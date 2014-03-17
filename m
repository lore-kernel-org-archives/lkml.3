Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaCQPHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:07:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933411AbaCQPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:06:33 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500 pro
Date: Mon, 17 Mar 2014 16:06:26 +0100
Message-Id: <1395068788-19786-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds initial support for the Marvell Armada 1500 pro (BG2Q) SoC (Berlin family).
The SoC has nodes for cpu, l2 cache controller, interrupt controllers, local
timer, apb timers and uarts for now.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 210 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 210 insertions(+)
 create mode 100644 arch/arm/boot/dts/berlin2q.dtsi

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
new file mode 100644
index 000000000000..7a50267b1044
--- /dev/null
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -0,0 +1,210 @@
+/*
+ * Copyright (C) 2014 Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+#include "skeleton.dtsi"
+
+/ {
+	model = "Marvell Armada 1500 pro (BG2-Q) SoC";
+	compatible = "marvell,berlin2q", "marvell,berlin";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <1>;
+		};
+
+		cpu@2 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <2>;
+		};
+
+		cpu@3 {
+			compatible = "arm,cortex-a9";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <3>;
+		};
+	};
+
+	smclk: sysmgr-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
+
+	cpuclk: cpu-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <1200000000>;
+	};
+
+	sysclk: system-clock {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&cpuclk>;
+		clock-multi = <1>;
+		clock-div = <3>;
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		ranges = <0 0xf7000000 0x1000000>;
+		interrupt-parent = <&gic>;
+
+		l2: l2-cache-controller@ac0000 {
+			compatible = "arm,pl310-cache";
+			reg = <0xac0000 0x1000>;
+			cache-level = <2>;
+		};
+
+		local-timer@ad0600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0xad0600 0x20>;
+			clocks = <&sysclk>;
+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		gic: interrupt-controller@ad1000 {
+			compatible = "arm,cortex-a9-gic";
+			reg = <0xad1000 0x1000>, <0xad0100 0x100>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+		};
+
+		apb@e80000 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			ranges = <0 0xe80000 0x10000>;
+			interrupt-parent = <&aic>;
+
+			timer0: timer@2c00 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c00 0x14>;
+				interrupts = <8>;
+				clock-freq = <100000000>;
+			};
+
+			timer1: timer@2c14 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c14 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			timer2: timer@2c28 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c28 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			timer3: timer@2c3c {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c3c 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			timer4: timer@2c50 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c50 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			timer5: timer@2c64 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c64 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			timer6: timer@2c78 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c78 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			timer7: timer@2c8c {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c8c 0x14>;
+				clock-freq = <100000000>;
+				status = "disabled";
+			};
+
+			aic: interrupt-controller@3800 {
+				compatible = "snps,dw-apb-ictl";
+				reg = <0x3800 0x30>;
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
+
+		apb@fc0000 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			ranges = <0 0xfc0000 0x10000>;
+			interrupt-parent = <&sic>;
+
+			uart0: uart@9000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x9000 0x100>;
+				interrupt-parent = <&sic>;
+				interrupts = <8>;
+				clock-frequency = <25000000>;
+				reg-shift = <2>;
+				status = "disabled";
+			};
+
+			uart1: uart@a000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xa000 0x100>;
+				interrupt-parent = <&sic>;
+				interrupts = <9>;
+				clock-frequency = <25000000>;
+				reg-shift = <2>;
+				status = "disabled";
+			};
+
+			sic: interrupt-controller@e000 {
+				compatible = "snps,dw-apb-ictl";
+				reg = <0xe000 0x30>;
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
+	};
+};
-- 
1.8.3.2

