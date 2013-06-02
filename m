Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3FBXnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:43:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:43477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3FBXnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,790,1363158000"; 
   d="log'?scan'208";a="343799712"
Date: Mon, 3 Jun 2013 07:43:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [lock_fb_info/console_callback] INFO: possible circular locking
 dependency detected
Message-ID: <20130602234320.GA8621@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 5845b81bdad374f98f809a658ec747d92c9595c4
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Feb 8 12:07:01 2013 +1000

    Revert "Revert "console: implement lockdep support for console_lock""
    
    This reverts commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf.
    
    Now that we have all the locking fixes in place, we can revert the
    revert. This re-enables lockdep tracking for the console lock,
    daee779718a319ff9f83e1ba3339334ac650bb22.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

[  602.016208]
[  602.016216] ======================================================
[  602.016217] [ INFO: possible circular locking dependency detected ]
[  602.016243] 3.10.0-rc3-00001-g71919ba #14 Not tainted
[  602.016249] -------------------------------------------------------
[  602.016253] kworker/0:1/17 is trying to acquire lock:
[  602.016347]  (&fb_info->lock){+.+.+.}, at: [<c19a7e98>] lock_fb_info+0x28/0x80
[  602.016348]
[  602.016348] but task is already holding lock:
[  602.016366]  (console_lock){+.+.+.}, at: [<c1b379e7>] console_callback+0x17/0x220
[  602.016367]
[  602.016367] which lock already depends on the new lock.
[  602.016367]

git bisect start v3.9 v3.8 --
git bisect good d778df51c09264076fe0208c099ef7d428f21790  #    10  2013-06-02 16:52:49  mm: vmscan: save work scanning (almost) empty LRU lists
git bisect  bad ee89f81252179dcbf6cd65bd48299f5e52292d88  #     4  2013-06-02 17:09:49  Merge branch 'for-3.9/core' of git://git.kernel.dk/linux-block
git bisect good 69086a78bdc973ec0b722be790b146e84ba8a8c4  #    12  2013-06-02 17:38:46  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect  bad ed5dc2372dba46e0ecd08791b1a0399d313e5cff  #     3  2013-06-02 17:56:21  Merge tag 'mmc-updates-for-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc
git bisect  bad 1f3a574a4bfe86ebf7d51fac37e0668397372fd8  #     5  2013-06-02 18:14:52  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
git bisect good cd17ef4114ad5c514b17e6a0bb02a309ab90b692  #    15  2013-06-02 18:35:52  Merge tag 'drm-intel-next-2013-02-01' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
git bisect  bad 210561ffd72d00eccf12c0131b8024d5436bae95  #     9  2013-06-02 18:52:00  intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
git bisect  bad 73ccd6962fff19e53a7d4baaa17cf9311284ac9c  #     2  2013-06-02 19:09:41  Merge branch 'drm-next-3.9' of git://people.freedesktop.org/~agd5f/linux into drm-next
git bisect good 43f1214aa094e46efdfc0255d9601be0e5ea0f62  #    27  2013-06-02 19:39:54  drm/radeon: use IBs for VM page table updates v2
git bisect  bad bb0f78dd7ded88082b2430c43c65bc821c4ea360  #     6  2013-06-02 19:55:44  Merge branch 'udl-fixes' into drm-next
git bisect  bad 6dc1c49da6dd3bf020a66b2a135b9625ac01c2c7  #     4  2013-06-02 20:11:28  Merge branch 'fbcon-locking-fixes' of ssh://people.freedesktop.org/~airlied/linux into drm-next
git bisect good 50e244cc793d511b86adea24972f3a7264cae114  #    27  2013-06-02 20:32:17  fb: rework locking to fix lock ordering on takeover
git bisect good 054430e773c9a1e26f38e30156eff02dedfffc17  #    27  2013-06-02 21:00:32  fbcon: fix locking harder
git bisect  bad 5845b81bdad374f98f809a658ec747d92c9595c4  #     0  2013-06-02 21:16:17  Revert "Revert "console: implement lockdep support for console_lock""
git bisect good 054430e773c9a1e26f38e30156eff02dedfffc17  #    81  2013-06-02 21:48:21  fbcon: fix locking harder
git bisect  bad 71919bac2803fc6834e178dd5935e7013fd78826  #     0  2013-06-02 21:48:56  cpufreq: spear needs cpufreq table
git bisect good 7c3628da24b83741fe940c29bf9525a7d09b9b9e  #    81  2013-06-03 01:15:38  Revert "Revert "Revert "console: implement lockdep support for console_lock"""
git bisect  bad 14d35d014bd806884801d32259ecdaf857ef276b  #     2  2013-06-03 01:39:14  Add linux-next specific files for 20130531

