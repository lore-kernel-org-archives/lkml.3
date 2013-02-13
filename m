Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3BMIdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:33:19 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36669 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3BMIdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:33:18 -0500
Date: Wed, 13 Feb 2013 09:33:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] sched: clean ups and a minor fix
Message-ID: <20130213083314.GA7149@gmail.com>
References: <20130212225412.781044738@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212225412.781044738@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> The first of the patches is a minor fix to when a woken RT task is about
> to preempt a pinned RT task, push_rt_task() is called to try to
> migrate the woken task if possible (to avoid preempting a pinned RT
> task that may be the second highest priority task in the system).
> 
> But the issue is that push_rt_task() won't push it if the woken task
> is higher priority even if the task to be preempted is pinned.
> 
> The second two patches is more of a clean up to remove the idle
> hooks in the scheduler proper, and to use the pre/post schedule
> methods instead.
> 
> This allows interrupts to be enabled in the idle balance, which slightly
> helps latencies, especially for the -rt kernel. Other patches can be
> added on top. Maybe in the future preemption could be enabled during
> the idle balance as well. But that remains to be seen.
> 
> Please pull the latest tip/sched/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/sched/core
> 
> Head SHA1: 1db13ecf89054d39922e7b3323d124c7e2921560
> 
> 
> Steven Rostedt (Red Hat) (3):
>       sched/rt: Fix push_rt_task() to have the same checks as the caller did
>       sched: Move idle_balance() to post_schedule
>       sched: Enable interrupts in idle_balance()
> 
> ----
>  kernel/sched/core.c      |    3 ---
>  kernel/sched/fair.c      |    8 +++++---
>  kernel/sched/idle_task.c |   10 ++++++++++
>  kernel/sched/rt.c        |   15 ++++++++++-----
>  4 files changed, 25 insertions(+), 11 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
