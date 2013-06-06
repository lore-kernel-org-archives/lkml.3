Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3FFBff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:35:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:41176 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab3FFBf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,810,1363158000"; 
   d="log'?scan'208";a="345520231"
Date: Thu, 6 Jun 2013 09:35:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [vt_console_print/cirrus_dirty_update] WARNING: at
 kernel/mutex.c:858 mutex_trylock()
Message-ID: <20130606013518.GA9092@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 3d71c6ed43d838e593538176a9a59debe228cfb0
Author: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date:   Tue Apr 2 12:33:01 2013 +0200

    drm/ttm: convert to the reservation api
    
    Now that the code is compatible in semantics, flip the switch.
    Use ww_mutex instead of the homegrown implementation.
    
    Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

[   13.044298] printing local APIC contents on CPU#0/0:
[   13.044313] ------------[ cut here ]------------
[   13.044367] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:858 mutex_trylock+0x87/0x220()
[   13.044378] DEBUG_LOCKS_WARN_ON(in_interrupt())
[   13.044378] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc4-00296-ga2963dd #20
[   13.044379] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   13.044390]  0000000000000009 ffff88000de039f8 ffffffff81fc86d5 ffff88000de03a38
[   13.044395]  ffffffff810d511b ffff880000000018 ffff88000f33c690 0000000000000001
[   13.044398]  00000000000003f0 ffff88000f4677c8 0000000000000000 ffff88000de03a98
[   13.044400] Call Trace:
[   13.044412]  <IRQ>  [<ffffffff81fc86d5>] dump_stack+0x19/0x1b
[   13.044441]  [<ffffffff810d511b>] warn_slowpath_common+0x6b/0x90
[   13.044445]  [<ffffffff810d51a6>] warn_slowpath_fmt+0x46/0x50
[   13.044448]  [<ffffffff81fd34d7>] mutex_trylock+0x87/0x220
[   13.044482]  [<ffffffff8186484d>] cirrus_dirty_update+0x1cd/0x330
[   13.044486]  [<ffffffff818649e8>] cirrus_imageblit+0x38/0x50
[   13.044506]  [<ffffffff8165782e>] soft_cursor+0x22e/0x240
[   13.044510]  [<ffffffff81656c31>] bit_cursor+0x581/0x5b0
[   13.044525]  [<ffffffff815de9f4>] ? vsnprintf+0x124/0x670
[   13.044529]  [<ffffffff81651333>] ? get_color.isra.16+0x43/0x130
[   13.044532]  [<ffffffff81653fca>] fbcon_cursor+0x18a/0x1d0
[   13.044535]  [<ffffffff816566b0>] ? update_attr.isra.2+0xa0/0xa0
[   13.044556]  [<ffffffff81754b82>] hide_cursor+0x32/0xa0
[   13.044565]  [<ffffffff81755bd3>] vt_console_print+0x103/0x3b0
[   13.044569]  [<ffffffff810d58ac>] ? print_time+0x9c/0xb0
[   13.044576]  [<ffffffff810d5960>] ? print_prefix+0xa0/0xc0
[   13.044580]  [<ffffffff810d63f6>] call_console_drivers.constprop.6+0x146/0x1f0
[   13.044593]  [<ffffffff815f9b38>] ? do_raw_spin_unlock+0xc8/0x100
[   13.044597]  [<ffffffff810d6f27>] console_unlock+0x2f7/0x460
[   13.044600]  [<ffffffff810d787a>] vprintk_emit+0x59a/0x5e0
[   13.044615]  [<ffffffff81fb676c>] printk+0x4d/0x4f
[   13.044650]  [<ffffffff82ba5511>] print_local_APIC+0x28/0x41c
[   13.044672]  [<ffffffff8114db55>] generic_smp_call_function_single_interrupt+0x145/0x2b0
[   13.044688]  [<ffffffff8106f9e7>] smp_call_function_single_interrupt+0x27/0x40
[   13.044697]  [<ffffffff81fd8f72>] call_function_single_interrupt+0x72/0x80
[   13.044707]  <EOI>  [<ffffffff81078166>] ? native_safe_halt+0x6/0x10
[   13.044717]  [<ffffffff811425cd>] ? trace_hardirqs_on+0xd/0x10
[   13.044738]  [<ffffffff8104f669>] default_idle+0x59/0x120
[   13.044742]  [<ffffffff810501e8>] arch_cpu_idle+0x18/0x40
[   13.044754]  [<ffffffff811320c5>] cpu_startup_entry+0x235/0x410
[   13.044763]  [<ffffffff81f9e781>] rest_init+0xd1/0xe0
[   13.044766]  [<ffffffff81f9e6b5>] ? rest_init+0x5/0xe0
[   13.044778]  [<ffffffff82b93ec2>] start_kernel+0x425/0x493
[   13.044781]  [<ffffffff82b93810>] ? repair_env_string+0x5e/0x5e
[   13.044786]  [<ffffffff82b93595>] x86_64_start_reservations+0x2a/0x2c
[   13.044789]  [<ffffffff82b93688>] x86_64_start_kernel+0xf1/0x100
[   13.044799] ---[ end trace 113ad28772af4058 ]---

git bisect start a2963dd6085970cbf5e09ab67fd57b2cb396f3b9 v3.9 --
git bisect good 73287a43cc79ca06629a88d1a199cd283f42456a  #    10  2013-06-05 22:52:59  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good 2e378f3eebd28feefbb1f9953834a5a19482f053  #    10  2013-06-05 23:11:57  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect good a1f0bcccffe508b36f8eb0bd39771d4bedc683a8  #    10  2013-06-05 23:23:44  Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze
git bisect good 72dd4e7980bf584fa11db4f00e38d5cf956a8856  #    10  2013-06-06 00:45:04  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good 279838960484fa22d903086eea743a6b6700647d  #    10  2013-06-06 00:55:21  powerpc/pci: Remove the stale comments of pci_process_bridge_OF_ranges
git bisect good a1f2cc73c762868435ae6ec9126bb2240337c61c  #    10  2013-06-06 01:20:30  drm/i915: add I915_PARAM_HAS_VEBOX to i915_getparam
git bisect good 6cf3c736200e3924d8ce6b37e5006a4598b9236d  #    10  2013-06-06 02:33:37  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 0e32fde96bb9c1fa8fa477e52c1d6ae2f4995cea  #    10  2013-06-06 04:09:34  Merge branch 'drm-nouveau-fixes-3.10' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
git bisect good d7fe0cc0f2e0b302b247caa4306915a06218e0be  #    10  2013-06-06 04:18:24  drm/i915: Fix DSPCLK_GATE_D for VLV
git bisect good f0e07e4668afdea1755a1e28a9649261afe980b3  #    10  2013-06-06 04:28:12  drm/nouveau: make flipping lockdep safe
git bisect good 979c3c0bdb21017cc6e00d20349f0ee0347dd5a7  #    10  2013-06-06 05:36:07  Merge remote-tracking branch 'drm-exynos/exynos-drm-next' into devel-cairo-x86_64-201306051657
git bisect  bad 37fbcd59bdc8c309bc98957ff51021bbdff45606  #     0  2013-06-06 05:41:47  drm/mgag200: inline reservations
git bisect  bad 1e9e9d11aa358123dd721dba5075e23c03b49957  #     0  2013-06-06 05:51:10  drm/ast: inline reservations
git bisect  bad 3d71c6ed43d838e593538176a9a59debe228cfb0  #     0  2013-06-06 05:57:39  drm/ttm: convert to the reservation api
git bisect good f0e07e4668afdea1755a1e28a9649261afe980b3  #    30  2013-06-06 07:16:11  drm/nouveau: make flipping lockdep safe
git bisect  bad a2963dd6085970cbf5e09ab67fd57b2cb396f3b9  #     0  2013-06-06 07:16:15  Merge remote-tracking branch 'mlankhorst/for-airlied' into devel-cairo-x86_64-201306051657
git bisect good f8f126f22a32f2f2b3b61bd5b8a3d51a2cac09ec  #    30  2013-06-06 07:19:56  Add linux-next specific files for 20130605

