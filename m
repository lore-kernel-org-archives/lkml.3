Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaCUXWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:22:53 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49398 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaCUXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:22:43 -0400
Message-ID: <1395444158.25974.1.camel@phoenix>
Subject: [PATCH] regulator: st-pwm: Convert to get_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2014 07:22:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove test for selector in st_pwm_regulator_set_voltage_sel, the checking
is already done in .list_voltage.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/st-pwm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/st-pwm.c b/drivers/regulator/st-pwm.c
index 6ef569f..e367af1 100644
--- a/drivers/regulator/st-pwm.c
+++ b/drivers/regulator/st-pwm.c
@@ -39,11 +39,11 @@ struct st_pwm_voltages {
 	unsigned int dutycycle;
 };
 
-static int st_pwm_regulator_get_voltage(struct regulator_dev *dev)
+static int st_pwm_regulator_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct st_pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
 
-	return drvdata->pdata->duty_cycle_table[drvdata->state].uV;
+	return drvdata->state;
 }
 
 static int st_pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
@@ -53,9 +53,6 @@ static int st_pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
 	int dutycycle;
 	int ret;
 
-	if (selector >= dev->desc->n_voltages)
-		return -EINVAL;
-
 	dutycycle = (ST_PWM_REG_PERIOD / 100) *
 		drvdata->pdata->duty_cycle_table[selector].dutycycle;
 
@@ -92,7 +89,7 @@ static int st_pwm_regulator_list_voltage(struct regulator_dev *dev,
 
 static struct regulator_ops st_pwm_regulator_voltage_ops = {
 	.set_voltage_sel = st_pwm_regulator_set_voltage_sel,
-	.get_voltage     = st_pwm_regulator_get_voltage,
+	.get_voltage_sel = st_pwm_regulator_get_voltage_sel,
 	.list_voltage    = st_pwm_regulator_list_voltage,
 	.map_voltage     = regulator_map_voltage_iterate,
 };
-- 
1.8.3.2



