Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaIFLLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 07:11:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53000 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIFLL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 07:11:29 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Date: Sat,  6 Sep 2014 12:11:21 +0100
Message-Id: <1410001881-14417-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: tps65217: Remove spurious platform data check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should always be able to probe a regulator with no platform data. This
will enable readback of current state, though no changes can be made to
the device configuration.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/tps65217-regulator.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index d58db72a63b0..1cf16aed9735 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -230,11 +230,6 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 	if (tps->dev->of_node)
 		pdata = tps65217_parse_dt(pdev);
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "Platform data not found\n");
-		return -EINVAL;
-	}
-
 	if (tps65217_chip_id(tps) != TPS65217) {
 		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return -ENODEV;
@@ -245,7 +240,8 @@ static int tps65217_regulator_probe(struct platform_device *pdev)
 	for (i = 0; i < TPS65217_NUM_REGULATOR; i++) {
 		/* Register the regulators */
 		config.dev = tps->dev;
-		config.init_data = pdata->tps65217_init_data[i];
+		if (pdata)
+			config.init_data = pdata->tps65217_init_data[i];
 		config.driver_data = tps;
 		config.regmap = tps->regmap;
 		if (tps->dev->of_node)
-- 
2.1.0

