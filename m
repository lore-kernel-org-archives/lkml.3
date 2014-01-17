Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaAQCOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:14:40 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39550 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaAQCOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:14:37 -0500
Message-ID: <52D891FB.9020308@linaro.org>
Date: Fri, 17 Jan 2014 10:14:19 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched: select_idle_sibling macro optimize
References: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>	 <52D7DAF5.4020506@linaro.org> <1389880335.5418.46.camel@marge.simpson.net>
In-Reply-To: <1389880335.5418.46.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:52 PM, Mike Galbraith wrote:
> On Thu, 2014-01-16 at 21:13 +0800, Alex Shi wrote: 
>> Add Mike Galbraith.
>>
>> Any one like to give some comments?
>>
>> On 01/15/2014 10:23 PM, Alex Shi wrote:
>>> If the sd domain just has one group, then we must be caught the
>>> 	i == target later, and then goes to deeper level domain.
>>> So just skip this domain checking to save some instructions.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@linaro.org>
>>> ---
>>>  kernel/sched/fair.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index c7395d9..3265fbc 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -4196,6 +4196,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
>>>  	sd = rcu_dereference(per_cpu(sd_llc, target));
>>>  	for_each_lower_domain(sd) {
>>>  		sg = sd->groups;
>>> +
>>> +		/* skip single group domain */
>>> +		if (sg == sg->next)
>>> +			continue;
> 
> When is that gonna happen?

I had seen this in a Intel platform, you may have both CPU domain and MC
domain layer, because the domain flag is different, then they can not be
merged. and then the CPU domain just has one group.
> 
> -Mike
> 
> 


-- 
Thanks
    Alex
