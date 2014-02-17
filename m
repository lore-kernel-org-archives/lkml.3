Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaBQKbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:31:04 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:11855 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBQKbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:31:01 -0500
Message-ID: <5301E4E1.60408@atmel.com>
Date: Mon, 17 Feb 2014 11:30:57 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 3/3] ARM: at91: dt: sam9rl: Device Tree for the at91sam9rlek
References: <1392426860-19589-1-git-send-email-alexandre.belloni@free-electrons.com> <1392426860-19589-4-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1392426860-19589-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2014 02:14, Alexandre Belloni :
> Add a device tree for the at91sam9rl-ek. For now it supports:
>  - MMC
>  - dbgu
>  - usart1
>  - watchdog
>  - nand
>  - leds
>  - buttons
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile         |   2 +
>  arch/arm/boot/dts/at91sam9rlek.dts | 151 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 153 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91sam9rlek.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index d57c1a65b24f..bb28e65d17ee 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -28,6 +28,8 @@ dtb-$(CONFIG_ARCH_AT91) += at91sam9m10g45ek.dtb
>  dtb-$(CONFIG_ARCH_AT91) += pm9g45.dtb
>  # sam9n12
>  dtb-$(CONFIG_ARCH_AT91) += at91sam9n12ek.dtb
> +# sam9rl
> +dtb-$(CONFIG_ARCH_AT91) += at91sam9rlek.dtb
>  # sam9x5
>  dtb-$(CONFIG_ARCH_AT91) += at91-ariag25.dtb
>  dtb-$(CONFIG_ARCH_AT91) += at91sam9g15ek.dtb
> diff --git a/arch/arm/boot/dts/at91sam9rlek.dts b/arch/arm/boot/dts/at91sam9rlek.dts
> new file mode 100644
> index 000000000000..5ec9589613a1
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9rlek.dts
> @@ -0,0 +1,151 @@
> +/*
> + * at91sam9rlek.dts - Device Tree file for Atmel at91sam9rl reference board
> + *
> + *  Copyright (C) 2014  Alexandre Belloni <alexandre.belloni@free-electrons.com>
> + *
> + * Licensed under GPLv2 only
> + */
> +/dts-v1/;
> +#include "at91sam9rl.dtsi"
> +
> +/ {
> +	model = "Atmel at91sam9rlek";
> +	compatible = "atmel,at91sam9rlek", "atmel,at91sam9rl", "atmel,at91sam9";
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200 rootfstype=ubifs root=ubi0:rootfs ubi.mtd=7 rw";

Isn't it ubi.mtd=5 according to the NAND layer below?

> +	};
> +
> +	memory {
> +		reg = <0x20000000 0x4000000>;
> +	};
> +
> +	clocks {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		main_clock: clock@0 {
> +			compatible = "atmel,osc", "fixed-clock";
> +			clock-frequency = <12000000>;
> +		};
> +	};
> +
> +	ahb {
> +		apb {
> +			mmc0: mmc@fffa4000 {

Use address ascending order, even for the board, please.

> +				pinctrl-0 = <
> +					&pinctrl_board_mmc0
> +					&pinctrl_mmc0_clk
> +					&pinctrl_mmc0_slot0_cmd_dat0
> +					&pinctrl_mmc0_slot0_dat1_3>;
> +				status = "okay";
> +				slot@0 {
> +					reg = <0>;
> +					bus-width = <4>;
> +					cd-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
> +				};
> +			};
> +
> +			dbgu: serial@fffff200 {
> +				status = "okay";
> +			};
> +
> +			usart0: serial@fffb0000 {
> +				pinctrl-0 = <
> +					&pinctrl_usart0
> +					&pinctrl_usart0_rts
> +					&pinctrl_usart0_cts>;
> +				status = "okay";
> +			};
> +
> +			pinctrl@fffff400 {
> +				mmc0 {
> +					pinctrl_board_mmc0: mmc0-board {
> +						atmel,pins =
> +							<AT91_PIOA 15 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> +					};
> +				};
> +			};
> +
> +			watchdog@fffffd40 {
> +				status = "okay";
> +			};
> +		};
> +
> +		nand0: nand@40000000 {
> +			nand-bus-width = <8>;
> +			nand-ecc-mode = "soft";
> +			nand-on-flash-bbt = <1>;
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
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		ds1 {
> +			label = "ds1";
> +			gpios = <&pioD 15 GPIO_ACTIVE_LOW>;
> +		};
> +
> +		ds2 {
> +			label = "ds2";
> +			gpios = <&pioD 16 GPIO_ACTIVE_LOW>;
> +		};
> +
> +		ds3 {
> +			label = "ds3";
> +			gpios = <&pioD 14 GPIO_ACTIVE_HIGH>;
> +			linux,default-trigger = "heartbeat";
> +		};
> +	};
> +
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +
> +		right_click {
> +			label = "right_click";
> +			gpios = <&pioB 0 GPIO_ACTIVE_LOW>;
> +			linux,code = <273>;
> +			gpio-key,wakeup;
> +		};
> +
> +		left_click {
> +			label = "left_click";
> +			gpios = <&pioB 1 GPIO_ACTIVE_LOW>;
> +			linux,code = <272>;
> +			gpio-key,wakeup;
> +		};
> +	};
> +};
> 

Otherwise, seems okay:

when corrected, you can add my:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

-- 
Nicolas Ferre
