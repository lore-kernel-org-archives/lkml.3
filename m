Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3GQQGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:06:06 -0400
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:58697 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab3GQQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:06:04 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Genoud <richard.genoud@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 33/42] ARM: at91/dt: move at91sam9x5 SoCs to new at91 clk implem
Date: Wed, 17 Jul 2013 18:05:27 +0200
Message-Id: <1374077127-20633-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13886849452760070252
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9x5 clocks in at91sam9x5 device tree.
Add references to the appropriate clocks in each peripheral.
Split optional sam9x5 peripherals in several device tree files. These
files are included by each SoC according to it's availability.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9g15.dtsi       |    1 +
 arch/arm/boot/dts/at91sam9g25.dtsi       |    3 +
 arch/arm/boot/dts/at91sam9g35.dtsi       |    2 +
 arch/arm/boot/dts/at91sam9x25.dtsi       |   25 +--
 arch/arm/boot/dts/at91sam9x35.dtsi       |    3 +
 arch/arm/boot/dts/at91sam9x5.dtsi        |  319 +++++++++++++++++++++++-------
 arch/arm/boot/dts/at91sam9x5_can.dtsi    |   26 +++
 arch/arm/boot/dts/at91sam9x5_isi.dtsi    |   22 +++
 arch/arm/boot/dts/at91sam9x5_lcdc.dtsi   |   28 +++
 arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |   66 +++++++
 arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |   54 +++++
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi |   58 ++++++
 12 files changed, 519 insertions(+), 88 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9x5_can.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_isi.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi

