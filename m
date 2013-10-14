Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3JNMD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:03:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3JNMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:03:26 -0400
Date: Mon, 14 Oct 2013 14:03:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 04/14] sched: SCHED_DEADLINE SMP-related data structures
 & logic.
Message-ID: <20131014120306.GH3081@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-5-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381747426-31334-5-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:43:36PM +0200, Juri Lelli wrote:
> +static inline void dl_set_overload(struct rq *rq)
> +{
> +	if (!rq->online)
> +		return;
> +
> +	cpumask_set_cpu(rq->cpu, rq->rd->dlo_mask);
> +	/*
> +	 * Must be visible before the overload count is
> +	 * set (as in sched_rt.c).
> +	 */
> +	wmb();
> +	atomic_inc(&rq->rd->dlo_count);
> +}

Please, make that smp_wmb() and modify the comment to point to the
matching barrier ; I couldn't find one! Which suggests something is
amiss.

Ideally we'd have something like smp_wmb__after_set_bit() but alas.
