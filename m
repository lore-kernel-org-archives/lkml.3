Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3EDGl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 02:41:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60377 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3EDGlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 02:41:55 -0400
Date: Sat, 4 May 2013 08:41:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Bunch of fixes
Message-ID: <20130504064151.GB14614@gmail.com>
References: <1367599676-2049-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367599676-2049-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the timers/nohz-hz1 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-hz1
> 
> HEAD: a7f4d69bb1d5e1f573b680355a2ad51566338887
> 
> It fixes a Kconfig dependency issue and forces a minimum of 1 tick every seconds
> to keep handling the scheduler_tick() duties, even at a very low granularity. This
> is a workaround until we can handle all these duties through on-demand driven
> solutions rather than using periodic events, as per your suggestion.
> 
> I just noted two things:
> 
> * update_cpu_load_active() seem to rely on the fixed periodic tick at the
>   HZ rate. There is certainly something to tweak there to make it really correct
>   with dynamick ticks. I have the feeling that modifying pending_updates won't work
>   as it seems to decay assuming the time to catch up was idle.
> 
> * I'll probably have to disable CONFIG_CFS_BANDWIDTH when full dynticks
>   is enabled. First of all it modifies rq->nr_running without using inc/dec_nr_running
>   standard API, which is required for full dynticks. And second, I need to triple
>   check it's safe to use with 1 tick per second.
> 
> Ah and please note the merge commit (c032862fba51a3ca504752d3a25186b324c5ce83)
> that was needed to get latest RCU and sched updates for the Kconfig fix.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       rcu: Fix full dynticks' dependency on wide RCU nocb mode
>       sched: Keep at least 1 tick per second for active dynticks tasks
> 
> 
>  include/linux/sched.h    |    1 +
>  init/Kconfig             |    4 ++--
>  kernel/sched/core.c      |   30 ++++++++++++++++++++++++++++++
>  kernel/sched/idle_task.c |    1 +
>  kernel/sched/sched.h     |   10 ++++++++++
>  kernel/time/Kconfig      |    1 -
>  kernel/time/tick-sched.c |    7 +++++++
>  7 files changed, 51 insertions(+), 3 deletions(-)

Pulled, thanks Frederic!

	Ingo
