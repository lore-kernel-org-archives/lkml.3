Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab3CFS24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:28:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56604 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3CFS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:28:53 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 5/6] ARM: tegra: convert device tree files to use GPIO defines
Date: Wed,  6 Mar 2013 11:28:36 -0700
Message-Id: <1362594517-22099-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
References: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Use TEGRA_GPIO() macro to name all GPIOs referenced by GPIO properties,
and some interrupts properties. Use standard GPIO flag defines too.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Move addition of #include of tegra-gpio.h into this patch.
---
 arch/arm/boot/dts/tegra114.dtsi            |    2 ++
 arch/arm/boot/dts/tegra20-colibri-512.dtsi |   16 ++++++++-----
 arch/arm/boot/dts/tegra20-harmony.dts      |   36 ++++++++++++++++------------
 arch/arm/boot/dts/tegra20-iris-512.dts     |    2 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts  |    4 ++--
 arch/arm/boot/dts/tegra20-paz00.dts        |   24 +++++++++++--------
 arch/arm/boot/dts/tegra20-plutux.dts       |    4 ++--
 arch/arm/boot/dts/tegra20-seaboard.dts     |   33 +++++++++++++------------
 arch/arm/boot/dts/tegra20-tamonten.dtsi    |    7 +++---
 arch/arm/boot/dts/tegra20-tec.dts          |    5 ++--
 arch/arm/boot/dts/tegra20-trimslice.dts    |   17 +++++++------
 arch/arm/boot/dts/tegra20-ventana.dts      |   33 ++++++++++++++-----------
 arch/arm/boot/dts/tegra20-whistler.dts     |    5 ++--
 arch/arm/boot/dts/tegra20.dtsi             |    2 ++
 arch/arm/boot/dts/tegra30-beaver.dts       |   14 +++++------
 arch/arm/boot/dts/tegra30-cardhu-a02.dts   |    8 +++----
 arch/arm/boot/dts/tegra30-cardhu-a04.dts   |   10 ++++----
 arch/arm/boot/dts/tegra30-cardhu.dtsi      |   35 ++++++++++++++-------------
 arch/arm/boot/dts/tegra30.dtsi             |    2 ++
 19 files changed, 147 insertions(+), 112 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index d2150f0..116a1b1 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -1,3 +1,5 @@
