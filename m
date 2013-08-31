Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3HaL37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40096 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3HaL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:55 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:17 +0100
Message-Id: <1377948564-8383-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 02/11] regulator: arizona-ldo1: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/arizona-ldo1.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 81d8681..4f6c205 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -226,7 +226,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	else
 		config.init_data = &ldo1->init_data;
 
-	ldo1->regulator = regulator_register(desc, &config);
+	ldo1->regulator = devm_regulator_register(&pdev->dev, desc, &config);
 	if (IS_ERR(ldo1->regulator)) {
 		ret = PTR_ERR(ldo1->regulator);
 		dev_err(arizona->dev, "Failed to register LDO1 supply: %d\n",
@@ -239,18 +239,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int arizona_ldo1_remove(struct platform_device *pdev)
-{
-	struct arizona_ldo1 *ldo1 = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo1->regulator);
-
-	return 0;
-}
-
 static struct platform_driver arizona_ldo1_driver = {
 	.probe = arizona_ldo1_probe,
-	.remove = arizona_ldo1_remove,
 	.driver		= {
 		.name	= "arizona-ldo1",
 		.owner	= THIS_MODULE,
-- 
1.8.4.rc3

