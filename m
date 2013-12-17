Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3LQSal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:30:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3LQSPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Forest Bond <forest.bond@rapidrollout.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 058/103] HID: hid-multitouch: add support for SiS panels
Date: Tue, 17 Dec 2013 18:12:47 +0000
Message-Id: <1387304012-23805-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit a6802e008e19845fd9669511b895f7515ef9c48b upstream.

Add support for SiS multitouch panels.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/Kconfig             | 1 +
 drivers/hid/hid-core.c          | 2 ++
 drivers/hid/hid-ids.h           | 4 ++++
 drivers/hid/hid-multitouch.c    | 8 ++++++++
 drivers/hid/usbhid/hid-quirks.c | 2 ++
 5 files changed, 17 insertions(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3fda8c8..78935b8 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -381,6 +381,7 @@ config HID_MULTITOUCH
 	  - Pixcir dual touch panels
 	  - Quanta panels
 	  - eGalax dual-touch panels, including the Joojoo and Wetab tablets
+	  - SiS multitouch panels
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index adca1b0..509d119 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1709,6 +1709,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0e59c28..84f9695 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -689,6 +689,10 @@
 #define USB_VENDOR_ID_SIGMATEL		0x066F
 #define USB_DEVICE_ID_SIGMATEL_STMP3780	0x3780
 
+#define USB_VENDOR_ID_SIS2_TOUCH	0x0457
+#define USB_DEVICE_ID_SIS9200_TOUCH	0x9200
+#define USB_DEVICE_ID_SIS817_TOUCH	0x0817
+
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fa3c904..e3c3e52 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1004,6 +1004,14 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
 
+	/* SiS panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS817_TOUCH) },
+
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM,
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index bb09319..d577fa8 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -83,6 +83,8 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_REALTEK, USB_DEVICE_ID_REALTEK_READER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SIGMATEL, USB_DEVICE_ID_SIGMATEL_STMP3780, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_2, HID_QUIRK_NOGET },
-- 
1.8.3.2

