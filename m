Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJFFWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:22:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:34954 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaJFFWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,662,1406617200"; 
   d="scan'208";a="610090377"
Date: Mon, 6 Oct 2014 13:22:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [NFS] WARNING: CPU: 0 PID: 879 at fs/proc/generic.c:521
 remove_proc_entry+0x153/0x16b()
Message-ID: <20141006052236.GC28732@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eric,

FYI, we noticed the below changes on commit

65b38851a17472d31fec9019fc3a55b0802dab88 ("NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes")

+--------------------------------------------------+------------+------------+
|                                                  | db181ce011 | 65b38851a1 |
+--------------------------------------------------+------------+------------+
| boot_successes                                   | 49         | 16         |
| boot_failures                                    | 7          | 1          |
| BUG:kernel_test_crashed                          | 7          |            |
| WARNING:at_fs/proc/generic.c:remove_proc_entry() | 0          | 1          |
| backtrace:cleanup_net                            | 0          | 1          |
+--------------------------------------------------+------------+------------+


[   19.275971] trinity-c0: vm86 mode not supported on 64 bit kernel
[   19.361766] VFS: Warning: trinity-c0 using old stat() call. Recompile your binary.
[   19.400863] ------------[ cut here ]------------
[   19.400878] WARNING: CPU: 0 PID: 879 at fs/proc/generic.c:521 remove_proc_entry+0x153/0x16b()
[   19.400879] remove_proc_entry: removing non-empty directory 'fs/nfsfs', leaking at least 'volumes'
[   19.400882] Modules linked in:
[   19.400886] CPU: 0 PID: 879 Comm: kworker/u2:2 Not tainted 3.17.0-rc1 #1
[   19.400887] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   19.400894] Workqueue: netns cleanup_net
[   19.400896]  0000000000000000 ffff8800104d3c80 ffffffff819d6c7b ffff8800104d3cc8
[   19.400898]  ffff8800104d3cb8 ffffffff810e8810 ffffffff8124ffd2 ffff8800127c2880
[   19.400899]  ffffffff81d1786c ffff8800126eae30 0000000000000005 ffff8800104d3d20
[   19.400900] Call Trace:
[   19.400905]  [<ffffffff819d6c7b>] dump_stack+0x4d/0x66
[   19.400910]  [<ffffffff810e8810>] warn_slowpath_common+0x7f/0x98
[   19.400912]  [<ffffffff8124ffd2>] ? remove_proc_entry+0x153/0x16b
[   19.400914]  [<ffffffff810e8871>] warn_slowpath_fmt+0x48/0x50
[   19.400919]  [<ffffffff8124b8dd>] ? proc_entry_rundown+0x55/0x82
[   19.400921]  [<ffffffff8124ffd2>] remove_proc_entry+0x153/0x16b
[   19.400927]  [<ffffffff81309766>] nfs_fs_proc_net_exit+0x75/0x78
[   19.400934]  [<ffffffff8130e4ac>] nfs_net_exit+0x12/0x1d
[   19.400936]  [<ffffffff818b7aa2>] ops_exit_list+0x42/0x53
[   19.400938]  [<ffffffff818b8363>] cleanup_net+0xfe/0x19e
[   19.400942]  [<ffffffff810fc6cf>] process_one_work+0x1c9/0x378
[   19.400946]  [<ffffffff810fd20e>] worker_thread+0x2c2/0x3b8
[   19.400948]  [<ffffffff810fcf4c>] ? rescuer_thread+0x25b/0x25b
[   19.400950]  [<ffffffff81100f28>] kthread+0xe4/0xec
[   19.400952]  [<ffffffff81100e44>] ? kthread_create_on_node+0x18c/0x18c
[   19.400955]  [<ffffffff819de03c>] ret_from_fork+0x7c/0xb0
[   19.400957]  [<ffffffff81100e44>] ? kthread_create_on_node+0x18c/0x18c
[   19.400958] ---[ end trace d172d68987077a95 ]---
[   19.796662] VFS: Warning: trinity-c0 using old stat() call. Recompile your binary.

Thanks,
Fengguang

