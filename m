Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbaGOSr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964AbaGOSqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:46:09 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 22/23] Input - wacom: keep wacom_ids ordered
Date: Tue, 15 Jul 2014 14:45:45 -0400
Message-Id: <1405449946-11515-23-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No Functional changes, just some reordering.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
Tested-by: Jason Gerecke <killertofu@gmail.com>
---

changes in v2:
- fix 0x0307/0x307 and 0x0309/0x309

 drivers/input/tablet/wacom_wac.c | 79 ++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 66668b8..d62e320 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -2385,11 +2385,11 @@ static const struct wacom_features wacom_features_0x30E =
 static const struct wacom_features wacom_features_0x6004 =
 	{ "ISD-V4", 12800, 8000, 255, 0,
 	  TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
-static const struct wacom_features wacom_features_0x0307 =
+static const struct wacom_features wacom_features_0x307 =
 	{ "Wacom ISDv5 307", 59352, 33648, 2047, 63,
 	  CINTIQ_HYBRID, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, 200, 200,
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x309 };
-static const struct wacom_features wacom_features_0x0309 =
+static const struct wacom_features wacom_features_0x309 =
 	{ "Wacom ISDv5 309", .type = WACOM_24HDT, /* Touch */
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x0307, .touch_max = 10,
 	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
@@ -2404,6 +2404,7 @@ static const struct wacom_features wacom_features_0x0309 =
 
 const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x00) },
+	{ USB_DEVICE_WACOM(0x03) },
 	{ USB_DEVICE_WACOM(0x10) },
 	{ USB_DEVICE_WACOM(0x11) },
 	{ USB_DEVICE_WACOM(0x12) },
@@ -2414,20 +2415,16 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x17) },
 	{ USB_DEVICE_WACOM(0x18) },
 	{ USB_DEVICE_WACOM(0x19) },
-	{ USB_DEVICE_WACOM(0x60) },
-	{ USB_DEVICE_WACOM(0x61) },
-	{ USB_DEVICE_WACOM(0x62) },
-	{ USB_DEVICE_WACOM(0x63) },
-	{ USB_DEVICE_WACOM(0x64) },
-	{ USB_DEVICE_WACOM(0x65) },
-	{ USB_DEVICE_WACOM(0x69) },
-	{ USB_DEVICE_WACOM(0x6A) },
-	{ USB_DEVICE_WACOM(0x6B) },
 	{ USB_DEVICE_WACOM(0x20) },
 	{ USB_DEVICE_WACOM(0x21) },
 	{ USB_DEVICE_WACOM(0x22) },
 	{ USB_DEVICE_WACOM(0x23) },
 	{ USB_DEVICE_WACOM(0x24) },
+	{ USB_DEVICE_WACOM(0x26) },
+	{ USB_DEVICE_WACOM(0x27) },
+	{ USB_DEVICE_WACOM(0x28) },
+	{ USB_DEVICE_WACOM(0x29) },
+	{ USB_DEVICE_WACOM(0x2A) },
 	{ USB_DEVICE_WACOM(0x30) },
 	{ USB_DEVICE_WACOM(0x31) },
 	{ USB_DEVICE_WACOM(0x32) },
@@ -2437,20 +2434,33 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x37) },
 	{ USB_DEVICE_WACOM(0x38) },
 	{ USB_DEVICE_WACOM(0x39) },
-	{ USB_DEVICE_WACOM(0xC4) },
-	{ USB_DEVICE_WACOM(0xC0) },
-	{ USB_DEVICE_WACOM(0xC2) },
-	{ USB_DEVICE_WACOM(0x03) },
+	{ USB_DEVICE_WACOM(0x3F) },
 	{ USB_DEVICE_WACOM(0x41) },
 	{ USB_DEVICE_WACOM(0x42) },
 	{ USB_DEVICE_WACOM(0x43) },
 	{ USB_DEVICE_WACOM(0x44) },
 	{ USB_DEVICE_WACOM(0x45) },
+	{ USB_DEVICE_WACOM(0x47) },
 	{ USB_DEVICE_WACOM(0x57) },
 	{ USB_DEVICE_WACOM(0x59) },
-	{ USB_DEVICE_WACOM(0x5D) },
 	{ USB_DEVICE_WACOM(0x5B) },
+	{ USB_DEVICE_WACOM(0x5D) },
 	{ USB_DEVICE_WACOM(0x5E) },
