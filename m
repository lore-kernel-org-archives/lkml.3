Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaBTJCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:02:53 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63183 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaBTI7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:40 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH 17/23] regulator: tps6586x: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:17 +0530
Message-Id: <1392886403-10640-17-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/tps6586x-regulator.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 0485d47f0d8a..e36f3569767f 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -363,10 +363,8 @@ static struct tps6586x_platform_data *tps6586x_parse_regulator_dt(
 	}
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "Memory alloction failed\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	for (i = 0; i < num; i++) {
 		int id;
@@ -420,10 +418,8 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 
 	rdev = devm_kzalloc(&pdev->dev, TPS6586X_ID_MAX_REGULATOR *
 				sizeof(*rdev), GFP_KERNEL);
-	if (!rdev) {
-		dev_err(&pdev->dev, "Mmemory alloc failed\n");
+	if (!rdev)
 		return -ENOMEM;
-	}
 
 	version = tps6586x_get_version(pdev->dev.parent);
 
-- 
1.7.9.5

