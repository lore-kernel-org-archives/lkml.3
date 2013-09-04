Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606Ab3IDMFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:05:49 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53390 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537Ab3IDMFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:46 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org, ldewangan@nvidia.com,
        magi@slimlogic.co.uk, gg@slimlogic.co.uk, mike@compulab.co.il,
        anilkumar@ti.com, vbyravarasu@nvidia.com
Subject: [PATCH 02/10] regulator: tps62360: Use devm_regulator_register
Date: Wed,  4 Sep 2013 17:17:45 +0530
Message-Id: <1378295273-32257-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
References: <1378295273-32257-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps62360-regulator.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index a490d5b..c4a5695 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -476,7 +476,7 @@ static int tps62360_probe(struct i2c_client *client,
 	config.of_node = client->dev.of_node;
 
 	/* Register the regulators */
-	rdev = regulator_register(&tps->desc, &config);
+	rdev = devm_regulator_register(&client->dev, &tps->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(tps->dev,
 			"%s(): regulator register failed with err %s\n",
@@ -488,20 +488,6 @@ static int tps62360_probe(struct i2c_client *client,
 	return 0;
 }
 
-/**
- * tps62360_remove - tps62360 driver i2c remove handler
- * @client: i2c driver client device structure
- *
- * Unregister TPS driver as an i2c client device driver
- */
-static int tps62360_remove(struct i2c_client *client)
-{
-	struct tps62360_chip *tps = i2c_get_clientdata(client);
-
-	regulator_unregister(tps->rdev);
-	return 0;
-}
-
 static void tps62360_shutdown(struct i2c_client *client)
 {
 	struct tps62360_chip *tps = i2c_get_clientdata(client);
@@ -535,7 +521,6 @@ static struct i2c_driver tps62360_i2c_driver = {
 		.of_match_table = of_match_ptr(tps62360_of_match),
 	},
 	.probe = tps62360_probe,
-	.remove = tps62360_remove,
 	.shutdown = tps62360_shutdown,
 	.id_table = tps62360_id,
 };
-- 
1.7.9.5

