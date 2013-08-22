Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3HVCzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:55:11 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:35000 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3HVCzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:55:08 -0400
Message-ID: <52157D88.3070701@gmail.com>
Date: Thu, 22 Aug 2013 04:55:04 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-pm@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:667
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The miracle is that anyone ever manages to read this from a bunch of
other posts.


Waking up from system sleep state S3:

PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
PM: Entering mem sleep
PM: suspend of devices complete after 2720.791 msecs
PM: suspend devices took 2.725 seconds
PM: late suspend of devices complete after 3.898 msecs
PM: noirq suspend of devices complete after 88.109 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
smpboot: CPU 2 is now offline
smpboot: CPU 3 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
PCI-DMA: Resuming GART IOMMU
PCI-DMA: Restoring GART aperture settings
microcode: CPU0: new patch_level=0x010000c8
Enabling non-boot CPUs ...
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node 0 Processor 1 APIC 0x1
[Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #1
process: Switch to broadcast mode on CPU1
microcode: CPU1: new patch_level=0x010000c8
CPU1 is up
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node 0 Processor 2 APIC 0x2
[Firmware Bug]: cpu 2, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #2
process: Switch to broadcast mode on CPU2
------------[ cut here ]------------
WARNING: CPU: 2 PID: 0 at kernel/time/tick-broadcast.c:667
tick_broadcast_oneshot_control+0x181/0x190()
Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast
ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat
iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables kvm_amd
kvm snd_hda_codec_realtek skge r8169 edac_core edac_mce_amd k10temp
snd_hda_intel snd_hda_codec microcode serio_raw mii snd_hwdep snd_seq
snd_seq_device snd_pcm snd_page_alloc snd_timer snd soundcore shpchp
i2c_nforce2 acpi_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc
nouveau mxm_wmi video i2c_algo_bit drm_kms_helper ttm drm i2c_core
ata_generic pata_acpi pata_amd wmi
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.11.0-0.rc6.git1.2.fc20.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. M720-US3/M720-US3, BIOS F7n
09/07/2010
 0000000000000009 ffff880118517df0 ffffffff81723666 0000000000000000
 ffff880118517e28 ffffffff8107463d 0000000000000002 0000000000000004
 ffff88011aa0dec0 0000000000000096 ffffffff81c26d80 ffff880118517e38
Call Trace:
 [<ffffffff81723666>] dump_stack+0x54/0x74
 [<ffffffff8107463d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8107471a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810e0ab1>] tick_broadcast_oneshot_control+0x181/0x190
 [<ffffffff810df5c8>] clockevents_notify+0x178/0x1a0
 [<ffffffff810229f8>] amd_e400_idle+0x78/0x110
 [<ffffffff8102329e>] arch_cpu_idle+0x2e/0x40
 [<ffffffff810d66e2>] cpu_startup_entry+0xd2/0x410
 [<ffffffff81047f1f>] start_secondary+0x22f/0x2e0
---[ end trace 213708ad48d5b2e3 ]---
microcode: CPU2: new patch_level=0x010000c8
CPU2 is up
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node 0 Processor 3 APIC 0x3
[Firmware Bug]: cpu 3, try to use APIC500 (LVT offset 0) for vector
0x400, but the register is already in use for vector 0xf9 on another cpu
perf: IBS APIC setup failed on cpu #3
process: Switch to broadcast mode on CPU3
microcode: CPU3: new patch_level=0x010000c8
CPU3 is up
ACPI: Waking up from system sleep state S3
PM: noirq resume of devices complete after 206.430 msecs
PM: early resume of devices complete after 0.973 msecs
PM: resume of devices complete after 7049.893 msecs
PM: resume devices took 7.054 seconds
PM: Finishing wakeup.


Waking up from system sleep state S4:

PM: Hibernation mode set to 'platform'
PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
PM: Marking nosave pages: [mem 0xdfef0000-0xffffffff]
PM: Marking nosave pages: [mem 0xd4000000-0xd7ffffff]
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
PM: Preallocating image memory... done (allocated 118863 pages)
PM: Allocated 475452 kbytes in 0.32 seconds (1485.78 MB/s)
PM: freeze of devices complete after 2244.968 msecs
PM: late freeze of devices complete after 3.680 msecs
PM: noirq freeze of devices complete after 2.578 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
smpboot: CPU 2 is now offline
smpboot: CPU 3 is now offline
PM: Creating hibernation image:
PM: Need to copy 118824 pages
PM: Normal pages needed: 118824 + 1024, available pages: 912915
PM: Restoring platform NVS memory
microcode: CPU0: new patch_level=0x010000c8
Enabling non-boot CPUs ...
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node 0 Processor 1 APIC 0x1
LVT offset 1 assigned for vector 0x400
process: Switch to broadcast mode on CPU1
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:667
tick_broadcast_oneshot_control+0x181/0x190()
Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast
ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat
iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables kvm_amd
kvm snd_hda_codec_realtek snd_hda_intel microcode edac_core edac_mce_amd
snd_hda_codec k10temp r8169 serio_raw snd_hwdep mii skge snd_seq
snd_seq_device snd_pcm snd_page_alloc snd_timer snd i2c_nforce2 shpchp
soundcore acpi_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc
nouveau mxm_wmi video i2c_algo_bit drm_kms_helper ttm ata_generic drm
pata_acpi i2c_core pata_amd wmi
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-0.rc6.git1.2.fc20.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. M720-US3/M720-US3, BIOS F7n
09/07/2010
 0000000000000009 ffff880118515df0 ffffffff81723666 0000000000000000
 ffff880118515e28 ffffffff8107463d 0000000000000001 0000000000000004
 ffff88011a80dec0 0000000000000096 ffffffff81c26d80 ffff880118515e38
Call Trace:
 [<ffffffff81723666>] dump_stack+0x54/0x74
 [<ffffffff8107463d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8107471a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810e0ab1>] tick_broadcast_oneshot_control+0x181/0x190
 [<ffffffff810df5c8>] clockevents_notify+0x178/0x1a0
 [<ffffffff810229f8>] amd_e400_idle+0x78/0x110
 [<ffffffff8102329e>] arch_cpu_idle+0x2e/0x40
 [<ffffffff810d66e2>] cpu_startup_entry+0xd2/0x410
 [<ffffffff81047f1f>] start_secondary+0x22f/0x2e0
---[ end trace 75625b90d4157f98 ]---
microcode: CPU1: new patch_level=0x010000c8
CPU1 is up
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node 0 Processor 2 APIC 0x2
process: Switch to broadcast mode on CPU2
microcode: CPU2: new patch_level=0x010000c8
CPU2 is up
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node 0 Processor 3 APIC 0x3
process: Switch to broadcast mode on CPU3
microcode: CPU3: new patch_level=0x010000c8
CPU3 is up
ACPI: Waking up from system sleep state S4
PM: noirq restore of devices complete after 15.654 msecs
PM: early restore of devices complete after 1.392 msecs
PM: restore of devices complete after 373.136 msecs
PM: Image restored successfully.
PM: Basic memory bitmaps freed


poma