Thanks,
Fengguang

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-7545-2013-06-02-12-24-35-3.10.0-rc3-00001-g71919ba-14"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00001-g71919ba (kbuild@xian) (gcc version 4.7.2 (Debian 4.7.2-4) ) #14 Sat Jun 1 19:33:15 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x05bfffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x05690000, 0x05690fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128356(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] BRK [0x05691000, 0x05691fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat c4428880, node_mem_map cdd3f020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64912
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=vireshk/cpufreq-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-x05-0601/vireshk:cpufreq-next/.vmlinuz-2013-06-01-19-47-50-vireshk:cpufreq-next:71919bac2803fc6834e178dd5935e7013fd78826-71919bac2803fc6834e178dd5935e7013fd78826-i386-randconfig-x05-0601-5-bens  BOOT_IMAGE=/kernel/i386-randconfig-x05-0601/71919bac2803fc6834e178dd5935e7013fd78826/vmlinuz-3.10.0-rc3-00001-g71919ba
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 153572k/262136k available (36667k kernel code, 108124k reserved, 16976k data, 1360k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc4468000 - 0xc45bc000   (1360 kB)
[    0.000000]       .data : 0xc33ced22 - 0xc4462d80   (16976 kB)
[    0.000000]       .text : 0xc1000000 - 0xc33ced22   (36667 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=cd806000 soft=cd808000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2666.880 MHz processor
[    0.003012] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.76 BogoMIPS (lpj=2666880)
[    0.004910] pid_max: default: 32768 minimum: 301
[    0.005225] Security Framework initialized
[    0.006062] Yama: becoming mindful.
[    0.008089] Mount-cache hash table entries: 512
[    0.010908] Initializing cgroup subsys debug
[    0.011045] Initializing cgroup subsys devices
[    0.012050] Initializing cgroup subsys net_cls
[    0.013038] Initializing cgroup subsys net_prio
[    0.014265] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014265] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014265] tlb_flushall_shift: 6
[    0.015012] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.021230] ACPI: Core revision 20130328
[    0.027033] ACPI: All ACPI Tables successfully acquired
[    0.028455] ACPI: setting ELCR to 0200 (from 0c00)
[    0.030110] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.032780] ftrace: Allocated trace_printk buffers
[    0.036426] Testing tracer nop: PASSED
[    0.046568] EVM: security.ima
[    0.047013] EVM: security.capability
[    0.054193] Testing tracer wakeup: ret = 0
[    0.157226] ftrace-test (8) used greatest stack depth: 7080 bytes left
[    0.159636] PASSED
[    0.161203] Testing tracer wakeup_rt: ret = 0
[    0.263554] PASSED
[    0.264000] xor: measuring software checksum speed
[    0.273021]    pIII_sse  :  7864.000 MB/sec
[    0.284021]    prefetch64-sse:  8828.000 MB/sec
[    0.285017] xor: using function: prefetch64-sse (8828.000 MB/sec)
[    0.287193] regulator-dummy: no parameters
[    0.288303] RTC time:  4:14:28, date: 06/02/13
[    0.289498] NET: Registered protocol family 16
[    0.293211] i2c-core: driver [dummy] registered
[    0.296868] ACPI: bus type PCI registered
[    0.297500] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.298021] PCI: Using configuration type 1 for base access
[    0.345938] bio: create slab <bio-0> at 0
[    0.364112] raid6: mmxx1      468 MB/s
[    0.382036] raid6: mmxx2      511 MB/s
[    0.400089] raid6: sse1x1     367 MB/s
[    0.418058] raid6: sse1x2     425 MB/s
[    0.436094] raid6: sse2x1     734 MB/s
[    0.454041] raid6: sse2x2     894 MB/s
[    0.455016] raid6: using algorithm sse2x2 (894 MB/s)
[    0.456014] raid6: using intx1 recovery algorithm
[    0.457149] i2c-core: driver [max732x] registered
[    0.459049] i2c-core: driver [mcp230xx] registered
[    0.460041] i2c-core: driver [pca953x] registered
[    0.461041] i2c-core: driver [pcf857x] registered
[    0.462044] i2c-core: driver [sx150x] registered
[    0.463315] ACPI: Added _OSI(Module Device)
[    0.464014] ACPI: Added _OSI(Processor Device)
[    0.465020] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.467025] ACPI: Added _OSI(Processor Aggregator Device)
[    0.472817] ACPI: EC: Look up EC in DSDT
[    0.483883] ACPI: Interpreter enabled
[    0.484040] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.487026] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.490101] ACPI: (supports S0 S3 S5)
[    0.491012] ACPI: Using PIC for interrupt routing
[    0.493107] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.517307] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.518174] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.519028] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.520013] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.521014] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.522030] PCI: root bus 00: using default resources
[    0.523070] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.524304] PCI host bridge to bus 0000:00
[    0.525030] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.526016] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.527014] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.528036] pci_bus 0000:00: scanning bus
[    0.529155] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.530090] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x20
[    0.532587] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.534247] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.538017] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.541698] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.542079] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x80
[    0.543668] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x200
[    0.544042] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.545035] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.546132] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x20
[    0.548011] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.551509] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.554054] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.562483] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.564401] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.565858] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.566712] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.571696] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.573223] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.575410] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.576728] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.581000] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.581518] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.582847] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.583789] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.588607] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.589878] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.591374] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.596268] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.598710] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.599708] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.605155] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.607421] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.608717] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.614100] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.616367] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.617718] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.623050] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.625427] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.626719] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.632061] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.634194] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.639269] pci_bus 0000:00: fixups for bus
[    0.640015] pci_bus 0000:00: bus scan returning with max=00
[    0.641018] pci_bus 0000:00: on NUMA node 0
[    0.642030] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.646347] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.649125] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.652140] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.654822] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.657371] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.661000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.661033] acpi root: \_SB_.PCI0 notify handler is installed
[    0.662251] Found 1 acpi root devices
[    0.666450] ACPI: No dock devices found.
[    0.668157] i2c-core: driver [ad5398] registered
[    0.669000] i2c-core: driver [isl6271a] registered
[    0.669059] i2c-core: driver [max1586] registered
[    0.670071] i2c-core: driver [max8649] registered
[    0.671037] i2c-core: driver [max8660] registered
[    0.672100] i2c-core: driver [max8952] registered
[    0.673038] i2c-core: driver [max8973] registered
[    0.674136] i2c-core: driver [tps51632] registered
[    0.675090] i2c-core: driver [tps65023] registered
[    0.676438] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.678022] vgaarb: loaded
[    0.679009] vgaarb: bridge control possible 0000:00:02.0
[    0.681428] i2c-core: driver [88PM860x] registered
[    0.682044] i2c-core: driver [88PM80X] registered
[    0.683049] i2c-core: driver [tc3589x] registered
[    0.684012] tps65010: version 2 May 2005
[    0.685035] i2c-core: driver [tps65010] registered
[    0.686223] i2c-core: driver [tps65010] unregistered
[    0.698091] i2c-core: driver [tps65010] registered
[    0.699048] i2c-core: driver [tps65010] unregistered
[    0.711081] i2c-core: driver [tps65010] registered
[    0.712049] i2c-core: driver [tps65010] unregistered
[    0.713009] tps65010: no chip?
[    0.714043] i2c-core: driver [tps6507x] registered
[    0.715047] i2c-core: driver [tps65217] registered
[    0.716036] i2c-core: driver [tps65912] registered
[    0.717063] i2c-core: driver [twl] registered
[    0.718048] i2c-core: driver [mc13xxx] registered
[    0.719091] i2c-core: driver [max77693] registered
[    0.720041] i2c-core: driver [max8907] registered
[    0.721042] i2c-core: driver [max8925] registered
[    0.722061] i2c-core: driver [max8997] registered
[    0.723044] i2c-core: driver [pcf50633] registered
[    0.724045] i2c-core: driver [ab3100] registered
[    0.725045] i2c-core: driver [tps6586x] registered
[    0.726053] i2c-core: driver [palmas] registered
[    0.727060] i2c-core: driver [lm3533] registered
[    0.728042] i2c-core: driver [as3711] registered
[    0.729513] SCSI subsystem initialized
[    0.731012] ACPI: bus type ATA registered
[    0.732303] libata version 3.00 loaded.
[    0.734233] ACPI: bus type USB registered
[    0.735140] usbcore: registered new interface driver usbfs
[    0.736069] usbcore: registered new interface driver hub
[    0.737132] usbcore: registered new device driver usb
[    0.738281] i2c-core: driver [tca6416-keypad] registered
[    0.739120] media: Linux media interface: v0.10
[    0.740058] Linux video capture interface: v2.00
[    0.741092] pps_core: LinuxPPS API ver. 1 registered
[    0.742010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.743060] PTP clock support registered
[    0.744434] wmi: Mapper loaded
[    0.745313] Advanced Linux Sound Architecture Driver Initialized.
[    0.746072] PCI: Using ACPI for IRQ routing
[    0.747021] PCI: pci_cache_line_size set to 64 bytes
[    0.748098] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.749023] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.750014] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.751013] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.752028] pci 0000:00:01.1: BAR 4: reserving [io  0xc1e0-0xc1ef flags 0x40101] (d=0, p=0)
[    0.754012] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.755014] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebe0000-0xfebe0fff flags 0x40200] (d=0, p=0)
[    0.756056] pci 0000:00:03.0: BAR 0: reserving [io  0xc1c0-0xc1df flags 0x40101] (d=0, p=0)
[    0.757015] pci 0000:00:03.0: BAR 1: reserving [mem 0xfebe1000-0xfebe1fff flags 0x40200] (d=0, p=0)
[    0.758030] pci 0000:00:04.0: BAR 0: reserving [mem 0xfeb80000-0xfeb9ffff flags 0x40200] (d=0, p=0)
[    0.759032] pci 0000:00:04.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    0.760036] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    0.761014] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebe2000-0xfebe2fff flags 0x40200] (d=0, p=0)
[    0.762046] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    0.763014] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebe3000-0xfebe3fff flags 0x40200] (d=0, p=0)
[    0.764042] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    0.765014] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebe4000-0xfebe4fff flags 0x40200] (d=0, p=0)
[    0.766030] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    0.767032] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebe5000-0xfebe5fff flags 0x40200] (d=0, p=0)
[    0.768037] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    0.769014] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebe6000-0xfebe6fff flags 0x40200] (d=0, p=0)
[    0.770048] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    0.771014] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebe7000-0xfebe7fff flags 0x40200] (d=0, p=0)
[    0.772031] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebe8000-0xfebe800f flags 0x40200] (d=0, p=0)
[    0.774125] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.775044] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.777633] NET: Registered protocol family 23
[    0.781636] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.783855] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.786068] Switching to clocksource hpet
[    1.006762] pnp: PnP ACPI init
[    1.007956] ACPI: bus type PNP registered
[    1.009466] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.020763] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.022696] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.024526] pnp 00:03: [dma 2]
[    1.032881] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.034931] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.036904] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.039528] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.041756] pnp: PnP ACPI: found 7 devices
[    1.044631] ACPI: bus type PNP unregistered
[    1.096258] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.106149] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    1.108081] NET: Registered protocol family 2
[    1.110319] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    1.112247] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    1.122659] TCP: Hash tables configured (established 2048 bind 2048)
[    1.124531] TCP: reno registered
[    1.125675] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    1.127391] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    1.135911] NET: Registered protocol family 1
[    1.137394] pci 0000:00:00.0: calling quirk_natoma+0x0/0x60
[    1.138968] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.140592] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xf0
[    1.142318] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.153261] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x60
[    1.154977] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.156732] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x160
[    1.158371] pci 0000:00:02.0: Boot video device
[    1.166049] pci 0000:00:04.0: calling quirk_e100_interrupt+0x0/0x2a0
[    1.167909] PCI: CLS 0 bytes, default 64
[    1.169730] Trying to unpack rootfs image as initramfs...
[    4.172347] Freeing initrd memory: 25284k freed
[    4.203440] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    4.205575] apm: overridden by ACPI.
[    4.207645] cryptomgr_test (19) used greatest stack depth: 7052 bytes left
[    4.215155] cryptomgr_probe (28) used greatest stack depth: 6928 bytes left
[    4.218356] cryptomgr_test (27) used greatest stack depth: 6248 bytes left
[    4.220742] PCLMULQDQ-NI instructions are not detected.
[    4.222574] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    4.225173] NatSemi SCx200 Driver
[    4.228254] Initializing RT-Tester: OK
[    4.231053] audit: initializing netlink socket (disabled)
[    4.232910] type=2000 audit(1370146472.232:1): initialized
[    4.253295] VFS: Disk quotas dquot_6.5.2
[    4.254781] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.259434] DLM installed
[    4.262719] fuse init (API version 7.22)
[    4.265653] JFS: nTxBlock = 1397, nTxLock = 11178
[    4.269641] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    4.273555] OCFS2 1.5.0
[    4.274998] ocfs2: Registered cluster interface user
[    4.276495] OCFS2 DLMFS 1.5.0
[    4.277849] OCFS2 User DLM kernel interface loaded
[    4.279298] OCFS2 Node Manager 1.5.0
[    4.281966] bio: create slab <bio-1> at 1
[    4.284327] Running btrfs free space cache tests
[    4.285813] Running extent only tests
[    4.287200] Running bitmap only tests
[    4.288443] Running bitmap and extent tests
[    4.289837] Free space cache tests finished
[    4.291152] Btrfs loaded
[    4.293555] GFS2 installed
[    4.294638] msgmni has been set to 349
[    4.307146] alg: No test for crc32 (crc32-table)
[    4.308927] alg: No test for stdrng (krng)
[    4.332506] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    4.334500] NET: Registered protocol family 38
[    4.335976] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    4.338400] io scheduler noop registered
[    4.339667] io scheduler deadline registered (default)
[    4.344226] list_sort_test: start testing list_sort()
[    4.346383] test_string_helpers: Running tests...
[    4.348015] xz_dec_test: module loaded
[    4.349432] xz_dec_test: Create a device node with 'mknod xz_dec_test c 248 0' and write .xz files to it.
[    4.352415] i2c-core: driver [adp5588-gpio] registered
[    4.354606] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.356327] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    4.358888] i2c-core: driver [adp8860_bl] registered
[    4.360576] i2c-core: driver [lm3639_bl] registered
[    4.362491] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.364942] vmlfb: initializing
[    4.366138] Could not find Carillo Ranch MCH device.
[    4.367749] no IO addresses supplied
[    4.370364] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
[    4.373417] fbcon: CL Picasso4 (fb0) is primary device
[    4.832275] Console: switching to colour frame buffer device 80x30
[    4.975988] usbcore: registered new interface driver udlfb
[    4.983873] ipmi message handler version 39.2
[    4.989399] ipmi device interface
[    4.994774] IPMI System Interface driver.
[    5.182580] ipmi_si: Adding default-specified kcs state machine
[    5.376213] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    5.961822] ipmi_si: Interface detection failed
[    6.338679] tsc: Refined TSC clocksource calibration: 2666.662 MHz
[    6.703687] Switching to clocksource tsc
[    6.990136] ipmi_si: Adding default-specified smic state machine
[    7.179806] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    7.563563] ipmi_si: Interface detection failed
[    7.758297] ipmi_si: Adding default-specified bt state machine
[    7.961859] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    8.361690] ipmi_si: Interface detection failed
[    8.577788] ipmi_si: Unable to find any System Interface(s)
[    8.772568] IPMI Watchdog: driver initialized
[    8.977647] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    9.462814] i2c-core: driver [fan53555-regulator] registered
[    9.669038] i2c-core: driver [LP3971] registered
[   10.072077] i2c-core: driver [lp872x] registered
[   10.472486] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   10.896463] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.262983] Initializing Nozomi driver 2.1d
[   11.631649] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   11.995672] toshiba: not a supported Toshiba laptop
[   12.387783] scx200_gpio: no SCx200 gpio present
[   12.756618] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[   13.141682] platform pc8736x_gpio.0: no device found
[   13.581985] nsc_gpio initializing
[   13.952839] telclk_interrupt = 0xf non-mcpbl0010 hw.
[   14.313668] Linux agpgart interface v0.103
[   14.497406] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   15.094213] Hangcheck: Using getrawmonotonic().
[   15.330708] [drm] Initialized drm 1.1.0 20060810
[   15.563511] [drm] radeon kernel modesetting enabled.
[   15.983905] usbcore: registered new interface driver udl
[   16.293820] i2c-core: driver [ch7006] registered
[   16.476437] i2c-core: driver [tda998x] registered
[   16.661784] brd: module loaded
[   16.870415] Compaq SMART2 Driver (v 2.6.0)
[   17.209800] HP CISS Driver (v 3.6.26)
[   17.556583] nbd: registered device at major 43
[   17.870497] events: mcg drbd: 5
[   18.055400] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[   18.222849] drbd: built-in
[   18.502851] drbd: registered as block device major 147
[   18.835403] mtip32xx Version 1.2.6os3
[   19.176503] i2c-core: driver [bmp085] registered
[   19.513917] dummy-irq: no IRQ given.  Use irq=N
[   19.859199] i2c-core: driver [ics932s401] registered
[   20.187728] lkdtm: No crash points registered, enable through debugfs
[   20.520911] Phantom Linux Driver, version n0.9.8, init OK
[   20.848707] i2c-core: driver [bh1780] registered
[   21.178247] i2c-core: driver [bh1770glc] registered
[   21.501124] i2c-core: driver [apds9802als] registered
[   21.819700] i2c-core: driver [ds1682] registered
[   22.133913] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[   22.773755] c2port c2port0: C2 port uc added
[   23.099551] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[   23.773647] i2c-core: driver [hmc6352] registered
[   24.110444] i2c-core: driver [at24] registered
[   24.458837] i2c-core: driver [eeprom] registered
[   24.807710] i2c-core: driver [lis3lv02d_i2c] registered
[   25.139734] i2c-core: driver [fsa9480] registered
[   25.480994] i2c-core: driver [htcpld-chip] registered
[   25.810672] i2c-core: driver [smsc] registered
[   26.140736] Driver for timberdale has been successfully registered.
[   26.475092] i2c-core: driver [adp5520] registered
[   26.823574] i2c-core: driver [si476x-core] registered
[   27.167618] usbcore: registered new interface driver viperboard
[   27.511565] i2c-core: driver [retu-mfd] registered
[   27.856106] Uniform Multi-Platform E-IDE driver
[   28.195141] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   28.535363] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[   28.882923] pci 0000:00:01.1: enabling bus mastering
[   29.223612] pci 0000:00:01.1: setting latency timer to 64
[   29.573443]     ide0: BM-DMA at 0xc1e0-0xc1e7
[   29.928507]     ide1: BM-DMA at 0xc1e8-0xc1ef
[   30.282870] Probing IDE interface ide0...
[   31.160074] Probing IDE interface ide1...
[   32.174497] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   33.126165] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   33.475825] hdc: MWDMA2 mode selected
[   33.827959] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   34.196672] ide1 at 0x170-0x177,0x376 on irq 15
[   34.537999] ide-cd driver 5.00
[   34.870544] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[   35.216981] cdrom: Uniform CD-ROM driver Revision: 3.20
[   35.532983] Loading iSCSI transport class v2.0-870.
[   35.854489] CPA self-test:
[   36.163912]  4k 2046 large 62 gb 0 x 2108[c0000000-cfffd000] miss 0
[   36.541519]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   36.933052]  4k 65534 large 0 gb 0 x 65534[c0000000-cfffd000] miss 0
[   37.267673] ok.
[   37.612862] hp_sw: device handler registered
[   37.967320] alua: device handler registered
[   38.304242] iscsi: registered transport (tcp)
[   38.640281] Adaptec aacraid driver 1.2-0[30200]-ms
[   38.987495] scsi: <fdomain> Detection failed (no card)
[   39.327608] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.05.00.03-k.
[   40.024232] iscsi: registered transport (qla4xxx)
[   40.368868] QLogic iSCSI HBA Driver
[   40.713611] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
[   41.063839] csiostor: Chelsio FCoE driver 1.0.0
[   41.409641] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   41.748575] PCI: setting IRQ 10 as level-triggered
[   42.111940] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   42.467696] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   42.812075] PCI: setting IRQ 11 as level-triggered
[   43.174618] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   43.547994] megasas: 06.506.00.00-rc1 Sat. Feb. 9 17:00:00 PDT 2013
[   43.906193] 3ware Storage Controller device driver for Linux v1.26.02.003.
[   44.263649] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
[   44.970012] RocketRAID 3xxx/4xxx Controller driver v1.8
[   45.356488] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   45.781616] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[   46.164885] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
[   46.354580] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   46.631711] iscsi: registered transport (cxgb3i)
[   47.038203] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
[   47.442709] iscsi: registered transport (bnx2i)
[   47.841238] VMware PVSCSI driver - version 1.0.2.0-k
[   48.247784] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   48.668321] osst :I: Tape driver with OnStream support version 0.99.4
[   48.668321] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   49.417646] SCSI Media Changer driver v0.25 
[   49.756382] osd: LOADED open-osd 0.2.1
[   50.117475] scsi_debug: host protection
[   50.498431] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[   51.098803] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[   51.515631] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB)
[   52.181062] Rounding down aligned max_sectors from 4294967295 to 4294967288
[   52.515779] device id = 2440
[   52.737483] device id = 2480
[   52.950570] device id = 24c0
[   53.162214] device id = 24d0
[   53.378124] device id = 25a1
[   53.633048] device id = 2670
[   54.038165] platform physmap-flash.0: failed to claim resource 0
[   54.429995] Failed to ioremap_nocache
[   54.837100] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[   55.053920] slram: not enough parameters.
[   55.255808] ftl_cs: FTL header not found.
[   55.541553] i2c-core: driver [spi-xcomm] registered
[   55.832469] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[   56.037840] sd 0:0:0:0: [sda] Write Protect is off
[   56.228722] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[   56.413414] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   56.916041] spi_ks8995: Micrel KS8995 Ethernet switch SPI driver version 0.1.1
[   57.660457] tun: Universal TUN/TAP device driver, 1.6
[   58.059843] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   58.457176] arcnet loaded.
[   58.754384] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[   59.120598] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[   59.925962] arcnet: raw mode (`r') encapsulation support loaded.
[   60.320171] arcnet: cap mode (`c') encapsulation support loaded.
[   60.710265] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   61.451274] E-mail me if you actually test this driver, please!
[   61.832237]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   62.633882] arcnet: RIM I (entirely mem-mapped) support
[   63.049675] E-mail me if you actually test the RIM I driver, please!
[   63.591101] Given: node 00h, shmem 0h, irq 0
[   63.904117] No autoprobe for RIM I; you must specify the shmem and irq!
[   64.136888] arcnet: COM20020 PCI support
[   64.368226] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   64.607389] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[   65.116983] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.17-0 (2013/04/11)
[   66.187738] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   67.167870] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.39
[   67.664612] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   68.154897] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   68.652293] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   69.133760] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.2.42
[   69.601553] QLogic/NetXen Network Driver v4.0.80
[   70.094436] tlan: ThunderLAN driver v1.17
[   70.572428] tlan: 0 devices installed, PCI: 0  EISA: 0
[   71.037496] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   71.506090] AX.25: 6pack driver, Revision: 0.3.0
[   71.958331] YAM driver version 0.8 by F1OAT/F6FBB
[   72.417831] AX.25: bpqether driver version 004
[   72.863956] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   72.863956] baycom_ser_fdx: version 0.10
[   73.774227] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   74.225863] hdlcdrv: version 0.8
[   74.716691] usbcore: registered new interface driver irda-usb
[   75.174412] usbcore: registered new interface driver stir4200
[   75.519782] usbcore: registered new interface driver kingsun-sir
[   75.907622] usbcore: registered new interface driver ksdazzle-sir
[   76.286012] PPP generic driver version 2.4.2
[   76.676579] PPP Deflate Compression module registered
[   77.035594] PPP MPPE Compression module registered
[   77.394677] NET: Registered protocol family 24
[   77.762737] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
[   78.458521] SLIP linefill/keepalive option.
[   78.807866] usbcore: registered new interface driver i2400m_usb
[   79.156620] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMAC hardware
[   79.841615] usbcore: registered new interface driver catc
[   80.183223] usbcore: registered new interface driver kaweth
[   80.522342] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   81.179368] usbcore: registered new interface driver pegasus
[   81.519992] usbcore: registered new interface driver rtl8150
[   81.852827] usbcore: registered new interface driver r8152
[   82.178335] usbcore: registered new interface driver cdc_phonet
[   82.495351] usbcore: registered new interface driver ipheth
[   82.817844] I2O subsystem v1.325
[   83.137650] i2o: max drivers = 8
[   83.576608] I2O Bus Adapter OSM v1.317
[   83.905482] I2O SCSI Peripheral OSM v1.316
[   84.224885] I2O ProcFS OSM v1.316
[   84.539908] Fusion MPT base driver 3.04.20
[   84.839190] Copyright (c) 1999-2008 LSI Corporation
[   85.153676] Fusion MPT FC Host driver 3.04.20
[   85.464448] Fusion MPT SAS Host driver 3.04.20
[   85.781223] Fusion MPT misc device (ioctl) driver 3.04.20
[   86.084831] mptctl: Registered with Fusion MPT base driver
[   86.384472] mptctl: /dev/mptctl @ (major,minor=10,220)
[   86.693191] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[   86.993979] usbcore: registered new interface driver hwa-rc
[   87.304856] usbcore: registered new interface driver i1480-dfu-usb
[   87.613696] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   87.900322] ohci_hcd: block sizes: ed 64 td 64
[   88.202552] uhci_hcd: USB Universal Host Controller Interface driver
[   88.500435] driver u132_hcd
[   88.862170]  sda: unknown partition table
[   89.196157] sd 0:0:0:0: [sda] Attached SCSI disk
[   89.495903] usbcore: registered new interface driver hwa-hc
[   89.811427] usbcore: registered new interface driver cdc_acm
[   90.086229] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   90.666635] usbcore: registered new interface driver usblp
[   90.956917] usbcore: registered new interface driver cdc_wdm
[   91.259632] usbcore: registered new interface driver usb-storage
[   91.560882] usbcore: registered new interface driver ums-alauda
[   91.855761] usbcore: registered new interface driver ums-cypress
[   92.154644] usbcore: registered new interface driver ums_eneub6250
[   92.445648] usbcore: registered new interface driver ums-freecom
[   92.724697] usbcore: registered new interface driver ums-isd200
[   93.017779] usbcore: registered new interface driver ums-jumpshot
[   93.296471] usbcore: registered new interface driver ums-onetouch
[   93.580753] usbcore: registered new interface driver mdc800
[   93.849497] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   94.405198] usbcore: registered new interface driver microtekX6
[   94.704559] usbcore: registered new interface driver cypress_cy7c63
[   95.003156] usbcore: registered new interface driver cytherm
[   95.299845] usbcore: registered new interface driver emi26 - firmware loader
[   95.587754] driver ftdi-elan
[   95.903771] usbcore: registered new interface driver ftdi-elan
[   96.210932] usbcore: registered new interface driver idmouse
[   96.525269] usbcore: registered new interface driver iowarrior
[   96.831672] usbcore: registered new interface driver usblcd
[   97.109720] usbcore: registered new interface driver ldusb
[   97.404536] usbcore: registered new interface driver usbled
[   97.679591] usbcore: registered new interface driver rio500
[   97.952262] usbcore: registered new interface driver usbtest
[   98.216782] usbcore: registered new interface driver trancevibrator
[   98.480463] usbcore: registered new interface driver yurex
[   98.740388] i2c-core: driver [isp1301] registered
[   98.975617] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   99.458485] serio: i8042 KBD port at 0x60,0x64 irq 1
[   99.721755] serio: i8042 AUX port at 0x60,0x64 irq 12
[  100.147638] mousedev: PS/2 mouse device common for all mice
[  100.426817] i2c-core: driver [adp5588_keys] registered
[  100.696615] i2c-core: driver [adp5589_keys] registered
[  100.957514] i2c-core: driver [lm8323] registered
[  101.227866] i2c-core: driver [lm8333] registered
[  101.515396] i2c-core: driver [mcs_touchkey] registered
[  101.789521] i2c-core: driver [mpr121] registered
[  102.078475] i2c-core: driver [qt1070] registered
[  102.346462] i2c-core: driver [qt2160] registered
[  102.600332] usbcore: registered new interface driver xpad
[  102.863408] i2c-core: driver [atmel_mxt_ts] registered
[  103.117853] i2c-core: driver [bu21013_tp] registered
[  103.373611] i2c-core: driver [edt_ft5x06] registered
[  103.651456] i2c-core: driver [eeti_ts] registered
[  103.890995] i2c-core: driver [ili210x_i2c] registered
[  104.133388] i2c-core: driver [max11801_ts] registered
[  104.371300] i2c-core: driver [mcs5000_ts] registered
[  104.609750] i2c-core: driver [mms114] registered
[  104.860363] mk712: device not present
[  105.107540] usbcore: registered new interface driver usbtouchscreen
[  105.358699] i2c-core: driver [tsc2007] registered
[  105.630596] i2c-core: driver [bq32k] registered
[  105.895234] rtc_cmos 00:00: RTC can wake from S4
[  106.165178] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[  106.351060] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[  106.619065] hpet1: lost 16 rtc interrupts
[  106.926135] i2c-core: driver [rtc-ds1374] registered
[  107.203331] i2c-core: driver [rtc-ds1672] registered
[  107.335381] i2c-core: driver [rtc-ds3232] registered
[  107.494360] i2c-core: driver [rtc-em3027] registered
[  107.761242] i2c-core: driver [rtc-fm3130] registered
[  108.125296] i2c-core: driver [rtc-max6900] registered
[  108.480769] i2c-core: driver [rtc-pcf8563] registered
[  108.745871] i2c-core: driver [pcf8583] registered
[  108.896141] i2c-core: driver [rtc-rs5c372] registered
[  109.079695] i2c-core: driver [rtc-rx8025] registered
[  109.307055] rtc-test rtc-test.0: rtc core: registered test as rtc1
[  109.442205] rtc-test rtc-test.1: rtc core: registered test as rtc2
[  109.736886] i2c-core: driver [rtc-x1205] registered
[  110.003859] piix4_smbus 0000:00:01.3: Using Interrupt 9 for SMBus.
[  110.268744] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[  110.826775] i2c i2c-0: adapter [SMBus PIIX4 adapter at b100] registered
[  111.133946] i2c i2c-0: found normal entry for adapter 0, addr 0x69
[  111.426905] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=d2, DAT0=00, DAT1=00
[  112.066209] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[  112.756653] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=d2, DAT0=00, DAT1=00
[  113.466731] i2c i2c-0: Transaction (pre): CNT=0c, CMD=07, ADD=d3, DAT0=00, DAT1=00
[  114.312825] i2c i2c-0: Transaction (post): CNT=0c, CMD=07, ADD=d3, DAT0=ff, DAT1=ff
[  115.099619] i2c i2c-0: found normal entry for adapter 0, addr 0x50
[  115.503924] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=a1, DAT0=ff, DAT1=ff
[  116.314386] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=a1, DAT0=00, DAT1=ff
[  117.090733] i2c i2c-0: Creating eeprom at 0x50
[  117.389529] i2c 0-0050: uevent
[  117.638768] eeprom 0-0050: probe
[  118.089379] i2c i2c-0: client [eeprom] registered with bus id 0-0050
[  118.448728] i2c i2c-0: found normal entry for adapter 0, addr 0x51
[  118.686167] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=a3, DAT0=00, DAT1=ff
[  119.163350] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=a3, DAT0=00, DAT1=ff
[  119.660738] i2c i2c-0: Creating eeprom at 0x51
[  119.993354] i2c 0-0051: uevent
[  120.241739] eeprom 0-0051: probe
[  120.483277] i2c i2c-0: client [eeprom] registered with bus id 0-0051
[  120.858630] i2c i2c-0: found normal entry for adapter 0, addr 0x52
[  121.339991] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=a5, DAT0=00, DAT1=ff
[  122.113255] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=a5, DAT0=00, DAT1=ff
[  123.005972] i2c i2c-0: Creating eeprom at 0x52
[  123.313888] i2c 0-0052: uevent
[  123.788588] eeprom 0-0052: probe
[  124.227816] i2c i2c-0: client [eeprom] registered with bus id 0-0052
[  124.457775] i2c i2c-0: found normal entry for adapter 0, addr 0x53
[  124.716429] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=a7, DAT0=00, DAT1=ff
[  125.577209] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=a7, DAT0=00, DAT1=ff
[  126.454548] i2c i2c-0: Creating eeprom at 0x53
[  126.881837] i2c 0-0053: uevent
[  127.309860] eeprom 0-0053: probe
[  127.734380] i2c i2c-0: client [eeprom] registered with bus id 0-0053
[  128.150584] i2c i2c-0: found normal entry for adapter 0, addr 0x54
[  128.574592] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=a9, DAT0=00, DAT1=ff
[  129.532631] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=a9, DAT0=00, DAT1=ff
[  130.247472] i2c i2c-0: Creating eeprom at 0x54
[  130.708809] i2c 0-0054: uevent
[  131.156707] eeprom 0-0054: probe
[  131.599677] i2c i2c-0: client [eeprom] registered with bus id 0-0054
[  132.116902] i2c i2c-0: found normal entry for adapter 0, addr 0x55
[  132.562618] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=ab, DAT0=00, DAT1=ff
[  133.170828] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=ab, DAT0=00, DAT1=ff
[  134.045637] i2c i2c-0: Creating eeprom at 0x55
[  134.721895] i2c 0-0055: uevent
[  135.411038] eeprom 0-0055: probe
[  136.078869] i2c i2c-0: client [eeprom] registered with bus id 0-0055
[  136.764547] i2c i2c-0: found normal entry for adapter 0, addr 0x56
[  137.443675] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=ad, DAT0=00, DAT1=ff
[  138.534484] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=ad, DAT0=00, DAT1=ff
[  139.512281] i2c i2c-0: Creating eeprom at 0x56
[  139.970960] i2c 0-0056: uevent
[  140.224258] eeprom 0-0056: probe
[  140.470608] i2c i2c-0: client [eeprom] registered with bus id 0-0056
[  140.722451] i2c i2c-0: found normal entry for adapter 0, addr 0x57
[  141.054767] i2c i2c-0: Transaction (pre): CNT=04, CMD=07, ADD=af, DAT0=00, DAT1=ff
[  141.874782] i2c i2c-0: Transaction (post): CNT=04, CMD=07, ADD=af, DAT0=00, DAT1=ff
[  142.444922] i2c i2c-0: Creating eeprom at 0x57
[  142.819691] i2c 0-0057: uevent
[  143.272078] eeprom 0-0057: probe
[  143.701778] i2c i2c-0: Transaction (pre): CNT=08, CMD=80, ADD=af, DAT0=00, DAT1=ff
[  144.170835] i2c i2c-0: Transaction (post): CNT=08, CMD=80, ADD=af, DAT0=00, DAT1=ff
[  144.655889] i2c i2c-0: Transaction (pre): CNT=08, CMD=81, ADD=af, DAT0=00, DAT1=ff
[  145.417262] i2c i2c-0: Transaction (post): CNT=08, CMD=81, ADD=af, DAT0=00, DAT1=ff
[  145.936629] i2c i2c-0: Transaction (pre): CNT=08, CMD=82, ADD=af, DAT0=00, DAT1=ff
[  146.987345] i2c i2c-0: Transaction (post): CNT=08, CMD=82, ADD=af, DAT0=00, DAT1=ff
[  147.967970] i2c i2c-0: Transaction (pre): CNT=08, CMD=83, ADD=af, DAT0=00, DAT1=ff
[  149.002833] i2c i2c-0: Transaction (post): CNT=08, CMD=83, ADD=af, DAT0=00, DAT1=ff
[  150.027888] i2c i2c-0: client [eeprom] registered with bus id 0-0057
[  150.539493] usbcore: registered new interface driver i2c-diolan-u2c
[  150.935022] scx200_i2c: NatSemi SCx200 I2C Driver
[  151.230773] scx200_i2c: no SCx200 gpio pins available
[  151.518311] i2c-core: driver [msp3400] registered
[  151.782664] i2c-core: driver [cx25840] registered
[  152.034446] i2c-core: driver [tda7432] registered
[  152.292973] i2c-core: driver [saa6588] registered
[  152.533982] i2c-core: driver [tea6420] registered
[  152.772303] i2c-core: driver [saa7110] registered
[  153.008709] i2c-core: driver [saa7127] registered
[  153.233803] i2c-core: driver [saa7185] registered
[  153.483745] i2c-core: driver [saa7191] registered
[  153.918274] i2c-core: driver [adv7183] registered
[  154.338856] i2c-core: driver [adv7343] registered
[  154.749625] i2c-core: driver [vpx3220] registered
[  155.144918] i2c-core: driver [vs6624] registered
[  155.576872] i2c-core: driver [bt856] registered
[  155.937725] i2c-core: driver [tvp5150] registered
[  156.273918] i2c-core: driver [tvp514x] registered
[  156.626000] i2c-core: driver [tvp7002] registered
[  156.947394] i2c-core: driver [tw2804] registered
[  157.242970] i2c-core: driver [tw9903] registered
[  157.544956] i2c-core: driver [tw9906] registered
[  157.813903] i2c-core: driver [cs5345] registered
[  158.090278] i2c-core: driver [cs53l32a] registered
[  158.340150] i2c-core: driver [m52790] registered
[  158.525808] i2c-core: driver [uda1342] registered
[  158.639497] i2c-core: driver [wm8775] registered
[  158.835497] i2c-core: driver [wm8739] registered
[  159.033862] i2c-core: driver [vp27smpx] registered
[  159.235844] i2c-core: driver [sony-btf-mpx] registered
[  159.431905] i2c-core: driver [ov7640] registered
[  159.617003] i2c-core: driver [ov7670] registered
[  159.807712] i2c-core: driver [mt9v011] registered
[  160.004723] i2c-core: driver [SR030PC30] registered
[  160.194978] i2c-core: driver [adp1653] registered
[  160.398965] i2c-core: driver [as3645a] registered
[  160.600570] i2c-core: driver [ak881x] registered
[  160.793983] i2c-core: driver [au8522] registered
[  160.989942] smssdio: Siano SMS1xxx SDIO driver
[  161.186289] smssdio: Copyright Pierre Ossman
[  161.401135] pps_core: source ktimer got cdev (253:0)
[  161.602732] pps pps0: new PPS source ktimer
[  161.828447] pps pps0: ktimer PPS source registered
[  162.047260] Driver for 1-wire Dallas network protocol.
[  162.263154] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[  162.745248] i2c-core: driver [ds2782-battery] registered
[  163.000701] pps pps0: PPS event at 1370146631.000622136
[  163.243717] pps pps0: capture assert seq #1
[  163.471916] i2c-core: driver [bq27x00-battery] registered
[  163.603532] i2c-core: driver [max17042] registered
[  163.817379] i2c-core: driver [bq2415x-charger] registered
[  164.090780] i2c-core: driver [smb347] registered
[  164.327763] i2c-core: driver [w83792d] registered
[  164.471632] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  164.711828] pps pps0: PPS event at 1370146632.711724645
[  165.014073] pps pps0: capture assert seq #2
[  165.245992] i2c i2c-0: Transaction (pre): CNT=00, CMD=83, ADD=58, DAT0=00, DAT1=ff
[  165.555716] i2c i2c-0: Transaction (post): CNT=00, CMD=83, ADD=58, DAT0=00, DAT1=ff
[  165.977833] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=00, DAT1=ff
[  166.452700] pps pps0: PPS event at 1370146634.452586835
[  166.840611] pps pps0: capture assert seq #3
[  167.208475] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[  167.964872] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  168.372321] pps pps0: PPS event at 1370146636.365093170
[  168.777928] pps pps0: capture assert seq #4
[  169.188323] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[  170.029352] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[  170.880139] pps pps0: PPS event at 1370146638.880025986
[  171.311262] pps pps0: capture assert seq #5
[  171.527684] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[  172.304599] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[  172.958421] pps pps0: PPS event at 1370146640.958300551
[  173.331322] pps pps0: capture assert seq #6
[  173.824672] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  174.326823] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[  175.326622] pps pps0: PPS event at 1370146643.326511162
[  175.894546] pps pps0: capture assert seq #7
[  176.478744] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[  177.451634] pps pps0: PPS event at 1370146645.451524477
[  178.140047] pps pps0: capture assert seq #8
[  178.826351] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[  179.810177] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[  180.379613] pps pps0: PPS event at 1370146648.379494208
[  180.773541] pps pps0: capture assert seq #9
[  181.226761] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[  181.690220] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=ff
[  182.609207] pps pps0: PPS event at 1370146650.609037668
[  182.945009] pps pps0: capture assert seq #10
[  183.175259] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=ff
[  183.767786] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=ff
[  184.686828] pps pps0: PPS event at 1370146652.686723626
[  185.148027] pps pps0: capture assert seq #11
[  185.609320] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=ff
[  186.298448] i2c-core: driver [w83793] registered
[  186.904221] pps pps0: PPS event at 1370146654.903996509
[  187.349547] pps pps0: capture assert seq #12
[  187.799532] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  188.234561] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=ff
[  188.936671] pps pps0: PPS event at 1370146656.931139204
[  189.385249] pps pps0: capture assert seq #13
[  189.858489] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=ff
[  190.741721] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=ff
[  191.651342] pps pps0: PPS event at 1370146659.651236228
[  191.986636] pps pps0: capture assert seq #14
[  192.241401] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=ff
[  192.692462] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=59, DAT0=ff, DAT1=ff
[  193.488852] pps pps0: PPS event at 1370146661.488746086
[  193.963322] pps pps0: capture assert seq #15
[  194.337379] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=59, DAT0=ff, DAT1=ff
[  194.881834] w83793: Detection failed at check vendor id
[  195.270271] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  195.720725] pps pps0: PPS event at 1370146663.720628485
[  196.151702] pps pps0: capture assert seq #16
[  196.591229] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=5a, DAT0=ff, DAT1=ff
[  197.466697] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=5a, DAT0=ff, DAT1=ff
[  198.360343] pps pps0: PPS event at 1370146666.360227641
[  198.660612] pps pps0: capture assert seq #17
[  199.058589] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=ff
[  199.686368] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=ff
[  200.647943] pps pps0: PPS event at 1370146668.647838282
[  201.182777] pps pps0: capture assert seq #18
[  201.808003] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5b, DAT0=ff, DAT1=ff
[  202.434968] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5b, DAT0=ff, DAT1=ff
[  202.918357] pps pps0: PPS event at 1370146670.918235964
[  203.405520] pps pps0: capture assert seq #19
[  203.903295] w83793: Detection failed at check vendor id
[  204.377201] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  204.844604] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=5c, DAT0=ff, DAT1=ff
[  205.559918] pps pps0: PPS event at 1370146673.559810722
[  205.802732] pps pps0: capture assert seq #20
[  206.114257] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=5c, DAT0=ff, DAT1=ff
[  206.997294] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5d, DAT0=ff, DAT1=ff
[  207.886497] pps pps0: PPS event at 1370146675.886386946
[  208.163620] pps pps0: capture assert seq #21
[  208.471337] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5d, DAT0=ff, DAT1=ff
[  208.955568] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5d, DAT0=ff, DAT1=ff
[  209.443384] pps pps0: PPS event at 1370146677.443268990
[  209.687618] pps pps0: capture assert seq #22
[  209.929282] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5d, DAT0=ff, DAT1=ff
[  210.701964] w83793: Detection failed at check vendor id
[  211.178933] pps pps0: PPS event at 1370146679.178830939
[  211.619274] pps pps0: capture assert seq #23
[  211.982964] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[  212.461796] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=5e, DAT0=ff, DAT1=ff
[  213.369297] pps pps0: PPS event at 1370146681.369063311
[  213.588466] pps pps0: capture assert seq #24
[  213.866355] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=5e, DAT0=ff, DAT1=ff
[  214.774891] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5f, DAT0=ff, DAT1=ff
[  215.681452] pps pps0: PPS event at 1370146683.681341369
[  216.127360] pps pps0: capture assert seq #25
[  216.448344] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5f, DAT0=ff, DAT1=ff
[  216.895694] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5f, DAT0=ff, DAT1=ff
[  217.359273] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5f, DAT0=ff, DAT1=ff
[  217.866846] pps pps0: PPS event at 1370146685.866735786
[  218.101192] pps pps0: capture assert seq #26
[  218.330924] w83793: Detection failed at check vendor id
[  218.560657] i2c-core: driver [w83795] registered
[  218.781634] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  219.071044] i2c i2c-0: Transaction (pre): CNT=00, CMD=0d, ADD=58, DAT0=ff, DAT1=ff
[  219.973969] pps pps0: PPS event at 1370146687.973861041
[  220.319374] pps pps0: capture assert seq #27
[  220.665687] i2c i2c-0: Transaction (post): CNT=00, CMD=0d, ADD=58, DAT0=ff, DAT1=ff
[  221.306859] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=ff
[  222.262094] pps pps0: PPS event at 1370146690.261940291
[  222.723832] pps pps0: capture assert seq #28
[  223.180347] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=59, DAT0=ff, DAT1=ff
[  224.090613] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[  224.546759] pps pps0: PPS event at 1370146692.546652498
[  225.011232] pps pps0: capture assert seq #29
[  225.468600] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  225.925622] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=5a, DAT0=ff, DAT1=ff
[  226.825462] pps pps0: PPS event at 1370146694.825283703
[  227.274221] pps pps0: capture assert seq #30
[  227.730804] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=5a, DAT0=ff, DAT1=ff
[  228.585983] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=ff
[  229.125547] pps pps0: PPS event at 1370146697.125438898
[  229.443908] pps pps0: capture assert seq #31
[  229.800983] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5b, DAT0=ff, DAT1=ff
[  230.553554] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[  230.943596] pps pps0: PPS event at 1370146698.943493140
[  231.415932] pps pps0: capture assert seq #32
[  231.873530] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  232.375663] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=5c, DAT0=ff, DAT1=ff
[  233.304631] pps pps0: PPS event at 1370146701.304526533
[  233.778550] pps pps0: capture assert seq #33
[  234.225414] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=5c, DAT0=ff, DAT1=ff
[  235.130718] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5d, DAT0=ff, DAT1=ff
[  236.066526] pps pps0: PPS event at 1370146704.066418008
[  236.523839] pps pps0: capture assert seq #34
[  236.977804] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5d, DAT0=ff, DAT1=ff
[  237.876714] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[  238.345852] pps pps0: PPS event at 1370146706.345744488
[  238.819413] pps pps0: capture assert seq #35
[  239.278714] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[  239.744537] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=5e, DAT0=ff, DAT1=ff
[  240.669579] pps pps0: PPS event at 1370146708.669471868
[  241.147751] pps pps0: capture assert seq #36
[  241.703777] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=5e, DAT0=ff, DAT1=ff
[  242.593951] i2c i2c-0: Transaction (pre): CNT=08, CMD=00, ADD=5f, DAT0=ff, DAT1=ff
[  243.532583] pps pps0: PPS event at 1370146711.532478658
[  243.998604] pps pps0: capture assert seq #37
[  244.503967] i2c i2c-0: Transaction (post): CNT=08, CMD=00, ADD=5f, DAT0=ff, DAT1=ff
[  245.399897] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[  245.894519] pps pps0: PPS event at 1370146713.884999569
[  246.383352] pps pps0: capture assert seq #38
[  246.854419] i2c-core: driver [w83781d] registered
[  247.314502] i2c i2c-0: found normal entry for adapter 0, addr 0x28
[  247.785902] i2c i2c-0: Transaction (pre): CNT=00, CMD=00, ADD=50, DAT0=ff, DAT1=ff
[  248.742580] pps pps0: PPS event at 1370146716.742468067
[  249.212539] pps pps0: capture assert seq #39
[  249.665993] i2c i2c-0: Transaction (post): CNT=00, CMD=00, ADD=50, DAT0=ff, DAT1=ff
[  250.233592] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=51, DAT0=ff, DAT1=ff
[  251.158840] pps pps0: PPS event at 1370146719.153244205
[  251.611757] pps pps0: capture assert seq #40
[  252.080826] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=51, DAT0=ff, DAT1=ff
[  253.013448] i2c i2c-0: Detection of w83781d chip failed at step 3
[  253.488594] pps pps0: PPS event at 1370146721.488479722
[  253.973964] pps pps0: capture assert seq #41
[  254.437966] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[  254.923794] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=52, DAT0=ff, DAT1=ff
[  255.862932] pps pps0: PPS event at 1370146723.862825059
[  256.335833] pps pps0: capture assert seq #42
[  256.661681] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=52, DAT0=ff, DAT1=ff
[  257.596648] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=53, DAT0=ff, DAT1=ff
[  258.523371] pps pps0: PPS event at 1370146726.523256369
[  258.970662] pps pps0: capture assert seq #43
[  259.477806] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=53, DAT0=ff, DAT1=ff
[  260.290011] i2c i2c-0: Detection of w83781d chip failed at step 3
[  260.530704] pps pps0: PPS event at 1370146728.530595725
[  260.773253] pps pps0: capture assert seq #44
[  261.232453] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[  261.706537] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=54, DAT0=ff, DAT1=ff
[  262.651282] pps pps0: PPS event at 1370146730.651116085
[  263.123384] pps pps0: capture assert seq #45
[  263.547554] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=54, DAT0=ff, DAT1=ff
[  264.040162] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=55, DAT0=ff, DAT1=ff
[  264.544460] pps pps0: PPS event at 1370146732.544381094
[  264.787084] pps pps0: capture assert seq #46
[  265.052975] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=55, DAT0=ff, DAT1=ff
[  265.814012] i2c i2c-0: Detection of w83781d chip failed at step 3
[  266.301298] pps pps0: PPS event at 1370146734.299212991
[  266.776916] pps pps0: capture assert seq #47
[  267.240445] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[  267.704571] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=56, DAT0=ff, DAT1=ff
[  268.616520] pps pps0: PPS event at 1370146736.616413808
[  269.083125] pps pps0: capture assert seq #48
[  269.531936] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=56, DAT0=ff, DAT1=ff
[  270.422678] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=57, DAT0=ff, DAT1=ff
[  271.293432] pps pps0: PPS event at 1370146739.293307239
[  271.541744] pps pps0: capture assert seq #49
[  271.812631] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=57, DAT0=ff, DAT1=ff
[  272.562598] i2c i2c-0: Detection of w83781d chip failed at step 3
[  273.034875] pps pps0: PPS event at 1370146741.034773818
[  273.386412] pps pps0: capture assert seq #50
[  273.614929] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  273.846117] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=ff
[  274.807494] pps pps0: PPS event at 1370146742.807387989
[  275.283738] pps pps0: capture assert seq #51
[  275.751400] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=ff
[  276.450663] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[  277.159945] pps pps0: PPS event at 1370146745.159840548
[  277.537843] pps pps0: capture assert seq #52
[  277.780977] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[  278.287657] i2c i2c-0: Detection of w83781d chip failed at step 3
[  278.737550] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  279.200517] pps pps0: PPS event at 1370146747.200401845
[  279.605916] pps pps0: capture assert seq #53
[  279.841584] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[  280.329692] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[  280.806692] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[  281.305710] pps pps0: PPS event at 1370146749.305601658
[  281.604321] pps pps0: capture assert seq #54
[  282.112324] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[  283.121814] pps pps0: PPS event at 1370146751.121707642
[  283.592068] pps pps0: capture assert seq #55
[  284.175986] i2c i2c-0: Detection of w83781d chip failed at step 3
[  284.639405] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  285.102759] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[  286.037487] pps pps0: PPS event at 1370146754.037379704
[  286.494059] pps pps0: capture assert seq #56
[  286.966617] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[  287.851624] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[  288.761796] pps pps0: PPS event at 1370146756.761691376
[  289.120682] pps pps0: capture assert seq #57
[  289.562398] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[  290.326670] i2c i2c-0: Detection of w83781d chip failed at step 3
[  290.705374] pps pps0: PPS event at 1370146758.705132388
[  290.935283] pps pps0: capture assert seq #58
[  291.166480] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[  291.467960] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=ff
[  292.284433] pps pps0: PPS event at 1370146760.284249355
[  292.860635] pps pps0: capture assert seq #59
[  293.528682] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5e, DAT0=ff, DAT1=ff
[  294.472752] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=ff
[  295.423006] pps pps0: PPS event at 1370146763.422902831
[  295.904787] pps pps0: capture assert seq #60
[  296.428822] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5f, DAT0=ff, DAT1=ff
[  297.387024] pps pps0: PPS event at 1370146765.386919163
[  297.881907] pps pps0: capture assert seq #61
[  298.393224] i2c i2c-0: Detection of w83781d chip failed at step 3
[  298.864158] i2c-core: driver [ad7418] registered
[  299.336001] i2c-core: driver [adm1021] registered
[  299.787185] pps pps0: PPS event at 1370146767.786999724
[  300.239142] pps pps0: capture assert seq #62
[  300.692016] i2c i2c-0: found normal entry for adapter 0, addr 0x18
[  301.130731] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=30, DAT0=ff, DAT1=ff
[  301.987020] pps pps0: PPS event at 1370146769.986914691
[  302.441053] pps pps0: capture assert seq #63
[  303.050005] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=30, DAT0=ff, DAT1=ff
[  304.042746] pps pps0: PPS event at 1370146772.042631185
[  304.526952] pps pps0: capture assert seq #64
[  305.007634] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=31, DAT0=ff, DAT1=ff
[  305.766725] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=31, DAT0=ff, DAT1=ff
[  306.243354] pps pps0: PPS event at 1370146774.243245048
[  306.474355] pps pps0: capture assert seq #65
[  306.693782] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=31, DAT0=ff, DAT1=ff
[  307.143415] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=31, DAT0=ff, DAT1=ff
[  307.592582] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=31, DAT0=ff, DAT1=ff
[  308.059633] pps pps0: PPS event at 1370146776.059516942
[  308.285616] pps pps0: capture assert seq #66
[  308.507560] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=31, DAT0=ff, DAT1=ff
[  308.958506] detect failed, chip not detected!
[  309.190351] i2c i2c-0: found normal entry for adapter 0, addr 0x19
[  309.453291] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=32, DAT0=ff, DAT1=ff
[  310.230265] pps pps0: PPS event at 1370146778.230094828
[  310.536712] pps pps0: capture assert seq #67
[  310.773964] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=32, DAT0=ff, DAT1=ff
[  311.491512] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=33, DAT0=ff, DAT1=ff
[  312.017551] pps pps0: PPS event at 1370146780.017436804
[  312.325390] pps pps0: capture assert seq #68
[  312.651008] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=33, DAT0=ff, DAT1=ff
[  313.438389] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=33, DAT0=ff, DAT1=ff
[  314.344429] pps pps0: PPS event at 1370146782.344313220
[  314.836294] pps pps0: capture assert seq #69
[  315.318323] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=33, DAT0=ff, DAT1=ff
[  316.263648] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=33, DAT0=ff, DAT1=ff
[  317.212267] pps pps0: PPS event at 1370146785.212161256
[  317.680602] pps pps0: capture assert seq #70
[  318.352533] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=33, DAT0=ff, DAT1=ff
[  319.194670] detect failed, chip not detected!
[  319.437716] pps pps0: PPS event at 1370146787.437605575
[  319.677831] pps pps0: capture assert seq #71
[  320.082675] i2c i2c-0: found normal entry for adapter 0, addr 0x1a
[  320.540936] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=34, DAT0=ff, DAT1=ff
[  321.886815] pps pps0: PPS event at 1370146789.886708328
[  322.551921] pps pps0: capture assert seq #72
[  323.249672] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=34, DAT0=ff, DAT1=ff
[  324.519883] pps pps0: PPS event at 1370146792.519779533
[  325.185895] pps pps0: capture assert seq #73
[  325.865089] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=35, DAT0=ff, DAT1=ff
[  326.964598] pps pps0: PPS event at 1370146794.964491631
[  327.427296] pps pps0: capture assert seq #74
[  327.894818] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=35, DAT0=ff, DAT1=ff
[  328.787945] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=35, DAT0=ff, DAT1=ff
[  329.335360] pps pps0: PPS event at 1370146797.335246301
[  329.719457] pps pps0: capture assert seq #75
[  330.212763] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=35, DAT0=ff, DAT1=ff
[  331.093635] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=35, DAT0=ff, DAT1=ff
[  332.022915] pps pps0: PPS event at 1370146800.022806808
[  332.704236] pps pps0: capture assert seq #76
[  333.383759] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=35, DAT0=ff, DAT1=ff
[  334.723793] pps pps0: PPS event at 1370146802.723688856
[  335.452848] pps pps0: capture assert seq #77
[  335.931017] detect failed, chip not detected!
[  336.371439] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[  336.842386] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=52, DAT0=ff, DAT1=ff
[  337.756522] pps pps0: PPS event at 1370146805.747086582
[  338.224248] pps pps0: capture assert seq #78
[  338.685941] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=52, DAT0=ff, DAT1=ff
[  339.589865] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=ff
[  340.181080] pps pps0: PPS event at 1370146808.180962623
[  340.553858] pps pps0: capture assert seq #79
[  340.889979] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=ff
[  341.373232] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=53, DAT0=ff, DAT1=ff
[  341.991002] pps pps0: PPS event at 1370146809.990888017
[  342.216011] pps pps0: capture assert seq #80
[  342.598732] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=53, DAT0=ff, DAT1=ff
[  343.393783] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=53, DAT0=ff, DAT1=ff
[  344.047415] pps pps0: PPS event at 1370146812.047173126
[  344.526805] pps pps0: capture assert seq #81
[  345.083353] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=53, DAT0=ff, DAT1=ff
[  346.109743] pps pps0: PPS event at 1370146814.109642595
[  346.785630] pps pps0: capture assert seq #82
[  347.424324] detect failed, chip not detected!
[  347.900986] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[  348.360907] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=54, DAT0=ff, DAT1=ff
[  348.827362] pps pps0: PPS event at 1370146816.827144750
[  349.059498] pps pps0: capture assert seq #83
[  349.291148] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=54, DAT0=ff, DAT1=ff
[  349.826712] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=ff
[  350.780964] pps pps0: PPS event at 1370146818.780854561
[  351.245409] pps pps0: capture assert seq #84
[  351.560357] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=ff
[  352.475911] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=55, DAT0=ff, DAT1=ff
[  353.258531] pps pps0: PPS event at 1370146821.258423598
[  353.493902] pps pps0: capture assert seq #85
[  353.725485] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=55, DAT0=ff, DAT1=ff
[  354.270510] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=55, DAT0=ff, DAT1=ff
[  355.180957] pps pps0: PPS event at 1370146823.180852907
[  355.630579] pps pps0: capture assert seq #86
[  356.126413] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=55, DAT0=ff, DAT1=ff
[  357.049416] detect failed, chip not detected!
[  357.507703] pps pps0: PPS event at 1370146825.507596165
[  358.148629] pps pps0: capture assert seq #87
[  358.862217] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[  359.509076] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=56, DAT0=ff, DAT1=ff
[  360.177872] pps pps0: PPS event at 1370146828.177767510
[  360.634554] pps pps0: capture assert seq #88
[  361.120512] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=56, DAT0=ff, DAT1=ff
[  361.816406] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=ff
[  362.755629] pps pps0: PPS event at 1370146830.755522569
[  363.094916] pps pps0: capture assert seq #89
[  363.566562] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=ff
[  364.150694] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=57, DAT0=ff, DAT1=ff
[  364.874934] pps pps0: PPS event at 1370146832.874828461
[  365.321976] pps pps0: capture assert seq #90
[  365.783877] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=57, DAT0=ff, DAT1=ff
[  366.333634] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=57, DAT0=ff, DAT1=ff
[  366.811496] pps pps0: PPS event at 1370146834.811386023
[  367.067428] pps pps0: capture assert seq #91
[  367.524572] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=57, DAT0=ff, DAT1=ff
[  368.433235] detect failed, chip not detected!
[  368.873240] pps pps0: PPS event at 1370146836.873093944
[  369.399713] pps pps0: capture assert seq #92
[  369.836934] i2c i2c-0: found normal entry for adapter 0, addr 0x4c
[  370.296937] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=98, DAT0=ff, DAT1=ff
[  370.889920] pps pps0: PPS event at 1370146838.889811428
[  371.124352] pps pps0: capture assert seq #93
[  371.400408] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=98, DAT0=ff, DAT1=ff
[  371.865594] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=99, DAT0=ff, DAT1=ff
[  372.333759] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=99, DAT0=ff, DAT1=ff
[  372.801420] pps pps0: PPS event at 1370146840.801303002
[  373.041441] pps pps0: capture assert seq #94
[  373.279328] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=ff
[  373.760476] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=99, DAT0=ff, DAT1=ff
[  374.231821] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=99, DAT0=ff, DAT1=ff
[  374.717382] pps pps0: PPS event at 1370146842.717280208
[  374.958810] pps pps0: capture assert seq #95
[  375.259861] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=99, DAT0=ff, DAT1=ff
[  375.995289] detect failed, chip not detected!
[  376.230287] i2c i2c-0: found normal entry for adapter 0, addr 0x4d
[  376.594515] pps pps0: PPS event at 1370146844.594409743
[  377.075541] pps pps0: capture assert seq #96
[  377.649835] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=9a, DAT0=ff, DAT1=ff
[  378.471287] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=9a, DAT0=ff, DAT1=ff
[  379.066184] pps pps0: PPS event at 1370146847.065986762
[  379.615125] pps pps0: capture assert seq #97
[  380.102763] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=9b, DAT0=ff, DAT1=ff
[  381.094177] pps pps0: PPS event at 1370146849.094103063
[  381.437892] pps pps0: capture assert seq #98
[  381.942655] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=9b, DAT0=ff, DAT1=ff
[  382.889044] pps pps0: PPS event at 1370146850.888933394
[  383.355864] pps pps0: capture assert seq #99
[  383.586359] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=ff
[  384.350788] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9b, DAT0=ff, DAT1=ff
[  385.287758] pps pps0: PPS event at 1370146853.287654449
[  385.618805] pps pps0: capture assert seq #100
[  385.872216] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=9b, DAT0=ff, DAT1=ff
[  386.410139] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=9b, DAT0=ff, DAT1=ff
[  387.334195] pps pps0: PPS event at 1370146855.333969040
[  387.754008] pps pps0: capture assert seq #101
[  388.048998] detect failed, chip not detected!
[  388.367784] i2c i2c-0: found normal entry for adapter 0, addr 0x4e
[  388.821729] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=9c, DAT0=ff, DAT1=ff
[  389.707352] pps pps0: PPS event at 1370146857.707251119
[  390.156767] pps pps0: capture assert seq #102
[  390.603475] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=9c, DAT0=ff, DAT1=ff
[  391.483827] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=9d, DAT0=ff, DAT1=ff
[  392.377062] pps pps0: PPS event at 1370146860.376961087
[  392.843008] pps pps0: capture assert seq #103
[  393.229573] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=9d, DAT0=ff, DAT1=ff
[  393.783599] i2c i2c-0: Transaction (pre): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=ff
[  394.503968] pps pps0: PPS event at 1370146862.503860763
[  394.741393] pps pps0: capture assert seq #104
[  395.003388] i2c i2c-0: Transaction (post): CNT=08, CMD=04, ADD=9d, DAT0=ff, DAT1=ff
[  395.823198] i2c i2c-0: Transaction (pre): CNT=08, CMD=03, ADD=9d, DAT0=ff, DAT1=ff
[  396.627680] pps pps0: PPS event at 1370146864.627573761
[  396.945693] pps pps0: capture assert seq #105
[  397.525829] i2c i2c-0: Transaction (post): CNT=08, CMD=03, ADD=9d, DAT0=ff, DAT1=ff
[  398.464454] detect failed, chip not detected!
[  398.711105] pps pps0: PPS event at 1370146866.711003808
[  399.106235] pps pps0: capture assert seq #106
[  399.544815] i2c-core: driver [adm1025] registered
[  399.995471] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  400.456940] i2c i2c-0: Transaction (pre): CNT=00, CMD=03, ADD=58, DAT0=ff, DAT1=ff
[  401.357474] pps pps0: PPS event at 1370146869.357369179
[  401.802772] pps pps0: capture assert seq #107
[  402.361901] i2c i2c-0: Transaction (post): CNT=00, CMD=03, ADD=58, DAT0=ff, DAT1=ff
[  403.276791] pps pps0: PPS event at 1370146871.276690820
[  403.743463] pps pps0: capture assert seq #108
[  404.199629] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[  404.944500] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=59, DAT0=ff, DAT1=ff
[  405.586013] pps pps0: PPS event at 1370146873.585908975
[  405.971118] pps pps0: capture assert seq #109
[  406.394617] i2c i2c-0: ADM1025 detection failed at 0x2c
[  406.854469] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  407.348855] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[  408.334340] pps pps0: PPS event at 1370146876.334229416
[  408.778398] pps pps0: capture assert seq #110
[  409.233876] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5a, DAT0=ff, DAT1=ff
[  410.088181] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[  411.027610] pps pps0: PPS event at 1370146879.027504573
[  411.581482] pps pps0: capture assert seq #111
[  412.035497] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5b, DAT0=ff, DAT1=ff
[  413.353813] pps pps0: PPS event at 1370146881.353574666
[  414.031150] pps pps0: capture assert seq #112
[  414.613547] i2c i2c-0: ADM1025 detection failed at 0x2d
[  415.024369] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  415.458017] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[  416.440403] pps pps0: PPS event at 1370146884.440290698
[  416.864813] pps pps0: capture assert seq #113
[  417.319418] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=5c, DAT0=ff, DAT1=ff
[  418.119944] i2c i2c-0: Transaction (pre): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[  418.638109] pps pps0: PPS event at 1370146886.637940004
[  418.916304] pps pps0: capture assert seq #114
[  419.293363] i2c i2c-0: Transaction (post): CNT=08, CMD=40, ADD=5d, DAT0=ff, DAT1=ff
[  420.031694] i2c i2c-0: ADM1025 detection failed at 0x2e
[  420.523594] pps pps0: PPS event at 1370146888.523496614
[  421.146529] pps pps0: capture assert seq #115
[  421.425199] i2c-core: driver [adm1026] registered
[  421.681978] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  421.937753] i2c i2c-0: Transaction (pre): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=ff
[  422.439226] pps pps0: PPS event at 1370146890.439015464
[  422.690379] pps pps0: capture assert seq #116
[  422.944130] i2c i2c-0: Transaction (post): CNT=00, CMD=40, ADD=58, DAT0=ff, DAT1=ff
[  423.442458] i2c i2c-0: Transaction (pre): CNT=08, CMD=16, ADD=59, DAT0=ff, DAT1=ff
[  423.944227] pps pps0: PPS event at 1370146891.944150006
[  424.196642] pps pps0: capture assert seq #117
[  424.458459] i2c i2c-0: Transaction (post): CNT=08, CMD=16, ADD=59, DAT0=ff, DAT1=ff
[  425.326129] i2c i2c-0: Transaction (pre): CNT=08, CMD=17, ADD=59, DAT0=ff, DAT1=ff
[  425.828907] pps pps0: PPS event at 1370146893.828799556
[  426.179466] pps pps0: capture assert seq #118
[  426.404170] i2c i2c-0: Transaction (post): CNT=08, CMD=17, ADD=59, DAT0=ff, DAT1=ff
[  426.848504] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and VERSTEP: 0xff
[  427.295623] i2c i2c-0: Autodetecting device at 0,0x2c...
[  427.522016] pps pps0: PPS event at 1370146895.521923526
[  427.748954] pps pps0: capture assert seq #119
[  427.983392] i2c i2c-0: Autodetection failed
[  428.204348] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  428.424678] i2c i2c-0: Transaction (pre): CNT=00, CMD=17, ADD=5a, DAT0=ff, DAT1=ff
[  428.873151] i2c i2c-0: Transaction (post): CNT=00, CMD=17, ADD=5a, DAT0=ff, DAT1=ff
[  429.329557] pps pps0: PPS event at 1370146897.329459743
[  429.562217] pps pps0: capture assert seq #120
[  429.787043] i2c i2c-0: Transaction (pre): CNT=08, CMD=16, ADD=5b, DAT0=ff, DAT1=ff
[  430.259831] i2c i2c-0: Transaction (post): CNT=08, CMD=16, ADD=5b, DAT0=ff, DAT1=ff
[  430.792185] pps pps0: PPS event at 1370146898.792031222
[  431.023271] pps pps0: capture assert seq #121
[  431.247606] i2c i2c-0: Transaction (pre): CNT=08, CMD=17, ADD=5b, DAT0=ff, DAT1=ff
[  431.731286] i2c i2c-0: Transaction (post): CNT=08, CMD=17, ADD=5b, DAT0=ff, DAT1=ff
[  432.197123] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and VERSTEP: 0xff
[  432.668307] pps pps0: PPS event at 1370146900.668205475
[  432.905393] pps pps0: capture assert seq #122
[  433.144369] i2c i2c-0: Autodetecting device at 0,0x2d...
[  433.388993] i2c i2c-0: Autodetection failed
[  433.621636] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  433.851441] i2c i2c-0: Transaction (pre): CNT=00, CMD=17, ADD=5c, DAT0=ff, DAT1=ff
[  434.300666] pps pps0: PPS event at 1370146902.300580578
[  434.530058] pps pps0: capture assert seq #123
[  434.851269] i2c i2c-0: Transaction (post): CNT=00, CMD=17, ADD=5c, DAT0=ff, DAT1=ff
[  435.312868] i2c i2c-0: Transaction (pre): CNT=08, CMD=16, ADD=5d, DAT0=ff, DAT1=ff
[  435.785387] pps pps0: PPS event at 1370146903.785284073
[  436.019010] pps pps0: capture assert seq #124
[  436.254224] i2c i2c-0: Transaction (post): CNT=08, CMD=16, ADD=5d, DAT0=ff, DAT1=ff
[  436.715932] i2c i2c-0: Transaction (pre): CNT=08, CMD=17, ADD=5d, DAT0=ff, DAT1=ff
[  437.203228] i2c i2c-0: Transaction (post): CNT=08, CMD=17, ADD=5d, DAT0=ff, DAT1=ff
[  437.673918] pps pps0: PPS event at 1370146905.673817324
[  437.911481] pps pps0: capture assert seq #125
[  438.148855] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and VERSTEP: 0xff
[  438.638874] i2c i2c-0: Autodetecting device at 0,0x2e...
[  438.876370] i2c i2c-0: Autodetection failed
[  439.110313] i2c-core: driver [adm1029] registered
[  439.336559] pps pps0: PPS event at 1370146907.336464478
[  439.555720] pps pps0: capture assert seq #126
[  439.780351] i2c i2c-0: found normal entry for adapter 0, addr 0x28
[  440.000681] i2c i2c-0: Transaction (pre): CNT=00, CMD=17, ADD=50, DAT0=ff, DAT1=ff
[  440.515304] i2c i2c-0: Transaction (post): CNT=00, CMD=17, ADD=50, DAT0=ff, DAT1=ff
[  440.968625] pps pps0: PPS event at 1370146908.968526456
[  441.194446] pps pps0: capture assert seq #127
[  441.437971] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=51, DAT0=ff, DAT1=ff
[  442.278296] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=51, DAT0=ff, DAT1=ff
[  442.732915] pps pps0: PPS event at 1370146910.732824980
[  443.096269] pps pps0: capture assert seq #128
[  443.521928] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=51, DAT0=ff, DAT1=ff
[  444.222706] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=51, DAT0=ff, DAT1=ff
[  444.678176] pps pps0: PPS event at 1370146912.677969047
[  444.919148] pps pps0: capture assert seq #129
[  445.150863] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=51, DAT0=ff, DAT1=ff
[  445.748766] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=51, DAT0=ff, DAT1=ff
[  446.299387] pps pps0: PPS event at 1370146914.299218112
[  446.533029] pps pps0: capture assert seq #130
[  446.764709] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=51, DAT0=ff, DAT1=ff
[  447.234934] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=51, DAT0=ff, DAT1=ff
[  447.727070] i2c i2c-0: found normal entry for adapter 0, addr 0x29
[  447.984084] pps pps0: PPS event at 1370146915.983970430
[  448.255891] pps pps0: capture assert seq #131
[  448.519403] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=52, DAT0=ff, DAT1=ff
[  449.036750] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=52, DAT0=ff, DAT1=ff
[  449.546772] pps pps0: PPS event at 1370146917.546656038
[  449.977139] pps pps0: capture assert seq #132
[  450.276187] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=53, DAT0=ff, DAT1=ff
[  450.755925] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=53, DAT0=ff, DAT1=ff
[  451.248864] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=53, DAT0=ff, DAT1=ff
[  452.216681] pps pps0: PPS event at 1370146920.216579649
[  452.715093] pps pps0: capture assert seq #133
[  453.226833] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=53, DAT0=ff, DAT1=ff
[  454.202593] pps pps0: PPS event at 1370146922.202502733
[  454.497383] pps pps0: capture assert seq #134
[  454.736323] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=53, DAT0=ff, DAT1=ff
[  455.648296] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=53, DAT0=ff, DAT1=ff
[  456.276728] pps pps0: PPS event at 1370146924.276623841
[  456.530821] pps pps0: capture assert seq #135
[  456.777989] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=ff
[  457.296454] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=53, DAT0=ff, DAT1=ff
[  457.786793] pps pps0: PPS event at 1370146925.786689349
[  458.040721] pps pps0: capture assert seq #136
[  458.289470] i2c i2c-0: found normal entry for adapter 0, addr 0x2a
[  458.536857] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=54, DAT0=ff, DAT1=ff
[  459.047424] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=54, DAT0=ff, DAT1=ff
[  459.533952] pps pps0: PPS event at 1370146927.533850676
[  459.773484] pps pps0: capture assert seq #137
[  460.008353] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=55, DAT0=ff, DAT1=ff
[  460.480349] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=55, DAT0=ff, DAT1=ff
[  460.946492] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=55, DAT0=ff, DAT1=ff
[  461.424336] pps pps0: PPS event at 1370146929.424234967
[  461.664304] pps pps0: capture assert seq #138
[  461.924435] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=55, DAT0=ff, DAT1=ff
[  462.423629] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=55, DAT0=ff, DAT1=ff
[  463.088303] pps pps0: PPS event at 1370146931.088083686
[  463.571157] pps pps0: capture assert seq #139
[  463.919636] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=55, DAT0=ff, DAT1=ff
[  464.392182] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=ff
[  464.918210] pps pps0: PPS event at 1370146932.918117218
[  465.160516] pps pps0: capture assert seq #140
[  465.397590] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=55, DAT0=ff, DAT1=ff
[  465.869979] i2c i2c-0: found normal entry for adapter 0, addr 0x2b
[  466.114346] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=56, DAT0=ff, DAT1=ff
[  466.601313] pps pps0: PPS event at 1370146934.601217406
[  466.842946] pps pps0: capture assert seq #141
[  467.081456] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=56, DAT0=ff, DAT1=ff
[  467.564872] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=57, DAT0=ff, DAT1=ff
[  468.049847] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=57, DAT0=ff, DAT1=ff
[  468.592077] pps pps0: PPS event at 1370146936.591962792
[  468.833817] pps pps0: capture assert seq #142
[  469.068530] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=57, DAT0=ff, DAT1=ff
[  469.550416] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=57, DAT0=ff, DAT1=ff
[  470.056267] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=57, DAT0=ff, DAT1=ff
[  470.561460] pps pps0: PPS event at 1370146938.561348047
[  470.949904] pps pps0: capture assert seq #143
[  471.295314] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=57, DAT0=ff, DAT1=ff
[  472.258870] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=ff
[  473.129556] pps pps0: PPS event at 1370146941.129451936
[  473.376509] pps pps0: capture assert seq #144
[  473.717322] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=57, DAT0=ff, DAT1=ff
[  474.604606] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  474.848824] pps pps0: PPS event at 1370146942.848730153
[  475.113698] pps pps0: capture assert seq #145
[  475.605646] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=58, DAT0=ff, DAT1=ff
[  476.326984] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=58, DAT0=ff, DAT1=ff
[  476.817552] pps pps0: PPS event at 1370146944.817458995
[  477.269529] pps pps0: capture assert seq #146
[  477.541838] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=59, DAT0=ff, DAT1=ff
[  478.027264] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=59, DAT0=ff, DAT1=ff
[  478.812098] pps pps0: PPS event at 1370146946.811988467
[  479.316551] pps pps0: capture assert seq #147
[  479.571095] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=59, DAT0=ff, DAT1=ff
[  480.090594] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=59, DAT0=ff, DAT1=ff
[  480.577594] pps pps0: PPS event at 1370146948.577490705
[  480.823772] pps pps0: capture assert seq #148
[  481.066551] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=59, DAT0=ff, DAT1=ff
[  481.788255] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=59, DAT0=ff, DAT1=ff
[  482.784853] pps pps0: PPS event at 1370146950.784748725
[  483.282406] pps pps0: capture assert seq #149
[  483.625600] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=59, DAT0=ff, DAT1=ff
[  484.313308] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=59, DAT0=ff, DAT1=ff
[  484.814735] pps pps0: PPS event at 1370146952.814640114
[  485.063031] pps pps0: capture assert seq #150
[  485.307286] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  485.552529] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=5a, DAT0=ff, DAT1=ff
[  486.467913] pps pps0: PPS event at 1370146954.467807000
[  486.954888] pps pps0: capture assert seq #151
[  487.422330] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=5a, DAT0=ff, DAT1=ff
[  487.914340] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5b, DAT0=ff, DAT1=ff
[  488.455927] pps pps0: PPS event at 1370146956.455823749
[  488.702578] pps pps0: capture assert seq #152
[  488.950268] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5b, DAT0=ff, DAT1=ff
[  489.582794] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=5b, DAT0=ff, DAT1=ff
[  490.172566] pps pps0: PPS event at 1370146958.159993873
[  490.496377] pps pps0: capture assert seq #153
[  490.911618] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=5b, DAT0=ff, DAT1=ff
[  491.872595] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=5b, DAT0=ff, DAT1=ff
[  492.860614] pps pps0: PPS event at 1370146960.860508517
[  493.336721] pps pps0: capture assert seq #154
[  493.635373] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=5b, DAT0=ff, DAT1=ff
[  494.498821] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=5b, DAT0=ff, DAT1=ff
[  495.410256] pps pps0: PPS event at 1370146963.410141161
[  495.879617] pps pps0: capture assert seq #155
[  496.440791] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=5b, DAT0=ff, DAT1=ff
[  497.376640] pps pps0: PPS event at 1370146965.367165005
[  497.677266] pps pps0: capture assert seq #156
[  498.143688] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  498.613486] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=5c, DAT0=ff, DAT1=ff
[  499.381938] pps pps0: PPS event at 1370146967.381834827
[  499.646090] pps pps0: capture assert seq #157
[  500.003404] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=5c, DAT0=ff, DAT1=ff
[  500.992739] pps pps0: PPS event at 1370146968.992625258
[  501.410261] pps pps0: capture assert seq #158
[  501.892568] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5d, DAT0=ff, DAT1=ff
[  502.869744] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5d, DAT0=ff, DAT1=ff
[  503.782077] pps pps0: PPS event at 1370146971.781982189
[  504.251397] pps pps0: capture assert seq #159
[  504.591973] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=5d, DAT0=ff, DAT1=ff
[  505.176411] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=5d, DAT0=ff, DAT1=ff
[  505.636993] pps pps0: PPS event at 1370146973.636893667
[  505.878252] pps pps0: capture assert seq #160
[  506.208565] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=5d, DAT0=ff, DAT1=ff
[  506.673247] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=5d, DAT0=ff, DAT1=ff
[  507.242754] pps pps0: PPS event at 1370146975.242654034
[  507.488464] pps pps0: capture assert seq #161
[  507.726998] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=5d, DAT0=ff, DAT1=ff
[  508.235548] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=5d, DAT0=ff, DAT1=ff
[  508.728629] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[  508.981325] pps pps0: PPS event at 1370146976.981213459
[  509.232114] pps pps0: capture assert seq #162
[  509.604617] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=5e, DAT0=ff, DAT1=ff
[  510.606359] pps pps0: PPS event at 1370146978.606141475
[  511.101470] pps pps0: capture assert seq #163
[  511.596872] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=5e, DAT0=ff, DAT1=ff
[  512.627928] pps pps0: PPS event at 1370146980.627823725
[  513.105214] pps pps0: capture assert seq #164
[  513.596626] i2c i2c-0: Transaction (pre): CNT=08, CMD=0d, ADD=5f, DAT0=ff, DAT1=ff
[  514.760485] pps pps0: PPS event at 1370146982.756191273
[  515.228773] pps pps0: capture assert seq #165
[  515.701750] i2c i2c-0: Transaction (post): CNT=08, CMD=0d, ADD=5f, DAT0=ff, DAT1=ff
[  516.672467] i2c i2c-0: Transaction (pre): CNT=08, CMD=0e, ADD=5f, DAT0=ff, DAT1=ff
[  517.603798] pps pps0: PPS event at 1370146985.603695449
[  518.034363] pps pps0: capture assert seq #166
[  518.272830] i2c i2c-0: Transaction (post): CNT=08, CMD=0e, ADD=5f, DAT0=ff, DAT1=ff
[  518.990640] i2c i2c-0: Transaction (pre): CNT=08, CMD=06, ADD=5f, DAT0=ff, DAT1=ff
[  519.917947] pps pps0: PPS event at 1370146987.917842030
[  520.393981] pps pps0: capture assert seq #167
[  520.886985] i2c i2c-0: Transaction (post): CNT=08, CMD=06, ADD=5f, DAT0=ff, DAT1=ff
[  521.396845] i2c i2c-0: Transaction (pre): CNT=08, CMD=02, ADD=5f, DAT0=ff, DAT1=ff
[  521.948585] pps pps0: PPS event at 1370146989.948480180
[  522.471827] pps pps0: capture assert seq #168
[  522.825140] i2c i2c-0: Transaction (post): CNT=08, CMD=02, ADD=5f, DAT0=ff, DAT1=ff
[  523.672718] i2c-core: driver [adm9240] registered
[  524.137485] pps pps0: PPS event at 1370146992.137363162
[  524.687010] pps pps0: capture assert seq #169
[  525.059635] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  525.473327] i2c i2c-0: Transaction (pre): CNT=00, CMD=02, ADD=58, DAT0=ff, DAT1=ff
[  526.326476] pps pps0: PPS event at 1370146994.326359955
[  526.810939] pps pps0: capture assert seq #170
[  527.310000] i2c i2c-0: Transaction (post): CNT=00, CMD=02, ADD=58, DAT0=ff, DAT1=ff
[  528.251624] pps pps0: PPS event at 1370146996.251526522
[  528.739442] pps pps0: capture assert seq #171
[  529.186864] i2c i2c-0: Transaction (pre): CNT=08, CMD=48, ADD=59, DAT0=ff, DAT1=ff
[  530.124623] i2c i2c-0: Transaction (post): CNT=08, CMD=48, ADD=59, DAT0=ff, DAT1=ff
[  530.648063] pps pps0: PPS event at 1370146998.647242508
[  531.141587] pps pps0: capture assert seq #172
[  531.577980] i2c i2c-0: detect fail: address match, 0x2c
[  532.012457] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  532.370004] i2c i2c-0: Transaction (pre): CNT=00, CMD=48, ADD=5a, DAT0=ff, DAT1=ff
[  532.830647] pps pps0: PPS event at 1370147000.830541061
[  533.044038] pps pps0: capture assert seq #173
[  533.466254] i2c i2c-0: Transaction (post): CNT=00, CMD=48, ADD=5a, DAT0=ff, DAT1=ff
[  534.261541] i2c i2c-0: Transaction (pre): CNT=08, CMD=48, ADD=5b, DAT0=ff, DAT1=ff
[  534.781826] pps pps0: PPS event at 1370147002.781724316
[  535.232229] pps pps0: capture assert seq #174
[  535.698796] i2c i2c-0: Transaction (post): CNT=08, CMD=48, ADD=5b, DAT0=ff, DAT1=ff
[  536.585751] i2c i2c-0: detect fail: address match, 0x2d
[  537.098438] pps pps0: PPS event at 1370147005.098335038
[  537.628432] pps pps0: capture assert seq #175
[  538.056445] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  538.499677] i2c i2c-0: Transaction (pre): CNT=00, CMD=48, ADD=5c, DAT0=ff, DAT1=ff
[  539.439486] pps pps0: PPS event at 1370147007.439377914
[  539.939776] pps pps0: capture assert seq #176
[  540.333744] i2c i2c-0: Transaction (post): CNT=00, CMD=48, ADD=5c, DAT0=ff, DAT1=ff
[  541.233177] i2c i2c-0: Transaction (pre): CNT=08, CMD=48, ADD=5d, DAT0=ff, DAT1=ff
[  542.133555] pps pps0: PPS event at 1370147010.133441563
[  542.537035] pps pps0: capture assert seq #177
[  542.769551] i2c i2c-0: Transaction (post): CNT=08, CMD=48, ADD=5d, DAT0=ff, DAT1=ff
[  543.205993] i2c i2c-0: detect fail: address match, 0x2e
[  543.431114] i2c i2c-0: found normal entry for adapter 0, addr 0x2f
[  543.658090] i2c i2c-0: Transaction (pre): CNT=00, CMD=48, ADD=5e, DAT0=ff, DAT1=ff
[  544.096004] pps pps0: PPS event at 1370147012.095898111
[  544.352640] pps pps0: capture assert seq #178
[  544.577368] i2c i2c-0: Transaction (post): CNT=00, CMD=48, ADD=5e, DAT0=ff, DAT1=ff
[  545.092930] i2c i2c-0: Transaction (pre): CNT=08, CMD=48, ADD=5f, DAT0=ff, DAT1=ff
[  545.696241] pps pps0: PPS event at 1370147013.696127600
[  545.919741] pps pps0: capture assert seq #179
[  546.255972] i2c i2c-0: Transaction (post): CNT=08, CMD=48, ADD=5f, DAT0=ff, DAT1=ff
[  546.916908] i2c i2c-0: detect fail: address match, 0x2f
[  547.343880] pps pps0: PPS event at 1370147015.343775309
[  547.778953] pps pps0: capture assert seq #180
[  548.227484] i2c-core: driver [ads1015] registered
[  548.530524] i2c-core: driver [adt7410] registered
[  548.755981] i2c-core: driver [adt7475] registered
[  548.969628] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  549.363545] pps pps0: PPS event at 1370147017.363433737
[  549.586200] pps pps0: capture assert seq #181
[  549.813245] i2c i2c-0: Transaction (pre): CNT=00, CMD=48, ADD=58, DAT0=ff, DAT1=ff
[  550.262444] i2c i2c-0: Transaction (post): CNT=00, CMD=48, ADD=58, DAT0=ff, DAT1=ff
[  550.947365] pps pps0: PPS event at 1370147018.938970138
[  551.329693] pps pps0: capture assert seq #182
[  551.555179] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[  552.104421] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[  552.571458] pps pps0: PPS event at 1370147020.571351583
[  552.782696] pps pps0: capture assert seq #183
[  553.054290] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[  553.547394] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[  554.281322] pps pps0: PPS event at 1370147022.281217680
[  554.716506] pps pps0: capture assert seq #184
[  555.143784] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  555.528919] i2c i2c-0: Transaction (pre): CNT=00, CMD=3f, ADD=5a, DAT0=ff, DAT1=ff
[  556.174563] pps pps0: PPS event at 1370147024.174442162
[  556.593666] pps pps0: capture assert seq #185
[  557.050863] i2c i2c-0: Transaction (post): CNT=00, CMD=3f, ADD=5a, DAT0=ff, DAT1=ff
[  557.913715] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[  558.836135] pps pps0: PPS event at 1370147026.836029808
[  559.307672] pps pps0: capture assert seq #186
[  559.948707] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[  560.883186] pps pps0: PPS event at 1370147028.882968112
[  561.339953] pps pps0: capture assert seq #187
[  561.782006] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=5b, DAT0=ff, DAT1=ff
[  562.706884] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=5b, DAT0=ff, DAT1=ff
[  563.633897] pps pps0: PPS event at 1370147031.633794758
[  564.100505] pps pps0: capture assert seq #188
[  564.555663] i2c i2c-0: found normal entry for adapter 0, addr 0x2e
[  565.037644] i2c i2c-0: Transaction (pre): CNT=00, CMD=3f, ADD=5c, DAT0=ff, DAT1=ff
[  566.023916] pps pps0: PPS event at 1370147034.023808066
[  566.486247] pps pps0: capture assert seq #189
[  566.938473] i2c i2c-0: Transaction (post): CNT=00, CMD=3f, ADD=5c, DAT0=ff, DAT1=ff
[  567.820857] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=ff
[  568.868518] pps pps0: PPS event at 1370147036.868410082
[  569.519107] pps pps0: capture assert seq #190
[  570.075394] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5d, DAT0=ff, DAT1=ff
[  571.192285] pps pps0: PPS event at 1370147039.192187094
[  571.756121] pps pps0: capture assert seq #191
[  572.315297] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=5d, DAT0=ff, DAT1=ff
[  573.382473] pps pps0: PPS event at 1370147041.382374787
[  573.827390] pps pps0: capture assert seq #192
[  574.277060] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=5d, DAT0=ff, DAT1=ff
[  575.146892] applesmc: supported laptop not found!
[  575.596739] pps pps0: PPS event at 1370147043.596643532
[  576.047128] pps pps0: capture assert seq #193
[  576.493905] applesmc: driver init failed (ret=-19)!
[  576.944115] i2c-core: driver [asc7621] registered
[  577.375438] i2c i2c-0: found normal entry for adapter 0, addr 0x2c
[  577.814937] pps pps0: PPS event at 1370147045.814164846
[  578.293217] pps pps0: capture assert seq #194
[  578.714575] i2c i2c-0: Transaction (pre): CNT=00, CMD=3f, ADD=58, DAT0=ff, DAT1=ff
[  579.596254] i2c i2c-0: Transaction (post): CNT=00, CMD=3f, ADD=58, DAT0=ff, DAT1=ff
[  580.459438] pps pps0: PPS event at 1370147048.459329600
[  580.911630] pps pps0: capture assert seq #195
[  581.349092] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[  582.290257] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[  583.158370] pps pps0: PPS event at 1370147051.158266549
[  583.607772] pps pps0: capture assert seq #196
[  584.039588] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[  584.623306] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[  585.284546] pps pps0: PPS event at 1370147053.284440683
[  585.743380] pps pps0: capture assert seq #197
[  586.188743] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[  587.196682] pps pps0: PPS event at 1370147055.196585130
[  587.642744] pps pps0: capture assert seq #198
[  588.208966] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=59, DAT0=ff, DAT1=ff
[  589.587775] pps pps0: PPS event at 1370147057.587654515
[  590.250624] pps pps0: capture assert seq #199
[  590.935779] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[  592.227417] pps pps0: PPS event at 1370147060.227304066
[  592.828035] pps pps0: capture assert seq #200
[  593.618140] i2c i2c-0: Transaction (post): CNT=08, CMD=3f, ADD=59, DAT0=ff, DAT1=ff
[  594.908750] pps pps0: PPS event at 1370147062.904998050
[  595.589688] pps pps0: capture assert seq #201
[  596.295959] i2c i2c-0: found normal entry for adapter 0, addr 0x2d
[  596.836575] i2c i2c-0: Transaction (pre): CNT=00, CMD=3f, ADD=5a, DAT0=ff, DAT1=ff
[  597.933822] pps pps0: PPS event at 1370147065.933710697
[  598.337552] pps pps0: capture assert seq #202
[  598.761946] i2c i2c-0: Transaction (post): CNT=00, CMD=3f, ADD=5a, DAT0=ff, DAT1=ff
[  599.740254] i2c i2c-0: Transaction (pre): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[  600.472958] pps pps0: PPS event at 1370147068.472842440
[  600.784671] pps pps0: capture assert seq #203
[  601.049305] i2c i2c-0: Transaction (post): CNT=08, CMD=3e, ADD=5b, DAT0=ff, DAT1=ff
[  601.504829] i2c i2c-0: Transaction (pre): CNT=08, CMD=3f, ADD=5b, DAT0=ff, DAT1=ff
[  601.985461] 
[  601.985469] ======================================================
[  601.985470] [ INFO: possible circular locking dependency detected ]
[  601.985505] 3.10.0-rc3-00001-g71919ba #14 Not tainted
[  601.985511] -------------------------------------------------------
[  601.985515] kworker/0:1/17 is trying to acquire lock:
[  601.985609]  (&fb_info->lock){+.+.+.}, at: [<c19a7e98>] lock_fb_info+0x28/0x80

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="71919bac2803fc6834e178dd5935e7013fd78826-bisect.log"

