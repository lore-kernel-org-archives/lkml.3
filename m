Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777Ab3HHIro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:47:44 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:34769 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933813Ab3HHIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:47:40 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 3/6] ARM: at91/dt: define sama5d3 clocks
Date: Thu,  8 Aug 2013 10:47:24 +0200
Message-Id: <1375951644-10941-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 6625920952700532915
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define sama5d3 clocks in sama5d3 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3.dtsi      |  331 ++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/sama5d3_can.dtsi  |   19 ++
 arch/arm/boot/dts/sama5d3_emac.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_gmac.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_lcd.dtsi  |   17 ++
 arch/arm/boot/dts/sama5d3_mci2.dtsi |   11 ++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_uart.dtsi |   19 ++
 8 files changed, 431 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index f0ca1ba..e2791c5 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -14,6 +14,10 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/common/clk-system.h>
+#include <dt-bindings/clk/at91/common/pmc.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
+#include <dt-bindings/clk/at91/common/clk-pll.h>
 
 / {
 	model = "Atmel SAMA5D3 family SoC";
@@ -52,6 +56,14 @@
 		reg = <0x20000000 0x8000000>;
 	};
 
+	clocks {
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <20000000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -75,6 +87,8 @@
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph SAMA5D3_ID_HSMCI0>;
+				clock-names = "mci_clk";
 			};
 
 			spi0: spi@f0004000 {
@@ -88,6 +102,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph SAMA5D3_ID_SPI0>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -97,6 +113,8 @@
 				interrupts = <SAMA5D3_ID_SSC0 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph SAMA5D3_ID_SSC0>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -104,6 +122,8 @@
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf0010000 0x100>;
 				interrupts = <SAMA5D3_ID_TC0 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph SAMA5D3_ID_TC0>;
+				clock-names = "t0_clk";
 			};
 
 			i2c0: i2c@f0014000 {
@@ -117,6 +137,7 @@
 				pinctrl-0 = <&pinctrl_i2c0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph SAMA5D3_ID_TWI0>;
 				status = "disabled";
 			};
 
@@ -131,6 +152,7 @@
 				pinctrl-0 = <&pinctrl_i2c1>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph SAMA5D3_ID_TWI1>;
 				status = "disabled";
 			};
 
@@ -140,6 +162,8 @@
 				interrupts = <SAMA5D3_ID_USART0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph SAMA5D3_ID_USART0>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -149,6 +173,8 @@
 				interrupts = <SAMA5D3_ID_USART1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph SAMA5D3_ID_USART1>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -170,6 +196,8 @@
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph SAMA5D3_ID_HSMCI1>;
+				clock-names = "mci_clk";
 			};
 
 			spi1: spi@f8008000 {
@@ -183,6 +211,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph SAMA5D3_ID_SPI1>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -192,6 +222,8 @@
 				interrupts = <SAMA5D3_ID_SSC1 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&periph SAMA5D3_ID_SSC1>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -215,6 +247,9 @@
 					&pinctrl_adc0_ad10
 					&pinctrl_adc0_ad11
 					>;
+				clocks = <&periph SAMA5D3_ID_ADC>,
+					 <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-channel-base = <0x50>;
 				atmel,adc-channels-used = <0xfff>;
 				atmel,adc-drdy-mask = <0x1000000>;
@@ -270,6 +305,7 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph SAMA5D3_ID_TWI2>;
 				status = "disabled";
 			};
 
