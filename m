Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3J2E3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:29:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33373 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983Ab3J2E27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:28:59 -0400
Date: Tue, 29 Oct 2013 04:28:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131029042810.GD22291@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:07:48PM +0000, Vince Weaver wrote:
> It's also a shame this change apprently didn't hit the linux-kernel list 
> as far as I can tell.  I do my best to try to note all of the perf 
> ABI-related changes there, but if things like this are going to start 
> getting merged in architecture trees then things get that much harder 
> to keep track of.

I can CC LKML on ARM perf patches if you think it will help, but all PMU
backend patches go via their respective arch trees afaict.

> > I don't want to be the `oddball' architecture (at least, not more than I am
> > already :), but I do find it tricky to follow the required semantics of perf
> > as opposed to `it happens to work this way', especially when so much of it
> > is buried in the various arch backends. So if somebody using the thing on
> > ARM has (what looks to me like) a valid issue, then I usually try and fix
> > it.
> 
> But it was global behavior that was common on all architectures.
> 
> Now any cross-platform tool like PAPI is going to have to have a mess of 
> #ifdefs around every use of this ioctl, and it will only get worse if 
> other architectures decide to "fix" the problem too.

What would you like me to do to fix this for you? Moving more code out of
the backends and into the core will help maintain consistency between
architectures, but that's a huge job.

Will