git checkout e4aa937ec75df0eea0bee03bffa3303ad36c986b
Previous HEAD position was 71919ba... cpufreq: spear needs cpufreq table
HEAD is now at e4aa937... Linux 3.10-rc3

2013-06-02-15:57:21 e4aa937ec75df0eea0bee03bffa3303ad36c986b reuse /kernel/i386-randconfig-x05-0601/e4aa937ec75df0eea0bee03bffa3303ad36c986b/vmlinuz-3.10.0-rc3

2013-06-02-15:57:21 detecting boot state 	0...................	3 TEST FAILURE
bisect: bad commit e4aa937ec75df0eea0bee03bffa3303ad36c986b
git checkout v3.9
Previous HEAD position was e4aa937... Linux 3.10-rc3
HEAD is now at c1be5a5... Linux 3.9

2013-06-02-16:07:56 c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1 reuse /kernel/i386-randconfig-x05-0601/c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1/vmlinuz-3.9.0-bisect3-sound

2013-06-02-16:07:56 detecting boot state 	0 TEST FAILURE
bisect: bad commit v3.9
git checkout v3.8
Previous HEAD position was c1be5a5... Linux 3.9
HEAD is now at 19f949f... Linux 3.8

2013-06-02-16:08:29 19f949f52599ba7c3f67a5897ac6be14bfcb1200 reuse /kernel/i386-randconfig-x05-0601/19f949f52599ba7c3f67a5897ac6be14bfcb1200/vmlinuz-3.8.0-bisect3-sound

