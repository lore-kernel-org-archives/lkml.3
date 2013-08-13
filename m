Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab3HMKuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:50:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55676 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3HMKuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:50:07 -0400
Message-ID: <520A0F5B.5080502@baylibre.com>
Date: Tue, 13 Aug 2013 12:50:03 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        b-cousson@ti.com, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] N900: add device tree
References: <20130613155240.GB3775@amd.pavel.ucw.cz> <20130613161418.GJ8164@atomide.com> <20130613230808.GA14876@amd.pavel.ucw.cz> <20130614055629.GM8164@atomide.com> <20130614212816.GA31768@atrey.karlin.mff.cuni.cz> <20130617111031.GQ20992@atomide.com> <20130701211753.GC15318@amd.pavel.ucw.cz> <20130704171939.GA27374@blackmetal.musicnaut.iki.fi> <20130704202145.GB10752@amd.pavel.ucw.cz> <20130704203256.GB27374@blackmetal.musicnaut.iki.fi> <20130713121709.GC16473@amd.pavel.ucw.cz> <CAAwP0s18PNn10q5qrzgi4Vz9t31AYuwBSthjE=rSdRb0FG0CFQ@mail.gmail.com>
In-Reply-To: <CAAwP0s18PNn10q5qrzgi4Vz9t31AYuwBSthjE=rSdRb0FG0CFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

I finally got released by the aliens. It took longer than expected and 
beside a small scar on the back of my neck, I feel pretty OK.

I just have few cosmetic comments on top of Javier's ones.

On 11/08/2013 17:02, Javier Martinez Canillas wrote:
> Hi Pavel,
>
> some minor comments about your patch below
>
> On Sat, Jul 13, 2013 at 2:17 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>> This adds device tree with neccessary support to boot with functional

Typo----------------------------^

>> video (on both emulator and real N900 device).
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>
>> ---
>>
>>  From v1: Aaro wants just GPLv2, so I did that. I re-enabled parts that
>> can be enabled on 3.10, and tested it on that kernel.
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index f0895c5..1950aed 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -141,6 +141,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>>          omap3-devkit8000.dtb \
>>          omap3-beagle-xm.dtb \
>>          omap3-evm.dtb \
>> +       omap3-n900.dtb \
>>          omap3-tobi.dtb \
>>          omap3-igep0020.dtb \
>>          omap3-igep0030.dtb \
>> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
>> new file mode 100644
>> index 0000000..fb461bf
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/omap3-n900.dts
>> @@ -0,0 +1,92 @@
>> +/*
>> + * Copyright (C) 2013 Pavel Machek <pavel@ucw.cz>
>> + * Copyright 2013 Aaro Koskinen <aaro.koskinen@iki.fi>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +/include/ "omap34xx.dtsi"
>> +
>
> The current trend is to use #include "omap34xx.dtsi" instead /include/
> in order to use the C pre-processor and the macros defined in
> include/dt-bindings.
>
>> +/ {
>> +       model = "Nokia N900";
>> +       compatible = "nokia,omap3-n900", "ti,omap3";
>> +
>> +       cpus {
>> +               cpu@0 {
>> +                       cpu0-supply = <&vcc>;
>> +               };
>> +       };
>> +
>> +       memory {
>> +               device_type = "memory";
>> +               reg = <0x80000000 0x10000000>; /* 256 MB */
>> +       };
>> +
>> +};
>> +
>> +&i2c1 {
>> +       clock-frequency = <2200000>;
>> +
>> +       twl: twl@48 {
>> +               reg = <0x48>;
>> +               interrupts = <7>; /* SYS_NIRQ cascaded to intc */
>> +               interrupt-parent = <&intc>;
>> +       };
>> +};
>> +
>> +/include/ "twl4030.dtsi"
>> +
>> +&twl_gpio {
>> +       ti,pullups      = <0x0>;
>> +       ti,pulldowns    = <0x03ff3f>; /* BIT(0..5) | BIT(8..17) */
>> +};
>> +
>> +&i2c2 {
>> +       clock-frequency = <400000>;
>> +};
>> +
>> +&i2c3 {
>> +       clock-frequency = <100000>;
>> +};
>> +
>> +&mmc1 {
>> +       status = "disabled";
>> +};
>> +
>> +&mmc2 {
>> +       status = "disabled";
>> +};
>> +
>> +&mmc3 {
>> +       status = "disabled";
>> +};
>> +
>> +&mcspi1 {
>> +       // For some reason, touchscreen is neccessary for screen to work at

Same typo than before---------------------------^

>> +       // all on real hw. It works well without it on emulator.
>> +       //
>> +       // Also... order in the device tree actually matters here.

Nit: Please use the regular Linux style comment.

The order should not matter at all in DT, it should be a static 
representation of the HW, so there is probably something wrong in the 
code that make the device creation order important.

>> +       tsc2005@0 {
>> +               compatible = "tsc2005";
>> +               spi-max-frequency = <6000000>;
>> +               reg = <0>;
>> +       };
>> +       mipid@2 {
>> +               compatible = "acx565akm";
>> +               spi-max-frequency = <6000000>;
>> +               reg = <2>;
>> +               // turbo_mode = 0,
>> +               // cs_per_word = 0
>> +       };
>> +};
>
> You should remove these properties if they are not being used instead
> of keeping them as commented.
>
>> +
>> +&usb_otg_hs {
>> +       interface-type = <0>;
>> +       usb-phy = <&usb2_phy>;
>> +       mode = <2>;
>> +       power = <50>;
>> +};

Beside my comments and the ones from Javier, it looks good.
If you can repost ASAP, I'll take it right after.
It will be the first one in the list.

Thanks,
Benoit

