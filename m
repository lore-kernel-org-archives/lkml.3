Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaGNKeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:34:08 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11696 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaGNKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:34:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Jul 2014 03:22:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <support.opensource@diasemi.com>, <milo.kim@ti.com>,
        <linux-kernel@vger.kernel.org>, <patches@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: drivers: fix return value of get_mode callback
Date: Mon, 14 Jul 2014 16:03:17 +0530
Message-ID: <1405333997-28764-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function get_mode() should return 0 on error and REGULATOR_MODE_*
on success. The return type of this function is defined as unsigned int.

Some of driver who implements this callback return -ve error number when
it fails which is incorrect as per function definitions. Correcting the
implemnetation on different drivers to return 0 (zero) on error and
REGULATOR_MODE_* on success.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/ab8500-ext.c         | 4 ++--
 drivers/regulator/ab8500.c             | 4 ++--
 drivers/regulator/as3711-regulator.c   | 4 ++--
 drivers/regulator/as3722-regulator.c   | 4 ++--
 drivers/regulator/da9055-regulator.c   | 4 ++--
 drivers/regulator/da9063-regulator.c   | 2 +-
 drivers/regulator/fan53555.c           | 2 +-
 drivers/regulator/lp872x.c             | 4 ++--
 drivers/regulator/lp8788-buck.c        | 2 +-
 drivers/regulator/max8649.c            | 2 +-
 drivers/regulator/max8973-regulator.c  | 2 +-
 drivers/regulator/mc13892-regulator.c  | 2 +-
 drivers/regulator/tps62360-regulator.c | 2 +-
 drivers/regulator/tps65910-regulator.c | 4 ++--
 drivers/regulator/tps65912-regulator.c | 2 +-
 drivers/regulator/wm831x-dcdc.c        | 4 ++--
 drivers/regulator/wm831x-ldo.c         | 8 ++++----
 drivers/regulator/wm8350-regulator.c   | 2 +-
 18 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 29c0faa..42afcb9 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -218,7 +218,7 @@ static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
 
 	if (info == NULL) {
 		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
+		return 0;
 	}
 
 	if (info->update_val == info->update_val_hp)
@@ -226,7 +226,7 @@ static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
 	else if (info->update_val == info->update_val_lp)
 		ret = REGULATOR_MODE_IDLE;
 	else
-		ret = -EINVAL;
+		ret = 0;
 
 	return ret;
 }
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 1fda14e..b85f597 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -440,7 +440,7 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 
 	if (info == NULL) {
 		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
+		return 0;
 	}
 
 	/* Need special handling for shared mode */
@@ -471,7 +471,7 @@ static unsigned int ab8500_regulator_get_mode(struct regulator_dev *rdev)
 	else if (val == val_idle)
 		ret = REGULATOR_MODE_IDLE;
 	else
-		ret = -EINVAL;
+		ret = 0;
 
 	return ret;
 }
diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index b47283f..8fcc8ef 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -70,7 +70,7 @@ static unsigned int as3711_get_mode_sd(struct regulator_dev *rdev)
 	int ret = regmap_read(rdev->regmap, AS3711_SD_CONTROL_1, &val);
 
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	if ((val & mask) == mask)
 		return REGULATOR_MODE_FAST;
@@ -81,7 +81,7 @@ static unsigned int as3711_get_mode_sd(struct regulator_dev *rdev)
 	if (!(val & mask))
 		return REGULATOR_MODE_IDLE;
 
