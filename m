Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3GDOp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:45:29 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36350 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3GDOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:45:27 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org, arnd@arndb.de,
        olof@lixom.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v3 2/4] ARM: mach-moxart: add MOXA ART device tree files
Date: Thu,  4 Jul 2013 16:45:15 +0200
Message-Id: <1372949115-8190-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371040448-28742-3-git-send-email-jonas.jensen@gmail.com>
References: <1371040448-28742-3-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic SoC include and UC-7112-LX platform device tree files
and documentation.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703
    
    Changes since v2:
    
    1. add and update documentation, new drivers: mmc, mac, rtc,
       watchdog, gpio, core-clock, apb-clock

 .../bindings/arm/moxart/moxa,moxart-apb-clock.txt  | 18 +++++
 .../devicetree/bindings/arm/moxart/moxart.txt      | 12 ++++
 .../bindings/clock/moxa,moxart-core-clock          | 19 +++++
 .../devicetree/bindings/gpio/moxa,moxart-gpio.txt  | 16 +++++
 .../interrupt-controller/moxa,moxart-ic.txt        | 28 ++++++++
 .../devicetree/bindings/mmc/moxa,moxart-mmc.txt    | 17 +++++
 .../devicetree/bindings/net/moxa,moxart-mac.txt    | 25 +++++++
 .../devicetree/bindings/rtc/moxa,moxart-rtc.txt    | 11 +++
 .../bindings/timer/moxa,moxart-timer.txt           | 17 +++++
 .../bindings/watchdog/moxa,moxart-watchdog.txt     | 15 ++++
 arch/arm/boot/dts/Makefile                         |  1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts              | 82 ++++++++++++++++++++++
 arch/arm/boot/dts/moxart.dtsi                      | 79 +++++++++++++++++++++
 13 files changed, 340 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/moxart/moxa,moxart-apb-clock.txt
 create mode 100644 Documentation/devicetree/bindings/arm/moxart/moxart.txt
 create mode 100644 Documentation/devicetree/bindings/clock/moxa,moxart-core-clock
 create mode 100644 Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
 create mode 100644 Documentation/devicetree/bindings/net/moxa,moxart-mac.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/moxa,moxart-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi

