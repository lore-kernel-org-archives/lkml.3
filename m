Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3AVNrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:47:10 -0500
Received: from mxout-07.mxes.net ([216.86.168.182]:30062 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3AVNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:47:03 -0500
Date: Tue, 22 Jan 2013 08:46:58 -0500
From: Brad Tilley <brad@16s.us>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: PROBLEM: 3.8.0-rc4 keyboard failure at boot
Message-ID: <20130122134658.GA27683@16s.us>
References: <20130121213604.GA31225@16s.us>
 <20130122001346.GD16638@core.coreip.homeip.net>
 <alpine.LNX.2.00.1301221122380.20374@pobox.suse.cz>
 <20130122121947.GB27072@16s.us>
 <alpine.LNX.2.00.1301221341550.20374@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301221341550.20374@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 01:42:54PM +0100, Jiri Kosina wrote:
> Could you please provide dmesg output from both working and non-working 
> case?

See attached. Two dmesgs from the same machine. One from 3.7.3, the other from 3.8-rc4 (with a ps2 keyboard). USB keyboards on this machine never work with 3.8, but always works with 3.7.

I used an old ps2 keyboard to enter the dm-crypt password. After that, the boot process continues and the USB keyboard and mouse become active and begin to work. However, USB keyboards do not work when the user is prompted to enter the dm-crypt decryption password early in the boot process. That's the primary issue. 

> Also /proc/bus/input/devices content would be interesting (in case you are 
> able to log remotely into the machine).

See attached. One from 3.7.3 the other from 3.8-rc4 (again, the 3.8 kernel is using a ps2 keyboard and a USB keyboard).

> Does replugging the keyboard fix the problem with 50% probability?

Replugging the keyboard does not fix the problem, nor does plugging it into different USB ports or swapping USB keyboards.

> Are other USB devices (such as mice) affected by this as well?

Users are attempting to enter the dm-crypt decryption password during boot so they have not noticed nor complained about mouse failure, only keyboard failure. 

Brad

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3.7.3-dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.3-i7 (rbt@teal) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Mon Jan 21 09:55:53 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.7.3-i7 root=/dev/mapper/i7-root ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000917ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000091800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000ca9f6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca9f7000-0x00000000caa3afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000caa3b000-0x00000000cadb6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cadb7000-0x00000000cade6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cade7000-0x00000000cafe6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cafe7000-0x00000000caffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cafff000-0x00000000caffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cb800000-0x00000000cf9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffc1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000042dffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. OptiPlex 990/0D6H9T, BIOS A16 08/21/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x42e000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FE0000000 write-back
[    0.000000]   2 base 420000000 mask FF0000000 write-back
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   5 base 0CC000000 mask FFC000000 uncachable
[    0.000000]   6 base 0CB000000 mask FFF000000 uncachable
[    0.000000]   7 base 42E000000 mask FFE000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xcb000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f22d0-0x000f22df] mapped at [ffff8800000f22d0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008a000] 8a000 size 28672
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcaffffff]
[    0.000000]  [mem 0x00000000-0xcaffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xcaffffff @ [mem 0x1fffb000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x42dffffff]
[    0.000000]  [mem 0x100000000-0x42dffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x42dffffff @ [mem 0xcada9000-0xcadb6fff]
[    0.000000] RAMDISK: [mem 0x1751a000-0x1803ffff]
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000caffde18 00074 (v01 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000caf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20120913/tbfadt-394)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in FADT - 0xCAFE4E40/0x00000000CAFE4D40, using 32 (20120913/tbfadt-521)
[    0.000000] ACPI: DSDT 00000000caf71018 07327 (v02 INT430 SYSFexxx 00001001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000cafe4e40 00040
[    0.000000] ACPI: APIC 00000000caffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000cafe5d18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000caf88a98 002F9 (v01 DELLTP      TPM 00003000 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000cafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000cafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000caf7e018 00846 (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000caf7d018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000caf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000042dffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x42dffffff]
[    0.000000]   NODE_DATA [mem 0x42dffc000-0x42dffffff]
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041d600000-ffff88042d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x42dffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00090fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xca9f6fff]
[    0.000000]   node   0: [mem 0xcaa3b000-0xcadb6fff]
[    0.000000]   node   0: [mem 0xcafff000-0xcaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x42dffffff]
[    0.000000] On node 0 totalpages: 4163829
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 7 pages reserved
[    0.000000]   DMA zone: 3898 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 809396 pages, LIFO batch:31
[    0.000000]   Normal zone: 52096 pages used for memmap
[    0.000000]   Normal zone: 3282048 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000091000 - 0000000000092000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000ca9f7000 - 00000000caa3b000
[    0.000000] PM: Registered nosave memory: 00000000cadb7000 - 00000000cade7000
[    0.000000] PM: Registered nosave memory: 00000000cade7000 - 00000000cafe7000
[    0.000000] PM: Registered nosave memory: 00000000cafe7000 - 00000000cafff000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000cb800000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000cfa00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 0000000100000000
[    0.000000] e820: [mem 0xcfa00000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88042dc00000 s83008 r8192 d23488 u131072
[    0.000000] pcpu-alloc: s83008 r8192 d23488 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4095342
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.7.3-i7 root=/dev/mapper/i7-root ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16305296k/17530880k available (4068k kernel code, 875564k absent, 350020k reserved, 2630k data, 628k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=16.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3392.261 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6784.52 BogoMIPS (lpj=13569044)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000024] Security Framework initialized
[    0.000026] SELinux:  Disabled at boot.
[    0.000636] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.002972] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.003967] Mount-cache hash table entries: 256
[    0.004118] Initializing cgroup subsys cpuacct
[    0.004119] Initializing cgroup subsys devices
[    0.004120] Initializing cgroup subsys freezer
[    0.004121] Initializing cgroup subsys net_cls
[    0.004138] CPU: Physical Processor ID: 0
[    0.004139] CPU: Processor Core ID: 0
[    0.004142] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.004142] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.004144] mce: CPU supports 9 MCE banks
[    0.004154] CPU0: Thermal monitoring enabled (TM1)
[    0.004159] process: using mwait in idle threads
[    0.004162] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.004162] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.004162] tlb_flushall_shift: 5
[    0.004240] Freeing SMP alternatives: 20k freed
[    0.004970] ACPI: Core revision 20120913
[    0.007738] Switched APIC routing to physical flat.
[    0.008132] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.047701] smpboot: CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz (fam: 06, model: 2a, stepping: 07)
[    0.152790] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.152794] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.152795] ... version:                3
[    0.152796] ... bit width:              48
[    0.152797] ... generic registers:      4
[    0.152798] ... value mask:             0000ffffffffffff
[    0.152798] ... max period:             000000007fffffff
[    0.152799] ... fixed-purpose events:   3
[    0.152800] ... event mask:             000000070000000f
[    0.152965] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7
[    0.244935] Brought up 8 CPUs
[    0.244938] smpboot: Total of 8 processors activated (54276.17 BogoMIPS)
[    0.251077] devtmpfs: initialized
[    0.253645] PM: Registering ACPI NVS region [mem 0xcade7000-0xcafe6fff] (2097152 bytes)
[    0.253684] reboot: PCI series board detected. Selecting Dell OptiPlex 990-method for reboots.
[    0.253756] regulator-dummy: no parameters
[    0.253794] NET: Registered protocol family 16
[    0.253872] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.253873] ACPI: bus type pci registered
[    0.253924] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.253925] PCI: not using MMCONFIG
[    0.253927] PCI: Using configuration type 1 for base access
[    0.253931] dmi type 0xB1 record - unknown flag
[    0.254435] bio: create slab <bio-0> at 0
[    0.254477] ACPI: Added _OSI(Module Device)
[    0.254478] ACPI: Added _OSI(Processor Device)
[    0.254479] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.254480] ACPI: Added _OSI(Processor Aggregator Device)
[    0.255151] ACPI: EC: Look up EC in DSDT
[    0.257686] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.296659] ACPI: SSDT 00000000cadd7798 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    0.296837] ACPI: Dynamic OEM Table Load:
[    0.296838] ACPI: SSDT           (null) 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    0.316519] ACPI: SSDT 00000000cadd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    0.316718] ACPI: Dynamic OEM Table Load:
[    0.316719] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    0.336370] ACPI: SSDT 00000000cadd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    0.336540] ACPI: Dynamic OEM Table Load:
[    0.336542] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    0.356973] ACPI: Interpreter enabled
[    0.356975] ACPI: (supports S0 S3 S4 S5)
[    0.356987] ACPI: Using IOAPIC for interrupt routing
[    0.356999] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.357229] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.397420] ACPI: No dock devices found.
[    0.397423] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.397636] \_SB_.PCI0:_OSC invalid UUID
[    0.397637] _OSC request data:1 8 1f 
[    0.397639] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.398012] PCI host bridge to bus 0000:00
[    0.398015] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.398016] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.398018] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.398019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.398021] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeafffff]
[    0.398027] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.398055] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
[    0.398062] pci 0000:00:02.0: reg 10: [mem 0xe0c00000-0xe0ffffff 64bit]
[    0.398066] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.398069] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
[    0.398112] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.398133] pci 0000:00:16.0: reg 10: [mem 0xe1ab0000-0xe1ab000f 64bit]
[    0.398202] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.398230] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.398245] pci 0000:00:19.0: reg 10: [mem 0xe1a00000-0xe1a1ffff]
[    0.398253] pci 0000:00:19.0: reg 14: [mem 0xe1a80000-0xe1a80fff]
[    0.398260] pci 0000:00:19.0: reg 18: [io  0x3080-0x309f]
[    0.398316] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.398339] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.398358] pci 0000:00:1a.0: reg 10: [mem 0xe1a70000-0xe1a703ff]
[    0.398439] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.398463] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.398476] pci 0000:00:1b.0: reg 10: [mem 0xe1a60000-0xe1a63fff 64bit]
[    0.398536] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.398560] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.398687] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.398725] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.398845] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.398885] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.398904] pci 0000:00:1d.0: reg 10: [mem 0xe1a50000-0xe1a503ff]
[    0.398986] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.399006] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.399062] pci 0000:00:1f.0: [8086:1c4e] type 00 class 0x060100
[    0.399176] pci 0000:00:1f.2: [8086:2822] type 00 class 0x010400
[    0.399192] pci 0000:00:1f.2: reg 10: [io  0x30d0-0x30d7]
[    0.399199] pci 0000:00:1f.2: reg 14: [io  0x30c0-0x30c3]
[    0.399206] pci 0000:00:1f.2: reg 18: [io  0x30b0-0x30b7]
[    0.399212] pci 0000:00:1f.2: reg 1c: [io  0x30a0-0x30a3]
[    0.399219] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
[    0.399226] pci 0000:00:1f.2: reg 24: [mem 0xe1a40000-0xe1a407ff]
[    0.399265] pci 0000:00:1f.2: PME# supported from D3hot
[    0.399280] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.399293] pci 0000:00:1f.3: reg 10: [mem 0xe1a30000-0xe1a300ff 64bit]
[    0.399312] pci 0000:00:1f.3: reg 20: [io  0x3040-0x305f]
[    0.399401] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.399484] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.399488] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.399493] pci 0000:00:1c.2:   bridge window [mem 0xe1000000-0xe19fffff]
[    0.399501] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe09fffff 64bit pref]
[    0.399554] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.399562] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.399564] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.399565] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.399567] pci 0000:00:1e.0:   bridge window [mem 0xcfa00000-0xfeafffff] (subtractive decode)
[    0.399585] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.399698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.399721] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.399753] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.399830] \_SB_.PCI0:_OSC invalid UUID
[    0.399831] _OSC request data:1 1f 1f 
[    0.399833]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.399834]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.401559] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401589] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.401617] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401644] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.401672] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.401700] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.401727] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.401755] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.401804] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.401806] vgaarb: loaded
[    0.401806] vgaarb: bridge control possible 0000:00:02.0
[    0.401810] ACPI: bus type usb registered
[    0.401821] usbcore: registered new interface driver usbfs
[    0.401827] usbcore: registered new interface driver hub
[    0.401838] usbcore: registered new device driver usb
[    0.401854] PCI: Using ACPI for IRQ routing
[    0.403240] PCI: pci_cache_line_size set to 64 bytes
[    0.403274] e820: reserve RAM buffer [mem 0x00091800-0x0009ffff]
[    0.403275] e820: reserve RAM buffer [mem 0xca9f7000-0xcbffffff]
[    0.403276] e820: reserve RAM buffer [mem 0xcadb7000-0xcbffffff]
[    0.403277] e820: reserve RAM buffer [mem 0xcb000000-0xcbffffff]
[    0.403279] e820: reserve RAM buffer [mem 0x42e000000-0x42fffffff]
[    0.403348] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.403352] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.405356] Switching to clocksource hpet
[    0.406783] pnp: PnP ACPI init
[    0.406788] ACPI: bus type pnp registered
[    0.406985] pnp 00:00: [bus 00-3e]
[    0.406987] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.406988] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.406989] pnp 00:00: [io  0x0d00-0xffff window]
[    0.406991] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.406992] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.406993] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.406995] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.406996] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.406997] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.406998] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.406999] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.407001] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.407002] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.407003] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.407004] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.407005] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.407006] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.407008] pnp 00:00: [mem 0xcfa00000-0xfeafffff window]
[    0.407024] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.407039] pnp 00:01: [io  0x0000-0x001f]
[    0.407040] pnp 00:01: [io  0x0081-0x0091]
[    0.407041] pnp 00:01: [io  0x0093-0x009f]
[    0.407043] pnp 00:01: [io  0x00c0-0x00df]
[    0.407045] pnp 00:01: [dma 4]
[    0.407055] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.407060] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.407070] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.407116] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.407126] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.407131] pnp 00:04: [io  0x00f0]
[    0.407138] pnp 00:04: [irq 13]
[    0.407147] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.407160] pnp 00:05: [io  0x002e-0x002f]
[    0.407161] pnp 00:05: [io  0x004e-0x004f]
[    0.407162] pnp 00:05: [io  0x0061]
[    0.407163] pnp 00:05: [io  0x0063]
[    0.407164] pnp 00:05: [io  0x0065]
[    0.407165] pnp 00:05: [io  0x0067]
[    0.407166] pnp 00:05: [io  0x0070]
[    0.407167] pnp 00:05: [io  0x0080]
[    0.407168] pnp 00:05: [io  0x0092]
[    0.407169] pnp 00:05: [io  0x00b2-0x00b3]
[    0.407171] pnp 00:05: [io  0x0680-0x069f]
[    0.407172] pnp 00:05: [io  0xffff]
[    0.407173] pnp 00:05: [io  0xffff]
[    0.407174] pnp 00:05: [io  0xffff]
[    0.407175] pnp 00:05: [io  0x0400-0x0453]
[    0.407176] pnp 00:05: [io  0x0458-0x047f]
[    0.407177] pnp 00:05: [io  0x0500-0x057f]
[    0.407178] pnp 00:05: [io  0x164e-0x164f]
[    0.407196] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.407198] system 00:05: [io  0xffff] has been reserved
[    0.407199] system 00:05: [io  0xffff] has been reserved
[    0.407201] system 00:05: [io  0xffff] has been reserved
[    0.407202] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.407203] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.407205] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.407206] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.407208] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.407212] pnp 00:06: [io  0x0070-0x0077]
[    0.407217] pnp 00:06: [irq 8]
[    0.407226] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.407241] pnp 00:07: [io  0x0454-0x0457]
[    0.407256] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.407258] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.407410] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.407411] pnp 00:08: [mem 0xfed10000-0xfed17fff]
[    0.407412] pnp 00:08: [mem 0xfed18000-0xfed18fff]
[    0.407413] pnp 00:08: [mem 0xfed19000-0xfed19fff]
[    0.407415] pnp 00:08: [mem 0xf8000000-0xfbffffff]
[    0.407416] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    0.407417] pnp 00:08: [mem 0xfed90000-0xfed93fff]
[    0.407418] pnp 00:08: [mem 0xfed45000-0xfed8ffff]
[    0.407419] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.407420] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    0.407422] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.407423] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.407441] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.407443] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.407446] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.407447] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.407449] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.407450] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.407451] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.407453] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.407454] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    0.407456] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.407457] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.407471] pnp 00:09: [mem 0x20000000-0x201fffff]
[    0.407473] pnp 00:09: [mem 0x40000000-0x401fffff]
[    0.407490] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.407491] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    0.407493] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.407563] pnp: PnP ACPI: found 10 devices
[    0.407563] ACPI: ACPI bus type pnp unregistered
[    0.413135] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.413152] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.413155] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.413162] pci 0000:00:1c.2:   bridge window [mem 0xe1000000-0xe19fffff]
[    0.413166] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe09fffff 64bit pref]
[    0.413174] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.413204] pci 0000:00:1e.0: setting latency timer to 64
[    0.413208] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.413209] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.413210] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.413211] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.413213] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.413214] pci_bus 0000:02: resource 1 [mem 0xe1000000-0xe19fffff]
[    0.413216] pci_bus 0000:02: resource 2 [mem 0xe0000000-0xe09fffff 64bit pref]
[    0.413217] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.413218] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.413219] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.413221] pci_bus 0000:03: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.413238] NET: Registered protocol family 2
[    0.413626] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.414504] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.414621] TCP: Hash tables configured (established 524288 bind 65536)
[    0.414637] TCP: reno registered
[    0.414650] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.414694] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.414777] NET: Registered protocol family 1
[    0.415003] pci 0000:00:02.0: Boot video device
[    0.415085] PCI: CLS 64 bytes, default 64
[    0.415112] Unpacking initramfs...
[    0.583433] Freeing initrd memory: 11416k freed
[    0.584372] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.584377] software IO TLB [mem 0xc69f7000-0xca9f6fff] (64MB) mapped at [ffff8800c69f7000-ffff8800ca9f6fff]
[    0.584406] Simple Boot Flag at 0xf3 set to 0x1
[    0.584745] audit: initializing netlink socket (disabled)
[    0.584757] type=2000 audit(1358783265.480:1): initialized
[    0.594240] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.595094] VFS: Disk quotas dquot_6.5.2
[    0.595124] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.595350] msgmni has been set to 31868
[    0.595494] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.595496] io scheduler noop registered
[    0.595497] io scheduler deadline registered
[    0.595500] io scheduler cfq registered (default)
[    0.595713] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.616069] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.616281] Linux agpgart interface v0.103
[    0.616345] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.619209] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.619212] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.619270] mousedev: PS/2 mouse device common for all mice
[    0.619296] rtc_cmos 00:06: RTC can wake from S4
[    0.619415] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.619442] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    0.619446] cpuidle: using governor ladder
[    0.619447] cpuidle: using governor menu
[    0.619497] drop_monitor: Initializing network drop monitor service
[    0.619550] TCP: cubic registered
[    0.619612] NET: Registered protocol family 10
[    0.619726] mip6: Mobile IPv6
[    0.619728] NET: Registered protocol family 17
[    0.619729] lib80211: common routines for IEEE802.11 drivers
[    0.619731] lib80211_crypt: registered algorithm 'NULL'
[    0.619887] PM: Hibernation image not present or could not be loaded.
[    0.619892] registered taskstats version 1
[    0.620129] rtc_cmos 00:06: setting system clock to 2013-01-21 15:47:45 UTC (1358783265)
[    0.620806] Freeing unused kernel memory: 628k freed
[    0.620852] Write protecting the kernel read-only data: 6144k
[    0.620961] Freeing unused kernel memory: 16k freed
[    0.621990] Freeing unused kernel memory: 552k freed
[    0.658446] udev[83]: starting version 164
[    0.664804] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.664846] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.664850] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.664856] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.664870] ehci_hcd 0000:00:1a.0: debug port 2
[    0.665717] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    0.665719] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    0.668768] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.668788] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe1a70000
[    0.670104] SCSI subsystem initialized
[    0.670826] ACPI: bus type scsi registered
[    0.671219] libata version 3.00 loaded.
[    0.680610] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.680655] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.680656] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.680658] usb usb1: Product: EHCI Host Controller
[    0.680659] usb usb1: Manufacturer: Linux 3.7.3-i7 ehci_hcd
[    0.680660] usb usb1: SerialNumber: 0000:00:1a.0
[    0.680742] hub 1-0:1.0: USB hub found
[    0.680745] hub 1-0:1.0: 2 ports detected
[    0.680840] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.680843] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.680846] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.680857] ehci_hcd 0000:00:1d.0: debug port 2
[    0.684740] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.684754] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe1a50000
[    0.696580] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.696610] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.696612] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.696613] usb usb2: Product: EHCI Host Controller
[    0.696614] usb usb2: Manufacturer: Linux 3.7.3-i7 ehci_hcd
[    0.696615] usb usb2: SerialNumber: 0000:00:1d.0
[    0.696675] hub 2-0:1.0: USB hub found
[    0.696677] hub 2-0:1.0: 2 ports detected
[    0.696751] e1000e 0000:00:19.0: setting latency timer to 64
[    0.696805] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.696833] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    0.953916] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 18:03:73:4d:0b:0d
[    0.953918] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.953950] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: E041FF-0FF
[    0.953961] ahci 0000:00:1f.2: version 3.0
[    0.954002] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.954014] ahci 0000:00:1f.2: controller can't do SNTF, turning off CAP_SNTF
[    0.954048] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl RAID mode
[    0.954050] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.954054] ahci 0000:00:1f.2: setting latency timer to 64
[    0.960082] scsi0 : ahci
[    0.960124] scsi1 : ahci
[    0.960157] scsi2 : ahci
[    0.960190] scsi3 : ahci
[    0.960223] scsi4 : ahci
[    0.960255] scsi5 : ahci
[    0.960279] ata1: SATA max UDMA/133 abar m2048@0xe1a40000 port 0xe1a40100 irq 41
[    0.960282] ata2: SATA max UDMA/133 abar m2048@0xe1a40000 port 0xe1a40180 irq 41
[    0.960283] ata3: DUMMY
[    0.960283] ata4: DUMMY
[    0.960284] ata5: DUMMY
[    0.960285] ata6: DUMMY
[    0.991714] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.123652] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.123657] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.123788] hub 1-1:1.0: USB hub found
[    1.123899] hub 1-1:1.0: 6 ports detected
[    1.235009] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.278891] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.278913] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.279934] ata1.00: ATA-8: ST3500413AS, JC49, max UDMA/133
[    1.279937] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.280146] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.281644] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.281648] ata1.00: configured for UDMA/133
[    1.282127] ata2.00: ATAPI: HL-DT-ST DVD+-RW GT50N, A101, max UDMA/133
[    1.284996] ata2.00: configured for UDMA/133
[    1.286959] scsi 0:0:0:0: Direct-Access     ATA      ST3500413AS      JC49 PQ: 0 ANSI: 5
[    1.292940] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GT50N    A101 PQ: 0 ANSI: 5
[    1.294666] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.294717] sd 0:0:0:0: [sda] Write Protect is off
[    1.294720] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.294742] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.298028] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.298031] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.298121] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.308206]  sda: sda1 sda2 < sda5 >
[    1.308405] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.309478] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.309501] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.366954] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.366959] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.367092] hub 2-1:1.0: USB hub found
[    1.367199] hub 2-1:1.0: 8 ports detected
[    1.521931] Btrfs loaded
[    1.524959] device-mapper: uevent: version 1.0.3
[    1.525005] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    1.578044] tsc: Refined TSC clocksource calibration: 3392.293 MHz
[    1.578049] Switching to clocksource tsc
[    1.637925] usb 2-1.1: new low-speed USB device number 3 using ehci_hcd
[    1.734398] usb 2-1.1: New USB device found, idVendor=0461, idProduct=4d51
[    1.734402] usb 2-1.1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.734405] usb 2-1.1: Product: DELL Laser Mouse
[    1.738515] input: DELL Laser Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input0
[    1.738559] hid-generic 0003:0461:4D51.0001: input,hidraw0: USB HID v1.11 Mouse [DELL Laser Mouse] on usb-0000:00:1d.0-1.1/input0
[    1.738569] usbcore: registered new interface driver usbhid
[    1.738570] usbhid: USB HID core driver
[    1.805445] usb 2-1.2: new low-speed USB device number 4 using ehci_hcd
[    1.913136] usb 2-1.2: New USB device found, idVendor=413c, idProduct=2106
[    1.913140] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.913143] usb 2-1.2: Product: Dell QuietKey Keyboard
[    1.913145] usb 2-1.2: Manufacturer: Dell
[    1.921874] input: Dell Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input1
[    1.921908] hid-generic 0003:413C:2106.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell QuietKey Keyboard] on usb-0000:00:1d.0-1.2/input0
[    1.992908] usb 2-1.7: new full-speed USB device number 5 using ehci_hcd
[    2.092498] usb 2-1.7: New USB device found, idVendor=0529, idProduct=0600
[    2.092501] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.092504] usb 2-1.7: Product: Token 4.28.1.1 2.7.195
[    2.092507] usb 2-1.7: Manufacturer: Aladdin Knowledge Systems Ltd.
[   16.832376] bio: create slab <bio-1> at 1
[   16.963457] bio: create slab <bio-1> at 1
[   17.404967] PM: Starting manual resume from disk
[   17.404970] PM: Hibernation image partition 254:2 present
[   17.404971] PM: Looking for hibernation image.
[   17.405177] PM: Image not found (code -22)
[   17.405178] PM: Hibernation image not present or could not be loaded.
[   17.447455] kjournald starting.  Commit interval 5 seconds
[   17.447526] EXT3-fs (dm-1): mounted filesystem with ordered data mode
[   18.637067] udev[374]: starting version 164
[   18.919662] ACPI Warning: 0x0000000000003040-0x000000000000305f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
[   18.919666] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   18.928064] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x25
[   18.960976] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   18.996025] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[   18.996046] ACPI: Power Button [PWRB]
[   18.996073] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   18.996093] ACPI: Power Button [PWRF]
[   18.996737] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   19.119939] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
[   19.119944] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.119947] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   19.119950] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.119951] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   19.119953] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.119954] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20120913/utaddress-251)
[   19.119956] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.119957] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   19.195607] ACPI: Requesting acpi_cpufreq
[   19.196053] Monitor-Mwait will be used to enter C-1 state
[   19.196059] Monitor-Mwait will be used to enter C-2 state
[   19.196063] Monitor-Mwait will be used to enter C-3 state
[   19.196073] ACPI: acpi_idle registered with cpuidle
[   19.227178] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x25
[   19.228160] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x25
[   19.229127] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25
[   19.230010] microcode: CPU4 sig=0x206a7, pf=0x2, revision=0x25
[   19.230855] microcode: CPU5 sig=0x206a7, pf=0x2, revision=0x25
[   19.231710] microcode: CPU6 sig=0x206a7, pf=0x2, revision=0x25
[   19.232591] microcode: CPU7 sig=0x206a7, pf=0x2, revision=0x25
[   19.233438] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   19.808276] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   19.847075] hda_codec: ALC269VB: SKU not ready 0x411111f0
[   19.848900] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[   19.857330] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   19.857416] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   19.857490] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   19.857557] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   19.857623] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   20.897588] EXT3-fs (dm-1): using internal journal
[   21.109029] loop: module loaded
[   21.471710] Adding 19779580k swap on /dev/mapper/i7-swap_1.  Priority:-1 extents:1 across:19779580k 
[   22.898308] fuse init (API version 7.20)
[   22.970427] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   23.072643] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   23.072794] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.315172] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   24.315295] DECnet: Routing cache hash table of 1024 buckets, 16Kbytes
[   24.315301] NET: Registered protocol family 12
[   24.482696] thinkpad_ec: no ThinkPad embedded controller!
[   26.285917] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   26.285962] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   29.142274] Netfilter messages via NETLINK v0.30.
[   29.733716] sshd (1710): /proc/1710/oom_adj is deprecated, please use /proc/1710/oom_score_adj instead.
[   31.073258] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.105294] lp: driver loaded but no devices found
[   35.690262] ppdev: user-space parallel port driver
[   35.755617] parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
[   35.880115] parport0: irq 7 detected
[   35.975761] lp0: using parport0 (polling).
[   38.379617] [drm] Initialized drm 1.1.0 20060810
[   38.543788] pci 0000:00:00.0: Intel Sandybridge Chipset
[   38.543877] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   38.544863] pci 0000:00:00.0: detected 65536K stolen memory
[   38.544948] i915 0000:00:02.0: setting latency timer to 64
[   38.557514] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[   38.557536] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   38.557537] [drm] Driver supports precise vblank timestamp query.
[   38.557560] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   38.585678] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   39.185645] fbcon: inteldrmfb (fb0) is primary device
[   39.185809] Console: switching to colour frame buffer device 160x64
[   39.185814] fb0: inteldrmfb frame buffer device
[   39.185816] drm: registered panic notifier
[   39.186387] acpi device:01: registered as cooling_device8
[   39.186633] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   39.186693] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input11
[   39.186862] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   51.194662] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[ 4454.244871] usb 2-1.7: reset full-speed USB device number 5 using ehci_hcd
[ 4462.812408] usb 2-1.7: reset full-speed USB device number 5 using ehci_hcd
[ 4465.891604] usb 2-1.7: reset full-speed USB device number 5 using ehci_hcd
[ 4466.150870] usb 2-1.7: reset full-speed USB device number 5 using ehci_hcd

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3.7.3-proc-bus-input-devices.txt"

