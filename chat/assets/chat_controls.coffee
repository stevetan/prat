class window.ChatControls
  constructor: (@messageHub, @channelViewCollection, leftClosed, rightClosed) ->
    @init(leftClosed, rightClosed)

  init: (leftSidebarClosed, rightSidebarClosed) ->
    rightToggle = if rightSidebarClosed then @onExpandRightSidebar else @onCollapseRightSidebar
    leftToggle = if leftSidebarClosed then @onExpandLeftSidebar else @onCollapseLeftSidebar
    $(".toggle-right-sidebar").one("click", rightToggle)
    $(".toggle-left-sidebar").one("click", leftToggle)
    $(".chat-text").on("keydown.ctrl_return", @onChatSubmit)
    unless localStorage.quickSend?
      localStorage.quickSend = "true"
    @quickSendButton = $("#quicksend")
    if localStorage.quickSend == "true" then @quickSendOn() else @quickSendOff()
    @messageHub.on("force_refresh", @refreshPage)
    $(".chat-submit").click(@onChatSubmit)
    $(".chat-preview").click(@onPreviewSubmit)
    $(".chat-edit").click(@onEditSubmit)

  onPreviewSubmit: (event) =>
    message = $(".chat-text").val()
    if message.replace(/\s*$/, "") isnt ""
      @messageHub.sendPreview(message, @channelViewCollection.currentChannel)

    $(".preview-wrapper").show()
    $(".chat-preview").hide()
    $(".chat-edit").show()
    $(".chat-text-wrapper").hide()

  onEditSubmit: (event) =>
    $(".preview-wrapper").hide()
    $(".chat-preview").show()
    $(".chat-edit").hide()
    $(".chat-text-wrapper").show()

  onChatSubmit: (event) =>
    message = $(".chat-text").val()
    if message.replace(/\s*$/, "") isnt ""
      @messageHub.sendChat(message, @channelViewCollection.currentChannel)
    $(".chat-text").val("").focus()
    event.preventDefault()

  onExpandRightSidebar: (event) =>
    rightSidebarButton = $(".toggle-right-sidebar")
    rightSidebarButton.find(".ss-icon").html("right")
    $(".right-sidebar").removeClass("closed")
    $(".chat-column").removeClass("collapse-right")
    rightSidebarButton.one("click", @onCollapseRightSidebar)
    document.cookie = "rightSidebar=open"

  onCollapseRightSidebar: (event) =>
    rightSidebarButton = $(".toggle-right-sidebar")
    rightSidebarButton.find(".ss-icon").html("left")
    $(".right-sidebar").addClass("closed")
    $(".chat-column").addClass("collapse-right")
    rightSidebarButton.one("click", @onExpandRightSidebar)
    document.cookie = "rightSidebar=closed"

  onExpandLeftSidebar: (event) =>
    leftSidebarButton = $(".toggle-left-sidebar")
    leftSidebarButton.find(".ss-icon").html("left")
    $(".left-sidebar").removeClass("closed")
    $(".main-content").removeClass("collapse-left")
    leftSidebarButton.one("click", @onCollapseLeftSidebar)
    document.cookie = "leftSidebar=open"

  onCollapseLeftSidebar: (event) =>
    leftSidebarButton = $(".toggle-left-sidebar")
    leftSidebarButton.find(".ss-icon").html("right")
    $(".left-sidebar").addClass("closed")
    $(".main-content").addClass("collapse-left")
    leftSidebarButton.one("click", @onExpandLeftSidebar)
    document.cookie = "leftSidebar=closed"

  quickSendOn: =>
    @quickSendButton.addClass("active")
                    .one("click", @quickSendOff)
                    .attr("title", "Turn quick send off")
                    .trigger("mouseleave") # refresh tipsy
                    .trigger("mouseenter")
    localStorage.quickSend = "true"
    $(".chat-text").on("keydown.return", @onChatSubmit)
    @quickSendButton

  quickSendOff: =>
    @quickSendButton.removeClass("active")
                    .one("click", @quickSendOn)
                    .attr("title", "Turn quick send on")
                    .trigger("mouseleave") # refresh tipsy
                    .trigger("mouseenter")
    localStorage.quickSend = "false"
    $(".chat-text").off("keydown.return", @onChatSubmit)
