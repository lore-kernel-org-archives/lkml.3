Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaBTI7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:43 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63096 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbaBTI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:35 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 15/23] regulator: tps65090: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:15 +0530
Message-Id: <1392886403-10640-15-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/regulator/tps65090-regulator.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 5674f886c471..2e92ef68574d 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -168,17 +168,13 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 
 	tps65090_pdata = devm_kzalloc(&pdev->dev, sizeof(*tps65090_pdata),
 				GFP_KERNEL);
-	if (!tps65090_pdata) {
-		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
+	if (!tps65090_pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	reg_pdata = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX *
 				sizeof(*reg_pdata), GFP_KERNEL);
-	if (!reg_pdata) {
-		dev_err(&pdev->dev, "Memory alloc for reg_pdata failed\n");
+	if (!reg_pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	regulators = of_get_child_by_name(np, "regulators");
 	if (!regulators) {
@@ -253,10 +249,8 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 
 	pmic = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX * sizeof(*pmic),
 			GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	for (num = 0; num < TPS65090_REGULATOR_MAX; num++) {
 		tps_pdata = tps65090_pdata->reg_pdata[num];
-- 
1.7.9.5

