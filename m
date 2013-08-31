Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3HaL35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40099 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3HaL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:55 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:18 +0100
Message-Id: <1377948564-8383-3-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 03/11] regulator: arizona-micsupp: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/arizona-micsupp.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index e87536b..724706a 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -225,7 +225,9 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_MIC_CHARGE_PUMP_1,
 			   ARIZONA_CPMIC_BYPASS, 0);
 
-	micsupp->regulator = regulator_register(&arizona_micsupp, &config);
+	micsupp->regulator = devm_regulator_register(&pdev->dev,
+						     &arizona_micsupp,
+						     &config);
 	if (IS_ERR(micsupp->regulator)) {
 		ret = PTR_ERR(micsupp->regulator);
 		dev_err(arizona->dev, "Failed to register mic supply: %d\n",
@@ -238,18 +240,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int arizona_micsupp_remove(struct platform_device *pdev)
-{
-	struct arizona_micsupp *micsupp = platform_get_drvdata(pdev);
-
-	regulator_unregister(micsupp->regulator);
-
-	return 0;
-}
-
 static struct platform_driver arizona_micsupp_driver = {
 	.probe = arizona_micsupp_probe,
-	.remove = arizona_micsupp_remove,
 	.driver		= {
 		.name	= "arizona-micsupp",
 		.owner	= THIS_MODULE,
-- 
1.8.4.rc3

