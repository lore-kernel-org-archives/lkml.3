Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab3BMPlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:41:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:25261 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934215Ab3BMPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,658,1355126400"; 
   d="scan'208";a="256432413"
Message-ID: <511BB413.4000601@intel.com>
Date: Wed, 13 Feb 2013 23:41:07 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 09/18] sched: add sched_policies in kernel
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-10-git-send-email-alex.shi@intel.com> <1360665361.4485.24.camel@laptop>
In-Reply-To: <1360665361.4485.24.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:36 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> Current scheduler behavior is just consider the for larger performance
>> of system. So it try to spread tasks on more cpu sockets and cpu cores
>>
>> To adding the consideration of power awareness, the patchset adds
>> 2 kinds of scheduler policy: powersaving and balance. They will use
>> runnable load util in scheduler balancing. The current scheduling is taken
>> as performance policy.
>>
>> performance: the current scheduling behaviour, try to spread tasks
>>                 on more CPU sockets or cores. performance oriented.
>> powersaving: will pack tasks into few sched group until all LCPU in the
>>                 group is full, power oriented.
>> balance    : will pack tasks into few sched group until group_capacity
>>                 numbers CPU is full, balance between performance and
>> 		powersaving.
> 
> _WHY_ do you start out with so much choice?
> 
> If your power policy is so abysmally poor on performance that you
> already know you need a 3rd policy to keep people happy, maybe you're
> doing something wrong?

Nope, no much performance yield for both of powersaving and balance policy.
Much of testing results in replaying Ingo's email on '0/18' thread --
the cover letter email threads.
https://lkml.org/lkml/2013/2/3/353
https://lkml.org/lkml/2013/2/4/735

I introduce a 'balance' policy just because HT thread LCPU in Intel CPU
is less then 1 usual cpu power. It is used when someone want to save
power but still want tasks have a whole cpu core...
> 
>> +#define SCHED_POLICY_PERFORMANCE	(0x1)
>> +#define SCHED_POLICY_POWERSAVING	(0x2)
>> +#define SCHED_POLICY_BALANCE		(0x4)
>> +
>> +extern int __read_mostly sched_policy;
> 
> I'd much prefer: sched_balance_policy. Scheduler policy is a concept
> already well defined by posix and we don't need it to mean two
> completely different things.
> 

Got it.
-- 
Thanks
    Alex
