Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaCaAkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:40:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:27100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaCaAkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,761,1389772800"; 
   d="log'?scan'208";a="503184544"
Date: Mon, 31 Mar 2014 08:38:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [do_xor_speed] WARNING: CPU: 0 PID: 1 at init/main.c:708
 do_one_initcall()
Message-ID: <20140331003825.GA11782@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.open-osd.org/linux-open-osd.git bidi-mq

commit 992e60a78e1c2c6996fd55c5fb11344ad1a4c189
Author:     Boaz Harrosh <bharrosh@panasas.com>
AuthorDate: Thu Jul 19 15:22:37 2012 +0300
Commit:     Boaz Harrosh <boaz@plexistor.com>
CommitDate: Sun Mar 30 16:03:29 2014 +0300

    RFC: do_xor_speed Broken on UML do to jiffies
    
[    0.413369]    generic_sse:    70.500 MB/sec
[    0.415084] xor: using function: generic_sse (70.500 MB/sec)
[    0.416734] ------------[ cut here ]------------
[    0.418634] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x174/0x18b()
[    0.420050] initcall calibrate_xor_blocks+0x0/0x1cc returned with preemption imbalance 
[    0.423371] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc8-00108-g992e60a #38
[    0.426451] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.426700]  0000000000000000 ffff880000155d80 ffffffff823bd1f9 ffff880000155dc8
[    0.432082]  ffff880000155db8 ffffffff81084d37 ffffffff84684565 ffffffff846b9bc6
[    0.435342]  0000000000000000 0000000000000000 0000000000000000 ffff880000155e18
[    0.438786] Call Trace:
[    0.439766]  [<ffffffff823bd1f9>] dump_stack+0xa1/0x102
[    0.440059]  [<ffffffff81084d37>] warn_slowpath_common+0x93/0xc1
[    0.443380]  [<ffffffff84684565>] ? do_one_initcall+0x174/0x18b
[    0.446707]  [<ffffffff846b9bc6>] ? do_xor_speed+0x12d/0x12d
[    0.448950]  [<ffffffff81084df0>] warn_slowpath_fmt+0x55/0x5e
[    0.450041]  [<ffffffff846b9bc6>] ? do_xor_speed+0x12d/0x12d
[    0.453372]  [<ffffffff84684565>] do_one_initcall+0x174/0x18b
[    0.455645]  [<ffffffff846848d7>] kernel_init_freeable+0x35b/0x46d
[    0.456706]  [<ffffffff84683992>] ? do_early_param+0xd7/0xd7
[    0.460044]  [<ffffffff8239ea58>] ? rest_init+0x15c/0x15c
[    0.463372]  [<ffffffff8239ea68>] kernel_init+0x10/0x181
[    0.465550]  [<ffffffff823d890c>] ret_from_fork+0x7c/0xb0
[    0.466712]  [<ffffffff8239ea58>] ? rest_init+0x15c/0x15c
[    0.470089] ---[ end trace 5d56b560c4cace50 ]---
[    0.471938] prandom: seed boundary self test passed

git bisect start 80b612bf90a8ebdd09dff5695d0357aeb78f963e 66e810ec9fff9cf5622a8326805ef310fd5b98e7 --
git bisect good ad95c966acc03bc906dff6b875a545379680f264  # 03:08     20+      0  Merge remote-tracking branch 'linus/master' into bidi-mq
git bisect  bad 992e60a78e1c2c6996fd55c5fb11344ad1a4c189  # 03:09      0-      1  RFC: do_xor_speed Broken on UML do to jiffies
# first bad commit: [992e60a78e1c2c6996fd55c5fb11344ad1a4c189] RFC: do_xor_speed Broken on UML do to jiffies
git bisect good ad95c966acc03bc906dff6b875a545379680f264  # 03:20     60+      0  Merge remote-tracking branch 'linus/master' into bidi-mq
git bisect  bad 80b612bf90a8ebdd09dff5695d0357aeb78f963e  # 03:20      0-     19  {TODO} bsg: remove bogus (and fatal) check in bsg_register_queue
git bisect good 981e893ed537cbaa08f8089d480db4165e6d71c0  # 03:31     60+      0  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 201544be8c37dffbf069bb5fc9edb5674f8c1754  # 03:36     60+      0  Add linux-next specific files for 20140328


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
	-kernel $kernel
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Fengguang

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-jaketown-12:20140331031615:x86_64-randconfig-s4-03291922::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc8-00108-g992e60a (kbuild@snb) (gcc ve=
rsion 4.8.2 (Debian 4.8.2-17) ) #38 SMP PREEMPT Mon Mar 31 02:51:13 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s4-03291922/open-osd:bid=
i-mq:992e60a78e1c2c6996fd55c5fb11344ad1a4c189:bisect-linux5/.vmlinuz-992e60=
a78e1c2c6996fd55c5fb11344ad1a4c189-20140331030821-5-jaketown branch=3Dopen-=
osd/bidi-mq BOOT_IMAGE=3D/kernel/x86_64-randconfig-s4-03291922/992e60a78e1c=
2c6996fd55c5fb11344ad1a4c189/vmlinuz-3.14.0-rc8-00108-g992e60a drbd.minor_c=
ount=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05c3f000, 0x05c3ffff] PGTABLE
[    0.000000] BRK [0x05c40000, 0x05c40fff] PGTABLE
[    0.000000] BRK [0x05c41000, 0x05c41fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x05c42000, 0x05c42fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x05c43000, 0x05c43fff] PGTABLE
[    0.000000] BRK [0x05c44000, 0x05c44fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fcc1000-0x0fce5fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fc41001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ee0000=
0-ffff88000f1fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57b000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000f600000 s1916736 r0=
 d20672 u2097152
[    0.000000] pcpu-alloc: s1916736 r0 d20672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fc41001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f60dc80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s4-03291922/open-=
osd:bidi-mq:992e60a78e1c2c6996fd55c5fb11344ad1a4c189:bisect-linux5/.vmlinuz=
-992e60a78e1c2c6996fd55c5fb11344ad1a4c189-20140331030821-5-jaketown branch=
=3Dopen-osd/bidi-mq BOOT_IMAGE=3D/kernel/x86_64-randconfig-s4-03291922/992e=
60a78e1c2c6996fd55c5fb11344ad1a4c189/vmlinuz-3.14.0-rc8-00108-g992e60a drbd=
=2Eminor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 171024K/261744K available (20329K kernel code, 21172=
K rwdata, 10960K rodata, 3524K init, 20576K bss, 90720K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:524544 nr_irqs:56 16
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
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1599.966 MHz processor
[    0.009999] Calibrating delay loop (skipped) preset value.. 3201.26 Bogo=
MIPS (lpj=3D5333220)
[    0.011158] pid_max: default: 4096 minimum: 301
[    0.013030] ACPI: Core revision 20131218
[    0.033333] ACPI: All ACPI Tables successfully acquired
[    0.035147] Security Framework initialized
[    0.036700] SELinux:  Initializing.
[    0.038337] SELinux:  Starting in enforcing mode
[    0.041182] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.044177] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.046758] Mount-cache hash table entries: 256
[    0.051365] Initializing cgroup subsys debug
[    0.053049] Initializing cgroup subsys devices
[    0.056695] Initializing cgroup subsys freezer
[    0.058530] Initializing cgroup subsys net_cls
[    0.060334] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.060334] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.060334] tlb_flushall_shift: 6
[    0.066797] debug: unmapping init [mem 0xffffffff84820000-0xffffffff8482=
5fff]
[    0.083911] Getting VERSION: 50014
[    0.086724] Getting VERSION: 50014
[    0.090049] Getting ID: 0
[    0.093408] Getting ID: ff000000
[    0.096723] Getting LVT0: 8700
[    0.098037] Getting LVT1: 8400
[    0.100213] enabled ExtINT on CPU#0
[    0.111529] ENABLING IO-APIC IRQs
[    0.113379] init IO_APIC IRQs
[    0.114985]  apic 0 pin 0 not connected
[    0.116769] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.120134] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.123463] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.126786] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.130116] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.133452] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.136789] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.140112] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.146814] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.150127] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.153459] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.156786] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.160109] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.163441] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.167853] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.173356]  apic 0 pin 16 not connected
[    0.176689]  apic 0 pin 17 not connected
[    0.180023]  apic 0 pin 18 not connected
[    0.183356]  apic 0 pin 19 not connected
[    0.186693]  apic 0 pin 20 not connected
[    0.190025]  apic 0 pin 21 not connected
[    0.193357]  apic 0 pin 22 not connected
[    0.196691]  apic 0 pin 23 not connected
[    0.202100] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.203360] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.213358] Using local APIC timer interrupts.
[    0.213358] calibrating APIC timer ...
[    0.219999] ... lapic delta =3D 6250373
[    0.219999] ... PM-Timer delta =3D 357984
[    0.219999] ... PM-Timer result ok
[    0.219999] ..... delta 6250373
[    0.219999] ..... mult: 268451503
[    0.219999] ..... calibration result: 3333532
[    0.219999] ..... CPU clock speed is 1600.0805 MHz.
[    0.219999] ..... host bus clock speed is 1000.0532 MHz.
[    0.220490] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.250613] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.258250] x86: Booting SMP configuration:
[    0.260029] .... node  #0, CPUs:      #1
[    0.009999] kvm-clock: cpu 1, msr 0:fc41041, secondary cpu clock
[    0.009999] masked ExtINT on CPU#1
[    0.283854] KVM setup async PF for cpu 1
[    0.283959] x86: Booted up 1 node, 2 CPUs
[    0.284001] ----------------
[    0.284003] | NMI testsuite:
[    0.284005] --------------------
[    0.286666]   remote IPI:
[    0.286666] kvm-stealtime: cpu 1, msr f80dc80
[    0.298908]   ok  |
[    0.300148]    local IPI:  ok  |
[    0.310173] --------------------
[    0.311447] Good, all   2 testcases passed! |
[    0.313351] ---------------------------------
[    0.315136] smpboot: Total of 2 processors activated (6402.52 BogoMIPS)
[    0.363045] gcov: version magic: 0x3430382a
[    0.386376] xor: measuring software checksum speed
[    0.400047]    prefetch64-sse:    57.300 MB/sec
[    0.413369]    generic_sse:    70.500 MB/sec
[    0.415084] xor: using function: generic_sse (70.500 MB/sec)
[    0.416734] ------------[ cut here ]------------
[    0.418634] WARNING: CPU: 0 PID: 1 at init/main.c:708 do_one_initcall+0x=
174/0x18b()
[    0.420050] initcall calibrate_xor_blocks+0x0/0x1cc returned with preemp=
tion imbalance=20
[    0.423371] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc8-00108-g=
992e60a #38
[    0.426451] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.426700]  0000000000000000 ffff880000155d80 ffffffff823bd1f9 ffff8800=
00155dc8
[    0.432082]  ffff880000155db8 ffffffff81084d37 ffffffff84684565 ffffffff=
846b9bc6
[    0.435342]  0000000000000000 0000000000000000 0000000000000000 ffff8800=
00155e18
[    0.438786] Call Trace:
[    0.439766]  [<ffffffff823bd1f9>] dump_stack+0xa1/0x102
[    0.440059]  [<ffffffff81084d37>] warn_slowpath_common+0x93/0xc1
[    0.443380]  [<ffffffff84684565>] ? do_one_initcall+0x174/0x18b
[    0.446707]  [<ffffffff846b9bc6>] ? do_xor_speed+0x12d/0x12d
[    0.448950]  [<ffffffff81084df0>] warn_slowpath_fmt+0x55/0x5e
[    0.450041]  [<ffffffff846b9bc6>] ? do_xor_speed+0x12d/0x12d
[    0.453372]  [<ffffffff84684565>] do_one_initcall+0x174/0x18b
[    0.455645]  [<ffffffff846848d7>] kernel_init_freeable+0x35b/0x46d
[    0.456706]  [<ffffffff84683992>] ? do_early_param+0xd7/0xd7
[    0.460044]  [<ffffffff8239ea58>] ? rest_init+0x15c/0x15c
[    0.463372]  [<ffffffff8239ea68>] kernel_init+0x10/0x181
[    0.465550]  [<ffffffff823d890c>] ret_from_fork+0x7c/0xb0
[    0.466712]  [<ffffffff8239ea58>] ? rest_init+0x15c/0x15c
[    0.470089] ---[ end trace 5d56b560c4cace50 ]---
[    0.471938] prandom: seed boundary self test passed
[    0.475263] prandom: 100 self tests passed
[    0.476709] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.480032] pinctrl core: initialized pinctrl subsystem
[    0.484638] NET: Registered protocol family 16
[    0.491059] cpuidle: using governor ladder
[    0.492767] cpuidle: using governor menu
[    0.496750] ACPI: bus type PCI registered
[    0.499361] PCI: Using configuration type 1 for base access
[    0.598104] bio: create slab <bio-0> at 0
[    0.660058] raid6: sse2x1     607 MB/s
[    0.716726] raid6: sse2x2     813 MB/s
[    0.773369] raid6: sse2x4     827 MB/s
[    0.775065] raid6: using algorithm sse2x4 (827 MB/s)
[    0.776699] raid6: using intx1 recovery algorithm
[    0.780145] ACPI: Added _OSI(Module Device)
[    0.782126] ACPI: Added _OSI(Processor Device)
[    0.783370] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.785575] ACPI: Added _OSI(Processor Aggregator Device)
[    0.837314] ACPI: Interpreter enabled
[    0.838991] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.842474] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.846844] ACPI: (supports S0 S3 S5)
[    0.848424] ACPI: Using IOAPIC for interrupt routing
[    0.850389] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.936936] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.939564] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.940164] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.947412] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.953566] PCI host bridge to bus 0000:00
[    0.955248] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.956709] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.960039] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.962582] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.963372] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.966954] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.975049] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.981688] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.993375] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.002007] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.005157] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.006846] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.015188] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.022198] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.030205] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.060192] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.068682] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.073395] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.080057] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.100037] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.105776] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.110040] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.132982] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.137048] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.141286] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.145275] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.148181] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.156260] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.166439] SCSI subsystem initialized
[    1.167561] libata version 3.00 loaded.
[    1.171087] ACPI: bus type USB registered
[    1.173828] usbcore: registered new interface driver usbfs
[    1.176924] usbcore: registered new interface driver hub
[    1.180493] usbcore: registered new device driver usb
[    1.183659] pps_core: LinuxPPS API ver. 1 registered
[    1.185496] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.186785] PTP clock support registered
[    1.193661] PCI: Using ACPI for IRQ routing
[    1.195536] PCI: pci_cache_line_size set to 64 bytes
[    1.197326] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.200059] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.209870] cfg80211: Calling CRDA to update world regulatory domain
[    1.213657] NetLabel: Initializing
[    1.215032] NetLabel:  domain hash size =3D 128
[    1.216693] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.219185] NetLabel:  unlabeled traffic allowed by default
[    1.225308] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.227384] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.234927] Switched to clocksource kvm-clock
[    1.237116] pnp: PnP ACPI init
[    1.238929] ACPI: bus type PNP registered
[    1.240929] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.245273] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.248570] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.252471] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.255564] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.259769] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.263103] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.266597] pnp 00:03: [dma 2]
[    1.268446] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.271772] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.275682] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.279143] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.283207] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.288878] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.293242] pnp: PnP ACPI: found 7 devices
[    1.295186] ACPI: bus type PNP unregistered
[    1.307216] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.309625] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.312138] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.314803] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.317982] NET: Registered protocol family 2
[    1.324699] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.328587] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    1.332106] TCP: Hash tables configured (established 2048 bind 2048)
[    1.337333] TCP: reno registered
[    1.338820] UDP hash table entries: 128 (order: 2, 24576 bytes)
[    1.341485] UDP-Lite hash table entries: 128 (order: 2, 24576 bytes)
[    1.345510] NET: Registered protocol family 1
[    1.362005] RPC: Registered named UNIX socket transport module.
[    1.364510] RPC: Registered udp transport module.
[    1.366482] RPC: Registered tcp transport module.
[    1.368403] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.371112] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.383158] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.389238] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.393198] pci 0000:00:02.0: Boot video device
[    1.398967] PCI: CLS 0 bytes, default 64
[    1.430866] Unpacking initramfs...
[    2.373290] debug: unmapping init [mem 0xffff88000fce6000-0xffff88000ffe=
ffff]
[    2.381684] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.386387] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.389123] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.404749] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    2.408477] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    2.413219] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    2.417345] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.419860] PCLMULQDQ-NI instructions are not detected.
[    2.422005] AVX or AES-NI instructions are not detected.
[    2.424184] AVX instructions are not detected.
[    2.426007] AVX instructions are not detected.
[    2.427967] AVX instructions are not detected.
[    2.429812] AVX2 or AES-NI instructions are not detected.
[    2.431969] AVX2 instructions are not detected.
[    2.439779] futex hash table entries: 16 (order: -1, 2048 bytes)
[    2.442288] Initialise system trusted keyring
[    2.444502] audit: initializing netlink subsys (disabled)
[    2.447040] audit: type=3D2000 audit(1396206869.940:1): initialized
[    3.386440] tsc: Refined TSC clocksource calibration: 1599.924 MHz
[    7.849531] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    7.889974] VFS: Disk quotas dquot_6.5.2
[    7.892749] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.908368] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    7.942067] NFS: Registering the id_resolver key type
[    7.944490] Key type id_resolver registered
[    7.946561] Key type id_legacy registered
[    7.948331] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.969068] Key type cifs.idmap registered
[    7.972446] NTFS driver 2.1.30 [Flags: R/W].
[    7.976007] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    7.979564] ROMFS MTD (C) 2007 Red Hat, Inc.
[    7.983452] QNX4 filesystem 0.2.3 registered.
[    7.986238] QNX6 filesystem 1.0.0 registered.
[    7.990962] JFS: nTxBlock =3D 1336, nTxLock =3D 10689
[    8.005250] SGI XFS with security attributes, large block/inode numbers,=
 no debug enabled
