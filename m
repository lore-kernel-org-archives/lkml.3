Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3DKLeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:34:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42221 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab3DKLeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:34:15 -0400
Date: Thu, 11 Apr 2013 06:34:13 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Russ Anderson <rja@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130411113412.GP3658@sgi.com>
References: <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130410152911.GA3011@sgi.com>
 <20130410165934.GB21951@gmail.com>
 <20130410171420.GF3658@sgi.com>
 <20130410172236.GE21951@gmail.com>
 <20130410175519.GG3658@sgi.com>
 <20130410190003.GH3658@sgi.com>
 <20130411085751.GD11824@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411085751.GD11824@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, so it looks profilable.
> 
> The result above is not surprising: most CPUs sit in idle and don't do anything, 
> while the loop goes on, right?
> 
> The interesting thing to profile would be the parallel bring-down, with the 
> simplest global lock solution you mentioned. In that case most CPUs should be 
> doing 'something' all the time - maybe spinning on the lock, maybe something else, 
> right?

Again, mostly looks idle.

Events: 5M cycles
    31.69%          swapper  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
    14.22%          swapper  [kernel.kallsyms]        [k] load_balance
    12.95%          swapper  [kernel.kallsyms]        [k] ktime_get
     4.64%          swapper  [kernel.kallsyms]        [k] idle_cpu
     3.46%          swapper  [kernel.kallsyms]        [k] uv_read_rtc
     2.26%          swapper  [kernel.kallsyms]        [k] ktime_get_update_offsets
     2.25%          swapper  [kernel.kallsyms]        [k] rcu_check_callbacks
     1.72%          swapper  [kernel.kallsyms]        [k] _raw_spin_lock_irqsave
     1.57%          swapper  [kernel.kallsyms]        [k] native_write_msr_safe
     1.53%          swapper  [kernel.kallsyms]        [k] native_safe_halt
     1.52%          swapper  [kernel.kallsyms]        [k] apic_timer_interrupt
     1.52%          swapper  [kernel.kallsyms]        [k] update_blocked_averages
     1.51%          swapper  [kernel.kallsyms]        [k] __lock_text_start
     1.48%          swapper  [kernel.kallsyms]        [k] rcu_process_gp_end
     1.40%          swapper  [kernel.kallsyms]        [k] rcu_process_callbacks
     1.19%           reboot  [kernel.kallsyms]        [k] kmem_cache_alloc_node
     0.63%          swapper  [kernel.kallsyms]        [k] check_for_new_grace_period
     0.58%          swapper  [kernel.kallsyms]        [k] rebalance_domains
     0.55%          swapper  [kernel.kallsyms]        [k] cpumask_next_and
     0.54%          swapper  [kernel.kallsyms]        [k] __tick_nohz_idle_enter
     0.53%          swapper  [kernel.kallsyms]        [k] perf_adjust_freq_unthr_context
     0.49%          swapper  [kernel.kallsyms]        [k] _raw_spin_lock

Robin

