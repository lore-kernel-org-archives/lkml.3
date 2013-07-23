Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab3GWRVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:21:14 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64436 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab3GWRVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130723165319.GC27075@twins.programming.kicks-ass.net>
References: <1374594257.5382.5.camel@localhost.localdomain>
	<20130723154736.GB27075@twins.programming.kicks-ass.net>
	<CADZ9YHgdK86MuGk7QcsYt+pRZpJ7GYG-rUWf77p9jWZvkw+i5w@mail.gmail.com>
	<CADZ9YHj9vQU7Ki2+mCH5TPGUrn_d3V5bks9dumyEGcMwX3XApA@mail.gmail.com>
	<20130723165319.GC27075@twins.programming.kicks-ass.net>
Date: Tue, 23 Jul 2013 23:21:12 +0600
Message-ID: <CADZ9YHj5EUBGkv4E_yAoNqL5nnZ3XFr_axLmiNtNZF3uTmP6kQ@mail.gmail.com>
Subject: Re: [PATCH, RFC] sched: update_top_cache_domain only at the times of
 building sched domain.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:53 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 23, 2013 at 10:20:20PM +0600, Rakib Mullick wrote:
>
>> You mean using sd == NULL rather than using update_cache_domain variable ?
>
> Yes, note how:
>
> @@ -6109,7 +6110,7 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
>
>         rcu_read_lock();
>         for_each_cpu(i, cpu_map)
> -               cpu_attach_domain(NULL, &def_root_domain, i);
>         rcu_read_unlock();
>  }
>
> Always has NULL for sd? Which means you can do:
>
> @@ -5138,7 +5138,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>         rcu_assign_pointer(rq->sd, sd);
>         destroy_sched_domains(tmp, cpu);
>
> -       update_top_cache_domain(cpu);
> +       if (sd)
> +               update_top_cache_domain(cpu);
>  }
>
>  /* cpus with isolated domains */

Okay, got it. Will submit an updated patch!

Thanks
Rakib.
