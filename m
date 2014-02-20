Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaBTI6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:58:55 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36688 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaBTI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:58:54 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Subject: [PATCH 01/23] regulator: da9063: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:01 +0530
Message-Id: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/regulator/da9063-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 22ba992e73f2..38ad5e950907 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -776,10 +776,8 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	size = sizeof(struct da9063_regulators) +
 		n_regulators * sizeof(struct da9063_regulator);
 	regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
-	if (!regulators) {
-		dev_err(&pdev->dev, "No memory for regulators\n");
+	if (!regulators)
 		return -ENOMEM;
-	}
 
 	regulators->n_regulators = n_regulators;
 	platform_set_drvdata(pdev, regulators);
-- 
1.7.9.5

