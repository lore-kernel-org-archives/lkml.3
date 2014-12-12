Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031264AbaLLSYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:24:33 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57520 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031120AbaLLSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:24:31 -0500
Date: Fri, 12 Dec 2014 10:24:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212182424.GY25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212030343.GA7945@redhat.com>
 <20141212044509.GA21145@redhat.com>
 <20141212143846.GA27914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212143846.GA27914@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121218-0017-0000-0000-0000071058F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 09:38:46AM -0500, Dave Jones wrote:
> On Thu, Dec 11, 2014 at 11:45:09PM -0500, Dave Jones wrote:
> 
>  > I've seen those messages a fair bit on other machines do, and they drive me nuts
>  > because there's no 'perf' being run. I think it means "NMI watchdog", but is
>  > worded badly.  Still, it's curious that they appeared during what should have
>  > been idle time.
>  > 
>  > I'll reboot the box and give it another shot, and see what falls out in the morning.
> 
> Same deal again. It happened pretty quick after I'd gone to bed (typical).
> 
> [ 2754.509747] Clocksource tsc unstable (delta = -243594587656 ns)
> [ 2754.519197] Switched to clocksource hpet
> [ 2754.782940] INFO: rcu_preempt self-detected stall on CPU
> [ 2754.782972] 	0: (1 GPs behind) idle=6ef/140000000000001/0 softirq=247160/247161 

In this one, the CPU is at least non-idle.  ;-)

> [ 2754.782999] 	 (t=24343 jiffies g=104086 c=104085 q=0)
> [ 2754.783022] Task dump for CPU 0:
> [ 2754.783037] trinity-c387    R  running task    14016 13658  12780 0x00000008
> [ 2754.783070]  ffff880222365bc0 000000005ed04994 ffff880244003d68 ffffffff810a8d46
> [ 2754.783104]  ffffffff810a8cb2 0000000000000000 0000000000000001 0000000000000000
> [ 2754.783138]  ffffffff81c51e40 0000000000000092 ffff880244003d88 ffffffff810acf4d
> [ 2754.783171] Call Trace:
> [ 2754.783184]  <IRQ>  [<ffffffff810a8d46>] sched_show_task+0x116/0x180
> [ 2754.783215]  [<ffffffff810a8cb2>] ? sched_show_task+0x82/0x180
> [ 2754.783239]  [<ffffffff810acf4d>] dump_cpu_task+0x3d/0x50
> [ 2754.783261]  [<ffffffff810dc0c0>] rcu_dump_cpu_stacks+0x90/0xd0
> [ 2754.783286]  [<ffffffff810e3db3>] rcu_check_callbacks+0x573/0x850
> [ 2754.783311]  [<ffffffff8138cb43>] ? __this_cpu_preempt_check+0x13/0x20
> [ 2754.783337]  [<ffffffff810ec043>] ? hrtimer_run_queues+0x43/0x130
> [ 2754.783361]  [<ffffffff810ea5eb>] update_process_times+0x4b/0x80
> [ 2754.783386]  [<ffffffff810fb2cc>] tick_sched_timer+0x4c/0x1b0
> [ 2754.783409]  [<ffffffff810eb5db>] ? __run_hrtimer+0xbb/0x2e0
> [ 2754.783432]  [<ffffffff810eb5db>] __run_hrtimer+0xbb/0x2e0
> [ 2754.783454]  [<ffffffff810eb984>] ? hrtimer_interrupt+0x94/0x260
> [ 2754.783478]  [<ffffffff810fb280>] ? tick_init_highres+0x20/0x20
> [ 2754.783501]  [<ffffffff810eb9f7>] hrtimer_interrupt+0x107/0x260
> [ 2754.783526]  [<ffffffff81033258>] local_apic_timer_interrupt+0x38/0x70
> [ 2754.783552]  [<ffffffff817e16f5>] smp_apic_timer_interrupt+0x45/0x60
> [ 2754.783578]  [<ffffffff817dfadf>] apic_timer_interrupt+0x6f/0x80

Looks like standard scheduling-clock interrupt above this point.

> [ 2754.783600]  <EOI>  [<ffffffff810c541d>] ? lock_release_holdtime.part.24+0x9d/0x160

If this was an acquisition rather than a release, I would suspect high
lock contention.  Could just be luck of the draw,I suppose.

Or am I missing something subtle here?

							Thanx, Paul

