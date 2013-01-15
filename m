Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3AOAmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:42:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:4645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab3AOAm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:42:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,469,1355126400"; 
   d="log'?scan'208";a="273740789"
Date: Tue, 15 Jan 2013 08:42:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [sysfs_write_file] net/wireless/reg.c:144 suspicious
 rcu_dereference_protected() usage!
Message-ID: <20130115004213.GB5512@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

c492db370c17c428a0a58d3673294d4e99634b7d is the first bad commit

commit c492db370c17c428a0a58d3673294d4e99634b7d
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Dec 6 16:29:25 2012 +0100

    regulatory: use RCU to protect last_request

    This will allow making freq_reg_info() lock-free.

    Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

[   38.437215] 
[   38.437457] ===============================
[   38.438047] [ INFO: suspicious RCU usage. ]
[   38.438635] 3.8.0-rc1-00184-gfb97c3e #24 Not tainted
[   38.439333] -------------------------------
[   38.439938] /c/kernel-tests/src/i386/net/wireless/reg.c:144 suspicious rcu_dereference_protected() usage!
[   38.444094] 
[   38.444094] other info that might help us debug this:
[   38.444094] 
[   38.445209] 
[   38.445209] rcu_scheduler_active = 1, debug_locks = 0
[   38.446120] 2 locks held by udevadm/2386:
[   38.446684]  #0:  (&buffer->mutex#2){+.+.+.}, at: [<791038ec>] sysfs_write_file+0x29/0xeb
[   38.447962]  #1:  (s_active#10){++++.+}, at: [<7910395e>] sysfs_write_file+0x9b/0xeb
[   38.453032] 
[   38.453032] stack backtrace:
[   38.453649] Pid: 2386, comm: udevadm Not tainted 3.8.0-rc1-00184-gfb97c3e #24
[   38.454650] Call Trace:
[   38.455017]  [<7905f645>] lockdep_rcu_suspicious+0xe3/0xeb
[   38.455800]  [<7986010b>] get_last_request+0x43/0x4a
[   38.463378]  [<79860374>] reg_device_uevent+0x13/0x51
[   38.464199]  [<794c2984>] ? platform_uevent+0x2a/0x2e
[   38.464915]  [<794bfb7b>] dev_uevent+0x12d/0x135
[   38.465569]  [<793c1b80>] ? add_uevent_var+0x4a/0xa3
[   38.466270]  [<794bfa4e>] ? device_get_devnode+0xaf/0xaf
[   38.467024]  [<793c1d4d>] kobject_uevent_env+0x174/0x3f6
[   38.467772]  [<793c1b14>] ? kobject_action_type+0x43/0x65
[   38.472095]  [<793c1fd9>] kobject_uevent+0xa/0xd
[   38.472757]  [<794c02d0>] store_uevent+0x2a/0x45
[   38.473409]  [<794c02a6>] ? dev_err+0x2f/0x2f
[   38.474030]  [<794be9a5>] dev_attr_store+0x1d/0x29
[   38.474708]  [<79103974>] sysfs_write_file+0xb1/0xeb
[   38.475412]  [<791038c3>] ? sysfs_poll+0x7a/0x7a
[   38.483120]  [<790bfce3>] vfs_write+0x74/0xad
[   38.483744]  [<790bfdbe>] sys_write+0x3d/0x65
[   38.484473]  [<798ac02b>] sysenter_do_call+0x12/0x3c
[   39.172207] init: Failed to create pty - disabling logging for job
[   39.173336] init: Temporary process spawn error: No such file or directory

