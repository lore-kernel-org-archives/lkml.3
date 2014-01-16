Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaAPBwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:52:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:45388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaAPBvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:51:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="459556775"
Date: Thu, 16 Jan 2014 09:51:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] PANIC: early exception 0e rip 10:ffffffff8ae04c6e
 error 0 cr2 ffffffff81972b28
Message-ID: <20140116015120.GA15735@localhost>
References: <20140115121201.GA16953@localhost>
 <20140115122401.GB18065@localhost>
 <CAGXu5jL5zZwhEtPG=-1UNJ-AgKdFNeLzk-EoYdAzjMWQbBUK4Q@mail.gmail.com>
 <20140116000516.GB4724@localhost>
 <CAGXu5jJUMr7DBRNF8rpuO33UKhwB3zVs=NWBO7G7pZ=FysKnLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <CAGXu5jJUMr7DBRNF8rpuO33UKhwB3zVs=NWBO7G7pZ=FysKnLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Kees,

On Wed, Jan 15, 2014 at 04:19:34PM -0800, Kees Cook wrote:
> Is it possible this is the bug that was fixed with "x86, relocs: add
> percpu fixup for GNU ld 2.23"?
> 
> 82fa9637a2ba285bcc7c5050c73010b2c1b3d803 doesn't include the full
> x86,kalsr (and x86,relocs) series, so I'm not sure it's a good place
> to test.

I just tested the new tip/x86/kaslr head da2b6fb99 ("x86, kaslr:
Clarify RANDOMIZE_BASE_MAX_OFFSET") and find 4 boot failures out of
100 total boots for kconfig x86_64-randconfig-s1-01101738.

        boot_successes: 96
        boot_failures: 4
        general_protection_fault:SMP_SMP: 2
        RIP:get_pageblock_flags_group: 1
        RIP:memcpy: 1
        Kernel_panic-not_syncing:Fatal_exception: 2
        page_allocation_failure:order:,mode: 1
        BUG:kernel_boot_hang: 1
        RIP:__lock_acquire: 1
        RIP:free_object: 1

Attached are the dmesg files. One of them is OOM triggered by trinity,
which is not a problem.

Thanks,
Fengguang

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-nhm4-4:20140116091528:x86_64-randconfig-s1-01101738:3.12.0-rc4-00014-gda2b6fb:1"
Content-Transfer-Encoding: quoted-printable

Linux version 3.12.0-rc4-00014-gda2b6fb #1
Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Dd=
ebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,11=
5200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/=
run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/.vmlinuz-da2b6fb9=
90cf782b18952f534ec7323453bc4fc9-20140116085414-80-nhm4 branch=3Dtip/x86/ka=
slr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da2b6fb990cf782b1895=
2f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.

BUG: kernel boot hang
Elapsed time: 610
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-01101738/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00=
014-gda2b6fb -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/.vmlinuz-=
da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-80-nhm4 branch=3Dti=
p/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da2b6fb990cf=
782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb'  -initrd /k=
ernel-tests/initrd/yocto-minimal-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D=
1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::9336-:22 -boot order=3Dnc=
 -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -soundhw hda -drive fi=
le=3D/fs/LABEL=3DKVM/disk0-yocto-nhm4-4,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/LABEL=3DKVM/disk1-yocto-nhm4-4,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk2-yocto-nhm4-4,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk3-yocto-nhm4-4,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk4-yocto-nhm4-4,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk5-yocto-nhm4-4,media=3Ddisk,if=3Dvirtio -pidfile /de=
v/shm/kboot/pid-yocto-nhm4-4 -serial file:/dev/shm/kboot/serial-yocto-nhm4-=
4 -daemonize -display none -monitor null=20

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-roam-24:20140116090953:x86_64-randconfig-s1-01101738:3.12.0-rc4-00014-gda2b6fb:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00014-gda2b6fb (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 08:53:36 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/=
=2Evmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-95-roam =
branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/d=
a2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x09e86000, 0x09e86fff] PGTABLE
[    0.000000] BRK [0x09e87000, 0x09e87fff] PGTABLE
[    0.000000] BRK [0x09e88000, 0x09e88fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x09e89000, 0x09e89fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000dc0000=
0-ffff88000dffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000e400000 s1914448 r8=
192 d22960 u2097152
[    0.000000] pcpu-alloc: s1914448 r8192 d22960 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e40d080
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:=
kaslr/.vmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-95-r=
oam branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-011017=
38/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6=
fb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 206676K/261744K available (6294K kernel code, 685K r=
wdata, 2640K rodata, 2572K init, 10836K bss, 55068K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00014-gda2b6fb (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 08:53:36 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/=
=2Evmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-95-roam =
branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/d=
a2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x09e86000, 0x09e86fff] PGTABLE
[    0.000000] BRK [0x09e87000, 0x09e87fff] PGTABLE
[    0.000000] BRK [0x09e88000, 0x09e88fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x09e89000, 0x09e89fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000dc0000=
0-ffff88000dffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000e400000 s1914448 r8=
192 d22960 u2097152
[    0.000000] pcpu-alloc: s1914448 r8192 d22960 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e40d080
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:=
kaslr/.vmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-95-r=
oam branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-011017=
38/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6=
fb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 206676K/261744K available (6294K kernel code, 685K r=
wdata, 2640K rodata, 2572K init, 10836K bss, 55068K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.988 MHz processor
[    0.000000] tsc: Detected 2892.988 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.97 Bogo=
MIPS (lpj=3D28929880)
5785.97 BogoMIPS (lpj=3D28929880)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020455] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.020455] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.023035] Mount-cache hash table entries: 256
[    0.023035] Mount-cache hash table entries: 256
[    0.025791] Initializing cgroup subsys devices
[    0.025791] Initializing cgroup subsys devices
[    0.027359] Initializing cgroup subsys freezer
[    0.027359] Initializing cgroup subsys freezer
[    0.030042] Initializing cgroup subsys net_cls
[    0.030042] Initializing cgroup subsys net_cls
[    0.031663] mce: CPU supports 10 MCE banks
[    0.031663] mce: CPU supports 10 MCE banks
[    0.033136] numa_add_cpu cpu 0 node 0: mask now 0
[    0.033136] numa_add_cpu cpu 0 node 0: mask now 0
[    0.034744] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034744] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034744] tlb_flushall_shift: 6
[    0.034744] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034744] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034744] tlb_flushall_shift: 6
[    0.040124] Freeing SMP alternatives memory: 24K (ffffffff893eb000 - fff=
fffff893f1000)
[    0.040124] Freeing SMP alternatives memory: 24K (ffffffff893eb000 - fff=
fffff893f1000)
[    0.048143] ACPI: Core revision 20130725
[    0.048143] ACPI: Core revision 20130725
[    0.055034] ACPI:=20
[    0.055034] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.057296] Getting VERSION: 50014
[    0.057296] Getting VERSION: 50014
[    0.058471] Getting VERSION: 50014
[    0.058471] Getting VERSION: 50014
[    0.059615] Getting ID: 0
[    0.059615] Getting ID: 0
[    0.060044] Getting ID: ff000000
[    0.060044] Getting ID: ff000000
[    0.061226] Getting LVT0: 8700
[    0.061226] Getting LVT0: 8700
[    0.062315] Getting LVT1: 8400
[    0.062315] Getting LVT1: 8400
[    0.063459] enabled ExtINT on CPU#0
[    0.063459] enabled ExtINT on CPU#0
[    0.066146] ENABLING IO-APIC IRQs
[    0.066146] ENABLING IO-APIC IRQs
[    0.067232] init IO_APIC IRQs
[    0.067232] init IO_APIC IRQs
[    0.068236]  apic 0 pin 0 not connected
[    0.068236]  apic 0 pin 0 not connected
[    0.070062] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.070062] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.072810] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.072810] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.075508] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.075508] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.078178] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.078178] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.080057] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.080057] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.082500] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.082500] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.085313] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.085313] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.087875] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.087875] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.090055] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.090055] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.092606] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.092606] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.095237] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.095237] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.097920] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.097920] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.100055] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.100055] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.102777] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.102777] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.105499] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.105499] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.110052]  apic 0 pin 16 not connected
[    0.110052]  apic 0 pin 16 not connected
[    0.111353]  apic 0 pin 17 not connected
[    0.111353]  apic 0 pin 17 not connected
[    0.112604]  apic 0 pin 18 not connected
[    0.112604]  apic 0 pin 18 not connected
[    0.113838]  apic 0 pin 19 not connected
[    0.113838]  apic 0 pin 19 not connected
[    0.115067]  apic 0 pin 20 not connected
[    0.115067]  apic 0 pin 20 not connected
[    0.116318]  apic 0 pin 21 not connected
[    0.116318]  apic 0 pin 21 not connected
[    0.117573]  apic 0 pin 22 not connected
[    0.117573]  apic 0 pin 22 not connected
[    0.120021]  apic 0 pin 23 not connected
[    0.120021]  apic 0 pin 23 not connected
[    0.121547] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.121547] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.124418] smpboot: CPU0:=20
[    0.124418] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.128381] Using local APIC timer interrupts.
[    0.128381] calibrating APIC timer ...
[    0.128381] Using local APIC timer interrupts.
[    0.128381] calibrating APIC timer ...
[    0.140000] ... lapic delta =3D 6252262
[    0.140000] ... lapic delta =3D 6252262
[    0.140000] ... PM-Timer delta =3D 358073
[    0.140000] ... PM-Timer delta =3D 358073
[    0.140000] ... PM-Timer result ok
[    0.140000] ... PM-Timer result ok
[    0.140000] ..... delta 6252262
[    0.140000] ..... delta 6252262
[    0.140000] ..... mult: 268532608
[    0.140000] ..... mult: 268532608
[    0.140000] ..... calibration result: 10003619
[    0.140000] ..... calibration result: 10003619
[    0.140000] ..... CPU clock speed is 2893.7966 MHz.
[    0.140000] ..... CPU clock speed is 2893.7966 MHz.
[    0.140000] ..... host bus clock speed is 1000.3619 MHz.
[    0.140000] ..... host bus clock speed is 1000.3619 MHz.
[    0.140145] Performance Events:=20
[    0.140145] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.146417] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.146417] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.150338] SMP alternatives: lockdep: fixing up alternatives
[    0.150338] SMP alternatives: lockdep: fixing up alternatives
[    0.153023] smpboot: Booting Node   0, Processors=20
[    0.153023] smpboot: Booting Node   0, Processors  #   1 OK
 #   1 OK
