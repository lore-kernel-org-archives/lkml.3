Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3J3XWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:22:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48659 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab3J3XWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:22:36 -0400
Date: Wed, 30 Oct 2013 23:21:49 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131030232148.GC27743@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
 <20131029042810.GD22291@mudshark.cambridge.arm.com>
 <20131029134536.GD16117@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu>
 <20131030095615.GG16117@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1310301006190.8668@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1310301006190.8668@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:13:11PM +0000, Vince Weaver wrote:
> On Wed, 30 Oct 2013, Peter Zijlstra wrote:
> > The below code should deal with both cases I think -- completely
> > untested.
> 
> Uncompiled too I guess?
> 
> kernel/events/core.c: In function ‘perf_event_period’:
> kernel/events/core.c:3531: error: invalid type argument of ‘->’ (have ‘local64_t’)
> make[3]: *** [kernel/events/core.o] Error 1

That's trivial to fix.

> I also won't be able to test the ARM change, as my pandaboard won't boot 
> with recent kernels (can't find the MMC root filesystem) and I haven't had 
> time to track down why.  Also even on a simple period changing test it 
> often fails due to lost interrupts (the Cortex-A9 lost interrupt errata?).

The omap guys like trying to blame the A9 erratum for that (which doesn't
even affect the cycle counter), but the reality is that the CTI never
worked reliably with mainline, and now there are no developers working
on that after the TI layoffs. I don't see the state of Pandaboard support
improving over time.

If you have a canned testcase for this stuff, I'm happy to run it on my
Chromebook.

Will
