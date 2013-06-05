Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3FERyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:54:11 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:55235 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757129Ab3FERsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:15 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 25/53] Input: atmel_mxt_ts - Rename pressure to amplitude to match spec
Date: Wed,  5 Jun 2013 18:37:18 +0100
Message-Id: <1370453866-16534-26-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2e6ddc5..ab6a1f6 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -641,7 +641,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int x;
 	int y;
 	int area;
-	int pressure;
+	int amplitude;
 
 	/* do not report events if input device not yet registered */
 	if (!data->enable_reporting)
@@ -655,7 +655,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		y = y >> 2;
 
 	area = message->message[4];
-	pressure = message->message[5];
+	amplitude = message->message[5];
 
 	dev_dbg(dev,
 		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
@@ -668,7 +668,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		(status & MXT_AMP) ? 'A' : '.',
 		(status & MXT_SUPPRESS) ? 'S' : '.',
 		(status & MXT_UNGRIP) ? 'U' : '.',
-		x, y, area, pressure);
+		x, y, area, amplitude);
 
 	input_mt_slot(input_dev, id);
 	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
@@ -677,7 +677,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	if (status & MXT_DETECT) {
 		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
-		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
+		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
 	}
 }
-- 
1.7.10.4

