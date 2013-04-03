Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257Ab3DCFld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:41:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:58612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760596Ab3DCFlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="280021771"
Message-ID: <515BC0F6.6060903@intel.com>
Date: Wed, 03 Apr 2013 13:41:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 13/21] sched: using avg_idle to detect bursty wakeup
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-14-git-send-email-alex.shi@intel.com> <876204fbgu.fsf@sejong.aot.lge.com>
In-Reply-To: <876204fbgu.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	struct rq *rq = cpu_rq(i);
>> +
>> +		if (burst && rq->nr_running > 1)
>> +			/* use nr_running as instant utilization */
>> +			sgs->group_util += rq->nr_running;
> 
> I guess multiplying FULL_UTIL to rq->nr_running here will remove
> special-casing the burst in is_sd_full().  Also moving this logic to
> max_rq_util() looks better IMHO.

Yes, right! Thanks a lot!
> 
> 

>> +	if (cpu_rq(cpu)->avg_idle < sysctl_sched_burst_threshold)
>> +		burst = 1;
> 
> Sorry, I don't understand this.
> 
> Given that sysctl_sched_burst_threshold is twice of
> sysctl_sched_migration_cost which is max value of rq->avg_idle, the
> avg_idle will be almost always less than the threshold, right?

In fact, lots of time we have avg_idle at the max value. so won't always
have burst.
> 
> So how does it find out the burst case?  I thought it's the case of a
> cpu is in idle for a while and then wakes number of tasks at once.

Yes.
  If
> so, shouldn't it check whether the avg_idle is *longer* than certain
> threshold?  What am I missing?

avg_idle is smaller when many wakeup happens. update_avg() is not always
increase it.
> 
> Thanks,
> Namhyung
> 

-- 
Thanks Alex
