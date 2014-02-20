Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaBTI7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:05 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58614 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaBTI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:00 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 03/23] regulator: dbx500: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:03 +0530
Message-Id: <1392886403-10640-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/regulator/dbx500-prcmu.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index ce89f7848a57..f111dfb8d2d7 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -202,18 +202,12 @@ ux500_regulator_debug_init(struct platform_device *pdev,
 	rdebug.num_regulators = num_regulators;
 
 	rdebug.state_before_suspend = kzalloc(num_regulators, GFP_KERNEL);
-	if (!rdebug.state_before_suspend) {
-		dev_err(&pdev->dev,
-			"could not allocate memory for saving state\n");
+	if (!rdebug.state_before_suspend)
 		goto exit_destroy_power_state;
-	}
 
 	rdebug.state_after_suspend = kzalloc(num_regulators, GFP_KERNEL);
-	if (!rdebug.state_after_suspend) {
-		dev_err(&pdev->dev,
-			"could not allocate memory for saving state\n");
+	if (!rdebug.state_after_suspend)
 		goto exit_free;
-	}
 
 	dbx500_regulator_testcase(regulator_info, num_regulators);
 	return 0;
-- 
1.7.9.5

