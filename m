Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3J2Npt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:45:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49194 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3J2Nps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:45:48 -0400
Date: Tue, 29 Oct 2013 14:45:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131029134536.GD16117@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
 <20131029042810.GD22291@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029042810.GD22291@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 04:28:10AM +0000, Will Deacon wrote:
> On Mon, Oct 28, 2013 at 02:07:48PM +0000, Vince Weaver wrote:
> > It's also a shame this change apprently didn't hit the linux-kernel list 
> > as far as I can tell.  I do my best to try to note all of the perf 
> > ABI-related changes there, but if things like this are going to start 
> > getting merged in architecture trees then things get that much harder 
> > to keep track of.
> 
> I can CC LKML on ARM perf patches if you think it will help, but all PMU
> backend patches go via their respective arch trees afaict.

Just those that change user visible semantics that are shared between
archs I suppose :-)

> > > I don't want to be the `oddball' architecture (at least, not more than I am
> > > already :), but I do find it tricky to follow the required semantics of perf
> > > as opposed to `it happens to work this way', especially when so much of it
> > > is buried in the various arch backends. So if somebody using the thing on
> > > ARM has (what looks to me like) a valid issue, then I usually try and fix
> > > it.
> > 
> > But it was global behavior that was common on all architectures.
> > 
> > Now any cross-platform tool like PAPI is going to have to have a mess of 
> > #ifdefs around every use of this ioctl, and it will only get worse if 
> > other architectures decide to "fix" the problem too.
> 
> What would you like me to do to fix this for you? Moving more code out of
> the backends and into the core will help maintain consistency between
> architectures, but that's a huge job.

We could start by making all archs do the same thing again; but yes
ideally we'd move some of it into generic code. Not entirely sure how
that will work out though, there's a reason its in per-arch code :/


Vince, what would you prefer to do here?
