Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaKSCpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:45:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:49710 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbaKSCow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:44:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,414,1413270000"; 
   d="scan'208";a="624621792"
Date: Wed, 19 Nov 2014 10:45:19 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [drm/i915] Out of memory: Kill process 3058 (gem_userptr_bli)
 score 1002 or sacrifice child
Message-ID: <20141119024519.GE3938@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uCPdOCrL+PnN2Vxy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

commit ad46cb533d586fdb256855437af876617c6cf609 ("drm/i915: Prevent recursive deadlock on releasing a busy userptr")


       v3.17-rc4  ad46cb533d586fdb256855437a  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :5          100%           5:5     lkp-t410/piglit/performance-igt-002
           :5          100%           5:5     TOTAL piglit.igt/gem_userptr_blits/coherency-sync.crash

       v3.17-rc4  ad46cb533d586fdb256855437a  
----------------  --------------------------  
           :5          100%           5:5     lkp-t410/piglit/performance-igt-002
           :5          100%           5:5     TOTAL dmesg.Out_of_memory:Kill_process



<6>[   16.764414] BTRFS: device fsid 8886adc6-3306-411a-bbf8-6638ebb74746 devid 1 transid 57 /dev/sda6
<6>[   18.558946] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<6>[   69.352751] Purging GPU memory, 0 bytes freed, 12288 bytes still pinned.
<4>[   69.363044] gem_userptr_bli invoked oom-killer: gfp_mask=0xa00d2, order=0, oom_score_adj=1000
<6>[   69.373682] gem_userptr_bli cpuset=/ mems_allowed=0
<4>[   69.380617] CPU: 1 PID: 3058 Comm: gem_userptr_bli Not tainted 3.17.0-dirty #1
<4>[   69.390574] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   69.399759]  0000000000000000 ffff8800749d37d8 ffffffff81870560 ffff880074a00000
<4>[   69.409950]  ffff8800749d3840 ffffffff8186d528 ffff880000000015 0000000000000000
<4>[   69.419535]  00000000ffffffff ffff880076ffe0c0 0000000000000206 ffffffff81cf5440
<4>[   69.429544] Call Trace:
<4>[   69.435415]  [<ffffffff81870560>] dump_stack+0x4d/0x66
<4>[   69.442549]  [<ffffffff8186d528>] dump_header+0x9e/0x225
<4>[   69.448393]  [<ffffffff81163bed>] oom_kill_process+0x20d/0x380
<4>[   69.451840]  [<ffffffff81388a65>] ? security_capable_noaudit+0x15/0x20
<4>[   69.456166]  [<ffffffff81164419>] out_of_memory+0x4f9/0x540
<4>[   69.459434]  [<ffffffff8116ad58>] __alloc_pages_nodemask+0xab8/0xb00
<4>[   69.463816]  [<ffffffff811b130f>] alloc_pages_vma+0xaf/0x1c0
<4>[   69.467235]  [<ffffffff8117847f>] shmem_alloc_page+0x5f/0x90
<4>[   69.470444]  [<ffffffff81194cd9>] ? __vm_enough_memory+0x29/0x150
<4>[   69.474756]  [<ffffffff8117b490>] shmem_getpage_gfp+0x550/0x8e0
<4>[   69.478142]  [<ffffffff8117c371>] shmem_read_mapping_page_gfp+0x31/0x60
<4>[   69.481728]  [<ffffffffa01e830c>] i915_gem_object_get_pages_gtt+0x2dc/0x3b0 [i915]
<4>[   69.486341]  [<ffffffff811badec>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   69.490795]  [<ffffffffa00d20da>] ? drm_vma_node_allow+0x2a/0xe0 [drm]
<4>[   69.494314]  [<ffffffffa01e3ca0>] i915_gem_object_get_pages+0x50/0xb0 [i915]
<4>[   69.498890]  [<ffffffffa01ea789>] i915_gem_pwrite_ioctl+0x369/0x800 [i915]
<4>[   69.503486]  [<ffffffffa01e5d28>] ? i915_gem_create+0x58/0xe0 [i915]
<4>[   69.508875]  [<ffffffffa00b9df7>] drm_ioctl+0x197/0x680 [drm]
<4>[   69.513217]  [<ffffffff810a0928>] ? __enqueue_entity+0x78/0x80
<4>[   69.517707]  [<ffffffff810a2745>] ? set_next_entity+0x95/0xb0
<4>[   69.521943]  [<ffffffff811ed620>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   69.527080]  [<ffffffff8138e7c6>] ? file_has_perm+0x86/0xa0
<4>[   69.531373]  [<ffffffff811ed8a1>] SyS_ioctl+0x81/0xa0
<4>[   69.535560]  [<ffffffff81879229>] system_call_fastpath+0x16/0x1b
<4>[   69.539938] Mem-Info:
<4>[   69.543345] Node 0 DMA per-cpu:
<4>[   69.547209] CPU    0: hi:    0, btch:   1 usd:   0


	--yliu