diff --git a/arch/arm/boot/dts/at91sam9g15.dtsi b/arch/arm/boot/dts/at91sam9g15.dtsi
index cfd7044..e0d8d84 100644
--- a/arch/arm/boot/dts/at91sam9g15.dtsi
+++ b/arch/arm/boot/dts/at91sam9g15.dtsi
@@ -7,6 +7,7 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_lcdc.dtsi"
 
 / {
 	model = "Atmel AT91SAM9G15 SoC";
diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
index b4ec6fe..49f5122 100644
--- a/arch/arm/boot/dts/at91sam9g25.dtsi
+++ b/arch/arm/boot/dts/at91sam9g25.dtsi
@@ -7,6 +7,9 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_usart3.dtsi"
+#include "at91sam9x5_macb0.dtsi"
+#include "at91sam9x5_isi.dtsi"
 
 / {
 	model = "Atmel AT91SAM9G25 SoC";
diff --git a/arch/arm/boot/dts/at91sam9g35.dtsi b/arch/arm/boot/dts/at91sam9g35.dtsi
index bebf9f5..cde7626 100644
--- a/arch/arm/boot/dts/at91sam9g35.dtsi
+++ b/arch/arm/boot/dts/at91sam9g35.dtsi
@@ -7,6 +7,8 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_macb0.dtsi"
+#include "at91sam9x5_isi.dtsi"
 
 / {
 	model = "Atmel AT91SAM9G35 SoC";
diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
index 49e94ab..3c5fa33 100644
--- a/arch/arm/boot/dts/at91sam9x25.dtsi
+++ b/arch/arm/boot/dts/at91sam9x25.dtsi
@@ -7,6 +7,10 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_usart3.dtsi"
+#include "at91sam9x5_macb0.dtsi"
+#include "at91sam9x5_macb1.dtsi"
+#include "at91sam9x5_can.dtsi"
 
 / {
 	model = "Atmel AT91SAM9X25 SoC";
@@ -22,27 +26,6 @@
 				       0x80000000 0xfffd0000 0xb83fffff  /* pioC */
 				       0x003fffff 0x003f8000 0x00000000  /* pioD */
 				      >;
-
-				macb1 {
-					pinctrl_macb1_rmii: macb1_rmii-0 {
-						atmel,pins =
-							<AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC16 periph B */
-							 AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC18 periph B */
-							 AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC19 periph B */
-							 AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC20 periph B */
-							 AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC21 periph B */
-							 AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC27 periph B */
-							 AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC28 periph B */
-							 AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC29 periph B */
-							 AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC30 periph B */
-							 AT91_PIOC 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC31 periph B */
-					};
-				};
-			};
-
-			macb1: ethernet@f8030000 {
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_macb1_rmii>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/at91sam9x35.dtsi b/arch/arm/boot/dts/at91sam9x35.dtsi
index 1a3d525..ecbdf5d 100644
--- a/arch/arm/boot/dts/at91sam9x35.dtsi
+++ b/arch/arm/boot/dts/at91sam9x35.dtsi
@@ -7,6 +7,9 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_macb0.dtsi"
+#include "at91sam9x5_lcdc.dtsi"
+#include "at91sam9x5_can.dtsi"
 
 / {
 	model = "Atmel AT91SAM9X35 SoC";
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 57d45f5..1dd5d11 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -50,6 +50,14 @@
 		reg = <0x20000000 0x10000000>;
 	};
 
+	clocks {
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <13200000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -78,6 +86,210 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
 				reg = <0xfffffc00 0x100>;
+
+				clk32k: slck {
+					compatible = "fixed-clock";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main", "fixed-clock";
+					#clock-cells = <0>;
+					clocks = <&clk32k>;
+				};
+
+				plla: pllack {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <0>;
+					input = <2000000 32000000>;
+					output = <74500000 800000000
+						  69500000 750000000
+						  64500000 700000000
+						  59500000 650000000
+						  54500000 600000000
+						  49500000 550000000
+						  44500000 500000000
+						  40000000 450000000>;
+					out = <0 1 2 3 0 1 2 3>;
+					icpll = <0 0 0 0 1 1 1 1>;
+				};
+
+				plladiv: plladivck {
+					compatible = "atmel,at91sam9x5-clk-plldiv";
+					#clock-cells = <0>;
+					clocks = <&plla>;
+				};
+
+				utmi: utmick {
+					compatible = "atmel,at91sam9x5-clk-utmi";
+					#clock-cells = <0>;
+					clocks = <&main>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91sam9x5-clk-master";
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
+					output = <0 133000000>;
+					divisors = <1 2 4 3>;
+					have-div3-pres;
+				};
+
+				usb: usbck {
+					compatible = "atmel,at91sam9x5-clk-usb";
+					#clock-cells = <0>;
+					clocks = <&plladiv>, <&utmi>;
+				};
+
+				prog: progck {
+					compatible = "atmel,at91sam9x5-clk-programmable";
+					#clock-cells = <1>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+
+					prog0@0 {
+						id = <0>;
+					};
+
+					prog1@1 {
+						id = <1>;
+					};
+				};
+
+				smd: smdclk {
+					compatible = "atmel,at91sam9x5-clk-smd";
+					#clock-cells = <0>;
+					clocks = <&plladiv>, <&utmi>;
+				};
+
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+
+					ddrck@2 {
+						id = <2>;
+					};
+
+					smdck@4 {
+						id = <4>;
+					};
+
+					udpck@6 {
+						id = <6>;
+					};
+
+					uhpck@7 {
+						id = <7>;
+					};
+
+					pck0@8 {
+						id = <8>;
+					};
+
+					pck1@9 {
+						id = <9>;
+					};
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+
+					pioAB_clk@2 {
+						id = <2>;
+					};
+
+					pioCD_clk@3 {
+						id = <3>;
+					};
+
+					smd_clk@4 {
+						id = <4>;
+					};
+
+					usart0_clk@5 {
+						id = <5>;
+					};
+
+					usart1_clk@6 {
+						id = <6>;
+					};
+
+					usart2_clk@7 {
+						id = <7>;
+					};
+
+					twi0_clk@9 {
+						id = <9>;
+					};
+
+					twi1_clk@10 {
+						id = <10>;
+					};
+
+					twi2_clk@11 {
+						id = <11>;
+					};
+
+					mci0_clk@12 {
+						id = <12>;
+					};
+
+					spi0_clk@13 {
+						id = <13>;
+					};
+
+					spi1_clk@14 {
+						id = <14>;
+					};
+
+					uart0_clk@15 {
+						id = <15>;
+					};
+
+					uart1_clk@16 {
+						id = <16>;
+					};
+
+					tcb_clk@17 {
+						id = <17>;
+					};
+
+					pwm_clk@18 {
+						id = <18>;
+					};
+
+					adc_clk@19 {
+						id = <19>;
+					};
+
+					dma0_clk@20 {
+						id = <20>;
+					};
+
+					dma1_clk@21 {
+						id = <21>;
+					};
+
+					uhphs_clk@22 {
+						id = <22>;
+					};
+
+					udphs_clk@23 {
+						id = <23>;
+					};
+
+					mci1_clk@26 {
+						id = <26>;
+					};
+
+					ssc_clk@27 {
+						id = <27>;
+					};
+				};
 			};
 
 			rstc@fffffe00 {
@@ -94,18 +306,23 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			tcb0: timer@f8008000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf8008000 0x100>;
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 17>;
+				clock-names = "t0_clk";
 			};
 
 			tcb1: timer@f800c000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf800c000 0x100>;
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 17>;
+				clock-names = "t0_clk";
 			};
 
 			dma0: dma-controller@ffffec00 {
@@ -113,6 +330,8 @@
 				reg = <0xffffec00 0x200>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 20>;
+				clock-names = "dma_clk";
 			};
 
 			dma1: dma-controller@ffffee00 {
@@ -120,6 +339,8 @@
 				reg = <0xffffee00 0x200>;
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 21>;
+				clock-names = "dma_clk";
 			};
 
 			pinctrl@fffff400 {
@@ -206,29 +427,6 @@
 					};
 				};
 
-				usart3 {
-					pinctrl_usart3: usart3-0 {
-						atmel,pins =
-							<AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP	/* PC22 periph B with pullup */
-							 AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC23 periph B */
-					};
-
-					pinctrl_usart3_rts: usart3_rts-0 {
-						atmel,pins =
-							<AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC24 periph B */
-					};
-
-					pinctrl_usart3_cts: usart3_cts-0 {
-						atmel,pins =
-							<AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC25 periph B */
-					};
-
-					pinctrl_usart3_sck: usart3_sck-0 {
-						atmel,pins =
-							<AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC26 periph B */
-					};
-				};
-
 				uart0 {
 					pinctrl_uart0: uart0-0 {
 						atmel,pins =
@@ -277,34 +475,6 @@
 					};
 				};
 
-				macb0 {
-					pinctrl_macb0_rmii: macb0_rmii-0 {
-						atmel,pins =
-							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A */
-							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A */
-							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A */
-							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A */
-							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A */
-							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A */
-							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A */
-							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB7 periph A */
-							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A */
-							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB10 periph A */
-					};
-
-					pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
-						atmel,pins =
-							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A */
-							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A */
-							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A */
-							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A */
-							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A */
-							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A */
-							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A */
-							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB17 periph A */
-					};
-				};
-
 				mmc0 {
 					pinctrl_mmc0_slot0_clk_cmd_dat0: mmc0_slot0_clk_cmd_dat0-0 {
 						atmel,pins =
@@ -503,6 +673,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -514,6 +685,7 @@
 					#gpio-lines = <19>;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -524,6 +696,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioD: gpio@fffffa00 {
@@ -535,6 +708,7 @@
 					#gpio-lines = <22>;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 			};
 
@@ -544,6 +718,8 @@
 				interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 28>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -555,6 +731,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 12>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -566,6 +744,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 26>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -575,6 +755,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -584,6 +766,8 @@
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 5>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -593,6 +777,8 @@
 				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 6>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -602,22 +788,8 @@
 				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
-				status = "disabled";
-			};
-
-			macb0: ethernet@f802c000 {
-				compatible = "cdns,at32ap7000-macb", "cdns,macb";
-				reg = <0xf802c000 0x100>;
-				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_macb0_rmii>;
-				status = "disabled";
-			};
-
-			macb1: ethernet@f8030000 {
-				compatible = "cdns,at32ap7000-macb", "cdns,macb";
-				reg = <0xf8030000 0x100>;
-				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
+				clocks = <&periph 7>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -632,6 +804,7 @@
 				#size-cells = <0>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_i2c0>;
+				clocks = <&periph 9>;
 				status = "disabled";
 			};
 
@@ -646,6 +819,7 @@
 				#size-cells = <0>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_i2c1>;
+				clocks = <&periph 10>;
 				status = "disabled";
 			};
 