+#include <dt-bindings/gpio/tegra-gpio.h>
+
 #include "skeleton.dtsi"
 
 / {
diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index d77252c..d393f7a 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -14,7 +14,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&i2c_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -434,17 +435,20 @@
 
 	ac97: ac97 {
 		status = "okay";
-		nvidia,codec-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
-		nvidia,codec-sync-gpio = <&gpio 120 0>; /* gpio PP0 */
+		nvidia,codec-reset-gpio = <&gpio TEGRA_GPIO(V, 0)
+			GPIO_ACTIVE_HIGH>;
+		nvidia,codec-sync-gpio = <&gpio TEGRA_GPIO(P, 0)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	sdhci@c8000600 {
-		cd-gpios = <&gpio 23 0>; /* gpio PC7 */
+		cd-gpios = <&gpio TEGRA_GPIO(C, 7) GPIO_ACTIVE_HIGH>;
 	};
 
 	sound {
@@ -485,7 +489,7 @@
 			enable-active-high;
 			regulator-boot-on;
 			regulator-always-on;
-			gpio = <&gpio 217 0>;
+			gpio = <&gpio TEGRA_GPIO(BB, 1) GPIO_ACTIVE_HIGH>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index a4d0d78..746071f 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -18,7 +18,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -262,7 +263,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <187 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -424,7 +425,8 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5008000 {
@@ -432,22 +434,23 @@
 	};
 
 	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	sdhci@c8000200 {
 		status = "okay";
-		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
-		power-gpios = <&gpio 155 0>; /* gpio PT3 */
+		cd-gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(H, 1) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(T, 3) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
 	sdhci@c8000600 {
 		status = "okay";
-		cd-gpios = <&gpio 58 0>; /* gpio PH2 */
-		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
-		power-gpios = <&gpio 70 0>; /* gpio PI6 */
+		cd-gpios = <&gpio TEGRA_GPIO(H, 2) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(H, 3) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(I, 6) GPIO_ACTIVE_HIGH>;
 		bus-width = <8>;
 	};
 
@@ -619,7 +622,7 @@
 			regulator-name = "vdd_pnl";
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
-			gpio = <&gpio 22 0>; /* gpio PC6 */
+			gpio = <&gpio TEGRA_GPIO(C, 6) GPIO_ACTIVE_HIGH>;
 			enable-active-high;
 		};
 
@@ -629,7 +632,7 @@
 			regulator-name = "vdd_bl";
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
-			gpio = <&gpio 176 0>; /* gpio PW0 */
+			gpio = <&gpio TEGRA_GPIO(W, 0) GPIO_ACTIVE_HIGH>;
 			enable-active-high;
 		};
 	};
@@ -653,8 +656,11 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
-		nvidia,int-mic-en-gpios = <&gpio 184 0>; /*gpio PX0 */
-		nvidia,ext-mic-en-gpios = <&gpio 185 0>; /* gpio PX1 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
+			GPIO_ACTIVE_HIGH>;
+		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(X, 0)
+			GPIO_ACTIVE_HIGH>;
+		nvidia,ext-mic-en-gpios = <&gpio TEGRA_GPIO(X, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index 248f7ea..f1c5a64 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -73,7 +73,7 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-boot-on;
 			regulator-always-on;
-			gpio = <&gpio 178 0>;
+			gpio = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
 		};
 
 		vcc_sd_reg: regulator@1 {
diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 10aa386..4ba8638 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -11,7 +11,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <187 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -53,6 +53,6 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 13a2118..40c916b 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -18,7 +18,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -274,7 +275,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clock-frequency = <80000>;
-		request-gpios = <&gpio 170 0>; /* gpio PV2 */
+		request-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 		slave-addr = <138>;
 		clocks = <&tegra_car 67>, <&tegra_car 124>;
 		clock-names = "div-clk", "fast-clk";
@@ -423,7 +424,8 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 0)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5008000 {
@@ -431,14 +433,15 @@
 	};
 
 	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 0)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	sdhci@c8000000 {
 		status = "okay";
-		cd-gpios = <&gpio 173 0>; /* gpio PV5 */
-		wp-gpios = <&gpio 57 0>;  /* gpio PH1 */
-		power-gpios = <&gpio 169 0>; /* gpio PV1 */
+		cd-gpios = <&gpio TEGRA_GPIO(V, 5) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(H, 1) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(V, 1) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
@@ -452,7 +455,7 @@
 
 		power {
 			label = "Power";
-			gpios = <&gpio 79 1>; /* gpio PJ7, active low */
+			gpios = <&gpio TEGRA_GPIO(J, 7) GPIO_ACTIVE_LOW>;
 			linux,code = <116>; /* KEY_POWER */
 			gpio-key,wakeup;
 		};
@@ -463,7 +466,7 @@
 
 		wifi {
 			label = "wifi-led";
-			gpios = <&gpio 24 0>; /* gpio PD0 */
+			gpios = <&gpio TEGRA_GPIO(D, 0) GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "rfkill0";
 		};
 	};
@@ -500,6 +503,7 @@
 
 		nvidia,audio-codec = <&alc5632>;
 		nvidia,i2s-controller = <&tegra_i2s1>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
+			GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-plutux.dts b/arch/arm/boot/dts/tegra20-plutux.dts
index eca914e..a26d487 100644
--- a/arch/arm/boot/dts/tegra20-plutux.dts
+++ b/arch/arm/boot/dts/tegra20-plutux.dts
@@ -17,7 +17,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <187 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -51,6 +51,6 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 74716c9..c5d3ffa 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -18,7 +18,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -313,7 +314,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <187 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -328,14 +329,14 @@
 			compatible = "isil,isl29018";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
-			interrupts = <202 0x04>; /* GPIO PZ2 */
+			interrupts = <TEGRA_GPIO(Z, 2) 0x04>;
 		};
 
 		gyrometer@68 {
 			compatible = "invn,mpu3050";
 			reg = <0x68>;
 			interrupt-parent = <&gpio>;
-			interrupts = <204 0x04>; /* gpio PZ4 */
+			interrupts = <TEGRA_GPIO(Z, 4) 0x04>;
 		};
 	};
 
@@ -511,7 +512,7 @@
 			compatible = "ak,ak8975";
 			reg = <0xc>;
 			interrupt-parent = <&gpio>;
-			interrupts = <109 0x04>; /* gpio PN5 */
+			interrupts = <TEGRA_GPIO(N, 5) 0x04>;
 		};
 	};
 