2013-06-02-16:08:29 detecting boot state 	0.............................................	15 SUCCESS
bisect: good commit v3.8
git bisect start v3.9 v3.8 --
Previous HEAD position was 19f949f... Linux 3.8
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 6477 revisions left to test after this (roughly 13 steps)
[d778df51c09264076fe0208c099ef7d428f21790] mm: vmscan: save work scanning (almost) empty LRU lists
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-16:32:13 d778df51c09264076fe0208c099ef7d428f21790 compiling
220 real  3182 user  206 sys  1538.30% cpu 	i386-randconfig-x05-0601

2013-06-02-16:37:18 detecting boot state 3.8.0-bisect3-sound-06052-gd778df5	0.........................	1..	2	10 SUCCESS
Bisecting: 3220 revisions left to test after this (roughly 12 steps)
[ee89f81252179dcbf6cd65bd48299f5e52292d88] Merge branch 'for-3.9/core' of git://git.kernel.dk/linux-block
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-16:52:52 ee89f81252179dcbf6cd65bd48299f5e52292d88 compiling
340 real  3213 user  218 sys  1008.76% cpu 	i386-randconfig-x05-0601

2013-06-02-16:58:49 detecting boot state 3.8.0-bisect3-sound-06685-gee89f81	0....................	4 TEST FAILURE
Increasing repeat count from 10 to 12
Bisecting: 1678 revisions left to test after this (roughly 11 steps)
[69086a78bdc973ec0b722be790b146e84ba8a8c4] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-17:09:52 69086a78bdc973ec0b722be790b146e84ba8a8c4 compiling
306 real  3220 user  228 sys  1124.37% cpu 	i386-randconfig-x05-0601

