Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaHIObA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:31:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:40110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaHIOaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:30:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,832,1400050800"; 
   d="scan'208";a="574225583"
Date: Sat, 9 Aug 2014 22:30:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [sched] Out of memory: Kill process 2999 (rc) score 9 or sacrifice
 child
Message-ID: <20140809143034.GA28345@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Peter,

We noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/wait
commit d58d631b474c552dce72da2dce9dd276d731b79a ("sched: Fix finish_task_switch vs prev_state")

test case: vm-vp-quantal-x86_64/boot/1

9e6e6179961e8dd  d58d631b474c552dce72da2dc  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
         0           +Inf%          1 ± 0%  TOTAL dmesg.Out_of_memory:Kill_process
         0           +Inf%          0 ±50%  TOTAL dmesg.Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes

In commit 9e6e6179961e8dd, the boot dmesg is

[    7.537598] Freeing unused kernel memory: 3352K (ffffffff82230000 - ffffffff82576000)
[    7.558273] random: init urandom read with 11 bits of entropy available
[    7.687132] init: Failed to create pty - disabling logging for job
[    7.688578] init: Temporary process spawn error: No space left on device
[   68.298970] reboot: Restarting system

In d58d631b474c552dce72da2dc, the OOM occurred immediately after the
"No space left on device" line. The qemu has mem=320M and the initrds
are 24M in total. What's interesting is, in the 5 boot tests for
d58d631b47 and its parent commit, this OOM message is 100%
reproducible on commit d58d631b47, while its parent boots all fine. 

