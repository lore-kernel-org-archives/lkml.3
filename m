Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3AaQXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:23:15 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:37218 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3AaQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:23:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] HID: multitouch: fix protocol for Elo panels
Date: Thu, 31 Jan 2013 17:22:30 +0100
Message-Id: <1359649351-11092-9-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous protocol was nearly working, but when several fingers were
present on the sensor, those that were not moving were not updated
in the next report, introducing a lot of releases.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Conflicts:
	drivers/hid/hid-multitouch.c
---
 drivers/hid/hid-multitouch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f106e90..68d511c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -116,6 +116,7 @@ struct mt_device {
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
 #define MT_CLS_ALWAYS_TRUE			0x000a
 #define MT_CLS_DUAL_CONTACT_NUMBER		0x0010
+#define MT_CLS_DUAL_CONTACT_ID			0x0011
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -183,6 +184,11 @@ static struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
 		.maxcontacts = 2 },
+	{ .name = MT_CLS_DUAL_CONTACT_ID,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.maxcontacts = 2 },
 
 	/*
 	 * vendor specific classes
@@ -1040,7 +1046,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72C4) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */
-	{ .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
+	{ .driver_data = MT_CLS_DUAL_CONTACT_ID,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELO,
 			USB_DEVICE_ID_ELO_TS2515) },
 
-- 
1.8.1