Thanks,
Fengguang

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-cairo-2888-20130605173903-3.10.0-rc4-00296-ga2963dd-20"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc4-00296-ga2963dd (kbuild@cairo) (gcc version 4.7.2 (Debian 4.7.2-4) ) #20 SMP Wed Jun 5 17:34:47 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c00-0605/devel-cairo-x86_64-201306051657/.vmlinuz-a2963dd6085970cbf5e09ab67fd57b2cb396f3b9-20130605173602-5-cairo branch=linux-devel/devel-cairo-x86_64-201306051657  BOOT_IMAGE=/kernel/x86_64-randconfig-c00-0605/a2963dd6085970cbf5e09ab67fd57b2cb396f3b9/vmlinuz-3.10.0-rc4-00296-ga2963dd
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x036cf000, 0x036cffff] PGTABLE
[    0.000000] BRK [0x036d0000, 0x036d0fff] PGTABLE
[    0.000000] BRK [0x036d1000, 0x036d1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x036d2000, 0x036d2fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127292(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88000de00000 s82048 r0 d24448 u1048576
[    0.000000] pcpu-alloc: s82048 r0 d24448 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0cf80
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c00-0605/devel-cairo-x86_64-201306051657/.vmlinuz-a2963dd6085970cbf5e09ab67fd57b2cb396f3b9-20130605173602-5-cairo branch=linux-devel/devel-cairo-x86_64-201306051657  BOOT_IMAGE=/kernel/x86_64-randconfig-c00-0605/a2963dd6085970cbf5e09ab67fd57b2cb396f3b9/vmlinuz-3.10.0-rc4-00296-ga2963dd
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 184704k/262136k available (16245k kernel code, 440k absent, 76992k reserved, 11898k data, 1168k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]             using two ww contexts:  ok  |
[    0.000000]           finish ww context twice:  ok  |
[    0.000000]                      unlock twice:  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 237 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.002 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5786.00 BogoMIPS (lpj=11572008)
[    0.012016] pid_max: default: 32768 minimum: 301
[    0.016584] Mount-cache hash table entries: 256
[    0.022018] Initializing cgroup subsys memory
[    0.024221] Initializing cgroup subsys net_cls
[    0.028032] Initializing cgroup subsys perf_event
[    0.032066] Initializing cgroup subsys net_prio
[    0.036399] mce: CPU supports 10 MCE banks
[    0.038334] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038334] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.038334] tlb_flushall_shift: 6
[    0.044212] Freeing SMP alternatives: 36k freed
[    0.060033] ACPI: Core revision 20130328
[    0.109406] ACPI: All ACPI Tables successfully acquired
[    0.117241] Getting VERSION: 50014
[    0.118828] Getting VERSION: 50014
[    0.120031] Getting ID: 0
[    0.121392] Getting ID: ff000000
[    0.124045] Getting LVT0: 8700
[    0.125655] Getting LVT1: 8400
[    0.128110] enabled ExtINT on CPU#0
[    0.136585] ENABLING IO-APIC IRQs
[    0.138240] init IO_APIC IRQs
[    0.139690]  apic 2 pin 0 not connected
[    0.140000] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.140090] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.144096] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.148095] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.152078] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.156092] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.160096] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.164109] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.168086] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.172092] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.176088] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.180056] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.183302] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.184066] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.188096] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.192045]  apic 2 pin 16 not connected
[    0.196023]  apic 2 pin 17 not connected
[    0.197673]  apic 2 pin 18 not connected
[    0.200013]  apic 2 pin 19 not connected
[    0.204028]  apic 2 pin 20 not connected
[    0.208007]  apic 2 pin 21 not connected
[    0.209631]  apic 2 pin 22 not connected
[    0.212017]  apic 2 pin 23 not connected
[    0.213984] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.216024] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.220019] Using local APIC timer interrupts.
[    0.220019] calibrating APIC timer ...
[    0.228000] ... lapic delta = 7500737
[    0.228000] ... PM-Timer delta = 429593
[    0.228000] APIC calibration not consistent with PM-Timer: 120ms instead of 100ms
[    0.228000] APIC delta adjusted to PM-Timer: 6249912 (7500737)
[    0.228000] TSC delta adjusted to PM-Timer: 289303848 (347203574)
[    0.228000] ..... delta 6249912
[    0.228000] ..... mult: 268431676
[    0.228000] ..... calibration result: 3999943
[    0.228000] ..... CPU clock speed is 2893.0153 MHz.
[    0.228000] ..... host bus clock speed is 999.3943 MHz.
[    0.228153] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.240553] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.248197] SMP alternatives: lockdep: fixing up alternatives
[    0.252054] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.296192] Brought up 2 CPUs
[    0.296117] KVM setup async PF for cpu 1
[    0.296117] kvm-stealtime: cpu 1, msr df0cf80
[    0.300024] smpboot: Total of 2 processors activated (11572.00 BogoMIPS)
[    0.308730] CPU0 attaching sched-domain:
[    0.310739]  domain 0: span 0-1 level CPU
[    0.313136]   groups: 0 (cpu_power = 1023) 1
[    0.316811] CPU1 attaching sched-domain:
[    0.318809]  domain 0: span 0-1 level CPU
[    0.321082]   groups: 1 0 (cpu_power = 1023)
[    0.357762] xor: measuring software checksum speed
[    0.400024]    prefetch64-sse:  9481.000 MB/sec
[    0.440019]    generic_sse:  9084.000 MB/sec
[    0.441972] xor: using function: prefetch64-sse (9481.000 MB/sec)
[    0.445225] regulator-dummy: no parameters
[    0.448975] RTC time:  9:37:28, date: 06/05/13
[    0.452680] NET: Registered protocol family 16
[    0.457889] ACPI: bus type PCI registered
[    0.460016] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.464345] PCI: Using configuration type 1 for base access
[    0.558182] bio: create slab <bio-0> at 0
[    0.632023] raid6: sse2x1    3870 MB/s
[    0.700025] raid6: sse2x2    6153 MB/s
[    0.768029] raid6: sse2x4    6089 MB/s
[    0.769840] raid6: using algorithm sse2x2 (6153 MB/s)
[    0.772019] raid6: using intx1 recovery algorithm
[    0.780111] ACPI: Added _OSI(Module Device)
[    0.784023] ACPI: Added _OSI(Processor Device)
[    0.788037] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.792028] ACPI: Added _OSI(Processor Aggregator Device)
[    0.798488] ACPI: EC: Look up EC in DSDT
[    0.905887] ACPI: Interpreter enabled
[    0.908147] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.914235] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.920066] ACPI: (supports S0 S3 S5)
[    0.922309] ACPI: Using IOAPIC for interrupt routing
[    0.924287] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.107985] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.108363] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.112022] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.116033] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.120032] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    1.124062] PCI: root bus 00: using default resources
[    1.141949] acpiphp: Slot [3] registered
[    1.144611] acpiphp: Slot [4] registered
[    1.148508] acpiphp: Slot [5] registered
[    1.152209] acpiphp: Slot [6] registered
[    1.156507] acpiphp: Slot [7] registered
[    1.164432] acpiphp: Slot [8] registered
[    1.167038] acpiphp: Slot [9] registered
[    1.168504] acpiphp: Slot [10] registered
[    1.170779] acpiphp: Slot [11] registered
[    1.172454] acpiphp: Slot [12] registered
[    1.176493] acpiphp: Slot [13] registered
[    1.178981] acpiphp: Slot [14] registered
[    1.181563] acpiphp: Slot [15] registered
[    1.188153] acpiphp: Slot [16] registered
[    1.192561] acpiphp: Slot [17] registered
[    1.196356] acpiphp: Slot [18] registered
[    1.198607] acpiphp: Slot [19] registered
[    1.200410] acpiphp: Slot [20] registered
[    1.204450] acpiphp: Slot [21] registered
[    1.206759] acpiphp: Slot [22] registered
[    1.208423] acpiphp: Slot [23] registered
[    1.210774] acpiphp: Slot [24] registered
[    1.212465] acpiphp: Slot [25] registered
[    1.216400] acpiphp: Slot [26] registered
[    1.219526] acpiphp: Slot [27] registered
[    1.220432] acpiphp: Slot [28] registered
[    1.224477] acpiphp: Slot [29] registered
[    1.228474] acpiphp: Slot [30] registered
[    1.230774] acpiphp: Slot [31] registered
[    1.232077] PCI host bridge to bus 0000:00
[    1.234108] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.236036] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.240031] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    1.244144] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.251348] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.253688] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.261217] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    1.267486] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.269603] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    1.272294] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    1.277088] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.284737] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.289816] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    1.302062] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    1.312937] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    1.317414] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    1.320461] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    1.328022] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    1.333048] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    1.336965] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    1.340448] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    1.348021] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    1.352474] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.356068] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    1.360020] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    1.369402] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.373048] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    1.376460] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    1.389466] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.393183] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.396988] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    1.409303] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.413129] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    1.417203] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    1.428613] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.432024] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    1.435585] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    1.447300] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.449082] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    1.452948] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    1.461443] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.464577] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    1.474058] pci_bus 0000:00: on NUMA node 0
[    1.476110] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    1.480024] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    1.494134] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.500487] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.509587] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.515570] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.528088] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.533885] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.536046] acpi root: \_SB_.PCI0 notify handler is installed
[    1.544184] Found 1 acpi root devices
[    1.553762] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.556021] vgaarb: loaded
[    1.557123] vgaarb: bridge control possible 0000:00:02.0
[    1.568166] tps65010: version 2 May 2005
[    1.600270] tps65010: no chip?
[    1.605067] SCSI subsystem initialized
[    1.607047] ACPI: bus type ATA registered
[    1.608346] libata version 3.00 loaded.
[    1.616034] Linux video capture interface: v2.00
[    1.620225] pps_core: LinuxPPS API ver. 1 registered
[    1.622357] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.628078] PTP clock support registered
[    1.640484] wmi: Mapper loaded
[    1.652587] Advanced Linux Sound Architecture Driver Initialized.
[    1.656287] PCI: Using ACPI for IRQ routing
[    1.658180] PCI: pci_cache_line_size set to 64 bytes
[    1.660525] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.664062] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.672539] Bluetooth: Core ver 2.16
[    1.674454] NET: Registered protocol family 31
[    1.676070] Bluetooth: HCI device and connection manager initialized
[    1.680121] Bluetooth: HCI socket layer initialized
[    1.684040] Bluetooth: L2CAP socket layer initialized
[    1.686194] Bluetooth: SCO socket layer initialized
[    1.689350] nfc: nfc_init: NFC Core ver 0.1
[    1.691438] NET: Registered protocol family 39
[    1.692911] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.700454] Switching to clocksource kvm-clock
[    1.703488] Warning: could not register annotated branches stats
[    1.988482] FS-Cache: Loaded
[    1.991155] pnp: PnP ACPI init
[    1.994377] ACPI: bus type PNP registered
[    1.997285] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.001506] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.008495] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    2.013048] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.019869] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    2.033654] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.045359] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    2.057085] pnp 00:03: [dma 2]
[    2.058957] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.072469] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    2.084585] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.093090] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.104686] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.113921] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.125421] pnp: PnP ACPI: found 7 devices
[    2.127281] ACPI: bus type PNP unregistered
[    2.156818] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.159203] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    2.166654] NET: Registered protocol family 1
[    2.168983] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.171453] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.176281] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.178832] pci 0000:00:02.0: Boot video device
[    2.186306] PCI: CLS 0 bytes, default 64
[    2.189079] Unpacking initramfs...
[    4.631593] Freeing initrd memory: 23656k freed
[    4.649934] kvm: no hardware support
[    4.654565] Machine check injector initialized
[    4.658117] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    4.660827] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
[    4.663554] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.693534] cryptomgr_test (28) used greatest stack depth: 6416 bytes left
[    4.696945] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    4.701626] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    4.715431] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    4.720076] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.722561] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.727850] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.730434] AVX or AES-NI instructions are not detected.
[    4.733094] AVX instructions are not detected.
[    4.737035] AVX instructions are not detected.
[    4.738946] AVX instructions are not detected.
[    4.741157] AVX2 instructions are not detected.
[    4.743513] AVX2 or AES-NI instructions are not detected.
[    4.746049] AVX2 instructions are not detected.
[    4.753699] audit: initializing netlink socket (disabled)
[    4.756665] type=2000 audit(1370425051.756:1): initialized
[    4.759304] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    4.841887] VFS: Disk quotas dquot_6.5.2
[    4.844308] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.854734] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    4.864751] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.869743] QNX4 filesystem 0.2.3 registered.
[    4.871816] fuse init (API version 7.22)
[    4.879958] JFS: nTxBlock = 1628, nTxLock = 13024
[    4.888105] SGI XFS with security attributes, large block/inode numbers, debug enabled
[    4.925311] NILFS version 2 loaded
[    4.927025] BeFS version: 0.9.3
[    4.933749] bio: create slab <bio-1> at 1
[    4.954575] Running btrfs free space cache tests
[    4.956839] Running extent only tests
[    4.958699] Running bitmap only tests
[    4.960760] Running bitmap and extent tests
[    4.962864] Free space cache tests finished
[    4.968426] Btrfs loaded
[    5.054104] NET: Registered protocol family 38
[    5.060687] async_tx: api initialized (async)
[    5.063164] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    5.071510] io scheduler noop registered
[    5.073382] io scheduler deadline registered (default)
[    5.083165] list_sort_test: start testing list_sort()
[    5.094985] test_string_helpers: Running tests...
[    5.099416] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.106000] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    5.109262] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    5.115686] cpcihp_generic: not configured, disabling.
[    5.118147] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.121992] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    5.124193] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    5.131535] rivafb_setup START
[    5.133987] vmlfb: initializing
[    5.136093] hgafb: HGA card not detected.
[    5.137959] hgafb: probe of hgafb.0 failed with error -22
[    5.142223] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.145839] ACPI: Power Button [PWRF]
[    5.197227] ERST DBG: ERST support is disabled.
[    5.297477] HDLC line discipline maxframe=4096
[    5.299591] N_HDLC line discipline registered.
[    5.306241] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.371103] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.386529] Cyclades driver 2.6
[    5.394413] MOXA Intellio family driver version 6.0k
[    5.401125] MOXA Smartio/Industio family driver version 2.0.5
[    5.403534] Initializing Nozomi driver 2.1d
[    5.409769] SyncLink GT
[    5.411173] SyncLink GT, tty major#245
[    5.417729] SyncLink GT no devices found
[    5.419584] SyncLink MultiPort driver $Revision: 4.38 $
[    5.459779] SyncLink MultiPort driver $Revision: 4.38 $, tty major#244
[    5.462648] SyncLink serial driver $Revision: 4.38 $
[    5.546449] SyncLink serial driver $Revision: 4.38 $, tty major#243
[    5.555222] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    5.559568] ac.o: No PCI boards found.
[    5.561325] ac.o: For an ISA board you must supply memory and irq parameters.
[    5.579964] Non-volatile memory driver v1.3
[    5.590640] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    5.592839] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    5.610384] Hangcheck: Using getrawmonotonic().
[    5.612726] [drm] Initialized drm 1.1.0 20060810
[    5.619387] [drm] radeon kernel modesetting enabled.
[    5.634187] [TTM] Zone  kernel: Available graphics memory: 104198 kiB
[    5.637712] [TTM] Initializing pool allocator
[    5.639777] [TTM] Initializing DMA pool allocator
[    5.648679] [drm] fb mappable at 0x0
[    5.650442] [drm] vram aper at 0x0
[    5.653006] [drm] size 0
[    5.662517] [drm] fb depth is 24
[    5.664054] [drm]    pitch is 3840
[    5.672446] fbcon: cirrusdrmfb (fb0) is primary device
[    5.772153] Console: switching to colour frame buffer device 160x64
[    5.802238] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    5.804590] cirrus 0000:00:02.0: registered panic notifier
[    5.806446] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
[    5.811048] dummy-irq: no IRQ given.  Use irq=N
[    5.813697] lkdtm: No crash points registered, enable through debugfs
[    5.817103] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    5.820255] Guest personality initialized and is inactive
[    5.822409] VMCI host device registered (name=vmci, major=10, minor=60)
[    5.824588] Initialized host personality
[    5.827121] Driver for timberdale has been successfully registered.
[    5.830226] Uniform Multi-Platform E-IDE driver
[    5.831893] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.835679] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    5.838197] pci 0000:00:01.1: setting latency timer to 64
[    5.839918]     ide0: BM-DMA at 0xc1e0-0xc1e7
[    5.843597]     ide1: BM-DMA at 0xc1e8-0xc1ef
[    5.845090] Probing IDE interface ide0...
[    5.858271] tsc: Refined TSC clocksource calibration: 2893.028 MHz
[    6.422436] Probing IDE interface ide1...
[    7.160294] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.848498] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.850674] hdc: MWDMA2 mode selected
[    7.852355] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.854088] ide1 at 0x170-0x177,0x376 on irq 15
[    7.861191] ide-gd driver 1.18
[    7.862550] ide-cd driver 5.00
[    7.871016] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    7.888522] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.911213] rdac: device handler registered
[    7.928292] emc: device handler registered
[    7.929697] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    7.931939] osst :I: Tape driver with OnStream support version 0.99.4
[    7.931939] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    7.941196] SCSI Media Changer driver v0.25 
[    7.950172] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    7.988604] HSI/SSI char device loaded
[    7.989871] slcan: serial line CAN interface driver
[    7.991361] slcan: 10 dynamic interface channels.
[    8.011633] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.035065] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.048847] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.058148] parkbd: no such parport
[    8.301998] mousedev: PS/2 mouse device common for all mice
[    8.317237] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    8.330465] walkera0701: parport 0 does not exist
[    8.342097] I2O subsystem v1.325
[    8.357370] i2o: max drivers = 8
[    8.396228] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    8.406498] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    8.452677] I2O Configuration OSM v1.323
[    8.473689] I2O Bus Adapter OSM v1.317
[    8.478402] I2O SCSI Peripheral OSM v1.316
[    8.495460] I2O ProcFS OSM v1.316
[    8.506012] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    8.622192] i2c-parport-light: adapter type unspecified
[    8.630331] saa7146: register extension 'Multimedia eXtension Board'
[    8.638135] saa7146: register extension 'hexium gemini'
[    8.643911] Zoran MJPEG board driver version 0.10.1
[    8.654243] Linux video codec intermediate layer: v0.2
[    8.664356] cx25821: driver version 0.0.106 loaded
[    8.678040] pps pps0: new PPS source ktimer
[    8.684084] pps pps0: ktimer PPS source registered
[    8.703536] pps_ldisc: PPS line discipline registered
[    8.712492] Driver for 1-wire Dallas network protocol.
[    8.737013] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.888241] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    8.917062] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    8.944194] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    8.987540] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    9.013060] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.032142] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.057228] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.082088] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.105141] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.128818] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.153494] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.179058] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.301046] detect failed, chip not detected!
[    9.340645] detect failed, chip not detected!
[    9.378030] detect failed, chip not detected!
[    9.421052] detect failed, chip not detected!
[    9.458051] detect failed, chip not detected!
[    9.495082] detect failed, chip not detected!
[    9.529060] detect failed, chip not detected!
[    9.575100] detect failed, chip not detected!
[    9.608205] detect failed, chip not detected!
[   10.213200] f71882fg: Not a Fintek device
[   10.220341] f71882fg: Not a Fintek device
[   10.393038]  (null): Unknown chip type, skipping
[   10.418063]  (null): Unknown chip type, skipping
[   11.421071] i2c i2c-0: MAX1619 detection failed at 0x18
[   11.460682] i2c i2c-0: MAX1619 detection failed at 0x19
[   11.504098] i2c i2c-0: MAX1619 detection failed at 0x1a
[   11.543163] i2c i2c-0: MAX1619 detection failed at 0x29
[   11.583031] i2c i2c-0: MAX1619 detection failed at 0x2a
[   11.621747] i2c i2c-0: MAX1619 detection failed at 0x2b
[   11.663172] i2c i2c-0: MAX1619 detection failed at 0x4c
[   11.696205] i2c i2c-0: MAX1619 detection failed at 0x4d
[   11.733218] i2c i2c-0: MAX1619 detection failed at 0x4e
[   11.849002] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[   11.884113] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[   11.903031] i2c i2c-0: amc6821_detect called.
[   11.932322] i2c i2c-0: amc6821: detection failed at 0x18.
[   11.948822] i2c i2c-0: amc6821_detect called.
[   11.983629] i2c i2c-0: amc6821: detection failed at 0x19.
[   12.000803] i2c i2c-0: amc6821_detect called.
[   12.025142] i2c i2c-0: amc6821: detection failed at 0x1a.
[   12.039576] i2c i2c-0: amc6821_detect called.
[   12.059541] i2c i2c-0: amc6821: detection failed at 0x2c.
[   12.072420] i2c i2c-0: amc6821_detect called.
[   12.092125] i2c i2c-0: amc6821: detection failed at 0x2d.
[   12.112465] i2c i2c-0: amc6821_detect called.
[   12.132447] i2c i2c-0: amc6821: detection failed at 0x2e.
[   12.144409] i2c i2c-0: amc6821_detect called.
[   12.164798] i2c i2c-0: amc6821: detection failed at 0x4c.
[   12.176685] i2c i2c-0: amc6821_detect called.
[   12.193584] i2c i2c-0: amc6821: detection failed at 0x4d.
[   12.205726] i2c i2c-0: amc6821_detect called.
[   12.224253] i2c i2c-0: amc6821: detection failed at 0x4e.
[   12.380148] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[   12.384647] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[   12.389471] intel_powerclamp: Intel powerclamp does not run on family 15 model 6
[   12.394431] md: linear personality registered for level -1
[   12.399352] md: raid0 personality registered for level 0
[   12.403621] md: raid10 personality registered for level 10
[   12.411298] md: raid6 personality registered for level 6
[   12.415488] md: raid5 personality registered for level 5
[   12.419663] md: raid4 personality registered for level 4
[   12.424210] md: multipath personality registered for level -4
[   12.428424] md: faulty personality registered for level -5
[   12.445177] device-mapper: uevent: version 1.0.3
[   12.449648] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   12.462212] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   12.466476] Bluetooth: Virtual HCI driver ver 1.3
[   12.471177] Bluetooth: HCI UART driver ver 2.2
[   12.475313] Bluetooth: HCI H4 protocol initialized
[   12.480528] Bluetooth: HCI BCSP protocol initialized
[   12.484766] Bluetooth: HCILL protocol initialized
[   12.489150] Bluetooth: HCIATH3K protocol initialized
[   12.493632] cpuidle: using governor ladder
[   12.498283] cpuidle: using governor menu
[   12.503461] leds_ss4200: no LED devices found
[   12.508960] cs5535-clockevt: Could not allocate MFGPT timer
[   12.513781] hidraw: raw HID events driver (C) Jiri Kosina
[   12.523570] panel: driver version 0.9.5 not yet registered
[   12.532458] Loading crystalhd 0.9.27
[   12.537623] input: Speakup as /devices/virtual/input/input2
[   12.543234] evbug: Connected device: input2 (Speakup at speakup/input0)
[   12.550514] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   12.570123] speakup 3.1.6: initialized
[   12.576070] synth name on entry is: (null)
[   12.585464] ashmem: initialized
[   12.592541] logger: created 256K log 'log_main'
[   12.606970] logger: created 256K log 'log_events'
[   12.613487] logger: created 256K log 'log_radio'
[   12.622047] logger: created 256K log 'log_system'
[   12.628967] asus_wmi: Asus Management GUID not found
[   12.632305] asus_wmi: Management GUID not found
[   12.644938] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
[   12.656241] dell_wmi_aio: No known WMI GUID found
[   12.662131] acer_wmi: Acer Laptop ACPI-WMI Extras
[   12.670129] acer_wmi: No or unsupported WMI interface, unable to load
[   12.678986] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   12.701333] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Bochs, please report, aborting!
[   12.738353] fujitsu_laptop: driver 0.6.0 successfully loaded
[   12.743996] fujitsu_tablet: Unknown (using defaults)
[   12.749461] msi_wmi: This machine doesn't have neither MSI-hotkeys nor backlight through WMI
[   12.756293] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
[   12.770550] no UART detected at 0x1
[   12.783661] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[   12.793084] ASIHPI driver 4.10.01
[   12.815049] pktgen: Packet Generator for packet performance testing. Version: 2.74
[   12.823217] netem: version 1.3
[   12.828840] NET: Registered protocol family 15
[   12.835126] Ebtables v2.0 registered
[   12.856056] NET: Registered protocol family 4
[   12.862696] NET: Registered protocol family 9
[   12.867554] X.25 for Linux Version 0.2
[   12.873068] can: controller area network core (rev 20120528 abi 9)
[   12.880995] NET: Registered protocol family 29
[   12.886773] can: raw protocol (rev 20120528)
[   12.896562] can: netlink gateway (rev 20130117) max_hops=1
[   12.903194] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.908981] Bluetooth: BNEP socket layer initialized
[   12.914819] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   12.921010] Bluetooth: HIDP socket layer initialized
[   12.926744] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   12.934940] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[   12.941485] NET: Registered protocol family 12
[   12.947448] NET: Registered protocol family 35
[   12.954268] 9pnet: Installing 9P2000 support
[   12.961063] NET: Registered protocol family 36
[   12.984376] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility version 14) loaded
[   12.991992] openvswitch: Open vSwitch switching datapath
[   13.002285] 
[   13.002285] printing PIC contents
[   13.016642] ... PIC  IMR: ffff
[   13.020593] ... PIC  IRR: 9013
[   13.032341] ... PIC  ISR: 0000
[   13.038837] ... PIC ELCR: 0c00
[   13.044298] printing local APIC contents on CPU#0/0:
[   13.044313] ------------[ cut here ]------------
[   13.044367] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:858 mutex_trylock+0x87/0x220()
[   13.044378] DEBUG_LOCKS_WARN_ON(in_interrupt())
[   13.044378] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc4-00296-ga2963dd #20
[   13.044379] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   13.044390]  0000000000000009 ffff88000de039f8 ffffffff81fc86d5 ffff88000de03a38
[   13.044395]  ffffffff810d511b ffff880000000018 ffff88000f33c690 0000000000000001
[   13.044398]  00000000000003f0 ffff88000f4677c8 0000000000000000 ffff88000de03a98
[   13.044400] Call Trace:
[   13.044412]  <IRQ>  [<ffffffff81fc86d5>] dump_stack+0x19/0x1b
[   13.044441]  [<ffffffff810d511b>] warn_slowpath_common+0x6b/0x90
[   13.044445]  [<ffffffff810d51a6>] warn_slowpath_fmt+0x46/0x50
[   13.044448]  [<ffffffff81fd34d7>] mutex_trylock+0x87/0x220
[   13.044482]  [<ffffffff8186484d>] cirrus_dirty_update+0x1cd/0x330
[   13.044486]  [<ffffffff818649e8>] cirrus_imageblit+0x38/0x50
[   13.044506]  [<ffffffff8165782e>] soft_cursor+0x22e/0x240
[   13.044510]  [<ffffffff81656c31>] bit_cursor+0x581/0x5b0
[   13.044525]  [<ffffffff815de9f4>] ? vsnprintf+0x124/0x670
[   13.044529]  [<ffffffff81651333>] ? get_color.isra.16+0x43/0x130
[   13.044532]  [<ffffffff81653fca>] fbcon_cursor+0x18a/0x1d0
[   13.044535]  [<ffffffff816566b0>] ? update_attr.isra.2+0xa0/0xa0
[   13.044556]  [<ffffffff81754b82>] hide_cursor+0x32/0xa0
[   13.044565]  [<ffffffff81755bd3>] vt_console_print+0x103/0x3b0
[   13.044569]  [<ffffffff810d58ac>] ? print_time+0x9c/0xb0
[   13.044576]  [<ffffffff810d5960>] ? print_prefix+0xa0/0xc0
[   13.044580]  [<ffffffff810d63f6>] call_console_drivers.constprop.6+0x146/0x1f0
[   13.044593]  [<ffffffff815f9b38>] ? do_raw_spin_unlock+0xc8/0x100
[   13.044597]  [<ffffffff810d6f27>] console_unlock+0x2f7/0x460
[   13.044600]  [<ffffffff810d787a>] vprintk_emit+0x59a/0x5e0
[   13.044615]  [<ffffffff81fb676c>] printk+0x4d/0x4f
[   13.044650]  [<ffffffff82ba5511>] print_local_APIC+0x28/0x41c
[   13.044672]  [<ffffffff8114db55>] generic_smp_call_function_single_interrupt+0x145/0x2b0
[   13.044688]  [<ffffffff8106f9e7>] smp_call_function_single_interrupt+0x27/0x40
[   13.044697]  [<ffffffff81fd8f72>] call_function_single_interrupt+0x72/0x80
[   13.044707]  <EOI>  [<ffffffff81078166>] ? native_safe_halt+0x6/0x10
[   13.044717]  [<ffffffff811425cd>] ? trace_hardirqs_on+0xd/0x10
[   13.044738]  [<ffffffff8104f669>] default_idle+0x59/0x120
[   13.044742]  [<ffffffff810501e8>] arch_cpu_idle+0x18/0x40
[   13.044754]  [<ffffffff811320c5>] cpu_startup_entry+0x235/0x410
[   13.044763]  [<ffffffff81f9e781>] rest_init+0xd1/0xe0
[   13.044766]  [<ffffffff81f9e6b5>] ? rest_init+0x5/0xe0
[   13.044778]  [<ffffffff82b93ec2>] start_kernel+0x425/0x493
[   13.044781]  [<ffffffff82b93810>] ? repair_env_string+0x5e/0x5e
[   13.044786]  [<ffffffff82b93595>] x86_64_start_reservations+0x2a/0x2c
[   13.044789]  [<ffffffff82b93688>] x86_64_start_kernel+0xf1/0x100
[   13.044799] ---[ end trace 113ad28772af4058 ]---
[   13.048262] ... APIC ID:      00000000 (0)
[   13.048262] ... APIC VERSION: 00050014
[   13.048262] ... APIC TASKPRI: 00000000 (00)
[   13.048262] ... APIC PROCPRI: 00000000
[   13.048262] ... APIC LDR: 01000000
[   13.048262] ... APIC DFR: ffffffff
[   13.048262] ... APIC SPIV: 000001ff
[   13.048262] ... APIC ISR field:
[   13.048262] 0000000000000000000000000000000000000000000000000000000000000000
[   13.048262] ... APIC TMR field:
[   13.048262] 0000000000000000000000000000000000000000000000000000000000000000
[   13.048262] ... APIC IRR field:
[   13.048262] 0000000000000000000000000000000000000000000000000000000020008000
[   13.048262] ... APIC ESR: 00000000
[   13.048262] ... APIC ICR: 000008fd
[   13.048262] ... APIC ICR2: 02000000
[   13.048262] ... APIC LVTT: 000000ef
[   13.048262] ... APIC LVTPC: 00010000
[   13.048262] ... APIC LVT0: 00010700
[   13.048262] ... APIC LVT1: 00000400
[   13.048262] ... APIC LVTERR: 000000fe
[   13.048262] ... APIC TMICT: 005f1b9e
[   13.048262] ... APIC TMCCT: 00000000
[   13.048262] ... APIC TDCR: 00000003
[   13.048262] 
[   13.562469] number of MP IRQ sources: 15.
[   13.565459] number of IO-APIC #2 registers: 24.
[   13.568838] testing the IO APIC.......................
[   13.572236] IO APIC #2......
[   13.575110] .... register #00: 00000000
[   13.578360] .......    : physical APIC id: 00
[   13.580789] .......    : Delivery Type: 0
[   13.583059] .......    : LTS          : 0
[   13.586374] .... register #01: 00170011
[   13.589665] .......     : max redirection entries: 17
[   13.593234] .......     : PRQ implemented: 0
[   13.596781] .......     : IO APIC version: 11
[   13.600280] .... register #02: 00000000
[   13.603478] .......     : arbitration: 00
[   13.606752] .... IRQ redirection table:
[   13.609909] 1    0    0   0   0    0    0    00
[   13.612930] 0    0    0   0   0    1    1    31
[   13.615864] 0    0    0   0   0    1    1    30
[   13.619018] 0    0    0   0   0    1    1    33
[   13.622166] 1    0    0   0   0    1    1    34
[   13.625585] 1    1    0   0   0    1    1    35
[   13.629011] 0    0    0   0   0    1    1    36
[   13.632215] 0    0    0   0   0    1    1    37
[   13.635484] 0    0    0   0   0    1    1    38
[   13.638749] 0    1    0   0   0    1    1    39
[   13.641968] 1    1    0   0   0    1    1    3A
[   13.645233] 1    1    0   0   0    1    1    3B
[   13.648353] 0    0    0   0   0    1    1    3C
[   13.651401] 0    0    0   0   0    1    1    3D
[   13.654617] 0    0    0   0   0    1    1    3E
[   13.657840] 0    0    0   0   0    1    1    3F
[   13.660913] 1    0    0   0   0    0    0    00
[   13.663832] 1    0    0   0   0    0    0    00
[   13.666950] 1    0    0   0   0    0    0    00
[   13.669852] 1    0    0   0   0    0    0    00
[   13.672753] 1    0    0   0   0    0    0    00
[   13.675527] 1    0    0   0   0    0    0    00
[   13.678382] 1    0    0   0   0    0    0    00
[   13.681278] 1    0    0   0   0    0    0    00
[   13.684146] IRQ to pin mappings:
[   13.686406] IRQ0 -> 0:2
[   13.688665] IRQ1 -> 0:1
[   13.690761] IRQ3 -> 0:3
[   13.693037] IRQ4 -> 0:4
[   13.694949] IRQ5 -> 0:5
[   13.697198] IRQ6 -> 0:6
[   13.699249] IRQ7 -> 0:7
[   13.701097] IRQ8 -> 0:8
[   13.702821] IRQ9 -> 0:9
[   13.704582] IRQ10 -> 0:10
[   13.706376] IRQ11 -> 0:11
[   13.708155] IRQ12 -> 0:12
[   13.709802] IRQ13 -> 0:13
[   13.711592] IRQ14 -> 0:14
[   13.713667] IRQ15 -> 0:15
[   13.715602] .................................... done.
[   13.719008] registered taskstats version 1
[   13.721518] Running ring buffer tests...
[   23.747921] rbtester/0 (118) used greatest stack depth: 6280 bytes left
[   23.752880] finished
[   23.759560] CPU 0:
[   23.762014]               events:    29938
[   23.772540]        dropped bytes:    0
[   23.780181]        alloced bytes:    2340332
[   23.786509]        written bytes:    2295865
[   23.794805]        biggest event:    253
[   23.799762]       smallest event:    4
[   23.813211]          read events:   12602
[   23.822392]          lost events:   17336
[   23.829102]         total events:   29938
[   23.831920]   recorded len bytes:   973548
[   23.840843]  recorded size bytes:   954926
[   23.846123]  With dropped events, record len and size may not match
[   23.846123]  alloced and written from above
[   23.858832] CPU 1:
[   23.861226]               events:    171041
[   23.864258]        dropped bytes:    0
[   23.870340]        alloced bytes:    13354048
[   23.892352]        written bytes:    13100371
[   23.900288]        biggest event:    222
[   23.902890]       smallest event:    4
[   23.914565]          read events:   12508
[   23.923724]          lost events:   158533
[   23.933343]         total events:   171041
[   23.939249]   recorded len bytes:   972840
[   23.942705]  recorded size bytes:   954255
[   23.949750]  With dropped events, record len and size may not match
[   23.949750]  alloced and written from above
[   23.962769] Ring buffer PASSED!
[   23.973553] raid6test: testing the 4-disk case...
[   23.981075] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   23.988409] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
[   23.993094] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
[   24.004145] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
[   24.011824] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
[   24.030634] raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
[   24.043562] raid6test: testing the 5-disk case...
[   24.063363] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   24.070148] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[   24.085292] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
[   24.092384] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
[   24.099650] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[   24.113320] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
[   24.119800] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
[   24.132151] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
[   24.142659] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
[   24.149683] raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
[   24.161723] raid6test: testing the 11-disk case...
[   24.171561] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   24.179150] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[   24.190808] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[   24.199073] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[   24.207177] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[   24.219884] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[   24.229403] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[   24.235150] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[   24.245325] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
[   24.249081] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
[   24.264579] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[   24.269030] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[   24.279387] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[   24.289821] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[   24.300270] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[   24.309481] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[   24.313675] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[   24.321912] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
[   24.331087] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
[   24.342504] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[   24.349691] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[   24.353930] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[   24.366241] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[   24.375444] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[   24.379620] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[   24.390131] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
[   24.399591] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
[   24.403908] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[   24.412229] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[   24.419251] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[   24.428769] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[   24.435869] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[   24.443013] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
[   24.450983] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
[   24.460605] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[   24.464822] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[   24.468647] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[   24.475748] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[   24.479714] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
[   24.488891] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
[   24.496016] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[   24.503449] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[   24.507621] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[   24.514596] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
[   24.518676] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
[   24.525997] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[   24.533796] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[   24.549335] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
[   24.561255] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
[   24.569367] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[   24.579796] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
[   24.589140] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
[   24.599304] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
[   24.608162] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
[   24.618585] raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
[   24.630134] raid6test: testing the 12-disk case...
[   24.640134] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   24.649470] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[   24.661200] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[   24.669668] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[   24.679063] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[   24.690579] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[   24.699888] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[   24.710325] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[   24.721197] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[   24.736542] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
[   24.745468] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
[   24.753854] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[   24.763341] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[   24.776840] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[   24.784331] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[   24.792267] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[   24.803686] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[   24.811150] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[   24.822473] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[   24.830567] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
[   24.834664] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
[   24.849176] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[   24.857907] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[   24.895200] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[   24.902806] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[   24.907201] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[   24.914171] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[   24.924553] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[   24.935736] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
[   24.944224] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
[   24.948448] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[   24.959787] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[   24.966115] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[   24.970276] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[   24.983418] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[   24.991516] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[   24.999861] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
[   25.008335] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
[   25.018697] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[   25.023011] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[   25.035255] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[   25.043638] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[   25.054010] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[   25.061352] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
[   25.072602] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
[   25.080730] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[   25.092090] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[   25.100390] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[   25.109371] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[   25.119173] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
[   25.128294] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
[   25.135554] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[   25.145718] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[   25.153912] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[   25.162174] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
[   25.174440] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
[   25.178697] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[   25.189855] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[   25.199690] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
[   25.203271] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
[   25.217173] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[   25.225469] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
[   25.233622] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
[   25.237880] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
[   25.249718] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
[   25.255809] raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
[   25.264275] raid6test: testing the 16-disk case...
[   25.272203] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[   25.280132] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[   25.289465] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[   25.295691] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[   25.304168] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[   25.312543] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[   25.334680] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[   25.343052] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[   25.351226] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[   25.367542] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
[   25.374334] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
[   25.383231] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
[   25.399331] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
[   25.412896] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P)  OK
[   25.422367] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q)  OK
[   25.444491] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[   25.450473] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[   25.459590] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[   25.472234] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[   25.480344] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[   25.489532] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[   25.501166] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[   25.523334] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[   25.535244] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
[   25.548299] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
[   25.551733] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
[   25.565581] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
[   25.575122] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P)  OK
[   25.589238] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q)  OK
[   25.592769] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[   25.606767] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[   25.622925] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[   25.640291] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[   25.655437] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[   25.668521] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[   25.685619] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[   25.698920] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
[   25.712631] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
[   25.726440] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
[   25.741367] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
[   25.753541] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P)  OK
[   25.757052] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q)  OK
[   25.771577] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[   25.781760] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[   25.793965] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[   25.801790] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[   25.814394] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[   25.822660] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[   25.835154] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
[   25.839191] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
[   25.843290] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
[   25.853702] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
[   25.861823] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P)  OK
[   25.871417] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q)  OK
[   25.887391] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[   25.899740] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[   25.917283] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[   25.939128] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[   25.949076] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[   25.971703] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
[   25.975784] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
[   25.985185] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
[   25.989444] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
[   25.993425] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P)  OK
[   25.999283] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q)  OK
[   26.007388] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[   26.011265] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[   26.015281] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[   26.020118] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[   26.032671] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
[   26.040623] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
[   26.052289] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
[   26.061129] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
[   26.069753] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P)  OK
[   26.079083] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q)  OK
[   26.083148] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[   26.090742] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[   26.098658] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[   26.108936] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
[   26.117107] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
[   26.124979] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
[   26.133609] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
[   26.142454] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P)  OK
[   26.150701] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q)  OK
[   26.154553] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[   26.162852] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[   26.171622] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
[   26.179368] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
[   26.185703] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
[   26.189161] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
[   26.192522] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P)  OK
[   26.195894] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q)  OK
[   26.198943] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[   26.202412] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
[   26.205615] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
[   26.209804] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
[   26.214421] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
[   26.220895] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P)  OK
[   26.228406] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q)  OK
[   26.252746] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
[   26.262883] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
[   26.268340] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
[   26.276593] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
[   26.281987] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P)  OK
[   26.285688] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q)  OK
[   26.290687] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
[   26.296742] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
[   26.314079] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
[   26.322746] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P)  OK
[   26.327684] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q)  OK
[   26.333359] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
[   26.340665] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
[   26.358999] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P)  OK
[   26.363525] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q)  OK
[   26.378105] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
[   26.395969] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P)  OK
[   26.436202] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q)  OK
[   26.441288] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P)  OK
[   26.465219] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q)  OK
[   26.486569] raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q)  OK
[   26.494420] raid6test: 
[   26.502425] raid6test: complete (257 tests, 0 failures)
[   26.545202]   Magic number: 1:907:625
[   26.550253] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   26.553701] EDD information not available.
[   26.557959] ALSA device list:
[   26.561050]   #0: Dummy 1
[   26.563395]   #1: Loopback 1
[   26.565704]   #2: MTPAV on parallel port at 0x378
[   26.588416] Freeing unused kernel memory: 1168k freed
[   26.660983] hostname (123) used greatest stack depth: 5288 bytes left
[   36.521020] MAKEDEV (636) used greatest stack depth: 4984 bytes left
[   58.868483] init: Failed to create pty - disabling logging for job
[   58.872510] init: Temporary process spawn error: No such file or directory
[   58.948432] init: Failed to create pty - disabling logging for job
[   58.986752] init: Temporary process spawn error: No such file or directory
[   59.103872] init: Failed to create pty - disabling logging for job
[   59.127269] init: Temporary process spawn error: No such file or directory
[   59.183879] init: Failed to create pty - disabling logging for job
[   59.203148] ip (3345) used greatest stack depth: 4496 bytes left
[   59.224431] init: Temporary process spawn error: No such file or directory
[   59.408661] init: failsafe main process (3343) killed by TERM signal
[   59.670932] init: Failed to create pty - disabling logging for job
[   59.700137] init: Temporary process spawn error: No such file or directory
[   59.716179] init: Failed to create pty - disabling logging for job
[   59.734503] init: Temporary process spawn error: No such file or directory
[   59.750813] init: Failed to create pty - disabling logging for job
[   59.755004] init: Temporary process spawn error: No such file or directory
[   59.801392] init: Failed to create pty - disabling logging for job
[   59.806395] init: Temporary process spawn error: No such file or directory
[   59.824091] init: Failed to create pty - disabling logging for job
[   59.833161] init: Temporary process spawn error: No such file or directory
Kernel tests: Boot OK!
[   61.411327] init: Failed to create pty - disabling logging for job
[   61.422569] init: Temporary process spawn error: No such file or directory
[   61.437054] init: Failed to create pty - disabling logging for job
[   61.442086] init: Temporary process spawn error: No such file or directory
[   61.530624] init: networking main process (3410) terminated with status 1
[   64.800520] rcu-torture: rtc: ffffffff83539700 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=250) barrier: 0/0:0
[   64.800520] rcu-torture: Reader Pipe:  8 0 0 0 0 0 0 0 0 0 0
[   64.800520] rcu-torture: Reader Batch:  8 0 0 0 0 0 0 0 0 0 0
[   64.800520] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[   86.862542] init: Failed to create pty - disabling logging for job
[   86.877326] init: Temporary process spawn error: No such file or directory
[   86.916421] init: rc main process (3376) killed by TERM signal
[   86.938704] init: tty4 main process (3378) killed by TERM signal
[   86.956279] init: tty5 main process (3379) killed by TERM signal
[   86.969502] init: tty2 main process (3380) killed by TERM signal
[   86.978335] init: tty3 main process (3383) killed by TERM signal
[   87.000401] init: tty6 main process (3384) killed by TERM signal
[   87.009841] init: hwclock-save main process (3418) terminated with status 70
[   87.022897] init: plymouth-upstart-bridge main process (3419) terminated with status 1
[   88.609092] Unregister pv shared memory for cpu 0
[   88.624492] Unregister pv shared memory for cpu 1
[   88.643135] Disabling non-boot CPUs ...
[   88.660876] CPU0 attaching NULL sched-domain.
[   88.671580] CPU1 attaching NULL sched-domain.
[   88.679719] CPU0 attaching NULL sched-domain.
[   88.710765] Restarting system.
[   88.715410] reboot: machine restart

