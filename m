Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaBDUbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:31:05 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:49501 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaBDUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:31:03 -0500
Date: Tue, 4 Feb 2014 21:30:54 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] ARM: at91: add Atmel's SAMA5D3 Xplained board
Message-ID: <20140204203054.GA21958@ldesroches-Latitude-E6320>
Mail-Followup-To: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Boris BREZILLON <b.brezillon@overkiz.com>,
	linux-kernel@vger.kernel.org
References: <1391535767-30749-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1391535767-30749-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 06:42:47PM +0100, Nicolas Ferre wrote:
> Add DT file for new SAMA5D3 Xpained board.
> This board is based on Atmel's SAMA5D36 Cortex-A5 SoC.
> 

You may also add the board to the Makefile.

Ludovic

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/at91-sama5d3_xplained.dts | 233 ++++++++++++++++++++++++++++
>  1 file changed, 233 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts
> 
> diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> new file mode 100644
> index 000000000000..fb1349ca60a4
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> @@ -0,0 +1,233 @@
> +/*
> + * at91-sama5d3_xplained.dts - Device Tree file for the SAMA5D3 Xplained board
> + *
> + *  Copyright (C) 2014 Atmel,
> + *		  2014 Nicolas Ferre <nicolas.ferre@atmel.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +/dts-v1/;
> +#include "sama5d36.dtsi"
> +
> +/ {
> +	model = "SAMA5D3 Xplained";
> +	compatible = "atmel,sama5d3-xplained", "atmel,sama5d3", "atmel,sama5";
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200";
> +	};
> +
> +	memory {
> +		reg = <0x20000000 0x10000000>;
> +	};
> +
> +	ahb {
> +		apb {
> +			mmc0: mmc@f0000000 {
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_mmc0_clk_cmd_dat0 &pinctrl_mmc0_dat1_3 &pinctrl_mmc0_dat4_7 &pinctrl_mmc0_cd>;
> +				status = "okay";
> +				slot@0 {
> +					reg = <0>;
> +					bus-width = <8>;
> +					cd-gpios = <&pioE 0 GPIO_ACTIVE_LOW>;
> +				};
> +			};
> +
> +			spi0: spi@f0004000 {
> +				cs-gpios = <&pioD 13 0>, <0>, <0>, <0>;
> +				status = "okay";
> +			};
> +
> +			can0: can@f000c000 {
> +				status = "okay";
> +			};
> +
> +			i2c0: i2c@f0014000 {
> +				status = "okay";
> +			};
> +
> +			i2c1: i2c@f0018000 {
> +				status = "okay";
> +			};
> +
> +			macb0: ethernet@f0028000 {
> +				phy-mode = "rgmii";
> +				status = "okay";
> +			};
> +
> +			usart0: serial@f001c000 {
> +				status = "okay";
> +			};
> +
> +			usart1: serial@f0020000 {
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_usart1 &pinctrl_usart1_rts_cts>;
> +				status = "okay";
> +			};
> +
> +			uart0: serial@f0024000 {
> +				status = "okay";
> +			};
> +
> +			mmc1: mmc@f8000000 {
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_mmc1_clk_cmd_dat0 &pinctrl_mmc1_dat1_3 &pinctrl_mmc1_cd>;
> +				status = "okay";
> +				slot@0 {
> +					reg = <0>;
> +					bus-width = <4>;
> +					cd-gpios = <&pioE 1 GPIO_ACTIVE_HIGH>;
> +				};
> +			};
> +
> +			spi1: spi@f8008000 {
> +				cs-gpios = <&pioC 25 0>, <0>, <0>, <&pioD 16 0>;
> +				status = "okay";
> +			};
> +
> +			adc0: adc@f8018000 {
> +				pinctrl-names = "default";
> +				pinctrl-0 = <
> +					&pinctrl_adc0_adtrg
> +					&pinctrl_adc0_ad0
> +					&pinctrl_adc0_ad1
> +					&pinctrl_adc0_ad2
> +					&pinctrl_adc0_ad3
> +					&pinctrl_adc0_ad4
> +					&pinctrl_adc0_ad5
> +					&pinctrl_adc0_ad6
> +					&pinctrl_adc0_ad7
> +					&pinctrl_adc0_ad8
> +					&pinctrl_adc0_ad9
> +					>;
> +				status = "okay";
> +			};
> +
> +			i2c2: i2c@f801c000 {
> +				dmas = <0>, <0>;	/* Do not use DMA for i2c2 */
> +				status = "okay";
> +			};
> +
> +			macb1: ethernet@f802c000 {
> +				phy-mode = "rmii";
> +				status = "okay";
> +			};
> +
> +			dbgu: serial@ffffee00 {
> +				status = "okay";
> +			};
> +
> +			pinctrl@fffff200 {
> +				board {
> +					pinctrl_mmc0_cd: mmc0_cd {
> +						atmel,pins =
> +							<AT91_PIOE 0 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> +					};
> +
> +					pinctrl_mmc1_cd: mmc1_cd {
> +						atmel,pins =
> +							<AT91_PIOE 1 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> +					};
> +
> +					pinctrl_usba_vbus: usba_vbus {
> +						atmel,pins =
> +							<AT91_PIOE 9 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;	/* PE9, conflicts with A9 */
> +					};
> +				};
> +			};
> +
> +			pmc: pmc@fffffc00 {
> +				main: mainck {
> +					clock-frequency = <12000000>;
> +				};
> +			};
> +		};
> +
> +		nand0: nand@60000000 {
> +			nand-bus-width = <8>;
> +			nand-ecc-mode = "hw";
> +			atmel,has-pmecc;
> +			atmel,pmecc-cap = <4>;
> +			atmel,pmecc-sector-size = <512>;
> +			nand-on-flash-bbt;
> +			status = "okay";
> +
> +			at91bootstrap@0 {
> +				label = "at91bootstrap";
> +				reg = <0x0 0x40000>;
> +			};
> +
> +			bootloader@40000 {
> +				label = "bootloader";
> +				reg = <0x40000 0x80000>;
> +			};
> +
> +			bootloaderenv@c0000 {
> +				label = "bootloader env";
> +				reg = <0xc0000 0xc0000>;
> +			};
> +
> +			dtb@180000 {
> +				label = "device tree";
> +				reg = <0x180000 0x80000>;
> +			};
> +
> +			kernel@200000 {
> +				label = "kernel";
> +				reg = <0x200000 0x600000>;
> +			};
> +
> +			rootfs@800000 {
> +				label = "rootfs";
> +				reg = <0x800000 0x0f800000>;
> +			};
> +		};
> +
> +		usb0: gadget@00500000 {
> +			atmel,vbus-gpio = <&pioE 9 GPIO_ACTIVE_HIGH>;	/* PE9, conflicts with A9 */
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_usba_vbus>;
> +			status = "okay";
> +		};
> +
> +		usb1: ohci@00600000 {
> +			num-ports = <3>;
> +			atmel,vbus-gpio = <0
> +					   &pioE 3 GPIO_ACTIVE_LOW
> +					   &pioE 4 GPIO_ACTIVE_LOW
> +					  >;
> +			status = "okay";
> +		};
> +
> +		usb2: ehci@00700000 {
> +			status = "okay";
> +		};
> +	};
> +
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +
> +		bp3 {
> +			label = "PB_USER";
> +			gpios = <&pioE 29 GPIO_ACTIVE_LOW>;
> +			linux,code = <0x104>;
> +			gpio-key,wakeup;
> +		};
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		d2 {
> +			label = "d2";
> +			gpios = <&pioE 23 GPIO_ACTIVE_LOW>;	/* PE23, conflicts with A23, CTS2 */
> +			linux,default-trigger = "heartbeat";
> +		};
> +
> +		d3 {
> +			label = "d3";
> +			gpios = <&pioE 24 GPIO_ACTIVE_HIGH>;
> +		};
> +	};
> +};
> -- 
> 1.8.2.2
> 