> [ 2754.783634]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
> [ 2754.783659]  [<ffffffff8118524c>] ? __alloc_pages_nodemask+0x1ac/0xb60
> [ 2754.783684]  [<ffffffff811cf4be>] ? alloc_pages_vma+0xee/0x1b0
> [ 2754.783708]  [<ffffffff810ad575>] ? local_clock+0x25/0x30
> [ 2754.783731]  [<ffffffff810c6e2c>] ? __lock_acquire.isra.31+0x22c/0x9f0
> [ 2754.783756]  [<ffffffff810a73e1>] ? get_parent_ip+0x11/0x50
> [ 2754.783779]  [<ffffffff810c541d>] ? lock_release_holdtime.part.24+0x9d/0x160
> [ 2754.784613]  [<ffffffff811cf4be>] alloc_pages_vma+0xee/0x1b0
> [ 2754.785452]  [<ffffffff811aa21a>] ? do_wp_page+0xca/0x7d0
> [ 2754.786305]  [<ffffffff811aa21a>] do_wp_page+0xca/0x7d0
> [ 2754.787140]  [<ffffffff811acb6b>] handle_mm_fault+0x6cb/0xe90
> [ 2754.787948]  [<ffffffff81042b20>] ? __do_page_fault+0x140/0x600
> [ 2754.788748]  [<ffffffff81042b84>] __do_page_fault+0x1a4/0x600
> [ 2754.789562]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
> [ 2754.790340]  [<ffffffff810c541d>] ? lock_release_holdtime.part.24+0x9d/0x160
> [ 2754.791113]  [<ffffffff810a73e1>] ? get_parent_ip+0x11/0x50
> [ 2754.791879]  [<ffffffff810a755b>] ? preempt_count_sub+0x7b/0x100
> [ 2754.792646]  [<ffffffff8137fa0d>] ? trace_hardirqs_off_thunk+0x3a/0x3f
> [ 2754.793413]  [<ffffffff81042fec>] do_page_fault+0xc/0x10
> [ 2754.794176]  [<ffffffff817e0862>] page_fault+0x22/0x30
> [ 2754.794938] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 2754.795736] 	Tasks blocked on level-0 rcu_node (CPUs 0-7):
> [ 2754.796528] 	0: (1 GPs behind) idle=6ef/140000000000001/0 softirq=247160/247161 
> [ 2754.797334] 	Tasks blocked on level-0 rcu_node (CPUs 0-7):
> [ 2754.798153] 	(detected by 3, t=24343 jiffies, g=104086, c=104085, q=0)
> [ 2754.798981] Task dump for CPU 0:
> [ 2754.799797] trinity-c387    R  running task    14016 13658  12780 0x00000008
> [ 2754.800630]  ffff880222365bc0 0000000000000246 0000000127e77e08 8000000000000865
> [ 2754.801461]  ffff8802000000a9 800000008d044865 0000000000000000 ffff8802256d3c70
> [ 2754.802288]  ffff880227e77e28 00000000000000a9 0000000000d8eff8 ffff880227e77f58
> [ 2754.803109] Call Trace:
> [ 2754.803929]  [<ffffffff81042b84>] ? __do_page_fault+0x1a4/0x600
> [ 2754.804765]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
> [ 2754.805596]  [<ffffffff810c541d>] ? lock_release_holdtime.part.24+0x9d/0x160
> [ 2754.806444]  [<ffffffff810a73e1>] ? get_parent_ip+0x11/0x50
> [ 2754.807267]  [<ffffffff810a755b>] ? preempt_count_sub+0x7b/0x100
> [ 2754.808088]  [<ffffffff8137fa0d>] ? trace_hardirqs_off_thunk+0x3a/0x3f
> [ 2754.808920]  [<ffffffff81042fec>] ? do_page_fault+0xc/0x10
> [ 2754.809742]  [<ffffffff817e0862>] ? page_fault+0x22/0x30
> [ 2771.561356] ------------[ cut here ]------------
> [ 2771.562079] WARNING: CPU: 0 PID: 13696 at kernel/watchdog.c:317 watchdog_overflow_callback+0xdd/0x130()
> [ 2771.562879] Watchdog detected hard LOCKUP on cpu 0
> [ 2771.562895] CPU: 0 PID: 13696 Comm: trinity-c425 Not tainted 3.18.0+ #101 
> [ 2771.564490]  ffffffff81a66315 00000000fce35109 ffff880244005b88 ffffffff817d317e
> [ 2771.565315]  0000000000110004 ffff880244005be0 ffff880244005bc8 ffffffff81078a01
> [ 2771.566136]  0000000000000000 0000000000000000 0000000000000000 ffff880244005d30
> [ 2771.566954] Call Trace:
> [ 2771.567759]  <NMI>  [<ffffffff817d317e>] dump_stack+0x4f/0x7c
> [ 2771.568584]  [<ffffffff81078a01>] warn_slowpath_common+0x81/0xa0
> [ 2771.569405]  [<ffffffff81078a75>] warn_slowpath_fmt+0x55/0x70
> [ 2771.570253]  [<ffffffff8112fea0>] ? restart_watchdog_hrtimer+0x60/0x60
> [ 2771.571074]  [<ffffffff8112ff7d>] watchdog_overflow_callback+0xdd/0x130
> [ 2771.571894]  [<ffffffff81173a7c>] __perf_event_overflow+0xac/0x2a0
> [ 2771.572721]  [<ffffffff81019952>] ? x86_perf_event_set_period+0xe2/0x150
> [ 2771.573551]  [<ffffffff81174644>] perf_event_overflow+0x14/0x20
> [ 2771.574378]  [<ffffffff8101f479>] intel_pmu_handle_irq+0x209/0x410
> [ 2771.575210]  [<ffffffff8101875b>] perf_event_nmi_handler+0x2b/0x50
> [ 2771.576040]  [<ffffffff81007634>] nmi_handle+0xa4/0x1e0
> [ 2771.576868]  [<ffffffff81007595>] ? nmi_handle+0x5/0x1e0
> [ 2771.577698]  [<ffffffff81006de1>] ? print_context_stack+0xe1/0x100
> [ 2771.578526]  [<ffffffff810079aa>] default_do_nmi+0x7a/0x1d0
> [ 2771.579354]  [<ffffffff81007bb8>] do_nmi+0xb8/0xf0
> [ 2771.580206]  [<ffffffff817e0c2a>] end_repeat_nmi+0x1e/0x2e
> [ 2771.581023]  [<ffffffff817d0f85>] ? free_debug_processing+0x157/0x22a
> [ 2771.581836]  [<ffffffff817d0f85>] ? free_debug_processing+0x157/0x22a
> [ 2771.582644]  [<ffffffff81006de1>] ? print_context_stack+0xe1/0x100
> [ 2771.583452]  [<ffffffff81006de1>] ? print_context_stack+0xe1/0x100
> [ 2771.584253]  [<ffffffff81006de1>] ? print_context_stack+0xe1/0x100
> [ 2771.585042]  <<EOE>>  [<ffffffff81005710>] dump_trace+0x140/0x370
> [ 2771.585841]  [<ffffffff812005c6>] ? final_putname+0x26/0x50
> [ 2771.586636]  [<ffffffff81013ecf>] save_stack_trace+0x2f/0x50
> [ 2771.587430]  [<ffffffff811d4f20>] set_track+0x70/0x140
> [ 2771.588217]  [<ffffffff817d0f85>] free_debug_processing+0x157/0x22a
> [ 2771.589015]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
> [ 2771.589815]  [<ffffffff817d10ad>] __slab_free+0x55/0x320
> [ 2771.590636]  [<ffffffff8138e016>] ? debug_check_no_obj_freed+0x156/0x250
> [ 2771.591442]  [<ffffffff81212294>] ? mntput+0x24/0x40
> [ 2771.592242]  [<ffffffff811d7fd2>] kmem_cache_free+0x262/0x280
> [ 2771.593036]  [<ffffffff812005c6>] ? final_putname+0x26/0x50
> [ 2771.593831]  [<ffffffff812005c6>] final_putname+0x26/0x50
> [ 2771.594622]  [<ffffffff81200869>] putname+0x29/0x40
> [ 2771.595411]  [<ffffffff8120166e>] user_path_at_empty+0x6e/0xc0
> [ 2771.596199]  [<ffffffff81212197>] ? mntput_no_expire+0x67/0x140
> [ 2771.596986]  [<ffffffff81212135>] ? mntput_no_expire+0x5/0x140
> [ 2771.597766]  [<ffffffff81207df6>] ? dput+0x56/0x190
> [ 2771.598542]  [<ffffffff812016d1>] user_path_at+0x11/0x20
> [ 2771.599311]  [<ffffffff812187ec>] path_setxattr+0x4c/0xe0
> [ 2771.600097]  [<ffffffff81218a51>] SyS_lsetxattr+0x11/0x20
> [ 2771.600848]  [<ffffffff817dec12>] system_call_fastpath+0x12/0x17
> [ 2771.601598] ---[ end trace 7b78126c55dcb717 ]---
> [ 2771.602404] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 40.989 msecs
> [ 2771.603175] perf interrupt took too long (322423 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> [ 3471.463812] perf interrupt took too long (319933 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
> [ 4563.539619] perf interrupt took too long (317460 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
> [ 5676.723413] perf interrupt took too long (315015 > 19841), lowering kernel.perf_event_max_sample_rate to 6300
> [ 6800.751151] perf interrupt took too long (312583 > 39062), lowering kernel.perf_event_max_sample_rate to 3200
> [ 8056.882309] perf interrupt took too long (310176 > 78125), lowering kernel.perf_event_max_sample_rate to 1600
> [ 9233.809073] perf interrupt took too long (307790 > 156250), lowering kernel.perf_event_max_sample_rate to 800
> 
> again, the box survived.   Next run I'll try undoing Chris' idea of no serial,
> and see if it wedges after the spew.  After that, I'll do a no preempt run.
> 
> 	Dave
> 
> 

