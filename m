Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3KDNzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:55:11 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:63645 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3KDNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:55:09 -0500
Message-ID: <5277A737.5080705@atmel.com>
Date: Mon, 4 Nov 2013 14:55:03 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/7] ARM: at91/dt: define sama5d3 clocks
References: <5260F959.2090705@atmel.com> <1382132907-30198-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1382132907-30198-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/2013 23:48, Boris BREZILLON :
> Define sama5d3 clocks in sama5d3 device tree.
> Add references to the appropriate clocks in each peripheral.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
> Changes since v2:
>   - add usb_clk to usb ehci controller node

Yes. Tested and it works okay.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Bye,

> This new version (and the associated patch
> "USB: ehci-atmel: add usb_clk for transition to CCF") fixes a bug in ehci clk
> initialization.
>
>   arch/arm/boot/dts/sama5d3.dtsi      |  331 ++++++++++++++++++++++++++++++++++-
>   arch/arm/boot/dts/sama5d3_can.dtsi  |   18 ++
>   arch/arm/boot/dts/sama5d3_emac.dtsi |   10 ++
>   arch/arm/boot/dts/sama5d3_gmac.dtsi |   10 ++
>   arch/arm/boot/dts/sama5d3_lcd.dtsi  |   15 ++
>   arch/arm/boot/dts/sama5d3_mci2.dtsi |   11 ++
>   arch/arm/boot/dts/sama5d3_tcb1.dtsi |   12 ++
>   arch/arm/boot/dts/sama5d3_uart.dtsi |   19 ++
>   8 files changed, 425 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 5cdaba4..20a6e4e 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -13,6 +13,7 @@
>   #include <dt-bindings/pinctrl/at91.h>
>   #include <dt-bindings/interrupt-controller/irq.h>
>   #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/clk/at91.h>
>
>   / {
>   	model = "Atmel SAMA5D3 family SoC";
> @@ -56,6 +57,14 @@
>   		reg = <0x20000000 0x8000000>;
>   	};
>
> +	clocks {
> +		adc_op_clk: adc_op_clk{
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <20000000>;
> +		};
> +	};
> +
>   	ahb {
>   		compatible = "simple-bus";
>   		#address-cells = <1>;
> @@ -79,6 +88,8 @@
>   				status = "disabled";
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +				clocks = <&periph 21>;
> +				clock-names = "mci_clk";
>   			};
>
>   			spi0: spi@f0004000 {
> @@ -92,6 +103,8 @@
>   				dma-names = "tx", "rx";
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_spi0>;
> +				clocks = <&periph 24>;
> +				clock-names = "spi_clk";
>   				status = "disabled";
>   			};
>
> @@ -101,6 +114,8 @@
>   				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
> +				clocks = <&periph 38>;
> +				clock-names = "pclk";
>   				status = "disabled";
>   			};
>
> @@ -108,6 +123,8 @@
>   				compatible = "atmel,at91sam9x5-tcb";
>   				reg = <0xf0010000 0x100>;
>   				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&periph 26>;
> +				clock-names = "t0_clk";
>   			};
>
>   			i2c0: i2c@f0014000 {
> @@ -121,6 +138,7 @@
>   				pinctrl-0 = <&pinctrl_i2c0>;
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +				clocks = <&periph 18>;
>   				status = "disabled";
>   			};
>
> @@ -135,6 +153,7 @@
>   				pinctrl-0 = <&pinctrl_i2c1>;
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +				clocks = <&periph 19>;
>   				status = "disabled";
>   			};
>
> @@ -144,6 +163,8 @@
>   				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 5>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_usart0>;
> +				clocks = <&periph 12>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>
> @@ -153,6 +174,8 @@
>   				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 5>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_usart1>;
> +				clocks = <&periph 13>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>
> @@ -174,6 +197,8 @@
>   				status = "disabled";
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +				clocks = <&periph 22>;
> +				clock-names = "mci_clk";
>   			};
>
>   			spi1: spi@f8008000 {
> @@ -187,6 +212,8 @@
>   				dma-names = "tx", "rx";
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_spi1>;
> +				clocks = <&periph 25>;
> +				clock-names = "spi_clk";
>   				status = "disabled";
>   			};
>
> @@ -196,6 +223,8 @@
>   				interrupts = <39 IRQ_TYPE_LEVEL_HIGH 4>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
> +				clocks = <&periph 39>;
> +				clock-names = "pclk";
>   				status = "disabled";
>   			};
>
> @@ -219,6 +248,9 @@
>   					&pinctrl_adc0_ad10
>   					&pinctrl_adc0_ad11
>   					>;
> +				clocks = <&periph 29>,
> +					 <&adc_op_clk>;
> +				clock-names = "adc_clk", "adc_op_clk";
>   				atmel,adc-channel-base = <0x50>;
>   				atmel,adc-channels-used = <0xfff>;
>   				atmel,adc-drdy-mask = <0x1000000>;
> @@ -274,6 +306,7 @@
>   				dma-names = "tx", "rx";
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> +				clocks = <&periph 20>;
>   				status = "disabled";
>   			};
>
> @@ -283,6 +316,8 @@
>   				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_usart2>;
> +				clocks = <&periph 14>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>
> @@ -292,6 +327,8 @@
>   				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_usart3>;
> +				clocks = <&periph 15>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>
> @@ -318,6 +355,8 @@
>   				reg = <0xffffe600 0x200>;
>   				interrupts = <30 IRQ_TYPE_LEVEL_HIGH 0>;
>   				#dma-cells = <2>;
> +				clocks = <&periph 30>;
> +				clock-names = "dma_clk";
>   			};
>
>   			dma1: dma-controller@ffffe800 {
> @@ -325,6 +364,8 @@
>   				reg = <0xffffe800 0x200>;
>   				interrupts = <31 IRQ_TYPE_LEVEL_HIGH 0>;
>   				#dma-cells = <2>;
> +				clocks = <&periph 31>;
> +				clock-names = "dma_clk";
>   			};
>
>   			ramc0: ramc@ffffea00 {
> @@ -338,6 +379,8 @@
>   				interrupts = <2 IRQ_TYPE_LEVEL_HIGH 7>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_dbgu>;
> +				clocks = <&periph 2>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>
> @@ -626,6 +669,7 @@
>   					gpio-controller;
>   					interrupt-controller;
>   					#interrupt-cells = <2>;
> +					clocks = <&periph 6>;
>   				};
>
>   				pioB: gpio@fffff400 {
> @@ -636,6 +680,7 @@
>   					gpio-controller;
>   					interrupt-controller;
>   					#interrupt-cells = <2>;
> +					clocks = <&periph 7>;
>   				};
>
>   				pioC: gpio@fffff600 {
> @@ -646,6 +691,7 @@
>   					gpio-controller;
>   					interrupt-controller;
>   					#interrupt-cells = <2>;
> +					clocks = <&periph 8>;
>   				};
>
>   				pioD: gpio@fffff800 {
> @@ -656,6 +702,7 @@
>   					gpio-controller;
>   					interrupt-controller;
>   					#interrupt-cells = <2>;
> +					clocks = <&periph 9>;
>   				};
>
>   				pioE: gpio@fffffa00 {
> @@ -666,12 +713,286 @@
>   					gpio-controller;
>   					interrupt-controller;
>   					#interrupt-cells = <2>;
> +					clocks = <&periph 10>;
>   				};
>   			};
>
>   			pmc: pmc@fffffc00 {
> -				compatible = "atmel,at91rm9200-pmc";
> +				compatible = "atmel,sama5d3-pmc";
>   				reg = <0xfffffc00 0x120>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				interrupt-controller;
> +				#interrupt-cells = <1>;
> +
> +				clk32k: slck {
> +					compatible = "fixed-clock";
> +					#clock-cells = <0>;
> +					clock-frequency = <32768>;
> +				};
> +
> +				main: mainck {
> +					compatible = "atmel,at91rm9200-clk-main";
> +					interrupt-parent = <&pmc>;
> +					interrupts = <AT91_PMC_MOSCS>;
> +					#clock-cells = <0>;
> +					clocks = <&clk32k>;
> +				};
> +
> +				plla: pllack {
> +					compatible = "atmel,sama5d3-clk-pll";
> +					interrupt-parent = <&pmc>;
> +					interrupts = <AT91_PMC_LOCKA>;
> +					#clock-cells = <0>;
> +					clocks = <&main>;
> +					atmel,clk-id = <0>;
> +					atmel,clk-input-range = <8000000 50000000>;
> +					#atmel,pll-clk-output-range-cells = <4>;
> +					atmel,pll-clk-output-ranges = <400000000 1000000000 0 0>;
> +				};
> +
> +				plladiv: plladivck {
> +					compatible = "atmel,at91sam9x5-clk-plldiv";
> +					#clock-cells = <0>;
> +					clocks = <&plla>;
> +				};
> +
> +				utmi: utmick {
> +					compatible = "atmel,at91sam9x5-clk-utmi";
> +					interrupt-parent = <&pmc>;
> +					interrupts = <AT91_PMC_LOCKU>;
> +					#clock-cells = <0>;
> +					clocks = <&main>;
> +				};
> +
> +				mck: masterck {
> +					compatible = "atmel,at91sam9x5-clk-master";
> +					interrupt-parent = <&pmc>;
> +					interrupts = <AT91_PMC_MCKRDY>;
> +					#clock-cells = <0>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
> +					atmel,clk-output-range = <0 166000000>;
> +					atmel,clk-divisors = <1 2 4 3>;
> +				};
> +
> +				usb: usbck {
> +					compatible = "atmel,at91sam9x5-clk-usb";
> +					#clock-cells = <0>;
> +					clocks = <&plladiv>, <&utmi>;
> +				};
> +
> +				prog: progck {
> +					compatible = "atmel,at91sam9x5-clk-programmable";
> +					interrupt-parent = <&pmc>;
> +					#clock-cells = <1>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
> +
> +					prog0 {
> +						atmel,clk-id = <0>;
> +						interrupts = <AT91_PMC_PCKRDY(0)>;
> +					};
> +
> +					prog1 {
> +						atmel,clk-id = <1>;
> +						interrupts = <AT91_PMC_PCKRDY(1)>;
> +					};
> +
> +					prog2 {
> +						atmel,clk-id = <2>;
> +						interrupts = <AT91_PMC_PCKRDY(2)>;
> +					};
> +				};
> +
> +				smd: smdclk {
> +					compatible = "atmel,at91sam9x5-clk-smd";
> +					#clock-cells = <0>;
> +					clocks = <&plladiv>, <&utmi>;
> +				};
> +
> +				system: systemck {
> +					compatible = "atmel,at91rm9200-clk-system";
> +					#clock-cells = <1>;
> +
> +					ddrck {
> +						atmel,clk-id = <2>;
> +						clocks = <&mck>;
> +					};
> +
> +					smdck {
> +						atmel,clk-id = <4>;
> +						clocks = <&smd>;
> +					};
> +
> +					uhpck {
> +						atmel,clk-id = <6>;
> +						clocks = <&usb>;
> +					};
> +
> +					udpck {
> +						atmel,clk-id = <7>;
> +						clocks = <&usb>;
> +					};
> +
> +					pck0 {
> +						atmel,clk-id = <8>;
> +						clocks = <&prog 0>;
> +					};
> +
> +					pck1 {
> +						atmel,clk-id = <9>;
> +						clocks = <&prog 1>;
> +					};
> +
> +					pck2 {
> +						atmel,clk-id = <10>;
> +						clocks = <&prog 2>;
> +					};
> +				};
> +
> +				periph: periphck {
> +					compatible = "atmel,at91sam9x5-clk-peripheral";
> +					#clock-cells = <1>;
> +					clocks = <&mck>;
> +
> +					dbgu_clk {
> +						atmel,clk-id = <2>;
> +					};
> +
> +					pioA_clk {
> +						atmel,clk-id = <6>;
> +					};
> +
> +					pioB_clk {
> +						atmel,clk-id = <7>;
> +					};
> +
> +					pioC_clk {
> +						atmel,clk-id = <8>;
> +					};
> +
> +					pioD_clk {
> +						atmel,clk-id = <9>;
> +					};
> +
> +					pioE_clk {
> +						atmel,clk-id = <10>;
> +					};
> +
> +					usart0_clk {
> +						atmel,clk-id = <12>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					usart1_clk {
> +						atmel,clk-id = <13>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					usart2_clk {
> +						atmel,clk-id = <14>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					usart3_clk {
> +						atmel,clk-id = <15>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					twi0_clk {
> +						atmel,clk-id = <18>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					twi1_clk {
> +						atmel,clk-id = <19>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					twi2_clk {
> +						atmel,clk-id = <20>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					mci0_clk {
> +						atmel,clk-id = <21>;
> +					};
> +
> +					mci1_clk {
> +						atmel,clk-id = <22>;
> +					};
> +
> +					spi0_clk {
> +						atmel,clk-id = <24>;
> +					};
> +
> +					spi1_clk {
> +						atmel,clk-id = <25>;
> +					};
> +
> +					tcb0_clk {
> +						atmel,clk-id = <26>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					pwm_clk {
> +						atmel,clk-id = <28>;
> +					};
> +
> +					adc_clk {
> +						atmel,clk-id = <29>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					dma0_clk {
> +						atmel,clk-id = <30>;
> +					};
> +
> +					dma1_clk {
> +						atmel,clk-id = <31>;
> +					};
> +
> +					uhphs_clk {
> +						atmel,clk-id = <32>;
> +					};
> +
> +					udphs_clk {
> +						atmel,clk-id = <33>;
> +					};
> +
> +					isi_clk {
> +						atmel,clk-id = <37>;
> +					};
> +
> +					ssc0_clk {
> +						atmel,clk-id = <38>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					ssc1_clk {
> +						atmel,clk-id = <39>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					sha_clk {
> +						atmel,clk-id = <42>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV8>;
> +					};
> +
> +					aes_clk {
> +						atmel,clk-id = <43>;
> +					};
> +
> +					tdes_clk {
> +						atmel,clk-id = <44>;
> +					};
> +
> +					trng_clk {
> +						atmel,clk-id = <45>;
> +					};
> +
> +					fuse_clk {
> +						atmel,clk-id = <48>;
> +					};
> +				};
>   			};
>
>   			rstc@fffffe00 {
> @@ -683,6 +1004,7 @@
>   				compatible = "atmel,at91sam9260-pit";
>   				reg = <0xfffffe30 0xf>;
>   				interrupts = <3 IRQ_TYPE_LEVEL_HIGH 5>;
> +				clocks = <&mck>;
>   			};
>
>   			watchdog@fffffe40 {
> @@ -705,6 +1027,8 @@
>   			reg = <0x00500000 0x100000
>   			       0xf8030000 0x4000>;
>   			interrupts = <33 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&periph 33>, <&utmi>;
> +			clock-names = "pclk", "hclk";
>   			status = "disabled";
>
>   			ep0 {
> @@ -817,6 +1141,9 @@
>   			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
>   			reg = <0x00600000 0x100000>;
>   			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&usb>, <&periph 32>, <&periph 32>,
> +				 <&system 6>;
> +			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
>   			status = "disabled";
>   		};
>
> @@ -824,6 +1151,8 @@
>   			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
>   			reg = <0x00700000 0x100000>;
>   			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&usb>, <&periph 32>, <&system 6>;
> +			clock-names = "usb_clk", "ehci_clk", "uhpck";
>   			status = "disabled";
>   		};
>
> diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3_can.dtsi
> index 8ed3260..019a0d5 100644
> --- a/arch/arm/boot/dts/sama5d3_can.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_can.dtsi
> @@ -32,12 +32,28 @@
>
>   			};
>
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					can0_clk {
> +						atmel,clk-id = <40>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					can1_clk {
> +						atmel,clk-id = <41>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +				};
> +			};
> +
>   			can0: can@f000c000 {
>   				compatible = "atmel,at91sam9x5-can";
>   				reg = <0xf000c000 0x300>;
>   				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_can0_rx_tx>;
> +				clocks = <&periph 40>;
> +				clock-names = "can_clk";
>   				status = "disabled";
>   			};
>
> @@ -47,6 +63,8 @@
>   				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_can1_rx_tx>;
> +				clocks = <&periph 41>;
> +				clock-names = "can_clk";
>   				status = "disabled";
>   			};
>   		};
> diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
> index 4d4f351..15f00e5 100644
> --- a/arch/arm/boot/dts/sama5d3_emac.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
> @@ -31,12 +31,22 @@
>   				};
>   			};
>
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					macb1_clk {
> +						atmel,clk-id = <35>;
> +					};
> +				};
> +			};
> +
>   			macb1: ethernet@f802c000 {
>   				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>   				reg = <0xf802c000 0x100>;
>   				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_macb1_rmii>;
> +				clocks = <&periph 35>, <&periph 35>;
> +				clock-names = "hclk", "pclk";
>   				status = "disabled";
>   			};
>   		};
> diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
> index 0ba8be3..04f8a80 100644
> --- a/arch/arm/boot/dts/sama5d3_gmac.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
> @@ -64,12 +64,22 @@
>   				};
>   			};
>
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					macb0_clk {
> +						atmel,clk-id = <34>;
> +					};
> +				};
> +			};
> +
>   			macb0: ethernet@f0028000 {
>   				compatible = "cdns,pc302-gem", "cdns,gem";
>   				reg = <0xf0028000 0x100>;
>   				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
> +				clocks = <&periph 34>, <&periph 34>;
> +				clock-names = "hclk", "pclk";
>   				status = "disabled";
>   			};
>   		};
> diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
> index 01f52a7..bcb0e47 100644
> --- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
> @@ -50,6 +50,21 @@
>   					};
>   				};
>   			};
> +
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					lcdc_clk {
> +						atmel,clk-id = <36>;
> +					};
> +				};
> +
> +				system: systemck {
> +					lcdck {
> +						atmel,clk-id = <3>;
> +						clocks = <&mck>;
> +					};
> +				};
> +			};
>   		};
>   	};
>   };
> diff --git a/arch/arm/boot/dts/sama5d3_mci2.dtsi b/arch/arm/boot/dts/sama5d3_mci2.dtsi
> index 38e88e3..72b0d00 100644
> --- a/arch/arm/boot/dts/sama5d3_mci2.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_mci2.dtsi
> @@ -9,6 +9,7 @@
>
>   #include <dt-bindings/pinctrl/at91.h>
>   #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/clk/at91.h>
>
>   / {
>   	ahb {
> @@ -30,6 +31,14 @@
>   				};
>   			};
>
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					mci2_clk {
> +						atmel,clk-id = <23>;
> +					};
> +				};
> +			};
> +
>   			mmc2: mmc@f8004000 {
>   				compatible = "atmel,hsmci";
>   				reg = <0xf8004000 0x600>;
> @@ -38,6 +47,8 @@
>   				dma-names = "rxtx";
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
> +				clocks = <&periph 23>;
> +				clock-names = "mci_clk";
>   				status = "disabled";
>   				#address-cells = <1>;
>   				#size-cells = <0>;
> diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
> index 5264bb4..de1c7b6 100644
> --- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
> @@ -9,6 +9,7 @@
>
>   #include <dt-bindings/pinctrl/at91.h>
>   #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/clk/at91.h>
>
>   / {
>   	aliases {
> @@ -17,10 +18,21 @@
>
>   	ahb {
>   		apb {
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					tcb1_clk {
> +						atmel,clk-id = <27>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +				};
> +			};
> +
>   			tcb1: timer@f8014000 {
>   				compatible = "atmel,at91sam9x5-tcb";
>   				reg = <0xf8014000 0x100>;
>   				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&periph 27>;
> +				clock-names = "t0_clk";
>   			};
>   		};
>   	};
> diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
> index 98fcb2d..483705e 100644
> --- a/arch/arm/boot/dts/sama5d3_uart.dtsi
> +++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
> @@ -9,6 +9,7 @@
>
>   #include <dt-bindings/pinctrl/at91.h>
>   #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/clk/at91.h>
>
>   / {
>   	ahb {
> @@ -31,12 +32,28 @@
>   				};
>   			};
>
> +			pmc: pmc@fffffc00 {
> +				periph: periphck {
> +					uart0_clk {
> +						atmel,clk-id = <16>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +
> +					uart1_clk {
> +						atmel,clk-id = <17>;
> +						atmel,clk-default-divisor = <AT91SAM9X5_PERIPH_CLK_DIV2>;
> +					};
> +				};
> +			};
> +
>   			uart0: serial@f0024000 {
>   				compatible = "atmel,at91sam9260-usart";
>   				reg = <0xf0024000 0x200>;
>   				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_uart0>;
> +				clocks = <&periph 16>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>
> @@ -46,6 +63,8 @@
>   				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
>   				pinctrl-names = "default";
>   				pinctrl-0 = <&pinctrl_uart1>;
> +				clocks = <&periph 17>;
> +				clock-names = "usart";
>   				status = "disabled";
>   			};
>   		};
>


-- 
Nicolas Ferre
