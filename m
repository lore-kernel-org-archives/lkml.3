Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaGHB0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:26:42 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16437 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbaGHB0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:26:32 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx gpio block
Date: Mon, 7 Jul 2014 18:26:24 -0700
Message-ID: <1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduced the device tree bindings for the gpio block found in
pm8018, pm8038, pm8058, pm8917 and pm8921 pmics from Qualcomm.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../bindings/pinctrl/qcom,pm8xxx-gpio.txt          |  230 ++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h     |   34 +++
 2 files changed, 264 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
 create mode 100644 include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
new file mode 100644
index 0000000..0035dd8
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
@@ -0,0 +1,230 @@
+Qualcomm PM8XXX GPIO block
+
+This binding describes the GPIO block(s) found in the 8xxx series of pmics from
+Qualcomm.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+			"qcom,pm8018-gpio"
+			"qcom,pm8038-gpio"
+			"qcom,pm8058-gpio"
+			"qcom,pm8917-gpio"
+			"qcom,pm8921-gpio"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: Register base of the gpio block
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Must contain an array of encoded interrupt specifiers for
+		    each available gpio
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
+The pin configuration nodes act as a container for an abitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin or a list of pins. This configuration can include the
+mux function to select on those pin(s), and various pin configuration
+parameters, s listed below.
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
+			gpio1-gpio6 for pm8018
+			gpio1-gpio12 for pm8038
+			gpio1-gpio40 for pm8058
+			gpio1-gpio38 for pm8917
+			gpio1-gpio44 for pm8921
+
+- function:
+	Usage: optional
+	Value type: <string>
+	Definition: Specify the alternative function to be configured for the
+		    specified pins.  Valid values are:
+			"normal",
+			"paired",
+			"func1",
+			"func2",
+			"dtest1",
+			"dtest2",
+			"dtest3",
+			"dtest4"
+
+- bias-disable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins should be configued as no pull.
+
+- bias-pull-down:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins should be configued as pull down.
+
+- bias-pull-up:
+	Usage: optional
+	Value type: <u32> (optional)
+	Definition: The specified pins should be configued as pull up. An
+		    optional argument can be used to configure the strength.
+		    Valid values are; as defined in
+		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
+		    1: 30uA			(PM8XXX_GPIO_PULL_UP_30)
+		    2: 1.5uA			(PM8XXX_GPIO_PULL_UP_1P5)
+		    3: 31.5uA			(PM8XXX_GPIO_PULL_UP_31P5)
+		    4: 1.5uA + 30uA boost	(PM8XXX_GPIO_PULL_UP_1P5_30)
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
+		    power sources are, as defined in
+		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
+			0: bb (PM8XXX_GPIO_VIN_BB)
+				valid for pm8038, pm8058, pm8917, pm8921
+			1: ldo2 (PM8XXX_GPIO_VIN_L2)
+				valid for pm8018, pm8038, pm8917,pm8921
+			2: ldo3 (PM8XXX_GPIO_VIN_L3)
+				valid for pm8038, pm8058, pm8917, pm8921
+			3: ldo4 (PM8XXX_GPIO_VIN_L4)
+				valid for pm8018, pm8917, pm8921
+			4: ldo5 (PM8XXX_GPIO_VIN_L5)
+				valid for pm8018, pm8058
+			5: ldo6 (PM8XXX_GPIO_VIN_L6)
+				valid for pm8018, pm8058
+			6: ldo7 (PM8XXX_GPIO_VIN_L7)
+				valid for pm8058
+			7: ldo8 (PM8XXX_GPIO_VIN_L8)
+				valid for pm8018
+			8: ldo11 (PM8XXX_GPIO_VIN_L11)
+				valid for pm8038
+			9: ldo14 (PM8XXX_GPIO_VIN_L14)
+				valid for pm8018
+			10: ldo15 (PM8XXX_GPIO_VIN_L15)
+				valid for pm8038, pm8917, pm8921
+			11: ldo17 (PM8XXX_GPIO_VIN_L17)
+				valid for pm8038, pm8917, pm8921
+			12: smps3 (PM8XXX_GPIO_VIN_S3)
+				valid for pm8018, pm8058
+			13: smps4 (PM8XXX_GPIO_VIN_S4)
+				valid for pm8921
+			14: vph (PM8XXX_GPIO_VIN_VPH)
+				valid for pm8018, pm8038, pm8058, pm8917 pm8921
+
+- drive-strength:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the drive strength for the specified pins. Value
+		    drive strengths are:
+			0: no	(PM8XXX_GPIO_STRENGTH_NO)
+			1: high	(PM8XXX_GPIO_STRENGTH_HIGH)
+			2: medium	(PM8XXX_GPIO_STRENGTH_MED)
+			3: low	(PM8XXX_GPIO_STRENGTH_LOW)
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
+
+Example:
+
+	pm8921_gpio: gpio@150 {
+		compatible = "qcom,pm8921-gpio";
+		reg = <0x150>;
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
+				drive-strength = <PM8XXX_GPIO_STRENGTH_NO>;
+				power-source = <PM8XXX_GPIO_VIN_S4>;
+			};
+		};
+	};
diff --git a/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h b/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h
new file mode 100644
index 0000000..6b66fff
--- /dev/null
+++ b/include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h
@@ -0,0 +1,34 @@
+/*
+ * This header provides constants for the pm8xxx gpio binding.
+ */
+
+#ifndef _DT_BINDINGS_PINCTRL_QCOM_PM8XXX_GPIO_H
+#define _DT_BINDINGS_PINCTRL_QCOM_PM8XXX_GPIO_H
+
+#define PM8XXX_GPIO_PULL_UP_30		1
+#define PM8XXX_GPIO_PULL_UP_1P5		2
+#define PM8XXX_GPIO_PULL_UP_31P5	3
+#define PM8XXX_GPIO_PULL_UP_1P5_30	4
+
+#define PM8XXX_GPIO_VIN_BB		0
+#define PM8XXX_GPIO_VIN_L2		1
+#define PM8XXX_GPIO_VIN_L3		2
+#define PM8XXX_GPIO_VIN_L4		3
+#define PM8XXX_GPIO_VIN_L5		4
+#define PM8XXX_GPIO_VIN_L6		5
+#define PM8XXX_GPIO_VIN_L7		6
+#define PM8XXX_GPIO_VIN_L8		7
+#define PM8XXX_GPIO_VIN_L11		8
+#define PM8XXX_GPIO_VIN_L14		9
+#define PM8XXX_GPIO_VIN_L15		10
+#define PM8XXX_GPIO_VIN_L17		11
+#define PM8XXX_GPIO_VIN_S3		12
+#define PM8XXX_GPIO_VIN_S4		13
+#define PM8XXX_GPIO_VIN_VPH		14
+
+#define	PM8XXX_GPIO_STRENGTH_NO		0
+#define	PM8XXX_GPIO_STRENGTH_HIGH	1
+#define	PM8XXX_GPIO_STRENGTH_MED	2
+#define	PM8XXX_GPIO_STRENGTH_LOW	3
+
+#endif
-- 
1.7.9.5

