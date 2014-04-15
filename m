Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaDOPVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:21:06 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:20996
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752624AbaDOPVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:21:02 -0400
Date: Tue, 15 Apr 2014 17:20:47 +0200
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <olof@lixom.net>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <dbaryshkov@gmail.com>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
Message-ID: <20140415152047.GB32285@swsaberg01>
References: <cover.1397552154.git.anders.berg@lsi.com>
 <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
 <8344066.GP0Bf5lvlE@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8344066.GP0Bf5lvlE@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA054.namprd07.prod.outlook.com (10.141.251.29) To
 BLUPR07MB370.namprd07.prod.outlook.com (10.141.26.147)
X-Forefront-PRVS: 0182DBBB05
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(199002)(189002)(51704005)(24454002)(57704003)(80976001)(97756001)(19580395003)(81542001)(87976001)(54356999)(83506001)(80022001)(76176999)(66066001)(20776003)(47776003)(79102001)(92566001)(46102001)(77982001)(99396002)(50986999)(92726001)(74502001)(76482001)(31966008)(83072002)(4396001)(33716001)(33656001)(85852003)(83322001)(19580405001)(46406003)(50466002)(86362001)(42186004)(23726002)(74662001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB370;H:swsaberg01;FPR:E296F644.AFF69DAA.FACC1297.CC6101A.203D2;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:45:48PM +0200, Arnd Bergmann wrote:
> On Tuesday 15 April 2014 14:06:11 Anders Berg wrote:
> > diff --git a/arch/arm/boot/dts/axm5516-amarillo.dts b/arch/arm/boot/dts/axm5516-amarillo.dts
> > new file mode 100644
> > index 0000000..1760d6c
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/axm5516-amarillo.dts
> > @@ -0,0 +1,51 @@
> > +/*
> > + * arch/arm/boot/dts/axm5516-amarillo.dts
> > + *
> > + * Copyright (C) 2013 LSI
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> 
> It's better to use a permissive license such as the BSD license for dts files,
> so they can be shared with other OSs.

Ok.

> 
> The situation with the clocks is still very strange: either the bindings
> are all in need of update, or you got all devices wrong:
> 
> > +			serial0: uart@2010080000 {
> > +				compatible = "arm,pl011", "arm,primecell";
> > +				reg = <0x20 0x10080000 0 0x1000>;
> > +				interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
> > +				clocks = <&clk_per>, <&clk_per>;
> > +				clock-names = "uartclk", "apb_pclk";
> > +				status = "disabled";
> > +			};
> 
> "uartclk" is not a valid string for pl011, as per binding:
> 
> | - clocks:  When present, must refer to exactly one clock named
> |           "apb_pclk"
> 
> I do see that a lot of platforms do the same thing you have here, not
> sure who is wrong.

The docs are probably correct. I used some vexpress dtsi as a reference, hence
the uartclk reference. It's gone now.

> 
> > +			timer0: timer@2010091000 {
> > +				compatible = "arm,sp804", "arm,primecell";
> > +				reg = <0x20 0x10091000 0 0x1000>;
> > +				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
> > +				clocks = <&clk_per>, <&clk_per>;
> > +				clock-names = "timclken1", "apb_pclk";
> 
> Citing the binding:
> 
> | - clocks: clocks driving the dual timer hardware. This list should be 1 or 3
> |        clocks. With 3 clocks, the order is timer0 clock, timer1 clock,
> |        apb_pclk. A single clock can also be specified if the same clock is
> |        used for all clock inputs.
> 
> I think you only want to have one clock here and make that the "apb_pclk".

Yepp, will be fixed.

> 
> > +			gpio0: gpio@2010092000 {
> > +				#gpio-cells = <2>;
> > +				compatible = "arm,pl061", "arm,primecell";
> > +				gpio-controller;
> > +				reg = <0x20 0x10092000 0x00 0x1000>;
> > +				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
> > +					     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> > +				clocks = <&clk_per>;
> > +				clock-names = "apb_pclk";
> > +				status = "disabled";
> 
> The pl061 binding does not specify any clocks at all. Do we need to update
> that?

Doesn't all AMBA devices need at least one apb_pclk since the bus driver does
clk_get(...,"apb_pclk") before calling probe()?

/Anders
