Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab3GWQx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:53:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3GWQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:53:26 -0400
Date: Tue, 23 Jul 2013 18:53:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sched: update_top_cache_domain only at the times of
 building sched domain.
Message-ID: <20130723165319.GC27075@twins.programming.kicks-ass.net>
References: <1374594257.5382.5.camel@localhost.localdomain>
 <20130723154736.GB27075@twins.programming.kicks-ass.net>
 <CADZ9YHgdK86MuGk7QcsYt+pRZpJ7GYG-rUWf77p9jWZvkw+i5w@mail.gmail.com>
 <CADZ9YHj9vQU7Ki2+mCH5TPGUrn_d3V5bks9dumyEGcMwX3XApA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHj9vQU7Ki2+mCH5TPGUrn_d3V5bks9dumyEGcMwX3XApA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:20:20PM +0600, Rakib Mullick wrote:

> You mean using sd == NULL rather than using update_cache_domain variable ?

Yes, note how:

@@ -6109,7 +6110,7 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)

        rcu_read_lock();
        for_each_cpu(i, cpu_map)
-               cpu_attach_domain(NULL, &def_root_domain, i);
        rcu_read_unlock();
 }

Always has NULL for sd? Which means you can do:

@@ -5138,7 +5138,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
        rcu_assign_pointer(rq->sd, sd);
        destroy_sched_domains(tmp, cpu);

-       update_top_cache_domain(cpu);
+       if (sd)
+               update_top_cache_domain(cpu);
 }

 /* cpus with isolated domains */
