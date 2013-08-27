Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3H0BXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:23:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:14183 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3H0BXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:23:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,964,1367996400"; 
   d="log'?scan'208";a="386853763"
Date: Tue, 27 Aug 2013 09:23:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: [cpuid4_cache_sysfs_exit] BUG kmalloc-512 (Not tainted): Poison
 overwritten
Message-ID: <20130827012338.GA9805@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Russell,

You commit is so good at catching errors!

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers
    

Here is another one, full dmesg attached.

modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070-g245f086/modules.dep: No such file or directory
[    4.993719] =============================================================================
[    4.994014] BUG kmalloc-512 (Not tainted): Poison overwritten
[    4.994014] -----------------------------------------------------------------------------
[    4.994014]
[    4.994014] Disabling lock debugging due to kernel taint
[    4.994014] INFO: 0x78094c00-0x78094c03. First byte 0x68 instead of 0x6b
[    4.994014] INFO: Allocated in kzalloc.constprop.12+0xd/0xf age=888 cpu=0 pid=1
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014] INFO: Freed in cpuid4_cache_sysfs_exit+0x30/0x8c age=223 cpu=1 pid=1
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014]
[    4.994014] INFO: Slab 0x866a0720 objects=23 used=23 fp=0x  (null) flags=0x4080
[    4.994014] INFO: Object 0x78094ac0 @offset=2752 fp=0x  (null)


git bisect start 5e8d1acd05687720cbb0b08975eacb7588fdfc42 v3.10 --
git bisect good 8cbd0eefcaf8cc32ded2bf229f0fc379b2ad69f2  # 13:42     55+  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
git bisect good 60a2b977533c312d271563d955ef7b8e35a6aa38  # 14:47     55+  Merge remote-tracking branch 'infiniband/for-next'
git bisect  bad 4a225b466e040a70e7d12b159d2a36da1c2ef7dc  # 14:57      0-  next-20130821/driver-core
git bisect good 98246c1ae6f18fe1b710cdff687b6b7077f739c9  # 15:27     55+  Merge remote-tracking branch 'virtio/virtio-next'
git bisect good 38136c1f1471c7dcbe889beb790cc4d331e9d3ad  # 18:45     55+  Merge remote-tracking branch 'spi/for-next'
git bisect good f07762be3b9222a7649cb29a3f5b959204d40446  # 19:17     55+  Merge branch 'x86/asmlinkage'
git bisect good 93d6294dfcdff81194086ed9bd6ceca3bc5e5863  # 22:17     55+  Merge remote-tracking branch 'kvm-ppc/kvm-ppc-next'
git bisect good c57e8c89b271af4ef914c439effffed53c39434c  # 01:28     55+  Merge remote-tracking branch 'leds/for-next'
git bisect  bad 76f411fb3a62711de7f59e0f4c56456fe356675a  # 01:40      0-  x86 / cpu topology: remove the stale macro arch_provides_topology_pointers
git bisect  bad ea1bb7064fd6972ef00a93ba882a2f38450b273e  # 01:47      0-  video: backlight: convert class code to use dev_groups
git bisect good e56341ad380114454119ac043e6d710ddbbb7710  # 09:41     55+  staging: comedi: convert class code to use dev_groups
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 10:20      0-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 13:57     55+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 17:36    165+  char: tile-srom: fix build error
git bisect  bad 245f08699d5320f021070ed8698ac89ebf2f0670  # 17:36      0-  Add linux-next specific files for 20130822
git bisect good 754ad8d4fe504c68d209749f5c49b578d68a0106  # 18:42    165+  Revert "kobject: delayed kobject release: help find buggy drivers"
git bisect good d8dfad3876e4386666b759da3c833d62fb8b2267  # 03:59    165+  Linux 3.11-rc7
git bisect  bad 245f08699d5320f021070ed8698ac89ebf2f0670  # 03:59      0-  Add linux-next specific files for 20130822

Thanks,
Fengguang

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-3174-20130825060922-3.11.0-rc6-next-20130822-07070-g245f086-1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc6-next-20130822-07070-g245f086 (kbuil=
d@jaketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Aug 25 05:51:1=
8 CST 2013
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01bd1000, 0x01bd1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x01bd2000, 0x01bd2fff] PGTABLE
[    0.000000] BRK [0x01bd3000, 0x01bd3fff] PGTABLE
[    0.000000] BRK [0x01bd4000, 0x01bd4fff] PGTABLE
[    0.000000] BRK [0x01bd5000, 0x01bd5fff] PGTABLE
[    0.000000] BRK [0x01bd6000, 0x01bd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128680(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @8647f000 s26432 r0 d22720 u49=
152
[    0.000000] pcpu-alloc: s26432 r0 d22720 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e481600
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j7-08250355/next:master/.vml=
inuz-245f08699d5320f021070ed8698ac89ebf2f0670-20130825055215-9-bens branch=
=3Dnext/master  BOOT_IMAGE=3D/kernel/i386-randconfig-j7-08250355/245f08699d=
5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-next-20130822-07070-g245f=
086
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 212832K/261744K available (4455K kernel code, 417K r=
wdata, 2440K rodata, 372K init, 4356K bss, 48912K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa93000 - 0xfffff000   (5552 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff3fe000   (1900 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79726000 - 0x79783000   ( 372 kB)
[    0.000000]       .data : 0x79459fd5 - 0x79725720   (2861 kB)
[    0.000000]       .text : 0x79000000 - 0x79459fd5   (4455 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D7808c000 soft=3D7808e000
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.420 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5332.84 Bogo=
MIPS (lpj=3D2666420)
[    0.003449] pid_max: default: 32768 minimum: 301
[    0.005166] Mount-cache hash table entries: 512
[    0.008138] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008138] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008138] tlb_flushall_shift: 6
[    0.010207] debug: unmapping init [mem 0x79783000-0x79785fff]
[    0.012830] ACPI: Core revision 20130725
[    0.050892] ACPI: All ACPI Tables successfully acquired
[    0.052649] Getting VERSION: 50014
[    0.053016] Getting VERSION: 50014
[    0.053569] Getting ID: 0
[    0.054021] Getting ID: f000000
[    0.054542] Getting LVT0: 8700
[    0.055011] Getting LVT1: 8400
[    0.055497] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.057032] enabled ExtINT on CPU#0
[    0.059258] ENABLING IO-APIC IRQs
[    0.059798] init IO_APIC IRQs
[    0.060007]  apic 0 pin 0 not connected
[    0.061026] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.062055] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.063046] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.065043] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.066051] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.067043] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.068043] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.069043] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.070043] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.071043] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.072043] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.073043] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.074043] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.075043] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.076043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.077024]  apic 0 pin 16 not connected
[    0.078003]  apic 0 pin 17 not connected
[    0.078619]  apic 0 pin 18 not connected
[    0.079004]  apic 0 pin 19 not connected
[    0.080003]  apic 0 pin 20 not connected
[    0.080616]  apic 0 pin 21 not connected
[    0.081003]  apic 0 pin 22 not connected
[    0.081614]  apic 0 pin 23 not connected
[    0.082169] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.083003] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.085626] Using local APIC timer interrupts.
[    0.085626] calibrating APIC timer ...
[    0.087000] ... lapic delta =3D 6250069
[    0.087000] ... PM-Timer delta =3D 357958
[    0.087000] ... PM-Timer result ok
[    0.087000] ..... delta 6250069
[    0.087000] ..... mult: 268438419
[    0.087000] ..... calibration result: 1000011
[    0.087000] ..... CPU clock speed is 2666.0692 MHz.
[    0.087000] ..... host bus clock speed is 1000.0011 MHz.
[    0.087118] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.091202] SMP alternatives: lockdep: fixing up alternatives
[    0.092096] CPU 1 irqstacks, hard=3D7812e000 soft=3D78140000
[    0.093004] smpboot: Booting Node   0, Processors  #1 OK
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:fffb021, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.109129] Brought up 2 CPUs
[    0.109082] KVM setup async PF for cpu 1
[    0.109082] kvm-stealtime: cpu 1, msr e48d600
[    0.110004] smpboot: Total of 2 processors activated (10665.68 BogoMIPS)
[    0.113714] devtmpfs: initialized
[    0.120163] xor: measuring software checksum speed
[    0.130003]    pIII_sse  :  7832.000 MB/sec
[    0.140003]    prefetch64-sse:  9132.000 MB/sec
[    0.140702] xor: using function: prefetch64-sse (9132.000 MB/sec)
[    0.142458] NET: Registered protocol family 16
[    0.145160] cpuidle: using governor menu
[    0.146402] ACPI: bus type PCI registered
[    0.147923] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.148003] PCI: Using configuration type 1 for base access
[    0.167291] bio: create slab <bio-0> at 0
[    0.186013] raid6: mmxx1     3441 MB/s
[    0.203019] raid6: mmxx2     3746 MB/s
[    0.220007] raid6: sse1x1    1675 MB/s
[    0.237008] raid6: sse1x2    3703 MB/s
[    0.254017] raid6: sse2x1    2753 MB/s
[    0.271010] raid6: sse2x2    6953 MB/s
[    0.271594] raid6: using algorithm sse2x2 (6953 MB/s)
[    0.272003] raid6: using intx1 recovery algorithm
[    0.273614] ACPI: Added _OSI(Module Device)
[    0.274004] ACPI: Added _OSI(Processor Device)
[    0.275003] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.275721] ACPI: Added _OSI(Processor Aggregator Device)
[    0.278913] ACPI: EC: Look up EC in DSDT
[    0.356345] ACPI: Interpreter enabled
[    0.356957] ACPI: (supports S0 S5)
[    0.357003] ACPI: Using IOAPIC for interrupt routing
[    0.358203] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.497066] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.504436] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.506476] PCI host bridge to bus 0000:00
[    0.507015] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.508100] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.509014] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.510013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.511013] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.512088] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.516656] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.519363] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.523637] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.528715] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.530183] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.531017] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.535442] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.538807] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.541073] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.551034] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.553472] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.555617] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.557668] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.564607] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.568647] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.570619] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.573004] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.580004] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.583871] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.586004] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.588005] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.598097] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.600004] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.602005] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.612229] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.614004] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.616004] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.626368] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.628611] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.630614] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.640664] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.642615] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.644614] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.655048] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.657004] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.659005] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.669173] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.670660] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.678535] pci_bus 0000:00: on NUMA node 0
[    0.679019] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.688859] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.692292] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.695674] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.699148] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.701032] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.709000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.710027] ACPI: \_SB_.PCI0: notify handler is installed
[    0.710923] Found 1 acpi root devices
[    0.712390] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.713016] vgaarb: loaded
[    0.714003] vgaarb: bridge control possible 0000:00:02.0
[    0.721276] SCSI subsystem initialized
[    0.722714] pps_core: LinuxPPS API ver. 1 registered
[    0.723004] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.725076] PTP clock support registered
[    0.725352] PCI: Using ACPI for IRQ routing
[    0.726006] PCI: pci_cache_line_size set to 64 bytes
[    0.727334] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.728025] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.732017] NET: Registered protocol family 23
[    0.733392] Switched to clocksource kvm-clock
[    0.734305] pnp: PnP ACPI init
[    0.734880] ACPI: bus type PNP registered
[    0.735983] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.737669] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.739050] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.740802] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.742147] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.743846] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.745584] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.746876] pnp 00:03: [dma 2]
[    0.747716] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.749446] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.751054] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.752762] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.754460] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.759231] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.763132] pnp: PnP ACPI: found 7 devices
[    0.763769] ACPI: bus type PNP unregistered
[    0.803149] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.803999] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.804873] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.805844] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.806919] NET: Registered protocol family 1
[    0.807662] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.808594] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.809503] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.810496] pci 0000:00:02.0: Boot video device
[    0.811320] PCI: CLS 0 bytes, default 64
[    0.812612] Unpacking initramfs...
[    4.102787] debug: unmapping init [mem 0x8673f000-0x87feffff]
[    4.110492] PCLMULQDQ-NI instructions are not detected.
[    4.114533] Initialise module verification
[    4.115433] audit: initializing netlink socket (disabled)
[    4.116378] type=3D2000 audit(1377382149.096:1): initialized
[    4.126640] bounce pool size: 64 pages
[    4.127254] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    4.195616] VFS: Disk quotas dquot_6.5.2
[    4.197599] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.222627] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    4.225396] QNX6 filesystem 1.0.0 registered.
[    4.226092] fuse init (API version 7.22)
[    4.230066] BeFS version: 0.9.3
[    4.240374] bio: create slab <bio-1> at 1
[    4.247214] Btrfs loaded, integrity-checker=3Don
[    4.247940] btrfs: selftest: Running btrfs free space cache tests
[    4.248912] btrfs: selftest: Running extent only tests
[    4.249900] btrfs: selftest: Running bitmap only tests
[    4.250788] btrfs: selftest: Running bitmap and extent tests
[    4.251865] btrfs: selftest: Free space cache tests finished
[    4.262211] NET: Registered protocol family 38
[    4.262936] Key type asymmetric registered
[    4.263621] Asymmetric key parser 'x509' registered
[    4.265130] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    4.266288] io scheduler noop registered (default)
[    4.268668] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.269545] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    4.271882] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.273069] ACPI: Power Button [PWRF]
[    4.288418] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.289351] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    4.291404] virtio-pci 0000:00:03.0: setting latency timer to 64
[    4.305217] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.306135] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    4.308289] virtio-pci 0000:00:05.0: setting latency timer to 64
[    4.322799] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.324666] virtio-pci 0000:00:06.0: setting latency timer to 64
[    4.337528] virtio-pci 0000:00:07.0: setting latency timer to 64
[    4.352347] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.354604] virtio-pci 0000:00:08.0: setting latency timer to 64
[    4.368265] virtio-pci 0000:00:09.0: setting latency timer to 64
[    4.382300] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    4.385997] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.386945] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.410620] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.416062] STMicroelectronics ASC driver initialized
[    4.418209] Initializing Nozomi driver 2.1d
[    4.420841] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    4.421990] platform pc8736x_gpio.0: no device found
[    4.423146] nsc_gpio initializing
[    4.423666] Linux agpgart interface v0.103
[    4.424921] dummy-irq: no IRQ given.  Use irq=3DN
[    4.428414] Uniform Multi-Platform E-IDE driver
[    4.430891] ide-cd driver 5.00
[    4.437962] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.439555] slcan: serial line CAN interface driver
[    4.440352] slcan: 10 dynamic interface channels.
[    4.441742] Fusion MPT base driver 3.04.20
[    4.442399] Copyright (c) 1999-2008 LSI Corporation
[    4.443284] Fusion MPT SPI Host driver 3.04.20
[    4.444177] Fusion MPT misc device (ioctl) driver 3.04.20
[    4.445361] mptctl: Registered with Fusion MPT base driver
[    4.446225] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    4.447588] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.450456] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.451268] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.530941] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.532455] mk712: device not present
[    4.535119] power_supply test_ac: uevent
[    4.535729] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.536678] power_supply test_ac: prop ONLINE=3D1
[    4.537493] power_supply test_ac: power_supply_changed
[    4.538320] power_supply test_ac: power_supply_changed_work
[    4.539232] power_supply test_ac: uevent
[    4.539662] power_supply test_battery: uevent
[    4.539663] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.539726] power_supply test_battery: prop STATUS=3DDischarging
[    4.539741] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.539756] power_supply test_battery: prop HEALTH=3DGood
[    4.539770] power_supply test_battery: prop PRESENT=3D1
[    4.539785] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.539800] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.539816] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.539830] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.539845] power_supply test_battery: prop CAPACITY=3D50
[    4.539860] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.539884] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.539900] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.539915] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.539930] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.539945] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc6-n=
ext-20130822-07070-g245f086
[    4.539960] power_supply test_battery: prop TEMP=3D26
[    4.539974] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.540690] power_supply test_battery: power_supply_changed
[    4.540697] power_supply test_battery: power_supply_changed_work
[    4.540714] power_supply test_battery: uevent
[    4.540715] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.540777] power_supply test_battery: prop STATUS=3DDischarging
[    4.540792] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.540807] power_supply test_battery: prop HEALTH=3DGood
[    4.540821] power_supply test_battery: prop PRESENT=3D1
[    4.540835] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.540850] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.540873] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.540888] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.540902] power_supply test_battery: prop CAPACITY=3D50
[    4.540916] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.540931] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.540946] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.540960] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.540974] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.540989] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc6-n=
ext-20130822-07070-g245f086
[    4.541003] power_supply test_battery: prop TEMP=3D26
[    4.541035] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.541308] power_supply test_usb: uevent
[    4.541310] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.541371] power_supply test_usb: prop ONLINE=3D1
[    4.541441] power_supply test_usb: power_supply_changed
[    4.541451] power_supply test_usb: power_supply_changed_work
[    4.541468] power_supply test_usb: uevent
[    4.541470] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.541532] power_supply test_usb: prop ONLINE=3D1
[    4.546681] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D0)
[    4.546683] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    4.546697] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    4.546708] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    4.546989] it87_wdt: no device
[    4.546991] sc1200wdt: build 20020303
[    4.547169] sc1200wdt: io parameter must be specified
[    4.547195] pc87413_wdt: Version 1.1 at io 0x2E
[    4.547203] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    4.547216] sbc60xxwdt: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    4.547233] sbc8360: failed to register misc device
[    4.547399] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    4.547456] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    4.547520] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    4.547536] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    4.547555] machzwd: no ZF-Logic found
[    4.547773] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    4.547774] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    4.548277] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    4.548278] lguest: switcher text too large (4384)
[    4.601713] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.602665] power_supply test_ac: prop ONLINE=3D1
[    4.605196] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    4.606638] Loading crystalhd 0.9.27
[    4.608249] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[    4.609314] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[    4.611470] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[    4.612663] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[    4.614271]  fake-fmc-carrier: mezzanine 0
[    4.614919]       Manufacturer: fake-vendor
[    4.615580]       Product name: fake-design-for-testing
[    4.616657] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    4.617808] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    4.619479] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    4.620982] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    4.623672] NET: Registered protocol family 17
[    4.624418] NET: Registered protocol family 5
[    4.625309] NET: Registered protocol family 9
[    4.625989] X.25 for Linux Version 0.2
[    4.626678] can: controller area network core (rev 20120528 abi 9)
[    4.628573] NET: Registered protocol family 29
[    4.629284] can: broadcast manager protocol (rev 20120528 t)
[    4.630197] can: netlink gateway (rev 20130117) max_hops=3D1
[    4.631798] IrCOMM protocol (Dag Brattli)
[    4.643033] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    4.646187] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[    4.647958] NET: Registered protocol family 12
[    4.648820] NET: Registered protocol family 35
[    4.651066] 8021q: 802.1Q VLAN Support v1.8
[    4.651822] NET: Registered protocol family 37
[    4.652526] openvswitch: Open vSwitch switching datapath
[    4.654729]=20
[    4.654729] printing PIC contents
[    4.655499] ... PIC  IMR: ffff
[    4.655985] ... PIC  IRR: 1013
[    4.656490] ... PIC  ISR: 0000
[    4.656978] ... PIC ELCR: 0c00
[    4.657542] printing local APIC contents on CPU#0/0:
[    4.658316] ... APIC ID:      00000000 (0)
[    4.658529] ... APIC VERSION: 00050014
[    4.658529] ... APIC TASKPRI: 00000000 (00)
[    4.658529] ... APIC PROCPRI: 00000000
[    4.658529] ... APIC LDR: 01000000
[    4.658529] ... APIC DFR: ffffffff
[    4.658529] ... APIC SPIV: 000001ff
[    4.658529] ... APIC ISR field:
[    4.658529] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.658529] ... APIC TMR field:
[    4.658529] 000000000200000000000000000000000000000000000000000000000000=
0000
[    4.658529] ... APIC IRR field:
[    4.658529] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.658529] ... APIC ESR: 00000000
[    4.658529] ... APIC ICR: 000008fd
[    4.658529] ... APIC ICR2: 02000000
[    4.658529] ... APIC LVTT: 000000ef
[    4.658529] ... APIC LVTPC: 00010000
[    4.658529] ... APIC LVT0: 00010700
[    4.658529] ... APIC LVT1: 00000400
[    4.658529] ... APIC LVTERR: 000000fe
[    4.658529] ... APIC TMICT: 01dcc6fd
[    4.658529] ... APIC TMCCT: 019f2313
[    4.658529] ... APIC TDCR: 00000003
[    4.658529]=20
[    4.674052] number of MP IRQ sources: 15.
[    4.674663] number of IO-APIC #0 registers: 24.
[    4.675373] testing the IO APIC.......................
[    4.676196] IO APIC #0......
[    4.676645] .... register #00: 00000000
[    4.677290] .......    : physical APIC id: 00
[    4.677959] .......    : Delivery Type: 0
[    4.678589] .......    : LTS          : 0
[    4.679227] .... register #01: 00170011
[    4.679815] .......     : max redirection entries: 17
[    4.680604] .......     : PRQ implemented: 0
[    4.681280] .......     : IO APIC version: 11
[    4.681950] .... register #02: 00000000
[    4.682556] .......     : arbitration: 00
[    4.683191] .... IRQ redirection table:
[    4.683795] 1    0    0   0   0    0    0    00
[    4.684525] 0    0    0   0   0    1    1    31
[    4.685255] 0    0    0   0   0    1    1    30
[    4.685968] 0    0    0   0   0    1    1    33
[    4.686693] 1    0    0   0   0    1    1    34
[    4.687458] 1    1    0   0   0    1    1    35
[    4.688189] 0    0    0   0   0    1    1    36
[    4.688901] 0    0    0   0   0    1    1    37
[    4.689629] 0    0    0   0   0    1    1    38
[    4.690362] 0    1    0   0   0    1    1    39
[    4.691094] 1    1    0   0   0    1    1    3A
[    4.691802] 1    1    0   0   0    1    1    3B
[    4.692536] 0    0    0   0   0    1    1    3C
[    4.693265] 0    0    0   0   0    1    1    3D
[    4.693980] 0    0    0   0   0    1    1    3E
[    4.694706] 0    0    0   0   0    1    1    3F
[    4.695437] 1    0    0   0   0    0    0    00
[    4.696166] 1    0    0   0   0    0    0    00
[    4.696872] 1    0    0   0   0    0    0    00
[    4.697640] 1    0    0   0   0    0    0    00
[    4.698371] 1    0    0   0   0    0    0    00
[    4.699102] 1    0    0   0   0    0    0    00
[    4.699810] 1    0    0   0   0    0    0    00
[    4.700543] 1    0    0   0   0    0    0    00
[    4.701259] IRQ to pin mappings:
[    4.701765] IRQ0 -> 0:2
[    4.702214] IRQ1 -> 0:1
[    4.702639] IRQ3 -> 0:3
[    4.703087] IRQ4 -> 0:4
[    4.703510] IRQ5 -> 0:5
[    4.703941] IRQ6 -> 0:6
[    4.704386] IRQ7 -> 0:7
[    4.704811] IRQ8 -> 0:8
[    4.705260] IRQ9 -> 0:9
[    4.705683] IRQ10 -> 0:10
[    4.706159] IRQ11 -> 0:11
[    4.706609] IRQ12 -> 0:12
[    4.707083] IRQ13 -> 0:13
[    4.707568] IRQ14 -> 0:14
[    4.708044] IRQ15 -> 0:15
[    4.708497] .................................... done.
[    4.709300] Using IPI No-Shortcut mode
[    4.711096] Loading module verification certificates
[    4.715615] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: a0b5d9=
0f4c7204e87116d7a926e7b707e95999d2'
[    4.717202] registered taskstats version 1
modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070=
-g245f086/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070=
-g245f086/modules.dep: No such file or directory

