Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3FQLJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:09:07 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:48508 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3FQLIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:08:51 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2 2/3] ARM: mach-moxart: add MOXA ART device tree files
Date: Mon, 17 Jun 2013 13:08:02 +0200
Message-Id: <1371467283-6981-2-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371467283-6981-1-git-send-email-jonas.jensen@gmail.com>
References: <1371467283-6981-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic SoC include and UC-7112-LX platform device tree files.
Add device tree bindings documentation.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 Documentation/devicetree/bindings/arm/moxart.txt   |    8 +++
 .../arm/moxart/moxart-interrupt-controller.txt     |   29 +++++++++
 .../bindings/arm/moxart/moxart-timer.txt           |   17 ++++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/moxart-uc7112lx.dts              |   61 ++++++++++++++++++++
 arch/arm/boot/dts/moxart.dtsi                      |   60 +++++++++++++++++++
 6 files changed, 176 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/moxart.txt
 create mode 100644 Documentation/devicetree/bindings/arm/moxart/moxart-interrupt-controller.txt
 create mode 100644 Documentation/devicetree/bindings/arm/moxart/moxart-timer.txt
 create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
 create mode 100644 arch/arm/boot/dts/moxart.dtsi

diff --git a/Documentation/devicetree/bindings/arm/moxart.txt b/Documentation/devicetree/bindings/arm/moxart.txt
new file mode 100644
index 0000000..a13b567
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/moxart.txt
@@ -0,0 +1,8 @@
+MOXA ART device tree bindings
+-------------------------------------------
+
+Boards with the MOXA ART SoC shall have the following properties:
+
+Required root node property:
+
+compatible = "moxa,moxart";
diff --git a/Documentation/devicetree/bindings/arm/moxart/moxart-interrupt-controller.txt b/Documentation/devicetree/bindings/arm/moxart/moxart-interrupt-controller.txt
new file mode 100644
index 0000000..5e3b62d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/moxart/moxart-interrupt-controller.txt
@@ -0,0 +1,29 @@
+* MOXA ART Interrupt Controller
+
+MOXA ART Interrupt Controller (moxart-interrupt-controller) is used on
+MOXA ART SoCs and supports 32 non-configurable number of interrupts
+
+Main node required properties:
+
+- compatible : should be:
+	"moxa,moxart-interrupt-controller"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The type shall be a <u32> and the value shall be 2.
+
+  The first cell contains the interrupt number in the range [0-31].
+  The second cell contains the interrupt type
+- reg: physical base address and size of the intc registers map.
+- interrupt-mask: Specifies if the interrupt is edge or level-triggered
+  each bit represent an interrupt 0-31 where 1 signify edge
+
+Example:
+
+	intc: interrupt-controller@98800000 {
+		compatible = "moxa,moxart-interrupt-controller";
+		reg = <0x98800000 0x38>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupt-mask = <0x00080000>;
+	};
+
diff --git a/Documentation/devicetree/bindings/arm/moxart/moxart-timer.txt b/Documentation/devicetree/bindings/arm/moxart/moxart-timer.txt
new file mode 100644
index 0000000..dd4e06d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/moxart/moxart-timer.txt
@@ -0,0 +1,17 @@
+MOXA ART timer
+-----------------------------------------------------
+This timer is used on MOXA ART SoCs:
+
+Required properties:
+- compatible : "moxa,moxart-timer"
+- reg : Register range for the timer
+- interrupts : interrupt for the timer
+
+Example:
+
+	timer: timer@98400000 {
+		compatible = "moxa,moxart-timer";
+		reg = <0x98400000 0x10>;
+		interrupts = <19 1>;
+	};
+
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index c130447..8bcbc7b 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -219,6 +219,7 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8750-apc8750.dtb \
 	wm8850-w70v2.dtb
 dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
+dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
 
 targets += dtbs
 targets += $(dtb-y)
diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
new file mode 100644
index 0000000..c0be8a9
--- /dev/null
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -0,0 +1,61 @@
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
+		reg = <0x00000000 0x02000000>;
+	};
+
+	flash@80000000,0 {
+		/* JS28F128 J3D75 A9087684
+		 * Numonyx Embedded Flash Memory (J3 v. D)
+		 */
+		compatible = "numonyx,js28f128", "cfi-flash";
+		reg = <0x80000000 0x01000000>;
+		bank-width = <2>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		partition@0 {
+			label = "bootloader";
+			reg = <0x00000000 0x00040000>;
+		};
+		partition@40000 {
+			label = "linux kernel";
+			reg = <0x00040000 0x001C0000>;
+		};
+		partition@200000 {
+			label = "root filesystem";
+			reg = <0x00200000 0x00800000>;
+		};
+		partition@a00000 {
+			label = "user filesystem";
+			reg = <0x00a00000 0x00600000>;
+		};
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
index 0000000..4c0214f
--- /dev/null
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -0,0 +1,60 @@
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
+		osc: oscillator {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
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
+			compatible = "moxa,moxart-interrupt-controller";
+			reg = <0x98800000 0x38>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+
+			/* single register vector, interrupts 0-31, 1s signify edge */
+			interrupt-mask = <0x00080000>;
+		};
+
+		timer: timer@98400000 {
+			compatible = "moxa,moxart-timer";
+			reg = <0x98400000 0x10>;
+			interrupts = <19 1>;
+		};
+	};
+};
-- 
1.7.2.5

