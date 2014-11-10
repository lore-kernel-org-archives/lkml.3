Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKJFie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:38:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:64421 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaKJFid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:38:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,350,1413270000"; 
   d="scan'208";a="619784616"
Date: Mon, 10 Nov 2014 13:39:00 +0800
From: lkp@01.org
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [x86, irq] BUG: kernel boot hang
Message-ID: <20141110053900.GB1705@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

FYI, we noticed the below changes on

https://github.com/jiangliu/linux.git irqdomain/p4v1
commit e530b4be849e7c865c95f25008eb52b72ec96341 ("x86, irq: Use cached IOAP=
IC entry instead of reading from hardware")


+----------------------+------------+------------+
|                      | ff34368973 | e530b4be84 |
+----------------------+------------+------------+
| boot_successes       | 10         | 1          |
| boot_failures        | 0          | 14         |
| BUG:kernel_boot_hang | 0          | 14         |
+----------------------+------------+------------+


[  302.136037] Waiting up to 20 more seconds for network.
[  312.136042] Waiting up to 10 more seconds for network.

BUG: kernel boot hang
Elapsed time: 310
qemu-system-x86_64 -enable-kvm -cpu Westmere -kernel /kernel/x86_64-lkp/dfc=
6ac916357d686ca861cb0a996ed85413d5d00/vmlinuz-3.18.0-rc3-00128-gdfc6ac9 -ap=
pend 'user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yocto-ia32-31/rand_boot-1-y=
octo-minimal-i386.cgz-x86_64-lkp-dfc6ac916357d686ca861cb0a996ed85413d5d00-1=
=2Eyaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/dfc6ac916357d686ca861=
cb0a996ed85413d5d00/vmlinuz-3.18.0-rc3-00128-gdfc6ac9 kconfig=3Dx86_64-lkp =
commit=3Ddfc6ac916357d686ca861cb0a996ed85413d5d00 branch=3Dlinux-devel/deve=
l-roam-lkp-201411081809 root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/r=
esult/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86_64-lkp/dfc6ac9=
16357d686ca861cb0a996ed85413d5d00/0 ip=3D::::vm-kbuild-yocto-ia32-31::dhcp =
earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate=
=2Ercu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8'  -initrd /fs/sdh=
1/initrd-vm-kbuild-yocto-ia32-31 -m 320 -smp 1 -net nic,vlan=3D1,model=3De1=
000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc =
base=3Dlocaltime -drive file=3D/fs/sdh1/disk0-vm-kbuild-yocto-ia32-31,media=
=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vm-kbuild-yocto-ia32-31 -se=
rial file:/dev/shm/kboot/serial-vm-kbuild-yocto-ia32-31 -daemonize -display=
 none -monitor null=20

Thanks,
Fengguang

--TakKZr9L6Hm6aLOc
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
[    0.000000] Linux version 3.18.0-rc3-00128-gdfc6ac9 (kbuild@roam) (gcc v=
ersion 4.9.1 (Debian 4.9.1-19) ) #41 SMP Sat Nov 8 18:13:44 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-ia32-31/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-dfc6ac916357d686ca8=
61cb0a996ed85413d5d00-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/=
dfc6ac916357d686ca861cb0a996ed85413d5d00/vmlinuz-3.18.0-rc3-00128-gdfc6ac9 =
kconfig=3Dx86_64-lkp commit=3Ddfc6ac916357d686ca861cb0a996ed85413d5d00 bran=
ch=3Dlinux-devel/devel-roam-lkp-201411081809 root=3D/dev/ram0 max_uptime=3D=
3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.c=
gz/x86_64-lkp/dfc6ac916357d686ca861cb0a996ed85413d5d00/0 ip=3D::::vm-kbuild=
-yocto-ia32-31::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_al=
ways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_pan=
ic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
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
[    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at =
[ffff8800000fdaf0]
[    0.000000]   mpc: fdb00-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02468000, 0x02468fff] PGTABLE
[    0.000000] BRK [0x02469000, 0x02469fff] PGTABLE
[    0.000000] BRK [0x0246a000, 0x0246afff] PGTABLE
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
[    0.000000] BRK [0x0246b000, 0x0246bfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13b20000-0x13feffff]
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
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ffa000-0x13ffdfff]
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
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
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
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s81920 r8192=
 d28672 u2097152