[    4.741493] Key type encrypted registered
modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070=
-g245f086/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070=
-g245f086/modules.dep: No such file or directory

[    4.766350] Unregister pv shared memory for cpu 0
[    4.771814] CPU 0 is now offline
[    4.773614] debug: unmapping init [mem 0x79726000-0x79782fff]
modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070=
-g245f086/modules.dep: No such file or directory
[    4.993719] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[    4.994014] BUG kmalloc-512 (Not tainted): Poison overwritten
[    4.994014] ------------------------------------------------------------=
-----------------
[    4.994014]=20
[    4.994014] Disabling lock debugging due to kernel taint
[    4.994014] INFO: 0x78094c00-0x78094c03. First byte 0x68 instead of 0x6b
[    4.994014] INFO: Allocated in kzalloc.constprop.12+0xd/0xf age=3D888 cp=
u=3D0 pid=3D1
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014] INFO: Freed in cpuid4_cache_sysfs_exit+0x30/0x8c age=3D223 c=
pu=3D1 pid=3D1
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014]=20
[    4.994014] INFO: Slab 0x866a0720 objects=3D23 used=3D23 fp=3D0x  (null)=
 flags=3D0x4080
[    4.994014] INFO: Object 0x78094ac0 @offset=3D2752 fp=3D0x  (null)
[    4.994014]=20
[    4.994014] Bytes b4 78094ab0: 00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a=
 5a 5a  ........ZZZZZZZZ
[    4.994014] Object 78094ac0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094ad0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094ae0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094af0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094b90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094ba0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094bb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094bc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094bd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094be0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094bf0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c00: 68 dc 2f 78 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  h./xkkkkkkkkkkkk
[    4.994014] Object 78094c10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c50: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c60: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c70: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c80: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094c90: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094ca0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b  kkkkkkkkkkkkkkkk
[    4.994014] Object 78094cb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b a5  kkkkkkkkkkkkkkk.
[    4.994014] Redzone 78094cc0: bb bb bb bb                               =
       ....
[    4.994014] Padding 78094d68: 5a 5a 5a 5a 5a 5a 5a 5a                   =
       ZZZZZZZZ
[    4.994014] CPU: 1 PID: 1 Comm: init Tainted: G    B        3.11.0-rc6-n=
ext-20130822-07070-g245f086 #1
[    4.994014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.994014]  00000000 00000000 78073a14 7945399b 78098780 78073a44 790b3=
1a8 796184b2
[    4.994014]  78094ac0 00000ac0 00000000 00000000 00004080 78094000 78094=
c00 78094c04
[    4.994014]  78098780 78073a78 790b326f 7961850f 78094c00 78094c03 00000=
068 0000006b
[    4.994014] Call Trace:
[    4.994014]  [<7945399b>] dump_stack+0x4b/0x66
[    4.994014]  [<790b31a8>] print_trailer+0x106/0x10e
[    4.994014]  [<790b326f>] check_bytes_and_report+0x89/0xd9
[    4.994014]  [<790b33d2>] check_object+0x113/0x1a5
[    4.994014]  [<79451150>] alloc_debug_processing+0x52/0xf1
[    4.994014]  [<7945134c>] ? __slab_alloc.constprop.84+0x15d/0x319
[    4.994014]  [<79451382>] __slab_alloc.constprop.84+0x193/0x319
[    4.994014]  [<793db0ba>] ? __alloc_skb+0x5b/0x14f
[    4.994014]  [<793db0ba>] ? __alloc_skb+0x5b/0x14f
[    4.994014]  [<7904a96a>] ? __might_sleep+0x36/0xf4
[    4.994014]  [<793db093>] ? __alloc_skb+0x34/0x14f
[    4.994014]  [<7904acaa>] ? should_resched+0x8/0x22
[    4.994014]  [<7945777c>] ? _cond_resched+0x8/0x18
[    4.994014]  [<790b5560>] __kmalloc_track_caller+0x8a/0x129
[    4.994014]  [<793db0ba>] ? __alloc_skb+0x5b/0x14f
[    4.994014]  [<793da4bf>] __kmalloc_reserve.isra.26+0x1d/0x5b
[    4.994014]  [<793db0ba>] __alloc_skb+0x5b/0x14f
[    4.994014]  [<793d82b2>] sock_alloc_send_pskb+0x163/0x2cc
[    4.994014]  [<793d7867>] ? rcu_read_unlock+0x17/0x23
[    4.994014]  [<793d7a43>] ? sock_def_readable+0x4c/0x51
[    4.994014]  [<79405ee4>] unix_stream_sendmsg+0x138/0x2bb
[    4.994014]  [<793d38e9>] __sock_sendmsg_nosec+0x25/0x2a
[    4.994014]  [<793d4d23>] sock_sendmsg+0x2c/0x41
[    4.994014]  [<7904a96a>] ? __might_sleep+0x36/0xf4
[    4.994014]  [<792421d1>] ? _copy_from_user+0x36/0x4a
[    4.994014]  [<793dd99e>] ? verify_iovec+0x44/0x76
[    4.994014]  [<793d571f>] ___sys_sendmsg+0x172/0x1f6
[    4.994014]  [<7902443a>] ? __flush_tlb_all+0x12/0x1d
[    4.994014]  [<790254f3>] ? kernel_map_pages+0x75/0xb0
[    4.994014]  [<79027105>] ? kmap_atomic_prot+0x39/0x10e
[    4.994014]  [<7909324d>] ? get_page_from_freelist+0x360/0x3c3
[    4.994014]  [<790cf81c>] ? fget_light+0x2b/0x8b
[    4.994014]  [<793d5c17>] __sys_sendmsg+0x33/0x4c
[    4.994014]  [<793d628e>] SYSC_socketcall+0x2f6/0x380
[    4.994014]  [<79063357>] ? lock_release+0x150/0x19a
[    4.994014]  [<7904a01b>] ? __wake_up_sync_key+0x43/0x4a
[    4.994014]  [<79062aee>] ? __lock_acquire.isra.26+0x340/0x51e
[    4.994014]  [<790c29a8>] ? pipe_write+0x3a0/0x3b3
[    4.994014]  [<79063357>] ? lock_release+0x150/0x19a
[    4.994014]  [<790e4c3d>] ? fsnotify+0x65/0x270
[    4.994014]  [<790e4e08>] ? fsnotify+0x230/0x270
[    4.994014]  [<790e4e29>] ? fsnotify+0x251/0x270
[    4.994014]  [<790e4c3d>] ? fsnotify+0x65/0x270
[    4.994014]  [<790bc78d>] ? fsnotify_modify+0x5e/0x66
[    4.994014]  [<790bc809>] ? do_sync_read+0x74/0x74
[    4.994014]  [<790bcc49>] ? vfs_write+0xce/0xef
[    4.994014]  [<790bd021>] ? SyS_write+0x5b/0x6c
[    4.994014]  [<793d6349>] SyS_socketcall+0xe/0x10
[    4.994014]  [<794591f0>] sysenter_do_call+0x12/0x37
[    4.994014] FIX kmalloc-512: Restoring 0x78094c00-0x78094c03=3D0x6b
[    4.994014]=20
[    4.994014] FIX kmalloc-512: Marking all objects used
[    5.111122] tsc: Refined TSC clocksource calibration: 2666.664 MHz


modprobe: FATAL: Could not load /lib/modules/3.11.0-rc6-next-20130822-07070=
-g245f086/modules.dep: No such file or directory