--C7zPtVaVf+AK4Oqc
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="a2963dd6085970cbf5e09ab67fd57b2cb396f3b9-bisect.log"
Content-Transfer-Encoding: base64

YmlzZWN0OiBza2lwIDg0NGNlOWYyMDQ0NzIzYTlkYTBmNGJjZTU4OGNjYTQxMGU3NzRkMjQ6
IG5vdCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBhMjk2M2RkLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J21sYW5raG9yc3QvZm9yLWFpcmxpZWQnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMw
NjA1MTY1NwpIRUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4IDMuOQpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzAwLTA2MDUvbGlu
dXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA1MTY1NzpjMWJlNWE1YjFiMzU1
ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxOmJpc2VjdC1uZXh0CgoyMDEzLTA2LTA1LTIx
OjI4OjU2IGMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEgY29tcGls
aW5nCjEzNCByZWFsICAxOTQzIHVzZXIgIDE2MCBzeXMgIDE1NjUuMTIlIGNwdSAJeDg2XzY0
LXJhbmRjb25maWctYzAwLTA2MDUKCjIwMTMtMDYtMDUtMjE6MzE6MjYgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy45LjAuLi4uLgkxLi4JMgkzLi4JNC4JNQk3Li4JOC4JOS4JMTAgU1VDQ0VT
UwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My45CmdpdCBiaXNlY3Qgc3RhcnQgYTI5NjNkZDYw
ODU5NzBjYmY1ZTA5YWI2N2ZkNTdiMmNiMzk2ZjNiOSB2My45IC0tCkhFQUQgaXMgbm93IGF0
IGMxYmU1YTUuLi4gTGludXggMy45CkJpc2VjdGluZzogNjkyOCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls3MzI4N2E0M2NjNzljYTA2
NjI5YTg4ZDFhMTk5Y2QyODNmNDI0NTZhXSBNZXJnZSBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0LW5leHQKZ2l0IGJpc2VjdCBydW4g
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBv
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1jMDAtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2
MDUxNjU3OjczMjg3YTQzY2M3OWNhMDY2MjlhODhkMWExOTljZDI4M2Y0MjQ1NmE6YmlzZWN0
LW5leHQKCjIwMTMtMDYtMDUtMjE6NDM6MDQgNzMyODdhNDNjYzc5Y2EwNjYyOWE4OGQxYTE5
OWNkMjgzZjQyNDU2YSBjb21waWxpbmcKMTc4IHJlYWwgIDE5ODYgdXNlciAgMTcwIHN5cyAg
MTIwOC4wMCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0wNS0y
MTo0NzoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC0wNzE2OC1nNzMyODdhNC4uLgkx
CTQJNgk3Li4JOC4JOS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMRtbMG0KLi4uLi4uLi4uLi4uLi4uLi4J
MTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzNTQ4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzJlMzc4ZjNlZWJkMjhmZWVmYmIxZjk5NTM4
MzRhNWExOTQ4MmYwNTNdIE1lcmdlIGJyYW5jaCAnZm9yLW5leHQnIG9mIGdpdDovL2dpdC5z
YW1iYS5vcmcvc2ZyZW5jaC9jaWZzLTIuNgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzAwLTA2MDUvbGludXgtZGV2ZWw6
ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA1MTY1NzoyZTM3OGYzZWViZDI4ZmVlZmJiMWY5
OTUzODM0YTVhMTk0ODJmMDUzOmJpc2VjdC1uZXh0CgoyMDEzLTA2LTA1LTIyOjUzOjAyIDJl
Mzc4ZjNlZWJkMjhmZWVmYmIxZjk5NTM4MzRhNWExOTQ4MmYwNTMgY29tcGlsaW5nCjE2MyBy
ZWFsICAyMDYwIHVzZXIgIDE4MyBzeXMgIDEzNzQuNTglIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzAwLTA2MDUKCjIwMTMtMDYtMDUtMjI6NTU6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My45LjAtMTA1NDgtZzJlMzc4ZjMuLi4uLi4uCTEuLi4uLgkyLi4JNC4uLi4JNQk3Li4uLgk5
Li4uCTEwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTc3MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpClthMWYwYmNjY2ZmZTUwOGIzNmY4ZWIw
YmQzOTc3MWQ0YmVkYzY4M2E4XSBNZXJnZSBicmFuY2ggJ25leHQnIG9mIGdpdDovL2dpdC5t
b25zdHIuZXUvbGludXgtMi42LW1pY3JvYmxhemUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1L2xpbnV4LWRl
dmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNTE2NTc6YTFmMGJjY2NmZmU1MDhiMzZm
OGViMGJkMzk3NzFkNGJlZGM2ODNhODpiaXNlY3QtbmV4dAoKMjAxMy0wNi0wNS0yMzoxMjow
MCBhMWYwYmNjY2ZmZTUwOGIzNmY4ZWIwYmQzOTc3MWQ0YmVkYzY4M2E4IGNvbXBpbGluZwox
NzkgcmVhbCAgMjA2OSB1c2VyICAxOTEgc3lzICAxMjU4Ljg0JSBjcHUgCXg4Nl82NC1yYW5k
Y29uZmlnLWMwMC0wNjA1CgoyMDEzLTA2LTA1LTIzOjE1OjE0IGRldGVjdGluZyBib290IHN0
YXRlIDMuOS4wLTEyMzI2LWdhMWYwYmNjLi4uLi4JMQkyLgkzCTUuLgk2CTcJOAk5CTEwIFNV
Q0NFU1MKCkJpc2VjdGluZzogODg3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMCBzdGVwcykKWzcyZGQ0ZTc5ODBiZjU4NGZhMTFkYjRmMDBlMzhkNWNm
OTU2YTg4NTZdIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vdmlydC9rdm0v
a3ZtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCBvYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1jMDAtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAx
MzA2MDUxNjU3OjcyZGQ0ZTc5ODBiZjU4NGZhMTFkYjRmMDBlMzhkNWNmOTU2YTg4NTY6Ymlz
ZWN0LW5leHQKCjIwMTMtMDYtMDUtMjM6MjM6NDYgNzJkZDRlNzk4MGJmNTg0ZmExMWRiNGYw
MGUzOGQ1Y2Y5NTZhODg1NiBjb21waWxpbmcKMTc2IHJlYWwgIDIwNjcgdXNlciAgMTg3IHN5
cyAgMTI3OC40OCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0w
NS0yMzoyNjo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMyLTAwMDkyLWc3MmRk
NGU3Li4uLi4uLi4uLgkxLi4uLgkyLi4uLi4uLgkzLi4uLi4JNC4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JNS4JNi4uLi4uLi4uLi4uLi4uLi4uLgk3Li4uLi4uLi4u
Li4uLgk4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JOS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JMTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0NDMgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpClsyNzk4Mzg5NjA0ODRmYTIyZDkwMzA4
NmVlYTc0M2E2YjY3MDA2NDdkXSBwb3dlcnBjL3BjaTogUmVtb3ZlIHRoZSBzdGFsZSBjb21t
ZW50cyBvZiBwY2lfcHJvY2Vzc19icmlkZ2VfT0ZfcmFuZ2VzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNS9s
aW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDUxNjU3OjI3OTgzODk2MDQ4
NGZhMjJkOTAzMDg2ZWVhNzQzYTZiNjcwMDY0N2Q6YmlzZWN0LW5leHQKCjIwMTMtMDYtMDYt
MDA6NDU6MDUgMjc5ODM4OTYwNDg0ZmEyMmQ5MDMwODZlZWE3NDNhNmI2NzAwNjQ3ZCBjb21w
aWxpbmcKMTcxIHJlYWwgIDIwNjYgdXNlciAgMTk0IHN5cyAgMTMxOC41OCUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0wNi0wMDo1MDo1MCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjEwLjAtcmMzLTAwMDYwLWcyNzk4Mzg5Li4uLgkxCTIJMwk2CTEwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMjIxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA4IHN0ZXBzKQpbYTFmMmNjNzNjNzYyODY4NDM1YWU2ZWM5MTI2YmIyMjQw
MzM3YzYxY10gZHJtL2k5MTU6IGFkZCBJOTE1X1BBUkFNX0hBU19WRUJPWCB0byBpOTE1X2dl
dHBhcmFtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCBvYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1jMDAtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQt
MjAxMzA2MDUxNjU3OmExZjJjYzczYzc2Mjg2ODQzNWFlNmVjOTEyNmJiMjI0MDMzN2M2MWM6
YmlzZWN0LW5leHQKCjIwMTMtMDYtMDYtMDA6NTU6MjMgYTFmMmNjNzNjNzYyODY4NDM1YWU2
ZWM5MTI2YmIyMjQwMzM3YzYxYyBjb21waWxpbmcKMTk0IHJlYWwgIDIwNzQgdXNlciAgMTk4
IHN5cyAgMTE2Ni4yOCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0w
Ni0wNi0wMTowMToyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMyLTAwMjIyLWdh
MWYyY2M3Li4uCTEuLgkyLi4JMy4uLi4uCTQuLi4uLgk1CTYuLi4uLi4uLgk3Lgk4CTkuLgkx
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzZjZjNjNzM2MjAwZTM5MjRkOGNlNmIzN2U1MDA2
YTQ1OThiOTIzNmRdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdmlyby92ZnMKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0w
NjA1L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNTE2NTc6NmNmM2M3
MzYyMDBlMzkyNGQ4Y2U2YjM3ZTUwMDZhNDU5OGI5MjM2ZDpiaXNlY3QtbmV4dAoKMjAxMy0w
Ni0wNi0wMToyMDozMSA2Y2YzYzczNjIwMGUzOTI0ZDhjZTZiMzdlNTAwNmE0NTk4YjkyMzZk
IGNvbXBpbGluZwoyMDAgcmVhbCAgMjA3NCB1c2VyICAxOTUgc3lzICAxMTMwLjYxJSBjcHUg
CXg4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1CgoyMDEzLTA2LTA2LTAxOjI2OjU2IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTAuMC1yYzMtMDAxNTYtZzZjZjNjNzMuLi4JMwk3CTkuLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRf
dG9fcnVuX3F1ZXVlIDEbWzBtCi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA1NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNiBzdGVwcykKWzBlMzJmZGU5NmJiOWMxZmE4ZmE0NzdlNTJjMWQ2YWUyZjQ5OTVj
ZWFdIE1lcmdlIGJyYW5jaCAnZHJtLW5vdXZlYXUtZml4ZXMtMy4xMCcgb2YgZ2l0Oi8vYW5v
bmdpdC5mcmVlZGVza3RvcC5vcmcvZ2l0L25vdXZlYXUvbGludXgtMi42IGludG8gZHJtLWZp
eGVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCBvYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1jMDAtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAx
MzA2MDUxNjU3OjBlMzJmZGU5NmJiOWMxZmE4ZmE0NzdlNTJjMWQ2YWUyZjQ5OTVjZWE6Ymlz
ZWN0LW5leHQKCjIwMTMtMDYtMDYtMDI6MzM6MzkgMGUzMmZkZTk2YmI5YzFmYThmYTQ3N2U1
MmMxZDZhZTJmNDk5NWNlYSBjb21waWxpbmcKMTYzIHJlYWwgIDIwMTAgdXNlciAgMTg5IHN5
cyAgMTM0OC4zNCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0w
Ni0wMjozNjozMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM0LTAwMDE4LWcwZTMy
ZmRlLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTEuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JMi4uLi4uLi4uLi4JMy4uLi4uLi4uLi4uLi4uLi4uLi4uCTQu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNS4uLi4uCTYJNy4uLi4uLi4uLi4uCTguLi4uLi4u
Li4uLi4uLi4uLi4uLi4JOS4uLi4uLi4uLi4uLi4uLi4uLi4JMTAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAyOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBz
dGVwcykKW2Q3ZmUwY2MwZjJlMGIzMDJiMjQ3Y2FhNDMwNjkxNWEwNjIxOGUwYmVdIGRybS9p
OTE1OiBGaXggRFNQQ0xLX0dBVEVfRCBmb3IgVkxWCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNS9saW51eC1k
ZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDUxNjU3OmQ3ZmUwY2MwZjJlMGIzMDJi
MjQ3Y2FhNDMwNjkxNWEwNjIxOGUwYmU6YmlzZWN0LW5leHQKCjIwMTMtMDYtMDYtMDQ6MDk6
MzYgZDdmZTBjYzBmMmUwYjMwMmIyNDdjYWE0MzA2OTE1YTA2MjE4ZTBiZSBjb21waWxpbmcK
MTkwIHJlYWwgIDIwNTAgdXNlciAgMTg0IHN5cyAgMTE3NS45MiUgY3B1IAl4ODZfNjQtcmFu
ZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0wNi0wNDoxMzoyNCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEwLjAtcmMyLTAwMjQ4LWdkN2ZlMGNjLi4uLgkzCTYJOAk5LgkxMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDE0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA0IHN0ZXBzKQpbZjBlMDdlNDY2OGFmZGVhMTc1NWExZTI4YTk2NDkyNjFhZmU5ODBi
M10gZHJtL25vdXZlYXU6IG1ha2UgZmxpcHBpbmcgbG9ja2RlcCBzYWZlCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMDAt
MDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDUxNjU3OmYwZTA3
ZTQ2NjhhZmRlYTE3NTVhMWUyOGE5NjQ5MjYxYWZlOTgwYjM6YmlzZWN0LW5leHQKCjIwMTMt
MDYtMDYtMDQ6MTg6MjYgZjBlMDdlNDY2OGFmZGVhMTc1NWExZTI4YTk2NDkyNjFhZmU5ODBi
MyBjb21waWxpbmcKMTgwIHJlYWwgIDE5ODQgdXNlciAgMTc2IHN5cyAgMTIwMC44MyUgY3B1
IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0wNi0wNDoyMTo0MiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzUtMDA3NjAtZ2YwZTA3ZTQuLi4uCTEJMi4uCTQJ
NQk2CTkJMTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbOTc5YzNjMGJkYjIxMDE3Y2M2ZTAwZDIw
MzQ5ZjBlZTAzNDdkZDVhN10gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZHJtLWV4
eW5vcy9leHlub3MtZHJtLW5leHQnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNjA1
MTY1NwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYzAwLTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIw
MTMwNjA1MTY1Nzo5NzljM2MwYmRiMjEwMTdjYzZlMDBkMjAzNDlmMGVlMDM0N2RkNWE3OmJp
c2VjdC1uZXh0CgoyMDEzLTA2LTA2LTA0OjI4OjE2IDk3OWMzYzBiZGIyMTAxN2NjNmUwMGQy
MDM0OWYwZWUwMzQ3ZGQ1YTcgY29tcGlsaW5nCjE4NCByZWFsICAyMDM4IHVzZXIgIDE4OCBz
eXMgIDEyMDQuNTIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzAwLTA2MDUKCjIwMTMtMDYt
MDYtMDQ6MzE6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNC0wMDAyNS1nOTc5
YzNjMC4uLgkxLgkyCTMJNQk3Li4JOS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMRtbMG0KLi4uLi4uLi4u
Li4uLi4uCTEwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzM3ZmJjZDU5YmRjOGMzMDliYzk4OTU3
ZmY1MTAyMWJiZGZmNDU2MDZdIGRybS9tZ2FnMjAwOiBpbmxpbmUgcmVzZXJ2YXRpb25zCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1jMDAtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDUx
NjU3OjM3ZmJjZDU5YmRjOGMzMDliYzk4OTU3ZmY1MTAyMWJiZGZmNDU2MDY6YmlzZWN0LW5l
eHQKCjIwMTMtMDYtMDYtMDU6MzY6MTEgMzdmYmNkNTliZGM4YzMwOWJjOTg5NTdmZjUxMDIx
YmJkZmY0NTYwNiBjb21waWxpbmcKMTcyIHJlYWwgIDE5NzkgdXNlciAgMTY4IHN5cyAgMTI0
OC40MyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0wNi0wNToz
OToxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzUtMDA3NjQtZzM3ZmJjZDUuLi4u
LiBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLWF0aGVucy0zODMwMC0yMDEzMDYwNjA1NDIwMy0z
LjkuMC1yYzUtMDA3NjQtZzM3ZmJjZDUtMTMKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClsxZTllOWQxMWFhMzU4MTIz
ZGQ3MjFkYmE1MDc1ZTIzYzAzYjQ5OTU3XSBkcm0vYXN0OiBpbmxpbmUgcmVzZXJ2YXRpb25z
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBv
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1jMDAtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2
MDUxNjU3OjFlOWU5ZDExYWEzNTgxMjNkZDcyMWRiYTUwNzVlMjNjMDNiNDk5NTc6YmlzZWN0
LW5leHQKCjIwMTMtMDYtMDYtMDU6NDE6NDggMWU5ZTlkMTFhYTM1ODEyM2RkNzIxZGJhNTA3
NWUyM2MwM2I0OTk1NyBjb21waWxpbmcKMTcxIHJlYWwgIDE5NzIgdXNlciAgMTY3IHN5cyAg
MTI0Ny4zOCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNQoKMjAxMy0wNi0wNi0w
NTo0NToxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1yYzUtMDA3NjItZzFlOWU5ZDEu
Li4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1zbmItNDg2ODMtMjAxMzA2MDYw
NTU0MTYtMy45LjAtcmM1LTAwNzYyLWcxZTllOWQxLTE0CgpCaXNlY3Rpbmc6IDAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClszZDcxYzZl
ZDQzZDgzOGU1OTM1MzgxNzZhOWE1OWRlYmUyMjhjZmIwXSBkcm0vdHRtOiBjb252ZXJ0IHRv
IHRoZSByZXNlcnZhdGlvbiBhcGkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1L2xpbnV4LWRldmVsOmRldmVs
LWNhaXJvLXg4Nl82NC0yMDEzMDYwNTE2NTc6M2Q3MWM2ZWQ0M2Q4MzhlNTkzNTM4MTc2YTlh
NTlkZWJlMjI4Y2ZiMDpiaXNlY3QtbmV4dAoKMjAxMy0wNi0wNi0wNTo1MToxMSAzZDcxYzZl
ZDQzZDgzOGU1OTM1MzgxNzZhOWE1OWRlYmUyMjhjZmIwIGNvbXBpbGluZwoxNjcgcmVhbCAg
MTk2MSB1c2VyICAxNjcgc3lzICAxMjY4LjYxJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMw
MC0wNjA1CgoyMDEzLTA2LTA2LTA1OjU0OjA5IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4w
LXJjNS0wMDc2MS1nM2Q3MWM2ZS4uLi4uLi4gVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1zbmIt
NDY3LTIwMTMwNjA2MDYwMDI4LTMuOS4wLXJjNS0wMDc2MS1nM2Q3MWM2ZS0xNQoKM2Q3MWM2
ZWQ0M2Q4MzhlNTkzNTM4MTc2YTlhNTlkZWJlMjI4Y2ZiMCBpcyB0aGUgZmlyc3QgYmFkIGNv
bW1pdApjb21taXQgM2Q3MWM2ZWQ0M2Q4MzhlNTkzNTM4MTc2YTlhNTlkZWJlMjI4Y2ZiMApB
dXRob3I6IE1hYXJ0ZW4gTGFua2hvcnN0IDxtYWFydGVuLmxhbmtob3JzdEBjYW5vbmljYWwu
Y29tPgpEYXRlOiAgIFR1ZSBBcHIgMiAxMjozMzowMSAyMDEzICswMjAwCgogICAgZHJtL3R0
bTogY29udmVydCB0byB0aGUgcmVzZXJ2YXRpb24gYXBpCiAgICAKICAgIE5vdyB0aGF0IHRo
ZSBjb2RlIGlzIGNvbXBhdGlibGUgaW4gc2VtYW50aWNzLCBmbGlwIHRoZSBzd2l0Y2guCiAg
ICBVc2Ugd3dfbXV0ZXggaW5zdGVhZCBvZiB0aGUgaG9tZWdyb3duIGltcGxlbWVudGF0aW9u
LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBNYWFydGVuIExhbmtob3JzdCA8bWFhcnRlbi5s
YW5raG9yc3RAY2Fub25pY2FsLmNvbT4KCjowNDAwMDAgMDQwMDAwIDZmM2IxZGFjYWZlOTk1
NTRhY2I0NmFjZGJkNmU3MmQ1ZjI2NzI3MWUgNGE0NTNkNmJlNWZkNzM5M2I5ZTI4MzQ4NGZk
YWI3YjUxNzdmMDY1ZiBNCWRyaXZlcnMKOjA0MDAwMCAwNDAwMDAgZTQ4ZjY0ZWY1ODI0ZGJl
MThlNjIwYzEwODgzMWMyNzEyOGFmMzhjMCA1NDg0MDMzNzI5NWRiYWRlNTBmMTViNjk0MjY1
N2U1MjBhZmY1NDlmIE0JaW5jbHVkZQpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1L2xpbnV4
LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYwNTE2NTc6ZjBlMDdlNDY2OGFmZGVh
MTc1NWExZTI4YTk2NDkyNjFhZmU5ODBiMzpiaXNlY3QtbmV4dAoKMjAxMy0wNi0wNi0wNTo1
Nzo0MCBmMGUwN2U0NjY4YWZkZWExNzU1YTFlMjhhOTY0OTI2MWFmZTk4MGIzIHJldXNlIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzAwLTA2MDUvZjBlMDdlNDY2OGFmZGVhMTc1NWEx
ZTI4YTk2NDkyNjFhZmU5ODBiMy92bWxpbnV6LTMuOS4wLXJjNS0wMDc2MC1nZjBlMDdlNAoK
MjAxMy0wNi0wNi0wNTo1Nzo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4J
MS4uCTIuLi4uLi4uLi4uLi4uLgkzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNC4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JNQk2Li4uLi4uLgk3Li4uLi4uLi4JOC4uLgk5Li4uLi4u
Li4uLi4uLi4uLgkxMC4JMTEuLi4JMTIuLi4uLi4uLi4uCTEzCTE0Li4JMTcuCTE4LgkxOS4J
MjAJMjEuLgkyMy4JMjQJMzAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLWNh
aXJvLXg4Nl82NC0yMDEzMDYwNTE2NTc6YTI5NjNkZDYwODU5NzBjYmY1ZTA5YWI2N2ZkNTdi
MmNiMzk2ZjNiOTpiaXNlY3QtbmV4dAogVEVTVCBGQUlMVVJFCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzAwLTA2MDUvYTI5NjNkZDYwODU5NzBjYmY1ZTA5YWI2N2ZkNTdiMmNiMzk2
ZjNiOS9kbWVzZy1rdm0tY2Fpcm8tMjg4OC0yMDEzMDYwNTE3MzkwMy0zLjEwLjAtcmM0LTAw
Mjk2LWdhMjk2M2RkLTIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzAwLTA2MDUvYTI5
NjNkZDYwODU5NzBjYmY1ZTA5YWI2N2ZkNTdiMmNiMzk2ZjNiOS9kbWVzZy1rdm0taW5uLTUz
MTU2LTIwMTMwNjA1MTgxMzA1LTMuMTAuMC1yYzQtMDAyOTYtZ2EyOTYzZGQtMjAKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNS9hMjk2M2RkNjA4NTk3MGNiZjVlMDlhYjY3
ZmQ1N2IyY2IzOTZmM2I5L2RtZXNnLWt2bS1yb2FtLTI3MzU4LTIwMTMwNjA1MTgwNTUzLTMu
MTAuMC1yYzQtMDAyOTYtZ2EyOTYzZGQtMjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MDAtMDYwNS9hMjk2M2RkNjA4NTk3MGNiZjVlMDlhYjY3ZmQ1N2IyY2IzOTZmM2I5L2RtZXNn
LWt2bS12cC0yNzc3Ni0yMDEzMDYwNTE4MTIwOC0zLjEwLjAtcmM0LTAwMjk2LWdhMjk2M2Rk
LTIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzAwLTA2MDUvYTI5NjNkZDYwODU5NzBj
YmY1ZTA5YWI2N2ZkNTdiMmNiMzk2ZjNiOS9kbWVzZy1rdm0tdnAtMjc4ODYtMjAxMzA2MDUx
ODE4MjgtMy4xMC4wLXJjNC0wMDI5Ni1nYTI5NjNkZC0yMAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMwMC0wNjA1L2EyOTYzZGQ2MDg1OTcwY2JmNWUwOWFiNjdmZDU3YjJjYjM5NmYz
YjkvZG1lc2cta3ZtLXZwLTI4ODUwLTIwMTMwNjA1MTgxODQ3LTMuMTAuMC1yYzQtMDAyOTYt
Z2EyOTYzZGQtMjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMDAtMDYwNS9hMjk2M2Rk
NjA4NTk3MGNiZjVlMDlhYjY3ZmQ1N2IyY2IzOTZmM2I5L2RtZXNnLWt2bS12cC0yOTMxMS0y
MDEzMDYwNTE4MDU1MS0zLjEwLjAtcmM0LTAwMjk2LWdhMjk2M2RkLTIwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzAwLTA2MDUvYTI5NjNkZDYwODU5NzBjYmY1ZTA5YWI2N2ZkNTdi
MmNiMzk2ZjNiOS9kbWVzZy1rdm0tdnAtMzEyODMtMjAxMzA2MDUxODA5NDMtMy4xMC4wLXJj
NC0wMDI5Ni1nYTI5NjNkZC0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1
L2EyOTYzZGQ2MDg1OTcwY2JmNWUwOWFiNjdmZDU3YjJjYjM5NmYzYjkvZG1lc2cta3ZtLXhp
YW4tNTIxNTgtMjAxMzA2MDUxNzUyNDEtMy4xMC4wLXJjNC0wMDI5Ni1nYTI5NjNkZC0yMAoK
SEVBRCBpcyBub3cgYXQgYTI5NjNkZCBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdt
bGFua2hvcnN0L2Zvci1haXJsaWVkJyBpbnRvIGRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDYw
NTE2NTcKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMDAt
MDYwNS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA2MDUxNjU3OmY4ZjEy
NmYyMmEzMmYyZjJiM2I2MWJkNWI4YTNkNTFhMmNhYzA5ZWM6YmlzZWN0LW5leHQKCjIwMTMt
MDYtMDYtMDc6MTY6MjYgZjhmMTI2ZjIyYTMyZjJmMmIzYjYxYmQ1YjhhM2Q1MWEyY2FjMDll
YyByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMwMC0wNjA1L2Y4ZjEyNmYyMmEz
MmYyZjJiM2I2MWJkNWI4YTNkNTFhMmNhYzA5ZWMvdm1saW51ei0zLjEwLjAtcmM0LW5leHQt
MjAxMzA2MDUKCjIwMTMtMDYtMDYtMDc6MTY6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4u
CTE4CTI2CTI5CTMwIFNVQ0NFU1MKCg==

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc4 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
# CONFIG_MEMCG_SWAP_ENABLED is not set
# CONFIG_MEMCG_KMEM is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=y
# CONFIG_BRIDGE_EBT_ARP is not set
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=y
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_ATMEL_PWM is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_SAMSUNG=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_UCB1400 is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_WM97XX=y
# CONFIG_TOUCHSCREEN_WM9705 is not set
CONFIG_TOUCHSCREEN_WM9712=y
# CONFIG_TOUCHSCREEN_WM9713 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_ATMEL=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_EXYNOS is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_WM97XX=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog TV support
#
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
# CONFIG_VIDEO_ZORAN_BUZ is not set
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_CX25821_ALSA=y
# CONFIG_VIDEO_SAA7134 is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y