2013-06-02-17:15:13 detecting boot state 3.8.0-bisect3-sound-07630-g69086a7	0..........................................	8.	10	12 SUCCESS
Bisecting: 802 revisions left to test after this (roughly 10 steps)
[ed5dc2372dba46e0ecd08791b1a0399d313e5cff] Merge tag 'mmc-updates-for-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-17:38:51 ed5dc2372dba46e0ecd08791b1a0399d313e5cff compiling
323 real  3194 user  223 sys  1056.44% cpu 	i386-randconfig-x05-0601

2013-06-02-17:45:51 detecting boot state 3.8.0-bisect3-sound-05882-ged5dc23	0...................	3 TEST FAILURE
Bisecting: 406 revisions left to test after this (roughly 9 steps)
[1f3a574a4bfe86ebf7d51fac37e0668397372fd8] Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-17:56:23 1f3a574a4bfe86ebf7d51fac37e0668397372fd8 compiling
465 real  2971 user  207 sys  682.48% cpu 	i386-randconfig-x05-0601

2013-06-02-18:04:21 detecting boot state 3.8.0-rc6-bisect3-sound-00567-g1f3a574	0...................	5 TEST FAILURE
Increasing repeat count from 12 to 15
Bisecting: 233 revisions left to test after this (roughly 8 steps)
[cd17ef4114ad5c514b17e6a0bb02a309ab90b692] Merge tag 'drm-intel-next-2013-02-01' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-18:14:54 cd17ef4114ad5c514b17e6a0bb02a309ab90b692 compiling
339 real  2895 user  201 sys  913.33% cpu 	i386-randconfig-x05-0601