[    5.600051] ------------[ cut here ]------------
[    5.600793] kernel BUG at kernel/timer.c:1084!
[    5.601026] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    5.601026] Modules linked in:
[    5.601026] CPU: 1 PID: 109 Comm: mount Tainted: G    B        3.11.0-rc=
6-next-20130822-07070-g245f086 #1
[    5.601026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.601026] task: 7f060000 ti: 7f26a000 task.ti: 7f26a000
[    5.601026] EIP: 0060:[<7903625b>] EFLAGS: 00010012 CPU: 1
[    5.601026] EIP is at cascade+0x3b/0x5a
[    5.601026] EAX: 6b6b6b68 EBX: 7f26bc64 ECX: 6b6b6b6b EDX: 78094b00
[    5.601026] ESI: 78138000 EDI: 00000002 EBP: 7f26bc78 ESP: 7f26bc60
[    5.601026]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    5.601026] CR0: 8005003b CR2: 6f75b004 CR3: 0722b000 CR4: 00000690
[    5.601026] Stack:
[    5.601026]  78094b00 8648e27c 797b85d0 78138000 00000000 796c21c4 7f26b=
ca4 790362dd
[    5.601026]  78138a30 78138830 8648d6f4 7f26bcdc 7904600f 7904a96a 00000=
101 7f26a000
[    5.601026]  796c21c4 7f26bce8 79031cc6 8648d7f8 8648d7c8 8648d798 00000=
003 4dc997b1
[    5.601026] Call Trace:
[    5.601026]  [<790362dd>] run_timer_softirq+0x63/0x160
[    5.601026]  [<7904600f>] ? hrtimer_interrupt+0x12d/0x1f2
[    5.601026]  [<7904a96a>] ? __might_sleep+0x36/0xf4
[    5.601026]  [<79031cc6>] __do_softirq+0x98/0x145
[    5.601026]  [<79031e46>] irq_exit+0x3b/0x76
[    5.601026]  [<7901cec9>] smp_apic_timer_interrupt+0x25/0x2f
[    5.601026]  [<79458d6a>] apic_timer_interrupt+0x2a/0x30
[    5.601026]  [<7906007b>] ? tick_device_uses_broadcast+0x82/0xfc
[    5.601026]  [<79023065>] ? native_flush_tlb_global+0x22/0x28
[    5.601026]  [<7902443a>] __flush_tlb_all+0x12/0x1d
[    5.601026]  [<790254f3>] kernel_map_pages+0x75/0xb0
[    5.601026]  [<7909320d>] get_page_from_freelist+0x320/0x3c3
[    5.601026]  [<7945134c>] ? __slab_alloc.constprop.84+0x15d/0x319
[    5.601026]  [<79093421>] __alloc_pages_nodemask+0x171/0x6a8
[    5.601026]  [<79062d47>] ? lock_acquire+0x7b/0x83
[    5.601026]  [<79063357>] ? lock_release+0x150/0x19a
[    5.601026]  [<790a059d>] ? __anon_vma_interval_tree_augment_propagate+0=
x28/0x28
[    5.601026]  [<790aaaf4>] ? anon_vma_prepare+0xcf/0xff
[    5.601026]  [<790aaaf4>] ? anon_vma_prepare+0xcf/0xff
[    5.601026]  [<790a39a6>] handle_pte_fault+0x7bc/0x8aa
[    5.601026]  [<790a69a0>] ? __vma_link_rb+0x5b/0x61
[    5.601026]  [<790a4853>] handle_mm_fault+0x19b/0x1c8
[    5.601026]  [<7904a96a>] ? __might_sleep+0x36/0xf4
[    5.601026]  [<79023cd5>] __do_page_fault+0x285/0x37b
[    5.601026]  [<790a8535>] ? do_mmap_pgoff+0x28c/0x2e6
[    5.601026]  [<7909bc5d>] ? vm_mmap_pgoff+0x57/0x73
[    5.601026]  [<790a65cc>] ? SYSC_mmap_pgoff+0x109/0x14f
[    5.601026]  [<79046709>] ? up_write+0x16/0x2b
[    5.601026]  [<790229e1>] ? kvm_async_pf_task_wake+0xa3/0xa3
[    5.601026]  [<79023e63>] do_page_fault+0x8/0xa
[    5.601026]  [<79022a04>] do_async_page_fault+0x23/0x49
[    5.601026]  [<79458f5a>] error_code+0x5a/0x60
[    5.601026]  [<790229e1>] ? kvm_async_pf_task_wake+0xa3/0xa3
[    5.601026] Code: 8b 02 8d 5d ec 89 58 04 89 45 ec 8b 42 04 89 45 f0 89 =
18 89 12 89 52 04 8b 55 ec 8b 0a 39 da 74 1f 8b 42 0c 83 e0 fc 39 c6 74 02 =
<0f> 0b 89 f0 89 4d e8 e8 cd f7 ff ff 8b 4d e8 89 ca 8b 09 eb dd
[    5.601026] EIP: [<7903625b>] cascade+0x3b/0x5a SS:ESP 0068:7f26bc60
[    5.601026] ---[ end trace a903806376c88f25 ]---
[    5.601026] Kernel panic - not syncing: Fatal exception in interrupt
[    5.601026] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/i386-randcon=
fig-j7-08250355/245f08699d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6=
-next-20130822-07070-g245f086-3174 -append 'hung_task_panic=3D1 rcutree.rcu=
_cpu_stall_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug=
 apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdis=
k=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 =
rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-j7-08250355/next:mast=
er/.vmlinuz-245f08699d5320f021070ed8698ac89ebf2f0670-20130825055215-9-bens =
branch=3Dnext/master  BOOT_IMAGE=3D/kernel/i386-randconfig-j7-08250355/245f=
08699d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-next-20130822-07070=
-g245f086'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp=
 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,v=
lan=3D0,hostfwd=3Dtcp::7270-:22 -net nic,vlan=3D1,model=3De1000 -net user,v=
lan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/sd=
a7/disk0-bens-3174,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk1-be=
ns-3174,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk2-bens-3174,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk3-bens-3174,media=3Ddisk,i=
f=3Dvirtio -drive file=3D/fs/sda7/disk4-bens-3174,media=3Ddisk,if=3Dvirtio =
-drive file=3D/fs/sda7/disk5-bens-3174,media=3Ddisk,if=3Dvirtio -pidfile /d=
ev/shm/kboot/pid-bens-lkp-3174 -serial file:/dev/shm/kboot/serial-bens-lkp-=
3174 -daemonize -display none -monitor null=20

