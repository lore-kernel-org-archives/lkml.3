Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaE0EcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:32:22 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44170 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaE0EcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:32:20 -0400
Message-ID: <1401165136.5134.34.camel@marge.simpson.net>
Subject: Re: [PATCH v2 1/6] sched/fair.c: remove "power" from struct
 numa_stats
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Date: Tue, 27 May 2014 06:32:16 +0200
In-Reply-To: <alpine.LFD.2.11.1405262315210.17310@knanqh.ubzr>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
	 <1401142779-6633-2-git-send-email-nicolas.pitre@linaro.org>
	 <1401160028.5134.7.camel@marge.simpson.net>
	 <alpine.LFD.2.11.1405262315210.17310@knanqh.ubzr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 23:18 -0400, Nicolas Pitre wrote: 
> On Tue, 27 May 2014, Mike Galbraith wrote:
> 
> > On Mon, 2014-05-26 at 18:19 -0400, Nicolas Pitre wrote: 
> > > 
> > > @@ -1046,7 +1046,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
> > >  
> > >  		ns->nr_running += rq->nr_running;
> > >  		ns->load += weighted_cpuload(cpu);
> > > -		ns->power += power_of(cpu);
> > > +		ns->compute_capacity += power_of(cpu);
> > 
> > power_of(cpu) as a capacity input looks odd now.. 
> > 
> > > @@ -1062,9 +1062,10 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
> > >  	if (!cpus)
> > >  		return;
> > >  
> > > -	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->power;
> > > -	ns->capacity = DIV_ROUND_CLOSEST(ns->power, SCHED_POWER_SCALE);
> > > -	ns->has_capacity = (ns->nr_running < ns->capacity);
> > > +	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->compute_capacity;
> > > +	ns->task_capacity =
> > > +		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_POWER_SCALE);
> > 
> > ..as do SCHED_POWER_SCALE, update_cpu_power() etc.
> 
> The rest is renamed in a later patch.  I wanted to split it into 
> multiple patches to keep those changes manageable.

I don't see a lot of benefit in creating intermediate inconsistencies vs
one bulk rename, but it does make smaller patches, so never mind.

-Mike

