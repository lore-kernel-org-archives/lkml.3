Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3AXKz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:55:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58104 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3AXKyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:55 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH 4/6] davinci: regulator: tps6507x: add device tree support.
Date: Thu, 24 Jan 2013 16:25:18 +0530
Message-ID: <1359024920-32190-5-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
References: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based initialization support for
TI's tps6507x regulators.
Add device tree binding document for TI's tps6507x
using datasheet:
http://www.ti.com/lit/ds/symlink/tps65070.pdf

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
 Documentation/devicetree/bindings/mfd/tps6507x.txt |   91 +++++++++++++++++++
 drivers/regulator/tps6507x-regulator.c             |   92 ++++++++++++++++++++
 2 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/devicetree/bindings/mfd/tps6507x.txt

diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
new file mode 100755
index 0000000..8fffa3c
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/tps6507x.txt
@@ -0,0 +1,91 @@
+TPS6507x Power Management Integrated Circuit
+
+Required properties:
+- compatible: "ti,tps6507x"
+- reg: I2C slave address
+- regulators: This is the list of child nodes that specify the regulator
+  initialization data for defined regulators. Not all regulators for the
+  given device need to be present. The definition for each of these nodes
+  is defined using the standard binding for regulators found at
+  Documentation/devicetree/bindings/regulator/regulator.txt.
+  The regulator is matched with the regulator-compatible.
+
+  The valid regulator-compatible values are:
+  tps6507x: vdcdc1, vdcdc2, vdcdc3, vldo1, vldo2
+- xxx-supply: Input voltage supply regulator.
+  These entries are required if regulators are enabled for a device.
+  Missing of these properties can cause the regulator registration
+  fails.
+  If some of input supply is powered through battery or always-on
+  supply then also it is require to have these parameters with proper
+  node handle of always on power supply.
+  tps6507x:
+       vindcdc1_2-supply: VDCDC1 and VDCDC2 input.
+       vindcdc3-supply  : VDCDC3 input.
+       vldo1_2-supply   : VLDO1 and VLDO2 input.
+
+Regulator Optional properties:
+- defdcdc_default: It's property of DCDC2 and DCDC3 regulators.
+			0: If defdcdc pin of DCDC2/DCDC3 is pulled to GND.
+			1: If defdcdc pin of DCDC2/DCDC3 is driven HIGH.
+  If this property is not defined, it defaults to 0 (not enabled).
+
+Example:
+
+	pmu: tps6507x@48 {
+		compatible = "ti,tps6507x";
+		reg = <0x48>;
+
+		vindcdc1_2-supply = <&vbat>;
+		vindcdc3-supply = <...>;
+		vinldo1_2-supply = <...>;
+
+		regulators {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			vdcdc1_reg: regulator@0 {
+				regulator-compatible = "VDCDC1";
+				reg = <0>;
+				regulator-min-microvolt = <3150000>;
+				regulator-max-microvolt = <3450000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			vdcdc2_reg: regulator@1 {
+				regulator-compatible = "VDCDC2";
+				reg = <1>;
+				regulator-min-microvolt = <1710000>;
+				regulator-max-microvolt = <3450000>;
+				regulator-always-on;
+				regulator-boot-on;
+				defdcdc_default = <1>;
+			};
+			vdcdc3_reg: regulator@2 {
+				regulator-compatible = "VDCDC3";
+				reg = <2>;
+				regulator-min-microvolt = <950000>
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+				defdcdc_default = <1>;
+			};
+			ldo1_reg: regulator@3 {
+				regulator-compatible = "LDO1";
+				reg = <3>;
+				regulator-min-microvolt = <1710000>;
+				regulator-max-microvolt = <1890000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+			ldo2_reg: regulator@4 {
+				regulator-compatible = "LDO2";
+				reg = <4>;
+				regulator-min-microvolt = <1140000>;
+				regulator-max-microvolt = <1320000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+
+	};
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 0233cfb..afdeb65 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -23,8 +23,10 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/tps6507x.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/mfd/tps6507x.h>
+#include <linux/regulator/of_regulator.h>
 
 /* DCDC's */
 #define TPS6507X_DCDC_1				0
@@ -356,6 +358,80 @@ static struct regulator_ops tps6507x_pmic_ops = {
 	.list_voltage = regulator_list_voltage_table,
 };
 
+#ifdef CONFIG_OF
+static struct of_regulator_match tps6507x_matches[] = {
+	{ .name = "VDCDC1"},
+	{ .name = "VDCDC2"},
+	{ .name = "VDCDC3"},
+	{ .name = "LDO1"},
+	{ .name = "LDO2"},
+};
+
+static struct tps6507x_board *tps6507x_parse_dt_reg_data(
+		struct platform_device *pdev,
+		struct of_regulator_match **tps6507x_reg_matches)
+{
+	struct tps6507x_board *tps_board;
+	struct device_node *np = pdev->dev.parent->of_node;
+	struct device_node *regulators;
+	struct of_regulator_match *matches;
+	static struct regulator_init_data *reg_data;
+	int idx = 0, count, ret;
+
+	tps_board = devm_kzalloc(&pdev->dev, sizeof(*tps_board),
+					GFP_KERNEL);
+	if (!tps_board) {
+		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+		return NULL;
+	}
+
+	regulators = of_find_node_by_name(np, "regulators");
+	if (!regulators) {
+		dev_err(&pdev->dev, "regulator node not found\n");
+		return NULL;
+	}
+
+	count = ARRAY_SIZE(tps6507x_matches);
+	matches = tps6507x_matches;
+
+	ret = of_regulator_match(pdev->dev.parent, regulators, matches, count);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
+			ret);
+		return NULL;
+	}
+
+	*tps6507x_reg_matches = matches;
+
+	reg_data = devm_kzalloc(&pdev->dev, (sizeof(struct regulator_init_data)
+					* TPS6507X_NUM_REGULATOR), GFP_KERNEL);
+	if (!reg_data) {
+		dev_err(&pdev->dev, "Failure to alloc init data for regulators.\n");
+		return NULL;
+	}
+
+	tps_board->tps6507x_pmic_init_data = reg_data;
+
+	for (idx = 0; idx < count; idx++) {
+		if (!matches[idx].init_data || !matches[idx].of_node)
+			continue;
+
+		memcpy(&reg_data[idx], matches[idx].init_data,
+				sizeof(struct regulator_init_data));
+
+	}
+
+	return tps_board;
+}
+#else
+static inline struct tps6507x_board *tps6507x_parse_dt_reg_data(
+			struct platform_device *pdev,
+			struct of_regulator_match **tps6507x_reg_matches)
+{
+	*tps6507x_reg_matches = NULL;
+	return NULL;
+}
+#endif
 static int tps6507x_pmic_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
@@ -365,8 +441,10 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct tps6507x_pmic *tps;
 	struct tps6507x_board *tps_board;
+	struct of_regulator_match *tps6507x_reg_matches = NULL;
 	int i;
 	int error;
+	unsigned int prop;
 
 	/**
 	 * tps_board points to pmic related constants
@@ -374,6 +452,9 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 	 */
 
 	tps_board = dev_get_platdata(tps6507x_dev->dev);
+	if (!tps_board && tps6507x_dev->dev->of_node)
+		tps_board = tps6507x_parse_dt_reg_data(pdev,
+						&tps6507x_reg_matches);
 	if (!tps_board)
 		return -EINVAL;
 
@@ -415,6 +496,17 @@ static int tps6507x_pmic_probe(struct platform_device *pdev)
 		config.init_data = init_data;
 		config.driver_data = tps;
 
+		if (tps6507x_reg_matches) {
+			error = of_property_read_u32(
+				tps6507x_reg_matches[i].of_node,
+					"ti,defdcdc_default", &prop);
+
+			if (!error)
+				tps->info[i]->defdcdc_default = prop;
+
+			config.of_node = tps6507x_reg_matches[i].of_node;
+		}
+
 		rdev = regulator_register(&tps->desc[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(tps6507x_dev->dev,
-- 
1.7.4.1