[    0.146312] kvm-clock: cpu 1, msr 0:fff8041, secondary cpu clock
[    0.146312] masked ExtINT on CPU#1
[    0.146312] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.170235] KVM setup async PF for cpu 1
[    0.170235] KVM setup async PF for cpu 1
[    0.170344] Brought up 2 CPUs
[    0.170344] Brought up 2 CPUs
[    0.170347] smpboot: Total of 2 processors activated (11571.95 BogoMIPS)
[    0.170347] smpboot: Total of 2 processors activated (11571.95 BogoMIPS)
[    0.174615] kvm-stealtime: cpu 1, msr e60d080
[    0.174615] kvm-stealtime: cpu 1, msr e60d080
[    0.191470] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.191470] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.193846] regulator-dummy: no parameters
[    0.193846] regulator-dummy: no parameters
[    0.195316] NET: Registered protocol family 16
[    0.195316] NET: Registered protocol family 16
[    0.196897] cpuidle: using governor ladder
[    0.196897] cpuidle: using governor ladder
[    0.197985] cpuidle: using governor menu
[    0.197985] cpuidle: using governor menu
[    0.199147] ACPI: bus type PCI registered
[    0.199147] ACPI: bus type PCI registered
[    0.200078] PCI: Using configuration type 1 for base access
[    0.200078] PCI: Using configuration type 1 for base access
[    0.205782] bio: create slab <bio-0> at 0
[    0.205782] bio: create slab <bio-0> at 0
[    0.205782] ACPI: Added _OSI(Module Device)
[    0.205782] ACPI: Added _OSI(Module Device)
[    0.210012] ACPI: Added _OSI(Processor Device)
[    0.210012] ACPI: Added _OSI(Processor Device)
[    0.211443] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.211443] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.212919] ACPI: Added _OSI(Processor Aggregator Device)
[    0.212919] ACPI: Added _OSI(Processor Aggregator Device)
[    0.218037] ACPI: EC: Look up EC in DSDT
[    0.218037] ACPI: EC: Look up EC in DSDT
[    0.231307] ACPI: Interpreter enabled
[    0.231307] ACPI: Interpreter enabled
[    0.232561] ACPI Exception: AE_NOT_FOUND,=20
[    0.232561] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.235660] ACPI Exception: AE_NOT_FOUND,=20
[    0.235660] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.238810] ACPI: (supports S0 S3 S5)
[    0.238810] ACPI: (supports S0 S3 S5)
[    0.240014] ACPI: Using IOAPIC for interrupt routing
[    0.240014] ACPI: Using IOAPIC for interrupt routing
[    0.241786] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.241786] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.269086] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.269086] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.270030] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.270030] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.273957] PCI host bridge to bus 0000:00
[    0.273957] PCI host bridge to bus 0000:00
[    0.275376] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.275376] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.277218] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.277218] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.280016] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.280016] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.282126] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.282126] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.284449] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.284449] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.286905] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.286905] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.290806] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.290806] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.294300] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.294300] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.300898] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.300898] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.305488] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.305488] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.308266] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.308266] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.310038] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.310038] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.313391] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.313391] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.321109] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.321109] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.325762] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.325762] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.338533] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.338533] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.341465] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.341465] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.345294] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.345294] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.350018] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.350018] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.360021] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.360021] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.363377] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.363377] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.367275] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.367275] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.370907] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.370907] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.382816] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.382816] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.386676] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.386676] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.390017] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.390017] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.401999] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.401999] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.405868] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.405868] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.409462] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.409462] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.421143] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.421143] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.425029] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.425029] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.428396] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.428396] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.440698] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.440698] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.444550] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.444550] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.448173] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.448173] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.459487] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.459487] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.461832] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.461832] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.465403] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.465403] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.478684] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.478684] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.480973] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.480973] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.493194] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.493194] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.495714] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.495714] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.498130] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.498130] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.500607] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.500607] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.502834] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.502834] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.506457] ACPI:=20
[    0.506457] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.507930] ACPI: \_SB_.PCI0: notify handler is installed
[    0.507930] ACPI: \_SB_.PCI0: notify handler is installed
[    0.509775] Found 1 acpi root devices
[    0.509775] Found 1 acpi root devices
[    0.511020] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.511020] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.513419] vgaarb: loaded
[    0.513419] vgaarb: loaded
[    0.514273] vgaarb: bridge control possible 0000:00:02.0
[    0.514273] vgaarb: bridge control possible 0000:00:02.0
[    0.516554] Linux video capture interface: v2.00
[    0.516554] Linux video capture interface: v2.00
[    0.518218] pps_core: LinuxPPS API ver. 1 registered
[    0.518218] pps_core: LinuxPPS API ver. 1 registered
[    0.520013] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.520013] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.523138] PTP clock support registered
[    0.523138] PTP clock support registered
[    0.524448] EDAC MC: Ver: 3.0.0
[    0.524448] EDAC MC: Ver: 3.0.0
[    0.527101] PCI: Using ACPI for IRQ routing
[    0.527101] PCI: Using ACPI for IRQ routing
[    0.527101] PCI: pci_cache_line_size set to 64 bytes
[    0.527101] PCI: pci_cache_line_size set to 64 bytes
[    0.530434] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.530434] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.532386] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.532386] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.535545] Bluetooth: Core ver 2.16
[    0.535545] Bluetooth: Core ver 2.16
[    0.536820] NET: Registered protocol family 31
[    0.536820] NET: Registered protocol family 31
[    0.538189] Bluetooth: HCI device and connection manager initialized
[    0.538189] Bluetooth: HCI device and connection manager initialized
[    0.540055] Bluetooth: HCI socket layer initialized
[    0.540055] Bluetooth: HCI socket layer initialized
[    0.541491] Bluetooth: L2CAP socket layer initialized
[    0.541491] Bluetooth: L2CAP socket layer initialized
[    0.543148] Bluetooth: SCO socket layer initialized
[    0.543148] Bluetooth: SCO socket layer initialized
[    0.544739] NET: Registered protocol family 8
[    0.544739] NET: Registered protocol family 8
[    0.546195] NET: Registered protocol family 20
[    0.546195] NET: Registered protocol family 20
[    0.547660] nfc: nfc_init: NFC Core ver 0.1
[    0.547660] nfc: nfc_init: NFC Core ver 0.1
[    0.550160] NET: Registered protocol family 39
[    0.550160] NET: Registered protocol family 39
[    0.551921] Switched to clocksource kvm-clock
[    0.551921] Switched to clocksource kvm-clock
[    0.552299] FS-Cache: Loaded
[    0.552299] FS-Cache: Loaded
[    0.553368] pnp: PnP ACPI init
[    0.553368] pnp: PnP ACPI init
[    0.554498] ACPI: bus type PNP registered
[    0.554498] ACPI: bus type PNP registered
[    0.556028] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.556028] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.559096] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.559096] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.561756] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.561756] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.564902] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.564902] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.567445] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.567445] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.570840] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.570840] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.573308] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.573308] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.576004] pnp 00:03: [dma 2]
[    0.576004] pnp 00:03: [dma 2]
[    0.577311] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.577311] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.580088] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.580088] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.583100] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.583100] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.585813] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.585813] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.588723] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.588723] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.592376] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.592376] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.595184] pnp: PnP ACPI: found 7 devices
[    0.595184] pnp: PnP ACPI: found 7 devices
[    0.596607] ACPI: bus type PNP unregistered
[    0.596607] ACPI: bus type PNP unregistered
[    0.604416] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.604416] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.606398] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.606398] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.608108] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.608108] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.610551] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.610551] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.613124] NET: Registered protocol family 2
[    0.613124] NET: Registered protocol family 2
[    0.615906] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.615906] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.618351] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.618351] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.621126] TCP: Hash tables configured (established 2048 bind 2048)
[    0.621126] TCP: Hash tables configured (established 2048 bind 2048)
[    0.623485] TCP: reno registered
[    0.623485] TCP: reno registered
[    0.624587] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.624587] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.626767] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.626767] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.629561] NET: Registered protocol family 1
[    0.629561] NET: Registered protocol family 1
[    0.631168] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.631168] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.633276] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.633276] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.635291] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.635291] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.637398] pci 0000:00:02.0: Boot video device
[    0.637398] pci 0000:00:02.0: Boot video device
[    0.639127] PCI: CLS 0 bytes, default 64
[    0.639127] PCI: CLS 0 bytes, default 64
[    0.641197] Unpacking initramfs...
[    0.641197] Unpacking initramfs...
[    1.685796] Freeing initrd memory: 23244K (ffff88000e93d000 - ffff88000f=
ff0000)
[    1.685796] Freeing initrd memory: 23244K (ffff88000e93d000 - ffff88000f=
ff0000)
[    1.725302] DMA-API: preallocated 65536 debug entries
[    1.725302] DMA-API: preallocated 65536 debug entries
[    1.727153] DMA-API: debugging enabled by kernel config
[    1.727153] DMA-API: debugging enabled by kernel config
[    1.729628] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.729628] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.733081] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.733081] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.739248] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.739248] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.741535] AVX or AES-NI instructions are not detected.
[    1.741535] AVX or AES-NI instructions are not detected.
[    1.771700] Kprobe smoke test started
[    1.771700] Kprobe smoke test started
[    1.850364] Kprobe smoke test passed successfully
[    1.850364] Kprobe smoke test passed successfully
[    1.853125] bounce pool size: 64 pages
[    1.853125] bounce pool size: 64 pages
[    1.854347] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.854347] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.857559] VFS: Disk quotas dquot_6.5.2
[    1.857559] VFS: Disk quotas dquot_6.5.2
[    1.859016] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.859016] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.861886] DLM installed
[    1.861886] DLM installed
[    1.863702] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.863702] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.865192] QNX6 filesystem 1.0.0 registered.
[    1.865192] QNX6 filesystem 1.0.0 registered.
[    1.866551] fuse init (API version 7.22)
[    1.866551] fuse init (API version 7.22)
[    1.868237] BeFS version: 0.9.3
[    1.868237] BeFS version: 0.9.3
[    1.870745] ceph: loaded (mds proto 32)
[    1.870745] ceph: loaded (mds proto 32)
[    1.872091] msgmni has been set to 449
[    1.872091] msgmni has been set to 449
[    1.878278] NET: Registered protocol family 38
[    1.878278] NET: Registered protocol family 38
[    1.879836] Key type asymmetric registered
[    1.879836] Key type asymmetric registered
[    1.881448] Asymmetric key parser 'x509' registered
[    1.881448] Asymmetric key parser 'x509' registered
[    1.883236] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.883236] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.885660] io scheduler noop registered (default)
[    1.885660] io scheduler noop registered (default)
[    1.887267] io scheduler cfq registered
[    1.887267] io scheduler cfq registered
[    1.889744] test_string_helpers: Running tests...
[    1.889744] test_string_helpers: Running tests...
[    1.893067] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    1.893067] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    1.894603] crc32: self tests passed, processed 225944 bytes in 276323 n=
sec
[    1.894603] crc32: self tests passed, processed 225944 bytes in 276323 n=
sec
[    1.897139] crc32c: CRC_LE_BITS =3D 32
[    1.897139] crc32c: CRC_LE_BITS =3D 32
[    1.898363] crc32c: self tests passed, processed 225944 bytes in 138701 =
nsec
[    1.898363] crc32c: self tests passed, processed 225944 bytes in 138701 =
nsec
[    1.900810] rbtree testing
[    1.900810] rbtree testing -> 14035 cycles
 -> 14035 cycles
[    2.417771] augmented rbtree testing
[    2.417771] augmented rbtree testing
[    2.730266] tsc: Refined TSC clocksource calibration: 2892.918 MHz
[    2.730266] tsc: Refined TSC clocksource calibration: 2892.918 MHz
 -> 20459 cycles
 -> 20459 cycles
[    3.158851] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.158851] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.160418] ACPI: Power Button [PWRF]
[    3.160418] ACPI: Power Button [PWRF]
[    3.161845] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.161845] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.162944] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.162944] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.186943] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.186943] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.191390] Non-volatile memory driver v1.3
[    3.191390] Non-volatile memory driver v1.3
[    3.192884] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.192884] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.194677] smapi::smapi_init, ERROR invalid usSmapiID
[    3.194677] smapi::smapi_init, ERROR invalid usSmapiID
[    3.196458] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.196458] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.199601] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.199601] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.202132] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.202132] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.204269] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.204269] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.207275] Hangcheck: Using getrawmonotonic().
[    3.207275] Hangcheck: Using getrawmonotonic().
[    3.208990] [drm] Initialized drm 1.1.0 20060810
[    3.208990] [drm] Initialized drm 1.1.0 20060810
[    3.212143] nbd: registered device at major 43
[    3.212143] nbd: registered device at major 43
[    3.218619] Uniform Multi-Platform E-IDE driver
[    3.218619] Uniform Multi-Platform E-IDE driver
[    3.221131] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    3.221131] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    3.224452] ide-gd driver 1.18
[    3.224452] ide-gd driver 1.18
[    3.225517] ide-cd driver 5.00
[    3.225517] ide-cd driver 5.00
[    3.227316] platform physmap-flash.0: failed to claim resource 0
[    3.227316] platform physmap-flash.0: failed to claim resource 0
[    3.229485] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    3.229485] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[    3.233822] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    3.233822] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    3.235348] AX.25: 6pack driver, Revision: 0.3.0
[    3.235348] AX.25: 6pack driver, Revision: 0.3.0
[    3.236887] YAM driver version 0.8 by F1OAT/F6FBB
[    3.236887] YAM driver version 0.8 by F1OAT/F6FBB
[    3.239872] AX.25: bpqether driver version 004
[    3.239872] AX.25: bpqether driver version 004
[    3.242389] PPP generic driver version 2.4.2
[    3.242389] PPP generic driver version 2.4.2
[    3.243997] NET: Registered protocol family 24
[    3.243997] NET: Registered protocol family 24
[    3.246492] aoe: AoE v85 initialised.
[    3.246492] aoe: AoE v85 initialised.
[    3.247944] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.247944] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.251916] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.251916] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.253696] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.253696] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.255976] i2c-parport: adapter type unspecified
[    3.255976] i2c-parport: adapter type unspecified
[    3.257998] smssdio: Siano SMS1xxx SDIO driver
[    3.257998] smssdio: Siano SMS1xxx SDIO driver
[    3.259493] smssdio: Copyright Pierre Ossman
[    3.259493] smssdio: Copyright Pierre Ossman
[    3.261107] pps_parport: parallel port PPS client
[    3.261107] pps_parport: parallel port PPS client
[    3.263095] Driver for 1-wire Dallas network protocol.
[    3.263095] Driver for 1-wire Dallas network protocol.
[    3.266044] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    3.266044] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    3.266242] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.266242] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.272528] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    3.272528] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[    3.274950] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    3.274950] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    3.277643] ib700wdt: START method I/O 443 is not available
[    3.277643] ib700wdt: START method I/O 443 is not available
[    3.279609] ib700wdt: probe of ib700wdt failed with error -5
[    3.279609] ib700wdt: probe of ib700wdt failed with error -5
[    3.281672] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.281672] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.284337] wafer5823wdt: I/O address 0x0443 already in use
[    3.284337] wafer5823wdt: I/O address 0x0443 already in use
[    3.286364] sbc60xxwdt: I/O address 0x0443 already in use
[    3.286364] sbc60xxwdt: I/O address 0x0443 already in use
[    3.288244] cpu5wdt: misc_register failed
[    3.288244] cpu5wdt: misc_register failed
[    3.289681] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.289681] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.293491] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.293491] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.295654] w83977f_wdt: driver v1.00
[    3.295654] w83977f_wdt: driver v1.00
[    3.296922] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.296922] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.304489] ISDN subsystem Rev: 1.1.2.3/
[    3.304489] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/1.1.2.2/none/none/1.1.2.=
2/1.1.2.2/1.1.2.21.1.2.2

