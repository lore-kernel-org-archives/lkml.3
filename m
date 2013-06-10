Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3FJBzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 21:55:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:54271 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3FJBzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 21:55:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,833,1363158000"; 
   d="scan'208";a="347315095"
Date: Mon, 10 Jun 2013 09:55:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [inconsistent HARDIRQ usage] &dev->mode_config.idr_mutex at
 drm_mode_object_find()
Message-ID: <20130610015530.GA18906@localhost>
References: <20130606013518.GA9092@localhost>
 <51B038E3.30800@canonical.com>
 <20130606072856.GA32274@localhost>
 <51B427A4.9030805@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B427A4.9030805@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten,

Sorry for the delay!

On Sun, Jun 09, 2013 at 08:58:44AM +0200, Maarten Lankhorst wrote:
> Hey,
> 
> Op 06-06-13 09:28, Fengguang Wu schreef:
> > Hi Maarten,
> >
> > Thanks for the patch! I'll queue it for the tests.
> >
> > <snip>
> I haven't heard back from you yet, did it fix all lockdep issues you were having?
> If so I'll get it queued.

Booted 1000 kernels with the patch, I no longer see the
mutex_trylock() warning. However there is one single occurrence of
this warning. Not sure how relevant it is.

[  347.858442] =================================
[  347.858442] [ INFO: inconsistent lock state ]
[  347.858442] 3.9.0-rc5-00675-ga35505b #60 Not tainted
[  347.858442] ---------------------------------
[  347.858442] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  347.858442] umount/122 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  347.858442]  (&dev->mode_config.idr_mutex){?.+.+.}, at: [<ffffffff817a8aa2>] drm_mode_object_find+0xf2/0x110

Thanks,
Fengguang

