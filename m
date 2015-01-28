Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbbA1CrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:47:01 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18622 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933456AbbA1Cq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:46:57 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <patches@opensource.wolfsonmicro.com>
CC: <agross@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 5/9] regulator: wm8350: move to set_optimum_mode
Date: Tue, 27 Jan 2015 18:46:35 -0800
Message-ID: <1422413199-17273-6-git-send-email-bjorn.andersson@sonymobile.com>
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
 drivers/regulator/wm8350-regulator.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 7ec7c39..f8bcaed 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -915,13 +915,13 @@ static unsigned int get_mode(int uA, const struct wm8350_dcdc_efficiency *eff)
 	return REGULATOR_MODE_NORMAL;
 }
 
-/* Query the regulator for it's most efficient mode @ uV,uA
+/* Configure the regulator for it's most efficient mode @ uV,uA
  * WM8350 regulator efficiency is pretty similar over
  * different input and output uV.
  */
-static unsigned int wm8350_dcdc_get_optimum_mode(struct regulator_dev *rdev,
-						 int input_uV, int output_uV,
-						 int output_uA)
+static int wm8350_dcdc_set_optimum_mode(struct regulator_dev *rdev,
+					int input_uV, int output_uV,
+					int output_uA)
 {
 	int dcdc = rdev_get_id(rdev), mode;
 
@@ -938,7 +938,7 @@ static unsigned int wm8350_dcdc_get_optimum_mode(struct regulator_dev *rdev,
 		mode = REGULATOR_MODE_NORMAL;
 		break;
 	}
-	return mode;
+	return wm8350_dcdc_set_mode(rdev, mode);
 }
 
 static struct regulator_ops wm8350_dcdc_ops = {
@@ -951,7 +951,7 @@ static struct regulator_ops wm8350_dcdc_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.get_mode = wm8350_dcdc_get_mode,
 	.set_mode = wm8350_dcdc_set_mode,
-	.get_optimum_mode = wm8350_dcdc_get_optimum_mode,
+	.set_optimum_mode = wm8350_dcdc_set_optimum_mode,
 	.set_suspend_voltage = wm8350_dcdc_set_suspend_voltage,
 	.set_suspend_enable = wm8350_dcdc_set_suspend_enable,
 	.set_suspend_disable = wm8350_dcdc_set_suspend_disable,
-- 
1.9.1

