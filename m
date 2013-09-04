Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086Ab3IDHAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:00:09 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49191 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761963Ab3IDHAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:00:07 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sbkim73@samsung.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] regulator: s2mps11: Use devm_regulator_register
Date: Wed,  4 Sep 2013 12:12:15 +0530
Message-Id: <1378276935-14053-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e398b51a ("regulator: s2mps11: Convert to devm_regulator_register()")
intended to do this conversion. However the actual conversion to devm_* got
missed out. Fix this.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/s2mps11.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 163b232..7a90a16 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -293,7 +293,8 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = s2mps11;
 
-		s2mps11->rdev[i] = regulator_register(&regulators[i], &config);
+		s2mps11->rdev[i] = devm_regulator_register(&pdev->dev,
+						&regulators[i], &config);
 		if (IS_ERR(s2mps11->rdev[i])) {
 			ret = PTR_ERR(s2mps11->rdev[i]);
 			dev_err(&pdev->dev, "regulator init failed for %d\n",
-- 
1.7.9.5

