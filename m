Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab3BTMFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:05:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:21275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935127Ab3BTMFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:05:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,701,1355126400"; 
   d="scan'208";a="265027913"
Message-ID: <5124BBEA.3040806@intel.com>
Date: Wed, 20 Feb 2013 20:04:58 +0800
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-12-git-send-email-alex.shi@intel.com> <1361353681.10155.10.camel@laptop>
In-Reply-To: <1361353681.10155.10.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:48 PM, Peter Zijlstra wrote:
> On Mon, 2013-02-18 at 13:07 +0800, Alex Shi wrote:
>> @@ -4053,6 +4053,8 @@ struct lb_env {
>>         unsigned int            loop;
>>         unsigned int            loop_break;
>>         unsigned int            loop_max;
>> +       int                     power_lb;  /* if power balance needed
>> */
>> +       int                     perf_lb;   /* if performance balance
>> needed */
>>  };
>>  
>>  /*
>> @@ -5195,6 +5197,8 @@ static int load_balance(int this_cpu, struct rq
>> *this_rq,
>>                 .idle           = idle,
>>                 .loop_break     = sched_nr_migrate_break,
>>                 .cpus           = cpus,
>> +               .power_lb       = 0,
>> +               .perf_lb        = 1,
>>         };
>>  
>>         cpumask_copy(cpus, cpu_active_mask);
> 
> This construct allows for the possibility of power_lb=1,perf_lb=1, does
> that make sense? Why not have a single balance_policy enumeration?

(power_lb == 1 && perf_lb == 1) is incorrect and impossible to have.

(power_lb == 0 && perf_lb == 0) is possible and it means there is no any
balance on this cpu.

So, enumeration is not enough.
> 


-- 
Thanks
    Alex
