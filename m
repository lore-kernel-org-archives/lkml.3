Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab3KMOfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:35:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab3KMOfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:35:06 -0500
Date: Wed, 13 Nov 2013 15:35:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] state/exit_state cleanups (Was: Remove unused variable
	ret from sync_thread_master())
Message-ID: <20131113143552.GA10517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12, Oleg Nesterov wrote:
>
> On 11/12, Peter Zijlstra wrote:
> >
> > We have to put in something...
> >
> > 	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
> >
> > However, since we always set it together with TASK_UNINTERUPTIBLE
> > userspace shouldn't actually ever see the I thing.
>
> OOPS. I didn't know that get_task_state() does &= TASK_REPORT. So it
> can never report anything > EXIT_DEAD.
>
> Perhaps we should change BUILD_BUG_ON() and shrink task_state_array?

Seriously, imho this looks confusing enough and deserves a cleanup.


As for "nobody should use exit_state". I'll try to recheck, but iirc
we already discussed this... do you remember any reason why
schedule_debug() can't check prev->state == TASK_DEAD instead of
->exit_state?

Note that ->exit_state is not exactly right, it is set by exit_notify()
but in_atomic_preempt_off() should be only ignored when the task does
the last schedule() in TASK_DEAD.

Oleg.

