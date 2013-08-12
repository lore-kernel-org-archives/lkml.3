Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3HLHEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:04:24 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33061 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3HLHET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:04:19 -0400
Date: Mon, 12 Aug 2013 00:04:11 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
Message-ID: <20130812070411.GA2878@elie.Belkin>
References: <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20130116025251.GM2668@htj.dyndns.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Tejun Heo wrote:

> This avoids the described deadlock because iosched module doesn't use
> async and thus wouldn't invoke async_synchronize_full().  This is
> hacky and incomplete.  It will deadlock if async module loading nests;
> however, this works around the known problem case and seems to be the
> best of bad options.
>
> For more details, please refer to the following thread.
>
>   http://thread.gmane.org/gmane.linux.kernel/1420814

My laptop fails to boot[1] with the message 'Volume group "data" not
found'.  Bisects to v3.8-rc4~17 (the above commit).  Reverting that
commit on top of current "master" (d92581fcad18, 2013-08-10) produces
a working kernel.  dmesg output from that working kernel attached.
More details, including .config, at [2].

Any ideas for tracking this down?

Thanks,
Jonathan

[1] Screenshot: http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=bad_3.10.3-1.jpg;att=1;bug=719464
Screenshot in recovery mode: http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=bad_3.10.3-1_recovery.jpg;att=2;bug=719464
[2] http://bugs.debian.org/719464

