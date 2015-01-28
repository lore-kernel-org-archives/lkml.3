Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbbA1Crz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:47:55 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18631 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933484AbbA1CrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:47:00 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-arm-msm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <agross@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>
Subject: [PATCH 6/9] regulator: hi6421: move to set_optimum_mode
Date: Tue, 27 Jan 2015 18:46:36 -0800
Message-ID: <1422413199-17273-7-git-send-email-bjorn.andersson@sonymobile.com>
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
 drivers/regulator/hi6421-regulator.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
index 42dc5fb..42b362d 100644
--- a/drivers/regulator/hi6421-regulator.c
+++ b/drivers/regulator/hi6421-regulator.c
@@ -477,15 +477,18 @@ static int hi6421_regulator_buck_set_mode(struct regulator_dev *rdev,
 	return 0;
 }
 
-unsigned int hi6421_regulator_ldo_get_optimum_mode(struct regulator_dev *rdev,
+static int hi6421_regulator_ldo_set_optimum_mode(struct regulator_dev *rdev,
 			int input_uV, int output_uV, int load_uA)
 {
 	struct hi6421_regulator_info *info = rdev_get_drvdata(rdev);
+	unsigned int mode;
 
 	if (load_uA > info->eco_microamp)
-		return REGULATOR_MODE_NORMAL;
+		mode = REGULATOR_MODE_NORMAL;
+	else
+		mode = REGULATOR_MODE_IDLE;
 
-	return REGULATOR_MODE_IDLE;
+	return hi6421_regulator_ldo_set_mode(rdev, mode);
 }
 
 static const struct regulator_ops hi6421_ldo_ops = {
@@ -498,7 +501,7 @@ static const struct regulator_ops hi6421_ldo_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_mode = hi6421_regulator_ldo_get_mode,
 	.set_mode = hi6421_regulator_ldo_set_mode,
-	.get_optimum_mode = hi6421_regulator_ldo_get_optimum_mode,
+	.set_optimum_mode = hi6421_regulator_ldo_set_optimum_mode,
 };
 
 static const struct regulator_ops hi6421_ldo_linear_ops = {
@@ -511,7 +514,7 @@ static const struct regulator_ops hi6421_ldo_linear_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_mode = hi6421_regulator_ldo_get_mode,
 	.set_mode = hi6421_regulator_ldo_set_mode,
-	.get_optimum_mode = hi6421_regulator_ldo_get_optimum_mode,
+	.set_optimum_mode = hi6421_regulator_ldo_set_optimum_mode,
 };
 
 static const struct regulator_ops hi6421_ldo_linear_range_ops = {
@@ -524,7 +527,7 @@ static const struct regulator_ops hi6421_ldo_linear_range_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_mode = hi6421_regulator_ldo_get_mode,
 	.set_mode = hi6421_regulator_ldo_set_mode,
-	.get_optimum_mode = hi6421_regulator_ldo_get_optimum_mode,
+	.set_optimum_mode = hi6421_regulator_ldo_set_optimum_mode,
 };
 
 static const struct regulator_ops hi6421_buck012_ops = {
-- 
1.9.1

