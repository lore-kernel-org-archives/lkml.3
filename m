Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3BHF4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:56:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:5167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3BHF4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:56:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,627,1355126400"; 
   d="log'?scan'208";a="284336651"
Date: Fri, 8 Feb 2013 13:56:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: WARNING: at lib/debugobjects.c:261 debug_print_object()
Message-ID: <20130208055605.GA7646@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Stephen,

I got the below oops and the first bad commit is

commit 457583af4aef89d5252769ea290a2acc89e2361f
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Feb 4 18:12:17 2013 +1100

    memory-hotplug: common APIs to support page tables hot-remove fix fix
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I see no direct relationship between the change and oops message,
however I tried two bisects and they both converge to the above
commit.

[   34.746615] cryptomgr_test (42) used greatest stack depth: 6776 bytes left
[   34.802868] ------------[ cut here ]------------
[   34.803941] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
[   34.804548] Hardware name: Bochs
[   34.804548] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
[   34.804548] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc6-09234-g457583a #40
[   34.804548] Call Trace:
[   34.804548]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
[   34.804548]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
[   34.804548]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
[   34.804548]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
[   34.804548]  [<ffffffff8135dbe6>] ? __debug_object_init+0x3d/0x333
[   34.804548]  [<ffffffff8135de91>] __debug_object_init+0x2e8/0x333
[   34.804548]  [<ffffffff8135def0>] debug_object_init+0x14/0x16
[   34.804548]  [<ffffffff813665b4>] __percpu_counter_init+0x6a/0xc8
[   34.804548]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
[   34.804548]  [<ffffffff8284b327>] swap_setup+0x38/0x84
[   34.804548]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
[   34.804548]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
[   34.804548]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
[   34.804548]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
[   34.804548]  [<ffffffff82830689>] ? loglevel+0x31/0x31
[   34.804548]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.804548]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
[   34.804548]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
[   34.804548]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.804548] ---[ end trace 4b830e8d096c7c64 ]---

git bisect start 457583af4aef89d5252769ea290a2acc89e2361f v3.7 --
git bisect good b4c582a92f41417154131083127e24b66cc4b31b  #    10  2013-02-08 11:31:44  serial: xilinx_uartps: get clock rate info from dts
git bisect good 24d32e96c394bb84ca30dc41f8995efb3efa0b2e  #    10  2013-02-08 11:41:36  Merge remote-tracking branch 'sound/for-next'
git bisect good 86159e4b9bc1270344a890d368ab08d91a373c0b  #    10  2013-02-08 11:50:32  Merge remote-tracking branch 'workqueues/for-next'
git bisect good 32165b5ad1f88636cf5b7768cbf33cea74989211  #    10  2013-02-08 11:59:39  Merge remote-tracking branch 'char-misc/char-misc-next'
git bisect good edbbe0c1f464400706358f91d0b9a308e56cf50f  #    10  2013-02-08 12:11:42  Merge remote-tracking branch 'samsung/for-next'
git bisect good c5ec1c273c49037e833f096c4f591abae8c41c01  #    10  2013-02-08 12:20:33  compat: return -EFAULT on error in waitid()
git bisect good e4fde7764bf589399a6060596cca195f3fce15ff  #    10  2013-02-08 12:27:14  get_maintainer.pl: find maintainers for removed files
git bisect good 6710fc9562f4016222677534277ea442ff028ea1  #    10  2013-02-08 12:33:37  hfsplus: add support of manipulation by attributes file
git bisect good 960468a8cda8ab71a846b668a03e85c08f3543c0  #    10  2013-02-08 12:37:42  wait: add wait_event_hrtimeout()
git bisect good 29ce58899628f7c1de594b4c51a57129b9d28dae  #    10  2013-02-08 12:41:41  aio-dont-include-aioh-in-schedh-fix-fix
git bisect good bf5b05d942033ed019a3daef9651ccb172c50a2a  #    10  2013-02-08 12:46:53  block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
git bisect good 04e0961ab478b63f81d6976e50b5642fcfaf80c9  #    10  2013-02-08 12:54:30  aio: fix aio_read_events_ring() types
git bisect good ec32b1df9515509c7ced856ea2f687d0ae51fe27  #    10  2013-02-08 12:59:23  kfifo: fix kfifo_alloc() and kfifo_init()
git bisect good 0e4ef6ad789dc7fedeaf347d013521bffe685480  #    10  2013-02-08 13:03:06  swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
git bisect good 0e4ef6ad789dc7fedeaf347d013521bffe685480  #    30  2013-02-08 13:15:16  swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
git bisect  bad 99ae5387e08311e47931836be5136d9df9e94cb2  #     0  2013-02-08 13:18:32  Add linux-next specific files for 20130205

