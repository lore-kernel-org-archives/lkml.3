Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3JNOg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:36:26 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33776 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3JNOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:36:25 -0400
Message-ID: <525C0163.2060002@gmail.com>
Date: Mon, 14 Oct 2013 16:36:19 +0200
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
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-4-git-send-email-juri.lelli@gmail.com> <20131014112410.GC3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014112410.GC3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:24 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
>> +/*
>> + * We are being explicitly informed that a new instance is starting,
>> + * and this means that:
>> + *  - the absolute deadline of the entity has to be placed at
>> + *    current time + relative deadline;
>> + *  - the runtime of the entity has to be set to the maximum value.
>> + *
>> + * The capability of specifying such event is useful whenever a -deadline
>> + * entity wants to (try to!) synchronize its behaviour with the scheduler's
>> + * one, and to (try to!) reconcile itself with its own scheduling
>> + * parameters.
>> + */
>> +static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
>> +{
>> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
>> +	struct rq *rq = rq_of_dl_rq(dl_rq);
>> +
>> +	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
>> +
>> +	/*
>> +	 * We use the regular wall clock time to set deadlines in the
>> +	 * future; in fact, we must consider execution overheads (time
>> +	 * spent on hardirq context, etc.).
>> +	 */
>> +	dl_se->deadline = rq->clock + dl_se->dl_deadline;
>> +	dl_se->runtime = dl_se->dl_runtime;
>> +	dl_se->dl_new = 0;
>> +}
> 
> 78becc270975 sched: Use an accessor to read the rq clock
> 
> wants you to use rq_clock(rq) there I think.
> 
> 

Modified here and below.

Thanks,

- Juri
