Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3HPQBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:01:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50437 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3HPQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:01:02 -0400
Date: Fri, 16 Aug 2013 18:00:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/4] nohz: Convert a few places to use local per cpu
 accesses
Message-ID: <20130816160043.GA24092@twins.programming.kicks-ass.net>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376667753-29014-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK so these patches look ok to me -- didn't read in detail though.

On Fri, Aug 16, 2013 at 05:42:33PM +0200, Frederic Weisbecker wrote:
> A few functions use remote per CPU access APIs when they
> deal with local values.
> 
> Just to the right conversion to improve performance, code
> readability and debug checks.

> @@ -410,7 +408,7 @@ static void tick_nohz_update_jiffies(ktime_t now)
>  
>  static void tick_nohz_stop_idle(int cpu, ktime_t now)
>  {
> -	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);

What's there from stopping someone from calling this with cpu !=
smp_processor_id() ? 

> @@ -1020,7 +1018,7 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
>  
>  static inline void tick_check_nohz(int cpu)
>  {
> -	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>  	ktime_t now;
>  
>  	if (!ts->idle_active && !ts->tick_stopped)

idem
