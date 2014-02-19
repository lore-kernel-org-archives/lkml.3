Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaBSM0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:26:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:57442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaBSM0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:26:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="log'?scan'208";a="477621861"
Date: Wed, 19 Feb 2014 20:25:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [cgroup] BUG: unable to handle kernel NULL pointer dereference at
 0000001c
Message-ID: <20140219122537.GD7735@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next

commit ace2bee8135a3dc725958b8d08c55ee9df813d39
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue Feb 11 11:52:47 2014 -0500
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Tue Feb 11 11:52:47 2014 -0500

    cgroup: introduce cgroup_tree_mutex
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Acked-by: Li Zefan <lizefan@huawei.com>

[   97.464167] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[   97.464897] IP: [<8130f33d>] kernfs_path_locked+0x7d/0xc0
[   97.465519] *pde = 00000000
[   97.465960] Oops: 0000 [#1] SMP
[   97.466936] CPU: 0 PID: 24 Comm: kworker/0:1 Tainted: G S      W    3.14.0-rc2-01592-g97162c1 #6
[   97.467818] Workqueue: events_freezable_power_ disk_events_workfn
[   97.468342] task: 801c7560 ti: 801d6000 task.ti: 801d6000
[   97.468836] EIP: 0060:[<8130f33d>] EFLAGS: 00000046 CPU: 0
[   97.469291] EIP is at kernfs_path_locked+0x7d/0xc0
[   97.469636] EAX: 00000000 EBX: 00000000 ECX: 801d7c34 EDX: 801d7bb4
[   97.470024] ESI: 00000046 EDI: 801d7c33 EBP: 801d7b68 ESP: 801d7b58
[   97.470505]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   97.470929] CR0: 8005003b CR2: 0000001c CR3: 03b92000 CR4: 00300690
[   97.471550] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   97.472155] DR6: 00000000 DR7: 00000000
[   97.472397] Stack:
[   97.472397]  801d7bb4 00000000 00000046 801d7bb4 801d7b80 8130fe59 00000080 929c0ce0
[   97.472397]  929ae498 00000018 801d7c40 8199b88a 00000002 00000001 00000000 8199b650
[   97.472397]  929ae498 00000000 00000001 801c7560 929ae5e4 929b46f8 929c0ca0 819978d0
[   97.472397] Call Trace:
[   97.472397]  [<8130fe59>] kernfs_path+0x49/0x80
[   97.472397]  [<8199b88a>] cfq_find_alloc_queue+0x3fa/0x620
[   97.472397]  [<8199b650>] ? cfq_find_alloc_queue+0x1c0/0x620
[   97.472397]  [<819978d0>] ? cfq_put_request+0x220/0x220
[   97.472397]  [<8199bca5>] ? cfq_set_request+0x85/0x740
[   97.472397]  [<8111e5ce>] ? do_raw_spin_lock+0xe/0x2e0
[   97.472397]  [<8199bb35>] cfq_get_queue+0x85/0x170
[   97.472397]  [<8199bff7>] cfq_set_request+0x3d7/0x740

git bisect start 97162c1b407ab8dbcc637c316b772dd0572deddc b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed --
git bisect good fac377044fb04ec759db1dd84fab3312b718541a  # 12:52     20+      2  Merge 'asoc/topic/io' into devel-hourly-2014021619
git bisect good e4a1d2bc3960c559a130db3ca999521c8120fbfb  # 13:00     20+      1  Merge 'lunn/v3.14-rc1-synology-v2' into devel-hourly-2014021619
git bisect  bad df2a05d9d2e5ec7aaa7f2912bf531955525f6155  # 13:02      0-      7  Merge 'cgroup/review-post-kernfs-conversion' into devel-hourly-2014021619
git bisect good 542b836903f8aa533efc48c0d4b269303f14885e  # 13:06     20+      7  Merge 'input/for-linus' into devel-hourly-2014021619
git bisect good 3a24395f59305e7995690e65e5593082ae8d9c1b  # 13:09     20+      5  Merge 'target/master' into devel-hourly-2014021619
git bisect  bad ace2bee8135a3dc725958b8d08c55ee9df813d39  # 13:13      1-      2  cgroup: introduce cgroup_tree_mutex
git bisect good 0ab02ca8f887908152d1a96db5130fc661d36a1e  # 13:19     25+      7  cgroup: protect modifications to cgroup_idr with cgroup_mutex
git bisect good 69e943b7d3c2dcca1087e03e556ac6cb0d4433b4  # 13:23     25+      8  cgroup: update locking in cgroup_show_options()
git bisect good f7cef064aa01a1ac682c1945cc168b878cb118ff  # 13:30     25+      9  Merge branch 'driver-core-next' into cgroup/for-3.15
git bisect good 5a17f543ed6808e9085063277fe46795dea484bd  # 13:35     25+     11  cgroup: improve css_from_dir() into css_tryget_from_dir()
# first bad commit: [ace2bee8135a3dc725958b8d08c55ee9df813d39] cgroup: introduce cgroup_tree_mutex
git bisect good 5a17f543ed6808e9085063277fe46795dea484bd  # 13:39     75+     20  cgroup: improve css_from_dir() into css_tryget_from_dir()
git bisect  bad 97162c1b407ab8dbcc637c316b772dd0572deddc  # 13:39      0-     19  0day head guard for 'devel-hourly-2014021619'
git bisect good 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2  # 13:48     75+     15  Linux 3.14-rc3

Thanks,
Fengguang

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-waimea-7:20140217000627:i386-randconfig-nh0-02162347:3.14.0-rc2-01592-g97162c1:6"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 3.14.0-rc2-01592-g97162c1 (kbuild@nhm4) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #6 SMP Mon Feb 17 00:02:55 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[800fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x04ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x048f5000, 0x048f5fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD920 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] BRK [0x048f6000, 0x048f6fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @924ed000 s31872 r0 d13184 u45=
056
[    0.000000] pcpu-alloc: s31872 r0 d13184 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-nh0-02162347/linux-devel:devel-hourly-2014021619/.vmlinu=
z-97162c1b407ab8dbcc637c316b772dd0572deddc-20140217000347-1-waimea branch=
=3Dlinux-devel/devel-hourly-2014021619 BOOT_IMAGE=3D/kernel/i386-randconfig=
-nh0-02162347/97162c1b407ab8dbcc637c316b772dd0572deddc/vmlinuz-3.14.0-rc2-0=
1592-g97162c1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 240800K/327280K available (30858K kernel code, 3927K=
 rwdata, 8420K rodata, 1292K init, 13640K bss, 86480K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd33000 - 0xfffff000   (2864 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x83a41000 - 0x83b84000   (1292 kB)
[    0.000000]       .data : 0x82e22ee2 - 0x83a40d00   (12407 kB)
[    0.000000]       .text : 0x81000000 - 0x82e22ee2   (30859 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80090000 soft=3D80092000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3300.115 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.079270] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6600.23 BogoMIPS (lpj=3D33001150)
[    0.080000] pid_max: default: 4096 minimum: 301
[    0.084375] Security Framework initialized
[    0.092910] Yama: becoming mindful.
[    0.102792] Mount-cache hash table entries: 512
[    0.181670] Initializing cgroup subsys debug
[    0.182930] Initializing cgroup subsys devices
[    0.183565] Initializing cgroup subsys net_cls
[    0.184003] Initializing cgroup subsys blkio
[    0.184418] Initializing cgroup subsys perf_event
[    0.210000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.210000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.210000] tlb_flushall_shift: -1
[    0.253485] Freeing SMP alternatives memory: 44K (83b84000 - 83b8f000)
[    0.358519] Getting VERSION: 50011
[    0.358995] Getting VERSION: 50011
[    0.359348] Getting ID: 0
[    0.359586] Getting ID: f000000
[    0.360409] Getting LVT0: 8700
[    0.360704] Getting LVT1: 8400
[    0.361114] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.362359] enabled ExtINT on CPU#0
[    0.364749] ENABLING IO-APIC IRQs
[    0.365149] init IO_APIC IRQs
[    0.365641]  apic 0 pin 0 not connected
[    0.367723] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.370478] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.371036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.371484] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.371989] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.377219] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.377770] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.378271] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.378856] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.379365] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.379918] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.380000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.380000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.380000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.380000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.380000]  apic 0 pin 16 not connected
[    0.380000]  apic 0 pin 17 not connected
[    0.380000]  apic 0 pin 18 not connected
[    0.380000]  apic 0 pin 19 not connected
[    0.380000]  apic 0 pin 20 not connected
[    0.380000]  apic 0 pin 21 not connected
[    0.380000]  apic 0 pin 22 not connected
[    0.380000]  apic 0 pin 23 not connected
[    0.380000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.562841] smpboot: CPU0: AMD QEMU Virtual CPU version 1.6.0 (fam: 06, =
model: 02, stepping: 03)
[    0.564881] Using local APIC timer interrupts.
[    0.564881] calibrating APIC timer ...
[    0.570000] ... lapic delta =3D 6874226
[    0.570000] ... PM-Timer delta =3D 393696
[    0.570000] APIC calibration not consistent with PM-Timer: 109ms instead=
 of 100ms
