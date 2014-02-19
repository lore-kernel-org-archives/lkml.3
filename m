Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBSIqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:46:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaBSIqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:46:24 -0500
Date: Wed, 19 Feb 2014 09:46:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] sched/deadline: Fix bad accounting of nr_running
Message-ID: <20140219084618.GF27965@twins.programming.kicks-ass.net>
References: <20140214235946.60a89b65@gandalf.local.home>
 <53022F2D.8040301@gmail.com>
 <20140218215012.209059c0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218215012.209059c0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:50:12PM -0500, Steven Rostedt wrote:
>  
> > Rationale for this odd behavior is that, when a task is throttled, it
> > is removed only from the dl_rq, but we keep it on_rq (as this is not
> > a "full dequeue", that is the task is not actually sleeping). But, it
> > is also true that, while throttled a task behaves like it is sleeping
> > (e.g., its timer will fire on a new CPU if the old one is dead). So,
> > Steven's fix sounds also semantically correct.
> 
> Actually, it seems that I was hitting it again, but this time getting a
> negative number. OK, after looking at the code a bit more, I think we
> should update the runqueue nr_running only when the task is officially
> enqueued and dequeued, and all accounting within, will not touch that
> number.

But if the task is throttled it should still very much decrement the
number. There's places that very much rely on nr_running be exactly the
number of runnable tasks.
