Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbaGQP0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:26:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60062 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934216AbaGQP0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:26:15 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 3/4] pinctrl: qcom: Add documentation for pinctrl-qpnp driver bindings
Date: Thu, 17 Jul 2014 18:25:47 +0300
Message-Id: <1405610748-7583-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

DT binding documentation for qcom,pm8xxx-mpp pinctrl drivers.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../bindings/pinctrl/qcom,pm8xxx-mpp.txt           | 199 +++++++++++++++++++++
 1 file changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-mpp.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-mpp.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-mpp.txt
new file mode 100644
index 0000000..a797d41
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-mpp.txt
@@ -0,0 +1,199 @@
+Qualcomm PM8XXX Multi-Purpose Pin (MPP) block
+
+This binding describes the MPP block(s) found in the 8xxx series of pmics from
+Qualcomm.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8841-mpp"
+		    "qcom,pm8941-mpp"
+		    "qcom,pma8084-mpp"
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
+			mpp1-mpp4 for pm8841
+			mpp1-mpp8 for pm8941
+			mpp1-mpp4 for pma8084
+
+- function:
+	Usage: mandatory
+	Value type: <string>
+	Definition: Specify the alternative function to be configured for the
+		    specified pins.  Valid values are:
+		    "gpio"  - digital input, output
+		    "ain"   - analog input
+		    "aout"  - analog output
+		    "cs"    - current sink
+
+- bias-disable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins should be configued as no pull.
+
+- bias-pull-up:
+	Usage: optional
+	Value type:  <u32>
+	Definition: The specified pins should be configued as pull up.
+			Valid values are 600, 10000 and 30000.
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
+	Definition: Selects the power source for the specified pins. Valid only
+			when pin operate in Digital I/O mode ("gpio"). Valid
+		    power sources are, as defined in
+		    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
+			0: (PM8XXX_GPIO_VIN0)
+			1: (PM8XXX_GPIO_VIN1)
+			2: (PM8XXX_GPIO_VIN2)
+			3: (PM8XXX_GPIO_VIN3)
+			4: (PM8XXX_GPIO_VIN4)
+			5: (PM8XXX_GPIO_VIN5)
+			6: (PM8XXX_GPIO_VIN6)
+			7: (PM8XXX_GPIO_VIN7)
+
+- drive-strength:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the drive strength for the specified pins. Value
+		    drive strengths are: 5-40mA with 5mA step
+
+- qcom,ain:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the source for analog input. Valid values as
+			defined in <dt-bindings/pinctrl/qcom,pm8xxx-mpp.h>:
+			0: (PM8XXX_MPP_AIN_CH5)
+			1: (PM8XXX_MPP_AIN_CH6)
+			2: (PM8XXX_MPP_AIN_CH7)
+			3: (PM8XXX_MPP_AIN_CH8)
+			4: (PM8XXX_MPP_AIN_ABUS1)
+			5: (PM8XXX_MPP_AIN_ABUS2)
+			6: (PM8XXX_MPP_AIN_ABUS3)
+			7: (PM8XXX_MPP_AIN_ABUS4)
+
+- qcom,aout:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the analog output reference. Valid values as
+			defined in <dt-bindings/pinctrl/qcom,pm8xxx-mpp.h>:
+			0: (PM8XXX_MPP_AOUT_1V25)
+			1: (PM8XXX_MPP_AOUT_0V625)
+			2: (PM8XXX_MPP_AOUT_0V3125)
+			3: (PM8XXX_MPP_AOUT_MPP)
+			4: (PM8XXX_MPP_AOUT_ABUS1)
+			5: (PM8XXX_MPP_AOUT_ABUS2)
+			6: (PM8XXX_MPP_AOUT_ABUS3)
+			7: (PM8XXX_MPP_AOUT_ABUS4)
+
+Example:
+
+	mpps@a000 {
+		compatible = "qcom,pm8841-mpp";
+		reg = <0xa000>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupts = <4 0xa0 0 0>, <4 0xa1 0 0>, <4 0xa2 0 0>, <4 0xa3 0 0>;
+
+		pinctrl-names = "default", "sleep";
+		pinctrl-0 = <&pm8841_default>;
+		pinctrl-1 = <&pm8841_sleep>;
+
+		pm8841_sleep: sleep {
+			gpio {
+				pins = "mpp1", "mpp2", "mpp3", "mpp4";
+				function = "gpio";
+
+				input-enable;
+
+				power-source = <PM8XXX_GPIO_VIN0>;
+				qcom,pull-up = <PM8XXX_GPIO_STRENGTH_NO>;
+				qcom,strength = <PM8XXX_GPIO_PULL_UP_30>;
+			};
+		};
+
+		pm8841_default: default {
+			ain {
+				pins = "mpp1", "mpp2", "mpp3", "mpp4";
+				function = "ain";
+			};
+		};
+	};
-- 
1.8.3.2