[    0.570000] APIC delta adjusted to PM-Timer: 6250144 (6874226)
[    0.570000] TSC delta adjusted to PM-Timer: 330008160 (362959746)
[    0.570000] ..... delta 6250144
[    0.570000] ..... mult: 268441640
[    0.570000] ..... calibration result: 10000230
[    0.570000] ..... CPU clock speed is 3300.0816 MHz.
[    0.570000] ..... host bus clock speed is 1000.0230 MHz.
[    0.570000] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.570000] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.693603] CPU 1 irqstacks, hard=3D8005e000 soft=3D80060000
[    0.694185] x86: Booting SMP configuration:
[    0.694561] .... node  #0, CPUs:      #1
[    0.080000] Initializing CPU#1
[    0.080000] masked ExtINT on CPU#1
[    0.080000] ------------[ cut here ]------------
[    0.080000] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220 init=
_amd+0xff3/0x1100()
[    0.080000] WARNING: This combination of AMD processors is not suitable =
for SMP.
[    0.080000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc2-01592-g=
97162c1 #6
[    0.080000]  8344ace8 80045eb4 82e0217e 80045ef4 80045ee4 8108fc7d 8344a=
ca0 80045f10
[    0.080000]  00000000 8344ace8 000000dc 81029223 81029223 924fee40 924fe=
e90 924feebc
[    0.080000]  80045efc 8108fd6f 00000009 80045ef4 8344aca0 80045f10 80045=
f38 81029223
[    0.080000] Call Trace:
[    0.080000]  [<82e0217e>] dump_stack+0xb8/0x108
[    0.080000]  [<8108fc7d>] warn_slowpath_common+0xcd/0x110
[    0.080000]  [<81029223>] ? init_amd+0xff3/0x1100
[    0.080000]  [<81029223>] ? init_amd+0xff3/0x1100
[    0.080000]  [<8108fd6f>] warn_slowpath_fmt+0x4f/0x60
[    0.080000]  [<81029223>] init_amd+0xff3/0x1100
[    0.080000]  [<81024341>] identify_cpu+0x191/0x980
[    0.080000]  [<8111e929>] ? do_raw_spin_unlock+0x9/0x140
[    0.080000]  [<81024b4d>] identify_secondary_cpu+0x1d/0x80
[    0.080000]  [<81050900>] smp_store_cpu_info+0x40/0x60
[    0.080000]  [<81051a45>] start_secondary+0x235/0x650
[    0.080000] ---[ end trace afe459c58c4c3ec5 ]---
[    0.080000] Disabling lock debugging due to kernel taint
[    0.080000] calibrate_delay_direct() failed to get a good estimate for l=
oops_per_jiffy.
[    0.080000] Probably due to long platform interrupts. Consider using "lp=
j=3D" boot option.
[    0.975765] x86: Booted up 1 node, 2 CPUs
[    0.976222] smpboot: Total of 2 processors activated (7647.98 BogoMIPS)
[    1.110388] devtmpfs: initialized
[    1.191030] gcov: version magic: 0x3430382a
[    1.370986] EVM: security.ima
[    1.371243] EVM: security.capability
[    1.508898] xor: measuring software checksum speed
[    1.600267]    pIII_sse  :   534.400 MB/sec
[    1.700155]    prefetch64-sse:   525.600 MB/sec
[    1.700517] xor: using function: pIII_sse (534.400 MB/sec)
[    1.734943] regulator-dummy: no parameters
[    1.761676] NET: Registered protocol family 16
[    1.810156] EISA bus registered
[    1.810759] cpuidle: using governor menu
[    1.912884] ACPI: bus type PCI registered
[    1.914963] dca service started, version 1.12.1
[    1.933131] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    1.933582] PCI: Using configuration type 1 for base access
[    2.705106] bio: create slab <bio-0> at 0
[    2.880565] raid6: mmxx1       28 MB/s
[    3.052481] raid6: mmxx2       28 MB/s
[    3.220900] raid6: sse1x1      22 MB/s
[    3.392511] raid6: sse1x2      27 MB/s
[    3.561291] raid6: sse2x1      27 MB/s
[    3.730316] raid6: sse2x2      23 MB/s
[    3.900179] raid6: int32x1     67 MB/s
[    4.070326] raid6: int32x2     81 MB/s
[    4.240769] raid6: int32x4     66 MB/s
[    4.411029] raid6: int32x8     43 MB/s
[    4.411943] raid6: using algorithm int32x2 (81 MB/s)
[    4.412533] raid6: using intx1 recovery algorithm
[    4.427154] ACPI: Added _OSI(Module Device)
[    4.427932] ACPI: Added _OSI(Processor Device)
[    4.428281] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.428538] ACPI: Added _OSI(Processor Aggregator Device)
[    4.827284] ACPI: Interpreter enabled
[    4.828992] ACPI: (supports S0 S5)
[    4.829402] ACPI: Using IOAPIC for interrupt routing
[    4.832965] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    5.207650] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    5.208902] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    5.210282] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    5.228132] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    5.233237] PCI host bridge to bus 0000:00
[    5.233960] pci_bus 0000:00: root bus resource [bus 00-ff]
[    5.234467] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    5.234865] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    5.235254] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    5.235681] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    5.237658] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    5.252507] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    5.264466] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    5.269074] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    5.279177] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    5.282043] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    5.282564] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    5.293838] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    5.295762] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    5.297391] pci 0000:00:02.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    5.304270] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    5.314985] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    5.316787] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    5.318391] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    5.325552] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    5.336095] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    5.337332] pci 0000:00:04.0: reg 0x10: [mem 0xfebf0000-0xfebf3fff]
[    5.352646] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    5.354479] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    5.356131] pci 0000:00:05.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    5.375400] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    5.377166] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    5.378806] pci 0000:00:06.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    5.396087] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    5.397897] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    5.399531] pci 0000:00:07.0: reg 0x14: [mem 0xfebf7000-0xfebf7fff]
[    5.417346] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    5.419209] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    5.420850] pci 0000:00:08.0: reg 0x14: [mem 0xfebf8000-0xfebf8fff]
[    5.436568] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    5.438368] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    5.440182] pci 0000:00:09.0: reg 0x14: [mem 0xfebf9000-0xfebf9fff]
[    5.461626] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    5.463440] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    5.465066] pci 0000:00:0a.0: reg 0x14: [mem 0xfebfa000-0xfebfafff]
[    5.482911] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    5.484149] pci 0000:00:0b.0: reg 0x10: [mem 0xfebfb000-0xfebfb00f]
[    5.498818] pci_bus 0000:00: on NUMA node 0
[    5.522732] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    5.529160] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    5.535890] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    5.542278] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    5.545090] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    5.591870] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    5.592545] vgaarb: loaded
[    5.592769] vgaarb: bridge control possible 0000:00:02.0
[    5.618612] SCSI subsystem initialized
[    5.628824] pps_core: LinuxPPS API ver. 1 registered
[    5.629199] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    5.630317] PTP clock support registered
[    5.636190] PCI: Using ACPI for IRQ routing
[    5.636190] PCI: pci_cache_line_size set to 64 bytes
[    5.640756] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    5.641417] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    5.670346] NET: Registered protocol family 23
[    5.673698] Bluetooth: Core ver 2.18
[    5.674656] NET: Registered protocol family 31
[    5.674945] Bluetooth: HCI device and connection manager initialized
[    5.675665] Bluetooth: HCI socket layer initialized
[    5.676213] Bluetooth: L2CAP socket layer initialized
[    5.677596] Bluetooth: SCO socket layer initialized
[    5.678270] NET: Registered protocol family 8
[    5.678908] NET: Registered protocol family 20
[    5.691651] cfg80211: Calling CRDA to update world regulatory domain
[    5.706448] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    5.707417] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    5.708046] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    5.730571] Switched to clocksource hpet
[    8.913121] FS-Cache: Loaded
[    8.929017] CacheFiles: Loaded
[    8.937239] pnp: PnP ACPI init
[    8.938476] ACPI: bus type PNP registered
[    8.956875] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    8.973209] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    8.978477] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    8.988221] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    8.995452] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    9.004883] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    9.015654] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    9.018522] pnp 00:03: [dma 2]
[    9.027531] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    9.038059] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    9.047922] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    9.058469] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    9.065328] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    9.088355] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    9.102734] pnp: PnP ACPI: found 7 devices
[    9.103318] ACPI: bus type PNP unregistered
[    9.202088] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    9.202755] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    9.203088] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    9.203595] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    9.207385] NET: Registered protocol family 1
[    9.208804] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    9.209477] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    9.211470] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    9.212530] pci 0000:00:02.0: Boot video device
[    9.213868] PCI: CLS 0 bytes, default 64
[    9.233649] Trying to unpack rootfs image as initramfs...
[   25.793752] Freeing initrd memory: 24852K (927ab000 - 93ff0000)
[   45.922656] DMA-API: preallocated 65536 debug entries
[   45.923000] DMA-API: debugging enabled by kernel config
[   46.037828] PCLMULQDQ-NI instructions are not detected.
[   46.040039] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[   46.041744] NatSemi SCx200 Driver
[   46.119762] Initializing RT-Tester: OK
[   46.207338] futex hash table entries: 16 (order: -2, 1024 bytes)
[   46.208759] Initialise system trusted keyring
[   46.223614] audit: initializing netlink subsys (disabled)
[   46.226552] audit: type=3D2000 audit(1392595528.220:1): initialized
[   67.702442] bounce pool size: 64 pages
[   67.703652] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[   67.709123] VFS: Disk quotas dquot_6.5.2
[   67.727425] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   67.734030] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   67.739873] NTFS driver 2.1.30 [Flags: R/O].
[   67.740842] ROMFS MTD (C) 2007 Red Hat, Inc.
[   67.742033] QNX4 filesystem 0.2.3 registered.
[   67.742398] fuse init (API version 7.22)
[   67.766436] JFS: nTxBlock =3D 2075, nTxLock =3D 16606
[   67.782887] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[   67.792725] NILFS version 2 loaded
[   67.793041] BeFS version: 0.9.3
[   67.813070] ocfs2: Registered cluster interface o2cb
[   67.815690] OCFS2 User DLM kernel interface loaded
[   67.960183] Key type asymmetric registered
[   67.960659] Asymmetric key parser 'x509' registered
[   67.962387] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[   67.967549] io scheduler noop registered
[   67.967951] io scheduler deadline registered
[   67.968695] io scheduler cfq registered (default)
[   67.997472] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[   67.997862] crc32: self tests passed, processed 225944 bytes in 2682600 =
nsec
[   68.002336] crc32c: CRC_LE_BITS =3D 64
[   68.003040] crc32c: self tests passed, processed 225944 bytes in 2337930=
 nsec
