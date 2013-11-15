Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3KORSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:18:12 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:37957 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KORSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:18:03 -0500
Date: Fri, 15 Nov 2013 12:26:16 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf sw_event related lockup
In-Reply-To: <20131115145944.GA3694@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1311151223040.11932@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu> <20131115145944.GA3694@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, Peter Zijlstra wrote:
> 
> Please enable CONFIG_FRAME_POINTER to get better backtraces, but the
> above suggests the pagefault swevent, will have a look.

here it is again I think.  I compiled with CONFIG_FRAME_POINTER but the 
backtraces don't look that different.

Sorry about the truncation of the right edge of the dump, this is over a 
serial console and I can't figure out how to get minicom configured 
properly to not do that.


[  132.648914] hrtimer: interrupt took 1372 ns
[  236.300427] perf samples too long (2502 > 2500), lowering kernel.perf_event_0
[  236.301947] INFO: NMI handler (perf_event_nmi_handler) took too long to run:s
[  555.475509] perf samples too long (5002 > 5000), lowering kernel.perf_event_0
[  555.589569] perf samples too long (10005 > 10000), lowering kernel.perf_even0
[  555.593183] INFO: NMI handler (perf_event_nmi_handler) took too long to run:s
[  571.903706] ------------[ cut here ]------------
[  571.907549] WARNING: CPU: 1 PID: 3926 at arch/x86/kernel/cpu/perf_event.c:10)
[  571.907549] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
[  571.907549] CPU: 1 PID: 3926 Comm: perf_fuzzer Not tainted 3.12.0 #4
[  571.907549] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[  571.907549]  0000000000000434 ffff8800ca4afab8 ffffffff8151d8ec 0000000000004
[  571.907549]  0000000000000000 ffff8800ca4afaf8 ffffffff8103cda9 0000000200003
[  571.907549]  ffffffff81012a69 ffff8800c813e800 ffff88011fc8b940 0000000000001
[  571.907549] Call Trace:
[  571.907549]  [<ffffffff8151d8ec>] dump_stack+0x49/0x5d
[  571.907549]  [<ffffffff8103cda9>] warn_slowpath_common+0x81/0x9b
[  571.907549]  [<ffffffff81012a69>] ? x86_pmu_start+0x4f/0xf8
[  571.907549]  [<ffffffff8103cddd>] warn_slowpath_null+0x1a/0x1c
[  571.907549]  [<ffffffff81012a69>] x86_pmu_start+0x4f/0xf8
[  571.907549]  [<ffffffff81012cea>] x86_pmu_enable+0x1d8/0x27d
[  571.907549]  [<ffffffff810c5ea5>] perf_pmu_enable+0x21/0x23
[  571.907549]  [<ffffffff81012721>] x86_pmu_commit_txn+0x84/0x9a
[  571.907549]  [<ffffffff810db64c>] ? release_pages+0x18a/0x199
[  571.907549]  [<ffffffff810c88bc>] ? event_sched_in+0x7a/0x109
[  571.907549]  [<ffffffff810c89e3>] group_sched_in+0x98/0x147
[  571.907549]  [<ffffffff810c91e9>] __perf_event_enable+0x117/0x172
[  571.907549]  [<ffffffff810c956f>] ? perf_event_task_output+0x13d/0x13d
[  571.907549]  [<ffffffff810c95ab>] remote_function+0x3c/0x43
[  571.907549]  [<ffffffff8108c655>] smp_call_function_single+0x8a/0x101
[  571.907549]  [<ffffffff810c95f6>] task_function_call+0x44/0x4e
[  571.907549]  [<ffffffff810c90d2>] ? __perf_event_task_sched_in+0x10e/0x10e
[  571.907549]  [<ffffffff810c9b59>] perf_event_enable+0x112/0x150
[  571.907549]  [<ffffffff810c9a47>] ? perf_install_in_context+0xbc/0xbc
[  571.907549]  [<ffffffff810c7027>] perf_event_for_each_child+0x58/0x8b
[  571.907549]  [<ffffffff810c7122>] perf_event_task_enable+0x4b/0x7d
[  571.907549]  [<ffffffff8104ed5a>] SyS_prctl+0x151/0x341
[  571.907549]  [<ffffffff81527b56>] system_call_fastpath+0x1a/0x1f
[  571.907549] ---[ end trace ee0dc4a441b301bf ]---
[  573.054155] BUG: unable to handle kernel NULL pointer dereference at        )
[  573.057564] IP: [<ffffffff81520a44>] _raw_spin_lock_irqsave+0x11/0x2d
[  573.057564] PGD c814b067 PUD cb183067 PMD 0 
[  573.057564] Oops: 0002 [#1] SMP 
[  573.057564] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
[  573.057564] CPU: 1 PID: 3926 Comm: perf_fuzzer Tainted: G        W    3.12.04
[  573.057564] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[  573.057564] task: ffff880037cfd0c0 ti: ffff8800ca4ae000 task.ti: ffff8800ca40
[  573.057564] RIP: 0010:[<ffffffff81520a44>]  [<ffffffff81520a44>] _raw_spin_ld
[  573.057564] RSP: 0018:ffff8800ca4afa08  EFLAGS: 00010046
[  573.057564] RAX: 0000000000000046 RBX: ffff8800c813e800 RCX: 0000000000000000
[  573.057564] RDX: 0000000000010000 RSI: ffff8800c813e800 RDI: 0000000000000000
[  573.057564] RBP: ffff8800ca4afa08 R08: ffff8800c813e800 R09: ffff8800ca4afdf8
[  573.057564] R10: ffff88011a2261c0 R11: 0000000000000246 R12: ffff88011fc8b940
[  573.057564] R13: 0000000000000000 R14: ffff8800c813e948 R15: 0000000000000000
[  573.057564] FS:  00007fc238e92700(0000) GS:ffff88011fc80000(0000) knlGS:00000
[  573.057564] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  573.057564] CR2: 0000000000000000 CR3: 00000000c88c4000 CR4: 00000000000407e0
[  573.057564] DR0: 0000000000033c20 DR1: 0000000000000000 DR2: 0000000000000000
[  573.057564] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  573.057564] Stack:
[  573.057564]  ffff8800ca4afa58 ffffffff810190b0 0000000000000000 0000000000000
[  573.057564]  ffff88011fff8680 0000000000000000 ffff8800c813e800 ffff88011fc80
[  573.057564]  0000000000000040 0000000000000000 ffff8800ca4afa88 ffffffff81013
[  573.057564] Call Trace:
[  573.057564]  [<ffffffff810190b0>] __intel_shared_reg_get_constraints+0x5e/0xc
[  573.057564]  [<ffffffff81019273>] intel_get_event_constraints+0x85/0x154
[  573.057564]  [<ffffffff81013bcc>] x86_schedule_events+0x54/0x185
[  573.057564]  [<ffffffff8101284f>] ? x86_pmu_add+0xf8/0x110
[  573.057564]  [<ffffffff810126ee>] x86_pmu_commit_txn+0x51/0x9a
[  573.057564]  [<ffffffff810d6fef>] ? __alloc_pages_nodemask+0x173/0x718
[  573.057564]  [<ffffffff810c88bc>] ? event_sched_in+0x7a/0x109
[  573.057564]  [<ffffffff810c89e3>] group_sched_in+0x98/0x147
[  573.057564]  [<ffffffff81067436>] ? sched_clock_cpu+0xc3/0xd1
[  573.057564]  [<ffffffff810c8bf0>] ctx_sched_in+0x15e/0x185
[  573.057564]  [<ffffffff810c8c80>] perf_event_sched_in+0x69/0x72
[  573.057564]  [<ffffffff810c8d51>] __perf_install_in_context+0xc8/0xf1
[  573.057564]  [<ffffffff810c956f>] ? perf_event_task_output+0x13d/0x13d
[  573.057564]  [<ffffffff810c95ab>] remote_function+0x3c/0x43
[  573.057564]  [<ffffffff8108c655>] smp_call_function_single+0x8a/0x101
[  573.057564]  [<ffffffff810c95f6>] task_function_call+0x44/0x4e
[  573.057564]  [<ffffffff810c8c89>] ? perf_event_sched_in+0x72/0x72
[  573.057564]  [<ffffffff810c9a0c>] perf_install_in_context+0x81/0xbc
[  573.057564]  [<ffffffff8151dddc>] ? mutex_lock+0x16/0x37
[  573.057564]  [<ffffffff810cd56b>] SYSC_perf_event_open+0x634/0x7e9
[  573.057564]  [<ffffffff810cd729>] SyS_perf_event_open+0x9/0xb
[  573.057564]  [<ffffffff81527b56>] system_call_fastpath+0x1a/0x1f
[  573.057564] Code: c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 66 39 d0 74 0 
[  573.057564] RIP  [<ffffffff81520a44>] _raw_spin_lock_irqsave+0x11/0x2d
[  573.057564]  RSP <ffff8800ca4afa08>
[  573.057564] CR2: 0000000000000000
[  573.057564] ---[ end trace ee0dc4a441b301c0 ]---
[  577.000000] ------------[ cut here ]------------
[  577.000000] WARNING: CPU: 0 PID: 15546 at kernel/watchdog.c:245 watchdog_ove)
[  577.000000] Watchdog detected hard LOCKUP on cpu 0
[  577.000000] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
[  577.000000] CPU: 0 PID: 15546 Comm: perf_fuzzer Tainted: G      D W    3.12.4
[  577.000000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[  577.000000]  00000000000000f5 ffff88011fc07bc8 ffffffff8151d8ec 0000000000005
[  577.000000]  ffff88011fc07c18 ffff88011fc07c08 ffffffff8103cda9 ffff88011fc08
[  577.000000]  ffffffff810a137f ffff88011b313400 0000000000000000 ffff88011fc08
[  577.000000] Call Trace:
[  577.000000]  <NMI>  [<ffffffff8151d8ec>] dump_stack+0x49/0x5d
[  577.000000]  [<ffffffff8103cda9>] warn_slowpath_common+0x81/0x9b
[  577.000000]  [<ffffffff810a137f>] ? watchdog_overflow_callback+0x9b/0xa6
[  577.000000]  [<ffffffff8103ce66>] warn_slowpath_fmt+0x46/0x48
[  577.000000]  [<ffffffff810a137f>] watchdog_overflow_callback+0x9b/0xa6
[  577.000000]  [<ffffffff810cbb94>] __perf_event_overflow+0x137/0x1c1
[  577.000000]  [<ffffffff81018991>] ? intel_pmu_enable_all+0x4c/0xa4
[  577.000000]  [<ffffffff810cc23a>] perf_event_overflow+0x14/0x16
[  577.000000]  [<ffffffff81018fbd>] intel_pmu_handle_irq+0x2b8/0x34d
[  577.000000]  [<ffffffff8151f82a>] ? __schedule+0x514/0x54b
[  577.000000]  [<ffffffff81522253>] perf_event_nmi_handler+0x2d/0x4a
[  577.000000]  [<ffffffff81521b86>] nmi_handle+0x5e/0x13a
[  577.000000]  [<ffffffff81521d0a>] do_nmi+0xa8/0x2c0
[  577.000000]  [<ffffffff81521337>] end_repeat_nmi+0x1e/0x2e
[  577.000000]  [<ffffffff81520abf>] ? _raw_spin_lock+0x26/0x2a
[  577.000000]  [<ffffffff81520abf>] ? _raw_spin_lock+0x26/0x2a
[  577.000000]  [<ffffffff81520abf>] ? _raw_spin_lock+0x26/0x2a
[  577.000000]  <<EOE>>  <IRQ>  [<ffffffff8106cf00>] sched_rt_period_timer+0x8be
[  577.000000]  [<ffffffff8105c156>] __run_hrtimer+0xba/0x145
[  577.000000]  [<ffffffff8106ce75>] ? init_rt_bandwidth+0x46/0x46
[  577.000000]  [<ffffffff8105c42b>] hrtimer_interrupt+0xd5/0x1c3
[  577.000000]  [<ffffffff81028469>] local_apic_timer_interrupt+0x58/0x5d
[  577.000000]  [<ffffffff8152983e>] smp_apic_timer_interrupt+0x2a/0x3c
[  577.000000]  [<ffffffff815287ca>] apic_timer_interrupt+0x6a/0x70
[  577.000000]  <EOI> 
[  577.000000] ---[ end trace ee0dc4a441b301c1 ]---
[  577.000000] perf samples too long (5541124 > 20000), lowering kernel.perf_ev0
[  577.000000] INFO: NMI handler (perf_event_nmi_handler) took too long to run:s
[  577.000000] perf samples too long (5497840 > 40000), lowering kernel.perf_ev0
[  577.000000] perf samples too long (5454894 > 76923), lowering kernel.perf_ev0
[  577.000000] perf samples too long (5412282 > 142857), lowering kernel.perf_e0
[  577.000000] perf samples too long (5370004 > 250000), lowering kernel.perf_e0
[  577.000000] perf samples too long (5328056 > 500000), lowering kernel.perf_e0