-	return -EINVAL;
+	return 0;
 }
 
 static struct regulator_ops as3711_sd_ops = {
diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index b68f05f..44d6dea 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -468,13 +468,13 @@ static unsigned int as3722_sd_get_mode(struct regulator_dev *rdev)
 	int ret;
 
 	if (!as3722_reg_lookup[id].control_reg)
-		return -ENOTSUPP;
+		return 0;
 
 	ret = as3722_read(as3722, as3722_reg_lookup[id].control_reg, &val);
 	if (ret < 0) {
 		dev_err(as3722_regs->dev, "Reg 0x%02x read failed: %d\n",
 			as3722_reg_lookup[id].control_reg, ret);
-		return ret;
+		return 0;
 	}
 
 	if (val & as3722_reg_lookup[id].mode_mask)
diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 9516317..cc2e746 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -90,7 +90,7 @@ static unsigned int da9055_buck_get_mode(struct regulator_dev *rdev)
 
 	ret = da9055_reg_read(regulator->da9055, info->mode.reg);
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	switch ((ret & info->mode.mask) >> info->mode.shift) {
 	case DA9055_BUCK_MODE_SYNC:
@@ -138,7 +138,7 @@ static unsigned int da9055_ldo_get_mode(struct regulator_dev *rdev)
 
 	ret = da9055_reg_read(regulator->da9055, info->volt.reg_b);
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	if (ret >> info->volt.sl_shift)
 		return REGULATOR_MODE_STANDBY;
diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 7c9461d..6275e00 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -233,7 +233,7 @@ static unsigned da9063_buck_get_mode(struct regulator_dev *rdev)
 
 	ret = regmap_field_read(regl->mode, &val);
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	switch (val) {
 	default:
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 714fd9a..bb5cc0e 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -128,7 +128,7 @@ static unsigned int fan53555_get_mode(struct regulator_dev *rdev)
 
 	ret = regmap_read(di->regmap, di->vol_reg, &val);
 	if (ret < 0)
-		return ret;
+		return 0;
 	if (val & VSEL_MODE)
 		return REGULATOR_MODE_FAST;
 	else
diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 2e022aa..8229561b 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -469,12 +469,12 @@ static unsigned int lp872x_buck_get_mode(struct regulator_dev *rdev)
 		mask = LP8725_BUCK2_FPWM_M;
 		break;
 	default:
-		return -EINVAL;
+		return 0;
 	}
 
 	ret = lp872x_read_byte(lp, addr, &val);
 	if (ret)
-		return ret;
+		return 0;
 
 	return val & mask ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
 }
diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 948afc2..d28c5f4 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -338,7 +338,7 @@ static unsigned int lp8788_buck_get_mode(struct regulator_dev *rdev)
 
 	ret = lp8788_read_byte(buck->lp, LP8788_BUCK_PWM, &val);
 	if (ret)
-		return ret;
+		return 0;
 
 	return val & BUCK_FPWM_MASK(id) ?
 				REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index c8bddcc..f3519ca 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -109,7 +109,7 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 
 	ret = regmap_read(info->regmap, rdev->desc->vsel_reg, &val);
 	if (ret != 0)
-		return ret;
+		return 0;
 	if (val & MAX8649_FORCE_PWM)
 		return REGULATOR_MODE_FAST;
 	return REGULATOR_MODE_NORMAL;
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index dbedf17..c4a4cdc2 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -236,7 +236,7 @@ static unsigned int max8973_dcdc_get_mode(struct regulator_dev *rdev)
 	if (ret < 0) {
 		dev_err(max->dev, "register %d read failed, err %d\n",
 				MAX8973_CONTROL1, ret);
-		return ret;
+		return 0;
 	}
 	return (data & MAX8973_FPWM_EN_M) ?
 		REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index f374fa5..fc3ed75 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -518,7 +518,7 @@ static unsigned int mc13892_vcam_get_mode(struct regulator_dev *rdev)
 	mc13xxx_unlock(priv->mc13xxx);
 
 	if (ret)
-		return ret;
+		return 0;
 
 	if (val & MC13892_REGULATORMODE1_VCAMCONFIGEN)
 		return REGULATOR_MODE_FAST;
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index a167204..42954f9 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -227,7 +227,7 @@ static unsigned int tps62360_get_mode(struct regulator_dev *rdev)
 	if (ret < 0) {
 		dev_err(tps->dev, "%s(): register %d read failed with err %d\n",
 			__func__, REG_VSET0 + tps->curr_vset_id, ret);
-		return ret;
+		return 0;
 	}
 	return (data & FORCE_PWM_ENABLE) ?
 				REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index fa7db88..752e0ca 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -423,11 +423,11 @@ static unsigned int tps65910_get_mode(struct regulator_dev *dev)
 
 	reg = pmic->get_ctrl_reg(id);
 	if (reg < 0)
-		return reg;
+		return 0;
 
 	ret = tps65910_reg_read(pmic->mfd, reg, &value);
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	if (!(value & LDO_ST_ON_BIT))
 		return REGULATOR_MODE_STANDBY;
diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index 9cafaa0..319f1bb 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -241,7 +241,7 @@ static int tps65912_get_mode_regiters(struct tps65912_reg *pmic, int id)
 		pmic->eco_reg = TPS65912_DCDC4_AVS;
 		break;
 	default:
-		return -EINVAL;
+		return 0;
 	}
 
 	return 0;
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 0d88a82..0188def 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -71,7 +71,7 @@ static unsigned int wm831x_dcdc_get_mode(struct regulator_dev *rdev)
 
 	val = wm831x_reg_read(wm831x, reg);
 	if (val < 0)
-		return val;
+		return 0;
 
 	val = (val & WM831X_DC1_ON_MODE_MASK) >> WM831X_DC1_ON_MODE_SHIFT;
 
@@ -86,7 +86,7 @@ static unsigned int wm831x_dcdc_get_mode(struct regulator_dev *rdev)
 		return REGULATOR_MODE_IDLE;
 	default:
 		BUG();
-		return -EINVAL;
+		return 0;
 	}
 }
 
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index eca0eeb..16a5692 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -91,14 +91,14 @@ static unsigned int wm831x_gp_ldo_get_mode(struct regulator_dev *rdev)
 
 	ret = wm831x_reg_read(wm831x, on_reg);
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	if (!(ret & WM831X_LDO1_ON_MODE))
 		return REGULATOR_MODE_NORMAL;
 
 	ret = wm831x_reg_read(wm831x, ctrl_reg);
 	if (ret < 0)
-		return ret;
+		return 0;
 
 	if (ret & WM831X_LDO1_LP_MODE)
 		return REGULATOR_MODE_STANDBY;
@@ -180,8 +180,8 @@ static int wm831x_gp_ldo_get_status(struct regulator_dev *rdev)
 		return REGULATOR_STATUS_ERROR;
 
 	ret = wm831x_gp_ldo_get_mode(rdev);
-	if (ret < 0)
-		return ret;
+	if (!ret)
+		return -EINVAL;
 	else
 		return regulator_mode_to_status(ret);
 }
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 7ec7c39..b76d51d 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -855,7 +855,7 @@ static unsigned int wm8350_dcdc_get_mode(struct regulator_dev *rdev)
 		reg = WM8350_DCDC6_FORCE_PWM;
 		break;
 	default:
-		return -EINVAL;
+		return 0;
 	}
 
 	mask = 1 << (dcdc - WM8350_DCDC_1);
-- 
1.8.1.5

