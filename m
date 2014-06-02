Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaFBTZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:25:42 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:52835 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaFBTZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:25:39 -0400
MIME-Version: 1.0
Date: Mon, 2 Jun 2014 12:25:38 -0700
Message-ID: <CAHTgTXUYTy05aBQD57LrU3LOfFjBeFNqrewouLCkMOipxa6d=g@mail.gmail.com>
Subject: perf intel_pmu_handle_irq warning
From: Vinson Lee <vlee@twopensource.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

We've seen this perf-related warning with 3.10 on several different
machines. When this warning occurs there are multiple instances of
perf stat running.


------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/perf_event_intel.c:1191
intel_pmu_handle_irq+0xc9/0x2cb()
perfevents: irq loop stuck!
Modules linked in: netconsole configfs cpufreq_ondemand ipv6
dm_multipath video sbs sbshc acpi_pad acpi_ipmi acpi_i2c i2c_core
parport_pc lp parport tcp_diag inet_diag ipmi_si ipmi_
andler iTCO_wdt iTCO_vendor_support dcdbas ses enclosure bnx2 hed wmi
serio_raw i7core_edac edac_core lpc_ich mfd_core microcode
acpi_cpufreq freq_table mperf shpchp megaraid_sas
CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.10.28 #1
 0000000000000000 ffff881219c06cf8 ffffffff814bdbf8 ffff881219c06d30
 ffffffff8103d453 ffff881219c06d40 0000000000000064 ffff881219c0bc90
 0000000000000040 ffff88052ca35800 ffff881219c06d90 ffffffff8103d4b7
Call Trace:
 <NMI>  [<ffffffff814bdbf8>] dump_stack+0x19/0x1b
 [<ffffffff8103d453>] warn_slowpath_common+0x65/0x7d
 [<ffffffff8103d4b7>] warn_slowpath_fmt+0x4c/0x4e
 [<ffffffff810137c1>] intel_pmu_handle_irq+0xc9/0x2cb
 [<ffffffff814c4262>] perf_event_nmi_handler+0x17/0x19
 [<ffffffff814c3b20>] nmi_handle.isra.1+0x73/0xab
 [<ffffffff814c3ab2>] ? nmi_handle.isra.1+0x5/0xab
 [<ffffffff814c3bff>] do_nmi+0xa7/0x2c9
 [<ffffffff814c3307>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff810129e9>] ? x86_pmu_disable_event+0x1b/0x1d
 [<ffffffff810129e9>] ? x86_pmu_disable_event+0x1b/0x1d
 [<ffffffff810129e9>] ? x86_pmu_disable_event+0x1b/0x1d
 <<EOE>>  <IRQ>  [<ffffffff81013092>] intel_pmu_disable_event+0xc8/0xdf
 [<ffffffff8100e4ee>] x86_pmu_stop+0x3a/0x9f
 [<ffffffff8100e582>] x86_pmu_del+0x2f/0x9c
 [<ffffffff810e40e2>] event_sched_out+0x8b/0xf1
 [<ffffffff810e4582>] __perf_remove_from_context+0x3f/0x89
 [<ffffffff810e2b57>] remote_function+0x17/0x40
 [<ffffffff8108fdc5>] generic_smp_call_function_single_interrupt+0xb8/0xe8
 [<ffffffff8101e397>] smp_call_function_single_interrupt+0x18/0x29
 [<ffffffff814ca77a>] call_function_single_interrupt+0x6a/0x70
 <EOI>  [<ffffffff8106c7d4>] ? sched_clock_cpu+0x42/0xc7
 [<ffffffff813dd3bb>] ? cpuidle_enter_state+0x52/0xa3
 [<ffffffff813dd3b4>] ? cpuidle_enter_state+0x4b/0xa3
 [<ffffffff813dd4f1>] cpuidle_idle_call+0xe5/0x13f
 [<ffffffff810093ee>] arch_cpu_idle+0xe/0x1d
 [<ffffffff8107ef86>] cpu_startup_entry+0x128/0x17a
 [<ffffffff814b0c4b>] start_secondary+0x246/0x248
---[ end trace 6259476cbb715a4d ]---

CPU#6: ctrl:       0000000000000000
CPU#6: status:     0000000000000008
CPU#6: overflow:   0000000000000000
CPU#6: fixed:      00000000000000bb
CPU#6: pebs:       0000000000000000
CPU#6: active:     0000000300000003
CPU#6:   gen-PMC0 ctrl:  0000000000530151
CPU#6:   gen-PMC0 count: 0000ffff8154731e
CPU#6:   gen-PMC0 left:  000000007eab8d8a
CPU#6:   gen-PMC1 ctrl:  00000000005301b7
CPU#6:   gen-PMC1 count: 0000ffff800ac9b4
CPU#6:   gen-PMC1 left:  000000007ff53654
CPU#6:   gen-PMC2 ctrl:  0000000000000000
CPU#6:   gen-PMC2 count: 0000000000000000
CPU#6:   gen-PMC2 left:  000000006adea321
CPU#6:   gen-PMC3 ctrl:  000000000013003c
CPU#6:   gen-PMC3 count: 0000000000000000
CPU#6:   gen-PMC3 left:  0000000000008d7e
CPU#6: fixed-PMC0 count: 0000ffffdf0acb67
CPU#6: fixed-PMC1 count: 0000ffffc2f1a0bd
CPU#6: fixed-PMC2 count: 0000000000000000
perf_event_intel: clearing PMU state on CPU#6


Cheers,
Vinson
