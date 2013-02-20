Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab3BTOJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:09:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:17730 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935393Ab3BTOJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:09:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="265087132"
Message-ID: <5124D8F4.6030108@intel.com>
Date: Wed, 20 Feb 2013 22:08:52 +0800
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-12-git-send-email-alex.shi@intel.com>  <1361353681.10155.10.camel@laptop> <5124BBEA.3040806@intel.com>  <1361367469.10155.34.camel@laptop> <1361368088.10155.36.camel@laptop>
In-Reply-To: <1361368088.10155.36.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> (power_lb == 1 && perf_lb == 1) is incorrect and impossible to have.
>>>
>>> (power_lb == 0 && perf_lb == 0) is possible and it means there is no any
>>> balance on this cpu.
>>>
>>> So, enumeration is not enough.
>>
>> Huh.. both 0 doesn't make any sense either. If there's no balancing, we
>> shouldn't be here to begin with.
> 
> Also, why is this in the lb_env at all, shouldn't we simply use the
> global sched_balance_policy all over the place? Its not like we want to
> change power/perf on a finer granularity.

they are in lb_env, since we need to set them according to each group
status, mostly in update_sd_lb_power_stats().

Even the sched_balance_policy is powersaving, the domain may also need
performance balance since there are maybe too much tasks or much
imbalance in domain.

when we find the domain is not suitable for power balance, we will set
lb_perf = 1, then we don't need go through other groups for power info
collection.
> 


-- 
Thanks
    Alex
