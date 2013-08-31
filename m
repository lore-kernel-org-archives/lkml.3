Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3HaL3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:29:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40162 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3HaL3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:29:50 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:22 +0100
Message-Id: <1377948564-8383-7-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 07/11] regulator: wm831x-isink: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-isink.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 841cb52..0339b88 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -194,7 +194,8 @@ static int wm831x_isink_probe(struct platform_device *pdev)
 	config.init_data = pdata->isink[id];
 	config.driver_data = isink;
 
-	isink->regulator = regulator_register(&isink->desc, &config);
+	isink->regulator = devm_regulator_register(&pdev->dev, &isink->desc,
+						   &config);
 	if (IS_ERR(isink->regulator)) {
 		ret = PTR_ERR(isink->regulator);
 		dev_err(wm831x->dev, "Failed to register ISINK%d: %d\n",
@@ -210,31 +211,19 @@ static int wm831x_isink_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request ISINK IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, isink);
 
 	return 0;
 
-err_regulator:
-	regulator_unregister(isink->regulator);
 err:
 	return ret;
 }
 
-static int wm831x_isink_remove(struct platform_device *pdev)
-{
-	struct wm831x_isink *isink = platform_get_drvdata(pdev);
-
-	regulator_unregister(isink->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_isink_driver = {
 	.probe = wm831x_isink_probe,
-	.remove = wm831x_isink_remove,
 	.driver		= {
 		.name	= "wm831x-isink",
 		.owner	= THIS_MODULE,
-- 
1.8.4.rc3

