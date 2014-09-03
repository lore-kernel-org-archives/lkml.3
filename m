Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbaICMVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:21:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:31502 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaICMVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:21:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,457,1406617200"; 
   d="scan'208";a="585597163"
Date: Wed, 3 Sep 2014 20:20:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [drm/i915] c2b6ef43779:
 dmesg.WARNING:CPU:PID:at_drivers/gpu/drm/i915/i915_irq.c:ironlake_enable_display_irq_i915()
Message-ID: <20140903122044.GA15980@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below dmesg warning changes on

git://linuxtv.org/snawrocki/samsung.git next-20140721-exynos4412-odroid-sound
commit c2b6ef437792d4d5f972d5147b809aac78a5b273 ("drm/i915: set pm._irqs_disabled at IRQ init time")

test case: lkp-t410/boot/1
lkp-t410 is a Westmere laptop.

e59a094c9058421  c2b6ef437792d4d5f972d5147 
---------------  ------------------------- 
         0           +Inf%          1 ± 0%  TOTAL dmesg.WARNING:CPU:PID:at_drivers/gpu/drm/i915/i915_irq.c:ironlake_enable_display_irq_i915()
         0           +Inf%          1 ± 0%  TOTAL dmesg.WARNING:CPU:PID:at_drivers/gpu/drm/i915/i915_irq.c:ibx_display_interrupt_update_i915()
         1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.WARNING:CPU:PID:at_drivers/gpu/drm/i915/intel_pm.c:intel_disable_gt_powersave_i915()

After patch, the dmesg sometimes show this warning

[    9.146723] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    9.146724] [drm] Driver supports precise vblank timestamp query.
[    9.147237] ------------[ cut here ]------------
[    9.147300] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:139 ironlake_enable_display_irq+0x73/0x80 [i915]()
[    9.147336] Modules linked in: snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.147340] CPU: 0 PID: 271 Comm: modprobe Not tainted 3.16.0-rc4-00052-gc2b6ef4 #1
[    9.147342] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.147347]  0000000000000009 ffff880076b0f8e0 ffffffff8182b6d0 0000000000000000
[    9.147350]  ffff880076b0f918 ffffffff8106d0dd ffff880074f30000 ffff880074f37128
[    9.147354]  0000000000000246 ffff880074f30000 ffff880074f30000 ffff880076b0f928
[    9.147355] Call Trace:
[    9.147365]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.147373]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.147376]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.147421]  [<ffffffffa02a88b3>] ironlake_enable_display_irq+0x73/0x80 [i915]
[    9.147466]  [<ffffffffa02a912f>] ironlake_irq_postinstall+0x17f/0x1a0 [i915]
[    9.147488]  [<ffffffffa00957be>] drm_irq_install+0xbe/0x1a0 [drm]
[    9.147547]  [<ffffffffa03067e7>] i915_driver_load+0xb07/0xfe0 [i915]
[    9.147555]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.147560]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.147564]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.147569]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.147572]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.147595]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.147614]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.147634]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.147668]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.147674]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.147679]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.147683]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.147688]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.147691]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.147694]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.147697]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.147700]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.147704]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.147707]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.147712]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.147731]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.147736]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.147771]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.147779]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.147784]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.147789]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.147797]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.147801]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.147805]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.147810]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.147817]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.147820] ---[ end trace 2d05078fac923b98 ]---
[    9.147880] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem

