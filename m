Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3LQMrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:47:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41777 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3LQMrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:47:06 -0500
Date: Tue, 17 Dec 2013 13:46:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sched/rt: Fix rq's cpupri leak while enqueue/dequeue
 child RT entities
Message-ID: <20131217124656.GI21999@twins.programming.kicks-ass.net>
References: <49231385567953@web4m.yandex.ru>
 <20131213154211.GP21999@twins.programming.kicks-ass.net>
 <122071387281778@web18h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <122071387281778@web18h.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:02:58PM +0400, Kirill Tkhai wrote:
> 
> 
> 13.12.2013, 19:42, "Peter Zijlstra" <peterz@infradead.org>:
> > On Wed, Nov 27, 2013 at 07:59:13PM +0400, Kirill Tkhai wrote:
> >
> >>  This patch touches RT group scheduling case.
> >>
> >>  Functions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's priority,
> >>  while rt_rq passed to them may be not the top-level rt_rq. This is wrong, because
> >>  changing of priority on a child level does not guarantee that the priority is
> >>  the highest all over the rq. So, this leak makes RT balancing unusable.
> >>
> >>  The short example: the task having the highest priority among all rq's RT tasks
> >>  (no one other task has the same priority) are waking on a throttle rt_rq.
> >>  The rq's cpupri is set to the task's priority equivalent, but real
> >>  rq->rt.highest_prio.curr is less.
> >>
> >>  The patch below fixes the problem.
> >>
> >>  It looks like all version have this bug, so I CC'ed stable mailing list.
> >
> > Yeah, I think this is right.
> >
> > cpupri stuff should indeed only be changed for the top level group.
> 
> Ingo, are you going to apply this patch? Or will you give any comments?

I queued it, Ingo should get it through me somewhere today if all things
go well.

Thanks