+	{ USB_DEVICE_WACOM(0x60) },
+	{ USB_DEVICE_WACOM(0x61) },
+	{ USB_DEVICE_WACOM(0x62) },
+	{ USB_DEVICE_WACOM(0x63) },
+	{ USB_DEVICE_WACOM(0x64) },
+	{ USB_DEVICE_WACOM(0x65) },
+	{ USB_DEVICE_WACOM(0x69) },
+	{ USB_DEVICE_WACOM(0x6A) },
+	{ USB_DEVICE_WACOM(0x6B) },
+	{ USB_DEVICE_WACOM(0x84) },
+	{ USB_DEVICE_WACOM(0x90) },
+	{ USB_DEVICE_WACOM(0x93) },
+	{ USB_DEVICE_WACOM(0x97) },
+	{ USB_DEVICE_WACOM(0x9A) },
+	{ USB_DEVICE_WACOM(0x9F) },
 	{ USB_DEVICE_WACOM(0xB0) },
 	{ USB_DEVICE_WACOM(0xB1) },
 	{ USB_DEVICE_WACOM(0xB2) },
@@ -2463,17 +2473,14 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xBA) },
 	{ USB_DEVICE_WACOM(0xBB) },
 	{ USB_DEVICE_WACOM(0xBC) },
-	{ USB_DEVICE_WACOM(0x26) },
-	{ USB_DEVICE_WACOM(0x27) },
-	{ USB_DEVICE_WACOM(0x28) },
-	{ USB_DEVICE_WACOM(0x29) },
-	{ USB_DEVICE_WACOM(0x2A) },
-	{ USB_DEVICE_WACOM(0x3F) },
+	{ USB_DEVICE_WACOM(0xC0) },
+	{ USB_DEVICE_WACOM(0xC2) },
+	{ USB_DEVICE_WACOM(0xC4) },
 	{ USB_DEVICE_WACOM(0xC5) },
 	{ USB_DEVICE_WACOM(0xC6) },
 	{ USB_DEVICE_WACOM(0xC7) },
+	{ USB_DEVICE_WACOM(0xCC) },
 	{ USB_DEVICE_WACOM(0xCE) },
-	{ USB_DEVICE_WACOM(0x84) },
 	{ USB_DEVICE_WACOM(0xD0) },
 	{ USB_DEVICE_WACOM(0xD1) },
 	{ USB_DEVICE_WACOM(0xD2) },
@@ -2488,13 +2495,6 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xDD) },
 	{ USB_DEVICE_WACOM(0xDE) },
 	{ USB_DEVICE_WACOM(0xDF) },
-	{ USB_DEVICE_WACOM(0xF0) },
-	{ USB_DEVICE_WACOM(0xCC) },
-	{ USB_DEVICE_WACOM(0x90) },
-	{ USB_DEVICE_WACOM(0x93) },
-	{ USB_DEVICE_WACOM(0x97) },
-	{ USB_DEVICE_WACOM(0x9A) },
-	{ USB_DEVICE_WACOM(0x9F) },
 	{ USB_DEVICE_WACOM(0xE2) },
 	{ USB_DEVICE_WACOM(0xE3) },
 	{ USB_DEVICE_WACOM(0xE5) },
@@ -2502,6 +2502,12 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xEC) },
 	{ USB_DEVICE_WACOM(0xED) },
 	{ USB_DEVICE_WACOM(0xEF) },
+	{ USB_DEVICE_WACOM(0xF0) },
+	{ USB_DEVICE_WACOM(0xF4) },
+	{ USB_DEVICE_WACOM(0xF6) },
+	{ USB_DEVICE_WACOM(0xF8) },
+	{ USB_DEVICE_WACOM(0xFA) },
+	{ USB_DEVICE_WACOM(0xFB) },
 	{ USB_DEVICE_WACOM(0x100) },
 	{ USB_DEVICE_WACOM(0x101) },
 	{ USB_DEVICE_WACOM(0x10D) },
@@ -2512,8 +2518,10 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x301) },
 	{ USB_DEVICE_WACOM(0x302) },
 	{ USB_DEVICE_WACOM(0x303) },
-	{ USB_DEVICE_WACOM(0x30E) },
 	{ USB_DEVICE_WACOM(0x304) },
+	{ USB_DEVICE_WACOM(0x307) },
+	{ USB_DEVICE_WACOM(0x309) },
+	{ USB_DEVICE_WACOM(0x30E) },
 	{ USB_DEVICE_WACOM(0x314) },
 	{ USB_DEVICE_WACOM(0x315) },
 	{ USB_DEVICE_WACOM(0x317) },
@@ -2521,15 +2529,6 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },
 	{ USB_DEVICE_WACOM(0x5002) },
-	{ USB_DEVICE_WACOM(0x47) },
-	{ USB_DEVICE_WACOM(0xF4) },
-	{ USB_DEVICE_WACOM(0xF8) },
-	{ USB_DEVICE_WACOM(0xF6) },
-	{ USB_DEVICE_WACOM(0xFA) },
-	{ USB_DEVICE_WACOM(0xFB) },
-	{ USB_DEVICE_WACOM(0x0307) },
-	{ USB_DEVICE_WACOM(0x0309) },
-	{ USB_DEVICE_LENOVO(0x6004) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, wacom_ids);
-- 
2.0.0