@@ -559,13 +560,14 @@
 
 	usb@c5000000 {
 		status = "okay";
-		nvidia,vbus-gpio = <&gpio 24 0>; /* PD0 */
+		nvidia,vbus-gpio = <&gpio TEGRA_GPIO(D, 0) GPIO_ACTIVE_HIGH>;
 		dr_mode = "otg";
 	};
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5008000 {
@@ -573,20 +575,21 @@
 	};
 
 	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	sdhci@c8000000 {
 		status = "okay";
-		power-gpios = <&gpio 86 0>; /* gpio PK6 */
+		power-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
 	sdhci@c8000400 {
 		status = "okay";
-		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
-		power-gpios = <&gpio 70 0>; /* gpio PI6 */
+		cd-gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(H, 1) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(I, 6) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
@@ -600,14 +603,14 @@
 
 		power {
 			label = "Power";
-			gpios = <&gpio 170 1>; /* gpio PV2, active low */
+			gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
 			linux,code = <116>; /* KEY_POWER */
 			gpio-key,wakeup;
 		};
 
 		lid {
 			label = "Lid";
-			gpios = <&gpio 23 0>; /* gpio PC7 */
+			gpios = <&gpio TEGRA_GPIO(C, 7) GPIO_ACTIVE_HIGH>;
 			linux,input-type = <5>; /* EV_SW */
 			linux,code = <0>; /* SW_LID */
 			debounce-interval = <1>;
@@ -807,6 +810,6 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 185 0>; /* gpio PX1 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(X, 1) GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 855f65d..4ea5c90 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -14,7 +14,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -465,8 +466,8 @@
 	};
 
 	sdhci@c8000600 {
-		cd-gpios = <&gpio 58 0>; /* gpio PH2 */
-		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
+		cd-gpios = <&gpio TEGRA_GPIO(H, 2) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(H, 3) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index aaca293..6542806 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -17,7 +17,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <187 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -51,6 +51,7 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
+			GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index af2a874..c7e65d9 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -18,7 +18,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -302,12 +303,13 @@
 
 	usb@c5000000 {
 		status = "okay";
-		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
+		nvidia,vbus-gpio = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 0)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5008000 {
@@ -315,7 +317,8 @@
 	};
 
 	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 0)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	sdhci@c8000000 {
@@ -325,14 +328,14 @@
 
 	sdhci@c8000600 {
 		status = "okay";
-		cd-gpios = <&gpio 121 0>; /* gpio PP1 */
-		wp-gpios = <&gpio 122 0>; /* gpio PP2 */
+		cd-gpios = <&gpio TEGRA_GPIO(P, 1) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(P, 2) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
 	poweroff {
 		compatible = "gpio-poweroff";
-		gpios = <&gpio 191 1>; /* gpio PX7, active low */
+		gpios = <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_LOW>;
 	};
 
 	regulators {
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index b5251db..ba746b8 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -18,7 +18,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -310,7 +311,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <187 0x04>;
+			interrupts = <TEGRA_GPIO(X, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -325,7 +326,7 @@
 			compatible = "isil,isl29018";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
-			interrupts = <202 0x04>; /*gpio PZ2 */
+			interrupts = <TEGRA_GPIO(Z, 2) 0x04>;
 		};
 	};
 
@@ -501,7 +502,8 @@
 
 	usb@c5004000 {
 		status = "okay";
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	usb@c5008000 {
@@ -509,20 +511,21 @@
 	};
 
 	usb-phy@c5004400 {
-		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
+		nvidia,phy-reset-gpio = <&gpio TEGRA_GPIO(V, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 
 	sdhci@c8000000 {
 		status = "okay";
-		power-gpios = <&gpio 86 0>; /* gpio PK6 */
+		power-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
 	sdhci@c8000400 {
 		status = "okay";
-		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
-		power-gpios = <&gpio 70 0>; /* gpio PI6 */
+		cd-gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(H, 1) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(I, 6) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
@@ -570,7 +573,7 @@
 			regulator-name = "vdd_pnl";
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
-			gpio = <&gpio 22 0>; /* gpio PC6 */
+			gpio = <&gpio TEGRA_GPIO(C, 6) GPIO_ACTIVE_HIGH>;
 			enable-active-high;
 		};
 
@@ -580,7 +583,7 @@
 			regulator-name = "vdd_bl";
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
-			gpio = <&gpio 176 0>; /* gpio PW0 */
+			gpio = <&gpio TEGRA_GPIO(W, 0) GPIO_ACTIVE_HIGH>;
 			enable-active-high;
 		};
 	};
@@ -604,8 +607,10 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
-		nvidia,int-mic-en-gpios = <&gpio 184 0>; /* gpio PX0 */
-		nvidia,ext-mic-en-gpios = <&gpio 185 0>; /* gpio PX1 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2) GPIO_ACTIVE_HIGH>;
+		nvidia,int-mic-en-gpios = <&gpio TEGRA_GPIO(X, 0)
+			GPIO_ACTIVE_HIGH>;
+		nvidia,ext-mic-en-gpios = <&gpio TEGRA_GPIO(X, 1)
+			GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index f1d92c1..867722c 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -18,7 +18,8 @@
 			pll-supply = <&hdmi_pll_reg>;
 
 			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
-			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7)
+				GPIO_ACTIVE_HIGH>;
 		};
 	};
 
@@ -510,7 +511,7 @@
 
 	sdhci@c8000400 {
 		status = "okay";
-		wp-gpios = <&gpio 173 0>; /* gpio PV5 */
+		wp-gpios = <&gpio TEGRA_GPIO(V, 5) GPIO_ACTIVE_HIGH>;
 		bus-width = <8>;
 	};
 
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 0bff930..5d30e10 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -1,3 +1,5 @@
+#include <dt-bindings/gpio/tegra-gpio.h>
+
 #include "skeleton.dtsi"
 
 / {
diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 89b46c1..6a52822 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -257,9 +257,9 @@
 
 	sdhci@78000000 {
 		status = "okay";
-		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-		wp-gpios = <&gpio 155 0>; /* gpio PT3 */
-		power-gpios = <&gpio 31 0>; /* gpio PD7 */
+		cd-gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(T, 3) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(D, 7) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
@@ -316,7 +316,7 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 30 0>; /* gpio PD6 */
+			gpio = <&gpio TEGRA_GPIO(D, 6) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&vdd_5v_in_reg>;
 		};
 
@@ -327,7 +327,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 68 0>; /* GPIO PI4 */
+			gpio = <&gpio TEGRA_GPIO(I, 4) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v_in_reg>;
 		};
@@ -339,7 +339,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 63 0>; /* GPIO PH7 */
+			gpio = <&gpio TEGRA_GPIO(H, 7) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v_in_reg>;
 		};
@@ -366,7 +366,7 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 95 0>; /* gpio PL7 */
+			gpio = <&gpio TEGRA_GPIO(L, 7) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
index 814359e..1cec0a6 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a02.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -44,7 +44,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 68 0>; /* GPIO PI4 */
+			gpio = <&gpio TEGRA_GPIO(I, 4) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v0_reg>;
 		};
@@ -56,7 +56,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 63 0>; /* GPIO PH7 */
+			gpio = <&gpio TEGRA_GPIO(H, 7) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v0_reg>;
 		};
@@ -80,13 +80,13 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 83 0>; /* GPIO PK3 */
+			gpio = <&gpio TEGRA_GPIO(K, 3) GPIO_ACTIVE_HIGH>;
 		};
 	};
 
 	sdhci@78000400 {
 		status = "okay";
-		power-gpios = <&gpio 28 0>; /* gpio PD4 */
+		power-gpios = <&gpio TEGRA_GPIO(D, 4) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a04.dts b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
index 4ac31ec..5b263b7 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a04.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
@@ -44,7 +44,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 238 0>; /* GPIO PDD6 */
+			gpio = <&gpio TEGRA_GPIO(DD, 6) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v0_reg>;
 		};
