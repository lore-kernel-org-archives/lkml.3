Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaGWNpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:45:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19727 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbaGWNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:45:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19q4YpWraJrOVqT7A3rEtVi7UlbIDNhq3k=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4FA8B5B3ECA
Date: Wed, 23 Jul 2014 09:45:34 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: benoitm974 <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 1/2] Added dts defintion for Lenovo ix4-300d nas
Message-ID: <20140723134534.GF23220@titan.lakedaemon.net>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

Thanks for the patch!  A few minor things:

Please Cc: the mvebu maintainers patches regarding Armada XP SoCs, I
almost missed this. ;-)

I know, we probably need to update MAINTAINERS for the dts{i} files...

Also, Please adjust your Subject line to start with "ARM: mvebu: ...",
you can use 'git log --oneline -- arch/arm/boot/dts/armada*' to get an
idea of what we prefer to see.

On Wed, Jul 23, 2014 at 05:07:11AM -0700, benoitm974 wrote:
> Signed-off-by: benoitm974 <yahoo@perenite.com>

Please use your real name here, as well as in the From: of the email.

> ---
>  arch/arm/boot/dts/Makefile                     |   1 +
>  arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts | 267 +++++++++++++++++++++++++
>  2 files changed, 268 insertions(+)
>  create mode 100644 arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index adb5ed9..f759dd2 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -438,6 +438,7 @@ dtb-$(CONFIG_MACH_ARMADA_XP) += \
>  	armada-xp-db.dtb \
>  	armada-xp-gp.dtb \
>  	armada-xp-netgear-rn2120.dtb \
> +	armada-xp-lenovo-ix4300d.dtb \
>  	armada-xp-matrix.dtb \
>  	armada-xp-openblocks-ax3-4.dtb

Please place in alphabetical order.  Yes, I know it wasn't to begin
with. :(  Feel free to fix it up while you are adding your line.

>  dtb-$(CONFIG_MACH_DOVE) += dove-cm-a510.dtb \
> diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts
> new file mode 100644
> index 0000000..e04e7a6
> --- /dev/null
> +++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts
> @@ -0,0 +1,267 @@
> +/*
> + * Device Tree file for LENOVO IX4-300d
> + *
> + * Copyright (C) 2014, Benoit Masson <yahoo@perenite.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +/dts-v1/;
> +
> +#include <dt-bindings/input/input.h>
> +#include <dt-bindings/gpio/gpio.h>
> +#include "armada-xp-mv78230.dtsi"
> +
> +/ {
> +	model = "LENOVO IX4-300d";
> +	compatible = "lenovo,ix4-300d", "marvell,armadaxp-mv78230", "marvell,armadaxp", "marvell,armada-370-xp";
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200 earlyprintk";
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0 0x00000000 0 0x20000000>; /* 512MB */
> +	};
> +
> +	soc {
> +		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xd0000000 0x100000
> +			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000>;
> +
> +		pcie-controller {
> +			status = "okay";
> +
> +			pcie@1,0 {
> +				/* Port 0, Lane 0 */
> +				status = "okay";
> +			};
> +			pcie@5,0 {
> +                                /* Port 1, Lane 0 */
> +                                status = "okay";
> +                        };
> +

spurious extra line, and it looks like you have some whitespace issues.
Please make sure you use leading tabs.

> +		};
> +
> +		internal-regs {
> +			pinctrl {
> +				poweroff: poweroff {
> +                                        marvell,pins = "mpp24";
> +                                        marvell,function = "gpio";
> +                                };
> +
> +                                power_button_pin: power-button-pin {
> +                                        marvell,pins = "mpp44";
> +                                        marvell,function = "gpio";
> +                                };
> +
> +                                reset_button_pin: reset-button-pin {
> +                                        marvell,pins = "mpp45";
> +                                        marvell,function = "gpio";
> +                                };
> +				select_button_pin: select-button-pin {
> +                                        marvell,pins = "mpp41";
> +                                        marvell,function = "gpio";
> +                                };
> +
> +                                scroll_button_pin: scroll-button-pin {
> +                                        marvell,pins = "mpp42";
> +                                        marvell,function = "gpio";
> +                                };
> +				hdd_led_pin: hdd-led-pin {
> +					marvell,pins = "mpp26";
> +					marvell,function = "gpio";
> +		                };

More leading tabs issues in this block.

> +			};
> +
> +			serial@12000 {
> +				clocks = <&coreclk 0>;
> +				status = "okay";
> +			};
> +
> +			mdio {
> +				phy0: ethernet-phy@0 { /* Marvell 88E1318 */
> +					reg = <0>;
> +				};
> +
> +				phy1: ethernet-phy@1 { /* Marvell 88E1318 */
> +					reg = <1>;
> +				};
> +			};
> +
> +			ethernet@70000 {
> +				status = "okay";
> +				phy = <&phy0>;
> +				phy-mode = "rgmii-id";
> +			};
> +
> +			ethernet@74000 {
> +				status = "okay";
> +				phy = <&phy1>;
> +				phy-mode = "rgmii-id";
> +			};
> +
> +			usb@50000 {
> +                                status = "okay";
> +                        };
> +
> +                        usb@51000 {
> +                                status = "okay";
> +                        };

And here.

> +
> +			i2c@11000 {
> +				compatible = "marvell,mv78230-a0-i2c", "marvell,mv64xxx-i2c";
> +                                clock-frequency = <400000>;

And here.

> +				status = "okay";
> +
> +				adt7473@2e {
> +					compatible = "adt7473";
> +					reg = <0x2e>;
> +				};
> +
> +				pcf8563@51 {
> +					compatible = "pcf8563";
> +					reg = <0x51>;
> +				};
> +
> +			};

Need an empty line here.

> +			nand@d0000 {
> +                                status = "okay";
> +                                num-cs = <1>;
> +                                marvell,nand-keep-config;
> +                                marvell,nand-enable-arbiter;
> +                                nand-on-flash-bbt;
> +
> +                                partition@0 {
> +                                        label = "u-boot";
> +                                        reg = <0x0000000 0xe0000>;
> +                                        read-only;
> +                                };
> +
> +                                partition@e0000 {
> +                                        label = "u-boot-env";
> +                                        reg = <0xe0000 0x20000>;
> +                                        read-only;
> +                                };
> +
> +                                partition@100000 {
> +                                        label = "u-boot-env2";
> +                                        reg = <0x100000 0x20000>;
> +					read-only;
> +                                };
> +
> +                                partition@120000 {
> +                                        label = "zImage";
> +                                        reg = <0x120000 0x400000>;
> +                                };
> +
> +                                partition@520000 {
> +                                        label = "initrd";
> +                                        reg = <0x520000 0x400000>;
> +                                };
> +                                partition@xE00000 {
> +                                        label = "boot";
> +                                        reg = <0xE00000 0x3F200000>;
> +                                };
> +                                partition@flash {
> +                                        label = "flash";
> +                                        reg = <0x0 0x40000000>;
> +                                };
> +                        };
> +

Don't need this empty line.

> +		};
> +	};

