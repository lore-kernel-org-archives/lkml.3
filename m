Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaG3Dmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:42:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:57401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbaG3Dmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:42:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,761,1400050800"; 
   d="log'?scan'208";a="569229257"
Date: Wed, 30 Jul 2014 11:42:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [RCU] INFO: trying to register non-static key.
Message-ID: <20140730034237.GB16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20140730034047.GA16537@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

This is another warning for the same commit.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu_tasks.2014.07.28d
commit bd14ddc45614b61210fdf0ee4e94152948dd9d5e
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon Jul 28 12:41:25 2014 -0700
Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Mon Jul 28 14:57:56 2014 -0700

    rcu: Make RCU-tasks track exiting tasks
    
    This commit adds synchronization with exiting tasks, so that RCU-tasks
    avoids waiting on tasks that no longer exist.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    
    Conflicts:
    	kernel/rcu/update.c

+--------------------------------------------------------------------------+------------+------------+------------------+
|                                                                          | 4e73c5aafb | bd14ddc456 | v3.16-rc7_072910 |
+--------------------------------------------------------------------------+------------+------------+------------------+
| boot_successes                                                           | 60         | 0          | 0                |
| boot_failures                                                            | 0          | 20         | 11               |
| INFO:trying_to_register_non-static_key                                   | 0          | 20         | 11               |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/rcu/update.c | 0          | 20         | 11               |
| INFO:lockdep_is_turned_off                                               | 0          | 20         | 11               |
| backtrace:cryptomgr_test                                                 | 0          | 20         | 11               |
| backtrace:do_group_exit                                                  | 0          | 20         | 11               |
| backtrace:SyS_exit_group                                                 | 0          | 20         | 11               |
| backtrace:do_exit                                                        | 0          | 19         |                  |
+--------------------------------------------------------------------------+------------+------------+------------------+

[    0.367474] debug: unmapping init [mem 0xc3cbd000-0xc3feffff]
[    0.368575] apm: BIOS not found.
[    0.369357] cryptomgr_test (19) used greatest stack depth: 7060 bytes left
[    0.369940] INFO: trying to register non-static key.
[    0.370011] the code is fine but needs lockdep annotation.
[    0.370011] turning off the locking correctness validator.
[    0.370011] CPU: 0 PID: 19 Comm: cryptomgr_test Not tainted 3.16.0-rc1-00010-gbd14ddc #10
[    0.370011]  00000000 00000000 c22abe1c b149e13a c14bb000 c22abe54 b1079298 b1673d18
[    0.370011]  00000000 c22abe54 b106767f 00000286 00000165 00000000 00000000 c14bb180
[    0.370011]  c14bb180 00000246 00000000 c22abe88 b1079c64 00000000 00000000 00000000
[    0.370011] Call Trace:
[    0.370011]  [<b149e13a>] dump_stack+0x48/0x60
[    0.370011]  [<b1079298>] __lock_acquire.isra.28+0x878/0xb20
[    0.370011]  [<b106767f>] ? sched_clock_cpu+0xdf/0x120
[    0.370011]  [<b1079c64>] lock_acquire+0x84/0x100
[    0.370011]  [<b1087a4f>] ? exit_rcu_tasks+0x2f/0x50
[    0.370011]  [<b14a322d>] _raw_spin_lock+0x3d/0x70
[    0.370011]  [<b1087a4f>] ? exit_rcu_tasks+0x2f/0x50
[    0.370011]  [<b1087a4f>] exit_rcu_tasks+0x2f/0x50
[    0.370011]  [<b108b6c8>] exit_rcu+0x8/0x10
[    0.370011]  [<b103d286>] do_exit+0x596/0x920
[    0.370011]  [<b1167030>] ? cryptomgr_notify+0x440/0x440
[    0.370011]  [<b116705b>] cryptomgr_test+0x2b/0x40
[    0.370011]  [<b1056230>] kthread+0xb0/0xd0
[    0.370011]  [<b1074492>] ? complete+0x12/0x40
[    0.370011]  [<b14a3f01>] ret_from_kernel_thread+0x21/0x30
[    0.370011]  [<b1056180>] ? __kthread_parkme+0x60/0x60
[    0.380893] cryptomgr_test (26) used greatest stack depth: 6316 bytes left
[    0.381613] PCLMULQDQ-NI instructions are not detected.
[    0.382045] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.

git bisect start 042abb083e26874a281814b00dfd20149c9beae2 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91 --
git bisect  bad 935104624f31f70fd24874e67431838b7af8ed1b  # 11:57      0-     20  Merge 'asoc/topic/rockchip' into devel-hourly-2014072910
git bisect good 6eb8c6122aab6e944113d6cada6e579468974251  # 12:01     20+      0  Merge 'pinctrl/for-next' into devel-hourly-2014072910
git bisect  bad 6f6c1629afd346f9897fcaf5b09ccc179be8ef57  # 12:17      0-      8  Merge 'jcmvbkbc-xtensa/xtensa-kc705' into devel-hourly-2014072910
git bisect  bad ea97bfad281dec63417068b0c9686492892af6a2  # 12:20      0-     20  Merge 'rcu/rcu_tasks.2014.07.28d' into devel-hourly-2014072910
git bisect good f255aa5d3cb715389362367326aeeb1b45ab8fc3  # 12:24     20+      0  Merge 'kgene-samsung/for-next' into devel-hourly-2014072910
git bisect good 21ba29459d3e5f129c1e9626098986521b09dab7  # 12:26     20+      0  Merge 'net/master' into devel-hourly-2014072910
git bisect good 41d8e02382e1e79c17a78c0898bc938531000716  # 12:33     20+      0  rcutorture: Add torture tests for RCU-tasks
git bisect good 4e73c5aafbe9108c83de0f8f5294e6ccad2e29c3  # 12:38     20+      0  rcu: Add stall-warning checks for RCU-tasks
git bisect  bad ebc6436166ae583e6db906eb7ffdb1c198921380  # 12:40      0-     20  rcu: Improve RCU-tasks energy efficiency
git bisect  bad bd14ddc45614b61210fdf0ee4e94152948dd9d5e  # 12:44      0-     10  rcu: Make RCU-tasks track exiting tasks
# first bad commit: [bd14ddc45614b61210fdf0ee4e94152948dd9d5e] rcu: Make RCU-tasks track exiting tasks
git bisect good 4e73c5aafbe9108c83de0f8f5294e6ccad2e29c3  # 12:51     60+      0  rcu: Add stall-warning checks for RCU-tasks
git bisect  bad 042abb083e26874a281814b00dfd20149c9beae2  # 12:53      0-     11  0day head guard for 'devel-hourly-2014072910'
git bisect good 31dab719fa50cf56d56d3dc25980fecd336f6ca8  # 12:56     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect good e40cff4a7990e5d73eaad0a2f2593fe725e24cdd  # 13:10     60+      0  Add linux-next specific files for 20140728


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-5:20140729124331:i386-randconfig-c0-07291054:3.16.0-rc1-00010-gbd14ddc:10"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc1-00010-gbd14ddc (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #10 SMP Tue Jul 29 20:42:56 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[b00fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 4k
[    0.000000] BRK [0x02035000, 0x02035fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 4k
[    0.000000] BRK [0x02036000, 0x02036fff] PGTABLE
[    0.000000] BRK [0x02037000, 0x02037fff] PGTABLE
[    0.000000] BRK [0x02038000, 0x02038fff] PGTABLE
[    0.000000] BRK [0x02039000, 0x02039fff] PGTABLE
[    0.000000] BRK [0x0203a000, 0x0203afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 16 MiB at 12800000
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE4F0 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF800 000735 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF6A0 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat b17996c0, node_mem_map c3=
8ef024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @c26b5000 s1341760 r0 d14016 =
u1355776
[    0.000000] pcpu-alloc: s1341760 r0 d14016 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 126b7680
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c0-07291054/linux-d=
evel:devel-hourly-2014072910:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisec=
t-linux-7/.vmlinuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729204259-=
5-vp branch=3Dlinux-devel/devel-hourly-2014072910 BOOT_IMAGE=3D/kernel/i386=
-randconfig-c0-07291054/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.=
16.0-rc1-00010-gbd14ddc drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 286032K/327280K available (4756K kernel code, 683K r=
wdata, 2404K rodata, 1720K init, 6968K bss, 41248K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xff7fe000   ( 944 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xb17ac000 - 0xb195a000   (1720 kB)
[    0.000000]       .data : 0xb14a56a8 - 0xb17aaec0   (3094 kB)
[    0.000000]       .text : 0xb1000000 - 0xb14a56a8   (4757 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc2004000 soft=3Dc2006000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 5151 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.486 MHz processor
[    0.002000] Calibrating delay loop (skipped) preset value.. 5386.97 Bogo=
MIPS (lpj=3D2693486)
[    0.002236] pid_max: default: 4096 minimum: 301
[    0.002619] ACPI: Core revision 20140424
[    0.007986] ACPI: All ACPI Tables successfully acquired
[    0.008351] Security Framework initialized
[    0.008725] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.009008] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.010354] Initializing cgroup subsys freezer
[    0.010748] Initializing cgroup subsys perf_event
[    0.011018] Initializing cgroup subsys debug
[    0.011434] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.011434] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.011434] tlb_flushall_shift: -1
[    0.017112] debug: unmapping init [mem 0xb195a000-0xb195dfff]
[    0.019644] Getting VERSION: 50014
[    0.019938] Getting VERSION: 50014
[    0.020010] Getting ID: 0
[    0.020230] Getting ID: f000000
[    0.020486] Getting LVT0: 8700
[    0.020743] Getting LVT1: 8400
[    0.021006] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.021484] enabled ExtINT on CPU#0
[    0.022739] ENABLING IO-APIC IRQs
[    0.023008] init IO_APIC IRQs
[    0.023248]  apic 0 pin 0 not connected
[    0.023559] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.024020] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.024716] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.025000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.025018] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.025638] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.026018] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.027018] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.027647] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.028017] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.029018] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.029661] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.030018] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.031018] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.032006] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.032647]  apic 0 pin 16 not connected
[    0.032962]  apic 0 pin 17 not connected
[    0.033005]  apic 0 pin 18 not connected
[    0.033421]  apic 0 pin 19 not connected
[    0.034005]  apic 0 pin 20 not connected
[    0.034316]  apic 0 pin 21 not connected
[    0.034628]  apic 0 pin 22 not connected
[    0.035004]  apic 0 pin 23 not connected
[    0.035446] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.036003] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, m=
odel: 06, stepping: 01)
[    0.036707] Using local APIC timer interrupts.
[    0.036707] calibrating APIC timer ...
[    0.038000] ... lapic delta =3D 6249499
[    0.038000] ... PM-Timer delta =3D 357925
[    0.038000] ... PM-Timer result ok
[    0.038000] ..... delta 6249499
[    0.038000] ..... mult: 268413938
[    0.038000] ..... calibration result: 999919
[    0.038000] ..... CPU clock speed is 2693.0059 MHz.
[    0.038000] ..... host bus clock speed is 999.0919 MHz.
[    0.038079] Performance Events: no PMU driver, software events only.
[    0.040213] x86: Booted up 1 node, 1 CPUs
[    0.040562] ----------------
[    0.040787] | NMI testsuite:
[    0.041003] --------------------
[    0.041260]   remote IPI:  ok  |
[    0.041535]    local IPI:  ok  |
[    0.041821] --------------------
[    0.042003] Good, all   2 testcases passed! |
[    0.042341] ---------------------------------
[    0.042674] smpboot: Total of 1 processors activated (5386.97 BogoMIPS)
[    0.043287] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.045832] regulator-dummy: no parameters
[    0.046289] RTC time: 12:43:19, date: 07/29/14
[    0.046716] NET: Registered protocol family 16
[    0.048053] EISA bus registered
[    0.048323] cpuidle: using governor ladder
[    0.048639] cpuidle: using governor menu
[    0.049289] ACPI: bus type PCI registered
[    0.049697] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.050005] PCI: Using configuration type 1 for base access
[    0.066413] ACPI: Added _OSI(Module Device)
[    0.066740] ACPI: Added _OSI(Processor Device)
[    0.067004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.067392] ACPI: Added _OSI(Processor Aggregator Device)
[    0.075875] ACPI: Interpreter enabled
[    0.076007] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.076742] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.077459] ACPI: (supports S0 S3 S5)
[    0.078003] ACPI: Using IOAPIC for interrupt routing
[    0.078426] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.090508] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.091003] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.091439] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.092334] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.093217] PCI host bridge to bus 0000:00
[    0.093540] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.094005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.094464] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.095004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.095533] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.096046] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.097222] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.098317] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.101258] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.102768] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.103004] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.103491] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.104003] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.105377] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.106117] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.106671] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.107387] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.110039] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.112031] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.119031] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.120385] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.121485] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.123006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.128004] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.129486] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.130490] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.132003] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.138252] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.139489] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.141004] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.146943] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.148004] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.149488] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.155585] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.157004] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.158489] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.164407] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.165491] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.167003] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.173154] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.174494] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.176003] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.181587] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.183003] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.186738] pci_bus 0000:00: on NUMA node 0
[    0.188377] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.189299] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.190196] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.191165] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.191824] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.193177] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.194564] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.195007] vgaarb: loaded
[    0.195220] vgaarb: bridge control possible 0000:00:02.0
[    0.196959] Advanced Linux Sound Architecture Driver Initialized.
[    0.197011] PCI: Using ACPI for IRQ routing
[    0.197340] PCI: pci_cache_line_size set to 64 bytes
[    0.198174] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.198628] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.200583] Switched to clocksource kvm-clock
[    0.216536] FS-Cache: Loaded
[    0.216871] pnp: PnP ACPI init
[    0.217173] ACPI: bus type PNP registered
[    0.217547] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.218268] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.218821] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.219577] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.220184] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.220882] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.221532] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.222174] pnp 00:03: [dma 2]
[    0.222611] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.223199] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.223883] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.224474] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.225232] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.225805] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.226497] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.227556] pnp: PnP ACPI: found 7 devices
[    0.227882] ACPI: bus type PNP unregistered
[    0.264040] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.264472] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.264902] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.265390] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.265888] NET: Registered protocol family 1
[    0.266251] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.266718] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.267184] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.267669] pci 0000:00:02.0: Boot video device
[    0.268088] PCI: CLS 0 bytes, default 64
[    0.268649] Unpacking initramfs...
[    0.367474] debug: unmapping init [mem 0xc3cbd000-0xc3feffff]
[    0.368575] apm: BIOS not found.
[    0.369357] cryptomgr_test (19) used greatest stack depth: 7060 bytes le=
ft
[    0.369940] INFO: trying to register non-static key.
[    0.370011] the code is fine but needs lockdep annotation.
[    0.370011] turning off the locking correctness validator.
[    0.370011] CPU: 0 PID: 19 Comm: cryptomgr_test Not tainted 3.16.0-rc1-0=
0010-gbd14ddc #10
[    0.370011]  00000000 00000000 c22abe1c b149e13a c14bb000 c22abe54 b1079=
298 b1673d18
[    0.370011]  00000000 c22abe54 b106767f 00000286 00000165 00000000 00000=
000 c14bb180
[    0.370011]  c14bb180 00000246 00000000 c22abe88 b1079c64 00000000 00000=
000 00000000
[    0.370011] Call Trace:
[    0.370011]  [<b149e13a>] dump_stack+0x48/0x60
[    0.370011]  [<b1079298>] __lock_acquire.isra.28+0x878/0xb20
[    0.370011]  [<b106767f>] ? sched_clock_cpu+0xdf/0x120
[    0.370011]  [<b1079c64>] lock_acquire+0x84/0x100
[    0.370011]  [<b1087a4f>] ? exit_rcu_tasks+0x2f/0x50
[    0.370011]  [<b14a322d>] _raw_spin_lock+0x3d/0x70
[    0.370011]  [<b1087a4f>] ? exit_rcu_tasks+0x2f/0x50
[    0.370011]  [<b1087a4f>] exit_rcu_tasks+0x2f/0x50
[    0.370011]  [<b108b6c8>] exit_rcu+0x8/0x10
[    0.370011]  [<b103d286>] do_exit+0x596/0x920
[    0.370011]  [<b1167030>] ? cryptomgr_notify+0x440/0x440
[    0.370011]  [<b116705b>] cryptomgr_test+0x2b/0x40
[    0.370011]  [<b1056230>] kthread+0xb0/0xd0
[    0.370011]  [<b1074492>] ? complete+0x12/0x40
[    0.370011]  [<b14a3f01>] ret_from_kernel_thread+0x21/0x30
[    0.370011]  [<b1056180>] ? __kthread_parkme+0x60/0x60
[    0.380893] cryptomgr_test (26) used greatest stack depth: 6316 bytes le=
ft
[    0.381613] PCLMULQDQ-NI instructions are not detected.
[    0.382045] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.382764] NatSemi SCx200 Driver
[    0.383497] futex hash table entries: 16 (order: -2, 1024 bytes)
[    0.384638] msgmni has been set to 590
[    0.387176] cryptomgr_test (46) used greatest stack depth: 6136 bytes le=
ft
[    0.391879] alg: No test for crc32 (crc32-table)
[    0.392583] alg: No test for lz4 (lz4-generic)
[    0.392969] alg: No test for lz4hc (lz4hc-generic)
[    0.393422] alg: No test for stdrng (krng)
[    0.397408] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.398034] start plist test
[    0.400410] end plist test
[    0.400636] list_sort_test: start testing list_sort()
[    0.402307] ipmi message handler version 39.2
[    0.402682] IPMI System Interface driver.
[    0.403197] ipmi_si: Unable to find any System Interface(s)
[    0.403643] IPMI Watchdog: driver initialized
[    0.403979] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    0.404797] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.405426] ACPI: Power Button [PWRF]
[    0.441388] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.465391] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.467358] Non-volatile memory driver v1.3
[    0.467832] scx200_gpio: no SCx200 gpio present
[    0.468420] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    0.469000] platform pc8736x_gpio.0: no device found
[    0.469460] nsc_gpio initializing
[    0.469748] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    0.470139] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    0.470867] Hangcheck: Using getrawmonotonic().
[    0.471685] [drm] Initialized drm 1.1.0 20060810
[    0.472300] dummy-irq: no IRQ given.  Use irq=3DN
[    0.473577] HSI/SSI char device loaded
[    0.474143] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.475422] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.475825] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.476814] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    0.477998] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    0.478749] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    0.479687] inport.c: Didn't find InPort mouse at 0x23c
[    0.480212] logibm.c: Didn't find Logitech busmouse at 0x23c
[    0.483279] mk712: device not present
[    0.484147] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    0.485241] wistron_btns: System unknown
[    0.485669] rtc_cmos 00:00: RTC can wake from S4
[    0.486445] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.487039] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    0.488876] rtc (null): invalid alarm value: 1900-1-29 0:0:0
[    0.489611] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    0.490210] rtc (null): invalid alarm value: 1900-1-29 0:0:0
[    0.490857] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    0.491607] i2c /dev entries driver
[    0.491968] i2c-parport-light: adapter type unspecified
[    0.492597] isa i2c-pca-isa.0: Please specify I/O base
[    0.493060] Driver for 1-wire Dallas network protocol.
[    0.493660] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    0.494159] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    0.496966] applesmc: supported laptop not found!
[    0.497385] applesmc: driver init failed (ret=3D-19)!
[    0.499020] pc87360: PC8736x not detected, module not inserted
[    0.500048] platform eisa.0: Probing EISA bus 0
[    0.500491] platform eisa.0: EISA: Cannot allocate resource for mainboard
[    0.501090] sdhci: Secure Digital Host Controller Interface driver
[    0.501559] sdhci: Copyright(c) Pierre Ossman
[    0.501906] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    0.502361] wbsd: Copyright(c) Pierre Ossman
[    0.502787] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.504082] ledtrig-cpu: registered to indicate activity on CPUs
[    0.505018] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    0.507662] FPGA DOWNLOAD --->
[    0.507911] FPGA image file name: xlinx_fpga_firmware.bit
[    0.508383] GPIO INIT FAIL!!
[    0.508656] hdaps: supported laptop not found!
[    0.509033] hdaps: driver init failed (ret=3D-19)!
[    0.509687] intel_rapl: driver does not support CPU family 15 model 6
[    0.510484] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    0.511064] I/O, IRQ, DMA and type are mandatory
[    0.511464] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    0.512169] ad1848: No ISAPnP cards found, trying standard ones...
[    0.512657] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[    0.513233] I/O, IRQ, DMA and type are mandatory
[    0.513586] sb: Init: Starting Probe...
[    0.513912] sb: Init: Done
[    0.514159] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[    0.514762] MIDI Loopback device driver
[    0.515667] ALSA: seq_oss: can't register device seq
[    0.516316] isa adlib.0: please specify port
[    0.520760] sc6000: specify IO port
[    0.521534] isa ad1848.0: please specify port
[    0.522315] isa cs4231.0: please specify port
[    0.523537] isa azt1605.0: please specify port
[    0.524332] isa azt2316.0: please specify port
[    1.114698] isa sb8.0: please specify irq
[    1.121275] please specify port
[    1.124225] oprofile: using timer interrupt.
[    1.124902]=20
[    1.124902] printing PIC contents
[    1.125290] ... PIC  IMR: ffff
[    1.125528] ... PIC  IRR: 1113
[    1.125779] ... PIC  ISR: 0000
[    1.126030] ... PIC ELCR: 0c00
[    1.126273] printing local APIC contents on CPU#0/0:
[    1.126664] ... APIC ID:      00000000 (0)
[    1.126980] ... APIC VERSION: 00050014
[    1.127021] ... APIC TASKPRI: 00000000 (00)
[    1.127021] ... APIC PROCPRI: 00000000
[    1.127021] ... APIC LDR: 01000000
[    1.127021] ... APIC DFR: ffffffff
[    1.127021] ... APIC SPIV: 000001ff
[    1.127021] ... APIC ISR field:
[    1.127021] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.127021] ... APIC TMR field:
[    1.127021] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.127021] ... APIC IRR field:
[    1.127021] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.127021] ... APIC ESR: 00000000
[    1.127021] ... APIC ICR: 00000831
[    1.127021] ... APIC ICR2: 01000000
[    1.127021] ... APIC LVTT: 000000ef
[    1.127021] ... APIC LVTPC: 00010000
[    1.127021] ... APIC LVT0: 00010700
[    1.127021] ... APIC LVT1: 00000400
[    1.127021] ... APIC LVTERR: 000000fe
[    1.127021] ... APIC TMICT: 0000eeb0
[    1.127021] ... APIC TMCCT: 00000000
[    1.127021] ... APIC TDCR: 00000003
[    1.127021]=20
[    1.134792] number of MP IRQ sources: 15.
[    1.135109] number of IO-APIC #0 registers: 24.
[    1.135450] testing the IO APIC.......................
[    1.135858] IO APIC #0......
[    1.136093] .... register #00: 00000000
[    1.136387] .......    : physical APIC id: 00
[    1.136724] .......    : Delivery Type: 0
[    1.137038] .......    : LTS          : 0
[    1.137346] .... register #01: 00170011
[    1.137646] .......     : max redirection entries: 17
[    1.138036] .......     : PRQ implemented: 0
[    1.138360] .......     : IO APIC version: 11
[    1.138697] .... register #02: 00000000
[    1.138987] .......     : arbitration: 00
[    1.139301] .... IRQ redirection table:
[    1.139609] 1    0    0   0   0    0    0    00
[    1.140040] 0    0    0   0   0    1    1    31
[    1.140393] 0    0    0   0   0    1    1    30
[    1.140757] 0    0    0   0   0    1    1    33
[    1.141123] 1    0    0   0   0    1    1    34
[    1.141475] 1    1    0   0   0    1    1    35
[    1.141839] 0    0    0   0   0    1    1    36
[    1.142202] 0    0    0   0   0    1    1    37
[    1.142554] 0    0    0   0   0    1    1    38
[    1.142916] 0    1    0   0   0    1    1    39
[    1.143281] 1    1    0   0   0    1    1    3A
[    1.143642] 1    1    0   0   0    1    1    3B
[    1.143990] 0    0    0   0   0    1    1    3C
[    1.144352] 0    0    0   0   0    1    1    3D
[    1.144716] 0    0    0   0   0    1    1    3E
[    1.145101] 0    0    0   0   0    1    1    3F
[    1.145451] 1    0    0   0   0    0    0    00
[    1.145816] 1    0    0   0   0    0    0    00
[    1.146176] 1    0    0   0   0    0    0    00
[    1.146527] 1    0    0   0   0    0    0    00
[    1.146888] 1    0    0   0   0    0    0    00
[    1.147251] 1    0    0   0   0    0    0    00
[    1.147611] 1    0    0   0   0    0    0    00
[    1.147962] 1    0    0   0   0    0    0    00
[    1.148317] IRQ to pin mappings:
[    1.148564] IRQ0 -> 0:2
[    1.148788] IRQ1 -> 0:1
[    1.149000] IRQ3 -> 0:3
[    1.149225] IRQ4 -> 0:4
[    1.149437] IRQ5 -> 0:5
[    1.149660] IRQ6 -> 0:6
[    1.149873] IRQ7 -> 0:7
[    1.150102] IRQ8 -> 0:8
[    1.150315] IRQ9 -> 0:9
[    1.150526] IRQ10 -> 0:10
[    1.150761] IRQ11 -> 0:11
[    1.150985] IRQ12 -> 0:12
[    1.151224] IRQ13 -> 0:13
[    1.151449] IRQ14 -> 0:14
[    1.151682] IRQ15 -> 0:15
[    1.151907] .................................... done.
[    1.152310] Using IPI No-Shortcut mode
[    1.154156]   Magic number: 6:143:735
[    1.154554] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.155118] EDD information not available.
[    1.155450] ALSA device list:
[    1.155689]   No soundcards found.
[    1.156368] debug: unmapping init [mem 0xb17ac000-0xb1959fff]
mount: mounting proc on /proc failed: No such device
[    1.166011] BUG: sleeping function called from invalid context at kernel=
/rcu/update.c:871
[    1.167352] in_atomic(): 1, irqs_disabled(): 0, pid: 86, name: mount
[    1.168207] INFO: lockdep is turned off.
[    1.168733] CPU: 0 PID: 86 Comm: mount Not tainted 3.16.0-rc1-00010-gbd1=
4ddc #10
[    1.169715]  00000000 00000000 c1651efc b149e13a 00000056 c1651f24 b1066=
52e b1673698
[    1.170891]  00000001 00000000 00000056 c16442f0 c1644000 c1644170 c1644=
000 c1651f34
[    1.172101]  b1087a43 00001abc 00000000 c1651f3c b108b6c8 c1651f8c b103d=
286 00000000
[    1.173283] Call Trace:
[    1.173627]  [<b149e13a>] dump_stack+0x48/0x60
[    1.174229]  [<b106652e>] __might_sleep+0xde/0x110
[    1.174862]  [<b1087a43>] exit_rcu_tasks+0x23/0x50
[    1.175510]  [<b108b6c8>] exit_rcu+0x8/0x10
[    1.176090]  [<b103d286>] do_exit+0x596/0x920
[    1.176659]  [<b1110c7d>] ? vfs_write+0x12d/0x190
[    1.177294]  [<b103d67f>] do_group_exit+0x2f/0x90
[    1.177920]  [<b103d6f1>] SyS_exit_group+0x11/0x20
[    1.178573]  [<b14a4085>] syscall_call+0x7/0xb
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/rcS.d/S37populate-volatile.sh: line 172: /proc/cmdline: No such file o=
r directory
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
ifup: can't open '/var/run/ifstate': No such file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: /proc/157/oom_score_adj: No such file or =
directory
sed: /lib/modules/3.16.0-rc1-00010-gbd14ddc/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[    1.321894] random: trinity urandom read with 6 bits of entropy available
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
## couldn't open logfile trinity.log
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
## couldn't open logfile trinity.log
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
[    1.772454] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    1.773704] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    2.371531] in_atomic(): 1, irqs_disabled(): 0, pid: 175, name: kwatchdog
[    2.372440] INFO: lockdep is turned off.
[    2.372986] CPU: 0 PID: 175 Comm: kwatchdog Not tainted 3.16.0-rc1-00010=
-gbd14ddc #10
[    2.374034]  00000000 00000000 c1695e90 b149e13a 000000af c1695eb8 b1066=
52e b1673698
[    2.375292]  00000001 00000000 000000af c16602f0 c1660000 c1660170 c1660=
000 c1695ec8
[    2.376561]  b1087a43 00001d48 00000000 c1695ed0 b108b6c8 c1695f20 b103d=
286 00000046
[    2.377789] Call Trace:
[    2.378100]  [<b149e13a>] dump_stack+0x48/0x60
[    2.378601]  [<b106652e>] __might_sleep+0xde/0x110
[    2.379164]  [<b1087a43>] exit_rcu_tasks+0x23/0x50
[    2.379745]  [<b108b6c8>] exit_rcu+0x8/0x10
[    2.380235]  [<b103d286>] do_exit+0x596/0x920
[    2.380734]  [<b14a1fd8>] ? mutex_unlock+0x8/0x10
[    2.381120]  [<b108fe80>] ? __clocksource_watchdog_kthread+0x150/0x150
[    2.381658]  [<b1056221>] kthread+0xa1/0xd0
[    2.381980]  [<b14a3f01>] ret_from_kernel_thread+0x21/0x30
[    2.382410]  [<b1056180>] ? __kthread_parkme+0x60/0x60

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
0-07291054/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-0001=
0-gbd14ddc -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kb=
uild-tests/run-queue/kvm/i386-randconfig-c0-07291054/linux-devel:devel-hour=
ly-2014072910:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisect-linux-7/.vmli=
nuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729204259-5-vp branch=3Dl=
inux-devel/devel-hourly-2014072910 BOOT_IMAGE=3D/kernel/i386-randconfig-c0-=
07291054/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-=
gbd14ddc drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-=
i386.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -=
boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive =
file=3D/fs/LABEL=3DKVM/disk0-yocto-vp-5,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/LABEL=3DKVM/disk1-yocto-vp-5,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk2-yocto-vp-5,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk3-yocto-vp-5,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk4-yocto-vp-5,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LA=
BEL=3DKVM/disk5-yocto-vp-5,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot=
/pid-yocto-vp-5 -serial file:/dev/shm/kboot/serial-yocto-vp-5 -daemonize -d=
isplay none -monitor null=20

