Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab3LBUpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:45:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3LBTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Forest Bond <forest.bond@rapidrollout.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 123/173] Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs
Date: Mon,  2 Dec 2013 11:11:46 -0800
Message-Id: <20131202191157.744551617@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit ae2aa3a512fa5f50f67feba9e66bc2efb394bd63 upstream.

The HID driver now handles these devices, regardless of what protocol
the device claims it supports.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/usbtouchscreen.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -146,12 +146,10 @@ enum {
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
 	.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS \
-		| USB_DEVICE_ID_MATCH_INT_PROTOCOL \
 		| USB_DEVICE_ID_MATCH_DEVICE, \
 	.idVendor = (vend), \
 	.idProduct = (prod), \
-	.bInterfaceClass = USB_INTERFACE_CLASS_HID, \
-	.bInterfaceProtocol = USB_INTERFACE_PROTOCOL_MOUSE
+	.bInterfaceClass = USB_INTERFACE_CLASS_HID
 
 static const struct usb_device_id usbtouch_devices[] = {
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX


