Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaFOD3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:29:43 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:59326 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaFOD3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:29:41 -0400
Date: Sun, 15 Jun 2014 03:29:40 +0000 (UTC)
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
In-Reply-To: <20140614045603.GA28775@saruman.home>
Message-ID: <alpine.DEB.2.02.1406150257380.659@utopia.booyaka.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com> <1402676147-3711-2-git-send-email-balbi@ti.com> <20140613162323.GH8319@saruman.home> <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com> <20140613231019.GA24121@saruman.home>
 <alpine.DEB.2.02.1406140127020.20370@utopia.booyaka.com> <20140614045603.GA28775@saruman.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 13 Jun 2014, Felipe Balbi wrote:

> On Sat, Jun 14, 2014 at 02:57:32AM +0000, Paul Walmsley wrote:
> > > > > > From: Sathya Prakash M R <sathyap@ti.com>
> > > > > > 
> > > > > > Add DSS hwmod data for AM43xx.
> > > > > > 
> > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > > > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > > > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > > > ---
> > > > > > 
> > > > > > Note that this patch was originally send on May 9th [1], changes were requested
> > > > > > and a new version was sent on May 19th [2], then on May 27th [3] Tomi pinged
> > > > > > maintainer again and go no response.
> > > > > > 
> > > > > > Without this patch, we cannot get display working on any AM437x devices.
> > > > > > 
> > > > > > [1] http://marc.info/?l=linux-arm-kernel&m=139963677925227&w=2
> > > > > > [2] http://marc.info/?l=linux-arm-kernel&m=140049799425512&w=2
> > > > > > [3] http://marc.info/?l=linux-arm-kernel&m=140117232826754&w=2
> > > > > > 
> > > > > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++++++++++++
> > > > > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > > > > >  2 files changed, 99 insertions(+)
> > > > 
> > > > Sorry for the delay on this.  Have been corresponding with TI management 
> > > > to figure out what to do about patches for AM43xx.  I don't have boards or 
> > > > public documentation for these devices, so it's impossible for me to 
> > > > meaningfully review the patches.  Looks like boards and/or public docs 
> > > > won't be coming any time soon.
> > > > 
> > > > So for my part, here's what I'll need to merge any hwmod or PRCM patches 
> > > > that involve AM437x:
> > > > 
> > > > 1. A Reviewed-by: from one of the following folks (which should come from
> > > > a different person than who is submitting the patches):
> > > > 
> > > > Roger Quadros
> > > > Nishanth Menon
> > > > Rajendra Nayak
> > > > Kevin Hilman
> > > > Tony Lindgren
> > > > 
> > > > 2. A Tested-by: from one of the following folks (who can be the same as 
> > > > the person who is the same as the person who is submitting the patches):
> > > > 
> > > > Nishanth Menon
> > > > Rajendra Nayak
> > > > Kevin Hilman 
> > > > Tony Lindgren
> > > 
> > > What you're saying here is that it's pointless for anybody else in TI to
> > > review and/or test patches because you will only accept such tags from
> > > this list of 4 ~ 5 people.
> > 
> > That might be how you interpreted the E-mail.  But that's not what was 
> > written.
> 
> of course it was. Read what you wrote:
> 
> "here's what I'll need to *merge* any hwmod or PRCM patches that involve
> AM437x".
> 
> That basically puts down the requirements to getting any patches
> accepted and those requirements are the blessings of a handful.
> 
> > For the record, I'm pleased to accept Reviewed-by:s and Tested-by:s from 
> > anyone.  But, like most maintainers, there are some folks who I think do a 
> > better job of reviewing and testing hwmod and PRCM patches than others.
> > 
> > The people listed above are a first cut at that list.  I'm certainly
> > happy to consider adding others, but the reviewers need:
> > 
> > 1. to have experience with those parts of the kernel;
> > 
> > 2. to have access to the canonical documentation for AM43xx to review
> > against; and
> 
> anybody in ti.com have access to those.
> 
> > 3. to have some kind of track record doing in-depth reviews of patches
> > for that subsystem, or writing clean code for that subsystem.
> > 
> > 
> > Similarly, for testers, the folks listed above are people who:
> > 
> > 1. could actually have AM43xx boards; and
> 
> well, quite a few have rather easy access to multiple (3, to be exact)
> different am437x platforms.
> 
> > 2. who have a history of testing patches against mainline kernels in 
> > public forums, rather than testing against vendor kernels; and
> 
> $subject and patch two have both been tested on top of linux next from
> june 10th. Is that bleeding edge enough for you ? Moreover, *only* these
> two patches were applied on top of Stephen's linux-next.
> 
> > 3. who I think would be mortally embarrassed if a patch was broken 
> > that they had a Tested-by: for.
> 
> right, and when those guys try to get bugs fixed, we spend half a year
> discussing pointless might-happen-when-the-sun-dies problems with other
> drivers even when... aaaah what the heck, you'll just say I'm mixing
> threads again...
> 
> The point is that it has been this back and forth for quite a while now,
> in countless occasions we have missed merge windows because this or that
> maintainer just stops responding and *nobody* else has balls to pick the
> patch up.
> 
> Weeks later social network posts start to arise blaming TI for not
> sending patches upstream.
> 
> > (N.B. In the case of anything involving DSS, such as this patch, I'd be 
> > happy to accept Tested-by:s from Archit or Tomi.)
> > 
> > If you have other people that you think I'm missing from the above two 
> > lists, who meet those requirements, please suggest some names!
> 
> the point is about not having a list. Sure, you need to know some folks
> who you can trust, but sometimes, when it's clear that the patch doesn't
> break anything, follows standard code practices, have passed through
> more than one hand and soaked in the mailing list for months, it's time
> to give up and just let the patch sit in linux-next for a while. You can
> always revert if someone else starts to scream.
> 
> I'm *not* saying that you should blindly accept anything, but not
> accepting patches without a reason isn't fair.
> 
> > > Quite frankly, it's very upsetting to see an affirmation that all the
> > > work that I (personally) and many others do is seen as "pointless" from
> > > your side *unless* it gets the blessing from the few folks listed above.
> > 
> > I'd be curious to know how many of the people listed in the Signed-off-by: 
> > for these patches have double-checked the data against the TRM (or 
> 
> I know I've done it. Have latest am437x Datasheed, TRM and board
> schematics open for quite a while now as I've been hacking this am437x
> StarterKit.
> 
> Also, the thing is functional. Xorg + i3 runs just fine without any
> glitches or bogus colors, or any sort of warnings, errors, anything at
> all.
> 
> > whatever documentation is canonical for this chip).  And have thought 
> > through whether the data actually makes sense with regards to the SoC 
> > integration.  I consider those to be the prerequisites for reviewing hwmod 
> 
> how else would we get the freaking thing to enable clocks ? Or are you
> forgetting that long ago the entire OMAP architecture was made tightly
> coupled with runtime PM and HWMOD; and are you also forgetting that no
> driver is now allowed to call clk_get() directly without hurting
> somebody's feelings ?
> 
> With these details in mind, there's no SoC who depends on mach-omap2
> that can have any chance of *working* without hwmod data.
> 
> > device data patches.  That's what I generally do myself, and that's what I 
> > expect from trusted reviewers.
> 
> alright, so do you see any problems with the patch ? Do you think the
> data isn't necessary ? Instead of just being silent for months, why
> don't you just drop a line ? Reply to the f-ing thread ? How can we make
> any progress if you don't ? Is this what we have to go now ? Send a
> patch and hopefully, some day, it will make its way to mainline ?
> 
> > > This just makes it ever more difficult for anything, which is clearly
> > > *BROKEN* to be fixed upstream and will just contribute to people
> > > vanishing from mainline development.
> > 
> > Sounds like you might be mixing mailing list threads.  
> > 
> > The description for these patches states:
> > 
> > "Add DSS hwmod data for AM43xx"
> > 
> > Unless I'm missing something, these patches add a feature.  They are not 
> > fixing something that is broken.
> 
> without DSS hwmod data, how can display work ? So it _is_ broken indeed.
> The same DSS code is functional in many other SoCs, but it's *broken* in
> am437x because $subject has been pending without *any* reply since
> May 19th.
> 
> > > The very fact that you will only accept patches blessed by the gang-of-4
> > > goes against the very foundations of open source development. Just
> > > because you don't have access to documentation - and granted, that
> > > _does_ make things a lot more difficult - does not mean you have to
> > > consider an entire company as a non-trust worthy organization. Specially
> > > when there are so many here who have been doing mainline development for
> > > quite some time.
> > 
> > As stated, I'm happy to consider adding more folks to the list, but they 
> > need to have a track record of doing good work in that area, or doing 
> > in-depth reviews.  If they don't have one yet, well, there's no better 
> > time to start than the present.
> > 
> > I'm also happy to do the reviews and a basic test myself, if I have 
> > documentation and a board.
> > 
> > > It doesn't take a brain surgeon to note how this won't scale and, if you 
> > > continue to ignore patches during the entire development cycle and only 
> > > reply after it's too late for $this merge window, it won't help much.
> > 
> > ...
> > 
> > > Anyway, whatever... I just hope that if we go through *another* merge
> > > window without $subject being merged
> > 
> > What is this business about "*another* merge window" and "continue to 
> > ignore"?  Using the dates from your own E-mail message above, the original 
> > patches were sent May 9th.  This was the same day that v3.15-rc5 was 
> > released. According to your message, the revised patches were sent May 
> > 19th - three days before v3.15-rc6.
> 
> right, right.. I'm talking in general. This *could* have made it into
> v3.16. There are also other patches which were missed. One of them since
> january.
> 
> > So by the time these patches were ready to go, we'd already reached the 
> > cutoff point for getting anything merged into v3.16.
> 
> not really. We had 3 more tags (3 more weeks) until v3.15 final was
> tagged. Add to that the fact that the merge window is 2 weeks long, 4
> weeks (leaving the last week as padding) seems like enough time.
> 
> > I was rather hoping that I'd be able to review it against the AM43xx 
> > documentation in time, but that turned out not to be available.
> > 
> > If all this has nothing to do with the $SUBJECT patches, and is about the 
> > DSS clocking issue, and not these patches, that's fine; but please direct 
> > your flames to that thread instead.
> > 
> > > ps: $subject in particular, has been tested by 3 different people.
> > > Actually 4, if you consider Darren Etheridge who used $subject to help
> > > me get display working on AM437x SK.
> > 
> > There are no Tested-by:s on this patch.  It seems likely to me that Tomi 
> > has tested it against something close to mainline, just based on general 
> > experience with his level of patch quality in the past, but in general, I 
> > have no way of knowing this.
> 
> SoB usually means the patch was tested by that person. Or are you
> implying that neither me nor Sathya (patch author!!) ever tested the
> patch ? I can post a video on youtube if that makes you happy, but boy
> do I want to avoid doing that...
> 
> > So if folks actually tested it against mainline, please do send 
> > Tested-by:s, and note the mainline commit that it was tested on, along 
> > with other patches were needed for this patch to apply and/or work.  It's 
> > also helpful to include a serial console boot log to a Tested-by: message.  
> > That adds confidence that the patches don't add extra warnings and that 
> > the commit ID is what's expected.
> 
> sure thing, but don't expect everybody to just figure out what's going
> on inside your head. Silent gets us nowhere.
> 
> > For the specific case of this patch, since it's already been reviewed by 
> > Rajendra, once there are good Tested-by:s sent to the list, I'd say it's 
> > ready to merge.
> 
> good Tested-by:s ?
> 
> nice