--/NkBOFFp2J2Af1nK
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c0-07291054-042abb083e26874a281814b00dfd20149c9beae2-INFO:-trying-to-register-non-static-key--69640.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgMDQyYWJiMC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA3MjkxMCcKZ2l0IGNoZWNrb3V0IDY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5
OGE3ZDBlY2NmYmQ2YzFhOTEKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA3MjkxMDo2NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxOmJpc2Vj
dC1saW51eC03CgoyMDE0LTA3LTI5LTExOjM4OjM5IDY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5
OGE3ZDBlY2NmYmQ2YzFhOTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LTY0YWE5
MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC82NGFhOTBmMjZjMDZlMWNi
MmFhY2ZiOThhN2QwZWNjZmJkNmMxYTkxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQtNjRh
YTkwZjI2YzA2ZTFjYjJhYWNmYjk4YTdkMGVjY2ZiZDZjMWE5MQprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3
ZDBlY2NmYmQ2YzFhOTEvdm1saW51ei0zLjE2LjAtcmM3CgoyMDE0LTA3LTI5LTExOjQzOjM5
IGRldGVjdGluZyBib290IHN0YXRlIAkxNwkyMCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29t
bWl0IDY0YWE5MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEKZ2l0IGJpc2Vj
dCBzdGFydCAwNDJhYmIwODNlMjY4NzRhMjgxODE0YjAwZGZkMjAxNDljOWJlYWUyIDY0YWE5
MGYyNmMwNmUxY2IyYWFjZmI5OGE3ZDBlY2NmYmQ2YzFhOTEgLS0KL2Mva2VybmVsLXRlc3Rz
L2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMDQyYWJiMDgzZTI2ODc0YTI4MTgxNGIwMGRmZDIw
MTQ5YzliZWFlMiIsICItZyIsICI2NGFhOTBmMjZjMDZlMWNiMmFhY2ZiOThhN2QwZWNjZmJk
NmMxYTkxIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gi
LCAiL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAzODA0
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykK
WzkzNTEwNDYyNGYzMWY3MGZkMjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWJdIE1lcmdlICdhc29j
L3RvcGljL3JvY2tjaGlwJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcyOTEwCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJp
c2VjdC9saW51eC03L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA3MjkxMDo5MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3NDMxODM4YjdhZjhlZDFi
OmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTI5LTExOjQ0OjQwIDkzNTEwNDYyNGYzMWY3MGZk
MjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0
LTkzNTEwNDYyNGYzMWY3MGZkMjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRm
MzFmNzBmZDI0ODc0ZTY3NDMxODM4YjdhZjhlZDFiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEw
NTQtOTM1MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3YWY4ZWQxYgprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYyNGYzMWY3MGZkMjQ4
NzRlNjc0MzE4MzhiN2FmOGVkMWIvdm1saW51ei0zLjE2LjAtcmM3LXdsLWF0aC0wMjA5OC1n
OTM1MTA0NgoKMjAxNC0wNy0yOS0xMTo0Nzo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
Li4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDEuMDQzMzIyXSBkZWJ1ZzogdW5t
YXBwaW5nIGluaXQgW21lbSAweGMyN2FiMDAwLTB4YzNmZWZmZmZdClsgICAgMS4wNDUxOTFd
IGFwbTogQklPUyBub3QgZm91bmQuClsgICAgMS4wNDU5MzFdIGNyeXB0b21ncl90ZXN0ICgy
NSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNzA3MiBieXRlcyBsZWZ0ClsgICAgMS4w
NDY0OThdIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAx
LjA0Njg3Nl0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9u
LgpbICAgIDEuMDQ3MjgwXSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2
YWxpZGF0b3IuClsgICAgMS4wNDc0ODRdIENQVTogMSBQSUQ6IDI1IENvbW06IGNyeXB0b21n
cl90ZXN0IE5vdCB0YWludGVkIDMuMTYuMC1yYzctd2wtYXRoLTAyMDk4LWc5MzUxMDQ2ICMy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYyNGYzMWY3MGZk
MjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0NC0xMTM6MjAxNDA3
MjkxMTQ5MTI6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzAtMDcyOTEwNTQvOTM1MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3
YWY4ZWQxYi9kbWVzZy1xdWFudGFsLWl2YjQ0LTExOToyMDE0MDcyOTExNDkxMjppMzg2LXJh
bmRjb25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5
MTA1NC85MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3NDMxODM4YjdhZjhlZDFiL2RtZXNnLXF1
YW50YWwtaXZiNDQtMTIwOjIwMTQwNzI5MTE0OTEyOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5
MTA1NDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYyNGYz
MWY3MGZkMjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0NC0xNjoy
MDE0MDcyOTExNDkxMjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3NDMx
ODM4YjdhZjhlZDFiL2RtZXNnLXF1YW50YWwtaXZiNDQtMTc6MjAxNDA3MjkxMTQ5MTI6aTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAt
MDcyOTEwNTQvOTM1MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3YWY4ZWQxYi9kbWVz
Zy1xdWFudGFsLWl2YjQ0LTIxOjIwMTQwNzI5MTE0OTEyOmkzODYtcmFuZGNvbmZpZy1jMC0w
NzI5MTA1NDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYy
NGYzMWY3MGZkMjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0NC0y
ODoyMDE0MDcyOTExNDkxMjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3
NDMxODM4YjdhZjhlZDFiL2RtZXNnLXF1YW50YWwtaXZiNDQtMzM6MjAxNDA3MjkxMTQ5MTI6
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQvOTM1MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3YWY4ZWQxYi9k
bWVzZy1xdWFudGFsLWl2YjQ0LTM1OjIwMTQwNzI5MTE0OTEyOmkzODYtcmFuZGNvbmZpZy1j
MC0wNzI5MTA1NDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEw
NDYyNGYzMWY3MGZkMjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0
NC0zOjIwMTQwNzI5MTE0OTEyOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYyNGYzMWY3MGZkMjQ4NzRl
Njc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0NC00MjoyMDE0MDcyOTExNDkx
MjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3NDMxODM4YjdhZjhlZDFi
L2RtZXNnLXF1YW50YWwtaXZiNDQtNDM6MjAxNDA3MjkxMTQ5MTI6aTM4Ni1yYW5kY29uZmln
LWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvOTM1
MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3YWY4ZWQxYi9kbWVzZy1xdWFudGFsLWl2
YjQ0LTQ5OjIwMTQwNzI5MTE0OTEyOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYyNGYzMWY3MGZkMjQ4
NzRlNjc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0NC01NDoyMDE0MDcyOTEx
NDkxMjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3NDMxODM4YjdhZjhl
ZDFiL2RtZXNnLXF1YW50YWwtaXZiNDQtNTU6MjAxNDA3MjkxMTQ5MTI6aTM4Ni1yYW5kY29u
ZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQv
OTM1MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3YWY4ZWQxYi9kbWVzZy1xdWFudGFs
LWl2YjQ0LTYwOjIwMTQwNzI5MTE0OTEyOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzkzNTEwNDYyNGYzMWY3MGZk
MjQ4NzRlNjc0MzE4MzhiN2FmOGVkMWIvZG1lc2ctcXVhbnRhbC1pdmI0NC03ODoyMDE0MDcy
OTExNDkxMjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRmMzFmNzBmZDI0ODc0ZTY3NDMxODM4Yjdh
ZjhlZDFiL2RtZXNnLXF1YW50YWwtaXZiNDQtODE6MjAxNDA3MjkxMTQ5MTI6aTM4Ni1yYW5k
Y29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEw
NTQvOTM1MTA0NjI0ZjMxZjcwZmQyNDg3NGU2NzQzMTgzOGI3YWY4ZWQxYi9kbWVzZy15b2N0
by1pdmI0NC02ODoyMDE0MDcyOTExNDkxMjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC85MzUxMDQ2MjRmMzFmNzBm
ZDI0ODc0ZTY3NDMxODM4YjdhZjhlZDFiL2RtZXNnLXlvY3RvLWl2YjQ0LTk6MjAxNDA3Mjkx
MTQ5MTI6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKMDoyMDoyMCBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNy0yOSAxMTo1NzoxMyBSRVBFQVQgQ09V
TlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiAyMDk4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxMiBzdGVwcykKWzZlYjhjNjEyMmFhYjZlOTQ0MTEzZDZjYWRhNmU1Nzk0Njg5
NzQyNTFdIE1lcmdlICdwaW5jdHJsL2Zvci1uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0
MDcyOTEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC03L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MjkxMDo2ZWI4YzYxMjJhYWI2ZTk0NDExM2Q2Y2Fk
YTZlNTc5NDY4OTc0MjUxOmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTI5LTExOjU3OjE4IDZl
YjhjNjEyMmFhYjZlOTQ0MTEzZDZjYWRhNmU1Nzk0Njg5NzQyNTEgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWMwLTA3MjkxMDU0LTZlYjhjNjEyMmFhYjZlOTQ0MTEzZDZjYWRhNmU1Nzk0Njg5NzQy
NTEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5
MTA1NC82ZWI4YzYxMjJhYWI2ZTk0NDExM2Q2Y2FkYTZlNTc5NDY4OTc0MjUxCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQtNmViOGM2MTIyYWFiNmU5NDQxMTNkNmNhZGE2ZTU3OTQ2ODk3
NDI1MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvbGtwLWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC02ZWI4
YzYxMjJhYWI2ZTk0NDExM2Q2Y2FkYTZlNTc5NDY4OTc0MjUxCmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvNmViOGM2MTIyYWFiNmU5NDQxMTNkNmNhZGE2
ZTU3OTQ2ODk3NDI1MS92bWxpbnV6LTMuMTYuMC1yYzctMDA2NjAtZzZlYjhjNjEKCjIwMTQt
MDctMjktMTI6MDA6MTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgk0CTIwIFNVQ0NFU1MKCkJp
c2VjdGluZzogMTQzOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMTEgc3RlcHMpCls2ZjZjMTYyOWFmZDM0NmY5ODk3ZmNhZjViMDljY2MxNzliZThlZjU3
XSBNZXJnZSAnamNtdmJrYmMteHRlbnNhL3h0ZW5zYS1rYzcwNScgaW50byBkZXZlbC1ob3Vy
bHktMjAxNDA3MjkxMApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzI5MTA6NmY2YzE2MjlhZmQzNDZmOTg5
N2ZjYWY1YjA5Y2NjMTc5YmU4ZWY1NzpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0yOS0xMjow
NDo0NCA2ZjZjMTYyOWFmZDM0NmY5ODk3ZmNhZjViMDljY2MxNzliZThlZjU3IGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1jMC0wNzI5MTA1NC02ZjZjMTYyOWFmZDM0NmY5ODk3ZmNhZjViMDljY2Mx
NzliZThlZjU3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQvNmY2YzE2MjlhZmQzNDZmOTg5N2ZjYWY1YjA5Y2NjMTc5YmU4ZWY1Nwp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LTZmNmMxNjI5YWZkMzQ2Zjk4OTdmY2FmNWIwOWNj
YzE3OWJlOGVmNTcKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NC82ZjZjMTYyOWFmZDM0NmY5ODk3ZmNhZjViMDljY2MxNzliZThlZjU3L3ZtbGludXotMy4x
Ni4wLXJjNy0wMTI4MC1nNmY2YzE2MgoKMjAxNC0wNy0yOS0xMjowNjo1NSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDEu
NDMyNzY1XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGMyN2FiMDAwLTB4YzNmZWZm
ZmZdClsgICAgMS40MzQ2NDVdIGFwbTogQklPUyBub3QgZm91bmQuClsgICAgMS40MzU2NjRd
IGNyeXB0b21ncl90ZXN0ICgyNSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNzE0NCBi
eXRlcyBsZWZ0ClsgICAgMS40MzYzMTFdIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24t
c3RhdGljIGtleS4KWyAgICAxLjQzNjg3Ml0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMg
bG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDEuNDM3MjgwXSB0dXJuaW5nIG9mZiB0aGUgbG9j
a2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgMS40Mzc0NTNdIGNyeXB0b21ncl90
ZXN0ICgzMikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNjMxNiBieXRlcyBsZWZ0Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzZmNmMxNjI5YWZkMzQ2Zjk4OTdm
Y2FmNWIwOWNjYzE3OWJlOGVmNTcvZG1lc2ctcXVhbnRhbC12cC0yNToyMDE0MDcyOTEyMTgx
OTppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjNy0wMTI4MC1nNmY2YzE2
Mjo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzZmNmMxNjI5YWZkMzQ2
Zjk4OTdmY2FmNWIwOWNjYzE3OWJlOGVmNTcvZG1lc2cteW9jdG8tdnAtMjM6MjAxNDA3Mjkx
MjE4MTU6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDEyODAtZzZm
NmMxNjI6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC82ZjZjMTYyOWFm
ZDM0NmY5ODk3ZmNhZjViMDljY2MxNzliZThlZjU3L2RtZXNnLXlvY3RvLXZwLTI1OjIwMTQw
NzI5MTIxODIwOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAtcmM3LTAxMjgw
LWc2ZjZjMTYyOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvNmY2YzE2
MjlhZmQzNDZmOTg5N2ZjYWY1YjA5Y2NjMTc5YmU4ZWY1Ny9kbWVzZy15b2N0by12cC0zMDoy
MDE0MDcyOTEyMTgxNTppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjNy0w
MTI4MC1nNmY2YzE2Mjo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzZm
NmMxNjI5YWZkMzQ2Zjk4OTdmY2FmNWIwOWNjYzE3OWJlOGVmNTcvZG1lc2cteW9jdG8tdnAt
MzM6MjAxNDA3MjkxMjE4MTk6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1y
YzctMDEyODAtZzZmNmMxNjI6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NC82ZjZjMTYyOWFmZDM0NmY5ODk3ZmNhZjViMDljY2MxNzliZThlZjU3L2RtZXNnLXlvY3Rv
LXZwLTM1OjIwMTQwNzI5MTIxODIwOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2
LjAtcmM3LTAxMjgwLWc2ZjZjMTYyOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcy
OTEwNTQvNmY2YzE2MjlhZmQzNDZmOTg5N2ZjYWY1YjA5Y2NjMTc5YmU4ZWY1Ny9kbWVzZy15
b2N0by12cC00MToyMDE0MDcyOTEyMTgxOTppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6
My4xNi4wLXJjNy0wMTI4MC1nNmY2YzE2Mjo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMw
LTA3MjkxMDU0LzZmNmMxNjI5YWZkMzQ2Zjk4OTdmY2FmNWIwOWNjYzE3OWJlOGVmNTcvZG1l
c2cteW9jdG8tdnAtNTU6MjAxNDA3MjkxMjE4MTU6aTM4Ni1yYW5kY29uZmlnLWMwLTA3Mjkx
MDU0OjMuMTYuMC1yYzctMDEyODAtZzZmNmMxNjI6NAowOjg6OCBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwobWzE7MzVtMjAxNC0wNy0yOSAxMjoxNzo1NiBSRVBFQVQgQ09VTlQ6IDIw
ICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlz
ZWN0aW5nOiA2MjAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDEwIHN0ZXBzKQpbZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJhZjZhMl0g
TWVyZ2UgJ3JjdS9yY3VfdGFza3MuMjAxNC4wNy4yOGQnIGludG8gZGV2ZWwtaG91cmx5LTIw
MTQwNzI5MTAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2xpbnV4
LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcyOTEwOmVhOTdiZmFkMjgxZGVjNjM0MTcwNjhi
MGM5Njg2NDkyODkyYWY2YTI6YmlzZWN0LWxpbnV4LTcKCjIwMTQtMDctMjktMTI6MTc6NTYg
ZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJhZjZhMiBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQtZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJh
ZjZhMgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3
MjkxMDU0L2VhOTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2NDkyODkyYWY2YTIKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1jMC0wNzI5MTA1NC1lYTk3YmZhZDI4MWRlYzYzNDE3MDY4YjBjOTY4NjQ5Mjg5
MmFmNmEyCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvZWE5
N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJhZjZhMi92bWxpbnV6LTMuMTYuMC1y
YzctMDA3ODgtZ2VhOTdiZmEKCjIwMTQtMDctMjktMTI6MTk6NTcgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAxLjc0Njc0MV0gZGVidWc6IHVubWFwcGluZyBp
bml0IFttZW0gMHhjMjdhYjAwMC0weGMzZmVmZmZmXQpbICAgIDEuNzYwODA4XSBhcG06IEJJ
T1Mgbm90IGZvdW5kLgpbICAgIDEuNzYyMTgyXSBjcnlwdG9tZ3JfdGVzdCAoMjUpIHVzZWQg
Z3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDcwNjQgYnl0ZXMgbGVmdApbICAgIDEuNzYzMjAxXSBJ
TkZPOiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXkuClsgICAgMS43NjMyMDJd
IElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAxLjc2MzIw
NV0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAg
IDEuNzYzMjA1XSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0
b3IuClsgICAgMS43NjMyMTRdIENQVTogMCBQSUQ6IDI2IENvbW06IGNyeXB0b21ncl90ZXN0
IE5vdCB0YWludGVkIDMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmEgIzUKWyAgICAxLjc2MzIx
OV0gIDAwMDAwMDAwIDAwMDAwMDAwIGMwZWViZTFjIGIxNGEwNTc1IGJiYTI5MDAwIGMwZWVi
ZTU0IGIxMDc5NDY4IGIxNjc2NzUwClsgICAgMS43NjMyMjNdICAwMDAwMDAwMCBjMGVlYmU1
NCBiMTA2NzdmZiBiMTA2NzdmZiBiMTcxMDVkMCAwMDAwMDAwNiAwMDAwMDAwMCBiYmEyOTE4
MApbICAgIDEuNzYzMjI2XSAgYmJhMjkxODAgMDAwMDAyNDYgMDAwMDAwMDAgYzBlZWJlODgg
YjEwNzllMzQgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKWyAgICAxLjc2MzIyOF0gQ2Fs
bCBUcmFjZToKWyAgICAxLjc2MzIzOV0gIFs8YjE0YTA1NzU+XSBkdW1wX3N0YWNrKzB4NDgv
MHg2MApbICAgIDEuNzYzMjQ3XSAgWzxiMTA3OTQ2OD5dIF9fbG9ja19hY3F1aXJlLmlzcmEu
MjgrMHg4NzgvMHhiMjAKWyAgICAxLjc2MzI1M10gIFs8YjEwNjc3ZmY+XSA/IHNjaGVkX2Ns
b2NrX2NwdSsweGRmLzB4MTIwClsgICAgMS43NjMyNTVdICBbPGIxMDY3N2ZmPl0gPyBzY2hl
ZF9jbG9ja19jcHUrMHhkZi8weDEyMApbICAgIDEuNzYzMjU3XSAgWzxiMTA3OWUzND5dIGxv
Y2tfYWNxdWlyZSsweDg0LzB4MTAwClsgICAgMS43NjMyNjZdICBbPGIxMDg3ZDFmPl0gPyBl
eGl0X3JjdV90YXNrcysweDJmLzB4NTAKWyAgICAxLjc2MzI3Ml0gIFs8YjE0YTU2Y2Q+XSBf
cmF3X3NwaW5fbG9jaysweDNkLzB4NzAKWyAgICAxLjc2MzI3NF0gIFs8YjEwODdkMWY+XSA/
IGV4aXRfcmN1X3Rhc2tzKzB4MmYvMHg1MApbICAgIDEuNzYzMjc4XSAgWzxiMTA4N2QxZj5d
IGV4aXRfcmN1X3Rhc2tzKzB4MmYvMHg1MApbICAgIDEuNzYzMjgwXSAgWzxiMTA4YjlhOD5d
IGV4aXRfcmN1KzB4OC8weDEwClsgICAgMS43NjMyODVdICBbPGIxMDNkM2Y2Pl0gZG9fZXhp
dCsweDU5Ni8weDkyMApbICAgIDEuNzYzMzAxXSAgWzxiMTE2N2UxMD5dID8gY3J5cHRvbWdy
X25vdGlmeSsweDQ0MC8weDQ0MApbICAgIDEuNzYzMzAzXSAgWzxiMTE2N2UzYj5dIGNyeXB0
b21ncl90ZXN0KzB4MmIvMHg0MApbICAgIDEuNzYzMzEwXSAgWzxiMTA1NjNiMD5dIGt0aHJl
YWQrMHhiMC8weGQwClsgICAgMS43NjMzMTJdICBbPGIxMDc0NjEyPl0gPyBjb21wbGV0ZSsw
eDEyLzB4NDAKWyAgICAxLjc2MzMxNV0gIFs8YjE0YTYzODE+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MjEvMHgzMApbICAgIDEuNzYzMzE3XSAgWzxiMTA1NjMwMD5dID8gX19rdGhy
ZWFkX3BhcmttZSsweDYwLzB4NjAKWyAgICAxLjc2NDYwMl0gY3J5cHRvbWdyX3Rlc3QgKDMy
KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA2MzE2IGJ5dGVzIGxlZnQKWyAgICAxLjc2
NzcyN10gYWxnOiBObyB0ZXN0IGZvciBjcmMzMiAoY3JjMzItcGNsbXVsKQpbICAgIDEuNzY3
NzM5XSBUaGUgZm9yY2UgcGFyYW1ldGVyIGhhcyBub3QgYmVlbiBzZXQgdG8gMS4gVGhlIEly
aXMgcG93ZXJvZmYgaGFuZGxlciB3aWxsIG5vdCBiZSBpbnN0YWxsZWQuCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2VhOTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2
NDkyODkyYWY2YTIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjQ6MjAxNDA3MjkxMjE2NTI6aTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3
MDY4YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXF1YW50YWwtdnAtMjU6MjAxNDA3MjkxMjE5
MjE6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdi
ZmE6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRl
YzYzNDE3MDY4YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXlvY3RvLWtidWlsZC0xOToyMDE0
MDcyOTEyMTY0NzppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjNy0wMDc4
OC1nZWE5N2JmYTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2VhOTdi
ZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2NDkyODkyYWY2YTIvZG1lc2cteW9jdG8ta2J1aWxk
LTI2OjIwMTQwNzI5MTIxNjUzOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAt
cmM3LTAwNzg4LWdlYTk3YmZhOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEw
NTQvZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJhZjZhMi9kbWVzZy15b2N0
by1rYnVpbGQtMjc6MjAxNDA3MjkxMjE2NDc6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0
OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3MDY4YjBjOTY4NjQ5Mjg5MmFmNmEyL2Rt
ZXNnLXlvY3RvLXZwLTIzOjIwMTQwNzI5MTIxOTMzOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5
MTA1NDozLjE2LjAtcmM3LTAwNzg4LWdlYTk3YmZhOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzAtMDcyOTEwNTQvZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJhZjZh
Mi9kbWVzZy15b2N0by12cC01ODoyMDE0MDcyOTEyMTkzMzppMzg2LXJhbmRjb25maWctYzAt
MDcyOTEwNTQ6My4xNi4wLXJjNy0wMDc4OC1nZWE5N2JmYTo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMwLTA3MjkxMDU0L2VhOTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2NDkyODky
YWY2YTIvZG1lc2cteW9jdG8tdnAtMjA6MjAxNDA3MjkxMjE5MzM6aTM4Ni1yYW5kY29uZmln
LWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3MDY4YjBjOTY4NjQ5
Mjg5MmFmNmEyL2RtZXNnLXF1YW50YWwta2J1aWxkLTc6MjAxNDA3MjkxMjE2NTg6aTM4Ni1y
YW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3MDY4
YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXF1YW50YWwtdnAtMjU6MjAxNDA3MjkxMjE5NDI6
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYz
NDE3MDY4YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXF1YW50YWwtdnAtMjk6MjAxNDA3Mjkx
MjE5MzY6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2Vh
OTdiZmE6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4
MWRlYzYzNDE3MDY4YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXlvY3RvLWtidWlsZC0xNDoy
MDE0MDcyOTEyMTY1NDppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjNy0w
MDc4OC1nZWE5N2JmYTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2Vh
OTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2NDkyODkyYWY2YTIvZG1lc2cteW9jdG8ta2J1
aWxkLTE3OjIwMTQwNzI5MTIxNjU0OmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2
LjAtcmM3LTAwNzg4LWdlYTk3YmZhOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcy
OTEwNTQvZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0OTI4OTJhZjZhMi9kbWVzZy15
b2N0by1rYnVpbGQtMToyMDE0MDcyOTEyMTY1NDppMzg2LXJhbmRjb25maWctYzAtMDcyOTEw
NTQ6My4xNi4wLXJjNy0wMDc4OC1nZWE5N2JmYTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMwLTA3MjkxMDU0L2VhOTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2NDkyODkyYWY2YTIv
ZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA3MjkxMjE2NTU6aTM4Ni1yYW5kY29uZmlnLWMw
LTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3MDY4YjBjOTY4NjQ5Mjg5
MmFmNmEyL2RtZXNnLXlvY3RvLXZwLTEzOjIwMTQwNzI5MTIxOTM2OmkzODYtcmFuZGNvbmZp
Zy1jMC0wNzI5MTA1NDozLjE2LjAtcmM3LTAwNzg4LWdlYTk3YmZhOjUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzAtMDcyOTEwNTQvZWE5N2JmYWQyODFkZWM2MzQxNzA2OGIwYzk2ODY0
OTI4OTJhZjZhMi9kbWVzZy15b2N0by12cC0zODoyMDE0MDcyOTEyMTkzNjppMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjNy0wMDc4OC1nZWE5N2JmYTo1Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2VhOTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5
Njg2NDkyODkyYWY2YTIvZG1lc2cteW9jdG8tdnAtNDI6MjAxNDA3MjkxMjE5MzY6aTM4Ni1y
YW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3MDY4
YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXlvY3RvLXZwLTg6MjAxNDA3MjkxMjE5MzY6aTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYTk3YmZhZDI4MWRlYzYzNDE3
MDY4YjBjOTY4NjQ5Mjg5MmFmNmEyL2RtZXNnLXlvY3RvLXZwLTk6MjAxNDA3MjkxMjE5MzY6
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzctMDA3ODgtZ2VhOTdiZmE6
NQowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTI5
IDEyOjIwOjI3IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtNy9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEyOCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2YyNTVhYTVkM2NiNzE1Mzg5
MzYyMzY3MzI2YWVlYjFiNDVhYjhmYzNdIE1lcmdlICdrZ2VuZS1zYW1zdW5nL2Zvci1uZXh0
JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDcyOTEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC03L29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1jMC0wNzI5MTA1NC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MjkxMDpm
MjU1YWE1ZDNjYjcxNTM4OTM2MjM2NzMyNmFlZWIxYjQ1YWI4ZmMzOmJpc2VjdC1saW51eC03
CgoyMDE0LTA3LTI5LTEyOjIwOjI4IGYyNTVhYTVkM2NiNzE1Mzg5MzYyMzY3MzI2YWVlYjFi
NDVhYjhmYzMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LWYyNTVhYTVkM2NiNzE1
Mzg5MzYyMzY3MzI2YWVlYjFiNDVhYjhmYzMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9mMjU1YWE1ZDNjYjcxNTM4OTM2MjM2NzMy
NmFlZWIxYjQ1YWI4ZmMzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQtZjI1NWFhNWQzY2I3
MTUzODkzNjIzNjczMjZhZWViMWI0NWFiOGZjMwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMwLTA3MjkxMDU0L2YyNTVhYTVkM2NiNzE1Mzg5MzYyMzY3MzI2YWVlYjFiNDVh
YjhmYzMvdm1saW51ei0zLjE2LjAtcmM3LTAwNzQ3LWdmMjU1YWE1CgoyMDE0LTA3LTI5LTEy
OjIyOjI4IGRldGVjdGluZyBib290IHN0YXRlIC4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDQxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBz
KQpbMjFiYTI5NDU5ZDNlNWYxMjljMWU5NjI2MDk4OTg2NTIxYjA5ZGFiN10gTWVyZ2UgJ25l
dC9tYXN0ZXInIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNzI5MTAKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTcvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDcyOTEwOjIxYmEyOTQ1OWQzZTVmMTI5YzFlOTYyNjA5ODk4NjUyMWIwOWRhYjc6YmlzZWN0
LWxpbnV4LTcKCjIwMTQtMDctMjktMTI6MjQ6MjggMjFiYTI5NDU5ZDNlNWYxMjljMWU5NjI2
MDk4OTg2NTIxYjA5ZGFiNyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQtMjFiYTI5
NDU5ZDNlNWYxMjljMWU5NjI2MDk4OTg2NTIxYjA5ZGFiNwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzIxYmEyOTQ1OWQzZTVmMTI5
YzFlOTYyNjA5ODk4NjUyMWIwOWRhYjcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC0yMWJh
Mjk0NTlkM2U1ZjEyOWMxZTk2MjYwOTg5ODY1MjFiMDlkYWI3Cmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvMjFiYTI5NDU5ZDNlNWYxMjljMWU5NjI2MDk4
OTg2NTIxYjA5ZGFiNy92bWxpbnV6LTMuMTYuMC1yYzctMDA3NzgtZzIxYmEyOTQKCjIwMTQt
MDctMjktMTI6MjY6MjggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIwIFNVQ0NFU1MKCmxpbmVh
ci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIHJjdS9yY3VfdGFza3MuMjAxNC4wNy4yOGQK
bGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0
OiBnaXQgYmlzZWN0IHN0YXJ0IGVhOTdiZmFkMjgxZGVjNjM0MTcwNjhiMGM5Njg2NDkyODky
YWY2YTIgMjFiYTI5NDU5ZDNlNWYxMjljMWU5NjI2MDk4OTg2NTIxYjA5ZGFiNyAtLQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyMWJhMjk0Li4uIE1lcmdlICduZXQvbWFzdGVyJyBp
bnRvIGRldmVsLWhvdXJseS0yMDE0MDcyOTEwCkhFQUQgaXMgbm93IGF0IGEzNWMwN2QuLi4g
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZnRyYWNlL2Zvci1uZXh0JwpCaXNlY3Rp
bmc6IDQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3Rl
cHMpCls0MWQ4ZTAyMzgyZTFlNzljMTdhNzhjMDg5OGJjOTM4NTMxMDAwNzE2XSByY3V0b3J0
dXJlOiBBZGQgdG9ydHVyZSB0ZXN0cyBmb3IgUkNVLXRhc2tzCmxpbmVhci1iaXNlY3Q6IGdp
dCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC03L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3
MjkxMDo0MWQ4ZTAyMzgyZTFlNzljMTdhNzhjMDg5OGJjOTM4NTMxMDAwNzE2OmJpc2VjdC1s
aW51eC03CgoyMDE0LTA3LTI5LTEyOjI3OjA4IDQxZDhlMDIzODJlMWU3OWMxN2E3OGMwODk4
YmM5Mzg1MzEwMDA3MTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LTQxZDhlMDIz
ODJlMWU3OWMxN2E3OGMwODk4YmM5Mzg1MzEwMDA3MTYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC80MWQ4ZTAyMzgyZTFlNzljMTdh
NzhjMDg5OGJjOTM4NTMxMDAwNzE2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQtNDFkOGUw
MjM4MmUxZTc5YzE3YTc4YzA4OThiYzkzODUzMTAwMDcxNgprZXJuZWw6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzQxZDhlMDIzODJlMWU3OWMxN2E3OGMwODk4YmM5
Mzg1MzEwMDA3MTYvdm1saW51ei0zLjE2LjAtcmMxLTAwMDA3LWc0MWQ4ZTAyCgoyMDE0LTA3
LTI5LTEyOjI5OjA4IGRldGVjdGluZyBib290IHN0YXRlIC4JMTguLi4uCTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMSBzdGVwKQpbNGU3M2M1YWFmYmU5MTA4YzgzZGUwZjhmNTI5NGU2Y2NhZDJlMjljM10g
cmN1OiBBZGQgc3RhbGwtd2FybmluZyBjaGVja3MgZm9yIFJDVS10YXNrcwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwNzI5MTA6NGU3M2M1YWFmYmU5MTA4YzgzZGUwZjhmNTI5NGU2Y2NhZDJlMjljMzpi
aXNlY3QtbGludXgtNwoKMjAxNC0wNy0yOS0xMjozMzowNiA0ZTczYzVhYWZiZTkxMDhjODNk
ZTBmOGY1Mjk0ZTZjY2FkMmUyOWMzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC00
ZTczYzVhYWZiZTkxMDhjODNkZTBmOGY1Mjk0ZTZjY2FkMmUyOWMzCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvNGU3M2M1YWFmYmU5
MTA4YzgzZGUwZjhmNTI5NGU2Y2NhZDJlMjljMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0
LTRlNzNjNWFhZmJlOTEwOGM4M2RlMGY4ZjUyOTRlNmNjYWQyZTI5YzMKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC80ZTczYzVhYWZiZTkxMDhjODNkZTBm
OGY1Mjk0ZTZjY2FkMmUyOWMzL3ZtbGludXotMy4xNi4wLXJjMS0wMDAwOS1nNGU3M2M1YQoK
MjAxNC0wNy0yOS0xMjozNTowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMgkxNi4uCTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMSBzdGVwKQpbZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODky
MTM4MF0gcmN1OiBJbXByb3ZlIFJDVS10YXNrcyBlbmVyZ3kgZWZmaWNpZW5jeQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwNzI5MTA6ZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4
MDpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0yOS0xMjozODowNSBlYmM2NDM2MTY2YWU1ODNl
NmRiOTA2ZWI3ZmZkYjFjMTk4OTIxMzgwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NC1lYmM2NDM2MTY2YWU1ODNlNmRiOTA2ZWI3ZmZkYjFjMTk4OTIxMzgwCkNoZWNrIGZvciBr
ZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2
NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4MAp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMwLTA3Mjkx
MDU0LWViYzY0MzYxNjZhZTU4M2U2ZGI5MDZlYjdmZmRiMWMxOTg5MjEzODAKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYmM2NDM2MTY2YWU1ODNlNmRi
OTA2ZWI3ZmZkYjFjMTk4OTIxMzgwL3ZtbGludXotMy4xNi4wLXJjMS0wMDAxMS1nZWJjNjQz
NgoKMjAxNC0wNy0yOS0xMjo0MDowNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMjc3NjEwXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGMzY2Jk
MDAwLTB4YzNmZWZmZmZdClsgICAgMC4yNzg4OTddIGFwbTogQklPUyBub3QgZm91bmQuClsg
ICAgMC4yNzk1MjZdIGNyeXB0b21ncl90ZXN0ICgxOSkgdXNlZCBncmVhdGVzdCBzdGFjayBk
ZXB0aDogNzE0NCBieXRlcyBsZWZ0ClsgICAgMC4yODAwNjNdIElORk86IHRyeWluZyB0byBy
ZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAwLjI4MDQ0M10gdGhlIGNvZGUgaXMgZmlu
ZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDAuMjgwODUzXSB0dXJuaW5n
IG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgMC4yODEwNTJd
IENQVTogMCBQSUQ6IDE5IENvbW06IGNyeXB0b21ncl90ZXN0IE5vdCB0YWludGVkIDMuMTYu
MC1yYzEtMDAwMTEtZ2ViYzY0MzYgIzEKWyAgICAwLjI4MTA1Ml0gIDAwMDAwMDAwIDAwMDAw
MDAwIGMyMmFiZTFjIGIxNDllMWRhIGMxNGI2MDAwIGMyMmFiZTU0IGIxMDc5Mjk4IGIxNjcz
YmQ4ClsgICAgMC4yODEwNTJdICAwMDAwMDAwMCBjMjJhYmU1NCBiMTA2NzY3ZiAwMDAwMDI4
NiAwMDAwMDE1OSAwMDAwMDAwMCAwMDAwMDAwMCBjMTRiNjE4MApbICAgIDAuMjgxMDUyXSAg
YzE0YjYxODAgMDAwMDAyNDYgMDAwMDAwMDAgYzIyYWJlODggYjEwNzljNjQgMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjI4MTA1Ml0gQ2FsbCBUcmFjZToKWyAgICAwLjI4
MTA1Ml0gIFs8YjE0OWUxZGE+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDAuMjgxMDUy
XSAgWzxiMTA3OTI5OD5dIF9fbG9ja19hY3F1aXJlLmlzcmEuMjgrMHg4NzgvMHhiMjAKWyAg
ICAwLjI4MTA1Ml0gIFs8YjEwNjc2N2Y+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGRmLzB4MTIw
ClsgICAgMC4yODEwNTJdICBbPGIxMDc5YzY0Pl0gbG9ja19hY3F1aXJlKzB4ODQvMHgxMDAK
WyAgICAwLjI4MTA1Ml0gIFs8YjEwODdhZWY+XSA/IGV4aXRfcmN1X3Rhc2tzKzB4MmYvMHg1
MApbICAgIDAuMjgxMDUyXSAgWzxiMTRhMzJjZD5dIF9yYXdfc3Bpbl9sb2NrKzB4M2QvMHg3
MApbICAgIDAuMjgxMDUyXSAgWzxiMTA4N2FlZj5dID8gZXhpdF9yY3VfdGFza3MrMHgyZi8w
eDUwClsgICAgMC4yODEwNTJdICBbPGIxMDg3YWVmPl0gZXhpdF9yY3VfdGFza3MrMHgyZi8w
eDUwClsgICAgMC4yODEwNTJdICBbPGIxMDhiNzY4Pl0gZXhpdF9yY3UrMHg4LzB4MTAKWyAg
ICAwLjI4MTA1Ml0gIFs8YjEwM2QyODY+XSBkb19leGl0KzB4NTk2LzB4OTIwClsgICAgMC4y
ODEwNTJdICBbPGIxMTY3MGQwPl0gPyBjcnlwdG9tZ3Jfbm90aWZ5KzB4NDQwLzB4NDQwClsg
ICAgMC4yODEwNTJdICBbPGIxMTY3MGZiPl0gY3J5cHRvbWdyX3Rlc3QrMHgyYi8weDQwClsg
ICAgMC4yODEwNTJdICBbPGIxMDU2MjMwPl0ga3RocmVhZCsweGIwLzB4ZDAKWyAgICAwLjI4
MTA1Ml0gIFs8YjEwNzQ0OTI+XSA/IGNvbXBsZXRlKzB4MTIvMHg0MApbICAgIDAuMjgxMDUy
XSAgWzxiMTRhM2Y4MT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAg
MC4yODEwNTJdICBbPGIxMDU2MTgwPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4NjAvMHg2MApb
ICAgIDAuMjkwNDY3XSBjcnlwdG9tZ3JfdGVzdCAoMjYpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sg
ZGVwdGg6IDYzMTYgYnl0ZXMgbGVmdApbICAgIDAuMjkxMTMzXSBQQ0xNVUxRRFEtTkkgaW5z
dHJ1Y3Rpb25zIGFyZSBub3QgZGV0ZWN0ZWQuClsgICAgMC4yOTE1NDNdIFRoZSBmb3JjZSBw
YXJhbWV0ZXIgaGFzIG5vdCBiZWVuIHNldCB0byAxLiBUaGUgSXJpcyBwb3dlcm9mZiBoYW5k
bGVyIHdpbGwgbm90IGJlIGluc3RhbGxlZC4KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAt
MDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4MC9kbWVz
Zy15b2N0by12cC0zOjIwMTQwNzI5MTIzOTU2OmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NDozLjE2LjAtcmMxLTAwMDExLWdlYmM2NDM2OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4MC9k
bWVzZy15b2N0by12cC00MjoyMDE0MDcyOTEyMzk1NTppMzg2LXJhbmRjb25maWctYzAtMDcy
OTEwNTQ6My4xNi4wLXJjMS0wMDAxMS1nZWJjNjQzNjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMwLTA3MjkxMDU0L2ViYzY0MzYxNjZhZTU4M2U2ZGI5MDZlYjdmZmRiMWMxOTg5MjEz
ODAvZG1lc2cteW9jdG8tdnAtNjQ6MjAxNDA3MjkxMjM5NTY6aTM4Ni1yYW5kY29uZmlnLWMw
LTA3MjkxMDU0OjMuMTYuMC1yYzEtMDAwMTEtZ2ViYzY0MzY6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMC0wNzI5MTA1NC9lYmM2NDM2MTY2YWU1ODNlNmRiOTA2ZWI3ZmZkYjFjMTk4
OTIxMzgwL2RtZXNnLXlvY3RvLXZwLTQzOjIwMTQwNzI5MTIzOTU3OmkzODYtcmFuZGNvbmZp
Zy1jMC0wNzI5MTA1NDozLjE2LjAtcmMxLTAwMDExLWdlYmM2NDM2OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIx
YzE5ODkyMTM4MC9kbWVzZy15b2N0by12cC0xNToyMDE0MDcyOTEyNDAwMTppMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjMS0wMDAxMS1nZWJjNjQzNjoxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2ViYzY0MzYxNjZhZTU4M2U2ZGI5MDZlYjdm
ZmRiMWMxOTg5MjEzODAvZG1lc2cteW9jdG8tdnAtMjE6MjAxNDA3MjkxMjM5NTk6aTM4Ni1y
YW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzEtMDAwMTEtZ2ViYzY0MzY6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYmM2NDM2MTY2YWU1ODNlNmRiOTA2
ZWI3ZmZkYjFjMTk4OTIxMzgwL2RtZXNnLXlvY3RvLXZwLTQ4OjIwMTQwNzI5MTIzOTU5Omkz
ODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAtcmMxLTAwMDExLWdlYmM2NDM2OjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZk
YjkwNmViN2ZmZGIxYzE5ODkyMTM4MC9kbWVzZy15b2N0by12cC01OjIwMTQwNzI5MTIzOTU3
OmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAtcmMxLTAwMDExLWdlYmM2NDM2
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgz
ZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4MC9kbWVzZy15b2N0by1pdmI0NC0xMTM6MjAxNDA3
MjkxMjMyMTA6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5
ODkyMTM4MC9kbWVzZy15b2N0by1pdmI0NC0xOToyMDE0MDcyOTEyMzIxMDppMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NC9lYmM2NDM2MTY2YWU1ODNlNmRiOTA2ZWI3ZmZkYjFjMTk4OTIxMzgwL2RtZXNnLXlvY3Rv
LWl2YjQ0LTIwOjIwMTQwNzI5MTIzMjEwOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2ViYzY0MzYxNjZhZTU4M2U2
ZGI5MDZlYjdmZmRiMWMxOTg5MjEzODAvZG1lc2cteW9jdG8taXZiNDQtMzc6MjAxNDA3Mjkx
MjMyMTA6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODky
MTM4MC9kbWVzZy15b2N0by1pdmI0NC00NDoyMDE0MDcyOTEyMzIxMDppMzg2LXJhbmRjb25m
aWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9l
YmM2NDM2MTY2YWU1ODNlNmRiOTA2ZWI3ZmZkYjFjMTk4OTIxMzgwL2RtZXNnLXlvY3RvLWl2
YjQ0LTc4OjIwMTQwNzI5MTIzMjEwOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2ViYzY0MzYxNjZhZTU4M2U2ZGI5
MDZlYjdmZmRiMWMxOTg5MjEzODAvZG1lc2cteW9jdG8taXZiNDQtNzk6MjAxNDA3MjkxMjMy
MTA6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4
MC9kbWVzZy15b2N0by1pdmI0NC04MDoyMDE0MDcyOTEyMzIxMDppMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYmM2
NDM2MTY2YWU1ODNlNmRiOTA2ZWI3ZmZkYjFjMTk4OTIxMzgwL2RtZXNnLXlvY3RvLWl2YjQ0
LTg4OjIwMTQwNzI5MTIzMjEwOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2ViYzY0MzYxNjZhZTU4M2U2ZGI5MDZl
YjdmZmRiMWMxOTg5MjEzODAvZG1lc2cteW9jdG8taXZiNDQtOTE6MjAxNDA3MjkxMjMyMTA6
aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQvZWJjNjQzNjE2NmFlNTgzZTZkYjkwNmViN2ZmZGIxYzE5ODkyMTM4MC9k
bWVzZy15b2N0by1pdmI0NC05MzoyMDE0MDcyOTEyMzIxMDppMzg2LXJhbmRjb25maWctYzAt
MDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9lYmM2NDM2
MTY2YWU1ODNlNmRiOTA2ZWI3ZmZkYjFjMTk4OTIxMzgwL2RtZXNnLXlvY3RvLWl2YjQ0LTk4
OjIwMTQwNzI5MTIzMjEwOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6CjA6MjA6MjAg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMjkgMTI6NDE6MTQg
UkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC03L29iai1iaXNlY3Qv
LnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMCBzdGVwcykKW2JkMTRkZGM0NTYxNGI2MTIxMGZkZjBlZTRlOTQx
NTI5NDhkZDlkNWVdIHJjdTogTWFrZSBSQ1UtdGFza3MgdHJhY2sgZXhpdGluZyB0YXNrcwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgtNy9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwNzI5MTA6YmQxNGRkYzQ1NjE0YjYxMjEwZmRmMGVlNGU5NDE1Mjk0
OGRkOWQ1ZTpiaXNlY3QtbGludXgtNwoKMjAxNC0wNy0yOS0xMjo0MTo1MyBiZDE0ZGRjNDU2
MTRiNjEyMTBmZGYwZWU0ZTk0MTUyOTQ4ZGQ5ZDVlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMC0w
NzI5MTA1NC1iZDE0ZGRjNDU2MTRiNjEyMTBmZGYwZWU0ZTk0MTUyOTQ4ZGQ5ZDVlCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvYmQx
NGRkYzQ1NjE0YjYxMjEwZmRmMGVlNGU5NDE1Mjk0OGRkOWQ1ZQp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMw
LTA3MjkxMDU0LWJkMTRkZGM0NTYxNGI2MTIxMGZkZjBlZTRlOTQxNTI5NDhkZDlkNWUKa2Vy
bmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9iZDE0ZGRjNDU2MTRi
NjEyMTBmZGYwZWU0ZTk0MTUyOTQ4ZGQ5ZDVlL3ZtbGludXotMy4xNi4wLXJjMS0wMDAxMC1n
YmQxNGRkYwoKMjAxNC0wNy0yOS0xMjo0Mzo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRF
U1QgRkFJTFVSRQpbICAgIDEuMDkwNzMwXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAw
eGMyN2FiMDAwLTB4YzNmZWZmZmZdClsgICAgMS4wOTI0MDhdIGFwbTogQklPUyBub3QgZm91
bmQuClsgICAgMS4wOTMxMDJdIGNyeXB0b21ncl90ZXN0ICgyNSkgdXNlZCBncmVhdGVzdCBz
dGFjayBkZXB0aDogNzE0NCBieXRlcyBsZWZ0ClsgICAgMS4wOTM2MzVdIElORk86IHRyeWlu
ZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAxLjA5NDAxMF0gdGhlIGNvZGUg
aXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDEuMDk0MDEwXSB0
dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgMS4w
OTQwMTBdIENQVTogMSBQSUQ6IDI1IENvbW06IGNyeXB0b21ncl90ZXN0IE5vdCB0YWludGVk
IDMuMTYuMC1yYzEtMDAwMTAtZ2JkMTRkZGMgIzEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMwLTA3MjkxMDU0L2JkMTRkZGM0NTYxNGI2MTIxMGZkZjBlZTRlOTQxNTI5NDhkZDlkNWUv
ZG1lc2cteW9jdG8tdnAtMTU6MjAxNDA3MjkxMjQzMTQ6aTM4Ni1yYW5kY29uZmlnLWMwLTA3
MjkxMDU0OjMuMTYuMC1yYzEtMDAwMTAtZ2JkMTRkZGM6MTAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQvYmQxNGRkYzQ1NjE0YjYxMjEwZmRmMGVlNGU5NDE1Mjk0OGRk
OWQ1ZS9kbWVzZy15b2N0by12cC00ODoyMDE0MDcyOTEyNDMxMTppMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQ6My4xNi4wLXJjMS0wMDAxMC1nYmQxNGRkYzoxMAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9iZDE0ZGRjNDU2MTRiNjEyMTBmZGYwZWU0ZTk0MTUy
OTQ4ZGQ5ZDVlL2RtZXNnLXlvY3RvLXZwLTQ6MjAxNDA3MjkxMjQzMTU6aTM4Ni1yYW5kY29u
ZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzEtMDAwMTAtZ2JkMTRkZGM6MTAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvYmQxNGRkYzQ1NjE0YjYxMjEwZmRmMGVlNGU5
NDE1Mjk0OGRkOWQ1ZS9kbWVzZy15b2N0by12cC01OjIwMTQwNzI5MTI0MzEwOmkzODYtcmFu
ZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAtcmMxLTAwMDEwLWdiZDE0ZGRjOjEwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2JkMTRkZGM0NTYxNGI2MTIxMGZkZjBl
ZTRlOTQxNTI5NDhkZDlkNWUvZG1lc2ctcXVhbnRhbC12cC05OjIwMTQwNzI5MTI0MzM0Omkz
ODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAtcmMxLTAwMDEwLWdiZDE0ZGRjOjEw
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2JkMTRkZGM0NTYxNGI2MTIx
MGZkZjBlZTRlOTQxNTI5NDhkZDlkNWUvZG1lc2cteW9jdG8tdnAtMTA6MjAxNDA3MjkxMjQz
MzQ6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYuMC1yYzEtMDAwMTAtZ2JkMTRk
ZGM6MTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvYmQxNGRkYzQ1NjE0
YjYxMjEwZmRmMGVlNGU5NDE1Mjk0OGRkOWQ1ZS9kbWVzZy15b2N0by12cC0xNToyMDE0MDcy
OTEyNDMzMzppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJjMS0wMDAxMC1n
YmQxNGRkYzoxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9iZDE0ZGRj
NDU2MTRiNjEyMTBmZGYwZWU0ZTk0MTUyOTQ4ZGQ5ZDVlL2RtZXNnLXlvY3RvLXZwLTQ4OjIw
MTQwNzI5MTI0MzMxOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDozLjE2LjAtcmMxLTAw
MDEwLWdiZDE0ZGRjOjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2Jk
MTRkZGM0NTYxNGI2MTIxMGZkZjBlZTRlOTQxNTI5NDhkZDlkNWUvZG1lc2cteW9jdG8tdnAt
NDoyMDE0MDcyOTEyNDMzMzppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6My4xNi4wLXJj
MS0wMDAxMC1nYmQxNGRkYzoxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NC9iZDE0ZGRjNDU2MTRiNjEyMTBmZGYwZWU0ZTk0MTUyOTQ4ZGQ5ZDVlL2RtZXNnLXlvY3Rv
LXZwLTU6MjAxNDA3MjkxMjQzMzE6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjMuMTYu
MC1yYzEtMDAwMTAtZ2JkMTRkZGM6MTAKMDoxMDoxMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwobWzE7MzVtMjAxNC0wNy0yOSAxMjo0NDozMCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTcvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmQxNGRkYzQ1
NjE0YjYxMjEwZmRmMGVlNGU5NDE1Mjk0OGRkOWQ1ZSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1p
dApjb21taXQgYmQxNGRkYzQ1NjE0YjYxMjEwZmRmMGVlNGU5NDE1Mjk0OGRkOWQ1ZQpBdXRo
b3I6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXgudm5ldC5pYm0uY29tPgpEYXRl
OiAgIE1vbiBKdWwgMjggMTI6NDE6MjUgMjAxNCAtMDcwMAoKICAgIHJjdTogTWFrZSBSQ1Ut
dGFza3MgdHJhY2sgZXhpdGluZyB0YXNrcwogICAgCiAgICBUaGlzIGNvbW1pdCBhZGRzIHN5
bmNocm9uaXphdGlvbiB3aXRoIGV4aXRpbmcgdGFza3MsIHNvIHRoYXQgUkNVLXRhc2tzCiAg
ICBhdm9pZHMgd2FpdGluZyBvbiB0YXNrcyB0aGF0IG5vIGxvbmdlciBleGlzdC4KICAgIAog
ICAgU2lnbmVkLW9mZi1ieTogUGF1bCBFLiBNY0tlbm5leSA8cGF1bG1ja0BsaW51eC52bmV0
LmlibS5jb20+CiAgICAKICAgIENvbmZsaWN0czoKICAgIAlrZXJuZWwvcmN1L3VwZGF0ZS5j
Cgo6MDQwMDAwIDA0MDAwMCA1NzQ1YjUxNjY3NjdjZDZiYWY1YmQ2ZTY0ZmUwMjQ5Nzk4Yzdh
MzIyIDJmZTg2M2E3YTVkZjBjNTRiMzQ1MzI0ZjNjZWU5Yzg0NmYwODkwNWEgTQlpbmNsdWRl
CjowNDAwMDAgMDQwMDAwIGExNjA1YzU1MTY4YzI2ZTY2MTQ5NTdlZWY4NTBjODJmY2E2NDMw
ZjIgZjZhOWM2OWI1YjUzMDRiMGYyODk2MDk0ODNhMDZkNmU0ODYwNDcxMiBNCWtlcm5lbApi
aXNlY3QgcnVuIHN1Y2Nlc3MKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYmQxNGRkYy4u
LiByY3U6IE1ha2UgUkNVLXRhc2tzIHRyYWNrIGV4aXRpbmcgdGFza3MKSEVBRCBpcyBub3cg
YXQgNGU3M2M1YS4uLiByY3U6IEFkZCBzdGFsbC13YXJuaW5nIGNoZWNrcyBmb3IgUkNVLXRh
c2tzCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzI5MTA6NGU3M2M1
YWFmYmU5MTA4YzgzZGUwZjhmNTI5NGU2Y2NhZDJlMjljMzpiaXNlY3QtbGludXgtNwoKMjAx
NC0wNy0yOS0xMjo0NDozOCA0ZTczYzVhYWZiZTkxMDhjODNkZTBmOGY1Mjk0ZTZjY2FkMmUy
OWMzIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzRlNzNjNWFh
ZmJlOTEwOGM4M2RlMGY4ZjUyOTRlNmNjYWQyZTI5YzMvdm1saW51ei0zLjE2LjAtcmMxLTAw
MDA5LWc0ZTczYzVhCgoyMDE0LTA3LTI5LTEyOjQ0OjM4IGRldGVjdGluZyBib290IHN0YXRl
IC4uCTIxCTU0Li4uLi4uLi4JNjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgNGU3M2M1YS4uLiByY3U6IEFkZCBzdGFsbC13YXJuaW5nIGNoZWNrcyBmb3IgUkNVLXRh
c2tzCkhFQUQgaXMgbm93IGF0IDA0MmFiYjAuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2
ZWwtaG91cmx5LTIwMTQwNzI5MTAnCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwNzI5MTA6MDQyYWJiMDgzZTI2ODc0YTI4MTgxNGIwMGRmZDIwMTQ5YzliZWFlMjpi
aXNlY3QtbGludXgtNwogVEVTVCBGQUlMVVJFClsgICAgMS4wMTE5NDldIGRlYnVnOiB1bm1h
cHBpbmcgaW5pdCBbbWVtIDB4YzI3YWIwMDAtMHhjM2ZlZmZmZl0KWyAgICAxLjAxMzUyMV0g
YXBtOiBCSU9TIG5vdCBmb3VuZC4KWyAgICAxLjAxNDM3M10gY3J5cHRvbWdyX3Rlc3QgKDI1
KSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA3MTQ0IGJ5dGVzIGxlZnQKWyAgICAxLjAx
NDkwNF0gSU5GTzogdHJ5aW5nIHRvIHJlZ2lzdGVyIG5vbi1zdGF0aWMga2V5LgpbICAgIDEu
MDE0OTA1XSBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXkuClsgICAg
MS4wMTQ5MDddIHRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5ub3RhdGlv
bi4KWyAgICAxLjAxNDkwN10gdHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5lc3Mg
dmFsaWRhdG9yLgpbICAgIDEuMDE0OTEwXSBDUFU6IDAgUElEOiAyNiBDb21tOiBjcnlwdG9t
Z3JfdGVzdCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM3LXdsLWF0aC0wMzgwNC1nMDQyYWJiMCAj
MTMxClsgICAgMS4wMTQ5MTNdICAwMDAwMDAwMCAwMDAwMDAwMCBiYmRlZmUxYyBiMTRhMjM3
NSBiYmEzMDAwMCBiYmRlZmU1NCBiMTA3OGI5OCBiMTY3OTA4MApbICAgIDEuMDE0OTE1XSAg
MDAwMDAwMDAgYmJkZWZlNTQgYjEwNjZlOGYgYjEwNjZlOGYgYmJhMzA0NDggYmJkZWZlNjQg
MDAwMDAwMDAgYmJhMzAxODAKWyAgICAxLjAxNDkxN10gIGJiYTMwMTgwIDAwMDAwMjQ2IDAw
MDAwMDAwIGJiZGVmZTg4IGIxMDc5NTY0IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwClsg
ICAgMS4wMTQ5MThdIENhbGwgVHJhY2U6ClsgICAgMS4wMTQ5MjJdICBbPGIxNGEyMzc1Pl0g
ZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAxLjAxNDkyNV0gIFs8YjEwNzhiOTg+XSBfX2xv
Y2tfYWNxdWlyZS5pc3JhLjI4KzB4ODc4LzB4YjIwClsgICAgMS4wMTQ5MjddICBbPGIxMDY2
ZThmPl0gPyBzY2hlZF9jbG9ja19jcHUrMHhkZi8weDEyMApbICAgIDEuMDE0OTI4XSAgWzxi
MTA2NmU4Zj5dID8gc2NoZWRfY2xvY2tfY3B1KzB4ZGYvMHgxMjAKWyAgICAxLjAxNDkzMF0g
IFs8YjEwNzk1NjQ+XSBsb2NrX2FjcXVpcmUrMHg4NC8weDEwMApbICAgIDEuMDE0OTMyXSAg
WzxiMTA4NzQ0Zj5dID8gZXhpdF9yY3VfdGFza3MrMHgyZi8weDUwClsgICAgMS4wMTQ5MzRd
ICBbPGIxNGE3NTVkPl0gX3Jhd19zcGluX2xvY2srMHgzZC8weDcwClsgICAgMS4wMTQ5MzZd
ICBbPGIxMDg3NDRmPl0gPyBleGl0X3JjdV90YXNrcysweDJmLzB4NTAKWyAgICAxLjAxNDkz
N10gIFs8YjEwODc0NGY+XSBleGl0X3JjdV90YXNrcysweDJmLzB4NTAKWyAgICAxLjAxNDkz
OF0gIFs8YjEwOGIwZDg+XSBleGl0X3JjdSsweDgvMHgxMApbICAgIDEuMDE0OTQwXSAgWzxi
MTAzY2NmNj5dIGRvX2V4aXQrMHg1OTYvMHg5MjAKWyAgICAxLjAxNDk0NF0gIFs8YjExNjdh
MTA+XSA/IGNyeXB0b21ncl9ub3RpZnkrMHg0NDAvMHg0NDAKWyAgICAxLjAxNDk0NV0gIFs8
YjExNjdhM2I+XSBjcnlwdG9tZ3JfdGVzdCsweDJiLzB4NDAKWyAgICAxLjAxNDk0N10gIFs8
YjEwNTViMDA+XSBrdGhyZWFkKzB4YjAvMHhkMApbICAgIDEuMDE0OTQ5XSAgWzxiMTA3M2Q0
Mj5dID8gY29tcGxldGUrMHgxMi8weDQwClsgICAgMS4wMTQ5NTBdICBbPGIxNGE4MjAxPl0g
cmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICAxLjAxNDk1MV0gIFs8YjEw
NTVhNTA+XSA/IF9fa3RocmVhZF9wYXJrbWUrMHg2MC8weDYwClsgICAgMS4wMTU1OTRdIGNy
eXB0b21ncl90ZXN0ICgzMikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNjMxNiBieXRl
cyBsZWZ0ClsgICAgMS4wMTU3OTBdIFBDTE1VTFFEUS1OSSBpbnN0cnVjdGlvbnMgYXJlIG5v
dCBkZXRlY3RlZC4KWyAgICAxLjAxNTc5M10gVGhlIGZvcmNlIHBhcmFtZXRlciBoYXMgbm90
IGJlZW4gc2V0IHRvIDEuIFRoZSBJcmlzIHBvd2Vyb2ZmIGhhbmRsZXIgd2lsbCBub3QgYmUg
aW5zdGFsbGVkLgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC8wNDJhYmIw
ODNlMjY4NzRhMjgxODE0YjAwZGZkMjAxNDljOWJlYWUyL2RtZXNnLXF1YW50YWwtaXZiNDMt
OTE6MjAxNDA3MjkxMTQ1MzU6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvMDQyYWJiMDgzZTI2ODc0YTI4MTgxNGIw
MGRmZDIwMTQ5YzliZWFlMi9kbWVzZy1xdWFudGFsLWl2YjQzLTMxOjIwMTQwNzI5MTE0NTMy
OmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMwLTA3MjkxMDU0LzA0MmFiYjA4M2UyNjg3NGEyODE4MTRiMDBkZmQyMDE0OWM5YmVhZTIv
ZG1lc2ctcXVhbnRhbC1pdmI0My00NDoyMDE0MDcyOTExNDUzMjppMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC8wNDJh
YmIwODNlMjY4NzRhMjgxODE0YjAwZGZkMjAxNDljOWJlYWUyL2RtZXNnLXF1YW50YWwtaXZi
NDMtMTExOjIwMTQwNzI5MTE0NTM1OmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzA0MmFiYjA4M2UyNjg3NGEyODE4
MTRiMDBkZmQyMDE0OWM5YmVhZTIvZG1lc2cteW9jdG8taXZiNDMtMTA0OjIwMTQwNzI5MTEw
NDAzOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMwLTA3MjkxMDU0LzA0MmFiYjA4M2UyNjg3NGEyODE4MTRiMDBkZmQyMDE0OWM5YmVh
ZTIvZG1lc2ctcXVhbnRhbC1pdmI0My0xMToyMDE0MDcyOTExNDUzMjppMzg2LXJhbmRjb25m
aWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC8w
NDJhYmIwODNlMjY4NzRhMjgxODE0YjAwZGZkMjAxNDljOWJlYWUyL2RtZXNnLXF1YW50YWwt
aXZiNDMtNjE6MjAxNDA3MjkxMTQ1MzI6aTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvMDQyYWJiMDgzZTI2ODc0YTI4
MTgxNGIwMGRmZDIwMTQ5YzliZWFlMi9kbWVzZy1xdWFudGFsLWl2YjQzLTc4OjIwMTQwNzI5
MTE0NTM1OmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NDo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMwLTA3MjkxMDU0LzA0MmFiYjA4M2UyNjg3NGEyODE4MTRiMDBkZmQyMDE0OWM5
YmVhZTIvZG1lc2ctcXVhbnRhbC1pdmI0My02ODoyMDE0MDcyOTExNDUzNTppMzg2LXJhbmRj
b25maWctYzAtMDcyOTEwNTQ6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NC8wNDJhYmIwODNlMjY4NzRhMjgxODE0YjAwZGZkMjAxNDljOWJlYWUyL2RtZXNnLXF1YW50
YWwtaXZiNDMtMTE5OjIwMTQwNzI5MTE0NTMyOmkzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1
NDo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzA0MmFiYjA4M2UyNjg3
NGEyODE4MTRiMDBkZmQyMDE0OWM5YmVhZTIvZG1lc2ctcXVhbnRhbC1pdmI0My00ODoyMDE0
MDcyOTExNDUzMjppMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQ6OgowOjExOjExIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCAwNDJhYmIwIDBkYXkgaGVh
ZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDcyOTEwJwoKPT09PT09PT09IGxpbnVz
L21hc3RlciA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMDQyYWJiMC4u
LiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MjkxMCcKSEVBRCBp
cyBub3cgYXQgMzFkYWI3MS4uLiBNZXJnZSBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvaGVyYmVydC9jcnlwdG8tMi42CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQvbGludXM6bWFz
dGVyOjMxZGFiNzE5ZmE1MGNmNTZkNTZkM2RjMjU5ODBmZWNkMzM2ZjZjYTg6YmlzZWN0LWxp
bnV4LTcKCjIwMTQtMDctMjktMTI6NTM6NTQgMzFkYWI3MTlmYTUwY2Y1NmQ1NmQzZGMyNTk4
MGZlY2QzMzZmNmNhOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzAtMDcyOTEwNTQtMzFkYWI3MTlm
YTUwY2Y1NmQ1NmQzZGMyNTk4MGZlY2QzMzZmNmNhOApDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0LzMxZGFiNzE5ZmE1MGNmNTZkNTZk
M2RjMjU5ODBmZWNkMzM2ZjZjYTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC0zMWRhYjcx
OWZhNTBjZjU2ZDU2ZDNkYzI1OTgwZmVjZDMzNmY2Y2E4Cmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzAtMDcyOTEwNTQvMzFkYWI3MTlmYTUwY2Y1NmQ1NmQzZGMyNTk4MGZl
Y2QzMzZmNmNhOC92bWxpbnV6LTMuMTYuMC1yYzctMDAwMDctZzMxZGFiNzEKCjIwMTQtMDct
MjktMTI6NTU6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTYwIFNVQ0NFU1MKCgo9PT09PT09
PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICsg
ZmI4ZGU4NC4uLmU0MWEyNzggYWtwbSAgICAgICAtPiBuZXh0L2FrcG0gIChmb3JjZWQgdXBk
YXRlKQogKyA3MWFhMTZiLi4uMDI1MjYzMyBha3BtLWJhc2UgIC0+IG5leHQvYWtwbS1iYXNl
ICAoZm9yY2VkIHVwZGF0ZSkKICsgNWViMDBiMC4uLmU0MGNmZjQgbWFzdGVyICAgICAtPiBu
ZXh0L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAgIDE1YmEyMjMuLjY0YWE5MGYgIHN0YWJs
ZSAgICAgLT4gbmV4dC9zdGFibGUKRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKiBbbmV3
IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNzI0IC0+IG5leHQtMjAxNDA3MjQKICogW25ldyB0
YWddICAgICAgICAgbmV4dC0yMDE0MDcyNSAtPiBuZXh0LTIwMTQwNzI1CiAqIFtuZXcgdGFn
XSAgICAgICAgIG5leHQtMjAxNDA3MjggLT4gbmV4dC0yMDE0MDcyOApQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyAzMWRhYjcxLi4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9oZXJiZXJ0L2NyeXB0by0yLjYKSEVBRCBpcyBub3cg
YXQgZTQwY2ZmNC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3
MjgKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1j
MC0wNzI5MTA1NC9uZXh0Om1hc3RlcjplNDBjZmY0YTc5OTBlNWQ3M2VhYWQwYTJmMjU5M2Zl
NzI1ZTI0Y2RkOmJpc2VjdC1saW51eC03CgoyMDE0LTA3LTI5LTEzOjA1OjUzIGU0MGNmZjRh
Nzk5MGU1ZDczZWFhZDBhMmYyNTkzZmU3MjVlMjRjZGQgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMw
LTA3MjkxMDU0LWU0MGNmZjRhNzk5MGU1ZDczZWFhZDBhMmYyNTkzZmU3MjVlMjRjZGQKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMC0wNzI5MTA1NC9l
NDBjZmY0YTc5OTBlNWQ3M2VhYWQwYTJmMjU5M2ZlNzI1ZTI0Y2RkCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
YzAtMDcyOTEwNTQtZTQwY2ZmNGE3OTkwZTVkNzNlYWFkMGEyZjI1OTNmZTcyNWUyNGNkZApr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMwLTA3MjkxMDU0L2U0MGNmZjRhNzk5
MGU1ZDczZWFhZDBhMmYyNTkzZmU3MjVlMjRjZGQvdm1saW51ei0zLjE2LjAtcmM3LW5leHQt
MjAxNDA3MjgKCjIwMTQtMDctMjktMTM6MDg6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4J
NjAgU1VDQ0VTUwoK

