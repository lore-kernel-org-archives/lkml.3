Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997Ab3DCDYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:24:17 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44890 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461Ab3DCDYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:24:15 -0400
Message-ID: <515BA0B7.2090906@linux.vnet.ibm.com>
Date: Wed, 03 Apr 2013 11:23:35 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com>
In-Reply-To: <515B9A7A.6030807@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040303-0260-0000-0000-000002C10842
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:56 AM, Alex Shi wrote:
> On 04/03/2013 10:46 AM, Michael Wang wrote:
>> | 15 GB   |      16 | 45110 |   | 48091 |
>> | 15 GB   |      24 | 41415 |   | 47415 |
>> | 15 GB   |      32 | 35988 |   | 45749 |	+27.12%
>>
>> Very nice improvement, I'd like to test it with the wake-affine throttle
>> patch later, let's see what will happen ;-)
>>
>> Any idea on why the last one caused the regression?
> 
> you can change the burst threshold: sysctl_sched_migration_cost, to see
> what's happen with different value. create a similar knob and tune it.
> +
> +	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost)
> +		burst_this = 1;
> +	if (cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
> +		burst_prev = 1;
> +
> 
> 

This changing the rate of adopt cpu_rq(cpu)->load.weight, correct?

So if rq is busy, cpu_rq(cpu)->load.weight is capable enough to stand
for the load status of rq? what's the really idea here?

> BTW, what's the job thread behaviour of pgbench, guess it has lots of
> wakeup. what's the work and sleep ratio of pgbench?

I won't do the summary unless I reviewed it's code :) what I know is,
it's a database benchmark, with several process operating database, see
below one for details:

pgbench is a simple program for running benchmark tests on PostgreSQL.
It runs the same sequence of SQL commands over and over, possibly in
multiple concurrent database sessions, and then calculates the average
transaction rate (transactions per second). By default, pgbench tests a
scenario that is loosely based on TPC-B, involving five SELECT, UPDATE,
and INSERT commands per transaction. However, it is easy to test other
cases by writing your own transaction script files.

Regards,
Michael Wang

> 

