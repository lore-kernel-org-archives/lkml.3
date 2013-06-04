Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3FDOHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:07:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46650 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3FDOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Abraham <abrahamh@web.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/70] Input: egalax_ts - ABS_MT_POSITION_Y not reported well
Date: Tue,  4 Jun 2013 15:06:25 +0100
Message-Id: <1370354846-14213-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Abraham <abrahamh@web.de>

commit 3c9cfa782e075cc2348b949ba139911aac02c7cb upstream.

The egalax_ts touchscreen modul not report ABS_MT_POSITION_Y proper.
As result it may be, that upper software levels only receive x coordinates well.

Signed-off-by: Heiko Abraham <abrahamh@web.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/touchscreen/egalax_ts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 70524dd..be2a271 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -203,7 +203,7 @@ static int __devinit egalax_ts_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_X, 0, 0);
 	input_set_abs_params(input_dev,
-			     ABS_MT_POSITION_X, 0, EGALAX_MAX_Y, 0, 0);
+			     ABS_MT_POSITION_Y, 0, EGALAX_MAX_Y, 0, 0);
 	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS);
 
 	input_set_drvdata(input_dev, ts);
-- 
1.8.1.2

