Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaCLLGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:06:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753993AbaCLLGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:06:08 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: berlin2q: add the Marvell Armada 1500 pro (BG2Q) device tree
Date: Wed, 12 Mar 2014 12:06:03 +0100
Message-Id: <1394622364-6848-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/arm/Marvell/README                   |   5 +
 .../devicetree/bindings/arm/marvell,berlin.txt     |   1 +
 arch/arm/boot/dts/berlin2q.dtsi                    | 167 +++++++++++++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 arch/arm/boot/dts/berlin2q.dtsi

diff --git a/Documentation/arm/Marvell/README b/Documentation/arm/Marvell/README
index 5a930c1528ad..69ad05ea8ed8 100644
--- a/Documentation/arm/Marvell/README
+++ b/Documentation/arm/Marvell/README
@@ -224,6 +224,11 @@ Berlin family (Digital Entertainment)
 		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
 		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500/
 		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500/assets/Marvell-ARMADA-1500-Product-Brief.pdf
+	88DE3114, Armada 1500 Pro
+		Desgin name:	BG2-Q
+		Core:		Quad Core ARM CA9, PL310 L2CC
+		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500-pro/
+		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500-pro/assets/Marvell_ARMADA_1500_PRO-01_product_brief.pdf
 	88DE????
 		Design name:	BG3
 		Core:		ARM Cortex-A15, CA15 integrated L2CC
diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
index 737afa5f8148..25472b74218f 100644
--- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -11,6 +11,7 @@ In addition, the above compatible shall be extended with the specific
 SoC and board used. Currently known SoC compatibles are:
     "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
     "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
+    "marvell,berlin2q"     for Marvell Armada 1500-pro (BG2Q)
     "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
     "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
 
diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
new file mode 100644
index 000000000000..f58c9c64c60e
--- /dev/null
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -0,0 +1,167 @@
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
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		smclk: sysmgr-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <25000000>;
+		};
+
+		sysclk: system-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <400000000>;
+		};
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
+		gic: interrupt-controller@ad1000 {
+			compatible = "arm,cortex-a9-gic";
+			reg = <0xad1000 0x1000>, <0xad0100 0x100>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+		};
+
+		local-timer@ad0600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0xad0600 0x20>;
+			clocks = <&sysclk>;
+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			status = "okay";
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
+				status = "okay";
+			};
+
+			timer1: timer@2c14 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c14 0x14>;
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

