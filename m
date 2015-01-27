Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbbA0MSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbbA0MSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= 
	<giedrius.statkevicius@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 051/126] HID: Add a new id 0x501a for Genius MousePen i608X
Date: Tue, 27 Jan 2015 12:15:56 +0000
Message-Id: <1422361031-19364-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?=

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c          | 1 +
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/hid-kye.c           | 4 ++++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 4 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8ed66fd1ea87..85f70c62b3ab 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1793,6 +1793,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_I405X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ab9d3da01930..1bda12b7af69 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -523,6 +523,7 @@
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
 #define USB_DEVICE_ID_KYE_MOUSEPEN_I608X	0x5011
+#define USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2	0x501a
 #define USB_DEVICE_ID_KYE_EASYPEN_M610X	0x5013
 
 #define USB_VENDOR_ID_LABTEC		0x1020
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index b92bf01a1ae8..158fcf577fae 100644
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
@@ -446,6 +448,8 @@ static const struct hid_device_id kye_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
+				USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_KYE_EASYPEN_M610X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 7f16acb84f90..f10dffa795cd 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -123,6 +123,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_SIGMA_MICRO, USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X, HID_QUIRK_MULTI_INPUT },
+	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_2, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_DUOSENSE, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD, HID_QUIRK_NO_INIT_REPORTS },
-- 
2.1.4

