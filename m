Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3LFCKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:10:16 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18943 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab3LFCKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:10:12 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 3/3] pinctrl: Add documentation for pinctrl-msm8x74
Date: Thu, 5 Dec 2013 18:10:05 -0800
Message-ID: <1386295805-13708-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds initial documentation for the pinctrl-msm8x74 driver.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../bindings/pinctrl/qcom,msm8x74-pinctrl.txt      | 92 ++++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
new file mode 100644
index 0000000..70ab78f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
@@ -0,0 +1,92 @@
+Qualcomm MSM8x74 TLMM block
+
+Required properties:
+- compatible: "qcom,msm8x74-pinctrl"
+- reg: Should be the base address and length of the TLMM block.
+- interrupts: Should be the parent IRQ of the TLMM block.
+- interrupt-controller: Marks the device node as an interrupt controller.
+- #interrupt-cells: Should be two.
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells : Should be two.
+                The first cell is the gpio pin number and the
+                second cell is used for optional parameters.
+
+Please refer to ../gpio/gpio.txt and ../interrupt-controller/interrupts.txt for
+a general description of GPIO and interrupt bindings.
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
+
+The following generic properties as defined in pinctrl-bindings.txt are valid
+to specify in a pin configuration subnode:
+ pins, function, bias-disable, bias-pull-down, bias-pull,up, drive-strength.
+
+Non-empty subnodes must specify the 'pins' property.
+Note that not all properties are valid for all pins.
+
+
+Valid values for qcom,pins are:
+  gpio0-gpio145
+    Supports mux, bias and drive-strength
+
+  sdc1_clk, sdc1_cmd, sdc1_data, sdc2_clk, sdc2_cmd, sdc2_data
+    Supports bias and drive-strength
+
+Valid values for qcom,function are:
+  blsp_i2c2, blsp_i2c6, blsp_i2c11, blsp_spi1, blsp_uart2, blsp_uart8, slimbus
+
+  (Note that this is not yet the complete list of functions)
+
+
+
+Example:
+
+	msmgpio: pinctrl@fd510000 {
+		compatible = "qcom,msm8x74-pinctrl";
+		reg = <0xfd510000 0x4000>;
+
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupts = <0 208 0>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart2_default>;
+
+		uart2_default: uart2_default {
+			mux {
+				qcom,pins = "gpio4", "gpio5";
+				qcom,function = "blsp_uart2";
+			};
+
+			tx {
+				qcom,pins = "gpio4";
+				drive-strength = <4>;
+				bias-disable;
+			};
+
+			rx {
+				qcom,pins = "gpio5";
+				drive-strength = <2>;
+				bias-pull-up;
+			};
+		};
+	};
-- 
1.8.2.2

