Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab3IDF5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:57:42 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34493 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab3IDF4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:56:08 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, ldewangan@nvidia.com, jack.yoo@maxim-ic.com,
        haojian.zhuang@marvell.com, jonghwa3.lee@samsung.com
Subject: [PATCH 4/9] regulator: max8649: Use devm_regulator_register
Date: Wed,  4 Sep 2013 11:07:57 +0530
Message-Id: <1378273082-28305-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
References: <1378273082-28305-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8649.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index db6c9be..b2a808c 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -234,7 +234,8 @@ static int max8649_regulator_probe(struct i2c_client *client,
 	config.driver_data = info;
 	config.regmap = info->regmap;
 
-	info->regulator = regulator_register(&dcdc_desc, &config);
+	info->regulator = devm_regulator_register(&client->dev, &dcdc_desc,
+						  &config);
 	if (IS_ERR(info->regulator)) {
 		dev_err(info->dev, "failed to register regulator %s\n",
 			dcdc_desc.name);
@@ -244,16 +245,6 @@ static int max8649_regulator_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int max8649_regulator_remove(struct i2c_client *client)
-{
-	struct max8649_regulator_info *info = i2c_get_clientdata(client);
-
-	if (info)
-		regulator_unregister(info->regulator);
-
-	return 0;
-}
-
 static const struct i2c_device_id max8649_id[] = {
 	{ "max8649", 0 },
 	{ }
@@ -262,7 +253,6 @@ MODULE_DEVICE_TABLE(i2c, max8649_id);
 
 static struct i2c_driver max8649_driver = {
 	.probe		= max8649_regulator_probe,
-	.remove		= max8649_regulator_remove,
 	.driver		= {
 		.name	= "max8649",
 	},
-- 
1.7.9.5

