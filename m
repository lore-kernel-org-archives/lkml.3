Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027Ab3DCH2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:28:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:63217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762636Ab3DCH2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:28:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="312844730"
Message-ID: <515BDA1B.2040801@intel.com>
Date: Wed, 03 Apr 2013 15:28:27 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
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
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com> <515BA0B7.2090906@linux.vnet.ibm.com> <515BAFE6.1020804@intel.com> <515BCA94.6050703@linux.vnet.ibm.com> <515BD1FE.7030901@intel.com> <515BD7DB.6020602@linux.vnet.ibm.com>
In-Reply-To: <515BD7DB.6020602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 03:18 PM, Michael Wang wrote:
>> > the following patch include the renamed knob, and you can tune it under 
>> > /proc/sys/kernel/... to see detailed impact degree.
> Could I make the conclusion that the improvement on pgbench was caused
> by the new weighted_cpuload()?

guess too.
> 
> The burst branch seems to just adopt the load in old world, if reduce
> the rate to enter that branch could regain the benefit, then I could
> confirm my supposition.
> 
>> > 
>> > +	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost ||
>> > +		cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
> It should be 'sysctl_sched_burst_threshold' here, isn't it? anyway, I
> will take a try with different rate.

Ops, sth wrong in my git operation.

-- 
Thanks Alex
