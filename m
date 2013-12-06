Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3LFNko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:40:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161620Ab3LFNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Forest Bond <forest.bond@rapidrollout.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 148/272] Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs
Date: Fri,  6 Dec 2013 12:57:17 +0000
Message-Id: <1386334761-25517-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit ae2aa3a512fa5f50f67feba9e66bc2efb394bd63 upstream.

The HID driver now handles these devices, regardless of what protocol
the device claims it supports.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/touchscreen/usbtouchscreen.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 721fdb3..ae4b6b9 100644
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
-- 
1.8.3.2

