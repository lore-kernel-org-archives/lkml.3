Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBOXdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:33:54 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:54640 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaBOXdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:33:46 -0500
Subject: [PATCH v6 5/8] ARM: dts: sun7i: Add support for mmc
To: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?utf-8?b?TMOzcGV6?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Date: Sun, 16 Feb 2014 00:33:42 +0100
Message-ID: <20140215233342.30460.88486.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20140215233011.30460.27261.stgit@dizzy-6.o2s.ch>
References: <20140215233011.30460.27261.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     |    8 +++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts      |    8 +++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   23 +++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi                |   61 +++++++++++++++++++++++
 4 files changed, 100 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
index 5c51cb8..ae800b6 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -34,6 +34,14 @@
 			};
 		};
 
+		mmc0: mmc@01c0f000 {
+			pinctrl-names = "default", "default";
+			pinctrl-0 = <&mmc0_pins_a>;
+			pinctrl-1 = <&mmc0_cd_pin_reference_design>;
+			cd-gpios = <&pio 7 1 0>; /* PH1 */
+			status = "okay";
+		};
+
 		pinctrl@01c20800 {
 			led_pins_cubieboard2: led_pins@0 {
 				allwinner,pins = "PH20", "PH21";
diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index f9dcb61..370cef84 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -19,6 +19,14 @@
 	compatible = "cubietech,cubietruck", "allwinner,sun7i-a20";
 
 	soc@01c00000 {
+		mmc0: mmc@01c0f000 {
+			pinctrl-names = "default", "default";
+			pinctrl-0 = <&mmc0_pins_a>;
+			pinctrl-1 = <&mmc0_cd_pin_reference_design>;
+			cd-gpios = <&pio 7 1 0>; /* PH1 */
+			status = "okay";
+		};
+
 		pinctrl@01c20800 {
 			led_pins_cubietruck: led_pins@0 {
 				allwinner,pins = "PH7", "PH11", "PH20", "PH21";
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
index ead3013..685ec06 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -34,7 +34,30 @@
 			};
 		};
 
+		mmc0: mmc@01c0f000 {
+			pinctrl-names = "default", "default";
+			pinctrl-0 = <&mmc0_pins_a>;
+			pinctrl-1 = <&mmc0_cd_pin_reference_design>;
+			cd-gpios = <&pio 7 1 0>; /* PH1 */
+			status = "okay";
+		};
+
+		mmc3: mmc@01c12000 {
+			pinctrl-names = "default", "default";
+			pinctrl-0 = <&mmc3_pins_a>;
+			pinctrl-1 = <&mmc3_cd_pin_olinuxinom>;
+			cd-gpios = <&pio 7 11 0>; /* PH11 */
+			status = "okay";
+		};
+
 		pinctrl@01c20800 {
+			mmc3_cd_pin_olinuxinom: mmc3_cd_pin@0 {
+				allwinner,pins = "PH11";
+				allwinner,function = "gpio_in";
+				allwinner,drive = <0>;
+				allwinner,pull = <1>;
+			};
+
 			led_pins_olinuxino: led_pins@0 {
 				allwinner,pins = "PH2";
 				allwinner,function = "gpio_out";
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 9ff0948..5b55414 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -355,6 +355,46 @@
 			#size-cells = <0>;
 		};
 
+		mmc0: mmc@01c0f000 {
+			compatible = "allwinner,sun5i-a13-mmc";
+			reg = <0x01c0f000 0x1000>;
+			clocks = <&ahb_gates 8>, <&mmc0_clk>;
+			clock-names = "ahb", "mod";
+			interrupts = <0 32 4>;
+			bus-width = <4>;
+			status = "disabled";
+		};
+
+		mmc1: mmc@01c10000 {
+			compatible = "allwinner,sun5i-a13-mmc";
+			reg = <0x01c10000 0x1000>;
+			clocks = <&ahb_gates 9>, <&mmc1_clk>;
+			clock-names = "ahb", "mod";
+			interrupts = <0 33 4>;
+			bus-width = <4>;
+			status = "disabled";
+		};
+
+		mmc2: mmc@01c11000 {
+			compatible = "allwinner,sun5i-a13-mmc";
+			reg = <0x01c11000 0x1000>;
+			clocks = <&ahb_gates 10>, <&mmc2_clk>;
+			clock-names = "ahb", "mod";
+			interrupts = <0 34 4>;
+			bus-width = <4>;
+			status = "disabled";
+		};
+
+		mmc3: mmc@01c12000 {
+			compatible = "allwinner,sun5i-a13-mmc";
+			reg = <0x01c12000 0x1000>;
+			clocks = <&ahb_gates 11>, <&mmc3_clk>;
+			clock-names = "ahb", "mod";
+			interrupts = <0 35 4>;
+			bus-width = <4>;
+			status = "disabled";
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun7i-a20-pinctrl";
 			reg = <0x01c20800 0x400>;
@@ -432,6 +472,27 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			mmc0_pins_a: mmc0@0 {
+				allwinner,pins = "PF0","PF1","PF2","PF3","PF4","PF5";
+				allwinner,function = "mmc0";
+				allwinner,drive = <3>;
+				allwinner,pull = <0>;
+			};
+
+			mmc0_cd_pin_reference_design: mmc0_cd_pin@0 {
+				allwinner,pins = "PH1";
+				allwinner,function = "gpio_in";
+				allwinner,drive = <0>;
+				allwinner,pull = <1>;
+			};
+
+			mmc3_pins_a: mmc3@0 {
+				allwinner,pins = "PI4","PI5","PI6","PI7","PI8","PI9";
+				allwinner,function = "mmc3";
+				allwinner,drive = <3>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {

