Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaCCSk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:40:27 -0500
Received: from top.free-electrons.com ([176.31.233.9]:36453 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536AbaCCSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:40:26 -0500
Date: Mon, 3 Mar 2014 19:40:23 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com
Subject: Re: [PATCH v5 4/9] at91: dt: Add at91sam9261 dt SoC support
Message-ID: <20140303184023.GG3155@piout.net>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
 <1393841162-25339-5-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393841162-25339-5-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 at 11:05:57 +0100, Jean-Jacques Hiblot wrote :
> This patch adds support for the Device Tree on a sam9261-based platform
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/boot/dts/at91sam9261.dtsi | 740 +++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/at91sam9261.c   |  17 +
>  2 files changed, 757 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
> 
> diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
> new file mode 100644
> index 0000000..b40b91e
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9261.dtsi
> @@ -0,0 +1,740 @@
> +/*
> + * at91sam9261.dtsi - Device Tree Include file for AT91SAM9261 SoC
> + *
> + *  Copyright (C) 2013 Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> + *
> + * Licensed under GPLv2 only.
> + */
> +
> +#include "skeleton.dtsi"
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/clk/at91.h>
> +
> +/ {
> +	model = "Atmel AT91SAM9261 family SoC";
> +	compatible = "atmel,at91sam9261";
> +	interrupt-parent = <&aic>;
> +
> +	aliases {
> +		serial0 = &dbgu;
> +		serial1 = &usart0;
> +		serial2 = &usart1;
> +		serial3 = &usart2;
> +		gpio0 = &pioA;
> +		gpio1 = &pioB;
> +		gpio2 = &pioC;
> +		tcb0 = &tcb0;
> +		i2c0 = &i2c0;
> +		ssc0 = &ssc0;
> +		ssc1 = &ssc1;
> +	};
> +
> +	cpus {
> +		#address-cells = <0>;
> +		#size-cells = <0>;
> +
> +		cpu {
> +			compatible = "arm,arm926ej-s";
> +			device_type = "cpu";
> +		};
> +	};
> +
> +	memory {
> +		reg = <0x20000000 0x08000000>;
> +	};
> +
> +	ahb {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		usb0: ohci@00500000 {
> +			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
> +			reg = <0x00500000 0x100000>;
> +			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&usb>, <&ohci_clk>, <&hclk0>, <&uhpck>;
> +			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
> +			status = "disabled";
> +		};
> +
> +		fb0: fb@0x00600000 {
> +			compatible = "atmel,at91sam9261-lcdc";
> +			reg = <0x00600000 0x1000>;
> +			interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_fb>;
> +			clocks = <&lcd_clk>, <&hclk1>;
> +			clock-names = "lcdc_clk", "hclk";
> +			status = "disabled";
> +		};
> +
> +		nand0: nand@40000000 {
> +			compatible = "atmel,at91rm9200-nand";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <0x40000000 0x10000000>;
> +			atmel,nand-addr-offset = <22>;
> +			atmel,nand-cmd-offset = <21>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_nand>;
> +
> +			gpios = <&pioC 15 GPIO_ACTIVE_HIGH
> +				&pioC 14 GPIO_ACTIVE_HIGH
> +				0
> +				>;

Nit: please bracket list entries individually. Also for other list
properties like reg, interrupts and atmel,pins.

> +			status = "disabled";
> +		};
> +
> +		apb {
> +			compatible = "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +
> +			tcb0: timer@fffa0000 {
> +				compatible = "atmel,at91rm9200-tcb";
> +				reg = <0xfffa0000 0x100>;
> +				interrupts = < 17 IRQ_TYPE_LEVEL_HIGH 0
> +					18 IRQ_TYPE_LEVEL_HIGH 0
> +					19 IRQ_TYPE_LEVEL_HIGH 0
> +					>;
> +				clocks = <&tc0_clk>, <&tc1_clk>, <&tc2_clk>;
> +				clock-names = "t0_clk", "t1_clk", "t2_clk";
> +			};
> +
> +			usb1: gadget@fffa4000 {
> +				compatible = "atmel,at91rm9200-udc";
> +				reg = <0xfffa4000 0x4000>;
> +				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
> +				clocks = <&usb>, <&udc_clk>, <&udpck>;
> +				clock-names = "usb_clk", "udc_clk", "udpck";
> +				status = "disabled";
> +			};
> +
> +			mmc0: mmc@fffa8000 {
> +				compatible = "atmel,hsmci";
> +				reg = <0xfffa8000 0x600>;
> +				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 0>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_mmc0_clk>, <&pinctrl_mmc0_slot0_cmd_dat0>, <&pinctrl_mmc0_slot0_dat1_3>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				clocks = <&mci0_clk>;
> +				clock-names = "mci_clk";
> +				status = "disabled";
> +			};
> +
> +			i2c0: i2c@fffac000 {
> +				compatible = "atmel,at91sam9261-i2c";
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_i2c_twi>;
> +				reg = <0xfffac000 0x100>;
> +				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				clocks = <&twi0_clk>;
> +				status = "disabled";
> +			};
> +
> +			usart0: serial@fffb0000 {
> +				compatible = "atmel,at91sam9260-usart";
> +				reg = <0xfffb0000 0x200>;
> +				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_usart0>;
> +				clocks = <&usart0_clk>;
> +				clock-names = "usart";
> +				status = "disabled";
> +			};
> +
> +			usart1: serial@fffb4000 {
> +				compatible = "atmel,at91sam9260-usart";
> +				reg = <0xfffb4000 0x200>;
> +				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_usart1>;
> +				clocks = <&usart1_clk>;
> +				clock-names = "usart";
> +				status = "disabled";
> +			};
> +
> +			usart2: serial@fffb8000{
> +				compatible = "atmel,at91sam9260-usart";
> +				reg = <0xfffb8000 0x200>;
> +				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
> +				atmel,use-dma-rx;
> +				atmel,use-dma-tx;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_usart2>;
> +				clocks = <&usart2_clk>;
> +				clock-names = "usart";
> +				status = "disabled";
> +			};
> +
> +			ssc0: ssc@fffbc000 {
> +				compatible = "atmel,at91rm9200-ssc";
> +				reg = <0xfffbc000 0x4000>;
> +				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
> +				status = "disabled";
> +			};
> +
> +			ssc1: ssc@fffc0000 {
> +				compatible = "atmel,at91rm9200-ssc";
> +				reg = <0xfffc0000 0x4000>;
> +				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
> +				status = "disabled";
> +			};
> +
> +			spi0: spi@fffc8000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91rm9200-spi";
> +				reg = <0xfffc8000 0x200>;
> +				cs-gpios = <0>, <0>, <0>, <0>;
> +				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi0>;
> +				clocks = <&spi0_clk>;
> +				clock-names = "spi_clk";
> +				status = "disabled";
> +			};
> +
> +			spi1: spi@fffcc000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "atmel,at91rm9200-spi";
> +				reg = <0xfffcc000 0x200>;
> +				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi1>;
> +				clocks = <&spi1_clk>;
> +				clock-names = "spi_clk";
> +				status = "disabled";
> +			};
> +
> +			ramc: ramc@ffffea00 {
> +				compatible = "atmel,at91sam9260-sdramc";
> +				reg = <0xffffea00 0x200>;
> +			};
> +
> +			matrix: matrix@ffffee00 {
> +				compatible = "atmel,at91sam9260-bus-matrix";
> +				reg = <0xffffee00 0x200>;
> +			};
> +
> +			aic: interrupt-controller@fffff000 {
> +				#interrupt-cells = <3>;
> +				compatible = "atmel,at91rm9200-aic";
> +				interrupt-controller;
> +				reg = <0xfffff000 0x200>;
> +				atmel,external-irqs = <29 30 31>;
> +			};
> +
> +			dbgu: serial@fffff200 {
> +				compatible = "atmel,at91sam9260-usart";
> +				reg = <0xfffff200 0x200>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_dbgu>;
> +				clocks = <&mck>;
> +				clock-names = "usart";
> +				status = "disabled";
> +			};
> +
> +			pinctrl@fffff400 {
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
> +				ranges = <0xfffff400 0xfffff400 0x600>;
> +
> +				atmel,mux-mask = <
> +				      /*    A         B     */
> +				       0xffffffff 0xfffffff7  /* pioA */
> +				       0xffffffff 0xfffffff4  /* pioB */
> +				       0xffffffff 0xffffff07  /* pioC */
> +				      >;
> +
> +				/* shared pinctrl settings */
> +				dbgu {
> +					pinctrl_dbgu: dbgu-0 {
> +						atmel,pins =
> +							<AT91_PIOA 9  AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
> +					};
> +				};
> +
> +				usart0 {
> +					pinctrl_usart0: usart0-0 {
> +						atmel,pins =
> +							<AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
> +							 AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_usart0_rts: usart0_rts-0 {
> +						atmel,pins =
> +							<AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_usart0_cts: usart0_cts-0 {
> +						atmel,pins =
> +							<AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				usart1 {
> +					pinctrl_usart1: usart1-0 {
> +						atmel,pins =
> +							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
> +							 AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_usart1_rts: usart1_rts-0 {
> +						atmel,pins =
> +							<AT91_PIOA 12 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_usart1_cts: usart1_cts-0 {
> +						atmel,pins =
> +							<AT91_PIOA 13 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				usart2 {
> +					pinctrl_usart2: usart2-0 {
> +						atmel,pins =
> +							<AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
> +							 AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_usart2_rts: usart2_rts-0 {
> +						atmel,pins =
> +							<AT91_PIOA 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_usart2_cts: usart2_cts-0 {
> +						atmel,pins =
> +							<AT91_PIOA 16 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				nand {
> +					pinctrl_nand: nand-0 {
> +						atmel,pins =
> +							<AT91_PIOC 15 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP
> +							 AT91_PIOC 14 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;
> +					};
> +				};
> +
> +				mmc0 {
> +					pinctrl_mmc0_clk: mmc0_clk-0 {
> +						atmel,pins =
> +							<AT91_PIOA 2 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_mmc0_slot0_cmd_dat0: mmc0_slot0_cmd_dat0-0 {
> +						atmel,pins =
> +							<AT91_PIOA 1 AT91_PERIPH_B AT91_PINCTRL_PULL_UP
> +							 AT91_PIOA 0 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;
> +					};
> +
> +					pinctrl_mmc0_slot0_dat1_3: mmc0_slot0_dat1_3-0 {
> +						atmel,pins =
> +							<AT91_PIOA 4 AT91_PERIPH_B AT91_PINCTRL_PULL_UP
> +							 AT91_PIOA 5 AT91_PERIPH_B AT91_PINCTRL_PULL_UP
> +							 AT91_PIOA 6 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;
> +					};
> +					};
> +
> +				ssc0 {
> +					pinctrl_ssc0_tx: ssc0_tx-0 {
> +						atmel,pins =
> +							<AT91_PIOB 21 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 22 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 23 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_ssc0_rx: ssc0_rx-0 {
> +						atmel,pins =
> +							<AT91_PIOB 24 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 25 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 26 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				ssc1 {
> +					pinctrl_ssc1_tx: ssc1_tx-0 {
> +						atmel,pins =
> +							<AT91_PIOA 17 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOA 18 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOA 19 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_ssc1_rx: ssc1_rx-0 {
> +						atmel,pins =
> +							<AT91_PIOA 20 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOA 21 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOA 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				spi0 {
> +					pinctrl_spi0: spi0-0 {
> +						atmel,pins =
> +							<AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +					};
> +
> +				spi1 {
> +					pinctrl_spi1: spi1-0 {
> +						atmel,pins =
> +							<AT91_PIOB 30 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 31 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				tcb0 {
> +					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
> +						atmel,pins = <AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tclk1: tcb0_tclk1-0 {
> +						atmel,pins = <AT91_PIOC 17 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tclk2: tcb0_tclk2-0 {
> +						atmel,pins = <AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tioa0: tcb0_tioa0-0 {
> +						atmel,pins = <AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tioa1: tcb0_tioa1-0 {
> +						atmel,pins = <AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tioa2: tcb0_tioa2-0 {
> +						atmel,pins = <AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tiob0: tcb0_tiob0-0 {
> +						atmel,pins = <AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tiob1: tcb0_tiob1-0 {
> +						atmel,pins = <AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +
> +					pinctrl_tcb0_tiob2: tcb0_tiob2-0 {
> +						atmel,pins = <AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				i2c0 {
> +					pinctrl_i2c_bitbang: i2c-0-bitbang {
> +						atmel,pins =
> +							<AT91_PIOA 7 AT91_PERIPH_GPIO AT91_PINCTRL_NONE
> +							AT91_PIOA 8 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
> +					};
> +					pinctrl_i2c_twi: i2c-0-twi {
> +						atmel,pins =
> +							<AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> +					};
> +				};
> +
> +				fb {
> +					pinctrl_fb: fb-0 {
> +						atmel,pins =
> +							<AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 19 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 20 AT91_PERIPH_A AT91_PINCTRL_NONE
> +							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 AT91_PIOB 28 AT91_PERIPH_B AT91_PINCTRL_NONE
> +							 >;
> +					};
> +				};
> +
> +				pioA: gpio@fffff400 {
> +					compatible = "atmel,at91rm9200-gpio";
> +					reg = <0xfffff400 0x200>;
> +					interrupts = <2 IRQ_TYPE_LEVEL_HIGH 1>;
> +					#gpio-cells = <2>;
> +					gpio-controller;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					clocks = <&pioA_clk>;
> +				};
> +
> +				pioB: gpio@fffff600 {
> +					compatible = "atmel,at91rm9200-gpio";
> +					reg = <0xfffff600 0x200>;
> +					interrupts = <3 IRQ_TYPE_LEVEL_HIGH 1>;
> +					#gpio-cells = <2>;
> +					gpio-controller;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					clocks = <&pioB_clk>;
> +				};
> +
> +				pioC: gpio@fffff800 {
> +					compatible = "atmel,at91rm9200-gpio";
> +					reg = <0xfffff800 0x200>;
> +					interrupts = <4 IRQ_TYPE_LEVEL_HIGH 1>;
> +					#gpio-cells = <2>;
> +					gpio-controller;
> +					interrupt-controller;
> +					#interrupt-cells = <2>;
> +					clocks = <&pioC_clk>;
> +				};
> +			};
> +
> +			pmc: pmc@fffffc00 {
> +				compatible = "atmel,at91rm9200-pmc";
> +				reg = <0xfffffc00 0x100>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				interrupt-controller;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
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
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
> +					clocks = <&clk32k>;
> +				};
> +
> +				plla: pllack {
> +					compatible = "atmel,at91rm9200-clk-pll";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_LOCKA>;
> +					clocks = <&main>;
> +					reg = <0>;
> +					atmel,clk-input-range = <1000000 32000000>;
> +					#atmel,pll-clk-output-range-cells = <4>;
> +					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
> +				};
> +
> +				pllb: pllbck {
> +					compatible = "atmel,at91rm9200-clk-pll";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
> +					clocks = <&main>;
> +					reg = <1>;
> +					atmel,clk-input-range = <1000000 32000000>;
> +					#atmel,pll-clk-output-range-cells = <4>;
> +					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
> +				};
> +
> +				mck: masterck {
> +					compatible = "atmel,at91rm9200-clk-master";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
> +					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
> +					atmel,clk-output-range = <0 94000000>;
> +					atmel,clk-divisors = <1 2 4 3>;
> +				};
> +
> +				usb: usbck {
> +					compatible = "atmel,at91rm9200-clk-usb";
> +					#clock-cells = <0>;
> +					atmel,clk-divisors = <1 2 4 3>;
> +					clocks = <&pllb>;
> +				};
> +
> +				systemck {
> +					compatible = "atmel,at91rm9200-clk-system";
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					uhpck: uhpck {
> +						#clock-cells = <0>;
> +						reg = <6>;
> +						clocks = <&usb>;
> +					};
> +
> +					udpck: udpck {
> +						#clock-cells = <0>;
> +						reg = <7>;
> +						clocks = <&usb>;
> +					};
> +
> +					hclk0: hclk0 {
> +						#clock-cells = <0>;
> +						reg = <16>;
> +						clocks = <&mck>;
> +					};
> +
> +					hclk1: hclk1 {
> +						#clock-cells = <0>;
> +						reg = <17>;
> +						clocks = <&mck>;
> +					};
> +				};
> +
> +				periphck {
> +					compatible = "atmel,at91rm9200-clk-peripheral";
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					clocks = <&mck>;
> +
> +					pioA_clk: pioA_clk {
> +						#clock-cells = <0>;
> +						reg = <2>;
> +					};
> +
> +					pioB_clk: pioB_clk {
> +						#clock-cells = <0>;
> +						reg = <3>;
> +					};
> +
> +					pioC_clk: pioC_clk {
> +						#clock-cells = <0>;
> +						reg = <4>;
> +					};
> +
> +					usart0_clk: usart0_clk {
> +						#clock-cells = <0>;
> +						reg = <6>;
> +					};
> +
> +					usart1_clk: usart1_clk {
> +						#clock-cells = <0>;
> +						reg = <7>;
> +					};
> +
> +					usart2_clk: usart2_clk {
> +						#clock-cells = <0>;
> +						reg = <8>;
> +					};
> +
> +					mci0_clk: mci0_clk {
> +						#clock-cells = <0>;
> +						reg = <9>;
> +					};
> +
> +					udc_clk: udc_clk {
> +						#clock-cells = <0>;
> +						reg = <10>;
> +					};
> +
> +					twi0_clk: twi0_clk {
> +						reg = <11>;
> +						#clock-cells = <0>;
> +					};
> +
> +					spi0_clk: spi0_clk {
> +						#clock-cells = <0>;
> +						reg = <12>;
> +					};
> +
> +					spi1_clk: spi1_clk {
> +						#clock-cells = <0>;
> +						reg = <13>;
> +					};
> +
> +					tc0_clk: tc0_clk {
> +						#clock-cells = <0>;
> +						reg = <17>;
> +					};
> +
> +					tc1_clk: tc1_clk {
> +						#clock-cells = <0>;
> +						reg = <18>;
> +					};
> +
> +					tc2_clk: tc2_clk {
> +						#clock-cells = <0>;
> +						reg = <19>;
> +					};
> +
> +					ohci_clk: ohci_clk {
> +						#clock-cells = <0>;
> +						reg = <20>;
> +					};
> +
> +					lcd_clk: lcd_clk {
> +						#clock-cells = <0>;
> +						reg = <21>;
> +					};
> +				};
> +			};
> +
> +			rstc@fffffd00 {
> +				compatible = "atmel,at91sam9260-rstc";
> +				reg = <0xfffffd00 0x10>;
> +			};
> +
> +			shdwc@fffffd10 {
> +				compatible = "atmel,at91sam9260-shdwc";
> +				reg = <0xfffffd10 0x10>;
> +			};
> +
> +			pit: timer@fffffd30 {
> +				compatible = "atmel,at91sam9260-pit";
> +				reg = <0xfffffd30 0xf>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&mck>;
> +			};
> +
> +			watchdog@fffffd40 {
> +				compatible = "atmel,at91sam9260-wdt";
> +				reg = <0xfffffd40 0x10>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				status = "disabled";
> +			};
> +		};
> +	};
> +
> +	i2c@0 {
> +		compatible = "i2c-gpio";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_i2c_bitbang>;
> +		gpios = <&pioA 7 GPIO_ACTIVE_HIGH /* sda */
> +			 &pioA 8 GPIO_ACTIVE_HIGH /* scl */
> +			>;
> +		i2c-gpio,sda-open-drain;
> +		i2c-gpio,scl-open-drain;
> +		i2c-gpio,delay-us = <2>;	/* ~100 kHz */
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		status = "disabled";
> +	};
> +};
> diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
> index 6276b4c..5c90581 100644
> --- a/arch/arm/mach-at91/at91sam9261.c
> +++ b/arch/arm/mach-at91/at91sam9261.c
> @@ -189,6 +189,23 @@ static struct clk_lookup periph_clocks_lookups[] = {
>  	CLKDEV_CON_ID("pioA", &pioA_clk),
>  	CLKDEV_CON_ID("pioB", &pioB_clk),
>  	CLKDEV_CON_ID("pioC", &pioC_clk),
> +	/* more lookup table for DT entries */
> +	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
> +	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
> +	CLKDEV_CON_DEV_ID("usart", "ffffb400.serial", &usart1_clk),
> +	CLKDEV_CON_DEV_ID("usart", "fff94000.serial", &usart2_clk),
> +	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
> +	CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
> +	CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
> +	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &hck0),
> +	CLKDEV_CON_DEV_ID("hclk", "600000.fb", &hck1),
> +	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
> +	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
> +	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
> +	CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi_clk),
> +	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
> +	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
> +	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
>  };
>  
>  static struct clk_lookup usart_clocks_lookups[] = {
> -- 
> 1.9.0
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
