Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3AYBDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:03:51 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63740 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3AYBDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <51015059.8010505@intel.com>
References: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
	<1358998243-23176-3-git-send-email-alex.shi@intel.com>
	<20130124100823.GE26351@gmail.com>
	<51015059.8010505@intel.com>
Date: Fri, 25 Jan 2013 09:03:31 +0800
Message-ID: <CAGjg+kGBWVE6ujniero=quEMT82x_bcUCmeGkiya51niDQQwpQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
From: Alex Shi <lkml.alex@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:16 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 01/24/2013 06:08 PM, Ingo Molnar wrote:
>>
>> * Alex Shi <alex.shi@intel.com> wrote:
>>
>>> @@ -2539,7 +2539,11 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>>  void update_idle_cpu_load(struct rq *this_rq)
>>>  {
>>>      unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
>>> +#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>>> +    unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
>>> +#else
>>>      unsigned long load = this_rq->load.weight;
>>> +#endif
>>
>> I'd not make it conditional - just calculate runnable_load_avg
>> all the time (even if group scheduling is disabled) and use it
>> consistently. The last thing we want is to bifurcate scheduler
>> balancer behavior even further.
>
> Very glad to see you being back, Ingo! :)
>
> This patch set is following my power aware scheduling patchset. But for
> a separate workable runnable load engaged balancing. only needs the
> other 3 patches, that already sent you at another patchset
>
> [patch v4 06/18] sched: give initial value for runnable avg of sched
> [patch v4 07/18] sched: set initial load avg of new forked task
> [patch v4 08/18] Revert "sched: Introduce temporary FAIR_GROUP_SCHED

You's right, Ingo! the last revert patch missed above 2 points.
I will resend new patches with full version.
