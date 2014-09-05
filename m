Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaIEGtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:49:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50441 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaIEGtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:49:00 -0400
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 5/6] dts, arm64: Move dts files to vendor subdirs
Date: Fri,  5 Sep 2014 08:48:11 +0200
Message-Id: <1409899692-1455-6-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409899692-1455-1-git-send-email-rric@kernel.org>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

Moving dts files to vendor subdirs.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/boot/dts/Makefile                     |   4 +-
 arch/arm64/boot/dts/apm-mustang.dts              |  34 --
 arch/arm64/boot/dts/apm-storm.dtsi               | 425 -----------------------
 arch/arm64/boot/dts/apm/Makefile                 |   5 +
 arch/arm64/boot/dts/apm/apm-mustang.dts          |  34 ++
 arch/arm64/boot/dts/apm/apm-storm.dtsi           | 425 +++++++++++++++++++++++
 arch/arm64/boot/dts/arm/Makefile                 |   6 +
 arch/arm64/boot/dts/arm/foundation-v8.dts        | 232 +++++++++++++
 arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts       | 159 +++++++++
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi | 240 +++++++++++++
 arch/arm64/boot/dts/foundation-v8.dts            | 232 -------------
 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts           | 159 ---------
 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi     | 240 -------------
 13 files changed, 1103 insertions(+), 1092 deletions(-)
 delete mode 100644 arch/arm64/boot/dts/apm-mustang.dts
 delete mode 100644 arch/arm64/boot/dts/apm-storm.dtsi
 create mode 100644 arch/arm64/boot/dts/apm/Makefile
 create mode 100644 arch/arm64/boot/dts/apm/apm-mustang.dts
 create mode 100644 arch/arm64/boot/dts/apm/apm-storm.dtsi
 create mode 100644 arch/arm64/boot/dts/arm/Makefile
 create mode 100644 arch/arm64/boot/dts/arm/foundation-v8.dts
 create mode 100644 arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
 create mode 100644 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
 delete mode 100644 arch/arm64/boot/dts/foundation-v8.dts
 delete mode 100644 arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
 delete mode 100644 arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi

diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index 9b8622532068..309c3dc4bb70 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,5 +1,5 @@
-dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
-dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
+dts-dirs += apm
+dts-dirs += arm
 
 always		:= $(dtb-y)
 subdir-y	:= $(dts-dirs)
