Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaFWQAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:00:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:39928 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754060AbaFWP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:59:58 -0400
Message-ID: <1403539186.3804.46.camel@hornet>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 23 Jun 2014 16:59:46 +0100
In-Reply-To: <CAL_Jsq+6SveWhzWPrtziTJ-tDOFaJV4sXO+r_CEhAZf=tQE6FA@mail.gmail.com>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
	 <20140620170901.GA12059@leverpostej> <1403532837.3804.29.camel@hornet>
	 <CAL_Jsq+6SveWhzWPrtziTJ-tDOFaJV4sXO+r_CEhAZf=tQE6FA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 16:43 +0100, Rob Herring wrote:
> On Mon, Jun 23, 2014 at 9:13 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> > On Fri, 2014-06-20 at 18:09 +0100, Mark Rutland wrote:
> >> > +- clocks-names: should contain "clcdclk" and "apb_pclk"
> >>
> >> s/clocks-names/clock-names/
> >
> > Haha - it took quite a few patch revisions to spot this one, thanks!
> 
> Was this tested?

Yes it was. The typo sneaked in the documentation only, dts changes were
fine.

> >> > +- clocks: contains phandle and clock specifier pairs for the entries
> >> > +   in the clock-names property. See
> >> > +   Documentation/devicetree/binding/clock/clock-bindings.txt
> >> > +
> >> > +Optional properties:
> >> > +
> >> > +- arm,pl11x,framebuffer-base: a pair of two 32-bit values, address and size,
> >> > +   defining the framebuffer that must be used; if not present, the
> >> > +   framebuffer may be located anywhere in the memory
> >>
> >> The name is confusing: this is a base _and_ size.
> >
> > True. Can split it into two -base and -size or rename it into
> > framebuffer or video-memory.
> >
> >> When should this be used, and what is valid to point it at?
> >
> > When the hardware design determines the address the memory transactions
> > must be issued at. This is aimed at a situation (allegedly not
> > impossible) when the memory map from the CLCD's point of view is
> > different from the CPU's one (eg. the video memory is mapped at xxx for
> > the CPU and yyy for the CLCD).
> 
> Humm, that sounds like what dma-ranges is for.
> 
> >
> >> How does this play with memory carveouts (CMA, reserved-memory)?
> >
> > It doesn't, and wasn't intended to (the original version of the binding
> > was trying to do something like reserved-memory before it was defined),
> > but someone managed to convince me not to do this, if it's a "low level"
> > feature.
> >
> > I guess I can be re-convinced (again).
> 
> NAK on this property. Convinced?

Sure. Shame you weren't so clear in any of v3 to v6 nor in the
discussions around v2.

> If this is only theoretical, then just drop it for now.
> 
> >> > +- max-memory-bandwidth: maximum bandwidth in bytes per second that the
> >> > +   cell's memory interface can handle
> >>
> >> When should I set this, given it is optional?
> >
> > When there is a (significant) limitation of the bandwidth available for
> > the cell's memory interface. One will either be told by the soc guys or
> > will figure it out in the hard way, as we did :-(
> 
> What are you going to do with this information? b/w is a function of
> screen size and pixel depth. Are you going to refuse certain configs
> based on that? Seems like someone doing their own modes should know
> what they are doing and the limitations.
> 
> Again, drop it until there is a defined need for this.

Yes, there is. Use case: PL111 is wired up to a HDMI formatter, which
will take everything up to 1080p. This is what a DRM driver (what/if
it's ready) will get from the encoder driver (and rightly so). But the
chip interconnect limitations is make the chip being able to get 480p at
60Hz tops. 

Or do you want me to add a subnode with timings for all achievable modes
instead?

Pawel

