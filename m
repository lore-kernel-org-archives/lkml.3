Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3JaPRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:17:51 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49920 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3JaPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:17:49 -0400
Date: Thu, 31 Oct 2013 11:25:55 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Will Deacon <will.deacon@arm.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
In-Reply-To: <20131030232148.GC27743@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1310311117430.9722@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu> <20131028085700.GB20218@mudshark.cambridge.arm.com> <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu> <20131029042810.GD22291@mudshark.cambridge.arm.com>
 <20131029134536.GD16117@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu> <20131030095615.GG16117@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1310301006190.8668@vincent-weaver-1.um.maine.edu>
 <20131030232148.GC27743@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-343091466-1383233156=:9722"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-343091466-1383233156=:9722
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Oct 2013, Will Deacon wrote:
> On Wed, Oct 30, 2013 at 02:13:11PM +0000, Vince Weaver wrote:
> > Uncompiled too I guess?
> > 
> > kernel/events/core.c: In function ‘perf_event_period’:
> > kernel/events/core.c:3531: error: invalid type argument of ‘->’ (have ‘local64_t’)
> > make[3]: *** [kernel/events/core.o] Error 1
> 
> That's trivial to fix.

Probably, although Peter's been sending some "interesting" mostly untested 
perf patches to linux-kernel the past few days so before testing I'd 
rather have a patch that at least compiles cleanly.

> > I also won't be able to test the ARM change, as my pandaboard won't boot 
> > with recent kernels (can't find the MMC root filesystem) and I haven't had 
> > time to track down why.  Also even on a simple period changing test it 
> > often fails due to lost interrupts (the Cortex-A9 lost interrupt errata?).
> 
> The omap guys like trying to blame the A9 erratum for that (which doesn't
> even affect the cycle counter), but the reality is that the CTI never
> worked reliably with mainline, and now there are no developers working
> on that after the TI layoffs. I don't see the state of Pandaboard support
> improving over time.

So it might be OMAP4460/CTI specific and not related to the errata?
That might be nice especially if things might work on other cortex-a9 
boards.

A shame about the TI people, they were often semi-responsive to my
OMAP4460 questions even if it was usually just to say "ignore the 
documentation, that's broken, don't do that"

> If you have a canned testcase for this stuff, I'm happy to run it on my
> Chromebook.

There's the tests/ioctl/ioctl_period test in my perf_event_tests.git tree
but it's very simple.  Currently it will likely just return success on 
current x86 Linux but fail on newish ARM and patched x86.  I need to 
fix it to print old_behavior/new_behavior/fail I guess.

I have a cortex-a15 chromebook too, but I haven't managed to get a 
recent kernel booting on it yet.

Vince
--8323329-343091466-1383233156=:9722--
