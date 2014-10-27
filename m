Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaJ0CRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:17:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:30582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaJ0CQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:16:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406456983"
Date: Mon, 27 Oct 2014 10:17:23 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [virtio_blk] kernel BUG at drivers/virtio/virtio.c:116!
Message-ID: <20141027021723.GG27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6e7ZaeXHKrTJCxdu"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-next
commit 067da47bd4572e15532e303b6ced799540654589 ("virtio_blk: v1.0 support")


+------------------------------------------+------------+------------+
|                                          | bea3a62baf | 067da47bd4 |
+------------------------------------------+------------+------------+
| boot_successes                           | 15         | 10         |
| early-boot-hang                          | 1          |            |
| boot_failures                            | 0          | 5          |
| kernel_BUG_at_drivers/virtio/virtio.c    | 0          | 5          |
| invalid_opcode                           | 0          | 5          |
| RIP:virtio_check_driver_offered_feature  | 0          | 5          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 5          |
| backtrace:init                           | 0          | 5          |
| backtrace:kernel_init_freeable           | 0          | 5          |
+------------------------------------------+------------+------------+





Thanks,
Fengguang

--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc1-g84d2686 (kbuild@xian) (gcc version=
 4.9.1 (Debian 4.9.1-11) ) #159 SMP Fri Oct 24 01:28:28 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-x86_64-62/rand_boot-performance-1-yocto-minimal-x86_64.cgz-x86_64-nfsroot=
