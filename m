Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaJKFUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 01:20:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:4333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaJKFUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 01:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,696,1406617200"; 
   d="scan'208";a="603752586"
Date: Sat, 11 Oct 2014 13:20:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [drm/crtc] WARNING: CPU: 2 PID: 254 at
 drivers/gpu/drm/drm_crtc_helper.c:131
 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
Message-ID: <20141011052037.GD21803@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Daniel,

FYI, we noticed the below changes on

commit 62ff94a5492175759546f8bc61383189d6b49122 ("drm/crtc-helper: remove LOCKING from kerneldoc")

testbox/testcase/testparams: snb-drag/piglit/igt-007

9fd93784f1719532  62ff94a5492175759546f8bc61  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :1          100%           5:5     kmsg.WARNING:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_probe_single_connector_modes_drm_kms_helper()
           :1          100%           5:5     dmesg.WARNING:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_probe_single_connector_modes_drm_kms_helper()
          1:5          -20%            :5     kmsg.Spurious_LAPIC_timer_interrupt_on_cpu

[   76.535023] [drm] This can cause pipe underruns and display issues.
[   76.541349] [drm] Please upgrade your BIOS to fix this.
[   76.546656] ------------[ cut here ]------------
[   76.551339] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
[   76.566126] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   76.591030] CPU: 2 PID: 254 Comm: modprobe Not tainted 3.14.0-g9a952a0 #1
[   76.597879] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   76.607100]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
[   76.614804]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000001 ffff8801bd312400
[   76.622520]  ffff880099d99800 ffff8801bd46ce28 ffffffffa0247a00 ffff8801bd4c5860
[   76.630237] Call Trace:
[   76.632755]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   76.637955]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   76.644016]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   76.649912]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
[   76.659293]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   76.668765]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   76.677208]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   76.683364]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   76.689606]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   76.695853]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   76.703060]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   76.709568]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   76.715894]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   76.722139]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   76.728289]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   76.733917]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   76.739807]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   76.745610]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   76.751680]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   76.757316]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   76.761145] ata5: SATA link down (SStatus 0 SControl 310)
[   76.768581]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   76.774297]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   76.779753]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   76.785467]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   76.790663]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   76.796292]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   76.801489]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   76.807638]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   76.813707]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   76.818908]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   76.824626]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   76.830341]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   76.835971]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   76.841597]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   76.847140]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   76.852855]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   76.858915] ---[ end trace decc4f53056ad5c3 ]---
[   76.897652] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193



Thanks,
Fengguang

