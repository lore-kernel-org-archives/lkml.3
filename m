Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaAYSGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:06:10 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36018 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaAYSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:06:08 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, badarkhe.manish@gmail.com
Subject: [PATCH] regulator: fixed: Use devm_regulator_register
Date: Sat, 25 Jan 2014 23:35:54 +0530
Message-Id: <1390673154-15839-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "devm_regulator_register" instead of "regulator_register"
which simplifies the code.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 5ea64b9... 6d32341... M	drivers/regulator/fixed.c
 drivers/regulator/fixed.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 5ea64b9..6d32341 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -186,7 +186,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = pdev->dev.of_node;
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -212,7 +213,6 @@ static int reg_fixed_voltage_remove(struct platform_device *pdev)
 {
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
 	kfree(drvdata->desc.supply_name);
 	kfree(drvdata->desc.name);
 
-- 
1.7.10.4

