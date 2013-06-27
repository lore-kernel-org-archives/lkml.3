Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3F0NBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:01:53 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461Ab3F0Muo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:44 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 24/51] Input: atmel_mxt_ts - Rename touchscreen defines to include T9
Date: Thu, 27 Jun 2013 13:48:59 +0100
Message-Id: <1372337366-9286-25-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids confusion with the newer T100 touchscreen object.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   46 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 8ccc809de..5a16383 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -111,13 +111,23 @@ struct t7_config {
 #define MXT_T9_ORIENT		9
 #define MXT_T9_RANGE		18
 
+/* MXT_TOUCH_MULTI_T9 status */
+#define MXT_T9_UNGRIP		(1 << 0)
+#define MXT_T9_SUPPRESS		(1 << 1)
+#define MXT_T9_AMP		(1 << 2)
+#define MXT_T9_VECTOR		(1 << 3)
+#define MXT_T9_MOVE		(1 << 4)
+#define MXT_T9_RELEASE		(1 << 5)
+#define MXT_T9_PRESS		(1 << 6)
+#define MXT_T9_DETECT		(1 << 7)
+
 struct t9_range {
 	u16 x;
 	u16 y;
 } __packed;
 
-/* Touch orient bits */
-#define MXT_XY_SWITCH		(1 << 0)
+/* MXT_TOUCH_MULTI_T9 orient */
+#define MXT_T9_ORIENT_SWITCH	(1 << 0)
 
 /* MXT_PROCI_GRIPFACE_T20 field */
 #define MXT_GRIPFACE_CTRL	0
@@ -192,16 +202,6 @@ struct t9_range {
 #define MXT_BOOT_EXTENDED_ID	(1 << 5)
 #define MXT_BOOT_ID_MASK	0x1f
 
-/* Touch status */
-#define MXT_UNGRIP		(1 << 0)
-#define MXT_SUPPRESS		(1 << 1)
-#define MXT_AMP			(1 << 2)
-#define MXT_VECTOR		(1 << 3)
-#define MXT_MOVE		(1 << 4)
-#define MXT_RELEASE		(1 << 5)
-#define MXT_PRESS		(1 << 6)
-#define MXT_DETECT		(1 << 7)
-
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
@@ -656,21 +656,21 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	dev_dbg(dev,
 		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
 		id,
-		(status & MXT_DETECT) ? 'D' : '.',
-		(status & MXT_PRESS) ? 'P' : '.',
-		(status & MXT_RELEASE) ? 'R' : '.',
-		(status & MXT_MOVE) ? 'M' : '.',
-		(status & MXT_VECTOR) ? 'V' : '.',
-		(status & MXT_AMP) ? 'A' : '.',
-		(status & MXT_SUPPRESS) ? 'S' : '.',
-		(status & MXT_UNGRIP) ? 'U' : '.',
+		(status & MXT_T9_DETECT) ? 'D' : '.',
+		(status & MXT_T9_PRESS) ? 'P' : '.',
+		(status & MXT_T9_RELEASE) ? 'R' : '.',
+		(status & MXT_T9_MOVE) ? 'M' : '.',
+		(status & MXT_T9_VECTOR) ? 'V' : '.',
+		(status & MXT_T9_AMP) ? 'A' : '.',
+		(status & MXT_T9_SUPPRESS) ? 'S' : '.',
+		(status & MXT_T9_UNGRIP) ? 'U' : '.',
 		x, y, area, amplitude);
 
 	input_mt_slot(input_dev, id);
 	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
-				   status & MXT_DETECT);
+				   status & MXT_T9_DETECT);
 
-	if (status & MXT_DETECT) {
+	if (status & MXT_T9_DETECT) {
 		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
 		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
@@ -1339,7 +1339,7 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 	if (range.y == 0)
 		range.y = 1023;
 
-	if (orient & MXT_XY_SWITCH) {
+	if (orient & MXT_T9_ORIENT_SWITCH) {
 		data->max_x = range.y;
 		data->max_y = range.x;
 	} else {
-- 
1.7.10.4