@@ -56,7 +56,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 236 0>; /* GPIO PDD4 */
+			gpio = <&gpio TEGRA_GPIO(DD, 4) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v0_reg>;
 		};
@@ -80,7 +80,7 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 234 0>; /* GPIO PDD2 */
+			gpio = <&gpio TEGRA_GPIO(DD, 2) GPIO_ACTIVE_HIGH>;
 		};
 
 		vdd_bl2_reg: regulator@106 {
@@ -92,13 +92,13 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 232 0>; /* GPIO PDD0 */
+			gpio = <&gpio TEGRA_GPIO(DD, 0) GPIO_ACTIVE_HIGH>;
 		};
 	};
 
 	sdhci@78000400 {
 		status = "okay";
-		power-gpios = <&gpio 27 0>; /* gpio PD3 */
+		power-gpios = <&gpio TEGRA_GPIO(D, 3) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 51a24cc..ac1bb88 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -146,7 +146,7 @@
 			compatible = "isil,isl29028";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
-			interrupts = <88 0x04>; /*gpio PL0 */
+			interrupts = <TEGRA_GPIO(L, 0) 0x04>;
 		};
 	};
 
@@ -163,7 +163,7 @@
 			compatible = "wlf,wm8903";
 			reg = <0x1a>;
 			interrupt-parent = <&gpio>;
