Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3FRMJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:09:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:57235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab3FRMJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:09:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,888,1363158000"; 
   d="log'?scan'208";a="351687955"
Date: Tue, 18 Jun 2013 20:08:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, linux-kernel@vger.kernel.org
Subject: Oops in ring_buffer_alloc_read_page()
Message-ID: <20130618120855.GA29700@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below oops in upstream. It's a hard to reproduce one and at
least is as old as v3.0.

[   36.774933] IP: [<7916a472>] ring_buffer_alloc_read_page+0x66/0x82
[   36.776024] *pde = 0e3e1067 *pte = 061e7260 
[   36.776024] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   36.776024] CPU: 0 PID: 44 Comm: rb_consumer Not tainted 3.10.0-rc4-00292-gbed1059 #29
[   36.776024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   36.776024] task: 7e3a5000 ti: 7e3a8000 task.ti: 7e3a8000
[   36.776024] EIP: 0060:[<7916a472>] EFLAGS: 00010246 CPU: 0
[   36.776024] EIP is at ring_buffer_alloc_read_page+0x66/0x82
[   36.776024] EAX: 7e1e7000 EBX: 0000feaf ECX: 00000000 EDX: 00000000
[   36.776024] ESI: 7e3a5000 EDI: 00000000 EBP: 7e3a9ed0 ESP: 7e3a9ecc
[   36.776024]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   36.776024] CR0: 8005003b CR2: 7e1e7008 CR3: 05beb000 CR4: 00000690
[   36.776024] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   36.776024] DR6: ffff0ff0 DR7: 00000400
[   36.776024] Stack:
[   36.776024]  00000000 7e3a9f00 7916abae 00000001 00000001 7e1e7000 ffffffff 00000ff0
[   36.776024]  00000ff0 00000000 00000000 7e3a5000 00000000 7e3a9f30 7916b38c 00000000
[   36.776024]  003a9f14 7e3a5000 00000000 00000000 0670d10e 00000004 00000000 7916b191
[   36.776024] Call Trace:
[   36.776024]  [<7916abae>] read_page+0x25/0x608
[   36.776024]  [<7916b38c>] ring_buffer_consumer_thread+0x1fb/0x549

git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 12:28      0-  Linux 3.9
git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 12:28      0-  Linux 3.8
git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 12:28      0-  Linux 3.7
git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 12:29      0-  Linux 3.6
git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 12:31    179-  Linux 3.5
git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 20:58   3174-  Linux 3.4
git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 15:59  21714-  Linux 3.3
git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 16:20   2591-  Linux 3.2
git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 20:15   6321-  Linux 3.1
git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 05:29  11960-  Linux 3.0
git bisect  bad 8177a9d79c0e942dcac3312f15585d0344d505a5  # 06:23    493-  lseek(fd, n, SEEK_END) does *not* go to eof - n

Thanks,
Fengguang

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-52676-20130610071953-3.10.0-rc4-00292-gbed1059-29"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc4-00292-gbed1059 (kbuild@snb) (gcc version 4.7.2 (Debian 4.7.2-4) ) #29 SMP Thu Jun 6 22:11:01 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [780fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x037fffff]
[    0.000000] Base memory trampoline at [7808f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x03342000, 0x03342fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x03343000, 0x03343fff] PGTABLE
[    0.000000] BRK [0x03344000, 0x03344fff] PGTABLE
[    0.000000] BRK [0x03345000, 0x03345fff] PGTABLE
[    0.000000] BRK [0x03346000, 0x03346fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128256(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat 7a6f6920, node_mem_map 864ff024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @864e9000 s29696 r0 d15360 u45056
[    0.000000] pcpu-alloc: s29696 r0 d15360 u45056 alloc=11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64848
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-s04-0605/linux-devel:devel-snb-i386-201306062154:bed10590f06e41b1a806dd3590bd7242d11f6b1d:bisect-sound/.vmlinuz-bed10590f06e41b1a806dd3590bd7242d11f6b1d-20130610070359-284-inn branch=linux-devel/devel-snb-i386-201306062154  BOOT_IMAGE=/kernel/i386-randconfig-s04-0605/bed10590f06e41b1a806dd3590bd7242d11f6b1d/vmlinuz-3.10.0-rc4-00292-gbed1059
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 172844k/262136k available (14419k kernel code, 88852k reserved, 11207k data, 876k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x7a90a000 - 0x7a9e5000   ( 876 kB)
[    0.000000]       .data : 0x79e14d87 - 0x7a906c40   (11207 kB)
[    0.000000]       .text : 0x79000000 - 0x79e14d87   (14419 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=84402000 soft=84404000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches HPET. 2 loops
[    0.000000] tsc: Detected 2693.409 MHz processor
[    0.016006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.81 BogoMIPS (lpj=10773636)
[    0.020810] pid_max: default: 32768 minimum: 301
[    0.022295] Security Framework initialized
[    0.023457] Mount-cache hash table entries: 512
[    0.025789] Initializing cgroup subsys devices
[    0.027008] Initializing cgroup subsys freezer
[    0.028358] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.028358] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.028358] tlb_flushall_shift: 6
[    0.032779] debug: unmapping init [mem 0x7a9e5000-0x7a9e6fff]
[    0.036127] ACPI: Core revision 20130328
[    0.064247] ACPI: All ACPI Tables successfully acquired
[    0.066209] Getting VERSION: 50014
[    0.067127] Getting VERSION: 50014
[    0.068025] Getting ID: 0
[    0.068733] Getting ID: f000000
[    0.069569] Getting LVT0: 8700
[    0.070394] Getting LVT1: 8400
[    0.071222] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.072119] enabled ExtINT on CPU#0
[    0.077067] ENABLING IO-APIC IRQs
[    0.077954] init IO_APIC IRQs
[    0.078728]  apic 2 pin 0 not connected
[    0.079779] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.080078] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.084059] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.086031] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.088052] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.090164] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.092062] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.096062] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.098152] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.100000] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.100052] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.104049] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.108054] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.112052] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.116046] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.120044]  apic 2 pin 16 not connected
[    0.121056]  apic 2 pin 17 not connected
[    0.122032]  apic 2 pin 18 not connected
[    0.124012]  apic 2 pin 19 not connected
[    0.124992]  apic 2 pin 20 not connected
[    0.125974]  apic 2 pin 21 not connected
[    0.126946]  apic 2 pin 22 not connected
[    0.128022]  apic 2 pin 23 not connected
[    0.129251] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.174146] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.178591] Using local APIC timer interrupts.
[    0.178591] calibrating APIC timer ...
[    0.184000] ... lapic delta = 6553613
[    0.184000] ... PM-Timer delta = 375352
[    0.184000] APIC calibration not consistent with PM-Timer: 104ms instead of 100ms
[    0.184000] APIC delta adjusted to PM-Timer: 6249845 (6553613)
[    0.184000] TSC delta adjusted to PM-Timer: 269349775 (282441255)
[    0.184000] ..... delta 6249845
[    0.184000] ..... mult: 268428798
[    0.184000] ..... calibration result: 3999900
[    0.184000] ..... CPU clock speed is 2693.1991 MHz.
[    0.184000] ..... host bus clock speed is 999.3900 MHz.
[    0.184173] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.190309] ftrace: Allocated trace_printk buffers
[    0.207477] SMP alternatives: lockdep: fixing up alternatives
[    0.208164] CPU 1 irqstacks, hard=84734000 soft=84736000
[    0.212014] smpboot: Booting Node   0, Processors  #1 OK
[    0.020000] Initializing CPU#1
[    0.020000] masked ExtINT on CPU#1
[    0.020000] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.020000] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    0.424313] Brought up 2 CPUs
[    0.425222] ----------------
[    0.425855] | NMI testsuite:
[    0.426480] --------------------
[    0.427173]   remote IPI:  ok  |
[    0.436408]    local IPI:  ok  |
[    0.464033] --------------------
[    0.465105] Good, all   2 testcases passed! |
[    0.466417] ---------------------------------
[    0.467653] smpboot: Total of 2 processors activated (10764.86 BogoMIPS)
[    0.492323] regulator-dummy: no parameters
[    0.493898] cma: cma_init_reserved_areas()
[    0.495048] cma: cma_create_area(base 0000d000, count 1000)
[    0.497597] cma: cma_create_area: returned 8474f2d8
[    0.500104] NET: Registered protocol family 16
[    0.537157] ACPI: bus type PCI registered
[    0.538906] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.540025] PCI: Using configuration type 1 for base access
[    0.585471] ACPI: Added _OSI(Module Device)
[    0.586700] ACPI: Added _OSI(Processor Device)
[    0.588017] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.589376] ACPI: Added _OSI(Processor Aggregator Device)
[    0.599076] ACPI: EC: Look up EC in DSDT
[    0.632093] ACPI: Interpreter enabled
[    0.633173] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.637518] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.640152] ACPI: (supports S0 S3 S5)
[    0.641268] ACPI: Using IOAPIC for interrupt routing
[    0.642706] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.694946] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.696244] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.698157] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.700015] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.704013] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.706124] PCI: root bus 00: using default resources
[    0.708105] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.712395] PCI host bridge to bus 0000:00
[    0.713533] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.714994] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.720032] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.724211] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.728230] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.731076] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.738332] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.744750] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.747043] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.748040] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.750571] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.756865] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.760930] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.771403] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.777877] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.780919] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.784465] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.792031] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.797096] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.800421] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.803251] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.813347] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.820193] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.824500] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.827068] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.841229] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.843951] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.848973] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.856654] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.864526] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.867067] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.877124] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.880020] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.882534] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.896273] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.898913] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.904940] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.914949] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.921017] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.924915] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.933348] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.936541] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.943681] pci_bus 0000:00: on NUMA node 0
[    0.944066] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.946557] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.955055] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.957430] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.960498] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.963177] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.965437] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.969724] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.971174] acpi root: \_SB_.PCI0 notify handler is installed
[    0.972314] Found 1 acpi root devices
[    0.980464] Error: Driver '88PM80X' is already registered, aborting...
[    0.982724] tps65010: version 2 May 2005
[    1.016400] tps65010: no chip?
[    1.019545] pps_core: LinuxPPS API ver. 1 registered
[    1.020018] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.022645] PTP clock support registered
[    1.024861] wmi: Mapper loaded
[    1.028369] PCI: Using ACPI for IRQ routing
[    1.029702] PCI: pci_cache_line_size set to 64 bytes
[    1.032639] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.036077] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.043120] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.049201] Switching to clocksource hpet
[    1.051979] Warning: could not register all branches stats
[    1.051979] Warning: could not register annotated branches stats
[    1.327701] pnp: PnP ACPI init
[    1.335147] ACPI: bus type PNP registered
[    1.337092] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    1.340261] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.342794] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    1.347283] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.355965] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    1.359418] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.362184] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    1.365068] pnp 00:03: [dma 2]
[    1.366708] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.369825] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    1.372904] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.375523] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    1.378352] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.382947] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.386408] pnp: PnP ACPI: found 7 devices
[    1.387668] ACPI: bus type PNP unregistered
[    1.428392] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.430137] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    1.432237] NET: Registered protocol family 1
[    1.433536] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.435541] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.437546] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.439509] pci 0000:00:02.0: Boot video device
[    1.441369] PCI: CLS 0 bytes, default 64
[    1.443803] Unpacking initramfs...
[    6.719498] debug: unmapping init [mem 0x8673f000-0x87feffff]
[    6.740655] cryptomgr_test (22) used greatest stack depth: 7168 bytes left
[    6.743771] cryptomgr_test (23) used greatest stack depth: 7156 bytes left
[    6.746209] PCLMULQDQ-NI instructions are not detected.
[    6.755041] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    6.764253] NatSemi SCx200 Driver
[    6.778086] Initializing RT-Tester: OK
[    6.779555] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    6.923581] jffs2: version 2.2. (NAND) (SUMMARY)  
[    6.928987] ROMFS MTD (C) 2007 Red Hat, Inc.
[    6.933188] fuse init (API version 7.22)
[    7.052280] cryptomgr_test (71) used greatest stack depth: 7092 bytes left
[    7.151630] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    7.153372] crc32: self tests passed, processed 225944 bytes in 344500 nsec
[    7.155793] crc32c: CRC_LE_BITS = 32
[    7.157805] crc32c: self tests passed, processed 225944 bytes in 177490 nsec
[    7.182693] rivafb_setup START
[    7.183921] nvidiafb_setup START
[    7.189848] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    7.201690] vmlfb: initializing
[    7.204160] no IO addresses supplied
[    7.215227] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM (4096 kB) at 0xfc000000
[    7.218313] CL Picasso4: enable CONFIG_FB_LITTLE_ENDIAN to support this framebuffer
[    7.224889] cirrusfb 0000:00:02.0: could not register fb device; err = -38!
[    7.232191] cirrusfb: probe of 0000:00:02.0 failed with error -38
[    7.235228] ipmi message handler version 39.2
[    7.238130] ipmi device interface
[    7.239572] IPMI System Interface driver.
[    7.250914] ipmi_si: Adding default-specified kcs state machine
[    7.265102] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    7.275222] ipmi_si: Interface detection failed
[    7.408492] ipmi_si: Adding default-specified smic state machine
[    7.410293] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    7.413407] ipmi_si: Interface detection failed
[    7.488261] ipmi_si: Adding default-specified bt state machine
[    7.491718] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    7.495463] ipmi_si: Interface detection failed
[    7.508634] ipmi_si: Unable to find any System Interface(s)
[    7.512329] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    7.527913] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    7.534799] ACPI: Power Button [PWRF]
[    7.597847] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    7.602570] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:3)
[    7.610286] virtio-pci 0000:00:03.0: setting latency timer to 64
[    7.625015] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    7.626780] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:3)
[    7.633413] virtio-pci 0000:00:05.0: setting latency timer to 64
[    7.647752] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    7.649652] virtio-pci 0000:00:06.0: setting latency timer to 64
[    7.655298] virtio-pci 0000:00:07.0: setting latency timer to 64
[    7.667420] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    7.669434] virtio-pci 0000:00:08.0: setting latency timer to 64
[    7.684183] virtio-pci 0000:00:09.0: setting latency timer to 64
[    7.690548] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    7.820204] tsc: Refined TSC clocksource calibration: 2693.507 MHz
[    7.822285] Switching to clocksource tsc
[    8.013567] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.057873] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.067164] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    8.069756] ac.o: No PCI boards found.
[    8.070969] ac.o: For an ISA board you must supply memory and irq parameters.
[    8.073637] Non-volatile memory driver v1.3
[    8.078834] nsc_gpio initializing
[    8.080138] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    8.082098] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    8.085194] Hangcheck: Using getrawmonotonic().
[    8.094682] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    8.100116] [drm] radeon kernel modesetting enabled.
[    8.114274] dummy-irq: no IRQ given.  Use irq=N
[    8.118689] Phantom Linux Driver, version n0.9.8, init OK
[    8.122296] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    8.125268] c2port c2port0: C2 port uc added
[    8.134346] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    8.141506] Guest personality initialized and is inactive
[    8.144545] VMCI host device registered (name=vmci, major=10, minor=62)
[    8.154630] Initialized host personality
[    8.160465] Driver for timberdale has been successfully registered.
[    8.171116] device id = 2440
[    8.172245] device id = 2480
[    8.173295] device id = 24c0
[    8.174318] device id = 24d0
[    8.175321] device id = 25a1
[    8.176502] device id = 2670
[    8.177783] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    8.179904] Could not find PAR responsible for SC520CDP Flash Bank #1
[    8.182232] Trying default address 0x8c00000
[    8.183890] SC520 CDP flash device: 0x800000 at 0x8800000
[    8.185779] Failed to ioremap_nocache
[    8.186941] NetSc520 flash device: 0x100000 at 0x200000
[    8.188795] Failed to ioremap_nocache
[    8.189965] Failed to ioremap_nocache
[    8.191129] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    8.194987] slram: not enough parameters.
[    8.210636] Spectra MTD driver built on Jun  6 2013 @ 22:07:15
[    8.212895] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.215879] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.219223] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.222515] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.225848] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.229111] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    8.231988] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    8.236243] flash size: 128 MiB
[    8.237217] page size: 512 bytes
[    8.238209] OOB area size: 16 bytes
[    8.239301] sector size: 16 KiB
[    8.240378] pages number: 262144
[    8.241452] pages per sector: 32
[    8.242584] bus width: 8
[    8.243462] bits in sector size: 14
[    8.244692] bits in page size: 9
[    8.245830] bits in OOB size: 4
[    8.246815] flash size with OOB: 135168 KiB
[    8.248335] page address bytes: 4
[    8.249489] sector address bytes: 3
[    8.250663] options: 0x42
[    8.255215] Scanning device for bad blocks
[    8.387969] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    8.390196] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    8.407997] HSI/SSI char device loaded
[    8.409186] I2O subsystem v1.325
[    8.410140] i2o: max drivers = 8
[    8.419828] I2O Configuration OSM v1.323
[    8.421450] I2O Bus Adapter OSM v1.317
[    8.436437] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    8.441009] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.456896] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.458602] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.617097] mousedev: PS/2 mouse device common for all mice
[    8.620877] i2c /dev entries driver
[    8.623641] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    8.630085] i2c-parport-light: adapter type unspecified
[    8.633176] pps pps0: new PPS source ktimer
[    8.635594] pps pps0: ktimer PPS source registered
[    8.637489] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    8.655355] Driver for 1-wire Dallas network protocol.
[    8.659111] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.661244] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    9.413970] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[   10.360186] i2c i2c-0: detect fail: address match, 0x2c
[   10.380196] i2c i2c-0: detect fail: address match, 0x2d
[   10.400183] i2c i2c-0: detect fail: address match, 0x2e
[   10.420252] i2c i2c-0: detect fail: address match, 0x2f
[   12.545767] pc87360: PC8736x not detected, module not inserted
[   13.094750] intel_powerclamp: Intel powerclamp does not run on family 15 model 6
[   13.107601] acquirewdt: WDT driver for Acquire single board computer initialising
[   13.113617] acquirewdt: I/O address 0x0043 already in use
[   13.115278] acquirewdt: probe of acquirewdt failed with error -5
[   13.124678] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   13.126414] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   13.128521] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   13.132798] ib700wdt: WDT driver for IB700 single board computer initialising
[   13.147126] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[   13.149557] wafer5823wdt: I/O address 0x0443 already in use
[   13.151260] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   13.153430] i6300esb: cannot register miscdev on minor=130 (err=-16)
[   13.165650] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16
[   13.167762] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   13.169554] iTCO_vendor_support: vendor-support=0
[   13.170942] sc1200wdt: build 20020303
[   13.172187] sc1200wdt: io parameter must be specified
[   13.173754] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   13.185906] sbc8360: failed to register misc device
[   13.187395] sbc7240_wdt: I/O address 0x0443 already in use
[   13.189183] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[   13.203102] smsc37b787_wdt: Unable to register miscdev on minor 130
[   13.207712] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   13.209785] w83697hf_wdt: watchdog not found at address 0x2e
[   13.211396] w83697hf_wdt: No W83697HF/HG could be found
[   13.213046] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[   13.223170] w83697ug_wdt: No W83697UG/UF could be found
[   13.224750] w83877f_wdt: I/O address 0x0443 already in use
[   13.226328] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   13.228189] machzwd: no ZF-Logic found
[   13.229353] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[   13.232469] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   13.234833] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   13.245095] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   13.255932] cpuidle: using governor ladder
[   13.257279] sdhci: Secure Digital Host Controller Interface driver
[   13.259122] sdhci: Copyright(c) Pierre Ossman
[   13.262064] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   13.263835] wbsd: Copyright(c) Pierre Ossman
[   13.275565] sdhci-pltfm: SDHCI platform and OF driver helper
[   13.371972] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   13.411695] 
[   13.411695] printing PIC contents
[   13.413375] ... PIC  IMR: ffff
[   13.414345] ... PIC  IRR: 1013
[   13.415326] ... PIC  ISR: 0000
[   13.423844] ... PIC ELCR: 0c00
[   13.424795] printing local APIC contents on CPU#0/0:
[   13.426358] ... APIC ID:      00000000 (0)
[   13.427704] ... APIC VERSION: 00050014
[   13.428757] ... APIC TASKPRI: 00000000 (00)
[   13.428757] ... APIC PROCPRI: 00000000
[   13.428757] ... APIC LDR: 01000000
[   13.428757] ... APIC DFR: ffffffff
[   13.428757] ... APIC SPIV: 000001ff
[   13.428757] ... APIC ISR field:
[   13.428757] 0000000000000000000000000000000000000000000000000000000000000000
[   13.428757] ... APIC TMR field:
[   13.428757] 0000000000000000000000000000000000000000000000000000000000000000
[   13.428757] ... APIC IRR field:
[   13.428757] 0000000000000000000000000000000000000000000000000000000000008000
[   13.428757] ... APIC ESR: 00000000
[   13.428757] ... APIC ICR: 000008fd
[   13.428757] ... APIC ICR2: 02000000
[   13.428757] ... APIC LVTT: 000000ef
[   13.428757] ... APIC LVTPC: 00010000
[   13.428757] ... APIC LVT0: 00010700
[   13.428757] ... APIC LVT1: 00000400
[   13.428757] ... APIC LVTERR: 000000fe
[   13.428757] ... APIC TMICT: 00031655
[   13.428757] ... APIC TMCCT: 00000000
[   13.428757] ... APIC TDCR: 00000003
[   13.428757] 
[   13.488701] number of MP IRQ sources: 15.
[   13.489929] number of IO-APIC #2 registers: 24.
[   13.491313] testing the IO APIC.......................
[   13.492949] IO APIC #2......
[   13.493875] .... register #00: 00000000
[   13.495078] .......    : physical APIC id: 00
[   13.503898] .......    : Delivery Type: 0
[   13.505139] .......    : LTS          : 0
[   13.506331] .... register #01: 00170011
[   13.507429] .......     : max redirection entries: 17
[   13.508981] .......     : PRQ implemented: 0
[   13.510204] .......     : IO APIC version: 11
[   13.511550] .... register #02: 00000000
[   13.512737] .......     : arbitration: 00
[   13.513949] .... IRQ redirection table:
[   13.515140] 1    0    0   0   0    0    0    00
[   13.536709] 0    0    0   0   0    1    1    31
[   13.538003] 0    0    0   0   0    1    1    30
[   13.539333] 0    0    0   0   0    1    1    33
[   13.540815] 1    0    0   0   0    1    1    34
[   13.542121] 1    1    0   0   0    1    1    35
[   13.543480] 0    0    0   0   0    1    1    36
[   13.544866] 0    0    0   0   0    1    1    37
[   13.553713] 0    0    0   0   0    1    1    38
[   13.555074] 0    1    0   0   0    1    1    39
[   13.556600] 1    1    0   0   0    1    1    3A
[   13.557959] 1    1    0   0   0    1    1    3B
[   13.559366] 0    0    0   0   0    1    1    3C
[   13.560834] 0    0    0   0   0    1    1    3D
[   13.562239] 0    0    0   0   0    1    1    3E
[   13.563649] 0    0    0   0   0    1    1    3F
[   13.565040] 1    0    0   0   0    0    0    00
[   13.576635] 1    0    0   0   0    0    0    00
[   13.578154] 1    0    0   0   0    0    0    00
[   13.579657] 1    0    0   0   0    0    0    00
[   13.581077] 1    0    0   0   0    0    0    00
[   13.582430] 1    0    0   0   0    0    0    00
[   13.583782] 1    0    0   0   0    0    0    00
[   13.585192] 1    0    0   0   0    0    0    00
[   13.594039] IRQ to pin mappings:
[   13.595044] IRQ0 -> 0:2
[   13.595956] IRQ1 -> 0:1
[   13.596824] IRQ3 -> 0:3
[   13.597728] IRQ4 -> 0:4
[   13.598643] IRQ5 -> 0:5
[   13.599536] IRQ6 -> 0:6
[   13.600464] IRQ7 -> 0:7
[   13.601296] IRQ8 -> 0:8
[   13.602148] IRQ9 -> 0:9
[   13.602996] IRQ10 -> 0:10
[   13.603897] IRQ11 -> 0:11
[   13.604794] IRQ12 -> 0:12
[   13.625794] IRQ13 -> 0:13
[   13.626785] IRQ14 -> 0:14
[   13.627742] IRQ15 -> 0:15
[   13.628642] .................................... done.
[   13.630442] Using IPI No-Shortcut mode
[   13.634181] Running ring buffer tests...
[   23.685590] rbhammer (95) used greatest stack depth: 6816 bytes left
[   23.688530] finished
[   23.689290] CPU 0:
[   23.689973]               events:    63724
[   23.691279]        dropped bytes:    0
[   23.692631]        alloced bytes:    4970656
[   23.693915]        written bytes:    4875944
[   23.695185]        biggest event:    264
[   23.696951]       smallest event:    4
[   23.720349]          read events:   12498
[   23.721626]          lost events:   51226
[   23.722880]         total events:   63724
[   23.724308]   recorded len bytes:   971480
[   23.725715]  recorded size bytes:   953149
[   23.727061]  With dropped events, record len and size may not match
[   23.727061]  alloced and written from above
[   23.730566] CPU 1:
[   23.731249]               events:    81383
[   23.732807]        dropped bytes:    0
[   23.733999]        alloced bytes:    6386512
[   23.735338]        written bytes:    6266318
[   23.737071]        biggest event:    234
[   23.738351]       smallest event:    4
[   23.782896]          read events:   12660
[   23.785640]          lost events:   68723
[   23.786890]         total events:   81383
[   23.792269]   recorded len bytes:   972288
[   23.793509]  recorded size bytes:   953482
[   23.794727]  With dropped events, record len and size may not match
[   23.794727]  alloced and written from above
[   23.802425] Ring buffer PASSED!
[   23.835276] cryptomgr_probe (96) used greatest stack depth: 6796 bytes left
[   23.835581] Key type encrypted registered
[   23.846923] ### dt-test ### No testcase data in device tree; not running tests
[   23.866174] debug: unmapping init [mem 0x7a90a000-0x7a9e4fff]
[   23.997515] sh (104) used greatest stack depth: 6792 bytes left
[   24.012570] sh (105) used greatest stack depth: 6580 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
[   24.086661] sh (108) used greatest stack depth: 6504 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   36.745552] CPA self-test:
[   36.749335]  4k 65534 large 0 gb 0 x 65534[78000000-87ffd000] miss 0
[   36.773159] BUG: unable to handle kernel paging request at 7e1e7008
[   36.774933] IP: [<7916a472>] ring_buffer_alloc_read_page+0x66/0x82
[   36.776024] *pde = 0e3e1067 *pte = 061e7260 
[   36.776024] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   36.776024] CPU: 0 PID: 44 Comm: rb_consumer Not tainted 3.10.0-rc4-00292-gbed1059 #29
[   36.776024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   36.776024] task: 7e3a5000 ti: 7e3a8000 task.ti: 7e3a8000
[   36.776024] EIP: 0060:[<7916a472>] EFLAGS: 00010246 CPU: 0
[   36.776024] EIP is at ring_buffer_alloc_read_page+0x66/0x82
[   36.776024] EAX: 7e1e7000 EBX: 0000feaf ECX: 00000000 EDX: 00000000
[   36.776024] ESI: 7e3a5000 EDI: 00000000 EBP: 7e3a9ed0 ESP: 7e3a9ecc
[   36.776024]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   36.776024] CR0: 8005003b CR2: 7e1e7008 CR3: 05beb000 CR4: 00000690
[   36.776024] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   36.776024] DR6: ffff0ff0 DR7: 00000400
[   36.776024] Stack:
[   36.776024]  00000000 7e3a9f00 7916abae 00000001 00000001 7e1e7000 ffffffff 00000ff0
[   36.776024]  00000ff0 00000000 00000000 7e3a5000 00000000 7e3a9f30 7916b38c 00000000
[   36.776024]  003a9f14 7e3a5000 00000000 00000000 0670d10e 00000004 00000000 7916b191
[   36.776024] Call Trace:
[   36.776024]  [<7916abae>] read_page+0x25/0x608
[   36.776024]  [<7916b38c>] ring_buffer_consumer_thread+0x1fb/0x549
[   36.776024]  [<7916b191>] ? read_page+0x608/0x608
[   36.776024]  [<790b7c6a>] kthread+0xe6/0xf9
[   36.776024]  [<790c0000>] ? hrtimer_init+0xc5/0x1b1
[   36.776024]  [<79e13f17>] ret_from_kernel_thread+0x1b/0x28
[   36.776024]  [<790b7b84>] ? __kthread_parkme+0xee/0xee
[   36.776024] Code: 05 50 25 f7 7a 01 83 15 54 25 f7 7a 00 84 d2 89 1c 8d ec f8 75 7a 75 2a 83 05 58 25 f7 7a 01 83 15 5c 25 f7 7a 00 e8 86 ad 08 00 <c7> 40 08 00 00 00 00 83 05 60 25 f7 7a 01 83 15 64 25 f7 7a 00
[   36.776024] EIP: [<7916a472>] ring_buffer_alloc_read_page+0x66/0x82 SS:ESP 0068:7e3a9ecc
[   36.776024] CR2: 000000007e1e7008
[   36.776024] ---[ end trace 1eb1f8599a507450 ]---
[   36.776024] BUG: sleeping function called from invalid context at /c/kernel-tests/src/linux/kernel/rwsem.c:20
[   36.776024] in_atomic(): 0, irqs_disabled(): 1, pid: 44, name: rb_consumer
[   36.776024] INFO: lockdep is turned off.
[   36.776024] irq event stamp: 5033122
[   36.776024] hardirqs last  enabled at (5033121): [<791c0172>] buffered_rmqueue.isra.54+0x735/0xb3c
[   36.776024] hardirqs last disabled at (5033122): [<79e13d0f>] error_code+0x5b/0x64
[   36.776024] softirqs last  enabled at (5000644): [<7907d657>] __do_softirq+0x53d/0x582
[   36.776024] softirqs last disabled at (5000603): [<7907d99e>] irq_exit+0xfb/0x150
[   36.776024] CPU: 0 PID: 44 Comm: rb_consumer Tainted: G      D      3.10.0-rc4-00292-gbed1059 #29
[   36.776024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   36.776024]  7e3a5000 7e3a5000 7e3a9cc8 79dfcd42 7e3a9cec 790db661 7a3d87df 00000000
[   36.776024]  00000001 0000002c 7e3a51f8 7e2a7408 00000000 7e3a9d08 79e0ee16 7e3a9d1c
[   36.776024]  790c6be8 79409df7 00000000 7e3a5000 7e3a9d24 790942b2 7e3a5000 00000000
[   36.776024] Call Trace:
[   36.776024]  [<79dfcd42>] dump_stack+0x32/0x42
[   36.776024]  [<790db661>] __might_sleep+0x24b/0x260
[   36.776024]  [<79e0ee16>] down_read+0x28/0x97
[   36.776024]  [<790c6be8>] ? __validate_process_creds+0xaa/0x2d7
[   36.776024]  [<79409df7>] ? do_raw_spin_lock+0x1ea/0x3f2
[   36.776024]  [<790942b2>] exit_signals+0x37/0x303
[   36.776024]  [<79077f09>] do_exit+0x250/0xee4
[   36.776024]  [<790724bb>] ? kmsg_dump+0x90/0x32b
[   36.776024]  [<790726e3>] ? kmsg_dump+0x2b8/0x32b
[   36.776024]  [<790724bb>] ? kmsg_dump+0x90/0x32b
[   36.776024]  [<7900a75e>] oops_end+0x208/0x21d
[   36.776024]  [<79dec54e>] no_context+0x438/0x44e
[   36.776024]  [<79054594>] ? vmalloc_sync_all+0x171/0x171
[   36.776024]  [<79dec879>] __bad_area_nosemaphore+0x315/0x32b
[   36.776024]  [<79deb872>] ? spurious_fault+0xe3/0x2e3
[   36.776024]  [<79054594>] ? vmalloc_sync_all+0x171/0x171
[   36.776024]  [<79dec975>] bad_area_nosemaphore+0x20/0x30
[   36.776024]  [<79053627>] __do_page_fault+0x25e/0x105a
[   36.776024]  [<791c06ff>] ? get_page_from_freelist+0x186/0x23b
[   36.776024]  [<791112b3>] ? trace_hardirqs_off_caller+0x14b/0x270
[   36.776024]  [<79054594>] ? vmalloc_sync_all+0x171/0x171
[   36.776024]  [<790545aa>] do_page_fault+0x16/0x28
[   36.776024]  [<79e13d13>] error_code+0x5f/0x64
[   36.776024]  [<791f007b>] ? isolate_migratepages_range+0x721/0x1007
[   36.776024]  [<79054594>] ? vmalloc_sync_all+0x171/0x171
[   36.776024]  [<7916a472>] ? ring_buffer_alloc_read_page+0x66/0x82
[   36.776024]  [<7916abae>] read_page+0x25/0x608
[   36.776024]  [<7916b38c>] ring_buffer_consumer_thread+0x1fb/0x549
[   36.776024]  [<7916b191>] ? read_page+0x608/0x608
[   36.776024]  [<790b7c6a>] kthread+0xe6/0xf9
[   36.776024]  [<790c0000>] ? hrtimer_init+0xc5/0x1b1
[   36.776024]  [<79e13f17>] ret_from_kernel_thread+0x1b/0x28
[   36.776024]  [<790b7b84>] ? __kthread_parkme+0xee/0xee
[   36.776024] rb_consumer (44) used greatest stack depth: 6244 bytes left
[   37.049153]  4k 65534 large 0 gb 0 x 65534[78000000-87ffd000] miss 0
[   37.073765]  4k 65534 large 0 gb 0 x 65534[78000000-87ffd000] miss 0
[   37.075964] ok.
[   66.816168] rcu-torture: rtc: 7af69bb8 ver: 4233 tfle: 0 rta: 4233 rtaf: 40 rtf: 4232 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 16202 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=250) barrier: 0/0:0
[   66.816168] rcu-torture: Reader Pipe:  6181128 14 0 0 0 0 0 0 0 0 0
[   66.816168] rcu-torture: Reader Batch:  6181090 52 0 0 0 0 0 0 0 0 0
[   66.816168] rcu-torture: Free-Block Circulation:  4232 4232 4232 4232 4232 4232 4232 4232 4232 4232 0
 * Asking all remaining processes to terminate...       
