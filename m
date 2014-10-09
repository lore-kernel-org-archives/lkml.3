Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaJICGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:06:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:34423 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbaJICGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,682,1406617200"; 
   d="scan'208";a="602595841"
Date: Thu, 9 Oct 2014 10:05:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [drm/i915] WARNING: CPU: 1 PID: 4249 at
 drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50
 [i915]()
Message-ID: <20141009020549.GB7968@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paulo,

FYI, we noticed the below changes on

commit 9a952a0d42ff089945ea3f5b3f690e45218d073f ("drm/i915: add SNB runtime PM support")

testbox/testcase/testparams: snb-drag/piglit/igt-007

97bea20794f600ae  9a952a0d42ff089945ea3f5b3f
----------------  --------------------------
       fail:runs  %reproduction    fail:runs
           |            |              |
           :1          100%           5:5     dmesg.WARNING:at_drivers/gpu/drm/i915/intel_uncore.c:assert_device_not_suspended_i915()
           :1          100%           5:5     dmesg.WARNING:at_drivers/gpu/drm/i915/intel_display.c:intel_modeset_check_state_i915()
           :1          100%           5:5     dmesg.WARNING:at_drivers/gpu/drm/i915/intel_display.c:check_crtc_state_i915()
           :1          100%           5:5     last_state.is_incomplete_run
           :1          100%           5:5     last_state.running

<3>[   89.395967] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.395973] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<4>[  171.693289] ------------[ cut here ]------------
<4>[  171.697936] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  171.711305] Device suspended
<4>[  171.714192] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  171.759962] CPU: 1 PID: 4249 Comm: pm_rpm Not tainted 3.16.0-rc1-00315-g401c58f #1
<4>[  171.767518] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  171.776634]  0000000000000009 ffff88019828fb00 ffffffff81844cfd ffff88019828fb48
<4>[  171.784102]  ffff88019828fb38 ffffffff8106de6d ffff880198400000 00000000000e1100
<4>[  171.791549]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828fb98
<4>[  171.798997] Call Trace:
<4>[  171.801449]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  171.806579]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  171.812580]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  171.818328]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  171.826159]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  171.832078]  [<ffffffffa00f8745>] ? intel_display_power_enabled+0xc5/0xe0 [i915]
<4>[  171.839470]  [<ffffffffa0155f3f>] intel_crt_get_hw_state+0x5f/0xa0 [i915]
<4>[  171.846256]  [<ffffffffa0142fc8>] intel_connector_get_hw_state+0x28/0x30 [i915]
<4>[  171.853567]  [<ffffffffa0146da5>] intel_modeset_check_state+0x55/0x7c0 [i915]
<4>[  171.860697]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  171.866786]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  171.873662]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  171.880884]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  171.887234]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  171.892978]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  171.899580]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  171.905063]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  171.910629]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  171.915679]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  171.921677] ---[ end trace 3b79dbaad8e668ef ]---
<4>[  171.926287] ------------[ cut here ]------------


Thanks,
Fengguang

