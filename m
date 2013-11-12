Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3KLIGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:06:34 -0500
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:51803 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KLIG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:06:26 -0500
Message-ID: <1384243549.12583.36.camel@porter.coelho.fi>
Subject: Re: [PATCH] clk: add flags to distinguish xtal clocks
From: Luca Coelho <luca@coelho.fi>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: balbi@ti.com, mturquette@linaro.org, james.hogan@imgtec.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 12 Nov 2013 10:05:49 +0200
In-Reply-To: <20131111205910.GA26440@lukather>
References: <1382528150.21526.25.camel@porter.coelho.fi>
	 <1383933648-28595-1-git-send-email-balbi@ti.com>
	 <20131110113716.GN26440@lukather> <20131111194247.GB19212@saruman.home>
	 <1384199456.12583.27.camel@porter.coelho.fi>
	 <20131111205910.GA26440@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 21:59 +0100, Maxime Ripard wrote:
> Hi Luca,
> 
> On Mon, Nov 11, 2013 at 09:50:56PM +0200, Luca Coelho wrote:
> > On Mon, 2013-11-11 at 13:42 -0600, Felipe Balbi wrote:
> > > > > +	if (of_property_read_bool(node, "clock-xtal"))
> > > > > +		flags |= CLK_IS_TYPE_XTAL;
> > > > > +
> > > > 
> > > > Introducing a new compatible instead of a property would make more
> > > > sense here I think.
> > > > 
> > > > Do you have a reason not to do so?
> > > 
> > > As you can see, this is original work from Luca but I disagree that
> > > adding a new compatible makes more sense. This still related to a fixed
> > > rate clock, we're just giving it one extra metadata which willAnd t
> > > differentiate between crystal and oscilator fixed rate clocks.
> > 
> > I agree with Felipe.  This was discussed before [1].  While still at TI,
> > I tried to figure out the exact need for the firmware to know whether it
> > was an oscillator or not.  It was mostly because the stabilization time
> > and such things differ with oscillators, but I wasn't able to find out
> > how exactly this affected things.
> > 
> > In any case, as I concluded earlier (but it's not really my call), being
> > a crystal or an oscillator *is* a characteristic of the hardware,
> > regardless of whether that information is useful or not.  In the WiLink
> > case it is, at least it can differentiate the clocks that are used in
> > the HW modules it uses.
> > 
> > So IMHO it doesn't really hurt and it's not really against the DT
> > principles.
> 
> Just to be clear, I'm not against your patch. If you need this to make
> your driver work, then it's fine for me. Mike will probably know
> better if we actually need some extra metadata.

:)

I understand, we should really try to make this as clean as possible, DT
should really be a good description of the hardware.


> What I'm not really convinced about is *how* you carry that metadata
> in the DT, that's all, nothing more.

Okay, I get you.  My point is that being a crystal or not *is* a
characteristic of the clock, so I think it could be part of the flags
that describe it.

In any case, it's not really my call.  This is about the clock and it's
not even my home turf (wireless). ;)

Thanks for your comments.  And I'm sorry if the tone of my previous
email sounded harsh, it was not supposed to. :)

--
Cheers,
Luca.

