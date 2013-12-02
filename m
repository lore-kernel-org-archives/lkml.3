Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3LBUlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:41:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3LBTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luosong <android@generaltouch.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 127/173] HID: multitouch: Fix GeneralTouch products and add more PIDs
Date: Mon,  2 Dec 2013 11:11:50 -0800
Message-Id: <20131202191158.086686103@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luosong <android@generaltouch.com>

commit 7b2262920db2b98fe2cd32cde52141f02fd9eecf upstream.

GeneralTouch products should use the quirk SLOT_IS_CONTACTID
instead of SLOT_IS_CONTACTNUMBER.

Adding PIDs 0101,e100,0102,0106,010a from the new products.

Tested on new and older products by GeneralTouch engineers.

Signed-off-by: Luosong <android@generaltouch.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ids.h        |    5 +++++
 drivers/hid/hid-multitouch.c |   19 +++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -330,6 +330,11 @@
 #define USB_VENDOR_ID_GENERAL_TOUCH	0x0dfc
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS 0x0003
 #define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS 0x0100
+#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_0101 0x0101
+#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_0102 0x0102
+#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_0106 0x0106
+#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_010A 0x010a
+#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100 0xe100
 
 #define USB_VENDOR_ID_GLAB		0x06c2
 #define USB_DEVICE_ID_4_PHIDGETSERVO_30	0x0038
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -244,12 +244,12 @@ static struct mt_class mt_classes[] = {
 	{ .name	= MT_CLS_GENERALTOUCH_TWOFINGERS,
 		.quirks	= MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_VALID_IS_INRANGE |
-			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
+			MT_QUIRK_SLOT_IS_CONTACTID,
 		.maxcontacts = 2
 	},
 	{ .name	= MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
 		.quirks	= MT_QUIRK_NOT_SEEN_MEANS_UP |
-			MT_QUIRK_SLOT_IS_CONTACTNUMBER
+			MT_QUIRK_SLOT_IS_CONTACTID
 	},
 
 	{ .name = MT_CLS_FLATFROG,
@@ -1191,6 +1191,21 @@ static const struct hid_device_id mt_dev
 	{ .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
 		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS) },
+	{ .driver_data = MT_CLS_GENERALTOUCH_TWOFINGERS,
+		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_0101) },
+	{ .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
+		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_0102) },
+	{ .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
+		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_0106) },
+	{ .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
+		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_010A) },
+	{ .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
+		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
+			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PIT_E100) },
 
 	/* Gametel game controller */
 	{ .driver_data = MT_CLS_NSMU,


