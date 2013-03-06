Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3CFS3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:29:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37755 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3CFS2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:28:55 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 6/6] ARM: tegra: convert device tree files to use IRQ defines
Date: Wed,  6 Mar 2013 11:28:37 -0700
Message-Id: <1362594517-22099-6-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
References: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Use the GIC and standard IRQ binding defines in all IRQ specifiers.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra114.dtsi            |   55 +++++----
 arch/arm/boot/dts/tegra20-colibri-512.dtsi |    2 +-
 arch/arm/boot/dts/tegra20-harmony.dts      |    4 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts  |    2 +-
 arch/arm/boot/dts/tegra20-paz00.dts        |    4 +-
 arch/arm/boot/dts/tegra20-plutux.dts       |    2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts     |   10 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi    |    2 +-
 arch/arm/boot/dts/tegra20-tec.dts          |    2 +-
 arch/arm/boot/dts/tegra20-ventana.dts      |    6 +-
 arch/arm/boot/dts/tegra20-whistler.dts     |    2 +-
 arch/arm/boot/dts/tegra20.dtsi             |  138 +++++++++++-----------
 arch/arm/boot/dts/tegra30-beaver.dts       |    2 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi      |    6 +-
 arch/arm/boot/dts/tegra30.dtsi             |  174 ++++++++++++++--------------
 15 files changed, 211 insertions(+), 200 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 116a1b1..5e268be 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -1,4 +1,5 @@
 #include <dt-bindings/gpio/tegra-gpio.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
 
@@ -14,18 +15,19 @@
 		      <0x50042000 0x1000>,
 		      <0x50044000 0x2000>,
 		      <0x50046000 0x2000>;
