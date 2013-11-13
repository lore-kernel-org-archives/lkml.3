Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab3KMOtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:49:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977Ab3KMOtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:49:16 -0500
Date: Wed, 13 Nov 2013 15:48:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] state/exit_state cleanups (Was: Remove unused
 variable ret from sync_thread_master())
Message-ID: <20131113144856.GL26898@twins.programming.kicks-ass.net>
References: <20131113143552.GA10517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113143552.GA10517@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:35:52PM +0100, Oleg Nesterov wrote:
> On 11/12, Oleg Nesterov wrote:
> >
> > On 11/12, Peter Zijlstra wrote:
> > >
> > > We have to put in something...
> > >
> > > 	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
> > >
> > > However, since we always set it together with TASK_UNINTERUPTIBLE
> > > userspace shouldn't actually ever see the I thing.
> >
> > OOPS. I didn't know that get_task_state() does &= TASK_REPORT. So it
> > can never report anything > EXIT_DEAD.
> >
> > Perhaps we should change BUILD_BUG_ON() and shrink task_state_array?
> 
> Seriously, imho this looks confusing enough and deserves a cleanup.
> 
> 
> As for "nobody should use exit_state". I'll try to recheck, but iirc
> we already discussed this... do you remember any reason why
> schedule_debug() can't check prev->state == TASK_DEAD instead of
> ->exit_state?

I have no such memories :/ but a quick test shows that such a kernel
does boot without issue.

> Note that ->exit_state is not exactly right, it is set by exit_notify()
> but in_atomic_preempt_off() should be only ignored when the task does
> the last schedule() in TASK_DEAD.

Agreed.

For these patches:

Acked-by: Peter Zijlstra <peterz@infradead.org>
