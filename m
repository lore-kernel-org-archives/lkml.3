Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3FGSNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:13:49 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:51853 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756375Ab3FGSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:13:47 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 41/50] ARM: at91/dt: move at91sam9x5 SoCs to new at91 clk implem
Date: Fri,  7 Jun 2013 20:13:34 +0200
Message-Id: <1370628819-2973-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2552133615719118876
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9x5 clocks in at91sam9x5 device tree.
Add references to the appropriate clocks in each peripheral.
Split optional sam9x5 peripherals in several device tree files. These
files are included by each SoC according to it's availability.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9g15.dtsi       |   11 ++
 arch/arm/boot/dts/at91sam9g25.dtsi       |    3 +
 arch/arm/boot/dts/at91sam9g35.dtsi       |   23 +++
 arch/arm/boot/dts/at91sam9x25.dtsi       |   25 +---
 arch/arm/boot/dts/at91sam9x35.dtsi       |    3 +
 arch/arm/boot/dts/at91sam9x5.dtsi        |  226 +++++++++++++++++++++---------
 arch/arm/boot/dts/at91sam9x5_can.dtsi    |   24 ++++
 arch/arm/boot/dts/at91sam9x5_isi.dtsi    |   24 ++++
 arch/arm/boot/dts/at91sam9x5_lcdc.dtsi   |   32 +++++
 arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |   68 +++++++++
 arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |   56 ++++++++
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi |   60 ++++++++
 12 files changed, 467 insertions(+), 88 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g15.dtsi b/arch/arm/boot/dts/at91sam9g15.dtsi
index cfd7044..29d765c 100644
--- a/arch/arm/boot/dts/at91sam9g15.dtsi
+++ b/arch/arm/boot/dts/at91sam9g15.dtsi
@@ -7,6 +7,7 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_lcdc.dtsi"
 
 / {
 	model = "Atmel AT91SAM9G15 SoC";
@@ -23,6 +24,16 @@
 				       0x003fffff 0x003f8000 0x00000000  /* pioD */
 				      >;
 			};
+
+			pmc: pmc@fffffc00 {
+				at91sam9g15periph: at91sam9g15periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <25>;
+					clock-output-names = "lcdc_clk";
+				};
+			};
 		};
 	};
 };
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
index bebf9f5..6ee3c5a 100644
--- a/arch/arm/boot/dts/at91sam9g35.dtsi
+++ b/arch/arm/boot/dts/at91sam9g35.dtsi
@@ -7,6 +7,8 @@
  */
 
 #include "at91sam9x5.dtsi"
+#include "at91sam9x5_macb0.dtsi"
+#include "at91sam9x5_isi.dtsi"
 
 / {
 	model = "Atmel AT91SAM9G35 SoC";
@@ -23,6 +25,27 @@
 				       0x003fffff 0x003f8000 0x00000000  /* pioD */
 				      >;
 			};
+
+			pmc: pmc@fffffc00 {
+				at91sam9g35periph: at91sam9g35periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <24 25>;
+					clock-output-names = "macb_clk", "isi_clk";
+				};
+			};
+
+			macb0: ethernet@f802c000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf802c000 0x100>;
+				interrupts = <24 4 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb0_rmii>;
+				clocks = <&at91sam9g35periph 24>, <&at91sam9g35periph 24>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
 		};
 	};
 };
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
index e77106e..18f9283 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -73,6 +73,125 @@
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
+					ids = <0 1>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+					clock-output-names = "prog0", "prog1";
+				};
+
+				smd: smdck {
+					compatible = "atmel,at91sam9x5-clk-smd";
+					#clock-cells = <0>;
+					clocks = <&plladiv>, <&utmi>;
+				};
+
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+					ids = <2 4 6 7 8 9>;
+					clocks = <&mck>, <&smd>, <&usb>,
+						 <&usb>, <&prog 0>, <&prog 1>;
+					clock-output-names = "ddrck", "smdck",
+							     "uhpck", "udpck",
+							     "pck0", "pck1";
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <2 3 4 5 6 7 9 10 11 12 13 14 15
+					       16 17 18 19 20 21 22 23 26 28>;
+					clock-output-names = "pioAB_clk",
+							     "pioCD_clk",
+							     "smd_clk",
+							     "usart0_clk",
+							     "usart1_clk",
+							     "usart2_clk",
+							     "twi0_clk",
+							     "twi1_clk",
+							     "twi2_clk",
+							     "mci0_clk",
+							     "spi0_clk",
+							     "spi1_clk",
+							     "uart0_clk",
+							     "uart1_clk",
+							     "tcb_clk",
+							     "pwm_clk",
+							     "adc_clk",
+							     "dma0_clk",
+							     "dma1_clk",
+							     "uhphs_clk",
+							     "udphs_clk",
+							     "mci1_clk",
+							     "ssc_clk";
+
+					adc_op_clk: adc_op_clk{
+						compatible = "fixed-clock";
+						#clock-cells = <0>;
+						clock-frequency = <13200000>;
+					};
+				};
 			};
 
 			rstc@fffffe00 {
@@ -89,18 +208,23 @@
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
@@ -108,6 +232,8 @@
 				reg = <0xffffec00 0x200>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 20>;
+				clock-names = "dma_clk";
 			};
 
 			dma1: dma-controller@ffffee00 {
@@ -115,6 +241,8 @@
 				reg = <0xffffee00 0x200>;
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 21>;
+				clock-names = "dma_clk";
 			};
 
 			pinctrl@fffff400 {
@@ -201,29 +329,6 @@
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
@@ -272,34 +377,6 @@
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
@@ -498,6 +575,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -509,6 +587,7 @@
 					#gpio-lines = <19>;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -519,6 +598,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioD: gpio@fffffa00 {
@@ -530,6 +610,7 @@
 					#gpio-lines = <22>;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 			};
 
@@ -539,6 +620,8 @@
 				interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 28>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -550,6 +633,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 26>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -561,6 +646,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 12>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -570,6 +657,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -579,6 +668,8 @@
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 5>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -588,6 +679,8 @@
 				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 6>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -597,22 +690,8 @@
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
 
@@ -627,6 +706,7 @@
 				#size-cells = <0>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_i2c0>;
+				clocks = <&periph 9>;
 				status = "disabled";
 			};
 
