Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3B1HEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:04:46 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52122 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3B1HEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:04:45 -0500
Message-ID: <512F0139.60702@linux.vnet.ibm.com>
Date: Thu, 28 Feb 2013 12:33:21 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 02/15] sched: set initial load avg of new forked task
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-3-git-send-email-alex.shi@intel.com> <51246B1A.8040100@intel.com> <5129F200.6080309@linux.vnet.ibm.com> <512AFE18.5020104@intel.com>
In-Reply-To: <512AFE18.5020104@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022807-5564-0000-0000-000006CEEBE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 81fa536..cae5134 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -1509,6 +1509,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>>>  	 * We track migrations using entity decay_count <= 0, on a wake-up
>>>  	 * migration we use a negative decay count to track the remote decays
>>>  	 * accumulated while sleeping.
>>> +	 *
>>> +	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
>>> +	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib initial
>>> +	 * value: se->load.weight.
>>
>> I disagree with the comment.update_entity_load_avg() gets called for all
>> forked tasks.
>> enqueue_task_fair->update_entity_load_avg() during the second
>> iteration.But __update_entity_load_avg() in update_entity_load_avg()
>>
> 
> When goes 'enqueue_task_fair->update_entity_load_avg()' during the
> second iteration. the se is changed.
> That is different se.
> 
> 
Correct Alex,sorry I overlooked this.

Regards
Preeti U Murthy

