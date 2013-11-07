Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3KGEif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:38:35 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55727 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3KGEid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:38:33 -0500
Date: Wed, 6 Nov 2013 20:40:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
Message-ID: <20131107044052.GA11459@kroah.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
 <20131104062540.GA12149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104062540.GA12149@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 07:25:40AM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So I may be pessimistic, but I'd expect many developers would go "Let's 
> > hunt bugs.. Wait. Oooh, shiny" and go off doing some new feature after 
> > all instead. Or just take that release off.
> > 
> > But I do wonder.. Maybe it would be possible, and I'm just unfairly 
> > projecting my own inner squirrel onto other kernel developers. If we 
> > have enough heads-up that people *know* that for one release (and 
> > companies/managers know that too) the only patches that get accepted are 
> > the kind that fix bugs, maybe people really would have sufficient 
> > attention span that it could work.
> > 
> > And the reason I mention "4.0" is that it would be a lovely time to do 
> > that. Roughly a years heads-up that "ok, after 3.19 (or whatever), we're 
> > doing a release with *just* fixes, and then that becomes 4.0".
> > 
> > Comments?
> 
> I think the biggest problem wouldn't even be the enforcement of 
> bugfixes-only during that 2.5 months period, or kernel developers 
> surviving such a long streak of boredom, but v3.19 would also probably be 
> a super-stressful release to maintainers, as everyone would try to cram 
> their feature in there. And if anything important misses that window then 
> it's a +5 months wait...

I second this statement.  The presure that people will be trying to cram
stuff into the "bugfix-only-release" - 1 will be huge, I see it today
when people are trying to guess as to what the next longterm-stable
kernel is going to be and they throw thing in that are half-baked just
because they know then can "fix it up" later with "bugfixes".

Maintainers have a hard enough time handling patches from developers,
trying to sift them into a "bugfix for this release" and "new
feature/option for next release" bucket, all the time having to educate
the developers that the merge window is for the maintainers, it does not
mean it is time for developers to send new subsystems / drivers /
features in after a 3.x-final release is done by you and expect it to
get reviewed and merged before 3.x-rc1 comes out.

> Bugs that go on longer are usually the bugs developers cannot reproduce, 
> the ones where the timing and progress depends on other, external people. 
> For example the NUMA fixes in v3.12 took a couple of full cycles to pin 
> down fully. I think waiting another 2-3 months will mostly bring idle time 
> and diminishing returns of the long, exponentially decaying tail of 
> bugfixes, IMHO.
> 
> Thirdly, _users_ interested in stability can already go to the -stable 
> kernel, will will suck up 1 cycle worth of bugfixes out of the main flow 
> of changes. So users already have a stability choice of v-latest and 
> 'v-latest - 1' - plus the 'long term' stable kernels as well.

I think (but I'm probably biased here), that the -stable releases are
doing this pretty well.  The fact that we had 4,000 bugfixes added to
the 3.0-stable kernel is a testament to the fact that developers and
users are paying more attention to the stable kernel releases, and are
asking for things to be included there that they hadn't been before.
It's taken 8 years to educate people about this process, and still,
maintainers don't do this today, as was evident in my kernel summit talk
about the stable tree.  I think pushing those maintainers to start
tagging things for stable releases will benefit everyone much more than
having a "bugfix only" release.

> So ... unless you think our current stabilization flow is unhealthy and/or 
> you'd like to perform a natural experiment to measure it, why not just do 
> what worked so well for v3.0 and afterwards? Keep the existing process in 
> place, don't upset it just due to a (comparably) silly number tweak.

I agree.

> Maybe ask first-hop maintainers to be extra super diligent about new 
> features in v4.0 by imposing an internal merge window deadline 2 weeks 
> before the real merge window [a fair chunk of patches hit maintainer trees 
> in the last 2 weeks of the development window, and those cause much of the 
> regressions], maybe even reject a few pulls during the merge window that 
> blatantly violate these pre-freeze rules, but don't hold up the 
> low-latency flow of steady improvements - much of which is driver work, 
> platform enablement work, small improvements, etc., which isn't really a 
> big source of real regressions for the existing installed base.

A 2 week merge window deadline would help out a lot with a number of
some of the bugs we get during the -rc cycle, but there's always going
to be issues found with wider testing, so I'm not quite sure that will
help out all that much in the end.

Anyway, I think this might be tougher than expected, and put more work
on the maintainers who are going to have to queue up stuff for 3 extra
months in their trees, because it's not like things are just going to
not come in to us because Linus isn't taking them at the moment.

thanks,

greg k-h
