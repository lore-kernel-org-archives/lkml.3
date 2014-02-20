Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaBTI7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:20 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64907 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaBTI7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:17 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 09/23] regulator: max8997: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:09 +0530
Message-Id: <1392886403-10640-9-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8997.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 10108f2941e3..f657d8db9c0c 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -937,7 +937,6 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
 		of_node_put(regulators_np);
-		dev_err(&pdev->dev, "could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.9.5

