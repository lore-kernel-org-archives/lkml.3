Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3AOWfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:43426 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584Ab3AOWfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 182/221] regulator: max8998: Use uV in voltage_map_desc
Date: Tue, 15 Jan 2013 10:51:49 -0800
Message-Id: <20130115185011.150161776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit adf6178ad5552a7f2f742a8c85343c50f080c412 upstream.

Integer division may truncate.
This happens when pdata->buckx_voltagex setting is not align with 1000 uV.
Thus use uV in voltage_map_desc, this ensures the selected voltage won't less
than pdata buckx_voltagex settings.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/max8998.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -51,39 +51,39 @@ struct voltage_map_desc {
 	int step;
 };
 
-/* Voltage maps */
+/* Voltage maps in uV*/
 static const struct voltage_map_desc ldo23_voltage_map_desc = {
-	.min = 800,	.step = 50,	.max = 1300,
+	.min = 800000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo456711_voltage_map_desc = {
-	.min = 1600,	.step = 100,	.max = 3600,
+	.min = 1600000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc ldo8_voltage_map_desc = {
-	.min = 3000,	.step = 100,	.max = 3600,
+	.min = 3000000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc ldo9_voltage_map_desc = {
-	.min = 2800,	.step = 100,	.max = 3100,
+	.min = 2800000,	.step = 100000,	.max = 3100000,
 };
 static const struct voltage_map_desc ldo10_voltage_map_desc = {
-	.min = 950,	.step = 50,	.max = 1300,
+	.min = 95000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo1213_voltage_map_desc = {
-	.min = 800,	.step = 100,	.max = 3300,
+	.min = 800000,	.step = 100000,	.max = 3300000,
 };
 static const struct voltage_map_desc ldo1415_voltage_map_desc = {
-	.min = 1200,	.step = 100,	.max = 3300,
+	.min = 1200000,	.step = 100000,	.max = 3300000,
 };
 static const struct voltage_map_desc ldo1617_voltage_map_desc = {
-	.min = 1600,	.step = 100,	.max = 3600,
+	.min = 1600000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc buck12_voltage_map_desc = {
-	.min = 750,	.step = 25,	.max = 1525,
+	.min = 750000,	.step = 25000,	.max = 1525000,
 };
 static const struct voltage_map_desc buck3_voltage_map_desc = {
-	.min = 1600,	.step = 100,	.max = 3600,
+	.min = 1600000,	.step = 100000,	.max = 3600000,
 };
 static const struct voltage_map_desc buck4_voltage_map_desc = {
-	.min = 800,	.step = 100,	.max = 2300,
+	.min = 800000,	.step = 100000,	.max = 2300000,
 };
 
 static const struct voltage_map_desc *ldo_voltage_map[] = {
@@ -445,7 +445,7 @@ static int max8998_set_voltage_buck_time
 	if (max8998->iodev->type == TYPE_MAX8998 && !(val & MAX8998_ENRAMP))
 		return 0;
 
-	difference = (new_selector - old_selector) * desc->step;
+	difference = (new_selector - old_selector) * desc->step / 1000;
 	if (difference > 0)
 		return difference / ((val & 0x0f) + 1);
 
@@ -702,7 +702,7 @@ static __devinit int max8998_pmic_probe(
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage1 / 1000))
+		       < pdata->buck1_voltage1)
 			i++;
 		max8998->buck1_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
@@ -713,7 +713,7 @@ static __devinit int max8998_pmic_probe(
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage2 / 1000))
+		       < pdata->buck1_voltage2)
 			i++;
 
 		max8998->buck1_vol[1] = i;
@@ -725,7 +725,7 @@ static __devinit int max8998_pmic_probe(
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage3 / 1000))
+		       < pdata->buck1_voltage3)
 			i++;
 
 		max8998->buck1_vol[2] = i;
@@ -737,7 +737,7 @@ static __devinit int max8998_pmic_probe(
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck1_voltage4 / 1000))
+		       < pdata->buck1_voltage4)
 			i++;
 
 		max8998->buck1_vol[3] = i;
@@ -763,7 +763,7 @@ static __devinit int max8998_pmic_probe(
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck2_voltage1 / 1000))
+		       < pdata->buck2_voltage1)
 			i++;
 		max8998->buck2_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
@@ -774,7 +774,7 @@ static __devinit int max8998_pmic_probe(
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       < (pdata->buck2_voltage2 / 1000))
+		       < pdata->buck2_voltage2)
 			i++;
 		max8998->buck2_vol[1] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
@@ -792,8 +792,8 @@ static __devinit int max8998_pmic_probe(
 			int count = (desc->max - desc->min) / desc->step + 1;
 
 			regulators[index].n_voltages = count;
-			regulators[index].min_uV = desc->min * 1000;
-			regulators[index].uV_step = desc->step * 1000;
+			regulators[index].min_uV = desc->min;
+			regulators[index].uV_step = desc->step;
 		}
 
 		config.dev = max8998->dev;


