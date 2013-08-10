Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3HJLqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 07:46:32 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63382 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab3HJLqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 07:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130810110955.GA11437@amd.pavel.ucw.cz>
References: <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
	<20130617111031.GQ20992@atomide.com>
	<20130701211753.GC15318@amd.pavel.ucw.cz>
	<20130704171939.GA27374@blackmetal.musicnaut.iki.fi>
	<20130704202145.GB10752@amd.pavel.ucw.cz>
	<20130704203256.GB27374@blackmetal.musicnaut.iki.fi>
	<20130713121709.GC16473@amd.pavel.ucw.cz>
	<20130714222819.GB3296@blackmetal.musicnaut.iki.fi>
	<20130728134409.GB5382@amd.pavel.ucw.cz>
	<20130801234355.GA15611@amd.pavel.ucw.cz>
	<20130810110955.GA11437@amd.pavel.ucw.cz>
Date: Sat, 10 Aug 2013 13:46:30 +0200
Message-ID: <CAAfyv34w1e+sAuB==-+Pj2gOO1auVNQgawcNC1Z4QfeqchRh3g@mail.gmail.com>
Subject: Re: [PATCH v2] N900: add device tree
From: Belisko Marek <marek.belisko@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        Tony Lindgren <tony@atomide.com>, b-cousson@ti.com,
        pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Sat, Aug 10, 2013 at 1:09 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2013-08-02 01:43:55, Pavel Machek wrote:
>> On Sun 2013-07-28 15:44:09, Pavel Machek wrote:
>> > On Mon 2013-07-15 01:28:19, Aaro Koskinen wrote:
>> > > Hi,
>> > >
>> > > On Sat, Jul 13, 2013 at 02:17:09PM +0200, Pavel Machek wrote:
>> > > >
>> > > > This adds device tree with neccessary support to boot with functional
>> > > > video (on both emulator and real N900 device).
>> > > >
>> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> > >
>> > > You can also add:
>> > >
>> > > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>> >
>> > Benoit, could you apply this? Tony said you are doing dts changes, and
>> > the patch seems to be ready.
>>
>> Tony, Benoit was apparently abducted by aliens or something. Is there
>> chance you could take the patch?
>
> Hello, is there anybody out there?
>
> There's nice and simple patch enabling device tree on n900, it is even
> reviewed by Aaro, and it is neither applied nor are negative comments
> coming? ...for a month...?
Same for gta04 (omap3 based device) [1].
It was send upstream 2 times and second time there is no reply from 1.3.2013.
>
> Tony also seen the patch and comment was "Benoit takes these", so I
> assume it looks basically ok.
>
> Benoit, you are supposed to maintain device tree for omap2.
>
> [I wonder if this is clean-enough cause for "trivial in resubmit
> mode?]
>                                                                 Pavel
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
> From v1: Aaro wants just GPLv2, so I did that. I re-enabled parts that
> can be enabled on 3.10, and tested it on that kernel.
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index f0895c5..1950aed 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -141,6 +141,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>         omap3-devkit8000.dtb \
>         omap3-beagle-xm.dtb \
>         omap3-evm.dtb \
> +       omap3-n900.dtb \
>         omap3-tobi.dtb \
>         omap3-igep0020.dtb \
>         omap3-igep0030.dtb \
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> new file mode 100644
> index 0000000..fb461bf
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -0,0 +1,92 @@
> +/*
> + * Copyright (C) 2013 Pavel Machek <pavel@ucw.cz>
> + * Copyright 2013 Aaro Koskinen <aaro.koskinen@iki.fi>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/dts-v1/;
> +
> +/include/ "omap34xx.dtsi"
> +
> +/ {
> +       model = "Nokia N900";
> +       compatible = "nokia,omap3-n900", "ti,omap3";
> +
> +       cpus {
> +               cpu@0 {
> +                       cpu0-supply = <&vcc>;
> +               };
> +       };
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x80000000 0x10000000>; /* 256 MB */
> +       };
> +
> +};
> +
> +&i2c1 {
> +       clock-frequency = <2200000>;
> +
> +       twl: twl@48 {
> +               reg = <0x48>;
> +               interrupts = <7>; /* SYS_NIRQ cascaded to intc */
> +               interrupt-parent = <&intc>;
> +       };
> +};
> +
> +/include/ "twl4030.dtsi"
> +
> +&twl_gpio {
> +       ti,pullups      = <0x0>;
> +       ti,pulldowns    = <0x03ff3f>; /* BIT(0..5) | BIT(8..17) */
> +};
> +
> +&i2c2 {
> +       clock-frequency = <400000>;
> +};
> +
> +&i2c3 {
> +       clock-frequency = <100000>;
> +};
> +
> +&mmc1 {
> +       status = "disabled";
> +};
> +
> +&mmc2 {
> +       status = "disabled";
> +};
> +
> +&mmc3 {
> +       status = "disabled";
> +};
> +
> +&mcspi1 {
> +       // For some reason, touchscreen is neccessary for screen to work at
> +       // all on real hw. It works well without it on emulator.
> +       //
> +       // Also... order in the device tree actually matters here.
> +       tsc2005@0 {
> +               compatible = "tsc2005";
> +               spi-max-frequency = <6000000>;
> +               reg = <0>;
> +       };
> +       mipid@2 {
> +               compatible = "acx565akm";
> +               spi-max-frequency = <6000000>;
> +               reg = <2>;
> +               // turbo_mode = 0,
> +               // cs_per_word = 0
> +       };
> +};
> +
> +&usb_otg_hs {
> +       interface-type = <0>;
> +       usb-phy = <&usb2_phy>;
> +       mode = <2>;
> +       power = <50>;
> +};
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

[1] - https://lkml.org/lkml/2013/3/1/526

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
