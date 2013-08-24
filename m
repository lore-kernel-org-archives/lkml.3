Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3HXOS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 10:18:57 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37047 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3HXOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 10:18:55 -0400
From: Ian Munsie <darkstarsword@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Munsie <darkstarsword@gmail.com>
Subject: [PATCH 2/2] Input: bcm5974: Add another device ID for the mid-2013 Macbook Air
Date: Sun, 25 Aug 2013 00:17:53 +1000
Message-Id: <1377353873-17000-3-git-send-email-darkstarsword@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
References: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a device ID found for mid-2013 Macbook Air 6,1 from
lsusb:

Bus 001 Device 003: ID 05ac:0290 Apple, Inc.

Since IDs already exist for this generation Macbook air as WELLSPRING8,
name this one WELLSPRING8A. This only adds an ANSI version since it's
device ID is only one less than the existing WELLSPRING8 IDs.

Signed-off-by: Ian Munsie <darkstarsword@gmail.com>
---
 drivers/input/mouse/bcm5974.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 4ef4d5e..fcd2f3f 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -88,6 +88,8 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI	0x0259
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO	0x025a
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS	0x025b
+/* MacbookAir6,1 (unibody, June 2013) */
+#define USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI	0x0290
 /* MacbookAir6,2 (unibody, June 2013) */
 #define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
 #define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
@@ -149,6 +151,8 @@ static const struct usb_device_id bcm5974_table[] = {
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS),
+	/* MacbookAir6,1 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI),
 	/* MacbookAir6,2 */
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_ISO),
@@ -424,6 +428,19 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		{ SN_COORD, -150, 6600 },
 		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING8A_ANSI,
+		0,
+		0,
+		HAS_INTEGRATED_BUTTON,
+		0, sizeof(struct bt_data),
+		0x83, TYPE3, FINGER_TYPE3, FINGER_TYPE3 + SIZEOF_ALL_FINGERS,
+		{ SN_PRESSURE, 0, 300 },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4620, 5140 },
+		{ SN_COORD, -150, 6600 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
+	},
 	{}
 };
 
-- 
1.8.4.rc3