[   69.803183] crc32_combine: 8373 self tests passed
[   71.553576] crc32c_combine: 8373 self tests passed
[   71.572373] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   71.573721] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   71.588621] rivafb_setup START
[   71.592315] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   71.615607] vmlfb: initializing
[   71.616726] Could not find Carillo Ranch MCH device.
[   71.622210] no IO addresses supplied
[   71.647061] ipmi message handler version 39.2
[   71.647585] ipmi device interface
[   71.665797] IPMI System Interface driver.
[   71.667670] ipmi_si: Adding default-specified kcs state machine
[   71.668147] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   71.669343] ipmi_si: Interface detection failed
[   71.693751] ipmi_si: Adding default-specified smic state machine
[   71.694120] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   71.694748] ipmi_si: Interface detection failed
[   71.723124] ipmi_si: Adding default-specified bt state machine
[   71.723521] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   71.724523] ipmi_si: Interface detection failed
[   71.755983] ipmi_si: Unable to find any System Interface(s)
[   71.870890] isapnp: Scanning for PnP cards...
[   71.990859] isapnp: No Plug & Play device found
[   71.992231] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   72.058151] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   72.058772] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[   72.100045] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   72.100467] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[   72.154810] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   72.196394] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[   77.377575] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   77.408395] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   77.534952] lp: driver loaded but no devices found
[   77.536794] DoubleTalk PC - not found
[   77.585165] Non-volatile memory driver v1.3
[   77.586232] ppdev: user-space parallel port driver
[   77.586671] scx200_gpio: no SCx200 gpio present
[   77.590199] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   77.590912] platform pc8736x_gpio.0: no device found
[   77.596779] nsc_gpio initializing
[   77.597430] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   77.598070] Linux agpgart interface v0.103
[   77.678782] parport_pc 00:04: reported by Plug and Play ACPI
[   77.680469] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   77.785130] lp0: using parport0 (interrupt-driven).
[   77.957617] Floppy drive(s): fd0 is 1.44M
[   78.012667] FDC 0 is a S82078B
[   79.427359] brd: module loaded
[   79.459137] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[   79.459739] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[   79.466328] blk-mq: CPU -> queue map
[   79.466605]   CPU 0 -> Queue 0
[   79.466821]   CPU 1 -> Queue 0
[   79.538227]  vda: unknown partition table
[   79.580195] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[   79.580735] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[   79.606189] blk-mq: CPU -> queue map
[   79.606451]   CPU 0 -> Queue 0
[   79.606614]   CPU 1 -> Queue 0
[   79.634794]  vdb: unknown partition table
[   79.659405] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[   79.659882] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[   79.685751] blk-mq: CPU -> queue map
[   79.685969]   CPU 0 -> Queue 0
[   79.686131]   CPU 1 -> Queue 0
[   94.419965]  vdc: unknown partition table
[   94.465230] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[   94.465769] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[   94.487014] blk-mq: CPU -> queue map
[   94.487270]   CPU 0 -> Queue 0
[   94.487442]   CPU 1 -> Queue 0
[   94.536003]  vdd: unknown partition table
[   94.557939] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[   94.558512] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[   94.577164] blk-mq: CPU -> queue map
[   94.577442]   CPU 0 -> Queue 0
[   94.577636]   CPU 1 -> Queue 0
[   94.622791]  vde: unknown partition table
[   94.645350] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[   94.646661] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[   94.696992] blk-mq: CPU -> queue map
[   94.696992]   CPU 0 -> Queue 0
[   94.696992]   CPU 1 -> Queue 0
[   94.716845]  vdf: unknown partition table
[   94.776794] blk-mq: CPU -> queue map
[   94.777007]   CPU 0 -> Queue 0
[   94.777182]   CPU 1 -> Queue 0
[   94.797447]  nullb0: unknown partition table
[   94.819721] blk-mq: CPU -> queue map
[   94.819944]   CPU 0 -> Queue 0
[   94.820105]   CPU 1 -> Queue 0
[   94.847065]  nullb1: unknown partition table
[   94.866516] null: module loaded
[   94.883706] dummy-irq: no IRQ given.  Use irq=3DN
[   94.924117] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   94.944276] c2port c2port0: C2 port uc added
[   94.944731] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   95.028217] Uniform Multi-Platform E-IDE driver
[   95.079732] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   95.082635] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[   95.086110]     ide0: BM-DMA at 0xc1c0-0xc1c7
[   95.088049]     ide1: BM-DMA at 0xc1c8-0xc1cf
[   95.088876] Probing IDE interface ide0...
[   95.745836] Probing IDE interface ide1...
[   96.533335] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   97.278482] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   97.282325] hdc: MWDMA2 mode selected
[   97.286865] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   97.288066] ide1 at 0x170-0x177,0x376 on irq 15
[   97.355049] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   97.356511] ide-cd driver 5.00
[   97.390156] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[   97.391172] cdrom: Uniform CD-ROM driver Revision: 3.20
[   97.464167] BUG: unable to handle kernel NULL pointer dereference at 000=
0001c
[   97.464897] IP: [<8130f33d>] kernfs_path_locked+0x7d/0xc0
[   97.465519] *pde =3D 00000000=20
[   97.465960] Oops: 0000 [#1] SMP=20
[   97.466936] CPU: 0 PID: 24 Comm: kworker/0:1 Tainted: G S      W    3.14=
=2E0-rc2-01592-g97162c1 #6
[   97.467818] Workqueue: events_freezable_power_ disk_events_workfn
[   97.468342] task: 801c7560 ti: 801d6000 task.ti: 801d6000
[   97.468836] EIP: 0060:[<8130f33d>] EFLAGS: 00000046 CPU: 0
[   97.469291] EIP is at kernfs_path_locked+0x7d/0xc0
[   97.469636] EAX: 00000000 EBX: 00000000 ECX: 801d7c34 EDX: 801d7bb4
[   97.470024] ESI: 00000046 EDI: 801d7c33 EBP: 801d7b68 ESP: 801d7b58
[   97.470505]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   97.470929] CR0: 8005003b CR2: 0000001c CR3: 03b92000 CR4: 00300690
[   97.471550] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   97.472155] DR6: 00000000 DR7: 00000000
[   97.472397] Stack:
[   97.472397]  801d7bb4 00000000 00000046 801d7bb4 801d7b80 8130fe59 00000=
080 929c0ce0
[   97.472397]  929ae498 00000018 801d7c40 8199b88a 00000002 00000001 00000=
000 8199b650
[   97.472397]  929ae498 00000000 00000001 801c7560 929ae5e4 929b46f8 929c0=
ca0 819978d0
[   97.472397] Call Trace:
[   97.472397]  [<8130fe59>] kernfs_path+0x49/0x80
[   97.472397]  [<8199b88a>] cfq_find_alloc_queue+0x3fa/0x620
[   97.472397]  [<8199b650>] ? cfq_find_alloc_queue+0x1c0/0x620
[   97.472397]  [<819978d0>] ? cfq_put_request+0x220/0x220
[   97.472397]  [<8199bca5>] ? cfq_set_request+0x85/0x740
[   97.472397]  [<8111e5ce>] ? do_raw_spin_lock+0xe/0x2e0
[   97.472397]  [<8199bb35>] cfq_get_queue+0x85/0x170
[   97.472397]  [<8199bff7>] cfq_set_request+0x3d7/0x740
[   97.472397]  [<81245b79>] ? slob_alloc.isra.10+0x59/0x360
[   97.472397]  [<8111e929>] ? do_raw_spin_unlock+0x9/0x140
[   97.472397]  [<819b473a>] ? memset+0xa/0x40
[   97.472397]  [<81245e4a>] ? slob_alloc.isra.10+0x32a/0x360
[   97.472397]  [<81966510>] ? ioc_create_icq+0xc0/0x270
[   97.472397]  [<819a6fad>] ? radix_tree_insert+0xad/0x440
[   97.472397]  [<8111e929>] ? do_raw_spin_unlock+0x9/0x140
[   97.472397]  [<82e1f64d>] ? _raw_spin_unlock_irq+0x6d/0xc0
[   97.472397]  [<8199bc20>] ? cfq_get_queue+0x170/0x170
[   97.472397]  [<8195154d>] elv_set_request+0x3d/0x70
[   97.472397]  [<81958e79>] get_request+0x6d9/0xf00
[   97.472397]  [<819587eb>] ? get_request+0x4b/0xf00
[   97.472397]  [<811075d0>] ? __wake_up_common+0xd0/0xd0
[   97.472397]  [<8195b54d>] blk_get_request+0xfd/0x200
[   97.472397]  [<81d35d98>] ide_cd_queue_pc+0x58/0x300
[   97.472397]  [<810f9cf9>] ? dequeue_task_fair+0x519/0x9b0
[   97.472397]  [<81d3617c>] cdrom_check_status+0x8c/0xb0
[   97.472397]  [<81d37b6f>] ide_cdrom_check_events_real+0x3f/0x70
[   97.472397]  [<827a10a4>] cdrom_check_events+0x24/0x50
[   97.472397]  [<81d33c36>] idecd_check_events+0x26/0x40
[   97.472397]  [<8197543b>] disk_check_events+0x4b/0x1f0
[   97.472397]  [<81975606>] disk_events_workfn+0x26/0x40
[   97.472397]  [<810c09ea>] process_one_work+0x29a/0x9d0
[   97.472397]  [<810c08f7>] ? process_one_work+0x1a7/0x9d0
[   97.472397]  [<8111e5ce>] ? do_raw_spin_lock+0xe/0x2e0
[   97.472397]  [<810c1927>] worker_thread+0x2c7/0x770
[   97.472397]  [<810c1660>] ? rescuer_thread+0x540/0x540
[   97.472397]  [<810cde05>] kthread+0x115/0x160
[   97.472397]  [<82e2193b>] ret_from_kernel_thread+0x1b/0x30
[   97.472397]  [<810cdcf0>] ? __kthread_unpark+0xd0/0xd0
[   97.472397] Code: 2f 8b 5b 18 85 db 74 4f 83 05 b8 9a 0a 84 01 83 15 bc =
9a 0a 84 00 8b 43 18 85 c0 74 3a 83 05 c0 9a 0a 84 01 83 15 c4 9a 0a 84 00 =
<8b> 43 1c 89 fe e8 49 59 6a 00 2b 75 f0 89 c1 8d 40 01 39 c6 7d
[   97.472397] EIP: [<8130f33d>] kernfs_path_locked+0x7d/0xc0 SS:ESP 0068:8=
01d7b58
[   97.472397] CR2: 000000000000001c
[   97.472397] ---[ end trace afe459c58c4c3ec6 ]---
[   97.472397] note: kworker/0:1[24] exited with preempt_count 3
[   97.472397] ------------[ cut here ]------------
[   97.472397] WARNING: CPU: 0 PID: 24 at kernel/smp.c:210 smp_call_functio=
n_single+0x23a/0x450()
[   97.472397] CPU: 0 PID: 24 Comm: kworker/0:1 Tainted: G S    D W    3.14=
=2E0-rc2-01592-g97162c1 #6
[   97.472397]  83461af4 801d78f8 82e0217e 00000000 801d7928 8108fc7d 8345b=
3ac 00000000
[   97.472397]  00000018 83461af4 000000d2 8115af3a 8115af3a 00000000 00000=
000 811c9bf0
[   97.472397]  801d7938 8108fe1e 00000009 00000000 801d7964 8115af3a 801d7=
970 00000000
[   97.472397] Call Trace:
[   97.472397]  [<82e0217e>] dump_stack+0xb8/0x108
[   97.472397]  [<8108fc7d>] warn_slowpath_common+0xcd/0x110
[   97.472397]  [<8115af3a>] ? smp_call_function_single+0x23a/0x450
[   97.472397]  [<8115af3a>] ? smp_call_function_single+0x23a/0x450
[   97.472397]  [<811c9bf0>] ? perf_event_disable+0x130/0x130
[   97.472397]  [<8108fe1e>] warn_slowpath_null+0x3e/0x50
[   97.472397]  [<8115af3a>] smp_call_function_single+0x23a/0x450
[   97.472397]  [<811c98c0>] ? task_function_call+0x80/0x80
[   97.472397]  [<811c98a6>] task_function_call+0x66/0x80
[   97.472397]  [<811d40a0>] ? perf_cgroup_switch+0x480/0x480
[   97.472397]  [<811c98f3>] perf_cgroup_exit+0x33/0x50
[   97.472397]  [<81167f1c>] cgroup_exit+0x13c/0x190
[   97.472397]  [<810943b1>] do_exit+0x4a1/0x1250
[   97.472397]  [<81126334>] ? kmsg_dump+0x1b4/0x1e0
[   97.472397]  [<811261cb>] ? kmsg_dump+0x4b/0x1e0
[   97.472397]  [<8100b2bd>] oops_end+0xed/0x140
[   97.472397]  [<82df6e9f>] no_context+0x33b/0x351
[   97.472397]  [<82df719a>] __bad_area_nosemaphore+0x2e5/0x2fb
[   97.472397]  [<82df72a6>] bad_area_nosemaphore+0x25/0x35
[   97.472397]  [<8106d5b8>] __do_page_fault+0x5b8/0xb60
[   97.472397]  [<810fdcc2>] ? trigger_load_balance+0x172/0x590
[   97.472397]  [<81245b79>] ? slob_alloc.isra.10+0x59/0x360
[   97.472397]  [<81244efe>] ? slob_page_alloc+0xe/0x440
[   97.472397]  [<8106de30>] ? vmalloc_sync_all+0x2d0/0x2d0
[   97.472397]  [<8106de4b>] do_page_fault+0x1b/0x30
[   97.472397]  [<82e216ef>] error_code+0x5f/0x70
[   97.472397]  [<8106de30>] ? vmalloc_sync_all+0x2d0/0x2d0
[   97.472397]  [<8130f33d>] ? kernfs_path_locked+0x7d/0xc0
[   97.472397]  [<8130fe59>] kernfs_path+0x49/0x80
[   97.472397]  [<8199b88a>] cfq_find_alloc_queue+0x3fa/0x620
[   97.472397]  [<8199b650>] ? cfq_find_alloc_queue+0x1c0/0x620
[   97.472397]  [<819978d0>] ? cfq_put_request+0x220/0x220
[   97.472397]  [<8199bca5>] ? cfq_set_request+0x85/0x740
[   97.472397]  [<8111e5ce>] ? do_raw_spin_lock+0xe/0x2e0
[   97.472397]  [<8199bb35>] cfq_get_queue+0x85/0x170
[   97.472397]  [<8199bff7>] cfq_set_request+0x3d7/0x740
[   97.472397]  [<81245b79>] ? slob_alloc.isra.10+0x59/0x360
[   97.472397]  [<8111e929>] ? do_raw_spin_unlock+0x9/0x140
[   97.472397]  [<819b473a>] ? memset+0xa/0x40
[   97.472397]  [<81245e4a>] ? slob_alloc.isra.10+0x32a/0x360
[   97.472397]  [<81966510>] ? ioc_create_icq+0xc0/0x270
[   97.472397]  [<819a6fad>] ? radix_tree_insert+0xad/0x440
[   97.472397]  [<8111e929>] ? do_raw_spin_unlock+0x9/0x140
[   97.472397]  [<82e1f64d>] ? _raw_spin_unlock_irq+0x6d/0xc0
[   97.472397]  [<8199bc20>] ? cfq_get_queue+0x170/0x170
[   97.472397]  [<8195154d>] elv_set_request+0x3d/0x70
[   97.472397]  [<81958e79>] get_request+0x6d9/0xf00
[   97.472397]  [<819587eb>] ? get_request+0x4b/0xf00
[   97.472397]  [<811075d0>] ? __wake_up_common+0xd0/0xd0
[   97.472397]  [<8195b54d>] blk_get_request+0xfd/0x200
[   97.472397]  [<81d35d98>] ide_cd_queue_pc+0x58/0x300
[   97.472397]  [<810f9cf9>] ? dequeue_task_fair+0x519/0x9b0
[   97.472397]  [<81d3617c>] cdrom_check_status+0x8c/0xb0
[   97.472397]  [<81d37b6f>] ide_cdrom_check_events_real+0x3f/0x70
[   97.472397]  [<827a10a4>] cdrom_check_events+0x24/0x50
[   97.472397]  [<81d33c36>] idecd_check_events+0x26/0x40
[   97.472397]  [<8197543b>] disk_check_events+0x4b/0x1f0
[   97.472397]  [<81975606>] disk_events_workfn+0x26/0x40
[   97.472397]  [<810c09ea>] process_one_work+0x29a/0x9d0
[   97.472397]  [<810c08f7>] ? process_one_work+0x1a7/0x9d0
[   97.472397]  [<8111e5ce>] ? do_raw_spin_lock+0xe/0x2e0
[   97.472397]  [<810c1927>] worker_thread+0x2c7/0x770
[   97.472397]  [<810c1660>] ? rescuer_thread+0x540/0x540
[   97.472397]  [<810cde05>] kthread+0x115/0x160
[   97.472397]  [<82e2193b>] ret_from_kernel_thread+0x1b/0x30
[   97.472397]  [<810cdcf0>] ? __kthread_unpark+0xd0/0xd0
[   97.472397] ---[ end trace afe459c58c4c3ec7 ]---
[   97.581121] Loading iSCSI transport class v2.0-870.
[   97.620637] alua: device handler registered
[   97.627428] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.1 (Sep=
 17, 2013)
[   97.639159] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   97.639629] Detecting Adaptec I2O RAID controllers...
[   97.671167] Adaptec aacraid driver 1.2-0[30200]-ms
[   97.674635] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   97.680049] scsi: <fdomain> Detection failed (no card)
[   97.683600] NCR53c406a: no available ports found
[   97.684024] sym53c416.c: Version 1.0.0-ac
[   97.684912] qlogicfas: no cards were found, please specify I/O address a=
nd IRQ using iobase=3D and irq=3D options
[   97.709805] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.12-k.
[   97.715659] iscsi: registered transport (qla4xxx)
[   97.717014] QLogic iSCSI HBA Driver
[   97.717343] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[   97.740867] csiostor: Chelsio FCoE driver 1.0.0
[   97.874017] DC390: clustering now enabled by default. If you get problem=
s load
[   97.874338]        with "disable_clustering=3D1" and report to maintaine=
rs
[   97.875150] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[   97.894606] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[   97.895527] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[   97.896812] mpt3sas version 02.100.00.00 loaded
[   97.916318] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   97.931517] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[   97.934112] ppa: Version 2.07 (for Linux 2.4.x)
[   97.935510] imm: Version 2.05 (for Linux 2.4.0)
[   97.936496] nsp32: loading...
[   97.937226] RocketRAID 3xxx/4xxx Controller driver v1.8
[   97.938026] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   97.954854] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2=
013)
[   97.956376] iscsi: registered transport (bnx2i)
[   97.959123] iscsi: registered transport (be2iscsi)
[   97.959387] In beiscsi_module_init, tt=3D838aac60
[   98.036154] VMware PVSCSI driver - version 1.0.2.0-k
[   98.037479] osst :I: Tape driver with OnStream support version 0.99.4
[   98.037479] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   98.158438] scsi_debug: host protection
[   98.158823] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[   98.249388] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[   98.249940] device id =3D 2440
[   98.250142] device id =3D 2480
[   98.250359] device id =3D 24c0
[   98.250529] device id =3D 24d0
[   98.250698] device id =3D 25a1
[   98.250868] device id =3D 2670
[   98.256117] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[   98.265783] Failed to ioremap_nocache
[   98.369563] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[   98.370084] pmc551: not detected
[   98.375623] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[   98.425220] ftl_cs: FTL header not found.
[   98.571404] No valid DiskOnChip devices found
[   98.576301] HSI/SSI char device loaded
[   98.626991] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[   99.214200] arcnet loaded.
[   99.214543] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[   99.214955] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   99.215412] arcnet: raw mode (`r') encapsulation support loaded.
[   99.215860] arcnet: cap mode (`c') encapsulation support loaded.
[   99.216559] arcnet: COM90xx chipset support
[   99.327162] S3: No ARCnet cards found.
[   99.328368] arcnet: RIM I (entirely mem-mapped) support
[   99.328635] E-mail me if you actually test the RIM I driver, please!
[   99.328955] Given: node 00h, shmem 0h, irq 0
[   99.329190] No autoprobe for RIM I; you must specify the shmem and irq!
[   99.329646] vcan: Virtual CAN interface driver
[   99.330147] CAN device driver interface
[   99.354766] cc770: CAN netdevice driver
[   99.409868] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[   99.415034] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   99.415331] Copyright (c) 2007 Atheros Corporation.
[   99.419860] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[   99.423588] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[   99.426154] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[   99.477013] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   99.477385] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   99.478655] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[   99.479009] igb: Copyright (c) 2007-2013 Intel Corporation.
[   99.480281] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.12.1-k
[   99.480724] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   99.483612] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.30-k
[   99.484023] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[   99.485732] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[   99.486101] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   99.487331] i40evf: Intel(R) XL710 X710 Virtual Function Network Driver =
- version 0.9.11
[   99.487740] Copyright (c) 2013 Intel Corporation.
[   99.511424] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   99.545646] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   99.548398] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.55
[   99.575539] QLogic/NetXen Network Driver v4.0.82
[   99.577582] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[   99.604785] Solarflare NET driver v4.0
[   99.635775] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   99.636083] tehuti: Options: hw_csum=20
[   99.696493] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[   99.696915] plip0: Parallel port at 0x378, using IRQ 7.
[   99.697226] PPP generic driver version 2.4.2
[   99.720417] PPP BSD Compression module registered
[   99.720730] PPP Deflate Compression module registered
[   99.721002] NET: Registered protocol family 24
[   99.721768] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   99.723765] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   99.725418] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2=
=2E2k
[   99.725688] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   99.726871] libipw: 802.11 data/management/control stack, git-1.1.13
[   99.727100] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[   99.727476] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[   99.727879] orinoco_plx 0.15 (Pavel Roskin <proski@gnu.org>, David Gibso=
n <hermes@gibson.dropbear.id.au>, Daniel Barlow <dan@telent.net>)
[   99.728954] orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
[   99.730045] airo(): Probing for PCI adapters
[   99.747186] airo(): Finished probing for PCI adapters
[   99.747529] Loaded prism54 driver, version 1.2
[   99.766458] Madge ATM Ambassador driver version 1.2.4
[   99.767496] Madge ATM Horizon [Ultra] driver version 1.2.1
[   99.769621] idt77252_init: at 83af5c85
[   99.770432] Solos PCI Driver Version 1.04
[   99.786556] adummy: version 1.0
[   99.808462] Fusion MPT base driver 3.04.20
[   99.808778] Copyright (c) 1999-2008 LSI Corporation
[   99.809644] Fusion MPT SPI Host driver 3.04.20
[   99.811115] Fusion MPT FC Host driver 3.04.20
[   99.814450] Fusion MPT SAS Host driver 3.04.20
[   99.815898] Fusion MPT misc device (ioctl) driver 3.04.20
[   99.840698] mptctl: Registered with Fusion MPT base driver
[   99.841048] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   99.841470] Fusion MPT LAN driver 3.04.20
[   99.937731] aoe: AoE v85 initialised.
[   99.939743] paride: aten registered as protocol 0
[   99.940176] paride: bpck registered as protocol 1
[   99.940592] paride: dstr registered as protocol 2
[   99.940970] paride: epat registered as protocol 3
[   99.941304] paride: epia registered as protocol 4
[   99.941756] paride: fit3 registered as protocol 5
[   99.943994] paride: on26 registered as protocol 6
[   99.944313] bpck6: BACKPACK Protocol Driver V2.0.2
[   99.944536] bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. U=
SA
[   99.944784] paride: bpck6 registered as protocol 7
[   99.946478] pcd: pcd version 1.07, major 46, nice 0
[  100.446344] pcd0: Autoprobe failed
[  100.446642] pcd: No CD-ROM drive found
[  100.447409] pt: pt version 1.04, major 96
[  101.327553] pt0: Autoprobe failed
[  101.327874] pt: No ATAPI tape drive detected
[  101.328373] pg: pg version 1.02, major 97
[  101.845528] pga: Autoprobe failed
[  101.845823] pg: No ATAPI device detected
[  101.849532] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[  101.902547] serio: i8042 KBD port at 0x60,0x64 irq 1
[  101.903104] serio: i8042 AUX port at 0x60,0x64 irq 12
[  103.223296] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[  103.732659] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[  104.003294] mk712: device not present

