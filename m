Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaJHNEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:04:38 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:55418 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaJHNDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:03:07 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v3 2/5] ARM: dts: sunxi: Add Allwinner A80 dtsi
Date: Wed,  8 Oct 2014 21:02:53 +0800
Message-Id: <1412773376-25212-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412773376-25212-1-git-send-email-wens@csie.org>
References: <1412773376-25212-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A80 is a new multi-purpose SoC with 4 Cortex-A7 and
4 Cortex-A15 cores in a big.LITTLE architecture, and a 64-core
PowerVR G6230 GPU.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 257 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 257 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun9i-a80.dtsi

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
new file mode 100644
index 0000000..5e2ec4b
--- /dev/null
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -0,0 +1,257 @@
+/*
+ * Copyright 2014 Chen-Yu Tsai
+ *
+ * Chen-Yu Tsai <wens@csie.org>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this library; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+/include/ "skeleton64.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+		serial3 = &uart3;
+		serial4 = &uart4;
+		serial5 = &uart5;
+		serial6 = &r_uart;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu0: cpu@0 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0x0>;
+		};
+
+		cpu1: cpu@1 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0x1>;
+		};
+
+		cpu2: cpu@2 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0x2>;
+		};
+
+		cpu3: cpu@3 {
+			compatible = "arm,cortex-a7";
+			device_type = "cpu";
+			reg = <0x3>;
+		};
+
+		cpu4: cpu@100 {
+			compatible = "arm,cortex-a15";
+			device_type = "cpu";
+			reg = <0x100>;
+		};
+
+		cpu5: cpu@101 {
+			compatible = "arm,cortex-a15";
+			device_type = "cpu";
+			reg = <0x101>;
+		};
+
+		cpu6: cpu@102 {
+			compatible = "arm,cortex-a15";
+			device_type = "cpu";
+			reg = <0x102>;
+		};
+
+		cpu7: cpu@103 {
+			compatible = "arm,cortex-a15";
+			device_type = "cpu";
+			reg = <0x103>;
+		};
+	};
+
+	memory {
+		/* 8GB max. with LPAE */
+		reg = <0 0x20000000 0x02 0>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		/*
+		 * map 64 bit address range down to 32 bits,
+		 * as the peripherals are all under 512MB.
+		 */
+		ranges = <0 0 0 0x20000000>;
+
+		osc24M: osc24M_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+			clock-output-names = "osc24M";
+		};
+
+		osc32k: osc32k_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+			clock-output-names = "osc32k";
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		/*
+		 * map 64 bit address range down to 32 bits,
+		 * as the peripherals are all under 512MB.
+		 */
+		ranges = <0 0 0 0x20000000>;
+
+		gic: interrupt-controller@01c41000 {
+			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
+			reg = <0x01c41000 0x1000>,
+			      <0x01c42000 0x1000>,
+			      <0x01c44000 0x2000>,
+			      <0x01c46000 0x2000>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+			interrupts = <1 9 0xf04>;
+		};
+
+		timer@06000c00 {
+			compatible = "allwinner,sun4i-a10-timer";
+			reg = <0x06000c00 0xa0>;
+			interrupts = <0 18 4>,
+				     <0 19 4>,
+				     <0 20 4>,
+				     <0 21 4>,
+				     <0 22 4>,
+				     <0 23 4>;
+
+			clocks = <&osc24M>;
+		};
+
+		uart0: serial@07000000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x07000000 0x400>;
+			interrupts = <0 0 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart1: serial@07000400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x07000400 0x400>;
+			interrupts = <0 1 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart2: serial@07000800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x07000800 0x400>;
+			interrupts = <0 2 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart3: serial@07000c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x07000c00 0x400>;
+			interrupts = <0 3 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart4: serial@07001000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x07001000 0x400>;
+			interrupts = <0 4 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart5: serial@07001400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x07001400 0x400>;
+			interrupts = <0 5 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		r_wdt: watchdog@08001000 {
+			compatible = "allwinner,sun6i-a31-wdt";
+			reg = <0x08001000 0x20>;
+			interrupts = <0 36 4>;
+		};
+
+		r_uart: serial@08002800 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x08002800 0x400>;
+			interrupts = <0 38 4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+	};
+};
-- 
2.1.1

