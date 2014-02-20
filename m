Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaBTJDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:03:50 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbaBTI7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:31 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 14/23] regulator: tps6507x: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:14 +0530
Message-Id: <1392886403-10640-14-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps6507x-regulator.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index e506e7f54253..98e66ce26723 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -380,10 +380,8 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 
 	tps_board = devm_kzalloc(&pdev->dev, sizeof(*tps_board),
 					GFP_KERNEL);
-	if (!tps_board) {
-		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+	if (!tps_board)
 		return NULL;
-	}
 
 	regulators = of_get_child_by_name(np, "regulators");
 	if (!regulators) {
@@ -406,10 +404,8 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 
 	reg_data = devm_kzalloc(&pdev->dev, (sizeof(struct regulator_init_data)
 					* TPS6507X_NUM_REGULATOR), GFP_KERNEL);
-	if (!reg_data) {
-		dev_err(&pdev->dev, "Failure to alloc init data for regulators.\n");
+	if (!reg_data)
 		return NULL;
-	}
 
 	tps_board->tps6507x_pmic_init_data = reg_data;
 
-- 
1.7.9.5

