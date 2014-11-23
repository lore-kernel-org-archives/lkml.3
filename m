Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaKWBD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 20:03:26 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42008 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaKWBDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 20:03:25 -0500
Message-ID: <54713254.9020601@gmail.com>
Date: Sun, 23 Nov 2014 09:03:16 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org> <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org> <20141009121643.GQ4750@worktop.programming.kicks-ass.net> <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
In-Reply-To: <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,
On 10/9/14, 10:18 PM, Vincent Guittot wrote:
> On 9 October 2014 14:16, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
>>> +static inline bool
>>> +group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
>>>   {
>>> +     if ((sgs->group_capacity * 100) >
>>> +                     (sgs->group_usage * env->sd->imbalance_pct))
>>> +             return true;
>> Why the imb_pct there? We're looking for 100% utilization, not 130 or
>> whatnot, right?
> Having exactly 100% is quite difficult because of various rounding.

Could you give some examples about the various rounding？

Regards,
Wanpeng Li

> So i have added a margin/threshold to prevent any excessive change of the state.
> I have just to use the same margin/threshold than in other place in
> load balance.
>
> so the current threshold depends of the sched_level. it's around 14% at MC level
>
>>> +     if (sgs->sum_nr_running < sgs->group_weight)
>>> +             return true;
>> With the code as it stands, this is the cheaper test (no mults) so why
>> is it second?
>>
>>> +     return false;
>>> +}
>>>
>>> +static inline bool
>>> +group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
>>> +{
>>> +     if (sgs->sum_nr_running <= sgs->group_weight)
>>> +             return false;
>>> +
>>> +     if ((sgs->group_capacity * 100) <
>>> +                     (sgs->group_usage * env->sd->imbalance_pct))
>>> +             return true;
>>>
>>> +     return false;
>>>   }
>> Same thing here wrt imb_pct
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

