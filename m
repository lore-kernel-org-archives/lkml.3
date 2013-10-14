Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3JNV0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:26:16 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35682 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3JNV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:26:13 -0400
Message-ID: <525C6170.1060901@gmail.com>
Date: Mon, 14 Oct 2013 23:26:08 +0200
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
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-4-git-send-email-juri.lelli@gmail.com> <20131014115138.GG3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014115138.GG3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:51 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
>> +static void set_cpus_allowed_dl(struct task_struct *p,
>> +				const struct cpumask *new_mask)
>> +{
>> +	int weight = cpumask_weight(new_mask);
>> +
>> +	BUG_ON(!dl_task(p));
>> +
>> +	cpumask_copy(&p->cpus_allowed, new_mask);
>> +	p->dl.nr_cpus_allowed = weight;
>> +}
> 
> This seems identical so the default in do_set_cpus_allowed(); can we
> leave this function out and use the default?
> 

Another thing that is changed completely in next patch. Anyway, I removed it
from here too.

Thanks,

- Juri
