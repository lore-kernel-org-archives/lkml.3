Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3H1APB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:15:01 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53133 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3H1AOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:14:46 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 5/6] ARM: add Armada 1500 and Sony NSZ-GS7 device tree files
Date: Wed, 28 Aug 2013 02:14:33 +0200
Message-Id: <1377648874-6714-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds very basic device tree files for the Marvell Armada 1500 SoC
(88DE3100) and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has
nodes for cpus, some clocks, l2 cache controller, local timer, apb timers,
uart, and interrupt controllers. The Sony NSZ-GS7 is a GoogleTV consumer
device comprising the Armada 1500 SoC above.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- add binding documentation (Reported by Jason Cooper)
- change l2cc from aurora to tauros3 (Reported by Thomas Petazzoni)
- add copyright reference
- adapt compatibles to mach-berlin instead of mach-mvebu

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/arm/marvell,berlin.txt     |   23 ++
 arch/arm/boot/dts/Makefile                         |    2 +
 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts      |   29 +++
 arch/arm/boot/dts/mv88de3100.dtsi                  |  222 ++++++++++++++++++++
 4 files changed, 276 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,berlin.txt
 create mode 100644 arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
 create mode 100644 arch/arm/boot/dts/mv88de3100.dtsi

diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
new file mode 100644
index 0000000..a4c3056
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
@@ -0,0 +1,23 @@
+Marvell Berlin (88DE3xxx) family SoCs Device Tree Bindings
+---------------------------------------------------------------
+
+Boards with a SoC of the Marvell Berlin (88DE3xxx) family, e.g. Armada 1500
+shall have the following properties:
+
+* Required root node properties:
+compatible: must contain "marvell,berlin"
+
+In addition, the above compatible shall be extended with the specific
+SoC used, i.e.
+    "marvell,88de3100"	for Marvell 88DE3100 (Armada 1500),
+    "marvell,88de3010"	for Marvell 88DE3010 (Armada 1000),
+    "marvell,88de3005"	for Marvell 88DE3005 (Armada 1500-mini)
+
+* Example:
+
+/ {
+	model = "Sony NSZ-GS7";
+	compatible = "marvell,88de3100", "marvell,berlin";
+
+	...
+}
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d45058e..2989b51 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -43,6 +43,8 @@ dtb-$(CONFIG_ARCH_AT91)	+= sama5d35ek.dtb
 
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BCM) += bcm11351-brt.dtb
+dtb-$(CONFIG_ARCH_BERLIN) += \
+	mv88de3100-sony-nsz-gs7.dtb
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
diff --git a/arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts b/arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
new file mode 100644
index 0000000..1081bc1
--- /dev/null
+++ b/arch/arm/boot/dts/mv88de3100-sony-nsz-gs7.dts
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
+#include "mv88de3100.dtsi"
+
+/ {
+	model = "Sony NSZ-GS7";
+	compatible = "sony,nsz-gs7", "marvell,88de3100", "marvell,berlin";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk verbose debug";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>; /* 1 GB */
+	};
+};
+
+&uart0 { status = "okay"; };
diff --git a/arch/arm/boot/dts/mv88de3100.dtsi b/arch/arm/boot/dts/mv88de3100.dtsi
new file mode 100644
index 0000000..04328a6
--- /dev/null
+++ b/arch/arm/boot/dts/mv88de3100.dtsi
@@ -0,0 +1,222 @@
+/*
+ * Device Tree Include file for Marvell 88DE3100 (Armada 1500) SoC
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
+	model = "Marvell 88DE3100 (Armada 1500) SoC";
+	compatible = "marvell,88de3100", "marvell,berlin";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			compatible = "marvell,sheeva-v7";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "marvell,sheeva-v7";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <1>;
+		};
+	};
+
+	clocks {
+		/* 25MHz reference crystal */
+		ref25: oscillator {
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
+			compatible = "marvell,tauros3-cache";
+			reg = <0xac0000 0x1000>;
+			cache-unified;
+			cache-level = <2>;
+		};
+
+		gic: interrupt-controller@ad1000 {
+			compatible = "arm,cortex-a9-gic";
+			reg = <0xad1000 0x1000
+			       0xad0100 0x0100>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
+		};
+
+		local-timer@ad0600 {
+			compatible = "arm,cortex-a9-twd-timer";
+			reg = <0xad0600 0x20>;
+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
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
+				compatible = "snps,dw-apb-timer-osc";
+				reg = <0x2c00 0x14>;
+				interrupts = <8>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer1: timer@2c14 {
+				compatible = "snps,dw-apb-timer-osc";
+				reg = <0x2c14 0x14>;
+				interrupts = <9>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer2: timer@2c28 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c28 0x14>;
+				interrupts = <10>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer3: timer@2c3c {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c3c 0x14>;
+				interrupts = <11>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "okay";
+			};
+
+			timer4: timer@2c50 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c50 0x14>;
+				interrupts = <12>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer5: timer@2c64 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c64 0x14>;
+				interrupts = <13>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer6: timer@2c78 {
+				compatible = "snps,dw-apb-timer-sp";
+				reg = <0x2c78 0x14>;
+				interrupts = <14>;
+				clocks = <&cfgclk>;
+				clock-names = "timer";
+				status = "disabled";
+			};
+
+			timer7: timer@2c8c {
+				compatible = "snps,dw-apb-timer-sp";
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
+				clock-frequency = <25000000>;
+				status = "disabled";
+			};
+
+			uart1: serial@a000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xa000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <9>;
+				clock-frequency = <25000000>;
+				status = "disabled";
+			};
+
+			uart2: serial@b000 {
+				compatible = "snps,dw-apb-uart";
+				reg = <0xb000 0x100>;
+				reg-shift = <2>;
+				reg-io-width = <1>;
+				interrupts = <10>;
+				clock-frequency = <25000000>;
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
-- 
1.7.2.5

