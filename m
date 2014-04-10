Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487AbaDJEQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:16:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934694AbaDJDWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 049/134] usb: Add USB_QUIRK_RESET_RESUME for all Logitech UVC webcams
Date: Wed,  9 Apr 2014 20:22:45 -0700
Message-Id: <20140410032306.388810029@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit e387ef5c47ddeaeaa3cbdc54424cdb7a28dae2c0 upstream.

Most Logitech UVC webcams (both early models that don't advertise UVC
compatibility and newer UVC-advertised devices) require the RESET_RESUME
quirk. Instead of listing each and every model, match the devices based
on the UVC interface information.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
[bwh: Adjust context to apply after 3.2.38]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |   58 ++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 42 deletions(-)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -46,53 +46,23 @@ static const struct usb_device_id usb_qu
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech Webcam C200 */
-	{ USB_DEVICE(0x046d, 0x0802), .driver_info = USB_QUIRK_RESET_RESUME },
+	/* Logitech Quickcam Fusion */
+	{ USB_DEVICE(0x046d, 0x08c1), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech Webcam C250 */
-	{ USB_DEVICE(0x046d, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
+	/* Logitech Quickcam Orbit MP */
+	{ USB_DEVICE(0x046d, 0x08c2), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech Webcam C300 */
-	{ USB_DEVICE(0x046d, 0x0805), .driver_info = USB_QUIRK_RESET_RESUME },
+	/* Logitech Quickcam Pro for Notebook */
+	{ USB_DEVICE(0x046d, 0x08c3), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech Webcam B/C500 */
-	{ USB_DEVICE(0x046d, 0x0807), .driver_info = USB_QUIRK_RESET_RESUME },
+	/* Logitech Quickcam Pro 5000 */
+	{ USB_DEVICE(0x046d, 0x08c5), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech Webcam C600 */
-	{ USB_DEVICE(0x046d, 0x0808), .driver_info = USB_QUIRK_RESET_RESUME },
+	/* Logitech Quickcam OEM Dell Notebook */
+	{ USB_DEVICE(0x046d, 0x08c6), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech Webcam Pro 9000 */
-	{ USB_DEVICE(0x046d, 0x0809), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C905 */
-	{ USB_DEVICE(0x046d, 0x080a), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C210 */
-	{ USB_DEVICE(0x046d, 0x0819), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C260 */
-	{ USB_DEVICE(0x046d, 0x081a), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C310 */
-	{ USB_DEVICE(0x046d, 0x081b), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C910 */
-	{ USB_DEVICE(0x046d, 0x0821), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C160 */
-	{ USB_DEVICE(0x046d, 0x0824), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Webcam C270 */
-	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Quickcam Pro 9000 */
-	{ USB_DEVICE(0x046d, 0x0990), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Quickcam E3500 */
-	{ USB_DEVICE(0x046d, 0x09a4), .driver_info = USB_QUIRK_RESET_RESUME },
-
-	/* Logitech Quickcam Vision Pro */
-	{ USB_DEVICE(0x046d, 0x09a6), .driver_info = USB_QUIRK_RESET_RESUME },
+	/* Logitech Quickcam OEM Cisco VT Camera II */
+	{ USB_DEVICE(0x046d, 0x08c7), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	/* Logitech Harmony 700-series */
 	{ USB_DEVICE(0x046d, 0xc122), .driver_info = USB_QUIRK_DELAY_INIT },
@@ -184,6 +154,10 @@ static const struct usb_device_id usb_qu
 };
 
 static const struct usb_device_id usb_interface_quirk_list[] = {
+	/* Logitech UVC Cameras */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x046d, USB_CLASS_VIDEO, 1, 0),
+	  .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 