[    0.000000] pcpu-alloc: s81920 r8192 d28672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-ia32-31/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-dfc6ac916357=
d686ca861cb0a996ed85413d5d00-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_=
64-lkp/dfc6ac916357d686ca861cb0a996ed85413d5d00/vmlinuz-3.18.0-rc3-00128-gd=
fc6ac9 kconfig=3Dx86_64-lkp commit=3Ddfc6ac916357d686ca861cb0a996ed85413d5d=
00 branch=3Dlinux-devel/devel-roam-lkp-201411081809 root=3D/dev/ram0 max_up=
time=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal=
-i386.cgz/x86_64-lkp/dfc6ac916357d686ca861cb0a996ed85413d5d00/0 ip=3D::::vm=
-kbuild-yocto-ia32-31::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug s=
ysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softloc=
kup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ram=
disk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_c=
ount=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 294804K/327280K available (10213K kernel code, 1385K=
 rwdata, 4324K rodata, 1448K init, 1624K bss, 32476K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc3-00128-gdfc6ac9 (kbuild@roam) (gcc v=
ersion 4.9.1 (Debian 4.9.1-19) ) #41 SMP Sat Nov 8 18:13:44 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-ia32-31/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-dfc6ac916357d686ca8=
61cb0a996ed85413d5d00-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/=
dfc6ac916357d686ca861cb0a996ed85413d5d00/vmlinuz-3.18.0-rc3-00128-gdfc6ac9 =
kconfig=3Dx86_64-lkp commit=3Ddfc6ac916357d686ca861cb0a996ed85413d5d00 bran=
ch=3Dlinux-devel/devel-roam-lkp-201411081809 root=3D/dev/ram0 max_uptime=3D=
3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.c=
gz/x86_64-lkp/dfc6ac916357d686ca861cb0a996ed85413d5d00/0 ip=3D::::vm-kbuild=
-yocto-ia32-31::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_al=
ways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_pan=
ic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
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
[    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at =
[ffff8800000fdaf0]
[    0.000000]   mpc: fdb00-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02468000, 0x02468fff] PGTABLE
[    0.000000] BRK [0x02469000, 0x02469fff] PGTABLE
[    0.000000] BRK [0x0246a000, 0x0246afff] PGTABLE
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
[    0.000000] BRK [0x0246b000, 0x0246bfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13b20000-0x13feffff]
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
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ffa000-0x13ffdfff]
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
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
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
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s81920 r8192=
 d28672 u2097152
