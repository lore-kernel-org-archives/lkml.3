Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaFIKUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:20:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45840 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752948AbaFIKU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:20:28 -0400
Date: Mon, 9 Jun 2014 11:20:27 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Henrik Austad <henrik@austad.us>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140609102027.GA29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140608060316.GA18179@austad.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 07:03:16AM +0100, Henrik Austad wrote:
> On Fri, May 23, 2014 at 07:16:29PM +0100, Morten Rasmussen wrote:
> > The Energy-aware scheduler implementation is guarded by
> > CONFIG_SCHED_ENERGY.
> > 
> > Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > ---
> >  arch/arm/Kconfig |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index ab438cb..bfc3a85 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> 
> Is this going to be duplicate for each architecture enabling this? Why
> not make a kernel/Kconfig.energy and link to that from those
> architectures using it?

kernel/Kconfig.energy is better I think.

> 
> > @@ -1926,6 +1926,11 @@ config XEN
> >  	help
> >  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> >  
> > +config SCHED_ENERGY
> > +	bool "Energy-aware scheduling (EXPERIMENTAL)"
> > +	help
> > +	  Highly experimental energy aware task scheduling.
> > +
> 
> how about adding *slightly* more info here? :) (yes, yes, I know it's an RFC)

Fair point.

> 
> """
> Highly experimental energy aware task scheduling.
> 
> This will allow the kernel to keep track of energy required for
> different capacity levels for a given CPU. That way, the scheduler can
> make more informed decisions as to where a newly woken task should be
> placed. Heterogenous platform will benefit the most from this option.

Platforms with hierarchical power domains (for example, having ability
to power off groups of cpus and their caches) should see some benefit as
well.

> Enabling this will add a significant overhead for a task-switch.

The overhead is at task wakeup, task switch (as in task preemption)
should not be affected.

Thanks for the text. I will roll into v2.

Morten
