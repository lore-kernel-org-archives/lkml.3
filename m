Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaFRHDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:03:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22903 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaFRHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:03:23 -0400
Message-ID: <53A1394A.7040607@huawei.com>
Date: Wed, 18 Jun 2014 15:01:30 +0800
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
References: <537348DA.7080001@huawei.com> <20140514113245.GZ11096@twins.programming.kicks-ass.net> <53736CD9.90805@unitn.it> <5374A335.90705@huawei.com> <20140515143132.c3199bec4476065cc843277d@gmail.com> <20140516071141.GA28755@austad.us> <537C9FE1.8060603@unitn.it> <539FAB4D.6000702@huawei.com> <539FF5D2.9080703@unitn.it>
In-Reply-To: <539FF5D2.9080703@unitn.it>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/17 16:01, Luca Abeni wrote:
> Hi,
>
> On 06/17/2014 04:43 AM, xiaofeng.yan wrote:
> [...]
>>> The basic ideas are (warning! This is an over-simplification of the 
>>> algorithm! :)
>>> - You assign runtime and period to each SCHED_DEADLINE task as usual
>>> - Each task is guaranteed to receive its runtime every period
>>> - You can also define a maximum fraction Umax of the CPU time that the
>>>   SCHED_DEADLINE tasks can use. Note that Umax _must_ be larger or 
>>> equal
>>>   than sum_i runtime_i / period_i
>>>   (note: in the original GRUB paper, only one CPU is considered, and 
>>> Umax is
>>>   set equal to 1)
>>> - If the tasks are consuming less than Umax, then the scheduling 
>>> algorithm
>>>   allows them to use more runtime (but not less than the guaranteed 
>>> runtime_i)
>>>   in order to use up to Umax.
>>>   This is achieved by modifying the rule used to decrease the 
>>> runtime: in
>>>   SCHED_DEADLINE, if a task executes for a time delta, its runtime 
>>> is decreased
>>>   by delta; using GRUB, it would be decreased by a smaller amount of 
>>> time
>>>   (computed based on Umax, on the active SCHED_DEADLINE tasks, etc...).
>>>   This requires to implement some kind of state machine (the details 
>>> are in
>>>   the GRUB paper)
>>>
>>> I also had an implementation of the GRUB algorithm (based on a 
>>> modification
>>> of my old CBS scheduler for Linux), but the computational complexity 
>>> of the
>>> algorithm was too high. That's why I never proposed to merge it in 
>>> SCHED_DEADLINE.
>>> But maybe there can be some trade-off between the "exact compliance 
>>> with the
>>> GRUB algorithm" and implementation efficiency that can make it 
>>> acceptable...
>>>
>>>
>> Has these  codes been opened about the implementation in some 
>> community or not ?
> The old GRUB scheduler for Linux was used for some experiments 
> published in a paper
> at RTLWS 2007, and of course the code was open-source (released under 
> GPL).
> It required a patch for the Linux kernel (I used a 2.6.something 
> kernel) which allowed
> to load the scheduler as a kernel module (yes, I know this is the 
> wrong way to go...
> But implementing it like this was simpler :).
> That is very old code... I probably still have it somewhere, but I 
> have to search
> for it. If someone is interested, I can try to search (the story of 
> the user-space
> daemon for adaptive reservations is similar: I released it as 
> open-source years ago...
> If anyone is interested I can search for this code too)
>
>
>                 Luca
>
I'm glad that you reply this email.  yes, I'm so interesting about your 
solution.  In fact , there are scenarios
in our product.  Could you send me a link if you have?  I can test your 
solution in our scene if you like.

Thanks
Yan
>


