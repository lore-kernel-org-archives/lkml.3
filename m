Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763099Ab3DDQUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:20:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52315 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763041Ab3DDQUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:20:06 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-c1-515da8345ff2
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, m.szyprowski@samsung.com,
        kgene.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 3/3] mfd: max8998: Add support for Device Tree
Date: Thu, 04 Apr 2013 18:19:23 +0200
Message-id: <1365092363-12763-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
References: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAV2TFbGBBuvmKVr8m32KzeLA7Ies
	Fr0LrrJZnG16w25xedccNosZ5/cxWTRtn8BusfbIXXaL9TNeszhwepyfsZDR4+XE32wefVtW
	MXocv7GdyePzJrkA1igum5TUnMyy1CJ9uwSujCkr3jAW/G5nrDjVM5GtgfFfbhcjJ4eEgInE
	49/T2CBsMYkL99YD2VwcQgKLGCV6Z+9mBEkICXQxSdyeVAFiswmoSXxueATWICKgILG59xkr
	SAOzwHtGiStPXgI5HBzCAnYSnXPLQWpYBFQlZl36AjaHV8BJ4tuEJewQy+Qlnt7vYwMp5xRw
	ljg0WRtilZPEs8+3GScw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxoz6R3MK5q
	sDjEKMDBqMTDm9EXGyjEmlhWXJl7iFGCg1lJhPdoC1CINyWxsiq1KD++qDQntfgQozQHi5I4
	78FW60AhgfTEktTs1NSC1CKYLBMHp1QDo5Bx66cd/i/fR9rFFMm8nKHxfPX/qKCtfm3uNhFq
	z08EGZ7Ssnx/gudTx4q/DBd/bf+YYLe72cVW4cm3RM77OStK5+pY8IQeuzorR73he1fsXY3i
	zV4PFFY06ex4mr7Qt9hhU8neSGke3n0CmoHHPHb+/9i94k3jrqSJFx7OnRO6PeYHQ4uOhRJL
	cUaioRZzUXEiAI/0AP4wAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Device Tree support to max8998 driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max8998.txt | 111 +++++++++++++++
 drivers/mfd/max8998.c                             |  75 +++++++++-
 drivers/regulator/max8998.c                       | 158 +++++++++++++++++++++-
 drivers/rtc/rtc-max8998.c                         |   2 +-
 include/linux/mfd/max8998-private.h               |   2 +
 include/linux/mfd/max8998.h                       |   2 +
 6 files changed, 343 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt

diff --git a/Documentation/devicetree/bindings/mfd/max8998.txt b/Documentation/devicetree/bindings/mfd/max8998.txt
new file mode 100644
index 0000000..80ac378
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max8998.txt
@@ -0,0 +1,111 @@
+* Maxim MAX8998, National/TI LP3974 Voltage and Current Regulator
+
+The Maxim MAX8998 is a multi-function device which includes volatage and
+current regulators, rtc, charger controller and other sub-blocks. It is
+interfaced to the host controller using a i2c interface. Each sub-block is
+addressed by the host system using different i2c slave address. This document
+describes the bindings for 'pmic' sub-block of max8998.
+
+Required properties:
+- compatible: Should be one of the following:
+    - "maxim,max8998" for Maxim MAX8998
+    - "national,lp3974" or "ti,lp3974" for National/TI LP3974.
+- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
+
+Optional properties:
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the interrupts from max8998 are delivered to.
+- interrupts: Interrupt specifiers for two interrupt sources.
+  - First interrupt specifier is for 'irq1' interrupt.
+  - Second interrupt specifier is for 'alert' interrupt.
+- max8998,pmic-buck1-dvs-gpios: GPIO specifiers for two host gpios used
+  for buck 1 dvs. The format of the gpio specifier depends in the gpio
+  controller.
+- max8998,pmic-buck2-dvs-gpio: GPIO specifier for host gpio used
+  for buck 2 dvs. The format of the gpio specifier depends in the gpio
+  controller.
+- max8998,pmic-buck1-default-dvs-idx: Default voltage setting selected from
+  the possible 4 options selectable by the dvs gpios. The value of this
+  property should be between 0 and 3. If not specified or if out of range, the
+  default value of this property is set to 0.
+- max8998,pmic-buck2-default-dvs-idx: Default voltage setting selected from
+  the possible 2 options selectable by the dvs gpios. The value of this
+  property should be between 0 and 1. If not specified or if out of range, the
+  default value of this property is set to 0.
+- max8998,pmic-buck-voltage-lock: If present, disallows changing of
+  preprogrammed buck dvfs voltages.
+
+Additional properties required if max8998,pmic-buck1-dvs-gpios is defined:
+- max8998,pmic-buck1-dvs-voltage: A set of 4 voltage values in micro-volt (uV)
+  units for buck1 when changing voltage using gpio dvs.
+
+Additional properties required if max8998,pmic-buck2-dvs-gpio is defined:
+- max8998,pmic-buck2-dvs-voltage: A set of 2 voltage values in micro-volt (uV)
+  units for buck2 when changing voltage using gpio dvs.
+
+Regulators: The regulators of max8998 that have to be instantiated should be
+included in a sub-node named 'regulators'. Regulator nodes included in this
+sub-node should be of the format as listed below.
+
+	regulator_name {
+		standard regulator bindings here
+	};
+
+The following are the names of the regulators that the max8998 pmic block
+supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
+as per the datasheet of max8998.
+
+	- LDOn
+		  - valid values for n are 2 to 17
+		  - Example: LDO2, LDO10, LDO17
+	- BUCKn
+		  - valid values for n are 1 to 4.
+		  - Example: BUCK1, BUCK2, BUCK3, BUCK4
+
+	- ENVICHG: Battery Charging Current Monitor Output. This is a fixed
+		   voltage type regulator
+
+	- ESAFEOUT1: (ldo19)
+	- ESAFEOUT2: (ld020)
+
+	- EN32KHz AP: 32KHz clock output for application processor
+	- EN32KHz CP: 32KHz clock output for call processor
+
+The bindings inside the regulator nodes use the standard regulator bindings
+which are documented elsewhere.
+
+Example:
+
+	max8998_pmic@66 {
+		compatible = "maxim,max8998-pmic";
+		interrupt-parent = <&wakeup_eint>;
+		reg = <0x66>;
+		interrupts = <4 0>, <3 0>;
+
+		max8998,pmic-buck1-default-dvs-idx = <0>;
+		max8998,pmic-buck1-dvs-gpios = <&gpx0 0 1 0 0>, /* SET1 */
+						 <&gpx0 1 1 0 0>; /* SET2 */
+		max8998,pmic-buck1-dvs-voltage = <1350000>, <1300000>,
+						 <1000000>, <950000>;
+
+		max8998,pmic-buck2-default-dvs-idx = <0>;
+		max8998,pmic-buck2-dvs-gpio = <&gpx0 0 3 0 0>; /* SET3 */
+		max8998,pmic-buck2-dvs-voltage = <1350000>, <1300000>;
+
+		regulators {
+			ldo2_reg: LDO2 {
+				regulator-name = "VDD_ALIVE_1.1V";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-always-on;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "VDD_ARM_1.2V";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+	};
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index e9bd352..d4a8753 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -20,12 +20,14 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/of_irq.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
@@ -128,6 +130,65 @@ int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 }
 EXPORT_SYMBOL(max8998_update_reg);
 
+#ifdef CONFIG_OF
+static struct of_device_id max8998_dt_match[] = {
+	{ .compatible = "maxim,max8998", .data = (void *)TYPE_MAX8998 },
+	{ .compatible = "national,lp3974", .data = (void *)TYPE_LP3974 },
+	{ .compatible = "ti,lp3974", .data = (void *)TYPE_LP3974 },
+	{},
+};
+MODULE_DEVICE_TABLE(of, max8998_dt_match);
+
+/*
+ * Only the common platform data elements for max8998 are parsed here from the
+ * device tree. Other sub-modules of max8998 such as pmic, rtc and others have
+ * to parse their own platform data elements from device tree.
+ *
+ * The max8998 platform data structure is instantiated here and the drivers for
+ * the sub-modules need not instantiate another instance while parsing their
+ * platform data.
+ */
+static struct max8998_platform_data *max8998_i2c_parse_dt_pdata(
+							struct device *dev)
+{
+	struct max8998_platform_data *pd;
+
+	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dev_err(dev, "could not allocate memory for pdata\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
+
+	/*
+	 * ToDo: the 'wakeup' member in the platform data is more of a linux
+	 * specfic information. Hence, there is no binding for that yet and
+	 * not parsed here.
+	 */
+
+	return pd;
+}
+#else
+static struct max8998_platform_data *max8998_i2c_parse_dt_pdata(
+							struct device *dev)
+{
+	return 0;
+}
+#endif
+
+static inline int max8998_i2c_get_driver_data(struct i2c_client *i2c,
+						const struct i2c_device_id *id)
+{
+	if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(max8998_dt_match, i2c->dev.of_node);
+		return (int)match->data;
+	}
+
+	return (int)id->driver_data;
+}
+
 static int max8998_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -139,11 +200,20 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	if (max8998 == NULL)
 		return -ENOMEM;
 
+	if (i2c->dev.of_node) {
+		pdata = max8998_i2c_parse_dt_pdata(&i2c->dev);
+		if (IS_ERR(pdata)) {
+			ret = PTR_ERR(pdata);
+			goto err;
+		}
+	}
+
 	i2c_set_clientdata(i2c, max8998);
 	max8998->dev = &i2c->dev;
 	max8998->i2c = i2c;
 	max8998->irq = i2c->irq;
-	max8998->type = id->driver_data;
+	max8998->type = max8998_i2c_get_driver_data(i2c, id);
+	max8998->pdata = pdata;
 	if (pdata) {
 		max8998->ono = pdata->ono;
 		max8998->wakeup = pdata->wakeup;
@@ -157,7 +227,7 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 	pm_runtime_set_active(max8998->dev);
 
-	switch (id->driver_data) {
+	switch (max8998->type) {
 	case TYPE_LP3974:
 		ret = mfd_add_devices(max8998->dev, -1,
 				      lp3974_devs, ARRAY_SIZE(lp3974_devs),
@@ -313,6 +383,7 @@ static struct i2c_driver max8998_i2c_driver = {
 		   .name = "max8998",
 		   .owner = THIS_MODULE,
 		   .pm = &max8998_pm,
+		   .of_match_table = of_match_ptr(max8998_dt_match),
 	},
 	.probe = max8998_i2c_probe,
 	.remove = max8998_i2c_remove,
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 8c45b93..df37b3a 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -28,8 +28,10 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/mfd/max8998.h>
 #include <linux/mfd/max8998-private.h>
 
@@ -589,13 +591,13 @@ static struct regulator_desc regulators[] = {
 		.type		= REGULATOR_VOLTAGE,
 		.owner		= THIS_MODULE,
 	}, {
-		.name		= "EN32KHz AP",
+		.name		= "EN32KHz-AP",
 		.id		= MAX8998_EN32KHZ_AP,
 		.ops		= &max8998_others_ops,
 		.type		= REGULATOR_VOLTAGE,
 		.owner		= THIS_MODULE,
 	}, {
-		.name		= "EN32KHz CP",
+		.name		= "EN32KHz-CP",
 		.id		= MAX8998_EN32KHZ_CP,
 		.ops		= &max8998_others_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -621,10 +623,150 @@ static struct regulator_desc regulators[] = {
 	}
 };
 
+#ifdef CONFIG_OF
+static int max8998_pmic_dt_parse_dvs_gpio(struct max8998_dev *iodev,
+			struct max8998_platform_data *pdata,
+			struct device_node *pmic_np)
+{
+	int gpio;
+
+	gpio = of_get_named_gpio(pmic_np, "max8998,pmic-buck1-dvs-gpios", 0);
+	if (!gpio_is_valid(gpio)) {
+		dev_err(iodev->dev, "invalid buck1 gpio[0]: %d\n", gpio);
+		return -EINVAL;
+	}
+	pdata->buck1_set1 = gpio;
+
+	gpio = of_get_named_gpio(pmic_np, "max8998,pmic-buck1-dvs-gpios", 1);
+	if (!gpio_is_valid(gpio)) {
+		dev_err(iodev->dev, "invalid buck1 gpio[1]: %d\n", gpio);
+		return -EINVAL;
+	}
+	pdata->buck1_set2 = gpio;
+
+	gpio = of_get_named_gpio(pmic_np, "max8998,pmic-buck2-dvs-gpio", 0);
+	if (!gpio_is_valid(gpio)) {
+		dev_err(iodev->dev, "invalid buck 2 gpio: %d\n", gpio);
+		return -EINVAL;
+	}
+	pdata->buck2_set3 = gpio;
+
+	return 0;
+}
+
+static int max8998_pmic_dt_parse_pdata(struct max8998_dev *iodev,
+					struct max8998_platform_data *pdata)
+{
+	struct device_node *pmic_np, *regulators_np, *reg_np;
+	struct max8998_regulator_data *rdata;
+	unsigned int i, ret;
+
+	pmic_np = iodev->dev->of_node;
+	if (!pmic_np) {
+		dev_err(iodev->dev, "could not find pmic sub-node\n");
+		return -ENODEV;
+	}
+
+	regulators_np = of_find_node_by_name(pmic_np, "regulators");
+	if (!regulators_np) {
+		dev_err(iodev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	/* count the number of regulators to be supported in pmic */
+	pdata->num_regulators = 0;
+	for_each_child_of_node(regulators_np, reg_np)
+		pdata->num_regulators++;
+
+	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+				pdata->num_regulators, GFP_KERNEL);
+	if (!rdata) {
+		dev_err(iodev->dev, "could not allocate memory for "
+						"regulator data\n");
+		return -ENOMEM;
+	}
+
+	pdata->regulators = rdata;
+	for_each_child_of_node(regulators_np, reg_np) {
+		for (i = 0; i < ARRAY_SIZE(regulators); i++)
+			if (!of_node_cmp(reg_np->name, regulators[i].name))
+				break;
+
+		if (i == ARRAY_SIZE(regulators)) {
+			dev_warn(iodev->dev, "don't know how to configure "
+				"regulator %s\n", reg_np->name);
+			--pdata->num_regulators;
+			continue;
+		}
+
+		rdata->id = regulators[i].id;
+		rdata->initdata = of_get_regulator_init_data(
+						iodev->dev, reg_np);
+		rdata->reg_node = reg_np;
+		rdata++;
+	}
+
+	ret = max8998_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
+	if (ret)
+		return -EINVAL;
+
+	if (of_find_property(pmic_np, "max8998,pmic-buck-voltage-lock", NULL))
+		pdata->buck_voltage_lock = true;
+
+	if (of_property_read_u32(pmic_np,
+			"max8998,pmic-buck1-default-dvs-idx",
+			&pdata->buck1_default_idx)) {
+		pdata->buck1_default_idx = 0;
+	} else {
+		if (pdata->buck1_default_idx >= 4) {
+			pdata->buck1_default_idx = 0;
+			dev_info(iodev->dev, "invalid value for "
+			"default dvs index, using 0 instead\n");
+		}
+	}
+
+	if (of_property_read_u32(pmic_np,
+			"max8998,pmic-buck2-default-dvs-idx",
+			&pdata->buck2_default_idx)) {
+		pdata->buck2_default_idx = 0;
+	} else {
+		if (pdata->buck2_default_idx >= 2) {
+			pdata->buck2_default_idx = 0;
+			dev_info(iodev->dev, "invalid value for "
+			"default dvs index, using 0 instead\n");
+		}
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"max8998,pmic-buck1-dvs-voltage",
+				pdata->buck1_voltage,
+				ARRAY_SIZE(pdata->buck1_voltage))) {
+		dev_err(iodev->dev, "buck1 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_u32_array(pmic_np,
+				"max8998,pmic-buck2-dvs-voltage",
+				pdata->buck2_voltage,
+				ARRAY_SIZE(pdata->buck2_voltage))) {
+		dev_err(iodev->dev, "buck2 voltages not specified\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#else
+static int max8998_pmic_dt_parse_pdata(struct max8998_dev *iodev,
+					struct max8998_platform_data *pdata)
+{
+	return 0;
+}
+#endif /* CONFIG_OF */
+
 static int max8998_pmic_probe(struct platform_device *pdev)
 {
 	struct max8998_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max8998_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct max8998_platform_data *pdata = iodev->pdata;
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct max8998_data *max8998;
@@ -637,6 +779,12 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (iodev->dev->of_node) {
+		ret = max8998_pmic_dt_parse_pdata(iodev, pdata);
+		if (ret)
+			return ret;
+	}
+
 	max8998 = devm_kzalloc(&pdev->dev, sizeof(struct max8998_data),
 			       GFP_KERNEL);
 	if (!max8998)
@@ -750,13 +898,15 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		}
 
 		config.dev = max8998->dev;
+		config.of_node = pdata->regulators[i].reg_node;
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = max8998;
 
 		rdev[i] = regulator_register(&regulators[index], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
-			dev_err(max8998->dev, "regulator init failed\n");
+			dev_err(max8998->dev, "regulator %s init failed\n",
+							regulators[index].name);
 			rdev[i] = NULL;
 			goto err;
 		}
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index f854983..66374ac 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -253,7 +253,7 @@ static const struct rtc_class_ops max8998_rtc_ops = {
 static int max8998_rtc_probe(struct platform_device *pdev)
 {
 	struct max8998_dev *max8998 = dev_get_drvdata(pdev->dev.parent);
-	struct max8998_platform_data *pdata = dev_get_platdata(max8998->dev);
+	struct max8998_platform_data *pdata = max8998->pdata;
 	struct max8998_rtc_info *info;
 	int ret;
 
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index e81077a..f02676e 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -137,6 +137,7 @@ struct irq_domain;
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
+ * @pdata: platform data for the driver and subdrivers
  * @i2c: i2c client private data for regulator
  * @rtc: i2c client private data for rtc
  * @iolock: mutex for serializing io access
@@ -150,6 +151,7 @@ struct irq_domain;
  */
 struct max8998_dev {
 	struct device *dev;
+	struct max8998_platform_data *pdata;
 	struct i2c_client *i2c;
 	struct i2c_client *rtc;
 	struct mutex iolock;
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index e8b9ba7..bb4de8b 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -58,10 +58,12 @@ enum {
  * max8998_regulator_data - regulator data
  * @id: regulator id
  * @initdata: regulator init data (contraints, supplies, ...)
+ * @reg_node: DT node of regulator (unused on non-DT platforms)
  */
 struct max8998_regulator_data {
 	int				id;
 	struct regulator_init_data	*initdata;
+	struct device_node		*reg_node;
 };
 
 /**
-- 
1.8.1.5

