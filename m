Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbaHZOMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:12:13 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:56826 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443AbaHZOML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:12:11 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <505e0251df710f3041379f54f976961b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v6 1/5] dt-bindings: Add RK808 device tree bindings document
Date: Tue, 26 Aug 2014 22:11:28 +0800
Message-Id: <1409062288-11882-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings documentation and a header file
for rockchip's RK808 pmic.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>

---

Changes in v6:
Advices by Mark Rutland
- add description about clock-cells
Advices by Doug
- modify description about regulator
- remove pinctrl description

Changes in v5:
Advices by Mark Brown
- add description about regulator valid name.
- add a header file "rockchip,rk808".

Changes in v4:
Advices by Doug
- add a "#clock-cells" propertiy
- update the example

Changes in v3: None
Changes in v2: None

 Documentation/devicetree/bindings/mfd/rk808.txt |  150 +++++++++++++++++++++++
 include/dt-bindings/clock/rockchip,rk808.h      |   11 ++
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
 create mode 100644 include/dt-bindings/clock/rockchip,rk808.h

diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
new file mode 100644
index 0000000..6c39360
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rk808.txt
@@ -0,0 +1,150 @@
+RK808 Power Management Integrated Circuit
+
+Required properties:
+- compatible: "rockchip,rk808"
+- reg: I2C slave address
+- interrupt-parent: The parent interrupt controller.
+- interrupts: the interrupt outputs of the controller.
+- #clock-cells: RK808 has 2 clkout, they are always 32khz,
+  the value should be 1
+
+Optional properties:
+- clock-output-names: From common clock binding to override the
+  default output clock name
+- rockchip,system-power-controller: Telling whether or not this pmic is controlling
+  the system power.
+
+Regulators: All the regulators of RK808 to be instantiated shall be
+listed in a child node named 'regulators'. Each regulator is represented
+by a child node of the 'regulators' node.
+
+	regulator-name {
+		/* standard regulator bindings here */
+	};
+
+Following regulators of the RK808 PMIC block are supported. Note that
+the 'n' in regulator name, as in DCDC_REGn or LDOn, represents the DCDC or LDO
+number as described in RK808 datasheet.
+
+	- DCDC_REGn
+		- valid values for n are 1 to 4.
+	- LDO_REGn
+		- valid values for n are 1 to 8.
+	- SWITCH_REGn
+		- valid values for n are 1 to 2
+
+Standard regulator bindings are used inside regulator subnodes. Check
+  Documentation/devicetree/bindings/regulator/regulator.txt
+for more details
+
+Example:
+	rk808: pmic@1b {
+		compatible = "rockchip,rk808";
+		interrupt-parent = <&gpio0>;
+		interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pmic_int>;
+		reg = <0x1b>;
+		#clock-cells = <1>;
+		clock-output-names = "xin32k0", "xin32k1";
+		rockchip,system-power-controller;
+
+		regulators {
+			rk808_dcdc1_reg: DCDC_REG1 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-name = "vdd_arm";
+			};
+
+			rk808_dcdc2_reg: DCDC_REG2 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1250000>;
+				regulator-name = "vdd_gpu";
+			};
+
+			rk808_dcdc3_reg: DCDC_REG3 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-name = "vdd_ddr";
+			};
+
+			rk808_dcdc4_reg: DCDC_REG4 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-name = "vccio";
+			};
+
+			rk808_ldo1_reg: LDO_REG1 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			rk808_ldo2_reg: LDO_REG2 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			rk808_ldo3_reg: LDO_REG3 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-name = "LDO_REG3";
+			};
+
+			rk808_ldo4_reg: LDO_REG4 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			rk808_ldo5_reg: LDO_REG5 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			rk808_ldo6_reg: LDO_REG6 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+			};
+
+			rk808_ldo7_reg: LDO_REG7 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			rk808_ldo8_reg: LDO_REG8 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			rk808_switch1_reg: SWITCH_REG1 {
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			rk808_switch2_reg: SWITCH_REG2 {
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+	};
diff --git a/include/dt-bindings/clock/rockchip,rk808.h b/include/dt-bindings/clock/rockchip,rk808.h
new file mode 100644
index 0000000..1a87343
--- /dev/null
+++ b/include/dt-bindings/clock/rockchip,rk808.h
@@ -0,0 +1,11 @@
+/*
+ * This header provides constants clk index RK808 pmic clkout
+ */
+#ifndef _CLK_ROCKCHIP_RK808
+#define _CLK_ROCKCHIP_RK808
+
+/* CLOCKOUT index */
+#define RK808_CLKOUT0		0
+#define RK808_CLKOUT1		1
+
+#endif
-- 
1.7.9.5


