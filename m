Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3KYB3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 20:29:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:6630 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3KYB3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 20:29:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,764,1378882800"; 
   d="scan'208";a="433027614"
Date: Mon, 25 Nov 2013 09:29:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Shaohua Li <shli@kernel.org>
Subject: Re: kernel BUG at drivers/md/raid5.c:693!
Message-ID: <20131125012908.GA13476@localhost>
References: <20131123032205.GB20794@localhost>
 <20131125103522.6a1c1b36@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20131125103522.6a1c1b36@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 25, 2013 at 10:35:22AM +1100, NeilBrown wrote:
> On Sat, 23 Nov 2013 11:22:05 +0800 fengguang.wu@intel.com wrote:
> 
> > Shaohua,
> > 
> > FYI, we are still seeing this bug.. dmesg attached.
> 
> Thanks for the report.  However the dmesg you attached doesn't mention:
> 
>      kernel BUG at drivers/md/raid5.c:693!
> 
> at all.  It is quite different.

Sorry I attached the wrong dmesg... Here it is, for upstream commit

# bad: [6d6e352c80f22c446d933ca8103e02bac1f09129] Merge tag 'md/3.13' of git://neil.brown.name/md

Note that I didn't check if your tree or latest upstream HEAD has
included any new fixes.

Thanks,
Fengguang

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kbuildx-5:20131123014605:x86_64-lkp:3.12.0-10730-g6d6e352:63"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-10730-g6d6e352 (kbuild@cairo) (gcc vers=
ion 4.8.1 (Debian 4.8.1-8) ) #63 SMP Sat Nov 23 01:42:55 CST 2013
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx-5/bise=
ct_dd-write-4HDD-RAID5-cfq-xfs-1dd-x86_64-lkp-6d6e352c80f22c446d933ca8103e0=
2bac1f09129-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/6d6e352c80=
f22c446d933ca8103e02bac1f09129/vmlinuz-3.12.0-10730-g6d6e352 kconfig=3Dx86_=
64-lkp commit=3D6d6e352c80f22c446d933ca8103e02bac1f09129 modules_initrd=3D/=
kernel/x86_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/modules.cgz RESU=
LT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4HDD-RAID5-cfq-xfs-1dd/x86_64-=
lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/0 initrd=3D/kernel-tests/initr=
d/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-5::dhcp oops=3Dpanic log=
_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk=
 sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x420000 max_arch_pfn =3D 0x400000000
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
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02feb000, 0x02febfff] PGTABLE
[    0.000000] BRK [0x02fec000, 0x02fecfff] PGTABLE
[    0.000000] BRK [0x02fed000, 0x02fedfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x02fee000, 0x02feefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x02fef000, 0x02feffff] PGTABLE
[    0.000000] BRK [0x02ff0000, 0x02ff0fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 1044060(99%)
[    0.000000] RAMDISK: [mem 0x74396000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41f7ed000-0x41f7f1fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4:1f7e9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040ee0000=
0-ffff88041edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 4194204
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 51200 pages used for memmap
[    0.000000]   Normal zone: 3276800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
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
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f6000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88040e600000 s1920424 r8=
192 d21080 u2097152
[    0.000000] pcpu-alloc: s1920424 r8192 d21080 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3=20
[    0.000000] kvm-clock: cpu 0, msr 4:1f7e9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 40e60d240
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4128647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx=
-5/bisect_dd-write-4HDD-RAID5-cfq-xfs-1dd-x86_64-lkp-6d6e352c80f22c446d933c=
a8103e02bac1f09129-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/6d6=
e352c80f22c446d933ca8103e02bac1f09129/vmlinuz-3.12.0-10730-g6d6e352 kconfig=
=3Dx86_64-lkp commit=3D6d6e352c80f22c446d933ca8103e02bac1f09129 modules_ini=
trd=3D/kernel/x86_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/modules.c=
gz RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4HDD-RAID5-cfq-xfs-1dd/=
x86_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/0 initrd=3D/kernel-test=
s/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-5::dhcp oops=3Dpa=
nic log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic=
_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16205968K/16776816K available (10597K kernel code, 1=
392K rwdata, 5400K rodata, 3212K init, 9592K bss, 570848K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
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
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.602 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.20 Bogo=
MIPS (lpj=3D10774408)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.012047] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.032711] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.040463] Mount-cache hash table entries: 256
[    0.041822] Initializing cgroup subsys memory
[    0.042682] Initializing cgroup subsys blkio
[    0.044006] Initializing cgroup subsys perf_event
[    0.044910] Initializing cgroup subsys hugetlb
[    0.045875] mce: CPU supports 10 MCE banks
[    0.046758] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.046758] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.046758] tlb_flushall_shift: 6
[    0.048115] Freeing SMP alternatives memory: 40K (ffffffff82681000 - fff=
fffff8268b000)
[    0.055347] ACPI: Core revision 20130927
[    0.057402] ACPI: All ACPI Tables successfully acquired
[    0.058475] ftrace: allocating 39963 entries in 157 pages
[    0.072074] Getting VERSION: 50014
[    0.072815] Getting VERSION: 50014
[    0.073535] Getting ID: 0
[    0.074168] Getting ID: ff000000
[    0.074891] Getting LVT0: 8700
[    0.075576] Getting LVT1: 8400
[    0.076050] enabled ExtINT on CPU#0
[    0.077523] ENABLING IO-APIC IRQs
[    0.078271] init IO_APIC IRQs
[    0.078972]  apic 0 pin 0 not connected
[    0.080013] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.081526] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.083024] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.084018] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.085498] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.087000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.088017] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.089489] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.092018] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.093488] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.094988] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.096018] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.097516] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.100018] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.101508] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.102995]  apic 0 pin 16 not connected
[    0.103779]  apic 0 pin 17 not connected
[    0.104003]  apic 0 pin 18 not connected
[    0.104762]  apic 0 pin 19 not connected
[    0.105521]  apic 0 pin 20 not connected
[    0.106271]  apic 0 pin 21 not connected
[    0.107056]  apic 0 pin 22 not connected
[    0.108003]  apic 0 pin 23 not connected
[    0.108912] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.110083] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.112003] Using local APIC timer interrupts.
[    0.112003] calibrating APIC timer ...
[    0.116000] ... lapic delta =3D 6249994
[    0.116000] ... PM-Timer delta =3D 357960
[    0.116000] ... PM-Timer result ok
[    0.116000] ..... delta 6249994
[    0.116000] ..... mult: 268435198
[    0.116000] ..... calibration result: 3999996
[    0.116000] ..... CPU clock speed is 2693.2214 MHz.
[    0.116000] ..... host bus clock speed is 999.3996 MHz.
[    0.116071] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.120170] x86: Booting SMP configuration:
[    0.121140] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 4:1f7e9041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.136051] KVM setup async PF for cpu 1
 #2
