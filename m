Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891Ab3LHOPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:15:16 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:36473 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab3LHOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:14:21 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/9] ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
Date: Sun,  8 Dec 2013 15:14:04 +0100
Message-Id: <1386512047-874-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds very basic device tree files for the Marvell Armada 1500 SoC
(Berlin BG2) and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has
nodes for cpus, some clocks, l2 cache controller, local timer, apb timers,
uart, and interrupt controllers. The Sony NSZ-GS7 is a GoogleTV consumer
device comprising the Armada 1500 SoC above.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jisheng Zhang <jszhang@marvell.com>
---
Changelog:
v3->v4:
- rename dts/dtsi to vendor,name.dts[i] (Suggested by Kumar Gala)
v2->v3:
- none
v1->v2:
- add "arm,pl310-cache" compatible to l2cc (Suggested by Mark Rutland)
- replace 88DE3xxx numbering with SoC variant name
  (Requested by Jisheng Zhang)
RCFv2->v1:
- switch to (soon to be) correct "marvell,pj4b" cpu compatible
- reference fixed-clock for uarts instead of hard-coded clock-frequency
- disable timers except two for clksrc and clkevt
RFCv1->RFCv2:
- add binding documentation (Reported by Jason Cooper)
- change l2cc from aurora to tauros3 (Reported by Thomas Petazzoni)
- add copyright reference
- adapt compatibles to mach-berlin instead of mach-mvebu

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/arm/marvell,berlin.txt     |  24 +++
 arch/arm/boot/dts/Makefile                         |   2 +
 arch/arm/boot/dts/marvell,berlin2.dtsi             | 227 +++++++++++++++++++++
 arch/arm/boot/dts/sony,nsz-gs7.dts                 |  29 +++
 4 files changed, 282 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
 create mode 100644 arch/arm/boot/dts/marvell,berlin2.dtsi
 create mode 100644 arch/arm/boot/dts/sony,nsz-gs7.dts

diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
new file mode 100644
index 0000000..737afa5
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -0,0 +1,24 @@
+Marvell Berlin SoC Family Device Tree Bindings
+---------------------------------------------------------------
+
+Boards with a SoC of the Marvell Berlin family, e.g. Armada 1500
+shall have the following properties:
+
+* Required root node properties:
+compatible: must contain "marvell,berlin"
+
+In addition, the above compatible shall be extended with the specific
+SoC and board used. Currently known SoC compatibles are:
+    "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
+    "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
+    "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
+    "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
+
+* Example:
+
+/ {
+	model = "Sony NSZ-GS7";
+	compatible = "sony,nsz-gs7", "marvell,berlin2", "marvell,berlin";
+
+	...
+}
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d57c1a6..f742800 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -45,6 +45,8 @@ dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
 	bcm28155-ap.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
+dtb-$(CONFIG_ARCH_BERLIN) += \
+	sony,nsz-gs7.dtb
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
diff --git a/arch/arm/boot/dts/marvell,berlin2.dtsi b/arch/arm/boot/dts/marvell,berlin2.dtsi
new file mode 100644
index 0000000..56a1af2
--- /dev/null
+++ b/arch/arm/boot/dts/marvell,berlin2.dtsi
@@ -0,0 +1,227 @@
+/*
+ * Device Tree Include file for Marvell Armada 1500 (Berlin BG2) SoC
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * based on GPL'ed 2.6 kernel sources
+ *  (c) Marvell International Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include "skeleton.dtsi"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
+/ {
+	model = "Marvell Armada 1500 (BG2) SoC";
+	compatible = "marvell,berlin2", "marvell,berlin";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "marvell,pj4b";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "marvell,pj4b";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <1>;
+		};
+	};
+
+	clocks {
+		smclk: sysmgr-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <25000000>;
+		};
+
+		cfgclk: cfg-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <100000000>;
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
+		interrupt-parent = <&gic>;
+
+		ranges = <0 0xf7000000 0x1000000>;
+
+		l2: l2-cache-controller@ac0000 {
+			compatible = "marvell,tauros3-cache", "arm,pl310-cache";
+			reg = <0xac0000 0x1000>;
+			cache-unified;
+			cache-level = <2>;
+		};
+
+		gic: interrupt-controller@ad1000 {
+			compatible = "arm,cortex-a9-gic";
+			reg = <0xad1000 0x1000>, <0xad0100 0x0100>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+		};
+
+		local-timer@ad0600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0xad0600 0x20>;
+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&sysclk>;
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
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer1: timer@2c14 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c14 0x14>;
+				interrupts = <9>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer2: timer@2c28 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c28 0x14>;
+				interrupts = <10>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer3: timer@2c3c {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c3c 0x14>;
+				interrupts = <11>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer4: timer@2c50 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c50 0x14>;
+				interrupts = <12>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer5: timer@2c64 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c64 0x14>;
+				interrupts = <13>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer6: timer@2c78 {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c78 0x14>;
+				interrupts = <14>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer7: timer@2c8c {
+				compatible = "snps,dw-apb-timer";
+				reg = <0x2c8c 0x14>;
+				interrupts = <15>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			aic: interrupt-controller@3000 {
+				compatible = "snps,dw-apb-ictl";
+				reg = <0x3000 0xc00>;
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
+			uart0: serial@9000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0x9000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <8>;
+				clocks = <&smclk>;
+				status = "disabled";
+			};
+
+			uart1: serial@a000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xa000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <9>;
+				clocks = <&smclk>;
+				status = "disabled";
+			};
+
+			uart2: serial@b000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xb000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <10>;
+				clocks = <&smclk>;
+				status = "disabled";
+			};
+
+			sic: interrupt-controller@e000 {
+				compatible = "snps,dw-apb-ictl";
+				reg = <0xe000 0x400>;
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				interrupt-parent = <&gic>;
+				interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sony,nsz-gs7.dts b/arch/arm/boot/dts/sony,nsz-gs7.dts
new file mode 100644
index 0000000..a6b1482
--- /dev/null
+++ b/arch/arm/boot/dts/sony,nsz-gs7.dts
@@ -0,0 +1,29 @@
+/*
+ * Device Tree file for Sony NSZ-GS7
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/dts-v1/;
+
+#include "marvell,berlin2.dtsi"
+
+/ {
+	model = "Sony NSZ-GS7";
+	compatible = "sony,nsz-gs7", "marvell,berlin2", "marvell,berlin";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>; /* 1 GB */
+	};
+};
+
+&uart0 { status = "okay"; };
-- 
1.8.4.rc3