-		interrupts = <1 9 0xf04>;
+		interrupts = <GIC_PPI 9
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 	};
 
 	timer@60005000 {
 		compatible = "nvidia,tegra114-timer", "nvidia,tegra20-timer";
 		reg = <0x60005000 0x400>;
-		interrupts = <0 0 0x04
-			      0 1 0x04
-			      0 41 0x04
-			      0 42 0x04
-			      0 121 0x04
-			      0 122 0x04>;
+		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	tegra_car: clock {
@@ -42,14 +44,14 @@
 	gpio: gpio {
 		compatible = "nvidia,tegra114-gpio", "nvidia,tegra30-gpio";
 		reg = <0x6000d000 0x1000>;
-		interrupts = <0 32 0x04
-			      0 33 0x04
-			      0 34 0x04
-			      0 35 0x04
-			      0 55 0x04
-			      0 87 0x04
-			      0 89 0x04
-			      0 125 0x04>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
 		#gpio-cells = <2>;
 		gpio-controller;
 		#interrupt-cells = <2>;
@@ -66,7 +68,7 @@
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
-		interrupts = <0 36 0x04>;
+		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
@@ -74,7 +76,7 @@
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
-		interrupts = <0 37 0x04>;
+		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
@@ -82,7 +84,7 @@
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 46 0x04>;
+		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
@@ -90,14 +92,14 @@
 		compatible = "nvidia,tegra114-uart", "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 90 0x04>;
+		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
 	rtc {
 		compatible = "nvidia,tegra114-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
-		interrupts = <0 2 0x04>;
+		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	pmc {
@@ -147,9 +149,14 @@
 
 	timer {
 		compatible = "arm,armv7-timer";
-		interrupts = <1 13 0xf08>,
-			     <1 14 0xf08>,
-			     <1 11 0xf08>,
-			     <1 10 0xf08>;
+		interrupts =
+			<GIC_PPI 13
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			<GIC_PPI 14
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			<GIC_PPI 11
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			<GIC_PPI 10
+				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index d393f7a..af2b341 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -218,7 +218,7 @@
 		pmic: tps6586x@34 {
 			compatible = "ti,tps6586x";
 			reg = <0x34>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			ti,system-power-controller;
 
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 746071f..6d6b5e5 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -263,7 +263,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -291,7 +291,7 @@
 		pmic: tps6586x@34 {
 			compatible = "ti,tps6586x";
 			reg = <0x34>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			ti,system-power-controller;
 
diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 4ba8638..edd617d 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -11,7 +11,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 40c916b..5c6e06d 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -271,7 +271,7 @@
 	nvec {
 		compatible = "nvidia,nvec";
 		reg = <0x7000c500 0x100>;
-		interrupts = <0 92 0x04>;
+		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clock-frequency = <80000>;
@@ -288,7 +288,7 @@
 		pmic: tps6586x@34 {
 			compatible = "ti,tps6586x";
 			reg = <0x34>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			#gpio-cells = <2>;
 			gpio-controller;
diff --git a/arch/arm/boot/dts/tegra20-plutux.dts b/arch/arm/boot/dts/tegra20-plutux.dts
index a26d487..769f188 100644
--- a/arch/arm/boot/dts/tegra20-plutux.dts
+++ b/arch/arm/boot/dts/tegra20-plutux.dts
@@ -17,7 +17,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index c5d3ffa..2b40132 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -314,7 +314,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -329,14 +329,14 @@
 			compatible = "isil,isl29018";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(Z, 2) 0x04>;
+			interrupts = <TEGRA_GPIO(Z, 2) IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		gyrometer@68 {
 			compatible = "invn,mpu3050";
 			reg = <0x68>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(Z, 4) 0x04>;
+			interrupts = <TEGRA_GPIO(Z, 4) IRQ_TYPE_LEVEL_HIGH>;
 		};
 	};
 
@@ -389,7 +389,7 @@
 		pmic: tps6586x@34 {
 			compatible = "ti,tps6586x";
 			reg = <0x34>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			ti,system-power-controller;
 
@@ -512,7 +512,7 @@
 			compatible = "ak,ak8975";
 			reg = <0xc>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(N, 5) 0x04>;
+			interrupts = <TEGRA_GPIO(N, 5) IRQ_TYPE_LEVEL_HIGH>;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 4ea5c90..de1c022 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -322,7 +322,7 @@
 		pmic: tps6586x@34 {
 			compatible = "ti,tps6586x";
 			reg = <0x34>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			ti,system-power-controller;
 
diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 6542806..5f554df 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -17,7 +17,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index ba746b8..c9d7516 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -311,7 +311,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -326,7 +326,7 @@
 			compatible = "isil,isl29018";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(Z, 2) 0x04>;
+			interrupts = <TEGRA_GPIO(Z, 2) IRQ_TYPE_LEVEL_HIGH>;
 		};
 	};
 
@@ -372,7 +372,7 @@
 		pmic: tps6586x@34 {
 			compatible = "ti,tps6586x";
 			reg = <0x34>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			ti,system-power-controller;
 
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index 867722c..366f147 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -282,7 +282,7 @@
 		max8907@3c {
 			compatible = "maxim,max8907";
 			reg = <0x3c>;
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 
 			maxim,system-power-controller;
 
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 5d30e10..c0ddba0 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -1,4 +1,5 @@
 #include <dt-bindings/gpio/tegra-gpio.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
 
@@ -17,8 +18,8 @@
 	host1x {
 		compatible = "nvidia,tegra20-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
-		interrupts = <0 65 0x04   /* mpcore syncpt */
-			      0 67 0x04>; /* mpcore general */
+		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
+			     <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
 		clocks = <&tegra_car 28>;
 
 		#address-cells = <1>;
@@ -29,35 +30,35 @@
 		mpe {
 			compatible = "nvidia,tegra20-mpe";
 			reg = <0x54040000 0x00040000>;
-			interrupts = <0 68 0x04>;
+			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 60>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra20-vi";
 			reg = <0x54080000 0x00040000>;
-			interrupts = <0 69 0x04>;
+			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 100>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra20-epp";
 			reg = <0x540c0000 0x00040000>;
-			interrupts = <0 70 0x04>;
+			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 19>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra20-isp";
 			reg = <0x54100000 0x00040000>;
-			interrupts = <0 71 0x04>;
+			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 23>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra20-gr2d";
 			reg = <0x54140000 0x00040000>;
-			interrupts = <0 72 0x04>;
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 21>;
 		};
 
@@ -70,7 +71,7 @@
 		dc@54200000 {
 			compatible = "nvidia,tegra20-dc";
 			reg = <0x54200000 0x00040000>;
-			interrupts = <0 73 0x04>;
+			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 27>, <&tegra_car 121>;
 			clock-names = "disp1", "parent";
 
@@ -82,7 +83,7 @@
 		dc@54240000 {
 			compatible = "nvidia,tegra20-dc";
 			reg = <0x54240000 0x00040000>;
-			interrupts = <0 74 0x04>;
+			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 26>, <&tegra_car 121>;
 			clock-names = "disp2", "parent";
 
@@ -94,7 +95,7 @@
 		hdmi {
 			compatible = "nvidia,tegra20-hdmi";
 			reg = <0x54280000 0x00040000>;
-			interrupts = <0 75 0x04>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 51>, <&tegra_car 117>;
 			clock-names = "hdmi", "parent";
 			status = "disabled";
@@ -103,7 +104,7 @@
 		tvo {
 			compatible = "nvidia,tegra20-tvo";
 			reg = <0x542c0000 0x00040000>;
-			interrupts = <0 76 0x04>;
+			interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 102>;
 			status = "disabled";
 		};
@@ -119,7 +120,8 @@
 	timer@50004600 {
 		compatible = "arm,cortex-a9-twd-timer";
 		reg = <0x50040600 0x20>;
-		interrupts = <1 13 0x304>;
+		interrupts = <GIC_PPI 13
+			(GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_HIGH)>;
 		clocks = <&tegra_car 132>;
 	};
 
@@ -143,10 +145,10 @@
 	timer@60005000 {
 		compatible = "nvidia,tegra20-timer";
 		reg = <0x60005000 0x60>;
-		interrupts = <0 0 0x04
-			      0 1 0x04
-			      0 41 0x04
-			      0 42 0x04>;
+		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	tegra_car: clock {
@@ -158,22 +160,22 @@
 	apbdma: dma {
 		compatible = "nvidia,tegra20-apbdma";
 		reg = <0x6000a000 0x1200>;
-		interrupts = <0 104 0x04
-			      0 105 0x04
-			      0 106 0x04
-			      0 107 0x04
-			      0 108 0x04
-			      0 109 0x04
-			      0 110 0x04
-			      0 111 0x04
-			      0 112 0x04
-			      0 113 0x04
-			      0 114 0x04
-			      0 115 0x04
-			      0 116 0x04
-			      0 117 0x04
-			      0 118 0x04
-			      0 119 0x04>;
+		interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 34>;
 	};
 
@@ -185,13 +187,13 @@
 	gpio: gpio {
 		compatible = "nvidia,tegra20-gpio";
 		reg = <0x6000d000 0x1000>;
-		interrupts = <0 32 0x04
-			      0 33 0x04
-			      0 34 0x04
-			      0 35 0x04
-			      0 55 0x04
-			      0 87 0x04
-			      0 89 0x04>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 		#gpio-cells = <2>;
 		gpio-controller;
 		#interrupt-cells = <2>;
@@ -214,7 +216,7 @@
 	tegra_ac97: ac97 {
 		compatible = "nvidia,tegra20-ac97";
 		reg = <0x70002000 0x200>;
-		interrupts = <0 81 0x04>;
+		interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 12>;
 		clocks = <&tegra_car 3>;
 		status = "disabled";
@@ -223,7 +225,7 @@
 	tegra_i2s1: i2s@70002800 {
 		compatible = "nvidia,tegra20-i2s";
 		reg = <0x70002800 0x200>;
-		interrupts = <0 13 0x04>;
+		interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 2>;
 		clocks = <&tegra_car 11>;
 		status = "disabled";
@@ -232,7 +234,7 @@
 	tegra_i2s2: i2s@70002a00 {
 		compatible = "nvidia,tegra20-i2s";
 		reg = <0x70002a00 0x200>;
-		interrupts = <0 3 0x04>;
+		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 1>;
 		clocks = <&tegra_car 18>;
 		status = "disabled";
@@ -249,7 +251,7 @@
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
-		interrupts = <0 36 0x04>;
+		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 8>;
 		clocks = <&tegra_car 6>;
 		status = "disabled";
@@ -259,7 +261,7 @@
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
-		interrupts = <0 37 0x04>;
+		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
 		clocks = <&tegra_car 96>;
 		status = "disabled";
@@ -269,7 +271,7 @@
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 46 0x04>;
+		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
 		clocks = <&tegra_car 55>;
 		status = "disabled";
@@ -279,7 +281,7 @@
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 90 0x04>;
+		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
 		clocks = <&tegra_car 65>;
 		status = "disabled";
@@ -289,7 +291,7 @@
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 91 0x04>;
+		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
 		clocks = <&tegra_car 66>;
 		status = "disabled";
@@ -305,13 +307,13 @@
 	rtc {
 		compatible = "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
-		interrupts = <0 2 0x04>;
+		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	i2c@7000c000 {
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000c000 0x100>;
-		interrupts = <0 38 0x04>;
+		interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 12>, <&tegra_car 124>;
@@ -322,7 +324,7 @@
 	spi@7000c380 {
 		compatible = "nvidia,tegra20-sflash";
 		reg = <0x7000c380 0x80>;
-		interrupts = <0 39 0x04>;
+		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 11>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -333,7 +335,7 @@
 	i2c@7000c400 {
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000c400 0x100>;
-		interrupts = <0 84 0x04>;
+		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 54>, <&tegra_car 124>;
@@ -344,7 +346,7 @@
 	i2c@7000c500 {
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000c500 0x100>;
-		interrupts = <0 92 0x04>;
+		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 67>, <&tegra_car 124>;
@@ -355,7 +357,7 @@
 	i2c@7000d000 {
 		compatible = "nvidia,tegra20-i2c-dvc";
 		reg = <0x7000d000 0x200>;
-		interrupts = <0 53 0x04>;
+		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 47>, <&tegra_car 124>;
@@ -366,7 +368,7 @@
 	spi@7000d400 {
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d400 0x200>;
-		interrupts = <0 59 0x04>;
+		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 15>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -377,7 +379,7 @@
 	spi@7000d600 {
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d600 0x200>;
-		interrupts = <0 82 0x04>;
+		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 16>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -388,7 +390,7 @@
 	spi@7000d800 {
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000d480 0x200>;
-		interrupts = <0 83 0x04>;
+		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -399,7 +401,7 @@
 	spi@7000da00 {
 		compatible = "nvidia,tegra20-slink";
 		reg = <0x7000da00 0x200>;
-		interrupts = <0 93 0x04>;
+		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 18>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -410,7 +412,7 @@
 	kbc {
 		compatible = "nvidia,tegra20-kbc";
 		reg = <0x7000e200 0x100>;
-		interrupts = <0 85 0x04>;
+		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 36>;
 		status = "disabled";
 	};
@@ -424,7 +426,7 @@
 		compatible = "nvidia,tegra20-mc";
 		reg = <0x7000f000 0x024
 		       0x7000f03c 0x3c4>;
-		interrupts = <0 77 0x04>;
+		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	iommu {
@@ -443,7 +445,7 @@
 	usb@c5000000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
 		reg = <0xc5000000 0x4000>;
-		interrupts = <0 20 0x04>;
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
 		phy_type = "utmi";
 		nvidia,has-legacy-mode;
 		clocks = <&tegra_car 22>;
@@ -464,7 +466,7 @@
 	usb@c5004000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
 		reg = <0xc5004000 0x4000>;
-		interrupts = <0 21 0x04>;
+		interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
 		phy_type = "ulpi";
 		clocks = <&tegra_car 58>;
 		nvidia,phy = <&phy2>;
@@ -482,7 +484,7 @@
 	usb@c5008000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
 		reg = <0xc5008000 0x4000>;
-		interrupts = <0 97 0x04>;
+		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 		phy_type = "utmi";
 		clocks = <&tegra_car 59>;
 		nvidia,phy = <&phy3>;
@@ -500,7 +502,7 @@
 	sdhci@c8000000 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000000 0x200>;
-		interrupts = <0 14 0x04>;
+		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 14>;
 		status = "disabled";
 	};
@@ -508,7 +510,7 @@
 	sdhci@c8000200 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000200 0x200>;
-		interrupts = <0 15 0x04>;
+		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 9>;
 		status = "disabled";
 	};
@@ -516,7 +518,7 @@
 	sdhci@c8000400 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000400 0x200>;
-		interrupts = <0 19 0x04>;
+		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 69>;
 		status = "disabled";
 	};
@@ -524,7 +526,7 @@
 	sdhci@c8000600 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000600 0x200>;
-		interrupts = <0 31 0x04>;
+		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 15>;
 		status = "disabled";
 	};
@@ -548,7 +550,7 @@
 
 	pmu {
 		compatible = "arm,cortex-a9-pmu";
-		interrupts = <0 56 0x04
-			      0 57 0x04>;
+		interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 6a52822..e350c67 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -133,7 +133,7 @@
 			compatible = "ti,tps65911";
 			reg = <0x2d>;
 
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index ac1bb88..b3de6a3 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -146,7 +146,7 @@
 			compatible = "isil,isl29028";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(L, 0) 0x04>;
+			interrupts = <TEGRA_GPIO(L, 0) IRQ_TYPE_LEVEL_HIGH>;
 		};
 	};
 
@@ -163,7 +163,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(W, 3) 0x04>;
+			interrupts = <TEGRA_GPIO(W, 3) IRQ_TYPE_LEVEL_HIGH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -190,7 +190,7 @@
 			compatible = "ti,tps65911";
 			reg = <0x2d>;
 
-			interrupts = <0 86 0x4>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 94b8cf4..ed4f140 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -1,4 +1,5 @@
 #include <dt-bindings/gpio/tegra-gpio.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
 
@@ -17,8 +18,8 @@
 	host1x {
 		compatible = "nvidia,tegra30-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
-		interrupts = <0 65 0x04   /* mpcore syncpt */
-			      0 67 0x04>; /* mpcore general */
+		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>, /* syncpt */
+			     <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>; /* general */
 		clocks = <&tegra_car 28>;
 
 		#address-cells = <1>;
@@ -29,35 +30,35 @@
 		mpe {
 			compatible = "nvidia,tegra30-mpe";
 			reg = <0x54040000 0x00040000>;
-			interrupts = <0 68 0x04>;
+			interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 60>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra30-vi";
 			reg = <0x54080000 0x00040000>;
-			interrupts = <0 69 0x04>;
+			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 164>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra30-epp";
 			reg = <0x540c0000 0x00040000>;
-			interrupts = <0 70 0x04>;
+			interrupts = <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 19>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra30-isp";
 			reg = <0x54100000 0x00040000>;
-			interrupts = <0 71 0x04>;
+			interrupts = <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 23>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra30-gr2d";
 			reg = <0x54140000 0x00040000>;
-			interrupts = <0 72 0x04>;
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 21>;
 		};
 
@@ -71,7 +72,7 @@
 		dc@54200000 {
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54200000 0x00040000>;
-			interrupts = <0 73 0x04>;
+			interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 27>, <&tegra_car 179>;
 			clock-names = "disp1", "parent";
 
@@ -83,7 +84,7 @@
 		dc@54240000 {
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54240000 0x00040000>;
-			interrupts = <0 74 0x04>;
+			interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 26>, <&tegra_car 179>;
 			clock-names = "disp2", "parent";
 
@@ -95,7 +96,7 @@
 		hdmi {
 			compatible = "nvidia,tegra30-hdmi";
 			reg = <0x54280000 0x00040000>;
-			interrupts = <0 75 0x04>;
+			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 51>, <&tegra_car 189>;
 			clock-names = "hdmi", "parent";
 			status = "disabled";
@@ -104,7 +105,7 @@
 		tvo {
 			compatible = "nvidia,tegra30-tvo";
 			reg = <0x542c0000 0x00040000>;
-			interrupts = <0 76 0x04>;
+			interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&tegra_car 169>;
 			status = "disabled";
 		};
@@ -120,7 +121,8 @@
 	timer@50004600 {
 		compatible = "arm,cortex-a9-twd-timer";
 		reg = <0x50040600 0x20>;
-		interrupts = <1 13 0xf04>;
+		interrupts = <GIC_PPI 13
+			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		clocks = <&tegra_car 214>;
 	};
 
@@ -144,12 +146,12 @@
 	timer@60005000 {
 		compatible = "nvidia,tegra30-timer", "nvidia,tegra20-timer";
 		reg = <0x60005000 0x400>;
-		interrupts = <0 0 0x04
-			      0 1 0x04
-			      0 41 0x04
-			      0 42 0x04
-			      0 121 0x04
-			      0 122 0x04>;
+		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	tegra_car: clock {
@@ -161,38 +163,38 @@
 	apbdma: dma {
 		compatible = "nvidia,tegra30-apbdma", "nvidia,tegra20-apbdma";
 		reg = <0x6000a000 0x1400>;
-		interrupts = <0 104 0x04
-			      0 105 0x04
-			      0 106 0x04
-			      0 107 0x04
-			      0 108 0x04
-			      0 109 0x04
-			      0 110 0x04
-			      0 111 0x04
-			      0 112 0x04
-			      0 113 0x04
-			      0 114 0x04
-			      0 115 0x04
-			      0 116 0x04
-			      0 117 0x04
-			      0 118 0x04
-			      0 119 0x04
-			      0 128 0x04
-			      0 129 0x04
-			      0 130 0x04
-			      0 131 0x04
-			      0 132 0x04
-			      0 133 0x04
-			      0 134 0x04
-			      0 135 0x04
-			      0 136 0x04
-			      0 137 0x04
-			      0 138 0x04
-			      0 139 0x04
-			      0 140 0x04
-			      0 141 0x04
-			      0 142 0x04
-			      0 143 0x04>;
+		interrupts = <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 132 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 34>;
 	};
 
@@ -204,14 +206,14 @@
 	gpio: gpio {
 		compatible = "nvidia,tegra30-gpio";
 		reg = <0x6000d000 0x1000>;
-		interrupts = <0 32 0x04
-			      0 33 0x04
-			      0 34 0x04
-			      0 35 0x04
-			      0 55 0x04
-			      0 87 0x04
-			      0 89 0x04
-			      0 125 0x04>;
+		interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
 		#gpio-cells = <2>;
 		gpio-controller;
 		#interrupt-cells = <2>;
@@ -236,7 +238,7 @@
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
-		interrupts = <0 36 0x04>;
+		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 8>;
 		clocks = <&tegra_car 6>;
 		status = "disabled";
@@ -246,7 +248,7 @@
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
-		interrupts = <0 37 0x04>;
+		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 9>;
 		clocks = <&tegra_car 160>;
 		status = "disabled";
@@ -256,7 +258,7 @@
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 46 0x04>;
+		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 10>;
 		clocks = <&tegra_car 55>;
 		status = "disabled";
@@ -266,7 +268,7 @@
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 90 0x04>;
+		interrupts = <GIC_SPI 90 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 19>;
 		clocks = <&tegra_car 65>;
 		status = "disabled";
@@ -276,7 +278,7 @@
 		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
-		interrupts = <0 91 0x04>;
+		interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 20>;
 		clocks = <&tegra_car 66>;
 		status = "disabled";
@@ -292,13 +294,13 @@
 	rtc {
 		compatible = "nvidia,tegra30-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
-		interrupts = <0 2 0x04>;
+		interrupts = <GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	i2c@7000c000 {
 		compatible =  "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
 		reg = <0x7000c000 0x100>;
-		interrupts = <0 38 0x04>;
+		interrupts = <GIC_SPI 38 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 12>, <&tegra_car 182>;
@@ -309,7 +311,7 @@
 	i2c@7000c400 {
 		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
 		reg = <0x7000c400 0x100>;
-		interrupts = <0 84 0x04>;
+		interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 54>, <&tegra_car 182>;
@@ -320,7 +322,7 @@
 	i2c@7000c500 {
 		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
 		reg = <0x7000c500 0x100>;
-		interrupts = <0 92 0x04>;
+		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 67>, <&tegra_car 182>;
@@ -331,7 +333,7 @@
 	i2c@7000c700 {
 		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
 		reg = <0x7000c700 0x100>;
-		interrupts = <0 120 0x04>;
+		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 103>, <&tegra_car 182>;
@@ -342,7 +344,7 @@
 	i2c@7000d000 {
 		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
 		reg = <0x7000d000 0x100>;
-		interrupts = <0 53 0x04>;
+		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&tegra_car 47>, <&tegra_car 182>;
@@ -353,7 +355,7 @@
 	spi@7000d400 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000d400 0x200>;
-		interrupts = <0 59 0x04>;
+		interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 15>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -364,7 +366,7 @@
 	spi@7000d600 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000d600 0x200>;
-		interrupts = <0 82 0x04>;
+		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 16>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -375,7 +377,7 @@
 	spi@7000d800 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000d480 0x200>;
-		interrupts = <0 83 0x04>;
+		interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -386,7 +388,7 @@
 	spi@7000da00 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000da00 0x200>;
-		interrupts = <0 93 0x04>;
+		interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 18>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -397,7 +399,7 @@
 	spi@7000dc00 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000dc00 0x200>;
-		interrupts = <0 94 0x04>;
+		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 27>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -408,7 +410,7 @@
 	spi@7000de00 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
 		reg = <0x7000de00 0x200>;
-		interrupts = <0 79 0x04>;
+		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 28>;
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -419,7 +421,7 @@
 	kbc {
 		compatible = "nvidia,tegra30-kbc", "nvidia,tegra20-kbc";
 		reg = <0x7000e200 0x100>;
-		interrupts = <0 85 0x04>;
+		interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 36>;
 		status = "disabled";
 	};
@@ -435,7 +437,7 @@
 		       0x7000f03c 0x1b4
 		       0x7000f200 0x028
 		       0x7000f284 0x17c>;
-		interrupts = <0 77 0x04>;
+		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
 	iommu {
@@ -452,7 +454,7 @@
 		compatible = "nvidia,tegra30-ahub";
 		reg = <0x70080000 0x200
 		       0x70080200 0x100>;
-		interrupts = <0 103 0x04>;
+		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
 		nvidia,dma-request-selector = <&apbdma 1>;
 		clocks = <&tegra_car 106>, <&tegra_car 107>, <&tegra_car 30>,
 			 <&tegra_car 11>, <&tegra_car 18>, <&tegra_car 101>,
@@ -509,7 +511,7 @@
 	sdhci@78000000 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000000 0x200>;
-		interrupts = <0 14 0x04>;
+		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 14>;
 		status = "disabled";
 	};
@@ -517,7 +519,7 @@
 	sdhci@78000200 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000200 0x200>;
-		interrupts = <0 15 0x04>;
+		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 9>;
 		status = "disabled";
 	};
@@ -525,7 +527,7 @@
 	sdhci@78000400 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000400 0x200>;
-		interrupts = <0 19 0x04>;
+		interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 69>;
 		status = "disabled";
 	};
@@ -533,7 +535,7 @@
 	sdhci@78000600 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000600 0x200>;
-		interrupts = <0 31 0x04>;
+		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&tegra_car 15>;
 		status = "disabled";
 	};
@@ -569,9 +571,9 @@
 
 	pmu {
 		compatible = "arm,cortex-a9-pmu";
-		interrupts = <0 144 0x04
-			      0 145 0x04
-			      0 146 0x04
-			      0 147 0x04>;
+		interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 145 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 146 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
 	};
 };
-- 
1.7.10.4

