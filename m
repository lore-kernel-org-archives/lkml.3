Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaBTI7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:00 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59024 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaBTI66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:58:58 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        S Twiss <stwiss.opensource@diasemi.com>
Subject: [PATCH 02/23] regulator: da9210: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:02 +0530
Message-Id: <1392886403-10640-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: S Twiss <stwiss.opensource@diasemi.com>
---
 drivers/regulator/da9210-regulator.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index 6f5ecbe1132e..7a320dd11c46 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -134,11 +134,8 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	int error;
 
 	chip = devm_kzalloc(&i2c->dev, sizeof(struct da9210), GFP_KERNEL);
-	if (NULL == chip) {
-		dev_err(&i2c->dev,
-			"Cannot kzalloc memory for regulator structure\n");
+	if (!chip)
 		return -ENOMEM;
-	}
 
 	chip->regmap = devm_regmap_init_i2c(i2c, &da9210_regmap_config);
 	if (IS_ERR(chip->regmap)) {
-- 
1.7.9.5

