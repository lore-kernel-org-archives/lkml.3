Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3IJH0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:26:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3IJH0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:26:43 -0400
Message-ID: <1378797995.6046.54.camel@marge.simpson.net>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
From: Mike Galbraith <bitbucket@online.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 10 Sep 2013 09:26:35 +0200
In-Reply-To: <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	 <1378795659.6046.41.camel@marge.simpson.net>
	 <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:2fA3alw38ZwH/cPuTta53TBfYPlEYb57psKtWjd/b3B
 pKfDLqElpKHktXNLx3Dc1jwUTPDhHzXLTrdfNoeEjCyQJsc35j
 m+hJ6DfQjt3Jm2RoqxknB7UHu4NGV3OHgrwai7gnR1OCj3bRfB
 JohClkthRseNZGGraHrJWrrpLqejDSluCPuHHe5hqKBjq3KyEk
 FxibSylSkXCezoWuilBJkHOAScXJuR3R/cIZ1WzBlVfpx/fuJG
 RLwyKyvik92Yr1UwtFLTgvMFCyK5Idxigd213Dp1TtlvCYhDTI
 n8/1YNXP+9PM/21Nytrw223i8QbMBeOtLsnsw9uMXp+9oW1aUF
 9+Q9CvrM0UzlXsKI9pH1ju2Z3viNMQ/sgGGdbNodQ6HdUa0mvP
 p/nDcx/VaQqlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 09:59 +0300, Gilad Ben-Yossef wrote: 
> Hi,
> 
> 
> On Tue, Sep 10, 2013 at 9:47 AM, Mike Galbraith <bitbucket@online.de> wrote:
> >
> > On Tue, 2013-09-10 at 09:05 +0300, Gilad Ben-Yossef wrote:
> > > Hi,
> > >
> > > On Thu, Sep 5, 2013 at 11:07 PM, Christoph Lameter <cl@linux.com> wrote:
> > > > I am not sure how to call this kernel option but we need something like
> > > > that. I see drivers and the kernel spawning processes on the nohz cores.
> > > > The name kthread is not really catching the purpose.
> > > >
> > > > os_cpus=? highlatency_cpus=?
> > > >
> > >
> > > First off, thank you for doing this. It is very useful :-)
> > >
> > > Currently if one wishes to run a single task on an isolated CPU with
> > > as little interference as possible, one needs to pass
> > > rcu_nocbs, isolcpus, nohz_full parameters and now kthread parameter,
> > > all pretty much with the same values
> > >
> > > I know some people won't like this, but can we perhaps fold all these
> > > into a single parameter, perhaps even the existing isolcpus?
> >
> > isolcpus is supposed to go away, as cpusets can isolate CPUs, and can
> > turn off load balancing.
> >
> 
> And I'm all for that. I think cpusets is a much more elegant solution.
> 
> But... AFAIK currently cpusets cannot migrate timers that were registered on
> a cpu prior to it being isolated via cpuset, designate RCU off loaded CPUs or
> sets cpus as full nohz capable, or - it seems from this patch, keep off certain
> kernel thread off a cpu.
> 
> This is no fault of cpusets, but it still means there are work loads
> that it can't
> support at this time.
> 
> So long as we must  have a kernel boot option, I prefer to have one
> and not four of
> them. Think of it this way - when we put all these capabilities into
> cpusets, we'll have
> just one kernel option to kill and not four.
> 
> Does that makes sense?

Hammering on the wrong spot makes removing isolcpus take longer, and
adds up to more hammering in the long run, no?  Hearing you mention
isolcpus, I just thought I should mention that it wants to go away, so
might not be the optimal spot for isolation related tinkering.

-Mike

