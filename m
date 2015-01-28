Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbbA2JfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:35:06 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44862 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759895AbbA2JGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= 
	<giedrius.statkevicius@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/176] HID: Add a new id 0x501a for Genius MousePen i608X
Date: Wed, 28 Jan 2015 15:27:34 +0100
Message-Id: <6bbd1764b520f02cb69a86b03b4c3084a27339b7.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2bacedada682d5485424f5227f27a3d5d6eb551c upstream.

New Genius MousePen i608X devices have a new id 0x501a instead of the
old 0x5011 so add a new #define with "_2" appended and change required
places.

The remaining two checkpatch warnings about line length
being over 80 characters are present in the original files too and this
patch was made in the same style (no line break).

Just adding a new id and changing the required places should make the
new device work without any issues according to the bug report in the
following url.

This patch was made according to and fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=67111

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-core.c          | 1 +
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/hid-kye.c           | 4 ++++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 4 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 245f8922f813..62d73264b3e2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1743,6 +1743,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_I405X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 28f6cdc5aaf9..60348ec399fc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -501,6 +501,7 @@
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
 #define USB_DEVICE_ID_KYE_MOUSEPEN_I608X	0x5011
+#define USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2	0x501a
 #define USB_DEVICE_ID_KYE_EASYPEN_M610X	0x5013
 
 #define USB_VENDOR_ID_LABTEC		0x1020
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 8a3552cf3904..a4beb9917b52 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -323,6 +323,7 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		}
 		break;
 	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X:
+	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2:
 		if (*rsize == MOUSEPEN_I608X_RDESC_ORIG_SIZE) {
 			rdesc = mousepen_i608x_rdesc_fixed;
 			*rsize = sizeof(mousepen_i608x_rdesc_fixed);
@@ -415,6 +416,7 @@ static int kye_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	switch (id->product) {
 	case USB_DEVICE_ID_KYE_EASYPEN_I405X:
 	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X:
+	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2:
 	case USB_DEVICE_ID_KYE_EASYPEN_M610X:
 		ret = kye_tablet_enable(hdev);
 		if (ret) {
@@ -438,6 +440,8 @@ static const struct hid_device_id kye_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
+				USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_KYE_EASYPEN_M610X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 19b5fc350354..3554496bacf8 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -119,6 +119,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD, HID_QUIRK_NO_INIT_REPORTS },
-- 
2.2.2

