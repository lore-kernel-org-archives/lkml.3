Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab3CDEQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:16:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60821 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526Ab3CDDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:45 -0500
Message-Id: <20130304033721.420513463@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 141/153] usb: Add USB_QUIRK_RESET_RESUME for all Logitech UVC webcams
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit e387ef5c47ddeaeaa3cbdc54424cdb7a28dae2c0 upstream.

Most Logitech UVC webcams (both early models that don't advertise UVC
compatibility and newer UVC-advertised devices) require the RESET_RESUME
quirk. Instead of listing each and every model, match the devices based
on the UVC interface information.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Adjust context to apply after 3.2.38]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/quirks.c |   58 +++++++++++++--------------------------------
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
@@ -169,6 +139,10 @@ static const struct usb_device_id usb_qu
 };
 
 static const struct usb_device_id usb_interface_quirk_list[] = {
+	/* Logitech UVC Cameras */
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x046d, USB_CLASS_VIDEO, 1, 0),
+	  .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 