[    3.307202] CAPI 2.0 started up with major 68 (middleware)
[    3.307202] CAPI 2.0 started up with major 68 (middleware)
[    3.309267] ledtrig-cpu: registered to indicate activity on CPUs
[    3.309267] ledtrig-cpu: registered to indicate activity on CPUs
[    3.311535] oprofile: using NMI interrupt.
[    3.311535] oprofile: using NMI interrupt.
[    3.313205] NET: Registered protocol family 26
[    3.313205] NET: Registered protocol family 26
[    3.314882] gre: GRE over IPv4 demultiplexor driver
[    3.314882] gre: GRE over IPv4 demultiplexor driver
[    3.316455] IPv4 over IPSec tunneling driver
[    3.316455] IPv4 over IPSec tunneling driver
[    3.318596] TCP: highspeed registered
[    3.318596] TCP: highspeed registered
[    3.319844] TCP: hybla registered
[    3.319844] TCP: hybla registered
[    3.321091] TCP: vegas registered
[    3.321091] TCP: vegas registered
[    3.322243] TCP: scalable registered
[    3.322243] TCP: scalable registered
[    3.323480] TCP: yeah registered
[    3.323480] TCP: yeah registered
[    3.324592] TCP: illinois registered
[    3.324592] TCP: illinois registered
[    3.325894] NET: Registered protocol family 17
[    3.325894] NET: Registered protocol family 17
[    3.350586] NET: Registered protocol family 4
[    3.350586] NET: Registered protocol family 4
[    3.352179] NET: Registered protocol family 3
[    3.352179] NET: Registered protocol family 3
[    3.354174] sctp: Hash tables configured (established 819 bind 819)
[    3.354174] sctp: Hash tables configured (established 819 bind 819)
[    3.357116] 9pnet: Installing 9P2000 support
[    3.357116] 9pnet: Installing 9P2000 support
[    3.358822] Key type dns_resolver registered
[    3.358822] Key type dns_resolver registered
[    3.360372] Key type ceph registered
[    3.360372] Key type ceph registered
[    3.361859] libceph: loaded (mon/osd proto 15/24)
[    3.361859] libceph: loaded (mon/osd proto 15/24)
[    3.363478] mpls_gso: MPLS GSO support
[    3.363478] mpls_gso: MPLS GSO support
[    3.365494]=20
[    3.365494] printing PIC contents
[    3.365494]=20
[    3.365494] printing PIC contents
[    3.367168] ... PIC  IMR: ffff
[    3.367168] ... PIC  IMR: ffff
[    3.368241] ... PIC  IRR: 1013
[    3.368241] ... PIC  IRR: 1013
[    3.370369] ... PIC  ISR: 0000
[    3.370369] ... PIC  ISR: 0000
[    3.371445] ... PIC ELCR: 0c00
[    3.371445] ... PIC ELCR: 0c00
[    3.372578] printing local APIC contents on CPU#0/0:
[    3.372578] printing local APIC contents on CPU#0/0:
[    3.374326] ... APIC ID:      00000000 (0)
[    3.374326] ... APIC ID:      00000000 (0)
[    3.375772] ... APIC VERSION: 00050014
[    3.375772] ... APIC VERSION: 00050014
[    3.377087] ... APIC TASKPRI: 00000000 (00)
[    3.377087] ... APIC TASKPRI: 00000000 (00)
[    3.378644] ... APIC PROCPRI: 00000000
[    3.378644] ... APIC PROCPRI: 00000000
[    3.380030] ... APIC LDR: 01000000
[    3.380030] ... APIC LDR: 01000000
[    3.381229] ... APIC DFR: ffffffff
[    3.381229] ... APIC DFR: ffffffff
[    3.382484] ... APIC SPIV: 000001ff
[    3.382484] ... APIC SPIV: 000001ff
[    3.382558] ... APIC ISR field:
[    3.382558] ... APIC ISR field:
[    3.382558] 00000000
[    3.382558] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.382558] ... APIC TMR field:
[    3.382558] ... APIC TMR field:
[    3.382558] 00000000
[    3.382558] 000000000200000002000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    3.382558] ... APIC IRR field:
[    3.382558] ... APIC IRR field:
[    3.382558] 00000000
[    3.382558] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    3.382558] ... APIC ESR: 00000000
[    3.382558] ... APIC ESR: 00000000
[    3.382558] ... APIC ICR: 000008fd
[    3.382558] ... APIC ICR: 000008fd
[    3.382558] ... APIC ICR2: 02000000
[    3.382558] ... APIC ICR2: 02000000
[    3.382558] ... APIC LVTT: 000000ef
[    3.382558] ... APIC LVTT: 000000ef
[    3.382558] ... APIC LVTPC: 00010000
[    3.382558] ... APIC LVTPC: 00010000
[    3.382558] ... APIC LVT0: 00010700
[    3.382558] ... APIC LVT0: 00010700
[    3.382558] ... APIC LVT1: 00000400
[    3.382558] ... APIC LVT1: 00000400
[    3.382558] ... APIC LVTERR: 000000fe
[    3.382558] ... APIC LVTERR: 000000fe
[    3.382558] ... APIC TMICT: 00097ae8
[    3.382558] ... APIC TMICT: 00097ae8
[    3.382558] ... APIC TMCCT: 00000000
[    3.382558] ... APIC TMCCT: 00000000
[    3.382558] ... APIC TDCR: 00000003
[    3.382558] ... APIC TDCR: 00000003
[    3.382558]=20
[    3.382558]=20
[    3.411362] number of MP IRQ sources: 15.
[    3.411362] number of MP IRQ sources: 15.
[    3.412725] number of IO-APIC #0 registers: 24.
[    3.412725] number of IO-APIC #0 registers: 24.
[    3.414260] testing the IO APIC.......................
[    3.414260] testing the IO APIC.......................
[    3.416074] IO APIC #0......
[    3.416074] IO APIC #0......
[    3.416987] .... register #00: 00000000
[    3.416987] .... register #00: 00000000
[    3.418285] .......    : physical APIC id: 00
[    3.418285] .......    : physical APIC id: 00
[    3.419798] .......    : Delivery Type: 0
[    3.419798] .......    : Delivery Type: 0
[    3.421216] .......    : LTS          : 0
[    3.421216] .......    : LTS          : 0
[    3.422615] .... register #01: 00170011
[    3.422615] .... register #01: 00170011
[    3.423927] .......     : max redirection entries: 17
[    3.423927] .......     : max redirection entries: 17
[    3.425653] .......     : PRQ implemented: 0
[    3.425653] .......     : PRQ implemented: 0
[    3.427128] .......     : IO APIC version: 11
[    3.427128] .......     : IO APIC version: 11
[    3.428657] .... register #02: 00000000
[    3.428657] .... register #02: 00000000
[    3.429992] .......     : arbitration: 00
[    3.429992] .......     : arbitration: 00
[    3.431455] .... IRQ redirection table:
[    3.431455] .... IRQ redirection table:
[    3.432844] 1    0    0   0   0    0    0    00
[    3.432844] 1    0    0   0   0    0    0    00
[    3.434442] 0    0    0   0   0    1    1    31
[    3.434442] 0    0    0   0   0    1    1    31
[    3.436021] 0    0    0   0   0    1    1    30
[    3.436021] 0    0    0   0   0    1    1    30
[    3.437581] 0    0    0   0   0    1    1    33
[    3.437581] 0    0    0   0   0    1    1    33
[    3.438998] 1    0    0   0   0    1    1    34
[    3.438998] 1    0    0   0   0    1    1    34
[    3.440620] 1    1    0   0   0    1    1    35
[    3.440620] 1    1    0   0   0    1    1    35
[    3.442175] 0    0    0   0   0    1    1    36
[    3.442175] 0    0    0   0   0    1    1    36
[    3.443756] 0    0    0   0   0    1    1    37
[    3.443756] 0    0    0   0   0    1    1    37
[    3.445342] 0    0    0   0   0    1    1    38
[    3.445342] 0    0    0   0   0    1    1    38
[    3.446907] 0    1    0   0   0    1    1    39
[    3.446907] 0    1    0   0   0    1    1    39
[    3.448349] 1    1    0   0   0    1    1    3A
[    3.448349] 1    1    0   0   0    1    1    3A
[    3.449938] 1    1    0   0   0    1    1    3B
[    3.449938] 1    1    0   0   0    1    1    3B
[    3.451431] 0    0    0   0   0    1    1    3C
[    3.451431] 0    0    0   0   0    1    1    3C
[    3.452758] 0    0    0   0   0    1    1    3D
[    3.452758] 0    0    0   0   0    1    1    3D
[    3.454254] 0    0    0   0   0    1    1    3E
[    3.454254] 0    0    0   0   0    1    1    3E
[    3.455727] 0    0    0   0   0    1    1    3F
[    3.455727] 0    0    0   0   0    1    1    3F
[    3.457297] 1    0    0   0   0    0    0    00
[    3.457297] 1    0    0   0   0    0    0    00
[    3.458927] 1    0    0   0   0    0    0    00
[    3.458927] 1    0    0   0   0    0    0    00
[    3.460547] 1    0    0   0   0    0    0    00
[    3.460547] 1    0    0   0   0    0    0    00
[    3.462117] 1    0    0   0   0    0    0    00
[    3.462117] 1    0    0   0   0    0    0    00
[    3.463671] 1    0    0   0   0    0    0    00
[    3.463671] 1    0    0   0   0    0    0    00
[    3.465240] 1    0    0   0   0    0    0    00
[    3.465240] 1    0    0   0   0    0    0    00
[    3.466831] 1    0    0   0   0    0    0    00
[    3.466831] 1    0    0   0   0    0    0    00
[    3.468390] 1    0    0   0   0    0    0    00
[    3.468390] 1    0    0   0   0    0    0    00
[    3.469929] IRQ to pin mappings:
[    3.469929] IRQ to pin mappings:
[    3.471036] IRQ0=20
[    3.471036] IRQ0 -> 0:2-> 0:2

[    3.471961] IRQ1=20
[    3.471961] IRQ1 -> 0:1-> 0:1

[    3.472874] IRQ3=20
[    3.472874] IRQ3 -> 0:3-> 0:3

[    3.473785] IRQ4=20
[    3.473785] IRQ4 -> 0:4-> 0:4

[    3.474710] IRQ5=20
[    3.474710] IRQ5 -> 0:5-> 0:5

[    3.475624] IRQ6=20
[    3.475624] IRQ6 -> 0:6-> 0:6

[    3.476547] IRQ7=20
[    3.476547] IRQ7 -> 0:7-> 0:7

[    3.477457] IRQ8=20
[    3.477457] IRQ8 -> 0:8-> 0:8

[    3.478351] IRQ9=20
[    3.478351] IRQ9 -> 0:9-> 0:9

[    3.479273] IRQ10=20
[    3.479273] IRQ10 -> 0:10-> 0:10

[    3.480261] IRQ11=20
[    3.480261] IRQ11 -> 0:11-> 0:11

[    3.481157] IRQ12=20
[    3.481157] IRQ12 -> 0:12-> 0:12

[    3.482151] IRQ13=20
[    3.482151] IRQ13 -> 0:13-> 0:13

[    3.483160] IRQ14=20
[    3.483160] IRQ14 -> 0:14-> 0:14

[    3.484119] IRQ15=20
[    3.484119] IRQ15 -> 0:15-> 0:15

