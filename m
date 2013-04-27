Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3D0F6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 01:58:16 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52348 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3D0F6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 01:58:15 -0400
Message-ID: <1367042288.7402.1.camel@phoenix>
Subject: [PATCH] regulator: Remove NULL test before calling
 regulator_unregister()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Sangbeom Kim <sbkim73@samsung.com>, Cyril Chemparathy <cyril@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 27 Apr 2013 13:58:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's safe to call regulator_unregister() with NULL, thus remove the NULL test
before regulator_unregister() calls.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Cyril Chemparathy <cyril@ti.com>
---
 drivers/regulator/max1586.c            |    3 +--
 drivers/regulator/max8649.c            |    6 ++----
 drivers/regulator/max8660.c            |    3 +--
 drivers/regulator/s5m8767.c            |    6 ++----
 drivers/regulator/tps6524x-regulator.c |    3 +--
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index dac0490..54af610 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -232,8 +232,7 @@ static int max1586_pmic_remove(struct i2c_client *client)
 	int i;
 
 	for (i = 0; i <= MAX1586_V6; i++)
-		if (max1586->rdev[i])
-			regulator_unregister(max1586->rdev[i]);
+		regulator_unregister(max1586->rdev[i]);
 	return 0;
 }
 
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index fdb67ff..db6c9be 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -248,10 +248,8 @@ static int max8649_regulator_remove(struct i2c_client *client)
 {
 	struct max8649_regulator_info *info = i2c_get_clientdata(client);
 
-	if (info) {
-		if (info->regulator)
-			regulator_unregister(info->regulator);
-	}
+	if (info)
+		regulator_unregister(info->regulator);
 
 	return 0;
 }
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 4d7c635..d428ef9 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -426,8 +426,7 @@ static int max8660_remove(struct i2c_client *client)
 	int i;
 
 	for (i = 0; i < MAX8660_V_END; i++)
-		if (max8660->rdev[i])
-			regulator_unregister(max8660->rdev[i]);
+		regulator_unregister(max8660->rdev[i]);
 	return 0;
 }
 
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 8e56198..c24448b 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -923,8 +923,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	return 0;
 err:
 	for (i = 0; i < s5m8767->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
+		regulator_unregister(rdev[i]);
 
 	return ret;
 }
@@ -936,8 +935,7 @@ static int s5m8767_pmic_remove(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < s5m8767->num_regulators; i++)
-		if (rdev[i])
-			regulator_unregister(rdev[i]);
+		regulator_unregister(rdev[i]);
 
 	return 0;
 }
diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 18b67d2..1094393 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -585,8 +585,7 @@ static int pmic_remove(struct spi_device *spi)
 	if (!hw)
 		return 0;
 	for (i = 0; i < N_REGULATORS; i++) {
-		if (hw->rdev[i])
-			regulator_unregister(hw->rdev[i]);
+		regulator_unregister(hw->rdev[i]);
 		hw->rdev[i] = NULL;
 	}
 	spi_set_drvdata(spi, NULL);
-- 
1.7.10.4



