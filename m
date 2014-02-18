Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaBRKre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:34 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56422 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaBRKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:31 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 15/15] regulator: as3711: Remove redundant error message
Date: Tue, 18 Feb 2014 16:11:11 +0530
Message-Id: <1392720071-13503-15-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/as3711-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 856c55f3a832..b47283f91e2d 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -245,10 +245,8 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 
 	regs = devm_kzalloc(&pdev->dev, AS3711_REGULATOR_NUM *
 			sizeof(struct as3711_regulator), GFP_KERNEL);
-	if (!regs) {
-		dev_err(&pdev->dev, "Memory allocation failed exiting..\n");
+	if (!regs)
 		return -ENOMEM;
-	}
 
 	for (id = 0, ri = as3711_reg_info; id < AS3711_REGULATOR_NUM; ++id, ri++) {
 		reg = &regs[id];
-- 
1.7.9.5