killall5[142]: mount returned non-zero exit status
killall5[142]: /proc not mounted, failed to mount.

mount: proc has wrong device number or fs type proc not supported
killall5[150]: mount returned non-zero exit status
killall5[150]: /proc not mounted, failed to mount.
 * All processes ended within 1 seconds....       
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
[   89.935081] rcutorture thread rcu_torture_reader parking due to system shutdown
[   89.937607] rcutorture thread rcu_torture_writer parking due to system shutdown
[   89.937867] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
[   89.937878] rcutorture thread rcu_torture_reader parking due to system shutdown
[   89.937906] rcutorture thread rcu_torture_reader parking due to system shutdown
[   89.937924] rcutorture thread rcu_torture_reader parking due to system shutdown
[   89.951717] Disabling non-boot CPUs ...
[   89.952126] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
[   89.968140] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
[   89.968161] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
[   89.982708] Restarting system.
[   89.983716] reboot: machine restart
Elapsed time: 95

--W/nzBZO5zC0uMSeA
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-bed10590f06e41b1a806dd3590bd7242d11f6b1d-i386-randconfig-s04-0605-ring_buffer_alloc_read_page-57413.log"
Content-Transfer-Encoding: base64

YmlzZWN0OiBza2lwIDI5ZWI3NzgyNWNjN2RhOGQ0NWI2NDJkZTJkZTNkNDIzZGM4YTM2M2Y6
IG5vdCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyBiZWQxMDU5Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2RybS1pbnRlbC9kcm0taW50ZWwtbmlnaHRseScgaW50byBkZXZlbC1zbmItaTM4Ni0yMDEz
MDYwNjIxNTQKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51
eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6YzFiZTVhNWIxYjM1NWQ0MGU2
Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMTpiaXNlY3Qtc291bmQKIFRFU1QgRkFJTFVSRQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5
NzllYjY2ZGFmYTI0YWQxL2RtZXNnLWt2bS12cC0yOTE4MS0yMDEzMDYxMDAxMzIxNy0zLjku
MC0yNgoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjkKZ2l0IGNoZWNrb3V0IHYzLjgKUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgYzFiZTVhNS4uLiBMaW51eCAzLjkKSEVBRCBpcyBub3cg
YXQgMTlmOTQ5Zi4uLiBMaW51eCAzLjgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4
Ni0yMDEzMDYwNjIxNTQ6MTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIw
MDpiaXNlY3Qtc291bmQKIFRFU1QgRkFJTFVSRQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1z
MDQtMDYwNS8xOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwL2RtZXNn
LWt2bS1pbm4tMzc3MzgtMjAxMzA2MTAwNTMyMzUtMy44LjAtNDEKCmJpc2VjdDogYmFkIGNv
bW1pdCB2My44CmdpdCBjaGVja291dCB2My43ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDE5Zjk0OWYuLi4gTGludXggMy44CkhFQUQgaXMgbm93IGF0IDI5NTk0NDAuLi4gTGludXgg
My43CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
czA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjI5NTk0
NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGU6YmlzZWN0LXNvdW5kCiBURVNU
IEZBSUxVUkUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvMjk1OTQ0MDRkN2Zl
NzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy1rdm0ta2J1aWxkLTUwODcxLTIw
MTMwNjEwMDczMzQyLTMuNy4wLTM0CgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuNwpnaXQgY2hl
Y2tvdXQgdjMuNgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyOTU5NDQwLi4uIExpbnV4
IDMuNwpIRUFEIGlzIG5vdyBhdCBhMGQyNzFjLi4uIExpbnV4IDMuNgpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRl
dmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDphMGQyNzFjYmZlZDFkZDUwMjc4YzZi
MDZiZWFkM2QwMGJhMGE4OGY5OmJpc2VjdC1zb3VuZAogVEVTVCBGQUlMVVJFCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2EwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQz
ZDAwYmEwYTg4ZjkvZG1lc2cta3ZtLXZwLTI4NTk2LTIwMTMwNjEwMDc1MjQ4LTMuNi4wLTM1
CgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuNgpnaXQgY2hlY2tvdXQgdjMuNQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyBhMGQyNzFjLi4uIExpbnV4IDMuNgpIRUFEIGlzIG5vdyBhdCAy
OGEzM2NiLi4uIExpbnV4IDMuNQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIw
MTMwNjA2MjE1NDoyOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyOmJp
c2VjdC1zb3VuZAoKMjAxMy0wNi0xNC0xNzo0MToxMiAyOGEzM2NiYzI0ZTQyNTZjMTQzZGNl
OTZjN2Q5M2JmNDIzMjI5ZjkyIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1LzI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIvdm1saW51ei0z
LjUuMAoKMjAxMy0wNi0xNC0xNzo0MToxNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTQJMTIJ
MTUJMjkJMzEJMzMJMzQJMzkJNTAJNTMJNjAJNjgJNzgJODgJOTMJMTA0CTExNgkxMzAJMTM4
CTE0NQkxNTMJMTY2CTE3NQkxNzcJMTgwCTE4NgkxOTcJMjAxCTIwNQkyMjEJMjIzCTIzNQky
NDgJMjUxCTI2MAkyNzAJMjc2CTI4NQkyOTMJMzA0CTMxMwkzMjEJMzMxCTM0NgkzNDkJMzU4
CTM3MQkzNzMJMzc3CTQwMQk0MDgJNDEyCTQxOAk0MjMJNDI5CTQ0MAk0NTIJNDU5CTQ3Mgk0
ODAJNDg0CTUwNAk1MTgJNTI4CTU1NAk1NjAJNTY1CTU3Nwk1OTkJNjA0CTYxMAk2MjkJNjQz
CTY1MAk2NTUJNjc2CTY3OQk2ODgJNzAzCTcwNwk3MjcJNzUxCTc1Nwk3NjIJNzgyCTc4NAk3
OTAJODM0CTg0Mwk4NzAJODk4CTkwOQk5MzIJOTYyCTk4MAkxMDA3CTEwMjUJMTA1OQkxMDk0
CTExMDcJMTEzMQkxMTcwCTExOTkJMTIxNQkxMjUzCTEyNzMJMTI4NQkxMzE4CTEzMzgJMTM2
MgkxMzkyCTE0MDcJMTQxOQkxNDQxCTE0NTIJMTQ1MwkxNDU1Li4uLi4uLi4uLi4uCTE0NTYu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUg
NDY5G1swbQouLgkxNDY0CTE0NzQJMTQ4MQkxNDg1CTE1MjUJMTU0MAkxNTU2CTE1ODgJMTYw
OQkxNjI2CTE2NDQJMTY2MAkxNjY0CTE2NjgJMTY3OQkxNzEwCTE3MTQJMTcxNwkxNzQwCTE3
NjQJMTc4MwkxNzg5CTE3OTEJMTc5NgkxODAzCTE4MzIJMTgzNwkxODUzCTE4NjcJMTg5MAkx
OTA0CTE5MTEJMTkyMwkxOTI0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTsz
NW1hZGRfdG9fcnVuX3F1ZXVlIDEbWzBtCi4JMTkyNSBTVUNDRVNTCgpiaXNlY3Q6IGdvb2Qg
Y29tbWl0IHYzLjUKZ2l0IGJpc2VjdCBzdGFydCB2My42IHYzLjUgLS0KUHJldmlvdXMgSEVB
RCBwb3NpdGlvbiB3YXMgMjhhMzNjYi4uLiBMaW51eCAzLjUKSEVBRCBpcyBub3cgYXQgYzFi
ZTVhNS4uLiBMaW51eCAzLjkKQmlzZWN0aW5nOiA1MDcxIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKW2IxM2JjOGRkYTgxYzU0YTY2YTFj
ODRlNjZmNjBiOGZlYmE2NTlmMjhdIE1lcmdlIHRhZyAnc3RhZ2luZy0zLjYtcmMxJyBvZiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL3N0
YWdpbmcKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6
YjEzYmM4ZGRhODFjNTRhNjZhMWM4NGU2NmY2MGI4ZmViYTY1OWYyODpiaXNlY3Qtc291bmQK
IFRFU1QgRkFJTFVSRQobWzE7MzVtSW5jcmVhc2luZyByZXBlYXQgY291bnQgZnJvbSAxOTI1
IHRvIDc2MzUbWzBtCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2IxM2JjOGRk
YTgxYzU0YTY2YTFjODRlNjZmNjBiOGZlYmE2NTlmMjgvZG1lc2cta3ZtLWlubi0zMzkwOS0y
MDEzMDYxMDA5MDQ1NS0zLjUuMC0wNjQ5NS1nYjEzYmM4ZC0zNwoKQmlzZWN0aW5nOiAyMzg0
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykK
WzNjNGNmYWRlZjZhMTY2NWQ5Y2QwMmE1NDM3ODJkMDNkM2U2NzQwYzZdIE1lcmdlIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQtbmV4
dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmIt
aTM4Ni0yMDEzMDYwNjIxNTQ6M2M0Y2ZhZGVmNmExNjY1ZDljZDAyYTU0Mzc4MmQwM2QzZTY3
NDBjNjpiaXNlY3Qtc291bmQKIFRFU1QgRkFJTFVSRQobWzE7MzVtSW5jcmVhc2luZyByZXBl
YXQgY291bnQgZnJvbSA3NjM1IHRvIDEwMDAwG1swbQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zMDQtMDYwNS8zYzRjZmFkZWY2YTE2NjVkOWNkMDJhNTQzNzgyZDAzZDNlNjc0MGM2L2Rt
ZXNnLWt2bS1yb2FtLTU2MDctMjAxMzA2MTAxMDA4MzEtMy41LjAtMDQwMzMtZzNjNGNmYWQt
MzgKCkJpc2VjdGluZzogMTgzOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTEgc3RlcHMpCls5MGI5MGY2MGM0ZjhlM2E4NTI1ZGZlYjRhZWM0NmE5Yzdh
MjljODU3XSBNZXJnZSBicmFuY2ggJ21hc3Rlcicgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2xpbnZpbGxlL3dpcmVsZXNzLW5leHQgaW50byBm
b3ItZGF2ZW0KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2
ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjkwYjkwZjYwYzRmOGUzYTg1MjVkZmViNGFlYzQ2
YTljN2EyOWM4NTc6YmlzZWN0LXNvdW5kCiBURVNUIEZBSUxVUkUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctczA0LTA2MDUvOTBiOTBmNjBjNGY4ZTNhODUyNWRmZWI0YWVjNDZhOWM3YTI5
Yzg1Ny9kbWVzZy1rdm0tY2Fpcm8tNDMxODAtMjAxMzA2MTAxMDM3MjctMy41LjAtcmM3LTAx
OTY4LWc5MGI5MGY2LTM5CgpCaXNlY3Rpbmc6IDkyMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpClsyM2NiM2IyMTIxMzIzNDQzODM0Mjk2
YThlY2I1ODJiOGFlYjc4ZDc1XSBiY21hOiBhZGQgcGxhY2UgZm9yIGZsYXNoIG1lbW9yeSBz
dXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVs
LXNuYi1pMzg2LTIwMTMwNjA2MjE1NDoyM2NiM2IyMTIxMzIzNDQzODM0Mjk2YThlY2I1ODJi
OGFlYjc4ZDc1OmJpc2VjdC1zb3VuZAogVEVTVCBGQUlMVVJFCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXMwNC0wNjA1LzIzY2IzYjIxMjEzMjM0NDM4MzQyOTZhOGVjYjU4MmI4YWViNzhk
NzUvZG1lc2cta3ZtLXhpYW4tMTI1MC0yMDEzMDYxMDEwNDgwNS0zLjUuMC1yYzEtMDA5Mjkt
ZzIzY2IzYjItNDAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvMjNjYjNiMjEy
MTMyMzQ0MzgzNDI5NmE4ZWNiNTgyYjhhZWI3OGQ3NS9kbWVzZy1rdm0teGlhbi01NzQzOS0y
MDEzMDYxMDEwNDg1OS0zLjUuMC1yYzEtMDA5MjktZzIzY2IzYjItNDAKCkJpc2VjdGluZzog
NDYwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBz
KQpbY2U3NzkwM2M5MTViYTA1NjY4ZWNmZmFiZDBlMjBiYzJhNjFjMmIzYV0gTWVyZ2UgYnJh
bmNoICdmb3ItbGludmlsbGUnIG9mIGdpdDovL2dpdGh1Yi5jb20va3ZhbG8vYXRoNmtsCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2
LTIwMTMwNjA2MjE1NDpjZTc3OTAzYzkxNWJhMDU2NjhlY2ZmYWJkMGUyMGJjMmE2MWMyYjNh
OmJpc2VjdC1zb3VuZAogVEVTVCBGQUlMVVJFCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
NC0wNjA1L2NlNzc5MDNjOTE1YmEwNTY2OGVjZmZhYmQwZTIwYmMyYTYxYzJiM2EvZG1lc2ct
a3ZtLXdhaW1lYS0yODU4OC0yMDEzMDYxMDE0MjkwOC0zLjUuMC1yYzEtMDA0NzMtZ2NlNzc5
MDMtNDEKCkJpc2VjdGluZzogMjMzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA4IHN0ZXBzKQpbOTM0YjlkMWVkNzFjY2E1YTIyMGVjMTNlM2Y3NmQ2YWVi
ZjUxODNkYV0gd2wxOHh4OiBhdm9pZCBzb21lIC1XZm9ybWF0IHdhcm5pbmdzCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
c291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMw
NjA2MjE1NDo5MzRiOWQxZWQ3MWNjYTVhMjIwZWMxM2UzZjc2ZDZhZWJmNTE4M2RhOmJpc2Vj
dC1zb3VuZAoKMjAxMy0wNi0xNS0wMDowOToyNyA5MzRiOWQxZWQ3MWNjYTVhMjIwZWMxM2Uz
Zjc2ZDZhZWJmNTE4M2RhIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1
LzkzNGI5ZDFlZDcxY2NhNWEyMjBlYzEzZTNmNzZkNmFlYmY1MTgzZGEvdm1saW51ei0zLjUu
MC1yYzEtMDAyMzktZzkzNGI5ZDEKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3Rl
ZCAxMDAwMCwgbGltaXQgdG8gNTAwMBtbMG0KCjIwMTMtMDYtMTUtMDA6MDk6MzkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLgk2MgkxNzEJMzU1CTM5OQk0MjcJNTE4CTYxNQk3NDEJODE0CTg3
NQk5OTEJMTE0MgkxMzQ3CTE1MDAJMTYyNgkxNjc1CTE3ODcJMTkwNAkyMTQ1CTIzODEJMjU0
NAkyNjIyCTI2NzMJMjcyMgkyODE1CTI5OTMJMzE0MgkzMzEwCTM0MjQJMzU1OAkzNzYwCTM5
NTYJNDA4Mwk0MTcxCTQyNjcJNDQ1Ngk0NTUzCTQ2MzMJNDg3MQk0OTUzCTQ5NjUJNDk3MS4u
Li4uLi4uLi4uLi4uLi4uLgk0OTcyLgk0OTc1CTQ5NzguLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNTAyMhtbMG0KG1sxOzM1bWFkZF90
b19ydW5fcXVldWU6IHJlcXVlc3RlZCA1MDIyLCBsaW1pdCB0byA1MDAwG1swbQoJNDk4MAk1
MDg1CTUyMDYJNTM0MQk1NDM2CTU0NjUJNTU4MAk1NzE4CTU3ODUJNTkyNAk2MDU4CTYwODIJ
NjE1Nwk2MjkxCTY0NDUJNjQ2NQk2NTk5CTY2NTYJNjgxMAk2OTE1CTcwMTIJNzA0MAk3MTYx
CTcyODMJNzMwNwk3NDM2CTc1NjMJNzYzMQk3NjYwCTc4NDMJNzk3Ngk4MDY2CTgxMDAJODE0
OAk4MzAwCTgzMjUJODM1MAk4Mzg0CTg1NTcJODczMwk4ODI5CTg4NzUJOTA2OAk5MjA0CTky
ODkJOTM3Mwk5NDEzCTk1MTYJOTU3Mgk5NjkwCTk4MDEJOTkwNgk5OTUxCTk5NjIJOTk2Ngk5
OTY3Li4uCTk5NjguLi4uLi4JOTk2OS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4b
WzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAzMRtbMG0KLgk5OTk2CTk5OTgJOTk5OS4uLi4uLi4u
Li4uLi4uLi4uLi4uCTEwMDAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTI0IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbOTMzMDk2OWI4ZmQx
MzA0ZmRjYjdjMTgyNWYxNTI4ZWVhMzhkMzIxY10gYXRoOWtfaHc6IHJlbW92ZSBNQ0lfU1RB
VEVfU0VUX0JUX1NMRUVQCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRl
dmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDo5MzMwOTY5YjhmZDEzMDRmZGNiN2Mx
ODI1ZjE1MjhlZWEzOGQzMjFjOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xNS0wNjozMDo0OCA5
MzMwOTY5YjhmZDEzMDRmZGNiN2MxODI1ZjE1MjhlZWEzOGQzMjFjIHJldXNlIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1LzkzMzA5NjliOGZkMTMwNGZkY2I3YzE4MjVmMTUy
OGVlYTM4ZDMyMWMvdm1saW51ei0zLjUuMC1yYzEtMDAzMzAtZzkzMzA5NjkKG1sxOzM1bWFk
ZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAxMDAwMCwgbGltaXQgdG8gNTAwMBtbMG0KCjIw
MTMtMDYtMTUtMDY6MzE6MDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJODUJMjM0CTM0MQkz
NjYJNDE3CTU5Nwk2NzYJNjkyCTgwOAk4NTcJOTQ2CTExMDgJMTE0OAkxMjU0CTEyODgJMTQw
OQkxNTAzCTE1OTQJMTY5MgkxNzU5CTE4MjMJMTg0MwkxODgzCTE4OTQJMTkxOQkxOTY1CTE5
NzkJMTk5MgkyMDA1CTIwNDcJMjA4NQkyMDk4CTIxMDkJMjE2MAkyMTk4CTIyMTkJMjI1MAky
Mjc5CTIzMTUJMjM2NwkyMzgxCTIzOTkJMjQxNgkyNDkzCTI1MTQJMjUxNQkyNTQ4CTI2MjIJ
MjY0MAkyNjQ2CTI2NjQJMjY3MQkyNzM4CTI4MDMJMjgxMgkyODE2CTI4MjAJMjgzNwkyODQx
CTI4NDYJMjg1Mi4JMjg1NAkyODU2CTI4NjAJMjg5MgkyOTMxCTI5NDMJMjk1NgkyOTc3CTI5
OTEJMzAwNgkzMDEwCTMwMTEJMzAxMwkzMDI4CTMwNDQJMzA1MAkzMDUzCTMwNjQJMzA4OAkz
MDkyCTMxMDgJMzEyMwkzMTQyCTMxNTcJMzE4NgkzMTk0CTMxOTYuCTMxOTkJMzIxMQkzMjIy
CTMyMjcJMzIzNQkzMjQyCTMyNjIJMzI5MwkzMzA0CTMzMjIJMzMzMwkzMzYxCTMzODUJMzM5
MgkzMzk5CTM0MDYJMzQwOQkzNDE3CTM0MjgJMzQzNwkzNDQwCTM0NDcJMzQ5OAkzNTE1CTM1
MjYJMzUzNQkzNTQwCTM1NDIJMzU1MwkzNTgyCTM1OTAJMzU5NAkzNTk5CTM2MTgJMzYzNwkz
NjUxCTM2NTUJMzY2NwkzNzEyCTM3MzIJMzc0NAkzNzU3CTM4NDMJMzg0NgkzODg4CTM5ODUJ
NDAxNgk0MTA3CTQxODgJNDI3MQk0MzIwCTQ0NTkJNDU0NAk0NTgwCTQ2NzAJNDc2Mwk0Nzc1
CTQ3ODQJNDc4Ny4JNDc4OC4uLi4uLi4uLgk0ODAwCTQ4MDIuLi4uLi4JNDgwMy4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA1MTk3G1sw
bQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDUxOTcsIGxpbWl0IHRvIDUw
MDAbWzBtCgk0OTIxCTUwMjMJNTI0MAk1MzE5CTUzODcJNTQzMAk1NDc0CTU0OTcJNTUzOAk1
NTQwCTU1NDkJNTU1Mgk1NTU5CTU1NzAJNTYxMwk1NjI0CTU2NDgJNTY2OQk1Njg3CTU3MzQJ
NTc3Ngk1NzkwCTU4MjguCTU4MzcJNTg0NQk1ODYwCTU4OTAJNTkzNAk1OTU2CTU5NjMJNTk3
Mwk2MDA2CTYwMTkJNjAyOAk2MDMzCTYwMzguCTYwNzgJNjE0NQk2MjExCTYyODkJNjMyOAk2
MzY1CTY0NzcJNjQ4OQk2NjA0CTY2ODYJNjcwMAk2NzY2CTY4NjAJNjkzNgk3MDAzCTcwODkJ
NzE2Ngk3MTk1CTczMzYJNzQwOAk3NDQ2CTc0NzQJNzUwNAk3NTE4CTc1MTkJNzUyMC4JNzUy
Mgk3NTI2CTc1MzAuCTc1MzEJNzUzNy4JNzU0MQk3NTQ4CTc1NTMJNzU1OC4JNzU2MC4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JNzU2MQk3NTYyLi4uLgk3NTYzCTc1NjQuLi4uCTc1NjUuCTc1
NjkJNzU3NAk3NTc2CTc1NzkJNzU4Mgk3NTgzCTc1ODUJNzU4OQk3NTkwCTc2MDQJNzYxNQk3
NjIzCTc2MjcJNzYyOC4uCTc2NDMJNzY1Mwk3NjYwCTc2NzIJNzY3NAk3Njg0CTc2OTAJNzY5
OQk3NzA1CTc3MDcJNzcxMQk3NzE3CTc3MzgJNzc2NQk3Nzg0CTc3OTEJNzgwMgk3ODIwCTc4
MzEJNzg0MAk3ODQ0CTc4NjUJNzg3OAk3ODkyCTc5MDAJNzkxMgk3OTIwCTc5MjQJNzkzMgk3
OTQyCTc5NjEJNzk3Mgk3OTkxCTgwMTAJODAzMQk4MDQ1CTgwNTYJODA2Mwk4MDY2CTgwNjkJ
ODA5OQk4MTI0CTgxNDIJODE2Mgk4MTk1CTgyMTcJODIyOQk4MjU5CTgyOTIJODMxOAk4MzU1
CTgzNzYJODQxNgk4NDgxCTg1MzYJODU4OAk4NjA2CTg2MjkJODY0MAk4NjU3CTg2NjQJODY3
Mwk4NjgwCTg2ODgJODY5MAk4Njk2CTg3MTkJODczOAk4NzUwCTg3NTcJODc4MQk4NzkzCTg4
MDIJODgxNwk4ODMwCTg4NDYJODg1OAk4ODY2CTg4NzIJODg4MAk4ODg4CTg4OTkJODkxNAk4
OTM4CTg5NDIJODk1MAk4OTY2CTg5OTIJOTAwNwk5MDA4CTkwMzcJOTA1NAk5MDc2CTkxMDUJ
OTExOQk5MTQwCTkxNTYJOTE2Ngk5MTczCTkxODAJOTE5NQk5MTk3CTkyMDgJOTIyNgk5MjQ3
CTkyNTgJOTI2NQk5MjcwCTkyNzgJOTI4Nwk5MjkyCTkzMjAJOTM1MAk5Mzc3CTk0MDAJOTQz
MQk5NDU2CTk0OTUJOTUxNwk5NTM0CTk1NDkJOTU3MQk5NTgxCTk1OTcJOTYxMQk5NjI3CTk2
MzcJOTY0OAk5NjYzCTk2NzkJOTY5Mwk5Njk5CTk3MTMJOTcyNgk5NzUxCTk3NjcJOTc4MAk5
Nzk2CTk4MjIJOTg0MQk5ODUzCTk4ODAJOTg5Nwk5OTE2CTk5MzYJOTk1OAk5OTY4CTEwMDIy
IFNVQ0NFU1MKCkJpc2VjdGluZzogNjIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDYgc3RlcHMpCls4MGI5ODAyNzk1MDhlZGQxYTkyZDhkNzdlYzk5YjBk
ZGFkMDBjNWZlXSBCbHVldG9vdGg6IFVzZSBjaGFuIGFzIHBhcmFtZXRlcnMgZm9yIGwyY2Fw
IGNoYW4gb3BzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRl
dmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDo4MGI5ODAyNzk1MDhlZGQxYTkyZDhkNzdlYzk5
YjBkZGFkMDBjNWZlOmJpc2VjdC1zb3VuZAogVEVTVCBGQUlMVVJFCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXMwNC0wNjA1LzgwYjk4MDI3OTUwOGVkZDFhOTJkOGQ3N2VjOTliMGRkYWQw
MGM1ZmUvZG1lc2cta3ZtLXZwLTI1NzE0LTIwMTMwNjEyMTcxODUzLTMuNS4wLXJjMS0wMDA2
Mi1nODBiOTgwMi00NAoKQmlzZWN0aW5nOiAzMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzZlYTAwNDg1NzUwODllOWE3MTRlMDhiYzNk
ZWJlYzRiMWI5ZDc2NjRdIEJsdWV0b290aDogUmVtb3ZlIHVubmVjY2VzYXJ5IGlubGluZQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4
Ni0yMDEzMDYwNjIxNTQ6NmVhMDA0ODU3NTA4OWU5YTcxNGUwOGJjM2RlYmVjNGIxYjlkNzY2
NDpiaXNlY3Qtc291bmQKCjIwMTMtMDYtMTUtMTM6MTU6NDcgNmVhMDA0ODU3NTA4OWU5YTcx
NGUwOGJjM2RlYmVjNGIxYjlkNzY2NCByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1z
MDQtMDYwNS82ZWEwMDQ4NTc1MDg5ZTlhNzE0ZTA4YmMzZGViZWM0YjFiOWQ3NjY0L3ZtbGlu
dXotMy41LjAtcmMxLTAwMDMxLWc2ZWEwMDQ4ChtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlOiBy
ZXF1ZXN0ZWQgMTAwMDAsIGxpbWl0IHRvIDUwMDAbWzBtCgoyMDEzLTA2LTE1LTEzOjE2OjAw
IGRldGVjdGluZyBib290IHN0YXRlIC4JMi4JNQk2CTcJMTAJMTEJMTQuCTE1CTI5CTM5CTQ3
CTYwCTY3CTcyLgk3MwkxMTAJMTQ3CTE2OAkxODUJMjA0CTIxNAkyMTgJMjIyCTIzMAkyNjYJ
Mjk2CTMxNQkzMzIJMzQ1CTM1NwkzNzEJMzkxCTM5OQk0MTMJNDI1CTQyOQk0MzEJNDUyCTQ3
Ngk1MDkJNTI1CTUzMAk1NDMJNTU1CTU2NQk1NzUJNTg0CTU5Ngk2MDMJNjE4CTYyOAk2MzUJ
NjQzCTY1MAk2NjMJNjc2CTY5Mgk2OTgJNzA2CTcxNwk3NDEJNzU5CTc3MQk3NzYJNzkyCTgw
Nwk4MjQJODM2CTgzOC4JODU1CTg3OAk4OTYJOTE1CTkyMgk5MzIJOTUyCTk5MAkxMDI4CTEw
NDcJMTA1OQkxMDczCTEwODAJMTA4MQkxMDk5CTExMjEJMTE0MQkxMTUyCTExNzAJMTE4Mwkx
MTk4CTEyMTAJMTI2NwkxMzMyCTEzODgJMTQzNwkxNDc0CTE1MzgJMTU5MwkxNjM2CTE2ODAJ
MTczMwkxNzY4CTE4MDMJMTg0NQkxODc2CTE5MDkJMTkzOQkxOTcwCTIwMDAJMjAyNQkyMDQ2
CTIwNjQJMjA5MQkyMTIyCTIxMzgJMjE0NwkyMTYzCTIxODMJMjIyMwkyMjgxCTIzNTUJMjQy
OAkyNTA3CTI1OTAJMjY0OQkyNzMwCTI4MDMJMjg1MgkyOTAwCTI5NTcJMzAxNwkzMDU4CTMx
MDIJMzE0OAkzMTg5CTMyMjYJMzI2MwkzMzA0CTMzMzcJMzM2OQkzMzk0CTM0MjAJMzQ1MAkz
NDc5CTM1MTEJMzUzNAkzNTU0CTM1ODkJMzYwNAkzNjE5CTM2MzYJMzY0OQkzNjU2CTM2NjUJ
MzcwNAkzNzU4CTM4MTgJMzg4NwkzOTQ1CTM5OTUJNDAzMAk0MDgzCTQxMjgJNDE2OQk0MjEz
CTQyNTgJNDMwNgk0MzQ5CTQ0MDQJNDQ1MAk0NDkxCTQ1MzEJNDU4MQk0NjEyCTQ2NTQJNDY4
OQk0NzQwCTQ3ODEJNDgwOAk0ODMyCTQ4NTcJNDg3NAk0ODk4CTQ5MjAJNDkzMwk0OTQwCTQ5
NTcJNDk3NAk0OTgyCTQ5OTMJNDk5Nwk1MDAyCTUwMDkJNTAxNgk1MDE5CTUwMjUJNTAzMgk1
MDQxCTUwOTYJNTE1MQk1MTk2CTUyNDQJNTI4OAk1MzI4CTUzNzUJNTQyMwk1NDYwCTU0OTYJ
NTU0MQk1NTg4CTU2MTkJNTY0OAk1NjgzCTU3MjMJNTc2OAk1ODA1CTU4NTAJNTg4OQk1OTIx
CTU5NTYJNTk4Ngk2MDE2CTYwNDEJNjA3Mgk2MTAxCTYxMjIJNjE0MQk2MTY4CTYxODMJNjE5
Ngk2MjA5CTYyMjAJNjIyOQk2MjM5CTYyNDYJNjI1NAk2MjYwCTYyOTUJNjQzOAk2NTc3CTY3
MDEJNjc0OAk2ODEzCTY4ODgJNjk3MQk3MDUyCTcxMjIJNzIwNwk3MzQzCTc0NjkJNzU0Mgk3
NjQwCTc3NTgJNzg2OAk3OTc4CTgxMDAJODI1Nwk4NDAyCTg1MzMJODY3OAk4ODIxCTg5NjUJ
OTEwNwk5MjM4CTkzOTMJOTUyNAk5NjI1CTk3MDQJOTc5MQk5ODY1CTk5ODcJMTAxMTggU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNCBzdGVwcykKW2MzYzdlYTY1OTQxYTBiN2E0ZjFiOTY1NWU3YWFhYWI2Y2Ux
ODc0ZDJdIEJsdWV0b290aDogRml4IGNvZGluZyBzdHlsZSBpbiBpbmNsdWRlL25ldC9ibHVl
dG9vdGgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwt
c25iLWkzODYtMjAxMzA2MDYyMTU0OmMzYzdlYTY1OTQxYTBiN2E0ZjFiOTY1NWU3YWFhYWI2
Y2UxODc0ZDI6YmlzZWN0LXNvdW5kCiBURVNUIEZBSUxVUkUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctczA0LTA2MDUvYzNjN2VhNjU5NDFhMGI3YTRmMWI5NjU1ZTdhYWFhYjZjZTE4NzRk
Mi9kbWVzZy1rdm0tcm9hbS0zMjY2NC0yMDEzMDYxNDEzMjYzMC0zLjUuMC1yYzEtMDAwNDYt
Z2MzYzdlYTYtNDYKCkJpc2VjdGluZzogNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMyBzdGVwcykKW2Q2NjAzNjZkNTMxMTlmYmQ5ODhlMWIxZDZlYTJj
MDAzNThhOGU2ODhdIEJsdWV0b290aDogUmVtb3ZlIGRlYWQgaW50IHJldHVybnMKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAx
MzA2MDYyMTU0OmQ2NjAzNjZkNTMxMTlmYmQ5ODhlMWIxZDZlYTJjMDAzNThhOGU2ODg6Ymlz
ZWN0LXNvdW5kCgoyMDEzLTA2LTE1LTE1OjM1OjA3IGQ2NjAzNjZkNTMxMTlmYmQ5ODhlMWIx
ZDZlYTJjMDAzNThhOGU2ODggcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2
MDUvZDY2MDM2NmQ1MzExOWZiZDk4OGUxYjFkNmVhMmMwMDM1OGE4ZTY4OC92bWxpbnV6LTMu
NS4wLXJjMS0wMDAzOC1nZDY2MDM2NgobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVz
dGVkIDEwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xNS0xNTozNToxMiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMjkJODIJMTU0CTIzMQkzMDMJMzUxCTM1NwkzNTgJMzcxCTQzNwk1
MTAJNTYzCTYwMAk2NTMJNzA4CTc0MiBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLXN0b2FrbGV5
LTUxMTctMjAxMzA2MTUxNTM4MzAtMy41LjAtcmMxLTAwMDM4LWdkNjYwMzY2LTQ3CgpCaXNl
Y3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIg
c3RlcHMpCltkMWRlNmQ0NmRjN2I1MDNkNzdlYzU5Yzg0OWFjYWNhZGZlY2UxZGExXSBCbHVl
dG9vdGg6IEVuYWJsZSBFUlRNIGJ5IGRlZmF1bHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0
LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OmQxZGU2ZDQ2
ZGM3YjUwM2Q3N2VjNTljODQ5YWNhY2FkZmVjZTFkYTE6YmlzZWN0LXNvdW5kCgoyMDEzLTA2
LTE1LTE3OjAyOjUzIGQxZGU2ZDQ2ZGM3YjUwM2Q3N2VjNTljODQ5YWNhY2FkZmVjZTFkYTEg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvZDFkZTZkNDZkYzdiNTAz
ZDc3ZWM1OWM4NDlhY2FjYWRmZWNlMWRhMS92bWxpbnV6LTMuNS4wLXJjMS0wMDAzNC1nZDFk
ZTZkNAobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0
byA1MDAwG1swbQoKMjAxMy0wNi0xNS0xNzowMjo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
Li4uLi4JNwkxMwkyMwkzNAk0MQk1Mwk1OS4JNjAJNjEuLi4JNjIuCTYzLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTQyCTIyMAkyODIJMzQ5CTQxMAk0NzEJNTAyCTUx
OQk1MjAJNTIyCTUzNwk1NTEJNTU4CTU2OQk1NzYJNTc3CTU4Nwk1OTMJNjA2CTYxMwk2MTUJ
NjI2CTYzOQk2NDYJNjUzCTY2Mgk2NjgJNjc2CTY4NAk2OTEJNjkzCTcwMAk3MDcJNzA4CTcx
Mgk3MTcJNzE4CTcyMgk3MjUuLi4JNzI2CTcyNy4uCTcyOQk3MzUJNzQ2CTc1MQk3NjAJNzY5
CTc3Mgk3NzUJNzc3CTc4NAk3OTEJNzk3CTgxMgk4MTQJODE2CTgyNwk4MzAJODM2CTg0Mwk4
NTIJODYxCTg2OAk4NzMJODc4CTg4MQk4OTAJODkyCTg5Ngk4OTkJOTA2CTkxNgk5MjIJOTI1
CTkyOAk5MzIJOTQyCTk1MAk5NTYJOTU4CTk2Ngk5NzkJOTk0CTk5NQkxMDAwCTEwMDkJMTAx
NgkxMDE4CTEwMjIJMTAzMQkxMDM1CTEwNDIJMTA0NwkxMDUzCTEwNjEuCTEwNjUJMTA3Mgkx
MDc5CTEwODMJMTA4NgkxMDg4CTEwOTMJMTA5NQkxMTAwCTExMDIJMTEwNgkxMTA3CTExMTYJ
MTEyMQkxMTI1CTExMjYJMTEyOC4uCTExMjkuLgkxMTQxCTExNTIJMTE2OAkxMTc3CTExODQu
LgkxMTg2CTExOTYJMTIwMQkxMjA5CTEyMTYJMTIyMgkxMjI0CTEyMzEJMTIzNwkxMjM5CTEy
NDAJMTI0MQkxMjQyLgkxMjQzLgkxMjQ1Li4uLi4uCTEyNTQJMTI3MwkxMzAxCTEzMjEJMTMz
OAkxMzQ0Li4JMTM0NQkxMzQ3Li4uCTEzNTgJMTM3MwkxMzg0CTEzOTgJMTQwMwkxNDA3CTE0
MTEuLgkxNDEyCTE0MjcJMTQ0MwkxNDU2CTE0NzMJMTQ3NgkxNDc3CTE0ODUJMTQ5MgkxNDk1
CTE0OTcJMTUwMy4JMTUwNAkxNTA3CTE1MTIJMTUxNgkxNTIxCTE1MjcJMTUyOQkxNTMwCTE1
MzMJMTUzOQkxNTQ3CTE1NDgJMTU0OQkxNTUxCTE1NTYJMTU1OC4JMTU2NwkxNTc1CTE1ODYJ
MTU5MAkxNTk2CTE2MDIJMTYwNQkxNjA2CTE2MDcJMTYwOS4JMTYxMgkxNjIwCTE2MjUJMTYz
MwkxNjM1CTE2MzYJMTYzNwkxNjM4CTE2MzkJMTY0NgkxNjQ5CTE2NTIJMTY1MwkxNjU1CTE2
NTgJMTY2MQkxNjY3CTE2NzAJMTY3MwkxNjc3Li4JMTY4MAkxNjgzCTE2ODcJMTY5MAkxNjkx
CTE2OTIJMTY5My4JMTY5OAkxNzE0CTE3MjUJMTczOAkxNzQ0LgkxNzQ4CTE3NTAJMTc1Nwkx
NzYwCTE3NjcJMTc2OS4JMTc3MQkxNzc3CTE3ODAJMTc4NQkxNzkyCTE3OTgJMTgwMC4JMTgw
NgkxODExCTE4MTMJMTgxNQkxODE3CTE4MTkJMTgyMC4JMTgyMy4uCTE4MjQuCTE4MzkJMTg2
MwkxODc1CTE4OTAJMTg5MwkxODk0CTE4OTcJMTg5OAkxOTAzCTE5MTAJMTkxMQkxOTEyCTE5
MTcJMTkyMQkxOTI2CTE5MjcJMTkyOS4JMTkzNQkxOTQ1CTE5NjEJMTk3MS4JMTk3NwkxOTgz
CTE5ODgJMTk5NQkxOTk3LgkyMDAzCTIwMTEJMjAxOQkyMDIzLgkyMDI3CTIwMzUJMjA0NAky
MDUwCTIwNTYJMjA1NwkyMDYzCTIwNzIJMjA4NAkyMDg4CTIwOTMgVEVTVCBGQUlMVVJFCmRt
ZXNnLWt2bS12cC0xODY3OC0yMDEzMDYxNTIwMTMwNy0zLjUuMC1yYzEtMDAwMzQtZ2QxZGU2
ZDQtNTEKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMSBzdGVwKQpbNTIyY2MyZWU2ZTU1YmE0OWY0ZGYzMzhlMGRmY2ZiOTg5YjQ2
ZWI4Y10gQmx1ZXRvb3RoOiBSZW1vdmUgdW51c2VkIEVSVE0gY29udHJvbCBmaWVsZCBtYWNy
b3MKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25i
LWkzODYtMjAxMzA2MDYyMTU0OjUyMmNjMmVlNmU1NWJhNDlmNGRmMzM4ZTBkZmNmYjk4OWI0
NmViOGM6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE1LTIwOjE0OjUwIDUyMmNjMmVlNmU1NWJh
NDlmNGRmMzM4ZTBkZmNmYjk4OWI0NmViOGMgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctczA0LTA2MDUvNTIyY2MyZWU2ZTU1YmE0OWY0ZGYzMzhlMGRmY2ZiOTg5YjQ2ZWI4Yy92
bWxpbnV6LTMuNS4wLXJjMS0wMDAzMy1nNTIyY2MyZQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1
ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xNS0yMDox
NDo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEuLi4uLi4uLgk2CTEzCTE3CTI1CTI5Lgkz
NAkzNwk0NAk0OAk1MAk1Mi4JNTkJNzEJNzgJODkJOTMJOTgJMTAzCTEwOAkxMTgJMTIyCTEy
OAkxMzUJMTQyCTE0Ni4JMTUwCTE2MQkxNjYJMTcyCTE3NwkxODMJMTkzCTE5NAkxOTcuLgky
MDAJMjAxCTIwMgkyMDgJMjUyCTI2MgkyNzAJMjcyCTI3NAkyNzcJMjg0CTI4OAkyOTcJMzA2
CTMxNQkzMjcuCTM0MQkzNDUJMzQ4CTM1NAkzNjEJMzY3CTM3MgkzNzcJMzgxCTM4NwkzODkJ
Mzk5CTQwMAk0MDUJNDEwCTQxMQk0MTYJNDI0CTQyNQk0MzMJNDM4CTQ0MQk0NDgJNDU1CTQ1
Ngk0NTgJNDYyCTQ2Mwk0NjcJNDc0CTQ3Ngk0ODMuCTQ4Ngk0OTAJNDkyCTQ5NQk1MDUJNTA4
CTUxNAk1MTcJNTI0CTUyOQk1MzMuCTU0Ngk1NTAJNTUxCTU2Mwk1NjYJNTY4Li4JNTkwCTU5
Ngk1OTkJNjA0CTYwNwk2MDgJNjA5Lgk2MTQJNjE5CTYyNwk2MzMJNjQyCTY0NAk2NTIJNjY0
CTY3MQk2NzUJNjc2CTY4NQk2OTAJNzAxCTcwOQk3MTkJNzI2CTczOQk3NTUJNzYxCTc2OAk3
ODEJNzg2CTc5OAk4MDEJODA0CTgxMAk4MTUJODIwLgk4MzcJODQ5CTg1MQk4NTUJODYzCTg2
OQk4NzMJODg2CTg5MAk4OTkJOTA1CTkxMgk5MTYuCTkxOAk5MjEJOTMwCTk0MAk5NTAJOTYw
CTk2OAk5NzAJOTcyCTk3NQk5ODUJOTkxCTk5NgkxMDAyCTEwMDYJMTAwNwkxMDE2CTEwMjcJ
MTA0NQkxMDU0CTEwNTkJMTA2NQkxMDcwCTEwODQJMTA5MgkxMDk2CTEwOTkJMTEwNAkxMTE5
CTExMzAJMTEzNQkxMTM3CTExNDQJMTE1MQkxMTU0CTExODQJMTE5NQkxMjE4CTEyMzAuCTEy
NDUJMTI1NgkxMjY0CTEyNjYuLgkxMjc0CTEyOTUuCTEzMDMJMTMxMgkxMzM2CTEzNDgJMTM1
MAkxMzU1CTEzNjAJMTM3MwkxMzk0CTE0MDEJMTQwNAkxNDE4CTE0MjUJMTQzOQkxNDU2CTE0
NzEJMTQ3NwkxNDgyCTE0ODkJMTQ5MgkxNDk3CTE1MDUJMTUyMwkxNTM2CTE1MzkJMTU1NAkx
NTYwCTE1NjMJMTU2NgkxNTgwCTE2MDEJMTYwNgkxNjE3CTE2MzAJMTYzOAkxNjQ2CTE2NTUJ
MTY2NAkxNjcyCTE2ODEJMTY4MgkxNjkxCTE3MDAJMTcwOQkxNzE4CTE3MjcJMTczNQkxNzQ3
CTE3NjIJMTc3MgkxNzgzCTE3OTQJMTgwNwkxODEwCTE4MzAJMTgzNgkxODQ1CTE4NjUJMTg3
MQkxODc1CTE4ODgJMTg5MQkxODk2CTE5MDcJMTkxOQkxOTI4CTE5MzQJMTk0NAkxOTY2CTE5
NzQJMTk4MwkxOTk1CTE5OTkJMjAwMwkyMDEwCTIwMTgJMjAzNAkyMDQzCTIwNTAJMjA1OAky
MDcyCTIwODIJMjA5MAkyMDk1Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIxMDAJMjE3MwkyMjMyCTIyNTUJMjM0NQkyMzgz
CTI0MTMJMjUxMwkyNTg2CTI2NTMJMjY1OQkyNzA2CTI3MjcJMjczMgkyNzMzCTI3NDcJMjc3
NwkyNzgzCTI3ODkJMjc5OQkyODA5CTI4MTUJMjgyMwkyODI5CTI4MzgJMjg1MAkyODU0CTI4
NjQJMjg3MAkyODcxCTI4NzQJMjg4MAkyODg1CTI4OTQJMjg5NgkyOTA1CTI5MDYJMjkxMwky
OTE5CTI5MjYJMjkyNwkyOTMzCTI5MzYuCTI5NDMJMjk0OQkyOTU0CTI5NjkJMjk3NQkyOTg5
CTMwMDcJMzAxOQkzMDIxCTMwNDQJMzA0NwkzMDUxCTMwOTYJMzEyOQkzMTQ5CTMxODUJMzIw
MAkzMjMwCTMyNDYJMzI2MQkzMjgzCTMyOTkJMzM0NQkzMzYyCTMzODcJMzM5OAkzNDEyCTM0
MjQJMzQzNgkzNDQ5CTM0NjQJMzQ4MgkzNDg2CTM1MDcJMzUxNAkzNTMzCTM1MzkJMzU1Ngkz
NTcwCTM1OTEJMzYwOQkzNjI5CTM2MzIuLi4uLi4JMzcxMgkzODY0CTM5MTAJMzkyNQkzOTcz
CTM5OTgJNDAyNQk0MDM2CTQwNjcJNDA5MAk0MDk2CTQxMzYJNDE1NAk0MTY5CTQxOTAuLi4J
NDIzMQk0MzMxCTQzNTIJNDM3Mgk0MzkzCTQzOTkJNDQwMQk0NDY2CTQ0OTIJNDUwMgk0NTY1
CTQ2MTAJNDY1NQk0NjgyCTQ3MTEJNDc0MAk0NzU1CTQ4MDQJNDgyOAk0ODQzCTQ4NjcJNDg5
MQk0OTI0CTQ5MjgJNDk1MAk0OTU5CTQ5ODUJNDk4Ni4JNDk5MAk0OTkxLi4JNDk5Mi4uLi4u
Li4uLi4uCTQ5OTQuLi4uCTQ5OTUuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sx
OzM1bWFkZF90b19ydW5fcXVldWUgNTAwNRtbMG0KG1sxOzM1bWFkZF90b19ydW5fcXVldWU6
IHJlcXVlc3RlZCA1MDA1LCBsaW1pdCB0byA1MDAwG1swbQouCTQ5OTYJNTAwMAk1MDE3CTUw
MjYJNTAzNgk1MDQzCTUwNTgJNTA2OQk1MDgxCTUxMDEJNTExNwk1MTIyCTUxMjMJNTEzMQk1
MTQ0CTUxNTQJNTE2Nwk1MTY4CTUxNzMJNTE3OQk1MTgxCTUxOTAJNTIxNQk1MjI1CTUyMzUJ
NTI3MAk1Mjk2CTUzMjMJNTM0Mwk1MzUwCTUzNjAJNTM2NQk1MzcwCTUzNzMJNTM3OQk1Mzg5
CTUzOTgJNTQxNAk1NDI1CTU0MzIJNTQ0Mgk1NDQ2CTU0NzgJNTQ4OAk1NDk2CTU1MDUJNTUx
My4JNTUyMwk1NTQ2CTU1NjUJNTU5Mgk1NjIwCTU2MzQJNTY2Mgk1NjY5CTU2NzUJNTY3OAk1
Njk5CTU3MDkJNTcxNwk1NzI2CTU3MzkJNTc1Mwk1NzcwCTU3ODUJNTgxMwk1ODI4CTU4NDMJ
NTg1NQk1ODY0CTU4NjgJNTg3Nwk1ODkyCTU5MDIJNTkxOAk1OTI1CTU5MjYJNTkzNQk1OTM3
CTU5MzkuCTU5NDAJNTk2Ngk2MDE1CTYwMjYJNjAzMwk2MDQzCTYwNjIJNjA2OAk2MDgzCTYw
OTEJNjA5Ngk2MTEyCTYxMzcJNjE0Nwk2MTU0CTYxNjkJNjE4MAk2MTkyCTYyMDMJNjIxNQk2
MjI2CTYyMzUJNjI0NAk2MjU5CTYyNjkJNjI3Nwk2Mjg1CTYzMDMJNjMwNQk2MzIzCTYzMzQJ
NjM0MC4JNjM1Mwk2MzYzCTYzNjgJNjM3OAk2Mzg4CTY0MDIJNjQxNAk2NDMwCTY0NTAJNjQ1
Ngk2NDYyCTY0NzAJNjQ4Mgk2NDg4CTY0OTUJNjQ5OAk2NTE2CTY1MjMJNjUyNAk2NTcxCTY1
NzgJNjU5Mwk2NTk5CTY2MDcJNjYxOAk2NjIwCTY2MjcJNjY0Mgk2NjQ5CTY2NjAJNjY2Ngk2
Njc1CTY2ODYJNjY5Mwk2Njk3CTY3MTIJNjcxNgk2NzI0CTY3MjkJNjc0MQk2NzQ4CTY3NjAJ
Njc2OAk2Nzc3CTY3ODQJNjc5MAk2NzkzCTY4MDQJNjgwOQk2ODExCTY4MTQJNjgxOAk2ODMz
CTY4MzcJNjg0Ngk2ODQ3CTY4NTYJNjg2MQk2ODY1CTY4NzEJNjg3Ngk2ODgwCTY4ODUJNjg5
MQk2ODk2CTY4OTkJNjkwMQk2OTAzCTY5MDQJNjkwNwk2OTIwCTY5MjIuCTY5MjUJNjkyNwk2
OTMwCTY5MzIJNjkzNS4JNjk0MQk2OTQyCTY5NDkJNjk1OC4JNjk2Nwk2OTczCTY5ODIJNjk4
Ngk2OTg4CTY5ODkJNjk5MQk2OTk0CTcwMDAJNzAwMgk3MDIxCTcwMjUJNzAyNwk3MDQ3CTcw
NTYJNzA2Ngk3MDgwCTcwODMJNzA5MAk3MTAyCTcxMTAJNzExNAk3MTIyCTcxMjcJNzEzNAk3
MTQzCTcxNDkJNzE1Mwk3MTYyCTcxNzYJNzE5Mgk3MjA4CTcyMTAJNzIxOQk3MjI1CTcyMzcJ
NzI0MQk3MjUyCTcyNTQJNzI1OAk3MjczCTcyODYJNzI5Mwk3Mjk1CTczMDYJNzMxMgk3MzIy
CTczMjgJNzMzOAk3MzQwCTczNDEJNzM2MQk3MzcwCTczNzkJNzM4OAk3MzkyCTczOTkJNzQw
Mwk3NDA3Lgk3NDExCTc0MTYJNzQyMC4JNzQyMgk3NDM2CTc0NDEJNzQ0Mwk3NDY1CTc0NzgJ
NzQ4MAk3NDk0CTc1MDgJNzUyMwk3NTI2CTc1MjgJNzUzNwk3NTQ3CTc1NjUJNzU3Mgk3NTg5
CTc2MDEJNzYxMQk3NjE5CTc2MjkJNzYzOAk3NjQwCTc2NTYJNzY2MAk3NjYyCTc2NzcJNzY4
MQk3Njk2CTc3MDUJNzcxNwk3NzMwCTc3NDMJNzc1MAk3NzYwCTc3NzcJNzc5Mwk3Nzk0CTc3
OTkJNzgxNQk3ODI1CTc4MzcJNzg0MQk3ODUyCTc4NjAJNzg3NAk3ODg2CTc4OTAJNzkwMwk3
OTEwCTc5MTYJNzkyMgk3OTM0CTc5NDkgVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1iZW5zLTc3
MTItMjAxMzA2MTYwNTQ2NDctMy41LjAtcmMxLTAwMDMzLWc1MjJjYzJlLTU3CgpCaXNlY3Rp
bmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3Rl
cHMpClsyNzM3NTllMmMzYmQ2OWVmZTc0Nzk5YzQ0NmRmNjlkOWVhNWNhNDE4XSBCbHVldG9v
dGg6IFNldCB0eHdpbiB2YWx1ZXMgZm9yIHN0cmVhbWluZyBtb2RlCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1
NDoyNzM3NTllMmMzYmQ2OWVmZTc0Nzk5YzQ0NmRmNjlkOWVhNWNhNDE4OmJpc2VjdC1zb3Vu
ZAoKMjAxMy0wNi0xNi0wNTo0ODowOSAyNzM3NTllMmMzYmQ2OWVmZTc0Nzk5YzQ0NmRmNjlk
OWVhNWNhNDE4IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1LzI3Mzc1
OWUyYzNiZDY5ZWZlNzQ3OTljNDQ2ZGY2OWQ5ZWE1Y2E0MTgvdm1saW51ei0zLjUuMC1yYzEt
MDAwMzItZzI3Mzc1OWUKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAxMDAw
MCwgbGltaXQgdG8gNTAwMBtbMG0KCjIwMTMtMDYtMTYtMDU6NDg6MTQgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLgkxCTgJMTAJMjIJMjMJMjQJMjUJNTAJNzUJODEJOTQJMTE2CTEzMQkxMzYJ
MTUwCTE2MAkxNzIJMTc1CTE4MwkxOTAJMTk3CTIwMgkyMDYJMjEwCTIxOAkyMjMJMjI5CTIz
MAkyMzkJMjQwCTI0NQkyNTEJMjU1CTI2MAkyNjIJMjczCTI3OQkyODMJMjg4CTI5NQkyOTcJ
MzAzCTMwOC4JMzEyLgkzMTUJMzE5CTMyNAkzMzIJMzQwCTM0MwkzNDQJMzQ4CTM0OQkzNTIJ
MzUzCTM2MQkzNjcJMzczCTM4MwkzOTMJMzk5CTQwMAk0MDgJNDI1CTQzMwk0MzgJNDQ5CTQ1
My4JNDY1CTQ4Mwk0OTQJNTA0CTUxMAk1MTMJNTE1CTUyNgk1MzQJNTM3CTU0Ngk1NjMJNTY2
CTU3OAk1ODUJNTk4CTYwMwk2MTQJNjIwCTYzOQk2NjEJNjcxCTY4NQk3MjcJNzM2CTc0Nwk3
NTYuCTc1Nwk3NzIJODA3CTgyMwk4NjUJODg3CTkwOAk5MjUJOTQ1CTk3NQk5ODgJOTk2CTEw
MTgJMTAyNQkxMDM1CTEwNDEJMTA1MAkxMDY0LgkxMDcwCTEwODYJMTA5NgkxMTE2CTExMjUJ
MTE1NQkxMTU5CTExNjUJMTE4NgkxMjA3CTEyMjkJMTIzMwkxMjc3CTEzMTMJMTM0MAkxMzY4
CTEzODkJMTQwMgkxNDIzCTE0NDgJMTQ2NgkxNDg3CTE1MDYJMTUyMwkxNTUxCTE1NjcJMTU4
NgkxNjA1CTE2MDcJMTYzMgkxNjM3CTE2NDMJMTY2NwkxNjgwCTE3MDAJMTczMAkxNzQwCTE3
NjIJMTc3NgkxNzkwCTE4MDAJMTgyMAkxODQwCTE4NTQJMTg3MAkxODkyLgkxOTMxCTE5NDMJ
MTk1MgkxOTYwCTE5NjYJMTk3MwkxOTg1CTE5OTIJMjAxMgkyMDE3CTIwNDYJMjA1OAkyMDcz
CTIwODkJMjEwOQkyMTMyCTIxNDkJMjE3MwkyMTk4CTIyMTQJMjIxOQkyMjI2CTIyMzkJMjI1
OAkyMjU5CTIyOTAJMjMxNgkyMzQzCTIzNzIuCTIzNzkJMjQxMAkyNDEyCTI0MTUJMjQyMwky
NDI1CTI0MzcJMjQ0NgkyNDUxCTI0NjQJMjQ4NQkyNDk3CTI1MDgJMjUxNAkyNTI2CTI1MzQJ
MjUzOAkyNTUyCTI1NjgJMjU3NAkyNTg4CTI1OTUJMjYwNgkyNjE5CTI2MjcJMjYzOQkyNjQ4
CTI2NTMJMjY1NgkyNjU5CTI2NjMJMjY3NgkyNjgyCTI2ODYJMjcwMAkyNzE0CTI3MjcJMjcz
NQkyNzQ4CTI3NTEJMjc2OQkyNzczCTI3NzkJMjc5MgkyODAxCTI4MTEJMjgxNgkyODE3CTI4
MjkJMjgzNQkyODQzCTI4NjIJMjg2NAkyODgyCTI4ODcJMjkwMgkyOTEzCTI5MTUJMjkyNgky
OTM2CTI5NTUJMjk3MQkyOTc4CTI5ODIJMzAwMQkzMDA4CTMwMTYJMzAyMAkzMDM2CTMwMzgJ
MzA0NgkzMDUxCTMwNjEJMzA3MAkzMDg0CTMwODgJMzEwMAkzMTA5CTMxMTIJMzEyNgkzMTQw
CTMxNTcJMzE3MgkzMTgwCTMxODQJMzIwMwkzMjE0CTMyMTkJMzIyMgkzMjI2CTMyMjcJMzIz
MgkzMjM1CTMyMzcJMzIzOAkzMjQ3CTMyNTcJMzI2NgkzMjc4CTMyODUJMzI5MwkzMzEwCTMz
MjUJMzMzMQkzMzUwCTMzNTkJMzM2NQkzMzc4CTMzOTAJMzM5MgkzNDAyCTM0MTUJMzQyNQkz
NDM0CTM0NTYJMzQ2NwkzNDk1CTM1MDQJMzUzNwkzNTUxCTM1NzMJMzU5MgkzNjE0CTM2MzMJ
MzY1NQkzNjgzCTM2OTkJMzcxNQkzNzI0CTM3NDcJMzc3MgkzNzgzCTM3OTYJMzgwOAkzODIz
CTM4MzQJMzg0Ny4JMzg4MQkzODk4CTM5MDQJMzkyOAkzOTQ0CTM5NTQJMzk2NgkzOTgyCTM5
OTYJNDAxMwk0MDIyCTQwMzQJNDA0Ngk0MDU5CTQwNzQJNDA4NQk0MDg5CTQxMTkJNDEyMgk0
MTQ1CTQxNTEJNDE2MS4JNDE3NAk0MTk5Lgk0MjE4CTQyMjUJNDI0Nwk0MjU5CTQyNjkJNDI4
NQk0MzA0CTQzMTUJNDMyOQk0MzM2CTQzNDgJNDM1Nwk0MzY1CTQzODYJNDQwMQk0NDEwCTQ0
MjcJNDQzOQk0NDUyCTQ0NjkJNDQ4Mwk0NDk2CTQ1MTMJNDUyMwk0NTMxCTQ1NDQJNDU1Mwk0
NTU5CTQ1NjQJNDU4Mgk0NTk0CTQ2MDkJNDYyMAk0NjMwCTQ2MzgJNDY1NQk0NjY3CTQ2NzYJ
NDY3OAk0NjkyCTQ3MDUJNDcxMQk0NzE2CTQ3MjgJNDc0MAk0NzQ4CTQ3NjcJNDc4MAk0Nzg1
CTQ3OTcJNDgxNwk0ODIwCTQ4NDIJNDg1MAk0ODYwCTQ4NzAJNDg4MQk0ODg1CTQ5MDQJNDkx
OQk0OTI2CTQ5MzkJNDk0NAk0OTQ2CTQ5NjYJNDk3Mgk0OTkyCTQ5OTUuLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNTAwNRtbMG0KG1sx
OzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCA1MDA1LCBsaW1pdCB0byA1MDAwG1sw
bQouCTUwMjMJNTA1Mgk1MDc4CTUxNzMJNTIzNAk1MjYzCTUyODEJNTMzOAk1MzcyCTUzOTgJ
NTQ2Ngk1NTQwCTU1NzMJNTYwMgk1Njk5CTU5MzAgVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1y
b2FtLTM0ODQ1LTIwMTMwNjE2MTIwMDE4LTMuNS4wLXJjMS0wMDAzMi1nMjczNzU5ZS01OQoK
MjczNzU5ZTJjM2JkNjllZmU3NDc5OWM0NDZkZjY5ZDllYTVjYTQxOCBpcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdApjb21taXQgMjczNzU5ZTJjM2JkNjllZmU3NDc5OWM0NDZkZjY5ZDllYTVj
YTQxOApBdXRob3I6IE1hdCBNYXJ0aW5lYXUgPG1hdGhld21AY29kZWF1cm9yYS5vcmc+CkRh
dGU6ICAgVGh1IE1heSAxNyAyMDo1Mzo1MyAyMDEyIC0wNzAwCgogICAgQmx1ZXRvb3RoOiBT
ZXQgdHh3aW4gdmFsdWVzIGZvciBzdHJlYW1pbmcgbW9kZQogICAgCiAgICBUaGUgdHJhbnNt
aXQgd2luZG93IHZhbHVlcyBtdXN0IGJlIGNvbmZpZ3VyZWQgZm9yIHN0cmVhbWluZyBtb2Rl
LCBldmVuCiAgICB0aG91Z2ggc3RyZWFtaW5nIG1vZGUgZG9lcyBub3QgaGF2ZSBhIHdpbmRv
dy4gIFRoaXMgZW5hYmxlcyB1c2Ugb2YKICAgIGV4dGVuZGVkIGhlYWRlcnMgd2hlbiB0aGUg
dHJhbnNtaXQgd2luZG93IHNvY2tldCBvcHRpb24gaXMgc2V0IHRvIDY0CiAgICBvciBsYXJn
ZXIuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IE1hdCBNYXJ0aW5lYXUgPG1hdGhld21AY29k
ZWF1cm9yYS5vcmc+CiAgICBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZvIFBhZG92YW4gPGd1c3Rh
dm8ucGFkb3ZhbkBjb2xsYWJvcmEuY28udWs+Cgo6MDQwMDAwIDA0MDAwMCA4ODM3MDg0MDI3
YjhjNzc3ZjJlOGFiMjFiYWEyZmQwNGRmZjI1NTlhIGZhZGE4MjA2MDJlZDFjZjI5ZDBhZTdh
OTkxMjllNDY3NjRiZWVkM2UgTQluZXQKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgt
ZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjZlYTAwNDg1NzUwODllOWE3MTRl
MDhiYzNkZWJlYzRiMWI5ZDc2NjQ6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE2LTEyOjAyOjU0
IDZlYTAwNDg1NzUwODllOWE3MTRlMDhiYzNkZWJlYzRiMWI5ZDc2NjQgcmV1c2UgL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvNmVhMDA0ODU3NTA4OWU5YTcxNGUwOGJjM2Rl
YmVjNGIxYjlkNzY2NC92bWxpbnV6LTMuNS4wLXJjMS0wMDAzMS1nNmVhMDA0OAobWzE7MzVt
YWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDMwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoK
MjAxMy0wNi0xNi0xMjowMzoxNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQkzNgkxMDUJMjEy
CTI3MgkyOTkuCTMyMgk0ODIJNTQ0CTU2MAk1ODcJNjE2CTc0Mgk4MTYJODQyCTg3Mgk4OTkJ
OTMyCTEwMzcJMTEwNgkxMTQ4CTEzMzUJMTQ3NgkxNTg2CTE3NDgJMTc4NgkxOTk2CTIwODIJ
MjExOQkyMTc5CTI0MTQJMjQ5MgkyNjU3CTI2OTYJMjc4OAkyOTg2CTMwOTQJMzE4MwkzMjkz
CTM0ODQJMzU4NAkzNjA3CTM3NDcJMzkzMwk0MDM1CTQxMDEJNDI0Ngk0NDAxCTQ0NTcgVEVT
VCBGQUlMVVJFCmRtZXNnLWt2bS1iZW5zLTc4OTYtMjAxMzA2MTYxMjI2NDItMy41LjAtcmMx
LTAwMDMxLWc2ZWEwMDQ4LTQ1CgobWzE7MzVtYmFkIGJpc2VjdCwgcmV0cnkgd2l0aCBpbmNy
ZWFzZWQgcmVwZWF0IGNvdW50IDMwMDAwG1swbQpiaXNlY3Q6IHNraXAgMjllYjc3ODI1Y2M3
ZGE4ZDQ1YjY0MmRlMmRlM2Q0MjNkYzhhMzYzZjogbm90IGEgZ29vZCBtZXJnZSBiYXNlCmdp
dCBjaGVja291dCB2My45ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGJlZDEwNTkuLi4g
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZHJtLWludGVsL2RybS1pbnRlbC1uaWdo
dGx5JyBpbnRvIGRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NApIRUFEIGlzIG5vdyBhdCBj
MWJlNWE1Li4uIExpbnV4IDMuOQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIw
MTMwNjA2MjE1NDpjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxOmJp
c2VjdC1zb3VuZAogVEVTVCBGQUlMVVJFCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvZG1lc2cta3Zt
LXZwLTI5MTgxLTIwMTMwNjEwMDEzMjE3LTMuOS4wLTI2CgpiaXNlY3Q6IGJhZCBjb21taXQg
djMuOQpnaXQgY2hlY2tvdXQgdjMuOApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjMWJl
NWE1Li4uIExpbnV4IDMuOQpIRUFEIGlzIG5vdyBhdCAxOWY5NDlmLi4uIExpbnV4IDMuOAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDoxOWY5NDlmNTI1
OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwOmJpc2VjdC1zb3VuZAogVEVTVCBGQUlM
VVJFCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1LzE5Zjk0OWY1MjU5OWJhN2Mz
ZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvZG1lc2cta3ZtLWlubi0zNzczOC0yMDEzMDYxMDA1
MzIzNS0zLjguMC00MQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjgKZ2l0IGNoZWNrb3V0IHYz
LjcKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTlmOTQ5Zi4uLiBMaW51eCAzLjgKSEVB
RCBpcyBub3cgYXQgMjk1OTQ0MC4uLiBMaW51eCAzLjcKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZl
bC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6Mjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2Rj
YzUzOTcwYzYwZTpiaXNlY3Qtc291bmQKIFRFU1QgRkFJTFVSRQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zMDQtMDYwNS8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBj
NjBlL2RtZXNnLWt2bS1rYnVpbGQtNTA4NzEtMjAxMzA2MTAwNzMzNDItMy43LjAtMzQKCmJp
c2VjdDogYmFkIGNvbW1pdCB2My43CmdpdCBjaGVja291dCB2My42ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDI5NTk0NDAuLi4gTGludXggMy43CkhFQUQgaXMgbm93IGF0IGEwZDI3
MWMuLi4gTGludXggMy42CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2
MDYyMTU0OmEwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4Zjk6YmlzZWN0
LXNvdW5kCiBURVNUIEZBSUxVUkUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUv
YTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOS9kbWVzZy1rdm0tdnAt
Mjg1OTYtMjAxMzA2MTAwNzUyNDgtMy42LjAtMzUKCmJpc2VjdDogYmFkIGNvbW1pdCB2My42
CmdpdCBjaGVja291dCB2My41ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGEwZDI3MWMu
Li4gTGludXggMy42CkhFQUQgaXMgbm93IGF0IDI4YTMzY2IuLi4gTGludXggMy41CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUv
bGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjI4YTMzY2JjMjRlNDI1
NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTI6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE2LTEy
OjI5OjI4IDI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0MjMyMjlmOTIgcmV1c2Ug
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvMjhhMzNjYmMyNGU0MjU2YzE0M2Rj
ZTk2YzdkOTNiZjQyMzIyOWY5Mi92bWxpbnV6LTMuNS4wChtbMTszNW1hZGRfdG9fcnVuX3F1
ZXVlOiByZXF1ZXN0ZWQgMzAwMDAsIGxpbWl0IHRvIDUwMDAbWzBtCgoyMDEzLTA2LTE2LTEy
OjI5OjM3IGRldGVjdGluZyBib290IHN0YXRlIC4JNgk0MAkxNzkgVEVTVCBGQUlMVVJFCmRt
ZXNnLWt2bS1rYnVpbGQtMzIxODEtMjAxMzA2MTYxMjI3MDgtMy41LjAtMzYKCmJpc2VjdDog
YmFkIGNvbW1pdCB2My41CmdpdCBjaGVja291dCB2My40ClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIDI4YTMzY2IuLi4gTGludXggMy41CkhFQUQgaXMgbm93IGF0IDc2ZTEwZDEuLi4g
TGludXggMy40CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0
Ojc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1NTAxOTAwYmM6YmlzZWN0LXNvdW5k
CgoyMDEzLTA2LTE2LTEyOjMxOjQzIDc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1
NTAxOTAwYmMgY29tcGlsaW5nCjI3OCByZWFsICAxMzEyIHVzZXIgIDkwIHN5cyAgNTAzLjg5
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1
ZTogcmVxdWVzdGVkIDMwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xNi0xMjoz
Njo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjQuMC4JMTAJNTIJMTA1CTE3OQkyMzkJMjgx
CTM0MAkzNzkJNDQyCTUwMQk1NTQJNjAwCTYyMQk2OTMJNzI0CTc2NQk4MDEJODUyCTg3MAk4
OTUJOTI3CTk4NAkxMDE4CTEwNDQJMTA2NAkxMDk3CTExMjAJMTE0MgkxMTU2CTExNzYJMTE3
OQkxMTkxCTEyMDcJMTIwOAkxMjEzCTEyMzIJMTI0OAkxMjU2CTEyNjUJMTI4MAkxMjkzCTEz
MTcJMTM0MwkxMzU2CTEzNjYJMTM3OAkxMzg2CTE0MDgJMTQxNQkxNDI2CTE0NDEJMTQ0Ngkx
NDY2CTE0NzYJMTQ5NAkxNTAyCTE1MTIJMTUyMAkxNTM3CTE1NTEJMTU2MgkxNTY4CTE1NzkJ
MTU4OQkxNjA2CTE2MjEJMTYzNgkxNjQ0CTE2NjIJMTY4NAkxNzAxCTE3MTAJMTcyMgkxNzMw
CTE3NDEJMTc0OAkxNzU4CTE3NzAJMTc4MAkxNzkxCTE4MDMJMTgxOAkxODI4CTE4NDAJMTg1
MQkxODY0CTE4NzAJMTg4NwkxODk4CTE5MDkJMTkyMgkxOTMzCTE5NDIJMTk1MQkxOTY2CTE5
NzgJMTk5MwkyMDAzCTIwMTcJMjAyNAkyMDI1CTIwMjgJMjAzMQkyMDM1CTIwMzYJMjAzNwky
MDM4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTIwMzkuLi4uLgkyMDQwCTIwNDIJMjA0NQkyMDQ5CTIwNTEJMjA1
NQkyMDU4Li4uCTIwNjAJMjA2MQkyMDYzCTIwNjgJMjA3MgkyMDc2CTIwNzgJMjA4MAkyMDgx
CTIwODQJMjA4NQkyMDg5CTIwOTMJMjEwMAkyMTAzCTIxMDkJMjExMgkyMTE1CTIxMTYJMjEy
MAkyMTIxCTIxMjIJMjEyNAkyMTI2CTIxMjcuLi4JMjEyOAkyMTM0CTIxMzUJMjE0MAkyMTQx
CTIxNDMJMjE0NwkyMTUxLgkyMTUzLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIxNTQJMjE1NQkyMTU2
LgkyMTU3CTIxNTgJMjE2MAkyMTYxCTIxNjQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LgkyMTY4CTIxNjkJMjE3MQkyMTc0CTIxNzUJMjE3NgkyMTc3Li4uCTIxNzgJMjE3OQkyMTgy
CTIxODYJMjE5MwkyMTk0CTIxOTcJMjIwMAkyMjAzCTIyMDUJMjIxMAkyMjEzCTIyMjEJMjIz
MQkyMjMzCTIyMzYJMjI0MgkyMjQ4CTIyNTEJMjI1NQkyMjU5CTIyNjMJMjI2NgkyMjcxCTIy
NzgJMjI3OQkyMjgzCTIyODkJMjI5NwkyMzAzCTIzMTAJMjMxNAkyMzE3CTIzMjIJMjMyNgky
MzI4CTIzMzIJMjMzNAkyMzM2CTIzMzcJMjMzOC4uCTIzNDIJMjM0NgkyMzUxCTIzNTQJMjM1
NwkyMzU4CTIzNjAJMjM2MQkyMzY1LgkyMzcwLgkyMzcyLgkyMzczLgkyMzc0LgkyMzc2Lgky
Mzc5CTIzODEuLgkyMzg0CTIzODcuCTIzOTEJMjM5NAkyMzk1CTIzOTcJMjM5OAkyNDAwCTI0
MDEJMjQwNgkyNDA3CTI0MTEJMjQxMi4JMjQxNC4JMjQxNQkyNDE2CTI0MTcJMjQxOAkyNDE5
CTI0MjAuLgkyNDIxCTI0MjIJMjQyNAkyNDI1CTI0MjgJMjQyOS4JMjQzMC4uLgkyNDMyCTI0
MzMJMjQzNAkyNDM1CTI0MzcJMjQzOC4uLi4JMjQ0MS4JMjQ0My4uLi4JMjQ0NC4JMjQ0Nwky
NDQ4CTI0NDkJMjQ1MC4uCTI0NTEJMjQ1Mi4uLgkyNDU0CTI0NTUuCTI0NTYuCTI0NTcuLi4u
Li4uCTI0NjAJMjQ2MS4JMjQ2Mi4uLi4JMjQ2MwkyNDY0Li4JMjQ2Ni4JMjQ2Ny4uLgkyNDY4
CTI0NjkuCTI0NzUJMjQ3OQkyNDgwCTI0ODQuCTI0ODUuCTI0ODguCTI0OTAJMjQ5MQkyNDk0
LgkyNDk3CTI0OTkJMjUwMgkyNTA1CTI1MTEJMjUxNwkyNTIwCTI1MjQJMjUyNgkyNTI3Li4J
MjUzMAkyNTM3CTI1NDAJMjU0OAkyNTUyCTI1NTcJMjU1OQkyNTYwCTI1NjkJMjU3Mi4JMjU3
NAkyNTc3CTI1ODAJMjU4NQkyNTg2CTI1OTIJMjU5NgkyNjAwCTI2MDgJMjYwOQkyNjE2CTI2
MTkJMjYyMgkyNjI0CTI2MzAJMjYzMgkyNjM0CTI2MzkJMjY0NgkyNjUwCTI2NTQJMjY1OQky
NjY3CTI2NzAJMjY3NQkyNjc4CTI2ODAJMjY4MwkyNjg1CTI2OTEJMjY5NQkyNjk3CTI3MDQJ
MjcwNgkyNzExCTI3MTYJMjcyMgkyNzIzCTI3MjUJMjczMAkyNzM1CTI3NDIJMjc0NAkyNzQ3
CTI3NDkJMjc1MgkyNzU5CTI3NjAJMjc2NgkyNzczCTI3ODAJMjc4MwkyNzg3CTI3OTAJMjc5
NQkyNzk4CTI4MDAJMjgwMgkyODA1CTI4MTEJMjgxNgkyODE5CTI4MjIJMjgyOAkyODMyCTI4
MzYJMjgzOQkyODQyCTI4NDUJMjg0NgkyODU2CTI4NTcJMjg2MwkyODY2CTI4NjgJMjg3NQky
ODg1CTI4ODYJMjg4OS4JMjg5MAkyODkyCTI4OTUJMjg5NwkyODk4CTI5MDQJMjkwNgkyOTEx
CTI5MTUJMjkyMQkyOTIzCTI5MjYJMjkyOAkyOTM4CTI5NDYJMjk1NAkyOTU3CTI5NjMJMjk2
OQkyOTc0CTI5ODAJMjk4NAkyOTkyCTI5OTcJMzAwMgkzMDEzCTMwMTYJMzAyNQkzMDM3CTMw
NDIJMzA1NQkzMDYyCTMwNjgJMzA3NgkzMDg3CTMwOTMJMzA5NQkzMTAwCTMxMTEJMzExOAkz
MTI0CTMxMzEJMzE0MgkzMTQ1CTMxNTUJMzE2NAkzMTY3CTMxNzQgVEVTVCBGQUlMVVJFCmRt
ZXNnLWt2bS1rYnVpbGQtNjM3OTMtMjAxMzA2MTYyMDUzMjgtMy40LjAtNjMKCmJpc2VjdDog
YmFkIGNvbW1pdCB2My40CmdpdCBjaGVja291dCB2My4zClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIDc2ZTEwZDEuLi4gTGludXggMy40CkhFQUQgaXMgbm93IGF0IGMxNmZhNGYuLi4g
TGludXggMy4zCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0
OmMxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTc6YmlzZWN0LXNvdW5k
CgoyMDEzLTA2LTE2LTIwOjU4OjQzIGMxNmZhNGYyYWQxOTkwOGE0N2M2M2Q4ZmE0MzZhMTE3
ODQzOGM3ZTcgY29tcGlsaW5nCjE3NyByZWFsICAxMjUwIHVzZXIgIDkwIHN5cyAgNzU2LjU3
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1
ZTogcmVxdWVzdGVkIDMwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xNi0yMTow
MjowMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjMuMC4JMQk5CTE5CTMwCTM2CTM5CTQ4CTU2
CTYzCTY4CTgxCTkzCTk5CTEwOQkxMTUJMTIwCTEyOQkxMzcJMTQ0CTE1MAkxNTgJMTY1CTE3
MgkxODIJMTkwCTE5OQkyMDkJMjE0CTIyMQkyMjkJMjM3CTI0NQkyNTMJMjU4CTI2NAkyNzMJ
MjgwCTI4OQkyOTYJMzA2CTMxOAkzMjYJMzM3CTM1MQkzNzYJMzkxCTQxNwk0MzkJNDU1CTQ3
NQk0ODkJNTExCTUyNQk1NDEJNTY2CTU3NQk1OTEJNjA0CTYyMwk2MzQJNjQ0CTY2Nwk2ODUJ
NzA4CTczNQk3NTMJNzcwCTc4OQk4MDUJODEzCTgyOQk4NDgJODU1CTg2OAk4ODIJODkxCTg5
OQk5MTcJOTI1CTk0MQk5NTkJOTY2CTk4Nwk5OTEJMTAwMwkxMDI1CTEwNDUJMTA2OAkxMDc1
CTEwOTUJMTEyMQkxMTM0CTExNTQJMTE4MQkxMTkxCTExOTgJMTIyNAkxMjQ5CTEyNjIJMTI3
MwkxMzA4CTEzMzIJMTM0NQkxMzU0CTEzODEJMTM5NwkxNDA2CTE0MjYJMTQ0NgkxNDU3CTE0
NzgJMTQ5NwkxNTA0CTE1MTgJMTUyNQkxNTUwCTE1NjcJMTU4MwkxNjAyCTE2MjAJMTYzNAkx
NjUwCTE2NzAJMTY4OAkxNzA5CTE3MjQJMTczOQkxNzU3CTE3NjcJMTc5MAkxNzk4CTE4MTQJ
MTgyNQkxODQyCTE4NjAJMTg4MAkxODkzCTE5MDMJMTkyMwkxOTM3CTE5NTYJMTk2NwkxOTg1
CTIwMTMJMjAzNwkyMDUwCTIwNTgJMjA3NAkyMTA2CTIxMjIJMjE0NAkyMTcyCTIxODUJMjE5
MAkyMjA3CTIyMjYJMjIzNQkyMjUyCTIyNTcJMjI4NAkyMjk5CTIzMDcJMjMyNgkyMzUyCTIz
NzUJMjM5MQkyNDEzCTI0MjcJMjQ0OAkyNDY2CTI0ODQJMjUwNwkyNTE4CTI1MzAJMjU0Ngky
NTU1CTI1NjgJMjU3OAkyNjA1CTI2MjcJMjY0MgkyNjYyCTI2ODAJMjY5NQkyNzE3CTI3MzYJ
Mjc1MAkyNzY0CTI3NzkJMjc5OAkyODI0CTI4NDkJMjg4MgkyOTA1CTI5MzMJMjk1MgkyOTk0
CTMwMTEJMzA0NgkzMDc3CTMxMDYJMzE0NQkzMTg0CTMxOTkJMzIyMwkzMjU0CTMzMDMJMzMy
MAkzMzQ2CTMzNzQJMzM5OQkzNDI1CTM0NTMJMzQ4OQkzNTIwCTM1MzMJMzU3NwkzNTk3CTM2
MzcJMzY3MAkzNjk5CTM3MjYJMzc1MAkzNzc3CTM4MDYJMzgxMAkzODU3CTM5MDMJMzk1MQkz
OTk4CTQwMjkJNDA1NQk0MTAyCTQxNDUJNDE3OAk0MjI5CTQyNTEJNDI5Mwk0MzI4CTQzODAJ
NDQ0Nwk0NTAwCTQ1NTIJNDYzMgk0NjkwCTQ3MzkJNDgxNQk0ODg4CTQ5MzAJNDk1NC4JNDk2
MQk0OTY5CTQ5ODAJNDk4NS4JNDk4Ni4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4b
WzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAyNTAxNBtbMG0KG1sxOzM1bWFkZF90b19ydW5fcXVl
dWU6IHJlcXVlc3RlZCAyNTAxNCwgbGltaXQgdG8gNTAwMBtbMG0KLi4JNTAxMAk1MDQ0CTUw
OTUJNTEzMQk1MjQ2CTUyNjIJNTQ2Mwk1NTczCTU2MDAJNTYyMwk1NzQ2CTU4MjkJNTkyMAk1
OTkwCTYwNjIJNjIwNwk2MzI4CTY0MjgJNjQ5Mgk2NTMyCTY1OTYJNjczMAk2ODYxCTY5NDUJ
Njk2MAk3MTAzCTcxMzkJNzE1Ngk3MTc5CTcyMzYJNzMxMQk3MzcyCTc0MTIJNzQ0OAk3NTEz
CTc1NTMJNzc1Ngk3NzgyCTc4NjcJNzg5NAk3OTMwCTc5ODgJODA0MAk4MTAxCTgxNDcJODIw
MAk4MjUxCTgzMTUJODM2Ngk4MzkxCTg0NjgJODU1Mwk4NTk0CTg2NTAJODcxMwk4ODAzCTg4
MzkJODg5MAk4OTM5CTg5NjYJOTAxMAk5MDg0CTkxNjIJOTIyNwk5Mjg4CTkzMjIJOTQwMgk5
NTE0CTk2MTkJOTY4OAk5NzY4CTk4MzIJOTg3OQk5ODgzCTk5NTQJOTk4Mgk5OTgzCTk5ODQJ
OTk4NS4uLi4uLi4uLi4uLi4uLgk5OTg2Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDIwMDE0G1swbQobWzE7MzVtYWRkX3RvX3J1bl9x
dWV1ZTogcmVxdWVzdGVkIDIwMDE0LCBsaW1pdCB0byA1MDAwG1swbQouCTk5ODkJMTAwMDAJ
MTAwMjAJMTAwODQJMTAwOTUJMTAxMTQJMTAxMzIJMTAxODYJMTAyMTEJMTAyMTYJMTAyMjUJ
MTAyNDYJMTAyOTUJMTAzMTkJMTAzMzUJMTAzMzkJMTAzNDcJMTAzNTAJMTA0MTcJMTA0NTUJ
MTA0NTYJMTA0NzUJMTA0NzcJMTA1MjQJMTA1NTYuCTEwNTcwCTEwNjE1CTEwNjc1CTEwNjg0
CTEwNjk0CTEwNzE3CTEwNzg4CTEwODE2CTEwODMzCTEwODYyCTEwOTA0CTEwOTQ5CTEwOTcx
CTEwOTg2CTEwOTk1CTExMDMxCTExMDg4CTExMTAwCTExMTE1CTExMTMyCTExMTUzCTExMTg0
CTExMjE0CTExMjI3CTExMjQ5CTExMjY0CTExMzA2CTExMzQ5CTExMzYyCTExMzcwCTExNDA5
CTExNDM3CTExNDYwCTExNDcyCTExNDg3CTExNTUwCTExNTgxCTExNTk2CTExNjE3CTExNjQ3
CTExNjc2CTExNjc5CTExNjk5CTExNzE5CTExNzQwCTExNzQ4CTExNzc1CTExNzk1CTExODEw
CTExODMwCTExODU5CTExODg2CTExOTExCTExOTM3CTExOTcyCTEyMDAzCTEyMDMxCTEyMDY2
CTEyMDg2CTEyMTE4CTEyMTQ4CTEyMTg3CTEyMjI0CTEyMjQ0CTEyMjg4CTEyMzI4CTEyMzYz
CTEyMzkwCTEyNDIyCTEyNDQ5CTEyNDc4CTEyNTA3CTEyNTM0CTEyNTYxCTEyNTk1CTEyNjI5
CTEyNjYxCTEyNjg5CTEyNzIzCTEyNzQ0CTEyNzc2CTEyODAyCTEyODQxCTEyODg1CTEyOTA3
CTEyOTQ0CTEyOTY3CTEyOTk4CTEzMDI4CTEzMDU5CTEzMTAxCTEzMTMyCTEzMTYzCTEzMTk3
CTEzMjQwCTEzMjY3CTEzMjkyCTEzMzMxCTEzMzU5CTEzMzkwCTEzNDIzCTEzNDY4CTEzNTA1
CTEzNTQ1CTEzNTc0CTEzNjE3CTEzNjQ5CTEzNjkxCTEzNzE1CTEzNzUxCTEzNzg2CTEzODM0
CTEzODgyCTEzOTA4CTEzOTQzCTEzOTc3CTE0MDI0CTE0MDU3CTE0MDg3CTE0MTI3CTE0MTY2
CTE0MTg3CTE0MjIyCTE0MjQ3CTE0Mjg2CTE0MzE3CTE0MzUxCTE0MzgwCTE0NDIxCTE0NDM5
CTE0NDY4CTE0NTA0CTE0NTI5CTE0NTU3CTE0NTk5CTE0NjU3CTE0Njg0CTE0NzI3CTE0NzY2
CTE0Nzk3CTE0ODMzCTE0ODg2CTE0OTE3CTE0OTU1CTE0OTc5CTE0OTgyLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgkxNDk4MwkxNDk4NAkxNDk5MwkxNDk5NS4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxNDk5Ni4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAx
NTAwNBtbMG0KG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAxNTAwNCwgbGlt
aXQgdG8gNTAwMBtbMG0KCTE1MDExCTE1MDUxCTE1MTIzCTE1MzE3CTE1NTgwCTE1NzIzCTE1
OTAzCTE2MDM0CTE2MTI2CTE2MjQyCTE2Mjg3CTE2MzEwCTE2MzIxCTE2MzU0CTE2NDA1Li4J
MTY0MDYJMTY0MTEJMTY0MTYJMTY0MjkJMTY0NDEJMTY0NzcJMTY1MDEJMTY1MTIJMTY1MTgJ
MTY1MjEJMTY1MjMJMTY1MzMJMTY1NjQJMTY1OTUJMTY1OTYJMTY2MTgJMTY2MjgJMTY2NDYJ
MTY2NTUJMTY2NjUJMTY2NzgJMTY2ODcJMTY2OTUJMTY3MzAJMTY3NTUJMTY3NzIJMTY3ODUJ
MTY4MDIJMTY4MTkJMTY4MzkJMTY4NDgJMTY4NTkJMTY4NzcJMTY4ODMJMTY4OTMJMTY5MTgJ
MTY5NTkJMTY5NzEJMTY5ODcJMTY5OTkJMTcwMDcJMTcwMTgJMTcwNDMJMTcwNjkJMTcwODAJ
MTcwODgJMTcwOTIJMTcxMDUJMTcxNDAJMTcxNjcJMTcxOTkJMTcyMDUJMTcyMTEJMTcyMTkJ
MTcyMzAJMTcyMzkJMTcyNTEJMTcyNTkJMTcyNjMJMTcyOTIJMTczMjIJMTczNjIJMTczODUJ
MTc0MjAJMTc0NDMJMTc0NzgJMTc1MDQJMTc1MjAJMTc1MzIJMTc1NTIJMTc1NzEJMTc2MDAJ
MTc2MTIJMTc2NDcJMTc2NTIJMTc2ODcJMTc3MDUJMTc3MzAJMTc3NDYJMTc3NjQJMTc3ODkJ
MTc4MTMJMTc4MjYJMTc4NDcJMTc4NTYJMTc4OTEJMTc5MDMJMTc5MzcJMTc5NzgJMTc5ODkJ
MTgwMDQJMTgwMjUJMTgwNTcJMTgwNzcJMTgxMTMJMTgxNDQJMTgxNjIJMTgyMDQJMTgyMjEJ
MTgyMzcJMTgyNTUJMTgyNzQJMTgyOTAJMTgzMDMJMTgzMjIJMTgzNDAJMTgzNjcJMTgzODUJ
MTg0MDIJMTg0MjMJMTg0NTgJMTg0NzUJMTg0OTgJMTg1MTkJMTg1NDgJMTg1OTIJMTg2MDkJ
MTg2MjEJMTg2NDYJMTg2NjYJMTg2OTAJMTg3MDEJMTg3MjgJMTg3NDUJMTg3NTYJMTg3NzAJ
MTg3OTQJMTg4MTEJMTg4MjYJMTg4NDIJMTg4NjEJMTg4ODAJMTg5MTIJMTg5MjcJMTg5NTAJ
MTg5ODYJMTkwMTEJMTkwMjcJMTkwNDQJMTkwNTMJMTkwNjkJMTkwODYJMTkxMDcJMTkxMTkJ
MTkxNDEJMTkxNjQJMTkxODIJMTkyMTAJMTkyNDYJMTkyNjAJMTkyNzQJMTkyODYJMTkzMDEJ
MTkzMTkJMTkzMzgJMTkzNTcJMTkzODkJMTk0MDIJMTk0MTMJMTk0MTgJMTk0NDYJMTk0NjMJ
MTk0NzEJMTk1MDIJMTk1MjgJMTk1NDgJMTk1ODMJMTk2MTUJMTk2MzQJMTk2NTAJMTk2NjYJ
MTk2ODAJMTk2OTgJMTk3MDQJMTk3MDUJMTk3MDcuLi4uLi4uLi4uLi4uLi4JMTk3MDkuLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMTAy
OTEbWzBtChtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlOiByZXF1ZXN0ZWQgMTAyOTEsIGxpbWl0
IHRvIDUwMDAbWzBtCi4JMTk3MjQJMTk3OTUJMTk4NzkJMjAwOTEJMjAxNjkJMjAyNjMJMjAz
NzkJMjA0NDAJMjA1NjgJMjA3MzQJMjA3ODYJMjA4NDkJMjA5NjUJMjExMDcJMjExOTEJMjEy
NTYJMjEzMjQJMjEzOTYJMjE1NTYJMjE2OTkJMjE3MTQgVEVTVCBGQUlMVVJFCmRtZXNnLWt2
bS1sa3Atc2J4MDQtNDQyOTMtMjAxMzA2MTcyMDAzMDYtMy4zLjAtNjQKCmJpc2VjdDogYmFk
IGNvbW1pdCB2My4zCmdpdCBjaGVja291dCB2My4yClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIGMxNmZhNGYuLi4gTGludXggMy4zCkhFQUQgaXMgbm93IGF0IDgwNWE2YWYuLi4gTGlu
dXggMy4yCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0Ojgw
NWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTA6YmlzZWN0LXNvdW5kCgoy
MDEzLTA2LTE3LTE1OjU5OjI5IDgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAw
YjI2MTAgY29tcGlsaW5nCjI0NiByZWFsICAxMTg4IHVzZXIgIDg2IHN5cyAgNTE4LjAyJSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTog
cmVxdWVzdGVkIDMwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xNy0xNjowMzo1
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjIuMC4JMjIJNDgJMTE0CTI2OQkzMzYJNDQ1CTQ5
Mgk1ODYJNjk0CTc5MQk4MjAJOTU1CTk5NwkxMDY1CTExNzAJMTI0MAkxMzYyCTE0NTIJMTU2
NgkxNjQwCTE3MzgJMTgzNAkxODg3CTIwMjYJMjA1NwkyMDcxCTIyNjAJMjI5MQkyMzQwCTI0
NjUJMjQ5NgkyNTkxIFRFU1QgRkFJTFVSRQpkbWVzZy1rdm0tbGtwLXNieDA0LTI5MDk3LTIw
MTMwNjE3MjAyMzU0LTMuMi4wLTY1CgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMgpnaXQgY2hl
Y2tvdXQgdjMuMQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4MDVhNmFmLi4uIExpbnV4
IDMuMgpIRUFEIGlzIG5vdyBhdCBjM2I5MmM4Li4uIExpbnV4IDMuMQpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRl
dmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDpjM2I5MmM4Nzg3MzY3YThiYjUzZDU3
ZDk3ODliNTU4ZjEyOTVjYzk2OmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xNy0xNjoyMDozNiBj
M2I5MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEyOTVjYzk2IGNvbXBpbGluZwoxNjcg
cmVhbCAgMTE0NSB1c2VyICA3OCBzeXMgIDcyOS44MSUgY3B1IAlpMzg2LXJhbmRjb25maWct
czA0LTA2MDUKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVlc3RlZCAzMDAwMCwgbGlt
aXQgdG8gNTAwMBtbMG0KCjIwMTMtMDYtMTctMTY6MjM6NDIgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xLjAuLgkyNwk0MAkyOTgJMzUxCTM3OQk0NjgJNTA5CTYyNwk2ODYJNzExCTczNgk5
MjYJOTU3CTk4OQkxMDEzCTEwMjkJMTAzOAkxMDM5CTEwNDUJMTA1MAkxMDY1CTEwNzUJMTA5
OQkxMTEyCTExMzAJMTE1MAkxMTYwCTExNjEJMTE3MAkxMTc4CTExNzkJMTE4MAkxMTkxCTEy
MDIJMTIxNQkxMjI5CTEyMzMJMTI0NAkxMjU0CTEyNjEJMTI2NQkxMjgyCTEzMDQJMTMzMwkx
MzgyCTE0MTcJMTQ1NgkxNDk4CTE1NDYJMTU5MwkxNjQ5CTE2OTkJMTcyOQkxODAzCTE4NDkJ
MTkwNgkxOTQ4CTIwMDgJMjA1MQkyMTAyCTIxMzEJMjE2NAkyMjE4CTIyNDcJMjMxNwkyMzcy
CTI0MzIJMjQ2OQkyNTI5CTI1NzgJMjYyNAkyNjcwCTI3MTYJMjc3MAkyODI5CTI4NzAJMjkx
OAkyOTUyCTI5OTUJMzAzMQkzMDgwCTMxMjEJMzE2OQkzMjIyCTMyODEJMzM0MQkzMzkxCTM0
MzYJMzQ3MQkzNTI3CTM2MDUJMzY2NgkzNzA0CTM3NzEJMzgxNQkzODYyCTM5MDEJMzk0MAkz
OTg4CTQwMjcJNDA2OQk0MDk5CTQxMjcJNDE4Mwk0MjMyCTQzMDMJNDM0Mgk0NDA3CTQ0ODAJ
NDUzNgk0NTY5CTQ2MjgJNDY3OAk0NzE2CTQ3NTcJNDc3OQk0ODEyCTQ4MzgJNDg0NC4JNDg0
NQk0ODQ2CTQ4NDguLi4JNDg0OS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7
MzVtYWRkX3RvX3J1bl9xdWV1ZSAyNTE1MRtbMG0KG1sxOzM1bWFkZF90b19ydW5fcXVldWU6
IHJlcXVlc3RlZCAyNTE1MSwgbGltaXQgdG8gNTAwMBtbMG0KLi4JNDg2MQk0OTMxCTQ5OTUJ
NTAzNQk1MDcyCTUxMDYJNTE0Ngk1MTk2CTUyMzMJNTI4MAk1MzI5CTUzOTEJNTQyOQk1NDk1
CTU1MzQJNTU2Nwk1NjMwCTU2NDYJNTcyOQk1NzU1CTU4MDkJNTg1Nwk1OTE1CTU5NDUJNTk4
Nwk2MDQ3CTYxMDMJNjEyMAk2MTk1CTYyNTQJNjI5Mgk2MzIxIFRFU1QgRkFJTFVSRQpkbWVz
Zy1rdm0td2FpbWVhLTQ2NjctMjAxMzA2MTcyMDE4MTYtMy4xLjAtNjYKCmJpc2VjdDogYmFk
IGNvbW1pdCB2My4xCmdpdCBjaGVja291dCB2My4wClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIGMzYjkyYzguLi4gTGludXggMy4xCkhFQUQgaXMgbm93IGF0IDAyZjhjNmEuLi4gTGlu
dXggMy4wCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjAy
ZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYwMzVkYmU6YmlzZWN0LXNvdW5kCgoy
MDEzLTA2LTE3LTIwOjE2OjA1IDAyZjhjNmFlZThkZjNjZGM5MzVlOWJkZDRmMmQwMjAzMDYw
MzVkYmUgY29tcGlsaW5nCjE4OSByZWFsICAxMTA1IHVzZXIgIDc0IHN5cyAgNjIyLjQwJSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTog
cmVxdWVzdGVkIDMwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0wNi0xNy0yMDoxOTo0
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjAuMC4uCTI4CTQyCTExNgkxMjcJMTcwCTIyOQky
OTYJMzE0CTM0OQkzOTIJNDE2CTQ2NAk0OTgJNTE2CTU2Nwk2MDYJNjQ4CTY3Nwk3MDQJNzQ4
CTgwNQk4MjkJODgwCTkxMAk5MzkJOTgyCTEwMjIJMTA2MQkxMTExCTExMzkJMTE3NwkxMjIx
CTEyNTMJMTMwMQkxMzE0CTEzNjMJMTM5OQkxNDI2CTE0NjQJMTUxNQkxNTMxCTE1NzcJMTYx
OQkxNjQ0CTE2ODMJMTcwNgkxNzY4CTE3OTkJMTg1OQkxOTM0CTE5NzEJMjA2MgkyMTAwCTIx
NzkJMjI0NQkyMjk1CTIzNDUJMjM0NwkyNDc0CTI1MzAJMjYwNAkyNjY1CTI3MjIJMjc3NAky
ODM3CTI4ODAJMjkxNgkyOTg1CTMwMjIJMzA1NwkzMTExCTMxNTAJMzIzNwkzMjY2CTMzMTIJ
MzQxNgkzNTQ5CTM2MTkJMzcyMgkzNzY4CTM3OTUJMzgyNQkzODcwCTM4OTgJMzkyNAkzOTc0
CTQwNTAJNDExNgk0MTc0CTQyNjUJNDMxMAk0NDA1CTQ0NjEJNDUyMAk0NjMwCTQ2NzMJNDc2
OQk0ODM4CTQ4ODgJNDkwMwk0OTA5CTQ5MTEJNDkxMi4uLi4uLi4JNDkxMy4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Lgk0OTE2Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVu
X3F1ZXVlIDI1MDg0G1swbQobWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDI1
MDg0LCBsaW1pdCB0byA1MDAwG1swbQoJNDkyOAk0OTY3CTUwMzkJNTA4Mwk1MTQ4CTUxODYJ
NTIyMAk1MzA2CTUzNTIJNTQxMgk1NDM4CTU0NDcJNTQ1MQk1NTk4CTU2MTkJNTYzOQk1Njc0
CTU3MTUJNTc3NQk1ODE3CTU4NzgJNTg4OQk1OTUzCTU5OTAJNjAxMAk2MTAxCTYxMjMJNjE2
MQk2MjQ1CTYyODkJNjMwMAk2MzI3CTYzOTUJNjQ0Mwk2NDUxCTY1MTgJNjU2OQk2NjMyCTY2
OTcJNjcwMwk2NzMyCTY3NDcJNjgzOAk2ODcyCTY4OTAJNjkxNAk2OTUwCTY5OTMJNzA3OAk3
MTEwCTcxNTEJNzE5NQk3MjM0CTczMDAJNzM0OAk3Mzk3CTc0ODcJNzUxMwk3NTI3CTc1NjUJ
NzY1OQk3Njk4CTc3NzcJNzgwNQk3ODM0CTc4OTAJNzk3NQk3OTkzCTgwMzQJODE0Ngk4Mjg5
CTgzNDYJODQ2OQk4NTAwCTg1NjgJODcxOQk4ODQyCTg4NjMJOTAyMAk5MTE2CTkyMDQJOTI1
OQk5MzAwCTkzMzkJOTM4Ngk5NDcwCTk1ODEJOTY1OAk5NzYzCTk3NzUJOTc4NQk5Nzk2Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JOTc5Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAyMDIwMxtbMG0KG1sxOzM1bWFkZF90b19ydW5f
cXVldWU6IHJlcXVlc3RlZCAyMDIwMywgbGltaXQgdG8gNTAwMBtbMG0KLi4uLi4uCTk3OTgJ
OTgxOQk5ODUzCTk4NjQJOTg3OS4JOTg4MAk5ODgxCTk4OTEJOTg5Mwk5ODk0Li4JOTkwMAk5
OTA5CTk5MTMJOTkyNQk5OTI5CTk5MzIJOTkzNQk5OTQwCTk5NDEJOTk3NwkxMDAwMQkxMDAy
MQkxMDAzMwkxMDAzNwkxMDA0NgkxMDA0OQkxMDA1NAkxMDA2MgkxMDA2NQkxMDA2OAkxMDA3
MQkxMDA3NAkxMDA5MQkxMDE0NQkxMDE1OAkxMDE5MwkxMDIxNgkxMDIyMi4JMTAyMjMJMTAy
NDAJMTAyNDUJMTAyNTAJMTAyNjEJMTAyNjIJMTAyNjMJMTAyNjUJMTAyOTIJMTAzMjkJMTAz
NjEJMTAzNjgJMTAzODYJMTA0MDAJMTA0MTYJMTA0MzcJMTA0NDYJMTA0NDgJMTA0NTQuLgkx
MDQ3OQkxMDUwNwkxMDUyOQkxMDUzNy4JMTA1NDEJMTA1NDQJMTA1OTAJMTA2MTgJMTA2NDMJ
MTA2NDQuLgkxMDY2MAkxMDY4MgkxMDY5NwkxMDY5OC4JMTA3MDcJMTA3MTgJMTA3MjgJMTA3
NDQJMTA3NjMJMTA3NjUJMTA3NjcJMTA3OTAJMTA4MDgJMTA4MjgJMTA4NDQJMTA4NjIJMTA4
ODcJMTA4OTEuCTEwODkyCTEwODk5CTEwOTExCTEwOTQ2CTEwOTQ3CTEwOTU5CTEwOTY2CTEw
OTc5CTEwOTk3CTExMDEyCTExMDIxCTExMDM2CTExMDQzCTExMDU4CTExMDU5CTExMDY5CTEx
MDc4CTExMTIzCTExMTMwCTExMTM0CTExMTM1CTExMTM2CTExMTQyCTExMTY4CTExMjA5CTEx
MjIwCTExMjI1CTExMjM2LgkxMTI1OAkxMTI4NQkxMTI5MgkxMTI5NwkxMTMwMwkxMTMwOAkx
MTMxMQkxMTMyMgkxMTMzNwkxMTM1NwkxMTM2MgkxMTM2NQkxMTM3MQkxMTM3NwkxMTM4NAkx
MTM4OAkxMTM5MgkxMTM5NQkxMTQwMAkxMTQwOAkxMTQzMAkxMTQzOAkxMTQ0MgkxMTQ1OQkx
MTQ2OS4JMTE0ODcJMTE1MDEJMTE1MDIuCTExNTA1CTExNTA4CTExNTEyCTExNTE5CTExNTIy
CTExNTMyCTExNTQyCTExNTUxCTExNTU4CTExNTc4CTExNjA2CTExNjE2CTExNjI3CTExNjQw
CTExNjU4CTExNjYxCTExNjYzCTExNjc1LgkxMTY5NwkxMTcwNgkxMTczNgkxMTc1MwkxMTc3
NAkxMTc3NwkxMTgwNwkxMTgyNQkxMTgzMgkxMTg0NAkxMTg1MwkxMTg1NS4JMTE4NzEJMTE4
OTAJMTE4OTMJMTE5MjIJMTE5NjAgVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1pbm4tMjc2OTkt
MjAxMzA2MTgwNTI4NDUtMy4wLjAtNjcKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4wCmdpdCBj
aGVja291dCB2Mi42LjM5ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDAyZjhjNmEuLi4g
TGludXggMy4wCkhFQUQgaXMgbm93IGF0IDYxYzRmMmMuLi4gTGludXggMi42LjM5CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUv
bGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjYxYzRmMmM4MWM2MWY3
MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2Y6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE4LTA1
OjI5OjE5IDYxYzRmMmM4MWM2MWY3MzU0OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2YgY29tcGls
aW5nCjE0MiByZWFsICAxMDM5IHVzZXIgIDcyIHN5cyAgNzgwLjcxJSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1zMDQtMDYwNQoyMDEzLTA2LTE4LTA1OjMxOjUzIDYxYzRmMmM4MWM2MWY3MzU0
OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2YgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3Mg
aW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zMDQtMDYwNS82MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYyNmFhMzZhOGNmCmJp
c2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzkKZ2l0IGNoZWNrb3V0IHYyLjYu
MzgKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNjFjNGYyYy4uLiBMaW51eCAyLjYuMzkK
SEVBRCBpcyBub3cgYXQgNTIxY2I0MC4uLiBMaW51eCAyLjYuMzgKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZl
bDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6NTIxY2I0MGIwYzQ0NDE4YTRmZDM2ZGM2
MzNmNTc1ODEzZDU5YTQzZDpiaXNlY3Qtc291bmQKCjIwMTMtMDYtMTgtMDU6MzI6MDEgNTIx
Y2I0MGIwYzQ0NDE4YTRmZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZCBjb21waWxpbmcKMTA2IHJl
YWwgIDEwMTkgdXNlciAgNzAgc3lzICAxMDIxLjk1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1z
MDQtMDYwNQoyMDEzLTA2LTE4LTA1OjMzOjU1IDUyMWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMz
ZjU3NTgxM2Q1OWE0M2QgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dm
Zy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYw
NS81MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1NzU4MTNkNTlhNDNkCmJpc2VjdDogc2tp
cCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMzgKZ2l0IGNoZWNrb3V0IHYyLjYuMzcKUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgNTIxY2I0MC4uLiBMaW51eCAyLjYuMzgKSEVBRCBpcyBu
b3cgYXQgM2MwZWVlM2YuLi4gTGludXggMi42LjM3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwt
c25iLWkzODYtMjAxMzA2MDYyMTU0OjNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0
YWE2NGY2ZDU6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE4LTA1OjM0OjAyIDNjMGVlZTNmZTZh
M2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2ZDUgY29tcGlsaW5nCjEwNyByZWFsICA5NzQg
dXNlciAgNjUgc3lzICA5NjYuMzIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1CjIw
MTMtMDYtMTgtMDU6MzY6MDQgM2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5NTQ3YzdlN2M5MDRhYTY0
ZjZkNSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJp
c2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1LzNjMGVlZTNm
ZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2ZDUKYmlzZWN0OiBza2lwIGJyb2tlbiBi
dWlsZCBmb3IgdjIuNi4zNwpnaXQgY2hlY2tvdXQgdjIuNi4zNgpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyAzYzBlZWUzZi4uLiBMaW51eCAyLjYuMzcKSEVBRCBpcyBub3cgYXQgZjZm
OTRlMi4uLiBMaW51eCAyLjYuMzYKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0y
MDEzMDYwNjIxNTQ6ZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3MWY2NjM4NWE2MGQ4MTU3Zjpi
aXNlY3Qtc291bmQKCjIwMTMtMDYtMTgtMDU6MzY6MTEgZjZmOTRlMmFiMWIzM2YwMDgyYWMy
MmQ3MWY2NjM4NWE2MGQ4MTU3ZiBjb21waWxpbmcKMTAxIHJlYWwgIDkzMyB1c2VyICA2MiBz
eXMgIDk3Ny4yOSUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0LTA2MDUKMjAxMy0wNi0xOC0w
NTozODowOSBmNmY5NGUyYWIxYjMzZjAwODJhYzIyZDcxZjY2Mzg1YTYwZDgxNTdmIFNLSVAg
QlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFuZCAv
dG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvZjZmOTRlMmFiMWIzM2YwMDgy
YWMyMmQ3MWY2NjM4NWE2MGQ4MTU3ZgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2
Mi42LjM2CmdpdCBjaGVja291dCB2Mi42LjM1ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IGY2Zjk0ZTIuLi4gTGludXggMi42LjM2CkhFQUQgaXMgbm93IGF0IDlmZTYyMDYuLi4gTGlu
dXggMi42LjM1CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0
OjlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTE6YmlzZWN0LXNvdW5k
CgoyMDEzLTA2LTE4LTA1OjM4OjE1IDlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFk
NTMwZThkNTEgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6IG1h
a2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjk5IHJlYWwgIDkwMyB1c2VyICA2
MiBzeXMgIDk2OS45NCUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0LTA2MDUKMjAxMy0wNi0x
OC0wNTo0MDoxMSA5ZmU2MjA2ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkxZDUzMGU4ZDUxIFNL
SVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFu
ZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvOWZlNjIwNmY0MDA2NDZh
MjMyMjA5NmI1NmM1OTg5MWQ1MzBlOGQ1MQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZv
ciB2Mi42LjM1CmdpdCBjaGVja291dCB2Mi42LjM0ClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDlmZTYyMDYuLi4gTGludXggMi42LjM1CkhFQUQgaXMgbm93IGF0IGU0MDE1MmUuLi4g
TGludXMgMi42LjM0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYy
MTU0OmU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODY6YmlzZWN0LXNv
dW5kCgoyMDEzLTA2LTE4LTA1OjQwOjE1IGU0MDE1MmVlMWUxYzdhNjNmNDc3Nzc5MTg2MzIx
NWUzZmFhMzdhODYgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6
IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMw
NC0wNjA1OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjEwMCByZWFsICA4NzMgdXNl
ciAgNjMgc3lzICA5MzMuNjUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1CjIwMTMt
MDYtMTgtMDU6NDI6MTUgZTQwMTUyZWUxZTFjN2E2M2Y0Nzc3NzkxODYzMjE1ZTNmYWEzN2E4
NiBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2Vj
dCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2U0MDE1MmVlMWUx
YzdhNjNmNDc3Nzc5MTg2MzIxNWUzZmFhMzdhODYKYmlzZWN0OiBza2lwIGJyb2tlbiBidWls
ZCBmb3IgdjIuNi4zNApnaXQgY2hlY2tvdXQgdjIuNi4zMwpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyBlNDAxNTJlLi4uIExpbnVzIDIuNi4zNApIRUFEIGlzIG5vdyBhdCA2MGIzNDFi
Li4uIExpbnV4IDIuNi4zMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMw
NjA2MjE1NDo2MGIzNDFiNzc4Y2MyOTI5ZGYxNmMwYTUwNGM5MTYyMWIzYzZhNGFkOmJpc2Vj
dC1zb3VuZAoKMjAxMy0wNi0xOC0wNTo0MjoyMSA2MGIzNDFiNzc4Y2MyOTI5ZGYxNmMwYTUw
NGM5MTYyMWIzYzZhNGFkIGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZp
Zy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQoxODEgcmVhbCAgODU0
IHVzZXIgIDYxIHN5cyAgNTA0LjI1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQoy
MDEzLTA2LTE4LTA1OjQ4OjExIDYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNj
NmE0YWQgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1i
aXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS82MGIzNDFi
Nzc4Y2MyOTI5ZGYxNmMwYTUwNGM5MTYyMWIzYzZhNGFkCmJpc2VjdDogc2tpcCBicm9rZW4g
YnVpbGQgZm9yIHYyLjYuMzMKZ2l0IGNoZWNrb3V0IHYyLjYuMzIKUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgNjBiMzQxYi4uLiBMaW51eCAyLjYuMzMKSEVBRCBpcyBub3cgYXQgMjI3
NjNjNS4uLiBMaW51eCAyLjYuMzIKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0y
MDEzMDYwNjIxNTQ6MjI3NjNjNWNmMzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNzpi
aXNlY3Qtc291bmQKCjIwMTMtMDYtMTgtMDU6NDg6MTYgMjI3NjNjNWNmMzY5MGE2ODE1NTEx
NjJjMTVkMzRkOTM1MzA4YzhkNyBjb21waWxpbmcKG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1z
MDQtMDYwNTogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRj
b25maWctczA0LTA2MDU6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMTM0IHJlYWwg
IDgzMiB1c2VyICA2MSBzeXMgIDY2My40MiUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0LTA2
MDUKMjAxMy0wNi0xOC0wNTo1MDo1NCAyMjc2M2M1Y2YzNjkwYTY4MTU1MTE2MmMxNWQzNGQ5
MzUzMDhjOGQ3IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291
bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvMjI3
NjNjNWNmMzY5MGE2ODE1NTExNjJjMTVkMzRkOTM1MzA4YzhkNwpiaXNlY3Q6IHNraXAgYnJv
a2VuIGJ1aWxkIGZvciB2Mi42LjMyCmdpdCBjaGVja291dCB2Mi42LjMxClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDIyNzYzYzUuLi4gTGludXggMi42LjMyCkhFQUQgaXMgbm93IGF0
IDc0ZmNhNmEuLi4gTGludXggMi42LjMxCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkz
ODYtMjAxMzA2MDYyMTU0Ojc0ZmNhNmE0Mjg2M2ZmYWNhZjdiYTZmMTkzNmE5ZjIyODk1MGY2
NTc6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE4LTA1OjUwOjU4IDc0ZmNhNmE0Mjg2M2ZmYWNh
ZjdiYTZmMTkzNmE5ZjIyODk1MGY2NTcgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25m
aWctczA0LTA2MDU6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1y
YW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjgxIHJl
YWwgIDczMSB1c2VyICA1MSBzeXMgIDk2MC4wMiUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0
LTA2MDUKMjAxMy0wNi0xOC0wNTo1Mjo0NSA3NGZjYTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZh
OWYyMjg5NTBmNjU3IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcv
c291bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUv
NzRmY2E2YTQyODYzZmZhY2FmN2JhNmYxOTM2YTlmMjI4OTUwZjY1NwpiaXNlY3Q6IHNraXAg
YnJva2VuIGJ1aWxkIGZvciB2Mi42LjMxCmdpdCBjaGVja291dCB2Mi42LjMwClByZXZpb3Vz
IEhFQUQgcG9zaXRpb24gd2FzIDc0ZmNhNmEuLi4gTGludXggMi42LjMxCkhFQUQgaXMgbm93
IGF0IDA3YTIwMzkuLi4gTGludXggMi42LjMwCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25i
LWkzODYtMjAxMzA2MDYyMTU0OjA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAy
NjQ4YzY6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE4LTA1OjUyOjQ5IDA3YTIwMzliOGViMGFm
NGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRj
b25maWctczA0LTA2MDU6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4
Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjU2
IHJlYWwgIDUyOSB1c2VyICA0MyBzeXMgIDEwMTEuOTklIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXMwNC0wNjA1CjIwMTMtMDYtMTgtMDU6NTQ6MDEgMDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQz
ZGZkOTVkZTVjMDI2NDhjNiBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mv
d2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1LzA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYKYmlzZWN0OiBz
a2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMApnaXQgY2hlY2tvdXQgdjIuNi4yOQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAwN2EyMDM5Li4uIExpbnV4IDIuNi4zMApIRUFEIGlz
IG5vdyBhdCA4ZTBlZTQzLi4uIExpbnV4IDIuNi4yOQpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVs
LXNuYi1pMzg2LTIwMTMwNjA2MjE1NDo4ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0
Y2U4ODVjZDg0OmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNTo1NDowNiA4ZTBlZTQzYmMy
YzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1y
YW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1
bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1sw
bQo1NiByZWFsICA1MDUgdXNlciAgNDEgc3lzICA5NjIuMjclIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLXMwNC0wNjA1CjIwMTMtMDYtMTgtMDU6NTU6MjIgOGUwZWU0M2JjMmMzZTE5ZGI1NmE0
YWRhYTlhOWIwNGNlODg1Y2Q4NCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAv
Y2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMw
NC0wNjA1LzhlMGVlNDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQKYmlzZWN0
OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yOQpnaXQgY2hlY2tvdXQgdjIuNi4yOApQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4ZTBlZTQzLi4uIExpbnV4IDIuNi4yOQpIRUFE
IGlzIG5vdyBhdCA0YTY5MDhhLi4uIExpbnV4IDIuNi4yOApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRl
dmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDo0YTY5MDhhM2EwNTBhYWNjOWMzYTJmMzZiMjc2
YjQ2YzA2MjlhZDkxOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNTo1NToyNyA0YTY5MDhh
M2EwNTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxIGNvbXBpbGluZwobWzE7MzVtaTM4
Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sx
OzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVk
G1swbQo0NiByZWFsICAzNzMgdXNlciAgMzYgc3lzICA4ODAuMzklIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLXMwNC0wNjA1CjIwMTMtMDYtMTgtMDU6NTY6MzggNGE2OTA4YTNhMDUwYWFjYzlj
M2EyZjM2YjI3NmI0NmMwNjI5YWQ5MSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBp
biAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXMwNC0wNjA1LzRhNjkwOGEzYTA1MGFhY2M5YzNhMmYzNmIyNzZiNDZjMDYyOWFkOTEKYmlz
ZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yOApnaXQgY2hlY2tvdXQgdjIuNi4y
NwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA0YTY5MDhhLi4uIExpbnV4IDIuNi4yOApI
RUFEIGlzIG5vdyBhdCAzZmE4NzQ5Li4uIExpbnV4IDIuNi4yNwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVs
OmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDozZmE4NzQ5ZTU4NGI1NWYxMTgwNDExYWIx
YjUxMTE3MTkwYmFjMWU1OmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNTo1Njo0MyAzZmE4
NzQ5ZTU4NGI1NWYxMTgwNDExYWIxYjUxMTE3MTkwYmFjMWU1IGNvbXBpbGluZwobWzE7MzVt
aTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0K
G1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcgc3VjY2Vl
ZGVkG1swbQo0NiByZWFsICAzNDggdXNlciAgMzMgc3lzICA4MjkuMTYlIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLXMwNC0wNjA1CjIwMTMtMDYtMTgtMDU6NTc6NDQgM2ZhODc0OWU1ODRiNTVm
MTE4MDQxMWFiMWI1MTExNzE5MGJhYzFlNSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJv
cyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXMwNC0wNjA1LzNmYTg3NDllNTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUK
YmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNwpnaXQgY2hlY2tvdXQgdjIu
Ni4yNgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAzZmE4NzQ5Li4uIExpbnV4IDIuNi4y
NwpIRUFEIGlzIG5vdyBhdCBiY2U3Zjc5Li4uIExpbnV4IDIuNi4yNgpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRl
dmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDpiY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3
MDVkMjQ1N2I4MWZlN2I1NzI1OmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNTo1Nzo0OCBi
Y2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1IGNvbXBpbGluZwobWzE7
MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtb
MG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcgc3Vj
Y2VlZGVkG1swbQo1MCByZWFsICAzMTkgdXNlciAgMzEgc3lzICA2OTUuNDklIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLXMwNC0wNjA1CjIwMTMtMDYtMTgtMDU6NTg6NTcgYmNlN2Y3OTNkYWVj
M2U2NWVjNWM1NzA1ZDI0NTdiODFmZTdiNTcyNSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBl
cnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXMwNC0wNjA1L2JjZTdmNzkzZGFlYzNlNjVlYzVjNTcwNWQyNDU3YjgxZmU3YjU3
MjUKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNgpnaXQgY2hlY2tvdXQg
djIuNi4yNQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiY2U3Zjc5Li4uIExpbnV4IDIu
Ni4yNgpIRUFEIGlzIG5vdyBhdCA0YjExOWUyLi4uIExpbnV4IDIuNi4yNQpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4
LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDo0YjExOWUyMWQwYzY2YzIyZThj
YTAzZGYwNWQ5ZGU2MjNkMGViNTBmOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNTo1OTow
MiA0YjExOWUyMWQwYzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNkMGViNTBmIGNvbXBpbGluZwob
WzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxl
ZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcg
c3VjY2VlZGVkG1swbQozMCByZWFsICAzMDcgdXNlciAgMjkgc3lzICAxMTE2LjA5JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQoyMDEzLTA2LTE4LTA1OjU5OjQ1IDRiMTE5ZTIx
ZDBjNjZjMjJlOGNhMDNkZjA1ZDlkZTYyM2QwZWI1MGYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hl
Y2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zMDQtMDYwNS80YjExOWUyMWQwYzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNk
MGViNTBmCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjUKZ2l0IGNoZWNr
b3V0IHYyLjYuMjQKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNGIxMTllMi4uLiBMaW51
eCAyLjYuMjUKSEVBRCBpcyBub3cgYXQgNDk5MTQwOC4uLiBMaW51eCAyLjYuMjQKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9s
aW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6NDk5MTQwODRlNzk3NTMw
ZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhODpiaXNlY3Qtc291bmQKCjIwMTMtMDYtMTgtMDU6
NTk6NTAgNDk5MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhOCBjb21waWxp
bmcKG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRub2NvbmZpZyBm
YWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6IG1ha2Ugb2xkY29u
ZmlnIHN1Y2NlZWRlZBtbMG0KNDUgcmVhbCAgMjg2IHVzZXIgIDI4IHN5cyAgNjg1LjQzJSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQoyMDEzLTA2LTE4LTA2OjAwOjU4IDQ5OTE0
MDg0ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJjOThmYTggU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zMDQtMDYwNS80OTkxNDA4NGU3OTc1MzBkOWJhYWY1MWRmOWVkYTc3
YmFiYzk4ZmE4CmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjQKZ2l0IGNo
ZWNrb3V0IHYyLjYuMjMKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNDk5MTQwOC4uLiBM
aW51eCAyLjYuMjQKSEVBRCBpcyBub3cgYXQgYmJmMjUwMTBmLi4uIExpbnV4IDIuNi4yMwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDpiYmYyNTAxMGYx
YTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0x
OC0wNjowMTowMiBiYmYyNTAxMGYxYTZiNzYxOTE0NDMwZjVmY2EwODFlYzhjN2FjY2QxIGNv
bXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29u
ZmlnIGZhaWxlZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBv
bGRjb25maWcgc3VjY2VlZGVkG1swbQozNCByZWFsICAyNjMgdXNlciAgMjUgc3lzICA4MzMu
OTglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1CjIwMTMtMDYtMTgtMDY6MDE6NTUg
YmJmMjUwMTBmMWE2Yjc2MTkxNDQzMGY1ZmNhMDgxZWM4YzdhY2NkMSBTS0lQIEJST0tFTiBC
VUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2JiZjI1MDEwZjFhNmI3NjE5MTQ0MzBmNWZj
YTA4MWVjOGM3YWNjZDEKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yMwpn
aXQgY2hlY2tvdXQgdjIuNi4yMgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiYmYyNTAx
MGYuLi4gTGludXggMi42LjIzCkhFQUQgaXMgbm93IGF0IDdkY2NhMzAuLi4gTGludXggMi42
LjIyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
czA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OjdkY2Nh
MzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWM6YmlzZWN0LXNvdW5kCgoyMDEz
LTA2LTE4LTA2OjAxOjU5IDdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUw
NWMgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6IG1ha2Ugb2xk
bm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBt
YWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjMxIHJlYWwgIDI1NyB1c2VyICAyNiBzeXMg
IDg4OS4yOCUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0LTA2MDUKMjAxMy0wNi0xOC0wNjow
Mjo1MSA3ZGNjYTMwYTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjIFNLSVAgQlJP
S0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFuZCAvdG1w
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvN2RjY2EzMGEzMmFhZGIwNTIwNDE3
NTIxYjBjNDRmNDJkMDlmZTA1YwpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42
LjIyCmdpdCBjaGVja291dCB2Mi42LjIxClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDdk
Y2NhMzAuLi4gTGludXggMi42LjIyCkhFQUQgaXMgbm93IGF0IGRlNDZjMzMuLi4gTGludXgg
Mi42LjIxCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkzODYtMjAxMzA2MDYyMTU0OmRl
NDZjMzM3NDVmNWUyYWQ1OTRjNzJmMmNmNWY0OTA4NjFiMTZjZTE6YmlzZWN0LXNvdW5kCgoy
MDEzLTA2LTE4LTA2OjAyOjU1IGRlNDZjMzM3NDVmNWUyYWQ1OTRjNzJmMmNmNWY0OTA4NjFi
MTZjZTEgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6IG1ha2Ug
b2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1
OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjkgcmVhbCAgOCB1c2VyICAwIHN5cyAg
MTAxLjY0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNQoyMDEzLTA2LTE4LTA2OjAz
OjIyIGRlNDZjMzM3NDVmNWUyYWQ1OTRjNzJmMmNmNWY0OTA4NjFiMTZjZTEgU0tJUCBCUk9L
RU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9kZTQ2YzMzNzQ1ZjVlMmFkNTk0Yzcy
ZjJjZjVmNDkwODYxYjE2Y2UxCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYu
MjEKZ2l0IGNoZWNrb3V0IHYyLjYuMjAKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZGU0
NmMzMy4uLiBMaW51eCAyLjYuMjEKSEVBRCBpcyBub3cgYXQgNjJkMGNmYy4uLiBMaW51eCAy
LjYuMjAKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6NjJk
MGNmY2IyN2NmNzU1Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZDpiaXNlY3Qtc291bmQKCjIw
MTMtMDYtMTgtMDY6MDM6MjYgNjJkMGNmY2IyN2NmNzU1Y2ViZGM5M2NhOTVkYWJjODM2MDgw
MDdjZCBjb21waWxpbmcKG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBv
bGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6
IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KOSByZWFsICA4IHVzZXIgIDAgc3lzICAx
MDAuNTclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1CjIwMTMtMDYtMTgtMDY6MDM6
NDYgNjJkMGNmY2IyN2NmNzU1Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZCBTS0lQIEJST0tF
TiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1LzYyZDBjZmNiMjdjZjc1NWNlYmRjOTNj
YTk1ZGFiYzgzNjA4MDA3Y2QKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4y
MApnaXQgY2hlY2tvdXQgdjIuNi4xOQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA2MmQw
Y2ZjLi4uIExpbnV4IDIuNi4yMApIRUFEIGlzIG5vdyBhdCAwMjE1ZmZiLi4uIExpbnV4IDIu
Ni4xOQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIwMTMwNjA2MjE1NDowMjE1
ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0OmJpc2VjdC1zb3VuZAoKMjAx
My0wNi0xOC0wNjowMzo0OSAwMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZl
NzA0IGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9s
ZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTog
bWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo4IHJlYWwgIDggdXNlciAgMCBzeXMgIDEw
NC41NSUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0LTA2MDUKMjAxMy0wNi0xOC0wNjowNDox
MyAwMjE1ZmZiMDhjZTk5ZTJiYjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0IFNLSVAgQlJPS0VO
IEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0IGFuZCAvdG1wL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvMDIxNWZmYjA4Y2U5OWUyYmI1OWVjYTEx
NGE5OTQ5OWE0ZDA2ZTcwNApiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjE5
CmdpdCBjaGVja291dCB2Mi42LjE4ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDAyMTVm
ZmIuLi4gTGludXggMi42LjE5CkhFQUQgaXMgbm93IGF0IGU0NzhiZWMuLi4gTGludXggdjIu
Ni4xOC4gQXJyciEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYwNjIx
NTQ6ZTQ3OGJlYzBiYTBhODNhNDhhMGY2OTgyOTM0YjZkZTA3OWU3ZTZiMzpiaXNlY3Qtc291
bmQKCjIwMTMtMDYtMTgtMDY6MDQ6MTcgZTQ3OGJlYzBiYTBhODNhNDhhMGY2OTgyOTM0YjZk
ZTA3OWU3ZTZiMyBjb21waWxpbmcKG1sxOzM1bWkzODYtcmFuZGNvbmZpZy1zMDQtMDYwNTog
bWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW1pMzg2LXJhbmRjb25maWctczA0
LTA2MDU6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMjMgcmVhbCAgMjQxIHVzZXIg
IDIzIHN5cyAgMTEwNC4xMyUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0LTA2MDUKMjAxMy0w
Ni0xOC0wNjowNDo1NyBlNDc4YmVjMGJhMGE4M2E0OGEwZjY5ODI5MzRiNmRlMDc5ZTdlNmIz
IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcvc291bmQtYmlzZWN0
IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvZTQ3OGJlYzBiYTBh
ODNhNDhhMGY2OTgyOTM0YjZkZTA3OWU3ZTZiMwpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxk
IGZvciB2Mi42LjE4CmdpdCBjaGVja291dCB2Mi42LjE3ClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIGU0NzhiZWMuLi4gTGludXggdjIuNi4xOC4gQXJyciEKSEVBRCBpcyBub3cgYXQg
NDI3YWJmYS4uLiBMaW51eCB2Mi42LjE3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctczA0LTA2MDUvbGludXgtZGV2ZWw6ZGV2ZWwtc25iLWkz
ODYtMjAxMzA2MDYyMTU0OjQyN2FiZmEyOGFmZWRmZmFkZmNhOWRkOGIwNjdlYjZkMzZiYWM1
M2Y6YmlzZWN0LXNvdW5kCgoyMDEzLTA2LTE4LTA2OjA1OjAxIDQyN2FiZmEyOGFmZWRmZmFk
ZmNhOWRkOGIwNjdlYjZkMzZiYWM1M2YgY29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25m
aWctczA0LTA2MDU6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtaTM4Ni1y
YW5kY29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjM1IHJl
YWwgIDIyNCB1c2VyICAyMSBzeXMgIDY5NC40MCUgY3B1IAlpMzg2LXJhbmRjb25maWctczA0
LTA2MDUKMjAxMy0wNi0xOC0wNjowNjowNiA0MjdhYmZhMjhhZmVkZmZhZGZjYTlkZDhiMDY3
ZWI2ZDM2YmFjNTNmIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93Zmcv
c291bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctczA0LTA2MDUv
NDI3YWJmYTI4YWZlZGZmYWRmY2E5ZGQ4YjA2N2ViNmQzNmJhYzUzZgpiaXNlY3Q6IHNraXAg
YnJva2VuIGJ1aWxkIGZvciB2Mi42LjE3CmdpdCBjaGVja291dCB2Mi42LjE2ClByZXZpb3Vz
IEhFQUQgcG9zaXRpb24gd2FzIDQyN2FiZmEuLi4gTGludXggdjIuNi4xNwpIRUFEIGlzIG5v
dyBhdCA3NzA1YTg3Li4uIExpbnV4IDIuNi4xNgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNu
Yi1pMzg2LTIwMTMwNjA2MjE1NDo3NzA1YTg3OTJiMGZjODJmZDdkNGRkOTIzNzI0NjA2YmJm
ZDlmYjIwOmJpc2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNjowNjoxMCA3NzA1YTg3OTJiMGZj
ODJmZDdkNGRkOTIzNzI0NjA2YmJmZDlmYjIwIGNvbXBpbGluZwobWzE7MzVtaTM4Ni1yYW5k
Y29uZmlnLXMwNC0wNjA1OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bWkz
ODYtcmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQoz
MCByZWFsICAyMjUgdXNlciAgMjEgc3lzICA3OTguNjIlIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXMwNC0wNjA1CjIwMTMtMDYtMTgtMDY6MDc6MDYgNzcwNWE4NzkyYjBmYzgyZmQ3ZDRkZDky
MzcyNDYwNmJiZmQ5ZmIyMCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAvY2Mv
d2ZnL3NvdW5kLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXMwNC0w
NjA1Lzc3MDVhODc5MmIwZmM4MmZkN2Q0ZGQ5MjM3MjQ2MDZiYmZkOWZiMjAKYmlzZWN0OiBz
a2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4xNgpnaXQgY2hlY2tvdXQgdjIuNi4xNQpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA3NzA1YTg3Li4uIExpbnV4IDIuNi4xNgpIRUFEIGlz
IG5vdyBhdCA4ODAyNjg0Li4uIExpbnV4IHYyLjYuMTUKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZl
bC1zbmItaTM4Ni0yMDEzMDYwNjIxNTQ6ODgwMjY4NDJiMGE3NjAxNDVhYTcxZDY5ZTc0ZmJj
OWVjMTE4Y2E0NDpiaXNlY3Qtc291bmQKCjIwMTMtMDYtMTgtMDY6MDc6MTAgODgwMjY4NDJi
MGE3NjAxNDVhYTcxZDY5ZTc0ZmJjOWVjMTE4Y2E0NCBjb21waWxpbmcKG1sxOzM1bWkzODYt
cmFuZGNvbmZpZy1zMDQtMDYwNTogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTsz
NW1pMzg2LXJhbmRjb25maWctczA0LTA2MDU6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtb
MG0KMjIgcmVhbCAgMjE2IHVzZXIgIDIwIHN5cyAgMTAzOS4wNCUgY3B1IAlpMzg2LXJhbmRj
b25maWctczA0LTA2MDUKMjAxMy0wNi0xOC0wNjowNzo0OSA4ODAyNjg0MmIwYTc2MDE0NWFh
NzFkNjllNzRmYmM5ZWMxMThjYTQ0IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGlu
IC9jYy93Zmcvc291bmQtYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
czA0LTA2MDUvODgwMjY4NDJiMGE3NjAxNDVhYTcxZDY5ZTc0ZmJjOWVjMTE4Y2E0NApiaXNl
Y3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjE1ChtbMTszNW1jYW5ub3QgZmluZCB0
aGUgZmlyc3QgYmFkIGNvbW1pdBtbMG0KCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0K
RmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1zMDQtMDYwNS9saW51eC1kZXZlbDpkZXZlbC1zbmItaTM4Ni0yMDEzMDYw
NjIxNTQ6ODE3N2E5ZDc5YzBlOTQyZGNhYzMzMTJmMTU1ODVkMDM0NGQ1MDVhNTpiaXNlY3Qt
c291bmQKCjIwMTMtMDYtMTgtMDY6MDg6MDcgODE3N2E5ZDc5YzBlOTQyZGNhYzMzMTJmMTU1
ODVkMDM0NGQ1MDVhNSBjb21waWxpbmcKG1sxOzM1bWFkZF90b19ydW5fcXVldWU6IHJlcXVl
c3RlZCAzMDAwMCwgbGltaXQgdG8gNTAwMBtbMG0KCjIwMTMtMDYtMTgtMDY6MTM6MDggZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNi0wMDAwMS1nODE3N2E5ZC4uLgk1CTE0CTU0
CTk5CTEyNwkxNjEJMTkyCTIyOQkyNDkJMjgzCTMxNgkzMzEJMzgxCTM5OAk0MjkJNDUzCTQ5
MyBURVNUIEZBSUxVUkUKZG1lc2cta3ZtLXdhaW1lYS0zODU5LTIwMTMwNjE4MDYyNTA1LTMu
MTAuMC1yYzYtMDAwMDEtZzgxNzdhOWQtNjgKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09
PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXMwNC0wNjA1L2xpbnV4LWRldmVsOmRldmVsLXNuYi1pMzg2LTIw
MTMwNjA2MjE1NDozNDI4MGEyZWUzM2NhMjQ0NDVhMmIxN2IyZTMwNmQzNzY4MDNhZGRhOmJp
c2VjdC1zb3VuZAoKMjAxMy0wNi0xOC0wNjoyMzoxNCAzNDI4MGEyZWUzM2NhMjQ0NDVhMmIx
N2IyZTMwNmQzNzY4MDNhZGRhIGNvbXBpbGluZwoyMDEzLTA2LTE4LTA2OjI2OjE0IDM0Mjgw
YTJlZTMzY2EyNDQ0NWEyYjE3YjJlMzA2ZDM3NjgwM2FkZGEgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2NjL3dmZy9zb3VuZC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zMDQtMDYwNS8zNDI4MGEyZWUzM2NhMjQ0NDVhMmIxN2IyZTMwNmQz
NzY4MDNhZGRhCg==

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc4 Kernel Configuration
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
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_MDFLD is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
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
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
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
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=y
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_SODAVILLE=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_GPIO=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=y
# CONFIG_RDC321X_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_MFD_CROS_EC_SPI is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8994=y
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_LOGO is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
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
# CONFIG_STAGING is not set
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
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
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
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_KXSD9 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
# CONFIG_AD7298 is not set
CONFIG_AD7923=y
CONFIG_AD7791=y
CONFIG_AD7793=y
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
# CONFIG_EXYNOS_ADC is not set
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5755=y
CONFIG_AD5764=y
CONFIG_AD5791=y
# CONFIG_AD5686 is not set
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16136=y
CONFIG_ADXRS450=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
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
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
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
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_RING_BUFFER_STARTUP_TEST=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
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
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
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
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--W/nzBZO5zC0uMSeA--
