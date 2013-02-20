Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935698Ab3BTNwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:52:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:43383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935422Ab3BTNwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="293578430"
Message-ID: <5124D514.70302@intel.com>
Date: Wed, 20 Feb 2013 21:52:20 +0800
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
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>   <1361164062-20111-12-git-send-email-alex.shi@intel.com>  <1361353681.10155.10.camel@laptop> <5124BBEA.3040806@intel.com> <1361367469.10155.34.camel@laptop>
In-Reply-To: <1361367469.10155.34.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 09:37 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 20:04 +0800, Alex Shi wrote:
> 
>>>> @@ -5195,6 +5197,8 @@ static int load_balance(int this_cpu, struct rq
>>>> *this_rq,
>>>>                 .idle           = idle,
>>>>                 .loop_break     = sched_nr_migrate_break,
>>>>                 .cpus           = cpus,
>>>> +               .power_lb       = 0,
>>>> +               .perf_lb        = 1,
>>>>         };
>>>>  
>>>>         cpumask_copy(cpus, cpu_active_mask);
>>>
>>> This construct allows for the possibility of power_lb=1,perf_lb=1, does
>>> that make sense? Why not have a single balance_policy enumeration?
>>
>> (power_lb == 1 && perf_lb == 1) is incorrect and impossible to have.
>>
>> (power_lb == 0 && perf_lb == 0) is possible and it means there is no any
>> balance on this cpu.
>>
>> So, enumeration is not enough.
> 
> Huh.. both 0 doesn't make any sense either. If there's no balancing, we
> shouldn't be here to begin with.
> 

Um, both 0 means, there is a balance happen, and we think a power
balance is appropriate for this domain, but maybe this group is already
empty, so the cpu is inappropriate to pull a task, than we exit this
time balancing, to wait another cpu from another appropriate group do
balance and pull a task.

-- 
Thanks
    Alex
