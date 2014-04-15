Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaDOPYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:24:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:65329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaDOPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:24:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Anders Berg <anders.berg@lsi.com>
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        mturquette@linaro.org, mark.rutland@arm.com, dbaryshkov@gmail.com,
        linus.walleij@linaro.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
Date: Tue, 15 Apr 2014 17:23:28 +0200
Message-ID: <11327885.Oem0QkHdqf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140415152047.GB32285@swsaberg01>
References: <cover.1397552154.git.anders.berg@lsi.com> <8344066.GP0Bf5lvlE@wuerfel> <20140415152047.GB32285@swsaberg01>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dOQjiHIVhiYSjsVra//rqrjg1BACmSLN4/Bh4Xijxfc
 xNSCd/XJFqVuycxcJkH0xKRu3x8kquTGsWrLyR+mYzIlMl8QKj
 u23iQDPmUoTTXF60cEzIy2Qh3ueiSKC7k7b2IO5nitKtDl1ZA9
 h5ylpu2hGQHDThnltiyByXEVhAEz9oHznk+izRa07Q6eE7McoV
 5qO4/CRvzxd6jl1neXXlLsmV7EF77/4jFIaEZE0n0mVqillRaM
 sE4vmYdX1YSOzlUmm4jB1cP8SqvPXrU2ePdgU5//QKSkzQbFhl
 7fvvpiuNj7oK1gr1FANI+DoaZkVyvnsOPqhPs60GXYy6xOu0+1
 yOWKw9/Kyr120ridEwgo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014 17:20:47 Anders Berg wrote:
> > > +                   gpio0: gpio@2010092000 {
> > > +                           #gpio-cells = <2>;
> > > +                           compatible = "arm,pl061", "arm,primecell";
> > > +                           gpio-controller;
> > > +                           reg = <0x20 0x10092000 0x00 0x1000>;
> > > +                           interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                        <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> > > +                           clocks = <&clk_per>;
> > > +                           clock-names = "apb_pclk";
> > > +                           status = "disabled";
> > 
> > The pl061 binding does not specify any clocks at all. Do we need to update
> > that?
> 
> Doesn't all AMBA devices need at least one apb_pclk since the bus driver does
> clk_get(...,"apb_pclk") before calling probe()?

Yes, I was mostly wondering whether we had a policy about whether this clock
should also be listed in the binding or not. My feeling is that it's better
to make that explicit.

	Arnd
