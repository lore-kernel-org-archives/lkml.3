Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaE0DSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:18:13 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:59271 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaE0DSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:18:10 -0400
Date: Mon, 26 May 2014 23:18:08 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/6] sched/fair.c: remove "power" from struct
 numa_stats
In-Reply-To: <1401160028.5134.7.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.11.1405262315210.17310@knanqh.ubzr>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org> <1401142779-6633-2-git-send-email-nicolas.pitre@linaro.org> <1401160028.5134.7.camel@marge.simpson.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Mike Galbraith wrote:

> On Mon, 2014-05-26 at 18:19 -0400, Nicolas Pitre wrote: 
> > 
> > @@ -1046,7 +1046,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
> >  
> >  		ns->nr_running += rq->nr_running;
> >  		ns->load += weighted_cpuload(cpu);
> > -		ns->power += power_of(cpu);
> > +		ns->compute_capacity += power_of(cpu);
> 
> power_of(cpu) as a capacity input looks odd now.. 
> 
> > @@ -1062,9 +1062,10 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
> >  	if (!cpus)
> >  		return;
> >  
> > -	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->power;
> > -	ns->capacity = DIV_ROUND_CLOSEST(ns->power, SCHED_POWER_SCALE);
> > -	ns->has_capacity = (ns->nr_running < ns->capacity);
> > +	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->compute_capacity;
> > +	ns->task_capacity =
> > +		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_POWER_SCALE);
> 
> ..as do SCHED_POWER_SCALE, update_cpu_power() etc.

The rest is renamed in a later patch.  I wanted to split it into 
multiple patches to keep those changes manageable.


Nicolas
