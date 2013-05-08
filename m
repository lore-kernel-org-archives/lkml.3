Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3EHKwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:52:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47987 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3EHKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:52:17 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 1/2] regulator: isl6271a: Use NULL instead of 0
Date: Wed,  8 May 2013 16:09:05 +0530
Message-Id: <1368009546-20770-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_data is a pointer. Use NULL instead of 0.

Silences the following sparse warning:
drivers/regulator/isl6271a-regulator.c:133:44:
warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index d1e5bee..b99c49b 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -130,7 +130,7 @@ static int isl6271a_probe(struct i2c_client *i2c,
 		if (i == 0)
 			config.init_data = init_data;
 		else
-			config.init_data = 0;
+			config.init_data = NULL;
 		config.driver_data = pmic;
 
 		pmic->rdev[i] = regulator_register(&isl_rd[i], &config);
-- 
1.7.9.5