Elapsed time: 140
qemu-system-x86_64 -cpu qemu64,+smep,+smap -kernel /kernel/i386-randconfig-=
nh0-02162347/97162c1b407ab8dbcc637c316b772dd0572deddc/vmlinuz-3.14.0-rc2-01=
592-g97162c1 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watch=
dog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-rand=
config-nh0-02162347/linux-devel:devel-hourly-2014021619/.vmlinuz-97162c1b40=
7ab8dbcc637c316b772dd0572deddc-20140217000347-1-waimea branch=3Dlinux-devel=
/devel-hourly-2014021619 BOOT_IMAGE=3D/kernel/i386-randconfig-nh0-02162347/=
97162c1b407ab8dbcc637c316b772dd0572deddc/vmlinuz-3.14.0-rc2-01592-g97162c1'=
  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic=
,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::30240-:22 -boot o=
rder=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -soundhw hda =
-drive file=3D/fs/LABEL=3DKVM/disk0-quantal-waimea-7,media=3Ddisk,if=3Dvirt=
io -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-waimea-7,media=3Ddisk,if=3Dv=
irtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-waimea-7,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-waimea-7,media=3Ddisk=
,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-waimea-7,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-waimea-7,media=
=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-waimea-7 -serial fi=
le:/dev/shm/kboot/serial-quantal-waimea-7 -daemonize -display none -monitor=
 null=20

