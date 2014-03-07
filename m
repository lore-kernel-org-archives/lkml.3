Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaCGKhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:37:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:10023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaCGKhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:37:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,607,1389772800"; 
   d="scan'208";a="487838224"
Date: Fri, 7 Mar 2014 18:36:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
Message-ID: <20140307103649.GA21708@localhost>
References: <20140307013833.GD8427@localhost>
 <1394182034.21684.6.camel@wall-e.seibold.net>
 <20140307091515.GA8888@localhost>
 <1394186248.28066.42.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394186248.28066.42.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:57:28AM +0100, Stefani Seibold wrote:
> Hi Fengguang,
> 
> did you test the config i had sent to you?

Stefani, here is the result with your config. It goes on to another
bug. I repeated it twice and it's reproducible.

This kernel is build with gcc 4.6.3 on commit
4dea8e4824b363c53f320d328040d7c6c5921419 ("x86, vdso: Add 32 bit VDSO
time support for 32 bit kernel").

wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
early console in setup code
Probing EDD (edd=off to disable)... ok
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-00009-g4dea8e4 (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #6 SMP Fri Mar 7 18:30:39 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [800f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x02790000, 0x02790fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x02791000, 0x02791fff] PGTABLE
[    0.000000] BRK [0x02792000, 0x02792fff] PGTABLE
[    0.000000] BRK [0x02793000, 0x02793fff] PGTABLE
[    0.000000] BRK [0x02794000, 0x02794fff] PGTABLE
[    0.000000] BRK [0x02795000, 0x02795fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000f16b0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe3f0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe430 001137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff6a0 000899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffff5b0 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffff570 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8200a2e0, node_mem_map 8f951028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @8f6bd000 s1338976 r0 d12704 u1351680
[    0.000000] pcpu-alloc: s1338976 r0 d12704 u1351680 alloc=330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f6bf540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64796
[    0.000000] Kernel command line: debug sched_debug apic=debug ignore_loglevel earlyprintk=ttyS0,115200 sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal root=/dev/ram0 rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 228784K/261744K available (11650K kernel code, 875K rwdata, 4076K rodata, 1920K init, 5512K bss, 32960K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa93000 - 0xfffff000   (5552 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff3fe000   (1772 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x82039000 - 0x82219000   (1920 kB)
[    0.000000]       .data : 0x81b60dce - 0x82037fe0   (4956 kB)
[    0.000000]       .text : 0x81000000 - 0x81b60dce   (11651 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  Hierarchical RCU autobalancing is disabled.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=8f00a000 soft=8f00c000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
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
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.012000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.013636] pid_max: default: 4096 minimum: 301
[    0.016073] Mount-cache hash table entries: 512
[    0.018625] Initializing cgroup subsys debug
[    0.020022] Initializing cgroup subsys devices
[    0.024026] Initializing cgroup subsys freezer
[    0.026092] Initializing cgroup subsys net_cls
[    0.027192] Initializing cgroup subsys blkio
[    0.028020] Initializing cgroup subsys perf_event
[    0.032025] Initializing cgroup subsys net_prio
[    0.034439] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034439] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.034439] tlb_flushall_shift: -1
[    0.040842] debug: unmapping init [mem 0x82219000-0x82221fff]
[    0.050702] Getting VERSION: 50014
[    0.052013] Getting VERSION: 50014
[    0.053849] Getting ID: 0
[    0.056027] Getting ID: f000000
[    0.057861] Getting LVT0: 8700
[    0.059501] Getting LVT1: 8400
[    0.060020] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.064143] enabled ExtINT on CPU#0
[    0.068055] ENABLING IO-APIC IRQs
[    0.072027] init IO_APIC IRQs
[    0.076015]  apic 0 pin 0 not connected
[    0.077991] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.080058] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.084056] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.088052] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.092051] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.096053] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.100051] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.104052] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.108056] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.112062] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.116051] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.120052] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.124058] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.128050] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.132051] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.136049]  apic 0 pin 16 not connected
[    0.140010]  apic 0 pin 17 not connected
[    0.141251]  apic 0 pin 18 not connected
[    0.144005]  apic 0 pin 19 not connected
[    0.145356]  apic 0 pin 20 not connected
[    0.147376]  apic 0 pin 21 not connected
[    0.148011]  apic 0 pin 22 not connected
[    0.150122]  apic 0 pin 23 not connected
[    0.152192] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.156010] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.161144] Using local APIC timer interrupts.
[    0.161144] calibrating APIC timer ...
[    0.168000] ... lapic delta = 6249564
[    0.168000] ... PM-Timer delta = 357923
[    0.168000] ... PM-Timer result ok
[    0.168000] ..... delta 6249564
[    0.168000] ..... mult: 268416729
[    0.168000] ..... calibration result: 3999720
[    0.168000] ..... CPU clock speed is 2693.0593 MHz.
[    0.168000] ..... host bus clock speed is 999.3720 MHz.
[    0.168131] Performance Events: no PMU driver, software events only.
[    0.175541] CPU 1 irqstacks, hard=8f086000 soft=8f090000
[    0.176012] x86: Booting SMP configuration:
[    0.180010] .... node  #0, CPUs:      #1
[    0.012000] Initializing CPU#1
[    0.012000] kvm-clock: cpu 1, msr 0:fffb021, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.194698] x86: Booted up 1 node, 2 CPUs
[    0.194633] KVM setup async PF for cpu 1
[    0.194633] kvm-stealtime: cpu 1, msr f809540
[    0.200028] ----------------
[    0.201634] | NMI testsuite:
[    0.204007] --------------------
[    0.205970]   remote IPI:  ok  |
[    0.221224]    local IPI:  ok  |
[    0.244040] --------------------
[    0.246770] Good, all   2 testcases passed! |
[    0.248010] ---------------------------------
[    0.250219] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.252726] CPU0 attaching sched-domain:
[    0.256057]  domain 0: span 0-1 level CPU
[    0.258166]   groups: 0 1
[    0.261022] CPU1 attaching sched-domain:
[    0.263162]  domain 0: span 0-1 level CPU
[    0.265216]   groups: 1 0
[    0.268496] devtmpfs: initialized
[    0.273590] xor: measuring software checksum speed
[    0.316031]    pIII_sse  :    80.000 MB/sec
[    0.356063]    prefetch64-sse:    81.000 MB/sec
[    0.358520] xor: using function: prefetch64-sse (81.000 MB/sec)
[    0.360043] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.364500] regulator-dummy: no parameters
[    0.367128] NET: Registered protocol family 16
[    0.369279] cpuidle: using governor ladder
[    0.372013] cpuidle: using governor menu
[    0.376089] ACPI: bus type PCI registered
[    0.378420] PCI: PCI BIOS revision 2.10 entry at 0xfd4e3, last bus=0
[    0.380011] PCI: Using configuration type 1 for base access
[    0.398117] bio: create slab <bio-0> at 0
[    0.468047] raid6: mmxx1     1965 MB/s
[    0.536030] raid6: mmxx2     2066 MB/s
[    0.604038] raid6: sse1x1    1687 MB/s
[    0.672026] raid6: sse1x2    1995 MB/s
[    0.740032] raid6: sse2x1    3289 MB/s
[    0.808027] raid6: sse2x2    4043 MB/s
[    0.810189] raid6: using algorithm sse2x2 (4043 MB/s)
[    0.812012] raid6: using intx1 recovery algorithm
[    0.816007] ACPI: Added _OSI(Module Device)
[    0.818260] ACPI: Added _OSI(Processor Device)
[    0.820012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.822397] ACPI: Added _OSI(Processor Aggregator Device)
[    0.840253] ACPI: Interpreter enabled
[    0.842482] ACPI: (supports S0 S5)
[    0.844010] ACPI: Using IOAPIC for interrupt routing
[    0.846458] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.869792] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.872024] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.874609] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.876407] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.884192] PCI host bridge to bus 0000:00
[    0.886239] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.888015] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.890864] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.892015] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.896021] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.900125] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.905121] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.909252] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.917610] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.922746] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.924717] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.928036] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.932753] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.944074] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.952081] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.976051] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.977983] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.980010] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.982040] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.987517] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.988360] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.990476] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.992901] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.999129] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    1.000317] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    1.001999] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    1.007026] pci_bus 0000:00: on NUMA node 0
[    1.008667] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.010267] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.011811] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.012787] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.014350] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.016917] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.018836] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.018836] vgaarb: loaded
[    1.018836] vgaarb: bridge control possible 0000:00:02.0
[    1.020128] SCSI subsystem initialized
[    1.023305] libata version 3.00 loaded.
[    1.023305] ACPI: bus type USB registered
[    1.023305] usbcore: registered new interface driver usbfs
[    1.024033] usbcore: registered new interface driver hub
[    1.027774] usbcore: registered new device driver usb
[    1.027774] pps_core: LinuxPPS API ver. 1 registered
[    1.027774] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.028016] PTP clock support registered
[    1.028890] PCI: Using ACPI for IRQ routing
[    1.029759] PCI: pci_cache_line_size set to 64 bytes
[    1.032137] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.033280] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.034824] irda_init()
[    1.035534] NET: Registered protocol family 23
[    1.036045] Bluetooth: Core ver 2.18
[    1.036880] NET: Registered protocol family 31
[    1.037779] Bluetooth: HCI device and connection manager initialized
[    1.039007] Bluetooth: HCI socket layer initialized
[    1.040016] Bluetooth: L2CAP socket layer initialized
[    1.041048] Bluetooth: SCO socket layer initialized
[    1.045382] cfg80211: Calling CRDA to update world regulatory domain
[    1.045880] Switched to clocksource kvm-clock
[    1.045880] FS-Cache: Loaded
[    1.045922] CacheFiles: Loaded
[    1.046692] pnp: PnP ACPI init
[    1.047411] ACPI: bus type PNP registered
[    1.048352] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    1.052070] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.053394] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    1.055167] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.056469] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    1.058199] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.059495] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    1.061148] pnp 00:03: [dma 2]
[    1.061904] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.063274] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    1.064966] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.066283] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    1.067967] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.069639] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.071121] pnp: PnP ACPI: found 7 devices
[    1.071983] ACPI: bus type PNP unregistered
[    1.111354] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.112559] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.113656] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.114884] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.116195] NET: Registered protocol family 2
[    1.117686] TCP established hash table entries: 2048 (order: 1, 8192 bytes)
[    1.119092] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    1.120476] TCP: Hash tables configured (established 2048 bind 2048)
[    1.121754] TCP: reno registered
[    1.122500] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    1.123682] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    1.125161] NET: Registered protocol family 1
[    1.126115] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.127294] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.128456] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.129674] pci 0000:00:02.0: Boot video device
[    1.130662] PCI: CLS 0 bytes, default 64
[    1.394320] Unpacking initramfs...
[    2.121341] debug: unmapping init [mem 0x8fce6000-0x8ffeffff]
[    2.125846] cryptomgr_test (25) used greatest stack depth: 7220 bytes left
[    2.129704] PCLMULQDQ-NI instructions are not detected.
[    2.131872] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    2.135487] NatSemi SCx200 Driver
[    2.137615] futex hash table entries: 16 (order: -3, 768 bytes)
[    2.139370] Initialise system trusted keyring
[    2.141665] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.150850] VFS: Disk quotas dquot_6.5.2
[    2.152523] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.155316] DLM installed
[    2.158305] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    2.160836] ocfs2 stack glue: unable to register sysctl
[    2.162356] ocfs2: Registered cluster interface o2cb
[    2.164094] OCFS2 User DLM kernel interface loaded
[    2.169919] msgmni has been set to 446
[    2.182029] Key type asymmetric registered
[    2.183519] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.186111] io scheduler noop registered (default)
[    2.187523] io scheduler deadline registered
[    2.188826] io scheduler cfq registered
[    2.190023] list_sort_test: start testing list_sort()
[    2.191782] test_string_helpers: Running tests...
[    2.194328] no IO addresses supplied
[    2.195696] usbcore: registered new interface driver udlfb
[    2.197237] usbcore: registered new interface driver smscufx
[    2.200202] kworker/u4:0 (85) used greatest stack depth: 6880 bytes left
[    2.202082] uvesafb: failed to execute /sbin/v86d
[    2.203435] uvesafb: make sure that the v86d helper is installed and executable
[    2.205558] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-8)
[    2.207235] uvesafb: vbe_init() failed with -22
[    2.208528] uvesafb: probe of uvesafb.0 failed with error -22
[    2.210566] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.212682] ACPI: Power Button [PWRF]
[    2.214976] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.216512] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.251476] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.255246] STMicroelectronics ASC driver initialized
[    2.256935] serial: Freescale lpuart driver
[    2.258576] lp: driver loaded but no devices found
[    2.259893] toshiba: not a supported Toshiba laptop
[    2.261701] ppdev: user-space parallel port driver
[    2.263144] scx200_gpio: no SCx200 gpio present
[    2.264529] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    2.266339] platform pc8736x_gpio.0: no device found
[    2.267795] nsc_gpio initializing
[    2.268886] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    2.270325] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
[    2.272098] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.275218] Hangcheck: Using getrawmonotonic().
[    2.277478] parport_pc 00:04: reported by Plug and Play ACPI
[    2.279942] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    2.380662] lp0: using parport0 (interrupt-driven).
[    2.385885] Floppy drive(s): fd0 is 1.44M
[    2.394564] loop: module loaded
[    2.396533] rbd: loaded
[    2.397807] blk-mq: CPU -> queue map
[    2.399544]   CPU 0 -> Queue 0
[    2.401016]   CPU 1 -> Queue 0
[    2.404207]  nullb0: unknown partition table
[    2.406830] FDC 0 is a S82078B
[    2.406892] blk-mq: CPU -> queue map
[    2.406893]   CPU 0 -> Queue 0
[    2.406893]   CPU 1 -> Queue 0
[    2.416684]  nullb1: unknown partition table
[    2.419346] null: module loaded
[    2.422351] zram: Created 1 device(s) ...
[    2.424592] dummy-irq: no IRQ given.  Use irq=N
[    2.426915] lkdtm: No crash points registered, enable through debugfs
[    2.429963] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.433768] c2port c2port0: C2 port uc added
[    2.434689] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    2.436654] usbcore: registered new interface driver viperboard
[    2.437819] Uniform Multi-Platform E-IDE driver
[    2.438846] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    2.440185] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    2.442135]     ide0: BM-DMA at 0xc060-0xc067
[    2.443081]     ide1: BM-DMA at 0xc068-0xc06f
[    2.443995] Probing IDE interface ide0...
[    3.014829] Probing IDE interface ide1...
[    3.754810] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    4.430638] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    4.433191] hdc: MWDMA2 mode selected
[    4.435029] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.436943] ide1 at 0x170-0x177,0x376 on irq 15
[    4.439489] ide-gd driver 1.18
[    4.442813] Loading iSCSI transport class v2.0-870.
[    4.445442] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.448054] osd: LOADED open-osd 0.2.1
[    4.450716] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    4.457102] SSFDC read-only Flash Translation layer
[    4.459309] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
[    4.462749] Failed to ioremap_nocache
[    4.464596] slram: not enough parameters.
[    4.906125] parport0: AVR Butterfly
[    4.907163] parport0: cannot grant exclusive access for device spi-lm70llp
[    4.909417] spi-lm70llp: spi_lm70llp probe fail, status -12
[    4.911397] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    4.915972] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.920305] tun: Universal TUN/TAP device driver, 1.6
[    4.921734] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.923337] arcnet loaded.
[    4.924402] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    4.926088] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    4.928127] arcnet: raw mode (`r') encapsulation support loaded.
[    4.929633] arcnet: cap mode (`c') encapsulation support loaded.
[    4.932002] arcnet: COM90xx chipset support
[    5.232765] S3: No ARCnet cards found.
[    5.234689] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    5.240676] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[    5.246552] slcan: serial line CAN interface driver
[    5.249749] slcan: 10 dynamic interface channels.
[    5.252643] CAN device driver interface
[    5.255390] usbcore: registered new interface driver ems_usb
[    5.259066] usbcore: registered new interface driver esd_usb2
[    5.262792] usbcore: registered new interface driver kvaser_usb
[    5.265219] usbcore: registered new interface driver peak_usb
[    5.267167] usbcore: registered new interface driver usb_8dev
[    5.269293] sja1000 CAN netdevice driver
[    5.270972] sja1000_isa: insufficient parameters supplied
[    5.273252] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    5.276288] usbcore: registered new interface driver irda-usb
[    5.277511] usbcore: registered new interface driver stir4200
[    5.280800] usbcore: registered new interface driver mcs7780
[    5.283335] usbcore: registered new interface driver kingsun-sir
[    5.285676] usbcore: registered new interface driver ks959-sir
[    5.288501] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    5.290542] plip0: Parallel port at 0x378, using IRQ 7.
[    5.291593] PPP generic driver version 2.4.2
[    5.296975] PPP BSD Compression module registered
[    5.300164] PPP Deflate Compression module registered
[    5.303224] PPP MPPE Compression module registered
[    5.306205] NET: Registered protocol family 24
[    5.308995] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    5.313166] usbcore: registered new interface driver kaweth
[    5.316540] usbcore: registered new interface driver r8152
[    5.320037] usbcore: registered new interface driver cdc_phonet
[    5.323755] parport0: cannot grant exclusive access for device ks0108
[    5.327584] ks0108: ERROR: parport didn't register new device
[    5.331152] cfag12864b: ERROR: ks0108 is not initialized
[    5.334459] cfag12864bfb: ERROR: cfag12864b is not initialized
[    5.339533] aoe: AoE v85 initialised.
[    5.342520] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.346214] ehci-pci: EHCI PCI platform driver
[    5.347716] ehci-platform: EHCI generic platform driver
[    5.349075] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.350900] ohci-pci: OHCI PCI platform driver
[    5.353029] ohci-platform: OHCI generic platform driver
[    5.355099] driver u132_hcd
[    5.357145] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.359564] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.363410] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    5.365693] 4Warning! fotg210_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.369581] usbcore: registered new interface driver cdc_acm
[    5.371952] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    5.375634] usbcore: registered new interface driver usblp
[    5.377852] usbcore: registered new interface driver cdc_wdm
[    5.380088] usbcore: registered new interface driver usbtmc
[    5.382352] usbcore: registered new interface driver usb-storage
[    5.384782] usbcore: registered new interface driver ums-alauda
[    5.387245] usbcore: registered new interface driver ums-cypress
[    5.389692] usbcore: registered new interface driver ums_eneub6250
[    5.392264] usbcore: registered new interface driver ums-jumpshot
[    5.394635] usbcore: registered new interface driver ums-sddr09
[    5.397059] usbcore: registered new interface driver ums-usbat
[    5.399614] usbcore: registered new interface driver mdc800
[    5.401878] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    5.405158] usbcore: registered new interface driver microtekX6
[    5.407749] usbcore: registered new interface driver usbserial
[    5.410134] usbcore: registered new interface driver usbserial_generic
[    5.412897] usbserial: USB Serial support registered for generic
[    5.415366] usbcore: registered new interface driver aircable
[    5.417740] usbserial: USB Serial support registered for aircable
[    5.420268] usbcore: registered new interface driver ark3116
[    5.422530] usbserial: USB Serial support registered for ark3116
[    5.424829] usbcore: registered new interface driver belkin_sa
[    5.426614] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    5.428789] usbcore: registered new interface driver ch341
[    5.430064] usbserial: USB Serial support registered for ch341-uart
[    5.431426] usbcore: registered new interface driver cp210x
[    5.433194] usbserial: USB Serial support registered for cp210x
[    5.435513] usbcore: registered new interface driver cyberjack
[    5.437994] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    5.440011] usbcore: registered new interface driver cypress_m8
[    5.441325] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    5.443087] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    5.444804] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    5.446973] usbcore: registered new interface driver usb_debug
[    5.449135] usbserial: USB Serial support registered for debug
[    5.451307] usbcore: registered new interface driver digi_acceleport
[    5.453731] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    5.457042] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    5.460292] usbcore: registered new interface driver empeg
[    5.462564] usbserial: USB Serial support registered for empeg
[    5.464956] usbcore: registered new interface driver ftdi_sio
[    5.467232] usbserial: USB Serial support registered for FTDI USB Serial Device
[    5.470562] usbcore: registered new interface driver ipw
[    5.472728] usbserial: USB Serial support registered for IPWireless converter
[    5.474856] usbcore: registered new interface driver keyspan
[    5.476179] usbserial: USB Serial support registered for Keyspan - (without firmware)
[    5.478090] usbserial: USB Serial support registered for Keyspan 1 port adapter
[    5.479899] usbserial: USB Serial support registered for Keyspan 2 port adapter
[    5.481712] usbserial: USB Serial support registered for Keyspan 4 port adapter
[    5.483500] usbcore: registered new interface driver metro_usb
[    5.484803] usbserial: USB Serial support registered for Metrologic USB to Serial
[    5.486662] usbcore: registered new interface driver mos7840
[    5.487949] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    5.489879] usbcore: registered new interface driver mxuport
[    5.491173] usbserial: USB Serial support registered for MOXA UPort
[    5.492561] usbcore: registered new interface driver navman
[    5.493801] usbserial: USB Serial support registered for navman
[    5.495116] usbcore: registered new interface driver omninet
[    5.496369] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[    5.498570] usbcore: registered new interface driver opticon
[    5.500779] usbserial: USB Serial support registered for opticon
[    5.502506] usbcore: registered new interface driver option
[    5.503912] usbserial: USB Serial support registered for GSM modem (1-port)
[    5.505452] usbcore: registered new interface driver qcaux
[    5.507468] usbserial: USB Serial support registered for qcaux
[    5.509929] usbcore: registered new interface driver qcserial
[    5.512443] usbserial: USB Serial support registered for Qualcomm USB modem
[    5.514449] usbcore: registered new interface driver usb_serial_simple
[    5.516240] usbserial: USB Serial support registered for zio
[    5.517802] usbserial: USB Serial support registered for funsoft
[    5.519619] usbserial: USB Serial support registered for flashloader
[    5.521306] usbserial: USB Serial support registered for vivopay
[    5.523109] usbserial: USB Serial support registered for moto_modem
[    5.525264] usbserial: USB Serial support registered for hp4x
[    5.527149] usbserial: USB Serial support registered for suunto
[    5.529498] usbserial: USB Serial support registered for siemens_mpi
[    5.532117] usbcore: registered new interface driver spcp8x5
[    5.534420] usbserial: USB Serial support registered for SPCP8x5
[    5.536351] usbcore: registered new interface driver ssu100
[    5.537986] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    5.540925] usbcore: registered new interface driver visor
[    5.543067] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    5.545340] usbserial: USB Serial support registered for Sony Clie 5.0
[    5.547699] usbserial: USB Serial support registered for Sony Clie 3.5
[    5.549788] usbcore: registered new interface driver wishbone_serial
[    5.551876] usbserial: USB Serial support registered for wishbone_serial
[    5.554628] usbcore: registered new interface driver whiteheat
[    5.556995] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    5.560938] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    5.564523] usbcore: registered new interface driver xsens_mt
[    5.567181] usbserial: USB Serial support registered for xsens_mt
[    5.569405] usbcore: registered new interface driver zte_ev
[    5.571699] usbserial: USB Serial support registered for zte_ev
[    5.573991] usbcore: registered new interface driver appledisplay
[    5.575981] usbcore: registered new interface driver cytherm
[    5.577659] usbcore: registered new interface driver emi26 - firmware loader
[    5.579584] usbcore: registered new interface driver emi62 - firmware loader
[    5.581481] driver ftdi-elan
[    5.583383] usbcore: registered new interface driver ftdi-elan
[    5.585884] usbcore: registered new interface driver idmouse
[    5.588206] usbcore: registered new interface driver iowarrior
[    5.590530] usbcore: registered new interface driver usblcd
[    5.592846] usbcore: registered new interface driver usbled
[    5.594757] usbcore: registered new interface driver legousbtower
[    5.596779] usbcore: registered new interface driver rio500
[    5.598642] usbcore: registered new interface driver uss720
[    5.600724] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    5.604944] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    5.608317] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    5.611701] uss720: If you just want to connect to a printer, use usblp instead
[    5.615286] usbcore: registered new interface driver sisusb
[    5.618182] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.623134] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.625099] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.703450] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    5.708145] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.711311] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    5.715087] usbcore: registered new interface driver appletouch
[    5.718162] usbcore: registered new interface driver xpad
[    5.721308] mk712: device not present
[    5.723587] usbcore: registered new interface driver usbtouchscreen
[    5.726224] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    5.728816] usbcore: registered new interface driver ati_remote2
[    5.730929] cm109: Keymap for Komunikate KIP1000 phone loaded
[    5.736132] usbcore: registered new interface driver cm109
[    5.738453] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    5.740955] usbcore: registered new interface driver keyspan_remote
[    5.743527] usbcore: registered new interface driver powermate
[    5.745568] wistron_btns: System unknown
[    5.747163] i2c /dev entries driver
[    5.748987] i2c-parport: adapter type unspecified
[    5.750927] i2c-parport-light: adapter type unspecified
[    5.753095] usbcore: registered new interface driver i2c-tiny-usb
[    5.755289] scx200_i2c: no SCx200 gpio pins available
[    5.757526] pps_ldisc: PPS line discipline registered
[    5.759623] pps_parport: parallel port PPS client
[    5.761589] parport0: cannot grant exclusive access for device pps_parport
[    5.764038] pps_parport: couldn't register with parport0
[    5.765984] Driver for 1-wire Dallas network protocol.
[    5.767755] usbcore: registered new interface driver DS9490R
[    5.769971] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.772499] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    5.776441] power_supply test_ac: uevent
[    5.778205] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    5.780950] power_supply test_ac: prop ONLINE=1
[    5.782617] power_supply test_ac: power_supply_changed
[    5.786358] power_supply test_ac: power_supply_changed_work
[    5.790239] power_supply test_ac: power_supply_update_gen_leds 1
[    5.794494] power_supply test_ac: uevent
[    5.796114] power_supply test_battery: uevent
[    5.796117] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    5.796139] power_supply test_battery: prop STATUS=Discharging
[    5.796144] power_supply test_battery: prop CHARGE_TYPE=Fast
[    5.796148] power_supply test_battery: prop HEALTH=Good
[    5.796153] power_supply test_battery: prop PRESENT=1
[    5.796157] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    5.796162] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    5.796165] power_supply test_battery: prop CHARGE_FULL=100
[    5.796169] power_supply test_battery: prop CHARGE_NOW=50
[    5.796172] power_supply test_battery: prop CAPACITY=50
[    5.796176] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    5.796179] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    5.796182] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    5.796186] power_supply test_battery: prop MODEL_NAME=Test battery
[    5.796190] power_supply test_battery: prop MANUFACTURER=Linux
[    5.796193] power_supply test_battery: prop SERIAL_NUMBER=3.14.0-rc5-00009-g4dea8e4
[    5.796197] power_supply test_battery: prop TEMP=26
[    5.796200] power_supply test_battery: prop VOLTAGE_NOW=3300
[    5.796497] power_supply test_battery: power_supply_changed
[    5.796536] power_supply test_battery: power_supply_changed_work
[    5.796545] power_supply test_battery: power_supply_update_bat_leds 2
[    5.796556] power_supply test_battery: uevent
[    5.796558] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    5.796568] power_supply test_battery: prop STATUS=Discharging
[    5.796572] power_supply test_battery: prop CHARGE_TYPE=Fast
[    5.796575] power_supply test_battery: prop HEALTH=Good
[    5.796578] power_supply test_battery: prop PRESENT=1
[    5.796588] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    5.796593] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    5.796596] power_supply test_battery: prop CHARGE_FULL=100
[    5.796600] power_supply test_battery: prop CHARGE_NOW=50
[    5.796603] power_supply test_battery: prop CAPACITY=50
[    5.796607] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    5.796610] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    5.796613] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    5.796617] power_supply test_battery: prop MODEL_NAME=Test battery
[    5.796620] power_supply test_battery: prop MANUFACTURER=Linux
[    5.796624] power_supply test_battery: prop SERIAL_NUMBER=3.14.0-rc5-00009-g4dea8e4
[    5.796627] power_supply test_battery: prop TEMP=26
[    5.796630] power_supply test_battery: prop VOLTAGE_NOW=3300
[    5.796695] power_supply test_usb: uevent
[    5.796697] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    5.796705] power_supply test_usb: prop ONLINE=1
[    5.796722] power_supply test_usb: power_supply_changed
[    5.796771] power_supply test_usb: power_supply_changed_work
[    5.796775] power_supply test_usb: power_supply_update_gen_leds 1
[    5.796778] power_supply test_usb: uevent
[    5.796779] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    5.796782] power_supply test_usb: prop ONLINE=1
[    5.799998] pc87360: PC8736x not detected, module not inserted
[    5.801087] Bluetooth: Virtual HCI driver ver 1.4
[    5.801262] Bluetooth: HCI UART driver ver 2.2
[    5.801275] Bluetooth: HCI H4 protocol initialized
[    5.801280] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    5.801335] usbcore: registered new interface driver bcm203x
[    5.801377] usbcore: registered new interface driver bpa10x
[    5.801412] usbcore: registered new interface driver bfusb
[    5.807328] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    5.807778] CAPI 2.0 started up with major 68 (middleware)
[    5.807880] dss1_divert module successfully installed
[    5.807881] gigaset: Driver for Gigaset 307x (debug build)
[    5.807890] gigaset: Kernel CAPI interface
[    5.808005] usbcore: registered new interface driver usb_gigaset
[    5.808006] usb_gigaset: USB Driver for Gigaset 307x using M105
[    5.809658] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.811605] usbcore: registered new interface driver usbhid
[    5.811611] usbhid: USB HID core driver
[    5.811987] oprofile: using timer interrupt.
[    5.812150] NET: Registered protocol family 26
[    5.812202] netem: version 1.3
[    5.812207] u32 classifier
[    5.812210]     Performance counters on
[    5.812210]     input device check on
[    5.812238] Netfilter messages via NETLINK v0.30.
[    5.812248] nfnl_acct: registering with nfnetlink.
[    5.812392] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    5.812402] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
[    5.812561] xt_time: kernel timezone is -0000
[    5.812595] ip_set: protocol 6
[    5.812627] IPVS: Registered protocols (TCP, UDP, SCTP, AH)
[    5.812687] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    5.812693] IPVS: Each connection entry needs 256 bytes at least
[    5.812786] IPVS: Creating netns size=1356 id=0
[    6.005108] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    6.008163] power_supply test_ac: prop ONLINE=1
[    6.011074] IPVS: ipvs loaded.
[    6.012603] IPVS: [rr] scheduler registered.
[    6.014503] IPVS: [wrr] scheduler registered.
[    6.016621] IPVS: [lc] scheduler registered.
[    6.018488] IPVS: [wlc] scheduler registered.
[    6.020075] IPVS: [lblc] scheduler registered.
[    6.022164] IPVS: [lblcr] scheduler registered.
[    6.024134] IPVS: [dh] scheduler registered.
[    6.026052] IPVS: [nq] scheduler registered.
[    6.028136] ipip: IPv4 over IPv4 tunneling driver
[    6.030867] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.033853] arp_tables: (C) 2002 David S. Miller
[    6.036397] TCP: cubic registered
[    6.038084] NET: Registered protocol family 17
[    6.040077] NET: Registered protocol family 15
[    6.042096] NET: Registered protocol family 5
[    6.043985] NET: Registered protocol family 9
[    6.045989] X25: Linux Version 0.2
[    6.047649] can: controller area network core (rev 20120528 abi 9)
[    6.050334] NET: Registered protocol family 29
[    6.052500] can: raw protocol (rev 20120528)
[    6.054408] can: netlink gateway (rev 20130117) max_hops=1
[    6.058449] IrCOMM protocol (Dag Brattli)
[    6.065925] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.068232] Bluetooth: BNEP filters: protocol
[    6.069728] Bluetooth: BNEP socket layer initialized
[    6.071951] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[    6.074195] Bluetooth: CMTP socket layer initialized
[    6.076351] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    6.078755] Bluetooth: HIDP socket layer initialized
[    6.080478] NET: Registered protocol family 33
[    6.082540] Key type rxrpc registered
[    6.084298] Key type rxrpc_s registered
[    6.086616] cryptomgr_probe (111) used greatest stack depth: 6812 bytes left
[    6.086663] RxRPC: Registered security type 2 'rxkad'
[    6.086692] l2tp_core: L2TP core driver, V2.0
[    6.086702] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[    6.086729] l2tp_debugfs: L2TP debugfs support
[    6.086730] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    6.086881] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    6.086929] NET: Registered protocol family 12
[    6.086974] NET: Registered protocol family 35
[    6.087056] 8021q: 802.1Q VLAN Support v1.8
[    6.087602] DCCP: Activated CCID 2 (TCP-like)
[    6.087614] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    6.088050] sctp: Hash tables configured (established 1365 bind 1489)
[    6.088218] tipc: Activated (version 2.0.0)
[    6.089064] NET: Registered protocol family 30
[    6.089312] tipc: Started in single node mode
[    6.089420] NET: Registered protocol family 37
[    6.089432] Key type dns_resolver registered
[    6.089451] Key type ceph registered
[    6.089620] libceph: loaded (mon/osd proto 15/24)
[    6.089834] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility version 15) loaded
[    6.089835] openvswitch: Open vSwitch switching datapath
[    6.089964] mpls_gso: MPLS GSO support
[    6.090331]
[    6.090331] printing PIC contents
[    6.090341] ... PIC  IMR: ffff
[    6.090345] ... PIC  IRR: 1053
[    6.090353] ... PIC  ISR: 0000
[    6.090357] ... PIC ELCR: 0c00
[    6.090367] printing local APIC contents on CPU#0/0:
[    6.090374] ... APIC ID:      00000000 (0)
[    6.090378] ... APIC VERSION: 00050014
[    6.090382] ... APIC TASKPRI: 00000000 (00)
[    6.090385] ... APIC PROCPRI: 00000000
[    6.090387] ... APIC LDR: 01000000
[    6.090390] ... APIC DFR: ffffffff
[    6.090392] ... APIC SPIV: 000001ff
[    6.090393] ... APIC ISR field:
[    6.090412] 0000000000000000000000000000000000000000000000000000000000000000
[    6.090413] ... APIC TMR field:
[    6.090431] 0000000000000000000000000000000000000000000000000000000000000000
[    6.090431] ... APIC IRR field:
[    6.090450] 0000000000000000000000000000000000000000000000000000000000000000
[    6.090455] ... APIC ESR: 00000000
[    6.090460] ... APIC ICR: 000008fd
[    6.090460] ... APIC ICR2: 02000000
[    6.090463] ... APIC LVTT: 000200ef
[    6.090465] ... APIC LVTPC: 00010000
[    6.090467] ... APIC LVT0: 00010700
[    6.090470] ... APIC LVT1: 00000400
[    6.090472] ... APIC LVTERR: 000000fe
[    6.090475] ... APIC TMICT: 0003d07e
[    6.090478] ... APIC TMCCT: 00013d3d
[    6.090480] ... APIC TDCR: 00000003
[    6.090481]
[    6.090482] number of MP IRQ sources: 15.
[    6.090482] number of IO-APIC #0 registers: 24.
[    6.090483] testing the IO APIC.......................
[    6.090498] IO APIC #0......
[    6.090498] .... register #00: 00000000
[    6.090499] .......    : physical APIC id: 00
[    6.090499] .......    : Delivery Type: 0
[    6.090500] .......    : LTS          : 0
[    6.090500] .... register #01: 00170011
[    6.090501] .......     : max redirection entries: 17
[    6.090501] .......     : PRQ implemented: 0
[    6.090501] .......     : IO APIC version: 11
[    6.090502] .... register #02: 00000000
[    6.090502] .......     : arbitration: 00
[    6.090503] .... IRQ redirection table:
[    6.090513] 1    0    0   0   0    0    0    00
[    6.090522] 0    0    0   0   0    1    1    31
[    6.090531] 0    0    0   0   0    1    1    30
[    6.090540] 0    0    0   0   0    1    1    33
[    6.090550] 1    0    0   0   0    1    1    34
[    6.090559] 1    1    0   0   0    1    1    35
[    6.090568] 0    0    0   0   0    1    1    36
[    6.090578] 0    0    0   0   0    1    1    37
[    6.090587] 0    0    0   0   0    1    1    38
[    6.090596] 0    1    0   0   0    1    1    39
[    6.090605] 1    1    0   0   0    1    1    3A
[    6.090614] 1    1    0   0   0    1    1    3B
[    6.090624] 0    0    0   0   0    1    1    3C
[    6.090633] 0    0    0   0   0    1    1    3D
[    6.090642] 0    0    0   0   0    1    1    3E
[    6.090652] 0    0    0   0   0    1    1    3F
[    6.090661] 1    0    0   0   0    0    0    00
[    6.090670] 1    0    0   0   0    0    0    00
[    6.090679] 1    0    0   0   0    0    0    00
[    6.090688] 1    0    0   0   0    0    0    00
[    6.090697] 1    0    0   0   0    0    0    00
[    6.090706] 1    0    0   0   0    0    0    00
[    6.090715] 1    0    0   0   0    0    0    00
[    6.090724] 1    0    0   0   0    0    0    00
[    6.090725] IRQ to pin mappings:
[    6.090728] IRQ0 -> 0:2
[    6.090729] IRQ1 -> 0:1
[    6.090730] IRQ3 -> 0:3
[    6.090731] IRQ4 -> 0:4
[    6.090732] IRQ5 -> 0:5
[    6.090733] IRQ6 -> 0:6
[    6.090734] IRQ7 -> 0:7
[    6.090735] IRQ8 -> 0:8
[    6.090736] IRQ9 -> 0:9
[    6.090737] IRQ10 -> 0:10
[    6.090738] IRQ11 -> 0:11
[    6.090739] IRQ12 -> 0:12
[    6.090740] IRQ13 -> 0:13
[    6.090741] IRQ14 -> 0:14
[    6.090742] IRQ15 -> 0:15
[    6.090743] .................................... done.
[    6.090744] Using IPI Shortcut mode
[    6.090936] Loading compiled-in X.509 certificates
[    6.090950] Problem loading in-kernel X.509 certificate (-74)
[    6.091365] bio: create slab <bio-1> at 1
[    6.091876] Btrfs loaded, debug=on, assert=on, integrity-checker=on
[    6.092060] Key type trusted registered
[    6.279514] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.282414] EDD information not available.
[    6.284361] debug: unmapping init [mem 0x82039000-0x82218fff]
[    6.286803] Write protecting the kernel text: 11652k
[    6.288948] Write protecting the kernel read-only data: 4080k
[    6.292582] Failed to execute /init (error -8)
[    6.295125] Starting init: /sbin/init exists but couldn't execute it (error -8)
[    6.299442] Starting init: /etc/init exists but couldn't execute it (error -13)
[    6.302942] Starting init: /bin/sh exists but couldn't execute it (error -8)
[    6.307438] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
[    6.311314] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-00009-g4dea8e4 #6
[    6.311314] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.311314]  00000000 00000000 8f037f74 81b48a98 8f803770 8f037f98 81b3d3fa 81e07204
[    6.311314]  82233ec0 81df9b08 81df98af 8f803770 81f717e0 00000000 8f037fac 81b38dfc
[    6.311314]  81df9cd0 81df989f fffffff8 8f036000 81b5fd3b 81b38d30 00000000 00000000
[    6.311314] Call Trace:
[    6.311314]  [<81b48a98>] dump_stack+0x48/0x60
[    6.311314]  [<81b3d3fa>] panic+0x82/0x180
[    6.311314]  [<81b38dfc>] kernel_init+0xcc/0xe0
[    6.311314]  [<81b5fd3b>] ret_from_kernel_thread+0x1b/0x30
[    6.311314]  [<81b38d30>] ? rest_init+0xc0/0xc0
[    6.311314] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x80000000-0x907fdfff)


wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
early console in setup code
Probing EDD (edd=off to disable)... ok
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-00009-g4dea8e4 (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #6 SMP Fri Mar 7 18:30:39 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [800f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x02790000, 0x02790fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x02791000, 0x02791fff] PGTABLE
[    0.000000] BRK [0x02792000, 0x02792fff] PGTABLE
[    0.000000] BRK [0x02793000, 0x02793fff] PGTABLE
[    0.000000] BRK [0x02794000, 0x02794fff] PGTABLE
[    0.000000] BRK [0x02795000, 0x02795fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000f16b0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe3f0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe430 001137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff6a0 000899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffff5b0 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffff570 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8200a2e0, node_mem_map 8f951028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @8f6bd000 s1338976 r0 d12704 u1351680
[    0.000000] pcpu-alloc: s1338976 r0 d12704 u1351680 alloc=330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] kvm-clock: cpu 0, msr 0:fffb001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f6bf540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64796
[    0.000000] Kernel command line: debug sched_debug apic=debug ignore_loglevel earlyprintk=ttyS0,115200 sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal root=/dev/ram0 rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 228784K/261744K available (11650K kernel code, 875K rwdata, 4076K rodata, 1920K init, 5512K bss, 32960K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa93000 - 0xfffff000   (5552 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff3fe000   (1772 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x82039000 - 0x82219000   (1920 kB)
[    0.000000]       .data : 0x81b60dce - 0x82037fe0   (4956 kB)
[    0.000000]       .text : 0x81000000 - 0x81b60dce   (11651 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  Hierarchical RCU autobalancing is disabled.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=8f00a000 soft=8f00c000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
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
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.012000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.013239] pid_max: default: 4096 minimum: 301
[    0.014788] Mount-cache hash table entries: 512
[    0.016841] Initializing cgroup subsys debug
[    0.018735] Initializing cgroup subsys devices
[    0.020032] Initializing cgroup subsys freezer
[    0.022158] Initializing cgroup subsys net_cls
[    0.024010] Initializing cgroup subsys blkio
[    0.026123] Initializing cgroup subsys perf_event
[    0.028028] Initializing cgroup subsys net_prio
[    0.032182] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.032182] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.032182] tlb_flushall_shift: -1
[    0.042916] debug: unmapping init [mem 0x82219000-0x82221fff]
[    0.052889] Getting VERSION: 50014
[    0.054861] Getting VERSION: 50014
[    0.056029] Getting ID: 0
[    0.057585] Getting ID: f000000
[    0.060027] Getting LVT0: 8700
[    0.061087] Getting LVT1: 8400
[    0.062078] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.064098] enabled ExtINT on CPU#0
[    0.066960] ENABLING IO-APIC IRQs
[    0.068027] init IO_APIC IRQs
[    0.069426]  apic 0 pin 0 not connected
[    0.072024] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.074175] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.076065] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.080045] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.084060] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.087259] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.088050] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.092050] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.096060] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.100025] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.104061] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.108060] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.112043] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.116060] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.120052] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.124052]  apic 0 pin 16 not connected
[    0.126099]  apic 0 pin 17 not connected
[    0.128011]  apic 0 pin 18 not connected
[    0.129923]  apic 0 pin 19 not connected
[    0.132006]  apic 0 pin 20 not connected
[    0.133808]  apic 0 pin 21 not connected
[    0.136011]  apic 0 pin 22 not connected
[    0.137961]  apic 0 pin 23 not connected
[    0.140159] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.142130] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.145090] Using local APIC timer interrupts.
[    0.145090] calibrating APIC timer ...
[    0.148000] ... lapic delta = 6251195
[    0.148000] ... PM-Timer delta = 358135
[    0.148000] ... PM-Timer result ok
[    0.148000] ..... delta 6251195
[    0.148000] ..... mult: 268486780
[    0.148000] ..... calibration result: 4000764
[    0.148000] ..... CPU clock speed is 2694.3929 MHz.
[    0.148000] ..... host bus clock speed is 1000.0764 MHz.
[    0.148073] Performance Events: no PMU driver, software events only.
[    0.153410] CPU 1 irqstacks, hard=8f086000 soft=8f090000
[    0.155354] x86: Booting SMP configuration:
[    0.156005] .... node  #0, CPUs:      #1
[    0.012000] Initializing CPU#1
[    0.012000] kvm-clock: cpu 1, msr 0:fffb021, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.173562] x86: Booted up 1 node, 2 CPUs
[    0.173503] KVM setup async PF for cpu 1
[    0.173503] kvm-stealtime: cpu 1, msr f809540
[    0.176009] ----------------
[    0.180008] | NMI testsuite:
[    0.181618] --------------------
[    0.183352]   remote IPI:  ok  |
[    0.197253]    local IPI:  ok  |
[    0.220032] --------------------
[    0.222522] Good, all   2 testcases passed! |
[    0.224014] ---------------------------------
[    0.228016] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.232552] CPU0 attaching sched-domain:
[    0.236033]  domain 0: span 0-1 level CPU
[    0.239014]   groups: 0 1
[    0.241193] CPU1 attaching sched-domain:
[    0.244047]  domain 0: span 0-1 level CPU
[    0.246266]   groups: 1 0
[    0.249006] devtmpfs: initialized
[    0.254320] xor: measuring software checksum speed
[    0.296018]    pIII_sse  :   123.000 MB/sec
[    0.336054]    prefetch64-sse:   134.000 MB/sec
[    0.339007] xor: using function: prefetch64-sse (134.000 MB/sec)
[    0.340040] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.348255] regulator-dummy: no parameters
[    0.351838] NET: Registered protocol family 16
[    0.352660] cpuidle: using governor ladder
[    0.356018] cpuidle: using governor menu
[    0.359544] ACPI: bus type PCI registered
[    0.360116] PCI: PCI BIOS revision 2.10 entry at 0xfd4e3, last bus=0
[    0.364007] PCI: Using configuration type 1 for base access
[    0.380569] bio: create slab <bio-0> at 0
[    0.452010] raid6: mmxx1     2865 MB/s
[    0.520027] raid6: mmxx2     2605 MB/s
[    0.588025] raid6: sse1x1    1969 MB/s
[    0.656019] raid6: sse1x2    2600 MB/s
[    0.724040] raid6: sse2x1    3953 MB/s
[    0.792022] raid6: sse2x2    4016 MB/s
[    0.795132] raid6: using algorithm sse2x2 (4016 MB/s)
[    0.796022] raid6: using intx1 recovery algorithm
[    0.800529] ACPI: Added _OSI(Module Device)
[    0.802740] ACPI: Added _OSI(Processor Device)
[    0.804025] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.806010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.824533] ACPI: Interpreter enabled
[    0.826471] ACPI: (supports S0 S5)
[    0.828010] ACPI: Using IOAPIC for interrupt routing
[    0.830175] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.852392] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.855676] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.856045] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.860328] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.864155] PCI host bridge to bus 0000:00
[    0.868007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.870474] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.872013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.876014] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.880026] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.883039] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.885106] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.892011] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.900574] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.906231] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.908701] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.912017] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.916691] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.921217] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.925494] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.944144] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.949320] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.954123] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.958005] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.971679] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.972831] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.981034] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.985031] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.998016] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    1.000744] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    1.005121] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    1.016720] pci_bus 0000:00: on NUMA node 0
[    1.020298] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.023955] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.025745] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.029747] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.033602] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.038254] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.041747] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.041747] vgaarb: loaded
[    1.044006] vgaarb: bridge control possible 0000:00:02.0
[    1.045494] SCSI subsystem initialized
[    1.048077] libata version 3.00 loaded.
[    1.049699] ACPI: bus type USB registered
[    1.049699] usbcore: registered new interface driver usbfs
[    1.051363] usbcore: registered new interface driver hub
[    1.054886] usbcore: registered new device driver usb
[    1.054886] pps_core: LinuxPPS API ver. 1 registered
[    1.056008] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.060026] PTP clock support registered
[    1.061477] PCI: Using ACPI for IRQ routing
[    1.062863] PCI: pci_cache_line_size set to 64 bytes
[    1.064172] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.066094] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.068488] irda_init()
[    1.069467] NET: Registered protocol family 23
[    1.071111] Bluetooth: Core ver 2.18
[    1.072059] NET: Registered protocol family 31
[    1.073583] Bluetooth: HCI device and connection manager initialized
[    1.076047] Bluetooth: HCI socket layer initialized
[    1.077729] Bluetooth: L2CAP socket layer initialized
[    1.080067] Bluetooth: SCO socket layer initialized
[    1.083492] cfg80211: Calling CRDA to update world regulatory domain
[    1.085850] Switched to clocksource kvm-clock
[    1.086476] FS-Cache: Loaded
[    1.087540] CacheFiles: Loaded
[    1.088326] pnp: PnP ACPI init
[    1.089499] ACPI: bus type PNP registered
[    1.091018] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    1.095831] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.098067] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    1.101027] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.103307] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    1.106173] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.108414] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    1.111180] pnp 00:03: [dma 2]
[    1.112355] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.114644] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    1.117451] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.119710] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    1.122606] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.125192] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.127582] pnp: PnP ACPI: found 7 devices
[    1.129024] ACPI: bus type PNP unregistered
[    1.169081] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.171304] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.174802] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.177509] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.179415] NET: Registered protocol family 2
[    1.181393] TCP established hash table entries: 2048 (order: 1, 8192 bytes)
[    1.184156] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    1.186264] TCP: Hash tables configured (established 2048 bind 2048)
[    1.188508] TCP: reno registered
[    1.189846] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    1.191454] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    1.193572] NET: Registered protocol family 1
[    1.195116] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.197312] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.199390] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.201786] pci 0000:00:02.0: Boot video device
[    1.203392] PCI: CLS 0 bytes, default 64
[    1.205211] Unpacking initramfs...
[    2.144177] debug: unmapping init [mem 0x8fce6000-0x8ffeffff]
[    2.147910] cryptomgr_test (24) used greatest stack depth: 7292 bytes left
[    2.151185] cryptomgr_test (25) used greatest stack depth: 7280 bytes left
[    2.153527] PCLMULQDQ-NI instructions are not detected.
[    2.156056] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    2.159347] NatSemi SCx200 Driver
[    2.162103] futex hash table entries: 16 (order: -3, 768 bytes)
[    2.164977] Initialise system trusted keyring
[    2.168199] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.176426] VFS: Disk quotas dquot_6.5.2
[    2.178681] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.183159] DLM installed
[    2.186719] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    2.188662] ocfs2 stack glue: unable to register sysctl
[    2.191364] ocfs2: Registered cluster interface o2cb
[    2.194015] OCFS2 User DLM kernel interface loaded
[    2.199885] msgmni has been set to 446
[    2.211434] Key type asymmetric registered
[    2.214822] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.220812] io scheduler noop registered (default)
[    2.224495] io scheduler deadline registered
[    2.227018] io scheduler cfq registered
[    2.228119] list_sort_test: start testing list_sort()
[    2.230879] test_string_helpers: Running tests...
[    2.234133] no IO addresses supplied
[    2.235090] usbcore: registered new interface driver udlfb
[    2.236513] usbcore: registered new interface driver smscufx
[    2.238550] kworker/u4:0 (84) used greatest stack depth: 6880 bytes left
[    2.240651] uvesafb: failed to execute /sbin/v86d
[    2.242872] uvesafb: make sure that the v86d helper is installed and executable
[    2.246171] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-8)
[    2.248827] uvesafb: vbe_init() failed with -22
[    2.251067] uvesafb: probe of uvesafb.0 failed with error -22
[    2.253577] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.255701] ACPI: Power Button [PWRF]
[    2.257880] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.259530] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.284028] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.288377] STMicroelectronics ASC driver initialized
[    2.290753] serial: Freescale lpuart driver
[    2.292439] lp: driver loaded but no devices found
[    2.294304] toshiba: not a supported Toshiba laptop
[    2.296553] ppdev: user-space parallel port driver
[    2.298283] scx200_gpio: no SCx200 gpio present
[    2.300338] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    2.302529] platform pc8736x_gpio.0: no device found
[    2.304102] nsc_gpio initializing
[    2.305447] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    2.307289] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
[    2.309348] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.312871] Hangcheck: Using getrawmonotonic().
[    2.315519] parport_pc 00:04: reported by Plug and Play ACPI
[    2.318497] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    2.419484] lp0: using parport0 (interrupt-driven).
[    2.423671] Floppy drive(s): fd0 is 1.44M
[    2.426951] loop: module loaded
[    2.428451] rbd: loaded
[    2.430781] blk-mq: CPU -> queue map
[    2.433632]   CPU 0 -> Queue 0
[    2.436028]   CPU 1 -> Queue 0
[    2.438413]  nullb0: unknown partition table
[    2.441605] blk-mq: CPU -> queue map
[    2.443556]   CPU 0 -> Queue 0
[    2.443762] FDC 0 is a S82078B
[    2.448480]   CPU 1 -> Queue 0
[    2.450945]  nullb1: unknown partition table
[    2.454439] null: module loaded
[    2.456686] zram: Created 1 device(s) ...
[    2.458470] dummy-irq: no IRQ given.  Use irq=N
[    2.461813] lkdtm: No crash points registered, enable through debugfs
[    2.465940] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.471533] c2port c2port0: C2 port uc added
[    2.474727] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    2.479449] usbcore: registered new interface driver viperboard
[    2.481564] Uniform Multi-Platform E-IDE driver
[    2.483379] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    2.487142] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    2.491290]     ide0: BM-DMA at 0xc060-0xc067
[    2.494425]     ide1: BM-DMA at 0xc068-0xc06f
[    2.497995] Probing IDE interface ide0...
[    3.071490] Probing IDE interface ide1...
[    3.807704] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    4.479819] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    4.481162] hdc: MWDMA2 mode selected
[    4.482148] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.483103] ide1 at 0x170-0x177,0x376 on irq 15
[    4.484318] ide-gd driver 1.18
[    4.486936] Loading iSCSI transport class v2.0-870.
[    4.488297] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.490501] osd: LOADED open-osd 0.2.1
[    4.492000] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    4.497752] SSFDC read-only Flash Translation layer
[    4.500682] L440GX flash mapping: failed to find PIIX4 ISA bridge, cannot continue
[    4.504856] Failed to ioremap_nocache
[    4.506917] slram: not enough parameters.
[    4.637135] parport0: AVR Butterfly
[    4.638705] parport0: cannot grant exclusive access for device spi-lm70llp
[    4.640675] spi-lm70llp: spi_lm70llp probe fail, status -12
[    4.642699] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    4.646731] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.652318] tun: Universal TUN/TAP device driver, 1.6
[    4.653988] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.656106] arcnet loaded.
[    4.657079] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    4.659069] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    4.661508] arcnet: raw mode (`r') encapsulation support loaded.
[    4.664165] arcnet: cap mode (`c') encapsulation support loaded.
[    4.665717] arcnet: COM90xx chipset support
[    4.965550] S3: No ARCnet cards found.
[    4.967958] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    4.970933] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[    4.973765] slcan: serial line CAN interface driver
[    4.975461] slcan: 10 dynamic interface channels.
[    4.977081] CAN device driver interface
[    4.978601] usbcore: registered new interface driver ems_usb
[    4.980515] usbcore: registered new interface driver esd_usb2
[    4.982530] usbcore: registered new interface driver kvaser_usb
[    4.983821] usbcore: registered new interface driver peak_usb
[    4.985107] usbcore: registered new interface driver usb_8dev
[    4.986368] sja1000 CAN netdevice driver
[    4.987275] sja1000_isa: insufficient parameters supplied
[    4.988535] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    4.990325] usbcore: registered new interface driver irda-usb
[    4.991610] usbcore: registered new interface driver stir4200
[    4.993330] usbcore: registered new interface driver mcs7780
[    4.994699] usbcore: registered new interface driver kingsun-sir
[    4.995980] usbcore: registered new interface driver ks959-sir
[    4.997500] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    4.998694] plip0: Parallel port at 0x378, using IRQ 7.
[    5.002085] PPP generic driver version 2.4.2
[    5.003402] PPP BSD Compression module registered
[    5.004728] PPP Deflate Compression module registered
[    5.006778] PPP MPPE Compression module registered
[    5.008871] NET: Registered protocol family 24
[    5.010958] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    5.013234] usbcore: registered new interface driver kaweth
[    5.015802] usbcore: registered new interface driver r8152
[    5.018389] usbcore: registered new interface driver cdc_phonet
[    5.020610] parport0: cannot grant exclusive access for device ks0108
[    5.023161] ks0108: ERROR: parport didn't register new device
[    5.025900] cfag12864b: ERROR: ks0108 is not initialized
[    5.028474] cfag12864bfb: ERROR: cfag12864b is not initialized
[    5.032765] aoe: AoE v85 initialised.
[    5.034955] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.037822] ehci-pci: EHCI PCI platform driver
[    5.039056] ehci-platform: EHCI generic platform driver
[    5.040627] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.042299] ohci-pci: OHCI PCI platform driver
[    5.043600] ohci-platform: OHCI generic platform driver
[    5.045224] driver u132_hcd
[    5.047001] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.050641] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.057585] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    5.061313] 4Warning! fotg210_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    5.068248] usbcore: registered new interface driver cdc_acm
[    5.071628] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    5.077308] usbcore: registered new interface driver usblp
[    5.079054] usbcore: registered new interface driver cdc_wdm
[    5.080698] usbcore: registered new interface driver usbtmc
[    5.082344] usbcore: registered new interface driver usb-storage
[    5.083628] usbcore: registered new interface driver ums-alauda
[    5.085186] usbcore: registered new interface driver ums-cypress
[    5.086807] usbcore: registered new interface driver ums_eneub6250
[    5.088367] usbcore: registered new interface driver ums-jumpshot
[    5.089855] usbcore: registered new interface driver ums-sddr09
[    5.091309] usbcore: registered new interface driver ums-usbat
[    5.092789] usbcore: registered new interface driver mdc800
[    5.095100] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    5.098140] usbcore: registered new interface driver microtekX6
[    5.100493] usbcore: registered new interface driver usbserial
[    5.102613] usbcore: registered new interface driver usbserial_generic
[    5.104776] usbserial: USB Serial support registered for generic
[    5.106999] usbcore: registered new interface driver aircable
[    5.109678] usbserial: USB Serial support registered for aircable
[    5.112632] usbcore: registered new interface driver ark3116
[    5.115323] usbserial: USB Serial support registered for ark3116
[    5.118294] usbcore: registered new interface driver belkin_sa
[    5.120153] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    5.122693] usbcore: registered new interface driver ch341
[    5.123973] usbserial: USB Serial support registered for ch341-uart
[    5.125390] usbcore: registered new interface driver cp210x
[    5.126805] usbserial: USB Serial support registered for cp210x
[    5.128650] usbcore: registered new interface driver cyberjack
[    5.131294] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    5.135471] usbcore: registered new interface driver cypress_m8
[    5.137726] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    5.140291] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    5.142815] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    5.145777] usbcore: registered new interface driver usb_debug
[    5.148460] usbserial: USB Serial support registered for debug
[    5.151218] usbcore: registered new interface driver digi_acceleport
[    5.153116] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    5.155729] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    5.158447] usbcore: registered new interface driver empeg
[    5.159999] usbserial: USB Serial support registered for empeg
[    5.161458] usbcore: registered new interface driver ftdi_sio
[    5.162861] usbserial: USB Serial support registered for FTDI USB Serial Device
[    5.164781] usbcore: registered new interface driver ipw
[    5.166056] usbserial: USB Serial support registered for IPWireless converter
[    5.167772] usbcore: registered new interface driver keyspan
[    5.169937] usbserial: USB Serial support registered for Keyspan - (without firmware)
[    5.172584] usbserial: USB Serial support registered for Keyspan 1 port adapter
[    5.175522] usbserial: USB Serial support registered for Keyspan 2 port adapter
[    5.179215] usbserial: USB Serial support registered for Keyspan 4 port adapter
[    5.183082] usbcore: registered new interface driver metro_usb
[    5.185851] usbserial: USB Serial support registered for Metrologic USB to Serial
[    5.189657] usbcore: registered new interface driver mos7840
[    5.192279] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    5.195874] usbcore: registered new interface driver mxuport
[    5.197283] usbserial: USB Serial support registered for MOXA UPort
[    5.199390] usbcore: registered new interface driver navman
[    5.201171] usbserial: USB Serial support registered for navman
[    5.203981] usbcore: registered new interface driver omninet
[    5.206699] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[    5.210607] usbcore: registered new interface driver opticon
[    5.213337] usbserial: USB Serial support registered for opticon
[    5.216133] usbcore: registered new interface driver option
[    5.218357] usbserial: USB Serial support registered for GSM modem (1-port)
[    5.220033] usbcore: registered new interface driver qcaux
[    5.221423] usbserial: USB Serial support registered for qcaux
[    5.223681] usbcore: registered new interface driver qcserial
[    5.226458] usbserial: USB Serial support registered for Qualcomm USB modem
[    5.229354] usbcore: registered new interface driver usb_serial_simple
[    5.232092] usbserial: USB Serial support registered for zio
[    5.234250] usbserial: USB Serial support registered for funsoft
[    5.236556] usbserial: USB Serial support registered for flashloader
[    5.238280] usbserial: USB Serial support registered for vivopay
[    5.239657] usbserial: USB Serial support registered for moto_modem
[    5.241745] usbserial: USB Serial support registered for hp4x
[    5.243999] usbserial: USB Serial support registered for suunto
[    5.245584] usbserial: USB Serial support registered for siemens_mpi
[    5.246997] usbcore: registered new interface driver spcp8x5
[    5.248229] usbserial: USB Serial support registered for SPCP8x5
[    5.250686] usbcore: registered new interface driver ssu100
[    5.252857] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    5.256939] usbcore: registered new interface driver visor
[    5.259281] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    5.263216] usbserial: USB Serial support registered for Sony Clie 5.0
[    5.266247] usbserial: USB Serial support registered for Sony Clie 3.5
[    5.269106] usbcore: registered new interface driver wishbone_serial
[    5.271921] usbserial: USB Serial support registered for wishbone_serial
[    5.274225] usbcore: registered new interface driver whiteheat
[    5.275752] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    5.279066] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    5.281494] usbcore: registered new interface driver xsens_mt
[    5.283329] usbserial: USB Serial support registered for xsens_mt
[    5.285610] usbcore: registered new interface driver zte_ev
[    5.287123] usbserial: USB Serial support registered for zte_ev
[    5.289731] usbcore: registered new interface driver appledisplay
[    5.292044] usbcore: registered new interface driver cytherm
[    5.294238] usbcore: registered new interface driver emi26 - firmware loader
[    5.296847] usbcore: registered new interface driver emi62 - firmware loader
[    5.299079] driver ftdi-elan
[    5.300378] usbcore: registered new interface driver ftdi-elan
[    5.301749] usbcore: registered new interface driver idmouse
[    5.302978] usbcore: registered new interface driver iowarrior
[    5.304252] usbcore: registered new interface driver usblcd
[    5.305493] usbcore: registered new interface driver usbled
[    5.306719] usbcore: registered new interface driver legousbtower
[    5.308025] usbcore: registered new interface driver rio500
[    5.309271] usbcore: registered new interface driver uss720
[    5.310518] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    5.312532] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    5.314207] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    5.315878] uss720: If you just want to connect to a printer, use usblp instead
[    5.317697] usbcore: registered new interface driver sisusb
[    5.319244] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.321828] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.323217] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.369532] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    5.372520] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.376275] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    5.378423] usbcore: registered new interface driver appletouch
[    5.379291] usbcore: registered new interface driver xpad
[    5.380128] mk712: device not present
[    5.380179] usbcore: registered new interface driver usbtouchscreen
[    5.380671] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    5.380718] usbcore: registered new interface driver ati_remote2
[    5.380753] cm109: Keymap for Komunikate KIP1000 phone loaded
[    5.380794] usbcore: registered new interface driver cm109
[    5.380800] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    5.380939] usbcore: registered new interface driver keyspan_remote
[    5.381044] usbcore: registered new interface driver powermate
[    5.381059] wistron_btns: System unknown
[    5.381100] i2c /dev entries driver
[    5.381213] i2c-parport: adapter type unspecified
[    5.381213] i2c-parport-light: adapter type unspecified
[    5.381251] usbcore: registered new interface driver i2c-tiny-usb
[    5.381255] scx200_i2c: no SCx200 gpio pins available
[    5.381305] pps_ldisc: PPS line discipline registered
[    5.381306] pps_parport: parallel port PPS client
[    5.381311] parport0: cannot grant exclusive access for device pps_parport
[    5.381312] pps_parport: couldn't register with parport0
[    5.381367] Driver for 1-wire Dallas network protocol.
[    5.381444] usbcore: registered new interface driver DS9490R
[    5.381447] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.381492] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    5.381605] power_supply test_ac: uevent
[    5.381608] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    5.381620] power_supply test_ac: prop ONLINE=1
[    5.381660] power_supply test_ac: power_supply_changed
[    5.381688] power_supply test_ac: power_supply_changed_work
[    5.381692] power_supply test_ac: power_supply_update_gen_leds 1
[    5.381703] power_supply test_ac: uevent
[    5.381704] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    5.381709] power_supply test_ac: prop ONLINE=1
[    5.381774] power_supply test_battery: uevent
[    5.381775] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    5.381779] power_supply test_battery: prop STATUS=Discharging
[    5.381781] power_supply test_battery: prop CHARGE_TYPE=Fast
[    5.381783] power_supply test_battery: prop HEALTH=Good
[    5.381784] power_supply test_battery: prop PRESENT=1
[    5.381786] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    5.381788] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    5.381789] power_supply test_battery: prop CHARGE_FULL=100
[    5.381791] power_supply test_battery: prop CHARGE_NOW=50
[    5.381792] power_supply test_battery: prop CAPACITY=50
[    5.381794] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    5.381795] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    5.381797] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    5.381798] power_supply test_battery: prop MODEL_NAME=Test battery
[    5.381800] power_supply test_battery: prop MANUFACTURER=Linux
[    5.381801] power_supply test_battery: prop SERIAL_NUMBER=3.14.0-rc5-00009-g4dea8e4
[    5.381803] power_supply test_battery: prop TEMP=26
[    5.381804] power_supply test_battery: prop VOLTAGE_NOW=3300
[    5.381956] power_supply test_battery: power_supply_changed
[    5.381965] power_supply test_battery: power_supply_changed_work
[    5.381968] power_supply test_battery: power_supply_update_bat_leds 2
[    5.381972] power_supply test_battery: uevent
[    5.381973] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    5.381983] power_supply test_battery: prop STATUS=Discharging
[    5.381984] power_supply test_battery: prop CHARGE_TYPE=Fast
[    5.381988] power_supply test_battery: prop HEALTH=Good
[    5.381989] power_supply test_battery: prop PRESENT=1
[    5.381991] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    5.381993] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    5.381995] power_supply test_battery: prop CHARGE_FULL=100
[    5.381996] power_supply test_battery: prop CHARGE_NOW=50
[    5.381998] power_supply test_battery: prop CAPACITY=50
[    5.381999] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    5.382001] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    5.382002] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    5.382004] power_supply test_battery: prop MODEL_NAME=Test battery
[    5.382005] power_supply test_battery: prop MANUFACTURER=Linux
[    5.382007] power_supply test_battery: prop SERIAL_NUMBER=3.14.0-rc5-00009-g4dea8e4
[    5.382008] power_supply test_battery: prop TEMP=26
[    5.382009] power_supply test_battery: prop VOLTAGE_NOW=3300
[    5.382052] power_supply test_usb: uevent
[    5.382052] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    5.382056] power_supply test_usb: prop ONLINE=1
[    5.382064] power_supply test_usb: power_supply_changed
[    5.382078] power_supply test_usb: power_supply_changed_work
[    5.382082] power_supply test_usb: power_supply_update_gen_leds 1
[    5.382085] power_supply test_usb: uevent
[    5.382086] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    5.382089] power_supply test_usb: prop ONLINE=1
[    5.383489] pc87360: PC8736x not detected, module not inserted
[    5.383978] Bluetooth: Virtual HCI driver ver 1.4
[    5.538244] Bluetooth: HCI UART driver ver 2.2
[    5.539536] Bluetooth: HCI H4 protocol initialized
[    5.540929] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    5.542672] usbcore: registered new interface driver bcm203x
[    5.544321] usbcore: registered new interface driver bpa10x
[    5.545838] usbcore: registered new interface driver bfusb
[    5.559827] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    5.563255] CAPI 2.0 started up with major 68 (middleware)
[    5.565129] dss1_divert module successfully installed
[    5.566923] gigaset: Driver for Gigaset 307x (debug build)
[    5.568720] gigaset: Kernel CAPI interface
[    5.570603] usbcore: registered new interface driver usb_gigaset
[    5.572189] usb_gigaset: USB Driver for Gigaset 307x using M105
[    5.576403] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    5.582360] usbcore: registered new interface driver usbhid
[    5.585194] usbhid: USB HID core driver
[    5.587641] oprofile: using timer interrupt.
[    5.589959] NET: Registered protocol family 26
[    5.592241] netem: version 1.3
[    5.593885] u32 classifier
[    5.595415]     Performance counters on
[    5.597331]     input device check on
[    5.599287] Netfilter messages via NETLINK v0.30.
[    5.600682] nfnl_acct: registering with nfnetlink.
[    5.601857] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    5.603427] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
[    5.606560] xt_time: kernel timezone is -0000
[    5.608599] ip_set: protocol 6
[    5.610285] IPVS: Registered protocols (TCP, UDP, SCTP, AH)
[    5.612013] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    5.613906] IPVS: Each connection entry needs 256 bytes at least
[    5.616864] IPVS: Creating netns size=1356 id=0
[    5.619360] IPVS: ipvs loaded.
[    5.620155] IPVS: [rr] scheduler registered.
[    5.621169] IPVS: [wrr] scheduler registered.
[    5.622193] IPVS: [lc] scheduler registered.
[    5.623203] IPVS: [wlc] scheduler registered.
[    5.624895] IPVS: [lblc] scheduler registered.
[    5.627027] IPVS: [lblcr] scheduler registered.
[    5.629132] IPVS: [dh] scheduler registered.
[    5.631317] IPVS: [nq] scheduler registered.
[    5.633322] ipip: IPv4 over IPv4 tunneling driver
[    5.636224] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.639382] arp_tables: (C) 2002 David S. Miller
[    5.641568] TCP: cubic registered
[    5.643408] NET: Registered protocol family 17
[    5.645473] NET: Registered protocol family 15
[    5.647807] NET: Registered protocol family 5
[    5.649939] NET: Registered protocol family 9
[    5.651101] X25: Linux Version 0.2
[    5.652850] can: controller area network core (rev 20120528 abi 9)
[    5.655683] NET: Registered protocol family 29
[    5.657795] can: raw protocol (rev 20120528)
[    5.659743] can: netlink gateway (rev 20130117) max_hops=1
[    5.662126] IrCOMM protocol (Dag Brattli)
[    5.670299] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.671609] Bluetooth: BNEP filters: protocol
[    5.672650] Bluetooth: BNEP socket layer initialized
[    5.673776] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[    5.674913] Bluetooth: CMTP socket layer initialized
[    5.676025] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    5.679822] Bluetooth: HIDP socket layer initialized
[    5.683860] NET: Registered protocol family 33
[    5.686828] Key type rxrpc registered
[    5.688672] Key type rxrpc_s registered
[    5.690693] cryptomgr_probe (111) used greatest stack depth: 6748 bytes left
[    5.690726] RxRPC: Registered security type 2 'rxkad'
[    5.690756] l2tp_core: L2TP core driver, V2.0
[    5.690769] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[    5.690793] l2tp_debugfs: L2TP debugfs support
[    5.690794] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    5.690927] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    5.690976] NET: Registered protocol family 12
[    5.691013] NET: Registered protocol family 35
[    5.691107] 8021q: 802.1Q VLAN Support v1.8
[    5.691635] DCCP: Activated CCID 2 (TCP-like)
[    5.691648] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    5.692019] sctp: Hash tables configured (established 1365 bind 1489)
[    5.692166] tipc: Activated (version 2.0.0)
[    5.693601] NET: Registered protocol family 30
[    5.694182] tipc: Started in single node mode
[    5.694415] NET: Registered protocol family 37
[    5.694550] Key type dns_resolver registered
[    5.694591] Key type ceph registered
[    5.694974] libceph: loaded (mon/osd proto 15/24)
[    5.695448] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility version 15) loaded
[    5.695450] openvswitch: Open vSwitch switching datapath
[    5.695668] mpls_gso: MPLS GSO support
[    5.696312]
[    5.696312] printing PIC contents
[    5.696330] ... PIC  IMR: ffff
[    5.696340] ... PIC  IRR: 1053
[    5.696357] ... PIC  ISR: 0000
[    5.696366] ... PIC ELCR: 0c00
[    5.696389] printing local APIC contents on CPU#0/0:
[    5.696405] ... APIC ID:      00000000 (0)
[    5.696411] ... APIC VERSION: 00050014
[    5.696418] ... APIC TASKPRI: 00000000 (00)
[    5.696424] ... APIC PROCPRI: 00000000
[    5.696430] ... APIC LDR: 01000000
[    5.696436] ... APIC DFR: ffffffff
[    5.696441] ... APIC SPIV: 000001ff
[    5.696442] ... APIC ISR field:
[    5.696486] 0000000000000000000000000000000000000000000000000000000000000000
[    5.696487] ... APIC TMR field:
[    5.696528] 0000000000000000000000000000000000000000000000000000000000000000
[    5.696529] ... APIC IRR field:
[    5.696569] 0000000000000000000000000000000000000000000000000000000000000000
[    5.696580] ... APIC ESR: 00000000
[    5.696590] ... APIC ICR: 000008fd
[    5.696591] ... APIC ICR2: 02000000
[    5.696597] ... APIC LVTT: 000200ef
[    5.696602] ... APIC LVTPC: 00010000
[    5.696608] ... APIC LVT0: 00010700
[    5.696613] ... APIC LVT1: 00000400
[    5.696619] ... APIC LVTERR: 000000fe
[    5.696625] ... APIC TMICT: 0003d0bf
[    5.696631] ... APIC TMCCT: 0001b473
[    5.696637] ... APIC TDCR: 00000003
[    5.696638]
[    5.696640] number of MP IRQ sources: 15.
[    5.696641] number of IO-APIC #0 registers: 24.
[    5.696642] testing the IO APIC.......................
[    5.696675] IO APIC #0......
[    5.696676] .... register #00: 00000000
[    5.696677] .......    : physical APIC id: 00
[    5.696678] .......    : Delivery Type: 0
[    5.696679] .......    : LTS          : 0
[    5.696680] .... register #01: 00170011
[    5.696681] .......     : max redirection entries: 17
[    5.696681] .......     : PRQ implemented: 0
[    5.696682] .......     : IO APIC version: 11
[    5.696683] .... register #02: 00000000
[    5.696684] .......     : arbitration: 00
[    5.696685] .... IRQ redirection table:
[    5.696707] 1    0    0   0   0    0    0    00
[    5.696729] 0    0    0   0   0    1    1    31
[    5.696753] 0    0    0   0   0    1    1    30
[    5.696763] 0    0    0   0   0    1    1    33
[    5.696772] 1    0    0   0   0    1    1    34
[    5.696781] 1    1    0   0   0    1    1    35
[    5.696790] 0    0    0   0   0    1    1    36
[    5.696822] 0    0    0   0   0    1    1    37
[    5.696843] 0    0    0   0   0    1    1    38
[    5.696863] 0    1    0   0   0    1    1    39
[    5.696884] 1    1    0   0   0    1    1    3A
[    5.696904] 1    1    0   0   0    1    1    3B
[    5.696925] 0    0    0   0   0    1    1    3C
[    5.696946] 0    0    0   0   0    1    1    3D
[    5.696967] 0    0    0   0   0    1    1    3E
[    5.696987] 0    0    0   0   0    1    1    3F
[    5.697008] 1    0    0   0   0    0    0    00
[    5.697028] 1    0    0   0   0    0    0    00
[    5.697049] 1    0    0   0   0    0    0    00
[    5.697069] 1    0    0   0   0    0    0    00
[    5.697090] 1    0    0   0   0    0    0    00
[    5.697110] 1    0    0   0   0    0    0    00
[    5.697131] 1    0    0   0   0    0    0    00
[    5.697151] 1    0    0   0   0    0    0    00
[    5.697152] IRQ to pin mappings:
[    5.697157] IRQ0 -> 0:2
[    5.697159] IRQ1 -> 0:1
[    5.697162] IRQ3 -> 0:3
[    5.697164] IRQ4 -> 0:4
[    5.697166] IRQ5 -> 0:5
[    5.697168] IRQ6 -> 0:6
[    5.697170] IRQ7 -> 0:7
[    5.697172] IRQ8 -> 0:8
[    5.697174] IRQ9 -> 0:9
[    5.697177] IRQ10 -> 0:10
[    5.697179] IRQ11 -> 0:11
[    5.697181] IRQ12 -> 0:12
[    5.697184] IRQ13 -> 0:13
[    5.697186] IRQ14 -> 0:14
[    5.697188] IRQ15 -> 0:15
[    5.697189] .................................... done.
[    5.697190] Using IPI Shortcut mode
[    5.889704] Loading compiled-in X.509 certificates
[    5.890857] Problem loading in-kernel X.509 certificate (-74)
[    5.892573] bio: create slab <bio-1> at 1
[    5.894338] Btrfs loaded, debug=on, assert=on, integrity-checker=on
[    5.897689] Key type trusted registered
[    5.900830] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.903528] EDD information not available.
[    5.905654] debug: unmapping init [mem 0x82039000-0x82218fff]
[    5.908755] Write protecting the kernel text: 11652k
[    5.911243] Write protecting the kernel read-only data: 4080k
[    5.913835] Failed to execute /init (error -8)
[    5.916046] Starting init: /sbin/init exists but couldn't execute it (error -8)
[    5.918907] Starting init: /etc/init exists but couldn't execute it (error -13)
[    5.921981] Starting init: /bin/sh exists but couldn't execute it (error -8)
[    5.924289] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
[    5.928232] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-00009-g4dea8e4 #6
[    5.928232] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.928232]  00000000 00000000 8f037f74 81b48a98 8f803770 8f037f98 81b3d3fa 81e07204
[    5.928232]  82233ec0 81df9b08 81df98af 8f803770 81f717e0 00000000 8f037fac 81b38dfc
[    5.928232]  81df9cd0 81df989f fffffff8 8f036000 81b5fd3b 81b38d30 00000000 00000000
[    5.928232] Call Trace:
[    5.928232]  [<81b48a98>] dump_stack+0x48/0x60
[    5.928232]  [<81b3d3fa>] panic+0x82/0x180
[    5.928232]  [<81b38dfc>] kernel_init+0xcc/0xe0
[    5.928232]  [<81b5fd3b>] ret_from_kernel_thread+0x1b/0x30
[    5.928232]  [<81b38d30>] ? rest_init+0xc0/0xc0
[    5.928232] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x80000000-0x907fdfff)