[    0.137418] kvm-stealtime: cpu 1, msr 40e80d240
[    0.008000] kvm-clock: cpu 2, msr 4:1f7e9081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.152029] KVM setup async PF for cpu 2
 #3
[    0.153028] kvm-stealtime: cpu 2, msr 40ea0d240
[    0.008000] kvm-clock: cpu 3, msr 4:1f7e90c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3

[    0.168049] x86: Booted up 1 node, 4 CPUs
[    0.168029] KVM setup async PF for cpu 3
[    0.168029] kvm-stealtime: cpu 3, msr 40ec0d240
[    0.170905] smpboot: Total of 4 processors activated (21548.81 BogoMIPS)
[    0.172460] CPU0 attaching sched-domain:
[    0.172881]  domain 0: span 0-3 level CPU
[    0.173727]   groups: 0 1 2 3
[    0.176019] CPU1 attaching sched-domain:
[    0.176831]  domain 0: span 0-3 level CPU
[    0.177738]   groups: 1 2 3 0
[    0.178724] CPU2 attaching sched-domain:
[    0.179477]  domain 0: span 0-3 level CPU
[    0.180011]   groups: 2 3 0 1
[    0.181078] CPU3 attaching sched-domain:
[    0.181838]  domain 0: span 0-3 level CPU
[    0.182677]   groups: 3 0 1 2
[    0.188199] devtmpfs: initialized
[    0.197391] xor: measuring software checksum speed
[    0.236004]    prefetch64-sse: 14636.000 MB/sec
[    0.276002]    generic_sse: 13605.000 MB/sec
[    0.276827] xor: using function: prefetch64-sse (14636.000 MB/sec)
[    0.277900] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.279226] NET: Registered protocol family 16
[    0.280693] cpuidle: using governor ladder
[    0.280873] cpuidle: using governor menu
[    0.284430] ACPI: bus type PCI registered
[    0.285273] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.286403] PCI: Using configuration type 1 for base access
[    0.328150] bio: create slab <bio-0> at 0
[    0.396009] raid6: sse2x1    8362 MB/s
[    0.464002] raid6: sse2x2   10651 MB/s
[    0.532006] raid6: sse2x4   12393 MB/s
[    0.532805] raid6: using algorithm sse2x4 (12393 MB/s)
[    0.533727] raid6: using intx1 recovery algorithm
[    0.534626] ACPI: Added _OSI(Module Device)
[    0.535428] ACPI: Added _OSI(Processor Device)
[    0.536004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.536882] ACPI: Added _OSI(Processor Aggregator Device)
[    0.543369] ACPI: Interpreter enabled
[    0.544006] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130927/hwxface-580)
[    0.548004] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130927/hwxface-580)
[    0.552697] ACPI: (supports S0 S3 S4 S5)
[    0.553514] ACPI: Using IOAPIC for interrupt routing
[    0.554545] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.556856] ACPI: No dock devices found.
[    0.568267] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.569282] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.572017] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.573346] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.575431] acpiphp: Slot [3] registered
[    0.576124] acpiphp: Slot [4] registered
[    0.576928] acpiphp: Slot [5] registered
[    0.576928] acpiphp: Slot [6] registered
[    0.576931] acpiphp: Slot [7] registered
[    0.580106] acpiphp: Slot [8] registered
[    0.580933] acpiphp: Slot [9] registered
[    0.580933] acpiphp: Slot [10] registered
[    0.580942] acpiphp: Slot [11] registered
[    0.584115] acpiphp: Slot [12] registered
[    0.584952] acpiphp: Slot [13] registered
[    0.584952] acpiphp: Slot [14] registered
[    0.584952] acpiphp: Slot [15] registered
[    0.588107] acpiphp: Slot [16] registered
[    0.588934] acpiphp: Slot [17] registered
[    0.588944] acpiphp: Slot [18] registered
[    0.588944] acpiphp: Slot [19] registered
[    0.588944] acpiphp: Slot [20] registered
[    0.592118] acpiphp: Slot [21] registered
[    0.592931] acpiphp: Slot [22] registered
[    0.592944] acpiphp: Slot [23] registered
[    0.592947] acpiphp: Slot [24] registered
[    0.596104] acpiphp: Slot [25] registered
[    0.596935] acpiphp: Slot [26] registered
[    0.596942] acpiphp: Slot [27] registered
[    0.596943] acpiphp: Slot [28] registered
[    0.600118] acpiphp: Slot [29] registered
[    0.600939] acpiphp: Slot [30] registered
[    0.600939] acpiphp: Slot [31] registered
[    0.600939] PCI host bridge to bus 0000:00
[    0.604004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.604993] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.606049] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.607114] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.608004] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.609161] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.610699] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.612630] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.616511] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.618861] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.620364] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.621853] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.623338] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.628602] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.630974] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.637773] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.639483] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.641030] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.644005] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.650202] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.652088] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.654295] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.656011] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.663051] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.665041] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.667026] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.673475] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.674144] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.676991] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.684459] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.686142] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.688509] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.695011] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.697102] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.698947] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.704975] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.706039] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.708966] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.715281] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.716544] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.721343] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.722388] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.724901] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.726251] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.727568] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.729405] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.729405] ACPI: \_SB_.PCI0: notify handler is installed
[    0.732102] Found 1 acpi root devices
[    0.733059] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.733630] vgaarb: loaded
[    0.734293] vgaarb: bridge control possible 0000:00:02.0
[    0.737333] SCSI subsystem initialized
[    0.737333] libata version 3.00 loaded.
[    0.740502] ACPI: bus type USB registered
[    0.740976] usbcore: registered new interface driver usbfs
[    0.741098] usbcore: registered new interface driver hub
[    0.744126] usbcore: registered new device driver usb
[    0.745116] pps_core: LinuxPPS API ver. 1 registered
[    0.745116] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.748331] PTP clock support registered
[    0.748960] EDAC MC: Ver: 3.0.0
[    0.749015] PCI: Using ACPI for IRQ routing
[    0.749015] PCI: pci_cache_line_size set to 64 bytes
[    0.749997] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.752033] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.755112] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.755112] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.756698] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.764106] Switched to clocksource kvm-clock
[    0.813252] pnp: PnP ACPI init
[    0.814000] ACPI: bus type PNP registered
[    0.814891] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.816799] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.817930] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.819779] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.820942] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.822807] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.823884] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.825450] pnp 00:03: [dma 2]
[    0.826455] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.827536] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.829490] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.830584] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.832471] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.834024] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.835216] pnp: PnP ACPI: found 7 devices
[    0.836039] ACPI: bus type PNP unregistered
[    0.855150] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.856163] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.857132] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.858143] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.859451] NET: Registered protocol family 2
[    0.861343] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.870217] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.874661] TCP: Hash tables configured (established 131072 bind 65536)
[    0.875764] TCP: reno registered
[    0.876787] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    0.881499] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    0.883269] NET: Registered protocol family 1
[    0.884509] RPC: Registered named UNIX socket transport module.
[    0.885613] RPC: Registered udp transport module.
[    0.886525] RPC: Registered tcp transport module.
[    0.887437] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.888565] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.889627] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.890661] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.891696] pci 0000:00:02.0: Boot video device
[    0.892700] PCI: CLS 0 bytes, default 64
[    0.893676] Trying to unpack rootfs image as initramfs...
[    5.692345] Freeing initrd memory: 192936K (ffff880074396000 - ffff88008=
0000000)
[    5.748983] DMA-API: preallocated 65536 debug entries
[    5.749870] DMA-API: debugging enabled by kernel config
[    5.750749] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.751734] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    5.753843] kvm: no hardware support
[    5.755413] Machine check injector initialized
[    5.757186] Scanning for low memory corruption every 60 seconds
[    5.758805] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    5.760672] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    5.762490] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    5.766048] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    5.767059] PCLMULQDQ-NI instructions are not detected.
[    5.767963] AVX or AES-NI instructions are not detected.
[    5.773992] AVX instructions are not detected.
[    5.774806] AVX instructions are not detected.
[    5.775616] AVX instructions are not detected.
[    5.776497] AVX instructions are not detected.
[    5.815184] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.835827] VFS: Disk quotas dquot_6.5.2
[    5.837025] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.841490] NFS: Registering the id_resolver key type
[    5.842415] Key type id_resolver registered
[    5.843256] Key type id_legacy registered
[    5.844102] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    5.845162] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.847156] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.848414] fuse init (API version 7.22)
[    5.849693] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, debug enabled
[    5.853758] bio: create slab <bio-1> at 1
[    5.855588] Btrfs loaded
[    5.856313] msgmni has been set to 32029
[    5.867404] NET: Registered protocol family 38
[    5.868378] Key type asymmetric registered
[    5.869211] Asymmetric key parser 'x509' registered
[    5.870252] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    5.871918] io scheduler noop registered
[    5.872797] io scheduler deadline registered
[    5.873657] io scheduler cfq registered (default)
[    5.875201] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.876627] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.879310] GHES: HEST is not enabled!
[    5.880159] ERST DBG: ERST support is disabled.
[    5.881924] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.882945] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    5.886459] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.887483] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    5.891334] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.895232] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.905110] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.927496] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.931626] Non-volatile memory driver v1.3
[    5.939242] brd: module loaded
[    5.943385] loop: module loaded
[    5.944390] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    5.945371] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    5.946560] blk-mq: CPU -> queue map
[    5.947332]   CPU 0 -> Queue 0
[    5.948095]   CPU 1 -> Queue 0
[    5.948812]   CPU 2 -> Queue 0
[    5.949589]   CPU 3 -> Queue 0
[    5.951180]  vda: unknown partition table
[    5.953886] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    5.954855] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    5.955985] blk-mq: CPU -> queue map
[    5.956819]   CPU 0 -> Queue 0
[    5.957561]   CPU 1 -> Queue 0
[    5.958246]   CPU 2 -> Queue 0
[    5.958934]   CPU 3 -> Queue 0
[    5.970058]  vdb: unknown partition table
[    5.973197] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    5.974171] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    5.975311] blk-mq: CPU -> queue map
[    5.976132]   CPU 0 -> Queue 0
[    5.976824]   CPU 1 -> Queue 0
[    5.977511]   CPU 2 -> Queue 0
[    5.978189]   CPU 3 -> Queue 0
[    5.980050]  vdc: unknown partition table
[    5.982777] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    5.983713] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    5.984880] blk-mq: CPU -> queue map
[    5.985608]   CPU 0 -> Queue 0
[    5.986267]   CPU 1 -> Queue 0
[    5.986930]   CPU 2 -> Queue 0
[    5.987594]   CPU 3 -> Queue 0
[    5.989336]  vdd: unknown partition table
[    5.991771] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    5.992809] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    5.993917] blk-mq: CPU -> queue map
[    5.994670]   CPU 0 -> Queue 0
[    5.995359]   CPU 1 -> Queue 0
[    5.996098]   CPU 2 -> Queue 0
[    5.996799]   CPU 3 -> Queue 0
[    5.998197]  vde: unknown partition table
[    6.000806] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    6.001765] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    6.002870] blk-mq: CPU -> queue map
[    6.003647]   CPU 0 -> Queue 0
[    6.004423]   CPU 1 -> Queue 0
[    6.005155]   CPU 2 -> Queue 0
[    6.005879]   CPU 3 -> Queue 0
[    6.007512]  vdf: unknown partition table
[    6.010403] lkdtm: No crash points registered, enable through debugfs
[    6.012820] Loading iSCSI transport class v2.0-870.
[    6.015618] Adaptec aacraid driver 1.2-0[30200]-ms
[    6.016920] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    6.018406] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    6.020416] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    6.022130] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    6.023432] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    6.024849] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    6.026066] RocketRAID 3xxx/4xxx Controller driver v1.8
[    6.031481] scsi_debug: host protection
[    6.032361] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    6.034508] ata_piix 0000:00:01.1: version 2.13
[    6.034537] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    6.039542] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.040665] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    6.041686] scsi1 : ata_piix
[    6.042005] scsi2 : ata_piix
[    6.042258] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    6.042259] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    6.044365] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    6.044584] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    6.044585] Copyright (c) 2007 Atheros Corporation.
[    6.045157] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    6.045270] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    6.045270]   http://www.scyld.com/network/drivers.html
[    6.045619] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    6.045849] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    6.045849] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.045966] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    6.045967] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.060047] sd 0:0:0:0: [sda] Write Protect is off
[    6.060993] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.068122] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    6.096078]  sda: unknown partition table
[    6.112111] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.196617] ata2.01: NODEV after polling detection
[    6.197761] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    6.199124] ata2.00: configured for MWDMA2
[    6.200611] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    6.203645] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[    6.372830] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    6.373950] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    6.375307] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.376425] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    6.377856] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    6.379095] igb: Copyright (c) 2007-2013 Intel Corporation.
[    6.380514] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    6.382100] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    6.383480] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    6.384694] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    6.386165] sky2: driver version 1.30
[    6.388888] usbcore: registered new interface driver catc
[    6.390052] usbcore: registered new interface driver kaweth
[    6.391524] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    6.394195] usbcore: registered new interface driver pegasus
[    6.395442] usbcore: registered new interface driver rtl8150
[    6.396656] usbcore: registered new interface driver asix
[    6.397855] usbcore: registered new interface driver ax88179_178a
[    6.399088] usbcore: registered new interface driver cdc_ether
[    6.400334] usbcore: registered new interface driver r815x
[    6.401542] usbcore: registered new interface driver cdc_eem
[    6.402730] usbcore: registered new interface driver dm9601
[    6.403903] usbcore: registered new interface driver smsc75xx
[    6.405160] usbcore: registered new interface driver smsc95xx
[    6.406357] usbcore: registered new interface driver gl620a
[    6.407525] usbcore: registered new interface driver net1080
[    6.408733] usbcore: registered new interface driver plusb
[    6.409944] usbcore: registered new interface driver rndis_host
[    6.411163] usbcore: registered new interface driver cdc_subset
[    6.412404] usbcore: registered new interface driver zaurus
[    6.413600] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    6.415320] usbcore: registered new interface driver int51x1
[    6.416504] usbcore: registered new interface driver ipheth
[    6.417701] usbcore: registered new interface driver sierra_net
[    6.418888] usbcore: registered new interface driver cdc_ncm
[    6.419913] Fusion MPT base driver 3.04.20
[    6.426312] Copyright (c) 1999-2008 LSI Corporation
[    6.427246] Fusion MPT SPI Host driver 3.04.20
[    6.428321] Fusion MPT FC Host driver 3.04.20
[    6.429394] Fusion MPT SAS Host driver 3.04.20
[    6.430465] Fusion MPT misc device (ioctl) driver 3.04.20
[    6.431696] mptctl: Registered with Fusion MPT base driver
[    6.432749] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    6.434375] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.435835] ehci-pci: EHCI PCI platform driver
[    6.436969] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.438066] ohci-pci: OHCI PCI platform driver
[    6.439132] uhci_hcd: USB Universal Host Controller Interface driver
[    6.440675] usbcore: registered new interface driver usb-storage
[    6.441955] usbcore: registered new interface driver ums-alauda
[    6.443191] usbcore: registered new interface driver ums-datafab
[    6.444475] usbcore: registered new interface driver ums-freecom
[    6.445705] usbcore: registered new interface driver ums-isd200
[    6.446870] usbcore: registered new interface driver ums-jumpshot
[    6.448115] usbcore: registered new interface driver ums-sddr09
[    6.449330] usbcore: registered new interface driver ums-sddr55
[    6.450485] usbcore: registered new interface driver ums-usbat
[    6.451649] usbcore: registered new interface driver usbtest
[    6.452984] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.455407] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.456425] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.457869] mousedev: PS/2 mouse device common for all mice
[    6.459477] rtc_cmos 00:00: RTC can wake from S4
[    6.460926] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    6.462050] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    6.463429] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    6.464670] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    6.466687] i6300esb: initialized (0xffffc90002966000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    6.468498] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    6.469659] iTCO_vendor_support: vendor-support=3D0
[    6.470610] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    6.472248] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    6.474019] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    6.476115] md: linear personality registered for level -1
[    6.477177] md: raid0 personality registered for level 0
[    6.478272] md: raid1 personality registered for level 1
[    6.479305] md: raid10 personality registered for level 10
[    6.480596] md: raid6 personality registered for level 6
[    6.481629] md: raid5 personality registered for level 5
[    6.482667] md: raid4 personality registered for level 4
[    6.483693] md: multipath personality registered for level -4
[    6.484814] md: faulty personality registered for level -5
[    6.486974] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    6.489281] device-mapper: multipath: version 1.6.0 loaded
[    6.490312] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.491625] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    6.492746] device-mapper: cache cleaner: version 1.0.0 loaded
[    6.494336] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.502373] usbcore: registered new interface driver usbhid
[    6.503420] usbhid: USB HID core driver
[    6.504478] oprofile: using NMI interrupt.
[    6.505442] TCP: bic registered
[    6.506179] Initializing XFRM netlink socket
[    6.507742] NET: Registered protocol family 10
[    6.509120] sit: IPv6 over IPv4 tunneling driver
[    6.510413] NET: Registered protocol family 17
[    6.511374] 8021q: 802.1Q VLAN Support v1.8
[    6.534726] sctp: Hash tables configured (established 52428 bind 52428)
[    6.536274] Key type dns_resolver registered
[    6.539109]=20
[    6.539109] printing PIC contents
[    6.540397] ... PIC  IMR: ffff
[    6.541085] ... PIC  IRR: 9113
[    6.541778] ... PIC  ISR: 0000
[    6.542461] ... PIC ELCR: 0c00
[    6.543194] printing local APIC contents on CPU#0/0:
[    6.544164] ... APIC ID:      00000000 (0)
[    6.545008] ... APIC VERSION: 00050014
[    6.545813] ... APIC TASKPRI: 00000000 (00)
[    6.546665] ... APIC PROCPRI: 00000000
[    6.547185] ... APIC LDR: 01000000
[    6.547185] ... APIC DFR: ffffffff
[    6.547185] ... APIC SPIV: 000001ff
[    6.547185] ... APIC ISR field:
[    6.547185] 000000000000000000000000000000000000000000000000000000000000=
0000
[    6.547185] ... APIC TMR field:
[    6.547185] 000000000200000000000000000000000000000000000000000000000000=
0000
[    6.547185] ... APIC IRR field:
[    6.547185] 000000000000000000000000000000000000000000000000000000000000=
8000
[    6.547185] ... APIC ESR: 00000000
[    6.547185] ... APIC ICR: 000008fd
[    6.547185] ... APIC ICR2: 02000000
[    6.547185] ... APIC LVTT: 000000ef
[    6.547185] ... APIC LVTPC: 00010000
[    6.547185] ... APIC LVT0: 00010700
[    6.547185] ... APIC LVT1: 00000400
[    6.547185] ... APIC LVTERR: 000000fe
[    6.547185] ... APIC TMICT: 0003ca70
[    6.547185] ... APIC TMCCT: 00000000
[    6.547185] ... APIC TDCR: 00000003
[    6.547185]=20
[    6.565856] number of MP IRQ sources: 15.
[    6.566648] number of IO-APIC #0 registers: 24.
[    6.567463] testing the IO APIC.......................
[    6.568409] IO APIC #0......
[    6.569057] .... register #00: 00000000
[    6.569805] .......    : physical APIC id: 00
[    6.570609] .......    : Delivery Type: 0
[    6.571372] .......    : LTS          : 0
[    6.572190] .... register #01: 00170011
[    6.572936] .......     : max redirection entries: 17
[    6.573802] .......     : PRQ implemented: 0
[    6.574593] .......     : IO APIC version: 11
[    6.575393] .... register #02: 00000000
[    6.576188] .......     : arbitration: 00
[    6.576953] .... IRQ redirection table:
[    6.577709] 1    0    0   0   0    0    0    00
[    6.578530] 0    0    0   0   0    1    1    31
[    6.579353] 0    0    0   0   0    1    1    30
[    6.580225] 0    0    0   0   0    1    1    33
[    6.581061] 1    0    0   0   0    1    1    34
[    6.581886] 1    1    0   0   0    1    1    35
[    6.582707] 0    0    0   0   0    1    1    36
[    6.583527] 0    0    0   0   0    1    1    37
[    6.584404] 0    0    0   0   0    1    1    38
[    6.585228] 0    1    0   0   0    1    1    39
[    6.586051] 1    1    0   0   0    1    1    3A
[    6.586874] 1    1    0   0   0    1    1    3B
[    6.587695] 0    0    0   0   0    1    1    3C
[    6.588578] 0    0    0   0   0    1    1    3D
[    6.589404] 0    0    0   0   0    1    1    3E
[    6.590224] 0    0    0   0   0    1    1    3F
[    6.591052] 1    0    0   0   0    0    0    00
[    6.591881] 1    0    0   0   0    0    0    00
[    6.592767] 1    0    0   0   0    0    0    00
[    6.593589] 1    0    0   0   0    0    0    00
[    6.594417] 1    0    0   0   0    0    0    00
[    6.595241] 1    0    0   0   0    0    0    00
[    6.596118] 1    0    0   0   0    0    0    00
[    6.596944] 1    0    0   0   0    0    0    00
[    6.597758] IRQ to pin mappings:
[    6.598443] IRQ0 -> 0:2
[    6.599169] IRQ1 -> 0:1
[    6.599897] IRQ3 -> 0:3
[    6.600685] IRQ4 -> 0:4
[    6.601505] IRQ5 -> 0:5
[    6.602285] IRQ6 -> 0:6
[    6.603027] IRQ7 -> 0:7
[    6.603757] IRQ8 -> 0:8
[    6.604593] IRQ9 -> 0:9
[    6.605327] IRQ10 -> 0:10
[    6.606069] IRQ11 -> 0:11
[    6.606824] IRQ12 -> 0:12
[    6.607577] IRQ13 -> 0:13
[    6.608383] IRQ14 -> 0:14
[    6.609126] IRQ15 -> 0:15
[    6.609870] .................................... done.
[    6.612085] registered taskstats version 1
[    6.614327] rtc_cmos 00:00: setting system clock to 2013-11-23 01:45:26 =
UTC (1385171126)
[    6.615877] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    6.622508] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.623463] 8021q: adding VLAN 0 to HW filter on device eth0
[    6.756122] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[    7.087965] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[    8.628511] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[    8.632074] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.648057] Sending DHCP requests ., OK
[    8.668060] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    8.669379] IP-Config: Complete:
[    8.670083]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    8.671766]      host=3Dkbuildx-5, domain=3D, nis-domain=3D(none)
[    8.672796]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[    8.673522]      nameserver0=3D10.0.2.3
[    8.674725] PM: Hibernation image not present or could not be loaded.
[    8.682667] Freeing unused kernel memory: 3212K (ffffffff8235e000 - ffff=
ffff82681000)
[    8.684229] Write protecting the kernel read-only data: 18432k
[    8.689087] Freeing unused kernel memory: 1680K (ffff880001a5c000 - ffff=
880001c00000)
[    8.692139] Freeing unused kernel memory: 744K (ffff880002146000 - ffff8=
80002200000)
[    9.654207] random: vgscan urandom read with 41 bits of entropy available

