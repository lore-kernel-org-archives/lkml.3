Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3CFCgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:36:06 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43899 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3CFCgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <F3DBB1B3EF102E4994C89758CFCA32412CC74F@DBDE01.ent.ti.com>
References: <F3DBB1B3EF102E4994C89758CFCA32412CC4E9@DBDE01.ent.ti.com>
	<CABYxbz5GyxYaHANgdpwBNaaR6tnu=6LJuUNSvL7DEzU=4CPHcA@mail.gmail.com>
	<F3DBB1B3EF102E4994C89758CFCA32412CC74F@DBDE01.ent.ti.com>
Date: Wed, 6 Mar 2013 08:06:02 +0530
Message-ID: <CABYxbz62JrMB95p5i9iu2G=B4ETXLrYbLsyFEFR5F+WVD6YNnQ@mail.gmail.com>
Subject: Re: [PATCH V4] ARM: dts: add minimal DT support for DevKit8000.
From: Anil Kumar <anilk4.v@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, b-cousson@ti.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Anil Kumar <anilk4.v@gmail.com>, Thomas Weber <thomas@tomweber.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

>> From: linux-arm-kernel [mailto:linux-arm-kernel-
>> bounces@lists.infradead.org] On Behalf Of Anil Kumar
>> Sent: Wednesday, February 27, 2013 8:03 AM
>> To: devicetree-discuss@lists.ozlabs.org; linux-omap@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>> Cc: linux@arm.linux.org.uk; Cousson, Benoit; Tony Lindgren; Grant
>> Likely; Anil Kumar; thomas@tomweber.eu
>> Subject: Re: FW: [PATCH V4] ARM: dts: add minimal DT support for
>> DevKit8000.
>>
>> Hi,
>> >
>> > DevKit8000 is a beagle board clone from Timll, sold by
>> > armkits.com. The DevKit8000 has RS232 serial port, LCD, DVI-D,
>> > S-Video, Ethernet, SD/MMC, keyboard, camera, SPI, I2C, USB and
>> > JTAG interface.
>> >
>> > This patch adds the basic DT support for devkit8000. At this time,
>> Information
>> > of twl4030 (PMIC), MMC1, I2C1 and leds are added.
>> >
>> > Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
>> > Tested-by: Thomas Weber <thomas@tomweber.eu>
>>
>> Gentle Ping. As there are no review comments on this patch,
>> Could you please pull this patch ?

Gentle Ping.

This patch also got Reviewed-by: Manish Badarkhe <badarkhe.manish@gmail.com>
and as patch "ARM: dts: omap3-devkit8000: Enable audio support"  has already got
"Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>" but it is on the
top of this patch.
So, Could you please pull this patch in one of your omap branch? or
you want me to
do rebase this patch on top of v3.9-rc1 ?

Thanks,
Anil

