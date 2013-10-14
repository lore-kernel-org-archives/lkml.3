Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3JNLo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:44:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3JNLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:44:57 -0400
Date: Mon, 14 Oct 2013 13:44:33 +0200
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
Message-ID: <20131014114433.GE3081@twins.programming.kicks-ass.net>
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
> +static void update_curr_dl(struct rq *rq)
> +{
> +	struct task_struct *curr = rq->curr;
> +	struct sched_dl_entity *dl_se = &curr->dl;
> +	u64 delta_exec;
> +
> +	if (!dl_task(curr) || !on_dl_rq(dl_se))
> +		return;
> +
> +	/*
> +	 * Consumed budget is computed considering the time as
> +	 * observed by schedulable tasks (excluding time spent
> +	 * in hardirq context, etc.)
> +	 */
> +	delta_exec = rq->clock_task - curr->se.exec_start;

Oh, cute.. So we compute deadlines from rq->clock but compute runtime
from rq->clock_task.

So won't that give funny results in that clock_task is generally slower
than clock; so people get more 'time'.

Maybe there's some illumination on this point further on; I'll continue
reading.