PS. full dmesg.

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc5-00675-ga35505b (kbuild@cairo) (gcc version 4.7.2 (Debian 4.7.2-4) ) #60 SMP Mon Jun 10 03:33:41 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c00-0605/wfg:0day/.vmlinuz-a35505b46be17ab9c91d77bf0b47df477b7181e1-20130610063801-720-ant branch=wfg/0day noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-c00-0605/a35505b46be17ab9c91d77bf0b47df477b7181e1/vmlinuz-3.9.0-rc5-00675-ga35505b
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x035f3000, 0x035f3fff] PGTABLE
[    0.000000] BRK [0x035f4000, 0x035f4fff] PGTABLE
[    0.000000] BRK [0x035f5000, 0x035f5fff] PGTABLE
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
[    0.000000] BRK [0x035f6000, 0x035f6fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127440(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000de00000 s81216 r0 d21184 u1048576
[    0.000000] pcpu-alloc: s81216 r0 d21184 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c00-0605/wfg:0day/.vmlinuz-a35505b46be17ab9c91d77bf0b47df477b7181e1-20130610063801-720-ant branch=wfg/0day noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-c00-0605/a35505b46be17ab9c91d77bf0b47df477b7181e1/vmlinuz-3.9.0-rc5-00675-ga35505b
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 185596k/262136k available (15776k kernel code, 440k absent, 76100k reserved, 11623k data, 1052k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
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
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]             using two ww contexts:  ok  |
[    0.000000]           finish ww context twice:  ok  |
[    0.000000]                      unlock twice:  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 237 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3191.921 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.052000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.84 BogoMIPS (lpj=12767684)
[    0.057014] pid_max: default: 32768 minimum: 301
[    0.106687] Mount-cache hash table entries: 256
[    0.321096] Initializing cgroup subsys memory
[    0.340933] Initializing cgroup subsys net_cls
[    0.342856] Initializing cgroup subsys perf_event
[    0.345054] Initializing cgroup subsys net_prio
[    0.372848] mce: CPU supports 10 MCE banks
[    0.392674] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.392674] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.392674] tlb_flushall_shift: -1
[    0.444000] Freeing SMP alternatives: 32k freed
[    0.581205] ACPI: Core revision 20130117
[    3.466225] ACPI: All ACPI Tables successfully acquired
[    3.473112] ACPI: setting ELCR to 0200 (from 0c00)
[    3.580000] smpboot: SMP disabled
[    3.586453] Performance Events: 
[    3.588996] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    3.592225] no hardware sampling interrupt available.
[    3.594104] Broken PMU hardware detected, using software events only.
[    3.600376] Failed to access perfctr msr (MSR c0010004 is 0)
[    3.794354] Brought up 1 CPUs
[    3.796589] smpboot: Total of 1 processors activated (6383.84 BogoMIPS)
[    3.816000] CPU0 attaching NULL sched-domain.
[    3.848558] NMI watchdog: disabled (cpu0): hardware events not enabled
[    4.430352] xor: measuring software checksum speed
[    4.492430]    prefetch64-sse:   165.000 MB/sec
[    4.536381]    generic_sse:   166.000 MB/sec
[    4.540480] xor: using function: generic_sse (166.000 MB/sec)
[    4.641800] regulator-dummy: no parameters
[    4.660671] RTC time: 23:39:33, date: 06/09/13
[    4.710895] NET: Registered protocol family 16
[    4.890504] ACPI: bus type PCI registered
[    4.945877] PCI: Using configuration type 1 for base access
[    9.912000] [sched_delayed] sched: RT throttling activated
[    9.940972] bio: create slab <bio-0> at 0
[   10.048755] raid6: sse2x1      28 MB/s
[   10.116391] raid6: sse2x2      54 MB/s
[   10.184588] raid6: sse2x4      50 MB/s
[   10.185946] raid6: using algorithm sse2x2 (54 MB/s)
[   10.188685] raid6: using intx1 recovery algorithm
[   10.247439] ACPI: Added _OSI(Module Device)
[   10.252846] ACPI: Added _OSI(Processor Device)
[   10.255040] ACPI: Added _OSI(3.0 _SCP Extensions)
[   10.257001] ACPI: Added _OSI(Processor Aggregator Device)
[   10.507085] ACPI: EC: Look up EC in DSDT
[   14.621023] ACPI: Interpreter enabled
[   14.624746] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[   14.632592] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[   14.646621] ACPI: (supports S0 S3 S5)
[   14.648645] ACPI: Using PIC for interrupt routing
[   14.665444] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[   23.208000] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   23.221688] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[   23.224402] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   23.245182] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[   23.248466] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[   23.250262] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[   23.252336] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[   23.261409] PCI: root bus 00: using default resources
[   23.296557] PCI host bridge to bus 0000:00
[   23.308286] pci_bus 0000:00: root bus resource [bus 00-ff]
[   23.310279] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   23.312560] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[   23.321986] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   23.524272] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   23.564839] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   23.576449] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[   23.796493] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   23.808786] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   23.812534] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   23.853402] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   23.860441] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   23.872345] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[   23.896444] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[   23.937263] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   23.942873] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[   23.952340] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[   23.973666] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[   24.027273] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   24.033671] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[   24.040320] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[   24.072379] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[   24.156502] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   24.165488] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[   24.170554] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[   24.276379] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   24.281793] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[   24.296377] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[   24.386184] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   24.392443] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[   24.405542] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[   24.516519] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   24.522625] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[   24.528335] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[   24.657063] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   24.661558] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[   24.666597] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[   24.772788] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   24.781327] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[   24.789624] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[   24.933365] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   24.937711] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[   25.057353] pci_bus 0000:00: on NUMA node 0
[   25.058572] ACPI _OSC control for PCIe not granted, disabling ASPM
[   26.385439] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   26.494092] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   26.605486] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   26.724556] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   26.826414] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   26.956000] ACPI: Enabled 16 GPEs in block 00 to 0F
[   26.965097] acpi root: \_SB_.PCI0 notify handler is installed
[   26.982235] Found 1 acpi root devices
[   27.176000] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[   27.176823] vgaarb: loaded
[   27.180360] vgaarb: bridge control possible 0000:00:02.0
[   27.246541] tps65010: version 2 May 2005
[   27.322062] tps65010: no chip?
[   27.449454] SCSI subsystem initialized
[   27.451261] ACPI: bus type ATA registered
[   27.461944] libata version 3.00 loaded.
[   27.492696] Linux video capture interface: v2.00
[   27.500867] pps_core: LinuxPPS API ver. 1 registered
[   27.502172] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   27.509215] PTP clock support registered
[   27.540449] wmi: Mapper loaded
[   27.574099] Advanced Linux Sound Architecture Driver Initialized.
[   27.581790] PCI: Using ACPI for IRQ routing
[   27.584701] PCI: pci_cache_line_size set to 64 bytes
[   27.590118] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   27.593663] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[   27.689637] Bluetooth: Core ver 2.16
[   27.694841] NET: Registered protocol family 31
[   27.696363] Bluetooth: HCI device and connection manager initialized
[   27.702151] Bluetooth: HCI socket layer initialized
[   27.705243] Bluetooth: L2CAP socket layer initialized
[   27.710509] Bluetooth: SCO socket layer initialized
[   27.733802] nfc: nfc_init: NFC Core ver 0.1
[   27.744512] NET: Registered protocol family 39
[   27.763104] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[   27.787168] Switching to clocksource hpet
[   27.813813] CE: hpet increased min_delta_ns to 5000 nsec
[   27.813813] CE: hpet increased min_delta_ns to 7500 nsec
[   27.970334] Warning: could not register annotated branches stats
[   49.871653] FS-Cache: Loaded
[   49.896769] pnp: PnP ACPI init
[   49.909818] ACPI: bus type PNP registered
[   49.982392] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   50.096968] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   50.199372] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   50.296246] pnp 00:03: [dma 2]
[   50.331012] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   50.509582] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   50.697463] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   51.286351] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   51.783322] pnp: PnP ACPI: found 7 devices
[   51.790566] ACPI: bus type PNP unregistered
[   53.359272] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   53.367604] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[   53.382374] NET: Registered protocol family 1
[   53.394673] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   53.403013] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   53.406344] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   53.414513] pci 0000:00:02.0: Boot video device
[   53.419153] PCI: CLS 0 bytes, default 64
[   53.550888] Unpacking initramfs...
[  197.923661] Freeing initrd memory: 23656k freed
[  198.627134] kvm: no hardware support
[  198.645810] Machine check injector initialized
[  198.695852] cryptomgr_test (21) used greatest stack depth: 6416 bytes left
[  198.750378] AVX or AES-NI instructions are not detected.
[  198.751816] AVX instructions are not detected.
[  198.827834] AVX instructions are not detected.
[  198.835157] AVX instructions are not detected.
[  198.838452] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[  198.886373] audit: initializing netlink socket (disabled)
[  198.894339] type=2000 audit(1370821356.888:1): initialized
[  200.791956] VFS: Disk quotas dquot_6.5.2
[  200.809534] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[  201.191895] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[  201.275140] ROMFS MTD (C) 2007 Red Hat, Inc.
[  201.309606] QNX4 filesystem 0.2.3 registered.
[  201.311011] fuse init (API version 7.21)
[  201.438198] JFS: nTxBlock = 1635, nTxLock = 13080
[  201.509442] SGI XFS with security attributes, large block/inode numbers, debug enabled
[  201.838631] NILFS version 2 loaded
[  201.839840] BeFS version: 0.9.3
[  202.113578] Btrfs loaded
[  202.831670] NET: Registered protocol family 38
[  202.842970] async_tx: api initialized (async)
[  202.883646] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[  202.893027] io scheduler noop registered
[  202.894418] io scheduler deadline registered (default)
[  203.491617] list_sort_test: start testing list_sort()
[  203.923274] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  203.925430] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[  203.931312] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[  203.933801] cpcihp_generic: not configured, disabling.
[  203.938657] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  203.941346] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[  203.996911] acpiphp: Slot [3] registered
[  204.019432] acpiphp: Slot [4] registered
[  204.046166] acpiphp: Slot [5] registered
[  204.063583] acpiphp: Slot [6] registered
[  204.079630] acpiphp: Slot [7] registered
[  204.095977] acpiphp: Slot [8] registered
[  204.113345] acpiphp: Slot [9] registered
[  204.131116] acpiphp: Slot [10] registered
[  204.147504] acpiphp: Slot [11] registered
[  204.167785] acpiphp: Slot [12] registered
[  204.191537] acpiphp: Slot [13] registered
[  204.217122] acpiphp: Slot [14] registered
[  204.233327] acpiphp: Slot [15] registered
[  204.249505] acpiphp: Slot [16] registered
[  204.265404] acpiphp: Slot [17] registered
[  204.281327] acpiphp: Slot [18] registered
[  204.305084] acpiphp: Slot [19] registered
[  204.331977] acpiphp: Slot [20] registered
[  204.357282] acpiphp: Slot [21] registered
[  204.373096] acpiphp: Slot [22] registered
[  204.387856] acpiphp: Slot [23] registered
[  204.403047] acpiphp: Slot [24] registered
[  204.422772] acpiphp: Slot [25] registered
[  204.440278] acpiphp: Slot [26] registered
[  204.455679] acpiphp: Slot [27] registered
[  204.470705] acpiphp: Slot [28] registered
[  204.497321] acpiphp: Slot [29] registered
[  204.534034] acpiphp: Slot [30] registered
[  204.559835] acpiphp: Slot [31] registered
[  204.840967] i2c-core: driver [adp8860_bl] using legacy suspend method
[  204.842700] i2c-core: driver [adp8860_bl] using legacy resume method
[  204.858324] i2c-core: driver [adp8870_bl] using legacy suspend method
[  204.859935] i2c-core: driver [adp8870_bl] using legacy resume method
[  204.899938] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[  204.915100] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[  204.994448] rivafb_setup START
[  205.061590] vmlfb: initializing
[  205.098609] hgafb: HGA card not detected.
[  205.101442] hgafb: probe of hgafb.0 failed with error -22
[  205.299173] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  205.310643] ACPI: Power Button [PWRF]
[  206.147287] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[  206.150494] Unable to map lapic to logical cpu number
[  213.009129] ERST DBG: ERST support is disabled.
[  219.807238] HDLC line discipline maxframe=4096
[  219.809540] N_HDLC line discipline registered.
[  219.813326] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  219.870862] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  220.250096] Cyclades driver 2.6
[  220.283606] MOXA Intellio family driver version 6.0k
[  220.310954] MOXA Smartio/Industio family driver version 2.0.5
[  220.327434] Initializing Nozomi driver 2.1d
[  220.347185] SyncLink GT
[  220.358421] SyncLink GT, tty major#245
[  220.363891] SyncLink GT no devices found
[  220.369091] SyncLink MultiPort driver $Revision: 4.38 $
[  222.287444] SyncLink MultiPort driver $Revision: 4.38 $, tty major#244
[  222.301030] SyncLink serial driver $Revision: 4.38 $
[  223.832762] INFO: rcu_sched detected stalls on CPUs/tasks:
[  223.832762] 
[  223.832762] INFO: Stall ended before state dump start
[  224.362348] SyncLink serial driver $Revision: 4.38 $, tty major#243
[  224.403449] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[  224.407271] ac.o: No PCI boards found.
[  224.419485] ac.o: For an ISA board you must supply memory and irq parameters.
[  224.442055] Non-volatile memory driver v1.3
[  224.502025] telclk_interrupt = 0xf non-mcpbl0010 hw.
[  224.510427] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[  224.524866] Hangcheck: Using getrawmonotonic().
[  224.550131] [drm] Initialized drm 1.1.0 20060810
[  224.571669] [drm] radeon kernel modesetting enabled.
[  224.832264] [TTM] Zone  kernel: Available graphics memory: 104642 kiB
[  224.834995] [TTM] Initializing pool allocator
[  224.847408] [TTM] Initializing DMA pool allocator
[  225.179047] [drm] fb mappable at 0x0
[  225.181300] [drm] vram aper at 0x0
[  225.182279] [drm] size 0
[  225.183132] [drm] fb depth is 24
[  225.195060] [drm]    pitch is 3840
[  225.259706] fbcon: cirrusdrmfb (fb0) is primary device
[  227.187992] Console: switching to colour frame buffer device 160x64
[  227.690846] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[  227.698063] cirrus 0000:00:02.0: registered panic notifier
[  227.713975] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
[  227.879242] lkdtm: No crash points registered, enable through debugfs
[  227.961336] i2c-core: driver [apds9802als] using legacy suspend method
[  227.965435] i2c-core: driver [apds9802als] using legacy resume method
[  227.983657] i2c-core: driver [tsl2550] using legacy suspend method
[  227.987628] i2c-core: driver [tsl2550] using legacy resume method
[  228.001797] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[  228.087009] Guest personality initialized and is inactive
[  228.121782] VMCI host device registered (name=vmci, major=10, minor=60)
[  228.136943] Initialized host personality
[  228.254048] Driver for timberdale has been successfully registered.
[  228.334930] Uniform Multi-Platform E-IDE driver
[  228.369707] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[  228.395091] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[  228.407022] pci 0000:00:01.1: setting latency timer to 64
[  228.421312]     ide0: BM-DMA at 0xc1e0-0xc1e7
[  228.436839]     ide1: BM-DMA at 0xc1e8-0xc1ef
[  228.441239] Probing IDE interface ide0...
[  229.066372] Probing IDE interface ide1...
[  229.814694] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[  230.514023] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[  230.533963] hdc: MWDMA2 mode selected
[  230.553943] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[  230.572342] ide1 at 0x170-0x177,0x376 on irq 15
[  230.926126] ide-gd driver 1.18
[  230.945807] ide-cd driver 5.00
[  231.059288] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[  231.077961] cdrom: Uniform CD-ROM driver Revision: 3.20
[  231.461847] rdac: device handler registered
[  231.539254] emc: device handler registered
[  231.542980] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[  231.575993] osst :I: Tape driver with OnStream support version 0.99.4
[  231.575993] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[  231.678340] SCSI Media Changer driver v0.25 
[  232.079848] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  232.607307] HSI/SSI char device loaded
[  232.798687] slcan: serial line CAN interface driver
[  233.006312] slcan: 10 dynamic interface channels.
[  233.323151] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[  233.560289] serio: i8042 KBD port at 0x60,0x64 irq 1
[  233.693235] serio: i8042 AUX port at 0x60,0x64 irq 12
[  233.894901] parkbd: no such parport
[  234.207101] mousedev: PS/2 mouse device common for all mice
[  234.442400] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[  234.854496] walkera0701: parport 0 does not exist
[  235.227024] I2O subsystem v1.325
[  235.424315] i2o: max drivers = 8
[  235.799480] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[  236.031089] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[  236.367817] I2O Configuration OSM v1.323
[  236.583254] I2O Bus Adapter OSM v1.317
[  236.785823] I2O SCSI Peripheral OSM v1.316
[  237.039924] I2O ProcFS OSM v1.316
[  237.241133] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[  238.001603] i2c-parport-light: adapter type unspecified
[  238.362305] saa7146: register extension 'Multimedia eXtension Board'
[  238.613939] saa7146: register extension 'hexium gemini'
[  238.815924] Zoran MJPEG board driver version 0.10.1
[  239.030121] Linux video codec intermediate layer: v0.2
[  239.259143] pps pps0: new PPS source ktimer
[  239.473094] pps pps0: ktimer PPS source registered
[  239.761269] pps_ldisc: PPS line discipline registered
[  239.986456] Driver for 1-wire Dallas network protocol.
[  240.234629] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  240.665547] i2c-core: driver [ds2782-battery] using legacy suspend method
[  240.858963] i2c-core: driver [ds2782-battery] using legacy resume method
[  241.213657] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[  241.453317] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[  241.701319] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[  241.882491] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[  242.101423] i2c i2c-0: Detection of w83781d chip failed at step 3
[  242.325549] i2c i2c-0: Detection of w83781d chip failed at step 3
[  242.529209] i2c i2c-0: Detection of w83781d chip failed at step 3
[  242.737289] i2c i2c-0: Detection of w83781d chip failed at step 3
[  242.973267] i2c i2c-0: Detection of w83781d chip failed at step 3
[  243.193263] i2c i2c-0: Detection of w83781d chip failed at step 3
[  243.389427] i2c i2c-0: Detection of w83781d chip failed at step 3
[  243.578633] i2c i2c-0: Detection of w83781d chip failed at step 3
[  243.849379] adm1021: detect failed, chip not detected!
[  244.085340] adm1021: detect failed, chip not detected!
[  244.317361] adm1021: detect failed, chip not detected!
[  244.541484] adm1021: detect failed, chip not detected!
[  244.745510] adm1021: detect failed, chip not detected!
[  244.949514] adm1021: detect failed, chip not detected!
[  245.145113] adm1021: detect failed, chip not detected!
[  245.341363] adm1021: detect failed, chip not detected!
[  245.537392] adm1021: detect failed, chip not detected!
[  246.342527] f71882fg: Not a Fintek device
[  246.550832] f71882fg: Not a Fintek device
[  247.012467]  (null): Unknown chip type, skipping
[  247.193470]  (null): Unknown chip type, skipping
[  248.469562] i2c i2c-0: MAX1619 detection failed at 0x18
[  248.653571] i2c i2c-0: MAX1619 detection failed at 0x19
[  248.833436] i2c i2c-0: MAX1619 detection failed at 0x1a
[  249.013659] i2c i2c-0: MAX1619 detection failed at 0x29
[  249.193536] i2c i2c-0: MAX1619 detection failed at 0x2a
[  249.369543] i2c i2c-0: MAX1619 detection failed at 0x2b
[  249.545540] i2c i2c-0: MAX1619 detection failed at 0x4c
[  249.717556] i2c i2c-0: MAX1619 detection failed at 0x4d
[  249.894237] i2c i2c-0: MAX1619 detection failed at 0x4e
[  250.145531] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[  250.329256] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[  250.513595] i2c i2c-0: amc6821_detect called.
[  250.605400] i2c i2c-0: amc6821: detection failed at 0x18.
[  250.755472] i2c i2c-0: amc6821_detect called.
[  250.901387] i2c i2c-0: amc6821: detection failed at 0x19.
[  251.045544] i2c i2c-0: amc6821_detect called.
[  251.185536] i2c i2c-0: amc6821: detection failed at 0x1a.
[  251.325496] i2c i2c-0: amc6821_detect called.
[  251.465473] i2c i2c-0: amc6821: detection failed at 0x2c.
[  251.605102] i2c i2c-0: amc6821_detect called.
[  251.749531] i2c i2c-0: amc6821: detection failed at 0x2d.
[  251.885569] i2c i2c-0: amc6821_detect called.
[  252.013599] i2c i2c-0: amc6821: detection failed at 0x2e.
[  252.149510] i2c i2c-0: amc6821_detect called.
[  252.289436] i2c i2c-0: amc6821: detection failed at 0x4c.
[  252.425420] i2c i2c-0: amc6821_detect called.
[  252.565608] i2c i2c-0: amc6821: detection failed at 0x4d.
[  252.689499] i2c i2c-0: amc6821_detect called.
[  252.821089] i2c i2c-0: amc6821: detection failed at 0x4e.
[  253.089460] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[  253.195064] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[  253.343706] intel_powerclamp: Intel powerclamp does not run on family 6 model 2
[  253.467667] md: linear personality registered for level -1
[  253.577052] md: raid0 personality registered for level 0
[  253.698383] md: raid10 personality registered for level 10
[  253.812909] md: raid6 personality registered for level 6
[  253.943099] md: raid5 personality registered for level 5
[  254.054279] md: raid4 personality registered for level 4
[  254.173238] md: multipath personality registered for level -4
[  254.289168] md: faulty personality registered for level -5
[  254.505885] device-mapper: uevent: version 1.0.3
[  254.723942] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[  254.978964] device-mapper: dm-log-userspace: version 1.1.0 loaded
[  255.102866] Bluetooth: Virtual HCI driver ver 1.3
[  255.256076] Bluetooth: HCI UART driver ver 2.2
[  255.405195] Bluetooth: HCI H4 protocol initialized
[  255.548892] Bluetooth: HCI BCSP protocol initialized
[  255.621827] Bluetooth: HCILL protocol initialized
[  255.695993] Bluetooth: HCIATH3K protocol initialized
[  255.871489] cpuidle: using governor ladder
[  256.034778] cpuidle: using governor menu
[  256.319170] leds_ss4200: no LED devices found
[  256.693939] cs5535-clockevt: Could not allocate MFGPT timer
[  256.862963] hidraw: raw HID events driver (C) Jiri Kosina
[  257.174396] panel: driver version 0.9.5 not yet registered
[  257.711864] Loading crystalhd 0.9.27
[  257.973955] input: Speakup as /devices/virtual/input/input2
[  258.155816] evbug: Connected device: input2 (Speakup at speakup/input0)
[  258.391264] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[  258.576047] speakup 3.1.6: initialized
[  258.743231] synth name on entry is: (null)
[  258.932010] i2c-core: driver [cptm1217] using legacy suspend method
[  259.105460] i2c-core: driver [cptm1217] using legacy resume method
[  259.451662] ashmem: initialized
[  259.654033] logger: created 256K log 'log_main'
[  259.863105] logger: created 256K log 'log_events'
[  260.071888] logger: created 256K log 'log_radio'
[  260.291156] logger: created 256K log 'log_system'
[  260.591814] asus_wmi: Asus Management GUID not found
[  260.683124] asus_wmi: Management GUID not found
[  261.063837] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
[  261.250953] dell_wmi_aio: No known WMI GUID found
[  261.442137] acer_wmi: Acer Laptop ACPI-WMI Extras
[  261.631626] acer_wmi: No or unsupported WMI interface, unable to load
[  261.825029] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[  262.029409] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Bochs, please report, aborting!
[  262.262764] fujitsu_laptop: driver 0.6.0 successfully loaded
[  262.438296] fujitsu_tablet: Unknown (using defaults)
[  262.651441] msi_wmi: This machine doesn't have neither MSI-hotkeys nor backlight through WMI
[  262.875081] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
[  263.854912] no UART detected at 0x1
[  264.474213] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[  265.055360] ASIHPI driver 4.10.01
[  266.841213] pktgen: Packet Generator for packet performance testing. Version: 2.74
[  267.159836] netem: version 1.3
[  267.407857] NET: Registered protocol family 15
[  267.683648] Ebtables v2.0 registered
[  268.051544] NET: Registered protocol family 4
[  268.283407] NET: Registered protocol family 9
[  268.493199] X.25 for Linux Version 0.2
[  268.730075] can: controller area network core (rev 20120528 abi 9)
[  269.007909] NET: Registered protocol family 29
[  269.235265] can: raw protocol (rev 20120528)
[  269.457001] can: netlink gateway (rev 20130117) max_hops=1
[  269.695646] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[  269.910318] Bluetooth: BNEP socket layer initialized
[  270.098139] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[  270.290206] Bluetooth: HIDP socket layer initialized
[  270.473648] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[  270.830362] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[  271.058618] NET: Registered protocol family 12
[  271.302864] NET: Registered protocol family 35
[  271.626609] 9pnet: Installing 9P2000 support
[  271.923743] NET: Registered protocol family 36
[  272.053652] batman_adv: B.A.T.M.A.N. advanced 2013.1.0 (compatibility version 14) loaded
[  272.162735] openvswitch: Open vSwitch switching datapath
[  272.379808] 
[  272.379808] printing PIC contents
[  272.759968] ... PIC  IMR: 2d78
[  272.763161] ... PIC  IRR: 0011
[  273.197474] ... PIC  ISR: 0000
[  273.403971] ... PIC ELCR: 0200
[  273.697757] registered taskstats version 1
[  273.921133] raid6test: testing the 4-disk case...
[  274.161138] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  274.374994] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
[  274.606853] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
[  274.813965] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
[  275.038161] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
[  275.258816] raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
[  275.466039] raid6test: testing the 5-disk case...
[  275.692336] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  275.898453] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  276.111838] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
[  276.287861] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
[  276.386403] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  276.574900] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
[  276.791832] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
[  276.986203] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
[  277.198148] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
[  277.409917] raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
[  277.530085] raid6test: testing the 11-disk case...
[  277.654066] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  277.759438] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  277.927793] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[  278.126890] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[  278.323650] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[  278.530698] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[  278.726960] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[  278.919191] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[  279.106279] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
[  279.286808] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
[  279.475596] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  279.649165] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[  279.838228] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[  280.007041] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[  280.183763] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[  280.354569] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[  280.471163] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[  280.619289] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
[  280.789180] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
[  280.949878] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[  281.102885] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[  281.263453] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[  281.409487] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[  281.499804] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[  281.647491] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[  281.791627] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
[  281.935856] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
[  282.090204] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[  282.222024] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[  282.363372] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[  282.501423] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[  282.642951] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[  282.789794] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
[  282.936898] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
[  283.078973] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[  283.231892] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[  283.374257] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[  283.521226] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[  283.659868] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
[  283.782851] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
[  283.927197] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[  284.054851] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[  284.190643] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[  284.344946] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
[  284.483615] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
[  284.552346] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[  284.658875] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[  284.794676] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
[  284.934340] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
[  285.070624] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[  285.207522] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
[  285.346575] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
[  285.486822] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
[  285.630553] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
[  285.778547] raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
[  285.926950] raid6test: testing the 12-disk case...
[  286.059901] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  286.199130] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  286.345383] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[  286.495624] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[  286.639253] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[  286.783793] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[  286.931069] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[  287.067077] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[  287.203473] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[  287.351033] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
[  287.487417] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
[  287.639929] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  287.789542] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[  287.935627] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[  288.080280] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[  288.230211] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[  288.371616] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[  288.511406] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[  288.650591] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[  288.782827] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
[  288.927413] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
[  289.066455] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[  289.206527] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[  289.351239] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[  289.491525] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[  289.627775] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[  289.779600] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[  289.874944] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[  289.945019] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
[  290.011544] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
[  290.081892] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[  290.213976] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[  290.351304] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[  290.467428] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[  290.602013] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[  290.722882] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[  290.847276] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
[  290.981422] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
[  291.103617] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[  291.232363] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[  291.355142] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[  291.489360] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[  291.612375] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[  291.733884] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
[  291.870041] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
[  291.997341] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[  292.133189] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[  292.258127] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[  292.391292] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[  292.517310] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
[  292.641453] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
[  292.777926] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[  292.913222] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[  293.037179] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[  293.171101] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
[  293.285609] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
[  293.419010] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[  293.553336] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[  293.676396] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
[  293.809351] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
[  293.934203] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[  294.055003] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
[  294.187163] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
[  294.303169] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
[  294.422936] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
[  294.543165] raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
[  294.677520] raid6test: testing the 16-disk case...
[  294.807887] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  294.933172] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  295.067163] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[  295.191682] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[  295.315399] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[  295.449906] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[  295.577283] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[  295.705506] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[  295.834128] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[  295.970531] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
[  296.090456] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
[  296.229333] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
[  296.351816] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
[  296.477770] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P)  OK
[  296.613419] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q)  OK
[  296.742846] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  296.867333] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[  296.999237] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[  297.133564] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[  297.258365] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[  297.391208] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[  297.514557] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[  297.637862] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[  297.772355] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
[  297.897599] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
[  298.034620] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
[  298.161941] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
[  298.287767] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P)  OK
[  298.409788] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q)  OK
[  298.531393] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[  298.653243] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[  298.771790] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[  298.894952] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[  299.016355] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[  299.148323] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[  299.273177] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[  299.394318] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
[  299.515028] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
[  299.637150] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
[  299.758102] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
[  299.878526] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P)  OK
[  299.998323] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q)  OK
[  300.119551] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[  300.253283] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[  300.363545] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[  300.483518] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[  300.610305] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[  300.727353] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[  300.861792] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
[  300.992650] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
[  301.122326] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
[  301.239051] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
[  301.353378] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P)  OK
[  301.479594] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q)  OK
[  301.603331] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[  301.723503] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[  301.850466] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[  301.963479] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[  302.087301] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[  302.229064] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
[  302.356775] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
[  302.482738] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
[  302.609455] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
[  302.735584] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P)  OK
[  302.861032] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q)  OK
[  302.984963] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[  303.111664] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[  303.233031] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[  303.355525] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[  303.481012] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
[  303.611289] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
[  303.719825] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
[  303.783662] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
[  303.862505] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P)  OK
[  303.986801] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q)  OK
[  304.111591] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[  304.252526] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[  304.379324] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[  304.495849] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
[  304.630470] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
[  304.747307] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
[  304.878690] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
[  304.995880] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P)  OK
[  305.115026] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q)  OK
[  305.243481] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[  305.373080] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[  305.491543] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
[  305.626552] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
[  305.755113] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
[  305.883056] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
[  306.010312] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P)  OK
[  306.138526] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q)  OK
[  306.272985] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[  306.399313] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
[  306.519550] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
[  306.642921] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
[  306.763419] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
[  306.903216] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P)  OK
[  307.031072] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q)  OK
[  307.155376] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
[  307.286780] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
[  307.407816] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
[  307.550594] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
[  307.676928] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P)  OK
[  307.802606] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q)  OK
[  307.924012] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
[  308.055766] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
[  308.185640] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
[  308.313004] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P)  OK
[  308.449376] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q)  OK
[  308.581271] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
[  308.707627] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
[  308.808394] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P)  OK
[  308.918146] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q)  OK
[  309.039346] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
[  309.170967] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P)  OK
[  309.303261] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q)  OK
[  309.431485] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P)  OK
[  309.547432] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q)  OK
[  309.671840] raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q)  OK
[  309.793540] raid6test: 
[  309.914133] raid6test: complete (257 tests, 0 failures)
[  310.338146]   Magic number: 1:250:706
[  310.458434] tty ttySL122: hash matches
[  310.589995] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[  310.709702] EDD information not available.
[  310.906183] ALSA device list:
[  311.026184]   #0: Dummy 1
[  311.153927]   #1: Loopback 1
[  311.277938]   #2: MTPAV on parallel port at 0x378
[  312.230916] Freeing unused kernel memory: 1052k freed
[  323.435915] hostname (110) used greatest stack depth: 5080 bytes left
[  347.855138] BUG: soft lockup - CPU#0 stuck for 22s! [umount:122]
[  347.858442] irq event stamp: 4246
[  347.858442] hardirqs last  enabled at (4245): [<ffffffff81f5c430>] mutex_lock_nested+0x380/0x3b0
[  347.858442] hardirqs last disabled at (4246): [<ffffffff81f6232d>] common_interrupt+0x6d/0x72
[  347.858442] softirqs last  enabled at (4214): [<ffffffff810cfd42>] __do_softirq+0x242/0x2c0
[  347.858442] softirqs last disabled at (4175): [<ffffffff810cff23>] irq_exit+0x63/0xd0
[  347.858442] CPU 0 
[  347.858442] Pid: 122, comm: umount Not tainted 3.9.0-rc5-00675-ga35505b #60 Bochs Bochs
[  347.858442] RIP: 0010:[<ffffffff81f5c436>]  [<ffffffff81f5c436>] mutex_lock_nested+0x386/0x3b0
[  347.858442] RSP: 0018:ffff8800055ebb48  EFLAGS: 00000246
[  347.858442] RAX: ffff8800055c6840 RBX: ffffffff81130fdb RCX: 0000000000000006
[  347.858442] RDX: 0000000000000006 RSI: ffff8800055c6f20 RDI: 0000000000000246
[  347.858442] RBP: ffff8800055ebbd8 R08: 0000000000000000 R09: 0000000000000002
[  347.858442] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800055c6840
[  347.858442] R13: 0000000000000006 R14: 0000000000000007 R15: ffff8800055c6f20
[  347.858442] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[  347.858442] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  347.858442] CR2: 00007ffc9b7ce09c CR3: 00000000055a2000 CR4: 00000000000006f0
[  347.858442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  347.858442] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  347.858442] Process umount (pid: 122, threadinfo ffff8800055ea000, task ffff8800055c6840)
[  347.858442] Stack:
[  347.858442]  ffffffff811d3991 00007ffc9b7b7fff 00007ffc9b7b7fff 00007ffc9b7b8000
[  347.858442]  ffff8800055a2800 00007ffc9b7b7fff ffff88000b975a98 0000000000000246
[  347.858442]  ffff8800055ebb88 ffff8800055ebb88 0000000000000000 ffff8800055ebb88
[  347.858442] Call Trace:
[  347.858442]  [<ffffffff811d3991>] ? unlink_file_vma+0x41/0x70
[  347.858442]  [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
[  347.858442]  [<ffffffff811cbd07>] free_pgtables+0x47/0xe0
[  347.858442]  [<ffffffff811d33ef>] unmap_region+0xdf/0x110
[  347.858442]  [<ffffffff811d3749>] ? vma_rb_erase+0x1c9/0x210
[  347.858442]  [<ffffffff811d5692>] do_munmap+0x2c2/0x3d0
[  347.858442]  [<ffffffff811d6266>] mmap_region+0x596/0x660
[  347.858442]  [<ffffffff811d41e7>] ? vma_adjust+0x6a7/0x730
[  347.858442]  [<ffffffff81567455>] ? cap_mmap_addr+0x5/0x50
[  347.858442]  [<ffffffff811d6612>] do_mmap_pgoff+0x2e2/0x3b0
[  347.858442]  [<ffffffff811bfbc5>] vm_mmap_pgoff+0x75/0xb0
[  347.858442]  [<ffffffff812288d5>] ? fget+0x5/0x120
[  347.858442]  [<ffffffff811d489b>] sys_mmap_pgoff+0x13b/0x180
[  347.858442]  [<ffffffff8104f7d2>] sys_mmap+0x22/0x30
[  347.858442]  [<ffffffff81f62de9>] system_call_fastpath+0x16/0x1b
[  347.858442] Code: 80 47 08 01 48 f7 45 a8 00 02 00 00 75 12 48 8b 7d a8 57 9d 66 66 90 66 90 e8 97 4e 1d ff eb 10 e8 b0 4d 1d ff 48 8b 7d a8 57 9d <66> 66 90 66 90 48 89 df e8 0d 21 1d ff 41 83 6d 1c 01 48 83 c4 
[  347.858442] Kernel panic - not syncing: softlockup: hung tasks
[  347.858442] Pid: 122, comm: umount Not tainted 3.9.0-rc5-00675-ga35505b #60
[  347.858442] Call Trace:
[  347.858442]  <IRQ>  [<ffffffff81f41c56>] panic+0xc6/0x1d3
[  347.858442]  [<ffffffff81158052>] watchdog_timer_fn+0x172/0x1c0
[  347.858442]  [<ffffffff810f74b1>] __run_hrtimer+0x131/0x320
[  347.858442]  [<ffffffff81157ee0>] ? watchdog+0x30/0x30
[  347.858442]  [<ffffffff810f8349>] hrtimer_interrupt+0x129/0x230
[  347.858442]  [<ffffffff810fb054>] ? put_cred_rcu+0x74/0x80
[  347.858442]  [<ffffffff81164319>] ? rcu_process_callbacks+0x5a9/0x8c0
[  347.858442]  [<ffffffff8104d005>] timer_interrupt+0x15/0x20
[  347.858442]  [<ffffffff8115949d>] handle_irq_event_percpu+0x8d/0x2f0
[  347.858442]  [<ffffffff81159748>] handle_irq_event+0x48/0x70
[  347.858442]  [<ffffffff8115ce34>] handle_level_irq+0x124/0x130
[  347.858442]  [<ffffffff8104c74c>] handle_irq+0x4c/0x60
[  347.858442]  [<ffffffff81f648ca>] do_IRQ+0x5a/0xd0
[  347.858442]  [<ffffffff81f62332>] common_interrupt+0x72/0x72
[  347.858442]  <EOI>  [<ffffffff81130fdb>] ? mark_held_locks+0x10b/0x120
[  347.858442]  [<ffffffff81f5c436>] ? mutex_lock_nested+0x386/0x3b0
[  347.858442]  [<ffffffff811d3991>] ? unlink_file_vma+0x41/0x70
[  347.858442]  [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
[  347.858442]  [<ffffffff811cbd07>] free_pgtables+0x47/0xe0
[  347.858442]  [<ffffffff811d33ef>] unmap_region+0xdf/0x110
[  347.858442]  [<ffffffff811d3749>] ? vma_rb_erase+0x1c9/0x210
[  347.858442]  [<ffffffff811d5692>] do_munmap+0x2c2/0x3d0
[  347.858442]  [<ffffffff811d6266>] mmap_region+0x596/0x660
[  347.858442]  [<ffffffff811d41e7>] ? vma_adjust+0x6a7/0x730
[  347.858442]  [<ffffffff81567455>] ? cap_mmap_addr+0x5/0x50
[  347.858442]  [<ffffffff811d6612>] do_mmap_pgoff+0x2e2/0x3b0
[  347.858442]  [<ffffffff811bfbc5>] vm_mmap_pgoff+0x75/0xb0
[  347.858442]  [<ffffffff812288d5>] ? fget+0x5/0x120
[  347.858442]  [<ffffffff811d489b>] sys_mmap_pgoff+0x13b/0x180
[  347.858442]  [<ffffffff8104f7d2>] sys_mmap+0x22/0x30
[  347.858442]  [<ffffffff81f62de9>] system_call_fastpath+0x16/0x1b
[  347.858442] drm_kms_helper: panic occurred, switching back to text console
[  347.858442] 
[  347.858442] =================================
[  347.858442] [ INFO: inconsistent lock state ]
[  347.858442] 3.9.0-rc5-00675-ga35505b #60 Not tainted
[  347.858442] ---------------------------------
[  347.858442] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  347.858442] umount/122 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  347.858442]  (&dev->mode_config.idr_mutex){?.+.+.}, at: [<ffffffff817a8aa2>] drm_mode_object_find+0xf2/0x110
[  347.858442] {HARDIRQ-ON-W} state was registered at:
[  347.858442]   [<ffffffff81132eeb>] __lock_acquire+0x87b/0x1b00
[  347.858442]   [<ffffffff8113474a>] lock_acquire+0xda/0x140
[  347.858442]   [<ffffffff81f5c11c>] mutex_lock_nested+0x6c/0x3b0
[  347.858442]   [<ffffffff817a8107>] drm_mode_object_get+0x37/0x90
[  347.858442]   [<ffffffff817ab953>] drm_property_create+0x73/0x130
[  347.858442]   [<ffffffff817ae76c>] drm_mode_config_init+0x11c/0x180
[  347.858442]   [<ffffffff8184b3cb>] cirrus_modeset_init+0x1b/0x220
[  347.858442]   [<ffffffff8184a491>] cirrus_driver_load+0xd1/0x140
[  347.858442]   [<ffffffff817a5054>] drm_get_pci_dev+0x174/0x2c0
[  347.858442]   [<ffffffff8184b6e1>] cirrus_pci_probe+0xc1/0xe0
[  347.858442]   [<ffffffff81616586>] pci_device_probe+0x66/0xb0
[  347.858442]   [<ffffffff8193ae55>] driver_probe_device+0xe5/0x260
[  347.858442]   [<ffffffff8193b04e>] __driver_attach+0x7e/0xb0
[  347.858442]   [<ffffffff81938f49>] bus_for_each_dev+0x69/0xb0
[  347.858442]   [<ffffffff8193ab1e>] driver_attach+0x1e/0x20
[  347.858442]   [<ffffffff81939908>] bus_add_driver+0x108/0x290
[  347.858442]   [<ffffffff8193b9c0>] driver_register+0xc0/0x180
[  347.858442]   [<ffffffff81616364>] __pci_register_driver+0x64/0x70
[  347.858442]   [<ffffffff817a522c>] drm_pci_init+0x8c/0x110
[  347.858442]   [<ffffffff82b0e45f>] cirrus_init+0x32/0x3b
[  347.858442]   [<ffffffff82ad7f14>] do_one_initcall+0x7a/0x139
[  347.858442]   [<ffffffff82ad80db>] kernel_init_freeable+0x108/0x197
[  347.858442]   [<ffffffff81f2ad0e>] kernel_init+0xe/0xf0
[  347.858442]   [<ffffffff81f62d3c>] ret_from_fork+0x7c/0xb0
[  347.858442] irq event stamp: 4246
[  347.858442] hardirqs last  enabled at (4245): [<ffffffff81f5c430>] mutex_lock_nested+0x380/0x3b0
[  347.858442] hardirqs last disabled at (4246): [<ffffffff81f6232d>] common_interrupt+0x6d/0x72
[  347.858442] softirqs last  enabled at (4214): [<ffffffff810cfd42>] __do_softirq+0x242/0x2c0
[  347.858442] softirqs last disabled at (4175): [<ffffffff810cff23>] irq_exit+0x63/0xd0
[  347.858442] 
[  347.858442] other info that might help us debug this:
[  347.858442]  Possible unsafe locking scenario:
[  347.858442] 
[  347.858442]        CPU0
[  347.858442]        ----
[  347.858442]   lock(&dev->mode_config.idr_mutex);
[  347.858442]   <Interrupt>
[  347.858442]     lock(&dev->mode_config.idr_mutex);
[  347.858442] 
[  347.858442]  *** DEADLOCK ***
[  347.858442] 
[  347.858442] 4 locks held by umount/122:
[  347.858442]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff811bfba4>] vm_mmap_pgoff+0x54/0xb0
[  347.858442]  #1:  (&mapping->i_mmap_mutex){+.+.+.}, at: [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
[  347.858442]  #2:  (panic_lock){....+.}, at: [<ffffffff81f41bd3>] panic+0x43/0x1d3
[  347.858442]  #3:  (rcu_read_lock){.+.+.+}, at: [<ffffffff810fa575>] __atomic_notifier_call_chain+0x5/0xc0
[  347.858442] 
[  347.858442] stack backtrace:
[  347.858442] Pid: 122, comm: umount Not tainted 3.9.0-rc5-00675-ga35505b #60
[  347.858442] Call Trace:
[  347.858442]  <IRQ>  [<ffffffff81f4383b>] print_usage_bug+0x1f7/0x208
[  347.858442]  [<ffffffff81059eaf>] ? save_stack_trace+0x2f/0x50
[  347.858442]  [<ffffffff811303b0>] ? print_irq_inversion_bug+0x200/0x200
[  347.858442]  [<ffffffff81130db1>] mark_lock+0x171/0x290
[  347.858442]  [<ffffffff81132e42>] __lock_acquire+0x7d2/0x1b00
[  347.858442]  [<ffffffff811edc05>] ? deactivate_slab+0x615/0x680
[  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
[  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
[  347.858442]  [<ffffffff81059eaf>] ? save_stack_trace+0x2f/0x50
[  347.858442]  [<ffffffff8113474a>] lock_acquire+0xda/0x140
[  347.858442]  [<ffffffff817a8aa2>] ? drm_mode_object_find+0xf2/0x110
[  347.858442]  [<ffffffff81f5c11c>] mutex_lock_nested+0x6c/0x3b0
[  347.858442]  [<ffffffff817a8aa2>] ? drm_mode_object_find+0xf2/0x110
[  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
[  347.858442]  [<ffffffff81130fdb>] ? mark_held_locks+0x10b/0x120
[  347.858442]  [<ffffffff817a8aa2>] drm_mode_object_find+0xf2/0x110
[  347.858442]  [<ffffffff81796f88>] ? drm_crtc_helper_set_config+0x218/0xb50
[  347.858442]  [<ffffffff8184ab41>] cirrus_connector_best_encoder+0x31/0x50
[  347.858442]  [<ffffffff817972b5>] drm_crtc_helper_set_config+0x545/0xb50
[  347.858442]  [<ffffffff811312cd>] ? trace_hardirqs_off+0xd/0x10
[  347.858442]  [<ffffffff817aa8c1>] drm_mode_set_config_internal+0x31/0x70
[  347.858442]  [<ffffffff81794faf>] drm_fb_helper_restore_fbdev_mode+0x4f/0x80
[  347.858442]  [<ffffffff8179504a>] drm_fb_helper_panic+0x6a/0xb0
[  347.858442]  [<ffffffff810fa425>] notifier_call_chain+0x85/0xd0
[  347.858442]  [<ffffffff810fa5f3>] __atomic_notifier_call_chain+0x83/0xc0
[  347.858442]  [<ffffffff810fa575>] ? __atomic_notifier_call_chain+0x5/0xc0
[  347.858442]  [<ffffffff810fa646>] atomic_notifier_call_chain+0x16/0x20
[  347.858442]  [<ffffffff81f41c7d>] panic+0xed/0x1d3
[  347.858442]  [<ffffffff81158052>] watchdog_timer_fn+0x172/0x1c0
[  347.858442]  [<ffffffff810f74b1>] __run_hrtimer+0x131/0x320
[  347.858442]  [<ffffffff81157ee0>] ? watchdog+0x30/0x30
[  347.858442]  [<ffffffff810f8349>] hrtimer_interrupt+0x129/0x230
[  347.858442]  [<ffffffff810fb054>] ? put_cred_rcu+0x74/0x80
[  347.858442]  [<ffffffff81164319>] ? rcu_process_callbacks+0x5a9/0x8c0
[  347.858442]  [<ffffffff8104d005>] timer_interrupt+0x15/0x20
[  347.858442]  [<ffffffff8115949d>] handle_irq_event_percpu+0x8d/0x2f0
[  347.858442]  [<ffffffff81159748>] handle_irq_event+0x48/0x70
[  347.858442]  [<ffffffff8115ce34>] handle_level_irq+0x124/0x130
[  347.858442]  [<ffffffff8104c74c>] handle_irq+0x4c/0x60
[  347.858442]  [<ffffffff81f648ca>] do_IRQ+0x5a/0xd0
[  347.858442]  [<ffffffff81f62332>] common_interrupt+0x72/0x72
[  347.858442]  <EOI>  [<ffffffff81130fdb>] ? mark_held_locks+0x10b/0x120
[  347.858442]  [<ffffffff81f5c436>] ? mutex_lock_nested+0x386/0x3b0
[  347.858442]  [<ffffffff811d3991>] ? unlink_file_vma+0x41/0x70
[  347.858442]  [<ffffffff811d3991>] unlink_file_vma+0x41/0x70
[  347.858442]  [<ffffffff811cbd07>] free_pgtables+0x47/0xe0
[  347.858442]  [<ffffffff811d33ef>] unmap_region+0xdf/0x110
[  347.858442]  [<ffffffff811d3749>] ? vma_rb_erase+0x1c9/0x210
[  347.858442]  [<ffffffff811d5692>] do_munmap+0x2c2/0x3d0
[  347.858442]  [<ffffffff811d6266>] mmap_region+0x596/0x660
[  347.858442]  [<ffffffff811d41e7>] ? vma_adjust+0x6a7/0x730
[  347.858442]  [<ffffffff81567455>] ? cap_mmap_addr+0x5/0x50
[  347.858442]  [<ffffffff811d6612>] do_mmap_pgoff+0x2e2/0x3b0
[  347.858442]  [<ffffffff811bfbc5>] vm_mmap_pgoff+0x75/0xb0
[  347.858442]  [<ffffffff812288d5>] ? fget+0x5/0x120
[  347.858442]  [<ffffffff811d489b>] sys_mmap_pgoff+0x13b/0x180
[  347.858442]  [<ffffffff8104f7d2>] sys_mmap+0x22/0x30
[  347.858442]  [<ffffffff81f62de9>] system_call_fastpath+0x16/0x1b
[  347.858442] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 490
