Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3F3TFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 15:05:17 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:60580 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3F3TFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 15:05:15 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlB1ALeA0FFV5qu1PGdsb2JhbABagwmDGYUjt08EAX0XAwEBAQE4NYIkAQVWEwEPEAhJIRgKFAYBEod9AxOyGA2IUhaMX4FMgR0Hg2cDlWGIF4VwiDg6
X-IronPort-AV: E=Sophos;i="4.87,969,1363129200"; 
   d="scan'208";a="574688860"
From: rydberg@euromail.se
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, stable@vger.kernel.org
Subject: [PATCH 1/2] HID: apple: Add support for the 2013 Macbook Air
Date: Sun, 30 Jun 2013 21:04:45 +0200
Message-Id: <1372619086-3532-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372619086-3532-1-git-send-email-rydberg@euromail.se>
References: <1372619086-3532-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds keyboard support for MacbookAir6,2 as WELLSPRING8
(0x0291, 0x0292, 0x0293). The touchpad is handled in a separate
bcm5974 patch, as usual.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Brad Ford <plymouthffl@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-apple.c | 6 ++++++
 drivers/hid/hid-core.c  | 6 ++++++
 drivers/hid/hid-ids.h   | 3 +++
 3 files changed, 15 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index feae88b..c7710b5 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -524,6 +524,12 @@ static const struct hid_device_id apple_devices[] = {
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 264f550..402f486 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1547,6 +1547,9 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_JIS) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
@@ -2179,6 +2182,9 @@ static const struct hid_device_id hid_mouse_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING8_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 38535c9..2168885 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -135,6 +135,9 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI  0x0255
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL	0x8240
-- 
1.8.3.1

