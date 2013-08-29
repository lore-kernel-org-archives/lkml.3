Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3H2PRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:17:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3H2PRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:17:47 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, m.chehab@samsung.com,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/1] [media] uvcvideo: quirk PROBE_DEF for Dell SP2008WFP monitor.
Date: Thu, 29 Aug 2013 11:17:41 -0400
Message-Id: <efa845fedf7b2326c7fe6e82c4f90b15055c4a1c.1377781889.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1377781889.git.joseph.salisbury@canonical.com>
References: <cover.1377781889.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1217957

Add quirk for Dell SP2008WFP monitor: 05a9:2641

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Tested-by: Christopher Townsend <christopher.townsend@canonical.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com> 
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/media/usb/uvc/uvc_driver.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index ed123f4..8c1826c 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2174,6 +2174,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
+	/* Dell SP2008WFP Monitor */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05a9,
+	  .idProduct		= 0x2641,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
 	/* Dell Alienware X51 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.7.9.5

