Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3LQMIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:08:32 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:34217 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQMIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:08:30 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 07:08:30 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <20131213154211.GP21999@twins.programming.kicks-ass.net>
References: <49231385567953@web4m.yandex.ru> <20131213154211.GP21999@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities
MIME-Version: 1.0
Message-Id: <122071387281778@web18h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 17 Dec 2013 16:02:58 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



13.12.2013, 19:42, "Peter Zijlstra" <peterz@infradead.org>:
> On Wed, Nov 27, 2013 at 07:59:13PM +0400, Kirill Tkhai wrote:
>
>> šThis patch touches RT group scheduling case.
>>
>> šFunctions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's priority,
>> šwhile rt_rq passed to them may be not the top-level rt_rq. This is wrong, because
>> šchanging of priority on a child level does not guarantee that the priority is
>> šthe highest all over the rq. So, this leak makes RT balancing unusable.
>>
>> šThe short example: the task having the highest priority among all rq's RT tasks
>> š(no one other task has the same priority) are waking on a throttle rt_rq.
>> šThe rq's cpupri is set to the task's priority equivalent, but real
>> šrq->rt.highest_prio.curr is less.
>>
>> šThe patch below fixes the problem.
>>
>> šIt looks like all version have this bug, so I CC'ed stable mailing list.
>
> Yeah, I think this is right.
>
> cpupri stuff should indeed only be changed for the top level group.

Ingo, are you going to apply this patch? Or will you give any comments?
