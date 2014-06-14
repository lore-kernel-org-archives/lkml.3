Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaFNC5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:57:35 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:55802 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaFNC5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:57:33 -0400
Date: Sat, 14 Jun 2014 02:57:32 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
In-Reply-To: <20140613231019.GA24121@saruman.home>
Message-ID: <alpine.DEB.2.02.1406140127020.20370@utopia.booyaka.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com> <1402676147-3711-2-git-send-email-balbi@ti.com> <20140613162323.GH8319@saruman.home> <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com> <20140613231019.GA24121@saruman.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, 13 Jun 2014, Felipe Balbi wrote:

> On Fri, Jun 13, 2014 at 07:11:58PM +0000, Paul Walmsley wrote:
> > > > From: Sathya Prakash M R <sathyap@ti.com>
> > > > 
> > > > Add DSS hwmod data for AM43xx.
> > > > 
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > > > 
> > > > Note that this patch was originally send on May 9th [1], changes were requested
> > > > and a new version was sent on May 19th [2], then on May 27th [3] Tomi pinged
> > > > maintainer again and go no response.
> > > > 
> > > > Without this patch, we cannot get display working on any AM437x devices.
> > > > 
> > > > [1] http://marc.info/?l=linux-arm-kernel&m=139963677925227&w=2
> > > > [2] http://marc.info/?l=linux-arm-kernel&m=140049799425512&w=2
> > > > [3] http://marc.info/?l=linux-arm-kernel&m=140117232826754&w=2
> > > > 
> > > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++++++++++++
> > > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > > >  2 files changed, 99 insertions(+)
> > 
> > Sorry for the delay on this.  Have been corresponding with TI management 
> > to figure out what to do about patches for AM43xx.  I don't have boards or 
> > public documentation for these devices, so it's impossible for me to 
> > meaningfully review the patches.  Looks like boards and/or public docs 
> > won't be coming any time soon.
> > 
> > So for my part, here's what I'll need to merge any hwmod or PRCM patches 
> > that involve AM437x:
> > 
> > 1. A Reviewed-by: from one of the following folks (which should come from
> > a different person than who is submitting the patches):
> > 
> > Roger Quadros
> > Nishanth Menon
> > Rajendra Nayak
> > Kevin Hilman
> > Tony Lindgren
> > 
> > 2. A Tested-by: from one of the following folks (who can be the same as 
> > the person who is the same as the person who is submitting the patches):
> > 
> > Nishanth Menon
> > Rajendra Nayak
> > Kevin Hilman 
> > Tony Lindgren
> 
> What you're saying here is that it's pointless for anybody else in TI to
> review and/or test patches because you will only accept such tags from
> this list of 4 ~ 5 people.

That might be how you interpreted the E-mail.  But that's not what was 
written.

For the record, I'm pleased to accept Reviewed-by:s and Tested-by:s from 
anyone.  But, like most maintainers, there are some folks who I think do a 
better job of reviewing and testing hwmod and PRCM patches than others.

The people listed above are a first cut at that list.  I'm certainly happy 
to consider adding others, but the reviewers need:

1. to have experience with those parts of the kernel;

2. to have access to the canonical documentation for AM43xx to review 
against; and

3. to have some kind of track record doing in-depth reviews of patches for 
that subsystem, or writing clean code for that subsystem.


Similarly, for testers, the folks listed above are people who:

1. could actually have AM43xx boards; and

2. who have a history of testing patches against mainline kernels in 
public forums, rather than testing against vendor kernels; and

3. who I think would be mortally embarrassed if a patch was broken 
that they had a Tested-by: for.

(N.B. In the case of anything involving DSS, such as this patch, I'd be 
happy to accept Tested-by:s from Archit or Tomi.)

If you have other people that you think I'm missing from the above two 
lists, who meet those requirements, please suggest some names!

> Quite frankly, it's very upsetting to see an affirmation that all the
> work that I (personally) and many others do is seen as "pointless" from
> your side *unless* it gets the blessing from the few folks listed above.

I'd be curious to know how many of the people listed in the Signed-off-by: 
for these patches have double-checked the data against the TRM (or 
whatever documentation is canonical for this chip).  And have thought 
through whether the data actually makes sense with regards to the SoC 
integration.  I consider those to be the prerequisites for reviewing hwmod 
device data patches.  That's what I generally do myself, and that's what I 
expect from trusted reviewers.

> This just makes it ever more difficult for anything, which is clearly
> *BROKEN* to be fixed upstream and will just contribute to people
> vanishing from mainline development.

Sounds like you might be mixing mailing list threads.  

The description for these patches states:

"Add DSS hwmod data for AM43xx"

Unless I'm missing something, these patches add a feature.  They are not 
fixing something that is broken.

> The very fact that you will only accept patches blessed by the gang-of-4
> goes against the very foundations of open source development. Just
> because you don't have access to documentation - and granted, that
> _does_ make things a lot more difficult - does not mean you have to
> consider an entire company as a non-trust worthy organization. Specially
> when there are so many here who have been doing mainline development for
> quite some time.

As stated, I'm happy to consider adding more folks to the list, but they 
need to have a track record of doing good work in that area, or doing 
in-depth reviews.  If they don't have one yet, well, there's no better 
time to start than the present.

I'm also happy to do the reviews and a basic test myself, if I have 
documentation and a board.

> It doesn't take a brain surgeon to note how this won't scale and, if you 
> continue to ignore patches during the entire development cycle and only 
> reply after it's too late for $this merge window, it won't help much.

...

> Anyway, whatever... I just hope that if we go through *another* merge
> window without $subject being merged

What is this business about "*another* merge window" and "continue to 
ignore"?  Using the dates from your own E-mail message above, the original 
patches were sent May 9th.  This was the same day that v3.15-rc5 was 
released. According to your message, the revised patches were sent May 
19th - three days before v3.15-rc6.

So by the time these patches were ready to go, we'd already reached the 
cutoff point for getting anything merged into v3.16.

I was rather hoping that I'd be able to review it against the AM43xx 
documentation in time, but that turned out not to be available.

If all this has nothing to do with the $SUBJECT patches, and is about the 
DSS clocking issue, and not these patches, that's fine; but please direct 
your flames to that thread instead.

> ps: $subject in particular, has been tested by 3 different people.
> Actually 4, if you consider Darren Etheridge who used $subject to help
> me get display working on AM437x SK.

There are no Tested-by:s on this patch.  It seems likely to me that Tomi 
has tested it against something close to mainline, just based on general 
experience with his level of patch quality in the past, but in general, I 
have no way of knowing this.

So if folks actually tested it against mainline, please do send 
Tested-by:s, and note the mainline commit that it was tested on, along 
with other patches were needed for this patch to apply and/or work.  It's 
also helpful to include a serial console boot log to a Tested-by: message.  
That adds confidence that the patches don't add extra warnings and that 
the commit ID is what's expected.

...

For the specific case of this patch, since it's already been reviewed by 
Rajendra, once there are good Tested-by:s sent to the list, I'd say it's 
ready to merge.


- Paul