diff --git a/Documentation/devicetree/bindings/arm/moxart/moxa,moxart-apb-clock.txt b/Documentation/devicetree/bindings/arm/moxart/moxa,moxart-apb-clock.txt
new file mode 100644
index 0000000..f6e88fc
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/moxart/moxa,moxart-apb-clock.txt
@@ -0,0 +1,18 @@
+MOXA ART APB clock
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-apb-clock"
+- #clock-cells : Should be 0
+
+Example:
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		clkapb: clkapb {
+			compatible = "moxa,moxart-apb-clock";
+			#clock-cells = <0>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/moxart/moxart.txt b/Documentation/devicetree/bindings/arm/moxart/moxart.txt
new file mode 100644
index 0000000..11087ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/moxart/moxart.txt
@@ -0,0 +1,12 @@
+MOXA ART device tree bindings
+
+Boards with the MOXA ART SoC shall have the following properties:
+
+Required root node property:
+
+compatible = "moxa,moxart";
+
+Boards:
+
+- UC-7112-LX: embedded computer
+  compatible = "moxa,moxart-uc-7112-lx", "moxa,moxart"
diff --git a/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock
new file mode 100644
index 0000000..cf69361
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock
@@ -0,0 +1,19 @@
+Device Tree Clock bindings for arch-moxart
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+MOXA ART SoCs allow to determine core clock frequencies by reading
+a register.
+
+Required properties:
+- compatible : Should be "moxa,moxart-core-clock"
+- reg : Should contain registers location and length
+
+For example:
+
+	clk: core-clock@98100000 {
+		compatible = "moxa,moxart-core-clock";
+		reg = <0x98100000 0x34>;
+	};
diff --git a/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
new file mode 100644
index 0000000..1be5875
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
@@ -0,0 +1,16 @@
+MOXA ART GPIO Controller
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-gpio"
+- reg : Should contain registers location and length
+	index 0 : input, output, and direction control
+	index 1 : enable/disable individual pins, pin 0-31
+
+Example:
+
+	gpio: gpio@98700000 {
+		compatible = "moxa,moxart-gpio";
+		reg =	<0x98700000 0xC>,
+			<0x98100100 0x4>;
+	};
diff --git a/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
new file mode 100644
index 0000000..58f1fe1
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
@@ -0,0 +1,28 @@
+* MOXA ART Interrupt Controller
+
+MOXA ART Interrupt Controller (moxart-ic) is used on MOXA ART SoCs
+and supports 32 non-configurable number of interrupts
+
+Main node required properties:
+
+- compatible : "moxa,moxart-ic"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The type shall be a <u32> and the value shall be 2.
+
+  The first cell contains the interrupt number in the range [0-31].
+  The second cell contains the interrupt type
+
+- reg: physical base address and size of the intc registers map.
+- interrupt-mask: Specifies if the interrupt is edge or level-triggered
+  each bit represent an interrupt 0-31 where 1 signify edge
+
+Example:
+
+	intc: interrupt-controller@98800000 {
+		compatible = "moxa,moxart-ic";
+		reg = <0x98800000 0x38>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupt-mask = <0x00080000>;
+	};
diff --git a/Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt b/Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
new file mode 100644
index 0000000..7cd7bd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/moxa,moxart-mmc.txt
@@ -0,0 +1,17 @@
+MOXA ART SD Host Controller Interface
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-mmc"
+- reg : Should contain registers location and length
+- interrupts : Should contain the interrupt number
+- clocks : Should contain phandle for the internal bus clock "tclk"
+
+Example:
+
+	mmc: mmc@98e00000 {
+		compatible = "moxa,moxart-mmc";
+		reg = <0x98e00000 0x0000005C>;
+		interrupts = <5 0>;
+		clocks = <&tclk>;
+	};
diff --git a/Documentation/devicetree/bindings/net/moxa,moxart-mac.txt b/Documentation/devicetree/bindings/net/moxa,moxart-mac.txt
new file mode 100644
index 0000000..8be75cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/moxa,moxart-mac.txt
@@ -0,0 +1,25 @@
+MOXA ART Ethernet Controller
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-mac"
+- reg : Should contain registers location and length
+  index 0 : main register
+  index 1 : mac address (stored on flash)
+- interrupts : Should contain the mac interrupt number
+
+Example:
+
+	mac0: mac@90900000 {
+		compatible = "moxa,moxart-mac";
+		reg =	<0x90900000 0x1000>,
+			<0x80000050 0x6>;
+		interrupts = <25 0>;
+	};
+
+	mac1: mac@92000000 {
+		compatible = "moxa,moxart-mac";
+		reg =	<0x92000000 0x1000>,
+			<0x80000056 0x6>;
+		interrupts = <27 0>;
+	};
diff --git a/Documentation/devicetree/bindings/rtc/moxa,moxart-rtc.txt b/Documentation/devicetree/bindings/rtc/moxa,moxart-rtc.txt
new file mode 100644
index 0000000..65f632c
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/moxa,moxart-rtc.txt
@@ -0,0 +1,11 @@
+MOXA ART real-time clock
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-rtc"
+
+Example:
+
+	rtc: rtc {
+		compatible = "moxa,moxart-rtc";
+	};
diff --git a/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt b/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
new file mode 100644
index 0000000..9015b88
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
@@ -0,0 +1,17 @@
+MOXA ART timer
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-timer"
+- reg : Should contain registers location and length
+- interrupts : Should contain the timer interrupt number
+- clocks : Should contain phandle for the internal bus clock "tclk"
+
+Example:
+
+	timer: timer@98400000 {
+		compatible = "moxa,moxart-timer";
+		reg = <0x98400000 0x10>;
+		interrupts = <19 1>;
+		clocks = <&tclk>;
+	};
diff --git a/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
new file mode 100644
index 0000000..00a23b9
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/moxa,moxart-watchdog.txt
@@ -0,0 +1,15 @@
+MOXA ART Watchdog timer
+
+Required properties:
+
+- compatible : Should be "moxa,moxart-watchdog"
+- reg : Should contain registers location and length
+- clocks : Should contain phandle for the internal bus clock "tclk"
+
+Example:
+
+	watchdog: watchdog@98500000 {
+		compatible = "moxa,moxart-watchdog";
+		reg = <0x98500000 0x10>;
+		clocks = <&tclk>;
+	};
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 2cec2ff..66d4d73 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -96,6 +96,7 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-ts219-6282.dtb \
 	kirkwood-openblocks_a6.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
+dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
 dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
 	msm8960-cdp.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
new file mode 100644
index 0000000..db65575
--- /dev/null
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -0,0 +1,82 @@
+/* moxart-uc7112lx.dts - Device Tree file for MOXA UC-7112-LX
+ *
+ * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/dts-v1/;
+/include/ "moxart.dtsi"
+
+/ {
+	model = "MOXA UC-7112-LX";
+	compatible = "moxa,moxart-uc-7112-lx", "moxa,moxart";
+
+	memory {
+		/* SAMSUNG K4S561632J-UC75 */
+		device_type = "memory";
+		reg = <0x0 0x2000000>;
+	};
+
+	flash@80000000,0 {
+		/* JS28F128 J3D75 A9087684
+		 * Numonyx Embedded Flash Memory (J3 v. D)
+		 */
+		compatible = "numonyx,js28f128", "cfi-flash";
+		reg = <0x80000000 0x1000000>;
+		bank-width = <2>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		partition@0 {
+			label = "bootloader";
+			reg = <0x0 0x40000>;
+		};
+		partition@40000 {
+			label = "linux kernel";
+			reg = <0x40000 0x1C0000>;
+		};
+		partition@200000 {
+			label = "root filesystem";
+			reg = <0x200000 0x800000>;
+		};
+		partition@a00000 {
+			label = "user filesystem";
+			reg = <0xa00000 0x600000>;
+		};
+	};
+
+	mmc: mmc@98e00000 {
+		compatible = "moxa,moxart-mmc";
+		reg = <0x98e00000 0x5C>;
+		interrupts = <5 0>;
+		clocks = <&clkapb>;
+	};
+
+	mac0: mac@90900000 {
+		compatible = "moxa,moxart-mac";
+		reg =   <0x90900000 0x100>,
+			<0x80000050 0x6>;
+		interrupts = <25 0>;
+	};
+
+	mac1: mac@92000000 {
+		compatible = "moxa,moxart-mac";
+		reg =	<0x92000000 0x100>,
+			<0x80000056 0x6>;
+		interrupts = <27 0>;
+	};
+
+	uart0: uart@98200000 {
+		compatible = "ns16550a";
+		reg = <0x98200000 0x20>;
+		interrupts = <31 8>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+		clock-frequency = <14745600>;
+		status = "okay";
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 root=/dev/mtdblock2 rootfstype=jffs2 rw";
+	};
+};
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
new file mode 100644
index 0000000..40f20f3
--- /dev/null
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -0,0 +1,79 @@
+/* moxart.dtsi - Device Tree Include file for MOXA ART family SoC
+ *
+ * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "moxa,moxart";
+	model = "MOXART";
+	interrupt-parent = <&intc>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "faraday,fa526";
+			reg = <0>;
+		};
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		clkapb: clkapb {
+			compatible = "moxa,moxart-apb-clock";
+			#clock-cells = <0>;
+		};
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x90000000 0x10000000>;
+		ranges;
+
+		intc: interrupt-controller@98800000 {
+			compatible = "moxa,moxart-ic";
+			reg = <0x98800000 0x38>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupt-mask = <0x00080000>;
+		};
+
+		clk: core-clock@98100000 {
+			compatible = "moxa,moxart-core-clock";
+			reg = <0x98100000 0x34>;
+		};
+
+		timer: timer@98400000 {
+			compatible = "moxa,moxart-timer";
+			reg = <0x98400000 0x42>;
+			interrupts = <19 1>;
+			clocks = <&clkapb>;
+		};
+
+		gpio: gpio@98700000 {
+			compatible = "moxa,moxart-gpio";
+			reg =	<0x98700000 0xC>,
+				<0x98100100 0x4>;
+		};
+
+		rtc: rtc {
+			compatible = "moxa,moxart-rtc";
+		};
+
+		watchdog: watchdog@98500000 {
+			compatible = "moxa,moxart-watchdog";
+			reg = <0x98500000 0x10>;
+			clocks = <&clkapb>;
+		};
+	};
+};
-- 
1.8.2.1