@@ -641,6 +721,7 @@
 				#size-cells = <0>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_i2c1>;
+				clocks = <&periph 10>;
 				status = "disabled";
 			};
 
@@ -655,6 +736,7 @@
 				#size-cells = <0>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_i2c2>;
+				clocks = <&periph 11>;
 				status = "disabled";
 			};
 
@@ -680,6 +762,8 @@
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf804c000 0x100>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 19>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-use-external;
 				atmel,adc-channels-used = <0xffff>;
 				atmel,adc-vref = <3300>;
@@ -725,6 +809,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 13>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -736,6 +822,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 14>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -778,6 +866,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 22>, <&periph 22>, <&system 6>;
+			clock-names = "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -785,6 +875,8 @@
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
index 0000000..224752c
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_can.dtsi
@@ -0,0 +1,24 @@
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
+				isiperiph: isiperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <29 30>;
+					clock-output-names = "can0_clk", "can1_clk";
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_isi.dtsi b/arch/arm/boot/dts/at91sam9x5_isi.dtsi
new file mode 100644
index 0000000..86244c6
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_isi.dtsi
@@ -0,0 +1,24 @@
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
+				isiperiph: isiperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <25>;
+					clock-output-names = "isi_clk";
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_lcdc.dtsi b/arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
new file mode 100644
index 0000000..6c77b0f
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_lcdc.dtsi
@@ -0,0 +1,32 @@
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
+				lcdsys: lcdsysck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+					ids = <3>;
+					clocks = <&mck>;
+					clock-output-names = "lcdck";
+				};
+
+				lcdcperiph: lcdcperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <25>;
+					clock-output-names = "lcdc_clk";
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_macb0.dtsi b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
new file mode 100644
index 0000000..2d05137
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
@@ -0,0 +1,68 @@
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
+				macb0periph: macb0periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <24>;
+					clock-output-names = "macb0_clk";
+				};
+			};
+
+			macb0: ethernet@f802c000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf802c000 0x100>;
+				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb0_rmii>;
+				clocks = <&macb0periph 24>, <&macb0periph 24>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_macb1.dtsi b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
new file mode 100644
index 0000000..8d9c8f7
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
@@ -0,0 +1,56 @@
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
+				macb1periph: macb1periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <27>;
+					clock-output-names = "macb1_clk";
+				};
+			};
+
+			macb1: ethernet@f8030000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf8030000 0x100>;
+				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb1_rmii>;
+				clocks = <&macb1periph 27>, <&macb1periph 27>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
new file mode 100644
index 0000000..6146fd0
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
@@ -0,0 +1,60 @@
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
+				usart3periph: usart3periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <8>;
+					clock-output-names = "usart3_clk";
+				};
+			};
+
+			usart3: serial@f8028000 {
+				compatible = "atmel,at91sam9260-usart";
+				reg = <0xf8028000 0x200>;
+				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&usart3periph 8>;
+				clock-names = "usart";
+				status = "disabled";
+			};
+		};
+	};
+};
-- 
1.7.9.5