--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.11.0-rc4+ (jrn@elie) (gcc version 4.7.3 (Debian 4.7.3-6) ) #2 SMP Sun Aug 11 23:20:20 PDT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.11.0-rc4+ root=/dev/mapper/data-root ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006e545fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006e546000-0x000000006e745fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006e746000-0x000000006fd3efff] usable
[    0.000000] BIOS-e820: [mem 0x000000006fd3f000-0x000000006fdbefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006fdbf000-0x000000006febefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006febf000-0x000000006fef6fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000006fef7000-0x000000006fefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000f8ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: TOSHIBA Satellite C650D/Portable PC, BIOS 1.60 09/02/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x6ff00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFFC0000000 write-back
[    0.000000]   1 base 000040000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 000060000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 00006FEBE000 mask FFFFFFFFF000 uncachable
[    0.000000]   4 base 0000FFE00000 mask FFFFFFE00000 write-protect
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0184c000, 0x0184cfff] PGTABLE
[    0.000000] BRK [0x0184d000, 0x0184dfff] PGTABLE
[    0.000000] BRK [0x0184e000, 0x0184efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6fa00000-0x6fbfffff]
[    0.000000]  [mem 0x6fa00000-0x6fbfffff] page 2M
[    0.000000] BRK [0x0184f000, 0x0184ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6e545fff]
[    0.000000]  [mem 0x6c000000-0x6e3fffff] page 2M
[    0.000000]  [mem 0x6e400000-0x6e545fff] page 4k
[    0.000000] BRK [0x01850000, 0x01850fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x6e746000-0x6f9fffff]
[    0.000000]  [mem 0x6e746000-0x6e7fffff] page 4k
[    0.000000]  [mem 0x6e800000-0x6f9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x6bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x6fc00000-0x6fd3efff]
[    0.000000]  [mem 0x6fc00000-0x6fd3efff] page 4k
[    0.000000] init_memory_mapping: [mem 0x6fef7000-0x6fefffff]
[    0.000000]  [mem 0x6fef7000-0x6fefffff] page 4k
[    0.000000] RAMDISK: [mem 0x37ab2000-0x37d50fff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 TOSINV)
[    0.000000] ACPI: XSDT 000000006fef6120 0005C (v01 TOSINV TOSINV00 00000003      01000013)
[    0.000000] ACPI: FACP 000000006fef5000 000F4 (v04 TOSINV TOSINV00 00000003 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000006fee6000 0BAD7 (v01 TOSINV TOSINV00 F0000000 MSFT 01000013)
[    0.000000] ACPI: FACS 000000006fe9c000 00040
[    0.000000] ACPI: HPET 000000006fef4000 00038 (v01 TOSINV TOSINV00 00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000006fef3000 00084 (v02 TOSINV TOSINV00 00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000006fef2000 0003C (v01 TOSINV TOSINV00 00000001 MSFT 01000013)
[    0.000000] ACPI: BOOT 000000006fee5000 00028 (v01 TOSINV TOSINV00 00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000006fee4000 00176 (v01 TOSINV TOSINV00 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000006fee3000 00392 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000006fefffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x6fefffff]
[    0.000000]   NODE_DATA [mem 0x6fefc000-0x6fefffff]
[    0.000000]  [ffffea0000000000-ffffea00019fffff] PMD -> [ffff88006c800000-ffff88006e1fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x6e545fff]
[    0.000000]   node   0: [mem 0x6e746000-0x6fd3efff]
[    0.000000]   node   0: [mem 0x6fef7000-0x6fefffff]
[    0.000000] On node 0 totalpages: 457446
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6213 pages used for memmap
[    0.000000]   DMA32 zone: 453448 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x1002a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6e546000-0x6e745fff]
[    0.000000] PM: Registered nosave memory: [mem 0x6fd3f000-0x6fdbefff]
[    0.000000] PM: Registered nosave memory: [mem 0x6fdbf000-0x6febefff]
[    0.000000] PM: Registered nosave memory: [mem 0x6febf000-0x6fef6fff]
[    0.000000] e820: [mem 0x6ff00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88006f800000 s80512 r8192 d21888 u524288
[    0.000000] pcpu-alloc: s80512 r8192 d21888 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 451156
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.11.0-rc4+ root=/dev/mapper/data-root ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ d912000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1791168K/1829784K available (3365K kernel code, 591K rwdata, 1444K rodata, 856K init, 884K bss, 38616K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 7340032 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2294.162 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4588.32 BogoMIPS (lpj=9176648)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000049] Security Framework initialized
[    0.000055] AppArmor: AppArmor disabled by boot time parameter
[    0.000208] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001142] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.001587] Mount-cache hash table entries: 256
[    0.001813] Initializing cgroup subsys memory
[    0.001835] Initializing cgroup subsys devices
[    0.001837] Initializing cgroup subsys freezer
[    0.001840] Initializing cgroup subsys net_cls
[    0.001842] Initializing cgroup subsys blkio
[    0.001844] Initializing cgroup subsys perf_event
[    0.001867] tseg: 006ff00000
[    0.001870] CPU: Physical Processor ID: 0
[    0.001871] CPU: Processor Core ID: 0
[    0.001873] mce: CPU supports 6 MCE banks
[    0.001880] LVT offset 0 assigned for vector 0xf9
[    0.001885] process: using AMD E400 aware idle routine
[    0.001888] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.001888] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.001888] tlb_flushall_shift: 4
[    0.001960] Freeing SMP alternatives memory: 8K (ffffffff8176b000 - ffffffff8176d000)
[    0.001962] ACPI: Core revision 20130517
[    0.001964] TOSHIBA Satellite detected - force copy of DSDT to local memory
[    0.002085] ACPI: Forced DSDT copy: length 0x0BAD7 copied locally, original unmapped
[    0.006991] ACPI: All ACPI Tables successfully acquired
[    0.011022] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.050677] smpboot: CPU0: AMD Athlon(tm) II P360 Dual-Core Processor (fam: 10, model: 06, stepping: 03)
[    0.155726] Performance Events: AMD PMU driver.
[    0.155731] ... version:                0
[    0.155733] ... bit width:              48
[    0.155734] ... generic registers:      4
[    0.155735] ... value mask:             0000ffffffffffff
[    0.155737] ... max period:             00007fffffffffff
[    0.155738] ... fixed-purpose events:   0
[    0.155739] ... event mask:             000000000000000f
[    0.156004] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.156121] smpboot: Booting Node   0, Processors  #1
[    0.169239] Brought up 2 CPUs
[    0.169242] smpboot: Total of 2 processors activated (9176.64 BogoMIPS)
[    0.169589] process: System has AMD C1E enabled
[    0.169607] process: Switch to broadcast mode on CPU1
[    0.169729] process: Switch to broadcast mode on CPU0
[    0.173823] devtmpfs: initialized
[    0.176836] PM: Registering ACPI NVS region [mem 0x6e546000-0x6e745fff] (2097152 bytes)
[    0.176908] PM: Registering ACPI NVS region [mem 0x6fdbf000-0x6febefff] (1048576 bytes)
[    0.177161] regulator-dummy: no parameters
[    0.177238] NET: Registered protocol family 16
[    0.177339] node 0 link 0: io port [0, ffffff]
[    0.177342] TOM: 0000000080000000 aka 2048M
[    0.177345] Fam 10h mmconf [mem 0xf8000000-0xfbffffff]
[    0.177348] node 0 link 0: mmio [80000000, 8fffffff]
[    0.177350] node 0 link 0: mmio [90000000, 920fffff]
[    0.177352] node 0 link 0: mmio [92100000, 922fffff]
[    0.177354] node 0 link 0: mmio [92300000, f7ffffff]
[    0.177356] node 0 link 0: mmio [f8000000, fbffffff] ==> none
[    0.177358] node 0 link 0: mmio [fc000000, febfffff]
[    0.177360] node 0 link 0: mmio [fec00000, fffeffff]
[    0.177362] node 0 link 0: mmio [ffff0000, ffffffff]
[    0.177364] bus: [bus 00-1f] on node 0 link 0
[    0.177366] bus: 00 [io  0x0000-0xffff]
[    0.177368] bus: 00 [mem 0x80000000-0xf7ffffff]
[    0.177370] bus: 00 [mem 0xfc000000-0xfcffffffff]
[    0.177400] ACPI: bus type PCI registered
[    0.177402] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.177460] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.177463] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.177466] PCI: MMCONFIG for 0000 [bus00-0f] at [mem 0xf8000000-0xf8ffffff] (base 0xf8000000) (size reduced!)
[    0.178326] PCI: Using configuration type 1 for base access
[    0.178455] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.178456] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.178458] mtrr: probably your BIOS does not setup all CPUs.
[    0.178459] mtrr: corrected configuration.
[    0.179115] bio: create slab <bio-0> at 0
[    0.179249] ACPI: Added _OSI(Module Device)
[    0.179252] ACPI: Added _OSI(Processor Device)
[    0.179253] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.179255] ACPI: Added _OSI(Processor Aggregator Device)
[    0.180366] ACPI: EC: Look up EC in DSDT
[    0.181561] ACPI: Executed 1 blocks of module-level executable AML code
[    0.185333] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.611520] ACPI: Interpreter enabled
[    0.611531] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    0.611536] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.611552] ACPI: (supports S0 S3 S4 S5)
[    0.611555] ACPI: Using IOAPIC for interrupt routing
[    0.611763] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.639420] ACPI: Power Resource [PFA1] (off)
[    0.640221] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.641101] acpi PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cefff])
[    0.641108] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-0f] only partially covers this bridge
[    0.641193] PCI host bridge to bus 0000:00
[    0.641196] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.641199] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.641202] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.641204] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.641207] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.641209] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.641211] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.641214] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.641216] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.641218] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.641221] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.641223] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.641225] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.641228] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.641230] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.641232] pci_bus 0000:00: root bus resource [mem 0x80000000-0xf7ffffff]
[    0.641235] pci_bus 0000:00: root bus resource [mem 0xfc000000-0xfed3ffff]
[    0.641237] pci_bus 0000:00: root bus resource [mem 0xfed45000-0xffffffff]
[    0.641251] pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
[    0.641384] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
[    0.641493] pci 0000:00:04.0: [1022:9604] type 01 class 0x060400
[    0.641529] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.641615] pci 0000:00:05.0: [1022:9605] type 01 class 0x060400
[    0.641650] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.641701] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.641796] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.641818] pci 0000:00:11.0: reg 0x10: [io  0x8038-0x803f]
[    0.641828] pci 0000:00:11.0: reg 0x14: [io  0x804c-0x804f]
[    0.641837] pci 0000:00:11.0: reg 0x18: [io  0x8030-0x8037]
[    0.641847] pci 0000:00:11.0: reg 0x1c: [io  0x8048-0x804b]
[    0.641856] pci 0000:00:11.0: reg 0x20: [io  0x8010-0x801f]
[    0.641866] pci 0000:00:11.0: reg 0x24: [mem 0x92307000-0x923073ff]
[    0.642000] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.642013] pci 0000:00:12.0: reg 0x10: [mem 0x92306000-0x92306fff]
[    0.649649] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.649700] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.649718] pci 0000:00:12.2: reg 0x10: [mem 0x92307600-0x923076ff]
[    0.649796] pci 0000:00:12.2: supports D1 D2
[    0.649798] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.658318] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.658368] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.658381] pci 0000:00:13.0: reg 0x10: [mem 0x92305000-0x92305fff]
[    0.658521] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.658539] pci 0000:00:13.2: reg 0x10: [mem 0x92307500-0x923075ff]
[    0.658617] pci 0000:00:13.2: supports D1 D2
[    0.658619] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.658715] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.658859] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.658880] pci 0000:00:14.2: reg 0x10: [mem 0x92300000-0x92303fff 64bit]
[    0.658942] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.658994] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.659038] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.659178] pci 0000:00:14.4: [1002:4384] type 01 class 0x060400
[    0.659253] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.659302] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.659316] pci 0000:00:16.0: reg 0x10: [mem 0x92304000-0x92304fff]
[    0.659451] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.659470] pci 0000:00:16.2: reg 0x10: [mem 0x92307400-0x923074ff]
[    0.659547] pci 0000:00:16.2: supports D1 D2
[    0.659549] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.659645] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.659724] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.659801] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.659876] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.659955] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.660123] pci 0000:01:05.0: [1002:9712] type 00 class 0x030000
[    0.660132] pci 0000:01:05.0: reg 0x10: [mem 0x80000000-0x8fffffff pref]
[    0.660137] pci 0000:01:05.0: reg 0x14: [io  0x7000-0x70ff]
[    0.660143] pci 0000:01:05.0: reg 0x18: [mem 0x92200000-0x9220ffff]
[    0.660153] pci 0000:01:05.0: reg 0x24: [mem 0x92100000-0x921fffff]
[    0.660171] pci 0000:01:05.0: supports D1 D2
[    0.660239] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.660243] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.660246] pci 0000:00:01.0:   bridge window [mem 0x92100000-0x922fffff]
[    0.660251] pci 0000:00:01.0:   bridge window [mem 0x80000000-0x8fffffff 64bit pref]
[    0.660307] pci 0000:02:00.0: [168c:002b] type 00 class 0x028000
[    0.660325] pci 0000:02:00.0: reg 0x10: [mem 0x91100000-0x9110ffff 64bit]
[    0.660401] pci 0000:02:00.0: supports D1
[    0.660404] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.665344] pci 0000:00:04.0: PCI bridge to [bus 02-07]
[    0.665352] pci 0000:00:04.0:   bridge window [io  0x3000-0x6fff]
[    0.665356] pci 0000:00:04.0:   bridge window [mem 0x91100000-0x920fffff]
[    0.665361] pci 0000:00:04.0:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    0.665455] pci 0000:08:00.0: [1969:2060] type 00 class 0x020000
[    0.665478] pci 0000:08:00.0: reg 0x10: [mem 0x91000000-0x9103ffff 64bit]
[    0.665489] pci 0000:08:00.0: reg 0x18: [io  0x2000-0x207f]
[    0.665584] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.673339] pci 0000:00:05.0: PCI bridge to [bus 08]
[    0.673348] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    0.673352] pci 0000:00:05.0:   bridge window [mem 0x91000000-0x910fffff]
[    0.673462] pci 0000:00:14.4: PCI bridge to [bus 09]
[    0.673488] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.673491] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.674186] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674263] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674339] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674413] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674473] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674522] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674571] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674619] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.674825] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.674835] ACPI: \_SB_.PCI0: notify handler is installed
[    0.674886] Found 1 acpi root devices
[    0.675035] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.675037] vgaarb: loaded
[    0.675039] vgaarb: bridge control possible 0000:01:05.0
[    0.675089] PCI: Using ACPI for IRQ routing
[    0.675440] PCI: pci_cache_line_size set to 64 bytes
[    0.675497] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.675499] e820: reserve RAM buffer [mem 0x6e546000-0x6fffffff]
[    0.675502] e820: reserve RAM buffer [mem 0x6fd3f000-0x6fffffff]
[    0.675504] e820: reserve RAM buffer [mem 0x6ff00000-0x6fffffff]
[    0.675640] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.675644] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.677707] Switched to clocksource hpet
[    0.679522] pnp: PnP ACPI init
[    0.679544] ACPI: bus type PNP registered
[    0.679971] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.679974] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.679978] system 00:00: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.679983] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.680164] pnp 00:01: [dma 4]
[    0.680204] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.680254] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.680316] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.680351] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.680396] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.680452] pnp 00:06: Plug and Play ACPI device, IDs TOS0100 SYN1900 SYN0002 PNP0f13 (active)
[    0.680519] system 00:07: [io  0x0400-0x04cf] could not be reserved
[    0.680522] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.680525] system 00:07: [io  0x04d6] has been reserved
[    0.680528] system 00:07: [io  0x0680-0x06ff] has been reserved
[    0.680531] system 00:07: [io  0x077a] has been reserved
[    0.680533] system 00:07: [io  0x0c00-0x0c01] has been reserved
[    0.680536] system 00:07: [io  0x0c14] has been reserved
[    0.680539] system 00:07: [io  0x0c50-0x0c52] has been reserved
[    0.680542] system 00:07: [io  0x0c6c] has been reserved
[    0.680544] system 00:07: [io  0x0c6f] has been reserved
[    0.680547] system 00:07: [io  0x0cd0-0x0cdb] has been reserved
[    0.680550] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.680633] system 00:08: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.680636] system 00:08: [mem 0xffe00000-0xffffffff] has been reserved
[    0.680639] system 00:08: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.680643] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.681021] pnp: PnP ACPI: found 9 devices
[    0.681023] ACPI: bus type PNP unregistered
[    0.688732] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.688737] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.688741] pci 0000:00:01.0:   bridge window [mem 0x92100000-0x922fffff]
[    0.688745] pci 0000:00:01.0:   bridge window [mem 0x80000000-0x8fffffff 64bit pref]
[    0.688749] pci 0000:00:04.0: PCI bridge to [bus 02-07]
[    0.688751] pci 0000:00:04.0:   bridge window [io  0x3000-0x6fff]
[    0.688755] pci 0000:00:04.0:   bridge window [mem 0x91100000-0x920fffff]
[    0.688758] pci 0000:00:04.0:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    0.688762] pci 0000:00:05.0: PCI bridge to [bus 08]
[    0.688765] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    0.688768] pci 0000:00:05.0:   bridge window [mem 0x91000000-0x910fffff]
[    0.688772] pci 0000:00:14.4: PCI bridge to [bus 09]
[    0.688793] pci 0000:00:01.0: setting latency timer to 64
[    0.689044] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.689047] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.689049] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.689052] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.689054] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.689057] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.689059] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.689062] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.689064] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.689066] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.689069] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.689071] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.689073] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.689076] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.689078] pci_bus 0000:00: resource 18 [mem 0x80000000-0xf7ffffff]
[    0.689081] pci_bus 0000:00: resource 19 [mem 0xfc000000-0xfed3ffff]
[    0.689083] pci_bus 0000:00: resource 20 [mem 0xfed45000-0xffffffff]
[    0.689086] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    0.689088] pci_bus 0000:01: resource 1 [mem 0x92100000-0x922fffff]
[    0.689091] pci_bus 0000:01: resource 2 [mem 0x80000000-0x8fffffff 64bit pref]
[    0.689093] pci_bus 0000:02: resource 0 [io  0x3000-0x6fff]
[    0.689096] pci_bus 0000:02: resource 1 [mem 0x91100000-0x920fffff]
[    0.689098] pci_bus 0000:02: resource 2 [mem 0x90000000-0x90ffffff 64bit pref]
[    0.689101] pci_bus 0000:08: resource 0 [io  0x2000-0x2fff]
[    0.689103] pci_bus 0000:08: resource 1 [mem 0x91000000-0x910fffff]
[    0.689177] NET: Registered protocol family 2
[    0.689381] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.689514] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.689606] TCP: Hash tables configured (established 16384 bind 16384)
[    0.689671] TCP: reno registered
[    0.689679] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.689764] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.689897] NET: Registered protocol family 1
[    0.689913] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.691212] pci 0000:01:05.0: Boot video device
[    0.691220] PCI: CLS 64 bytes, default 64
[    0.691278] Unpacking initramfs...
[    1.063294] Freeing initrd memory: 2684K (ffff880037ab2000 - ffff880037d51000)
[    1.063634] Simple Boot Flag at 0x44 set to 0x1
[    1.063716] LVT offset 1 assigned for vector 0x400
[    1.063722] IBS: LVT offset 1 assigned
[    1.063746] perf: AMD IBS detected (0x0000001f)
[    1.064125] audit: initializing netlink socket (disabled)
[    1.064141] type=2000 audit(1376290884.944:1): initialized
[    1.080423] bounce pool size: 64 pages
[    1.080430] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.080964] VFS: Disk quotas dquot_6.5.2
[    1.081008] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.081119] msgmni has been set to 3503
[    1.081427] alg: No test for stdrng (krng)
[    1.081462] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.081503] io scheduler noop registered
[    1.081504] io scheduler deadline registered
[    1.081517] io scheduler cfq registered (default)
[    1.081677] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    1.081825] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
[    1.081975] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.081997] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.082113] GHES: HEST is not enabled!
[    1.082207] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.082819] Linux agpgart interface v0.103
[    1.082925] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.112145] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.112151] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.112371] mousedev: PS/2 mouse device common for all mice
[    1.112404] rtc_cmos 00:03: RTC can wake from S4
[    1.112582] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.112617] rtc_cmos 00:03: alarms up to one day, 114 bytes nvram, hpet irqs
[    1.112632] cpuidle: using governor ladder
[    1.112634] cpuidle: using governor menu
[    1.112707] TCP: cubic registered
[    1.113254] NET: Registered protocol family 10
[    1.113486] NET: Registered protocol family 17
[    1.113844] PM: Hibernation image not present or could not be loaded.
[    1.113859] registered taskstats version 1
[    1.114443] rtc_cmos 00:03: setting system clock to 2013-08-12 07:01:25 UTC (1376290885)
[    1.115745] Freeing unused kernel memory: 856K (ffffffff81695000 - ffffffff8176b000)
[    1.115749] Write protecting the kernel read-only data: 6144k
[    1.118871] Freeing unused kernel memory: 720K (ffff88000134c000 - ffff880001400000)
[    1.121300] Freeing unused kernel memory: 604K (ffff880001569000 - ffff880001600000)
[    1.139759] udevd[56]: starting version 175
[    1.146791] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.170368] ACPI: bus type USB registered
[    1.170405] usbcore: registered new interface driver usbfs
[    1.170417] usbcore: registered new interface driver hub
[    1.174602] SCSI subsystem initialized
[    1.176040] ACPI: bus type ATA registered
[    1.184322] usbcore: registered new device driver usb
[    1.184747] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.184929] ehci-pci: EHCI PCI platform driver
[    1.185189] ehci-pci 0000:00:12.2: setting latency timer to 64
[    1.185209] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.185222] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.185231] QUIRK: Enable AMD PLL fix
[    1.185233] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.185249] ehci-pci 0000:00:12.2: debug port 1
[    1.185306] ehci-pci 0000:00:12.2: irq 17, io mem 0x92307600
[    1.190382] libata version 3.00 loaded.
[    1.193374] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.193411] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.193414] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.193417] usb usb1: Product: EHCI Host Controller
[    1.193419] usb usb1: Manufacturer: Linux 3.11.0-rc4+ ehci_hcd
[    1.193421] usb usb1: SerialNumber: 0000:00:12.2
[    1.193609] hub 1-0:1.0: USB hub found
[    1.193616] hub 1-0:1.0: 5 ports detected
[    1.194098] ehci-pci 0000:00:13.2: setting latency timer to 64
[    1.194107] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.194115] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.194121] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.194133] ehci-pci 0000:00:13.2: debug port 1
[    1.194168] ehci-pci 0000:00:13.2: irq 17, io mem 0x92307500
[    1.205350] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.205385] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.205389] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.205392] usb usb2: Product: EHCI Host Controller
[    1.205394] usb usb2: Manufacturer: Linux 3.11.0-rc4+ ehci_hcd
[    1.205396] usb usb2: SerialNumber: 0000:00:13.2
[    1.205550] hub 2-0:1.0: USB hub found
[    1.205556] hub 2-0:1.0: 5 ports detected
[    1.206000] ehci-pci 0000:00:16.2: setting latency timer to 64
[    1.206010] ehci-pci 0000:00:16.2: EHCI Host Controller
[    1.206017] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 3
[    1.206023] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.206034] ehci-pci 0000:00:16.2: debug port 1
[    1.206068] ehci-pci 0000:00:16.2: irq 17, io mem 0x92307400
[    1.213191] ACPI: Fan [FAN1] (off)
[    1.217381] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.217420] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.217423] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.217426] usb usb3: Product: EHCI Host Controller
[    1.217429] usb usb3: Manufacturer: Linux 3.11.0-rc4+ ehci_hcd
[    1.217431] usb usb3: SerialNumber: 0000:00:16.2
[    1.217603] hub 3-0:1.0: USB hub found
[    1.217610] hub 3-0:1.0: 4 ports detected
[    1.218096] ahci 0000:00:11.0: version 3.0
[    1.218345] ahci 0000:00:11.0: irq 42 for MSI/MSI-X
[    1.218433] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    1.218438] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    1.220913] thermal LNXTHERM:00: registered as thermal_zone0
[    1.220917] ACPI: Thermal Zone [THZN] (53 C)
[    1.221130] scsi0 : ahci
[    1.221946] scsi1 : ahci
[    1.222325] scsi2 : ahci
[    1.222463] ata1: SATA max UDMA/133 abar m1024@0x92307000 port 0x92307100 irq 42
[    1.222467] ata2: SATA max UDMA/133 abar m1024@0x92307000 port 0x92307180 irq 42
[    1.222470] ata3: SATA max UDMA/133 abar m1024@0x92307000 port 0x92307200 irq 42
[    1.541194] ata3: SATA link down (SStatus 0 SControl 300)
[    1.713059] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.713095] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.715641] ata2.00: ATAPI: HL-DT-STDVDRAM GT30N, TN08, max UDMA/100
[    1.718625] ata2.00: configured for UDMA/100
[    1.761836] ata1.00: ATA-8: TOSHIBA MK3265GSXN, GH101M, max UDMA/100
[    1.761841] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.762720] ata1.00: configured for UDMA/100
[    1.763006] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3265GS GH10 PQ: 0 ANSI: 5
[    1.765590] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT30N     TN08 PQ: 0 ANSI: 5
[    1.771968] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.772022] sd 0:0:0:0: [sda] Write Protect is off
[    1.772025] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.772049] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.774714] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.774720] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.774896] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.836272]  sda: sda1 sda2 sda3 < sda5 >
[    1.836951] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.839130] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.839304] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.060799] tsc: Refined TSC clocksource calibration: 2294.254 MHz
[    2.243678] device-mapper: uevent: version 1.0.3
[    2.243750] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    2.348947] bio: create slab <bio-1> at 1
[    2.629501] PM: Starting manual resume from disk
[    2.629507] PM: Hibernation image partition 254:1 present
[    2.629509] PM: Looking for hibernation image.
[    2.639228] PM: Image not found (code -22)
[    2.639232] PM: Hibernation image not present or could not be loaded.
[    2.662957] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    3.060128] Switched to clocksource tsc
[    4.059917] udevd[375]: starting version 175
[    4.861125] ACPI: AC Adapter [ADP0] (on-line)
[    4.861748] ACPI: processor limited to max C-state 1
[    4.868631] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.868998] acpi-cpufreq: overriding BIOS provided _PSD data
[    4.877991] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    4.878049] sp5100_tco: PCI Revision ID: 0x42
[    4.878122] sp5100_tco: Using 0xfed80b00 for watchdog MMIO address
[    4.878135] sp5100_tco: Last reboot was not triggered by watchdog.
[    4.878187] sp5100_tco: initialized (0xffffc9000037ab00). heartbeat=60 sec (nowayout=0)
[    4.886280] microcode: CPU0: patch_level=0x010000b6
[    4.891107] ACPI: Battery Slot [BAT0] (battery present)
[    4.891378] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    4.891393] ACPI: Power Button [PWRB]
[    4.891573] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    4.893488] ACPI: Lid Switch [LID]
[    4.894026] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.894037] ACPI: Power Button [PWRF]
[    4.912777] acpi device:03: registered as cooling_device3
[    4.912801] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    4.912865] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input4
[    4.973755] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    4.976931] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    4.979706] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.987328] wmi: Mapper loaded
[    5.031810] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[    5.032469] input: Toshiba input device as /devices/virtual/input/input6
[    5.038401] microcode: failed to load file amd-ucode/microcode_amd.bin
[    5.038964] microcode: CPU1: patch_level=0x010000b6
[    5.039070] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.065700] [drm] Initialized drm 1.1.0 20060810
[    5.087178] ohci-pci: OHCI PCI platform driver
[    5.087421] ohci-pci 0000:00:12.0: setting latency timer to 64
[    5.087428] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    5.087442] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 4
[    5.087487] ohci-pci 0000:00:12.0: irq 18, io mem 0x92306000
[    5.146595] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.146607] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.146615] usb usb4: Product: OHCI PCI host controller
[    5.146621] usb usb4: Manufacturer: Linux 3.11.0-rc4+ ohci_hcd
[    5.146627] usb usb4: SerialNumber: 0000:00:12.0
[    5.147948] hub 4-0:1.0: USB hub found
[    5.147964] hub 4-0:1.0: 5 ports detected
[    5.148903] ohci-pci 0000:00:13.0: setting latency timer to 64
[    5.148912] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    5.148928] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[    5.148970] ohci-pci 0000:00:13.0: irq 18, io mem 0x92305000
[    5.163104] cfg80211: Calling CRDA to update world regulatory domain
[    5.206521] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.206534] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.206542] usb usb5: Product: OHCI PCI host controller
[    5.206549] usb usb5: Manufacturer: Linux 3.11.0-rc4+ ohci_hcd
[    5.206554] usb usb5: SerialNumber: 0000:00:13.0
[    5.206947] hub 5-0:1.0: USB hub found
[    5.207001] hub 5-0:1.0: 5 ports detected
[    5.208062] ohci-pci 0000:00:16.0: setting latency timer to 64
[    5.208072] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    5.208090] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 6
[    5.208142] ohci-pci 0000:00:16.0: irq 18, io mem 0x92304000
[    5.266524] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.266536] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.266544] usb usb6: Product: OHCI PCI host controller
[    5.266550] usb usb6: Manufacturer: Linux 3.11.0-rc4+ ohci_hcd
[    5.266555] usb usb6: SerialNumber: 0000:00:16.0
[    5.267006] hub 6-0:1.0: USB hub found
[    5.267032] hub 6-0:1.0: 4 ports detected
[    5.292584] [drm] radeon kernel modesetting enabled.
[    5.293455] [drm] initializing kernel modesetting (RS880 0x1002:0x9712 0x1179:0xFDE4).
[    5.293498] [drm] register mmio base: 0x92200000
[    5.293503] [drm] register mmio size: 65536
[    5.301098] ATOM BIOS: Tos_Berlin10AD
[    5.301149] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x00000000CFFFFFFF (256M used)
[    5.301157] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    5.301166] [drm] Detected VRAM RAM=256M, BAR=256M
[    5.301170] [drm] RAM width 32bits DDR
[    5.301299] [TTM] Zone  kernel: Available graphics memory: 898020 kiB
[    5.301300] [TTM] Initializing pool allocator
[    5.301306] [TTM] Initializing DMA pool allocator
[    5.301333] [drm] radeon: 256M of VRAM memory ready
[    5.301335] [drm] radeon: 512M of GTT memory ready.
[    5.301347] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.320736] [drm] Loading RS780 Microcode
[    5.338145] r600_cp: Failed to load firmware "radeon/RS780_pfp.bin"
[    5.338278] [drm:r600_startup] *ERROR* Failed to load firmware!
[    5.338331] radeon 0000:01:05.0: disabling GPU acceleration
[    5.339702] radeon 0000:01:05.0: ffff880069da9400 unpin not necessary
[    5.340300] [drm] radeon atom DIG backlight initialized
[    5.340305] [drm] Radeon Display Connectors
[    5.340309] [drm] Connector 0:
[    5.340313] [drm]   VGA-1
[    5.340319] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    5.340322] [drm]   Encoders:
[    5.340326] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.340329] [drm] Connector 1:
[    5.340333] [drm]   LVDS-1
[    5.340339] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    5.340342] [drm]   Encoders:
[    5.340346] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    5.340377] [drm] radeon: power management initialized
[    5.733892] ath: phy0: ASPM enabled: 0x42
[    5.733903] ath: EEPROM regdomain: 0x65
[    5.733908] ath: EEPROM indicates we should expect a direct regpair map
[    5.733916] ath: Country alpha2 being used: 00
[    5.733920] ath: Regpair used: 0x65
[    5.772820] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    5.773419] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc900013e0000, irq=16
[    5.778400] kvm: Nested Virtualization enabled
[    5.778416] kvm: Nested Paging enabled
[    5.803078] snd_hda_intel 0000:00:14.2: setting latency timer to 64
[    5.864026] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input7
[    6.251148] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 582762
[    6.251169] psmouse serio1: synaptics: Toshiba Satellite C650D detected, limiting rate to 40pps.
[    6.335430] [drm] fb mappable at 0x80040000
[    6.335439] [drm] vram apper at 0x80000000
[    6.335443] [drm] size 4325376
[    6.335447] [drm] fb depth is 24
[    6.335451] [drm]    pitch is 5632
[    6.335683] fbcon: radeondrmfb (fb0) is primary device
[    6.355680] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
[    6.410984] Console: switching to colour frame buffer device 170x48
[    6.424157] radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
[    6.424164] radeon 0000:01:05.0: registered panic notifier
[    6.424482] [drm] Initialized radeon 2.34.0 20080528 for 0000:01:05.0 on minor 0
[    8.014260] EXT4-fs (dm-0): re-mounted. Opts: (null)
[    8.139624] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[    8.715272] Adding 4882428k swap on /dev/mapper/data-swap.  Priority:-1 extents:1 across:4882428k 
[    9.295763] fuse init (API version 7.22)
[    9.333131] loop: module loaded
[    9.435146] kjournald starting.  Commit interval 5 seconds
[    9.435688] EXT3-fs (sda1): using internal journal
[    9.435701] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    9.483220] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[    9.517596] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    9.557272] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
[   14.805373] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input9
[   24.300277] lp: driver loaded but no devices found
[   24.307971] ppdev: user-space parallel port driver

--cvVnyQ+4j833TQvp--