I: Bus=0003 Vendor=0461 Product=4d51 Version=0111
N: Name="DELL Laser Mouse"
P: Phys=usb-0000:00:1d.0-1.1/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input0
U: Uniq=
H: Handlers=mouse0 event0 
B: PROP=0
B: EV=17
B: KEY=1f0000 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0003 Vendor=413c Product=2106 Version=0110
N: Name="Dell Dell QuietKey Keyboard"
P: Phys=usb-0000:00:1d.0-1.2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input1
U: Uniq=
H: Handlers=sysrq kbd event1 
B: PROP=0
B: EV=120013
B: KEY=1000000000007 ff9f207ac14057ff febeffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input2
U: Uniq=
H: Handlers=kbd event2 
B: PROP=0
B: EV=40001
B: SND=6

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
U: Uniq=
H: Handlers=kbd event3 
B: PROP=0
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
U: Uniq=
H: Handlers=kbd event4 
B: PROP=0
B: EV=3
B: KEY=10000000000000 0

I: Bus=0001 Vendor=10ec Product=0269 Version=0001
N: Name="HDA Digital PCBeep"
P: Phys=card0/codec#0/beep0
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/input/input5
U: Uniq=
H: Handlers=kbd event5 
B: PROP=0
B: EV=40001
B: SND=6

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH HDMI/DP,pcm=3"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
U: Uniq=
H: Handlers=event6 
B: PROP=0
B: EV=21
B: SW=140

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Rear Mic"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
U: Uniq=
H: Handlers=event7 
B: PROP=0
B: EV=21
B: SW=10

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Front Mic"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
U: Uniq=
H: Handlers=event8 
B: PROP=0
B: EV=21
B: SW=10

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Front Headphone"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
U: Uniq=
H: Handlers=event9 
B: PROP=0
B: EV=21
B: SW=4

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Line Out"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
U: Uniq=
H: Handlers=event10 
B: PROP=0
B: EV=21
B: SW=40

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=LNXVIDEO/video/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input11
U: Uniq=
H: Handlers=kbd event11 
B: PROP=0
B: EV=3
B: KEY=3e000b00000000 0 0 0


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3.8-rc4-dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc4-i7 (rbt@teal) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Tue Jan 22 08:19:00 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc4-i7 root=/dev/mapper/i7-root ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000917ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000091800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000ca9f6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca9f7000-0x00000000caa3afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000caa3b000-0x00000000cadb6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cadb7000-0x00000000cade6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cade7000-0x00000000cafe6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cafe7000-0x00000000caffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cafff000-0x00000000caffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cb800000-0x00000000cf9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffc1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000042dffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. OptiPlex 990/0D6H9T, BIOS A16 08/21/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x42e000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FE0000000 write-back
[    0.000000]   2 base 420000000 mask FF0000000 write-back
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   5 base 0CC000000 mask FFC000000 uncachable
[    0.000000]   6 base 0CB000000 mask FFF000000 uncachable
[    0.000000]   7 base 42E000000 mask FFE000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xcb000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f22d0-0x000f22df] mapped at [ffff8800000f22d0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008a000] 8a000 size 28672
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcaffffff]
[    0.000000]  [mem 0x00000000-0xcaffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xcaffffff @ [mem 0x1fffb000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x42dffffff]
[    0.000000]  [mem 0x100000000-0x42dffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x42dffffff @ [mem 0xcada9000-0xcadb6fff]
[    0.000000] RAMDISK: [mem 0x17516000-0x1803ffff]
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000caffde18 00074 (v01 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000caf87d98 000F4 (v04 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20121018/tbfadt-394)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in FADT - 0xCAFE4E40/0x00000000CAFE4D40, using 32 (20121018/tbfadt-521)
[    0.000000] ACPI: DSDT 00000000caf71018 07327 (v02 INT430 SYSFexxx 00001001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000cafe4e40 00040
[    0.000000] ACPI: APIC 00000000caffcf18 000CC (v02 DELL    CBX3    06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000cafe5d18 00032 (v02                 00000000      00000000)
[    0.000000] ACPI: SSDT 00000000caf88a98 002F9 (v01 DELLTP      TPM 00003000 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000cafe5c98 0003C (v01 DELL   SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cafe5c18 00038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000cafe5b98 00028 (v01 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000caf7e018 00846 (v01  PmRef  Cpu0Ist 00003000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000caf7d018 00996 (v01  PmRef    CpuPm 00003000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000caf87c18 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0010bfffff] PMD -> [ffff88041d600000-ffff88042d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x42dffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00090fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xca9f6fff]
[    0.000000]   node   0: [mem 0xcaa3b000-0xcadb6fff]
[    0.000000]   node   0: [mem 0xcafff000-0xcaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x42dffffff]
[    0.000000] On node 0 totalpages: 4163829
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 129 pages reserved
[    0.000000]   DMA zone: 3776 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12902 pages used for memmap
[    0.000000]   DMA32 zone: 812814 pages, LIFO batch:31
[    0.000000]   Normal zone: 52096 pages used for memmap
[    0.000000]   Normal zone: 3282048 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000091000 - 0000000000092000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000ca9f7000 - 00000000caa3b000
[    0.000000] PM: Registered nosave memory: 00000000cadb7000 - 00000000cade7000
[    0.000000] PM: Registered nosave memory: 00000000cade7000 - 00000000cafe7000
[    0.000000] PM: Registered nosave memory: 00000000cafe7000 - 00000000cafff000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000cb800000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000cfa00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 0000000100000000
[    0.000000] e820: [mem 0xcfa00000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042dc00000 s78144 r8192 d24256 u262144
[    0.000000] pcpu-alloc: s78144 r8192 d24256 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4098638
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc4-i7 root=/dev/mapper/i7-root ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16281456k/17530880k available (3874k kernel code, 875564k absent, 373860k reserved, 2738k data, 528k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3392.243 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 6784.48 BogoMIPS (lpj=13568972)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000022] Security Framework initialized
[    0.000025] SELinux:  Disabled at boot.
[    0.000030] Mount-cache hash table entries: 256
[    0.000151] Initializing cgroup subsys cpuacct
[    0.000152] Initializing cgroup subsys devices
[    0.000153] Initializing cgroup subsys freezer
[    0.000154] Initializing cgroup subsys net_cls
[    0.000170] CPU: Physical Processor ID: 0
[    0.000171] CPU: Processor Core ID: 0
[    0.000174] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000174] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000176] mce: CPU supports 9 MCE banks
[    0.000185] CPU0: Thermal monitoring enabled (TM1)
[    0.000192] process: using mwait in idle threads
[    0.000194] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.000194] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000194] tlb_flushall_shift: 5
[    0.000270] Freeing SMP alternatives: 20k freed
[    0.000965] ACPI: Core revision 20121018
[    0.004087] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043656] smpboot: CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz (fam: 06, model: 2a, stepping: 07)
[    0.043661] TSC deadline timer enabled
[    0.043664] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.043667] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.043669] ... version:                3
[    0.043670] ... bit width:              48
[    0.043670] ... generic registers:      4
[    0.043671] ... value mask:             0000ffffffffffff
[    0.043672] ... max period:             000000007fffffff
[    0.043673] ... fixed-purpose events:   3
[    0.043674] ... event mask:             000000070000000f
[    0.043803] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.135774] Brought up 8 CPUs
[    0.135777] smpboot: Total of 8 processors activated (54275.88 BogoMIPS)
[    0.141871] devtmpfs: initialized
[    0.144255] PM: Registering ACPI NVS region [mem 0xcade7000-0xcafe6fff] (2097152 bytes)
[    0.144294] reboot: PCI series board detected. Selecting Dell OptiPlex 990-method for reboots.
[    0.144360] regulator-dummy: no parameters
[    0.144394] NET: Registered protocol family 16
[    0.144464] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.144466] ACPI: bus type pci registered
[    0.144515] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.144517] PCI: not using MMCONFIG
[    0.144518] PCI: Using configuration type 1 for base access
[    0.144522] dmi type 0xB1 record - unknown flag
[    0.144903] bio: create slab <bio-0> at 0
[    0.144939] ACPI: Added _OSI(Module Device)
[    0.144940] ACPI: Added _OSI(Processor Device)
[    0.144941] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.144942] ACPI: Added _OSI(Processor Aggregator Device)
[    0.145618] ACPI: EC: Look up EC in DSDT
[    0.148121] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.181850] ACPI: SSDT 00000000cadd7798 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    0.182029] ACPI: Dynamic OEM Table Load:
[    0.182030] ACPI: SSDT           (null) 00727 (v01  PmRef  Cpu0Cst 00003001 INTL 20090903)
[    0.197732] ACPI: SSDT 00000000cadd8a98 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    0.197932] ACPI: Dynamic OEM Table Load:
[    0.197933] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20090903)
[    0.213601] ACPI: SSDT 00000000cadd6d98 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    0.213773] ACPI: Dynamic OEM Table Load:
[    0.213774] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20090903)
[    0.230210] ACPI: Interpreter enabled
[    0.230213] ACPI: (supports S0 S3 S4 S5)
[    0.230225] ACPI: Using IOAPIC for interrupt routing
[    0.230236] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.230460] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.262699] ACPI: No dock devices found.
[    0.262702] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.262886] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.262888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.263006] \_SB_.PCI0:_OSC invalid UUID
[    0.263007] _OSC request data:1 8 1f 
[    0.263028] \_SB_.PCI0:_OSC invalid UUID
[    0.263029] _OSC request data:1 1f 1f 
[    0.263031] pci_root PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.263032] pci_root PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.263393] PCI host bridge to bus 0000:00
[    0.263395] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.263397] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.263398] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.263400] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.263401] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeafffff]
[    0.263407] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.263434] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
[    0.263442] pci 0000:00:02.0: reg 10: [mem 0xe0c00000-0xe0ffffff 64bit]
[    0.263446] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.263449] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
[    0.263493] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.263513] pci 0000:00:16.0: reg 10: [mem 0xe1ab0000-0xe1ab000f 64bit]
[    0.263583] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.263611] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.263626] pci 0000:00:19.0: reg 10: [mem 0xe1a00000-0xe1a1ffff]
[    0.263634] pci 0000:00:19.0: reg 14: [mem 0xe1a80000-0xe1a80fff]
[    0.263642] pci 0000:00:19.0: reg 18: [io  0x3080-0x309f]
[    0.263697] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.263719] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.263738] pci 0000:00:1a.0: reg 10: [mem 0xe1a70000-0xe1a703ff]
[    0.263819] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.263843] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.263856] pci 0000:00:1b.0: reg 10: [mem 0xe1a60000-0xe1a63fff 64bit]
[    0.263915] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.263940] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.264068] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.264106] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.264231] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.264271] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.264290] pci 0000:00:1d.0: reg 10: [mem 0xe1a50000-0xe1a503ff]
[    0.264371] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.264391] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.264447] pci 0000:00:1f.0: [8086:1c4e] type 00 class 0x060100
[    0.264560] pci 0000:00:1f.2: [8086:2822] type 00 class 0x010400
[    0.264576] pci 0000:00:1f.2: reg 10: [io  0x30d0-0x30d7]
[    0.264582] pci 0000:00:1f.2: reg 14: [io  0x30c0-0x30c3]
[    0.264589] pci 0000:00:1f.2: reg 18: [io  0x30b0-0x30b7]
[    0.264596] pci 0000:00:1f.2: reg 1c: [io  0x30a0-0x30a3]
[    0.264603] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
[    0.264610] pci 0000:00:1f.2: reg 24: [mem 0xe1a40000-0xe1a407ff]
[    0.264649] pci 0000:00:1f.2: PME# supported from D3hot
[    0.264664] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.264677] pci 0000:00:1f.3: reg 10: [mem 0xe1a30000-0xe1a300ff 64bit]
[    0.264696] pci 0000:00:1f.3: reg 20: [io  0x3040-0x305f]
[    0.264785] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.264870] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.264874] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.264879] pci 0000:00:1c.2:   bridge window [mem 0xe1000000-0xe19fffff]
[    0.264887] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe09fffff 64bit pref]
[    0.264941] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.264949] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.264950] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.264952] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.264953] pci 0000:00:1e.0:   bridge window [mem 0xcfa00000-0xfeafffff] (subtractive decode)
[    0.264973] pci_bus 0000:00: on NUMA node 0
[    0.264988] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.265013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.265045] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.265100] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.266885] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.266914] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.266942] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.266970] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.266998] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.267025] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.267053] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.267080] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.267119] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.267121] vgaarb: loaded
[    0.267122] vgaarb: bridge control possible 0000:00:02.0
[    0.267126] ACPI: bus type usb registered
[    0.267137] usbcore: registered new interface driver usbfs
[    0.267143] usbcore: registered new interface driver hub
[    0.267154] usbcore: registered new device driver usb
[    0.267170] PCI: Using ACPI for IRQ routing
[    0.268521] PCI: pci_cache_line_size set to 64 bytes
[    0.268554] e820: reserve RAM buffer [mem 0x00091800-0x0009ffff]
[    0.268556] e820: reserve RAM buffer [mem 0xca9f7000-0xcbffffff]
[    0.268557] e820: reserve RAM buffer [mem 0xcadb7000-0xcbffffff]
[    0.268558] e820: reserve RAM buffer [mem 0xcb000000-0xcbffffff]
[    0.268559] e820: reserve RAM buffer [mem 0x42e000000-0x42fffffff]
[    0.268627] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.268631] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.270636] Switching to clocksource hpet
[    0.271896] pnp: PnP ACPI init
[    0.271902] ACPI: bus type pnp registered
[    0.271922] pnp 00:00: [dma 4]
[    0.271934] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.271947] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.272004] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.272023] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.272055] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.272056] system 00:04: [io  0xffff] has been reserved
[    0.272058] system 00:04: [io  0xffff] has been reserved
[    0.272059] system 00:04: [io  0xffff] has been reserved
[    0.272061] system 00:04: [io  0x0400-0x0453] has been reserved
[    0.272062] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.272063] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.272065] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.272067] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.272082] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.272110] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.272112] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.272137] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.272303] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.272304] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.272306] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.272307] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.272309] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.272310] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.272312] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.272313] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.272315] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    0.272316] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.272318] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.272346] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.272348] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    0.272349] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.272418] pnp: PnP ACPI: found 10 devices
[    0.272419] ACPI: ACPI bus type pnp unregistered
[    0.277943] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.277961] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.277964] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.277970] pci 0000:00:1c.2:   bridge window [mem 0xe1000000-0xe19fffff]
[    0.277975] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe09fffff 64bit pref]
[    0.277983] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.278012] pci 0000:00:1e.0: setting latency timer to 64
[    0.278015] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.278017] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.278018] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.278020] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.278021] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.278022] pci_bus 0000:02: resource 1 [mem 0xe1000000-0xe19fffff]
[    0.278023] pci_bus 0000:02: resource 2 [mem 0xe0000000-0xe09fffff 64bit pref]
[    0.278025] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.278026] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.278027] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.278029] pci_bus 0000:03: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.278045] NET: Registered protocol family 2
[    0.278122] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.278318] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.278405] TCP: Hash tables configured (established 131072 bind 65536)
[    0.278417] TCP: reno registered
[    0.278420] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.278452] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.278524] NET: Registered protocol family 1
[    0.278781] pci 0000:00:02.0: Boot video device
[    0.278853] PCI: CLS 64 bytes, default 64
[    0.278877] Unpacking initramfs...
[    0.447242] Freeing initrd memory: 11432k freed
[    0.448245] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.448249] software IO TLB [mem 0xc69f7000-0xca9f7000] (64MB) mapped at [ffff8800c69f7000-ffff8800ca9f6fff]
[    0.448278] Simple Boot Flag at 0xf3 set to 0x1
[    0.448605] audit: initializing netlink socket (disabled)
[    0.448617] type=2000 audit(1358861529.440:1): initialized
[    0.457560] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.458314] VFS: Disk quotas dquot_6.5.2
[    0.458340] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.458564] msgmni has been set to 31822
[    0.458708] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.458710] io scheduler noop registered
[    0.458711] io scheduler deadline registered
[    0.458714] io scheduler cfq registered (default)
[    0.458926] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.479279] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.479509] Linux agpgart interface v0.103
[    0.479573] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.479574] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.480363] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.480415] mousedev: PS/2 mouse device common for all mice
[    0.480467] rtc_cmos 00:05: RTC can wake from S4
[    0.480570] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.480595] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    0.480600] cpuidle: using governor ladder
[    0.480601] cpuidle: using governor menu
[    0.480653] drop_monitor: Initializing network drop monitor service
[    0.480702] TCP: cubic registered
[    0.480757] NET: Registered protocol family 10
[    0.480866] mip6: Mobile IPv6
[    0.480867] NET: Registered protocol family 17
[    0.481027] PM: Hibernation image not present or could not be loaded.
[    0.481031] registered taskstats version 1
[    0.481256] rtc_cmos 00:05: setting system clock to 2013-01-22 13:32:10 UTC (1358861530)
[    0.481867] Freeing unused kernel memory: 528k freed
[    0.481906] Write protecting the kernel read-only data: 6144k
[    0.482388] Freeing unused kernel memory: 216k freed
[    0.483556] Freeing unused kernel memory: 612k freed
[    0.515777] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.519825] udev[85]: starting version 164
[    0.527563] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    0.527565] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    0.527593] e1000e 0000:00:19.0: setting latency timer to 64
[    0.527642] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.527669] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[    0.528348] SCSI subsystem initialized
[    0.528867] ACPI: bus type scsi registered
[    0.529343] libata version 3.00 loaded.
[    0.791225] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 18:03:73:4d:0b:0d
[    0.791228] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.791262] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: E041FF-0FF
[    0.791275] ahci 0000:00:1f.2: version 3.0
[    0.791328] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.791341] ahci 0000:00:1f.2: controller can't do SNTF, turning off CAP_SNTF
[    0.791375] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl RAID mode
[    0.791377] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.791381] ahci 0000:00:1f.2: setting latency timer to 64
[    0.797445] scsi0 : ahci
[    0.797493] scsi1 : ahci
[    0.797529] scsi2 : ahci
[    0.797566] scsi3 : ahci
[    0.797603] scsi4 : ahci
[    0.797639] scsi5 : ahci
[    0.797664] ata1: SATA max UDMA/133 abar m2048@0xe1a40000 port 0xe1a40100 irq 41
[    0.797666] ata2: SATA max UDMA/133 abar m2048@0xe1a40000 port 0xe1a40180 irq 41
[    0.797667] ata3: DUMMY
[    0.797668] ata4: DUMMY
[    0.797668] ata5: DUMMY
[    0.797669] ata6: DUMMY
[    1.116249] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.116271] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.117313] ata1.00: ATA-8: ST3500413AS, JC49, max UDMA/133
[    1.117317] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.117525] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.119020] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.119024] ata1.00: configured for UDMA/133
[    1.119464] ata2.00: ATAPI: HL-DT-ST DVD+-RW GT50N, A101, max UDMA/133
[    1.122232] ata2.00: configured for UDMA/133
[    1.124312] scsi 0:0:0:0: Direct-Access     ATA      ST3500413AS      JC49 PQ: 0 ANSI: 5
[    1.130407] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GT50N    A101 PQ: 0 ANSI: 5
[    1.132127] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.132148] sd 0:0:0:0: [sda] Write Protect is off
[    1.132150] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.132159] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.135534] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.135537] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.135627] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.136523] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.136548] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.141135]  sda: sda1 sda2 < sda5 >
[    1.141312] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.384139] Btrfs loaded
[    1.387126] device-mapper: uevent: version 1.0.3
[    1.387169] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    1.447298] tsc: Refined TSC clocksource calibration: 3392.292 MHz
[    1.447303] Switching to clocksource tsc
[   13.433127] bio: create slab <bio-1> at 1
[   13.564010] bio: create slab <bio-1> at 1
[   13.942429] PM: Starting manual resume from disk
[   13.942432] PM: Hibernation image partition 254:2 present
[   13.942433] PM: Looking for hibernation image.
[   13.942641] PM: Image not found (code -22)
[   13.942641] PM: Hibernation image not present or could not be loaded.
[   13.984951] kjournald starting.  Commit interval 5 seconds
[   13.985016] EXT3-fs (dm-1): mounted filesystem with ordered data mode
[   15.108160] udev[361]: starting version 164
[   15.418429] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   15.427957] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[   15.427961] ACPI: Power Button [PWRB]
[   15.427990] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   15.427992] ACPI: Power Button [PWRF]
[   15.431350] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x25
[   15.445665] ACPI: Requesting acpi_cpufreq
[   15.446032] Monitor-Mwait will be used to enter C-1 state
[   15.446049] Monitor-Mwait will be used to enter C-2 state
[   15.446055] Monitor-Mwait will be used to enter C-3 state
[   15.446064] ACPI: acpi_idle registered with cpuidle
[   15.491465] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   15.644110] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x25
[   15.645003] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x25
[   15.645839] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25
[   15.646652] microcode: CPU4 sig=0x206a7, pf=0x2, revision=0x25
[   15.647478] microcode: CPU5 sig=0x206a7, pf=0x2, revision=0x25
[   15.648289] microcode: CPU6 sig=0x206a7, pf=0x2, revision=0x25
[   15.649091] microcode: CPU7 sig=0x206a7, pf=0x2, revision=0x25
[   15.649929] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   15.857850] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   15.858706] ehci-pci: EHCI PCI platform driver
[   15.858805] ehci-pci 0000:00:1a.0: setting latency timer to 64
[   15.858809] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   15.858813] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   15.858825] ehci-pci 0000:00:1a.0: debug port 2
[   15.862709] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   15.862723] ehci-pci 0000:00:1a.0: irq 16, io mem 0xe1a70000
[   15.874081] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   15.874111] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   15.874113] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.874115] usb usb1: Product: EHCI Host Controller
[   15.874116] usb usb1: Manufacturer: Linux 3.8.0-rc4-i7 ehci_hcd
[   15.874117] usb usb1: SerialNumber: 0000:00:1a.0
[   15.874243] hub 1-0:1.0: USB hub found
[   15.874246] hub 1-0:1.0: 2 ports detected
[   15.874354] ehci-pci 0000:00:1d.0: setting latency timer to 64
[   15.874364] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   15.874367] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   15.874377] ehci-pci 0000:00:1d.0: debug port 2
[   15.878257] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   15.878268] ehci-pci 0000:00:1d.0: irq 17, io mem 0xe1a50000
[   15.890000] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   15.890023] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   15.890027] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.890030] usb usb2: Product: EHCI Host Controller
[   15.890033] usb usb2: Manufacturer: Linux 3.8.0-rc4-i7 ehci_hcd
[   15.890035] usb usb2: SerialNumber: 0000:00:1d.0
[   15.890145] hub 2-0:1.0: USB hub found
[   15.890148] hub 2-0:1.0: 2 ports detected
[   15.890229] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20121018/utaddress-251)
[   15.890234] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.890237] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20121018/utaddress-251)
[   15.890241] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.890242] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20121018/utaddress-251)
[   15.890245] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.890246] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20121018/utaddress-251)
[   15.890249] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.890250] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   15.929090] ACPI Warning: 0x0000000000003040-0x000000000000305f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20121018/utaddress-251)
[   15.929098] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   16.185182] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   16.317136] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   16.317141] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   16.317546] hub 1-1:1.0: USB hub found
[   16.317605] hub 1-1:1.0: 6 ports detected
[   16.420059] snd_hda_intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[   16.428448] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   16.501909] hda_codec: ALC269VB: SKU not ready 0x411111f0
[   16.503713] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
[   16.560564] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   16.560569] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   16.560848] hub 2-1:1.0: USB hub found
[   16.560897] hub 2-1:1.0: 8 ports detected
[   16.620000] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[   16.620117] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   16.620226] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   16.620337] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   16.620446] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   16.831393] usb 2-1.1: new low-speed USB device number 3 using ehci-pci
[   16.928015] usb 2-1.1: New USB device found, idVendor=0461, idProduct=4d51
[   16.928020] usb 2-1.1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[   16.928023] usb 2-1.1: Product: DELL Laser Mouse
[   16.998921] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
[   17.090311] input: DELL Laser Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input10
[   17.090460] hid-generic 0003:0461:4D51.0001: input,hidraw0: USB HID v1.11 Mouse [DELL Laser Mouse] on usb-0000:00:1d.0-1.1/input0
[   17.090481] usbcore: registered new interface driver usbhid
[   17.090483] usbhid: USB HID core driver
[   17.106371] usb 2-1.2: New USB device found, idVendor=413c, idProduct=2106
[   17.106376] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   17.106380] usb 2-1.2: Product: Dell QuietKey Keyboard
[   17.106382] usb 2-1.2: Manufacturer: Dell
[   17.115713] input: Dell Dell QuietKey Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input11
[   17.115968] hid-generic 0003:413C:2106.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell QuietKey Keyboard] on usb-0000:00:1d.0-1.2/input0
[   17.186377] usb 2-1.7: new full-speed USB device number 5 using ehci-pci
[   17.286241] usb 2-1.7: New USB device found, idVendor=0529, idProduct=0600
[   17.286247] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   17.286250] usb 2-1.7: Product: Token 4.28.1.1 2.7.195
[   17.286253] usb 2-1.7: Manufacturer: Aladdin Knowledge Systems Ltd.
[   17.609501] EXT3-fs (dm-1): using internal journal
[   17.820598] loop: module loaded
[   18.158159] Adding 19779580k swap on /dev/mapper/i7-swap_1.  Priority:-1 extents:1 across:19779580k 
[   19.746938] fuse init (API version 7.20)
[   20.389257] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   20.440552] thinkpad_ec: no ThinkPad embedded controller!
[   20.492924] e1000e 0000:00:19.0: irq 40 for MSI/MSI-X
[   20.493064] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.654504] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   20.654619] DECnet: Routing cache hash table of 1024 buckets, 16Kbytes
[   20.654625] NET: Registered protocol family 12
[   24.264851] sshd (1452): /proc/1452/oom_adj is deprecated, please use /proc/1452/oom_score_adj instead.
[   24.635546] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   24.635598] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.391891] Netfilter messages via NETLINK v0.30.
[   27.886795] ip_tables: (C) 2000-2006 Netfilter Core Team
[   30.918115] [drm] Initialized drm 1.1.0 20060810
[   31.067478] [drm] Memory usable by graphics device = 2048M
[   31.067484] i915 0000:00:02.0: setting latency timer to 64
[   31.081777] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[   31.081791] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   31.081791] [drm] Driver supports precise vblank timestamp query.
[   31.081812] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   31.285610] lp: driver loaded but no devices found
[   31.319526] ppdev: user-space parallel port driver
[   31.387732] parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
[   31.513481] parport0: irq 7 detected
[   31.584811] fbcon: inteldrmfb (fb0) is primary device
[   31.584902] Console: switching to colour frame buffer device 160x64
[   31.584906] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   31.584908] i915 0000:00:02.0: registered panic notifier
[   31.585398] acpi device:01: registered as cooling_device8
[   31.585572] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   31.585615] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input12
[   31.585680] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   31.609366] lp0: using parport0 (polling).
[   32.650263] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   49.110732] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3.8-rc4-proc-bus-input-devices.txt"

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input0
U: Uniq=
H: Handlers=sysrq kbd event0 
B: PROP=0
B: EV=120013
B: KEY=500f02902002 8380307cf910f001 feffffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: PROP=0
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
U: Uniq=
H: Handlers=kbd event2 
B: PROP=0
B: EV=3
B: KEY=10000000000000 0

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input3
U: Uniq=
H: Handlers=kbd event3 
B: PROP=0
B: EV=40001
B: SND=6