diff --git a/arch/arm64/boot/dts/apm-mustang.dts b/arch/arm64/boot/dts/apm-mustang.dts
deleted file mode 100644
index b2f56229aa5e..000000000000
--- a/arch/arm64/boot/dts/apm-mustang.dts
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * dts file for AppliedMicro (APM) Mustang Board
- *
- * Copyright (C) 2013, Applied Micro Circuits Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of
- * the License, or (at your option) any later version.
- */
-
-/dts-v1/;
-
-/include/ "apm-storm.dtsi"
-
-/ {
-	model = "APM X-Gene Mustang board";
-	compatible = "apm,mustang", "apm,xgene-storm";
-
-	chosen { };
-
-	memory {
-		device_type = "memory";
-		reg = < 0x1 0x00000000 0x0 0x80000000 >; /* Updated by bootloader */
-	};
-};
-
-&serial0 {
-	status = "ok";
-};
-
-&menet {
-	status = "ok";
-};
diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
deleted file mode 100644
index c0aceef7f5b3..000000000000
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ /dev/null
@@ -1,425 +0,0 @@
-/*
- * dts file for AppliedMicro (APM) X-Gene Storm SOC
- *
- * Copyright (C) 2013, Applied Micro Circuits Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of
- * the License, or (at your option) any later version.
- */
-
-/ {
-	compatible = "apm,xgene-storm";
-	interrupt-parent = <&gic>;
-	#address-cells = <2>;
-	#size-cells = <2>;
-
-	cpus {
-		#address-cells = <2>;
-		#size-cells = <0>;
-
-		cpu@000 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x000>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@001 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x001>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@100 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x100>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@101 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x101>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@200 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x200>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@201 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x201>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@300 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x300>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-		cpu@301 {
-			device_type = "cpu";
-			compatible = "apm,potenza", "arm,armv8";
-			reg = <0x0 0x301>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x1 0x0000fff8>;
-		};
-	};
-
-	gic: interrupt-controller@78010000 {
-		compatible = "arm,cortex-a15-gic";
-		#interrupt-cells = <3>;
-		interrupt-controller;
-		reg = <0x0 0x78010000 0x0 0x1000>,	/* GIC Dist */
-		      <0x0 0x78020000 0x0 0x1000>,	/* GIC CPU */
-		      <0x0 0x78040000 0x0 0x2000>,	/* GIC VCPU Control */
-		      <0x0 0x78060000 0x0 0x2000>;	/* GIC VCPU */
-		interrupts = <1 9 0xf04>;	/* GIC Maintenence IRQ */
-	};
-
-	timer {
-		compatible = "arm,armv8-timer";
-		interrupts = <1 0 0xff01>,	/* Secure Phys IRQ */
-			     <1 13 0xff01>,	/* Non-secure Phys IRQ */
-			     <1 14 0xff01>,	/* Virt IRQ */
-			     <1 15 0xff01>;	/* Hyp IRQ */
-		clock-frequency = <50000000>;
-	};
-
-	soc {
-		compatible = "simple-bus";
-		#address-cells = <2>;
-		#size-cells = <2>;
-		ranges;
-
-		clocks {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
-			refclk: refclk {
-				compatible = "fixed-clock";
-				#clock-cells = <1>;
-				clock-frequency = <100000000>;
-				clock-output-names = "refclk";
-			};
-
-			pcppll: pcppll@17000100 {
-				compatible = "apm,xgene-pcppll-clock";
-				#clock-cells = <1>;
-				clocks = <&refclk 0>;
-				clock-names = "pcppll";
-				reg = <0x0 0x17000100 0x0 0x1000>;
-				clock-output-names = "pcppll";
-				type = <0>;
-			};
-
-			socpll: socpll@17000120 {
-				compatible = "apm,xgene-socpll-clock";
-				#clock-cells = <1>;
-				clocks = <&refclk 0>;
-				clock-names = "socpll";
-				reg = <0x0 0x17000120 0x0 0x1000>;
-				clock-output-names = "socpll";
-				type = <1>;
-			};
-
-			socplldiv2: socplldiv2  {
-				compatible = "fixed-factor-clock";
-				#clock-cells = <1>;
-				clocks = <&socpll 0>;
-				clock-names = "socplldiv2";
-				clock-mult = <1>;
-				clock-div = <2>;
-				clock-output-names = "socplldiv2";
-			};
-
-			qmlclk: qmlclk {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				clock-names = "qmlclk";
-				reg = <0x0 0x1703C000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "qmlclk";
-			};
-
-			ethclk: ethclk {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				clock-names = "ethclk";
-				reg = <0x0 0x17000000 0x0 0x1000>;
-				reg-names = "div-reg";
-				divider-offset = <0x238>;
-				divider-width = <0x9>;
-				divider-shift = <0x0>;
-				clock-output-names = "ethclk";
-			};
-
-			menetclk: menetclk {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&ethclk 0>;
-				reg = <0x0 0x1702C000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "menetclk";
-			};
-
-			sataphy1clk: sataphy1clk@1f21c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f21c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sataphy1clk";
-				status = "disabled";
-				csr-offset = <0x4>;
-				csr-mask = <0x00>;
-				enable-offset = <0x0>;
-				enable-mask = <0x06>;
-			};
-
-			sataphy2clk: sataphy1clk@1f22c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f22c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sataphy2clk";
-				status = "ok";
-				csr-offset = <0x4>;
-				csr-mask = <0x3a>;
-				enable-offset = <0x0>;
-				enable-mask = <0x06>;
-			};
-
-			sataphy3clk: sataphy1clk@1f23c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f23c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sataphy3clk";
-				status = "ok";
-				csr-offset = <0x4>;
-				csr-mask = <0x3a>;
-				enable-offset = <0x0>;
-				enable-mask = <0x06>;
-			};
-
-			sata01clk: sata01clk@1f21c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f21c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sata01clk";
-				csr-offset = <0x4>;
-				csr-mask = <0x05>;
-				enable-offset = <0x0>;
-				enable-mask = <0x39>;
-			};
-
-			sata23clk: sata23clk@1f22c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f22c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sata23clk";
-				csr-offset = <0x4>;
-				csr-mask = <0x05>;
-				enable-offset = <0x0>;
-				enable-mask = <0x39>;
-			};
-
-			sata45clk: sata45clk@1f23c000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x1f23c000 0x0 0x1000>;
-				reg-names = "csr-reg";
-				clock-output-names = "sata45clk";
-				csr-offset = <0x4>;
-				csr-mask = <0x05>;
-				enable-offset = <0x0>;
-				enable-mask = <0x39>;
-			};
-
-			rtcclk: rtcclk@17000000 {
-				compatible = "apm,xgene-device-clock";
-				#clock-cells = <1>;
-				clocks = <&socplldiv2 0>;
-				reg = <0x0 0x17000000 0x0 0x2000>;
-				reg-names = "csr-reg";
-				csr-offset = <0xc>;
-				csr-mask = <0x2>;
-				enable-offset = <0x10>;
-				enable-mask = <0x2>;
-				clock-output-names = "rtcclk";
-			};
-		};
-
-		serial0: serial@1c020000 {
-			status = "disabled";
-			device_type = "serial";
-			compatible = "ns16550a";
-			reg = <0 0x1c020000 0x0 0x1000>;
-			reg-shift = <2>;
-			clock-frequency = <10000000>; /* Updated by bootloader */
-			interrupt-parent = <&gic>;
-			interrupts = <0x0 0x4c 0x4>;
-		};
-
-		serial1: serial@1c021000 {
-			status = "disabled";
-			device_type = "serial";
-			compatible = "ns16550a";
-			reg = <0 0x1c021000 0x0 0x1000>;
-			reg-shift = <2>;
-			clock-frequency = <10000000>; /* Updated by bootloader */
-			interrupt-parent = <&gic>;
-			interrupts = <0x0 0x4d 0x4>;
-		};
-
-		serial2: serial@1c022000 {
-			status = "disabled";
-			device_type = "serial";
-			compatible = "ns16550a";
-			reg = <0 0x1c022000 0x0 0x1000>;
-			reg-shift = <2>;
-			clock-frequency = <10000000>; /* Updated by bootloader */
-			interrupt-parent = <&gic>;
-			interrupts = <0x0 0x4e 0x4>;
-		};
-
-		serial3: serial@1c023000 {
-			status = "disabled";
-			device_type = "serial";
-			compatible = "ns16550a";
-			reg = <0 0x1c023000 0x0 0x1000>;
-			reg-shift = <2>;
-			clock-frequency = <10000000>; /* Updated by bootloader */
-			interrupt-parent = <&gic>;
-			interrupts = <0x0 0x4f 0x4>;
-		};
-
-		phy1: phy@1f21a000 {
-			compatible = "apm,xgene-phy";
-			reg = <0x0 0x1f21a000 0x0 0x100>;
-			#phy-cells = <1>;
-			clocks = <&sataphy1clk 0>;
-			status = "disabled";
-			apm,tx-boost-gain = <30 30 30 30 30 30>;
-			apm,tx-eye-tuning = <2 10 10 2 10 10>;
-		};
-
-		phy2: phy@1f22a000 {
-			compatible = "apm,xgene-phy";
-			reg = <0x0 0x1f22a000 0x0 0x100>;
-			#phy-cells = <1>;
-			clocks = <&sataphy2clk 0>;
-			status = "ok";
-			apm,tx-boost-gain = <30 30 30 30 30 30>;
-			apm,tx-eye-tuning = <1 10 10 2 10 10>;
-		};
-
-		phy3: phy@1f23a000 {
-			compatible = "apm,xgene-phy";
-			reg = <0x0 0x1f23a000 0x0 0x100>;
-			#phy-cells = <1>;
-			clocks = <&sataphy3clk 0>;
-			status = "ok";
-			apm,tx-boost-gain = <31 31 31 31 31 31>;
-			apm,tx-eye-tuning = <2 10 10 2 10 10>;
-		};
-
-		sata1: sata@1a000000 {
-			compatible = "apm,xgene-ahci";
-			reg = <0x0 0x1a000000 0x0 0x1000>,
-			      <0x0 0x1f210000 0x0 0x1000>,
-			      <0x0 0x1f21d000 0x0 0x1000>,
-			      <0x0 0x1f21e000 0x0 0x1000>,
-			      <0x0 0x1f217000 0x0 0x1000>;
-			interrupts = <0x0 0x86 0x4>;
-			dma-coherent;
-			status = "disabled";
-			clocks = <&sata01clk 0>;
-			phys = <&phy1 0>;
-			phy-names = "sata-phy";
-		};
-
-		sata2: sata@1a400000 {
-			compatible = "apm,xgene-ahci";
-			reg = <0x0 0x1a400000 0x0 0x1000>,
-			      <0x0 0x1f220000 0x0 0x1000>,
-			      <0x0 0x1f22d000 0x0 0x1000>,
-			      <0x0 0x1f22e000 0x0 0x1000>,
-			      <0x0 0x1f227000 0x0 0x1000>;
-			interrupts = <0x0 0x87 0x4>;
-			dma-coherent;
-			status = "ok";
-			clocks = <&sata23clk 0>;
-			phys = <&phy2 0>;
-			phy-names = "sata-phy";
-		};
-
-		sata3: sata@1a800000 {
-			compatible = "apm,xgene-ahci";
-			reg = <0x0 0x1a800000 0x0 0x1000>,
-			      <0x0 0x1f230000 0x0 0x1000>,
-			      <0x0 0x1f23d000 0x0 0x1000>,
-			      <0x0 0x1f23e000 0x0 0x1000>;
-			interrupts = <0x0 0x88 0x4>;
-			dma-coherent;
-			status = "ok";
-			clocks = <&sata45clk 0>;
-			phys = <&phy3 0>;
-			phy-names = "sata-phy";
-		};
-
-		rtc: rtc@10510000 {
-			compatible = "apm,xgene-rtc";
-			reg = <0x0 0x10510000 0x0 0x400>;
-			interrupts = <0x0 0x46 0x4>;
-			#clock-cells = <1>;
-			clocks = <&rtcclk 0>;
-		};
-
-		menet: ethernet@17020000 {
-			compatible = "apm,xgene-enet";
-			status = "disabled";
-			reg = <0x0 0x17020000 0x0 0xd100>,
-			      <0x0 0X17030000 0x0 0X400>,
-			      <0x0 0X10000000 0x0 0X200>;
-			reg-names = "enet_csr", "ring_csr", "ring_cmd";
-			interrupts = <0x0 0x3c 0x4>;
-			dma-coherent;
-			clocks = <&menetclk 0>;
-			local-mac-address = [00 01 73 00 00 01];
-			phy-connection-type = "rgmii";
-			phy-handle = <&menetphy>;
-			mdio {
-				compatible = "apm,xgene-mdio";
-				#address-cells = <1>;
-				#size-cells = <0>;
-				menetphy: menetphy@3 {
-					compatible = "ethernet-phy-id001c.c915";
-					reg = <0x3>;
-				};
-
-			};
-		};
-	};
-};
diff --git a/arch/arm64/boot/dts/apm/Makefile b/arch/arm64/boot/dts/apm/Makefile
new file mode 100644
index 000000000000..a2afabbc1717
--- /dev/null
+++ b/arch/arm64/boot/dts/apm/Makefile
@@ -0,0 +1,5 @@
+dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
+
+always		:= $(dtb-y)
+subdir-y	:= $(dts-dirs)
+clean-files	:= *.dtb
diff --git a/arch/arm64/boot/dts/apm/apm-mustang.dts b/arch/arm64/boot/dts/apm/apm-mustang.dts
new file mode 100644
index 000000000000..b2f56229aa5e
--- /dev/null
+++ b/arch/arm64/boot/dts/apm/apm-mustang.dts
@@ -0,0 +1,34 @@
+/*
+ * dts file for AppliedMicro (APM) Mustang Board
+ *
+ * Copyright (C) 2013, Applied Micro Circuits Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+
+/dts-v1/;
+
+/include/ "apm-storm.dtsi"
+
+/ {
+	model = "APM X-Gene Mustang board";
+	compatible = "apm,mustang", "apm,xgene-storm";
+
+	chosen { };
+
+	memory {
+		device_type = "memory";
+		reg = < 0x1 0x00000000 0x0 0x80000000 >; /* Updated by bootloader */
+	};
+};
+
+&serial0 {
+	status = "ok";
+};
+
+&menet {
+	status = "ok";
+};
diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
new file mode 100644
index 000000000000..c0aceef7f5b3
--- /dev/null
+++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
@@ -0,0 +1,425 @@
+/*
+ * dts file for AppliedMicro (APM) X-Gene Storm SOC
+ *
+ * Copyright (C) 2013, Applied Micro Circuits Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+
+/ {
+	compatible = "apm,xgene-storm";
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		cpu@000 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x000>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@001 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x001>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@100 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x100>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@101 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x101>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@200 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x200>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@201 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x201>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@300 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x300>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+		cpu@301 {
+			device_type = "cpu";
+			compatible = "apm,potenza", "arm,armv8";
+			reg = <0x0 0x301>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x1 0x0000fff8>;
+		};
+	};
+
+	gic: interrupt-controller@78010000 {
+		compatible = "arm,cortex-a15-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0x0 0x78010000 0x0 0x1000>,	/* GIC Dist */
+		      <0x0 0x78020000 0x0 0x1000>,	/* GIC CPU */
+		      <0x0 0x78040000 0x0 0x2000>,	/* GIC VCPU Control */
+		      <0x0 0x78060000 0x0 0x2000>;	/* GIC VCPU */
+		interrupts = <1 9 0xf04>;	/* GIC Maintenence IRQ */
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <1 0 0xff01>,	/* Secure Phys IRQ */
+			     <1 13 0xff01>,	/* Non-secure Phys IRQ */
+			     <1 14 0xff01>,	/* Virt IRQ */
+			     <1 15 0xff01>;	/* Hyp IRQ */
+		clock-frequency = <50000000>;
+	};
+
+	soc {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		clocks {
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges;
+			refclk: refclk {
+				compatible = "fixed-clock";
+				#clock-cells = <1>;
+				clock-frequency = <100000000>;
+				clock-output-names = "refclk";
+			};
+
+			pcppll: pcppll@17000100 {
+				compatible = "apm,xgene-pcppll-clock";
+				#clock-cells = <1>;
+				clocks = <&refclk 0>;
+				clock-names = "pcppll";
+				reg = <0x0 0x17000100 0x0 0x1000>;
+				clock-output-names = "pcppll";
+				type = <0>;
+			};
+
+			socpll: socpll@17000120 {
+				compatible = "apm,xgene-socpll-clock";
+				#clock-cells = <1>;
+				clocks = <&refclk 0>;
+				clock-names = "socpll";
+				reg = <0x0 0x17000120 0x0 0x1000>;
+				clock-output-names = "socpll";
+				type = <1>;
+			};
+
+			socplldiv2: socplldiv2  {
+				compatible = "fixed-factor-clock";
+				#clock-cells = <1>;
+				clocks = <&socpll 0>;
+				clock-names = "socplldiv2";
+				clock-mult = <1>;
+				clock-div = <2>;
+				clock-output-names = "socplldiv2";
+			};
+
+			qmlclk: qmlclk {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "qmlclk";
+				reg = <0x0 0x1703C000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "qmlclk";
+			};
+
+			ethclk: ethclk {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				clock-names = "ethclk";
+				reg = <0x0 0x17000000 0x0 0x1000>;
+				reg-names = "div-reg";
+				divider-offset = <0x238>;
+				divider-width = <0x9>;
+				divider-shift = <0x0>;
+				clock-output-names = "ethclk";
+			};
+
+			menetclk: menetclk {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&ethclk 0>;
+				reg = <0x0 0x1702C000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "menetclk";
+			};
+
+			sataphy1clk: sataphy1clk@1f21c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f21c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sataphy1clk";
+				status = "disabled";
+				csr-offset = <0x4>;
+				csr-mask = <0x00>;
+				enable-offset = <0x0>;
+				enable-mask = <0x06>;
+			};
+
+			sataphy2clk: sataphy1clk@1f22c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f22c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sataphy2clk";
+				status = "ok";
+				csr-offset = <0x4>;
+				csr-mask = <0x3a>;
+				enable-offset = <0x0>;
+				enable-mask = <0x06>;
+			};
+
+			sataphy3clk: sataphy1clk@1f23c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f23c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sataphy3clk";
+				status = "ok";
+				csr-offset = <0x4>;
+				csr-mask = <0x3a>;
+				enable-offset = <0x0>;
+				enable-mask = <0x06>;
+			};
+
+			sata01clk: sata01clk@1f21c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f21c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata01clk";
+				csr-offset = <0x4>;
+				csr-mask = <0x05>;
+				enable-offset = <0x0>;
+				enable-mask = <0x39>;
+			};
+
+			sata23clk: sata23clk@1f22c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f22c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata23clk";
+				csr-offset = <0x4>;
+				csr-mask = <0x05>;
+				enable-offset = <0x0>;
+				enable-mask = <0x39>;
+			};
+
+			sata45clk: sata45clk@1f23c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f23c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "sata45clk";
+				csr-offset = <0x4>;
+				csr-mask = <0x05>;
+				enable-offset = <0x0>;
+				enable-mask = <0x39>;
+			};
+
+			rtcclk: rtcclk@17000000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x17000000 0x0 0x2000>;
+				reg-names = "csr-reg";
+				csr-offset = <0xc>;
+				csr-mask = <0x2>;
+				enable-offset = <0x10>;
+				enable-mask = <0x2>;
+				clock-output-names = "rtcclk";
+			};
+		};
+
+		serial0: serial@1c020000 {
+			status = "disabled";
+			device_type = "serial";
+			compatible = "ns16550a";
+			reg = <0 0x1c020000 0x0 0x1000>;
+			reg-shift = <2>;
+			clock-frequency = <10000000>; /* Updated by bootloader */
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x4c 0x4>;
+		};
+
+		serial1: serial@1c021000 {
+			status = "disabled";
+			device_type = "serial";
+			compatible = "ns16550a";
+			reg = <0 0x1c021000 0x0 0x1000>;
+			reg-shift = <2>;
+			clock-frequency = <10000000>; /* Updated by bootloader */
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x4d 0x4>;
+		};
+
+		serial2: serial@1c022000 {
+			status = "disabled";
+			device_type = "serial";
+			compatible = "ns16550a";
+			reg = <0 0x1c022000 0x0 0x1000>;
+			reg-shift = <2>;
+			clock-frequency = <10000000>; /* Updated by bootloader */
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x4e 0x4>;
+		};
+
+		serial3: serial@1c023000 {
+			status = "disabled";
+			device_type = "serial";
+			compatible = "ns16550a";
+			reg = <0 0x1c023000 0x0 0x1000>;
+			reg-shift = <2>;
+			clock-frequency = <10000000>; /* Updated by bootloader */
+			interrupt-parent = <&gic>;
+			interrupts = <0x0 0x4f 0x4>;
+		};
+
+		phy1: phy@1f21a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f21a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy1clk 0>;
+			status = "disabled";
+			apm,tx-boost-gain = <30 30 30 30 30 30>;
+			apm,tx-eye-tuning = <2 10 10 2 10 10>;
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy2clk 0>;
+			status = "ok";
+			apm,tx-boost-gain = <30 30 30 30 30 30>;
+			apm,tx-eye-tuning = <1 10 10 2 10 10>;
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f23a000 0x0 0x100>;
+			#phy-cells = <1>;
+			clocks = <&sataphy3clk 0>;
+			status = "ok";
+			apm,tx-boost-gain = <31 31 31 31 31 31>;
+			apm,tx-eye-tuning = <2 10 10 2 10 10>;
+		};
+
+		sata1: sata@1a000000 {
+			compatible = "apm,xgene-ahci";
+			reg = <0x0 0x1a000000 0x0 0x1000>,
+			      <0x0 0x1f210000 0x0 0x1000>,
+			      <0x0 0x1f21d000 0x0 0x1000>,
+			      <0x0 0x1f21e000 0x0 0x1000>,
+			      <0x0 0x1f217000 0x0 0x1000>;
+			interrupts = <0x0 0x86 0x4>;
+			dma-coherent;
+			status = "disabled";
+			clocks = <&sata01clk 0>;
+			phys = <&phy1 0>;
+			phy-names = "sata-phy";
+		};
+
+		sata2: sata@1a400000 {
+			compatible = "apm,xgene-ahci";
+			reg = <0x0 0x1a400000 0x0 0x1000>,
+			      <0x0 0x1f220000 0x0 0x1000>,
+			      <0x0 0x1f22d000 0x0 0x1000>,
+			      <0x0 0x1f22e000 0x0 0x1000>,
+			      <0x0 0x1f227000 0x0 0x1000>;
+			interrupts = <0x0 0x87 0x4>;
+			dma-coherent;
+			status = "ok";
+			clocks = <&sata23clk 0>;
+			phys = <&phy2 0>;
+			phy-names = "sata-phy";
+		};
+
+		sata3: sata@1a800000 {
+			compatible = "apm,xgene-ahci";
+			reg = <0x0 0x1a800000 0x0 0x1000>,
+			      <0x0 0x1f230000 0x0 0x1000>,
+			      <0x0 0x1f23d000 0x0 0x1000>,
+			      <0x0 0x1f23e000 0x0 0x1000>;
+			interrupts = <0x0 0x88 0x4>;
+			dma-coherent;
+			status = "ok";
+			clocks = <&sata45clk 0>;
+			phys = <&phy3 0>;
+			phy-names = "sata-phy";
+		};
+
+		rtc: rtc@10510000 {
+			compatible = "apm,xgene-rtc";
+			reg = <0x0 0x10510000 0x0 0x400>;
+			interrupts = <0x0 0x46 0x4>;
+			#clock-cells = <1>;
+			clocks = <&rtcclk 0>;
+		};
+
+		menet: ethernet@17020000 {
+			compatible = "apm,xgene-enet";
+			status = "disabled";
+			reg = <0x0 0x17020000 0x0 0xd100>,
+			      <0x0 0X17030000 0x0 0X400>,
+			      <0x0 0X10000000 0x0 0X200>;
+			reg-names = "enet_csr", "ring_csr", "ring_cmd";
+			interrupts = <0x0 0x3c 0x4>;
+			dma-coherent;
+			clocks = <&menetclk 0>;
+			local-mac-address = [00 01 73 00 00 01];
+			phy-connection-type = "rgmii";
+			phy-handle = <&menetphy>;
+			mdio {
+				compatible = "apm,xgene-mdio";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				menetphy: menetphy@3 {
+					compatible = "ethernet-phy-id001c.c915";
+					reg = <0x3>;
+				};
+
+			};
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/arm/Makefile b/arch/arm64/boot/dts/arm/Makefile
new file mode 100644
index 000000000000..43d1404bb3c1
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/Makefile
@@ -0,0 +1,6 @@
+dtb-$(CONFIG_ARCH_VEXPRESS) += foundation-v8.dtb
+dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb
+
+always		:= $(dtb-y)
+subdir-y	:= $(dts-dirs)
+clean-files	:= *.dtb
diff --git a/arch/arm64/boot/dts/arm/foundation-v8.dts b/arch/arm64/boot/dts/arm/foundation-v8.dts
new file mode 100644
index 000000000000..4a060906809d
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/foundation-v8.dts
@@ -0,0 +1,232 @@
+/*
+ * ARM Ltd.
+ *
+ * ARMv8 Foundation model DTS
+ */
+
+/dts-v1/;
+
+/memreserve/ 0x80000000 0x00010000;
+
+/ {
+	model = "Foundation-v8A";
+	compatible = "arm,foundation-aarch64", "arm,vexpress";
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	chosen { };
+
+	aliases {
+		serial0 = &v2m_serial0;
+		serial1 = &v2m_serial1;
+		serial2 = &v2m_serial2;
+		serial3 = &v2m_serial3;
+	};
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x1>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x2>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x3>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+	};
+
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0x00000000 0x80000000 0 0x80000000>,
+		      <0x00000008 0x80000000 0 0x80000000>;
+	};
+
+	gic: interrupt-controller@2c001000 {
+		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <0>;
+		interrupt-controller;
+		reg = <0x0 0x2c001000 0 0x1000>,
+		      <0x0 0x2c002000 0 0x1000>,
+		      <0x0 0x2c004000 0 0x2000>,
+		      <0x0 0x2c006000 0 0x2000>;
+		interrupts = <1 9 0xf04>;
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <1 13 0xff01>,
+			     <1 14 0xff01>,
+			     <1 11 0xff01>,
+			     <1 10 0xff01>;
+		clock-frequency = <100000000>;
+	};
+
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <0 60 4>,
+			     <0 61 4>,
+			     <0 62 4>,
+			     <0 63 4>;
+	};
+
+	smb {
+		compatible = "arm,vexpress,v2m-p1", "simple-bus";
+		arm,v2m-memory-map = "rs1";
+		#address-cells = <2>; /* SMB chipselect number and offset */
+		#size-cells = <1>;
+
+		ranges = <0 0 0 0x08000000 0x04000000>,
+			 <1 0 0 0x14000000 0x04000000>,
+			 <2 0 0 0x18000000 0x04000000>,
+			 <3 0 0 0x1c000000 0x04000000>,
+			 <4 0 0 0x0c000000 0x04000000>,
+			 <5 0 0 0x10000000 0x04000000>;
+
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 63>;
+		interrupt-map = <0 0  0 &gic 0  0 4>,
+				<0 0  1 &gic 0  1 4>,
+				<0 0  2 &gic 0  2 4>,
+				<0 0  3 &gic 0  3 4>,
+				<0 0  4 &gic 0  4 4>,
+				<0 0  5 &gic 0  5 4>,
+				<0 0  6 &gic 0  6 4>,
+				<0 0  7 &gic 0  7 4>,
+				<0 0  8 &gic 0  8 4>,
+				<0 0  9 &gic 0  9 4>,
+				<0 0 10 &gic 0 10 4>,
+				<0 0 11 &gic 0 11 4>,
+				<0 0 12 &gic 0 12 4>,
+				<0 0 13 &gic 0 13 4>,
+				<0 0 14 &gic 0 14 4>,
+				<0 0 15 &gic 0 15 4>,
+				<0 0 16 &gic 0 16 4>,
+				<0 0 17 &gic 0 17 4>,
+				<0 0 18 &gic 0 18 4>,
+				<0 0 19 &gic 0 19 4>,
+				<0 0 20 &gic 0 20 4>,
+				<0 0 21 &gic 0 21 4>,
+				<0 0 22 &gic 0 22 4>,
+				<0 0 23 &gic 0 23 4>,
+				<0 0 24 &gic 0 24 4>,
+				<0 0 25 &gic 0 25 4>,
+				<0 0 26 &gic 0 26 4>,
+				<0 0 27 &gic 0 27 4>,
+				<0 0 28 &gic 0 28 4>,
+				<0 0 29 &gic 0 29 4>,
+				<0 0 30 &gic 0 30 4>,
+				<0 0 31 &gic 0 31 4>,
+				<0 0 32 &gic 0 32 4>,
+				<0 0 33 &gic 0 33 4>,
+				<0 0 34 &gic 0 34 4>,
+				<0 0 35 &gic 0 35 4>,
+				<0 0 36 &gic 0 36 4>,
+				<0 0 37 &gic 0 37 4>,
+				<0 0 38 &gic 0 38 4>,
+				<0 0 39 &gic 0 39 4>,
+				<0 0 40 &gic 0 40 4>,
+				<0 0 41 &gic 0 41 4>,
+				<0 0 42 &gic 0 42 4>;
+
+		ethernet@2,02000000 {
+			compatible = "smsc,lan91c111";
+			reg = <2 0x02000000 0x10000>;
+			interrupts = <15>;
+		};
+
+		v2m_clk24mhz: clk24mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <24000000>;
+			clock-output-names = "v2m:clk24mhz";
+		};
+
+		v2m_refclk1mhz: refclk1mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <1000000>;
+			clock-output-names = "v2m:refclk1mhz";
+		};
+
+		v2m_refclk32khz: refclk32khz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <32768>;
+			clock-output-names = "v2m:refclk32khz";
+		};
+
+		iofpga@3,00000000 {
+			compatible = "arm,amba-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 3 0 0x200000>;
+
+			v2m_sysreg: sysreg@010000 {
+				compatible = "arm,vexpress-sysreg";
+				reg = <0x010000 0x1000>;
+			};
+
+			v2m_serial0: uart@090000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x090000 0x1000>;
+				interrupts = <5>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			v2m_serial1: uart@0a0000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x0a0000 0x1000>;
+				interrupts = <6>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			v2m_serial2: uart@0b0000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x0b0000 0x1000>;
+				interrupts = <7>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			v2m_serial3: uart@0c0000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x0c0000 0x1000>;
+				interrupts = <8>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			virtio_block@0130000 {
+				compatible = "virtio,mmio";
+				reg = <0x130000 0x200>;
+				interrupts = <42>;
+			};
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
new file mode 100644
index 000000000000..572005ea2217
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts
@@ -0,0 +1,159 @@
+/*
+ * ARM Ltd. Fast Models
+ *
+ * Architecture Envelope Model (AEM) ARMv8-A
+ * ARMAEMv8AMPCT
+ *
+ * RTSM_VE_AEMv8A.lisa
+ */
+
+/dts-v1/;
+
+/memreserve/ 0x80000000 0x00010000;
+
+/ {
+	model = "RTSM_VE_AEMv8A";
+	compatible = "arm,rtsm_ve,aemv8a", "arm,vexpress";
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	chosen { };
+
+	aliases {
+		serial0 = &v2m_serial0;
+		serial1 = &v2m_serial1;
+		serial2 = &v2m_serial2;
+		serial3 = &v2m_serial3;
+	};
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x0>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x1>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x2>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,armv8";
+			reg = <0x0 0x3>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0x8000fff8>;
+		};
+	};
+
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0x00000000 0x80000000 0 0x80000000>,
+		      <0x00000008 0x80000000 0 0x80000000>;
+	};
+
+	gic: interrupt-controller@2c001000 {
+		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <0>;
+		interrupt-controller;
+		reg = <0x0 0x2c001000 0 0x1000>,
+		      <0x0 0x2c002000 0 0x1000>,
+		      <0x0 0x2c004000 0 0x2000>,
+		      <0x0 0x2c006000 0 0x2000>;
+		interrupts = <1 9 0xf04>;
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <1 13 0xff01>,
+			     <1 14 0xff01>,
+			     <1 11 0xff01>,
+			     <1 10 0xff01>;
+		clock-frequency = <100000000>;
+	};
+
+	pmu {
+		compatible = "arm,armv8-pmuv3";
+		interrupts = <0 60 4>,
+			     <0 61 4>,
+			     <0 62 4>,
+			     <0 63 4>;
+	};
+
+	smb {
+		compatible = "simple-bus";
+
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <0 0 0 0x08000000 0x04000000>,
+			 <1 0 0 0x14000000 0x04000000>,
+			 <2 0 0 0x18000000 0x04000000>,
+			 <3 0 0 0x1c000000 0x04000000>,
+			 <4 0 0 0x0c000000 0x04000000>,
+			 <5 0 0 0x10000000 0x04000000>;
+
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 63>;
+		interrupt-map = <0 0  0 &gic 0  0 4>,
+				<0 0  1 &gic 0  1 4>,
+				<0 0  2 &gic 0  2 4>,
+				<0 0  3 &gic 0  3 4>,
+				<0 0  4 &gic 0  4 4>,
+				<0 0  5 &gic 0  5 4>,
+				<0 0  6 &gic 0  6 4>,
+				<0 0  7 &gic 0  7 4>,
+				<0 0  8 &gic 0  8 4>,
+				<0 0  9 &gic 0  9 4>,
+				<0 0 10 &gic 0 10 4>,
+				<0 0 11 &gic 0 11 4>,
+				<0 0 12 &gic 0 12 4>,
+				<0 0 13 &gic 0 13 4>,
+				<0 0 14 &gic 0 14 4>,
+				<0 0 15 &gic 0 15 4>,
+				<0 0 16 &gic 0 16 4>,
+				<0 0 17 &gic 0 17 4>,
+				<0 0 18 &gic 0 18 4>,
+				<0 0 19 &gic 0 19 4>,
+				<0 0 20 &gic 0 20 4>,
+				<0 0 21 &gic 0 21 4>,
+				<0 0 22 &gic 0 22 4>,
+				<0 0 23 &gic 0 23 4>,
+				<0 0 24 &gic 0 24 4>,
+				<0 0 25 &gic 0 25 4>,
+				<0 0 26 &gic 0 26 4>,
+				<0 0 27 &gic 0 27 4>,
+				<0 0 28 &gic 0 28 4>,
+				<0 0 29 &gic 0 29 4>,
+				<0 0 30 &gic 0 30 4>,
+				<0 0 31 &gic 0 31 4>,
+				<0 0 32 &gic 0 32 4>,
+				<0 0 33 &gic 0 33 4>,
+				<0 0 34 &gic 0 34 4>,
+				<0 0 35 &gic 0 35 4>,
+				<0 0 36 &gic 0 36 4>,
+				<0 0 37 &gic 0 37 4>,
+				<0 0 38 &gic 0 38 4>,
+				<0 0 39 &gic 0 39 4>,
+				<0 0 40 &gic 0 40 4>,
+				<0 0 41 &gic 0 41 4>,
+				<0 0 42 &gic 0 42 4>;
+
+		/include/ "rtsm_ve-motherboard.dtsi"
+	};
+};
diff --git a/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
new file mode 100644
index 000000000000..ac2cb2418025
--- /dev/null
+++ b/arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi
@@ -0,0 +1,240 @@
+/*
+ * ARM Ltd. Fast Models
+ *
+ * Versatile Express (VE) system model
+ * Motherboard component
+ *
+ * VEMotherBoard.lisa
+ */
+
+	motherboard {
+		arm,v2m-memory-map = "rs1";
+		compatible = "arm,vexpress,v2m-p1", "simple-bus";
+		#address-cells = <2>; /* SMB chipselect number and offset */
+		#size-cells = <1>;
+		#interrupt-cells = <1>;
+		ranges;
+
+		flash@0,00000000 {
+			compatible = "arm,vexpress-flash", "cfi-flash";
+			reg = <0 0x00000000 0x04000000>,
+			      <4 0x00000000 0x04000000>;
+			bank-width = <4>;
+		};
+
+		vram@2,00000000 {
+			compatible = "arm,vexpress-vram";
+			reg = <2 0x00000000 0x00800000>;
+		};
+
+		ethernet@2,02000000 {
+			compatible = "smsc,lan91c111";
+			reg = <2 0x02000000 0x10000>;
+			interrupts = <15>;
+		};
+
+		v2m_clk24mhz: clk24mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <24000000>;
+			clock-output-names = "v2m:clk24mhz";
+		};
+
+		v2m_refclk1mhz: refclk1mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <1000000>;
+			clock-output-names = "v2m:refclk1mhz";
+		};
+
+		v2m_refclk32khz: refclk32khz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <32768>;
+			clock-output-names = "v2m:refclk32khz";
+		};
+
+		iofpga@3,00000000 {
+			compatible = "arm,amba-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 3 0 0x200000>;
+
+			v2m_sysreg: sysreg@010000 {
+				compatible = "arm,vexpress-sysreg";
+				reg = <0x010000 0x1000>;
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+
+			v2m_sysctl: sysctl@020000 {
+				compatible = "arm,sp810", "arm,primecell";
+				reg = <0x020000 0x1000>;
+				clocks = <&v2m_refclk32khz>, <&v2m_refclk1mhz>, <&v2m_clk24mhz>;
+				clock-names = "refclk", "timclk", "apb_pclk";
+				#clock-cells = <1>;
+				clock-output-names = "timerclken0", "timerclken1", "timerclken2", "timerclken3";
+			};
+
+			aaci@040000 {
+				compatible = "arm,pl041", "arm,primecell";
+				reg = <0x040000 0x1000>;
+				interrupts = <11>;
+				clocks = <&v2m_clk24mhz>;
+				clock-names = "apb_pclk";
+			};
+
+			mmci@050000 {
+				compatible = "arm,pl180", "arm,primecell";
+				reg = <0x050000 0x1000>;
+				interrupts = <9 10>;
+				cd-gpios = <&v2m_sysreg 0 0>;
+				wp-gpios = <&v2m_sysreg 1 0>;
+				max-frequency = <12000000>;
+				vmmc-supply = <&v2m_fixed_3v3>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "mclk", "apb_pclk";
+			};
+
+			kmi@060000 {
+				compatible = "arm,pl050", "arm,primecell";
+				reg = <0x060000 0x1000>;
+				interrupts = <12>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "KMIREFCLK", "apb_pclk";
+			};
+
+			kmi@070000 {
+				compatible = "arm,pl050", "arm,primecell";
+				reg = <0x070000 0x1000>;
+				interrupts = <13>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "KMIREFCLK", "apb_pclk";
+			};
+
+			v2m_serial0: uart@090000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x090000 0x1000>;
+				interrupts = <5>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			v2m_serial1: uart@0a0000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x0a0000 0x1000>;
+				interrupts = <6>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			v2m_serial2: uart@0b0000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x0b0000 0x1000>;
+				interrupts = <7>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			v2m_serial3: uart@0c0000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x0c0000 0x1000>;
+				interrupts = <8>;
+				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
+				clock-names = "uartclk", "apb_pclk";
+			};
+
+			wdt@0f0000 {
+				compatible = "arm,sp805", "arm,primecell";
+				reg = <0x0f0000 0x1000>;
+				interrupts = <0>;
+				clocks = <&v2m_refclk32khz>, <&v2m_clk24mhz>;
+				clock-names = "wdogclk", "apb_pclk";
+			};
+
+			v2m_timer01: timer@110000 {
+				compatible = "arm,sp804", "arm,primecell";
+				reg = <0x110000 0x1000>;
+				interrupts = <2>;
+				clocks = <&v2m_sysctl 0>, <&v2m_sysctl 1>, <&v2m_clk24mhz>;
+				clock-names = "timclken1", "timclken2", "apb_pclk";
+			};
+
+			v2m_timer23: timer@120000 {
+				compatible = "arm,sp804", "arm,primecell";
+				reg = <0x120000 0x1000>;
+				interrupts = <3>;
+				clocks = <&v2m_sysctl 2>, <&v2m_sysctl 3>, <&v2m_clk24mhz>;
+				clock-names = "timclken1", "timclken2", "apb_pclk";
+			};
+
+			rtc@170000 {
+				compatible = "arm,pl031", "arm,primecell";
+				reg = <0x170000 0x1000>;
+				interrupts = <4>;
+				clocks = <&v2m_clk24mhz>;
+				clock-names = "apb_pclk";
+			};
+
+			clcd@1f0000 {
+				compatible = "arm,pl111", "arm,primecell";
+				reg = <0x1f0000 0x1000>;
+				interrupts = <14>;
+				clocks = <&v2m_oscclk1>, <&v2m_clk24mhz>;
+				clock-names = "clcdclk", "apb_pclk";
+			};
+
+			virtio_block@0130000 {
+				compatible = "virtio,mmio";
+				reg = <0x130000 0x200>;
+				interrupts = <42>;
+			};
+		};
+
+		v2m_fixed_3v3: fixedregulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "3V3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		mcc {
+			compatible = "arm,vexpress,config-bus";
+			arm,vexpress,config-bridge = <&v2m_sysreg>;
+
+			v2m_oscclk1: osc@1 {
+				/* CLCD clock */
+				compatible = "arm,vexpress-osc";
+				arm,vexpress-sysreg,func = <1 1>;
+				freq-range = <23750000 63500000>;
+				#clock-cells = <0>;
+				clock-output-names = "v2m:oscclk1";
+			};
+
+			reset@0 {
+				compatible = "arm,vexpress-reset";
+				arm,vexpress-sysreg,func = <5 0>;
+			};
+
+			muxfpga@0 {
+				compatible = "arm,vexpress-muxfpga";
+				arm,vexpress-sysreg,func = <7 0>;
+			};
+
+			shutdown@0 {
+				compatible = "arm,vexpress-shutdown";
+				arm,vexpress-sysreg,func = <8 0>;
+			};
+
+			reboot@0 {
+				compatible = "arm,vexpress-reboot";
+				arm,vexpress-sysreg,func = <9 0>;
+			};
+
+			dvimode@0 {
+				compatible = "arm,vexpress-dvimode";
+				arm,vexpress-sysreg,func = <11 0>;
+			};
+		};
+	};
diff --git a/arch/arm64/boot/dts/foundation-v8.dts b/arch/arm64/boot/dts/foundation-v8.dts
deleted file mode 100644
index 4a060906809d..000000000000
--- a/arch/arm64/boot/dts/foundation-v8.dts
+++ /dev/null
@@ -1,232 +0,0 @@
-/*
- * ARM Ltd.
- *
- * ARMv8 Foundation model DTS
- */
-
-/dts-v1/;
-
-/memreserve/ 0x80000000 0x00010000;
-
-/ {
-	model = "Foundation-v8A";
-	compatible = "arm,foundation-aarch64", "arm,vexpress";
-	interrupt-parent = <&gic>;
-	#address-cells = <2>;
-	#size-cells = <2>;
-
-	chosen { };
-
-	aliases {
-		serial0 = &v2m_serial0;
-		serial1 = &v2m_serial1;
-		serial2 = &v2m_serial2;
-		serial3 = &v2m_serial3;
-	};
-
-	cpus {
-		#address-cells = <2>;
-		#size-cells = <0>;
-
-		cpu@0 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x0>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-		cpu@1 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x1>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-		cpu@2 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x2>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-		cpu@3 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x3>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-	};
-
-	memory@80000000 {
-		device_type = "memory";
-		reg = <0x00000000 0x80000000 0 0x80000000>,
-		      <0x00000008 0x80000000 0 0x80000000>;
-	};
-
-	gic: interrupt-controller@2c001000 {
-		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
-		#interrupt-cells = <3>;
-		#address-cells = <0>;
-		interrupt-controller;
-		reg = <0x0 0x2c001000 0 0x1000>,
-		      <0x0 0x2c002000 0 0x1000>,
-		      <0x0 0x2c004000 0 0x2000>,
-		      <0x0 0x2c006000 0 0x2000>;
-		interrupts = <1 9 0xf04>;
-	};
-
-	timer {
-		compatible = "arm,armv8-timer";
-		interrupts = <1 13 0xff01>,
-			     <1 14 0xff01>,
-			     <1 11 0xff01>,
-			     <1 10 0xff01>;
-		clock-frequency = <100000000>;
-	};
-
-	pmu {
-		compatible = "arm,armv8-pmuv3";
-		interrupts = <0 60 4>,
-			     <0 61 4>,
-			     <0 62 4>,
-			     <0 63 4>;
-	};
-
-	smb {
-		compatible = "arm,vexpress,v2m-p1", "simple-bus";
-		arm,v2m-memory-map = "rs1";
-		#address-cells = <2>; /* SMB chipselect number and offset */
-		#size-cells = <1>;
-
-		ranges = <0 0 0 0x08000000 0x04000000>,
-			 <1 0 0 0x14000000 0x04000000>,
-			 <2 0 0 0x18000000 0x04000000>,
-			 <3 0 0 0x1c000000 0x04000000>,
-			 <4 0 0 0x0c000000 0x04000000>,
-			 <5 0 0 0x10000000 0x04000000>;
-
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 63>;
-		interrupt-map = <0 0  0 &gic 0  0 4>,
-				<0 0  1 &gic 0  1 4>,
-				<0 0  2 &gic 0  2 4>,
-				<0 0  3 &gic 0  3 4>,
-				<0 0  4 &gic 0  4 4>,
-				<0 0  5 &gic 0  5 4>,
-				<0 0  6 &gic 0  6 4>,
-				<0 0  7 &gic 0  7 4>,
-				<0 0  8 &gic 0  8 4>,
-				<0 0  9 &gic 0  9 4>,
-				<0 0 10 &gic 0 10 4>,
-				<0 0 11 &gic 0 11 4>,
-				<0 0 12 &gic 0 12 4>,
-				<0 0 13 &gic 0 13 4>,
-				<0 0 14 &gic 0 14 4>,
-				<0 0 15 &gic 0 15 4>,
-				<0 0 16 &gic 0 16 4>,
-				<0 0 17 &gic 0 17 4>,
-				<0 0 18 &gic 0 18 4>,
-				<0 0 19 &gic 0 19 4>,
-				<0 0 20 &gic 0 20 4>,
-				<0 0 21 &gic 0 21 4>,
-				<0 0 22 &gic 0 22 4>,
-				<0 0 23 &gic 0 23 4>,
-				<0 0 24 &gic 0 24 4>,
-				<0 0 25 &gic 0 25 4>,
-				<0 0 26 &gic 0 26 4>,
-				<0 0 27 &gic 0 27 4>,
-				<0 0 28 &gic 0 28 4>,
-				<0 0 29 &gic 0 29 4>,
-				<0 0 30 &gic 0 30 4>,
-				<0 0 31 &gic 0 31 4>,
-				<0 0 32 &gic 0 32 4>,
-				<0 0 33 &gic 0 33 4>,
-				<0 0 34 &gic 0 34 4>,
-				<0 0 35 &gic 0 35 4>,
-				<0 0 36 &gic 0 36 4>,
-				<0 0 37 &gic 0 37 4>,
-				<0 0 38 &gic 0 38 4>,
-				<0 0 39 &gic 0 39 4>,
-				<0 0 40 &gic 0 40 4>,
-				<0 0 41 &gic 0 41 4>,
-				<0 0 42 &gic 0 42 4>;
-
-		ethernet@2,02000000 {
-			compatible = "smsc,lan91c111";
-			reg = <2 0x02000000 0x10000>;
-			interrupts = <15>;
-		};
-
-		v2m_clk24mhz: clk24mhz {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <24000000>;
-			clock-output-names = "v2m:clk24mhz";
-		};
-
-		v2m_refclk1mhz: refclk1mhz {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <1000000>;
-			clock-output-names = "v2m:refclk1mhz";
-		};
-
-		v2m_refclk32khz: refclk32khz {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <32768>;
-			clock-output-names = "v2m:refclk32khz";
-		};
-
-		iofpga@3,00000000 {
-			compatible = "arm,amba-bus", "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0 3 0 0x200000>;
-
-			v2m_sysreg: sysreg@010000 {
-				compatible = "arm,vexpress-sysreg";
-				reg = <0x010000 0x1000>;
-			};
-
-			v2m_serial0: uart@090000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x090000 0x1000>;
-				interrupts = <5>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			v2m_serial1: uart@0a0000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x0a0000 0x1000>;
-				interrupts = <6>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			v2m_serial2: uart@0b0000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x0b0000 0x1000>;
-				interrupts = <7>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			v2m_serial3: uart@0c0000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x0c0000 0x1000>;
-				interrupts = <8>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			virtio_block@0130000 {
-				compatible = "virtio,mmio";
-				reg = <0x130000 0x200>;
-				interrupts = <42>;
-			};
-		};
-	};
-};
diff --git a/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts b/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
deleted file mode 100644
index 572005ea2217..000000000000
--- a/arch/arm64/boot/dts/rtsm_ve-aemv8a.dts
+++ /dev/null
@@ -1,159 +0,0 @@
-/*
- * ARM Ltd. Fast Models
- *
- * Architecture Envelope Model (AEM) ARMv8-A
- * ARMAEMv8AMPCT
- *
- * RTSM_VE_AEMv8A.lisa
- */
-
-/dts-v1/;
-
-/memreserve/ 0x80000000 0x00010000;
-
-/ {
-	model = "RTSM_VE_AEMv8A";
-	compatible = "arm,rtsm_ve,aemv8a", "arm,vexpress";
-	interrupt-parent = <&gic>;
-	#address-cells = <2>;
-	#size-cells = <2>;
-
-	chosen { };
-
-	aliases {
-		serial0 = &v2m_serial0;
-		serial1 = &v2m_serial1;
-		serial2 = &v2m_serial2;
-		serial3 = &v2m_serial3;
-	};
-
-	cpus {
-		#address-cells = <2>;
-		#size-cells = <0>;
-
-		cpu@0 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x0>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-		cpu@1 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x1>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-		cpu@2 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x2>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-		cpu@3 {
-			device_type = "cpu";
-			compatible = "arm,armv8";
-			reg = <0x0 0x3>;
-			enable-method = "spin-table";
-			cpu-release-addr = <0x0 0x8000fff8>;
-		};
-	};
-
-	memory@80000000 {
-		device_type = "memory";
-		reg = <0x00000000 0x80000000 0 0x80000000>,
-		      <0x00000008 0x80000000 0 0x80000000>;
-	};
-
-	gic: interrupt-controller@2c001000 {
-		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
-		#interrupt-cells = <3>;
-		#address-cells = <0>;
-		interrupt-controller;
-		reg = <0x0 0x2c001000 0 0x1000>,
-		      <0x0 0x2c002000 0 0x1000>,
-		      <0x0 0x2c004000 0 0x2000>,
-		      <0x0 0x2c006000 0 0x2000>;
-		interrupts = <1 9 0xf04>;
-	};
-
-	timer {
-		compatible = "arm,armv8-timer";
-		interrupts = <1 13 0xff01>,
-			     <1 14 0xff01>,
-			     <1 11 0xff01>,
-			     <1 10 0xff01>;
-		clock-frequency = <100000000>;
-	};
-
-	pmu {
-		compatible = "arm,armv8-pmuv3";
-		interrupts = <0 60 4>,
-			     <0 61 4>,
-			     <0 62 4>,
-			     <0 63 4>;
-	};
-
-	smb {
-		compatible = "simple-bus";
-
-		#address-cells = <2>;
-		#size-cells = <1>;
-		ranges = <0 0 0 0x08000000 0x04000000>,
-			 <1 0 0 0x14000000 0x04000000>,
-			 <2 0 0 0x18000000 0x04000000>,
-			 <3 0 0 0x1c000000 0x04000000>,
-			 <4 0 0 0x0c000000 0x04000000>,
-			 <5 0 0 0x10000000 0x04000000>;
-
-		#interrupt-cells = <1>;
-		interrupt-map-mask = <0 0 63>;
-		interrupt-map = <0 0  0 &gic 0  0 4>,
-				<0 0  1 &gic 0  1 4>,
-				<0 0  2 &gic 0  2 4>,
-				<0 0  3 &gic 0  3 4>,
-				<0 0  4 &gic 0  4 4>,
-				<0 0  5 &gic 0  5 4>,
-				<0 0  6 &gic 0  6 4>,
-				<0 0  7 &gic 0  7 4>,
-				<0 0  8 &gic 0  8 4>,
-				<0 0  9 &gic 0  9 4>,
-				<0 0 10 &gic 0 10 4>,
-				<0 0 11 &gic 0 11 4>,
-				<0 0 12 &gic 0 12 4>,
-				<0 0 13 &gic 0 13 4>,
-				<0 0 14 &gic 0 14 4>,
-				<0 0 15 &gic 0 15 4>,
-				<0 0 16 &gic 0 16 4>,
-				<0 0 17 &gic 0 17 4>,
-				<0 0 18 &gic 0 18 4>,
-				<0 0 19 &gic 0 19 4>,
-				<0 0 20 &gic 0 20 4>,
-				<0 0 21 &gic 0 21 4>,
-				<0 0 22 &gic 0 22 4>,
-				<0 0 23 &gic 0 23 4>,
-				<0 0 24 &gic 0 24 4>,
-				<0 0 25 &gic 0 25 4>,
-				<0 0 26 &gic 0 26 4>,
-				<0 0 27 &gic 0 27 4>,
-				<0 0 28 &gic 0 28 4>,
-				<0 0 29 &gic 0 29 4>,
-				<0 0 30 &gic 0 30 4>,
-				<0 0 31 &gic 0 31 4>,
-				<0 0 32 &gic 0 32 4>,
-				<0 0 33 &gic 0 33 4>,
-				<0 0 34 &gic 0 34 4>,
-				<0 0 35 &gic 0 35 4>,
-				<0 0 36 &gic 0 36 4>,
-				<0 0 37 &gic 0 37 4>,
-				<0 0 38 &gic 0 38 4>,
-				<0 0 39 &gic 0 39 4>,
-				<0 0 40 &gic 0 40 4>,
-				<0 0 41 &gic 0 41 4>,
-				<0 0 42 &gic 0 42 4>;
-
-		/include/ "rtsm_ve-motherboard.dtsi"
-	};
-};
diff --git a/arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi b/arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi
deleted file mode 100644
index ac2cb2418025..000000000000
--- a/arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * ARM Ltd. Fast Models
- *
- * Versatile Express (VE) system model
- * Motherboard component
- *
- * VEMotherBoard.lisa
- */
-
-	motherboard {
-		arm,v2m-memory-map = "rs1";
-		compatible = "arm,vexpress,v2m-p1", "simple-bus";
-		#address-cells = <2>; /* SMB chipselect number and offset */
-		#size-cells = <1>;
-		#interrupt-cells = <1>;
-		ranges;
-
-		flash@0,00000000 {
-			compatible = "arm,vexpress-flash", "cfi-flash";
-			reg = <0 0x00000000 0x04000000>,
-			      <4 0x00000000 0x04000000>;
-			bank-width = <4>;
-		};
-
-		vram@2,00000000 {
-			compatible = "arm,vexpress-vram";
-			reg = <2 0x00000000 0x00800000>;
-		};
-
-		ethernet@2,02000000 {
-			compatible = "smsc,lan91c111";
-			reg = <2 0x02000000 0x10000>;
-			interrupts = <15>;
-		};
-
-		v2m_clk24mhz: clk24mhz {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <24000000>;
-			clock-output-names = "v2m:clk24mhz";
-		};
-
-		v2m_refclk1mhz: refclk1mhz {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <1000000>;
-			clock-output-names = "v2m:refclk1mhz";
-		};
-
-		v2m_refclk32khz: refclk32khz {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <32768>;
-			clock-output-names = "v2m:refclk32khz";
-		};
-
-		iofpga@3,00000000 {
-			compatible = "arm,amba-bus", "simple-bus";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			ranges = <0 3 0 0x200000>;
-
-			v2m_sysreg: sysreg@010000 {
-				compatible = "arm,vexpress-sysreg";
-				reg = <0x010000 0x1000>;
-				gpio-controller;
-				#gpio-cells = <2>;
-			};
-
-			v2m_sysctl: sysctl@020000 {
-				compatible = "arm,sp810", "arm,primecell";
-				reg = <0x020000 0x1000>;
-				clocks = <&v2m_refclk32khz>, <&v2m_refclk1mhz>, <&v2m_clk24mhz>;
-				clock-names = "refclk", "timclk", "apb_pclk";
-				#clock-cells = <1>;
-				clock-output-names = "timerclken0", "timerclken1", "timerclken2", "timerclken3";
-			};
-
-			aaci@040000 {
-				compatible = "arm,pl041", "arm,primecell";
-				reg = <0x040000 0x1000>;
-				interrupts = <11>;
-				clocks = <&v2m_clk24mhz>;
-				clock-names = "apb_pclk";
-			};
-
-			mmci@050000 {
-				compatible = "arm,pl180", "arm,primecell";
-				reg = <0x050000 0x1000>;
-				interrupts = <9 10>;
-				cd-gpios = <&v2m_sysreg 0 0>;
-				wp-gpios = <&v2m_sysreg 1 0>;
-				max-frequency = <12000000>;
-				vmmc-supply = <&v2m_fixed_3v3>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "mclk", "apb_pclk";
-			};
-
-			kmi@060000 {
-				compatible = "arm,pl050", "arm,primecell";
-				reg = <0x060000 0x1000>;
-				interrupts = <12>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "KMIREFCLK", "apb_pclk";
-			};
-
-			kmi@070000 {
-				compatible = "arm,pl050", "arm,primecell";
-				reg = <0x070000 0x1000>;
-				interrupts = <13>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "KMIREFCLK", "apb_pclk";
-			};
-
-			v2m_serial0: uart@090000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x090000 0x1000>;
-				interrupts = <5>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			v2m_serial1: uart@0a0000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x0a0000 0x1000>;
-				interrupts = <6>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			v2m_serial2: uart@0b0000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x0b0000 0x1000>;
-				interrupts = <7>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			v2m_serial3: uart@0c0000 {
-				compatible = "arm,pl011", "arm,primecell";
-				reg = <0x0c0000 0x1000>;
-				interrupts = <8>;
-				clocks = <&v2m_clk24mhz>, <&v2m_clk24mhz>;
-				clock-names = "uartclk", "apb_pclk";
-			};
-
-			wdt@0f0000 {
-				compatible = "arm,sp805", "arm,primecell";
-				reg = <0x0f0000 0x1000>;
-				interrupts = <0>;
-				clocks = <&v2m_refclk32khz>, <&v2m_clk24mhz>;
-				clock-names = "wdogclk", "apb_pclk";
-			};
-
-			v2m_timer01: timer@110000 {
-				compatible = "arm,sp804", "arm,primecell";
-				reg = <0x110000 0x1000>;
-				interrupts = <2>;
-				clocks = <&v2m_sysctl 0>, <&v2m_sysctl 1>, <&v2m_clk24mhz>;
-				clock-names = "timclken1", "timclken2", "apb_pclk";
-			};
-
-			v2m_timer23: timer@120000 {
-				compatible = "arm,sp804", "arm,primecell";
-				reg = <0x120000 0x1000>;
-				interrupts = <3>;
-				clocks = <&v2m_sysctl 2>, <&v2m_sysctl 3>, <&v2m_clk24mhz>;
-				clock-names = "timclken1", "timclken2", "apb_pclk";
-			};
-
-			rtc@170000 {
-				compatible = "arm,pl031", "arm,primecell";
-				reg = <0x170000 0x1000>;
-				interrupts = <4>;
-				clocks = <&v2m_clk24mhz>;
-				clock-names = "apb_pclk";
-			};
-
-			clcd@1f0000 {
-				compatible = "arm,pl111", "arm,primecell";
-				reg = <0x1f0000 0x1000>;
-				interrupts = <14>;
-				clocks = <&v2m_oscclk1>, <&v2m_clk24mhz>;
-				clock-names = "clcdclk", "apb_pclk";
-			};
-
-			virtio_block@0130000 {
-				compatible = "virtio,mmio";
-				reg = <0x130000 0x200>;
-				interrupts = <42>;
-			};
-		};
-
-		v2m_fixed_3v3: fixedregulator@0 {
-			compatible = "regulator-fixed";
-			regulator-name = "3V3";
-			regulator-min-microvolt = <3300000>;
-			regulator-max-microvolt = <3300000>;
-			regulator-always-on;
-		};
-
-		mcc {
-			compatible = "arm,vexpress,config-bus";
-			arm,vexpress,config-bridge = <&v2m_sysreg>;
-
-			v2m_oscclk1: osc@1 {
-				/* CLCD clock */
-				compatible = "arm,vexpress-osc";
-				arm,vexpress-sysreg,func = <1 1>;
-				freq-range = <23750000 63500000>;
-				#clock-cells = <0>;
-				clock-output-names = "v2m:oscclk1";
-			};
-
-			reset@0 {
-				compatible = "arm,vexpress-reset";
-				arm,vexpress-sysreg,func = <5 0>;
-			};
-
-			muxfpga@0 {
-				compatible = "arm,vexpress-muxfpga";
-				arm,vexpress-sysreg,func = <7 0>;
-			};
-
-			shutdown@0 {
-				compatible = "arm,vexpress-shutdown";
-				arm,vexpress-sysreg,func = <8 0>;
-			};
-
-			reboot@0 {
-				compatible = "arm,vexpress-reboot";
-				arm,vexpress-sysreg,func = <9 0>;
-			};
-
-			dvimode@0 {
-				compatible = "arm,vexpress-dvimode";
-				arm,vexpress-sysreg,func = <11 0>;
-			};
-		};
-	};
-- 
2.0.1

