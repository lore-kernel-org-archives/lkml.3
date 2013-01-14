Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3ANI3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:29:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:4645 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab3ANI33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:29:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,466,1355126400"; 
   d="scan'208";a="273419950"
Message-ID: <50F3C222.6050002@intel.com>
Date: Mon, 14 Jan 2013 16:30:26 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/22] sched: add power aware scheduling in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-17-git-send-email-alex.shi@intel.com> <87txqknt5m.fsf@sejong.aot.lge.com>
In-Reply-To: <87txqknt5m.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +/*
>> + * Try to collect the task running number and capacity of the doamin.
>> + */
>> +static void get_sd_power_stats(struct sched_domain *sd,
>> +		struct task_struct *p, struct sd_lb_stats *sds)
>> +{
>> +	struct sched_group *group;
>> +	struct sg_lb_stats sgs;
>> +	int sd_min_delta = INT_MAX;
>> +	int cpu = task_cpu(p);
>> +
>> +	group = sd->groups;
>> +	do {
>> +		long g_delta;
>> +		unsigned long threshold;
>> +
>> +		if (!cpumask_test_cpu(cpu, sched_group_mask(group)))
>> +			continue;
> 
> Why?
> 
> That means only local group's stat will be accounted for this domain,
> right?  Is it your intension?
> 

Uh, Thanks a lot for finding this bug!
it is a mistake, should be:
+               if (!cpumask_intersects(sched_group_cpus(group),
+                                       tsk_cpus_allowed(p)))
+                       continue;

-- 
Thanks Alex