[    8.030789] 9p: Installing v9fs 9p2000 file system support
[    8.035499] NILFS version 2 loaded
[    8.037185] BeFS version: 0.9.3
[    8.042736] ocfs2 stack glue: unable to register sysctl
[    8.046397] ocfs2: Registered cluster interface o2cb
[    8.051978] OCFS2 User DLM kernel interface loaded
[    8.067615] GFS2 installed
[    8.072218] SELinux:  Registering netfilter hooks
[    8.127527] NET: Registered protocol family 38
[    8.129932] Key type asymmetric registered
[    8.134717] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    8.150908] io scheduler noop registered (default)
[    8.153274] io scheduler deadline registered
[    8.170647] test_string_helpers: Running tests...
[    8.177651] xz_dec_test: module loaded
[    8.179497] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    8.184639] rbtree testing -> 33861 cycles
[   10.451847] augmented rbtree testing -> 56462 cycles
[   14.234801] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[   14.241096] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[   14.254099] vmlfb: initializing
[   14.259511] Could not find Carillo Ranch MCH device.
[   14.262157] no IO addresses supplied
[   14.268348] hgafb: HGA card not detected.
[   14.273539] hgafb: probe of hgafb.0 failed with error -22
[   14.284387] usbcore: registered new interface driver smscufx
[   14.291872] ipmi message handler version 39.2
[   14.294107] IPMI System Interface driver.
[   14.300634] ipmi_si: Adding default-specified kcs state machine
[   14.307503] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   14.316111] ipmi_si: Interface detection failed
[   14.323821] ipmi_si: Adding default-specified smic state machine
[   14.326536] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   14.333861] ipmi_si: Interface detection failed
[   14.345730] ipmi_si: Adding default-specified bt state machine
[   14.349937] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   14.354152] ipmi_si: Interface detection failed
[   14.366428] ipmi_si: Unable to find any System Interface(s)
[   14.369097] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   14.376365] IPMI poweroff: Unable to register powercycle sysctl
[   14.394232] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   14.401527] ACPI: Power Button [PWRF]
[   14.415918] GHES: HEST is not enabled!
[   14.417662] ERST DBG: ERST support is disabled.
[   14.424521] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   14.758583] MOXA Intellio family driver version 6.0k
[   14.765299] RocketPort device driver module, version 2.09, 12-June-2003
[   14.772515] No rocketport ports found; unloading driver
[   14.774775] SyncLink GT
[   14.777383] SyncLink GT, tty major#246
[   14.779070] SyncLink GT no devices found
[   14.784876] SyncLink MultiPort driver $Revision: 4.38 $
[   14.881559] SyncLink MultiPort driver $Revision: 4.38 $, tty major#245
[   14.890091] lp: driver loaded but no devices found
[   14.896312] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   14.899135] ac.o: No PCI boards found.
[   14.907811] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   14.916574] Non-volatile memory driver v1.3
[   14.918358] ppdev: user-space parallel port driver
[   14.924562] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   14.926864] smapi::smapi_init, ERROR invalid usSmapiID
[   14.933133] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   14.940986] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   14.948071] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   14.982310] loop: module loaded
[   14.992953] MM: desc_per_page =3D 128
[   14.997877] nbd: registered device at major 43
[   15.151575] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[   15.154237] drbd: built-in
[   15.155482] drbd: registered as block device major 147
[   15.164065] rbd: loaded
[   15.165146] mtip32xx Version 1.3.0
[   15.171892] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   15.174947] dummy-irq: no IRQ given.  Use irq=3DN
[   15.181457] lkdtm: No crash points registered, enable through debugfs
[   15.188925] Phantom Linux Driver, version n0.9.8, init OK
[   15.196407] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   15.204391] c2port c2port0: C2 port uc added
[   15.206201] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   15.214636] Guest personality initialized and is inactive
[   15.221606] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[   15.228486] Initialized host personality
[   15.237572] usbcore: registered new interface driver viperboard
[   15.244270] Uniform Multi-Platform E-IDE driver
[   15.246599] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   15.254210] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[   15.262781]     ide0: BM-DMA at 0xc040-0xc047
[   15.264769]     ide1: BM-DMA at 0xc048-0xc04f
[   15.266635] Probing IDE interface ide0...
[   15.810805] Probing IDE interface ide1...
[   16.513526] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   17.157579] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   17.160902] hdc: MWDMA2 mode selected
[   17.163661] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   17.165918] ide1 at 0x170-0x177,0x376 on irq 15
[   17.184031] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   17.192536] ide-gd driver 1.18
[   17.201411] Loading iSCSI transport class v2.0-870.
[   17.213102] osst :I: Tape driver with OnStream support version 0.99.4
[   17.213102] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   17.227881] SCSI Media Changer driver v0.25=20
[   17.230507] osd: LOADED open-osd 0.2.1
[   17.248022] HSI/SSI char device loaded
[   17.258175] arcnet loaded.
[   17.259485] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   17.262803] arcnet: raw mode (`r') encapsulation support loaded.
[   17.265366] arcnet: cap mode (`c') encapsulation support loaded.
[   17.268359] arcnet: COM90xx chipset support
[   17.663935] S3: No ARCnet cards found.
[   17.665832] arcnet: RIM I (entirely mem-mapped) support
[   17.668240] E-mail me if you actually test the RIM I driver, please!
[   17.671175] Given: node 00h, shmem 0h, irq 0
[   17.673049] No autoprobe for RIM I; you must specify the shmem and irq!
[   17.689597] arcnet: COM20020 PCI support
[   17.692205] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[   17.703796] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[   17.711836] vcan: Virtual CAN interface driver
[   17.717545] slcan: serial line CAN interface driver
[   17.721196] slcan: 10 dynamic interface channels.
[   17.725244] CAN device driver interface
[   17.730063] usbcore: registered new interface driver ems_usb
[   17.737703] usbcore: registered new interface driver esd_usb2
[   17.742847] usbcore: registered new interface driver usb_8dev
[   17.748444] sja1000 CAN netdevice driver
[   17.752521] sja1000_isa: insufficient parameters supplied
[   17.760484] cc770: CAN netdevice driver
[   17.765020] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[   17.773445] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   17.778091] Copyright (c) 2007 Atheros Corporation.
[   17.786639] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[   17.809393] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[   17.822780] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   17.829643] sky2: driver version 1.30
[   17.849298] myri10ge: Version 1.5.3-1.534
[   17.855041] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[   17.863752] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[   17.873865] Solarflare NET driver v4.0
[   17.889802] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   17.896831] tehuti: Options: hw_csum=20
[   17.898483] tlan: ThunderLAN driver v1.17
[   17.904995] tlan: 0 devices installed, PCI: 0  EISA: 0
[   17.907726] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[   17.918557] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[   17.922776] SLIP linefill/keepalive option.
[   17.929532] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[   17.935978] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[   17.942598] usbcore: registered new interface driver kaweth
[   17.945076] usbcore: registered new interface driver rtl8150
[   17.950916] usbcore: registered new interface driver cdc_phonet
[   17.957664] Fusion MPT base driver 3.04.20
[   17.963805] Copyright (c) 1999-2008 LSI Corporation
[   17.969345] Fusion MPT SPI Host driver 3.04.20
[   17.971401] Fusion MPT FC Host driver 3.04.20
[   17.977021] Fusion MPT SAS Host driver 3.04.20
[   18.003526] aoe: AoE v85 initialised.
[   18.005400] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   18.008227] ehci-pci: EHCI PCI platform driver
[   18.010536] ehci-platform: EHCI generic platform driver
[   18.017296] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   18.024003] ohci-platform: OHCI generic platform driver
[   18.026272] uhci_hcd: USB Universal Host Controller Interface driver
[   18.033693] driver u132_hcd
[   18.041700] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   18.048397] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[   18.056908] usbcore: registered new interface driver usblp
[   18.063475] usbcore: registered new interface driver cdc_wdm
[   18.065928] usbcore: registered new interface driver usbtmc
[   18.072942] usbcore: registered new interface driver usb-storage
[   18.082961] usbcore: registered new interface driver ums-cypress
[   18.090193] usbcore: registered new interface driver ums-datafab
[   18.092983] usbcore: registered new interface driver ums-freecom
[   18.103411] usbcore: registered new interface driver ums-jumpshot
[   18.107066] usbcore: registered new interface driver ums-karma
[   18.113849] usbcore: registered new interface driver ums-realtek
[   18.120845] usbcore: registered new interface driver ums-sddr55
[   18.127810] usbcore: registered new interface driver ums-usbat
[   18.134732] usbcore: registered new interface driver mdc800
[   18.141685] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   18.154125] usbcore: registered new interface driver microtekX6
[   18.157100] usbcore: registered new interface driver usbserial
[   18.166362] usbcore: registered new interface driver usbserial_generic
[   18.173661] usbserial: USB Serial support registered for generic
[   18.180738] usbcore: registered new interface driver aircable
[   18.187719] usbserial: USB Serial support registered for aircable
[   18.197077] usbcore: registered new interface driver ch341
[   18.203590] usbserial: USB Serial support registered for ch341-uart
[   18.206243] usbcore: registered new interface driver cp210x
[   18.212914] usbserial: USB Serial support registered for cp210x
[   18.219867] usbcore: registered new interface driver cyberjack
[   18.222427] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[   18.230272] usbcore: registered new interface driver io_edgeport
[   18.237083] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[   18.244448] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[   18.251809] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[   18.259435] usbserial: USB Serial support registered for EPiC device
[   18.262269] usbcore: registered new interface driver empeg
[   18.265223] usbserial: USB Serial support registered for empeg
[   18.271818] usbcore: registered new interface driver f81232
[   18.274421] usbserial: USB Serial support registered for f81232
[   18.281125] usbcore: registered new interface driver garmin_gps
[   18.287942] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[   18.293160] usbcore: registered new interface driver ipaq
[   18.299632] usbserial: USB Serial support registered for PocketPC PDA
[   18.302471] usbcore: registered new interface driver ir_usb
[   18.309092] usbserial: USB Serial support registered for IR Dongle
[   18.316014] usbcore: registered new interface driver iuu_phoenix
[   18.318519] usbserial: USB Serial support registered for iuu_phoenix
[   18.325504] usbcore: registered new interface driver keyspan
[   18.328111] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[   18.331624] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[   18.334771] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[   18.337929] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[   18.341169] usbcore: registered new interface driver keyspan_pda
[   18.343948] usbserial: USB Serial support registered for Keyspan PDA
[   18.346756] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[   18.350302] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[   18.354189] usbcore: registered new interface driver kl5kusb105
[   18.356900] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[   18.360212] usbcore: registered new interface driver kobil_sct
[   18.362721] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[   18.366319] usbcore: registered new interface driver mct_u232
[   18.368991] usbserial: USB Serial support registered for MCT U232
[   18.371749] usbcore: registered new interface driver metro_usb
[   18.374271] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[   18.377639] usbcore: registered new interface driver mos7720
[   18.380236] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[   18.383477] usbcore: registered new interface driver mos7840
[   18.385803] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[   18.393790] usbcore: registered new interface driver mxuport
[   18.400634] usbserial: USB Serial support registered for MOXA UPort
[   18.407626] usbcore: registered new interface driver navman
[   18.410060] usbserial: USB Serial support registered for navman
[   18.416850] usbcore: registered new interface driver omninet
[   18.423576] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[   18.426890] usbcore: registered new interface driver opticon
[   18.433722] usbserial: USB Serial support registered for opticon
[   18.440698] usbcore: registered new interface driver pl2303
[   18.443012] usbserial: USB Serial support registered for pl2303
[   18.449739] usbcore: registered new interface driver qcaux
[   18.456372] usbserial: USB Serial support registered for qcaux
[   18.458933] usbcore: registered new interface driver qcserial
[   18.465719] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[   18.472866] usbcore: registered new interface driver quatech2
[   18.479616] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[   18.487335] usbcore: registered new interface driver safe_serial
[   18.490045] usbserial: USB Serial support registered for safe_serial
[   18.497030] usbcore: registered new interface driver sierra
[   18.503467] usbserial: USB Serial support registered for Sierra USB modem
[   18.506214] usbcore: registered new interface driver usb_serial_simple
[   18.513518] usbserial: USB Serial support registered for zio
[   18.520395] usbserial: USB Serial support registered for funsoft
[   18.527459] usbserial: USB Serial support registered for flashloader
[   18.530275] usbserial: USB Serial support registered for vivopay
[   18.537065] usbserial: USB Serial support registered for moto_modem
[   18.543804] usbserial: USB Serial support registered for hp4x
[   18.546239] usbserial: USB Serial support registered for suunto
[   18.553085] usbserial: USB Serial support registered for siemens_mpi
[   18.560039] usbcore: registered new interface driver spcp8x5
[   18.562390] usbserial: USB Serial support registered for SPCP8x5
[   18.571680] usbcore: registered new interface driver ssu100
[   18.574071] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[   18.581834] usbcore: registered new interface driver ti_usb_3410_5052
[   18.588670] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[   18.592041] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[   18.595402] usbcore: registered new interface driver wishbone_serial
[   18.598146] usbserial: USB Serial support registered for wishbone_serial
[   18.601260] usbcore: registered new interface driver xsens_mt
[   18.603797] usbserial: USB Serial support registered for xsens_mt
[   18.606286] usbcore: registered new interface driver zte_ev
[   18.608898] usbserial: USB Serial support registered for zte_ev
[   18.611641] usbcore: registered new interface driver adutux
[   18.614130] usbcore: registered new interface driver cypress_cy7c63
[   18.617074] usbcore: registered new interface driver cytherm
[   18.619648] usbcore: registered new interface driver emi26 - firmware lo=
ader
[   18.622638] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   18.625556] driver ftdi-elan
[   18.636532] usbcore: registered new interface driver ftdi-elan
[   18.639307] usbcore: registered new interface driver ldusb
[   18.641764] usbcore: registered new interface driver usbled
[   18.649028] usbcore: registered new interface driver rio500
[   18.672785] usbcore: registered new interface driver usbtest
[   18.675419] usbcore: registered new interface driver usb_ehset_test
[   18.678228] usbcore: registered new interface driver trancevibrator
[   18.681205] usbcore: registered new interface driver uss720
[   18.683620] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[   18.700467] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[   18.703634] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[   18.706562] uss720: If you just want to connect to a printer, use usblp =
instead
[   18.710011] usbcore: registered new interface driver usbsevseg
[   18.725717] usbcore: registered new interface driver yurex
[   18.728303] usbcore: registered new interface driver sisusb
[   18.733079] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[   18.736421] dummy_hcd dummy_hcd.0: Dummy host controller
[   18.752011] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[   18.756253] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   18.759081] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   18.762148] usb usb1: Product: Dummy host controller
[   18.771946] usb usb1: Manufacturer: Linux 3.14.0-rc8-00108-g992e60a dumm=
y_hcd
[   18.779441] usb usb1: SerialNumber: dummy_hcd.0
[   18.788523] hub 1-0:1.0: USB hub found
[   18.790203] hub 1-0:1.0: 1 port detected
[   18.808319] printer gadget: Printer Gadget, version: 2007 OCT 06
[   18.815446] printer gadget: printer ready
[   18.817752] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   18.833752] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.841323] serio: i8042 AUX port at 0x60,0x64 irq 12
[   18.844102] parkbd: no such parport
[   18.851703] mousedev: PS/2 mouse device common for all mice
[   18.854059] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   18.869217] usbcore: registered new interface driver appletouch
[   18.871887] usbcore: registered new interface driver bcm5974
[   18.874565] usbcore: registered new interface driver synaptics_usb
[   18.875826] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   18.875861] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[   18.889373] usbcore: registered new interface driver usb_acecad
[   18.895231] usbcore: registered new interface driver aiptek
[   18.900961] usbcore: registered new interface driver gtco
[   18.905597] usbcore: registered new interface driver hanwang
[   18.911301] usbcore: registered new interface driver kbtab
[   18.921693] mk712: device not present
[   18.927308] usbcore: registered new interface driver sur40
[   18.949121] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   18.957264] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   18.965013] i2c /dev entries driver
[   18.971466] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   19.074648] usbcore: registered new interface driver i2c-diolan-u2c
[   19.077224] i2c-parport: adapter type unspecified
[   19.079405] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[   19.083537] usbcore: registered new interface driver i2c-tiny-usb
[   19.089411] pps pps0: new PPS source ktimer
[   19.093346] pps pps0: ktimer PPS source registered
[   19.097458] pps_parport: parallel port PPS client
[   19.103081] Driver for 1-wire Dallas network protocol.
[   19.110730] usbcore: registered new interface driver DS9490R
[   19.115301] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   19.124023] power_supply test_ac: uevent
[   19.127671] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[   19.132179] power_supply test_ac: prop ONLINE=3D1
[   19.133593] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   19.143713] power_supply test_ac: power_supply_changed
[   19.146072] power_supply test_ac: power_supply_changed_work
[   19.155028] power_supply test_ac: power_supply_update_gen_leds 1
[   19.158604] power_supply test_ac: uevent
[   19.160336] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[   19.160938] power_supply test_battery: uevent
[   19.160945] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[   19.160989] power_supply test_battery: prop STATUS=3DDischarging
[   19.161004] power_supply test_battery: prop CHARGE_TYPE=3DFast
[   19.161019] power_supply test_battery: prop HEALTH=3DGood
[   19.161031] power_supply test_battery: prop PRESENT=3D1
[   19.161043] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[   19.161055] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[   19.161067] power_supply test_battery: prop CHARGE_FULL=3D100
[   19.161079] power_supply test_battery: prop CHARGE_NOW=3D50
[   19.161091] power_supply test_battery: prop CAPACITY=3D50
[   19.161102] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[   19.161113] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[   19.161133] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[   19.161146] power_supply test_battery: prop MODEL_NAME=3DTest battery
[   19.161158] power_supply test_battery: prop MANUFACTURER=3DLinux
[   19.161170] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0108-g992e60a
[   19.161182] power_supply test_battery: prop TEMP=3D26
[   19.161193] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[   19.161764] power_supply test_battery: power_supply_changed
[   19.162283] power_supply test_usb: uevent
[   19.162289] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[   19.162328] power_supply test_usb: prop ONLINE=3D1
[   19.162391] power_supply test_usb: power_supply_changed
[   19.165134] power_supply test_battery: power_supply_changed_work
[   19.165153] power_supply test_battery: power_supply_update_bat_leds 2
[   19.165190] power_supply test_battery: uevent
[   19.165196] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[   19.165242] power_supply test_battery: prop STATUS=3DDischarging
[   19.165257] power_supply test_battery: prop CHARGE_TYPE=3DFast
[   19.165268] power_supply test_battery: prop HEALTH=3DGood
[   19.165280] power_supply test_battery: prop PRESENT=3D1
[   19.165292] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[   19.165304] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[   19.165315] power_supply test_battery: prop CHARGE_FULL=3D100
[   19.165327] power_supply test_battery: prop CHARGE_NOW=3D50
[   19.165338] power_supply test_battery: prop CAPACITY=3D50
[   19.165350] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[   19.165362] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[   19.165373] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[   19.165385] power_supply test_battery: prop MODEL_NAME=3DTest battery
[   19.165396] power_supply test_battery: prop MANUFACTURER=3DLinux
[   19.165408] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0108-g992e60a
[   19.165419] power_supply test_battery: prop TEMP=3D26
[   19.165430] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[   19.165506] power_supply test_usb: power_supply_changed_work
[   19.165526] power_supply test_usb: power_supply_update_gen_leds 1
[   19.165562] power_supply test_usb: uevent
[   19.165568] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[   19.165624] power_supply test_usb: prop ONLINE=3D1
[   19.336309] power_supply test_ac: prop ONLINE=3D1
[   19.476820] usb 1-1: Dual-Role OTG device on HNP port
[   19.480135] usb 1-1: device v0525 pa4a8 is not supported
[   19.482383] hub 1-0:1.0: unable to enumerate USB device on port 1
[   19.750193] i2c i2c-0: detect fail: address match, 0x2c
[   19.763604] i2c i2c-0: detect fail: address match, 0x2d
[   19.780198] i2c i2c-0: detect fail: address match, 0x2e
[   19.796895] i2c i2c-0: detect fail: address match, 0x2f
[   26.770730] device-mapper: uevent: version 1.0.3
[   26.775298] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   26.798371] device-mapper: multipath: version 1.6.0 loaded
[   26.801281] device-mapper: multipath round-robin: version 1.0.0 loaded
[   26.804258] device-mapper: multipath queue-length: version 0.1.0 loaded
[   26.807424] device-mapper: multipath service-time: version 0.2.0 loaded
[   26.811068] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   26.814490] sdhci: Secure Digital Host Controller Interface driver
[   26.817196] sdhci: Copyright(c) Pierre Ossman
[   26.819879] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   26.822590] wbsd: Copyright(c) Pierre Ossman
[   26.825112] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[   26.844935] usbcore: registered new interface driver vub300
[   26.847974] usbcore: registered new interface driver ushc
[   26.850764] sdhci-pltfm: SDHCI platform and OF driver helper
[   26.878495] leds_ss4200: no LED devices found
[   26.895967] rdma_ucm: couldn't register sysctl paths
[   26.903040] iscsi: registered transport (iser)
[   26.908607] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   26.912569] hidraw: raw HID events driver (C) Jiri Kosina
[   26.926528] usbcore: registered new interface driver usbhid
[   26.929288] usbhid: USB HID core driver
[   26.931333] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   26.934099] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   26.938262] hdaps: supported laptop not found!
[   26.940354] hdaps: driver init failed (ret=3D-19)!
[   26.945354] FUJ02B1: call_fext_func: FUNC interface is not present
[   26.948424] fujitsu_laptop: driver 0.6.0 successfully loaded
[   26.959592]  fake-fmc-carrier: mezzanine 0
[   26.961606]       Manufacturer: fake-vendor
[   26.963785]       Product name: fake-design-for-testing
[   26.966868] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   26.970285] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   26.975180] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   26.979277] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   26.984359] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[   27.007408] NET: Registered protocol family 26
[   27.009715] Mirror/redirect action on
[   27.011671] Simple TC action Loaded
[   27.016216] netem: version 1.3
[   27.018395] Netfilter messages via NETLINK v0.30.
[   27.021341] IPVS: Registered protocols (UDP)
[   27.024008] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   27.028233] IPVS: Creating netns size=3D1864 id=3D0
[   27.030938] IPVS: ipvs loaded.
[   27.032463] IPVS: [wlc] scheduler registered.
[   27.034849] IPVS: [lblc] scheduler registered.
[   27.037144] IPVS: [dh] scheduler registered.
[   27.039288] IPVS: [sh] scheduler registered.
[   27.041505] IPVS: [nq] scheduler registered.
[   27.043840] ipip: IPv4 over IPv4 tunneling driver
[   27.048775] gre: GRE over IPv4 demultiplexor driver
[   27.051730] TCP: cubic registered
[   27.053879] TCP: highspeed registered
[   27.055603] TCP: hybla registered
[   27.057438] TCP: htcp registered
[   27.059090] TCP: vegas registered
[   27.060934] TCP: scalable registered
[   27.062856] TCP: yeah registered
[   27.064441] TCP: illinois registered
[   27.066336] Initializing XFRM netlink socket
[   27.072631] NET: Registered protocol family 10
[   27.082011] mip6: Mobile IPv6
[   27.084134] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   27.087622] sit: IPv6 over IPv4 tunneling driver
[   27.096608] ip6_gre: GRE over IPv6 tunneling driver
[   27.101983] NET: Registered protocol family 17
[   27.117628] NET: Registered protocol family 15
[   27.120344] Ebtables v2.0 registered
[   27.122794] NET: Registered protocol family 5
[   27.125106] can: controller area network core (rev 20120528 abi 9)
[   27.128229] NET: Registered protocol family 29
[   27.130335] can: broadcast manager protocol (rev 20120528 t)
[   27.134265] RPC: Registered rdma transport module.
[   27.152535] NET: Registered protocol family 33
[   27.154742] Key type rxrpc registered
[   27.156491] Key type rxrpc_s registered
[   27.161432] RxRPC: Registered security type 2 'rxkad'
[   27.164330] l2tp_core: L2TP core driver, V2.0
[   27.166423] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   27.171247] DECnet: Routing cache hash table of 64 buckets, 5Kbytes
[   27.175467] NET: Registered protocol family 12
[   27.178503] NET: Registered protocol family 35
[   27.181882] 8021q: 802.1Q VLAN Support v1.8
[   27.186526] DCCP: Activated CCID 2 (TCP-like)
[   27.194646] sctp: Hash tables configured (established 819 bind 819)
[   27.199025] tipc: Activated (version 2.0.0)
[   27.207226] NET: Registered protocol family 30
[   27.212610] tipc: Started in single node mode
[   27.214754] 9pnet: Installing 9P2000 support
[   27.217595] NET: Registered protocol family 37
[   27.219833] NET: Registered protocol family 36
[   27.222226] Key type dns_resolver registered
[   27.224733] Key type ceph registered
[   27.228567] libceph: loaded (mon/osd proto 15/24)
[   27.232211] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   27.235997] openvswitch: Open vSwitch switching datapath
[   27.241422] NET: Registered protocol family 40
[   27.243518] mpls_gso: MPLS GSO support
[   27.248109]=20
[   27.248109] printing PIC contents
[   27.250512] ... PIC  IMR: ffff
[   27.251938] ... PIC  IRR: 1013
[   27.253398] ... PIC  ISR: 0000
[   27.254944] ... PIC ELCR: 0c00
[   27.256605] printing local APIC contents on CPU#0/0:
[   27.258880] ... APIC ID:      00000000 (0)
[   27.259901] ... APIC VERSION: 00050014
[   27.259901] ... APIC TASKPRI: 00000000 (00)
[   27.259901] ... APIC PROCPRI: 00000000
[   27.259901] ... APIC LDR: 01000000
[   27.259901] ... APIC DFR: ffffffff
[   27.259901] ... APIC SPIV: 000001ff
[   27.259901] ... APIC ISR field:
[   27.259901] 000000000000000000000000000000000000000000000000000000000000=
0000
[   27.259901] ... APIC TMR field:
[   27.259901] 000000000200000000000000000000000000000000000000000000000000=
0000
[   27.259901] ... APIC IRR field:
[   27.259901] 000000000000000000000000000000000000000000000000000000000000=
8000
[   27.259901] ... APIC ESR: 00000000
[   27.259901] ... APIC ICR: 000400f6
[   27.259901] ... APIC ICR2: 02000000
[   27.259901] ... APIC LVTT: 000200ef
[   27.259901] ... APIC LVTPC: 00010000
[   27.259901] ... APIC LVT0: 00010700
[   27.259901] ... APIC LVT1: 00000400
[   27.259901] ... APIC LVTERR: 000000fe
[   27.259901] ... APIC TMICT: 00032dd9
[   27.259901] ... APIC TMCCT: 00027972
[   27.259901] ... APIC TDCR: 00000003
[   27.259901]=20
[   27.303620] number of MP IRQ sources: 15.
[   27.305559] number of IO-APIC #0 registers: 24.
[   27.307722] testing the IO APIC.......................
[   27.310062] IO APIC #0......
[   27.311506] .... register #00: 00000000
[   27.313230] .......    : physical APIC id: 00
[   27.315298] .......    : Delivery Type: 0
[   27.317211] .......    : LTS          : 0
[   27.318945] .... register #01: 00170011
[   27.320742] .......     : max redirection entries: 17
[   27.322869] .......     : PRQ implemented: 0
[   27.324773] .......     : IO APIC version: 11
[   27.326610] .... register #02: 00000000
[   27.328473] .......     : arbitration: 00
[   27.330348] .... IRQ redirection table:
[   27.332028] 1    0    0   0   0    0    0    00
[   27.334009] 0    0    0   0   0    1    1    31
[   27.335893] 0    0    0   0   0    1    1    30
[   27.338017] 1    0    0   0   0    1    1    33
[   27.340163] 1    0    0   0   0    1    1    34
[   27.342330] 1    1    0   0   0    1    1    35
[   27.344535] 1    0    0   0   0    1    1    36
[   27.346695] 1    0    0   0   0    1    1    37
[   27.348890] 1    0    0   0   0    1    1    38
[   27.351082] 0    1    0   0   0    1    1    39
[   27.353184] 1    1    0   0   0    1    1    3A
[   27.355322] 1    1    0   0   0    1    1    3B
[   27.357550] 0    0    0   0   0    1    1    3C
[   27.359677] 1    0    0   0   0    1    1    3D
[   27.361676] 0    0    0   0   0    1    1    3E
[   27.363882] 0    0    0   0   0    1    1    3F
[   27.365886] 1    0    0   0   0    0    0    00
[   27.367899] 1    0    0   0   0    0    0    00
[   27.369913] 1    0    0   0   0    0    0    00
[   27.372061] 1    0    0   0   0    0    0    00
[   27.374283] 1    0    0   0   0    0    0    00
[   27.376354] 1    0    0   0   0    0    0    00
[   27.378569] 1    0    0   0   0    0    0    00
[   27.380761] 1    0    0   0   0    0    0    00
[   27.382840] IRQ to pin mappings:
[   27.384441] IRQ0 -> 0:2
[   27.385760] IRQ1 -> 0:1
[   27.387144] IRQ3 -> 0:3
[   27.388476] IRQ4 -> 0:4
[   27.389788] IRQ5 -> 0:5
[   27.391109] IRQ6 -> 0:6
[   27.392205] IRQ7 -> 0:7
[   27.393400] IRQ8 -> 0:8
[   27.394859] IRQ9 -> 0:9
[   27.396005] IRQ10 -> 0:10
[   27.397324] IRQ11 -> 0:11
[   27.398509] IRQ12 -> 0:12
[   27.399718] IRQ13 -> 0:13
[   27.400995] IRQ14 -> 0:14
[   27.402165] IRQ15 -> 0:15
[   27.403388] .................................... done.
[   27.407399] Loading compiled-in X.509 certificates
[   27.410163] kAFS: Red Hat AFS client v0.1 registering.
[   27.416662] bio: create slab <bio-1> at 1
[   27.424078] Btrfs loaded, integrity-checker=3Don
[   27.430683] rtc-test rtc-test.0: setting system clock to 2014-03-30 19:1=
4:54 UTC (1396206894)
[   27.437187] debug: unmapping init [mem 0xffffffff844af000-0xffffffff8481=
ffff]
[   27.442735] Write protecting the kernel read-only data: 32768k
[   27.452388] debug: unmapping init [mem 0xffff8800023ec000-0xffff8800023f=
ffff]
[   27.458948] debug: unmapping init [mem 0xffff880002eb4000-0xffff880002ff=
ffff]
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
Starting udev
mount: mounting none on /dev failed: Invalid argument
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
udevd[165]: inotify_init failed: Function not implemented
error initializing inotify
udevd[165]: error initializing inotify
error sending message: Connection refused
udevadm[166]: error sending message: Connection refused
[   28.900887] power_supply test_ac: uevent
[   28.903544] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[   28.906910] power_supply test_ac: prop ONLINE=3D1
[   28.909314] power_supply test_battery: uevent
[   28.911938] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[   28.916895] power_supply test_battery: prop STATUS=3DDischarging
[   28.919754] power_supply test_battery: prop CHARGE_TYPE=3DFast
[   28.923716] power_supply test_battery: prop HEALTH=3DGood
[   28.927109] power_supply test_battery: prop PRESENT=3D1
[   28.929085] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[   28.932162] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[   28.934381] power_supply test_battery: prop CHARGE_FULL=3D100
[   28.936293] power_supply test_battery: prop CHARGE_NOW=3D50
[   28.938198] power_supply test_battery: prop CAPACITY=3D50
[   28.940275] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[   28.943703] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[   28.948509] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[   28.951150] power_supply test_battery: prop MODEL_NAME=3DTest battery
[   28.955394] power_supply test_battery: prop MANUFACTURER=3DLinux
[   28.958863] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc8-0=
0108-g992e60a
[   28.962880] power_supply test_battery: prop TEMP=3D26
[   28.964733] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[   28.968715] power_supply test_usb: uevent
[   28.971355] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[   28.974721] power_supply test_usb: prop ONLINE=3D1
error sending message: Connection refused
udevadm[168]: error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
[   29.516263] GFS2: path_lookup on rootfs returned error -2
/etc/init.d/rc: eval: line 1: can't create /dev/tty0: No such device or add=
ress
Configuring network interfaces... done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
sed: /lib/modules/3.14.0-rc8-00108-g992e60a/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
/etc/kernel-tests/90-trinity: line 15: /trinity: not found
/etc/kernel-tests/90-trinity: line 16: /trinity: not found
/etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
wfg: skip syslogd
Deconfiguring network interfaces... done.
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting...=20
[  101.901740] Unregister pv shared memory for cpu 0
[  101.904142] Unregister pv shared memory for cpu 1
[  101.939571] reboot: Restarting system
[  101.945458] reboot: machine restart
Elapsed time: 115
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s4-03291922/992e60a78e1c2c6996fd55c5fb11344ad1a4c189/vmlinuz-3.14.0-rc8-00=
108-g992e60a -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pani=
c=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/k=
ernel-tests/run-queue/kvm/x86_64-randconfig-s4-03291922/open-osd:bidi-mq:99=
2e60a78e1c2c6996fd55c5fb11344ad1a4c189:bisect-linux5/.vmlinuz-992e60a78e1c2=
c6996fd55c5fb11344ad1a4c189-20140331030821-5-jaketown branch=3Dopen-osd/bid=
i-mq BOOT_IMAGE=3D/kernel/x86_64-randconfig-s4-03291922/992e60a78e1c2c6996f=
d55c5fb11344ad1a4c189/vmlinuz-3.14.0-rc8-00108-g992e60a drbd.minor_count=3D=
8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 256 -smp 2 -ne=
t nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::28425-:22 -b=
oot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile=
 /dev/shm/kboot/pid-yocto-jaketown-12 -serial file:/dev/shm/kboot/serial-yo=