Thanks,
Fengguang

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-6205-2013-02-05-14-24-00-3.8.0-rc6-09234-g457583a-40"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc6-09234-g457583a (kbuild@hive) (gcc version 4.7.1 (GCC) ) #40 SMP PREEMPT Tue Feb 5 14:18:52 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=next/akpm log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-02-05-14-23-00-next:akpm:457583a-457583a-x86_64-randconfig-h114-4-ant noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-h114/457583a/vmlinuz-3.8.0-rc6-09234-g457583a
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x032a0000, 0x032a0fff] PGTABLE
[    0.000000] BRK [0x032a1000, 0x032a1fff] PGTABLE
[    0.000000] BRK [0x032a2000, 0x032a2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0e8d5fff]
[    0.000000]  [mem 0x0e800000-0x0e8d5fff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e7fffff]
[    0.000000]  [mem 0x0c000000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e8d6000-0x0fffdfff]
[    0.000000]  [mem 0x0e8d6000-0x0e9fffff] page 2M
[    0.000000]  [mem 0x0ea00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x032a3000, 0x032a3fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127584(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0e0b9000-0x0e0d5fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 65409 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff88000de00000 s75264 r0 d23040 u1048576
[    0.000000] pcpu-alloc: s75264 r0 d23040 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64379
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=next/akpm log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-02-05-14-23-00-next:akpm:457583a-457583a-x86_64-randconfig-h114-4-ant noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-h114/457583a/vmlinuz-3.8.0-rc6-09234-g457583a
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 189572k/262136k available (13747k kernel code, 500k absent, 72064k reserved, 10938k data, 1120k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3192.037 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.023234] Calibrating delay loop (skipped), value calculated using timer frequency.. 6384.07 BogoMIPS (lpj=12768148)
[    0.028443] pid_max: default: 32768 minimum: 301
[    0.034407] Security Framework initialized
[    0.049064] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.054471] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.058184] Mount-cache hash table entries: 256
[    0.105285] Initializing cgroup subsys debug
[    0.107188] Initializing cgroup subsys devices
[    0.116306] mce: CPU supports 10 MCE banks
[    0.121215] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.121215] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.121215] tlb_flushall_shift: -1
[    0.136428] Freeing SMP alternatives: 32k freed
[    0.169079] ACPI: Core revision 20130117
[    0.270308] ACPI: All ACPI Tables successfully acquired
[    0.272417] ACPI: setting ELCR to 0200 (from 0c00)
[    0.308680] smpboot: SMP disabled
[    0.313834] Performance Events: 
[    0.316633] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.317937] no hardware sampling interrupt available.
[    0.319134] Broken PMU hardware detected, using software events only.
[    0.320203] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.408480] Brought up 1 CPUs
[    0.409518] ----------------
[    0.410115] | NMI testsuite:
[    0.410686] --------------------
[    0.411394]   remote IPI:[    0.414524] NMI watchdog: disabled (cpu0): hardware events not enabled
  ok  |
