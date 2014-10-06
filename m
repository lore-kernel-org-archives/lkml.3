Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaJFP3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:29:37 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:59808 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaJFP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:29:35 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 6 Oct 2014 11:36:02 -0400 (EDT)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: perf: 3.17 another perf_fuzzer lockup 
Message-ID: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I reported this on the other thread but it seems to be unrelated to the 
other bug, and this time instead of simply wedging the process I got a 
backtrace and the machine locked solid.

This is reproducible, on 3.17 on a core2.

Trying to get something useful out of ftrace but no luck so far.

Vince

[  843.700042] general protection fault: 0000 [#1] SMP 
[  843.704001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 evdev usbnet coretemp ohci_pci pcspkr ohci_hcd psmouse serio_raw video wmi i2c_nforce2 button acpi_cpufreq processor thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  843.704001] CPU: 1 PID: 7273 Comm: perf_fuzzer Not tainted 3.17.0+ #86
[  843.704001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  843.704001] task: ffff88011a874000 ti: ffff8800bc0ec000 task.ti: ffff8800bc0ec000
[  843.704001] RIP: 0010:[<ffffffff810cd913>]  [<ffffffff810cd913>] perf_event_context_sched_in.isra.75+0x1f/0x90
[  843.704001] RSP: 0018:ffff8800bc0efd50  EFLAGS: 00010087
[  843.704001] RAX: ffffea0002ba2d68 RBX: ffff1001e742c000 RCX: 000000000000038f
[  843.704001] RDX: ffff88011fc95b30 RSI: ffff880037d0eb00 RDI: ffff880037d0e700
[  843.704001] RBP: ffff8800bc0efd60 R08: ffff8800bc0ec000 R09: 000000000000baff
[  843.704001] R10: 0000000000000006 R11: 00000000000009bc R12: ffff880037d0e700
[  843.704001] R13: ffff8800c944f400 R14: 0000000000000001 R15: ffff88011b340800
[  843.704001] FS:  00007ffc76c17700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  843.704001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  843.704001] DR0: 0000000001c7b000 DR1: 0000000000000000 DR2: 0000000001c7b000
[  843.704001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  843.704001] Stack:
[  843.704001]  ffff88011a874000 ffff88011b340800 ffff8800bc0efd90 ffffffff810cd9bb
[  843.704001]  ffff88011a8744e8 ffff88011b340800 ffff88011fc929c0 ffff8800c944f400
[  843.704001]  ffff8800bc0efdc0 ffffffff8105ae62 ffff88011fc929c0 ffff8800c944f400
[  843.704001] Call Trace:
[  843.704001]  [<ffffffff810cd9bb>] __perf_event_task_sched_in+0x37/0xf4
[  843.704001]  [<ffffffff8105ae62>] finish_task_switch+0x9b/0xa6
[  843.704001]  [<ffffffff815209c1>] __schedule+0x309/0x4a5
[  843.704001]  [<ffffffff81520df3>] _cond_resched+0x28/0x3b
[  843.704001]  [<ffffffff815217b5>] mutex_lock+0x12/0x2f
[  843.704001]  [<ffffffff810cb9bb>] find_get_context+0xfc/0x170
[  843.704001]  [<ffffffff810cff77>] SYSC_perf_event_open+0x47b/0x7f5
[  843.704001]  [<ffffffff810d0651>] SyS_perf_event_open+0xe/0x10
[  843.704001]  [<ffffffff81523ad1>] tracesys+0xd4/0xd9
[  843.704001] Code: 89 e7 e8 65 fe ff ff 5b 41 5c 5d c3 e8 c7 7e 45 00 55 48 89 e5 41 54 49 89 fc 53 48 8b 07 48 8b 58 40 65 48 03 1c 25 08 ce 00 00 <48> 39 bb d8 00 00 00 74 63 48 89 fe 48 89 df e8 f0 b4 ff ff 49 
[  843.704001] RIP  [<ffffffff810cd913>] perf_event_context_sched_in.isra.75+0x1f/0x90
[  843.704001]  RSP <ffff8800bc0efd50>
[  843.704001] ---[ end trace 24a30c0f4ce68693 ]---
[  843.960002] ------------[ cut here ]------------
[  843.960002] WARNING: CPU: 0 PID: 2018 at kernel/watchdog.c:267 watchdog_overflow_callback+0x9b/0xa7()
[  843.960002] Watchdog detected hard LOCKUP on cpu 0
[  843.960002] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 evdev usbnet coretemp ohci_pci pcspkr ohci_hcd psmouse serio_raw video wmi i2c_nforce2 button acpi_cpufreq processor thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  843.960002] CPU: 0 PID: 2018 Comm: rsyslogd Tainted: G      D        3.17.0+ #86
[  843.960002] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  843.960002]  0000000000000000 ffff88011fc06c20 ffffffff8151e1be ffff88011fc06c68
[  843.960002]  ffff88011fc06c58 ffffffff8103ee43 ffffffff810a6bd6 ffff88011b349800
[  843.960002]  0000000000000000 ffff88011fc06d70 ffff88011fc06ef8 ffff88011fc06cb8
[  843.960002] Call Trace:
[  843.960002]  <NMI>  [<ffffffff8151e1be>] dump_stack+0x45/0x56
[  843.960002]  [<ffffffff8103ee43>] warn_slowpath_common+0x7f/0x98
[  843.960002]  [<ffffffff810a6bd6>] ? watchdog_overflow_callback+0x9b/0xa7
[  843.960002]  [<ffffffff8103eea8>] warn_slowpath_fmt+0x4c/0x4e
[  843.960002]  [<ffffffff81525821>] ? ftrace_call+0x5/0x2f
[  843.960002]  [<ffffffff81525821>] ? ftrace_call+0x5/0x2f
[  843.960002]  [<ffffffff810a6bd6>] watchdog_overflow_callback+0x9b/0xa7
[  843.960002]  [<ffffffff810cec50>] __perf_event_overflow+0x139/0x1bd
[  843.960002]  [<ffffffff810cf14b>] perf_event_overflow+0x19/0x1b
[  843.960002]  [<ffffffff8101981a>] intel_pmu_handle_irq+0x29d/0x323
[  843.960002]  [<ffffffff81525821>] ? ftrace_call+0x5/0x2f
[  843.960002]  [<ffffffff81012da8>] perf_event_nmi_handler+0x25/0x3e
[  843.960002]  [<ffffffff81005e88>] nmi_handle+0x60/0xf3
[  843.960002]  [<ffffffff8102b34d>] ? cpumask_clear_cpu.constprop.3+0x11/0x11
[  843.960002]  [<ffffffff810060df>] default_do_nmi+0x50/0xdc
[  843.960002]  [<ffffffff810061cf>] do_nmi+0x64/0xa6
[  843.960002]  [<ffffffff8152572a>] end_repeat_nmi+0x1e/0x2e
[  843.960002]  [<ffffffff8106a531>] ? do_raw_spin_lock+0x1c/0x27
[  843.960002]  [<ffffffff8106a531>] ? do_raw_spin_lock+0x1c/0x27
[  843.960002]  [<ffffffff8106a531>] ? do_raw_spin_lock+0x1c/0x27
[  843.960002]  <<EOE>>  <IRQ>  [<ffffffff8152350f>] _raw_spin_lock+0xe/0x10
[  843.960002]  [<ffffffff8106326d>] load_balance+0x2bf/0x63d
[  843.960002]  [<ffffffff8105e0cf>] ? try_to_wake_up+0x1c4/0x1d4
[  843.960002]  [<ffffffff81063a5b>] rebalance_domains+0x144/0x205
[  843.960002]  [<ffffffff81063b59>] run_rebalance_domains+0x3d/0x15c
[  843.960002]  [<ffffffff81041bd4>] __do_softirq+0xde/0x238
[  843.960002]  [<ffffffff81041ea3>] irq_exit+0x3f/0x86
[  843.960002]  [<ffffffff8102a4e1>] smp_apic_timer_interrupt+0x35/0x41
[  843.960002]  [<ffffffff8152480a>] apic_timer_interrupt+0x6a/0x70
[  843.960002]  <EOI> 
[  843.960002] ---[ end trace 24a30c0f4ce68694 ]---
[  843.957990] ------------[ cut here ]------------
[  843.957990] WARNING: CPU: 1 PID: 7273 at kernel/watchdog.c:267 watchdog_overflow_callback+0x9b/0xa7()
[  843.957990] Watchdog detected hard LOCKUP on cpu 1
[  843.957990] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 evdev usbnet coretemp ohci_pci pcspkr ohci_hcd psmouse serio_raw video wmi i2c_nforce2 button acpi_cpufreq processor thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  843.957990] CPU: 1 PID: 7273 Comm: perf_fuzzer Tainted: G      D W      3.17.0+ #86
[  843.957990] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  843.957990]  0000000000000000 ffff88011fc86c20 ffffffff8151e1be ffff88011fc86c68
[  843.957990]  ffff88011fc86c58 ffffffff8103ee43 ffffffff810a6bd6 ffff88011ac2ac00
[  843.957990]  0000000000000001 ffff88011fc86d70 ffff88011fc86ef8 ffff88011fc86cb8
[  843.957990] Call Trace:
[  843.957990]  <NMI>  [<ffffffff8151e1be>] dump_stack+0x45/0x56
[  843.957990]  [<ffffffff8103ee43>] warn_slowpath_common+0x7f/0x98
[  843.957990]  [<ffffffff810a6bd6>] ? watchdog_overflow_callback+0x9b/0xa7
[  843.957990]  [<ffffffff8103eea8>] warn_slowpath_fmt+0x4c/0x4e
[  843.957990]  [<ffffffff81525821>] ? ftrace_call+0x5/0x2f
[  843.957990]  [<ffffffff810a6bd6>] watchdog_overflow_callback+0x9b/0xa7
[  843.957990]  [<ffffffff810cec50>] __perf_event_overflow+0x139/0x1bd
[  843.957990]  [<ffffffff810cf14b>] perf_event_overflow+0x19/0x1b
[  843.957990]  [<ffffffff8101981a>] intel_pmu_handle_irq+0x29d/0x323
[  843.957990]  [<ffffffff81525821>] ? ftrace_call+0x5/0x2f
[  843.957990]  [<ffffffff81012da8>] perf_event_nmi_handler+0x25/0x3e
[  843.957990]  [<ffffffff81005e88>] nmi_handle+0x60/0xf3
[  843.957990]  [<ffffffff8102b34d>] ? cpumask_clear_cpu.constprop.3+0x11/0x11
[  843.957990]  [<ffffffff8108d3f0>] ? tick_sched_do_timer+0x2f/0x2f
[  843.957990]  [<ffffffff810060df>] default_do_nmi+0x50/0xdc
[  843.957990]  [<ffffffff810061cf>] do_nmi+0x64/0xa6
[  843.957990]  [<ffffffff8152572a>] end_repeat_nmi+0x1e/0x2e
[  843.957990]  [<ffffffff8108d3f0>] ? tick_sched_do_timer+0x2f/0x2f
[  843.957990]  [<ffffffff8106a538>] ? do_raw_spin_lock+0x23/0x27
[  843.957990]  [<ffffffff8106a538>] ? do_raw_spin_lock+0x23/0x27
[  843.957990]  [<ffffffff8106a538>] ? do_raw_spin_lock+0x23/0x27
[  843.957990]  <<EOE>>  <IRQ>  [<ffffffff8152350f>] _raw_spin_lock+0xe/0x10
[  843.957990]  [<ffffffff8105d52c>] scheduler_tick+0x3d/0x85
[  843.957990]  [<ffffffff8108145a>] update_process_times+0x56/0x65
[  843.957990]  [<ffffffff8108cf19>] tick_sched_handle+0x4a/0x59
[  843.957990]  [<ffffffff8108d42a>] tick_sched_timer+0x3a/0x58
[  843.957990]  [<ffffffff810818c7>] __run_hrtimer+0x92/0x14b
[  843.957990]  [<ffffffff810820a7>] hrtimer_interrupt+0xe8/0x1d3
[  843.957990]  [<ffffffff8102a189>] local_apic_timer_interrupt+0x54/0x57
[  843.957990]  [<ffffffff8102a4dc>] smp_apic_timer_interrupt+0x30/0x41
[  843.957990]  [<ffffffff8152480a>] apic_timer_interrupt+0x6a/0x70
[  843.957990]  <EOI>  [<ffffffff8107439d>] ? console_unlock+0x30d/0x32b
[  843.957990]  [<ffffffff810975d5>] ? acct_collect+0x164/0x16e
[  843.957990]  [<ffffffff8103fed7>] do_exit+0x21c/0x8fe
[  843.957990]  [<ffffffff8151c536>] ? printk+0x54/0x56
[  843.957990]  [<ffffffff81005685>] oops_end+0xa6/0xad
[  843.957990]  [<ffffffff810059cf>] die+0x5a/0x63
[  843.957990]  [<ffffffff81002e7f>] do_general_protection+0x96/0x142
[  843.957990]  [<ffffffff815253c2>] general_protection+0x22/0x30
[  843.957990]  [<ffffffff810cd913>] ? perf_event_context_sched_in.isra.75+0x1f/0x90
[  843.957990]  [<ffffffff810cd9bb>] __perf_event_task_sched_in+0x37/0xf4
[  843.957990]  [<ffffffff8105ae62>] finish_task_switch+0x9b/0xa6
[  843.957990]  [<ffffffff815209c1>] __schedule+0x309/0x4a5
[  843.957990]  [<ffffffff81520df3>] _cond_resched+0x28/0x3b
[  843.957990]  [<ffffffff815217b5>] mutex_lock+0x12/0x2f
[  843.957990]  [<ffffffff810cb9bb>] find_get_context+0xfc/0x170
[  843.957990]  [<ffffffff810cff77>] SYSC_perf_event_open+0x47b/0x7f5
[  843.957990]  [<ffffffff810d0651>] SyS_perf_event_open+0xe/0x10
[  843.957990]  [<ffffffff81523ad1>] tracesys+0xd4/0xd9
[  843.957990] ---[ end trace 24a30c0f4ce68695 ]---


