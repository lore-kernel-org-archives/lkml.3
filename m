Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbbAGNOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:14:19 -0500
Received: from mail3.unitn.it ([193.205.206.24]:63583 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbbAGNOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:14:17 -0500
Message-ID: <54AD3123.8030104@unitn.it>
Date: Wed, 07 Jan 2015 14:14:11 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: tkhai@yandex.ru
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
References: <20141230002738.6c12db31@utopia>		 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>		 <1420499241.3361.14.camel@yandex.ru> <20150107080155.1d42d123@luca-1225C>	 <1420633741.12772.10.camel@yandex.ru> <54AD2A56.70307@unitn.it> <1420635879.14676.12.camel@yandex.ru>
In-Reply-To: <1420635879.14676.12.camel@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 02:04 PM, Kirill Tkhai wrote:
[...]
>>> and further enqueue_task() places it on the dl_rq.
>> I was under the impression that no further enqueue_task() will happen (since
>> the task is throttled, it is not on runqueue, so __sched_setscheduler() will
>> not dequeue/enqueue it).
>> But I am probably missing something else :)
>
> We have two concept of "on runqueue". The first one is rq->on_rq. It means
> that a task is "queued". The second is on_dl_rq(dl_se).
>
> When task is not "queued", it's always not on dl_rq.
>
> When task is "queued" it may be in two states:
> 1)on_dl_rq() -- this means the task is not throttled;
> 2)!on_dl_rq() -- is task as throttled.
>
> So when we are discussing about a throttled task, the task is "queued". If
> you clear dl_throttled, __sched_setscheduler() places it back it the both
> meaning: on_rq and on_dl_rq, and the task becomes available for picking
> in __schedule().
Ah, I see. Thanks for explaining! Now, everything is more clear and I agree
with you.

[...]
> Does my patch help you? It helps me, but anyway I need your confirmation.
I am just back from vacations, and I had no time to test it yet... I hope to
test it before the end of the week, and I'll let you know (but now I am convinced
that it should help).



			Thanks again,
				Luca

