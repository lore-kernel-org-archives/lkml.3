Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3ENL7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:59:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3ENL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:59:19 -0400
Date: Tue, 14 May 2013 13:57:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC GIT PULL] sched; Fix a few missing rq clock updates
Message-ID: <20130514115733.GG15942@dyad.programming.kicks-ass.net>
References: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 01:50:57AM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> So I revisited the rq clock series I had for dynticks. The patches
> actually were about upstream issues so I refactored the fixes
> under that angle and gave up with the wrong asumption that rq
> clock relies on the tick for its updates.
> 
> Patches 1-4 fix some missing updates. Additionally I removed
> 2 of these updates from the previous set:
> 
> * No need to update the rq clock on idle_balance() because it should
> follow a call to deactivate_task() (unless TIF_NEED_RESCHED is set
> on idle without new task on the runqueue, not sure we want to cover that).
> 
> * No need to update for try_to_wake_up_local() -> ttwu_do_wakeup() -> check_preempt_curr()
>   as it's following deactivate_task().
> 
> Patch 5 brings accessors that will be necessary to settle an rq clock
> debugging engine. What remains is to tag scheduler's entry/exit points
> and report missing or redundant update_rq_clock() before calls to
> rq_clock() and rq_clock_task().

Just noticed this queue was still sitting in the INBOX, I took it and will
soon-ish hand to Ingo.

Thanks!
