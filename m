Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaJGVfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:35:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35176 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbaJGVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:34:52 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 2/3] pinctrl: meson: add device tree bindings documentation
Date: Tue,  7 Oct 2014 23:32:55 +0200
Message-Id: <1412717576-19737-3-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings documentation for Amlogic Meson pinmux and
GPIO controller.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 .../devicetree/bindings/pinctrl/meson,pinctrl.txt  | 80 ++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt
new file mode 100644
index 0000000..dd573d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/meson,pinctrl.txt
@@ -0,0 +1,80 @@
+* Amlogic Meson pinmux controller
+
+Pins are organized in banks; all banks except AO are controlled by the
+same set of registers, while the AO bank uses a dedicated register
+range. The device tree uses sub-nodes to represent set of banks which
+share the same address space.
+
+Required properties for the root node:
+ - compatible: "amlogic,meson8-pinctrl"
+ - reg: address and size of the common registers controlling gpio irq
+   functionality
+
+Required properties for gpio sub-nodes:
+ - reg: should contain address and size for mux, pull-enable, pull and
+   gpio register sets
+ - reg-names: an array of strings describing the "reg" entries. Must
+   contain "mux", "pull" and "gpio". "pull-enable" is optional and
+   when it is missing the "pull" registers are used instead
+ - gpio-controller: identifies the node as a gpio controller
+ - #gpio-cells: must be 2
+
+Valid gpio sub-nodes name are:
+ - "banks" for the standard banks
+ - "ao-bank" for the AO bank which belong to the special always-on
+   power domain
+
+Required properties for configuration nodes:
+ - pins: the name of a pin group. The list of all available groups can
+   be found in driver sources.
+ - function: the name of a function to activate for the specified set
+   of groups. The list of all available functions can be found in
+   driver sources.
+
+Example:
+
+	pinctrl: pinctrl@c1109880 {
+		compatible = "amlogic,meson8-pinctrl";
+		reg = <0xc1109880 0x10>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		gpio: banks@c11080b0 {
+			reg = <0xc11080b0 0x28>,
+			      <0xc11080e4 0x18>,
+			      <0xc1108120 0x18>,
+			      <0xc1108030 0x30>;
+			reg-names = "mux", "pull-enable", "pull", "gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+               };
+
+		gpio_ao: ao-bank@c1108030 {
+			reg = <0xc8100014 0x4>,
+			      <0xc810002c 0x4>,
+			      <0xc8100024 0x8>;
+			reg-names = "mux", "pull", "gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		nand {
+			nand {
+				pins = "nand_io", "nand_io_ce0", "nand_io_ce1",
+				       "nand_io_rb0", "nand_ale", "nand_cle",
+				       "nand_wen_clk", "nand_ren_clk", "nand_dqs",
+				       "nand_ce2", "nand_ce3";
+				function = "nand";
+			};
+		};
+
+		uart_ao_a: uart_ao_a {
+			uart_ao_a {
+				pins = "uart_tx_ao_a", "uart_rx_ao_a";
+				       "uart_cts_ao_a", "uart_rts_ao_a";
+				function = "uart_ao";
+			};
+		};
+	};
+
-- 
1.9.1

