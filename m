Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbbA1Cqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:46:55 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18556 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933300AbbA1Cqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:46:51 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <agross@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>
Subject: [PATCH 3/9] regulator: ab8500: move to set_optimum_mode
Date: Tue, 27 Jan 2015 18:46:33 -0800
Message-ID: <1422413199-17273-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422413199-17273-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/regulator/ab8500.c | 48 +++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0f97514..c1588c1 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -320,27 +320,6 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 		return 0;
 }
 
-static unsigned int ab8500_regulator_get_optimum_mode(
-		struct regulator_dev *rdev, int input_uV,
-		int output_uV, int load_uA)
-{
-	unsigned int mode;
-
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
-
-	if (load_uA <= info->load_lp_uA)
-		mode = REGULATOR_MODE_IDLE;
-	else
-		mode = REGULATOR_MODE_NORMAL;
-
-	return mode;
-}
-
 static int ab8500_regulator_set_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
@@ -430,6 +409,27 @@ out_unlock:
 	return ret;
 }
 
+static int ab8500_regulator_set_optimum_mode(
+		struct regulator_dev *rdev, int input_uV,
+		int output_uV, int load_uA)
+{
+	unsigned int mode;
+
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (load_uA <= info->load_lp_uA)
+		mode = REGULATOR_MODE_IDLE;
+	else
+		mode = REGULATOR_MODE_NORMAL;
+
+	return ab8500_regulator_set_mode(rdev, mode);
+}
+
 static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -645,7 +645,7 @@ static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_optimum_mode	= ab8500_regulator_set_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
@@ -656,7 +656,7 @@ static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 static struct regulator_ops ab8540_aux3_regulator_volt_mode_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
-	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_optimum_mode	= ab8500_regulator_set_optimum_mode,
 	.set_mode	= ab8500_regulator_set_mode,
 	.get_mode	= ab8500_regulator_get_mode,
 	.is_enabled	= ab8500_regulator_is_enabled,
@@ -678,7 +678,7 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_optimum_mode	= ab8500_regulator_set_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
 	.list_voltage		= regulator_list_voltage_table,
-- 
1.9.1

