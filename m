Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaBTI7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:49 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41747 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaBTI7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:47 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 19/23] regulator: tps80031: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:19 +0530
Message-Id: <1392886403-10640-19-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps80031-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 71f457a42623..ac88c988bb2e 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -693,10 +693,8 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 
 	pmic = devm_kzalloc(&pdev->dev,
 			TPS80031_REGULATOR_MAX * sizeof(*pmic), GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
 		tps_pdata = pdata->regulator_pdata[num];
-- 
1.7.9.5