--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc1 (kbuild@athens) (gcc version 4.9.1 =
(Debian 4.9.1-11) ) #1 SMP Thu Oct 2 07:54:34 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-ia32-26/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-f71529722cf8c209a4e=
71c1000f0f8b8e74f674f-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/=
f71529722cf8c209a4e71c1000f0f8b8e74f674f/vmlinuz-3.17.0-rc1 kconfig=3Dx86_6=
4-lkp commit=3Df71529722cf8c209a4e71c1000f0f8b8e74f674f branch=3Dat91/at91-=
3.18-soc3 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-kbui=
ld-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86_64-lkp/f71529722cf8c209a4e7=
1c1000f0f8b8e74f674f/0 ip=3D::::vm-kbuild-yocto-ia32-26::dhcp earlyprintk=
=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_st=
all_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=
=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02465000, 0x02465fff] PGTABLE
[    0.000000] BRK [0x02466000, 0x02466fff] PGTABLE
[    0.000000] BRK [0x02467000, 0x02467fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13800000-0x139fffff]
[    0.000000]  [mem 0x13800000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13ffdfff]
[    0.000000]  [mem 0x13a00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02468000, 0x02468fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13b5b000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffa000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff2001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s81856 r8192=
 d20544 u2097152
[    0.000000] pcpu-alloc: s81856 r8192 d20544 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-ia32-26/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-f71529722cf8=
c209a4e71c1000f0f8b8e74f674f-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_=
64-lkp/f71529722cf8c209a4e71c1000f0f8b8e74f674f/vmlinuz-3.17.0-rc1 kconfig=
=3Dx86_64-lkp commit=3Df71529722cf8c209a4e71c1000f0f8b8e74f674f branch=3Dat=
91/at91-3.18-soc3 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result=
/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86_64-lkp/f71529722cf8=
c209a4e71c1000f0f8b8e74f674f/0 ip=3D::::vm-kbuild-yocto-ia32-26::dhcp early=
printk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_=
cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpani=
c oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 295060K/327280K available (10128K kernel code, 1403K=
 rwdata, 4352K rodata, 1424K init, 1620K bss, 32220K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc1 (kbuild@athens) (gcc version 4.9.1 =
(Debian 4.9.1-11) ) #1 SMP Thu Oct 2 07:54:34 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-ia32-26/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-f71529722cf8c209a4e=
71c1000f0f8b8e74f674f-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/=
f71529722cf8c209a4e71c1000f0f8b8e74f674f/vmlinuz-3.17.0-rc1 kconfig=3Dx86_6=
4-lkp commit=3Df71529722cf8c209a4e71c1000f0f8b8e74f674f branch=3Dat91/at91-=
3.18-soc3 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result/vm-kbui=
ld-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86_64-lkp/f71529722cf8c209a4e7=
1c1000f0f8b8e74f674f/0 ip=3D::::vm-kbuild-yocto-ia32-26::dhcp earlyprintk=
=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_st=
all_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=
=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02465000, 0x02465fff] PGTABLE
[    0.000000] BRK [0x02466000, 0x02466fff] PGTABLE
[    0.000000] BRK [0x02467000, 0x02467fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13800000-0x139fffff]
[    0.000000]  [mem 0x13800000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13ffdfff]
[    0.000000]  [mem 0x13a00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02468000, 0x02468fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13b5b000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffa000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff2001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880013800000 s81856 r8192=
 d20544 u2097152
[    0.000000] pcpu-alloc: s81856 r8192 d20544 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-ia32-26/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-f71529722cf8=
c209a4e71c1000f0f8b8e74f674f-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_=
64-lkp/f71529722cf8c209a4e71c1000f0f8b8e74f674f/vmlinuz-3.17.0-rc1 kconfig=
=3Dx86_64-lkp commit=3Df71529722cf8c209a4e71c1000f0f8b8e74f674f branch=3Dat=
91/at91-3.18-soc3 root=3D/dev/ram0 max_uptime=3D18000 RESULT_ROOT=3D/result=
/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86_64-lkp/f71529722cf8=
c209a4e71c1000f0f8b8e74f674f/0 ip=3D::::vm-kbuild-yocto-ia32-26::dhcp early=
printk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_=
cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpani=
c oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 295060K/327280K available (10128K kernel code, 1403K=
 rwdata, 4352K rodata, 1424K init, 1620K bss, 32220K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.90 Bogo=
MIPS (lpj=3D10773808)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008038] ACPI: Core revision 20140724
[    0.013589] ACPI: All ACPI Tables successfully acquired
[    0.016036] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.017960] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.019911] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.020032] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.022160] Initializing cgroup subsys memory
[    0.024033] Initializing cgroup subsys devices
[    0.025492] Initializing cgroup subsys freezer
[    0.026860] Initializing cgroup subsys blkio
[    0.028030] Initializing cgroup subsys perf_event
[    0.029633] Initializing cgroup subsys hugetlb
[    0.032157] mce: CPU supports 10 MCE banks
[    0.033650] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033650] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.081829] Freeing SMP alternatives memory: 40K (ffffffff822c4000 - fff=
fffff822ce000)
[    0.092475] ftrace: allocating 39706 entries in 156 pages
[    0.108130] Getting VERSION: 50014
[    0.109454] Getting VERSION: 50014
[    0.112024] Getting ID: 0
[    0.113187] Getting ID: ff000000
[    0.114488] Getting LVT0: 8700
[    0.115664] Getting LVT1: 8400
[    0.120051] enabled ExtINT on CPU#0
[    0.122357] ENABLING IO-APIC IRQs
[    0.123680] init IO_APIC IRQs
[    0.124017]  apic 0 pin 0 not connected
[    0.128022] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.130583] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.132045] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.136043] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.138717] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.140038] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.144039] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.146562] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.148045] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.152045] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.154617] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.156048] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.160049] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.164042] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.168008] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.170567]  apic 0 pin 16 not connected
[    0.171861]  apic 0 pin 17 not connected
[    0.172011]  apic 0 pin 18 not connected
[    0.173299]  apic 0 pin 19 not connected
[    0.176018]  apic 0 pin 20 not connected
[    0.177337]  apic 0 pin 21 not connected
[    0.180014]  apic 0 pin 22 not connected
[    0.181358]  apic 0 pin 23 not connected
[    0.182880] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.184012] smpboot: CPU0: Intel Westmere E56xx/L56xx/X56xx (Nehalem-C) =
(fam: 06, model: 2c, stepping: 01)
[    0.190421] Using local APIC timer interrupts.
[    0.190421] calibrating APIC timer ...
[    0.196000] ... lapic delta =3D 9501264
[    0.196000] ... PM-Timer delta =3D 544179
[    0.196000] APIC calibration not consistent with PM-Timer: 152ms instead=
 of 100ms
