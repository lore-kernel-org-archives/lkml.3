Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaIOOoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:44:22 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45764 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbaIOOoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:44:18 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        David Collins <collinsd@codeaurora.org>,
        Wu Fenglin <fenglinw@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 2/4] pinctrl: Device tree bindings for Qualcomm PMIC MPP block
Date: Mon, 15 Sep 2014 17:44:12 +0300
Message-Id: <1410792254-24126-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410792254-24126-1-git-send-email-iivanov@mm-sol.com>
References: <1410792254-24126-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DeviceTree binding documentation for Qualcomm SPMI PMIC MPP
pinctrl drivers.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  | 159 +++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |  44 ++++++
 2 files changed, 203 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
new file mode 100644
index 0000000..9d4779f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
@@ -0,0 +1,159 @@
+Qualcomm PMIC Multi-Purpose Pin (MPP) block
+
+This binding describes the MPP block(s) found in the 8xxx series
+of PMIC's from Qualcomm.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: Should contain "qcom,spmi-pmic-mpp"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Register base of the MPP block and length.
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
+The pin configuration nodes act as a container for an arbitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin or a list of pins. This configuration can include the
+mux function to select on those pin(s), and various pin configuration
+parameters, as listed below.
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
+		    mpp1-mpp4 for pm8841
+		    mpp1-mpp8 for pm8941
+		    mpp1-mpp4 for pma8084
+
+- function:
+	Usage: required
+	Value type: <string>
+	Definition: Specify the alternative function to be configured for the
+		    specified pins.  Valid values are:
+		    "normal",
+		    "paired",
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
+- bias-pull-up:
+	Usage: optional
+	Value type: <u32>
+	Definition: The specified pins should be configured as pull up.
+		    Valid values are 600, 10000 and 30000 in bidirectional mode only,
+		    i.e. when operating in qcom,analog-mode and input and outputs are
+		    enabled. The hardware ignores the configuration when operating in
+		    other modes.
+
+- bias-high-impedance:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins will put in high-Z mode and disabled.
+
+- input-enable:
+	Usage: optional
+	Value type: <none>
+	Definition: The specified pins are put in input mode, i.e. thier input
+		    buffer is enabled
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
+	Definition: Selects the power source for the specified pins. Valid power
+		    sources are defined in <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+
+- qcom,analog-mode:
+	Usage: optional
+	Value type: <none>
+	Definition: Selects Analog mode of operation: combined with input-enable
+		    and/or output-high, output-log MPP could operate as Bidirectional
+		    Logic, Analog Input, Analog Output.
+
+- qcom,amux-route:
+	Usage: optional
+	Value type: <u32>
+	Definition: Selects the source for analog input. Valid values are
+		    defined in <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+		    PMIC_MPP_AMUX_ROUTE_CH5, PMIC_MPP_AMUX_ROUTE_CH6...
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
+		pinctrl-names = "default";
+		pinctrl-0 = <&pm8841_default>;
+
+		pm8841_default: default {
+			gpio {
+				pins = "mpp1", "mpp2", "mpp3", "mpp4";
+				function = "normal";
+				input-enable;
+				power-source = <PM8841_MPP_S3>;
+			};
+		};
+	};
diff --git a/include/dt-bindings/pinctrl/qcom,pmic-mpp.h b/include/dt-bindings/pinctrl/qcom,pmic-mpp.h
new file mode 100644
index 0000000..d2c7dab
--- /dev/null
+++ b/include/dt-bindings/pinctrl/qcom,pmic-mpp.h
@@ -0,0 +1,44 @@
+/*
+ * This header provides constants for the Qualcomm PMIC's
+ * Multi-Purpose Pin binding.
+ */
+
+#ifndef _DT_BINDINGS_PINCTRL_QCOM_PMIC_MPP_H
+#define _DT_BINDINGS_PINCTRL_QCOM_PMIC_MPP_H
+
+/* power-source */
+#define PM8841_MPP_VPH			0
+#define PM8841_MPP_S3			2
+
+#define PM8941_MPP_VPH			0
+#define PM8941_MPP_L1			1
+#define PM8941_MPP_S3			2
+#define PM8941_MPP_L6			3
+
+#define PMA8084_MPP_VPH			0
+#define PMA8084_MPP_L1			1
+#define PMA8084_MPP_S4			2
+#define PMA8084_MPP_L6			3
+
+/*
+ * Analog Input - Set the source for analog input.
+ * To be used with "qcom,amux-route" property
+ */
+#define PMIC_MPP_AMUX_ROUTE_CH5		0
+#define PMIC_MPP_AMUX_ROUTE_CH6		1
+#define PMIC_MPP_AMUX_ROUTE_CH7		2
+#define PMIC_MPP_AMUX_ROUTE_CH8		3
+#define PMIC_MPP_AMUX_ROUTE_ABUS1	4
+#define PMIC_MPP_AMUX_ROUTE_ABUS2	5
+#define PMIC_MPP_AMUX_ROUTE_ABUS3	6
+#define PMIC_MPP_AMUX_ROUTE_ABUS4	7
+
+/* To be used with "function" */
+#define PMIC_MPP_FUNC_NORMAL		"normal"
+#define PMIC_MPP_FUNC_PAIRED		"paired"
+#define PMIC_MPP_FUNC_DTEST1		"dtest1"
+#define PMIC_MPP_FUNC_DTEST2		"dtest2"
+#define PMIC_MPP_FUNC_DTEST3		"dtest3"
+#define PMIC_MPP_FUNC_DTEST4		"dtest4"
+
+#endif
-- 
1.9.1

