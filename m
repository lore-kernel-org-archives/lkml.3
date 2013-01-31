Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3AaQXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:23:50 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50392 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3AaQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:23:13 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] HID: multitouch: make MT_CLS_ALWAYS_TRUE the new default class
Date: Thu, 31 Jan 2013 17:22:31 +0100
Message-Id: <1359649351-11092-10-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By running a test on all the traces of the devices I have,
I noticed that the class MT_CLS_ALWAYS_TRUE could handle all
the devices I've seen so far without any other quirks.
I guess this is the behavior Win 7 requires in its driver.

We can change the default class then and keep the existing classes
for backward compatibility and performances for some of them.

Two operations have been done:
 * replaced MT_CLS_DEFAULT by MT_CLS_NSMU
 * then replaced MT_CLS_ALWAYS_TRUE by MT_CLS_DEFAULT

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 54 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 68d511c..5490e70 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -114,7 +114,7 @@ struct mt_device {
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
 #define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
-#define MT_CLS_ALWAYS_TRUE			0x000a
+#define MT_CLS_NSMU				0x000a
 #define MT_CLS_DUAL_CONTACT_NUMBER		0x0010
 #define MT_CLS_DUAL_CONTACT_ID			0x0011
 
@@ -150,6 +150,9 @@ static int cypress_compute_slot(struct mt_device *td)
 
 static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE },
+	{ .name = MT_CLS_NSMU,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
 	{ .name = MT_CLS_SERIAL,
 		.quirks = MT_QUIRK_ALWAYS_VALID},
@@ -176,9 +179,6 @@ static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
-	{ .name = MT_CLS_ALWAYS_TRUE,
-		.quirks = MT_QUIRK_ALWAYS_VALID |
-			MT_QUIRK_CONTACT_CNT_ACCURATE },
 	{ .name = MT_CLS_DUAL_CONTACT_NUMBER,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
@@ -939,7 +939,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_ACTIONSTAR,
 			USB_DEVICE_ID_ACTIONSTAR_1011) },
 
@@ -952,7 +952,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
 
 	/* Baanto multitouch devices */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_BAANTO,
 			USB_DEVICE_ID_BAANTO_MT_190W2) },
 	/* Cando panels */
@@ -970,12 +970,12 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 
 	/* Chunghwa Telecom touch panels */
-	{  .driver_data = MT_CLS_DEFAULT,
+	{  .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
 			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 
 	/* CVTouch panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
 			USB_DEVICE_ID_CVTOUCH_SCREEN) },
 
@@ -1064,12 +1064,12 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS) },
 
 	/* Gametel game controller */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_BT_DEVICE(USB_VENDOR_ID_FRUCTEL,
 			USB_DEVICE_ID_GAMETEL_MT_MODE) },
 
 	/* GoodTouch panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
 			USB_DEVICE_ID_GOODTOUCH_000f) },
 
@@ -1087,7 +1087,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_IDEACOM_IDC6651) },
 
 	/* Ilitek dual touch panel */
-	{  .driver_data = MT_CLS_DEFAULT,
+	{  .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_ILITEK,
 			USB_DEVICE_ID_ILITEK_MULTITOUCH) },
 
@@ -1121,7 +1121,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 
 	/* Nexio panels */
-	{ .driver_data = MT_CLS_ALWAYS_TRUE,
+	{ .driver_data = MT_CLS_DEFAULT,
 		MT_USB_DEVICE(USB_VENDOR_ID_NEXIO,
 			USB_DEVICE_ID_NEXIO_MULTITOUCH_420)},
 
@@ -1134,7 +1134,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_PANABOARD_UBT880) },
 
 	/* Novatek Panel */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
 			USB_DEVICE_ID_NOVATEK_PCT) },
 
@@ -1180,7 +1180,7 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
 			USB_DEVICE_ID_MTP_STM)},
-	{ .driver_data = MT_CLS_ALWAYS_TRUE,
+	{ .driver_data = MT_CLS_DEFAULT,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
@@ -1190,48 +1190,48 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_TOPSEED2_PERIPAD_701) },
 
 	/* Touch International panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
 			USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
 
 	/* Unitec panels */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
 			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
 	/* XAT */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XAT,
 			USB_DEVICE_ID_XAT_CSR) },
 
 	/* Xiroku */
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX1) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX1) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR1) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_SPX2) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_MPX2) },
-	{ .driver_data = MT_CLS_DEFAULT,
+	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
 			USB_DEVICE_ID_XIROKU_CSR2) },
 
-- 
1.8.1