[    0.416957]    local IPI:  ok  |
[    4.140555] --------------------
[    4.141326] Good, all   2 testcases passed! |
[    4.142115] ---------------------------------
[    4.143231] smpboot: Total of 1 processors activated (6384.07 BogoMIPS)
[    4.153873] CPU0 attaching NULL sched-domain.
[    4.192412] devtmpfs: initialized
[    4.285130] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    4.297203] NET: Registered protocol family 16
[    4.359526] ACPI: bus type pci registered
[    4.368458] dca service started, version 1.12.1
[    4.371486] PCI: Using configuration type 1 for base access
[    5.094594] bio: create slab <bio-0> at 0
[    5.114038] ACPI: Added _OSI(Module Device)
[    5.114958] ACPI: Added _OSI(Processor Device)
[    5.116206] ACPI: Added _OSI(3.0 _SCP Extensions)
[    5.117117] ACPI: Added _OSI(Processor Aggregator Device)
[    5.177383] ACPI: EC: Look up EC in DSDT
[    5.353608] ACPI: Interpreter enabled
[    5.354506] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    5.357564] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    5.360977]  S3 S5)
[    5.362370] ACPI: Using PIC for interrupt routing
[    5.365553] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    5.662713] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    5.664392] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    5.683439] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    5.688830] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    5.690166] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    5.691564] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    5.692203] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    5.693907] PCI: root bus 00: using default resources
[    5.701455] PCI host bridge to bus 0000:00
[    5.702973] pci_bus 0000:00: root bus resource [bus 00-ff]
[    5.704385] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    5.705560] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    5.707393] pci_bus 0000:00: scanning bus
[    5.710458] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    5.714099] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0xa
[    5.732992] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    5.740444] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    5.749180] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    5.764386] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    5.765680] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x38
[    5.768553] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x154
[    5.770588] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    5.772354] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    5.774057] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    5.779527] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    5.782549] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    5.786453] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    5.800363] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    5.806740] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    5.810484] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    5.814386] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    5.827394] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    5.834908] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    5.838604] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    5.842413] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    5.862087] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    5.865379] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    5.869408] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    5.888915] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    5.892323] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    5.896284] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    5.915466] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    5.918466] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    5.922339] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    5.942528] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    5.946470] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    5.949357] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    5.970083] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    5.973393] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    5.977408] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    5.997823] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    6.000872] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    6.017317] pci_bus 0000:00: fixups for bus
[    6.018680] pci_bus 0000:00: bus scan returning with max=00
[    6.020360] ACPI _OSC control for PCIe not granted, disabling ASPM
[    6.059015] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    6.066330] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    6.072820] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    6.078628] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    6.084945] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    6.098143] ACPI: Enabled 16 GPEs in block 00 to 0F
[    6.100569] acpi root: \_SB_.PCI0 notify handler is installed
[    6.105118] Found 1 acpi root devices
[    6.118757] tps65010: version 2 May 2005
[    6.157522] tps65010: no chip?
[    6.175183] SCSI subsystem initialized
[    6.182329] Linux video capture interface: v2.00
[    6.185281] pps_core: LinuxPPS API ver. 1 registered
[    6.186228] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    6.188687] PTP clock support registered
[    6.194506] wmi: Mapper loaded
[    6.201070] Advanced Linux Sound Architecture Driver Initialized.
[    6.202986] PCI: Using ACPI for IRQ routing
[    6.204678] PCI: pci_cache_line_size set to 64 bytes
[    6.206614] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    6.208362] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    6.209746] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    6.211389] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    6.212269] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    6.213895] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    6.216400] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    6.218066] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    6.220255] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    6.221819] pci 0000:00:04.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    6.224294] pci 0000:00:04.0: BAR 1: reserving [mem 0xfebf1000-0xfebf1fff flags 0x40200] (d=0, p=0)
[    6.225951] pci 0000:00:05.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    6.228269] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf2000-0xfebf2fff flags 0x40200] (d=0, p=0)
[    6.229961] pci 0000:00:06.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    6.231656] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf3000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    6.232323] pci 0000:00:07.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    6.233853] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    6.236301] pci 0000:00:08.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    6.237839] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    6.240287] pci 0000:00:09.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    6.241839] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    6.244328] pci 0000:00:0a.0: BAR 0: reserving [mem 0xfebf7000-0xfebf700f flags 0x40200] (d=0, p=0)
[    6.246785] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    6.248554] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    6.279194] irda_init()
[    6.286846] NET: Registered protocol family 23
[    6.290958] Bluetooth: Core ver 2.16
[    6.293078] NET: Registered protocol family 31
[    6.293962] Bluetooth: HCI device and connection manager initialized
[    6.296358] Bluetooth: HCI socket layer initialized
[    6.297644] Bluetooth: L2CAP socket layer initialized
[    6.300422] Bluetooth: SCO socket layer initialized
[    6.318563] Switching to clocksource hpet
[    6.324558] CE: hpet increased min_delta_ns to 5000 nsec
[    6.334930] pnp: PnP ACPI init
[    6.337407] ACPI: bus type pnp registered
[    6.348190] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.354202] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    6.359135] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    6.362958] pnp 00:03: [dma 2]
[    6.365965] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.372604] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    6.378244] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.391858] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.400776] pnp: PnP ACPI: found 7 devices
[    6.401762] ACPI: ACPI bus type pnp unregistered
[    6.455558] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    6.457004] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    6.459609] NET: Registered protocol family 1
[    6.461918] pci 0000:00:00.0: calling quirk_natoma+0x0/0x2b
[    6.463038] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.464672] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x7b
[    6.466130] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    6.467790] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e
[    6.469504] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    6.470900] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x99
[    6.472588] pci 0000:00:02.0: Boot video device
[    6.473608] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x154
[    6.475443] PCI: CLS 0 bytes, default 64
[    6.495250] Unpacking initramfs...
[   34.454608] Freeing initrd memory: 23656k freed
[   34.639108] Machine check injector initialized
[   34.657952] cryptomgr_test (21) used greatest stack depth: 6936 bytes left
[   34.665901] cryptomgr_test (22) used greatest stack depth: 6872 bytes left
[   34.672559] cryptomgr_test (23) used greatest stack depth: 6792 bytes left
[   34.691198] AVX instructions are not detected.
[   34.746615] cryptomgr_test (42) used greatest stack depth: 6776 bytes left
[   34.802868] ------------[ cut here ]------------
[   34.803941] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
[   34.804548] Hardware name: Bochs
[   34.804548] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
[   34.804548] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc6-09234-g457583a #40
[   34.804548] Call Trace:
[   34.804548]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
[   34.804548]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
[   34.804548]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
[   34.804548]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
[   34.804548]  [<ffffffff8135dbe6>] ? __debug_object_init+0x3d/0x333
[   34.804548]  [<ffffffff8135de91>] __debug_object_init+0x2e8/0x333
[   34.804548]  [<ffffffff8135def0>] debug_object_init+0x14/0x16
[   34.804548]  [<ffffffff813665b4>] __percpu_counter_init+0x6a/0xc8
[   34.804548]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
[   34.804548]  [<ffffffff8284b327>] swap_setup+0x38/0x84
[   34.804548]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
[   34.804548]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
[   34.804548]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
[   34.804548]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
[   34.804548]  [<ffffffff82830689>] ? loglevel+0x31/0x31
[   34.804548]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.804548]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
[   34.804548]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
[   34.804548]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.804548] ---[ end trace 4b830e8d096c7c64 ]---
[   34.840909] ------------[ cut here ]------------
[   34.841859] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
[   34.843438] Hardware name: Bochs
[   34.844260] ODEBUG: activate active (active state 0) object type: percpu_counter hint:           (null)
[   34.844615] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc6-09234-g457583a #40
[   34.844615] Call Trace:
[   34.844615]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
[   34.844615]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
[   34.844615]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
[   34.844615]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
[   34.844615]  [<ffffffff8135df62>] ? debug_object_activate+0x57/0x116
[   34.844615]  [<ffffffff8135dfa8>] debug_object_activate+0x9d/0x116
[   34.844615]  [<ffffffff813665c3>] __percpu_counter_init+0x79/0xc8
[   34.844615]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
[   34.844615]  [<ffffffff8284b327>] swap_setup+0x38/0x84
[   34.844615]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
[   34.844615]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
[   34.844615]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
[   34.844615]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
[   34.844615]  [<ffffffff82830689>] ? loglevel+0x31/0x31
[   34.844615]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.844615]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
[   34.844615]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
[   34.844615]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.844615] ---[ end trace 4b830e8d096c7c65 ]---
[   34.870166] ------------[ cut here ]------------
[   34.871092] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
[   34.872857] Hardware name: Bochs
[   34.873528] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
[   34.873811] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc6-09234-g457583a #40
[   34.873811] Call Trace:
[   34.873811]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
[   34.873811]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
[   34.873811]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
[   34.873811]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
[   34.873811]  [<ffffffff8135dbe6>] ? __debug_object_init+0x3d/0x333
[   34.873811]  [<ffffffff8135de91>] __debug_object_init+0x2e8/0x333
[   34.873811]  [<ffffffff8135def0>] debug_object_init+0x14/0x16
[   34.873811]  [<ffffffff813665b4>] __percpu_counter_init+0x6a/0xc8
[   34.873811]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
[   34.873811]  [<ffffffff8284b327>] swap_setup+0x38/0x84
[   34.873811]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
[   34.873811]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
[   34.873811]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
[   34.873811]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
[   34.873811]  [<ffffffff82830689>] ? loglevel+0x31/0x31
[   34.873811]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.873811]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
[   34.873811]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
[   34.873811]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.873811] ---[ end trace 4b830e8d096c7c66 ]---
[   34.899952] ------------[ cut here ]------------
[   34.901064] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
[   34.902716] Hardware name: Bochs
[   34.903379] ODEBUG: activate active (active state 0) object type: percpu_counter hint:           (null)
[   34.903709] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc6-09234-g457583a #40
[   34.903709] Call Trace:
[   34.903709]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
[   34.903709]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
[   34.903709]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
[   34.903709]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
[   34.903709]  [<ffffffff8135df62>] ? debug_object_activate+0x57/0x116
[   34.903709]  [<ffffffff8135dfa8>] debug_object_activate+0x9d/0x116
[   34.903709]  [<ffffffff813665c3>] __percpu_counter_init+0x79/0xc8
[   34.903709]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
[   34.903709]  [<ffffffff8284b327>] swap_setup+0x38/0x84
[   34.903709]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
[   34.903709]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
[   34.903709]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
[   34.903709]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
[   34.903709]  [<ffffffff82830689>] ? loglevel+0x31/0x31
[   34.903709]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.903709]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
[   34.903709]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
[   34.903709]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.903709] ---[ end trace 4b830e8d096c7c67 ]---
[   34.929046] ------------[ cut here ]------------
[   34.929968] WARNING: at /c/kernel-tests/src/stable/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
[   34.931538] Hardware name: Bochs
[   34.932350] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
[   34.932679] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc6-09234-g457583a #40
[   34.932679] Call Trace:
[   34.932679]  [<ffffffff8135da31>] ? debug_print_object+0x7c/0x8d
[   34.932679]  [<ffffffff81059ee7>] warn_slowpath_common+0x79/0x94
[   34.932679]  [<ffffffff81059f5d>] warn_slowpath_fmt+0x41/0x43
[   34.932679]  [<ffffffff8135da31>] debug_print_object+0x7c/0x8d
[   34.932679]  [<ffffffff8135dbe6>] ? __debug_object_init+0x3d/0x333
[   34.932679]  [<ffffffff8135de91>] __debug_object_init+0x2e8/0x333
[   34.932679]  [<ffffffff8135def0>] debug_object_init+0x14/0x16
[   34.932679]  [<ffffffff813665b4>] __percpu_counter_init+0x6a/0xc8
[   34.932679]  [<ffffffff810ceca3>] bdi_init+0x139/0x1d1
[   34.932679]  [<ffffffff8284b327>] swap_setup+0x38/0x84
[   34.932679]  [<ffffffff8284b385>] kswapd_init+0x12/0x77
[   34.932679]  [<ffffffff8284b373>] ? swap_setup+0x84/0x84
[   34.932679]  [<ffffffff82830e32>] do_one_initcall+0x7a/0x134
[   34.932679]  [<ffffffff82830ff7>] kernel_init_freeable+0x10b/0x19a
[   34.932679]  [<ffffffff82830689>] ? loglevel+0x31/0x31
[   34.932679]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.932679]  [<ffffffff81d42358>] kernel_init+0x9/0xd6
[   34.932679]  [<ffffffff81d6b37c>] ret_from_fork+0x7c/0xb0
[   34.932679]  [<ffffffff81d4234f>] ? rest_init+0xc3/0xc3
[   34.932679] ---[ end trace 4b830e8d096c7c68 ]---
[   34.979567] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   35.146286] VFS: Disk quotas dquot_6.5.2
[   35.154830] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   35.229070] NTFS driver 2.1.30 [Flags: R/W].
[   35.237090] fuse init (API version 7.21)
[   35.251711] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[   35.301432] NILFS version 2 loaded
[   35.302293] OCFS2 1.5.0
[   35.314360] ocfs2: Registered cluster interface o2cb
[   35.315480] OCFS2 DLMFS 1.5.0
[   35.322826] OCFS2 User DLM kernel interface loaded
[   35.323873] OCFS2 Node Manager 1.5.0
[   35.342670] OCFS2 DLM 1.5.0
[   35.373500] GFS2 installed
[   35.417302] cryptomgr_test (73) used greatest stack depth: 6632 bytes left
[   35.463709] NET: Registered protocol family 38
[   35.467070] Key type asymmetric registered
[   35.470177] Asymmetric key parser 'x509' registered
[   35.477405] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   35.479375] io scheduler noop registered (default)
[   35.481630] io scheduler deadline registered
[   35.482532] list_sort_test: start testing list_sort()
[   35.523738] i2c-core: driver [adp8870_bl] using legacy suspend method
[   35.525631] i2c-core: driver [adp8870_bl] using legacy resume method
[   35.532718] rivafb_setup START
[   35.534349] nvidiafb_setup START
[   35.540804] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   35.551874] vmlfb: initializing
[   35.559887] hgafb: HGA card not detected.
[   35.562725] hgafb: probe of hgafb.0 failed with error -22
[   35.587626] kworker/u:0 (90) used greatest stack depth: 6616 bytes left
[   35.595346] uvesafb: failed to execute /sbin/v86d
[   35.597280] uvesafb: make sure that the v86d helper is installed and executable
[   35.598780] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[   35.602001] uvesafb: vbe_init() failed with -22
[   35.603255] uvesafb: probe of uvesafb.0 failed with error -22
[   35.619308] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   35.622422] ACPI: Power Button [PWRF]
[   35.651720] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[   35.653961] Unable to map lapic to logical cpu number
[   35.805524] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   35.814105] cs5535-clockevt: Could not allocate MFGPT timer

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="457583a-bisect.log"