--jho1yZJdad60DJr+
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-nh0-02162347-97162c1b407ab8dbcc637c316b772dd0572deddc-WARNING:----at----smp_call_function_single+-x-37158.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGIyOGE5NjBjNDJmY2Q5Y2ZjOTg3NDQxZmE2ZDFjMWE0NzFmMGY5ZWQK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDIxNjIzNDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6YjI4YTk2MGM0
MmZjZDljZmM5ODc0NDFmYTZkMWMxYTQ3MWYwZjllZDpiaXNlY3QtbGludXgKMjAxNC0wMi0x
NyAxMjozNjozNzogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVz
Zy0qJyAnLXMnICctbCcgJ1dBUk5JTkc6IC4qIGF0IC4qIHNtcF9jYWxsX2Z1bmN0aW9uX3Np
bmdsZSsweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny9iMjhhOTYw
YzQyZmNkOWNmYzk4NzQ0MWZhNmQxYzFhNDcxZjBmOWVkJyAsIHJldD0yLCByZWY6IC9rZXJu
ZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTEy
OjM2OjM3IGIyOGE5NjBjNDJmY2Q5Y2ZjOTg3NDQxZmE2ZDFjMWE0NzFmMGY5ZWQgY29tcGls
aW5nCjE1MSByZWFsICAyNTQwIHVzZXIgIDEyNyBzeXMgIDE3NjUuNzclIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMjE2MjM0NwoKMjAxNC0wMi0xNy0xMjozOToxNSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjE0LjAtcmMyLi4uCTMJMTIJMTUJMTYuCTE4LgkxOQkyMCBTVUNDRVNT
CgpiaXNlY3Q6IGdvb2QgY29tbWl0IGIyOGE5NjBjNDJmY2Q5Y2ZjOTg3NDQxZmE2ZDFjMWE0
NzFmMGY5ZWQKZ2l0IGJpc2VjdCBzdGFydCA5NzE2MmMxYjQwN2FiOGRiY2M2MzdjMzE2Yjc3
MmRkMDU3MmRlZGRjIGIyOGE5NjBjNDJmY2Q5Y2ZjOTg3NDQxZmE2ZDFjMWE0NzFmMGY5ZWQg
LS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiOTcxNjJjMWI0MDdh
YjhkYmNjNjM3YzMxNmI3NzJkZDA1NzJkZWRkYyIsICItZyIsICJiMjhhOTYwYzQyZmNkOWNm
Yzk4NzQ0MWZhNmQxYzFhNDcxZjBmOWVkIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0Il0K
QmlzZWN0aW5nOiAxNTkyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMSBzdGVwcykKW2ZhYzM3NzA0NGZiMDRlYzc1OWRiMWRkODRmYWIzMzEyYjcxODU0
MWFdIE1lcmdlICdhc29jL3RvcGljL2lvJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDIxNjE5
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwMjE2MTk6ZmFjMzc3MDQ0ZmIwNGVjNzU5ZGIxZGQ4NGZhYjMzMTJi
NzE4NTQxYTpiaXNlY3QtbGludXgKMjAxNC0wMi0xNyAxMjo0NToxNjogY21kX2ZhaWw6ICcv
YmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMnICctbCcgJ1dBUk5JTkc6
IC4qIGF0IC4qIHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweCcgJy9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLW5oMC0wMjE2MjM0Ny9mYWMzNzcwNDRmYjA0ZWM3NTlkYjFkZDg0ZmFiMzMx
MmI3MTg1NDFhJyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUt
Z3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTEyOjQ1OjE2IGZhYzM3NzA0NGZiMDRlYzc1
OWRiMWRkODRmYWIzMzEyYjcxODU0MWEgY29tcGlsaW5nCjE1MSByZWFsICAyNTIzIHVzZXIg
IDEyOCBzeXMgIDE3NTMuMDUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NwoK
MjAxNC0wMi0xNy0xMjo0Nzo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAw
Njc2LWdmYWMzNzcwLi4uCTE4Li4uCTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogOTE2IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2U0
YTFkMmJjMzk2MGM1NTlhMTMwZGIzY2E5OTk1MjFjODEyMGZiZmJdIE1lcmdlICdsdW5uL3Yz
LjE0LXJjMS1zeW5vbG9neS12MicgaW50byBkZXZlbC1ob3VybHktMjAxNDAyMTYxOQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2xpbnV4LWRldmVsOmRldmVsLWhv
dXJseS0yMDE0MDIxNjE5OmU0YTFkMmJjMzk2MGM1NTlhMTMwZGIzY2E5OTk1MjFjODEyMGZi
ZmI6YmlzZWN0LWxpbnV4CjIwMTQtMDItMTcgMTI6NTI6MjQ6IGNtZF9mYWlsOiAnL2Jpbi9n
cmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdXQVJOSU5HOiAuKiBh
dCAuKiBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUrMHgnICcva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1uaDAtMDIxNjIzNDcvZTRhMWQyYmMzOTYwYzU1OWExMzBkYjNjYTk5OTUyMWM4MTIw
ZmJmYicgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAt
a2J1aWxkLmxvZwoKMjAxNC0wMi0xNy0xMjo1MjoyNCBlNGExZDJiYzM5NjBjNTU5YTEzMGRi
M2NhOTk5NTIxYzgxMjBmYmZiIGNvbXBpbGluZwoxNTAgcmVhbCAgMjQ2MyB1c2VyICAxMjEg
c3lzICAxNzIyLjM4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcKCjIwMTQt
MDItMTctMTI6NTU6MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMi0wMTI3NS1n
ZTRhMWQyYi4uCTEJMTMJMTkuLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMzE3IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZGYyYTA1
ZDlkMmU1ZWM3YWFhN2YyOTEyYmY1MzE5NTU1MjVmNjE1NV0gTWVyZ2UgJ2Nncm91cC9yZXZp
ZXctcG9zdC1rZXJuZnMtY29udmVyc2lvbicgaW50byBkZXZlbC1ob3VybHktMjAxNDAyMTYx
OQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2tlcm5lbC10ZXN0cy9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDIxNjE5OmRmMmEwNWQ5ZDJlNWVjN2FhYTdmMjkxMmJmNTMxOTU1
NTI1ZjYxNTU6YmlzZWN0LWxpbnV4CjIwMTQtMDItMTcgMTM6MDA6MDE6IGNtZF9mYWlsOiAn
L2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdXQVJOSU5H
OiAuKiBhdCAuKiBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUrMHgnICcva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvZGYyYTA1ZDlkMmU1ZWM3YWFhN2YyOTEyYmY1MzE5
NTU1MjVmNjE1NScgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVl
LWdyZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0xNy0xMzowMDowMSBkZjJhMDVkOWQyZTVlYzdh
YWE3ZjI5MTJiZjUzMTk1NTUyNWY2MTU1IGNvbXBpbGluZwoxMDMgcmVhbCAgMTI5MSB1c2Vy
ICA2MiBzeXMgIDEzMTQuODAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NwoK
MjAxNC0wMi0xNy0xMzowMTo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAx
MzM3LWdkZjJhMDVkLiBURVNUIEZBSUxVUkUKWyAgICA5LjE4MjEyOF0gaWRlLWNkIGRyaXZl
ciA1LjAwClsgICAgOS4xODI5MDVdIGlkZS1jZDogaGRjOiBBVEFQSSA0WCBEVkQtUk9NIGRy
aXZlLCA1MTJrQiBDYWNoZQpbICAgIDkuMTgzNDkyXSBjZHJvbTogVW5pZm9ybSBDRC1ST00g
ZHJpdmVyIFJldmlzaW9uOiAzLjIwClsgICAgOS4yMDg2MDJdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDFjClsgICAg
OS4yMDk0MzhdIElQOiBbPDgxMzBmNDBkPl0ga2VybmZzX3BhdGhfbG9ja2VkKzB4N2QvMHhj
MApbICAgIDkuMjEwMDU5XSAqcGRlID0gMDAwMDAwMDAgClsgICAgOS4yMTA0NDddIE9vcHM6
IDAwMDAgWyMxXSBTTVAgClsgICAgOS4yMTExMDddIENQVTogMCBQSUQ6IDI0IENvbW06IGt3
b3JrZXIvMDoxIE5vdCB0YWludGVkIDMuMTQuMC1yYzItMDEzMzctZ2RmMmEwNWQgIzEyMwpb
ICAgIDkuMjEyMjI0XSBXb3JrcXVldWU6IGV2ZW50c19mcmVlemFibGVfcG93ZXJfIGRpc2tf
ZXZlbnRzX3dvcmtmbgpbICAgIDkuMjEzMDgyXSB0YXNrOiA4MDFjNTU2MCB0aTogODAxZDYw
MDAgdGFzay50aTogODAxZDYwMDAKWyAgICA5LjIxMzc0Nl0gRUlQOiAwMDYwOls8ODEzMGY0
MGQ+XSBFRkxBR1M6IDAwMDEwMDQ2IENQVTogMApbICAgIDkuMjE0MzI4XSBFSVAgaXMgYXQg
a2VybmZzX3BhdGhfbG9ja2VkKzB4N2QvMHhjMApbICAgIDkuMjE0ODI4XSBFQVg6IDAwMDAw
MDAwIEVCWDogMDAwMDAwMDAgRUNYOiA4MDFkN2MzNCBFRFg6IDgwMWQ3YmI0ClsgICAgOS4y
MTUxOTFdIEVTSTogMDAwMDAwNDYgRURJOiA4MDFkN2MzMyBFQlA6IDgwMWQ3YjY4IEVTUDog
ODAxZDdiNTgKWyAgICA5LjIxNTE5MV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdT
OiAwMDAwIFNTOiAwMDY4ClsgICAgOS4yMTUxOTFdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAw
MDAxYyBDUjM6IDAzYjdjMDAwIENSNDogMDAwMDA2OTAKWyAgICA5LjIxNTE5MV0gU3RhY2s6
ClsgICAgOS4yMTUxOTFdICA4MDFkN2JiNCAwMDAwMDAwMCAwMDAwMDA0NiA4MDFkN2JiNCA4
MDFkN2I4MCA4MTMwZmYyOSAwMDAwMDA4MCA5MmQwNjY5MApbICAgIDkuMjE1MTkxXSAgOTJk
NWZhZDggMDAwMDAwMTggODAxZDdjNDAgODE5OWJlMGEgMDAwMDAwMDIgMDAwMDAwMDEgMDAw
MDAwMDAgODE5OWJiZDAKWyAgICA5LjIxNTE5MV0gIDkyZDVmYWQ4IDAwMDAwMDAwIDAwMDAw
MDAxIDgwMWM1NTYwIDkyZDVmYzI0IDkyZGE1NmY4IDkyZDA2NWYwIDgxOTk3ZTUwClsgICAg
OS4yMTUxOTFdIENhbGwgVHJhY2U6ClsgICAgOS4yMTUxOTFdICBbPDgxMzBmZjI5Pl0ga2Vy
bmZzX3BhdGgrMHg0OS8weDgwClsgICAgOS4yMTUxOTFdICBbPDgxOTliZTBhPl0gY2ZxX2Zp
bmRfYWxsb2NfcXVldWUrMHgzZmEvMHg2MjAKWyAgICA5LjIxNTE5MV0gIFs8ODE5OWJiZDA+
XSA/IGNmcV9maW5kX2FsbG9jX3F1ZXVlKzB4MWMwLzB4NjIwClsgICAgOS4yMTUxOTFdICBb
PDgxOTk3ZTUwPl0gPyBjZnFfcHV0X3JlcXVlc3QrMHgyMjAvMHgyMjAKWyAgICA5LjIxNTE5
MV0gIFs8ODExMTgyNTU+XSA/IF9fbG9ja19hY3F1aXJlLmlzcmEuMTkrMHgzZTUvMHhjYTAK
WyAgICA5LjIxNTE5MV0gIFs8ODEwMWU4OGQ+XSA/IF9fc2F2ZV9zdGFja19hZGRyZXNzKzB4
ZC8weGQwClsgICAgOS4yMTUxOTFdICBbPDgxOTljMjI1Pl0gPyBjZnFfc2V0X3JlcXVlc3Qr
MHg4NS8weDc0MApbICAgIDkuMjE1MTkxXSAgWzw4MTExZTYzZT5dID8gZG9fcmF3X3NwaW5f
bG9jaysweGUvMHgyZTAKWyAgICA5LjIxNTE5MV0gIFs8ODE5OWMwYjU+XSBjZnFfZ2V0X3F1
ZXVlKzB4ODUvMHgxNzAKWyAgICA5LjIxNTE5MV0gIFs8ODE5OWM1Nzc+XSBjZnFfc2V0X3Jl
cXVlc3QrMHgzZDcvMHg3NDAKWyAgICA5LjIxNTE5MV0gIFs8ODE5NjZiNTg+XSA/IGlvY19j
cmVhdGVfaWNxKzB4MTg4LzB4MjcwClsgICAgOS4yMTUxOTFdICBbPDgxOWE3NTJkPl0gPyBy
YWRpeF90cmVlX2luc2VydCsweGFkLzB4NDQwClsgICAgOS4yMTUxOTFdICBbPDgxMTFlOTk5
Pl0gPyBkb19yYXdfc3Bpbl91bmxvY2srMHg5LzB4MTQwClsgICAgOS4yMTUxOTFdICBbPDgy
ZTIwZThkPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDZkLzB4YzAKWyAgICA5LjIxNTE5
MV0gIFs8ODE5OWMxYTA+XSA/IGNmcV9nZXRfcXVldWUrMHgxNzAvMHgxNzAKWyAgICA5LjIx
NTE5MV0gIFs8ODE5NTFhY2Q+XSBlbHZfc2V0X3JlcXVlc3QrMHgzZC8weDcwClsgICAgOS4y
MTUxOTFdICBbPDgxOTU5M2Y5Pl0gZ2V0X3JlcXVlc3QrMHg2ZDkvMHhmMDAKWyAgICA5LjIx
NTE5MV0gIFs8ODE5NThkNmI+XSA/IGdldF9yZXF1ZXN0KzB4NGIvMHhmMDAKWyAgICA5LjIx
NTE5MV0gIFs8ODExMDc2MzA+XSA/IF9fd2FrZV91cF9jb21tb24rMHhkMC8weGQwClsgICAg
OS4yMTUxOTFdICBbPDgxOTViYWNkPl0gYmxrX2dldF9yZXF1ZXN0KzB4ZmQvMHgyMDAKWyAg
ICA5LjIxNTE5MV0gIFs8ODFkMzViYTg+XSBpZGVfY2RfcXVldWVfcGMrMHg1OC8weDMwMApb
ICAgIDkuMjE1MTkxXSAgWzw4MTExODI1NT5dID8gX19sb2NrX2FjcXVpcmUuaXNyYS4xOSsw
eDNlNS8weGNhMApbICAgIDkuMjE1MTkxXSAgWzw4MTBmOWJhOT5dID8gZGVxdWV1ZV90YXNr
X2ZhaXIrMHgzNzkvMHg5YjAKWyAgICA5LjIxNTE5MV0gIFs8ODFkMzVmOGM+XSBjZHJvbV9j
aGVja19zdGF0dXMrMHg4Yy8weGIwClsgICAgOS4yMTUxOTFdICBbPDgxZDM3OTdmPl0gaWRl
X2Nkcm9tX2NoZWNrX2V2ZW50c19yZWFsKzB4M2YvMHg3MApbICAgIDkuMjE1MTkxXSAgWzw4
MjdhMWFlND5dIGNkcm9tX2NoZWNrX2V2ZW50cysweDI0LzB4NTAKWyAgICA5LjIxNTE5MV0g
IFs8ODFkMzNhNDY+XSBpZGVjZF9jaGVja19ldmVudHMrMHgyNi8weDQwClsgICAgOS4yMTUx
OTFdICBbPDgxOTc1OWNiPl0gZGlza19jaGVja19ldmVudHMrMHg0Yi8weDFmMApbICAgIDku
MjE1MTkxXSAgWzw4MTk3NWI5Nj5dIGRpc2tfZXZlbnRzX3dvcmtmbisweDI2LzB4NDAKWyAg
ICA5LjIxNTE5MV0gIFs8ODEwYzBhMGE+XSBwcm9jZXNzX29uZV93b3JrKzB4MjlhLzB4OWQw
ClsgICAgOS4yMTUxOTFdICBbPDgxMGMwOTE3Pl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MWE3
LzB4OWQwClsgICAgOS4yMTUxOTFdICBbPDgxMTFlNjNlPl0gPyBkb19yYXdfc3Bpbl9sb2Nr
KzB4ZS8weDJlMApbICAgIDkuMjE1MTkxXSAgWzw4MTBjMTk0Nz5dIHdvcmtlcl90aHJlYWQr
MHgyYzcvMHg3NzAKWyAgICA5LjIxNTE5MV0gIFs8ODEwYzE2ODA+XSA/IHJlc2N1ZXJfdGhy
ZWFkKzB4NTQwLzB4NTQwClsgICAgOS4yMTUxOTFdICBbPDgxMGNkZTI1Pl0ga3RocmVhZCsw
eDExNS8weDE2MApbICAgIDkuMjE1MTkxXSAgWzw4MmUyMzE3Yj5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgxYi8weDMwClsgICAgOS4yMTUxOTFdICBbPDgxMGNkZDEwPl0gPyBfX2t0
aHJlYWRfdW5wYXJrKzB4ZDAvMHhkMApbICAgIDkuMjE1MTkxXSBDb2RlOiAyZiA4YiA1YiAx
OCA4NSBkYiA3NCA0ZiA4MyAwNSBiOCAzYSAwOSA4NCAwMSA4MyAxNSBiYyAzYSAwOSA4NCAw
MCA4YiA0MyAxOCA4NSBjMCA3NCAzYSA4MyAwNSBjMCAzYSAwOSA4NCAwMSA4MyAxNSBjNCAz
YSAwOSA4NCAwMCA8OGI+IDQzIDFjIDg5IGZlIGU4IGY5IDVkIDZhIDAwIDJiIDc1IGYwIDg5
IGMxIDhkIDQwIDAxIDM5IGM2IDdkClsgICAgOS4yMTUxOTFdIEVJUDogWzw4MTMwZjQwZD5d
IGtlcm5mc19wYXRoX2xvY2tlZCsweDdkLzB4YzAgU1M6RVNQIDAwNjg6ODAxZDdiNTgKWyAg
ICA5LjIxNTE5MV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDFjClsgICAgOS4yMTUxOTFdIC0tLVsg
ZW5kIHRyYWNlIDliYjIwNTI3YTUzNWU1ZTkgXS0tLQpbICAgIDkuMjE1MTkxXSBub3RlOiBr
d29ya2VyLzA6MVsyNF0gZXhpdGVkIHdpdGggcHJlZW1wdF9jb3VudCAzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny9kZjJhMDVkOWQyZTVlYzdhYWE3ZjI5MTJiZjUz
MTk1NTUyNWY2MTU1L2RtZXNnLXF1YW50YWwtYXRoZW5zLTEyOjIwMTQwMjE3MTMwMjEwOmkz
ODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDc6My4xNC4wLXJjMi0wMTMzNy1nZGYyYTA1ZDox
MjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2RmMmEwNWQ5ZDJlNWVj
N2FhYTdmMjkxMmJmNTMxOTU1NTI1ZjYxNTUvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzA6MjAx
NDAyMTcxMzAyMTU6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAx
MzM3LWdkZjJhMDVkOjEyMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcv
ZGYyYTA1ZDlkMmU1ZWM3YWFhN2YyOTEyYmY1MzE5NTU1MjVmNjE1NS9kbWVzZy1xdWFudGFs
LWF0aGVucy01OToyMDE0MDIxNzEzMDIxMDppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3
OjMuMTQuMC1yYzItMDEzMzctZ2RmMmEwNWQ6MTIzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LW5oMC0wMjE2MjM0Ny9kZjJhMDVkOWQyZTVlYzdhYWE3ZjI5MTJiZjUzMTk1NTUyNWY2MTU1
L2RtZXNnLXF1YW50YWwteGlhbi0xNjoyMDE0MDIxNzEzMDIxMDppMzg2LXJhbmRjb25maWct
bmgwLTAyMTYyMzQ3OjMuMTQuMC1yYzItMDEzMzctZ2RmMmEwNWQ6MTIzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny9kZjJhMDVkOWQyZTVlYzdhYWE3ZjI5MTJiZjUz
MTk1NTUyNWY2MTU1L2RtZXNnLXlvY3RvLXhpYW4tMjA6MjAxNDAyMTcxMzAyMTA6aTM4Ni1y
YW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAxMzM3LWdkZjJhMDVkOjEyMwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvZGYyYTA1ZDlkMmU1ZWM3YWFh
N2YyOTEyYmY1MzE5NTU1MjVmNjE1NS9kbWVzZy15b2N0by14aWFuLTYzOjIwMTQwMjE3MTMw
MjA3OmkzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDc6My4xNC4wLXJjMi0wMTMzNy1nZGYy
YTA1ZDoxMjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2RmMmEwNWQ5
ZDJlNWVjN2FhYTdmMjkxMmJmNTMxOTU1NTI1ZjYxNTUvZG1lc2ctcXVhbnRhbC1jYWlyby01
NDoyMDE0MDIxNzEzMDIxODppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3OjMuMTQuMC1y
YzItMDEzMzctZ2RmMmEwNWQ6MTIzCjA6Nzo3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTAyLTE3IDEzOjAyOjIwIFJFUEVBVCBDT1VOVDogMjAgICMgL2tlcm5l
bC10ZXN0cy9saW51eC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDYyIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNTQy
YjgzNjkwM2Y4YWE1MzNlZmM0OGMwZDRiMjY5MzAzZjE0ODg1ZV0gTWVyZ2UgJ2lucHV0L2Zv
ci1saW51cycgaW50byBkZXZlbC1ob3VybHktMjAxNDAyMTYxOQpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctbmgwLTAyMTYyMzQ3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIx
NjE5OjU0MmI4MzY5MDNmOGFhNTMzZWZjNDhjMGQ0YjI2OTMwM2YxNDg4NWU6YmlzZWN0LWxp
bnV4CjIwMTQtMDItMTcgMTM6MDI6MjA6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICct
LWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdXQVJOSU5HOiAuKiBhdCAuKiBzbXBfY2Fs
bF9mdW5jdGlvbl9zaW5nbGUrMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIx
NjIzNDcvNTQyYjgzNjkwM2Y4YWE1MzNlZmM0OGMwZDRiMjY5MzAzZjE0ODg1ZScgLCByZXQ9
MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoK
MjAxNC0wMi0xNy0xMzowMjoyMCA1NDJiODM2OTAzZjhhYTUzM2VmYzQ4YzBkNGIyNjkzMDNm
MTQ4ODVlIGNvbXBpbGluZwo5NSByZWFsICAxMDY3IHVzZXIgIDQ4IHN5cyAgMTE3My40NSUg
Y3B1IAlpMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3CgoyMDE0LTAyLTE3LTEzOjA0OjAy
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzItMDEyODgtZzU0MmI4MzYuLi4JMTEJ
MjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzNhMjQzOTVmNTkzMDVlNzk5NTY5MGU2NWU1NTkz
MDgyYWU4ZDljMWJdIE1lcmdlICd0YXJnZXQvbWFzdGVyJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDIxNjE5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvbGludXgt
ZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6M2EyNDM5NWY1OTMwNWU3OTk1NjkwZTY1
ZTU1OTMwODJhZThkOWMxYjpiaXNlY3QtbGludXgKMjAxNC0wMi0xNyAxMzowNjozMjogY21k
X2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMnICctbCcg
J1dBUk5JTkc6IC4qIGF0IC4qIHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweCcgJy9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny8zYTI0Mzk1ZjU5MzA1ZTc5OTU2OTBl
NjVlNTU5MzA4MmFlOGQ5YzFiJyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVk
LWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTEzOjA2OjMyIDNhMjQzOTVm
NTkzMDVlNzk5NTY5MGU2NWU1NTkzMDgyYWU4ZDljMWIgY29tcGlsaW5nCjUxIHJlYWwgIDg2
IHVzZXIgIDQgc3lzICAxNzYuOTglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0
NwoKMjAxNC0wMi0xNy0xMzowNzoyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMy
LTAxMjk4LWczYTI0Mzk1Li4JNAkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJh
bmNoIG1heSBiZSBjZ3JvdXAvcmV2aWV3LXBvc3Qta2VybmZzLWNvbnZlcnNpb24KbGluZWFy
LWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQg
YmlzZWN0IHN0YXJ0IGRmMmEwNWQ5ZDJlNWVjN2FhYTdmMjkxMmJmNTMxOTU1NTI1ZjYxNTUg
M2EyNDM5NWY1OTMwNWU3OTk1NjkwZTY1ZTU1OTMwODJhZThkOWMxYiAtLQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyAzYTI0Mzk1Li4uIE1lcmdlICd0YXJnZXQvbWFzdGVyJyBpbnRv
IGRldmVsLWhvdXJseS0yMDE0MDIxNjE5CkhFQUQgaXMgbm93IGF0IDVlMzAwMjUuLi4gTWVy
Z2UgYnJhbmNoICdjb3JlLWxvY2tpbmctZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApCaXNlY3Rpbmc6IDE5IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbYWNl
MmJlZTgxMzVhM2RjNzI1OTU4YjhkMDhjNTVlZTlkZjgxM2QzOV0gY2dyb3VwOiBpbnRyb2R1
Y2UgY2dyb3VwX3RyZWVfbXV0ZXgKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0
Ny9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMTYxOTphY2UyYmVlODEzNWEzZGM3
MjU5NThiOGQwOGM1NWVlOWRmODEzZDM5OmJpc2VjdC1saW51eAoyMDE0LTAyLTE3IDEzOjA5
OjM0OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICct
cycgJy1sJyAnV0FSTklORzogLiogYXQgLiogc21wX2NhbGxfZnVuY3Rpb25fc2luZ2xlKzB4
JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2FjZTJiZWU4MTM1YTNk
YzcyNTk1OGI4ZDA4YzU1ZWU5ZGY4MTNkMzknICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0
cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTctMTM6MDk6MzQg
YWNlMmJlZTgxMzVhM2RjNzI1OTU4YjhkMDhjNTVlZTlkZjgxM2QzOSBjb21waWxpbmcKMTUw
IHJlYWwgIDI1MzUgdXNlciAgMTI5IHN5cyAgMTc3Ni45NiUgY3B1IAlpMzg2LXJhbmRjb25m
aWctbmgwLTAyMTYyMzQ3CgoyMDE0LTAyLTE3LTEzOjEyOjEyIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTQuMC1yYzEtMDAwNDMtZ2FjZTJiZWUuCTEgVEVTVCBGQUlMVVJFClsgICAgNy4z
NjM2MTJdIGJyZDogbW9kdWxlIGxvYWRlZApbICAgIDcuMzY0NjcxXSBibGstbXE6IENQVSAt
PiBxdWV1ZSBtYXAKWyAgICA3LjM2NTI3Ml0gICBDUFUgMCAtPiBRdWV1ZSAwClsgICAgNy4z
NjU5NDNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQg
YWI5MzBiODAKWyAgICA3LjM2NzAwOF0gSVA6IFs8ODE5NzJhNjY+XSBibGtfbXFfbWFwX3F1
ZXVlKzB4MjYvMHgzMApbICAgIDcuMzY3OTEzXSAqcGRlID0gMDAwMDAwMDAgClsgICAgNy4z
Njg0MTldIE9vcHM6IDAwMDAgWyMxXSBTTVAgClsgICAgNy4zNjkwMDFdIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQuMC1yYzEtMDAwNDMtZ2FjZTJi
ZWUgIzEyNgpbICAgIDcuMzcwMjI2XSB0YXNrOiA4MDAxYTAwMCB0aTogODAwMjQwMDAgdGFz
ay50aTogODAwMjQwMDAKWyAgICA3LjM3MTIzN10gRUlQOiAwMDYwOls8ODE5NzJhNjY+XSBF
RkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgIDcuMzcyMDg3XSBFSVAgaXMgYXQgYmxrX21x
X21hcF9xdWV1ZSsweDI2LzB4MzAKWyAgICA3LjM3MjgwNF0gRUFYOiA5MWJiMGI3OCBFQlg6
IDkzYTE0NzQwIEVDWDogOTFiYjBjYzggRURYOiAwNjc2MDAwMgpbICAgIDcuMzczNTMwXSBF
U0k6IDkxYmIxNTU4IEVESTogMDAwMDAwMDIgRUJQOiA4MDAyNWU2OCBFU1A6IDgwMDI1ZTU0
ClsgICAgNy4zNzM1MzBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBT
UzogMDA2OApbICAgIDcuMzczNTMwXSBDUjA6IDgwMDUwMDNiIENSMjogYWI5MzBiODAgQ1Iz
OiAwM2I3ODAwMCBDUjQ6IDAwMDAwNjkwClsgICAgNy4zNzM1MzBdIFN0YWNrOgpbICAgIDcu
MzczNTMwXSAgODE5NmYyYjMgOTFiYjBjZDggOTFiYjE1NTggMDAwMDAwNDEgOTFiYzYxODAg
ODAwMjVlZTQgODE5NzNiMWYgMDAwMDAwMDAKWyAgICA3LjM3MzUzMF0gIDgwMDI1ZTg0IDgx
OWI3MjNhIDkxYmIwYWM4IDkxYmIyNDc0IGZmZmZmZmZmIDAwMDAwMDAxIDgzYjZjNzQwIDkx
YmIwYjc4ClsgICAgNy4zNzM1MzBdICAwMDAwMDAwMSA4MzgxNzJjMCA5MWJiMTU1OCAwMDAw
MDA0MSA5MWJiMjNiOCAwMDAwMDAwMSAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDcuMzczNTMw
XSBDYWxsIFRyYWNlOgpbICAgIDcuMzczNTMwXSAgWzw4MTk2ZjJiMz5dID8gYmxrX21xX21h
cF9zd3F1ZXVlKzB4OTMvMHhmMApbICAgIDcuMzczNTMwXSAgWzw4MTk3M2IxZj5dIGJsa19t
cV9pbml0X3F1ZXVlKzB4ZjZmLzB4MTBiMApbICAgIDcuMzczNTMwXSAgWzw4MTliNzIzYT5d
ID8gbWVtc2V0KzB4YS8weDQwClsgICAgNy4zNzM1MzBdICBbPDgzYWIyNDI0Pl0gbnVsbF9p
bml0KzB4NDRiLzB4N2E2ClsgICAgNy4zNzM1MzBdICBbPDgxYTJiZGU2Pl0gPyBfX3BjaV9y
ZWdpc3Rlcl9kcml2ZXIrMHg2Ni8weDgwClsgICAgNy4zNzM1MzBdICBbPDgzYWIxZmQ5Pl0g
PyByc3h4X2NvcmVfaW5pdCsweGQ1LzB4ZDUKWyAgICA3LjM3MzUzMF0gIFs8ODNhMjg2ZjM+
XSBkb19vbmVfaW5pdGNhbGwrMHhmNi8weDIyMgpbICAgIDcuMzczNTMwXSAgWzw4MTBjYTY0
Nj5dID8gcGFyYW1lcSsweDI2LzB4MTAwClsgICAgNy4zNzM1MzBdICBbPDgxOWI3Nzk5Pl0g
PyBzdHJsZW4rMHg5LzB4NDAKWyAgICA3LjM3MzUzMF0gIFs8ODNhMjc3NjM+XSA/IHJlcGFp
cl9lbnZfc3RyaW5nKzB4MzIvMHhkMwpbICAgIDcuMzczNTMwXSAgWzw4MTBjYWEwYj5dID8g
cGFyc2VfYXJncysweDJlYi8weDVmMApbICAgIDcuMzczNTMwXSAgWzw4M2EyOGE3OD5dIGtl
cm5lbF9pbml0X2ZyZWVhYmxlKzB4MjU5LzB4M2UxClsgICAgNy4zNzM1MzBdICBbPDgzYTI3
NzMxPl0gPyBkb19lYXJseV9wYXJhbSsweDEzMS8weDEzMQpbICAgIDcuMzczNTMwXSAgWzw4
MmRlN2MwZT5dIGtlcm5lbF9pbml0KzB4MWUvMHgyMzAKWyAgICA3LjM3MzUzMF0gIFs8ODJl
MWYwYmI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgzMApbICAgIDcuMzczNTMw
XSAgWzw4MmRlN2JmMD5dID8gcmVzdF9pbml0KzB4MWEwLzB4MWEwClsgICAgNy4zNzM1MzBd
IENvZGU6IDAwIDhkIDc0IDI2IDAwIDU1IDg5IGU1IGU4IGY4IGNiIDRhIDAxIDgzIDA1IGIw
IDlhIDI2IDg0IDAxIDgzIDE1IGI0IDlhIDI2IDg0IDAwIDhiIDg4IGI0IDAwIDAwIDAwIDhi
IDgwIGMwIDAwIDAwIDAwIDVkIDhiIDE0IDkxIDw4Yj4gMDQgOTAgYzMgOGQgYjYgMDAgMDAg
MDAgMDAgNTUgODkgZTUgZTggYzggY2IgNGEgMDEgYmEgZDAgODAKWyAgICA3LjM3MzUzMF0g
RUlQOiBbPDgxOTcyYTY2Pl0gYmxrX21xX21hcF9xdWV1ZSsweDI2LzB4MzAgU1M6RVNQIDAw
Njg6ODAwMjVlNTQKWyAgICA3LjM3MzUzMF0gQ1IyOiAwMDAwMDAwMGFiOTMwYjgwClsgICAg
Ny4zNzM1MzBdIC0tLVsgZW5kIHRyYWNlIDU1ZjQ1MmY4NDkyYjJmNmIgXS0tLQpbICAgIDcu
MzczNTMwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2FjZTJiZWU4MTM1YTNkYzcyNTk1OGI4ZDA4
YzU1ZWU5ZGY4MTNkMzkvZG1lc2cteW9jdG8teGJtLTI6MjAxNDAyMTcxMzEyNDM6aTM4Ni1y
YW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMxLTAwMDQzLWdhY2UyYmVlOjEyNgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvYWNlMmJlZTgxMzVhM2RjNzI1
OTU4YjhkMDhjNTVlZTlkZjgxM2QzOS9kbWVzZy15b2N0by14Ym0tMjoyMDE0MDIxNzEzMTMw
MzppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3OjMuMTQuMC1yYzEtMDAwNDMtZ2FjZTJi
ZWU6MTI2CjE6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAy
LTE3IDEzOjEzOjEzIFJFUEVBVCBDT1VOVDogMjUgICMgL2tlcm5lbC10ZXN0cy9saW51eC9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbMGFiMDJjYThmODg3OTA4MTUy
ZDFhOTZkYjUxMzBmYzY2MWQzNmExZV0gY2dyb3VwOiBwcm90ZWN0IG1vZGlmaWNhdGlvbnMg
dG8gY2dyb3VwX2lkciB3aXRoIGNncm91cF9tdXRleApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctbmgwLTAyMTYyMzQ3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIxNjE5OjBh
YjAyY2E4Zjg4NzkwODE1MmQxYTk2ZGI1MTMwZmM2NjFkMzZhMWU6YmlzZWN0LWxpbnV4CjIw
MTQtMDItMTcgMTM6MTM6MTM6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1
ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdXQVJOSU5HOiAuKiBhdCAuKiBzbXBfY2FsbF9mdW5j
dGlvbl9zaW5nbGUrMHgnICcva2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcv
MGFiMDJjYThmODg3OTA4MTUyZDFhOTZkYjUxMzBmYzY2MWQzNmExZScgLCByZXQ9MiwgcmVm
OiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAxNC0w
Mi0xNy0xMzoxMzoxMyAwYWIwMmNhOGY4ODc5MDgxNTJkMWE5NmRiNTEzMGZjNjYxZDM2YTFl
IGNvbXBpbGluZwoxNDAgcmVhbCAgMjM3NSB1c2VyICAxMTQgc3lzICAxNzY4Ljg5JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcKCjIwMTQtMDItMTctMTM6MTU6NDAgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDAwOC1nMGFiMDJjYS4uLgkyCTE2CTIz
CTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzY5ZTk0M2I3ZDNjMmRjY2ExMDg3ZTAzZTU1NmFj
NmNiMGQ0NDMzYjRdIGNncm91cDogdXBkYXRlIGxvY2tpbmcgaW4gY2dyb3VwX3Nob3dfb3B0
aW9ucygpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6NjllOTQzYjdkM2MyZGNjYTEwODdlMDNlNTU2
YWM2Y2IwZDQ0MzNiNDpiaXNlY3QtbGludXgKMjAxNC0wMi0xNyAxMzoxOToxMDogY21kX2Zh
aWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMnICctbCcgJ1dB
Uk5JTkc6IC4qIGF0IC4qIHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweCcgJy9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny82OWU5NDNiN2QzYzJkY2NhMTA4N2UwM2U1
NTZhYzZjYjBkNDQzM2I0JyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNt
ZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTEzOjE5OjEwIDY5ZTk0M2I3ZDNj
MmRjY2ExMDg3ZTAzZTU1NmFjNmNiMGQ0NDMzYjQgY29tcGlsaW5nCjg4IHJlYWwgIDEwNTQg
dXNlciAgNDggc3lzICAxMjQ2LjI2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIz
NDcKCjIwMTQtMDItMTctMTM6MjA6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJj
MS0wMDAwNS1nNjllOTQzYi4uLgkyNAkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltmN2NlZjA2
NGFhMDFhMWFjNjgyYzE5NDVjYzE2OGI4NzhjYjExOGZmXSBNZXJnZSBicmFuY2ggJ2RyaXZl
ci1jb3JlLW5leHQnIGludG8gY2dyb3VwL2Zvci0zLjE1CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1uaDAtMDIxNjIzNDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6
ZjdjZWYwNjRhYTAxYTFhYzY4MmMxOTQ1Y2MxNjhiODc4Y2IxMThmZjpiaXNlY3QtbGludXgK
MjAxNC0wMi0xNyAxMzoyMzoxNTogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5j
bHVkZT1kbWVzZy0qJyAnLXMnICctbCcgJ1dBUk5JTkc6IC4qIGF0IC4qIHNtcF9jYWxsX2Z1
bmN0aW9uX3NpbmdsZSsweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0
Ny9mN2NlZjA2NGFhMDFhMWFjNjgyYzE5NDVjYzE2OGI4NzhjYjExOGZmJyAsIHJldD0yLCBy
ZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0
LTAyLTE3LTEzOjIzOjE1IGY3Y2VmMDY0YWEwMWExYWM2ODJjMTk0NWNjMTY4Yjg3OGNiMTE4
ZmYgY29tcGlsaW5nCjE0OCByZWFsICAyMzc0IHVzZXIgIDExNiBzeXMgIDE2ODEuOTglIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NwoKMjAxNC0wMi0xNy0xMzoyNTo0OSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMxLTAwMDM5LWdmN2NlZjA2Li4JMQkxNQkx
OAkyMC4uCTIyCTI1IFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbNWExN2Y1NDNlZDY4MDhlOTA4NTA2
MzI3N2ZlNDY3OTVkZWE0ODRiZF0gY2dyb3VwOiBpbXByb3ZlIGNzc19mcm9tX2RpcigpIGlu
dG8gY3NzX3RyeWdldF9mcm9tX2RpcigpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDIxNjIzNDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6NWExN2Y1NDNl
ZDY4MDhlOTA4NTA2MzI3N2ZlNDY3OTVkZWE0ODRiZDpiaXNlY3QtbGludXgKMjAxNC0wMi0x
NyAxMzozMDo0OTogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVz
Zy0qJyAnLXMnICctbCcgJ1dBUk5JTkc6IC4qIGF0IC4qIHNtcF9jYWxsX2Z1bmN0aW9uX3Np
bmdsZSsweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny81YTE3ZjU0
M2VkNjgwOGU5MDg1MDYzMjc3ZmU0Njc5NWRlYTQ4NGJkJyAsIHJldD0yLCByZWY6IC9rZXJu
ZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE3LTEz
OjMwOjQ5IDVhMTdmNTQzZWQ2ODA4ZTkwODUwNjMyNzdmZTQ2Nzk1ZGVhNDg0YmQgY29tcGls
aW5nCjkxIHJlYWwgIDEwNjIgdXNlciAgNDcgc3lzICAxMjA3Ljk5JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1uaDAtMDIxNjIzNDcKCjIwMTQtMDItMTctMTM6MzI6MjcgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xNC4wLXJjMS0wMDA0Mi1nNWExN2Y1NC4uCTIJMjAJMjMJMjUgU1VDQ0VT
UwoKYWNlMmJlZTgxMzVhM2RjNzI1OTU4YjhkMDhjNTVlZTlkZjgxM2QzOSBpcyB0aGUgZmly
c3QgYmFkIGNvbW1pdApjb21taXQgYWNlMmJlZTgxMzVhM2RjNzI1OTU4YjhkMDhjNTVlZTlk
ZjgxM2QzOQpBdXRob3I6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KRGF0ZTogICBUdWUg
RmViIDExIDExOjUyOjQ3IDIwMTQgLTA1MDAKCiAgICBjZ3JvdXA6IGludHJvZHVjZSBjZ3Jv
dXBfdHJlZV9tdXRleAogICAgCiAgICBDdXJyZW50bHkgY2dyb3VwIHVzZXMgY29tYmluYXRp
b24gb2YgaW5vZGUtPmlfbXV0ZXgnZXMgYW5kCiAgICBjZ3JvdXBfbXV0ZXggZm9yIHN5bmNo
cm9uaXphdGlvbi4gIFdpdGggdGhlIHNjaGVkdWxlZCBrZXJuZnMKICAgIGNvbnZlcnNpb24s
IGlfbXV0ZXgnZXMgd2lsbCBiZSByZW1vdmVkLiAgVW5mb3J0dW5hdGVseSwganVzdCB1c2lu
ZwogICAgY2dyb3VwX211dGV4IGlzbid0IHBvc3NpYmxlLiAgQWxsIGtlcm5mcyBmaWxlIGFu
ZCBzeXNjYWxsIG9wZXJhdGlvbnMsCiAgICBtb3N0IG9mIHdoaWNoIHJlcXVpcmUgZ3JhYmJp
bmcgY2dyb3VwX211dGV4LCB3aWxsIGJlIGNhbGxlZCB3aXRoCiAgICBrZXJuZnMgYWN0aXZl
IHJlZiBoZWxkIGFuZCwgaWYgd2UgdHJ5IHRvIHBlcmZvcm0ga2VybmZzIHJlbW92YWxzIHVu
ZGVyCiAgICBjZ3JvdXBfbXV0ZXgsIGl0IGNhbiBkZWFkbG9jayBhcyBrZXJuZnNfcmVtb3Zl
KCkgdHJpZXMgdG8gZHJhaW4gdGhlCiAgICB0YXJnZXQgbm9kZS4KICAgIAogICAgTGV0J3Mg
aW50cm9kdWNlIGEgbmV3IG91dGVyIG11dGV4LCBjZ3JvdXBfdHJlZV9tdXRleCwgd2hpY2gg
cHJvdGVjdHMKICAgIHN0dWZmIHVzZWQgZHVyaW5nIGhpZXJhcmNoeSBjaGFuZ2luZyBvcGVy
YXRpb25zIC0gY2Z0eXBlcyBhbmQgYWxsIHRoZQogICAgb3BlcmF0aW9ucyB3aGljaCBtYXkg
YWZmZWN0IHRoZSBjZ3JvdXBmcy4gIEl0IGFsc28gY292ZXJzIGNzcwogICAgYXNzb2NpYXRp
b24gYW5kIGl0ZXJhdGlvbi4gIFRoaXMgYWxsb3dzIGNncm91cF9jc3MoKSwgZm9yX2VhY2hf
Y3NzKCkKICAgIGFuZCBvdGhlciBjc3MgaXRlcmF0b3JzIHRvIGJlIGNhbGxlZCB1bmRlciBj
Z3JvdXBfdHJlZV9tdXRleC4gIFRoZSBuZXcKICAgIG11dGV4IHdpbGwgbmVzdCBhYm92ZSBi
b3RoIGtlcm5mcydzIGFjdGl2ZSByZWYgcHJvdGVjdGlvbiBhbmQKICAgIGNncm91cF9tdXRl
eC4gIEJ5IHByb3RlY3RpbmcgdHJlZSBtb2RpZmljYXRpb25zIHdpdGggYSBzZXBhcmF0ZSBv
dXRlcgogICAgbXV0ZXgsIHdlIGNhbiBnZXQgcmlkIG9mIHRoZSBmb3JlbWVudGlvbmVkIGRl
YWRsb2NrIGNvbmRpdGlvbi4KICAgIAogICAgQWN0dWFsIGZpbGUgYWRkaXRpb25zIGFuZCBy
ZW1vdmFscyBub3cgcmVxdWlyZSBjZ3JvdXBfdHJlZV9tdXRleAogICAgaW5zdGVhZCBvZiBj
Z3JvdXBfbXV0ZXguICBDdXJyZW50bHksIGNncm91cF90cmVlX211dGV4IGlzIG5ldmVyIHVz
ZWQKICAgIHdpdGhvdXQgY2dyb3VwX211dGV4OyBob3dldmVyLCB3ZSdsbCBzb29uIGFkZCBo
aWVyYXJjaHkgbW9kaWZpY2F0aW9uCiAgICBzZWN0aW9ucyB3aGljaCBhcmUgb25seSBwcm90
ZWN0ZWQgYnkgY2dyb3VwX3RyZWVfbXV0ZXguICBJbiB0aGUKICAgIGZ1dHVyZSwgd2UgbWln
aHQgd2FudCB0byBtYWtlIHRoZSBsb2NraW5nIG1vcmUgZ3JhbnVsYXIgYnkgYmV0dGVyCiAg
ICBzcGxpdHRpbmcgdGhlIGNvdmVyYWdlcyBvZiB0aGUgdHdvIG11dGV4ZXMuICBGb3Igbm93
LCB0aGlzIHNob3VsZCBkby4KICAgIAogICAgdjI6IFJlYmFzZWQgb24gdG9wIG9mIDBhYjAy
Y2E4Zjg4NyAoImNncm91cDogcHJvdGVjdCBtb2RpZmljYXRpb25zIHRvCiAgICAgICAgY2dy
b3VwX2lkciB3aXRoIGNncm91cF9tdXRleCIpLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBU
ZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CiAgICBBY2tlZC1ieTogTGkgWmVmYW4gPGxpemVm
YW5AaHVhd2VpLmNvbT4KCjowNDAwMDAgMDQwMDAwIDM3OWY3YTk2ZGMwMDE3NDYzNTI4NmEw
OGY2YmNiZDk3ZTQwZjdhYWYgY2NiZmQ5ODhlZDMwMzdiNmNkZGE2MTc5MzI0MjAxNjI0NTBk
YjliYyBNCWtlcm5lbApiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6NWExN2Y1NDNlZDY4MDhlOTA4NTA2MzI3N2ZlNDY3
OTVkZWE0ODRiZDpiaXNlY3QtbGludXgKCjIwMTQtMDItMTctMTM6MzU6MjcgNWExN2Y1NDNl
ZDY4MDhlOTA4NTA2MzI3N2ZlNDY3OTVkZWE0ODRiZCByZXVzZSAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1uaDAtMDIxNjIzNDcvNWExN2Y1NDNlZDY4MDhlOTA4NTA2MzI3N2ZlNDY3OTVk
ZWE0ODRiZC92bWxpbnV6LTMuMTQuMC1yYzEtMDAwNDItZzVhMTdmNTQKCjIwMTQtMDItMTct
MTM6MzU6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxLgk2CTM4CTU1CTc0CTc1IFNVQ0NF
U1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
bmgwLTAyMTYyMzQ3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIxNjE5Ojk3MTYy
YzFiNDA3YWI4ZGJjYzYzN2MzMTZiNzcyZGQwNTcyZGVkZGM6YmlzZWN0LWxpbnV4CiBURVNU
IEZBSUxVUkUKWyAgICAwLjA4MDAwMF0gSW5pdGlhbGl6aW5nIENQVSMxClsgICAgMC4wODAw
MDBdIG1hc2tlZCBFeHRJTlQgb24gQ1BVIzEKWyAgICAwLjA4MDAwMF0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4wODAwMDBdIFdBUk5JTkc6IENQVTog
MSBQSUQ6IDAgYXQgYXJjaC94ODYva2VybmVsL2NwdS9hbWQuYzoyMjAgaW5pdF9hbWQrMHhm
ZjMvMHgxMTAwKCkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3Lzk3MTYy
YzFiNDA3YWI4ZGJjYzYzN2MzMTZiNzcyZGQwNTcyZGVkZGMvZG1lc2ctcXVhbnRhbC13YWlt
ZWEtNzoyMDE0MDIxNzAwMDYyNzppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3OjMuMTQu
MC1yYzItMDE1OTItZzk3MTYyYzE6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIx
NjIzNDcvOTcxNjJjMWI0MDdhYjhkYmNjNjM3YzMxNmI3NzJkZDA1NzJkZWRkYy9kbWVzZy1x
dWFudGFsLXdhaW1lYS03OjIwMTQwMjE3MTIzNTQyOmkzODYtcmFuZGNvbmZpZy1uaDAtMDIx
NjIzNDc6My4xNC4wLXJjMi0wMTU5Mi1nOTcxNjJjMTo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMjE2MjM0Ny85NzE2MmMxYjQwN2FiOGRiY2M2MzdjMzE2Yjc3MmRkMDU3MmRl
ZGRjL2RtZXNnLXF1YW50YWwtcm9hbS01NzoyMDE0MDIxNzAwMDk1NDppMzg2LXJhbmRjb25m
aWctbmgwLTAyMTYyMzQ3OjMuMTQuMC1yYzItMDE1OTItZzk3MTYyYzE6Ngova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDcvOTcxNjJjMWI0MDdhYjhkYmNjNjM3YzMxNmI3
NzJkZDA1NzJkZWRkYy9kbWVzZy1xdWFudGFsLXJvYW0tNDQ6MjAxNDAyMTcxMjM3NTc6aTM4
Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAxNTkyLWc5NzE2MmMxOjYK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3Lzk3MTYyYzFiNDA3YWI4ZGJj
YzYzN2MzMTZiNzcyZGQwNTcyZGVkZGMvZG1lc2ctcXVhbnRhbC1yb2FtLTMxOjIwMTQwMjE3
MTIzNzUzOmkzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDc6My4xNC4wLXJjMi0wMTU5Mi1n
OTcxNjJjMTo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny85NzE2MmMx
YjQwN2FiOGRiY2M2MzdjMzE2Yjc3MmRkMDU3MmRlZGRjL2RtZXNnLXlvY3RvLXJvYW0tNTE6
MjAxNDAyMTcxMjM3MzQ6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMy
LTAxNTkyLWc5NzE2MmMxOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3
Lzk3MTYyYzFiNDA3YWI4ZGJjYzYzN2MzMTZiNzcyZGQwNTcyZGVkZGMvZG1lc2cteW9jdG8t
cm9hbS0yNToyMDE0MDIxNzEyMzgwMzppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3OjMu
MTQuMC1yYzItMDE1OTItZzk3MTYyYzE6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDIxNjIzNDcvOTcxNjJjMWI0MDdhYjhkYmNjNjM3YzMxNmI3NzJkZDA1NzJkZWRkYy9kbWVz
Zy15b2N0by13YWltZWEtMTE6MjAxNDAyMTcwMDA2MTI6aTM4Ni1yYW5kY29uZmlnLW5oMC0w
MjE2MjM0NzozLjE0LjAtcmMyLTAxNTkyLWc5NzE2MmMxOjYKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctbmgwLTAyMTYyMzQ3Lzk3MTYyYzFiNDA3YWI4ZGJjYzYzN2MzMTZiNzcyZGQwNTcy
ZGVkZGMvZG1lc2ctcXVhbnRhbC1yb2FtLTc6MjAxNDAyMTcxMjM3NTU6aTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAxNTkyLWc5NzE2MmMxOjYKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3Lzk3MTYyYzFiNDA3YWI4ZGJjYzYzN2MzMTZi
NzcyZGQwNTcyZGVkZGMvZG1lc2ctcXVhbnRhbC13YWltZWEtMTU6MjAxNDAyMTcwMDA2MjU6
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAxNTkyLWc5NzE2MmMx
OjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3Lzk3MTYyYzFiNDA3YWI4
ZGJjYzYzN2MzMTZiNzcyZGQwNTcyZGVkZGMvZG1lc2cteW9jdG8td2FpbWVhLTk6MjAxNDAy
MTcxMjM1MjE6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAxNTky
LWc5NzE2MmMxOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3Lzk3MTYy
YzFiNDA3YWI4ZGJjYzYzN2MzMTZiNzcyZGQwNTcyZGVkZGMvZG1lc2ctcXVhbnRhbC13YWlt
ZWEtMzoyMDE0MDIxNzEyMzU0MjppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3OjMuMTQu
MC1yYzItMDE1OTItZzk3MTYyYzE6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIx
NjIzNDcvOTcxNjJjMWI0MDdhYjhkYmNjNjM3YzMxNmI3NzJkZDA1NzJkZWRkYy9kbWVzZy15
b2N0by1yb2FtLTE5OjIwMTQwMjE3MDAwOTE0OmkzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIz
NDc6My4xNC4wLXJjMi0wMTU5Mi1nOTcxNjJjMTo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LW5oMC0wMjE2MjM0Ny85NzE2MmMxYjQwN2FiOGRiY2M2MzdjMzE2Yjc3MmRkMDU3MmRlZGRj
L2RtZXNnLXlvY3RvLXJvYW0tODoyMDE0MDIxNzEyMzcyMTppMzg2LXJhbmRjb25maWctbmgw
LTAyMTYyMzQ3OjMuMTQuMC1yYzItMDE1OTItZzk3MTYyYzE6Ngova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1uaDAtMDIxNjIzNDcvOTcxNjJjMWI0MDdhYjhkYmNjNjM3YzMxNmI3NzJkZDA1
NzJkZWRkYy9kbWVzZy15b2N0by1yb2FtLTUyOjIwMTQwMjE3MTIzNzI4OmkzODYtcmFuZGNv
bmZpZy1uaDAtMDIxNjIzNDc6My4xNC4wLXJjMi0wMTU5Mi1nOTcxNjJjMTo2Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny85NzE2MmMxYjQwN2FiOGRiY2M2MzdjMzE2
Yjc3MmRkMDU3MmRlZGRjL2RtZXNnLXlvY3RvLXdhaW1lYS0yOjIwMTQwMjE3MDAwNjA3Omkz
ODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIzNDc6My4xNC4wLXJjMi0wMTU5Mi1nOTcxNjJjMTo2
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0Ny85NzE2MmMxYjQwN2FiOGRi
Y2M2MzdjMzE2Yjc3MmRkMDU3MmRlZGRjL2RtZXNnLXlvY3RvLXJvYW0tMjM6MjAxNDAyMTcw
MDA5Mjk6aTM4Ni1yYW5kY29uZmlnLW5oMC0wMjE2MjM0NzozLjE0LjAtcmMyLTAxNTkyLWc5
NzE2MmMxOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3Lzk3MTYyYzFi
NDA3YWI4ZGJjYzYzN2MzMTZiNzcyZGQwNTcyZGVkZGMvZG1lc2ctcXVhbnRhbC13YWltZWEt
OToyMDE0MDIxNzAwMDYzMDppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3OjMuMTQuMC1y
YzItMDE1OTItZzk3MTYyYzE6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1uaDAtMDIxNjIz
NDcvOTcxNjJjMWI0MDdhYjhkYmNjNjM3YzMxNmI3NzJkZDA1NzJkZWRkYy9kbWVzZy15b2N0
by13YWltZWEtODoyMDE0MDIxNzAwMDYxMzppMzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3
OjMuMTQuMC1yYzItMDE1OTItZzk3MTYyYzE6NgowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA5NzE2MmMxIDBkYXkgaGVhZCBndWFyZCBmb3Ig
J2RldmVsLWhvdXJseS0yMDE0MDIxNjE5JwoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09
PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5NzE2MmMxLi4uIDBkYXkgaGVhZCBndWFy
ZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDIxNjE5JwpIRUFEIGlzIG5vdyBhdCA2ZDBhYmVj
Li4uIExpbnV4IDMuMTQtcmMzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctbmgwLTAyMTYyMzQ3L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDIxNjE5OjZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzI6Ymlz
ZWN0LWxpbnV4CgoyMDE0LTAyLTE3LTEzOjM5OjMxIDZkMGFiZWNhMzI0MmE4OGNhYjgyMzJl
NGFjZDdlMmJmMDg4ZjNiYzIgY29tcGlsaW5nCgoyMDE0LTAyLTE3LTEzOjQyOjExIGRldGVj
dGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMuLi4JMTQJMjgJNDEJNjQJNjguLgk3Mwk3NSBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDZkMGFiZWMuLi4gTGludXggMy4xNC1yYzMKSEVBRCBpcyBub3cgYXQg
ZGE4ZDMwOC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAyMTQK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1uaDAt
MDIxNjIzNDcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE2MTk6ZGE4ZDMwOGZi
ZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMTpiaXNlY3QtbGludXgKCjIwMTQtMDIt
MTctMTM6NDg6MTIgZGE4ZDMwOGZiZGI4MzYwMDc4Nzg2YjNlMTI1MjM4MTIyYzRmYzYxMSBj
b21waWxpbmcKMjAxNC0wMi0xNy0xMzo1MDowNyBkYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2Ux
MjUyMzgxMjJjNGZjNjExIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9rZXJu
ZWwtdGVzdHMvbGludXgvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLW5oMC0wMjE2MjM0Ny9kYThkMzA4ZmJkYjgzNjAwNzg3ODZiM2UxMjUyMzgxMjJjNGZj
NjExCg==

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc2-01592-g97162c1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc2 Kernel Configuration
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
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
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
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
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
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
CONFIG_X86_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
# CONFIG_STA2X11 is not set
CONFIG_X86_SUMMIT=y
CONFIG_X86_ES7000=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
CONFIG_M586MMX=y
# CONFIG_M686 is not set
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
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_APB_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y

