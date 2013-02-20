Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935190Ab3BTMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:09:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:15587 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934395Ab3BTMJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:09:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,701,1355126400"; 
   d="scan'208";a="289537422"
Message-ID: <5124BCEB.8030606@intel.com>
Date: Wed, 20 Feb 2013 20:09:15 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-10-git-send-email-alex.shi@intel.com> <1361353360.10155.9.camel@laptop>
In-Reply-To: <1361353360.10155.9.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:42 PM, Peter Zijlstra wrote:
> On Mon, 2013-02-18 at 13:07 +0800, Alex Shi wrote:
>> +/*
>> + * Try to collect the task running number and capacity of the group.
>> + */
>> +static void get_sg_power_stats(struct sched_group *group,
>> +       struct sched_domain *sd, struct sg_lb_stats *sgs)
>> +{
>> +       int i;
>> +
>> +       for_each_cpu(i, sched_group_cpus(group)) {
>> +               struct rq *rq = cpu_rq(i);
>> +
>> +               sgs->group_utils += rq->nr_running;
>> +       }
>> +
>> +       sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
>> +                                               SCHED_POWER_SCALE);
>> +       if (!sgs->group_capacity)
>> +               sgs->group_capacity = fix_small_capacity(sd, group);
>> +       sgs->group_weight = group->group_weight;
>> +}
> 
> So you're trying to compute the group utilization, but what does that
> have to do with nr_running? In an earlier patch you introduced the
> per-cpu utilization, so why not avg that to compute the group
> utilization?

I had tried to use rq utilisation in this balancing, but since the
utilisation need much time to accumulate itself(345ms). It's bad for
any burst balancing. So I use instant utilisation -- nr_running.

> 



-- 
Thanks
    Alex