--PNTmBPCT7hxwcZjr
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-245f08699d5320f021070ed8698ac89ebf2f0670-i386-randconfig-j7-08250355-BUG-kmalloc-2052.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMjQ1ZjA4Ni4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA4MjIKSEVBRCBpcyBub3cgYXQgNWU4ZDFhYy4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1L25leHQ6
bWFzdGVyOjVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDI6YmlzZWN0
LW5ldAoKMjAxMy0wOC0yNS0wODoyMDoxNyA1ZThkMWFjZDA1Njg3NzIwY2JiMGIwODk3NWVh
Y2I3NTg4ZmRmYzQyIGNvbXBpbGluZwo0MTYgcmVhbCAgMjEwNiB1c2VyICAyMTggc3lzICA1
NTcuOTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1CgoyMDEzLTA4LTI1LTA4
OjI3OjQ0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDY2NzctZzVlOGQxYWMu
Li4uIFRFU1QgRkFJTFVSRQpbICAgIDIuNDk4NDkyXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQg
W21lbSAweDc5NzIyMDAwLTB4Nzk3N2VmZmZdClsgICAgMi41Njc1MThdID09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09ClsgICAgMi41NjgwMTRdIEJVRyBrbWFsbG9jLTUxMiAoTm90IHRhaW50
ZWQpOiBQb2lzb24gb3ZlcndyaXR0ZW4KWyAgICAyLjU2ODAxNF0gLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KWyAgICAyLjU2ODAxNF0gClsgICAgMi41NjgwMTRdIERpc2FibGluZyBsb2Nr
IGRlYnVnZ2luZyBkdWUgdG8ga2VybmVsIHRhaW50ClsgICAgMi41NjgwMTRdIElORk86IDB4
NzgwOTRjMDAtMHg3ODA5NGMwMy4gRmlyc3QgYnl0ZSAweDY4IGluc3RlYWQgb2YgMHg2Ygov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS81ZThkMWFjZDA1Njg3NzIwY2Ji
MGIwODk3NWVhY2I3NTg4ZmRmYzQyL2RtZXNnLWt2bS13YWltZWEtMjcyMTItMjAxMzA4MjUw
ODI5MjUtMy4xMS4wLXJjNi0wNjY3Ny1nNWU4ZDFhYy0xODAKCmJpc2VjdDogYmFkIGNvbW1p
dCA1ZThkMWFjZDA1Njg3NzIwY2JiMGIwODk3NWVhY2I3NTg4ZmRmYzQyCmdpdCBjaGVja291
dCB2My4xMApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1ZThkMWFjLi4uIE1lcmdlIHJl
bW90ZS10cmFja2luZyBicmFuY2ggJ2Fpby9tYXN0ZXInCkhFQUQgaXMgbm93IGF0IDhiYjQ5
NWUuLi4gTGludXggMy4xMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1L25leHQ6bWFzdGVyOjhiYjQ5NWUzZjAyNDAxZWU2
Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LW5ldAoKMjAxMy0wOC0yNS0wODoyOTo1
MSA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNvbXBpbGluZwo1
MTYgcmVhbCAgMjE0MSB1c2VyICAyMTYgc3lzICA0NTYuOTAlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWo3LTA4MjUwMzU1CgoyMDEzLTA4LTI1LTA4OjM4OjQ2IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTAuMC4uLi4uLi4uCTEJMi4uLgkzCTQuCTUuLi4uLi4uCTYuLi4uCTcuLi4JOC4u
Li4uLi4uLgk5CTEwLi4uLi4uLi4uLi4uLgkxMQkxMwkxNC4uLi4uLi4uLgkxNgkxOAkxOS4u
Li4uLi4uLi4uLgkyMAkyMi4uLgkyNC4uCTI2CTI3Li4uCTI5LgkzMAkzMi4uLi4uLi4uLi4u
Li4uLi4uLi4uCTMzLgkzNAkzNQkzNi4uCTM3Li4uLi4uLi4JMzguCTM5Li4uLi4uLi4uLi4u
Li4uCTQwLi4uLi4uLi4JNDEuLi4uLgk0Mi4uLgk0My4JNDUJNDcuLi4uLi4uLi4uCTQ4Lgk0
OS4uLi4uLi4uLgk1MC4JNTEJNTIuCTUzCTU0Li4uLi4uLi4JNTUgU1VDQ0VTUwoKYmlzZWN0
OiBnb29kIGNvbW1pdCB2My4xMApnaXQgYmlzZWN0IHN0YXJ0IDVlOGQxYWNkMDU2ODc3MjBj
YmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDIgdjMuMTAgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgOGJiNDk1ZS4uLiBMaW51eCAzLjEwClN3aXRjaGVkIHRvIGJyYW5jaCAnbWFzdGVy
JwpZb3VyIGJyYW5jaCBpcyBiZWhpbmQgJ29yaWdpbi9tYXN0ZXInIGJ5IDMwNDggY29tbWl0
cywgYW5kIGNhbiBiZSBmYXN0LWZvcndhcmRlZC4KICAodXNlICJnaXQgcHVsbCIgdG8gdXBk
YXRlIHlvdXIgbG9jYWwgYnJhbmNoKQpCaXNlY3Rpbmc6IDkxMzAgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbOGNiZDBlZWZjYWY4Y2Mz
MmRlZDJiZjIyOWYwZmMzNzliMmFkNjlmMl0gTWVyZ2UgYnJhbmNoICduZXh0JyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcnpoYW5nL2xpbnV4
CmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0w
ODI1MDM1NS9uZXh0Om1hc3Rlcjo4Y2JkMGVlZmNhZjhjYzMyZGVkMmJmMjI5ZjBmYzM3OWIy
YWQ2OWYyOmJpc2VjdC1uZXQKCjIwMTMtMDgtMjUtMTA6Mjc6NTAgOGNiZDBlZWZjYWY4Y2Mz
MmRlZDJiZjIyOWYwZmMzNzliMmFkNjlmMiBjb21waWxpbmcKMzAyIHJlYWwgIDIyMzMgdXNl
ciAgMjM1IHN5cyAgODE1LjM4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NQoK
MjAxMy0wOC0yNS0xMDozMzo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtMDkxMjct
ZzhjYmQwZWUuCTEJNC4uLi4uCTUJOAk5CTExCTEzCTE2Li4uCTE3CTE4CTE5LgkyMAkyMgky
MwkyOQkzNQkzOC4uCTM5CTQyLi4JNDQJNDYJNDcJNTAJNTIuLi4uLi4uLi4uLgk1My4uLgk1
NC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1
ZSAxG1swbQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTU1IFNVQ0NFU1MKCkJpc2VjdGluZzog
NDU3OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3Rl
cHMpCls2MGEyYjk3NzUzM2MzMTJkMjcxNTYzZDk1NWVmN2I4ZTM1YTZhYTM4XSBNZXJnZSBy
ZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdpbmZpbmliYW5kL2Zvci1uZXh0JwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25l
dC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctajctMDgyNTAzNTUvbmV4dDptYXN0ZXI6NjBhMmI5Nzc1MzNjMzEyZDI3MTU2
M2Q5NTVlZjdiOGUzNWE2YWEzODpiaXNlY3QtbmV0CgoyMDEzLTA4LTI1LTEzOjQyOjU1IDYw
YTJiOTc3NTMzYzMxMmQyNzE1NjNkOTU1ZWY3YjhlMzVhNmFhMzggY29tcGlsaW5nCjQ3NSBy
ZWFsICAyMjE4IHVzZXIgIDIyMCBzeXMgIDUxMi44MyUgY3B1IAlpMzg2LXJhbmRjb25maWct
ajctMDgyNTAzNTUKCjIwMTMtMDgtMjUtMTM6NTE6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMS4wLXJjNi0wMjA5OC1nNjBhMmI5Ny4uLi4uLi4JMS4uLi4uLi4JMi4uLi4uLi4uLi4u
LgkzCTUuCTYuLi4uLi4uCTcJOC4uLgk5CTEwLgkxMS4JMTIuLgkxMwkxNAkxNgkxNy4JMTkJ
MjAJMjMJMjcJMzEJMzQJMzYJMzcuLi4uLi4uLi4uLgkzOAkzOQk0MS4JNDIJNDkJNTEuLi4u
Li4uLi4JNTIuLi4uLi4uLi4uLi4uCTUzLi4JNTQJNTUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAy
MzYwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVw
cykKWzRhMjI1YjQ2NmUwNDBhNzBlN2QxMmIxNTlkMmEzNmRhMWMyZWY3ZGNdIG5leHQtMjAx
MzA4MjEvZHJpdmVyLWNvcmUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1L25leHQ6
bWFzdGVyOjRhMjI1YjQ2NmUwNDBhNzBlN2QxMmIxNTlkMmEzNmRhMWMyZWY3ZGM6YmlzZWN0
LW5ldAoKMjAxMy0wOC0yNS0xNDo0NzowNSA0YTIyNWI0NjZlMDQwYTcwZTdkMTJiMTU5ZDJh
MzZkYTFjMmVmN2RjIGNvbXBpbGluZwozMjggcmVhbCAgMjI2MCB1c2VyICAyMjAgc3lzICA3
NTQuMzIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1CgoyMDEzLTA4LTI1LTE0
OjU2OjA5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDQzMTYtZzRhMjI1YjQu
LiBURVNUIEZBSUxVUkUKWyAgICAxLjkxNjU2NV0gZm1jX3dyaXRlX2VlcHJvbSBmYWtlLWRl
c2lnbi1mb3ItdGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9tOiBubyBidXNpZCBwYXNz
ZWQsIHJlZnVzaW5nIGFsbCBjYXJkcwpbICAgIDEuOTE3NDMwXSBmbWMgZmFrZS1kZXNpZ24t
Zm9yLXRlc3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0Y2hlcyBhbGwKWyAgICAx
LjkxODA1NF0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci8wLzEvMHgx
MDAwMDAwMgpbICAgIDEuOTE4NTE3XSA0IGxvY2tzIGhlbGQgYnkgc3dhcHBlci8wLzE6Clsg
ICAgMS45MTg4MDldICAjMDogICgmX19sb2NrZGVwX25vX3ZhbGlkYXRlX18pey4uLi4uLn0s
IGF0OiBbPDc5MmQyMDNkPl0gX19kcml2ZXJfYXR0YWNoKzB4MjYvMHg3MQpbICAgIDEuOTE5
NTUwXSAgIzE6ICAoJl9fbG9ja2RlcF9ub192YWxpZGF0ZV9fKXsuLi4uLi59LCBhdDogWzw3
OTJkMjA1OD5dIF9fZHJpdmVyX2F0dGFjaCsweDQxLzB4NzEKWyAgICAxLjkyMDI2Nl0gICMy
OiAgKGZjX2xvY2spey4uLi4uLn0sIGF0OiBbPDc5M2JkMTM2Pl0gZmNfcHJvYmUrMHg3YS8w
eGY0ClsgICAgMS45MjA4MjNdICAjMzogIChtaXNjX210eCl7Li4uLi4ufSwgYXQ6IFs8Nzky
YzgzYTU+XSBtaXNjX3JlZ2lzdGVyKzB4MWYvMHhmOQpbICAgIDEuOTIxNDMwXSBNb2R1bGVz
IGxpbmtlZCBpbjoKWyAgICAxLjkyMTY3N10gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVy
LzAgTm90IHRhaW50ZWQgMy4xMS4wLXJjNi0wNDMxNi1nNGEyMjViNCAjMTg0ClsgICAgMS45
MjIyNjhdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgICAxLjkyMjY5OV0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDczYzE0IDc5NDRjMDU3
IDc4MDc4MDAwIDc4MDczYzMwIDc5NDQ3ZGJjIDc5NjA1MjgxClsgICAgMS45MjMzNzldICA3
ODA3ODJlYyAwMDAwMDAwMSAxMDAwMDAwMiA3ODA3MjAwMCA3ODA3M2NiOCA3OTQ0ZjczYyA3
MjUzMjUyYiA4NjQ5MTA0OApbICAgIDEuOTI0MDU1XSAgMDAwMDAwMDAgNzk3NzJmYzAgODY0
OTEwMjAgNzgwNzNjNjQgMDAwMDAwMjcgMDAwMDAwMDAgMDAwMDAwMDEgNzgwNzIwMDAKWyAg
ICAxLjkyNDcxN10gQ2FsbCBUcmFjZToKWyAgICAxLjkyNDkwOV0gIFs8Nzk0NGMwNTc+XSBk
dW1wX3N0YWNrKzB4NGIvMHg2NgpbICAgIDEuOTI1MjU4XSAgWzw3OTQ0N2RiYz5dIF9fc2No
ZWR1bGVfYnVnKzB4NTYvMHg2OApbICAgIDEuOTI1NjIyXSAgWzw3OTQ0ZjczYz5dIF9fc2No
ZWR1bGUrMHg1ZS8weDU3ZQpbICAgIDEuOTI1OTYyXSAgWzw3OTA2MzI5Mz5dID8gbG9ja19y
ZWxlYXNlKzB4MTVkLzB4MWFmClsgICAgMS45MjYzNTNdICBbPDc5MDYzMjkzPl0gPyBsb2Nr
X3JlbGVhc2UrMHgxNWQvMHgxYWYKWyAgICAxLjkyNjczMl0gIFs8NzkwNDAwMTQ+XSA/IHdv
cmtxdWV1ZV9jcHVfdXBfY2FsbGJhY2srMHgzNmEvMHg0MGIKWyAgICAxLjkyNzE5N10gIFs8
NzkwNGI1NDI+XSBfX2NvbmRfcmVzY2hlZCsweDE2LzB4MjYKWyAgICAxLjkyNzU2NF0gIFs8
Nzk0NGZlNDU+XSBfY29uZF9yZXNjaGVkKzB4MTEvMHgxOApbICAgIDEuOTI3OTE4XSAgWzw3
OTQ0ZmU3Mj5dIF9fd2FpdF9mb3JfY29tbW9uKzB4MjYvMHhlMgpbICAgIDEuOTI4MzI1XSAg
Wzw3OTQ0ZDUyOD5dID8gX19wb3Bfdmxhbl90Y2krMHgxMDIvMHgxMDIKWyAgICAxLjkyODcx
M10gIFs8NzkwNGNjMzU+XSA/IHRyeV90b193YWtlX3VwKzB4MTY3LzB4MTcxClsgICAgMS45
MjkxMDZdICBbPDc5NDRmZjQ4Pl0gd2FpdF9mb3JfY29tcGxldGlvbisweDFhLzB4MWMKWyAg
ICAxLjkyOTUwMF0gIFs8NzkyZDRmM2Q+XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsweGQxLzB4
ZWQKWyAgICAxLjkyOTg5N10gIFs8NzkxMDAxMDE+XSA/IHN5c2ZzX29wZW5fZmlsZSsweDFj
LzB4MWI4ClsgICAgMS45MzAyOTFdICBbPDc5MmNmYzBlPl0gZGV2aWNlX2FkZCsweDE5OC8w
eDU2NgpbICAgIDEuOTMwNjQwXSAgWzw3OTA0MzgwMD5dID8gX19pbml0X3dhaXRxdWV1ZV9o
ZWFkKzB4MmYvMHgzZQpbICAgIDEuOTMxMDYzXSAgWzw3OTAwMzEzNj5dID8gZml4dXBfaXJx
cysweGJmLzB4MWUzClsgICAgMS45MzE0MjFdICBbPDc5MmNmZmVlPl0gZGV2aWNlX3JlZ2lz
dGVyKzB4MTIvMHgxNQpbICAgIDEuOTMxNzg0XSAgWzw3OTJkMDBmZj5dIGRldmljZV9jcmVh
dGVfZ3JvdXBzX3ZhcmdzKzB4NzIvMHg5OQpbICAgIDEuOTMyMjI5XSAgWzw3OTJkMDE0ZT5d
IGRldmljZV9jcmVhdGVfdmFyZ3MrMHgyOC8weDJlClsgICAgMS45MzI2MjNdICBbPDc5MmQw
MTdjPl0gZGV2aWNlX2NyZWF0ZSsweDI4LzB4MmEKWyAgICAxLjkzMjk3MF0gIFs8NzkyYzg0
MmY+XSBtaXNjX3JlZ2lzdGVyKzB4YTkvMHhmOQpbICAgIDEuOTMzMzQwXSAgWzw3OTNiZDEz
ZT5dIGZjX3Byb2JlKzB4ODIvMHhmNApbICAgIDEuOTMzNjYxXSAgWzw3OTEwMTYxZj5dID8g
c3lzZnNfY3JlYXRlX2xpbmsrMHgyNC8weDJkClsgICAgMS45MzQwNThdICBbPDc5M2JiODQ2
Pl0gZm1jX3Byb2JlKzB4Zi8weDExClsgICAgMS45MzQzODRdICBbPDc5MmQxZWRkPl0gZHJp
dmVyX3Byb2JlX2RldmljZSsweDhkLzB4MTliClsgICAgMS45MzQ3NzldICBbPDc5M2JiZDVi
Pl0gPyBmbWNfbWF0Y2grMHgyNC8weDgzClsgICAgMS45MzUxMzBdICBbPDc5MmQyMDZhPl0g
X19kcml2ZXJfYXR0YWNoKzB4NTMvMHg3MQpbICAgIDEuOTM1NTAwXSAgWzw3OTJkMDhmMT5d
IGJ1c19mb3JfZWFjaF9kZXYrMHg1Ny8weDYxClsgICAgMS45MzU4NzBdICBbPDc5MmQxYWYz
Pl0gZHJpdmVyX2F0dGFjaCsweDE3LzB4MTkKWyAgICAxLjkzNjIzNF0gIFs8NzkyZDIwMTc+
XSA/IF9fZGV2aWNlX2F0dGFjaCsweDJjLzB4MmMKWyAgICAxLjkzNjYxNl0gIFs8NzkyZDE3
ODc+XSBidXNfYWRkX2RyaXZlcisweGU3LzB4MjEyClsgICAgMS45MzY5NzRdICBbPDc5MmQy
M2Q4Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4N2EvMHhhZQpbICAgIDEuOTM3MzU1XSAgWzw3OTJk
MTI3YT5dID8gYnVzX3JlZ2lzdGVyKzB4MTUzLzB4MjdkClsgICAgMS45Mzc3MjVdICBbPDc5
M2JiOTE0Pl0gZm1jX2RyaXZlcl9yZWdpc3RlcisweDIzLzB4MmQKWyAgICAxLjkzODEyNF0g
IFs8NzkzYmQwOWU+XSA/IGZjX3JlYWQrMHg2OC8weDY4ClsgICAgMS45Mzg0NjhdICBbPDc5
M2JkMGFiPl0gZmNfaW5pdCsweGQvMHhmClsgICAgMS45Mzg3NzFdICBbPDc5MDAwNDA2Pl0g
ZG9fb25lX2luaXRjYWxsKzB4N2YvMHgxMDYKWyAgICAxLjkzOTE1M10gIFs8NzkyNDIxZDc+
XSA/IHN0cmxlbisweGQvMHgxNwpbICAgIDEuOTM5NDcyXSAgWzw3OTcxNzQzZD5dID8gcmVw
YWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMS45Mzk4NjBdICBbPDc5MDQxZTNkPl0g
PyBwYXJzZV9hcmdzKzB4MTZiLzB4MjI2ClsgICAgMS45NDAyMzBdICBbPDc5NDUwOTM1Pl0g
PyBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHgyNy8weDM1ClsgICAgMS45NDA2ODZd
ICBbPDc5NzE3YWQ1Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMzAvMHgxYzIKWyAgICAx
Ljk0MTEwNl0gIFs8Nzk3MTc0MmI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3OApbICAg
IDEuOTQxNDgyXSAgWzw3OTQ0MWU1MD5dIGtlcm5lbF9pbml0KzB4Yi8weGJlClsgICAgMS45
NDE4MTRdICBbPDc5NDUxNzNiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAK
WyAgICAxLjk0MjIzNF0gIFs8Nzk0NDFlNDU+XSA/IHJlc3RfaW5pdCsweGMxLzB4YzEKWyAg
ICAxLjk0MjY3MV0gZm1jX2NoYXJkZXYgZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTog
Q3JlYXRlZCBtaXNjIGRldmljZSAiZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMSIKWyAg
ICAxLjk0MzgyN10gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS80YTIyNWI0NjZlMDQwYTcwZTdkMTJiMTU5
ZDJhMzZkYTFjMmVmN2RjL2RtZXNnLWt2bS1pbm4tNzUyNi0yMDEzMDgyNTE0NTY1Mi0zLjEx
LjAtcmM2LTA0MzE2LWc0YTIyNWI0LTE4NAoKQmlzZWN0aW5nOiAxMTE1IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzk4MjQ2YzFhZTZm
MThmZTFiNzEwY2RmZjY4N2I2YjcwNzdmNzM5YzldIE1lcmdlIHJlbW90ZS10cmFja2luZyBi
cmFuY2ggJ3ZpcnRpby92aXJ0aW8tbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUw
MzU1L25leHQ6bWFzdGVyOjk4MjQ2YzFhZTZmMThmZTFiNzEwY2RmZjY4N2I2YjcwNzdmNzM5
Yzk6YmlzZWN0LW5ldAoKMjAxMy0wOC0yNS0xNDo1NzoxNCA5ODI0NmMxYWU2ZjE4ZmUxYjcx
MGNkZmY2ODdiNmI3MDc3ZjczOWM5IGNvbXBpbGluZwo3OTQgcmVhbCAgMjIzMCB1c2VyICAy
MjIgc3lzICAzMDguODElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1CgoyMDEz
LTA4LTI1LTE1OjEwOjUyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDMyMDAt
Zzk4MjQ2YzEuCTQJMTAJMTEJMTIJMjEJMjQJMjUJMzIJNDMJNTEuLi4uLi4uLi4uLi4uLi4u
Lgk1Mgk1My4uCTU1IFNVQ0NFU1MKCkJpc2VjdGluZzogNTU1IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbMzgxMzZjMWYxNDcxYzdkY2Jl
ODg5YmViNzkwY2M0ZDMzMWU5ZDNhZF0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
c3BpL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvbmV4dDptYXN0
ZXI6MzgxMzZjMWYxNDcxYzdkY2JlODg5YmViNzkwY2M0ZDMzMWU5ZDNhZDpiaXNlY3QtbmV0
CgoyMDEzLTA4LTI1LTE1OjI3OjI3IDM4MTM2YzFmMTQ3MWM3ZGNiZTg4OWJlYjc5MGNjNGQz
MzFlOWQzYWQgY29tcGlsaW5nCjMwNSByZWFsICAyMjQ4IHVzZXIgIDIyOSBzeXMgIDgxMC4w
MCUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUKCjIwMTMtMDgtMjUtMTU6MzM6
MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0wMzc2MC1nMzgxMzZjMS4uLi4J
MgkzCTQuLi4uCTUJNi4JOAk5CTExLgkxMwkxNgkyMS4JMjIJMjMJMjQuCTMwCTM0CTM1Li4J
MzYuLi4JMzcJMzgJMzkJNDAJNDIJNDMuLi4uLi4JNDUuCTQ2CTQ4Li4uLgk0OS4JNTAuLgk1
MS4uCTUyCTUzLi4uLi4uLgk1NC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7
MzVtYWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLi4uLi4uLi4JNTUgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAyNzUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDgg
c3RlcHMpCltmMDc3NjJiZTNiOTIyMmE3NjQ5Y2IyOWEzZjViOTU5MjA0ZDQwNDQ2XSBNZXJn
ZSBicmFuY2ggJ3g4Ni9hc21saW5rYWdlJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMDgyNTAz
NTUvbmV4dDptYXN0ZXI6ZjA3NzYyYmUzYjkyMjJhNzY0OWNiMjlhM2Y1Yjk1OTIwNGQ0MDQ0
NjpiaXNlY3QtbmV0CgoyMDEzLTA4LTI1LTE4OjQ1OjExIGYwNzc2MmJlM2I5MjIyYTc2NDlj
YjI5YTNmNWI5NTkyMDRkNDA0NDYgY29tcGlsaW5nCjMwNiByZWFsICAyMjM2IHVzZXIgIDIx
NSBzeXMgIDc5OC43NSUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUKCjIwMTMt
MDgtMjUtMTg6NTA6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0wMDMwOC1n
ZjA3NzYyYi4uLgkzLi4JNAk2CTgJMTIuCTE0CTE4LgkxOS4JMjEuLi4JMjMuLgkyNC4JMjYu
CTI4CTI5LgkzMgk0MQk0Nwk1MQk1Mgk1My4uLi4uCTU0Li4uLi4uLi4uLi4JNTUgU1VDQ0VT
UwoKQmlzZWN0aW5nOiAxMzggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDcgc3RlcHMpCls5M2Q2Mjk0ZGZjZGZmODExOTQwODZlZDliZDZjZWNhM2JjNWU1
ODYzXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdrdm0tcHBjL2t2bS1wcGMtbmV4
dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1L25leHQ6bWFzdGVyOjkzZDYyOTRk
ZmNkZmY4MTE5NDA4NmVkOWJkNmNlY2EzYmM1ZTU4NjM6YmlzZWN0LW5ldAoKMjAxMy0wOC0y
NS0xOToxNzo0NyA5M2Q2Mjk0ZGZjZGZmODExOTQwODZlZDliZDZjZWNhM2JjNWU1ODYzIGNv
bXBpbGluZwozMTAgcmVhbCAgMjI4MiB1c2VyICAyMjcgc3lzICA4MDguODQlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1CgoyMDEzLTA4LTI1LTE5OjIzOjMxIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDQxNzctZzkzZDYyOTQuLgkyCTgJMTIJMTkJMjIJ
MjYJMzEJMzgJNDMJNDUJNDYuLgk0OC4JNTEJNTIuLi4uLgk1My4uLi4uLi4uLi4uLgk1NC4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAx
G1swbQouLi4uLi4uCTU1IFNVQ0NFU1MKCkJpc2VjdGluZzogNTcgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCltjNTdlOGM4OWIyNzFhZjRl
ZjkxNGM0MzllZmZmZmVkNTNjMzk0MzRjXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdsZWRzL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvbmV4dDpt
YXN0ZXI6YzU3ZThjODliMjcxYWY0ZWY5MTRjNDM5ZWZmZmZlZDUzYzM5NDM0YzpiaXNlY3Qt
bmV0CgoyMDEzLTA4LTI1LTIyOjE3OjA1IGM1N2U4Yzg5YjI3MWFmNGVmOTE0YzQzOWVmZmZm
ZWQ1M2MzOTQzNGMgY29tcGlsaW5nCjMxNyByZWFsICAyMjQ1IHVzZXIgIDIxOSBzeXMgIDc3
Ni42NCUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUKCjIwMTMtMDgtMjUtMjI6
MjI6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0wNDI1OC1nYzU3ZThjOC4u
Li4JMS4JMgkzLgk0Lgk1CTYJNy4uLgkxNQkxOQkzNQk0NC4JNDYuLi4JNDcuLgk0OC4uLi4u
CTQ5CTUwCTUzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9f
cnVuX3F1ZXVlIDIbWzBtCi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTU0Li4JNTUg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAyOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNSBzdGVwcykKWzc2ZjQxMWZiM2E2MjcxMWRlN2Y1OWUwZjRjNTY0NTZm
ZTM1NjY3NWFdIHg4NiAvIGNwdSB0b3BvbG9neTogcmVtb3ZlIHRoZSBzdGFsZSBtYWNybyBh
cmNoX3Byb3ZpZGVzX3RvcG9sb2d5X3BvaW50ZXJzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0w
ODI1MDM1NS9uZXh0Om1hc3Rlcjo3NmY0MTFmYjNhNjI3MTFkZTdmNTllMGY0YzU2NDU2ZmUz
NTY2NzVhOmJpc2VjdC1uZXQKCjIwMTMtMDgtMjYtMDE6Mjk6MDAgNzZmNDExZmIzYTYyNzEx
ZGU3ZjU5ZTBmNGM1NjQ1NmZlMzU2Njc1YSBjb21waWxpbmcKNTI5IHJlYWwgIDIwOTQgdXNl
ciAgMjE5IHN5cyAgNDM3LjA0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NQoK
MjAxMy0wOC0yNi0wMTozODoxOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMzLTAw
MDI5LWc3NmY0MTFmLi4uLiBURVNUIEZBSUxVUkUKWyAgICA3Ljg4MTgzN10gZm1jX3dyaXRl
X2VlcHJvbSBmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9t
OiBubyBidXNpZCBwYXNzZWQsIHJlZnVzaW5nIGFsbCBjYXJkcwpbICAgIDcuODgzNTU0XSBm
bWMgZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0
Y2hlcyBhbGwKWyAgICA3Ljg4NDg0OF0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzog
c3dhcHBlci8wLzEvMHgxMDAwMDAwMgpbICAgIDcuODk1NjM0XSA0IGxvY2tzIGhlbGQgYnkg
c3dhcHBlci8wLzE6ClsgICAgNy44OTYyNjZdICAjMDogICgmX19sb2NrZGVwX25vX3ZhbGlk
YXRlX18pey4uLi4uLn0sIGF0OiBbPDc5MmNmNTMzPl0gX19kcml2ZXJfYXR0YWNoKzB4MjYv
MHg3MQpbICAgIDcuODk3NzU1XSAgIzE6ICAoJl9fbG9ja2RlcF9ub192YWxpZGF0ZV9fKXsu
Li4uLi59LCBhdDogWzw3OTJjZjU0ZT5dIF9fZHJpdmVyX2F0dGFjaCsweDQxLzB4NzEKWyAg
ICA3Ljg5OTI4NV0gICMyOiAgKGZjX2xvY2spey4uLi4uLn0sIGF0OiBbPDc5M2JhNWIxPl0g
ZmNfcHJvYmUrMHg3YS8weGY5ClsgICAgNy45MDA0MzddICAjMzogIChtaXNjX210eCl7Li4u
Li4ufSwgYXQ6IFs8NzkyYzU5OGI+XSBtaXNjX3JlZ2lzdGVyKzB4MWYvMHhmOQpbICAgIDcu
OTAxNzExXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA3LjkwMjI1OF0gQ1BVOiAxIFBJRDog
MSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLXJjMy0wMDAyOS1nNzZmNDEx
ZiAjMTkwClsgICAgNy45MDM0NzddIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICA3LjkwNDQyOV0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4
MDczYzEwIDc5NDQ4ZTAwIDc4MDc4MDAwIDc4MDczYzJjIDc5NDQ0Yzk4IDc5NWZmMGU4Clsg
ICAgNy45MDU4MTldICA3ODA3ODJlMCAwMDAwMDAwMSAxMDAwMDAwMiA3ODA3MjAwMCA3ODA3
M2NiNCA3OTQ0YzUwOSBkNWY5MmYxMiA4NjQ5MTEwOApbICAgIDcuOTA3MjIzXSAgMDAwMDAw
MDAgNzk3NmQwODAgODY0OTEwZTAgNzgwNzNjNjAgMDAwMDAwZDYgMDAwMDAwMDAgMDAwMDAw
MDEgNzgwNzIwMDAKWyAgICA3LjkwODYxNV0gQ2FsbCBUcmFjZToKWyAgICA3LjkwOTAxMV0g
IFs8Nzk0NDhlMDA+XSBkdW1wX3N0YWNrKzB4NGIvMHg2NgpbICAgIDcuOTA5NzU2XSAgWzw3
OTQ0NGM5OD5dIF9fc2NoZWR1bGVfYnVnKzB4NTYvMHg2OApbICAgIDcuOTEwNTM2XSAgWzw3
OTQ0YzUwOT5dIF9fc2NoZWR1bGUrMHg1ZS8weDU3ZQpbICAgIDcuOTExMzAyXSAgWzw3OTA2
MmI0OT5dID8gbG9ja19yZWxlYXNlKzB4MTVkLzB4MWFmClsgICAgNy45MTIxMDVdICBbPDc5
MDYyYjQ5Pl0gPyBsb2NrX3JlbGVhc2UrMHgxNWQvMHgxYWYKWyAgICA3LjkxMjg3MV0gIFs8
NzkwNDAwMTQ+XSA/IGxpbmtfcHdxKzB4MmQvMHg1YwpbICAgIDcuOTEzNjA4XSAgWzw3OTA0
ZDhkZj5dIF9fY29uZF9yZXNjaGVkKzB4MTYvMHgyNgpbICAgIDcuOTE0Mzg2XSAgWzw3OTQ0
Y2MxMj5dIF9jb25kX3Jlc2NoZWQrMHgxMS8weDE4ClsgICAgNy45MTUxNTVdICBbPDc5NDRj
YzNmPl0gX193YWl0X2Zvcl9jb21tb24rMHgyNi8weGUyClsgICAgNy45MTU5MzFdICBbPDc5
NDRhMmY0Pl0gPyBjb25zb2xlX2NvbmRpdGlvbmFsX3NjaGVkdWxlKzB4MjQvMHgyNApbICAg
IDcuOTE2OTI5XSAgWzw3OTA0ZWZmMT5dID8gdHJ5X3RvX3dha2VfdXArMHgxNjcvMHgxNzEK
WyAgICA3LjkxNzc2N10gIFs8Nzk0NGNkMTU+XSB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4MWEv
MHgxYwpbICAgIDcuOTE4NjE5XSAgWzw3OTJkMjNmYj5dIGRldnRtcGZzX2NyZWF0ZV9ub2Rl
KzB4ZDEvMHhlZApbICAgIDcuOTE5NDkwXSAgWzw3OTBmMDEwMT5dID8gZHF1b3Rfc2V0X2Rx
aW5mbysweDZhLzB4YjUKWyAgICA3LjkyMDMyNV0gIFs8NzkyY2QxZjQ+XSBkZXZpY2VfYWRk
KzB4MTk4LzB4NTY2ClsgICAgNy45MjEwODBdICBbPDc5MDQ1YmRlPl0gPyBfX2luaXRfd2Fp
dHF1ZXVlX2hlYWQrMHgyZi8weDNlClsgICAgNy45MjE5MzRdICBbPDc5MDAzMTM2Pl0gPyBm
aXh1cF9pcnFzKzB4YjEvMHgxZTMKWyAgICA3LjkyMjcxM10gIFs8NzkyY2Q1ZDQ+XSBkZXZp
Y2VfcmVnaXN0ZXIrMHgxMi8weDE1ClsgICAgNy45MjM1MDZdICBbPDc5MmNkNmU1Pl0gZGV2
aWNlX2NyZWF0ZV9ncm91cHNfdmFyZ3MrMHg3Mi8weDk5ClsgICAgNy45MjQ0NDRdICBbPDc5
MmNkNzM0Pl0gZGV2aWNlX2NyZWF0ZV92YXJncysweDI4LzB4MmUKWyAgICA3LjkyNTI5OV0g
IFs8NzkyY2Q3NjI+XSBkZXZpY2VfY3JlYXRlKzB4MjgvMHgyYQpbICAgIDcuOTI2MDc4XSAg
Wzw3OTJjNWExNT5dIG1pc2NfcmVnaXN0ZXIrMHhhOS8weGY5ClsgICAgNy45MjY4MDNdICBb
PDc5M2JhNWI5Pl0gZmNfcHJvYmUrMHg4Mi8weGY5ClsgICAgNy45Mjc1MDVdICBbPDc5MTAw
MGNjPl0gPyBzeXNmc19jcmVhdGVfbGluaysweDI0LzB4MmQKWyAgICA3LjkyODM1M10gIFs8
NzkzYjhjYzE+XSBmbWNfcHJvYmUrMHhmLzB4MTEKWyAgICA3LjkyOTA3MF0gIFs8NzkyY2Yz
ZDM+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4OGQvMHgxOWIKWyAgICA3LjkyOTg4Nl0gIFs8
NzkyY2Y1NjA+XSBfX2RyaXZlcl9hdHRhY2grMHg1My8weDcxClsgICAgNy45MzA2OTZdICBb
PDc5MmNkZWFlPl0gYnVzX2Zvcl9lYWNoX2RldisweDU3LzB4NjEKWyAgICA3LjkzMTUwNF0g
IFs8NzkyY2VmZTk+XSBkcml2ZXJfYXR0YWNoKzB4MTcvMHgxOQpbICAgIDcuOTMyMjc2XSAg
Wzw3OTJjZjUwZD5dID8gX19kZXZpY2VfYXR0YWNoKzB4MmMvMHgyYwpbICAgIDcuOTMzMDk4
XSAgWzw3OTJjZWNiNj5dIGJ1c19hZGRfZHJpdmVyKzB4ZTcvMHgxZWEKWyAgICA3LjkzMzg1
NV0gIFs8NzkyY2Y4MWU+XSBkcml2ZXJfcmVnaXN0ZXIrMHg3YS8weGQzClsgICAgNy45MzQ2
NjddICBbPDc5MmNlMzZjPl0gPyBidXNfcmVnaXN0ZXIrMHgxNTMvMHgyMjMKWyAgICA3Ljkz
NTQ3Nl0gIFs8NzkzYjhkOGY+XSBmbWNfZHJpdmVyX3JlZ2lzdGVyKzB4MjMvMHgyZApbICAg
IDcuOTM2MzMxXSAgWzw3OTNiYTUxOT5dID8gZmNfcmVhZCsweDY4LzB4NjgKWyAgICA3Ljkz
NzA1Ml0gIFs8NzkzYmE1MjY+XSBmY19pbml0KzB4ZC8weGYKWyAgICA3LjkzNzY4MF0gIFs8
NzkwMDA0MDY+XSBkb19vbmVfaW5pdGNhbGwrMHg3Zi8weDEwNgpbICAgIDcuOTM4NDk4XSAg
Wzw3OTIzZmQ1NT5dID8gc3RybGVuKzB4Yi8weDE3ClsgICAgNy45MzkyMTZdICBbPDc5NzEx
NDNkPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAgICA3Ljk0MDA2Ml0gIFs8
NzkwNDQyMjM+XSA/IHBhcnNlX2FyZ3MrMHgxNzUvMHgyMzAKWyAgICA3Ljk0MDgwMl0gIFs8
Nzk0NGQ2ZTk+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDI3LzB4MzUKWyAg
ICA3Ljk0MTc3Nl0gIFs8Nzk3MTFhZDU+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEzMC8w
eDFjMgpbICAgIDcuOTQyNjcwXSAgWzw3OTcxMTQyYj5dID8gZG9fZWFybHlfcGFyYW0rMHg3
OC8weDc4ClsgICAgNy45NDM0NzVdICBbPDc5NDNlYzcwPl0ga2VybmVsX2luaXQrMHhiLzB4
YmUKWyAgICA3Ljk0NDIwOF0gIFs8Nzk0NGU0ZGI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFk
KzB4MWIvMHgzMApbICAgIDcuOTQ1MTA1XSAgWzw3OTQzZWM2NT5dID8gcmVzdF9pbml0KzB4
YzEvMHhjMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS83NmY0MTFmYjNh
NjI3MTFkZTdmNTllMGY0YzU2NDU2ZmUzNTY2NzVhL2RtZXNnLWt2bS13YWltZWEtOTM1My0y
MDEzMDgyNjAxMzk0MS0zLjExLjAtcmMzLTAwMDI5LWc3NmY0MTFmLTE5MAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS83NmY0MTFmYjNhNjI3MTFkZTdmNTllMGY0YzU2
NDU2ZmUzNTY2NzVhL2RtZXNnLWt2bS1iZW5zLTQwNDAtMjAxMzA4MjYwMTM1NDQtMy4xMS4w
LXJjMy0wMDAyOS1nNzZmNDExZi0xOTAKCkJpc2VjdGluZzogMTQgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCltlYTFiYjcwNjRmZDY5NzJl
ZjAwYTkzYmE4ODJhMmYzODQ1MGIyNzNlXSB2aWRlbzogYmFja2xpZ2h0OiBjb252ZXJ0IGNs
YXNzIGNvZGUgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUw
MzU1L25leHQ6bWFzdGVyOmVhMWJiNzA2NGZkNjk3MmVmMDBhOTNiYTg4MmEyZjM4NDUwYjI3
M2U6YmlzZWN0LW5ldAoKMjAxMy0wOC0yNi0wMTo0MDoyMiBlYTFiYjcwNjRmZDY5NzJlZjAw
YTkzYmE4ODJhMmYzODQ1MGIyNzNlIGNvbXBpbGluZwoyOTYgcmVhbCAgMjE5NCB1c2VyICAy
MTUgc3lzICA4MTMuMTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1CgoyMDEz
LTA4LTI2LTAxOjQ1OjM0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAwMTQt
Z2VhMWJiNzAuLi4gVEVTVCBGQUlMVVJFClsgICAgMy42MzExNzNdIGZtY193cml0ZV9lZXBy
b20gZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogZm1jX3dyaXRlX2VlcHJvbTogbm8g
YnVzaWQgcGFzc2VkLCByZWZ1c2luZyBhbGwgY2FyZHMKWyAgICAzLjYzMjY0NF0gZm1jIGZh
a2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDE6IERyaXZlciBoYXMgbm8gSUQ6IG1hdGNoZXMg
YWxsClsgICAgMy42MzM2ODldIEJVRzogc2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3YXBw
ZXIvMC8xLzB4MTAwMDAwMDIKWyAgICAzLjY0NzM2MV0gNCBsb2NrcyBoZWxkIGJ5IHN3YXBw
ZXIvMC8xOgpbICAgIDMuNjQ3ODU3XSAgIzA6ICAoJl9fbG9ja2RlcF9ub192YWxpZGF0ZV9f
KXsuLi4uLi59LCBhdDogWzw3OTJjZjUxZj5dIF9fZHJpdmVyX2F0dGFjaCsweDI2LzB4NzEK
WyAgICAzLjY0OTEzNV0gICMxOiAgKCZfX2xvY2tkZXBfbm9fdmFsaWRhdGVfXyl7Li4uLi4u
fSwgYXQ6IFs8NzkyY2Y1M2E+XSBfX2RyaXZlcl9hdHRhY2grMHg0MS8weDcxClsgICAgMy42
NTAzODJdICAjMjogIChmY19sb2NrKXsuLi4uLi59LCBhdDogWzw3OTNiYTU5MT5dIGZjX3By
b2JlKzB4N2EvMHhmOQpbICAgIDMuNjUxMzA5XSAgIzM6ICAobWlzY19tdHgpey4uLi4uLn0s
IGF0OiBbPDc5MmM1OTc3Pl0gbWlzY19yZWdpc3RlcisweDFmLzB4ZjkKWyAgICAzLjY1MjM4
MV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMy42NTI3OTNdIENQVTogMSBQSUQ6IDEgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMTQtZ2VhMWJiNzAgIzE5
MQpbICAgIDMuNjUzODAxXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMy42NTQ1NjBdICAwMDAwMDAwMCAwMDAwMDAwMCA3ODA3M2Mx
MCA3OTQ0OGRlMCA3ODA3ODAwMCA3ODA3M2MyYyA3OTQ0NGM3OCA3OTVmZjBmOApbICAgIDMu
NjU1Njk0XSAgNzgwNzgyZTAgMDAwMDAwMDEgMTAwMDAwMDIgNzgwNzIwMDAgNzgwNzNjYjQg
Nzk0NGM0ZTcgZDg5NWE2NjcgODY0OTExMDgKWyAgICAzLjY1NjgyM10gIDAwMDAwMDAwIDc5
NzZkMDgwIDg2NDkxMGUwIDc4MDczYzYwIDAwMDAwMDg1IDAwMDAwMDAwIDAwMDAwMDAxIDc4
MDcyMDAwClsgICAgMy42NTc5NDRdIENhbGwgVHJhY2U6ClsgICAgMy42NTgyNzRdICBbPDc5
NDQ4ZGUwPl0gZHVtcF9zdGFjaysweDRiLzB4NjYKWyAgICAzLjY1ODg2M10gIFs8Nzk0NDRj
Nzg+XSBfX3NjaGVkdWxlX2J1ZysweDU2LzB4NjgKWyAgICAzLjY1OTU3Ml0gIFs8Nzk0NGM0
ZTc+XSBfX3NjaGVkdWxlKzB4NWUvMHg1N2UKWyAgICAzLjY2MDE3OF0gIFs8NzkwNjJiNDk+
XSA/IGxvY2tfcmVsZWFzZSsweDE1ZC8weDFhZgpbICAgIDMuNjYwODMxXSAgWzw3OTA2MmI0
OT5dID8gbG9ja19yZWxlYXNlKzB4MTVkLzB4MWFmClsgICAgMy42NjE1MTVdICBbPDc5MDQw
MDE0Pl0gPyBsaW5rX3B3cSsweDJkLzB4NWMKWyAgICAzLjY2MjEyNF0gIFs8NzkwNGQ4ZGY+
XSBfX2NvbmRfcmVzY2hlZCsweDE2LzB4MjYKWyAgICAzLjY2Mjc2MV0gIFs8Nzk0NGNiZjA+
XSBfY29uZF9yZXNjaGVkKzB4MTEvMHgxOApbICAgIDMuNjYzNDIwXSAgWzw3OTQ0Y2MxZD5d
IF9fd2FpdF9mb3JfY29tbW9uKzB4MjYvMHhlMgpbICAgIDMuNjY0MDg3XSAgWzw3OTQ0YTJk
ND5dID8gY29uc29sZV9jb25kaXRpb25hbF9zY2hlZHVsZSsweDI0LzB4MjQKWyAgICAzLjY2
NDg5MF0gIFs8NzkwNGVmZjE+XSA/IHRyeV90b193YWtlX3VwKzB4MTY3LzB4MTcxClsgICAg
My42NjU1ODRdICBbPDc5NDRjY2YzPl0gd2FpdF9mb3JfY29tcGxldGlvbisweDFhLzB4MWMK
WyAgICAzLjY2NjI3Nl0gIFs8NzkyZDIzZTc+XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsweGQx
LzB4ZWQKWyAgICAzLjY2Njk3NV0gIFs8NzkwZjAxMDE+XSA/IGRxdW90X3NldF9kcWluZm8r
MHg3YS8weGI1ClsgICAgMy42Njc2ODVdICBbPDc5MmNkMWUwPl0gZGV2aWNlX2FkZCsweDE5
OC8weDU2NgpbICAgIDMuNjY4MzA0XSAgWzw3OTA0NWJkZT5dID8gX19pbml0X3dhaXRxdWV1
ZV9oZWFkKzB4MmYvMHgzZQpbICAgIDMuNjY5MDcyXSAgWzw3OTAwMzEzNj5dID8gZml4dXBf
aXJxcysweGIxLzB4MWUzClsgICAgMy42Njk2OTddICBbPDc5MmNkNWMwPl0gZGV2aWNlX3Jl
Z2lzdGVyKzB4MTIvMHgxNQpbICAgIDMuNjcwMzczXSAgWzw3OTJjZDZkMT5dIGRldmljZV9j
cmVhdGVfZ3JvdXBzX3ZhcmdzKzB4NzIvMHg5OQpbICAgIDMuNjcxMTM4XSAgWzw3OTJjZDcy
MD5dIGRldmljZV9jcmVhdGVfdmFyZ3MrMHgyOC8weDJlClsgICAgMy42NzE4MjBdICBbPDc5
MmNkNzRlPl0gZGV2aWNlX2NyZWF0ZSsweDI4LzB4MmEKWyAgICAzLjY3MjQ4Ml0gIFs8Nzky
YzVhMDE+XSBtaXNjX3JlZ2lzdGVyKzB4YTkvMHhmOQpbICAgIDMuNjczMTI2XSAgWzw3OTNi
YTU5OT5dIGZjX3Byb2JlKzB4ODIvMHhmOQpbICAgIDMuNjczNzA4XSAgWzw3OTEwMDBiYz5d
ID8gc3lzZnNfY3JlYXRlX2xpbmsrMHgyNC8weDJkClsgICAgMy42NzQ0NTFdICBbPDc5M2I4
Y2ExPl0gZm1jX3Byb2JlKzB4Zi8weDExClsgICAgMy42NzQ5ODldICBbPDc5MmNmM2JmPl0g
ZHJpdmVyX3Byb2JlX2RldmljZSsweDhkLzB4MTliClsgICAgMy42NzU3MjVdICBbPDc5MmNm
NTRjPl0gX19kcml2ZXJfYXR0YWNoKzB4NTMvMHg3MQpbICAgIDMuNjc2Mzk4XSAgWzw3OTJj
ZGU5YT5dIGJ1c19mb3JfZWFjaF9kZXYrMHg1Ny8weDYxClsgICAgMy42NzcwNTZdICBbPDc5
MmNlZmQ1Pl0gZHJpdmVyX2F0dGFjaCsweDE3LzB4MTkKWyAgICAzLjY3NzY4MF0gIFs8Nzky
Y2Y0Zjk+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDJjLzB4MmMKWyAgICAzLjY3ODM3N10gIFs8
NzkyY2VjYTI+XSBidXNfYWRkX2RyaXZlcisweGU3LzB4MWVhClsgICAgMy42Nzg5ODBdICBb
PDc5MmNmODBhPl0gZHJpdmVyX3JlZ2lzdGVyKzB4N2EvMHhkMwpbICAgIDMuNjc5NjU1XSAg
Wzw3OTJjZTM1OD5dID8gYnVzX3JlZ2lzdGVyKzB4MTUzLzB4MjIzClsgICAgMy42ODAzNDRd
ICBbPDc5M2I4ZDZmPl0gZm1jX2RyaXZlcl9yZWdpc3RlcisweDIzLzB4MmQKWyAgICAzLjY4
MDk5Ml0gIFs8NzkzYmE0Zjk+XSA/IGZjX3JlYWQrMHg2OC8weDY4ClsgICAgMy42ODE2MDld
ICBbPDc5M2JhNTA2Pl0gZmNfaW5pdCsweGQvMHhmClsgICAgMy42ODIxNTFdICBbPDc5MDAw
NDA2Pl0gZG9fb25lX2luaXRjYWxsKzB4N2YvMHgxMDYKWyAgICAzLjY4MjgwM10gIFs8Nzk3
MTE0M2Q+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDMuNjgzNTIwXSAg
Wzw3OTA0NDIyMz5dID8gcGFyc2VfYXJncysweDE3NS8weDIzMApbICAgIDMuNjg0MTU3XSAg
Wzw3OTQ0ZDZjMT5dID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4MjcvMHgzNQpb
ICAgIDMuNjg0OTQ4XSAgWzw3OTcxMWFkNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTMw
LzB4MWMyClsgICAgMy42ODU3MDZdICBbPDc5NzExNDJiPl0gPyBkb19lYXJseV9wYXJhbSsw
eDc4LzB4NzgKWyAgICAzLjY4NjM5OV0gIFs8Nzk0M2VjNTA+XSBrZXJuZWxfaW5pdCsweGIv
MHhiZQpbICAgIDMuNjg2OTY1XSAgWzw3OTQ0ZTRiYj5dIHJldF9mcm9tX2tlcm5lbF90aHJl
YWQrMHgxYi8weDMwClsgICAgMy42ODc3MjNdICBbPDc5NDNlYzQ1Pl0gPyByZXN0X2luaXQr
MHhjMS8weGMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1L2VhMWJiNzA2
NGZkNjk3MmVmMDBhOTNiYTg4MmEyZjM4NDUwYjI3M2UvZG1lc2cta3ZtLXdhaW1lYS0zNjQ3
LTIwMTMwODI2MDE0NjI5LTMuMTEuMC1yYzItMDAwMTQtZ2VhMWJiNzAtMTkxCgpCaXNlY3Rp
bmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3Rl
cHMpCltlNTYzNDFhZDM4MDExNDQ1NDExOWFjMDQzZTZkNzEwZGRiYmI3NzEwXSBzdGFnaW5n
OiBjb21lZGk6IGNvbnZlcnQgY2xhc3MgY29kZSB0byB1c2UgZGV2X2dyb3VwcwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctajctMDgyNTAzNTUvbmV4dDptYXN0ZXI6ZTU2MzQxYWQzODAxMTQ0NTQx
MTlhYzA0M2U2ZDcxMGRkYmJiNzcxMDpiaXNlY3QtbmV0CgoyMDEzLTA4LTI2LTAxOjQ3OjA3
IGU1NjM0MWFkMzgwMTE0NDU0MTE5YWMwNDNlNmQ3MTBkZGJiYjc3MTAgY29tcGlsaW5nCjI4
MSByZWFsICAyMTY2IHVzZXIgIDIwOCBzeXMgIDg0NS4xMyUgY3B1IAlpMzg2LXJhbmRjb25m
aWctajctMDgyNTAzNTUKCjIwMTMtMDgtMjYtMDE6NTI6MDggZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMS4wLXJjMi0wMDAwNy1nZTU2MzQxYS4uLi4uLi4uLi4uLi4uLi4uLi4uCTEJMy4u
Li4uLi4uLi4uLi4JNC4uLi4uLi4uLi4uLi4uLi4uCTUuCTYJNy4uLi4uLi4uLgk4Li4uLi4u
CTkJMTAuCTExLi4uLi4uLi4uLi4JMTIuLi4uLi4uLi4JMTMuLi4uLi4uLi4uLi4uLi4uLi4u
CTE0Li4uLi4uCTE1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
CTE3Li4JMTguLi4uCTE5Li4uLi4uLi4uLi4uLi4uLi4uLgkyMC4uLgkyMS4JMjIuCTIzLi4u
LgkyNS4uLgkyNi4uLi4uCTI3Li4JMjguLi4uLi4uLi4uLi4uLi4JMjkJMzAuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uCTMxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzMi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMzMJMzQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTM1Li4JMzYuLi4uLi4uLi4uLi4uLi4uLi4uCTM3Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTM4Li4uLi4JMzkuLi4uLi4uLi4uLi4uCTQwLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JNDEuLgk0Mgk0NAk0NS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4J
NDYuLi4uCTQ3Li4uLi4uLi4JNDguCTUwLi4uLi4uLi4uLi4uLi4uLi4uCTUxLgk1Mi4JNTMu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUg
MhtbMG0KLi4uLi4uCTU0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uCTU1IFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKW2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3
OTZkNzhmMTYwYWY2MDkyMGRdIGtvYmplY3Q6IGRlbGF5ZWQga29iamVjdCByZWxlYXNlOiBo
ZWxwIGZpbmQgYnVnZ3kgZHJpdmVycwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUv
bmV4dDptYXN0ZXI6YzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZDpi
aXNlY3QtbmV0CgoyMDEzLTA4LTI2LTA5OjQxOjQ3IGM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3
OTZkNzhmMTYwYWY2MDkyMGQgY29tcGlsaW5nCjMzMyByZWFsICAyMDc0IHVzZXIgIDIxMSBz
eXMgIDY4NS4xNiUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUKCjIwMTMtMDgt
MjYtMDk6NDc6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMi0wMDAxMC1nYzgx
N2E2Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMy43OTc4MzFdIGZtY193cml0ZV9l
ZXByb20gZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogZm1jX3dyaXRlX2VlcHJvbTog
bm8gYnVzaWQgcGFzc2VkLCByZWZ1c2luZyBhbGwgY2FyZHMKWyAgICAzLjc5OTM4OV0gZm1j
IGZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDE6IERyaXZlciBoYXMgbm8gSUQ6IG1hdGNo
ZXMgYWxsClsgICAgMy44MDA1MDFdIEJVRzogc2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3
YXBwZXIvMC8xLzB4MTAwMDAwMDIKWyAgICAzLjgwMTUwNl0gNCBsb2NrcyBoZWxkIGJ5IHN3
YXBwZXIvMC8xOgpbICAgIDMuODAyMTgwXSAgIzA6ICAoJl9fbG9ja2RlcF9ub192YWxpZGF0
ZV9fKXsuLi4uLi59LCBhdDogWzw3OTJjZjUxZj5dIF9fZHJpdmVyX2F0dGFjaCsweDI2LzB4
NzEKWyAgICAzLjgwMzY5Nl0gICMxOiAgKCZfX2xvY2tkZXBfbm9fdmFsaWRhdGVfXyl7Li4u
Li4ufSwgYXQ6IFs8NzkyY2Y1M2E+XSBfX2RyaXZlcl9hdHRhY2grMHg0MS8weDcxClsgICAg
My44MDUyNDBdICAjMjogIChmY19sb2NrKXsuLi4uLi59LCBhdDogWzw3OTNiYTU5MT5dIGZj
X3Byb2JlKzB4N2EvMHhmOQpbICAgIDMuODA2MzQ3XSAgIzM6ICAobWlzY19tdHgpey4uLi4u
Ln0sIGF0OiBbPDc5MmM1OTc3Pl0gbWlzY19yZWdpc3RlcisweDFmLzB4ZjkKWyAgICAzLjgw
NzUxMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMy44MDgwMjVdIENQVTogMSBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjcg
IzE5MwpbICAgIDMuODA5MTg1XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAgMy44MTAwNTBdICAwMDAwMDAwMCAwMDAwMDAwMCA3ODA3
M2MxMCA3OTQ0OGRlMCA3ODA3ODAwMCA3ODA3M2MyYyA3OTQ0NGM3OCA3OTVmZjA5MApbICAg
IDMuODExMjc5XSAgNzgwNzgyZTAgMDAwMDAwMDEgMTAwMDAwMDIgNzgwNzIwMDAgNzgwNzNj
YjQgNzk0NGM0ZTcgMDAwMDAwMDAgMDAwMDAwNmEKWyAgICAzLjgxMjUxM10gIDAwMDAwMDAx
IDc5NzZkMDgwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDBmIDAwMDAwMDAwIDAwMDAwMDAx
IDc4MDcyMDAwClsgICAgMy44MTM3MTNdIENhbGwgVHJhY2U6ClsgICAgMy44MTQxMzBdICBb
PDc5NDQ4ZGUwPl0gZHVtcF9zdGFjaysweDRiLzB4NjYKWyAgICAzLjgxNDcxNl0gIFs8Nzk0
NDRjNzg+XSBfX3NjaGVkdWxlX2J1ZysweDU2LzB4NjgKWyAgICAzLjgxNTQzMl0gIFs8Nzk0
NGM0ZTc+XSBfX3NjaGVkdWxlKzB4NWUvMHg1N2UKWyAgICAzLjgxNjExMV0gIFs8NzkwNjJi
NDk+XSA/IGxvY2tfcmVsZWFzZSsweDE1ZC8weDFhZgpbICAgIDMuODE2Nzc0XSAgWzw3OTA2
MmI0OT5dID8gbG9ja19yZWxlYXNlKzB4MTVkLzB4MWFmClsgICAgMy44MTc1MDZdICBbPDc5
MDQwMDE0Pl0gPyBsaW5rX3B3cSsweDJkLzB4NWMKWyAgICAzLjgxODE0M10gIFs8NzkwNGQ4
ZGY+XSBfX2NvbmRfcmVzY2hlZCsweDE2LzB4MjYKWyAgICAzLjgxODg0M10gIFs8Nzk0NGNi
ZjA+XSBfY29uZF9yZXNjaGVkKzB4MTEvMHgxOApbICAgIDMuODE5NDk2XSAgWzw3OTQ0Y2Mx
ZD5dIF9fd2FpdF9mb3JfY29tbW9uKzB4MjYvMHhlMgpbICAgIDMuODIwMjExXSAgWzw3OTQ0
YTJkND5dID8gY29uc29sZV9jb25kaXRpb25hbF9zY2hlZHVsZSsweDI0LzB4MjQKWyAgICAz
LjgyMTA3N10gIFs8NzkwNGVmZjE+XSA/IHRyeV90b193YWtlX3VwKzB4MTY3LzB4MTcxClsg
ICAgMy44MjE3NzJdICBbPDc5NDRjY2YzPl0gd2FpdF9mb3JfY29tcGxldGlvbisweDFhLzB4
MWMKWyAgICAzLjgyMjUzMV0gIFs8NzkyZDIzZTc+XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsw
eGQxLzB4ZWQKWyAgICAzLjgyMzM1Ml0gIFs8NzkwZjAxMDE+XSA/IGRxdW90X3NldF9kcWlu
Zm8rMHg3YS8weGI1ClsgICAgMy44MjQxMTddICBbPDc5MmNkMWUwPl0gZGV2aWNlX2FkZCsw
eDE5OC8weDU2NgpbICAgIDMuODI0NzQ0XSAgWzw3OTA0NWJkZT5dID8gX19pbml0X3dhaXRx
dWV1ZV9oZWFkKzB4MmYvMHgzZQpbICAgIDMuODI1NTk4XSAgWzw3OTAwMzEzNj5dID8gZml4
dXBfaXJxcysweGIxLzB4MWUzClsgICAgMy44MjYzNTNdICBbPDc5MmNkNWMwPl0gZGV2aWNl
X3JlZ2lzdGVyKzB4MTIvMHgxNQpbICAgIDMuODI3MDY1XSAgWzw3OTJjZDZkMT5dIGRldmlj
ZV9jcmVhdGVfZ3JvdXBzX3ZhcmdzKzB4NzIvMHg5OQpbICAgIDMuODI3ODMzXSAgWzw3OTJj
ZDcyMD5dIGRldmljZV9jcmVhdGVfdmFyZ3MrMHgyOC8weDJlClsgICAgMy44Mjg2MjFdICBb
PDc5MmNkNzRlPl0gZGV2aWNlX2NyZWF0ZSsweDI4LzB4MmEKWyAgICAzLjgyOTM2NV0gIFs8
NzkyYzVhMDE+XSBtaXNjX3JlZ2lzdGVyKzB4YTkvMHhmOQpbICAgIDMuODMwMDY2XSAgWzw3
OTNiYTU5OT5dIGZjX3Byb2JlKzB4ODIvMHhmOQpbICAgIDMuODMwNjI3XSAgWzw3OTEwMDBi
Yz5dID8gc3lzZnNfY3JlYXRlX2xpbmsrMHgyNC8weDJkClsgICAgMy44MzEzODZdICBbPDc5
M2I4Y2ExPl0gZm1jX3Byb2JlKzB4Zi8weDExClsgICAgMy44MzE5ODRdICBbPDc5MmNmM2Jm
Pl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDhkLzB4MTliClsgICAgMy44MzI4MTRdICBbPDc5
MmNmNTRjPl0gX19kcml2ZXJfYXR0YWNoKzB4NTMvMHg3MQpbICAgIDMuODMzNTIzXSAgWzw3
OTJjZGU5YT5dIGJ1c19mb3JfZWFjaF9kZXYrMHg1Ny8weDYxClsgICAgMy44MzQyNjFdICBb
PDc5MmNlZmQ1Pl0gZHJpdmVyX2F0dGFjaCsweDE3LzB4MTkKWyAgICAzLjgzNDg4NF0gIFs8
NzkyY2Y0Zjk+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDJjLzB4MmMKWyAgICAzLjgzNTYyN10g
IFs8NzkyY2VjYTI+XSBidXNfYWRkX2RyaXZlcisweGU3LzB4MWVhClsgICAgMy44MzYzOTdd
ICBbPDc5MmNmODBhPl0gZHJpdmVyX3JlZ2lzdGVyKzB4N2EvMHhkMwpbICAgIDMuODM3MDcx
XSAgWzw3OTJjZTM1OD5dID8gYnVzX3JlZ2lzdGVyKzB4MTUzLzB4MjIzClsgICAgMy44Mzc3
OThdICBbPDc5M2I4ZDZmPl0gZm1jX2RyaXZlcl9yZWdpc3RlcisweDIzLzB4MmQKWyAgICAz
LjgzODU2MF0gIFs8NzkzYmE0Zjk+XSA/IGZjX3JlYWQrMHg2OC8weDY4ClsgICAgMy44Mzkx
OThdICBbPDc5M2JhNTA2Pl0gZmNfaW5pdCsweGQvMHhmClsgICAgMy44Mzk4MDZdICBbPDc5
MDAwNDA2Pl0gZG9fb25lX2luaXRjYWxsKzB4N2YvMHgxMDYKWyAgICAzLjg0MDUzMV0gIFs8
Nzk3MTE0M2Q+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDMuODQxMjgx
XSAgWzw3OTA0NDIyMz5dID8gcGFyc2VfYXJncysweDE3NS8weDIzMApbICAgIDMuODQyMDQy
XSAgWzw3OTQ0ZDZjMT5dID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4MjcvMHgz
NQpbICAgIDMuODQyODE3XSAgWzw3OTcxMWFkNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
MTMwLzB4MWMyClsgICAgMy44NDM2MTNdICBbPDc5NzExNDJiPl0gPyBkb19lYXJseV9wYXJh
bSsweDc4LzB4NzgKWyAgICAzLjg0NDMxNl0gIFs8Nzk0M2VjNTA+XSBrZXJuZWxfaW5pdCsw
eGIvMHhiZQpbICAgIDMuODQ0OTA0XSAgWzw3OTQ0ZTRiYj5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgxYi8weDMwClsgICAgMy44NDU3MDJdICBbPDc5NDNlYzQ1Pl0gPyByZXN0X2lu
aXQrMHhjMS8weGMxClsgICAgMy44NDY1MjhdIGZtY19jaGFyZGV2IGZha2UtZGVzaWduLWZv
ci10ZXN0aW5nLWYwMDE6IENyZWF0ZWQgbWlzYyBkZXZpY2UgImZha2UtZGVzaWduLWZvci10
ZXN0aW5nLWYwMDEiClsgICAgMy44NDg0ODZdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBm
YW1pbHkgMTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvYzgxN2E2N2Vj
YmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZC9kbWVzZy1rdm0td2FpbWVhLTg5MDEt
MjAxMzA4MjYxMDE5MDctMy4xMS4wLXJjMi0wMDAxMC1nYzgxN2E2Ny0xOTMKCkJpc2VjdGlu
ZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVw
KQpbN2M0MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YV0gY2hhcjogdGls
ZS1zcm9tOiBmaXggYnVpbGQgZXJyb3IKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1
L25leHQ6bWFzdGVyOjdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEzNWE6
YmlzZWN0LW5ldAoKMjAxMy0wOC0yNi0xMDoyMDowMyA3YzQyNzIxZmUwYzU4YTg0ODg0OWI0
M2ZmNTU4Y2YyZmI4NmFhMzVhIGNvbXBpbGluZwozMTIgcmVhbCAgMjE1MiB1c2VyICAyMTEg
c3lzICA3NTcuOTAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1CgoyMDEzLTA4
LTI2LTEwOjI1OjQxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAwMDktZzdj
NDI3MjEuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTEJMi4JMy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNC4uCTUu
Li4uLi4uLi4JNi4uCTcuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uCTgJOS4uLi4uCTEwLi4uLi4uLi4uLi4JMTEuLi4uLi4uLi4uLi4uLi4uLgkx
Mi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxMy4uLi4uLi4uLi4uLi4uLgkxNC4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMTUuLi4JMTYuLi4JMTcuLi4uLgkxOC4uLi4uLi4uLi4JMTkuLi4u
Li4uLi4uLi4uLi4JMjAuLi4JMjIuLi4uLgkyMy4uCTI0CTI1CTI2Li4uLi4uLi4uLgkyNy4u
LgkyOAkyOS4uLi4JMzAuLi4JMzEuCTMyLi4uLi4uLi4JMzMuLgkzNC4uLi4uLi4uLi4uCTM1
Li4uLi4JMzYJMzguCTM5Li4JNDAJNDEuCTQyCTQzCTQ1CTQ2Li4JNDguCTQ5Li4uLi4uCTUw
Li4uLi4uLi4uLgk1MQk1Mi4uLi4uLi4uLgk1My4uCTU0CTU1IFNVQ0NFU1MKCmM4MTdhNjdl
Y2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQgaXMgdGhlIGZpcnN0IGJhZCBjb21t
aXQKY29tbWl0IGM4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQKQXV0
aG9yOiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtLmxpbnV4Lm9yZy51az4KRGF0ZTog
ICBUaHUgSnVuIDI3IDE1OjA2OjE0IDIwMTMgKzAxMDAKCiAgICBrb2JqZWN0OiBkZWxheWVk
IGtvYmplY3QgcmVsZWFzZTogaGVscCBmaW5kIGJ1Z2d5IGRyaXZlcnMKICAgIAogICAgSW1w
bGVtZW50IGRlYnVnZ2luZyBmb3Iga29iamVjdCByZWxlYXNlIGZ1bmN0aW9ucy4gIGtvYmpl
Y3RzIGFyZQogICAgcmVmZXJlbmNlIGNvdW50ZWQsIHNvIHRoZSBkcm9wIG9mIHRoZSBsYXN0
IHJlZmVyZW5jZSB0byB0aGVtIGlzIG5vdAogICAgcHJlZGljdGFibGUuIEhvd2V2ZXIsIHRo
ZSBjb21tb24gY2FzZSBpcyBmb3IgdGhlIGxhc3QgcmVmZXJlbmNlIHRvIGJlCiAgICB0aGUg
a29iamVjdCdzIHJlbW92YWwgZnJvbSBhIHN1YnN5c3RlbSwgd2hpY2ggcmVzdWx0cyBpbiB0
aGUgcmVsZWFzZQogICAgZnVuY3Rpb24gYmVpbmcgaW1tZWRpYXRlbHkgY2FsbGVkLgogICAg
CiAgICBUaGlzIGNhbiBoaWRlIHN1YnRsZSBidWdzLCB3aGljaCBjYW4gb2NjdXIgd2hlbiBh
bm90aGVyIHRocmVhZCBob2xkcyBhCiAgICByZWZlcmVuY2UgdG8gdGhlIGtvYmplY3QgYXQg
dGhlIHNhbWUgdGltZSB0aGF0IGEga29iamVjdCBpcyByZW1vdmVkLgogICAgVGhpcyByZXN1
bHRzIGluIHRoZSByZWxlYXNlIG1ldGhvZCBiZWluZyBkZWxheWVkLgogICAgCiAgICBJbiBv
cmRlciB0byBtYWtlIHRoZXNlIGtpbmRzIG9mIHByb2JsZW1zIG1vcmUgdmlzaWJsZSwgdGhl
IGZvbGxvd2luZwogICAgcGF0Y2ggaW1wbGVtZW50cyBhIGRlbGF5ZWQgcmVsZWFzZTsgdGhp
cyBoYXMgdGhlIGVmZmVjdCB0aGF0IHRoZQogICAgcmVsZWFzZSBmdW5jdGlvbiB3aWxsIGJl
IG91dCBvZiBvcmRlciB3aXRoIHJlc3BlY3QgdG8gdGhlIHJlbW92YWwgb2YKICAgIHRoZSBr
b2JqZWN0IGluIHRoZSBzYW1lIG1hbm5lciB0aGF0IGl0IHdvdWxkIGJlIGlmIGEgcmVmZXJl
bmNlIHdhcwogICAgYmVpbmcgaGVsZC4KICAgIAogICAgVGhpcyBwcm92aWRlcyB1cyB3aXRo
IGFuIGVhc3kgd2F5IHRvIGFsbG93IGRyaXZlciB3cml0ZXJzIHRvIGRlYnVnCiAgICB0aGVp
ciBkcml2ZXJzIGFuZCBmaXggb3RoZXJ3aXNlIGhpZGRlbiBwcm9ibGVtcy4KICAgIAogICAg
U2lnbmVkLW9mZi1ieTogUnVzc2VsbCBLaW5nIDxybWsra2VybmVsQGFybS5saW51eC5vcmcu
dWs+CiAgICBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51
eGZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAwNDAwMDAgZjZjMjNlZmExMDJmYzJjMmVhZDVj
ODZiZGI2NWFhNzA3MTliMWFiOSAwNDk4NTlmYTdhM2E5NTM4OTIxMjc0NjdiYWJiZjAyZjY2
YTY5Yjc2IE0JaW5jbHVkZQo6MDQwMDAwIDA0MDAwMCBhNDFkMjA2NjlmMGY2MjRkMmNlOWNh
N2U2YTVmOTZlNGY5MTQzMmUwIGJmMjE2ODE5NGY4MjkxMWNmMmUxODkyZDgyZjBjMTNkMDBj
NzcyYWUgTQlsaWIKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvbmV4dDptYXN0ZXI6N2M0
MjcyMWZlMGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YTpiaXNlY3QtbmV0CgoyMDEz
LTA4LTI2LTEzOjU3OjQ0IDdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEz
NWEgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvN2M0MjcyMWZl
MGM1OGE4NDg4NDliNDNmZjU1OGNmMmZiODZhYTM1YS92bWxpbnV6LTMuMTEuMC1yYzItMDAw
MDktZzdjNDI3MjEKCjIwMTMtMDgtMjYtMTM6NTc6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JMS4JMi4uLgkzCTUuCTYJNy4JOQkxMAkxMi4JMTQJMTUJMTkJMjAJMjQJMjYJMzUuLgkz
OS4uLgk0MC4uCTQxLgk0My4JNDUuLgk0Nwk0OQk1Mwk1NAk1Ngk1OC4JNTkJNjAJNjIJNjMJ
NjQuLgk2NQk2OAk3MC4JNzIJNzQJNzYJODAJODgJOTMuCTk0CTk2CTk4Lgk5OQkxMDIJMTAz
CTEwNAkxMDcJMTEwCTExMy4uLgkxMTUuCTEyMAkxMjMJMTI3CTEzMQkxMzIJMTM1CTEzNwkx
NDAuCTE0MgkxNDMJMTQ0CTE0NS4uCTE0Ny4uLgkxNDgJMTUxLgkxNTMuCTE1NAkxNTUJMTU2
Li4uLgkxNTcuLi4uLi4uLi4uLi4uCTE1OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA3G1swbQouLgkxNjEJMTYzLi4JMTY0LgkxNjUg
U1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1qNy0wODI1MDM1NS9uZXh0Om1hc3RlcjoyNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2
OThhYzg5ZWJmMmYwNjcwOmJpc2VjdC1uZXQKIFRFU1QgRkFJTFVSRQptb2Rwcm9iZTogRkFU
QUw6IENvdWxkIG5vdCBsb2FkIC9saWIvbW9kdWxlcy8zLjExLjAtcmM2LW5leHQtMjAxMzA4
MjItMDcwNzAtZzI0NWYwODYvbW9kdWxlcy5kZXA6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3Rv
cnkKWyAgICA0Ljk5MzcxOV0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgICA0Ljk5NDAx
NF0gQlVHIGttYWxsb2MtNTEyIChOb3QgdGFpbnRlZCk6IFBvaXNvbiBvdmVyd3JpdHRlbgpb
ICAgIDQuOTk0MDE0XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDQuOTk0MDE0XSAK
WyAgICA0Ljk5NDAxNF0gRGlzYWJsaW5nIGxvY2sgZGVidWdnaW5nIGR1ZSB0byBrZXJuZWwg
dGFpbnQKWyAgICA0Ljk5NDAxNF0gSU5GTzogMHg3ODA5NGMwMC0weDc4MDk0YzAzLiBGaXJz
dCBieXRlIDB4NjggaW5zdGVhZCBvZiAweDZiCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3
LTA4MjUwMzU1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1l
c2cta3ZtLWJlbnMtMzE3NC0yMDEzMDgyNTA2MDkyMi0zLjExLjAtcmM2LW5leHQtMjAxMzA4
MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1
NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1i
ZW5zLTMxNzQtMjAxMzA4MjUwODI5NTMtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcw
LWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4
Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tYmVucy0zMjc4
LTIwMTMwODI1MDgxNTIzLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4
Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1LzI0NWYwODY5OWQ1MzIw
ZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWJlbnMtNDA0MC0yMDEzMDgy
NTA2MDIyOS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1iZW5zLTQwNDAtMjAxMzA4MjUwODM4NDAt
My4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4
OWViZjJmMDY3MC9kbWVzZy1rdm0tYmVucy00MTk4LTIwMTMwODI1MDgxNjE4LTMuMTEuMC1y
YzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo3LTA4MjUwMzU1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2
NzAvZG1lc2cta3ZtLWJlbnMtNDE5OC0yMDEzMDgyNTA4MTg1NC0zLjExLjAtcmM2LW5leHQt
MjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0w
ODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNn
LWt2bS1pbm4tMTE2OTAtMjAxMzA4MjUwNjE1NTYtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIy
LTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUv
MjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tamFr
ZXRvd24tNTQ4MC0yMDEzMDgyNTA1NTM0Ni0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcw
NzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1uaG00LTE1
MjkyLTIwMTMwODI1MDAzNzM2LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1
ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1LzI0NWYwODY5OWQ1
MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLW5obTQtNDcxNy0yMDEz
MDgyNTAwMjc1My0zLjEwLjAtcmMxLTAzMDQzLWdhZjRlZDA3LTQ2Mwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5
ZWJmMmYwNjcwL2RtZXNnLWt2bS1uaG00LTYxNTItMjAxMzA4MjUwMDQwNDUtMy4xMS4wLXJj
Mi0wMDE2OC1nOTc2ZjM3NS0zNjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAz
NTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0t
d2FpbWVhLTI3MjEyLTIwMTMwODI1MDYwNTA5LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0w
NzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1LzI0
NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1l
YS0yNzIxMi0yMDEzMDgyNTA4MzEwNi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAt
ZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2
OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtMjcy
MTItMjAxMzA4MjUwODMzMTAtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVm
MDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUz
MjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTQ3NjAtMjAx
MzA4MjUwNjA2MzMtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIx
MDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTcwOTUtMjAxMzA4MjUw
ODM5NTQtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4
Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTcwOTYtMjAxMzA4MjUwNjA5Mzkt
My4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4
OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTczMzktMjAxMzA4MjUwODM1MzMtMy4xMS4w
LXJjMS0wMDA1Mi1nMDUwYTE5NS0xNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1
MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2
bS13YWltZWEtODg1NS0yMDEzMDgyNTA1NTgxNC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjIt
MDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8y
NDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWlt
ZWEtODg1NS0yMDEzMDgyNTA4MjI1NS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAt
ZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2
OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtODg3
My0yMDEzMDgyNTA4MTYzNS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYw
ODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMy
MGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtODg5OS0yMDEz
MDgyNTA4MzUyMi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEw
NzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtOTMzMC0yMDEzMDgyNTA4
MzEzMS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2
OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtOTMzMS0yMDEzMDgyNTA4MzMzMS0z
LjExLjAtcmMyLTAwMTY4LWc5NzZmMzc1LTM2MAoKW2RldGFjaGVkIEhFQUQgNzU0YWQ4ZF0g
UmV2ZXJ0ICJrb2JqZWN0OiBkZWxheWVkIGtvYmplY3QgcmVsZWFzZTogaGVscCBmaW5kIGJ1
Z2d5IGRyaXZlcnMiCiAzIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNDIgZGVs
ZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctajctMDgyNTAzNTUvbmV4dDptYXN0ZXI6NzU0YWQ4ZDRmZTUwNGM2OGQyMDk3NDlm
NWM0OWI1NzhkNjhhMDEwNjpiaXNlY3QtbmV0CgoyMDEzLTA4LTI2LTE3OjM2OjU4IDc1NGFk
OGQ0ZmU1MDRjNjhkMjA5NzQ5ZjVjNDliNTc4ZDY4YTAxMDYgY29tcGlsaW5nCgoyMDEzLTA4
LTI2LTE3OjUwOjAzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtbmV4dC0yMDEz
MDgyMi0wNzA3MS1nNzU0YWQ4ZC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMS4JMi4J
Mwk0Li4JNQk2Lgk3Lgk4Lgk5LgkxMC4JMTEJMTIJMTMuLi4uLgkxNgkxNwkyMAkyMQkyMgky
NAkyNQkyNwkzMgkzNC4uCTM2CTM3CTM4CTM5CTQzCTQ5Li4uCTEwNgkxNDcJMTUwCTE1Nwkx
NjEuLi4JMTYzLi4uLi4uCTE2NC4uLi4uLi4uLi4uLgkxNjUgU1VDQ0VTUwoKCj09PT09PT09
PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS9uZXh0Om1hc3Rl
cjpkOGRmYWQzODc2ZTQzODY2NjZiNzU5ZGEzYzgzM2Q2MmZiOGIyMjY3OmJpc2VjdC1uZXQK
CjIwMTMtMDgtMjYtMTg6NDI6NDMgZDhkZmFkMzg3NmU0Mzg2NjY2Yjc1OWRhM2M4MzNkNjJm
YjhiMjI2NyBjb21waWxpbmcKCjIwMTMtMDgtMjYtMTg6NTE6MDQgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMS4wLXJjNy4uLi4uLi4uLi4JMS4uLi4JMi4JNC4uCTUJNgk3Lgk4LgkxMC4u
Li4uLi4uLi4uLi4uCTExCTE0CTE4CTIwLi4uLgkyMQkyMwkyNS4uLi4uCTI3LgkyOC4JMjkJ
MzEuLi4uCTMzLi4JMzQJMzUuLgkzOS4uLi4uLgk0MC4uLi4JNDIJNDMJNDQuLi4JNDUJNDcu
Li4JNDkuLi4JNTAuLi4uLi4uLi4uLi4uCTUyLgk1Mwk1NAk1NS4uLgk1Ngk1Ny4uLi4JNTgu
CTU5CTYwCTYxLgk2Mgk2My4JNjQuCTY1Li4uCTY2Li4JNjcuLi4uLgk3MC4JNzEuLi4uLi4u
Li4uLi4uLgk3Mi4uLi4uLi4JNzMJNzUuLi4uCTc2CTc3Li4JNzguCTc5Lgk4MC4uLi4uLi4u
Lgk4MS4uLi4JODIuLgk4Mwk4NAk4NS4uLi4uLi4JODYJOTMJOTQJOTcJMTA1CTEwNgkxMTIJ
MTIwCTEyMQkxMjgJMTMzCTE0MQkxNDkJMTUyCTE1MwkxNTUuLgkxNTYuCTE1Ny4JMTU4CTE1
OS4uCTE2MS4uLi4uLi4uCTE2Mi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkxNjMuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
G1sxOzM1bWFkZF90b19ydW5fcXVldWUgMhtbMG0KLi4uLi4uLi4uLi4uLi4uLi4uLgkxNjQu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUg
MRtbMG0KLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uCTE2NSBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZl
dGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qNy0wODI1MDM1NS9uZXh0Om1hc3RlcjoyNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwOmJpc2VjdC1uZXQKIFRFU1QgRkFJTFVSRQptb2Rwcm9iZTog
RkFUQUw6IENvdWxkIG5vdCBsb2FkIC9saWIvbW9kdWxlcy8zLjExLjAtcmM2LW5leHQtMjAx
MzA4MjItMDcwNzAtZzI0NWYwODYvbW9kdWxlcy5kZXA6IE5vIHN1Y2ggZmlsZSBvciBkaXJl
Y3RvcnkKWyAgICA0Ljk5MzcxOV0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgICA0Ljk5
NDAxNF0gQlVHIGttYWxsb2MtNTEyIChOb3QgdGFpbnRlZCk6IFBvaXNvbiBvdmVyd3JpdHRl
bgpbICAgIDQuOTk0MDE0XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDQuOTk0MDE0
XSAKWyAgICA0Ljk5NDAxNF0gRGlzYWJsaW5nIGxvY2sgZGVidWdnaW5nIGR1ZSB0byBrZXJu
ZWwgdGFpbnQKWyAgICA0Ljk5NDAxNF0gSU5GTzogMHg3ODA5NGMwMC0weDc4MDk0YzAzLiBG
aXJzdCBieXRlIDB4NjggaW5zdGVhZCBvZiAweDZiCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo3LTA4MjUwMzU1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAv
ZG1lc2cta3ZtLWJlbnMtMzE3NC0yMDEzMDgyNTA2MDkyMi0zLjExLjAtcmM2LW5leHQtMjAx
MzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1
MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2
bS1iZW5zLTMxNzQtMjAxMzA4MjUwODI5NTMtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3
MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1
ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tYmVucy0z
Mjc4LTIwMTMwODI1MDgxNTIzLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1
ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1LzI0NWYwODY5OWQ1
MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWJlbnMtNDA0MC0yMDEz
MDgyNTA2MDIyOS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEw
NzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1iZW5zLTQwNDAtMjAxMzA4MjUwODM4
NDAtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4
YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tYmVucy00MTk4LTIwMTMwODI1MDgxNjE4LTMuMTEu
MC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo3LTA4MjUwMzU1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYy
ZjA2NzAvZG1lc2cta3ZtLWJlbnMtNDE5OC0yMDEzMDgyNTA4MTg1NC0zLjExLjAtcmM2LW5l
eHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
Ny0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2Rt
ZXNnLWt2bS1pbm4tMTE2OTAtMjAxMzA4MjUwNjE1NTYtMy4xMS4wLXJjNi1uZXh0LTIwMTMw
ODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAz
NTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0t
amFrZXRvd24tNTQ4MC0yMDEzMDgyNTA1NTM0Ni0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjIt
MDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8y
NDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1uaG00
LTE1MjkyLTIwMTMwODI1MDAzNzM2LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1n
MjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1LzI0NWYwODY5
OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLW5obTQtNDcxNy0y
MDEzMDgyNTAwMjc1My0zLjEwLjAtcmMxLTAzMDQzLWdhZjRlZDA3LTQ2Mwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThh
Yzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1uaG00LTYxNTItMjAxMzA4MjUwMDQwNDUtMy4xMS4w
LXJjMi0wMDE2OC1nOTc2ZjM3NS0zNjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgy
NTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1r
dm0td2FpbWVhLTI3MjEyLTIwMTMwODI1MDYwNTA5LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgy
Mi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTA4MjUwMzU1
LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdh
aW1lYS0yNzIxMi0yMDEzMDgyNTA4MzEwNi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcw
NzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEt
MjcyMTItMjAxMzA4MjUwODMzMTAtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcy
NDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5
ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTQ3NjAt
MjAxMzA4MjUwNjA2MzMtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2
LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBm
MDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTcwOTUtMjAxMzA4
MjUwODM5NTQtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcw
ZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTcwOTYtMjAxMzA4MjUwNjA5
MzktMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajctMDgyNTAzNTUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4
YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTczMzktMjAxMzA4MjUwODM1MzMtMy4x
MS4wLXJjMS0wMDA1Mi1nMDUwYTE5NS0xNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0w
ODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNn
LWt2bS13YWltZWEtODg1NS0yMDEzMDgyNTA1NTgxNC0zLjExLjAtcmM2LW5leHQtMjAxMzA4
MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1
NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13
YWltZWEtODg1NS0yMDEzMDgyNTA4MjI1NS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcw
NzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEt
ODg3My0yMDEzMDgyNTA4MTYzNS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0
NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlk
NTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtODg5OS0y
MDEzMDgyNTA4MzUyMi0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYt
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYw
MjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtOTMzMC0yMDEzMDgy
NTA4MzEzMS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0wODI1MDM1NS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtOTMzMS0yMDEzMDgyNTA4MzMz
MS0zLjExLjAtcmMyLTAwMTY4LWc5NzZmMzc1LTM2MAoK

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc6-next-20130822-07070-g245f086"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0-rc6 Kernel Configuration
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
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_INTEL_MID=y
CONFIG_X86_MDFLD=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
# CONFIG_X86_32_IRIS is not set
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
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
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
CONFIG_MVIAC3_2=y
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
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
CONFIG_TOSHIBA=m
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
CONFIG_HIGHMEM=y
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_CMA is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
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
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
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
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=m
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_BINFMT_SCRIPT is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=m
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set
# CONFIG_BLOCKCONSOLE is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
CONFIG_VMWARE_VMCI=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=m
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
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_HIGHBANK is not set
CONFIG_SATA_MV=m
# CONFIG_SATA_NV is not set
CONFIG_SATA_PROMISE=m
CONFIG_SATA_RCAR=m
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
# CONFIG_PATA_ARASAN_CF is not set
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=m
CONFIG_PATA_CS5536=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_IT821X=m
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_RADISYS=m
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
# CONFIG_PATA_SIS is not set
CONFIG_PATA_TOSHIBA=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_NS87410=m
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_RZ1000=m

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_ISCSI_TARGET=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=m
CONFIG_TOUCHSCREEN_DA9052=m
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_INTEL_MID=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_STMPE=m
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
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=y
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
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MRST_MAX3110=m
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
CONFIG_R3964=y
CONFIG_APPLICOM=m
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=m
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=y
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_GPIO=m
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m
CONFIG_SPI_DW_MID_DMA=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_GPIO=m

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_MSIC=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=m
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
CONFIG_BATTERY_DA9052=m
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_BATTERY_INTEL_MID=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_LP8788=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

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
CONFIG_INTEL_POWERCLAMP=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
CONFIG_INTEL_SCU_WATCHDOG=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=m
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_RDC321X_WDT is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=m
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=m
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_MEDFIELD is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=m
CONFIG_FB_I810=m
# CONFIG_FB_I810_GTF is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=m
# CONFIG_FB_TMIO is not set
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=m
CONFIG_LCD_ILI9320=m
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=m
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=m
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_AAT2870=m
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=m
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_HCD_TEST_MODE=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
CONFIG_USB_SERIAL_VISOR=m
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=m
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_F81232=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_XSENS_MT is not set
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=m
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=m
CONFIG_AM335X_PHY_USB=m
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=m
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_FOTG210_UDC=m
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
CONFIG_USB_AMD5536UDC=m
CONFIG_USB_NET2272=m
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_U_RNDIS=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_GADGET_TARGET=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
# CONFIG_USB_G_HID is not set
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=m
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=m
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD76X is not set
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
# CONFIG_EDAC_I82860 is not set
CONFIG_EDAC_R82600=m
CONFIG_EDAC_I5000=m
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_PCMCIA_DRIVERS=y
# CONFIG_COMEDI_CB_DAS16_CS is not set
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
# CONFIG_COMEDI_NI_LABPC_CS is not set
# CONFIG_COMEDI_NI_MIO_CS is not set
# CONFIG_COMEDI_QUATECH_DAQP_CS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_DAS08=m
CONFIG_RTS5139=m
CONFIG_RTS5139_DEBUG=y
CONFIG_TRANZPORT=m
CONFIG_IDE_PHISON=m
# CONFIG_USB_SERIAL_QUATECH2 is not set
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
CONFIG_ADIS16220=m
# CONFIG_ADIS16240 is not set
CONFIG_LIS3L02DQ=m
CONFIG_SCA3000=m

