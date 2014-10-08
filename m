Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaJHSg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaJHSg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:36:27 -0400
Date: Wed, 8 Oct 2014 20:33:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 0/2] (Was: sched: fix the PREEMPT_ACTIVE check in
	__trace_sched_switch_state())
Message-ID: <20141008183302.GA17495@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141008080016.GB10832@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008080016.GB10832@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Peter Zijlstra wrote:
>
> On Tue, Oct 07, 2014 at 09:50:46PM +0200, Oleg Nesterov wrote:
> > And note that another caller of task_preempt_count(), set_cpu(), is
> > fine but it doesn't really need this helper.
> >
> > And afaics we do not need ->saved_preempt_count at all, the trivial
> > patch below makes it unnecessary, we can kill it and all its users.
> >
> > Not only this will simplify the code, this will make (well, almost)
> > the per-cpu preempt counter arch-agnostic.
> >
> > Or I missed something?
>
> Two things, per-cpu isn't always faster on some archs, and load-store
> archs have problems with PREEMPT_NEED_RESCHED, although arguably you can
> do per-cpu preempt count without that.

Ah, but I didn't mean we should make it per-cpu on every arch.

I meant that (imo) this change can cleanup x86 code, and it can also help
if we want to change another arch to use per-cpu preempt_count.

> > Do you think this makes sense? If yes, I'll try to make the patches.
>
> It penalizes everything but x86 I think.

I don't think so.

But please forget for the moment, lets discuss this later. Let me start
with 2 simple preparations which imho make sense anyway. Then we will see.

1/2 looks like the obvious bugfix (iirc we already discussed this a bit),
2/2 depends on this patch.

Oleg.

