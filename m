Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaBTI7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:14 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46743 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaBTI7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:11 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 06/23] regulator: max77686: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:06 +0530
Message-Id: <1392886403-10640-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max77686.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index b411af00065d..de020adf0568 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -410,8 +410,6 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 			     pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
-		dev_err(&pdev->dev,
-			"could not allocate memory for regulator data\n");
 		of_node_put(regulators_np);
 		return -ENOMEM;
 	}
-- 
1.7.9.5

