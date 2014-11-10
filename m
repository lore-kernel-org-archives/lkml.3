Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKJFg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:36:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:37015 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaKJFgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:36:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,350,1413270000"; 
   d="scan'208";a="629343810"
Date: Mon, 10 Nov 2014 13:36:12 +0800
From: lkp@01.org
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [drm/i915] WARNING: CPU: 0 PID: 1814 at
 drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
Message-ID: <20141110053612.GA1705@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 51e31d49c89055299e34b8f44d13f70e19aaaad1 ("drm/i915: Use generic vblank wait")


+-------------------------+------------+------------+
|                         | 07f11d49f1 | 51e31d49c8 |
+-------------------------+------------+------------+
| boot_successes          | 10         | 0          |
| early-boot-hang         | 1          |            |
| boot_failures           | 0          | 3          |
| BUG:kernel_test_crashed | 0          | 3          |
+-------------------------+------------+------------+


<6>[   25.092524] ipmi message handler version 39.2
<6>[   25.106110] IPMI Watchdog: driver initialized
<4>[   46.024267] ------------[ cut here ]------------
<4>[   46.030029] WARNING: CPU: 0 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   46.045334] vblank not available on crtc 1, ret=-22
<4>[   46.050710] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   46.104497] CPU: 0 PID: 1814 Comm: kms_setmode Not tainted 3.18.0-rc2-g2d81df3 #1
<4>[   46.113099] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   46.121968]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e0ffb8
<4>[   46.129736]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   46.134783]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000804
<4>[   46.138393] Call Trace:
<4>[   46.139060]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   46.141227]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   46.144489]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   46.146830]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   46.150249]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   46.152729]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   46.155166]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   46.158658]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   46.161194]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   46.164606]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   46.167110]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   46.170410]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   46.173103]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   46.175309]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   46.178833]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   46.182285]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   46.184576]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   46.186751]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   46.189103]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   46.191292]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   46.194522] ---[ end trace 7042ddb87f73ead7 ]---
<3>[   51.725259] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g2d81df3 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 29 22:10:11 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 user=lkp job=/lkp/scheduled/lkp-t410/cyclic_piglit-performance-igt-064-x86_64-rhel-HEAD-2d81df3743b43726f849a300250152a9a6bfab48-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 kconfig=x86_64-rhel commit=2d81df3743b43726f849a300250152a9a6bfab48 branch=linux-devel/devel-hourly-2014102921 root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-064/debian-x86_64.cgz/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
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
[    0.000000] BRK [0x0219c000, 0x0219cfff] PGTABLE
[    0.000000] BRK [0x0219d000, 0x0219dfff] PGTABLE
[    0.000000] BRK [0x0219e000, 0x0219efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x66e00000-0x66ffffff]
[    0.000000]  [mem 0x66e00000-0x66ffffff] page 2M
[    0.000000] BRK [0x0219f000, 0x0219ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x64000000-0x66dfffff]
[    0.000000]  [mem 0x64000000-0x66dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x63ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x63ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x67000000-0x7727bfff]
[    0.000000]  [mem 0x67000000-0x771fffff] page 2M
[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
[    0.000000] BRK [0x021a0000, 0x021a0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
[    0.000000] BRK [0x021a1000, 0x021a1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
[    0.000000] RAMDISK: [mem 0x67038000-0x7727bfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140926/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140926/tbfadt-699)
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
[    0.000000] NODE_DATA(0) allocated [mem 0x77746000-0x7776bfff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880064a00000-ffff8800667fffff] on node 0
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
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x777fffff]
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
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
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
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880066e00000 s89088 r8192 d29696 u524288
[    0.000000] pcpu-alloc: s89088 r8192 d29696 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 user=lkp job=/lkp/scheduled/lkp-t410/cyclic_piglit-performance-igt-064-x86_64-rhel-HEAD-2d81df3743b43726f849a300250152a9a6bfab48-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 kconfig=x86_64-rhel commit=2d81df3743b43726f849a300250152a9a6bfab48 branch=linux-devel/devel-hourly-2014102921 root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-064/debian-x86_64.cgz/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 1639236K/1953472K available (8725K kernel code, 1684K rwdata, 3852K rodata, 1820K init, 1888K bss, 314236K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:456 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 7864320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2393.929 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.85 BogoMIPS (lpj=2393929)
[    0.000731] pid_max: default: 32768 minimum: 301
[    0.001047] ACPI: Core revision 20140926
[    0.014444] ACPI: All ACPI Tables successfully acquired
[    0.014925] Security Framework initialized
[    0.015214] SELinux:  Initializing.
[    0.015465] SELinux:  Starting in permissive mode
[    0.015928] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.017071] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.017804] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.018232] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.018951] Initializing cgroup subsys memory
[    0.019293] Initializing cgroup subsys devices
[    0.019634] Initializing cgroup subsys freezer
[    0.019977] Initializing cgroup subsys net_cls
[    0.020318] Initializing cgroup subsys blkio
[    0.020649] Initializing cgroup subsys perf_event
[    0.021005] Initializing cgroup subsys hugetlb
[    0.021365] CPU: Physical Processor ID: 0
[    0.021680] CPU: Processor Core ID: 0
[    0.021980] mce: CPU supports 9 MCE banks
[    0.022304] CPU0: Thermal monitoring enabled (TM1)
[    0.022672] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.022672] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.023559] Freeing SMP alternatives memory: 36K (ffffffff81fb9000 - ffffffff81fc2000)
[    0.025316] ftrace: allocating 31216 entries in 122 pages
[    0.041090] Getting VERSION: 1060015
[    0.041389] Getting VERSION: 1060015
[    0.041681] Getting ID: 0
[    0.041918] Getting ID: 0
[    0.042161] masked ExtINT on CPU#0
[    0.042752] ENABLING IO-APIC IRQs
[    0.043029] init IO_APIC IRQs
[    0.043286]  apic 1 pin 0 not connected
[    0.043597] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.044179] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044759] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.045338] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.045937] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.046518] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.047098] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.047682] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.048263] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.048842] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.049423] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.050012] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.050604] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.051193] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.051785] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.052375] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.052967]  apic 1 pin 16 not connected
[    0.053279]  apic 1 pin 17 not connected
[    0.053592]  apic 1 pin 18 not connected
[    0.053902]  apic 1 pin 19 not connected
[    0.054214]  apic 1 pin 20 not connected
[    0.054525]  apic 1 pin 21 not connected
[    0.054836]  apic 1 pin 22 not connected
[    0.055146]  apic 1 pin 23 not connected
[    0.055596] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066031] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
[    0.066878] Using local APIC timer interrupts.
[    0.066878] calibrating APIC timer ...
[    0.168600] ... lapic delta = 831234
[    0.168892] ... PM-Timer delta = 357948
[    0.169200] ... PM-Timer result ok
[    0.169482] ..... delta 831234
[    0.169745] ..... mult: 35701228
[    0.170018] ..... calibration result: 132997
[    0.170348] ..... CPU clock speed is 2393.0953 MHz.
[    0.170711] ..... host bus clock speed is 132.0997 MHz.
[    0.171131] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.171948] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.172428] ... version:                3
[    0.172744] ... bit width:              48
[    0.173066] ... generic registers:      4
[    0.173384] ... value mask:             0000ffffffffffff
[    0.173774] ... max period:             000000007fffffff
[    0.174164] ... fixed-purpose events:   3
[    0.174480] ... event mask:             000000070000000f
[    0.176462] x86: Booting SMP configuration:
[    0.176790] .... node  #0, CPUs:      #1
[    0.188281] masked ExtINT on CPU#1
[    0.190684] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.191394]  #2
[    0.202658] masked ExtINT on CPU#2
[    0.205114]  #3
[    0.216282] masked ExtINT on CPU#3
[    0.218619] x86: Booted up 1 node, 4 CPUs
[    0.218936] smpboot: Total of 4 processors activated (19151.43 BogoMIPS)
[    0.221901] devtmpfs: initialized
[    0.224521] evm: security.selinux
[    0.224799] evm: security.ima
[    0.225057] evm: security.capability
[    0.225507] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
[    0.226095] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
[    0.226684] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
[    0.227259] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
[    0.227832] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
[    0.229588] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.230196] NET: Registered protocol family 16
[    0.230767] Driver 'dummy' needs an owner
[    0.233156] cpuidle: using governor menu
[    0.233718] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.234278] ACPI: bus type PCI registered
[    0.234595] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.235114] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.235771] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.236748] PCI: Using configuration type 1 for base access
[    0.241560] ACPI: Added _OSI(Module Device)
[    0.241887] ACPI: Added _OSI(Processor Device)
[    0.242230] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.242585] ACPI: Added _OSI(Processor Aggregator Device)
[    0.244319] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
[    0.244925] ACPI : EC: EC description table is found, configuring boot EC
[    0.249396] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.326086] ACPI: Dynamic OEM Table Load:
[    0.326511] ACPI: SSDT 0xFFFF880063A30800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
[    0.327684] ACPI: Dynamic OEM Table Load:
[    0.328107] ACPI: SSDT 0xFFFF880063A31000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
[    0.336307] ACPI: Dynamic OEM Table Load:
[    0.336734] ACPI: SSDT 0xFFFF880063431000 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
[    0.341187] ACPI: Dynamic OEM Table Load:
[    0.341608] ACPI: SSDT 0xFFFF880063434000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
[    0.347649] ACPI: Interpreter enabled
[    0.347955] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.348709] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.349473] ACPI: (supports S0 S3 S4 S5)
[    0.349786] ACPI: Using IOAPIC for interrupt routing
[    0.350180] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.356391] ACPI: Power Resource [PUBS] (on)
[    0.357432] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.359501] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.361890] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.363116] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.364339] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.365555] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.366774] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.367995] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.369216] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.370438] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.371669] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.372100] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.372699] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.373208] PCI host bridge to bus 0000:ff
[    0.373532] pci_bus 0000:ff: root bus resource [bus ff]
[    0.373924] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.374407] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.374886] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.375356] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.375828] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.376300] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.376798] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.377826] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.378575] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.379141] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.379793] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.380361] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.380921] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.381540] PCI host bridge to bus 0000:00
[    0.381865] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.382265] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.382706] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.383145] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.383623] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.384103] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.384581] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
[    0.385058] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.385541] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.385985] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.386592] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.387032] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.387509] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.388050] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
[    0.388561] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.389020] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
[    0.389583] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.390090] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.390539] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
[    0.390955] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
[    0.391560] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    0.392012] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
[    0.392462] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
[    0.392914] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
[    0.393403] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.393873] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.394323] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.394775] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
[    0.395324] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.395794] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.396251] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.396702] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.397287] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.397770] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.398218] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.398756] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.399230] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.399680] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.400215] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.400689] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.401140] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.401673] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.402147] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.402597] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.403133] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.403605] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.404063] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.404514] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
[    0.405066] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.405535] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.405984] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.406544] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    0.407143] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    0.407596] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.408011] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
[    0.408424] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
[    0.408838] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
[    0.409251] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.409663] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
[    0.410173] pci 0000:00:1f.2: PME# supported from D3hot
[    0.410627] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.411076] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
[    0.411573] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
[    0.412068] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.412522] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
[    0.413203] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.413677] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
[    0.414147] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.414823] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.417755] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.418135] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.418706] acpiphp: Slot [1] registered
[    0.419026] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.419415] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.419856] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.420335] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.421045] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
[    0.421541] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.422104] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
[    0.422774] pci 0000:0d:00.0: supports D1 D2
[    0.423104] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.423741] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
[    0.424239] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
[    0.424897] pci 0000:0d:00.1: supports D1 D2
[    0.425228] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.425862] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
[    0.426361] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
[    0.427019] pci 0000:0d:00.3: supports D1 D2
[    0.427349] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.429818] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.430198] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.430760] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
[    0.431243] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.431821] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.432397] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.433013] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.433629] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.434246] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
[    0.434864] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
[    0.435690] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    0.437488] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.437955] Driver 'ec' needs an owner
[    0.438263] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.438970] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.439382] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.439975] vgaarb: loaded
[    0.440219] vgaarb: bridge control possible 0000:00:02.0
[    0.440694] SCSI subsystem initialized
[    0.441010] Driver 'Generic PHY' needs an owner
[    0.441312] Driver 'Generic 10G PHY' needs an owner<6>
[    0.441743] ACPI: bus type USB registered
[    0.442112] Driver 'usbfs' needs an owner
[    0.442386] usbcore: registered new interface driver usbfs
[    0.442888] Driver 'hub' needs an owner
[    0.443150] usbcore: registered new interface driver hub
[    0.443654] Driver 'usb' needs an owner
[    0.443918] usbcore: registered new device driver usb
[    0.444415] pps_core: LinuxPPS API ver. 1 registered
[    0.444785] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.445433] PTP clock support registered
[    0.445857] PCI: Using ACPI for IRQ routing
[    0.456086] PCI: pci_cache_line_size set to 64 bytes
[    0.456625] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.457056] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
[    0.457490] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
[    0.457922] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
[    0.458353] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
[    0.458780] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
[    0.459207] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
[    0.459757] NetLabel: Initializing
[    0.460039] NetLabel:  domain hash size = 128
[    0.460375] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.460760] NetLabel:  unlabeled traffic allowed by default
[    0.461313] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.462202] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.464662] Switched to clocksource hpet
[    0.475295] Driver 'system' needs an owner
[    0.475590] pnp: PnP ACPI init
[    0.477434] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.477924] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.478405] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.478893] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.479354] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.479823] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.480304] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.480792] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.481273] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.481761] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.482242] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.482730] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.483212] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
[    0.483701] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.484183] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.484666] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.485461] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.485895] system 00:01: [io  0x1000-0x107f] could not be reserved
[    0.486928] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.487353] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.487782] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.488206] system 00:01: [io  0x1600-0x1641] has been reserved
[    0.488629] system 00:01: [io  0x1644-0x167f] could not be reserved
[    0.489080] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.489543] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.490011] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.490474] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.490942] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.491405] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.491874] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.492387] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    0.492992] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.493460] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
[    0.494063] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.494531] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
[    0.495145] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.495982] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.497217] pnp: PnP ACPI: found 6 devices
[    0.504823] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.505208] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.505583] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.506072] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.506458] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.506903] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.507378] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.507956] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.508329] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.508816] pci 0000:00:1e.0: PCI bridge to [bus 0e]
[    0.509198] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.509602] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.510013] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.510456] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.510905] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.511348] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.511796] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.512245] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.512689] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.513099] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.513543] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.514090] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.514536] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.514947] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.515353] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.515805] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.516249] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.516701] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.517146] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.517624] NET: Registered protocol family 2
[    0.518163] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.518773] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.519313] TCP: Hash tables configured (established 16384 bind 16384)
[    0.519809] TCP: reno registered
[    0.520087] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.520530] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.521046] NET: Registered protocol family 1
[    0.521480] RPC: Registered named UNIX socket transport module.
[    0.521911] RPC: Registered udp transport module.
[    0.522264] RPC: Registered tcp transport module.
[    0.522618] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.523093] pci 0000:00:02.0: Video device with shadowed ROM
[    0.523585] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    0.524317] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    0.525050] PCI: CLS 64 bytes, default 64
[    0.525425] Unpacking initramfs...
[    4.864718] Freeing initrd memory: 264464K (ffff880067038000 - ffff88007727c000)
[    4.865437] Simple Boot Flag at 0x35 set to 0x1
[    4.866567] Driver 'alarmtimer' needs an owner
[    4.866960] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    4.867537] Initialise system trusted keyring
[    4.867891] audit: initializing netlink subsys (disabled)
[    4.868306] audit: type=2000 audit(1414623088.641:1): initialized
[    4.869080] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.871037] zpool: loaded
[    4.871276] zbud: loaded
[    4.871709] VFS: Disk quotas dquot_6.5.2
[    4.872056] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.873045] SGI XFS with ACLs, security attributes, no debug enabled
[    4.873942] 9p: Installing v9fs 9p2000 file system support
[    4.874374] msgmni has been set to 3718
[    4.874750] Key type big_key registered
[    4.875058] SELinux:  Registering netfilter hooks
[    4.876311] NET: Registered protocol family 38
[    4.876668] Key type asymmetric registered
[    4.876992] Asymmetric key parser 'x509' registered
[    4.877404] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    4.878008] io scheduler noop registered
[    4.878323] io scheduler deadline registered (default)
[    4.878722] io scheduler cfq registered
[    4.879115] Driver 'pcieport' needs an owner
[    4.879507] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    4.880313] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    4.881019] IOAPIC[0]: Set routing entry (1-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    4.881807] Driver 'aer' needs an owner
[    4.882072] Driver 'pcie_pme' needs an ownerDriver 'ioapic' needs an owner
[    4.882675] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.883184] Driver 'pciehp_dummy' needs an owner
[    4.883501] Driver 'pciehp' needs an owner<6>
[    4.883876] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.884383] Driver 'pci-stub' needs an owner
[    4.884760] Driver 'vesa-framebuffer' needs an ownerDriver 'efi-framebuffer' needs an owner
[    4.885486] intel_idle: MWAIT substates: 0x1120
[    4.885932] intel_idle: v0.4 model 0x25
[    4.886239] intel_idle: lapic_timer_reliable_states 0xffffffff
[    4.886826] Driver 'ac' needs an owner
[    4.887692] ACPI: AC Adapter [AC] (on-line)
[    4.888162] Driver 'button' needs an owner
[    4.888885] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    4.890131] ACPI: Lid Switch [LID]
[    4.890533] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    4.891139] ACPI: Sleep Button [SLPB]
[    4.891535] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    4.892083] ACPI: Power Button [PWRF]
[    4.892415] Driver 'acpi-fan' needs an owner
[    4.892727] Driver 'processor' needs an ownerDriver 'thermal' needs an owner
[    4.898622] thermal LNXTHERM:00: registered as thermal_zone0
[    4.899137] ACPI: Thermal Zone [THM0] (55 C)
[    4.899527] Driver 'hardware_error_device' needs an owner
[    4.899719] Driver 'battery' needs an owner<6>
[    4.900014] ACPI: Battery Slot [BAT0] (battery absent)
[    4.900771] GHES: HEST is not enabled!
[    4.901179] Driver 'virtio-pci' needs an owner
[    4.901512] Driver 'virtio_balloon' needs an ownerDriver 'xen-platform-pci' needs an owner
[    4.902472] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.903039] Driver 'serial' needs an owner
[    4.904280] Driver 'serial8250' needs an ownerDriver 'serial' needs an owner
[    4.905063] IOAPIC[0]: Set routing entry (1-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    4.906071] console [ttyS0] disabled
[    4.926904] serial 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
[    5.869047] tsc: Refined TSC clocksource calibration: 2393.998 MHz
[    6.826913] console [ttyS0] enabled
[    6.828923] Driver 'virtio_console' needs an owner
[    6.830740] Driver 'virtio_rproc_serial' needs an ownerDriver 'hpet' needs an owner
[    6.834502] Non-volatile memory driver v1.3
[    6.836521] Driver 'virtio_rng' needs an owner
[    6.838604] Linux agpgart interface v0.103
[    6.840432] Driver 'agpgart-amd64' needs an owner
[    6.842526] Driver 'agpgart-intel' needs an owner<6>
[    6.844641] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    6.847963] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    6.852279] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    6.854391] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    6.857792] Driver 'agpgart-sis' needs an owner
[    6.859712] Driver 'agpgart-via' needs an ownerDriver 'tpm_tis' needs an owner
[    6.863973] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    6.869785] Switched to clocksource tsc
[    6.902748] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
[    6.905931] Driver 'virtio_blk' needs an owner
[    6.908025] Driver 'mei_me' needs an owner<7>
[    6.909837] IOAPIC[0]: Set routing entry (1-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    6.912671] mei_me 0000:00:16.0: irq 24 for MSI/MSI-X
[    6.916899] Driver 'lpc_ich' needs an ownerACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140926/utaddress-258)
[    6.927227] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.931577] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    6.939246] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.943667] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    6.951447] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.955679] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
[    6.963641] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.967850] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.971158] rdac: device handler registered
[    6.973149] hp_sw: device handler registered
[    6.975023] emc: device handler registered
[    6.976927] alua: device handler registered
[    6.978940] libphy: Fixed MDIO Bus: probed
[    6.980785] Driver 'virtio_net' needs an owner
[    6.981954] Driver 'tg3' needs an ownerDriver 'tulip' needs an owner
[    6.985255] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.988823] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.991164] Driver 'e1000' needs an owner
[    6.993117] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.995414] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    6.997776] Driver 'e1000e' needs an owner
[    6.999851] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    7.003889] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    7.189746] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
[    7.193055] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.196564] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    7.199179] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[    7.202617] igb: Copyright (c) 2007-2014 Intel Corporation.
[    7.204938] Driver 'igb' needs an owner
[    7.206780] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    7.210491] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    7.212830] Driver 'ixgbe' needs an owner
[    7.214659] Driver '8139cp' needs an ownerDriver '8139too' needs an owner
[    7.218231] Driver 'r8169' needs an ownerDriver 'catc' needs an owner
[    7.220677] usbcore: registered new interface driver catc
[    7.223225] Driver 'kaweth' needs an owner
[    7.224858] usbcore: registered new interface driver kaweth
[    7.227163] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    7.230801] Driver 'pegasus' needs an owner
[    7.232720] usbcore: registered new interface driver pegasus
[    7.235050] Driver 'rtl8150' needs an owner
[    7.236937] usbcore: registered new interface driver rtl8150
[    7.240140] Driver 'asix' needs an owner
[    7.241197] usbcore: registered new interface driver asix
[    7.244263] Driver 'cdc_ether' needs an owner
[    7.246196] usbcore: registered new interface driver cdc_ether
[    7.248698] Driver 'cdc_eem' needs an owner
[    7.250594] usbcore: registered new interface driver cdc_eem
[    7.252832] Driver 'dm9601' needs an owner
[    7.254720] usbcore: registered new interface driver dm9601
[    7.257003] Driver 'smsc75xx' needs an owner
[    7.259075] usbcore: registered new interface driver smsc75xx
[    7.262198] Driver 'smsc95xx' needs an owner
[    7.263407] usbcore: registered new interface driver smsc95xx
[    7.266520] Driver 'gl620a' needs an owner
[    7.268408] usbcore: registered new interface driver gl620a
[    7.270724] Driver 'net1080' needs an owner
[    7.272637] usbcore: registered new interface driver net1080
[    7.274988] Driver 'plusb' needs an owner
[    7.276847] usbcore: registered new interface driver plusb
[    7.279153] Driver 'rndis_host' needs an owner
[    7.281114] usbcore: registered new interface driver rndis_host
[    7.284380] Driver 'cdc_subset' needs an owner
[    7.286353] usbcore: registered new interface driver cdc_subset
[    7.288881] Driver 'zaurus' needs an owner
[    7.290665] usbcore: registered new interface driver zaurus
[    7.292973] Driver 'MOSCHIP usb-ethernet driver' needs an owner
[    7.295348] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    7.299087] Driver 'int51x1' needs an owner
[    7.300873] usbcore: registered new interface driver int51x1
[    7.303360] Driver 'ipheth' needs an owner
[    7.305099] usbcore: registered new interface driver ipheth
[    7.308641] Driver 'sierra_net' needs an owner
[    7.310270] usbcore: registered new interface driver sierra_net
[    7.312912] Driver 'xhci_hcd' needs an owner
[    7.314614] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.317216] ehci-pci: EHCI PCI platform driver
[    7.319242] Driver 'ehci-pci' needs an owner
[    7.321304] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    7.323616] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.327008] ehci-pci 0000:00:1a.0: debug port 2
[    7.332995] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    7.336505] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
[    7.344001] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.346241] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.349625] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.352374] usb usb1: Product: EHCI Host Controller
[    7.355304] usb usb1: Manufacturer: Linux 3.18.0-rc2-g2d81df3 ehci_hcd
[    7.357847] usb usb1: SerialNumber: 0000:00:1a.0
[    7.360181] hub 1-0:1.0: USB hub found
[    7.361750] hub 1-0:1.0: 3 ports detected
[    7.364014] IOAPIC[0]: Set routing entry (1-19 -> 0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    7.367483] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    7.369792] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.372454] ehci-pci 0000:00:1d.0: debug port 2
[    7.378342] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    7.381946] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
[    7.390028] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.393588] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.396050] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.399612] usb usb2: Product: EHCI Host Controller
[    7.401734] usb usb2: Manufacturer: Linux 3.18.0-rc2-g2d81df3 ehci_hcd
[    7.404370] usb usb2: SerialNumber: 0000:00:1d.0
[    7.406561] hub 2-0:1.0: USB hub found
[    7.408180] hub 2-0:1.0: 3 ports detected
[    7.410250] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.412484] ohci-pci: OHCI PCI platform driver
[    7.414585] Driver 'ohci-pci' needs an owner
[    7.416433] uhci_hcd: USB Universal Host Controller Interface driver
[    7.419819] Driver 'uhci_hcd' needs an owner
[    7.421761] Driver 'usbserial' needs an owner<6>
[    7.423765] usbcore: registered new interface driver usbserial
[    7.426081] Driver 'usbserial_generic' needs an owner
[    7.428166] usbcore: registered new interface driver usbserial_generic
[    7.431620] Driver 'generic' needs an owner
[    7.433589] usbserial: USB Serial support registered for generic
[    7.435941] Driver 'i8042 kbd' needs an owner
[    7.437924] Driver 'i8042 aux' needs an owner<6>
[    7.439886] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    7.443820] Driver 'i8042' needs an owner
[    7.448019] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.449689] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.452189] mousedev: PS/2 mouse device common for all mice
[    7.454714] Driver 'atkbd' needs an owner
[    7.456098] Driver 'psmouse' needs an ownerDriver 'rtc_cmos' needs an owner
[    7.459609] rtc_cmos 00:02: RTC can wake from S4
[    7.461826] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    7.462743] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    7.467993] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    7.471648] Driver 'i6300ESB timer' needs an owner
[    7.473804] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    7.476006] Driver 'iTCO_wdt' needs an owner
[    7.477976] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
[    7.480800] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.483944] iTCO_vendor_support: vendor-support=0
[    7.486218] hidraw: raw HID events driver (C) Jiri Kosina
[    7.488182] Driver 'hid-generic' needs an owner
[    7.490182] Driver 'a4tech' needs an ownerDriver 'apple' needs an owner
[    7.493711] Driver 'belkin' needs an ownerDriver 'cherry' needs an owner
[    7.496265] Driver 'chicony' needs an ownerDriver 'cypress' needs an owner
[    7.499684] Driver 'ezkey' needs an ownerDriver 'kensington' needs an owner
[    7.502331] Driver 'logitech' needs an ownerDriver 'magicmouse' needs an owner
[    7.505873] Driver 'microsoft' needs an ownerDriver 'monterey' needs an owner
[    7.509001] Driver 'ntrig' needs an ownerDriver 'usbhid' needs an owner
[    7.512028] usbcore: registered new interface driver usbhid
[    7.514441] usbhid: USB HID core driver
[    7.516179] Driver 'pvpanic' needs an owner
[    7.518094] drop_monitor: Initializing network drop monitor service
[    7.520669] TCP: cubic registered
[    7.522310] Initializing XFRM netlink socket
[    7.524459] NET: Registered protocol family 10
[    7.526804] NET: Registered protocol family 17
[    7.528364] 9pnet: Installing 9P2000 support
[    7.530283] Driver '9pnet_virtio' needs an owner
[    7.532996] 
[    7.532996] printing PIC contents
[    7.535408] ... PIC  IMR: ffff
[    7.537044] ... PIC  IRR: 0800
[    7.538823] ... PIC  ISR: 0000
[    7.539735] ... PIC ELCR: 0800
[    7.541189] printing local APIC contents on CPU#0/0:
[    7.543251] ... APIC ID:      00000000 (0)
[    7.545173] ... APIC VERSION: 01060015
[    7.546961] ... APIC TASKPRI: 00000000 (00)
[    7.549016] ... APIC PROCPRI: 00000000
[    7.550738] ... APIC LDR: 01000000
[    7.551698] ... APIC DFR: ffffffff
[    7.553347] ... APIC SPIV: 000001ff
[    7.555124] ... APIC ISR field:
[    7.556765] 0000000000000000000000000000000000000000000000000000000000000000
[    7.559777] ... APIC TMR field:
[    7.561073] 0000000002000000000200020002000200000002000000000002000000000000
[    7.564733] ... APIC IRR field:
[    7.565604] 0000000010000000000000000000000000000000000000000000000000000000
[    7.569165] ... APIC ESR: 00000000
[    7.570705] ... APIC ICR: 000008fd
[    7.571681] ... APIC ICR2: 08000000
[    7.573368] ... APIC LVTT: 000000ef
[    7.575103] ... APIC LVTPC: 00000400
[    7.576877] ... APIC LVT0: 00010700
[    7.578710] ... APIC LVT1: 00000400
[    7.579685] ... APIC LVTERR: 000000fe
[    7.581329] ... APIC TMICT: 005d67da
[    7.583102] ... APIC TMCCT: 005700af
[    7.584891] ... APIC TDCR: 00000003
[    7.586667] 
[    7.587132] number of MP IRQ sources: 15.
[    7.589020] number of IO-APIC #1 registers: 24.
[    7.590988] testing the IO APIC.......................
[    7.593147] IO APIC #1......
[    7.594758] .... register #00: 02000000
[    7.595845] .......    : physical APIC id: 02
[    7.597726] .......    : Delivery Type: 0
[    7.599709] .......    : LTS          : 0
[    7.601529] .... register #01: 00170020
[    7.603393] .......     : max redirection entries: 17
[    7.605498] .......     : PRQ implemented: 0
[    7.607471] .......     : IO APIC version: 20
[    7.609602] .... IRQ redirection table:
[    7.611311] 1    0    0   0   0    0    0    00
[    7.613341] 0    0    0   0   0    1    1    31
[    7.615357] 0    0    0   0   0    1    1    30
[    7.617371] 0    0    0   0   0    1    1    33
[    7.619462] 0    0    0   0   0    1    1    34
[    7.621483] 0    0    0   0   0    1    1    35
[    7.623459] 0    0    0   0   0    1    1    36
[    7.625504] 0    0    0   0   0    1    1    37
[    7.627511] 0    0    0   0   0    1    1    38
[    7.629563] 0    1    0   0   0    1    1    39
[    7.631530] 0    0    0   0   0    1    1    3A
[    7.633581] 0    0    0   0   0    1    1    3B
[    7.635656] 0    0    0   0   0    1    1    3C
[    7.637620] 0    0    0   0   0    1    1    3D
[    7.639718] 0    0    0   0   0    1    1    3E
[    7.641671] 0    0    0   0   0    1    1    3F
[    7.643734] 1    1    0   1   0    1    1    A1
[    7.645741] 1    1    0   1   0    1    1    91
[    7.647746] 1    0    0   0   0    0    0    00
[    7.649858] 0    1    0   1   0    1    1    D1
[    7.651768] 1    1    0   1   0    1    1    61
[    7.653893] 1    1    0   1   0    1    1    71
[    7.655834] 1    0    0   0   0    0    0    00
[    7.657848] 0    1    0   1   0    1    1    81
[    7.660769] IRQ to pin mappings:
[    7.661724] IRQ0 -> 0:2
[    7.663223] IRQ1 -> 0:1
[    7.664117] IRQ3 -> 0:3
[    7.665136] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    7.667708] 
[    7.669029] IRQ4 -> 0:4
[    7.669870] IRQ5 -> 0:5
[    7.671201] IRQ6 -> 0:6
[    7.672026] IRQ7 -> 0:7
[    7.673465] IRQ8 -> 0:8
[    7.674319] IRQ9 -> 0:9
[    7.675446] IRQ10 -> 0:10
[    7.676959] IRQ11 -> 0:11
[    7.677800] IRQ12 -> 0:12
[    7.679264] IRQ13 -> 0:13
[    7.680089] IRQ14 -> 0:14
[    7.681384] IRQ15 -> 0:15
[    7.682817] IRQ16 -> 0:16
[    7.683637] IRQ17 -> 0:17
[    7.685147] IRQ19 -> 0:19
[    7.685999] IRQ20 -> 0:20
[    7.687351] IRQ21 -> 0:21
[    7.688193] IRQ23 -> 0:23
[    7.689620] .................................... done.
[    7.692284] Loading compiled-in X.509 certificates
[    7.695890] Loaded X.509 cert 'Magrathea: Glacier signing key: 67a86f1d43874f1f36ff60e119628b2a14bbaf77'
[    7.700015] registered taskstats version 1
[    7.705354] Key type trusted registered
[    7.709589] Key type encrypted registered
[    7.712157] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    7.719224] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
[    7.721721] ima: No TPM chip found, activating TPM-bypass!
[    7.724943] evm: HMAC attrs: 0x1
[    7.726700] rtc_cmos 00:02: setting system clock to 2014-10-29 22:51:32 UTC (1414623092)
[    7.779625] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    7.783057] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.786365] hub 1-1:1.0: USB hub found
[    7.787851] hub 1-1:1.0: 6 ports detected
[    7.828983] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    7.831106] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.832881] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    7.837272] hub 2-1:1.0: USB hub found
[    7.838858] hub 2-1:1.0: 8 ports detected
[    7.933394] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    7.935036] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.064615] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
[    8.154020] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    8.156460] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.160288] usb 1-1.3: Product: Biometric Coprocessor
[    8.162318] usb 1-1.3: Manufacturer: UPEK
[    8.238724] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    8.332469] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[    8.334542] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.338170] usb 1-1.6: Product: Integrated Camera
[    8.340290] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    8.455709] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
[    8.461660] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    8.515396] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[   10.386327] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   10.396913] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.407869] Sending DHCP requests .., OK
[   12.957543] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
[   12.974349] IP-Config: Complete:
[   12.979419]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
[   12.999889]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
[   13.008108]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   13.017423]      nameserver0=192.168.1.1
[   13.019783] PM: Hibernation image not present or could not be loaded.
[   13.023356] Freeing unused kernel memory: 1820K (ffffffff81df2000 - ffffffff81fb9000)
[   13.248233] Driver 'wmi' needs an owner
[   13.252294] wmi: Mapper loaded
[   13.256707] [drm] Initialized drm 1.1.0 20060810
[   13.272348] Linux video capture interface: v2.00
[   13.284315] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[   13.300379] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
[   13.331718] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   13.334123] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   13.344367] Driver 'parport_pc' needs an owner
[   13.346383] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[   13.352265] sdhci: Secure Digital Host Controller Interface driver
[   13.354357] sdhci: Copyright(c) Pierre Ossman
[   13.361860] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input7
[   13.362092] libata version 3.00 loaded.
[   13.368474] usbcore: registered new interface driver uvcvideo
[   13.370518] USB Video Class driver (1.1.1)
[   13.380638] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[   13.384873] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[   13.388607] ahci 0000:00:1f.2: version 3.0
[   13.388653] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   13.388663] sdhci-pci 0000:0d:00.0: No vmmc regulator found
[   13.388665] sdhci-pci 0000:0d:00.0: No vqmmc regulator found
[   13.393681] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[   13.402818] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[   13.404509] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[   13.406314] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[   13.406316] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.406317] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
[   13.406319] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
[   13.409449] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[   13.410283] thinkpad_acpi: radio switch found; radios are disabled
[   13.410518] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   13.410519] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   13.422394] Driver 'thinkpad_hotkey' needs an owner
[   13.422395] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[   13.438236] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[   13.441913] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
[   13.446872] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   13.451173] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   13.452906] scsi host0: ahci
[   13.453141] scsi host1: ahci
[   13.453327] scsi host2: ahci
[   13.453506] scsi host3: ahci
[   13.453719] scsi host4: ahci
[   13.453925] scsi host5: ahci
[   13.454023] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 26
[   13.454027] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 26
[   13.454028] ata3: DUMMY
[   13.454029] ata4: DUMMY
[   13.454032] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 26
[   13.454034] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 26
[   13.454332] snd_hda_intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[   13.455617] [drm] Memory usable by graphics device = 2048M
[   13.455618] [drm] Replacing VGA console driver
[   13.485597] Console: switching to colour dummy device 80x25
[   13.487790] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[   13.500938] i915 0000:00:02.0: irq 28 for MSI/MSI-X
[   13.503359] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   13.506615] [drm] Driver supports precise vblank timestamp query.
[   13.509732] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.514373] sound hdaudioC0D0: CX20585: BIOS auto-probing.
[   13.517258] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[   13.520380] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.523776] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
[   13.526237] sound hdaudioC0D0:    mono: mono_out=0x0
[   13.528428] sound hdaudioC0D0:    inputs:
[   13.530308] sound hdaudioC0D0:      Internal Mic=0x23
[   13.532463] sound hdaudioC0D0:      Mic=0x1b
[   13.534535] sound hdaudioC0D0:      Dock Mic=0x1a
[   13.537852] sound hdaudioC0D0: Enable sync_write for stable communication
[   13.554475] Driver 'video' needs an owner
[   13.562174] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   13.565901] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   13.569132] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   13.573548] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   13.577634] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   13.581872] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   13.584269] acpi device:01: registered as cooling_device4
[   13.584490] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input16
[   13.584801] [drm] Initialized i915 1.6.0 20141024 for 0000:00:02.0 on minor 0
[   13.595748] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   13.599805] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   13.619792] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[   13.631765] fbcon: inteldrmfb (fb0) is primary device
[   13.633912] input: PC Speaker as /devices/platform/pcspkr/input/input17
[   13.637375] Error: Driver 'pcspkr' is already registered, aborting...
[   13.758826] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.886193] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
[   13.914077] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   13.915878] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.915882] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   13.916035] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.916039] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   13.917789] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
[   13.917792] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   13.919920] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.919924] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   13.920042] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.920045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   13.921625] ata1.00: configured for UDMA/100
[   13.921900] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
[   14.012939] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
[   14.139318] Console: switching to colour frame buffer device 160x50
[   14.207477] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   14.209954] i915 0000:00:02.0: registered panic notifier
[   14.382334] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.393490] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   14.401201] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   14.406283] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
[   14.423825] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   14.433633] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   14.440781] ata2.00: configured for UDMA/100
[   14.461048] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
[   14.792629] ata5: SATA link down (SStatus 0 SControl 300)
[   15.100820] ata6: SATA link down (SStatus 0 SControl 300)
[   15.126895] Driver 'sd' needs an owner
[   15.128955] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   15.137502] sd 0:0:0:0: [sda] Write Protect is off
[   15.141518] Driver 'sr' needs an owner
[   15.141518] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.148620] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.169608] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   15.175545] cdrom: Uniform CD-ROM driver Revision: 3.20
[   15.180160] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   15.190298] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.194170] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   15.573204]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   15.581973] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.728943] random: nonblocking pool is initialized
[   16.614639] raid6: sse2x1    2902 MB/s
[   16.637646] raid6: sse2x2    3417 MB/s
[   16.661669] raid6: sse2x4    3808 MB/s
[   16.668196] raid6: using algorithm sse2x4 (3808 MB/s)
[   16.675729] raid6: using ssse3x2 recovery algorithm
[   16.686162] xor: measuring software checksum speed
[   16.704724]    prefetch64-sse:  4944.000 MB/sec
[   16.720735]    generic_sse:  4364.000 MB/sec
[   16.724931] xor: using function: prefetch64-sse (4944.000 MB/sec)
[   16.767140] Btrfs loaded
[   16.772424] BTRFS: device fsid 8886adc6-3306-411a-bbf8-6638ebb74746 devid 1 transid 57 /dev/sda6
[   18.535034] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.18.0-rc2-g2d81df3 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 29 22:10:11 CST 2014
<6>[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 user=lkp job=/lkp/scheduled/lkp-t410/cyclic_piglit-performance-igt-064-x86_64-rhel-HEAD-2d81df3743b43726f849a300250152a9a6bfab48-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 kconfig=x86_64-rhel commit=2d81df3743b43726f849a300250152a9a6bfab48 branch=linux-devel/devel-hourly-2014102921 root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-064/debian-x86_64.cgz/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007727bfff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000007727c000-0x0000000077281fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000077282000-0x0000000077362fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000077363000-0x0000000077374fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000077375000-0x00000000773f5fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000773f6000-0x000000007740efff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007740f000-0x000000007746efff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000007746f000-0x0000000077667fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000077668000-0x00000000776e7fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000776e8000-0x000000007770efff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007770f000-0x0000000077716fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000077717000-0x000000007771efff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007776bfff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000007776c000-0x0000000077777fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x0000000077778000-0x000000007777afff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007777b000-0x000000007778afff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000007778b000-0x000000007778bfff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007778c000-0x000000007779efff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000007779f000-0x00000000777fefff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x00000000777ff000-0x00000000777fffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000077800000-0x000000007bffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.6 present.
<7>[    0.000000] DMI: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x77800 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-D3FFF write-protect
<7>[    0.000000]   D4000-DBFFF uncachable
<7>[    0.000000]   DC000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 disabled
<7>[    0.000000]   1 base 078000000 mask FF8000000 uncachable
<7>[    0.000000]   2 base 000000000 mask F80000000 write-back
<7>[    0.000000]   3 disabled
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>[    0.000000] found SMP MP-table at [mem 0x000f68c0-0x000f68cf] mapped at [ffff8800000f68c0]
<4>[    0.000000]   mpc: 9f071-9f17d
<7>[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x0219c000, 0x0219cfff] PGTABLE
<7>[    0.000000] BRK [0x0219d000, 0x0219dfff] PGTABLE
<7>[    0.000000] BRK [0x0219e000, 0x0219efff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x66e00000-0x66ffffff]
<7>[    0.000000]  [mem 0x66e00000-0x66ffffff] page 2M
<7>[    0.000000] BRK [0x0219f000, 0x0219ffff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x64000000-0x66dfffff]
<7>[    0.000000]  [mem 0x64000000-0x66dfffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x63ffffff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x63ffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x67000000-0x7727bfff]
<7>[    0.000000]  [mem 0x67000000-0x771fffff] page 2M
<7>[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
<7>[    0.000000] BRK [0x021a0000, 0x021a0fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
<7>[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
<7>[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
<7>[    0.000000] BRK [0x021a1000, 0x021a1fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
<7>[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
<7>[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
<7>[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
<6>[    0.000000] RAMDISK: [mem 0x67038000-0x7727bfff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
<4>[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
<4>[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140926/tbfadt-618)
<4>[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140926/tbfadt-699)
<4>[    0.000000] ACPI: DSDT 0x00000000777EFED1 00ECE9 (v01 LENOVO TP-6I    00001120 MSFT 03000001)
<4>[    0.000000] ACPI: FACS 0x00000000776E7000 000040
<4>[    0.000000] ACPI: SSDT 0x00000000777EFCB4 00021D (v01 LENOVO TP-6I    00001120 MSFT 03000001)
<4>[    0.000000] ACPI: ECDT 0x00000000777FEBBA 000052 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>[    0.000000] ACPI: APIC 0x00000000777FEC0C 000084 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>[    0.000000] ACPI: MCFG 0x00000000777FECC8 00003C (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>[    0.000000] ACPI: HPET 0x00000000777FED04 000038 (v01 LENOVO TP-6I    00001120 LNVO 00000001)
<4>[    0.000000] ACPI: ASF! 0x00000000777FEDBE 0000A4 (v16 LENOVO TP-6I    00001120 PTL  00000001)
<4>[    0.000000] ACPI: SLIC 0x00000000777FEE62 000176 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>[    0.000000] ACPI: BOOT 0x00000000777FEFD8 000028 (v01 LENOVO TP-6I    00001120  LTP 00000001)
<4>[    0.000000] ACPI: SSDT 0x00000000776E591A 00084B (v01 LENOVO TP-6I    00001120 INTL 20050513)
<4>[    0.000000] ACPI: TCPA 0x000000007778B000 000032 (v02 PTL     CRESTLN 06040000      00005A52)
<4>[    0.000000] ACPI: SSDT 0x000000007777A000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20050513)
<4>[    0.000000] ACPI: SSDT 0x0000000077779000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20050513)
<4>[    0.000000] ACPI: SSDT 0x0000000077778000 00049F (v01 PmRef  ApTst    00003000 INTL 20050513)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000777fffff]
<6>[    0.000000] NODE_DATA(0) allocated [mem 0x77746000-0x7776bfff]
<7>[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880064a00000-ffff8800667fffff] on node 0
<4>[    0.000000] Zone ranges:
<4>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>[    0.000000]   Normal   empty
<4>[    0.000000] Movable zone start for each node
<4>[    0.000000] Early memory node ranges
<4>[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
<4>[    0.000000]   node   0: [mem 0x00100000-0x7727bfff]
<4>[    0.000000]   node   0: [mem 0x77282000-0x77362fff]
<4>[    0.000000]   node   0: [mem 0x7740f000-0x7746efff]
<4>[    0.000000]   node   0: [mem 0x7770f000-0x77716fff]
<4>[    0.000000]   node   0: [mem 0x7771f000-0x7776bfff]
<4>[    0.000000]   node   0: [mem 0x777ff000-0x777fffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00001000-0x777fffff]
<7>[    0.000000] On node 0 totalpages: 488368
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 21 pages reserved
<7>[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 7584 pages used for memmap
<7>[    0.000000]   DMA32 zone: 484371 pages, LIFO batch:31
<6>[    0.000000] Reserving Intel graphics stolen memory at 0x7a000000-0x7bffffff
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x1008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 1, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 1, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 1, APIC INT 01
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 1, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 1, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 1, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 1, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 1, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 1, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 1, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 1, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 1, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 1, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 1, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 1, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<6>[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000d1fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000d2000-0x000d3fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7727c000-0x77281fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x77363000-0x77374fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x77375000-0x773f5fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x773f6000-0x7740efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7746f000-0x77667fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x77668000-0x776e7fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x776e8000-0x7770efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x77717000-0x7771efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7776c000-0x77777fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x77778000-0x7777afff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7777b000-0x7778afff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7778b000-0x7778bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7778c000-0x7779efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7779f000-0x777fefff]
<6>[    0.000000] e820: [mem 0x7c000000-0xdfffffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff880066e00000 s89088 r8192 d29696 u524288
<7>[    0.000000] pcpu-alloc: s89088 r8192 d29696 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<4>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
<4>[    0.000000] Policy zone: DMA32
<5>[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 user=lkp job=/lkp/scheduled/lkp-t410/cyclic_piglit-performance-igt-064-x86_64-rhel-HEAD-2d81df3743b43726f849a300250152a9a6bfab48-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/vmlinuz-3.18.0-rc2-g2d81df3 kconfig=x86_64-rhel commit=2d81df3743b43726f849a300250152a9a6bfab48 branch=linux-devel/devel-hourly-2014102921 root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-064/debian-x86_64.cgz/x86_64-rhel/2d81df3743b43726f849a300250152a9a6bfab48/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 1639236K/1953472K available (8725K kernel code, 1684K rwdata, 3852K rodata, 1820K init, 1888K bss, 314236K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
<6>[    0.000000] NR_IRQS:524544 nr_irqs:456 0
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 7864320 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 2393.929 MHz processor
<6>[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.85 BogoMIPS (lpj=2393929)
<6>[    0.000731] pid_max: default: 32768 minimum: 301
<6>[    0.001047] ACPI: Core revision 20140926
<4>[    0.014444] ACPI: All ACPI Tables successfully acquired
<6>[    0.014925] Security Framework initialized
<6>[    0.015214] SELinux:  Initializing.
<7>[    0.015465] SELinux:  Starting in permissive mode
<6>[    0.015928] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.017071] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
<6>[    0.017804] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.018232] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.018951] Initializing cgroup subsys memory
<6>[    0.019293] Initializing cgroup subsys devices
<6>[    0.019634] Initializing cgroup subsys freezer
<6>[    0.019977] Initializing cgroup subsys net_cls
<6>[    0.020318] Initializing cgroup subsys blkio
<6>[    0.020649] Initializing cgroup subsys perf_event
<6>[    0.021005] Initializing cgroup subsys hugetlb
<6>[    0.021365] CPU: Physical Processor ID: 0
<6>[    0.021680] CPU: Processor Core ID: 0
<6>[    0.021980] mce: CPU supports 9 MCE banks
<6>[    0.022304] CPU0: Thermal monitoring enabled (TM1)
<6>[    0.022672] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
<6>[    0.022672] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>[    0.023559] Freeing SMP alternatives memory: 36K (ffffffff81fb9000 - ffffffff81fc2000)
<6>[    0.025316] ftrace: allocating 31216 entries in 122 pages
<4>[    0.041090] Getting VERSION: 1060015
<4>[    0.041389] Getting VERSION: 1060015
<4>[    0.041681] Getting ID: 0
<4>[    0.041918] Getting ID: 0
<4>[    0.042161] masked ExtINT on CPU#0
<4>[    0.042752] ENABLING IO-APIC IRQs
<7>[    0.043029] init IO_APIC IRQs
<7>[    0.043286]  apic 1 pin 0 not connected
<7>[    0.043597] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.044179] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.044759] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.045338] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.045937] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.046518] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.047098] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.047682] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.048263] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.048842] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.049423] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.050012] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.050604] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.051193] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.051785] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.052375] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.052967]  apic 1 pin 16 not connected
<7>[    0.053279]  apic 1 pin 17 not connected
<7>[    0.053592]  apic 1 pin 18 not connected
<7>[    0.053902]  apic 1 pin 19 not connected
<7>[    0.054214]  apic 1 pin 20 not connected
<7>[    0.054525]  apic 1 pin 21 not connected
<7>[    0.054836]  apic 1 pin 22 not connected
<7>[    0.055146]  apic 1 pin 23 not connected
<6>[    0.055596] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.066031] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
<4>[    0.066878] Using local APIC timer interrupts.
<4>[    0.066878] calibrating APIC timer ...
<4>[    0.168600] ... lapic delta = 831234
<4>[    0.168892] ... PM-Timer delta = 357948
<4>[    0.169200] ... PM-Timer result ok
<4>[    0.169482] ..... delta 831234
<4>[    0.169745] ..... mult: 35701228
<4>[    0.170018] ..... calibration result: 132997
<4>[    0.170348] ..... CPU clock speed is 2393.0953 MHz.
<4>[    0.170711] ..... host bus clock speed is 132.0997 MHz.
<6>[    0.171131] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
<4>[    0.171948] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
<6>[    0.172428] ... version:                3
<6>[    0.172744] ... bit width:              48
<6>[    0.173066] ... generic registers:      4
<6>[    0.173384] ... value mask:             0000ffffffffffff
<6>[    0.173774] ... max period:             000000007fffffff
<6>[    0.174164] ... fixed-purpose events:   3
<6>[    0.174480] ... event mask:             000000070000000f
<6>[    0.176462] x86: Booting SMP configuration:
<6>[    0.176790] .... node  #0, CPUs:      #1
<4>[    0.188281] masked ExtINT on CPU#1
<6>[    0.190684] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.191394]  #2
<4>[    0.202658] masked ExtINT on CPU#2
<4>[    0.205114]  #3
<4>[    0.216282] masked ExtINT on CPU#3
<6>[    0.218619] x86: Booted up 1 node, 4 CPUs
<6>[    0.218936] smpboot: Total of 4 processors activated (19151.43 BogoMIPS)
<6>[    0.221901] devtmpfs: initialized
<6>[    0.224521] evm: security.selinux
<6>[    0.224799] evm: security.ima
<6>[    0.225057] evm: security.capability
<6>[    0.225507] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
<6>[    0.226095] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
<6>[    0.226684] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
<6>[    0.227259] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
<6>[    0.227832] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
<6>[    0.229588] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    0.230196] NET: Registered protocol family 16
<4>[    0.230767] Driver 'dummy' needs an owner
<6>[    0.233156] cpuidle: using governor menu
<6>[    0.233718] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>[    0.234278] ACPI: bus type PCI registered
<6>[    0.234595] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.235114] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>[    0.235771] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>[    0.236748] PCI: Using configuration type 1 for base access
<6>[    0.241560] ACPI: Added _OSI(Module Device)
<6>[    0.241887] ACPI: Added _OSI(Processor Device)
<6>[    0.242230] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.242585] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    0.244319] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
<6>[    0.244925] ACPI : EC: EC description table is found, configuring boot EC
<5>[    0.249396] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<4>[    0.326086] ACPI: Dynamic OEM Table Load:
<4>[    0.326511] ACPI: SSDT 0xFFFF880063A30800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
<4>[    0.327684] ACPI: Dynamic OEM Table Load:
<4>[    0.328107] ACPI: SSDT 0xFFFF880063A31000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
<4>[    0.336307] ACPI: Dynamic OEM Table Load:
<4>[    0.336734] ACPI: SSDT 0xFFFF880063431000 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
<4>[    0.341187] ACPI: Dynamic OEM Table Load:
<4>[    0.341608] ACPI: SSDT 0xFFFF880063434000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
<6>[    0.347649] ACPI: Interpreter enabled
<4>[    0.347955] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
<4>[    0.348709] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
<6>[    0.349473] ACPI: (supports S0 S3 S4 S5)
<6>[    0.349786] ACPI: Using IOAPIC for interrupt routing
<6>[    0.350180] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    0.356391] ACPI: Power Resource [PUBS] (on)
<6>[    0.357432] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
<6>[    0.359501] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
<6>[    0.361890] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.363116] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.364339] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.365555] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.366774] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.367995] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.369216] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.370438] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.371669] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
<6>[    0.372100] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.372699] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    0.373208] PCI host bridge to bus 0000:ff
<6>[    0.373532] pci_bus 0000:ff: root bus resource [bus ff]
<7>[    0.373924] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
<7>[    0.374407] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
<7>[    0.374886] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
<7>[    0.375356] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
<7>[    0.375828] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
<7>[    0.376300] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
<6>[    0.376798] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
<6>[    0.377826] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.378575] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
<6>[    0.379141] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
<6>[    0.379793] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
<6>[    0.380361] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
<6>[    0.380921] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
<6>[    0.381540] PCI host bridge to bus 0000:00
<6>[    0.381865] pci_bus 0000:00: root bus resource [bus 00-fe]
<6>[    0.382265] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    0.382706] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    0.383145] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    0.383623] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
<6>[    0.384103] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
<6>[    0.384581] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
<6>[    0.385058] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
<7>[    0.385541] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
<6>[    0.385985] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
<7>[    0.386592] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
<7>[    0.387032] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
<7>[    0.387509] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
<7>[    0.388050] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
<7>[    0.388561] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
<7>[    0.389020] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
<7>[    0.389583] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    0.390090] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
<7>[    0.390539] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
<7>[    0.390955] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
<7>[    0.391560] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
<7>[    0.392012] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
<7>[    0.392462] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
<7>[    0.392914] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
<7>[    0.393403] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>[    0.393873] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>[    0.394323] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
<7>[    0.394775] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
<7>[    0.395324] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>[    0.395794] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>[    0.396251] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
<7>[    0.396702] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
<7>[    0.397287] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>[    0.397770] pci 0000:00:1b.0: System wakeup disabled by ACPI
<7>[    0.398218] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
<7>[    0.398756] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    0.399230] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    0.399680] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
<7>[    0.400215] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<6>[    0.400689] pci 0000:00:1c.1: System wakeup disabled by ACPI
<7>[    0.401140] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
<7>[    0.401673] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
<6>[    0.402147] pci 0000:00:1c.3: System wakeup disabled by ACPI
<7>[    0.402597] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
<7>[    0.403133] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>[    0.403605] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>[    0.404063] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
<7>[    0.404514] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
<7>[    0.405066] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>[    0.405535] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    0.405984] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
<7>[    0.406544] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
<7>[    0.407143] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
<7>[    0.407596] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
<7>[    0.408011] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
<7>[    0.408424] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
<7>[    0.408838] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
<7>[    0.409251] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
<7>[    0.409663] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
<7>[    0.410173] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    0.410627] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
<7>[    0.411076] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
<7>[    0.411573] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
<7>[    0.412068] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
<7>[    0.412522] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
<6>[    0.413203] pci 0000:00:1c.0: PCI bridge to [bus 02]
<7>[    0.413677] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
<7>[    0.414147] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
<7>[    0.414823] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
<6>[    0.417755] pci 0000:00:1c.1: PCI bridge to [bus 03]
<7>[    0.418135] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>[    0.418706] acpiphp: Slot [1] registered
<6>[    0.419026] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<7>[    0.419415] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<7>[    0.419856] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<7>[    0.420335] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<7>[    0.421045] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
<5>[    0.421541] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
<7>[    0.422104] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
<7>[    0.422774] pci 0000:0d:00.0: supports D1 D2
<7>[    0.423104] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.423741] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
<7>[    0.424239] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
<7>[    0.424897] pci 0000:0d:00.1: supports D1 D2
<7>[    0.425228] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.425862] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
<7>[    0.426361] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
<7>[    0.427019] pci 0000:0d:00.3: supports D1 D2
<7>[    0.427349] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    0.429818] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<7>[    0.430198] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>[    0.430760] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
<7>[    0.431243] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    0.431821] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    0.432397] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    0.433013] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
<7>[    0.433629] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
<7>[    0.434246] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
<7>[    0.434864] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
<7>[    0.435690] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<4>[    0.437488] ACPI: Enabled 3 GPEs in block 00 to 3F
<4>[    0.437955] Driver 'ec' needs an owner
<6>[    0.438263] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
<6>[    0.438970] vgaarb: setting as boot device: PCI:0000:00:02.0
<6>[    0.439382] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    0.439975] vgaarb: loaded
<6>[    0.440219] vgaarb: bridge control possible 0000:00:02.0
<5>[    0.440694] SCSI subsystem initialized
<4>[    0.441010] Driver 'Generic PHY' needs an owner
<4>[    0.441312] Driver 'Generic 10G PHY' needs an owner<6>[    0.441743] ACPI: bus type USB registered
<4>[    0.442112] Driver 'usbfs' needs an owner
<6>[    0.442386] usbcore: registered new interface driver usbfs
<4>[    0.442888] Driver 'hub' needs an owner
<6>[    0.443150] usbcore: registered new interface driver hub
<4>[    0.443654] Driver 'usb' needs an owner
<6>[    0.443918] usbcore: registered new device driver usb
<6>[    0.444415] pps_core: LinuxPPS API ver. 1 registered
<6>[    0.444785] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    0.445433] PTP clock support registered
<6>[    0.445857] PCI: Using ACPI for IRQ routing
<7>[    0.456086] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.456625] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
<7>[    0.457056] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
<7>[    0.457490] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
<7>[    0.457922] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
<7>[    0.458353] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
<7>[    0.458780] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
<7>[    0.459207] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
<6>[    0.459757] NetLabel: Initializing
<6>[    0.460039] NetLabel:  domain hash size = 128
<6>[    0.460375] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    0.460760] NetLabel:  unlabeled traffic allowed by default
<6>[    0.461313] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    0.462202] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    0.464662] Switched to clocksource hpet
<4>[    0.475295] Driver 'system' needs an owner
<6>[    0.475590] pnp: PnP ACPI init
<6>[    0.477434] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
<6>[    0.477924] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
<6>[    0.478405] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
<6>[    0.478893] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
<6>[    0.479354] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
<6>[    0.479823] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
<6>[    0.480304] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
<6>[    0.480792] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
<6>[    0.481273] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
<6>[    0.481761] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
<6>[    0.482242] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
<6>[    0.482730] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
<6>[    0.483212] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
<6>[    0.483701] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
<6>[    0.484183] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
<7>[    0.484666] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    0.485461] system 00:01: [io  0x164e-0x164f] has been reserved
<6>[    0.485895] system 00:01: [io  0x1000-0x107f] could not be reserved
<6>[    0.486928] system 00:01: [io  0x1180-0x11ff] has been reserved
<6>[    0.487353] system 00:01: [io  0x0800-0x080f] has been reserved
<6>[    0.487782] system 00:01: [io  0x15e0-0x15ef] has been reserved
<6>[    0.488206] system 00:01: [io  0x1600-0x1641] has been reserved
<6>[    0.488629] system 00:01: [io  0x1644-0x167f] could not be reserved
<6>[    0.489080] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
<6>[    0.489543] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    0.490011] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
<6>[    0.490474] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
<6>[    0.490942] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
<6>[    0.491405] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
<7>[    0.491874] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.492387] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    0.492992] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    0.493460] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
<7>[    0.494063] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
<7>[    0.494531] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
<7>[    0.495145] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
<7>[    0.495982] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
<6>[    0.497217] pnp: PnP ACPI: found 6 devices
<6>[    0.504823] pci 0000:00:1c.0: PCI bridge to [bus 02]
<6>[    0.505208] pci 0000:00:1c.1: PCI bridge to [bus 03]
<6>[    0.505583] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>[    0.506072] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<6>[    0.506458] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<6>[    0.506903] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<6>[    0.507378] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<6>[    0.507956] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<6>[    0.508329] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>[    0.508816] pci 0000:00:1e.0: PCI bridge to [bus 0e]
<7>[    0.509198] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    0.509602] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    0.510013] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.510456] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
<7>[    0.510905] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
<7>[    0.511348] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
<7>[    0.511796] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
<7>[    0.512245] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
<7>[    0.512689] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
<7>[    0.513099] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
<7>[    0.513543] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
<7>[    0.514090] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
<7>[    0.514536] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
<7>[    0.514947] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
<7>[    0.515353] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.515805] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
<7>[    0.516249] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
<7>[    0.516701] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
<7>[    0.517146] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
<6>[    0.517624] NET: Registered protocol family 2
<6>[    0.518163] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.518773] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
<6>[    0.519313] TCP: Hash tables configured (established 16384 bind 16384)
<6>[    0.519809] TCP: reno registered
<6>[    0.520087] UDP hash table entries: 1024 (order: 3, 32768 bytes)
<6>[    0.520530] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
<6>[    0.521046] NET: Registered protocol family 1
<6>[    0.521480] RPC: Registered named UNIX socket transport module.
<6>[    0.521911] RPC: Registered udp transport module.
<6>[    0.522264] RPC: Registered tcp transport module.
<6>[    0.522618] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    0.523093] pci 0000:00:02.0: Video device with shadowed ROM
<7>[    0.523585] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>[    0.524317] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
<7>[    0.525050] PCI: CLS 64 bytes, default 64
<6>[    0.525425] Unpacking initramfs...
<6>[    4.864718] Freeing initrd memory: 264464K (ffff880067038000 - ffff88007727c000)
<6>[    4.865437] Simple Boot Flag at 0x35 set to 0x1
<4>[    4.866567] Driver 'alarmtimer' needs an owner
<6>[    4.866960] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>[    4.867537] Initialise system trusted keyring
<6>[    4.867891] audit: initializing netlink subsys (disabled)
<5>[    4.868306] audit: type=2000 audit(1414623088.641:1): initialized
<6>[    4.869080] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    4.871037] zpool: loaded
<6>[    4.871276] zbud: loaded
<5>[    4.871709] VFS: Disk quotas dquot_6.5.2
<4>[    4.872056] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    4.873045] SGI XFS with ACLs, security attributes, no debug enabled
<6>[    4.873942] 9p: Installing v9fs 9p2000 file system support
<6>[    4.874374] msgmni has been set to 3718
<5>[    4.874750] Key type big_key registered
<7>[    4.875058] SELinux:  Registering netfilter hooks
<6>[    4.876311] NET: Registered protocol family 38
<5>[    4.876668] Key type asymmetric registered
<5>[    4.876992] Asymmetric key parser 'x509' registered
<6>[    4.877404] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    4.878008] io scheduler noop registered
<6>[    4.878323] io scheduler deadline registered (default)
<6>[    4.878722] io scheduler cfq registered
<4>[    4.879115] Driver 'pcieport' needs an owner
<7>[    4.879507] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
<7>[    4.880313] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
<7>[    4.881019] IOAPIC[0]: Set routing entry (1-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
<4>[    4.881807] Driver 'aer' needs an owner
<4>[    4.882072] Driver 'pcie_pme' needs an ownerDriver 'ioapic' needs an owner
<6>[    4.882675] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<4>[    4.883184] Driver 'pciehp_dummy' needs an owner
<4>[    4.883501] Driver 'pciehp' needs an owner<6>[    4.883876] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<4>[    4.884383] Driver 'pci-stub' needs an owner
<4>[    4.884760] Driver 'vesa-framebuffer' needs an ownerDriver 'efi-framebuffer' needs an owner
<7>[    4.885486] intel_idle: MWAIT substates: 0x1120
<7>[    4.885932] intel_idle: v0.4 model 0x25
<7>[    4.886239] intel_idle: lapic_timer_reliable_states 0xffffffff
<4>[    4.886826] Driver 'ac' needs an owner
<6>[    4.887692] ACPI: AC Adapter [AC] (on-line)
<4>[    4.888162] Driver 'button' needs an owner
<6>[    4.888885] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
<6>[    4.890131] ACPI: Lid Switch [LID]
<6>[    4.890533] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
<6>[    4.891139] ACPI: Sleep Button [SLPB]
<6>[    4.891535] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
<6>[    4.892083] ACPI: Power Button [PWRF]
<4>[    4.892415] Driver 'acpi-fan' needs an owner
<4>[    4.892727] Driver 'processor' needs an ownerDriver 'thermal' needs an owner
<6>[    4.898622] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    4.899137] ACPI: Thermal Zone [THM0] (55 C)
<4>[    4.899527] Driver 'hardware_error_device' needs an owner
<4>[    4.899719] Driver 'battery' needs an owner<6>[    4.900014] ACPI: Battery Slot [BAT0] (battery absent)
<6>[    4.900771] GHES: HEST is not enabled!
<4>[    4.901179] Driver 'virtio-pci' needs an owner
<4>[    4.901512] Driver 'virtio_balloon' needs an ownerDriver 'xen-platform-pci' needs an owner
<6>[    4.902472] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<4>[    4.903039] Driver 'serial' needs an owner
<4>[    4.904280] Driver 'serial8250' needs an ownerDriver 'serial' needs an owner
<7>[    4.905063] IOAPIC[0]: Set routing entry (1-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:15)
<6>[    4.906071] console [ttyS0] disabled
<6>[    4.926904] serial 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
<6>[    5.869047] tsc: Refined TSC clocksource calibration: 2393.998 MHz
<6>[    6.826913] console [ttyS0] enabled
<4>[    6.828923] Driver 'virtio_console' needs an owner
<4>[    6.830740] Driver 'virtio_rproc_serial' needs an ownerDriver 'hpet' needs an owner
<6>[    6.834502] Non-volatile memory driver v1.3
<4>[    6.836521] Driver 'virtio_rng' needs an owner
<6>[    6.838604] Linux agpgart interface v0.103
<4>[    6.840432] Driver 'agpgart-amd64' needs an owner
<4>[    6.842526] Driver 'agpgart-intel' needs an owner<6>[    6.844641] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
<6>[    6.847963] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
<6>[    6.852279] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
<6>[    6.854391] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
<4>[    6.857792] Driver 'agpgart-sis' needs an owner
<4>[    6.859712] Driver 'agpgart-via' needs an ownerDriver 'tpm_tis' needs an owner
<6>[    6.863973] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
<6>[    6.869785] Switched to clocksource tsc
<6>[    6.902748] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
<4>[    6.905931] Driver 'virtio_blk' needs an owner
<4>[    6.908025] Driver 'mei_me' needs an owner<7>[    6.909837] IOAPIC[0]: Set routing entry (1-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[    6.912671] mei_me 0000:00:16.0: irq 24 for MSI/MSI-X
<4>[    6.916899] Driver 'lpc_ich' needs an ownerACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140926/utaddress-258)
<6>[    6.927227] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.931577] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
<6>[    6.939246] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.943667] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
<6>[    6.951447] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.955679] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140926/utaddress-258)
<6>[    6.963641] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.967850] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[    6.971158] rdac: device handler registered
<6>[    6.973149] hp_sw: device handler registered
<6>[    6.975023] emc: device handler registered
<6>[    6.976927] alua: device handler registered
<6>[    6.978940] libphy: Fixed MDIO Bus: probed
<4>[    6.980785] Driver 'virtio_net' needs an owner
<4>[    6.981954] Driver 'tg3' needs an ownerDriver 'tulip' needs an owner
<6>[    6.985255] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    6.988823] e1000: Copyright (c) 1999-2006 Intel Corporation.
<4>[    6.991164] Driver 'e1000' needs an owner
<6>[    6.993117] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    6.995414] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<4>[    6.997776] Driver 'e1000e' needs an owner
<6>[    6.999851] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>[    7.003889] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
<6>[    7.189746] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
<6>[    7.193055] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>[    7.196564] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
<6>[    7.199179] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
<6>[    7.202617] igb: Copyright (c) 2007-2014 Intel Corporation.
<4>[    7.204938] Driver 'igb' needs an owner
<6>[    7.206780] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    7.210491] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<4>[    7.212830] Driver 'ixgbe' needs an owner
<4>[    7.214659] Driver '8139cp' needs an ownerDriver '8139too' needs an owner
<4>[    7.218231] Driver 'r8169' needs an ownerDriver 'catc' needs an owner
<6>[    7.220677] usbcore: registered new interface driver catc
<4>[    7.223225] Driver 'kaweth' needs an owner
<6>[    7.224858] usbcore: registered new interface driver kaweth
<6>[    7.227163] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<4>[    7.230801] Driver 'pegasus' needs an owner
<6>[    7.232720] usbcore: registered new interface driver pegasus
<4>[    7.235050] Driver 'rtl8150' needs an owner
<6>[    7.236937] usbcore: registered new interface driver rtl8150
<4>[    7.240140] Driver 'asix' needs an owner
<6>[    7.241197] usbcore: registered new interface driver asix
<4>[    7.244263] Driver 'cdc_ether' needs an owner
<6>[    7.246196] usbcore: registered new interface driver cdc_ether
<4>[    7.248698] Driver 'cdc_eem' needs an owner
<6>[    7.250594] usbcore: registered new interface driver cdc_eem
<4>[    7.252832] Driver 'dm9601' needs an owner
<6>[    7.254720] usbcore: registered new interface driver dm9601
<4>[    7.257003] Driver 'smsc75xx' needs an owner
<6>[    7.259075] usbcore: registered new interface driver smsc75xx
<4>[    7.262198] Driver 'smsc95xx' needs an owner
<6>[    7.263407] usbcore: registered new interface driver smsc95xx
<4>[    7.266520] Driver 'gl620a' needs an owner
<6>[    7.268408] usbcore: registered new interface driver gl620a
<4>[    7.270724] Driver 'net1080' needs an owner
<6>[    7.272637] usbcore: registered new interface driver net1080
<4>[    7.274988] Driver 'plusb' needs an owner
<6>[    7.276847] usbcore: registered new interface driver plusb
<4>[    7.279153] Driver 'rndis_host' needs an owner
<6>[    7.281114] usbcore: registered new interface driver rndis_host
<4>[    7.284380] Driver 'cdc_subset' needs an owner
<6>[    7.286353] usbcore: registered new interface driver cdc_subset
<4>[    7.288881] Driver 'zaurus' needs an owner
<6>[    7.290665] usbcore: registered new interface driver zaurus
<4>[    7.292973] Driver 'MOSCHIP usb-ethernet driver' needs an owner
<6>[    7.295348] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<4>[    7.299087] Driver 'int51x1' needs an owner
<6>[    7.300873] usbcore: registered new interface driver int51x1
<4>[    7.303360] Driver 'ipheth' needs an owner
<6>[    7.305099] usbcore: registered new interface driver ipheth
<4>[    7.308641] Driver 'sierra_net' needs an owner
<6>[    7.310270] usbcore: registered new interface driver sierra_net
<4>[    7.312912] Driver 'xhci_hcd' needs an owner
<6>[    7.314614] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    7.317216] ehci-pci: EHCI PCI platform driver
<4>[    7.319242] Driver 'ehci-pci' needs an owner
<6>[    7.321304] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>[    7.323616] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>[    7.327008] ehci-pci 0000:00:1a.0: debug port 2
<7>[    7.332995] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>[    7.336505] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
<6>[    7.344001] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>[    7.346241] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    7.349625] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    7.352374] usb usb1: Product: EHCI Host Controller
<6>[    7.355304] usb usb1: Manufacturer: Linux 3.18.0-rc2-g2d81df3 ehci_hcd
<6>[    7.357847] usb usb1: SerialNumber: 0000:00:1a.0
<6>[    7.360181] hub 1-0:1.0: USB hub found
<6>[    7.361750] hub 1-0:1.0: 3 ports detected
<7>[    7.364014] IOAPIC[0]: Set routing entry (1-19 -> 0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)
<6>[    7.367483] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>[    7.369792] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>[    7.372454] ehci-pci 0000:00:1d.0: debug port 2
<7>[    7.378342] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>[    7.381946] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
<6>[    7.390028] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>[    7.393588] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    7.396050] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    7.399612] usb usb2: Product: EHCI Host Controller
<6>[    7.401734] usb usb2: Manufacturer: Linux 3.18.0-rc2-g2d81df3 ehci_hcd
<6>[    7.404370] usb usb2: SerialNumber: 0000:00:1d.0
<6>[    7.406561] hub 2-0:1.0: USB hub found
<6>[    7.408180] hub 2-0:1.0: 3 ports detected
<6>[    7.410250] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    7.412484] ohci-pci: OHCI PCI platform driver
<4>[    7.414585] Driver 'ohci-pci' needs an owner
<6>[    7.416433] uhci_hcd: USB Universal Host Controller Interface driver
<4>[    7.419819] Driver 'uhci_hcd' needs an owner
<4>[    7.421761] Driver 'usbserial' needs an owner<6>[    7.423765] usbcore: registered new interface driver usbserial
<4>[    7.426081] Driver 'usbserial_generic' needs an owner
<6>[    7.428166] usbcore: registered new interface driver usbserial_generic
<4>[    7.431620] Driver 'generic' needs an owner
<6>[    7.433589] usbserial: USB Serial support registered for generic
<4>[    7.435941] Driver 'i8042 kbd' needs an owner
<4>[    7.437924] Driver 'i8042 aux' needs an owner<6>[    7.439886] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
<4>[    7.443820] Driver 'i8042' needs an owner
<6>[    7.448019] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    7.449689] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    7.452189] mousedev: PS/2 mouse device common for all mice
<4>[    7.454714] Driver 'atkbd' needs an owner
<4>[    7.456098] Driver 'psmouse' needs an ownerDriver 'rtc_cmos' needs an owner
<6>[    7.459609] rtc_cmos 00:02: RTC can wake from S4
<6>[    7.461826] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>[    7.462743] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
<6>[    7.467993] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<4>[    7.471648] Driver 'i6300ESB timer' needs an owner
<6>[    7.473804] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<4>[    7.476006] Driver 'iTCO_wdt' needs an owner
<6>[    7.477976] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
<6>[    7.480800] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    7.483944] iTCO_vendor_support: vendor-support=0
<6>[    7.486218] hidraw: raw HID events driver (C) Jiri Kosina
<4>[    7.488182] Driver 'hid-generic' needs an owner
<4>[    7.490182] Driver 'a4tech' needs an ownerDriver 'apple' needs an owner
<4>[    7.493711] Driver 'belkin' needs an ownerDriver 'cherry' needs an owner
<4>[    7.496265] Driver 'chicony' needs an ownerDriver 'cypress' needs an owner
<4>[    7.499684] Driver 'ezkey' needs an ownerDriver 'kensington' needs an owner
<4>[    7.502331] Driver 'logitech' needs an ownerDriver 'magicmouse' needs an owner
<4>[    7.505873] Driver 'microsoft' needs an ownerDriver 'monterey' needs an owner
<4>[    7.509001] Driver 'ntrig' needs an ownerDriver 'usbhid' needs an owner
<6>[    7.512028] usbcore: registered new interface driver usbhid
<6>[    7.514441] usbhid: USB HID core driver
<4>[    7.516179] Driver 'pvpanic' needs an owner
<6>[    7.518094] drop_monitor: Initializing network drop monitor service
<6>[    7.520669] TCP: cubic registered
<6>[    7.522310] Initializing XFRM netlink socket
<6>[    7.524459] NET: Registered protocol family 10
<6>[    7.526804] NET: Registered protocol family 17
<6>[    7.528364] 9pnet: Installing 9P2000 support
<4>[    7.530283] Driver '9pnet_virtio' needs an owner
<7>[    7.532996] 
<7>[    7.532996] printing PIC contents
<7>[    7.535408] ... PIC  IMR: ffff
<7>[    7.537044] ... PIC  IRR: 0800
<7>[    7.538823] ... PIC  ISR: 0000
<7>[    7.539735] ... PIC ELCR: 0800
<7>[    7.541189] printing local APIC contents on CPU#0/0:
<6>[    7.543251] ... APIC ID:      00000000 (0)
<6>[    7.545173] ... APIC VERSION: 01060015
<7>[    7.546961] ... APIC TASKPRI: 00000000 (00)
<7>[    7.549016] ... APIC PROCPRI: 00000000
<7>[    7.550738] ... APIC LDR: 01000000
<7>[    7.551698] ... APIC DFR: ffffffff
<7>[    7.553347] ... APIC SPIV: 000001ff
<7>[    7.555124] ... APIC ISR field:
<4>[    7.556765] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    7.559777] ... APIC TMR field:
<4>[    7.561073] 0000000002000000000200020002000200000002000000000002000000000000
<7>[    7.564733] ... APIC IRR field:
<4>[    7.565604] 0000000010000000000000000000000000000000000000000000000000000000
<7>[    7.569165] ... APIC ESR: 00000000
<7>[    7.570705] ... APIC ICR: 000008fd
<7>[    7.571681] ... APIC ICR2: 08000000
<7>[    7.573368] ... APIC LVTT: 000000ef
<7>[    7.575103] ... APIC LVTPC: 00000400
<7>[    7.576877] ... APIC LVT0: 00010700
<7>[    7.578710] ... APIC LVT1: 00000400
<7>[    7.579685] ... APIC LVTERR: 000000fe
<7>[    7.581329] ... APIC TMICT: 005d67da
<7>[    7.583102] ... APIC TMCCT: 005700af
<7>[    7.584891] ... APIC TDCR: 00000003
<4>[    7.586667] 
<7>[    7.587132] number of MP IRQ sources: 15.
<7>[    7.589020] number of IO-APIC #1 registers: 24.
<6>[    7.590988] testing the IO APIC.......................
<7>[    7.593147] IO APIC #1......
<7>[    7.594758] .... register #00: 02000000
<7>[    7.595845] .......    : physical APIC id: 02
<7>[    7.597726] .......    : Delivery Type: 0
<7>[    7.599709] .......    : LTS          : 0
<7>[    7.601529] .... register #01: 00170020
<7>[    7.603393] .......     : max redirection entries: 17
<7>[    7.605498] .......     : PRQ implemented: 0
<7>[    7.607471] .......     : IO APIC version: 20
<7>[    7.609602] .... IRQ redirection table:
<4>[    7.611311] 1    0    0   0   0    0    0    00
<4>[    7.613341] 0    0    0   0   0    1    1    31
<4>[    7.615357] 0    0    0   0   0    1    1    30
<4>[    7.617371] 0    0    0   0   0    1    1    33
<4>[    7.619462] 0    0    0   0   0    1    1    34
<4>[    7.621483] 0    0    0   0   0    1    1    35
<4>[    7.623459] 0    0    0   0   0    1    1    36
<4>[    7.625504] 0    0    0   0   0    1    1    37
<4>[    7.627511] 0    0    0   0   0    1    1    38
<4>[    7.629563] 0    1    0   0   0    1    1    39
<4>[    7.631530] 0    0    0   0   0    1    1    3A
<4>[    7.633581] 0    0    0   0   0    1    1    3B
<4>[    7.635656] 0    0    0   0   0    1    1    3C
<4>[    7.637620] 0    0    0   0   0    1    1    3D
<4>[    7.639718] 0    0    0   0   0    1    1    3E
<4>[    7.641671] 0    0    0   0   0    1    1    3F
<4>[    7.643734] 1    1    0   1   0    1    1    A1
<4>[    7.645741] 1    1    0   1   0    1    1    91
<4>[    7.647746] 1    0    0   0   0    0    0    00
<4>[    7.649858] 0    1    0   1   0    1    1    D1
<4>[    7.651768] 1    1    0   1   0    1    1    61
<4>[    7.653893] 1    1    0   1   0    1    1    71
<4>[    7.655834] 1    0    0   0   0    0    0    00
<4>[    7.657848] 0    1    0   1   0    1    1    81
<7>[    7.660769] IRQ to pin mappings:
<7>[    7.661724] IRQ0 -> 0:2
<7>[    7.663223] IRQ1 -> 0:1
<7>[    7.664117] IRQ3 -> 0:3
<6>[    7.665136] usb 1-1: new high-speed USB device number 2 using ehci-pci
<4>[    7.667708] 
<7>[    7.669029] IRQ4 -> 0:4
<7>[    7.669870] IRQ5 -> 0:5
<7>[    7.671201] IRQ6 -> 0:6
<7>[    7.672026] IRQ7 -> 0:7
<7>[    7.673465] IRQ8 -> 0:8
<7>[    7.674319] IRQ9 -> 0:9
<7>[    7.675446] IRQ10 -> 0:10
<7>[    7.676959] IRQ11 -> 0:11
<7>[    7.677800] IRQ12 -> 0:12
<7>[    7.679264] IRQ13 -> 0:13
<7>[    7.680089] IRQ14 -> 0:14
<7>[    7.681384] IRQ15 -> 0:15
<7>[    7.682817] IRQ16 -> 0:16
<7>[    7.683637] IRQ17 -> 0:17
<7>[    7.685147] IRQ19 -> 0:19
<7>[    7.685999] IRQ20 -> 0:20
<7>[    7.687351] IRQ21 -> 0:21
<7>[    7.688193] IRQ23 -> 0:23
<6>[    7.689620] .................................... done.
<5>[    7.692284] Loading compiled-in X.509 certificates
<5>[    7.695890] Loaded X.509 cert 'Magrathea: Glacier signing key: 67a86f1d43874f1f36ff60e119628b2a14bbaf77'
<6>[    7.700015] registered taskstats version 1
<5>[    7.705354] Key type trusted registered
<5>[    7.709589] Key type encrypted registered
<6>[    7.712157] usb 2-1: new high-speed USB device number 2 using ehci-pci
<3>[    7.719224] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
<6>[    7.721721] ima: No TPM chip found, activating TPM-bypass!
<6>[    7.724943] evm: HMAC attrs: 0x1
<6>[    7.726700] rtc_cmos 00:02: setting system clock to 2014-10-29 22:51:32 UTC (1414623092)
<6>[    7.779625] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
<6>[    7.783057] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    7.786365] hub 1-1:1.0: USB hub found
<6>[    7.787851] hub 1-1:1.0: 6 ports detected
<6>[    7.828983] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
<6>[    7.831106] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<7>[    7.832881] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
<6>[    7.837272] hub 2-1:1.0: USB hub found
<6>[    7.838858] hub 2-1:1.0: 8 ports detected
<7>[    7.933394] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
<6>[    7.935036] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[    8.064615] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
<6>[    8.154020] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
<6>[    8.156460] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    8.160288] usb 1-1.3: Product: Biometric Coprocessor
<6>[    8.162318] usb 1-1.3: Manufacturer: UPEK
<6>[    8.238724] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
<6>[    8.332469] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
<6>[    8.334542] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    8.338170] usb 1-1.6: Product: Integrated Camera
<6>[    8.340290] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
<6>[    8.455709] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
<6>[    8.461660] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
<6>[    8.515396] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
<6>[   10.386327] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
<6>[   10.396913] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   10.407869] Sending DHCP requests .., OK
<4>[   12.957543] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
<6>[   12.974349] IP-Config: Complete:
<6>[   12.979419]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
<6>[   12.999889]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
<6>[   13.008108]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   13.017423]      nameserver0=192.168.1.1
<7>[   13.019783] PM: Hibernation image not present or could not be loaded.
<6>[   13.023356] Freeing unused kernel memory: 1820K (ffffffff81df2000 - ffffffff81fb9000)
<4>[   13.248233] Driver 'wmi' needs an owner
<6>[   13.252294] wmi: Mapper loaded
<6>[   13.256707] [drm] Initialized drm 1.1.0 20060810
<6>[   13.272348] Linux video capture interface: v2.00
<6>[   13.284315] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
<6>[   13.300379] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
<6>[   13.331718] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
<6>[   13.334123] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<4>[   13.344367] Driver 'parport_pc' needs an owner
<6>[   13.346383] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
<6>[   13.352265] sdhci: Secure Digital Host Controller Interface driver
<6>[   13.354357] sdhci: Copyright(c) Pierre Ossman
<6>[   13.361860] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input7
<7>[   13.362092] libata version 3.00 loaded.
<6>[   13.368474] usbcore: registered new interface driver uvcvideo
<6>[   13.370518] USB Video Class driver (1.1.1)
<5>[   13.380638] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
<6>[   13.384873] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
<7>[   13.388607] ahci 0000:00:1f.2: version 3.0
<4>[   13.388653] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
<6>[   13.388663] sdhci-pci 0000:0d:00.0: No vmmc regulator found
<6>[   13.388665] sdhci-pci 0000:0d:00.0: No vqmmc regulator found
<6>[   13.393681] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
<7>[   13.402818] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
<6>[   13.404509] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
<6>[   13.406314] thinkpad_acpi: ThinkPad ACPI Extras v0.25
<6>[   13.406316] thinkpad_acpi: http://ibm-acpi.sf.net/
<6>[   13.406317] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
<6>[   13.406319] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
<6>[   13.409449] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
<6>[   13.410283] thinkpad_acpi: radio switch found; radios are disabled
<6>[   13.410518] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
<5>[   13.410519] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
<4>[   13.422394] Driver 'thinkpad_hotkey' needs an owner
<6>[   13.422395] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
<6>[   13.438236] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
<6>[   13.441913] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
<6>[   13.446872] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
<6>[   13.451173] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
<6>[   13.452906] scsi host0: ahci
<6>[   13.453141] scsi host1: ahci
<6>[   13.453327] scsi host2: ahci
<6>[   13.453506] scsi host3: ahci
<6>[   13.453719] scsi host4: ahci
<6>[   13.453925] scsi host5: ahci
<6>[   13.454023] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 26
<6>[   13.454027] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 26
<6>[   13.454028] ata3: DUMMY
<6>[   13.454029] ata4: DUMMY
<6>[   13.454032] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 26
<6>[   13.454034] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 26
<7>[   13.454332] snd_hda_intel 0000:00:1b.0: irq 27 for MSI/MSI-X
<6>[   13.455617] [drm] Memory usable by graphics device = 2048M
<6>[   13.455618] [drm] Replacing VGA console driver
<6>[   13.485597] Console: switching to colour dummy device 80x25
<6>[   13.487790] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
<7>[   13.500938] i915 0000:00:02.0: irq 28 for MSI/MSI-X
<6>[   13.503359] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[   13.506615] [drm] Driver supports precise vblank timestamp query.
<6>[   13.509732] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<6>[   13.514373] sound hdaudioC0D0: CX20585: BIOS auto-probing.
<6>[   13.517258] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
<6>[   13.520380] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<6>[   13.523776] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
<6>[   13.526237] sound hdaudioC0D0:    mono: mono_out=0x0
<6>[   13.528428] sound hdaudioC0D0:    inputs:
<6>[   13.530308] sound hdaudioC0D0:      Internal Mic=0x23
<6>[   13.532463] sound hdaudioC0D0:      Mic=0x1b
<6>[   13.534535] sound hdaudioC0D0:      Dock Mic=0x1a
<6>[   13.537852] sound hdaudioC0D0: Enable sync_write for stable communication
<4>[   13.554475] Driver 'video' needs an owner
<6>[   13.562174] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
<6>[   13.565901] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
<6>[   13.569132] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
<6>[   13.573548] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>[   13.577634] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>[   13.581872] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>[   13.584269] acpi device:01: registered as cooling_device4
<6>[   13.584490] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input16
<6>[   13.584801] [drm] Initialized i915 1.6.0 20141024 for 0000:00:02.0 on minor 0
<6>[   13.595748] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>[   13.599805] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
<6>[   13.619792] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
<6>[   13.631765] fbcon: inteldrmfb (fb0) is primary device
<6>[   13.633912] input: PC Speaker as /devices/platform/pcspkr/input/input17
<3>[   13.637375] Error: Driver 'pcspkr' is already registered, aborting...
<6>[   13.758826] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
<5>[   13.886193] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
<6>[   13.914077] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<7>[   13.915878] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.915882] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>[   13.916035] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.916039] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>[   13.917789] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
<6>[   13.917792] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<7>[   13.919920] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.919924] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>[   13.920042] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.920045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>[   13.921625] ata1.00: configured for UDMA/100
<5>[   13.921900] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
<6>[   14.012939] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
<6>[   14.139318] Console: switching to colour frame buffer device 160x50
<6>[   14.207477] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[   14.209954] i915 0000:00:02.0: registered panic notifier
<6>[   14.382334] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<7>[   14.393490] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>[   14.401201] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>[   14.406283] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
<7>[   14.423825] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>[   14.433633] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>[   14.440781] ata2.00: configured for UDMA/100
<5>[   14.461048] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
<6>[   14.792629] ata5: SATA link down (SStatus 0 SControl 300)
<6>[   15.100820] ata6: SATA link down (SStatus 0 SControl 300)
<4>[   15.126895] Driver 'sd' needs an owner
<5>[   15.128955] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
<5>[   15.137502] sd 0:0:0:0: [sda] Write Protect is off
<4>[   15.141518] Driver 'sr' needs an owner
<7>[   15.141518] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   15.148620] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[   15.169608] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
<6>[   15.175545] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>[   15.180160] sr 1:0:0:0: Attached scsi CD-ROM sr0
<5>[   15.190298] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[   15.194170] sr 1:0:0:0: Attached scsi generic sg1 type 5
<6>[   15.573204]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
<5>[   15.581973] sd 0:0:0:0: [sda] Attached SCSI disk
<5>[   15.728943] random: nonblocking pool is initialized
<6>[   16.614639] raid6: sse2x1    2902 MB/s
<6>[   16.637646] raid6: sse2x2    3417 MB/s
<6>[   16.661669] raid6: sse2x4    3808 MB/s
<6>[   16.668196] raid6: using algorithm sse2x4 (3808 MB/s)
<6>[   16.675729] raid6: using ssse3x2 recovery algorithm
<6>[   16.686162] xor: measuring software checksum speed
<6>[   16.704724]    prefetch64-sse:  4944.000 MB/sec
<6>[   16.720735]    generic_sse:  4364.000 MB/sec
<6>[   16.724931] xor: using function: prefetch64-sse (4944.000 MB/sec)
<6>[   16.767140] Btrfs loaded
<6>[   16.772424] BTRFS: device fsid 8886adc6-3306-411a-bbf8-6638ebb74746 devid 1 transid 57 /dev/sda6
<6>[   18.535034] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<4>[   25.087666] Driver 'ipmi' needs an owner
<6>[   25.092524] ipmi message handler version 39.2
<6>[   25.106110] IPMI Watchdog: driver initialized
<4>[   46.024267] ------------[ cut here ]------------
<4>[   46.030029] WARNING: CPU: 0 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   46.045334] vblank not available on crtc 1, ret=-22
<4>[   46.050710] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   46.104497] CPU: 0 PID: 1814 Comm: kms_setmode Not tainted 3.18.0-rc2-g2d81df3 #1
<4>[   46.113099] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   46.121968]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e0ffb8
<4>[   46.129736]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   46.134783]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000804
<4>[   46.138393] Call Trace:
<4>[   46.139060]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   46.141227]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   46.144489]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   46.146830]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   46.150249]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   46.152729]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   46.155166]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   46.158658]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   46.161194]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   46.164606]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   46.167110]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   46.170410]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   46.173103]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   46.175309]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   46.178833]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   46.182285]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   46.184576]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   46.186751]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   46.189103]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   46.191292]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   46.194522] ---[ end trace 7042ddb87f73ead7 ]---
<3>[   51.725259] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
<4>[   57.347294] ------------[ cut here ]------------
<4>[   57.353249] WARNING: CPU: 3 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   57.365648] vblank not available on crtc 1, ret=-22
<4>[   57.371025] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   57.424589] CPU: 3 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   57.431541] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   57.435294]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066f8ffb8
<4>[   57.438003]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   57.441631]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   57.445247] Call Trace:
<4>[   57.445899]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   57.448886]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   57.451330]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   57.453617]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   57.457064]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   57.459477]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   57.462884]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   57.465600]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   57.468878]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   57.471406]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   57.473927]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   57.477211]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   57.479762]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   57.482964]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   57.485742]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   57.489009]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   57.491344]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   57.493622]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   57.495926]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   57.498910]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   57.501304] ---[ end trace 7042ddb87f73ead8 ]---
<4>[   68.637261] ------------[ cut here ]------------
<4>[   68.643114] WARNING: CPU: 2 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   68.656337] vblank not available on crtc 1, ret=-22
<4>[   68.661723] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   68.714487] CPU: 2 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   68.727175] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   68.732435]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066f0ffb8
<4>[   68.735994]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   68.738767]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   68.742352] Call Trace:
<4>[   68.743889]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   68.746021]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   68.748423]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   68.750841]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   68.754225]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   68.756606]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   68.760126]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   68.762619]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   68.766033]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   68.768585]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   68.771942]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   68.774341]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   68.777821]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   68.780213]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   68.782834]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   68.786134]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   68.788508]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   68.790775]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   68.793911]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   68.796093]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   68.798468] ---[ end trace 7042ddb87f73ead9 ]---
<3>[   74.429524] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder A FIFO underrun
<4>[   74.515869] ------------[ cut here ]------------
<4>[   74.521686] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   74.531653] vblank not available on crtc 1, ret=-22
<4>[   74.533684] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   74.555341] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   74.559369] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   74.562079]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   74.565712]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   74.569422]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000804
<4>[   74.572140] Call Trace:
<4>[   74.573584]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   74.575752]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   74.578119]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   74.581349]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   74.583958]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   74.586315]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   74.589770]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   74.593193]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   74.595724]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   74.598269]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   74.601649]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   74.604057]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   74.607518]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   74.609920]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   74.613405]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   74.615855]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   74.618202]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   74.621320]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   74.623605]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   74.625779]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   74.628188] ---[ end trace 7042ddb87f73eada ]---
<3>[   74.934127] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder A FIFO underrun
<3>[   75.002149] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
<3>[   75.006555] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder B FIFO underrun
<4>[   75.021132] ------------[ cut here ]------------
<4>[   75.023000] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   75.028491] vblank not available on crtc 1, ret=-22
<4>[   75.030578] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   75.052200] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   75.056072] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   75.059774]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   75.062542]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   75.066142]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   75.069754] Call Trace:
<4>[   75.070436]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   75.072571]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   75.075834]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   75.078164]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   75.080691]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   75.084118]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   75.086516]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   75.090032]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   75.092497]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   75.095932]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   75.098476]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   75.100919]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   75.104453]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   75.106646]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   75.110200]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   75.112726]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   75.115884]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   75.118100]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   75.120404]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   75.122660]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   75.125797] ---[ end trace 7042ddb87f73eadb ]---
<3>[   75.452232] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder A FIFO underrun
<3>[   75.524157] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder B FIFO underrun
<4>[   75.538431] ------------[ cut here ]------------
<4>[   75.539673] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   75.544304] vblank not available on crtc 1, ret=-22
<4>[   75.546417] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   75.568025] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   75.571984] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   75.575611]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   75.578503]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   75.581994]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   75.585623] Call Trace:
<4>[   75.586265]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   75.589286]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   75.591700]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   75.594063]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   75.597450]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   75.599857]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   75.602360]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   75.605866]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   75.608474]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   75.611776]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   75.614431]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   75.617579]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   75.620138]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   75.623416]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   75.626076]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   75.629413]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   75.631742]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   75.634065]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   75.636278]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   75.639299]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   75.641716] ---[ end trace 7042ddb87f73eadc ]---
<4>[   76.083770] ------------[ cut here ]------------
<4>[   76.085438] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   76.090890] vblank not available on crtc 1, ret=-22
<4>[   76.093045] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   76.113867] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   76.117686] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   76.121343]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   76.124965]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   76.127683]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   76.131368] Call Trace:
<4>[   76.132932]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   76.135159]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   76.137421]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   76.139796]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   76.143206]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   76.145641]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   76.149008]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   76.151646]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   76.154978]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   76.157526]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   76.160908]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   76.163444]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   76.166778]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   76.169073]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   76.171887]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   76.175145]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   76.177466]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   76.179751]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   76.182972]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   76.185028]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   76.187458] ---[ end trace 7042ddb87f73eadd ]---
<4>[   76.365568] ------------[ cut here ]------------
<4>[   76.367331] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   76.372935] vblank not available on crtc 1, ret=-22
<4>[   76.374959] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod
<3>[   76.378872] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder A FIFO underrun
<4>[   76.383064]  cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   76.401013] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   76.404848] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   76.408596]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   76.411294]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   76.414958]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000804
<4>[   76.418594] Call Trace:
<4>[   76.419225]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   76.421402]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   76.424621]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   76.427003]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   76.429546]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   76.432860]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   76.435430]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   76.438837]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   76.441372]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   76.444781]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   76.447238]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   76.450552]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   76.453224]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   76.455482]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   76.459017]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   76.461444]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   76.464703]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   76.466971]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   76.469266]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   76.471416]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   76.474658] ---[ end trace 7042ddb87f73eade ]---
<3>[   76.513575] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
<3>[   76.706220] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
<4>[   76.724173] ------------[ cut here ]------------
<4>[   76.726287] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   76.730951] vblank not available on crtc 1, ret=-22
<4>[   76.733135] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   76.754671] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   76.758526] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   76.762325]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   76.765023]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   76.768624]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   76.772293] Call Trace:
<4>[   76.772979]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   76.775011]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   76.778307]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   76.780637]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   76.784063]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   76.786490]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   76.789035]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   76.792536]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   76.794981]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   76.798433]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   76.800887]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   76.804197]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   76.806799]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   76.809149]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   76.812764]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   76.816002]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   76.818302]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   76.820573]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   76.822994]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   76.825076]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   76.828283] ---[ end trace 7042ddb87f73eadf ]---
<3>[   76.943533] [drm:intel_pch_fifo_underrun_irq_handler [i915]] *ERROR* PCH transcoder B FIFO underrun
<4>[   77.009964] ------------[ cut here ]------------
<4>[   77.011231] WARNING: CPU: 1 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   77.015884] vblank not available on crtc 1, ret=-22
<4>[   77.018852] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   77.039597] CPU: 1 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   77.043494] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   77.047288]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e8ffb8
<4>[   77.050810]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   77.053560]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000804
<4>[   77.057243] Call Trace:
<4>[   77.057876]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   77.060843]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   77.063266]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   77.065560]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   77.068988]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   77.071412]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   77.074834]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   77.077502]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   77.080841]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   77.083396]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   77.086766]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   77.089148]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   77.091828]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   77.094924]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   77.097706]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   77.100978]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   77.103290]  [<ffffffff810a81df>] ? pick_next_task_fair+0x6cf/0x8d0
<4>[   77.105750]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   77.108904]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   77.111211]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   77.113345]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   77.115755] ---[ end trace 7042ddb87f73eae0 ]---
<3>[   77.361672] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
<4>[   77.380572] ------------[ cut here ]------------
<4>[   77.382546] WARNING: CPU: 0 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   77.387971] vblank not available on crtc 1, ret=-22
<4>[   77.390049] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   77.411762] CPU: 0 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   77.415584] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   77.418399]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e0ffb8
<4>[   77.422097]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   77.425625]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   77.428396] Call Trace:
<4>[   77.429893]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   77.432179]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   77.435317]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   77.437645]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   77.440268]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   77.443477]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   77.446088]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   77.449507]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   77.452128]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   77.455447]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   77.457961]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   77.460381]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   77.463864]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   77.466157]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   77.469701]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   77.472237]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   77.475375]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   77.477629]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   77.479927]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   77.482179]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   77.485331] ---[ end trace 7042ddb87f73eae1 ]---
<4>[   77.660380] ------------[ cut here ]------------
<4>[   77.662288] WARNING: CPU: 0 PID: 1814 at drivers/gpu/drm/drm_irq.c:1080 drm_wait_one_vblank+0x180/0x190 [drm]()
<4>[   77.666992] vblank not available on crtc 1, ret=-22
<4>[   77.669036] Modules linked in: ipmi_watchdog ipmi_msghandler btrfs xor raid6_pq sg sr_mod sd_mod cdrom mxm_wmi pcspkr snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic snd_hda_intel thinkpad_acpi snd_hda_controller i915 ahci snd_hda_codec sdhci_pci libahci snd_hwdep rfkill libata sdhci uvcvideo parport_pc parport videobuf2_vmalloc snd_pcm videobuf2_core firewire_ohci snd_timer videobuf2_memops mmc_core v4l2_common video i2c_i801 intel_ips drm_kms_helper firewire_core videodev snd crc_itu_t drm wmi soundcore acpi_cpufreq
<4>[   77.690614] CPU: 0 PID: 1814 Comm: kms_setmode Tainted: G        W      3.18.0-rc2-g2d81df3 #1
<4>[   77.694549] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   77.698228]  0000000000000009 ffff88006393f998 ffffffff81877998 ffff880066e0ffb8
<4>[   77.700989]  ffff88006393f9e8 ffff88006393f9d8 ffffffff8106a561 ffff88006393f9d8
<4>[   77.704628]  ffff8800755d0000 ffff8800766e3800 0000000000000001 0000000080000004
<4>[   77.708249] Call Trace:
<4>[   77.708864]  [<ffffffff81877998>] dump_stack+0x4e/0x68
<4>[   77.711015]  [<ffffffff8106a561>] warn_slowpath_common+0x81/0xa0
<4>[   77.714289]  [<ffffffff8106a5c6>] warn_slowpath_fmt+0x46/0x50
<4>[   77.716715]  [<ffffffffa004c7e0>] drm_wait_one_vblank+0x180/0x190 [drm]
<4>[   77.720079]  [<ffffffffa023d10b>] ? gen5_read32+0x5b/0xe0 [i915]
<4>[   77.722461]  [<ffffffffa027ef97>] intel_disable_hdmi+0x1a7/0x1e0 [i915]
<4>[   77.725051]  [<ffffffffa02541aa>] ironlake_crtc_disable+0x15a/0x7a0 [i915]
<4>[   77.728497]  [<ffffffff811bd83c>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   77.730977]  [<ffffffffa025617b>] ? __intel_set_mode+0x4b/0xaf0 [i915]
<4>[   77.734430]  [<ffffffffa02563d7>] __intel_set_mode+0x2a7/0xaf0 [i915]
<4>[   77.736958]  [<ffffffffa025bdc6>] intel_set_mode+0x16/0x30 [i915]
<4>[   77.740208]  [<ffffffffa025cf52>] intel_crtc_set_config+0xa92/0xe90 [i915]
<4>[   77.742791]  [<ffffffff810904ca>] ? __might_sleep+0x3a/0xc0
<4>[   77.745145]  [<ffffffffa0054980>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   77.748692]  [<ffffffffa0059053>] drm_mode_setcrtc+0x283/0x580 [drm]
<4>[   77.752033]  [<ffffffffa004a9d7>] drm_ioctl+0x197/0x680 [drm]
<4>[   77.754333]  [<ffffffff811f0e60>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   77.756724]  [<ffffffff813958f7>] ? file_has_perm+0x87/0xa0
<4>[   77.758874]  [<ffffffff811f10e1>] SyS_ioctl+0x81/0xa0
<4>[   77.761148]  [<ffffffff81880369>] system_call_fastpath+0x12/0x17
<4>[   77.764321] ---[ end trace 7042ddb87f73eae2 ]---
<3>[   77.791744] [drm:intel_cpu_fifo_underrun_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--d6Gm4EdcadzBjdND--
