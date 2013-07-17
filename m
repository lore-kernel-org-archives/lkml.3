Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3GQQCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:02:20 -0400
Received: from 12.mo1.mail-out.ovh.net ([87.98.162.229]:49935 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754572Ab3GQQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:02:19 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 32/42] ARM: at91/dt: move at91sam9n12 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 18:02:05 +0200
Message-Id: <1374076925-20580-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13828302656911931500
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9n12 clocks in at91sam9n12 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9n12.dtsi |  251 ++++++++++++++++++++++++++++++++++++
 1 file changed, 251 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index bb7f564..a12ad9f 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -76,6 +76,224 @@
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
+				pllb: pllbck {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <1>;
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
+				mck: masterck {
+					compatible = "atmel,at91sam9x5-clk-master";
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&pllb>;
+					output = <0 133000000>;
+					divisors = <1 2 4 3>;
+				};
+
+				usb: usbck {
+					compatible = "atmel,at91sam9x5-clk-usb";
+					#clock-cells = <0>;
+					clocks = <&pllb>;
+					usbs0-unused;
+				};
+
+				prog: progck {
+					compatible = "atmel,at91rm9200-clk-programmable";
+					#clock-cells = <1>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&pllb>, <&mck>;
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
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+
+					ddrck@2 {
+						id = <2>;
+					};
+
+					lcdck@3 {
+						id = <3>;
+					};
+
+					uhpck@6 {
+						id = <6>;
+					};
+
+					udpck@7 {
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
+					compatible = "atmel,at91rm9200-clk-peripheral";
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
+					fuse_clk@4 {
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
+					usart3_clk@8 {
+						id = <8>;
+					};
+
+					twi0_ck@9 {
+						id = <9>;
+					};
+
+					twi1_ck@10 {
+						id = <10>;
+					};
+
+					hsmci_clk@12 {
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
+					dma_clk@20 {
+						id = <20>;
+					};
+
+					uhp_clk@22 {
+						id = <22>;
+					};
+
+					udc_clk@23 {
+						id = <23>;
+					};
+
+					lcdc_clk@25 {
+						id = <25>;
+					};
+
+					sha_clk@27 {
+						id = <27>;
+					};
+
+					ssc_clk@28 {
+						id = <28>;
+					};
+
+					aes_clk@29 {
+						id = <29>;
+					};
+
+					trng_clk@30 {
+						id = <30>;
+					};
+				};
 			};
 
 			rstc@fffffe00 {
@@ -87,6 +305,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			shdwc@fffffe10 {
@@ -102,6 +321,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 12>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -109,12 +330,16 @@
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
 
 			dma: dma-controller@ffffec00 {
@@ -122,6 +347,8 @@
 				reg = <0xffffec00 0x200>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 20>;
+				clock-names = "dma_clk";
 			};
 
 			pinctrl@fffff400 {
@@ -375,6 +602,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -385,6 +613,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -395,6 +624,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioD: gpio@fffffa00 {
@@ -405,6 +635,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 			};
 
@@ -414,6 +645,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -423,6 +656,8 @@
 				interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 28>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -432,6 +667,8 @@
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 5>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -441,6 +678,8 @@
 				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 6>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -450,6 +689,8 @@
 				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph 7>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -459,6 +700,8 @@
 				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&periph 8>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -471,6 +714,7 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 9>;
 				status = "disabled";
 			};
 
@@ -483,6 +727,7 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 10>;
 				status = "disabled";
 			};
 
@@ -497,6 +742,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 13>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -511,6 +758,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 14>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -546,6 +795,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00500000 0x00100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&periph 22>, <&periph 22>, <&system 6>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

