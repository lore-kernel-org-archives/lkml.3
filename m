Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3JKBcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:32:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58492 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3JKBcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:32:23 -0400
Message-ID: <1381455138.4296.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: Add REGULATOR_LINEAR_RANGE macro
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Margarita Olaya <magi@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 09:32:18 +0800
In-Reply-To: <1381455024.4296.1.camel@phoenix>
References: <1381455024.4296.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add REGULATOR_LINEAR_RANGE macro and convert regulator drivers to use it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Yi Zhang <yizhang@marvell.com>
Cc: Chao Xie <chao.xie@marvell.com>
Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Margarita Olaya <magi@slimlogic.co.uk>
---
 drivers/regulator/88pm800.c            | 10 ++++------
 drivers/regulator/as3711-regulator.c   | 18 +++++++-----------
 drivers/regulator/as3722-regulator.c   | 18 +++++-------------
 drivers/regulator/da903x.c             |  4 ++--
 drivers/regulator/tps65217-regulator.c | 16 ++++++++--------
 drivers/regulator/tps65912-regulator.c |  6 +++---
 drivers/regulator/wm831x-ldo.c         |  8 ++++----
 drivers/regulator/wm8350-regulator.c   |  4 ++--
 drivers/regulator/wm8400-regulator.c   |  4 ++--
 include/linux/regulator/driver.h       |  9 +++++++++
 10 files changed, 46 insertions(+), 51 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index 22ba4c4..d333f7e 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -141,16 +141,14 @@ struct pm800_regulators {
 
 /* Ranges are sorted in ascending order. */
 static const struct regulator_linear_range buck1_volt_range[] = {
-	{ .min_uV = 600000, .min_sel = 0, .max_sel = 0x4f, .uV_step = 12500 },
-	{ .min_uV = 1600000, .min_sel = 0x50, .max_sel = 0x54,
-	  .uV_step = 50000 },
+	REGULATOR_LINEAR_RANGE(600000, 0, 0x4f, 12500),
+	REGULATOR_LINEAR_RANGE(1600000, 0x50, 0x54, 50000),
 };
 
 /* BUCK 2~5 have same ranges. */
 static const struct regulator_linear_range buck2_5_volt_range[] = {
-	{ .min_uV = 600000, .min_sel = 0, .max_sel = 0x4f, .uV_step = 12500 },
-	{ .min_uV = 1600000, .min_sel = 0x50, .max_sel = 0x72,
-	  .uV_step = 50000 },
+	REGULATOR_LINEAR_RANGE(600000, 0, 0x4f, 12500),
+	REGULATOR_LINEAR_RANGE(1600000, 0x50, 0x72, 50000),
 };
 
 static const unsigned int ldo1_volt_table[] = {
diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 84c9ea0..c77a584 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -117,23 +117,19 @@ static struct regulator_ops as3711_dldo_ops = {
 };
 
 static const struct regulator_linear_range as3711_sd_ranges[] = {
-	{ .min_uV = 612500, .min_sel = 0x1, .max_sel = 0x40, .uV_step = 12500 },
-	{ .min_uV = 1425000, .min_sel = 0x41, .max_sel = 0x70,
-	  .uV_step = 25000 },
-	{ .min_uV = 2650000, .min_sel = 0x71, .max_sel = 0x7f,
-	  .uV_step = 50000 },
+	REGULATOR_LINEAR_RANGE(612500, 0x1, 0x40, 12500),
+	REGULATOR_LINEAR_RANGE(1425000, 0x41, 0x70, 25000),
+	REGULATOR_LINEAR_RANGE(2650000, 0x71, 0x7f, 50000),
 };
 
 static const struct regulator_linear_range as3711_aldo_ranges[] = {
-	{ .min_uV = 1200000, .min_sel = 0, .max_sel = 0xf, .uV_step = 50000 },
-	{ .min_uV = 1800000, .min_sel = 0x10, .max_sel = 0x1f,
-	  .uV_step = 100000 },
+	REGULATOR_LINEAR_RANGE(1200000, 0, 0xf, 50000),
+	REGULATOR_LINEAR_RANGE(1800000, 0x10, 0x1f, 100000),
 };
 
 static const struct regulator_linear_range as3711_dldo_ranges[] = {
-	{ .min_uV = 900000, .min_sel = 0, .max_sel = 0x10, .uV_step = 50000 },
-	{ .min_uV = 1750000, .min_sel = 0x20, .max_sel = 0x3f,
-	  .uV_step = 50000 },
+	REGULATOR_LINEAR_RANGE(900000, 0, 0x10, 50000),
+	REGULATOR_LINEAR_RANGE(1750000, 0x20, 0x3f, 50000),
 };
 
 #define AS3711_REG(_id, _en_reg, _en_bit, _vmask, _vshift, _min_uV, _max_uV, _sfx)	\
diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 240ae6d..5917fe3 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -435,17 +435,9 @@ static struct regulator_ops as3722_ldo3_extcntrl_ops = {
 	.get_current_limit = as3722_ldo3_get_current_limit,
 };
 
-#define regulator_lin_range(_min_sel, _max_sel, _min_uV, _step_uV)	\
-	{								\
-		.min_sel = _min_sel,					\
-		.max_sel = _max_sel,					\
-		.uV_step = _step_uV,					\
-		.min_uV = _min_uV,					\
-	}
-
 static const struct regulator_linear_range as3722_ldo_ranges[] = {
-	regulator_lin_range(0x01, 0x24,  825000, 25000),
-	regulator_lin_range(0x40, 0x7F, 1725000, 25000),
+	REGULATOR_LINEAR_RANGE(825000, 0x01, 0x24, 25000),
+	REGULATOR_LINEAR_RANGE(1725000, 0x40, 0x7F, 25000),
 };
 
 static struct regulator_ops as3722_ldo_ops = {
@@ -604,9 +596,9 @@ static int as3722_sd016_set_current_limit(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range as3722_sd2345_ranges[] = {
-	regulator_lin_range(0x01, 0x40,  612500, 12500),
-	regulator_lin_range(0x41, 0x70, 1425000, 25000),
-	regulator_lin_range(0x71, 0x7F, 2650000, 50000),
+	REGULATOR_LINEAR_RANGE(612500, 0x01, 0x40, 12500),
+	REGULATOR_LINEAR_RANGE(1425000, 0x41, 0x70, 25000),
+	REGULATOR_LINEAR_RANGE(2650000, 0x71, 0x7F, 50000),
 };
 
 static struct regulator_ops as3722_sd016_ops = {
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 872e14a..b431ae3 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -253,8 +253,8 @@ static int da9034_set_dvc_voltage_sel(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range da9034_ldo12_ranges[] = {
-	{ .min_uV = 1700000, .min_sel =  0, .max_sel = 7, .uV_step =  50000 },
-	{ .min_uV = 2700000, .min_sel =  8, .max_sel = 15, .uV_step =  50000 },
+	REGULATOR_LINEAR_RANGE(1700000, 0, 7, 50000),
+	REGULATOR_LINEAR_RANGE(2700000, 8, 15, 50000),
 };
 
 static struct regulator_ops da903x_regulator_ldo_ops = {
diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index baf2aec..9ea1bf2 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -52,17 +52,17 @@ static const unsigned int LDO1_VSEL_table[] = {
 };
 
 static const struct regulator_linear_range tps65217_uv1_ranges[] = {
-	{ .min_uV = 900000, .min_sel =  0, .max_sel = 24, .uV_step = 25000 },
-	{ .min_uV = 1550000, .min_sel = 25, .max_sel = 30, .uV_step = 50000 },
-	{ .min_uV = 1850000, .min_sel = 31, .max_sel = 52, .uV_step = 50000 },
-	{ .min_uV = 3000000, .min_sel = 53, .max_sel = 55, .uV_step = 100000 },
-	{ .min_uV = 3300000, .min_sel = 56, .max_sel = 62, .uV_step = 0 },
+	REGULATOR_LINEAR_RANGE(900000, 0, 24, 25000),
+	REGULATOR_LINEAR_RANGE(1550000, 25, 30, 50000),
+	REGULATOR_LINEAR_RANGE(1850000, 31, 52, 50000),
+	REGULATOR_LINEAR_RANGE(3000000, 53, 55, 100000),
+	REGULATOR_LINEAR_RANGE(3300000, 56, 62, 0),
 };
 
 static const struct regulator_linear_range tps65217_uv2_ranges[] = {
-	{ .min_uV = 1500000, .min_sel =  0, .max_sel = 8, .uV_step = 50000 },
-	{ .min_uV = 2000000, .min_sel = 9, .max_sel = 13, .uV_step = 100000 },
-	{ .min_uV = 2450000, .min_sel = 14, .max_sel = 31, .uV_step = 50000 },
+	REGULATOR_LINEAR_RANGE(1500000, 0, 8, 50000),
+	REGULATOR_LINEAR_RANGE(2000000, 9, 13, 100000),
+	REGULATOR_LINEAR_RANGE(2450000, 14, 31, 50000),
 };
 
 static int tps65217_pmic_enable(struct regulator_dev *dev)
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 86bb109..9cafaa0 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -119,9 +119,9 @@ struct tps65912_reg {
 };
 
 static const struct regulator_linear_range tps65912_ldo_ranges[] = {
-	{ .min_uV = 800000, .min_sel =  0, .max_sel = 32, .uV_step = 25000 },
-	{ .min_uV = 1650000, .min_sel = 33, .max_sel = 60, .uV_step = 50000 },
-	{ .min_uV = 3100000, .min_sel = 61, .max_sel = 63, .uV_step = 100000 },
+	REGULATOR_LINEAR_RANGE(800000, 0, 32, 25000),
+	REGULATOR_LINEAR_RANGE(1650000, 33, 60, 50000),
+	REGULATOR_LINEAR_RANGE(3100000, 61, 63, 100000),
 };
 
 static int tps65912_get_range(struct tps65912_reg *pmic, int id)
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index afb1671..46d6700 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -63,8 +63,8 @@ static irqreturn_t wm831x_ldo_uv_irq(int irq, void *data)
  */
 
 static const struct regulator_linear_range wm831x_gp_ldo_ranges[] = {
-	{ .min_uV =  900000, .min_sel =  0, .max_sel = 14, .uV_step =  50000 },
-	{ .min_uV = 1700000, .min_sel = 15, .max_sel = 31, .uV_step = 100000 },
+	REGULATOR_LINEAR_RANGE(900000, 0, 14, 50000),
+	REGULATOR_LINEAR_RANGE(1700000, 15, 31, 100000),
 };
 
 static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
@@ -318,8 +318,8 @@ static struct platform_driver wm831x_gp_ldo_driver = {
  */
 
 static const struct regulator_linear_range wm831x_aldo_ranges[] = {
-	{ .min_uV = 1000000, .min_sel =  0, .max_sel = 12, .uV_step =  50000 },
-	{ .min_uV = 1700000, .min_sel = 13, .max_sel = 31, .uV_step = 100000 },
+	REGULATOR_LINEAR_RANGE(1000000, 0, 12, 50000),
+	REGULATOR_LINEAR_RANGE(1700000, 13, 31, 100000),
 };
 
 static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index a00690a..de7b9c7 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -543,8 +543,8 @@ static int wm8350_dcdc_set_suspend_mode(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range wm8350_ldo_ranges[] = {
-	{ .min_uV =  900000, .min_sel =  0, .max_sel = 15, .uV_step =  50000 },
-	{ .min_uV = 1800000, .min_sel = 16, .max_sel = 31, .uV_step = 100000 },
+	REGULATOR_LINEAR_RANGE(900000, 0, 15, 50000),
+	REGULATOR_LINEAR_RANGE(1800000, 16, 31, 100000),
 };
 
 static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 60cc76c..82d8290 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -20,8 +20,8 @@
 #include <linux/mfd/wm8400-private.h>
 
 static const struct regulator_linear_range wm8400_ldo_ranges[] = {
-	{ .min_uV =  900000, .min_sel = 0, .max_sel = 14, .uV_step =  50000 },
-	{ .min_uV = 1700000, .min_sel = 15, .max_sel = 31, .uV_step = 100000 },
+	REGULATOR_LINEAR_RANGE(900000, 0, 14, 50000),
+	REGULATOR_LINEAR_RANGE(1700000, 15, 31, 100000),
 };
 
 static struct regulator_ops wm8400_ldo_ops = {
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index a9b3e26..9370e65 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -57,6 +57,15 @@ struct regulator_linear_range {
 	unsigned int uV_step;
 };
 
+/* Initialize struct regulator_linear_range */
+#define REGULATOR_LINEAR_RANGE(_min_uV, _min_sel, _max_sel, _step_uV)	\
+{									\
+	.min_uV		= _min_uV,					\
+	.min_sel	= _min_sel,					\
+	.max_sel	= _max_sel,					\
+	.uV_step	= _step_uV,					\
+}
+
 /**
  * struct regulator_ops - regulator operations.
  *
-- 
1.8.1.2



