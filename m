Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaJVJ6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:58:55 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49658 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbaJVJ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:58:40 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v6 1/4] pinctrl: Device tree bindings for Qualcomm PMIC GPIO block
Date: Wed, 22 Oct 2014 12:58:44 +0300
Message-Id: <1413971927-9168-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971927-9168-1-git-send-email-iivanov@mm-sol.com>
References: <1413971927-9168-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@sonymobile.com>

This introduced the device tree bindings for the GPIO block found
in PMIC's from Qualcomm.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt | 215 +++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       | 142 ++++++++++++++
 2 files changed, 357 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
new file mode 100644
index 0000000..7ed0804
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
@@ -0,0 +1,215 @@
+Qualcomm PMIC GPIO block
+
+This binding describes the GPIO block(s) found in the 8xxx series of
+PMIC's from Qualcomm.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8018-gpio"
+		    "qcom,pm8038-gpio"
+		    "qcom,pm8058-gpio"
+		    "qcom,pm8917-gpio"
+		    "qcom,pm8921-gpio"
+		    "qcom,pm8941-gpio"
+		    "qcom,pma8084-gpio"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Register base of the GPIO block and length.
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Must contain an array of encoded interrupt specifiers for
+		    each available GPIO
+
+- gpio-controller:
+	Usage: required
+	Value type: <none>
+	Definition: Mark the device node as a GPIO controller
+
+- #gpio-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: Must be 2;
+		    the first cell will be used to define gpio number and the
+		    second denotes the flags for this gpio
+
+Please refer to ../gpio/gpio.txt and ../interrupt-controller/interrupts.txt for
+a general description of GPIO and interrupt bindings.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+The pin configuration nodes act as a container for an arbitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin or a list of pins. This configuration can include the
+mux function to select on those pin(s), and various pin configuration
+parameters, as listed below.
+
+
+SUBNODES:
+
+The name of each subnode is not important; all subnodes should be enumerated
+and processed purely based on their content.
+
+Each subnode only affects those parameters that are explicitly listed. In
+other words, a subnode that lists a mux function but no pin configuration
+parameters implies no information about any pin configuration parameters.
+Similarly, a pin subnode that describes a pullup parameter implies no
+information about e.g. the mux function.
+
+The following generic properties as defined in pinctrl-bindings.txt are valid
+to specify in a pin configuration subnode:
+
+- pins:
+	Usage: required
+	Value type: <string-array>
+	Definition: List of gpio pins affected by the properties specified in
+		    this subnode.  Valid pins are:
+		    gpio1-gpio6 for pm8018
+		    gpio1-gpio12 for pm8038
+		    gpio1-gpio40 for pm8058
+		    gpio1-gpio38 for pm8917
+		    gpio1-gpio44 for pm8921
+		    gpio1-gpio36 for pm8941
+		    gpio1-gpio22 for pma8084
+
+- function:
+	Usage: required
+	Value type: <string>
+	Definition: Specify the alternative function to be configured for the
+		    specified pins.  Valid values are:
+		    "normal",
+		    "paired",
+		    "func1",
+		    "func2",
+		    "dtest1",
+		    "dtest2",
+		    "dtest3",
+		    "dtest4"
+
+- bias-disable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins should be configured as no pull.
+
+- bias-pull-down:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins should be configured as pull down.
+
+- bias-pull-up:
+	Usage: optional
+	Value type: <empty>
+	Definition: The specified pins should be configured as pull up.
+
+- qcom,pull-up-strength:
+	Usage: optional
+	Value type: <u32>
+	Definition: Specifies the strength to use for pull up, if selected.
+		    Valid values are; as defined in
+		    <dt-bindings/pinctrl/qcom,pmic-gpio.h>:
+		    1: 30uA                     (PMIC_GPIO_PULL_UP_30)
+		    2: 1.5uA                    (PMIC_GPIO_PULL_UP_1P5)
+		    3: 31.5uA                   (PMIC_GPIO_PULL_UP_31P5)
+		    4: 1.5uA + 30uA boost       (PMIC_GPIO_PULL_UP_1P5_30)
+		    If this property is ommited 30uA strength will be used if
+		    pull up is selected
+
+- bias-high-impedance:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins will put in high-Z mode and disabled.
+
+- input-enable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are put in input mode.
+
+- output-high:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in output mode, driven
+		    high.
+
+- output-low:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in output mode, driven
+		    low.
+
+- power-source:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the power source for the specified pins. Valid
+		    power sources are defined per chip in
+		    <dt-bindings/pinctrl/qcom,pmic-gpio.h>
+
+- qcom,drive-strength:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the drive strength for the specified pins. Value
+		    drive strengths are:
+		    0: no (PMIC_GPIO_STRENGTH_NO)
+		    1: high (PMIC_GPIO_STRENGTH_HIGH) 0.9mA @ 1.8V - 1.9mA @ 2.6V
+		    2: medium (PMIC_GPIO_STRENGTH_MED) 0.6mA @ 1.8V - 1.25mA @ 2.6V
+		    3: low (PMIC_GPIO_STRENGTH_LOW) 0.15mA @ 1.8V - 0.3mA @ 2.6V
+		    as defined in <dt-bindings/pinctrl/qcom,pmic-gpio.h>
+
+- drive-push-pull:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in push-pull mode.
+
+- drive-open-drain:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in open-drain mode.
+
+- drive-open-source:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are configured in open-source mode.
+
+Example:
+
+	pm8921_gpio: gpio@150 {
+		compatible = "qcom,pm8921-gpio";
+		reg = <0x150 0x160>;
+		interrupts = <192 1>, <193 1>, <194 1>,
+			     <195 1>, <196 1>, <197 1>,
+			     <198 1>, <199 1>, <200 1>,
+			     <201 1>, <202 1>, <203 1>,
+			     <204 1>, <205 1>, <206 1>,
+			     <207 1>, <208 1>, <209 1>,
+			     <210 1>, <211 1>, <212 1>,
+			     <213 1>, <214 1>, <215 1>,
+			     <216 1>, <217 1>, <218 1>,
+			     <219 1>, <220 1>, <221 1>,
+			     <222 1>, <223 1>, <224 1>,
+			     <225 1>, <226 1>, <227 1>,
+			     <228 1>, <229 1>, <230 1>,
+			     <231 1>, <232 1>, <233 1>,
+			     <234 1>, <235 1>;
+
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		pm8921_gpio_keys: gpio-keys {
+			volume-keys {
+				pins = "gpio20", "gpio21";
+				function = "normal";
+
+				input-enable;
+				bias-pull-up;
+				drive-push-pull;
+				qcom,drive-strength = <PMIC_GPIO_STRENGTH_NO>;
+				power-source = <PM8921_GPIO_S4>;
+			};
+		};
+	};
diff --git a/include/dt-bindings/pinctrl/qcom,pmic-gpio.h b/include/dt-bindings/pinctrl/qcom,pmic-gpio.h
new file mode 100644
index 0000000..fa74d7c
--- /dev/null
+++ b/include/dt-bindings/pinctrl/qcom,pmic-gpio.h
@@ -0,0 +1,142 @@
+/*
+ * This header provides constants for the Qualcomm PMIC GPIO binding.
+ */
+
+#ifndef _DT_BINDINGS_PINCTRL_QCOM_PMIC_GPIO_H
+#define _DT_BINDINGS_PINCTRL_QCOM_PMIC_GPIO_H
+
+#define PMIC_GPIO_PULL_UP_30		0
+#define PMIC_GPIO_PULL_UP_1P5		1
+#define PMIC_GPIO_PULL_UP_31P5		2
+#define PMIC_GPIO_PULL_UP_1P5_30	3
+
+#define PMIC_GPIO_STRENGTH_NO		0
+#define PMIC_GPIO_STRENGTH_HIGH		1
+#define PMIC_GPIO_STRENGTH_MED		2
+#define PMIC_GPIO_STRENGTH_LOW		3
+
+/*
+ * Note: PM8018 GPIO3 and GPIO4 are supporting
+ * only S3 and L2 options (1.8V)
+ */
+#define PM8018_GPIO_L6			0
+#define PM8018_GPIO_L5			1
+#define PM8018_GPIO_S3			2
+#define PM8018_GPIO_L14			3
+#define PM8018_GPIO_L2			4
+#define PM8018_GPIO_L4			5
+#define PM8018_GPIO_VDD			6
+
+/*
+ * Note: PM8038 GPIO7 and GPIO8 are supporting
+ * only L11 and L4 options (1.8V)
+ */
+#define PM8038_GPIO_VPH			0
+#define PM8038_GPIO_BB			1
+#define PM8038_GPIO_L11			2
+#define PM8038_GPIO_L15			3
+#define PM8038_GPIO_L4			4
+#define PM8038_GPIO_L3			5
+#define PM8038_GPIO_L17			6
+
+#define PM8058_GPIO_VPH			0
+#define PM8058_GPIO_BB			1
+#define PM8058_GPIO_S3			2
+#define PM8058_GPIO_L3			3
+#define PM8058_GPIO_L7			4
+#define PM8058_GPIO_L6			5
+#define PM8058_GPIO_L5			6
+#define PM8058_GPIO_L2			7
+
+#define PM8917_GPIO_VPH			0
+#define PM8917_GPIO_S4			2
+#define PM8917_GPIO_L15			3
+#define PM8917_GPIO_L4			4
+#define PM8917_GPIO_L3			5
+#define PM8917_GPIO_L17			6
+
+#define PM8921_GPIO_VPH			0
+#define PM8921_GPIO_BB			1
+#define PM8921_GPIO_S4			2
+#define PM8921_GPIO_L15			3
+#define PM8921_GPIO_L4			4
+#define PM8921_GPIO_L3			5
+#define PM8921_GPIO_L17			6
+
+/*
+ * Note: PM8941 gpios from 15 to 18 are supporting
+ * only S3 and L6 options (1.8V)
+ */
+#define PM8941_GPIO_VPH			0
+#define PM8941_GPIO_L1			1
+#define PM8941_GPIO_S3			2
+#define PM8941_GPIO_L6			3
+
+/*
+ * Note: PMA8084 gpios from 15 to 18 are supporting
+ * only S4 and L6 options (1.8V)
+ */
+#define PMA8084_GPIO_VPH		0
+#define PMA8084_GPIO_L1			1
+#define PMA8084_GPIO_S4			2
+#define PMA8084_GPIO_L6			3
+
+/* To be used with "function" */
+#define PMIC_GPIO_FUNC_NORMAL		"normal"
+#define PMIC_GPIO_FUNC_PAIRED		"paired"
+#define PMIC_GPIO_FUNC_FUNC1		"func1"
+#define PMIC_GPIO_FUNC_FUNC2		"func2"
+#define PMIC_GPIO_FUNC_DTEST1		"dtest1"
+#define PMIC_GPIO_FUNC_DTEST2		"dtest2"
+#define PMIC_GPIO_FUNC_DTEST3		"dtest3"
+#define PMIC_GPIO_FUNC_DTEST4		"dtest4"
+
+#define PM8038_GPIO1_2_LPG_DRV		PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO3_5V_BOOST_EN	PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO4_SSBI_ALT_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO5_6_EXT_REG_EN	PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO10_11_EXT_REG_EN	PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO6_7_CLK		PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO9_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
+#define PM8038_GPIO6_12_KYPD_DRV	PMIC_GPIO_FUNC_FUNC2
+
+#define PM8058_GPIO7_8_MP3_CLK		PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO7_8_BCLK_19P2MHZ	PMIC_GPIO_FUNC_FUNC2
+#define PM8058_GPIO9_26_KYPD_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO21_23_UART_TX	PMIC_GPIO_FUNC_FUNC2
+#define PM8058_GPIO24_26_LPG_DRV	PMIC_GPIO_FUNC_FUNC2
+#define PM8058_GPIO33_BCLK_19P2MHZ	PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO34_35_MP3_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO36_BCLK_19P2MHZ	PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO37_UPL_OUT		PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO37_UART_M_RX		PMIC_GPIO_FUNC_FUNC2
+#define PM8058_GPIO38_XO_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO38_39_CLK_32KHZ	PMIC_GPIO_FUNC_FUNC2
+#define PM8058_GPIO39_MP3_CLK		PMIC_GPIO_FUNC_FUNC1
+#define PM8058_GPIO40_EXT_BB_EN		PMIC_GPIO_FUNC_FUNC1
+
+#define PM8917_GPIO9_18_KEYP_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PM8917_GPIO20_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
+#define PM8917_GPIO21_23_UART_TX	PMIC_GPIO_FUNC_FUNC2
+#define PM8917_GPIO25_26_EXT_REG_EN	PMIC_GPIO_FUNC_FUNC1
+#define PM8917_GPIO37_38_XO_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PM8917_GPIO37_38_MP3_CLK	PMIC_GPIO_FUNC_FUNC2
+
+#define PM8941_GPIO9_14_KYPD_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO15_18_DIV_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO15_18_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC2
+#define PM8941_GPIO23_26_KYPD_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO23_26_LPG_DRV_HI	PMIC_GPIO_FUNC_FUNC2
+#define PM8941_GPIO31_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO33_36_LPG_DRV_3D	PMIC_GPIO_FUNC_FUNC1
+#define PM8941_GPIO33_36_LPG_DRV_HI	PMIC_GPIO_FUNC_FUNC2
+
+#define PMA8084_GPIO4_5_LPG_DRV		PMIC_GPIO_FUNC_FUNC1
+#define PMA8084_GPIO7_10_LPG_DRV	PMIC_GPIO_FUNC_FUNC1
+#define PMA8084_GPIO5_14_KEYP_DRV	PMIC_GPIO_FUNC_FUNC2
+#define PMA8084_GPIO19_21_KEYP_DRV	PMIC_GPIO_FUNC_FUNC2
+#define PMA8084_GPIO15_18_DIV_CLK	PMIC_GPIO_FUNC_FUNC1
+#define PMA8084_GPIO15_18_SLEEP_CLK	PMIC_GPIO_FUNC_FUNC2
+#define PMA8084_GPIO22_BAT_ALRM_OUT	PMIC_GPIO_FUNC_FUNC1
+
+#endif
-- 
1.9.1

