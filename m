Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaGWPqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:46:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65503 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaGWPqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:46:07 -0400
Message-ID: <53CFD8B5.2030205@gmail.com>
Date: Wed, 23 Jul 2014 17:45:57 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Jason Cooper <jason@lakedaemon.net>, benoitm974 <yahoo@perenite.com>
CC: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 1/2] Added dts defintion for Lenovo ix4-300d nas
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com> <20140723134534.GF23220@titan.lakedaemon.net>
In-Reply-To: <20140723134534.GF23220@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 03:45 PM, Jason Cooper wrote:
> Thanks for the patch!  A few minor things:

Benoit,

I also have some minor remarks just because I stumble over them
all the time.

>> ---
>>   arch/arm/boot/dts/Makefile                     |   1 +
>>   arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts | 267 +++++++++++++++++++++++++

I looked it up and Lenovo names it "ix4-300d", maybe you should
rename the dts "armada-xp-lenovo-ix4-300d.dts" then.

[...]
>> diff --git a/arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts b/arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts
>> new file mode 100644
>> index 0000000..e04e7a6
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/armada-xp-lenovo-ix4300d.dts
>> @@ -0,0 +1,267 @@
>> +/*
>> + * Device Tree file for LENOVO IX4-300d

It is spelled "Lenovo" and the full name is "Lenovo Iomega ix4-300d".
As it is the initial commit, we should be more sensitive on the case
here.

>> + * Copyright (C) 2014, Benoit Masson <yahoo@perenite.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version
>> + * 2 of the License, or (at your option) any later version.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +#include <dt-bindings/input/input.h>
>> +#include <dt-bindings/gpio/gpio.h>
>> +#include "armada-xp-mv78230.dtsi"
>> +
>> +/ {
>> +	model = "LENOVO IX4-300d";

Same comment about "Lenovo Iomega ix4-300d"

>> +	compatible = "lenovo,ix4-300d", "marvell,armadaxp-mv78230", "marvell,armadaxp", "marvell,armada-370-xp";
>> +
>> +	chosen {
>> +		bootargs = "console=ttyS0,115200 earlyprintk";

Consider to add

stdout-path = "/soc/internal-regs/serial@12000";

That way you would not have to fix it up for e.g. Barebox.
Unfortunately, neither Armada 370 nor XP dtsi define node
labels yet, so you have to put the full node path.

>> +	};
>> +
[...]
>> +	soc {
>> +		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xd0000000 0x100000
>> +			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000>;
>> +
>> +		pcie-controller {
>> +			status = "okay";
>> +
>> +			pcie@1,0 {
>> +				/* Port 0, Lane 0 */
>> +				status = "okay";
>> +			};
>> +			pcie@5,0 {
>> +                                /* Port 1, Lane 0 */
>> +                                status = "okay";
>> +                        };
>> +

Any chance you know what is connected to above PCIe ports?
If so, put a comment above the node itself naming the attached
device, e.g.

/* USB 3.0 xHCI controller */
pcie@1,0 {...}

Also, I saw you have a good impression about the GPIOs used on
the ix4-300d. If you also know the PERST# GPIOs, add them with

reset-gpios = <&gpioN M GPIO_ACTIVE_LOW>;

where N, M follow gpio# = (32 * N) + M, i.e. N=1, M=22 for gpio54.

>> +		};
>> +
>> +		internal-regs {
>> +			pinctrl {
>> +				poweroff: poweroff {

nit: poweroff_pin: poweroff-pin {...}
like the ones below?

>> +                                        marvell,pins = "mpp24";
>> +                                        marvell,function = "gpio";
>> +                                };
>> +
>> +                                power_button_pin: power-button-pin {
>> +                                        marvell,pins = "mpp44";
>> +                                        marvell,function = "gpio";
>> +                                };
>> +
>> +                                reset_button_pin: reset-button-pin {
>> +                                        marvell,pins = "mpp45";
>> +                                        marvell,function = "gpio";
>> +                                };
>> +				select_button_pin: select-button-pin {
>> +                                        marvell,pins = "mpp41";
>> +                                        marvell,function = "gpio";
>> +                                };
>> +
>> +                                scroll_button_pin: scroll-button-pin {
>> +                                        marvell,pins = "mpp42";
>> +                                        marvell,function = "gpio";
>> +                                };
>> +				hdd_led_pin: hdd-led-pin {
>> +					marvell,pins = "mpp26";
>> +					marvell,function = "gpio";
>> +		                };
[...]
>> +			};
>> +
>> +			serial@12000 {
>> +				clocks = <&coreclk 0>;

As Andrew already said, no need to duplicate the clocks property.

>> +				status = "okay";
>> +			};
[...]
>> +	spi3 {
>> +                compatible = "spi-gpio";
>> +                status = "okay";
>> +                gpio-sck = <&gpio0 25 0>;
>> +                gpio-mosi = <&gpio1 15 0>; /*gpio 47*/
>> +                cs-gpios = <&gpio0 27 0 >;
[...]
>> +                num-chipselects = <1>;
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +                gpio2: gpio2@0 {
>> +                        compatible = "fairchild,74hc595";

Freaky we have a driver for a 74x595 8-bit shift register ;)

>> +                        gpio-controller;
>> +                        #gpio-cells = <2>;
>> +                        reg = <0>;
>> +                        registers-number = <2>;
>> +                        spi-max-frequency = <100000>;
>> +                };
>> +	};
>> +
>> +	gpio-leds {
>> +                compatible = "gpio-leds";
>> +		pinctrl-0 = <&hdd_led_pin>;
>> +		pinctrl-names = "default";
>> +
>> +		hdd-led {
>> +                        label = "ix4300d:blue:hdd";

Can you get rid of "ix4300d:" or rename it to "ix4-300d:" without
breaking any userspace stuff? If so, please update all LEDs.

>> +                        gpios = <&gpio0 26 GPIO_ACTIVE_HIGH>;
>> +                        default-state = "off";
>> +                };
[...]
>> +	/* warning: you need both eth1 & 0 to be initialize for poweroff to shutdown otherwise it reboots */

I don't get the comment.

> This is a great first version

Yup, Thanks!

Sebastian
