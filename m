Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3E3NYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:24:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56565 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3E3NYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:24:33 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Device trees for TI-Nspire hardware
Date: Thu, 30 May 2013 23:24:19 +1000
Message-Id: <827B6FFA-81CC-4866-8F8B-2762AB8B7A2F@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device trees for describing the TI-Nspire hardware.


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/boot/dts/Makefile                         |   3 +
 arch/arm/boot/dts/nspire-classic.dtsi              |  74 +++++++++
 arch/arm/boot/dts/nspire-clp.dts                   |  45 ++++++
 arch/arm/boot/dts/nspire-cx.dts                    | 112 +++++++++++++
 arch/arm/boot/dts/nspire-tp.dts                    |  44 ++++++
 arch/arm/boot/dts/nspire.dtsi                      | 175 +++++++++++++++++++++
 7 files changed, 454 insertions(+)
 create mode 100644 arch/arm/boot/dts/nspire-classic.dtsi
 create mode 100644 arch/arm/boot/dts/nspire-clp.dts
 create mode 100644 arch/arm/boot/dts/nspire-cx.dts
 create mode 100644 arch/arm/boot/dts/nspire-tp.dts
 create mode 100644 arch/arm/boot/dts/nspire.dtsi

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 6931c43..b27b057 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -31,6 +31,7 @@ idt	Integrated Device Technologies, Inc.
 img	Imagination Technologies Ltd.
 intercontrol	Inter Control Group
 linux	Linux-specific binding
+lsi	LSI Corp. (LSI Logic)
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
 mosaixtech	Mosaix Technologies, Inc.
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f0895c5..6191b1d 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -135,6 +135,9 @@ dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
 	imx28-sps1.dtb \
 	imx28-tx28.dtb
 dtb-$(CONFIG_ARCH_NOMADIK) += ste-nomadik-s8815.dtb
+dtb-$(CONFIG_ARCH_NSPIRE) += nspire-cx.dtb \
+	nspire-tp.dtb \
+	nspire-clp.dtb
 dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3430-sdp.dtb \
 	omap3-beagle.dtb \