bisect: skip b55f07258643744df579045653618630db9647fc: not a good merge base
git checkout v3.7
Previous HEAD position was 457583a... memory-hotplug: common APIs to support page tables hot-remove fix fix
HEAD is now at 2959440... Linux 3.7

2013-02-08-10:43:38 29594404d7fe73cd80eaa4ee8c43dcc53970c60e compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-10:48:09 detecting boot state 3.7.0-bisect2 #25 	2..	4.	6.	7	8.	10. SUCCESS
bisect: good commit v3.7
git bisect start 457583af4aef89d5252769ea290a2acc89e2361f v3.7 --
Previous HEAD position was 2959440... Linux 3.7
HEAD is now at 3c0eee3f... Linux 2.6.37
Bisecting: 11215 revisions left to test after this (roughly 14 steps)
[b4c582a92f41417154131083127e24b66cc4b31b] serial: xilinx_uartps: get clock rate info from dts
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-10:55:21 b4c582a92f41417154131083127e24b66cc4b31b compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-11:00:40 detecting boot state 3.7.0-bisect2-00001-gb4c582a #26 .	1........	2.	3.......	4.........	5..	6......	7..	8.......	9..	10...... SUCCESS
Bisecting: 5656 revisions left to test after this (roughly 13 steps)
[24d32e96c394bb84ca30dc41f8995efb3efa0b2e] Merge remote-tracking branch 'sound/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-11:31:50 24d32e96c394bb84ca30dc41f8995efb3efa0b2e compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-11:36:05 detecting boot state 3.8.0-rc6-bisect2-03577-g24d32e9 #27 .	1	2.	4	6.	8	9	10 SUCCESS
Bisecting: 2810 revisions left to test after this (roughly 12 steps)
[86159e4b9bc1270344a890d368ab08d91a373c0b] Merge remote-tracking branch 'workqueues/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-11:41:41 86159e4b9bc1270344a890d368ab08d91a373c0b compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-11:46:02 detecting boot state 3.8.0-rc6-bisect2-06423-g86159e4 #28 	2	3	4	6.	8	9	10 SUCCESS
Bisecting: 1368 revisions left to test after this (roughly 11 steps)
[32165b5ad1f88636cf5b7768cbf33cea74989211] Merge remote-tracking branch 'char-misc/char-misc-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-11:50:35 32165b5ad1f88636cf5b7768cbf33cea74989211 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-11:55:09 detecting boot state 3.8.0-rc6-bisect2-07865-g32165b5 #29 	2	4.	6	7	8	9	10 SUCCESS
Bisecting: 701 revisions left to test after this (roughly 10 steps)
[edbbe0c1f464400706358f91d0b9a308e56cf50f] Merge remote-tracking branch 'samsung/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-11:59:42 edbbe0c1f464400706358f91d0b9a308e56cf50f compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:04:12 detecting boot state 3.8.0-rc6-bisect2-08532-gedbbe0c #30 	1	3.	4	5.	6	7.	8	9.	10. SUCCESS
Bisecting: 350 revisions left to test after this (roughly 9 steps)
[c5ec1c273c49037e833f096c4f591abae8c41c01] compat: return -EFAULT on error in waitid()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:11:45 c5ec1c273c49037e833f096c4f591abae8c41c01 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:16:02 detecting boot state 3.8.0-rc6-bisect2-08883-gc5ec1c2 #31 	1	3	4	5	6	7	9. SUCCESS
Bisecting: 175 revisions left to test after this (roughly 8 steps)
[e4fde7764bf589399a6060596cca195f3fce15ff] get_maintainer.pl: find maintainers for removed files
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:20:34 e4fde7764bf589399a6060596cca195f3fce15ff compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:26:14 detecting boot state 3.8.0-rc6-bisect2-09058-ge4fde77 #31 . SUCCESS
Bisecting: 87 revisions left to test after this (roughly 7 steps)
[6710fc9562f4016222677534277ea442ff028ea1] hfsplus: add support of manipulation by attributes file
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:27:15 6710fc9562f4016222677534277ea442ff028ea1 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:28:37 detecting boot state 3.8.0-rc6-bisect2-09146-g6710fc9 #31 .	1	2.	3	4.	5	6 SUCCESS
Bisecting: 43 revisions left to test after this (roughly 6 steps)
[960468a8cda8ab71a846b668a03e85c08f3543c0] wait: add wait_event_hrtimeout()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:33:38 960468a8cda8ab71a846b668a03e85c08f3543c0 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:36:12 detecting boot state 3.8.0-rc6-bisect2-09190-g960468a #31 	1	2 SUCCESS
Bisecting: 21 revisions left to test after this (roughly 5 steps)
[29ce58899628f7c1de594b4c51a57129b9d28dae] aio-dont-include-aioh-in-schedh-fix-fix
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:37:44 29ce58899628f7c1de594b4c51a57129b9d28dae compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:40:11 detecting boot state 3.8.0-rc6-bisect2-09212-g29ce588 #31 	2. SUCCESS
Bisecting: 10 revisions left to test after this (roughly 4 steps)
[bf5b05d942033ed019a3daef9651ccb172c50a2a] block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:41:42 bf5b05d942033ed019a3daef9651ccb172c50a2a compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:43:53 detecting boot state 3.8.0-rc6-bisect2-09223-gbf5b05d #31 	2	4.	5. SUCCESS
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[04e0961ab478b63f81d6976e50b5642fcfaf80c9] aio: fix aio_read_events_ring() types
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:46:54 04e0961ab478b63f81d6976e50b5642fcfaf80c9 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:47:59 detecting boot state 3.8.0-rc6-bisect2-09228-g04e0961 #31 	1	2.	3.	4	5.	6	7.	8 SUCCESS
Bisecting: 2 revisions left to test after this (roughly 2 steps)
[ec32b1df9515509c7ced856ea2f687d0ae51fe27] kfifo: fix kfifo_alloc() and kfifo_init()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:54:31 ec32b1df9515509c7ced856ea2f687d0ae51fe27 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-12:55:22 detecting boot state 3.8.0-rc6-bisect2-09231-gec32b1d #31 	1	2	3	5	6	7	8 SUCCESS
Bisecting: 0 revisions left to test after this (roughly 1 step)
[0e4ef6ad789dc7fedeaf347d013521bffe685480] swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-08-12:59:24 0e4ef6ad789dc7fedeaf347d013521bffe685480 compiling
rm: cannot remove `/tmp/bisect-good-kvm_bisect2': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect2': Operation not permitted
/home/wfg/tip

2013-02-08-13:00:05 detecting boot state 3.8.0-rc6-bisect2-09233-g0e4ef6a #31 	2	3	4	6. SUCCESS
457583af4aef89d5252769ea290a2acc89e2361f is the first bad commit
commit 457583af4aef89d5252769ea290a2acc89e2361f
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Feb 4 18:12:17 2013 +1100

    memory-hotplug: common APIs to support page tables hot-remove fix fix
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

:040000 040000 4460604a5e2eada07dc330c88b9e0a30bebfcfcb 226989044fbb9dda3d3ddce136303ac0d3d47010 M	arch
bisect run success

2013-02-08-13:03:07 0e4ef6ad789dc7fedeaf347d013521bffe685480 compiling
/home/wfg/tip

2013-02-08-13:03:44 detecting boot state 3.8.0-rc6-bisect2-09233-g0e4ef6a #31 .	2	3	4	5	7	8	9	10	12	13	14	16	17	18	19	21	22	23	24	26	27 SUCCESS

========= linux-next =========

2013-02-08-13:15:20 99ae5387e08311e47931836be5136d9df9e94cb2 compiling
/home/wfg/tip

2013-02-08-13:17:32 detecting boot state 3.8.0-rc6-bisect2-next-20130205 #32 	1 TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:59: main: $BISECT_TEST $KBUILD_OUTPUT

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.8.0-rc6 Kernel Configuration
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
CONFIG_EXPERIMENTAL=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
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
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
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
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
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
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
# CONFIG_YENTA_ENE_TUNE is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
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
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_MCP251X=y
# CONFIG_CAN_JANZ_ICAN3 is not set
# CONFIG_PCH_CAN is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y
# CONFIG_CAN_SOFTING is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_BT_WILINK is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
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
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
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
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
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
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
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
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
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
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
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
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
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
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
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
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
# CONFIG_MEGARAID_MAILBOX is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
# CONFIG_TCM_FC is not set
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
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
CONFIG_BNX2X_SRIOV=y
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
CONFIG_WINBOND_840=y
# CONFIG_DM9102 is not set
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IGB is not set
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
CONFIG_KS8851=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
# CONFIG_NET_VENDOR_8390 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
CONFIG_QLCNIC=y
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
# CONFIG_HDLC_RAW_ETH is not set
# CONFIG_HDLC_CISCO is not set
# CONFIG_HDLC_FR is not set
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
# CONFIG_FARSYNC is not set
# CONFIG_DLCI is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
# CONFIG_DE_AOC is not set
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
# CONFIG_HISAX_NO_LLC is not set
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_3 is not set
CONFIG_HISAX_TELESPCI=y
# CONFIG_HISAX_S0BOX is not set
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
# CONFIG_HISAX_ELSA is not set
CONFIG_HISAX_DIEHLDIVA=y
# CONFIG_HISAX_SEDLBAUER is not set
CONFIG_HISAX_NETJET=y
# CONFIG_HISAX_NETJET_U is not set
CONFIG_HISAX_NICCY=y
# CONFIG_HISAX_BKM_A4T is not set
CONFIG_HISAX_SCT_QUADRO=y
# CONFIG_HISAX_GAZEL is not set
# CONFIG_HISAX_HFC_PCI is not set
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#
# CONFIG_HISAX_AVM_A1_CS is not set

#
# HiSax sub driver modules
#
CONFIG_HISAX_HFC4S8S=y
CONFIG_HISAX_FRITZ_PCIPNP=y

#
# Active cards
#
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

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
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_WM97XX=y
CONFIG_TOUCHSCREEN_WM9705=y
# CONFIG_TOUCHSCREEN_WM9712 is not set
# CONFIG_TOUCHSCREEN_WM9713 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

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
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
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
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MRST_MAX3110=y
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
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_TTY_PRINTK=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
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
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
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
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MID_DMA=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
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
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_WM97XX=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_FAIR_SHARE is not set
CONFIG_STEP_WISE=y
# CONFIG_USER_SPACE is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_DA9055_WATCHDOG is not set
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

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
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_UCB1400_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_SMSC=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_DVB=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog TV support
#
# CONFIG_VIDEO_IVTV is not set
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
# CONFIG_VIDEO_ZORAN_BUZ is not set
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX18 is not set
CONFIG_VIDEO_CX23885=y
# CONFIG_MEDIA_ALTERA_CI is not set
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_CX25821_ALSA=y
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
CONFIG_VIDEO_SAA7134=y
# CONFIG_VIDEO_SAA7134_ALSA is not set
# CONFIG_VIDEO_SAA7134_RC is not set
CONFIG_VIDEO_SAA7134_DVB=y
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
# CONFIG_DVB_AV7110_OSD is not set
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=y
# CONFIG_DVB_DM1105 is not set
# CONFIG_DVB_PT1 is not set
CONFIG_MANTIS_CORE=y
CONFIG_DVB_MANTIS=y
CONFIG_DVB_HOPPER=y
# CONFIG_DVB_NGENE is not set
CONFIG_DVB_DDBRIDGE=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
# CONFIG_VIDEO_VP27SMPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
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
CONFIG_VIDEO_UPD64031A=y
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_TUA9001=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
# CONFIG_DVB_STB6100 is not set
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_SI21XX=y
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
# CONFIG_DVB_DRXD is not set
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
CONFIG_DVB_STV0367=y
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=y
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=y
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
# CONFIG_DVB_LGS8GXX is not set
# CONFIG_DVB_ATBM8830 is not set
# CONFIG_DVB_TDA665x is not set
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TTM is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
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
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
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
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
# CONFIG_SND_RTCTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
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
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=y
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=y
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=y
CONFIG_SND_CS5535AUDIO=y
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
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
CONFIG_SND_FM801=y
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
CONFIG_SND_HDA_CODEC_CA0110=y
# CONFIG_SND_HDA_CODEC_CA0132 is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=y
# CONFIG_SND_LOLA is not set
CONFIG_SND_LX6464ES=y
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
# CONFIG_SND_VIA82XX is not set
CONFIG_SND_VIA82XX_MODEM=y
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SOC_ALL_CODECS=y
CONFIG_SND_SOC_88PM860X=y
CONFIG_SND_SOC_ARIZONA=y
CONFIG_SND_SOC_WM_HUBS=y
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AD1836=y
CONFIG_SND_SOC_AD193X=y
CONFIG_SND_SOC_AD73311=y
CONFIG_SND_SOC_ADAU1373=y
CONFIG_SND_SOC_ADAV80X=y
CONFIG_SND_SOC_ADS117X=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4535=y
CONFIG_SND_SOC_AK4641=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK4671=y
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
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA529=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC26=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_TLV320DAC33=y
CONFIG_SND_SOC_TWL4030=y
CONFIG_SND_SOC_UDA134X=y
CONFIG_SND_SOC_UDA1380=y
CONFIG_SND_SOC_WL1273=y
CONFIG_SND_SOC_WM0010=y
CONFIG_SND_SOC_WM1250_EV1=y
CONFIG_SND_SOC_WM2000=y
CONFIG_SND_SOC_WM2200=y
CONFIG_SND_SOC_WM5100=y
CONFIG_SND_SOC_WM5102=y
CONFIG_SND_SOC_WM8350=y
CONFIG_SND_SOC_WM8400=y
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
CONFIG_SND_SOC_WM8770=y
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
CONFIG_SND_SOC_WM8995=y
CONFIG_SND_SOC_WM8996=y
CONFIG_SND_SOC_WM9081=y
CONFIG_SND_SOC_WM9090=y
CONFIG_SND_SOC_LM4857=y
CONFIG_SND_SOC_MAX9768=y
CONFIG_SND_SOC_MAX9877=y
CONFIG_SND_SOC_MC13783=y
CONFIG_SND_SOC_ML26124=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_APPLE=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ICADE=y
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set

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
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
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
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_ACPI_WMI=y
CONFIG_MXM_WMI=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_MEMORY=y
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
# CONFIG_KXSD9 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7476=y
CONFIG_AD7887=y
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set

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
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
CONFIG_AD5686=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16136 is not set

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
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
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

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
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

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
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
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
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
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
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
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
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
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
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
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
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_X86_64=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS7_MESSAGE_PARSER is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
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
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_ISDN_DRV_LOOP is not set

--huq684BweRXVnRxX--