Felipe, here's what I need:

For boards that I don't have access to, that I don't have 
documentation for, such as the AM43xx and DRA7xx), for me to merge or ack 
SoC infrastructure or PM-related patches, I want to have:

1. a Reviewed-by: from people who:

a. I think know something about SoC integration or PM in general, and 
about OMAP-style integration specifically; and

b. who have a track record of doing strong and detailed reviews of that 
code, or who have contributed significantly to that code in the past.

My initial list of those reviewers is listed above, and I am happy to 
consider extending it or modifying that list.


2. confidence that the patch or series has been tested against a mainline 
commit and isn't obviously breaking other things, like PM, and confidence 
that it's not adding new runtime warnings.

I've listed an initial set of people above who I feel have proven track 
records in testing who I'm happy to accept Tested-by:s without further 
explanation.  I'm sure I've missed some folks and if anyone who should be 
on that list is offended that I didn't mention them, please accept my 
apologies.  For other folks, like yourself, who aren't on that list (yet), 
please just specifically state:

a. what mainline commit they've tested the patch against,

b. what other prerequisite patches were needed for the patch to apply,

c. and a cut-and-paste of the serial console boot log from the boot 
portion of the test.

in such a way that myself or someone else can easily doublecheck it. 

And frankly, I'll probably be happy to merge it.

After someone has done these three things a few times, and I gain 
confidence that they're doing the right thing, I'm happy to add them to 
my list.

The testing doesn't have to be expressed via a Tested-by: tag in cases 
where you're testing as part of a Signed-off-by:.  Just be sure to state 
those three things above as part of the patch or series message.  The boot 
log can either be placed on a different page and linked to, or sent in 
another public E-mail.

If you can get two or three people to do the above, that's great - the 
more, the better.

...

These two steps do not apply to boards that I have in my testbed or which 
I have documentation for (although they would definitely be very welcome 
in those cases too).

...

Regarding the various other complaints in your E-mail:  if you really 
have a burning desire for me to address any of them, aside from just 
wanting to let off frustration and steam, kindly put them in separate 
public E-mails and make sure that I'm included in the To: line.


regards,

- Paul
