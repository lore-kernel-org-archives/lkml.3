Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaIAJUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:20:25 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:56519 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbaIAJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:20:23 -0400
X-RL-SENDER: zyw@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <a650cf93922cdd48c646650fe9ece5c8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com, Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v7 1/5] dt-bindings: Add RK808 device tree bindings document
Date: Mon,  1 Sep 2014 17:07:44 +0800
Message-Id: <1409562468-16586-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings documentation and a header file
for rockchip's RK808 pmic.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>

---

Changes in v7:
Advices by Mark Rutland
- modify description about clock-cells
- update the example

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

 Documentation/devicetree/bindings/mfd/rk808.txt |  166 +++++++++++++++++++++++
 include/dt-bindings/clock/rockchip,rk808.h      |   11 ++
 2 files changed, 177 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt
 create mode 100644 include/dt-bindings/clock/rockchip,rk808.h

diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
new file mode 100644
index 0000000..f8932ac
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rk808.txt
@@ -0,0 +1,166 @@
+RK808 Power Management Integrated Circuit
+
+Required properties:
+- compatible: "rockchip,rk808"
+- reg: I2C slave address
+- interrupt-parent: The parent interrupt controller.
+- interrupts: the interrupt outputs of the controller.
+- #clock-cells: from common clock binding; shall be set to 1 (multiple clock
+  outputs)
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
+		clock-output-names = "xin32k", "rk808-clkout2";
+		interrupt-parent = <&gpio0>;
+		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pmic_int>;
+		reg = <0x1b>;
+		rockchip,system-power-controller;
+		wakeup-source;
+		#clock-cells = <1>;
+
+		vcc8-supply = <&vcc_18>;
+		vcc9-supply = <&vcc_io>;
+		vcc10-supply = <&vcc_io>;
+		vcc12-supply = <&vcc_io>;
+		vddio-supply = <&vccio_pmu>;
+
+		regulators {
+			vdd_cpu: DCDC_REG1 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-name = "vdd_arm";
+			};
+
+			vdd_gpu: DCDC_REG2 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1250000>;
+				regulator-name = "vdd_gpu";
+			};
+
+			vcc_ddr: DCDC_REG3 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-name = "vcc_ddr";
+			};
+
+			vcc_io: DCDC_REG4 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-name = "vcc_io";
+			};
+
+			vccio_pmu: LDO_REG1 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-name = "vccio_pmu";
+			};
+
+			vcc_tp: LDO_REG2 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-name = "vcc_tp";
+			};
+
+			vdd_10: LDO_REG3 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-name = "vdd_10";
+			};
+
+			vcc18_lcd: LDO_REG4 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-name = "vcc18_lcd";
+			};
+
+			vccio_sd: LDO_REG5 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-name = "vccio_sd";
+			};
+
+			vdd10_lcd: LDO_REG6 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-name = "vdd10_lcd";
+			};
+
+			vcc_18: LDO_REG7 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-name = "vcc_18";
+			};
+
+			vcca_codec: LDO_REG8 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-name = "vcca_codec";
+			};
+
+			vcc_wl: SWITCH_REG1 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-name = "vcc_wl";
+			};
+
+			vcc_lcd: SWITCH_REG2 {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-name = "vcc_lcd";
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

