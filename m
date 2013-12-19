Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3LSMCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:02:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3LSMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 203/208] HID: kye: Add report fixup for Genius Manticore Keyboard
Date: Thu, 19 Dec 2013 11:55:01 +0000
Message-Id: <1387454106-19326-204-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 4a2c94c9b6c03af61b04993340bd9559e2277de4 upstream.

Genius Manticore Keyboard presents the same problem in its report
descriptors than Genius Gila Gaming Mouse and Genius Imperator Keyboard.
Use the same fixup.

Reported-and-tested-by: Adam Kulagowski <fidor@fidor.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 1 +
 drivers/hid/hid-ids.h  | 1 +
 drivers/hid/hid-kye.c  | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d22cc95..016aab4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1682,6 +1682,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KEYTOUCH, USB_DEVICE_ID_KEYTOUCH_IEC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_MANTICORE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_I405X) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b4e3716..7c85918 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -489,6 +489,7 @@
 #define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
 #define USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE	0x0138
+#define USB_DEVICE_ID_GENIUS_MANTICORE	0x0153
 #define USB_DEVICE_ID_GENIUS_GX_IMPERATOR	0x4018
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 7384512..35a4f9c 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -341,6 +341,9 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 					"Genius Gx Imperator Keyboard");
+	case USB_DEVICE_ID_GENIUS_MANTICORE:
+		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
+					"Genius Manticore Keyboard");
 		break;
 	}
 	return rdesc;
@@ -439,6 +442,8 @@ static const struct hid_device_id kye_devices[] = {
 				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
 				USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
+				USB_DEVICE_ID_GENIUS_MANTICORE) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, kye_devices);
-- 
1.8.3.2