Empty line here.

> +	gpio-keys {
> +                compatible = "gpio-keys";
> +		pinctrl-0 = <&power_button_pin &reset_button_pin &select_button_pin &scroll_button_pin>;

Yeah... I think you get the point ;-) please check the rest of the
patch.  I'll stop mentioning it.

> +                pinctrl-names = "default";
> +
> +                power-button {
> +                        label = "Power Button";
> +                        linux,code = <KEY_POWER>;
> +                        gpios = <&gpio1 12 GPIO_ACTIVE_HIGH>;
> +                };
> +                reset-button {
> +                        label = "Reset Button";
> +                        linux,code = <KEY_RESTART>;
> +                        gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
> +                };
> +		select-button {
> +                        label = "Select Button";
> +                        linux,code = <BTN_SELECT>;
> +                        gpios = <&gpio1 9 GPIO_ACTIVE_LOW>;
> +                };
> +		scroll-button {
> +                        label = "Scroll Button";
> +                        linux,code = <KEY_SCROLLDOWN>;
> +                        gpios = <&gpio1 10 GPIO_ACTIVE_LOW>;
> +                };
> +        };
> +
> +	spi3 {
> +                compatible = "spi-gpio";
> +                status = "okay";
> +                gpio-sck = <&gpio0 25 0>;
> +                gpio-mosi = <&gpio1 15 0>; /*gpio 47*/
> +                cs-gpios = <&gpio0 27 0 >;

I know no one else does it, but please use GPIO_ACTIVE_HIGH for these
three.

> +                num-chipselects = <1>;
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                gpio2: gpio2@0 {
> +                        compatible = "fairchild,74hc595";
> +                        gpio-controller;
> +                        #gpio-cells = <2>;
> +                        reg = <0>;
> +                        registers-number = <2>;
> +                        spi-max-frequency = <100000>;
> +                };
> +	};
> +
> +	gpio-leds {
> +                compatible = "gpio-leds";
> +		pinctrl-0 = <&hdd_led_pin>;
> +		pinctrl-names = "default";
> +
> +		hdd-led {
> +                        label = "ix4300d:blue:hdd";
> +                        gpios = <&gpio0 26 GPIO_ACTIVE_HIGH>;
> +                        default-state = "off";
> +                };
> +
> +		power-led {
> +                        label = "ix4300d:power";
> +                        gpios = <&gpio2 1 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "timer"; /* init blinking while booting */

Watch >80 char lines.

> +                        default-state = "on";
> +                };
> +
> +		sysfail-led {
> +                        label = "ix4300d:sysfail:red";
> +                        gpios = <&gpio2 2 GPIO_ACTIVE_HIGH>;
> +                        default-state = "off";
> +                };
> +		sys-led {
> +                        label = "ix4300d:sys:blue";
> +                        gpios = <&gpio2 3 GPIO_ACTIVE_HIGH>;
> +                        default-state = "off";
> +                };
> +		hddfail-led {
> +                        label = "ix4300d:hddfail:red";
> +                        gpios = <&gpio2 4 GPIO_ACTIVE_HIGH>;
> +                        default-state = "off";
> +                };
> +
> +	};
> +	/* warning: you need both eth1 & 0 to be initialize for poweroff to shutdown otherwise it reboots */

Same here, please convert to multi-line comment.

> +	gpio-poweroff {
> +                compatible = "gpio-poweroff";
> +                pinctrl-0 = <&poweroff>;
> +                pinctrl-names = "default";
> +                gpios = <&gpio0 24 GPIO_ACTIVE_HIGH>;
> +        };
> +
> +};

This is a great first version, it really just a bunch of minor details
to fixup for v2.  Please Cc myself, Andrew, Gregory, and Sebastian when
you send v2.  I've included them in the Cc.

thx,

Jason.
