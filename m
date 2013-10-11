Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3JKBaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:30:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33529 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3JKBad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:30:33 -0400
Message-ID: <1381455024.4296.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Remove max_uV from struct
 regulator_linear_range
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Margarita Olaya <magi@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 09:30:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linear ranges means each range has linear voltage settings.
So we can calculate max_uV for each linear range in regulator core rather than
set the max_uV field in drivers.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Yi Zhang <yizhang@marvell.com>
Cc: Chao Xie <chao.xie@marvell.com>
Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Margarita Olaya <magi@slimlogic.co.uk>
---
 drivers/regulator/88pm800.c            | 14 ++++++--------
 drivers/regulator/as3711-regulator.c   | 25 +++++++++++--------------
 drivers/regulator/as3722-regulator.c   |  1 -
 drivers/regulator/da903x.c             |  6 ++----
 drivers/regulator/helpers.c            |  6 +++++-
 drivers/regulator/tps65217-regulator.c | 24 ++++++++----------------
 drivers/regulator/tps65912-regulator.c |  9 +++------
 drivers/regulator/wm831x-ldo.c         | 12 ++++--------
 drivers/regulator/wm8350-regulator.c   |  6 ++----
 drivers/regulator/wm8400-regulator.c   |  6 ++----
 include/linux/regulator/driver.h       |  2 --
 11 files changed, 43 insertions(+), 68 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index 3459f60..22ba4c4 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -141,18 +141,16 @@ struct pm800_regulators {
 
 /* Ranges are sorted in ascending order. */
 static const struct regulator_linear_range buck1_volt_range[] = {
-	{ .min_uV = 600000, .max_uV = 1587500, .min_sel = 0, .max_sel = 0x4f,
-	  .uV_step = 12500 },
-	{ .min_uV = 1600000, .max_uV = 1800000, .min_sel = 0x50,
-	  .max_sel = 0x54, .uV_step = 50000 },
+	{ .min_uV = 600000, .min_sel = 0, .max_sel = 0x4f, .uV_step = 12500 },
+	{ .min_uV = 1600000, .min_sel = 0x50, .max_sel = 0x54,
+	  .uV_step = 50000 },
 };
 
 /* BUCK 2~5 have same ranges. */
 static const struct regulator_linear_range buck2_5_volt_range[] = {
-	{ .min_uV = 600000, .max_uV = 1587500,	.min_sel = 0, .max_sel = 0x4f,
-	  .uV_step = 12500 },
-	{ .min_uV = 1600000, .max_uV = 3300000, .min_sel = 0x50,
-	  .max_sel = 0x72, .uV_step = 50000 },
+	{ .min_uV = 600000, .min_sel = 0, .max_sel = 0x4f, .uV_step = 12500 },
+	{ .min_uV = 1600000, .min_sel = 0x50, .max_sel = 0x72,
+	  .uV_step = 50000 },
 };
 
 static const unsigned int ldo1_volt_table[] = {
diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index fb27e6c..84c9ea0 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -117,26 +117,23 @@ static struct regulator_ops as3711_dldo_ops = {
 };
 
 static const struct regulator_linear_range as3711_sd_ranges[] = {
-	{ .min_uV = 612500, .max_uV = 1400000,
-	  .min_sel = 0x1, .max_sel = 0x40, .uV_step = 12500 },
-	{ .min_uV = 1425000, .max_uV = 2600000,
-	  .min_sel = 0x41, .max_sel = 0x70, .uV_step = 25000 },
-	{ .min_uV = 2650000, .max_uV = 3350000,
-	  .min_sel = 0x71, .max_sel = 0x7f, .uV_step = 50000 },
+	{ .min_uV = 612500, .min_sel = 0x1, .max_sel = 0x40, .uV_step = 12500 },
+	{ .min_uV = 1425000, .min_sel = 0x41, .max_sel = 0x70,
+	  .uV_step = 25000 },
+	{ .min_uV = 2650000, .min_sel = 0x71, .max_sel = 0x7f,
+	  .uV_step = 50000 },
 };
 
 static const struct regulator_linear_range as3711_aldo_ranges[] = {
-	{ .min_uV = 1200000, .max_uV = 1950000,
-	  .min_sel = 0, .max_sel = 0xf, .uV_step = 50000 },
-	{ .min_uV = 1800000, .max_uV = 3300000,
-	  .min_sel = 0x10, .max_sel = 0x1f, .uV_step = 100000 },
+	{ .min_uV = 1200000, .min_sel = 0, .max_sel = 0xf, .uV_step = 50000 },
+	{ .min_uV = 1800000, .min_sel = 0x10, .max_sel = 0x1f,
+	  .uV_step = 100000 },
 };
 
 static const struct regulator_linear_range as3711_dldo_ranges[] = {
-	{ .min_uV = 900000, .max_uV = 1700000,
-	  .min_sel = 0, .max_sel = 0x10, .uV_step = 50000 },
-	{ .min_uV = 1750000, .max_uV = 3300000,
-	  .min_sel = 0x20, .max_sel = 0x3f, .uV_step = 50000 },
+	{ .min_uV = 900000, .min_sel = 0, .max_sel = 0x10, .uV_step = 50000 },
+	{ .min_uV = 1750000, .min_sel = 0x20, .max_sel = 0x3f,
+	  .uV_step = 50000 },
 };
 
 #define AS3711_REG(_id, _en_reg, _en_bit, _vmask, _vshift, _min_uV, _max_uV, _sfx)	\
diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index d7b71a9..240ae6d 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -441,7 +441,6 @@ static struct regulator_ops as3722_ldo3_extcntrl_ops = {
 		.max_sel = _max_sel,					\
 		.uV_step = _step_uV,					\
 		.min_uV = _min_uV,					\
-		.max_uV = _min_uV + (_max_sel - _min_sel) * _step_uV,	\
 	}
 
 static const struct regulator_linear_range as3722_ldo_ranges[] = {
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index c61d96e..872e14a 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -253,10 +253,8 @@ static int da9034_set_dvc_voltage_sel(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range da9034_ldo12_ranges[] = {
-	{ .min_uV = 1700000, .max_uV = 2050000, .min_sel =  0, .max_sel = 7,
-	  .uV_step =  50000 },
-	{ .min_uV = 2700000, .max_uV = 3050000, .min_sel =  8, .max_sel = 15,
-	  .uV_step =  50000 },
+	{ .min_uV = 1700000, .min_sel =  0, .max_sel = 7, .uV_step =  50000 },
+	{ .min_uV = 2700000, .min_sel =  8, .max_sel = 15, .uV_step =  50000 },
 };
 
 static struct regulator_ops da903x_regulator_ldo_ops = {
diff --git a/drivers/regulator/helpers.c b/drivers/regulator/helpers.c
index 6e30df1..e221a27 100644
--- a/drivers/regulator/helpers.c
+++ b/drivers/regulator/helpers.c
@@ -284,9 +284,13 @@ int regulator_map_voltage_linear_range(struct regulator_dev *rdev,
 	}
 
 	for (i = 0; i < rdev->desc->n_linear_ranges; i++) {
+		int linear_max_uV;
+
 		range = &rdev->desc->linear_ranges[i];
+		linear_max_uV = range->min_uV +
+			(range->max_sel - range->min_sel) * range->uV_step;
 
-		if (!(min_uV <= range->max_uV && max_uV >= range->min_uV))
+		if (!(min_uV <= linear_max_uV && max_uV >= range->min_uV))
 			continue;
 
 		if (min_uV <= range->min_uV)
diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 8860379..baf2aec 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -52,25 +52,17 @@ static const unsigned int LDO1_VSEL_table[] = {
 };
 
 static const struct regulator_linear_range tps65217_uv1_ranges[] = {
-	{ .min_uV = 900000, .max_uV = 1500000, .min_sel =  0, .max_sel = 24,
-	  .uV_step = 25000 },
-	{ .min_uV = 1550000, .max_uV = 1800000, .min_sel = 25, .max_sel = 30,
-	  .uV_step = 50000 },
-	{ .min_uV = 1850000, .max_uV = 2900000, .min_sel = 31, .max_sel = 52,
-	  .uV_step = 50000 },
-	{ .min_uV = 3000000, .max_uV = 3200000, .min_sel = 53, .max_sel = 55,
-	  .uV_step = 100000 },
-	{ .min_uV = 3300000, .max_uV = 3300000, .min_sel = 56, .max_sel = 62,
-	  .uV_step = 0 },
+	{ .min_uV = 900000, .min_sel =  0, .max_sel = 24, .uV_step = 25000 },
+	{ .min_uV = 1550000, .min_sel = 25, .max_sel = 30, .uV_step = 50000 },
+	{ .min_uV = 1850000, .min_sel = 31, .max_sel = 52, .uV_step = 50000 },
+	{ .min_uV = 3000000, .min_sel = 53, .max_sel = 55, .uV_step = 100000 },
+	{ .min_uV = 3300000, .min_sel = 56, .max_sel = 62, .uV_step = 0 },
 };
 
 static const struct regulator_linear_range tps65217_uv2_ranges[] = {
-	{ .min_uV = 1500000, .max_uV = 1900000, .min_sel =  0, .max_sel = 8,
-	  .uV_step = 50000 },
-	{ .min_uV = 2000000, .max_uV = 2400000, .min_sel = 9, .max_sel = 13,
-	  .uV_step = 100000 },
-	{ .min_uV = 2450000, .max_uV = 3300000, .min_sel = 14, .max_sel = 31,
-	  .uV_step = 50000 },
+	{ .min_uV = 1500000, .min_sel =  0, .max_sel = 8, .uV_step = 50000 },
+	{ .min_uV = 2000000, .min_sel = 9, .max_sel = 13, .uV_step = 100000 },
+	{ .min_uV = 2450000, .min_sel = 14, .max_sel = 31, .uV_step = 50000 },
 };
 
 static int tps65217_pmic_enable(struct regulator_dev *dev)
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 1ed4d04..86bb109 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -119,12 +119,9 @@ struct tps65912_reg {
 };
 
 static const struct regulator_linear_range tps65912_ldo_ranges[] = {
-	{ .min_uV = 800000, .max_uV = 1600000, .min_sel =  0, .max_sel = 32,
-	  .uV_step = 25000 },
-	{ .min_uV = 1650000, .max_uV = 3000000, .min_sel = 33, .max_sel = 60,
-	  .uV_step = 50000 },
-	{ .min_uV = 3100000, .max_uV = 3300000, .min_sel = 61, .max_sel = 63,
-	  .uV_step = 100000 },
+	{ .min_uV = 800000, .min_sel =  0, .max_sel = 32, .uV_step = 25000 },
+	{ .min_uV = 1650000, .min_sel = 33, .max_sel = 60, .uV_step = 50000 },
+	{ .min_uV = 3100000, .min_sel = 61, .max_sel = 63, .uV_step = 100000 },
 };
 
 static int tps65912_get_range(struct tps65912_reg *pmic, int id)
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 482ebe8..afb1671 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -63,10 +63,8 @@ static irqreturn_t wm831x_ldo_uv_irq(int irq, void *data)
  */
 
 static const struct regulator_linear_range wm831x_gp_ldo_ranges[] = {
-	{ .min_uV =  900000, .max_uV = 1600000, .min_sel =  0, .max_sel = 14,
-	  .uV_step =  50000 },
-	{ .min_uV = 1700000, .max_uV = 3300000, .min_sel = 15, .max_sel = 31,
-	  .uV_step = 100000 },
+	{ .min_uV =  900000, .min_sel =  0, .max_sel = 14, .uV_step =  50000 },
+	{ .min_uV = 1700000, .min_sel = 15, .max_sel = 31, .uV_step = 100000 },
 };
 
 static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
@@ -320,10 +318,8 @@ static struct platform_driver wm831x_gp_ldo_driver = {
  */
 
 static const struct regulator_linear_range wm831x_aldo_ranges[] = {
-	{ .min_uV = 1000000, .max_uV = 1600000, .min_sel =  0, .max_sel = 12,
-	  .uV_step =  50000 },
-	{ .min_uV = 1700000, .max_uV = 3500000, .min_sel = 13, .max_sel = 31,
-	  .uV_step = 100000 },
+	{ .min_uV = 1000000, .min_sel =  0, .max_sel = 12, .uV_step =  50000 },
+	{ .min_uV = 1700000, .min_sel = 13, .max_sel = 31, .uV_step = 100000 },
 };
 
 static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 017e869..a00690a 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -543,10 +543,8 @@ static int wm8350_dcdc_set_suspend_mode(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range wm8350_ldo_ranges[] = {
-	{ .min_uV =  900000, .max_uV = 1650000, .min_sel =  0, .max_sel = 15,
-	  .uV_step =  50000 },
-	{ .min_uV = 1800000, .max_uV = 3300000, .min_sel = 16, .max_sel = 31,
-	  .uV_step = 100000 },
+	{ .min_uV =  900000, .min_sel =  0, .max_sel = 15, .uV_step =  50000 },
+	{ .min_uV = 1800000, .min_sel = 16, .max_sel = 31, .uV_step = 100000 },
 };
 
 static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 870b52f..60cc76c 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -20,10 +20,8 @@
 #include <linux/mfd/wm8400-private.h>
 
 static const struct regulator_linear_range wm8400_ldo_ranges[] = {
-	{ .min_uV =  900000, .max_uV = 1600000, .min_sel = 0, .max_sel = 14,
-	  .uV_step =  50000 },
-	{ .min_uV = 1700000, .max_uV = 3300000, .min_sel = 15, .max_sel = 31,
-	  .uV_step = 100000 },
+	{ .min_uV =  900000, .min_sel = 0, .max_sel = 14, .uV_step =  50000 },
+	{ .min_uV = 1700000, .min_sel = 15, .max_sel = 31, .uV_step = 100000 },
 };
 
 static struct regulator_ops wm8400_ldo_ops = {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index c8b492c..a9b3e26 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -46,14 +46,12 @@ enum regulator_status {
  * regulator_list_linear_range().
  *
  * @min_uV:  Lowest voltage in range
- * @max_uV:  Highest voltage in range
  * @min_sel: Lowest selector for range
  * @max_sel: Highest selector for range
  * @uV_step: Step size
  */
 struct regulator_linear_range {
 	unsigned int min_uV;
-	unsigned int max_uV;
 	unsigned int min_sel;
 	unsigned int max_sel;
 	unsigned int uV_step;
-- 
1.8.1.2