[    3.485084] .................................... done.
[    3.485084] .................................... done.
[    3.487180] turn off boot console earlyser0
[    3.487180] turn off boot console earlyser0
[    3.498606] Freeing unused kernel memory: 2572K (ffffffff89168000 - ffff=
ffff893eb000)
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   13.716182] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   14.064896] sock: sock_set_timeout: `trinity-main' (pid 110) tries to se=
t negative timeout
[   14.495953] vmalloc: allocation failure: 268443519 bytes
[   14.497012] trinity-c1: page allocation failure: order:0, mode:0xd2
[   14.498161] CPU: 1 PID: 2306 Comm: trinity-c1 Not tainted 3.12.0-rc4-000=
14-gda2b6fb #1
[   14.499628]  ffffffff89000090 ffff880006d39dc8 ffffffff88e1492a 00000000=
000000d2
[   14.501182]  ffff880006d39e50 ffffffff888ec0b7 ffffffff89000090 ffff8800=
06d39de8
[   14.502667]  ffff880000000018 ffff880006d39e60 ffff880006d39e00 ffffffff=
88809c69
[   14.504138] Call Trace:
[   14.504624]  [<ffffffff88e1492a>] dump_stack+0x54/0x74
[   14.505586]  [<ffffffff888ec0b7>] warn_alloc_failed+0x117/0x130
[   14.506696]  [<ffffffff88809c69>] ? sched_clock+0x9/0x10
[   14.507657]  [<ffffffff8888842d>] ? sched_clock_local+0x1d/0x80
[   14.508763]  [<ffffffff888bc0e0>] ? SyS_init_module+0x50/0xc0
[   14.509862]  [<ffffffff88913597>] __vmalloc_node_range+0x247/0x260
[   14.511076]  [<ffffffff88888701>] ? local_clock+0x41/0x60
[   14.512092]  [<ffffffff88913806>] vmalloc+0x46/0x50
[   14.513000]  [<ffffffff888bc0e0>] ? SyS_init_module+0x50/0xc0
[   14.514078]  [<ffffffff888bc0e0>] SyS_init_module+0x50/0xc0
[   14.515137]  [<ffffffff88e242b9>] system_call_fastpath+0x16/0x1b
[   14.516258] Mem-Info:
[   14.516694] Node 0 DMA per-cpu:
[   14.517303] CPU    0: hi:    0, btch:   1 usd:   0
[   14.518220] CPU    1: hi:    0, btch:   1 usd:   0
[   14.519071] Node 0 DMA32 per-cpu:
[   14.519730] CPU    0: hi:   90, btch:  15 usd:  88
[   14.520665] CPU    1: hi:   90, btch:  15 usd:  16
[   14.521590] active_anon:1302 inactive_anon:96 isolated_anon:0
[   14.521590]  active_file:2467 inactive_file:16361 isolated_file:0
[   14.521590]  unevictable:0 dirty:0 writeback:0 unstable:0
[   14.521590]  free:27901 slab_reclaimable:4062 slab_unreclaimable:5236
[   14.521590]  mapped:788 shmem:186 pagetables:94 bounce:0
[   14.521590]  free_cma:0
[   14.526908] Node 0 DMA free:14556kB min:132kB low:164kB high:196kB activ=
e_anon:292kB inactive_anon:16kB active_file:0kB inactive_file:0kB unevictab=
le:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908k=
B mlocked:0kB dirty:0kB writeback:0kB mapped:16kB shmem:16kB slab_reclaimab=
le:564kB slab_unreclaimable:340kB kernel_stack:32kB pagetables:16kB unstabl=
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unrecla=
imable? yes
[   14.533704] lowmem_reserve[]: 0 209 209 209
[   14.534589] Node 0 DMA32 free:97012kB min:1780kB low:2224kB high:2668kB =
active_anon:4952kB inactive_anon:368kB active_file:9868kB inactive_file:654=
44kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:245752kB=
 managed:216608kB mlocked:0kB dirty:0kB writeback:0kB mapped:3136kB shmem:7=
28kB slab_reclaimable:15684kB slab_unreclaimable:20644kB kernel_stack:464kB=
 pagetables:360kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pa=
ges_scanned:0 all_unreclaimable? no
[   14.542326] lowmem_reserve[]: 0 0 0 0
[   14.543170] Node 0 DMA: 4*4kB (UM) 4*8kB (UEM) 7*16kB (U) 2*32kB (U) 4*6=
4kB (UEM) 2*128kB (EM) 2*256kB (UE) 2*512kB (UM) 2*1024kB (EM) 3*2048kB (EM=
R) 1*4096kB (M) =3D 14560kB
[   14.546760] Node 0 DMA32: 19*4kB (UEM) 2*8kB (UM) 28*16kB (UEM) 34*32kB =
(UEM) 20*64kB (UEM) 9*128kB (UM) 3*256kB (M) 4*512kB (UEM) 0*1024kB 2*2048k=
B (M) 21*4096kB (MR) =3D 96988kB
[   14.550381] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   14.551932] 19011 total pagecache pages
[   14.554527] 65533 pages RAM
[   14.555089] 7404 pages reserved
[   14.555697] 4015 pages shared
[   14.556269] 28190 pages non-shared
 * Asking all remaining processes to terminate...      =20
killall5[2336]: mount returned non-zero exit status
killall5[2336]: /proc not mounted, failed to mount.

mount: proc has wrong device number or fs type proc not supported
killall5[2346]: mount returned non-zero exit status
killall5[2346]: /proc not mounted, failed to mount.
 * All processes ended within 1 seconds....      =20
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
 * Will now restart
[   69.043249] Unregister pv shared memory for cpu 0
[   69.043938] Unregister pv shared memory for cpu 1
[   69.046378] reboot: Restarting system
[   69.046911] reboot: machine restart
Elapsed time: 75
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-01101738/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00=
014-gda2b6fb -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/.vmlinuz-=
da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-95-roam branch=3Dti=
p/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da2b6fb990cf=
782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb'  -initrd /k=
ernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D1=
,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::12971-:22 -boot order=3Dnc=
 -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABE=
L=3DKVM/disk0-quantal-roam-24,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LA=
BEL=3DKVM/disk1-quantal-roam-24,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/=
LABEL=3DKVM/disk2-quantal-roam-24,media=3Ddisk,if=3Dvirtio -drive file=3D/f=
s/LABEL=3DKVM/disk3-quantal-roam-24,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk4-quantal-roam-24,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk5-quantal-roam-24,media=3Ddisk,if=3Dvirtio -pidfile =
/dev/shm/kboot/pid-quantal-roam-24 -serial file:/dev/shm/kboot/serial-quant=
al-roam-24 -daemonize -display none -monitor null=20

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-snb-26:20140116085613:x86_64-randconfig-s1-01101738:3.12.0-rc4-00014-gda2b6fb:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00014-gda2b6fb (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 08:53:36 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/=
=2Evmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-31-snb b=
ranch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da=
2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0fe86000, 0x0fe86fff] PGTABLE
[    0.000000] BRK [0x0fe87000, 0x0fe87fff] PGTABLE
[    0.000000] BRK [0x0fe88000, 0x0fe88fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000da0000=
0-ffff88000ddfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000e200000 s1914448 r8=
192 d22960 u2097152
[    0.000000] pcpu-alloc: s1914448 r8192 d22960 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e20d080
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:=
kaslr/.vmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-31-s=
nb branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-0110173=
8/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 228492K/261744K available (6294K kernel code, 685K r=
wdata, 2640K rodata, 2572K init, 10836K bss, 33252K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00014-gda2b6fb (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 08:53:36 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/=
=2Evmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-31-snb b=
ranch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da=
2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0fe86000, 0x0fe86fff] PGTABLE
[    0.000000] BRK [0x0fe87000, 0x0fe87fff] PGTABLE
[    0.000000] BRK [0x0fe88000, 0x0fe88fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000da0000=
0-ffff88000ddfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000e200000 s1914448 r8=
192 d22960 u2097152
[    0.000000] pcpu-alloc: s1914448 r8192 d22960 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e20d080
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:=
kaslr/.vmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-31-s=
nb branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-0110173=
8/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 228492K/261744K available (6294K kernel code, 685K r=
wdata, 2640K rodata, 2572K init, 10836K bss, 33252K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2300.194 MHz processor
[    0.000000] tsc: Detected 2300.194 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 4600.38 Bogo=
MIPS (lpj=3D23001940)
4600.38 BogoMIPS (lpj=3D23001940)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020575] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020575] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.025419] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.025419] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.030317] Mount-cache hash table entries: 256
[    0.030317] Mount-cache hash table entries: 256
[    0.033842] Initializing cgroup subsys devices
[    0.033842] Initializing cgroup subsys devices
[    0.035850] Initializing cgroup subsys freezer
[    0.035850] Initializing cgroup subsys freezer
[    0.037982] Initializing cgroup subsys net_cls
[    0.037982] Initializing cgroup subsys net_cls
[    0.040240] mce: CPU supports 10 MCE banks
[    0.040240] mce: CPU supports 10 MCE banks
[    0.042081] numa_add_cpu cpu 0 node 0: mask now 0
[    0.042081] numa_add_cpu cpu 0 node 0: mask now 0
[    0.045320] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045320] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045320] tlb_flushall_shift: 6
[    0.045320] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045320] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045320] tlb_flushall_shift: 6
[    0.050372] Freeing SMP alternatives memory: 24K (ffffffff8f3eb000 - fff=
fffff8f3f1000)
[    0.050372] Freeing SMP alternatives memory: 24K (ffffffff8f3eb000 - fff=
fffff8f3f1000)
[    0.061941] ACPI: Core revision 20130725
[    0.061941] ACPI: Core revision 20130725
[    0.070944] ACPI:=20
[    0.070944] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.073796] Getting VERSION: 50014
[    0.073796] Getting VERSION: 50014
[    0.075334] Getting VERSION: 50014
[    0.075334] Getting VERSION: 50014
[    0.076789] Getting ID: 0
[    0.076789] Getting ID: 0
[    0.078963] Getting ID: ff000000
[    0.078963] Getting ID: ff000000
[    0.080037] Getting LVT0: 8700
[    0.080037] Getting LVT0: 8700
[    0.081278] Getting LVT1: 8400
[    0.081278] Getting LVT1: 8400
[    0.082672] enabled ExtINT on CPU#0
[    0.082672] enabled ExtINT on CPU#0
[    0.085885] ENABLING IO-APIC IRQs
[    0.085885] ENABLING IO-APIC IRQs
[    0.087267] init IO_APIC IRQs
[    0.087267] init IO_APIC IRQs
[    0.088862]  apic 0 pin 0 not connected
[    0.088862]  apic 0 pin 0 not connected
[    0.090081] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.090081] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.093005] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.093005] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.096015] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.096015] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.100077] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.100077] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.102818] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.102818] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.105951] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.105951] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.110079] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.110079] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.113137] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.113137] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.116196] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.116196] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.120081] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.120081] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.123162] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.123162] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.126168] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.126168] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.130077] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.130077] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.133297] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.133297] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.136343] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.136343] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.140062]  apic 0 pin 16 not connected
[    0.140062]  apic 0 pin 16 not connected
[    0.141570]  apic 0 pin 17 not connected
[    0.141570]  apic 0 pin 17 not connected
[    0.143077]  apic 0 pin 18 not connected
[    0.143077]  apic 0 pin 18 not connected
[    0.144607]  apic 0 pin 19 not connected
[    0.144607]  apic 0 pin 19 not connected
[    0.146112]  apic 0 pin 20 not connected
[    0.146112]  apic 0 pin 20 not connected
[    0.147742]  apic 0 pin 21 not connected
[    0.147742]  apic 0 pin 21 not connected
[    0.149239]  apic 0 pin 22 not connected
[    0.149239]  apic 0 pin 22 not connected
[    0.150022]  apic 0 pin 23 not connected
[    0.150022]  apic 0 pin 23 not connected
[    0.151721] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.151721] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.154721] smpboot: CPU0:=20
[    0.154721] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.160021] Using local APIC timer interrupts.
[    0.160021] calibrating APIC timer ...
[    0.160021] Using local APIC timer interrupts.
[    0.160021] calibrating APIC timer ...
[    0.170000] ... lapic delta =3D 6249621
[    0.170000] ... lapic delta =3D 6249621
[    0.170000] ... PM-Timer delta =3D 357932
[    0.170000] ... PM-Timer delta =3D 357932
[    0.170000] ... PM-Timer result ok
[    0.170000] ... PM-Timer result ok
[    0.170000] ..... delta 6249621
[    0.170000] ..... delta 6249621
[    0.170000] ..... mult: 268419178
[    0.170000] ..... mult: 268419178
[    0.170000] ..... calibration result: 9999393
[    0.170000] ..... calibration result: 9999393
[    0.170000] ..... CPU clock speed is 2299.8185 MHz.
[    0.170000] ..... CPU clock speed is 2299.8185 MHz.
[    0.170000] ..... host bus clock speed is 999.9393 MHz.
[    0.170000] ..... host bus clock speed is 999.9393 MHz.
[    0.170183] Performance Events:=20
[    0.170183] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.177389] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.177389] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.181440] SMP alternatives: lockdep: fixing up alternatives
[    0.181440] SMP alternatives: lockdep: fixing up alternatives
[    0.184619] smpboot: Booting Node   0, Processors=20
[    0.184619] smpboot: Booting Node   0, Processors  #   1 OK
 #   1 OK
[    0.177245] kvm-clock: cpu 1, msr 0:fff8041, secondary cpu clock
[    0.177245] masked ExtINT on CPU#1
[    0.177245] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.210224] KVM setup async PF for cpu 1
[    0.210224] KVM setup async PF for cpu 1
[    0.210337] Brought up 2 CPUs
[    0.210337] Brought up 2 CPUs
[    0.210341] smpboot: Total of 2 processors activated (9200.77 BogoMIPS)
[    0.210341] smpboot: Total of 2 processors activated (9200.77 BogoMIPS)
[    0.215984] kvm-stealtime: cpu 1, msr e40d080
[    0.215984] kvm-stealtime: cpu 1, msr e40d080
[    0.226149] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.226149] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.231079] regulator-dummy: no parameters
[    0.231079] regulator-dummy: no parameters
[    0.233409] NET: Registered protocol family 16
[    0.233409] NET: Registered protocol family 16
[    0.235807] cpuidle: using governor ladder
[    0.235807] cpuidle: using governor ladder
[    0.237374] cpuidle: using governor menu
[    0.237374] cpuidle: using governor menu
[    0.239105] ACPI: bus type PCI registered
[    0.239105] ACPI: bus type PCI registered
[    0.240124] PCI: Using configuration type 1 for base access
[    0.240124] PCI: Using configuration type 1 for base access
[    0.250640] bio: create slab <bio-0> at 0
[    0.250640] bio: create slab <bio-0> at 0
[    0.252228] ACPI: Added _OSI(Module Device)
[    0.252228] ACPI: Added _OSI(Module Device)
[    0.252228] ACPI: Added _OSI(Processor Device)
[    0.252228] ACPI: Added _OSI(Processor Device)
[    0.253782] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.253782] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.260023] ACPI: Added _OSI(Processor Aggregator Device)
[    0.260023] ACPI: Added _OSI(Processor Aggregator Device)
[    0.265992] ACPI: EC: Look up EC in DSDT
[    0.265992] ACPI: EC: Look up EC in DSDT
[    0.281617] ACPI: Interpreter enabled
[    0.281617] ACPI: Interpreter enabled
[    0.283077] ACPI Exception: AE_NOT_FOUND,=20
[    0.283077] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.286638] ACPI Exception: AE_NOT_FOUND,=20
[    0.286638] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.290119] ACPI: (supports S0 S3 S5)
[    0.290119] ACPI: (supports S0 S3 S5)
[    0.291434] ACPI: Using IOAPIC for interrupt routing
[    0.291434] ACPI: Using IOAPIC for interrupt routing
[    0.293362] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.293362] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.325441] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.325441] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.327854] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.327854] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.331500] PCI host bridge to bus 0000:00
[    0.331500] PCI host bridge to bus 0000:00
[    0.333086] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.333086] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.335213] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.335213] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.337511] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.337511] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.340038] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.340038] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.342583] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.342583] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.345380] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.345380] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.350225] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.350225] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.354096] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.354096] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.361565] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.361565] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.366778] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.366778] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.370071] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.370071] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.372777] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.372777] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.376514] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.376514] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.381248] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.381248] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.390156] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.390156] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.405066] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.405066] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.410124] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.410124] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.414483] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.414483] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.418761] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.418761] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.430949] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.430949] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.434563] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.434563] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.438748] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.438748] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.442001] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.442001] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.455941] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.455941] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.460027] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.460027] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.464148] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.464148] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.478029] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.478029] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.482087] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.482087] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.486078] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.486078] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.500258] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.500258] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.504582] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.504582] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.508612] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.508612] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.521261] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.521261] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.525602] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.525602] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.530026] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.530026] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.543177] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.543177] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.547532] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.547532] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.551944] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.551944] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.565081] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.565081] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.568387] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.568387] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.582495] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.582495] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.585411] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.585411] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.588242] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.588242] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.591131] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.591131] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.593575] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.593575] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.597748] ACPI:=20
[    0.597748] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.599731] ACPI: \_SB_.PCI0: notify handler is installed
[    0.599731] ACPI: \_SB_.PCI0: notify handler is installed
[    0.600298] Found 1 acpi root devices
[    0.600298] Found 1 acpi root devices
[    0.602992] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.602992] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.606071] vgaarb: loaded
[    0.606071] vgaarb: loaded
[    0.607115] vgaarb: bridge control possible 0000:00:02.0
[    0.607115] vgaarb: bridge control possible 0000:00:02.0
[    0.610761] Linux video capture interface: v2.00
[    0.610761] Linux video capture interface: v2.00
[    0.612671] pps_core: LinuxPPS API ver. 1 registered
[    0.612671] pps_core: LinuxPPS API ver. 1 registered
[    0.614477] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.614477] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.618053] PTP clock support registered
[    0.618053] PTP clock support registered
[    0.620081] EDAC MC: Ver: 3.0.0
[    0.620081] EDAC MC: Ver: 3.0.0
[    0.622464] PCI: Using ACPI for IRQ routing
[    0.622464] PCI: Using ACPI for IRQ routing
[    0.622464] PCI: pci_cache_line_size set to 64 bytes
[    0.622464] PCI: pci_cache_line_size set to 64 bytes
[    0.624093] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.624093] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.630059] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.630059] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.633606] Bluetooth: Core ver 2.16
[    0.633606] Bluetooth: Core ver 2.16
[    0.635060] NET: Registered protocol family 31
[    0.635060] NET: Registered protocol family 31
[    0.636807] Bluetooth: HCI device and connection manager initialized
[    0.636807] Bluetooth: HCI device and connection manager initialized
[    0.639216] Bluetooth: HCI socket layer initialized
[    0.639216] Bluetooth: HCI socket layer initialized
[    0.640034] Bluetooth: L2CAP socket layer initialized
[    0.640034] Bluetooth: L2CAP socket layer initialized
[    0.642024] Bluetooth: SCO socket layer initialized
[    0.642024] Bluetooth: SCO socket layer initialized
[    0.643960] NET: Registered protocol family 8
[    0.643960] NET: Registered protocol family 8
[    0.645636] NET: Registered protocol family 20
[    0.645636] NET: Registered protocol family 20
[    0.647426] nfc: nfc_init: NFC Core ver 0.1
[    0.647426] nfc: nfc_init: NFC Core ver 0.1
[    0.650201] NET: Registered protocol family 39
[    0.650201] NET: Registered protocol family 39
[    0.652349] Switched to clocksource kvm-clock
[    0.652349] Switched to clocksource kvm-clock
[    0.652929] FS-Cache: Loaded
[    0.652929] FS-Cache: Loaded
[    0.653999] pnp: PnP ACPI init
[    0.653999] pnp: PnP ACPI init
[    0.655090] ACPI: bus type PNP registered
[    0.655090] ACPI: bus type PNP registered
[    0.656647] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.656647] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.659909] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.659909] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.662805] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.662805] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.665786] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.665786] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.668241] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.668241] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.671359] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.671359] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.673721] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.673721] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.676474] pnp 00:03: [dma 2]
[    0.676474] pnp 00:03: [dma 2]
[    0.677798] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.677798] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.680227] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.680227] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.683178] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.683178] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.685714] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.685714] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.689007] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.689007] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.692280] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.692280] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.695108] pnp: PnP ACPI: found 7 devices
[    0.695108] pnp: PnP ACPI: found 7 devices
[    0.696507] ACPI: bus type PNP unregistered
[    0.696507] ACPI: bus type PNP unregistered
[    0.704099] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.704099] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.706096] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.706096] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.708500] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.708500] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.710660] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.710660] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.713351] NET: Registered protocol family 2
[    0.713351] NET: Registered protocol family 2
[    0.715997] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.715997] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.718616] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.718616] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.721404] TCP: Hash tables configured (established 2048 bind 2048)
[    0.721404] TCP: Hash tables configured (established 2048 bind 2048)
[    0.724210] TCP: reno registered
[    0.724210] TCP: reno registered
[    0.725418] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.725418] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.727615] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.727615] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.730549] NET: Registered protocol family 1
[    0.730549] NET: Registered protocol family 1
[    0.732101] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.732101] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.734238] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.734238] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.736239] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.736239] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.738416] pci 0000:00:02.0: Boot video device
[    0.738416] pci 0000:00:02.0: Boot video device
[    0.740245] PCI: CLS 0 bytes, default 64
[    0.740245] PCI: CLS 0 bytes, default 64
[    0.742246] Unpacking initramfs...
[    0.742246] Unpacking initramfs...
[    0.743744] Initramfs unpacking failed: junk in compressed archive
[    0.743744] Initramfs unpacking failed: junk in compressed archive
[    0.750205] general protection fault: 0000 [#1]=20
[    0.750205] general protection fault: 0000 [#1] SMP SMP=20

[    0.751996] Modules linked in:
[    0.751996] Modules linked in:

[    0.753129] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00014-g=
da2b6fb #1
[    0.753129] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00014-g=
da2b6fb #1
[    0.755746] task: ffff88000d4e6040 ti: ffff88000d4e8000 task.ti: ffff880=
00d4e8000
[    0.755746] task: ffff88000d4e6040 ti: ffff88000d4e8000 task.ti: ffff880=
00d4e8000
[    0.759012] RIP: 0010:[<ffffffff8e8af400>]=20
[    0.759012] RIP: 0010:[<ffffffff8e8af400>]  [<ffffffff8e8af400>] __lock_=
acquire+0x550/0x1450
 [<ffffffff8e8af400>] __lock_acquire+0x550/0x1450
[    0.760035] RSP: 0000:ffff88000d4e9be0  EFLAGS: 00010086
[    0.760035] RSP: 0000:ffff88000d4e9be0  EFLAGS: 00010086
[    0.760035] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 00000000000=
00000
[    0.760035] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 00000000000=
00000
[    0.760035] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8fc=
f6cd0
[    0.760035] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8fc=
f6cd0
[    0.760035] RBP: ffff88000d4e9c40 R08: 0000000000000002 R09: 00000000000=
00001
[    0.760035] RBP: ffff88000d4e9c40 R08: 0000000000000002 R09: 00000000000=
00001
[    0.760035] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88000d4=
e6040
[    0.760035] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88000d4=
e6040
[    0.760035] R13: cccccccccccccccc R14: ffffffff8fcf6cd0 R15: 00000000000=
00000
[    0.760035] R13: cccccccccccccccc R14: ffffffff8fcf6cd0 R15: 00000000000=
00000
[    0.760035] FS:  0000000000000000(0000) GS:ffff88000e400000(0000) knlGS:=
0000000000000000
[    0.760035] FS:  0000000000000000(0000) GS:ffff88000e400000(0000) knlGS:=
0000000000000000
[    0.760035] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.760035] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.760035] CR2: 00000000ffffffff CR3: 000000000f0c5000 CR4: 00000000000=
006e0
[    0.760035] CR2: 00000000ffffffff CR3: 000000000f0c5000 CR4: 00000000000=
006e0
[    0.760035] Stack:
[    0.760035] Stack:
[    0.760035]  ffffffff8e809c69
[    0.760035]  ffffffff8e809c69 ffff88000d4e9c10 ffff88000d4e9c10 ffffffff=
8e88842d ffffffff8e88842d ffff88000e5d3180 ffff88000e5d3180

[    0.760035]  00000000001d3180
[    0.760035]  00000000001d3180 0000000000000001 0000000000000001 ffff8800=
0d4e9c38 ffff88000d4e9c38 0000000000000046 0000000000000046

[    0.760035]  ffff88000d4e6040
[    0.760035]  ffff88000d4e6040 0000000000000000 0000000000000000 00000000=
00000000 0000000000000000 0000000000000000 0000000000000000

[    0.760035] Call Trace:
[    0.760035] Call Trace:
[    0.760035]  [<ffffffff8e809c69>] ? sched_clock+0x9/0x10
[    0.760035]  [<ffffffff8e809c69>] ? sched_clock+0x9/0x10
[    0.760035]  [<ffffffff8e88842d>] ? sched_clock_local+0x1d/0x80
[    0.760035]  [<ffffffff8e88842d>] ? sched_clock_local+0x1d/0x80
[    0.760035]  [<ffffffff8e8b03ac>] lock_acquire+0xac/0xe0
[    0.760035]  [<ffffffff8e8b03ac>] lock_acquire+0xac/0xe0
[    0.760035]  [<ffffffff8eaabc1b>] ? debug_check_no_obj_freed+0xcb/0x260
[    0.760035]  [<ffffffff8eaabc1b>] ? debug_check_no_obj_freed+0xcb/0x260
[    0.760035]  [<ffffffff8ee1d069>] _raw_spin_lock_irqsave+0x59/0xa0
[    0.760035]  [<ffffffff8ee1d069>] _raw_spin_lock_irqsave+0x59/0xa0
[    0.760035]  [<ffffffff8eaabc1b>] ? debug_check_no_obj_freed+0xcb/0x260
[    0.760035]  [<ffffffff8eaabc1b>] ? debug_check_no_obj_freed+0xcb/0x260
[    0.760035]  [<ffffffff8eaabc1b>] debug_check_no_obj_freed+0xcb/0x260
[    0.760035]  [<ffffffff8eaabc1b>] debug_check_no_obj_freed+0xcb/0x260
[    0.760035]  [<ffffffff8e8ee00b>] free_pages_prepare+0x7b/0x130
[    0.760035]  [<ffffffff8e8ee00b>] free_pages_prepare+0x7b/0x130
[    0.760035]  [<ffffffff8e8eeb30>] free_hot_cold_page+0x30/0x170
[    0.760035]  [<ffffffff8e8eeb30>] free_hot_cold_page+0x30/0x170
[    0.760035]  [<ffffffff8e8eecf8>] __free_pages+0x28/0x40
[    0.760035]  [<ffffffff8e8eecf8>] __free_pages+0x28/0x40
[    0.760035]  [<ffffffff8e8eefb9>] free_reserved_area+0xb9/0x120
[    0.760035]  [<ffffffff8e8eefb9>] free_reserved_area+0xb9/0x120
[    0.760035]  [<ffffffff8e834a68>] free_init_pages+0x88/0xa0
[    0.760035]  [<ffffffff8e834a68>] free_init_pages+0x88/0xa0
[    0.760035]  [<ffffffff8f34b20f>] free_initrd_mem+0x30/0x35
[    0.760035]  [<ffffffff8f34b20f>] free_initrd_mem+0x30/0x35
[    0.760035]  [<ffffffff8f33e35f>] populate_rootfs+0xea/0x10a
[    0.760035]  [<ffffffff8f33e35f>] populate_rootfs+0xea/0x10a
[    0.760035]  [<ffffffff8f33e275>] ? do_header+0x147/0x147
[    0.760035]  [<ffffffff8f33e275>] ? do_header+0x147/0x147
[    0.760035]  [<ffffffff8e800262>] do_one_initcall+0x92/0x160
[    0.760035]  [<ffffffff8e800262>] do_one_initcall+0x92/0x160
[    0.760035]  [<ffffffff8e87520d>] ? parse_args+0x1dd/0x300
[    0.760035]  [<ffffffff8e87520d>] ? parse_args+0x1dd/0x300
[    0.760035]  [<ffffffff8f33cfc0>] kernel_init_freeable+0x149/0x1d5
[    0.760035]  [<ffffffff8f33cfc0>] kernel_init_freeable+0x149/0x1d5
[    0.760035]  [<ffffffff8f33c836>] ? do_early_param+0x8a/0x8a
[    0.760035]  [<ffffffff8f33c836>] ? do_early_param+0x8a/0x8a
[    0.760035]  [<ffffffff8ee07c20>] ? rest_init+0xe0/0xe0
[    0.760035]  [<ffffffff8ee07c20>] ? rest_init+0xe0/0xe0
[    0.760035]  [<ffffffff8ee07c29>] kernel_init+0x9/0x180
[    0.760035]  [<ffffffff8ee07c29>] kernel_init+0x9/0x180
[    0.760035]  [<ffffffff8ee2420c>] ret_from_fork+0x7c/0xb0
[    0.760035]  [<ffffffff8ee2420c>] ret_from_fork+0x7c/0xb0
[    0.760035]  [<ffffffff8ee07c20>] ? rest_init+0xe0/0xe0
[    0.760035]  [<ffffffff8ee07c20>] ? rest_init+0xe0/0xe0
[    0.760035] Code:=20
[    0.760035] Code: 8e 8e 48 48 c7 c7 c2 c2 43 43 b4 b4 ff ff 8e 8e be be =
39 39 03 03 00 00 00 00 48 48 c7 c7 c7 c7 e8 e8 7f 7f ff ff 8e 8e 31 31 c0 =
c0 e8 e8 50 50 99 99 fa fa ff ff e9 e9 f3 f3 0c 0c 00 00 00 00 4d 4d 85 85 =
ed ed 0f 0f 84 84 ea ea 0c 0c 00 00 00 00 66 66 90 90 <f0> <f0> 41 41 ff ff=
 85 85 98 98 01 01 00 00 00 00 44 44 8b 8b 1d 1d 69 69 d4 d4 b7 b7 00 00 45=
 45 8b 8b 84 84 24 24 50 50 06 06=20

[    0.760035] RIP=20
[    0.760035] RIP  [<ffffffff8e8af400>] __lock_acquire+0x550/0x1450
 [<ffffffff8e8af400>] __lock_acquire+0x550/0x1450
[    0.760035]  RSP <ffff88000d4e9be0>
[    0.760035]  RSP <ffff88000d4e9be0>
[    0.760046] general protection fault: 0000 [#2]=20
[    0.760046] general protection fault: 0000 [#2]=20
[    0.760035] ---[ end trace 2c955ee278493463 ]---
[    0.760035] ---[ end trace 2c955ee278493463 ]---
[    0.760035] Kernel panic - not syncing: Fatal exception
[    0.760035] Kernel panic - not syncing: Fatal exception
SMP SMP=20

[    0.760046] Modules linked in:
[    0.760046] Modules linked in:

[    0.760046] CPU: 0 PID: 11 Comm: rcu_sched Tainted: G      D      3.12.0=
-rc4-00014-gda2b6fb #1
[    0.760046] CPU: 0 PID: 11 Comm: rcu_sched Tainted: G      D      3.12.0=
-rc4-00014-gda2b6fb #1
[    0.760046] task: ffff88000d52a2c0 ti: ffff88000d52c000 task.ti: ffff880=
00d52c000
[    0.760046] task: ffff88000d52a2c0 ti: ffff88000d52c000 task.ti: ffff880=
00d52c000
[    0.760046] RIP: 0010:[<ffffffff8eaaaad9>]=20
[    0.760046] RIP: 0010:[<ffffffff8eaaaad9>]  [<ffffffff8eaaaad9>] free_ob=
ject+0x59/0xb0
 [<ffffffff8eaaaad9>] free_object+0x59/0xb0
[    0.760046] RSP: 0000:ffff88000d52dcb0  EFLAGS: 00010086
[    0.760046] RSP: 0000:ffff88000d52dcb0  EFLAGS: 00010086
[    0.760046] RAX: 0000000000000282 RBX: ffff88000d655268 RCX: 00000000000=
000ff
[    0.760046] RAX: 0000000000000282 RBX: ffff88000d655268 RCX: 00000000000=
000ff
[    0.760046] RDX: cccccccccccccccc RSI: ffffffff8f10e6b8 RDI: 00000000000=
00046
[    0.760046] RDX: cccccccccccccccc RSI: ffffffff8f10e6b8 RDI: 00000000000=
00046
[    0.760046] RBP: ffff88000d52dcc0 R08: 0000000000000000 R09: 00000000000=
00001
[    0.760046] RBP: ffff88000d52dcc0 R08: 0000000000000000 R09: 00000000000=
00001
[    0.760046] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00000
[    0.760046] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00000
[    0.760046] R13: ffffffff8fd73038 R14: ffffffff8f0ed8e0 R15: 00000000fff=
f8b1a
[    0.760046] R13: ffffffff8fd73038 R14: ffffffff8f0ed8e0 R15: 00000000fff=
f8b1a
[    0.760046] FS:  0000000000000000(0000) GS:ffff88000e200000(0000) knlGS:=
0000000000000000
[    0.760046] FS:  0000000000000000(0000) GS:ffff88000e200000(0000) knlGS:=
0000000000000000
[    0.760046] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.760046] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.760046] CR2: 00000000ffffffff CR3: 000000000f0c5000 CR4: 00000000000=
006f0
[    0.760046] CR2: 00000000ffffffff CR3: 000000000f0c5000 CR4: 00000000000=
006f0
[    0.760046] Stack:
[    0.760046] Stack:
[    0.760046]  ffff88000d655268
[    0.760046]  ffff88000d655268 ffff88000d52dd10 ffff88000d52dd10 ffff8800=
0d52dcf8 ffff88000d52dcf8 ffffffff8eaab811 ffffffff8eaab811

[    0.760046]  ffffffff8e8627d8
[    0.760046]  ffffffff8e8627d8 ffff88000d52dd10 ffff88000d52dd10 00000000=
ffff8b1b 00000000ffff8b1b ffffffff8f427c80 ffffffff8f427c80

[    0.760046]  ffffffff8f427c80
[    0.760046]  ffffffff8f427c80 ffff88000d52dda8 ffff88000d52dda8 ffffffff=
8ee17184 ffffffff8ee17184 0000000000000292 0000000000000292

[    0.760046] Call Trace:
[    0.760046] Call Trace:
[    0.760046]  [<ffffffff8eaab811>] debug_object_free+0x161/0x1a0
[    0.760046]  [<ffffffff8eaab811>] debug_object_free+0x161/0x1a0
[    0.760046]  [<ffffffff8e8627d8>] ? del_timer_sync+0xb8/0xf0
[    0.760046]  [<ffffffff8e8627d8>] ? del_timer_sync+0xb8/0xf0
[    0.760046]  [<ffffffff8ee17184>] schedule_timeout+0x194/0x1c0
[    0.760046]  [<ffffffff8ee17184>] schedule_timeout+0x194/0x1c0
[    0.760046]  [<ffffffff8e8620f0>] ? add_timer_on+0x90/0x90
[    0.760046]  [<ffffffff8e8620f0>] ? add_timer_on+0x90/0x90
[    0.760046]  [<ffffffff8e8cfbb5>] rcu_gp_kthread+0x385/0x680
[    0.760046]  [<ffffffff8e8cfbb5>] rcu_gp_kthread+0x385/0x680
[    0.760046]  [<ffffffff8e877fa0>] ? abort_exclusive_wait+0xa0/0xa0
[    0.760046]  [<ffffffff8e877fa0>] ? abort_exclusive_wait+0xa0/0xa0
[    0.760046]  [<ffffffff8e8cf830>] ? rcu_gp_fqs+0x80/0x80
[    0.760046]  [<ffffffff8e8cf830>] ? rcu_gp_fqs+0x80/0x80
[    0.760046]  [<ffffffff8e8772f3>] kthread+0xe3/0xf0
[    0.760046]  [<ffffffff8e8772f3>] kthread+0xe3/0xf0
[    0.760046]  [<ffffffff8e877210>] ? kthread_stop+0x60/0x60
[    0.760046]  [<ffffffff8e877210>] ? kthread_stop+0x60/0x60
[    0.760046]  [<ffffffff8ee2420c>] ret_from_fork+0x7c/0xb0
[    0.760046]  [<ffffffff8ee2420c>] ret_from_fork+0x7c/0xb0
[    0.760046]  [<ffffffff8e877210>] ? kthread_stop+0x60/0x60
[    0.760046]  [<ffffffff8e877210>] ? kthread_stop+0x60/0x60
[    0.760046] Code:=20
[    0.760046] Code: 00 00 74 74 19 19 48 48 83 83 3d 3d 7f 7f 78 78 6b 6b =
00 00 00 00 74 74 0f 0f 4c 4c 8b 8b 25 25 7e 7e 3b 3b 66 66 00 00 41 41 83 =
83 e4 e4 01 01 41 41 83 83 f4 f4 01 01 48 48 8b 8b 15 15 ef ef 64 64 24 24 =
01 01 48 48 85 85 d2 d2 48 48 89 89 13 13 74 74 04 04 <48> <48> 89 89 5a 5a=
 08 08 83 83 c1 c1 01 01 48 48 c7 c7 43 43 08 08 c0 c0 0f 0f cf cf 8f 8f 48=
 48 89 89 c6 c6 48 48 c7 c7 c7 c7=20

[    0.760046] RIP=20
[    0.760046] RIP  [<ffffffff8eaaaad9>] free_object+0x59/0xb0
 [<ffffffff8eaaaad9>] free_object+0x59/0xb0
[    0.760046]  RSP <ffff88000d52dcb0>
[    0.760046]  RSP <ffff88000d52dcb0>
[    0.760046] ---[ end trace 2c955ee278493464 ]---
[    0.760046] ---[ end trace 2c955ee278493464 ]---
[    0.760035] Shutting down cpus with NMI
[    0.760035] Shutting down cpus with NMI
[    0.760035] Rebooting in 10 seconds..
[    0.760035] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-01101738/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00=
014-gda2b6fb -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/.vmlinuz-=
da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-31-snb branch=3Dtip=
/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da2b6fb990cf7=
82b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb'  -initrd /ke=
rnel-tests/initrd/yocto-minimal-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D1=
,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::20349-:22 -boot order=3Dnc=
 -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABE=
L=3DKVM/disk0-yocto-snb-26,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk1-yocto-snb-26,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk2-yocto-snb-26,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk3-yocto-snb-26,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk4-yocto-snb-26,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk5-yocto-snb-26,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/=
pid-yocto-snb-26 -serial file:/dev/shm/kboot/serial-yocto-snb-26 -daemonize=
 -display none -monitor null=20

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-cairo-16:20140116085449:x86_64-randconfig-s1-01101738:3.12.0-rc4-00014-gda2b6fb:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00014-gda2b6fb (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 08:53:36 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/=
=2Evmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-100-cair=
o branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738=
/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0ee86000, 0x0ee86fff] PGTABLE
[    0.000000] BRK [0x0ee87000, 0x0ee87fff] PGTABLE
[    0.000000] BRK [0x0ee88000, 0x0ee88fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0d600000-0x0d7fffff]
[    0.000000]  [mem 0x0d600000-0x0d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0d5fffff]
[    0.000000]  [mem 0x0c000000-0x0d5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0d800000-0x0fffdfff]
[    0.000000]  [mem 0x0d800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ca0000=
0-ffff88000cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000d200000 s1914448 r8=
192 d22960 u2097152
[    0.000000] pcpu-alloc: s1914448 r8192 d22960 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr d20d080
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:=
kaslr/.vmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-100-=
cairo branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-0110=
1738/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2=
b6fb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 212108K/261744K available (6294K kernel code, 685K r=
wdata, 2640K rodata, 2572K init, 10836K bss, 49636K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00014-gda2b6fb (kbuild@snb) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 16 08:53:36 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/=
=2Evmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-100-cair=
o branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738=
/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0ee86000, 0x0ee86fff] PGTABLE
[    0.000000] BRK [0x0ee87000, 0x0ee87fff] PGTABLE
[    0.000000] BRK [0x0ee88000, 0x0ee88fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0d600000-0x0d7fffff]
[    0.000000]  [mem 0x0d600000-0x0d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0d5fffff]
[    0.000000]  [mem 0x0c000000-0x0d5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0d800000-0x0fffdfff]
[    0.000000]  [mem 0x0d800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ca0000=
0-ffff88000cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000d200000 s1914448 r8=
192 d22960 u2097152
[    0.000000] pcpu-alloc: s1914448 r8192 d22960 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr d20d080
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:=
kaslr/.vmlinuz-da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-100-=
cairo branch=3Dtip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-0110=
1738/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2=
b6fb
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 212108K/261744K available (6294K kernel code, 685K r=
wdata, 2640K rodata, 2572K init, 10836K bss, 49636K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.014 MHz processor
[    0.000000] tsc: Detected 2893.014 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.02 Bogo=
MIPS (lpj=3D28930140)
5786.02 BogoMIPS (lpj=3D28930140)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020456] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.020456] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.023243] Mount-cache hash table entries: 256
[    0.023243] Mount-cache hash table entries: 256
[    0.026145] Initializing cgroup subsys devices
[    0.026145] Initializing cgroup subsys devices
[    0.027850] Initializing cgroup subsys freezer
[    0.027850] Initializing cgroup subsys freezer
[    0.030043] Initializing cgroup subsys net_cls
[    0.030043] Initializing cgroup subsys net_cls
[    0.031884] mce: CPU supports 10 MCE banks
[    0.031884] mce: CPU supports 10 MCE banks
[    0.033493] numa_add_cpu cpu 0 node 0: mask now 0
[    0.033493] numa_add_cpu cpu 0 node 0: mask now 0
[    0.035281] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035281] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035281] tlb_flushall_shift: 6
[    0.035281] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035281] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035281] tlb_flushall_shift: 6
[    0.040360] Freeing SMP alternatives memory: 24K (ffffffff8e3eb000 - fff=
fffff8e3f1000)
[    0.040360] Freeing SMP alternatives memory: 24K (ffffffff8e3eb000 - fff=
fffff8e3f1000)
[    0.047772] ACPI: Core revision 20130725
[    0.047772] ACPI: Core revision 20130725
[    0.055471] ACPI:=20
[    0.055471] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.057949] Getting VERSION: 50014
[    0.057949] Getting VERSION: 50014
[    0.059230] Getting VERSION: 50014
[    0.059230] Getting VERSION: 50014
[    0.060028] Getting ID: 0
[    0.060028] Getting ID: 0
[    0.061032] Getting ID: ff000000
[    0.061032] Getting ID: ff000000
[    0.062269] Getting LVT0: 8700
[    0.062269] Getting LVT0: 8700
[    0.063451] Getting LVT1: 8400
[    0.063451] Getting LVT1: 8400
[    0.064693] enabled ExtINT on CPU#0
[    0.064693] enabled ExtINT on CPU#0
[    0.067633] ENABLING IO-APIC IRQs
[    0.067633] ENABLING IO-APIC IRQs
[    0.068790] init IO_APIC IRQs
[    0.068790] init IO_APIC IRQs
[    0.070022]  apic 0 pin 0 not connected
[    0.070022]  apic 0 pin 0 not connected
[    0.071337] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.071337] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.074168] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.074168] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.076965] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.076965] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.080059] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.080059] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.082872] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.082872] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.085920] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.085920] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.088764] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.088764] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.090056] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.090056] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.092958] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.092958] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.095769] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.095769] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.100054] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.100054] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.102750] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.102750] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.105690] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.105690] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.108591] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.108591] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.110054] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.110054] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.112956]  apic 0 pin 16 not connected
[    0.112956]  apic 0 pin 16 not connected
[    0.114303]  apic 0 pin 17 not connected
[    0.114303]  apic 0 pin 17 not connected
[    0.115650]  apic 0 pin 18 not connected
[    0.115650]  apic 0 pin 18 not connected
[    0.117027]  apic 0 pin 19 not connected
[    0.117027]  apic 0 pin 19 not connected
[    0.120017]  apic 0 pin 20 not connected
[    0.120017]  apic 0 pin 20 not connected
[    0.121421]  apic 0 pin 21 not connected
[    0.121421]  apic 0 pin 21 not connected
[    0.122787]  apic 0 pin 22 not connected
[    0.122787]  apic 0 pin 22 not connected
[    0.124165]  apic 0 pin 23 not connected
[    0.124165]  apic 0 pin 23 not connected
[    0.125763] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.125763] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.128605] smpboot: CPU0:=20
[    0.128605] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.132713] Using local APIC timer interrupts.
[    0.132713] calibrating APIC timer ...
[    0.132713] Using local APIC timer interrupts.
[    0.132713] calibrating APIC timer ...
[    0.140000] ... lapic delta =3D 6249998
[    0.140000] ... lapic delta =3D 6249998
[    0.140000] ... PM-Timer delta =3D 357945
[    0.140000] ... PM-Timer delta =3D 357945
[    0.140000] ... PM-Timer result ok
[    0.140000] ... PM-Timer result ok
[    0.140000] ..... delta 6249998
[    0.140000] ..... delta 6249998
[    0.140000] ..... mult: 268435370
[    0.140000] ..... mult: 268435370
[    0.140000] ..... calibration result: 9999996
[    0.140000] ..... calibration result: 9999996
[    0.140000] ..... CPU clock speed is 2894.3283 MHz.
[    0.140000] ..... CPU clock speed is 2894.3283 MHz.
[    0.140000] ..... host bus clock speed is 999.9996 MHz.
[    0.140000] ..... host bus clock speed is 999.9996 MHz.
[    0.140133] Performance Events:=20
[    0.140133] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.146525] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.146525] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.151088] SMP alternatives: lockdep: fixing up alternatives
[    0.151088] SMP alternatives: lockdep: fixing up alternatives
[    0.153722] smpboot: Booting Node   0, Processors=20
[    0.153722] smpboot: Booting Node   0, Processors  #   1 OK
 #   1 OK
[    0.146390] kvm-clock: cpu 1, msr 0:fff8041, secondary cpu clock
[    0.146390] masked ExtINT on CPU#1
[    0.146390] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.170306] Brought up 2 CPUs
[    0.170306] Brought up 2 CPUs
[    0.180010] smpboot: Total of 2 processors activated (11572.05 BogoMIPS)
[    0.180010] smpboot: Total of 2 processors activated (11572.05 BogoMIPS)
[    0.182609] KVM setup async PF for cpu 1
[    0.182609] KVM setup async PF for cpu 1
[    0.182609] kvm-stealtime: cpu 1, msr d40d080
[    0.182609] kvm-stealtime: cpu 1, msr d40d080
[    0.204013] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.204013] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.206996] regulator-dummy: no parameters
[    0.206996] regulator-dummy: no parameters
[    0.209053] NET: Registered protocol family 16
[    0.209053] NET: Registered protocol family 16
[    0.210915] cpuidle: using governor ladder
[    0.210915] cpuidle: using governor ladder
[    0.212340] cpuidle: using governor menu
[    0.212340] cpuidle: using governor menu
[    0.213964] ACPI: bus type PCI registered
[    0.213964] ACPI: bus type PCI registered
[    0.215436] PCI: Using configuration type 1 for base access
[    0.215436] PCI: Using configuration type 1 for base access
[    0.224186] bio: create slab <bio-0> at 0
[    0.224186] bio: create slab <bio-0> at 0
[    0.224186] ACPI: Added _OSI(Module Device)
[    0.224186] ACPI: Added _OSI(Module Device)
[    0.224186] ACPI: Added _OSI(Processor Device)
[    0.224186] ACPI: Added _OSI(Processor Device)
[    0.230013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.230013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.231586] ACPI: Added _OSI(Processor Aggregator Device)
[    0.231586] ACPI: Added _OSI(Processor Aggregator Device)
[    0.237093] ACPI: EC: Look up EC in DSDT
[    0.237093] ACPI: EC: Look up EC in DSDT
[    0.252271] ACPI: Interpreter enabled
[    0.252271] ACPI: Interpreter enabled
[    0.253651] ACPI Exception: AE_NOT_FOUND,=20
[    0.253651] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.256801] ACPI Exception: AE_NOT_FOUND,=20
[    0.256801] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.260095] ACPI: (supports S0 S3 S5)
[    0.260095] ACPI: (supports S0 S3 S5)
[    0.261420] ACPI: Using IOAPIC for interrupt routing
[    0.261420] ACPI: Using IOAPIC for interrupt routing
[    0.263162] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.263162] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.291349] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.291349] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.293449] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.293449] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.297382] PCI host bridge to bus 0000:00
[    0.297382] PCI host bridge to bus 0000:00
[    0.298799] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.298799] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.300016] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.300016] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.302117] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.302117] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.304156] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.304156] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.306513] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.306513] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.309030] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.309030] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.311306] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.311306] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.314890] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.314890] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.323301] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.323301] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.327950] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.327950] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.330693] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.330693] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.333176] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.333176] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.336555] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.336555] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.341146] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.341146] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.345849] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.345849] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.362368] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.362368] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.366204] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.366204] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.370031] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.370031] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.373846] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.373846] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.384316] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.384316] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.387738] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.387738] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.391892] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.391892] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.395646] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.395646] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.407888] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.407888] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.411901] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.411901] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.415573] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.415573] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.427907] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.427907] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.431900] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.431900] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.435651] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.435651] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.447144] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.447144] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.450892] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.450892] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.454587] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.454587] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.467251] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.467251] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.470907] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.470907] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.474537] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.474537] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.486280] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.486280] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.490922] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.490922] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.494642] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.494642] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.506416] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.506416] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.509504] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.509504] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.521669] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.521669] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.524138] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.524138] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.526786] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.526786] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.529339] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.529339] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.530799] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.530799] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.534624] ACPI:=20
[    0.534624] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.536245] ACPI: \_SB_.PCI0: notify handler is installed
[    0.536245] ACPI: \_SB_.PCI0: notify handler is installed
[    0.538324] Found 1 acpi root devices
[    0.538324] Found 1 acpi root devices
[    0.541190] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.541190] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.543854] vgaarb: loaded
[    0.543854] vgaarb: loaded
[    0.544736] vgaarb: bridge control possible 0000:00:02.0
[    0.544736] vgaarb: bridge control possible 0000:00:02.0
[    0.547204] Linux video capture interface: v2.00
[    0.547204] Linux video capture interface: v2.00
[    0.548881] pps_core: LinuxPPS API ver. 1 registered
[    0.548881] pps_core: LinuxPPS API ver. 1 registered
[    0.550012] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.550012] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.553126] PTP clock support registered
[    0.553126] PTP clock support registered
[    0.554570] EDAC MC: Ver: 3.0.0
[    0.554570] EDAC MC: Ver: 3.0.0
[    0.556794] PCI: Using ACPI for IRQ routing
[    0.556794] PCI: Using ACPI for IRQ routing
[    0.556794] PCI: pci_cache_line_size set to 64 bytes
[    0.556794] PCI: pci_cache_line_size set to 64 bytes
[    0.560471] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.560471] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.562697] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.562697] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.565955] Bluetooth: Core ver 2.16
[    0.565955] Bluetooth: Core ver 2.16
[    0.567324] NET: Registered protocol family 31
[    0.567324] NET: Registered protocol family 31
[    0.570016] Bluetooth: HCI device and connection manager initialized
[    0.570016] Bluetooth: HCI device and connection manager initialized
[    0.572392] Bluetooth: HCI socket layer initialized
[    0.572392] Bluetooth: HCI socket layer initialized
[    0.574149] Bluetooth: L2CAP socket layer initialized
[    0.574149] Bluetooth: L2CAP socket layer initialized
[    0.576049] Bluetooth: SCO socket layer initialized
[    0.576049] Bluetooth: SCO socket layer initialized
[    0.577646] NET: Registered protocol family 8
[    0.577646] NET: Registered protocol family 8
[    0.579244] NET: Registered protocol family 20
[    0.579244] NET: Registered protocol family 20
[    0.580212] nfc: nfc_init: NFC Core ver 0.1
[    0.580212] nfc: nfc_init: NFC Core ver 0.1
[    0.581743] NET: Registered protocol family 39
[    0.581743] NET: Registered protocol family 39
[    0.583731] Switched to clocksource kvm-clock
[    0.583731] Switched to clocksource kvm-clock
[    0.583731] FS-Cache: Loaded
[    0.583731] FS-Cache: Loaded
[    0.583731] pnp: PnP ACPI init
[    0.583731] pnp: PnP ACPI init
[    0.584911] ACPI: bus type PNP registered
[    0.584911] ACPI: bus type PNP registered
[    0.586520] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.586520] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.589533] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.589533] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.591934] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.591934] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.594572] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.594572] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.596679] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.596679] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.599354] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.599354] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.601555] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.601555] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.604047] pnp 00:03: [dma 2]
[    0.604047] pnp 00:03: [dma 2]
[    0.605179] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.605179] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.607376] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.607376] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.609966] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.609966] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.612231] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.612231] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.614861] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.614861] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.617682] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.617682] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.620261] pnp: PnP ACPI: found 7 devices
[    0.620261] pnp: PnP ACPI: found 7 devices
[    0.621529] ACPI: bus type PNP unregistered
[    0.621529] ACPI: bus type PNP unregistered
[    0.628682] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.628682] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.630478] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.630478] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.632210] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.632210] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.634152] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.634152] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.636489] NET: Registered protocol family 2
[    0.636489] NET: Registered protocol family 2
[    0.638752] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.638752] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.641140] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.641140] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.643492] TCP: Hash tables configured (established 2048 bind 2048)
[    0.643492] TCP: Hash tables configured (established 2048 bind 2048)
[    0.645640] TCP: reno registered
[    0.645640] TCP: reno registered
[    0.646669] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.646669] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.648618] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.648618] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.651180] NET: Registered protocol family 1
[    0.651180] NET: Registered protocol family 1
[    0.652552] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.652552] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.654426] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.654426] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.656257] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.656257] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.658197] pci 0000:00:02.0: Boot video device
[    0.658197] pci 0000:00:02.0: Boot video device
[    0.659738] PCI: CLS 0 bytes, default 64
[    0.659738] PCI: CLS 0 bytes, default 64
[    0.661605] Unpacking initramfs...
[    0.661605] Unpacking initramfs...
[    0.671523] Initramfs unpacking failed: junk in compressed archive
[    0.671523] Initramfs unpacking failed: junk in compressed archive
[    0.678074] general protection fault: 0000 [#1]=20
[    0.678074] general protection fault: 0000 [#1] SMP SMP=20

[    0.679722] Modules linked in:
[    0.679722] Modules linked in: [last unloaded:=20

[    0.680040] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00014-g=
da2b6fb #1
[    0.680040] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00014-g=
da2b6fb #1
[    0.680040] task: ffff88000c4e6040 ti: ffff88000c4e8000 task.ti: ffff880=
00c4e8000
[    0.680040] task: ffff88000c4e6040 ti: ffff88000c4e8000 task.ti: ffff880=
00c4e8000
[    0.680040] RIP: 0010:[<ffffffff8d8ecf8e>]=20
[    0.680040] RIP: 0010:[<ffffffff8d8ecf8e>]  [<ffffffff8d8ecf8e>] get_pag=
eblock_flags_group+0x4e/0xa0
 [<ffffffff8d8ecf8e>] get_pageblock_flags_group+0x4e/0xa0
[    0.680040] RSP: 0000:ffff88000c4e9d80  EFLAGS: 00010206
[    0.680040] RSP: 0000:ffff88000c4e9d80  EFLAGS: 00010206
[    0.680040] RAX: ccccccccccccccdc RBX: ffffea000033d1e0 RCX: 00000000000=
00010
[    0.680040] RAX: ccccccccccccccdc RBX: ffffea000033d1e0 RCX: 00000000000=
00010
[    0.680040] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000=
06ce4
[    0.680040] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000=
06ce4
[    0.680040] RBP: ffff88000c4e9d80 R08: 0000000000000001 R09: 00000000000=
00000
[    0.680040] RBP: ffff88000c4e9d80 R08: 0000000000000001 R09: 00000000000=
00000
[    0.680040] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00780
[    0.680040] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00780
[    0.680040] R13: 0000000000000000 R14: ffff88000fff9780 R15: ffff88000ec=
e4000
[    0.680040] R13: 0000000000000000 R14: ffff88000fff9780 R15: ffff88000ec=
e4000
[    0.680040] FS:  0000000000000000(0000) GS:ffff88000d400000(0000) knlGS:=
0000000000000000
[    0.680040] FS:  0000000000000000(0000) GS:ffff88000d400000(0000) knlGS:=
0000000000000000
[    0.680040] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.680040] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.680040] CR2: 00000000ffffffff CR3: 000000000e0c5000 CR4: 00000000000=
006e0
[    0.680040] CR2: 00000000ffffffff CR3: 000000000e0c5000 CR4: 00000000000=
006e0
[    0.680040] Stack:
[    0.680040] Stack:
[    0.680040]  ffff88000c4e9dc0
[    0.680040]  ffff88000c4e9dc0 ffffffff8d8eeb60 ffffffff8d8eeb60 ffffffff=
8e0f83e0 ffffffff8e0f83e0 00000000000003a7 00000000000003a7

[    0.680040]  ffff88000fff0000
[    0.680040]  ffff88000fff0000 00000000000000cc 00000000000000cc ffffea00=
0033d1e0 ffffea000033d1e0 ffff88000ece4000 ffff88000ece4000

[    0.680040]  ffff88000c4e9dd0
[    0.680040]  ffff88000c4e9dd0 ffffffff8d8eecf8 ffffffff8d8eecf8 ffff8800=
0c4e9e20 ffff88000c4e9e20 ffffffff8d8eefb9 ffffffff8d8eefb9

[    0.680040] Call Trace:
[    0.680040] Call Trace:
[    0.680040]  [<ffffffff8d8eeb60>] free_hot_cold_page+0x60/0x170
[    0.680040]  [<ffffffff8d8eeb60>] free_hot_cold_page+0x60/0x170
[    0.680040]  [<ffffffff8d8eecf8>] __free_pages+0x28/0x40
[    0.680040]  [<ffffffff8d8eecf8>] __free_pages+0x28/0x40
[    0.680040]  [<ffffffff8d8eefb9>] free_reserved_area+0xb9/0x120
[    0.680040]  [<ffffffff8d8eefb9>] free_reserved_area+0xb9/0x120
[    0.680040]  [<ffffffff8d834a68>] free_init_pages+0x88/0xa0
[    0.680040]  [<ffffffff8d834a68>] free_init_pages+0x88/0xa0
[    0.680040]  [<ffffffff8e34b20f>] free_initrd_mem+0x30/0x35
[    0.680040]  [<ffffffff8e34b20f>] free_initrd_mem+0x30/0x35
[    0.680040]  [<ffffffff8e33e35f>] populate_rootfs+0xea/0x10a
[    0.680040]  [<ffffffff8e33e35f>] populate_rootfs+0xea/0x10a
[    0.680040]  [<ffffffff8e33e275>] ? do_header+0x147/0x147
[    0.680040]  [<ffffffff8e33e275>] ? do_header+0x147/0x147
[    0.680040]  [<ffffffff8d800262>] do_one_initcall+0x92/0x160
[    0.680040]  [<ffffffff8d800262>] do_one_initcall+0x92/0x160
[    0.680040]  [<ffffffff8d87520d>] ? parse_args+0x1dd/0x300
[    0.680040]  [<ffffffff8d87520d>] ? parse_args+0x1dd/0x300
[    0.680040]  [<ffffffff8e33cfc0>] kernel_init_freeable+0x149/0x1d5
[    0.680040]  [<ffffffff8e33cfc0>] kernel_init_freeable+0x149/0x1d5
[    0.680040]  [<ffffffff8e33c836>] ? do_early_param+0x8a/0x8a
[    0.680040]  [<ffffffff8e33c836>] ? do_early_param+0x8a/0x8a
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040]  [<ffffffff8de07c29>] kernel_init+0x9/0x180
[    0.680040]  [<ffffffff8de07c29>] kernel_init+0x9/0x180
[    0.680040]  [<ffffffff8de2420c>] ret_from_fork+0x7c/0xb0
[    0.680040]  [<ffffffff8de2420c>] ret_from_fork+0x7c/0xb0
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040] Code:=20
[    0.680040] Code: 48 48 89 89 f8 f8 48 48 89 89 f9 f9 48 48 c1 c1 e8 e8 =
17 17 48 48 c1 c1 e9 e9 0f 0f 48 48 8b 8b 04 04 c5 c5 40 40 44 44 ce ce 8e =
8e 48 48 85 85 c0 c0 74 74 0a 0a 0f 0f b6 b6 c9 c9 48 48 c1 c1 e1 e1 04 04 =
48 48 01 01 c8 c8 81 81 e7 e7 ff ff 7f 7f 00 00 00 00 <4c> <4c> 8b 8b 50 50=
 08 08 48 48 c1 c1 ef ef 09 09 39 39 d6 d6 4c 4c 8d 8d 0c 0c 7f 7f 7f 7f 30=
 30 b9 b9 01 01 00 00 00 00 00 00=20

[    0.680040] RIP=20
[    0.680040] RIP  [<ffffffff8d8ecf8e>] get_pageblock_flags_group+0x4e/0xa0
 [<ffffffff8d8ecf8e>] get_pageblock_flags_group+0x4e/0xa0
[    0.680040]  RSP <ffff88000c4e9d80>
[    0.680040]  RSP <ffff88000c4e9d80>
[    0.680040] general protection fault: 0000 [#2]=20
[    0.680040] general protection fault: 0000 [#2] SMP SMP=20

[    0.680040] Modules linked in:
[    0.680040] Modules linked in: [last unloaded:=20

[    0.680040] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00014-g=
da2b6fb #1
[    0.680040] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00014-g=
da2b6fb #1
[    0.680040] task: ffff88000c4e6040 ti: ffff88000c4e8000 task.ti: ffff880=
00c4e8000
[    0.680040] task: ffff88000c4e6040 ti: ffff88000c4e8000 task.ti: ffff880=
00c4e8000
[    0.680040] RIP: 0010:[<ffffffff8da90bcd>]=20
[    0.680040] RIP: 0010:[<ffffffff8da90bcd>]  [<ffffffff8da90bcd>] memcpy+=
0x9d/0x110
 [<ffffffff8da90bcd>] memcpy+0x9d/0x110
[    0.680040] RSP: 0000:ffff88000c4e9ab0  EFLAGS: 00010006
[    0.680040] RSP: 0000:ffff88000c4e9ab0  EFLAGS: 00010006
[    0.680040] RAX: cccccccc5b9a998c RBX: cccccccccccccce1 RCX: 33333333333=
34334
[    0.680040] RAX: cccccccc5b9a998c RBX: cccccccccccccce1 RCX: 33333333333=
34334
[    0.680040] RDX: 0000000000000015 RSI: ffff88000c4e9ad0 RDI: cccccccc5b9=
a998c
[    0.680040] RDX: 0000000000000015 RSI: ffff88000c4e9ad0 RDI: cccccccc5b9=
a998c
[    0.680040] RBP: ffff88000c4e9b68 R08: 4d49544853415243 R09: 33383938333=
13d45
[    0.680040] RBP: ffff88000c4e9b68 R08: 4d49544853415243 R09: 33383938333=
13d45
[    0.680040] R10: 3833313d454d4954 R11: 0a31383633333839 R12: 00000000000=
00015
[    0.680040] R10: 3833313d454d4954 R11: 0a31383633333839 R12: 00000000000=
00015
[    0.680040] R13: 0000000000000246 R14: 0000000000000000 R15: ffff88000ec=
e4000
[    0.680040] R13: 0000000000000246 R14: 0000000000000000 R15: ffff88000ec=
e4000
[    0.680040] FS:  0000000000000000(0000) GS:ffff88000d400000(0000) knlGS:=
0000000000000000
[    0.680040] FS:  0000000000000000(0000) GS:ffff88000d400000(0000) knlGS:=
0000000000000000
[    0.680040] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.680040] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.680040] CR2: 00000000ffffffff CR3: 000000000e0c5000 CR4: 00000000000=
006e0
[    0.680040] CR2: 00000000ffffffff CR3: 000000000e0c5000 CR4: 00000000000=
006e0
[    0.680040] Stack:
[    0.680040] Stack:
[    0.680040]  ffffffff8d8bf884
[    0.680040]  ffffffff8d8bf884 0000000000000010 0000000000000010 ffff8800=
0c4e9b78 ffff88000c4e9b78 ffff88000c4e9b28 ffff88000c4e9b28

[    0.680040]  4d49544853415243
[    0.680040]  4d49544853415243 3338393833313d45 3338393833313d45 ffff000a=
31383633 ffff000a31383633 0000000000000046 0000000000000046

[    0.680040]  0000000000000000
[    0.680040]  0000000000000000 ffffffff8d8bf8fd ffffffff8d8bf8fd 00000000=
00000000 0000000000000000 0000000200000027 0000000200000027

[    0.680040] Call Trace:
[    0.680040] Call Trace:
[    0.680040]  [<ffffffff8d8bf884>] ? vmcoreinfo_append_str+0xa4/0xd0
[    0.680040]  [<ffffffff8d8bf884>] ? vmcoreinfo_append_str+0xa4/0xd0
[    0.680040]  [<ffffffff8d8bf8fd>] ? crash_kexec+0x1d/0x110
[    0.680040]  [<ffffffff8d8bf8fd>] ? crash_kexec+0x1d/0x110
[    0.680040]  [<ffffffff8d8bf8ca>] crash_save_vmcoreinfo+0x1a/0x30
[    0.680040]  [<ffffffff8d8bf8ca>] crash_save_vmcoreinfo+0x1a/0x30
[    0.680040]  [<ffffffff8d8bf9ac>] crash_kexec+0xcc/0x110
[    0.680040]  [<ffffffff8d8bf9ac>] crash_kexec+0xcc/0x110
[    0.680040]  [<ffffffff8d8ecf8e>] ? get_pageblock_flags_group+0x4e/0xa0
[    0.680040]  [<ffffffff8d8ecf8e>] ? get_pageblock_flags_group+0x4e/0xa0
[    0.680040]  [<ffffffff8de1e550>] oops_end+0x30/0xe0
[    0.680040]  [<ffffffff8de1e550>] oops_end+0x30/0xe0
[    0.680040]  [<ffffffff8d806075>] die+0x55/0x60
[    0.680040]  [<ffffffff8d806075>] die+0x55/0x60
[    0.680040]  [<ffffffff8de1df3f>] do_general_protection+0xaf/0x1b0
[    0.680040]  [<ffffffff8de1df3f>] do_general_protection+0xaf/0x1b0
[    0.680040]  [<ffffffff8de1d888>] general_protection+0x28/0x30
[    0.680040]  [<ffffffff8de1d888>] general_protection+0x28/0x30
[    0.680040]  [<ffffffff8d8ecf8e>] ? get_pageblock_flags_group+0x4e/0xa0
[    0.680040]  [<ffffffff8d8ecf8e>] ? get_pageblock_flags_group+0x4e/0xa0
[    0.680040]  [<ffffffff8d8eeb60>] free_hot_cold_page+0x60/0x170
[    0.680040]  [<ffffffff8d8eeb60>] free_hot_cold_page+0x60/0x170
[    0.680040]  [<ffffffff8d8eecf8>] __free_pages+0x28/0x40
[    0.680040]  [<ffffffff8d8eecf8>] __free_pages+0x28/0x40
[    0.680040]  [<ffffffff8d8eefb9>] free_reserved_area+0xb9/0x120
[    0.680040]  [<ffffffff8d8eefb9>] free_reserved_area+0xb9/0x120
[    0.680040]  [<ffffffff8d834a68>] free_init_pages+0x88/0xa0
[    0.680040]  [<ffffffff8d834a68>] free_init_pages+0x88/0xa0
[    0.680040]  [<ffffffff8e34b20f>] free_initrd_mem+0x30/0x35
[    0.680040]  [<ffffffff8e34b20f>] free_initrd_mem+0x30/0x35
[    0.680040]  [<ffffffff8e33e35f>] populate_rootfs+0xea/0x10a
[    0.680040]  [<ffffffff8e33e35f>] populate_rootfs+0xea/0x10a
[    0.680040]  [<ffffffff8e33e275>] ? do_header+0x147/0x147
[    0.680040]  [<ffffffff8e33e275>] ? do_header+0x147/0x147
[    0.680040]  [<ffffffff8d800262>] do_one_initcall+0x92/0x160
[    0.680040]  [<ffffffff8d800262>] do_one_initcall+0x92/0x160
[    0.680040]  [<ffffffff8d87520d>] ? parse_args+0x1dd/0x300
[    0.680040]  [<ffffffff8d87520d>] ? parse_args+0x1dd/0x300
[    0.680040]  [<ffffffff8e33cfc0>] kernel_init_freeable+0x149/0x1d5
[    0.680040]  [<ffffffff8e33cfc0>] kernel_init_freeable+0x149/0x1d5
[    0.680040]  [<ffffffff8e33c836>] ? do_early_param+0x8a/0x8a
[    0.680040]  [<ffffffff8e33c836>] ? do_early_param+0x8a/0x8a
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040]  [<ffffffff8de07c29>] kernel_init+0x9/0x180
[    0.680040]  [<ffffffff8de07c29>] kernel_init+0x9/0x180
[    0.680040]  [<ffffffff8de2420c>] ret_from_fork+0x7c/0xb0
[    0.680040]  [<ffffffff8de2420c>] ret_from_fork+0x7c/0xb0
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040]  [<ffffffff8de07c20>] ? rest_init+0xe0/0xe0
[    0.680040] Code:=20
[    0.680040] Code: 57 57 e8 e8 4c 4c 89 89 5f 5f e0 e0 48 48 8d 8d 7f 7f =
e0 e0 73 73 d2 d2 83 83 c2 c2 20 20 48 48 29 29 d6 d6 48 48 29 29 d7 d7 83 =
83 fa fa 10 10 72 72 24 24 4c 4c 8b 8b 06 06 4c 4c 8b 8b 4e 4e 08 08 4c 4c =
8b 8b 54 54 16 16 f0 f0 4c 4c 8b 8b 5c 5c 16 16 f8 f8 <4c> <4c> 89 89 07 07=
 4c 4c 89 89 4f 4f 08 08 4c 4c 89 89 54 54 17 17 f0 f0 4c 4c 89 89 5c 5c 17=
 17 f8 f8 c3 c3 90 90 83 83 fa fa=20

[    0.680040] RIP=20
[    0.680040] RIP  [<ffffffff8da90bcd>] memcpy+0x9d/0x110
 [<ffffffff8da90bcd>] memcpy+0x9d/0x110
[    0.680040]  RSP <ffff88000c4e9ab0>
[    0.680040]  RSP <ffff88000c4e9ab0>
[    0.680040] ---[ end trace 4eb217bf3ed60586 ]---
[    0.680040] ---[ end trace 4eb217bf3ed60586 ]---
[    0.680040] Kernel panic - not syncing: Fatal exception
[    0.680040] Kernel panic - not syncing: Fatal exception
[    0.680040] Rebooting in 10 seconds..
[    0.680040] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-01101738/da2b6fb990cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00=
014-gda2b6fb -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/tip:x86:kaslr/.vmlinuz-=
da2b6fb990cf782b18952f534ec7323453bc4fc9-20140116085414-100-cairo branch=3D=
tip/x86/kaslr BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/da2b6fb990=
cf782b18952f534ec7323453bc4fc9/vmlinuz-3.12.0-rc4-00014-gda2b6fb'  -initrd =
/kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::9927-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-quantal-cairo-16,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk1-quantal-cairo-16,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk2-quantal-cairo-16,media=3Ddisk,if=3Dvirtio -drive f=
ile=3D/fs/LABEL=3DKVM/disk3-quantal-cairo-16,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/LABEL=3DKVM/disk4-quantal-cairo-16,media=3Ddisk,if=3Dvirtio -d=
rive file=3D/fs/LABEL=3DKVM/disk5-quantal-cairo-16,media=3Ddisk,if=3Dvirtio=
 -pidfile /dev/shm/kboot/pid-quantal-cairo-16 -serial file:/dev/shm/kboot/s=
erial-quantal-cairo-16 -daemonize -display none -monitor null=20

--KsGdsel6WgEHnImy--
