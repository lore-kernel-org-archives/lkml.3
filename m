Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3KTXBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:01:21 -0500
Received: from pavo.uberspace.de ([95.143.172.191]:57133 "HELO
	pavo.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754265Ab3KTXBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:01:16 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 18:01:16 EST
From: =?UTF-8?q?Friedrich=20Sch=C3=B6ller?= <linux@schoeller.se>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Friedrich=20Sch=C3=B6ller?= <linux@schoeller.se>
Subject: [PATCH 1/3] Input: Fixed ABS_MT_TOUCH_MINOR scale factor in BCM5974 multitouch driver
Date: Wed, 20 Nov 2013 23:54:10 +0100
Message-Id: <1384988052-31898-1-git-send-email-linux@schoeller.se>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wellspring3 devices ABS_MT_TOUCH_MINOR was sometimes reported bigger than
ABS_MT_TOUCH_MAJOR. This is fixed by rescaling ABS_MT_TOUCH_MINOR by a factor of
0.85 instead of 2. Excessive tapping on the trackpad shows this to be the right
value. Circular touches should now lead to values for ABS_MT_TOUCH_MAJOR and
ABS_MT_TOUCH_MINOR that are similar, with ABS_MT_TOUCH_MINOR never greater than
ABS_MT_TOUCH_MAJOR.
---
 drivers/input/mouse/bcm5974.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index a73f961..af15410 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -235,6 +235,7 @@ struct bcm5974_config {
 	enum tp_type tp_type;	/* type of trackpad interface */
 	int tp_offset;		/* offset to trackpad finger data */
 	int tp_datalen;		/* data length of the trackpad interface */
+	float touch_minor_f;	/* factor for ABS_MT_TOUCH_MINOR */
 	struct bcm5974_param p;	/* finger pressure limits */
 	struct bcm5974_param w;	/* finger width limits */
 	struct bcm5974_param x;	/* horizontal limits */
@@ -275,6 +276,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		0,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE1, FINGER_TYPE1, FINGER_TYPE1 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 256 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4824, 5342 },
@@ -288,6 +290,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		0,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE1, FINGER_TYPE1, FINGER_TYPE1 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 256 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4824, 4824 },
@@ -301,6 +304,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		0.85,
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4460, 5166 },
@@ -314,6 +318,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
@@ -327,6 +332,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4616, 5112 },
@@ -340,6 +346,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4415, 5050 },
@@ -353,6 +360,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
@@ -366,6 +374,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4750, 5280 },
@@ -379,6 +388,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
@@ -392,6 +402,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4750, 5280 },
@@ -405,6 +416,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4750, 5280 },
@@ -418,6 +430,7 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0, sizeof(struct bt_data),
 		0x83, TYPE3, FINGER_TYPE3, FINGER_TYPE3 + SIZEOF_ALL_FINGERS,
+		2, /* verify me! */
 		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
@@ -502,7 +515,8 @@ static int report_bt_state(struct bcm5974 *dev, int size)
 	return 0;
 }
 
-static void report_finger_data(struct input_dev *input, int slot,
+static void report_finger_data(struct input_dev *input,
+			       const struct bcm5974_config *cfg, int slot,
 			       const struct input_mt_pos *pos,
 			       const struct tp_finger *f)
 {
@@ -512,7 +526,7 @@ static void report_finger_data(struct input_dev *input, int slot,
 	input_report_abs(input, ABS_MT_TOUCH_MAJOR,
 			 raw2int(f->touch_major) << 1);
 	input_report_abs(input, ABS_MT_TOUCH_MINOR,
-			 raw2int(f->touch_minor) << 1);
+			 raw2int(f->touch_minor) * cfg->touch_minor_f);
 	input_report_abs(input, ABS_MT_WIDTH_MAJOR,
 			 raw2int(f->tool_major) << 1);
 	input_report_abs(input, ABS_MT_WIDTH_MINOR,
@@ -568,7 +582,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	input_mt_assign_slots(input, dev->slots, dev->pos, n);
 
 	for (i = 0; i < n; i++)
-		report_finger_data(input, dev->slots[i],
+		report_finger_data(input, c, dev->slots[i],
 				   &dev->pos[i], dev->index[i]);
 
 	input_mt_sync_frame(input);
-- 
1.8.4.2

