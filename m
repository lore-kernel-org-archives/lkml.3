Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3GVV6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:58:05 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:59051 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVV6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:58:03 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Jon Loeliger <jdl@jdl.com>
Cc: "Chaiken, Alison" <Alison_Chaiken@mentor.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: The future of DT binding maintainership
Date: Mon, 22 Jul 2013 23:57:56 +0200
Message-ID: <1687020.5ErE9ecltl@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <E1V1Nkn-00072x-Df@jdl.com>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <1925583.R0td2pS6as@flatron> <E1V1Nkn-00072x-Df@jdl.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 of July 2013 16:34:49 Jon Loeliger wrote:
> > > Is there a schema out there in the wild that exemplifies what you
> > > mean?
> > 
> > Not really. The format of schemas is currently in design stage. I'm
> > currently rethinking some details of what I have in my mind. Give me
> > some more time and I will post an RFC to the ML with all that written
> > down.
> ...and...

I meant a bit longer "more time". It's late here and it's almost time to 
go to bed.

I need to look a bit inside dtc to see what is already there, but expect 
results rather later this week.

> > > The schema-check idea reminds me of the W3C HTML validators:
> > >       http://validator.w3.org/
> > > 
> > > Since device-tree source looks a bit like XML (or maybe more like
> > > JSON), will be the schemas be similar in spirit to DTDs, and is it
> > > helpful to think of the validator in this spirit?   Or will the
> > > checker be more like "gcc -Wall", since it will be invoked by a
> > > compiler?
> > 
> > My idea is to implement compile time verification in dtc, so I guess
> > it
> > will be more like the latter. Since dts is what dtc can already parse,
> > my plan is to keep the schemas in spirit to dts, just
> > modifying/extending it to allow specifying bindings with them, rather
> > than static values.
> > 
> > Best regards,
> > Tomasz
> 
> It is possible to add some-damn XML DTD parsing and
> rule glomming even in DTC if that is what is wanted.

IMHO it's more natural to describe device tree bindings using dts-like 
format, if not just because of tools already existing, then at least from 
readability point of view.

> I think it will be more an issue of expressability.
> That is, how can the desired style of rules be most
> eloquently expressed, internalized and applied?
> 
> That will be the current challenge first.

Yes, it will and it is already.

There is no problem with simple rules, such as required or optional 
properties with predefined names, this is pretty obvious.

Things start to become fun when you get to bindings like regulators or 
clocks, when part of the binding is defined on generic level (-supply, 
clocks, clock-names properties) and remaining part is specific to device 
(XXX in XXX-supply, count and order of clocks and clock-names, strings 
allowed in clock-names property). This kind of inheritance is likely to be 
the biggest troublemaker.

Best regards,
Tomasz