Thanks,
Fengguang

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-3449-2013-01-11-22-46-49-3.8.0-rc1-00184-gfb97c3e-24"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc1-00184-gfb97c3e (kbuild@lkp-mb01) (gcc version 4.7.1 (GCC) ) #24 PREEMPT Fri Jan 11 22:43:10 CST 2013
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [7808f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x02bbd000-0x02bfffff]
[    0.000000] cma: CMA: reserved 16 MiB at 0d400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128788(98%)
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
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 79dcec8c, node_mem_map 864bf280
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64769 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1d26840
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64769
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=nfc/for-wireless-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-01-11-22-45-50-nfc:for-wireless-next:fb97c3e-fb97c3e-i386-randconfig-m151-1-bay BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-m151/fb97c3e/vmlinuz-3.8.0-rc1-00184-gfb97c3e
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 188380k/262136k available (8883k kernel code, 73256k reserved, 5311k data, 484k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79ddd000 - 0x79e56000   ( 484 kB)
[    0.000000]       .data : 0x798ace70 - 0x79ddcd40   (5311 kB)
[    0.000000]       .text : 0x79000000 - 0x798ace70   (8883 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=84806000 soft=84808000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.556 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5985.11 BogoMIPS (lpj=11970224)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Mount-cache hash table entries: 512
[    0.008588] Initializing cgroup subsys debug
[    0.009206] Initializing cgroup subsys devices
[    0.009843] Initializing cgroup subsys freezer
[    0.010489] Initializing cgroup subsys blkio
[    0.011088] Initializing cgroup subsys perf_event
[    0.011758] Initializing cgroup subsys net_prio
[    0.012176] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012176] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012176] tlb_flushall_shift: 6
[    0.014084] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.018237] ACPI: Core revision 20121018
[    0.020518] ACPI: setting ELCR to 0200 (from 0c00)
[    0.021601] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.023421] ftrace: Allocated trace_printk buffers
[    0.039579] Testing tracer nop: PASSED
[    0.041789] devtmpfs: initialized
[    0.044293] Testing tracer function: PASSED
[    0.157622] Testing ftrace regs(no arch support): PASSED
[    0.188507] Testing tracer wakeup: ret = 0
[    0.292058] ftrace-test (12) used greatest stack depth: 7204 bytes left
[    0.320497] PASSED
[    0.339021] Testing tracer wakeup_rt: ret = 0
[    0.465799] PASSED
[    0.468536] NET: Registered protocol family 16
[    0.471257] ACPI: bus type pci registered
[    0.472109] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.473004] PCI: Using configuration type 1 for base access
[    0.480413] bio: create slab <bio-0> at 0
[    0.481499] ACPI: Added _OSI(Module Device)
[    0.482091] ACPI: Added _OSI(Processor Device)
[    0.482719] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.483381] ACPI: Added _OSI(Processor Aggregator Device)
[    0.485652] ACPI: EC: Look up EC in DSDT
[    0.490297] ACPI: Interpreter enabled
[    0.490824] ACPI: (supports S0 S5)
[    0.491355] ACPI: Using PIC for interrupt routing
[    0.499699] ACPI: No dock devices found.
[    0.500008] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.501370] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.502233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.504065] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.505250] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.506298] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.507344] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.508008] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.509151] PCI: root bus 00: using default resources
[    0.509884] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.512143] PCI host bridge to bus 0000:00
[    0.512730] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.513497] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.514357] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.515324] pci_bus 0000:00: scanning bus
[    0.516138] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.516994] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0xe
[    0.518270] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.519687] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.521745] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.523307] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.524029] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x3a
[    0.525428] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x139
[    0.526282] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.528020] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.529066] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x14
[    0.530074] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.532477] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.536067] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.541326] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.542464] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.544337] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.545781] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.549507] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.550562] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.551803] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.554264] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.556676] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.558041] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.562162] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.563677] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.564611] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.569479] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.570984] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.572326] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.576591] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.578095] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.579458] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.583280] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.584672] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.586030] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.590676] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.592326] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.593682] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.597755] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.598948] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.602118] pci_bus 0000:00: fixups for bus
[    0.602714] pci_bus 0000:00: bus scan returning with max=00
[    0.603502] pci_bus 0000:00: on NUMA node 0
[    0.604187] ACPI: Invalid Power Resource to register!
[    0.604906] ACPI: Invalid Power Resource to register!
[    0.605635] ACPI: Invalid Power Resource to register!
[    0.606356] ACPI: Invalid Power Resource to register!
[    0.607084] ACPI: Invalid Power Resource to register!
[    0.608018] ACPI: Invalid Power Resource to register!
[    0.608744] ACPI: Invalid Power Resource to register!
[    0.609468] ACPI: Invalid Power Resource to register!
[    0.610187] ACPI: Invalid Power Resource to register!
[    0.610912] ACPI: Invalid Power Resource to register!
[    0.611635] ACPI: Invalid Power Resource to register!
[    0.612018] ACPI: Invalid Power Resource to register!
[    0.612736] ACPI: Invalid Power Resource to register!
[    0.613457] ACPI: Invalid Power Resource to register!
[    0.614301] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.626922] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.627929] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.628367] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.629366] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.630363] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.632280] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.633416] vgaarb: loaded
[    0.633805] vgaarb: bridge control possible 0000:00:02.0
[    0.634811] tps65010: version 2 May 2005
[    0.664047] tps65010: no chip?
[    0.665037] SCSI subsystem initialized
[    0.665724] Linux video capture interface: v2.00
[    0.666585] PCI: Using ACPI for IRQ routing
[    0.667175] PCI: pci_cache_line_size set to 64 bytes
[    0.667917] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.668010] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.669065] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.670206] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.672008] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    0.673189] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.674440] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    0.676022] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    0.677275] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    0.678443] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf0000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    0.679706] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    0.680008] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    0.681271] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    0.682432] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    0.684021] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    0.685181] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf7000-0xfebf7fff flags 0x40200] (d=0, p=0)
[    0.686443] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    0.688008] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf8000-0xfebf8fff flags 0x40200] (d=0, p=0)
[    0.689271] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    0.690421] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf9000-0xfebf9fff flags 0x40200] (d=0, p=0)
[    0.692021] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    0.693180] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebfa000-0xfebfafff flags 0x40200] (d=0, p=0)
[    0.694445] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebfb000-0xfebfb00f flags 0x40200] (d=0, p=0)
[    0.696102] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.696948] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.698169] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    0.699273] NET: Registered protocol family 23
[    0.699931] NET: Registered protocol family 8
[    0.700007] NET: Registered protocol family 20
[    0.700934] cfg80211: Calling CRDA to update world regulatory domain
[    0.702018] nfc: nfc_init: NFC Core ver 0.1
[    0.702679] NET: Registered protocol family 39
[    0.704705] Switching to clocksource kvm-clock
[    0.835191] FS-Cache: Loaded
[    0.835695] CacheFiles: Loaded
[    0.836255] pnp: PnP ACPI init
[    0.836718] ACPI: bus type pnp registered
[    0.837441] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.838483] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.839465] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.840514] pnp 00:03: [dma 2]
[    0.841035] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.842108] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.843113] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.844342] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.845441] pnp: PnP ACPI: found 7 devices
[    0.846018] ACPI: ACPI bus type pnp unregistered
[    0.882301] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.883088] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.883968] NET: Registered protocol family 1
[    0.884723] pci 0000:00:00.0: calling quirk_natoma+0x0/0x30
[    0.885502] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.886330] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x6d
[    0.887227] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.888148] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x33
[    0.889008] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.889912] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xa2
[    0.890741] pci 0000:00:02.0: Boot video device
[    0.891393] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x14f
[    0.892476] PCI: CLS 0 bytes, default 64
[    0.893312] Unpacking initramfs...
[    3.360980] debug: unmapping init [mem 0x8673f000-0x87feffff]
[    3.416976] DMA-API: preallocated 32768 debug entries
[    3.417710] DMA-API: debugging enabled by kernel config
[    3.423396] cryptomgr_test (19) used greatest stack depth: 7012 bytes left
[    3.436650] cryptomgr_test (25) used greatest stack depth: 6232 bytes left
[    3.438131] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    3.439432] NatSemi SCx200 Driver
[    3.442326] Initializing RT-Tester: OK
[    3.468126] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.471694] VFS: Disk quotas dquot_6.5.2
[    3.472440] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.474482] NTFS driver 2.1.30 [Flags: R/W].
[    3.475206] fuse init (API version 7.20)
[    3.476213] JFS: nTxBlock = 1599, nTxLock = 12797
[    3.485628] SGI XFS with ACLs, security attributes, realtime, debug enabled
[    3.487463] NILFS version 2 loaded
[    3.487952] OCFS2 1.5.0
[    3.488704] ocfs2 stack glue: unable to register sysctl
[    3.489449] OCFS2 DLMFS 1.5.0
[    3.490027] OCFS2 User DLM kernel interface loaded
[    3.490699] OCFS2 Node Manager 1.5.0
[    3.492179] Btrfs loaded
[    3.492561] msgmni has been set to 399
[    3.493399] alg: No test for cipher_null (cipher_null-generic)
[    3.494394] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    3.495328] alg: No test for compress_null (compress_null-generic)
[    3.496462] alg: No test for digest_null (digest_null-generic)
[    3.526586] alg: No test for stdrng (krng)
[    3.528593] Key type asymmetric registered
[    3.529214] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    3.530372] io scheduler noop registered (default)
[    3.532793] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.533600] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.534698] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.535464] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.536498] i2c-core: driver [adp8870_bl] using legacy suspend method
[    3.537396] i2c-core: driver [adp8870_bl] using legacy resume method
[    3.538484] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.539578] vmlfb: initializing
[    3.540164] Could not find Carillo Ranch MCH device.
[    3.541677] uvesafb: failed to execute /sbin/v86d
[    3.542348] uvesafb: make sure that the v86d helper is installed and executable
[    3.543366] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    3.544403] uvesafb: vbe_init() failed with -22
[    3.545051] uvesafb: probe of uvesafb.0 failed with error -22
[    3.546036] ipmi message handler version 39.2
[    3.546669] IPMI System Interface driver.
[    3.547329] ipmi_si: Adding default-specified kcs state machine
[    3.548325] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    3.549714] ipmi_si: Interface detection failed
[    3.550363] ipmi_si: Adding default-specified smic state machine
[    3.551226] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    3.552722] ipmi_si: Interface detection failed
[    3.553370] ipmi_si: Adding default-specified bt state machine
[    3.554219] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    3.555600] ipmi_si: Interface detection failed
[    3.556397] ipmi_si: Unable to find any System Interface(s)
[    3.557321] pci_bus 0000:00: dev 01, created physical slot 1
[    3.558149] pci_bus 0000:00: dev 02, created physical slot 2
[    3.558957] pci_bus 0000:00: dev 03, created physical slot 3
[    3.559820] pci_bus 0000:00: dev 04, created physical slot 4
[    3.560726] pci_bus 0000:00: dev 05, created physical slot 5
[    3.561541] pci_bus 0000:00: dev 06, created physical slot 6
[    3.562355] pci_bus 0000:00: dev 07, created physical slot 7
[    3.563171] pci_bus 0000:00: dev 08, created physical slot 8
[    3.563982] pci_bus 0000:00: dev 09, created physical slot 9
[    3.564898] pci_bus 0000:00: dev 0a, created physical slot 10
[    3.565729] pci_bus 0000:00: dev 0b, created physical slot 11
[    3.566558] pci_bus 0000:00: dev 0c, created physical slot 12
[    3.567385] pci_bus 0000:00: dev 0d, created physical slot 13
[    3.568315] pci_bus 0000:00: dev 0e, created physical slot 14
[    3.569139] pci_bus 0000:00: dev 0f, created physical slot 15
[    3.569957] pci_bus 0000:00: dev 10, created physical slot 16
[    3.570823] pci_bus 0000:00: dev 11, created physical slot 17
[    3.571647] pci_bus 0000:00: dev 12, created physical slot 18
[    3.572559] pci_bus 0000:00: dev 13, created physical slot 19
[    3.573383] pci_bus 0000:00: dev 14, created physical slot 20
[    3.574207] pci_bus 0000:00: dev 15, created physical slot 21
[    3.575036] pci_bus 0000:00: dev 16, created physical slot 22
[    3.575859] pci_bus 0000:00: dev 17, created physical slot 23
[    3.576771] pci_bus 0000:00: dev 18, created physical slot 24
[    3.577597] pci_bus 0000:00: dev 19, created physical slot 25
[    3.578420] pci_bus 0000:00: dev 1a, created physical slot 26
[    3.579244] pci_bus 0000:00: dev 1b, created physical slot 27
[    3.580162] pci_bus 0000:00: dev 1c, created physical slot 28
[    3.580982] pci_bus 0000:00: dev 1d, created physical slot 29
[    3.581852] pci_bus 0000:00: dev 1e, created physical slot 30
[    3.582678] pci_bus 0000:00: dev 1f, created physical slot 31
[    3.585513] isapnp: Scanning for PnP cards...
[    3.958305] isapnp: No Plug & Play device found
[    3.959329] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    3.960207] PCI: setting IRQ 10 as level-triggered
[    3.960900] virtio-pci 0000:00:05.0: enabling bus mastering
[    3.961701] virtio-pci 0000:00:05.0: setting latency timer to 64
[    3.963162] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    3.963976] virtio-pci 0000:00:06.0: enabling bus mastering
[    3.964872] virtio-pci 0000:00:06.0: setting latency timer to 64
[    3.966235] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    3.967045] PCI: setting IRQ 11 as level-triggered
[    3.967735] virtio-pci 0000:00:07.0: enabling bus mastering
[    3.968629] virtio-pci 0000:00:07.0: setting latency timer to 64
[    3.969981] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    3.970805] virtio-pci 0000:00:08.0: enabling bus mastering
[    3.971604] virtio-pci 0000:00:08.0: setting latency timer to 64
[    3.972878] virtio-pci 0000:00:09.0: enabling bus mastering
[    3.973681] virtio-pci 0000:00:09.0: setting latency timer to 64
[    3.974862] virtio-pci 0000:00:0a.0: enabling bus mastering
[    3.975663] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    3.976940] HDLC line discipline maxframe=4096
[    3.977576] N_HDLC line discipline registered.
[    3.978207] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.978967] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.006199] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.008701] Cyclades driver 2.6
[    4.024143] MOXA Intellio family driver version 6.0k
[    4.024954] SyncLink GT
[    4.025319] SyncLink GT, tty major#247
[    4.025869] SyncLink GT no devices found
[    4.026427] SyncLink serial driver $Revision: 4.38 $
[    4.036975] SyncLink serial driver $Revision: 4.38 $, tty major#246
[    4.038175] DoubleTalk PC - not found
[    4.038712] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    4.039723] ac.o: No PCI boards found.
[    4.040385] ac.o: For an ISA board you must supply memory and irq parameters.
[    4.041383] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.042308] Real Time Clock Driver v1.12b
[    4.042882] toshiba: not a supported Toshiba laptop
[    4.043694] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    4.044720] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.045902] lkdtm: No crash points registered, enable through debugfs
[    4.046849] Phantom Linux Driver, version n0.9.8, init OK
[    4.047671] i2c-core: driver [apds9802als] using legacy suspend method
[    4.048679] i2c-core: driver [apds9802als] using legacy resume method
[    4.049594] i2c-core: driver [tsl2550] using legacy suspend method
[    4.050466] i2c-core: driver [tsl2550] using legacy resume method
[    4.051397] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    4.052560] i2c-core: driver [fsa9480] using legacy suspend method
[    4.053424] i2c-core: driver [fsa9480] using legacy resume method
[    4.054486] Driver for timberdale has been successfully registered.
[    4.057388] Loading iSCSI transport class v2.0-870.
[    4.058387] hp_sw: device handler registered
[    4.059400] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.060277] Detecting Adaptec I2O RAID controllers...
[    4.061085] Adaptec aacraid driver 1.2-0[29801]-ms
[    4.061848] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.062994] NCR53c406a: no available ports found
[    4.063640] qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options
[    4.065172] iscsi: registered transport (qla4xxx)
[    4.065893] QLogic iSCSI HBA Driver
[    4.066391] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
[    4.096094] Failed initialization of WD-7000 SCSI card!
[    4.096825] DC390: clustering now enabled by default. If you get problems load
[    4.097828]        with "disable_clustering=1" and report to maintainers
[    4.098784] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    4.100100] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    4.101092] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
[    4.102035] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.103020] 3ware Storage Controller device driver for Linux v1.26.02.003.
[    4.104000] nsp32: loading...
[    4.104538] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.105310] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
[    4.106378] iscsi: registered transport (bnx2i)
[    4.107148] VMware PVSCSI driver - version 1.0.2.0-k
[    4.107915] SCSI Media Changer driver v0.25 
[    4.108914] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.114980] tun: Universal TUN/TAP device driver, 1.6
[    4.115695] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.120113] arcnet loaded.
[    4.120503] arcnet: cap mode (`c') encapsulation support loaded.
[    4.121344] arcnet: COM20020 ISA support (by David Woodhouse et al.)
[    4.122231]  arc%d: No autoprobe (yet) for IO mapped cards; you must specify the base address!
[    4.123420] arcnet: COM20020 PCI support
[    4.124004] slcan: serial line CAN interface driver
[    4.124777] slcan: 10 dynamic interface channels.
[    4.125446] CAN device driver interface
[    4.125990] sja1000 CAN netdevice driver
[    4.126824] cc770: CAN netdevice driver
[    4.127524] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[    4.128808] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.00-0 (2012/09/27)
[    4.130443] Brocade 10G Ethernet driver - version: 3.1.2.1
[    4.131300] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    4.132283] sky2: driver version 1.30
[    4.133839] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    4.134912] hv_vmbus: registering driver hv_netvsc
[    4.136030] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.138156] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.139035] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.213411] mousedev: PS/2 mouse device common for all mice
[    4.215037] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.216522] evbug: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    4.218495] mk712: device not present
[    4.219352] I2O subsystem v1.325
[    4.219811] i2o: max drivers = 8
[    4.220614] I2O Bus Adapter OSM v1.317
[    4.221161] I2O SCSI Peripheral OSM v1.316
[    4.221750] I2O ProcFS OSM v1.316
[    4.222554] i2c-parport-light: adapter type unspecified
[    4.223485] isa i2c-pca-isa.0: Please specify I/O base
[    4.224454] i2c-core: driver [adv7180] using legacy suspend method
[    4.225322] i2c-core: driver [adv7180] using legacy resume method
[    4.226609] IR NEC protocol handler initialized
[    4.227253] IR RC5(x) protocol handler initialized
[    4.227926] IR JVC protocol handler initialized
[    4.228657] IR Sony protocol handler initialized
[    4.229315] IR RC5 (streamzap) protocol handler initialized
[    4.230102] Driver for 1-wire Dallas network protocol.
[    4.230954] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    4.232337] i2c-core: driver [sbs-battery] using legacy suspend method
[    4.233262] i2c-core: driver [max17040] using legacy suspend method
[    4.234137] i2c-core: driver [max17040] using legacy resume method
[    4.236171] pc87360: PC8736x not detected, module not inserted
[    4.237401] acquirewdt: WDT driver for Acquire single board computer initialising
[    4.238500] acquirewdt: I/O address 0x0043 already in use
[    4.239263] acquirewdt: probe of acquirewdt failed with error -5
[    4.240206] advantechwdt: WDT driver for Advantech single board computer initialising
[    4.241512] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    4.242388] ib700wdt: WDT driver for IB700 single board computer initialising
[    4.243434] ib700wdt: START method I/O 443 is not available
[    4.244315] ib700wdt: probe of ib700wdt failed with error -5
[    4.245115] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    4.246216] wafer5823wdt: I/O address 0x0443 already in use
[    4.247020] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    4.248133] i6300esb: cannot register miscdev on minor=130 (err=-16)
[    4.249083] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16
[    4.250018] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.250968] sc1200wdt: build 20020303
[    4.251509] sc1200wdt: io parameter must be specified
[    4.252328] pc87413_wdt: Version 1.1 at io 0x2E
[    4.252974] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[    4.253904] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    4.254801] sbc60xxwdt: I/O address 0x0443 already in use
[    4.255558] sbc8360: failed to register misc device
[    4.256427] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[    4.258577] smsc37b787_wdt: Unable to register miscdev on minor 130
[    4.259454] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[    4.260885] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[    4.261938] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[    4.262867] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    4.263737] w83697hf_wdt: watchdog not found at address 0x2e
[    4.264629] w83697hf_wdt: No W83697HF/HG could be found
[    4.265365] w83877f_wdt: I/O address 0x0443 already in use
[    4.266135] w83977f_wdt: driver v1.00
[    4.266654] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    4.267576] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    4.268522] machzwd: no ZF-Logic found
[    4.269085] cpuidle: using governor ladder
[    4.270265] ledtrig-cpu: registered to indicate activity on CPUs
[    4.271288] EFI Variables Facility v0.08 2004-May-17
[    4.272246] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.273300] No iBFT detected.
[    4.273745] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[    4.275010] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
[    4.276729] fujitsu_laptop: driver 0.6.0 successfully loaded
[    4.277529] fujitsu_tablet: Unknown (using defaults)
[    4.278445] hv_utils: Registering HyperV Utility Driver
[    4.279179] hv_vmbus: registering driver hv_util
[    4.279823] hv_vmbus: registering driver hv_balloon
[    4.280882] oprofile: using timer interrupt.
[    4.281538] NET: Registered protocol family 17
[    4.282259] Ebtables v2.0 registered
[    4.283343] NET: Registered protocol family 4
[    4.283996] NET: Registered protocol family 9
[    4.284713] X.25 for Linux Version 0.2
[    4.285259] can: controller area network core (rev 20120528 abi 9)
[    4.286163] NET: Registered protocol family 29
[    4.286796] can: raw protocol (rev 20120528)
[    4.287419] can: netlink gateway (rev 20101209)
[    4.288536] lec:lane_module_init: lec.c: initialized
[    4.289239] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.290607] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[    4.291561] NET: Registered protocol family 12
[    4.292368] Key type dns_resolver registered
[    4.294076] registered taskstats version 1
[    4.294657] Running tests on trace events:
[    4.295239] Testing event rdev_suspend: OK
[    4.304341] Testing event rdev_return_int: OK
[    4.316604] Testing event rdev_scan: OK
[    4.328331] Testing event rdev_resume: OK
[    4.340301] Testing event rdev_return_void: OK
[    4.352378] Testing event rdev_get_ringparam: OK
[    4.364301] Testing event rdev_get_antenna: OK
[    4.376301] Testing event rdev_rfkill_poll: OK
[    4.388300] Testing event rdev_set_wakeup: OK
[    4.400326] Testing event rdev_add_virtual_intf: OK
[    4.412290] Testing event rdev_return_wdev: [    4.416132] tsc: Refined TSC clocksource calibration: 2992.494 MHz
OK
[    4.424289] Testing event rdev_del_virtual_intf: OK
[    4.436290] Testing event rdev_change_virtual_intf: OK
[    4.448288] Testing event rdev_add_key: OK
[    4.460315] Testing event rdev_get_key: OK
[    4.472287] Testing event rdev_del_key: OK
[    4.484347] Testing event rdev_set_default_key: OK
[    4.496314] Testing event rdev_set_default_mgmt_key: OK
[    4.508318] Testing event rdev_start_ap: OK
[    4.520288] Testing event rdev_change_beacon: OK
[    4.532288] Testing event rdev_stop_ap: OK
[    4.544316] Testing event rdev_get_et_stats: OK
[    4.556285] Testing event rdev_sched_scan_stop: OK
[    4.568287] Testing event rdev_set_rekey_data: OK
[    4.580287] Testing event rdev_get_mesh_config: OK
[    4.592287] Testing event rdev_leave_mesh: OK
[    4.604286] Testing event rdev_leave_ibss: OK
[    4.616286] Testing event rdev_flush_pmksa: OK
[    4.628288] Testing event rdev_add_station: OK
[    4.640287] Testing event rdev_change_station: OK
[    4.652293] Testing event rdev_del_station: OK
[    4.664286] Testing event rdev_get_station: OK
[    4.676287] Testing event rdev_del_mpath: OK
[    4.688286] Testing event rdev_set_wds_peer: OK
[    4.700302] Testing event rdev_dump_station: OK
[    4.712286] Testing event rdev_return_int_station_info: OK
[    4.724288] Testing event rdev_add_mpath: OK
[    4.736287] Testing event rdev_change_mpath: OK
[    4.748285] Testing event rdev_get_mpath: OK
[    4.760287] Testing event rdev_dump_mpath: OK
[    4.772287] Testing event rdev_return_int_mpath_info: OK
[    4.784286] Testing event rdev_return_int_mesh_config: OK
[    4.796287] Testing event rdev_update_mesh_config: OK
[    4.808286] Testing event rdev_join_mesh: OK
[    4.820288] Testing event rdev_change_bss: OK
[    4.832286] Testing event rdev_set_txq_params: OK
[    4.844294] Testing event rdev_libertas_set_mesh_channel: OK
[    4.856292] Testing event rdev_set_monitor_channel: OK
[    4.868289] Testing event rdev_auth: OK
[    4.880286] Testing event rdev_assoc: OK
[    4.892286] Testing event rdev_deauth: OK
[    4.904287] Testing event rdev_disassoc: OK
[    4.916326] Testing event rdev_mgmt_tx_cancel_wait: OK
[    4.928288] Testing event rdev_set_power_mgmt: OK
[    4.940317] Testing event rdev_connect: OK
[    4.952287] Testing event rdev_set_cqm_rssi_config: OK
[    4.964288] Testing event rdev_set_cqm_txe_config: OK
[    4.976286] Testing event rdev_disconnect: OK
[    4.988288] Testing event rdev_join_ibss: OK
[    5.000287] Testing event rdev_set_wiphy_params: OK
[    5.012288] Testing event rdev_get_tx_power: OK
[    5.024256] Testing event rdev_set_tx_power: OK
[    5.036287] Testing event rdev_return_int_int: OK
[    5.048257] Testing event rdev_set_bitrate_mask: OK
[    5.060289] Testing event rdev_mgmt_frame_register: OK
[    5.072291] Testing event rdev_return_int_tx_rx: OK
[    5.084288] Testing event rdev_return_void_tx_rx: OK
[    5.096286] Testing event rdev_set_ringparam: OK
[    5.108285] Testing event rdev_set_antenna: OK
[    5.120286] Testing event rdev_sched_scan_start: OK
[    5.132286] Testing event rdev_tdls_mgmt: OK
[    5.144287] Testing event rdev_dump_survey: OK
[    5.156293] Testing event rdev_return_int_survey_info: OK
[    5.168289] Testing event rdev_tdls_oper: OK
[    5.180287] Testing event rdev_probe_client: OK
[    5.192286] Testing event rdev_set_pmksa: OK
[    5.204258] Testing event rdev_del_pmksa: OK
[    5.216256] Testing event rdev_remain_on_channel: OK
[    5.228288] Testing event rdev_return_int_cookie: OK
[    5.240313] Testing event rdev_cancel_remain_on_channel: OK
[    5.252286] Testing event rdev_mgmt_tx: OK
[    5.264286] Testing event rdev_set_noack_map: OK
[    5.276288] Testing event rdev_get_et_sset_count: OK
[    5.288309] Testing event rdev_get_et_strings: OK
[    5.300291] Testing event rdev_get_channel: OK
[    5.312287] Testing event rdev_return_chandef: OK
[    5.324288] Testing event rdev_start_p2p_device: OK
[    5.336288] Testing event rdev_stop_p2p_device: OK
[    5.348314] Testing event cfg80211_return_bool: OK
[    5.360346] Testing event cfg80211_notify_new_peer_candidate: OK
[    5.372288] Testing event cfg80211_send_rx_auth: OK
[    5.384291] Testing event cfg80211_send_rx_assoc: OK
[    5.396289] Testing event __cfg80211_send_deauth: OK
[    5.408287] Testing event __cfg80211_send_disassoc: OK
[    5.420289] Testing event cfg80211_send_unprot_deauth: OK
[    5.432286] Testing event cfg80211_send_unprot_disassoc: OK
[    5.444286] Testing event cfg80211_send_auth_timeout: OK
[    5.456292] Testing event cfg80211_send_assoc_timeout: OK
[    5.468286] Testing event cfg80211_michael_mic_failure: OK
[    5.480286] Testing event cfg80211_ready_on_channel: OK
[    5.492285] Testing event cfg80211_ready_on_channel_expired: OK
[    5.504287] Testing event cfg80211_new_sta: OK
[    5.516288] Testing event cfg80211_del_sta: OK
[    5.528286] Testing event cfg80211_rx_mgmt: OK
[    5.540288] Testing event cfg80211_mgmt_tx_status: OK
[    5.552286] Testing event cfg80211_cqm_rssi_notify: OK
[    5.564288] Testing event cfg80211_reg_can_beacon: OK
[    5.576286] Testing event cfg80211_ch_switch_notify: OK
[    5.588287] Testing event cfg80211_ibss_joined: OK
[    5.600286] Testing event cfg80211_rx_spurious_frame: OK
[    5.612288] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[    5.624287] Testing event cfg80211_probe_status: OK
[    5.636288] Testing event cfg80211_cqm_pktloss_notify: OK
[    5.648286] Testing event cfg80211_gtk_rekey_notify: OK
[    5.660294] Testing event cfg80211_pmksa_candidate_notify: OK
[    5.672288] Testing event cfg80211_report_obss_beacon: OK
[    5.684287] Testing event cfg80211_tdls_oper_request: OK
[    5.696286] Testing event cfg80211_scan_done: OK
[    5.708288] Testing event cfg80211_sched_scan_results: OK
[    5.720287] Testing event cfg80211_sched_scan_stopped: OK
[    5.732288] Testing event cfg80211_get_bss: OK
[    5.744286] Testing event cfg80211_inform_bss_frame: OK
[    5.756287] Testing event cfg80211_return_bss: OK
[    5.768286] Testing event cfg80211_return_uint: OK
[    5.780258] Testing event cfg80211_return_u32: OK
[    5.792256] Testing event kfree_skb: OK
[    5.804315] Testing event consume_skb: OK
[    5.816286] Testing event skb_copy_datagram_iovec: OK
[    5.828289] Testing event net_dev_xmit: OK
[    5.840290] Testing event net_dev_queue: OK
[    5.852289] Testing event netif_receive_skb: OK
[    5.864288] Testing event netif_rx: OK
[    5.876293] Testing event napi_poll: OK
[    5.888313] Testing event sock_rcvqueue_full: OK
[    5.900288] Testing event sock_exceed_buf_limit: OK
[    5.912287] Testing event udp_fail_queue_rcv_skb: OK
[    5.924259] Testing event scsi_dispatch_cmd_start: OK
[    5.936287] Testing event scsi_dispatch_cmd_error: OK
[    5.948288] Testing event scsi_dispatch_cmd_done: OK
[    5.960287] Testing event scsi_dispatch_cmd_timeout: OK
[    5.972287] Testing event scsi_eh_wakeup: OK
[    5.984288] Testing event regmap_reg_write: OK
[    5.996288] Testing event regmap_reg_read: OK
[    6.008286] Testing event regmap_reg_read_cache: OK
[    6.020288] Testing event regmap_hw_read_start: OK
[    6.032287] Testing event regmap_hw_read_done: OK
[    6.044287] Testing event regmap_hw_write_start: OK
[    6.056287] Testing event regmap_hw_write_done: OK
[    6.068288] Testing event regcache_sync: OK
[    6.080296] Testing event regmap_cache_only: OK
[    6.092287] Testing event regmap_cache_bypass: OK
[    6.104287] Testing event mix_pool_bytes: OK
[    6.116291] Testing event mix_pool_bytes_nolock: OK
[    6.128287] Testing event credit_entropy_bits: OK
[    6.140288] Testing event get_random_bytes: OK
[    6.152287] Testing event extract_entropy: OK
[    6.164289] Testing event extract_entropy_user: OK
[    6.176287] Testing event gpio_direction: OK
[    6.188294] Testing event gpio_value: OK
[    6.200287] Testing event block_rq_abort: OK
[    6.212289] Testing event block_rq_requeue: OK
[    6.224286] Testing event block_rq_complete: OK
[    6.236288] Testing event block_rq_insert: OK
[    6.248287] Testing event block_rq_issue: OK
[    6.260288] Testing event block_bio_bounce: OK
[    6.272287] Testing event block_bio_complete: OK
[    6.284258] Testing event block_bio_backmerge: OK
[    6.296298] Testing event block_bio_frontmerge: OK
[    6.308288] Testing event block_bio_queue: OK
[    6.320287] Testing event block_getrq: OK
[    6.332288] Testing event block_sleeprq: OK
[    6.344286] Testing event block_plug: OK
[    6.356288] Testing event block_unplug: OK
[    6.368287] Testing event block_split: OK
[    6.380288] Testing event block_bio_remap: OK
[    6.392287] Testing event block_rq_remap: OK
[    6.404259] Testing event btrfs_transaction_commit: OK
[    6.416290] Testing event btrfs_inode_new: OK
[    6.428288] Testing event btrfs_inode_request: OK
[    6.440288] Testing event btrfs_inode_evict: OK
[    6.452288] Testing event btrfs_get_extent: OK
[    6.464286] Testing event btrfs_ordered_extent_add: OK
[    6.476287] Testing event btrfs_ordered_extent_remove: OK
[    6.488287] Testing event btrfs_ordered_extent_start: OK
[    6.500287] Testing event btrfs_ordered_extent_put: OK
[    6.512296] Testing event __extent_writepage: OK
[    6.524288] Testing event btrfs_writepage_end_io_hook: OK
[    6.536287] Testing event btrfs_sync_file: OK
[    6.548288] Testing event btrfs_sync_fs: OK
[    6.560286] Testing event btrfs_delayed_tree_ref: OK
[    6.572287] Testing event btrfs_delayed_data_ref: OK
[    6.584286] Testing event btrfs_delayed_ref_head: OK
[    6.596288] Testing event btrfs_chunk_alloc: OK
[    6.608286] Testing event btrfs_chunk_free: OK
[    6.620287] Testing event btrfs_cow_block: OK
[    6.632287] Testing event btrfs_space_reservation: OK
[    6.644366] Testing event btrfs_reserved_extent_alloc: OK
[    6.656287] Testing event btrfs_reserved_extent_free: OK
[    6.668287] Testing event find_free_extent: OK
[    6.680292] Testing event btrfs_reserve_extent: OK
[    6.692288] Testing event btrfs_reserve_extent_cluster: OK
[    6.704287] Testing event btrfs_find_cluster: OK
[    6.716292] Testing event btrfs_failed_cluster_setup: OK
[    6.728287] Testing event btrfs_setup_cluster: OK
[    6.740288] Testing event alloc_extent_state: OK
[    6.752286] Testing event free_extent_state: OK
[    6.764288] Testing event ocfs2_adjust_rightmost_branch: OK
[    6.776286] Testing event ocfs2_rotate_tree_right: OK
[    6.788288] Testing event ocfs2_append_rec_to_path: OK
[    6.800287] Testing event ocfs2_insert_extent_start: OK
[    6.812287] Testing event ocfs2_add_clusters_in_btree: OK
[    6.824287] Testing event ocfs2_num_free_extents: OK
[    6.836287] Testing event ocfs2_complete_edge_insert: OK
[    6.848288] Testing event ocfs2_grow_tree: OK
[    6.860288] Testing event ocfs2_rotate_subtree: OK
[    6.872287] Testing event ocfs2_insert_extent: OK
[    6.884293] Testing event ocfs2_split_extent: OK
[    6.896287] Testing event ocfs2_remove_extent: OK
[    6.908287] Testing event ocfs2_commit_truncate: OK
[    6.920288] Testing event ocfs2_validate_extent_block: OK
[    6.932288] Testing event ocfs2_rotate_leaf: OK
[    6.944287] Testing event ocfs2_add_clusters_in_btree_ret: OK
[    6.956294] Testing event ocfs2_mark_extent_written: OK
[    6.968287] Testing event ocfs2_truncate_log_append: OK
[    6.980287] Testing event ocfs2_replay_truncate_records: OK
[    6.992286] Testing event ocfs2_flush_truncate_log: OK
[    7.004287] Testing event ocfs2_begin_truncate_log_recovery: OK
[    7.016287] Testing event ocfs2_truncate_log_recovery_num: OK
[    7.028287] Testing event ocfs2_complete_truncate_log_recovery: OK
[    7.040286] Testing event ocfs2_free_cached_blocks: OK
[    7.052287] Testing event ocfs2_cache_cluster_dealloc: OK
[    7.064287] Testing event ocfs2_run_deallocs: OK
[    7.076287] Testing event ocfs2_cache_block_dealloc: OK
[    7.088292] Testing event ocfs2_trim_extent: OK
[    7.100287] Testing event ocfs2_trim_group: OK
[    7.112286] Testing event ocfs2_trim_fs: OK
[    7.124287] Testing event ocfs2_la_set_sizes: OK
[    7.136286] Testing event ocfs2_alloc_should_use_local: OK
[    7.148294] Testing event ocfs2_load_local_alloc: OK
[    7.160290] Testing event ocfs2_begin_local_alloc_recovery: OK
[    7.172287] Testing event ocfs2_reserve_local_alloc_bits: OK
[    7.184287] Testing event ocfs2_local_alloc_count_bits: OK
[    7.196288] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
[    7.208289] Testing event ocfs2_local_alloc_find_clear_bits: OK
[    7.220288] Testing event ocfs2_sync_local_to_main: OK
[    7.232286] Testing event ocfs2_sync_local_to_main_free: OK
[    7.244288] Testing event ocfs2_local_alloc_new_window: OK
[    7.256287] Testing event ocfs2_local_alloc_new_window_result: OK
[    7.268287] Testing event ocfs2_update_last_group_and_inode: OK
[    7.280288] Testing event ocfs2_group_extend: OK
[    7.292293] Testing event ocfs2_group_add: OK
[    7.304286] Testing event ocfs2_validate_group_descriptor: OK
[    7.316288] Testing event ocfs2_block_group_alloc_contig: OK
[    7.328286] Testing event ocfs2_block_group_alloc_discontig: OK
[    7.340287] Testing event ocfs2_block_group_alloc: OK
[    7.352287] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
[    7.364288] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
[    7.376287] Testing event ocfs2_reserve_new_inode_new_group: OK
[    7.388286] Testing event ocfs2_block_group_set_bits: OK
[    7.400286] Testing event ocfs2_relink_block_group: OK
[    7.412287] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
[    7.424286] Testing event ocfs2_cluster_group_search_max_block: OK
[    7.436287] Testing event ocfs2_block_group_search_max_block: OK
[    7.448287] Testing event ocfs2_search_chain_begin: OK
[    7.460287] Testing event ocfs2_search_chain_succ: OK
[    7.472286] Testing event ocfs2_search_chain_end: OK
[    7.484288] Testing event ocfs2_claim_suballoc_bits: OK
[    7.496291] Testing event ocfs2_claim_new_inode_at_loc: OK
[    7.508289] Testing event ocfs2_block_group_clear_bits: OK
[    7.520286] Testing event ocfs2_free_suballoc_bits: OK
[    7.532292] Testing event ocfs2_free_clusters: OK
[    7.544289] Testing event ocfs2_get_suballoc_slot_bit: OK
[    7.556288] Testing event ocfs2_test_suballoc_bit: OK
[    7.568286] Testing event ocfs2_test_inode_bit: OK
[    7.580288] Testing event ocfs2_validate_refcount_block: OK
[    7.592287] Testing event ocfs2_purge_refcount_trees: OK
[    7.604291] Testing event ocfs2_create_refcount_tree: OK
[    7.616287] Testing event ocfs2_create_refcount_tree_blkno: OK
[    7.628288] Testing event ocfs2_change_refcount_rec: OK
[    7.640287] Testing event ocfs2_expand_inline_ref_root: OK
[    7.652288] Testing event ocfs2_divide_leaf_refcount_block: OK
[    7.664286] Testing event ocfs2_new_leaf_refcount_block: OK
[    7.676288] Testing event ocfs2_insert_refcount_rec: OK
[    7.688286] Testing event ocfs2_split_refcount_rec: OK
[    7.700303] Testing event ocfs2_split_refcount_rec_insert: OK
[    7.712288] Testing event ocfs2_increase_refcount_begin: OK
[    7.724291] Testing event ocfs2_increase_refcount_change: OK
[    7.736286] Testing event ocfs2_increase_refcount_insert: OK
[    7.748286] Testing event ocfs2_increase_refcount_split: OK
[    7.760288] Testing event ocfs2_remove_refcount_extent: OK
[    7.772287] Testing event ocfs2_restore_refcount_block: OK
[    7.784287] Testing event ocfs2_decrease_refcount_rec: OK
[    7.796287] Testing event ocfs2_decrease_refcount: OK
[    7.808310] Testing event ocfs2_mark_extent_refcounted: OK
[    7.820318] Testing event ocfs2_calc_refcount_meta_credits: OK
[    7.832292] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
[    7.844290] Testing event ocfs2_add_refcount_flag: OK
[    7.856288] Testing event ocfs2_prepare_refcount_change_for_del: OK
[    7.868290] Testing event ocfs2_lock_refcount_allocators: OK
[    7.880287] Testing event ocfs2_duplicate_clusters_by_page: OK
[    7.892289] Testing event ocfs2_duplicate_clusters_by_jbd: OK
[    7.904256] Testing event ocfs2_clear_ext_refcount: OK
[    7.916298] Testing event ocfs2_replace_clusters: OK
[    7.928286] Testing event ocfs2_make_clusters_writable: OK
[    7.940289] Testing event ocfs2_refcount_cow_hunk: OK
[    7.952287] Testing event ocfs2_symlink_get_block: OK
[    7.964287] Testing event ocfs2_get_block: OK
[    7.976287] Testing event ocfs2_get_block_end: OK
[    7.988288] Testing event ocfs2_readpage: OK
[    8.000286] Testing event ocfs2_writepage: OK
[    8.012289] Testing event ocfs2_bmap: OK
[    8.024287] Testing event ocfs2_try_to_write_inline_data: OK
[    8.036288] Testing event ocfs2_write_begin_nolock: OK
[    8.048287] Testing event ocfs2_write_end_inline: OK
[    8.060291] Testing event ocfs2_fault: OK
[    8.072285] Testing event ocfs2_file_open: OK
[    8.084288] Testing event ocfs2_file_release: OK
[    8.096287] Testing event ocfs2_sync_file: OK
[    8.108288] Testing event ocfs2_file_aio_write: OK
[    8.120291] Testing event ocfs2_file_splice_write: OK
[    8.132288] Testing event ocfs2_file_splice_read: OK
[    8.144286] Testing event ocfs2_file_aio_read: OK
[    8.156288] Testing event ocfs2_truncate_file: OK
[    8.168286] Testing event ocfs2_truncate_file_error: OK
[    8.180288] Testing event ocfs2_extend_allocation: OK
[    8.192286] Testing event ocfs2_extend_allocation_end: OK
[    8.204289] Testing event ocfs2_write_zero_page: OK
[    8.216287] Testing event ocfs2_zero_extend_range: OK
[    8.228288] Testing event ocfs2_zero_extend: OK
[    8.240286] Testing event ocfs2_setattr: OK
[    8.252288] Testing event ocfs2_write_remove_suid: OK
[    8.264286] Testing event ocfs2_zero_partial_clusters: OK
[    8.276288] Testing event ocfs2_zero_partial_clusters_range1: OK
[    8.288286] Testing event ocfs2_zero_partial_clusters_range2: OK
[    8.300289] Testing event ocfs2_remove_inode_range: OK
[    8.312286] Testing event ocfs2_prepare_inode_for_write: OK
[    8.324291] Testing event generic_file_aio_read_ret: OK
[    8.336286] Testing event ocfs2_iget_begin: OK
[    8.348288] Testing event ocfs2_iget5_locked: OK
[    8.360287] Testing event ocfs2_iget_end: OK
[    8.372288] Testing event ocfs2_find_actor: OK
[    8.384286] Testing event ocfs2_populate_inode: OK
[    8.396288] Testing event ocfs2_read_locked_inode: OK
[    8.408286] Testing event ocfs2_check_orphan_recovery_state: OK
[    8.420288] Testing event ocfs2_validate_inode_block: OK
[    8.432286] Testing event ocfs2_inode_is_valid_to_delete: OK
[    8.444288] Testing event ocfs2_query_inode_wipe_begin: OK
[    8.456286] Testing event ocfs2_query_inode_wipe_succ: OK
[    8.468288] Testing event ocfs2_query_inode_wipe_end: OK
[    8.480286] Testing event ocfs2_cleanup_delete_inode: OK
[    8.492286] Testing event ocfs2_delete_inode: OK
[    8.504289] Testing event ocfs2_clear_inode: OK
[    8.516287] Testing event ocfs2_drop_inode: OK
[    8.528291] Testing event ocfs2_inode_revalidate: OK
[    8.540287] Testing event ocfs2_mark_inode_dirty: OK
[    8.552287] Testing event ocfs2_read_virt_blocks: OK
[    8.564288] Testing event ocfs2_refresh_slot_info: OK
[    8.576286] Testing event ocfs2_map_slot_buffers: OK
[    8.588287] Testing event ocfs2_map_slot_buffers_block: OK
[    8.600289] Testing event ocfs2_find_slot: OK
[    8.612287] Testing event ocfs2_do_node_down: OK
[    8.624286] Testing event ocfs2_remount: OK
[    8.636288] Testing event ocfs2_fill_super: OK
[    8.648286] Testing event ocfs2_parse_options: OK
[    8.660288] Testing event ocfs2_put_super: OK
[    8.672286] Testing event ocfs2_statfs: OK
[    8.684288] Testing event ocfs2_dismount_volume: OK
[    8.696286] Testing event ocfs2_initialize_super: OK
[    8.708288] Testing event ocfs2_validate_xattr_block: OK
[    8.720287] Testing event ocfs2_xattr_extend_allocation: OK
[    8.732293] Testing event ocfs2_init_xattr_set_ctxt: OK
[    8.744287] Testing event ocfs2_xattr_bucket_find: OK
[    8.756288] Testing event ocfs2_xattr_index_block_find: OK
[    8.768286] Testing event ocfs2_xattr_index_block_find_rec: OK
[    8.780288] Testing event ocfs2_iterate_xattr_buckets: OK
[    8.792287] Testing event ocfs2_iterate_xattr_bucket: OK
[    8.804287] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
[    8.816288] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
[    8.828288] Testing event ocfs2_xattr_create_index_block_begin: OK
[    8.840286] Testing event ocfs2_xattr_create_index_block: OK
[    8.852289] Testing event ocfs2_defrag_xattr_bucket: OK
[    8.864287] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
[    8.876287] Testing event ocfs2_divide_xattr_bucket_begin: OK
[    8.888287] Testing event ocfs2_divide_xattr_bucket_move: OK
[    8.900288] Testing event ocfs2_cp_xattr_bucket: OK
[    8.912287] Testing event ocfs2_mv_xattr_buckets: OK
[    8.924288] Testing event ocfs2_adjust_xattr_cross_cluster: OK
[    8.936292] Testing event ocfs2_add_new_xattr_cluster_begin: OK
[    8.948291] Testing event ocfs2_add_new_xattr_cluster: OK
[    8.960287] Testing event ocfs2_add_new_xattr_cluster_insert: OK
[    8.972288] Testing event ocfs2_extend_xattr_bucket: OK
[    8.984286] Testing event ocfs2_add_new_xattr_bucket: OK
[    8.996287] Testing event ocfs2_xattr_bucket_value_truncate: OK
[    9.008287] Testing event ocfs2_rm_xattr_cluster: OK
[    9.020286] Testing event ocfs2_reflink_xattr_header: OK
[    9.032287] Testing event ocfs2_create_empty_xattr_block: OK
[    9.044294] Testing event ocfs2_xattr_set_entry_bucket: OK
[    9.056286] Testing event ocfs2_xattr_set_entry_index_block: OK
[    9.068286] Testing event ocfs2_xattr_bucket_value_refcount: OK
[    9.080287] Testing event ocfs2_reflink_xattr_buckets: OK
[    9.092287] Testing event ocfs2_reflink_xattr_rec: OK
[    9.104286] Testing event ocfs2_resv_insert: OK
[    9.116287] Testing event ocfs2_resmap_find_free_bits_begin: OK
[    9.128286] Testing event ocfs2_resmap_find_free_bits_end: OK
[    9.140292] Testing event ocfs2_resv_find_window_begin: OK
[    9.152289] Testing event ocfs2_resv_find_window_prev: OK
[    9.164288] Testing event ocfs2_resv_find_window_next: OK
[    9.176287] Testing event ocfs2_cannibalize_resv_begin: OK
[    9.188288] Testing event ocfs2_cannibalize_resv_end: OK
[    9.200286] Testing event ocfs2_resmap_resv_bits: OK
[    9.212288] Testing event ocfs2_resmap_claimed_bits_begin: OK
[    9.224287] Testing event ocfs2_resmap_claimed_bits_end: OK
[    9.236288] Testing event ocfs2_recover_local_quota_file: OK
[    9.248286] Testing event ocfs2_finish_quota_recovery: OK
[    9.260289] Testing event olq_set_dquot: OK
[    9.272286] Testing event ocfs2_validate_quota_block: OK
[    9.284287] Testing event ocfs2_sync_dquot: OK
[    9.296286] Testing event ocfs2_sync_dquot_helper: OK
[    9.308288] Testing event ocfs2_write_dquot: OK
[    9.320286] Testing event ocfs2_release_dquot: OK
[    9.332285] Testing event ocfs2_acquire_dquot: OK
[    9.344292] Testing event ocfs2_mark_dquot_dirty: OK
[    9.356287] Testing event ocfs2_search_dirblock: OK
[    9.368287] Testing event ocfs2_validate_dir_block: OK
[    9.380286] Testing event ocfs2_find_entry_el: OK
[    9.392290] Testing event ocfs2_dx_dir_search: OK
[    9.404287] Testing event ocfs2_dx_dir_search_leaf_info: OK
[    9.416288] Testing event ocfs2_delete_entry_dx: OK
[    9.428288] Testing event ocfs2_readdir: OK
[    9.440286] Testing event ocfs2_find_files_on_disk: OK
[    9.452288] Testing event ocfs2_check_dir_for_entry: OK
[    9.464286] Testing event ocfs2_dx_dir_attach_index: OK
[    9.476287] Testing event ocfs2_dx_dir_format_cluster: OK
[    9.488287] Testing event ocfs2_dx_dir_index_root_block: OK
[    9.500286] Testing event ocfs2_extend_dir: OK
[    9.512286] Testing event ocfs2_dx_dir_rebalance: OK
[    9.524288] Testing event ocfs2_dx_dir_rebalance_split: OK
[    9.536287] Testing event ocfs2_prepare_dir_for_insert: OK
[    9.548293] Testing event ocfs2_lookup: OK
[    9.560286] Testing event ocfs2_mkdir: OK
[    9.572286] Testing event ocfs2_create: OK
[    9.584287] Testing event ocfs2_unlink: OK
[    9.596287] Testing event ocfs2_symlink_create: OK
[    9.608286] Testing event ocfs2_mv_orphaned_inode_to_new: OK
[    9.620287] Testing event ocfs2_lookup_ret: OK
[    9.632287] Testing event ocfs2_mknod: OK
[    9.644288] Testing event ocfs2_link: OK
[    9.656287] Testing event ocfs2_unlink_noent: OK
[    9.668287] Testing event ocfs2_double_lock: OK
[    9.680286] Testing event ocfs2_double_lock_end: OK
[    9.692288] Testing event ocfs2_rename: OK
[    9.704286] Testing event ocfs2_rename_target_exists: OK
[    9.716287] Testing event ocfs2_rename_disagree: OK
[    9.728287] Testing event ocfs2_rename_over_existing: OK
[    9.740288] Testing event ocfs2_create_symlink_data: OK
[    9.752293] Testing event ocfs2_symlink_begin: OK
[    9.764289] Testing event ocfs2_blkno_stringify: OK
[    9.776287] Testing event ocfs2_orphan_add_begin: OK
[    9.788287] Testing event ocfs2_orphan_add_end: OK
[    9.800286] Testing event ocfs2_orphan_del: OK
[    9.812287] Testing event ocfs2_dentry_revalidate: OK
[    9.824287] Testing event ocfs2_dentry_revalidate_negative: OK
[    9.836292] Testing event ocfs2_dentry_revalidate_delete: OK
[    9.848287] Testing event ocfs2_dentry_revalidate_orphaned: OK
[    9.860288] Testing event ocfs2_dentry_revalidate_nofsdata: OK
[    9.872287] Testing event ocfs2_dentry_revalidate_ret: OK
[    9.884288] Testing event ocfs2_find_local_alias: OK
[    9.896287] Testing event ocfs2_dentry_attach_lock: OK
[    9.908288] Testing event ocfs2_dentry_attach_lock_found: OK
[    9.920288] Testing event ocfs2_get_dentry_begin: OK
[    9.932286] Testing event ocfs2_get_dentry_test_bit: OK
[    9.944286] Testing event ocfs2_get_dentry_stale: OK
[    9.956293] Testing event ocfs2_get_dentry_generation: OK
[    9.968286] Testing event ocfs2_get_dentry_end: OK
[    9.980288] Testing event ocfs2_get_parent: OK
[    9.992286] Testing event ocfs2_get_parent_end: OK
[   10.004288] Testing event ocfs2_encode_fh_begin: OK
[   10.016256] Testing event ocfs2_encode_fh_self: OK
[   10.028286] Testing event ocfs2_encode_fh_parent: OK
[   10.040286] Testing event ocfs2_encode_fh_type: OK
[   10.052288] Testing event ocfs2_commit_cache_begin: OK
[   10.064287] Testing event ocfs2_commit_cache_end: OK
[   10.076288] Testing event ocfs2_extend_trans: OK
[   10.088286] Testing event ocfs2_extend_trans_restart: OK
[   10.100289] Testing event ocfs2_journal_access: OK
[   10.112287] Testing event ocfs2_journal_dirty: OK
[   10.124288] Testing event ocfs2_journal_init: OK
[   10.136287] Testing event ocfs2_journal_init_maxlen: OK
[   10.148288] Testing event ocfs2_journal_shutdown: OK
[   10.160287] Testing event ocfs2_journal_shutdown_wait: OK
[   10.172294] Testing event ocfs2_complete_recovery: OK
[   10.184287] Testing event ocfs2_complete_recovery_end: OK
[   10.196289] Testing event ocfs2_complete_recovery_slot: OK
[   10.208288] Testing event ocfs2_recovery_thread_node: OK
[   10.220287] Testing event ocfs2_recovery_thread_end: OK
[   10.232286] Testing event ocfs2_recovery_thread: OK
[   10.244288] Testing event ocfs2_replay_journal_recovered: OK
[   10.256286] Testing event ocfs2_replay_journal_lock_err: OK
[   10.268288] Testing event ocfs2_replay_journal_skip: OK
[   10.280287] Testing event ocfs2_recover_node: OK
[   10.292319] Testing event ocfs2_recover_node_skip: OK
[   10.304291] Testing event ocfs2_mark_dead_nodes: OK
[   10.316289] Testing event ocfs2_queue_orphan_scan_begin: OK
[   10.328288] Testing event ocfs2_queue_orphan_scan_end: OK
[   10.340289] Testing event ocfs2_orphan_filldir: OK
[   10.352287] Testing event ocfs2_recover_orphans: OK
[   10.364289] Testing event ocfs2_recover_orphans_iput: OK
[   10.376293] Testing event ocfs2_wait_on_mount: OK
[   10.388289] Testing event ocfs2_read_blocks_sync: OK
[   10.400288] Testing event ocfs2_read_blocks_sync_jbd: OK
[   10.412288] Testing event ocfs2_read_blocks_from_disk: OK
[   10.424287] Testing event ocfs2_read_blocks_bh: OK
[   10.436289] Testing event ocfs2_read_blocks_end: OK
[   10.448287] Testing event ocfs2_write_block: OK
[   10.460287] Testing event ocfs2_read_blocks_begin: OK
[   10.472286] Testing event ocfs2_purge_copied_metadata_tree: OK
[   10.484288] Testing event ocfs2_metadata_cache_purge: OK
[   10.496287] Testing event ocfs2_buffer_cached_begin: OK
[   10.508287] Testing event ocfs2_buffer_cached_end: OK
[   10.520287] Testing event ocfs2_append_cache_array: OK
[   10.532288] Testing event ocfs2_insert_cache_tree: OK
[   10.544289] Testing event ocfs2_expand_cache: OK
[   10.556288] Testing event ocfs2_set_buffer_uptodate: OK
[   10.568287] Testing event ocfs2_set_buffer_uptodate_begin: OK
[   10.580293] Testing event ocfs2_remove_metadata_array: OK
[   10.592287] Testing event ocfs2_remove_metadata_tree: OK
[   10.604288] Testing event ocfs2_remove_block_from_cache: OK
[   10.616289] Testing event xfs_attr_list_sf: OK
[   10.628287] Testing event xfs_attr_list_sf_all: OK
[   10.640287] Testing event xfs_attr_list_leaf: OK
[   10.652287] Testing event xfs_attr_list_leaf_end: OK
[   10.664286] Testing event xfs_attr_list_full: OK
[   10.676286] Testing event xfs_attr_list_add: OK
[   10.688288] Testing event xfs_attr_list_wrong_blk: OK
[   10.700301] Testing event xfs_attr_list_notfound: OK
[   10.712286] Testing event xfs_attr_leaf_list: OK
[   10.724288] Testing event xfs_attr_node_list: OK
[   10.736290] Testing event xfs_perag_get: OK
[   10.748288] Testing event xfs_perag_get_tag: OK
[   10.760287] Testing event xfs_perag_put: OK
[   10.772289] Testing event xfs_perag_set_reclaim: OK
[   10.784292] Testing event xfs_perag_clear_reclaim: OK
[   10.796288] Testing event xfs_perag_set_eofblocks: OK
[   10.808287] Testing event xfs_perag_clear_eofblocks: OK
[   10.820288] Testing event xfs_attr_list_node_descend: OK
[   10.832287] Testing event xfs_iext_insert: OK
[   10.844288] Testing event xfs_iext_remove: OK
[   10.856287] Testing event xfs_bmap_pre_update: OK
[   10.868288] Testing event xfs_bmap_post_update: OK
[   10.880287] Testing event xfs_extlist: OK
[   10.892288] Testing event xfs_buf_init: OK
[   10.904287] Testing event xfs_buf_free: OK
[   10.916290] Testing event xfs_buf_hold: OK
[   10.928287] Testing event xfs_buf_rele: OK
[   10.940289] Testing event xfs_buf_iodone: OK
[   10.952287] Testing event xfs_buf_iorequest: OK
[   10.964286] Testing event xfs_buf_bawrite: OK
[   10.976256] Testing event xfs_buf_lock: OK
[   10.988288] Testing event xfs_buf_lock_done: OK
[   11.000292] Testing event xfs_buf_trylock: OK
[   11.012289] Testing event xfs_buf_unlock: OK
[   11.024286] Testing event xfs_buf_iowait: OK
[   11.036288] Testing event xfs_buf_iowait_done: OK
[   11.048286] Testing event xfs_buf_delwri_queue: OK
[   11.060288] Testing event xfs_buf_delwri_queued: OK
[   11.072286] Testing event xfs_buf_delwri_split: OK
[   11.084291] Testing event xfs_buf_get_uncached: OK
[   11.096287] Testing event xfs_bdstrat_shut: OK
[   11.108288] Testing event xfs_buf_item_relse: OK
[   11.120286] Testing event xfs_buf_item_iodone: OK
[   11.132288] Testing event xfs_buf_item_iodone_async: OK
[   11.144287] Testing event xfs_buf_error_relse: OK
[   11.156287] Testing event xfs_trans_read_buf_io: OK
[   11.168286] Testing event xfs_trans_read_buf_shut: OK
[   11.180286] Testing event xfs_btree_corrupt: OK
[   11.192366] Testing event xfs_da_btree_corrupt: OK
[   11.204288] Testing event xfs_reset_dqcounts: OK
[   11.216258] Testing event xfs_inode_item_push: OK
[   11.228258] Testing event xfs_buf_find: OK
[   11.240286] Testing event xfs_buf_get: OK
[   11.252288] Testing event xfs_buf_read: OK
[   11.264287] Testing event xfs_buf_ioerror: OK
[   11.276288] Testing event xfs_buf_item_size: OK
[   11.288286] Testing event xfs_buf_item_size_stale: OK
[   11.300288] Testing event xfs_buf_item_format: OK
[   11.312286] Testing event xfs_buf_item_format_stale: OK
[   11.324286] Testing event xfs_buf_item_pin: OK
[   11.336287] Testing event xfs_buf_item_unpin: OK
[   11.348288] Testing event xfs_buf_item_unpin_stale: OK
[   11.360286] Testing event xfs_buf_item_unlock: OK
[   11.372287] Testing event xfs_buf_item_unlock_stale: OK
[   11.384286] Testing event xfs_buf_item_committed: OK
[   11.396292] Testing event xfs_buf_item_push: OK
[   11.408286] Testing event xfs_trans_get_buf: OK
[   11.420288] Testing event xfs_trans_get_buf_recur: OK
[   11.432286] Testing event xfs_trans_getsb: OK
[   11.444287] Testing event xfs_trans_getsb_recur: OK
[   11.456286] Testing event xfs_trans_read_buf: OK
[   11.468288] Testing event xfs_trans_read_buf_recur: OK
[   11.480286] Testing event xfs_trans_log_buf: OK
[   11.492288] Testing event xfs_trans_brelse: OK
[   11.504286] Testing event xfs_trans_bjoin: OK
[   11.516287] Testing event xfs_trans_bhold: OK
[   11.528286] Testing event xfs_trans_bhold_release: OK
[   11.540288] Testing event xfs_trans_binval: OK
[   11.552286] Testing event xfs_ilock: OK
[   11.564288] Testing event xfs_ilock_nowait: OK
[   11.576286] Testing event xfs_ilock_demote: OK
[   11.588287] Testing event xfs_iunlock: OK
[   11.600292] Testing event xfs_iget_skip: OK
[   11.612287] Testing event xfs_iget_reclaim: OK
[   11.624289] Testing event xfs_iget_reclaim_fail: OK
[   11.636287] Testing event xfs_iget_hit: OK
[   11.648287] Testing event xfs_iget_miss: OK
[   11.660288] Testing event xfs_getattr: OK
[   11.672286] Testing event xfs_setattr: OK
[   11.684287] Testing event xfs_readlink: OK
[   11.696286] Testing event xfs_alloc_file_space: OK
[   11.708288] Testing event xfs_free_file_space: OK
[   11.720286] Testing event xfs_readdir: OK
[   11.732288] Testing event xfs_get_acl: OK
[   11.744286] Testing event xfs_vm_bmap: OK
[   11.756287] Testing event xfs_file_ioctl: OK
[   11.768286] Testing event xfs_file_compat_ioctl: OK
[   11.780258] Testing event xfs_ioctl_setattr: OK
[   11.792286] Testing event xfs_dir_fsync: OK
[   11.804288] Testing event xfs_file_fsync: OK
[   11.816293] Testing event xfs_destroy_inode: OK
[   11.828287] Testing event xfs_evict_inode: OK
[   11.840286] Testing event xfs_update_time: OK
[   11.852288] Testing event xfs_dquot_dqalloc: OK
[   11.864257] Testing event xfs_dquot_dqdetach: OK
[   11.876257] Testing event xfs_inode_set_eofblocks_tag: OK
[   11.888286] Testing event xfs_inode_clear_eofblocks_tag: OK
[   11.900288] Testing event xfs_inode_free_eofblocks_invalid: OK
[   11.912286] Testing event xfs_ihold: OK
[   11.924288] Testing event xfs_irele: OK
[   11.936467] Testing event xfs_inode_pin: OK
[   11.948290] Testing event xfs_inode_unpin: OK
[   11.960292] Testing event xfs_inode_unpin_nowait: OK
[   11.972288] Testing event xfs_remove: OK
[   11.984287] Testing event xfs_link: OK
[   11.996286] Testing event xfs_lookup: OK
[   12.008287] Testing event xfs_create: OK
[   12.020291] Testing event xfs_symlink: OK
[   12.032286] Testing event xfs_rename: OK
[   12.044287] Testing event xfs_dqadjust: OK
[   12.056257] Testing event xfs_dqreclaim_want: OK
[   12.068255] Testing event xfs_dqreclaim_dirty: OK
[   12.080256] Testing event xfs_dqreclaim_busy: OK
[   12.092257] Testing event xfs_dqreclaim_done: OK
[   12.104256] Testing event xfs_dqattach_found: OK
[   12.116254] Testing event xfs_dqattach_get: OK
[   12.128256] Testing event xfs_dqalloc: OK
[   12.140257] Testing event xfs_dqtobp_read: OK
[   12.152256] Testing event xfs_dqread: OK
[   12.164257] Testing event xfs_dqread_fail: OK
[   12.176256] Testing event xfs_dqget_hit: OK
[   12.188256] Testing event xfs_dqget_miss: OK
[   12.200256] Testing event xfs_dqget_freeing: OK
[   12.212257] Testing event xfs_dqget_dup: OK
[   12.224256] Testing event xfs_dqput: OK
[   12.236256] Testing event xfs_dqput_wait: OK
[   12.248256] Testing event xfs_dqput_free: OK
[   12.260257] Testing event xfs_dqrele: OK
[   12.272256] Testing event xfs_dqflush: OK
[   12.284257] Testing event xfs_dqflush_force: OK
[   12.296256] Testing event xfs_dqflush_done: OK
[   12.308256] Testing event xfs_log_done_nonperm: OK
[   12.320287] Testing event xfs_log_done_perm: OK
[   12.332289] Testing event xfs_log_umount_write: OK
[   12.344286] Testing event xfs_log_grant_sleep: OK
[   12.356288] Testing event xfs_log_grant_wake: OK
[   12.368286] Testing event xfs_log_grant_wake_up: OK
[   12.380287] Testing event xfs_log_reserve: OK
[   12.392287] Testing event xfs_log_reserve_exit: OK
[   12.404287] Testing event xfs_log_regrant: OK
[   12.416290] Testing event xfs_log_regrant_exit: OK
[   12.428293] Testing event xfs_log_regrant_reserve_enter: OK
[   12.440289] Testing event xfs_log_regrant_reserve_exit: OK
[   12.452289] Testing event xfs_log_regrant_reserve_sub: OK
[   12.464288] Testing event xfs_log_ungrant_enter: OK
[   12.476288] Testing event xfs_log_ungrant_exit: OK
[   12.488288] Testing event xfs_log_ungrant_sub: OK
[   12.500287] Testing event xfs_log_force: OK
[   12.512288] Testing event xfs_ail_push: OK
[   12.524288] Testing event xfs_ail_pinned: OK
[   12.536287] Testing event xfs_ail_locked: OK
[   12.548287] Testing event xfs_ail_flushing: OK
[   12.560288] Testing event xfs_file_read: OK
[   12.572287] Testing event xfs_file_buffered_write: OK
[   12.584287] Testing event xfs_file_direct_write: OK
[   12.596289] Testing event xfs_file_splice_read: OK
[   12.608289] Testing event xfs_file_splice_write: OK
[   12.620286] Testing event xfs_writepage: OK
[   12.632292] Testing event xfs_releasepage: OK
[   12.644289] Testing event xfs_invalidatepage: OK
[   12.656287] Testing event xfs_map_blocks_found: OK
[   12.668288] Testing event xfs_map_blocks_alloc: OK
[   12.680289] Testing event xfs_get_blocks_found: OK
[   12.692288] Testing event xfs_get_blocks_alloc: OK
[   12.704287] Testing event xfs_delalloc_enospc: OK
[   12.716288] Testing event xfs_unwritten_convert: OK
[   12.728291] Testing event xfs_get_blocks_notfound: OK
[   12.740288] Testing event xfs_setfilesize: OK
[   12.752288] Testing event xfs_itruncate_extents_start: OK
[   12.764289] Testing event xfs_itruncate_extents_end: OK
[   12.776287] Testing event xfs_pagecache_inval: OK
[   12.788259] Testing event xfs_bunmap: OK
[   12.800287] Testing event xfs_extent_busy: OK
[   12.812288] Testing event xfs_extent_busy_enomem: OK
[   12.824290] Testing event xfs_extent_busy_force: OK
[   12.836290] Testing event xfs_extent_busy_reuse: OK
[   12.848293] Testing event xfs_extent_busy_clear: OK
[   12.860289] Testing event xfs_extent_busy_trim: OK
[   12.872288] Testing event xfs_trans_commit_lsn: OK
[   12.884258] Testing event xfs_agf: OK
[   12.896288] Testing event xfs_free_extent: OK
[   12.908289] Testing event xfs_alloc_exact_done: OK
[   12.920289] Testing event xfs_alloc_exact_notfound: OK
[   12.932289] Testing event xfs_alloc_exact_error: OK
[   12.944287] Testing event xfs_alloc_near_nominleft: OK
[   12.956288] Testing event xfs_alloc_near_first: OK
[   12.968290] Testing event xfs_alloc_near_greater: OK
[   12.980288] Testing event xfs_alloc_near_lesser: OK
[   12.992288] Testing event xfs_alloc_near_error: OK
[   13.004288] Testing event xfs_alloc_near_noentry: OK
[   13.016289] Testing event xfs_alloc_near_busy: OK
[   13.028585] Testing event xfs_alloc_size_neither: OK
[   13.036308] Testing event xfs_alloc_size_noentry: OK
[   13.044367] Testing event xfs_alloc_size_nominleft: OK
[   13.052375] Testing event xfs_alloc_size_done: OK
[   13.060378] Testing event xfs_alloc_size_error: OK
[   13.068369] Testing event xfs_alloc_size_busy: OK
[   13.076313] Testing event xfs_alloc_small_freelist: OK
[   13.084309] Testing event xfs_alloc_small_notenough: OK
[   13.092309] Testing event xfs_alloc_small_done: OK
[   13.100315] Testing event xfs_alloc_small_error: OK
[   13.108308] Testing event xfs_alloc_vextent_badargs: OK
[   13.116310] Testing event xfs_alloc_vextent_nofix: OK
[   13.124310] Testing event xfs_alloc_vextent_noagbp: OK
[   13.132309] Testing event xfs_alloc_vextent_loopfailed: OK
[   13.140321] Testing event xfs_alloc_vextent_allfailed: OK
[   13.148311] Testing event xfs_dir2_sf_addname: OK
[   13.156310] Testing event xfs_dir2_sf_create: OK
[   13.164309] Testing event xfs_dir2_sf_lookup: OK
[   13.172310] Testing event xfs_dir2_sf_replace: OK
[   13.180309] Testing event xfs_dir2_sf_removename: OK
[   13.188322] Testing event xfs_dir2_sf_toino4: OK
[   13.196280] Testing event xfs_dir2_sf_toino8: OK
[   13.204279] Testing event xfs_dir2_sf_to_block: OK
[   13.212309] Testing event xfs_dir2_block_addname: OK
[   13.220309] Testing event xfs_dir2_block_lookup: OK
[   13.228313] Testing event xfs_dir2_block_replace: OK
[   13.236309] Testing event xfs_dir2_block_removename: OK
[   13.244310] Testing event xfs_dir2_block_to_sf: OK
[   13.252310] Testing event xfs_dir2_block_to_leaf: OK
[   13.260309] Testing event xfs_dir2_leaf_addname: OK
[   13.268319] Testing event xfs_dir2_leaf_lookup: OK
[   13.276311] Testing event xfs_dir2_leaf_replace: OK
[   13.284309] Testing event xfs_dir2_leaf_removename: OK
[   13.292310] Testing event xfs_dir2_leaf_to_block: OK
[   13.300309] Testing event xfs_dir2_leaf_to_node: OK
[   13.308308] Testing event xfs_dir2_node_addname: OK
[   13.316318] Testing event xfs_dir2_node_lookup: OK
[   13.324308] Testing event xfs_dir2_node_replace: OK
[   13.332308] Testing event xfs_dir2_node_removename: OK
[   13.340314] Testing event xfs_dir2_node_to_leaf: OK
[   13.348308] Testing event xfs_attr_sf_add: OK
[   13.356314] Testing event xfs_attr_sf_addname: OK
[   13.364311] Testing event xfs_attr_sf_create: OK
[   13.372309] Testing event xfs_attr_sf_lookup: OK
[   13.380308] Testing event xfs_attr_sf_remove: OK
[   13.388310] Testing event xfs_attr_sf_removename: OK
[   13.396287] Testing event xfs_attr_sf_to_leaf: OK
[   13.404310] Testing event xfs_attr_leaf_add: OK
[   13.412310] Testing event xfs_attr_leaf_add_old: OK
[   13.420308] Testing event xfs_attr_leaf_add_new: OK
[   13.428308] Testing event xfs_attr_leaf_add_work: OK
[   13.436310] Testing event xfs_attr_leaf_addname: OK
[   13.444318] Testing event xfs_attr_leaf_create: OK
[   13.452309] Testing event xfs_attr_leaf_compact: OK
[   13.460312] Testing event xfs_attr_leaf_get: OK
[   13.468308] Testing event xfs_attr_leaf_lookup: OK
[   13.476309] Testing event xfs_attr_leaf_replace: OK
[   13.484320] Testing event xfs_attr_leaf_remove: OK
[   13.492308] Testing event xfs_attr_leaf_removename: OK
[   13.500309] Testing event xfs_attr_leaf_split: OK
[   13.508309] Testing event xfs_attr_leaf_split_before: OK
[   13.516309] Testing event xfs_attr_leaf_split_after: OK
[   13.524317] Testing event xfs_attr_leaf_clearflag: OK
[   13.532311] Testing event xfs_attr_leaf_setflag: OK
[   13.540308] Testing event xfs_attr_leaf_flipflags: OK
[   13.548329] Testing event xfs_attr_leaf_to_sf: OK
[   13.556310] Testing event xfs_attr_leaf_to_node: OK
[   13.564309] Testing event xfs_attr_leaf_rebalance: OK
[   13.572309] Testing event xfs_attr_leaf_unbalance: OK
[   13.580310] Testing event xfs_attr_leaf_toosmall: OK
[   13.588317] Testing event xfs_attr_node_addname: OK
[   13.596309] Testing event xfs_attr_node_get: OK
[   13.604309] Testing event xfs_attr_node_lookup: OK
[   13.612279] Testing event xfs_attr_node_replace: OK
[   13.620309] Testing event xfs_attr_node_removename: OK
[   13.628315] Testing event xfs_attr_fillstate: OK
[   13.636318] Testing event xfs_attr_refillstate: OK
[   13.644308] Testing event xfs_attr_rmtval_get: OK
[   13.652310] Testing event xfs_attr_rmtval_set: OK
[   13.660309] Testing event xfs_attr_rmtval_remove: OK
[   13.668308] Testing event xfs_da_split: OK
[   13.676315] Testing event xfs_da_join: OK
[   13.684308] Testing event xfs_da_link_before: OK
[   13.692309] Testing event xfs_da_link_after: OK
[   13.700309] Testing event xfs_da_unlink_back: OK
[   13.708315] Testing event xfs_da_unlink_forward: OK
[   13.716323] Testing event xfs_da_root_split: OK
[   13.724311] Testing event xfs_da_root_join: OK
[   13.732309] Testing event xfs_da_node_add: OK
[   13.740309] Testing event xfs_da_node_create: OK
[   13.748310] Testing event xfs_da_node_split: OK
[   13.756309] Testing event xfs_da_node_remove: OK
[   13.764325] Testing event xfs_da_node_rebalance: OK
[   13.772310] Testing event xfs_da_node_unbalance: OK
[   13.780309] Testing event xfs_da_node_toosmall: OK
[   13.788310] Testing event xfs_da_swap_lastblock: OK
[   13.796311] Testing event xfs_da_grow_inode: OK
[   13.804310] Testing event xfs_da_shrink_inode: OK
[   13.812309] Testing event xfs_da_fixhashpath: OK
[   13.820310] Testing event xfs_da_path_shift: OK
[   13.828309] Testing event xfs_dir2_leafn_add: OK
[   13.836309] Testing event xfs_dir2_leafn_remove: OK
[   13.844319] Testing event xfs_dir2_grow_inode: OK
[   13.852309] Testing event xfs_dir2_shrink_inode: OK
[   13.860311] Testing event xfs_dir2_leafn_moveents: OK
[   13.868311] Testing event xfs_swap_extent_before: OK
[   13.876309] Testing event xfs_swap_extent_after: OK
[   13.884309] Testing event xfs_log_recover_item_add: OK
[   13.892319] Testing event xfs_log_recover_item_add_cont: OK
[   13.900314] Testing event xfs_log_recover_item_reorder_head: OK
[   13.908309] Testing event xfs_log_recover_item_reorder_tail: OK
[   13.916321] Testing event xfs_log_recover_item_recover: OK
[   13.924310] Testing event xfs_log_recover_buf_not_cancel: OK
[   13.932311] Testing event xfs_log_recover_buf_cancel: OK
[   13.940311] Testing event xfs_log_recover_buf_cancel_add: OK
[   13.948310] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   13.956309] Testing event xfs_log_recover_buf_recover: OK
[   13.964311] Testing event xfs_log_recover_buf_inode_buf: OK
[   13.972318] Testing event xfs_log_recover_buf_reg_buf: OK
[   13.980310] Testing event xfs_log_recover_buf_dquot_buf: OK
[   13.988311] Testing event xfs_log_recover_inode_recover: OK
[   13.996310] Testing event xfs_log_recover_inode_cancel: OK
[   14.004309] Testing event xfs_log_recover_inode_skip: OK
[   14.012310] Testing event xfs_discard_extent: OK
[   14.020318] Testing event xfs_discard_toosmall: OK
[   14.028309] Testing event xfs_discard_exclude: OK
[   14.036316] Testing event xfs_discard_busy: OK
[   14.044309] Testing event jbd2_checkpoint: OK
[   14.052309] Testing event jbd2_start_commit: OK
[   14.060313] Testing event jbd2_commit_locking: OK
[   14.068309] Testing event jbd2_commit_flushing: OK
[   14.076320] Testing event jbd2_commit_logging: OK
[   14.084323] Testing event jbd2_drop_transaction: OK
[   14.092309] Testing event jbd2_end_commit: OK
[   14.100318] Testing event jbd2_submit_inode_data: OK
[   14.108310] Testing event jbd2_run_stats: OK
[   14.116309] Testing event jbd2_checkpoint_stats: OK
[   14.124309] Testing event jbd2_update_log_tail: OK
[   14.132310] Testing event jbd2_write_superblock: OK
[   14.140309] Testing event ext4_free_inode: OK
[   14.148309] Testing event ext4_request_inode: OK
[   14.156310] Testing event ext4_allocate_inode: OK
[   14.164309] Testing event ext4_evict_inode: OK
[   14.172314] Testing event ext4_drop_inode: OK
[   14.180310] Testing event ext4_mark_inode_dirty: OK
[   14.188309] Testing event ext4_begin_ordered_truncate: OK
[   14.196310] Testing event ext4_write_begin: OK
[   14.204311] Testing event ext4_da_write_begin: OK
[   14.212317] Testing event ext4_ordered_write_end: OK
[   14.220308] Testing event ext4_writeback_write_end: OK
[   14.228319] Testing event ext4_journalled_write_end: OK
[   14.236308] Testing event ext4_da_write_end: OK
[   14.244309] Testing event ext4_da_writepages: OK
[   14.252310] Testing event ext4_da_write_pages: OK
[   14.260309] Testing event ext4_da_writepages_result: OK
[   14.268308] Testing event ext4_writepage: OK
[   14.276309] Testing event ext4_readpage: OK
[   14.284308] Testing event ext4_releasepage: OK
[   14.292308] Testing event ext4_invalidatepage: OK
[   14.300310] Testing event ext4_discard_blocks: OK
[   14.308376] Testing event ext4_mb_new_inode_pa: OK
[   14.316309] Testing event ext4_mb_new_group_pa: OK
[   14.324310] Testing event ext4_mb_release_inode_pa: OK
[   14.332308] Testing event ext4_mb_release_group_pa: OK
[   14.340317] Testing event ext4_discard_preallocations: OK
[   14.348310] Testing event ext4_mb_discard_preallocations: OK
[   14.356320] Testing event ext4_request_blocks: OK
[   14.364310] Testing event ext4_allocate_blocks: OK
[   14.372309] Testing event ext4_free_blocks: OK
[   14.380308] Testing event ext4_sync_file_enter: OK
[   14.388308] Testing event ext4_sync_file_exit: OK
[   14.396310] Testing event ext4_sync_fs: OK
[   14.404310] Testing event ext4_alloc_da_blocks: OK
[   14.412309] Testing event ext4_mballoc_alloc: OK
[   14.420310] Testing event ext4_mballoc_prealloc: OK
[   14.428308] Testing event ext4_mballoc_discard: OK
[   14.436309] Testing event ext4_mballoc_free: OK
[   14.444315] Testing event ext4_forget: OK
[   14.452310] Testing event ext4_da_update_reserve_space: OK
[   14.460308] Testing event ext4_da_reserve_space: OK
[   14.468319] Testing event ext4_da_release_space: OK
[   14.476308] Testing event ext4_mb_bitmap_load: OK
[   14.484317] Testing event ext4_mb_buddy_bitmap_load: OK
[   14.492310] Testing event ext4_read_block_bitmap_load: OK
[   14.500309] Testing event ext4_load_inode_bitmap: OK
[   14.508308] Testing event ext4_direct_IO_enter: OK
[   14.516310] Testing event ext4_direct_IO_exit: OK
[   14.524309] Testing event ext4_fallocate_enter: OK
[   14.532309] Testing event ext4_fallocate_exit: OK
[   14.540310] Testing event ext4_unlink_enter: OK
[   14.548308] Testing event ext4_unlink_exit: OK
[   14.556309] Testing event ext4_truncate_enter: OK
[   14.564310] Testing event ext4_truncate_exit: OK
[   14.572341] Testing event ext4_ext_convert_to_initialized_enter: OK
[   14.580309] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   14.588310] Testing event ext4_ext_map_blocks_enter: OK
[   14.596318] Testing event ext4_ind_map_blocks_enter: OK
[   14.604309] Testing event ext4_ext_map_blocks_exit: OK
[   14.612318] Testing event ext4_ind_map_blocks_exit: OK
[   14.620308] Testing event ext4_ext_load_extent: OK
[   14.628309] Testing event ext4_load_inode: OK
[   14.636310] Testing event ext4_journal_start: OK
[   14.644311] Testing event ext4_trim_extent: OK
[   14.652309] Testing event ext4_trim_all_free: OK
[   14.660311] Testing event ext4_ext_handle_uninitialized_extents: OK
[   14.668309] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   14.676308] Testing event ext4_ext_put_in_cache: OK
[   14.684310] Testing event ext4_ext_in_cache: OK
[   14.692308] Testing event ext4_find_delalloc_range: OK
[   14.700278] Testing event ext4_get_reserved_cluster_alloc: OK
[   14.708325] Testing event ext4_ext_show_extent: OK
[   14.716318] Testing event ext4_remove_blocks: OK
[   14.724320] Testing event ext4_ext_rm_leaf: OK
[   14.732311] Testing event ext4_ext_rm_idx: OK
[   14.740318] Testing event ext4_ext_remove_space: OK
[   14.748311] Testing event ext4_ext_remove_space_done: OK
[   14.756311] Testing event ext4_es_insert_extent: OK
[   14.764309] Testing event ext4_es_remove_extent: OK
[   14.772310] Testing event ext4_es_find_extent_enter: OK
[   14.780310] Testing event ext4_es_find_extent_exit: OK
[   14.788312] Testing event writeback_nothread: OK
[   14.796310] Testing event writeback_queue: OK
[   14.804318] Testing event writeback_exec: OK
[   14.812310] Testing event writeback_start: OK
[   14.820309] Testing event writeback_written: OK
[   14.828310] Testing event writeback_wait: OK
[   14.836309] Testing event writeback_pages_written: OK
[   14.844310] Testing event writeback_nowork: OK
[   14.852323] Testing event writeback_wake_background: OK
[   14.860310] Testing event writeback_wake_thread: OK
[   14.868311] Testing event writeback_wake_forker_thread: OK
[   14.876311] Testing event writeback_bdi_register: OK
[   14.884309] Testing event writeback_bdi_unregister: OK
[   14.892309] Testing event writeback_thread_start: OK
[   14.900310] Testing event writeback_thread_stop: OK
[   14.908309] Testing event wbc_writepage: OK
[   14.916312] Testing event writeback_queue_io: OK
[   14.924318] Testing event global_dirty_state: OK
[   14.932317] Testing event bdi_dirty_ratelimit: OK
[   14.940310] Testing event balance_dirty_pages: OK
[   14.948314] Testing event writeback_sb_inodes_requeue: OK
[   14.956311] Testing event writeback_congestion_wait: OK
[   14.964309] Testing event writeback_wait_iff_congested: OK
[   14.972311] Testing event writeback_single_inode: OK
[   14.980323] Testing event mm_migrate_pages: OK
[   14.988315] Testing event mm_compaction_isolate_migratepages: OK
[   14.996310] Testing event mm_compaction_isolate_freepages: OK
[   15.004309] Testing event mm_compaction_migratepages: OK
[   15.012309] Testing event kmalloc: OK
[   15.020317] Testing event kmem_cache_alloc: OK
[   15.028308] Testing event kmalloc_node: OK
[   15.036279] Testing event kmem_cache_alloc_node: OK
[   15.044280] Testing event kfree: OK
[   15.052310] Testing event kmem_cache_free: OK
[   15.060309] Testing event mm_page_free: OK
[   15.068310] Testing event mm_page_free_batched: OK
[   15.076314] Testing event mm_page_alloc: OK
[   15.084309] Testing event mm_page_alloc_zone_locked: OK
[   15.092310] Testing event mm_page_pcpu_drain: OK
[   15.100310] Testing event mm_page_alloc_extfrag: OK
[   15.108310] Testing event mm_vmscan_kswapd_sleep: OK
[   15.116310] Testing event mm_vmscan_kswapd_wake: OK
[   15.124318] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.132309] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.140315] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.148279] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.156280] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.164310] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.172287] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.180279] Testing event mm_shrink_slab_start: OK
[   15.188310] Testing event mm_shrink_slab_end: OK
[   15.196309] Testing event mm_vmscan_lru_isolate: OK
[   15.204309] Testing event mm_vmscan_memcg_isolate: OK
[   15.212280] Testing event mm_vmscan_writepage: OK
[   15.220309] Testing event mm_vmscan_lru_shrink_inactive: OK
[   15.228310] Testing event oom_score_adj_update: OK
[   15.236310] Testing event rpm_suspend: OK
[   15.244310] Testing event rpm_resume: OK
[   15.252317] Testing event rpm_idle: OK
[   15.260311] Testing event rpm_return_int: OK
[   15.268309] Testing event cpu_idle: OK
[   15.276346] Testing event cpu_frequency: OK
[   15.284277] Testing event machine_suspend: OK
[   15.292335] Testing event wakeup_source_activate: OK
[   15.300282] Testing event wakeup_source_deactivate: OK
[   15.308269] Testing event power_start: OK
[   15.316330] Testing event power_frequency: OK
[   15.324272] Testing event power_end: OK
[   15.332338] Testing event clock_enable: OK
[   15.340269] Testing event clock_disable: OK
[   15.348269] Testing event clock_set_rate: OK
[   15.356270] Testing event power_domain_target: OK
[   15.364270] Testing event ftrace_test_filter: OK
[   15.372270] Testing event lock_acquire: OK
[   15.380337] Testing event lock_release: OK
[   15.388317] Testing event sched_kthread_stop: OK
[   15.396305] Testing event sched_kthread_stop_ret: OK
[   15.404305] Testing event sched_wakeup: OK
[   15.412274] Testing event sched_wakeup_new: OK
[   15.420273] Testing event sched_switch: OK
[   15.428283] Testing event sched_migrate_task: OK
[   15.436268] Testing event sched_process_free: OK
[   15.444299] Testing event sched_process_exit: OK
[   15.452300] Testing event sched_wait_task: OK
[   15.460268] Testing event sched_process_wait: OK
[   15.468299] Testing event sched_process_fork: OK
[   15.476300] Testing event sched_process_exec: OK
[   15.484298] Testing event sched_stat_wait: OK
[   15.492301] Testing event sched_stat_sleep: OK
[   15.500300] Testing event sched_stat_iowait: OK
[   15.508310] Testing event sched_stat_blocked: OK
[   15.516312] Testing event sched_stat_runtime: OK
[   15.524310] Testing event sched_pi_setprio: OK
[   15.532311] Testing event rcu_utilization: OK
[   15.540279] Testing event workqueue_queue_work: OK
[   15.548311] Testing event workqueue_activate_work: OK
[   15.556325] Testing event workqueue_execute_start: OK
[   15.564311] Testing event workqueue_execute_end: OK
[   15.572315] Testing event signal_generate: OK
[   15.580310] Testing event signal_deliver: OK
[   15.588310] Testing event timer_init: OK
[   15.596311] Testing event timer_start: OK
[   15.604310] Testing event timer_expire_entry: OK
[   15.612311] Testing event timer_expire_exit: OK
[   15.620313] Testing event timer_cancel: OK
[   15.628311] Testing event hrtimer_init: OK
[   15.636318] Testing event hrtimer_start: OK
[   15.644311] Testing event hrtimer_expire_entry: OK
[   15.652310] Testing event hrtimer_expire_exit: OK
[   15.660315] Testing event hrtimer_cancel: OK
[   15.668314] Testing event itimer_state: OK
[   15.676309] Testing event itimer_expire: OK
[   15.684350] Testing event irq_handler_entry: OK
[   15.692343] Testing event irq_handler_exit: OK
[   15.700350] Testing event softirq_entry: OK
[   15.708314] Testing event softirq_exit: OK
[   15.716313] Testing event softirq_raise: OK
[   15.724320] Testing event console: OK
[   15.732309] Testing event task_newtask: OK
[   15.740310] Testing event task_rename: OK
[   15.748298] Testing event sys_enter: OK
[   15.756346] Testing event sys_exit: OK
[   15.764335] Running tests on trace event systems:
[   15.764990] Testing event system raw_syscalls: OK
[   15.772461] Testing event system task: OK
[   15.780442] Testing event system printk: OK
[   15.788332] Testing event system irq: OK
[   15.796850] Testing event system timer: OK
[   15.805677] Testing event system signal: OK
[   15.812451] Testing event system workqueue: OK
[   15.820680] Testing event system rcu: OK
[   15.828296] Testing event system sched: OK
[   15.838245] Testing event system lock: OK
[   15.844479] Testing event system test: OK
[   15.852303] Testing event system power: OK
[   15.861479] Testing event system rpm: OK
[   15.868678] Testing event system oom: OK
[   15.876326] Testing event system vmscan: OK
[   15.885879] Testing event system kmem: OK
[   15.893591] Testing event system compaction: OK
[   15.900575] Testing event system migrate: OK
[   15.908334] Testing event system writeback: OK
[   15.919130] Testing event system ext4: OK
[   15.947091] Testing event system jbd2: OK
[   15.957627] Testing event system xfs: OK
[   16.069670] Testing event system ocfs2: OK
[   16.186544] Testing event system btrfs: OK
[   16.199955] Testing event system block: OK
[   16.210170] Testing event system gpio: OK
[   16.216460] Testing event system random: OK
[   16.224909] Testing event system regmap: OK
[   16.233402] Testing event system scsi: OK
[   16.240797] Testing event system syscalls: OK
[   16.249152] Testing event system udp: OK
[   16.256296] Testing event system sock: OK
[   16.264446] Testing event system napi: OK
[   16.272358] Testing event system net: OK
[   16.280684] Testing event system skb: OK
[   16.288590] Testing event system cfg80211: OK
[   16.330211] Running tests on all trace events:
[   16.330833] Testing all events: OK
[   16.877345] Running tests again, along with the function tracer
[   16.878301] Running tests on trace events:
[   16.878973] Testing event rdev_suspend: OK
[   16.889164] Testing event rdev_return_int: OK
[   16.897720] Testing event rdev_scan: OK
[   16.905205] Testing event rdev_resume: OK
[   16.913248] Testing event rdev_return_void: OK
[   16.921264] Testing event rdev_get_ringparam: OK
[   16.929255] Testing event rdev_get_antenna: OK
[   16.937146] Testing event rdev_rfkill_poll: OK
[   16.945252] Testing event rdev_set_wakeup: OK
[   16.953190] Testing event rdev_add_virtual_intf: OK
[   16.961253] Testing event rdev_return_wdev: OK
[   16.969145] Testing event rdev_del_virtual_intf: OK
[   16.977253] Testing event rdev_change_virtual_intf: OK
[   16.985158] Testing event rdev_add_key: OK
[   16.993291] Testing event rdev_get_key: OK
[   17.001149] Testing event rdev_del_key: OK
[   17.009329] Testing event rdev_set_default_key: OK
[   17.017186] Testing event rdev_set_default_mgmt_key: OK
[   17.025315] Testing event rdev_start_ap: OK
[   17.033144] Testing event rdev_change_beacon: OK
[   17.041251] Testing event rdev_stop_ap: OK
[   17.049147] Testing event rdev_get_et_stats: OK
[   17.057251] Testing event rdev_sched_scan_stop: OK
[   17.065155] Testing event rdev_set_rekey_data: OK
[   17.073257] Testing event rdev_get_mesh_config: OK
[   17.081145] Testing event rdev_leave_mesh: OK
[   17.089260] Testing event rdev_leave_ibss: OK
[   17.097151] Testing event rdev_flush_pmksa: OK
[   17.105251] Testing event rdev_add_station: OK
[   17.113136] Testing event rdev_change_station: OK
[   17.121257] Testing event rdev_del_station: OK
[   17.129144] Testing event rdev_get_station: OK
[   17.137247] Testing event rdev_del_mpath: OK
[   17.145146] Testing event rdev_set_wds_peer: OK
[   17.153250] Testing event rdev_dump_station: OK
[   17.161146] Testing event rdev_return_int_station_info: OK
[   17.169256] Testing event rdev_add_mpath: OK
[   17.177159] Testing event rdev_change_mpath: OK
[   17.185252] Testing event rdev_get_mpath: OK
[   17.193152] Testing event rdev_dump_mpath: OK
[   17.201249] Testing event rdev_return_int_mpath_info: OK
[   17.209137] Testing event rdev_return_int_mesh_config: OK
[   17.217258] Testing event rdev_update_mesh_config: OK
[   17.225148] Testing event rdev_join_mesh: OK
[   17.233250] Testing event rdev_change_bss: OK
[   17.241152] Testing event rdev_set_txq_params: OK
[   17.249249] Testing event rdev_libertas_set_mesh_channel: OK
[   17.257144] Testing event rdev_set_monitor_channel: OK
[   17.265264] Testing event rdev_auth: OK
[   17.273141] Testing event rdev_assoc: OK
[   17.281257] Testing event rdev_deauth: OK
[   17.289155] Testing event rdev_disassoc: OK
[   17.297252] Testing event rdev_mgmt_tx_cancel_wait: OK
[   17.305153] Testing event rdev_set_power_mgmt: OK
[   17.313297] Testing event rdev_connect: OK
[   17.321145] Testing event rdev_set_cqm_rssi_config: OK
[   17.329251] Testing event rdev_set_cqm_txe_config: OK
[   17.337149] Testing event rdev_disconnect: OK
[   17.345260] Testing event rdev_join_ibss: OK
[   17.353148] Testing event rdev_set_wiphy_params: OK
[   17.361259] Testing event rdev_get_tx_power: OK
[   17.369105] Testing event rdev_set_tx_power: OK
[   17.377249] Testing event rdev_return_int_int: OK
[   17.385107] Testing event rdev_set_bitrate_mask: OK
[   17.393252] Testing event rdev_mgmt_frame_register: OK
[   17.401144] Testing event rdev_return_int_tx_rx: OK
[   17.409258] Testing event rdev_return_void_tx_rx: OK
[   17.417152] Testing event rdev_set_ringparam: OK
[   17.425251] Testing event rdev_set_antenna: OK
[   17.433163] Testing event rdev_sched_scan_start: OK
[   17.441249] Testing event rdev_tdls_mgmt: OK
[   17.449143] Testing event rdev_dump_survey: OK
[   17.457260] Testing event rdev_return_int_survey_info: OK
[   17.465145] Testing event rdev_tdls_oper: OK
[   17.473259] Testing event rdev_probe_client: OK
[   17.481148] Testing event rdev_set_pmksa: OK
[   17.489210] Testing event rdev_del_pmksa: OK
[   17.497103] Testing event rdev_remain_on_channel: OK
[   17.505258] Testing event rdev_return_int_cookie: OK
[   17.513192] Testing event rdev_cancel_remain_on_channel: OK
[   17.521247] Testing event rdev_mgmt_tx: OK
[   17.529153] Testing event rdev_set_noack_map: OK
[   17.537249] Testing event rdev_get_et_sset_count: OK
[   17.545159] Testing event rdev_get_et_strings: OK
[   17.553254] Testing event rdev_get_channel: OK
[   17.561157] Testing event rdev_return_chandef: OK
[   17.569255] Testing event rdev_start_p2p_device: OK
[   17.577141] Testing event rdev_stop_p2p_device: OK
[   17.585290] Testing event cfg80211_return_bool: OK
[   17.593221] Testing event cfg80211_notify_new_peer_candidate: OK
[   17.601268] Testing event cfg80211_send_rx_auth: OK
[   17.609144] Testing event cfg80211_send_rx_assoc: OK
[   17.617246] Testing event __cfg80211_send_deauth: OK
[   17.625155] Testing event __cfg80211_send_disassoc: OK
[   17.633249] Testing event cfg80211_send_unprot_deauth: OK
[   17.641143] Testing event cfg80211_send_unprot_disassoc: OK
[   17.649255] Testing event cfg80211_send_auth_timeout: OK
[   17.657145] Testing event cfg80211_send_assoc_timeout: OK
[   17.665250] Testing event cfg80211_michael_mic_failure: OK
[   17.673152] Testing event cfg80211_ready_on_channel: OK
[   17.681252] Testing event cfg80211_ready_on_channel_expired: OK
[   17.689159] Testing event cfg80211_new_sta: OK
[   17.697243] Testing event cfg80211_del_sta: OK
[   17.705144] Testing event cfg80211_rx_mgmt: OK
[   17.713240] Testing event cfg80211_mgmt_tx_status: OK
[   17.721148] Testing event cfg80211_cqm_rssi_notify: OK
[   17.729262] Testing event cfg80211_reg_can_beacon: OK
[   17.737146] Testing event cfg80211_ch_switch_notify: OK
[   17.745253] Testing event cfg80211_ibss_joined: OK
[   17.753158] Testing event cfg80211_rx_spurious_frame: OK
[   17.761253] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[   17.769148] Testing event cfg80211_probe_status: OK
[   17.777250] Testing event cfg80211_cqm_pktloss_notify: OK
[   17.785146] Testing event cfg80211_gtk_rekey_notify: OK
[   17.793254] Testing event cfg80211_pmksa_candidate_notify: OK
[   17.801146] Testing event cfg80211_report_obss_beacon: OK
[   17.809250] Testing event cfg80211_tdls_oper_request: OK
[   17.817156] Testing event cfg80211_scan_done: OK
[   17.825251] Testing event cfg80211_sched_scan_results: OK
[   17.833221] Testing event cfg80211_sched_scan_stopped: OK
[   17.841319] Testing event cfg80211_get_bss: OK
[   17.849139] Testing event cfg80211_inform_bss_frame: OK
[   17.857239] Testing event cfg80211_return_bss: OK
[   17.865144] Testing event cfg80211_return_uint: OK
[   17.873203] Testing event cfg80211_return_u32: OK
[   17.881124] Testing event kfree_skb: OK
[   17.889313] Testing event consume_skb: OK
[   17.897157] Testing event skb_copy_datagram_iovec: OK
[   17.905272] Testing event net_dev_xmit: OK
[   17.913165] Testing event net_dev_queue: OK
[   17.921260] Testing event netif_receive_skb: OK
[   17.929158] Testing event netif_rx: OK
[   17.937266] Testing event napi_poll: OK
[   17.945197] Testing event sock_rcvqueue_full: OK
[   17.953261] Testing event sock_exceed_buf_limit: OK
[   17.961165] Testing event udp_fail_queue_rcv_skb: OK
[   17.969223] Testing event scsi_dispatch_cmd_start: OK
[   17.977158] Testing event scsi_dispatch_cmd_error: OK
[   17.985278] Testing event scsi_dispatch_cmd_done: OK
[   17.993155] Testing event scsi_dispatch_cmd_timeout: OK
[   18.001263] Testing event scsi_eh_wakeup: OK
[   18.009171] Testing event regmap_reg_write: OK
[   18.017261] Testing event regmap_reg_read: OK
[   18.025158] Testing event regmap_reg_read_cache: OK
[   18.033266] Testing event regmap_hw_read_start: OK
[   18.041162] Testing event regmap_hw_read_done: OK
[   18.049264] Testing event regmap_hw_write_start: OK
[   18.057163] Testing event regmap_hw_write_done: OK
[   18.065264] Testing event regcache_sync: OK
[   18.073158] Testing event regmap_cache_only: OK
[   18.081266] Testing event regmap_cache_bypass: OK
[   18.089159] Testing event mix_pool_bytes: OK
[   18.097268] Testing event mix_pool_bytes_nolock: OK
[   18.105164] Testing event credit_entropy_bits: OK
[   18.113269] Testing event get_random_bytes: OK
[   18.121159] Testing event extract_entropy: OK
[   18.129266] Testing event extract_entropy_user: OK
[   18.137145] Testing event gpio_direction: OK
[   18.145262] Testing event gpio_value: OK
[   18.153162] Testing event block_rq_abort: OK
[   18.161265] Testing event block_rq_requeue: OK
[   18.169157] Testing event block_rq_complete: OK
[   18.177275] Testing event block_rq_insert: OK
[   18.185158] Testing event block_rq_issue: OK
[   18.193262] Testing event block_bio_bounce: OK
[   18.201163] Testing event block_bio_complete: OK
[   18.209221] Testing event block_bio_backmerge: OK
[   18.217154] Testing event block_bio_frontmerge: OK
[   18.225274] Testing event block_bio_queue: OK
[   18.233156] Testing event block_getrq: OK
[   18.241272] Testing event block_sleeprq: OK
[   18.249164] Testing event block_plug: OK
[   18.257265] Testing event block_unplug: OK
[   18.265166] Testing event block_split: OK
[   18.273266] Testing event block_bio_remap: OK
[   18.281157] Testing event block_rq_remap: OK
[   18.289218] Testing event btrfs_transaction_commit: OK
[   18.297163] Testing event btrfs_inode_new: OK
[   18.305264] Testing event btrfs_inode_request: OK
[   18.313156] Testing event btrfs_inode_evict: OK
[   18.321267] Testing event btrfs_get_extent: OK
[   18.329162] Testing event btrfs_ordered_extent_add: OK
[   18.337258] Testing event btrfs_ordered_extent_remove: OK
[   18.345162] Testing event btrfs_ordered_extent_start: OK
[   18.353262] Testing event btrfs_ordered_extent_put: OK
[   18.361158] Testing event __extent_writepage: OK
[   18.369276] Testing event btrfs_writepage_end_io_hook: OK
[   18.377157] Testing event btrfs_sync_file: OK
[   18.385261] Testing event btrfs_sync_fs: OK
[   18.393174] Testing event btrfs_delayed_tree_ref: OK
[   18.401265] Testing event btrfs_delayed_data_ref: OK
[   18.409156] Testing event btrfs_delayed_ref_head: OK
[   18.417278] Testing event btrfs_chunk_alloc: OK
[   18.425157] Testing event btrfs_chunk_free: OK
[   18.433262] Testing event btrfs_cow_block: OK
[   18.441161] Testing event btrfs_space_reservation: OK
[   18.449383] Testing event btrfs_reserved_extent_alloc: OK
[   18.457157] Testing event btrfs_reserved_extent_free: OK
[   18.465269] Testing event find_free_extent: OK
[   18.473159] Testing event btrfs_reserve_extent: OK
[   18.481259] Testing event btrfs_reserve_extent_cluster: OK
[   18.489162] Testing event btrfs_find_cluster: OK
[   18.497274] Testing event btrfs_failed_cluster_setup: OK
[   18.505155] Testing event btrfs_setup_cluster: OK
[   18.513268] Testing event alloc_extent_state: OK
[   18.521159] Testing event free_extent_state: OK
[   18.529264] Testing event ocfs2_adjust_rightmost_branch: OK
[   18.537164] Testing event ocfs2_rotate_tree_right: OK
[   18.545273] Testing event ocfs2_append_rec_to_path: OK
[   18.553157] Testing event ocfs2_insert_extent_start: OK
[   18.561292] Testing event ocfs2_add_clusters_in_btree: OK
[   18.569161] Testing event ocfs2_num_free_extents: OK
[   18.577273] Testing event ocfs2_complete_edge_insert: OK
[   18.585169] Testing event ocfs2_grow_tree: OK
[   18.593263] Testing event ocfs2_rotate_subtree: OK
[   18.601158] Testing event ocfs2_insert_extent: OK
[   18.609267] Testing event ocfs2_split_extent: OK
[   18.617158] Testing event ocfs2_remove_extent: OK
[   18.625273] Testing event ocfs2_commit_truncate: OK
[   18.633160] Testing event ocfs2_validate_extent_block: OK
[   18.641264] Testing event ocfs2_rotate_leaf: OK
[   18.649156] Testing event ocfs2_add_clusters_in_btree_ret: OK
[   18.657265] Testing event ocfs2_mark_extent_written: OK
[   18.665156] Testing event ocfs2_truncate_log_append: OK
[   18.673265] Testing event ocfs2_replay_truncate_records: OK
[   18.681163] Testing event ocfs2_flush_truncate_log: OK
[   18.689262] Testing event ocfs2_begin_truncate_log_recovery: OK
[   18.697158] Testing event ocfs2_truncate_log_recovery_num: OK
[   18.705263] Testing event ocfs2_complete_truncate_log_recovery: OK
[   18.713162] Testing event ocfs2_free_cached_blocks: OK
[   18.721265] Testing event ocfs2_cache_cluster_dealloc: OK
[   18.729163] Testing event ocfs2_run_deallocs: OK
[   18.737265] Testing event ocfs2_cache_block_dealloc: OK
[   18.745186] Testing event ocfs2_trim_extent: OK
[   18.753268] Testing event ocfs2_trim_group: OK
[   18.761161] Testing event ocfs2_trim_fs: OK
[   18.769263] Testing event ocfs2_la_set_sizes: OK
[   18.777169] Testing event ocfs2_alloc_should_use_local: OK
[   18.785262] Testing event ocfs2_load_local_alloc: OK
[   18.793158] Testing event ocfs2_begin_local_alloc_recovery: OK
[   18.801268] Testing event ocfs2_reserve_local_alloc_bits: OK
[   18.809156] Testing event ocfs2_local_alloc_count_bits: OK
[   18.817282] Testing event ocfs2_local_alloc_find_clear_bits_search_bitmap: OK
[   18.825165] Testing event ocfs2_local_alloc_find_clear_bits: OK
[   18.833264] Testing event ocfs2_sync_local_to_main: OK
[   18.841156] Testing event ocfs2_sync_local_to_main_free: OK
[   18.849273] Testing event ocfs2_local_alloc_new_window: OK
[   18.857158] Testing event ocfs2_local_alloc_new_window_result: OK
[   18.865259] Testing event ocfs2_update_last_group_and_inode: OK
[   18.873160] Testing event ocfs2_group_extend: OK
[   18.881260] Testing event ocfs2_group_add: OK
[   18.889156] Testing event ocfs2_validate_group_descriptor: OK
[   18.897267] Testing event ocfs2_block_group_alloc_contig: OK
[   18.905157] Testing event ocfs2_block_group_alloc_discontig: OK
[   18.913270] Testing event ocfs2_block_group_alloc: OK
[   18.921162] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
[   18.929261] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
[   18.937156] Testing event ocfs2_reserve_new_inode_new_group: OK
[   18.945270] Testing event ocfs2_block_group_set_bits: OK
[   18.953154] Testing event ocfs2_relink_block_group: OK
[   18.961262] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
[   18.969171] Testing event ocfs2_cluster_group_search_max_block: OK
[   18.977259] Testing event ocfs2_block_group_search_max_block: OK
[   18.985161] Testing event ocfs2_search_chain_begin: OK
[   18.993267] Testing event ocfs2_search_chain_succ: OK
[   19.001155] Testing event ocfs2_search_chain_end: OK
[   19.009262] Testing event ocfs2_claim_suballoc_bits: OK
[   19.017162] Testing event ocfs2_claim_new_inode_at_loc: OK
[   19.025262] Testing event ocfs2_block_group_clear_bits: OK
[   19.033178] Testing event ocfs2_free_suballoc_bits: OK
[   19.041267] Testing event ocfs2_free_clusters: OK
[   19.049155] Testing event ocfs2_get_suballoc_slot_bit: OK
[   19.057264] Testing event ocfs2_test_suballoc_bit: OK
[   19.065138] Testing event ocfs2_test_inode_bit: OK
[   19.073271] Testing event ocfs2_validate_refcount_block: OK
[   19.081158] Testing event ocfs2_purge_refcount_trees: OK
[   19.089266] Testing event ocfs2_create_refcount_tree: OK
[   19.097156] Testing event ocfs2_create_refcount_tree_blkno: OK
[   19.105263] Testing event ocfs2_change_refcount_rec: OK
[   19.113165] Testing event ocfs2_expand_inline_ref_root: OK
[   19.121269] Testing event ocfs2_divide_leaf_refcount_block: OK
[   19.129155] Testing event ocfs2_new_leaf_refcount_block: OK
[   19.137268] Testing event ocfs2_insert_refcount_rec: OK
[   19.145157] Testing event ocfs2_split_refcount_rec: OK
[   19.153264] Testing event ocfs2_split_refcount_rec_insert: OK
[   19.161153] Testing event ocfs2_increase_refcount_begin: OK
[   19.169264] Testing event ocfs2_increase_refcount_change: OK
[   19.177155] Testing event ocfs2_increase_refcount_insert: OK
[   19.185267] Testing event ocfs2_increase_refcount_split: OK
[   19.193158] Testing event ocfs2_remove_refcount_extent: OK
[   19.201272] Testing event ocfs2_restore_refcount_block: OK
[   19.209169] Testing event ocfs2_decrease_refcount_rec: OK
[   19.217264] Testing event ocfs2_decrease_refcount: OK
[   19.225157] Testing event ocfs2_mark_extent_refcounted: OK
[   19.233265] Testing event ocfs2_calc_refcount_meta_credits: OK
[   19.241158] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
[   19.249257] Testing event ocfs2_add_refcount_flag: OK
[   19.257165] Testing event ocfs2_prepare_refcount_change_for_del: OK
[   19.265263] Testing event ocfs2_lock_refcount_allocators: OK
[   19.273164] Testing event ocfs2_duplicate_clusters_by_page: OK
[   19.281270] Testing event ocfs2_duplicate_clusters_by_jbd: OK
[   19.289120] Testing event ocfs2_clear_ext_refcount: OK
[   19.297258] Testing event ocfs2_replace_clusters: OK
[   19.305160] Testing event ocfs2_make_clusters_writable: OK
[   19.313261] Testing event ocfs2_refcount_cow_hunk: OK
[   19.321157] Testing event ocfs2_symlink_get_block: OK
[   19.329277] Testing event ocfs2_get_block: OK
[   19.337159] Testing event ocfs2_get_block_end: OK
[   19.345261] Testing event ocfs2_readpage: OK
[   19.353161] Testing event ocfs2_writepage: OK
[   19.361265] Testing event ocfs2_bmap: OK
[   19.369164] Testing event ocfs2_try_to_write_inline_data: OK
[   19.377264] Testing event ocfs2_write_begin_nolock: OK
[   19.385156] Testing event ocfs2_write_end_inline: OK
[   19.393264] Testing event ocfs2_fault: OK
[   19.401168] Testing event ocfs2_file_open: OK
[   19.409264] Testing event ocfs2_file_release: OK
[   19.417171] Testing event ocfs2_sync_file: OK
[   19.425267] Testing event ocfs2_file_aio_write: OK
[   19.433156] Testing event ocfs2_file_splice_write: OK
[   19.441258] Testing event ocfs2_file_splice_read: OK
[   19.449163] Testing event ocfs2_file_aio_read: OK
[   19.457271] Testing event ocfs2_truncate_file: OK
[   19.465156] Testing event ocfs2_truncate_file_error: OK
[   19.473268] Testing event ocfs2_extend_allocation: OK
[   19.481156] Testing event ocfs2_extend_allocation_end: OK
[   19.489260] Testing event ocfs2_write_zero_page: OK
[   19.497176] Testing event ocfs2_zero_extend_range: OK
[   19.505265] Testing event ocfs2_zero_extend: OK
[   19.513156] Testing event ocfs2_setattr: OK
[   19.521275] Testing event ocfs2_write_remove_suid: OK
[   19.529168] Testing event ocfs2_zero_partial_clusters: OK
[   19.537265] Testing event ocfs2_zero_partial_clusters_range1: OK
[   19.545173] Testing event ocfs2_zero_partial_clusters_range2: OK
[   19.553264] Testing event ocfs2_remove_inode_range: OK
[   19.561156] Testing event ocfs2_prepare_inode_for_write: OK
[   19.569269] Testing event generic_file_aio_read_ret: OK
[   19.577153] Testing event ocfs2_iget_begin: OK
[   19.585270] Testing event ocfs2_iget5_locked: OK
[   19.593161] Testing event ocfs2_iget_end: OK
[   19.601262] Testing event ocfs2_find_actor: OK
[   19.609159] Testing event ocfs2_populate_inode: OK
[   19.617262] Testing event ocfs2_read_locked_inode: OK
[   19.625168] Testing event ocfs2_check_orphan_recovery_state: OK
[   19.633265] Testing event ocfs2_validate_inode_block: OK
[   19.641160] Testing event ocfs2_inode_is_valid_to_delete: OK
[   19.649270] Testing event ocfs2_query_inode_wipe_begin: OK
[   19.657161] Testing event ocfs2_query_inode_wipe_succ: OK
[   19.665266] Testing event ocfs2_query_inode_wipe_end: OK
[   19.673160] Testing event ocfs2_cleanup_delete_inode: OK
[   19.681260] Testing event ocfs2_delete_inode: OK
[   19.689161] Testing event ocfs2_clear_inode: OK
[   19.697265] Testing event ocfs2_drop_inode: OK
[   19.705146] Testing event ocfs2_inode_revalidate: OK
[   19.713254] Testing event ocfs2_mark_inode_dirty: OK
[   19.721156] Testing event ocfs2_read_virt_blocks: OK
[   19.729261] Testing event ocfs2_refresh_slot_info: OK
[   19.737171] Testing event ocfs2_map_slot_buffers: OK
[   19.745264] Testing event ocfs2_map_slot_buffers_block: OK
[   19.753155] Testing event ocfs2_find_slot: OK
[   19.761264] Testing event ocfs2_do_node_down: OK
[   19.769157] Testing event ocfs2_remount: OK
[   19.777278] Testing event ocfs2_fill_super: OK
[   19.785165] Testing event ocfs2_parse_options: OK
[   19.793264] Testing event ocfs2_put_super: OK
[   19.801159] Testing event ocfs2_statfs: OK
[   19.809273] Testing event ocfs2_dismount_volume: OK
[   19.817167] Testing event ocfs2_initialize_super: OK
[   19.825267] Testing event ocfs2_validate_xattr_block: OK
[   19.833163] Testing event ocfs2_xattr_extend_allocation: OK
[   19.841261] Testing event ocfs2_init_xattr_set_ctxt: OK
[   19.849155] Testing event ocfs2_xattr_bucket_find: OK
[   19.857271] Testing event ocfs2_xattr_index_block_find: OK
[   19.865165] Testing event ocfs2_xattr_index_block_find_rec: OK
[   19.873261] Testing event ocfs2_iterate_xattr_buckets: OK
[   19.881161] Testing event ocfs2_iterate_xattr_bucket: OK
[   19.889262] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
[   19.897156] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
[   19.905275] Testing event ocfs2_xattr_create_index_block_begin: OK
[   19.913162] Testing event ocfs2_xattr_create_index_block: OK
[   19.921262] Testing event ocfs2_defrag_xattr_bucket: OK
[   19.929162] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
[   19.937265] Testing event ocfs2_divide_xattr_bucket_begin: OK
[   19.945160] Testing event ocfs2_divide_xattr_bucket_move: OK
[   19.953271] Testing event ocfs2_cp_xattr_bucket: OK
[   19.961156] Testing event ocfs2_mv_xattr_buckets: OK
[   19.969262] Testing event ocfs2_adjust_xattr_cross_cluster: OK
[   19.977160] Testing event ocfs2_add_new_xattr_cluster_begin: OK
[   19.985262] Testing event ocfs2_add_new_xattr_cluster: OK
[   19.993165] Testing event ocfs2_add_new_xattr_cluster_insert: OK
[   20.001269] Testing event ocfs2_extend_xattr_bucket: OK
[   20.009162] Testing event ocfs2_add_new_xattr_bucket: OK
[   20.017259] Testing event ocfs2_xattr_bucket_value_truncate: OK
[   20.025161] Testing event ocfs2_rm_xattr_cluster: OK
[   20.033271] Testing event ocfs2_reflink_xattr_header: OK
[   20.041155] Testing event ocfs2_create_empty_xattr_block: OK
[   20.049268] Testing event ocfs2_xattr_set_entry_bucket: OK
[   20.057157] Testing event ocfs2_xattr_set_entry_index_block: OK
[   20.065261] Testing event ocfs2_xattr_bucket_value_refcount: OK
[   20.073162] Testing event ocfs2_reflink_xattr_buckets: OK
[   20.081264] Testing event ocfs2_reflink_xattr_rec: OK
[   20.089157] Testing event ocfs2_resv_insert: OK
[   20.097265] Testing event ocfs2_resmap_find_free_bits_begin: OK
[   20.105157] Testing event ocfs2_resmap_find_free_bits_end: OK
[   20.113261] Testing event ocfs2_resv_find_window_begin: OK
[   20.121170] Testing event ocfs2_resv_find_window_prev: OK
[   20.129262] Testing event ocfs2_resv_find_window_next: OK
[   20.137158] Testing event ocfs2_cannibalize_resv_begin: OK
[   20.145271] Testing event ocfs2_cannibalize_resv_end: OK
[   20.153155] Testing event ocfs2_resmap_resv_bits: OK
[   20.161273] Testing event ocfs2_resmap_claimed_bits_begin: OK
[   20.169164] Testing event ocfs2_resmap_claimed_bits_end: OK
[   20.177257] Testing event ocfs2_recover_local_quota_file: OK
[   20.185167] Testing event ocfs2_finish_quota_recovery: OK
[   20.193267] Testing event olq_set_dquot: OK
[   20.201155] Testing event ocfs2_validate_quota_block: OK
[   20.209266] Testing event ocfs2_sync_dquot: OK
[   20.217166] Testing event ocfs2_sync_dquot_helper: OK
[   20.225265] Testing event ocfs2_write_dquot: OK
[   20.233155] Testing event ocfs2_release_dquot: OK
[   20.241268] Testing event ocfs2_acquire_dquot: OK
[   20.249160] Testing event ocfs2_mark_dquot_dirty: OK
[   20.257263] Testing event ocfs2_search_dirblock: OK
[   20.265161] Testing event ocfs2_validate_dir_block: OK
[   20.273268] Testing event ocfs2_find_entry_el: OK
[   20.281156] Testing event ocfs2_dx_dir_search: OK
[   20.289278] Testing event ocfs2_dx_dir_search_leaf_info: OK
[   20.297222] Testing event ocfs2_delete_entry_dx: OK
[   20.305325] Testing event ocfs2_readdir: OK
[   20.313160] Testing event ocfs2_find_files_on_disk: OK
[   20.321550] Testing event ocfs2_check_dir_for_entry: OK
[   20.329132] Testing event ocfs2_dx_dir_attach_index: OK
[   20.337268] Testing event ocfs2_dx_dir_format_cluster: OK
[   20.345158] Testing event ocfs2_dx_dir_index_root_block: OK
[   20.353267] Testing event ocfs2_extend_dir: OK
[   20.361169] Testing event ocfs2_dx_dir_rebalance: OK
[   20.369266] Testing event ocfs2_dx_dir_rebalance_split: OK
[   20.377158] Testing event ocfs2_prepare_dir_for_insert: OK
[   20.385267] Testing event ocfs2_lookup: OK
[   20.393158] Testing event ocfs2_mkdir: OK
[   20.401261] Testing event ocfs2_create: OK
[   20.409162] Testing event ocfs2_unlink: OK
[   20.417268] Testing event ocfs2_symlink_create: OK
[   20.425159] Testing event ocfs2_mv_orphaned_inode_to_new: OK
[   20.433266] Testing event ocfs2_lookup_ret: OK
[   20.441168] Testing event ocfs2_mknod: OK
[   20.449268] Testing event ocfs2_link: OK
[   20.457160] Testing event ocfs2_unlink_noent: OK
[   20.465264] Testing event ocfs2_double_lock: OK
[   20.473155] Testing event ocfs2_double_lock_end: OK
[   20.481271] Testing event ocfs2_rename: OK
[   20.489162] Testing event ocfs2_rename_target_exists: OK
[   20.497261] Testing event ocfs2_rename_disagree: OK
[   20.505161] Testing event ocfs2_rename_over_existing: OK
[   20.513264] Testing event ocfs2_create_symlink_data: OK
[   20.521157] Testing event ocfs2_symlink_begin: OK
[   20.529268] Testing event ocfs2_blkno_stringify: OK
[   20.537165] Testing event ocfs2_orphan_add_begin: OK
[   20.545289] Testing event ocfs2_orphan_add_end: OK
[   20.553162] Testing event ocfs2_orphan_del: OK
[   20.561266] Testing event ocfs2_dentry_revalidate: OK
[   20.569165] Testing event ocfs2_dentry_revalidate_negative: OK
[   20.577268] Testing event ocfs2_dentry_revalidate_delete: OK
[   20.585155] Testing event ocfs2_dentry_revalidate_orphaned: OK
[   20.593263] Testing event ocfs2_dentry_revalidate_nofsdata: OK
[   20.601162] Testing event ocfs2_dentry_revalidate_ret: OK
[   20.609263] Testing event ocfs2_find_local_alias: OK
[   20.617155] Testing event ocfs2_dentry_attach_lock: OK
[   20.625272] Testing event ocfs2_dentry_attach_lock_found: OK
[   20.633156] Testing event ocfs2_get_dentry_begin: OK
[   20.641263] Testing event ocfs2_get_dentry_test_bit: OK
[   20.649161] Testing event ocfs2_get_dentry_stale: OK
[   20.657266] Testing event ocfs2_get_dentry_generation: OK
[   20.665156] Testing event ocfs2_get_dentry_end: OK
[   20.673277] Testing event ocfs2_get_parent: OK
[   20.681156] Testing event ocfs2_get_parent_end: OK
[   20.689262] Testing event ocfs2_encode_fh_begin: OK
[   20.697116] Testing event ocfs2_encode_fh_self: OK
[   20.705257] Testing event ocfs2_encode_fh_parent: OK
[   20.713163] Testing event ocfs2_encode_fh_type: OK
[   20.721273] Testing event ocfs2_commit_cache_begin: OK
[   20.729157] Testing event ocfs2_commit_cache_end: OK
[   20.737270] Testing event ocfs2_extend_trans: OK
[   20.745161] Testing event ocfs2_extend_trans_restart: OK
[   20.753265] Testing event ocfs2_journal_access: OK
[   20.761164] Testing event ocfs2_journal_dirty: OK
[   20.769271] Testing event ocfs2_journal_init: OK
[   20.777155] Testing event ocfs2_journal_init_maxlen: OK
[   20.785262] Testing event ocfs2_journal_shutdown: OK
[   20.793160] Testing event ocfs2_journal_shutdown_wait: OK
[   20.801263] Testing event ocfs2_complete_recovery: OK
[   20.809157] Testing event ocfs2_complete_recovery_end: OK
[   20.817272] Testing event ocfs2_complete_recovery_slot: OK
[   20.825156] Testing event ocfs2_recovery_thread_node: OK
[   20.833261] Testing event ocfs2_recovery_thread_end: OK
[   20.841162] Testing event ocfs2_recovery_thread: OK
[   20.849268] Testing event ocfs2_replay_journal_recovered: OK
[   20.857158] Testing event ocfs2_replay_journal_lock_err: OK
[   20.865279] Testing event ocfs2_replay_journal_skip: OK
[   20.873154] Testing event ocfs2_recover_node: OK
[   20.881262] Testing event ocfs2_recover_node_skip: OK
[   20.889170] Testing event ocfs2_mark_dead_nodes: OK
[   20.897265] Testing event ocfs2_queue_orphan_scan_begin: OK
[   20.905162] Testing event ocfs2_queue_orphan_scan_end: OK
[   20.913267] Testing event ocfs2_orphan_filldir: OK
[   20.921142] Testing event ocfs2_recover_orphans: OK
[   20.929273] Testing event ocfs2_recover_orphans_iput: OK
[   20.937147] Testing event ocfs2_wait_on_mount: OK
[   20.945249] Testing event ocfs2_read_blocks_sync: OK
[   20.953155] Testing event ocfs2_read_blocks_sync_jbd: OK
[   20.961256] Testing event ocfs2_read_blocks_from_disk: OK
[   20.969149] Testing event ocfs2_read_blocks_bh: OK
[   20.977250] Testing event ocfs2_read_blocks_end: OK
[   20.985147] Testing event ocfs2_write_block: OK
[   20.993270] Testing event ocfs2_read_blocks_begin: OK
[   21.001143] Testing event ocfs2_purge_copied_metadata_tree: OK
[   21.009258] Testing event ocfs2_metadata_cache_purge: OK
[   21.017153] Testing event ocfs2_buffer_cached_begin: OK
[   21.025250] Testing event ocfs2_buffer_cached_end: OK
[   21.033153] Testing event ocfs2_append_cache_array: OK
[   21.041253] Testing event ocfs2_insert_cache_tree: OK
[   21.049143] Testing event ocfs2_expand_cache: OK
[   21.057256] Testing event ocfs2_set_buffer_uptodate: OK
[   21.065144] Testing event ocfs2_set_buffer_uptodate_begin: OK
[   21.073249] Testing event ocfs2_remove_metadata_array: OK
[   21.081147] Testing event ocfs2_remove_metadata_tree: OK
[   21.089260] Testing event ocfs2_remove_block_from_cache: OK
[   21.097144] Testing event xfs_attr_list_sf: OK
[   21.105255] Testing event xfs_attr_list_sf_all: OK
[   21.113143] Testing event xfs_attr_list_leaf: OK
[   21.121262] Testing event xfs_attr_list_leaf_end: OK
[   21.129151] Testing event xfs_attr_list_full: OK
[   21.137251] Testing event xfs_attr_list_add: OK
[   21.145138] Testing event xfs_attr_list_wrong_blk: OK
[   21.153254] Testing event xfs_attr_list_notfound: OK
[   21.161144] Testing event xfs_attr_leaf_list: OK
[   21.169252] Testing event xfs_attr_node_list: OK
[   21.177159] Testing event xfs_perag_get: OK
[   21.185248] Testing event xfs_perag_get_tag: OK
[   21.193145] Testing event xfs_perag_put: OK
[   21.201258] Testing event xfs_perag_set_reclaim: OK
[   21.209142] Testing event xfs_perag_clear_reclaim: OK
[   21.217250] Testing event xfs_perag_set_eofblocks: OK
[   21.225148] Testing event xfs_perag_clear_eofblocks: OK
[   21.233254] Testing event xfs_attr_list_node_descend: OK
[   21.241142] Testing event xfs_iext_insert: OK
[   21.249266] Testing event xfs_iext_remove: OK
[   21.257144] Testing event xfs_bmap_pre_update: OK
[   21.265253] Testing event xfs_bmap_post_update: OK
[   21.273160] Testing event xfs_extlist: OK
[   21.281251] Testing event xfs_buf_init: OK
[   21.289145] Testing event xfs_buf_free: OK
[   21.297256] Testing event xfs_buf_hold: OK
[   21.305143] Testing event xfs_buf_rele: OK
[   21.313251] Testing event xfs_buf_iodone: OK
[   21.321148] Testing event xfs_buf_iorequest: OK
[   21.329250] Testing event xfs_buf_bawrite: OK
[   21.337099] Testing event xfs_buf_lock: OK
[   21.345259] Testing event xfs_buf_lock_done: OK
[   21.353144] Testing event xfs_buf_trylock: OK
[   21.361250] Testing event xfs_buf_unlock: OK
[   21.369148] Testing event xfs_buf_iowait: OK
[   21.377260] Testing event xfs_buf_iowait_done: OK
[   21.385144] Testing event xfs_buf_delwri_queue: OK
[   21.393255] Testing event xfs_buf_delwri_queued: OK
[   21.401158] Testing event xfs_buf_delwri_split: OK
[   21.409254] Testing event xfs_buf_get_uncached: OK
[   21.417155] Testing event xfs_bdstrat_shut: OK
[   21.425249] Testing event xfs_buf_item_relse: OK
[   21.433143] Testing event xfs_buf_item_iodone: OK
[   21.441257] Testing event xfs_buf_item_iodone_async: OK
[   21.449148] Testing event xfs_buf_error_relse: OK
[   21.457255] Testing event xfs_trans_read_buf_io: OK
[   21.465146] Testing event xfs_trans_read_buf_shut: OK
[   21.473253] Testing event xfs_btree_corrupt: OK
[   21.481261] Testing event xfs_da_btree_corrupt: OK
[   21.489256] Testing event xfs_reset_dqcounts: OK
[   21.497103] Testing event xfs_inode_item_push: OK
[   21.505217] Testing event xfs_buf_find: OK
[   21.513151] Testing event xfs_buf_get: OK
[   21.521251] Testing event xfs_buf_read: OK
[   21.529155] Testing event xfs_buf_ioerror: OK
[   21.537254] Testing event xfs_buf_item_size: OK
[   21.545160] Testing event xfs_buf_item_size_stale: OK
[   21.553250] Testing event xfs_buf_item_format: OK
[   21.561150] Testing event xfs_buf_item_format_stale: OK
[   21.569256] Testing event xfs_buf_item_pin: OK
[   21.577144] Testing event xfs_buf_item_unpin: OK
[   21.585261] Testing event xfs_buf_item_unpin_stale: OK
[   21.593143] Testing event xfs_buf_item_unlock: OK
[   21.601254] Testing event xfs_buf_item_unlock_stale: OK
[   21.609148] Testing event xfs_buf_item_committed: OK
[   21.617250] Testing event xfs_buf_item_push: OK
[   21.625143] Testing event xfs_trans_get_buf: OK
[   21.633266] Testing event xfs_trans_get_buf_recur: OK
[   21.641143] Testing event xfs_trans_getsb: OK
[   21.649250] Testing event xfs_trans_getsb_recur: OK
[   21.657149] Testing event xfs_trans_read_buf: OK
[   21.665251] Testing event xfs_trans_read_buf_recur: OK
[   21.673155] Testing event xfs_trans_log_buf: OK
[   21.681255] Testing event xfs_trans_brelse: OK
[   21.689143] Testing event xfs_trans_bjoin: OK
[   21.697271] Testing event xfs_trans_bhold: OK
[   21.705144] Testing event xfs_trans_bhold_release: OK
[   21.713242] Testing event xfs_trans_binval: OK
[   21.721169] Testing event xfs_ilock: OK
[   21.729259] Testing event xfs_ilock_nowait: OK
[   21.737146] Testing event xfs_ilock_demote: OK
[   21.745253] Testing event xfs_iunlock: OK
[   21.753153] Testing event xfs_iget_skip: OK
[   21.761250] Testing event xfs_iget_reclaim: OK
[   21.769144] Testing event xfs_iget_reclaim_fail: OK
[   21.777256] Testing event xfs_iget_hit: OK
[   21.785147] Testing event xfs_iget_miss: OK
[   21.793251] Testing event xfs_getattr: OK
[   21.801148] Testing event xfs_setattr: OK
[   21.809252] Testing event xfs_readlink: OK
[   21.817152] Testing event xfs_alloc_file_space: OK
[   21.825270] Testing event xfs_free_file_space: OK
[   21.833143] Testing event xfs_readdir: OK
[   21.841255] Testing event xfs_get_acl: OK
[   21.849163] Testing event xfs_vm_bmap: OK
[   21.857266] Testing event xfs_file_ioctl: OK
[   21.865144] Testing event xfs_file_compat_ioctl: OK
[   21.873212] Testing event xfs_ioctl_setattr: OK
[   21.881144] Testing event xfs_dir_fsync: OK
[   21.889257] Testing event xfs_file_fsync: OK
[   21.897151] Testing event xfs_destroy_inode: OK
[   21.905248] Testing event xfs_evict_inode: OK
[   21.913150] Testing event xfs_update_time: OK
[   21.921255] Testing event xfs_dquot_dqalloc: OK
[   21.929103] Testing event xfs_dquot_dqdetach: OK
[   21.937210] Testing event xfs_inode_set_eofblocks_tag: OK
[   21.945153] Testing event xfs_inode_clear_eofblocks_tag: OK
[   21.953261] Testing event xfs_inode_free_eofblocks_invalid: OK
[   21.961144] Testing event xfs_ihold: OK
[   21.969256] Testing event xfs_irele: OK
[   21.977430] Testing event xfs_inode_pin: OK
[   21.985251] Testing event xfs_inode_unpin: OK
[   21.993154] Testing event xfs_inode_unpin_nowait: OK
[   22.001259] Testing event xfs_remove: OK
[   22.009143] Testing event xfs_link: OK
[   22.017259] Testing event xfs_lookup: OK
[   22.025144] Testing event xfs_create: OK
[   22.033253] Testing event xfs_symlink: OK
[   22.041148] Testing event xfs_rename: OK
[   22.049250] Testing event xfs_dqadjust: OK
[   22.057099] Testing event xfs_dqreclaim_want: OK
[   22.065214] Testing event xfs_dqreclaim_dirty: OK
[   22.073102] Testing event xfs_dqreclaim_busy: OK
[   22.081219] Testing event xfs_dqreclaim_done: OK
[   22.089133] Testing event xfs_dqattach_found: OK
[   22.097207] Testing event xfs_dqattach_get: OK
[   22.105115] Testing event xfs_dqalloc: OK
[   22.113213] Testing event xfs_dqtobp_read: OK
[   22.121102] Testing event xfs_dqread: OK
[   22.129207] Testing event xfs_dqread_fail: OK
[   22.137108] Testing event xfs_dqget_hit: OK
[   22.145218] Testing event xfs_dqget_miss: OK
[   22.153099] Testing event xfs_dqget_freeing: OK
[   22.161218] Testing event xfs_dqget_dup: OK
[   22.169102] Testing event xfs_dqput: OK
[   22.177206] Testing event xfs_dqput_wait: OK
[   22.185106] Testing event xfs_dqput_free: OK
[   22.193207] Testing event xfs_dqrele: OK
[   22.201102] Testing event xfs_dqflush: OK
[   22.209226] Testing event xfs_dqflush_force: OK
[   22.217103] Testing event xfs_dqflush_done: OK
[   22.225208] Testing event xfs_log_done_nonperm: OK
[   22.233162] Testing event xfs_log_done_perm: OK
[   22.241252] Testing event xfs_log_umount_write: OK
[   22.249143] Testing event xfs_log_grant_sleep: OK
[   22.257255] Testing event xfs_log_grant_wake: OK
[   22.265144] Testing event xfs_log_grant_wake_up: OK
[   22.273269] Testing event xfs_log_reserve: OK
[   22.281148] Testing event xfs_log_reserve_exit: OK
[   22.289250] Testing event xfs_log_regrant: OK
[   22.297145] Testing event xfs_log_regrant_exit: OK
[   22.305258] Testing event xfs_log_regrant_reserve_enter: OK
[   22.313143] Testing event xfs_log_regrant_reserve_exit: OK
[   22.321248] Testing event xfs_log_regrant_reserve_sub: OK
[   22.329151] Testing event xfs_log_ungrant_enter: OK
[   22.337262] Testing event xfs_log_ungrant_exit: OK
[   22.345144] Testing event xfs_log_ungrant_sub: OK
[   22.353257] Testing event xfs_log_force: OK
[   22.361160] Testing event xfs_ail_push: OK
[   22.369252] Testing event xfs_ail_pinned: OK
[   22.377152] Testing event xfs_ail_locked: OK
[   22.385250] Testing event xfs_ail_flushing: OK
[   22.393143] Testing event xfs_file_read: OK
[   22.401268] Testing event xfs_file_buffered_write: OK
[   22.409148] Testing event xfs_file_direct_write: OK
[   22.417257] Testing event xfs_file_splice_read: OK
[   22.425146] Testing event xfs_file_splice_write: OK
[   22.433250] Testing event xfs_writepage: OK
[   22.441145] Testing event xfs_releasepage: OK
[   22.449258] Testing event xfs_invalidatepage: OK
[   22.457145] Testing event xfs_map_blocks_found: OK
[   22.465254] Testing event xfs_map_blocks_alloc: OK
[   22.473152] Testing event xfs_get_blocks_found: OK
[   22.481255] Testing event xfs_get_blocks_alloc: OK
[   22.489158] Testing event xfs_delalloc_enospc: OK
[   22.497260] Testing event xfs_unwritten_convert: OK
[   22.505144] Testing event xfs_get_blocks_notfound: OK
[   22.513247] Testing event xfs_setfilesize: OK
[   22.521151] Testing event xfs_itruncate_extents_start: OK
[   22.529263] Testing event xfs_itruncate_extents_end: OK
[   22.537144] Testing event xfs_pagecache_inval: OK
[   22.545225] Testing event xfs_bunmap: OK
[   22.553152] Testing event xfs_extent_busy: OK
[   22.561251] Testing event xfs_extent_busy_enomem: OK
[   22.569148] Testing event xfs_extent_busy_force: OK
[   22.577251] Testing event xfs_extent_busy_reuse: OK
[   22.585142] Testing event xfs_extent_busy_clear: OK
[   22.593253] Testing event xfs_extent_busy_trim: OK
[   22.601144] Testing event xfs_trans_commit_lsn: OK
[   22.609206] Testing event xfs_agf: OK
[   22.617159] Testing event xfs_free_extent: OK
[   22.625254] Testing event xfs_alloc_exact_done: OK
[   22.633143] Testing event xfs_alloc_exact_notfound: OK
[   22.641255] Testing event xfs_alloc_exact_error: OK
[   22.649145] Testing event xfs_alloc_near_nominleft: OK
[   22.657250] Testing event xfs_alloc_near_first: OK
[   22.665170] Testing event xfs_alloc_near_greater: OK
[   22.673252] Testing event xfs_alloc_near_lesser: OK
[   22.681158] Testing event xfs_alloc_near_error: OK
[   22.689255] Testing event xfs_alloc_near_noentry: OK
[   22.697146] Testing event xfs_alloc_near_busy: OK
[   22.705249] Testing event xfs_alloc_size_neither: OK
[   22.713138] Testing event xfs_alloc_size_noentry: OK
[   22.721264] Testing event xfs_alloc_size_nominleft: OK
[   22.729143] Testing event xfs_alloc_size_done: OK
[   22.737260] Testing event xfs_alloc_size_error: OK
[   22.745144] Testing event xfs_alloc_size_busy: OK
[   22.753259] Testing event xfs_alloc_small_freelist: OK
[   22.761148] Testing event xfs_alloc_small_notenough: OK
[   22.769248] Testing event xfs_alloc_small_done: OK
[   22.777145] Testing event xfs_alloc_small_error: OK
[   22.785261] Testing event xfs_alloc_vextent_badargs: OK
[   22.793145] Testing event xfs_alloc_vextent_nofix: OK
[   22.801256] Testing event xfs_alloc_vextent_noagbp: OK
[   22.809163] Testing event xfs_alloc_vextent_loopfailed: OK
[   22.817261] Testing event xfs_alloc_vextent_allfailed: OK
[   22.825147] Testing event xfs_dir2_sf_addname: OK
[   22.833260] Testing event xfs_dir2_sf_create: OK
[   22.841143] Testing event xfs_dir2_sf_lookup: OK
[   22.849332] Testing event xfs_dir2_sf_replace: OK
[   22.857191] Testing event xfs_dir2_sf_removename: OK
[   22.865257] Testing event xfs_dir2_sf_toino4: OK
[   22.873108] Testing event xfs_dir2_sf_toino8: OK
[   22.881224] Testing event xfs_dir2_sf_to_block: OK
[   22.889152] Testing event xfs_dir2_block_addname: OK
[   22.897256] Testing event xfs_dir2_block_lookup: OK
[   22.905152] Testing event xfs_dir2_block_replace: OK
[   22.913262] Testing event xfs_dir2_block_removename: OK
[   22.921156] Testing event xfs_dir2_block_to_sf: OK
[   22.929258] Testing event xfs_dir2_block_to_leaf: OK
[   22.937144] Testing event xfs_dir2_leaf_addname: OK
[   22.945253] Testing event xfs_dir2_leaf_lookup: OK
[   22.953162] Testing event xfs_dir2_leaf_replace: OK
[   22.961251] Testing event xfs_dir2_leaf_removename: OK
[   22.969144] Testing event xfs_dir2_leaf_to_block: OK
[   22.977267] Testing event xfs_dir2_leaf_to_node: OK
[   22.985152] Testing event xfs_dir2_node_addname: OK
[   22.993263] Testing event xfs_dir2_node_lookup: OK
[   23.001156] Testing event xfs_dir2_node_replace: OK
[   23.009262] Testing event xfs_dir2_node_removename: OK
[   23.017158] Testing event xfs_dir2_node_to_leaf: OK
[   23.029176] Testing event xfs_attr_sf_add: OK
[   23.037233] Testing event xfs_attr_sf_addname: OK
[   23.049264] Testing event xfs_attr_sf_create: OK
[   23.061164] Testing event xfs_attr_sf_lookup: OK
[   23.073325] Testing event xfs_attr_sf_remove: OK
[   23.085228] Testing event xfs_attr_sf_removename: OK
[   23.097185] Testing event xfs_attr_sf_to_leaf: OK
[   23.109314] Testing event xfs_attr_leaf_add: OK
[   23.121163] Testing event xfs_attr_leaf_add_old: OK
[   23.133267] Testing event xfs_attr_leaf_add_new: OK
[   23.145231] Testing event xfs_attr_leaf_add_work: OK
[   23.157249] Testing event xfs_attr_leaf_addname: OK
[   23.169230] Testing event xfs_attr_leaf_create: OK
[   23.181231] Testing event xfs_attr_leaf_compact: OK
[   23.193286] Testing event xfs_attr_leaf_get: OK
[   23.205227] Testing event xfs_attr_leaf_lookup: OK
[   23.217309] Testing event xfs_attr_leaf_replace: OK
[   23.229270] Testing event xfs_attr_leaf_remove: OK
[   23.241227] Testing event xfs_attr_leaf_removename: OK
[   23.253281] Testing event xfs_attr_leaf_split: OK
[   23.265230] Testing event xfs_attr_leaf_split_before: OK
[   23.277165] Testing event xfs_attr_leaf_split_after: OK
[   23.289229] Testing event xfs_attr_leaf_clearflag: OK
[   23.301230] Testing event xfs_attr_leaf_setflag: OK
[   23.313228] Testing event xfs_attr_leaf_flipflags: OK
[   23.325261] Testing event xfs_attr_leaf_to_sf: OK
[   23.337228] Testing event xfs_attr_leaf_to_node: OK
[   23.349225] Testing event xfs_attr_leaf_rebalance: OK
[   23.361316] Testing event xfs_attr_leaf_unbalance: OK
[   23.373162] Testing event xfs_attr_leaf_toosmall: OK
[   23.385303] Testing event xfs_attr_node_addname: OK
[   23.397234] Testing event xfs_attr_node_get: OK
[   23.409224] Testing event xfs_attr_node_lookup: OK
[   23.421198] Testing event xfs_attr_node_replace: OK
[   23.433229] Testing event xfs_attr_node_removename: OK
[   23.445256] Testing event xfs_attr_fillstate: OK
[   23.457226] Testing event xfs_attr_refillstate: OK
[   23.469260] Testing event xfs_attr_rmtval_get: OK
[   23.481229] Testing event xfs_attr_rmtval_set: OK
[   23.493236] Testing event xfs_attr_rmtval_remove: OK
[   23.505226] Testing event xfs_da_split: OK
[   23.517239] Testing event xfs_da_join: OK
[   23.529308] Testing event xfs_da_link_before: OK
[   23.541226] Testing event xfs_da_link_after: OK
[   23.553324] Testing event xfs_da_unlink_back: OK
[   23.565225] Testing event xfs_da_unlink_forward: OK
[   23.577166] Testing event xfs_da_root_split: OK
[   23.589287] Testing event xfs_da_root_join: OK
[   23.601237] Testing event xfs_da_node_add: OK
[   23.613249] Testing event xfs_da_node_create: OK
[   23.625231] Testing event xfs_da_node_split: OK
[   23.637315] Testing event xfs_da_node_remove: OK
[   23.649226] Testing event xfs_da_node_rebalance: OK
[   23.661170] Testing event xfs_da_node_unbalance: OK
[   23.673223] Testing event xfs_da_node_toosmall: OK
[   23.685332] Testing event xfs_da_swap_lastblock: OK
[   23.697330] Testing event xfs_da_grow_inode: OK
[   23.709158] Testing event xfs_da_shrink_inode: OK
[   23.721277] Testing event xfs_da_fixhashpath: OK
[   23.733335] Testing event xfs_da_path_shift: OK
[   23.745267] Testing event xfs_dir2_leafn_add: OK
[   23.757222] Testing event xfs_dir2_leafn_remove: OK
[   23.769325] Testing event xfs_dir2_grow_inode: OK
[   23.781226] Testing event xfs_dir2_shrink_inode: OK
[   23.793245] Testing event xfs_dir2_leafn_moveents: OK
[   23.805245] Testing event xfs_swap_extent_before: OK
[   23.817235] Testing event xfs_swap_extent_after: OK
[   23.829245] Testing event xfs_log_recover_item_add: OK
[   23.841226] Testing event xfs_log_recover_item_add_cont: OK
[   23.853267] Testing event xfs_log_recover_item_reorder_head: OK
[   23.865224] Testing event xfs_log_recover_item_reorder_tail: OK
[   23.877322] Testing event xfs_log_recover_item_recover: OK
[   23.889331] Testing event xfs_log_recover_buf_not_cancel: OK
[   23.901224] Testing event xfs_log_recover_buf_cancel: OK
[   23.913288] Testing event xfs_log_recover_buf_cancel_add: OK
[   23.925223] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   23.937330] Testing event xfs_log_recover_buf_recover: OK
[   23.949285] Testing event xfs_log_recover_buf_inode_buf: OK
[   23.961228] Testing event xfs_log_recover_buf_reg_buf: OK
[   23.973243] Testing event xfs_log_recover_buf_dquot_buf: OK
[   23.985227] Testing event xfs_log_recover_inode_recover: OK
[   23.997323] Testing event xfs_log_recover_inode_cancel: OK
[   24.009232] Testing event xfs_log_recover_inode_skip: OK
[   24.021282] Testing event xfs_discard_extent: OK
[   24.033229] Testing event xfs_discard_toosmall: OK
[   24.045242] Testing event xfs_discard_exclude: OK
[   24.057225] Testing event xfs_discard_busy: OK
[   24.069232] Testing event jbd2_checkpoint: OK
[   24.081248] Testing event jbd2_start_commit: OK
[   24.093226] Testing event jbd2_commit_locking: OK
[   24.105335] Testing event jbd2_commit_flushing: OK
[   24.117222] Testing event jbd2_commit_logging: OK
[   24.129273] Testing event jbd2_drop_transaction: OK
[   24.141223] Testing event jbd2_end_commit: OK
[   24.153270] Testing event jbd2_submit_inode_data: OK
[   24.165242] Testing event jbd2_run_stats: OK
[   24.177226] Testing event jbd2_checkpoint_stats: OK
[   24.189227] Testing event jbd2_update_log_tail: OK
[   24.201224] Testing event jbd2_write_superblock: OK
[   24.213235] Testing event ext4_free_inode: OK
[   24.225223] Testing event ext4_request_inode: OK
[   24.237310] Testing event ext4_allocate_inode: OK
[   24.249225] Testing event ext4_evict_inode: OK
[   24.261224] Testing event ext4_drop_inode: OK
[   24.273258] Testing event ext4_mark_inode_dirty: OK
[   24.285225] Testing event ext4_begin_ordered_truncate: OK
[   24.297269] Testing event ext4_write_begin: OK
[   24.309225] Testing event ext4_da_write_begin: OK
[   24.321263] Testing event ext4_ordered_write_end: OK
[   24.333222] Testing event ext4_writeback_write_end: OK
[   24.345337] Testing event ext4_journalled_write_end: OK
[   24.357309] Testing event ext4_da_write_end: OK
[   24.369223] Testing event ext4_da_writepages: OK
[   24.381273] Testing event ext4_da_write_pages: OK
[   24.393227] Testing event ext4_da_writepages_result: OK
[   24.405322] Testing event ext4_writepage: OK
[   24.417237] Testing event ext4_readpage: OK
[   24.429235] Testing event ext4_releasepage: OK
[   24.441226] Testing event ext4_invalidatepage: OK
[   24.453291] Testing event ext4_discard_blocks: OK
[   24.465227] Testing event ext4_mb_new_inode_pa: OK
[   24.477306] Testing event ext4_mb_new_group_pa: OK
[   24.489240] Testing event ext4_mb_release_inode_pa: OK
[   24.501225] Testing event ext4_mb_release_group_pa: OK
[   24.513284] Testing event ext4_discard_preallocations: OK
[   24.525267] Testing event ext4_mb_discard_preallocations: OK
[   24.537223] Testing event ext4_request_blocks: OK
[   24.549271] Testing event ext4_allocate_blocks: OK
[   24.561163] Testing event ext4_free_blocks: OK
[   24.573262] Testing event ext4_sync_file_enter: OK
[   24.585228] Testing event ext4_sync_file_exit: OK
[   24.597245] Testing event ext4_sync_fs: OK
[   24.609160] Testing event ext4_alloc_da_blocks: OK
[   24.625238] Testing event ext4_mballoc_alloc: OK
[   24.637221] Testing event ext4_mballoc_prealloc: OK
[   24.649214] Testing event ext4_mballoc_discard: OK
[   24.661221] Testing event ext4_mballoc_free: OK
[   24.673220] Testing event ext4_forget: OK
[   24.685315] Testing event ext4_da_update_reserve_space: OK
[   24.697250] Testing event ext4_da_reserve_space: OK
[   24.709221] Testing event ext4_da_release_space: OK
[   24.721228] Testing event ext4_mb_bitmap_load: OK
[   24.733219] Testing event ext4_mb_buddy_bitmap_load: OK
[   24.745273] Testing event ext4_read_block_bitmap_load: OK
[   24.757221] Testing event ext4_load_inode_bitmap: OK
[   24.769286] Testing event ext4_direct_IO_enter: OK
[   24.781226] Testing event ext4_direct_IO_exit: OK
[   24.793218] Testing event ext4_fallocate_enter: OK
[   24.805282] Testing event ext4_fallocate_exit: OK
[   24.817228] Testing event ext4_unlink_enter: OK
[   24.829242] Testing event ext4_unlink_exit: OK
[   24.841219] Testing event ext4_truncate_enter: OK
[   24.853298] Testing event ext4_truncate_exit: OK
[   24.865257] Testing event ext4_ext_convert_to_initialized_enter: OK
[   24.877309] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   24.889161] Testing event ext4_ext_map_blocks_enter: OK
[   24.901224] Testing event ext4_ind_map_blocks_enter: OK
[   24.913336] Testing event ext4_ext_map_blocks_exit: OK
[   24.925225] Testing event ext4_ind_map_blocks_exit: OK
[   24.937254] Testing event ext4_ext_load_extent: OK
[   24.949220] Testing event ext4_load_inode: OK
[   24.961284] Testing event ext4_journal_start: OK
[   24.973269] Testing event ext4_trim_extent: OK
[   24.985162] Testing event ext4_trim_all_free: OK
[   24.997251] Testing event ext4_ext_handle_uninitialized_extents: OK
[   25.009276] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   25.021311] Testing event ext4_ext_put_in_cache: OK
[   25.033290] Testing event ext4_ext_in_cache: OK
[   25.045159] Testing event ext4_find_delalloc_range: OK
[   25.057191] Testing event ext4_get_reserved_cluster_alloc: OK
[   25.069221] Testing event ext4_ext_show_extent: OK
[   25.081223] Testing event ext4_remove_blocks: OK
[   25.093230] Testing event ext4_ext_rm_leaf: OK
[   25.105223] Testing event ext4_ext_rm_idx: OK
[   25.117229] Testing event ext4_ext_remove_space: OK
[   25.129223] Testing event ext4_ext_remove_space_done: OK
[   25.141227] Testing event ext4_es_insert_extent: OK
[   25.153220] Testing event ext4_es_remove_extent: OK
[   25.165230] Testing event ext4_es_find_extent_enter: OK
[   25.177219] Testing event ext4_es_find_extent_exit: OK
[   25.189247] Testing event writeback_nothread: OK
[   25.201220] Testing event writeback_queue: OK
[   25.213222] Testing event writeback_exec: OK
[   25.225221] Testing event writeback_start: OK
[   25.237256] Testing event writeback_written: OK
[   25.249220] Testing event writeback_wait: OK
[   25.261162] Testing event writeback_pages_written: OK
[   25.273218] Testing event writeback_nowork: OK
[   25.285221] Testing event writeback_wake_background: OK
[   25.297155] Testing event writeback_wake_thread: OK
[   25.309312] Testing event writeback_wake_forker_thread: OK
[   25.321302] Testing event writeback_bdi_register: OK
[   25.333226] Testing event writeback_bdi_unregister: OK
[   25.345276] Testing event writeback_thread_start: OK
[   25.357220] Testing event writeback_thread_stop: OK
[   25.369244] Testing event wbc_writepage: OK
[   25.381222] Testing event writeback_queue_io: OK
[   25.393249] Testing event global_dirty_state: OK
[   25.405222] Testing event bdi_dirty_ratelimit: OK
[   25.417229] Testing event balance_dirty_pages: OK
[   25.429282] Testing event writeback_sb_inodes_requeue: OK
[   25.441221] Testing event writeback_congestion_wait: OK
[   25.453312] Testing event writeback_wait_iff_congested: OK
[   25.465214] Testing event writeback_single_inode: OK
[   25.477234] Testing event mm_migrate_pages: OK
[   25.489229] Testing event mm_compaction_isolate_migratepages: OK
[   25.501325] Testing event mm_compaction_isolate_freepages: OK
[   25.513295] Testing event mm_compaction_migratepages: OK
[   25.525221] Testing event kmalloc: OK
[   25.537227] Testing event kmem_cache_alloc: OK
[   25.549216] Testing event kmalloc_node: OK
[   25.561213] Testing event kmem_cache_alloc_node: OK
[   25.573208] Testing event kfree: OK
[   25.585217] Testing event kmem_cache_free: OK
[   25.597159] Testing event mm_page_free: OK
[   25.609215] Testing event mm_page_free_batched: OK
[   25.621287] Testing event mm_page_alloc: OK
[   25.633216] Testing event mm_page_alloc_zone_locked: OK
[   25.645308] Testing event mm_page_pcpu_drain: OK
[   25.657213] Testing event mm_page_alloc_extfrag: OK
[   25.673280] Testing event mm_vmscan_kswapd_sleep: OK
[   25.685259] Testing event mm_vmscan_kswapd_wake: OK
[   25.697321] Testing event mm_vmscan_wakeup_kswapd: OK
[   25.709269] Testing event mm_vmscan_direct_reclaim_begin: OK
[   25.721308] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   25.733173] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   25.745194] Testing event mm_vmscan_direct_reclaim_end: OK
[   25.757234] Testing event mm_vmscan_memcg_reclaim_end: OK
[   25.769173] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   25.781256] Testing event mm_shrink_slab_start: OK
[   25.793212] Testing event mm_shrink_slab_end: OK
[   25.805314] Testing event mm_vmscan_lru_isolate: OK
[   25.817250] Testing event mm_vmscan_memcg_isolate: OK
[   25.829173] Testing event mm_vmscan_writepage: OK
[   25.841249] Testing event mm_vmscan_lru_shrink_inactive: OK
[   25.853216] Testing event oom_score_adj_update: OK
[   25.865260] Testing event rpm_suspend: OK
[   25.877215] Testing event rpm_resume: OK
[   25.889217] Testing event rpm_idle: OK
[   25.901211] Testing event rpm_return_int: OK
[   25.913173] Testing event cpu_idle: OK
[   25.925259] Testing event cpu_frequency: OK
[   25.937170] Testing event machine_suspend: OK
[   25.949215] Testing event wakeup_source_activate: OK
[   25.961170] Testing event wakeup_source_deactivate: OK
[   25.973268] Testing event power_start: OK
[   25.985303] Testing event power_frequency: OK
[   25.997171] Testing event power_end: OK
[   26.009194] Testing event clock_enable: OK
[   26.021171] Testing event clock_disable: OK
[   26.033114] Testing event clock_set_rate: OK
[   26.045108] Testing event power_domain_target: OK
[   26.057204] Testing event ftrace_test_filter: OK
[   26.069172] Testing event lock_acquire: OK
[   26.081241] Testing event lock_release: OK
[   26.093329] Testing event sched_kthread_stop: OK
[   26.105266] Testing event sched_kthread_stop_ret: OK
[   26.117232] Testing event sched_wakeup: OK
[   26.129173] Testing event sched_wakeup_new: OK
[   26.141218] Testing event sched_switch: OK
[   26.153170] Testing event sched_migrate_task: OK
[   26.165185] Testing event sched_process_free: OK
[   26.177218] Testing event sched_process_exit: OK
[   26.189219] Testing event sched_wait_task: OK
[   26.201173] Testing event sched_process_wait: OK
[   26.213313] Testing event sched_process_fork: OK
[   26.225213] Testing event sched_process_exec: OK
[   26.237242] Testing event sched_stat_wait: OK
[   26.249176] Testing event sched_stat_sleep: OK
[   26.261223] Testing event sched_stat_iowait: OK
[   26.273252] Testing event sched_stat_blocked: OK
[   26.285231] Testing event sched_stat_runtime: OK
[   26.297224] Testing event sched_pi_setprio: OK
[   26.309219] Testing event rcu_utilization: OK
[   26.321170] Testing event workqueue_queue_work: OK
[   26.333525] Testing event workqueue_activate_work: OK
[   26.345269] Testing event workqueue_execute_start: OK
[   26.357276] Testing event workqueue_execute_end: OK
[   26.369320] Testing event signal_generate: OK
[   26.381213] Testing event signal_deliver: OK
[   26.393311] Testing event timer_init: OK
[   26.405212] Testing event timer_start: OK
[   26.417265] Testing event timer_expire_entry: OK
[   26.429328] Testing event timer_expire_exit: OK
[   26.441158] Testing event timer_cancel: OK
[   26.453323] Testing event hrtimer_init: OK
[   26.465157] Testing event hrtimer_start: OK
[   26.477223] Testing event hrtimer_expire_entry: OK
[   26.489213] Testing event hrtimer_expire_exit: OK
[   26.501248] Testing event hrtimer_cancel: OK
[   26.513217] Testing event itimer_state: OK
[   26.525215] Testing event itimer_expire: OK
[   26.537299] Testing event irq_handler_entry: OK
[   26.549260] Testing event irq_handler_exit: OK
[   26.561194] Testing event softirq_entry: OK
[   26.573211] Testing event softirq_exit: OK
[   26.585322] Testing event softirq_raise: OK
[   26.597218] Testing event console: OK
[   26.609215] Testing event task_newtask: OK
[   26.621213] Testing event task_rename: OK
[   26.633218] Testing event sys_enter: OK
[   26.645387] Testing event sys_exit: OK
[   26.657325] Running tests on trace event systems:
[   26.658094] Testing event system raw_syscalls: OK
[   26.674769] Testing event system task: OK
[   26.690655] Testing event system printk: OK
[   26.705749] Testing event system irq: OK
[   26.725351] Testing event system timer: OK
[   26.763489] Testing event system signal: OK
[   26.774592] Testing event system workqueue: OK
[   26.792319] Testing event system rcu: OK
[   26.805713] Testing event system sched: OK
[   26.852916] Testing event system lock: OK
[   26.866807] Testing event system test: OK
[   26.881707] Testing event system power: OK
[   26.919241] Testing event system rpm: OK
[   26.936491] Testing event system oom: OK
[   26.949760] Testing event system vmscan: OK
[   26.994049] Testing event system kmem: OK
[   27.027418] Testing event system compaction: OK
[   27.039429] Testing event system migrate: OK
[   27.053750] Testing event system writeback: OK
[   27.114846] Testing event system ext4: OK
[   27.309650] Testing event system jbd2: OK
[   27.343570] Testing event system xfs: OK
[   28.545768] Testing event system ocfs2: OK
[   29.712179] Testing event system btrfs: OK
[   29.781132] Testing event system block: OK
[   29.824203] Testing event system gpio: OK
[   29.834574] Testing event system random: OK
[   29.858185] Testing event system regmap: OK
[   29.893792] Testing event system scsi: OK
[   29.909293] Testing event system syscalls: OK
[   29.929708] Testing event system udp: OK
[   29.941705] Testing event system sock: OK
[   29.958684] Testing event system napi: OK
[   29.973792] Testing event system net: OK
[   29.992459] Testing event system skb: OK
[   30.011548] Testing event system cfg80211: OK
[   30.332939] Running tests on all trace events:
[   30.333685] Testing all events: OK
[   37.284688] Testing ftrace filter: OK
[   37.286675] console [netcon0] enabled
[   37.287201] netconsole: network logging started
[   37.287883] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   37.290064] debug: unmapping init [mem 0x79ddd000-0x79e55fff]
[   37.291771] Write protecting the kernel text: 8884k
[   37.292749] Write protecting the kernel read-only data: 4504k
mountall: Event failed
[   37.683784] init: Failed to create pty - disabling logging for job
[   37.685051] init: Temporary process spawn error: No such file or directory
mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [2338] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
[   37.725332] init: Failed to create pty - disabling logging for job
[   37.726407] init: Temporary process spawn error: No such file or directory
[   37.826220] init: Failed to create pty - disabling logging for job
[   37.827318] init: Temporary process spawn error: No such file or directory
[   37.837276] init: Failed to create pty - disabling logging for job
[   37.838359] init: Temporary process spawn error: No such file or directory
[   38.049558] init: Failed to create pty - disabling logging for job
[   38.050686] init: Temporary process spawn error: No such file or directory
[   38.061014] init: Failed to create pty - disabling logging for job
[   38.062117] init: Temporary process spawn error: No such file or directory
[   38.084769] init: Failed to create pty - disabling logging for job
[   38.085883] init: Temporary process spawn error: No such file or directory
[   38.112972] init: Failed to create pty - disabling logging for job
[   38.114070] init: Temporary process spawn error: No such file or directory
[   38.136368] init: plymouth-log main process (2374) terminated with status 1
[   38.160339] init: Failed to create pty - disabling logging for job
[   38.161426] init: Temporary process spawn error: No such file or directory
udevd[2380]: error: runtime directory '/run/udev' not writable, for now falling back to '/dev/.udev'
[   38.218668] init: Failed to create pty - disabling logging for job
[   38.219779] init: Temporary process spawn error: No such file or directory
[   38.228767] udevd[2383]: starting version 175
[   38.241402] init: Failed to create pty - disabling logging for job
[   38.242482] init: Temporary process spawn error: No such file or directory
[   38.265076] init: Failed to create pty - disabling logging for job
[   38.266203] init: Temporary process spawn error: No such file or directory
[   38.437215] 
[   38.437457] ===============================
[   38.438047] [ INFO: suspicious RCU usage. ]
[   38.438635] 3.8.0-rc1-00184-gfb97c3e #24 Not tainted
[   38.439333] -------------------------------
[   38.439938] /c/kernel-tests/src/i386/net/wireless/reg.c:144 suspicious rcu_dereference_protected() usage!
[   38.444094] 
[   38.444094] other info that might help us debug this:
[   38.444094] 
[   38.445209] 
[   38.445209] rcu_scheduler_active = 1, debug_locks = 0
[   38.446120] 2 locks held by udevadm/2386:
[   38.446684]  #0:  (&buffer->mutex#2){+.+.+.}, at: [<791038ec>] sysfs_write_file+0x29/0xeb
[   38.447962]  #1:  (s_active#10){++++.+}, at: [<7910395e>] sysfs_write_file+0x9b/0xeb
[   38.453032] 
[   38.453032] stack backtrace:
[   38.453649] Pid: 2386, comm: udevadm Not tainted 3.8.0-rc1-00184-gfb97c3e #24
[   38.454650] Call Trace:
[   38.455017]  [<7905f645>] lockdep_rcu_suspicious+0xe3/0xeb
[   38.455800]  [<7986010b>] get_last_request+0x43/0x4a
[   38.463378]  [<79860374>] reg_device_uevent+0x13/0x51
[   38.464199]  [<794c2984>] ? platform_uevent+0x2a/0x2e
[   38.464915]  [<794bfb7b>] dev_uevent+0x12d/0x135
[   38.465569]  [<793c1b80>] ? add_uevent_var+0x4a/0xa3
[   38.466270]  [<794bfa4e>] ? device_get_devnode+0xaf/0xaf
[   38.467024]  [<793c1d4d>] kobject_uevent_env+0x174/0x3f6
[   38.467772]  [<793c1b14>] ? kobject_action_type+0x43/0x65
[   38.472095]  [<793c1fd9>] kobject_uevent+0xa/0xd
[   38.472757]  [<794c02d0>] store_uevent+0x2a/0x45
[   38.473409]  [<794c02a6>] ? dev_err+0x2f/0x2f
[   38.474030]  [<794be9a5>] dev_attr_store+0x1d/0x29
[   38.474708]  [<79103974>] sysfs_write_file+0xb1/0xeb
[   38.475412]  [<791038c3>] ? sysfs_poll+0x7a/0x7a
[   38.483120]  [<790bfce3>] vfs_write+0x74/0xad
[   38.483744]  [<790bfdbe>] sys_write+0x3d/0x65
[   38.484473]  [<798ac02b>] sysenter_do_call+0x12/0x3c
[   39.172207] init: Failed to create pty - disabling logging for job
[   39.173336] init: Temporary process spawn error: No such file or directory
[   39.219280] init: Failed to create pty - disabling logging for job
[   39.220387] init: Temporary process spawn error: No such file or directory
[   39.356196] init: network-interface (irlan0) pre-start process (2467) terminated with status 1
[   39.372851] init: network-interface (eql) pre-start process (2468) terminated with status 1
[   39.404607] init: Failed to create pty - disabling logging for job
[   39.405749] init: Temporary process spawn error: No such file or directory
[   39.475740] init: Failed to create pty - disabling logging for job
[   39.477006] init: Temporary process spawn error: No such file or directory
[   39.508348] init: network-interface (irlan0) post-stop process (2474) terminated with status 1
[   39.517690] init: network-interface (eql) post-stop process (2475) terminated with status 1
[   39.531634] init: network-interface (lo) pre-start process (2469) terminated with status 1
[   39.613192] init: network-interface (lo) post-stop process (2485) terminated with status 1
[   39.867961] init: Failed to create pty - disabling logging for job
[   39.869637] init: Temporary process spawn error: No such file or directory
[   39.897207] init: Failed to create pty - disabling logging for job
[   39.898318] init: Temporary process spawn error: No such file or directory
[   39.930015] init: Failed to create pty - disabling logging for job
[   39.931177] init: Temporary process spawn error: No such file or directory
[   39.968322] init: udev-fallback-graphics main process (2489) terminated with status 1
[   39.971337] init: Failed to create pty - disabling logging for job
[   39.972516] init: Temporary process spawn error: No such file or directory
[   40.004114] init: plymouth-splash main process (2497) terminated with status 1
[   40.022701] init: networking main process (2495) terminated with status 1

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fb97c3e-bisect.log"
Content-Transfer-Encoding: quoted-printable

git checkout e7f767a7d9f809c494bfffffeda2bbdbfec110b4

2013-01-14-10:29:40 e7f767a7d9f809c494bfffffeda2bbdbfec110b4 compiling
/home/wfg/tip

2013-01-14-10:30:53 detecting boot state 3.8.0-rc1-bisect2-00139-ge7f767a #=
2 ..1......2................................... TEST FAILURE
bisect: bad commit e7f767a7d9f809c494bfffffeda2bbdbfec110b4
git checkout v3.7

2013-01-14-10:32:12 29594404d7fe73cd80eaa4ee8c43dcc53970c60e compiling
/home/wfg/tip

2013-01-14-10:35:14 detecting boot state 3.7.0-bisect2 #3 .................=
=2E..1..23..456............................................................=
=2E...............OK ..78..................................................=
=2E...............................OK ..91011...............................=
=2E..............................................OK ..OK .12...............=
=2E................................................................OK .1314=
=2E........................................................................=
=2E....OK ..1516...........................................................=
=2E...............OK .OK 1718OK .OK 19OK 2021..............................=
=2E.........................................OK .OK .22OK 23OK 24OK .2526...=
=2E........................................................................=
=2E.OK 27OK 2829OK .30.....................................................=
=2E.................OK .31.OK 32OK 33OK 3435...............................=
=2E.....................................OK 36..OK 37OK 38OK 39OK 40........=
=2E........................................................OK .41.OK  SUCCE=
SS
bisect: good commit v3.7
git bisect start e7f767a7d9f809c494bfffffeda2bbdbfec110b4 v3.7 --
Bisecting: 5968 revisions left to test after this (roughly 13 steps)
[4378bb695670e65ca4aeee1e7588cfa2381351a5] microblaze: signal: Declare do_n=
otify_resume
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-10:58:57 4378bb695670e65ca4aeee1e7588cfa2381351a5 compiling
/home/wfg/tip

2013-01-14-11:01:27 detecting boot state 3.7.0-bisect2-01810-g4378bb6 #4 ..=
=2E.......................................12.34..5.67......................=
=2E....................................................OK .8OK .9OK 10..OK =
11OK .OK 12OK 1314.........................................................=
=2E...............OK .15OK 16.OK .OK 17...OK 18OK 19OK 20..................=
=2E..................................................OK 21.OK 22..OK 2324..=
=2EOK 25OK 2627...OK 28....................................................=
=2E..........OK 29...OK .30.OK .OK 3132..OK 33OK .OK 3435..................=
=2E.............................................OK 36.......OK 3738.OK  SUC=
CESS
Bisecting: 3081 revisions left to test after this (roughly 12 steps)
[027c0a6af42efa4f2f6034421349bd26a3ca4923] ARM: imx: Move platform-mx2-emma=
 to arch/arm/mach-imx/devices
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-11:13:31 027c0a6af42efa4f2f6034421349bd26a3ca4923 compiling
/home/wfg/tip

2013-01-14-11:16:01 detecting boot state 3.7.0-bisect2-00003-g027c0a6 #5 ..=
=2E......................................................1........2..3...4.=
567.............................................................OK .8......=
=2EOK 9..OK .10.OK .11OK 12..OK .13OK 1415.................................=
=2E.....................OK .16.......OK .17.....OK 18.OK .OK 19OK 20OK 21OK=
 2223OK 24OK 25......................................................OK 26.=
=2E.......OK 27........OK 28OK 2930OK 31.OK .OK 3233OK .OK 34..............=
=2E............................OK 35.......OK .36........OK 37..OK  SUCCESS
Bisecting: 1499 revisions left to test after this (roughly 11 steps)
[2d4dce0070448bcb5ccd04553a4be4635417f565] Merge tag 'nfs-for-3.8-1' of git=
://git.linux-nfs.org/projects/trondmy/linux-nfs
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-11:26:06 2d4dce0070448bcb5ccd04553a4be4635417f565 compiling
/home/wfg/tip

2013-01-14-11:28:34 detecting boot state 3.7.0-bisect2-01582-g2d4dce0 #6 ..=
=2E..................................1.....2.............345..6...OK .78OK =
9...............................................OK 10....OK .11............=
OK .OK 1213OK 14..OK 15...OK 16OK 17OK 18..................................=
=2E............OK .19.....OK .20...........OK .OK 2122.OK 23.OK 24..OK 25OK=
 .OK 2627...OK .28.........................................OK .29....OK 30.=
=2E..........OK .OK 3132...OK .33OK 34...OK 35OK .OK  SUCCESS
Bisecting: 735 revisions left to test after this (roughly 10 steps)
[1ffab3d4139533eff6e27b7568825307e575faa6] Merge tag 'fixes' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/arm/arm-soc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-11:36:27 1ffab3d4139533eff6e27b7568825307e575faa6 compiling
/home/wfg/tip

2013-01-14-11:38:58 detecting boot state 3.7.0-bisect2-00061-g1ffab3d #7 ..=
=2E.......................1......2.............34.....5.6.7.89.....10......=
=2E.................................OK .11.....OK 12.......................=
=2E.......................OK .1314................OK 15.....OK .16.........=
=2E.........................................OK .OK 1718.................OK =
19.........OK .20.......................................................OK =
=2E21....OK .22.........OK 23..............................................=
=2E............OK 2425OK .OK 2627....OK 28...OK 29.........................=
=2E..................................OK .30.OK .31.OK ..32.OK .33..........=
=2E.............................................................OK .34.OK .=
35OK .OK 3637.OK .38.OK .39................................................=
=2E....................OK .40.OK .OK  SUCCESS
Bisecting: 368 revisions left to test after this (roughly 9 steps)
[f59dc2bb5a50b26ea751f9eac1c81e4cc7de5257] Merge branch 'fixes' of git://gi=
t.linaro.org/people/rmk/linux-arm
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-11:55:22 f59dc2bb5a50b26ea751f9eac1c81e4cc7de5257 compiling
/home/wfg/tip

2013-01-14-11:57:25 detecting boot state 3.7.0-bisect2-00294-gf59dc2b #8 12=
=2E...345..................................................................=
=2E.OK 6......OK 78OK .OK 910.OK .11OK .OK 12OK .13........................=
=2E......................................OK .14.....OK .1516OK 1718..OK 19O=
K .OK 20OK 2122............................................................=
=2E..OK .23......OK 2425OK .OK 26....OK .OK 27OK 28OK .29..................=
=2E..........................................OK .30......OK .31OK .OK 3233.=
=2E.OK .OK 34OK  SUCCESS
Bisecting: 166 revisions left to test after this (roughly 8 steps)
[b49249d10324d0fd6fb29725c2807dfd80d0edbc] Merge tag 'dm-3.8-fixes' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:05:55 b49249d10324d0fd6fb29725c2807dfd80d0edbc compiling
/home/wfg/tip

2013-01-14-12:08:28 detecting boot state 3.7.0-bisect2-00496-gb49249d #9 ..=
=2E.......................................1.........2.34..56.7.8...........=
=2E...........................................OK 9..........OK .10OK .OK 11=
OK 1213.OK .OK 1415OK 16.OK 17.............................................=
=2E..........OK 18.........OK .19..OK 20OK .21OK .22.OK .OK 23OK 2425......=
=2E..............................................OK 26.........OK .27..OK 2=
8..OK .OK 2930OK .31OK 32OK 33.OK 34.......................................=
=2E.............OK 35............OK .36.....OK .OK  SUCCESS
Bisecting: 83 revisions left to test after this (roughly 6 steps)
[b08fbbd8ade1fe3eea821a65b98d9f6a828329da] mac80211: restrict assoc request=
 VHT capabilities
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:18:18 b08fbbd8ade1fe3eea821a65b98d9f6a828329da compiling
/home/wfg/tip

2013-01-14-12:19:33 detecting boot state 3.8.0-rc1-bisect2-00055-gb08fbbd #=
10 ......1..............2......3..45..6..7............. TEST FAILURE
Bisecting: 41 revisions left to test after this (roughly 5 steps)
[0f6dfcee2e081f47a3e97cb8984fb4d62217e6f7] wireless: more 'capability info'=
 bits
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:20:57 0f6dfcee2e081f47a3e97cb8984fb4d62217e6f7 compiling
/home/wfg/tip

2013-01-14-12:22:12 detecting boot state 3.8.0-rc1-bisect2-00013-g0f6dfce #=
11 .1...........2......3...45.67..89.......................................=
=2E.........OK 10..........OK .11..OK 12...OK .13OK .14OK 15..OK 1617......=
=2E............................................OK 18..........OK .19..OK .2=
0..OK .21OK .OK 2223..OK 24OK 2526.........................................=
=2E........OK .27..........OK 28......OK 29...OK .30OK 3132OK 33OK 3435....=
=2E...........................................OK .36..........OK 37........=
=2E.OK .OK 3839OK 40OK .OK 41OK  SUCCESS
Bisecting: 20 revisions left to test after this (roughly 4 steps)
[540f6f2cc545da9ae2baa9faa3152fc550bedb57] regulatory: remove locking from =
wiphy_apply_custom_regulatory
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:31:15 540f6f2cc545da9ae2baa9faa3152fc550bedb57 compiling
/home/wfg/tip

2013-01-14-12:32:29 detecting boot state 3.8.0-rc1-bisect2-00034-g540f6f2 #=
12 .1...........2.........3...4.56.789.....................................=
=2E......OK .10...........OK 11............OK .OK 1213OK 14.OK .15..OK .OK =
1617..........................................OK .18...........OK 19.......=
=2E......OK 2021OK .22.....OK 23OK 242526..................................=
=2E........OK .27...........OK .28..................OK 2930OK .31..OK .OK 3=
233OK 34.......................................OK .35..........OK .36......=
=2E........OK .37OK .38..OK .OK 39OK 40OK 41...............................=
=2E............OK  SUCCESS
Bisecting: 10 revisions left to test after this (roughly 3 steps)
[d45c41722a3eca639ced2c4c93665ced229b1da9] mac82011: use frame control to d=
ifferentiate probe resp/beacon
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:42:45 d45c41722a3eca639ced2c4c93665ced229b1da9 compiling
/home/wfg/tip

2013-01-14-12:43:59 detecting boot state 3.8.0-rc1-bisect2-00044-gd45c417 #=
13 ................................1......2 TEST FAILURE
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[c492db370c17c428a0a58d3673294d4e99634b7d] regulatory: use RCU to protect l=
ast_request
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:45:01 c492db370c17c428a0a58d3673294d4e99634b7d compiling
/home/wfg/tip

2013-01-14-12:46:13 detecting boot state 3.8.0-rc1-bisect2-00039-gc492db3 #=
14 ..1..................2..3.4......56.78.....9...... TEST FAILURE
Bisecting: 2 revisions left to test after this (roughly 1 step)
[fe7ef5e9ba0c60bab01390493a4c6790f7b093af] regulatory: remove handling of c=
hannel bandwidth
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-12:47:30 fe7ef5e9ba0c60bab01390493a4c6790f7b093af compiling
/home/wfg/tip

2013-01-14-12:48:46 detecting boot state 3.8.0-rc1-bisect2-00036-gfe7ef5e #=
15 ...................1..23..4..567....8...................................=
=2E.....OK 9...OK 10.................OK 11..OK .12OK 13..OK .14.OK .15OK 16=
OK .17...OK .18.......................................OK .19..OK 20........=
=2E.......OK .21.OK .22OK .23.OK .24.OK .25.OK .26.OK .27..................=
=2E........................................................................=
=2E.......................OK ............OK .2829..........................=
=2E......................................................OK .3031OK 32OK 33=
34.........................................................................=
=2E...OK .35OK .OK 36OK .3738OK ..3940.....................................=
=2E.....................................OK  SUCCESS
Bisecting: 0 revisions left to test after this (roughly 1 step)
[458f4f9e960b9a3b674c4b87d996eef186b1fe83] regulatory: use RCU to protect g=
lobal and wiphy regdomains
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-01-14-13:03:19 458f4f9e960b9a3b674c4b87d996eef186b1fe83 compiling
/home/wfg/tip

2013-01-14-13:04:38 detecting boot state 3.8.0-rc1-bisect2-00038-g458f4f9 #=
16 ...........................12....3..4567................................=
=2E.....................................OK 8OK 9.......OK .OK 1011OK 12OK .=
OK 13OK 14.................................................................=
=2E.OK .OK 1516......OK .17..OK .OK 18OK 1920OK .OK 2122...................=
=2E...........................................OK .23OK 24.......OK 25..OK .=
OK 2627.OK .OK 2829........................................................=
=2E........OK 30.OK 31.....OK .32.OK .OK 3334.OK .OK  SUCCESS
c492db370c17c428a0a58d3673294d4e99634b7d is the first bad commit
commit c492db370c17c428a0a58d3673294d4e99634b7d
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Dec 6 16:29:25 2012 +0100

    regulatory: use RCU to protect last_request
   =20
    This will allow making freq_reg_info() lock-free.
   =20
    Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

:040000 040000 7fc77a427225f7bbc2deed73a2e2371a62468ff1 10a084fd7b769a0d1ff=
3c174396e5b413bab1041 M	include
:040000 040000 92cbe84babd4445d1fb6f90ce78832e93c577fc3 32672b36221616e6864=
c6a79873e96265614d8da M	net
bisect run success

=3D=3D=3D=3D=3D=3D=3D=3D=3D linux-next =3D=3D=3D=3D=3D=3D=3D=3D=3D

2013-01-14-13:14:03 21841151fca8b548a79b1f72d978da26d5eb1169 compiling
/home/wfg/tip

2013-01-14-13:16:40 detecting boot state 3.8.0-rc3-bisect2-next-20130111 #1=
7 ....................................12.........3..45.6.7.................=
=2E..............................................OK 89........OK .10.OK .11=
OK .OK 12OK 13OK 14OK 1516.................................................=
=2E...........OK .17..OK .18.....OK 19.OK .20.OK .21OK .OK 22OK 23OK .OK 24=
=2E...........................................................OK 25...OK 26=
=2E....OK .27.OK 28....OK .OK 2930.OK 31.OK .32............................=
=2E...............................OK .OK 3334....OK .35.....OK  SUCCESS

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.8.0-rc1 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
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
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_GENERIC_SIGALTSTACK=y
CONFIG_CLONE_BACKWARDS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
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
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
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
CONFIG_BRIDGE_EBT_802_3=y
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_WAN_ROUTER=y
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
CONFIG_CAN_PLX_PCI=y
CONFIG_CAN_TSCAN1=y
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
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

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN544 is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
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

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
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
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_7000FASST=y
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AACRAID=y
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=y
# CONFIG_HYPERV_STORAGE is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
CONFIG_SCSI_GENERIC_NCR53C400=y
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_NCR53C406A=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_PAS16 is not set
CONFIG_SCSI_QLOGIC_FAS=y
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_T128 is not set
CONFIG_SCSI_U14_34F=y
CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
# CONFIG_SCSI_U14_34F_LINKED_COMMANDS is not set
CONFIG_SCSI_U14_34F_MAX_TAGS=8
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_RIONET is not set
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
CONFIG_ARCNET_COM20020_PCI=y
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_EWRK3=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_AT1700 is not set
CONFIG_ETH16I=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
# CONFIG_QLCNIC is not set
CONFIG_QLGE=y
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PPP is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_HYPERV_NET=y
# CONFIG_ISDN is not set

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
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
CONFIG_DTLK=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
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
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_RX51=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_FAIR_SHARE=y
# CONFIG_STEP_WISE is not set
CONFIG_USER_SPACE=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_RDC321X_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=y
# CONFIG_LPC_SCH is not set
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_AS3711=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
# CONFIG_IR_SANYO_DECODER is not set
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
# CONFIG_VIDEO_CX2341X is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
# CONFIG_MEDIA_TUNER_FC0011 is not set
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

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
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_UTILS=y
CONFIG_HYPERV_BALLOON=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_MEMORY is not set
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

#
# Analog to digital converters
#
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
CONFIG_MAX1363=y
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=y
# CONFIG_AD5446 is not set
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

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
# CONFIG_ADIS16136 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
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
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--s2ZSL+KKDSLx8OML--
