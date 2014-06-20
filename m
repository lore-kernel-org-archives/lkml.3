Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaFTCaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:30:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63937 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaFTCai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:30:38 -0400
Message-ID: <53A39C73.2070004@huawei.com>
Date: Fri, 20 Jun 2014 10:29:07 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Luca Abeni <luca.abeni@unitn.it>
CC: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <duzhiping.du@huawei.com>, <xiaofeng.yan2012@gmail.com>,
        <raistlin@linux.it>, <tkhai@yandex.ru>,
        <harald.gustafsson@ericsson.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] sched/deadline: EDF dynamic quota design
References: <537348DA.7080001@huawei.com> <20140514113245.GZ11096@twins.programming.kicks-ass.net> <53736CD9.90805@unitn.it> <5374A335.90705@huawei.com> <20140515143132.c3199bec4476065cc843277d@gmail.com> <20140516071141.GA28755@austad.us> <537C9FE1.8060603@unitn.it> <539FAB4D.6000702@huawei.com> <539FF5D2.9080703@unitn.it> <53A1394A.7040607@huawei.com> <53A2A9BD.3070107@unitn.it>
In-Reply-To: <53A2A9BD.3070107@unitn.it>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/19 17:13, Luca Abeni wrote:
> On 06/18/2014 09:01 AM, xiaofeng.yan wrote:
> [...]
>>>>> I also had an implementation of the GRUB algorithm (based on a 
>>>>> modification
>>>>> of my old CBS scheduler for Linux), but the computational 
>>>>> complexity of the
>>>>> algorithm was too high. That's why I never proposed to merge it in 
>>>>> SCHED_DEADLINE.
>>>>> But maybe there can be some trade-off between the "exact 
>>>>> compliance with the
>>>>> GRUB algorithm" and implementation efficiency that can make it 
>>>>> acceptable...
>>>>>
>>>>>
>>>> Has these  codes been opened about the implementation in some 
>>>> community or not ?
>>> The old GRUB scheduler for Linux was used for some experiments 
>>> published in a paper
>>> at RTLWS 2007, and of course the code was open-source (released 
>>> under GPL).
>>> It required a patch for the Linux kernel (I used a 2.6.something 
>>> kernel) which allowed
>>> to load the scheduler as a kernel module (yes, I know this is the 
>>> wrong way to go...
>>> But implementing it like this was simpler :).
>>> That is very old code... I probably still have it somewhere, but I 
>>> have to search
>>> for it. If someone is interested, I can try to search (the story of 
>>> the user-space
>>> daemon for adaptive reservations is similar: I released it as 
>>> open-source years ago...
>>> If anyone is interested I can search for this code too)
>>>
>>>
>>>                 Luca
>>>
>> I'm glad that you reply this email.  yes, I'm so interesting about 
>> your solution.  In fact , there are scenarios
>> in our product.  Could you send me a link if you have?  I can test 
>> your solution in our scene if you like.
> Ok, so I found my old code for the CBS scheduler with GRUB modifications.
> You can get it from here: 
> http://disi.unitn.it/~abeni/old-cbs-scheduler.tgz
>
> Please note that:
> 1) This is old code (for 2.6.x kernels), written before SCHED_DEADLINE 
> development
>    was started
> 2) The scheduler architecture is completely different respect to the 
> current one,
>    but the basic scheduling algorithm implemented by my old scheduler 
> is the same
>    one implemented by SCHED_DEADLINE (but I did not implement 
> multi-processor support :)
> 3) You can have a look at the modifications needed to implement GRUB 
> by simply grepping
>    for "GRUB" in the source code. Basically, the algorithm is 
> implemented by:
>    1) Implementing a state machine to keep track of the current state 
> of a task (is it
>       using its reserved fraction of CPU time, did it already use such 
> a fraction of CPU
>       time, or is it not using any CPU time?). This is done by adding 
> a "state" field in
>       "cbs_struct", and properly updating it in cbs.c
>    2) Keeping track of the total fraction of CPU time used by the 
> active tasks. See the "U"
>       variable in cbs.c (in a modern scheduler, it should probably 
> become a field in the
>       runqueue structure)
>    3) Modifying the rule used to update the runtime. For a "standard" 
> CBS without CPU
>       reclaiming (the one implemented by SCHED_DEADLINE), if a task 
> executes for an amount
>       of time "delta" its runtime must be decreased by delta. For 
> GRUB, it must be decreased
>       by "delta" mutliplied by U. See "account()" in cbs.c.
>       The "trick" is in properly updating U (and this is done using 
> the state machine
>       mentioned above)
>
> Summing up, this code is not directly usable, but it shows you what 
> needs to be done in
> order to implement the GRUB mechanism for CPU reclaiming in a CBS 
> scheduler...
>
>
Thanks for giving me your solution. I will take a look at it and modify 
it in our scene later.

Thanks
Yan
>
>                 Luca
>
> .
>


