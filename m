Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3HDJ7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:59:22 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37144 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767Ab3HDJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:59:14 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 2/9] ARM: sun7i: Add Allwinner A20 DTSI
Date: Sun,  4 Aug 2013 11:58:43 +0200
Message-Id: <1375610330-18185-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A20 SoC is based on 2 Cortex A7, an ARM Mali GPU, and is
built to be pin-compatible with the older Allwinner A10.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 172 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun7i-a20.dtsi

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
new file mode 100644
index 0000000..0a2fd74
--- /dev/null
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -0,0 +1,172 @@
+/*
+ * Copyright 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		osc24M: osc24M@01c20050 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+
+		osc32k: osc32k {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+	};
+
+	soc@01c00000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		timer@01c20c00 {
+			compatible = "allwinner,sun4i-timer";
+			reg = <0x01c20c00 0x90>;
+			interrupts = <0 22 1>,
+				     <0 23 1>,
+				     <0 24 1>,
+				     <0 25 1>,
+				     <0 67 1>,
+				     <0 68 1>;
+			clocks = <&osc24M>;
+		};
+
+		wdt: watchdog@01c20c90 {
+			compatible = "allwinner,sun4i-wdt";
+			reg = <0x01c20c90 0x10>;
+		};
+
+		uart0: serial@01c28000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28000 0x400>;
+			interrupts = <0 1 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart1: serial@01c28400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28400 0x400>;
+			interrupts = <0 2 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart2: serial@01c28800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28800 0x400>;
+			interrupts = <0 3 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart3: serial@01c28c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28c00 0x400>;
+			interrupts = <0 4 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart4: serial@01c29000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29000 0x400>;
+			interrupts = <0 17 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart5: serial@01c29400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29400 0x400>;
+			interrupts = <0 18 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart6: serial@01c29800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29800 0x400>;
+			interrupts = <0 19 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart7: serial@01c29c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c29c00 0x400>;
+			interrupts = <0 20 1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		gic: interrupt-controller@01c81000 {
+			compatible = "arm,cortex-a7-gic";
+			reg = <0x01c81000 0x1000>,
+			      <0x01c82000 0x1000>,
+			      <0x01c84000 0x2000>,
+			      <0x01c86000 0x2000>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			interrupts = <1 9 0xf04>;
+		};
+	};
+};
-- 
1.8.3.4

