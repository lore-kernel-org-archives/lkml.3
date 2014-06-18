Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaFRXw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:52:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18757 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbaFRXwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:52:32 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-29-53a2263d20bd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCHv7 2/4] regulator: s2mps11: Add support S2MPU02 regulator device
Date: Thu, 19 Jun 2014 08:52:23 +0900
Message-id: <1403135545-7451-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
References: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSoGurtijYYP8FMYupD5+wWVz/8pzV
	ovPsE2aLs01v2C3ufz3KaHF51xw2i9uNK9gsTnezWlxc8YXJgdNj06pONo871/awecw7GejR
	t2UVo8fnTXIBrFFcNimpOZllqUX6dglcGWd3rmMt+N7EWPFzy3a2BsbtOV2MnBwSAiYSpx+v
	ZoKwxSQu3FvP1sXIxSEksJRR4v3jZ2wwRdcXvWWCSCxilPh8ZysrhNPEJLFzEUQ7m4CWxP4X
	N8A6RASiJOYu/A42illgOaPEm6nPGbsYOTiEBfwlNi7UAKlhEVCVeDnlHCuIzSvgIrG58To7
	xDY5iQ97HoHZnAKuEq/+PGYBsYWAan49agBbLCGwjl3iwJ5GdohBAhLfJh9iAZkvISArsekA
	M8QcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMPRP/3s2cQfj/QPW
	hxiTgcZNZJYSTc4Hxk5eSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTAu630R7bfzZFnH4uXBrw4ed69viDTui4mZ4q51O19pyePpR2RlFm3evzVQ
	JPjBAs1e2f37jrnGHAxcfER2fTDnEts8r8sCZWdnxfzs3y/0fd+3CJH4K2vfH2lLnTb7wdx9
	D9YtKW1NueoR2rtT6Mjn77HiBS+WXzqsfuff3NOyn24LRW6x8f/CrMRSnJFoqMVcVJwIABws
	RKmTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV1btUXBBvuWcFtMffiEzeL6l+es
	Fp1nnzBbnG16w25x/+tRRovLu+awWdxuXMFmcbqb1eLiii9MDpwem1Z1snncubaHzWPeyUCP
	vi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxduc61oLv
	TYwVP7dsZ2tg3J7TxcjJISFgInF90VsmCFtM4sK99WxdjFwcQgKLGCU+39nKCuE0MUnsXLQa
	rIpNQEti/4sbbCC2iECUxNyF38E6mAWWM0q8mfqcsYuRg0NYwF9i40INkBoWAVWJl1POsYLY
	vAIuEpsbr7NDbJOT+LDnEZjNKeAq8erPYxYQWwio5tejBtYJjLwLGBlWMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgRH1jPpHYyrGiwOMQpwMCrx8K5UXRQsxJpYVlyZe4hRgoNZSYRX/tfC
	YCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB0Z9Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1ut
	A4UE0hNLUrNTUwtSi2C2MHFwSjUwph8U/sCi52924n2df/Ok3LMXAx/f37Yv9s5NF9nrlmxb
	olk0rn1tWHatmkW36NFpp0i1H/V3/j4S+L9Z0GevifwPMb5HopyyHwu0eUvN67eJs2yT+Z++
	6Uy8asS8ngMTzXOnSgbL7n6+gmHxqgCRZzZrzp7f/+9FzGMZiZZPk1YsP3rRml30ghJLcUai
	oRZzUXEiAFT/jCbwAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add S2MPU02 regulator device to existing S2MPS11 device driver
because of little difference between S2MPS1x and S2MPU02. The S2MPU02
regulator device includes LDO[1-28] and BUCK[1-7].

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[Add missing linear_min_sel of S2MPU02 LDO regulators by Jonghwa Lee]
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Mark Brown <broonie@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-core.c      |  25 ++++
 drivers/regulator/s2mps11.c | 321 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 325 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 15ba847..2621328 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/samsung/s2mpa01.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