--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-g9a952a0 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 8 05:42:29 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-9a952a0d42ff089945ea3f5b3f690e45218d073f-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/vmlinuz-3.14.0-g9a952a0 kconfig=x86_64-rhel commit=9a952a0d42ff089945ea3f5b3f690e45218d073f branch=linus/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000bac1dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bac1e000-0x00000000bac76fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bac77000-0x00000000bada9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000badaa000-0x00000000badbafff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000badbb000-0x00000000badcefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000badcf000-0x00000000badd0fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000badd1000-0x00000000badd1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000badd2000-0x00000000badd9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000badda000-0x00000000bade3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bade4000-0x00000000bae3dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bae3e000-0x00000000bae80fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bae81000-0x00000000baffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb800000-0x00000000bf9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001bfdfffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1bfe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 0BB800000 mask FFF800000 uncachable
[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 1BFE00000 mask FFFE00000 uncachable
[    0.000000]   5 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xbb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcdd0-0x000fcddf] mapped at [ffff8800000fcdd0]
[    0.000000]   mpc: fcaa0-fcd54
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x1bf180000, 0x1bf180fff] PGTABLE
[    0.000000] BRK [0x1bf181000, 0x1bf181fff] PGTABLE
[    0.000000] BRK [0x1bf182000, 0x1bf182fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1bfc00000-0x1bfdfffff]
[    0.000000]  [mem 0x1bfc00000-0x1bfdfffff] page 2M
[    0.000000] BRK [0x1bf183000, 0x1bf183fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1bc000000-0x1bfbfffff]
[    0.000000]  [mem 0x1bc000000-0x1bfbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x180000000-0x1bbffffff]
[    0.000000]  [mem 0x180000000-0x1bbffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xbac1dfff]
[    0.000000]  [mem 0x40200000-0xbabfffff] page 2M
[    0.000000]  [mem 0xbac00000-0xbac1dfff] page 4k
[    0.000000] BRK [0x1bf184000, 0x1bf184fff] PGTABLE
[    0.000000] BRK [0x1bf185000, 0x1bf185fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbadcf000-0xbadd0fff]
[    0.000000]  [mem 0xbadcf000-0xbadd0fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbae81000-0xbaffffff]
[    0.000000]  [mem 0xbae81000-0xbaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
[    0.000000] RAMDISK: [mem 0x1ade4f000-0x1bdffffff]
[    0.000000] ACPI: RSDP 00000000000f0420 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bac69068 00004C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000bac72fa0 0000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000bac69140 009E5F (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000baddbf80 000040
[    0.000000] ACPI: APIC 00000000bac73098 000072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000bac73110 000102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bac73218 00003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bac73258 000038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001bfdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1bfdfffff]
[    0.000000]   NODE_DATA [mem 0x1bfdd5000-0x1bfdfbfff]
[    0.000000]  [ffffea0000000000-ffffea0006ffffff] PMD -> [ffff8801a7e00000-ffff8801addfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1bfdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xbac1dfff]
[    0.000000]   node   0: [mem 0xbadcf000-0xbadd0fff]
[    0.000000]   node   0: [mem 0xbae81000-0xbaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x1bfdfffff]
[    0.000000] On node 0 totalpages: 1550140
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 157 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11879 pages used for memmap
[    0.000000]   DMA32 zone: 760223 pages, LIFO batch:31
[    0.000000]   Normal zone: 12280 pages used for memmap
[    0.000000]   Normal zone: 785920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbac1e000-0xbac76fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbac77000-0xbada9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbadaa000-0xbadbafff]
[    0.000000] PM: Registered nosave memory: [mem 0xbadbb000-0xbadcefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbadd1000-0xbadd1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbadd2000-0xbadd9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbadda000-0xbade3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbade4000-0xbae3dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbae3e000-0xbae80fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb000000-0xbb7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb800000-0xbf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfa00000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xbfa00000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8801bfa00000 s88896 r8192 d21696 u524288
[    0.000000] pcpu-alloc: s88896 r8192 d21696 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1525760
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-9a952a0d42ff089945ea3f5b3f690e45218d073f-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/vmlinuz-3.14.0-g9a952a0 kconfig=x86_64-rhel commit=9a952a0d42ff089945ea3f5b3f690e45218d073f branch=linus/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 5752864K/6200560K available (8525K kernel code, 1631K rwdata, 3720K rodata, 1788K init, 2196K bss, 447696K reserved)
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
[    0.000000] allocated 25165824 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3311.505 MHz processor
[    0.000025] Calibrating delay loop (skipped), value calculated using timer frequency.. 6623.01 BogoMIPS (lpj=3311505)
[    0.010729] pid_max: default: 32768 minimum: 301
[    0.015393] ACPI: Core revision 20131218
[    0.021673] ACPI: All ACPI Tables successfully acquired
[    0.027079] Security Framework initialized
[    0.031222] SELinux:  Initializing.
[    0.034753] SELinux:  Starting in permissive mode
[    0.039914] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.048611] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.056368] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.063311] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.070863] Initializing cgroup subsys memory
[    0.075289] Initializing cgroup subsys devices
[    0.079797] Initializing cgroup subsys freezer
[    0.084309] Initializing cgroup subsys net_cls
[    0.088820] Initializing cgroup subsys blkio
[    0.093158] Initializing cgroup subsys perf_event
[    0.097929] Initializing cgroup subsys hugetlb
[    0.102460] CPU: Physical Processor ID: 0
[    0.106536] CPU: Processor Core ID: 0
[    0.110263] mce: CPU supports 9 MCE banks
[    0.114346] CPU0: Thermal LVT vector (0xfa) already installed
[    0.120163] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.120163] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.120163] tlb_flushall_shift: 6
[    0.135361] Freeing SMP alternatives memory: 36K (ffffffff81f50000 - ffffffff81f59000)
[    0.144441] ftrace: allocating 30377 entries in 119 pages
[    0.161064] Getting VERSION: 1060015
[    0.164712] Getting VERSION: 1060015
[    0.168356] Getting ID: 0
[    0.171041] Getting ID: 0
[    0.173729] enabled ExtINT on CPU#0
[    0.177508] ENABLING IO-APIC IRQs
[    0.180886] init IO_APIC IRQs
[    0.183917]  apic 0 pin 0 not connected
[    0.187817] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.195818] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.203820] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.211815] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.219817] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.227816] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.235810] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.243812] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.251813] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.259813] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.267979] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.276155] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.284329] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.292502] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.300668] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.308834]  apic 0 pin 16 not connected
[    0.312817]  apic 0 pin 17 not connected
[    0.316799]  apic 0 pin 18 not connected
[    0.320782]  apic 0 pin 19 not connected
[    0.324766]  apic 0 pin 20 not connected
[    0.328749]  apic 0 pin 21 not connected
[    0.332732]  apic 0 pin 22 not connected
[    0.336716]  apic 0 pin 23 not connected
[    0.340831] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.356883] smpboot: CPU0: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz (fam: 06, model: 2a, stepping: 07)
[    0.366429] TSC deadline timer enabled
[    0.371916] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.382707] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.390786] ... version:                3
[    0.394856] ... bit width:              48
[    0.399011] ... generic registers:      8
[    0.403083] ... value mask:             0000ffffffffffff
[    0.408451] ... max period:             0000ffffffffffff
[    0.413820] ... fixed-purpose events:   3
[    0.417890] ... event mask:             00000007000000ff
[    0.424396] x86: Booting SMP configuration:
[    0.428637] .... node  #0, CPUs:      #1
[    0.443523] masked ExtINT on CPU#1
[    0.447135] CPU1: Thermal LVT vector (0xfa) already installed
[    0.454991] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.463138]  #2
[    0.475854] masked ExtINT on CPU#2
[    0.479460] CPU2: Thermal LVT vector (0xfa) already installed
[    0.487346]  #3
[    0.500167] masked ExtINT on CPU#3
[    0.503776] CPU3: Thermal LVT vector (0xfa) already installed
[    0.511599] x86: Booted up 1 node, 4 CPUs
[    0.515672] smpboot: Total of 4 processors activated (26492.04 BogoMIPS)
[    0.524854] devtmpfs: initialized
[    0.530022] EVM: security.selinux
[    0.533398] EVM: security.ima
[    0.536429] EVM: security.capability
[    0.540164] PM: Registering ACPI NVS region [mem 0xbac1e000-0xbac76fff] (364544 bytes)
[    0.548167] PM: Registering ACPI NVS region [mem 0xbadaa000-0xbadbafff] (69632 bytes)
[    0.556077] PM: Registering ACPI NVS region [mem 0xbadda000-0xbade3fff] (40960 bytes)
[    0.563985] PM: Registering ACPI NVS region [mem 0xbae3e000-0xbae80fff] (274432 bytes)
[    0.572610] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.579575] NET: Registered protocol family 16
[    0.584222] cpuidle: using governor menu
[    0.588292] ACPI: bus type PCI registered
[    0.592359] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.598897] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.608286] PCI: not using MMCONFIG
[    0.611835] PCI: Using configuration type 1 for base access
[    0.618505] bio: create slab <bio-0> at 0
[    0.622635] ACPI: Added _OSI(Module Device)
[    0.626877] ACPI: Added _OSI(Processor Device)
[    0.631379] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.636141] ACPI: Added _OSI(Processor Aggregator Device)
[    0.643582] ACPI: Executed 1 blocks of module-level executable AML code
[    0.651901] ACPI: SSDT 00000000baddac18 00038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.660695] ACPI: Dynamic OEM Table Load:
[    0.664872] ACPI: SSDT           (null) 00038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.673425] ACPI: SSDT 00000000baddbe18 000084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.682180] ACPI: Dynamic OEM Table Load:
[    0.686357] ACPI: SSDT           (null) 000084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.695226] ACPI: Interpreter enabled
[    0.698954] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    0.708369] ACPI: (supports S0 S1 S3 S4 S5)
[    0.712613] ACPI: Using IOAPIC for interrupt routing
[    0.717649] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.727070] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.740942] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.750247] ACPI: No dock devices found.
[    0.754408] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.765191] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.771430] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.779780] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug]
[    0.786794] acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
[    0.793928] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cd7ff])
[    0.806516] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.817231] PCI host bridge to bus 0000:00
[    0.821386] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.826927] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.833160] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.839395] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.846323] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xffffffff]
[    0.853256] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.859383] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.865468] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.871642] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.877387] pci 0000:00:02.0: [8086:0112] type 00 class 0x030000
[    0.883452] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit]
[    0.890301] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.897606] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.903309] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.909392] pci 0000:00:16.0: reg 0x10: [mem 0xfe607000-0xfe60700f 64bit]
[    0.916309] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.922519] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.928598] pci 0000:00:1a.0: reg 0x10: [mem 0xfe606000-0xfe6063ff]
[    0.935009] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.941192] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.946943] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.953019] pci 0000:00:1b.0: reg 0x10: [mem 0xfe600000-0xfe603fff 64bit]
[    0.959935] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.966136] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.972272] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.978455] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.984202] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.990343] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.996528] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    1.002273] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    1.008417] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.014600] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    1.020344] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    1.026948] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.033129] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    1.038875] pci 0000:00:1c.7: [8086:244e] type 01 class 0x060401
[    1.045011] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.051192] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    1.056942] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    1.063026] pci 0000:00:1d.0: reg 0x10: [mem 0xfe605000-0xfe6053ff]
[    1.069429] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.075611] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.081360] pci 0000:00:1f.0: [8086:1c4a] type 00 class 0x060100
[    1.087572] pci 0000:00:1f.2: [8086:1c00] type 00 class 0x01018f
[    1.093648] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
[    1.099288] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
[    1.104924] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
[    1.110561] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
[    1.116201] pci 0000:00:1f.2: reg 0x20: [io  0xf0d0-0xf0df]
[    1.121838] pci 0000:00:1f.2: reg 0x24: [io  0xf0c0-0xf0cf]
[    1.127541] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    1.133621] pci 0000:00:1f.3: reg 0x10: [mem 0xfe604000-0xfe6040ff 64bit]
[    1.140485] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.146171] pci 0000:00:1f.5: [8086:1c08] type 00 class 0x010185
[    1.152247] pci 0000:00:1f.5: reg 0x10: [io  0xf0b0-0xf0b7]
[    1.157887] pci 0000:00:1f.5: reg 0x14: [io  0xf0a0-0xf0a3]
[    1.163524] pci 0000:00:1f.5: reg 0x18: [io  0xf090-0xf097]
[    1.169161] pci 0000:00:1f.5: reg 0x1c: [io  0xf080-0xf083]
[    1.174798] pci 0000:00:1f.5: reg 0x20: [io  0xf070-0xf07f]
[    1.180435] pci 0000:00:1f.5: reg 0x24: [io  0xf060-0xf06f]
[    1.186160] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.191235] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.196342] pci 0000:03:00.0: [1106:0415] type 00 class 0x010185
[    1.202427] pci 0000:03:00.0: reg 0x10: [io  0xe040-0xe047]
[    1.208066] pci 0000:03:00.0: reg 0x14: [io  0xe030-0xe033]
[    1.213712] pci 0000:03:00.0: reg 0x18: [io  0xe020-0xe027]
[    1.219356] pci 0000:03:00.0: reg 0x1c: [io  0xe010-0xe013]
[    1.224996] pci 0000:03:00.0: reg 0x20: [io  0xe000-0xe00f]
[    1.230655] pci 0000:03:00.0: reg 0x30: [mem 0xfe500000-0xfe50ffff pref]
[    1.237484] pci 0000:03:00.0: supports D1 D2
[    1.241817] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    1.249633] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.254661] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    1.260818] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
[    1.267742] pci 0000:04:00.0: [1b21:1042] type 00 class 0x0c0330
[    1.273830] pci 0000:04:00.0: reg 0x10: [mem 0xfe400000-0xfe407fff 64bit]
[    1.280825] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    1.288727] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    1.293751] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
[    1.300670] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
[    1.306754] pci 0000:05:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    1.312415] pci 0000:05:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    1.319737] pci 0000:05:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    1.327148] pci 0000:05:00.0: supports D1 D2
[    1.331476] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.340157] pci 0000:00:1c.6: PCI bridge to [bus 05]
[    1.345187] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    1.351348] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.359237] pci 0000:06:00.0: [1b21:1080] type 01 class 0x060401
[    1.365416] pci 0000:06:00.0: System wakeup disabled by ACPI
[    1.371157] pci 0000:00:1c.7: PCI bridge to [bus 06-07] (subtractive decode)
[    1.378272] pci 0000:00:1c.7:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.386265] pci 0000:00:1c.7:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.394258] pci 0000:00:1c.7:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.402951] pci 0000:00:1c.7:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
[    1.411748] pci 0000:06:00.0: PCI bridge to [bus 07] (subtractive decode)
[    1.418610] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    1.427215] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    1.435814] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    1.444413] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    1.453020] pci 0000:06:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.461013] pci 0000:06:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.469005] pci 0000:06:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.477690] pci 0000:06:00.0:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
[    1.486646] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.495436] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.504226] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    1.512807] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
[    1.521390] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
[    1.530177] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.538966] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
[    1.547748] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
[    1.556538] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.561550] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.569725] vgaarb: loaded
[    1.572493] vgaarb: bridge control possible 0000:00:02.0
[    1.577905] SCSI subsystem initialized
[    1.581732] ACPI: bus type USB registered
[    1.585813] usbcore: registered new interface driver usbfs
[    1.591360] usbcore: registered new interface driver hub
[    1.596746] usbcore: registered new device driver usb
[    1.601869] pps_core: LinuxPPS API ver. 1 registered
[    1.606890] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.616104] PTP clock support registered
[    1.620116] PCI: Using ACPI for IRQ routing
[    1.625718] PCI: pci_cache_line_size set to 64 bytes
[    1.630786] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    1.636850] e820: reserve RAM buffer [mem 0xbac1e000-0xbbffffff]
[    1.642911] e820: reserve RAM buffer [mem 0xbadd1000-0xbbffffff]
[    1.648975] e820: reserve RAM buffer [mem 0xbb000000-0xbbffffff]
[    1.655035] e820: reserve RAM buffer [mem 0x1bfe00000-0x1bfffffff]
[    1.661334] NetLabel: Initializing
[    1.664795] NetLabel:  domain hash size = 128
[    1.669211] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.674244] NetLabel:  unlabeled traffic allowed by default
[    1.679957] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.686658] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.694561] Switched to clocksource hpet
[    1.705053] pnp: PnP ACPI init
[    1.708183] ACPI: bus type PNP registered
[    1.712360] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    1.719032] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
[    1.725707] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.732383] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.739060] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
[    1.745737] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.752643] system 00:01: [io  0x0290-0x029f] has been reserved
[    1.758623] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.765654] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:15)
[    1.773745] pnp 00:02: [dma 0 disabled]
[    1.777710] pnp 00:02: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.784304] pnp 00:03: [dma 4]
[    1.787434] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.794028] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.802123] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.808720] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.815340] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    1.821317] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.828172] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    1.836440] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.843155] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    1.851246] pnp 00:08: [dma 0 disabled]
[    1.855180] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.861888] system 00:09: [io  0x0400-0x0453] could not be reserved
[    1.868216] system 00:09: [io  0x0458-0x047f] has been reserved
[    1.874199] system 00:09: [io  0x0500-0x057f] has been reserved
[    1.880185] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.886860] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.893883] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
[    1.900558] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    1.907236] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.914122] system 00:0a: [io  0x0454-0x0457] has been reserved
[    1.920104] system 00:0a: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.927784] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.934468] pnp: PnP ACPI: found 12 devices
[    1.938712] ACPI: bus type PNP unregistered
[    1.948845] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.953877] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.958914] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.963937] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    1.970099] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
[    1.976949] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    1.981977] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
[    1.989297] pci 0000:00:1c.6: PCI bridge to [bus 05]
[    1.994324] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    2.000486] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    2.008310] pci 0000:06:00.0: PCI bridge to [bus 07]
[    2.013355] pci 0000:00:1c.7: PCI bridge to [bus 06-07]
[    2.018648] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.024287] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.029921] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.036253] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xffffffff]
[    2.042582] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    2.048218] pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
[    2.054550] pci_bus 0000:04: resource 1 [mem 0xfe400000-0xfe4fffff]
[    2.060878] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    2.066507] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    2.073807] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    2.079437] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    2.085074] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    2.091402] pci_bus 0000:06: resource 7 [mem 0xbfa00000-0xffffffff]
[    2.097726] pci_bus 0000:07: resource 8 [io  0x0000-0x0cf7]
[    2.103362] pci_bus 0000:07: resource 9 [io  0x0d00-0xffff]
[    2.108999] pci_bus 0000:07: resource 10 [mem 0x000a0000-0x000bffff]
[    2.115416] pci_bus 0000:07: resource 11 [mem 0xbfa00000-0xffffffff]
[    2.121854] NET: Registered protocol family 2
[    2.126394] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    2.133815] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.140705] TCP: Hash tables configured (established 65536 bind 65536)
[    2.147308] TCP: reno registered
[    2.150608] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.156789] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.163422] NET: Registered protocol family 1
[    2.167892] RPC: Registered named UNIX socket transport module.
[    2.173877] RPC: Registered udp transport module.
[    2.178638] RPC: Registered tcp transport module.
[    2.183401] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.189909] pci 0000:00:02.0: Boot video device
[    2.194570] IOAPIC[0]: Set routing entry (0-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    2.203014] IOAPIC[0]: Set routing entry (0-16 -> 0x51 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    2.211299] IOAPIC[0]: Set routing entry (0-17 -> 0x61 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    2.219597] PCI: CLS 64 bytes, default 64
[    2.223708] Unpacking initramfs...
[    5.255419] Freeing initrd memory: 263876K (ffff8801ade4f000 - ffff8801be000000)
[    5.262902] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.269404] software IO TLB [mem 0xb6c1e000-0xbac1e000] (64MB) mapped at [ffff8800b6c1e000-ffff8800bac1dfff]
[    5.279543] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    5.290528] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    5.296778] Initialise system trusted keyring
[    5.301226] audit: initializing netlink subsys (disabled)
[    5.306701] audit: type=2000 audit(1412747277.028:1): initialized
[    5.332333] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.339835] zbud: loaded
[    5.342546] VFS: Disk quotas dquot_6.5.2
[    5.346564] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.353449] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    5.362464] 9p: Installing v9fs 9p2000 file system support
[    5.368030] msgmni has been set to 11751
[    5.372057] Key type big_key registered
[    5.375955] SELinux:  Registering netfilter hooks
[    5.381150] NET: Registered protocol family 38
[    5.385657] Key type asymmetric registered
[    5.389819] Asymmetric key parser 'x509' registered
[    5.394779] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    5.402277] io scheduler noop registered
[    5.406264] io scheduler deadline registered (default)
[    5.411463] io scheduler cfq registered
[    5.415508] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    5.420885] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    5.426280] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    5.431639] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
[    5.437016] IOAPIC[0]: Set routing entry (0-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    5.445295] pcieport 0000:00:1c.6: irq 44 for MSI/MSI-X
[    5.450654] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    5.457677] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    5.464451] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    5.471471] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    5.478245] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    5.485264] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    5.491856] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    5.498630] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    5.505648] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    5.512239] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    5.519014] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
[    5.526034] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    5.532623] pcie_pme 0000:00:1c.6:pcie01: service driver pcie_pme loaded
[    5.539396] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.545041] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.551739] intel_idle: MWAIT substates: 0x1120
[    5.556335] intel_idle: v0.4 model 0x2A
[    5.560237] intel_idle: lapic_timer_reliable_states 0xffffffff
[    5.566269] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    5.574538] ACPI: Power Button [PWRB]
[    5.578333] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.585829] ACPI: Power Button [PWRF]
[    5.590238] GHES: HEST is not enabled!
[    5.594249] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.621149] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    5.629417] Non-volatile memory driver v1.3
[    5.633676] Linux agpgart interface v0.103
[    5.637971] IOAPIC[0]: Set routing entry (0-21 -> 0xd1 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    5.646266] mei_me 0000:00:16.0: irq 45 for MSI/MSI-X
[    5.656828] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20131218/utaddress-258)
[    5.673823] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.684076] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20131218/utaddress-258)
[    5.701057] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.711309] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20131218/utaddress-258)
[    5.728290] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000050f (\_GPE.GPIO) (20131218/utaddress-258)
[    5.744396] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.754650] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.760893] rdac: device handler registered
[    5.765245] hp_sw: device handler registered
[    5.769598] emc: device handler registered
[    5.773753] alua: device handler registered
[    5.778021] libphy: Fixed MDIO Bus: probed
[    5.782200] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.789306] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.795115] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.801003] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    5.806989] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    5.814009] igb: Copyright (c) 2007-2013 Intel Corporation.
[    5.819647] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    5.827466] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    5.833296] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.839115] r8169 0000:05:00.0: irq 46 for MSI/MSI-X
[    5.844220] r8169 0000:05:00.0 eth0: RTL8168e/8111e at 0xffffc90004e66000, 20:cf:30:f4:b6:f7, XID 0c200000 IRQ 46
[    5.854564] r8169 0000:05:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.863187] usbcore: registered new interface driver catc
[    5.868648] usbcore: registered new interface driver kaweth
[    5.874281] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    5.881765] usbcore: registered new interface driver pegasus
[    5.887489] usbcore: registered new interface driver rtl8150
[    5.893215] usbcore: registered new interface driver asix
[    5.898677] usbcore: registered new interface driver cdc_ether
[    5.904574] usbcore: registered new interface driver cdc_eem
[    5.910299] usbcore: registered new interface driver dm9601
[    5.915937] usbcore: registered new interface driver smsc75xx
[    5.921747] usbcore: registered new interface driver smsc95xx
[    5.927555] usbcore: registered new interface driver gl620a
[    5.933193] usbcore: registered new interface driver net1080
[    5.938917] usbcore: registered new interface driver plusb
[    5.944468] usbcore: registered new interface driver rndis_host
[    5.950450] usbcore: registered new interface driver cdc_subset
[    5.956435] usbcore: registered new interface driver zaurus
[    5.962074] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.969557] usbcore: registered new interface driver int51x1
[    5.975277] usbcore: registered new interface driver ipheth
[    5.980917] usbcore: registered new interface driver sierra_net
[    5.986998] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.993603] ehci-pci: EHCI PCI platform driver
[    5.998169] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    6.004028] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    6.011528] ehci-pci 0000:00:1a.0: debug port 2
[    6.020011] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    6.026871] ehci-pci 0000:00:1a.0: irq 23, io mem 0xfe606000
[    6.037990] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.043854] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.050707] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.058006] usb usb1: Product: EHCI Host Controller
[    6.062942] usb usb1: Manufacturer: Linux 3.14.0-g9a952a0 ehci_hcd
[    6.069178] usb usb1: SerialNumber: 0000:00:1a.0
[    6.074157] hub 1-0:1.0: USB hub found
[    6.077980] hub 1-0:1.0: 2 ports detected
[    6.082186] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    6.087581] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.095081] ehci-pci 0000:00:1d.0: debug port 2
[    6.103564] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    6.110415] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe605000
[    6.121919] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.127775] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.134634] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.141933] usb usb2: Product: EHCI Host Controller
[    6.146871] usb usb2: Manufacturer: Linux 3.14.0-g9a952a0 ehci_hcd
[    6.153113] usb usb2: SerialNumber: 0000:00:1d.0
[    6.157952] hub 2-0:1.0: USB hub found
[    6.161778] hub 2-0:1.0: 2 ports detected
[    6.165923] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.172176] ohci-pci: OHCI PCI platform driver
[    6.176692] uhci_hcd: USB Universal Host Controller Interface driver
[    6.183171] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    6.188557] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
[    6.203019] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[    6.208304] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[    6.213594] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
[    6.218885] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
[    6.224174] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
[    6.229552] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    6.236399] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.243700] usb usb3: Product: xHCI Host Controller
[    6.248635] usb usb3: Manufacturer: Linux 3.14.0-g9a952a0 xhci_hcd
[    6.254877] usb usb3: SerialNumber: 0000:04:00.0
[    6.259713] hub 3-0:1.0: USB hub found
[    6.263530] hub 3-0:1.0: 2 ports detected
[    6.267674] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    6.273073] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
[    6.279805] tsc: Refined TSC clocksource calibration: 3311.144 MHz
[    6.286844] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    6.293719] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.301026] usb usb4: Product: xHCI Host Controller
[    6.305962] usb usb4: Manufacturer: Linux 3.14.0-g9a952a0 xhci_hcd
[    6.312203] usb usb4: SerialNumber: 0000:04:00.0
[    6.317039] hub 4-0:1.0: USB hub found
[    6.320864] hub 4-0:1.0: 2 ports detected
[    6.325016] usbcore: registered new interface driver usbserial
[    6.330921] usbcore: registered new interface driver usbserial_generic
[    6.337511] usbserial: USB Serial support registered for generic
[    6.343594] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    6.353486] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.358518] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.363799] mousedev: PS/2 mouse device common for all mice
[    6.369917] rtc_cmos 00:04: RTC can wake from S4
[    6.374808] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    6.380986] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.388696] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    6.395337] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    6.400986] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    6.408855] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.414938] iTCO_vendor_support: vendor-support=0
[    6.419705] Intel P-state driver initializing.
[    6.424218] Intel pstate controlling: cpu 0
[    6.428512] Intel pstate controlling: cpu 1
[    6.432770] Intel pstate controlling: cpu 2
[    6.437030] Intel pstate controlling: cpu 3
[    6.441657] hidraw: raw HID events driver (C) Jiri Kosina
[    6.447193] usbcore: registered new interface driver usbhid
[    6.452824] usbhid: USB HID core driver
[    6.456744] drop_monitor: Initializing network drop monitor service
[    6.463111] TCP: cubic registered
[    6.466488] Initializing XFRM netlink socket
[    6.470903] NET: Registered protocol family 10
[    6.475785] NET: Registered protocol family 17
[    6.480302] 9pnet: Installing 9P2000 support
[    6.484947] 
[    6.484947] printing PIC contents
[    6.489829] ... PIC  IMR: ffff
[    6.492941] ... PIC  IRR: 0c88
[    6.496067] ... PIC  ISR: 0000
[    6.499190] ... PIC ELCR: 0c88
[    6.502339] printing local APIC contents on CPU#0/0:
[    6.507366] ... APIC ID:      00000000 (0)
[    6.511522] ... APIC VERSION: 01060015
[    6.515333] ... APIC TASKPRI: 00000000 (00)
[    6.519575] ... APIC PROCPRI: 00000000
[    6.523387] ... APIC LDR: 01000000
[    6.526850] ... APIC DFR: ffffffff
[    6.530313] ... APIC SPIV: 000001ff
[    6.533854] ... APIC ISR field:
[    6.537051] 0000000000000000000000000000000000000000000000000000000000000000
[    6.544566] ... APIC TMR field:
[    6.547763] 0000000002000008000800020002000400060002000000000004000000000000
[    6.555278] ... APIC IRR field:
[    6.558473] 0000000000000000000000000000000000000000000000000000000000008000
[    6.565992] ... APIC ESR: 00000000
[    6.569454] ... APIC ICR: 000400f6
[    6.572917] ... APIC ICR2: 02000000
[    6.576460] ... APIC LVTT: 000400ef
[    6.580010] ... APIC LVTPC: 00000400
[    6.583646] ... APIC LVT0: 00010700
[    6.587189] ... APIC LVT1: 00000400
[    6.590740] ... APIC LVTERR: 000000fe
[    6.594464] ... APIC TMICT: 00000000
[    6.598100] ... APIC TMCCT: 00000000
[    6.601737] ... APIC TDCR: 00000000
[    6.605286] 
[    6.606837] number of MP IRQ sources: 15.
[    6.607316] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    6.607317] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.607589] hub 1-1:1.0: USB hub found
[    6.607690] hub 1-1:1.0: 6 ports detected
[    6.632770] number of IO-APIC #0 registers: 24.
[    6.637364] testing the IO APIC.......................
[    6.642569] IO APIC #0......
[    6.645522] .... register #00: 00000000
[    6.649419] .......    : physical APIC id: 00
[    6.653836] .......    : Delivery Type: 0
[    6.657906] .......    : LTS          : 0
[    6.661977] .... register #01: 00170020
[    6.665880] .......     : max redirection entries: 17
[    6.671005] .......     : PRQ implemented: 0
[    6.675353] .......     : IO APIC version: 20
[    6.679788] .... IRQ redirection table:
[    6.683705] 1    0    0   0   0    0    0    00
[    6.688311] 0    0    0   0   0    1    1    31
[    6.692917] 0    0    0   0   0    1    1    30
[    6.697525] 0    0    0   0   0    1    1    33
[    6.702131] 0    0    0   0   0    1    1    34
[    6.706739] 0    0    0   0   0    1    1    35
[    6.710426] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    6.717932] 0    0    0   0   0    1    1    36
[    6.722533] 0    0    0   0   0    1    1    37
[    6.727142] 0    0    0   0   0    1    1    38
[    6.731756] 0    1    0   0   0    1    1    39
[    6.736364] 0    0    0   0   0    1    1    3A
[    6.740978] 0    0    0   0   0    1    1    3B
[    6.745588] 0    0    0   0   0    1    1    3C
[    6.750201] 0    0    0   0   0    1    1    3D
[    6.754806] 0    0    0   0   0    1    1    3E
[    6.759415] 0    0    0   0   0    1    1    3F
[    6.764021] 1    1    0   1   0    1    1    51
[    6.768635] 1    1    0   1   0    1    1    61
[    6.773243] 1    1    0   1   0    1    1    B1
[    6.777848] 1    0    0   0   0    0    0    00
[    6.782456] 1    0    0   0   0    0    0    00
[    6.787063] 1    1    0   1   0    1    1    D1
[    6.791671] 1    0    0   0   0    0    0    00
[    6.796285] 0    1    0   1   0    1    1    41
[    6.800888] IRQ to pin mappings:
[    6.804197] IRQ0 -> 0:2
[    6.806852] IRQ1 -> 0:1
[    6.809487] IRQ3 -> 0:3
[    6.812125] IRQ4 -> 0:4
[    6.814749] IRQ5 -> 0:5
[    6.817377] IRQ6 -> 0:6
[    6.820032] IRQ7 -> 0:7
[    6.822680] IRQ8 -> 0:8
[    6.824634] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    6.824636] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.824903] hub 2-1:1.0: USB hub found
[    6.825007] hub 2-1:1.0: 8 ports detected
[    6.846909] 
[    6.849193] IRQ9 -> 0:9
[    6.851846] IRQ10 -> 0:10
[    6.854670] IRQ11 -> 0:11
[    6.857478] IRQ12 -> 0:12
[    6.860292] IRQ13 -> 0:13
[    6.863121] IRQ14 -> 0:14
[    6.865945] IRQ15 -> 0:15
[    6.868766] IRQ16 -> 0:16
[    6.871580] IRQ17 -> 0:17
[    6.874391] IRQ18 -> 0:18
[    6.877201] IRQ21 -> 0:21
[    6.880024] IRQ23 -> 0:23
[    6.882848] .................................... done.
[    6.888534] Loading compiled-in X.509 certificates
[    6.894859] Loaded X.509 cert 'Magrathea: Glacier signing key: 06d2b99720c6afedf80e78490b4986f86ef0912e'
[    6.904464] registered taskstats version 1
[    6.911582] Key type trusted registered
[    6.918411] Key type encrypted registered
[    6.925156] IMA: No TPM chip found, activating TPM-bypass!
[    6.931333] rtc_cmos 00:04: setting system clock to 2014-10-08 05:48:01 UTC (1412747281)
[    6.939872] r8169 0000:05:00.0: Direct firmware load failed with error -2
[    6.946739] r8169 0000:05:00.0: Falling back to user helper
[    7.100335] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
[    7.266405] usb 2-1.3: New USB device found, idVendor=04d9, idProduct=1702
[    7.273368] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.280784] usb 2-1.3: Product: USB Keyboard
[    7.285135] usb 2-1.3: Manufacturer:  
[    7.288985] Switched to clocksource tsc
[    7.311690] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:04D9:1702.0001/input/input5
[    7.323557] hid-generic 0003:04D9:1702.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1.3/input0
[    7.377005] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/0003:04D9:1702.0002/input/input6
[    7.388874] hid-generic 0003:04D9:1702.0002: input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-1.3/input1
[    7.422175] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.2/0003:04D9:1702.0003/input/input7
[    7.434156] hid-generic 0003:04D9:1702.0003: input,hidraw2: USB HID v1.10 Mouse [  USB Keyboard] on usb-0000:00:1d.0-1.3/input2
[   66.983082] r8169 0000:05:00.0 eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-2)
[   67.004726] r8169 0000:05:00.0 eth0: link down
[   67.004784] r8169 0000:05:00.0 eth0: link down
[   67.013788] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   69.866317] r8169 0000:05:00.0 eth0: link up
[   69.870753] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   69.881508] Sending DHCP requests ..., OK
[   75.836619] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.171
[   75.844597] IP-Config: Complete:
[   75.847900]      device=eth0, hwaddr=20:cf:30:f4:b6:f7, ipaddr=192.168.1.171, mask=255.255.255.0, gw=192.168.1.1
[   75.858167]      host=snb-drag, domain=lkp.intel.com, nis-domain=(none)
[   75.864859]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   75.871598]      nameserver0=192.168.1.1
[   75.875915] PM: Hibernation image not present or could not be loaded.
[   75.883668] Freeing unused kernel memory: 1788K (ffffffff81d91000 - ffffffff81f50000)
[   76.032214] wmi: Mapper loaded
[   76.043633] [drm] Initialized drm 1.1.0 20060810
[   76.053879] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   76.077467] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   76.083525] libata version 3.00 loaded.
[   76.091279] ata_piix 0000:00:1f.2: version 2.13
[   76.095928] pata_via 0000:03:00.0: version 0.3.4
[   76.095975] IOAPIC[0]: Set routing entry (0-20 -> 0x92 -> IRQ 20 Mode:1 Active:1 Dest:15)
[   76.095983] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   76.115326] Error: Driver 'pcspkr' is already registered, aborting...
[   76.121859] scsi0 : pata_via
[   76.125668] scsi1 : pata_via
[   76.125695] parport_pc 00:02: reported by Plug and Play ACPI
[   76.125751] parport0: PC-style at 0x378, irq 5 [PCSPP]
[   76.140165] ata1: PATA max UDMA/133 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 16
[   76.147370] ata2: PATA max UDMA/133 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 16
[   76.157614] asus_wmi: ASUS WMI generic driver loaded
[   76.164549] asus_wmi: Initialization: 0x0
[   76.168648] asus_wmi: BIOS WMI version: 0.9
[   76.172951] asus_wmi: SFUN value: 0x0
[   76.176966] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input9
[   76.185344] asus_wmi: Backlight controlled by ACPI video driver
[   76.247741] scsi2 : ata_piix
[   76.251061] scsi3 : ata_piix
[   76.254106] ata3: SATA max UDMA/133 cmd 0xf110 ctl 0xf100 bmdma 0xf0d0 irq 20
[   76.261321] ata4: SATA max UDMA/133 cmd 0xf0f0 ctl 0xf0e0 bmdma 0xf0d8 irq 20
[   76.268648] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[   76.425390] scsi4 : ata_piix
[   76.428706] scsi5 : ata_piix
[   76.431751] ata5: SATA max UDMA/133 cmd 0xf0b0 ctl 0xf0a0 bmdma 0xf070 irq 20
[   76.438958] ata6: SATA max UDMA/133 cmd 0xf090 ctl 0xf080 bmdma 0xf078 irq 20
[   76.447634] [drm] Memory usable by graphics device = 2048M
[   76.497981] i915 0000:00:02.0: irq 52 for MSI/MSI-X
[   76.502929] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   76.509606] [drm] Driver supports precise vblank timestamp query.
[   76.515812] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   76.530079] [drm] Wrong MCH_SSKPD value: 0x17050407
[   76.535023] [drm] This can cause pipe underruns and display issues.
[   76.541349] [drm] Please upgrade your BIOS to fix this.
[   76.546656] ------------[ cut here ]------------
[   76.551339] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
[   76.566126] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   76.591030] CPU: 2 PID: 254 Comm: modprobe Not tainted 3.14.0-g9a952a0 #1
[   76.597879] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   76.607100]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
[   76.614804]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000001 ffff8801bd312400
[   76.622520]  ffff880099d99800 ffff8801bd46ce28 ffffffffa0247a00 ffff8801bd4c5860
[   76.630237] Call Trace:
[   76.632755]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   76.637955]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   76.644016]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   76.649912]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
[   76.659293]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   76.668765]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   76.677208]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   76.683364]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   76.689606]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   76.695853]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   76.703060]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   76.709568]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   76.715894]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   76.722139]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   76.728289]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   76.733917]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   76.739807]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   76.745610]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   76.751680]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   76.757316]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   76.761145] ata5: SATA link down (SStatus 0 SControl 310)
[   76.768581]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   76.774297]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   76.779753]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   76.785467]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   76.790663]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   76.796292]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   76.801489]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   76.807638]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   76.813707]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   76.818908]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   76.824626]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   76.830341]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   76.835971]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   76.841597]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   76.847140]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   76.852855]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   76.858915] ---[ end trace decc4f53056ad5c3 ]---
[   76.897652] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   76.905913] Raw EDID:
[   76.908250]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.914060]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.919884]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.925692]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.931500]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.937318]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.943122]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   76.949407]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.967478] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   76.975744] Raw EDID:
[   76.978079]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.983880]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.989682]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   76.995484]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.001286]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.007104]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.012910]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   77.018726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.036765] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   77.045026] Raw EDID:
[   77.047362]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.053163]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.058966]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.064767]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.070580]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.076398]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.082208]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   77.088028]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.106059] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   77.114319] Raw EDID:
[   77.116656]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.122466]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.128268]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.134069]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.139872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.145691]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.151492]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   77.157311]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   77.163116] i915 0000:00:02.0: VGA-1: Ignoring invalid EDID block 1.
[   77.279310] ata4.00: failed to resume link (SControl 0)
[   77.344038] ------------[ cut here ]------------
[   77.348727] WARNING: CPU: 0 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
[   77.360107] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   77.385366] CPU: 0 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   77.393201] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   77.402432]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
[   77.410225]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff880099f9e900
[   77.418018]  0000000000000300 0000000000000001 ffffffffa004d300 ffff8801bd4c57f8
[   77.425785] Call Trace:
[   77.428291]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   77.433504]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   77.439593]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   77.445510]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
[   77.452031]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
[   77.457168] ata6: failed to resume link (SControl 0)
[   77.463657]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
[   77.468529] ata6: SATA link down (SStatus 4 SControl 0)
[   77.478352]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   77.487842]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   77.496305]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   77.502486]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   77.508753]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   77.515016]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   77.522241]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   77.528763]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   77.535108]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   77.541372]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   77.547539]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   77.553184]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   77.559092]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   77.564920]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   77.571008]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   77.576652]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   77.579080] ata3.01: failed to resume link (SControl 0)
[   77.587755]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   77.593494]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   77.598968]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   77.604701]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   77.609914]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   77.615567]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   77.620781]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   77.626958]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   77.633043]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   77.638264]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   77.643998]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   77.649742]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   77.655398]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   77.661046]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   77.666607]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   77.672338]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   77.678418] ---[ end trace decc4f53056ad5c4 ]---
[   77.683140] ------------[ cut here ]------------
[   77.687843] WARNING: CPU: 1 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
[   77.699227] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   77.724114] CPU: 1 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   77.731936] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   77.732049] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   77.732059] ata3.01: SATA link down (SStatus 0 SControl 0)
[   77.735594] ata3.00: ATA-8: ST3750528AS, CC38, max UDMA/133
[   77.735595] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   77.741555] ata3.00: configured for UDMA/133
[   77.741701] scsi 2:0:0:0: Direct-Access     ATA      ST3750528AS      CC38 PQ: 0 ANSI: 5
[   77.778238]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
[   77.785941]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8800a4fb0200
[   77.793655]  0000000000000300 0000000000000002 ffffffffa004d640 ffff8801bd4c57f8
[   77.801353] Call Trace:
[   77.803859]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   77.809064]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   77.815126]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   77.821016]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
[   77.827521]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
[   77.834108]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
[   77.843494]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   77.852967]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   77.861403]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   77.867566]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   77.873808]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   77.880054]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   77.887260]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   77.893776]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   77.900112]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   77.906361]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   77.912508]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   77.913804] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   77.924373]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   77.930260]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   77.936080]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   77.942157]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   77.947804]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   77.953622]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   77.959355]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   77.964828]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   77.970560]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   77.975774]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   77.981419]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   77.986633]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   77.992792]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   77.998868]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.004089]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   78.009822]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   78.015555]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   78.021201]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   78.026846]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   78.032407]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   78.038138]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   78.044218] ---[ end trace decc4f53056ad5c5 ]---
[   78.048966] ------------[ cut here ]------------
[   78.053694] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
[   78.065091] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   78.090070] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   78.097900] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   78.107130]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
[   78.115328]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8801bd46cf00
[   78.123051]  0000000000000300 0000000000000003 ffffffffa004d710 ffff8801bd4c57f8
[   78.130777] Call Trace:
[   78.133292]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   78.138495]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   78.144569]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   78.150475]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
[   78.156981]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
[   78.163582]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
[   78.172970]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   78.182452]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   78.190900]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   78.197070]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   78.203321]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   78.209585]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   78.216790]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   78.223303]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   78.229639]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   78.235895]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   78.242053]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   78.247688]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   78.253578]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   78.259388]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   78.265449]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   78.271086]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   78.276888]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   78.282612]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   78.288068]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   78.290469] ata4.01: failed to resume link (SControl 0)
[   78.299075]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.301850] ata4.00: SATA link down (SStatus 4 SControl 0)
[   78.301872] ata4.01: SATA link down (SStatus 0 SControl 0)
[   78.315365]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   78.321008]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.326215]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   78.332372]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   78.338450]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.343661]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   78.349394]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   78.355145]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   78.360791]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   78.366417]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   78.371960]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   78.377676]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   78.383737] ---[ end trace decc4f53056ad5c6 ]---
[   78.388414] ------------[ cut here ]------------
[   78.393096] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
[   78.404484] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   78.430505] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   78.438324] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   78.447530]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
[   78.455226]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8801bd46cb00
[   78.462926]  0000000000000300 0000000000000004 ffffffffa004db20 ffff8801bd4c57f8
[   78.470631] Call Trace:
[   78.473137]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   78.478331]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   78.484395]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   78.490286]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
[   78.496789]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
[   78.503377]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
[   78.512762]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   78.522237]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   78.530679]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   78.536835]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   78.543078]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   78.549325]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   78.556530]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   78.563037]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   78.569365]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   78.575621]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   78.581769]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   78.587396]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   78.593285]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   78.599089]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   78.605149]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   78.610796]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   78.616598]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   78.622311]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   78.627769]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   78.633483]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.638678]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   78.644306]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.649503]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   78.655654]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   78.661720]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.666924]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   78.672642]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   78.678357]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   78.683984]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   78.689613]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   78.695157]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   78.700871]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   78.706932] ---[ end trace decc4f53056ad5c7 ]---
[   78.711608] ------------[ cut here ]------------
[   78.716289] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
[   78.727663] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   78.753674] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   78.761495] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   78.770700]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
[   78.778396]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8801bd46c300
[   78.786095]  0000000000000300 0000000000000005 ffffffffa004dcc0 ffff8801bd4c57f8
[   78.793784] Call Trace:
[   78.796290]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   78.801485]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   78.807546]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   78.813439]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
[   78.819942]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
[   78.826529]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
[   78.835917]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   78.845398]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   78.853840]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   78.860003]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   78.866246]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   78.872492]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   78.879698]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   78.886205]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   78.892533]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   78.898781]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   78.904933]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   78.910567]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   78.916456]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   78.922259]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   78.928335]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   78.933983]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   78.939800]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   78.945534]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   78.951006]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   78.956738]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.961953]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   78.967598]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.972812]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   78.978970]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   78.985045]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   78.990267]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   78.995991]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   79.001725]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   79.007372]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   79.013016]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   79.018576]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   79.024310]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   79.030386] ---[ end trace decc4f53056ad5c8 ]---
[   79.035071] ------------[ cut here ]------------
[   79.039770] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:1030 drm_mode_connector_list_update+0xe9/0xf0 [drm]()
[   79.052199] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   79.078489] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   79.086310] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   79.096008]  0000000000000009 ffff8801bd4c57d0 ffffffff8183d636 0000000000000000
[   79.103773]  ffff8801bd4c5808 ffffffff8106bd7d ffff8801bd312448 ffff8801bd312400
[   79.111534]  ffff880099d99800 0000000000000005 ffff8801bd312400 ffff8801bd4c5818
[   79.119282] Call Trace:
[   79.121788]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   79.127001]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   79.133081]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   79.138989]  [<ffffffffa0039489>] drm_mode_connector_list_update+0xe9/0xf0 [drm]
[   79.146478]  [<ffffffffa01a90e3>] drm_helper_probe_single_connector_modes+0x113/0x3a0 [drm_kms_helper]
[   79.155871]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   79.165353]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   79.173807]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   79.179977]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   79.186239]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   79.192502]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   79.199716]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   79.206231]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   79.212569]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   79.218824]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   79.224990]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   79.230636]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   79.236542]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   79.242362]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   79.248441]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   79.254086]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   79.259904]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   79.265638]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   79.271102]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   79.276836]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.282047]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   79.287694]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.292906]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   79.299074]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   79.305152]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.310371]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   79.316097]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   79.321828]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   79.327476]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   79.333120]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   79.338681]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   79.344414]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   79.350492] ---[ end trace decc4f53056ad5c9 ]---
[   79.355187] ------------[ cut here ]------------
[   79.359881] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
[   79.374677] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   79.400957] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   79.408777] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   79.417999]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
[   79.425758]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000002 ffff8801bd310800
[   79.433500]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02490f0 ffff8801bd4c5860
[   79.441241] Call Trace:
[   79.443744]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   79.448957]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   79.455037]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   79.460943]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
[   79.470340]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   79.479821]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   79.488272]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   79.494445]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   79.500704]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   79.506968]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   79.514183]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   79.520691]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   79.527033]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   79.533292]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   79.539457]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   79.545103]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   79.551008]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   79.556829]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   79.562906]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   79.568554]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   79.574373]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   79.580096]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   79.585560]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   79.591292]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.596504]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   79.602151]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.607365]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   79.613541]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   79.619616]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.624837]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   79.630571]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   79.636305]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   79.641952]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   79.647596]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   79.653155]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   79.658888]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   79.664966] ---[ end trace decc4f53056ad5ca ]---
[   79.669901] ------------[ cut here ]------------
[   79.674614] WARNING: CPU: 0 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
[   79.689425] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   79.715591] CPU: 0 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   79.723428] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   79.732659]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
[   79.740381]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000003 ffff8801bd328400
[   79.748105]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02487e0 ffff8801bd4c5860
[   79.755819] Call Trace:
[   79.758337]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   79.763547]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   79.769618]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   79.775525]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
[   79.784912]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   79.794395]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   79.802851]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   79.809022]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   79.815279]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   79.821535]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   79.828750]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   79.835256]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   79.841598]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   79.847849]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   79.854011]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   79.859641]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   79.865536]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   79.871339]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   79.877409]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   79.883038]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   79.888847]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   79.894563]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   79.900027]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   79.905744]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.910947]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   79.916576]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.921780]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   79.927934]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   79.934019]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   79.939235]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   79.944969]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   79.950701]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   79.956347]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   79.961994]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   79.967563]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   79.973294]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   79.979374] ---[ end trace decc4f53056ad5cb ]---
[   79.984123] ------------[ cut here ]------------
[   79.988847] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
[   80.003658] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   80.029822] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   80.037652] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   80.047363]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
[   80.055092]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000004 ffff8801bd329000
[   80.062813]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02490f0 ffff8801bd4c5860
[   80.070538] Call Trace:
[   80.073053]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   80.078259]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   80.084336]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   80.090235]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
[   80.099638]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   80.109112]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   80.117568]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   80.123741]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   80.129998]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   80.136256]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   80.143476]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   80.149981]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   80.156317]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   80.162565]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   80.168730]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   80.174366]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   80.180264]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   80.186067]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   80.192135]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   80.197764]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   80.203575]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   80.209290]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   80.214753]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   80.220468]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   80.225673]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   80.231302]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   80.236506]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   80.242657]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   80.248724]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   80.253927]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   80.259645]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   80.265359]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   80.270988]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   80.276616]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   80.282160]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   80.287875]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   80.293934] ---[ end trace decc4f53056ad5cc ]---
[   80.298778] ------------[ cut here ]------------
[   80.303471] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
[   80.318251] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
[   80.344261] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
[   80.352083] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
[   80.361286]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
[   80.368983]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000005 ffff8801bd329c00
[   80.376683]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02487e0 ffff8801bd4c5860
[   80.384390] Call Trace:
[   80.386894]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
[   80.392089]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
[   80.398151]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
[   80.404040]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
[   80.413418]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
[   80.422892]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
[   80.431326]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
[   80.437482]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   80.443725]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
[   80.449970]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
[   80.457176]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
[   80.463676]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
[   80.470002]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
[   80.476249]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
[   80.482399]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
[   80.488029]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
[   80.493916]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
[   80.499719]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
[   80.505779]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
[   80.511407]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
[   80.517211]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
[   80.522925]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
[   80.528381]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
[   80.534096]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   80.539291]  [<ffffffff814ef754>] driver_register+0x64/0xf0
[   80.544919]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   80.550117]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
[   80.556268]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
[   80.562335]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
[   80.567536]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
[   80.573254]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
[   80.578969]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
[   80.584597]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
[   80.590225]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
[   80.595770]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
[   80.601485]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
[   80.607562] ---[ end trace decc4f53056ad5cd ]---
[   80.612876] fbcon: inteldrmfb (fb0) is primary device
[   80.783288] Console: switching to colour frame buffer device 128x48
[   80.797470] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   80.803683] i915 0000:00:02.0: registered panic notifier
[   80.816202] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   80.823428] acpi device:38: registered as cooling_device4
[   80.828962] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   80.838251] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   80.845591] IOAPIC[0]: Set routing entry (0-22 -> 0xb2 -> IRQ 22 Mode:1 Active:1 Dest:15)
[   80.854053] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
[   80.876881] sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   80.884549] sd 2:0:0:0: [sda] Write Protect is off
[   80.889373] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   80.894472] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   80.913195] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[   80.922766] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[   80.932496] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[   80.942075] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   80.951627] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   80.961541] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   80.971160] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   80.979936] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   80.989024] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   81.014699]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   81.023318] sd 2:0:0:0: [sda] Attached SCSI disk
[   81.033834] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   81.444727] random: nonblocking pool is initialized
[   81.823091] xor: automatically using best checksumming function:
[   81.839474]    avx       : 13408.000 MB/sec
[   81.864461] raid6: sse2x1    4761 MB/s
[   81.885438] raid6: sse2x2    7339 MB/s
[   81.906420] raid6: sse2x4    9308 MB/s
[   81.911031] raid6: using algorithm sse2x4 (9308 MB/s)
[   81.916939] raid6: using ssse3x2 recovery algorithm
[   81.938751] bio: create slab <bio-1> at 1
[   81.943891] Btrfs loaded
[   81.949466] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 5 transid 6 /dev/sda10
[   81.959697] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 4 transid 6 /dev/sda9
[   81.969883] BTRFS: device fsid 900723f3-0511-4215-979c-2146631700ac devid 1 transid 230 /dev/sda6
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.14.0-g9a952a0 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 8 05:42:29 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-9a952a0d42ff089945ea3f5b3f690e45218d073f-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/vmlinuz-3.14.0-g9a952a0 kconfig=x86_64-rhel commit=9a952a0d42ff089945ea3f5b3f690e45218d073f branch=linus/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ebff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000bac1dfff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000bac1e000-0x00000000bac76fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bac77000-0x00000000bada9fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000badaa000-0x00000000badbafff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000badbb000-0x00000000badcefff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000badcf000-0x00000000badd0fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000badd1000-0x00000000badd1fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x00000000badd2000-0x00000000badd9fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000badda000-0x00000000bade3fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bade4000-0x00000000bae3dfff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000bae3e000-0x00000000bae80fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bae81000-0x00000000baffffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000bb800000-0x00000000bf9fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001bfdfffff] usable
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.6 present.
<7>[    0.000000] DMI: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x1bfe00 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-CFFFF write-protect
<7>[    0.000000]   D0000-E7FFF uncachable
<7>[    0.000000]   E8000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 000000000 mask E00000000 write-back
<7>[    0.000000]   1 base 0BB800000 mask FFF800000 uncachable
<7>[    0.000000]   2 base 0BC000000 mask FFC000000 uncachable
<7>[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
<7>[    0.000000]   4 base 1BFE00000 mask FFFE00000 uncachable
<7>[    0.000000]   5 base 1C0000000 mask FC0000000 uncachable
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000]   8 disabled
<7>[    0.000000]   9 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<7>[    0.000000] e820: update [mem 0xbb800000-0xffffffff] usable ==> reserved
<6>[    0.000000] e820: last_pfn = 0xbb000 max_arch_pfn = 0x400000000
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>[    0.000000] found SMP MP-table at [mem 0x000fcdd0-0x000fcddf] mapped at [ffff8800000fcdd0]
<4>[    0.000000]   mpc: fcaa0-fcd54
<7>[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
<7>[    0.000000] reserving inaccessible SNB gfx pages
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x1bf180000, 0x1bf180fff] PGTABLE
<7>[    0.000000] BRK [0x1bf181000, 0x1bf181fff] PGTABLE
<7>[    0.000000] BRK [0x1bf182000, 0x1bf182fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x1bfc00000-0x1bfdfffff]
<7>[    0.000000]  [mem 0x1bfc00000-0x1bfdfffff] page 2M
<7>[    0.000000] BRK [0x1bf183000, 0x1bf183fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x1bc000000-0x1bfbfffff]
<7>[    0.000000]  [mem 0x1bc000000-0x1bfbfffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x180000000-0x1bbffffff]
<7>[    0.000000]  [mem 0x180000000-0x1bbffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
<7>[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x40200000-0xbac1dfff]
<7>[    0.000000]  [mem 0x40200000-0xbabfffff] page 2M
<7>[    0.000000]  [mem 0xbac00000-0xbac1dfff] page 4k
<7>[    0.000000] BRK [0x1bf184000, 0x1bf184fff] PGTABLE
<7>[    0.000000] BRK [0x1bf185000, 0x1bf185fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0xbadcf000-0xbadd0fff]
<7>[    0.000000]  [mem 0xbadcf000-0xbadd0fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xbae81000-0xbaffffff]
<7>[    0.000000]  [mem 0xbae81000-0xbaffffff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
<7>[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
<6>[    0.000000] RAMDISK: [mem 0x1ade4f000-0x1bdffffff]
<4>[    0.000000] ACPI: RSDP 00000000000f0420 000024 (v02 ALASKA)
<4>[    0.000000] ACPI: XSDT 00000000bac69068 00004C (v01 ALASKA    A M I 01072009 AMI  00010013)
<4>[    0.000000] ACPI: FACP 00000000bac72fa0 0000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
<4>[    0.000000] ACPI: DSDT 00000000bac69140 009E5F (v02 ALASKA    A M I 00000000 INTL 20051117)
<4>[    0.000000] ACPI: FACS 00000000baddbf80 000040
<4>[    0.000000] ACPI: APIC 00000000bac73098 000072 (v03 ALASKA    A M I 01072009 AMI  00010013)
<4>[    0.000000] ACPI: SSDT 00000000bac73110 000102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
<4>[    0.000000] ACPI: MCFG 00000000bac73218 00003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
<4>[    0.000000] ACPI: HPET 00000000bac73258 000038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001bfdfffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1bfdfffff]
<6>[    0.000000]   NODE_DATA [mem 0x1bfdd5000-0x1bfdfbfff]
<7>[    0.000000]  [ffffea0000000000-ffffea0006ffffff] PMD -> [ffff8801a7e00000-ffff8801addfffff] on node 0
<4>[    0.000000] Zone ranges:
<4>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>[    0.000000]   Normal   [mem 0x100000000-0x1bfdfffff]
<4>[    0.000000] Movable zone start for each node
<4>[    0.000000] Early memory node ranges
<4>[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
<4>[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
<4>[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
<4>[    0.000000]   node   0: [mem 0x40200000-0xbac1dfff]
<4>[    0.000000]   node   0: [mem 0xbadcf000-0xbadd0fff]
<4>[    0.000000]   node   0: [mem 0xbae81000-0xbaffffff]
<4>[    0.000000]   node   0: [mem 0x100000000-0x1bfdfffff]
<7>[    0.000000] On node 0 totalpages: 1550140
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 157 pages reserved
<7>[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 11879 pages used for memmap
<7>[    0.000000]   DMA32 zone: 760223 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 12280 pages used for memmap
<7>[    0.000000]   Normal zone: 785920 pages, LIFO batch:31
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57a000 (        fee00000)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
<7>[    0.000000] ACPI: IRQ2 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff579000 (fec00000)
<7>[    0.000000] nr_irqs_gsi: 40
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbac1e000-0xbac76fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbac77000-0xbada9fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbadaa000-0xbadbafff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbadbb000-0xbadcefff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbadd1000-0xbadd1fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbadd2000-0xbadd9fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbadda000-0xbade3fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbade4000-0xbae3dfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbae3e000-0xbae80fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbb000000-0xbb7fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbb800000-0xbf9fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfa00000-0xfed1bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
<6>[    0.000000] e820: [mem 0xbfa00000-0xfed1bfff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8801bfa00000 s88896 r8192 d21696 u524288
<7>[    0.000000] pcpu-alloc: s88896 r8192 d21696 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1525760
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-9a952a0d42ff089945ea3f5b3f690e45218d073f-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/vmlinuz-3.14.0-g9a952a0 kconfig=x86_64-rhel commit=9a952a0d42ff089945ea3f5b3f690e45218d073f branch=linus/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/9a952a0d42ff089945ea3f5b3f690e45218d073f/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
<6>[    0.000000] Checking aperture...
<6>[    0.000000] No AGP bridge found
<4>[    0.000000] Memory: 5752864K/6200560K available (8525K kernel code, 1631K rwdata, 3720K rodata, 1788K init, 2196K bss, 447696K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
<6>[    0.000000] NR_IRQS:524544 nr_irqs:712 16
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 25165824 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 3311.505 MHz processor
<6>[    0.000025] Calibrating delay loop (skipped), value calculated using timer frequency.. 6623.01 BogoMIPS (lpj=3311505)
<6>[    0.010729] pid_max: default: 32768 minimum: 301
<6>[    0.015393] ACPI: Core revision 20131218
<4>[    0.021673] ACPI: All ACPI Tables successfully acquired
<6>[    0.027079] Security Framework initialized
<6>[    0.031222] SELinux:  Initializing.
<7>[    0.034753] SELinux:  Starting in permissive mode
<6>[    0.039914] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<6>[    0.048611] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    0.056368] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.063311] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.070863] Initializing cgroup subsys memory
<6>[    0.075289] Initializing cgroup subsys devices
<6>[    0.079797] Initializing cgroup subsys freezer
<6>[    0.084309] Initializing cgroup subsys net_cls
<6>[    0.088820] Initializing cgroup subsys blkio
<6>[    0.093158] Initializing cgroup subsys perf_event
<6>[    0.097929] Initializing cgroup subsys hugetlb
<6>[    0.102460] CPU: Physical Processor ID: 0
<6>[    0.106536] CPU: Processor Core ID: 0
<6>[    0.110263] mce: CPU supports 9 MCE banks
<7>[    0.114346] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.120163] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
<6>[    0.120163] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>[    0.120163] tlb_flushall_shift: 6
<6>[    0.135361] Freeing SMP alternatives memory: 36K (ffffffff81f50000 - ffffffff81f59000)
<6>[    0.144441] ftrace: allocating 30377 entries in 119 pages
<4>[    0.161064] Getting VERSION: 1060015
<4>[    0.164712] Getting VERSION: 1060015
<4>[    0.168356] Getting ID: 0
<4>[    0.171041] Getting ID: 0
<4>[    0.173729] enabled ExtINT on CPU#0
<4>[    0.177508] ENABLING IO-APIC IRQs
<7>[    0.180886] init IO_APIC IRQs
<7>[    0.183917]  apic 0 pin 0 not connected
<7>[    0.187817] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.195818] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.203820] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.211815] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.219817] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.227816] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.235810] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.243812] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.251813] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.259813] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.267979] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.276155] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.284329] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.292502] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.300668] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.308834]  apic 0 pin 16 not connected
<7>[    0.312817]  apic 0 pin 17 not connected
<7>[    0.316799]  apic 0 pin 18 not connected
<7>[    0.320782]  apic 0 pin 19 not connected
<7>[    0.324766]  apic 0 pin 20 not connected
<7>[    0.328749]  apic 0 pin 21 not connected
<7>[    0.332732]  apic 0 pin 22 not connected
<7>[    0.336716]  apic 0 pin 23 not connected
<6>[    0.340831] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.356883] smpboot: CPU0: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz (fam: 06, model: 2a, stepping: 07)
<7>[    0.366429] TSC deadline timer enabled
<6>[    0.371916] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
<6>[    0.382707] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
<6>[    0.390786] ... version:                3
<6>[    0.394856] ... bit width:              48
<6>[    0.399011] ... generic registers:      8
<6>[    0.403083] ... value mask:             0000ffffffffffff
<6>[    0.408451] ... max period:             0000ffffffffffff
<6>[    0.413820] ... fixed-purpose events:   3
<6>[    0.417890] ... event mask:             00000007000000ff
<6>[    0.424396] x86: Booting SMP configuration:
<6>[    0.428637] .... node  #0, CPUs:      #1
<4>[    0.443523] masked ExtINT on CPU#1
<7>[    0.447135] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    0.454991] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.463138]  #2
<4>[    0.475854] masked ExtINT on CPU#2
<7>[    0.479460] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    0.487346]  #3
<4>[    0.500167] masked ExtINT on CPU#3
<7>[    0.503776] CPU3: Thermal LVT vector (0xfa) already installed
<6>[    0.511599] x86: Booted up 1 node, 4 CPUs
<6>[    0.515672] smpboot: Total of 4 processors activated (26492.04 BogoMIPS)
<6>[    0.524854] devtmpfs: initialized
<6>[    0.530022] EVM: security.selinux
<6>[    0.533398] EVM: security.ima
<6>[    0.536429] EVM: security.capability
<6>[    0.540164] PM: Registering ACPI NVS region [mem 0xbac1e000-0xbac76fff] (364544 bytes)
<6>[    0.548167] PM: Registering ACPI NVS region [mem 0xbadaa000-0xbadbafff] (69632 bytes)
<6>[    0.556077] PM: Registering ACPI NVS region [mem 0xbadda000-0xbade3fff] (40960 bytes)
<6>[    0.563985] PM: Registering ACPI NVS region [mem 0xbae3e000-0xbae80fff] (274432 bytes)
<6>[    0.572610] atomic64 test passed for x86-64 platform with CX8 and with SSE
<6>[    0.579575] NET: Registered protocol family 16
<6>[    0.584222] cpuidle: using governor menu
<6>[    0.588292] ACPI: bus type PCI registered
<6>[    0.592359] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.598897] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
<6>[    0.608286] PCI: not using MMCONFIG
<6>[    0.611835] PCI: Using configuration type 1 for base access
<6>[    0.618505] bio: create slab <bio-0> at 0
<6>[    0.622635] ACPI: Added _OSI(Module Device)
<6>[    0.626877] ACPI: Added _OSI(Processor Device)
<6>[    0.631379] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.636141] ACPI: Added _OSI(Processor Aggregator Device)
<4>[    0.643582] ACPI: Executed 1 blocks of module-level executable AML code
<4>[    0.651901] ACPI: SSDT 00000000baddac18 00038C (v01    AMI      IST 00000001 MSFT 03000001)
<4>[    0.660695] ACPI: Dynamic OEM Table Load:
<4>[    0.664872] ACPI: SSDT           (null) 00038C (v01    AMI      IST 00000001 MSFT 03000001)
<4>[    0.673425] ACPI: SSDT 00000000baddbe18 000084 (v01    AMI      CST 00000001 MSFT 03000001)
<4>[    0.682180] ACPI: Dynamic OEM Table Load:
<4>[    0.686357] ACPI: SSDT           (null) 000084 (v01    AMI      CST 00000001 MSFT 03000001)
<6>[    0.695226] ACPI: Interpreter enabled
<4>[    0.698954] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
<6>[    0.708369] ACPI: (supports S0 S1 S3 S4 S5)
<6>[    0.712613] ACPI: Using IOAPIC for interrupt routing
<6>[    0.717649] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
<6>[    0.727070] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
<6>[    0.740942] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    0.750247] ACPI: No dock devices found.
<5>[    0.754408] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<6>[    0.765191] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>[    0.771430] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.779780] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug]
<6>[    0.786794] acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
<6>[    0.793928] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cd7ff])
<6>[    0.806516] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
<6>[    0.817231] PCI host bridge to bus 0000:00
<6>[    0.821386] pci_bus 0000:00: root bus resource [bus 00-ff]
<6>[    0.826927] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    0.833160] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    0.839395] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    0.846323] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xffffffff]
<7>[    0.853256] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
<7>[    0.859383] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
<7>[    0.865468] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<6>[    0.871642] pci 0000:00:01.0: System wakeup disabled by ACPI
<7>[    0.877387] pci 0000:00:02.0: [8086:0112] type 00 class 0x030000
<7>[    0.883452] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit]
<7>[    0.890301] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
<7>[    0.897606] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
<7>[    0.903309] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
<7>[    0.909392] pci 0000:00:16.0: reg 0x10: [mem 0xfe607000-0xfe60700f 64bit]
<7>[    0.916309] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    0.922519] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
<7>[    0.928598] pci 0000:00:1a.0: reg 0x10: [mem 0xfe606000-0xfe6063ff]
<7>[    0.935009] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>[    0.941192] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>[    0.946943] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
<7>[    0.953019] pci 0000:00:1b.0: reg 0x10: [mem 0xfe600000-0xfe603fff 64bit]
<7>[    0.959935] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<7>[    0.966136] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
<7>[    0.972272] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    0.978455] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    0.984202] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
<7>[    0.990343] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>[    0.996528] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>[    1.002273] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
<7>[    1.008417] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
<6>[    1.014600] pci 0000:00:1c.5: System wakeup disabled by ACPI
<7>[    1.020344] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
<7>[    1.026948] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
<6>[    1.033129] pci 0000:00:1c.6: System wakeup disabled by ACPI
<7>[    1.038875] pci 0000:00:1c.7: [8086:244e] type 01 class 0x060401
<7>[    1.045011] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
<6>[    1.051192] pci 0000:00:1c.7: System wakeup disabled by ACPI
<7>[    1.056942] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
<7>[    1.063026] pci 0000:00:1d.0: reg 0x10: [mem 0xfe605000-0xfe6053ff]
<7>[    1.069429] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>[    1.075611] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    1.081360] pci 0000:00:1f.0: [8086:1c4a] type 00 class 0x060100
<7>[    1.087572] pci 0000:00:1f.2: [8086:1c00] type 00 class 0x01018f
<7>[    1.093648] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
<7>[    1.099288] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
<7>[    1.104924] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
<7>[    1.110561] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
<7>[    1.116201] pci 0000:00:1f.2: reg 0x20: [io  0xf0d0-0xf0df]
<7>[    1.121838] pci 0000:00:1f.2: reg 0x24: [io  0xf0c0-0xf0cf]
<7>[    1.127541] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
<7>[    1.133621] pci 0000:00:1f.3: reg 0x10: [mem 0xfe604000-0xfe6040ff 64bit]
<7>[    1.140485] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
<7>[    1.146171] pci 0000:00:1f.5: [8086:1c08] type 00 class 0x010185
<7>[    1.152247] pci 0000:00:1f.5: reg 0x10: [io  0xf0b0-0xf0b7]
<7>[    1.157887] pci 0000:00:1f.5: reg 0x14: [io  0xf0a0-0xf0a3]
<7>[    1.163524] pci 0000:00:1f.5: reg 0x18: [io  0xf090-0xf097]
<7>[    1.169161] pci 0000:00:1f.5: reg 0x1c: [io  0xf080-0xf083]
<7>[    1.174798] pci 0000:00:1f.5: reg 0x20: [io  0xf070-0xf07f]
<7>[    1.180435] pci 0000:00:1f.5: reg 0x24: [io  0xf060-0xf06f]
<6>[    1.186160] pci 0000:00:01.0: PCI bridge to [bus 01]
<6>[    1.191235] pci 0000:00:1c.0: PCI bridge to [bus 02]
<7>[    1.196342] pci 0000:03:00.0: [1106:0415] type 00 class 0x010185
<7>[    1.202427] pci 0000:03:00.0: reg 0x10: [io  0xe040-0xe047]
<7>[    1.208066] pci 0000:03:00.0: reg 0x14: [io  0xe030-0xe033]
<7>[    1.213712] pci 0000:03:00.0: reg 0x18: [io  0xe020-0xe027]
<7>[    1.219356] pci 0000:03:00.0: reg 0x1c: [io  0xe010-0xe013]
<7>[    1.224996] pci 0000:03:00.0: reg 0x20: [io  0xe000-0xe00f]
<7>[    1.230655] pci 0000:03:00.0: reg 0x30: [mem 0xfe500000-0xfe50ffff pref]
<7>[    1.237484] pci 0000:03:00.0: supports D1 D2
<7>[    1.241817] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
<6>[    1.249633] pci 0000:00:1c.4: PCI bridge to [bus 03]
<7>[    1.254661] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
<7>[    1.260818] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
<7>[    1.267742] pci 0000:04:00.0: [1b21:1042] type 00 class 0x0c0330
<7>[    1.273830] pci 0000:04:00.0: reg 0x10: [mem 0xfe400000-0xfe407fff 64bit]
<7>[    1.280825] pci 0000:04:00.0: PME# supported from D3hot D3cold
<6>[    1.288727] pci 0000:00:1c.5: PCI bridge to [bus 04]
<7>[    1.293751] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
<7>[    1.300670] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
<7>[    1.306754] pci 0000:05:00.0: reg 0x10: [io  0xd000-0xd0ff]
<7>[    1.312415] pci 0000:05:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
<7>[    1.319737] pci 0000:05:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
<7>[    1.327148] pci 0000:05:00.0: supports D1 D2
<7>[    1.331476] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    1.340157] pci 0000:00:1c.6: PCI bridge to [bus 05]
<7>[    1.345187] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
<7>[    1.351348] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
<7>[    1.359237] pci 0000:06:00.0: [1b21:1080] type 01 class 0x060401
<6>[    1.365416] pci 0000:06:00.0: System wakeup disabled by ACPI
<6>[    1.371157] pci 0000:00:1c.7: PCI bridge to [bus 06-07] (subtractive decode)
<7>[    1.378272] pci 0000:00:1c.7:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    1.386265] pci 0000:00:1c.7:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    1.394258] pci 0000:00:1c.7:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    1.402951] pci 0000:00:1c.7:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
<6>[    1.411748] pci 0000:06:00.0: PCI bridge to [bus 07] (subtractive decode)
<7>[    1.418610] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
<7>[    1.427215] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
<7>[    1.435814] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
<7>[    1.444413] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
<7>[    1.453020] pci 0000:06:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    1.461013] pci 0000:06:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    1.469005] pci 0000:06:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    1.477690] pci 0000:06:00.0:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
<6>[    1.486646] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
<6>[    1.495436] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
<6>[    1.504226] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
<6>[    1.512807] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
<6>[    1.521390] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
<6>[    1.530177] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
<6>[    1.538966] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
<6>[    1.547748] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
<4>[    1.556538] ACPI: Enabled 2 GPEs in block 00 to 3F
<6>[    1.561550] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    1.569725] vgaarb: loaded
<6>[    1.572493] vgaarb: bridge control possible 0000:00:02.0
<5>[    1.577905] SCSI subsystem initialized
<6>[    1.581732] ACPI: bus type USB registered
<6>[    1.585813] usbcore: registered new interface driver usbfs
<6>[    1.591360] usbcore: registered new interface driver hub
<6>[    1.596746] usbcore: registered new device driver usb
<6>[    1.601869] pps_core: LinuxPPS API ver. 1 registered
<6>[    1.606890] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    1.616104] PTP clock support registered
<6>[    1.620116] PCI: Using ACPI for IRQ routing
<7>[    1.625718] PCI: pci_cache_line_size set to 64 bytes
<7>[    1.630786] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
<7>[    1.636850] e820: reserve RAM buffer [mem 0xbac1e000-0xbbffffff]
<7>[    1.642911] e820: reserve RAM buffer [mem 0xbadd1000-0xbbffffff]
<7>[    1.648975] e820: reserve RAM buffer [mem 0xbb000000-0xbbffffff]
<7>[    1.655035] e820: reserve RAM buffer [mem 0x1bfe00000-0x1bfffffff]
<6>[    1.661334] NetLabel: Initializing
<6>[    1.664795] NetLabel:  domain hash size = 128
<6>[    1.669211] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    1.674244] NetLabel:  unlabeled traffic allowed by default
<6>[    1.679957] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    1.686658] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    1.694561] Switched to clocksource hpet
<6>[    1.705053] pnp: PnP ACPI init
<6>[    1.708183] ACPI: bus type PNP registered
<6>[    1.712360] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
<6>[    1.719032] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
<6>[    1.725707] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
<6>[    1.732383] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>[    1.739060] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
<7>[    1.745737] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.752643] system 00:01: [io  0x0290-0x029f] has been reserved
<7>[    1.758623] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.765654] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:15)
<7>[    1.773745] pnp 00:02: [dma 0 disabled]
<7>[    1.777710] pnp 00:02: Plug and Play ACPI device, IDs PNP0400 (active)
<7>[    1.784304] pnp 00:03: [dma 4]
<7>[    1.787434] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
<7>[    1.794028] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    1.802123] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    1.808720] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
<6>[    1.815340] system 00:06: [io  0x04d0-0x04d1] has been reserved
<7>[    1.821317] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.828172] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<7>[    1.836440] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
<7>[    1.843155] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
<7>[    1.851246] pnp 00:08: [dma 0 disabled]
<7>[    1.855180] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
<6>[    1.861888] system 00:09: [io  0x0400-0x0453] could not be reserved
<6>[    1.868216] system 00:09: [io  0x0458-0x047f] has been reserved
<6>[    1.874199] system 00:09: [io  0x0500-0x057f] has been reserved
<6>[    1.880185] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    1.886860] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
<6>[    1.893883] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
<6>[    1.900558] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
<7>[    1.907236] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.914122] system 00:0a: [io  0x0454-0x0457] has been reserved
<7>[    1.920104] system 00:0a: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<7>[    1.927784] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
<6>[    1.934468] pnp: PnP ACPI: found 12 devices
<6>[    1.938712] ACPI: bus type PNP unregistered
<6>[    1.948845] pci 0000:00:01.0: PCI bridge to [bus 01]
<6>[    1.953877] pci 0000:00:1c.0: PCI bridge to [bus 02]
<6>[    1.958914] pci 0000:00:1c.4: PCI bridge to [bus 03]
<6>[    1.963937] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
<6>[    1.970099] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
<6>[    1.976949] pci 0000:00:1c.5: PCI bridge to [bus 04]
<6>[    1.981977] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
<6>[    1.989297] pci 0000:00:1c.6: PCI bridge to [bus 05]
<6>[    1.994324] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
<6>[    2.000486] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
<6>[    2.008310] pci 0000:06:00.0: PCI bridge to [bus 07]
<6>[    2.013355] pci 0000:00:1c.7: PCI bridge to [bus 06-07]
<7>[    2.018648] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    2.024287] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    2.029921] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    2.036253] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xffffffff]
<7>[    2.042582] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
<7>[    2.048218] pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
<7>[    2.054550] pci_bus 0000:04: resource 1 [mem 0xfe400000-0xfe4fffff]
<7>[    2.060878] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
<7>[    2.066507] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
<7>[    2.073807] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
<7>[    2.079437] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
<7>[    2.085074] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    2.091402] pci_bus 0000:06: resource 7 [mem 0xbfa00000-0xffffffff]
<7>[    2.097726] pci_bus 0000:07: resource 8 [io  0x0000-0x0cf7]
<7>[    2.103362] pci_bus 0000:07: resource 9 [io  0x0d00-0xffff]
<7>[    2.108999] pci_bus 0000:07: resource 10 [mem 0x000a0000-0x000bffff]
<7>[    2.115416] pci_bus 0000:07: resource 11 [mem 0xbfa00000-0xffffffff]
<6>[    2.121854] NET: Registered protocol family 2
<6>[    2.126394] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
<6>[    2.133815] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>[    2.140705] TCP: Hash tables configured (established 65536 bind 65536)
<6>[    2.147308] TCP: reno registered
<6>[    2.150608] UDP hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    2.156789] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    2.163422] NET: Registered protocol family 1
<6>[    2.167892] RPC: Registered named UNIX socket transport module.
<6>[    2.173877] RPC: Registered udp transport module.
<6>[    2.178638] RPC: Registered tcp transport module.
<6>[    2.183401] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    2.189909] pci 0000:00:02.0: Boot video device
<7>[    2.194570] IOAPIC[0]: Set routing entry (0-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>[    2.203014] IOAPIC[0]: Set routing entry (0-16 -> 0x51 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[    2.211299] IOAPIC[0]: Set routing entry (0-17 -> 0x61 -> IRQ 17 Mode:1 Active:1 Dest:15)
<7>[    2.219597] PCI: CLS 64 bytes, default 64
<6>[    2.223708] Unpacking initramfs...
<6>[    5.255419] Freeing initrd memory: 263876K (ffff8801ade4f000 - ffff8801be000000)
<6>[    5.262902] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    5.269404] software IO TLB [mem 0xb6c1e000-0xbac1e000] (64MB) mapped at [ffff8800b6c1e000-ffff8800bac1dfff]
<6>[    5.279543] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
<6>[    5.290528] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>[    5.296778] Initialise system trusted keyring
<6>[    5.301226] audit: initializing netlink subsys (disabled)
<5>[    5.306701] audit: type=2000 audit(1412747277.028:1): initialized
<6>[    5.332333] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    5.339835] zbud: loaded
<5>[    5.342546] VFS: Disk quotas dquot_6.5.2
<4>[    5.346564] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    5.353449] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
<6>[    5.362464] 9p: Installing v9fs 9p2000 file system support
<6>[    5.368030] msgmni has been set to 11751
<5>[    5.372057] Key type big_key registered
<7>[    5.375955] SELinux:  Registering netfilter hooks
<6>[    5.381150] NET: Registered protocol family 38
<5>[    5.385657] Key type asymmetric registered
<5>[    5.389819] Asymmetric key parser 'x509' registered
<6>[    5.394779] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    5.402277] io scheduler noop registered
<6>[    5.406264] io scheduler deadline registered (default)
<6>[    5.411463] io scheduler cfq registered
<7>[    5.415508] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
<7>[    5.420885] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
<7>[    5.426280] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
<7>[    5.431639] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
<7>[    5.437016] IOAPIC[0]: Set routing entry (0-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
<7>[    5.445295] pcieport 0000:00:1c.6: irq 44 for MSI/MSI-X
<6>[    5.450654] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
<7>[    5.457677] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
<6>[    5.464451] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
<7>[    5.471471] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
<6>[    5.478245] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
<6>[    5.485264] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.491856] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
<6>[    5.498630] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
<6>[    5.505648] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.512239] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
<6>[    5.519014] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
<6>[    5.526034] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.532623] pcie_pme 0000:00:1c.6:pcie01: service driver pcie_pme loaded
<6>[    5.539396] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    5.545041] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[    5.551739] intel_idle: MWAIT substates: 0x1120
<7>[    5.556335] intel_idle: v0.4 model 0x2A
<7>[    5.560237] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[    5.566269] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
<6>[    5.574538] ACPI: Power Button [PWRB]
<6>[    5.578333] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[    5.585829] ACPI: Power Button [PWRF]
<6>[    5.590238] GHES: HEST is not enabled!
<6>[    5.594249] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    5.621149] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[    5.629417] Non-volatile memory driver v1.3
<6>[    5.633676] Linux agpgart interface v0.103
<7>[    5.637971] IOAPIC[0]: Set routing entry (0-21 -> 0xd1 -> IRQ 21 Mode:1 Active:1 Dest:15)
<7>[    5.646266] mei_me 0000:00:16.0: irq 45 for MSI/MSI-X
<4>[    5.656828] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20131218/utaddress-258)
<6>[    5.673823] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    5.684076] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20131218/utaddress-258)
<6>[    5.701057] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    5.711309] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20131218/utaddress-258)
<4>[    5.728290] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000050f (\_GPE.GPIO) (20131218/utaddress-258)
<6>[    5.744396] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    5.754650] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[    5.760893] rdac: device handler registered
<6>[    5.765245] hp_sw: device handler registered
<6>[    5.769598] emc: device handler registered
<6>[    5.773753] alua: device handler registered
<6>[    5.778021] libphy: Fixed MDIO Bus: probed
<6>[    5.782200] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    5.789306] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[    5.795115] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    5.801003] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
<6>[    5.806989] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
<6>[    5.814009] igb: Copyright (c) 2007-2013 Intel Corporation.
<6>[    5.819647] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    5.827466] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
<6>[    5.833296] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
<7>[    5.839115] r8169 0000:05:00.0: irq 46 for MSI/MSI-X
<6>[    5.844220] r8169 0000:05:00.0 eth0: RTL8168e/8111e at 0xffffc90004e66000, 20:cf:30:f4:b6:f7, XID 0c200000 IRQ 46
<6>[    5.854564] r8169 0000:05:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
<6>[    5.863187] usbcore: registered new interface driver catc
<6>[    5.868648] usbcore: registered new interface driver kaweth
<6>[    5.874281] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[    5.881765] usbcore: registered new interface driver pegasus
<6>[    5.887489] usbcore: registered new interface driver rtl8150
<6>[    5.893215] usbcore: registered new interface driver asix
<6>[    5.898677] usbcore: registered new interface driver cdc_ether
<6>[    5.904574] usbcore: registered new interface driver cdc_eem
<6>[    5.910299] usbcore: registered new interface driver dm9601
<6>[    5.915937] usbcore: registered new interface driver smsc75xx
<6>[    5.921747] usbcore: registered new interface driver smsc95xx
<6>[    5.927555] usbcore: registered new interface driver gl620a
<6>[    5.933193] usbcore: registered new interface driver net1080
<6>[    5.938917] usbcore: registered new interface driver plusb
<6>[    5.944468] usbcore: registered new interface driver rndis_host
<6>[    5.950450] usbcore: registered new interface driver cdc_subset
<6>[    5.956435] usbcore: registered new interface driver zaurus
<6>[    5.962074] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[    5.969557] usbcore: registered new interface driver int51x1
<6>[    5.975277] usbcore: registered new interface driver ipheth
<6>[    5.980917] usbcore: registered new interface driver sierra_net
<6>[    5.986998] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    5.993603] ehci-pci: EHCI PCI platform driver
<6>[    5.998169] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>[    6.004028] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>[    6.011528] ehci-pci 0000:00:1a.0: debug port 2
<7>[    6.020011] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>[    6.026871] ehci-pci 0000:00:1a.0: irq 23, io mem 0xfe606000
<6>[    6.037990] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>[    6.043854] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    6.050707] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.058006] usb usb1: Product: EHCI Host Controller
<6>[    6.062942] usb usb1: Manufacturer: Linux 3.14.0-g9a952a0 ehci_hcd
<6>[    6.069178] usb usb1: SerialNumber: 0000:00:1a.0
<6>[    6.074157] hub 1-0:1.0: USB hub found
<6>[    6.077980] hub 1-0:1.0: 2 ports detected
<6>[    6.082186] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>[    6.087581] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>[    6.095081] ehci-pci 0000:00:1d.0: debug port 2
<7>[    6.103564] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>[    6.110415] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe605000
<6>[    6.121919] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>[    6.127775] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    6.134634] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.141933] usb usb2: Product: EHCI Host Controller
<6>[    6.146871] usb usb2: Manufacturer: Linux 3.14.0-g9a952a0 ehci_hcd
<6>[    6.153113] usb usb2: SerialNumber: 0000:00:1d.0
<6>[    6.157952] hub 2-0:1.0: USB hub found
<6>[    6.161778] hub 2-0:1.0: 2 ports detected
<6>[    6.165923] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    6.172176] ohci-pci: OHCI PCI platform driver
<6>[    6.176692] uhci_hcd: USB Universal Host Controller Interface driver
<6>[    6.183171] xhci_hcd 0000:04:00.0: xHCI Host Controller
<6>[    6.188557] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
<7>[    6.203019] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
<7>[    6.208304] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
<7>[    6.213594] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
<7>[    6.218885] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
<7>[    6.224174] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
<6>[    6.229552] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    6.236399] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.243700] usb usb3: Product: xHCI Host Controller
<6>[    6.248635] usb usb3: Manufacturer: Linux 3.14.0-g9a952a0 xhci_hcd
<6>[    6.254877] usb usb3: SerialNumber: 0000:04:00.0
<6>[    6.259713] hub 3-0:1.0: USB hub found
<6>[    6.263530] hub 3-0:1.0: 2 ports detected
<6>[    6.267674] xhci_hcd 0000:04:00.0: xHCI Host Controller
<6>[    6.273073] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
<6>[    6.279805] tsc: Refined TSC clocksource calibration: 3311.144 MHz
<6>[    6.286844] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
<6>[    6.293719] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.301026] usb usb4: Product: xHCI Host Controller
<6>[    6.305962] usb usb4: Manufacturer: Linux 3.14.0-g9a952a0 xhci_hcd
<6>[    6.312203] usb usb4: SerialNumber: 0000:04:00.0
<6>[    6.317039] hub 4-0:1.0: USB hub found
<6>[    6.320864] hub 4-0:1.0: 2 ports detected
<6>[    6.325016] usbcore: registered new interface driver usbserial
<6>[    6.330921] usbcore: registered new interface driver usbserial_generic
<6>[    6.337511] usbserial: USB Serial support registered for generic
<6>[    6.343594] i8042: PNP: No PS/2 controller found. Probing ports directly.
<6>[    6.353486] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    6.358518] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    6.363799] mousedev: PS/2 mouse device common for all mice
<6>[    6.369917] rtc_cmos 00:04: RTC can wake from S4
<6>[    6.374808] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
<6>[    6.380986] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>[    6.388696] usb 1-1: new high-speed USB device number 2 using ehci-pci
<6>[    6.395337] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
<6>[    6.400986] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
<6>[    6.408855] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    6.414938] iTCO_vendor_support: vendor-support=0
<6>[    6.419705] Intel P-state driver initializing.
<6>[    6.424218] Intel pstate controlling: cpu 0
<6>[    6.428512] Intel pstate controlling: cpu 1
<6>[    6.432770] Intel pstate controlling: cpu 2
<6>[    6.437030] Intel pstate controlling: cpu 3
<6>[    6.441657] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    6.447193] usbcore: registered new interface driver usbhid
<6>[    6.452824] usbhid: USB HID core driver
<6>[    6.456744] drop_monitor: Initializing network drop monitor service
<6>[    6.463111] TCP: cubic registered
<6>[    6.466488] Initializing XFRM netlink socket
<6>[    6.470903] NET: Registered protocol family 10
<6>[    6.475785] NET: Registered protocol family 17
<6>[    6.480302] 9pnet: Installing 9P2000 support
<7>[    6.484947] 
<7>[    6.484947] printing PIC contents
<7>[    6.489829] ... PIC  IMR: ffff
<7>[    6.492941] ... PIC  IRR: 0c88
<7>[    6.496067] ... PIC  ISR: 0000
<7>[    6.499190] ... PIC ELCR: 0c88
<7>[    6.502339] printing local APIC contents on CPU#0/0:
<6>[    6.507366] ... APIC ID:      00000000 (0)
<6>[    6.511522] ... APIC VERSION: 01060015
<7>[    6.515333] ... APIC TASKPRI: 00000000 (00)
<7>[    6.519575] ... APIC PROCPRI: 00000000
<7>[    6.523387] ... APIC LDR: 01000000
<7>[    6.526850] ... APIC DFR: ffffffff
<7>[    6.530313] ... APIC SPIV: 000001ff
<7>[    6.533854] ... APIC ISR field:
<4>[    6.537051] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    6.544566] ... APIC TMR field:
<4>[    6.547763] 0000000002000008000800020002000400060002000000000004000000000000
<7>[    6.555278] ... APIC IRR field:
<4>[    6.558473] 0000000000000000000000000000000000000000000000000000000000008000
<7>[    6.565992] ... APIC ESR: 00000000
<7>[    6.569454] ... APIC ICR: 000400f6
<7>[    6.572917] ... APIC ICR2: 02000000
<7>[    6.576460] ... APIC LVTT: 000400ef
<7>[    6.580010] ... APIC LVTPC: 00000400
<7>[    6.583646] ... APIC LVT0: 00010700
<7>[    6.587189] ... APIC LVT1: 00000400
<7>[    6.590740] ... APIC LVTERR: 000000fe
<7>[    6.594464] ... APIC TMICT: 00000000
<7>[    6.598100] ... APIC TMCCT: 00000000
<7>[    6.601737] ... APIC TDCR: 00000000
<4>[    6.605286] 
<7>[    6.606837] number of MP IRQ sources: 15.
<6>[    6.607316] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    6.607317] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    6.607589] hub 1-1:1.0: USB hub found
<6>[    6.607690] hub 1-1:1.0: 6 ports detected
<7>[    6.632770] number of IO-APIC #0 registers: 24.
<6>[    6.637364] testing the IO APIC.......................
<7>[    6.642569] IO APIC #0......
<7>[    6.645522] .... register #00: 00000000
<7>[    6.649419] .......    : physical APIC id: 00
<7>[    6.653836] .......    : Delivery Type: 0
<7>[    6.657906] .......    : LTS          : 0
<7>[    6.661977] .... register #01: 00170020
<7>[    6.665880] .......     : max redirection entries: 17
<7>[    6.671005] .......     : PRQ implemented: 0
<7>[    6.675353] .......     : IO APIC version: 20
<7>[    6.679788] .... IRQ redirection table:
<4>[    6.683705] 1    0    0   0   0    0    0    00
<4>[    6.688311] 0    0    0   0   0    1    1    31
<4>[    6.692917] 0    0    0   0   0    1    1    30
<4>[    6.697525] 0    0    0   0   0    1    1    33
<4>[    6.702131] 0    0    0   0   0    1    1    34
<4>[    6.706739] 0    0    0   0   0    1    1    35
<6>[    6.710426] usb 2-1: new high-speed USB device number 2 using ehci-pci
<4>[    6.717932] 0    0    0   0   0    1    1    36
<4>[    6.722533] 0    0    0   0   0    1    1    37
<4>[    6.727142] 0    0    0   0   0    1    1    38
<4>[    6.731756] 0    1    0   0   0    1    1    39
<4>[    6.736364] 0    0    0   0   0    1    1    3A
<4>[    6.740978] 0    0    0   0   0    1    1    3B
<4>[    6.745588] 0    0    0   0   0    1    1    3C
<4>[    6.750201] 0    0    0   0   0    1    1    3D
<4>[    6.754806] 0    0    0   0   0    1    1    3E
<4>[    6.759415] 0    0    0   0   0    1    1    3F
<4>[    6.764021] 1    1    0   1   0    1    1    51
<4>[    6.768635] 1    1    0   1   0    1    1    61
<4>[    6.773243] 1    1    0   1   0    1    1    B1
<4>[    6.777848] 1    0    0   0   0    0    0    00
<4>[    6.782456] 1    0    0   0   0    0    0    00
<4>[    6.787063] 1    1    0   1   0    1    1    D1
<4>[    6.791671] 1    0    0   0   0    0    0    00
<4>[    6.796285] 0    1    0   1   0    1    1    41
<7>[    6.800888] IRQ to pin mappings:
<7>[    6.804197] IRQ0 -> 0:2
<7>[    6.806852] IRQ1 -> 0:1
<7>[    6.809487] IRQ3 -> 0:3
<7>[    6.812125] IRQ4 -> 0:4
<7>[    6.814749] IRQ5 -> 0:5
<7>[    6.817377] IRQ6 -> 0:6
<7>[    6.820032] IRQ7 -> 0:7
<7>[    6.822680] IRQ8 -> 0:8
<6>[    6.824634] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    6.824636] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    6.824903] hub 2-1:1.0: USB hub found
<6>[    6.825007] hub 2-1:1.0: 8 ports detected
<4>[    6.846909] 
<7>[    6.849193] IRQ9 -> 0:9
<7>[    6.851846] IRQ10 -> 0:10
<7>[    6.854670] IRQ11 -> 0:11
<7>[    6.857478] IRQ12 -> 0:12
<7>[    6.860292] IRQ13 -> 0:13
<7>[    6.863121] IRQ14 -> 0:14
<7>[    6.865945] IRQ15 -> 0:15
<7>[    6.868766] IRQ16 -> 0:16
<7>[    6.871580] IRQ17 -> 0:17
<7>[    6.874391] IRQ18 -> 0:18
<7>[    6.877201] IRQ21 -> 0:21
<7>[    6.880024] IRQ23 -> 0:23
<6>[    6.882848] .................................... done.
<5>[    6.888534] Loading compiled-in X.509 certificates
<5>[    6.894859] Loaded X.509 cert 'Magrathea: Glacier signing key: 06d2b99720c6afedf80e78490b4986f86ef0912e'
<6>[    6.904464] registered taskstats version 1
<5>[    6.911582] Key type trusted registered
<5>[    6.918411] Key type encrypted registered
<6>[    6.925156] IMA: No TPM chip found, activating TPM-bypass!
<6>[    6.931333] rtc_cmos 00:04: setting system clock to 2014-10-08 05:48:01 UTC (1412747281)
<4>[    6.939872] r8169 0000:05:00.0: Direct firmware load failed with error -2
<4>[    6.946739] r8169 0000:05:00.0: Falling back to user helper
<6>[    7.100335] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
<6>[    7.266405] usb 2-1.3: New USB device found, idVendor=04d9, idProduct=1702
<6>[    7.273368] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    7.280784] usb 2-1.3: Product: USB Keyboard
<6>[    7.285135] usb 2-1.3: Manufacturer:  
<6>[    7.288985] Switched to clocksource tsc
<6>[    7.311690] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:04D9:1702.0001/input/input5
<6>[    7.323557] hid-generic 0003:04D9:1702.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1.3/input0
<6>[    7.377005] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/0003:04D9:1702.0002/input/input6
<6>[    7.388874] hid-generic 0003:04D9:1702.0002: input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-1.3/input1
<6>[    7.422175] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.2/0003:04D9:1702.0003/input/input7
<6>[    7.434156] hid-generic 0003:04D9:1702.0003: input,hidraw2: USB HID v1.10 Mouse [  USB Keyboard] on usb-0000:00:1d.0-1.3/input2
<4>[   66.983082] r8169 0000:05:00.0 eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-2)
<6>[   67.004726] r8169 0000:05:00.0 eth0: link down
<6>[   67.004784] r8169 0000:05:00.0 eth0: link down
<6>[   67.013788] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[   69.866317] r8169 0000:05:00.0 eth0: link up
<6>[   69.870753] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   69.881508] Sending DHCP requests ..., OK
<4>[   75.836619] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.171
<6>[   75.844597] IP-Config: Complete:
<6>[   75.847900]      device=eth0, hwaddr=20:cf:30:f4:b6:f7, ipaddr=192.168.1.171, mask=255.255.255.0, gw=192.168.1.1
<6>[   75.858167]      host=snb-drag, domain=lkp.intel.com, nis-domain=(none)
<6>[   75.864859]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   75.871598]      nameserver0=192.168.1.1
<7>[   75.875915] PM: Hibernation image not present or could not be loaded.
<6>[   75.883668] Freeing unused kernel memory: 1788K (ffffffff81d91000 - ffffffff81f50000)
<6>[   76.032214] wmi: Mapper loaded
<6>[   76.043633] [drm] Initialized drm 1.1.0 20060810
<6>[   76.053879] input: PC Speaker as /devices/platform/pcspkr/input/input8
<6>[   76.077467] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<7>[   76.083525] libata version 3.00 loaded.
<7>[   76.091279] ata_piix 0000:00:1f.2: version 2.13
<7>[   76.095928] pata_via 0000:03:00.0: version 0.3.4
<7>[   76.095975] IOAPIC[0]: Set routing entry (0-20 -> 0x92 -> IRQ 20 Mode:1 Active:1 Dest:15)
<6>[   76.095983] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
<3>[   76.115326] Error: Driver 'pcspkr' is already registered, aborting...
<6>[   76.121859] scsi0 : pata_via
<6>[   76.125668] scsi1 : pata_via
<6>[   76.125695] parport_pc 00:02: reported by Plug and Play ACPI
<6>[   76.125751] parport0: PC-style at 0x378, irq 5 [PCSPP]
<6>[   76.140165] ata1: PATA max UDMA/133 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 16
<6>[   76.147370] ata2: PATA max UDMA/133 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 16
<6>[   76.157614] asus_wmi: ASUS WMI generic driver loaded
<6>[   76.164549] asus_wmi: Initialization: 0x0
<6>[   76.168648] asus_wmi: BIOS WMI version: 0.9
<6>[   76.172951] asus_wmi: SFUN value: 0x0
<6>[   76.176966] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input9
<6>[   76.185344] asus_wmi: Backlight controlled by ACPI video driver
<6>[   76.247741] scsi2 : ata_piix
<6>[   76.251061] scsi3 : ata_piix
<6>[   76.254106] ata3: SATA max UDMA/133 cmd 0xf110 ctl 0xf100 bmdma 0xf0d0 irq 20
<6>[   76.261321] ata4: SATA max UDMA/133 cmd 0xf0f0 ctl 0xf0e0 bmdma 0xf0d8 irq 20
<6>[   76.268648] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
<6>[   76.425390] scsi4 : ata_piix
<6>[   76.428706] scsi5 : ata_piix
<6>[   76.431751] ata5: SATA max UDMA/133 cmd 0xf0b0 ctl 0xf0a0 bmdma 0xf070 irq 20
<6>[   76.438958] ata6: SATA max UDMA/133 cmd 0xf090 ctl 0xf080 bmdma 0xf078 irq 20
<6>[   76.447634] [drm] Memory usable by graphics device = 2048M
<7>[   76.497981] i915 0000:00:02.0: irq 52 for MSI/MSI-X
<6>[   76.502929] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[   76.509606] [drm] Driver supports precise vblank timestamp query.
<6>[   76.515812] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<6>[   76.530079] [drm] Wrong MCH_SSKPD value: 0x17050407
<6>[   76.535023] [drm] This can cause pipe underruns and display issues.
<6>[   76.541349] [drm] Please upgrade your BIOS to fix this.
<4>[   76.546656] ------------[ cut here ]------------
<4>[   76.551339] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
<4>[   76.566126] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   76.591030] CPU: 2 PID: 254 Comm: modprobe Not tainted 3.14.0-g9a952a0 #1
<4>[   76.597879] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   76.607100]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
<4>[   76.614804]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000001 ffff8801bd312400
<4>[   76.622520]  ffff880099d99800 ffff8801bd46ce28 ffffffffa0247a00 ffff8801bd4c5860
<4>[   76.630237] Call Trace:
<4>[   76.632755]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   76.637955]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   76.644016]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   76.649912]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
<4>[   76.659293]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   76.668765]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   76.677208]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   76.683364]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   76.689606]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   76.695853]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   76.703060]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   76.709568]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   76.715894]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   76.722139]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   76.728289]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   76.733917]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   76.739807]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   76.745610]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   76.751680]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   76.757316]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<6>[   76.761145] ata5: SATA link down (SStatus 0 SControl 310)
<4>[   76.768581]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   76.774297]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   76.779753]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   76.785467]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   76.790663]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   76.796292]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   76.801489]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   76.807638]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   76.813707]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   76.818908]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   76.824626]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   76.830341]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   76.835971]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   76.841597]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   76.847140]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   76.852855]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   76.858915] ---[ end trace decc4f53056ad5c3 ]---
<3>[   76.897652] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   76.905913] Raw EDID:
<3>[   76.908250]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.914060]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.919884]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.925692]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.931500]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.937318]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.943122]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   76.949407]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.967478] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   76.975744] Raw EDID:
<3>[   76.978079]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.983880]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.989682]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   76.995484]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.001286]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.007104]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.012910]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   77.018726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.036765] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   77.045026] Raw EDID:
<3>[   77.047362]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.053163]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.058966]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.064767]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.070580]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.076398]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.082208]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   77.088028]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.106059] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   77.114319] Raw EDID:
<3>[   77.116656]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.122466]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.128268]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.134069]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.139872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.145691]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   77.151492]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   77.157311]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<4>[   77.163116] i915 0000:00:02.0: VGA-1: Ignoring invalid EDID block 1.
<4>[   77.279310] ata4.00: failed to resume link (SControl 0)
<4>[   77.344038] ------------[ cut here ]------------
<4>[   77.348727] WARNING: CPU: 0 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
<4>[   77.360107] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   77.385366] CPU: 0 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   77.393201] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   77.402432]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
<4>[   77.410225]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff880099f9e900
<4>[   77.418018]  0000000000000300 0000000000000001 ffffffffa004d300 ffff8801bd4c57f8
<4>[   77.425785] Call Trace:
<4>[   77.428291]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   77.433504]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   77.439593]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   77.445510]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
<4>[   77.452031]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
<4>[   77.457168] ata6: failed to resume link (SControl 0)
<4>[   77.463657]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
<6>[   77.468529] ata6: SATA link down (SStatus 4 SControl 0)
<4>[   77.478352]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   77.487842]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   77.496305]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   77.502486]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   77.508753]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   77.515016]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   77.522241]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   77.528763]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   77.535108]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   77.541372]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   77.547539]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   77.553184]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   77.559092]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   77.564920]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   77.571008]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   77.576652]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   77.579080] ata3.01: failed to resume link (SControl 0)
<4>[   77.587755]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   77.593494]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   77.598968]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   77.604701]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   77.609914]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   77.615567]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   77.620781]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   77.626958]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   77.633043]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   77.638264]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   77.643998]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   77.649742]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   77.655398]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   77.661046]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   77.666607]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   77.672338]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   77.678418] ---[ end trace decc4f53056ad5c4 ]---
<4>[   77.683140] ------------[ cut here ]------------
<4>[   77.687843] WARNING: CPU: 1 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
<4>[   77.699227] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   77.724114] CPU: 1 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   77.731936] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<6>[   77.732049] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[   77.732059] ata3.01: SATA link down (SStatus 0 SControl 0)
<6>[   77.735594] ata3.00: ATA-8: ST3750528AS, CC38, max UDMA/133
<6>[   77.735595] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
<6>[   77.741555] ata3.00: configured for UDMA/133
<5>[   77.741701] scsi 2:0:0:0: Direct-Access     ATA      ST3750528AS      CC38 PQ: 0 ANSI: 5
<4>[   77.778238]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
<4>[   77.785941]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8800a4fb0200
<4>[   77.793655]  0000000000000300 0000000000000002 ffffffffa004d640 ffff8801bd4c57f8
<4>[   77.801353] Call Trace:
<4>[   77.803859]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   77.809064]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   77.815126]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   77.821016]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
<4>[   77.827521]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
<4>[   77.834108]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
<4>[   77.843494]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   77.852967]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   77.861403]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   77.867566]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   77.873808]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   77.880054]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   77.887260]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   77.893776]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   77.900112]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   77.906361]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   77.912508]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<6>[   77.913804] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
<4>[   77.924373]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   77.930260]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   77.936080]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   77.942157]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   77.947804]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   77.953622]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   77.959355]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   77.964828]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   77.970560]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   77.975774]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   77.981419]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   77.986633]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   77.992792]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   77.998868]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.004089]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   78.009822]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   78.015555]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   78.021201]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   78.026846]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   78.032407]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   78.038138]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   78.044218] ---[ end trace decc4f53056ad5c5 ]---
<4>[   78.048966] ------------[ cut here ]------------
<4>[   78.053694] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
<4>[   78.065091] Modules linked in: eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   78.090070] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   78.097900] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   78.107130]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
<4>[   78.115328]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8801bd46cf00
<4>[   78.123051]  0000000000000300 0000000000000003 ffffffffa004d710 ffff8801bd4c57f8
<4>[   78.130777] Call Trace:
<4>[   78.133292]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   78.138495]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   78.144569]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   78.150475]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
<4>[   78.156981]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
<4>[   78.163582]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
<4>[   78.172970]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   78.182452]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   78.190900]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   78.197070]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   78.203321]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   78.209585]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   78.216790]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   78.223303]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   78.229639]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   78.235895]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   78.242053]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   78.247688]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   78.253578]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   78.259388]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   78.265449]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   78.271086]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   78.276888]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   78.282612]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   78.288068]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   78.290469] ata4.01: failed to resume link (SControl 0)
<4>[   78.299075]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<6>[   78.301850] ata4.00: SATA link down (SStatus 4 SControl 0)
<6>[   78.301872] ata4.01: SATA link down (SStatus 0 SControl 0)
<4>[   78.315365]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   78.321008]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.326215]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   78.332372]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   78.338450]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.343661]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   78.349394]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   78.355145]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   78.360791]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   78.366417]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   78.371960]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   78.377676]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   78.383737] ---[ end trace decc4f53056ad5c6 ]---
<4>[   78.388414] ------------[ cut here ]------------
<4>[   78.393096] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
<4>[   78.404484] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   78.430505] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   78.438324] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   78.447530]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
<4>[   78.455226]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8801bd46cb00
<4>[   78.462926]  0000000000000300 0000000000000004 ffffffffa004db20 ffff8801bd4c57f8
<4>[   78.470631] Call Trace:
<4>[   78.473137]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   78.478331]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   78.484395]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   78.490286]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
<4>[   78.496789]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
<4>[   78.503377]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
<4>[   78.512762]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   78.522237]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   78.530679]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   78.536835]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   78.543078]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   78.549325]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   78.556530]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   78.563037]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   78.569365]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   78.575621]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   78.581769]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   78.587396]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   78.593285]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   78.599089]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   78.605149]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   78.610796]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   78.616598]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   78.622311]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   78.627769]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   78.633483]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.638678]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   78.644306]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.649503]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   78.655654]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   78.661720]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.666924]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   78.672642]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   78.678357]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   78.683984]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   78.689613]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   78.695157]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   78.700871]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   78.706932] ---[ end trace decc4f53056ad5c7 ]---
<4>[   78.711608] ------------[ cut here ]------------
<4>[   78.716289] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x49/0x50 [drm]()
<4>[   78.727663] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   78.753674] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   78.761495] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   78.770700]  0000000000000009 ffff8801bd4c57b0 ffffffff8183d636 0000000000000000
<4>[   78.778396]  ffff8801bd4c57e8 ffffffff8106bd7d ffff8801bd312400 ffff8801bd46c300
<4>[   78.786095]  0000000000000300 0000000000000005 ffffffffa004dcc0 ffff8801bd4c57f8
<4>[   78.793784] Call Trace:
<4>[   78.796290]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   78.801485]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   78.807546]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   78.813439]  [<ffffffffa0038cb9>] drm_mode_probed_add+0x49/0x50 [drm]
<4>[   78.819942]  [<ffffffffa003af25>] drm_add_modes_noedid+0xa5/0xd0 [drm]
<4>[   78.826529]  [<ffffffffa01a9358>] drm_helper_probe_single_connector_modes+0x388/0x3a0 [drm_kms_helper]
<4>[   78.835917]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   78.845398]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   78.853840]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   78.860003]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   78.866246]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   78.872492]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   78.879698]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   78.886205]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   78.892533]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   78.898781]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   78.904933]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   78.910567]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   78.916456]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   78.922259]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   78.928335]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   78.933983]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   78.939800]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   78.945534]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   78.951006]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   78.956738]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.961953]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   78.967598]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.972812]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   78.978970]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   78.985045]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   78.990267]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   78.995991]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   79.001725]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   79.007372]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   79.013016]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   79.018576]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   79.024310]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   79.030386] ---[ end trace decc4f53056ad5c8 ]---
<4>[   79.035071] ------------[ cut here ]------------
<4>[   79.039770] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_modes.c:1030 drm_mode_connector_list_update+0xe9/0xf0 [drm]()
<4>[   79.052199] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   79.078489] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   79.086310] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   79.096008]  0000000000000009 ffff8801bd4c57d0 ffffffff8183d636 0000000000000000
<4>[   79.103773]  ffff8801bd4c5808 ffffffff8106bd7d ffff8801bd312448 ffff8801bd312400
<4>[   79.111534]  ffff880099d99800 0000000000000005 ffff8801bd312400 ffff8801bd4c5818
<4>[   79.119282] Call Trace:
<4>[   79.121788]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   79.127001]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   79.133081]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   79.138989]  [<ffffffffa0039489>] drm_mode_connector_list_update+0xe9/0xf0 [drm]
<4>[   79.146478]  [<ffffffffa01a90e3>] drm_helper_probe_single_connector_modes+0x113/0x3a0 [drm_kms_helper]
<4>[   79.155871]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   79.165353]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   79.173807]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   79.179977]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   79.186239]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   79.192502]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   79.199716]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   79.206231]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   79.212569]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   79.218824]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   79.224990]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   79.230636]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   79.236542]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   79.242362]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   79.248441]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   79.254086]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   79.259904]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   79.265638]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   79.271102]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   79.276836]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.282047]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   79.287694]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.292906]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   79.299074]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   79.305152]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.310371]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   79.316097]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   79.321828]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   79.327476]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   79.333120]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   79.338681]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   79.344414]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   79.350492] ---[ end trace decc4f53056ad5c9 ]---
<4>[   79.355187] ------------[ cut here ]------------
<4>[   79.359881] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
<4>[   79.374677] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   79.400957] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   79.408777] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   79.417999]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
<4>[   79.425758]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000002 ffff8801bd310800
<4>[   79.433500]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02490f0 ffff8801bd4c5860
<4>[   79.441241] Call Trace:
<4>[   79.443744]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   79.448957]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   79.455037]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   79.460943]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
<4>[   79.470340]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   79.479821]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   79.488272]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   79.494445]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   79.500704]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   79.506968]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   79.514183]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   79.520691]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   79.527033]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   79.533292]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   79.539457]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   79.545103]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   79.551008]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   79.556829]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   79.562906]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   79.568554]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   79.574373]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   79.580096]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   79.585560]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   79.591292]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.596504]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   79.602151]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.607365]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   79.613541]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   79.619616]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.624837]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   79.630571]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   79.636305]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   79.641952]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   79.647596]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   79.653155]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   79.658888]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   79.664966] ---[ end trace decc4f53056ad5ca ]---
<4>[   79.669901] ------------[ cut here ]------------
<4>[   79.674614] WARNING: CPU: 0 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
<4>[   79.689425] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   79.715591] CPU: 0 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   79.723428] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   79.732659]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
<4>[   79.740381]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000003 ffff8801bd328400
<4>[   79.748105]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02487e0 ffff8801bd4c5860
<4>[   79.755819] Call Trace:
<4>[   79.758337]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   79.763547]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   79.769618]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   79.775525]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
<4>[   79.784912]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   79.794395]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   79.802851]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   79.809022]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   79.815279]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   79.821535]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   79.828750]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   79.835256]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   79.841598]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   79.847849]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   79.854011]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   79.859641]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   79.865536]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   79.871339]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   79.877409]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   79.883038]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   79.888847]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   79.894563]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   79.900027]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   79.905744]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.910947]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   79.916576]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.921780]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   79.927934]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   79.934019]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   79.939235]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   79.944969]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   79.950701]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   79.956347]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   79.961994]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   79.967563]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   79.973294]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   79.979374] ---[ end trace decc4f53056ad5cb ]---
<4>[   79.984123] ------------[ cut here ]------------
<4>[   79.988847] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
<4>[   80.003658] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   80.029822] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   80.037652] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   80.047363]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
<4>[   80.055092]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000004 ffff8801bd329000
<4>[   80.062813]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02490f0 ffff8801bd4c5860
<4>[   80.070538] Call Trace:
<4>[   80.073053]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   80.078259]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   80.084336]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   80.090235]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
<4>[   80.099638]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   80.109112]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   80.117568]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   80.123741]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   80.129998]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   80.136256]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   80.143476]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   80.149981]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   80.156317]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   80.162565]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   80.168730]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   80.174366]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   80.180264]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   80.186067]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   80.192135]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   80.197764]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   80.203575]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   80.209290]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   80.214753]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   80.220468]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   80.225673]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   80.231302]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   80.236506]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   80.242657]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   80.248724]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   80.253927]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   80.259645]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   80.265359]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   80.270988]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   80.276616]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   80.282160]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   80.287875]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   80.293934] ---[ end trace decc4f53056ad5cc ]---
<4>[   80.298778] ------------[ cut here ]------------
<4>[   80.303471] WARNING: CPU: 2 PID: 254 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]()
<4>[   80.318251] Modules linked in: pata_acpi(+) eeepc_wmi asus_wmi snd_hda_intel(+) sparse_keymap snd_hda_codec rfkill snd_hwdep i915(+) parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[   80.344261] CPU: 2 PID: 254 Comm: modprobe Tainted: G        W    3.14.0-g9a952a0 #1
<4>[   80.352083] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[   80.361286]  0000000000000009 ffff8801bd4c5818 ffffffff8183d636 0000000000000000
<4>[   80.368983]  ffff8801bd4c5850 ffffffff8106bd7d 0000000000000005 ffff8801bd329c00
<4>[   80.376683]  ffff880099d99800 ffff8801bd46ce28 ffffffffa02487e0 ffff8801bd4c5860
<4>[   80.384390] Call Trace:
<4>[   80.386894]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[   80.392089]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[   80.398151]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[   80.404040]  [<ffffffffa01a9341>] drm_helper_probe_single_connector_modes+0x371/0x3a0 [drm_kms_helper]
<4>[   80.413418]  [<ffffffffa01ac030>] drm_fb_helper_probe_connector_modes+0x50/0x70 [drm_kms_helper]
<4>[   80.422892]  [<ffffffffa01acdfd>] drm_fb_helper_initial_config+0x18d/0x4f0 [drm_kms_helper]
<4>[   80.431326]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[   80.437482]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   80.443725]  [<ffffffffa01f4ca2>] ? gen6_write32+0x72/0x100 [i915]
<4>[   80.449970]  [<ffffffffa021837f>] intel_fbdev_initial_config+0x1f/0x30 [i915]
<4>[   80.457176]  [<ffffffffa0238503>] i915_driver_load+0xf03/0xf50 [i915]
<4>[   80.463676]  [<ffffffffa002d4dd>] drm_dev_register+0xad/0x100 [drm]
<4>[   80.470002]  [<ffffffffa003010d>] drm_get_pci_dev+0x9d/0x210 [drm]
<4>[   80.476249]  [<ffffffffa01b77eb>] i915_pci_probe+0x3b/0x60 [i915]
<4>[   80.482399]  [<ffffffff8141d625>] local_pci_probe+0x45/0xa0
<4>[   80.488029]  [<ffffffff8141e815>] ? pci_match_device+0xc5/0xd0
<4>[   80.493916]  [<ffffffff8141e931>] pci_device_probe+0xd1/0x120
<4>[   80.499719]  [<ffffffff814eecdd>] driver_probe_device+0x8d/0x3c0
<4>[   80.505779]  [<ffffffff814ef0db>] __driver_attach+0x8b/0x90
<4>[   80.511407]  [<ffffffff814ef050>] ? __device_attach+0x40/0x40
<4>[   80.517211]  [<ffffffff814ecb2b>] bus_for_each_dev+0x6b/0xb0
<4>[   80.522925]  [<ffffffff814ee73e>] driver_attach+0x1e/0x20
<4>[   80.528381]  [<ffffffff814ee300>] bus_add_driver+0x180/0x250
<4>[   80.534096]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   80.539291]  [<ffffffff814ef754>] driver_register+0x64/0xf0
<4>[   80.544919]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   80.550117]  [<ffffffff8141cebc>] __pci_register_driver+0x4c/0x50
<4>[   80.556268]  [<ffffffffa003039a>] drm_pci_init+0x11a/0x130 [drm]
<4>[   80.562335]  [<ffffffffa0129000>] ? 0xffffffffa0128fff
<4>[   80.567536]  [<ffffffffa012906a>] i915_init+0x6a/0x6c [i915]
<4>[   80.573254]  [<ffffffff81002142>] do_one_initcall+0xd2/0x1a0
<4>[   80.578969]  [<ffffffff8105b473>] ? set_memory_nx+0x43/0x50
<4>[   80.584597]  [<ffffffff810eee1b>] load_module+0x133b/0x1990
<4>[   80.590225]  [<ffffffff810ea5c0>] ? store_uevent+0x40/0x40
<4>[   80.595770]  [<ffffffff810ef606>] SyS_finit_module+0x86/0xb0
<4>[   80.601485]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[   80.607562] ---[ end trace decc4f53056ad5cd ]---
<6>[   80.612876] fbcon: inteldrmfb (fb0) is primary device
<6>[   80.783288] Console: switching to colour frame buffer device 128x48
<6>[   80.797470] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[   80.803683] i915 0000:00:02.0: registered panic notifier
<6>[   80.816202] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
<6>[   80.823428] acpi device:38: registered as cooling_device4
<6>[   80.828962] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
<6>[   80.838251] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
<7>[   80.845591] IOAPIC[0]: Set routing entry (0-22 -> 0xb2 -> IRQ 22 Mode:1 Active:1 Dest:15)
<7>[   80.854053] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
<5>[   80.876881] sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
<5>[   80.884549] sd 2:0:0:0: [sda] Write Protect is off
<7>[   80.889373] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   80.894472] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[   80.913195] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
<6>[   80.922766] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
<6>[   80.932496] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
<6>[   80.942075] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
<6>[   80.951627] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
<6>[   80.961541] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>[   80.971160] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>[   80.979936] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>[   80.989024] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>[   81.014699]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
<5>[   81.023318] sd 2:0:0:0: [sda] Attached SCSI disk
<5>[   81.033834] sd 2:0:0:0: Attached scsi generic sg0 type 0
<5>[   81.444727] random: nonblocking pool is initialized
<6>[   81.823091] xor: automatically using best checksumming function:
<6>[   81.839474]    avx       : 13408.000 MB/sec
<4>[   81.864461] raid6: sse2x1    4761 MB/s
<4>[   81.885438] raid6: sse2x2    7339 MB/s
<4>[   81.906420] raid6: sse2x4    9308 MB/s
<4>[   81.911031] raid6: using algorithm sse2x4 (9308 MB/s)
<4>[   81.916939] raid6: using ssse3x2 recovery algorithm
<6>[   81.938751] bio: create slab <bio-1> at 1
<6>[   81.943891] Btrfs loaded
<6>[   81.949466] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 5 transid 6 /dev/sda10
<6>[   81.959697] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 4 transid 6 /dev/sda9
<6>[   81.969883] BTRFS: device fsid 900723f3-0511-4215-979c-2146631700ac devid 1 transid 230 /dev/sda6
<6>[   89.554796] ipmi message handler version 39.2
<6>[   89.562632] IPMI Watchdog: driver initialized
<3>[   89.597483] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.610031] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.635285] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.647514] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.672433] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.684477] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.709188] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.721087] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.745644] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.757437] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.781991] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.793677] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.818004] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.829620] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.853896] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.865461] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.889746] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.901289] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.925547] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.937073] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.961377] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.972845] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.997007] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.008461] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.032607] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.044042] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.068167] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.079556] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.103658] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   90.115006] bmc-watchdog:1620 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<4>[  168.267652] ------------[ cut here ]------------
<4>[  168.272307] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  168.285680] Device suspended
<4>[  168.288574] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  168.330063] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  168.337705] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  168.346822]  0000000000000009 ffff880099ef7ad0 ffffffff8183d636 ffff880099ef7b18
<4>[  168.354281]  ffff880099ef7b08 ffffffff8106bd7d ffff8801bd314000 00000000000e1100
<4>[  168.361747]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef7b68
<4>[  168.369213] Call Trace:
<4>[  168.371661]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  168.376794]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  168.382794]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  168.388542]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  168.396370]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  168.402291]  [<ffffffffa01c2db5>] ? intel_display_power_enabled+0xc5/0xe0 [i915]
<4>[  168.409683]  [<ffffffffa021b6ff>] intel_crt_get_hw_state+0x5f/0xa0 [i915]
<4>[  168.416469]  [<ffffffffa02098c8>] intel_connector_get_hw_state+0x28/0x30 [i915]
<4>[  168.423779]  [<ffffffffa020d5d7>] intel_modeset_check_state+0x67/0x7b0 [i915]
<4>[  168.430913]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  168.437008]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  168.443878]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  168.449454]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  168.456672]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  168.463018]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  168.468758]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  168.475362]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  168.480842]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  168.486411]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  168.491461]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  168.497460] ---[ end trace decc4f53056ad5ce ]---
<4>[  168.502078] ------------[ cut here ]------------
<4>[  168.506699] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:4614 intel_modeset_check_state+0x6eb/0x7b0 [i915]()
<4>[  168.519715] wrong connector dpms state
<4>[  168.523462] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  168.564828] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  168.572468] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  168.581585]  0000000000000009 ffff880099ef7b70 ffffffff8183d636 ffff880099ef7bb8
<4>[  168.589033]  ffff880099ef7ba8 ffffffff8106bd7d ffff880099d99af8 ffff880099d99800
<4>[  168.596486]  ffff8801bd312400 ffff880192c49d00 ffff880099d99800 ffff880099ef7c08
<4>[  168.603944] Call Trace:
<4>[  168.606388]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  168.611522]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  168.617524]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  168.623272]  [<ffffffffa020dc5b>] intel_modeset_check_state+0x6eb/0x7b0 [i915]
<4>[  168.630492]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  168.636579]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  168.643441]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  168.649013]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  168.656226]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  168.662576]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  168.668315]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  168.674917]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  168.680390]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  168.685959]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  168.691008]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  168.697006] ---[ end trace decc4f53056ad5cf ]---
<4>[  168.701613] ------------[ cut here ]------------
<4>[  168.706228] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:4616 intel_modeset_check_state+0x6cc/0x7b0 [i915]()
<4>[  168.719235] active connector not linked to encoder
<4>[  168.724015] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  168.765373] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  168.773011] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  168.782129]  0000000000000009 ffff880099ef7b70 ffffffff8183d636 ffff880099ef7bb8
<4>[  168.789574]  ffff880099ef7ba8 ffffffff8106bd7d ffff880099d99af8 ffff880099d99800
<4>[  168.797021]  ffff8801bd312400 ffff880192c49d00 ffff880099d99800 ffff880099ef7c08
<4>[  168.804468] Call Trace:
<4>[  168.806912]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  168.812040]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  168.818041]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  168.823789]  [<ffffffffa020dc3c>] intel_modeset_check_state+0x6cc/0x7b0 [i915]
<4>[  168.831002]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  168.837088]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  168.843950]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  168.849521]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  168.856734]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  168.863090]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  168.868832]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  168.875434]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  168.880907]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  168.886475]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  168.891524]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  168.897524] ---[ end trace decc4f53056ad5d0 ]---
<4>[  168.902130] ------------[ cut here ]------------
<4>[  168.906747] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:4618 intel_modeset_check_state+0x6ad/0x7b0 [i915]()
<4>[  168.919753] encoder->connectors_active not set
<4>[  168.924187] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  168.965562] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  168.973208] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  168.982327]  0000000000000009 ffff880099ef7b70 ffffffff8183d636 ffff880099ef7bb8
<4>[  168.989779]  ffff880099ef7ba8 ffffffff8106bd7d ffff880099d99af8 ffff880099d99800
<4>[  168.997228]  ffff8801bd312400 ffff880192c49d00 ffff880099d99800 ffff880099ef7c08
<4>[  169.004676] Call Trace:
<4>[  169.007120]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  169.012254]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  169.018255]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  169.024005]  [<ffffffffa020dc1d>] intel_modeset_check_state+0x6ad/0x7b0 [i915]
<4>[  169.031228]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  169.037322]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  169.044181]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  169.049753]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  169.056968]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  169.063313]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  169.069055]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  169.075658]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  169.081139]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  169.086706]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  169.091747]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  169.097739] ---[ end trace decc4f53056ad5d1 ]---
<4>[  169.102346] ------------[ cut here ]------------
<4>[  169.106959] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:4621 intel_modeset_check_state+0x68e/0x7b0 [i915]()
<4>[  169.119970] encoder not enabled
<4>[  169.123114] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  169.164487] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  169.172132] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  169.181241]  0000000000000009 ffff880099ef7b70 ffffffff8183d636 ffff880099ef7bb8
<4>[  169.188686]  ffff880099ef7ba8 ffffffff8106bd7d ffff880099d99af8 ffff880099d99800
<4>[  169.196133]  ffff8801bd312400 ffff880192c49d00 ffff880099d99800 ffff880099ef7c08
<4>[  169.203581] Call Trace:
<4>[  169.206025]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  169.211161]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  169.217162]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  169.222910]  [<ffffffffa021b6ce>] ? intel_crt_get_hw_state+0x2e/0xa0 [i915]
<4>[  169.229866]  [<ffffffffa020dbfe>] intel_modeset_check_state+0x68e/0x7b0 [i915]
<4>[  169.237086]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  169.243173]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  169.250033]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  169.255605]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  169.262818]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  169.269164]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  169.274906]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  169.281513]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  169.286994]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  169.292558]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  169.297598]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  169.303590] ---[ end trace decc4f53056ad5d2 ]---
<4>[  169.308197] ------------[ cut here ]------------
<4>[  169.312813] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:4622 intel_modeset_check_state+0x671/0x7b0 [i915]()
<4>[  169.325820] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  169.367191] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  169.374832] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  169.383941]  0000000000000009 ffff880099ef7bc0 ffffffff8183d636 0000000000000000
<4>[  169.391388]  ffff880099ef7bf8 ffffffff8106bd7d ffff880099d99af8 ffff880099d99800
<4>[  169.398834]  ffff8801bd312400 0000000000000000 ffff880099d99800 ffff880099ef7c08
<4>[  169.406282] Call Trace:
<4>[  169.408726]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  169.413861]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  169.419862]  [<ffffffff8106be5a>] warn_slowpath_null+0x1a/0x20
<4>[  169.425708]  [<ffffffffa020dbe1>] intel_modeset_check_state+0x671/0x7b0 [i915]
<4>[  169.432929]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  169.439025]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  169.445896]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  169.451468]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  169.458679]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  169.465025]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  169.470768]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  169.477372]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  169.482853]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  169.488421]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  169.493470]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  169.499469] ---[ end trace decc4f53056ad5d3 ]---
<4>[  169.504087] ------------[ cut here ]------------
<4>[  169.508706] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  169.522062] Device suspended
<4>[  169.524944] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  169.566324] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  169.573965] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  169.583081]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  169.590528]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 0000000000070008
<4>[  169.597984]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  169.605429] Call Trace:
<4>[  169.607874]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  169.613001]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  169.619002]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  169.624744]  [<ffffffff813eefda>] ? number+0x2ea/0x310
<4>[  169.630491]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  169.638309]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  169.644219]  [<ffffffff810cab8c>] ? vprintk_emit+0x1bc/0x560
<4>[  169.649880]  [<ffffffffa01ff467>] ironlake_get_pipe_config+0x57/0x2e0 [i915]
<4>[  169.656919]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  169.663356]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  169.668584]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  169.675797]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  169.681885]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  169.688746]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  169.694317]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  169.701530]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  169.707877]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  169.713618]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  169.720222]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  169.725703]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  169.731272]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  169.736319]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  169.742311] ---[ end trace decc4f53056ad5d4 ]---
<4>[  169.746921] ------------[ cut here ]------------
<4>[  169.751542] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  169.764895] Device suspended
<4>[  169.767770] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  169.809126] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  169.816764] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  169.825875]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  169.833319]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 00000000000f0008
<4>[  169.840768]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  169.848214] Call Trace:
<4>[  169.850658]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  169.855786]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  169.861787]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  169.867528]  [<ffffffff813eefda>] ? number+0x2ea/0x310
<4>[  169.873274]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  169.881094]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  169.887002]  [<ffffffff810cab8c>] ? vprintk_emit+0x1bc/0x560
<4>[  169.892653]  [<ffffffffa01ff4d2>] ironlake_get_pipe_config+0xc2/0x2e0 [i915]
<4>[  169.899694]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  169.906123]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  169.911350]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  169.918564]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  169.924651]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  169.931512]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  169.937084]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  169.944298]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  169.950645]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  169.956384]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  169.962989]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  169.968478]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  169.974038]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  169.979087]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  169.985088] ---[ end trace decc4f53056ad5d5 ]---
<4>[  169.989705] ------------[ cut here ]------------
<4>[  169.994326] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  170.007680] Device suspended
<4>[  170.010561] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  170.051935] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  170.059576] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  170.068695]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  170.076147]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 00000000000f000c
<4>[  170.083594]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  170.091050] Call Trace:
<4>[  170.093495]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  170.098620]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  170.104614]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  170.110354]  [<ffffffff813eefda>] ? number+0x2ea/0x310
<4>[  170.116092]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  170.123913]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  170.129820]  [<ffffffff810cab8c>] ? vprintk_emit+0x1bc/0x560
<4>[  170.135474]  [<ffffffffa01ff57a>] ironlake_get_pipe_config+0x16a/0x2e0 [i915]
<4>[  170.142607]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  170.149039]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  170.154269]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  170.161486]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  170.167582]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  170.174444]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  170.180015]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  170.187228]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  170.193574]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  170.199318]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  170.205919]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  170.211394]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  170.216960]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  170.222002]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  170.228000] ---[ end trace decc4f53056ad5d6 ]---
<4>[  170.232611] ------------[ cut here ]------------
<4>[  170.237230] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  170.250586] Device suspended
<4>[  170.253469] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  170.294850] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  170.302489] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  170.311600]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  170.319054]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060040
<4>[  170.326500]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  170.333946] Call Trace:
<4>[  170.336392]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  170.341528]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  170.347529]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  170.353270]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  170.359190]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  170.367009]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  170.372923]  [<ffffffffa01fce16>] intel_cpu_transcoder_get_m_n+0xf6/0x190 [i915]
<4>[  170.381003]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  170.388130]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  170.394557]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  170.399787]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  170.407007]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  170.413095]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  170.419955]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  170.425520]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  170.432733]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  170.439077]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  170.444819]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  170.451424]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  170.456904]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  170.462463]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  170.467503]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  170.473496] ---[ end trace decc4f53056ad5d7 ]---
<4>[  170.478104] ------------[ cut here ]------------
<4>[  170.482725] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  170.496080] Device suspended
<4>[  170.498963] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  170.540321] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  170.547966] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  170.557075]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  170.564521]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060044
<4>[  170.571969]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  170.579415] Call Trace:
<4>[  170.581860]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  170.586995]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  170.592996]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  170.598730]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  170.604648]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  170.612467]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  170.618382]  [<ffffffffa01fce3a>] intel_cpu_transcoder_get_m_n+0x11a/0x190 [i915]
<4>[  170.626548]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  170.633674]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  170.640104]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  170.645333]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  170.652544]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  170.658632]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  170.665493]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  170.671065]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  170.678278]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  170.684625]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  170.690367]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  170.696971]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  170.702451]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  170.708018]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  170.713060]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  170.719060] ---[ end trace decc4f53056ad5d8 ]---
<4>[  170.723669] ------------[ cut here ]------------
<4>[  170.728287] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  170.741644] Device suspended
<4>[  170.744527] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  170.785882] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  170.793521] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  170.802632]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  170.810087]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060030
<4>[  170.817532]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  170.824979] Call Trace:
<4>[  170.827424]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  170.832551]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  170.838551]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  170.844294]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  170.850212]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  170.858032]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  170.863947]  [<ffffffffa01fce5e>] intel_cpu_transcoder_get_m_n+0x13e/0x190 [i915]
<4>[  170.872112]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  170.879239]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  170.885668]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  170.890896]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  170.898110]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  170.904197]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  170.911058]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  170.916631]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  170.923841]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  170.930189]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  170.935931]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  170.942534]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  170.948014]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  170.953575]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  170.958623]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  170.964622] ---[ end trace decc4f53056ad5d9 ]---
<4>[  170.969231] ------------[ cut here ]------------
<4>[  170.973852] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  170.987208] Device suspended
<4>[  170.990091] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  171.031463] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  171.039104] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  171.048222]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  171.055666]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060034
<4>[  171.063113]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  171.070561] Call Trace:
<4>[  171.073006]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  171.078140]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  171.084132]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  171.089866]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  171.095787]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  171.103604]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  171.109519]  [<ffffffffa01fce87>] intel_cpu_transcoder_get_m_n+0x167/0x190 [i915]
<4>[  171.117687]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  171.124812]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  171.131240]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  171.136468]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  171.143681]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  171.149769]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  171.156630]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  171.162202]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  171.169414]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  171.175760]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  171.181502]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  171.188108]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  171.193586]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  171.199147]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  171.204196]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  171.210196] ---[ end trace decc4f53056ad5da ]---
<4>[  171.214804] ------------[ cut here ]------------
<4>[  171.219425] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  171.232780] Device suspended
<4>[  171.235663] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  171.277018] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  171.284657] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  171.293767]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  171.301214]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060030
<4>[  171.308662]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  171.316108] Call Trace:
<4>[  171.318553]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  171.323686]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  171.329678]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  171.335412]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  171.341332]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  171.349152]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  171.355066]  [<ffffffffa01fcdd1>] intel_cpu_transcoder_get_m_n+0xb1/0x190 [i915]
<4>[  171.363144]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  171.370272]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  171.376700]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  171.381928]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  171.389141]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  171.395228]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  171.402090]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  171.407662]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  171.414875]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  171.421222]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  171.426964]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  171.433566]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  171.439047]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  171.444606]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  171.449647]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  171.455648] ---[ end trace decc4f53056ad5db ]---
<4>[  171.460264] ------------[ cut here ]------------
<4>[  171.464884] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  171.478240] Device suspended
<4>[  171.481123] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  171.522481] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  171.530127] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  171.539245]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  171.546690]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 00000000000c7000
<4>[  171.554137]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  171.561584] Call Trace:
<4>[  171.564029]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  171.569163]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  171.575156]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  171.580895]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  171.588713]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  171.594629]  [<ffffffffa01ff673>] ironlake_get_pipe_config+0x263/0x2e0 [i915]
<4>[  171.601756]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  171.608183]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  171.613403]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  171.620615]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  171.626703]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  171.633565]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  171.639136]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  171.646350]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  171.652695]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  171.658438]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  171.665041]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  171.670514]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  171.676082]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  171.681131]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  171.687131] ---[ end trace decc4f53056ad5dc ]---
<4>[  171.691740] ------------[ cut here ]------------
<4>[  171.696361] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  171.709715] Device suspended
<4>[  171.712598] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  171.753953] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  171.761594] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  171.770712]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  171.778166]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 00000000000c6018
<4>[  171.785611]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  171.793059] Call Trace:
<4>[  171.795503]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  171.800631]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  171.806632]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  171.812373]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  171.818292]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  171.826112]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  171.832026]  [<ffffffffa01f9346>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  171.839067]  [<ffffffffa01ff5ef>] ironlake_get_pipe_config+0x1df/0x2e0 [i915]
<4>[  171.846194]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  171.852620]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  171.857844]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  171.865064]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  171.871151]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  171.878013]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  171.883585]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  171.890798]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  171.897143]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  171.902884]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  171.909488]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  171.914969]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  171.920530]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  171.925576]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  171.931568] ---[ end trace decc4f53056ad5dd ]---
<4>[  171.936176] ------------[ cut here ]------------
<4>[  171.940797] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  171.954152] Device suspended
<4>[  171.957028] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  171.998392] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  172.006031] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.015141]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  172.022595]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 00000000000c6048
<4>[  172.030053]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  172.037506] Call Trace:
<4>[  172.039951]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  172.045086]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.051087]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.056827]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  172.062741]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  172.070559]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  172.076475]  [<ffffffffa01f936e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  172.083513]  [<ffffffffa01ff5ef>] ironlake_get_pipe_config+0x1df/0x2e0 [i915]
<4>[  172.090639]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  172.097068]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  172.102297]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  172.109509]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.115598]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  172.122459]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  172.128030]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  172.135242]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  172.141597]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  172.147343]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  172.153948]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.159426]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  172.164993]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  172.170042]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  172.176042] ---[ end trace decc4f53056ad5de ]---
<4>[  172.180650] ------------[ cut here ]------------
<4>[  172.185271] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  172.198627] Device suspended
<4>[  172.201517] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  172.242875] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  172.250512] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.259622]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  172.267076]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 00000000000c604c
<4>[  172.274523]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  172.281975] Call Trace:
<4>[  172.284425]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  172.289558]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.295551]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.301285]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  172.307204]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  172.315023]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  172.320938]  [<ffffffffa01f9394>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  172.327979]  [<ffffffffa01ff5ef>] ironlake_get_pipe_config+0x1df/0x2e0 [i915]
<4>[  172.335105]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  172.341532]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  172.346761]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  172.353974]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.360061]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  172.366922]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  172.372496]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  172.379707]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  172.386054]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  172.391796]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  172.398399]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.403881]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  172.409448]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  172.414488]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  172.420480] ---[ end trace decc4f53056ad5df ]---
<4>[  172.425089] ------------[ cut here ]------------
<4>[  172.429710] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  172.443063] Device suspended
<4>[  172.445939] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  172.487294] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  172.494941] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.504051]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  172.511497]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060000
<4>[  172.518945]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  172.526390] Call Trace:
<4>[  172.528837]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  172.533970]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.539963]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.545696]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  172.551615]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  172.559435]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  172.565350]  [<ffffffffa01fcb43>] intel_get_pipe_timings+0x43/0x220 [i915]
<4>[  172.572910]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  172.579948]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  172.586378]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  172.591608]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  172.598828]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.604915]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  172.611776]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  172.617348]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  172.624561]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  172.630908]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  172.636649]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  172.643255]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.648735]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  172.654303]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  172.659351]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  172.665351] ---[ end trace decc4f53056ad5e0 ]---
<4>[  172.669960] ------------[ cut here ]------------
<4>[  172.674579] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  172.687934] Device suspended
<4>[  172.690809] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  172.732166] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  172.739804] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.748917]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  172.756396]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060004
<4>[  172.763840]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  172.771296] Call Trace:
<4>[  172.773743]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  172.778876]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.784877]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.790618]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  172.796530]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  172.804349]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  172.810265]  [<ffffffffa01fcb7e>] intel_get_pipe_timings+0x7e/0x220 [i915]
<4>[  172.817822]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  172.824863]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  172.831293]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  172.836522]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  172.843742]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.849829]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  172.856691]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  172.862262]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  172.869474]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  172.875821]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  172.881565]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  172.888166]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.893639]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  172.899198]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  172.904240]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  172.910240] ---[ end trace decc4f53056ad5e1 ]---
<4>[  172.914856] ------------[ cut here ]------------
<4>[  172.919478] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  172.932833] Device suspended
<4>[  172.935716] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  172.977081] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  172.984718] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.993828]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  173.001276]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060008
<4>[  173.008720]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  173.016170] Call Trace:
<4>[  173.018613]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  173.023748]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.029751]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.035493]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  173.041411]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  173.049228]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  173.055144]  [<ffffffffa01fcbb9>] intel_get_pipe_timings+0xb9/0x220 [i915]
<4>[  173.062704]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  173.069744]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  173.076171]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  173.081393]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  173.088603]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.094691]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  173.101553]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  173.107125]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  173.114338]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  173.120684]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  173.126426]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  173.133029]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.138510]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  173.144071]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  173.149120]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  173.155123] ---[ end trace decc4f53056ad5e2 ]---
<4>[  173.159737] ------------[ cut here ]------------
<4>[  173.164356] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  173.177712] Device suspended
<4>[  173.180595] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  173.221951] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  173.229589] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.238698]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  173.246144]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 000000000006000c
<4>[  173.253592]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  173.261039] Call Trace:
<4>[  173.263485]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  173.268619]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.274619]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.280353]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  173.286275]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  173.294103]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  173.300025]  [<ffffffffa01fcbf4>] intel_get_pipe_timings+0xf4/0x220 [i915]
<4>[  173.307583]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  173.314624]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  173.321051]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  173.326272]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  173.333485]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.339572]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  173.346432]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  173.351996]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  173.359208]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  173.365556]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  173.371298]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  173.377902]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.383382]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  173.388950]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  173.393999]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  173.399998] ---[ end trace decc4f53056ad5e3 ]---
<4>[  173.404607] ------------[ cut here ]------------
<4>[  173.409228] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  173.422583] Device suspended
<4>[  173.425456] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  173.466823] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  173.474462] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.483579]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  173.491034]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060010
<4>[  173.498479]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  173.505927] Call Trace:
<4>[  173.508372]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  173.513507]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.519508]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.525241]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  173.531162]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  173.538979]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  173.544895]  [<ffffffffa01fcc2f>] intel_get_pipe_timings+0x12f/0x220 [i915]
<4>[  173.552541]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  173.559582]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  173.566018]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  173.571247]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  173.578459]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.584546]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  173.591407]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  173.596981]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  173.604192]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  173.610539]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  173.616281]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  173.622886]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.628366]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  173.633935]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  173.638982]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  173.644990] ---[ end trace decc4f53056ad5e4 ]---
<4>[  173.649599] ------------[ cut here ]------------
<4>[  173.654220] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  173.667584] Device suspended
<4>[  173.670466] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  173.711822] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  173.719463] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.728581]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  173.736034]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000060014
<4>[  173.743481]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  173.750928] Call Trace:
<4>[  173.753373]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  173.758508]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.764509]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.770259]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  173.776180]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  173.783999]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  173.789912]  [<ffffffffa01fcc6a>] intel_get_pipe_timings+0x16a/0x220 [i915]
<4>[  173.797559]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  173.804600]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  173.811027]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  173.816258]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  173.823478]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.829566]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  173.836427]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  173.841999]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  173.849211]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  173.855558]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  173.861300]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  173.867902]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.873375]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  173.878944]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  173.883992]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  173.889992] ---[ end trace decc4f53056ad5e5 ]---
<4>[  173.894601] ------------[ cut here ]------------
<4>[  173.899222] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  173.912577] Device suspended
<4>[  173.915460] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  173.956816] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  173.964455] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.973572]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  173.981018]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000070008
<4>[  173.988467]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  173.995913] Call Trace:
<4>[  173.998358]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  174.003493]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.009494]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.015234]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.021154]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  174.028976]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  174.034892]  [<ffffffffa01fcca5>] intel_get_pipe_timings+0x1a5/0x220 [i915]
<4>[  174.042544]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  174.049582]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  174.056012]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  174.061240]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  174.068462]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.074549]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  174.081409]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  174.086973]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  174.094186]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  174.100532]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  174.106274]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  174.112879]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.118358]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  174.123920]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  174.128966]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  174.134959] ---[ end trace decc4f53056ad5e6 ]---
<4>[  174.139577] ------------[ cut here ]------------
<4>[  174.144198] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  174.157562] Device suspended
<4>[  174.160442] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  174.201799] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  174.209438] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.218549]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  174.226002]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 000000000006001c
<4>[  174.233449]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  174.240895] Call Trace:
<4>[  174.243342]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  174.248475]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.254467]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.260201]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.266120]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  174.273940]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  174.279858]  [<ffffffffa01fcce9>] intel_get_pipe_timings+0x1e9/0x220 [i915]
<4>[  174.287512]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  174.294558]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  174.300985]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  174.306206]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  174.313419]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.319506]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  174.326367]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  174.331940]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  174.339153]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  174.345498]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  174.351240]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  174.357844]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.363326]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  174.368903]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  174.373949]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  174.379942] ---[ end trace decc4f53056ad5e7 ]---
<4>[  174.384550] ------------[ cut here ]------------
<4>[  174.389172] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  174.402526] Device suspended
<4>[  174.405409] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  174.446765] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  174.454404] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.463513]  0000000000000009 ffff880099ef7818 ffffffff8183d636 ffff880099ef7860
<4>[  174.470962]  ffff880099ef7850 ffffffff8106bd7d ffff8801bd314000 0000000000068080
<4>[  174.478414]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b0
<4>[  174.485861] Call Trace:
<4>[  174.488307]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  174.493441]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.499434]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.505177]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.511095]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  174.518915]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  174.524828]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[  174.530917]  [<ffffffffa01fda8b>] ironlake_get_pfit_config+0x3b/0xe0 [i915]
<4>[  174.538563]  [<ffffffffa01ff507>] ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  174.545604]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  174.552031]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  174.557251]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  174.564463]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.570559]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  174.577421]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  174.582992]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  174.590206]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  174.596552]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  174.602296]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  174.608899]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.614380]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  174.619946]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  174.624988]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  174.630988] ---[ end trace decc4f53056ad5e8 ]---
<4>[  174.635605] ------------[ cut here ]------------
<4>[  174.640227] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  174.653579] Device suspended
<4>[  174.656454] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  174.697811] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  174.705450] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.714558]  0000000000000009 ffff880099ef7818 ffffffff8183d636 ffff880099ef7860
<4>[  174.722004]  ffff880099ef7850 ffffffff8106bd7d ffff8801bd314000 0000000000068070
<4>[  174.729453]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b0
<4>[  174.736899] Call Trace:
<4>[  174.739344]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  174.744480]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.750478]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.756211]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.762122]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  174.769941]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  174.775856]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[  174.781946]  [<ffffffffa01fdac7>] ironlake_get_pfit_config+0x77/0xe0 [i915]
<4>[  174.789590]  [<ffffffffa01ff507>] ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  174.796631]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  174.803060]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  174.808288]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  174.815501]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.821587]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  174.828448]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  174.834012]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  174.841226]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  174.847572]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  174.853314]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  174.859918]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.865398]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  174.870966]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  174.876005]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  174.881998] ---[ end trace decc4f53056ad5e9 ]---
<4>[  174.886607] ------------[ cut here ]------------
<4>[  174.891226] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  174.904583] Device suspended
<4>[  174.907466] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  174.948820] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  174.956461] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.965578]  0000000000000009 ffff880099ef7818 ffffffff8183d636 ffff880099ef7860
<4>[  174.973024]  ffff880099ef7850 ffffffff8106bd7d ffff8801bd314000 0000000000068074
<4>[  174.980470]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b0
<4>[  174.987928] Call Trace:
<4>[  174.990372]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  174.995506]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.001507]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.007248]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  175.013160]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  175.020978]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  175.026895]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[  175.032984]  [<ffffffffa01fdaed>] ironlake_get_pfit_config+0x9d/0xe0 [i915]
<4>[  175.040636]  [<ffffffffa01ff507>] ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  175.047678]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  175.054105]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  175.059333]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  175.066554]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.072642]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  175.079503]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  175.085076]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  175.092287]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  175.098634]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  175.104376]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  175.110981]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.116461]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  175.122030]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  175.127077]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  175.133069] ---[ end trace decc4f53056ad5ea ]---
<4>[  175.137677] ------------[ cut here ]------------
<4>[  175.142299] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:9802 check_crtc_state+0x377/0x390 [i915]()
<4>[  175.154527] crtc active state doesn't match with hw state (expected 0, found 1)
<4>[  175.161818] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  175.203175] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  175.210814] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.219932]  0000000000000009 ffff880099ef78c8 ffffffff8183d636 ffff880099ef7910
<4>[  175.227377]  ffff880099ef7900 ffffffff8106bd7d ffff880099ef7990 ffff880099d99800
<4>[  175.234824]  ffff8801a52eb000 ffff880099d99b28 ffff880099d99b20 ffff880099ef7960
<4>[  175.242280] Call Trace:
<4>[  175.244726]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  175.249860]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.255861]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.261609]  [<ffffffffa01ff507>] ? ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  175.268822]  [<ffffffffa01feea7>] check_crtc_state+0x377/0x390 [i915]
<4>[  175.275249]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  175.280478]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  175.287690]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.293778]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  175.300639]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  175.306210]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  175.313423]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  175.319769]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  175.325511]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  175.332114]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.337587]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  175.343148]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  175.348196]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  175.354196] ---[ end trace decc4f53056ad5eb ]---
<3>[  175.358803] [drm:intel_pipe_config_compare] *ERROR* mismatch in fdi_lanes (expected 1, found 8)
<4>[  175.367480] ------------[ cut here ]------------
<4>[  175.372102] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:9806 check_crtc_state+0x2cd/0x390 [i915]()
<4>[  175.384331] pipe state doesn't match!
<4>[  175.387984] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  175.429342] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  175.436980] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.446090]  0000000000000009 ffff880099ef78c8 ffffffff8183d636 ffff880099ef7910
<4>[  175.453536]  ffff880099ef7900 ffffffff8106bd7d ffff880099ef7990 ffff880099d99800
<4>[  175.460982]  ffff8801a52eb000 ffff880099d99b28 ffff8801a52eb6d8 ffff880099ef7960
<4>[  175.468430] Call Trace:
<4>[  175.470875]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  175.476008]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.482001]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.487748]  [<ffffffffa01fd438>] ? intel_pipe_config_compare+0x538/0xae0 [i915]
<4>[  175.495134]  [<ffffffffa01fedfd>] check_crtc_state+0x2cd/0x390 [i915]
<4>[  175.501564]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  175.506793]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  175.514005]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.520092]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  175.526952]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  175.532516]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  175.539729]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  175.546075]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  175.551816]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  175.558420]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.563901]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  175.569471]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  175.574519]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  175.580519] ---[ end trace decc4f53056ad5ec ]---
<4>[  175.585126] ------------[ cut here ]------------
<4>[  175.589739] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  175.603094] Device suspended
<4>[  175.605967] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  175.647323] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  175.654965] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.664081]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  175.671527]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 0000000000071008
<4>[  175.678977]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  175.686421] Call Trace:
<4>[  175.688868]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  175.694002]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.700003]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.705749]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  175.713569]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  175.719483]  [<ffffffffa01feb1e>] ? intel_dump_pipe_config+0x35e/0x370 [i915]
<4>[  175.727304]  [<ffffffffa01ff467>] ironlake_get_pipe_config+0x57/0x2e0 [i915]
<4>[  175.734341]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  175.740772]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  175.745999]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  175.753212]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.759299]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  175.766161]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  175.771732]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  175.778947]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  175.785291]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  175.791034]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  175.797637]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.803117]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  175.808679]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  175.813727]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  175.819727] ---[ end trace decc4f53056ad5ed ]---
<4>[  175.824344] ------------[ cut here ]------------
<4>[  175.828963] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  175.842318] Device suspended
<4>[  175.845194] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  175.886549] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  175.894190] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.903306]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  175.910754]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 00000000000f1008
<4>[  175.918199]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  175.925646] Call Trace:
<4>[  175.928091]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  175.933227]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.939227]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.944966]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  175.952784]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  175.958700]  [<ffffffffa01feb1e>] ? intel_dump_pipe_config+0x35e/0x370 [i915]
<4>[  175.966518]  [<ffffffffa01ff4d2>] ironlake_get_pipe_config+0xc2/0x2e0 [i915]
<4>[  175.973559]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  175.979988]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  175.985217]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  175.992429]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.998517]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  176.005378]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  176.010949]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  176.018163]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  176.024509]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  176.030251]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  176.036855]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.042335]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  176.047902]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  176.052943]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  176.058943] ---[ end trace decc4f53056ad5ee ]---
<4>[  176.063552] ------------[ cut here ]------------
<4>[  176.068172] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  176.081527] Device suspended
<4>[  176.084400] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  176.125759] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  176.133397] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.142507]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  176.149960]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 00000000000f100c
<4>[  176.157408]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  176.164853] Call Trace:
<4>[  176.167299]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  176.172426]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.178425]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.184165]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  176.191985]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  176.197898]  [<ffffffffa01feb1e>] ? intel_dump_pipe_config+0x35e/0x370 [i915]
<4>[  176.205719]  [<ffffffffa01ff57a>] ironlake_get_pipe_config+0x16a/0x2e0 [i915]
<4>[  176.212845]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  176.219272]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  176.224492]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  176.231705]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.237792]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  176.244653]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  176.250217]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  176.257430]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  176.263777]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  176.269520]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  176.276124]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.281602]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  176.287164]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  176.292210]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  176.298202] ---[ end trace decc4f53056ad5ef ]---
<4>[  176.302811] ------------[ cut here ]------------
<4>[  176.307433] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  176.320787] Device suspended
<4>[  176.323668] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  176.365027] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  176.372666] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.381783]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  176.389229]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061040
<4>[  176.396676]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  176.404123] Call Trace:
<4>[  176.406568]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  176.411703]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.417704]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.423445]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.429365]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  176.437185]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  176.443098]  [<ffffffffa01fce16>] intel_cpu_transcoder_get_m_n+0xf6/0x190 [i915]
<4>[  176.451178]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  176.458305]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  176.464734]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  176.469963]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  176.477183]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.483271]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  176.490132]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  176.495704]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  176.502916]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  176.509263]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  176.515005]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  176.521609]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.527089]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  176.532658]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  176.537705]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  176.543697] ---[ end trace decc4f53056ad5f0 ]---
<4>[  176.548306] ------------[ cut here ]------------
<4>[  176.552927] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  176.566282] Device suspended
<4>[  176.569164] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  176.610522] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  176.618160] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.627278]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  176.634724]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061044
<4>[  176.642172]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  176.649618] Call Trace:
<4>[  176.652063]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  176.657198]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.663199]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.668940]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.674860]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  176.682679]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  176.688595]  [<ffffffffa01fce3a>] intel_cpu_transcoder_get_m_n+0x11a/0x190 [i915]
<4>[  176.696758]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  176.703885]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  176.710315]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  176.715543]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  176.722756]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.728844]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  176.735703]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  176.741267]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  176.748480]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  176.754827]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  176.760569]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  176.767173]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.772654]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  176.778222]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  176.783270]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  176.789270] ---[ end trace decc4f53056ad5f1 ]---
<4>[  176.793887] ------------[ cut here ]------------
<4>[  176.798508] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  176.811863] Device suspended
<4>[  176.814746] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  176.856104] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  176.863750] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.872859]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  176.880305]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061030
<4>[  176.887751]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  176.895198] Call Trace:
<4>[  176.897643]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  176.902779]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.908780]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.914520]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.920441]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  176.928259]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  176.934174]  [<ffffffffa01fce5e>] intel_cpu_transcoder_get_m_n+0x13e/0x190 [i915]
<4>[  176.942340]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  176.949467]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  176.955894]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  176.961115]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  176.968329]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.974414]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  176.981276]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  176.986848]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  176.994061]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  177.000407]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  177.006149]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  177.012753]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.018234]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  177.023794]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  177.028843]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  177.034846] ---[ end trace decc4f53056ad5f2 ]---
<4>[  177.039460] ------------[ cut here ]------------
<4>[  177.044081] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  177.057435] Device suspended
<4>[  177.060310] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  177.101665] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  177.109306] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.118422]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  177.125870]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061034
<4>[  177.133316]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  177.140765] Call Trace:
<4>[  177.143207]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  177.148334]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.154335]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.160076]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.165995]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  177.173816]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  177.179730]  [<ffffffffa01fce87>] intel_cpu_transcoder_get_m_n+0x167/0x190 [i915]
<4>[  177.187896]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  177.195022]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  177.201451]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  177.206680]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  177.213891]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.219979]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  177.226840]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  177.232413]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  177.239626]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  177.245972]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  177.251714]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  177.258317]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.263798]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  177.269367]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  177.274414]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  177.280406] ---[ end trace decc4f53056ad5f3 ]---
<4>[  177.285017] ------------[ cut here ]------------
<4>[  177.289639] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  177.302999] Device suspended
<4>[  177.305872] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  177.347229] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  177.354868] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.363978]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  177.371423]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061030
<4>[  177.378871]  ffff880099ef7bc4 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  177.386317] Call Trace:
<4>[  177.388762]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  177.393889]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.399891]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.405632]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.411552]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  177.419369]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  177.425284]  [<ffffffffa01fcdd1>] intel_cpu_transcoder_get_m_n+0xb1/0x190 [i915]
<4>[  177.433364]  [<ffffffffa01ff5ab>] ironlake_get_pipe_config+0x19b/0x2e0 [i915]
<4>[  177.440490]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  177.446919]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  177.452147]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  177.459360]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.465447]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  177.472309]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  177.477880]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  177.485096]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  177.491476]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  177.497238]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  177.503870]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.509355]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  177.514956]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  177.520011]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  177.526019] ---[ end trace decc4f53056ad5f4 ]---
<4>[  177.530641] ------------[ cut here ]------------
<4>[  177.535265] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  177.548633] Device suspended
<4>[  177.551528] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  177.592931] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  177.600581] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.609700]  0000000000000009 ffff880099ef7850 ffffffff8183d636 ffff880099ef7898
<4>[  177.617160]  ffff880099ef7888 ffffffff8106bd7d ffff8801bd314000 00000000000c7000
<4>[  177.624609]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78e8
<4>[  177.632054] Call Trace:
<4>[  177.634508]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  177.639642]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.645634]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.651373]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  177.659193]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  177.665107]  [<ffffffffa01ff673>] ironlake_get_pipe_config+0x263/0x2e0 [i915]
<4>[  177.672242]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  177.678671]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  177.683891]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  177.691111]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.697199]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  177.704060]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  177.709633]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  177.716845]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  177.723201]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  177.728950]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  177.735553]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.741026]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  177.746586]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  177.751633]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  177.757625] ---[ end trace decc4f53056ad5f5 ]---
<4>[  177.762234] ------------[ cut here ]------------
<4>[  177.766846] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  177.780202] Device suspended
<4>[  177.783085] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  177.824466] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  177.832118] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.841241]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  177.848688]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 00000000000c6018
<4>[  177.856135]  ffff880099ef7990 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  177.863582] Call Trace:
<4>[  177.866025]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  177.871153]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.877161]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.882894]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.888815]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  177.896641]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  177.902557]  [<ffffffffa01f9346>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  177.909597]  [<ffffffffa01ff5ef>] ironlake_get_pipe_config+0x1df/0x2e0 [i915]
<4>[  177.916724]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  177.923161]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  177.928388]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  177.935609]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.941698]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  177.948560]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  177.954131]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  177.961353]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  177.967698]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  177.973449]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  177.980054]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.985543]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  177.991102]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  177.996141]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  178.002133] ---[ end trace decc4f53056ad5f6 ]---
<4>[  178.006743] ------------[ cut here ]------------
<4>[  178.011362] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  178.024728] Device suspended
<4>[  178.027614] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  178.068993] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  178.076639] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.085749]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  178.093204]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 00000000000c6048
<4>[  178.100652]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  178.108105] Call Trace:
<4>[  178.110552]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  178.115695]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.121703]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.127445]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.133357]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  178.141174]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  178.147091]  [<ffffffffa01f936e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  178.154129]  [<ffffffffa01ff5ef>] ironlake_get_pipe_config+0x1df/0x2e0 [i915]
<4>[  178.161265]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  178.167693]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  178.172913]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  178.180127]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.186222]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  178.193085]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  178.198655]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  178.205869]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  178.212224]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  178.217966]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  178.224579]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.230058]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  178.235618]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  178.240658]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  178.246659] ---[ end trace decc4f53056ad5f7 ]---
<4>[  178.251267] ------------[ cut here ]------------
<4>[  178.255887] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  178.269241] Device suspended
<4>[  178.272116] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  178.313492] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  178.321137] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.330247]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  178.337695]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 00000000000c604c
<4>[  178.345148]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  178.352595] Call Trace:
<4>[  178.355041]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  178.360175]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.366167]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.371901]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.377819]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  178.385648]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  178.391573]  [<ffffffffa01f9394>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  178.398611]  [<ffffffffa01ff5ef>] ironlake_get_pipe_config+0x1df/0x2e0 [i915]
<4>[  178.405739]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  178.412167]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  178.417397]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  178.424618]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.430713]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  178.437575]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  178.443147]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  178.450359]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  178.456706]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  178.462454]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  178.469069]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.474549]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  178.480109]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  178.485156]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  178.491156] ---[ end trace decc4f53056ad5f8 ]---
<4>[  178.495766] ------------[ cut here ]------------
<4>[  178.500387] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  178.513767] Device suspended
<4>[  178.516642] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  178.558008] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  178.565646] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.574763]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  178.582217]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061000
<4>[  178.589673]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  178.597129] Call Trace:
<4>[  178.599582]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  178.604708]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.610711]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.616452]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.622381]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  178.630198]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  178.636114]  [<ffffffffa01fcb43>] intel_get_pipe_timings+0x43/0x220 [i915]
<4>[  178.643673]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  178.650723]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  178.657150]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  178.662371]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  178.669583]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.675679]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  178.682539]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  178.688104]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  178.695317]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  178.701672]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  178.707428]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  178.714034]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.719516]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  178.725083]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  178.730123]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  178.736115] ---[ end trace decc4f53056ad5f9 ]---
<4>[  178.740724] ------------[ cut here ]------------
<4>[  178.745343] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  178.758698] Device suspended
<4>[  178.761572] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  178.802947] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  178.810594] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.819704]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  178.827149]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061004
<4>[  178.834596]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  178.842053] Call Trace:
<4>[  178.844498]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  178.849633]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.855642]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.861383]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.867312]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  178.875140]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  178.881063]  [<ffffffffa01fcb7e>] intel_get_pipe_timings+0x7e/0x220 [i915]
<4>[  178.888623]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  178.895670]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  178.902100]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  178.907329]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  178.914539]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.920636]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  178.927497]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  178.933061]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  178.940282]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  178.946630]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  178.952371]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  178.958974]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.964447]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  178.970007]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  178.975045]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  178.981038] ---[ end trace decc4f53056ad5fa ]---
<4>[  178.985654] ------------[ cut here ]------------
<4>[  178.990276] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  179.003648] Device suspended
<4>[  179.006521] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  179.047915] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  179.055553] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.064661]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  179.072117]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061008
<4>[  179.079573]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  179.087019] Call Trace:
<4>[  179.089465]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  179.094599]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.100600]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.106341]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.112270]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  179.120089]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  179.126004]  [<ffffffffa01fcbb9>] intel_get_pipe_timings+0xb9/0x220 [i915]
<4>[  179.133563]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  179.140602]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  179.147030]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  179.152252]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  179.159464]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.165550]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  179.172412]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  179.177995]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  179.185215]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  179.191562]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  179.197301]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  179.203907]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.209388]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  179.214964]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  179.220004]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  179.225996] ---[ end trace decc4f53056ad5fb ]---
<4>[  179.230604] ------------[ cut here ]------------
<4>[  179.235225] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  179.248587] Device suspended
<4>[  179.251463] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  179.292871] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  179.300509] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.309618]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  179.317066]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 000000000006100c
<4>[  179.324513]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  179.331962] Call Trace:
<4>[  179.334403]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  179.339529]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.345532]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.351272]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.357201]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  179.365020]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  179.370937]  [<ffffffffa01fcbf4>] intel_get_pipe_timings+0xf4/0x220 [i915]
<4>[  179.378495]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  179.385544]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  179.391988]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  179.397209]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  179.404420]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.410509]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  179.417370]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  179.422951]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  179.430180]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  179.436526]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  179.442269]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  179.448873]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.454345]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  179.459905]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  179.464952]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  179.470946] ---[ end trace decc4f53056ad5fc ]---
<4>[  179.475570] ------------[ cut here ]------------
<4>[  179.480190] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  179.493555] Device suspended
<4>[  179.496429] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  179.537804] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  179.545441] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.554551]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  179.561997]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061010
<4>[  179.569445]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  179.576891] Call Trace:
<4>[  179.579335]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  179.584463]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.590463]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.596214]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.602134]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  179.609951]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  179.615866]  [<ffffffffa01fcc2f>] intel_get_pipe_timings+0x12f/0x220 [i915]
<4>[  179.623522]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  179.630561]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  179.637008]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  179.642236]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  179.649447]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.655544]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  179.662404]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  179.667986]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  179.675198]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  179.681544]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  179.687287]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  179.693899]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.699381]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  179.704940]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  179.709980]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  179.715973] ---[ end trace decc4f53056ad5fd ]---
<4>[  179.720588] ------------[ cut here ]------------
<4>[  179.725200] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  179.738565] Device suspended
<4>[  179.741440] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  179.782803] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  179.790443] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.799560]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  179.807006]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000061014
<4>[  179.814453]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  179.821900] Call Trace:
<4>[  179.824346]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  179.829480]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.835481]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.841230]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.847142]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  179.854962]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  179.860876]  [<ffffffffa01fcc6a>] intel_get_pipe_timings+0x16a/0x220 [i915]
<4>[  179.868523]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  179.875563]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  179.881992]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  179.887219]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  179.894442]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.900528]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  179.907388]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  179.912953]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  179.920165]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  179.926511]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  179.932262]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  179.938866]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.944356]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  179.949925]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  179.954971]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  179.960963] ---[ end trace decc4f53056ad5fe ]---
<4>[  179.965572] ------------[ cut here ]------------
<4>[  179.970192] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  179.983564] Device suspended
<4>[  179.986440] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  180.027804] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  180.035443] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.044553]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  180.051998]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 0000000000071008
<4>[  180.059454]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  180.066912] Call Trace:
<4>[  180.069363]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  180.074497]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.080492]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.086231]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.092144]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  180.099970]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  180.105885]  [<ffffffffa01fcca5>] intel_get_pipe_timings+0x1a5/0x220 [i915]
<4>[  180.113533]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  180.120573]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  180.127008]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  180.132246]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  180.139459]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.145548]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  180.152407]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  180.157971]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  180.165185]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  180.171530]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  180.177283]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  180.183896]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.189374]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  180.194932]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  180.199974]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  180.205983] ---[ end trace decc4f53056ad5ff ]---
<4>[  180.210591] ------------[ cut here ]------------
<4>[  180.215211] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  180.228593] Device suspended
<4>[  180.231466] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  180.272851] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  180.280504] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.289626]  0000000000000009 ffff880099ef7820 ffffffff8183d636 ffff880099ef7868
<4>[  180.297087]  ffff880099ef7858 ffffffff8106bd7d ffff8801bd314000 000000000006101c
<4>[  180.304552]  ffff8801bd314004 ffff8801bd314070 0000000000000001 ffff880099ef78b8
<4>[  180.311999] Call Trace:
<4>[  180.314441]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  180.319569]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.325570]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.331311]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.337223]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  180.345041]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  180.350965]  [<ffffffffa01fcce9>] intel_get_pipe_timings+0x1e9/0x220 [i915]
<4>[  180.358619]  [<ffffffffa01ff4f8>] ironlake_get_pipe_config+0xe8/0x2e0 [i915]
<4>[  180.365660]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  180.372087]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  180.377309]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  180.384519]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.390608]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  180.397477]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  180.403043]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  180.410254]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  180.416609]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  180.422350]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  180.428956]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.434435]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  180.439994]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  180.445035]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  180.451028] ---[ end trace decc4f53056ad600 ]---
<4>[  180.455644] ------------[ cut here ]------------
<4>[  180.460273] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  180.473644] Device suspended
<4>[  180.476518] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  180.517900] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  180.525542] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.534651]  0000000000000009 ffff880099ef7818 ffffffff8183d636 ffff880099ef7860
<4>[  180.542096]  ffff880099ef7850 ffffffff8106bd7d ffff8801bd314000 0000000000068880
<4>[  180.549560]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b0
<4>[  180.557017] Call Trace:
<4>[  180.559460]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  180.564586]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.570580]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.576321]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.582241]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  180.590068]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  180.595991]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[  180.602080]  [<ffffffffa01fda8b>] ironlake_get_pfit_config+0x3b/0xe0 [i915]
<4>[  180.609726]  [<ffffffffa01ff507>] ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  180.616766]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  180.623193]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  180.628415]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  180.635627]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.641723]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  180.648593]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  180.654165]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  180.661377]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  180.667723]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  180.673465]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  180.680078]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.685558]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  180.691117]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  180.696159]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  180.702159] ---[ end trace decc4f53056ad601 ]---
<4>[  180.706775] ------------[ cut here ]------------
<4>[  180.711397] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  180.724760] Device suspended
<4>[  180.727633] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  180.768992] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  180.776630] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.785739]  0000000000000009 ffff880099ef7818 ffffffff8183d636 ffff880099ef7860
<4>[  180.793185]  ffff880099ef7850 ffffffff8106bd7d ffff8801bd314000 0000000000068870
<4>[  180.800632]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b0
<4>[  180.808089] Call Trace:
<4>[  180.810532]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  180.815658]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.821649]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.827384]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.833303]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  180.841130]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  180.847045]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[  180.853133]  [<ffffffffa01fdac7>] ironlake_get_pfit_config+0x77/0xe0 [i915]
<4>[  180.860780]  [<ffffffffa01ff507>] ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  180.867829]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  180.874256]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  180.879477]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  180.886707]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.892793]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  180.899653]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  180.905217]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  180.912432]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  180.918786]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  180.924536]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  180.931141]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.936622]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  180.942188]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  180.947228]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  180.953221] ---[ end trace decc4f53056ad602 ]---
<4>[  180.957830] ------------[ cut here ]------------
<4>[  180.962449] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  180.975821] Device suspended
<4>[  180.978696] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  181.020063] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  181.027699] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.036809]  0000000000000009 ffff880099ef7818 ffffffff8183d636 ffff880099ef7860
<4>[  181.044256]  ffff880099ef7850 ffffffff8106bd7d ffff8801bd314000 0000000000068874
<4>[  181.051704]  ffff8801bd314000 ffff8801bd314070 0000000000000001 ffff880099ef78b0
<4>[  181.059150] Call Trace:
<4>[  181.061595]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  181.066729]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.072723]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.078462]  [<ffffffff8106bdec>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  181.084375]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  181.092201]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  181.098117]  [<ffffffffa01f497f>] ? gen6_read32+0x6f/0x120 [i915]
<4>[  181.104214]  [<ffffffffa01fdaed>] ironlake_get_pfit_config+0x9d/0xe0 [i915]
<4>[  181.111859]  [<ffffffffa01ff507>] ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  181.118899]  [<ffffffffa01fec82>] check_crtc_state+0x152/0x390 [i915]
<4>[  181.125327]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  181.130549]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  181.137759]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.143848]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  181.150710]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  181.156290]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  181.163512]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  181.169858]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  181.175600]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  181.182202]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.187676]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  181.193243]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  181.198284]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  181.204303] ---[ end trace decc4f53056ad603 ]---
<4>[  181.208920] ------------[ cut here ]------------
<4>[  181.213540] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:9802 check_crtc_state+0x377/0x390 [i915]()
<4>[  181.225776] crtc active state doesn't match with hw state (expected 0, found 1)
<4>[  181.233067] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  181.274450] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  181.282108] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.291228]  0000000000000009 ffff880099ef78c8 ffffffff8183d636 ffff880099ef7910
<4>[  181.298679]  ffff880099ef7900 ffffffff8106bd7d ffff880099ef7990 ffff880099d99800
<4>[  181.306133]  ffff8801a52ed000 ffff880099d99b28 ffff880099d99b20 ffff880099ef7960
<4>[  181.313581] Call Trace:
<4>[  181.316025]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  181.321161]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.327161]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.332899]  [<ffffffffa01ff507>] ? ironlake_get_pipe_config+0xf7/0x2e0 [i915]
<4>[  181.340113]  [<ffffffffa01feea7>] check_crtc_state+0x377/0x390 [i915]
<4>[  181.346541]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  181.351762]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  181.358975]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.365062]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  181.371931]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  181.377512]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  181.384725]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  181.391072]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  181.396813]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  181.403418]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.408905]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  181.414473]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  181.419514]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  181.425507] ---[ end trace decc4f53056ad604 ]---
<3>[  181.430122] [drm:intel_pipe_config_compare] *ERROR* mismatch in fdi_lanes (expected 1, found 8)
<4>[  181.438798] ------------[ cut here ]------------
<4>[  181.443412] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:9806 check_crtc_state+0x2cd/0x390 [i915]()
<4>[  181.455648] pipe state doesn't match!
<4>[  181.459304] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  181.500694] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  181.508342] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.517452]  0000000000000009 ffff880099ef78c8 ffffffff8183d636 ffff880099ef7910
<4>[  181.524898]  ffff880099ef7900 ffffffff8106bd7d ffff880099ef7990 ffff880099d99800
<4>[  181.532353]  ffff8801a52ed000 ffff880099d99b28 ffff8801a52ed6d8 ffff880099ef7960
<4>[  181.539799] Call Trace:
<4>[  181.542244]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  181.547370]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.553363]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.559102]  [<ffffffffa01fd438>] ? intel_pipe_config_compare+0x538/0xae0 [i915]
<4>[  181.566488]  [<ffffffffa01fedfd>] check_crtc_state+0x2cd/0x390 [i915]
<4>[  181.572915]  [<ffffffff813f1c43>] ? delay_tsc+0x43/0x90
<4>[  181.578136]  [<ffffffffa020d8f1>] intel_modeset_check_state+0x381/0x7b0 [i915]
<4>[  181.585349]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.591446]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  181.598313]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  181.603885]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  181.611099]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  181.617446]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  181.623188]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  181.629799]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.635271]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  181.640841]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  181.645889]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  181.651879] ---[ end trace decc4f53056ad605 ]---
<4>[  181.656496] ------------[ cut here ]------------
<4>[  181.661109] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  181.674471] Device suspended
<4>[  181.677348] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  181.718713] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  181.726351] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.735460]  0000000000000009 ffff880099ef7af0 ffffffff8183d636 ffff880099ef7b38
<4>[  181.742917]  ffff880099ef7b28 ffffffff8106bd7d ffff8801bd314000 00000000000c6014
<4>[  181.750371]  ffff880099ef7c28 ffff8801bd314070 0000000000000001 ffff880099ef7b88
<4>[  181.757818] Call Trace:
<4>[  181.760262]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  181.765397]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.771389]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.777138]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  181.784954]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  181.790870]  [<ffffffffa01f9346>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  181.797911]  [<ffffffffa020d961>] intel_modeset_check_state+0x3f1/0x7b0 [i915]
<4>[  181.805133]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.811229]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  181.818089]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  181.823654]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  181.830866]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  181.837213]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  181.842953]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  181.849568]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.855049]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  181.860625]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  181.865664]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  181.871657] ---[ end trace decc4f53056ad606 ]---
<4>[  181.876264] ------------[ cut here ]------------
<4>[  181.880886] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  181.894248] Device suspended
<4>[  181.897124] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  181.938498] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  181.946135] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.955245]  0000000000000009 ffff880099ef7af0 ffffffff8183d636 ffff880099ef7b38
<4>[  181.962693]  ffff880099ef7b28 ffffffff8106bd7d ffff8801bd314000 00000000000c6040
<4>[  181.970156]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef7b88
<4>[  181.977602] Call Trace:
<4>[  181.980048]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  181.985182]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.991183]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.996922]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  182.004749]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  182.010664]  [<ffffffffa01f936e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  182.017715]  [<ffffffffa020d961>] intel_modeset_check_state+0x3f1/0x7b0 [i915]
<4>[  182.024932]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.031043]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  182.037912]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  182.043483]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  182.050695]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  182.057040]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  182.062791]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  182.069404]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.074893]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  182.080462]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  182.085502]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  182.091503] ---[ end trace decc4f53056ad607 ]---
<4>[  182.096112] ------------[ cut here ]------------
<4>[  182.100732] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  182.114095] Device suspended
<4>[  182.116969] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  182.158334] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  182.165973] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.175085]  0000000000000009 ffff880099ef7af0 ffffffff8183d636 ffff880099ef7b38
<4>[  182.182607]  ffff880099ef7b28 ffffffff8106bd7d ffff8801bd314000 00000000000c6044
<4>[  182.190053]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef7b88
<4>[  182.197501] Call Trace:
<4>[  182.199954]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  182.205087]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.211082]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.216828]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  182.224665]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  182.230577]  [<ffffffffa01f9394>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  182.237620]  [<ffffffffa020d961>] intel_modeset_check_state+0x3f1/0x7b0 [i915]
<4>[  182.244833]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.250946]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  182.257806]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  182.263370]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  182.270592]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  182.276937]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  182.282681]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  182.289287]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.294774]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  182.300341]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  182.305382]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  182.311373] ---[ end trace decc4f53056ad608 ]---
<4>[  182.315983] ------------[ cut here ]------------
<4>[  182.320604] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:9843 intel_modeset_check_state+0x614/0x7b0 [i915]()
<4>[  182.333622] pll on state mismatch (expected 0, found 1)
<4>[  182.338872] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  182.380258] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  182.387905] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.397015]  0000000000000009 ffff880099ef7b70 ffffffff8183d636 ffff880099ef7bb8
<4>[  182.404462]  ffff880099ef7ba8 ffffffff8106bd7d ffff880099d99b58 ffff880099d99800
<4>[  182.411908]  ffff880099ef7c28 ffff8801bd314000 ffff8801bd316c90 ffff880099ef7c08
<4>[  182.419357] Call Trace:
<4>[  182.421808]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  182.426942]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.432935]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.438674]  [<ffffffffa01f9394>] ? ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  182.445887]  [<ffffffffa020db84>] intel_modeset_check_state+0x614/0x7b0 [i915]
<4>[  182.453100]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.459188]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  182.466049]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  182.471630]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  182.478843]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  182.485189]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  182.490931]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  182.497535]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.503015]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  182.508584]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  182.513622]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  182.519623] ---[ end trace decc4f53056ad609 ]---
<4>[  182.524231] ------------[ cut here ]------------
<4>[  182.528851] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  182.542215] Device suspended
<4>[  182.545090] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  182.586482] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  182.594130] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.603238]  0000000000000009 ffff880099ef7af0 ffffffff8183d636 ffff880099ef7b38
<4>[  182.610684]  ffff880099ef7b28 ffffffff8106bd7d ffff8801bd314000 00000000000c6018
<4>[  182.618139]  ffff880099ef7c28 ffff8801bd314070 0000000000000001 ffff880099ef7b88
<4>[  182.625587] Call Trace:
<4>[  182.628032]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  182.633168]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.639176]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.644915]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  182.652735]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  182.658658]  [<ffffffffa01f9346>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  182.665697]  [<ffffffffa020d961>] intel_modeset_check_state+0x3f1/0x7b0 [i915]
<4>[  182.672911]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.678998]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  182.685868]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  182.691441]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  182.698661]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  182.705008]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  182.710749]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  182.717355]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.722844]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  182.728412]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  182.733450]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  182.739444] ---[ end trace decc4f53056ad60a ]---
<4>[  182.744059] ------------[ cut here ]------------
<4>[  182.748671] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  182.762036] Device suspended
<4>[  182.764909] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  182.806284] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  182.813923] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.823033]  0000000000000009 ffff880099ef7af0 ffffffff8183d636 ffff880099ef7b38
<4>[  182.830477]  ffff880099ef7b28 ffffffff8106bd7d ffff8801bd314000 00000000000c6048
<4>[  182.837926]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef7b88
<4>[  182.845380] Call Trace:
<4>[  182.847826]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  182.852970]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.858969]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.864707]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  182.872526]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  182.878441]  [<ffffffffa01f936e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  182.885492]  [<ffffffffa020d961>] intel_modeset_check_state+0x3f1/0x7b0 [i915]
<4>[  182.892704]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.898801]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  182.905660]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  182.911226]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  182.918438]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  182.924784]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  182.930525]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  182.937139]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.942628]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  182.948195]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  182.953236]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  182.959228] ---[ end trace decc4f53056ad60b ]---
<4>[  182.963838] ------------[ cut here ]------------
<4>[  182.968457] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x38/0x40 [i915]()
<4>[  182.981821] Device suspended
<4>[  182.984695] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  183.026094] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  183.033733] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.042853]  0000000000000009 ffff880099ef7af0 ffffffff8183d636 ffff880099ef7b38
<4>[  183.050298]  ffff880099ef7b28 ffffffff8106bd7d ffff8801bd314000 00000000000c604c
<4>[  183.057746]  00000000ffffffff ffff8801bd314070 0000000000000001 ffff880099ef7b88
<4>[  183.065191] Call Trace:
<4>[  183.067635]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  183.072772]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  183.078772]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  183.084511]  [<ffffffffa01f3218>] assert_device_not_suspended+0x38/0x40 [i915]
<4>[  183.092337]  [<ffffffffa01f4942>] gen6_read32+0x32/0x120 [i915]
<4>[  183.098253]  [<ffffffffa01f9394>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  183.105294]  [<ffffffffa020d961>] intel_modeset_check_state+0x3f1/0x7b0 [i915]
<4>[  183.112506]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  183.118592]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  183.125463]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  183.131027]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  183.138257]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  183.144604]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  183.150345]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  183.156958]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  183.162430]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  183.167990]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  183.173038]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  183.179029] ---[ end trace decc4f53056ad60c ]---
<4>[  183.183638] ------------[ cut here ]------------
<4>[  183.188260] WARNING: CPU: 0 PID: 3930 at drivers/gpu/drm/i915/intel_display.c:9843 intel_modeset_check_state+0x614/0x7b0 [i915]()
<4>[  183.201276] pll on state mismatch (expected 0, found 1)
<4>[  183.206489] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs raid6_pq xor sg snd_hda_codec_hdmi sd_mod snd_hda_codec_realtek crc_t10dif snd_hda_codec_generic crct10dif_generic crct10dif_pclmul crct10dif_common ata_generic pata_acpi eeepc_wmi asus_wmi snd_hda_intel sparse_keymap snd_hda_codec rfkill snd_hwdep i915 parport_pc snd_pcm ata_piix pata_via snd_timer snd drm_kms_helper parport video tpm_infineon i2c_i801 soundcore libata pcspkr serio_raw drm wmi
<4>[  183.247863] CPU: 0 PID: 3930 Comm: pm_rpm Tainted: G        W    3.14.0-g9a952a0 #1
<4>[  183.255500] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.264619]  0000000000000009 ffff880099ef7b70 ffffffff8183d636 ffff880099ef7bb8
<4>[  183.272066]  ffff880099ef7ba8 ffffffff8106bd7d ffff880099d99b58 ffff880099d99800
<4>[  183.279520]  ffff880099ef7c28 ffff8801bd314000 ffff8801bd316ce0 ffff880099ef7c08
<4>[  183.286986] Call Trace:
<4>[  183.289429]  [<ffffffff8183d636>] dump_stack+0x4d/0x66
<4>[  183.294555]  [<ffffffff8106bd7d>] warn_slowpath_common+0x7d/0xa0
<4>[  183.300548]  [<ffffffff8106bdec>] warn_slowpath_fmt+0x4c/0x50
<4>[  183.306287]  [<ffffffffa01f9394>] ? ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  183.313501]  [<ffffffffa020db84>] intel_modeset_check_state+0x614/0x7b0 [i915]
<4>[  183.320713]  [<ffffffffa020ddb5>] intel_set_mode+0x25/0x30 [i915]
<4>[  183.326800]  [<ffffffffa020ed60>] intel_crtc_set_config+0xa40/0xcb0 [i915]
<4>[  183.333663]  [<ffffffff81153936>] ? find_get_page+0x26/0xc0
<4>[  183.339234]  [<ffffffffa003327d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
<4>[  183.346465]  [<ffffffffa00368dc>] drm_mode_setcrtc+0x25c/0x580 [drm]
<4>[  183.352811]  [<ffffffffa0027c92>] drm_ioctl+0x4d2/0x5e0 [drm]
<4>[  183.358552]  [<ffffffffa0036680>] ? drm_mode_setplane+0x3e0/0x3e0 [drm]
<4>[  183.365165]  [<ffffffff811df9a0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  183.370647]  [<ffffffff81385cf6>] ? file_has_perm+0x86/0xa0
<4>[  183.376223]  [<ffffffff811dfc21>] SyS_ioctl+0x81/0xa0
<4>[  183.381272]  [<ffffffff8184efe9>] system_call_fastpath+0x16/0x1b
<4>[  183.387271] ---[ end trace decc4f53056ad60d ]---

--uZ3hkaAS1mZxFaxD--