@@ -660,6 +834,7 @@
 				#size-cells = <0>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_i2c2>;
+				clocks = <&periph 11>;
 				status = "disabled";
 			};
 
@@ -685,6 +860,8 @@
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf804c000 0x100>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 19>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-use-external;
 				atmel,adc-channels-used = <0xffff>;
 				atmel,adc-vref = <3300>;
@@ -733,6 +910,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 13>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -747,6 +926,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 14>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -851,6 +1032,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&periph 22>, <&periph 22>, <&system 6>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -858,6 +1041,8 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 22>, <&system 6>;
+			clock-names = "ehci_clk", "uhpck";
 			status = "disabled";
 		};
 	};
diff --git a/arch/arm/boot/dts/at91sam9x5_can.dtsi b/arch/arm/boot/dts/at91sam9x5_can.dtsi
new file mode 100644
index 0000000..e6db2f2
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_can.dtsi
@@ -0,0 +1,26 @@
+/*
+ * at91sam9x5_can.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * CAN support.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+/ {
+	ahb {
+		apb {
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					can0_clk@29 {
+						id = <29>;
+					};
+
+					can1_clk@30 {
+						id = <30>;
+					};
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_isi.dtsi b/arch/arm/boot/dts/at91sam9x5_isi.dtsi
new file mode 100644
index 0000000..593c9e4
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_isi.dtsi
@@ -0,0 +1,22 @@
+/*
+ * at91sam9x5_isi.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * ISI (Image Sensor Interface) support.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+/ {
+	ahb {
+		apb {
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					isi_clk@25 {
+						id = <25>;
+					};
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_lcdc.dtsi b/arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
new file mode 100644
index 0000000..5e04c50
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
@@ -0,0 +1,28 @@
+/*
+ * at91sam9x5_lcdc.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * LCDC (LCD controller) support.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+/ {
+	ahb {
+		apb {
+			pmc: pmc@fffffc00 {
+				system: systemck {
+					lcdck@3 {
+						id = <3>;
+					};
+				};
+
+				periph: periphck {
+					lcdc_clk@25 {
+						id = <25>;
+					};
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_macb0.dtsi b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
new file mode 100644
index 0000000..5483e1a
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
@@ -0,0 +1,66 @@
+/*
+ * at91sam9x5_macb0.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 1
+ * Ethernet interface.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff400 {
+				macb0 {
+					pinctrl_macb0_rmii: macb0_rmii-0 {
+						atmel,pins =
+							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A */
+							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A */
+							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A */
+							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A */
+							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A */
+							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A */
+							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A */
+							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB7 periph A */
+							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A */
+							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB10 periph A */
+					};
+
+					pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
+						atmel,pins =
+							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A */
+							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A */
+							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A */
+							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A */
+							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A */
+							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A */
+							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A */
+							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB17 periph A */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					macb0_clk@24 {
+						id = <24>;
+					};
+				};
+			};
+
+			macb0: ethernet@f802c000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf802c000 0x100>;
+				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb0_rmii>;
+				clocks = <&periph 24>, <&periph 24>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_macb1.dtsi b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
new file mode 100644
index 0000000..d20a680
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
@@ -0,0 +1,54 @@
+/*
+ * at91sam9x5_macb1.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 2
+ * Ethernet interfaces.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff400 {
+				macb1 {
+					pinctrl_macb1_rmii: macb1_rmii-0 {
+						atmel,pins =
+							<AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC16 periph B */
+							 AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC18 periph B */
+							 AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC19 periph B */
+							 AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC20 periph B */
+							 AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC21 periph B */
+							 AT91_PIOC 27 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC27 periph B */
+							 AT91_PIOC 28 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC28 periph B */
+							 AT91_PIOC 29 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC29 periph B */
+							 AT91_PIOC 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PC30 periph B */
+							 AT91_PIOC 31 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PC31 periph B */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					macb1_clk@27 {
+						id = <27>;
+					};
+				};
+			};
+
+			macb1: ethernet@f8030000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf8030000 0x100>;
+				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb1_rmii>;
+				clocks = <&periph 27>, <&periph 27>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
new file mode 100644
index 0000000..292b276
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
@@ -0,0 +1,58 @@
+/*
+ * at91sam9x5_lcdc.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * 4 USART.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff400 {
+				usart3 {
+					pinctrl_usart3: usart3-0 {
+						atmel,pins =
+							<AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_PULL_UP	/* PC22 periph B with pullup */
+							 AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC23 periph B */
+					};
+
+					pinctrl_usart3_rts: usart3_rts-0 {
+						atmel,pins =
+							<AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC24 periph B */
+					};
+
+					pinctrl_usart3_cts: usart3_cts-0 {
+						atmel,pins =
+							<AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC25 periph B */
+					};
+
+					pinctrl_usart3_sck: usart3_sck-0 {
+						atmel,pins =
+							<AT91_PIOC 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;		/* PC26 periph B */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					usart3_clk@8 {
+						id = <8>;
+					};
+				};
+			};
+
+			usart3: serial@f8028000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8028000 0x200>;
+				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&periph 8>;
+				clock-names = "usart";
+				status = "disabled";
+			};
+		};
+	};
+};
-- 
1.7.9.5

