Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3GDU1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 16:27:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:42375 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3GDU1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 16:27:23 -0400
Date: Thu, 4 Jul 2013 22:27:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
cc: Alex Shi <alex.shi@intel.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
In-Reply-To: <1372961512.8728.32.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1307042214090.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de> <1372961512.8728.32.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Davidlohr Bueso wrote:

> On Thu, 2013-07-04 at 13:00 +0200, Thomas Gleixner wrote:
> > On Thu, 4 Jul 2013, Alex Shi wrote:
> > 
> > > We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,
> > > like oltp, tbench, hackbench etc. and bisected the commit 5d33b883ae
> > > cause this regression. Due to this commit, the clocksource was changed
> > > to hpet from tsc even tsc will be set CLOCK_SOURCE_VALID_FOR_HRES later
> > > in clocksource_watchdog. 
> > 
> > 5d33b883ae is not in tip/sched/core. So what are you testing and
> > bisecting?
> 
> I think he's referring to:
> 
> commit 5d33b883aed81c6fbcd09c6f7c3619eee850a7e2

I know what he is referring to. He explicitly mentions this commit:

> > > like oltp, tbench, hackbench etc. and bisected the commit 5d33b883ae

What I was pointing out that he was referring to tip sched/core at the
same time

> > > We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,

And that branch does NOT have that commit included. So how can you see
a regression on a branch caused by a commit NOT included into that
branch?

The offending commit is in tip timers/core and not in tip
sched/core. What I'm wanted to say is, that we need a proper
description of problems and not some random association.

It tricked you to assume, that I'm not able to figure it out myself :)

See? These things are complex and subtle, so we need precise
descriptions and not some sloppy semi correct data.

I'm well aware of the issue and with Peters help I got a reasonable
explanation for it. A proper fix is about to be sent out.

Thanks,

	tglx
