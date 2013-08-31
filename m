Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3HaLbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:31:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40152 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3HaL3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:44 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:23 +0100
Message-Id: <1377948564-8383-8-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 08/11] regulator: wm831x-ldo: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-ldo.c | 47 +++++++-----------------------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 5570f3e..2be72fe 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -279,7 +279,8 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	config.driver_data = ldo;
 	config.regmap = wm831x->regmap;
 
-	ldo->regulator = regulator_register(&ldo->desc, &config);
+	ldo->regulator = devm_regulator_register(&pdev->dev, &ldo->desc,
+						 &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -295,31 +296,19 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, ldo);
 
 	return 0;
 
-err_regulator:
-	regulator_unregister(ldo->regulator);
 err:
 	return ret;
 }
 
-static int wm831x_gp_ldo_remove(struct platform_device *pdev)
-{
-	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_gp_ldo_driver = {
 	.probe = wm831x_gp_ldo_probe,
-	.remove = wm831x_gp_ldo_remove,
 	.driver		= {
 		.name	= "wm831x-ldo",
 		.owner	= THIS_MODULE,
@@ -504,7 +493,8 @@ static int wm831x_aldo_probe(struct platform_device *pdev)
 	config.driver_data = ldo;
 	config.regmap = wm831x->regmap;
 
-	ldo->regulator = regulator_register(&ldo->desc, &config);
+	ldo->regulator = devm_regulator_register(&pdev->dev, &ldo->desc,
+						 &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -519,31 +509,19 @@ static int wm831x_aldo_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, ldo);
 
 	return 0;
 
-err_regulator:
-	regulator_unregister(ldo->regulator);
 err:
 	return ret;
 }
 
-static int wm831x_aldo_remove(struct platform_device *pdev)
-{
-	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_aldo_driver = {
 	.probe = wm831x_aldo_probe,
-	.remove = wm831x_aldo_remove,
 	.driver		= {
 		.name	= "wm831x-aldo",
 		.owner	= THIS_MODULE,
@@ -661,7 +639,8 @@ static int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	config.driver_data = ldo;
 	config.regmap = wm831x->regmap;
 
-	ldo->regulator = regulator_register(&ldo->desc, &config);
+	ldo->regulator = devm_regulator_register(&pdev->dev, &ldo->desc,
+						 &config);
 	if (IS_ERR(ldo->regulator)) {
 		ret = PTR_ERR(ldo->regulator);
 		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
@@ -677,18 +656,8 @@ err:
 	return ret;
 }
 
-static int wm831x_alive_ldo_remove(struct platform_device *pdev)
-{
-	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_alive_ldo_driver = {
 	.probe = wm831x_alive_ldo_probe,
-	.remove = wm831x_alive_ldo_remove,
 	.driver		= {
 		.name	= "wm831x-alive-ldo",
 		.owner	= THIS_MODULE,
-- 
1.8.4.rc3

