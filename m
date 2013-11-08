Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3KHUCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:02:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59317 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3KHUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:02:49 -0500
Date: Fri, 8 Nov 2013 21:02:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131108200244.GB14606@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 03:06:11PM -0500, Vince Weaver wrote:
> 
> and again, this time after 600k successful syscalls or so.
> 
> This is on a core2 machine.
> 
> [ 1020.396002] ------------[ cut here ]------------
> [ 1020.396002] WARNING: CPU: 1 PID: 3036 at kernel/watchdog.c:245 watchdog_over)
> [ 1020.396002] Watchdog detected hard LOCKUP on cpu 1
> [ 1020.396002] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
> [ 1020.396002] CPU: 1 PID: 3036 Comm: perf_fuzzer Not tainted 3.12.0 #2
> [ 1020.396002] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
> [ 1020.396002]  00000000000000f5 ffff88011fc87c48 ffffffff8151aad6 ffff88011fc88
> [ 1020.396002]  ffffffff8103cd68 0000000100000000 ffffffff810a101c ffff88011b380
> [ 1020.396002]  ffff88011fc87ef8 ffff88011fc87d58 0000000000000000 ffff88011fc88
> [ 1020.396002] Call Trace:
> [ 1020.396002]  <NMI>  [<ffffffff8151aad6>] ? dump_stack+0x41/0x53
> [ 1020.396002]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c
> [ 1020.396002]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
> [ 1020.396002]  [<ffffffff8103ce25>] ? warn_slowpath_fmt+0x46/0x48
> [ 1020.396002]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
> [ 1020.396002]  [<ffffffff810ca4a2>] ? __perf_event_overflow+0x12e/0x1ab
> [ 1020.396002]  [<ffffffff81018cf5>] ? intel_pmu_handle_irq+0x318/0x34d
> [ 1020.396002]  [<ffffffff81018cfc>] ? intel_pmu_handle_irq+0x31f/0x34d
> [ 1020.396002]  [<ffffffff81018c95>] ? intel_pmu_handle_irq+0x2b8/0x34d
> [ 1020.396002]  [<ffffffff81018671>] ? intel_pmu_enable_all+0x55/0xa7
> [ 1020.396002]  [<ffffffff8151edfc>] ? nmi_handle+0xa8/0x13a
> [ 1020.396002]  [<ffffffff8151f473>] ? perf_event_nmi_handler+0x24/0x3d
> [ 1020.396002]  [<ffffffff8151edb2>] ? nmi_handle+0x5e/0x13a
> [ 1020.396002]  [<ffffffff8151ef35>] ? do_nmi+0xa7/0x2bd
> [ 1020.396002]  [<ffffffff8151e537>] ? end_repeat_nmi+0x1e/0x2e
> [ 1020.396002]  [<ffffffff8102bcc8>] ? apic_send_IPI_self+0x33/0x35
> [ 1020.396002]  [<ffffffff8102bcc8>] ? apic_send_IPI_self+0x33/0x35
> [ 1020.396002]  [<ffffffff8102bcc8>] ? apic_send_IPI_self+0x33/0x35
> [ 1020.396002]  <<EOE>>  <IRQ>  [<ffffffff81005ee2>] ? arch_irq_work_raise+0x27a
> [ 1020.396002]  [<ffffffff810c4ada>] ? irq_work_queue+0x70/0x72
> [ 1020.396002]  [<ffffffff810ca510>] ? __perf_event_overflow+0x19c/0x1ab
> [ 1020.396002]  [<ffffffff8104ae16>] ? __send_signal+0x244/0x26f
> [ 1020.396002]  [<ffffffff810ca68b>] ? perf_swevent_overflow+0x3f/0x58
> [ 1020.396002]  [<ffffffff810ca8a5>] ? perf_tp_event+0xe9/0x1f6
> [ 1020.396002]  [<ffffffff81005f6b>] ? smp_trace_irq_work_interrupt+0x34/0x7e
> [ 1020.396002]  [<ffffffff81040954>] ? perf_trace_softirq+0x8a/0x96
> [ 1020.396002]  [<ffffffff8100366f>] ? perf_trace_x86_irq_vector+0xc0/0xc9
> [ 1020.396002]  [<ffffffff81005f6b>] ? smp_trace_irq_work_interrupt+0x34/0x7e
> [ 1020.396002]  [<ffffffff81005f6b>] ? smp_trace_irq_work_interrupt+0x34/0x7e
> [ 1020.396002]  [<ffffffff815261ca>] ? trace_irq_work_interrupt+0x6a/0x70
> [ 1020.396002]  [<ffffffff81040fba>] ? __do_softirq+0x95/0x208
> [ 1020.396002]  [<ffffffff815263dc>] ? call_softirq+0x1c/0x30
> [ 1020.396002]  [<ffffffff810041b9>] ? do_softirq+0x38/0x6d
> [ 1020.396002]  [<ffffffff81040d1c>] ? irq_exit+0x45/0xa1
> [ 1020.396002]  [<ffffffff81526a14>] ? smp_trace_apic_timer_interrupt+0x83/0x91
> [ 1020.396002]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
> [ 1020.396002]  <EOI>  [<ffffffff810c7c20>] ? __perf_event_enable+0x118/0x173
> [ 1020.396002]  [<ffffffff8104c694>] ? get_signal_to_deliver+0x47d/0x48a
> [ 1020.396002]  [<ffffffff810024da>] ? do_signal+0x46/0x5f5
> [ 1020.396002]  [<ffffffff8100b9f5>] ? perf_trace_sys_exit+0x3e/0xa7
> [ 1020.396002]  [<ffffffff81002ab5>] ? do_notify_resume+0x2c/0x6a
> [ 1020.396002]  [<ffffffff81524ea0>] ? int_signal+0x12/0x17
> [ 1020.396002] ---[ end trace 2b385d729ba32e92 ]---
> [ 1020.396002] perf samples too long (8101340 > 10000), lowering kernel.perf_ev0
> [ 1020.396002] INFO: NMI handler (perf_event_nmi_handler) took too long to run:s
> [ 1033.301811] perf samples too long (8038058 > 20000), lowering kernel.perf_ev0
> [ 1034.125811] perf samples too long (7975268 > 40000), lowering kernel.perf_ev0
> [ 1034.973813] perf samples too long (7912968 > 76923), lowering kernel.perf_ev0
> [ 1035.821813] perf samples too long (7851154 > 142857), lowering kernel.perf_e0
> [ 1036.669813] perf samples too long (7789824 > 250000), lowering kernel.perf_e0
> [ 1037.517812] perf samples too long (7728973 > 500000), lowering kernel.perf_e0
> 

There seem to be a loop that takes too long in intel_pmu_handle_irq(). Your two
previous reports seemed to suggest that lbr is involved, but not this one.

I'm going to look further into this, unfortunately my testbox is an AMD...
