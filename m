Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935531Ab3BTNkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:40:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:33836 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935302Ab3BTNkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:40:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="289564936"
Message-ID: <5124D253.6090606@intel.com>
Date: Wed, 20 Feb 2013 21:40:35 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 04/15] sched: add sched balance policies in kernel
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-5-git-send-email-alex.shi@intel.com> <20130220093751.GA2444@gmail.com>
In-Reply-To: <20130220093751.GA2444@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:37 PM, Ingo Molnar wrote:
> 
> * Alex Shi <alex.shi@intel.com> wrote:
> 
>> Current scheduler behavior is just consider for larger 
>> performance of system. So it try to spread tasks on more cpu 
>> sockets and cpu cores
>>
>> To adding the consideration of power awareness, the patchset 
>> adds 2 kinds of scheduler policy: powersaving and balance. 
>> They will use runnable load util in scheduler balancing. The 
>> current scheduling is taken as performance policy.
>>
>> performance: the current scheduling behaviour, try to spread tasks
>>                 on more CPU sockets or cores. performance oriented.
>> powersaving: will pack tasks into few sched group until all LCPU in the
>>                 group is full, power oriented.
>> balance    : will pack tasks into few sched group until group_capacity
>>                 numbers CPU is full, balance between performance and
>> 		powersaving.
> 
> Hm, so in a previous review I suggested keeping two main 
> policies: power-saving and performance, plus a third, default 
> policy, which automatically switches between these two if/when 
> the kernel has information about whether a system is on battery 
> or on AC - and picking 'performance' when it has no information.

I will try to add a default policy according to your suggestion.
> 
> Such an automatic policy would obviously be useful to users - 
> and that is what makes such a feature really interesting and a 
> step forward.
> 
> I think Peter expressed similar views: we don't want many knobs 
> and states, we want two major goals plus an (optional but 
> default enabled) automatism.

I got the message. thanks for reclaim again.

Now there is just 2 types policy: performance and powersaving(with 2
degrees, powersaving and balance).

powersaving policy will try to assign one task to each LCPU, whichever
the LCPU is SMT thread or a core.
The balance policy is also a kind of powersaving policy, just a bit less
aggressive. It will try to assign tasks according group capacity, one
task to one capacity.
It was introduced just because SMT LCPU in intel arch. SMT thread is a
independent LCPU in software, but its cpu power(smt_gain 1178 / 2 = 589)
is smaller than a normal CPU(1024). So, the group capacity is just 1 for
a 2 SMT thread core. So, on policy, just one task assign to one core
normally.


> 
> Is your 'balance' policy implementing that suggestion?
> If not, why not?
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Thanks
    Alex
