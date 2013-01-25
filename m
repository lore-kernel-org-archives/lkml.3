Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3AYNYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:24:06 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45084 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab3AYNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/25] HID: multitouch: optimize Quanta panels
Date: Fri, 25 Jan 2013 14:22:56 +0100
Message-Id: <1359120190-18281-12-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not very different in terms of processing time. However, this
uniformizes the handling of devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0c62f90..8b07b6b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -119,6 +119,7 @@ struct mt_device {
 #define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
 #define MT_CLS_ALWAYS_TRUE			0x000a
+#define MT_CLS_CONTACT_ID			0x0011
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -181,6 +182,10 @@ static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_ALWAYS_TRUE,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_CONTACT_CNT_ACCURATE },
+	{ .name = MT_CLS_CONTACT_ID,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_SLOT_IS_CONTACTID },
 
 	/*
 	 * vendor specific classes
@@ -1157,7 +1162,7 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
 	/* Quanta-based panels */
-	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
+	{ .driver_data = MT_CLS_CONTACT_ID,
 		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ .driver_data = MT_CLS_CONFIDENCE_CONTACT_ID,
-- 
1.8.1

