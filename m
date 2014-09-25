Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaIYTTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:19:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40334 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYTTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:19:22 -0400
Message-ID: <54246ACE.1080502@arm.com>
Date: Thu, 25 Sep 2014 20:19:42 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org> <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org> <542303DF.8010606@arm.com> <CAKfTPtB3-M+pXaurDeWkWGNJ3_mU-FN+EnshGE-eg_r41Hppag@mail.gmail.com>
In-Reply-To: <CAKfTPtB3-M+pXaurDeWkWGNJ3_mU-FN+EnshGE-eg_r41Hppag@mail.gmail.com>
X-OriginalArrivalTime: 25 Sep 2014 19:19:18.0396 (UTC) FILETIME=[9A46EBC0:01CFD8F5]
X-MC-Unique: 114092520191904501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/14 09:35, Vincent Guittot wrote:
> On 24 September 2014 19:48, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>> On 23/09/14 17:08, Vincent Guittot wrote:
>>
> 
> [snip]
> 
>>
>> This review (by PeterZ) during v5 of your patch-set recommended some
>> renaming (e.g. s/group_has_free_capacity/group_has_capacity and
>> s/group_out_of_capacity/group_no_capacity as well as reordering of the
>> parameters which I agree with:
>>
>> https://lkml.org/lkml/2014/9/11/706
> 
> Ah... you're right, these changes have passed through my seance of renaming

What about the ordering of the function parameters in
group_has_capacity, group_is_overloaded and group_type group_classify?

All the existing *load balance* related functions in fair.c seem to
follow this (struct lb_env *env, struct sd_lb_stats *sds, struct
sched_group *group, struct sg_lb_stats *sgs) order.

> 
>>
>>>
>>> -/*
> 
> [snip]
> 
>>> -       if (sgs->group_capacity_factor > sgs->sum_nr_running)
>>> -               sgs->group_has_free_capacity = 1;
>>> +       sgs->group_type = group_classify(group, sgs, env);
>>> +
>>> +       sgs->group_out_of_capacity = group_is_overloaded(sgs, env);
>>
>> In case sgs->group_type is group_overloaded you could set
>> sgs->group_out_of_capacity to 1 without calling group_is_overloaded again.
> 
> I prefer to keep sgs->group_out_of_capacity = group_is_overloaded(sgs,
> env) and use it in group_classify in case of future changes in the
> classification order

Ok, but than group_is_overloaded is called twice at the end of
update_sg_lb_stats with exactly the same result. Looks weird in my traces.

> 
[...]


