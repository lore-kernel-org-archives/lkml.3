Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3AYN1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:27:20 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50617 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3AYNYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:24:01 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/25] HID: multitouch: optimize Elo panels
Date: Fri, 25 Jan 2013 14:22:59 +0100
Message-Id: <1359120190-18281-15-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on ALWAYS_VALID enhance a little the processing time of
the events.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index bc680b5..77f34ad 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -121,6 +121,7 @@ struct mt_device {
 #define MT_CLS_ALWAYS_TRUE			0x000a
 #define MT_CLS_CONTACT_ID			0x0011
 #define MT_CLS_MINUS_ONE			0x0012
+#define MT_CLS_DUAL_CONTACT_ID			0x0013
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -191,6 +192,11 @@ static struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE },
+	{ .name = MT_CLS_DUAL_CONTACT_ID,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.maxcontacts = 2 },
 
 	/*
 	 * vendor specific classes
@@ -1050,7 +1056,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72C4) },
 
 	/* Elo TouchSystems IntelliTouch Plus panel */
-	{ .driver_data = MT_CLS_DUAL_NSMU_CONTACTID,
+	{ .driver_data = MT_CLS_DUAL_CONTACT_ID,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELO,
 			USB_DEVICE_ID_ELO_TS2515) },
 
-- 
1.8.1

