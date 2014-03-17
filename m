Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaCQLgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:36:20 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:55148 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932732AbaCQLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:36:17 -0400
Date: Mon, 17 Mar 2014 12:38:11 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: nicolas.ferre@atmel.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com, devicetree@vger.kernel.org,
        thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com
Subject: Re: [PATCH v5 6/9] at91: dt: sam9261: Device Tree support for the
 at91sam9261ek
Message-ID: <20140317113811.GD9558@ns203013.ovh.net>
References: <1393841162-25339-1-git-send-email-jjhiblot@traphandler.com>
 <1393841162-25339-7-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393841162-25339-7-git-send-email-jjhiblot@traphandler.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 16009170775713229657
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:05 Mon 03 Mar     , Jean-Jacques Hiblot wrote:
> This patch implements a DTS to boot a at91sam9261ek with a dt-enabled
> kernel (at91_dt_defconfig).
> supported features are:
> * dbgu
> * lcdc
> * usb host
> * usb gadget,
> * spi dataflash
> * nand flash
> * touchscreen
> * leds
> * user buttons
> 
> In the TODO list:
> * dm9000 (ethernet)
> * audio
> * mmc
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/boot/dts/Makefile          |   2 +
>  arch/arm/boot/dts/at91sam9261ek.dts | 204 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 206 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 0320303..f496473 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -12,6 +12,8 @@ dtb-$(CONFIG_ARCH_AT91) += ethernut5.dtb
>  dtb-$(CONFIG_ARCH_AT91) += evk-pro3.dtb
>  dtb-$(CONFIG_ARCH_AT91) += tny_a9260.dtb
>  dtb-$(CONFIG_ARCH_AT91) += usb_a9260.dtb
> +# sam9261
> +dtb-$(CONFIG_ARCH_AT91) += at91sam9261ek.dtb
>  # sam9263
>  dtb-$(CONFIG_ARCH_AT91) += at91sam9263ek.dtb
>  dtb-$(CONFIG_ARCH_AT91) += tny_a9263.dtb
> diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
> new file mode 100644
> index 0000000..03adb7f
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9261ek.dts
> @@ -0,0 +1,204 @@
> +/*
> + * at91sam9261ek.dts - Device Tree file for Atmel at91sam9261 reference board
> + *
> + *  Copyright (C) 2013 Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> + *
> + * Licensed under GPLv2 only.
> + */
> +/dts-v1/;
> +#include "at91sam9261.dtsi"
> +
> +/ {
> +	model = "Atmel at91sam9261ek";
> +	compatible = "atmel,at91sam9261ek", "atmel,at91sam9261", "atmel,at91sam9";
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200 rootfstype=ubifs ubi.mtd=5 root=ubi0:rootfs rw";
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
> +			clock-frequency = <18432000>;
> +		};
> +	};
> +
> +	ahb {
> +		usb0: ohci@00500000 {
> +			status = "okay";
> +		};
> +
> +		fb0: fb@0x00600000 {
> +			display = <&display0>;
> +			atmel,power-control-gpio = <&pioA 12 GPIO_ACTIVE_LOW>;
> +			status = "okay";
> +
> +			display0: display {
> +				bits-per-pixel = <16>;
> +				atmel,lcdcon-backlight;
> +				atmel,dmacon = <0x1>;
> +				atmel,lcdcon2 = <0x80008002>;
> +				atmel,guard-time = <1>;
> +				atmel,lcd-wiring-mode = "BRG";
> +
> +				display-timings {
> +					native-mode = <&timing0>;
> +					timing0: timing0 {
> +						clock-frequency = <4965000>;
> +						hactive = <240>;
> +						vactive = <320>;
> +						hback-porch = <1>;
> +						hfront-porch = <33>;
> +						vback-porch = <1>;
> +						vfront-porch = <0>;
> +						hsync-len = <5>;
> +						vsync-len = <1>;
> +						hsync-active = <1>;
> +						vsync-active = <1>;
> +					};
> +				};
> +			};
> +		};
> +
> +		nand0: nand@40000000 {
> +			nand-bus-width = <8>;
> +			nand-ecc-mode = "soft";
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
> +		apb {
> +			usb1: gadget@fffa4000 {
> +				atmel,vbus-gpio = <&pioB 29 GPIO_ACTIVE_HIGH>;
> +				status = "okay";
> +			};
> +			spi0: spi@fffc8000 {
if you use cs-gpios you do not need to respect the hw order but ok just drop
the last 0
> +				cs-gpios = <&pioA 3 0>, <0>, <&pioA 28 0>, <0>;
> +				status = "okay";
> +
> +				mtd_dataflash@0 {
> +					compatible = "atmel,at45", "atmel,dataflash";
> +					reg = <0>;
> +					spi-max-frequency = <15000000>;
> +				};
please add empty line
> +				tsc2046@0 {
> +					reg = <2>;
> +					compatible = "ti,ads7843";
> +					interrupts-extended = <&pioC 2 IRQ_TYPE_EDGE_BOTH>;
> +					spi-max-frequency = <3000000>;
> +					pendown-gpio = <&pioC 2 GPIO_ACTIVE_HIGH>;
> +
> +					ti,x-min = /bits/ 16 <150>;
> +					ti,x-max = /bits/ 16 <3830>;
> +					ti,y-min = /bits/ 16 <190>;
> +					ti,y-max = /bits/ 16 <3830>;
> +					ti,vref-delay-usecs = /bits/ 16 <450>;
> +					ti,x-plate-ohms = /bits/ 16 <450>;
> +					ti,y-plate-ohms = /bits/ 16 <250>;
> +					ti,pressure-max = /bits/ 16 <15000>;
> +					ti,debounce-rep = /bits/ 16 <0>;
> +					ti,debounce-tol = /bits/ 16 <65535>;
> +					ti,debounce-max = /bits/ 16 <1>;
> +
> +					linux,wakeup;
> +				};
> +			};
> +
> +			dbgu: serial@fffff200 {
> +				status = "okay";
> +			};
> +
> +			watchdog@fffffd40 {
> +				status = "okay";
> +			};
> +
> +		};
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		ds8 {
> +			label = "ds8";
> +			gpios = <&pioA 13 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "none";
no-need drop it

please fix the missing empty line
> +		};
> +		ds7 {
> +			label = "ds7";
> +			gpios = <&pioA 14 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "nand-disk";
> +		};
> +		ds1 {
> +			label = "ds1";
> +			gpios = <&pioA 23 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "heartbeat";
> +		};
> +	};
> +
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +
> +		button_0 {
> +			label = "button_0";
> +			gpios = <&pioA 27 GPIO_ACTIVE_LOW>;
> +			linux,code = <256>;
> +			gpio-key,wakeup;
> +		};
> +		button_1 {
> +			label = "button_1";
> +			gpios = <&pioA 26 GPIO_ACTIVE_LOW>;
> +			linux,code = <257>;
> +			gpio-key,wakeup;
> +		};
> +		button_2 {
> +			label = "button_2";
> +			gpios = <&pioA 25 GPIO_ACTIVE_LOW>;
> +			linux,code = <258>;
> +			gpio-key,wakeup;
> +		};
> +		button_3 {
> +			label = "button_3";
> +			gpios = <&pioA 24 GPIO_ACTIVE_LOW>;
> +			linux,code = <259>;
> +			gpio-key,wakeup;
> +		};
> +	};
> +};
> -- 
> 1.9.0
> 
