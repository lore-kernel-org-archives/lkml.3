Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209Ab3BTMLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:11:14 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34768 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934344Ab3BTMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:11:13 -0500
Message-ID: <5124BD07.4050401@linux.vnet.ibm.com>
Date: Wed, 20 Feb 2013 17:39:43 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-7-git-send-email-alex.shi@intel.com> <1361352643.10155.4.camel@laptop>
In-Reply-To: <1361352643.10155.4.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022012-5564-0000-0000-000006AFF2B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>  /*
>>   * This is the main, per-CPU runqueue data structure.
>>   *
>> @@ -481,6 +484,7 @@ struct rq {
>>  #endif
>>  
>>  	struct sched_avg avg;
>> +	unsigned int util;
>>  };
>>  
>>  static inline int cpu_of(struct rq *rq)
> 
> You don't actually compute the rq utilization, you only compute the
> utilization as per the fair class, so if there's significant RT activity
> it'll think the cpu is under-utilized, whihc I think will result in the
> wrong thing.

Correct me if I am wrong,but isn't the current load balancer also
disregarding the real time tasks to calculate the domain/group/cpu level
load too?

What I mean is,if the answer to the above question is yes,then can we
safely assume that the furthur optimizations to the load balancer like
the power aware scheduler and the usage of per entity load tracking can
be done without considering the real time tasks?

Regards
Preeti U Murthy
> 