--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc1-00010-gbd14ddc"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.16.0-rc1 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
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
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SGETMASK_SYSCALL is not set
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
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
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
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
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

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
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

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
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_PCAP is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_ARIZONA_HAPTICS=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_BEEPER=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
# CONFIG_GPIO_DA9055 is not set

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

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
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
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
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_AXP20X=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ARIZONA=y
# CONFIG_REGULATOR_AXP20X is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
# CONFIG_DRM_PTN3460 is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_OPL4_LIB_SEQ=y
CONFIG_SND_SBAWE_SEQ=y
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
# CONFIG_SND_AD1816A is not set
CONFIG_SND_AD1848=y
# CONFIG_SND_ALS100 is not set
CONFIG_SND_AZT1605=y
CONFIG_SND_AZT2316=y
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8328 is not set
CONFIG_SND_CMI8330=y
CONFIG_SND_CS4231=y
CONFIG_SND_CS4236=y
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
CONFIG_SND_SC6000=y
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=y
CONFIG_SND_GUSMAX=y
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_JAZZ16=y
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
CONFIG_SND_SB8=y
CONFIG_SND_SB16=y
CONFIG_SND_SBAWE=y
# CONFIG_SND_SB16_CSP is not set
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_MSND_PINNACLE=y
# CONFIG_SND_MSND_CLASSIC is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_SPI=y
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_ATMEL_SOC is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_SAI=y
CONFIG_SND_SOC_FSL_SSI=y
# CONFIG_SND_SOC_FSL_SPDIF is not set
CONFIG_SND_SOC_FSL_ESAI=y
CONFIG_SND_SOC_FSL_UTILS=y
# CONFIG_SND_SOC_IMX_AUDMUX is not set
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4554=y
# CONFIG_SND_SOC_AK4642 is not set
CONFIG_SND_SOC_AK5386=y
# CONFIG_SND_SOC_ALC5623 is not set
CONFIG_SND_SOC_CS42L52=y
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271 is not set
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
# CONFIG_SND_SOC_HDMI_CODEC is not set
CONFIG_SND_SOC_PCM1681=y
# CONFIG_SND_SOC_PCM1792A is not set
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
# CONFIG_SND_SOC_PCM512x_SPI is not set
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_STA350=y
# CONFIG_SND_SOC_TAS5086 is not set
CONFIG_SND_SOC_TLV320AIC3X=y
# CONFIG_SND_SOC_WM8510 is not set
CONFIG_SND_SOC_WM8523=y
# CONFIG_SND_SOC_WM8580 is not set
CONFIG_SND_SOC_WM8711=y
# CONFIG_SND_SOC_WM8728 is not set
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
CONFIG_SND_SIMPLE_CARD=y
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
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=y
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1343=y
CONFIG_RTC_DRV_DS1347=y
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y
# CONFIG_RTC_DRV_MCP795 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_DX_SEP is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
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
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACEPOINT_BENCHMARK=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
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
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
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
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

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
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
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
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
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

--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--/NkBOFFp2J2Af1nK--