[    0.000000] pcpu-alloc: s81920 r8192 d28672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-ia32-31/rand_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-dfc6ac916357=
d686ca861cb0a996ed85413d5d00-1.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_=
64-lkp/dfc6ac916357d686ca861cb0a996ed85413d5d00/vmlinuz-3.18.0-rc3-00128-gd=
fc6ac9 kconfig=3Dx86_64-lkp commit=3Ddfc6ac916357d686ca861cb0a996ed85413d5d=
00 branch=3Dlinux-devel/devel-roam-lkp-201411081809 root=3D/dev/ram0 max_up=
time=3D3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal=
-i386.cgz/x86_64-lkp/dfc6ac916357d686ca861cb0a996ed85413d5d00/0 ip=3D::::vm=
-kbuild-yocto-ia32-31::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug s=
ysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softloc=
kup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ram=
disk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_c=
ount=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 294804K/327280K available (10213K kernel code, 1385K=
 rwdata, 4324K rodata, 1448K init, 1624K bss, 32476K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 16
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
[    0.008785] pid_max: default: 32768 minimum: 301
[    0.009872] ACPI: Core revision 20140926
[    0.013827] ACPI: All ACPI Tables successfully acquired
[    0.017038] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.018869] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.020081] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.021983] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.024300] Initializing cgroup subsys memory
[    0.028016] Initializing cgroup subsys devices
[    0.032011] Initializing cgroup subsys freezer
[    0.036020] Initializing cgroup subsys blkio
[    0.040013] Initializing cgroup subsys perf_event
[    0.044016] Initializing cgroup subsys hugetlb
[    0.048149] mce: CPU supports 10 MCE banks
[    0.049844] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.049844] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.104245] Freeing SMP alternatives memory: 40K (ffffffff822c6000 - fff=
fffff822d0000)
[    0.117071] ftrace: allocating 39716 entries in 156 pages
[    0.140123] Getting VERSION: 50014
[    0.141703] Getting VERSION: 50014
[    0.143070] Getting ID: 0
[    0.144018] Getting ID: ff000000
[    0.145418] Getting LVT0: 8700
[    0.146773] Getting LVT1: 8400
[    0.148096] enabled ExtINT on CPU#0
[    0.150635] ENABLING IO-APIC IRQs
[    0.152024] init IO_APIC IRQs
[    0.156008]  apic 0 pin 0 not connected
[    0.157403] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.160016] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.164000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.164000]  apic 0 pin 16 not connected
[    0.164000]  apic 0 pin 17 not connected
[    0.164000]  apic 0 pin 18 not connected
[    0.164000]  apic 0 pin 19 not connected
[    0.164000]  apic 0 pin 20 not connected
[    0.164000]  apic 0 pin 21 not connected
[    0.164000]  apic 0 pin 22 not connected
[    0.164000]  apic 0 pin 23 not connected
[    0.164000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.164000] smpboot: CPU0: Intel Westmere E56xx/L56xx/X56xx (Nehalem-C) =
(fam: 06, model: 2c, stepping: 01)
[    0.164010] Using local APIC timer interrupts.
[    0.164010] calibrating APIC timer ...
[    0.172000] ... lapic delta =3D 6667326
[    0.172000] ... PM-Timer delta =3D 381833
[    0.172000] APIC calibration not consistent with PM-Timer: 106ms instead=
 of 100ms