+#include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/regmap.h>
@@ -144,6 +145,18 @@ static bool s2mps11_volatile(struct device *dev, unsigned int reg)
 	}
 }
 
+static bool s2mpu02_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case S2MPU02_REG_INT1M:
+	case S2MPU02_REG_INT2M:
+	case S2MPU02_REG_INT3M:
+		return false;
+	default:
+		return true;
+	}
+}
+
 static bool s5m8763_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -189,6 +202,15 @@ static const struct regmap_config s2mps14_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
+static const struct regmap_config s2mpu02_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPU02_REG_DVSDATA,
+	.volatile_reg = s2mpu02_volatile,
+	.cache_type = REGCACHE_FLAT,
+};
+
 static const struct regmap_config s5m8763_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -310,6 +332,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	case S5M8767X:
 		regmap = &s5m8767_regmap_config;
 		break;
+	case S2MPU02:
+		regmap = &s2mpu02_regmap_config;
+		break;
 	default:
 		regmap = &sec_regmap_config;
 		break;
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 02e2fb2..2daacc6 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s2mps14.h>
+#include <linux/mfd/samsung/s2mpu02.h>
 
 struct s2mps11_info {
 	unsigned int rdev_num;
@@ -40,11 +41,15 @@ struct s2mps11_info {
 	int ramp_delay16;
 	int ramp_delay7810;
 	int ramp_delay9;
+
+	enum sec_device_type dev_type;
+
 	/*
-	 * One bit for each S2MPS14 regulator whether the suspend mode
+	 * One bit for each S2MPS14/S2MPU02 regulator whether the suspend mode
 	 * was enabled.
 	 */
-	unsigned int s2mps14_suspend_state:30;
+	unsigned long long s2mps14_suspend_state:35;
+
 	/* Array of size rdev_num with GPIO-s for external sleep control */
 	int *ext_control_gpio;
 };
@@ -415,12 +420,24 @@ static int s2mps14_regulator_enable(struct regulator_dev *rdev)
 	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
 	unsigned int val;
 
-	if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
-		val = S2MPS14_ENABLE_SUSPEND;
-	else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
-		val = S2MPS14_ENABLE_EXT_CONTROL;
-	else
-		val = rdev->desc->enable_mask;
+	switch (s2mps11->dev_type) {
+	case S2MPS14X:
+		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
+			val = S2MPS14_ENABLE_SUSPEND;
+		else if (gpio_is_valid(s2mps11->ext_control_gpio[rdev_get_id(rdev)]))
+			val = S2MPS14_ENABLE_EXT_CONTROL;
+		else
+			val = rdev->desc->enable_mask;
+		break;
+	case S2MPU02:
+		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
+			val = S2MPU02_ENABLE_SUSPEND;
+		else
+			val = rdev->desc->enable_mask;
+		break;
+	default:
+		return -EINVAL;
+	};
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 			rdev->desc->enable_mask, val);
@@ -429,12 +446,38 @@ static int s2mps14_regulator_enable(struct regulator_dev *rdev)
 static int s2mps14_regulator_set_suspend_disable(struct regulator_dev *rdev)
 {
 	int ret;
-	unsigned int val;
+	unsigned int val, state;
 	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	int rdev_id = rdev_get_id(rdev);
 
-	/* LDO3 should be always on and does not support suspend mode */
-	if (rdev_get_id(rdev) == S2MPS14_LDO3)
-		return 0;
+	/* Below LDO should be always on or does not support suspend mode. */
+	switch (s2mps11->dev_type) {
+	case S2MPS14X:
+		switch (rdev_id) {
+		case S2MPS14_LDO3:
+			return 0;
+		default:
+			state = S2MPS14_ENABLE_SUSPEND;
+			break;
+		};
+		break;
+	case S2MPU02:
+		switch (rdev_id) {
+		case S2MPU02_LDO13:
+		case S2MPU02_LDO14:
+		case S2MPU02_LDO15:
+		case S2MPU02_LDO17:
+		case S2MPU02_BUCK7:
+			state = S2MPU02_DISABLE_SUSPEND;
+			break;
+		default:
+			state = S2MPU02_ENABLE_SUSPEND;
+			break;
+		};
+		break;
+	default:
+		return -EINVAL;
+	};
 
 	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
 	if (ret < 0)
@@ -452,7 +495,7 @@ static int s2mps14_regulator_set_suspend_disable(struct regulator_dev *rdev)
 		return 0;
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
-			rdev->desc->enable_mask, S2MPS14_ENABLE_SUSPEND);
+			rdev->desc->enable_mask, state);
 }
 
 static struct regulator_ops s2mps14_reg_ops = {
@@ -605,8 +648,7 @@ static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 }
 
 static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