=3D=3D> /lkp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /lkp/err_log <=3D=3D

=3D=3D> /lkp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4HDD-RAID5-cfq-xfs-1dd/x86=
_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/0
job=3D/lkp/scheduled/kbuildx-5/bisect_dd-write-4HDD-RAID5-cfq-xfs-1dd-x86_6=
4-lkp-6d6e352c80f22c446d933ca8103e02bac1f09129-0.yaml
2013-11-23 01:45:45 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/kbuildx-5/bisect_dd-write-4HDD-RAID5-cfq-xfs-1dd-x86=
_64-lkp-6d6e352c80f22c446d933ca8103e02bac1f09129-0.yaml
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/md
run: /lkp/lkp/src/monitors/event/wait pre-test
run: /lkp/lkp/src/monitors/wrapper perf-stat
run: /lkp/lkp/src/monitors/wrapper ftrace
2013-11-23 01:45:46 mdadm -q --create /dev/md0 --chunk=3D256 --level=3Draid=
5 --raid-devices=3D4 --force --assume-clean /dev/vdb /dev/vdc /dev/vdd /dev=
/vde
[   25.382385] md: bind<vdb>
[   25.383385] md: bind<vdc>
[   25.384298] md: bind<vdd>
[   25.385128] md: bind<vde>
[   25.390307] md/raid:md0: device vde operational as raid disk 3
[   25.391387] md/raid:md0: device vdd operational as raid disk 2
[   25.392491] md/raid:md0: device vdc operational as raid disk 1
[   25.393556] md/raid:md0: device vdb operational as raid disk 0
[   25.395765] md/raid:md0: allocated 0kB
[   25.396733] md/raid:md0: raid level 5 active with 4 out of 4 devices, al=
gorithm 2
[   25.398293] RAID conf printout:
[   25.399036]  --- level:5 rd:4 wd:4
[   25.399815]  disk 0, o:1, dev:vdb
[   25.400641]  disk 1, o:1, dev:vdc
[   25.401403]  disk 2, o:1, dev:vdd
[   25.402165]  disk 3, o:1, dev:vde
[   25.402998] md0: detected capacity change from 0 to 824230281216
[   25.406366]  md0: unknown partition table
run: /lkp/lkp/src/setup/iosched
run: /lkp/lkp/src/setup/fs
2013-11-23 01:45:46 mkfs -t xfs /dev/md0
[   26.134284] random: nonblocking pool is initialized
meta-data=3D/dev/md0               isize=3D256    agcount=3D32, agsize=3D62=
88320 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
data     =3D                       bsize=3D4096   blocks=3D201226240, imaxp=
ct=3D25
         =3D                       sunit=3D64     swidth=3D192 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D98304, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
