Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaBTI7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:16 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33878 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaBTI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:12 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 07/23] regulator: max8907: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:07 +0530
Message-Id: <1392886403-10640-7-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8907-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index afda8c6af721..ed90c759c231 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -292,10 +292,9 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 		return ret;
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "Failed to alloc pmic\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, pmic);
 
 	memcpy(pmic->desc, max8907_regulators, sizeof(pmic->desc));
-- 
1.7.9.5