>>
>> > ---
>> >  -This patch is based on top of kernel 3.8-rc5.
>> >
>> >  -Tested on Devkit8000.
>> >
>> > For V4:
>> >  -Tiny nitpick.
>> >
>> > For V3:
>> >  - Remove pin mux as done at device boot time by default.
>> >
>> > For V2:
>> >  - Change model name as "TimLL OMAP3 Devkit8000"
>> >  - Change compatible as "timll,omap3-devkit8000"
>> >  - Doing i2c1 pinmux default with pinctrl-single driver instead of
>> i2c1
>> >    driver probe time.
>> >
>> > :100644 100644 5ebb44f... 22ebc76... M  arch/arm/boot/dts/Makefile
>> > :000000 100644 0000000... 2e1463a... A  arch/arm/boot/dts/omap3-
>> devkit8000.dts
>> > :100644 100644 53cb380b.. ccecb76... M  arch/arm/mach-omap2/board-
>> generic.c
>> >  arch/arm/boot/dts/Makefile             |    1 +
>> >  arch/arm/boot/dts/omap3-devkit8000.dts |  102
>> ++++++++++++++++++++++++++++++++
>> >  arch/arm/mach-omap2/board-generic.c    |    1 +
>> >  3 files changed, 104 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> > index 5ebb44f..22ebc76 100644
>> > --- a/arch/arm/boot/dts/Makefile
>> > +++ b/arch/arm/boot/dts/Makefile
>> > @@ -102,6 +102,7 @@ dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
>> >         imx28-tx28.dtb
>> >  dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>> >         omap3-beagle.dtb \
>> > +       omap3-devkit8000.dtb \
>> >         omap3-beagle-xm.dtb \
>> >         omap3-evm.dtb \
>> >         omap3-tobi.dtb \
>> > diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts
>> b/arch/arm/boot/dts/omap3-devkit8000.dts
>> > new file mode 100644
>> > index 0000000..2e1463a
>> > --- /dev/null
>> > +++ b/arch/arm/boot/dts/omap3-devkit8000.dts
>> > @@ -0,0 +1,102 @@
>> > +/*
>> > + * Author: Anil Kumar <anilk4.v@gmail.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > + */
>> > +/dts-v1/;
>> > +
>> > +/include/ "omap3.dtsi"
>> > +/ {
>> > +       model = "TimLL OMAP3 Devkit8000";
>> > +       compatible = "timll,omap3-devkit8000", "ti,omap3";
>> > +
>> > +       memory {
>> > +               device_type = "memory";
>> > +               reg = <0x80000000 0x10000000>;  /* 256 MB */
>> > +       };
>> > +
>> > +       leds {
>> > +               compatible = "gpio-leds";
>> > +
>> > +               heartbeat {
>> > +                       label = "devkit8000::led1";
>> > +                       gpios = <&gpio6 26 0>;  /* 186 -> LED1 */
>> > +                       default-state = "on";
>> > +                       linux,default-trigger = "heartbeat";
>> > +               };
>> > +
>> > +               mmc {
>> > +                       label = "devkit8000::led2";
>> > +                       gpios = <&gpio6 3 0>;   /* 163 -> LED2 */
>> > +                       default-state = "on";
>> > +                       linux,default-trigger = "none";
>> > +               };
>> > +
>> > +               usr {
>> > +                       label = "devkit8000::led3";
>> > +                       gpios = <&gpio6 4 0>;   /* 164 -> LED3 */
>> > +                       default-state = "on";
>> > +                       linux,default-trigger = "usr";
>> > +                };
>> > +       };
>> > +};
>> > +
>> > +&i2c1 {
>> > +       clock-frequency = <2600000>;
>> > +
>> > +       twl: twl@48 {
>> > +               reg = <0x48>;
>> > +               interrupts = <7>;       /* SYS_NIRQ cascaded to intc
>> */
>> > +               interrupt-parent = <&intc>;
>> > +       };
>> > +};
>> > +
>> > +&i2c2 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&i2c3 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +/include/ "twl4030.dtsi"
>> > +
>> > +&mmc1 {
>> > +       vmmc-supply = <&vmmc1>;
>> > +       vmmc_aux-supply = <&vsim>;
>> > +       bus-width = <8>;
>> > +};
>> > +
>> > +&mmc2 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&mmc3 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&wdt2 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&mcbsp1 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&mcbsp2 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&mcbsp3 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&mcbsp4 {
>> > +       status = "disabled";
>> > +};
>> > +
>> > +&mcbsp5 {
>> > +       status = "disabled";
>> > +};
>> > diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-
>> omap2/board-generic.c
>> > index 53cb380..ccecb76 100644
>> > --- a/arch/arm/mach-omap2/board-generic.c
>> > +++ b/arch/arm/mach-omap2/board-generic.c
>> > @@ -110,6 +110,7 @@ MACHINE_END
>> >
>> >  static const char *omap3_gp_boards_compat[] __initdata = {
>> >         "ti,omap3-beagle",
>> > +       "timll,omap3-devkit8000",
>> >         NULL,
>> >  };
>> >
>> > --
>> > 1.7.0.4
>> >
>> >
>> > _______________________________________________
>> > linux-arm-kernel mailing list
>> > linux-arm-kernel@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
