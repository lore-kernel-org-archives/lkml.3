Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaJHIAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:00:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:59841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJHIAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:00:18 -0400
Date: Wed, 8 Oct 2014 10:00:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] sched: fix the PREEMPT_ACTIVE check in
 __trace_sched_switch_state()
Message-ID: <20141008080016.GB10832@worktop.programming.kicks-ass.net>
References: <20141007195046.GA28002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007195046.GA28002@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:50:46PM +0200, Oleg Nesterov wrote:
> And note that another caller of task_preempt_count(), set_cpu(), is
> fine but it doesn't really need this helper.
> 
> And afaics we do not need ->saved_preempt_count at all, the trivial
> patch below makes it unnecessary, we can kill it and all its users.
> 
> Not only this will simplify the code, this will make (well, almost)
> the per-cpu preempt counter arch-agnostic.
> 
> Or I missed something?

Two things, per-cpu isn't always faster on some archs, and load-store
archs have problems with PREEMPT_NEED_RESCHED, although arguably you can
do per-cpu preempt count without that.

> Do you think this makes sense? If yes, I'll try to make the patches.

It penalizes everything but x86 I think. There is no other arch that has
per-cpu preempt count atm.
