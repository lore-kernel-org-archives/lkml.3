Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3JBJU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab3JBJUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:20:23 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Luosong <android@generaltouch.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: multitouch: Fix GeneralTouch products and add more PIDs
Date: Wed,  2 Oct 2013 11:20:00 +0200
Message-Id: <1380705600-11055-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luosong <android@generaltouch.com>

GeneralTouch products should use the quirk SLOT_IS_CONTACTID
instead of SLOT_IS_CONTACTNUMBER.

Adding PIDs 0101,e100,0102,0106,010a from the new products.

Tested on new and older products by GeneralTouch engineers.

Signed-off-by: Luosong <android@generaltouch.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Luosong,

I took the liberty to rewrite the commit message for it to be
more compliant with the kernel rules:
- there should be a one line title commit message first,
- and the rest should detail the patch, tell how it was tested, etc...

If you could just give our ack on this one, Jiri would be able to take it
through his tree.

Cheers,
Benjamin

 drivers/hid/hid-ids.h        |  5 +++++
 drivers/hid/hid-multitouch.c | 19 +++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e60e8d5..9a91dee 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -332,6 +332,11 @@
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
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5e5fe1b..cb3250c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -250,12 +250,12 @@ static struct mt_class mt_classes[] = {
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
@@ -1173,6 +1173,21 @@ static const struct hid_device_id mt_devices[] = {
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
-- 
1.8.3.1

