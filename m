Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaFQA1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:27:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19922 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaFQA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:27:19 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-41-539f8b65e461
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: sbkim73@samsung.com, k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, t.figa@samsung.com,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCHv6 2/3] regulator: s2mps11: Add support S2MPU02 regulator device
Date: Tue, 17 Jun 2014 09:27:09 +0900
Message-id: <1402964830-24890-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
References: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWyRsSkRDe1e36wwa6DahZTHz5hs7j+5Tmr
	xfwj51gt+t8sZLU492olo0Xn2SfMFq9fGFqcbXrDbnH/61FGi8u75rBZLL1+kcniduMKNosJ
	09eyWLy9M53FonXvEXaLk396GS1Od7NaXFzxhcli/YzXLA7CHmvmrWH0uNzXy+SxcvkXNo/N
	K7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBnFZZOSmpNZllqkb5fAlXFn6xfmgofrGCs+
	7T/H1sB4eyJjFyMnh4SAicSmh5dZIWwxiQv31rN1MXJxCAksZZS49f8DXNGyJy9ZIBKLGCVO
	H9vBCOE0MUnMaTsB1s4moCWx/8UNNhBbRMBZ4vuniWCjmAXWMUv8bGplAUkIC/hLzPy1EGws
	i4CqROubL2BxXgFXiU//lkGtk5P4sOcRO4jNKeAmcbT1GNgCIaCapc1r2UGGSgj0ckh09X9l
	ghgkIPFt8iGgQRxACVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6
	yfm5mxiBcXj637O+HYw3D1gfYkwGGjeRWUo0OR8Yx3kl8YbGZkYWpiamxkbmlmakCSuJ8y56
	mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXF24U+r/llG/l8U/mfeluuJtL0w0Tlt+tL+
	Dbbe1mfXfXVQmlkouiIx23oOo6t6VXS/ZtmOgF3vGYJ4HY/vWr3yeESKZI/D3SeNERn5+55c
	vvv4iZv8UXf9sH67vYZ7ZDPV/7evl1lqd0/6NVdTR3wx9/3zNVe3TXE9ViSdyOD9cuYjQb37
	bEosxRmJhlrMRcWJAGxx4ljZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd3U7vnBBt9XiVtMffiEzeL6l+es
	FvOPnGO16H+zkNXi3KuVjBadZ58wW7x+YWhxtukNu8X9r0cZLS7vmsNmsfT6RSaL240r2Cwm
	TF/LYvH2znQWi9a9R9gtTv7pZbQ43c1qcXHFFyaL9TNeszgIe6yZt4bR43JfL5PHyuVf2Dw2
	r9Dy2LSqk83jzrU9bB7zTgZ69G1ZxejxeZNcAGdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBPSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9
	Q4LgeowM0EDCGsaMO1u/MBc8XMdY8Wn/ObYGxtsTGbsYOTkkBEwklj15yQJhi0lcuLeerYuR
	i0NIYBGjxOljOxghnCYmiTltJ1hBqtgEtCT2v7jBBmKLCDhLfP80EayDWWAds8TPplawUcIC
	/hIzfy0EW8EioCrR+uYLWJxXwFXi079lUKvlJD7secQOYnMKuEkcbT0GtkAIqGZp81r2CYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/kz6R2MqxosDjEKcDAq8fA+kJ0fLMSa
	WFZcmXuIUYKDWUmEl8scKMSbklhZlVqUH19UmpNafIgxGeiqicxSosn5wASUVxJvaGxiZmRp
	ZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MtXo/Vy92Fcj26RDWP8aW2czp
	McdrflVd8RvJRY8rroeJipUc//0jdZLX+kmbSjc2nr591ec0h6C/mxGToX95hG7Sp7CElXOO
	uJ/N8dz21+GW9/E/cuo2dwp6uQ5Ki+q78R2/9NOywrdth/aVbUnHdi3TPbfNIGlt3dpH5UU5
	B2K+iBT5+a5VYinOSDTUYi4qTgQA/f6YFTYDAAA=
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
 drivers/mfd/sec-core.c              |  25 +++
 drivers/regulator/s2mps11.c         | 321 +++++++++++++++++++++++++++++++++---
 include/linux/mfd/samsung/s2mpu02.h | 201 ++++++++++++++++++++++
 3 files changed, 526 insertions(+), 21 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

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
diff --git a/include/linux/mfd/samsung/s2mpu02.h b/include/linux/mfd/samsung/s2mpu02.h
new file mode 100644
index 0000000..47ae9bc
--- /dev/null
+++ b/include/linux/mfd/samsung/s2mpu02.h
@@ -0,0 +1,201 @@
+/*
+ * s2mpu02.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ *              http://www.samsung.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_MFD_S2MPU02_H
+#define __LINUX_MFD_S2MPU02_H
+
+/* S2MPU02 registers */
+enum S2MPU02_reg {
+	S2MPU02_REG_ID,
+	S2MPU02_REG_INT1,
+	S2MPU02_REG_INT2,
+	S2MPU02_REG_INT3,
+	S2MPU02_REG_INT1M,
+	S2MPU02_REG_INT2M,
+	S2MPU02_REG_INT3M,
+	S2MPU02_REG_ST1,
+	S2MPU02_REG_ST2,
+	S2MPU02_REG_PWRONSRC,
+	S2MPU02_REG_OFFSRC,
+	S2MPU02_REG_BU_CHG,
+	S2MPU02_REG_RTCCTRL,
+	S2MPU02_REG_PMCTRL1,
+	S2MPU02_REG_RSVD1,
+	S2MPU02_REG_RSVD2,
+	S2MPU02_REG_RSVD3,
+	S2MPU02_REG_RSVD4,
+	S2MPU02_REG_RSVD5,
+	S2MPU02_REG_RSVD6,
+	S2MPU02_REG_RSVD7,
+	S2MPU02_REG_WRSTEN,
+	S2MPU02_REG_RSVD8,
+	S2MPU02_REG_RSVD9,
+	S2MPU02_REG_RSVD10,
+	S2MPU02_REG_B1CTRL1,
+	S2MPU02_REG_B1CTRL2,
+	S2MPU02_REG_B2CTRL1,
+	S2MPU02_REG_B2CTRL2,
+	S2MPU02_REG_B3CTRL1,
+	S2MPU02_REG_B3CTRL2,
+	S2MPU02_REG_B4CTRL1,
+	S2MPU02_REG_B4CTRL2,
+	S2MPU02_REG_B5CTRL1,
+	S2MPU02_REG_B5CTRL2,
+	S2MPU02_REG_B5CTRL3,
+	S2MPU02_REG_B5CTRL4,
+	S2MPU02_REG_B5CTRL5,
+	S2MPU02_REG_B6CTRL1,
+	S2MPU02_REG_B6CTRL2,
+	S2MPU02_REG_B7CTRL1,
+	S2MPU02_REG_B7CTRL2,
+	S2MPU02_REG_RAMP1,
+	S2MPU02_REG_RAMP2,
+	S2MPU02_REG_L1CTRL,
+	S2MPU02_REG_L2CTRL1,
+	S2MPU02_REG_L2CTRL2,
+	S2MPU02_REG_L2CTRL3,
+	S2MPU02_REG_L2CTRL4,
+	S2MPU02_REG_L3CTRL,
+	S2MPU02_REG_L4CTRL,
+	S2MPU02_REG_L5CTRL,
+	S2MPU02_REG_L6CTRL,
+	S2MPU02_REG_L7CTRL,
+	S2MPU02_REG_L8CTRL,
+	S2MPU02_REG_L9CTRL,
+	S2MPU02_REG_L10CTRL,
+	S2MPU02_REG_L11CTRL,
+	S2MPU02_REG_L12CTRL,
+	S2MPU02_REG_L13CTRL,
+	S2MPU02_REG_L14CTRL,
+	S2MPU02_REG_L15CTRL,
+	S2MPU02_REG_L16CTRL,
+	S2MPU02_REG_L17CTRL,
+	S2MPU02_REG_L18CTRL,
+	S2MPU02_REG_L19CTRL,
+	S2MPU02_REG_L20CTRL,
+	S2MPU02_REG_L21CTRL,
+	S2MPU02_REG_L22CTRL,
+	S2MPU02_REG_L23CTRL,
+	S2MPU02_REG_L24CTRL,
+	S2MPU02_REG_L25CTRL,
+	S2MPU02_REG_L26CTRL,
+	S2MPU02_REG_L27CTRL,
+	S2MPU02_REG_L28CTRL,
+	S2MPU02_REG_LDODSCH1,
+	S2MPU02_REG_LDODSCH2,
+	S2MPU02_REG_LDODSCH3,
+	S2MPU02_REG_LDODSCH4,
+	S2MPU02_REG_SELMIF,
+	S2MPU02_REG_RSVD11,
+	S2MPU02_REG_RSVD12,
+	S2MPU02_REG_RSVD13,
+	S2MPU02_REG_DVSSEL,
+	S2MPU02_REG_DVSPTR,
+	S2MPU02_REG_DVSDATA,
+};
+
+/* S2MPU02 regulator ids */
+enum S2MPU02_regulators {
+	S2MPU02_LDO1,
+	S2MPU02_LDO2,
+	S2MPU02_LDO3,
+	S2MPU02_LDO4,
+	S2MPU02_LDO5,
+	S2MPU02_LDO6,
+	S2MPU02_LDO7,
+	S2MPU02_LDO8,
+	S2MPU02_LDO9,
+	S2MPU02_LDO10,
+	S2MPU02_LDO11,
+	S2MPU02_LDO12,
+	S2MPU02_LDO13,
+	S2MPU02_LDO14,
+	S2MPU02_LDO15,
+	S2MPU02_LDO16,
+	S2MPU02_LDO17,
+	S2MPU02_LDO18,
+	S2MPU02_LDO19,
+	S2MPU02_LDO20,
+	S2MPU02_LDO21,
+	S2MPU02_LDO22,
+	S2MPU02_LDO23,
+	S2MPU02_LDO24,
+	S2MPU02_LDO25,
+	S2MPU02_LDO26,
+	S2MPU02_LDO27,
+	S2MPU02_LDO28,
+	S2MPU02_BUCK1,
+	S2MPU02_BUCK2,
+	S2MPU02_BUCK3,
+	S2MPU02_BUCK4,
+	S2MPU02_BUCK5,
+	S2MPU02_BUCK6,
+	S2MPU02_BUCK7,
+
+	S2MPU02_REGULATOR_MAX,
+};
+
+/* Regulator constraints for BUCKx */
+#define S2MPU02_BUCK1234_MIN_600MV	600000
+#define S2MPU02_BUCK5_MIN_1081_25MV	1081250
+#define S2MPU02_BUCK6_MIN_1700MV	1700000
+#define S2MPU02_BUCK7_MIN_900MV		900000
+
+#define S2MPU02_BUCK1234_STEP_6_25MV	6250
+#define S2MPU02_BUCK5_STEP_6_25MV	6250
+#define S2MPU02_BUCK6_STEP_2_50MV	2500
+#define S2MPU02_BUCK7_STEP_6_25MV	6250
+
+#define S2MPU02_BUCK1234_START_SEL	0x00
+#define S2MPU02_BUCK5_START_SEL		0x4D
+#define S2MPU02_BUCK6_START_SEL		0x28
+#define S2MPU02_BUCK7_START_SEL		0x30
+
+#define S2MPU02_BUCK_RAMP_DELAY		12500
+
+/* Regulator constraints for different types of LDOx */
+#define S2MPU02_LDO_MIN_900MV		900000
+#define S2MPU02_LDO_MIN_1050MV		1050000
+#define S2MPU02_LDO_MIN_1600MV		1600000
+#define S2MPU02_LDO_STEP_12_5MV		12500
+#define S2MPU02_LDO_STEP_25MV		25000
+#define S2MPU02_LDO_STEP_50MV		50000
+
+#define S2MPU02_LDO_GROUP1_START_SEL	0x8
+#define S2MPU02_LDO_GROUP2_START_SEL	0xA
+#define S2MPU02_LDO_GROUP3_START_SEL	0x10
+
+#define S2MPU02_LDO_VSEL_MASK		0x3F
+#define S2MPU02_BUCK_VSEL_MASK		0xFF
+#define S2MPU02_ENABLE_MASK		(0x03 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_ENABLE_SHIFT		6
+
+/* On/Off controlled by PWREN */
+#define S2MPU02_ENABLE_SUSPEND		(0x01 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_DISABLE_SUSPEND		(0x11 << S2MPU02_ENABLE_SHIFT)
+#define S2MPU02_LDO_N_VOLTAGES		(S2MPU02_LDO_VSEL_MASK + 1)
+#define S2MPU02_BUCK_N_VOLTAGES		(S2MPU02_BUCK_VSEL_MASK + 1)
+
+/* RAMP delay for BUCK1234*/
+#define S2MPU02_BUCK1_RAMP_SHIFT	6
+#define S2MPU02_BUCK2_RAMP_SHIFT	4
+#define S2MPU02_BUCK3_RAMP_SHIFT	2
+#define S2MPU02_BUCK4_RAMP_SHIFT	0
+#define S2MPU02_BUCK1234_RAMP_MASK	0x3
+
+#endif /*  __LINUX_MFD_S2MPU02_H */
-- 
1.8.0