Thanks,
Fengguang
_______________________________________________
LKP mailing list
LKP@linux.intel.com

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-e59a094

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc4-00051-ge59a094 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Fri Jul 18 13:15:30 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-e59a094c9058421e4af3b007b292b46a2fe7733c-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 kconfig=x86_64-rhel commit=e59a094c9058421e4af3b007b292b46a2fe7733c root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007727bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007727c000-0x0000000077281fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077282000-0x0000000077362fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077363000-0x0000000077374fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077375000-0x00000000773f5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000773f6000-0x000000007740efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007740f000-0x000000007746efff] usable
[    0.000000] BIOS-e820: [mem 0x000000007746f000-0x0000000077667fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077668000-0x00000000776e7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000776e8000-0x000000007770efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007770f000-0x0000000077716fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077717000-0x000000007771efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007776bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007776c000-0x0000000077777fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000077778000-0x000000007777afff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007777b000-0x000000007778afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007778b000-0x000000007778bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007778c000-0x000000007779efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007779f000-0x00000000777fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000777ff000-0x00000000777fffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077800000-0x000000007bffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x77800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 078000000 mask FF8000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f68c0-0x000f68cf] mapped at [ffff8800000f68c0]
[    0.000000]   mpc: 9f071-9f17d
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02144000, 0x02144fff] PGTABLE
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6e000000-0x6e1fffff]
[    0.000000]  [mem 0x6e000000-0x6e1fffff] page 2M
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6dffffff]
[    0.000000]  [mem 0x6c000000-0x6dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x6bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x6e200000-0x7727bfff]
[    0.000000]  [mem 0x6e200000-0x771fffff] page 2M
[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
[    0.000000] BRK [0x02148000, 0x02148fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
[    0.000000] BRK [0x02149000, 0x02149fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
[    0.000000] RAMDISK: [mem 0x6e3d2000-0x7727bfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140424/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140424/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000777EFED1 00ECE9 (v01 LENOVO TP-6I    00001120 MSFT 03000001)
[    0.000000] ACPI: FACS 0x00000000776E7000 000040
[    0.000000] ACPI: SSDT 0x00000000777EFCB4 00021D (v01 LENOVO TP-6I    00001120 MSFT 03000001)
[    0.000000] ACPI: ECDT 0x00000000777FEBBA 000052 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: APIC 0x00000000777FEC0C 000084 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: MCFG 0x00000000777FECC8 00003C (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: HPET 0x00000000777FED04 000038 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: ASF! 0x00000000777FEDBE 0000A4 (v16 LENOVO TP-6I    00001120 PTL  00000001)
[    0.000000] ACPI: SLIC 0x00000000777FEE62 000176 (v01 LENOVO TP-6I    00001120  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000777FEFD8 000028 (v01 LENOVO TP-6I    00001120  LTP 00000001)
[    0.000000] ACPI: SSDT 0x00000000776E591A 00084B (v01 LENOVO TP-6I    00001120 INTL 20050513)
[    0.000000] ACPI: TCPA 0x000000007778B000 000032 (v02 PTL     CRESTLN 06040000      00005A52)
[    0.000000] ACPI: SSDT 0x000000007777A000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20050513)
[    0.000000] ACPI: SSDT 0x0000000077779000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20050513)
[    0.000000] ACPI: SSDT 0x0000000077778000 00049F (v01 PmRef  ApTst    00003000 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000777fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x777fffff]
[    0.000000]   NODE_DATA [mem 0x77745000-0x7776bfff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff88006bc00000-ffff88006d9fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7727bfff]
[    0.000000]   node   0: [mem 0x77282000-0x77362fff]
[    0.000000]   node   0: [mem 0x7740f000-0x7746efff]
[    0.000000]   node   0: [mem 0x7770f000-0x77716fff]
[    0.000000]   node   0: [mem 0x7771f000-0x7776bfff]
[    0.000000]   node   0: [mem 0x777ff000-0x777fffff]
[    0.000000] On node 0 totalpages: 488368
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7584 pages used for memmap
[    0.000000]   DMA32 zone: 484371 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0x7a000000-0x7bffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 1, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 1, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 1, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 1, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 1, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 1, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 1, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 1, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 1, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 1, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 1, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 1, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 1, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 1, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 1, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7727c000-0x77281fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77363000-0x77374fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77375000-0x773f5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x773f6000-0x7740efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7746f000-0x77667fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77668000-0x776e7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x776e8000-0x7770efff]
[    0.000000] PM: Registered nosave memory: [mem 0x77717000-0x7771efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7776c000-0x77777fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77778000-0x7777afff]
[    0.000000] PM: Registered nosave memory: [mem 0x7777b000-0x7778afff]
[    0.000000] PM: Registered nosave memory: [mem 0x7778b000-0x7778bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7778c000-0x7779efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7779f000-0x777fefff]
[    0.000000] e820: [mem 0x7c000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88006e000000 s87552 r8192 d23040 u524288
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-e59a094c9058421e4af3b007b292b46a2fe7733c-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 kconfig=x86_64-rhel commit=e59a094c9058421e4af3b007b292b46a2fe7733c root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 1757992K/1953472K available (8421K kernel code, 1656K rwdata, 3876K rodata, 1792K init, 1876K bss, 195480K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 7864320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2393.929 MHz processor
[    0.000033] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.85 BogoMIPS (lpj=2393929)
[    0.000743] pid_max: default: 32768 minimum: 301
[    0.001061] ACPI: Core revision 20140424
[    0.014567] ACPI: All ACPI Tables successfully acquired
[    0.015049] Security Framework initialized
[    0.015340] SELinux:  Initializing.
[    0.015601] SELinux:  Starting in permissive mode
[    0.016061] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.017211] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.017962] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.018393] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.019131] Initializing cgroup subsys memory
[    0.019502] Initializing cgroup subsys devices
[    0.019850] Initializing cgroup subsys freezer
[    0.020194] Initializing cgroup subsys net_cls
[    0.020546] Initializing cgroup subsys blkio
[    0.020879] Initializing cgroup subsys perf_event
[    0.021234] Initializing cgroup subsys hugetlb
[    0.021603] CPU: Physical Processor ID: 0
[    0.021920] CPU: Processor Core ID: 0
[    0.022220] mce: CPU supports 9 MCE banks
[    0.022553] CPU0: Thermal monitoring enabled (TM1)
[    0.022921] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.022921] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.022921] tlb_flushall_shift: 6
[    0.024039] Freeing SMP alternatives memory: 32K (ffffffff81f65000 - ffffffff81f6d000)
[    0.025755] ftrace: allocating 30751 entries in 121 pages
[    0.041060] Getting VERSION: 1060015
[    0.041357] Getting VERSION: 1060015
[    0.041658] Getting ID: 0
[    0.041896] Getting ID: 0
[    0.042139] enabled ExtINT on CPU#0
[    0.042742] ENABLING IO-APIC IRQs
[    0.043018] init IO_APIC IRQs
[    0.043275]  apic 1 pin 0 not connected
[    0.043592] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.044172] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044759] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.045340] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.045919] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.046499] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.047078] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.047658] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.048235] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.048817] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.049407] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.049996] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.050585] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.051171] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.051763] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.052353]  apic 1 pin 16 not connected
[    0.052665]  apic 1 pin 17 not connected
[    0.052975]  apic 1 pin 18 not connected
[    0.053285]  apic 1 pin 19 not connected
[    0.053597]  apic 1 pin 20 not connected
[    0.053908]  apic 1 pin 21 not connected
[    0.054219]  apic 1 pin 22 not connected
[    0.054530]  apic 1 pin 23 not connected
[    0.054982] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065419] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
[    0.066263] Using local APIC timer interrupts.
[    0.066263] calibrating APIC timer ...
[    0.168568] ... lapic delta = 831240
[    0.168860] ... PM-Timer delta = 357949
[    0.169166] ... PM-Timer result ok
[    0.169449] ..... delta 831240
[    0.169711] ..... mult: 35701486
[    0.169983] ..... calibration result: 132998
[    0.170314] ..... CPU clock speed is 2393.0971 MHz.
[    0.170679] ..... host bus clock speed is 132.0998 MHz.
[    0.171098] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.171904] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.172384] ... version:                3
[    0.172701] ... bit width:              48
[    0.173022] ... generic registers:      4
[    0.173339] ... value mask:             0000ffffffffffff
[    0.173729] ... max period:             000000007fffffff
[    0.174119] ... fixed-purpose events:   3
[    0.174435] ... event mask:             000000070000000f
[    0.176535] x86: Booting SMP configuration:
[    0.176863] .... node  #0, CPUs:      #1
[    0.188346] masked ExtINT on CPU#1
[    0.190758] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.191450]  #2
[    0.202609] masked ExtINT on CPU#2
[    0.205051]  #3
[    0.216212] masked ExtINT on CPU#3
[    0.218553] x86: Booted up 1 node, 4 CPUs
[    0.218868] smpboot: Total of 4 processors activated (19151.43 BogoMIPS)
[    0.221748] devtmpfs: initialized
[    0.224362] evm: security.selinux
[    0.224638] evm: security.ima
[    0.224895] evm: security.capability
[    0.225320] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
[    0.225905] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
[    0.226492] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
[    0.227064] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
[    0.227637] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
[    0.229268] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.229810] NET: Registered protocol family 16
[    0.230356] cpuidle: using governor menu
[    0.230785] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.231346] ACPI: bus type PCI registered
[    0.231662] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.232179] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.232836] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.233811] PCI: Using configuration type 1 for base access
[    0.237382] ACPI: Added _OSI(Module Device)
[    0.237712] ACPI: Added _OSI(Processor Device)
[    0.238056] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.238412] ACPI: Added _OSI(Processor Aggregator Device)
[    0.240152] ACPI : EC: EC description table is found, configuring boot EC
[    0.244584] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.320695] ACPI: Dynamic OEM Table Load:
[    0.321119] ACPI: SSDT 0xFFFF88006AED0800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
[    0.322287] ACPI: Dynamic OEM Table Load:
[    0.322713] ACPI: SSDT 0xFFFF88006AED1000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
[    0.328001] ACPI: Dynamic OEM Table Load:
[    0.328423] ACPI: SSDT 0xFFFF88006AE45400 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
[    0.331135] ACPI: Dynamic OEM Table Load:
[    0.331557] ACPI: SSDT 0xFFFF88006A820000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
[    0.336168] ACPI: Interpreter enabled
[    0.336470] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.337223] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.337987] ACPI: (supports S0 S3 S4 S5)
[    0.338298] ACPI: Using IOAPIC for interrupt routing
[    0.338692] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.344960] ACPI: Power Resource [PUBS] (on)
[    0.346005] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.348058] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.350486] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.351526] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.352542] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.353783] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.354818] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.355833] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.357055] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.358293] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.359321] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.359749] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.360347] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.360855] PCI host bridge to bus 0000:ff
[    0.361178] pci_bus 0000:ff: root bus resource [bus ff]
[    0.361569] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.362053] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.362527] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.362996] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.363464] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.363936] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.364430] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.364874] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.365623] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.366194] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.366849] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.367419] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.368565] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.369181] PCI host bridge to bus 0000:00
[    0.369505] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.369908] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.370347] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.370788] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.371268] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.371747] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.372227] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
[    0.372705] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.373192] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.373636] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.374246] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.374687] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.375168] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.375710] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
[    0.376222] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.376677] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
[    0.377242] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.377745] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.378197] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
[    0.378612] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
[    0.379221] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    0.379674] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
[    0.380128] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
[    0.380580] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
[    0.381075] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.381547] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.382002] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.382454] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
[    0.383006] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.383477] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.383932] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.384385] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.384966] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.385441] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.385893] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.386427] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.386902] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.387352] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.387891] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.388364] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.388816] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.389350] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.389825] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.390276] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.390812] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.391286] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.391744] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.392201] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
[    0.392752] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.393226] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.393672] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.394233] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    0.394835] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    0.395288] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.395703] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
[    0.396119] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
[    0.396532] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
[    0.396948] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.397363] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
[    0.397873] pci 0000:00:1f.2: PME# supported from D3hot
[    0.398328] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.398776] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
[    0.399281] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
[    0.399773] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.400233] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
[    0.400910] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.401387] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
[    0.401861] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.402536] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.404822] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.405199] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.405770] acpiphp: Slot [1] registered
[    0.406091] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.406478] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.406918] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.407396] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.408100] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
[    0.408595] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.409158] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
[    0.409823] pci 0000:0d:00.0: supports D1 D2
[    0.410156] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.410797] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
[    0.411299] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
[    0.411955] pci 0000:0d:00.1: supports D1 D2
[    0.412285] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.412922] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
[    0.413423] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
[    0.414082] pci 0000:0d:00.3: supports D1 D2
[    0.414414] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.416885] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.417268] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.417832] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
[    0.418318] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.418899] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.419479] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.420099] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.420718] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.421339] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
[    0.421958] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
[    0.422780] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    0.424589] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.425112] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.425714] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.426303] vgaarb: loaded
[    0.426546] vgaarb: bridge control possible 0000:00:02.0
[    0.427023] SCSI subsystem initialized
[    0.427353] ACPI: bus type USB registered
[    0.427689] usbcore: registered new interface driver usbfs
[    0.428094] usbcore: registered new interface driver hub
[    0.428523] usbcore: registered new device driver usb
[    0.428922] pps_core: LinuxPPS API ver. 1 registered
[    0.429294] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.429941] PTP clock support registered
[    0.430318] PCI: Using ACPI for IRQ routing
[    0.440468] PCI: pci_cache_line_size set to 64 bytes
[    0.441006] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.441435] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
[    0.441863] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
[    0.442293] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
[    0.442722] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
[    0.443150] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
[    0.443579] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
[    0.444116] NetLabel: Initializing
[    0.444400] NetLabel:  domain hash size = 128
[    0.444734] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.445118] NetLabel:  unlabeled traffic allowed by default
[    0.445648] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.446539] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.448993] Switched to clocksource hpet
[    0.458730] pnp: PnP ACPI init
[    0.459025] ACPI: bus type PNP registered
[    0.460785] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.461279] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.461764] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.462254] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.462718] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.463188] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.463672] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.464162] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.464646] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.465136] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.465620] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.466110] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.466594] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
[    0.467084] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.467568] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.468059] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.468851] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.469285] system 00:01: [io  0x1000-0x107f] could not be reserved
[    0.469727] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.470158] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.470582] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.471013] system 00:01: [io  0x1600-0x1641] has been reserved
[    0.471438] system 00:01: [io  0x1644-0x167f] could not be reserved
[    0.471883] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.472353] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.472818] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.473287] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.473751] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.474222] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.474687] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.475205] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    0.475813] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.476288] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
[    0.477484] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.477950] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
[    0.478569] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.479409] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.480577] pnp: PnP ACPI: found 6 devices
[    0.480899] ACPI: bus type PNP unregistered
[    0.488028] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.488414] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.488787] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.489275] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.489660] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.490104] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.490578] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.491156] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.491529] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.492008] pci 0000:00:1e.0: PCI bridge to [bus 0e]
[    0.492395] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.492797] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.493206] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.493647] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.494095] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.494538] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.494980] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.495434] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.495877] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.496287] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.496730] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.497273] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.497716] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.498127] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.498532] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.498975] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.499424] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.499867] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.500315] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.500789] NET: Registered protocol family 2
[    0.501309] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.501903] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.502449] TCP: Hash tables configured (established 16384 bind 16384)
[    0.502935] TCP: reno registered
[    0.503219] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.503662] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.504180] NET: Registered protocol family 1
[    0.504618] RPC: Registered named UNIX socket transport module.
[    0.505058] RPC: Registered udp transport module.
[    0.505413] RPC: Registered tcp transport module.
[    0.505767] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.506252] pci 0000:00:02.0: Boot video device
[    0.506683] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    0.507407] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    0.508141] PCI: CLS 64 bytes, default 64
[    0.508518] Unpacking initramfs...
[    3.226501] Freeing initrd memory: 146088K (ffff88006e3d2000 - ffff88007727c000)
[    3.227246] Simple Boot Flag at 0x35 set to 0x1
[    3.228504] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.228979] Initialise system trusted keyring
[    3.229333] audit: initializing netlink subsys (disabled)
[    3.229775] audit: type=2000 audit(1405660735.045:1): initialized
[    3.230539] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.232497] zbud: loaded
[    3.232921] VFS: Disk quotas dquot_6.5.2
[    3.233269] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.234244] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    3.235243] 9p: Installing v9fs 9p2000 file system support
[    3.235672] msgmni has been set to 3718
[    3.236057] Key type big_key registered
[    3.236364] SELinux:  Registering netfilter hooks
[    3.237847] alg: No test for stdrng (krng)
[    3.238179] NET: Registered protocol family 38
[    3.238528] Key type asymmetric registered
[    3.238864] Asymmetric key parser 'x509' registered
[    3.239276] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    3.239893] io scheduler noop registered
[    3.240208] io scheduler deadline registered (default)
[    3.240612] io scheduler cfq registered
[    3.241122] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    3.241855] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    3.242746] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.243164] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.243672] intel_idle: MWAIT substates: 0x1120
[    3.244026] intel_idle: v0.4 model 0x25
[    3.244332] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.245520] ACPI: AC Adapter [AC] (on-line)
[    3.246015] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    3.247641] ACPI: Lid Switch [LID]
[    3.248039] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    3.248646] ACPI: Sleep Button [SLPB]
[    3.249039] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    3.249588] ACPI: Power Button [PWRF]
[    3.255451] thermal LNXTHERM:00: registered as thermal_zone0
[    3.255886] ACPI: Thermal Zone [THM0] (53 C)
[    3.256275] GHES: HEST is not enabled!
[    3.256701] ACPI: Battery Slot [BAT0] (battery absent)
[    3.256937] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.258006] IOAPIC[0]: Set routing entry (1-17 -> 0x81 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    3.258932] console [ttyS0] disabled
[    3.279759] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
[    5.102489] tsc: Refined TSC clocksource calibration: 2394.001 MHz
[    5.102498] console [ttyS0] enabled
[    5.103478] Non-volatile memory driver v1.3
[    5.103501] Linux agpgart interface v0.103
[    5.103659] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    5.103699] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    5.117264] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    5.120529] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.124419] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    5.162028] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
[    5.165520] IOAPIC[0]: Set routing entry (1-16 -> 0x91 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    5.169095] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
[    5.172590] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140424/utaddress-258)
[    5.179271] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.184345] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
[    5.192037] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.196476] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
[    5.204133] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.208455] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
[    5.216274] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.220534] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.223017] rdac: device handler registered
[    5.225077] hp_sw: device handler registered
[    5.227002] emc: device handler registered
[    5.228810] alua: device handler registered
[    5.230747] libphy: Fixed MDIO Bus: probed
[    5.232652] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.236256] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.238529] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.240840] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    5.244209] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    5.248189] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    5.432445] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
[    5.436105] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.438729] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    5.442158] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    5.444753] igb: Copyright (c) 2007-2014 Intel Corporation.
[    5.447908] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    5.450739] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    5.454049] usbcore: registered new interface driver catc
[    5.456230] usbcore: registered new interface driver kaweth
[    5.458506] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    5.462101] usbcore: registered new interface driver pegasus
[    5.464398] usbcore: registered new interface driver rtl8150
[    5.466800] usbcore: registered new interface driver asix
[    5.468968] usbcore: registered new interface driver cdc_ether
[    5.472159] usbcore: registered new interface driver cdc_eem
[    5.474503] usbcore: registered new interface driver dm9601
[    5.476861] usbcore: registered new interface driver smsc75xx
[    5.479968] usbcore: registered new interface driver smsc95xx
[    5.482324] usbcore: registered new interface driver gl620a
[    5.484576] usbcore: registered new interface driver net1080
[    5.486989] usbcore: registered new interface driver plusb
[    5.490051] usbcore: registered new interface driver rndis_host
[    5.492379] usbcore: registered new interface driver cdc_subset
[    5.494815] usbcore: registered new interface driver zaurus
[    5.497960] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.500716] usbcore: registered new interface driver int51x1
[    5.503877] usbcore: registered new interface driver ipheth
[    5.506200] usbcore: registered new interface driver sierra_net
[    5.508743] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.512072] ehci-pci: EHCI PCI platform driver
[    5.514108] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    5.516445] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.519013] ehci-pci 0000:00:1a.0: debug port 2
[    5.525351] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    5.528404] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
[    5.536199] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.538937] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.541574] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.545053] usb usb1: Product: EHCI Host Controller
[    5.547172] usb usb1: Manufacturer: Linux 3.16.0-rc4-00051-ge59a094 ehci_hcd
[    5.549851] usb usb1: SerialNumber: 0000:00:1a.0
[    5.552316] hub 1-0:1.0: USB hub found
[    5.553749] hub 1-0:1.0: 3 ports detected
[    5.555937] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    5.558023] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.561493] ehci-pci 0000:00:1d.0: debug port 2
[    5.567338] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    5.570993] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
[    5.579288] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.581740] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.584992] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.587738] usb usb2: Product: EHCI Host Controller
[    5.589858] usb usb2: Manufacturer: Linux 3.16.0-rc4-00051-ge59a094 ehci_hcd
[    5.593347] usb usb2: SerialNumber: 0000:00:1d.0
[    5.595731] hub 2-0:1.0: USB hub found
[    5.597216] hub 2-0:1.0: 3 ports detected
[    5.599338] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.601624] ohci-pci: OHCI PCI platform driver
[    5.603580] uhci_hcd: USB Universal Host Controller Interface driver
[    5.607000] usbcore: registered new interface driver usbserial
[    5.609341] usbcore: registered new interface driver usbserial_generic
[    5.611842] usbserial: USB Serial support registered for generic
[    5.615127] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.622072] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.623975] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.626585] mousedev: PS/2 mouse device common for all mice
[    5.629117] rtc_cmos 00:02: RTC can wake from S4
[    5.630914] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.632976] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.633056] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    5.640495] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    5.642846] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
[    5.646471] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.648730] iTCO_vendor_support: vendor-support=0
[    5.651461] hidraw: raw HID events driver (C) Jiri Kosina
[    5.655047] usbcore: registered new interface driver usbhid
[    5.657095] usbhid: USB HID core driver
[    5.658990] drop_monitor: Initializing network drop monitor service
[    5.661577] TCP: cubic registered
[    5.663152] Initializing XFRM netlink socket
[    5.665356] NET: Registered protocol family 10
[    5.667502] NET: Registered protocol family 17
[    5.669124] 9pnet: Installing 9P2000 support
[    5.671789] 
[    5.671789] printing PIC contents
[    5.674116] ... PIC  IMR: ffff
[    5.674987] ... PIC  IRR: 0800
[    5.676662] ... PIC  ISR: 0000
[    5.678199] ... PIC ELCR: 0a00
[    5.679895] printing local APIC contents on CPU#0/0:
[    5.681933] ... APIC ID:      00000000 (0)
[    5.683848] ... APIC VERSION: 01060015
[    5.684856] ... APIC TASKPRI: 00000000 (00)
[    5.686851] ... APIC PROCPRI: 00000000
[    5.688519] ... APIC LDR: 01000000
[    5.690283] ... APIC DFR: ffffffff
[    5.692036] ... APIC SPIV: 000001ff
[    5.693793] ... APIC ISR field:
[    5.694647] 0000000000000000000000000000000000000000000000000000000000000000
[    5.698241] ... APIC TMR field:
[    5.699791] 0000000002000000000000000000000000000000000000000000000000000000
[    5.702659] ... APIC IRR field:
[    5.704101] 0000000010000000000000000000000000000000000000000000000000000000
[    5.707171] ... APIC ESR: 00000000
[    5.708532] ... APIC ICR: 000008fd
[    5.710252] ... APIC ICR2: 02000000
[    5.712004] ... APIC LVTT: 000000ef
[    5.712899] ... APIC LVTPC: 00000400
[    5.714612] ... APIC LVT0: 00010700
[    5.716486] ... APIC LVT1: 00000400
[    5.718178] ... APIC LVTERR: 000000fe
[    5.719974] ... APIC TMICT: 003fc2de
[    5.721062] ... APIC TMCCT: 00397ada
[    5.722630] ... APIC TDCR: 00000003
[    5.724409] 
[    5.724877] number of MP IRQ sources: 15.
[    5.726811] number of IO-APIC #1 registers: 24.
[    5.728778] testing the IO APIC.......................
[    5.731009] IO APIC #1......
[    5.732554] .... register #00: 02000000
[    5.734322] .......    : physical APIC id: 02
[    5.736419] .......    : Delivery Type: 0
[    5.738181] .......    : LTS          : 0
[    5.740143] .... register #01: 00170020
[    5.741948] .......     : max redirection entries: 17
[    5.744093] .......     : PRQ implemented: 0
[    5.746125] .......     : IO APIC version: 20
[    5.748011] .... IRQ redirection table:
[    5.749879] 1    0    0   0   0    0    0    00
[    5.751902] 0    0    0   0   0    1    1    31
[    5.753905] 0    0    0   0   0    1    1    30
[    5.755969] 0    0    0   0   0    1    1    33
[    5.757956] 0    0    0   0   0    1    1    34
[    5.759969] 0    0    0   0   0    1    1    35
[    5.761996] 0    0    0   0   0    1    1    36
[    5.764036] 0    0    0   0   0    1    1    37
[    5.766163] 0    0    0   0   0    1    1    38
[    5.768085] 0    1    0   0   0    1    1    39
[    5.770086] 0    0    0   0   0    1    1    3A
[    5.772089] 0    0    0   0   0    1    1    3B
[    5.774113] 0    0    0   0   0    1    1    3C
[    5.776258] 0    0    0   0   0    1    1    3D
[    5.778169] 0    0    0   0   0    1    1    3E
[    5.780206] 0    0    0   0   0    1    1    3F
[    5.782216] 1    1    0   1   0    1    1    91
[    5.784248] 1    1    0   1   0    1    1    81
[    5.786353] 1    0    0   0   0    0    0    00
[    5.788300] 0    1    0   1   0    1    1    51
[    5.790302] 1    1    0   1   0    1    1    61
[    5.792354] 1    1    0   1   0    1    1    71
[    5.794421] 1    0    0   0   0    0    0    00
[    5.796442] 0    1    0   1   0    1    1    41
[    5.798474] IRQ to pin mappings:
[    5.800091] IRQ0 -> 0:2
[    5.801001] IRQ1 -> 0:1
[    5.802352] IRQ3 -> 0:3
[    5.803173] IRQ4 -> 0:4
[    5.804449] IRQ5 -> 0:5
[    5.805834] IRQ6 -> 0:6
[    5.806716] IRQ7 -> 0:7
[    5.807976] IRQ8 -> 0:8
[    5.808846] IRQ9 -> 0:9
[    5.810130] IRQ10 -> 0:10
[    5.811053] IRQ11 -> 0:11
[    5.812413] IRQ12 -> 0:12
[    5.813251] IRQ13 -> 0:13
[    5.814555] IRQ14 -> 0:14
[    5.816086] IRQ15 -> 0:15
[    5.816916] IRQ16 -> 0:16
[    5.818311] IRQ17 -> 0:17
[    5.819207] IRQ19 -> 0:19
[    5.820487] IRQ20 -> 0:20
[    5.821949] IRQ21 -> 0:21
[    5.822803] IRQ23 -> 0:23
[    5.824259] .................................... done.
[    5.827017] Loading compiled-in X.509 certificates
[    5.830431] Loaded X.509 cert 'Magrathea: Glacier signing key: 284701a18fb7882416111cb0174bd80ca4358dff'
[    5.834611] registered taskstats version 1
[    5.840653] Key type trusted registered
[    5.846101] Key type encrypted registered
[    5.857437] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
[    5.857485] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    5.863324] ima: No TPM chip found, activating TPM-bypass!
[    5.865646] evm: HMAC attrs: 0x1
[    5.868289] rtc_cmos 00:02: setting system clock to 2014-07-18 05:18:58 UTC (1405660738)
[    5.978262] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    5.980565] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    5.982677] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.986786] hub 1-1:1.0: USB hub found
[    5.988355] hub 1-1:1.0: 6 ports detected
[    6.081606] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    6.083280] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.093516] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    6.117698] Switched to clocksource tsc
[    6.210986] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    6.213195] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.217159] hub 2-1:1.0: USB hub found
[    6.218726] hub 2-1:1.0: 8 ports detected
[    6.294765] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
[    6.384223] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    6.387487] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.390172] usb 1-1.3: Product: Biometric Coprocessor
[    6.392380] usb 1-1.3: Manufacturer: UPEK
[    6.468008] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    6.562800] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[    6.565247] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.568852] usb 1-1.6: Product: Integrated Camera
[    6.570965] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    6.625561] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
[    6.631231] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.685016] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[    9.002821] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
[    9.012403] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    9.023376] Sending DHCP requests ., OK
[    9.066374] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
[    9.070090] IP-Config: Complete:
[    9.071093]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
[    9.077120]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
[    9.079392]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[    9.082832]      nameserver0=192.168.1.1
[    9.084953] PM: Hibernation image not present or could not be loaded.
[    9.089088] Freeing unused kernel memory: 1792K (ffffffff81da5000 - ffffffff81f65000)
[    9.371858] [drm] Initialized drm 1.1.0 20060810
[    9.409289] Linux video capture interface: v2.00
[    9.429785] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    9.435712] wmi: Mapper loaded
[    9.471179] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[    9.475607] libata version 3.00 loaded.
[    9.502770] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
[    9.508881] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    9.508972] sdhci: Secure Digital Host Controller Interface driver
[    9.508973] sdhci: Copyright(c) Pierre Ossman
[    9.515803] thinkpad_acpi: http://ibm-acpi.sf.net/
[    9.518665] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
[    9.521351] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
[    9.528968] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    9.532041] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    9.544771] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[    9.544956] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[    9.545237] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    9.545245] mmc0: no vqmmc regulator found
[    9.545246] mmc0: no vmmc regulator found
[    9.550193] [drm] Memory usable by graphics device = 2048M
[    9.550195] [drm] Replacing VGA console driver
[    9.563401] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    9.563910] Console: switching to colour dummy device 80x25
[    9.564395] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[    9.573262] thinkpad_acpi: radio switch found; radios are disabled
[    9.576013] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    9.578272] ------------[ cut here ]------------
[    9.578336] WARNING: CPU: 2 PID: 255 at drivers/gpu/drm/i915/intel_pm.c:4994 intel_disable_gt_powersave+0x416/0x420 [i915]()
[    9.578370] Modules linked in: libahci sdhci_pci uvcvideo(+) firewire_ohci(+) i915(+) videobuf2_vmalloc pcspkr sdhci thinkpad_acpi(+) parport_pc videobuf2_memops videobuf2_core firewire_core snd_timer mmc_core crc_itu_t parport rfkill video v4l2_common snd libata drm_kms_helper soundcore wmi intel_ips i2c_i801 videodev drm acpi_cpufreq
[    9.578375] CPU: 2 PID: 255 Comm: modprobe Not tainted 3.16.0-rc4-00051-ge59a094 #1
[    9.578377] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.578383]  0000000000000009 ffff8800769c7908 ffffffff8182b6d0 0000000000000000
[    9.578387]  ffff8800769c7940 ffffffff8106d0dd ffff8800762e0000 ffff8800762e0000
[    9.578392]  ffff880074da0000 ffff88005a184c60 ffffffffa028c7e0 ffff8800769c7950
[    9.578393] Call Trace:
[    9.578404]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.578412]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.578417]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.578465]  [<ffffffffa0206d66>] intel_disable_gt_powersave+0x416/0x420 [i915]
[    9.578527]  [<ffffffffa023e94e>] intel_uncore_sanitize+0xe/0x10 [i915]
[    9.578595]  [<ffffffffa0285f66>] i915_driver_load+0x296/0xfe0 [i915]
[    9.578603]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.578609]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.578614]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.578620]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.578624]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.578664]  [<ffffffffa003f176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.578688]  [<ffffffffa003b78d>] drm_dev_register+0xad/0x100 [drm]
[    9.578714]  [<ffffffffa003e26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.578760]  [<ffffffffa01f856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.578766]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.578771]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.578776]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.578781]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.578785]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.578789]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.578793]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.578797]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.578801]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.578805]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.578810]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.578835]  [<ffffffffa003e4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.578840]  [<ffffffffa02dd000>] ? 0xffffffffa02dcfff
[    9.578887]  [<ffffffffa02dd089>] i915_init+0x89/0x90 [i915]
[    9.578893]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.578898]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.578904]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.578910]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.578915]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.578923]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.578930]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.578933] ---[ end trace c1903d8690cfe527 ]---
[    9.634016] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
[    9.634213] usbcore: registered new interface driver uvcvideo
[    9.634215] USB Video Class driver (1.1.1)
[    9.634895] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    9.634913] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    9.634914] [drm] Driver supports precise vblank timestamp query.
[    9.635560] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.701973] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    9.743064] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    9.756143] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[    9.759627] Error: Driver 'pcspkr' is already registered, aborting...
[    9.767026] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    9.770087] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    9.775343] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[    9.835818] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    9.848719] fbcon: inteldrmfb (fb0) is primary device
[   10.247262] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
[   10.389264] Console: switching to colour frame buffer device 160x50
[   10.402367] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   10.405691] i915 0000:00:02.0: registered panic notifier
[   10.422584] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   10.429010] acpi device:01: registered as cooling_device4
[   10.431778] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   10.435940] [drm] Initialized i915 1.6.0 20140620 for 0000:00:02.0 on minor 0
[   10.438444] ahci 0000:00:1f.2: version 3.0
[   10.440524] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[   10.442334] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[   10.445838] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[   10.449711] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
[   10.460455] scsi0 : ahci
[   10.461430] scsi1 : ahci
[   10.463184] scsi2 : ahci
[   10.464073] scsi3 : ahci
[   10.465411] scsi4 : ahci
[   10.466796] scsi5 : ahci
[   10.467602] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 43
[   10.470872] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 43
[   10.473633] ata3: DUMMY
[   10.475205] ata4: DUMMY
[   10.476621] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 43
[   10.479391] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 43
[   10.485466] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   10.511332] sound hdaudioC0D0: CX20585: BIOS auto-probing.
[   10.516285] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[   10.522440] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   10.527179] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   10.532649] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
[   10.537948] sound hdaudioC0D0:    mono: mono_out=0x0
[   10.542089] sound hdaudioC0D0:    inputs:
[   10.545955] sound hdaudioC0D0:      Mic=0x1b
[   10.550017] sound hdaudioC0D0:      Internal Mic=0x23
[   10.554079] sound hdaudioC0D0:      Dock Mic=0x1a
[   10.559916] sound hdaudioC0D0: Enable sync_write for stable communication
[   10.580740] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   10.585972] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   10.591814] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   10.598856] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   10.604941] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   10.610982] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   10.617174] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[   10.950579] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   10.956212] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   10.960994] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   10.966912] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[   10.971440] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   10.978740] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
[   10.982583] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   10.990109] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   10.994706] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   11.000023] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[   11.005078] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   11.011551] ata1.00: configured for UDMA/100
[   11.015046] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
[   11.480940] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.493438] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   11.502271] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   11.507519] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
[   11.524585] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   11.533664] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   11.539635] ata2.00: configured for UDMA/100
[   11.558921] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
[   11.891190] ata5: SATA link down (SStatus 0 SControl 300)
[   12.136171] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   12.199362] ata6: SATA link down (SStatus 0 SControl 300)
[   12.227799] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   12.232397] sd 0:0:0:0: [sda] Write Protect is off
[   12.237171] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.241381] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.243809] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.243812] cdrom: Uniform CD-ROM driver Revision: 3.20
[   12.244110] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   12.267596] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   12.271590] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   12.416392] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
[   12.680669]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   12.686459] sd 0:0:0:0: [sda] Attached SCSI disk
[   12.851941] random: nonblocking pool is initialized
[   13.850098] fuse init (API version 7.23)
[   14.403161] device-mapper: uevent: version 1.0.3
[   14.411296] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   14.746048] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
[   24.350953] ipmi message handler version 39.2
[   24.361201] IPMI Watchdog: driver initialized
<6>
[    0.000000] Initializing cgroup subsys cpuset
<6>
[    0.000000] Initializing cgroup subsys cpu
<5>
[    0.000000] Linux version 3.16.0-rc4-00051-ge59a094 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Fri Jul 18 13:15:30 CST 2014
<6>
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-e59a094c9058421e4af3b007b292b46a2fe7733c-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 kconfig=x86_64-rhel commit=e59a094c9058421e4af3b007b292b46a2fe7733c root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
<6>
[    0.000000] e820: BIOS-provided physical RAM map:
<6>
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007727bfff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000007727c000-0x0000000077281fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077282000-0x0000000077362fff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077363000-0x0000000077374fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077375000-0x00000000773f5fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x00000000773f6000-0x000000007740efff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x000000007740f000-0x000000007746efff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000007746f000-0x0000000077667fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077668000-0x00000000776e7fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x00000000776e8000-0x000000007770efff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x000000007770f000-0x0000000077716fff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077717000-0x000000007771efff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007776bfff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000007776c000-0x0000000077777fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077778000-0x000000007777afff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x000000007777b000-0x000000007778afff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x000000007778b000-0x000000007778bfff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x000000007778c000-0x000000007779efff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x000000007779f000-0x00000000777fefff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x00000000777ff000-0x00000000777fffff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077800000-0x000000007bffffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
<6>
[    0.000000] bootconsole [earlyser0] enabled
<6>
[    0.000000] NX (Execute Disable) protection: active
<6>
[    0.000000] SMBIOS 2.6 present.
<7>
[    0.000000] DMI: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<7>
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>
[    0.000000] AGP: No AGP bridge found
<6>
[    0.000000] e820: last_pfn = 0x77800 max_arch_pfn = 0x400000000
<7>
[    0.000000] MTRR default type: uncachable
<7>
[    0.000000] MTRR fixed ranges enabled:
<7>
[    0.000000]   00000-9FFFF write-back
<7>
[    0.000000]   A0000-BFFFF uncachable
<7>
[    0.000000]   C0000-D3FFF write-protect
<7>
[    0.000000]   D4000-DBFFF uncachable
<7>
[    0.000000]   DC000-FFFFF write-protect
<7>
[    0.000000] MTRR variable ranges enabled:
<7>
[    0.000000]   0 disabled
<7>
[    0.000000]   1 base 078000000 mask FF8000000 uncachable
<7>
[    0.000000]   2 base 000000000 mask F80000000 write-back
<7>
[    0.000000]   3 disabled
<7>
[    0.000000]   4 disabled
<7>
[    0.000000]   5 disabled
<7>
[    0.000000]   6 disabled
<7>
[    0.000000]   7 disabled
<6>
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<4>
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>
[    0.000000] found SMP MP-table at [mem 0x000f68c0-0x000f68cf] mapped at [ffff8800000f68c0]
<4>
[    0.000000]   mpc: 9f071-9f17d
<7>
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
<6>
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>
[    0.000000] BRK [0x02144000, 0x02144fff] PGTABLE
<7>
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
<7>
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x6e000000-0x6e1fffff]
<7>
[    0.000000]  [mem 0x6e000000-0x6e1fffff] page 2M
<7>
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6dffffff]
<7>
[    0.000000]  [mem 0x6c000000-0x6dffffff] page 2M
<6>
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
<7>
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>
[    0.000000]  [mem 0x00200000-0x6bffffff] page 2M
<6>
[    0.000000] init_memory_mapping: [mem 0x6e200000-0x7727bfff]
<7>
[    0.000000]  [mem 0x6e200000-0x771fffff] page 2M
<7>
[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
<7>
[    0.000000] BRK [0x02148000, 0x02148fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
<7>
[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
<7>
[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
<7>
[    0.000000] BRK [0x02149000, 0x02149fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
<7>
[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
<7>
[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
<7>
[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
<6>
[    0.000000] RAMDISK: [mem 0x6e3d2000-0x7727bfff]
<6>
[    0.000000] ACPI: Early table checksum verification disabled
<4>
[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
<4>
[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>
[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140424/tbfadt-618)
<4>
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140424/tbfadt-699)
<4>
[    0.000000] ACPI: DSDT 0x00000000777EFED1 00ECE9 (v01 LENOVO TP-6I    00001120 MSFT 03000001)
<4>
[    0.000000] ACPI: FACS 0x00000000776E7000 000040
<4>
[    0.000000] ACPI: SSDT 0x00000000777EFCB4 00021D (v01 LENOVO TP-6I    00001120 MSFT 03000001)
<4>
[    0.000000] ACPI: ECDT 0x00000000777FEBBA 000052 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: APIC 0x00000000777FEC0C 000084 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: MCFG 0x00000000777FECC8 00003C (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: HPET 0x00000000777FED04 000038 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: ASF! 0x00000000777FEDBE 0000A4 (v16 LENOVO TP-6I    00001120 PTL  00000001)
<4>
[    0.000000] ACPI: SLIC 0x00000000777FEE62 000176 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>
[    0.000000] ACPI: BOOT 0x00000000777FEFD8 000028 (v01 LENOVO TP-6I    00001120  LTP 00000001)
<4>
[    0.000000] ACPI: SSDT 0x00000000776E591A 00084B (v01 LENOVO TP-6I    00001120 INTL 20050513)
<4>
[    0.000000] ACPI: TCPA 0x000000007778B000 000032 (v02 PTL     CRESTLN 06040000      00005A52)
<4>
[    0.000000] ACPI: SSDT 0x000000007777A000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20050513)
<4>
[    0.000000] ACPI: SSDT 0x0000000077779000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20050513)
<4>
[    0.000000] ACPI: SSDT 0x0000000077778000 00049F (v01 PmRef  ApTst    00003000 INTL 20050513)
<7>
[    0.000000] ACPI: Local APIC address 0xfee00000
<4>
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>
[    0.000000] No NUMA configuration found
<6>
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000777fffff]
<6>
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x777fffff]
<6>
[    0.000000]   NODE_DATA [mem 0x77745000-0x7776bfff]
<7>
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff88006bc00000-ffff88006d9fffff] on node 0
<4>
[    0.000000] Zone ranges:
<4>
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>
[    0.000000]   Normal   empty
<4>
[    0.000000] Movable zone start for each node
<4>
[    0.000000] Early memory node ranges
<4>
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
<4>
[    0.000000]   node   0: [mem 0x00100000-0x7727bfff]
<4>
[    0.000000]   node   0: [mem 0x77282000-0x77362fff]
<4>
[    0.000000]   node   0: [mem 0x7740f000-0x7746efff]
<4>
[    0.000000]   node   0: [mem 0x7770f000-0x77716fff]
<4>
[    0.000000]   node   0: [mem 0x7771f000-0x7776bfff]
<4>
[    0.000000]   node   0: [mem 0x777ff000-0x777fffff]
<7>
[    0.000000] On node 0 totalpages: 488368
<7>
[    0.000000]   DMA zone: 64 pages used for memmap
<7>
[    0.000000]   DMA zone: 21 pages reserved
<7>
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>
[    0.000000]   DMA32 zone: 7584 pages used for memmap
<7>
[    0.000000]   DMA32 zone: 484371 pages, LIFO batch:31
<6>
[    0.000000] Reserving Intel graphics stolen memory at 0x7a000000-0x7bffffff
<6>
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
<7>
[    0.000000] ACPI: Local APIC address 0xfee00000
<4>
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
<6>
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
<6>
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 1, APIC INT 02
<6>
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 1, APIC INT 09
<7>
[    0.000000] ACPI: IRQ0 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 1, APIC INT 01
<7>
[    0.000000] ACPI: IRQ2 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 1, APIC INT 03
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 1, APIC INT 04
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 1, APIC INT 05
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 1, APIC INT 06
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 1, APIC INT 07
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 1, APIC INT 08
<7>
[    0.000000] ACPI: IRQ9 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 1, APIC INT 0a
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 1, APIC INT 0b
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 1, APIC INT 0c
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 1, APIC INT 0d
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 1, APIC INT 0e
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 1, APIC INT 0f
<6>
[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
<6>
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
<4>
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<7>
[    0.000000] nr_irqs_gsi: 40
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7727c000-0x77281fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77363000-0x77374fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77375000-0x773f5fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x773f6000-0x7740efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7746f000-0x77667fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77668000-0x776e7fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x776e8000-0x7770efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77717000-0x7771efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7776c000-0x77777fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77778000-0x7777afff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7777b000-0x7778afff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7778b000-0x7778bfff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7778c000-0x7779efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7779f000-0x777fefff]
<6>
[    0.000000] e820: [mem 0x7c000000-0xdfffffff] available for PCI devices
<6>
[    0.000000] Booting paravirtualized kernel on bare hardware
<6>
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
<6>
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88006e000000 s87552 r8192 d23040 u524288
<7>
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=1*2097152
<7>
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<4>
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
<4>
[    0.000000] Policy zone: DMA32
<5>
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-e59a094c9058421e4af3b007b292b46a2fe7733c-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/vmlinuz-3.16.0-rc4-00051-ge59a094 kconfig=x86_64-rhel commit=e59a094c9058421e4af3b007b292b46a2fe7733c root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/e59a094c9058421e4af3b007b292b46a2fe7733c/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
<6>
[    0.000000] sysrq: sysrq always enabled.
<6>
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.000000] AGP: Checking aperture...
<6>
[    0.000000] AGP: No AGP bridge found
<4>
[    0.000000] Memory: 1757992K/1953472K available (8421K kernel code, 1656K rwdata, 3876K rodata, 1792K init, 1876K bss, 195480K reserved)
<6>
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>
[    0.000000] Hierarchical RCU implementation.
<6>
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
<6>
[    0.000000] 	Offload RCU callbacks from all CPUs
<6>
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
<6>
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
<6>
[    0.000000] Console: colour VGA+ 80x25
<6>
[    0.000000] console [tty0] enabled
<6>
[    0.000000] bootconsole [earlyser0] disabled
<6>
[    0.000000] console [ttyS0] enabled
<6>
[    0.000000] allocated 7864320 bytes of page_cgroup
<6>
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>
[    0.000000] hpet clockevent registered
<6>
[    0.000000] tsc: Fast TSC calibration using PIT
<6>
[    0.000000] tsc: Detected 2393.929 MHz processor
<6>
[    0.000033] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.85 BogoMIPS (lpj=2393929)
<6>
[    0.000743] pid_max: default: 32768 minimum: 301
<6>
[    0.001061] ACPI: Core revision 20140424
<4>
[    0.014567] ACPI: All ACPI Tables successfully acquired
<6>
[    0.015049] Security Framework initialized
<6>
[    0.015340] SELinux:  Initializing.
<7>
[    0.015601] SELinux:  Starting in permissive mode
<6>
[    0.016061] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>
[    0.017211] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
<6>
[    0.017962] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.018393] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.019131] Initializing cgroup subsys memory
<6>
[    0.019502] Initializing cgroup subsys devices
<6>
[    0.019850] Initializing cgroup subsys freezer
<6>
[    0.020194] Initializing cgroup subsys net_cls
<6>
[    0.020546] Initializing cgroup subsys blkio
<6>
[    0.020879] Initializing cgroup subsys perf_event
<6>
[    0.021234] Initializing cgroup subsys hugetlb
<6>
[    0.021603] CPU: Physical Processor ID: 0
<6>
[    0.021920] CPU: Processor Core ID: 0
<6>
[    0.022220] mce: CPU supports 9 MCE banks
<6>
[    0.022553] CPU0: Thermal monitoring enabled (TM1)
<6>
[    0.022921] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
<6>
[    0.022921] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>
[    0.022921] tlb_flushall_shift: 6
<6>
[    0.024039] Freeing SMP alternatives memory: 32K (ffffffff81f65000 - ffffffff81f6d000)
<6>
[    0.025755] ftrace: allocating 30751 entries in 121 pages
<4>
[    0.041060] Getting VERSION: 1060015
<4>
[    0.041357] Getting VERSION: 1060015
<4>
[    0.041658] Getting ID: 0
<4>
[    0.041896] Getting ID: 0
<4>
[    0.042139] enabled ExtINT on CPU#0
<4>
[    0.042742] ENABLING IO-APIC IRQs
<7>
[    0.043018] init IO_APIC IRQs
<7>
[    0.043275]  apic 1 pin 0 not connected
<7>
[    0.043592] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>
[    0.044172] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>
[    0.044759] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>
[    0.045340] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>
[    0.045919] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>
[    0.046499] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>
[    0.047078] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>
[    0.047658] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>
[    0.048235] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>
[    0.048817] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>
[    0.049407] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>
[    0.049996] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>
[    0.050585] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>
[    0.051171] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>
[    0.051763] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>
[    0.052353]  apic 1 pin 16 not connected
<7>
[    0.052665]  apic 1 pin 17 not connected
<7>
[    0.052975]  apic 1 pin 18 not connected
<7>
[    0.053285]  apic 1 pin 19 not connected
<7>
[    0.053597]  apic 1 pin 20 not connected
<7>
[    0.053908]  apic 1 pin 21 not connected
<7>
[    0.054219]  apic 1 pin 22 not connected
<7>
[    0.054530]  apic 1 pin 23 not connected
<6>
[    0.054982] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>
[    0.065419] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
<4>
[    0.066263] Using local APIC timer interrupts.
<4>
[    0.066263] calibrating APIC timer ...
<4>
[    0.168568] ... lapic delta = 831240
<4>
[    0.168860] ... PM-Timer delta = 357949
<4>
[    0.169166] ... PM-Timer result ok
<4>
[    0.169449] ..... delta 831240
<4>
[    0.169711] ..... mult: 35701486
<4>
[    0.169983] ..... calibration result: 132998
<4>
[    0.170314] ..... CPU clock speed is 2393.0971 MHz.
<4>
[    0.170679] ..... host bus clock speed is 132.0998 MHz.
<6>
[    0.171098] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
<4>
[    0.171904] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
<6>
[    0.172384] ... version:                3
<6>
[    0.172701] ... bit width:              48
<6>
[    0.173022] ... generic registers:      4
<6>
[    0.173339] ... value mask:             0000ffffffffffff
<6>
[    0.173729] ... max period:             000000007fffffff
<6>
[    0.174119] ... fixed-purpose events:   3
<6>
[    0.174435] ... event mask:             000000070000000f
<6>
[    0.176535] x86: Booting SMP configuration:
<6>
[    0.176863] .... node  #0, CPUs:      #1
<4>
[    0.188346] masked ExtINT on CPU#1
<6>
[    0.190758] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>
[    0.191450]  #2
<4>
[    0.202609] masked ExtINT on CPU#2
<4>
[    0.205051]  #3
<4>
[    0.216212] masked ExtINT on CPU#3
<6>
[    0.218553] x86: Booted up 1 node, 4 CPUs
<6>
[    0.218868] smpboot: Total of 4 processors activated (19151.43 BogoMIPS)
<6>
[    0.221748] devtmpfs: initialized
<6>
[    0.224362] evm: security.selinux
<6>
[    0.224638] evm: security.ima
<6>
[    0.224895] evm: security.capability
<6>
[    0.225320] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
<6>
[    0.225905] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
<6>
[    0.226492] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
<6>
[    0.227064] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
<6>
[    0.227637] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
<6>
[    0.229268] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>
[    0.229810] NET: Registered protocol family 16
<6>
[    0.230356] cpuidle: using governor menu
<6>
[    0.230785] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>
[    0.231346] ACPI: bus type PCI registered
<6>
[    0.231662] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>
[    0.232179] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>
[    0.232836] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>
[    0.233811] PCI: Using configuration type 1 for base access
<6>
[    0.237382] ACPI: Added _OSI(Module Device)
<6>
[    0.237712] ACPI: Added _OSI(Processor Device)
<6>
[    0.238056] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>
[    0.238412] ACPI: Added _OSI(Processor Aggregator Device)
<6>
[    0.240152] ACPI : EC: EC description table is found, configuring boot EC
<5>
[    0.244584] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<4>
[    0.320695] ACPI: Dynamic OEM Table Load:
<4>
[    0.321119] ACPI: SSDT 0xFFFF88006AED0800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
<4>
[    0.322287] ACPI: Dynamic OEM Table Load:
<4>
[    0.322713] ACPI: SSDT 0xFFFF88006AED1000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
<4>
[    0.328001] ACPI: Dynamic OEM Table Load:
<4>
[    0.328423] ACPI: SSDT 0xFFFF88006AE45400 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
<4>
[    0.331135] ACPI: Dynamic OEM Table Load:
<4>
[    0.331557] ACPI: SSDT 0xFFFF88006A820000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
<6>
[    0.336168] ACPI: Interpreter enabled
<4>
[    0.336470] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
<4>
[    0.337223] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
<6>
[    0.337987] ACPI: (supports S0 S3 S4 S5)
<6>
[    0.338298] ACPI: Using IOAPIC for interrupt routing
<6>
[    0.338692] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>
[    0.344960] ACPI: Power Resource [PUBS] (on)
<6>
[    0.346005] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
<6>
[    0.348058] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
<6>
[    0.350486] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.351526] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.352542] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>
[    0.353783] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.354818] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.355833] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>
[    0.357055] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>
[    0.358293] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.359321] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
<6>
[    0.359749] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>
[    0.360347] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>
[    0.360855] PCI host bridge to bus 0000:ff
<6>
[    0.361178] pci_bus 0000:ff: root bus resource [bus ff]
<7>
[    0.361569] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
<7>
[    0.362053] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
<7>
[    0.362527] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
<7>
[    0.362996] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
<7>
[    0.363464] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
<7>
[    0.363936] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
<6>
[    0.364430] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
<6>
[    0.364874] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>
[    0.365623] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
<6>
[    0.366194] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
<6>
[    0.366849] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
<6>
[    0.367419] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
<6>
[    0.368565] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
<6>
[    0.369181] PCI host bridge to bus 0000:00
<6>
[    0.369505] pci_bus 0000:00: root bus resource [bus 00-fe]
<6>
[    0.369908] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>
[    0.370347] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>
[    0.370788] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>
[    0.371268] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
<6>
[    0.371747] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
<6>
[    0.372227] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
<6>
[    0.372705] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
<7>
[    0.373192] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
<6>
[    0.373636] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
<7>
[    0.374246] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
<7>
[    0.374687] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
<7>
[    0.375168] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
<7>
[    0.375710] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
<7>
[    0.376222] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
<7>
[    0.376677] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
<7>
[    0.377242] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>
[    0.377745] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
<7>
[    0.378197] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
<7>
[    0.378612] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
<7>
[    0.379221] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
<7>
[    0.379674] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
<7>
[    0.380128] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
<7>
[    0.380580] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
<7>
[    0.381075] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>
[    0.381547] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>
[    0.382002] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
<7>
[    0.382454] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
<7>
[    0.383006] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>
[    0.383477] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>
[    0.383932] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
<7>
[    0.384385] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
<7>
[    0.384966] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>
[    0.385441] pci 0000:00:1b.0: System wakeup disabled by ACPI
<7>
[    0.385893] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
<7>
[    0.386427] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>
[    0.386902] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>
[    0.387352] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
<7>
[    0.387891] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<6>
[    0.388364] pci 0000:00:1c.1: System wakeup disabled by ACPI
<7>
[    0.388816] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
<7>
[    0.389350] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
<6>
[    0.389825] pci 0000:00:1c.3: System wakeup disabled by ACPI
<7>
[    0.390276] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
<7>
[    0.390812] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>
[    0.391286] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>
[    0.391744] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
<7>
[    0.392201] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
<7>
[    0.392752] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>
[    0.393226] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>
[    0.393672] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
<7>
[    0.394233] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
<7>
[    0.394835] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
<7>
[    0.395288] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
<7>
[    0.395703] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
<7>
[    0.396119] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
<7>
[    0.396532] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
<7>
[    0.396948] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
<7>
[    0.397363] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
<7>
[    0.397873] pci 0000:00:1f.2: PME# supported from D3hot
<7>
[    0.398328] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
<7>
[    0.398776] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
<7>
[    0.399281] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
<7>
[    0.399773] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
<7>
[    0.400233] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
<6>
[    0.400910] pci 0000:00:1c.0: PCI bridge to [bus 02]
<7>
[    0.401387] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
<7>
[    0.401861] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
<7>
[    0.402536] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
<6>
[    0.404822] pci 0000:00:1c.1: PCI bridge to [bus 03]
<7>
[    0.405199] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>
[    0.405770] acpiphp: Slot [1] registered
<6>
[    0.406091] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<7>
[    0.406478] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<7>
[    0.406918] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<7>
[    0.407396] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<7>
[    0.408100] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
<5>
[    0.408595] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
<7>
[    0.409158] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
<7>
[    0.409823] pci 0000:0d:00.0: supports D1 D2
<7>
[    0.410156] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>
[    0.410797] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
<7>
[    0.411299] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
<7>
[    0.411955] pci 0000:0d:00.1: supports D1 D2
<7>
[    0.412285] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
<7>
[    0.412922] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
<7>
[    0.413423] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
<7>
[    0.414082] pci 0000:0d:00.3: supports D1 D2
<7>
[    0.414414] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
<6>
[    0.416885] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<7>
[    0.417268] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>
[    0.417832] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
<7>
[    0.418318] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>
[    0.418899] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>
[    0.419479] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>
[    0.420099] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
<7>
[    0.420718] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
<7>
[    0.421339] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
<7>
[    0.421958] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
<7>
[    0.422780] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<4>
[    0.424589] ACPI: Enabled 3 GPEs in block 00 to 3F
<6>
[    0.425112] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
<6>
[    0.425714] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>
[    0.426303] vgaarb: loaded
<6>
[    0.426546] vgaarb: bridge control possible 0000:00:02.0
<5>
[    0.427023] SCSI subsystem initialized
<6>
[    0.427353] ACPI: bus type USB registered
<6>
[    0.427689] usbcore: registered new interface driver usbfs
<6>
[    0.428094] usbcore: registered new interface driver hub
<6>
[    0.428523] usbcore: registered new device driver usb
<6>
[    0.428922] pps_core: LinuxPPS API ver. 1 registered
<6>
[    0.429294] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>
[    0.429941] PTP clock support registered
<6>
[    0.430318] PCI: Using ACPI for IRQ routing
<7>
[    0.440468] PCI: pci_cache_line_size set to 64 bytes
<7>
[    0.441006] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
<7>
[    0.441435] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
<7>
[    0.441863] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
<7>
[    0.442293] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
<7>
[    0.442722] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
<7>
[    0.443150] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
<7>
[    0.443579] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
<6>
[    0.444116] NetLabel: Initializing
<6>
[    0.444400] NetLabel:  domain hash size = 128
<6>
[    0.444734] NetLabel:  protocols = UNLABELED CIPSOv4
<6>
[    0.445118] NetLabel:  unlabeled traffic allowed by default
<6>
[    0.445648] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>
[    0.446539] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>
[    0.448993] Switched to clocksource hpet
<6>
[    0.458730] pnp: PnP ACPI init
<6>
[    0.459025] ACPI: bus type PNP registered
<6>
[    0.460785] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
<6>
[    0.461279] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
<6>
[    0.461764] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
<6>
[    0.462254] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
<6>
[    0.462718] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
<6>
[    0.463188] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
<6>
[    0.463672] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
<6>
[    0.464162] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
<6>
[    0.464646] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
<6>
[    0.465136] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
<6>
[    0.465620] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
<6>
[    0.466110] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
<6>
[    0.466594] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
<6>
[    0.467084] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
<6>
[    0.467568] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
<7>
[    0.468059] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>
[    0.468851] system 00:01: [io  0x164e-0x164f] has been reserved
<6>
[    0.469285] system 00:01: [io  0x1000-0x107f] could not be reserved
<6>
[    0.469727] system 00:01: [io  0x1180-0x11ff] has been reserved
<6>
[    0.470158] system 00:01: [io  0x0800-0x080f] has been reserved
<6>
[    0.470582] system 00:01: [io  0x15e0-0x15ef] has been reserved
<6>
[    0.471013] system 00:01: [io  0x1600-0x1641] has been reserved
<6>
[    0.471438] system 00:01: [io  0x1644-0x167f] could not be reserved
<6>
[    0.471883] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
<6>
[    0.472353] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>
[    0.472818] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
<6>
[    0.473287] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
<6>
[    0.473751] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
<6>
[    0.474222] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
<7>
[    0.474687] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>
[    0.475205] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>
[    0.475813] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>
[    0.476288] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
<7>
[    0.477484] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
<7>
[    0.477950] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
<7>
[    0.478569] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
<7>
[    0.479409] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
<6>
[    0.480577] pnp: PnP ACPI: found 6 devices
<6>
[    0.480899] ACPI: bus type PNP unregistered
<6>
[    0.488028] pci 0000:00:1c.0: PCI bridge to [bus 02]
<6>
[    0.488414] pci 0000:00:1c.1: PCI bridge to [bus 03]
<6>
[    0.488787] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>
[    0.489275] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<6>
[    0.489660] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<6>
[    0.490104] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<6>
[    0.490578] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<6>
[    0.491156] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<6>
[    0.491529] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>
[    0.492008] pci 0000:00:1e.0: PCI bridge to [bus 0e]
<7>
[    0.492395] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>
[    0.492797] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>
[    0.493206] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>
[    0.493647] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
<7>
[    0.494095] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
<7>
[    0.494538] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
<7>
[    0.494980] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
<7>
[    0.495434] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
<7>
[    0.495877] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
<7>
[    0.496287] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
<7>
[    0.496730] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
<7>
[    0.497273] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
<7>
[    0.497716] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
<7>
[    0.498127] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
<7>
[    0.498532] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
<7>
[    0.498975] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
<7>
[    0.499424] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
<7>
[    0.499867] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
<7>
[    0.500315] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
<6>
[    0.500789] NET: Registered protocol family 2
<6>
[    0.501309] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
<6>
[    0.501903] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
<6>
[    0.502449] TCP: Hash tables configured (established 16384 bind 16384)
<6>
[    0.502935] TCP: reno registered
<6>
[    0.503219] UDP hash table entries: 1024 (order: 3, 32768 bytes)
<6>
[    0.503662] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
<6>
[    0.504180] NET: Registered protocol family 1
<6>
[    0.504618] RPC: Registered named UNIX socket transport module.
<6>
[    0.505058] RPC: Registered udp transport module.
<6>
[    0.505413] RPC: Registered tcp transport module.
<6>
[    0.505767] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>
[    0.506252] pci 0000:00:02.0: Boot video device
<7>
[    0.506683] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>
[    0.507407] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
<7>
[    0.508141] PCI: CLS 64 bytes, default 64
<6>
[    0.508518] Unpacking initramfs...
<6>
[    3.226501] Freeing initrd memory: 146088K (ffff88006e3d2000 - ffff88007727c000)
<6>
[    3.227246] Simple Boot Flag at 0x35 set to 0x1
<6>
[    3.228504] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>
[    3.228979] Initialise system trusted keyring
<6>
[    3.229333] audit: initializing netlink subsys (disabled)
<5>
[    3.229775] audit: type=2000 audit(1405660735.045:1): initialized
<6>
[    3.230539] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>
[    3.232497] zbud: loaded
<5>
[    3.232921] VFS: Disk quotas dquot_6.5.2
<4>
[    3.233269] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>
[    3.234244] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
<6>
[    3.235243] 9p: Installing v9fs 9p2000 file system support
<6>
[    3.235672] msgmni has been set to 3718
<5>
[    3.236057] Key type big_key registered
<7>
[    3.236364] SELinux:  Registering netfilter hooks
<6>
[    3.237847] alg: No test for stdrng (krng)
<6>
[    3.238179] NET: Registered protocol family 38
<5>
[    3.238528] Key type asymmetric registered
<5>
[    3.238864] Asymmetric key parser 'x509' registered
<6>
[    3.239276] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>
[    3.239893] io scheduler noop registered
<6>
[    3.240208] io scheduler deadline registered (default)
<6>
[    3.240612] io scheduler cfq registered
<7>
[    3.241122] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
<7>
[    3.241855] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
<6>
[    3.242746] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>
[    3.243164] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>
[    3.243672] intel_idle: MWAIT substates: 0x1120
<7>
[    3.244026] intel_idle: v0.4 model 0x25
<7>
[    3.244332] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>
[    3.245520] ACPI: AC Adapter [AC] (on-line)
<6>
[    3.246015] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
<6>
[    3.247641] ACPI: Lid Switch [LID]
<6>
[    3.248039] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
<6>
[    3.248646] ACPI: Sleep Button [SLPB]
<6>
[    3.249039] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
<6>
[    3.249588] ACPI: Power Button [PWRF]
<6>
[    3.255451] thermal LNXTHERM:00: registered as thermal_zone0
<6>
[    3.255886] ACPI: Thermal Zone [THM0] (53 C)
<6>
[    3.256275] GHES: HEST is not enabled!
<6>
[    3.256701] ACPI: Battery Slot [BAT0] (battery absent)
<6>
[    3.256937] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<7>
[    3.258006] IOAPIC[0]: Set routing entry (1-17 -> 0x81 -> IRQ 17 Mode:1 Active:1 Dest:15)
<6>
[    3.258932] console [ttyS0] disabled
<6>
[    3.279759] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
<6>
[    5.102489] tsc: Refined TSC clocksource calibration: 2394.001 MHz
<6>
[    5.102498] console [ttyS0] enabled
<6>
[    5.103478] Non-volatile memory driver v1.3
<6>
[    5.103501] Linux agpgart interface v0.103
<6>
[    5.103659] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
<6>
[    5.103699] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
<6>
[    5.117264] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
<6>
[    5.120529] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
<6>
[    5.124419] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
<6>
[    5.162028] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
<7>
[    5.165520] IOAPIC[0]: Set routing entry (1-16 -> 0x91 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>
[    5.169095] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
<4>
[    5.172590] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140424/utaddress-258)
<6>
[    5.179271] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.184345] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
<6>
[    5.192037] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.196476] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
<6>
[    5.204133] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.208455] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
<6>
[    5.216274] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.220534] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>
[    5.223017] rdac: device handler registered
<6>
[    5.225077] hp_sw: device handler registered
<6>
[    5.227002] emc: device handler registered
<6>
[    5.228810] alua: device handler registered
<6>
[    5.230747] libphy: Fixed MDIO Bus: probed
<6>
[    5.232652] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>
[    5.236256] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>
[    5.238529] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>
[    5.240840] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<6>
[    5.244209] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>
[    5.248189] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<6>
[    5.432445] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
<6>
[    5.436105] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>
[    5.438729] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
<6>
[    5.442158] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
<6>
[    5.444753] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>
[    5.447908] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>
[    5.450739] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>
[    5.454049] usbcore: registered new interface driver catc
<6>
[    5.456230] usbcore: registered new interface driver kaweth
<6>
[    5.458506] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>
[    5.462101] usbcore: registered new interface driver pegasus
<6>
[    5.464398] usbcore: registered new interface driver rtl8150
<6>
[    5.466800] usbcore: registered new interface driver asix
<6>
[    5.468968] usbcore: registered new interface driver cdc_ether
<6>
[    5.472159] usbcore: registered new interface driver cdc_eem
<6>
[    5.474503] usbcore: registered new interface driver dm9601
<6>
[    5.476861] usbcore: registered new interface driver smsc75xx
<6>
[    5.479968] usbcore: registered new interface driver smsc95xx
<6>
[    5.482324] usbcore: registered new interface driver gl620a
<6>
[    5.484576] usbcore: registered new interface driver net1080
<6>
[    5.486989] usbcore: registered new interface driver plusb
<6>
[    5.490051] usbcore: registered new interface driver rndis_host
<6>
[    5.492379] usbcore: registered new interface driver cdc_subset
<6>
[    5.494815] usbcore: registered new interface driver zaurus
<6>
[    5.497960] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>
[    5.500716] usbcore: registered new interface driver int51x1
<6>
[    5.503877] usbcore: registered new interface driver ipheth
<6>
[    5.506200] usbcore: registered new interface driver sierra_net
<6>
[    5.508743] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>
[    5.512072] ehci-pci: EHCI PCI platform driver
<6>
[    5.514108] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>
[    5.516445] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>
[    5.519013] ehci-pci 0000:00:1a.0: debug port 2
<7>
[    5.525351] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>
[    5.528404] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
<6>
[    5.536199] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>
[    5.538937] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    5.541574] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    5.545053] usb usb1: Product: EHCI Host Controller
<6>
[    5.547172] usb usb1: Manufacturer: Linux 3.16.0-rc4-00051-ge59a094 ehci_hcd
<6>
[    5.549851] usb usb1: SerialNumber: 0000:00:1a.0
<6>
[    5.552316] hub 1-0:1.0: USB hub found
<6>
[    5.553749] hub 1-0:1.0: 3 ports detected
<6>
[    5.555937] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>
[    5.558023] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>
[    5.561493] ehci-pci 0000:00:1d.0: debug port 2
<7>
[    5.567338] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>
[    5.570993] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
<6>
[    5.579288] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>
[    5.581740] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    5.584992] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    5.587738] usb usb2: Product: EHCI Host Controller
<6>
[    5.589858] usb usb2: Manufacturer: Linux 3.16.0-rc4-00051-ge59a094 ehci_hcd
<6>
[    5.593347] usb usb2: SerialNumber: 0000:00:1d.0
<6>
[    5.595731] hub 2-0:1.0: USB hub found
<6>
[    5.597216] hub 2-0:1.0: 3 ports detected
<6>
[    5.599338] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>
[    5.601624] ohci-pci: OHCI PCI platform driver
<6>
[    5.603580] uhci_hcd: USB Universal Host Controller Interface driver
<6>
[    5.607000] usbcore: registered new interface driver usbserial
<6>
[    5.609341] usbcore: registered new interface driver usbserial_generic
<6>
[    5.611842] usbserial: USB Serial support registered for generic
<6>
[    5.615127] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
<6>
[    5.622072] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>
[    5.623975] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>
[    5.626585] mousedev: PS/2 mouse device common for all mice
<6>
[    5.629117] rtc_cmos 00:02: RTC can wake from S4
<6>
[    5.630914] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>
[    5.632976] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>
[    5.633056] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
<6>
[    5.640495] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>
[    5.642846] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
<6>
[    5.646471] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>
[    5.648730] iTCO_vendor_support: vendor-support=0
<6>
[    5.651461] hidraw: raw HID events driver (C) Jiri Kosina
<6>
[    5.655047] usbcore: registered new interface driver usbhid
<6>
[    5.657095] usbhid: USB HID core driver
<6>
[    5.658990] drop_monitor: Initializing network drop monitor service
<6>
[    5.661577] TCP: cubic registered
<6>
[    5.663152] Initializing XFRM netlink socket
<6>
[    5.665356] NET: Registered protocol family 10
<6>
[    5.667502] NET: Registered protocol family 17
<6>
[    5.669124] 9pnet: Installing 9P2000 support
<7>
[    5.671789] 
<7>
[    5.671789] printing PIC contents
<7>
[    5.674116] ... PIC  IMR: ffff
<7>
[    5.674987] ... PIC  IRR: 0800
<7>
[    5.676662] ... PIC  ISR: 0000
<7>
[    5.678199] ... PIC ELCR: 0a00
<7>
[    5.679895] printing local APIC contents on CPU#0/0:
<6>
[    5.681933] ... APIC ID:      00000000 (0)
<6>
[    5.683848] ... APIC VERSION: 01060015
<7>
[    5.684856] ... APIC TASKPRI: 00000000 (00)
<7>
[    5.686851] ... APIC PROCPRI: 00000000
<7>
[    5.688519] ... APIC LDR: 01000000
<7>
[    5.690283] ... APIC DFR: ffffffff
<7>
[    5.692036] ... APIC SPIV: 000001ff
<7>
[    5.693793] ... APIC ISR field:
<4>
[    5.694647] 0000000000000000000000000000000000000000000000000000000000000000
<7>
[    5.698241] ... APIC TMR field:
<4>
[    5.699791] 0000000002000000000000000000000000000000000000000000000000000000
<7>
[    5.702659] ... APIC IRR field:
<4>
[    5.704101] 0000000010000000000000000000000000000000000000000000000000000000
<7>
[    5.707171] ... APIC ESR: 00000000
<7>
[    5.708532] ... APIC ICR: 000008fd
<7>
[    5.710252] ... APIC ICR2: 02000000
<7>
[    5.712004] ... APIC LVTT: 000000ef
<7>
[    5.712899] ... APIC LVTPC: 00000400
<7>
[    5.714612] ... APIC LVT0: 00010700
<7>
[    5.716486] ... APIC LVT1: 00000400
<7>
[    5.718178] ... APIC LVTERR: 000000fe
<7>
[    5.719974] ... APIC TMICT: 003fc2de
<7>
[    5.721062] ... APIC TMCCT: 00397ada
<7>
[    5.722630] ... APIC TDCR: 00000003
<4>
[    5.724409] 
<7>
[    5.724877] number of MP IRQ sources: 15.
<7>
[    5.726811] number of IO-APIC #1 registers: 24.
<6>
[    5.728778] testing the IO APIC.......................
<7>
[    5.731009] IO APIC #1......
<7>
[    5.732554] .... register #00: 02000000
<7>
[    5.734322] .......    : physical APIC id: 02
<7>
[    5.736419] .......    : Delivery Type: 0
<7>
[    5.738181] .......    : LTS          : 0
<7>
[    5.740143] .... register #01: 00170020
<7>
[    5.741948] .......     : max redirection entries: 17
<7>
[    5.744093] .......     : PRQ implemented: 0
<7>
[    5.746125] .......     : IO APIC version: 20
<7>
[    5.748011] .... IRQ redirection table:
<4>
[    5.749879] 1    0    0   0   0    0    0    00
<4>
[    5.751902] 0    0    0   0   0    1    1    31
<4>
[    5.753905] 0    0    0   0   0    1    1    30
<4>
[    5.755969] 0    0    0   0   0    1    1    33
<4>
[    5.757956] 0    0    0   0   0    1    1    34
<4>
[    5.759969] 0    0    0   0   0    1    1    35
<4>
[    5.761996] 0    0    0   0   0    1    1    36
<4>
[    5.764036] 0    0    0   0   0    1    1    37
<4>
[    5.766163] 0    0    0   0   0    1    1    38
<4>
[    5.768085] 0    1    0   0   0    1    1    39
<4>
[    5.770086] 0    0    0   0   0    1    1    3A
<4>
[    5.772089] 0    0    0   0   0    1    1    3B
<4>
[    5.774113] 0    0    0   0   0    1    1    3C
<4>
[    5.776258] 0    0    0   0   0    1    1    3D
<4>
[    5.778169] 0    0    0   0   0    1    1    3E
<4>
[    5.780206] 0    0    0   0   0    1    1    3F
<4>
[    5.782216] 1    1    0   1   0    1    1    91
<4>
[    5.784248] 1    1    0   1   0    1    1    81
<4>
[    5.786353] 1    0    0   0   0    0    0    00
<4>
[    5.788300] 0    1    0   1   0    1    1    51
<4>
[    5.790302] 1    1    0   1   0    1    1    61
<4>
[    5.792354] 1    1    0   1   0    1    1    71
<4>
[    5.794421] 1    0    0   0   0    0    0    00
<4>
[    5.796442] 0    1    0   1   0    1    1    41
<7>
[    5.798474] IRQ to pin mappings:
<7>
[    5.800091] IRQ0 -> 0:2
<7>
[    5.801001] IRQ1 -> 0:1
<7>
[    5.802352] IRQ3 -> 0:3
<7>
[    5.803173] IRQ4 -> 0:4
<7>
[    5.804449] IRQ5 -> 0:5
<7>
[    5.805834] IRQ6 -> 0:6
<7>
[    5.806716] IRQ7 -> 0:7
<7>
[    5.807976] IRQ8 -> 0:8
<7>
[    5.808846] IRQ9 -> 0:9
<7>
[    5.810130] IRQ10 -> 0:10
<7>
[    5.811053] IRQ11 -> 0:11
<7>
[    5.812413] IRQ12 -> 0:12
<7>
[    5.813251] IRQ13 -> 0:13
<7>
[    5.814555] IRQ14 -> 0:14
<7>
[    5.816086] IRQ15 -> 0:15
<7>
[    5.816916] IRQ16 -> 0:16
<7>
[    5.818311] IRQ17 -> 0:17
<7>
[    5.819207] IRQ19 -> 0:19
<7>
[    5.820487] IRQ20 -> 0:20
<7>
[    5.821949] IRQ21 -> 0:21
<7>
[    5.822803] IRQ23 -> 0:23
<6>
[    5.824259] .................................... done.
<5>
[    5.827017] Loading compiled-in X.509 certificates
<5>
[    5.830431] Loaded X.509 cert 'Magrathea: Glacier signing key: 284701a18fb7882416111cb0174bd80ca4358dff'
<6>
[    5.834611] registered taskstats version 1
<5>
[    5.840653] Key type trusted registered
<5>
[    5.846101] Key type encrypted registered
<3>
[    5.857437] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
<6>
[    5.857485] usb 1-1: new high-speed USB device number 2 using ehci-pci
<6>
[    5.863324] ima: No TPM chip found, activating TPM-bypass!
<6>
[    5.865646] evm: HMAC attrs: 0x1
<6>
[    5.868289] rtc_cmos 00:02: setting system clock to 2014-07-18 05:18:58 UTC (1405660738)
<6>
[    5.978262] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
<7>
[    5.980565] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<6>
[    5.982677] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>
[    5.986786] hub 1-1:1.0: USB hub found
<6>
[    5.988355] hub 1-1:1.0: 6 ports detected
<7>
[    6.081606] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<6>
[    6.083280] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>
[    6.093516] usb 2-1: new high-speed USB device number 2 using ehci-pci
<6>
[    6.117698] Switched to clocksource tsc
<6>
[    6.210986] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
<6>
[    6.213195] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>
[    6.217159] hub 2-1:1.0: USB hub found
<6>
[    6.218726] hub 2-1:1.0: 8 ports detected
<6>
[    6.294765] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
<6>
[    6.384223] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
<6>
[    6.387487] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>
[    6.390172] usb 1-1.3: Product: Biometric Coprocessor
<6>
[    6.392380] usb 1-1.3: Manufacturer: UPEK
<6>
[    6.468008] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
<6>
[    6.562800] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
<6>
[    6.565247] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>
[    6.568852] usb 1-1.6: Product: Integrated Camera
<6>
[    6.570965] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
<6>
[    6.625561] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
<6>
[    6.631231] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
<6>
[    6.685016] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
<6>
[    9.002821] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
<6>
[    9.012403] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>
[    9.023376] Sending DHCP requests ., OK
<4>
[    9.066374] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
<6>
[    9.070090] IP-Config: Complete:
<6>
[    9.071093]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
<6>
[    9.077120]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
<6>
[    9.079392]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>
[    9.082832]      nameserver0=192.168.1.1
<7>
[    9.084953] PM: Hibernation image not present or could not be loaded.
<6>
[    9.089088] Freeing unused kernel memory: 1792K (ffffffff81da5000 - ffffffff81f65000)
<6>
[    9.371858] [drm] Initialized drm 1.1.0 20060810
<6>
[    9.409289] Linux video capture interface: v2.00
<6>
[    9.429785] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<6>
[    9.435712] wmi: Mapper loaded
<6>
[    9.471179] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
<7>
[    9.475607] libata version 3.00 loaded.
<6>
[    9.502770] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
<6>
[    9.508881] thinkpad_acpi: ThinkPad ACPI Extras v0.25
<6>
[    9.508972] sdhci: Secure Digital Host Controller Interface driver
<6>
[    9.508973] sdhci: Copyright(c) Pierre Ossman
<6>
[    9.515803] thinkpad_acpi: http://ibm-acpi.sf.net/
<6>
[    9.518665] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
<6>
[    9.521351] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
<6>
[    9.528968] input: PC Speaker as /devices/platform/pcspkr/input/input7
<6>
[    9.532041] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
<6>
[    9.544771] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
<6>
[    9.544956] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
<4>
[    9.545237] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
<6>
[    9.545245] mmc0: no vqmmc regulator found
<6>
[    9.545246] mmc0: no vmmc regulator found
<6>
[    9.550193] [drm] Memory usable by graphics device = 2048M
<6>
[    9.550195] [drm] Replacing VGA console driver
<6>
[    9.563401] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
<6>
[    9.563910] Console: switching to colour dummy device 80x25
<6>
[    9.564395] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
<6>
[    9.573262] thinkpad_acpi: radio switch found; radios are disabled
<6>
[    9.576013] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
<4>
[    9.578272] ------------[ cut here ]------------
<4>
[    9.578336] WARNING: CPU: 2 PID: 255 at drivers/gpu/drm/i915/intel_pm.c:4994 intel_disable_gt_powersave+0x416/0x420 [i915]()
<4>
[    9.578370] Modules linked in: libahci sdhci_pci uvcvideo(+) firewire_ohci(+) i915(+) videobuf2_vmalloc pcspkr sdhci thinkpad_acpi(+) parport_pc videobuf2_memops videobuf2_core firewire_core snd_timer mmc_core crc_itu_t parport rfkill video v4l2_common snd libata drm_kms_helper soundcore wmi intel_ips i2c_i801 videodev drm acpi_cpufreq
<4>
[    9.578375] CPU: 2 PID: 255 Comm: modprobe Not tainted 3.16.0-rc4-00051-ge59a094 #1
<4>
[    9.578377] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.578383]  0000000000000009 ffff8800769c7908 ffffffff8182b6d0 0000000000000000
<4>
[    9.578387]  ffff8800769c7940 ffffffff8106d0dd ffff8800762e0000 ffff8800762e0000
<4>
[    9.578392]  ffff880074da0000 ffff88005a184c60 ffffffffa028c7e0 ffff8800769c7950
<4>
[    9.578393] Call Trace:
<4>
[    9.578404]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.578412]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.578417]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.578465]  [<ffffffffa0206d66>] intel_disable_gt_powersave+0x416/0x420 [i915]
<4>
[    9.578527]  [<ffffffffa023e94e>] intel_uncore_sanitize+0xe/0x10 [i915]
<4>
[    9.578595]  [<ffffffffa0285f66>] i915_driver_load+0x296/0xfe0 [i915]
<4>
[    9.578603]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.578609]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.578614]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.578620]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.578624]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.578664]  [<ffffffffa003f176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.578688]  [<ffffffffa003b78d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.578714]  [<ffffffffa003e26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.578760]  [<ffffffffa01f856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.578766]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.578771]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.578776]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.578781]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.578785]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.578789]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.578793]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.578797]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.578801]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.578805]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.578810]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.578835]  [<ffffffffa003e4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.578840]  [<ffffffffa02dd000>] ? 0xffffffffa02dcfff
<4>
[    9.578887]  [<ffffffffa02dd089>] i915_init+0x89/0x90 [i915]
<4>
[    9.578893]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.578898]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.578904]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.578910]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.578915]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.578923]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.578930]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.578933] ---[ end trace c1903d8690cfe527 ]---
<6>
[    9.634016] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
<6>
[    9.634213] usbcore: registered new interface driver uvcvideo
<6>
[    9.634215] USB Video Class driver (1.1.1)
<7>
[    9.634895] i915 0000:00:02.0: irq 42 for MSI/MSI-X
<6>
[    9.634913] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>
[    9.634914] [drm] Driver supports precise vblank timestamp query.
<6>
[    9.635560] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<5>
[    9.701973] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
<5>
[    9.743064] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
<6>
[    9.756143] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
<3>
[    9.759627] Error: Driver 'pcspkr' is already registered, aborting...
<6>
[    9.767026] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
<6>
[    9.770087] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
<6>
[    9.775343] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
<6>
[    9.835818] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
<6>
[    9.848719] fbcon: inteldrmfb (fb0) is primary device
<5>
[   10.247262] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
<6>
[   10.389264] Console: switching to colour frame buffer device 160x50
<6>
[   10.402367] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>
[   10.405691] i915 0000:00:02.0: registered panic notifier
<6>
[   10.422584] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
<6>
[   10.429010] acpi device:01: registered as cooling_device4
<6>
[   10.431778] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
<6>
[   10.435940] [drm] Initialized i915 1.6.0 20140620 for 0000:00:02.0 on minor 0
<7>
[   10.438444] ahci 0000:00:1f.2: version 3.0
<7>
[   10.440524] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
<6>
[   10.442334] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
<6>
[   10.445838] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
<6>
[   10.449711] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
<6>
[   10.460455] scsi0 : ahci
<6>
[   10.461430] scsi1 : ahci
<6>
[   10.463184] scsi2 : ahci
<6>
[   10.464073] scsi3 : ahci
<6>
[   10.465411] scsi4 : ahci
<6>
[   10.466796] scsi5 : ahci
<6>
[   10.467602] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 43
<6>
[   10.470872] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 43
<6>
[   10.473633] ata3: DUMMY
<6>
[   10.475205] ata4: DUMMY
<6>
[   10.476621] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 43
<6>
[   10.479391] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 43
<7>
[   10.485466] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
<6>
[   10.511332] sound hdaudioC0D0: CX20585: BIOS auto-probing.
<6>
[   10.516285] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
<6>
[   10.522440] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<6>
[   10.527179] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
<6>
[   10.532649] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
<6>
[   10.537948] sound hdaudioC0D0:    mono: mono_out=0x0
<6>
[   10.542089] sound hdaudioC0D0:    inputs:
<6>
[   10.545955] sound hdaudioC0D0:      Mic=0x1b
<6>
[   10.550017] sound hdaudioC0D0:      Internal Mic=0x23
<6>
[   10.554079] sound hdaudioC0D0:      Dock Mic=0x1a
<6>
[   10.559916] sound hdaudioC0D0: Enable sync_write for stable communication
<6>
[   10.580740] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>
[   10.585972] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>
[   10.591814] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>
[   10.598856] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>
[   10.604941] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
<6>
[   10.610982] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
<6>
[   10.617174] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
<6>
[   10.950579] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<7>
[   10.956212] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[   10.960994] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>
[   10.966912] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[   10.971440] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>
[   10.978740] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
<6>
[   10.982583] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<7>
[   10.990109] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[   10.994706] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>
[   11.000023] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[   11.005078] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>
[   11.011551] ata1.00: configured for UDMA/100
<5>
[   11.015046] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
<6>
[   11.480940] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<7>
[   11.493438] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>
[   11.502271] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>
[   11.507519] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
<7>
[   11.524585] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>
[   11.533664] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>
[   11.539635] ata2.00: configured for UDMA/100
<5>
[   11.558921] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
<6>
[   11.891190] ata5: SATA link down (SStatus 0 SControl 300)
<6>
[   12.136171] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
<6>
[   12.199362] ata6: SATA link down (SStatus 0 SControl 300)
<5>
[   12.227799] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
<5>
[   12.232397] sd 0:0:0:0: [sda] Write Protect is off
<7>
[   12.237171] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>
[   12.241381] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<4>
[   12.243809] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
<6>
[   12.243812] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>
[   12.244110] sr 1:0:0:0: Attached scsi CD-ROM sr0
<5>
[   12.267596] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>
[   12.271590] sr 1:0:0:0: Attached scsi generic sg1 type 5
<6>
[   12.416392] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
<6>
[   12.680669]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
<5>
[   12.686459] sd 0:0:0:0: [sda] Attached SCSI disk
<5>
[   12.851941] random: nonblocking pool is initialized
<6>
[   13.850098] fuse init (API version 7.23)
<6>
[   14.403161] device-mapper: uevent: version 1.0.3
<6>
[   14.411296] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
<6>
[   14.746048] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<6>
[   24.350953] ipmi message handler version 39.2
<6>
[   24.361201] IPMI Watchdog: driver initialized

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-c2b6ef4

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc4-00052-gc2b6ef4 (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Fri Jul 18 05:34:46 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-c2b6ef437792d4d5f972d5147b809aac78a5b273-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 kconfig=x86_64-rhel commit=c2b6ef437792d4d5f972d5147b809aac78a5b273 root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007727bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007727c000-0x0000000077281fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077282000-0x0000000077362fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077363000-0x0000000077374fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077375000-0x00000000773f5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000773f6000-0x000000007740efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007740f000-0x000000007746efff] usable
[    0.000000] BIOS-e820: [mem 0x000000007746f000-0x0000000077667fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077668000-0x00000000776e7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000776e8000-0x000000007770efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007770f000-0x0000000077716fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077717000-0x000000007771efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007776bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007776c000-0x0000000077777fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000077778000-0x000000007777afff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007777b000-0x000000007778afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007778b000-0x000000007778bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007778c000-0x000000007779efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007779f000-0x00000000777fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000777ff000-0x00000000777fffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077800000-0x000000007bffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x77800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 078000000 mask FF8000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f68c0-0x000f68cf] mapped at [ffff8800000f68c0]
[    0.000000]   mpc: 9f071-9f17d
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02144000, 0x02144fff] PGTABLE
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6e000000-0x6e1fffff]
[    0.000000]  [mem 0x6e000000-0x6e1fffff] page 2M
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6dffffff]
[    0.000000]  [mem 0x6c000000-0x6dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x6bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x6e200000-0x7727bfff]
[    0.000000]  [mem 0x6e200000-0x771fffff] page 2M
[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
[    0.000000] BRK [0x02148000, 0x02148fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
[    0.000000] BRK [0x02149000, 0x02149fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
[    0.000000] RAMDISK: [mem 0x6e3d1000-0x7727bfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140424/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140424/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000777EFED1 00ECE9 (v01 LENOVO TP-6I    00001120 MSFT 03000001)
[    0.000000] ACPI: FACS 0x00000000776E7000 000040
[    0.000000] ACPI: SSDT 0x00000000777EFCB4 00021D (v01 LENOVO TP-6I    00001120 MSFT 03000001)
[    0.000000] ACPI: ECDT 0x00000000777FEBBA 000052 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: APIC 0x00000000777FEC0C 000084 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: MCFG 0x00000000777FECC8 00003C (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: HPET 0x00000000777FED04 000038 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI: ASF! 0x00000000777FEDBE 0000A4 (v16 LENOVO TP-6I    00001120 PTL  00000001)
[    0.000000] ACPI: SLIC 0x00000000777FEE62 000176 (v01 LENOVO TP-6I    00001120  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000777FEFD8 000028 (v01 LENOVO TP-6I    00001120  LTP 00000001)
[    0.000000] ACPI: SSDT 0x00000000776E591A 00084B (v01 LENOVO TP-6I    00001120 INTL 20050513)
[    0.000000] ACPI: TCPA 0x000000007778B000 000032 (v02 PTL     CRESTLN 06040000      00005A52)
[    0.000000] ACPI: SSDT 0x000000007777A000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20050513)
[    0.000000] ACPI: SSDT 0x0000000077779000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20050513)
[    0.000000] ACPI: SSDT 0x0000000077778000 00049F (v01 PmRef  ApTst    00003000 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000777fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x777fffff]
[    0.000000]   NODE_DATA [mem 0x77745000-0x7776bfff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff88006bc00000-ffff88006d9fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7727bfff]
[    0.000000]   node   0: [mem 0x77282000-0x77362fff]
[    0.000000]   node   0: [mem 0x7740f000-0x7746efff]
[    0.000000]   node   0: [mem 0x7770f000-0x77716fff]
[    0.000000]   node   0: [mem 0x7771f000-0x7776bfff]
[    0.000000]   node   0: [mem 0x777ff000-0x777fffff]
[    0.000000] On node 0 totalpages: 488368
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7584 pages used for memmap
[    0.000000]   DMA32 zone: 484371 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0x7a000000-0x7bffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 1, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 1, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 1, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 1, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 1, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 1, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 1, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 1, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 1, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 1, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 1, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 1, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 1, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 1, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 1, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7727c000-0x77281fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77363000-0x77374fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77375000-0x773f5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x773f6000-0x7740efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7746f000-0x77667fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77668000-0x776e7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x776e8000-0x7770efff]
[    0.000000] PM: Registered nosave memory: [mem 0x77717000-0x7771efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7776c000-0x77777fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77778000-0x7777afff]
[    0.000000] PM: Registered nosave memory: [mem 0x7777b000-0x7778afff]
[    0.000000] PM: Registered nosave memory: [mem 0x7778b000-0x7778bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7778c000-0x7779efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7779f000-0x777fefff]
[    0.000000] e820: [mem 0x7c000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88006e000000 s87552 r8192 d23040 u524288
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-c2b6ef437792d4d5f972d5147b809aac78a5b273-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 kconfig=x86_64-rhel commit=c2b6ef437792d4d5f972d5147b809aac78a5b273 root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 1757988K/1953472K available (8421K kernel code, 1656K rwdata, 3876K rodata, 1792K init, 1876K bss, 195484K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 7864320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2394.038 MHz processor
[    0.000032] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.07 BogoMIPS (lpj=2394038)
[    0.000743] pid_max: default: 32768 minimum: 301
[    0.001061] ACPI: Core revision 20140424
[    0.014584] ACPI: All ACPI Tables successfully acquired
[    0.015067] Security Framework initialized
[    0.015358] SELinux:  Initializing.
[    0.015619] SELinux:  Starting in permissive mode
[    0.016083] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.017240] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.017994] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.018426] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.019173] Initializing cgroup subsys memory
[    0.019548] Initializing cgroup subsys devices
[    0.019891] Initializing cgroup subsys freezer
[    0.020237] Initializing cgroup subsys net_cls
[    0.020591] Initializing cgroup subsys blkio
[    0.020928] Initializing cgroup subsys perf_event
[    0.021285] Initializing cgroup subsys hugetlb
[    0.021659] CPU: Physical Processor ID: 0
[    0.021976] CPU: Processor Core ID: 0
[    0.022277] mce: CPU supports 9 MCE banks
[    0.022612] CPU0: Thermal monitoring enabled (TM1)
[    0.022983] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.022983] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.022983] tlb_flushall_shift: 6
[    0.024106] Freeing SMP alternatives memory: 32K (ffffffff81f65000 - ffffffff81f6d000)
[    0.025831] ftrace: allocating 30751 entries in 121 pages
[    0.041117] Getting VERSION: 1060015
[    0.041415] Getting VERSION: 1060015
[    0.041717] Getting ID: 0
[    0.041955] Getting ID: 0
[    0.042199] enabled ExtINT on CPU#0
[    0.042807] ENABLING IO-APIC IRQs
[    0.043086] init IO_APIC IRQs
[    0.043345]  apic 1 pin 0 not connected
[    0.043665] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.044249] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044839] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.045421] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.046001] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.046584] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.047167] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.047751] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.048331] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.048916] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.049510] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.050104] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.050698] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.051290] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.051885] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.052476]  apic 1 pin 16 not connected
[    0.052786]  apic 1 pin 17 not connected
[    0.053101]  apic 1 pin 18 not connected
[    0.053414]  apic 1 pin 19 not connected
[    0.053728]  apic 1 pin 20 not connected
[    0.054040]  apic 1 pin 21 not connected
[    0.054353]  apic 1 pin 22 not connected
[    0.054666]  apic 1 pin 23 not connected
[    0.055120] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065558] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
[    0.066405] Using local APIC timer interrupts.
[    0.066405] calibrating APIC timer ...
[    0.168567] ... lapic delta = 831240
[    0.168859] ... PM-Timer delta = 357951
[    0.169166] ... PM-Timer result ok
[    0.169450] ..... delta 831240
[    0.169712] ..... mult: 35701486
[    0.169985] ..... calibration result: 132998
[    0.170316] ..... CPU clock speed is 2393.0971 MHz.
[    0.170682] ..... host bus clock speed is 132.0998 MHz.
[    0.171101] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.171911] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.172393] ... version:                3
[    0.172708] ... bit width:              48
[    0.173028] ... generic registers:      4
[    0.173344] ... value mask:             0000ffffffffffff
[    0.173732] ... max period:             000000007fffffff
[    0.174122] ... fixed-purpose events:   3
[    0.174436] ... event mask:             000000070000000f
[    0.176527] x86: Booting SMP configuration:
[    0.176853] .... node  #0, CPUs:      #1
[    0.188337] masked ExtINT on CPU#1
[    0.190746] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.191441]  #2
[    0.202613] masked ExtINT on CPU#2
[    0.205057]  #3
[    0.216219] masked ExtINT on CPU#3
[    0.218560] x86: Booted up 1 node, 4 CPUs
[    0.218879] smpboot: Total of 4 processors activated (19152.30 BogoMIPS)
[    0.221758] devtmpfs: initialized
[    0.224375] evm: security.selinux
[    0.224655] evm: security.ima
[    0.224914] evm: security.capability
[    0.225343] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
[    0.225935] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
[    0.226528] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
[    0.227104] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
[    0.227685] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
[    0.229324] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.229870] NET: Registered protocol family 16
[    0.230419] cpuidle: using governor menu
[    0.230849] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.231415] ACPI: bus type PCI registered
[    0.231734] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.232255] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.232914] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.233890] PCI: Using configuration type 1 for base access
[    0.237390] ACPI: Added _OSI(Module Device)
[    0.237718] ACPI: Added _OSI(Processor Device)
[    0.238062] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.238419] ACPI: Added _OSI(Processor Aggregator Device)
[    0.240160] ACPI : EC: EC description table is found, configuring boot EC
[    0.244590] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.320894] ACPI: Dynamic OEM Table Load:
[    0.321319] ACPI: SSDT 0xFFFF88006AED0800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
[    0.322488] ACPI: Dynamic OEM Table Load:
[    0.322912] ACPI: SSDT 0xFFFF88006AED1000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
[    0.328258] ACPI: Dynamic OEM Table Load:
[    0.328684] ACPI: SSDT 0xFFFF88006AE45400 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
[    0.331862] ACPI: Dynamic OEM Table Load:
[    0.332284] ACPI: SSDT 0xFFFF88006A820000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
[    0.336580] ACPI: Interpreter enabled
[    0.336886] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.337643] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.338406] ACPI: (supports S0 S3 S4 S5)
[    0.338719] ACPI: Using IOAPIC for interrupt routing
[    0.339112] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.345367] ACPI: Power Resource [PUBS] (on)
[    0.346376] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.348432] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.350872] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.351912] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.352931] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.354170] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.355209] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.356228] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.357449] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.358687] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.359712] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.360144] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.360741] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.361249] PCI host bridge to bus 0000:ff
[    0.361572] pci_bus 0000:ff: root bus resource [bus ff]
[    0.361965] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.362446] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.362922] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.363391] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.363863] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.364336] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.364834] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.365280] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.366035] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.366603] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.367261] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.367833] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.368976] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.369596] PCI host bridge to bus 0000:00
[    0.369922] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.370324] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.370766] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.371207] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.371688] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.372169] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.372649] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
[    0.373131] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.373617] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.374062] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.374672] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.375115] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.375596] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.376141] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
[    0.376651] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.377109] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
[    0.377673] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.378181] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.378634] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
[    0.379051] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
[    0.379655] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    0.380111] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
[    0.380567] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
[    0.381024] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
[    0.381517] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.381992] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.382448] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.382905] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
[    0.383458] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.383933] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.384390] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.384845] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.385427] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.385908] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.386359] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.386897] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.387372] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.387825] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.388359] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.388836] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.389287] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.389824] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.390298] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.390748] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.391284] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.391758] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.392219] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.392673] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
[    0.393228] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.393699] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.394150] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.394708] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    0.395312] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    0.395766] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.396185] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
[    0.396601] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
[    0.397017] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
[    0.397433] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.397851] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
[    0.398361] pci 0000:00:1f.2: PME# supported from D3hot
[    0.398819] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.399271] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
[    0.399774] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
[    0.400269] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.400727] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
[    0.401408] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.401888] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
[    0.402363] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.403042] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.405809] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.406191] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.406763] acpiphp: Slot [1] registered
[    0.407084] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.407475] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.407916] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.408398] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.409105] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
[    0.409603] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.410167] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
[    0.410835] pci 0000:0d:00.0: supports D1 D2
[    0.411167] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.411810] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
[    0.412312] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
[    0.412971] pci 0000:0d:00.1: supports D1 D2
[    0.413305] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.413942] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
[    0.414446] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
[    0.415107] pci 0000:0d:00.3: supports D1 D2
[    0.415440] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.417873] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.418250] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.418812] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
[    0.419300] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.419883] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.420462] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.421083] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.421704] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.422325] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
[    0.422944] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
[    0.423767] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    0.425559] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.426085] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.426684] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.427277] vgaarb: loaded
[    0.427521] vgaarb: bridge control possible 0000:00:02.0
[    0.428002] SCSI subsystem initialized
[    0.428335] ACPI: bus type USB registered
[    0.428676] usbcore: registered new interface driver usbfs
[    0.429087] usbcore: registered new interface driver hub
[    0.429519] usbcore: registered new device driver usb
[    0.429922] pps_core: LinuxPPS API ver. 1 registered
[    0.430299] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.430953] PTP clock support registered
[    0.431331] PCI: Using ACPI for IRQ routing
[    0.441567] PCI: pci_cache_line_size set to 64 bytes
[    0.442104] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.442538] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
[    0.442970] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
[    0.443405] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
[    0.443838] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
[    0.444271] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
[    0.444703] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
[    0.445246] NetLabel: Initializing
[    0.445529] NetLabel:  domain hash size = 128
[    0.445867] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.446255] NetLabel:  unlabeled traffic allowed by default
[    0.446787] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.447685] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.450141] Switched to clocksource hpet
[    0.459854] pnp: PnP ACPI init
[    0.460139] ACPI: bus type PNP registered
[    0.461907] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.462405] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.462891] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.463385] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.463851] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.464324] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.464809] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.465298] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.465783] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.466273] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.466757] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.467247] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.467730] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
[    0.468220] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.468705] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.469197] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.469992] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.470429] system 00:01: [io  0x1000-0x107f] could not be reserved
[    0.470874] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.471307] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.471733] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.472165] system 00:01: [io  0x1600-0x1641] has been reserved
[    0.472593] system 00:01: [io  0x1644-0x167f] could not be reserved
[    0.473040] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.473511] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.473977] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.474449] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.474914] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.475386] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.475853] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.476373] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    0.476984] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.477461] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
[    0.478659] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.479127] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
[    0.479750] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.480592] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.481808] pnp: PnP ACPI: found 6 devices
[    0.482132] ACPI: bus type PNP unregistered
[    0.489249] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.489636] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.490011] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.490501] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.490889] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.491336] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.491815] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.492399] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.492775] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.493263] pci 0000:00:1e.0: PCI bridge to [bus 0e]
[    0.493646] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.494053] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.494466] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.494912] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.495364] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.495809] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.496260] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.496711] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.497155] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.497567] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.498012] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.498557] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.499002] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.499413] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.499819] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.500271] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.500717] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.501162] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.501614] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.502089] NET: Registered protocol family 2
[    0.502612] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.503219] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.503758] TCP: Hash tables configured (established 16384 bind 16384)
[    0.504254] TCP: reno registered
[    0.504532] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.504977] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.505496] NET: Registered protocol family 1
[    0.505937] RPC: Registered named UNIX socket transport module.
[    0.506379] RPC: Registered udp transport module.
[    0.506735] RPC: Registered tcp transport module.
[    0.507092] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.507581] pci 0000:00:02.0: Boot video device
[    0.508013] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    0.508741] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    0.509476] PCI: CLS 64 bytes, default 64
[    0.509857] Unpacking initramfs...
[    3.226838] Freeing initrd memory: 146092K (ffff88006e3d1000 - ffff88007727c000)
[    3.227585] Simple Boot Flag at 0x35 set to 0x1
[    3.228932] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.229398] Initialise system trusted keyring
[    3.229753] audit: initializing netlink subsys (disabled)
[    3.230198] audit: type=2000 audit(1405662278.044:1): initialized
[    3.230977] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.232953] zbud: loaded
[    3.233362] VFS: Disk quotas dquot_6.5.2
[    3.233712] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.234690] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    3.235699] 9p: Installing v9fs 9p2000 file system support
[    3.236148] msgmni has been set to 3718
[    3.236512] Key type big_key registered
[    3.236822] SELinux:  Registering netfilter hooks
[    3.238320] alg: No test for stdrng (krng)
[    3.238656] NET: Registered protocol family 38
[    3.239015] Key type asymmetric registered
[    3.239339] Asymmetric key parser 'x509' registered
[    3.239745] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    3.240373] io scheduler noop registered
[    3.240688] io scheduler deadline registered (default)
[    3.241106] io scheduler cfq registered
[    3.241607] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    3.242322] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    3.243221] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.243642] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.244164] intel_idle: MWAIT substates: 0x1120
[    3.244513] intel_idle: v0.4 model 0x25
[    3.244821] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.246016] ACPI: AC Adapter [AC] (on-line)
[    3.246438] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    3.248199] ACPI: Lid Switch [LID]
[    3.248575] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    3.249205] ACPI: Sleep Button [SLPB]
[    3.249591] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    3.250170] ACPI: Power Button [PWRF]
[    3.256031] thermal LNXTHERM:00: registered as thermal_zone0
[    3.256448] ACPI: Thermal Zone [THM0] (48 C)
[    3.256838] GHES: HEST is not enabled!
[    3.257374] ACPI: Battery Slot [BAT0] (battery absent)
[    3.257441] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.258686] IOAPIC[0]: Set routing entry (1-17 -> 0x81 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    3.259525] console [ttyS0] disabled
[    3.280335] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
[    4.231515] tsc: Refined TSC clocksource calibration: 2393.999 MHz
[    5.085414] console [ttyS0] enabled
[    5.088063] Non-volatile memory driver v1.3
[    5.090333] Linux agpgart interface v0.103
[    5.092145] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    5.094447] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    5.098945] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    5.101850] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.105724] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    5.143094] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
[    5.146196] IOAPIC[0]: Set routing entry (1-16 -> 0x91 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    5.149788] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
[    5.153293] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140424/utaddress-258)
[    5.159958] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.165010] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
[    5.172884] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.177111] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
[    5.184861] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.189212] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
[    5.197004] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.201326] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.203928] rdac: device handler registered
[    5.205808] hp_sw: device handler registered
[    5.207680] emc: device handler registered
[    5.209613] alua: device handler registered
[    5.211610] libphy: Fixed MDIO Bus: probed
[    5.213588] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.216986] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.219331] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.221682] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    5.225144] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    5.229069] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    5.231408] Switched to clocksource tsc
[    5.412940] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
[    5.415332] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.419004] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    5.422331] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    5.424983] igb: Copyright (c) 2007-2014 Intel Corporation.
[    5.427236] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    5.431033] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    5.433739] usbcore: registered new interface driver catc
[    5.436506] usbcore: registered new interface driver kaweth
[    5.438827] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    5.442357] usbcore: registered new interface driver pegasus
[    5.444708] usbcore: registered new interface driver rtl8150
[    5.447024] usbcore: registered new interface driver asix
[    5.449347] usbcore: registered new interface driver cdc_ether
[    5.452459] usbcore: registered new interface driver cdc_eem
[    5.454780] usbcore: registered new interface driver dm9601
[    5.457034] usbcore: registered new interface driver smsc75xx
[    5.459543] usbcore: registered new interface driver smsc95xx
[    5.462630] usbcore: registered new interface driver gl620a
[    5.464945] usbcore: registered new interface driver net1080
[    5.467239] usbcore: registered new interface driver plusb
[    5.469588] usbcore: registered new interface driver rndis_host
[    5.472774] usbcore: registered new interface driver cdc_subset
[    5.475122] usbcore: registered new interface driver zaurus
[    5.477425] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.481049] usbcore: registered new interface driver int51x1
[    5.483383] usbcore: registered new interface driver ipheth
[    5.486554] usbcore: registered new interface driver sierra_net
[    5.489131] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.491813] ehci-pci: EHCI PCI platform driver
[    5.493768] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    5.496685] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.499395] ehci-pci 0000:00:1a.0: debug port 2
[    5.505218] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    5.508911] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
[    5.516363] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.518664] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.521947] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.525526] usb usb1: Product: EHCI Host Controller
[    5.527643] usb usb1: Manufacturer: Linux 3.16.0-rc4-00052-gc2b6ef4 ehci_hcd
[    5.530335] usb usb1: SerialNumber: 0000:00:1a.0
[    5.532592] hub 1-0:1.0: USB hub found
[    5.534271] hub 1-0:1.0: 3 ports detected
[    5.536446] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    5.538419] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.541995] ehci-pci 0000:00:1d.0: debug port 2
[    5.547939] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    5.550599] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
[    5.559390] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.561123] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.563762] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.567294] usb usb2: Product: EHCI Host Controller
[    5.569494] usb usb2: Manufacturer: Linux 3.16.0-rc4-00052-gc2b6ef4 ehci_hcd
[    5.572933] usb usb2: SerialNumber: 0000:00:1d.0
[    5.575187] hub 2-0:1.0: USB hub found
[    5.576845] hub 2-0:1.0: 3 ports detected
[    5.578948] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.581198] ohci-pci: OHCI PCI platform driver
[    5.583188] uhci_hcd: USB Universal Host Controller Interface driver
[    5.585794] usbcore: registered new interface driver usbserial
[    5.588948] usbcore: registered new interface driver usbserial_generic
[    5.591404] usbserial: USB Serial support registered for generic
[    5.594738] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.600686] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.602765] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.606023] mousedev: PS/2 mouse device common for all mice
[    5.608512] rtc_cmos 00:02: RTC can wake from S4
[    5.610553] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.612587] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.613248] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    5.620168] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    5.622477] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
[    5.626103] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.628358] iTCO_vendor_support: vendor-support=0
[    5.630769] hidraw: raw HID events driver (C) Jiri Kosina
[    5.632752] usbcore: registered new interface driver usbhid
[    5.635824] usbhid: USB HID core driver
[    5.636921] drop_monitor: Initializing network drop monitor service
[    5.640158] TCP: cubic registered
[    5.641879] Initializing XFRM netlink socket
[    5.644042] NET: Registered protocol family 10
[    5.646106] NET: Registered protocol family 17
[    5.647860] 9pnet: Installing 9P2000 support
[    5.650097] 
[    5.650097] printing PIC contents
[    5.651899] ... PIC  IMR: ffff
[    5.652801] ... PIC  IRR: 1800
[    5.654427] ... PIC  ISR: 0000
[    5.655972] ... PIC ELCR: 0a00
[    5.656876] printing local APIC contents on CPU#0/0:
[    5.658962] ... APIC ID:      00000000 (0)
[    5.660751] ... APIC VERSION: 01060015
[    5.662615] ... APIC TASKPRI: 00000000 (00)
[    5.664595] ... APIC PROCPRI: 00000000
[    5.666356] ... APIC LDR: 01000000
[    5.668106] ... APIC DFR: ffffffff
[    5.669852] ... APIC SPIV: 000001ff
[    5.670840] ... APIC ISR field:
[    5.672383] 0000000000000000000000000000000000000000000000000000000000000000
[    5.676064] ... APIC TMR field:
[    5.676930] 0000000002000000000000000000000000000000000000000000000000000000
[    5.680485] ... APIC IRR field:
[    5.681960] 0000000010000000000000000000000000000000000000000000000000008000
[    5.684970] ... APIC ESR: 00000000
[    5.686364] ... APIC ICR: 000008fd
[    5.688128] ... APIC ICR2: 04000000
[    5.689893] ... APIC LVTT: 000000ef
[    5.690925] ... APIC LVTPC: 00000400
[    5.692493] ... APIC LVT0: 00010700
[    5.694376] ... APIC LVT1: 00000400
[    5.696057] ... APIC LVTERR: 000000fe
[    5.697870] ... APIC TMICT: 00000f6a
[    5.698962] ... APIC TMCCT: 00000000
[    5.700560] ... APIC TDCR: 00000003
[    5.702298] 
[    5.702774] number of MP IRQ sources: 15.
[    5.704684] number of IO-APIC #1 registers: 24.
[    5.706618] testing the IO APIC.......................
[    5.708805] IO APIC #1......
[    5.710490] .... register #00: 02000000
[    5.712252] .......    : physical APIC id: 02
[    5.714290] .......    : Delivery Type: 0
[    5.716136] .......    : LTS          : 0
[    5.718063] .... register #01: 00170020
[    5.719216] .......     : max redirection entries: 17
[    5.722056] .......     : PRQ implemented: 0
[    5.724097] .......     : IO APIC version: 20
[    5.725981] .... IRQ redirection table:
[    5.727029] 1    0    0   0   0    0    0    00
[    5.729067] 0    0    0   0   0    1    1    31
[    5.730978] 0    0    0   0   0    1    1    30
[    5.733115] 0    0    0   0   0    1    1    33
[    5.735945] 0    0    0   0   0    1    1    34
[    5.737972] 0    0    0   0   0    1    1    35
[    5.740004] 0    0    0   0   0    1    1    36
[    5.742008] 0    0    0   0   0    1    1    37
[    5.744134] 0    0    0   0   0    1    1    38
[    5.746060] 0    1    0   0   0    1    1    39
[    5.748096] 0    0    0   0   0    1    1    3A
[    5.750125] 0    0    0   0   0    1    1    3B
[    5.752152] 0    0    0   0   0    1    1    3C
[    5.754286] 0    0    0   0   0    1    1    3D
[    5.756197] 0    0    0   0   0    1    1    3E
[    5.758231] 0    0    0   0   0    1    1    3F
[    5.760283] 1    1    0   1   0    1    1    91
[    5.762238] 1    1    0   1   0    1    1    81
[    5.764356] 1    0    0   0   0    0    0    00
[    5.766323] 0    1    0   1   0    1    1    51
[    5.768339] 1    1    0   1   0    1    1    61
[    5.770383] 1    1    0   1   0    1    1    71
[    5.772427] 1    0    0   0   0    0    0    00
[    5.774512] 0    1    0   1   0    1    1    41
[    5.776426] IRQ to pin mappings:
[    5.778139] IRQ0 -> 0:2
[    5.778959] IRQ1 -> 0:1
[    5.780415] IRQ3 -> 0:3
[    5.781199] IRQ4 -> 0:4
[    5.782529] IRQ5 -> 0:5
[    5.783400] IRQ6 -> 0:6
[    5.784662] IRQ7 -> 0:7
[    5.785471] IRQ8 -> 0:8
[    5.786759] IRQ9 -> 0:9
[    5.788174] IRQ10 -> 0:10
[    5.789105] IRQ11 -> 0:11
[    5.790477] IRQ12 -> 0:12
[    5.791321] IRQ13 -> 0:13
[    5.792593] IRQ14 -> 0:14
[    5.794114] IRQ15 -> 0:15
[    5.794992] IRQ16 -> 0:16
[    5.796376] IRQ17 -> 0:17
[    5.797244] IRQ19 -> 0:19
[    5.798623] IRQ20 -> 0:20
[    5.799593] IRQ21 -> 0:21
[    5.800766] IRQ23 -> 0:23
[    5.802324] .................................... done.
[    5.804628] Loading compiled-in X.509 certificates
[    5.807314] Loaded X.509 cert 'Magrathea: Glacier signing key: ba9e94da3cc394358d403063eadcaa3ddf88d3ca'
[    5.811635] registered taskstats version 1
[    5.816643] Key type trusted registered
[    5.821671] Key type encrypted registered
[    5.831513] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
[    5.834201] ima: No TPM chip found, activating TPM-bypass!
[    5.837304] evm: HMAC attrs: 0x1
[    5.837528] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    5.843404] rtc_cmos 00:02: setting system clock to 2014-07-18 05:44:41 UTC (1405662281)
[    5.952125] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    5.954026] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.956830] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    5.960363] hub 1-1:1.0: USB hub found
[    5.961802] hub 1-1:1.0: 6 ports detected
[    6.057726] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    6.060111] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.066670] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    6.184170] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    6.186455] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.190628] hub 2-1:1.0: USB hub found
[    6.192072] hub 2-1:1.0: 8 ports detected
[    6.268001] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
[    6.358299] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    6.360326] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.363995] usb 1-1.3: Product: Biometric Coprocessor
[    6.366084] usb 1-1.3: Manufacturer: UPEK
[    6.442059] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    6.536872] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[    6.539416] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.543005] usb 1-1.6: Product: Integrated Camera
[    6.545112] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    6.597072] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
[    6.602468] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.655847] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[    8.412621] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
[    8.422223] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.433152] Sending DHCP requests ., OK
[    8.473288] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
[    8.485951] IP-Config: Complete:
[    8.489147]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
[    8.504797]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
[    8.513690]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[    8.522101]      nameserver0=192.168.1.1
[    8.528532] PM: Hibernation image not present or could not be loaded.
[    8.537417] Freeing unused kernel memory: 1792K (ffffffff81da5000 - ffffffff81f65000)
[    8.820067] wmi: Mapper loaded
[    8.851172] libata version 3.00 loaded.
[    8.865245] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    8.886462] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[    8.886472] Linux video capture interface: v2.00
[    8.904018] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
[    8.912935] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    8.923630] [drm] Initialized drm 1.1.0 20060810
[    8.924819] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    8.924863] ahci 0000:00:1f.2: version 3.0
[    8.925143] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    8.925196] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    8.925288] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[    8.925295] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
[    8.954521] sdhci: Secure Digital Host Controller Interface driver
[    8.956872] sdhci: Copyright(c) Pierre Ossman
[    8.959418] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[    8.960425] scsi0 : ahci
[    8.966877] scsi1 : ahci
[    8.975182] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    8.982449] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[    8.983922] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    8.983923] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.983925] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
[    8.983926] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
[    8.986154] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[    8.986697] thinkpad_acpi: radio switch found; radios are disabled
[    8.986885] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    8.986886] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    8.990978] scsi2 : ahci
[    8.995393] scsi3 : ahci
[    8.997724] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
[    8.997862] usbcore: registered new interface driver uvcvideo
[    8.997864] USB Video Class driver (1.1.1)
[    9.004459] scsi4 : ahci
[    9.005356] scsi5 : ahci
[    9.005488] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 42
[    9.005493] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 42
[    9.005494] ata3: DUMMY
[    9.005496] ata4: DUMMY
[    9.005500] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 42
[    9.005503] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 42
[    9.005627] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[    9.043876] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    9.047966] mmc0: no vqmmc regulator found
[    9.048548] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    9.048742] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    9.056716] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[    9.060517] mmc0: no vmmc regulator found
[    9.063956] Error: Driver 'pcspkr' is already registered, aborting...
[    9.071593] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    9.075197] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    9.127453] [drm] Memory usable by graphics device = 2048M
[    9.130664] [drm] Replacing VGA console driver
[    9.133206] Console: switching to colour dummy device 80x25
[    9.138911] sound hdaudioC0D0: CX20585: BIOS auto-probing.
[    9.141632] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[    9.145021] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    9.146704] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    9.146723] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    9.146724] [drm] Driver supports precise vblank timestamp query.
[    9.147237] ------------[ cut here ]------------
[    9.147300] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:139 ironlake_enable_display_irq+0x73/0x80 [i915]()
[    9.147336] Modules linked in: snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.147340] CPU: 0 PID: 271 Comm: modprobe Not tainted 3.16.0-rc4-00052-gc2b6ef4 #1
[    9.147342] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.147347]  0000000000000009 ffff880076b0f8e0 ffffffff8182b6d0 0000000000000000
[    9.147350]  ffff880076b0f918 ffffffff8106d0dd ffff880074f30000 ffff880074f37128
[    9.147354]  0000000000000246 ffff880074f30000 ffff880074f30000 ffff880076b0f928
[    9.147355] Call Trace:
[    9.147365]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.147373]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.147376]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.147421]  [<ffffffffa02a88b3>] ironlake_enable_display_irq+0x73/0x80 [i915]
[    9.147466]  [<ffffffffa02a912f>] ironlake_irq_postinstall+0x17f/0x1a0 [i915]
[    9.147488]  [<ffffffffa00957be>] drm_irq_install+0xbe/0x1a0 [drm]
[    9.147547]  [<ffffffffa03067e7>] i915_driver_load+0xb07/0xfe0 [i915]
[    9.147555]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.147560]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.147564]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.147569]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.147572]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.147595]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.147614]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.147634]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.147668]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.147674]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.147679]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.147683]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.147688]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.147691]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.147694]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.147697]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.147700]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.147704]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.147707]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.147712]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.147731]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.147736]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.147771]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.147779]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.147784]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.147789]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.147797]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.147801]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.147805]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.147810]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.147817]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.147820] ---[ end trace 2d05078fac923b98 ]---
[    9.147880] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.191847] ------------[ cut here ]------------
[    9.191900] WARNING: CPU: 2 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
[    9.191932] Modules linked in: snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.191936] CPU: 2 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
[    9.191938] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.191941]  0000000000000009 ffff880076b0f8d8 ffffffff8182b6d0 0000000000000000
[    9.191944]  ffff880076b0f910 ffffffff8106d0dd ffff880074f30000 0000000000000f40
[    9.191946]  0000000000000f00 0000000000000246 ffff880074f30000 ffff880076b0f920
[    9.191948] Call Trace:
[    9.191957]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.191963]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.191966]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.192006]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
[    9.192045]  [<ffffffffa02a89ca>] ibx_hpd_irq_setup+0x6a/0xf0 [i915]
[    9.192085]  [<ffffffffa02b1b68>] intel_hpd_init+0xc8/0xe0 [i915]
[    9.192134]  [<ffffffffa0306c1d>] i915_driver_load+0xf3d/0xfe0 [i915]
[    9.192140]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.192145]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.192148]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.192152]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.192155]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.192179]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.192195]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.192212]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.192242]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.192246]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.192250]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.192254]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.192257]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.192260]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.192263]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.192265]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.192268]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.192271]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.192274]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.192277]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.192294]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.192297]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.192326]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.192331]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.192335]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.192340]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.192346]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.192350]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.192354]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.192358]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.192363]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.192365] ---[ end trace 2d05078fac923b99 ]---
[    9.253603] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    9.457034] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
[    9.457036] sound hdaudioC0D0:    mono: mono_out=0x0
[    9.457038] sound hdaudioC0D0:    inputs:
[    9.457043] sound hdaudioC0D0:      Mic=0x1b
[    9.457046] sound hdaudioC0D0:      Internal Mic=0x23
[    9.457049] sound hdaudioC0D0:      Dock Mic=0x1a
[    9.457059] fbcon: inteldrmfb (fb0) is primary device
[    9.458491] sound hdaudioC0D0: Enable sync_write for stable communication
[    9.465745] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    9.467394] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    9.467399] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    9.467482] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    9.467486] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    9.468949] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
[    9.468952] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    9.470593] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    9.470597] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    9.470682] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[    9.470685] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    9.472116] ata1.00: configured for UDMA/100
[    9.472343] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
[    9.473237] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    9.473905] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.474108] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    9.474323] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    9.474511] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    9.474694] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    9.474891] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[    9.480926] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
[    9.732977] ------------[ cut here ]------------
[    9.733033] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
[    9.733066] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.733071] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
[    9.733072] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.733076]  0000000000000009 ffff880076b0f368 ffffffff8182b6d0 0000000000000000
[    9.733078]  ffff880076b0f3a0 ffffffff8106d0dd ffff880074f30000 0000000000000001
[    9.733081]  0000000000000000 ffff880074f30000 0000000000000000 ffff880076b0f3b0
[    9.733082] Call Trace:
[    9.733091]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.733098]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.733102]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.733142]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
[    9.733183]  [<ffffffffa02aca92>] intel_set_pch_fifo_underrun_reporting+0x152/0x1b0 [i915]
[    9.733227]  [<ffffffffa02d58ad>] ironlake_crtc_disable+0x16d/0x7c0 [i915]
[    9.733270]  [<ffffffffa02c82ac>] ? intel_dump_pipe_config.isra.50+0x3c/0x350 [i915]
[    9.733313]  [<ffffffffa02d08f0>] __intel_set_mode+0x7a0/0xac0 [i915]
[    9.733357]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
[    9.733401]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
[    9.733425]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
[    9.733433]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
[    9.733439]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
[    9.733446]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
[    9.733527]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
[    9.733534]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
[    9.733540]  [<ffffffff814aee58>] visual_init+0xb8/0x120
[    9.733545]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
[    9.733549]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
[    9.733553]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
[    9.733557]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
[    9.733563]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
[    9.733567]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
[    9.733571]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
[    9.733575]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
[    9.733581]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
[    9.733591]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
[    9.733642]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
[    9.733695]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[    9.733746]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
[    9.733751]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.733756]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.733759]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.733765]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.733767]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.733787]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.733803]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.733820]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.733850]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.733855]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.733858]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.733862]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.733865]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.733868]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.733871]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.733874]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.733876]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.733879]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.733882]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.733885]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.733902]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.733906]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.733935]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.733939]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.733944]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.733948]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.733954]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.733957]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.733961]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.733965]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.733971]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.733973] ---[ end trace 2d05078fac923b9a ]---
[    9.755997] ------------[ cut here ]------------
[    9.756044] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
[    9.756068] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.756072] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
[    9.756073] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.756076]  0000000000000009 ffff880076b0f368 ffffffff8182b6d0 0000000000000000
[    9.756079]  ffff880076b0f3a0 ffffffff8106d0dd ffff880074f30000 0000000000000001
[    9.756081]  0000000000000001 ffff880074f30000 0000000000000000 ffff880076b0f3b0
[    9.756082] Call Trace:
[    9.756087]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.756092]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.756096]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.756139]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
[    9.756181]  [<ffffffffa02acada>] intel_set_pch_fifo_underrun_reporting+0x19a/0x1b0 [i915]
[    9.756225]  [<ffffffffa02d5c97>] ironlake_crtc_disable+0x557/0x7c0 [i915]
[    9.756269]  [<ffffffffa02d08f0>] __intel_set_mode+0x7a0/0xac0 [i915]
[    9.756313]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
[    9.756356]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
[    9.756377]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
[    9.756384]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
[    9.756390]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
[    9.756397]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
[    9.756440]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
[    9.756443]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
[    9.756446]  [<ffffffff814aee58>] visual_init+0xb8/0x120
[    9.756450]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
[    9.756453]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
[    9.756456]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
[    9.756459]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
[    9.756462]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
[    9.756465]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
[    9.756469]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
[    9.756472]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
[    9.756475]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
[    9.756483]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
[    9.756524]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
[    9.756567]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[    9.756614]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
[    9.756618]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.756622]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.756625]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.756628]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.756630]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.756650]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.756665]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.756682]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.756713]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.756716]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.756720]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.756723]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.756727]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.756730]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.756732]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.756735]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.756738]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.756740]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.756743]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.756747]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.756763]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.756767]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.756796]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.756799]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.756801]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.756805]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.756809]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.756812]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.756817]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.756821]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.756825]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.756827] ---[ end trace 2d05078fac923b9b ]---
[    9.757321] ------------[ cut here ]------------
[    9.757362] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:139 ironlake_enable_display_irq+0x73/0x80 [i915]()
[    9.757384] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.757387] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
[    9.757388] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.757391]  0000000000000009 ffff880076b0f388 ffffffff8182b6d0 0000000000000000
[    9.757394]  ffff880076b0f3c0 ffffffff8106d0dd ffff880074f30000 0000000000000001
[    9.757396]  0000000000000000 0000000000000000 ffff880074dee800 ffff880076b0f3d0
[    9.757397] Call Trace:
[    9.757401]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.757405]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.757408]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.757447]  [<ffffffffa02a88b3>] ironlake_enable_display_irq+0x73/0x80 [i915]
[    9.757487]  [<ffffffffa02ac665>] intel_set_cpu_fifo_underrun_reporting+0x2b5/0x340 [i915]
[    9.757531]  [<ffffffffa02d3fe5>] ironlake_crtc_enable+0x1b5/0x7a0 [i915]
[    9.757583]  [<ffffffffa02d0982>] __intel_set_mode+0x832/0xac0 [i915]
[    9.757628]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
[    9.757672]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
[    9.757692]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
[    9.757698]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
[    9.757705]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
[    9.757711]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
[    9.757754]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
[    9.757758]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
[    9.757761]  [<ffffffff814aee58>] visual_init+0xb8/0x120
[    9.757764]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
[    9.757768]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
[    9.757770]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
[    9.757773]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
[    9.757777]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
[    9.757780]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
[    9.757783]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
[    9.757786]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
[    9.757790]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
[    9.757797]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
[    9.757838]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
[    9.757881]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[    9.757928]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
[    9.757932]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.757936]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.757939]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.757942]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.757944]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.757964]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.757980]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.757996]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.758027]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.758030]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.758034]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.758037]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.758041]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.758044]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.758047]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.758049]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.758052]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.758055]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.758058]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.758061]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.758078]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.758081]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.758110]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.758113]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.758116]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.758119]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.758123]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.758126]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.758131]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.758134]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.758139]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.758141] ---[ end trace 2d05078fac923b9c ]---
[    9.758152] ------------[ cut here ]------------
[    9.758193] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
[    9.758214] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
[    9.758217] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
[    9.758218] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
[    9.758221]  0000000000000009 ffff880076b0f378 ffffffff8182b6d0 0000000000000000
[    9.758224]  ffff880076b0f3b0 ffffffff8106d0dd ffff880074f30000 0000000000000001
[    9.758226]  0000000000000001 ffff880074f30000 0000000000000000 ffff880076b0f3c0
[    9.758227] Call Trace:
[    9.758231]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
[    9.758235]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
[    9.758238]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
[    9.758277]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
[    9.758317]  [<ffffffffa02acada>] intel_set_pch_fifo_underrun_reporting+0x19a/0x1b0 [i915]
[    9.758361]  [<ffffffffa02d3ff5>] ironlake_crtc_enable+0x1c5/0x7a0 [i915]
[    9.758404]  [<ffffffffa02d0982>] __intel_set_mode+0x832/0xac0 [i915]
[    9.758449]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
[    9.758492]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
[    9.758512]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
[    9.758518]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
[    9.758525]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
[    9.758531]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
[    9.758574]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
[    9.758577]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
[    9.758581]  [<ffffffff814aee58>] visual_init+0xb8/0x120
[    9.758584]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
[    9.758587]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
[    9.758590]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
[    9.758593]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
[    9.758596]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
[    9.758600]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
[    9.758603]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
[    9.758606]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
[    9.758609]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
[    9.758617]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
[    9.758658]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
[    9.758701]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[    9.758747]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
[    9.758752]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
[    9.758755]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
[    9.758758]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
[    9.758762]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
[    9.758764]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
[    9.758783]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
[    9.758799]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
[    9.758816]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    9.758846]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
[    9.758850]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
[    9.758853]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
[    9.758857]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
[    9.758860]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
[    9.758863]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
[    9.758866]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
[    9.758868]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
[    9.758871]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
[    9.758873]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
[    9.758876]  [<ffffffff814e4584>] driver_register+0x64/0xf0
[    9.758880]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
[    9.758897]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
[    9.758900]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
[    9.758928]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
[    9.758931]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.758934]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
[    9.758937]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
[    9.758942]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
[    9.758945]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
[    9.758949]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
[    9.758953]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
[    9.758957]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
[    9.758959] ---[ end trace 2d05078fac923b9d ]---
[    9.933057] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.940772] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    9.945837] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    9.947577] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
[    9.960195] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    9.965151] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    9.966897] ata2.00: configured for UDMA/100
[    9.969176] Console: switching to colour frame buffer device 160x50
[    9.982920] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
[   10.313334] ata5: SATA link down (SStatus 0 SControl 300)
[   10.620518] ata6: SATA link down (SStatus 0 SControl 300)
[   10.742591] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[   10.756247] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   10.756249] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.756585] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   10.770856] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   10.770992] sd 0:0:0:0: [sda] Write Protect is off
[   10.770996] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.771046] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.789232] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.789448] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   11.195006]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   11.196067] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.352084] random: nonblocking pool is initialized
[   11.570882] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   11.575340] i915 0000:00:02.0: registered panic notifier
[   11.602349] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   11.611760] acpi device:01: registered as cooling_device4
[   11.615521] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input17
[   11.621727] [drm] Initialized i915 1.6.0 20140620 for 0000:00:02.0 on minor 0
[   12.459610] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   12.718911] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
[   12.734920] fuse init (API version 7.23)
[   13.290075] device-mapper: uevent: version 1.0.3
[   13.297497] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   14.262785] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
[   23.221655] ipmi message handler version 39.2
[   23.231738] IPMI Watchdog: driver initialized
<6>
[    0.000000] Initializing cgroup subsys cpuset
<6>
[    0.000000] Initializing cgroup subsys cpu
<5>
[    0.000000] Linux version 3.16.0-rc4-00052-gc2b6ef4 (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Fri Jul 18 05:34:46 CST 2014
<6>
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-c2b6ef437792d4d5f972d5147b809aac78a5b273-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 kconfig=x86_64-rhel commit=c2b6ef437792d4d5f972d5147b809aac78a5b273 root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
<6>
[    0.000000] e820: BIOS-provided physical RAM map:
<6>
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007727bfff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000007727c000-0x0000000077281fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077282000-0x0000000077362fff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077363000-0x0000000077374fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077375000-0x00000000773f5fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x00000000773f6000-0x000000007740efff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x000000007740f000-0x000000007746efff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000007746f000-0x0000000077667fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077668000-0x00000000776e7fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x00000000776e8000-0x000000007770efff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x000000007770f000-0x0000000077716fff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077717000-0x000000007771efff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007776bfff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000007776c000-0x0000000077777fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077778000-0x000000007777afff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x000000007777b000-0x000000007778afff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x000000007778b000-0x000000007778bfff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x000000007778c000-0x000000007779efff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x000000007779f000-0x00000000777fefff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x00000000777ff000-0x00000000777fffff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x0000000077800000-0x000000007bffffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
<6>
[    0.000000] bootconsole [earlyser0] enabled
<6>
[    0.000000] NX (Execute Disable) protection: active
<6>
[    0.000000] SMBIOS 2.6 present.
<7>
[    0.000000] DMI: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<7>
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>
[    0.000000] AGP: No AGP bridge found
<6>
[    0.000000] e820: last_pfn = 0x77800 max_arch_pfn = 0x400000000
<7>
[    0.000000] MTRR default type: uncachable
<7>
[    0.000000] MTRR fixed ranges enabled:
<7>
[    0.000000]   00000-9FFFF write-back
<7>
[    0.000000]   A0000-BFFFF uncachable
<7>
[    0.000000]   C0000-D3FFF write-protect
<7>
[    0.000000]   D4000-DBFFF uncachable
<7>
[    0.000000]   DC000-FFFFF write-protect
<7>
[    0.000000] MTRR variable ranges enabled:
<7>
[    0.000000]   0 disabled
<7>
[    0.000000]   1 base 078000000 mask FF8000000 uncachable
<7>
[    0.000000]   2 base 000000000 mask F80000000 write-back
<7>
[    0.000000]   3 disabled
<7>
[    0.000000]   4 disabled
<7>
[    0.000000]   5 disabled
<7>
[    0.000000]   6 disabled
<7>
[    0.000000]   7 disabled
<6>
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<4>
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>
[    0.000000] found SMP MP-table at [mem 0x000f68c0-0x000f68cf] mapped at [ffff8800000f68c0]
<4>
[    0.000000]   mpc: 9f071-9f17d
<7>
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
<6>
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>
[    0.000000] BRK [0x02144000, 0x02144fff] PGTABLE
<7>
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
<7>
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x6e000000-0x6e1fffff]
<7>
[    0.000000]  [mem 0x6e000000-0x6e1fffff] page 2M
<7>
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6dffffff]
<7>
[    0.000000]  [mem 0x6c000000-0x6dffffff] page 2M
<6>
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
<7>
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>
[    0.000000]  [mem 0x00200000-0x6bffffff] page 2M
<6>
[    0.000000] init_memory_mapping: [mem 0x6e200000-0x7727bfff]
<7>
[    0.000000]  [mem 0x6e200000-0x771fffff] page 2M
<7>
[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
<7>
[    0.000000] BRK [0x02148000, 0x02148fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
<7>
[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
<7>
[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
<7>
[    0.000000] BRK [0x02149000, 0x02149fff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
<7>
[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
<7>
[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
<7>
[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
<6>
[    0.000000] RAMDISK: [mem 0x6e3d1000-0x7727bfff]
<6>
[    0.000000] ACPI: Early table checksum verification disabled
<4>
[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
<4>
[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>
[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140424/tbfadt-618)
<4>
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140424/tbfadt-699)
<4>
[    0.000000] ACPI: DSDT 0x00000000777EFED1 00ECE9 (v01 LENOVO TP-6I    00001120 MSFT 03000001)
<4>
[    0.000000] ACPI: FACS 0x00000000776E7000 000040
<4>
[    0.000000] ACPI: SSDT 0x00000000777EFCB4 00021D (v01 LENOVO TP-6I    00001120 MSFT 03000001)
<4>
[    0.000000] ACPI: ECDT 0x00000000777FEBBA 000052 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: APIC 0x00000000777FEC0C 000084 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: MCFG 0x00000000777FECC8 00003C (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: HPET 0x00000000777FED04 000038 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>
[    0.000000] ACPI: ASF! 0x00000000777FEDBE 0000A4 (v16 LENOVO TP-6I    00001120 PTL  00000001)
<4>
[    0.000000] ACPI: SLIC 0x00000000777FEE62 000176 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>
[    0.000000] ACPI: BOOT 0x00000000777FEFD8 000028 (v01 LENOVO TP-6I    00001120  LTP 00000001)
<4>
[    0.000000] ACPI: SSDT 0x00000000776E591A 00084B (v01 LENOVO TP-6I    00001120 INTL 20050513)
<4>
[    0.000000] ACPI: TCPA 0x000000007778B000 000032 (v02 PTL     CRESTLN 06040000      00005A52)
<4>
[    0.000000] ACPI: SSDT 0x000000007777A000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20050513)
<4>
[    0.000000] ACPI: SSDT 0x0000000077779000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20050513)
<4>
[    0.000000] ACPI: SSDT 0x0000000077778000 00049F (v01 PmRef  ApTst    00003000 INTL 20050513)
<7>
[    0.000000] ACPI: Local APIC address 0xfee00000
<4>
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>
[    0.000000] No NUMA configuration found
<6>
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000777fffff]
<6>
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x777fffff]
<6>
[    0.000000]   NODE_DATA [mem 0x77745000-0x7776bfff]
<7>
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff88006bc00000-ffff88006d9fffff] on node 0
<4>
[    0.000000] Zone ranges:
<4>
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>
[    0.000000]   Normal   empty
<4>
[    0.000000] Movable zone start for each node
<4>
[    0.000000] Early memory node ranges
<4>
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
<4>
[    0.000000]   node   0: [mem 0x00100000-0x7727bfff]
<4>
[    0.000000]   node   0: [mem 0x77282000-0x77362fff]
<4>
[    0.000000]   node   0: [mem 0x7740f000-0x7746efff]
<4>
[    0.000000]   node   0: [mem 0x7770f000-0x77716fff]
<4>
[    0.000000]   node   0: [mem 0x7771f000-0x7776bfff]
<4>
[    0.000000]   node   0: [mem 0x777ff000-0x777fffff]
<7>
[    0.000000] On node 0 totalpages: 488368
<7>
[    0.000000]   DMA zone: 64 pages used for memmap
<7>
[    0.000000]   DMA zone: 21 pages reserved
<7>
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>
[    0.000000]   DMA32 zone: 7584 pages used for memmap
<7>
[    0.000000]   DMA32 zone: 484371 pages, LIFO batch:31
<6>
[    0.000000] Reserving Intel graphics stolen memory at 0x7a000000-0x7bffffff
<6>
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
<7>
[    0.000000] ACPI: Local APIC address 0xfee00000
<4>
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
<6>
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
<6>
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 1, APIC INT 02
<6>
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 1, APIC INT 09
<7>
[    0.000000] ACPI: IRQ0 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 1, APIC INT 01
<7>
[    0.000000] ACPI: IRQ2 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 1, APIC INT 03
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 1, APIC INT 04
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 1, APIC INT 05
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 1, APIC INT 06
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 1, APIC INT 07
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 1, APIC INT 08
<7>
[    0.000000] ACPI: IRQ9 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 1, APIC INT 0a
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 1, APIC INT 0b
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 1, APIC INT 0c
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 1, APIC INT 0d
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 1, APIC INT 0e
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 1, APIC INT 0f
<6>
[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
<6>
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
<4>
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<7>
[    0.000000] nr_irqs_gsi: 40
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7727c000-0x77281fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77363000-0x77374fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77375000-0x773f5fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x773f6000-0x7740efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7746f000-0x77667fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77668000-0x776e7fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x776e8000-0x7770efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77717000-0x7771efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7776c000-0x77777fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x77778000-0x7777afff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7777b000-0x7778afff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7778b000-0x7778bfff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7778c000-0x7779efff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x7779f000-0x777fefff]
<6>
[    0.000000] e820: [mem 0x7c000000-0xdfffffff] available for PCI devices
<6>
[    0.000000] Booting paravirtualized kernel on bare hardware
<6>
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
<6>
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88006e000000 s87552 r8192 d23040 u524288
<7>
[    0.000000] pcpu-alloc: s87552 r8192 d23040 u524288 alloc=1*2097152
<7>
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<4>
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
<4>
[    0.000000] Policy zone: DMA32
<5>
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 user=lkp job=/lkp/scheduled/lkp-t410/bisect_boot-1-x86_64-rhel-c2b6ef437792d4d5f972d5147b809aac78a5b273-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/vmlinuz-3.16.0-rc4-00052-gc2b6ef4 kconfig=x86_64-rhel commit=c2b6ef437792d4d5f972d5147b809aac78a5b273 root=/dev/ram0 RESULT_ROOT=/result/lkp-t410/boot/1/x86_64-rhel/c2b6ef437792d4d5f972d5147b809aac78a5b273/0 ip=::::lkp-t410::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
<6>
[    0.000000] sysrq: sysrq always enabled.
<6>
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.000000] AGP: Checking aperture...
<6>
[    0.000000] AGP: No AGP bridge found
<4>
[    0.000000] Memory: 1757988K/1953472K available (8421K kernel code, 1656K rwdata, 3876K rodata, 1792K init, 1876K bss, 195484K reserved)
<6>
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>
[    0.000000] Hierarchical RCU implementation.
<6>
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
<6>
[    0.000000] 	Offload RCU callbacks from all CPUs
<6>
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
<6>
[    0.000000] NR_IRQS:524544 nr_irqs:712 16
<6>
[    0.000000] Console: colour VGA+ 80x25
<6>
[    0.000000] console [tty0] enabled
<6>
[    0.000000] bootconsole [earlyser0] disabled
<6>
[    0.000000] console [ttyS0] enabled
<6>
[    0.000000] allocated 7864320 bytes of page_cgroup
<6>
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>
[    0.000000] hpet clockevent registered
<6>
[    0.000000] tsc: Fast TSC calibration using PIT
<6>
[    0.000000] tsc: Detected 2394.038 MHz processor
<6>
[    0.000032] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.07 BogoMIPS (lpj=2394038)
<6>
[    0.000743] pid_max: default: 32768 minimum: 301
<6>
[    0.001061] ACPI: Core revision 20140424
<4>
[    0.014584] ACPI: All ACPI Tables successfully acquired
<6>
[    0.015067] Security Framework initialized
<6>
[    0.015358] SELinux:  Initializing.
<7>
[    0.015619] SELinux:  Starting in permissive mode
<6>
[    0.016083] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>
[    0.017240] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
<6>
[    0.017994] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.018426] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.019173] Initializing cgroup subsys memory
<6>
[    0.019548] Initializing cgroup subsys devices
<6>
[    0.019891] Initializing cgroup subsys freezer
<6>
[    0.020237] Initializing cgroup subsys net_cls
<6>
[    0.020591] Initializing cgroup subsys blkio
<6>
[    0.020928] Initializing cgroup subsys perf_event
<6>
[    0.021285] Initializing cgroup subsys hugetlb
<6>
[    0.021659] CPU: Physical Processor ID: 0
<6>
[    0.021976] CPU: Processor Core ID: 0
<6>
[    0.022277] mce: CPU supports 9 MCE banks
<6>
[    0.022612] CPU0: Thermal monitoring enabled (TM1)
<6>
[    0.022983] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
<6>
[    0.022983] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>
[    0.022983] tlb_flushall_shift: 6
<6>
[    0.024106] Freeing SMP alternatives memory: 32K (ffffffff81f65000 - ffffffff81f6d000)
<6>
[    0.025831] ftrace: allocating 30751 entries in 121 pages
<4>
[    0.041117] Getting VERSION: 1060015
<4>
[    0.041415] Getting VERSION: 1060015
<4>
[    0.041717] Getting ID: 0
<4>
[    0.041955] Getting ID: 0
<4>
[    0.042199] enabled ExtINT on CPU#0
<4>
[    0.042807] ENABLING IO-APIC IRQs
<7>
[    0.043086] init IO_APIC IRQs
<7>
[    0.043345]  apic 1 pin 0 not connected
<7>
[    0.043665] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>
[    0.044249] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>
[    0.044839] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>
[    0.045421] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>
[    0.046001] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>
[    0.046584] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>
[    0.047167] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>
[    0.047751] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>
[    0.048331] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>
[    0.048916] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>
[    0.049510] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>
[    0.050104] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>
[    0.050698] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>
[    0.051290] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>
[    0.051885] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>
[    0.052476]  apic 1 pin 16 not connected
<7>
[    0.052786]  apic 1 pin 17 not connected
<7>
[    0.053101]  apic 1 pin 18 not connected
<7>
[    0.053414]  apic 1 pin 19 not connected
<7>
[    0.053728]  apic 1 pin 20 not connected
<7>
[    0.054040]  apic 1 pin 21 not connected
<7>
[    0.054353]  apic 1 pin 22 not connected
<7>
[    0.054666]  apic 1 pin 23 not connected
<6>
[    0.055120] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>
[    0.065558] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
<4>
[    0.066405] Using local APIC timer interrupts.
<4>
[    0.066405] calibrating APIC timer ...
<4>
[    0.168567] ... lapic delta = 831240
<4>
[    0.168859] ... PM-Timer delta = 357951
<4>
[    0.169166] ... PM-Timer result ok
<4>
[    0.169450] ..... delta 831240
<4>
[    0.169712] ..... mult: 35701486
<4>
[    0.169985] ..... calibration result: 132998
<4>
[    0.170316] ..... CPU clock speed is 2393.0971 MHz.
<4>
[    0.170682] ..... host bus clock speed is 132.0998 MHz.
<6>
[    0.171101] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
<4>
[    0.171911] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
<6>
[    0.172393] ... version:                3
<6>
[    0.172708] ... bit width:              48
<6>
[    0.173028] ... generic registers:      4
<6>
[    0.173344] ... value mask:             0000ffffffffffff
<6>
[    0.173732] ... max period:             000000007fffffff
<6>
[    0.174122] ... fixed-purpose events:   3
<6>
[    0.174436] ... event mask:             000000070000000f
<6>
[    0.176527] x86: Booting SMP configuration:
<6>
[    0.176853] .... node  #0, CPUs:      #1
<4>
[    0.188337] masked ExtINT on CPU#1
<6>
[    0.190746] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>
[    0.191441]  #2
<4>
[    0.202613] masked ExtINT on CPU#2
<4>
[    0.205057]  #3
<4>
[    0.216219] masked ExtINT on CPU#3
<6>
[    0.218560] x86: Booted up 1 node, 4 CPUs
<6>
[    0.218879] smpboot: Total of 4 processors activated (19152.30 BogoMIPS)
<6>
[    0.221758] devtmpfs: initialized
<6>
[    0.224375] evm: security.selinux
<6>
[    0.224655] evm: security.ima
<6>
[    0.224914] evm: security.capability
<6>
[    0.225343] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
<6>
[    0.225935] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
<6>
[    0.226528] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
<6>
[    0.227104] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
<6>
[    0.227685] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
<6>
[    0.229324] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>
[    0.229870] NET: Registered protocol family 16
<6>
[    0.230419] cpuidle: using governor menu
<6>
[    0.230849] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>
[    0.231415] ACPI: bus type PCI registered
<6>
[    0.231734] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>
[    0.232255] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>
[    0.232914] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>
[    0.233890] PCI: Using configuration type 1 for base access
<6>
[    0.237390] ACPI: Added _OSI(Module Device)
<6>
[    0.237718] ACPI: Added _OSI(Processor Device)
<6>
[    0.238062] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>
[    0.238419] ACPI: Added _OSI(Processor Aggregator Device)
<6>
[    0.240160] ACPI : EC: EC description table is found, configuring boot EC
<5>
[    0.244590] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<4>
[    0.320894] ACPI: Dynamic OEM Table Load:
<4>
[    0.321319] ACPI: SSDT 0xFFFF88006AED0800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
<4>
[    0.322488] ACPI: Dynamic OEM Table Load:
<4>
[    0.322912] ACPI: SSDT 0xFFFF88006AED1000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
<4>
[    0.328258] ACPI: Dynamic OEM Table Load:
<4>
[    0.328684] ACPI: SSDT 0xFFFF88006AE45400 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
<4>
[    0.331862] ACPI: Dynamic OEM Table Load:
<4>
[    0.332284] ACPI: SSDT 0xFFFF88006A820000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
<6>
[    0.336580] ACPI: Interpreter enabled
<4>
[    0.336886] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
<4>
[    0.337643] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
<6>
[    0.338406] ACPI: (supports S0 S3 S4 S5)
<6>
[    0.338719] ACPI: Using IOAPIC for interrupt routing
<6>
[    0.339112] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>
[    0.345367] ACPI: Power Resource [PUBS] (on)
<6>
[    0.346376] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
<6>
[    0.348432] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
<6>
[    0.350872] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.351912] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.352931] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>
[    0.354170] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.355209] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.356228] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>
[    0.357449] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>
[    0.358687] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
<6>
[    0.359712] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
<6>
[    0.360144] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>
[    0.360741] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>
[    0.361249] PCI host bridge to bus 0000:ff
<6>
[    0.361572] pci_bus 0000:ff: root bus resource [bus ff]
<7>
[    0.361965] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
<7>
[    0.362446] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
<7>
[    0.362922] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
<7>
[    0.363391] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
<7>
[    0.363863] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
<7>
[    0.364336] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
<6>
[    0.364834] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
<6>
[    0.365280] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>
[    0.366035] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
<6>
[    0.366603] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
<6>
[    0.367261] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
<6>
[    0.367833] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
<6>
[    0.368976] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
<6>
[    0.369596] PCI host bridge to bus 0000:00
<6>
[    0.369922] pci_bus 0000:00: root bus resource [bus 00-fe]
<6>
[    0.370324] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>
[    0.370766] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>
[    0.371207] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>
[    0.371688] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
<6>
[    0.372169] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
<6>
[    0.372649] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
<6>
[    0.373131] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
<7>
[    0.373617] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
<6>
[    0.374062] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
<7>
[    0.374672] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
<7>
[    0.375115] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
<7>
[    0.375596] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
<7>
[    0.376141] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
<7>
[    0.376651] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
<7>
[    0.377109] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
<7>
[    0.377673] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>
[    0.378181] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
<7>
[    0.378634] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
<7>
[    0.379051] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
<7>
[    0.379655] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
<7>
[    0.380111] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
<7>
[    0.380567] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
<7>
[    0.381024] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
<7>
[    0.381517] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>
[    0.381992] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>
[    0.382448] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
<7>
[    0.382905] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
<7>
[    0.383458] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>
[    0.383933] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>
[    0.384390] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
<7>
[    0.384845] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
<7>
[    0.385427] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>
[    0.385908] pci 0000:00:1b.0: System wakeup disabled by ACPI
<7>
[    0.386359] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
<7>
[    0.386897] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>
[    0.387372] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>
[    0.387825] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
<7>
[    0.388359] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<6>
[    0.388836] pci 0000:00:1c.1: System wakeup disabled by ACPI
<7>
[    0.389287] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
<7>
[    0.389824] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
<6>
[    0.390298] pci 0000:00:1c.3: System wakeup disabled by ACPI
<7>
[    0.390748] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
<7>
[    0.391284] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>
[    0.391758] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>
[    0.392219] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
<7>
[    0.392673] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
<7>
[    0.393228] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>
[    0.393699] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>
[    0.394150] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
<7>
[    0.394708] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
<7>
[    0.395312] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
<7>
[    0.395766] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
<7>
[    0.396185] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
<7>
[    0.396601] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
<7>
[    0.397017] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
<7>
[    0.397433] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
<7>
[    0.397851] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
<7>
[    0.398361] pci 0000:00:1f.2: PME# supported from D3hot
<7>
[    0.398819] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
<7>
[    0.399271] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
<7>
[    0.399774] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
<7>
[    0.400269] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
<7>
[    0.400727] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
<6>
[    0.401408] pci 0000:00:1c.0: PCI bridge to [bus 02]
<7>
[    0.401888] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
<7>
[    0.402363] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
<7>
[    0.403042] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
<6>
[    0.405809] pci 0000:00:1c.1: PCI bridge to [bus 03]
<7>
[    0.406191] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>
[    0.406763] acpiphp: Slot [1] registered
<6>
[    0.407084] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<7>
[    0.407475] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<7>
[    0.407916] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<7>
[    0.408398] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<7>
[    0.409105] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
<5>
[    0.409603] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
<7>
[    0.410167] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
<7>
[    0.410835] pci 0000:0d:00.0: supports D1 D2
<7>
[    0.411167] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>
[    0.411810] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
<7>
[    0.412312] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
<7>
[    0.412971] pci 0000:0d:00.1: supports D1 D2
<7>
[    0.413305] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
<7>
[    0.413942] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
<7>
[    0.414446] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
<7>
[    0.415107] pci 0000:0d:00.3: supports D1 D2
<7>
[    0.415440] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
<6>
[    0.417873] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<7>
[    0.418250] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>
[    0.418812] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
<7>
[    0.419300] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>
[    0.419883] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>
[    0.420462] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>
[    0.421083] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
<7>
[    0.421704] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
<7>
[    0.422325] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
<7>
[    0.422944] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
<7>
[    0.423767] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<4>
[    0.425559] ACPI: Enabled 3 GPEs in block 00 to 3F
<6>
[    0.426085] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
<6>
[    0.426684] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>
[    0.427277] vgaarb: loaded
<6>
[    0.427521] vgaarb: bridge control possible 0000:00:02.0
<5>
[    0.428002] SCSI subsystem initialized
<6>
[    0.428335] ACPI: bus type USB registered
<6>
[    0.428676] usbcore: registered new interface driver usbfs
<6>
[    0.429087] usbcore: registered new interface driver hub
<6>
[    0.429519] usbcore: registered new device driver usb
<6>
[    0.429922] pps_core: LinuxPPS API ver. 1 registered
<6>
[    0.430299] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>
[    0.430953] PTP clock support registered
<6>
[    0.431331] PCI: Using ACPI for IRQ routing
<7>
[    0.441567] PCI: pci_cache_line_size set to 64 bytes
<7>
[    0.442104] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
<7>
[    0.442538] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
<7>
[    0.442970] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
<7>
[    0.443405] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
<7>
[    0.443838] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
<7>
[    0.444271] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
<7>
[    0.444703] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
<6>
[    0.445246] NetLabel: Initializing
<6>
[    0.445529] NetLabel:  domain hash size = 128
<6>
[    0.445867] NetLabel:  protocols = UNLABELED CIPSOv4
<6>
[    0.446255] NetLabel:  unlabeled traffic allowed by default
<6>
[    0.446787] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>
[    0.447685] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>
[    0.450141] Switched to clocksource hpet
<6>
[    0.459854] pnp: PnP ACPI init
<6>
[    0.460139] ACPI: bus type PNP registered
<6>
[    0.461907] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
<6>
[    0.462405] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
<6>
[    0.462891] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
<6>
[    0.463385] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
<6>
[    0.463851] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
<6>
[    0.464324] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
<6>
[    0.464809] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
<6>
[    0.465298] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
<6>
[    0.465783] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
<6>
[    0.466273] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
<6>
[    0.466757] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
<6>
[    0.467247] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
<6>
[    0.467730] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
<6>
[    0.468220] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
<6>
[    0.468705] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
<7>
[    0.469197] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>
[    0.469992] system 00:01: [io  0x164e-0x164f] has been reserved
<6>
[    0.470429] system 00:01: [io  0x1000-0x107f] could not be reserved
<6>
[    0.470874] system 00:01: [io  0x1180-0x11ff] has been reserved
<6>
[    0.471307] system 00:01: [io  0x0800-0x080f] has been reserved
<6>
[    0.471733] system 00:01: [io  0x15e0-0x15ef] has been reserved
<6>
[    0.472165] system 00:01: [io  0x1600-0x1641] has been reserved
<6>
[    0.472593] system 00:01: [io  0x1644-0x167f] could not be reserved
<6>
[    0.473040] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
<6>
[    0.473511] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>
[    0.473977] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
<6>
[    0.474449] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
<6>
[    0.474914] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
<6>
[    0.475386] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
<7>
[    0.475853] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>
[    0.476373] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>
[    0.476984] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>
[    0.477461] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
<7>
[    0.478659] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
<7>
[    0.479127] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
<7>
[    0.479750] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
<7>
[    0.480592] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
<6>
[    0.481808] pnp: PnP ACPI: found 6 devices
<6>
[    0.482132] ACPI: bus type PNP unregistered
<6>
[    0.489249] pci 0000:00:1c.0: PCI bridge to [bus 02]
<6>
[    0.489636] pci 0000:00:1c.1: PCI bridge to [bus 03]
<6>
[    0.490011] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>
[    0.490501] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<6>
[    0.490889] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<6>
[    0.491336] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<6>
[    0.491815] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<6>
[    0.492399] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<6>
[    0.492775] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>
[    0.493263] pci 0000:00:1e.0: PCI bridge to [bus 0e]
<7>
[    0.493646] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>
[    0.494053] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>
[    0.494466] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>
[    0.494912] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
<7>
[    0.495364] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
<7>
[    0.495809] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
<7>
[    0.496260] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
<7>
[    0.496711] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
<7>
[    0.497155] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
<7>
[    0.497567] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
<7>
[    0.498012] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
<7>
[    0.498557] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
<7>
[    0.499002] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
<7>
[    0.499413] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
<7>
[    0.499819] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
<7>
[    0.500271] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
<7>
[    0.500717] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
<7>
[    0.501162] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
<7>
[    0.501614] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
<6>
[    0.502089] NET: Registered protocol family 2
<6>
[    0.502612] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
<6>
[    0.503219] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
<6>
[    0.503758] TCP: Hash tables configured (established 16384 bind 16384)
<6>
[    0.504254] TCP: reno registered
<6>
[    0.504532] UDP hash table entries: 1024 (order: 3, 32768 bytes)
<6>
[    0.504977] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
<6>
[    0.505496] NET: Registered protocol family 1
<6>
[    0.505937] RPC: Registered named UNIX socket transport module.
<6>
[    0.506379] RPC: Registered udp transport module.
<6>
[    0.506735] RPC: Registered tcp transport module.
<6>
[    0.507092] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>
[    0.507581] pci 0000:00:02.0: Boot video device
<7>
[    0.508013] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>
[    0.508741] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
<7>
[    0.509476] PCI: CLS 64 bytes, default 64
<6>
[    0.509857] Unpacking initramfs...
<6>
[    3.226838] Freeing initrd memory: 146092K (ffff88006e3d1000 - ffff88007727c000)
<6>
[    3.227585] Simple Boot Flag at 0x35 set to 0x1
<6>
[    3.228932] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>
[    3.229398] Initialise system trusted keyring
<6>
[    3.229753] audit: initializing netlink subsys (disabled)
<5>
[    3.230198] audit: type=2000 audit(1405662278.044:1): initialized
<6>
[    3.230977] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>
[    3.232953] zbud: loaded
<5>
[    3.233362] VFS: Disk quotas dquot_6.5.2
<4>
[    3.233712] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>
[    3.234690] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
<6>
[    3.235699] 9p: Installing v9fs 9p2000 file system support
<6>
[    3.236148] msgmni has been set to 3718
<5>
[    3.236512] Key type big_key registered
<7>
[    3.236822] SELinux:  Registering netfilter hooks
<6>
[    3.238320] alg: No test for stdrng (krng)
<6>
[    3.238656] NET: Registered protocol family 38
<5>
[    3.239015] Key type asymmetric registered
<5>
[    3.239339] Asymmetric key parser 'x509' registered
<6>
[    3.239745] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>
[    3.240373] io scheduler noop registered
<6>
[    3.240688] io scheduler deadline registered (default)
<6>
[    3.241106] io scheduler cfq registered
<7>
[    3.241607] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
<7>
[    3.242322] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
<6>
[    3.243221] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>
[    3.243642] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>
[    3.244164] intel_idle: MWAIT substates: 0x1120
<7>
[    3.244513] intel_idle: v0.4 model 0x25
<7>
[    3.244821] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>
[    3.246016] ACPI: AC Adapter [AC] (on-line)
<6>
[    3.246438] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
<6>
[    3.248199] ACPI: Lid Switch [LID]
<6>
[    3.248575] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
<6>
[    3.249205] ACPI: Sleep Button [SLPB]
<6>
[    3.249591] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
<6>
[    3.250170] ACPI: Power Button [PWRF]
<6>
[    3.256031] thermal LNXTHERM:00: registered as thermal_zone0
<6>
[    3.256448] ACPI: Thermal Zone [THM0] (48 C)
<6>
[    3.256838] GHES: HEST is not enabled!
<6>
[    3.257374] ACPI: Battery Slot [BAT0] (battery absent)
<6>
[    3.257441] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<7>
[    3.258686] IOAPIC[0]: Set routing entry (1-17 -> 0x81 -> IRQ 17 Mode:1 Active:1 Dest:15)
<6>
[    3.259525] console [ttyS0] disabled
<6>
[    3.280335] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
<6>
[    4.231515] tsc: Refined TSC clocksource calibration: 2393.999 MHz
<6>
[    5.085414] console [ttyS0] enabled
<6>
[    5.088063] Non-volatile memory driver v1.3
<6>
[    5.090333] Linux agpgart interface v0.103
<6>
[    5.092145] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
<6>
[    5.094447] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
<6>
[    5.098945] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
<6>
[    5.101850] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
<6>
[    5.105724] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
<6>
[    5.143094] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
<7>
[    5.146196] IOAPIC[0]: Set routing entry (1-16 -> 0x91 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>
[    5.149788] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
<4>
[    5.153293] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140424/utaddress-258)
<6>
[    5.159958] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.165010] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
<6>
[    5.172884] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.177111] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
<6>
[    5.184861] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.189212] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140424/utaddress-258)
<6>
[    5.197004] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    5.201326] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>
[    5.203928] rdac: device handler registered
<6>
[    5.205808] hp_sw: device handler registered
<6>
[    5.207680] emc: device handler registered
<6>
[    5.209613] alua: device handler registered
<6>
[    5.211610] libphy: Fixed MDIO Bus: probed
<6>
[    5.213588] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>
[    5.216986] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>
[    5.219331] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>
[    5.221682] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<6>
[    5.225144] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>
[    5.229069] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<6>
[    5.231408] Switched to clocksource tsc
<6>
[    5.412940] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
<6>
[    5.415332] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>
[    5.419004] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
<6>
[    5.422331] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
<6>
[    5.424983] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>
[    5.427236] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>
[    5.431033] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>
[    5.433739] usbcore: registered new interface driver catc
<6>
[    5.436506] usbcore: registered new interface driver kaweth
<6>
[    5.438827] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>
[    5.442357] usbcore: registered new interface driver pegasus
<6>
[    5.444708] usbcore: registered new interface driver rtl8150
<6>
[    5.447024] usbcore: registered new interface driver asix
<6>
[    5.449347] usbcore: registered new interface driver cdc_ether
<6>
[    5.452459] usbcore: registered new interface driver cdc_eem
<6>
[    5.454780] usbcore: registered new interface driver dm9601
<6>
[    5.457034] usbcore: registered new interface driver smsc75xx
<6>
[    5.459543] usbcore: registered new interface driver smsc95xx
<6>
[    5.462630] usbcore: registered new interface driver gl620a
<6>
[    5.464945] usbcore: registered new interface driver net1080
<6>
[    5.467239] usbcore: registered new interface driver plusb
<6>
[    5.469588] usbcore: registered new interface driver rndis_host
<6>
[    5.472774] usbcore: registered new interface driver cdc_subset
<6>
[    5.475122] usbcore: registered new interface driver zaurus
<6>
[    5.477425] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>
[    5.481049] usbcore: registered new interface driver int51x1
<6>
[    5.483383] usbcore: registered new interface driver ipheth
<6>
[    5.486554] usbcore: registered new interface driver sierra_net
<6>
[    5.489131] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>
[    5.491813] ehci-pci: EHCI PCI platform driver
<6>
[    5.493768] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>
[    5.496685] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>
[    5.499395] ehci-pci 0000:00:1a.0: debug port 2
<7>
[    5.505218] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>
[    5.508911] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
<6>
[    5.516363] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>
[    5.518664] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    5.521947] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    5.525526] usb usb1: Product: EHCI Host Controller
<6>
[    5.527643] usb usb1: Manufacturer: Linux 3.16.0-rc4-00052-gc2b6ef4 ehci_hcd
<6>
[    5.530335] usb usb1: SerialNumber: 0000:00:1a.0
<6>
[    5.532592] hub 1-0:1.0: USB hub found
<6>
[    5.534271] hub 1-0:1.0: 3 ports detected
<6>
[    5.536446] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>
[    5.538419] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>
[    5.541995] ehci-pci 0000:00:1d.0: debug port 2
<7>
[    5.547939] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>
[    5.550599] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
<6>
[    5.559390] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>
[    5.561123] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    5.563762] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    5.567294] usb usb2: Product: EHCI Host Controller
<6>
[    5.569494] usb usb2: Manufacturer: Linux 3.16.0-rc4-00052-gc2b6ef4 ehci_hcd
<6>
[    5.572933] usb usb2: SerialNumber: 0000:00:1d.0
<6>
[    5.575187] hub 2-0:1.0: USB hub found
<6>
[    5.576845] hub 2-0:1.0: 3 ports detected
<6>
[    5.578948] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>
[    5.581198] ohci-pci: OHCI PCI platform driver
<6>
[    5.583188] uhci_hcd: USB Universal Host Controller Interface driver
<6>
[    5.585794] usbcore: registered new interface driver usbserial
<6>
[    5.588948] usbcore: registered new interface driver usbserial_generic
<6>
[    5.591404] usbserial: USB Serial support registered for generic
<6>
[    5.594738] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
<6>
[    5.600686] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>
[    5.602765] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>
[    5.606023] mousedev: PS/2 mouse device common for all mice
<6>
[    5.608512] rtc_cmos 00:02: RTC can wake from S4
<6>
[    5.610553] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>
[    5.612587] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>
[    5.613248] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
<6>
[    5.620168] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>
[    5.622477] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
<6>
[    5.626103] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>
[    5.628358] iTCO_vendor_support: vendor-support=0
<6>
[    5.630769] hidraw: raw HID events driver (C) Jiri Kosina
<6>
[    5.632752] usbcore: registered new interface driver usbhid
<6>
[    5.635824] usbhid: USB HID core driver
<6>
[    5.636921] drop_monitor: Initializing network drop monitor service
<6>
[    5.640158] TCP: cubic registered
<6>
[    5.641879] Initializing XFRM netlink socket
<6>
[    5.644042] NET: Registered protocol family 10
<6>
[    5.646106] NET: Registered protocol family 17
<6>
[    5.647860] 9pnet: Installing 9P2000 support
<7>
[    5.650097] 
<7>
[    5.650097] printing PIC contents
<7>
[    5.651899] ... PIC  IMR: ffff
<7>
[    5.652801] ... PIC  IRR: 1800
<7>
[    5.654427] ... PIC  ISR: 0000
<7>
[    5.655972] ... PIC ELCR: 0a00
<7>
[    5.656876] printing local APIC contents on CPU#0/0:
<6>
[    5.658962] ... APIC ID:      00000000 (0)
<6>
[    5.660751] ... APIC VERSION: 01060015
<7>
[    5.662615] ... APIC TASKPRI: 00000000 (00)
<7>
[    5.664595] ... APIC PROCPRI: 00000000
<7>
[    5.666356] ... APIC LDR: 01000000
<7>
[    5.668106] ... APIC DFR: ffffffff
<7>
[    5.669852] ... APIC SPIV: 000001ff
<7>
[    5.670840] ... APIC ISR field:
<4>
[    5.672383] 0000000000000000000000000000000000000000000000000000000000000000
<7>
[    5.676064] ... APIC TMR field:
<4>
[    5.676930] 0000000002000000000000000000000000000000000000000000000000000000
<7>
[    5.680485] ... APIC IRR field:
<4>
[    5.681960] 0000000010000000000000000000000000000000000000000000000000008000
<7>
[    5.684970] ... APIC ESR: 00000000
<7>
[    5.686364] ... APIC ICR: 000008fd
<7>
[    5.688128] ... APIC ICR2: 04000000
<7>
[    5.689893] ... APIC LVTT: 000000ef
<7>
[    5.690925] ... APIC LVTPC: 00000400
<7>
[    5.692493] ... APIC LVT0: 00010700
<7>
[    5.694376] ... APIC LVT1: 00000400
<7>
[    5.696057] ... APIC LVTERR: 000000fe
<7>
[    5.697870] ... APIC TMICT: 00000f6a
<7>
[    5.698962] ... APIC TMCCT: 00000000
<7>
[    5.700560] ... APIC TDCR: 00000003
<4>
[    5.702298] 
<7>
[    5.702774] number of MP IRQ sources: 15.
<7>
[    5.704684] number of IO-APIC #1 registers: 24.
<6>
[    5.706618] testing the IO APIC.......................
<7>
[    5.708805] IO APIC #1......
<7>
[    5.710490] .... register #00: 02000000
<7>
[    5.712252] .......    : physical APIC id: 02
<7>
[    5.714290] .......    : Delivery Type: 0
<7>
[    5.716136] .......    : LTS          : 0
<7>
[    5.718063] .... register #01: 00170020
<7>
[    5.719216] .......     : max redirection entries: 17
<7>
[    5.722056] .......     : PRQ implemented: 0
<7>
[    5.724097] .......     : IO APIC version: 20
<7>
[    5.725981] .... IRQ redirection table:
<4>
[    5.727029] 1    0    0   0   0    0    0    00
<4>
[    5.729067] 0    0    0   0   0    1    1    31
<4>
[    5.730978] 0    0    0   0   0    1    1    30
<4>
[    5.733115] 0    0    0   0   0    1    1    33
<4>
[    5.735945] 0    0    0   0   0    1    1    34
<4>
[    5.737972] 0    0    0   0   0    1    1    35
<4>
[    5.740004] 0    0    0   0   0    1    1    36
<4>
[    5.742008] 0    0    0   0   0    1    1    37
<4>
[    5.744134] 0    0    0   0   0    1    1    38
<4>
[    5.746060] 0    1    0   0   0    1    1    39
<4>
[    5.748096] 0    0    0   0   0    1    1    3A
<4>
[    5.750125] 0    0    0   0   0    1    1    3B
<4>
[    5.752152] 0    0    0   0   0    1    1    3C
<4>
[    5.754286] 0    0    0   0   0    1    1    3D
<4>
[    5.756197] 0    0    0   0   0    1    1    3E
<4>
[    5.758231] 0    0    0   0   0    1    1    3F
<4>
[    5.760283] 1    1    0   1   0    1    1    91
<4>
[    5.762238] 1    1    0   1   0    1    1    81
<4>
[    5.764356] 1    0    0   0   0    0    0    00
<4>
[    5.766323] 0    1    0   1   0    1    1    51
<4>
[    5.768339] 1    1    0   1   0    1    1    61
<4>
[    5.770383] 1    1    0   1   0    1    1    71
<4>
[    5.772427] 1    0    0   0   0    0    0    00
<4>
[    5.774512] 0    1    0   1   0    1    1    41
<7>
[    5.776426] IRQ to pin mappings:
<7>
[    5.778139] IRQ0 -> 0:2
<7>
[    5.778959] IRQ1 -> 0:1
<7>
[    5.780415] IRQ3 -> 0:3
<7>
[    5.781199] IRQ4 -> 0:4
<7>
[    5.782529] IRQ5 -> 0:5
<7>
[    5.783400] IRQ6 -> 0:6
<7>
[    5.784662] IRQ7 -> 0:7
<7>
[    5.785471] IRQ8 -> 0:8
<7>
[    5.786759] IRQ9 -> 0:9
<7>
[    5.788174] IRQ10 -> 0:10
<7>
[    5.789105] IRQ11 -> 0:11
<7>
[    5.790477] IRQ12 -> 0:12
<7>
[    5.791321] IRQ13 -> 0:13
<7>
[    5.792593] IRQ14 -> 0:14
<7>
[    5.794114] IRQ15 -> 0:15
<7>
[    5.794992] IRQ16 -> 0:16
<7>
[    5.796376] IRQ17 -> 0:17
<7>
[    5.797244] IRQ19 -> 0:19
<7>
[    5.798623] IRQ20 -> 0:20
<7>
[    5.799593] IRQ21 -> 0:21
<7>
[    5.800766] IRQ23 -> 0:23
<6>
[    5.802324] .................................... done.
<5>
[    5.804628] Loading compiled-in X.509 certificates
<5>
[    5.807314] Loaded X.509 cert 'Magrathea: Glacier signing key: ba9e94da3cc394358d403063eadcaa3ddf88d3ca'
<6>
[    5.811635] registered taskstats version 1
<5>
[    5.816643] Key type trusted registered
<5>
[    5.821671] Key type encrypted registered
<3>
[    5.831513] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
<6>
[    5.834201] ima: No TPM chip found, activating TPM-bypass!
<6>
[    5.837304] evm: HMAC attrs: 0x1
<6>
[    5.837528] usb 1-1: new high-speed USB device number 2 using ehci-pci
<6>
[    5.843404] rtc_cmos 00:02: setting system clock to 2014-07-18 05:44:41 UTC (1405662281)
<6>
[    5.952125] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
<6>
[    5.954026] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<7>
[    5.956830] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<6>
[    5.960363] hub 1-1:1.0: USB hub found
<6>
[    5.961802] hub 1-1:1.0: 6 ports detected
<7>
[    6.057726] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
<6>
[    6.060111] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>
[    6.066670] usb 2-1: new high-speed USB device number 2 using ehci-pci
<6>
[    6.184170] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
<6>
[    6.186455] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>
[    6.190628] hub 2-1:1.0: USB hub found
<6>
[    6.192072] hub 2-1:1.0: 8 ports detected
<6>
[    6.268001] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
<6>
[    6.358299] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
<6>
[    6.360326] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>
[    6.363995] usb 1-1.3: Product: Biometric Coprocessor
<6>
[    6.366084] usb 1-1.3: Manufacturer: UPEK
<6>
[    6.442059] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
<6>
[    6.536872] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
<6>
[    6.539416] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>
[    6.543005] usb 1-1.6: Product: Integrated Camera
<6>
[    6.545112] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
<6>
[    6.597072] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
<6>
[    6.602468] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
<6>
[    6.655847] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
<6>
[    8.412621] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx
<6>
[    8.422223] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>
[    8.433152] Sending DHCP requests ., OK
<4>
[    8.473288] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
<6>
[    8.485951] IP-Config: Complete:
<6>
[    8.489147]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
<6>
[    8.504797]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
<6>
[    8.513690]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>
[    8.522101]      nameserver0=192.168.1.1
<7>
[    8.528532] PM: Hibernation image not present or could not be loaded.
<6>
[    8.537417] Freeing unused kernel memory: 1792K (ffffffff81da5000 - ffffffff81f65000)
<6>
[    8.820067] wmi: Mapper loaded
<7>
[    8.851172] libata version 3.00 loaded.
<6>
[    8.865245] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<6>
[    8.886462] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
<6>
[    8.886472] Linux video capture interface: v2.00
<6>
[    8.904018] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
<6>
[    8.912935] input: PC Speaker as /devices/platform/pcspkr/input/input7
<6>
[    8.923630] [drm] Initialized drm 1.1.0 20060810
<6>
[    8.924819] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
<7>
[    8.924863] ahci 0000:00:1f.2: version 3.0
<7>
[    8.925143] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
<6>
[    8.925196] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
<6>
[    8.925288] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
<6>
[    8.925295] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
<6>
[    8.954521] sdhci: Secure Digital Host Controller Interface driver
<6>
[    8.956872] sdhci: Copyright(c) Pierre Ossman
<6>
[    8.959418] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
<6>
[    8.960425] scsi0 : ahci
<6>
[    8.966877] scsi1 : ahci
<5>
[    8.975182] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
<6>
[    8.982449] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
<6>
[    8.983922] thinkpad_acpi: ThinkPad ACPI Extras v0.25
<6>
[    8.983923] thinkpad_acpi: http://ibm-acpi.sf.net/
<6>
[    8.983925] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
<6>
[    8.983926] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
<6>
[    8.986154] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
<6>
[    8.986697] thinkpad_acpi: radio switch found; radios are disabled
<6>
[    8.986885] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
<5>
[    8.986886] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
<6>
[    8.990978] scsi2 : ahci
<6>
[    8.995393] scsi3 : ahci
<6>
[    8.997724] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input9
<6>
[    8.997862] usbcore: registered new interface driver uvcvideo
<6>
[    8.997864] USB Video Class driver (1.1.1)
<6>
[    9.004459] scsi4 : ahci
<6>
[    9.005356] scsi5 : ahci
<6>
[    9.005488] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 42
<6>
[    9.005493] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 42
<6>
[    9.005494] ata3: DUMMY
<6>
[    9.005496] ata4: DUMMY
<6>
[    9.005500] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 42
<6>
[    9.005503] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 42
<6>
[    9.005627] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
<4>
[    9.043876] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
<6>
[    9.047966] mmc0: no vqmmc regulator found
<6>
[    9.048548] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
<6>
[    9.048742] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
<6>
[    9.056716] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
<6>
[    9.060517] mmc0: no vmmc regulator found
<3>
[    9.063956] Error: Driver 'pcspkr' is already registered, aborting...
<6>
[    9.071593] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
<7>
[    9.075197] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
<6>
[    9.127453] [drm] Memory usable by graphics device = 2048M
<6>
[    9.130664] [drm] Replacing VGA console driver
<6>
[    9.133206] Console: switching to colour dummy device 80x25
<6>
[    9.138911] sound hdaudioC0D0: CX20585: BIOS auto-probing.
<6>
[    9.141632] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
<6>
[    9.145021] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<7>
[    9.146704] i915 0000:00:02.0: irq 44 for MSI/MSI-X
<6>
[    9.146723] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>
[    9.146724] [drm] Driver supports precise vblank timestamp query.
<4>
[    9.147237] ------------[ cut here ]------------
<4>
[    9.147300] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:139 ironlake_enable_display_irq+0x73/0x80 [i915]()
<4>
[    9.147336] Modules linked in: snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
<4>
[    9.147340] CPU: 0 PID: 271 Comm: modprobe Not tainted 3.16.0-rc4-00052-gc2b6ef4 #1
<4>
[    9.147342] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.147347]  0000000000000009 ffff880076b0f8e0 ffffffff8182b6d0 0000000000000000
<4>
[    9.147350]  ffff880076b0f918 ffffffff8106d0dd ffff880074f30000 ffff880074f37128
<4>
[    9.147354]  0000000000000246 ffff880074f30000 ffff880074f30000 ffff880076b0f928
<4>
[    9.147355] Call Trace:
<4>
[    9.147365]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.147373]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.147376]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.147421]  [<ffffffffa02a88b3>] ironlake_enable_display_irq+0x73/0x80 [i915]
<4>
[    9.147466]  [<ffffffffa02a912f>] ironlake_irq_postinstall+0x17f/0x1a0 [i915]
<4>
[    9.147488]  [<ffffffffa00957be>] drm_irq_install+0xbe/0x1a0 [drm]
<4>
[    9.147547]  [<ffffffffa03067e7>] i915_driver_load+0xb07/0xfe0 [i915]
<4>
[    9.147555]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.147560]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.147564]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.147569]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.147572]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.147595]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.147614]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.147634]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.147668]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.147674]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.147679]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.147683]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.147688]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.147691]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.147694]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.147697]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.147700]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.147704]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.147707]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.147712]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.147731]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.147736]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
<4>
[    9.147771]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
<4>
[    9.147779]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.147784]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.147789]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.147797]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.147801]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.147805]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
<4>
[    9.147810]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.147817]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.147820] ---[ end trace 2d05078fac923b98 ]---
<6>
[    9.147880] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<4>
[    9.191847] ------------[ cut here ]------------
<4>
[    9.191900] WARNING: CPU: 2 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
<4>
[    9.191932] Modules linked in: snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
<4>
[    9.191936] CPU: 2 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
<4>
[    9.191938] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.191941]  0000000000000009 ffff880076b0f8d8 ffffffff8182b6d0 0000000000000000
<4>
[    9.191944]  ffff880076b0f910 ffffffff8106d0dd ffff880074f30000 0000000000000f40
<4>
[    9.191946]  0000000000000f00 0000000000000246 ffff880074f30000 ffff880076b0f920
<4>
[    9.191948] Call Trace:
<4>
[    9.191957]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.191963]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.191966]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.192006]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
<4>
[    9.192045]  [<ffffffffa02a89ca>] ibx_hpd_irq_setup+0x6a/0xf0 [i915]
<4>
[    9.192085]  [<ffffffffa02b1b68>] intel_hpd_init+0xc8/0xe0 [i915]
<4>
[    9.192134]  [<ffffffffa0306c1d>] i915_driver_load+0xf3d/0xfe0 [i915]
<4>
[    9.192140]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.192145]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.192148]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.192152]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.192155]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.192179]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.192195]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.192212]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.192242]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.192246]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.192250]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.192254]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.192257]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.192260]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.192263]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.192265]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.192268]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.192271]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.192274]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.192277]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.192294]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.192297]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
<4>
[    9.192326]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
<4>
[    9.192331]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.192335]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.192340]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.192346]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.192350]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.192354]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
<4>
[    9.192358]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.192363]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.192365] ---[ end trace 2d05078fac923b99 ]---
<6>
[    9.253603] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
<6>
[    9.457034] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
<6>
[    9.457036] sound hdaudioC0D0:    mono: mono_out=0x0
<6>
[    9.457038] sound hdaudioC0D0:    inputs:
<6>
[    9.457043] sound hdaudioC0D0:      Mic=0x1b
<6>
[    9.457046] sound hdaudioC0D0:      Internal Mic=0x23
<6>
[    9.457049] sound hdaudioC0D0:      Dock Mic=0x1a
<6>
[    9.457059] fbcon: inteldrmfb (fb0) is primary device
<6>
[    9.458491] sound hdaudioC0D0: Enable sync_write for stable communication
<6>
[    9.465745] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<7>
[    9.467394] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[    9.467399] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>
[    9.467482] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[    9.467486] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>
[    9.468949] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
<6>
[    9.468952] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<7>
[    9.470593] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[    9.470597] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>
[    9.470682] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>
[    9.470685] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>
[    9.472116] ata1.00: configured for UDMA/100
<5>
[    9.472343] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
<6>
[    9.473237] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
<6>
[    9.473905] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>
[    9.474108] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>
[    9.474323] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>
[    9.474511] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>
[    9.474694] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
<6>
[    9.474891] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
<5>
[    9.480926] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
<4>
[    9.732977] ------------[ cut here ]------------
<4>
[    9.733033] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
<4>
[    9.733066] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
<4>
[    9.733071] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
<4>
[    9.733072] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.733076]  0000000000000009 ffff880076b0f368 ffffffff8182b6d0 0000000000000000
<4>
[    9.733078]  ffff880076b0f3a0 ffffffff8106d0dd ffff880074f30000 0000000000000001
<4>
[    9.733081]  0000000000000000 ffff880074f30000 0000000000000000 ffff880076b0f3b0
<4>
[    9.733082] Call Trace:
<4>
[    9.733091]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.733098]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.733102]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.733142]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
<4>
[    9.733183]  [<ffffffffa02aca92>] intel_set_pch_fifo_underrun_reporting+0x152/0x1b0 [i915]
<4>
[    9.733227]  [<ffffffffa02d58ad>] ironlake_crtc_disable+0x16d/0x7c0 [i915]
<4>
[    9.733270]  [<ffffffffa02c82ac>] ? intel_dump_pipe_config.isra.50+0x3c/0x350 [i915]
<4>
[    9.733313]  [<ffffffffa02d08f0>] __intel_set_mode+0x7a0/0xac0 [i915]
<4>
[    9.733357]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
<4>
[    9.733401]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
<4>
[    9.733425]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
<4>
[    9.733433]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
<4>
[    9.733439]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
<4>
[    9.733446]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
<4>
[    9.733527]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
<4>
[    9.733534]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
<4>
[    9.733540]  [<ffffffff814aee58>] visual_init+0xb8/0x120
<4>
[    9.733545]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
<4>
[    9.733549]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
<4>
[    9.733553]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
<4>
[    9.733557]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
<4>
[    9.733563]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
<4>
[    9.733567]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
<4>
[    9.733571]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
<4>
[    9.733575]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
<4>
[    9.733581]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
<4>
[    9.733591]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
<4>
[    9.733642]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
<4>
[    9.733695]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>
[    9.733746]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
<4>
[    9.733751]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.733756]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.733759]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.733765]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.733767]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.733787]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.733803]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.733820]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.733850]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.733855]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.733858]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.733862]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.733865]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.733868]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.733871]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.733874]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.733876]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.733879]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.733882]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.733885]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.733902]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.733906]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
<4>
[    9.733935]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
<4>
[    9.733939]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.733944]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.733948]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.733954]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.733957]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.733961]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
<4>
[    9.733965]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.733971]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.733973] ---[ end trace 2d05078fac923b9a ]---
<4>
[    9.755997] ------------[ cut here ]------------
<4>
[    9.756044] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
<4>
[    9.756068] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
<4>
[    9.756072] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
<4>
[    9.756073] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.756076]  0000000000000009 ffff880076b0f368 ffffffff8182b6d0 0000000000000000
<4>
[    9.756079]  ffff880076b0f3a0 ffffffff8106d0dd ffff880074f30000 0000000000000001
<4>
[    9.756081]  0000000000000001 ffff880074f30000 0000000000000000 ffff880076b0f3b0
<4>
[    9.756082] Call Trace:
<4>
[    9.756087]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.756092]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.756096]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.756139]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
<4>
[    9.756181]  [<ffffffffa02acada>] intel_set_pch_fifo_underrun_reporting+0x19a/0x1b0 [i915]
<4>
[    9.756225]  [<ffffffffa02d5c97>] ironlake_crtc_disable+0x557/0x7c0 [i915]
<4>
[    9.756269]  [<ffffffffa02d08f0>] __intel_set_mode+0x7a0/0xac0 [i915]
<4>
[    9.756313]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
<4>
[    9.756356]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
<4>
[    9.756377]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
<4>
[    9.756384]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
<4>
[    9.756390]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
<4>
[    9.756397]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
<4>
[    9.756440]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
<4>
[    9.756443]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
<4>
[    9.756446]  [<ffffffff814aee58>] visual_init+0xb8/0x120
<4>
[    9.756450]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
<4>
[    9.756453]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
<4>
[    9.756456]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
<4>
[    9.756459]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
<4>
[    9.756462]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
<4>
[    9.756465]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
<4>
[    9.756469]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
<4>
[    9.756472]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
<4>
[    9.756475]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
<4>
[    9.756483]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
<4>
[    9.756524]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
<4>
[    9.756567]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>
[    9.756614]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
<4>
[    9.756618]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.756622]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.756625]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.756628]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.756630]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.756650]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.756665]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.756682]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.756713]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.756716]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.756720]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.756723]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.756727]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.756730]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.756732]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.756735]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.756738]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.756740]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.756743]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.756747]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.756763]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.756767]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
<4>
[    9.756796]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
<4>
[    9.756799]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.756801]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.756805]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.756809]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.756812]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.756817]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
<4>
[    9.756821]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.756825]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.756827] ---[ end trace 2d05078fac923b9b ]---
<4>
[    9.757321] ------------[ cut here ]------------
<4>
[    9.757362] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:139 ironlake_enable_display_irq+0x73/0x80 [i915]()
<4>
[    9.757384] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
<4>
[    9.757387] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
<4>
[    9.757388] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.757391]  0000000000000009 ffff880076b0f388 ffffffff8182b6d0 0000000000000000
<4>
[    9.757394]  ffff880076b0f3c0 ffffffff8106d0dd ffff880074f30000 0000000000000001
<4>
[    9.757396]  0000000000000000 0000000000000000 ffff880074dee800 ffff880076b0f3d0
<4>
[    9.757397] Call Trace:
<4>
[    9.757401]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.757405]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.757408]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.757447]  [<ffffffffa02a88b3>] ironlake_enable_display_irq+0x73/0x80 [i915]
<4>
[    9.757487]  [<ffffffffa02ac665>] intel_set_cpu_fifo_underrun_reporting+0x2b5/0x340 [i915]
<4>
[    9.757531]  [<ffffffffa02d3fe5>] ironlake_crtc_enable+0x1b5/0x7a0 [i915]
<4>
[    9.757583]  [<ffffffffa02d0982>] __intel_set_mode+0x832/0xac0 [i915]
<4>
[    9.757628]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
<4>
[    9.757672]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
<4>
[    9.757692]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
<4>
[    9.757698]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
<4>
[    9.757705]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
<4>
[    9.757711]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
<4>
[    9.757754]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
<4>
[    9.757758]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
<4>
[    9.757761]  [<ffffffff814aee58>] visual_init+0xb8/0x120
<4>
[    9.757764]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
<4>
[    9.757768]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
<4>
[    9.757770]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
<4>
[    9.757773]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
<4>
[    9.757777]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
<4>
[    9.757780]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
<4>
[    9.757783]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
<4>
[    9.757786]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
<4>
[    9.757790]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
<4>
[    9.757797]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
<4>
[    9.757838]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
<4>
[    9.757881]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>
[    9.757928]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
<4>
[    9.757932]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.757936]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.757939]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.757942]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.757944]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.757964]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.757980]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.757996]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.758027]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.758030]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.758034]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.758037]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.758041]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.758044]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.758047]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.758049]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.758052]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.758055]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.758058]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.758061]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.758078]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.758081]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
<4>
[    9.758110]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
<4>
[    9.758113]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.758116]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.758119]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.758123]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.758126]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.758131]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
<4>
[    9.758134]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.758139]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.758141] ---[ end trace 2d05078fac923b9c ]---
<4>
[    9.758152] ------------[ cut here ]------------
<4>
[    9.758193] WARNING: CPU: 0 PID: 271 at drivers/gpu/drm/i915/i915_irq.c:423 ibx_display_interrupt_update+0x90/0xa0 [i915]()
<4>
[    9.758214] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic mxm_wmi i915(+) snd_hda_intel snd_hda_controller video parport_pc thinkpad_acpi snd_hda_codec sdhci_pci rfkill snd_hwdep parport drm_kms_helper uvcvideo sdhci videobuf2_vmalloc videobuf2_memops mmc_core videobuf2_core firewire_ohci pcspkr snd_pcm v4l2_common ahci firewire_core libahci videodev intel_ips i2c_i801 snd_timer drm crc_itu_t snd libata wmi soundcore acpi_cpufreq
<4>
[    9.758217] CPU: 0 PID: 271 Comm: modprobe Tainted: G        W     3.16.0-rc4-00052-gc2b6ef4 #1
<4>
[    9.758218] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>
[    9.758221]  0000000000000009 ffff880076b0f378 ffffffff8182b6d0 0000000000000000
<4>
[    9.758224]  ffff880076b0f3b0 ffffffff8106d0dd ffff880074f30000 0000000000000001
<4>
[    9.758226]  0000000000000001 ffff880074f30000 0000000000000000 ffff880076b0f3c0
<4>
[    9.758227] Call Trace:
<4>
[    9.758231]  [<ffffffff8182b6d0>] dump_stack+0x4d/0x66
<4>
[    9.758235]  [<ffffffff8106d0dd>] warn_slowpath_common+0x7d/0xa0
<4>
[    9.758238]  [<ffffffff8106d1ba>] warn_slowpath_null+0x1a/0x20
<4>
[    9.758277]  [<ffffffffa02a8950>] ibx_display_interrupt_update+0x90/0xa0 [i915]
<4>
[    9.758317]  [<ffffffffa02acada>] intel_set_pch_fifo_underrun_reporting+0x19a/0x1b0 [i915]
<4>
[    9.758361]  [<ffffffffa02d3ff5>] ironlake_crtc_enable+0x1c5/0x7a0 [i915]
<4>
[    9.758404]  [<ffffffffa02d0982>] __intel_set_mode+0x832/0xac0 [i915]
<4>
[    9.758449]  [<ffffffffa02d8356>] intel_set_mode+0x16/0x30 [i915]
<4>
[    9.758492]  [<ffffffffa02d926d>] intel_crtc_set_config+0x8ed/0xe10 [i915]
<4>
[    9.758512]  [<ffffffffa009e174>] drm_mode_set_config_internal+0x64/0xf0 [drm]
<4>
[    9.758518]  [<ffffffffa01e7b73>] restore_fbdev_mode+0xb3/0xe0 [drm_kms_helper]
<4>
[    9.758525]  [<ffffffffa01e7bc3>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
<4>
[    9.758531]  [<ffffffffa01e97a8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
<4>
[    9.758574]  [<ffffffffa02e2aba>] intel_fbdev_set_par+0x1a/0x60 [i915]
<4>
[    9.758577]  [<ffffffff81437ab4>] fbcon_init+0x4f4/0x580
<4>
[    9.758581]  [<ffffffff814aee58>] visual_init+0xb8/0x120
<4>
[    9.758584]  [<ffffffff814b1353>] do_bind_con_driver+0x163/0x330
<4>
[    9.758587]  [<ffffffff814b1ad4>] do_take_over_console+0x114/0x1c0
<4>
[    9.758590]  [<ffffffff81433203>] do_fbcon_takeover+0x63/0xd0
<4>
[    9.758593]  [<ffffffff8143855d>] fbcon_event_notify+0x68d/0x7e0
<4>
[    9.758596]  [<ffffffff810951bc>] notifier_call_chain+0x4c/0x70
<4>
[    9.758600]  [<ffffffff8109552d>] __blocking_notifier_call_chain+0x4d/0x70
<4>
[    9.758603]  [<ffffffff81095566>] blocking_notifier_call_chain+0x16/0x20
<4>
[    9.758606]  [<ffffffff8143ea9b>] fb_notifier_call_chain+0x1b/0x20
<4>
[    9.758609]  [<ffffffff81440cc6>] register_framebuffer+0x1e6/0x320
<4>
[    9.758617]  [<ffffffffa01e9aee>] drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
<4>
[    9.758658]  [<ffffffffa02bb6cf>] ? gen5_write32+0x5f/0xd0 [i915]
<4>
[    9.758701]  [<ffffffffa02e3c3f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>
[    9.758747]  [<ffffffffa0306c25>] i915_driver_load+0xf45/0xfe0 [i915]
<4>
[    9.758752]  [<ffffffff813de338>] ? kobject_uevent_env+0x178/0x690
<4>
[    9.758755]  [<ffffffff814df1e7>] ? get_device+0x17/0x30
<4>
[    9.758758]  [<ffffffff814e4875>] ? klist_class_dev_get+0x15/0x20
<4>
[    9.758762]  [<ffffffff8181943a>] ? klist_add_tail+0x3a/0x40
<4>
[    9.758764]  [<ffffffff814e0919>] ? device_add+0x1f9/0x610
<4>
[    9.758783]  [<ffffffffa009c176>] ? drm_sysfs_device_add+0xd6/0x120 [drm]
<4>
[    9.758799]  [<ffffffffa009878d>] drm_dev_register+0xad/0x100 [drm]
<4>
[    9.758816]  [<ffffffffa009b26f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
<4>
[    9.758846]  [<ffffffffa027856b>] i915_pci_probe+0x3b/0x60 [i915]
<4>
[    9.758850]  [<ffffffff81412c25>] local_pci_probe+0x45/0xa0
<4>
[    9.758853]  [<ffffffff81413db5>] ? pci_match_device+0xe5/0x110
<4>
[    9.758857]  [<ffffffff81413ef1>] pci_device_probe+0xd1/0x130
<4>
[    9.758860]  [<ffffffff814e39b0>] driver_probe_device+0x90/0x3c0
<4>
[    9.758863]  [<ffffffff814e3db3>] __driver_attach+0x93/0xa0
<4>
[    9.758866]  [<ffffffff814e3d20>] ? __device_attach+0x40/0x40
<4>
[    9.758868]  [<ffffffff814e1a33>] bus_for_each_dev+0x63/0xa0
<4>
[    9.758871]  [<ffffffff814e344e>] driver_attach+0x1e/0x20
<4>
[    9.758873]  [<ffffffff814e3060>] bus_add_driver+0x180/0x250
<4>
[    9.758876]  [<ffffffff814e4584>] driver_register+0x64/0xf0
<4>
[    9.758880]  [<ffffffff814125bc>] __pci_register_driver+0x4c/0x50
<4>
[    9.758897]  [<ffffffffa009b4da>] drm_pci_init+0x10a/0x140 [drm]
<4>
[    9.758900]  [<ffffffffa035d000>] ? 0xffffffffa035cfff
<4>
[    9.758928]  [<ffffffffa035d089>] i915_init+0x89/0x90 [i915]
<4>
[    9.758931]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
<4>
[    9.758934]  [<ffffffff811a9c35>] ? kfree+0x125/0x160
<4>
[    9.758937]  [<ffffffff8118fea2>] ? __vunmap+0xb2/0x100
<4>
[    9.758942]  [<ffffffff810ec9bc>] load_module+0x15fc/0x1a30
<4>
[    9.758945]  [<ffffffff810e8550>] ? store_uevent+0x40/0x40
<4>
[    9.758949]  [<ffffffff8119025c>] ? __vmalloc_node_range+0xbc/0x270
<4>
[    9.758953]  [<ffffffff810eceb1>] SyS_init_module+0xc1/0x110
<4>
[    9.758957]  [<ffffffff81834529>] system_call_fastpath+0x16/0x1b
<4>
[    9.758959] ---[ end trace 2d05078fac923b9d ]---
<6>
[    9.933057] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<7>
[    9.940772] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>
[    9.945837] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>
[    9.947577] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
<7>
[    9.960195] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>
[    9.965151] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>
[    9.966897] ata2.00: configured for UDMA/100
<6>
[    9.969176] Console: switching to colour frame buffer device 160x50
<5>
[    9.982920] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
<6>
[   10.313334] ata5: SATA link down (SStatus 0 SControl 300)
<6>
[   10.620518] ata6: SATA link down (SStatus 0 SControl 300)
<6>
[   10.742591] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
<4>
[   10.756247] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
<6>
[   10.756249] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>
[   10.756585] sr 1:0:0:0: Attached scsi CD-ROM sr0
<5>
[   10.770856] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
<5>
[   10.770992] sd 0:0:0:0: [sda] Write Protect is off
<7>
[   10.770996] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>
[   10.771046] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<5>
[   10.789232] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>
[   10.789448] sr 1:0:0:0: Attached scsi generic sg1 type 5
<6>
[   11.195006]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
<5>
[   11.196067] sd 0:0:0:0: [sda] Attached SCSI disk
<5>
[   11.352084] random: nonblocking pool is initialized
<6>
[   11.570882] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>
[   11.575340] i915 0000:00:02.0: registered panic notifier
<6>
[   11.602349] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
<6>
[   11.611760] acpi device:01: registered as cooling_device4
<6>
[   11.615521] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input17
<6>
[   11.621727] [drm] Initialized i915 1.6.0 20140620 for 0000:00:02.0 on minor 0
<6>
[   12.459610] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
<6>
[   12.718911] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
<6>
[   12.734920] fuse init (API version 7.23)
<6>
[   13.290075] device-mapper: uevent: version 1.0.3
<6>
[   13.297497] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
<6>
[   14.262785] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<6>
[   23.221655] ipmi message handler version 39.2
<6>
[   23.231738] IPMI Watchdog: driver initialized

--huq684BweRXVnRxX--
