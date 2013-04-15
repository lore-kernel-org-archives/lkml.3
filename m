Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733Ab3DOTB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:01:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab3DOTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:01:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH] [media] uvcvideo: quirk PROBE_DEF for Dell Studio / OmniVision webcam
Date: Mon, 15 Apr 2013 12:01:51 -0700
Message-Id: <1366052511-27284-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: https://bugs.launchpad.net/bugs/1168430

OminiVision webcam 0x05a9:0x264a (in Dell Studio Hybrid 140g) needs the
same UVC_QUIRK_PROBE_DEF as other OmniVision model to be recognized
consistently.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/uvc/uvc_driver.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5dbefa6..17bd48d 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2163,6 +2163,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
+	/* Dell Studio Hybrid 140g (OmniVision webcam) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05a9,
+	  .idProduct		= 0x264a,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_DEF },
 	/* Apple Built-In iSight */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.7.10.4

