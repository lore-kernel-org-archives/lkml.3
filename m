Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaBTI7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:25 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46970 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaBTI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:23 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 11/23] regulator: s5m8767: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:11 +0530
Message-Id: <1392886403-10640-11-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 4c356b872e6b..342a66ab654a 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -612,19 +612,13 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
-		dev_err(iodev->dev,
-			"could not allocate memory for regulator data\n");
+	if (!rdata)
 		return -ENOMEM;
-	}
 
 	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode) *
 				pdata->num_regulators, GFP_KERNEL);
-	if (!rmode) {
-		dev_err(iodev->dev,
-			"could not allocate memory for regulator mode\n");
+	if (!rmode)
 		return -ENOMEM;
-	}
 
 	pdata->regulators = rdata;
 	pdata->opmode = rmode;
-- 
1.7.9.5

