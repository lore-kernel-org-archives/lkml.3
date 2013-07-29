Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3G2M3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:29:21 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:42733 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3G2M3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:29:18 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: dove: add cpu device tree node
Date: Mon, 29 Jul 2013 14:29:03 +0200
Message-Id: <1375100946-28521-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a node for the Marvell Sheeva PJ4A CPU found on Dove SoCs.
While at it, also move the l2-cache node out of internal registers and
consistently name different nodes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |   52 ++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 8d5be1e8..09d9710 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -10,6 +10,23 @@
 		gpio2 = &gpio2;
 	};
 
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu0: cpu@0 {
+			compatible = "marvell,pj4a", "marvell,sheeva-v7";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <0>;
+		};
+	};
+
+	l2: l2-cache {
+		compatible = "marvell,tauros2-cache";
+		marvell,tauros2-cache-features = <0>;
+	};
+
 	soc@f1000000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -25,11 +42,6 @@
 		          0xf2100000 0xf2100000 0x0100000   /* PCIe0 I/O   1M */
 		          0xf8000000 0xf8000000 0x8000000>; /* BootROM   128M */
 
-		l2: l2-cache {
-			compatible = "marvell,tauros2-cache";
-			marvell,tauros2-cache-features = <0>;
-		};
-
 		timer: timer@20300 {
 			compatible = "marvell,orion-timer";
 			reg = <0x20300 0x20>;
@@ -60,14 +72,14 @@
 			#clock-cells = <1>;
 		};
 
-		gate_clk: clock-gating-control@d0038 {
+		gate_clk: clock-gating-ctrl@d0038 {
 			compatible = "marvell,dove-gating-clock";
 			reg = <0xd0038 0x4>;
 			clocks = <&core_clk 0>;
 			#clock-cells = <1>;
 		};
 
-		thermal: thermal@d001c {
+		thermal: thermal-diode@d001c {
 			compatible = "marvell,dove-thermal";
 			reg = <0xd001c 0x0c>, <0xd005c 0x08>;
 		};
@@ -108,7 +120,7 @@
 			status = "disabled";
 		};
 
-		gpio0: gpio@d0400 {
+		gpio0: gpio-ctrl@d0400 {
 			compatible = "marvell,orion-gpio";
 			#gpio-cells = <2>;
 			gpio-controller;
@@ -119,7 +131,7 @@
 			interrupts = <12>, <13>, <14>, <60>;
 		};
 
-		gpio1: gpio@d0420 {
+		gpio1: gpio-ctrl@d0420 {
 			compatible = "marvell,orion-gpio";
 			#gpio-cells = <2>;
 			gpio-controller;
@@ -130,7 +142,7 @@
 			interrupts = <61>;
 		};
 
-		gpio2: gpio@e8400 {
+		gpio2: gpio-ctrl@e8400 {
 			compatible = "marvell,orion-gpio";
 			#gpio-cells = <2>;
 			gpio-controller;
@@ -138,13 +150,13 @@
 			ngpios = <8>;
 		};
 
-		pinctrl: pinctrl@d0200 {
+		pinctrl: pin-ctrl@d0200 {
 			compatible = "marvell,dove-pinctrl";
 			reg = <0xd0200 0x10>;
 			clocks = <&gate_clk 22>;
 		};
 
-		spi0: spi@10600 {
+		spi0: spi-ctrl@10600 {
 			compatible = "marvell,orion-spi";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -155,7 +167,7 @@
 			status = "disabled";
 		};
 
-		spi1: spi@14600 {
+		spi1: spi-ctrl@14600 {
 			compatible = "marvell,orion-spi";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -166,7 +178,7 @@
 			status = "disabled";
 		};
 
-		i2c0: i2c@11000 {
+		i2c0: i2c-ctrl@11000 {
 			compatible = "marvell,mv64xxx-i2c";
 			reg = <0x11000 0x20>;
 			#address-cells = <1>;
@@ -194,7 +206,7 @@
 			status = "okay";
 		};
 
-		sdio0: sdio@92000 {
+		sdio0: sdio-host@92000 {
 			compatible = "marvell,dove-sdhci";
 			reg = <0x92000 0x100>;
 			interrupts = <35>, <37>;
@@ -202,7 +214,7 @@
 			status = "disabled";
 		};
 
-		sdio1: sdio@90000 {
+		sdio1: sdio-host@90000 {
 			compatible = "marvell,dove-sdhci";
 			reg = <0x90000 0x100>;
 			interrupts = <36>, <38>;
@@ -210,7 +222,7 @@
 			status = "disabled";
 		};
 
-		sata0: sata@a0000 {
+		sata0: sata-host@a0000 {
 			compatible = "marvell,orion-sata";
 			reg = <0xa0000 0x2400>;
 			interrupts = <62>;
@@ -219,12 +231,12 @@
 			status = "disabled";
 		};
 
-		rtc@d8500 {
+		rtc: real-time-clock@d8500 {
 			compatible = "marvell,orion-rtc";
 			reg = <0xd8500 0x20>;
 		};
 
-		crypto: crypto@30000 {
+		crypto: crypto-engine@30000 {
 			compatible = "marvell,orion-crypto";
 			reg = <0x30000 0x10000>,
 			      <0xc8000000 0x800>;
@@ -291,7 +303,7 @@
 			};
 		};
 
-		eth: ethernet-controller@72000 {
+		eth: ethernet-ctrl@72000 {
 			compatible = "marvell,orion-eth";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.7.10.4

