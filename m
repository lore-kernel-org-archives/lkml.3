Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab3LYAZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 19:25:22 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33740 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LYAZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 19:25:21 -0500
Message-ID: <1387931114.6419.0.camel@phoenix>
Subject: [PATCH v2] regulator: act8865: Remove unneeded
 regulator_unregister() calls
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Dec 2013 08:25:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not required because current code uses devm_regulator_register() to
register regulators.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2: Fix typo in subject line s/Rmove/Remove/
 drivers/regulator/act8865-regulator.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index db048f2..dfae294 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -334,17 +334,6 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int act8865_pmic_remove(struct i2c_client *client)
-{
-	struct act8865 *act8865 = i2c_get_clientdata(client);
-	int i;
-
-	for (i = 0; i < ACT8865_REG_NUM; i++)
-		regulator_unregister(act8865->rdev[i]);
-
-	return 0;
-}
-
 static const struct i2c_device_id act8865_ids[] = {
 	{ "act8865", 0 },
 	{ },
@@ -357,7 +346,6 @@ static struct i2c_driver act8865_pmic_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= act8865_pmic_probe,
-	.remove		= act8865_pmic_remove,
 	.id_table	= act8865_ids,
 };
 
-- 
1.8.1.2