2013-06-02-18:20:52 detecting boot state 3.8.0-rc4-bisect3-sound-00235-gcd17ef4	0...................	13	14.......	15 SUCCESS
Bisecting: 118 revisions left to test after this (roughly 7 steps)
[210561ffd72d00eccf12c0131b8024d5436bae95] intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-18:35:54 210561ffd72d00eccf12c0131b8024d5436bae95 compiling
321 real  2892 user  202 sys  962.89% cpu 	i386-randconfig-x05-0601

2013-06-02-18:41:25 detecting boot state 3.8.0-rc6-bisect3-sound-00448-g210561f	0...................	9 TEST FAILURE
Increasing repeat count from 15 to 27
Bisecting: 51 revisions left to test after this (roughly 6 steps)
[73ccd6962fff19e53a7d4baaa17cf9311284ac9c] Merge branch 'drm-next-3.9' of git://people.freedesktop.org/~agd5f/linux into drm-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-18:52:01 73ccd6962fff19e53a7d4baaa17cf9311284ac9c compiling
314 real  2910 user  199 sys  989.21% cpu 	i386-randconfig-x05-0601

2013-06-02-18:59:11 detecting boot state 3.8.0-rc6-bisect3-sound-00396-g73ccd69	0...................	2 TEST FAILURE
Bisecting: 31 revisions left to test after this (roughly 5 steps)
[43f1214aa094e46efdfc0255d9601be0e5ea0f62] drm/radeon: use IBs for VM page table updates v2
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-19:09:43 43f1214aa094e46efdfc0255d9601be0e5ea0f62 compiling
450 real  2920 user  200 sys  692.67% cpu 	i386-randconfig-x05-0601

