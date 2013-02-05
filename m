Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3BEMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:13:59 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63378 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3BEMN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:13:58 -0500
Date: Tue, 5 Feb 2013 13:13:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
Message-ID: <20130205121354.GC21455@gmail.com>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the support for full dynticks idle mode in printk that
> can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	nohz/printk-v9
> 
> nohz/printk-v8 was the tree that I proposed to Linus. It has been left unpulled
> though and we got no news from him but the tree has stayed untouched since then,
> waiting in -next without any issue.
> 
> Part of nohz/printk-v8 is now in tip:irq/core, and this pull request contains
> the rest. I could simply propose you the old branch but since there is a tiny
> conflict with another recent commit in tip:irq/core, I just made a new branch
> that contains tip:irq/core with nohz/printk-v8 merged inside which deals
> with the conflict.
> 
> Thanks.
> ---
> 
> Frederic Weisbecker (5):
>       nohz: Add API to check tick state
>       irq_work: Don't stop the tick with pending works
>       irq_work: Make self-IPIs optable
>       printk: Wake up klogd using irq_work
>       Merge branch 'nohz/printk-v8' into irq/core
> 
> Steven Rostedt (2):
>       irq_work: Flush work on CPU_DYING
>       irq_work: Warn if there's still work on cpu_down
> 
>  include/linux/irq_work.h |   20 ++++++++
>  include/linux/printk.h   |    3 -
>  include/linux/tick.h     |   17 +++++++-
>  init/Kconfig             |    1 +
>  kernel/irq_work.c        |  112 +++++++++++++++++++++++++++++++++++-----------
>  kernel/printk.c          |   36 ++++++++-------
>  kernel/time/tick-sched.c |    7 ++-
>  kernel/timer.c           |    1 -
>  8 files changed, 147 insertions(+), 50 deletions(-)

Pulled, thanks Frederic!

	Ingo
