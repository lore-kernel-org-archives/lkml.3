Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaBTI7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:10 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56957 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaBTI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:06 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 05/23] regulator: fixed: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:05 +0530
Message-Id: <1392886403-10640-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/fixed.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 3c307d62fd31..c61f7e97e4f8 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -130,10 +130,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
 			       GFP_KERNEL);
-	if (drvdata == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate device data\n");
+	if (!drvdata)
 		return -ENOMEM;
-	}
 
 	drvdata->desc.name = devm_kstrdup(&pdev->dev,
 					  config->supply_name,
-- 
1.7.9.5