2013-06-02-19:17:23 detecting boot state 3.8.0-rc3-bisect3-sound-00139-g43f1214	0....................	22	23.......	26.............	27 SUCCESS
Bisecting: 15 revisions left to test after this (roughly 4 steps)
[bb0f78dd7ded88082b2430c43c65bc821c4ea360] Merge branch 'udl-fixes' into drm-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-19:39:55 bb0f78dd7ded88082b2430c43c65bc821c4ea360 compiling
311 real  2914 user  200 sys  1000.58% cpu 	i386-randconfig-x05-0601

2013-06-02-19:45:14 detecting boot state 3.8.0-rc6-bisect3-sound-00349-gbb0f78d	0...................	6 TEST FAILURE
Bisecting: 7 revisions left to test after this (roughly 3 steps)
[6dc1c49da6dd3bf020a66b2a135b9625ac01c2c7] Merge branch 'fbcon-locking-fixes' of ssh://people.freedesktop.org/~airlied/linux into drm-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-19:55:45 6dc1c49da6dd3bf020a66b2a135b9625ac01c2c7 compiling
301 real  2926 user  199 sys  1038.17% cpu 	i386-randconfig-x05-0601

2013-06-02-20:00:58 detecting boot state 3.8.0-rc6-bisect3-sound-00285-g6dc1c49	0...................	4 TEST FAILURE
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[50e244cc793d511b86adea24972f3a7264cae114] fb: rework locking to fix lock ordering on takeover
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-20:11:29 50e244cc793d511b86adea24972f3a7264cae114 compiling
307 real  2896 user  196 sys  1007.13% cpu 	i386-randconfig-x05-0601

