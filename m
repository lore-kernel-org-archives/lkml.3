Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaBTI7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:47 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42219 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaBTI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:44 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 18/23] regulator: tps65910: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:18 +0530
Message-Id: <1392886403-10640-18-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/regulator/tps65910-regulator.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index f50dd847eebc..fa7db8847578 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1011,11 +1011,8 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 
 	pmic_plat_data = devm_kzalloc(&pdev->dev, sizeof(*pmic_plat_data),
 					GFP_KERNEL);
-
-	if (!pmic_plat_data) {
-		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+	if (!pmic_plat_data)
 		return NULL;
-	}
 
 	np = of_node_get(pdev->dev.parent->of_node);
 	regulators = of_get_child_by_name(np, "regulators");
@@ -1098,10 +1095,8 @@ static int tps65910_probe(struct platform_device *pdev)
 	}
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "Memory allocation failed for pmic\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	pmic->mfd = tps65910;
 	platform_set_drvdata(pdev, pmic);
@@ -1130,24 +1125,18 @@ static int tps65910_probe(struct platform_device *pdev)
 
 	pmic->desc = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct regulator_desc), GFP_KERNEL);
-	if (!pmic->desc) {
-		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
+	if (!pmic->desc)
 		return -ENOMEM;
-	}
 
 	pmic->info = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct tps_info *), GFP_KERNEL);
-	if (!pmic->info) {
-		dev_err(&pdev->dev, "Memory alloc fails for info\n");
+	if (!pmic->info)
 		return -ENOMEM;
-	}
 
 	pmic->rdev = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct regulator_dev *), GFP_KERNEL);
-	if (!pmic->rdev) {
-		dev_err(&pdev->dev, "Memory alloc fails for rdev\n");
+	if (!pmic->rdev)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < pmic->num_regulators && i < TPS65910_NUM_REGS;
 			i++, info++) {
-- 
1.7.9.5

