Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3CMNeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:34:46 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:62084 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3CMNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:34:45 -0400
Date: Wed, 13 Mar 2013 14:34:31 +0100
From: Rolf Offermanns <rolf.offermanns@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: OOPS with 3.9.0rc2+
Message-ID: <20130313133430.GA3841@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get a kernel oops / panic with a 3.9.0rc2+ kernel (git from 2h ago) on my Sony
Vaio laptop. It happened with rc1, too.

Unfortunately I only have a screen photo as nothing gets written to the system
log.

Here is a transcript:
---------[cut here]------------
WARNING: at linux-2.6/drivers/gpu/drm/drm.crtc.c:84 drm_warn_on_modeset_not_all_locked+0x80/0x90 [drm]()
Hardware name: VPCF23A9E
Modules linked in: [...]
Pid: 1894, comm: plasma-desktop Tainted: G       D W      3.9.0-rc2+ #1
Call Trace:
 <IRQ>   warn_slowpath_common+0x7f/0xc0
 warn_slowpath_null+0x1a/020
 drm_warn_on_modeset_not_all_locked+0x80/0x90 [drm]
 drm_fb_helper_restore_fbdev_mode+0x1c/0x80 [drm_kms_helper]
 drm_fb_helper_force_kernel_mode+0x4d/0xa0 [drm_kms_helper]
 drm_fb_helper_panic+0x2b/0x30 [drm_kms_helper]
 notifier_call_chain+0x4d/0x70
 __atomic_notifier_call_chain+0x12/0x20
 atomic_notifier_call_chain+0x16/0x20
 panic+0xef/0x1d0
 oops_end+0xe2/0xf0
 die+0x58/0x90
 do_trap+0x6b/0170
 ? __atomic_notifier_call_chain+0x12/0x20
 do_divide_error+0x96/0xa0
 ? intel_pstate_timer_func+0x15d/0x380
 ? check_preempt_curr+0x75/0xa0
 ? ttwu_do_wakeup+0x2c/0xf0
 divide_error+0x1e/0x30
 ? intel_pstate_timer_func+0x15d/0x380
 ? intel_pstate_timer_func+0xbc/0x380
 ? pid_param_set+0x120/0x120
 call_timer_fn+0x3a/0x120
 ? pid_param_set+0x120/0x120
 run_timer_softirq+0x1fe/0x2b0
 __do_softirq+0xe0/0x230
 irq_exit+0xa5/0xb0
 smp_apic_timer_interrupt+0x6e/0x99
 apic_timer_interrupt+0x6d/0x80
 <EOI> ? sysret_audit+0x17/0x21
 -----[ end trace .... ]------
 NOHZ: local_softirq_pending 282


 Is this of any use at all? How can I help track this down? Shall I attach a
 serial console (USB only)?

lspci:

00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b4)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b4)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b4)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b4)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 04)
01:00.0 VGA compatible controller: NVIDIA Corporation GF108 [GeForce GT 540M] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio Controller (rev a1)
02:00.0 Network controller: Atheros Communications Inc. AR9485 Wireless Network Adapter (rev 01)
03:00.0 SD Host controller: Ricoh Co Ltd PCIe SDXC/MMC Host Controller (rev 09) 03:00.1 System peripheral: Ricoh Co Ltd Device e232 (rev 06)
03:00.3 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 PCIe IEEE 1394 Controller (rev 05)
04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 06)


cpuinfo:
processor       : 0-7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2670QM CPU @ 2.20GHz
stepping        : 7
microcode       : 0x28
cpu MHz         : 800.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16
xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx
lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
vpid
bogomips        : 4390.18
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


-Rolf