2013-11-23 01:45:48 mount -t xfs -o nobarrier,inode64 /dev/md0 /fs/md0
[   27.534957] XFS (md0): Mounting Filesystem
[   27.578112] XFS (md0): Ending clean mount
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime
run: /lkp/lkp/src/monitors/wrapper iostat
run: /lkp/lkp/src/monitors/wrapper vmstat
run: /lkp/lkp/src/monitors/wrapper numa-numastat
run: /lkp/lkp/src/monitors/wrapper numa-vmstat
run: /lkp/lkp/src/monitors/wrapper numa-meminfo
run: /lkp/lkp/src/monitors/wrapper proc-vmstat
run: /lkp/lkp/src/monitors/wrapper meminfo
run: /lkp/lkp/src/monitors/wrapper slabinfo
run: /lkp/lkp/src/monitors/wrapper buddyinfo
run: /lkp/lkp/src/monitors/wrapper pagetypeinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /usr/bin/time -v -o /tmp/time /lkp/lkp/src/tests/micro/wrapper dd
[   39.829020] ------------[ cut here ]------------
[   39.830137] kernel BUG at drivers/md/raid5.c:693!
[   39.831515] invalid opcode: 0000 [#1] SMP=20
[   39.832671] Modules linked in:
[   39.832885] CPU: 0 PID: 942 Comm: kworker/u8:2 Not tainted 3.12.0-10730-=
g6d6e352 #63
[   39.832885] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   39.832885] Workqueue: writeback bdi_writeback_workfn (flush-9:0)
[   39.832885] task: ffff880408028000 ti: ffff8803d022c000 task.ti: ffff880=
3d022c000
[   39.832885] RIP: 0010:[<ffffffff81895392>]  [<ffffffff81895392>] get_act=
ive_stripe+0x632/0x6a9
[   39.832885] RSP: 0018:ffff8803d022d678  EFLAGS: 00010046
[   39.832885] RAX: ffff8803cde729a0 RBX: ffff88007f2c7000 RCX: 8c6318c6318=
c6320
[   39.832885] RDX: 0000000000000042 RSI: 00000000000003bb RDI: 00000000000=
00046
[   39.832885] RBP: ffff8803d022d708 R08: 00000000be147e16 R09: 00000000000=
00000
[   39.832885] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8803cde=
729a0
[   39.832885] R13: ffff88007f2c7520 R14: ffff88007f2c73f8 R15: ffff8803cde=
72990
[   39.832885] FS:  0000000000000000(0000) GS:ffff88040e600000(0000) knlGS:=
0000000000000000
[   39.832885] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   39.832885] CR2: 00007fc26e7e93c0 CR3: 000000007edd3000 CR4: 00000000000=
006f0
[   39.832885] Stack:
[   39.832885]  ffffffff810fc068 ffff8803d022d6b8 0000000000000046 00000000=
00000000
[   39.832885]  0000000000000ad0 0000000000000000 ffff880000000002 ffff8800=
7f2c7098
[   39.832885]  ffff8803d022d6d8 0000000000000246 ffff8803d022d778 ffff8800=
7f2c74c0
[   39.832885] Call Trace:
[   39.832885]  [<ffffffff810fc068>] ? prepare_to_wait+0x6f/0x77
[   39.832885]  [<ffffffff81898ca3>] make_request+0x69a/0xac5
[   39.832885]  [<ffffffff818b559b>] ? md_make_request+0x18b/0x2ce
[   39.832885]  [<ffffffff810fc321>] ? __wake_up_sync+0x12/0x12
[   39.832885]  [<ffffffff818b559b>] md_make_request+0x18b/0x2ce
[   39.832885]  [<ffffffff818b5478>] ? md_make_request+0x68/0x2ce
[   39.832885]  [<ffffffff811b3983>] ? kmem_cache_alloc+0x31/0x1bb
[   39.832885]  [<ffffffff811f6efa>] ? bvec_alloc+0xa9/0xc9
[   39.832885]  [<ffffffff814e68ff>] generic_make_request+0x9f/0xe0
[   39.832885]  [<ffffffff814e6a2a>] submit_bio+0xea/0x12a
[   39.832885]  [<ffffffff813960cc>] xfs_submit_ioend_bio+0x34/0x36
[   39.832885]  [<ffffffff8139632a>] xfs_submit_ioend+0xca/0x110
[   39.832885]  [<ffffffff81396f8c>] xfs_vm_writepage+0x474/0x4da
[   39.832885]  [<ffffffff81179f91>] __writepage+0x16/0x34
[   39.832885]  [<ffffffff8117a3a7>] write_cache_pages+0x27f/0x3aa
[   39.832885]  [<ffffffff81179f7b>] ? mapping_tagged+0x14/0x14
[   39.832885]  [<ffffffff8117a513>] generic_writepages+0x41/0x59
[   39.832885]  [<ffffffff81395562>] xfs_vm_writepages+0x45/0x4e
[   39.832885]  [<ffffffff8117b303>] do_writepages+0x21/0x2f
[   39.832885]  [<ffffffff811ecabd>] __writeback_single_inode+0x5d/0x228
[   39.832885]  [<ffffffff811ed68b>] writeback_sb_inodes+0x1f0/0x358
[   39.832885]  [<ffffffff811ed872>] __writeback_inodes_wb+0x7f/0xb7
[   39.832885]  [<ffffffff811ed9d1>] wb_writeback+0x127/0x2b0
[   39.832885]  [<ffffffff811ee10e>] bdi_writeback_workfn+0x179/0x3a5
[   39.832885]  [<ffffffff810dcfbf>] process_one_work+0x248/0x444
[   39.832885]  [<ffffffff810dcf42>] ? process_one_work+0x1cb/0x444
[   39.832885]  [<ffffffff810dddd0>] worker_thread+0x1d8/0x2c2
[   39.832885]  [<ffffffff810ddbf8>] ? rescuer_thread+0x29d/0x29d
[   39.832885]  [<ffffffff810e328d>] kthread+0xf9/0x101
[   39.832885]  [<ffffffff810f21ae>] ? local_clock+0x41/0x5a
[   39.832885]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   39.832885]  [<ffffffff81a53efc>] ret_from_fork+0x7c/0xb0
[   39.832885]  [<ffffffff810e3194>] ? kthread_create_on_node+0x1a4/0x1a4
[   39.832885] Code: 47 48 a8 02 75 07 f0 ff 83 d0 03 00 00 49 8b 47 10 4c =
39 e0 75 17 49 8b 57 48 f7 c2 00 00 10 00 75 0b 49 8b 57 48 80 e6 04 75 02 =
<0f> 0b 49 8b 57 18 48 89 50 08 48 89 02 49 8b 87 b8 00 00 00 4d=20
[   39.832885] RIP  [<ffffffff81895392>] get_active_stripe+0x632/0x6a9
[   39.832885]  RSP <ffff8803d022d678>
[   39.832885] ---[ end trace e19977ab9e25278d ]---
[   39.832885] Kernel panic - not syncing: Fatal exception
[   39.832885] Shutting down cpus with NMI
[   39.832885] Rebooting in 10 seconds..
Elapsed time: 60
numactl --preferred=3D0 --physcpubind=3D20-23 qemu-system-x86_64 -cpu kvm64=
 -enable-kvm -kernel /kernel/x86_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f=
