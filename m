Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3KDGZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:25:45 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46227 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3KDGZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:25:44 -0500
Date: Mon, 4 Nov 2013 07:25:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
Message-ID: <20131104062540.GA12149@gmail.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I may be pessimistic, but I'd expect many developers would go "Let's 
> hunt bugs.. Wait. Oooh, shiny" and go off doing some new feature after 
> all instead. Or just take that release off.
> 
> But I do wonder.. Maybe it would be possible, and I'm just unfairly 
> projecting my own inner squirrel onto other kernel developers. If we 
> have enough heads-up that people *know* that for one release (and 
> companies/managers know that too) the only patches that get accepted are 
> the kind that fix bugs, maybe people really would have sufficient 
> attention span that it could work.
> 
> And the reason I mention "4.0" is that it would be a lovely time to do 
> that. Roughly a years heads-up that "ok, after 3.19 (or whatever), we're 
> doing a release with *just* fixes, and then that becomes 4.0".
> 
> Comments?

I think the biggest problem wouldn't even be the enforcement of 
bugfixes-only during that 2.5 months period, or kernel developers 
surviving such a long streak of boredom, but v3.19 would also probably be 
a super-stressful release to maintainers, as everyone would try to cram 
their feature in there. And if anything important misses that window then 
it's a +5 months wait...

The other problem is that kernel developers who do development typically 
fix their own bugs within a week or two. It's not developers that 
typically determine the stability of a subsystem but _maintainers_, and 
the primary method of stabilization is, beyond being careful when merging 
a patch, is to remember/monitor breakages and not merge new feature 
patches from a developer until fixable bugs are fixed by the developer.

Bugs that go on longer are usually the bugs developers cannot reproduce, 
the ones where the timing and progress depends on other, external people. 
For example the NUMA fixes in v3.12 took a couple of full cycles to pin 
down fully. I think waiting another 2-3 months will mostly bring idle time 
and diminishing returns of the long, exponentially decaying tail of 
bugfixes, IMHO.

Thirdly, _users_ interested in stability can already go to the -stable 
kernel, will will suck up 1 cycle worth of bugfixes out of the main flow 
of changes. So users already have a stability choice of v-latest and 
'v-latest - 1' - plus the 'long term' stable kernels as well.

So IMO the main steering parameter of our kernel stabilization process is 
the maintainer directly above a developer, the first-hop maintainer. For 
90-95% of the commits you are the second hop maintainer or higher. So 
whether in 4.0 you are going to take non-fixes will not directly affect 
the stabilization process and flow that is already in place, assuming that 
our current stabilization process is more or less healthy. It will (or 
should) essentially track what our current -stable process is.

But we already have that process in place and it's working well IMO - the 
problem isn't really effort or meta-maintanence issues but lack of good 
stability metrics due to lack of kerneloops.org feedback, etc.

So ... unless you think our current stabilization flow is unhealthy and/or 
you'd like to perform a natural experiment to measure it, why not just do 
what worked so well for v3.0 and afterwards? Keep the existing process in 
place, don't upset it just due to a (comparably) silly number tweak.

Maybe ask first-hop maintainers to be extra super diligent about new 
features in v4.0 by imposing an internal merge window deadline 2 weeks 
before the real merge window [a fair chunk of patches hit maintainer trees 
in the last 2 weeks of the development window, and those cause much of the 
regressions], maybe even reject a few pulls during the merge window that 
blatantly violate these pre-freeze rules, but don't hold up the 
low-latency flow of steady improvements - much of which is driver work, 
platform enablement work, small improvements, etc., which isn't really a 
big source of real regressions for the existing installed base.

Thanks,

	Ingo
