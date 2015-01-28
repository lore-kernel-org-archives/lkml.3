Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbbA1CrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:47:07 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18649 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933456AbbA1CrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:47:03 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <patches@opensource.wolfsonmicro.com>
CC: <agross@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 7/9] regulator: wm8400: move to set_optimum_mode
Date: Tue, 27 Jan 2015 18:46:37 -0800
Message-ID: <1422413199-17273-8-git-send-email-bjorn.andersson@sonymobile.com>
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
 drivers/regulator/wm8400-regulator.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 82d8290..7f4c924 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -99,11 +99,11 @@ static int wm8400_dcdc_set_mode(struct regulator_dev *dev, unsigned int mode)
 	}
 }
 
-static unsigned int wm8400_dcdc_get_optimum_mode(struct regulator_dev *dev,
-						 int input_uV, int output_uV,
-						 int load_uA)
+static int wm8400_dcdc_set_optimum_mode(struct regulator_dev *dev,
+					int input_uV, int output_uV,
+					int load_uA)
 {
-	return REGULATOR_MODE_NORMAL;
+	return wm8400_dcdc_set_mode(rdev, REGULATOR_MODE_NORMAL);
 }
 
 static struct regulator_ops wm8400_dcdc_ops = {
@@ -116,7 +116,7 @@ static struct regulator_ops wm8400_dcdc_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_mode = wm8400_dcdc_get_mode,
 	.set_mode = wm8400_dcdc_set_mode,
-	.get_optimum_mode = wm8400_dcdc_get_optimum_mode,
+	.set_optimum_mode = wm8400_dcdc_set_optimum_mode,
 };
 
 static struct regulator_desc regulators[] = {
-- 
1.9.1

