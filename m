Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3GVUJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:09:17 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:48152 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3GVUJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:09:15 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: "Chaiken, Alison" <Alison_Chaiken@mentor.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: The future of DT binding maintainership
Date: Mon, 22 Jul 2013 22:09:09 +0200
Message-ID: <1925583.R0td2pS6as@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <60BA5429A0E1584BA3633194F6F993B502B21362@NA-MBX-03.mgc.mentorg.com>
References: <CACxGe6vtJPbbqwpH8Th5S36Hx50f39j1P4OpLb-Um9xQie6Lng@mail.gmail.com> <2962401.WRRoYlXkRr@flatron> <60BA5429A0E1584BA3633194F6F993B502B21362@NA-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alison,

On Monday 22 of July 2013 19:59:25 Chaiken, Alison wrote:
> Grant Likely wrote:
> > Another thing discussed is that we need to start validating DT schema
> > with an extension to dtc.
> Is there a schema out there in the wild that exemplifies what you mean?

Not really. The format of schemas is currently in design stage. I'm 
currently rethinking some details of what I have in my mind. Give me some 
more time and I will post an RFC to the ML with all that written down.

> > Tomasz Figa has volunteered to do this work and has support from his
> > employer
> That's great news.
> 
> > to have is that the DT schema will get checked as part of the dts
> > build
> > process so that any DT file that doesn't match the documented schema
> > will get flagged, and that the schema files will be human readable and
> > will double as documentation.
> 
> No doubt DTS files are already the best documentation available for many
> targets.    The vendor's technical reference manual describes how the
> hardware is supposed to work, but the DTS describes what actually does.
>   Any errata that the vendor issues subsequent to publication of the
> TRM must be reflected in DTS, after all.

I'm not sure about this. Device tree should describe what hardware it is, 
not how it works, unless it is really necessary.

> The schema-check idea reminds me of the W3C HTML validators:
> 
>       http://validator.w3.org/
> 
> Since device-tree source looks a bit like XML (or maybe more like JSON),
> will be the schemas be similar in spirit to DTDs, and is it helpful to
> think of the validator in this spirit?   Or will the checker be more
> like "gcc -Wall", since it will be invoked by a compiler?

My idea is to implement compile time verification in dtc, so I guess it 
will be more like the latter. Since dts is what dtc can already parse, my 
plan is to keep the schemas in spirit to dts, just modifying/extending it 
to allow specifying bindings with them, rather than static values.

Best regards,
Tomasz

