Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab3EOUjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:39:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3EOUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:39:02 -0400
From: joseph.salisbury@canonical.com
To: linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@redhat.com,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/1] [media] uvcvideo: quirk PROBE_DEF for Alienware X51 OmniVision webcam
Date: Wed, 15 May 2013 16:38:48 -0400
Message-Id: <1368650328-21128-1-git-send-email-joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Salisbury <joseph.salisbury@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/1180409

OminiVision webcam 0x05a9:0x2643 needs the same UVC_QUIRK_PROBE_DEF as other OmniVision models to work properly.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
---
 drivers/media/usb/uvc/uvc_driver.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5dbefa6..411682c 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2163,6 +2163,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
+ 	/* Alienware X51*/
+        { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                                | USB_DEVICE_ID_MATCH_INT_INFO,
+          .idVendor             = 0x05a9,
+          .idProduct            = 0x2643,
+          .bInterfaceClass      = USB_CLASS_VIDEO,
+          .bInterfaceSubClass   = 1,
+          .bInterfaceProtocol   = 0,
+          .driver_info          = UVC_QUIRK_PROBE_DEF },
 	/* Apple Built-In iSight */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.7.9.5

