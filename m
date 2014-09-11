Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaIKMTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:19:13 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47891 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaIKMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:19:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140911111736.GV3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org> <20140911111736.GV3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 11 Sep 2014 14:18:47 +0200
Message-ID: <CAKfTPtB=+Ybjs5iAB=E9fH2TX49gy+GNWjR7AGottnHH6WoaiA@mail.gmail.com>
Subject: Re: [PATCH v5 09/12] sched: add usage_load_avg
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 13:17, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 26, 2014 at 01:06:52PM +0200, Vincent Guittot wrote:
>> index 5c2c885..7dfd584 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1073,10 +1073,10 @@ struct sched_avg {
>>        * above by 1024/(1-y).  Thus we only need a u32 to store them for all
>>        * choices of y < 1-2^(-32)*1024.
>>        */
>> -     u32 runnable_avg_sum, runnable_avg_period;
>> +     u32 runnable_avg_sum, runnable_avg_period, running_avg_sum;
>
> Seeing how we use runnable_avg_period for both runnable and running,
> does it make sense to remove the runnable part of it from the name?

It's right

>
> Also, 4 byte hole here, not sure we've got anything useful to stuff in
> it though.

I can move all u32 declaration at the end of the struct unless it has
been put before any u64 for good reason

>
>>       u64 last_runnable_update;
>>       s64 decay_count;
>> -     unsigned long load_avg_contrib;
>> +     unsigned long load_avg_contrib, usage_avg_contrib;
>>  };
>>
>
> Man, I should go look at Yuyang's rewrite of this all again. I just
> tried to figure out the decay stuff and my head hurts ;-)
