Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaBRKtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:49:49 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39154 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaBRKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:00 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 06/15] regulator: lp872x: Do not hardcode return values
Date: Tue, 18 Feb 2014 16:11:02 +0530
Message-Id: <1392720071-13503-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error values returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/lp872x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 2e4734ff79fc..2e022aabd951 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -211,7 +211,7 @@ static int lp872x_get_timestep_usec(struct lp872x *lp)
 
 	ret = lp872x_read_byte(lp, LP872X_GENERAL_CFG, &val);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	val = (val & mask) >> shift;
 	if (val >= size)
@@ -229,7 +229,7 @@ static int lp872x_regulator_enable_time(struct regulator_dev *rdev)
 	u8 addr, val;
 
 	if (time_step_us < 0)
-		return -EINVAL;
+		return time_step_us;
 
 	switch (rid) {
 	case LP8720_ID_LDO1 ... LP8720_ID_BUCK:
-- 
1.7.9.5

