Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaDVVVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:21:19 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57433 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbaDVVVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <11327885.Oem0QkHdqf@wuerfel>
References: <cover.1397552154.git.anders.berg@lsi.com>
	<8344066.GP0Bf5lvlE@wuerfel>
	<20140415152047.GB32285@swsaberg01>
	<11327885.Oem0QkHdqf@wuerfel>
Date: Tue, 22 Apr 2014 23:21:15 +0200
Message-ID: <CACRpkdaZ3iPtPp0qhr15nvOOEibORSKujEMSgK67G=PC2SjEGA@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anders Berg <anders.berg@lsi.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 5:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 April 2014 17:20:47 Anders Berg wrote:
>> > > +                   gpio0: gpio@2010092000 {
>> > > +                           #gpio-cells = <2>;
>> > > +                           compatible = "arm,pl061", "arm,primecell";
>> > > +                           gpio-controller;
>> > > +                           reg = <0x20 0x10092000 0x00 0x1000>;
>> > > +                           interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
>> > > +                                        <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
>> > > +                           clocks = <&clk_per>;
>> > > +                           clock-names = "apb_pclk";
>> > > +                           status = "disabled";
>> >
>> > The pl061 binding does not specify any clocks at all. Do we need to update
>> > that?
>>
>> Doesn't all AMBA devices need at least one apb_pclk since the bus driver does
>> clk_get(...,"apb_pclk") before calling probe()?
>
> Yes, I was mostly wondering whether we had a policy about whether this clock
> should also be listed in the binding or not. My feeling is that it's better
> to make that explicit.

A separate patch to the GPIO maintainer for this will be accepted. :-)

Yours,
Linus Walleij
