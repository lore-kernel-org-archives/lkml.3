Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab3HHMNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:13:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab3HHMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:13:53 -0400
Date: Thu, 8 Aug 2013 13:13:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "trinity@vger.kernel.org" <trinity@vger.kernel.org>
Subject: Re: perf,arm -- another (different) fuzzer oops
Message-ID: <20130808121337.GC18724@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu>
 <20130807223129.GA17118@mudshark.cambridge.arm.com>
 <5202D5B0.9020107@codeaurora.org>
 <alpine.DEB.2.10.1308072227060.16962@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308072251210.20629@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308072251210.20629@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 03:53:31AM +0100, Vince Weaver wrote:
> On Wed, 7 Aug 2013, Vince Weaver wrote:
> > On Wed, 7 Aug 2013, Stephen Boyd wrote:
> > > diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> > > index d9f5cd4..21f7790 100644
> > > --- a/arch/arm/kernel/perf_event.c
> > > +++ b/arch/arm/kernel/perf_event.c
> > > @@ -53,7 +53,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
> > >  static int
> > >  armpmu_map_hw_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
> > >  {
> > > -       int mapping = (*event_map)[config];
> > > +       int mapping;
> > > +
> > > +       if (config >= PERF_COUNT_HW_MAX)
> > > +               return -ENOENT;
> > > +
> > > +       mapping = (*event_map)[config];
> > >         return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
> > >  }
> > 
> > I've tested this patch and my testcase no longer causes the kernel to 
> > oops, so 
> > 
> > Tested-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> P.S.  I re-ran the fuzzer again after applying the patch and the good news 
>       is there were no further oopsen.  The bad news is the machine locked 
>       up solid.  I'll investigate further when I'm not remote.

On the flip side, the good news is that we know the problem is there. We're
probably generating interrupts at some horrendous rate for the lock-up....
are you running your fuzzer as root?

Also, is your fuzzer available somewhere? I could take it for a spin on some
different architectures if you like.

Thanks,

Will