[    0.196000] APIC delta adjusted to PM-Timer: 6249810 (9501264)
[    0.196000] TSC delta adjusted to PM-Timer: 269349534 (409478202)
[    0.196000] ..... delta 6249810
[    0.196000] ..... mult: 268427295
[    0.196000] ..... calibration result: 3999878
[    0.196000] ..... CPU clock speed is 2693.1981 MHz.
[    0.196000] ..... host bus clock speed is 999.3878 MHz.
[    0.196098] Performance Events: unsupported p6 CPU model 44 no PMU drive=
r, software events only.
[    0.205974] x86: Booted up 1 node, 1 CPUs
[    0.208010] smpboot: Total of 1 processors activated (5386.90 BogoMIPS)
[    0.210234] devtmpfs: initialized
[    0.223184] xor: measuring software checksum speed
[    0.264024]    prefetch64-sse:   150.000 MB/sec
[    0.308020]    generic_sse:   157.000 MB/sec
[    0.312014] xor: using function: generic_sse (157.000 MB/sec)
[    0.316195] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.318409] NET: Registered protocol family 16
[    0.321056] cpuidle: using governor ladder
[    0.324113] cpuidle: using governor menu
[    0.332724] ACPI: bus type PCI registered
[    0.334205] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.336322] PCI: Using configuration type 1 for base access
[    0.416012] raid6: sse2x1    2747 MB/s
[    0.488010] raid6: sse2x2    6271 MB/s
[    0.556019] raid6: sse2x4    4375 MB/s
[    0.557278] raid6: using algorithm sse2x2 (6271 MB/s)
[    0.558692] raid6: using ssse3x2 recovery algorithm
[    0.575170] ACPI: Added _OSI(Module Device)
[    0.576019] ACPI: Added _OSI(Processor Device)
[    0.577445] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.580027] ACPI: Added _OSI(Processor Aggregator Device)
[    0.586350] ACPI: Interpreter enabled
[    0.588110] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    0.591020] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    0.596249] ACPI: (supports S0 S3 S4 S5)
[    0.597545] ACPI: Using IOAPIC for interrupt routing
[    0.600269] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.612541] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.614120] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.620034] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.624235] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.628655] acpiphp: Slot [3] registered
[    0.632050] acpiphp: Slot [4] registered
[    0.633285] acpiphp: Slot [5] registered
[    0.636196] acpiphp: Slot [6] registered
[    0.640082] acpiphp: Slot [7] registered
[    0.644144] acpiphp: Slot [8] registered
[    0.645395] acpiphp: Slot [9] registered
[    0.648141] acpiphp: Slot [10] registered
[    0.652083] acpiphp: Slot [11] registered
[    0.653430] acpiphp: Slot [12] registered
[    0.656197] acpiphp: Slot [13] registered
[    0.660077] acpiphp: Slot [14] registered
[    0.664069] acpiphp: Slot [15] registered
[    0.665559] acpiphp: Slot [24] registered
[    0.668231] acpiphp: Slot [25] registered
[    0.672086] acpiphp: Slot [26] registered
[    0.673357] acpiphp: Slot [27] registered
[    0.676217] acpiphp: Slot [28] registered
[    0.680084] acpiphp: Slot [29] registered
[    0.684170] acpiphp: Slot [30] registered
[    0.685638] acpiphp: Slot [31] registered
[    0.688047] PCI host bridge to bus 0000:00
[    0.692029] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.693485] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.696184] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.704122] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.708147] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.710956] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.712613] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.716290] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.721341] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.724056] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.725829] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.727574] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.728009] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.732115] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.734069] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.736021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.738542] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.744950] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.748091] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.759275] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.761155] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.765519] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.768717] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.776720] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.779485] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.781478] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.785415] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.795191] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.797460] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.800700] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.809941] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.812678] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.816020] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.825338] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.832714] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.837436] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.851155] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.856020] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.858721] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.869897] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.872676] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.875464] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.886748] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.892399] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.902039] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.904226] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.912444] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.914526] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.917117] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.919280] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.920508] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.924025] vgaarb: loaded
[    0.925065] vgaarb: bridge control possible 0000:00:02.0
[    0.928425] SCSI subsystem initialized
[    0.929756] libata version 3.00 loaded.
[    0.931088] ACPI: bus type USB registered
[    0.932243] usbcore: registered new interface driver usbfs
[    0.936118] usbcore: registered new interface driver hub
[    0.937630] usbcore: registered new device driver usb
[    0.940093] pps_core: LinuxPPS API ver. 1 registered
[    0.941430] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.944144] PTP clock support registered
[    0.948378] EDAC MC: Ver: 3.0.0
[    0.952448] PCI: Using ACPI for IRQ routing
[    0.953690] PCI: pci_cache_line_size set to 64 bytes
[    0.956276] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.957789] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.964310] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.968151] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.969859] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.976304] Switched to clocksource kvm-clock
[    1.021015] pnp: PnP ACPI init
[    1.022243] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.024098] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.036226] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.038029] pnp 00:03: [dma 2]
[    1.039223] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.041060] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.042864] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.044704] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.057006] pnp: PnP ACPI: found 7 devices
[    1.073229] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.074908] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.086469] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.088277] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.090346] NET: Registered protocol family 2
[    1.092063] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.093777] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[    1.095509] TCP: Hash tables configured (established 4096 bind 4096)
[    1.101774] TCP: reno registered
[    1.102877] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.104477] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.116365] NET: Registered protocol family 1
[    1.118052] RPC: Registered named UNIX socket transport module.
[    1.119540] RPC: Registered udp transport module.
[    1.120966] RPC: Registered tcp transport module.
[    1.122300] RPC: Registered tcp NFSv4.1 backchannel transport module
--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--ALfTUftag+2gvp1h--
