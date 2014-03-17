Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaCQRij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:38:39 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:58862 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756994AbaCQRi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:38:29 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 20/22] Input: atmel_mxt_ts - rename pressure to amplitude to match spec
Date: Mon, 17 Mar 2014 17:26:53 +0000
Message-Id: <1395077215-10922-21-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5cd2261..acd524f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -629,7 +629,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int x;
 	int y;
 	int area;
-	int pressure;
+	int amplitude;
 
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
 	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
@@ -639,7 +639,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		y = y >> 2;
 
 	area = message->message[4];
-	pressure = message->message[5];
+	amplitude = message->message[5];
 
 	dev_dbg(dev,
 		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
@@ -652,7 +652,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 		(status & MXT_AMP) ? 'A' : '.',
 		(status & MXT_SUPPRESS) ? 'S' : '.',
 		(status & MXT_UNGRIP) ? 'U' : '.',
-		x, y, area, pressure);
+		x, y, area, amplitude);
 
 	input_mt_slot(input_dev, id);
 	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
@@ -661,7 +661,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	if (status & MXT_DETECT) {
 		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
 		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
-		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
+		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
 		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
 	}
 }
-- 
1.8.3.2