@@ -279,6 +315,8 @@
 				interrupts = <SAMA5D3_ID_USART2 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph SAMA5D3_ID_USART2>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -288,6 +326,8 @@
 				interrupts = <SAMA5D3_ID_USART3 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&periph SAMA5D3_ID_USART3>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -300,7 +340,7 @@
 			aes@f8038000 {
 				compatible = "atmel,sam9g46-aes";
 				reg = <0xf8038000 0x100>;
-				interrupts = <SAMA5D3_ID_AES 4 0>;
+				interrupts = <SAMA5D3_ID_AES IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			tdes@f803c000 {
@@ -314,6 +354,8 @@
 				reg = <0xffffe600 0x200>;
 				interrupts = <SAMA5D3_ID_DMA0 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph SAMA5D3_ID_DMA0>;
+				clock-names = "dma_clk";
 			};
 
 			dma1: dma-controller@ffffe800 {
@@ -321,6 +363,8 @@
 				reg = <0xffffe800 0x200>;
 				interrupts = <SAMA5D3_ID_DMA1 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph SAMA5D3_ID_DMA1>;
+				clock-names = "dma_clk";
 			};
 
 			ramc0: ramc@ffffea00 {
@@ -334,6 +378,8 @@
 				interrupts = <SAMA5D3_ID_DBGU IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&periph 2>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -622,6 +668,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 6>;
 				};
 
 				pioB: gpio@fffff400 {
@@ -632,6 +679,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 7>;
 				};
 
 				pioC: gpio@fffff600 {
@@ -642,6 +690,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 8>;
 				};
 
 				pioD: gpio@fffff800 {
@@ -652,6 +701,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 9>;
 				};
 
 				pioE: gpio@fffffa00 {
@@ -662,12 +712,279 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 10>;
 				};
 			};
 
 			pmc: pmc@fffffc00 {
-				compatible = "atmel,at91rm9200-pmc";
+				compatible = "atmel,sama5d3-pmc";
 				reg = <0xfffffc00 0x120>;
+				interrupts = <AT91_ID_SYS IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+
+				clk32k: slck {
+					compatible = "fixed-clock";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main";
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_MOSCS IRQ_TYPE_LEVEL_HIGH>;
+					#clock-cells = <0>;
+					clocks = <&clk32k>;
+				};
+
+				plla: pllack {
+					compatible = "atmel,sama5d3-clk-pll";
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_LOCKA IRQ_TYPE_LEVEL_HIGH>;
+					#clock-cells = <0>;
+					clocks = <&main>;
+					atmel,clk-id = <AT91_PLLA_CLK>;
+					atmel,clk-input-range = <8000000 50000000>;
+					#atmel,pll-clk-output-range-cells = <4>;
+					atmel,pll-clk-output-ranges = <400000000 1000000000 0 0>;
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
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_LOCKU IRQ_TYPE_LEVEL_HIGH>;
+					#clock-cells = <0>;
+					clocks = <&main>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91sam9x5-clk-master";
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_MCKRDY IRQ_TYPE_LEVEL_HIGH>;
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
+					atmel,clk-output-range = <0 166000000>;
+					atmel,clk-divisors = <1 2 4 3>;
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
+					interrupt-parent = <&pmc>;
+					#clock-cells = <1>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+
+					prog0 {
+						atmel,clk-id = <0>;
+						interrupts = <AT91_PMC_PCKRDY(0) IRQ_TYPE_LEVEL_HIGH>;
+					};
+
+					prog1 {
+						atmel,clk-id = <1>;
+						interrupts = <AT91_PMC_PCKRDY(1) IRQ_TYPE_LEVEL_HIGH>;
+					};
+
+					prog2 {
+						atmel,clk-id = <2>;
+						interrupts = <AT91_PMC_PCKRDY(2) IRQ_TYPE_LEVEL_HIGH>;
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
+					ddrck {
+						atmel,clk-id = <AT91_DDRCK_SYS_CLK>;
+					};
+
+					smdck {
+						atmel,clk-id = <AT91_SMDCK_SYS_CLK>;
+					};
+
+					uhpck {
+						atmel,clk-id = <AT91_UHP_SYS_CLK>;
+					};
+
+					udpck {
+						atmel,clk-id = <AT91_UDP_SYS_CLK>;
+					};
+
+					pck0 {
+						atmel,clk-id = <AT91_PROG_SYS_CLK(0)>;
+					};
+
+					pck1 {
+						atmel,clk-id = <AT91_PROG_SYS_CLK(1)>;
+					};
+
+					pck2 {
+						atmel,clk-id = <AT91_PROG_SYS_CLK(2)>;
+					};
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+
+					dbgu_clk {
+						atmel,clk-id = <SAMA5D3_ID_DBGU>;
+					};
+
+					pioA_clk {
+						atmel,clk-id = <SAMA5D3_ID_PIOA>;
+					};
+
+					pioB_clk {
+						atmel,clk-id = <SAMA5D3_ID_PIOB>;
+					};
+
+					pioC_clk {
+						atmel,clk-id = <SAMA5D3_ID_PIOC>;
+					};
+
+					pioD_clk {
+						atmel,clk-id = <SAMA5D3_ID_PIOD>;
+					};
+
+					pioE_clk {
+						atmel,clk-id = <SAMA5D3_ID_PIOE>;
+					};
+
+					usart0_clk {
+						atmel,clk-id = <SAMA5D3_ID_USART0>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					usart1_clk {
+						atmel,clk-id = <SAMA5D3_ID_USART1>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					usart2_clk {
+						atmel,clk-id = <SAMA5D3_ID_USART2>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					usart3_clk {
+						atmel,clk-id = <SAMA5D3_ID_USART3>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					twi0_clk {
+						atmel,clk-id = <SAMA5D3_ID_TWI0>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					twi1_clk {
+						atmel,clk-id = <SAMA5D3_ID_TWI1>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					twi2_clk {
+						atmel,clk-id = <SAMA5D3_ID_TWI2>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					mci0_clk {
+						atmel,clk-id = <SAMA5D3_ID_HSMCI0>;
+					};
+
+					mci1_clk {
+						atmel,clk-id = <SAMA5D3_ID_HSMCI1>;
+					};
+
+					spi0_clk {
+						atmel,clk-id = <SAMA5D3_ID_SPI0>;
+					};
+
+					spi1_clk {
+						atmel,clk-id = <SAMA5D3_ID_SPI1>;
+					};
+
+					tcb0_clk {
+						atmel,clk-id = <SAMA5D3_ID_TC0>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					pwm_clk {
+						atmel,clk-id = <SAMA5D3_ID_PWM>;
+					};
+
+					adc_clk {
+						atmel,clk-id = <SAMA5D3_ID_ADC>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					dma0_clk {
+						atmel,clk-id = <SAMA5D3_ID_DMA0>;
+					};
+
+					dma1_clk {
+						atmel,clk-id = <SAMA5D3_ID_DMA1>;
+					};
+
+					uhphs_clk {
+						atmel,clk-id = <SAMA5D3_ID_UHPHS>;
+					};
+
+					udphs_clk {
+						atmel,clk-id = <SAMA5D3_ID_UDPHS>;
+					};
+
+					isi_clk {
+						atmel,clk-id = <SAMA5D3_ID_ISI>;
+					};
+
+					ssc0_clk {
+						atmel,clk-id = <SAMA5D3_ID_SSC0>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					ssc1_clk {
+						atmel,clk-id = <SAMA5D3_ID_SSC1>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					sha_clk {
+						atmel,clk-id = <SAMA5D3_ID_SHA>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV8>;
+					};
+
+					aes_clk {
+						atmel,clk-id = <SAMA5D3_ID_AES>;
+					};
+
+					tdes_clk {
+						atmel,clk-id = <SAMA5D3_ID_TDES>;
+					};
+
+					trng_clk {
+						atmel,clk-id = <SAMA5D3_ID_TRNG>;
+					};
+
+					fuse_clk {
+						atmel,clk-id = <SAMA5D3_ID_FUSE>;
+					};
+				};
 			};
 
 			rstc@fffffe00 {
@@ -679,6 +996,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
 				interrupts = <AT91_ID_PIT IRQ_TYPE_LEVEL_HIGH 5>;
+				clocks = <&mck>;
 			};
 
 			watchdog@fffffe40 {
@@ -701,6 +1019,8 @@
 			reg = <0x00500000 0x100000
 			       0xf8030000 0x4000>;
 			interrupts = <SAMA5D3_ID_UDPHS IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph SAMA5D3_ID_UDPHS>, <&utmi>;
+			clock-names = "pclk", "hclk";
 			status = "disabled";
 
 			ep0 {
@@ -813,6 +1133,10 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
 			interrupts = <SAMA5D3_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&periph SAMA5D3_ID_UHPHS>,
+				 <&periph SAMA5D3_ID_UHPHS>,
+				 <&system AT91_UHP_SYS_CLK>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -820,6 +1144,9 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <SAMA5D3_ID_UHPHS IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph SAMA5D3_ID_UHPHS>,
+				 <&system AT91_UHP_SYS_CLK>;
+			clock-names = "ehci_clk", "uhpck";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3_can.dtsi
index 55b2d9f..0c3fa82 100644
--- a/arch/arm/boot/dts/sama5d3_can.dtsi
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	ahb {
@@ -33,12 +34,28 @@
 
 			};
 
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					can0_clk {
+						atmel,clk-id = <SAMA5D3_ID_CAN0>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					can1_clk {
+						atmel,clk-id = <SAMA5D3_ID_CAN1>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+				};
+			};
+
 			can0: can@f000c000 {
 				compatible = "atmel,at91sam9x5-can";
 				reg = <0xf000c000 0x300>;
 				interrupts = <SAMA5D3_ID_CAN0 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_can0_rx_tx>;
+				clocks = <&periph SAMA5D3_ID_CAN0>;
+				clock-names = "can_clk";
 				status = "disabled";
 			};
 
@@ -48,6 +65,8 @@
 				interrupts = <SAMA5D3_ID_CAN1 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_can1_rx_tx>;
+				clocks = <&periph SAMA5D3_ID_CAN1>;
+				clock-names = "can_clk";
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
index fb4628d..d4a9556 100644
--- a/arch/arm/boot/dts/sama5d3_emac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	ahb {
@@ -32,12 +33,23 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					macb1_clk {
+						atmel,clk-id = <SAMA5D3_ID_EMAC>;
+					};
+				};
+			};
+
 			macb1: ethernet@f802c000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xf802c000 0x100>;
 				interrupts = <SAMA5D3_ID_EMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb1_rmii>;
+				clocks = <&periph SAMA5D3_ID_EMAC>,
+					 <&periph SAMA5D3_ID_EMAC>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
index f92c721..8082021 100644
--- a/arch/arm/boot/dts/sama5d3_gmac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	ahb {
@@ -65,12 +66,23 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					macb0_clk {
+						atmel,clk-id = <SAMA5D3_ID_GMAC>;
+					};
+				};
+			};
+
 			macb0: ethernet@f0028000 {
 				compatible = "cdns,pc302-gem", "cdns,gem";
 				reg = <0xf0028000 0x100>;
 				interrupts = <SAMA5D3_ID_GMAC IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
+				clocks = <&periph SAMA5D3_ID_GMAC>,
+					 <&periph SAMA5D3_ID_GMAC>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index 01f52a7..15ff059 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -9,6 +9,9 @@
 
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/common/clk-system.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	ahb {
@@ -50,6 +53,20 @@
 					};
 				};
 			};
+
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					lcdc_clk {
+						atmel,clk-id = <SAMA5D3_ID_LCDC>;
+					};
+				};
+
+				system: systemck {
+					lcdck {
+						atmel,clk-id = <AT91_LCDCK_SYS_CLK>;
+					};
+				};
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/sama5d3_mci2.dtsi b/arch/arm/boot/dts/sama5d3_mci2.dtsi
index 6471610..7cef03e 100644
--- a/arch/arm/boot/dts/sama5d3_mci2.dtsi
+++ b/arch/arm/boot/dts/sama5d3_mci2.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	ahb {
@@ -31,6 +32,14 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					mci2_clk {
+						atmel,clk-id = <SAMA5D3_ID_HSMCI2>;
+					};
+				};
+			};
+
 			mmc2: mmc@f8004000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf8004000 0x600>;
@@ -39,6 +48,8 @@
 				dma-names = "rxtx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
+				clocks = <&periph SAMA5D3_ID_HSMCI2>;
+				clock-names = "mci_clk";
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
index bd26568..fb00a22 100644
--- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	aliases {
@@ -18,10 +19,21 @@
 
 	ahb {
 		apb {
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					tcb1_clk {
+						atmel,clk-id = <SAMA5D3_ID_TC1>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+				};
+			};
+
 			tcb1: timer@f8014000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf8014000 0x100>;
 				interrupts = <SAMA5D3_ID_TC1 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph SAMA5D3_ID_TC1>;
+				clock-names = "t0_clk";
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
index 1d89110..675b04d 100644
--- a/arch/arm/boot/dts/sama5d3_uart.dtsi
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/at91/sama5d3/peripherals.h>
+#include <dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h>
 
 / {
 	ahb {
@@ -32,12 +33,28 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periph: periphck {
+					uart0_clk {
+						atmel,clk-id = <SAMA5D3_ID_UART0>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+
+					uart1_clk {
+						atmel,clk-id = <SAMA5D3_ID_UART1>;
+						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
+					};
+				};
+			};
+
 			uart0: serial@f0024000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf0024000 0x200>;
 				interrupts = <SAMA5D3_ID_UART0 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
+				clocks = <&periph SAMA5D3_ID_UART0>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -47,6 +64,8 @@
 				interrupts = <SAMA5D3_ID_UART1 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
+				clocks = <&periph SAMA5D3_ID_UART1>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 		};
-- 
1.7.9.5

