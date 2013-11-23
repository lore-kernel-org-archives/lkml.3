Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3KWXib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 18:38:31 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19017 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176Ab3KWXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 18:38:24 -0500
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
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] pinctrl: Add documentation for pinctrl-msm8x74
Date: Sat, 23 Nov 2013 15:38:17 -0800
Message-ID: <1385249897-16453-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1385249897-16453-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1385249897-16453-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1385249897-16453-2-git-send-email-bjorn.andersson@sonymobile.com>
 <1385249897-16453-3-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds initial documentation for the pinctrl-msm8x74 driver.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../bindings/pinctrl/qcom,msm8x74-pinctrl.txt      | 86 ++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
new file mode 100644
index 0000000..539abd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
@@ -0,0 +1,86 @@
+Qualcomm MSM8x74 TLMM block
+
+Required properties:
+- compatible: "qcom,msm8x74-pinctrl"
+- reg: Should be the base address of the TLMM block.
+- interrupts: Should be the irq of the TLMM summary interrupt.
+- interrupt-controller: Marks the device node as an interrupt controller.
+- #interrupt-cells: Should be two.
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells : Should be two.
+                The first cell is the gpio pin number and the
+                second cell is used for optional parameters.
+
+Please refer to ../gpio/gpio.txt for a general description of GPIO bindings.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+Each subnode describes properties for the given pins.
+
+Required subnode-properties:
+- qcom,pins: An array of strings, each matching a pin or group to be
+             configured. Possible values are listed below.
+
+Optional subnode-properties:
+- qcom,function: A name of the function to be muxed to the specified
+                 pins. Possible values are listed below.
+- bias-disable: Configure the specified pins as no pull.
+- bias-pull-down: Configure the specified pins as pull down.
+- bias-pull-up: Configure the specified pins as pull up.
+- drive-strength: Configure the drive strength of the specified pins.
+
+Note that not all optional properties are valid for all pins.
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
+		uart2 {
+			uart2_default: uart2_default {
+				mux {
+					qcom,pins = "gpio4", "gpio5";
+					qcom,function = "blsp_uart2";
+				};
+
+				tx {
+					qcom,pins = "gpio4";
+					drive-strength = <4>;
+					bias-disable;
+				};
+
+				rx {
+					qcom,pins = "gpio5";
+					drive-strength = <2>;
+					bias-pull-up;
+				};
+			};
+		};
+	};
-- 
1.8.2.2

