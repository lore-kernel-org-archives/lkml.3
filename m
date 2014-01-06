Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaAFXlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:41:45 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:53589 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbaAFXlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:41:42 -0500
Date: Mon, 6 Jan 2014 23:41:40 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <robherring2@gmail.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when populating
 interrupts
In-Reply-To: <CAL_Jsq+X5G94DUn-zFKQkhEy91cdjCyeciny+kDjr=V6EiBHfQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1401062340240.31394@utopia.booyaka.com>
References: <20131123004334.GJ10023@atomide.com> <20131123010850.GN10023@atomide.com> <20131123015034.GP10023@atomide.com> <20131124212757.7D224C402A3@trevor.secretlab.ca> <alpine.DEB.2.02.1312100331460.32309@utopia.booyaka.com>
 <alpine.DEB.2.02.1312302209200.8869@utopia.booyaka.com> <CAL_Jsq+X5G94DUn-zFKQkhEy91cdjCyeciny+kDjr=V6EiBHfQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Rob,

On Tue, 31 Dec 2013, Rob Herring wrote:

> On Mon, Dec 30, 2013 at 4:10 PM, Paul Walmsley <paul@pwsan.com> wrote:
> > Hi Grant, Rob,
> >
> > On Tue, 10 Dec 2013, Paul Walmsley wrote:
> >
> >> On Sun, 24 Nov 2013, Grant Likely wrote:
> >>
> >> > On Fri, 22 Nov 2013 17:50:35 -0800, Tony Lindgren <tony@atomide.com> wrote:
> >> > > * Tony Lindgren <tony@atomide.com> [131122 17:16]:
> >> > > > * Tony Lindgren <tony@atomide.com> [131122 17:09]:
> >> > > > > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> >> > > > > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> >> > > > > > > +         /* See of_device_resource_notify for populating interrupts */
> >> > > > > > > +         for (i = 0; i < num_irq; i++, res++) {
> >> > > > > > > +                 res->flags = IORESOURCE_IRQ;
> >> > > > > > > +                 res->start = -EPROBE_DEFER;
> >> > > > > > > +                 res->end = -EPROBE_DEFER;
> >> > > > > >
> >> > > > > > NAK.  Definitely a bad idea to start introducing magic values other into
> >> > > > > > resources.  Please don't do this.
> >> > > > >
> >> > > > > Do you have any better ideas on how to sort out this issue then?
> >> > > >
> >> > > > I guess we could allocate all the resources lazily here, I'll take a look
> >> > > > at that.
> >> > >
> >> > > Here's a version that allocates the resources lazily with the notifier.
> >> > > Seems to boot, need to play with it a bit more though to make sure we're
> >> > > not overwriting resources for any legacy devices.
> >> >
> >> > Blurg. Using a notifier really feels like we don't have a good handle on
> >> > a reasonable solution yet. Basically it means we're hooking into the
> >> > driver core without /looking/ like we're hooking into the driver core. I
> >> > don't think this is any better, but I don't have a better suggestion at
> >> > the moment.   :-(
> >>
> >> Unfortunately this patch, or something that accomplishes the same results,
> >> is somewhat high-priority for us on OMAP.  OMAP37xx got prematurely
> >> converted to DT booting, and now dynamic power management is broken:
> >>
> >>     http://marc.info/?l=linux-arm-kernel&m=138658294830408&w=2
> >>
> >> Tony writes that this patch is one of the two patches needed to get things
> >> working again:
> >>
> >>     http://marc.info/?l=linux-arm-kernel&m=138660942506846&w=2
> >>
> >> Is it possible to get this patch, or something similar, merged for
> >> v3.13-rc?
> >>
> >> Once something like PM is broken, it's pretty easy for other broken
> >> patches to make it into the tree, since it becomes very difficult to test
> >> without turning into a maintainer denial-of-service attack.
> >
> > Ping.  Could you please provide some guidance here about what you'd need
> > to get this solved for v3.13-rc?
> 
> I agree with doing the platform_get_irq modification and feel free to
> add my ack. I'm going to be offline for the next week.

Thanks Rob!

Tony, would you consider sending this patch upstream for v3.13-rc along 
with your 37xxevm fix patches?


- Paul