2013-06-02-20:16:46 detecting boot state 3.8.0-rc6-bisect3-sound-00046-g50e244c	0.............................	27 SUCCESS
Bisecting: 1 revision left to test after this (roughly 1 step)
[054430e773c9a1e26f38e30156eff02dedfffc17] fbcon: fix locking harder
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-20:32:18 054430e773c9a1e26f38e30156eff02dedfffc17 compiling
305 real  2899 user  195 sys  1013.62% cpu 	i386-randconfig-x05-0601

2013-06-02-20:37:31 detecting boot state 3.8.0-rc6-bisect3-sound-00048-g054430e	0............................	1	10	23.............	27 SUCCESS
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[5845b81bdad374f98f809a658ec747d92c9595c4] Revert "Revert "console: implement lockdep support for console_lock""
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect

2013-06-02-21:00:33 5845b81bdad374f98f809a658ec747d92c9595c4 compiling
304 real  2875 user  196 sys  1010.54% cpu 	i386-randconfig-x05-0601

2013-06-02-21:05:47 detecting boot state 3.8.0-rc6-bisect3-sound-00049-g5845b81	0.................... TEST FAILURE
5845b81bdad374f98f809a658ec747d92c9595c4 is the first bad commit
commit 5845b81bdad374f98f809a658ec747d92c9595c4
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Feb 8 12:07:01 2013 +1000

    Revert "Revert "console: implement lockdep support for console_lock""
    
    This reverts commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf.
    
    Now that we have all the locking fixes in place, we can revert the
    revert. This re-enables lockdep tracking for the console lock,
    daee779718a319ff9f83e1ba3339334ac650bb22.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

:040000 040000 7d663ed86ffafdbdd37e422ae5dac84944479966 00f1d3c0f768fe5462a532f1cfcbc1c368024246 M	kernel
bisect run success

2013-06-02-21:16:20 054430e773c9a1e26f38e30156eff02dedfffc17 reuse /kernel/i386-randconfig-x05-0601/054430e773c9a1e26f38e30156eff02dedfffc17/vmlinuz-3.8.0-rc6-bisect3-sound-00048-g054430e

2013-06-02-21:16:20 detecting boot state 	0....................	8...	9	13	14...	80...............................	81 SUCCESS

2013-06-02-21:48:25 71919bac2803fc6834e178dd5935e7013fd78826 reuse /kernel/i386-randconfig-x05-0601/71919bac2803fc6834e178dd5935e7013fd78826/vmlinuz-3.10.0-rc3-00001-g71919ba

2013-06-02-21:48:26 detecting boot state 	0 TEST FAILURE
[detached HEAD 7c3628d] Revert "Revert "Revert "console: implement lockdep support for console_lock"""
 1 file changed, 9 deletions(-)

2013-06-02-21:48:58 7c3628da24b83741fe940c29bf9525a7d09b9b9e compiling

2013-06-02-21:55:19 detecting boot state 3.10.0-rc3-bisect3-sound-00002-g7c3628d	0....................	8...	9.	12.	13	41	51	62..........	65	75.............................	77....................................................................................................................................................................................................................................................................................................................................	81 SUCCESS

========= linux-next =========
Fetching next

2013-06-03-01:15:44 14d35d014bd806884801d32259ecdaf857ef276b compiling

2013-06-03-01:28:42 detecting boot state 3.10.0-rc3-bisect3-sound-next-20130531-03708-g14d35d0	0.	2.................. TEST FAILURE

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

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
# CONFIG_SMP is not set
CONFIG_GOLDFISH=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_GOLDFISH=y
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
# CONFIG_NET_IP_TUNNEL is not set
# CONFIG_NET_IPGRE is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
# CONFIG_IP_VS_LBLC is not set
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_FILTER=y
# CONFIG_IP6_NF_TARGET_REJECT is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
# CONFIG_BRIDGE_EBT_IP6 is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
# CONFIG_BRIDGE_EBT_LOG is not set
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
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
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
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
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_TCM_QLA2XXX=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_CHELSIO_FCOE=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
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
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_MPIIX=y
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=y
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=y
CONFIG_SBP_TARGET=y
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
# CONFIG_ARCNET_COM20020_CS is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=y
CONFIG_PCMCIA_NMCLAN=y
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=y
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
# CONFIG_ULI526X is not set
CONFIG_PCMCIA_XIRCOM=y
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851=y
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R8169 is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
# CONFIG_NIU is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_MICREL_KS8995MA=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
# CONFIG_PPTP is not set
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
# CONFIG_USB_USBNET is not set
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_DUMMYLL=y
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
# CONFIG_GIGASET_M101 is not set
# CONFIG_GIGASET_DEBUG is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
CONFIG_MISDN_HFCUSB=y
# CONFIG_MISDN_AVMFRITZ is not set
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y

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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_SAMSUNG=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_UCB1400=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_W90X900=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MRST_MAX3110=y
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_ATMEL=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_EXYNOS=y
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_UCB1400_CORE=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS6586X is not set
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
# CONFIG_CYPRESS_FIRMWARE is not set
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
CONFIG_VIDEO_ADV7183=y
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=y
CONFIG_VIDEO_AS3645A=y

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_SI21XX=y
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=y
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
# CONFIG_DVB_HD29L2 is not set
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
# CONFIG_DVB_LNBP22 is not set
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=y
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
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
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_PANDORA is not set
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
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
CONFIG_FONT_PEARL_8x8=y
# CONFIG_FONT_ACORN_8x8 is not set
CONFIG_FONT_MINI_4x6=y
# CONFIG_FONT_SUN8x16 is not set
CONFIG_FONT_SUN12x22=y
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
CONFIG_SND_AW2=y
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=y
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=y
# CONFIG_SND_GINA20 is not set
CONFIG_SND_LAYLA20=y
# CONFIG_SND_DARLA24 is not set
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
CONFIG_SND_INDIGO=y
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
CONFIG_SND_INDIGODJX=y
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
CONFIG_SND_ENS1370=y
CONFIG_SND_ENS1371=y
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_HDMI=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SIS7019=y
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
CONFIG_SND_SPI=y
CONFIG_SND_AT73C213=y
CONFIG_SND_AT73C213_TARGET_BITRATE=48000
# CONFIG_SND_USB is not set
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_DESIGNWARE_I2S=y
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=y
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
CONFIG_SOUND_KAHLUA=y
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_HCD_DEBUGGING=y
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_PXAV3=y
# CONFIG_MMC_SDHCI_PXAV2 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_GOLDFISH is not set
CONFIG_MMC_SDRICOH_CS=y
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MMC_REALTEK_PCI is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_ATMEL_PWM=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_RENESAS_TPU=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_PCF50633 is not set
# CONFIG_RTC_DRV_AB3100 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_TC1100_WMI=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
CONFIG_PVPANIC=y
CONFIG_GOLDFISH_PIPE=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_DEBUG is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
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
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_KXSD9=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
# CONFIG_AD7923 is not set
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
# CONFIG_AD7476 is not set
CONFIG_AD7887=y
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5624R_SPI=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
CONFIG_AD5504=y
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
CONFIG_AD5686=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16136=y
CONFIG_ADXRS450=y
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_VCNL4000 is not set
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_RING_BUFFER_STARTUP_TEST=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_AUDIT is not set
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
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
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
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
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
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
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--G4iJoqBmSsgzjUCe--