#
# Analog to digital converters
#
CONFIG_AD7291=m
# CONFIG_AD7606 is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7780 is not set
CONFIG_AD7816=m
CONFIG_AD7192=m
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_SPI=m
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
# CONFIG_AD9832 is not set
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
# CONFIG_ADE7754 is not set
# CONFIG_ADE7758 is not set
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
CONFIG_AD2S1200=m
CONFIG_AD2S1210=m

#
# Triggers - standalone
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=m
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
CONFIG_BCM_WIMAX=m
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ASHMEM is not set
CONFIG_ANDROID_LOGGER=m
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
CONFIG_USB_WPAN_HCD=m
CONFIG_WIMAX_GDM72XX=m
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_LTE_GDM724X=m
# CONFIG_CED1401 is not set
CONFIG_DGRP=m
CONFIG_GOLDFISH_AUDIO=y
CONFIG_USB_DWC2=m
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
# CONFIG_XILLYBUS is not set
CONFIG_DGNC=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_SCU_IPC=y
# CONFIG_INTEL_SCU_IPC_UTIL is not set
# CONFIG_GPIO_INTEL_PMIC is not set
CONFIG_INTEL_MID_POWER_BUTTON=m
CONFIG_INTEL_MFLD_THERMAL=m
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_GOLDFISH_PIPE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=m
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
# CONFIG_AD7266 is not set
CONFIG_AD7298=m
CONFIG_AD7476=m
CONFIG_AD7791=m
CONFIG_AD7793=m
# CONFIG_AD7887 is not set
CONFIG_AD7923=m
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_VIPERBOARD_ADC=m

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
CONFIG_AD5446=m
CONFIG_AD5449=m
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=m
CONFIG_AD5686=m
CONFIG_AD5755=m
CONFIG_AD5764=m
# CONFIG_AD5791 is not set
CONFIG_AD7303=m
CONFIG_MAX517=m
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16136=m
CONFIG_ADIS16260=m
CONFIG_ADXRS450=m
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
# CONFIG_HID_SENSOR_ALS is not set
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
CONFIG_IIO_ST_MAGN_SPI_3AXIS=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m

#
# Temperature sensors
#
CONFIG_TMP006=m
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
CONFIG_VME_USER=m
CONFIG_VME_PIO2=m
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
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
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
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
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

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
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_MEMORY_NOTIFIER_ERROR_INJECT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
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
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_INTEL_MID=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
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
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

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
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
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
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--PNTmBPCT7hxwcZjr--
