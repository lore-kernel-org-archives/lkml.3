Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3HXOSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 10:18:49 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47087 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3HXOSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 10:18:47 -0400
From: Ian Munsie <darkstarsword@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Munsie <darkstarsword@gmail.com>
Subject: [PATCH 1/2] HID: apple: Add another device ID for the mid-2013 Macbook Air
Date: Sun, 25 Aug 2013 00:17:52 +1000
Message-Id: <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
References: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a device ID found for mid-2013 Macbook Air 6,1 from
lsusb:

Bus 001 Device 003: ID 05ac:0290 Apple, Inc.

Since IDs already exist for this generation Macbook air as WELLSPRING8,
name this one WELLSPRING8A. This only adds an ANSI version since it's
device ID is only one less than the existing WELLSPRING8 IDs.

Signed-off-by: Ian Munsie <darkstarsword@gmail.com>
---
 drivers/hid/hid-apple.c | 2 ++
 drivers/hid/hid-core.c  | 2 ++
 drivers/hid/hid-ids.h   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index c7710b5..9e5e9dd 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -530,6 +530,8 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI),
+		.driver_data = APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 36668d1..5ebcfac 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1550,6 +1550,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
@@ -2195,6 +2196,7 @@ static const struct hid_device_id hid_mouse_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ffe4c7a..442a877 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -135,6 +135,7 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI  0x0255
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
+#define USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI	0x0290
 #define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
 #define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
 #define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
-- 
1.8.4.rc3

