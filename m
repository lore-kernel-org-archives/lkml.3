Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaGTHFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 03:05:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39076 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaGTHFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 03:05:53 -0400
Message-ID: <1405839950.6512.49.camel@marge.simpson.net>
Subject: Re: 143e1e28 sched: Rework sched_domain topology definition
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 20 Jul 2014 09:05:50 +0200
In-Reply-To: <20140720065207.GU9918@twins.programming.kicks-ass.net>
References: <1405838616.6512.42.camel@marge.simpson.net>
	 <20140720065207.GU9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-20 at 08:52 +0200, Peter Zijlstra wrote: 
> On Sun, Jul 20, 2014 at 08:43:36AM +0200, Mike Galbraith wrote:
> > Hi,
> > 
> > +/*
> > + * Topology list, bottom-up.
> > + */
> > +static struct sched_domain_topology_level default_topology[] = {
> > +#ifdef CONFIG_SCHED_SMT
> > +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > +#endif
> > +#ifdef CONFIG_SCHED_MC
> > +	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
> > +#endif
> > +#ifdef CONFIG_SCHED_BOOK
> > +	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
> > +#endif
> > +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > +	{ NULL, },
> > +};
> > 
> > Why did this commit rename the CPU domain to DIE?
> 
> Because they're both wrong, but we found that DIE was less wrong than
> CPU.

Ok, doesn't matter anyway, just looks peculiar.

> Seeing how CPU typically means 1 logical, well, CPU, in the scheduler,
> and not the package you stick on your board.
> 
> We chose DIE over PACKAGE due to 1) its shorter name and 2) things like
> interlagos which have multiple DIEs in one PACKAGE etc..

It's actually a good name for some NUMA topologies.  You don't ever want
to see a CPU domain, that sucks cycles, so calling it DIE is fine :)

> Also, the only person who would ever care is the one who (with
> SCHED_DEBUG) enabled looks at the topology setup, which is maybe all of
> us 5.

Maybe a few more, but yeah, not many would care what you called it.

-Mike