[    0.172000] APIC delta adjusted to PM-Timer: 6250366 (6667326)
[    0.172000] TSC delta adjusted to PM-Timer: 263157460 (280712613)
[    0.172000] ..... delta 6250366
[    0.172000] ..... mult: 268451175
[    0.172000] ..... calibration result: 4000234
[    0.172000] ..... CPU clock speed is 2631.2298 MHz.
[    0.172000] ..... host bus clock speed is 1000.0234 MHz.
[    0.172097] Performance Events: unsupported p6 CPU model 44 no PMU drive=
r, software events only.
[    0.177263] x86: Booted up 1 node, 1 CPUs
[    0.178751] smpboot: Total of 1 processors activated (5386.90 BogoMIPS)
[    0.180231] devtmpfs: initialized
[    0.194344] xor: measuring software checksum speed
[    0.248041]    prefetch64-sse:   113.000 MB/sec
[    0.296028]    generic_sse:   111.000 MB/sec
[    0.297566] xor: using function: prefetch64-sse (113.000 MB/sec)
[    0.299497] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.300413] NET: Registered protocol family 16
[    0.304983] cpuidle: using governor ladder
[    0.308094] cpuidle: using governor menu
[    0.310210] ACPI: bus type PCI registered
[    0.312009] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.316994] PCI: Using configuration type 1 for base access
[    0.400013] raid6: sse2x1    3621 MB/s
[    0.468017] raid6: sse2x2    6303 MB/s
[    0.536014] raid6: sse2x4    7383 MB/s
[    0.537503] raid6: using algorithm sse2x4 (7383 MB/s)
[    0.539230] raid6: using ssse3x2 recovery algorithm
[    0.540577] ACPI: Added _OSI(Module Device)
[    0.542148] ACPI: Added _OSI(Processor Device)
[    0.544006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.545705] ACPI: Added _OSI(Processor Aggregator Device)
[    0.550821] ACPI: Interpreter enabled
[    0.552161] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140926/hwxface-580)
[    0.556182] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[    0.564324] ACPI: (supports S0 S3 S4 S5)
[    0.568006] ACPI: Using IOAPIC for interrupt routing
[    0.569938] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.578236] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.580013] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.582077] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.588223] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.592550] acpiphp: Slot [3] registered
[    0.594111] acpiphp: Slot [4] registered
[    0.596076] acpiphp: Slot [5] registered
[    0.600309] acpiphp: Slot [6] registered
[    0.604057] acpiphp: Slot [7] registered
[    0.605611] acpiphp: Slot [8] registered
[    0.608183] acpiphp: Slot [9] registered
[    0.609741] acpiphp: Slot [10] registered
[    0.612077] acpiphp: Slot [11] registered
[    0.616231] acpiphp: Slot [12] registered
[    0.618302] acpiphp: Slot [13] registered
[    0.620057] acpiphp: Slot [14] registered
[    0.621639] acpiphp: Slot [15] registered
[    0.624292] acpiphp: Slot [24] registered
[    0.625850] acpiphp: Slot [25] registered
[    0.628170] acpiphp: Slot [26] registered
[    0.632075] acpiphp: Slot [27] registered
[    0.633630] acpiphp: Slot [28] registered
[    0.636147] acpiphp: Slot [29] registered
[    0.637718] acpiphp: Slot [30] registered
[    0.639299] acpiphp: Slot [31] registered
[    0.640045] PCI host bridge to bus 0000:00
[    0.644100] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.645909] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.648133] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.650073] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.652145] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.654756] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.656697] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.660885] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.669246] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    0.672375] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.674484] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.676025] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.680019] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.684468] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.688017] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.690817] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.692383] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.696943] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.701697] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.713782] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.718148] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.721523] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.725189] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.733201] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.735665] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.737361] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.741322] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.750824] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.752678] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    0.760549] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.763225] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.765850] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.768273] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.770748] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.773761] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.776406] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.780000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.780034] vgaarb: loaded
[    0.781334] vgaarb: bridge control possible 0000:00:02.0
[    0.784447] SCSI subsystem initialized
[    0.786195] libata version 3.00 loaded.
[    0.788143] ACPI: bus type USB registered
[    0.789961] usbcore: registered new interface driver usbfs
[    0.792106] usbcore: registered new interface driver hub
[    0.794002] usbcore: registered new device driver usb
[    0.795826] pps_core: LinuxPPS API ver. 1 registered
[    0.796021] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.800059] PTP clock support registered
[    0.808307] EDAC MC: Ver: 3.0.0
[    0.810094] PCI: Using ACPI for IRQ routing
[    0.812019] PCI: pci_cache_line_size set to 64 bytes
[    0.813895] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.816020] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.821398] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.824169] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.828022] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.840688] Switched to clocksource kvm-clock
[    0.889267] pnp: PnP ACPI init
[    0.890766] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.893089] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.895229] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.897415] pnp 00:03: [dma 2]
[    0.898809] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.901003] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.909421] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.911589] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.913950] pnp: PnP ACPI: found 7 devices
[    0.923987] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.925859] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.927685] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.929684] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.931743] NET: Registered protocol family 2
[    0.933801] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.935950] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[    0.938005] TCP: Hash tables configured (established 4096 bind 4096)
[    0.940161] TCP: reno registered
[    0.941556] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.943419] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.945621] NET: Registered protocol family 1
[    0.947472] RPC: Registered named UNIX socket transport module.
[    0.949395] RPC: Registered udp transport module.
[    0.951029] RPC: Registered tcp transport module.
[    0.953370] RPC: Registered tcp NFSv4.1 backchannel transport module
--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--TakKZr9L6Hm6aLOc--
