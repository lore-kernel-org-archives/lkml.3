Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaBLR2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:28:48 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45875 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752471AbaBLR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:28:47 -0500
Date: Wed, 12 Feb 2014 18:28:44 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        gregory.clement@free-electrons.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/8] at91: dt: Add at91sam9261 dt SoC support
Message-ID: <20140212172844.GE11498@piout.net>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
 <1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/02/2014 at 11:06:42 +0100, Jean-Jacques Hiblot wrote :
> This patch adds support for the Device Tree on a sam9261-based platform
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/boot/dts/at91sam9261.dtsi | 740 +++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/at91sam9261.c   |  17 +
>  2 files changed, 757 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi

[...]

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

You probably copied/pasted it but according to the block diagram, the
sdram controller is not under the apb.

> +			matrix: matrix@ffffee00 {
> +				compatible = "atmel,at91sam9261-bus-matrix";
> +				reg = <0xffffee00 0x200>;
> +			};
> +

Same here, the apb is actually under the bus matrix.

I don't know whether it can be represented another way though.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
