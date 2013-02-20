Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab3BTOhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:37:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:12725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182Ab3BTOhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:37:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="293602977"
Message-ID: <5124DF88.5050908@intel.com>
Date: Wed, 20 Feb 2013 22:36:56 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-7-git-send-email-alex.shi@intel.com>  <1361352643.10155.4.camel@laptop> <5124BD07.4050401@linux.vnet.ibm.com> <1361367264.10155.31.camel@laptop>
In-Reply-To: <1361367264.10155.31.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 09:34 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 17:39 +0530, Preeti U Murthy wrote:
>> Hi,
>>
>>>>  /*
>>>>   * This is the main, per-CPU runqueue data structure.
>>>>   *
>>>> @@ -481,6 +484,7 @@ struct rq {
>>>>  #endif
>>>>  
>>>>  	struct sched_avg avg;
>>>> +	unsigned int util;
>>>>  };
>>>>  
>>>>  static inline int cpu_of(struct rq *rq)
>>>
>>> You don't actually compute the rq utilization, you only compute the
>>> utilization as per the fair class, so if there's significant RT activity
>>> it'll think the cpu is under-utilized, whihc I think will result in the
>>> wrong thing.
>>
>> Correct me if I am wrong,but isn't the current load balancer also
>> disregarding the real time tasks to calculate the domain/group/cpu level
>> load too?
> 
> Nope, the rt utilization affects the cpu_power, thereby correcting the
> weight stuff.

The balance policy use group capacity, that implicated using cpu power,
but seems capacity is a very rough data.
> 
> 


-- 
Thanks
    Alex
