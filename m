Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3C0KXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:23:33 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:49279 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3C0KXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:23:32 -0400
Message-ID: <5152C83F.6060509@linux.vnet.ibm.com>
Date: Wed, 27 Mar 2013 15:51:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        corbet@lwn.net
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364300782.5053.6.camel@laptop>
In-Reply-To: <1364300782.5053.6.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032710-5490-0000-0000-0000032F7301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/26/2013 05:56 PM, Peter Zijlstra wrote:
> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>> +static bool is_buddy_busy(int cpu)
>> +{
>> +       struct rq *rq = cpu_rq(cpu);
>> +
>> +       /*
>> +        * A busy buddy is a CPU with a high load or a small load with
>> a lot of
>> +        * running tasks.
>> +        */
>> +       return (rq->avg.runnable_avg_sum >
>> +                       (rq->avg.runnable_avg_period / (rq->nr_running
>> + 2)));
>> +}
> 
> Why does the comment talk about load but we don't see it in the
> equation. Also, why does nr_running matter at all? I thought we'd
> simply bother with utilization, if fully utilized we're done etc..
> 

Peter, lets say the run-queue has 50% utilization and is running 2
tasks. And we wish to find out if it is busy. We would compare this
metric with the cpu power, which lets say is 100.

rq->util * 100 < cpu_of(rq)->power.

In the above scenario would we declare the cpu _not_busy? Or would we do
the following:

(rq->util * 100) * #nr_running <  cpu_of(rq)->power and conclude that it
is just enough _busy_ to not take on more processes?


@Vincent: Yes the comment above needs to be fixed. A busy buddy is a CPU
with *high rq utilization*, as far as the equation goes.

Regards
Preeti U Murthy