cto-jaketown-12 -daemonize -display none -monitor null=20

--Nq2Wo0NMKNjxTN9z
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s4-03291922-80b612bf90a8ebdd09dff5695d0357aeb78f963e-WARNING:---at----do_one_initcall+-x-4858.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgODBiNjEyYi4uLiB7VE9ET30gYnNnOiByZW1vdmUgYm9ndXMgKGFu
ZCBmYXRhbCkgY2hlY2sgaW4gYnNnX3JlZ2lzdGVyX3F1ZXVlCmdpdCBjaGVja291dCA2NmU4
MTBlYzlmZmY5Y2Y1NjIyYTgzMjY4MDVlZjMxMGZkNWI5OGU3CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi9vcGVuLW9z
ZDpiaWRpLW1xOjY2ZTgxMGVjOWZmZjljZjU2MjJhODMyNjgwNWVmMzEwZmQ1Yjk4ZTc6Ymlz
ZWN0LWxpbnV4NQoKMjAxNC0wMy0zMS0wMjo1ODo0OSA2NmU4MTBlYzlmZmY5Y2Y1NjIyYTgz
MjY4MDVlZjMxMGZkNWI5OGU3IHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczQt
MDMyOTE5MjIvNjZlODEwZWM5ZmZmOWNmNTYyMmE4MzI2ODA1ZWYzMTBmZDViOThlNy92bWxp
bnV6LTMuMTQuMC1yYzUtMDAzMjAtZzY2ZTgxMGUKCjIwMTQtMDMtMzEtMDI6NTg6NDkgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLgk2Lgk3CTEzCTE3LgkyMCBTVUNDRVNTCgpiaXNlY3Q6IGdv
b2QgY29tbWl0IDY2ZTgxMGVjOWZmZjljZjU2MjJhODMyNjgwNWVmMzEwZmQ1Yjk4ZTcKZ2l0
IGJpc2VjdCBzdGFydCA4MGI2MTJiZjkwYThlYmRkMDlkZmY1Njk1ZDAzNTdhZWI3OGY5NjNl
IDY2ZTgxMGVjOWZmZjljZjU2MjJhODMyNjgwNWVmMzEwZmQ1Yjk4ZTcgLS0KL2Mva2VybmVs
LXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiODBiNjEyYmY5MGE4ZWJkZDA5ZGZmNTY5
NWQwMzU3YWViNzhmOTYzZSIsICItZyIsICI2NmU4MTBlYzlmZmY5Y2Y1NjIyYTgzMjY4MDVl
ZjMxMGZkNWI5OGU3IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzog
NDIxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBz
KQpbYWQ5NWM5NjZhY2MwM2JjOTA2ZGZmNmI4NzVhNTQ1Mzc5NjgwZjI2NF0gTWVyZ2UgcmVt
b3RlLXRyYWNraW5nIGJyYW5jaCAnbGludXMvbWFzdGVyJyBpbnRvIGJpZGktbXEKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwt
dGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyL29wZW4tb3NkOmJpZGktbXE6YWQ5
NWM5NjZhY2MwM2JjOTA2ZGZmNmI4NzVhNTQ1Mzc5NjgwZjI2NDpiaXNlY3QtbGludXg1Cgoy
MDE0LTAzLTMxLTAzOjAyOjUwIGFkOTVjOTY2YWNjMDNiYzkwNmRmZjZiODc1YTU0NTM3OTY4
MGYyNjQgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi9hZDk1
Yzk2NmFjYzAzYmM5MDZkZmY2Yjg3NWE1NDUzNzk2ODBmMjY0L3ZtbGludXotMy4xNC4wLXJj
OC0wMDEwNy1nYWQ5NWM5NgoKMjAxNC0wMy0zMS0wMzowMjo1MCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTEJMgk1Lgk2CTkJMTIJMTUJMTgJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbOTky
ZTYwYTc4ZTFjMmM2OTk2ZmQ1NWM1ZmIxMTM0NGFkMWE0YzE4OV0gUkZDOiBkb194b3Jfc3Bl
ZWQgQnJva2VuIG9uIFVNTCBkbyB0byBqaWZmaWVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1zNC0wMzI5MTkyMi9vcGVuLW9zZDpiaWRpLW1xOjk5MmU2MGE3OGUxYzJjNjk5NmZk
NTVjNWZiMTEzNDRhZDFhNGMxODk6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0zMS0wMzowODoy
MSA5OTJlNjBhNzhlMWMyYzY5OTZmZDU1YzVmYjExMzQ0YWQxYTRjMTg5IHJldXNlIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjIvOTkyZTYwYTc4ZTFjMmM2OTk2ZmQ1
NWM1ZmIxMTM0NGFkMWE0YzE4OS92bWxpbnV6LTMuMTQuMC1yYzgtMDAxMDgtZzk5MmU2MGEK
CjIwMTQtMDMtMzEtMDM6MDg6MjEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4gVEVTVCBGQUlM
VVJFClsgICAgMC4yNDMzOTldICAgIGdlbmVyaWNfc3NlOiAgICA2My45OTkgTUIvc2VjClsg
ICAgMC4yNDQwNDVdIHhvcjogdXNpbmcgZnVuY3Rpb246IGdlbmVyaWNfc3NlICg2My45OTkg
TUIvc2VjKQpbICAgIDAuMjQ2ODAwXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgICAwLjI0NzU3NF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBpbml0L21h
aW4uYzo3MDggZG9fb25lX2luaXRjYWxsKzB4MTc0LzB4MThiKCkKWyAgICAwLjI0OTA1MV0g
aW5pdGNhbGwgY2FsaWJyYXRlX3hvcl9ibG9ja3MrMHgwLzB4MWNjIHJldHVybmVkIHdpdGgg
cHJlZW1wdGlvbiBpbWJhbGFuY2UgClsgICAgMC4yNTAwOTVdIENQVTogMCBQSUQ6IDEgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQuMC1yYzgtMDAxMDgtZzk5MmU2MGEgIzM4
ClsgICAgMC4yNTMzNjVdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hz
IDAxLzAxLzIwMTEKWyAgICAwLjI1NDI2Nl0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAw
MDFhZmQ4MCBmZmZmZmZmZjgyM2JkMWY5IGZmZmY4ODAwMDAxYWZkYzgKWyAgICAwLjI1NzIx
NV0gIGZmZmY4ODAwMDAxYWZkYjggZmZmZmZmZmY4MTA4NGQzNyBmZmZmZmZmZjg0Njg0NTY1
IGZmZmZmZmZmODQ2YjliYzYKWyAgICAwLjI1ODM4OV0gIDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMDAxYWZlMTgKWyAgICAw
LjI1OTYwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjI2MDA3NV0gIFs8ZmZmZmZmZmY4MjNiZDFm
OT5dIGR1bXBfc3RhY2srMHhhMS8weDEwMgpbICAgIDAuMjYwOTEwXSAgWzxmZmZmZmZmZjgx
MDg0ZDM3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg5My8weGMxClsgICAgMC4yNjE4MDJd
ICBbPGZmZmZmZmZmODQ2ODQ1NjU+XSA/IGRvX29uZV9pbml0Y2FsbCsweDE3NC8weDE4Ygpb
ICAgIDAuMjYyNjk0XSAgWzxmZmZmZmZmZjg0NmI5YmM2Pl0gPyBkb194b3Jfc3BlZWQrMHgx
MmQvMHgxMmQKWyAgICAwLjI2MzM3Nl0gIFs8ZmZmZmZmZmY4MTA4NGRmMD5dIHdhcm5fc2xv
d3BhdGhfZm10KzB4NTUvMHg1ZQpbICAgIDAuMjY0MjUxXSAgWzxmZmZmZmZmZjg0NmI5YmM2
Pl0gPyBkb194b3Jfc3BlZWQrMHgxMmQvMHgxMmQKWyAgICAwLjI2NjY5OF0gIFs8ZmZmZmZm
ZmY4NDY4NDU2NT5dIGRvX29uZV9pbml0Y2FsbCsweDE3NC8weDE4YgpbICAgIDAuMjY3NTc2
XSAgWzxmZmZmZmZmZjg0Njg0OGQ3Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgzNWIvMHg0
NmQKWyAgICAwLjI2ODQ5NF0gIFs8ZmZmZmZmZmY4NDY4Mzk5Mj5dID8gZG9fZWFybHlfcGFy
YW0rMHhkNy8weGQ3ClsgICAgMC4yNjkzNThdICBbPGZmZmZmZmZmODIzOWVhNTg+XSA/IHJl
c3RfaW5pdCsweDE1Yy8weDE1YwpbICAgIDAuMjcwMDI2XSAgWzxmZmZmZmZmZjgyMzllYTY4
Pl0ga2VybmVsX2luaXQrMHgxMC8weDE4MQpbICAgIDAuMjczMzc0XSAgWzxmZmZmZmZmZjgy
M2Q4OTBjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjI3NDIwNF0gIFs8ZmZm
ZmZmZmY4MjM5ZWE1OD5dID8gcmVzdF9pbml0KzB4MTVjLzB4MTVjClsgICAgMC4yNzY4NThd
IC0tLVsgZW5kIHRyYWNlIDUxMGY4MmZhMzk0MWM5MjAgXS0tLQpbICAgIDAuMjc3NTc5XSBw
cmFuZG9tOiBzZWVkIGJvdW5kYXJ5IHNlbGYgdGVzdCBwYXNzZWQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zNC0wMzI5MTkyMi85OTJlNjBhNzhlMWMyYzY5OTZmZDU1YzVmYjExMzQ0
YWQxYTRjMTg5L2RtZXNnLXF1YW50YWwtbGtwLWliMDQtMTQ6MjAxNDAzMzEwMzA5MDM6eDg2
XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEwOC1nOTkyZTYwYToz
OAowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0zMSAw
MzowOToyMyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1i
aXNlY3QvLnJlcGVhdBtbMG0KCjk5MmU2MGE3OGUxYzJjNjk5NmZkNTVjNWZiMTEzNDRhZDFh
NGMxODkgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDk5MmU2MGE3OGUxYzJjNjk5
NmZkNTVjNWZiMTEzNDRhZDFhNGMxODkKQXV0aG9yOiAgICAgQm9heiBIYXJyb3NoIDxiaGFy
cm9zaEBwYW5hc2FzLmNvbT4KQXV0aG9yRGF0ZTogVGh1IEp1bCAxOSAxNToyMjozNyAyMDEy
ICswMzAwCkNvbW1pdDogICAgIEJvYXogSGFycm9zaCA8Ym9hekBwbGV4aXN0b3IuY29tPgpD
b21taXREYXRlOiBTdW4gTWFyIDMwIDE2OjAzOjI5IDIwMTQgKzAzMDAKCiAgICBSRkM6IGRv
X3hvcl9zcGVlZCBCcm9rZW4gb24gVU1MIGRvIHRvIGppZmZpZXMKICAgIAogICAgUmVtZW1i
ZXIgdGhhdCBoYW5nIEkgcmVwb3J0ZWQgYSB3aGlsZSBiYWNrIG9uIFVNTC4gV2VsbAogICAg
SSdtIGF0IGl0IGFnYWluLCBhbmQgaXQgc3RpbGwgaGFuZ3MgYW5kIEkgZm91bmQgd2h5Lgog
ICAgCiAgICBJIGhhdmUgZHByaW50ZWQgamlmZmllcyBhbmQgaXQgbmV2ZXIgYWR2YW5jZXMg
ZHVyaW5nIHRoZQogICAgbG9vcCBhdCBkb194b3Jfc3BlZWQuIFRoZXJlIGZvciBpdCBpcyBz
dHVjayBpbiBhbiBlbmRsZXNzCiAgICBsb29wLiBJIGhhdmUgYWxzbyBkcHJpbnRlZCBjdXJy
ZW50X2tlcm5lbF90aW1lKCkgYW5kIGl0CiAgICByZXR1cm5zIHRoZSBzYW1lIGNvbnN0YW50
IHZhbHVlIGFzIHdlbGwuCiAgICAKICAgIE5vdGUgdGhhdCBpdCBkb2VzIHVzdWFsbHkgd29y
ayBvbiBVTUwsIG9ubHkgZHVyaW5nCiAgICB0aGUgbW9kcHJvYmUgb2YgeG9yLmtvIHdoaWxl
IHRoYXQgdGVzdCBpcyBydW5uaW5nLiBJdCBsb29rcwogICAgbGlrZSBzb21lIGx1Y2tpbmcg
aXMgcHJldmVudGluZyB0aGUgY2xvY2sgZnJvbSB0aWNraW5nLgogICAgCiAgICBIb3dldmVy
IGt0aW1lX2dldF90cyBkb2VzIHdvcmsgZm9yIG1lIHNvIEkgY2hhbmdlZCB0aGUgY29kZQog
ICAgYXMgYmVsb3csIHNvIEkgY2FuIHdvcmsuIFNlZSBob3cgSSBwdXQgc2V2ZXJhbCBzYWZl
dHkKICAgIGd1YXJkcywgdG8gbmV2ZXIgZ2V0IGhhbmdzIGFnYWluLgogICAgQW5kIEkgdGhp
bmsgbXkgdGltZSBiYXNlZCBhcHByb2FjaCBpcyBtb3JlIGFjY3VyYXRlIHRoZW4KICAgIHBy
ZXZpb3VzIHN5c3RlbS4KICAgIAogICAgVU1MIGd1eXMgcGxlYXNlIGludmVzdGlnYXRlIHRo
ZSBqaWZmaWVzIGlzc3VlPyB3aGF0IGlzCiAgICB4b3Iua28gbm90IGRvaW5nIHJpZ2h0Pwog
ICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBCb2F6IEhhcnJvc2ggPGJoYXJyb3NoQHBhbmFzYXMu
Y29tPgoKIGNyeXB0by94b3IuYyB8IDQ3ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwg
MjIgZGVsZXRpb25zKC0pClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDk5MmU2MGEuLi4g
UkZDOiBkb194b3Jfc3BlZWQgQnJva2VuIG9uIFVNTCBkbyB0byBqaWZmaWVzCkhFQUQgaXMg
bm93IGF0IGFkOTVjOTYuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnbGludXMv
bWFzdGVyJyBpbnRvIGJpZGktbXEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyL29wZW4tb3NkOmJpZGktbXE6YWQ5NWM5
NjZhY2MwM2JjOTA2ZGZmNmI4NzVhNTQ1Mzc5NjgwZjI2NDpiaXNlY3QtbGludXg1CgoyMDE0
LTAzLTMxLTAzOjA5OjI0IGFkOTVjOTY2YWNjMDNiYzkwNmRmZjZiODc1YTU0NTM3OTY4MGYy
NjQgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi9hZDk1Yzk2
NmFjYzAzYmM5MDZkZmY2Yjg3NWE1NDUzNzk2ODBmMjY0L3ZtbGludXotMy4xNC4wLXJjOC0w
MDEwNy1nYWQ5NWM5NgoKMjAxNC0wMy0zMS0wMzowOToyNCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgkyMS4uCTIyCTIzCTI1CTI2Li4JMjguCTM0CTM1CTQzCTQ3CTUyCTU2CTU4CTU5CTYw
IFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGFkOTVjOTYuLi4gTWVyZ2Ug
cmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnbGludXMvbWFzdGVyJyBpbnRvIGJpZGktbXEKSEVB
RCBpcyBub3cgYXQgODBiNjEyYi4uLiB7VE9ET30gYnNnOiByZW1vdmUgYm9ndXMgKGFuZCBm
YXRhbCkgY2hlY2sgaW4gYnNnX3JlZ2lzdGVyX3F1ZXVlCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi9vcGVuLW9zZDpi
aWRpLW1xOjgwYjYxMmJmOTBhOGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2M2U6YmlzZWN0
LWxpbnV4NQogVEVTVCBGQUlMVVJFClsgICAgMC4xNzY2OTJdICAgIGdlbmVyaWNfc3NlOiAg
IDExMC40MDAgTUIvc2VjClsgICAgMC4xNzczMzhdIHhvcjogdXNpbmcgZnVuY3Rpb246IGdl
bmVyaWNfc3NlICgxMTAuNDAwIE1CL3NlYykKWyAgICAwLjE3ODE4MV0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4xNzg4MzhdIFdBUk5JTkc6IENQVTog
MCBQSUQ6IDEgYXQgaW5pdC9tYWluLmM6NzA4IGRvX29uZV9pbml0Y2FsbCsweDE3NC8weDE4
YigpClsgICAgMC4xODAwMjldIGluaXRjYWxsIGNhbGlicmF0ZV94b3JfYmxvY2tzKzB4MC8w
eDFjYyByZXR1cm5lZCB3aXRoIHByZWVtcHRpb24gaW1iYWxhbmNlIApbICAgIDAuMTgxMTQ1
XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM4
LTAwMTA5LWc4MGI2MTJiICMzOQpbICAgIDAuMTgyMjA3XSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4xODMwMTBdICAwMDAwMDAw
MDAwMDAwMDAwIGZmZmY4ODAwMDAxNTVkODAgZmZmZmZmZmY4MjNiZDQxOSBmZmZmODgwMDAw
MTU1ZGM4ClsgICAgMC4xODQwNzldICBmZmZmODgwMDAwMTU1ZGI4IGZmZmZmZmZmODEwODRk
MzcgZmZmZmZmZmY4NDY4NDU2NSBmZmZmZmZmZjg0NmI5YmM2ClsgICAgMC4xODUyMTNdICAw
MDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ODgwMDAwMTU1ZTE4ClsgICAgMC4xODY3MzddIENhbGwgVHJhY2U6ClsgICAgMC4xODcxMTRd
ICBbPGZmZmZmZmZmODIzYmQ0MTk+XSBkdW1wX3N0YWNrKzB4YTEvMHgxMDIKWyAgICAwLjE4
Nzg1Nl0gIFs8ZmZmZmZmZmY4MTA4NGQzNz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OTMv
MHhjMQpbICAgIDAuMTg4NzA2XSAgWzxmZmZmZmZmZjg0Njg0NTY1Pl0gPyBkb19vbmVfaW5p
dGNhbGwrMHgxNzQvMHgxOGIKWyAgICAwLjE4OTU0MV0gIFs8ZmZmZmZmZmY4NDZiOWJjNj5d
ID8gZG9feG9yX3NwZWVkKzB4MTJkLzB4MTJkClsgICAgMC4xOTAwMjJdICBbPGZmZmZmZmZm
ODEwODRkZjA+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDU1LzB4NWUKWyAgICAwLjE5MDgzOV0g
IFs8ZmZmZmZmZmY4NDZiOWJjNj5dID8gZG9feG9yX3NwZWVkKzB4MTJkLzB4MTJkClsgICAg
MC4xOTE2MzldICBbPGZmZmZmZmZmODQ2ODQ1NjU+XSBkb19vbmVfaW5pdGNhbGwrMHgxNzQv
MHgxOGIKWyAgICAwLjE5MjQ0Nl0gIFs8ZmZmZmZmZmY4NDY4NDhkNz5dIGtlcm5lbF9pbml0
X2ZyZWVhYmxlKzB4MzViLzB4NDZkClsgICAgMC4xOTMzNTVdICBbPGZmZmZmZmZmODQ2ODM5
OTI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ZDcvMHhkNwpbICAgIDAuMTk0MTY0XSAgWzxmZmZm
ZmZmZjgyMzllYzc4Pl0gPyByZXN0X2luaXQrMHgxNWMvMHgxNWMKWyAgICAwLjE5NDkzNl0g
IFs8ZmZmZmZmZmY4MjM5ZWM4OD5dIGtlcm5lbF9pbml0KzB4MTAvMHgxODEKWyAgICAwLjE5
NTY4N10gIFs8ZmZmZmZmZmY4MjNkOGIwYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsg
ICAgMC4xOTY2ODldICBbPGZmZmZmZmZmODIzOWVjNzg+XSA/IHJlc3RfaW5pdCsweDE1Yy8w
eDE1YwpbICAgIDAuMTk3NDkwXSAtLS1bIGVuZCB0cmFjZSA4YTgxMDljYWMzNTMxYjE1IF0t
LS0KWyAgICAwLjE5ODE1Ml0gcHJhbmRvbTogc2VlZCBib3VuZGFyeSBzZWxmIHRlc3QgcGFz
c2VkCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjIvODBiNjEyYmY5MGE4
ZWJkZDA5ZGZmNTY5NWQwMzU3YWViNzhmOTYzZS9kbWVzZy15b2N0by1sa3AtaWIwNC0zNzoy
MDE0MDMzMTAyNTkzODp4ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMjozLjE0LjAtcmM4
LTAwMTA5LWc4MGI2MTJiOjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5
MjIvODBiNjEyYmY5MGE4ZWJkZDA5ZGZmNTY5NWQwMzU3YWViNzhmOTYzZS9kbWVzZy1xdWFu
dGFsLWxrcC1pYjA0LTgyOjIwMTQwMzMxMDI1NjAwOng4Nl82NC1yYW5kY29uZmlnLXM0LTAz
MjkxOTIyOjMuMTQuMC1yYzgtMDAxMDktZzgwYjYxMmI6MzkKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zNC0wMzI5MTkyMi84MGI2MTJiZjkwYThlYmRkMDlkZmY1Njk1ZDAzNTdhZWI3
OGY5NjNlL2RtZXNnLXlvY3RvLWxrcC1pYjA0LTUyOjIwMTQwMzMxMDI1NzIzOng4Nl82NC1y
YW5kY29uZmlnLXM0LTAzMjkxOTIyOjMuMTQuMC1yYzgtMDAxMDktZzgwYjYxMmI6MzkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi84MGI2MTJiZjkwYThlYmRkMDlk
ZmY1Njk1ZDAzNTdhZWI3OGY5NjNlL2RtZXNnLXF1YW50YWwtbGtwLWliMDQtMjE6MjAxNDAz
MzEwMjU1NDA6eDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEw
OS1nODBiNjEyYjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzgw
YjYxMmJmOTBhOGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2M2UvZG1lc2cteW9jdG8tbGtw
LWliMDQtNDE6MjAxNDAzMzEwMjU2NDg6eDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjI6
My4xNC4wLXJjOC0wMDEwOS1nODBiNjEyYjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBhOGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2M2Uv
ZG1lc2cteW9jdG8tbGtwLWliMDQtMjk6MjAxNDAzMzEwMjU5Mzg6eDg2XzY0LXJhbmRjb25m
aWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEwOS1nODBiNjEyYjozOQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBhOGViZGQwOWRmZjU2OTVk
MDM1N2FlYjc4Zjk2M2UvZG1lc2cteW9jdG8tbGtwLWliMDQtNzg6MjAxNDAzMzEwMzAwMDE6
eDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEwOS1nODBiNjEy
YjozOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBh
OGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2M2UvZG1lc2ctcXVhbnRhbC1sa3AtaWIwNC0z
OjIwMTQwMzMxMDI1ODUzOng4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyOjMuMTQuMC1y
YzgtMDAxMDktZzgwYjYxMmI6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5
MTkyMi84MGI2MTJiZjkwYThlYmRkMDlkZmY1Njk1ZDAzNTdhZWI3OGY5NjNlL2RtZXNnLXF1
YW50YWwtYXRoZW5zLTMxOjIwMTQwMzMxMDI1OTMyOng4Nl82NC1yYW5kY29uZmlnLXM0LTAz
MjkxOTIyOjMuMTQuMC1yYzgtMDAxMDktZzgwYjYxMmI6MzkKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1zNC0wMzI5MTkyMi84MGI2MTJiZjkwYThlYmRkMDlkZmY1Njk1ZDAzNTdhZWI3
OGY5NjNlL2RtZXNnLXF1YW50YWwtbGtwLWliMDQtNDc6MjAxNDAzMzEwMjU2MDI6eDg2XzY0
LXJhbmRjb25maWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEwOS1nODBiNjEyYjozOQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBhOGViZGQw
OWRmZjU2OTVkMDM1N2FlYjc4Zjk2M2UvZG1lc2ctcXVhbnRhbC1sa3AtaWIwNC0zOjIwMTQw
MzMxMDI1NjM3Ong4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyOjMuMTQuMC1yYzgtMDAx
MDktZzgwYjYxMmI6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi84
MGI2MTJiZjkwYThlYmRkMDlkZmY1Njk1ZDAzNTdhZWI3OGY5NjNlL2RtZXNnLXF1YW50YWwt
bGtwLWliMDQtMzY6MjAxNDAzMzEwMjU2MTE6eDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5
MjI6My4xNC4wLXJjOC0wMDEwOS1nODBiNjEyYjozOQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBhOGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2
M2UvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzM6MjAxNDAzMzEwMjU5MzI6eDg2XzY0LXJhbmRj
b25maWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEwOS1nODBiNjEyYjozOQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBhOGViZGQwOWRmZjU2
OTVkMDM1N2FlYjc4Zjk2M2UvZG1lc2ctcXVhbnRhbC1sa3AtaWIwNC05NjoyMDE0MDMzMTAy
NTUyMTp4ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMjozLjE0LjAtcmM4LTAwMTA5LWc4
MGI2MTJiOjM5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjIvODBiNjEy
YmY5MGE4ZWJkZDA5ZGZmNTY5NWQwMzU3YWViNzhmOTYzZS9kbWVzZy1xdWFudGFsLWxrcC1p
YjA0LTc0OjIwMTQwMzMxMDI1ODMyOng4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyOjMu
MTQuMC1yYzgtMDAxMDktZzgwYjYxMmI6MzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
NC0wMzI5MTkyMi84MGI2MTJiZjkwYThlYmRkMDlkZmY1Njk1ZDAzNTdhZWI3OGY5NjNlL2Rt
ZXNnLXF1YW50YWwtamFrZXRvd24tMjY6MjAxNDAzMzEwMjU4MzA6eDg2XzY0LXJhbmRjb25m
aWctczQtMDMyOTE5MjI6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIy
LzgwYjYxMmJmOTBhOGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2M2UvZG1lc2cteW9jdG8t
bGtwLWliMDQtOTE6MjAxNDAzMzEwMjU2MjU6eDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5
MjI6My4xNC4wLXJjOC0wMDEwOS1nODBiNjEyYjozOQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXM0LTAzMjkxOTIyLzgwYjYxMmJmOTBhOGViZGQwOWRmZjU2OTVkMDM1N2FlYjc4Zjk2
M2UvZG1lc2ctcXVhbnRhbC1sa3AtaWIwNC0yMjoyMDE0MDMzMTAyNTkzODp4ODZfNjQtcmFu
ZGNvbmZpZy1zNC0wMzI5MTkyMjozLjE0LjAtcmM4LTAwMTA5LWc4MGI2MTJiOjM5Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjIvODBiNjEyYmY5MGE4ZWJkZDA5ZGZm
NTY5NWQwMzU3YWViNzhmOTYzZS9kbWVzZy15b2N0by1hdGhlbnMtMjc6MjAxNDAzMzEwMzAw
MzM6eDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjI6My4xNC4wLXJjOC0wMDEwOS1nODBi
NjEyYjozOQowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQg
SEVBRCA1YmI4NDViXSBSZXZlcnQgIlJGQzogZG9feG9yX3NwZWVkIEJyb2tlbiBvbiBVTUwg
ZG8gdG8gamlmZmllcyIKIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAyNSBk
ZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXM0LTAzMjkxOTIyL29wZW4tb3NkOmJpZGktbXE6NWJiODQ1YmUwNWExY2Mx
NTlkNTFkMmZhZjM0NGI4NzU1YzVkMGE2YzpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTMxLTAz
OjIwOjI4IDViYjg0NWJlMDVhMWNjMTU5ZDUxZDJmYWYzNDRiODc1NWM1ZDBhNmMgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjItNWJiODQ1YmUwNWExY2MxNTlkNTFkMmZhZjM0
NGI4NzU1YzVkMGE2YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczQtMDMyOTE5MjIvNWJiODQ1YmUwNWExY2MxNTlkNTFkMmZhZjM0NGI4NzU1YzVk
MGE2Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctczQtMDMyOTE5MjItNWJiODQ1YmUwNWExY2MxNTlkNTFk
MmZhZjM0NGI4NzU1YzVkMGE2YwpzdGF0dXM6IEZBSUw6IG5vIGNvbW1pdCA1YmI4NDViZTA1
YTFjYzE1OWQ1MWQyZmFmMzQ0Yjg3NTVjNWQwYTZjIGZvciBidWlsZCB0YXNrIHg4Nl82NC1y
YW5kY29uZmlnLXM0LTAzMjkxOTIyLTViYjg0NWJlMDVhMWNjMTU5ZDUxZDJmYWYzNDRiODc1
NWM1ZDBhNmMKMjAxNC0wMy0zMS0wMzoyMToyOCA1YmI4NDViZTA1YTFjYzE1OWQ1MWQyZmFm
MzQ0Yjg3NTVjNWQwYTZjIFNLSVAgQlJPS0VOIEJVSUxECk5vIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzViYjg0NWJlMDVhMWNjMTU5ZDUxZDJm
YWYzNDRiODc1NWM1ZDBhNmMKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KV2Fybmlu
ZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNvbm5lY3RlZCB0bwph
bnkgb2YgeW91ciBicmFuY2hlczoKCiAgNWJiODQ1YiBSZXZlcnQgIlJGQzogZG9feG9yX3Nw
ZWVkIEJyb2tlbiBvbiBVTUwgZG8gdG8gamlmZmllcyIKCklmIHlvdSB3YW50IHRvIGtlZXAg
dGhlbSBieSBjcmVhdGluZyBhIG5ldyBicmFuY2gsIHRoaXMgbWF5IGJlIGEgZ29vZCB0aW1l
CnRvIGRvIHNvIHdpdGg6CgogZ2l0IGJyYW5jaCBuZXdfYnJhbmNoX25hbWUgNWJiODQ1YgoK
SEVBRCBpcyBub3cgYXQgOTgxZTg5My4uLiBNZXJnZSBicmFuY2ggJ3RpbWVycy11cmdlbnQt
Zm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdGlwL3RpcApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczQtMDMyOTE5MjIvb3Blbi1vc2Q6YmlkaS1tcTo5ODFlODkzZWQ1Mzdj
YmFhMDhmODA4OWQ0ODBkYjQxNjVlNmQ3MWMwOmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMzEt
MDM6MjE6MjkgOTgxZTg5M2VkNTM3Y2JhYTA4ZjgwODlkNDgwZGI0MTY1ZTZkNzFjMCByZXVz
ZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyLzk4MWU4OTNlZDUzN2Ni
YWEwOGY4MDg5ZDQ4MGRiNDE2NWU2ZDcxYzAvdm1saW51ei0zLjE0LjAtcmM4LTAwMDY2LWc5
ODFlODkzCgoyMDE0LTAzLTMxLTAzOjIxOjI5IGRldGVjdGluZyBib290IHN0YXRlIC4JNAk4
CTEzCTE0CTE2CTE3CTIzCTI0CTI3CTMwCTM0CTQxCTQyCTQ1CTUzCTU0CTU5Lgk2MCBTVUND
RVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIDk4MWU4OTMuLi4gTWVyZ2UgYnJhbmNoICd0aW1lcnMtdXJnZW50LWZvci1s
aW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3RpcC90aXAKSEVBRCBpcyBub3cgYXQgMjAxNTQ0Yi4uLiBBZGQgbGludXgtbmV4dCBzcGVj
aWZpYyBmaWxlcyBmb3IgMjAxNDAzMjgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXM0LTAzMjkxOTIyL29wZW4tb3NkOmJpZGktbXE6MjAx
NTQ0YmU4YzM3ZGZmYmYwNjliYjVmYzllZGI1Njc0ZjhjMTc1NDpiaXNlY3QtbGludXg1Cgoy
MDE0LTAzLTMxLTAzOjMxOjQ0IDIwMTU0NGJlOGMzN2RmZmJmMDY5YmI1ZmM5ZWRiNTY3NGY4
YzE3NTQgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zNC0wMzI5MTkyMi8yMDE1
NDRiZThjMzdkZmZiZjA2OWJiNWZjOWVkYjU2NzRmOGMxNzU0L3ZtbGludXotMy4xNC4wLXJj
OC1uZXh0LTIwMTQwMzI4CgoyMDE0LTAzLTMxLTAzOjMxOjQ0IGRldGVjdGluZyBib290IHN0
YXRlIC4JMTAJMTMJMTQJMTkJMjQJMzIJNDcJNTMJNjAgU1VDQ0VTUwoK

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc8-00108-g992e60a"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc8 Kernel Configuration
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

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
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
CONFIG_X86_INTEL_LPSS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
# CONFIG_X86_64_ACPI_NUMA is not set
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
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
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
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
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
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
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_TABLES is not set
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
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
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
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
# CONFIG_BRIDGE_EBT_T_NAT is not set
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_IP6=y
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=y
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
# CONFIG_BRIDGE_EBT_LOG is not set
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_MEDIA_IB=y
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_6LOWPAN_IPHC=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
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
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_JANZ_ICAN3=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_PEAK_PCI=y
# CONFIG_CAN_PEAK_PCIEC is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
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
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
CONFIG_GENWQE=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
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
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

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
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
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
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_ATP867X=y
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=y
# CONFIG_PATA_HPT3X3_DMA is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=y
# CONFIG_PATA_SIS is not set
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
# CONFIG_DM_CACHE_CLEANER is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_RING=y

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
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_ALX=y
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=y
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
CONFIG_SFC=y
CONFIG_SFC_MCDI_MON=y
# CONFIG_SFC_SRIOV is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_CDC_PHONET=y
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=y
CONFIG_VMXNET3=y
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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_W90X900=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_SUR40=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_MUX_PINCTRL is not set
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
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
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
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
# CONFIG_PINCONF is not set
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_TMIO is not set
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
# CONFIG_REALTEK_AUTOPM is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
CONFIG_USB_MUSB_GADGET=y
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=y
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=y
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_PXAV3=y
CONFIG_MMC_SDHCI_PXAV2=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

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
CONFIG_LEDS_ATMEL_PWM=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
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
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_QIB is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_MLX5_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_ISER=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
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
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8925 is not set
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_SI5351=y
# CONFIG_CLK_TWL6040 is not set

#
# Hardware Spinlock drivers
#
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
CONFIG_BMA180=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_SENSORS_LM3533=y
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
# CONFIG_EFI_VARS_PSTORE is not set
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
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
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_EXOFS_FS=y
CONFIG_EXOFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=y
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB2 is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_9P_FS=y
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
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
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

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
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
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
CONFIG_CRYPTO_AUTHENC=y
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
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
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
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
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--Nq2Wo0NMKNjxTN9z--
