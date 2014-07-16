Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbaGPBXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:23:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29261 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760454AbaGPBW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:22:56 -0400
X-IronPort-AV: E=Sophos;i="5.00,899,1396972800"; 
   d="scan'208";a="33327146"
Message-ID: <53C5D432.8000601@cn.fujitsu.com>
Date: Wed, 16 Jul 2014 09:24:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 V2] workqueue: remove the del_timer_sync()s in maybe_create_worker()
References: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com> <1405325601-12437-1-git-send-email-laijs@cn.fujitsu.com> <1405325601-12437-2-git-send-email-laijs@cn.fujitsu.com> <20140714142707.GB31610@htj.dyndns.org> <alpine.DEB.2.10.1407141731240.24854@nanos> <53C44915.4000405@cn.fujitsu.com> <alpine.DEB.2.10.1407142340170.24854@nanos>
In-Reply-To: <alpine.DEB.2.10.1407142340170.24854@nanos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:42 AM, Thomas Gleixner wrote:
> On Tue, 15 Jul 2014, Lai Jiangshan wrote:
>> On 07/14/2014 11:33 PM, Thomas Gleixner wrote:
>>> On Mon, 14 Jul 2014, Tejun Heo wrote:
>>>
>>>> Hello,
>>>>
>>>> On Mon, Jul 14, 2014 at 04:13:21PM +0800, Lai Jiangshan wrote:
>>>>> It is said in the document that the timer which is being
>>>>> deleted by del_timer_sync() should not be restarted:
>>>>>   Synchronization rules: Callers must prevent restarting of
>>>>>   the timer, otherwise this function is meaningless.
>>>>>
>>>>> Repeating timer may cause the del_timer_sync() spin longer,
>>>>> or even spin forever in very very very very extreme condition.
>>>>
>>>> I'm fairly sure del_timer_sync() can delete self-requeueing timers.
>>>> The implementation busy-waits if the queued timer is the currently
>>>> executing one and dequeues only while the timer isn't running which
>>>> should be able to handle self-requeueing ones just fine.  Thomas,
>>>> del_timer_sync() can reliably delete self-requeueing ones, right?
>>>
>>> Yes. 
>>
>> The comments of the del_timer_sync() needs to be updated
>> if I did not misunderstood?
>>
>>> If the timer callback is running on the other cpu, then it waits
>>> for the callback to finish before checking whether the timer is
>>> enqueued or not.
>>
>> The syncer may be interrupted here, after it comes back, the timer
>> may be running again (and maybe again and again).
> 
> No. The del_timer_sync() code holds the base lock with interrupts
> disabled. So it can't be interrupted.
> 

The del_timer_sync() waits via cpu_relax() without interrupts
disabled. Could you wipe out my concern?

> 
> .
> 