Thanks,
Fengguang

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-00918-gd58d631 (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #11 SMP Sat Aug 9 07:13:50 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-quantal-=
x86_64-47/bisect_boot-1-x86_64-nfsroot-d58d631b474c552dce72da2dce9dd276d731=
b79a-4.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-nfsroot/d58d631b474c5=
52dce72da2dce9dd276d731b79a/vmlinuz-3.16.0-00918-gd58d631 kconfig=3Dx86_64-=
nfsroot commit=3Dd58d631b474c552dce72da2dce9dd276d731b79a initrd=3D/kernel-=
tests/initrd/quantal-core-x86_64.cgz root=3D/dev/ram0 lkp_initrd=3D/lkp/lkp=
/lkp-x86_64.cgz modules_initrd=3D/kernel/x86_64-nfsroot/d58d631b474c552dce7=
2da2dce9dd276d731b79a/modules.cgz RESULT_ROOT=3D/result/vm-vp-quantal-x86_6=
4/boot/1/x86_64-nfsroot/d58d631b474c552dce72da2dce9dd276d731b79a/0 ip=3D:::=
:vm-vp-quantal-x86_64-47::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debu=
g apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_=
ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.mino=
r_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000167fdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000167fe000-0x00000000167fffff] reser=
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
[    0.000000] e820: last_pfn =3D 0x167fe max_arch_pfn =3D 0x400000000
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
[    0.000000] PAT not supported by CPU.
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03509000, 0x03509fff] PGTABLE
[    0.000000] BRK [0x0350a000, 0x0350afff] PGTABLE
[    0.000000] BRK [0x0350b000, 0x0350bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x14e00000-0x14ffffff]
[    0.000000]  [mem 0x14e00000-0x14ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x14000000-0x14dfffff]
[    0.000000]  [mem 0x14000000-0x14dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x13ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x13ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x15000000-0x167fdfff]
[    0.000000]  [mem 0x15000000-0x165fffff] page 2M
[    0.000000]  [mem 0x16600000-0x167fdfff] page 4k
[    0.000000] BRK [0x0350c000, 0x0350cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x15101000-0x167effff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000167FE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000167FFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000167FE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000167FFF40 000040
[    0.000000] ACPI: SSDT 0x00000000167FF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000167FF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000167FF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000167fdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x167fdfff]
[    0.000000]   NODE_DATA [mem 0x167f9000-0x167fdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:167f8001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001420000=
0-ffff8800147fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x167fdfff]
[    0.000000] On node 0 totalpages: 92060
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1376 pages used for memmap
[    0.000000]   DMA32 zone: 88062 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x16800000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880014c00000 s1920576 r8=
192 d20928 u2097152
[    0.000000] pcpu-alloc: s1920576 r8192 d20928 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 14c0d200
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 90599
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-q=
uantal-x86_64-47/bisect_boot-1-x86_64-nfsroot-d58d631b474c552dce72da2dce9dd=
276d731b79a-4.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-nfsroot/d58d63=
1b474c552dce72da2dce9dd276d731b79a/vmlinuz-3.16.0-00918-gd58d631 kconfig=3D=
x86_64-nfsroot commit=3Dd58d631b474c552dce72da2dce9dd276d731b79a initrd=3D/=
kernel-tests/initrd/quantal-core-x86_64.cgz root=3D/dev/ram0 lkp_initrd=3D/=
lkp/lkp/lkp-x86_64.cgz modules_initrd=3D/kernel/x86_64-nfsroot/d58d631b474c=
552dce72da2dce9dd276d731b79a/modules.cgz RESULT_ROOT=3D/result/vm-vp-quanta=
l-x86_64/boot/1/x86_64-nfsroot/d58d631b474c552dce72da2dce9dd276d731b79a/0 i=
p=3D::::vm-vp-quantal-x86_64-47::dhcp oops=3Dpanic earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D=
2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw =
drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 296000K/368240K available (11422K kernel code, 1423K=
 rwdata, 5760K rodata, 3352K init, 15896K bss, 72240K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-00918-gd58d631 (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #11 SMP Sat Aug 9 07:13:50 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-quantal-=
x86_64-47/bisect_boot-1-x86_64-nfsroot-d58d631b474c552dce72da2dce9dd276d731=
b79a-4.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-nfsroot/d58d631b474c5=
52dce72da2dce9dd276d731b79a/vmlinuz-3.16.0-00918-gd58d631 kconfig=3Dx86_64-=
nfsroot commit=3Dd58d631b474c552dce72da2dce9dd276d731b79a initrd=3D/kernel-=
tests/initrd/quantal-core-x86_64.cgz root=3D/dev/ram0 lkp_initrd=3D/lkp/lkp=
/lkp-x86_64.cgz modules_initrd=3D/kernel/x86_64-nfsroot/d58d631b474c552dce7=
2da2dce9dd276d731b79a/modules.cgz RESULT_ROOT=3D/result/vm-vp-quantal-x86_6=
4/boot/1/x86_64-nfsroot/d58d631b474c552dce72da2dce9dd276d731b79a/0 ip=3D:::=
:vm-vp-quantal-x86_64-47::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debu=
g apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_=
ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.mino=
r_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000167fdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000167fe000-0x00000000167fffff] reser=
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
[    0.000000] e820: last_pfn =3D 0x167fe max_arch_pfn =3D 0x400000000
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
[    0.000000] PAT not supported by CPU.
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03509000, 0x03509fff] PGTABLE
[    0.000000] BRK [0x0350a000, 0x0350afff] PGTABLE
[    0.000000] BRK [0x0350b000, 0x0350bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x14e00000-0x14ffffff]
[    0.000000]  [mem 0x14e00000-0x14ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x14000000-0x14dfffff]
[    0.000000]  [mem 0x14000000-0x14dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x13ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x13ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x15000000-0x167fdfff]
[    0.000000]  [mem 0x15000000-0x165fffff] page 2M
[    0.000000]  [mem 0x16600000-0x167fdfff] page 4k
[    0.000000] BRK [0x0350c000, 0x0350cfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x15101000-0x167effff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x00000000167FE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x00000000167FFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x00000000167FE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x00000000167FFF40 000040
[    0.000000] ACPI: SSDT 0x00000000167FF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x00000000167FF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x00000000167FF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000167fdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x167fdfff]
[    0.000000]   NODE_DATA [mem 0x167f9000-0x167fdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:167f8001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff88001420000=
0-ffff8800147fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x167fdfff]
[    0.000000] On node 0 totalpages: 92060
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1376 pages used for memmap
[    0.000000]   DMA32 zone: 88062 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x16800000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880014c00000 s1920576 r8=
192 d20928 u2097152
[    0.000000] pcpu-alloc: s1920576 r8192 d20928 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 14c0d200
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 90599
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-vp-q=
uantal-x86_64-47/bisect_boot-1-x86_64-nfsroot-d58d631b474c552dce72da2dce9dd=
276d731b79a-4.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-nfsroot/d58d63=
1b474c552dce72da2dce9dd276d731b79a/vmlinuz-3.16.0-00918-gd58d631 kconfig=3D=
x86_64-nfsroot commit=3Dd58d631b474c552dce72da2dce9dd276d731b79a initrd=3D/=
kernel-tests/initrd/quantal-core-x86_64.cgz root=3D/dev/ram0 lkp_initrd=3D/=
lkp/lkp/lkp-x86_64.cgz modules_initrd=3D/kernel/x86_64-nfsroot/d58d631b474c=
552dce72da2dce9dd276d731b79a/modules.cgz RESULT_ROOT=3D/result/vm-vp-quanta=
l-x86_64/boot/1/x86_64-nfsroot/d58d631b474c552dce72da2dce9dd276d731b79a/0 i=
p=3D::::vm-vp-quantal-x86_64-47::dhcp oops=3Dpanic earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D=
2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw =
drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 296000K/368240K available (11422K kernel code, 1423K=
 rwdata, 5760K rodata, 3352K init, 15896K bss, 72240K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.486 MHz processor
[    0.002000] Calibrating delay loop (skipped) preset value.. 5386.97 Bogo=
MIPS (lpj=3D2693486)
[    0.002037] pid_max: default: 32768 minimum: 301
[    0.003157] ACPI: Core revision 20140424
[    0.073491] ACPI: All ACPI Tables successfully acquired
[    0.076655] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.078570] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.079275] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.080046] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.084285] Initializing cgroup subsys devices
[    0.086160] Initializing cgroup subsys freezer
[    0.087057] Initializing cgroup subsys blkio
[    0.088037] Initializing cgroup subsys debug
[    0.089331] mce: CPU supports 10 MCE banks
[    0.090117] numa_add_cpu cpu 0 node 0: mask now 0
[    0.091019] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.091019] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.093334] Freeing SMP alternatives memory: 44K (ffffffff82576000 - fff=
fffff82581000)
[    0.101201] ftrace: allocating 45664 entries in 179 pages
[    0.117315] Getting VERSION: 50014
[    0.118018] Getting VERSION: 50014
[    0.119067] Getting ID: 0
[    0.120021] Getting ID: ff000000
[    0.121022] Getting LVT0: 8700
[    0.122013] Getting LVT1: 8400
[    0.123087] enabled ExtINT on CPU#0
[    0.125912] ENABLING IO-APIC IRQs
[    0.126023] init IO_APIC IRQs
[    0.127017]  apic 0 pin 0 not connected
[    0.129026] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.130055] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.132052] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.133053] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.134052] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.135049] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.136053] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.137056] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.138049] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.139052] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.140057] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.141091] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.142052] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.143059] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.144061] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.145043]  apic 0 pin 16 not connected
[    0.146015]  apic 0 pin 17 not connected
[    0.147008]  apic 0 pin 18 not connected
[    0.148010]  apic 0 pin 19 not connected
[    0.149016]  apic 0 pin 20 not connected
[    0.150008]  apic 0 pin 21 not connected
[    0.151007]  apic 0 pin 22 not connected
[    0.152007]  apic 0 pin 23 not connected
[    0.153174] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.154015] smpboot: CPU0: Intel QEMU Virtual CPU version 1.7.1 (fam: 06=
, model: 06, stepping: 03)
[    0.157008] Using local APIC timer interrupts.
[    0.157008] calibrating APIC timer ...
[    0.159000] ... lapic delta =3D 6250041
[    0.159000] ... PM-Timer delta =3D 357961
[    0.159000] ... PM-Timer result ok
[    0.159000] ..... delta 6250041
[    0.159000] ..... mult: 268437216
[    0.159000] ..... calibration result: 1000006
[    0.159000] ..... CPU clock speed is 2693.0449 MHz.
[    0.159000] ..... host bus clock speed is 1000.0006 MHz.
[    0.159330] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
[    0.162015] Failed to access perfctr msr (MSR c1 is 0)
[    0.168701] x86: Booting SMP configuration:
[    0.169039] .... node  #0, CPUs:      #1
[    0.002000] kvm-clock: cpu 1, msr 0:167f8041, secondary cpu clock
[    0.002000] masked ExtINT on CPU#1
[    0.002000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.184259] x86: Booted up 1 node, 2 CPUs
[    0.185032] ----------------
[    0.186004] | NMI testsuite:
[    0.187006] --------------------
[    0.188006]   remote IPI:
[    0.194013] KVM setup async PF for cpu 1
[    0.195000] kvm-stealtime: cpu 1, msr 14e0d200
[    0.202059]   ok  |
[    0.203005]    local IPI:  ok  |
[    0.210033] --------------------
[    0.211006] Good, all   2 testcases passed! |
[    0.212012] ---------------------------------
[    0.213010] smpboot: Total of 2 processors activated (10773.94 BogoMIPS)
[    0.217450] devtmpfs: initialized
[    0.230049] kworker/u4:0 (17) used greatest stack depth: 13744 bytes left
[    0.231984] xor: measuring software checksum speed
[    0.252778]    prefetch64-sse:    96.000 MB/sec
[    0.266752]    generic_sse:    96.000 MB/sec
[    0.268007] xor: using function: generic_sse (96.000 MB/sec)
[    0.273653] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.275177] RTC time:  7:16:50, date: 08/09/14
[    0.277474] NET: Registered protocol family 16
[    0.282858] cpuidle: using governor ladder
[    0.283024] cpuidle: using governor menu
[    0.284000] ACPI: bus type PCI registered
[    0.284000] dca service started, version 1.12.1
[    0.285635] kworker/u4:0 (31) used greatest stack depth: 13280 bytes left
[    0.288039] PCI: Using configuration type 1 for base access
[    0.433753] raid6: sse2x1    4140 MB/s
[    0.451738] raid6: sse2x2    5917 MB/s
[    0.479042] raid6: sse2x4    8921 MB/s
[    0.481016] raid6: using algorithm sse2x4 (8921 MB/s)
[    0.482018] raid6: using intx1 recovery algorithm
[    0.485603] ACPI: Added _OSI(Module Device)
[    0.486011] ACPI: Added _OSI(Processor Device)
[    0.487007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.488007] ACPI: Added _OSI(Processor Aggregator Device)
[    0.544281] ACPI: Interpreter enabled
[    0.545043] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.548042] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.551209] ACPI: (supports S0 S3 S4 S5)
[    0.552011] ACPI: Using IOAPIC for interrupt routing
[    0.553232] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.663369] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.664133] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.666075] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.673538] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.688092] PCI host bridge to bus 0000:00
[    0.689032] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.690028] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.691020] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.692040] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.693020] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.694155] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.698833] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.704297] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.708359] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.710413] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.711010] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.712009] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.713017] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.717446] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.719428] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.722028] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.727357] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.731054] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.734089] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.746059] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.751460] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.753000] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.753000] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.754015] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.759234] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.762016] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.766011] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.778413] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.781683] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.784015] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.799570] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.802684] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.805012] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.818085] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.821013] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.824013] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.835929] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.838017] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.841026] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.854294] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.857013] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.860011] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.885780] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.888011] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.911043] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.921630] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.927095] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.931467] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.934439] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.946000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.947000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.947000] vgaarb: loaded
[    0.947000] vgaarb: bridge control possible 0000:00:02.0
[    0.962750] SCSI subsystem initialized
[    0.963466] libata version 3.00 loaded.
[    0.965622] ACPI: bus type USB registered
[    0.967601] usbcore: registered new interface driver usbfs
[    0.969333] usbcore: registered new interface driver hub
[    0.971188] usbcore: registered new device driver usb
[    0.974516] pps_core: LinuxPPS API ver. 1 registered
[    0.976013] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.977306] PTP clock support registered
[    0.979524] wmi: Mapper loaded
[    0.981317] Advanced Linux Sound Architecture Driver Initialized.
[    0.982000] PCI: Using ACPI for IRQ routing
[    0.982000] PCI: pci_cache_line_size set to 64 bytes
[    0.982000] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.982000] e820: reserve RAM buffer [mem 0x167fe000-0x17ffffff]
[    0.998707] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.999174] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.001595] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.006281] Switched to clocksource kvm-clock
[    1.375238] pnp: PnP ACPI init
[    1.376921] ACPI: bus type PNP registered
[    1.378847] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.382253] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.384433] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.387595] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.389590] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.392792] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.397266] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.399768] pnp 00:03: [dma 2]
[    1.401880] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.404449] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.407903] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.410256] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.426892] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.429567] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    1.432774] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.461786] pnp: PnP ACPI: found 7 devices
[    1.463044] ACPI: bus type PNP unregistered
[    1.561193] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.562827] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.564348] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.565969] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.581484] NET: Registered protocol family 2
[    1.584736] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.586905] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.589721] TCP: Hash tables configured (established 4096 bind 4096)
[    1.591539] TCP: reno registered
[    1.592718] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.594434] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.597109] NET: Registered protocol family 1
[    1.612398] RPC: Registered named UNIX socket transport module.
[    1.614026] RPC: Registered udp transport module.
[    1.615324] RPC: Registered tcp transport module.
[    1.616759] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.618543] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.620127] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.621674] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.623279] pci 0000:00:02.0: Boot video device
[    1.624791] PCI: CLS 0 bytes, default 64
[    1.640003] Trying to unpack rootfs image as initramfs...
[    3.535613] Freeing initrd memory: 23484K (ffff880015101000 - ffff880016=
7f0000)
[    3.539126] kvm: no hardware support
[    3.542670] Machine check injector initialized
[    3.544893] microcode: CPU0 sig=3D0x663, pf=3D0x1, revision=3D0x1
[    3.546708] microcode: CPU1 sig=3D0x663, pf=3D0x1, revision=3D0x1
[    3.549167] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.557316] Scanning for low memory corruption every 60 seconds
[    3.577176] futex hash table entries: 512 (order: 4, 65536 bytes)
[    3.579243] audit: initializing netlink subsys (disabled)
[    3.581165] audit: type=3D2000 audit(1407539812.480:1): initialized
[    3.597049] Kprobe smoke test started
[    3.730148] Kprobe smoke test passed successfully
[    3.735175] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.063037] NFS: Registering the id_resolver key type
[    4.064679] Key type id_resolver registered
[    4.066002] Key type id_legacy registered
[    4.067312] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.100915] fuse init (API version 7.23)
[    4.110129] JFS: nTxBlock =3D 2496, nTxLock =3D 19970
[    4.114103] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    4.141706] 9p: Installing v9fs 9p2000 file system support
[    4.153447] NILFS version 2 loaded
[    4.154736] msgmni has been set to 624
[    4.175776] async_tx: api initialized (async)
[    4.177552] bounce: pool size: 64 pages
[    4.180694] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.183645] io scheduler noop registered
[    4.185074] io scheduler deadline registered
[    4.202811] io scheduler cfq registered (default)
[    4.204359] start plist test
[    4.207287] end plist test
[    4.208386] list_sort_test: start testing list_sort()
[    4.230678] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.235532] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.238206] ACPI: Power Button [PWRF]
[    4.257521] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.288863] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.290545] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    4.319239] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.320792] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    4.351339] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.381869] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.543404] tsc: Refined TSC clocksource calibration: 2693.405 MHz
[    5.086370] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.129099] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.152805] Initializing Nozomi driver 2.1d
[    5.157405] Non-volatile memory driver v1.3
[    5.159505] Linux agpgart interface v0.103
[    5.161603] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.164056] Hangcheck: Using getrawmonotonic().
[    5.165661] [drm] Initialized drm 1.1.0 20060810
[    5.170938] Floppy drive(s): fd0 is 1.44M
[    5.193807] FDC 0 is a S82078B
[    5.283941] brd: module loaded
[    5.356426] loop: module loaded
[    5.369727] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    5.371272] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    5.378522]  vda: unknown partition table
[    5.383816] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    5.385389] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    5.399641]  vdb: unknown partition table
[    5.404872] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    5.406522] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    5.419668]  vdc: unknown partition table
[    5.424503] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    5.426087] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    5.439881]  vdd: unknown partition table
[    5.445391] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    5.446912] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    5.459441]  vde: unknown partition table
[    5.464648] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    5.466224] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    5.472359]  vdf: unknown partition table
[    5.478360] lkdtm: No crash points registered, enable through debugfs
[    5.480388] Uniform Multi-Platform E-IDE driver
[    5.482322] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.484253] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    5.488043]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.489431]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.490716] Probing IDE interface ide0...
[    6.012616] Probing IDE interface ide1...
[    6.686248] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.300774] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.303269] hdc: MWDMA2 mode selected
[    7.304807] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.306372] ide1 at 0x170-0x177,0x376 on irq 15
[    7.328690] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    7.331396] ide-gd driver 1.18
[    7.333421] Loading iSCSI transport class v2.0-870.
[    7.358668] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.360312] Detecting Adaptec I2O RAID controllers...
[    7.362520] Adaptec aacraid driver 1.2-0[30300]-ms
[    7.364381] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.382639] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    7.386414] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.07.00.08-k.
[    7.398429] iscsi: registered transport (qla4xxx)
[    7.400253] QLogic iSCSI HBA Driver
[    7.402208] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    7.406261] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    7.408619] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    7.411001] mpt2sas version 16.100.00.00 loaded
[    7.413767] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.439598] tun: Universal TUN/TAP device driver, 1.6
[    7.441020] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.448245] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    7.449773] Copyright (c) 2007 Atheros Corporation.
[    7.455543] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March =
14, 2014)
[    7.471722] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.473333] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.475223] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    7.476998] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    8.060816] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    8.062774] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    8.065158] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    8.068585] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    8.073555] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    8.075324] igb: Copyright (c) 2007-2014 Intel Corporation.
[    8.081605] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    8.084103] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    8.086224] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.19.1-k
[    8.088654] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    8.090759] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    8.092553] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    8.094865] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    8.097206] sky2: driver version 1.30
[    8.100486] usbcore: registered new interface driver catc
[    8.102506] usbcore: registered new interface driver kaweth
[    8.104241] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    8.107202] usbcore: registered new interface driver pegasus
[    8.111755] usbcore: registered new interface driver rtl8150
[    8.113842] usbcore: registered new interface driver asix
[    8.137272] usbcore: registered new interface driver ax88179_178a
[    8.139148] usbcore: registered new interface driver cdc_ether
[    8.140903] usbcore: registered new interface driver cdc_eem
[    8.142631] usbcore: registered new interface driver dm9601
[    8.144485] usbcore: registered new interface driver smsc75xx
[    8.159466] usbcore: registered new interface driver smsc95xx
[    8.161282] usbcore: registered new interface driver gl620a
[    8.162983] usbcore: registered new interface driver net1080
[    8.164714] usbcore: registered new interface driver plusb
[    8.188680] usbcore: registered new interface driver rndis_host
[    8.190498] usbcore: registered new interface driver cdc_subset
[    8.192431] usbcore: registered new interface driver zaurus
[    8.194169] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    8.196660] usbcore: registered new interface driver int51x1
[    8.198930] usbcore: registered new interface driver cdc_ncm
[    8.200489] Fusion MPT base driver 3.04.20
[    8.201904] Copyright (c) 1999-2008 LSI Corporation
[    8.203432] Fusion MPT SPI Host driver 3.04.20
[    8.210401] Fusion MPT FC Host driver 3.04.20
[    8.212081] Fusion MPT SAS Host driver 3.04.20
[    8.213738] Fusion MPT misc device (ioctl) driver 3.04.20
[    8.216238] mptctl: Registered with Fusion MPT base driver
[    8.217732] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    8.219482] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.221369] ehci-pci: EHCI PCI platform driver
[    8.223048] uhci_hcd: USB Universal Host Controller Interface driver
[    8.227141] usbcore: registered new interface driver usb-storage
[    8.242293] usbcore: registered new interface driver ums-alauda
[    8.244094] usbcore: registered new interface driver ums-cypress
[    8.245813] usbcore: registered new interface driver ums-datafab
[    8.247978] usbcore: registered new interface driver ums-freecom
[    8.252522] usbcore: registered new interface driver ums-isd200
[    8.254399] usbcore: registered new interface driver ums-jumpshot
[    8.260201] usbcore: registered new interface driver ums-karma
[    8.262405] usbcore: registered new interface driver ums-onetouch
[    8.264599] usbcore: registered new interface driver ums-sddr09
[    8.266513] usbcore: registered new interface driver ums-sddr55
[    8.268298] usbcore: registered new interface driver ums-usbat
[    8.270441] usbcore: registered new interface driver usbserial
[    8.276659] usbcore: registered new interface driver usbserial_generic
[    8.278898] usbserial: USB Serial support registered for generic
[    8.281158] usbcore: registered new interface driver belkin_sa
[    8.283094] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    8.286710] usbcore: registered new interface driver mct_u232
[    8.288558] usbserial: USB Serial support registered for MCT U232
[    8.290763] usbcore: registered new interface driver usbtest
[    8.293910] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.302117] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.307150] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.318007] mousedev: PS/2 mouse device common for all mice
[    8.337417] rtc_cmos 00:00: RTC can wake from S4
[    8.338452] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.345955] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    8.347953] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    8.350682] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    8.356101] i6300esb: initialized (0xffffc90000396000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    8.358821] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    8.360481] iTCO_vendor_support: vendor-support=3D0
[    8.361998] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    8.373985] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    8.377496] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    8.380910] md: linear personality registered for level -1
[    8.382547] md: raid0 personality registered for level 0
[    8.384098] md: raid1 personality registered for level 1
[    8.385600] md: raid10 personality registered for level 10
[    8.388332] md: raid6 personality registered for level 6
[    8.389720] md: raid5 personality registered for level 5
[    8.391177] md: raid4 personality registered for level 4
[    8.392720] md: multipath personality registered for level -4
[    8.394259] md: faulty personality registered for level -5
[    8.400506] device-mapper: uevent: version 1.0.3
[    8.411947] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    8.424805] device-mapper: multipath: version 1.7.0 loaded
[    8.426453] device-mapper: multipath round-robin: version 1.0.0 loaded
[    8.428166] device-mapper: multipath queue-length: version 0.1.0 loaded
[    8.429872] device-mapper: multipath service-time: version 0.2.0 loaded
[    8.435473] device-mapper: dm-log-userspace: version 1.3.0 loaded
[    8.438219] usbcore: registered new interface driver usbhid
[    8.440003] usbhid: USB HID core driver
[    8.448719] dell_wmi: No known WMI GUID found
[    8.450162] acer_wmi: Acer Laptop ACPI-WMI Extras
[    8.451557] acer_wmi: No or unsupported WMI interface, unable to load
[    8.464158] oprofile: using NMI interrupt.
[    8.465765] netem: version 1.3
[    8.466974] Netfilter messages via NETLINK v0.30.
[    8.468690] nf_conntrack version 0.5.0 (2496 buckets, 9984 max)
[    8.474844] ctnetlink v0.93: registering with nfnetlink.
[    8.496809] xt_time: kernel timezone is -0000
[    8.498978] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.500972] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    8.502839] arp_tables: (C) 2002 David S. Miller
[    8.504497] TCP: bic registered
[    8.505772] TCP: cubic registered
[    8.506947] TCP: westwood registered
[    8.508158] TCP: highspeed registered
[    8.509538] TCP: hybla registered
[    8.510676] TCP: htcp registered
[    8.511871] TCP: vegas registered
[    8.513072] TCP: veno registered
[    8.514168] TCP: scalable registered
[    8.515470] TCP: lp registered
[    8.516544] TCP: yeah registered
[    8.517770] TCP: illinois registered
[    8.518982] Initializing XFRM netlink socket
[    8.541605] NET: Registered protocol family 10
[    8.556545] sit: IPv6 over IPv4 tunneling driver
[    8.560878] NET: Registered protocol family 17
[    8.562373] NET: Registered protocol family 15
[    8.565321] Bridge firewalling registered
[    8.566613] Ebtables v2.0 registered
[    8.593571] 9pnet: Installing 9P2000 support
[    8.595460] Key type dns_resolver registered
[    8.601801]=20
[    8.601801] printing PIC contents
[    8.603909] ... PIC  IMR: ffff
[    8.604859] ... PIC  IRR: 1153
[    8.606119] ... PIC  ISR: 0000
[    8.607268] ... PIC ELCR: 0c00
[    8.608351] printing local APIC contents on CPU#0/0:
[    8.609343] ... APIC ID:      00000000 (0)
[    8.609343] ... APIC VERSION: 00050014
[    8.609343] ... APIC TASKPRI: 00000000 (00)
[    8.609343] ... APIC PROCPRI: 00000000
[    8.609343] ... APIC LDR: 01000000
[    8.609343] ... APIC DFR: ffffffff
[    8.609343] ... APIC SPIV: 000001ff
[    8.609343] ... APIC ISR field:
[    8.609343] 000000000000000000000000000000000000000000000000000000000000=
0000
[    8.609343] ... APIC TMR field:
[    8.609343] 000000000200000000000000000000000000000000000000000000000000=
0000
[    8.609343] ... APIC IRR field:
[    8.609343] 000000000000000000000000000000000000000000000000000000000000=
8000
[    8.609343] ... APIC ESR: 00000000
[    8.609343] ... APIC ICR: 000008fd
[    8.609343] ... APIC ICR2: 02000000
[    8.609343] ... APIC LVTT: 000000ef
[    8.609343] ... APIC LVTPC: 00010000
[    8.609343] ... APIC LVT0: 00010700
[    8.609343] ... APIC LVT1: 00000400
[    8.609343] ... APIC LVTERR: 000000fe
[    8.609343] ... APIC TMICT: 0000edc1
[    8.609343] ... APIC TMCCT: 00000000
[    8.609343] ... APIC TDCR: 00000003
[    8.609343]=20
[    8.660320] number of MP IRQ sources: 15.
[    8.661689] number of IO-APIC #0 registers: 24.
[    8.662985] testing the IO APIC.......................
[    8.664509] IO APIC #0......
[    8.665596] .... register #00: 00000000
[    8.666794] .......    : physical APIC id: 00
[    8.668176] .......    : Delivery Type: 0
[    8.679549] .......    : LTS          : 0
[    8.680850] .... register #01: 00170011
[    8.682108] .......     : max redirection entries: 17
[    8.683536] .......     : PRQ implemented: 0
[    8.684852] .......     : IO APIC version: 11
[    8.686223] .... register #02: 00000000
[    8.687415] .......     : arbitration: 00
[    8.688812] .... IRQ redirection table:
[    8.695556] 1    0    0   0   0    0    0    00
[    8.700026] 0    0    0   0   0    1    1    31
[    8.701359] 0    0    0   0   0    1    1    30
[    8.706168] 0    0    0   0   0    1    1    33
[    8.707594] 1    0    0   0   0    1    1    34
[    8.708927] 1    1    0   0   0    1    1    35
[    8.712008] 0    0    0   0   0    1    1    36
[    8.718727] 0    0    0   0   0    1    1    37
[    8.720163] 0    0    0   0   0    1    1    38
[    8.721482] 0    1    0   0   0    1    1    39
[    8.726257] 1    1    0   0   0    1    1    3A
[    8.727791] 1    1    0   0   0    1    1    3B
[    8.730978] 0    0    0   0   0    1    1    3C
[    8.734752] 0    0    0   0   0    1    1    3D
[    8.739245] 0    0    0   0   0    1    1    3E
[    8.740600] 0    0    0   0   0    1    1    3F
[    8.741937] 1    0    0   0   0    0    0    00
[    8.746806] 1    0    0   0   0    0    0    00
[    8.748143] 1    0    0   0   0    0    0    00
[    8.751146] 1    0    0   0   0    0    0    00
[    8.755141] 1    0    0   0   0    0    0    00
[    8.776308] 1    0    0   0   0    0    0    00
[    8.777705] 1    0    0   0   0    0    0    00
[    8.783986] 1    0    0   0   0    0    0    00
[    8.787169] IRQ to pin mappings:
[    8.790318] IRQ0 -> 0:2
[    8.791915] IRQ1 -> 0:1
[    8.795394] IRQ3 -> 0:3
[    8.796659] IRQ4 -> 0:4
[    8.797839] IRQ5 -> 0:5
[    8.803039] IRQ6 -> 0:6
[    8.804249] IRQ7 -> 0:7
[    8.805430] IRQ8 -> 0:8
[    8.810122] IRQ9 -> 0:9
[    8.811379] IRQ10 -> 0:10
[    8.814956] IRQ11 -> 0:11
[    8.819312] IRQ12 -> 0:12
[    8.820543] IRQ13 -> 0:13
[    8.821755] IRQ14 -> 0:14
[    8.826533] IRQ15 -> 0:15
[    8.827830] .................................... done.
[    8.834278] registered taskstats version 1
[    8.877163] Btrfs loaded
[    8.882983]   Magic number: 10:148:268
[    8.884835] tty ttyud: hash matches
[    8.887762] console [netcon0] enabled
[    8.889290] netconsole: network logging started
[    8.903155] rtc_cmos 00:00: setting system clock to 2014-08-09 07:16:58 =
UTC (1407568618)
[    8.928294] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.999613] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   10.919865] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[   10.923462] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.934133] Sending DHCP requests ., OK
[   10.943085] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[   10.946596] IP-Config: Complete:
[   10.947842]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[   10.950869]      host=3Dvm-vp-quantal-x86_64-47, domain=3D, nis-domain=
=3D(none)
[   10.952729]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[   10.953831]      nameserver0=3D10.0.2.3
[   10.956380] PM: Hibernation image not present or could not be loaded.
[   10.961233] ALSA device list:
[   10.964236]   No soundcards found.
[   11.012460] Freeing unused kernel memory: 3352K (ffffffff82230000 - ffff=
ffff82576000)
[   11.045492] random: init urandom read with 11 bits of entropy available
[   11.372591] init: Failed to create pty - disabling logging for job
[   11.374397] init: Temporary process spawn error: No space left on device
[   22.073448] Out of memory: Kill process 3004 (rc) score 9 or sacrifice c=
hild
[   22.074696] Killed process 3022 (S77lkp-bootstra) total-vm:17932kB, anon=
-rss:324kB, file-rss:2480kB
[   22.221505] Out of memory: Kill process 3004 (rc) score 9 or sacrifice c=
hild
[   22.222729] Killed process 4847 (S99ondemand) total-vm:18036kB, anon-rss=
:388kB, file-rss:2528kB
[   22.706262] Out of memory: Kill process 3004 (rc) score 9 or sacrifice c=
hild
[   22.707560] Killed process 4982 (S99rc.local) total-vm:18036kB, anon-rss=
:380kB, file-rss:2416kB
[   22.711946] Out of memory: Kill process 3004 (rc) score 9 or sacrifice c=
hild
[   22.787774] Out of memory: Kill process 4984 (ondemand) score 9 or sacri=
fice child
[   22.794428] Killed process 5034 (sleep) total-vm:4312kB, anon-rss:76kB, =
file-rss:656kB
[   22.807830] Out of memory: Kill process 4984 (ondemand) score 9 or sacri=
fice child
[   22.809554] Killed process 4984 (ondemand) total-vm:18092kB, anon-rss:37=
2kB, file-rss:2580kB
Kernel tests: Boot OK!
[   22.852589] Out of memory: Kill process 1951 (plymouthd) score 8 or sacr=
ifice child
[   22.854671] Killed process 1951 (plymouthd) total-vm:49432kB, anon-rss:3=
44kB, file-rss:2336kB
[   22.887466] Out of memory: Kill process 3013 (getty) score 6 or sacrific=
e child
[   22.890218] Killed process 3013 (getty) total-vm:12908kB, anon-rss:160kB=
, file-rss:1816kB
[   22.912743] Out of memory: Kill process 3005 (getty) score 5 or sacrific=
e child
[   22.915119] Killed process 3005 (getty) total-vm:12908kB, anon-rss:168kB=
, file-rss:1768kB
[   22.943290] Out of memory: Kill process 3015 (getty) score 5 or sacrific=
e child
[   22.958705] Killed process 3015 (getty) total-vm:12908kB, anon-rss:164kB=
, file-rss:1764kB
[   22.986338] Out of memory: Kill process 3008 (getty) score 5 or sacrific=
e child
[   22.988674] Killed process 3008 (getty) total-vm:12908kB, anon-rss:164kB=
, file-rss:1756kB
[   23.006604] Out of memory: Kill process 5067 (getty) score 5 or sacrific=
e child
[   23.006609] Killed process 5067 (getty) total-vm:12912kB, anon-rss:152kB=
, file-rss:1708kB
[   23.032262] Out of memory: Kill process 5032 (getty) score 5 or sacrific=
e child
[   23.034575] Killed process 5032 (getty) total-vm:12908kB, anon-rss:168kB=
, file-rss:1672kB
[   23.077286] Out of memory: Kill process 5064 (getty) score 5 or sacrific=
e child
[   23.080041] Killed process 5064 (getty) total-vm:12908kB, anon-rss:168kB=
, file-rss:1660kB
[   23.103645] Out of memory: Kill process 5073 (getty) score 5 or sacrific=
e child
[   23.105957] Killed process 5073 (getty) total-vm:12908kB, anon-rss:172kB=
, file-rss:1760kB
[   23.113872] Out of memory: Kill process 3010 (getty) score 5 or sacrific=
e child
[   23.116744] Killed process 3010 (getty) total-vm:12908kB, anon-rss:172kB=
, file-rss:1652kB
[   23.161950] Out of memory: Kill process 5077 (getty) score 6 or sacrific=
e child
[   23.164242] Killed process 5077 (getty) total-vm:12908kB, anon-rss:168kB=
, file-rss:1812kB
[   23.174334] Out of memory: Kill process 5081 (getty) score 5 or sacrific=
e child
[   23.176711] Killed process 5081 (getty) total-vm:12908kB, anon-rss:168kB=
, file-rss:1704kB
[   23.195713] Out of memory: Kill process 3028 (sleep) score 2 or sacrific=
e child
[   23.198178] Killed process 3028 (sleep) total-vm:4312kB, anon-rss:80kB, =
file-rss:660kB
[   23.219934] Out of memory: Kill process 2839 (upstart-socket-) score 0 o=
r sacrifice child
[   23.222395] Killed process 2839 (upstart-socket-) total-vm:15192kB, anon=
-rss:184kB, file-rss:0kB
[   23.227455] Out of memory: Kill process 2015 (upstart-udev-br) score 0 o=
r sacrifice child
[   23.229876] Killed process 2015 (upstart-udev-br) total-vm:17236kB, anon=
-rss:168kB, file-rss:0kB
[   23.253889] Kernel panic - not syncing: Out of memory and no killable pr=
ocesses...
[   23.253889]=20

