Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3DXH4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:56:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab3DXH4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:56:51 -0400
From: adam.lee@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Matthew Garrett <mjg@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Adam Lee <adam.lee@canonical.com>,
        linux-media@vger.kernel.org (open list:USB VIDEO CLASS)
Subject: [PATCH] Revert "V4L/DVB: uvc: Enable USB autosuspend by default on uvcvideo"
Date: Wed, 24 Apr 2013 15:57:19 +0800
Message-Id: <1366790239-838-1-git-send-email-adam.lee@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Lee <adam.lee@canonical.com>

This reverts commit 3dae8b41dc5651f8eb22cf310e8b116480ba25b7.

1, I do have a Chicony webcam, implements autosuspend in a broken way,
make `poweroff` performs rebooting when its autosuspend enabled.

2, There are other webcams which don't support autosuspend too, like
https://patchwork.kernel.org/patch/2356141/

3, kernel removed USB_QUIRK_NO_AUTOSUSPEND in
a691efa9888e71232dfb4088fb8a8304ffc7b0f9, because autosuspend is
disabled by default.

So, we need to disable autosuspend in uvcvideo, maintaining a quirk list
only for uvcvideo is not a good idea.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/media/usb/uvc/uvc_driver.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5dbefa6..8556f7c 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1914,7 +1914,6 @@ static int uvc_probe(struct usb_interface *intf,
 	}
 
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
-	usb_enable_autosuspend(udev);
 	return 0;
 
 error:
-- 
1.7.10.4

