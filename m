Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbaLLGzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:55:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51763 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758770AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        "Paul Fertser" <fercerpav@gmail.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.530829071@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 011/164] [media] media: usb: uvc: add a quirk for Dell
 XPS M1330 webcam
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Fertser <fercerpav@gmail.com>

commit 62ea864f84fed6e04dd033d500d4c9183a83d590 upstream.

As reported on [1], this device needs this quirk to be able to
reliably initialise the webcam.

[1] http://ubuntuforums.org/showthread.php?t=2145996

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2126,6 +2126,15 @@ static struct usb_device_id uvc_ids[] =
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_PROBE_MINMAX },
+	/* Dell XPS M1330 (OmniVision OV7670 webcam) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05a9,
+	  .idProduct		= 0x7670,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_PROBE_DEF },
 	/* Apple Built-In iSight */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,

