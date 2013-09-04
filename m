Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591Ab3IDMFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:05:45 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36352 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537Ab3IDMFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:43 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 01/10] regulator: tps51632: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:44 +0530
Message-Id: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This series is compile tested.
---
 drivers/regulator/tps51632-regulator.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 6e67be7..83a745e 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -343,7 +343,7 @@ static int tps51632_probe(struct i2c_client *client,
 	config.regmap = tps->regmap;
 	config.of_node = client->dev.of_node;
 
-	rdev = regulator_register(&tps->desc, &config);
+	rdev = devm_regulator_register(&client->dev, &tps->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(tps->dev, "regulator register failed\n");
 		return PTR_ERR(rdev);
@@ -353,14 +353,6 @@ static int tps51632_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int tps51632_remove(struct i2c_client *client)
-{
-	struct tps51632_chip *tps = i2c_get_clientdata(client);
-
-	regulator_unregister(tps->rdev);
-	return 0;
-}
-
 static const struct i2c_device_id tps51632_id[] = {
 	{.name = "tps51632",},
 	{},
@@ -375,7 +367,6 @@ static struct i2c_driver tps51632_i2c_driver = {
 		.of_match_table = of_match_ptr(tps51632_of_match),
 	},
 	.probe = tps51632_probe,
-	.remove = tps51632_remove,
 	.id_table = tps51632_id,
 };
 
-- 
1.7.9.5

