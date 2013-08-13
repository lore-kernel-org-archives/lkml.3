Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab3HMOGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:06:21 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:48374 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3HMOGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:06:19 -0400
Message-ID: <520A3D57.1020906@baylibre.com>
Date: Tue, 13 Aug 2013 16:06:15 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v3] N900: add device tree
References: <20130614055629.GM8164@atomide.com> <20130614212816.GA31768@atrey.karlin.mff.cuni.cz> <20130617111031.GQ20992@atomide.com> <20130701211753.GC15318@amd.pavel.ucw.cz> <20130704171939.GA27374@blackmetal.musicnaut.iki.fi> <20130704202145.GB10752@amd.pavel.ucw.cz> <20130704203256.GB27374@blackmetal.musicnaut.iki.fi> <20130713121709.GC16473@amd.pavel.ucw.cz> <CAAwP0s18PNn10q5qrzgi4Vz9t31AYuwBSthjE=rSdRb0FG0CFQ@mail.gmail.com> <520A0F5B.5080502@baylibre.com> <20130813133636.GA12364@amd.pavel.ucw.cz>
In-Reply-To: <20130813133636.GA12364@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/2013 15:36, Pavel Machek wrote:
> Hi!
>
>> I finally got released by the aliens. It took longer than expected
>> and beside a small scar on the back of my neck, I feel pretty OK.
>
> Scars on neck sound scary...
>
>> The order should not matter at all in DT, it should be a static
>> representation of the HW, so there is probably something wrong in
>> the code that make the device creation order important.
>
> I understand that there's something wrong with the code, but it turned
> out not to be easy to debug. Yes, it will have to be debugged some
> day, but it happens with old code, too, so it is actually orthogonal
> to device tree.
>
>> Beside my comments and the ones from Javier, it looks good.
>> If you can repost ASAP, I'll take it right after.
>> It will be the first one in the list.
>
> Thanks, here you go.

Thanks. I've just applied it after adding the prefix "ARM: dts:" to the 
subject.

Regards,
Benoit

> 								Pavel
>
> ---
>
> This adds device tree with neccessary support to boot with functional
> video (on both emulator and real N900 device).
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>
> ---
>
>  From v1: Aaro wants just GPLv2, so I did that. I re-enabled parts that
> can be enabled on 3.10, and tested it on that kernel.
>
>  From v2: spelling, improved comments. Tested on 3.11-rc (0ed4402).
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index a0f2365..c48b1ef 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -162,6 +162,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>   	omap3-devkit8000.dtb \
>   	omap3-beagle-xm.dtb \
>   	omap3-evm.dtb \
> +	omap3-n900.dtb \
>   	omap3-tobi.dtb \
>   	omap3-igep0020.dtb \
>   	omap3-igep0030.dtb \
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> new file mode 100644
> index 0000000..7ff90f8
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -0,0 +1,92 @@
> +/*
> + * Copyright (C) 2013 Pavel Machek <pavel@ucw.cz>
> + * Copyright 2013 Aaro Koskinen <aaro.koskinen@iki.fi>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 (or later) as
> + * published by the Free Software Foundation.
> + */
> +
> +/dts-v1/;
> +
> +#include "omap34xx.dtsi"
> +
> +/ {
> +	model = "Nokia N900";
> +	compatible = "nokia,omap3-n900", "ti,omap3";
> +
> +	cpus {
> +		cpu@0 {
> +			cpu0-supply = <&vcc>;
> +		};
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x80000000 0x10000000>; /* 256 MB */
> +	};
> +
> +};
> +
> +&i2c1 {
> +	clock-frequency = <2200000>;
> +
> +	twl: twl@48 {
> +		reg = <0x48>;
> +		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
> +		interrupt-parent = <&intc>;
> +	};
> +};
> +
> +#include "twl4030.dtsi"
> +
> +&twl_gpio {
> +	ti,pullups	= <0x0>;
> +	ti,pulldowns	= <0x03ff3f>; /* BIT(0..5) | BIT(8..17) */
> +};
> +
> +&i2c2 {
> +	clock-frequency = <400000>;
> +};
> +
> +&i2c3 {
> +	clock-frequency = <100000>;
> +};
> +
> +&mmc1 {
> +	status = "disabled";
> +};
> +
> +&mmc2 {
> +	status = "disabled";
> +};
> +
> +&mmc3 {
> +	status = "disabled";
> +};
> +
> +&mcspi1 {
> +	/*
> +	 * For some reason, touchscreen is necessary for screen to work at
> +	 * all on real hw. It works well without it on emulator.
> +	 *
> +	 * Also... order in the device tree actually matters here.
> +	 */
> +	tsc2005@0 {
> +		compatible = "tsc2005";
> +		spi-max-frequency = <6000000>;
> +		reg = <0>;
> +	};
> +	mipid@2 {
> +		compatible = "acx565akm";
> +		spi-max-frequency = <6000000>;
> +		reg = <2>;
> +	};
> +};
> +
> +&usb_otg_hs {
> +	interface-type = <0>;
> +	usb-phy = <&usb2_phy>;
> +	mode = <2>;
> +	power = <50>;
> +};
>

