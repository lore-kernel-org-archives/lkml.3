Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411Ab3IDF4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:56:23 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65374 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3IDF4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:20 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 7/9] regulator: max8973-regulator: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:08:00 +0530
Message-Id: <1378273082-28305-7-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8973-regulator.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 0c5195a..04de63d 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -467,7 +467,7 @@ static int max8973_probe(struct i2c_client *client,
 	config.regmap = max->regmap;
 
 	/* Register the regulators */
-	rdev = regulator_register(&max->desc, &config);
+	rdev = devm_regulator_register(&client->dev, &max->desc, &config);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(max->dev, "regulator register failed, err %d\n", ret);
@@ -478,14 +478,6 @@ static int max8973_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int max8973_remove(struct i2c_client *client)
-{
-	struct max8973_chip *max = i2c_get_clientdata(client);
-
-	regulator_unregister(max->rdev);
-	return 0;
-}
-
 static const struct i2c_device_id max8973_id[] = {
 	{.name = "max8973",},
 	{},
@@ -499,7 +491,6 @@ static struct i2c_driver max8973_i2c_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = max8973_probe,
-	.remove = max8973_remove,
 	.id_table = max8973_id,
 };
 
-- 
1.7.9.5