#
# NUMA (Summit) requires SMP, 64GB highmem support, ACPI
#
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
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
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
CONFIG_OLPC_XO15_SCI=y
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PCMCIA_PROBE=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
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
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_CLS_BPF is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
CONFIG_CAN_GRCAN=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

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
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
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
CONFIG_MTD_CFI=y
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_CS553X=y
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
# CONFIG_PARIDE_PD is not set
CONFIG_PARIDE_PCD=y
# CONFIG_PARIDE_PF is not set
CONFIG_PARIDE_PT=y
CONFIG_PARIDE_PG=y

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
CONFIG_PARIDE_BPCK=y
CONFIG_PARIDE_BPCK6=y
# CONFIG_PARIDE_COMM is not set
CONFIG_PARIDE_DSTR=y
# CONFIG_PARIDE_FIT2 is not set
CONFIG_PARIDE_FIT3=y
CONFIG_PARIDE_EPAT=y
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=y
# CONFIG_PARIDE_FRIQ is not set
# CONFIG_PARIDE_FRPW is not set
# CONFIG_PARIDE_KBIC is not set
# CONFIG_PARIDE_KTTI is not set
# CONFIG_PARIDE_ON20 is not set
CONFIG_PARIDE_ON26=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
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
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_7000FASST is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=y
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AHA1740=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
CONFIG_SCSI_GENERIC_NCR53C400=y
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_PAS16 is not set
CONFIG_SCSI_QLOGIC_FAS=y
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
CONFIG_SCSI_SYM53C416=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_NTB_NETDEV is not set
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
# CONFIG_ATM_ENI_BURST_TX_8W is not set
# CONFIG_ATM_ENI_BURST_TX_4W is not set
# CONFIG_ATM_ENI_BURST_TX_2W is not set
CONFIG_ATM_ENI_BURST_RX_16W=y
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
# CONFIG_ATM_ENI_BURST_RX_2W is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=y
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#

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
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_LANCE=y
CONFIG_PCNET32=y
CONFIG_NI65=y
CONFIG_NET_VENDOR_ARC=y
CONFIG_ARC_EMAC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_ALX=y
# CONFIG_NET_CADENCE is not set
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
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
CONFIG_IGB_DCA=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
CONFIG_IXGBEVF=y
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_I40EVF=y
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2000=y
# CONFIG_NE2K_PCI is not set
# CONFIG_ULTRA is not set
CONFIG_WD80x3=y
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
# CONFIG_QLCNIC_DCB is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
CONFIG_SFC_MTD=y
# CONFIG_SFC_MCDI_MON is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_SMC9194=y
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_MDIO_BUS_MUX_MMIOREG=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
CONFIG_PRISM54=y
# CONFIG_ATH_CARDS is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
# CONFIG_BRCMFMAC_SDIO is not set
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=y
# CONFIG_IPW2200_MONITOR is not set
# CONFIG_IPW2200_QOS is not set
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
# CONFIG_LIBERTAS is not set
CONFIG_HERMES=y
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=y
CONFIG_TMD_HERMES=y
# CONFIG_NORTEL_HERMES is not set
CONFIG_WL_TI=y
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
CONFIG_ISDN_DRV_AVMB1_T1ISA=y
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
# CONFIG_MISDN_AVMFRITZ is not set
CONFIG_MISDN_SPEEDFAX=y
# CONFIG_MISDN_INFINEON is not set
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
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_CYPRESS is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
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
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_INTEL_MID=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
CONFIG_DEVKMEM=y

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
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
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
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

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
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_I2C is not set
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
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
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_SODAVILLE=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS65910 is not set
CONFIG_GPIO_MSIC=y
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

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
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_AS3722 is not set
CONFIG_POWER_RESET_GPIO=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_ACPI_INT3403_THERMAL=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_AS3722 is not set
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
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
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
# CONFIG_FB_I810_I2C is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_INTEL is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_FB_SSD1307=y
# CONFIG_SOUND is not set

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
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

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
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_GOLDFISH is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
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
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_AS3722=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_HYM8563 is not set
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_VRTC is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_SNVS=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
# CONFIG_ECHO is not set
CONFIG_FB_OLPC_DCON=y
# CONFIG_FB_OLPC_DCON_1_5 is not set
# CONFIG_PANEL is not set
CONFIG_RTS5208=y
# CONFIG_RTS5208_DEBUG is not set
CONFIG_DX_SEP=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
CONFIG_ACPI_QUICKSTART=y
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
# CONFIG_GOLDFISH_AUDIO is not set
CONFIG_MTD_GOLDFISH_NAND=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=y
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=y
# CONFIG_GPIO_INTEL_PMIC is not set
CONFIG_INTEL_MID_POWER_BUTTON=y
# CONFIG_INTEL_MFLD_THERMAL is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y
# CONFIG_INTEL_IOMMU is not set

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
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_OF_EXTCON=y
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_PALMAS is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_PCA9685=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_PHY_EXYNOS_DP_VIDEO=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
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
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

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
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
CONFIG_F2FS_CHECK_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
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
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
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
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
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
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
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
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--jho1yZJdad60DJr+--