#
# Video and audio decoders
#

#
# Video encoders
#
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3630=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_OT200=y
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_HRTIMER=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=y
CONFIG_SND_CS5535AUDIO=y
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
# CONFIG_SND_ECHO3G is not set
CONFIG_SND_INDIGO=y
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
# CONFIG_SND_ES1968_INPUT is not set
# CONFIG_SND_ES1968_RADIO is not set
CONFIG_SND_FM801=y
# CONFIG_SND_FM801_TEA575X_BOOL is not set
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
# CONFIG_SND_VIA82XX is not set
CONFIG_SND_VIA82XX_MODEM=y
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
# CONFIG_SND_DESIGNWARE_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SOC_ALL_CODECS=y
CONFIG_SND_SOC_ARIZONA=y
CONFIG_SND_SOC_WM_HUBS=y
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AB8500_CODEC=y
CONFIG_SND_SOC_AD193X=y
CONFIG_SND_SOC_AD73311=y
CONFIG_SND_SOC_ADAU1373=y
CONFIG_SND_SOC_ADAV80X=y
CONFIG_SND_SOC_ADS117X=y
CONFIG_SND_SOC_AK4535=y
CONFIG_SND_SOC_AK4641=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK4671=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_ALC5632=y
CONFIG_SND_SOC_CS42L51=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CX20442=y
CONFIG_SND_SOC_JZ4740_CODEC=y
CONFIG_SND_SOC_L3=y
CONFIG_SND_SOC_DA7210=y
CONFIG_SND_SOC_DA7213=y
CONFIG_SND_SOC_DA732X=y
CONFIG_SND_SOC_DA9055=y
CONFIG_SND_SOC_DFBMCS320=y
CONFIG_SND_SOC_ISABELLE=y
CONFIG_SND_SOC_LM49453=y
CONFIG_SND_SOC_MAX98088=y
CONFIG_SND_SOC_MAX98090=y
CONFIG_SND_SOC_MAX98095=y
CONFIG_SND_SOC_MAX9850=y
CONFIG_SND_SOC_PCM3008=y
CONFIG_SND_SOC_RT5631=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SI476X=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA529=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_TLV320DAC33=y
CONFIG_SND_SOC_TWL6040=y
CONFIG_SND_SOC_UDA134X=y
CONFIG_SND_SOC_UDA1380=y
CONFIG_SND_SOC_WM1250_EV1=y
CONFIG_SND_SOC_WM2000=y
CONFIG_SND_SOC_WM2200=y
CONFIG_SND_SOC_WM5100=y
CONFIG_SND_SOC_WM5110=y
CONFIG_SND_SOC_WM8350=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8727=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8900=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8904=y
CONFIG_SND_SOC_WM8940=y
CONFIG_SND_SOC_WM8955=y
CONFIG_SND_SOC_WM8960=y
CONFIG_SND_SOC_WM8961=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_WM8971=y
CONFIG_SND_SOC_WM8974=y
CONFIG_SND_SOC_WM8978=y
CONFIG_SND_SOC_WM8983=y
CONFIG_SND_SOC_WM8985=y
CONFIG_SND_SOC_WM8988=y
CONFIG_SND_SOC_WM8990=y
CONFIG_SND_SOC_WM8991=y
CONFIG_SND_SOC_WM8993=y
CONFIG_SND_SOC_WM8994=y
CONFIG_SND_SOC_WM8995=y
CONFIG_SND_SOC_WM8996=y
CONFIG_SND_SOC_WM9081=y
CONFIG_SND_SOC_WM9090=y
CONFIG_SND_SOC_LM4857=y
CONFIG_SND_SOC_MAX9768=y
CONFIG_SND_SOC_MAX9877=y
CONFIG_SND_SOC_ML26124=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_PS3REMOTE=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_WIIMOTE_EXT is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_RENESAS_TPU=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_SLICOSS=y
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
# CONFIG_AD7606 is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_GPIO_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
CONFIG_ACPI_QUICKSTART=y
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
# CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=y
CONFIG_SPEAKUP_SYNTH_BNS=y
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
CONFIG_SPEAKUP_SYNTH_DECEXT=y
CONFIG_SPEAKUP_SYNTH_DTLK=y
CONFIG_SPEAKUP_SYNTH_KEYPC=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=y
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_DT3155=y
CONFIG_DT3155_CCIR=y
CONFIG_DT3155_STREAMING=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_PVPANIC=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y
CONFIG_COMMON_CLK_WM831X=y
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_CLK_TWL6040=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_RING_BUFFER_STARTUP_TEST=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
CONFIG_CRYPTO_TWOFISH_AVX2_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y
# CONFIG_ISDN_DRV_LOOP is not set

--C7zPtVaVf+AK4Oqc--