I: Bus=0001 Vendor=10ec Product=0269 Version=0001
N: Name="HDA Digital PCBeep"
P: Phys=card0/codec#0/beep0
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/input/input4
U: Uniq=
H: Handlers=kbd event4 
B: PROP=0
B: EV=40001
B: SND=6

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH HDMI/DP,pcm=3"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input5
U: Uniq=
H: Handlers=event5 
B: PROP=0
B: EV=21
B: SW=140

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Front Mic"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
U: Uniq=
H: Handlers=event6 
B: PROP=0
B: EV=21
B: SW=10

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Rear Mic"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
U: Uniq=
H: Handlers=event7 
B: PROP=0
B: EV=21
B: SW=10

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Front Headphone"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
U: Uniq=
H: Handlers=event8 
B: PROP=0
B: EV=21
B: SW=4

I: Bus=0000 Vendor=0000 Product=0000 Version=0000
N: Name="HDA Intel PCH Line Out"
P: Phys=ALSA
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
U: Uniq=
H: Handlers=event9 
B: PROP=0
B: EV=21
B: SW=40

I: Bus=0003 Vendor=0461 Product=4d51 Version=0111
N: Name="DELL Laser Mouse"
P: Phys=usb-0000:00:1d.0-1.1/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input10
U: Uniq=
H: Handlers=mouse0 event10 
B: PROP=0
B: EV=17
B: KEY=1f0000 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0003 Vendor=413c Product=2106 Version=0110
N: Name="Dell Dell QuietKey Keyboard"
P: Phys=usb-0000:00:1d.0-1.2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input11
U: Uniq=
H: Handlers=sysrq kbd event11 
B: PROP=0
B: EV=120013
B: KEY=1000000000007 ff9f207ac14057ff febeffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=LNXVIDEO/video/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input12
U: Uniq=
H: Handlers=kbd event12 
B: PROP=0
B: EV=3
B: KEY=3e000b00000000 0 0 0


--tThc/1wpZn/ma/RB--