09129/vmlinuz-3.12.0-10730-g6d6e352 -append 'user=3Dlkp job=3D/lkp/schedule=
d/kbuildx-5/bisect_dd-write-4HDD-RAID5-cfq-xfs-1dd-x86_64-lkp-6d6e352c80f22=
c446d933ca8103e02bac1f09129-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_6=
4-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/vmlinuz-3.12.0-10730-g6d6e35=
2 kconfig=3Dx86_64-lkp commit=3D6d6e352c80f22c446d933ca8103e02bac1f09129 mo=
dules_initrd=3D/kernel/x86_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/=
modules.cgz RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4HDD-RAID5-cfq=
-xfs-1dd/x86_64-lkp/6d6e352c80f22c446d933ca8103e02bac1f09129/0 initrd=3D/ke=
rnel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::kbuildx-5::dhcp =
oops=3Dpanic log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebu=
g dynamic_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ra=
mdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal'  -initrd /fs/=
sdf1/initrd-kbuildx-5 -m 16G -smp 4 -net nic,vlan=3D1,model=3De1000 -net us=
er,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloca=
ltime -drive file=3D/fs/sdf1/disk0-kbuildx-5,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/sdf1/disk1-kbuildx-5,media=3Ddisk,if=3Dvirtio -drive file=3D/f=
s/sdf1/disk2-kbuildx-5,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk=
3-kbuildx-5,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk4-kbuildx-5=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk5-kbuildx-5,media=3Ddi=
sk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-kbuildx-5 -serial file:/dev/shm/=
kboot/serial-kbuildx-5 -daemonize -display none -monitor null=20

--Kj7319i9nmIyA2yE--
