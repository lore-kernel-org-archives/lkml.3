Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3JNQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:16:56 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62789 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3JNQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:16:55 -0400
Message-ID: <525C18F2.9050205@gmail.com>
Date: Mon, 14 Oct 2013 18:16:50 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-4-git-send-email-juri.lelli@gmail.com> <20131014113301.GD3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014113301.GD3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:33 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
>> +static void replenish_dl_entity(struct sched_dl_entity *dl_se)
>> +{
>> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
>> +	struct rq *rq = rq_of_dl_rq(dl_rq);
>> +
>> +	/*
>> +	 * We keep moving the deadline away until we get some
>> +	 * available runtime for the entity. This ensures correct
>> +	 * handling of situations where the runtime overrun is
>> +	 * arbitrary large.
>> +	 */
>> +	while (dl_se->runtime <= 0) {
>> +		dl_se->deadline += dl_se->dl_deadline;
>> +		dl_se->runtime += dl_se->dl_runtime;
>> +	}
> 
> Are we sure GCC won't be 'smart' and bite us; that is do we need
> something like:
> 
>   asm("" : "+rm" (dl_se->runtime));
> 
> in there? See:
> 
> 0d98bb2656e9 sched: Prevent compiler from optimising the sched_avg_update() loop
> 

When disassembled everything seems fine, at least for x86 and ARM. Do I add the
fake data hazard anyway?

Thanks,

- Juri