-		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11,
-		enum sec_device_type dev_type)
+		struct of_regulator_match *rdata, struct s2mps11_info *s2mps11)
 {
 	struct device_node *reg_np;
 
@@ -617,7 +659,7 @@ static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
 	}
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, s2mps11->rdev_num);
-	if (dev_type == S2MPS14X)
+	if (s2mps11->dev_type == S2MPS14X)
 		s2mps14_pmic_dt_parse_ext_control_gpio(pdev, rdata, s2mps11);
 
 	of_node_put(reg_np);
@@ -625,6 +667,238 @@ static int s2mps11_pmic_dt_parse(struct platform_device *pdev,
 	return 0;
 }
 
+static int s2mpu02_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
+{
+	unsigned int ramp_val, ramp_shift, ramp_reg;
+
+	switch (rdev_get_id(rdev)) {
+	case S2MPU02_BUCK1:
+		ramp_shift = S2MPU02_BUCK1_RAMP_SHIFT;
+		break;
+	case S2MPU02_BUCK2:
+		ramp_shift = S2MPU02_BUCK2_RAMP_SHIFT;
+		break;
+	case S2MPU02_BUCK3:
+		ramp_shift = S2MPU02_BUCK3_RAMP_SHIFT;
+		break;
+	case S2MPU02_BUCK4:
+		ramp_shift = S2MPU02_BUCK4_RAMP_SHIFT;
+		break;
+	default:
+		return 0;
+	}
+	ramp_reg = S2MPU02_REG_RAMP1;
+	ramp_val = get_ramp_delay(ramp_delay);
+
+	return regmap_update_bits(rdev->regmap, ramp_reg,
+				  S2MPU02_BUCK1234_RAMP_MASK << ramp_shift,
+				  ramp_val << ramp_shift);
+}
+
+static struct regulator_ops s2mpu02_ldo_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= s2mps14_regulator_enable,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_disable	= s2mps14_regulator_set_suspend_disable,
+};
+
+static struct regulator_ops s2mpu02_buck_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= s2mps14_regulator_enable,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_suspend_disable	= s2mps14_regulator_set_suspend_disable,
+	.set_ramp_delay		= s2mpu02_set_ramp_delay,
+};
+
+#define regulator_desc_s2mpu02_ldo1(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPU02_LDO##num,		\
+	.ops		= &s2mpu02_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPU02_LDO_MIN_900MV,	\
+	.uV_step	= S2MPU02_LDO_STEP_12_5MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP1_START_SEL,	\
+	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPU02_REG_L1CTRL,		\
+	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPU02_REG_L1CTRL,		\
+	.enable_mask	= S2MPU02_ENABLE_MASK		\
+}
+#define regulator_desc_s2mpu02_ldo2(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPU02_LDO##num,		\
+	.ops		= &s2mpu02_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPU02_LDO_MIN_1050MV,	\
+	.uV_step	= S2MPU02_LDO_STEP_25MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP2_START_SEL,	\
+	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPU02_REG_L2CTRL1,		\
+	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPU02_REG_L2CTRL1,		\
+	.enable_mask	= S2MPU02_ENABLE_MASK		\
+}
+#define regulator_desc_s2mpu02_ldo3(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPU02_LDO##num,		\
+	.ops		= &s2mpu02_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPU02_LDO_MIN_900MV,	\
+	.uV_step	= S2MPU02_LDO_STEP_12_5MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP1_START_SEL,	\
+	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
+	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
+	.enable_mask	= S2MPU02_ENABLE_MASK		\
+}
+#define regulator_desc_s2mpu02_ldo4(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPU02_LDO##num,		\
+	.ops		= &s2mpu02_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPU02_LDO_MIN_1050MV,	\
+	.uV_step	= S2MPU02_LDO_STEP_25MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP2_START_SEL,	\
+	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
+	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
+	.enable_mask	= S2MPU02_ENABLE_MASK		\
+}
+#define regulator_desc_s2mpu02_ldo5(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPU02_LDO##num,		\
+	.ops		= &s2mpu02_ldo_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPU02_LDO_MIN_1600MV,	\
+	.uV_step	= S2MPU02_LDO_STEP_50MV,	\
+	.linear_min_sel	= S2MPU02_LDO_GROUP3_START_SEL,	\
+	.n_voltages	= S2MPU02_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
+	.vsel_mask	= S2MPU02_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPU02_REG_L3CTRL + num - 3,	\
+	.enable_mask	= S2MPU02_ENABLE_MASK		\
+}
+
+#define regulator_desc_s2mpu02_buck1234(num) {			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPU02_BUCK##num,			\
+	.ops		= &s2mpu02_buck_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPU02_BUCK1234_MIN_600MV,		\
+	.uV_step	= S2MPU02_BUCK1234_STEP_6_25MV,		\
+	.n_voltages	= S2MPU02_BUCK_N_VOLTAGES,		\
+	.linear_min_sel = S2MPU02_BUCK1234_START_SEL,		\
+	.ramp_delay	= S2MPU02_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPU02_REG_B1CTRL2 + (num - 1) * 2,	\
+	.vsel_mask	= S2MPU02_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPU02_REG_B1CTRL1 + (num - 1) * 2,	\
+	.enable_mask	= S2MPU02_ENABLE_MASK			\
+}
+#define regulator_desc_s2mpu02_buck5(num) {			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPU02_BUCK##num,			\
+	.ops		= &s2mpu02_ldo_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPU02_BUCK5_MIN_1081_25MV,		\
+	.uV_step	= S2MPU02_BUCK5_STEP_6_25MV,		\
+	.n_voltages	= S2MPU02_BUCK_N_VOLTAGES,		\
+	.linear_min_sel = S2MPU02_BUCK5_START_SEL,		\
+	.ramp_delay	= S2MPU02_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPU02_REG_B5CTRL2,			\
+	.vsel_mask	= S2MPU02_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPU02_REG_B5CTRL1,			\
+	.enable_mask	= S2MPU02_ENABLE_MASK			\
+}
+#define regulator_desc_s2mpu02_buck6(num) {			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPU02_BUCK##num,			\
+	.ops		= &s2mpu02_ldo_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPU02_BUCK6_MIN_1700MV,		\
+	.uV_step	= S2MPU02_BUCK6_STEP_2_50MV,		\
+	.n_voltages	= S2MPU02_BUCK_N_VOLTAGES,		\
+	.linear_min_sel = S2MPU02_BUCK6_START_SEL,		\
+	.ramp_delay	= S2MPU02_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPU02_REG_B6CTRL2,			\
+	.vsel_mask	= S2MPU02_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPU02_REG_B6CTRL1,			\
+	.enable_mask	= S2MPU02_ENABLE_MASK			\
+}
+#define regulator_desc_s2mpu02_buck7(num) {			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPU02_BUCK##num,			\
+	.ops		= &s2mpu02_ldo_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPU02_BUCK7_MIN_900MV,		\
+	.uV_step	= S2MPU02_BUCK7_STEP_6_25MV,		\
+	.n_voltages	= S2MPU02_BUCK_N_VOLTAGES,		\
+	.linear_min_sel = S2MPU02_BUCK7_START_SEL,		\
+	.ramp_delay	= S2MPU02_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPU02_REG_B7CTRL2,			\
+	.vsel_mask	= S2MPU02_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPU02_REG_B7CTRL1,			\
+	.enable_mask	= S2MPU02_ENABLE_MASK			\
+}
+
+static const struct regulator_desc s2mpu02_regulators[] = {
+	regulator_desc_s2mpu02_ldo1(1),
+	regulator_desc_s2mpu02_ldo2(2),
+	regulator_desc_s2mpu02_ldo4(3),
+	regulator_desc_s2mpu02_ldo5(4),
+	regulator_desc_s2mpu02_ldo4(5),
+	regulator_desc_s2mpu02_ldo3(6),
+	regulator_desc_s2mpu02_ldo3(7),
+	regulator_desc_s2mpu02_ldo4(8),
+	regulator_desc_s2mpu02_ldo5(9),
+	regulator_desc_s2mpu02_ldo3(10),
+	regulator_desc_s2mpu02_ldo4(11),
+	regulator_desc_s2mpu02_ldo5(12),
+	regulator_desc_s2mpu02_ldo5(13),
+	regulator_desc_s2mpu02_ldo5(14),
+	regulator_desc_s2mpu02_ldo5(15),
+	regulator_desc_s2mpu02_ldo5(16),
+	regulator_desc_s2mpu02_ldo4(17),
+	regulator_desc_s2mpu02_ldo5(18),
+	regulator_desc_s2mpu02_ldo3(19),
+	regulator_desc_s2mpu02_ldo4(20),
+	regulator_desc_s2mpu02_ldo5(21),
+	regulator_desc_s2mpu02_ldo5(22),
+	regulator_desc_s2mpu02_ldo5(23),
+	regulator_desc_s2mpu02_ldo4(24),
+	regulator_desc_s2mpu02_ldo5(25),
+	regulator_desc_s2mpu02_ldo4(26),
+	regulator_desc_s2mpu02_ldo5(27),
+	regulator_desc_s2mpu02_ldo5(28),
+	regulator_desc_s2mpu02_buck1234(1),
+	regulator_desc_s2mpu02_buck1234(2),
+	regulator_desc_s2mpu02_buck1234(3),
+	regulator_desc_s2mpu02_buck1234(4),
+	regulator_desc_s2mpu02_buck5(5),
+	regulator_desc_s2mpu02_buck6(6),
+	regulator_desc_s2mpu02_buck7(7),
+};
+
 static int s2mps11_pmic_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -634,15 +908,14 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	struct s2mps11_info *s2mps11;
 	int i, ret = 0;
 	const struct regulator_desc *regulators;
