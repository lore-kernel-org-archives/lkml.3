Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaHUNaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:30:07 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:60366 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaHUNaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:30:05 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <b488f760133b9cb00a44f11ee7e027d4>
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
Subject: [PATCH v3 1/5] MFD: Add rk808 device tree bindings documentation
Date: Thu, 21 Aug 2014 21:27:54 +0800
Message-Id: <1408627674-16130-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk808.txt: Add device tree bindings for rockchip's rk808 pmic.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v3:
- fix compile err

Changes in v2:
Adviced by javier.martinez
- separated from rtc-rk808.c

 Documentation/devicetree/bindings/mfd/rk808.txt |  128 +++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rk808.txt

diff --git a/Documentation/devicetree/bindings/mfd/rk808.txt b/Documentation/devicetree/bindings/mfd/rk808.txt
new file mode 100644
index 0000000..876291d
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/rk808.txt
@@ -0,0 +1,128 @@
+RK808 Power Management Integrated Circuit
+
+Required properties:
+- compatible: "rockchip,rk808"
+- reg: I2C slave address
+- interrupt-parent: The parent interrupt controller.
+- interrupts: the interrupt outputs of the controller.
+- pinctrl-names: Should contain only one value - "default".
+- pinctrl-0: Should specify pin control groups used for this controller.
+- regulators: This is the list of child nodes that specify the regulator
+  initialization data for defined regulators. Not all regulators for the given
+  device need to be present. The definition for each of these nodes is defined
+  using the standard binding for regulators found at
+  Documentation/devicetree/bindings/regulator/regulator.txt.
+
+Optional properties:
+- rockchip,system-power-controller: Telling whether or not this pmic is controlling
+  the system power.
+
+Example:
+rk808: pmic@1b {
+	compatible = "rockchip,rk808";
+	interrupt-parent = <&gpio0>;
+	interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pmic_int>;
+	reg = <0x1b>;
+	rockchip,system-power-controller;
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
-- 
1.7.9.5


