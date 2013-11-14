Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3KNTHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:07:34 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46343 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3KNTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:07:27 -0500
Date: Thu, 14 Nov 2013 14:15:49 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf/x86 BUG/oops in __intel_shared_reg_get_constraints
Message-ID: <alpine.DEB.2.10.1311141412060.8746@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

the perf_fuzzer kicked out this one while I was verifying the tracepoint 
fix.  This is stock 3.12 with the two recent perf/tracepoint fixes
on a core2 machine.

Vince

[ 2715.629603] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 2715.632001] IP: [<ffffffff8151dc71>] _raw_spin_lock_irqsave+0x11/0x2d
[ 2715.632001] PGD bc11f067 PUD c234d067 PMD 0 
[ 2715.632001] Oops: 0002 [#1] SMP 
[ 2715.632001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 acpi_cpufreq usbnet psmouse evdev serio_raw coretemp pcspkr button wmi video ohci_pci ohci_hcd processor i2c_nforce2 thermal_sys ehci_pci sg ehci_hcd sd_mod usbcore usb_common
[ 2715.632001] CPU: 1 PID: 9731 Comm: perf_fuzzer Tainted: G        W    3.12.0 #3
[ 2715.632001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[ 2715.632001] task: ffff8800cbad9890 ti: ffff8800bc0c2000 task.ti: ffff8800bc0c2000
[ 2715.632001] RIP: 0010:[<ffffffff8151dc71>]  [<ffffffff8151dc71>] _raw_spin_lock_irqsave+0x11/0x2d
[ 2715.632001] RSP: 0018:ffff8800bc0c3af8  EFLAGS: 00010046
[ 2715.632001] RAX: 0000000000000046 RBX: ffff8800bec9c000 RCX: 0000000000000000
[ 2715.632001] RDX: 0000000000010000 RSI: ffff8800bec9c000 RDI: 0000000000000000
[ 2715.632001] RBP: ffff8800bc0c3af8 R08: ffff8800bec9c000 R09: ffff8800bc0c3d18
[ 2715.632001] R10: 00007f7bf54c80a4 R11: 0000000000000246 R12: ffff88011fc8b940
[ 2715.632001] R13: 0000000000000000 R14: ffff8800bec9c148 R15: 0000000000000000
[ 2715.632001] FS:  00007f7bf56e0700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[ 2715.632001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2715.632001] CR2: 0000000000000000 CR3: 00000000bcbc6000 CR4: 00000000000407e0
[ 2715.632001] DR0: 00000000a86fb8ff DR1: 000000000080ffcd DR2: 000040dbdfdbdbdb
[ 2715.632001] DR3: 0000000100000000 DR6: 00000000ffff0ff0 DR7: 0000000000030602
[ 2715.632001] Stack:
[ 2715.632001]  ffff8800bc0c3b48 ffffffff81018db4 0000000000000000 0000000000000000
[ 2715.632001]  00007fffb0ae0fff 0000000000000000 ffff8800bec9c000 ffff88011fc8b940
[ 2715.632001]  0000000000000040 0000000000000000 ffff8800bc0c3b78 ffffffff81018f77
[ 2715.632001] Call Trace:
[ 2715.632001]  [<ffffffff81018db4>] ? __intel_shared_reg_get_constraints+0x5e/0x19c
[ 2715.632001]  [<ffffffff81018f77>] ? intel_get_event_constraints+0x85/0x154
[ 2715.632001]  [<ffffffff810138db>] ? x86_schedule_events+0x53/0x17f
[ 2715.632001]  [<ffffffff81012490>] ? x86_pmu_commit_txn+0x4a/0x8d
[ 2715.632001]  [<ffffffff810ccf04>] ? perf_output_copy+0x2f/0x85
[ 2715.632001]  [<ffffffff810c5833>] ? perf_swevent_add+0x37/0xf7
[ 2715.632001]  [<ffffffff810c7394>] ? event_sched_in+0x79/0x107
[ 2715.632001]  [<ffffffff810c74b1>] ? group_sched_in+0x8f/0x142
[ 2715.632001]  [<ffffffff810c7394>] ? event_sched_in+0x79/0x107
[ 2715.632001]  [<ffffffff810c74b1>] ? group_sched_in+0x8f/0x142
[ 2715.632001]  [<ffffffff810c7c81>] ? __perf_event_enable+0x118/0x173
[ 2715.632001]  [<ffffffff810c7fd6>] ? perf_event_task_output+0x117/0x117
[ 2715.632001]  [<ffffffff810c800a>] ? remote_function+0x34/0x39
[ 2715.632001]  [<ffffffff8108c378>] ? smp_call_function_single+0x8a/0x101
[ 2715.632001]  [<ffffffff810c8051>] ? task_function_call+0x42/0x4c
[ 2715.632001]  [<ffffffff810c7b69>] ? __perf_event_task_sched_in+0x108/0x108
[ 2715.632001]  [<ffffffff810c857f>] ? perf_event_enable+0x10a/0x141
[ 2715.632001]  [<ffffffff8151b011>] ? mutex_lock+0x16/0x37
[ 2715.632001]  [<ffffffff810c8475>] ? perf_install_in_context+0xb8/0xb8
[ 2715.632001]  [<ffffffff810c5c2f>] ? perf_event_for_each_child+0x56/0x88
[ 2715.632001]  [<ffffffff810c5d0c>] ? perf_event_task_enable+0x3f/0x6c
[ 2715.632001]  [<ffffffff8104eb35>] ? SyS_prctl+0x151/0x341
[ 2715.632001]  [<ffffffff81524d16>] ? system_call_fastpath+0x1a/0x1f
[ 2715.632001] Code: c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 66 39 d0 74 04 f3 90 eb f4 c9 c3 55 48 89 e5 66 66 66 66 90 9c 58 fa ba 00 00 01 00 <f0> 0f c1 17 89 d1 c1 e9 10 66 39 d1 74 0c 66 8b 17 66 39 ca 74 
[ 2715.632001] RIP  [<ffffffff8151dc71>] _raw_spin_lock_irqsave+0x11/0x2d
[ 2715.632001]  RSP <ffff8800bc0c3af8>
[ 2715.632001] CR2: 0000000000000000
[ 2715.632001] ---[ end trace 2f66a1bf606d6b56 ]---
