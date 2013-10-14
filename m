Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3JNLYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:24:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNLYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:24:30 -0400
Date: Mon, 14 Oct 2013 13:24:10 +0200
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
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
Message-ID: <20131014112410.GC3081@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-4-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381747426-31334-4-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
> +/*
> + * We are being explicitly informed that a new instance is starting,
> + * and this means that:
> + *  - the absolute deadline of the entity has to be placed at
> + *    current time + relative deadline;
> + *  - the runtime of the entity has to be set to the maximum value.
> + *
> + * The capability of specifying such event is useful whenever a -deadline
> + * entity wants to (try to!) synchronize its behaviour with the scheduler's
> + * one, and to (try to!) reconcile itself with its own scheduling
> + * parameters.
> + */
> +static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
> +
> +	/*
> +	 * We use the regular wall clock time to set deadlines in the
> +	 * future; in fact, we must consider execution overheads (time
> +	 * spent on hardirq context, etc.).
> +	 */
> +	dl_se->deadline = rq->clock + dl_se->dl_deadline;
> +	dl_se->runtime = dl_se->dl_runtime;
> +	dl_se->dl_new = 0;
> +}

78becc270975 sched: Use an accessor to read the rq clock

wants you to use rq_clock(rq) there I think.


