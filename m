Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3LQNIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:08:11 -0500
Received: from forward16.mail.yandex.net ([95.108.253.141]:36677 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3LQNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:08:09 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <20131217124656.GI21999@twins.programming.kicks-ass.net>
References: <49231385567953@web4m.yandex.ru>
 <20131213154211.GP21999@twins.programming.kicks-ass.net>
 <122071387281778@web18h.yandex.ru> <20131217124656.GI21999@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities
MIME-Version: 1.0
Message-Id: <96341387285682@web18g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 17 Dec 2013 17:08:02 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17.12.2013, 16:47, "Peter Zijlstra" <peterz@infradead.org>:
> On Tue, Dec 17, 2013 at 04:02:58PM +0400, Kirill Tkhai wrote:
>
>> š13.12.2013, 19:42, "Peter Zijlstra" <peterz@infradead.org>:
>>> šOn Wed, Nov 27, 2013 at 07:59:13PM +0400, Kirill Tkhai wrote:
>>>> ššThis patch touches RT group scheduling case.
>>>>
>>>> ššFunctions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's priority,
>>>> ššwhile rt_rq passed to them may be not the top-level rt_rq. This is wrong, because
>>>> ššchanging of priority on a child level does not guarantee that the priority is
>>>> ššthe highest all over the rq. So, this leak makes RT balancing unusable.
>>>>
>>>> ššThe short example: the task having the highest priority among all rq's RT tasks
>>>> šš(no one other task has the same priority) are waking on a throttle rt_rq.
>>>> ššThe rq's cpupri is set to the task's priority equivalent, but real
>>>> ššrq->rt.highest_prio.curr is less.
>>>>
>>>> ššThe patch below fixes the problem.
>>>>
>>>> ššIt looks like all version have this bug, so I CC'ed stable mailing list.
>>> šYeah, I think this is right.
>>>
>>> šcpupri stuff should indeed only be changed for the top level group.
>> šIngo, are you going to apply this patch? Or will you give any comments?
>
> I queued it, Ingo should get it through me somewhere today if all things
> go well.
>
> Thanks

Thanks, Peter