-	enum sec_device_type dev_type;
 
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
-	dev_type = platform_get_device_id(pdev)->driver_data;
-	switch (dev_type) {
+	s2mps11->dev_type = platform_get_device_id(pdev)->driver_data;
+	switch (s2mps11->dev_type) {
 	case S2MPS11X:
 		s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
 		regulators = s2mps11_regulators;
@@ -651,8 +924,13 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		s2mps11->rdev_num = ARRAY_SIZE(s2mps14_regulators);
 		regulators = s2mps14_regulators;
 		break;
+	case S2MPU02:
+		s2mps11->rdev_num = ARRAY_SIZE(s2mpu02_regulators);
+		regulators = s2mpu02_regulators;
+		break;
 	default:
-		dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
+		dev_err(&pdev->dev, "Invalid device type: %u\n",
+				    s2mps11->dev_type);
 		return -EINVAL;
 	};
 
@@ -686,7 +964,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
-	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11, dev_type);
+	ret = s2mps11_pmic_dt_parse(pdev, rdata, s2mps11);
 	if (ret)
 		goto out;
 
@@ -739,6 +1017,7 @@ out:
 static const struct platform_device_id s2mps11_pmic_id[] = {
 	{ "s2mps11-pmic", S2MPS11X},
 	{ "s2mps14-pmic", S2MPS14X},
+	{ "s2mpu02-pmic", S2MPU02},
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, s2mps11_pmic_id);
-- 
1.8.0