-84d2686f2c283d54b7574fcfba9727306328942a-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-nfsroot/84d2686f2c283d54b7574fcfba9727306328942a/vmlinuz-=
3.18.0-rc1-g84d2686 kconfig=3Dx86_64-nfsroot commit=3D84d2686f2c283d54b7574=
fcfba9727306328942a branch=3Dlinux-devel/devel-xian-x86_64-201410240123 roo=
t=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-x86_6=
4/boot/performance-1/yocto-minimal-x86_64.cgz/x86_64-nfsroot/84d2686f2c283d=
54b7574fcfba9727306328942a/0 ip=3D::::vm-kbuild-yocto-x86_64-62::dhcp early=
printk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_=
cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpani=
c oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at =
[ffff8800000fdaf0]
[    0.000000]   mpc: fdb00-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x035b8000, 0x035b8fff] PGTABLE
[    0.000000] BRK [0x035b9000, 0x035b9fff] PGTABLE
[    0.000000] BRK [0x035ba000, 0x035bafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x035bb000, 0x035bbfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13c44000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD990 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 479 pages/cpu @ffff880013800000 s1922560 r8=
192 d31232 u2097152
[    0.000000] pcpu-alloc: s1922560 r8192 d31232 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d340
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-x86_64-62/rand_boot-performance-1-yocto-minimal-x86_64.cgz-x86_64-=
nfsroot-84d2686f2c283d54b7574fcfba9727306328942a-0.yaml ARCH=3Dx86_64 BOOT_=
IMAGE=3D/kernel/x86_64-nfsroot/84d2686f2c283d54b7574fcfba9727306328942a/vml=
inuz-3.18.0-rc1-g84d2686 kconfig=3Dx86_64-nfsroot commit=3D84d2686f2c283d54=
b7574fcfba9727306328942a branch=3Dlinux-devel/devel-xian-x86_64-20141024012=
3 root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-=
x86_64/boot/performance-1/yocto-minimal-x86_64.cgz/x86_64-nfsroot/84d2686f2=
c283d54b7574fcfba9727306328942a/0 ip=3D::::vm-kbuild-yocto-x86_64-62::dhcp =
earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate=
=2Ercu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Memory: 275956K/327280K available (11716K kernel code, 1580K=
 rwdata, 5952K rodata, 3384K init, 15920K bss, 51324K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc1-g84d2686 (kbuild@xian) (gcc version=
 4.9.1 (Debian 4.9.1-11) ) #159 SMP Fri Oct 24 01:28:28 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-x86_64-62/rand_boot-performance-1-yocto-minimal-x86_64.cgz-x86_64-nfsroot=
-84d2686f2c283d54b7574fcfba9727306328942a-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=
=3D/kernel/x86_64-nfsroot/84d2686f2c283d54b7574fcfba9727306328942a/vmlinuz-=
3.18.0-rc1-g84d2686 kconfig=3Dx86_64-nfsroot commit=3D84d2686f2c283d54b7574=
fcfba9727306328942a branch=3Dlinux-devel/devel-xian-x86_64-201410240123 roo=
t=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-x86_6=
4/boot/performance-1/yocto-minimal-x86_64.cgz/x86_64-nfsroot/84d2686f2c283d=
54b7574fcfba9727306328942a/0 ip=3D::::vm-kbuild-yocto-x86_64-62::dhcp early=
printk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_=
cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpani=
c oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at =
[ffff8800000fdaf0]
[    0.000000]   mpc: fdb00-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x035b8000, 0x035b8fff] PGTABLE
[    0.000000] BRK [0x035b9000, 0x035b9fff] PGTABLE
[    0.000000] BRK [0x035ba000, 0x035bafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x035bb000, 0x035bbfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13c44000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD990 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 479 pages/cpu @ffff880013800000 s1922560 r8=
192 d31232 u2097152
[    0.000000] pcpu-alloc: s1922560 r8192 d31232 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d340
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-x86_64-62/rand_boot-performance-1-yocto-minimal-x86_64.cgz-x86_64-=
nfsroot-84d2686f2c283d54b7574fcfba9727306328942a-0.yaml ARCH=3Dx86_64 BOOT_=
IMAGE=3D/kernel/x86_64-nfsroot/84d2686f2c283d54b7574fcfba9727306328942a/vml=
inuz-3.18.0-rc1-g84d2686 kconfig=3Dx86_64-nfsroot commit=3D84d2686f2c283d54=
b7574fcfba9727306328942a branch=3Dlinux-devel/devel-xian-x86_64-20141024012=
3 root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-=
x86_64/boot/performance-1/yocto-minimal-x86_64.cgz/x86_64-nfsroot/84d2686f2=
c283d54b7574fcfba9727306328942a/0 ip=3D::::vm-kbuild-yocto-x86_64-62::dhcp =
earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate=
=2Ercu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Memory: 275956K/327280K available (11716K kernel code, 1580K=
 rwdata, 5952K rodata, 3384K init, 15920K bss, 51324K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
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
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5386.90 Bogo=
MIPS (lpj=3D2693452)
[    0.005009] pid_max: default: 32768 minimum: 301
[    0.007107] ACPI: Core revision 20140828
[    0.097055] ACPI: All ACPI Tables successfully acquired
[    0.099574] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.101379] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.103021] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.105071] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.110120] Initializing cgroup subsys devices
[    0.111137] Initializing cgroup subsys freezer
[    0.112054] Initializing cgroup subsys blkio
[    0.113043] Initializing cgroup subsys debug
[    0.114334] mce: CPU supports 10 MCE banks
[    0.115070] numa_add_cpu cpu 0 node 0: mask now 0
[    0.116026] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.116026] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.164689] Freeing SMP alternatives memory: 44K (ffffffff8261f000 - fff=
fffff8262a000)
[    0.173035] ftrace: allocating 46663 entries in 183 pages
[    0.194218] Getting VERSION: 1050014
[    0.195027] Getting VERSION: 1050014
[    0.196025] Getting ID: 0
[    0.197026] Getting ID: ff000000
[    0.198030] Getting LVT0: 8700
[    0.199015] Getting LVT1: 8400
[    0.200100] enabled ExtINT on CPU#0
[    0.203263] ENABLING IO-APIC IRQs
[    0.204070] init IO_APIC IRQs
[    0.205013]  apic 0 pin 0 not connected
[    0.206289] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.208079] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.209058] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.210078] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.211076] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.212082] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.213090] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.214083] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.216036] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.217087] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.218077] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.219000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.219090] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.220072] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.221078] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.222062] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.223041]  apic 0 pin 16 not connected
[    0.224010]  apic 0 pin 17 not connected
[    0.225010]  apic 0 pin 18 not connected
[    0.226009]  apic 0 pin 19 not connected
[    0.227013]  apic 0 pin 20 not connected
[    0.229008]  apic 0 pin 21 not connected
[    0.231009]  apic 0 pin 22 not connected
[    0.232007]  apic 0 pin 23 not connected
[    0.234000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.234014] smpboot: CPU0: Intel Xeon E312xx (Sandy Bridge) (fam: 06, mo=
del: 2a, stepping: 01)
[    0.237051] TSC deadline timer enabled
[    0.238000] Performance Events: unsupported p6 CPU model 42 no PMU drive=
r, software events only.
[    0.243453] x86: Booted up 1 node, 1 CPUs
[    0.244032] ----------------
[    0.245006] | NMI testsuite:
[    0.246007] --------------------
[    0.247014]   remote IPI:  ok  |
[    0.248008]    local IPI:  ok  |
[    0.249917] --------------------
[    0.250013] Good, all   2 testcases passed! |
[    0.251007] ---------------------------------
[    0.252015] smpboot: Total of 1 processors activated (5386.90 BogoMIPS)
[    0.256094] devtmpfs: initialized
[    0.275763] kworker/u2:0 (13) used greatest stack depth: 13408 bytes left
[    0.286135] xor: automatically using best checksumming function:
[    0.297031]    avx       :    88.000 MB/sec
[    0.298096] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.299598] RTC time:  1:28:06, date: 10/24/14
[    0.301093] NET: Registered protocol family 16
[    0.305572] kworker/u2:0 (17) used greatest stack depth: 13024 bytes left
[    0.308221] cpuidle: using governor ladder
[    0.309326] cpuidle: using governor menu
[    0.312531] ACPI: bus type PCI registered
[    0.315110] dca service started, version 1.12.1
[    0.316360] PCI: Using configuration type 1 for base access
[    0.517014] raid6: sse2x1    4531 MB/s
[    0.535013] raid6: sse2x2    5761 MB/s
[    0.553017] raid6: sse2x4    6613 MB/s
[    0.554008] raid6: using algorithm sse2x4 (6613 MB/s)
[    0.555007] raid6: using ssse3x2 recovery algorithm
[    0.567753] ACPI: Added _OSI(Module Device)
[    0.568017] ACPI: Added _OSI(Processor Device)
[    0.569011] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.570010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.577660] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.662318] ACPI: Interpreter enabled
[    0.663622] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140828/hwxface-580)
[    0.666274] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140828/hwxface-580)
[    0.669627] ACPI: (supports S0 S3 S4 S5)
[    0.670170] ACPI: Using IOAPIC for interrupt routing
[    0.671662] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.811852] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.812057] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.813608] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.821414] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.838504] PCI host bridge to bus 0000:00
[    0.839026] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.840563] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.841204] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.842035] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.843494] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.844278] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.849626] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.857028] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.861372] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    0.863045] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.864008] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.865008] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.866009] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.871175] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.872624] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.873025] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.879521] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.881833] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.883735] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.889806] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.895573] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.897010] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.899020] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.905011] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.912997] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.914629] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.916011] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.926792] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.928016] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    0.951274] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.957457] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.961950] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.966930] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.968895] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.975871] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.979477] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.980000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.980221] vgaarb: loaded
[    0.981007] vgaarb: bridge control possible 0000:00:02.0
[    0.985717] SCSI subsystem initialized
[    0.986840] libata version 3.00 loaded.
[    0.987726] ACPI: bus type USB registered
[    0.988704] usbcore: registered new interface driver usbfs
[    0.990519] usbcore: registered new interface driver hub
[    0.991463] usbcore: registered new device driver usb
[    0.992808] pps_core: LinuxPPS API ver. 1 registered
[    0.993007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.994419] PTP clock support registered
[    0.996820] wmi: Mapper loaded
[    0.997531] Advanced Linux Sound Architecture Driver Initialized.
[    0.998120] PCI: Using ACPI for IRQ routing
[    0.999013] PCI: pci_cache_line_size set to 64 bytes
[    1.000216] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.001041] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.008409] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.009125] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.011850] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.015266] Switched to clocksource kvm-clock
[    1.747863] pnp: PnP ACPI init
[    1.749762] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.753285] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.765922] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.769365] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.771560] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.785284] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.787846] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.790630] pnp 00:03: [dma 2]
[    1.792624] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.805558] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.808892] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.811775] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.825517] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.828270] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.831812] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.849741] pnp: PnP ACPI: found 7 devices
[    1.993354] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.005104] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.006667] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.008431] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.012310] NET: Registered protocol family 2
[    2.027955] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    2.033053] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    2.038589] TCP: Hash tables configured (established 4096 bind 4096)
[    2.044970] TCP: reno registered
[    2.049589] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    2.055744] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    2.062425] NET: Registered protocol family 1
[    2.072295] RPC: Registered named UNIX socket transport module.
[    2.083609] RPC: Registered udp transport module.
[    2.085192] RPC: Registered tcp transport module.
[    2.086695] RPC: Registered tcp NFSv4.1 backchannel transport module
--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--6e7ZaeXHKrTJCxdu--
