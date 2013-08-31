Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3HaL3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40135 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3HaL3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:40 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:24 +0100
Message-Id: <1377948564-8383-9-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 09/11] regulator: wm8350: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm8350-regulator.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 835b5f0..a438e93 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1206,7 +1206,8 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 	config.regmap = wm8350->regmap;
 
 	/* register regulator */
-	rdev = regulator_register(&wm8350_reg[pdev->id], &config);
+	rdev = devm_regulator_register(&pdev->dev, &wm8350_reg[pdev->id],
+				       &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register %s\n",
 			wm8350_reg[pdev->id].name);
@@ -1217,7 +1218,6 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 	ret = wm8350_register_irq(wm8350, wm8350_reg[pdev->id].irq,
 				  pmic_uv_handler, 0, "UV", rdev);
 	if (ret < 0) {
-		regulator_unregister(rdev);
 		dev_err(&pdev->dev, "failed to register regulator %s IRQ\n",
 			wm8350_reg[pdev->id].name);
 		return ret;
@@ -1233,8 +1233,6 @@ static int wm8350_regulator_remove(struct platform_device *pdev)
 
 	wm8350_free_irq(wm8350, wm8350_reg[pdev->id].irq, rdev);
 
-	regulator_unregister(rdev);
-
 	return 0;
 }
 
-- 
1.8.4.rc3

