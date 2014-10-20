Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaJTOQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:16:40 -0400
Received: from n26.netmark.pl ([94.124.9.61]:53433 "EHLO n26.netmark.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaJTOQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:16:38 -0400
Date: Mon, 20 Oct 2014 14:52:01 +0200
From: Marcin Szewczyk <Marcin.Szewczyk@wodny.org>
To: linux-kernel@vger.kernel.org
Subject: Radeon HD 6290 screen goes black at KMS
Message-ID: <20141020125159.GC10042@orkisz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - n26.netmark.pl
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - wodny.org
X-Get-Message-Sender-Via: n26.netmark.pl: authenticated_id: wodny/from_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

I have a DFI OT951-D board and sometimes the screen connected to the
DisplayPort-0 (LVDS) goes black at the moment of radeon's Kernel Mode
Setting. Sometimes I am able to turn it on again after X11 starts using
two commands (referenced as xrandr workaround below):

  xrandr --output DisplayPort-0 --off
  xrandr --output DisplayPort-0 --mode 1920x1080

The workaround helps sometimes with radeon but makes it worse with
fglrx.

Fglrx fails sometimes at early boot but mostly after xrandr.

The adapter as described by lspci:

  00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Wrestler [Radeon HD 6290]

Even when the screen remains black xrandr reports the screen as turned
on.

Some statistics. 120 samples. Numbers below mean the number of times the
screen remained black after the system finished booting:

  Debian with 3.2.54 kernel with X11
    radeon w/  workaround   |  5
    radeon w/o workaround   | 40
    fglrx  w/  workaround   | 25
    fglrx  w/o workaround   | 10

  Arch with 3.16.3 kernel without X11
    radeon w/o workaround   | 35

I attach dmesg output (with drm.debug=0xe) from one successful boot and
a unsuccessful one (both without the workaround). Unfortunately I do not
see much of a difference between them.

Please, help.

-- 
Marcin Szewczyk                       http://wodny.org
mailto:Marcin.Szewczyk@wodny.borg  <- remove b / usuń b
xmpp:wodny@ubuntu.pl                  xmpp:wodny@jabster.pl

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bad1

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-4-686-pae (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.54-2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000066786000 (usable)
[    0.000000]  BIOS-e820: 0000000066786000 - 0000000066888000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000066888000 - 0000000066891000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000066891000 - 00000000668e8000 (reserved)
[    0.000000]  BIOS-e820: 00000000668e8000 - 00000000668f6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000668f6000 - 000000006694f000 (reserved)
[    0.000000]  BIOS-e820: 000000006694f000 - 0000000066956000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000066956000 - 0000000066d58000 (usable)
[    0.000000]  BIOS-e820: 0000000066d58000 - 0000000066ef4000 (reserved)
[    0.000000]  BIOS-e820: 0000000066ef4000 - 0000000066f00000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed61000 - 00000000fed71000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fef00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./OT951, BIOS 4.6.5 06/14/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x66f00 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 066F00000 mask FFFF00000 uncachable
[    0.000000]   2 base 067000000 mask FFF000000 uncachable
[    0.000000]   3 base 068000000 mask FF8000000 uncachable
[    0.000000]   4 base 070000000 mask FF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00fce00] fce00
[    0.000000] initial memory mapped : 0 - 01a00000
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 19f9000-1a00000
[    0.000000] RAMDISK: 65dc2000 - 66785000
[    0.000000] Allocated new RAMDISK: 3703b000 - 379fda40
[    0.000000] Move RAMDISK from 0000000065dc2000 - 0000000066784a3f to 3703b000 - 379fda3f
[    0.000000] ACPI: RSDP 000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 66888068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 6688ecd8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20110623/tbfadt-560)
[    0.000000] ACPI: DSDT 66888150 06B86 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 668f4f80 00040
[    0.000000] ACPI: APIC 6688edd0 00062 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 6688ee38 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 6688ee78 00038 (v01 ALASKA    A M I 01072009 AMI  00000005)
[    0.000000] ACPI: SSDT 6688eeb0 0030C (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 6688f1c0 0168E (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 757MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x00066f00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x00066786
[    0.000000]     0: 0x00066956 -> 0x00066d58
[    0.000000]     0: 0x00066ef4 -> 0x00066f00
[    0.000000] On node 0 totalpages: 420642
[    0.000000] free_area_init_node: node 0, pgdat c1412740, node_mem_map f635a200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1515 pages used for memmap
[    0.000000]   HighMem zone: 191403 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 66f00000 (gap: 66f00000:97d00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f6335000 s33280 r0 d24064 u57344
[    0.000000] pcpu-alloc: s33280 r0 d24064 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 417347
[    0.000000] Kernel command line: initrd=/boot/initrd.img-3.2.0-4-686-pae root=UUID=bdb66d7d-99bf-4833-8436-2b8ed6efd7d1 ro BOOT_IMAGE=/boot/vmlinuz-3.2.0-4-686-pae 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000379fe:00066f00)
[    0.000000] Memory: 1653204k/1686528k available (2855k kernel code, 29364k reserved, 1344k data, 420k init, 771672k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc141b000 - 0xc1484000   ( 420 kB)
[    0.000000]       .data : 0xc12c9ec0 - 0xc141a100   (1344 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12c9ec0   (2855 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5c06000 soft=f5c08000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 999.971 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 1999.94 BogoMIPS (lpj=3999884)
[    0.004146] pid_max: default: 32768 minimum: 301
[    0.004356] Security Framework initialized
[    0.004417] AppArmor: AppArmor disabled by boot time parameter
[    0.004504] Mount-cache hash table entries: 512
[    0.004782] Initializing cgroup subsys cpuacct
[    0.004847] Initializing cgroup subsys memory
[    0.008020] Initializing cgroup subsys devices
[    0.008078] Initializing cgroup subsys freezer
[    0.008134] Initializing cgroup subsys net_cls
[    0.008190] Initializing cgroup subsys blkio
[    0.008255] Initializing cgroup subsys perf_event
[    0.008363] CPU: Physical Processor ID: 0
[    0.008418] CPU: Processor Core ID: 0
[    0.008475] mce: CPU supports 6 MCE banks
[    0.009412] ACPI: Core revision 20110623
[    0.020137] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020596] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.063108] CPU0: AMD G-T40N Processor stepping 00
[    0.064003] Performance Events: AMD PMU driver.
[    0.064003] ... version:                0
[    0.064003] ... bit width:              48
[    0.064003] ... generic registers:      4
[    0.064003] ... value mask:             0000ffffffffffff
[    0.064003] ... max period:             00007fffffffffff
[    0.064003] ... fixed-purpose events:   0
[    0.064003] ... event mask:             000000000000000f
[    0.064003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.064003] CPU 1 irqstacks, hard=f5c94000 soft=f5c96000
[    0.064003] Booting Node   0, Processors  #1 Ok.
[    0.064003] smpboot cpu 1: start_ip = 9a000
[    0.008000] Initializing CPU#1
[    0.156063] NMI watchdog enabled, takes one hw-pmu counter.
[    0.156282] Brought up 2 CPUs
[    0.156344] Total of 2 processors activated (3999.94 BogoMIPS).
[    0.157233] devtmpfs: initialized
[    0.157233] PM: Registering ACPI NVS region at 66786000 (1056768 bytes)
[    0.157233] PM: Registering ACPI NVS region at 668e8000 (57344 bytes)
[    0.157233] PM: Registering ACPI NVS region at 6694f000 (28672 bytes)
[    0.157233] print_constraints: dummy: 
[    0.157233] NET: Registered protocol family 16
[    0.157282] Extended Config Space enabled on 0 nodes
[    0.157389] ACPI: bus type pci registered
[    0.160213] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.160459] PCI: not using MMCONFIG
[    0.180558] PCI: Using configuration type 1 for base access
[    0.180783] PCI: Using configuration type 1 for extended access
[    0.182545] bio: create slab <bio-0> at 0
[    0.182545] ACPI: Added _OSI(Module Device)
[    0.182545] ACPI: Added _OSI(Processor Device)
[    0.182545] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.184030] ACPI: Added _OSI(Processor Aggregator Device)
[    0.186375] ACPI: EC: Look up EC in DSDT
[    0.190966] ACPI: Executed 3 blocks of module-level executable AML code
[    0.209413] ACPI: Interpreter enabled
[    0.209491] ACPI: (supports S0 S3 S4 S5)
[    0.209741] ACPI: Using IOAPIC for interrupt routing
[    0.210106] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.210275] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.210349] PCI: Using MMCONFIG for extended config space
[    0.284460] ACPI: No dock devices found.
[    0.284525] HEST: Table not found.
[    0.284587] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.285085] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.285772] pci_root PNP0A08:00: host bridge window [io  0x0000-0x03af]
[    0.285836] pci_root PNP0A08:00: host bridge window [io  0x03e0-0x0cf7]
[    0.285897] pci_root PNP0A08:00: host bridge window [io  0x03b0-0x03df]
[    0.285958] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.286020] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.286090] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.288025] pci_root PNP0A08:00: host bridge window [mem 0x7f000000-0xffffffff]
[    0.288120] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.288190] pci 0000:00:01.0: [1002:9807] type 0 class 0x000300
[    0.288208] pci 0000:00:01.0: reg 10: [mem 0xa0000000-0xafffffff pref]
[    0.288222] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.288234] pci 0000:00:01.0: reg 18: [mem 0xfeb00000-0xfeb3ffff]
[    0.288306] pci 0000:00:01.0: supports D1 D2
[    0.288341] pci 0000:00:01.1: [1002:1314] type 0 class 0x000403
[    0.288358] pci 0000:00:01.1: reg 10: [mem 0xfeb44000-0xfeb47fff]
[    0.288441] pci 0000:00:01.1: supports D1 D2
[    0.288480] pci 0000:00:04.0: [1022:1512] type 1 class 0x000604
[    0.288569] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.288632] pci 0000:00:11.0: [1002:4390] type 0 class 0x000101
[    0.288662] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
[    0.288678] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
[    0.288695] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
[    0.288711] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
[    0.288727] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
[    0.288744] pci 0000:00:11.0: reg 24: [mem 0xfeb4f000-0xfeb4f3ff]
[    0.288776] pci 0000:00:11.0: set SATA to AHCI mode
[    0.288903] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.288925] pci 0000:00:12.0: reg 10: [mem 0xfeb4e000-0xfeb4efff]
[    0.289034] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.289064] pci 0000:00:12.2: reg 10: [mem 0xfeb4d000-0xfeb4d0ff]
[    0.289183] pci 0000:00:12.2: supports D1 D2
[    0.289188] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.289226] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.289248] pci 0000:00:13.0: reg 10: [mem 0xfeb4c000-0xfeb4cfff]
[    0.289355] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.289385] pci 0000:00:13.2: reg 10: [mem 0xfeb4b000-0xfeb4b0ff]
[    0.289504] pci 0000:00:13.2: supports D1 D2
[    0.289509] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.289546] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.289664] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.289698] pci 0000:00:14.2: reg 10: [mem 0xfeb40000-0xfeb43fff 64bit]
[    0.289794] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.289820] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.289933] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.289998] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.290020] pci 0000:00:14.5: reg 10: [mem 0xfeb4a000-0xfeb4afff]
[    0.290129] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.290246] pci 0000:00:15.0: supports D1 D2
[    0.290288] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.290406] pci 0000:00:15.1: supports D1 D2
[    0.290449] pci 0000:00:15.2: [1002:43a2] type 1 class 0x000604
[    0.290566] pci 0000:00:15.2: supports D1 D2
[    0.290608] pci 0000:00:15.3: [1002:43a3] type 1 class 0x000604
[    0.290726] pci 0000:00:15.3: supports D1 D2
[    0.292031] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.292054] pci 0000:00:16.0: reg 10: [mem 0xfeb49000-0xfeb49fff]
[    0.292161] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.292191] pci 0000:00:16.2: reg 10: [mem 0xfeb48000-0xfeb480ff]
[    0.292310] pci 0000:00:16.2: supports D1 D2
[    0.292315] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.292357] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.292415] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.292468] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.292522] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.292591] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.292643] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.292695] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.292747] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.292863] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.293016] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.293089] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.293096] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.293103] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.293109] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.293116] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.293123] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.293129] pci 0000:00:14.4:   bridge window [mem 0x7f000000-0xffffffff] (subtractive decode)
[    0.293208] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.293555] pci 0000:04:00.0: [197b:2368] type 0 class 0x000101
[    0.293600] pci 0000:04:00.0: reg 10: [io  0xe040-0xe047]
[    0.293622] pci 0000:04:00.0: reg 14: [io  0xe030-0xe033]
[    0.293644] pci 0000:04:00.0: reg 18: [io  0xe020-0xe027]
[    0.293666] pci 0000:04:00.0: reg 1c: [io  0xe010-0xe013]
[    0.293687] pci 0000:04:00.0: reg 20: [io  0xe000-0xe00f]
[    0.293818] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.294166] pci 0000:00:15.1: PCI bridge to [bus 04-06]
[    0.294396] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.294404] pci 0000:00:15.1:   bridge window [mem 0xfe100000-0xfeafffff]
[    0.294417] pci 0000:00:15.1:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.294521] pci 0000:07:00.0: [10ec:8168] type 0 class 0x000200
[    0.294548] pci 0000:07:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.294591] pci 0000:07:00.0: reg 18: [mem 0xd0104000-0xd0104fff 64bit pref]
[    0.294620] pci 0000:07:00.0: reg 20: [mem 0xd0100000-0xd0103fff 64bit pref]
[    0.294641] pci 0000:07:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.294736] pci 0000:07:00.0: supports D1 D2
[    0.294741] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.300100] pci 0000:00:15.2: PCI bridge to [bus 07-07]
[    0.300177] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.300193] pci 0000:00:15.2:   bridge window [mem 0xd0100000-0xd01fffff 64bit pref]
[    0.300321] pci 0000:08:00.0: [10ec:8168] type 0 class 0x000200
[    0.300353] pci 0000:08:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.300397] pci 0000:08:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.300426] pci 0000:08:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.300447] pci 0000:08:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.300550] pci 0000:08:00.0: supports D1 D2
[    0.300555] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.308100] pci 0000:00:15.3: PCI bridge to [bus 08-08]
[    0.308273] pci 0000:00:15.3:   bridge window [io  0xc000-0xcfff]
[    0.308289] pci 0000:00:15.3:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.308338] pci_bus 0000:00: on NUMA node 0
[    0.308355] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.308805] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.308883] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.308975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.309049] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE22._PRT]
[    0.309123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE23._PRT]
[    0.309191]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.309255]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.309326] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.325612] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.326156] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.326698] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.327237] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 14 15) *0
[    0.327750] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.328731] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.329218] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.329706] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.330437] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.330437] vgaarb: loaded
[    0.330437] vgaarb: bridge control possible 0000:00:01.0
[    0.330437] PCI: Using ACPI for IRQ routing
[    0.342533] PCI: pci_cache_line_size set to 64 bytes
[    0.342766] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.342773] reserve RAM buffer: 0000000066786000 - 0000000067ffffff 
[    0.342779] reserve RAM buffer: 0000000066d58000 - 0000000067ffffff 
[    0.342785] reserve RAM buffer: 0000000066f00000 - 0000000067ffffff 
[    0.343033] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.343773] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.345060] Switching to clocksource hpet
[    0.347181] pnp: PnP ACPI init
[    0.347293] ACPI: bus type pnp registered
[    0.347790] pnp 00:00: [bus 00-ff]
[    0.347797] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.347803] pnp 00:00: [io  0x0000-0x03af window]
[    0.347809] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    0.347815] pnp 00:00: [io  0x03b0-0x03df window]
[    0.347820] pnp 00:00: [io  0x0d00-0xffff window]
[    0.347827] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.347832] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.347838] pnp 00:00: [mem 0x7f000000-0xffffffff window]
[    0.347844] pnp 00:00: [mem 0x00000000 window]
[    0.347989] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.348108] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.348239] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.348305] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.348943] pnp 00:02: [io  0x040b]
[    0.348951] pnp 00:02: [io  0x04d6]
[    0.348958] pnp 00:02: [io  0x0c00-0x0c01]
[    0.348963] pnp 00:02: [io  0x0c14]
[    0.348967] pnp 00:02: [io  0x0c50-0x0c51]
[    0.348972] pnp 00:02: [io  0x0c52]
[    0.348976] pnp 00:02: [io  0x0c6c]
[    0.348981] pnp 00:02: [io  0x0c6f]
[    0.348985] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.348990] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.348995] pnp 00:02: [io  0x0cd4-0x0cd5]
[    0.348999] pnp 00:02: [io  0x0cd6-0x0cd7]
[    0.349004] pnp 00:02: [io  0x0cd8-0x0cdf]
[    0.349009] pnp 00:02: [io  0x0800-0x089f]
[    0.349014] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.349020] pnp 00:02: [io  0x0000-0x000f]
[    0.349024] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.349029] pnp 00:02: [io  0x0900-0x090f]
[    0.349034] pnp 00:02: [io  0x0910-0x091f]
[    0.349039] pnp 00:02: [io  0xfe00-0xfefe]
[    0.349044] pnp 00:02: [io  0x0060-0x005f disabled]
[    0.349049] pnp 00:02: [io  0x0064-0x0063 disabled]
[    0.349054] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.349059] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.349065] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
[    0.349070] pnp 00:02: [mem 0xfed61000-0xfed70fff]
[    0.349078] pnp 00:02: [mem 0xfec10000-0xfec10fff]
[    0.349084] pnp 00:02: [mem 0xfed00000-0xfed00fff]
[    0.349089] pnp 00:02: [mem 0xffc00000-0xffffffff]
[    0.349259] system 00:02: [io  0x040b] has been reserved
[    0.349321] system 00:02: [io  0x04d6] has been reserved
[    0.349381] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.349441] system 00:02: [io  0x0c14] has been reserved
[    0.349501] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.349561] system 00:02: [io  0x0c52] has been reserved
[    0.349620] system 00:02: [io  0x0c6c] has been reserved
[    0.349679] system 00:02: [io  0x0c6f] has been reserved
[    0.349739] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.349799] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.349871] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.349932] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.349992] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.350053] system 00:02: [io  0x0800-0x089f] has been reserved
[    0.350113] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.350174] system 00:02: [io  0x0900-0x090f] has been reserved
[    0.350234] system 00:02: [io  0x0910-0x091f] has been reserved
[    0.350359] system 00:02: [io  0xfe00-0xfefe] has been reserved
[    0.350569] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.350816] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.351005] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.351176] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.351238] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.351300] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.351363] system 00:02: [mem 0xffc00000-0xffffffff] has been reserved
[    0.351426] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.351578] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
[    0.351584] pnp 00:03: [io  0x0405-0x0414]
[    0.351687] system 00:03: [io  0x0405-0x0414] could not be reserved
[    0.351750] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.352138] pnp 00:04: [io  0x03f8-0x03ff]
[    0.352161] pnp 00:04: [irq 4]
[    0.352166] pnp 00:04: [dma 0 disabled]
[    0.352325] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.352949] pnp 00:05: [io  0x02f8-0x02ff]
[    0.352960] pnp 00:05: [irq 3]
[    0.352965] pnp 00:05: [dma 0 disabled]
[    0.353094] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.353123] pnp 00:06: [dma 4]
[    0.353128] pnp 00:06: [io  0x0000-0x000f]
[    0.353134] pnp 00:06: [io  0x0081-0x0083]
[    0.353138] pnp 00:06: [io  0x0087]
[    0.353143] pnp 00:06: [io  0x0089-0x008b]
[    0.353148] pnp 00:06: [io  0x008f]
[    0.353152] pnp 00:06: [io  0x00c0-0x00df]
[    0.353212] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.353239] pnp 00:07: [io  0x0070-0x0071]
[    0.353250] pnp 00:07: [irq 8]
[    0.353308] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.353329] pnp 00:08: [io  0x0061]
[    0.353392] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.353451] pnp 00:09: [io  0x0010-0x001f]
[    0.353457] pnp 00:09: [io  0x0022-0x003f]
[    0.353462] pnp 00:09: [io  0x0044-0x005f]
[    0.353467] pnp 00:09: [io  0x0062-0x0063]
[    0.353471] pnp 00:09: [io  0x0065-0x006f]
[    0.353476] pnp 00:09: [io  0x0072-0x007f]
[    0.353481] pnp 00:09: [io  0x0080]
[    0.353485] pnp 00:09: [io  0x0084-0x0086]
[    0.353490] pnp 00:09: [io  0x0088]
[    0.353494] pnp 00:09: [io  0x008c-0x008e]
[    0.353499] pnp 00:09: [io  0x0090-0x009f]
[    0.353503] pnp 00:09: [io  0x00a2-0x00bf]
[    0.353508] pnp 00:09: [io  0x00e0-0x00ef]
[    0.353513] pnp 00:09: [io  0x04d0-0x04d1]
[    0.353653] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.353725] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.353755] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.353769] pnp 00:0a: [irq 13]
[    0.353848] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.354001] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.354501] pnp 00:0c: [mem 0x67000000-0x7effffff]
[    0.354641] system 00:0c: [mem 0x67000000-0x7effffff] could not be reserved
[    0.354706] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355061] pnp 00:0d: [mem 0xfed00000-0xfed003ff]
[    0.355197] pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.355212] pnp: PnP ACPI: found 14 devices
[    0.355331] ACPI: ACPI bus type pnp unregistered
[    0.355494] PnPBIOS: Disabled by ACPI PNP
[    0.399102] pci 0000:07:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.399198] pci 0000:08:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.399282] PCI: max bus depth: 1 pci_try_num: 2
[    0.399375] pci 0000:00:15.2: BAR 14: assigned [mem 0x7f000000-0x7f0fffff]
[    0.399484] pci 0000:00:15.3: BAR 14: assigned [mem 0x7f100000-0x7f1fffff]
[    0.399551] pci 0000:00:15.3: BAR 14: reassigned [mem 0x7f100000-0x7f5fffff]
[    0.399616] pci 0000:00:04.0: BAR 14: assigned [mem 0x7f600000-0x7f7fffff]
[    0.399681] pci 0000:00:04.0: BAR 15: assigned [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.399769] pci 0000:00:04.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.399838] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.399904] pci 0000:00:04.0:   bridge window [io  0x1000-0x1fff]
[    0.399974] pci 0000:00:04.0:   bridge window [mem 0x7f600000-0x7f7fffff]
[    0.400061] pci 0000:00:04.0:   bridge window [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.400148] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.400228] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.400308] pci 0000:00:15.1: PCI bridge to [bus 04-06]
[    0.400374] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.400445] pci 0000:00:15.1:   bridge window [mem 0xfe100000-0xfeafffff]
[    0.400515] pci 0000:00:15.1:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.400605] pci 0000:07:00.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff pref]
[    0.400684] pci 0000:00:15.2: PCI bridge to [bus 07-07]
[    0.400750] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.400820] pci 0000:00:15.2:   bridge window [mem 0x7f000000-0x7f0fffff]
[    0.400892] pci 0000:00:15.2:   bridge window [mem 0xd0100000-0xd01fffff 64bit pref]
[    0.400980] pci 0000:08:00.0: BAR 6: assigned [mem 0xd0020000-0xd003ffff pref]
[    0.401058] pci 0000:00:15.3: PCI bridge to [bus 08-08]
[    0.401124] pci 0000:00:15.3:   bridge window [io  0xc000-0xcfff]
[    0.401194] pci 0000:00:15.3:   bridge window [mem 0x7f100000-0x7f5fffff]
[    0.401265] pci 0000:00:15.3:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.401395] pci 0000:00:04.0: setting latency timer to 64
[    0.401421] pci 0000:00:15.0: setting latency timer to 64
[    0.401438] pci 0000:00:15.1: setting latency timer to 64
[    0.401455] pci 0000:00:15.2: setting latency timer to 64
[    0.401472] pci 0000:00:15.3: setting latency timer to 64
[    0.401482] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.401490] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.401498] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.401505] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.401513] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.401520] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.401528] pci_bus 0000:00: resource 10 [mem 0x7f000000-0xffffffff]
[    0.401536] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.401543] pci_bus 0000:01: resource 1 [mem 0x7f600000-0x7f7fffff]
[    0.401551] pci_bus 0000:01: resource 2 [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.401560] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.401568] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.401575] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.401582] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.401590] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.401597] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.401605] pci_bus 0000:02: resource 10 [mem 0x7f000000-0xffffffff]
[    0.401613] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.401620] pci_bus 0000:04: resource 1 [mem 0xfe100000-0xfeafffff]
[    0.401628] pci_bus 0000:04: resource 2 [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.401636] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.401644] pci_bus 0000:07: resource 1 [mem 0x7f000000-0x7f0fffff]
[    0.401652] pci_bus 0000:07: resource 2 [mem 0xd0100000-0xd01fffff 64bit pref]
[    0.401660] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.401667] pci_bus 0000:08: resource 1 [mem 0x7f100000-0x7f5fffff]
[    0.401675] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.401862] NET: Registered protocol family 2
[    0.402168] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.402895] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.403840] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.404398] TCP: Hash tables configured (established 131072 bind 65536)
[    0.404471] TCP reno registered
[    0.404539] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.404622] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.405028] NET: Registered protocol family 1
[    0.405130] pci 0000:00:01.0: Boot video device
[    0.696367] PCI: CLS 64 bytes, default 64
[    0.696503] Unpacking initramfs...
[    1.285984] Freeing initrd memory: 9996k freed
[    1.294227] perf: AMD IBS detected (0x000000ff)
[    1.294981] audit: initializing netlink socket (disabled)
[    1.295069] type=2000 audit(1413510396.288:1): initialized
[    1.325790] highmem bounce pool size: 64 pages
[    1.325862] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.327181] VFS: Disk quotas dquot_6.5.2
[    1.327328] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.327531] msgmni has been set to 1741
[    1.328160] alg: No test for stdrng (krng)
[    1.328344] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.328436] io scheduler noop registered
[    1.328497] io scheduler deadline registered
[    1.328594] io scheduler cfq registered (default)
[    1.329335] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.329458] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.329526] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.330669] ERST: Table is not found!
[    1.330733] GHES: HEST is not enabled!
[    1.330826] isapnp: Scanning for PnP cards...
[    1.685559] isapnp: No Plug & Play device found
[    1.685970] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.707308] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.728197] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.753109] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.774415] 00:05: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.780965] Linux agpgart interface v0.103
[    1.781507] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.784652] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.784738] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.785548] mousedev: PS/2 mouse device common for all mice
[    1.785747] rtc_cmos 00:07: RTC can wake from S4
[    1.786206] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.786316] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.786405] cpuidle: using governor ladder
[    1.786462] cpuidle: using governor menu
[    1.787138] TCP cubic registered
[    1.787375] NET: Registered protocol family 10
[    1.788913] Mobile IPv6
[    1.788975] NET: Registered protocol family 17
[    1.789045] Registering the dns_resolver key type
[    1.789170] Using IPI No-Shortcut mode
[    1.789967] PM: Hibernation image not present or could not be loaded.
[    1.790010] registered taskstats version 1
[    1.791127] rtc_cmos 00:07: setting system clock to 2014-10-17 01:46:37 UTC (1413510397)
[    1.791383] Initializing network drop monitor service
[    1.791728] Freeing unused kernel memory: 420k freed
[    1.792342] Write protecting the kernel text: 2856k
[    1.792502] Write protecting the kernel read-only data: 1084k
[    1.792567] NX-protecting the kernel data: 3288k
[    1.826058] udevd[49]: starting version 175
[    1.926883] usbcore: registered new interface driver usbfs
[    1.927020] usbcore: registered new interface driver hub
[    1.942964] SCSI subsystem initialized
[    1.960141] usbcore: registered new device driver usb
[    1.960880] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.961043] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.961173] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.961267] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.961393] QUIRK: Enable AMD PLL fix
[    1.961418] ehci_hcd 0000:00:12.2: debug port 1
[    1.961533] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfeb4d000
[    1.972121] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.972273] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.975511] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.975590] usb usb1: Product: EHCI Host Controller
[    1.975654] usb usb1: Manufacturer: Linux 3.2.0-4-686-pae ehci_hcd
[    1.975719] usb usb1: SerialNumber: 0000:00:12.2
[    1.976193] hub 1-0:1.0: USB hub found
[    1.976264] hub 1-0:1.0: 5 ports detected
[    1.976605] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.976710] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.976801] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.976927] ehci_hcd 0000:00:13.2: debug port 1
[    1.977018] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfeb4b000
[    1.981669] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.987640] libata version 3.00 loaded.
[    1.989815] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.989947] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.990017] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.990095] usb usb2: Product: EHCI Host Controller
[    1.990158] usb usb2: Manufacturer: Linux 3.2.0-4-686-pae ehci_hcd
[    1.990224] usb usb2: SerialNumber: 0000:00:13.2
[    1.990644] hub 2-0:1.0: USB hub found
[    1.990715] hub 2-0:1.0: 5 ports detected
[    1.991098] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.991186] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    1.991326] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfeb4e000
[    1.992307] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.993259] r8169 0000:07:00.0: setting latency timer to 64
[    1.993362] r8169 0000:07:00.0: irq 40 for MSI/MSI-X
[    1.994659] r8169 0000:07:00.0: eth0: RTL8168d/8111d at 0xf8270000, 00:01:29:51:5c:16, XID 081000c0 IRQ 40
[    1.994750] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.994883] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.995030] r8169 0000:08:00.0: setting latency timer to 64
[    1.995115] r8169 0000:08:00.0: irq 41 for MSI/MSI-X
[    1.998493] r8169 0000:08:00.0: eth1: RTL8168d/8111d at 0xf8278000, 00:01:29:51:5c:17, XID 081000c0 IRQ 41
[    1.998597] r8169 0000:08:00.0: eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.001207] pata_jmicron 0000:04:00.0: setting latency timer to 64
[    2.013117] scsi0 : pata_jmicron
[    2.028693] scsi1 : pata_jmicron
[    2.028961] ata1: PATA max UDMA/100 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 17
[    2.029033] ata2: PATA max UDMA/100 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 17
[    2.048174] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.048254] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.048334] usb usb3: Product: OHCI Host Controller
[    2.048397] usb usb3: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.048463] usb usb3: SerialNumber: 0000:00:12.0
[    2.048889] hub 3-0:1.0: USB hub found
[    2.048963] hub 3-0:1.0: 5 ports detected
[    2.049238] ahci 0000:00:11.0: version 3.0
[    2.049473] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    2.049559] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    2.063269] scsi2 : ahci
[    2.067521] scsi3 : ahci
[    2.074073] scsi4 : ahci
[    2.074423] scsi5 : ahci
[    2.075277] ata3: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f100 irq 19
[    2.075360] ata4: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f180 irq 19
[    2.075442] ata5: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f200 irq 19
[    2.075526] ata6: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f280 irq 19
[    2.075966] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    2.076135] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 4
[    2.076231] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.076366] ehci_hcd 0000:00:16.2: debug port 1
[    2.076458] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfeb48000
[    2.088272] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.088411] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    2.088481] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.088560] usb usb4: Product: EHCI Host Controller
[    2.088625] usb usb4: Manufacturer: Linux 3.2.0-4-686-pae ehci_hcd
[    2.088691] usb usb4: SerialNumber: 0000:00:16.2
[    2.089102] hub 4-0:1.0: USB hub found
[    2.089173] hub 4-0:1.0: 4 ports detected
[    2.089565] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.089651] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.089770] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeb4c000
[    2.148206] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.148285] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.148364] usb usb5: Product: OHCI Host Controller
[    2.148427] usb usb5: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.148493] usb usb5: SerialNumber: 0000:00:13.0
[    2.149524] hub 5-0:1.0: USB hub found
[    2.149600] hub 5-0:1.0: 5 ports detected
[    2.149928] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.150014] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    2.150134] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfeb4a000
[    2.208335] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.208444] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.208522] usb usb6: Product: OHCI Host Controller
[    2.208585] usb usb6: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.208650] usb usb6: SerialNumber: 0000:00:14.5
[    2.209476] ata1.00: CFA: ATP COMPACT FLASH, 20130426, max UDMA/66
[    2.209562] ata1.00: 3931200 sectors, multi 0: LBA48 
[    2.209651] hub 6-0:1.0: USB hub found
[    2.209734] hub 6-0:1.0: 2 ports detected
[    2.211115] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.211207] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.211931] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfeb49000
[    2.216933] ata1.00: configured for UDMA/66
[    2.217518] scsi 0:0:0:0: Direct-Access     ATA      ATP COMPACT FLAS 2013 PQ: 0 ANSI: 5
[    2.272318] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.272390] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.272460] usb usb7: Product: OHCI Host Controller
[    2.272518] usb usb7: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.272577] usb usb7: SerialNumber: 0000:00:16.0
[    2.273161] hub 7-0:1.0: USB hub found
[    2.273434] hub 7-0:1.0: 4 ports detected
[    2.292284] Refined TSC clocksource calibration: 999.999 MHz.
[    2.292451] Switching to clocksource tsc
[    2.396343] ata3: SATA link down (SStatus 0 SControl 300)
[    2.400265] ata4: SATA link down (SStatus 0 SControl 300)
[    2.408276] ata5: SATA link down (SStatus 0 SControl 300)
[    2.424277] ata6: SATA link down (SStatus 0 SControl 300)
[    2.440181] sd 0:0:0:0: [sda] 3931200 512-byte logical blocks: (2.01 GB/1.87 GiB)
[    2.440438] sd 0:0:0:0: [sda] Write Protect is off
[    2.440507] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.440582] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.442067]  sda: sda1 sda2
[    2.443139] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.496136] usb 3-2: new low-speed USB device number 2 using ohci_hcd
[    2.661239] usb 3-2: New USB device found, idVendor=01f3, idProduct=52c0
[    2.661314] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.678714] input: HID 01f3:52c0 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input0
[    2.679183] generic-usb 0003:01F3:52C0.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 01f3:52c0] on usb-0000:00:12.0-2/input0
[    2.693499] input: HID 01f3:52c0 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input1
[    2.695286] generic-usb 0003:01F3:52C0.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [HID 01f3:52c0] on usb-0000:00:12.0-2/input1
[    2.695410] usbcore: registered new interface driver usbhid
[    2.695469] usbhid: USB HID core driver
[    2.842257] aufs: module is from the staging directory, the quality is unknown, you have been warned.
[    2.845435] aufs 3.2.x-debian
[    2.850752] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.939887] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.756989] udevd[338]: starting version 175
[    3.988206] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    3.988304] ACPI: Power Button [PWRB]
[    3.988571] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.988654] ACPI: Power Button [PWRF]
[    3.991085] ACPI: acpi_idle registered with cpuidle
[    4.015598] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.063164] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    4.063396] SP5100 TCO timer: mmio address 0xbafe00 already in use
[    4.187094] [drm] Initialized drm 1.1.0 20060810
[    4.293771] snd_hda_intel 0000:00:01.1: irq 42 for MSI/MSI-X
[    4.293826] snd_hda_intel 0000:00:01.1: setting latency timer to 64
[    4.313841] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    4.343085] powernow-k8: Found 1 AMD G-T40N Processor (2 cpu cores) (version 2.20.00)
[    4.343199] powernow-k8: Core Performance Boosting: on.
[    4.343353] powernow-k8:    0 : pstate 0 (1000 MHz)
[    4.343417] powernow-k8:    1 : pstate 1 (800 MHz)
[    4.379860] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[    4.380326] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input5
[    4.529107] [drm] radeon kernel modesetting enabled.
[    4.530405] hda_codec: ALC886: BIOS auto-probing.
[    4.548263] radeon 0000:00:01.0: setting latency timer to 64
[    4.548290] [drm] initializing kernel modesetting (PALM 0x1002:0x9807 0x1022:0x1511).
[    4.548522] [drm] register mmio base: 0xFEB00000
[    4.548588] [drm] register mmio size: 262144
[    4.549034] ATOM BIOS: AMD
[    4.549152] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[    4.549243] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 - 0x0000000037FFFFFF
[    4.549828] [drm] Detected VRAM RAM=384M, BAR=256M
[    4.549904] [drm] RAM width 32bits DDR
[    4.563993] [TTM] Zone  kernel: Available graphics memory: 445974 kiB
[    4.564111] [TTM] Zone highmem: Available graphics memory: 831810 kiB
[    4.564179] [TTM] Initializing pool allocator
[    4.564252] [TTM] Initializing DMA pool allocator
[    4.564398] [drm] radeon: 384M of VRAM memory ready
[    4.564467] [drm] radeon: 512M of GTT memory ready.
[    4.564572] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    4.566751] [drm] radeon: ib pool ready.
[    4.568318] [drm] Loading PALM Microcode
[    4.685932] platform radeon_cp.0: firmware: agent loaded radeon/PALM_pfp.bin into memory
[    4.732238] platform radeon_cp.0: firmware: agent loaded radeon/PALM_me.bin into memory
[    4.752961] platform radeon_cp.0: firmware: agent loaded radeon/SUMO_rlc.bin into memory
[    4.995663] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    4.996139] radeon 0000:00:01.0: WB enabled
[    4.996215] [drm] fence driver on ring 0 use gpu addr 0x18000c00 and cpu addr 0xffbdfc00
[    4.996310] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.996383] [drm] Driver supports precise vblank timestamp query.
[    4.996537] radeon 0000:00:01.0: irq 43 for MSI/MSI-X
[    4.996552] radeon 0000:00:01.0: radeon: using MSI.
[    4.996687] [drm] radeon: irq initialized.
[    5.013722] [drm] ring test on 0 succeeded in 1 usecs
[    5.014145] [drm] ib test on ring 0 succeeded in 0 usecs
[    5.014225] [drm] Enabling audio support
[    5.014405] HDMI hot plug event: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=0
[    5.014520] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    5.015484] [drm:radeon_dp_i2c_aux_ch], aux_i2c nack
[    5.015970] [drm] Radeon Display Connectors
[    5.016074] [drm] Connector 0:
[    5.016140] [drm]   DisplayPort
[    5.016204] [drm]   HPD2
[    5.016271] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[    5.016357] [drm]   Encoders:
[    5.016422] [drm]     DFP1: INTERNAL_UNIPHY
[    5.016489] [drm] Connector 1:
[    5.016553] [drm]   VGA
[    5.016618] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[    5.016703] [drm]   Encoders:
[    5.016767] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.016901] [drm] Internal thermal controller without fan control
[    5.016982] [drm:radeon_pm_print_states], 5 Power State(s)
[    5.016992] [drm:radeon_pm_print_states], State 0: Default
[    5.017002] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.017011] [drm:radeon_pm_print_states], 		0 e: 275870
[    5.017021] [drm:radeon_pm_print_states], State 1: Battery
[    5.017030] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.017038] [drm:radeon_pm_print_states], 		0 e: 275870
[    5.017047] [drm:radeon_pm_print_states], State 2: Performance
[    5.017057] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.017065] [drm:radeon_pm_print_states], 		0 e: 275870
[    5.017075] [drm:radeon_pm_print_states], State 3: Default
[    5.017084] [drm:radeon_pm_print_states], 	Default
[    5.017091] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.017100] [drm:radeon_pm_print_states], 		0 e: 200000
[    5.017109] [drm:radeon_pm_print_states], State 4: Default
[    5.017118] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.017126] [drm:radeon_pm_print_states], 		0 e: 173920
[    5.017250] [drm] radeon: power management initialized
[    5.017331] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 3, devices 00000008, active_devices 00000000
[    5.017351] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.017450] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[    5.024594] [drm:radeon_dp_getdpcd], DPCD: 
[    5.024608] [drm:radeon_dp_getdpcd], 10 
[    5.024617] [drm:radeon_dp_getdpcd], 0a 
[    5.024625] [drm:radeon_dp_getdpcd], 82 
[    5.024633] [drm:radeon_dp_getdpcd], 40 
[    5.024640] [drm:radeon_dp_getdpcd], 00 
[    5.024647] [drm:radeon_dp_getdpcd], 00 
[    5.024654] [drm:radeon_dp_getdpcd], 01 
[    5.024660] [drm:radeon_dp_getdpcd], 00 
[    5.024667] [drm:radeon_dp_getdpcd], 
[    5.024680] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
[    5.025852] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    5.056479] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    5.056521] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[    5.056532] [drm:drm_mode_debug_printmodeline], Modeline 17:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[    5.056547] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 85 94500 1024 1072 1168 1376 768 769 772 808 0x40 0x5
[    5.056561] [drm:drm_mode_debug_printmodeline], Modeline 18:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[    5.056577] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[    5.068658] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[    5.068683] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[    5.068698] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[    5.068713] [drm:drm_setup_crtcs], 
[    5.068724] [drm:drm_enable_connectors], connector 13 enabled? yes
[    5.068734] [drm:drm_enable_connectors], connector 15 enabled? no
[    5.068744] [drm:drm_target_preferred], looking for cmdline mode on connector 13
[    5.068753] [drm:drm_target_preferred], looking for preferred mode on connector 13
[    5.068764] [drm:drm_target_preferred], found mode 1920x1080
[    5.068772] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    5.068786] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 10
[    5.085158] [drm] fb mappable at 0xA0142000
[    5.085221] [drm] vram apper at 0xA0000000
[    5.085276] [drm] size 8294400
[    5.085329] [drm] fb depth is 24
[    5.085382] [drm]    pitch is 7680
[    5.085812] fbcon: radeondrmfb (fb0) is primary device
[    5.087802] [drm:drm_crtc_helper_set_config], 
[    5.087806] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[    5.087819] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    5.087825] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    5.087830] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    5.087838] [drm:drm_mode_debug_printmodeline], Modeline 20:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[    5.087850] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    5.087855] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    5.087860] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[    5.087866] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    5.087870] [drm:drm_mode_debug_printmodeline], Modeline 20:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[    5.087885] [drm:radeon_encoder_set_active_device], setting active device to 00000008 from 00000008 00000008 for encoder 2
[    5.087897] [drm:drm_crtc_helper_set_mode], [CRTC:10]
[    5.087930] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.087974] [drm:radeon_compute_pll_avivo], 27000, pll dividers - fb: 75.6 ref: 7, post 4
[    5.088092] [drm:drm_crtc_helper_set_mode], [ENCODER:12:TMDS-12] set [MODE:20:1920x1080]
[    5.088098] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 3, devices 00000008, active_devices 00000008
[    5.088716] [drm:dce4_crtc_load_lut], 0
[    5.105424] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 0, devices 00000008, active_devices 00000008
[    5.115829] [drm:radeon_dp_get_link_status], link status 00 00 80 00 11 00
[    5.115846] [drm:dp_get_adjust_train], requested signal parameters: lane 0 voltage 0.6V pre_emph 0dB
[    5.115857] [drm:dp_get_adjust_train], requested signal parameters: lane 1 voltage 0.6V pre_emph 0dB
[    5.115867] [drm:dp_get_adjust_train], using signal parameters: voltage 0.6V pre_emph 0dB
[    5.117493] [drm:radeon_dp_get_link_status], link status 11 00 80 00 11 00
[    5.117504] [drm:radeon_dp_link_train_cr], clock recovery at voltage 1 pre-emphasis 0
[    5.119385] [drm:radeon_dp_get_link_status], link status 11 00 80 00 55 00
[    5.119395] [drm:dp_get_adjust_train], requested signal parameters: lane 0 voltage 0.6V pre_emph 3.5dB
[    5.119405] [drm:dp_get_adjust_train], requested signal parameters: lane 1 voltage 0.6V pre_emph 3.5dB
[    5.119414] [drm:dp_get_adjust_train], using signal parameters: voltage 0.6V pre_emph 3.5dB
[    5.121368] [drm:radeon_dp_get_link_status], link status 11 00 80 00 99 00
[    5.121379] [drm:dp_get_adjust_train], requested signal parameters: lane 0 voltage 0.6V pre_emph 6dB
[    5.121388] [drm:dp_get_adjust_train], requested signal parameters: lane 1 voltage 0.6V pre_emph 6dB
[    5.121397] [drm:dp_get_adjust_train], using signal parameters: voltage 0.6V pre_emph 6dB
[    5.123309] [drm:radeon_dp_get_link_status], link status 77 00 81 01 99 00
[    5.123319] [drm:radeon_dp_link_train_ce], channel eq at voltage 1 pre-emphasis 2
[    5.124159] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    5.124169] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:13:DP-1] set DPMS on
[    5.124180] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.124226] [drm:drm_crtc_helper_set_config], 
[    5.124232] [drm:drm_crtc_helper_set_config], [CRTC:11] [NOFB]
[    5.124240] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.124485] [drm:drm_crtc_helper_set_config], 
[    5.124492] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[    5.124516] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[    5.124530] [drm:dce4_crtc_load_lut], 0
[    5.124619] [drm:dce4_crtc_load_lut], 0
[    5.153032] Console: switching to colour frame buffer device 240x67
[    5.153112] [drm:drm_crtc_helper_set_config], 
[    5.153119] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[    5.153130] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[    5.153137] [drm:dce4_crtc_load_lut], 0
[    5.153191] [drm:dce4_crtc_load_lut], 0
[    5.172800] fb0: radeondrmfb frame buffer device
[    5.172867] drm: registered panic notifier
[    5.172945] [drm] Initialized radeon 2.16.0 20080528 for 0000:00:01.0 on minor 0
[    5.312381] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    5.612086] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    5.912486] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.212155] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.512191] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.812161] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    7.112160] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    7.412192] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    9.368963] loop: module loaded
[    9.402040] w83627ehf: Found W83627DHG-P chip at 0x400
[    9.402386] hwmon_vid: Unknown VRM version of your x86 CPU
[   11.179612] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.194849] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.236747] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   11.943334] r8169 0000:07:00.0: firmware: agent loaded rtl_nic/rtl8168d-1.fw into memory
[   11.999820] r8169 0000:07:00.0: eth0: link down
[   11.999944] r8169 0000:07:00.0: eth0: link down
[   12.000628] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.676747] r8169 0000:07:00.0: eth0: link up
[   13.680686] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.200281] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   15.201467] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   24.656102] eth0: no IPv6 routers present
[   25.216034] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   25.217183] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   26.089257] [drm:drm_crtc_helper_set_config], 
[   26.089264] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[   26.089288] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[   26.089301] [drm:dce4_crtc_load_lut], 0
[   26.089368] [drm:dce4_crtc_load_lut], 0
[   27.882124] Bluetooth: Core ver 2.16
[   27.887588] NET: Registered protocol family 31
[   27.892845] Bluetooth: HCI device and connection manager initialized
[   27.898087] Bluetooth: HCI socket layer initialized
[   27.903260] Bluetooth: L2CAP socket layer initialized
[   27.908511] Bluetooth: SCO socket layer initialized
[   27.934161] Bluetooth: RFCOMM TTY layer initialized
[   27.939501] Bluetooth: RFCOMM socket layer initialized
[   27.944509] Bluetooth: RFCOMM ver 1.11
[   27.956120] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.962620] Bluetooth: BNEP filters: protocol multicast
[   28.679396] [drm:drm_crtc_helper_set_config], 
[   28.679405] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[   28.679428] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[   28.679442] [drm:dce4_crtc_load_lut], 0
[   28.679513] [drm:dce4_crtc_load_lut], 0
[   28.715563] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   28.715590] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   28.715680] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   28.715691] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[   28.720451] [drm:radeon_dp_getdpcd], DPCD: 
[   28.720464] [drm:radeon_dp_getdpcd], 10 
[   28.720471] [drm:radeon_dp_getdpcd], 0a 
[   28.720478] [drm:radeon_dp_getdpcd], 82 
[   28.720484] [drm:radeon_dp_getdpcd], 40 
[   28.720490] [drm:radeon_dp_getdpcd], 00 
[   28.720496] [drm:radeon_dp_getdpcd], 00 
[   28.720502] [drm:radeon_dp_getdpcd], 01 
[   28.720507] [drm:radeon_dp_getdpcd], 00 
[   28.720513] [drm:radeon_dp_getdpcd], 
[   28.720525] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
[   28.721665] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   28.752876] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   28.752935] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[   28.752945] [drm:drm_mode_debug_printmodeline], Modeline 17:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[   28.752961] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 85 94500 1024 1072 1168 1376 768 769 772 808 0x40 0x5
[   28.752976] [drm:drm_mode_debug_printmodeline], Modeline 18:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   28.753011] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   28.753240] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   28.753250] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   28.768450] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   28.768467] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   28.768478] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   28.768505] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   28.768511] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   28.780493] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   28.780519] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   28.780535] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   28.780833] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   28.780846] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[   28.792476] [drm:radeon_dp_getdpcd], DPCD: 
[   28.792490] [drm:radeon_dp_getdpcd], 10 
[   28.792500] [drm:radeon_dp_getdpcd], 0a 
[   28.792508] [drm:radeon_dp_getdpcd], 82 
[   28.792516] [drm:radeon_dp_getdpcd], 40 
[   28.792523] [drm:radeon_dp_getdpcd], 00 
[   28.792530] [drm:radeon_dp_getdpcd], 00 
[   28.792537] [drm:radeon_dp_getdpcd], 01 
[   28.792544] [drm:radeon_dp_getdpcd], 00 
[   28.792551] [drm:radeon_dp_getdpcd], 
[   28.792564] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
[   28.793746] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   28.824987] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   28.825035] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[   28.825046] [drm:drm_mode_debug_printmodeline], Modeline 17:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[   28.825061] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 85 94500 1024 1072 1168 1376 768 769 772 808 0x40 0x5
[   28.825075] [drm:drm_mode_debug_printmodeline], Modeline 18:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   28.825107] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   28.873608] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   28.873630] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   28.884478] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   28.884503] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   28.884519] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   28.884555] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   28.884565] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   28.896496] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   28.896521] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   28.896536] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   29.783121] [drm:drm_mode_addfb], [FB:22]
[   29.783246] [drm:dce4_crtc_load_lut], 0
[   29.783303] [drm:drm_mode_setcrtc], [CRTC:10]
[   29.783321] [drm:drm_mode_setcrtc], [CONNECTOR:13:DP-1]
[   29.783330] [drm:drm_crtc_helper_set_config], 
[   29.783336] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:22] #connectors=1 (x y) (0 0)
[   29.783362] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[   29.783431] [drm:drm_mode_setcrtc], [CRTC:11]
[   29.783438] [drm:drm_crtc_helper_set_config], 
[   29.783444] [drm:drm_crtc_helper_set_config], [CRTC:11] [NOFB]
[   29.783456] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[   35.232269] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   35.233455] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   45.248287] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   45.249474] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   55.264397] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   55.265584] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   65.280286] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   65.281473] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   75.296283] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   75.297467] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   85.312312] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   85.313498] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   95.328304] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   95.329490] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  105.344264] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  105.345453] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  115.360283] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  115.361433] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  125.376295] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  125.377481] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  135.392296] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  135.393482] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  145.408367] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  145.409553] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  155.424294] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  155.425481] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  165.440303] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  165.441490] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  175.456357] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  175.457543] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  185.472301] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  185.473487] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  195.488357] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  195.489542] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  205.504315] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  205.505501] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  215.520315] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  215.521508] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  225.536397] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  225.537582] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  235.552309] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  235.553495] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  245.568317] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  245.569503] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  255.584367] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  255.585553] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  265.600312] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  265.601498] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  275.616307] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  275.617492] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  285.632282] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  285.633468] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  295.648393] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  295.649579] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  305.664305] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  305.665493] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  315.680290] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  315.681475] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  325.696393] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  325.697579] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  335.712300] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  335.713486] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  345.728299] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  345.729484] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  355.744365] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  355.745553] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  365.760290] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  365.761476] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=good1

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-4-686-pae (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.54-2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000066786000 (usable)
[    0.000000]  BIOS-e820: 0000000066786000 - 0000000066888000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000066888000 - 0000000066891000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000066891000 - 00000000668e8000 (reserved)
[    0.000000]  BIOS-e820: 00000000668e8000 - 00000000668f6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000668f6000 - 000000006694f000 (reserved)
[    0.000000]  BIOS-e820: 000000006694f000 - 0000000066956000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000066956000 - 0000000066d58000 (usable)
[    0.000000]  BIOS-e820: 0000000066d58000 - 0000000066ef4000 (reserved)
[    0.000000]  BIOS-e820: 0000000066ef4000 - 0000000066f00000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed61000 - 00000000fed71000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fef00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./OT951, BIOS 4.6.5 06/14/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x66f00 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 066F00000 mask FFFF00000 uncachable
[    0.000000]   2 base 067000000 mask FFF000000 uncachable
[    0.000000]   3 base 068000000 mask FF8000000 uncachable
[    0.000000]   4 base 070000000 mask FF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00fce00] fce00
[    0.000000] initial memory mapped : 0 - 01a00000
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 19f9000-1a00000
[    0.000000] RAMDISK: 65dc2000 - 66785000
[    0.000000] Allocated new RAMDISK: 3703b000 - 379fda40
[    0.000000] Move RAMDISK from 0000000065dc2000 - 0000000066784a3f to 3703b000 - 379fda3f
[    0.000000] ACPI: RSDP 000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 66888068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 6688ecd8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20110623/tbfadt-560)
[    0.000000] ACPI: DSDT 66888150 06B86 (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 668f4f80 00040
[    0.000000] ACPI: APIC 6688edd0 00062 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 6688ee38 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 6688ee78 00038 (v01 ALASKA    A M I 01072009 AMI  00000005)
[    0.000000] ACPI: SSDT 6688eeb0 0030C (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 6688f1c0 0168E (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 757MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x00066f00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x00066786
[    0.000000]     0: 0x00066956 -> 0x00066d58
[    0.000000]     0: 0x00066ef4 -> 0x00066f00
[    0.000000] On node 0 totalpages: 420642
[    0.000000] free_area_init_node: node 0, pgdat c1412740, node_mem_map f635a200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1515 pages used for memmap
[    0.000000]   HighMem zone: 191403 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 66f00000 (gap: 66f00000:97d00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f6335000 s33280 r0 d24064 u57344
[    0.000000] pcpu-alloc: s33280 r0 d24064 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 417347
[    0.000000] Kernel command line: initrd=/boot/initrd.img-3.2.0-4-686-pae root=UUID=bdb66d7d-99bf-4833-8436-2b8ed6efd7d1 ro BOOT_IMAGE=/boot/vmlinuz-3.2.0-4-686-pae 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000379fe:00066f00)
[    0.000000] Memory: 1653204k/1686528k available (2855k kernel code, 29364k reserved, 1344k data, 420k init, 771672k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc141b000 - 0xc1484000   ( 420 kB)
[    0.000000]       .data : 0xc12c9ec0 - 0xc141a100   (1344 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12c9ec0   (2855 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5c06000 soft=f5c08000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 999.939 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 1999.87 BogoMIPS (lpj=3999756)
[    0.004122] pid_max: default: 32768 minimum: 301
[    0.004249] Security Framework initialized
[    0.004312] AppArmor: AppArmor disabled by boot time parameter
[    0.004399] Mount-cache hash table entries: 512
[    0.004685] Initializing cgroup subsys cpuacct
[    0.004752] Initializing cgroup subsys memory
[    0.004821] Initializing cgroup subsys devices
[    0.004878] Initializing cgroup subsys freezer
[    0.008008] Initializing cgroup subsys net_cls
[    0.008065] Initializing cgroup subsys blkio
[    0.008131] Initializing cgroup subsys perf_event
[    0.008241] CPU: Physical Processor ID: 0
[    0.008297] CPU: Processor Core ID: 0
[    0.008354] mce: CPU supports 6 MCE banks
[    0.009302] ACPI: Core revision 20110623
[    0.020124] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.020562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.060562] CPU0: AMD G-T40N Processor stepping 00
[    0.064003] Performance Events: AMD PMU driver.
[    0.064003] ... version:                0
[    0.064003] ... bit width:              48
[    0.064003] ... generic registers:      4
[    0.064003] ... value mask:             0000ffffffffffff
[    0.064003] ... max period:             00007fffffffffff
[    0.064003] ... fixed-purpose events:   0
[    0.064003] ... event mask:             000000000000000f
[    0.064003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.064003] CPU 1 irqstacks, hard=f5c94000 soft=f5c96000
[    0.064003] Booting Node   0, Processors  #1 Ok.
[    0.064003] smpboot cpu 1: start_ip = 9a000
[    0.008000] Initializing CPU#1
[    0.008000] calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=4288269144 >=post_end=1301675
[    0.156064] NMI watchdog enabled, takes one hw-pmu counter.
[    0.156361] Brought up 2 CPUs
[    0.156423] Total of 2 processors activated (3999.90 BogoMIPS).
[    0.157309] devtmpfs: initialized
[    0.157309] PM: Registering ACPI NVS region at 66786000 (1056768 bytes)
[    0.157309] PM: Registering ACPI NVS region at 668e8000 (57344 bytes)
[    0.157309] PM: Registering ACPI NVS region at 6694f000 (28672 bytes)
[    0.157309] print_constraints: dummy: 
[    0.157309] NET: Registered protocol family 16
[    0.160126] Extended Config Space enabled on 0 nodes
[    0.160222] ACPI: bus type pci registered
[    0.160422] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.160510] PCI: not using MMCONFIG
[    0.180512] PCI: Using configuration type 1 for base access
[    0.180577] PCI: Using configuration type 1 for extended access
[    0.182174] bio: create slab <bio-0> at 0
[    0.182174] ACPI: Added _OSI(Module Device)
[    0.182174] ACPI: Added _OSI(Processor Device)
[    0.182174] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.182174] ACPI: Added _OSI(Processor Aggregator Device)
[    0.186015] ACPI: EC: Look up EC in DSDT
[    0.190576] ACPI: Executed 3 blocks of module-level executable AML code
[    0.209408] ACPI: Interpreter enabled
[    0.209485] ACPI: (supports S0 S3 S4 S5)
[    0.209736] ACPI: Using IOAPIC for interrupt routing
[    0.210101] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.210270] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.210344] PCI: Using MMCONFIG for extended config space
[    0.284460] ACPI: No dock devices found.
[    0.284525] HEST: Table not found.
[    0.284587] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.285082] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.285767] pci_root PNP0A08:00: host bridge window [io  0x0000-0x03af]
[    0.285830] pci_root PNP0A08:00: host bridge window [io  0x03e0-0x0cf7]
[    0.285892] pci_root PNP0A08:00: host bridge window [io  0x03b0-0x03df]
[    0.285953] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.286014] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.288024] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.288096] pci_root PNP0A08:00: host bridge window [mem 0x7f000000-0xffffffff]
[    0.288190] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.288260] pci 0000:00:01.0: [1002:9807] type 0 class 0x000300
[    0.288279] pci 0000:00:01.0: reg 10: [mem 0xa0000000-0xafffffff pref]
[    0.288292] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.288305] pci 0000:00:01.0: reg 18: [mem 0xfeb00000-0xfeb3ffff]
[    0.288377] pci 0000:00:01.0: supports D1 D2
[    0.288411] pci 0000:00:01.1: [1002:1314] type 0 class 0x000403
[    0.288428] pci 0000:00:01.1: reg 10: [mem 0xfeb44000-0xfeb47fff]
[    0.288512] pci 0000:00:01.1: supports D1 D2
[    0.288551] pci 0000:00:04.0: [1022:1512] type 1 class 0x000604
[    0.288640] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.288703] pci 0000:00:11.0: [1002:4390] type 0 class 0x000101
[    0.288733] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
[    0.288749] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
[    0.288766] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
[    0.288782] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
[    0.288799] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
[    0.288815] pci 0000:00:11.0: reg 24: [mem 0xfeb4f000-0xfeb4f3ff]
[    0.288847] pci 0000:00:11.0: set SATA to AHCI mode
[    0.288974] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.288997] pci 0000:00:12.0: reg 10: [mem 0xfeb4e000-0xfeb4efff]
[    0.289105] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.289135] pci 0000:00:12.2: reg 10: [mem 0xfeb4d000-0xfeb4d0ff]
[    0.289255] pci 0000:00:12.2: supports D1 D2
[    0.289260] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.289297] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.289319] pci 0000:00:13.0: reg 10: [mem 0xfeb4c000-0xfeb4cfff]
[    0.289427] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.289457] pci 0000:00:13.2: reg 10: [mem 0xfeb4b000-0xfeb4b0ff]
[    0.289576] pci 0000:00:13.2: supports D1 D2
[    0.289581] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.289618] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.289737] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.289770] pci 0000:00:14.2: reg 10: [mem 0xfeb40000-0xfeb43fff 64bit]
[    0.289867] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.289894] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.290007] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.290072] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.290094] pci 0000:00:14.5: reg 10: [mem 0xfeb4a000-0xfeb4afff]
[    0.290203] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.290321] pci 0000:00:15.0: supports D1 D2
[    0.290363] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.290481] pci 0000:00:15.1: supports D1 D2
[    0.290524] pci 0000:00:15.2: [1002:43a2] type 1 class 0x000604
[    0.290641] pci 0000:00:15.2: supports D1 D2
[    0.290683] pci 0000:00:15.3: [1002:43a3] type 1 class 0x000604
[    0.290802] pci 0000:00:15.3: supports D1 D2
[    0.292031] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.292054] pci 0000:00:16.0: reg 10: [mem 0xfeb49000-0xfeb49fff]
[    0.292161] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.292191] pci 0000:00:16.2: reg 10: [mem 0xfeb48000-0xfeb480ff]
[    0.292310] pci 0000:00:16.2: supports D1 D2
[    0.292315] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.292358] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.292416] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.292469] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.292523] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.292592] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.292644] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.292697] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.292749] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.292865] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.293019] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.293092] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.293098] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.293105] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.293111] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.293118] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.293125] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.293132] pci 0000:00:14.4:   bridge window [mem 0x7f000000-0xffffffff] (subtractive decode)
[    0.293210] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.293381] pci 0000:04:00.0: [197b:2368] type 0 class 0x000101
[    0.293427] pci 0000:04:00.0: reg 10: [io  0xe040-0xe047]
[    0.293448] pci 0000:04:00.0: reg 14: [io  0xe030-0xe033]
[    0.293470] pci 0000:04:00.0: reg 18: [io  0xe020-0xe027]
[    0.293492] pci 0000:04:00.0: reg 1c: [io  0xe010-0xe013]
[    0.293514] pci 0000:04:00.0: reg 20: [io  0xe000-0xe00f]
[    0.293645] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.293735] pci 0000:00:15.1: PCI bridge to [bus 04-06]
[    0.293799] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.293808] pci 0000:00:15.1:   bridge window [mem 0xfe100000-0xfeafffff]
[    0.293820] pci 0000:00:15.1:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.293925] pci 0000:07:00.0: [10ec:8168] type 0 class 0x000200
[    0.293952] pci 0000:07:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.293995] pci 0000:07:00.0: reg 18: [mem 0xd0104000-0xd0104fff 64bit pref]
[    0.294024] pci 0000:07:00.0: reg 20: [mem 0xd0100000-0xd0103fff 64bit pref]
[    0.294045] pci 0000:07:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.294141] pci 0000:07:00.0: supports D1 D2
[    0.294146] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.300104] pci 0000:00:15.2: PCI bridge to [bus 07-07]
[    0.300185] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.300201] pci 0000:00:15.2:   bridge window [mem 0xd0100000-0xd01fffff 64bit pref]
[    0.300330] pci 0000:08:00.0: [10ec:8168] type 0 class 0x000200
[    0.300363] pci 0000:08:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.300407] pci 0000:08:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.300437] pci 0000:08:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.300457] pci 0000:08:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.300561] pci 0000:08:00.0: supports D1 D2
[    0.300567] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.308100] pci 0000:00:15.3: PCI bridge to [bus 08-08]
[    0.308178] pci 0000:00:15.3:   bridge window [io  0xc000-0xcfff]
[    0.308194] pci 0000:00:15.3:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.308242] pci_bus 0000:00: on NUMA node 0
[    0.308258] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.308709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.308787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.308879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.308954] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE22._PRT]
[    0.309028] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE23._PRT]
[    0.309096]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.309160]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.309231] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.325513] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.327538] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.328149] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.328690] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 14 15) *0
[    0.329205] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.329696] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.330889] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.331615] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.332358] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.332358] vgaarb: loaded
[    0.332358] vgaarb: bridge control possible 0000:00:01.0
[    0.332459] PCI: Using ACPI for IRQ routing
[    0.344486] PCI: pci_cache_line_size set to 64 bytes
[    0.344661] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    0.344668] reserve RAM buffer: 0000000066786000 - 0000000067ffffff 
[    0.344674] reserve RAM buffer: 0000000066d58000 - 0000000067ffffff 
[    0.344680] reserve RAM buffer: 0000000066f00000 - 0000000067ffffff 
[    0.344927] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.345729] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.347826] Switching to clocksource hpet
[    0.351237] pnp: PnP ACPI init
[    0.351341] ACPI: bus type pnp registered
[    0.351804] pnp 00:00: [bus 00-ff]
[    0.351812] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.351818] pnp 00:00: [io  0x0000-0x03af window]
[    0.351824] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    0.351830] pnp 00:00: [io  0x03b0-0x03df window]
[    0.351835] pnp 00:00: [io  0x0d00-0xffff window]
[    0.351842] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.351847] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.351853] pnp 00:00: [mem 0x7f000000-0xffffffff window]
[    0.351858] pnp 00:00: [mem 0x00000000 window]
[    0.352063] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.352150] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.352279] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.352345] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.352988] pnp 00:02: [io  0x040b]
[    0.352993] pnp 00:02: [io  0x04d6]
[    0.352998] pnp 00:02: [io  0x0c00-0x0c01]
[    0.353003] pnp 00:02: [io  0x0c14]
[    0.353008] pnp 00:02: [io  0x0c50-0x0c51]
[    0.353012] pnp 00:02: [io  0x0c52]
[    0.353017] pnp 00:02: [io  0x0c6c]
[    0.353021] pnp 00:02: [io  0x0c6f]
[    0.353026] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.353030] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.353035] pnp 00:02: [io  0x0cd4-0x0cd5]
[    0.353039] pnp 00:02: [io  0x0cd6-0x0cd7]
[    0.353044] pnp 00:02: [io  0x0cd8-0x0cdf]
[    0.353049] pnp 00:02: [io  0x0800-0x089f]
[    0.353054] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.353059] pnp 00:02: [io  0x0000-0x000f]
[    0.353064] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.353069] pnp 00:02: [io  0x0900-0x090f]
[    0.353073] pnp 00:02: [io  0x0910-0x091f]
[    0.353078] pnp 00:02: [io  0xfe00-0xfefe]
[    0.353083] pnp 00:02: [io  0x0060-0x005f disabled]
[    0.353088] pnp 00:02: [io  0x0064-0x0063 disabled]
[    0.353094] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.353099] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.353104] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
[    0.353109] pnp 00:02: [mem 0xfed61000-0xfed70fff]
[    0.353117] pnp 00:02: [mem 0xfec10000-0xfec10fff]
[    0.353122] pnp 00:02: [mem 0xfed00000-0xfed00fff]
[    0.353128] pnp 00:02: [mem 0xffc00000-0xffffffff]
[    0.353297] system 00:02: [io  0x040b] has been reserved
[    0.353358] system 00:02: [io  0x04d6] has been reserved
[    0.353418] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.353479] system 00:02: [io  0x0c14] has been reserved
[    0.353538] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.353599] system 00:02: [io  0x0c52] has been reserved
[    0.353658] system 00:02: [io  0x0c6c] has been reserved
[    0.353717] system 00:02: [io  0x0c6f] has been reserved
[    0.353776] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.353836] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.353897] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.353957] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.354017] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.354077] system 00:02: [io  0x0800-0x089f] has been reserved
[    0.354138] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.354198] system 00:02: [io  0x0900-0x090f] has been reserved
[    0.354258] system 00:02: [io  0x0910-0x091f] has been reserved
[    0.354319] system 00:02: [io  0xfe00-0xfefe] has been reserved
[    0.354381] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.354444] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.354543] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.354632] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.354694] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.354756] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.354818] system 00:02: [mem 0xffc00000-0xffffffff] has been reserved
[    0.354881] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355032] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
[    0.355038] pnp 00:03: [io  0x0405-0x0414]
[    0.355141] system 00:03: [io  0x0405-0x0414] could not be reserved
[    0.355204] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355593] pnp 00:04: [io  0x03f8-0x03ff]
[    0.355618] pnp 00:04: [irq 4]
[    0.355625] pnp 00:04: [dma 0 disabled]
[    0.355818] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.356394] pnp 00:05: [io  0x02f8-0x02ff]
[    0.356406] pnp 00:05: [irq 3]
[    0.356411] pnp 00:05: [dma 0 disabled]
[    0.356540] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.356569] pnp 00:06: [dma 4]
[    0.356574] pnp 00:06: [io  0x0000-0x000f]
[    0.356579] pnp 00:06: [io  0x0081-0x0083]
[    0.356584] pnp 00:06: [io  0x0087]
[    0.356589] pnp 00:06: [io  0x0089-0x008b]
[    0.356593] pnp 00:06: [io  0x008f]
[    0.356598] pnp 00:06: [io  0x00c0-0x00df]
[    0.356658] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.356685] pnp 00:07: [io  0x0070-0x0071]
[    0.356696] pnp 00:07: [irq 8]
[    0.356753] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.356774] pnp 00:08: [io  0x0061]
[    0.356845] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.356923] pnp 00:09: [io  0x0010-0x001f]
[    0.356930] pnp 00:09: [io  0x0022-0x003f]
[    0.356937] pnp 00:09: [io  0x0044-0x005f]
[    0.356943] pnp 00:09: [io  0x0062-0x0063]
[    0.356949] pnp 00:09: [io  0x0065-0x006f]
[    0.356955] pnp 00:09: [io  0x0072-0x007f]
[    0.356961] pnp 00:09: [io  0x0080]
[    0.356967] pnp 00:09: [io  0x0084-0x0086]
[    0.356973] pnp 00:09: [io  0x0088]
[    0.356979] pnp 00:09: [io  0x008c-0x008e]
[    0.356985] pnp 00:09: [io  0x0090-0x009f]
[    0.356991] pnp 00:09: [io  0x00a2-0x00bf]
[    0.356997] pnp 00:09: [io  0x00e0-0x00ef]
[    0.357003] pnp 00:09: [io  0x04d0-0x04d1]
[    0.357162] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.357231] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.357254] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.357265] pnp 00:0a: [irq 13]
[    0.357324] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.357454] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.357952] pnp 00:0c: [mem 0x67000000-0x7effffff]
[    0.358092] system 00:0c: [mem 0x67000000-0x7effffff] could not be reserved
[    0.358157] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.358567] pnp 00:0d: [mem 0xfed00000-0xfed003ff]
[    0.358674] pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.358685] pnp: PnP ACPI: found 14 devices
[    0.358742] ACPI: ACPI bus type pnp unregistered
[    0.358801] PnPBIOS: Disabled by ACPI PNP
[    0.402348] pci 0000:07:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.402444] pci 0000:08:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.402529] PCI: max bus depth: 1 pci_try_num: 2
[    0.402621] pci 0000:00:15.2: BAR 14: assigned [mem 0x7f000000-0x7f0fffff]
[    0.402687] pci 0000:00:15.3: BAR 14: assigned [mem 0x7f100000-0x7f1fffff]
[    0.402755] pci 0000:00:15.3: BAR 14: reassigned [mem 0x7f100000-0x7f5fffff]
[    0.402820] pci 0000:00:04.0: BAR 14: assigned [mem 0x7f600000-0x7f7fffff]
[    0.402885] pci 0000:00:04.0: BAR 15: assigned [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.402968] pci 0000:00:04.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.403037] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.403103] pci 0000:00:04.0:   bridge window [io  0x1000-0x1fff]
[    0.403173] pci 0000:00:04.0:   bridge window [mem 0x7f600000-0x7f7fffff]
[    0.403244] pci 0000:00:04.0:   bridge window [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.403328] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.403409] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.403488] pci 0000:00:15.1: PCI bridge to [bus 04-06]
[    0.403553] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.403655] pci 0000:00:15.1:   bridge window [mem 0xfe100000-0xfeafffff]
[    0.403856] pci 0000:00:15.1:   bridge window [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.404107] pci 0000:07:00.0: BAR 6: assigned [mem 0xd0120000-0xd013ffff pref]
[    0.404265] pci 0000:00:15.2: PCI bridge to [bus 07-07]
[    0.404432] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    0.404589] pci 0000:00:15.2:   bridge window [mem 0x7f000000-0x7f0fffff]
[    0.404661] pci 0000:00:15.2:   bridge window [mem 0xd0100000-0xd01fffff 64bit pref]
[    0.404749] pci 0000:08:00.0: BAR 6: assigned [mem 0xd0020000-0xd003ffff pref]
[    0.404827] pci 0000:00:15.3: PCI bridge to [bus 08-08]
[    0.404892] pci 0000:00:15.3:   bridge window [io  0xc000-0xcfff]
[    0.404962] pci 0000:00:15.3:   bridge window [mem 0x7f100000-0x7f5fffff]
[    0.405033] pci 0000:00:15.3:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.405162] pci 0000:00:04.0: setting latency timer to 64
[    0.405187] pci 0000:00:15.0: setting latency timer to 64
[    0.405204] pci 0000:00:15.1: setting latency timer to 64
[    0.405221] pci 0000:00:15.2: setting latency timer to 64
[    0.405238] pci 0000:00:15.3: setting latency timer to 64
[    0.405249] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.405256] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.405262] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.405267] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.405273] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.405278] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.405284] pci_bus 0000:00: resource 10 [mem 0x7f000000-0xffffffff]
[    0.405290] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.405296] pci_bus 0000:01: resource 1 [mem 0x7f600000-0x7f7fffff]
[    0.405302] pci_bus 0000:01: resource 2 [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.405309] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.405314] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.405319] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.405325] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.405330] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.405336] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.405342] pci_bus 0000:02: resource 10 [mem 0x7f000000-0xffffffff]
[    0.405348] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.405353] pci_bus 0000:04: resource 1 [mem 0xfe100000-0xfeafffff]
[    0.405359] pci_bus 0000:04: resource 2 [mem 0xb0000000-0xcfffffff 64bit pref]
[    0.405365] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.405370] pci_bus 0000:07: resource 1 [mem 0x7f000000-0x7f0fffff]
[    0.405376] pci_bus 0000:07: resource 2 [mem 0xd0100000-0xd01fffff 64bit pref]
[    0.405382] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.405387] pci_bus 0000:08: resource 1 [mem 0x7f100000-0x7f5fffff]
[    0.405393] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.405563] NET: Registered protocol family 2
[    0.405870] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.406620] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.407565] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.408119] TCP: Hash tables configured (established 131072 bind 65536)
[    0.408193] TCP reno registered
[    0.408261] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.408344] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.408752] NET: Registered protocol family 1
[    0.409040] pci 0000:00:01.0: Boot video device
[    0.700374] PCI: CLS 64 bytes, default 64
[    0.700515] Unpacking initramfs...
[    1.290175] Freeing initrd memory: 9996k freed
[    1.298498] perf: AMD IBS detected (0x000000ff)
[    1.299265] audit: initializing netlink socket (disabled)
[    1.299356] type=2000 audit(1413509719.292:1): initialized
[    1.336171] highmem bounce pool size: 64 pages
[    1.336447] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.337970] VFS: Disk quotas dquot_6.5.2
[    1.338139] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.338381] msgmni has been set to 1741
[    1.339015] alg: No test for stdrng (krng)
[    1.339197] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.339288] io scheduler noop registered
[    1.339348] io scheduler deadline registered
[    1.339448] io scheduler cfq registered (default)
[    1.340253] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.340375] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.340532] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.341808] ERST: Table is not found!
[    1.341872] GHES: HEST is not enabled!
[    1.341965] isapnp: Scanning for PnP cards...
[    1.696612] isapnp: No Plug & Play device found
[    1.697026] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.717642] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.738542] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.761073] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.789705] 00:05: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.790970] Linux agpgart interface v0.103
[    1.791669] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.794880] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.794960] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.795801] mousedev: PS/2 mouse device common for all mice
[    1.795994] rtc_cmos 00:07: RTC can wake from S4
[    1.796404] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.796513] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.796605] cpuidle: using governor ladder
[    1.796667] cpuidle: using governor menu
[    1.797328] TCP cubic registered
[    1.797534] NET: Registered protocol family 10
[    1.798986] Mobile IPv6
[    1.799250] NET: Registered protocol family 17
[    1.799371] Registering the dns_resolver key type
[    1.799682] Using IPI No-Shortcut mode
[    1.800705] PM: Hibernation image not present or could not be loaded.
[    1.800743] registered taskstats version 1
[    1.801871] rtc_cmos 00:07: setting system clock to 2014-10-17 01:35:20 UTC (1413509720)
[    1.802129] Initializing network drop monitor service
[    1.802503] Freeing unused kernel memory: 420k freed
[    1.803074] Write protecting the kernel text: 2856k
[    1.803233] Write protecting the kernel read-only data: 1084k
[    1.803346] NX-protecting the kernel data: 3288k
[    1.836964] udevd[49]: starting version 175
[    1.945148] SCSI subsystem initialized
[    1.970357] usbcore: registered new interface driver usbfs
[    1.970494] usbcore: registered new interface driver hub
[    1.980221] usbcore: registered new device driver usb
[    1.981379] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.981544] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.981679] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.981774] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.981900] QUIRK: Enable AMD PLL fix
[    1.981924] ehci_hcd 0000:00:12.2: debug port 1
[    1.982043] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfeb4d000
[    1.989025] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.989203] libata version 3.00 loaded.
[    1.998589] pata_jmicron 0000:04:00.0: setting latency timer to 64
[    2.008368] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.008541] r8169 0000:07:00.0: setting latency timer to 64
[    2.008642] r8169 0000:07:00.0: irq 40 for MSI/MSI-X
[    2.009244] scsi0 : pata_jmicron
[    2.009986] r8169 0000:07:00.0: eth0: RTL8168d/8111d at 0xf8212000, 00:01:29:51:5c:16, XID 081000c0 IRQ 40
[    2.010075] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.010205] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.010341] r8169 0000:08:00.0: setting latency timer to 64
[    2.010425] r8169 0000:08:00.0: irq 41 for MSI/MSI-X
[    2.011727] r8169 0000:08:00.0: eth1: RTL8168d/8111d at 0xf8216000, 00:01:29:51:5c:17, XID 081000c0 IRQ 41
[    2.011814] r8169 0000:08:00.0: eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.016471] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.016649] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.016720] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.016799] usb usb1: Product: EHCI Host Controller
[    2.016813] scsi1 : pata_jmicron
[    2.016918] usb usb1: Manufacturer: Linux 3.2.0-4-686-pae ehci_hcd
[    2.016984] usb usb1: SerialNumber: 0000:00:12.2
[    2.017006] ata1: PATA max UDMA/100 cmd 0xe040 ctl 0xe030 bmdma 0xe000 irq 17
[    2.017014] ata2: PATA max UDMA/100 cmd 0xe020 ctl 0xe010 bmdma 0xe008 irq 17
[    2.017550] hub 1-0:1.0: USB hub found
[    2.017634] hub 1-0:1.0: 5 ports detected
[    2.017983] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.018071] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 2
[    2.018219] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfeb4e000
[    2.076184] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.076268] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.076347] usb usb2: Product: OHCI Host Controller
[    2.076411] usb usb2: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.076477] usb usb2: SerialNumber: 0000:00:12.0
[    2.076920] hub 2-0:1.0: USB hub found
[    2.076994] hub 2-0:1.0: 5 ports detected
[    2.077272] ahci 0000:00:11.0: version 3.0
[    2.077509] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    2.077594] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    2.089793] scsi2 : ahci
[    2.101475] scsi3 : ahci
[    2.101985] scsi4 : ahci
[    2.103954] scsi5 : ahci
[    2.104916] ata3: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f100 irq 19
[    2.105090] ata4: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f180 irq 19
[    2.105332] ata5: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f200 irq 19
[    2.105521] ata6: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f280 irq 19
[    2.105916] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.106011] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[    2.106104] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.106239] ehci_hcd 0000:00:13.2: debug port 1
[    2.106330] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfeb4b000
[    2.116515] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.116653] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.116723] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.116803] usb usb3: Product: EHCI Host Controller
[    2.116866] usb usb3: Manufacturer: Linux 3.2.0-4-686-pae ehci_hcd
[    2.116932] usb usb3: SerialNumber: 0000:00:13.2
[    2.117335] hub 3-0:1.0: USB hub found
[    2.117406] hub 3-0:1.0: 5 ports detected
[    2.117745] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    2.117834] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 4
[    2.117925] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.118052] ehci_hcd 0000:00:16.2: debug port 1
[    2.118146] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfeb48000
[    2.128135] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    2.128277] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    2.128347] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.128426] usb usb4: Product: EHCI Host Controller
[    2.128490] usb usb4: Manufacturer: Linux 3.2.0-4-686-pae ehci_hcd
[    2.128556] usb usb4: SerialNumber: 0000:00:16.2
[    2.129006] hub 4-0:1.0: USB hub found
[    2.129083] hub 4-0:1.0: 4 ports detected
[    2.129472] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.129561] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.129680] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeb4c000
[    2.188913] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.189003] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.189089] usb usb5: Product: OHCI Host Controller
[    2.189159] usb usb5: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.189235] usb usb5: SerialNumber: 0000:00:13.0
[    2.189794] hub 5-0:1.0: USB hub found
[    2.189868] hub 5-0:1.0: 5 ports detected
[    2.190855] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.190943] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    2.191062] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfeb4a000
[    2.196952] ata1.00: CFA: ATP COMPACT FLASH, 20130426, max UDMA/66
[    2.197026] ata1.00: 3931200 sectors, multi 0: LBA48 
[    2.212965] ata1.00: configured for UDMA/66
[    2.213555] scsi 0:0:0:0: Direct-Access     ATA      ATP COMPACT FLAS 2013 PQ: 0 ANSI: 5
[    2.248287] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.248367] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.248445] usb usb6: Product: OHCI Host Controller
[    2.248508] usb usb6: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.248574] usb usb6: SerialNumber: 0000:00:14.5
[    2.249259] hub 6-0:1.0: USB hub found
[    2.249344] hub 6-0:1.0: 2 ports detected
[    2.250264] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    2.250352] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    2.250475] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfeb49000
[    2.296259] Refined TSC clocksource calibration: 999.999 MHz.
[    2.296336] Switching to clocksource tsc
[    2.308286] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.308357] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.308427] usb usb7: Product: OHCI Host Controller
[    2.308484] usb usb7: Manufacturer: Linux 3.2.0-4-686-pae ohci_hcd
[    2.308543] usb usb7: SerialNumber: 0000:00:16.0
[    2.309099] hub 7-0:1.0: USB hub found
[    2.309174] hub 7-0:1.0: 4 ports detected
[    2.424138] ata3: SATA link down (SStatus 0 SControl 300)
[    2.432282] ata4: SATA link down (SStatus 0 SControl 300)
[    2.436286] ata5: SATA link down (SStatus 0 SControl 300)
[    2.436417] ata6: SATA link down (SStatus 0 SControl 300)
[    2.453351] sd 0:0:0:0: [sda] 3931200 512-byte logical blocks: (2.01 GB/1.87 GiB)
[    2.453602] sd 0:0:0:0: [sda] Write Protect is off
[    2.453672] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.453909] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.455338]  sda: sda1 sda2
[    2.456643] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.536192] usb 2-2: new low-speed USB device number 2 using ohci_hcd
[    2.704415] usb 2-2: New USB device found, idVendor=01f3, idProduct=52c0
[    2.704486] usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.720711] input: HID 01f3:52c0 as /devices/pci0000:00/0000:00:12.0/usb2/2-2/2-2:1.0/input/input0
[    2.721136] generic-usb 0003:01F3:52C0.0001: input,hidraw0: USB HID v1.10 Keyboard [HID 01f3:52c0] on usb-0000:00:12.0-2/input0
[    2.735522] input: HID 01f3:52c0 as /devices/pci0000:00/0000:00:12.0/usb2/2-2/2-2:1.1/input/input1
[    2.735926] generic-usb 0003:01F3:52C0.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [HID 01f3:52c0] on usb-0000:00:12.0-2/input1
[    2.736062] usbcore: registered new interface driver usbhid
[    2.736121] usbhid: USB HID core driver
[    2.882240] aufs: module is from the staging directory, the quality is unknown, you have been warned.
[    2.884975] aufs 3.2.x-debian
[    2.889998] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.995965] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.824864] udevd[337]: starting version 175
[    4.086554] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    4.086816] ACPI: Power Button [PWRB]
[    4.087416] ACPI: acpi_idle registered with cpuidle
[    4.088191] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.088287] ACPI: Power Button [PWRF]
[    4.115850] [drm] Initialized drm 1.1.0 20060810
[    4.143699] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.205225] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    4.205466] SP5100 TCO timer: mmio address 0xbafe00 already in use
[    4.228675] snd_hda_intel 0000:00:01.1: irq 42 for MSI/MSI-X
[    4.228734] snd_hda_intel 0000:00:01.1: setting latency timer to 64
[    4.310882] [drm] radeon kernel modesetting enabled.
[    4.356078] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[    4.356454] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input4
[    4.447034] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    4.481704] hda_codec: ALC886: BIOS auto-probing.
[    4.509550] radeon 0000:00:01.0: setting latency timer to 64
[    4.509576] [drm] initializing kernel modesetting (PALM 0x1002:0x9807 0x1022:0x1511).
[    4.509810] [drm] register mmio base: 0xFEB00000
[    4.509873] [drm] register mmio size: 262144
[    4.510400] ATOM BIOS: AMD
[    4.510526] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[    4.510611] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 - 0x0000000037FFFFFF
[    4.511433] [drm] Detected VRAM RAM=384M, BAR=256M
[    4.511507] [drm] RAM width 32bits DDR
[    4.512269] [TTM] Zone  kernel: Available graphics memory: 445974 kiB
[    4.512347] [TTM] Zone highmem: Available graphics memory: 831810 kiB
[    4.512414] [TTM] Initializing pool allocator
[    4.512490] [TTM] Initializing DMA pool allocator
[    4.512621] [drm] radeon: 384M of VRAM memory ready
[    4.512686] [drm] radeon: 512M of GTT memory ready.
[    4.512784] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    4.514977] [drm] radeon: ib pool ready.
[    4.515376] [drm] Loading PALM Microcode
[    4.545817] powernow-k8: Found 1 AMD G-T40N Processor (2 cpu cores) (version 2.20.00)
[    4.545923] powernow-k8: Core Performance Boosting: on.
[    4.546075] powernow-k8:    0 : pstate 0 (1000 MHz)
[    4.546139] powernow-k8:    1 : pstate 1 (800 MHz)
[    4.811022] platform radeon_cp.0: firmware: agent loaded radeon/PALM_pfp.bin into memory
[    4.823611] platform radeon_cp.0: firmware: agent loaded radeon/PALM_me.bin into memory
[    4.856451] platform radeon_cp.0: firmware: agent loaded radeon/SUMO_rlc.bin into memory
[    5.089138] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    5.089493] radeon 0000:00:01.0: WB enabled
[    5.089570] [drm] fence driver on ring 0 use gpu addr 0x18000c00 and cpu addr 0xffbdfc00
[    5.089665] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.089739] [drm] Driver supports precise vblank timestamp query.
[    5.089892] radeon 0000:00:01.0: irq 43 for MSI/MSI-X
[    5.089906] radeon 0000:00:01.0: radeon: using MSI.
[    5.090042] [drm] radeon: irq initialized.
[    5.107112] [drm] ring test on 0 succeeded in 1 usecs
[    5.107415] [drm] ib test on ring 0 succeeded in 0 usecs
[    5.107475] [drm] Enabling audio support
[    5.107633] HDMI hot plug event: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=0
[    5.107745] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    5.108521] [drm:radeon_dp_i2c_aux_ch], aux_i2c nack
[    5.108952] [drm] Radeon Display Connectors
[    5.109017] [drm] Connector 0:
[    5.109075] [drm]   DisplayPort
[    5.109133] [drm]   HPD2
[    5.109192] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[    5.109269] [drm]   Encoders:
[    5.109327] [drm]     DFP1: INTERNAL_UNIPHY
[    5.109387] [drm] Connector 1:
[    5.109444] [drm]   VGA
[    5.109503] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[    5.109578] [drm]   Encoders:
[    5.109636] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.109751] [drm] Internal thermal controller without fan control
[    5.109824] [drm:radeon_pm_print_states], 5 Power State(s)
[    5.109832] [drm:radeon_pm_print_states], State 0: Default
[    5.109840] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.109847] [drm:radeon_pm_print_states], 		0 e: 275870
[    5.109855] [drm:radeon_pm_print_states], State 1: Battery
[    5.109862] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.109869] [drm:radeon_pm_print_states], 		0 e: 275870
[    5.109876] [drm:radeon_pm_print_states], State 2: Performance
[    5.109883] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.109890] [drm:radeon_pm_print_states], 		0 e: 275870
[    5.109897] [drm:radeon_pm_print_states], State 3: Default
[    5.109904] [drm:radeon_pm_print_states], 	Default
[    5.109910] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.109917] [drm:radeon_pm_print_states], 		0 e: 200000
[    5.109925] [drm:radeon_pm_print_states], State 4: Default
[    5.109932] [drm:radeon_pm_print_states], 	1 Clock Mode(s)
[    5.109938] [drm:radeon_pm_print_states], 		0 e: 173920
[    5.110040] [drm] radeon: power management initialized
[    5.110112] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 3, devices 00000008, active_devices 00000000
[    5.110127] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.110237] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[    5.116714] [drm:radeon_dp_getdpcd], DPCD: 
[    5.116724] [drm:radeon_dp_getdpcd], 10 
[    5.116730] [drm:radeon_dp_getdpcd], 0a 
[    5.116735] [drm:radeon_dp_getdpcd], 82 
[    5.116739] [drm:radeon_dp_getdpcd], 40 
[    5.116744] [drm:radeon_dp_getdpcd], 00 
[    5.116748] [drm:radeon_dp_getdpcd], 00 
[    5.116753] [drm:radeon_dp_getdpcd], 01 
[    5.116757] [drm:radeon_dp_getdpcd], 00 
[    5.116761] [drm:radeon_dp_getdpcd], 
[    5.116771] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
[    5.117865] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    5.147951] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    5.147992] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[    5.148017] [drm:drm_mode_debug_printmodeline], Modeline 17:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[    5.148033] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 85 94500 1024 1072 1168 1376 768 769 772 808 0x40 0x5
[    5.148048] [drm:drm_mode_debug_printmodeline], Modeline 18:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[    5.148064] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[    5.160659] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[    5.160683] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[    5.160698] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[    5.160712] [drm:drm_setup_crtcs], 
[    5.160725] [drm:drm_enable_connectors], connector 13 enabled? yes
[    5.160734] [drm:drm_enable_connectors], connector 15 enabled? no
[    5.160744] [drm:drm_target_preferred], looking for cmdline mode on connector 13
[    5.160754] [drm:drm_target_preferred], looking for preferred mode on connector 13
[    5.160764] [drm:drm_target_preferred], found mode 1920x1080
[    5.160773] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    5.160787] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 10
[    5.177154] [drm] fb mappable at 0xA0142000
[    5.177219] [drm] vram apper at 0xA0000000
[    5.177273] [drm] size 8294400
[    5.177326] [drm] fb depth is 24
[    5.177379] [drm]    pitch is 7680
[    5.177809] fbcon: radeondrmfb (fb0) is primary device
[    5.179823] [drm:drm_crtc_helper_set_config], 
[    5.179829] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[    5.179845] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    5.179852] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[    5.179859] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    5.179870] [drm:drm_mode_debug_printmodeline], Modeline 20:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[    5.179885] [drm:drm_crtc_helper_set_config], encoder changed, full mode switch
[    5.179892] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    5.179898] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[    5.179906] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[    5.179912] [drm:drm_mode_debug_printmodeline], Modeline 20:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[    5.179931] [drm:radeon_encoder_set_active_device], setting active device to 00000008 from 00000008 00000008 for encoder 2
[    5.179945] [drm:drm_crtc_helper_set_mode], [CRTC:10]
[    5.179984] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.180087] [drm:radeon_compute_pll_avivo], 27000, pll dividers - fb: 75.6 ref: 7, post 4
[    5.180186] [drm:drm_crtc_helper_set_mode], [ENCODER:12:TMDS-12] set [MODE:20:1920x1080]
[    5.180195] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 3, devices 00000008, active_devices 00000008
[    5.180822] [drm:dce4_crtc_load_lut], 0
[    5.197531] [drm:radeon_atom_encoder_dpms], encoder dpms 30 to mode 0, devices 00000008, active_devices 00000008
[    5.207818] [drm:radeon_dp_get_link_status], link status 00 00 80 00 11 00
[    5.207837] [drm:dp_get_adjust_train], requested signal parameters: lane 0 voltage 0.6V pre_emph 0dB
[    5.207848] [drm:dp_get_adjust_train], requested signal parameters: lane 1 voltage 0.6V pre_emph 0dB
[    5.207858] [drm:dp_get_adjust_train], using signal parameters: voltage 0.6V pre_emph 0dB
[    5.209502] [drm:radeon_dp_get_link_status], link status 11 00 80 00 11 00
[    5.209513] [drm:radeon_dp_link_train_cr], clock recovery at voltage 1 pre-emphasis 0
[    5.211397] [drm:radeon_dp_get_link_status], link status 11 00 80 00 55 00
[    5.211406] [drm:dp_get_adjust_train], requested signal parameters: lane 0 voltage 0.6V pre_emph 3.5dB
[    5.211416] [drm:dp_get_adjust_train], requested signal parameters: lane 1 voltage 0.6V pre_emph 3.5dB
[    5.211426] [drm:dp_get_adjust_train], using signal parameters: voltage 0.6V pre_emph 3.5dB
[    5.213337] [drm:radeon_dp_get_link_status], link status 11 00 80 00 99 00
[    5.213347] [drm:dp_get_adjust_train], requested signal parameters: lane 0 voltage 0.6V pre_emph 6dB
[    5.213356] [drm:dp_get_adjust_train], requested signal parameters: lane 1 voltage 0.6V pre_emph 6dB
[    5.213366] [drm:dp_get_adjust_train], using signal parameters: voltage 0.6V pre_emph 6dB
[    5.215285] [drm:radeon_dp_get_link_status], link status 77 00 81 01 99 00
[    5.215295] [drm:radeon_dp_link_train_ce], channel eq at voltage 1 pre-emphasis 2
[    5.216174] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[    5.216183] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:13:DP-1] set DPMS on
[    5.216190] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.216223] [drm:drm_crtc_helper_set_config], 
[    5.216227] [drm:drm_crtc_helper_set_config], [CRTC:11] [NOFB]
[    5.216232] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[    5.216338] [drm:drm_crtc_helper_set_config], 
[    5.216342] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[    5.216366] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[    5.216376] [drm:dce4_crtc_load_lut], 0
[    5.216436] [drm:dce4_crtc_load_lut], 0
[    5.235775] Console: switching to colour frame buffer device 240x67
[    5.235804] [drm:drm_crtc_helper_set_config], 
[    5.235809] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[    5.235823] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[    5.235832] [drm:dce4_crtc_load_lut], 0
[    5.235898] [drm:dce4_crtc_load_lut], 0
[    5.255972] fb0: radeondrmfb frame buffer device
[    5.256074] drm: registered panic notifier
[    5.256163] [drm] Initialized radeon 2.16.0 20080528 for 0000:00:01.0 on minor 0
[    5.404371] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    5.708136] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.008161] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.308154] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.608138] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    6.908165] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    7.208167] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    7.508190] HDMI status: Codec=0 Pin=3 Presence_Detect=1 ELD_Valid=1
[    9.389060] loop: module loaded
[    9.422110] w83627ehf: Found W83627DHG-P chip at 0x400
[    9.422454] hwmon_vid: Unknown VRM version of your x86 CPU
[   11.204331] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.220208] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.263137] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   11.983302] r8169 0000:07:00.0: firmware: agent loaded rtl_nic/rtl8168d-1.fw into memory
[   12.039674] r8169 0000:07:00.0: eth0: link down
[   12.039806] r8169 0000:07:00.0: eth0: link down
[   12.040504] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.632776] r8169 0000:07:00.0: eth0: link up
[   13.636717] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.264119] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   15.265304] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   24.512017] eth0: no IPv6 routers present
[   25.167302] [drm:drm_crtc_helper_set_config], 
[   25.167311] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[   25.167333] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[   25.167346] [drm:dce4_crtc_load_lut], 0
[   25.167413] [drm:dce4_crtc_load_lut], 0
[   25.280093] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   25.288901] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   26.941534] Bluetooth: Core ver 2.16
[   26.946784] NET: Registered protocol family 31
[   26.952043] Bluetooth: HCI device and connection manager initialized
[   26.957279] Bluetooth: HCI socket layer initialized
[   26.962441] Bluetooth: L2CAP socket layer initialized
[   26.967730] Bluetooth: SCO socket layer initialized
[   26.993035] Bluetooth: RFCOMM TTY layer initialized
[   26.998315] Bluetooth: RFCOMM socket layer initialized
[   27.004594] Bluetooth: RFCOMM ver 1.11
[   27.010933] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.016082] Bluetooth: BNEP filters: protocol multicast
[   27.743765] [drm:drm_crtc_helper_set_config], 
[   27.743775] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:21] #connectors=1 (x y) (0 0)
[   27.743799] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[   27.743813] [drm:dce4_crtc_load_lut], 0
[   27.743885] [drm:dce4_crtc_load_lut], 0
[   27.779251] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   27.779279] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   27.779367] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   27.779380] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[   27.784447] [drm:radeon_dp_getdpcd], DPCD: 
[   27.784460] [drm:radeon_dp_getdpcd], 10 
[   27.784467] [drm:radeon_dp_getdpcd], 0a 
[   27.784474] [drm:radeon_dp_getdpcd], 82 
[   27.784480] [drm:radeon_dp_getdpcd], 40 
[   27.784486] [drm:radeon_dp_getdpcd], 00 
[   27.784492] [drm:radeon_dp_getdpcd], 00 
[   27.784497] [drm:radeon_dp_getdpcd], 01 
[   27.784503] [drm:radeon_dp_getdpcd], 00 
[   27.784509] [drm:radeon_dp_getdpcd], 
[   27.784520] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
[   27.785657] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   27.816693] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   27.816741] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[   27.816752] [drm:drm_mode_debug_printmodeline], Modeline 17:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[   27.816767] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 85 94500 1024 1072 1168 1376 768 769 772 808 0x40 0x5
[   27.816782] [drm:drm_mode_debug_printmodeline], Modeline 18:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   27.816816] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   27.817038] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   27.817048] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   27.832428] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   27.832447] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   27.832458] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   27.832487] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   27.832494] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   27.844471] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   27.844497] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   27.844513] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   27.844804] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   27.844818] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1]
[   27.852468] [drm:radeon_dp_getdpcd], DPCD: 
[   27.852482] [drm:radeon_dp_getdpcd], 10 
[   27.852492] [drm:radeon_dp_getdpcd], 0a 
[   27.852500] [drm:radeon_dp_getdpcd], 82 
[   27.852508] [drm:radeon_dp_getdpcd], 40 
[   27.852515] [drm:radeon_dp_getdpcd], 00 
[   27.852523] [drm:radeon_dp_getdpcd], 00 
[   27.852530] [drm:radeon_dp_getdpcd], 01 
[   27.852537] [drm:radeon_dp_getdpcd], 00 
[   27.852544] [drm:radeon_dp_getdpcd], 
[   27.852557] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
[   27.853725] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   27.884925] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   27.884980] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:DP-1] probed modes :
[   27.884991] [drm:drm_mode_debug_printmodeline], Modeline 17:"1920x1080" 60 138500 1920 1968 2000 2080 1080 1083 1088 1111 0x48 0x9
[   27.885006] [drm:drm_mode_debug_printmodeline], Modeline 19:"1024x768" 85 94500 1024 1072 1168 1376 768 769 772 808 0x40 0x5
[   27.885021] [drm:drm_mode_debug_printmodeline], Modeline 18:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   27.885052] [drm:drm_mode_getconnector], [CONNECTOR:13:?]
[   27.904321] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   27.904343] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   27.916463] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   27.916485] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   27.916498] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   27.916528] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   27.916537] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1]
[   27.928458] [drm:radeon_atom_dac_detect], Bios 0 scratch 10000 00000001
[   27.928483] [drm:radeon_atombios_connected_scratch_regs], CRT1 disconnected
[   27.928499] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:VGA-1] disconnected
[   28.981671] [drm:drm_mode_addfb], [FB:22]
[   28.981808] [drm:dce4_crtc_load_lut], 0
[   28.981878] [drm:drm_mode_setcrtc], [CRTC:10]
[   28.981898] [drm:drm_mode_setcrtc], [CONNECTOR:13:DP-1]
[   28.981908] [drm:drm_crtc_helper_set_config], 
[   28.981917] [drm:drm_crtc_helper_set_config], [CRTC:10] [FB:22] #connectors=1 (x y) (0 0)
[   28.981955] [drm:drm_crtc_helper_set_config], [CONNECTOR:13:DP-1] to [CRTC:10]
[   28.982036] [drm:drm_mode_setcrtc], [CRTC:11]
[   28.982045] [drm:drm_crtc_helper_set_config], 
[   28.982052] [drm:drm_crtc_helper_set_config], [CRTC:11] [NOFB]
[   28.982067] [drm:radeon_atom_encoder_dpms], encoder dpms 21 to mode 3, devices 00000001, active_devices 00000000
[   35.296293] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   35.297480] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   45.312298] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   45.313483] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   55.328295] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   55.329479] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   65.344296] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   65.345481] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   75.360295] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   75.361480] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   85.376298] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   85.377482] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[   95.392298] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[   95.393483] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  105.408286] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  105.409472] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  115.424286] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  115.425471] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  125.440287] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  125.441567] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2
[  135.456278] [drm:output_poll_execute], [CONNECTOR:13:DP-1] status updated from 1 to 1
[  135.457463] [drm:output_poll_execute], [CONNECTOR:15:VGA-1] status updated from 2 to 2

--HlL+5n6rz5pIUxbD--
