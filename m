Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaBTI7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60811 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbaBTI7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:20 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 10/23] regulator: rc5t583: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:10 +0530
Message-Id: <1392886403-10640-10-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/rc5t583-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 22d6fd1281b1..4c414ae109ae 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -134,10 +134,8 @@ static int rc5t583_regulator_probe(struct platform_device *pdev)
 
 	regs = devm_kzalloc(&pdev->dev, RC5T583_REGULATOR_MAX *
 			sizeof(struct rc5t583_regulator), GFP_KERNEL);
-	if (!regs) {
-		dev_err(&pdev->dev, "Memory allocation failed exiting..\n");
+	if (!regs)
 		return -ENOMEM;
-	}
 
 
 	for (id = 0; id < RC5T583_REGULATOR_MAX; ++id) {
-- 
1.7.9.5