--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-dirty (kbuild@lkp-sb04) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Nov 7 05:42:13 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty user=lkp job=/lkp/scheduled/lkp-t410/backwards_piglit-performance-igt-002-x86_64-rhel-bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty kconfig=x86_64-rhel commit=bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9 branch=linus/master root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-002/debian-x86_64.cgz/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
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
[    0.000000] BRK [0x0219f000, 0x0219ffff] PGTABLE
[    0.000000] BRK [0x021a0000, 0x021a0fff] PGTABLE
[    0.000000] BRK [0x021a1000, 0x021a1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x66c00000-0x66dfffff]
[    0.000000]  [mem 0x66c00000-0x66dfffff] page 2M
[    0.000000] BRK [0x021a2000, 0x021a2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x64000000-0x66bfffff]
[    0.000000]  [mem 0x64000000-0x66bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x63ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x63ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x66e00000-0x7727bfff]
[    0.000000]  [mem 0x66e00000-0x771fffff] page 2M
[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
[    0.000000] BRK [0x021a3000, 0x021a3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
[    0.000000] BRK [0x021a4000, 0x021a4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
[    0.000000] RAMDISK: [mem 0x66fff000-0x7727bfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140724/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140724/tbfadt-699)
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
[    0.000000]   NODE_DATA [mem 0x77746000-0x7776bfff]
[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880064800000-ffff8800665fffff] on node 0
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
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880066c00000 s88960 r8192 d21632 u524288
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty user=lkp job=/lkp/scheduled/lkp-t410/backwards_piglit-performance-igt-002-x86_64-rhel-bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty kconfig=x86_64-rhel commit=bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9 branch=linus/master root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-002/debian-x86_64.cgz/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 1639028K/1953472K available (8696K kernel code, 1698K rwdata, 3892K rodata, 1808K init, 1888K bss, 314444K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:456 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 7864320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2394.076 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.15 BogoMIPS (lpj=2394076)
[    0.000729] pid_max: default: 32768 minimum: 301
[    0.001044] ACPI: Core revision 20140724
[    0.021430] ACPI: All ACPI Tables successfully acquired
[    0.021911] Security Framework initialized
[    0.022201] SELinux:  Initializing.
[    0.022451] SELinux:  Starting in permissive mode
[    0.022919] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.024061] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.024798] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.025226] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.025937] Initializing cgroup subsys memory
[    0.026278] Initializing cgroup subsys devices
[    0.026619] Initializing cgroup subsys freezer
[    0.026960] Initializing cgroup subsys net_cls
[    0.027300] Initializing cgroup subsys blkio
[    0.027630] Initializing cgroup subsys perf_event
[    0.027986] Initializing cgroup subsys hugetlb
[    0.028347] CPU: Physical Processor ID: 0
[    0.028662] CPU: Processor Core ID: 0
[    0.028963] mce: CPU supports 9 MCE banks
[    0.029287] CPU0: Thermal monitoring enabled (TM1)
[    0.029655] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.029655] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.030537] Freeing SMP alternatives memory: 36K (ffffffff81fbc000 - ffffffff81fc5000)
[    0.032291] ftrace: allocating 31126 entries in 122 pages
[    0.047952] Getting VERSION: 1060015
[    0.048249] Getting VERSION: 1060015
[    0.048539] Getting ID: 0
[    0.048776] Getting ID: 0
[    0.049020] masked ExtINT on CPU#0
[    0.049611] ENABLING IO-APIC IRQs
[    0.049888] init IO_APIC IRQs
[    0.050144]  apic 1 pin 0 not connected
[    0.050455] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.051031] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.051608] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.052188] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.052782] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.053360] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.053939] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.054514] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.055091] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.055669] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.056247] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.056837] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.057424] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.058010] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.058598] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.059187] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.059773]  apic 1 pin 16 not connected
[    0.060083]  apic 1 pin 17 not connected
[    0.060393]  apic 1 pin 18 not connected
[    0.060705]  apic 1 pin 19 not connected
[    0.061015]  apic 1 pin 20 not connected
[    0.061325]  apic 1 pin 21 not connected
[    0.061635]  apic 1 pin 22 not connected
[    0.061945]  apic 1 pin 23 not connected
[    0.062395] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072830] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
[    0.073669] Using local APIC timer interrupts.
[    0.073669] calibrating APIC timer ...
[    0.175605] ... lapic delta = 831240
[    0.175896] ... PM-Timer delta = 357950
[    0.176200] ... PM-Timer result ok
[    0.176482] ..... delta 831240
[    0.176743] ..... mult: 35701486
[    0.177014] ..... calibration result: 132998
[    0.177344] ..... CPU clock speed is 2393.0970 MHz.
[    0.177708] ..... host bus clock speed is 132.0998 MHz.
[    0.178128] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.178943] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.179423] ... version:                3
[    0.179740] ... bit width:              48
[    0.180061] ... generic registers:      4
[    0.180378] ... value mask:             0000ffffffffffff
[    0.180767] ... max period:             000000007fffffff
[    0.181156] ... fixed-purpose events:   3
[    0.181471] ... event mask:             000000070000000f
[    0.183454] x86: Booting SMP configuration:
[    0.183780] .... node  #0, CPUs:      #1
[    0.195264] masked ExtINT on CPU#1
[    0.197673] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.198367]  #2
[    0.209525] masked ExtINT on CPU#2
[    0.211973]  #3
[    0.223137] masked ExtINT on CPU#3
[    0.225479] x86: Booted up 1 node, 4 CPUs
[    0.225795] smpboot: Total of 4 processors activated (19152.60 BogoMIPS)
[    0.228747] devtmpfs: initialized
[    0.232434] evm: security.selinux
[    0.232710] evm: security.ima
[    0.232967] evm: security.capability
[    0.233422] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
[    0.234005] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
[    0.234591] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
[    0.235163] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
[    0.235733] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
[    0.237431] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.238009] NET: Registered protocol family 16
[    0.238591] cpuidle: using governor menu
[    0.239058] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.239616] ACPI: bus type PCI registered
[    0.239933] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.240449] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.241104] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.242076] PCI: Using configuration type 1 for base access
[    0.246023] ACPI: Added _OSI(Module Device)
[    0.246354] ACPI: Added _OSI(Processor Device)
[    0.246693] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.247048] ACPI: Added _OSI(Processor Aggregator Device)
[    0.249024] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
[    0.249633] ACPI : EC: EC description table is found, configuring boot EC
[    0.256128] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.332939] ACPI: Dynamic OEM Table Load:
[    0.333362] ACPI: SSDT 0xFFFF880063AD8800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
[    0.334716] ACPI: Dynamic OEM Table Load:
[    0.335138] ACPI: SSDT 0xFFFF880063AD9000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
[    0.340326] ACPI: Dynamic OEM Table Load:
[    0.340752] ACPI: SSDT 0xFFFF880063A29400 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
[    0.343835] ACPI: Dynamic OEM Table Load:
[    0.344254] ACPI: SSDT 0xFFFF880063424000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
[    0.349115] ACPI: Interpreter enabled
[    0.349417] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.350172] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.350937] ACPI: (supports S0 S3 S4 S5)
[    0.351247] ACPI: Using IOAPIC for interrupt routing
[    0.351646] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.358867] ACPI: Power Resource [PUBS] (on)
[    0.359978] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.362400] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.365111] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.366370] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.367623] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.368881] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.370134] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.371390] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.372643] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.373897] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.375139] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
[    0.375569] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.376168] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.376679] PCI host bridge to bus 0000:ff
[    0.377004] pci_bus 0000:ff: root bus resource [bus ff]
[    0.377393] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.377871] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.378347] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.378816] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.379284] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.379756] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.380257] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.380700] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.382156] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.382784] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.383432] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.384000] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.384555] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.385223] PCI host bridge to bus 0000:00
[    0.385544] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.385946] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.386385] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.386823] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.387297] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.387774] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.388251] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
[    0.388728] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.389211] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.389653] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.390271] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.390712] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
[    0.391189] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.391731] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
[    0.392250] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.392709] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
[    0.393271] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.393787] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.394238] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
[    0.394650] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
[    0.395262] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    0.395716] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
[    0.396167] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
[    0.396619] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
[    0.397112] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.397590] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.398043] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.398494] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
[    0.399045] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.399523] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.399978] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.400427] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.401007] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.401496] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.401948] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.402479] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.402961] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.403410] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.403943] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.404423] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.404873] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.405404] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.405887] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.406335] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.406870] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.407341] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.407796] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.408247] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
[    0.408796] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.409272] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.409721] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.410284] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    0.410891] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
[    0.411344] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
[    0.411758] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
[    0.412170] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
[    0.412583] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
[    0.412998] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
[    0.413410] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
[    0.413917] pci 0000:00:1f.2: PME# supported from D3hot
[    0.414378] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.414826] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
[    0.415324] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
[    0.415826] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.416279] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
[    0.416964] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.417438] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
[    0.417909] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
[    0.418580] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.420743] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.421121] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.421694] acpiphp: Slot [1] registered
[    0.422013] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.422400] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.422836] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.423311] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.424015] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
[    0.424507] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.425066] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
[    0.425728] pci 0000:0d:00.0: supports D1 D2
[    0.426057] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.426691] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
[    0.427191] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
[    0.427846] pci 0000:0d:00.1: supports D1 D2
[    0.428176] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.428809] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
[    0.429307] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
[    0.429961] pci 0000:0d:00.3: supports D1 D2
[    0.430292] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.432806] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.433189] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.433750] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
[    0.434236] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.434816] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.435394] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.436009] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.436626] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.437243] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
[    0.437860] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
[    0.438703] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    0.440702] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.441224] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.441824] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.442232] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.442820] vgaarb: loaded
[    0.443062] vgaarb: bridge control possible 0000:00:02.0
[    0.443537] SCSI subsystem initialized
[    0.443871] ACPI: bus type USB registered
[    0.444206] usbcore: registered new interface driver usbfs
[    0.444616] usbcore: registered new interface driver hub
[    0.445043] usbcore: registered new device driver usb
[    0.445446] pps_core: LinuxPPS API ver. 1 registered
[    0.445816] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.446468] PTP clock support registered
[    0.446850] PCI: Using ACPI for IRQ routing
[    0.456994] PCI: pci_cache_line_size set to 64 bytes
[    0.457530] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.457958] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
[    0.458387] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
[    0.458815] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
[    0.459242] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
[    0.459672] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
[    0.460101] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
[    0.460646] NetLabel: Initializing
[    0.460928] NetLabel:  domain hash size = 128
[    0.461265] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.461649] NetLabel:  unlabeled traffic allowed by default
[    0.462210] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.463102] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.465560] Switched to clocksource hpet
[    0.475558] pnp: PnP ACPI init
[    0.477532] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.478024] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.478505] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.478994] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.479456] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.479925] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.480406] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.480893] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.481374] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.481860] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.482341] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.482828] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.483309] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
[    0.483798] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.484279] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.484769] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.485611] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.486036] system 00:01: [io  0x1000-0x107f] could not be reserved
[    0.486479] system 00:01: [io  0x1180-0x11ff] has been reserved
[    0.486911] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.487335] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.487766] system 00:01: [io  0x1600-0x1641] has been reserved
[    0.488190] system 00:01: [io  0x1644-0x167f] could not be reserved
[    0.488641] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.489105] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.489566] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.490619] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.491081] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.491542] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.492011] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.492533] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    0.493140] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.493617] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
[    0.494216] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.494693] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
[    0.495300] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.496191] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.497512] pnp: PnP ACPI: found 6 devices
[    0.504663] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.505046] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.505419] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
[    0.505906] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.506292] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.506735] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    0.507209] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.507788] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.508161] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.508648] pci 0000:00:1e.0: PCI bridge to [bus 0e]
[    0.509031] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.509436] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.509845] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.510288] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.510737] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.511180] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.511627] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.512075] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
[    0.512518] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.512927] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    0.513370] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    0.513912] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.514355] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.514765] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.515169] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.515619] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.516062] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.516505] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
[    0.516952] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
[    0.517427] NET: Registered protocol family 2
[    0.517972] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.518568] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.519114] TCP: Hash tables configured (established 16384 bind 16384)
[    0.519608] TCP: reno registered
[    0.519883] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.520325] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.520842] NET: Registered protocol family 1
[    0.521278] RPC: Registered named UNIX socket transport module.
[    0.521718] RPC: Registered udp transport module.
[    0.522073] RPC: Registered tcp transport module.
[    0.522427] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.522913] pci 0000:00:02.0: Video device with shadowed ROM
[    0.523418] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    0.524163] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    0.524907] PCI: CLS 64 bytes, default 64
[    0.525275] Unpacking initramfs...
[    4.875632] Freeing initrd memory: 264692K (ffff880066fff000 - ffff88007727c000)
[    4.876380] Simple Boot Flag at 0x35 set to 0x1
[    4.877623] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    4.878091] Initialise system trusted keyring
[    4.878461] audit: initializing netlink subsys (disabled)
[    4.878871] audit: type=2000 audit(1416196077.646:1): initialized
[    4.879677] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.881661] zpool: loaded
[    4.881901] zbud: loaded
[    4.882309] VFS: Disk quotas dquot_6.5.2
[    4.882662] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.883641] SGI XFS with ACLs, security attributes, no debug enabled
[    4.884552] 9p: Installing v9fs 9p2000 file system support
[    4.884982] msgmni has been set to 3718
[    4.885358] Key type big_key registered
[    4.885667] SELinux:  Registering netfilter hooks
[    4.886913] NET: Registered protocol family 38
[    4.887260] Key type asymmetric registered
[    4.887591] Asymmetric key parser 'x509' registered
[    4.887993] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    4.888624] io scheduler noop registered
[    4.888943] io scheduler deadline registered (default)
[    4.889337] io scheduler cfq registered
[    4.889849] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    4.890571] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    4.891273] IOAPIC[0]: Set routing entry (1-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    4.892082] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.892510] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.893017] intel_idle: MWAIT substates: 0x1120
[    4.893370] intel_idle: v0.4 model 0x25
[    4.893676] intel_idle: lapic_timer_reliable_states 0xffffffff
[    4.894882] ACPI: AC Adapter [AC] (on-line)
[    4.895337] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    4.896769] ACPI: Lid Switch [LID]
[    4.897147] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    4.897798] ACPI: Sleep Button [SLPB]
[    4.898189] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    4.898747] ACPI: Power Button [PWRF]
[    4.905710] thermal LNXTHERM:00: registered as thermal_zone0
[    4.906121] ACPI: Thermal Zone [THM0] (49 C)
[    4.906582] GHES: HEST is not enabled!
[    4.907108] ACPI: Battery Slot [BAT0] (battery absent)
[    4.907226] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.908257] IOAPIC[0]: Set routing entry (1-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:15)
[    4.909018] console [ttyS0] disabled
[    4.929882] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
[    5.878999] tsc: Refined TSC clocksource calibration: 2394.000 MHz
[    6.770574] console [ttyS0] enabled
[    6.772863] Non-volatile memory driver v1.3
[    6.774243] Linux agpgart interface v0.103
[    6.776335] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    6.778588] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    6.782998] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    6.785072] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    6.789488] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    6.827612] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
[    6.831311] IOAPIC[0]: Set routing entry (1-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    6.833936] mei_me 0000:00:16.0: irq 24 for MSI/MSI-X
[    6.838331] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140724/utaddress-258)
[    6.846124] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.851061] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140724/utaddress-258)
[    6.858003] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.863085] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140724/utaddress-258)
[    6.870080] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.875162] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140724/utaddress-258)
[    6.882916] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.887215] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.889642] Switched to clocksource tsc
[    6.889667] rdac: device handler registered
[    6.889702] hp_sw: device handler registered
[    6.889705] emc: device handler registered
[    6.889709] alua: device handler registered
[    6.889746] libphy: Fixed MDIO Bus: probed
[    6.889788] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.889789] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.889803] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.889803] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    6.889967] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.889996] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    7.071860] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
[    7.074937] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.078429] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
[    7.081002] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[    7.084525] igb: Copyright (c) 2007-2014 Intel Corporation.
[    7.086930] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    7.090535] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    7.092990] usbcore: registered new interface driver catc
[    7.095142] usbcore: registered new interface driver kaweth
[    7.098245] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    7.101092] usbcore: registered new interface driver pegasus
[    7.104179] usbcore: registered new interface driver rtl8150
[    7.106574] usbcore: registered new interface driver asix
[    7.108742] usbcore: registered new interface driver cdc_ether
[    7.111205] usbcore: registered new interface driver cdc_eem
[    7.114301] usbcore: registered new interface driver dm9601
[    7.116827] usbcore: registered new interface driver smsc75xx
[    7.119936] usbcore: registered new interface driver smsc95xx
[    7.123154] usbcore: registered new interface driver gl620a
[    7.125456] usbcore: registered new interface driver net1080
[    7.128730] usbcore: registered new interface driver plusb
[    7.131207] usbcore: registered new interface driver rndis_host
[    7.134260] usbcore: registered new interface driver cdc_subset
[    7.136725] usbcore: registered new interface driver zaurus
[    7.138935] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    7.142532] usbcore: registered new interface driver int51x1
[    7.144789] usbcore: registered new interface driver ipheth
[    7.147202] usbcore: registered new interface driver sierra_net
[    7.150446] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.152908] ehci-pci: EHCI PCI platform driver
[    7.155100] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    7.157258] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.160744] ehci-pci 0000:00:1a.0: debug port 2
[    7.166684] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    7.170196] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
[    7.177796] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.179873] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.183277] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.186133] usb usb1: Product: EHCI Host Controller
[    7.188967] usb usb1: Manufacturer: Linux 3.17.0-dirty ehci_hcd
[    7.191421] usb usb1: SerialNumber: 0000:00:1a.0
[    7.193631] hub 1-0:1.0: USB hub found
[    7.195242] hub 1-0:1.0: 3 ports detected
[    7.197435] IOAPIC[0]: Set routing entry (1-19 -> 0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    7.200192] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    7.203256] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.205913] ehci-pci 0000:00:1d.0: debug port 2
[    7.211877] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    7.215408] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
[    7.222824] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.225137] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.228496] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.232058] usb usb2: Product: EHCI Host Controller
[    7.234165] usb usb2: Manufacturer: Linux 3.17.0-dirty ehci_hcd
[    7.236628] usb usb2: SerialNumber: 0000:00:1d.0
[    7.238794] hub 2-0:1.0: USB hub found
[    7.240419] hub 2-0:1.0: 3 ports detected
[    7.242528] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.244787] ohci-pci: OHCI PCI platform driver
[    7.246810] uhci_hcd: USB Universal Host Controller Interface driver
[    7.250186] usbcore: registered new interface driver usbserial
[    7.252489] usbcore: registered new interface driver usbserial_generic
[    7.255014] usbserial: USB Serial support registered for generic
[    7.258302] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    7.265008] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.267116] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.269558] mousedev: PS/2 mouse device common for all mice
[    7.272138] rtc_cmos 00:02: RTC can wake from S4
[    7.273970] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    7.276161] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    7.276634] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    7.283734] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    7.286154] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
[    7.289656] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.291889] iTCO_vendor_support: vendor-support=0
[    7.294686] hidraw: raw HID events driver (C) Jiri Kosina
[    7.298238] usbcore: registered new interface driver usbhid
[    7.300319] usbhid: USB HID core driver
[    7.302187] drop_monitor: Initializing network drop monitor service
[    7.304742] TCP: cubic registered
[    7.306378] Initializing XFRM netlink socket
[    7.308514] NET: Registered protocol family 10
[    7.310698] NET: Registered protocol family 17
[    7.312268] 9pnet: Installing 9P2000 support
[    7.314938] 
[    7.314938] printing PIC contents
[    7.317345] ... PIC  IMR: ffff
[    7.318946] ... PIC  IRR: 0800
[    7.319859] ... PIC  ISR: 0000
[    7.321461] ... PIC ELCR: 0800
[    7.323065] printing local APIC contents on CPU#0/0:
[    7.325119] ... APIC ID:      00000000 (0)
[    7.327048] ... APIC VERSION: 01060015
[    7.328087] ... APIC TASKPRI: 00000000 (00)
[    7.329883] ... APIC PROCPRI: 00000000
[    7.331804] ... APIC LDR: 01000000
[    7.333459] ... APIC DFR: ffffffff
[    7.335175] ... APIC SPIV: 000001ff
[    7.336968] ... APIC ISR field:
[    7.337857] 0000000000000000000000000000000000000000000000000000000000000000
[    7.341511] ... APIC TMR field:
[    7.342974] 0000000002000000000200020002000200000002000000000002000000000000
[    7.345845] ... APIC IRR field:
[    7.347295] 0000000010000000000000000000000000000000000000000000000000000000
[    7.350282] ... APIC ESR: 00000000
[    7.351767] ... APIC ICR: 000008fd
[    7.353410] ... APIC ICR2: 02000000
[    7.355165] ... APIC LVTT: 000000ef
[    7.356923] ... APIC LVTPC: 00000400
[    7.357883] ... APIC LVT0: 00010700
[    7.359559] ... APIC LVT1: 00000400
[    7.361404] ... APIC LVTERR: 000000fe
[    7.363146] ... APIC TMICT: 0079cbc4
[    7.364916] ... APIC TMCCT: 00736895
[    7.365972] ... APIC TDCR: 00000003
[    7.367561] 
[    7.368055] number of MP IRQ sources: 15.
[    7.369875] number of IO-APIC #1 registers: 24.
[    7.372029] testing the IO APIC.......................
[    7.374991] IO APIC #1......
[    7.375814] .... register #00: 02000000
[    7.377521] .......    : physical APIC id: 02
[    7.379503] .......    : Delivery Type: 0
[    7.381451] .......    : LTS          : 0
[    7.383268] .... register #01: 00170020
[    7.385107] .......     : max redirection entries: 17
[    7.387307] .......     : PRQ implemented: 0
[    7.389208] .......     : IO APIC version: 20
[    7.391248] .... IRQ redirection table:
[    7.393043] 1    0    0   0   0    0    0    00
[    7.395086] 0    0    0   0   0    1    1    31
[    7.397068] 0    0    0   0   0    1    1    30
[    7.399112] 0    0    0   0   0    1    1    33
[    7.401177] 0    0    0   0   0    1    1    34
[    7.403150] 0    0    0   0   0    1    1    35
[    7.405138] 0    0    0   0   0    1    1    36
[    7.407212] 0    0    0   0   0    1    1    37
[    7.409235] 0    0    0   0   0    1    1    38
[    7.411336] 0    1    0   0   0    1    1    39
[    7.413240] 0    0    0   0   0    1    1    3A
[    7.415328] 0    0    0   0   0    1    1    3B
[    7.417288] 0    0    0   0   0    1    1    3C
[    7.419331] 0    0    0   0   0    1    1    3D
[    7.421426] 0    0    0   0   0    1    1    3E
[    7.423343] 0    0    0   0   0    1    1    3F
[    7.425400] 1    1    0   1   0    1    1    A1
[    7.427393] 1    1    0   1   0    1    1    91
[    7.429464] 1    0    0   0   0    0    0    00
[    7.431513] 0    1    0   1   0    1    1    D1
[    7.433467] 1    1    0   1   0    1    1    61
[    7.435468] 1    1    0   1   0    1    1    71
[    7.437496] 1    0    0   0   0    0    0    00
[    7.439515] 0    1    0   1   0    1    1    81
[    7.441618] IRQ to pin mappings:
[    7.443226] IRQ0 -> 0:2
[    7.444032] IRQ1 -> 0:1
[    7.445493] IRQ3 -> 0:3
[    7.446333] IRQ4 -> 0:4
[    7.447532] IRQ5 -> 0:5
[    7.448995] IRQ6 -> 0:6
[    7.449806] IRQ7 -> 0:7
[    7.451222] IRQ8 -> 0:8
[    7.452040] IRQ9 -> 0:9
[    7.453270] IRQ10 -> 0:10
[    7.454164] IRQ11 -> 0:11
[    7.455523] IRQ12 -> 0:12
[    7.456962] IRQ13 -> 0:13
[    7.457869] IRQ14 -> 0:14
[    7.459211] IRQ15 -> 0:15
[    7.460093] IRQ16 -> 0:16
[    7.461493] IRQ17 -> 0:17
[    7.462357] IRQ19 -> 0:19
[    7.463598] IRQ20 -> 0:20
[    7.465077] IRQ21 -> 0:21
[    7.466050] IRQ23 -> 0:23
[    7.467340] .................................... done.
[    7.469980] Loading compiled-in X.509 certificates
[    7.474664] Loaded X.509 cert 'Magrathea: Glacier signing key: d9d6b1769705ac0dbc53a286c5288e808793c1ae'
[    7.478642] registered taskstats version 1
[    7.484186] Key type trusted registered
[    7.488066] Key type encrypted registered
[    7.496953] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
[    7.498964] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    7.502425] ima: No TPM chip found, activating TPM-bypass!
[    7.504756] evm: HMAC attrs: 0x1
[    7.507440] rtc_cmos 00:02: setting system clock to 2014-11-17 03:48:00 UTC (1416196080)
[    7.613650] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    7.615284] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    7.618785] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.621995] hub 1-1:1.0: USB hub found
[    7.623396] hub 1-1:1.0: 6 ports detected
[    7.716139] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    7.718493] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.728091] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    7.845784] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    7.847822] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.851732] hub 2-1:1.0: USB hub found
[    7.853187] hub 2-1:1.0: 8 ports detected
[    7.919494] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
[    8.007753] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    8.011184] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.013754] usb 1-1.3: Product: Biometric Coprocessor
[    8.016085] usb 1-1.3: Manufacturer: UPEK
[    8.091593] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
[    8.186353] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
[    8.188788] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.192459] usb 1-1.6: Product: Integrated Camera
[    8.194489] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    8.265576] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
[    8.270879] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    8.326573] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[   10.211138] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   10.222707] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.233630] Sending DHCP requests .., OK
[   13.105531] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
[   13.119359] IP-Config: Complete:
[   13.121388]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
[   13.127698]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
[   13.131095]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   13.133723]      nameserver0=192.168.1.1
[   13.135676] PM: Hibernation image not present or could not be loaded.
[   13.140199] Freeing unused kernel memory: 1808K (ffffffff81df8000 - ffffffff81fbc000)
[   13.328566] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[   13.339789] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
[   13.348676] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   13.353466] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   13.358588] libata version 3.00 loaded.
[   13.376241] wmi: Mapper loaded
[   13.397674] ahci 0000:00:1f.2: version 3.0
[   13.399337] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[   13.404757] [drm] Initialized drm 1.1.0 20060810
[   13.412684] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[   13.414817] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
[   13.418694] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
[   13.438980] sdhci: Secure Digital Host Controller Interface driver
[   13.441979] sdhci: Copyright(c) Pierre Ossman
[   13.442874] scsi host0: ahci
[   13.445925] scsi host1: ahci
[   13.447552] scsi host2: ahci
[   13.449488] scsi host3: ahci
[   13.450668] scsi host4: ahci
[   13.453336] scsi host5: ahci
[   13.454928] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 26
[   13.457598] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 26
[   13.461199] ata3: DUMMY
[   13.462009] ata4: DUMMY
[   13.463384] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 26
[   13.466898] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 26
[   13.470103] snd_hda_intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[   13.481129] [drm] Memory usable by graphics device = 2048M
[   13.483161] [drm] Replacing VGA console driver
[   13.485578] Console: switching to colour dummy device 80x25
[   13.490959] sound hdaudioC0D0: CX20585: BIOS auto-probing.
[   13.493169] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[   13.496473] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.497844] i915 0000:00:02.0: irq 28 for MSI/MSI-X
[   13.497862] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   13.497863] [drm] Driver supports precise vblank timestamp query.
[   13.498687] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.503326] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[   13.503390] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
[   13.503568] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   13.503576] sdhci-pci 0000:0d:00.0: No vmmc regulator found
[   13.503578] sdhci-pci 0000:0d:00.0: No vqmmc regulator found
[   13.505326] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[   13.509367] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.534828] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
[   13.538098] sound hdaudioC0D0:    mono: mono_out=0x0
[   13.540107] sound hdaudioC0D0:    inputs:
[   13.541946] sound hdaudioC0D0:      Mic=0x1b
[   13.543907] sound hdaudioC0D0:      Internal Mic=0x23
[   13.546106] sound hdaudioC0D0:      Dock Mic=0x1a
[   13.550488] sound hdaudioC0D0: Enable sync_write for stable communication
[   13.559438] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[   13.561731] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.563813] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
[   13.566478] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
[   13.570725] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[   13.573654] thinkpad_acpi: radio switch found; radios are disabled
[   13.576860] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   13.581187] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   13.589763] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
[   13.596459] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   13.600988] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   13.615254] Linux video capture interface: v2.00
[   13.615409] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
[   13.631601] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   13.634998] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   13.636761] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[   13.643895] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   13.647975] fbcon: inteldrmfb (fb0) is primary device
[   13.648120] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   13.648312] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   13.648504] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   13.648710] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   13.657855] input: PC Speaker as /devices/platform/pcspkr/input/input15
[   13.661124] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
[   13.662374] Error: Driver 'pcspkr' is already registered, aborting...
[   13.662429] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input16
[   13.662551] usbcore: registered new interface driver uvcvideo
[   13.662552] USB Video Class driver (1.1.1)
[   13.801834] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
[   13.931002] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   13.932756] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.932760] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   13.932971] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.932977] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   13.934754] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
[   13.934757] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   13.936584] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.936588] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   13.936823] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[   13.936827] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[   13.938678] ata1.00: configured for UDMA/100
[   13.938957] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
[   14.003198] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
[   14.141210] Console: switching to colour frame buffer device 160x50
[   14.238101] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   14.242483] i915 0000:00:02.0: registered panic notifier
[   14.263682] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   14.277443] acpi device:01: registered as cooling_device4
[   14.281624] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input17
[   14.287777] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
[   14.399304] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.411410] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   14.421937] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   14.428124] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
[   14.445831] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[   14.456321] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[   14.462483] ata2.00: configured for UDMA/100
[   14.481823] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
[   14.813545] ata5: SATA link down (SStatus 0 SControl 300)
[   15.122738] ata6: SATA link down (SStatus 0 SControl 300)
[   15.153784] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[   15.159163] sd 0:0:0:0: [sda] Write Protect is off
[   15.163138] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.167349] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.179339] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   15.185200] cdrom: Uniform CD-ROM driver Revision: 3.20
[   15.190725] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   15.200728] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.204748] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   15.579961]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   15.585608] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.735694] random: nonblocking pool is initialized
[   16.598559] raid6: sse2x1    2878 MB/s
[   16.621558] raid6: sse2x2    3335 MB/s
[   16.644574] raid6: sse2x4    3742 MB/s
[   16.650901] raid6: using algorithm sse2x4 (3742 MB/s)
[   16.658464] raid6: using ssse3x2 recovery algorithm
[   16.669531] xor: measuring software checksum speed
[   16.686567]    prefetch64-sse:  4976.000 MB/sec
[   16.703621]    generic_sse:  4388.000 MB/sec
[   16.710126] xor: using function: prefetch64-sse (4976.000 MB/sec)
[   16.755535] Btrfs loaded
[   16.764414] BTRFS: device fsid 8886adc6-3306-411a-bbf8-6638ebb74746 devid 1 transid 57 /dev/sda6
[   18.558946] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.17.0-dirty (kbuild@lkp-sb04) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Nov 7 05:42:13 CST 2014
<6>[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty user=lkp job=/lkp/scheduled/lkp-t410/backwards_piglit-performance-igt-002-x86_64-rhel-bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty kconfig=x86_64-rhel commit=bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9 branch=linus/master root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-002/debian-x86_64.cgz/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
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
<7>[    0.000000] BRK [0x0219f000, 0x0219ffff] PGTABLE
<7>[    0.000000] BRK [0x021a0000, 0x021a0fff] PGTABLE
<7>[    0.000000] BRK [0x021a1000, 0x021a1fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x66c00000-0x66dfffff]
<7>[    0.000000]  [mem 0x66c00000-0x66dfffff] page 2M
<7>[    0.000000] BRK [0x021a2000, 0x021a2fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x64000000-0x66bfffff]
<7>[    0.000000]  [mem 0x64000000-0x66bfffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x63ffffff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x63ffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x66e00000-0x7727bfff]
<7>[    0.000000]  [mem 0x66e00000-0x771fffff] page 2M
<7>[    0.000000]  [mem 0x77200000-0x7727bfff] page 4k
<7>[    0.000000] BRK [0x021a3000, 0x021a3fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x77282000-0x77362fff]
<7>[    0.000000]  [mem 0x77282000-0x77362fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x7740f000-0x7746efff]
<7>[    0.000000]  [mem 0x7740f000-0x7746efff] page 4k
<7>[    0.000000] BRK [0x021a4000, 0x021a4fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x7770f000-0x77716fff]
<7>[    0.000000]  [mem 0x7770f000-0x77716fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x7771f000-0x7776bfff]
<7>[    0.000000]  [mem 0x7771f000-0x7776bfff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x777ff000-0x777fffff]
<7>[    0.000000]  [mem 0x777ff000-0x777fffff] page 4k
<6>[    0.000000] RAMDISK: [mem 0x66fff000-0x7727bfff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F6890 000024 (v02 LENOVO)
<4>[    0.000000] ACPI: XSDT 0x00000000777EF947 000094 (v01 LENOVO TP-6I    00001120  LTP 00000000)
<4>[    0.000000] ACPI: FACP 0x00000000777EFB00 0000F4 (v04 LENOVO TP-6I    00001120 LNVO 00000001)
<4>[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140724/tbfadt-618)
<4>[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140724/tbfadt-699)
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
<6>[    0.000000] Initmem setup node 0 [mem 0x00000000-0x777fffff]
<6>[    0.000000]   NODE_DATA [mem 0x77746000-0x7776bfff]
<7>[    0.000000]  [ffffea0000000000-ffffea0001dfffff] PMD -> [ffff880064800000-ffff8800665fffff] on node 0
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
<6>[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880066c00000 s88960 r8192 d21632 u524288
<7>[    0.000000] pcpu-alloc: s88960 r8192 d21632 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<4>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 480699
<4>[    0.000000] Policy zone: DMA32
<5>[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty user=lkp job=/lkp/scheduled/lkp-t410/backwards_piglit-performance-igt-002-x86_64-rhel-bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/vmlinuz-3.17.0-dirty kconfig=x86_64-rhel commit=bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9 branch=linus/master root=/dev/ram0 max_uptime=1800 RESULT_ROOT=/result/lkp-t410/piglit/performance-igt-002/debian-x86_64.cgz/x86_64-rhel/bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9/0 ip=::::lkp-t410::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 1639028K/1953472K available (8696K kernel code, 1698K rwdata, 3892K rodata, 1808K init, 1888K bss, 314444K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
<6>[    0.000000] NR_IRQS:524544 nr_irqs:456 0
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 7864320 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 2394.076 MHz processor
<6>[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.15 BogoMIPS (lpj=2394076)
<6>[    0.000729] pid_max: default: 32768 minimum: 301
<6>[    0.001044] ACPI: Core revision 20140724
<4>[    0.021430] ACPI: All ACPI Tables successfully acquired
<6>[    0.021911] Security Framework initialized
<6>[    0.022201] SELinux:  Initializing.
<7>[    0.022451] SELinux:  Starting in permissive mode
<6>[    0.022919] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.024061] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
<6>[    0.024798] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.025226] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.025937] Initializing cgroup subsys memory
<6>[    0.026278] Initializing cgroup subsys devices
<6>[    0.026619] Initializing cgroup subsys freezer
<6>[    0.026960] Initializing cgroup subsys net_cls
<6>[    0.027300] Initializing cgroup subsys blkio
<6>[    0.027630] Initializing cgroup subsys perf_event
<6>[    0.027986] Initializing cgroup subsys hugetlb
<6>[    0.028347] CPU: Physical Processor ID: 0
<6>[    0.028662] CPU: Processor Core ID: 0
<6>[    0.028963] mce: CPU supports 9 MCE banks
<6>[    0.029287] CPU0: Thermal monitoring enabled (TM1)
<6>[    0.029655] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
<6>[    0.029655] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>[    0.030537] Freeing SMP alternatives memory: 36K (ffffffff81fbc000 - ffffffff81fc5000)
<6>[    0.032291] ftrace: allocating 31126 entries in 122 pages
<4>[    0.047952] Getting VERSION: 1060015
<4>[    0.048249] Getting VERSION: 1060015
<4>[    0.048539] Getting ID: 0
<4>[    0.048776] Getting ID: 0
<4>[    0.049020] masked ExtINT on CPU#0
<4>[    0.049611] ENABLING IO-APIC IRQs
<7>[    0.049888] init IO_APIC IRQs
<7>[    0.050144]  apic 1 pin 0 not connected
<7>[    0.050455] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.051031] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.051608] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.052188] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.052782] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.053360] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.053939] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.054514] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.055091] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.055669] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.056247] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.056837] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.057424] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.058010] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.058598] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.059187] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.059773]  apic 1 pin 16 not connected
<7>[    0.060083]  apic 1 pin 17 not connected
<7>[    0.060393]  apic 1 pin 18 not connected
<7>[    0.060705]  apic 1 pin 19 not connected
<7>[    0.061015]  apic 1 pin 20 not connected
<7>[    0.061325]  apic 1 pin 21 not connected
<7>[    0.061635]  apic 1 pin 22 not connected
<7>[    0.061945]  apic 1 pin 23 not connected
<6>[    0.062395] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.072830] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz (fam: 06, model: 25, stepping: 02)
<4>[    0.073669] Using local APIC timer interrupts.
<4>[    0.073669] calibrating APIC timer ...
<4>[    0.175605] ... lapic delta = 831240
<4>[    0.175896] ... PM-Timer delta = 357950
<4>[    0.176200] ... PM-Timer result ok
<4>[    0.176482] ..... delta 831240
<4>[    0.176743] ..... mult: 35701486
<4>[    0.177014] ..... calibration result: 132998
<4>[    0.177344] ..... CPU clock speed is 2393.0970 MHz.
<4>[    0.177708] ..... host bus clock speed is 132.0998 MHz.
<6>[    0.178128] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
<4>[    0.178943] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
<6>[    0.179423] ... version:                3
<6>[    0.179740] ... bit width:              48
<6>[    0.180061] ... generic registers:      4
<6>[    0.180378] ... value mask:             0000ffffffffffff
<6>[    0.180767] ... max period:             000000007fffffff
<6>[    0.181156] ... fixed-purpose events:   3
<6>[    0.181471] ... event mask:             000000070000000f
<6>[    0.183454] x86: Booting SMP configuration:
<6>[    0.183780] .... node  #0, CPUs:      #1
<4>[    0.195264] masked ExtINT on CPU#1
<6>[    0.197673] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.198367]  #2
<4>[    0.209525] masked ExtINT on CPU#2
<4>[    0.211973]  #3
<4>[    0.223137] masked ExtINT on CPU#3
<6>[    0.225479] x86: Booted up 1 node, 4 CPUs
<6>[    0.225795] smpboot: Total of 4 processors activated (19152.60 BogoMIPS)
<6>[    0.228747] devtmpfs: initialized
<6>[    0.232434] evm: security.selinux
<6>[    0.232710] evm: security.ima
<6>[    0.232967] evm: security.capability
<6>[    0.233422] PM: Registering ACPI NVS region [mem 0x77375000-0x773f5fff] (528384 bytes)
<6>[    0.234005] PM: Registering ACPI NVS region [mem 0x77668000-0x776e7fff] (524288 bytes)
<6>[    0.234591] PM: Registering ACPI NVS region [mem 0x7776c000-0x77777fff] (49152 bytes)
<6>[    0.235163] PM: Registering ACPI NVS region [mem 0x7777b000-0x7778afff] (65536 bytes)
<6>[    0.235733] PM: Registering ACPI NVS region [mem 0x7778c000-0x7779efff] (77824 bytes)
<6>[    0.237431] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    0.238009] NET: Registered protocol family 16
<6>[    0.238591] cpuidle: using governor menu
<6>[    0.239058] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>[    0.239616] ACPI: bus type PCI registered
<6>[    0.239933] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.240449] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>[    0.241104] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>[    0.242076] PCI: Using configuration type 1 for base access
<6>[    0.246023] ACPI: Added _OSI(Module Device)
<6>[    0.246354] ACPI: Added _OSI(Processor Device)
<6>[    0.246693] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.247048] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    0.249024] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
<6>[    0.249633] ACPI : EC: EC description table is found, configuring boot EC
<5>[    0.256128] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<4>[    0.332939] ACPI: Dynamic OEM Table Load:
<4>[    0.333362] ACPI: SSDT 0xFFFF880063AD8800 00046F (v01 PmRef  Cpu0Ist  00003000 INTL 20050513)
<4>[    0.334716] ACPI: Dynamic OEM Table Load:
<4>[    0.335138] ACPI: SSDT 0xFFFF880063AD9000 0006B2 (v01 PmRef  Cpu0Cst  00003001 INTL 20050513)
<4>[    0.340326] ACPI: Dynamic OEM Table Load:
<4>[    0.340752] ACPI: SSDT 0xFFFF880063A29400 000303 (v01 PmRef  ApIst    00003000 INTL 20050513)
<4>[    0.343835] ACPI: Dynamic OEM Table Load:
<4>[    0.344254] ACPI: SSDT 0xFFFF880063424000 000119 (v01 PmRef  ApCst    00003000 INTL 20050513)
<6>[    0.349115] ACPI: Interpreter enabled
<4>[    0.349417] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
<4>[    0.350172] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
<6>[    0.350937] ACPI: (supports S0 S3 S4 S5)
<6>[    0.351247] ACPI: Using IOAPIC for interrupt routing
<6>[    0.351646] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    0.358867] ACPI: Power Resource [PUBS] (on)
<6>[    0.359978] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
<6>[    0.362400] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
<6>[    0.365111] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.366370] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.367623] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.368881] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.370134] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.371390] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.372643] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.373897] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
<6>[    0.375139] ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
<6>[    0.375569] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.376168] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    0.376679] PCI host bridge to bus 0000:ff
<6>[    0.377004] pci_bus 0000:ff: root bus resource [bus ff]
<7>[    0.377393] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
<7>[    0.377871] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
<7>[    0.378347] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
<7>[    0.378816] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
<7>[    0.379284] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
<7>[    0.379756] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
<6>[    0.380257] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
<6>[    0.380700] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    0.382156] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
<6>[    0.382784] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
<6>[    0.383432] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
<6>[    0.384000] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
<6>[    0.384555] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
<6>[    0.385223] PCI host bridge to bus 0000:00
<6>[    0.385544] pci_bus 0000:00: root bus resource [bus 00-fe]
<6>[    0.385946] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    0.386385] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    0.386823] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    0.387297] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
<6>[    0.387774] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
<6>[    0.388251] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfebfffff]
<6>[    0.388728] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
<7>[    0.389211] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
<6>[    0.389653] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
<7>[    0.390271] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
<7>[    0.390712] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
<7>[    0.391189] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
<7>[    0.391731] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
<7>[    0.392250] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
<7>[    0.392709] pci 0000:00:16.0: reg 0x10: [mem 0xf2827800-0xf282780f 64bit]
<7>[    0.393271] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    0.393787] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
<7>[    0.394238] pci 0000:00:16.3: reg 0x10: [io  0x1808-0x180f]
<7>[    0.394650] pci 0000:00:16.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
<7>[    0.395262] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
<7>[    0.395716] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
<7>[    0.396167] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
<7>[    0.396619] pci 0000:00:19.0: reg 0x18: [io  0x1820-0x183f]
<7>[    0.397112] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>[    0.397590] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>[    0.398043] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
<7>[    0.398494] pci 0000:00:1a.0: reg 0x10: [mem 0xf2828000-0xf28283ff]
<7>[    0.399045] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>[    0.399523] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>[    0.399978] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
<7>[    0.400427] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
<7>[    0.401007] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>[    0.401496] pci 0000:00:1b.0: System wakeup disabled by ACPI
<7>[    0.401948] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
<7>[    0.402479] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    0.402961] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    0.403410] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
<7>[    0.403943] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<6>[    0.404423] pci 0000:00:1c.1: System wakeup disabled by ACPI
<7>[    0.404873] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
<7>[    0.405404] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
<6>[    0.405887] pci 0000:00:1c.3: System wakeup disabled by ACPI
<7>[    0.406335] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
<7>[    0.406870] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>[    0.407341] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>[    0.407796] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
<7>[    0.408247] pci 0000:00:1d.0: reg 0x10: [mem 0xf2828400-0xf28287ff]
<7>[    0.408796] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>[    0.409272] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    0.409721] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
<7>[    0.410284] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
<7>[    0.410891] pci 0000:00:1f.2: [8086:3b2f] type 00 class 0x010601
<7>[    0.411344] pci 0000:00:1f.2: reg 0x10: [io  0x1860-0x1867]
<7>[    0.411758] pci 0000:00:1f.2: reg 0x14: [io  0x1814-0x1817]
<7>[    0.412170] pci 0000:00:1f.2: reg 0x18: [io  0x1818-0x181f]
<7>[    0.412583] pci 0000:00:1f.2: reg 0x1c: [io  0x1810-0x1813]
<7>[    0.412998] pci 0000:00:1f.2: reg 0x20: [io  0x1840-0x185f]
<7>[    0.413410] pci 0000:00:1f.2: reg 0x24: [mem 0xf2827000-0xf28277ff]
<7>[    0.413917] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    0.414378] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
<7>[    0.414826] pci 0000:00:1f.3: reg 0x10: [mem 0xf2828800-0xf28288ff 64bit]
<7>[    0.415324] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
<7>[    0.415826] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
<7>[    0.416279] pci 0000:00:1f.6: reg 0x10: [mem 0xf2626000-0xf2626fff 64bit]
<6>[    0.416964] pci 0000:00:1c.0: PCI bridge to [bus 02]
<7>[    0.417438] pci 0000:03:00.0: [8086:4239] type 00 class 0x028000
<7>[    0.417909] pci 0000:03:00.0: reg 0x10: [mem 0xf2400000-0xf2401fff 64bit]
<7>[    0.418580] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
<6>[    0.420743] pci 0000:00:1c.1: PCI bridge to [bus 03]
<7>[    0.421121] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>[    0.421694] acpiphp: Slot [1] registered
<6>[    0.422013] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<7>[    0.422400] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<7>[    0.422836] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<7>[    0.423311] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<7>[    0.424015] pci 0000:0d:00.0: [1180:e822] type 00 class 0x080500
<5>[    0.424507] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
<7>[    0.425066] pci 0000:0d:00.0: reg 0x10: [mem 0xf2500000-0xf25000ff]
<7>[    0.425728] pci 0000:0d:00.0: supports D1 D2
<7>[    0.426057] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.426691] pci 0000:0d:00.1: [1180:e230] type 00 class 0x088000
<7>[    0.427191] pci 0000:0d:00.1: reg 0x10: [mem 0xf2500400-0xf25004ff]
<7>[    0.427846] pci 0000:0d:00.1: supports D1 D2
<7>[    0.428176] pci 0000:0d:00.1: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.428809] pci 0000:0d:00.3: [1180:e832] type 00 class 0x0c0010
<7>[    0.429307] pci 0000:0d:00.3: reg 0x10: [mem 0xf2500800-0xf2500fff]
<7>[    0.429961] pci 0000:0d:00.3: supports D1 D2
<7>[    0.430292] pci 0000:0d:00.3: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    0.432806] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<7>[    0.433189] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>[    0.433750] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive decode)
<7>[    0.434236] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    0.434816] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>[    0.435394] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    0.436009] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
<7>[    0.436626] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
<7>[    0.437243] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfebfffff] (subtractive decode)
<7>[    0.437860] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
<7>[    0.438703] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<4>[    0.440702] ACPI: Enabled 3 GPEs in block 00 to 3F
<6>[    0.441224] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
<6>[    0.441824] vgaarb: setting as boot device: PCI:0000:00:02.0
<6>[    0.442232] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    0.442820] vgaarb: loaded
<6>[    0.443062] vgaarb: bridge control possible 0000:00:02.0
<5>[    0.443537] SCSI subsystem initialized
<6>[    0.443871] ACPI: bus type USB registered
<6>[    0.444206] usbcore: registered new interface driver usbfs
<6>[    0.444616] usbcore: registered new interface driver hub
<6>[    0.445043] usbcore: registered new device driver usb
<6>[    0.445446] pps_core: LinuxPPS API ver. 1 registered
<6>[    0.445816] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    0.446468] PTP clock support registered
<6>[    0.446850] PCI: Using ACPI for IRQ routing
<7>[    0.456994] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.457530] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
<7>[    0.457958] e820: reserve RAM buffer [mem 0x7727c000-0x77ffffff]
<7>[    0.458387] e820: reserve RAM buffer [mem 0x77363000-0x77ffffff]
<7>[    0.458815] e820: reserve RAM buffer [mem 0x7746f000-0x77ffffff]
<7>[    0.459242] e820: reserve RAM buffer [mem 0x77717000-0x77ffffff]
<7>[    0.459672] e820: reserve RAM buffer [mem 0x7776c000-0x77ffffff]
<7>[    0.460101] e820: reserve RAM buffer [mem 0x77800000-0x77ffffff]
<6>[    0.460646] NetLabel: Initializing
<6>[    0.460928] NetLabel:  domain hash size = 128
<6>[    0.461265] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    0.461649] NetLabel:  unlabeled traffic allowed by default
<6>[    0.462210] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    0.463102] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    0.465560] Switched to clocksource hpet
<6>[    0.475558] pnp: PnP ACPI init
<6>[    0.477532] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
<6>[    0.478024] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
<6>[    0.478505] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
<6>[    0.478994] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
<6>[    0.479456] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
<6>[    0.479925] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
<6>[    0.480406] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
<6>[    0.480893] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
<6>[    0.481374] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
<6>[    0.481860] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
<6>[    0.482341] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
<6>[    0.482828] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
<6>[    0.483309] system 00:00: [mem 0x00100000-0x7bffffff] could not be reserved
<6>[    0.483798] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
<6>[    0.484279] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
<7>[    0.484769] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    0.485611] system 00:01: [io  0x164e-0x164f] has been reserved
<6>[    0.486036] system 00:01: [io  0x1000-0x107f] could not be reserved
<6>[    0.486479] system 00:01: [io  0x1180-0x11ff] has been reserved
<6>[    0.486911] system 00:01: [io  0x0800-0x080f] has been reserved
<6>[    0.487335] system 00:01: [io  0x15e0-0x15ef] has been reserved
<6>[    0.487766] system 00:01: [io  0x1600-0x1641] has been reserved
<6>[    0.488190] system 00:01: [io  0x1644-0x167f] could not be reserved
<6>[    0.488641] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
<6>[    0.489105] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    0.489566] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
<6>[    0.490619] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
<6>[    0.491081] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
<6>[    0.491542] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
<7>[    0.492011] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.492533] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    0.493140] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    0.493617] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
<7>[    0.494216] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
<7>[    0.494693] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:15)
<7>[    0.495300] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
<7>[    0.496191] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
<6>[    0.497512] pnp: PnP ACPI: found 6 devices
<6>[    0.504663] pci 0000:00:1c.0: PCI bridge to [bus 02]
<6>[    0.505046] pci 0000:00:1c.1: PCI bridge to [bus 03]
<6>[    0.505419] pci 0000:00:1c.1:   bridge window [mem 0xf2400000-0xf24fffff]
<6>[    0.505906] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
<6>[    0.506292] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
<6>[    0.506735] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
<6>[    0.507209] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
<6>[    0.507788] pci 0000:00:1c.4: PCI bridge to [bus 0d]
<6>[    0.508161] pci 0000:00:1c.4:   bridge window [mem 0xf2500000-0xf25fffff]
<6>[    0.508648] pci 0000:00:1e.0: PCI bridge to [bus 0e]
<7>[    0.509031] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    0.509436] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    0.509845] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.510288] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
<7>[    0.510737] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
<7>[    0.511180] pci_bus 0000:00: resource 9 [mem 0x7c000000-0xfebfffff]
<7>[    0.511627] pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed4bfff]
<7>[    0.512075] pci_bus 0000:03: resource 1 [mem 0xf2400000-0xf24fffff]
<7>[    0.512518] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
<7>[    0.512927] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
<7>[    0.513370] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
<7>[    0.513912] pci_bus 0000:0d: resource 1 [mem 0xf2500000-0xf25fffff]
<7>[    0.514355] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
<7>[    0.514765] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
<7>[    0.515169] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.515619] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
<7>[    0.516062] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
<7>[    0.516505] pci_bus 0000:0e: resource 9 [mem 0x7c000000-0xfebfffff]
<7>[    0.516952] pci_bus 0000:0e: resource 10 [mem 0xfed40000-0xfed4bfff]
<6>[    0.517427] NET: Registered protocol family 2
<6>[    0.517972] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.518568] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
<6>[    0.519114] TCP: Hash tables configured (established 16384 bind 16384)
<6>[    0.519608] TCP: reno registered
<6>[    0.519883] UDP hash table entries: 1024 (order: 3, 32768 bytes)
<6>[    0.520325] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
<6>[    0.520842] NET: Registered protocol family 1
<6>[    0.521278] RPC: Registered named UNIX socket transport module.
<6>[    0.521718] RPC: Registered udp transport module.
<6>[    0.522073] RPC: Registered tcp transport module.
<6>[    0.522427] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    0.522913] pci 0000:00:02.0: Video device with shadowed ROM
<7>[    0.523418] IOAPIC[0]: Set routing entry (1-23 -> 0x41 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>[    0.524163] IOAPIC[0]: Set routing entry (1-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:15)
<7>[    0.524907] PCI: CLS 64 bytes, default 64
<6>[    0.525275] Unpacking initramfs...
<6>[    4.875632] Freeing initrd memory: 264692K (ffff880066fff000 - ffff88007727c000)
<6>[    4.876380] Simple Boot Flag at 0x35 set to 0x1
<6>[    4.877623] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>[    4.878091] Initialise system trusted keyring
<6>[    4.878461] audit: initializing netlink subsys (disabled)
<5>[    4.878871] audit: type=2000 audit(1416196077.646:1): initialized
<6>[    4.879677] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    4.881661] zpool: loaded
<6>[    4.881901] zbud: loaded
<5>[    4.882309] VFS: Disk quotas dquot_6.5.2
<4>[    4.882662] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    4.883641] SGI XFS with ACLs, security attributes, no debug enabled
<6>[    4.884552] 9p: Installing v9fs 9p2000 file system support
<6>[    4.884982] msgmni has been set to 3718
<5>[    4.885358] Key type big_key registered
<7>[    4.885667] SELinux:  Registering netfilter hooks
<6>[    4.886913] NET: Registered protocol family 38
<5>[    4.887260] Key type asymmetric registered
<5>[    4.887591] Asymmetric key parser 'x509' registered
<6>[    4.887993] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    4.888624] io scheduler noop registered
<6>[    4.888943] io scheduler deadline registered (default)
<6>[    4.889337] io scheduler cfq registered
<7>[    4.889849] IOAPIC[0]: Set routing entry (1-20 -> 0x61 -> IRQ 20 Mode:1 Active:1 Dest:15)
<7>[    4.890571] IOAPIC[0]: Set routing entry (1-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:15)
<7>[    4.891273] IOAPIC[0]: Set routing entry (1-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
<6>[    4.892082] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    4.892510] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[    4.893017] intel_idle: MWAIT substates: 0x1120
<7>[    4.893370] intel_idle: v0.4 model 0x25
<7>[    4.893676] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[    4.894882] ACPI: AC Adapter [AC] (on-line)
<6>[    4.895337] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
<6>[    4.896769] ACPI: Lid Switch [LID]
<6>[    4.897147] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
<6>[    4.897798] ACPI: Sleep Button [SLPB]
<6>[    4.898189] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
<6>[    4.898747] ACPI: Power Button [PWRF]
<6>[    4.905710] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    4.906121] ACPI: Thermal Zone [THM0] (49 C)
<6>[    4.906582] GHES: HEST is not enabled!
<6>[    4.907108] ACPI: Battery Slot [BAT0] (battery absent)
<6>[    4.907226] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<7>[    4.908257] IOAPIC[0]: Set routing entry (1-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:15)
<6>[    4.909018] console [ttyS0] disabled
<6>[    4.929882] 0000:00:16.3: ttyS0 at I/O 0x1808 (irq = 17, base_baud = 115200) is a 16550A
<6>[    5.878999] tsc: Refined TSC clocksource calibration: 2394.000 MHz
<6>[    6.770574] console [ttyS0] enabled
<6>[    6.772863] Non-volatile memory driver v1.3
<6>[    6.774243] Linux agpgart interface v0.103
<6>[    6.776335] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
<6>[    6.778588] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
<6>[    6.782998] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
<6>[    6.785072] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
<6>[    6.789488] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
<6>[    6.827612] tpm_tis 00:05: TPM is disabled/deactivated (0x6)
<7>[    6.831311] IOAPIC[0]: Set routing entry (1-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[    6.833936] mei_me 0000:00:16.0: irq 24 for MSI/MSI-X
<4>[    6.838331] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20140724/utaddress-258)
<6>[    6.846124] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.851061] ACPI Warning: SystemIO range 0x00000000000011c0-0x00000000000011cf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140724/utaddress-258)
<6>[    6.858003] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.863085] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140724/utaddress-258)
<6>[    6.870080] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.875162] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20140724/utaddress-258)
<6>[    6.882916] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    6.887215] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[    6.889642] Switched to clocksource tsc
<6>[    6.889667] rdac: device handler registered
<6>[    6.889702] hp_sw: device handler registered
<6>[    6.889705] emc: device handler registered
<6>[    6.889709] alua: device handler registered
<6>[    6.889746] libphy: Fixed MDIO Bus: probed
<6>[    6.889788] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    6.889789] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[    6.889803] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    6.889803] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<6>[    6.889967] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>[    6.889996] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
<6>[    7.071860] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:2d:f4:57:98
<6>[    7.074937] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>[    7.078429] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
<6>[    7.081002] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
<6>[    7.084525] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>[    7.086930] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    7.090535] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[    7.092990] usbcore: registered new interface driver catc
<6>[    7.095142] usbcore: registered new interface driver kaweth
<6>[    7.098245] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[    7.101092] usbcore: registered new interface driver pegasus
<6>[    7.104179] usbcore: registered new interface driver rtl8150
<6>[    7.106574] usbcore: registered new interface driver asix
<6>[    7.108742] usbcore: registered new interface driver cdc_ether
<6>[    7.111205] usbcore: registered new interface driver cdc_eem
<6>[    7.114301] usbcore: registered new interface driver dm9601
<6>[    7.116827] usbcore: registered new interface driver smsc75xx
<6>[    7.119936] usbcore: registered new interface driver smsc95xx
<6>[    7.123154] usbcore: registered new interface driver gl620a
<6>[    7.125456] usbcore: registered new interface driver net1080
<6>[    7.128730] usbcore: registered new interface driver plusb
<6>[    7.131207] usbcore: registered new interface driver rndis_host
<6>[    7.134260] usbcore: registered new interface driver cdc_subset
<6>[    7.136725] usbcore: registered new interface driver zaurus
<6>[    7.138935] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[    7.142532] usbcore: registered new interface driver int51x1
<6>[    7.144789] usbcore: registered new interface driver ipheth
<6>[    7.147202] usbcore: registered new interface driver sierra_net
<6>[    7.150446] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    7.152908] ehci-pci: EHCI PCI platform driver
<6>[    7.155100] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>[    7.157258] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>[    7.160744] ehci-pci 0000:00:1a.0: debug port 2
<7>[    7.166684] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>[    7.170196] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf2828000
<6>[    7.177796] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>[    7.179873] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    7.183277] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    7.186133] usb usb1: Product: EHCI Host Controller
<6>[    7.188967] usb usb1: Manufacturer: Linux 3.17.0-dirty ehci_hcd
<6>[    7.191421] usb usb1: SerialNumber: 0000:00:1a.0
<6>[    7.193631] hub 1-0:1.0: USB hub found
<6>[    7.195242] hub 1-0:1.0: 3 ports detected
<7>[    7.197435] IOAPIC[0]: Set routing entry (1-19 -> 0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)
<6>[    7.200192] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>[    7.203256] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>[    7.205913] ehci-pci 0000:00:1d.0: debug port 2
<7>[    7.211877] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>[    7.215408] ehci-pci 0000:00:1d.0: irq 19, io mem 0xf2828400
<6>[    7.222824] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>[    7.225137] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    7.228496] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    7.232058] usb usb2: Product: EHCI Host Controller
<6>[    7.234165] usb usb2: Manufacturer: Linux 3.17.0-dirty ehci_hcd
<6>[    7.236628] usb usb2: SerialNumber: 0000:00:1d.0
<6>[    7.238794] hub 2-0:1.0: USB hub found
<6>[    7.240419] hub 2-0:1.0: 3 ports detected
<6>[    7.242528] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    7.244787] ohci-pci: OHCI PCI platform driver
<6>[    7.246810] uhci_hcd: USB Universal Host Controller Interface driver
<6>[    7.250186] usbcore: registered new interface driver usbserial
<6>[    7.252489] usbcore: registered new interface driver usbserial_generic
<6>[    7.255014] usbserial: USB Serial support registered for generic
<6>[    7.258302] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
<6>[    7.265008] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    7.267116] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    7.269558] mousedev: PS/2 mouse device common for all mice
<6>[    7.272138] rtc_cmos 00:02: RTC can wake from S4
<6>[    7.273970] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>[    7.276161] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>[    7.276634] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
<6>[    7.283734] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[    7.286154] iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
<6>[    7.289656] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    7.291889] iTCO_vendor_support: vendor-support=0
<6>[    7.294686] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    7.298238] usbcore: registered new interface driver usbhid
<6>[    7.300319] usbhid: USB HID core driver
<6>[    7.302187] drop_monitor: Initializing network drop monitor service
<6>[    7.304742] TCP: cubic registered
<6>[    7.306378] Initializing XFRM netlink socket
<6>[    7.308514] NET: Registered protocol family 10
<6>[    7.310698] NET: Registered protocol family 17
<6>[    7.312268] 9pnet: Installing 9P2000 support
<7>[    7.314938] 
<7>[    7.314938] printing PIC contents
<7>[    7.317345] ... PIC  IMR: ffff
<7>[    7.318946] ... PIC  IRR: 0800
<7>[    7.319859] ... PIC  ISR: 0000
<7>[    7.321461] ... PIC ELCR: 0800
<7>[    7.323065] printing local APIC contents on CPU#0/0:
<6>[    7.325119] ... APIC ID:      00000000 (0)
<6>[    7.327048] ... APIC VERSION: 01060015
<7>[    7.328087] ... APIC TASKPRI: 00000000 (00)
<7>[    7.329883] ... APIC PROCPRI: 00000000
<7>[    7.331804] ... APIC LDR: 01000000
<7>[    7.333459] ... APIC DFR: ffffffff
<7>[    7.335175] ... APIC SPIV: 000001ff
<7>[    7.336968] ... APIC ISR field:
<4>[    7.337857] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    7.341511] ... APIC TMR field:
<4>[    7.342974] 0000000002000000000200020002000200000002000000000002000000000000
<7>[    7.345845] ... APIC IRR field:
<4>[    7.347295] 0000000010000000000000000000000000000000000000000000000000000000
<7>[    7.350282] ... APIC ESR: 00000000
<7>[    7.351767] ... APIC ICR: 000008fd
<7>[    7.353410] ... APIC ICR2: 02000000
<7>[    7.355165] ... APIC LVTT: 000000ef
<7>[    7.356923] ... APIC LVTPC: 00000400
<7>[    7.357883] ... APIC LVT0: 00010700
<7>[    7.359559] ... APIC LVT1: 00000400
<7>[    7.361404] ... APIC LVTERR: 000000fe
<7>[    7.363146] ... APIC TMICT: 0079cbc4
<7>[    7.364916] ... APIC TMCCT: 00736895
<7>[    7.365972] ... APIC TDCR: 00000003
<4>[    7.367561] 
<7>[    7.368055] number of MP IRQ sources: 15.
<7>[    7.369875] number of IO-APIC #1 registers: 24.
<6>[    7.372029] testing the IO APIC.......................
<7>[    7.374991] IO APIC #1......
<7>[    7.375814] .... register #00: 02000000
<7>[    7.377521] .......    : physical APIC id: 02
<7>[    7.379503] .......    : Delivery Type: 0
<7>[    7.381451] .......    : LTS          : 0
<7>[    7.383268] .... register #01: 00170020
<7>[    7.385107] .......     : max redirection entries: 17
<7>[    7.387307] .......     : PRQ implemented: 0
<7>[    7.389208] .......     : IO APIC version: 20
<7>[    7.391248] .... IRQ redirection table:
<4>[    7.393043] 1    0    0   0   0    0    0    00
<4>[    7.395086] 0    0    0   0   0    1    1    31
<4>[    7.397068] 0    0    0   0   0    1    1    30
<4>[    7.399112] 0    0    0   0   0    1    1    33
<4>[    7.401177] 0    0    0   0   0    1    1    34
<4>[    7.403150] 0    0    0   0   0    1    1    35
<4>[    7.405138] 0    0    0   0   0    1    1    36
<4>[    7.407212] 0    0    0   0   0    1    1    37
<4>[    7.409235] 0    0    0   0   0    1    1    38
<4>[    7.411336] 0    1    0   0   0    1    1    39
<4>[    7.413240] 0    0    0   0   0    1    1    3A
<4>[    7.415328] 0    0    0   0   0    1    1    3B
<4>[    7.417288] 0    0    0   0   0    1    1    3C
<4>[    7.419331] 0    0    0   0   0    1    1    3D
<4>[    7.421426] 0    0    0   0   0    1    1    3E
<4>[    7.423343] 0    0    0   0   0    1    1    3F
<4>[    7.425400] 1    1    0   1   0    1    1    A1
<4>[    7.427393] 1    1    0   1   0    1    1    91
<4>[    7.429464] 1    0    0   0   0    0    0    00
<4>[    7.431513] 0    1    0   1   0    1    1    D1
<4>[    7.433467] 1    1    0   1   0    1    1    61
<4>[    7.435468] 1    1    0   1   0    1    1    71
<4>[    7.437496] 1    0    0   0   0    0    0    00
<4>[    7.439515] 0    1    0   1   0    1    1    81
<7>[    7.441618] IRQ to pin mappings:
<7>[    7.443226] IRQ0 -> 0:2
<7>[    7.444032] IRQ1 -> 0:1
<7>[    7.445493] IRQ3 -> 0:3
<7>[    7.446333] IRQ4 -> 0:4
<7>[    7.447532] IRQ5 -> 0:5
<7>[    7.448995] IRQ6 -> 0:6
<7>[    7.449806] IRQ7 -> 0:7
<7>[    7.451222] IRQ8 -> 0:8
<7>[    7.452040] IRQ9 -> 0:9
<7>[    7.453270] IRQ10 -> 0:10
<7>[    7.454164] IRQ11 -> 0:11
<7>[    7.455523] IRQ12 -> 0:12
<7>[    7.456962] IRQ13 -> 0:13
<7>[    7.457869] IRQ14 -> 0:14
<7>[    7.459211] IRQ15 -> 0:15
<7>[    7.460093] IRQ16 -> 0:16
<7>[    7.461493] IRQ17 -> 0:17
<7>[    7.462357] IRQ19 -> 0:19
<7>[    7.463598] IRQ20 -> 0:20
<7>[    7.465077] IRQ21 -> 0:21
<7>[    7.466050] IRQ23 -> 0:23
<6>[    7.467340] .................................... done.
<5>[    7.469980] Loading compiled-in X.509 certificates
<5>[    7.474664] Loaded X.509 cert 'Magrathea: Glacier signing key: d9d6b1769705ac0dbc53a286c5288e808793c1ae'
<6>[    7.478642] registered taskstats version 1
<5>[    7.484186] Key type trusted registered
<5>[    7.488066] Key type encrypted registered
<3>[    7.496953] tpm_tis 00:05: A TPM error (6) occurred attempting to read a pcr value
<6>[    7.498964] usb 1-1: new high-speed USB device number 2 using ehci-pci
<6>[    7.502425] ima: No TPM chip found, activating TPM-bypass!
<6>[    7.504756] evm: HMAC attrs: 0x1
<6>[    7.507440] rtc_cmos 00:02: setting system clock to 2014-11-17 03:48:00 UTC (1416196080)
<6>[    7.613650] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
<7>[    7.615284] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
<6>[    7.618785] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    7.621995] hub 1-1:1.0: USB hub found
<6>[    7.623396] hub 1-1:1.0: 6 ports detected
<7>[    7.716139] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
<6>[    7.718493] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[    7.728091] usb 2-1: new high-speed USB device number 2 using ehci-pci
<6>[    7.845784] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
<6>[    7.847822] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    7.851732] hub 2-1:1.0: USB hub found
<6>[    7.853187] hub 2-1:1.0: 8 ports detected
<6>[    7.919494] usb 1-1.3: new full-speed USB device number 3 using ehci-pci
<6>[    8.007753] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
<6>[    8.011184] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    8.013754] usb 1-1.3: Product: Biometric Coprocessor
<6>[    8.016085] usb 1-1.3: Manufacturer: UPEK
<6>[    8.091593] usb 1-1.6: new high-speed USB device number 4 using ehci-pci
<6>[    8.186353] usb 1-1.6: New USB device found, idVendor=17ef, idProduct=480f
<6>[    8.188788] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    8.192459] usb 1-1.6: Product: Integrated Camera
<6>[    8.194489] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
<6>[    8.265576] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 578367
<6>[    8.270879] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
<6>[    8.326573] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
<6>[   10.211138] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
<6>[   10.222707] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   10.233630] Sending DHCP requests .., OK
<4>[   13.105531] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.79
<6>[   13.119359] IP-Config: Complete:
<6>[   13.121388]      device=eth0, hwaddr=00:26:2d:f4:57:98, ipaddr=192.168.1.79, mask=255.255.255.0, gw=192.168.1.1
<6>[   13.127698]      host=lkp-t410, domain=lkp.intel.com, nis-domain=(none)
<6>[   13.131095]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   13.133723]      nameserver0=192.168.1.1
<7>[   13.135676] PM: Hibernation image not present or could not be loaded.
<6>[   13.140199] Freeing unused kernel memory: 1808K (ffffffff81df8000 - ffffffff81fbc000)
<6>[   13.328566] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
<6>[   13.339789] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
<6>[   13.348676] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
<6>[   13.353466] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<7>[   13.358588] libata version 3.00 loaded.
<6>[   13.376241] wmi: Mapper loaded
<7>[   13.397674] ahci 0000:00:1f.2: version 3.0
<7>[   13.399337] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
<6>[   13.404757] [drm] Initialized drm 1.1.0 20060810
<6>[   13.412684] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
<6>[   13.414817] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
<6>[   13.418694] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
<6>[   13.438980] sdhci: Secure Digital Host Controller Interface driver
<6>[   13.441979] sdhci: Copyright(c) Pierre Ossman
<6>[   13.442874] scsi host0: ahci
<6>[   13.445925] scsi host1: ahci
<6>[   13.447552] scsi host2: ahci
<6>[   13.449488] scsi host3: ahci
<6>[   13.450668] scsi host4: ahci
<6>[   13.453336] scsi host5: ahci
<6>[   13.454928] ata1: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827100 irq 26
<6>[   13.457598] ata2: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827180 irq 26
<6>[   13.461199] ata3: DUMMY
<6>[   13.462009] ata4: DUMMY
<6>[   13.463384] ata5: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827300 irq 26
<6>[   13.466898] ata6: SATA max UDMA/133 abar m2048@0xf2827000 port 0xf2827380 irq 26
<7>[   13.470103] snd_hda_intel 0000:00:1b.0: irq 27 for MSI/MSI-X
<6>[   13.481129] [drm] Memory usable by graphics device = 2048M
<6>[   13.483161] [drm] Replacing VGA console driver
<6>[   13.485578] Console: switching to colour dummy device 80x25
<6>[   13.490959] sound hdaudioC0D0: CX20585: BIOS auto-probing.
<6>[   13.493169] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
<6>[   13.496473] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<7>[   13.497844] i915 0000:00:02.0: irq 28 for MSI/MSI-X
<6>[   13.497862] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[   13.497863] [drm] Driver supports precise vblank timestamp query.
<6>[   13.498687] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<5>[   13.503326] firewire_ohci 0000:0d:00.3: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
<6>[   13.503390] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e822] (rev 1)
<4>[   13.503568] sdhci-pci 0000:0d:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
<6>[   13.503576] sdhci-pci 0000:0d:00.0: No vmmc regulator found
<6>[   13.503578] sdhci-pci 0000:0d:00.0: No vqmmc regulator found
<6>[   13.505326] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
<6>[   13.509367] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
<6>[   13.534828] sound hdaudioC0D0:    hp_outs=2 (0x1c/0x19/0x0/0x0/0x0)
<6>[   13.538098] sound hdaudioC0D0:    mono: mono_out=0x0
<6>[   13.540107] sound hdaudioC0D0:    inputs:
<6>[   13.541946] sound hdaudioC0D0:      Mic=0x1b
<6>[   13.543907] sound hdaudioC0D0:      Internal Mic=0x23
<6>[   13.546106] sound hdaudioC0D0:      Dock Mic=0x1a
<6>[   13.550488] sound hdaudioC0D0: Enable sync_write for stable communication
<6>[   13.559438] thinkpad_acpi: ThinkPad ACPI Extras v0.25
<6>[   13.561731] thinkpad_acpi: http://ibm-acpi.sf.net/
<6>[   13.563813] thinkpad_acpi: ThinkPad BIOS 6IET52WW (1.12 ), EC 6IHT30WW-1.04
<6>[   13.566478] thinkpad_acpi: Lenovo ThinkPad T410, model 25222AU
<6>[   13.570725] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
<6>[   13.573654] thinkpad_acpi: radio switch found; radios are disabled
<6>[   13.576860] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
<5>[   13.581187] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
<6>[   13.589763] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
<6>[   13.596459] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
<6>[   13.600988] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
<6>[   13.615254] Linux video capture interface: v2.00
<6>[   13.615409] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
<6>[   13.631601] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
<6>[   13.634998] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
<6>[   13.636761] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
<6>[   13.643895] input: HDA Intel MID Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
<6>[   13.647975] fbcon: inteldrmfb (fb0) is primary device
<6>[   13.648120] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>[   13.648312] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>[   13.648504] input: HDA Intel MID HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>[   13.648710] input: HDA Intel MID HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>[   13.657855] input: PC Speaker as /devices/platform/pcspkr/input/input15
<6>[   13.661124] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:480f)
<3>[   13.662374] Error: Driver 'pcspkr' is already registered, aborting...
<6>[   13.662429] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input16
<6>[   13.662551] usbcore: registered new interface driver uvcvideo
<6>[   13.662552] USB Video Class driver (1.1.1)
<6>[   13.801834] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input6
<6>[   13.931002] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<7>[   13.932756] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.932760] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>[   13.932971] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.932977] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>[   13.934754] ata1.00: ATA-8: FUJITSU MJA2250BH G2, 0084001C, max UDMA/100
<6>[   13.934757] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<7>[   13.936584] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.936588] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
<7>[   13.936823] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
<6>[   13.936827] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
<6>[   13.938678] ata1.00: configured for UDMA/100
<5>[   13.938957] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MJA2250B 001C PQ: 0 ANSI: 5
<5>[   14.003198] firewire_core 0000:0d:00.3: created device fw0: GUID 00262dfff45798ff, S400
<6>[   14.141210] Console: switching to colour frame buffer device 160x50
<6>[   14.238101] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[   14.242483] i915 0000:00:02.0: registered panic notifier
<6>[   14.263682] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
<6>[   14.277443] acpi device:01: registered as cooling_device4
<6>[   14.281624] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input17
<6>[   14.287777] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
<6>[   14.399304] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<7>[   14.411410] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>[   14.421937] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>[   14.428124] ata2.00: ATAPI: Optiarc DVD RW AD-7930H, 1.D0, max UDMA/100
<7>[   14.445831] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
<7>[   14.456321] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
<6>[   14.462483] ata2.00: configured for UDMA/100
<5>[   14.481823] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7930H  1.D0 PQ: 0 ANSI: 5
<6>[   14.813545] ata5: SATA link down (SStatus 0 SControl 300)
<6>[   15.122738] ata6: SATA link down (SStatus 0 SControl 300)
<5>[   15.153784] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
<5>[   15.159163] sd 0:0:0:0: [sda] Write Protect is off
<7>[   15.163138] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   15.167349] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[   15.179339] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
<6>[   15.185200] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>[   15.190725] sr 1:0:0:0: Attached scsi CD-ROM sr0
<5>[   15.200728] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[   15.204748] sr 1:0:0:0: Attached scsi generic sg1 type 5
<6>[   15.579961]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
<5>[   15.585608] sd 0:0:0:0: [sda] Attached SCSI disk
<5>[   15.735694] random: nonblocking pool is initialized
<4>[   16.598559] raid6: sse2x1    2878 MB/s
<4>[   16.621558] raid6: sse2x2    3335 MB/s
<4>[   16.644574] raid6: sse2x4    3742 MB/s
<4>[   16.650901] raid6: using algorithm sse2x4 (3742 MB/s)
<4>[   16.658464] raid6: using ssse3x2 recovery algorithm
<6>[   16.669531] xor: measuring software checksum speed
<6>[   16.686567]    prefetch64-sse:  4976.000 MB/sec
<6>[   16.703621]    generic_sse:  4388.000 MB/sec
<6>[   16.710126] xor: using function: prefetch64-sse (4976.000 MB/sec)
<6>[   16.755535] Btrfs loaded
<6>[   16.764414] BTRFS: device fsid 8886adc6-3306-411a-bbf8-6638ebb74746 devid 1 transid 57 /dev/sda6
<6>[   18.558946] intel ips 0000:00:1f.6: i915 driver attached, reenabling gpu turbo
<6>[   69.352751] Purging GPU memory, 0 bytes freed, 12288 bytes still pinned.
<4>[   69.363044] gem_userptr_bli invoked oom-killer: gfp_mask=0xa00d2, order=0, oom_score_adj=1000
<6>[   69.373682] gem_userptr_bli cpuset=/ mems_allowed=0
<4>[   69.380617] CPU: 1 PID: 3058 Comm: gem_userptr_bli Not tainted 3.17.0-dirty #1
<4>[   69.390574] Hardware name: LENOVO 25222AU/25222AU, BIOS 6IET52WW (1.12 ) 02/16/2010
<4>[   69.399759]  0000000000000000 ffff8800749d37d8 ffffffff81870560 ffff880074a00000
<4>[   69.409950]  ffff8800749d3840 ffffffff8186d528 ffff880000000015 0000000000000000
<4>[   69.419535]  00000000ffffffff ffff880076ffe0c0 0000000000000206 ffffffff81cf5440
<4>[   69.429544] Call Trace:
<4>[   69.435415]  [<ffffffff81870560>] dump_stack+0x4d/0x66
<4>[   69.442549]  [<ffffffff8186d528>] dump_header+0x9e/0x225
<4>[   69.448393]  [<ffffffff81163bed>] oom_kill_process+0x20d/0x380
<4>[   69.451840]  [<ffffffff81388a65>] ? security_capable_noaudit+0x15/0x20
<4>[   69.456166]  [<ffffffff81164419>] out_of_memory+0x4f9/0x540
<4>[   69.459434]  [<ffffffff8116ad58>] __alloc_pages_nodemask+0xab8/0xb00
<4>[   69.463816]  [<ffffffff811b130f>] alloc_pages_vma+0xaf/0x1c0
<4>[   69.467235]  [<ffffffff8117847f>] shmem_alloc_page+0x5f/0x90
<4>[   69.470444]  [<ffffffff81194cd9>] ? __vm_enough_memory+0x29/0x150
<4>[   69.474756]  [<ffffffff8117b490>] shmem_getpage_gfp+0x550/0x8e0
<4>[   69.478142]  [<ffffffff8117c371>] shmem_read_mapping_page_gfp+0x31/0x60
<4>[   69.481728]  [<ffffffffa01e830c>] i915_gem_object_get_pages_gtt+0x2dc/0x3b0 [i915]
<4>[   69.486341]  [<ffffffff811badec>] ? kmem_cache_alloc_trace+0x4c/0x210
<4>[   69.490795]  [<ffffffffa00d20da>] ? drm_vma_node_allow+0x2a/0xe0 [drm]
<4>[   69.494314]  [<ffffffffa01e3ca0>] i915_gem_object_get_pages+0x50/0xb0 [i915]
<4>[   69.498890]  [<ffffffffa01ea789>] i915_gem_pwrite_ioctl+0x369/0x800 [i915]
<4>[   69.503486]  [<ffffffffa01e5d28>] ? i915_gem_create+0x58/0xe0 [i915]
<4>[   69.508875]  [<ffffffffa00b9df7>] drm_ioctl+0x197/0x680 [drm]
<4>[   69.513217]  [<ffffffff810a0928>] ? __enqueue_entity+0x78/0x80
<4>[   69.517707]  [<ffffffff810a2745>] ? set_next_entity+0x95/0xb0
<4>[   69.521943]  [<ffffffff811ed620>] do_vfs_ioctl+0x2f0/0x4f0
<4>[   69.527080]  [<ffffffff8138e7c6>] ? file_has_perm+0x86/0xa0
<4>[   69.531373]  [<ffffffff811ed8a1>] SyS_ioctl+0x81/0xa0
<4>[   69.535560]  [<ffffffff81879229>] system_call_fastpath+0x16/0x1b
<4>[   69.539938] Mem-Info:
<4>[   69.543345] Node 0 DMA per-cpu:
<4>[   69.547209] CPU    0: hi:    0, btch:   1 usd:   0
<4>[   69.551168] CPU    1: hi:    0, btch:   1 usd:   0
<4>[   69.555242] CPU    2: hi:    0, btch:   1 usd:   0
<4>[   69.558361] CPU    3: hi:    0, btch:   1 usd:   0
<4>[   69.561450] Node 0 DMA32 per-cpu:
<4>[   69.565175] CPU    0: hi:  186, btch:  31 usd:   0
<4>[   69.569246] CPU    1: hi:  186, btch:  31 usd:   0
<4>[   69.573341] CPU    2: hi:  186, btch:  31 usd:  30
<4>[   69.577495] CPU    3: hi:  186, btch:  31 usd:   0
<4>[   69.581585] active_anon:8656 inactive_anon:221642 isolated_anon:0
<4>[   69.581585]  active_file:86 inactive_file:102 isolated_file:0
<4>[   69.581585]  unevictable:207659 dirty:0 writeback:0 unstable:0
<4>[   69.581585]  free:13457 slab_reclaimable:12623 slab_unreclaimable:5040
<4>[   69.581585]  mapped:4233 shmem:222239 pagetables:463 bounce:0
<4>[   69.581585]  free_cma:0
<4>[   69.606919] Node 0 DMA free:7420kB min:376kB low:468kB high:564kB active_anon:0kB inactive_anon:0kB active_file:40kB inactive_file:60kB unevictable:7896kB isolated(anon):0kB isolated(file):0kB present:15988kB managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:248kB shmem:0kB slab_reclaimable:332kB slab_unreclaimable:88kB kernel_stack:16kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:7928 all_unreclaimable? yes
<4>[   69.631117] lowmem_reserve[]: 0 1843 1843 1843
<4>[   69.635370] Node 0 DMA32 free:46408kB min:44676kB low:55844kB high:67012kB active_anon:34624kB inactive_anon:886568kB active_file:304kB inactive_file:348kB unevictable:822740kB isolated(anon):0kB isolated(file):0kB present:1937484kB managed:1889660kB mlocked:0kB dirty:0kB writeback:0kB mapped:16684kB shmem:888956kB slab_reclaimable:50160kB slab_unreclaimable:20072kB kernel_stack:2176kB pagetables:1852kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
<4>[   69.664106] lowmem_reserve[]: 0 0 0 0
<4>[   69.668321] Node 0 DMA: 1*4kB (E) 1*8kB (U) 1*16kB (E) 1*32kB (E) 1*64kB (U) 1*128kB (E) 0*256kB 2*512kB (UE) 2*1024kB (UE) 2*2048kB (ER) 0*4096kB = 7420kB
<4>[   69.676506] Node 0 DMA32: 221*4kB (UEM) 143*8kB (UEM) 118*16kB (UEM) 71*32kB (UEM) 82*64kB (UEM) 34*128kB (EM) 20*256kB (EM) 16*512kB (EM) 11*1024kB (M) 1*2048kB (R) 1*4096kB (R) = 46508kB
<6>[   69.688492] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
<4>[   69.694756] 430095 total pagecache pages
<4>[   69.698583] 0 pages in swap cache
<4>[   69.702387] Swap cache stats: add 0, delete 0, find 0/0
<4>[   69.706545] Free swap  = 0kB
<4>[   69.709921] Total swap = 0kB
<4>[   69.713900] 488368 pages RAM
<4>[   69.717567] 0 pages HighMem/MovableOnly
<4>[   69.721344] 11956 pages reserved
<4>[   69.724752] 0 pages hwpoisoned
<6>[   69.728810] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
<6>[   69.734561] [  206]     0   206     6070      702      17        0         -1000 udevd
<6>[   69.740339] [  545]     0   545     6069      607      16        0         -1000 udevd
<6>[   69.745246] [  546]     0   546     6029      571      16        0         -1000 udevd
<6>[   69.750991] [ 1353]     0  1353     1079      392       7        0             0 rc
<6>[   69.756714] [ 1435]   101  1435     7078       59      18        0             0 dbus-daemon
<6>[   69.762687] [ 1457]     0  1457     3176      286      11        0             0 mcelog
<6>[   69.768390] [ 1468]     0  1468    13781      721      28        0         -1000 sshd
<6>[   69.773320] [ 1494]     0  1494     2374      670      10        0             0 S77lkp-bootstra
<6>[   69.779231] [ 1508]     0  1508     2381      677      10        0             0 lkp-setup-rootf
<6>[   69.785249] [ 1515]     0  1515     1065      177       8        0             0 tail-to-console
<6>[   69.791226] [ 1516]     0  1516     1065      197       7        0             0 tail-to-output
<6>[   69.797205] [ 1517]     0  1517     1065      196       8        0             0 tail-to-serial
<6>[   69.803350] [ 1544]     0  1544     2397      658      10        0             0 run-lkp
<6>[   69.809001] [ 1567]     0  1567     1833      178       8        0             0 cat
<6>[   69.814695] [ 1571]     0  1571    15464     3213      34        0             0 run-job
<6>[   69.820523] [ 1624]     0  1624     1018       20       7        0             0 wakeup
<6>[   69.825459] [ 1654]     0  1654     2874      646      11        0             0 watch-oom
<6>[   69.831295] [ 1658]     0  1658     1095      165       8        0             0 cat-watch-oom
<6>[   69.837257] [ 1665]     0  1665     2634      191      11        0             0 vmstat
<6>[   69.843144] [ 1666]     0  1666     8092     2112      19        0             0 ruby
<6>[   69.848812] [ 1670]     0  1670     1319      174       8        0             0 cat-vmstat
<6>[   69.854683] [ 1680]     0  1680     2872      582      10        0             0 watchdog
<6>[   69.859632] [ 1683]     0  1683     1095      194       8        0             0 cat-watchdog
<6>[   69.865538] [ 1684]     0  1684     6026     1403      16        0             0 bmc-watchdog
<6>[   69.871522] [ 1687]     0  1687     1052      160       8        0          1000 time
<6>[   69.877220] [ 1688]     0  1688     2370      671      10        0             0 piglit
<6>[   69.883082] [ 1692]     0  1692     1056      298       7        0             0 tee-piglit
<6>[   69.888908] [ 1694]     0  1694     2373      663      10        0             0 piglit.xinitrc
<6>[   69.894871] [ 2972]     0  2972   208008     4052      46        0             0 python2
<6>[   69.900687] [ 3058]     0  3058   376089     1450      54        0          1000 gem_userptr_bli
<6>[   69.906674] [ 3062]     0  3062     1570      172       9        0             0 sleep
<3>[   69.911597] Out of memory: Kill process 3058 (gem_userptr_bli) score 1002 or sacrifice child
<3>[   69.917436] Killed process 3058 (gem_userptr_bli) total-vm:1504356kB, anon-rss:1532kB, file-rss:4268kB

--uCPdOCrL+PnN2Vxy--