Elapsed time: 30
qemu-system-x86_64 -enable-kvm -kernel /kernel/x86_64-nfsroot/d58d631b474c5=
52dce72da2dce9dd276d731b79a/vmlinuz-3.16.0-00918-gd58d631 -append 'user=3Dl=
kp job=3D/lkp/scheduled/vm-vp-quantal-x86_64-47/bisect_boot-1-x86_64-nfsroo=
t-d58d631b474c552dce72da2dce9dd276d731b79a-4.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-nfsroot/d58d631b474c552dce72da2dce9dd276d731b79a/vmlinuz-=
3.16.0-00918-gd58d631 kconfig=3Dx86_64-nfsroot commit=3Dd58d631b474c552dce7=
2da2dce9dd276d731b79a initrd=3D/kernel-tests/initrd/quantal-core-x86_64.cgz=
 root=3D/dev/ram0 lkp_initrd=3D/lkp/lkp/lkp-x86_64.cgz modules_initrd=3D/ke=
rnel/x86_64-nfsroot/d58d631b474c552dce72da2dce9dd276d731b79a/modules.cgz RE=
SULT_ROOT=3D/result/vm-vp-quantal-x86_64/boot/1/x86_64-nfsroot/d58d631b474c=
552dce72da2dce9dd276d731b79a/0 ip=3D::::vm-vp-quantal-x86_64-47::dhcp oops=
=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled=
 rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_w=
atchdog=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 =
console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8'  -initrd /fs/sde1/init=
rd-vm-vp-quantal-x86_64-47 -m 360 -smp 2 -net nic,vlan=3D1,model=3De1000 -n=
et user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -drive file=3D/fs/sde1/disk0-vm-vp-quantal-x86_64-47,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/sde1/disk1-vm-vp-quantal-x86_64-47,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk2-vm-vp-quantal-x86_64-47,me=
dia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk3-vm-vp-quantal-x86_64-47=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk4-vm-vp-quantal-x86_64=
-47,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk5-vm-vp-quantal-x86=
_64-47,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vm-vp-quantal-x=
86_64-47 -serial file:/dev/shm/kboot/serial-vm-vp-quantal-x86_64-47 -daemon=
ize -display none -monitor null=20

--tThc/1wpZn/ma/RB--
