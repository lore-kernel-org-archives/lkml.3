Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaGGPNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:13:11 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35836 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaGGPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:12:21 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/4] pinctrl: qcom: Add documentation for pinctrl-qpnp binding
Date: Mon,  7 Jul 2014 18:11:31 +0300
Message-Id: <1404745893-6379-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

DT binding documentation for qcom,pm8941-pinctrl and
qcom,pm8841-pinctrl drivers.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../bindings/pinctrl/qcom,qpnp-pinctrl.txt         | 78 ++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,qpnp-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,qpnp-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,qpnp-pinctrl.txt
new file mode 100644
index 0000000..0b24860
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,qpnp-pinctrl.txt
@@ -0,0 +1,78 @@
+Qualcomm Technologies (QTI) QPNP pinctrl controller
+
+Qualcomm Technologies (QTI) PMIC chips integrate SPMI based MPP (multiple
+purpose pin) and GPIO pin configuration hardware modules. These modules control
+the pin settings, including types/functions/directions/pulls/drive-strength/
+input/output, etc.
+
+They are two types of pins inside PMIC chips. Multi-Purpose Pin (MPP) and
+General Purpuse Pins (GPIO)
+
+MPP pins are supporting following functions:
+Digital Input, Digital Output, Analog Input, Analog Output and Current Sink
+
+GPIO pins are supporting following functions:
+Digital Input, Digital Output
+
+Required Properties:
+ - compatible: Should contain "qcom,pm8941-pinctrl" or "qcom,pm8841-pinctrl".
+ - reg:        MPP's configuration registers map offset
+               GPIO's configuration registers map offset - optional
+ - gpio-controller: Marks the device node as a GPIO controller.
+ - #gpio-cells : Should be two.
+                The first cell is the gpio pin number and the
+                second cell is used for optional parameters.
+
+Please refer to ../gpio/gpio.txt for a general description of GPIO bindings.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+Qualcomm's pin configuration nodes act as a container for an abitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those pin(s)/group(s), and various pin configuration
+parameters, such as pull-up, drive strength, etc.
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
+Valid functions for MPPs are gpio, mpp-ain, mpp-aout, mpp-cs.
+Valid function for GPIOs is gpio.
+
+Valid names for PM8841 pins are mpp1-mpp4.
+Valid names for PM8941 pins are mpp1-mpp8 and gpio1-gpio36.
+
+The following generic properties as defined in pinctrl-bindings.txt are valid
+to specify in a GPIO pin configuration subnode:
+
+ pins, function, bias-disable, bias-pull-down, bias-pull,up, drive-strength.
+ bias-high-impedance, drive-push-pull, drive-open-drain, drive-open-source,
+ input-enable, input-disable, power-source, output-low, output-high
+
+The following generic properties as defined in pinctrl-bindings.txt are valid
+to specify in a MPP pin configuration subnode:
+
+ pins, function, bias-disable, bias-pull,up, drive-strength.
+ bias-high-impedance, input-enable, input-disable, power-source, output-low,
+ output-high,
+
+The following non-standard properties are valid to specify in a MPP pin
+configuration subnode:
+ qcom,ain-ctrl, qcom,aout-ctrl
+
+Example:
+
+	pm8941_pinctrl: pins@a000 {
+		compatible = "qcom,pm8941-pinctrl";
+		reg = <0xa000>, <0xc000>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
-- 
1.8.3.2