--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00315-g401c58f (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Fri Sep 26 02:23:20 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/vmlinuz-3.16.0-rc1-00315-g401c58f kconfig=x86_64-rhel commit=401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b branch=linus/master root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
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
[    0.000000] AGP: No AGP bridge found
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
[    0.000000] BRK [0x02151000, 0x02151fff] PGTABLE
[    0.000000] BRK [0x02152000, 0x02152fff] PGTABLE
[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1bfc00000-0x1bfdfffff]
[    0.000000]  [mem 0x1bfc00000-0x1bfdfffff] page 2M
[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
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
[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
[    0.000000] BRK [0x02156000, 0x02156fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbadcf000-0xbadd0fff]
[    0.000000]  [mem 0xbadcf000-0xbadd0fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbae81000-0xbaffffff]
[    0.000000]  [mem 0xbae81000-0xbaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
[    0.000000] RAMDISK: [mem 0x6ff56000-0x7fff2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0420 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000BAC69068 00004C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BAC72FA0 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000BAC69140 009E5F (v02 ALASKA A M I    00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BADDBF80 000040
[    0.000000] ACPI: APIC 0x00000000BAC73098 000072 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000BAC73110 000102 (v01 AMICPU PROC     00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BAC73218 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BAC73258 000038 (v01 ALASKA A M I    01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001bfdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1bfdfffff]
[    0.000000]   NODE_DATA [mem 0x1bfdd5000-0x1bfdfbfff]
[    0.000000]  [ffffea0000000000-ffffea0006ffffff] PMD -> [ffff8801b9400000-ffff8801bf3fffff] on node 0
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
[    0.000000] Reserving Intel graphics stolen memory at 0xbba00000-0xbf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
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
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8801bfa00000 s88768 r8192 d21824 u524288
[    0.000000] pcpu-alloc: s88768 r8192 d21824 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1525760
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/vmlinuz-3.16.0-rc1-00315-g401c58f kconfig=x86_64-rhel commit=401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b branch=linus/master root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 5754156K/6200560K available (8522K kernel code, 1677K rwdata, 3796K rodata, 1796K init, 1880K bss, 446404K reserved)
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
[    0.000000] tsc: Detected 3311.348 MHz processor
[    0.000026] Calibrating delay loop (skipped), value calculated using timer frequency.. 6622.69 BogoMIPS (lpj=3311348)
[    0.010719] pid_max: default: 32768 minimum: 301
[    0.015373] ACPI: Core revision 20140424
[    0.022723] ACPI: All ACPI Tables successfully acquired
[    0.028112] Security Framework initialized
[    0.032250] SELinux:  Initializing.
[    0.035774] SELinux:  Starting in permissive mode
[    0.040925] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.049609] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.057349] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.064285] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.071852] Initializing cgroup subsys memory
[    0.076287] Initializing cgroup subsys devices
[    0.080795] Initializing cgroup subsys freezer
[    0.085295] Initializing cgroup subsys net_cls
[    0.089799] Initializing cgroup subsys blkio
[    0.094129] Initializing cgroup subsys perf_event
[    0.098890] Initializing cgroup subsys hugetlb
[    0.103407] CPU: Physical Processor ID: 0
[    0.107471] CPU: Processor Core ID: 2
[    0.111189] mce: CPU supports 9 MCE banks
[    0.115263] CPU0: Thermal LVT vector (0xfa) already installed
[    0.121072] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.121072] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.121072] tlb_flushall_shift: 6
[    0.136279] Freeing SMP alternatives memory: 36K (ffffffff81f70000 - ffffffff81f79000)
[    0.145270] ftrace: allocating 30822 entries in 121 pages
[    0.161901] Getting VERSION: 1060015
[    0.165534] Getting VERSION: 1060015
[    0.169170] Getting ID: 4000000
[    0.172374] Getting ID: 4000000
[    0.175581] masked ExtINT on CPU#0
[    0.179267] ENABLING IO-APIC IRQs
[    0.182645] init IO_APIC IRQs
[    0.185674]  apic 0 pin 0 not connected
[    0.189575] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.197577] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.205577] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.213579] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.221581] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.229582] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.237582] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.245575] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.253577] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.261570] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.269745] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.277917] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.286085] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.294257] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.302425] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.310597]  apic 0 pin 16 not connected
[    0.314580]  apic 0 pin 17 not connected
[    0.318563]  apic 0 pin 18 not connected
[    0.322548]  apic 0 pin 19 not connected
[    0.326531]  apic 0 pin 20 not connected
[    0.330514]  apic 0 pin 21 not connected
[    0.334496]  apic 0 pin 22 not connected
[    0.338480]  apic 0 pin 23 not connected
[    0.342597] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.358658] smpboot: CPU0: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz (fam: 06, model: 2a, stepping: 07)
[    0.368201] TSC deadline timer enabled
[    0.372026] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.382817] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.390896] ... version:                3
[    0.394965] ... bit width:              48
[    0.399122] ... generic registers:      8
[    0.403193] ... value mask:             0000ffffffffffff
[    0.408560] ... max period:             0000ffffffffffff
[    0.413930] ... fixed-purpose events:   3
[    0.417999] ... event mask:             00000007000000ff
[    0.424557] x86: Booting SMP configuration:
[    0.428800] .... node  #0, CPUs:      #1
[    0.443784] masked ExtINT on CPU#1
[    0.447393] CPU1: Thermal LVT vector (0xfa) already installed
[    0.455243] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.463393]  #2
[    0.476111] masked ExtINT on CPU#2
[    0.479718] CPU2: Thermal LVT vector (0xfa) already installed
[    0.487598]  #3
[    0.500220] masked ExtINT on CPU#3
[    0.503826] CPU3: Thermal LVT vector (0xfa) already installed
[    0.511644] x86: Booted up 1 node, 4 CPUs
[    0.515713] smpboot: Total of 4 processors activated (26490.78 BogoMIPS)
[    0.524870] devtmpfs: initialized
[    0.530014] evm: security.selinux
[    0.533387] evm: security.ima
[    0.536417] evm: security.capability
[    0.540154] PM: Registering ACPI NVS region [mem 0xbac1e000-0xbac76fff] (364544 bytes)
[    0.548156] PM: Registering ACPI NVS region [mem 0xbadaa000-0xbadbafff] (69632 bytes)
[    0.556067] PM: Registering ACPI NVS region [mem 0xbadda000-0xbade3fff] (40960 bytes)
[    0.563974] PM: Registering ACPI NVS region [mem 0xbae3e000-0xbae80fff] (274432 bytes)
[    0.572674] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.579735] NET: Registered protocol family 16
[    0.584385] cpuidle: using governor menu
[    0.588454] ACPI: bus type PCI registered
[    0.592522] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.599066] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.608448] PCI: not using MMCONFIG
[    0.611997] PCI: Using configuration type 1 for base access
[    0.620862] ACPI: Added _OSI(Module Device)
[    0.625107] ACPI: Added _OSI(Processor Device)
[    0.629611] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.634372] ACPI: Added _OSI(Processor Aggregator Device)
[    0.641446] ACPI: Executed 1 blocks of module-level executable AML code
[    0.649693] ACPI: Dynamic OEM Table Load:
[    0.653875] ACPI: SSDT 0xFFFF8801B6561400 00038C (v01 AMI    IST      00000001 MSFT 03000001)
[    0.662836] ACPI: Dynamic OEM Table Load:
[    0.667020] ACPI: SSDT 0xFFFF8801B64E7E40 000084 (v01 AMI    CST      00000001 MSFT 03000001)
[    0.676222] ACPI: Interpreter enabled
[    0.679952] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.689375] ACPI: (supports S0 S1 S3 S4 S5)
[    0.693621] ACPI: Using IOAPIC for interrupt routing
[    0.698656] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.708076] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.716923] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.726297] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.735991] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.742228] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.750575] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug]
[    0.757590] acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
[    0.764721] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cd7ff])
[    0.777315] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.788011] PCI host bridge to bus 0000:00
[    0.792165] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.797708] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.803943] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.810175] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.817105] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xffffffff]
[    0.824036] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.830160] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.836246] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.842422] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.848168] pci 0000:00:02.0: [8086:0112] type 00 class 0x030000
[    0.854243] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit]
[    0.861087] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.868386] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.874088] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.880174] pci 0000:00:16.0: reg 0x10: [mem 0xfe607000-0xfe60700f 64bit]
[    0.887087] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.893302] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.899386] pci 0000:00:1a.0: reg 0x10: [mem 0xfe606000-0xfe6063ff]
[    0.905790] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.911972] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.917723] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.923803] pci 0000:00:1b.0: reg 0x10: [mem 0xfe600000-0xfe603fff 64bit]
[    0.930713] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.936917] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.943053] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.949234] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.954983] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.961124] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.967306] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.973053] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.979189] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.985368] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.991115] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    0.997252] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.003433] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    1.009180] pci 0000:00:1c.7: [8086:244e] type 01 class 0x060401
[    1.015316] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.021497] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    1.027247] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    1.033799] pci 0000:00:1d.0: reg 0x10: [mem 0xfe605000-0xfe6053ff]
[    1.040201] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.046381] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.052125] pci 0000:00:1f.0: [8086:1c4a] type 00 class 0x060100
[    1.058333] pci 0000:00:1f.2: [8086:1c00] type 00 class 0x01018f
[    1.064411] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
[    1.070042] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
[    1.075679] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
[    1.081318] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
[    1.086953] pci 0000:00:1f.2: reg 0x20: [io  0xf0d0-0xf0df]
[    1.092592] pci 0000:00:1f.2: reg 0x24: [io  0xf0c0-0xf0cf]
[    1.098293] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    1.104366] pci 0000:00:1f.3: reg 0x10: [mem 0xfe604000-0xfe6040ff 64bit]
[    1.111230] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.116916] pci 0000:00:1f.5: [8086:1c08] type 00 class 0x010185
[    1.122994] pci 0000:00:1f.5: reg 0x10: [io  0xf0b0-0xf0b7]
[    1.128633] pci 0000:00:1f.5: reg 0x14: [io  0xf0a0-0xf0a3]
[    1.134269] pci 0000:00:1f.5: reg 0x18: [io  0xf090-0xf097]
[    1.139908] pci 0000:00:1f.5: reg 0x1c: [io  0xf080-0xf083]
[    1.145544] pci 0000:00:1f.5: reg 0x20: [io  0xf070-0xf07f]
[    1.151180] pci 0000:00:1f.5: reg 0x24: [io  0xf060-0xf06f]
[    1.156902] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.161969] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.167077] pci 0000:03:00.0: [1106:0415] type 00 class 0x010185
[    1.173167] pci 0000:03:00.0: reg 0x10: [io  0xe040-0xe047]
[    1.178812] pci 0000:03:00.0: reg 0x14: [io  0xe030-0xe033]
[    1.184458] pci 0000:03:00.0: reg 0x18: [io  0xe020-0xe027]
[    1.190103] pci 0000:03:00.0: reg 0x1c: [io  0xe010-0xe013]
[    1.195741] pci 0000:03:00.0: reg 0x20: [io  0xe000-0xe00f]
[    1.201399] pci 0000:03:00.0: reg 0x30: [mem 0xfe500000-0xfe50ffff pref]
[    1.208229] pci 0000:03:00.0: supports D1 D2
[    1.212553] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    1.220370] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.225397] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    1.231545] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
[    1.238459] pci 0000:04:00.0: [1b21:1042] type 00 class 0x0c0330
[    1.244555] pci 0000:04:00.0: reg 0x10: [mem 0xfe400000-0xfe407fff 64bit]
[    1.251553] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    1.259457] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    1.264480] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
[    1.271398] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
[    1.277487] pci 0000:05:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    1.283152] pci 0000:05:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    1.290474] pci 0000:05:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    1.297878] pci 0000:05:00.0: supports D1 D2
[    1.302206] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.310885] pci 0000:00:1c.6: PCI bridge to [bus 05]
[    1.315915] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    1.322074] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.329962] pci 0000:06:00.0: [1b21:1080] type 01 class 0x060401
[    1.336143] pci 0000:06:00.0: System wakeup disabled by ACPI
[    1.341879] pci 0000:00:1c.7: PCI bridge to [bus 06-07] (subtractive decode)
[    1.348991] pci 0000:00:1c.7:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.356985] pci 0000:00:1c.7:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.364976] pci 0000:00:1c.7:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.373662] pci 0000:00:1c.7:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
[    1.382456] pci 0000:06:00.0: PCI bridge to [bus 07] (subtractive decode)
[    1.389322] pci 0000:06:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.397319] pci 0000:06:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.405313] pci 0000:06:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.413997] pci 0000:06:00.0:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
[    1.422830] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    1.431317] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.440119] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.448914] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    1.457478] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
[    1.466034] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
[    1.474823] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.483621] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
[    1.492402] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
[    1.501199] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.506228] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.514397] vgaarb: loaded
[    1.517165] vgaarb: bridge control possible 0000:00:02.0
[    1.522580] SCSI subsystem initialized
[    1.526410] ACPI: bus type USB registered
[    1.530486] usbcore: registered new interface driver usbfs
[    1.536033] usbcore: registered new interface driver hub
[    1.541418] usbcore: registered new device driver usb
[    1.546549] pps_core: LinuxPPS API ver. 1 registered
[    1.551570] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.560777] PTP clock support registered
[    1.564794] PCI: Using ACPI for IRQ routing
[    1.570399] PCI: pci_cache_line_size set to 64 bytes
[    1.575465] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    1.581534] e820: reserve RAM buffer [mem 0xbac1e000-0xbbffffff]
[    1.587603] e820: reserve RAM buffer [mem 0xbadd1000-0xbbffffff]
[    1.593663] e820: reserve RAM buffer [mem 0xbb000000-0xbbffffff]
[    1.599724] e820: reserve RAM buffer [mem 0x1bfe00000-0x1bfffffff]
[    1.606037] NetLabel: Initializing
[    1.609503] NetLabel:  domain hash size = 128
[    1.613918] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.618950] NetLabel:  unlabeled traffic allowed by default
[    1.624662] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.631374] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.639278] Switched to clocksource hpet
[    1.649453] pnp: PnP ACPI init
[    1.652588] ACPI: bus type PNP registered
[    1.656758] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    1.663437] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
[    1.670112] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.676787] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.683464] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
[    1.690141] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.697047] system 00:01: [io  0x0290-0x029f] has been reserved
[    1.703028] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.710047] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:15)
[    1.718131] pnp 00:02: [dma 0 disabled]
[    1.722098] pnp 00:02: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.728692] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.736792] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.743412] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.749390] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.756363] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    1.764449] pnp 00:05: [dma 0 disabled]
[    1.768377] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.775084] system 00:06: [io  0x0400-0x0453] could not be reserved
[    1.781411] system 00:06: [io  0x0458-0x047f] has been reserved
[    1.787394] system 00:06: [io  0x0500-0x057f] has been reserved
[    1.793371] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.800046] system 00:06: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.807069] system 00:06: [mem 0xfed08000-0xfed08fff] has been reserved
[    1.813750] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    1.820422] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.827310] system 00:07: [io  0x0454-0x0457] has been reserved
[    1.833292] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.841017] pnp: PnP ACPI: found 8 devices
[    1.845180] ACPI: bus type PNP unregistered
[    1.855364] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.860398] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.865433] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.870456] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    1.876615] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
[    1.883469] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    1.888496] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
[    1.895348] pci 0000:00:1c.6: PCI bridge to [bus 05]
[    1.900376] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    1.906537] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.914363] pci 0000:06:00.0: PCI bridge to [bus 07]
[    1.919407] pci 0000:00:1c.7: PCI bridge to [bus 06-07]
[    1.924699] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.930335] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.935964] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.942295] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xffffffff]
[    1.948624] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    1.954253] pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
[    1.960582] pci_bus 0000:04: resource 1 [mem 0xfe400000-0xfe4fffff]
[    1.966905] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    1.972541] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.979842] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    1.985478] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    1.991108] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    1.997904] pci_bus 0000:06: resource 7 [mem 0xbfa00000-0xffffffff]
[    2.004227] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    2.009863] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    2.015491] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    2.021814] pci_bus 0000:07: resource 7 [mem 0xbfa00000-0xffffffff]
[    2.028166] NET: Registered protocol family 2
[    2.032718] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    2.040143] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.047039] TCP: Hash tables configured (established 65536 bind 65536)
[    2.053653] TCP: reno registered
[    2.056958] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.063133] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.069774] NET: Registered protocol family 1
[    2.074274] RPC: Registered named UNIX socket transport module.
[    2.080261] RPC: Registered udp transport module.
[    2.085027] RPC: Registered tcp transport module.
[    2.089790] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.096302] pci 0000:00:02.0: Boot video device
[    2.100950] IOAPIC[0]: Set routing entry (0-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    2.109365] IOAPIC[0]: Set routing entry (0-16 -> 0x51 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    2.117645] IOAPIC[0]: Set routing entry (0-17 -> 0x61 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    2.125940] PCI: CLS 64 bytes, default 64
[    2.130060] Unpacking initramfs...
[    5.132146] Freeing initrd memory: 262772K (ffff88006ff56000 - ffff88007fff3000)
[    5.139663] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.146180] software IO TLB [mem 0xb6c1e000-0xbac1e000] (64MB) mapped at [ffff8800b6c1e000-ffff8800bac1dfff]
[    5.156348] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    5.167357] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    5.173614] Initialise system trusted keyring
[    5.178047] audit: initializing netlink subsys (disabled)
[    5.183516] audit: type=2000 audit(1412381521.894:1): initialized
[    5.189959] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.197515] zbud: loaded
[    5.200245] VFS: Disk quotas dquot_6.5.2
[    5.204260] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.211114] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    5.220144] 9p: Installing v9fs 9p2000 file system support
[    5.225711] msgmni has been set to 11751
[    5.229737] Key type big_key registered
[    5.233637] SELinux:  Registering netfilter hooks
[    5.238823] NET: Registered protocol family 38
[    5.243344] Key type asymmetric registered
[    5.247499] Asymmetric key parser 'x509' registered
[    5.252470] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    5.259988] io scheduler noop registered
[    5.263974] io scheduler deadline registered (default)
[    5.269195] io scheduler cfq registered
[    5.273242] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    5.278621] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    5.284013] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    5.289370] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
[    5.294746] IOAPIC[0]: Set routing entry (0-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    5.303026] pcieport 0000:00:1c.6: irq 44 for MSI/MSI-X
[    5.308383] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    5.315408] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    5.322183] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    5.329204] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    5.335978] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    5.342996] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    5.349587] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    5.356363] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    5.363379] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    5.369963] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    5.376735] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
[    5.383756] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    5.390350] pcie_pme 0000:00:1c.6:pcie01: service driver pcie_pme loaded
[    5.397121] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.402764] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.409469] intel_idle: MWAIT substates: 0x1120
[    5.414064] intel_idle: v0.4 model 0x2A
[    5.417961] intel_idle: lapic_timer_reliable_states 0xffffffff
[    5.424007] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.432441] ACPI: Power Button [PWRB]
[    5.436187] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.443663] ACPI: Power Button [PWRF]
[    5.447717] GHES: HEST is not enabled!
[    5.451634] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.478504] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    5.486544] Non-volatile memory driver v1.3
[    5.490803] Linux agpgart interface v0.103
[    5.495104] IOAPIC[0]: Set routing entry (0-21 -> 0xd1 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    5.503386] mei_me 0000:00:16.0: irq 45 for MSI/MSI-X
[    5.509410] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20140424/utaddress-258)
[    5.526420] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.536672] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20140424/utaddress-258)
[    5.553652] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.563905] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20140424/utaddress-258)
[    5.580887] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000050f (\_GPE.GPIO) (20140424/utaddress-258)
[    5.596993] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.607247] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.613491] rdac: device handler registered
[    5.617821] hp_sw: device handler registered
[    5.622159] emc: device handler registered
[    5.626315] alua: device handler registered
[    5.630579] libphy: Fixed MDIO Bus: probed
[    5.634765] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.641867] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.647677] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.653566] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    5.659551] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    5.666573] igb: Copyright (c) 2007-2014 Intel Corporation.
[    5.672208] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    5.680029] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    5.685860] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.691668] r8169 0000:05:00.0: irq 46 for MSI/MSI-X
[    5.696776] r8169 0000:05:00.0 eth0: RTL8168e/8111e at 0xffffc90000c6e000, 20:cf:30:f4:b6:f7, XID 0c200000 IRQ 46
[    5.707117] r8169 0000:05:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.715744] usbcore: registered new interface driver catc
[    5.721222] usbcore: registered new interface driver kaweth
[    5.726870] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    5.734374] usbcore: registered new interface driver pegasus
[    5.740113] usbcore: registered new interface driver rtl8150
[    5.745838] usbcore: registered new interface driver asix
[    5.751300] usbcore: registered new interface driver cdc_ether
[    5.757197] usbcore: registered new interface driver cdc_eem
[    5.762923] usbcore: registered new interface driver dm9601
[    5.768560] usbcore: registered new interface driver smsc75xx
[    5.774370] usbcore: registered new interface driver smsc95xx
[    5.780179] usbcore: registered new interface driver gl620a
[    5.785816] usbcore: registered new interface driver net1080
[    5.791542] usbcore: registered new interface driver plusb
[    5.797091] usbcore: registered new interface driver rndis_host
[    5.803074] usbcore: registered new interface driver cdc_subset
[    5.809059] usbcore: registered new interface driver zaurus
[    5.814696] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    5.822181] usbcore: registered new interface driver int51x1
[    5.827902] usbcore: registered new interface driver ipheth
[    5.833540] usbcore: registered new interface driver sierra_net
[    5.839588] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.846180] ehci-pci: EHCI PCI platform driver
[    5.850731] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    5.856083] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.863576] ehci-pci 0000:00:1a.0: debug port 2
[    5.872057] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    5.878910] ehci-pci 0000:00:1a.0: irq 23, io mem 0xfe606000
[    5.889731] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.895567] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.902431] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.909737] usb usb1: Product: EHCI Host Controller
[    5.914674] usb usb1: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f ehci_hcd
[    5.921782] usb usb1: SerialNumber: 0000:00:1a.0
[    5.926627] hub 1-0:1.0: USB hub found
[    5.930448] hub 1-0:1.0: 2 ports detected
[    5.934648] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    5.940022] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.947514] ehci-pci 0000:00:1d.0: debug port 2
[    5.956006] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    5.963314] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe605000
[    5.974719] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.980572] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.987430] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.994731] usb usb2: Product: EHCI Host Controller
[    5.999666] usb usb2: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f ehci_hcd
[    6.006774] usb usb2: SerialNumber: 0000:00:1d.0
[    6.011612] hub 2-0:1.0: USB hub found
[    6.015432] hub 2-0:1.0: 2 ports detected
[    6.019576] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.025829] ohci-pci: OHCI PCI platform driver
[    6.030345] uhci_hcd: USB Universal Host Controller Interface driver
[    6.036822] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    6.042178] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
[    6.056634] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[    6.061922] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[    6.067210] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
[    6.072494] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
[    6.077785] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
[    6.083162] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    6.090011] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.097317] usb usb3: Product: xHCI Host Controller
[    6.102255] usb usb3: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f xhci_hcd
[    6.109363] usb usb3: SerialNumber: 0000:04:00.0
[    6.114159] hub 3-0:1.0: USB hub found
[    6.117986] hub 3-0:1.0: 2 ports detected
[    6.122131] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    6.127490] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
[    6.134996] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    6.141846] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.149145] usb usb4: Product: xHCI Host Controller
[    6.154096] usb usb4: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f xhci_hcd
[    6.156526] tsc: Refined TSC clocksource calibration: 3311.141 MHz
[    6.167467] usb usb4: SerialNumber: 0000:04:00.0
[    6.172384] hub 4-0:1.0: USB hub found
[    6.176207] hub 4-0:1.0: 2 ports detected
[    6.180371] usbcore: registered new interface driver usbserial
[    6.186263] usbcore: registered new interface driver usbserial_generic
[    6.192852] usbserial: USB Serial support registered for generic
[    6.198935] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    6.208817] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.213843] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.219115] mousedev: PS/2 mouse device common for all mice
[    6.225103] rtc_cmos 00:03: RTC can wake from S4
[    6.230002] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    6.236194] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.243954] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    6.250034] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    6.257755] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.263898] iTCO_vendor_support: vendor-support=0
[    6.268670] Intel P-state driver initializing.
[    6.273214] Intel pstate controlling: cpu 0
[    6.273516] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    6.284472] Intel pstate controlling: cpu 1
[    6.288770] Intel pstate controlling: cpu 2
[    6.293064] Intel pstate controlling: cpu 3
[    6.297731] hidraw: raw HID events driver (C) Jiri Kosina
[    6.303274] usbcore: registered new interface driver usbhid
[    6.308903] usbhid: USB HID core driver
[    6.312814] drop_monitor: Initializing network drop monitor service
[    6.319179] TCP: cubic registered
[    6.322567] Initializing XFRM netlink socket
[    6.326985] NET: Registered protocol family 10
[    6.331681] NET: Registered protocol family 17
[    6.336198] 9pnet: Installing 9P2000 support
[    6.340757] 
[    6.340757] printing PIC contents
[    6.345643] ... PIC  IMR: ffff
[    6.348759] ... PIC  IRR: 0c88
[    6.351886] ... PIC  ISR: 0000
[    6.355007] ... PIC ELCR: 0c88
[    6.358158] printing local APIC contents on CPU#0/4:
[    6.363185] ... APIC ID:      04000000 (4)
[    6.367341] ... APIC VERSION: 01060015
[    6.371151] ... APIC TASKPRI: 00000000 (00)
[    6.375396] ... APIC PROCPRI: 00000000
[    6.379205] ... APIC LDR: 01000000
[    6.382669] ... APIC DFR: ffffffff
[    6.386131] ... APIC SPIV: 000001ff
[    6.389674] ... APIC ISR field:
[    6.392878] 0000000000000000000000000000000000000000000000000000000000000000
[    6.400394] ... APIC TMR field:
[    6.403599] 0000000002000000000800020000000400040000000000000000000000000000
[    6.411122] ... APIC IRR field:
[    6.414327] 0000000000000000000000000000000000000000000000000000000020000000
[    6.421843] ... APIC ESR: 00000000
[    6.425308] ... APIC ICR: 000008fd
[    6.428770] ... APIC ICR2: 04000000
[    6.432313] ... APIC LVTT: 000400ef
[    6.435864] ... APIC LVTPC: 00000400
[    6.439501] ... APIC LVT0: 00010700
[    6.443051] ... APIC LVT1: 00000400
[    6.446600] ... APIC LVTERR: 000000fe
[    6.450323] ... APIC TMICT: 00000000
[    6.453951] ... APIC TMCCT: 00000000
[    6.457582] ... APIC TDCR: 00000000
[    6.461130] 
[    6.462682] number of MP IRQ sources: 15.
[    6.466763] number of IO-APIC #0 registers: 24.
[    6.471355] testing the IO APIC.......................
[    6.476554] IO APIC #0......
[    6.477711] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    6.477712] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.477979] hub 1-1:1.0: USB hub found
[    6.478083] hub 1-1:1.0: 6 ports detected
[    6.501331] .... register #00: 00000000
[    6.505228] .......    : physical APIC id: 00
[    6.509647] .......    : Delivery Type: 0
[    6.513715] .......    : LTS          : 0
[    6.517783] .... register #01: 00170020
[    6.521683] .......     : max redirection entries: 17
[    6.526789] .......     : PRQ implemented: 0
[    6.531120] .......     : IO APIC version: 20
[    6.535537] .... IRQ redirection table:
[    6.539437] 1    0    0   0   0    0    0    00
[    6.544033] 0    0    0   0   0    1    1    31
[    6.548625] 0    0    0   0   0    1    1    30
[    6.553222] 0    0    0   0   0    1    1    33
[    6.557810] 0    0    0   0   0    1    1    34
[    6.562402] 0    0    0   0   0    1    1    35
[    6.566998] 0    0    0   0   0    1    1    36
[    6.571587] 0    0    0   0   0    1    1    37
[    6.576179] 0    0    0   0   0    1    1    38
[    6.580162] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    6.587362] 0    1    0   0   0    1    1    39
[    6.591955] 0    0    0   0   0    1    1    3A
[    6.596547] 0    0    0   0   0    1    1    3B
[    6.601162] 0    0    0   0   0    1    1    3C
[    6.605760] 0    0    0   0   0    1    1    3D
[    6.610358] 0    0    0   0   0    1    1    3E
[    6.614956] 0    0    0   0   0    1    1    3F
[    6.619553] 1    1    0   1   0    1    1    51
[    6.624143] 1    1    0   1   0    1    1    61
[    6.628741] 1    1    0   1   0    1    1    B1
[    6.633339] 1    0    0   0   0    0    0    00
[    6.637928] 1    0    0   0   0    0    0    00
[    6.642516] 1    1    0   1   0    1    1    D1
[    6.647109] 1    0    0   0   0    0    0    00
[    6.651705] 0    1    0   1   0    1    1    41
[    6.656290] IRQ to pin mappings:
[    6.659583] IRQ0 -> 0:2
[    6.662206] IRQ1 -> 0:1
[    6.664834] IRQ3 -> 0:3
[    6.667450] IRQ4 -> 0:4
[    6.670066] IRQ5 -> 0:5
[    6.672689] IRQ6 -> 0:6
[    6.675314] IRQ7 -> 0:7
[    6.677936] IRQ8 -> 0:8
[    6.680552] IRQ9 -> 0:9
[    6.683189] IRQ10 -> 0:10
[    6.685981] IRQ11 -> 0:11
[    6.688779] IRQ12 -> 0:12
[    6.691575] IRQ13 -> 0:13
[    6.694379] IRQ14 
[    6.694529] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    6.694530] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.694797] hub 2-1:1.0: USB hub found
[    6.694903] hub 2-1:1.0: 8 ports detected
[    6.718155] -> 0:14
[    6.720618] IRQ15 -> 0:15
[    6.723408] IRQ16 -> 0:16
[    6.726211] IRQ17 -> 0:17
[    6.729003] IRQ18 -> 0:18
[    6.731798] IRQ21 -> 0:21
[    6.734594] IRQ23 -> 0:23
[    6.737383] .................................... done.
[    6.742830] Loading compiled-in X.509 certificates
[    6.748324] Loaded X.509 cert 'Magrathea: Glacier signing key: d7e9e189a02f235065f9cf5a4ad89162d061a477'
[    6.757916] registered taskstats version 1
[    6.763780] Key type trusted registered
[    6.769205] Key type encrypted registered
[    6.775383] ima: No TPM chip found, activating TPM-bypass!
[    6.780959] evm: HMAC attrs: 0x1
[    6.784780] rtc_cmos 00:03: setting system clock to 2014-10-04 00:12:06 UTC (1412381526)
[    6.793130] r8169 0000:05:00.0: Direct firmware load failed with error -2
[    6.799982] r8169 0000:05:00.0: Falling back to user helper
[    6.970098] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
[    7.149422] usb 2-1.3: New USB device found, idVendor=04d9, idProduct=1702
[    7.156370] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.163766] usb 2-1.3: Product: USB Keyboard
[    7.168119] usb 2-1.3: Manufacturer:  
[    7.171964] Switched to clocksource tsc
[    7.194660] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:04D9:1702.0001/input/input5
[    7.206526] hid-generic 0003:04D9:1702.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1.3/input0
[    7.259881] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/0003:04D9:1702.0002/input/input6
[    7.271767] hid-generic 0003:04D9:1702.0002: input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-1.3/input1
[    7.302567] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.2/0003:04D9:1702.0003/input/input7
[    7.314568] hid-generic 0003:04D9:1702.0003: input,hidraw2: USB HID v1.10 Mouse [  USB Keyboard] on usb-0000:00:1d.0-1.3/input2
[   66.865755] r8169 0000:05:00.0 eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-12)
[   66.887435] r8169 0000:05:00.0 eth0: link down
[   66.887491] r8169 0000:05:00.0 eth0: link down
[   66.896490] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   69.748728] r8169 0000:05:00.0 eth0: link up
[   69.753173] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   69.763256] Sending DHCP requests ..., OK
[   77.895523] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.171
[   77.903499] IP-Config: Complete:
[   77.906804]      device=eth0, hwaddr=20:cf:30:f4:b6:f7, ipaddr=192.168.1.171, mask=255.255.255.0, gw=192.168.1.1
[   77.917073]      host=snb-drag, domain=lkp.intel.com, nis-domain=(none)
[   77.923764]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   77.930504]      nameserver0=192.168.1.1
[   77.934868] PM: Hibernation image not present or could not be loaded.
[   77.942746] Freeing unused kernel memory: 1796K (ffffffff81daf000 - ffffffff81f70000)
[   78.108813] wmi: Mapper loaded
[   78.120512] [drm] Initialized drm 1.1.0 20060810
[   78.133993] parport_pc 00:02: reported by Plug and Play ACPI
[   78.145575] parport0: PC-style at 0x378, irq 5 [PCSPP]
[   78.153794] [drm] Memory usable by graphics device = 2048M
[   78.159351] [drm] Replacing VGA console driver
[   78.164925] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   78.164930] Console: switching to colour dummy device 80x25
[   78.167600] libata version 3.00 loaded.
[   78.181898] pata_via 0000:03:00.0: version 0.3.4
[   78.186775] asus_wmi: ASUS WMI generic driver loaded
[   78.187179] scsi0 : pata_via
[   78.188708] scsi1 : pata_via
[   78.188745] ata1: PATA max UDMA/133 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 16
[   78.188746] ata2: PATA max UDMA/133 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 16
[   78.211915] Error: Driver 'pcspkr' is already registered, aborting...
[   78.217172] i915 0000:00:02.0: irq 52 for MSI/MSI-X
[   78.217177] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   78.217177] [drm] Driver supports precise vblank timestamp query.
[   78.217247] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   78.220079] [drm] Wrong MCH_SSKPD value: 0x17050407
[   78.220079] [drm] This can cause pipe underruns and display issues.
[   78.220080] [drm] Please upgrade your BIOS to fix this.
[   78.262274] asus_wmi: Initialization: 0x0
[   78.266333] asus_wmi: BIOS WMI version: 0.9
[   78.270550] asus_wmi: SFUN value: 0x0
[   78.274221] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   78.274222] Raw EDID:
[   78.274222]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.274223]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.274223]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.274223]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.274224]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.274224]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.274225]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   78.274225]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.330764] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input9
[   78.338776] asus_wmi: Backlight controlled by ACPI video driver
[   78.353325] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   78.361489] Raw EDID:
[   78.363766]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.369506]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.375239]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.380972]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.386713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.392453]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.398187]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   78.403927]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.421950] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   78.430116] Raw EDID:
[   78.432391]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.438122]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.443857]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.449597]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.455330]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.461070]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.466804]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   78.472544]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.490568] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   78.498734] Raw EDID:
[   78.501008]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.506740]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.512474]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.518216]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.523957]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.529698]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.535438]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   78.541178]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   78.546913] i915 0000:00:02.0: VGA-1: Ignoring invalid EDID block 1.
[   78.725823] fbcon: inteldrmfb (fb0) is primary device
[   78.755994] Console: switching to colour frame buffer device 128x48
[   78.768567] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   78.774756] i915 0000:00:02.0: registered panic notifier
[   78.786065] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   78.793109] acpi device:37: registered as cooling_device4
[   78.798582] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   78.807956] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   78.815264] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   78.821195] ata_piix 0000:00:1f.2: version 2.13
[   78.825838] IOAPIC[0]: Set routing entry (0-20 -> 0xa2 -> IRQ 20 Mode:1 Active:1 Dest:15)
[   78.834035] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   78.990285] scsi2 : ata_piix
[   78.993442] scsi3 : ata_piix
[   78.996376] ata3: SATA max UDMA/133 cmd 0xf110 ctl 0xf100 bmdma 0xf0d0 irq 20
[   79.003518] ata4: SATA max UDMA/133 cmd 0xf0f0 ctl 0xf0e0 bmdma 0xf0d8 irq 20
[   79.010720] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[   79.167017] scsi4 : ata_piix
[   79.170147] scsi5 : ata_piix
[   79.173078] ata5: SATA max UDMA/133 cmd 0xf0b0 ctl 0xf0a0 bmdma 0xf070 irq 20
[   79.180224] ata6: SATA max UDMA/133 cmd 0xf090 ctl 0xf080 bmdma 0xf078 irq 20
[   79.187420] IOAPIC[0]: Set routing entry (0-22 -> 0xb2 -> IRQ 22 Mode:1 Active:1 Dest:15)
[   79.195643] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
[   79.215609] sound hdaudioC0D0: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[   79.224420] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   79.231465] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   79.238167] sound hdaudioC0D0:    mono: mono_out=0x0
[   79.243632] sound hdaudioC0D0:    dig-out=0x11/0x1e
[   79.249001] sound hdaudioC0D0:    inputs:
[   79.253529] sound hdaudioC0D0:      Front Mic=0x19
[   79.258819] sound hdaudioC0D0:      Rear Mic=0x18
[   79.264025] sound hdaudioC0D0:      Line=0x1a
[   79.283814] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   79.293451] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   79.302993] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   79.312247] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   79.322332] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   79.332682] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   79.342704] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[   79.352700] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[   79.362878] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[   79.502828] ata5: SATA link down (SStatus 0 SControl 310)
[   79.918737] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   80.016666] ata4.00: failed to resume link (SControl 0)
[   80.193517] ata6: failed to resume link (SControl 0)
[   80.210680] ata6: SATA link down (SStatus 4 SControl 0)
[   80.321465] ata3.01: failed to resume link (SControl 0)
[   80.478328] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   80.486110] ata3.01: SATA link down (SStatus 0 SControl 0)
[   80.495816] ata3.00: ATA-8: ST3750528AS, CC38, max UDMA/133
[   80.502715] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   80.516803] ata3.00: configured for UDMA/133
[   80.522617] scsi 2:0:0:0: Direct-Access     ATA      ST3750528AS      CC38 PQ: 0 ANSI: 5
[   80.546100] sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   80.554920] sd 2:0:0:0: [sda] Write Protect is off
[   80.560935] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   80.567297] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   80.653346]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   80.662205] sd 2:0:0:0: [sda] Attached SCSI disk
[   81.028849] ata4.01: failed to resume link (SControl 0)
[   81.046234] ata4.00: SATA link down (SStatus 4 SControl 0)
[   81.052964] ata4.01: SATA link down (SStatus 0 SControl 0)
[   81.065191] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   81.479700] random: nonblocking pool is initialized
[   81.710191] raid6: sse2x1    4515 MB/s
[   81.731162] raid6: sse2x2    6320 MB/s
[   81.752145] raid6: sse2x4    8132 MB/s
[   81.756812] raid6: using algorithm sse2x4 (8132 MB/s)
[   81.762788] raid6: using ssse3x2 recovery algorithm
[   81.770759] xor: automatically using best checksumming function:
[   81.787117]    avx       : 12644.000 MB/sec
[   81.811323] Btrfs loaded
[   81.826992] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 5 transid 6 /dev/sda10
[   81.868331] BTRFS: device fsid 900723f3-0511-4215-979c-2146631700ac devid 1 transid 230 /dev/sda6
[   81.878563] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 4 transid 6 /dev/sda9
[   81.915422] fuse init (API version 7.23)
[   82.004899] device-mapper: uevent: version 1.0.3
[   82.010538] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   82.610104] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   89.135553] ipmi message handler version 39.2
[   89.143063] IPMI Watchdog: driver initialized
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.16.0-rc1-00315-g401c58f (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Fri Sep 26 02:23:20 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/vmlinuz-3.16.0-rc1-00315-g401c58f kconfig=x86_64-rhel commit=401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b branch=linus/master root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
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
<6>[    0.000000] AGP: No AGP bridge found
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
<7>[    0.000000] BRK [0x02151000, 0x02151fff] PGTABLE
<7>[    0.000000] BRK [0x02152000, 0x02152fff] PGTABLE
<7>[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x1bfc00000-0x1bfdfffff]
<7>[    0.000000]  [mem 0x1bfc00000-0x1bfdfffff] page 2M
<7>[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
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
<7>[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
<7>[    0.000000] BRK [0x02156000, 0x02156fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0xbadcf000-0xbadd0fff]
<7>[    0.000000]  [mem 0xbadcf000-0xbadd0fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xbae81000-0xbaffffff]
<7>[    0.000000]  [mem 0xbae81000-0xbaffffff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
<7>[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
<6>[    0.000000] RAMDISK: [mem 0x6ff56000-0x7fff2fff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F0420 000024 (v02 ALASKA)
<4>[    0.000000] ACPI: XSDT 0x00000000BAC69068 00004C (v01 ALASKA A M I    01072009 AMI  00010013)
<4>[    0.000000] ACPI: FACP 0x00000000BAC72FA0 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
<4>[    0.000000] ACPI: DSDT 0x00000000BAC69140 009E5F (v02 ALASKA A M I    00000000 INTL 20051117)
<4>[    0.000000] ACPI: FACS 0x00000000BADDBF80 000040
<4>[    0.000000] ACPI: APIC 0x00000000BAC73098 000072 (v03 ALASKA A M I    01072009 AMI  00010013)
<4>[    0.000000] ACPI: SSDT 0x00000000BAC73110 000102 (v01 AMICPU PROC     00000001 MSFT 03000001)
<4>[    0.000000] ACPI: MCFG 0x00000000BAC73218 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
<4>[    0.000000] ACPI: HPET 0x00000000BAC73258 000038 (v01 ALASKA A M I    01072009 AMI. 00000004)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001bfdfffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00000000-0x1bfdfffff]
<6>[    0.000000]   NODE_DATA [mem 0x1bfdd5000-0x1bfdfbfff]
<7>[    0.000000]  [ffffea0000000000-ffffea0006ffffff] PMD -> [ffff8801b9400000-ffff8801bf3fffff] on node 0
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
<6>[    0.000000] Reserving Intel graphics stolen memory at 0xbba00000-0xbf9fffff
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
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
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
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
<6>[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff8801bfa00000 s88768 r8192 d21824 u524288
<7>[    0.000000] pcpu-alloc: s88768 r8192 d21824 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1525760
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/snb-drag/bisect_piglit-igt-007-x86_64-rhel-401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/vmlinuz-3.16.0-rc1-00315-g401c58f kconfig=x86_64-rhel commit=401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b branch=linus/master root=/dev/ram0 max_uptime=18000 RESULT_ROOT=/result/snb-drag/piglit/igt-007/debian-x86_64.cgz/x86_64-rhel/401c58fcbbf570e7e4a8ee0e21ffd829deb4de0b/0 ip=::::snb-drag::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 5754156K/6200560K available (8522K kernel code, 1677K rwdata, 3796K rodata, 1796K init, 1880K bss, 446404K reserved)
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
<6>[    0.000000] tsc: Detected 3311.348 MHz processor
<6>[    0.000026] Calibrating delay loop (skipped), value calculated using timer frequency.. 6622.69 BogoMIPS (lpj=3311348)
<6>[    0.010719] pid_max: default: 32768 minimum: 301
<6>[    0.015373] ACPI: Core revision 20140424
<4>[    0.022723] ACPI: All ACPI Tables successfully acquired
<6>[    0.028112] Security Framework initialized
<6>[    0.032250] SELinux:  Initializing.
<7>[    0.035774] SELinux:  Starting in permissive mode
<6>[    0.040925] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<6>[    0.049609] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    0.057349] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.064285] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.071852] Initializing cgroup subsys memory
<6>[    0.076287] Initializing cgroup subsys devices
<6>[    0.080795] Initializing cgroup subsys freezer
<6>[    0.085295] Initializing cgroup subsys net_cls
<6>[    0.089799] Initializing cgroup subsys blkio
<6>[    0.094129] Initializing cgroup subsys perf_event
<6>[    0.098890] Initializing cgroup subsys hugetlb
<6>[    0.103407] CPU: Physical Processor ID: 0
<6>[    0.107471] CPU: Processor Core ID: 2
<6>[    0.111189] mce: CPU supports 9 MCE banks
<7>[    0.115263] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.121072] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
<6>[    0.121072] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>[    0.121072] tlb_flushall_shift: 6
<6>[    0.136279] Freeing SMP alternatives memory: 36K (ffffffff81f70000 - ffffffff81f79000)
<6>[    0.145270] ftrace: allocating 30822 entries in 121 pages
<4>[    0.161901] Getting VERSION: 1060015
<4>[    0.165534] Getting VERSION: 1060015
<4>[    0.169170] Getting ID: 4000000
<4>[    0.172374] Getting ID: 4000000
<4>[    0.175581] masked ExtINT on CPU#0
<4>[    0.179267] ENABLING IO-APIC IRQs
<7>[    0.182645] init IO_APIC IRQs
<7>[    0.185674]  apic 0 pin 0 not connected
<7>[    0.189575] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.197577] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.205577] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.213579] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.221581] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.229582] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.237582] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.245575] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.253577] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.261570] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.269745] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.277917] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.286085] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.294257] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.302425] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.310597]  apic 0 pin 16 not connected
<7>[    0.314580]  apic 0 pin 17 not connected
<7>[    0.318563]  apic 0 pin 18 not connected
<7>[    0.322548]  apic 0 pin 19 not connected
<7>[    0.326531]  apic 0 pin 20 not connected
<7>[    0.330514]  apic 0 pin 21 not connected
<7>[    0.334496]  apic 0 pin 22 not connected
<7>[    0.338480]  apic 0 pin 23 not connected
<6>[    0.342597] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.358658] smpboot: CPU0: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz (fam: 06, model: 2a, stepping: 07)
<7>[    0.368201] TSC deadline timer enabled
<6>[    0.372026] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
<6>[    0.382817] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
<6>[    0.390896] ... version:                3
<6>[    0.394965] ... bit width:              48
<6>[    0.399122] ... generic registers:      8
<6>[    0.403193] ... value mask:             0000ffffffffffff
<6>[    0.408560] ... max period:             0000ffffffffffff
<6>[    0.413930] ... fixed-purpose events:   3
<6>[    0.417999] ... event mask:             00000007000000ff
<6>[    0.424557] x86: Booting SMP configuration:
<6>[    0.428800] .... node  #0, CPUs:      #1
<4>[    0.443784] masked ExtINT on CPU#1
<7>[    0.447393] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    0.455243] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.463393]  #2
<4>[    0.476111] masked ExtINT on CPU#2
<7>[    0.479718] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    0.487598]  #3
<4>[    0.500220] masked ExtINT on CPU#3
<7>[    0.503826] CPU3: Thermal LVT vector (0xfa) already installed
<6>[    0.511644] x86: Booted up 1 node, 4 CPUs
<6>[    0.515713] smpboot: Total of 4 processors activated (26490.78 BogoMIPS)
<6>[    0.524870] devtmpfs: initialized
<6>[    0.530014] evm: security.selinux
<6>[    0.533387] evm: security.ima
<6>[    0.536417] evm: security.capability
<6>[    0.540154] PM: Registering ACPI NVS region [mem 0xbac1e000-0xbac76fff] (364544 bytes)
<6>[    0.548156] PM: Registering ACPI NVS region [mem 0xbadaa000-0xbadbafff] (69632 bytes)
<6>[    0.556067] PM: Registering ACPI NVS region [mem 0xbadda000-0xbade3fff] (40960 bytes)
<6>[    0.563974] PM: Registering ACPI NVS region [mem 0xbae3e000-0xbae80fff] (274432 bytes)
<6>[    0.572674] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    0.579735] NET: Registered protocol family 16
<6>[    0.584385] cpuidle: using governor menu
<6>[    0.588454] ACPI: bus type PCI registered
<6>[    0.592522] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.599066] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
<6>[    0.608448] PCI: not using MMCONFIG
<6>[    0.611997] PCI: Using configuration type 1 for base access
<6>[    0.620862] ACPI: Added _OSI(Module Device)
<6>[    0.625107] ACPI: Added _OSI(Processor Device)
<6>[    0.629611] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.634372] ACPI: Added _OSI(Processor Aggregator Device)
<4>[    0.641446] ACPI: Executed 1 blocks of module-level executable AML code
<4>[    0.649693] ACPI: Dynamic OEM Table Load:
<4>[    0.653875] ACPI: SSDT 0xFFFF8801B6561400 00038C (v01 AMI    IST      00000001 MSFT 03000001)
<4>[    0.662836] ACPI: Dynamic OEM Table Load:
<4>[    0.667020] ACPI: SSDT 0xFFFF8801B64E7E40 000084 (v01 AMI    CST      00000001 MSFT 03000001)
<6>[    0.676222] ACPI: Interpreter enabled
<4>[    0.679952] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
<6>[    0.689375] ACPI: (supports S0 S1 S3 S4 S5)
<6>[    0.693621] ACPI: Using IOAPIC for interrupt routing
<6>[    0.698656] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
<6>[    0.708076] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
<6>[    0.716923] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<5>[    0.726297] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<6>[    0.735991] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>[    0.742228] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.750575] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug]
<6>[    0.757590] acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
<6>[    0.764721] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cd7ff])
<6>[    0.777315] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
<6>[    0.788011] PCI host bridge to bus 0000:00
<6>[    0.792165] pci_bus 0000:00: root bus resource [bus 00-ff]
<6>[    0.797708] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    0.803943] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    0.810175] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    0.817105] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xffffffff]
<7>[    0.824036] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
<7>[    0.830160] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
<7>[    0.836246] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<6>[    0.842422] pci 0000:00:01.0: System wakeup disabled by ACPI
<7>[    0.848168] pci 0000:00:02.0: [8086:0112] type 00 class 0x030000
<7>[    0.854243] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit]
<7>[    0.861087] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
<7>[    0.868386] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
<7>[    0.874088] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
<7>[    0.880174] pci 0000:00:16.0: reg 0x10: [mem 0xfe607000-0xfe60700f 64bit]
<7>[    0.887087] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    0.893302] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
<7>[    0.899386] pci 0000:00:1a.0: reg 0x10: [mem 0xfe606000-0xfe6063ff]
<7>[    0.905790] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>[    0.911972] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>[    0.917723] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
<7>[    0.923803] pci 0000:00:1b.0: reg 0x10: [mem 0xfe600000-0xfe603fff 64bit]
<7>[    0.930713] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<7>[    0.936917] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
<7>[    0.943053] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    0.949234] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    0.954983] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
<7>[    0.961124] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>[    0.967306] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>[    0.973053] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
<7>[    0.979189] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
<6>[    0.985368] pci 0000:00:1c.5: System wakeup disabled by ACPI
<7>[    0.991115] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
<7>[    0.997252] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
<6>[    1.003433] pci 0000:00:1c.6: System wakeup disabled by ACPI
<7>[    1.009180] pci 0000:00:1c.7: [8086:244e] type 01 class 0x060401
<7>[    1.015316] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
<6>[    1.021497] pci 0000:00:1c.7: System wakeup disabled by ACPI
<7>[    1.027247] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
<7>[    1.033799] pci 0000:00:1d.0: reg 0x10: [mem 0xfe605000-0xfe6053ff]
<7>[    1.040201] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>[    1.046381] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    1.052125] pci 0000:00:1f.0: [8086:1c4a] type 00 class 0x060100
<7>[    1.058333] pci 0000:00:1f.2: [8086:1c00] type 00 class 0x01018f
<7>[    1.064411] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
<7>[    1.070042] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
<7>[    1.075679] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
<7>[    1.081318] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
<7>[    1.086953] pci 0000:00:1f.2: reg 0x20: [io  0xf0d0-0xf0df]
<7>[    1.092592] pci 0000:00:1f.2: reg 0x24: [io  0xf0c0-0xf0cf]
<7>[    1.098293] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
<7>[    1.104366] pci 0000:00:1f.3: reg 0x10: [mem 0xfe604000-0xfe6040ff 64bit]
<7>[    1.111230] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
<7>[    1.116916] pci 0000:00:1f.5: [8086:1c08] type 00 class 0x010185
<7>[    1.122994] pci 0000:00:1f.5: reg 0x10: [io  0xf0b0-0xf0b7]
<7>[    1.128633] pci 0000:00:1f.5: reg 0x14: [io  0xf0a0-0xf0a3]
<7>[    1.134269] pci 0000:00:1f.5: reg 0x18: [io  0xf090-0xf097]
<7>[    1.139908] pci 0000:00:1f.5: reg 0x1c: [io  0xf080-0xf083]
<7>[    1.145544] pci 0000:00:1f.5: reg 0x20: [io  0xf070-0xf07f]
<7>[    1.151180] pci 0000:00:1f.5: reg 0x24: [io  0xf060-0xf06f]
<6>[    1.156902] pci 0000:00:01.0: PCI bridge to [bus 01]
<6>[    1.161969] pci 0000:00:1c.0: PCI bridge to [bus 02]
<7>[    1.167077] pci 0000:03:00.0: [1106:0415] type 00 class 0x010185
<7>[    1.173167] pci 0000:03:00.0: reg 0x10: [io  0xe040-0xe047]
<7>[    1.178812] pci 0000:03:00.0: reg 0x14: [io  0xe030-0xe033]
<7>[    1.184458] pci 0000:03:00.0: reg 0x18: [io  0xe020-0xe027]
<7>[    1.190103] pci 0000:03:00.0: reg 0x1c: [io  0xe010-0xe013]
<7>[    1.195741] pci 0000:03:00.0: reg 0x20: [io  0xe000-0xe00f]
<7>[    1.201399] pci 0000:03:00.0: reg 0x30: [mem 0xfe500000-0xfe50ffff pref]
<7>[    1.208229] pci 0000:03:00.0: supports D1 D2
<7>[    1.212553] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
<6>[    1.220370] pci 0000:00:1c.4: PCI bridge to [bus 03]
<7>[    1.225397] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
<7>[    1.231545] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
<7>[    1.238459] pci 0000:04:00.0: [1b21:1042] type 00 class 0x0c0330
<7>[    1.244555] pci 0000:04:00.0: reg 0x10: [mem 0xfe400000-0xfe407fff 64bit]
<7>[    1.251553] pci 0000:04:00.0: PME# supported from D3hot D3cold
<6>[    1.259457] pci 0000:00:1c.5: PCI bridge to [bus 04]
<7>[    1.264480] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
<7>[    1.271398] pci 0000:05:00.0: [10ec:8168] type 00 class 0x020000
<7>[    1.277487] pci 0000:05:00.0: reg 0x10: [io  0xd000-0xd0ff]
<7>[    1.283152] pci 0000:05:00.0: reg 0x18: [mem 0xd0004000-0xd0004fff 64bit pref]
<7>[    1.290474] pci 0000:05:00.0: reg 0x20: [mem 0xd0000000-0xd0003fff 64bit pref]
<7>[    1.297878] pci 0000:05:00.0: supports D1 D2
<7>[    1.302206] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    1.310885] pci 0000:00:1c.6: PCI bridge to [bus 05]
<7>[    1.315915] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
<7>[    1.322074] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
<7>[    1.329962] pci 0000:06:00.0: [1b21:1080] type 01 class 0x060401
<6>[    1.336143] pci 0000:06:00.0: System wakeup disabled by ACPI
<6>[    1.341879] pci 0000:00:1c.7: PCI bridge to [bus 06-07] (subtractive decode)
<7>[    1.348991] pci 0000:00:1c.7:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    1.356985] pci 0000:00:1c.7:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    1.364976] pci 0000:00:1c.7:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    1.373662] pci 0000:00:1c.7:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
<6>[    1.382456] pci 0000:06:00.0: PCI bridge to [bus 07] (subtractive decode)
<7>[    1.389322] pci 0000:06:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    1.397319] pci 0000:06:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    1.405313] pci 0000:06:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    1.413997] pci 0000:06:00.0:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
<7>[    1.422830] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<6>[    1.431317] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
<6>[    1.440119] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
<6>[    1.448914] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
<6>[    1.457478] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
<6>[    1.466034] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
<6>[    1.474823] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
<6>[    1.483621] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
<6>[    1.492402] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
<4>[    1.501199] ACPI: Enabled 2 GPEs in block 00 to 3F
<6>[    1.506228] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    1.514397] vgaarb: loaded
<6>[    1.517165] vgaarb: bridge control possible 0000:00:02.0
<5>[    1.522580] SCSI subsystem initialized
<6>[    1.526410] ACPI: bus type USB registered
<6>[    1.530486] usbcore: registered new interface driver usbfs
<6>[    1.536033] usbcore: registered new interface driver hub
<6>[    1.541418] usbcore: registered new device driver usb
<6>[    1.546549] pps_core: LinuxPPS API ver. 1 registered
<6>[    1.551570] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    1.560777] PTP clock support registered
<6>[    1.564794] PCI: Using ACPI for IRQ routing
<7>[    1.570399] PCI: pci_cache_line_size set to 64 bytes
<7>[    1.575465] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
<7>[    1.581534] e820: reserve RAM buffer [mem 0xbac1e000-0xbbffffff]
<7>[    1.587603] e820: reserve RAM buffer [mem 0xbadd1000-0xbbffffff]
<7>[    1.593663] e820: reserve RAM buffer [mem 0xbb000000-0xbbffffff]
<7>[    1.599724] e820: reserve RAM buffer [mem 0x1bfe00000-0x1bfffffff]
<6>[    1.606037] NetLabel: Initializing
<6>[    1.609503] NetLabel:  domain hash size = 128
<6>[    1.613918] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    1.618950] NetLabel:  unlabeled traffic allowed by default
<6>[    1.624662] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    1.631374] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    1.639278] Switched to clocksource hpet
<6>[    1.649453] pnp: PnP ACPI init
<6>[    1.652588] ACPI: bus type PNP registered
<6>[    1.656758] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
<6>[    1.663437] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
<6>[    1.670112] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
<6>[    1.676787] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>[    1.683464] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
<7>[    1.690141] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.697047] system 00:01: [io  0x0290-0x029f] has been reserved
<7>[    1.703028] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.710047] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:15)
<7>[    1.718131] pnp 00:02: [dma 0 disabled]
<7>[    1.722098] pnp 00:02: Plug and Play ACPI device, IDs PNP0400 (active)
<7>[    1.728692] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    1.736792] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    1.743412] system 00:04: [io  0x04d0-0x04d1] has been reserved
<7>[    1.749390] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.756363] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
<7>[    1.764449] pnp 00:05: [dma 0 disabled]
<7>[    1.768377] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
<6>[    1.775084] system 00:06: [io  0x0400-0x0453] could not be reserved
<6>[    1.781411] system 00:06: [io  0x0458-0x047f] has been reserved
<6>[    1.787394] system 00:06: [io  0x0500-0x057f] has been reserved
<6>[    1.793371] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    1.800046] system 00:06: [mem 0xfec00000-0xfecfffff] could not be reserved
<6>[    1.807069] system 00:06: [mem 0xfed08000-0xfed08fff] has been reserved
<6>[    1.813750] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
<7>[    1.820422] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.827310] system 00:07: [io  0x0454-0x0457] has been reserved
<7>[    1.833292] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<6>[    1.841017] pnp: PnP ACPI: found 8 devices
<6>[    1.845180] ACPI: bus type PNP unregistered
<6>[    1.855364] pci 0000:00:01.0: PCI bridge to [bus 01]
<6>[    1.860398] pci 0000:00:1c.0: PCI bridge to [bus 02]
<6>[    1.865433] pci 0000:00:1c.4: PCI bridge to [bus 03]
<6>[    1.870456] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
<6>[    1.876615] pci 0000:00:1c.4:   bridge window [mem 0xfe500000-0xfe5fffff]
<6>[    1.883469] pci 0000:00:1c.5: PCI bridge to [bus 04]
<6>[    1.888496] pci 0000:00:1c.5:   bridge window [mem 0xfe400000-0xfe4fffff]
<6>[    1.895348] pci 0000:00:1c.6: PCI bridge to [bus 05]
<6>[    1.900376] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
<6>[    1.906537] pci 0000:00:1c.6:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
<6>[    1.914363] pci 0000:06:00.0: PCI bridge to [bus 07]
<6>[    1.919407] pci 0000:00:1c.7: PCI bridge to [bus 06-07]
<7>[    1.924699] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    1.930335] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    1.935964] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    1.942295] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xffffffff]
<7>[    1.948624] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
<7>[    1.954253] pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
<7>[    1.960582] pci_bus 0000:04: resource 1 [mem 0xfe400000-0xfe4fffff]
<7>[    1.966905] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
<7>[    1.972541] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
<7>[    1.979842] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
<7>[    1.985478] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
<7>[    1.991108] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    1.997904] pci_bus 0000:06: resource 7 [mem 0xbfa00000-0xffffffff]
<7>[    2.004227] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
<7>[    2.009863] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
<7>[    2.015491] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    2.021814] pci_bus 0000:07: resource 7 [mem 0xbfa00000-0xffffffff]
<6>[    2.028166] NET: Registered protocol family 2
<6>[    2.032718] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
<6>[    2.040143] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>[    2.047039] TCP: Hash tables configured (established 65536 bind 65536)
<6>[    2.053653] TCP: reno registered
<6>[    2.056958] UDP hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    2.063133] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    2.069774] NET: Registered protocol family 1
<6>[    2.074274] RPC: Registered named UNIX socket transport module.
<6>[    2.080261] RPC: Registered udp transport module.
<6>[    2.085027] RPC: Registered tcp transport module.
<6>[    2.089790] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    2.096302] pci 0000:00:02.0: Boot video device
<7>[    2.100950] IOAPIC[0]: Set routing entry (0-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>[    2.109365] IOAPIC[0]: Set routing entry (0-16 -> 0x51 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[    2.117645] IOAPIC[0]: Set routing entry (0-17 -> 0x61 -> IRQ 17 Mode:1 Active:1 Dest:15)
<7>[    2.125940] PCI: CLS 64 bytes, default 64
<6>[    2.130060] Unpacking initramfs...
<6>[    5.132146] Freeing initrd memory: 262772K (ffff88006ff56000 - ffff88007fff3000)
<6>[    5.139663] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    5.146180] software IO TLB [mem 0xb6c1e000-0xbac1e000] (64MB) mapped at [ffff8800b6c1e000-ffff8800bac1dfff]
<6>[    5.156348] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
<6>[    5.167357] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>[    5.173614] Initialise system trusted keyring
<6>[    5.178047] audit: initializing netlink subsys (disabled)
<5>[    5.183516] audit: type=2000 audit(1412381521.894:1): initialized
<6>[    5.189959] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    5.197515] zbud: loaded
<5>[    5.200245] VFS: Disk quotas dquot_6.5.2
<4>[    5.204260] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    5.211114] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
<6>[    5.220144] 9p: Installing v9fs 9p2000 file system support
<6>[    5.225711] msgmni has been set to 11751
<5>[    5.229737] Key type big_key registered
<7>[    5.233637] SELinux:  Registering netfilter hooks
<6>[    5.238823] NET: Registered protocol family 38
<5>[    5.243344] Key type asymmetric registered
<5>[    5.247499] Asymmetric key parser 'x509' registered
<6>[    5.252470] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    5.259988] io scheduler noop registered
<6>[    5.263974] io scheduler deadline registered (default)
<6>[    5.269195] io scheduler cfq registered
<7>[    5.273242] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
<7>[    5.278621] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
<7>[    5.284013] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
<7>[    5.289370] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
<7>[    5.294746] IOAPIC[0]: Set routing entry (0-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
<7>[    5.303026] pcieport 0000:00:1c.6: irq 44 for MSI/MSI-X
<6>[    5.308383] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
<7>[    5.315408] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
<6>[    5.322183] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
<7>[    5.329204] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
<6>[    5.335978] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
<6>[    5.342996] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.349587] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
<6>[    5.356363] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
<6>[    5.363379] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.369963] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
<6>[    5.376735] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
<6>[    5.383756] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.390350] pcie_pme 0000:00:1c.6:pcie01: service driver pcie_pme loaded
<6>[    5.397121] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    5.402764] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[    5.409469] intel_idle: MWAIT substates: 0x1120
<7>[    5.414064] intel_idle: v0.4 model 0x2A
<7>[    5.417961] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[    5.424007] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
<6>[    5.432441] ACPI: Power Button [PWRB]
<6>[    5.436187] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[    5.443663] ACPI: Power Button [PWRF]
<6>[    5.447717] GHES: HEST is not enabled!
<6>[    5.451634] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    5.478504] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[    5.486544] Non-volatile memory driver v1.3
<6>[    5.490803] Linux agpgart interface v0.103
<7>[    5.495104] IOAPIC[0]: Set routing entry (0-21 -> 0xd1 -> IRQ 21 Mode:1 Active:1 Dest:15)
<7>[    5.503386] mei_me 0000:00:16.0: irq 45 for MSI/MSI-X
<4>[    5.509410] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20140424/utaddress-258)
<6>[    5.526420] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    5.536672] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20140424/utaddress-258)
<6>[    5.553652] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    5.563905] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\_SB_.PCI0.SBRG.GPBX) (20140424/utaddress-258)
<4>[    5.580887] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000050f (\_GPE.GPIO) (20140424/utaddress-258)
<6>[    5.596993] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    5.607247] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[    5.613491] rdac: device handler registered
<6>[    5.617821] hp_sw: device handler registered
<6>[    5.622159] emc: device handler registered
<6>[    5.626315] alua: device handler registered
<6>[    5.630579] libphy: Fixed MDIO Bus: probed
<6>[    5.634765] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    5.641867] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[    5.647677] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    5.653566] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<6>[    5.659551] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
<6>[    5.666573] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>[    5.672208] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    5.680029] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[    5.685860] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
<7>[    5.691668] r8169 0000:05:00.0: irq 46 for MSI/MSI-X
<6>[    5.696776] r8169 0000:05:00.0 eth0: RTL8168e/8111e at 0xffffc90000c6e000, 20:cf:30:f4:b6:f7, XID 0c200000 IRQ 46
<6>[    5.707117] r8169 0000:05:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
<6>[    5.715744] usbcore: registered new interface driver catc
<6>[    5.721222] usbcore: registered new interface driver kaweth
<6>[    5.726870] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[    5.734374] usbcore: registered new interface driver pegasus
<6>[    5.740113] usbcore: registered new interface driver rtl8150
<6>[    5.745838] usbcore: registered new interface driver asix
<6>[    5.751300] usbcore: registered new interface driver cdc_ether
<6>[    5.757197] usbcore: registered new interface driver cdc_eem
<6>[    5.762923] usbcore: registered new interface driver dm9601
<6>[    5.768560] usbcore: registered new interface driver smsc75xx
<6>[    5.774370] usbcore: registered new interface driver smsc95xx
<6>[    5.780179] usbcore: registered new interface driver gl620a
<6>[    5.785816] usbcore: registered new interface driver net1080
<6>[    5.791542] usbcore: registered new interface driver plusb
<6>[    5.797091] usbcore: registered new interface driver rndis_host
<6>[    5.803074] usbcore: registered new interface driver cdc_subset
<6>[    5.809059] usbcore: registered new interface driver zaurus
<6>[    5.814696] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[    5.822181] usbcore: registered new interface driver int51x1
<6>[    5.827902] usbcore: registered new interface driver ipheth
<6>[    5.833540] usbcore: registered new interface driver sierra_net
<6>[    5.839588] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    5.846180] ehci-pci: EHCI PCI platform driver
<6>[    5.850731] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>[    5.856083] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>[    5.863576] ehci-pci 0000:00:1a.0: debug port 2
<7>[    5.872057] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>[    5.878910] ehci-pci 0000:00:1a.0: irq 23, io mem 0xfe606000
<6>[    5.889731] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>[    5.895567] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    5.902431] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    5.909737] usb usb1: Product: EHCI Host Controller
<6>[    5.914674] usb usb1: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f ehci_hcd
<6>[    5.921782] usb usb1: SerialNumber: 0000:00:1a.0
<6>[    5.926627] hub 1-0:1.0: USB hub found
<6>[    5.930448] hub 1-0:1.0: 2 ports detected
<6>[    5.934648] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>[    5.940022] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>[    5.947514] ehci-pci 0000:00:1d.0: debug port 2
<7>[    5.956006] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>[    5.963314] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe605000
<6>[    5.974719] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>[    5.980572] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    5.987430] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    5.994731] usb usb2: Product: EHCI Host Controller
<6>[    5.999666] usb usb2: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f ehci_hcd
<6>[    6.006774] usb usb2: SerialNumber: 0000:00:1d.0
<6>[    6.011612] hub 2-0:1.0: USB hub found
<6>[    6.015432] hub 2-0:1.0: 2 ports detected
<6>[    6.019576] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    6.025829] ohci-pci: OHCI PCI platform driver
<6>[    6.030345] uhci_hcd: USB Universal Host Controller Interface driver
<6>[    6.036822] xhci_hcd 0000:04:00.0: xHCI Host Controller
<6>[    6.042178] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
<7>[    6.056634] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
<7>[    6.061922] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
<7>[    6.067210] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
<7>[    6.072494] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
<7>[    6.077785] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
<6>[    6.083162] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    6.090011] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.097317] usb usb3: Product: xHCI Host Controller
<6>[    6.102255] usb usb3: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f xhci_hcd
<6>[    6.109363] usb usb3: SerialNumber: 0000:04:00.0
<6>[    6.114159] hub 3-0:1.0: USB hub found
<6>[    6.117986] hub 3-0:1.0: 2 ports detected
<6>[    6.122131] xhci_hcd 0000:04:00.0: xHCI Host Controller
<6>[    6.127490] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
<6>[    6.134996] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
<6>[    6.141846] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.149145] usb usb4: Product: xHCI Host Controller
<6>[    6.154096] usb usb4: Manufacturer: Linux 3.16.0-rc1-00315-g401c58f xhci_hcd
<6>[    6.156526] tsc: Refined TSC clocksource calibration: 3311.141 MHz
<6>[    6.167467] usb usb4: SerialNumber: 0000:04:00.0
<6>[    6.172384] hub 4-0:1.0: USB hub found
<6>[    6.176207] hub 4-0:1.0: 2 ports detected
<6>[    6.180371] usbcore: registered new interface driver usbserial
<6>[    6.186263] usbcore: registered new interface driver usbserial_generic
<6>[    6.192852] usbserial: USB Serial support registered for generic
<6>[    6.198935] i8042: PNP: No PS/2 controller found. Probing ports directly.
<6>[    6.208817] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    6.213843] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    6.219115] mousedev: PS/2 mouse device common for all mice
<6>[    6.225103] rtc_cmos 00:03: RTC can wake from S4
<6>[    6.230002] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
<6>[    6.236194] rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>[    6.243954] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[    6.250034] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
<6>[    6.257755] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    6.263898] iTCO_vendor_support: vendor-support=0
<6>[    6.268670] Intel P-state driver initializing.
<6>[    6.273214] Intel pstate controlling: cpu 0
<6>[    6.273516] usb 1-1: new high-speed USB device number 2 using ehci-pci
<6>[    6.284472] Intel pstate controlling: cpu 1
<6>[    6.288770] Intel pstate controlling: cpu 2
<6>[    6.293064] Intel pstate controlling: cpu 3
<6>[    6.297731] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    6.303274] usbcore: registered new interface driver usbhid
<6>[    6.308903] usbhid: USB HID core driver
<6>[    6.312814] drop_monitor: Initializing network drop monitor service
<6>[    6.319179] TCP: cubic registered
<6>[    6.322567] Initializing XFRM netlink socket
<6>[    6.326985] NET: Registered protocol family 10
<6>[    6.331681] NET: Registered protocol family 17
<6>[    6.336198] 9pnet: Installing 9P2000 support
<7>[    6.340757] 
<7>[    6.340757] printing PIC contents
<7>[    6.345643] ... PIC  IMR: ffff
<7>[    6.348759] ... PIC  IRR: 0c88
<7>[    6.351886] ... PIC  ISR: 0000
<7>[    6.355007] ... PIC ELCR: 0c88
<7>[    6.358158] printing local APIC contents on CPU#0/4:
<6>[    6.363185] ... APIC ID:      04000000 (4)
<6>[    6.367341] ... APIC VERSION: 01060015
<7>[    6.371151] ... APIC TASKPRI: 00000000 (00)
<7>[    6.375396] ... APIC PROCPRI: 00000000
<7>[    6.379205] ... APIC LDR: 01000000
<7>[    6.382669] ... APIC DFR: ffffffff
<7>[    6.386131] ... APIC SPIV: 000001ff
<7>[    6.389674] ... APIC ISR field:
<4>[    6.392878] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    6.400394] ... APIC TMR field:
<4>[    6.403599] 0000000002000000000800020000000400040000000000000000000000000000
<7>[    6.411122] ... APIC IRR field:
<4>[    6.414327] 0000000000000000000000000000000000000000000000000000000020000000
<7>[    6.421843] ... APIC ESR: 00000000
<7>[    6.425308] ... APIC ICR: 000008fd
<7>[    6.428770] ... APIC ICR2: 04000000
<7>[    6.432313] ... APIC LVTT: 000400ef
<7>[    6.435864] ... APIC LVTPC: 00000400
<7>[    6.439501] ... APIC LVT0: 00010700
<7>[    6.443051] ... APIC LVT1: 00000400
<7>[    6.446600] ... APIC LVTERR: 000000fe
<7>[    6.450323] ... APIC TMICT: 00000000
<7>[    6.453951] ... APIC TMCCT: 00000000
<7>[    6.457582] ... APIC TDCR: 00000000
<4>[    6.461130] 
<7>[    6.462682] number of MP IRQ sources: 15.
<7>[    6.466763] number of IO-APIC #0 registers: 24.
<6>[    6.471355] testing the IO APIC.......................
<7>[    6.476554] IO APIC #0......
<6>[    6.477711] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    6.477712] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    6.477979] hub 1-1:1.0: USB hub found
<6>[    6.478083] hub 1-1:1.0: 6 ports detected
<7>[    6.501331] .... register #00: 00000000
<7>[    6.505228] .......    : physical APIC id: 00
<7>[    6.509647] .......    : Delivery Type: 0
<7>[    6.513715] .......    : LTS          : 0
<7>[    6.517783] .... register #01: 00170020
<7>[    6.521683] .......     : max redirection entries: 17
<7>[    6.526789] .......     : PRQ implemented: 0
<7>[    6.531120] .......     : IO APIC version: 20
<7>[    6.535537] .... IRQ redirection table:
<4>[    6.539437] 1    0    0   0   0    0    0    00
<4>[    6.544033] 0    0    0   0   0    1    1    31
<4>[    6.548625] 0    0    0   0   0    1    1    30
<4>[    6.553222] 0    0    0   0   0    1    1    33
<4>[    6.557810] 0    0    0   0   0    1    1    34
<4>[    6.562402] 0    0    0   0   0    1    1    35
<4>[    6.566998] 0    0    0   0   0    1    1    36
<4>[    6.571587] 0    0    0   0   0    1    1    37
<4>[    6.576179] 0    0    0   0   0    1    1    38
<6>[    6.580162] usb 2-1: new high-speed USB device number 2 using ehci-pci
<4>[    6.587362] 0    1    0   0   0    1    1    39
<4>[    6.591955] 0    0    0   0   0    1    1    3A
<4>[    6.596547] 0    0    0   0   0    1    1    3B
<4>[    6.601162] 0    0    0   0   0    1    1    3C
<4>[    6.605760] 0    0    0   0   0    1    1    3D
<4>[    6.610358] 0    0    0   0   0    1    1    3E
<4>[    6.614956] 0    0    0   0   0    1    1    3F
<4>[    6.619553] 1    1    0   1   0    1    1    51
<4>[    6.624143] 1    1    0   1   0    1    1    61
<4>[    6.628741] 1    1    0   1   0    1    1    B1
<4>[    6.633339] 1    0    0   0   0    0    0    00
<4>[    6.637928] 1    0    0   0   0    0    0    00
<4>[    6.642516] 1    1    0   1   0    1    1    D1
<4>[    6.647109] 1    0    0   0   0    0    0    00
<4>[    6.651705] 0    1    0   1   0    1    1    41
<7>[    6.656290] IRQ to pin mappings:
<7>[    6.659583] IRQ0 -> 0:2
<7>[    6.662206] IRQ1 -> 0:1
<7>[    6.664834] IRQ3 -> 0:3
<7>[    6.667450] IRQ4 -> 0:4
<7>[    6.670066] IRQ5 -> 0:5
<7>[    6.672689] IRQ6 -> 0:6
<7>[    6.675314] IRQ7 -> 0:7
<7>[    6.677936] IRQ8 -> 0:8
<7>[    6.680552] IRQ9 -> 0:9
<7>[    6.683189] IRQ10 -> 0:10
<7>[    6.685981] IRQ11 -> 0:11
<7>[    6.688779] IRQ12 -> 0:12
<7>[    6.691575] IRQ13 -> 0:13
<7>[    6.694379] IRQ14 
<6>[    6.694529] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    6.694530] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    6.694797] hub 2-1:1.0: USB hub found
<6>[    6.694903] hub 2-1:1.0: 8 ports detected
<4>[    6.718155] -> 0:14
<7>[    6.720618] IRQ15 -> 0:15
<7>[    6.723408] IRQ16 -> 0:16
<7>[    6.726211] IRQ17 -> 0:17
<7>[    6.729003] IRQ18 -> 0:18
<7>[    6.731798] IRQ21 -> 0:21
<7>[    6.734594] IRQ23 -> 0:23
<6>[    6.737383] .................................... done.
<5>[    6.742830] Loading compiled-in X.509 certificates
<5>[    6.748324] Loaded X.509 cert 'Magrathea: Glacier signing key: d7e9e189a02f235065f9cf5a4ad89162d061a477'
<6>[    6.757916] registered taskstats version 1
<5>[    6.763780] Key type trusted registered
<5>[    6.769205] Key type encrypted registered
<6>[    6.775383] ima: No TPM chip found, activating TPM-bypass!
<6>[    6.780959] evm: HMAC attrs: 0x1
<6>[    6.784780] rtc_cmos 00:03: setting system clock to 2014-10-04 00:12:06 UTC (1412381526)
<4>[    6.793130] r8169 0000:05:00.0: Direct firmware load failed with error -2
<4>[    6.799982] r8169 0000:05:00.0: Falling back to user helper
<6>[    6.970098] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
<6>[    7.149422] usb 2-1.3: New USB device found, idVendor=04d9, idProduct=1702
<6>[    7.156370] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    7.163766] usb 2-1.3: Product: USB Keyboard
<6>[    7.168119] usb 2-1.3: Manufacturer:  
<6>[    7.171964] Switched to clocksource tsc
<6>[    7.194660] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:04D9:1702.0001/input/input5
<6>[    7.206526] hid-generic 0003:04D9:1702.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1.3/input0
<6>[    7.259881] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/0003:04D9:1702.0002/input/input6
<6>[    7.271767] hid-generic 0003:04D9:1702.0002: input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-1.3/input1
<6>[    7.302567] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.2/0003:04D9:1702.0003/input/input7
<6>[    7.314568] hid-generic 0003:04D9:1702.0003: input,hidraw2: USB HID v1.10 Mouse [  USB Keyboard] on usb-0000:00:1d.0-1.3/input2
<4>[   66.865755] r8169 0000:05:00.0 eth0: unable to load firmware patch rtl_nic/rtl8168e-2.fw (-12)
<6>[   66.887435] r8169 0000:05:00.0 eth0: link down
<6>[   66.887491] r8169 0000:05:00.0 eth0: link down
<6>[   66.896490] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[   69.748728] r8169 0000:05:00.0 eth0: link up
<6>[   69.753173] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   69.763256] Sending DHCP requests ..., OK
<4>[   77.895523] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.171
<6>[   77.903499] IP-Config: Complete:
<6>[   77.906804]      device=eth0, hwaddr=20:cf:30:f4:b6:f7, ipaddr=192.168.1.171, mask=255.255.255.0, gw=192.168.1.1
<6>[   77.917073]      host=snb-drag, domain=lkp.intel.com, nis-domain=(none)
<6>[   77.923764]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   77.930504]      nameserver0=192.168.1.1
<7>[   77.934868] PM: Hibernation image not present or could not be loaded.
<6>[   77.942746] Freeing unused kernel memory: 1796K (ffffffff81daf000 - ffffffff81f70000)
<6>[   78.108813] wmi: Mapper loaded
<6>[   78.120512] [drm] Initialized drm 1.1.0 20060810
<6>[   78.133993] parport_pc 00:02: reported by Plug and Play ACPI
<6>[   78.145575] parport0: PC-style at 0x378, irq 5 [PCSPP]
<6>[   78.153794] [drm] Memory usable by graphics device = 2048M
<6>[   78.159351] [drm] Replacing VGA console driver
<6>[   78.164925] input: PC Speaker as /devices/platform/pcspkr/input/input8
<6>[   78.164930] Console: switching to colour dummy device 80x25
<7>[   78.167600] libata version 3.00 loaded.
<7>[   78.181898] pata_via 0000:03:00.0: version 0.3.4
<6>[   78.186775] asus_wmi: ASUS WMI generic driver loaded
<6>[   78.187179] scsi0 : pata_via
<6>[   78.188708] scsi1 : pata_via
<6>[   78.188745] ata1: PATA max UDMA/133 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 16
<6>[   78.188746] ata2: PATA max UDMA/133 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 16
<3>[   78.211915] Error: Driver 'pcspkr' is already registered, aborting...
<7>[   78.217172] i915 0000:00:02.0: irq 52 for MSI/MSI-X
<6>[   78.217177] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[   78.217177] [drm] Driver supports precise vblank timestamp query.
<6>[   78.217247] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<6>[   78.220079] [drm] Wrong MCH_SSKPD value: 0x17050407
<6>[   78.220079] [drm] This can cause pipe underruns and display issues.
<6>[   78.220080] [drm] Please upgrade your BIOS to fix this.
<6>[   78.262274] asus_wmi: Initialization: 0x0
<6>[   78.266333] asus_wmi: BIOS WMI version: 0.9
<6>[   78.270550] asus_wmi: SFUN value: 0x0
<3>[   78.274221] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   78.274222] Raw EDID:
<3>[   78.274222]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.274223]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.274223]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.274223]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.274224]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.274224]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.274225]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   78.274225]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   78.330764] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input9
<6>[   78.338776] asus_wmi: Backlight controlled by ACPI video driver
<3>[   78.353325] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   78.361489] Raw EDID:
<3>[   78.363766]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.369506]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.375239]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.380972]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.386713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.392453]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.398187]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   78.403927]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.421950] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   78.430116] Raw EDID:
<3>[   78.432391]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.438122]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.443857]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.449597]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.455330]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.461070]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.466804]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   78.472544]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.490568] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>[   78.498734] Raw EDID:
<3>[   78.501008]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.506740]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.512474]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.518216]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.523957]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.529698]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>[   78.535438]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>[   78.541178]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<4>[   78.546913] i915 0000:00:02.0: VGA-1: Ignoring invalid EDID block 1.
<6>[   78.725823] fbcon: inteldrmfb (fb0) is primary device
<6>[   78.755994] Console: switching to colour frame buffer device 128x48
<6>[   78.768567] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[   78.774756] i915 0000:00:02.0: registered panic notifier
<6>[   78.786065] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
<6>[   78.793109] acpi device:37: registered as cooling_device4
<6>[   78.798582] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
<6>[   78.807956] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
<6>[   78.815264] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<7>[   78.821195] ata_piix 0000:00:1f.2: version 2.13
<7>[   78.825838] IOAPIC[0]: Set routing entry (0-20 -> 0xa2 -> IRQ 20 Mode:1 Active:1 Dest:15)
<6>[   78.834035] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
<6>[   78.990285] scsi2 : ata_piix
<6>[   78.993442] scsi3 : ata_piix
<6>[   78.996376] ata3: SATA max UDMA/133 cmd 0xf110 ctl 0xf100 bmdma 0xf0d0 irq 20
<6>[   79.003518] ata4: SATA max UDMA/133 cmd 0xf0f0 ctl 0xf0e0 bmdma 0xf0d8 irq 20
<6>[   79.010720] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
<6>[   79.167017] scsi4 : ata_piix
<6>[   79.170147] scsi5 : ata_piix
<6>[   79.173078] ata5: SATA max UDMA/133 cmd 0xf0b0 ctl 0xf0a0 bmdma 0xf070 irq 20
<6>[   79.180224] ata6: SATA max UDMA/133 cmd 0xf090 ctl 0xf080 bmdma 0xf078 irq 20
<7>[   79.187420] IOAPIC[0]: Set routing entry (0-22 -> 0xb2 -> IRQ 22 Mode:1 Active:1 Dest:15)
<7>[   79.195643] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
<6>[   79.215609] sound hdaudioC0D0: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
<6>[   79.224420] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<6>[   79.231465] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
<6>[   79.238167] sound hdaudioC0D0:    mono: mono_out=0x0
<6>[   79.243632] sound hdaudioC0D0:    dig-out=0x11/0x1e
<6>[   79.249001] sound hdaudioC0D0:    inputs:
<6>[   79.253529] sound hdaudioC0D0:      Front Mic=0x19
<6>[   79.258819] sound hdaudioC0D0:      Rear Mic=0x18
<6>[   79.264025] sound hdaudioC0D0:      Line=0x1a
<6>[   79.283814] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>[   79.293451] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>[   79.302993] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>[   79.312247] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>[   79.322332] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
<6>[   79.332682] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
<6>[   79.342704] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
<6>[   79.352700] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
<6>[   79.362878] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
<6>[   79.502828] ata5: SATA link down (SStatus 0 SControl 310)
<6>[   79.918737] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
<4>[   80.016666] ata4.00: failed to resume link (SControl 0)
<4>[   80.193517] ata6: failed to resume link (SControl 0)
<6>[   80.210680] ata6: SATA link down (SStatus 4 SControl 0)
<4>[   80.321465] ata3.01: failed to resume link (SControl 0)
<6>[   80.478328] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[   80.486110] ata3.01: SATA link down (SStatus 0 SControl 0)
<6>[   80.495816] ata3.00: ATA-8: ST3750528AS, CC38, max UDMA/133
<6>[   80.502715] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
<6>[   80.516803] ata3.00: configured for UDMA/133
<5>[   80.522617] scsi 2:0:0:0: Direct-Access     ATA      ST3750528AS      CC38 PQ: 0 ANSI: 5
<5>[   80.546100] sd 2:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
<5>[   80.554920] sd 2:0:0:0: [sda] Write Protect is off
<7>[   80.560935] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   80.567297] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[   80.653346]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
<5>[   80.662205] sd 2:0:0:0: [sda] Attached SCSI disk
<4>[   81.028849] ata4.01: failed to resume link (SControl 0)
<6>[   81.046234] ata4.00: SATA link down (SStatus 4 SControl 0)
<6>[   81.052964] ata4.01: SATA link down (SStatus 0 SControl 0)
<5>[   81.065191] sd 2:0:0:0: Attached scsi generic sg0 type 0
<5>[   81.479700] random: nonblocking pool is initialized
<4>[   81.710191] raid6: sse2x1    4515 MB/s
<4>[   81.731162] raid6: sse2x2    6320 MB/s
<4>[   81.752145] raid6: sse2x4    8132 MB/s
<4>[   81.756812] raid6: using algorithm sse2x4 (8132 MB/s)
<4>[   81.762788] raid6: using ssse3x2 recovery algorithm
<6>[   81.770759] xor: automatically using best checksumming function:
<6>[   81.787117]    avx       : 12644.000 MB/sec
<6>[   81.811323] Btrfs loaded
<6>[   81.826992] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 5 transid 6 /dev/sda10
<6>[   81.868331] BTRFS: device fsid 900723f3-0511-4215-979c-2146631700ac devid 1 transid 230 /dev/sda6
<6>[   81.878563] BTRFS: device fsid d1257b84-03ac-4fa0-a879-7a50295d9fd6 devid 4 transid 6 /dev/sda9
<6>[   81.915422] fuse init (API version 7.23)
<6>[   82.004899] device-mapper: uevent: version 1.0.3
<6>[   82.010538] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
<6>[   82.610104] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
<6>[   89.135553] ipmi message handler version 39.2
<6>[   89.143063] IPMI Watchdog: driver initialized
<3>[   89.181677] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.181704] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.196907] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.196919] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.212107] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.212114] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.227332] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.227339] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.242625] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.242631] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.258056] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.258062] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.273374] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.273380] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.288698] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.288704] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.303978] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.303984] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.319297] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.319303] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.334846] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.334853] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.350050] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.350056] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.365352] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.365358] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.380657] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.380663] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.395967] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<3>[   89.395973] bmc-watchdog:1682 map pfn expected mapping type uncached-minus for [mem 0xbac69000-0xbac69fff], got write-back
<4>[  171.693289] ------------[ cut here ]------------
<4>[  171.697936] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  171.711305] Device suspended
<4>[  171.714192] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  171.759962] CPU: 1 PID: 4249 Comm: pm_rpm Not tainted 3.16.0-rc1-00315-g401c58f #1
<4>[  171.767518] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  171.776634]  0000000000000009 ffff88019828fb00 ffffffff81844cfd ffff88019828fb48
<4>[  171.784102]  ffff88019828fb38 ffffffff8106de6d ffff880198400000 00000000000e1100
<4>[  171.791549]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828fb98
<4>[  171.798997] Call Trace:
<4>[  171.801449]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  171.806579]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  171.812580]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  171.818328]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  171.826159]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  171.832078]  [<ffffffffa00f8745>] ? intel_display_power_enabled+0xc5/0xe0 [i915]
<4>[  171.839470]  [<ffffffffa0155f3f>] intel_crt_get_hw_state+0x5f/0xa0 [i915]
<4>[  171.846256]  [<ffffffffa0142fc8>] intel_connector_get_hw_state+0x28/0x30 [i915]
<4>[  171.853567]  [<ffffffffa0146da5>] intel_modeset_check_state+0x55/0x7c0 [i915]
<4>[  171.860697]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  171.866786]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  171.873662]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  171.880884]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  171.887234]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  171.892978]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  171.899580]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  171.905063]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  171.910629]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  171.915679]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  171.921677] ---[ end trace 3b79dbaad8e668ef ]---
<4>[  171.926287] ------------[ cut here ]------------
<4>[  171.930907] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:4933 intel_modeset_check_state+0x652/0x7c0 [i915]()
<4>[  171.943916] wrong connector dpms state
<4>[  171.947662] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  171.993263] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  172.001854] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.010963]  0000000000000009 ffff88019828fba0 ffffffff81844cfd ffff88019828fbe8
<4>[  172.018408]  ffff88019828fbd8 ffffffff8106de6d ffff880199515800 ffff88009d59f800
<4>[  172.025857]  ffff8801a2c30c00 ffff880199515b10 ffff880199515b68 ffff88019828fc38
<4>[  172.033304] Call Trace:
<4>[  172.035748]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  172.040883]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.046877]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.052625]  [<ffffffffa01473a2>] intel_modeset_check_state+0x652/0x7c0 [i915]
<4>[  172.059836]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.065924]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  172.072789]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  172.080000]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  172.086350]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  172.092090]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  172.098694]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.104173]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  172.109734]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  172.114773]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  172.120775] ---[ end trace 3b79dbaad8e668f0 ]---
<4>[  172.125380] ------------[ cut here ]------------
<4>[  172.129996] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:4935 intel_modeset_check_state+0x633/0x7c0 [i915]()
<4>[  172.143003] active connector not linked to encoder
<4>[  172.147784] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  172.193392] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  172.201983] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.211100]  0000000000000009 ffff88019828fba0 ffffffff81844cfd ffff88019828fbe8
<4>[  172.218547]  ffff88019828fbd8 ffffffff8106de6d ffff880199515800 ffff88009d59f800
<4>[  172.225993]  ffff8801a2c30c00 ffff880199515b10 ffff880199515b68 ffff88019828fc38
<4>[  172.233441] Call Trace:
<4>[  172.235886]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  172.241021]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.247022]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.252768]  [<ffffffffa0147383>] intel_modeset_check_state+0x633/0x7c0 [i915]
<4>[  172.259983]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.266068]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  172.272935]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  172.280148]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  172.286494]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  172.292234]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  172.298839]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.304320]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  172.309888]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  172.314937]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  172.320937] ---[ end trace 3b79dbaad8e668f1 ]---
<4>[  172.325542] ------------[ cut here ]------------
<4>[  172.330158] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:4937 intel_modeset_check_state+0x614/0x7c0 [i915]()
<4>[  172.343164] encoder->connectors_active not set
<4>[  172.347598] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  172.393199] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  172.401790] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.410900]  0000000000000009 ffff88019828fba0 ffffffff81844cfd ffff88019828fbe8
<4>[  172.418345]  ffff88019828fbd8 ffffffff8106de6d ffff880199515800 ffff88009d59f800
<4>[  172.425792]  ffff8801a2c30c00 ffff880199515b10 ffff880199515b68 ffff88019828fc38
<4>[  172.433249] Call Trace:
<4>[  172.435694]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  172.440827]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.446828]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.452567]  [<ffffffffa0147364>] intel_modeset_check_state+0x614/0x7c0 [i915]
<4>[  172.459781]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.465869]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  172.472732]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  172.479947]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  172.486292]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  172.492033]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  172.498639]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.504119]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  172.509687]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  172.514735]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  172.520726] ---[ end trace 3b79dbaad8e668f2 ]---
<4>[  172.525333] ------------[ cut here ]------------
<4>[  172.529948] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:4940 intel_modeset_check_state+0x5f5/0x7c0 [i915]()
<4>[  172.542956] encoder not enabled
<4>[  172.546090] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  172.591690] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  172.600282] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.609391]  0000000000000009 ffff88019828fba0 ffffffff81844cfd ffff88019828fbe8
<4>[  172.616845]  ffff88019828fbd8 ffffffff8106de6d ffff880199515800 ffff88009d59f800
<4>[  172.624292]  ffff8801a2c30c00 ffff880199515b10 ffff880199515b68 ffff88019828fc38
<4>[  172.631739] Call Trace:
<4>[  172.634183]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  172.639309]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.645302]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  172.651041]  [<ffffffffa0155f0e>] ? intel_crt_get_hw_state+0x2e/0xa0 [i915]
<4>[  172.657995]  [<ffffffffa0147345>] intel_modeset_check_state+0x5f5/0x7c0 [i915]
<4>[  172.665208]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.671297]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  172.678161]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  172.685373]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  172.691720]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  172.697461]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  172.704074]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.709563]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  172.715123]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  172.720173]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  172.726171] ---[ end trace 3b79dbaad8e668f3 ]---
<4>[  172.730779] ------------[ cut here ]------------
<4>[  172.735402] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:4941 intel_modeset_check_state+0x5d8/0x7c0 [i915]()
<4>[  172.748409] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  172.794009] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  172.802600] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  172.811709]  0000000000000009 ffff88019828fbf0 ffffffff81844cfd 0000000000000000
<4>[  172.819154]  ffff88019828fc28 ffffffff8106de6d ffff880199515800 ffff88009d59f800
<4>[  172.826603]  0000000000000000 ffff880199515b10 ffff880199515b68 ffff88019828fc38
<4>[  172.834048] Call Trace:
<4>[  172.836495]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  172.841628]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  172.847622]  [<ffffffff8106df4a>] warn_slowpath_null+0x1a/0x20
<4>[  172.853456]  [<ffffffffa0147328>] intel_modeset_check_state+0x5d8/0x7c0 [i915]
<4>[  172.860668]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  172.866779]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  172.873648]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  172.880869]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  172.887215]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  172.892957]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  172.899559]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  172.905033]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  172.910601]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  172.915649]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  172.921650] ---[ end trace 3b79dbaad8e668f4 ]---
<4>[  172.926258] ------------[ cut here ]------------
<4>[  172.930879] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  172.944234] Device suspended
<4>[  172.947116] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  172.992725] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  173.001316] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.010425]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  173.017881]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 0000000000070008
<4>[  173.025327]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  173.032775] Call Trace:
<4>[  173.035220]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  173.040354]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.046354]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.052089]  [<ffffffff813f34b2>] ? put_dec+0x72/0x90
<4>[  173.057141]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  173.064960]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  173.070876]  [<ffffffffa0138d97>] ironlake_get_pipe_config+0x57/0x2f0 [i915]
<4>[  173.077915]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  173.084345]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  173.089739]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  173.095920]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  173.103133]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.109220]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  173.116085]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  173.123299]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  173.129642]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  173.135387]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  173.141989]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.147471]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  173.153039]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  173.158088]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  173.164088] ---[ end trace 3b79dbaad8e668f5 ]---
<4>[  173.168696] ------------[ cut here ]------------
<4>[  173.173317] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  173.186671] Device suspended
<4>[  173.189545] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  173.235154] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  173.243746] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.252855]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  173.260301]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 00000000000f0008
<4>[  173.267748]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  173.275194] Call Trace:
<4>[  173.277641]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  173.282775]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.288775]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.294508]  [<ffffffff813f34b2>] ? put_dec+0x72/0x90
<4>[  173.299562]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  173.307382]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  173.313297]  [<ffffffffa0138e0f>] ironlake_get_pipe_config+0xcf/0x2f0 [i915]
<4>[  173.320336]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  173.326765]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  173.332159]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  173.338332]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  173.345545]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.351632]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  173.358496]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  173.365709]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  173.372056]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  173.377797]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  173.384402]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.389882]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  173.395443]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  173.400491]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  173.406491] ---[ end trace 3b79dbaad8e668f6 ]---
<4>[  173.411099] ------------[ cut here ]------------
<4>[  173.415720] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  173.429076] Device suspended
<4>[  173.431957] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  173.477558] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  173.486150] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.495267]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  173.502713]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 00000000000f000c
<4>[  173.510160]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  173.517606] Call Trace:
<4>[  173.520051]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  173.525187]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.531197]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.536936]  [<ffffffff813f34b2>] ? put_dec+0x72/0x90
<4>[  173.541982]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  173.549801]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  173.555718]  [<ffffffffa0138eba>] ironlake_get_pipe_config+0x17a/0x2f0 [i915]
<4>[  173.562843]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  173.569272]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  173.574665]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  173.580841]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  173.588060]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.594147]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  173.601011]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  173.608227]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  173.614571]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  173.620313]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  173.626917]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.632397]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  173.637958]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  173.643007]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  173.649005] ---[ end trace 3b79dbaad8e668f7 ]---
<4>[  173.653615] ------------[ cut here ]------------
<4>[  173.658235] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  173.671591] Device suspended
<4>[  173.674473] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  173.720073] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  173.728664] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.737781]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  173.745228]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060040
<4>[  173.752675]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  173.760123] Call Trace:
<4>[  173.762566]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  173.767693]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  173.773686]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  173.779426]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  173.785338]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  173.793158]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  173.799074]  [<ffffffffa0136646>] intel_cpu_transcoder_get_m_n+0xf6/0x190 [i915]
<4>[  173.807152]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  173.814279]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  173.820706]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  173.826100]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  173.832274]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  173.839486]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  173.845572]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  173.852439]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  173.859652]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  173.865998]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  173.871738]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  173.878343]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  173.883815]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  173.889376]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  173.894424]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  173.900425] ---[ end trace 3b79dbaad8e668f8 ]---
<4>[  173.905041] ------------[ cut here ]------------
<4>[  173.909663] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  173.923017] Device suspended
<4>[  173.925891] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  173.971490] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  173.980083] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  173.989200]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  173.996646]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060044
<4>[  174.004092]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  174.011539] Call Trace:
<4>[  174.013986]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  174.019128]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.025128]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.030862]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.036781]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  174.044600]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  174.050516]  [<ffffffffa013666a>] intel_cpu_transcoder_get_m_n+0x11a/0x190 [i915]
<4>[  174.058680]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  174.065809]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  174.072234]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  174.077622]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  174.083804]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  174.091016]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.097103]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  174.103969]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  174.111181]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  174.117529]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  174.123269]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  174.129873]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.135355]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  174.140924]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  174.145971]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  174.151964] ---[ end trace 3b79dbaad8e668f9 ]---
<4>[  174.156579] ------------[ cut here ]------------
<4>[  174.161202] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  174.174554] Device suspended
<4>[  174.177429] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  174.223030] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  174.231622] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.240738]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  174.248184]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060030
<4>[  174.255631]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  174.263079] Call Trace:
<4>[  174.265523]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  174.270659]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.276659]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.282402]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.288322]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  174.296140]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  174.302056]  [<ffffffffa013668e>] intel_cpu_transcoder_get_m_n+0x13e/0x190 [i915]
<4>[  174.310221]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  174.317346]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  174.323775]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  174.329170]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  174.335352]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  174.342564]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.348650]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  174.355517]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  174.362728]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  174.369077]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  174.374817]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  174.381420]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.386894]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  174.392462]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  174.397511]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  174.403509] ---[ end trace 3b79dbaad8e668fa ]---
<4>[  174.408119] ------------[ cut here ]------------
<4>[  174.412739] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  174.426101] Device suspended
<4>[  174.428976] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  174.474579] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  174.483167] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.492276]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  174.499723]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060034
<4>[  174.507170]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  174.514618] Call Trace:
<4>[  174.517064]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  174.522205]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.528199]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.533938]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.539851]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  174.547670]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  174.553585]  [<ffffffffa01366b7>] intel_cpu_transcoder_get_m_n+0x167/0x190 [i915]
<4>[  174.561749]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  174.568878]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  174.575305]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  174.580691]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  174.586872]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  174.594085]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.600173]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  174.607038]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  174.614251]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  174.620606]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  174.626346]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  174.632950]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.638423]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  174.643984]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  174.649031]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  174.655022] ---[ end trace 3b79dbaad8e668fb ]---
<4>[  174.659631] ------------[ cut here ]------------
<4>[  174.664252] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  174.677607] Device suspended
<4>[  174.680481] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  174.726082] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  174.734674] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.743790]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  174.751238]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060030
<4>[  174.758684]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  174.766131] Call Trace:
<4>[  174.768576]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  174.773709]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  174.779704]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  174.785443]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  174.791365]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  174.799182]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  174.805097]  [<ffffffffa0136601>] intel_cpu_transcoder_get_m_n+0xb1/0x190 [i915]
<4>[  174.813176]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  174.820302]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  174.826731]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  174.832117]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  174.838289]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  174.845503]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  174.851599]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  174.858474]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  174.865685]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  174.872033]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  174.877773]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  174.884377]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  174.889859]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  174.895428]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  174.900474]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  174.906467] ---[ end trace 3b79dbaad8e668fc ]---
<4>[  174.911074] ------------[ cut here ]------------
<4>[  174.915696] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  174.929051] Device suspended
<4>[  174.931926] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  174.977524] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  174.986116] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  174.995225]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  175.002670]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 00000000000c7000
<4>[  175.010118]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  175.017566] Call Trace:
<4>[  175.020010]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  175.025144]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.031138]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.036884]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  175.044705]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  175.050617]  [<ffffffffa0138fb3>] ironlake_get_pipe_config+0x273/0x2f0 [i915]
<4>[  175.057745]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  175.064172]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  175.069559]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  175.075732]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  175.082946]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.089032]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  175.095898]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  175.103108]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  175.109457]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  175.115198]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  175.121809]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.127282]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  175.132842]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  175.137882]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  175.143883] ---[ end trace 3b79dbaad8e668fd ]---
<4>[  175.148498] ------------[ cut here ]------------
<4>[  175.153119] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  175.166474] Device suspended
<4>[  175.169350] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  175.214949] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  175.223548] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.232657]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  175.240102]  ffff88019828f870 ffffffff8106de6d ffff880198400000 00000000000c6018
<4>[  175.247550]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  175.254999] Call Trace:
<4>[  175.257443]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  175.262577]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.268569]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.274301]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  175.280214]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  175.288033]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  175.293948]  [<ffffffffa0132226>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  175.300987]  [<ffffffffa0138f2f>] ironlake_get_pipe_config+0x1ef/0x2f0 [i915]
<4>[  175.308116]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  175.314541]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  175.319928]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  175.326101]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  175.333314]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.339400]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  175.346267]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  175.353480]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  175.359827]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  175.365567]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  175.372171]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.377653]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  175.383222]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  175.388269]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  175.394260] ---[ end trace 3b79dbaad8e668fe ]---
<4>[  175.398869] ------------[ cut here ]------------
<4>[  175.403490] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  175.416845] Device suspended
<4>[  175.419728] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  175.465327] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  175.473919] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.483036]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  175.490483]  ffff88019828f870 ffffffff8106de6d ffff880198400000 00000000000c6048
<4>[  175.497929]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  175.505376] Call Trace:
<4>[  175.507822]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  175.512957]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.518957]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.524699]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  175.530618]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  175.538438]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  175.544354]  [<ffffffffa013224e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  175.551392]  [<ffffffffa0138f2f>] ironlake_get_pipe_config+0x1ef/0x2f0 [i915]
<4>[  175.558518]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  175.564948]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  175.570342]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  175.576523]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  175.583737]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.589823]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  175.596688]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  175.603902]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  175.610247]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  175.615989]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  175.622593]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.628073]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  175.633634]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  175.638672]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  175.644665] ---[ end trace 3b79dbaad8e668ff ]---
<4>[  175.649273] ------------[ cut here ]------------
<4>[  175.653894] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  175.667249] Device suspended
<4>[  175.670122] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  175.715722] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  175.724314] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.733424]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  175.740868]  ffff88019828f870 ffffffff8106de6d ffff880198400000 00000000000c604c
<4>[  175.748316]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  175.755764] Call Trace:
<4>[  175.758207]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  175.763334]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  175.769327]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  175.775059]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  175.780971]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  175.788789]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  175.794705]  [<ffffffffa0132274>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  175.801746]  [<ffffffffa0138f2f>] ironlake_get_pipe_config+0x1ef/0x2f0 [i915]
<4>[  175.808872]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  175.815300]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  175.820703]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  175.826884]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  175.834096]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  175.840185]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  175.847050]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  175.854263]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  175.860609]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  175.866351]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  175.872955]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  175.878434]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  175.883996]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  175.889042]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  175.895036] ---[ end trace 3b79dbaad8e66900 ]---
<4>[  175.899652] ------------[ cut here ]------------
<4>[  175.904273] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  175.917626] Device suspended
<4>[  175.920502] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  175.966111] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  175.974702] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  175.983811]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  175.991258]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060000
<4>[  175.998703]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  176.006151] Call Trace:
<4>[  176.008596]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  176.013730]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.019732]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.025472]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.031384]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  176.039203]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  176.045118]  [<ffffffffa0136373>] intel_get_pipe_timings+0x43/0x220 [i915]
<4>[  176.052676]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  176.059718]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  176.066145]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  176.071532]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  176.077713]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  176.084925]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.091013]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  176.097880]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  176.105092]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  176.111438]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  176.117179]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  176.123783]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.129263]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  176.134824]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  176.139871]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  176.145865] ---[ end trace 3b79dbaad8e66901 ]---
<4>[  176.150481] ------------[ cut here ]------------
<4>[  176.155102] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  176.168456] Device suspended
<4>[  176.171331] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  176.216930] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  176.225521] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.234630]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  176.242079]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060004
<4>[  176.249524]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  176.256971] Call Trace:
<4>[  176.259416]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  176.264551]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.270551]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.276283]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.282196]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  176.290014]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  176.295929]  [<ffffffffa01363ae>] intel_get_pipe_timings+0x7e/0x220 [i915]
<4>[  176.303488]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  176.310529]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  176.316958]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  176.322351]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  176.328525]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  176.335736]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.341826]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  176.348690]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  176.355902]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  176.362248]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  176.367991]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  176.374596]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.380075]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  176.385636]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  176.390684]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  176.396683] ---[ end trace 3b79dbaad8e66902 ]---
<4>[  176.401293] ------------[ cut here ]------------
<4>[  176.405914] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  176.419266] Device suspended
<4>[  176.422143] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  176.467750] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  176.476342] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.485450]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  176.492898]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060008
<4>[  176.500343]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  176.507792] Call Trace:
<4>[  176.510237]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  176.515380]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.521389]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.527129]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.533041]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  176.540860]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  176.546775]  [<ffffffffa01363e9>] intel_get_pipe_timings+0xb9/0x220 [i915]
<4>[  176.554335]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  176.561375]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  176.567804]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  176.573198]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  176.579379]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  176.586593]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.592679]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  176.599544]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  176.606758]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  176.613103]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  176.618846]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  176.625449]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.630921]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  176.636481]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  176.641530]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  176.647531] ---[ end trace 3b79dbaad8e66903 ]---
<4>[  176.652147] ------------[ cut here ]------------
<4>[  176.656767] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  176.670121] Device suspended
<4>[  176.672996] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  176.718596] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  176.727188] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.736297]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  176.743743]  ffff88019828f870 ffffffff8106de6d ffff880198400000 000000000006000c
<4>[  176.751191]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  176.758638] Call Trace:
<4>[  176.761082]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  176.766216]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  176.772208]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  176.777941]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  176.783853]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  176.791670]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  176.797589]  [<ffffffffa0136424>] intel_get_pipe_timings+0xf4/0x220 [i915]
<4>[  176.805147]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  176.812187]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  176.818615]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  176.824010]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  176.830193]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  176.837412]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  176.843499]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  176.850364]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  176.857578]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  176.863924]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  176.869666]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  176.876270]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  176.881750]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  176.887311]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  176.892358]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  176.898350] ---[ end trace 3b79dbaad8e66904 ]---
<4>[  176.902959] ------------[ cut here ]------------
<4>[  176.907580] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  176.920934] Device suspended
<4>[  176.923809] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  176.969408] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  176.977999] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  176.987108]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  176.994555]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060010
<4>[  177.002001]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  177.009450] Call Trace:
<4>[  177.011894]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  177.017030]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.023039]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.028780]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.034699]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  177.042518]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  177.048434]  [<ffffffffa013645f>] intel_get_pipe_timings+0x12f/0x220 [i915]
<4>[  177.056078]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  177.063120]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  177.069546]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  177.074934]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  177.081116]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  177.088330]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.094424]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  177.101290]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  177.108501]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  177.114849]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  177.120589]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  177.127195]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.132674]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  177.138234]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  177.143281]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  177.149275] ---[ end trace 3b79dbaad8e66905 ]---
<4>[  177.153890] ------------[ cut here ]------------
<4>[  177.158503] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  177.171857] Device suspended
<4>[  177.174732] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  177.220332] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  177.228931] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.238042]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  177.245488]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000060014
<4>[  177.252933]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  177.260380] Call Trace:
<4>[  177.262827]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  177.267961]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.273962]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.279702]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.285615]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  177.293434]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  177.299349]  [<ffffffffa013649a>] intel_get_pipe_timings+0x16a/0x220 [i915]
<4>[  177.306994]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  177.314035]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  177.320463]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  177.325857]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  177.332030]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  177.339244]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.345330]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  177.352195]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  177.359407]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  177.365756]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  177.371496]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  177.378101]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.383581]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  177.389141]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  177.394189]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  177.400180] ---[ end trace 3b79dbaad8e66906 ]---
<4>[  177.404788] ------------[ cut here ]------------
<4>[  177.409401] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  177.422756] Device suspended
<4>[  177.425630] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  177.471229] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  177.479822] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.488940]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  177.496385]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000070008
<4>[  177.503840]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  177.511289] Call Trace:
<4>[  177.513733]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  177.518877]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.524878]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.530619]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.536538]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  177.544358]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  177.550273]  [<ffffffffa01364d5>] intel_get_pipe_timings+0x1a5/0x220 [i915]
<4>[  177.557917]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  177.564959]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  177.571386]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  177.576774]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  177.582955]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  177.590167]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.596254]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  177.603120]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  177.610333]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  177.616680]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  177.622420]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  177.629025]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.634504]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  177.640064]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  177.645105]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  177.651104] ---[ end trace 3b79dbaad8e66907 ]---
<4>[  177.655712] ------------[ cut here ]------------
<4>[  177.660334] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  177.673688] Device suspended
<4>[  177.676564] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  177.722162] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  177.730754] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.739871]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  177.747327]  ffff88019828f870 ffffffff8106de6d ffff880198400000 000000000006001c
<4>[  177.754774]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  177.762220] Call Trace:
<4>[  177.764666]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  177.769801]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  177.775801]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  177.781542]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  177.787455]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  177.795273]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  177.801189]  [<ffffffffa0136519>] intel_get_pipe_timings+0x1e9/0x220 [i915]
<4>[  177.808833]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  177.815875]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  177.822302]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  177.827698]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  177.833879]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  177.841092]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  177.847177]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  177.854044]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  177.861274]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  177.867619]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  177.873361]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  177.879965]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  177.885438]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  177.890997]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  177.896038]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  177.902039] ---[ end trace 3b79dbaad8e66908 ]---
<4>[  177.906654] ------------[ cut here ]------------
<4>[  177.911276] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  177.924629] Device suspended
<4>[  177.927504] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  177.973104] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  177.981694] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  177.990805]  0000000000000009 ffff88019828f830 ffffffff81844cfd ffff88019828f878
<4>[  177.998251]  ffff88019828f868 ffffffff8106de6d ffff880198400000 0000000000068080
<4>[  178.005698]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8c8
<4>[  178.013145] Call Trace:
<4>[  178.015590]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  178.020724]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.026717]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.032459]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.038380]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  178.046205]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  178.052120]  [<ffffffffa012d272>] ? gen6_read32+0x72/0x120 [i915]
<4>[  178.058207]  [<ffffffffa013741b>] ironlake_get_pfit_config+0x3b/0xe0 [i915]
<4>[  178.065856]  [<ffffffffa0138e44>] ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  178.072981]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  178.079410]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  178.084804]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  178.090985]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  178.098198]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.104285]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  178.111149]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  178.118364]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  178.124708]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  178.130451]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  178.137055]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.142536]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  178.148094]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  178.153135]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  178.159136] ---[ end trace 3b79dbaad8e66909 ]---
<4>[  178.163752] ------------[ cut here ]------------
<4>[  178.168373] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  178.181728] Device suspended
<4>[  178.184601] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  178.230203] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  178.238794] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.247903]  0000000000000009 ffff88019828f830 ffffffff81844cfd ffff88019828f878
<4>[  178.255349]  ffff88019828f868 ffffffff8106de6d ffff880198400000 0000000000068070
<4>[  178.262794]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8c8
<4>[  178.270242] Call Trace:
<4>[  178.272689]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  178.277823]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.283823]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.289564]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.295476]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  178.303296]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  178.309210]  [<ffffffffa012d272>] ? gen6_read32+0x72/0x120 [i915]
<4>[  178.315297]  [<ffffffffa0137457>] ironlake_get_pfit_config+0x77/0xe0 [i915]
<4>[  178.322944]  [<ffffffffa0138e44>] ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  178.330068]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  178.336498]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  178.341885]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  178.348066]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  178.355277]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.361367]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  178.368231]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  178.375445]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  178.381790]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  178.387533]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  178.394137]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.399617]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  178.405184]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  178.410225]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  178.416225] ---[ end trace 3b79dbaad8e6690a ]---
<4>[  178.420833] ------------[ cut here ]------------
<4>[  178.425454] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  178.438810] Device suspended
<4>[  178.441692] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  178.487293] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  178.495883] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.504991]  0000000000000009 ffff88019828f830 ffffffff81844cfd ffff88019828f878
<4>[  178.512463]  ffff88019828f868 ffffffff8106de6d ffff880198400000 0000000000068074
<4>[  178.519919]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8c8
<4>[  178.527368] Call Trace:
<4>[  178.529813]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  178.534946]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.540949]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.546688]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  178.552601]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  178.560419]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  178.566333]  [<ffffffffa012d272>] ? gen6_read32+0x72/0x120 [i915]
<4>[  178.572422]  [<ffffffffa013747d>] ironlake_get_pfit_config+0x9d/0xe0 [i915]
<4>[  178.580069]  [<ffffffffa0138e44>] ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  178.587194]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  178.593623]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  178.599009]  [<ffffffff8184d8a9>] ? system_call_fastpath+0x16/0x1b
<4>[  178.605190]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  178.612403]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.618491]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  178.625354]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  178.632571]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  178.638913]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  178.644657]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  178.651261]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.656742]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  178.662308]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  178.667349]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  178.673340] ---[ end trace 3b79dbaad8e6690b ]---
<4>[  178.677948] ------------[ cut here ]------------
<4>[  178.682571] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:10159 check_crtc_state+0x37f/0x3b0 [i915]()
<4>[  178.694886] crtc active state doesn't match with hw state (expected 0, found 1)
<4>[  178.702176] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  178.747776] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  178.756366] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.765476]  0000000000000009 ffff88019828f8e0 ffffffff81844cfd ffff88019828f928
<4>[  178.772922]  ffff88019828f918 ffffffff8106de6d ffff88019828f9b0 ffff880199515800
<4>[  178.780368]  ffff880199515b40 ffff8801b6beb000 ffff880199515b38 ffff88019828f978
<4>[  178.787816] Call Trace:
<4>[  178.790261]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  178.795396]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  178.801398]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  178.807144]  [<ffffffffa0138e44>] ? ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  178.814445]  [<ffffffffa01389df>] check_crtc_state+0x37f/0x3b0 [i915]
<4>[  178.820871]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  178.826257]  [<ffffffff8184d801>] ? ret_from_fork+0x81/0xb0
<4>[  178.831824]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  178.839039]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  178.845124]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  178.851991]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  178.859203]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  178.865549]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  178.871290]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  178.877896]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  178.883376]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  178.888945]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  178.893991]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  178.899983] ---[ end trace 3b79dbaad8e6690c ]---
<3>[  178.904592] [drm:intel_pipe_config_compare] *ERROR* mismatch in fdi_lanes (expected 1, found 8)
<4>[  178.913275] ------------[ cut here ]------------
<4>[  178.917890] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:10163 check_crtc_state+0x2bd/0x3b0 [i915]()
<4>[  178.930205] pipe state doesn't match!
<4>[  178.933859] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  178.979458] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  178.988051] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  178.997168]  0000000000000009 ffff88019828f8e0 ffffffff81844cfd ffff88019828f928
<4>[  179.004613]  ffff88019828f918 ffffffff8106de6d ffff88019828f9b0 ffff880199515800
<4>[  179.012061]  ffff880199515b40 ffff8801b6beb000 ffff8801b6beb6f8 ffff88019828f978
<4>[  179.019508] Call Trace:
<4>[  179.021952]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  179.027079]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.033080]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.038819]  [<ffffffffa0136cc8>] ? intel_pipe_config_compare+0x598/0xba0 [i915]
<4>[  179.046204]  [<ffffffffa013891d>] check_crtc_state+0x2bd/0x3b0 [i915]
<4>[  179.052632]  [<ffffffff813f60dc>] ? vsnprintf+0x26c/0x550
<4>[  179.058019]  [<ffffffff8184d801>] ? ret_from_fork+0x81/0xb0
<4>[  179.063595]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  179.070807]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.076893]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  179.083759]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  179.090972]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  179.097318]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  179.103061]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  179.109674]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.115153]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  179.120715]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  179.125762]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  179.131762] ---[ end trace 3b79dbaad8e6690d ]---
<4>[  179.136377] ------------[ cut here ]------------
<4>[  179.140991] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  179.154347] Device suspended
<4>[  179.157229] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  179.202828] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  179.211419] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.220528]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  179.227973]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 0000000000071008
<4>[  179.235422]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  179.242870] Call Trace:
<4>[  179.245314]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  179.250448]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.256442]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.262189]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  179.270007]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  179.275916]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.281837]  [<ffffffffa0138d97>] ironlake_get_pipe_config+0x57/0x2f0 [i915]
<4>[  179.288877]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  179.295312]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  179.302524]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.308612]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  179.315476]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  179.322698]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  179.329045]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  179.334785]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  179.341390]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.346871]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  179.352440]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  179.357487]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  179.363479] ---[ end trace 3b79dbaad8e6690e ]---
<4>[  179.368087] ------------[ cut here ]------------
<4>[  179.372709] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  179.386064] Device suspended
<4>[  179.388945] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  179.434545] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  179.443137] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.452245]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  179.459691]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 00000000000f1008
<4>[  179.467139]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  179.474588] Call Trace:
<4>[  179.477032]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  179.482165]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.488159]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.493905]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  179.501724]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  179.507634]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.513564]  [<ffffffffa0138e0f>] ironlake_get_pipe_config+0xcf/0x2f0 [i915]
<4>[  179.520610]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  179.527047]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  179.534258]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.540346]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  179.547210]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  179.554425]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  179.560771]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  179.566512]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  179.573117]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.578597]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  179.584165]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  179.589214]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  179.595215] ---[ end trace 3b79dbaad8e6690f ]---
<4>[  179.599831] ------------[ cut here ]------------
<4>[  179.604452] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  179.617806] Device suspended
<4>[  179.620682] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  179.666280] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  179.674873] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.683991]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  179.691435]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 00000000000f100c
<4>[  179.698884]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  179.706330] Call Trace:
<4>[  179.708774]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  179.713901]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.719901]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.725641]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  179.733459]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  179.739369]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.745288]  [<ffffffffa0138eba>] ironlake_get_pipe_config+0x17a/0x2f0 [i915]
<4>[  179.752413]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  179.758850]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  179.766063]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  179.772152]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  179.779015]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  179.786229]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  179.792575]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  179.798316]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  179.804919]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  179.810392]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  179.815951]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  179.820992]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  179.826991] ---[ end trace 3b79dbaad8e66910 ]---
<4>[  179.831600] ------------[ cut here ]------------
<4>[  179.836220] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  179.849575] Device suspended
<4>[  179.852449] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  179.898050] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  179.906640] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  179.915750]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  179.923196]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061040
<4>[  179.930643]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  179.938090] Call Trace:
<4>[  179.940535]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  179.945662]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  179.951663]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  179.957403]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  179.963316]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  179.971134]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  179.977050]  [<ffffffffa0136646>] intel_cpu_transcoder_get_m_n+0xf6/0x190 [i915]
<4>[  179.985128]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  179.992256]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  179.998690]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  180.005902]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.012000]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  180.018863]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  180.026078]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  180.032424]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  180.038164]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  180.044770]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.050250]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  180.055819]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  180.060867]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  180.066866] ---[ end trace 3b79dbaad8e66911 ]---
<4>[  180.071476] ------------[ cut here ]------------
<4>[  180.076097] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  180.089449] Device suspended
<4>[  180.092325] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  180.137932] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  180.146526] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.155643]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  180.163087]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061044
<4>[  180.170536]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  180.177982] Call Trace:
<4>[  180.180429]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  180.185562]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.191555]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.197295]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.203209]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  180.211027]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  180.216941]  [<ffffffffa013666a>] intel_cpu_transcoder_get_m_n+0x11a/0x190 [i915]
<4>[  180.225116]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  180.232242]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  180.238686]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  180.245900]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.251985]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  180.258851]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  180.266064]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  180.272411]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  180.278152]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  180.284757]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.290237]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  180.295807]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  180.300853]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  180.306854] ---[ end trace 3b79dbaad8e66912 ]---
<4>[  180.311472] ------------[ cut here ]------------
<4>[  180.316093] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  180.329446] Device suspended
<4>[  180.332321] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  180.377921] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  180.386512] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.395621]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  180.403065]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061030
<4>[  180.410515]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  180.417961] Call Trace:
<4>[  180.420406]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  180.425549]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.431548]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.437284]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.443204]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  180.451023]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  180.456939]  [<ffffffffa013668e>] intel_cpu_transcoder_get_m_n+0x13e/0x190 [i915]
<4>[  180.465101]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  180.472230]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  180.478663]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  180.485878]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.491964]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  180.498830]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  180.506044]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  180.512388]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  180.518140]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  180.524743]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.530224]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  180.535793]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  180.540840]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  180.546833] ---[ end trace 3b79dbaad8e66913 ]---
<4>[  180.551448] ------------[ cut here ]------------
<4>[  180.556061] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  180.569415] Device suspended
<4>[  180.572291] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  180.617889] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  180.626483] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.635599]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  180.643053]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061034
<4>[  180.650500]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  180.657947] Call Trace:
<4>[  180.660394]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  180.665529]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.671528]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.677261]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.683172]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  180.690992]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  180.696908]  [<ffffffffa01366b7>] intel_cpu_transcoder_get_m_n+0x167/0x190 [i915]
<4>[  180.705072]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  180.712199]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  180.718644]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  180.725857]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.731943]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  180.738810]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  180.746022]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  180.752368]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  180.758110]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  180.764713]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  180.770193]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  180.775753]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  180.780802]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  180.786801] ---[ end trace 3b79dbaad8e66914 ]---
<4>[  180.791411] ------------[ cut here ]------------
<4>[  180.796032] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  180.809386] Device suspended
<4>[  180.812261] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  180.857861] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  180.866452] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  180.875560]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  180.883016]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061030
<4>[  180.890471]  ffff88019828fbf8 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  180.897919] Call Trace:
<4>[  180.900363]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  180.905497]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  180.911490]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  180.917230]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  180.923143]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  180.930962]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  180.936878]  [<ffffffffa0136601>] intel_cpu_transcoder_get_m_n+0xb1/0x190 [i915]
<4>[  180.944956]  [<ffffffffa0138eeb>] ironlake_get_pipe_config+0x1ab/0x2f0 [i915]
<4>[  180.952085]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  180.958518]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  180.965732]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  180.971817]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  180.978683]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  180.985895]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  180.992243]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  180.997984]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  181.004589]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.010069]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  181.015638]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  181.020684]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  181.026677] ---[ end trace 3b79dbaad8e66915 ]---
<4>[  181.031285] ------------[ cut here ]------------
<4>[  181.035906] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  181.049260] Device suspended
<4>[  181.052135] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  181.097735] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  181.106326] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.115435]  0000000000000009 ffff88019828f868 ffffffff81844cfd ffff88019828f8b0
<4>[  181.122883]  ffff88019828f8a0 ffffffff8106de6d ffff880198400000 00000000000c7000
<4>[  181.130337]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f900
<4>[  181.137783] Call Trace:
<4>[  181.140229]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  181.145363]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.151364]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.157103]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  181.164922]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  181.170838]  [<ffffffffa0138fb3>] ironlake_get_pipe_config+0x273/0x2f0 [i915]
<4>[  181.177965]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  181.184400]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  181.191613]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.197699]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  181.204565]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  181.211777]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  181.218123]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  181.223864]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  181.230468]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.235949]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  181.241509]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  181.246550]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  181.252550] ---[ end trace 3b79dbaad8e66916 ]---
<4>[  181.257158] ------------[ cut here ]------------
<4>[  181.261778] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  181.275132] Device suspended
<4>[  181.278008] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  181.323608] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  181.332200] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.341316]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  181.348764]  ffff88019828f870 ffffffff8106de6d ffff880198400000 00000000000c6018
<4>[  181.356208]  ffff88019828f9b0 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  181.363656] Call Trace:
<4>[  181.366101]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  181.371235]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.377228]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.382961]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  181.388881]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  181.396700]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  181.402616]  [<ffffffffa0132226>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  181.409653]  [<ffffffffa0138f2f>] ironlake_get_pipe_config+0x1ef/0x2f0 [i915]
<4>[  181.416781]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  181.423225]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  181.430439]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.436525]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  181.443392]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  181.450603]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  181.456951]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  181.462691]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  181.469296]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.474775]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  181.480336]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  181.485385]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  181.491386] ---[ end trace 3b79dbaad8e66917 ]---
<4>[  181.496001] ------------[ cut here ]------------
<4>[  181.500623] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  181.513976] Device suspended
<4>[  181.516851] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  181.562451] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  181.571042] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.580152]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  181.587599]  ffff88019828f870 ffffffff8106de6d ffff880198400000 00000000000c6048
<4>[  181.595045]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  181.602494] Call Trace:
<4>[  181.604937]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  181.610072]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.616072]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.621806]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  181.627724]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  181.635543]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  181.641458]  [<ffffffffa013224e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  181.648498]  [<ffffffffa0138f2f>] ironlake_get_pipe_config+0x1ef/0x2f0 [i915]
<4>[  181.655627]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  181.662061]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  181.669274]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.675360]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  181.682227]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  181.689439]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  181.695786]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  181.701527]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  181.708132]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.713612]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  181.719173]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  181.724219]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  181.730212] ---[ end trace 3b79dbaad8e66918 ]---
<4>[  181.734819] ------------[ cut here ]------------
<4>[  181.739442] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  181.752796] Device suspended
<4>[  181.755679] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  181.801278] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  181.809870] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  181.818978]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  181.826426]  ffff88019828f870 ffffffff8106de6d ffff880198400000 00000000000c604c
<4>[  181.833871]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  181.841319] Call Trace:
<4>[  181.843764]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  181.848899]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  181.854900]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  181.860640]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  181.866553]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  181.874371]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  181.880286]  [<ffffffffa0132274>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  181.887326]  [<ffffffffa0138f2f>] ironlake_get_pipe_config+0x1ef/0x2f0 [i915]
<4>[  181.894452]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  181.900888]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  181.908102]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  181.914186]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  181.921053]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  181.928266]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  181.934613]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  181.940354]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  181.946959]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  181.952438]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  181.957999]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  181.963046]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  181.969038] ---[ end trace 3b79dbaad8e66919 ]---
<4>[  181.973647] ------------[ cut here ]------------
<4>[  181.978268] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  181.991622] Device suspended
<4>[  181.994496] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  182.040105] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  182.048696] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.057805]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  182.065251]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061000
<4>[  182.072699]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  182.080148] Call Trace:
<4>[  182.082591]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  182.087724]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.093717]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.099450]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  182.105370]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  182.113189]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  182.119104]  [<ffffffffa0136373>] intel_get_pipe_timings+0x43/0x220 [i915]
<4>[  182.126672]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  182.133712]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  182.140148]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  182.147360]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.153446]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  182.160313]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  182.167525]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  182.173871]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  182.179613]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  182.186218]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.191698]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  182.197258]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  182.202298]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  182.208299] ---[ end trace 3b79dbaad8e6691a ]---
<4>[  182.212915] ------------[ cut here ]------------
<4>[  182.217536] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  182.230891] Device suspended
<4>[  182.233766] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  182.279365] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  182.287957] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.297075]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  182.304519]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061004
<4>[  182.311968]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  182.319415] Call Trace:
<4>[  182.321859]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  182.326993]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.332986]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.338726]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  182.344639]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  182.352457]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  182.358373]  [<ffffffffa01363ae>] intel_get_pipe_timings+0x7e/0x220 [i915]
<4>[  182.365932]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  182.372973]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  182.379406]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  182.386622]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.392706]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  182.399573]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  182.406785]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  182.413130]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  182.418873]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  182.425478]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.430968]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  182.436536]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  182.441583]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  182.447574] ---[ end trace 3b79dbaad8e6691b ]---
<4>[  182.452183] ------------[ cut here ]------------
<4>[  182.456804] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  182.470158] Device suspended
<4>[  182.473033] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  182.518642] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  182.527234] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.536351]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  182.543798]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061008
<4>[  182.551243]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  182.558692] Call Trace:
<4>[  182.561135]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  182.566262]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.572263]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.578003]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  182.583917]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  182.591734]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  182.597650]  [<ffffffffa01363e9>] intel_get_pipe_timings+0xb9/0x220 [i915]
<4>[  182.605208]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  182.612250]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  182.618684]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  182.625897]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.631985]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  182.638849]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  182.646062]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  182.652409]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  182.658151]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  182.664755]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.670236]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  182.675804]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  182.680852]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  182.686853] ---[ end trace 3b79dbaad8e6691c ]---
<4>[  182.691470] ------------[ cut here ]------------
<4>[  182.696091] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  182.709443] Device suspended
<4>[  182.712319] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  182.757919] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  182.766510] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  182.775620]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  182.783065]  ffff88019828f870 ffffffff8106de6d ffff880198400000 000000000006100c
<4>[  182.790512]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  182.797958] Call Trace:
<4>[  182.800403]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  182.805530]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  182.811524]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  182.817265]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  182.823186]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  182.831003]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  182.836918]  [<ffffffffa0136424>] intel_get_pipe_timings+0xf4/0x220 [i915]
<4>[  182.844477]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  182.851519]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  182.857952]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  182.865167]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  182.871253]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  182.878118]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  182.885330]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  182.891677]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  182.897419]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  182.904024]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  182.909504]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  182.915072]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  182.920120]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  182.926112] ---[ end trace 3b79dbaad8e6691d ]---
<4>[  182.930720] ------------[ cut here ]------------
<4>[  182.935343] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  182.948705] Device suspended
<4>[  182.951580] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  182.997178] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  183.005771] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.014889]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  183.022345]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061010
<4>[  183.029807]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  183.037256] Call Trace:
<4>[  183.039707]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  183.044842]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  183.050844]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  183.056584]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  183.062495]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  183.070314]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  183.076232]  [<ffffffffa013645f>] intel_get_pipe_timings+0x12f/0x220 [i915]
<4>[  183.083876]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  183.090917]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  183.097352]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  183.104565]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  183.110651]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  183.117516]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  183.124729]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  183.131075]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  183.136816]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  183.143422]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  183.148901]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  183.154463]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  183.159510]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  183.165503] ---[ end trace 3b79dbaad8e6691e ]---
<4>[  183.170118] ------------[ cut here ]------------
<4>[  183.174739] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  183.188095] Device suspended
<4>[  183.190978] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  183.236578] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  183.245168] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.254278]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  183.261723]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000061014
<4>[  183.269172]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  183.276617] Call Trace:
<4>[  183.279063]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  183.284197]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  183.290198]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  183.295930]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  183.301843]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  183.309661]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  183.315577]  [<ffffffffa013649a>] intel_get_pipe_timings+0x16a/0x220 [i915]
<4>[  183.323222]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  183.330262]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  183.336698]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  183.343910]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  183.349997]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  183.356863]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  183.364076]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  183.370422]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  183.376163]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  183.382769]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  183.388249]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  183.393818]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  183.398865]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  183.404864] ---[ end trace 3b79dbaad8e6691f ]---
<4>[  183.409475] ------------[ cut here ]------------
<4>[  183.414095] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  183.427459] Device suspended
<4>[  183.430341] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  183.475941] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  183.484533] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.493651]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  183.501094]  ffff88019828f870 ffffffff8106de6d ffff880198400000 0000000000071008
<4>[  183.508543]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  183.515999] Call Trace:
<4>[  183.518443]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  183.523579]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  183.529580]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  183.535321]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  183.541242]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  183.549059]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  183.554976]  [<ffffffffa01364d5>] intel_get_pipe_timings+0x1a5/0x220 [i915]
<4>[  183.562620]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  183.569661]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  183.576096]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  183.583309]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  183.589396]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  183.596262]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  183.603474]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  183.609820]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  183.615562]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  183.622167]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  183.627648]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  183.633216]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  183.638263]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  183.644256] ---[ end trace 3b79dbaad8e66920 ]---
<4>[  183.648871] ------------[ cut here ]------------
<4>[  183.653485] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  183.666839] Device suspended
<4>[  183.669714] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  183.715313] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  183.723905] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.733023]  0000000000000009 ffff88019828f838 ffffffff81844cfd ffff88019828f880
<4>[  183.740468]  ffff88019828f870 ffffffff8106de6d ffff880198400000 000000000006101c
<4>[  183.747914]  ffff880198400004 ffff880198400080 0000000000000001 ffff88019828f8d0
<4>[  183.755361] Call Trace:
<4>[  183.757808]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  183.762941]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  183.768935]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  183.774675]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  183.780587]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  183.788406]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  183.794322]  [<ffffffffa0136519>] intel_get_pipe_timings+0x1e9/0x220 [i915]
<4>[  183.801966]  [<ffffffffa0138e35>] ironlake_get_pipe_config+0xf5/0x2f0 [i915]
<4>[  183.809007]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  183.815443]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  183.822656]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  183.828741]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  183.835608]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  183.842820]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  183.849166]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  183.854908]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  183.861513]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  183.866992]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  183.872552]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  183.877593]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  183.883593] ---[ end trace 3b79dbaad8e66921 ]---
<4>[  183.888202] ------------[ cut here ]------------
<4>[  183.892823] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  183.906175] Device suspended
<4>[  183.909051] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  183.954653] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  183.963251] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  183.972360]  0000000000000009 ffff88019828f830 ffffffff81844cfd ffff88019828f878
<4>[  183.979806]  ffff88019828f868 ffffffff8106de6d ffff880198400000 0000000000068880
<4>[  183.987252]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8c8
<4>[  183.994700] Call Trace:
<4>[  183.997144]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  184.002271]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  184.008264]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  184.014003]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  184.019916]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  184.027735]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  184.033650]  [<ffffffffa012d272>] ? gen6_read32+0x72/0x120 [i915]
<4>[  184.039738]  [<ffffffffa013741b>] ironlake_get_pfit_config+0x3b/0xe0 [i915]
<4>[  184.047384]  [<ffffffffa0138e44>] ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  184.054511]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  184.060947]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  184.068167]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  184.074255]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  184.081119]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  184.088333]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  184.094679]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  184.100420]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  184.107024]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  184.112505]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  184.118064]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  184.123104]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  184.129104] ---[ end trace 3b79dbaad8e66922 ]---
<4>[  184.133713] ------------[ cut here ]------------
<4>[  184.138333] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  184.151688] Device suspended
<4>[  184.154562] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  184.200164] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  184.208753] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  184.217862]  0000000000000009 ffff88019828f830 ffffffff81844cfd ffff88019828f878
<4>[  184.225311]  ffff88019828f868 ffffffff8106de6d ffff880198400000 0000000000068870
<4>[  184.232757]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8c8
<4>[  184.240204] Call Trace:
<4>[  184.242648]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  184.247783]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  184.253783]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  184.259516]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  184.265429]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  184.273248]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  184.279161]  [<ffffffffa012d272>] ? gen6_read32+0x72/0x120 [i915]
<4>[  184.285248]  [<ffffffffa0137457>] ironlake_get_pfit_config+0x77/0xe0 [i915]
<4>[  184.292896]  [<ffffffffa0138e44>] ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  184.300023]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  184.306458]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  184.313671]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  184.319758]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  184.326623]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  184.333835]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  184.340180]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  184.345925]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  184.352526]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  184.358001]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  184.363569]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  184.368616]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  184.374607] ---[ end trace 3b79dbaad8e66923 ]---
<4>[  184.379218] ------------[ cut here ]------------
<4>[  184.383838] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  184.397191] Device suspended
<4>[  184.400067] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  184.445666] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  184.454258] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  184.463376]  0000000000000009 ffff88019828f830 ffffffff81844cfd ffff88019828f878
<4>[  184.470820]  ffff88019828f868 ffffffff8106de6d ffff880198400000 0000000000068874
<4>[  184.478268]  ffff880198400000 ffff880198400080 0000000000000001 ffff88019828f8c8
<4>[  184.485714] Call Trace:
<4>[  184.488161]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  184.493293]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  184.499288]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  184.505029]  [<ffffffff8106dedc>] ? warn_slowpath_fmt+0x4c/0x50
<4>[  184.510949]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  184.518768]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  184.524682]  [<ffffffffa012d272>] ? gen6_read32+0x72/0x120 [i915]
<4>[  184.530770]  [<ffffffffa013747d>] ironlake_get_pfit_config+0x9d/0xe0 [i915]
<4>[  184.538415]  [<ffffffffa0138e44>] ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  184.545543]  [<ffffffffa01387a5>] check_crtc_state+0x145/0x3b0 [i915]
<4>[  184.551980]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  184.559198]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  184.565287]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  184.572153]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  184.579365]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  184.585711]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  184.591453]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  184.598056]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  184.603529]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  184.609097]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  184.614145]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  184.620145] ---[ end trace 3b79dbaad8e66924 ]---
<4>[  184.624754] ------------[ cut here ]------------
<4>[  184.629375] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:10159 check_crtc_state+0x37f/0x3b0 [i915]()
<4>[  184.641690] crtc active state doesn't match with hw state (expected 0, found 1)
<4>[  184.648982] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  184.694580] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  184.703172] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  184.712280]  0000000000000009 ffff88019828f8e0 ffffffff81844cfd ffff88019828f928
<4>[  184.719728]  ffff88019828f918 ffffffff8106de6d ffff88019828f9b0 ffff880199515800
<4>[  184.727184]  ffff880199515b40 ffff8801b6bee000 ffff880199515b38 ffff88019828f978
<4>[  184.734630] Call Trace:
<4>[  184.737076]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  184.742209]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  184.748204]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  184.753949]  [<ffffffffa0138e44>] ? ironlake_get_pipe_config+0x104/0x2f0 [i915]
<4>[  184.761249]  [<ffffffffa01389df>] check_crtc_state+0x37f/0x3b0 [i915]
<4>[  184.767686]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  184.774905]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  184.780993]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  184.787859]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  184.795071]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  184.801416]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  184.807159]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  184.813764]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  184.819243]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  184.824805]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  184.829853]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  184.835852] ---[ end trace 3b79dbaad8e66925 ]---
<3>[  184.840458] [drm:intel_pipe_config_compare] *ERROR* mismatch in fdi_lanes (expected 1, found 8)
<4>[  184.849136] ------------[ cut here ]------------
<4>[  184.853759] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:10163 check_crtc_state+0x2bd/0x3b0 [i915]()
<4>[  184.866073] pipe state doesn't match!
<4>[  184.869727] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  184.915326] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  184.923919] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  184.933037]  0000000000000009 ffff88019828f8e0 ffffffff81844cfd ffff88019828f928
<4>[  184.940482]  ffff88019828f918 ffffffff8106de6d ffff88019828f9b0 ffff880199515800
<4>[  184.947929]  ffff880199515b40 ffff8801b6bee000 ffff8801b6bee6f8 ffff88019828f978
<4>[  184.955376] Call Trace:
<4>[  184.957820]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  184.962948]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  184.968948]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  184.974695]  [<ffffffffa0136cc8>] ? intel_pipe_config_compare+0x598/0xba0 [i915]
<4>[  184.982082]  [<ffffffffa013891d>] check_crtc_state+0x2bd/0x3b0 [i915]
<4>[  184.988517]  [<ffffffffa0147069>] intel_modeset_check_state+0x319/0x7c0 [i915]
<4>[  184.995729]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  185.001816]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  185.008683]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  185.015894]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  185.022241]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  185.027983]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  185.034588]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  185.040068]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  185.045635]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  185.050676]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  185.056676] ---[ end trace 3b79dbaad8e66926 ]---
<4>[  185.061282] ------------[ cut here ]------------
<4>[  185.065896] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  185.079251] Device suspended
<4>[  185.082125] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  185.127725] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  185.136316] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  185.145425]  0000000000000009 ffff88019828fb20 ffffffff81844cfd ffff88019828fb68
<4>[  185.152870]  ffff88019828fb58 ffffffff8106de6d ffff880198400000 00000000000c6014
<4>[  185.160319]  ffff880199515b70 ffff880198400080 0000000000000001 ffff88019828fbb8
<4>[  185.167765] Call Trace:
<4>[  185.170211]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  185.175344]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  185.181337]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  185.187077]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  185.194895]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  185.200809]  [<ffffffffa0132226>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  185.207852]  [<ffffffffa01470c0>] intel_modeset_check_state+0x370/0x7c0 [i915]
<4>[  185.215063]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  185.221152]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  185.228017]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  185.235230]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  185.241576]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  185.247317]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  185.253922]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  185.259402]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  185.264961]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  185.270002]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  185.276002] ---[ end trace 3b79dbaad8e66927 ]---
<4>[  185.280610] ------------[ cut here ]------------
<4>[  185.285231] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  185.298586] Device suspended
<4>[  185.301459] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  185.347060] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  185.355650] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  185.364760]  0000000000000009 ffff88019828fb20 ffffffff81844cfd ffff88019828fb68
<4>[  185.372215]  ffff88019828fb58 ffffffff8106de6d ffff880198400000 00000000000c6040
<4>[  185.379660]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828fbb8
<4>[  185.387109] Call Trace:
<4>[  185.389554]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  185.394689]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  185.400689]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  185.406428]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  185.414247]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  185.420160]  [<ffffffffa013224e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  185.427213]  [<ffffffffa01470c0>] intel_modeset_check_state+0x370/0x7c0 [i915]
<4>[  185.434441]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  185.440531]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  185.447395]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  185.454607]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  185.460954]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  185.466696]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  185.473298]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  185.478772]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  185.484338]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  185.489379]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  185.495378] ---[ end trace 3b79dbaad8e66928 ]---
<4>[  185.499987] ------------[ cut here ]------------
<4>[  185.504608] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  185.517963] Device suspended
<4>[  185.520836] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  185.566438] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  185.575028] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  185.584139]  0000000000000009 ffff88019828fb20 ffffffff81844cfd ffff88019828fb68
<4>[  185.591584]  ffff88019828fb58 ffffffff8106de6d ffff880198400000 00000000000c6044
<4>[  185.599031]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828fbb8
<4>[  185.606478] Call Trace:
<4>[  185.608924]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  185.614058]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  185.620060]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  185.625814]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  185.633634]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  185.639548]  [<ffffffffa0132274>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  185.646590]  [<ffffffffa01470c0>] intel_modeset_check_state+0x370/0x7c0 [i915]
<4>[  185.653801]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  185.659890]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  185.666754]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  185.673968]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  185.680312]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  185.686056]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  185.692659]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  185.698140]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  185.703709]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  185.708757]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  185.714757] ---[ end trace 3b79dbaad8e66929 ]---
<4>[  185.719365] ------------[ cut here ]------------
<4>[  185.723988] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:10200 intel_modeset_check_state+0x5c2/0x7c0 [i915]()
<4>[  185.737081] pll on state mismatch (expected 0, found 1)
<4>[  185.742294] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  185.787892] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  185.796486] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  185.805603]  0000000000000009 ffff88019828fba0 ffffffff81844cfd ffff88019828fbe8
<4>[  185.813050]  ffff88019828fbd8 ffffffff8106de6d ffff880199515800 ffff88019828fc58
<4>[  185.820496]  ffff880199515b70 ffff880198400000 ffff8801984082a8 ffff88019828fc38
<4>[  185.827943] Call Trace:
<4>[  185.830389]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  185.835522]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  185.841524]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  185.847271]  [<ffffffffa0132274>] ? ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  185.854486]  [<ffffffffa0147312>] intel_modeset_check_state+0x5c2/0x7c0 [i915]
<4>[  185.861698]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  185.867785]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  185.874650]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  185.881863]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  185.888207]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  185.893951]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  185.900555]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  185.906035]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  185.911596]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  185.916645]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  185.922644] ---[ end trace 3b79dbaad8e6692a ]---
<4>[  185.927252] ------------[ cut here ]------------
<4>[  185.931872] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  185.945229] Device suspended
<4>[  185.948111] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  185.993712] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  186.002302] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  186.011411]  0000000000000009 ffff88019828fb20 ffffffff81844cfd ffff88019828fb68
<4>[  186.018859]  ffff88019828fb58 ffffffff8106de6d ffff880198400000 00000000000c6018
<4>[  186.026304]  ffff880199515b70 ffff880198400080 0000000000000001 ffff88019828fbb8
<4>[  186.033751] Call Trace:
<4>[  186.036197]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  186.041331]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  186.047333]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  186.053078]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  186.060899]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  186.066811]  [<ffffffffa0132226>] ibx_pch_dpll_get_hw_state+0x36/0xa0 [i915]
<4>[  186.073855]  [<ffffffffa01470c0>] intel_modeset_check_state+0x370/0x7c0 [i915]
<4>[  186.081065]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  186.087155]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  186.094017]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  186.101232]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  186.107579]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  186.113321]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  186.119924]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  186.125406]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  186.130973]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  186.136022]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  186.142022] ---[ end trace 3b79dbaad8e6692b ]---
<4>[  186.146630] ------------[ cut here ]------------
<4>[  186.151250] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  186.164605] Device suspended
<4>[  186.167480] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  186.213080] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  186.221672] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  186.230790]  0000000000000009 ffff88019828fb20 ffffffff81844cfd ffff88019828fb68
<4>[  186.238234]  ffff88019828fb58 ffffffff8106de6d ffff880198400000 00000000000c6048
<4>[  186.245683]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828fbb8
<4>[  186.253129] Call Trace:
<4>[  186.255573]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  186.260709]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  186.266710]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  186.272455]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  186.280275]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  186.286190]  [<ffffffffa013224e>] ibx_pch_dpll_get_hw_state+0x5e/0xa0 [i915]
<4>[  186.293232]  [<ffffffffa01470c0>] intel_modeset_check_state+0x370/0x7c0 [i915]
<4>[  186.300445]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  186.306532]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  186.313398]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  186.320610]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  186.326955]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  186.332697]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  186.339301]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  186.344775]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  186.350341]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  186.355383]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  186.361382] ---[ end trace 3b79dbaad8e6692c ]---
<4>[  186.365991] ------------[ cut here ]------------
<4>[  186.370613] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_uncore.c:47 assert_device_not_suspended+0x43/0x50 [i915]()
<4>[  186.383965] Device suspended
<4>[  186.386839] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  186.432441] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  186.441032] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  186.450149]  0000000000000009 ffff88019828fb20 ffffffff81844cfd ffff88019828fb68
<4>[  186.457594]  ffff88019828fb58 ffffffff8106de6d ffff880198400000 00000000000c604c
<4>[  186.465041]  00000000ffffffff ffff880198400080 0000000000000001 ffff88019828fbb8
<4>[  186.472491] Call Trace:
<4>[  186.474934]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  186.480068]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  186.486062]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  186.491808]  [<ffffffffa012b8c3>] assert_device_not_suspended+0x43/0x50 [i915]
<4>[  186.499627]  [<ffffffffa012d235>] gen6_read32+0x35/0x120 [i915]
<4>[  186.505543]  [<ffffffffa0132274>] ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  186.512583]  [<ffffffffa01470c0>] intel_modeset_check_state+0x370/0x7c0 [i915]
<4>[  186.519796]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  186.525883]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  186.532749]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  186.539962]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  186.546307]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  186.552049]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  186.558654]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  186.564136]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  186.569701]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  186.574744]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  186.580742] ---[ end trace 3b79dbaad8e6692d ]---
<4>[  186.585350] ------------[ cut here ]------------
<4>[  186.589972] WARNING: CPU: 1 PID: 4249 at drivers/gpu/drm/i915/intel_display.c:10200 intel_modeset_check_state+0x5c2/0x7c0 [i915]()
<4>[  186.603067] pll on state mismatch (expected 0, found 1)
<4>[  186.608288] Modules linked in: ipmi_watchdog ipmi_msghandler nfsd auth_rpcgss dm_mod fuse btrfs xor raid6_pq sg sd_mod crct10dif_generic crct10dif_pclmul crc_t10dif crct10dif_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ata_generic pata_acpi snd_hda_intel snd_hda_controller eeepc_wmi snd_hda_codec asus_wmi ata_piix sparse_keymap pata_via i2c_i801 rfkill pcspkr snd_hwdep libata serio_raw i915 snd_pcm snd_timer parport_pc drm_kms_helper tpm_infineon snd parport soundcore drm video wmi
<4>[  186.653888] CPU: 1 PID: 4249 Comm: pm_rpm Tainted: G        W     3.16.0-rc1-00315-g401c58f #1
<4>[  186.662478] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1002 04/01/2011
<4>[  186.671587]  0000000000000009 ffff88019828fba0 ffffffff81844cfd ffff88019828fbe8
<4>[  186.679035]  ffff88019828fbd8 ffffffff8106de6d ffff880199515800 ffff88019828fc58
<4>[  186.686480]  ffff880199515b70 ffff880198400000 ffff8801984082f8 ffff88019828fc38
<4>[  186.693928] Call Trace:
<4>[  186.696372]  [<ffffffff81844cfd>] dump_stack+0x4d/0x66
<4>[  186.701499]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
<4>[  186.707500]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
<4>[  186.713247]  [<ffffffffa0132274>] ? ibx_pch_dpll_get_hw_state+0x84/0xa0 [i915]
<4>[  186.720460]  [<ffffffffa0147312>] intel_modeset_check_state+0x5c2/0x7c0 [i915]
<4>[  186.727673]  [<ffffffffa01475a5>] intel_set_mode+0x25/0x30 [i915]
<4>[  186.733762]  [<ffffffffa014861a>] intel_crtc_set_config+0xa4a/0xda0 [i915]
<4>[  186.740634]  [<ffffffffa00404f1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
<4>[  186.747849]  [<ffffffffa0044093>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[  186.754193]  [<ffffffffa0034a10>] drm_ioctl+0x1e0/0x5f0 [drm]
<4>[  186.759937]  [<ffffffffa0043e10>] ? drm_mode_setplane+0x470/0x470 [drm]
<4>[  186.766539]  [<ffffffff811e71c0>] do_vfs_ioctl+0x2f0/0x4f0
<4>[  186.772012]  [<ffffffff81385246>] ? file_has_perm+0x86/0xa0
<4>[  186.777581]  [<ffffffff811e7441>] SyS_ioctl+0x81/0xa0
<4>[  186.782629]  [<ffffffff8184d8a9>] system_call_fastpath+0x16/0x1b
<4>[  186.788630] ---[ end trace 3b79dbaad8e6692e ]---

--dc+cDN39EJAMEtIO--