diff --git a/arch/arm/boot/dts/nspire-classic.dtsi b/arch/arm/boot/dts/nspire-classic.dtsi
new file mode 100644
index 0000000..9565199
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-classic.dtsi
@@ -0,0 +1,74 @@
+/*
+ *  linux/arch/arm/boot/nspire-classic.dts
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/include/ "nspire.dtsi"
+
+&lcd {
+	lcd-type = "classic";
+};
+
+&fast_timer {
+	/* compatible = "lsi,zevio-timer"; */
+	reg = <0x90010000 0x1000>, <0x900A0010 0x8>;
+};
+
+&uart {
+	compatible = "ns16550";
+	reg-shift = <2>;
+	reg-io-width = <4>;
+	clocks = <&apb_pclk>;
+	no-loopback-test;
+};
+
+&timer0 {
+	/* compatible = "lsi,zevio-timer"; */
+	reg = <0x900C0000 0x1000>, <0x900A0018 0x8>;
+};
+
+&timer1 {
+	compatible = "lsi,zevio-timer";
+	reg = <0x900D0000 0x1000>, <0x900A0020 0x8>;
+};
+
+&keypad {
+	active-low;
+
+};
+
+&base_clk {
+	compatible = "lsi,nspire-classic-clock";
+};
+
+&ahb_clk {
+	compatible = "lsi,nspire-classic-ahb-divider";
+};
+
+/ {
+	memory {
+		device_type = "memory";
+		reg = <0x10000000 0x2000000>; /* 32 MB */
+	};
+
+	ahb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		intc: interrupt-controller@DC000000 {
+			compatible = "lsi,zevio-intc";
+			interrupt-controller;
+			reg = <0xDC000000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+	};
+	chosen {
+		bootargs = "debug earlyprintk console=tty0 console=ttyS0,115200n8 root=/dev/ram0";
+	};
+};
diff --git a/arch/arm/boot/dts/nspire-clp.dts b/arch/arm/boot/dts/nspire-clp.dts
new file mode 100644
index 0000000..3f9c8af
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-clp.dts
@@ -0,0 +1,45 @@
+/*
+ *  linux/arch/arm/boot/nspire-clp.dts
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+/dts-v1/;
+
+/include/ "nspire-classic.dtsi"
+
+&keypad {
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00020039
+	0x0004002c 	0x00050034 	0x00060015
+	0x0007000b 	0x0008002d 	0x01000033
+	0x0101004e 	0x01020011 	0x01030004
+	0x0104002f 	0x01050003 	0x01060016
+	0x01070002 	0x01080014 	0x02000062
+	0x0201000c 	0x0202001f 	0x02030007
+	0x02040013 	0x02050006 	0x02060010
+	0x02070005 	0x02080019 	0x03000027
+	0x03010037 	0x03020018 	0x0303000a
+	0x03040031 	0x03050009 	0x03060032
+	0x03070008 	0x03080026 	0x04000028
+	0x04010035 	0x04020025 	0x04040024
+	0x04060017 	0x04080023 	0x05000028
+	0x05020022 	0x0503001b 	0x05040021
+	0x0505001a 	0x05060012 	0x0507006f
+	0x05080020 	0x0509002a 	0x0601001c
+	0x0602002e 	0x06030068 	0x06040030
+	0x0605006d 	0x0606001e 	0x06070001
+	0x0608002b 	0x0609000f 	0x07000067
+	0x0702006a 	0x0704006c 	0x07060069
+	0x0707000e 	0x0708001d 	0x070a000d
+	>;
+};
+
+/ {
+	model = "TI-NSPIRE Clickpad";
+	compatible = "ti,nspire-clp";
+};
diff --git a/arch/arm/boot/dts/nspire-cx.dts b/arch/arm/boot/dts/nspire-cx.dts
new file mode 100644
index 0000000..64632ca
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-cx.dts
@@ -0,0 +1,112 @@
+/*
+ *  linux/arch/arm/boot/nspire-cx.dts
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+/dts-v1/;
+
+/include/ "nspire.dtsi"
+
+&lcd {
+	lcd-type = "cx";
+};
+
+&fast_timer {
+	/* compatible = "arm,sp804", "arm,primecell"; */
+};
+
+&uart {
+	compatible = "arm,pl011", "arm,primecell";
+
+	clocks = <&uart_clk>, <&apb_pclk>;
+	clock-names = "uart_clk", "apb_pclk";
+};
+
+&timer0 {
+	compatible = "arm,sp804", "arm,primecell";
+};
+
+&timer1 {
+	compatible = "arm,sp804", "arm,primecell";
+};
+
+&base_clk {
+	compatible = "lsi,nspire-cx-clock";
+};
+
+&ahb_clk {
+	compatible = "lsi,nspire-cx-ahb-divider";
+};
+
+&keypad {
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00040039
+	0x0005002c 	0x00060015 	0x0007000b
+	0x0008000f 	0x0100002d 	0x01010011
+	0x0102002f 	0x01030004 	0x01040016
+	0x01050014 	0x0106001f 	0x01070002
+	0x010a006a 	0x02000013 	0x02010010
+	0x02020019 	0x02030007 	0x02040018
+	0x02050031 	0x02060032 	0x02070005
+	0x02080028 	0x0209006c 	0x03000026
+	0x03010025 	0x03020024 	0x0303000a
+	0x03040017 	0x03050023 	0x03060022
+	0x03070008 	0x03080035 	0x03090069
+	0x04000021 	0x04010012 	0x04020020
+	0x0404002e 	0x04050030 	0x0406001e
+	0x0407000d 	0x04080037 	0x04090067
+	0x05010038 	0x0502000c 	0x0503001b
+	0x05040034 	0x0505001a 	0x05060006
+	0x05080027 	0x0509000e 	0x050a006f
+	0x0600002b 	0x0602004e 	0x06030068
+	0x06040003 	0x0605006d 	0x06060009
+	0x06070001 	0x0609000f 	0x0708002a
+	0x0709001d 	0x070a0033 	>;
+};
+
+/ {
+	model = "TI-NSPIRE CX";
+	compatible = "ti,nspire-cx";
+
+	memory {
+		device_type = "memory";
+		reg = <0x10000000 0x4000000>; /* 64 MB */
+	};
+
+	uart_clk: uart_clk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <12000000>;
+	};
+
+	ahb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		intc: interrupt-controller@DC000000 {
+			compatible = "arm,pl190-vic";
+			interrupt-controller;
+			reg = <0xDC000000 0x1000>;
+			#interrupt-cells = <1>;
+		};
+
+		apb@90000000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			i2c@90050000 {
+				compatible = "snps,designware-i2c";
+				reg = <0x90050000 0x1000>;
+				interrupts = <20>;
+			};
+		};
+	};
+	chosen {
+		bootargs = "debug earlyprintk console=tty0 console=ttyAMA0,115200n8 root=/dev/ram0";
+	};
+};
diff --git a/arch/arm/boot/dts/nspire-tp.dts b/arch/arm/boot/dts/nspire-tp.dts
new file mode 100644
index 0000000..ab209a3
--- /dev/null
+++ b/arch/arm/boot/dts/nspire-tp.dts
@@ -0,0 +1,44 @@
+/*
+ *  linux/arch/arm/boot/nspire-tp.dts
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+/dts-v1/;
+
+/include/ "nspire-classic.dtsi"
+
+&keypad {
+	keymap = <
+	0x0000001c 	0x0001001c 	0x00040039
+	0x0005002c 	0x00060015 	0x0007000b
+	0x0008000f 	0x0100002d 	0x01010011
+	0x0102002f 	0x01030004 	0x01040016
+	0x01050014 	0x0106001f 	0x01070002
+	0x010a006a 	0x02000013 	0x02010010
+	0x02020019 	0x02030007 	0x02040018
+	0x02050031 	0x02060032 	0x02070005
+	0x02080028 	0x0209006c 	0x03000026
+	0x03010025 	0x03020024 	0x0303000a
+	0x03040017 	0x03050023 	0x03060022
+	0x03070008 	0x03080035 	0x03090069
+	0x04000021 	0x04010012 	0x04020020
+	0x0404002e 	0x04050030 	0x0406001e
+	0x0407000d 	0x04080037 	0x04090067
+	0x05010038 	0x0502000c 	0x0503001b
+	0x05040034 	0x0505001a 	0x05060006
+	0x05080027 	0x0509000e 	0x050a006f
+	0x0600002b 	0x0602004e 	0x06030068
+	0x06040003 	0x0605006d 	0x06060009
+	0x06070001 	0x0609000f 	0x0708002a
+	0x0709001d 	0x070a0033 	>;
+};
+
+/ {
+	model = "TI-NSPIRE Touchpad";
+	compatible = "ti,nspire-tp";
+};
diff --git a/arch/arm/boot/dts/nspire.dtsi b/arch/arm/boot/dts/nspire.dtsi
new file mode 100644
index 0000000..a22ffe6
--- /dev/null
+++ b/arch/arm/boot/dts/nspire.dtsi
@@ -0,0 +1,175 @@
+/*
+ *  linux/arch/arm/boot/nspire.dtsi
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&intc>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	bootrom: bootrom@00000000 {
+		reg = <0x00000000 0x80000>;
+	};
+
+	sram: sram@A4000000 {
+		device = "memory";
+		reg = <0xA4000000 0x20000>;
+	};
+
+	timer_clk: timer_clk {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <32768>;
+	};
+
+	base_clk: base_clk {
+		#clock-cells = <0>;
+		reg = <0x900B0024 0x4>;
+	};
+
+	ahb_clk: ahb_clk {
+		#clock-cells = <0>;
+		reg = <0x900B0024 0x4>;
+		clocks = <&base_clk>;
+	};
+
+	apb_pclk: apb_pclk {
+		#clock-cells = <0>;
+		compatible = "fixed-factor-clock";
+		clock-div = <2>;
+		clock-mult = <1>;
+		clocks = <&ahb_clk>;
+	};
+
+	ahb {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		spi: spi@A9000000 {
+			reg = <0xA9000000 0x1000>;
+		};
+
+		usb0: usb@B0000000 {
+			reg = <0xB0000000 0x1000>;
+			interrupts = <8>;
+		};
+
+		usb1: usb@B4000000 {
+			reg = <0xB4000000 0x1000>;
+			interrupts = <9>;
+			status = "disabled";
+		};
+
+		lcd: lcd@C0000000 {
+			compatible = "arm,pl111", "arm,primecell";
+			reg = <0xC0000000 0x1000>;
+			interrupts = <21>;
+
+			clocks = <&apb_pclk>;
+			clock-names = "apb_pclk";
+		};
+
+		adc: adc@C4000000 {
+			reg = <0xC4000000 0x1000>;
+			interrupts = <11>;
+		};
+
+		tdes: crypto@C8010000 {
+			reg = <0xC8010000 0x1000>;
+		};
+
+		sha256: crypto@CC000000 {
+			reg = <0xCC000000 0x1000>;
+		};
+
+		apb@90000000 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			clock-ranges;
+			ranges;
+
+			gpio: gpio@90000000 {
+				reg = <0x90000000 0x1000>;
+				interrupts = <7>;
+			};
+
+			fast_timer: timer@90010000 {
+				reg = <0x90010000 0x1000>;
+				interrupts = <17>;
+			};
+
+			uart: serial@90020000 {
+				reg = <0x90020000 0x1000>;
+				interrupts = <1>;
+			};
+
+			timer0: timer@900C0000 {
+				reg = <0x900C0000 0x1000>;
+
+				clocks = <&timer_clk>;
+			};
+
+			timer1: timer@900D0000 {
+				reg = <0x900D0000 0x1000>;
+				interrupts = <19>;
+
+				clocks = <&timer_clk>;
+			};
+
+			watchdog: watchdog@90060000 {
+				compatible = "arm,amba-primecell";
+				reg = <0x90060000 0x1000>;
+				interrupts = <3>;
+			};
+
+			rtc: rtc@90090000 {
+				reg = <0x90090000 0x1000>;
+				interrupts = <4>;
+			};
+
+			misc: misc@900A0000 {
+				reg = <0x900A0000 0x1000>;
+			};
+
+			pwr: pwr@900B0000 {
+				reg = <0x900B0000 0x1000>;
+				interrupts = <15>;
+			};
+
+			keypad: input@900E0000 {
+				compatible = "ti,nspire-keypad";
+				reg = <0x900E0000 0x1000>;
+				interrupts = <16>;
+
+				scan-interval = <1000>;
+				row-delay = <200>;
+
+				clocks = <&apb_pclk>;
+			};
+
+			contrast: contrast@900F0000 {
+				reg = <0x900F0000 0x1000>;
+			};
+
+			led: led@90110000 {
+				reg = <0x90110000 0x1000>;
+			};
+		};
+	};
+};
-- 
1.8.1.3


