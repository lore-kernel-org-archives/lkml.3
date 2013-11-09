Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab3KIHLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:11:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab3KIGwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.11 13/94] HID: wiimote: add LEGO-wiimote VID
Date: Fri,  8 Nov 2013 22:51:19 -0800
Message-Id: <20131109065205.188536445@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 86b84167d4e67372376a57ea9955c5d53dae232f upstream.

The LEGO-wiimote uses a different VID than the Nintendo ID. The device is
technically the same so add the ID.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c         |    1 +
 drivers/hid/hid-ids.h          |    1 +
 drivers/hid/hid-wiimote-core.c |    5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1827,6 +1827,7 @@ static const struct hid_device_id hid_ha
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO2, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE2) },
 	{ }
 };
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -633,6 +633,7 @@
 #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
 
 #define USB_VENDOR_ID_NINTENDO		0x057e
+#define USB_VENDOR_ID_NINTENDO2		0x054c
 #define USB_DEVICE_ID_NINTENDO_WIIMOTE	0x0306
 #define USB_DEVICE_ID_NINTENDO_WIIMOTE2	0x0330
 
--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -838,7 +838,8 @@ static void wiimote_init_set_type(struct
 		goto done;
 	}
 
-	if (vendor == USB_VENDOR_ID_NINTENDO) {
+	if (vendor == USB_VENDOR_ID_NINTENDO ||
+	    vendor == USB_VENDOR_ID_NINTENDO2) {
 		if (product == USB_DEVICE_ID_NINTENDO_WIIMOTE) {
 			devtype = WIIMOTE_DEV_GEN10;
 			goto done;
@@ -1860,6 +1861,8 @@ static void wiimote_hid_remove(struct hi
 static const struct hid_device_id wiimote_hid_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO,
 				USB_DEVICE_ID_NINTENDO_WIIMOTE) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO2,
+				USB_DEVICE_ID_NINTENDO_WIIMOTE) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO,
 				USB_DEVICE_ID_NINTENDO_WIIMOTE2) },
 	{ }