-			interrupts = <179 0x04>; /* gpio PW3 */
+			interrupts = <TEGRA_GPIO(W, 3) 0x04>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -311,9 +311,9 @@
 
 	sdhci@78000000 {
 		status = "okay";
-		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-		wp-gpios = <&gpio 155 0>; /* gpio PT3 */
-		power-gpios = <&gpio 31 0>; /* gpio PD7 */
+		cd-gpios = <&gpio TEGRA_GPIO(I, 5) GPIO_ACTIVE_HIGH>;
+		wp-gpios = <&gpio TEGRA_GPIO(T, 3) GPIO_ACTIVE_HIGH>;
+		power-gpios = <&gpio TEGRA_GPIO(D, 7) GPIO_ACTIVE_HIGH>;
 		bus-width = <4>;
 	};
 
@@ -343,7 +343,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			enable-active-high;
-			gpio = <&gpio 220 0>; /* gpio PBB4 */
+			gpio = <&gpio TEGRA_GPIO(BB, 4) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&vio_reg>;
 		};
 
@@ -368,7 +368,7 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 25 0>; /* gpio PD1 */
+			gpio = <&gpio TEGRA_GPIO(D, 1) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -379,7 +379,7 @@
 			regulator-min-microvolt = <3300000>;
 			regulator-max-microvolt = <3300000>;
 			enable-active-high;
-			gpio = <&gpio 30 0>; /* gpio PD6 */
+			gpio = <&gpio TEGRA_GPIO(D, 6) GPIO_ACTIVE_HIGH>;
 		};
 
 		pex_hvdd_3v3_reg: regulator@5 {
@@ -389,7 +389,7 @@
 			regulator-min-microvolt = <3300000>;
 			regulator-max-microvolt = <3300000>;
 			enable-active-high;
-			gpio = <&gpio 95 0>; /* gpio PL7 */
+			gpio = <&gpio TEGRA_GPIO(L, 7) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -400,7 +400,7 @@
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
 			enable-active-high;
-			gpio = <&gpio 142 0>; /* gpio PR6 */
+			gpio = <&gpio TEGRA_GPIO(R, 6) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -411,7 +411,7 @@
 			regulator-min-microvolt = <2800000>;
 			regulator-max-microvolt = <2800000>;
 			enable-active-high;
-			gpio = <&gpio 143 0>; /* gpio PR7 */
+			gpio = <&gpio TEGRA_GPIO(R, 7) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -422,7 +422,7 @@
 			regulator-min-microvolt = <3300000>;
 			regulator-max-microvolt = <3300000>;
 			enable-active-high;
-			gpio = <&gpio 144 0>; /* gpio PS0 */
+			gpio = <&gpio TEGRA_GPIO(S, 0) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -435,7 +435,7 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 24 0>; /* gpio PD0 */
+			gpio = <&gpio TEGRA_GPIO(D, 0) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -446,7 +446,7 @@
 			regulator-min-microvolt = <3300000>;
 			regulator-max-microvolt = <3300000>;
 			enable-active-high;
-			gpio = <&gpio 94 0>; /* gpio PL6 */
+			gpio = <&gpio TEGRA_GPIO(L, 6) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -459,7 +459,7 @@
 			regulator-always-on;
 			regulator-boot-on;
 			enable-active-high;
-			gpio = <&gpio 92 0>; /* gpio PL4 */
+			gpio = <&gpio TEGRA_GPIO(L, 4) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
 
@@ -470,7 +470,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio 152 0>; /* GPIO PT0 */
+			gpio = <&gpio TEGRA_GPIO(T, 0) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v0_reg>;
 		};
@@ -495,6 +495,7 @@
 		nvidia,audio-codec = <&wm8903>;
 
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
-		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
+		nvidia,hp-det-gpios = <&gpio TEGRA_GPIO(W, 2)
+			GPIO_ACTIVE_HIGH>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index f474b6e..94b8cf4 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -1,3 +1,5 @@
+#include <dt-bindings/gpio/tegra-gpio.h>
+
 #include "skeleton.dtsi"
 
 / {
-- 
1.7.10.4

