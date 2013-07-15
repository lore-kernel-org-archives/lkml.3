Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3GOU3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:29:07 -0400
Received: from forward6.mail.yandex.net ([77.88.60.125]:46506 "EHLO
	forward6.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3GOU3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:29:02 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 16:29:02 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20130715201945.GQ17211@twins.programming.kicks-ass.net>
References: <1517081373730349@web23d.yandex.ru>
 <20130715063150.GL17211@twins.programming.kicks-ass.net>
 <449471373897674@web23d.yandex.ru> <20130715201945.GQ17211@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched: Add logic to handle parallel try_to_wake_up() of the same task
MIME-Version: 1.0
Message-Id: <222821373919744@web21e.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 16 Jul 2013 00:22:24 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.07.2013, 00:19, "Peter Zijlstra" <peterz@infradead.org>:
> On Mon, Jul 15, 2013 at 06:14:34PM +0400, Kirill Tkhai wrote:
>
>>>> ššš#ifdef CONFIG_SMP
>>>> šš+ p->state = TASK_WAKING;
>>>> šš+ smp_wmb();
>>>> šš+
>>> šThis too is broken; the loop below needs to be completed first,
>>> šotherwise we change p->state while the task is still on the CPU and it
>>> šmight read the wrong p->state.
>> šThis place is below (on_rq && ttwu_remote) check, so the task
>> šeither 'dequeued and on_cpu == 0'
>> šor it's in the middle of schedule() on arch, which wants unlocked
>> šcontext switch.
>>
>> šNobody scheduler's probes p->state between prepare_lock_switch() and
>> šfinish_lock_switch(). Archs with unlocked ctx switch (mips and ia64)
>> šdon't change or probe state of previous process during context_switch.
>
> It means its after deactivate_task(), but before context_switch(). It so
> happens that
> context_switch()->prepare_task_switch()->trace_sched_switch() inspects
> p->state.
>
> Even if this was not the case, touching a task that is 'life' on another
> CPU is very _very_ bad practise.

Thanks for the explanation.

Kirill
