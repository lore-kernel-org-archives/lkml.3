Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaCCSjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:39:23 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46073 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaCCSjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:39:21 -0500
Date: Mon, 3 Mar 2014 13:41:32 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: WARNING: Can't find any breakpoint slot
Message-ID: <alpine.DEB.2.10.1403031341260.11945@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The perf_fuzzer triggered this on a core2 machine running 3.14-rc5.

Mar  3 13:35:18 core2 kernel: [ 4100.124001] WARNING: CPU: 0 PID: 25900 at arch/x86/kernel/hw_breakpoint.c:120 arch_install_hw_breakpoint+0x6b/0xf8()
Mar  3 13:35:18 core2 kernel: [ 4100.124001] Can't find any breakpoint slot
Mar  3 13:35:18 core2 kernel: [ 4100.124001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 ohci_pci usbnet evdev pcspkr psmouse serio_raw coretemp ohci_hcd i2c_nforce2 video wmi button acpi_cpufreq processor thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common
Mar  3 13:35:18 core2 kernel: [ 4100.124001] CPU: 0 PID: 25900 Comm: perf_fuzzer Not tainted 3.14.0-rc5 #32
Mar  3 13:35:18 core2 kernel: [ 4100.124001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  0000000000000078 ffff880071189b18 ffffffff81531e61 0000000000000078
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  ffff880071189b68 ffff880071189b58 ffffffff8103fce4 ffff880071189b48
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  ffffffff81008e38 0000000000000004 ffff8800cb0e4800 ffff8800cad04680
Mar  3 13:35:18 core2 kernel: [ 4100.124001] Call Trace:
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff81531e61>] dump_stack+0x49/0x60
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff8103fce4>] warn_slowpath_common+0x81/0x9b
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff81008e38>] ? arch_install_hw_breakpoint+0x6b/0xf8
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff8103fda1>] warn_slowpath_fmt+0x46/0x48
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff81008e38>] arch_install_hw_breakpoint+0x6b/0xf8
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810d35a5>] hw_breakpoint_add+0x49/0x4d
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810ccfe8>] event_sched_in+0x8c/0x12d
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cd0d3>] group_sched_in+0x4a/0x147
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cd32e>] ctx_sched_in+0x15e/0x185
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cd3be>] perf_event_sched_in+0x69/0x72
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cd48f>] __perf_install_in_context+0xc8/0xf1
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cdcc2>] ? perf_event_task_output+0x13d/0x13d
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cdcfe>] remote_function+0x3c/0x43
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff81095451>] smp_call_function_single+0x8a/0x101
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cdd49>] task_function_call+0x44/0x4e
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cd3c7>] ? perf_event_sched_in+0x72/0x72
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cde7e>] perf_install_in_context+0x81/0xbc
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff815332fb>] ? mutex_lock+0x16/0x37
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810d214d>] SYSC_perf_event_open+0x647/0x7f5
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cb607>] ? perf_event_for_each_child+0x82/0x8b
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810cdeb9>] ? perf_install_in_context+0xbc/0xbc
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff810d2304>] SyS_perf_event_open+0x9/0xb
Mar  3 13:35:18 core2 kernel: [ 4100.124001]  [<ffffffff8153bf26>] system_call_fastpath+0x1a/0x1f
Mar  3 13:35:18 core2 kernel: [ 4100.124001] ---[ end trace e316e2bd7d603a09 ]---

