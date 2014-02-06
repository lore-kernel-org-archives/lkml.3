Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaBFX1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:27:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38839 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaBFX1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:27:09 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Fri, 07 Feb 2014 00:27:03 +0100
Message-ID: <1396879.yH0LySDBlU@al>
User-Agent: KMail/4.12.2 (Linux/3.13.1-2.1-ARCH; KDE/4.12.2; x86_64; ; )
In-Reply-To: <55671594.HynIX0trOC@vostro.rjw.lan>
References: <52F2CC7B.80406@gmail.com> <5898085.IKVHQGKOYn@al> <55671594.HynIX0trOC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014 00:28:57 Rafael J. Wysocki wrote:
> On Thursday, February 06, 2014 10:08:25 PM Peter Wu wrote:
[..]
> > I also have an affected laptop where the network and MMC controller
> > vanishes on resume. The laptop is also from Clevo, but a different
> > model: Clevo B7130. I had no issues with my custom kernel
> > configuration (latest version that I tested was 3.13.1), but at least
> > the stock Arch kernels from 3.12.2 up to 3.12.6 and 3.13.1 are
> > affected by this issue.
[..]
> Well, I suspected that it would result from hotplug changes.
> 
> Please send me a dmesg log including the suspend-resume cycle after which
> the device is missing.

Please find it below. The only details I have stripped are UUID and
MAC addresses. Let me know if you need more information.

Thanks,
Peter

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.1-2-ARCH (nobody@mnt-chroots-arch-extra-x86_64-flo-64) (gcc version 4.8.2 20131219 (prerelease) (GCC) ) #1 SMP PREEMPT Fri Jan 31 10:48:18 CET 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=[STRIPPED] rw quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b327bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b327c000-0x00000000b3281fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b3282000-0x00000000b33d5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b33d6000-0x00000000b340efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b340f000-0x00000000b345cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b345d000-0x00000000b345dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b345e000-0x00000000b34defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b34df000-0x00000000b370efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b370f000-0x00000000b3716fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b3717000-0x00000000b371efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b371f000-0x00000000b376efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b376f000-0x00000000b379efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b379f000-0x00000000b37e0fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b37e1000-0x00000000b37fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b37ff000-0x00000000b37fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b3800000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd80a000-0x00000000fd80afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feaff000-0x00000000feafffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001fbffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000200000000-0x000000023bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 disabled
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask FC0000000 write-back
[    0.000000]   5 base 23C000000 mask FFC000000 uncachable
[    0.000000]   6 base 0B4000000 mask FFC000000 uncachable
[    0.000000]   7 base 0B8000000 mask FF8000000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xb4000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xb3800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f6900-0x000f690f] mapped at [ffff8800000f6900]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b3e000, 0x01b3efff] PGTABLE
[    0.000000] BRK [0x01b3f000, 0x01b3ffff] PGTABLE
[    0.000000] BRK [0x01b40000, 0x01b40fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23be00000-0x23bffffff]
[    0.000000]  [mem 0x23be00000-0x23bffffff] page 2M
[    0.000000] BRK [0x01b41000, 0x01b41fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x238000000-0x23bdfffff]
[    0.000000]  [mem 0x238000000-0x23bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x237ffffff]
[    0.000000]  [mem 0x200000000-0x237ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xb327bfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xb31fffff] page 2M
[    0.000000]  [mem 0xb3200000-0xb327bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xb3282000-0xb33d5fff]
[    0.000000]  [mem 0xb3282000-0xb33d5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xb340f000-0xb345cfff]
[    0.000000]  [mem 0xb340f000-0xb345cfff] page 4k
[    0.000000] BRK [0x01b42000, 0x01b42fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xb370f000-0xb3716fff]
[    0.000000]  [mem 0xb370f000-0xb3716fff] page 4k
[    0.000000] BRK [0x01b43000, 0x01b43fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xb371f000-0xb376efff]
[    0.000000]  [mem 0xb371f000-0xb376efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xb379f000-0xb37e0fff]
[    0.000000]  [mem 0xb379f000-0xb37e0fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xb37ff000-0xb37fffff]
[    0.000000]  [mem 0xb37ff000-0xb37fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1fbffffff]
[    0.000000]  [mem 0x100000000-0x1fbffffff] page 2M
[    0.000000] RAMDISK: [mem 0x37622000-0x37b08fff]
[    0.000000] ACPI: RSDP 00000000000f6840 000024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000b37f5b01 00006C (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000b37e3000 0000F4 (v03 INTEL  CALPELLA 06040000 PTEC 00000001)
[    0.000000] ACPI: DSDT 00000000b37e4000 0090EB (v02 Intel  CALPELLA 06040000 INTL 20060912)
[    0.000000] ACPI: FACS 00000000b379bfc0 000040
[    0.000000] ACPI: HPET 00000000b37fedf0 000038 (v01 INTEL  CALPELLA 06040000 PTEC 00000001)
[    0.000000] ACPI: MCFG 00000000b37fee28 00003C (v01 INTEL  CALPELLA 06040000 PTEC 00000001)
[    0.000000] ACPI: APIC 00000000b37fee64 000084 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000b37feee8 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000b37fef10 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: ASF! 00000000b37fef60 0000A0 (v16   CETP     CETP 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000b37ee000 0010DE (v01 NvdRef  NvdTabl 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000b37e2000 0009F1 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23bffffff]
[    0.000000]   NODE_DATA [mem 0x23bff4000-0x23bff8fff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233800000-ffff88023b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xb327bfff]
[    0.000000]   node   0: [mem 0xb3282000-0xb33d5fff]
[    0.000000]   node   0: [mem 0xb340f000-0xb345cfff]
[    0.000000]   node   0: [mem 0xb370f000-0xb3716fff]
[    0.000000]   node   0: [mem 0xb371f000-0xb376efff]
[    0.000000]   node   0: [mem 0xb379f000-0xb37e0fff]
[    0.000000]   node   0: [mem 0xb37ff000-0xb37fffff]
[    0.000000]   node   0: [mem 0x100000000-0x1fbffffff]
[    0.000000]   node   0: [mem 0x200000000-0x23bffffff]
[    0.000000] On node 0 totalpages: 2012244
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11411 pages used for memmap
[    0.000000]   DMA32 zone: 730297 pages, LIFO batch:31
[    0.000000]   Normal zone: 20224 pages used for memmap
[    0.000000]   Normal zone: 1277952 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb327c000-0xb3281fff]
[    0.000000] PM: Registered nosave memory: [mem 0xb33d6000-0xb340efff]
[    0.000000] PM: Registered nosave memory: [mem 0xb345d000-0xb345dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xb345e000-0xb34defff]
[    0.000000] PM: Registered nosave memory: [mem 0xb34df000-0xb370efff]
[    0.000000] PM: Registered nosave memory: [mem 0xb3717000-0xb371efff]
[    0.000000] PM: Registered nosave memory: [mem 0xb376f000-0xb379efff]
[    0.000000] PM: Registered nosave memory: [mem 0xb37e1000-0xb37fefff]
[    0.000000] PM: Registered nosave memory: [mem 0xb3800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfd809fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd80a000-0xfd80afff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd80b000-0xfeafefff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeaff000-0xfeafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb00000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1fc000000-0x1ffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88023bc00000 s86336 r8192 d24256 u524288
[    0.000000] pcpu-alloc: s86336 r8192 d24256 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1980524
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=[STRIPPED] rw quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7836496K/8048976K available (5269K kernel code, 836K rwdata, 1672K rodata, 1124K init, 1324K bss, 212480K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:8448 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33030144 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 2526.904 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5055.38 BogoMIPS (lpj=8423013)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000031] Security Framework initialized
[    0.000042] AppArmor: AppArmor disabled by boot time parameter
[    0.000043] Yama: becoming mindful.
[    0.000544] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002412] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003253] Mount-cache hash table entries: 256
[    0.003436] Initializing cgroup subsys memory
[    0.003442] Initializing cgroup subsys devices
[    0.003444] Initializing cgroup subsys freezer
[    0.003446] Initializing cgroup subsys net_cls
[    0.003448] Initializing cgroup subsys blkio
[    0.003468] CPU: Physical Processor ID: 0
[    0.003469] CPU: Processor Core ID: 0
[    0.003474] mce: CPU supports 9 MCE banks
[    0.003483] CPU0: Thermal monitoring handled by SMI
[    0.003493] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 6
[    0.003575] Freeing SMP alternatives memory: 20K (ffffffff819ec000 - ffffffff819f1000)
[    0.004526] ACPI: Core revision 20131115
[    0.008791] ACPI: All ACPI Tables successfully acquired
[    0.018551] ftrace: allocating 21048 entries in 83 pages
[    0.028871] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061857] smpboot: CPU0: Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz (fam: 06, model: 25, stepping: 05)
[    0.165735] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.165742] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.165744] ... version:                3
[    0.165745] ... bit width:              48
[    0.165746] ... generic registers:      4
[    0.165747] ... value mask:             0000ffffffffffff
[    0.165748] ... max period:             000000007fffffff
[    0.165748] ... fixed-purpose events:   3
[    0.165749] ... event mask:             000000070000000f
[    0.192463] x86: Booting SMP configuration:
[    0.203600] CPU1: Thermal monitoring handled by SMI
[    0.205785] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.223589] CPU2: Thermal monitoring handled by SMI
[    0.243581] CPU3: Thermal monitoring handled by SMI
[    0.192467] .... node  #0, CPUs:      #1 #2 #3
[    0.245706] x86: Booted up 1 node, 4 CPUs
[    0.245710] smpboot: Total of 4 processors activated (20223.53 BogoMIPS)
[    0.248233] devtmpfs: initialized
[    0.250806] PM: Registering ACPI NVS region [mem 0xb345e000-0xb34defff] (528384 bytes)
[    0.250816] PM: Registering ACPI NVS region [mem 0xb376f000-0xb379efff] (196608 bytes)
[    0.251699] RTC time: 16:10:25, date: 02/06/14
[    0.251737] NET: Registered protocol family 16
[    0.251831] cpuidle: using governor ladder
[    0.251832] cpuidle: using governor menu
[    0.251857] ACPI: bus type PCI registered
[    0.251859] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.251923] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.251926] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.275399] PCI: Using configuration type 1 for base access
[    0.275561] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.275562] mtrr: probably your BIOS does not setup all CPUs.
[    0.275563] mtrr: corrected configuration.
[    0.275952] bio: create slab <bio-0> at 0
[    0.276059] ACPI: Added _OSI(Module Device)
[    0.276061] ACPI: Added _OSI(Processor Device)
[    0.276062] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.276063] ACPI: Added _OSI(Processor Aggregator Device)
[    0.280968] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.281277] ACPI: SSDT 00000000b371a918 000432 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.281529] ACPI: Dynamic OEM Table Load:
[    0.281531] ACPI: SSDT           (null) 000432 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.281631] ACPI: SSDT 00000000b3718018 0008B0 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.281867] ACPI: Dynamic OEM Table Load:
[    0.281869] ACPI: SSDT           (null) 0008B0 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.302548] ACPI: SSDT 00000000b3719a98 000303 (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.302835] ACPI: Dynamic OEM Table Load:
[    0.302837] ACPI: SSDT           (null) 000303 (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.315765] ACPI: SSDT 00000000b3717d98 000119 (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.316024] ACPI: Dynamic OEM Table Load:
[    0.316026] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.329959] ACPI : EC: GPE storm detected(19 GPEs), transactions will use polling mode
[    0.812117] ACPI: Interpreter enabled
[    0.812131] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.812140] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.812160] ACPI: (supports S0 S3 S4 S5)
[    0.812162] ACPI: Using IOAPIC for interrupt routing
[    0.812193] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.812291] ACPI: No dock devices found.
[    0.902697] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.902702] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.902731] \_SB_.PCI0:_OSC invalid UUID
[    0.902732] _OSC request data:1 1f 0 
[    0.902735] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.903366] PCI host bridge to bus 0000:00
[    0.903369] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.903371] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.903372] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.903374] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.903375] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.903377] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.903378] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.903379] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeafffff]
[    0.903387] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.903404] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.903476] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
[    0.903506] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.903551] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.903577] pci 0000:00:02.0: [8086:0046] type 00 class 0x030000
[    0.903587] pci 0000:00:02.0: reg 0x10: [mem 0xfd000000-0xfd3fffff 64bit]
[    0.903593] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.903597] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
[    0.903698] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.903724] pci 0000:00:16.0: reg 0x10: [mem 0xfd804000-0xfd80400f 64bit]
[    0.903813] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.903894] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.903912] pci 0000:00:1a.0: reg 0x10: [mem 0xfd806000-0xfd8063ff]
[    0.903990] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.904050] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.904085] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.904099] pci 0000:00:1b.0: reg 0x10: [mem 0xfd800000-0xfd803fff 64bit]
[    0.904156] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.904204] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.904232] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.904290] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.904337] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.904365] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.904423] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.904470] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.904499] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.904556] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.904604] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.904641] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.904659] pci 0000:00:1d.0: reg 0x10: [mem 0xfd807000-0xfd8073ff]
[    0.904737] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.904795] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.904823] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.904904] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.904934] pci 0000:00:1f.0: [8086:3b09] type 00 class 0x060100
[    0.905094] pci 0000:00:1f.2: [8086:3b29] type 00 class 0x010601
[    0.905110] pci 0000:00:1f.2: reg 0x10: [io  0x1818-0x181f]
[    0.905116] pci 0000:00:1f.2: reg 0x14: [io  0x180c-0x180f]
[    0.905123] pci 0000:00:1f.2: reg 0x18: [io  0x1810-0x1817]
[    0.905129] pci 0000:00:1f.2: reg 0x1c: [io  0x1808-0x180b]
[    0.905136] pci 0000:00:1f.2: reg 0x20: [io  0x1820-0x183f]
[    0.905142] pci 0000:00:1f.2: reg 0x24: [mem 0xfd808000-0xfd8087ff]
[    0.905181] pci 0000:00:1f.2: PME# supported from D3hot
[    0.905250] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.905263] pci 0000:00:1f.3: reg 0x10: [mem 0xfd809000-0xfd8090ff 64bit]
[    0.905281] pci 0000:00:1f.3: reg 0x20: [io  0x1840-0x185f]
[    0.905368] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.905388] pci 0000:00:1f.6: reg 0x10: [mem 0xfd80a000-0xfd80afff 64bit]
[    0.905554] pci 0000:01:00.0: [10de:0df0] type 00 class 0x030000
[    0.905562] pci 0000:01:00.0: reg 0x10: [mem 0xfb000000-0xfbffffff]
[    0.905570] pci 0000:01:00.0: reg 0x14: [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.905578] pci 0000:01:00.0: reg 0x1c: [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.905583] pci 0000:01:00.0: reg 0x24: [io  0x2000-0x207f]
[    0.905589] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.905664] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.905667] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.905669] pci 0000:00:01.0:   bridge window [mem 0xfb000000-0xfbffffff]
[    0.905672] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf9ffffff 64bit pref]
[    0.905743] pci 0000:02:00.0: [1033:0194] type 00 class 0x0c0330
[    0.905769] pci 0000:02:00.0: reg 0x10: [mem 0xfc000000-0xfc001fff 64bit]
[    0.905894] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.905926] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.915314] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.915321] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.915326] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfcffffff]
[    0.915334] pci 0000:00:1c.0:   bridge window [mem 0xfa000000-0xfaffffff 64bit pref]
[    0.915437] pci 0000:04:00.0: [197b:2382] type 00 class 0x088000
[    0.915455] pci 0000:04:00.0: reg 0x10: [mem 0xfd404000-0xfd4040ff]
[    0.915633] pci 0000:04:00.2: [197b:2381] type 00 class 0x080501
[    0.915651] pci 0000:04:00.2: reg 0x10: [mem 0xfd405000-0xfd4050ff]
[    0.915824] pci 0000:04:00.3: [197b:2383] type 00 class 0x088000
[    0.915842] pci 0000:04:00.3: reg 0x10: [mem 0xfd406000-0xfd4060ff]
[    0.916016] pci 0000:04:00.5: [197b:0250] type 00 class 0x020000
[    0.916034] pci 0000:04:00.5: reg 0x10: [mem 0xfd400000-0xfd403fff]
[    0.916058] pci 0000:04:00.5: reg 0x18: [io  0x4400-0x447f]
[    0.916070] pci 0000:04:00.5: reg 0x1c: [io  0x4000-0x40ff]
[    0.916170] pci 0000:04:00.5: PME# supported from D0 D3hot D3cold
[    0.925312] pci 0000:00:1c.1: PCI bridge to [bus 04]
[    0.925318] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.925324] pci 0000:00:1c.1:   bridge window [mem 0xfd400000-0xfd4fffff]
[    0.925470] pci 0000:05:00.0: [8086:422c] type 00 class 0x028000
[    0.925522] pci 0000:05:00.0: reg 0x10: [mem 0xfd500000-0xfd501fff 64bit]
[    0.925697] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.925751] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.935327] pci 0000:00:1c.2: PCI bridge to [bus 05]
[    0.935335] pci 0000:00:1c.2:   bridge window [mem 0xfd500000-0xfd5fffff]
[    0.935433] pci 0000:00:1e.0: PCI bridge to [bus 06] (subtractive decode)
[    0.935441] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.935443] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.935445] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.935446] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.935447] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.935449] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.935450] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfeafffff] (subtractive decode)
[    0.935872] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    0.935917] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.935960] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.936005] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.936048] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.936091] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.936135] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.936178] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.952031] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.952039] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.952047] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.952116] PCI host bridge to bus 0000:ff
[    0.952118] pci_bus 0000:ff: root bus resource [bus ff]
[    0.952122] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    0.952159] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.952198] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.952231] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.952265] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.952298] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.952462] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.952468] ACPI: \_SB_.PCI0: notify handler is installed
[    0.952500] ACPI: \_SB_.CPBG: notify handler is installed
[    0.952505] Found 2 acpi root devices
[    0.952644] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.952735] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.952739] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.952741] vgaarb: loaded
[    0.952742] vgaarb: bridge control possible 0000:01:00.0
[    0.952743] vgaarb: no bridge control possible 0000:00:02.0
[    0.952776] PCI: Using ACPI for IRQ routing
[    0.958136] PCI: pci_cache_line_size set to 64 bytes
[    0.958239] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    0.958241] e820: reserve RAM buffer [mem 0xb327c000-0xb3ffffff]
[    0.958242] e820: reserve RAM buffer [mem 0xb33d6000-0xb3ffffff]
[    0.958244] e820: reserve RAM buffer [mem 0xb345d000-0xb3ffffff]
[    0.958246] e820: reserve RAM buffer [mem 0xb3717000-0xb3ffffff]
[    0.958247] e820: reserve RAM buffer [mem 0xb376f000-0xb3ffffff]
[    0.958249] e820: reserve RAM buffer [mem 0xb37e1000-0xb3ffffff]
[    0.958250] e820: reserve RAM buffer [mem 0xb3800000-0xb3ffffff]
[    0.958335] NetLabel: Initializing
[    0.958336] NetLabel:  domain hash size = 128
[    0.958337] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.958352] NetLabel:  unlabeled traffic allowed by default
[    0.958370] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.958374] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.960397] Switched to clocksource hpet
[    0.964499] pnp: PnP ACPI init
[    0.964518] ACPI: bus type PNP registered
[    0.964591] pnp 00:00: [dma 4]
[    0.964613] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.964633] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.964730] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.964756] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.964809] system 00:04: [io  0x0500-0x050f] has been reserved
[    0.964811] system 00:04: [io  0x0600-0x0603] has been reserved
[    0.964813] system 00:04: [io  0xffff] has been reserved
[    0.964815] system 00:04: [io  0x0400-0x047f] could not be reserved
[    0.964817] system 00:04: [io  0x1180-0x11ff] has been reserved
[    0.964818] system 00:04: [io  0xfe00] has been reserved
[    0.964821] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.964862] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.964889] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.964933] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.965228] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.965230] system 00:08: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.965232] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.965234] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.965235] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.965237] system 00:08: [mem 0xfeaff000-0xfeafffff] has been reserved
[    0.965239] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.965241] system 00:08: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.965242] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.965244] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.965246] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.965248] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.977100] pnp: PnP ACPI: found 9 devices
[    0.977103] ACPI: bus type PNP unregistered
[    0.983583] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.983591] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 05] add_size 1000
[    0.983593] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 05] add_size 200000
[    0.983603] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.983605] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.983606] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.983611] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.983613] pci 0000:00:1c.2: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.983615] pci 0000:00:1c.2: BAR 13: assigned [io  0x5000-0x5fff]
[    0.983619] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x80000)
[    0.983621] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.983624] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.983626] pci 0000:00:01.0:   bridge window [mem 0xfb000000-0xfbffffff]
[    0.983628] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf9ffffff 64bit pref]
[    0.983632] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.983634] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.983638] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfcffffff]
[    0.983641] pci 0000:00:1c.0:   bridge window [mem 0xfa000000-0xfaffffff 64bit pref]
[    0.983645] pci 0000:00:1c.1: PCI bridge to [bus 04]
[    0.983648] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.983651] pci 0000:00:1c.1:   bridge window [mem 0xfd400000-0xfd4fffff]
[    0.983654] pci 0000:00:1c.1:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.983659] pci 0000:00:1c.2: PCI bridge to [bus 05]
[    0.983661] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
[    0.983665] pci 0000:00:1c.2:   bridge window [mem 0xfd500000-0xfd5fffff]
[    0.983668] pci 0000:00:1c.2:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.983673] pci 0000:00:1e.0: PCI bridge to [bus 06]
[    0.983682] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.983683] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.983685] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.983686] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.983688] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.983689] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.983691] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfeafffff]
[    0.983692] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.983694] pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfbffffff]
[    0.983695] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf9ffffff 64bit pref]
[    0.983697] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.983699] pci_bus 0000:02: resource 1 [mem 0xfc000000-0xfcffffff]
[    0.983700] pci_bus 0000:02: resource 2 [mem 0xfa000000-0xfaffffff 64bit pref]
[    0.983702] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[    0.983703] pci_bus 0000:04: resource 1 [mem 0xfd400000-0xfd4fffff]
[    0.983705] pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.983707] pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
[    0.983708] pci_bus 0000:05: resource 1 [mem 0xfd500000-0xfd5fffff]
[    0.983710] pci_bus 0000:05: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.983711] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.983713] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.983714] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.983720] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.983722] pci_bus 0000:06: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.983723] pci_bus 0000:06: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.983725] pci_bus 0000:06: resource 10 [mem 0xc0000000-0xfeafffff]
[    0.983759] NET: Registered protocol family 2
[    0.983925] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.984078] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.984274] TCP: Hash tables configured (established 65536 bind 65536)
[    0.984308] TCP: reno registered
[    0.984318] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.984350] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.984430] NET: Registered protocol family 1
[    0.984445] pci 0000:00:02.0: Boot video device
[    0.985087] PCI: CLS 64 bytes, default 64
[    0.985140] Unpacking initramfs...
[    1.067559] Freeing initrd memory: 5020K (ffff880037622000 - ffff880037b09000)
[    1.067566] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.067569] software IO TLB [mem 0xaf27c000-0xb327c000] (64MB) mapped at [ffff8800af27c000-ffff8800b327bfff]
[    1.067595] Simple Boot Flag at 0x36 set to 0x80
[    1.067753] Scanning for low memory corruption every 60 seconds
[    1.068019] audit: initializing netlink socket (disabled)
[    1.068037] type=2000 audit(1391703024.956:1): initialized
[    1.078847] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.080032] zbud: loaded
[    1.080174] VFS: Disk quotas dquot_6.5.2
[    1.080209] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.080366] msgmni has been set to 15315
[    1.080413] Key type big_key registered
[    1.080617] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.080650] io scheduler noop registered
[    1.080652] io scheduler deadline registered
[    1.080675] io scheduler cfq registered (default)
[    1.080892] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    1.081197] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.081209] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.081248] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    1.081250] vesafb: scrolling: redraw
[    1.081251] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.081563] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90010e80000, using 3072k, total 3072k
[    1.194893] Console: switching to colour frame buffer device 128x48
[    1.308183] fb0: VESA VGA frame buffer device
[    1.308194] intel_idle: MWAIT substates: 0x1120
[    1.308195] intel_idle: v0.4 model 0x25
[    1.308196] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.308314] GHES: HEST is not enabled!
[    1.308360] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.308682] Linux agpgart interface v0.103
[    1.308841] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.308871] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.308948] drop_monitor: Initializing network drop monitor service
[    1.308997] TCP: cubic registered
[    1.309073] NET: Registered protocol family 10
[    1.309212] NET: Registered protocol family 17
[    1.309220] Key type dns_resolver registered
[    1.309414] registered taskstats version 1
[    1.310174]   Magic number: 2:737:185
[    1.310277] rtc_cmos 00:05: setting system clock to 2014-02-06 16:10:26 UTC (1391703026)
[    1.310332] PM: Hibernation image not present or could not be loaded.
[    1.311344] Freeing unused kernel memory: 1124K (ffffffff818d3000 - ffffffff819ec000)
[    1.311345] Write protecting the kernel read-only data: 8192k
[    1.313315] Freeing unused kernel memory: 864K (ffff880001528000 - ffff880001600000)
[    1.314198] Freeing unused kernel memory: 376K (ffff8800017a2000 - ffff880001800000)
[    1.325398] systemd-udevd[57]: starting version 208
[    1.329220] [drm] Initialized drm 1.1.0 20060810
[    1.329848] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.329926] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.330649] agpgart-intel 0000:00:00.0: detected 131072K stolen memory
[    1.330819] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.331303] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.331309] ACPI: Power Button [PWRB]
[    1.331389] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.331395] ACPI: Sleep Button [SLPB]
[    1.331462] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    1.343634] ACPI: Lid Switch [LID0]
[    1.343729] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.343736] ACPI: Power Button [PWRF]
[    1.352376] [drm] Memory usable by graphics device = 2048M
[    1.352384] checking generic (d0000000 300000) vs hw (d0000000 10000000)
[    1.352387] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[    1.352413] Console: switching to colour dummy device 80x25
[    1.433670] i915 0000:00:02.0: irq 41 for MSI/MSI-X
[    1.433684] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.433686] [drm] Driver supports precise vblank timestamp query.
[    1.433876] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=none
[    1.476636] fbcon: inteldrmfb (fb0) is primary device
[    2.069852] tsc: Refined TSC clocksource calibration: 2526.999 MHz
[    2.233133] Console: switching to colour frame buffer device 200x56
[    2.241055] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.241058] i915 0000:00:02.0: registered panic notifier
[    2.241123] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20131115/video-1111)
[    2.241131] ACPI: Video Device [PEGP] (multi-head: no  rom: yes  post: no)
[    2.241215] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input4
[    2.241304] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.366440] acpi device:06: registered as cooling_device0
[    2.366541] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
[    2.366594] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.387976] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.393983] i8042: Detected active multiplexing controller, rev 1.1
[    2.397356] ACPI: bus type USB registered
[    2.397406] usbcore: registered new interface driver usbfs
[    2.397422] usbcore: registered new interface driver hub
[    2.397426] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.397493] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.397537] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.397577] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.397589] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.398375] usbcore: registered new device driver usb
[    2.398901] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.399059] ehci-pci: EHCI PCI platform driver
[    2.399729] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.399751] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.399766] ehci-pci 0000:00:1a.0: debug port 2
[    2.403787] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.403823] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfd806000
[    2.405808] SCSI subsystem initialized
[    2.407225] libata version 3.00 loaded.
[    2.412961] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.413651] hub 1-0:1.0: USB hub found
[    2.413672] hub 1-0:1.0: 3 ports detected
[    2.413882] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    2.413890] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
[    2.414107] xhci_hcd 0000:02:00.0: irq 42 for MSI/MSI-X
[    2.414116] xhci_hcd 0000:02:00.0: irq 43 for MSI/MSI-X
[    2.414123] xhci_hcd 0000:02:00.0: irq 44 for MSI/MSI-X
[    2.414130] xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
[    2.414136] xhci_hcd 0000:02:00.0: irq 46 for MSI/MSI-X
[    2.414533] hub 2-0:1.0: USB hub found
[    2.414548] hub 2-0:1.0: 2 ports detected
[    2.414679] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    2.414684] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    2.417464] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.417610] hub 3-0:1.0: USB hub found
[    2.417625] hub 3-0:1.0: 2 ports detected
[    2.417870] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.417883] ehci-pci 0000:00:1d.0: debug port 2
[    2.421840] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.421861] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfd807000
[    2.429725] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.430511] hub 4-0:1.0: USB hub found
[    2.430522] hub 4-0:1.0: 3 ports detected
[    2.430661] ahci 0000:00:1f.2: version 3.0
[    2.430875] ahci 0000:00:1f.2: irq 47 for MSI/MSI-X
[    2.430913] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    2.430941] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x13 impl SATA mode
[    2.430946] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    2.443413] scsi0 : ahci
[    2.443577] scsi1 : ahci
[    2.443711] scsi2 : ahci
[    2.443856] scsi3 : ahci
[    2.443996] scsi4 : ahci
[    2.444035] ata1: SATA max UDMA/133 abar m2048@0xfd808000 port 0xfd808100 irq 47
[    2.444038] ata2: SATA max UDMA/133 abar m2048@0xfd808000 port 0xfd808180 irq 47
[    2.444039] ata3: DUMMY
[    2.444040] ata4: DUMMY
[    2.444041] ata5: SATA max UDMA/133 abar m2048@0xfd808000 port 0xfd808300 irq 47
[    2.467326] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
[    2.719581] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.762829] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.763250] ata1.00: ATA-8: INTEL SSDSA2CW080G3, 4PC10362, max UDMA/133
[    2.763255] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.763761] ata1.00: configured for UDMA/133
[    2.764087] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2CW08 4PC1 PQ: 0 ANSI: 5
[    2.843547] hub 1-1:1.0: USB hub found
[    2.843689] hub 1-1:1.0: 6 ports detected
[    2.949452] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    3.069509] Switched to clocksource tsc
[    3.073342] hub 4-1:1.0: USB hub found
[    3.073567] hub 4-1:1.0: 8 ports detected
[    3.082623] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.084495] ata2.00: ATAPI: Optiarc DVD RW AD-7700S, 1.03, max UDMA/100
[    3.091322] ata2.00: configured for UDMA/100
[    3.107327] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7700S  1.03 PQ: 0 ANSI: 5
[    3.152799] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    3.244184] hidraw: raw HID events driver (C) Jiri Kosina
[    3.252679] usbcore: registered new interface driver usbhid
[    3.252685] usbhid: USB HID core driver
[    3.256127] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input2
[    3.260005] input: Logitech Unifying Device. Wireless PID:4013 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.0003/input/input11
[    3.260119] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:4013] on usb-0000:00:1a.0-1.1:1
[    3.262174] input: Logitech Unifying Device. Wireless PID:4101 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.0003/input/input12
[    3.262289] logitech-djdevice 0003:046D:C52B.0005: input,hidraw2: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4101] on usb-0000:00:1a.0-1.1:2
[    3.264211] input: Logitech Unifying Device. Wireless PID:4026 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:046D:C52B.0003/input/input13
[    3.264302] logitech-djdevice 0003:046D:C52B.0006: input,hidraw3: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4026] on usb-0000:00:1a.0-1.1:3
[    3.425794] ata5: SATA link down (SStatus 0 SControl 300)
[    3.428951] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    3.429044] sd 0:0:0:0: [sda] Write Protect is off
[    3.429047] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.429073] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.431720]  sda: sda1 sda2 sda3
[    3.433226] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.446074] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.446080] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.446336] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.548641] device-mapper: uevent: version 1.0.3
[    3.548888] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    9.979634] random: cryptsetup urandom read with 106 bits of entropy available
[    9.989549] sha256_ssse3: Using SSSE3 optimized SHA-256 implementation
[   10.022715] bio: create slab <bio-1> at 1
[   10.106621] bio: create slab <bio-1> at 1
[   10.206520] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   10.219703] random: nonblocking pool is initialized
[   10.373291] systemd[1]: systemd 208 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   10.374126] systemd[1]: Set hostname to <al>.
[   10.483286] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   10.483346] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   10.483358] systemd[1]: Starting Remote File Systems.
[   10.483369] systemd[1]: Reached target Remote File Systems.
[   10.483376] systemd[1]: Starting Device-mapper event daemon FIFOs.
[   10.483403] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[   10.483410] systemd[1]: Starting Delayed Shutdown Socket.
[   10.483433] systemd[1]: Listening on Delayed Shutdown Socket.
[   10.483440] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   10.483454] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   10.483461] systemd[1]: Starting LVM2 metadata daemon socket.
[   10.483481] systemd[1]: Listening on LVM2 metadata daemon socket.
[   10.483491] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   10.483514] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   10.483520] systemd[1]: Starting Paths.
[   10.483527] systemd[1]: Reached target Paths.
[   10.483552] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   10.483637] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   10.483649] systemd[1]: Starting udev Kernel Socket.
[   10.483668] systemd[1]: Listening on udev Kernel Socket.
[   10.483677] systemd[1]: Starting udev Control Socket.
[   10.483696] systemd[1]: Listening on udev Control Socket.
[   10.483704] systemd[1]: Starting Journal Socket.
[   10.483733] systemd[1]: Listening on Journal Socket.
[   10.484678] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[   10.488070] systemd[1]: Starting Load Kernel Modules...
[   10.488373] systemd[1]: Starting Setup Virtual Console...
[   10.491969] systemd[1]: Starting Apply Kernel Variables...
[   10.492594] systemd[1]: Mounting POSIX Message Queue File System...
[   10.493274] systemd[1]: Starting udev Coldplug all Devices...
[   10.496132] systemd[1]: Started Set Up Additional Binary Formats.
[   10.496163] systemd[1]: Starting Journal Service...
[   10.496648] systemd[1]: Started Journal Service.
[   10.523528] EXT4-fs (dm-0): re-mounted. Opts: discard
[   10.529947] systemd-journald[175]: Vacuuming done, freed 0 bytes
[   10.623714] systemd-udevd[198]: starting version 208
[   10.723626] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
[   10.723634] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.723638] ACPI Warning: 0x00000000000011c0-0x00000000000011cf SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[   10.723640] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.723641] ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[   10.723644] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.723645] ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[   10.723647] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.723648] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   10.725094] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[   10.725561] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   10.727692] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.758570] ACPI Warning: 0x0000000000001840-0x000000000000185f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20131115/utaddress-251)
[   10.758580] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.774017] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   10.774046] jme 0000:04:00.5: can't disable ASPM; OS doesn't have ASPM control
[   10.779544] sdhci: Secure Digital Host Controller Interface driver
[   10.779547] sdhci: Copyright(c) Pierre Ossman
[   10.791758] cfg80211: Calling CRDA to update world regulatory domain
[   10.801362] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   10.801367] Copyright(c) 2003-2013 Intel Corporation
[   10.822157] mousedev: PS/2 mouse device common for all mice
[   10.836707] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
[   10.839252] platform microcode: Direct firmware load failed with error -2
[   10.839254] platform microcode: Falling back to user helper
[   10.933251] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: discard
[   10.943748] systemd-journald[175]: Received request to flush runtime journal from PID 1
[   11.001989] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   11.003029] jme 0000:04:00.5 eth0: JMC250 Gigabit Ethernet chiprev:23 pcirev:3 macaddr:[STRIPPED]
[   11.019630] iTCO_vendor_support: vendor-support=0
[   11.020427] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   11.020470] iTCO_wdt: Found a HM55 TCO device (Version=2, TCOBASE=0x0460)
[   11.020614] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   11.036203] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input20
[   11.036282] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[   11.036345] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[   11.046710] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x2
[   11.046729] platform microcode: Direct firmware load failed with error -2
[   11.046732] platform microcode: Falling back to user helper
[   11.051661] iwlwifi 0000:05:00.0: can't disable ASPM; OS doesn't have ASPM control
[   11.051820] iwlwifi 0000:05:00.0: irq 49 for MSI/MSI-X
[   11.052017] iwlwifi 0000:05:00.0: Direct firmware load failed with error -2
[   11.052021] iwlwifi 0000:05:00.0: Falling back to user helper
[   11.064016] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
[   11.064036] platform microcode: Direct firmware load failed with error -2
[   11.064039] platform microcode: Falling back to user helper
[   11.069500] iwlwifi 0000:05:00.0: Direct firmware load failed with error -2
[   11.069506] iwlwifi 0000:05:00.0: Falling back to user helper
[   11.070294] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x2
[   11.070309] platform microcode: Direct firmware load failed with error -2
[   11.070312] platform microcode: Falling back to user helper
[   11.070974] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   11.083320] iwlwifi 0000:05:00.0: loaded firmware version 9.221.4.1 build 25532 op_mode iwldvm
[   11.110900] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   11.119403] iwlwifi 0000:05:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   11.119407] iwlwifi 0000:05:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   11.119409] iwlwifi 0000:05:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   11.119411] iwlwifi 0000:05:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[   11.119507] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
[   11.139254] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   11.228514] sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 80)
[   11.381919] mmc0: SDHCI controller on PCI [0000:04:00.0] using ADMA
[   11.381940] sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 80)
[   11.444730] sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
[   11.461899] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   11.481358] thermal LNXTHERM:00: registered as thermal_zone0
[   11.481363] ACPI: Thermal Zone [TZ0] (46 C)
[   11.499940] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.500550] tun: Universal TUN/TAP device driver, 1.6
[   11.500553] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.506554] sit: IPv6 over IPv4 tunneling driver
[   11.517628] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.536659] type=1006 audit(1391703036.726:2): pid=292 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1 res=1
[   11.582300] Netfilter messages via NETLINK v0.30.
[   11.586980] ip_set: protocol 6
[   11.733632] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 582762
[   11.737934] ACPI: Battery Slot [BAT0] (battery present)
[   11.738155] wmi: Mapper loaded
[   11.776521] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input17
[   12.074034] jme 0000:04:00.5: irq 50 for MSI/MSI-X
[   12.098349] jme 0000:04:00.5 eth0: Link is down
[   12.098374] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.102380] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
[   12.110076] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
[   12.224299] ACPI: AC Adapter [AC] (on-line)
[   12.320406] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
[   12.327298] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
[   12.450807] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   18.232175] type=1006 audit(1391703043.426:3): pid=410 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=2 res=1
[   18.246002] type=1006 audit(1391703043.440:4): pid=411 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=3 res=1
[   19.145712] wlan0: authenticate with [STRIPPED]
[   19.189240] wlan0: send auth to [STRIPPED] (try 1/3)
[   19.193193] wlan0: authenticated
[   19.193653] wlan0: associate with [STRIPPED] (try 1/3)
[   19.197538] wlan0: RX AssocResp from [STRIPPED] (capab=0x411 status=0 aid=6)
[   19.202289] wlan0: associated
[   19.202341] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   46.037942] wlan0: deauthenticating from [STRIPPED] by local choice (reason=3)
[   46.051474] cfg80211: Calling CRDA to update world regulatory domain
[   46.150078] PM: Syncing filesystems ... done.
[   46.172553] PM: Preparing system for mem sleep
[   46.172950] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   46.174264] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[   46.175018] PM: Entering mem sleep
[   46.175100] Suspending console(s) (use no_console_suspend to debug)
[   46.175802] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   46.175910] sd 0:0:0:0: [sda] Stopping disk
[   46.584887] PM: suspend of devices complete after 409.560 msecs
[   46.585105] PM: late suspend of devices complete after 0.214 msecs
[   46.598151] pcieport 0000:00:1c.1: System wakeup enabled by ACPI
[   46.611503] xhci_hcd 0000:02:00.0: System wakeup enabled by ACPI
[   46.624912] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[   46.638197] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[   46.651480] PM: noirq suspend of devices complete after 66.408 msecs
[   46.651663] ACPI: Preparing to enter system sleep state S3
[   46.686178] PM: Saving platform NVS memory
[   46.687271] Disabling non-boot CPUs ...
[   46.688744] kvm: disabling virtualization on CPU1
[   46.689002] smpboot: CPU 1 is now offline
[   46.690855] kvm: disabling virtualization on CPU2
[   46.791268] smpboot: CPU 2 is now offline
[   46.793027] kvm: disabling virtualization on CPU3
[   46.894598] smpboot: CPU 3 is now offline
[   46.895753] ACPI: Low-level resume complete
[   46.895792] PM: Restoring platform NVS memory
[   46.896289] CPU0: Thermal monitoring handled by SMI
[   46.896298] Enabling non-boot CPUs ...
[   46.896347] x86: Booting SMP configuration:
[   46.896348] smpboot: Booting Node 0 Processor 1 APIC 0x4
[   46.907384] CPU1: Thermal monitoring handled by SMI
[   46.907419] kvm: enabling virtualization on CPU1
[   46.909790] CPU1 is up
[   46.909810] smpboot: Booting Node 0 Processor 2 APIC 0x1
[   46.920946] CPU2: Thermal monitoring handled by SMI
[   46.920981] kvm: enabling virtualization on CPU2
[   46.923367] CPU2 is up
[   46.923387] smpboot: Booting Node 0 Processor 3 APIC 0x5
[   46.934519] CPU3: Thermal monitoring handled by SMI
[   46.934551] kvm: enabling virtualization on CPU3
[   46.936946] CPU3 is up
[   46.939418] ACPI: Waking up from system sleep state S3
[   47.632110] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[   47.658753] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[   47.685428] xhci_hcd 0000:02:00.0: System wakeup disabled by ACPI
[   47.739044] PM: noirq resume of devices complete after 133.370 msecs
[   47.739325] PM: early resume of devices complete after 0.234 msecs
[   47.739697] pcieport 0000:00:1c.1: System wakeup disabled by ACPI
[   47.741451] iwlwifi 0000:05:00.0: RF_KILL bit toggled to enable radio.
[   47.849065] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   48.078534] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   48.078575] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   48.079516] ata1.00: configured for UDMA/133
[   48.079626] sd 0:0:0:0: [sda] Starting disk
[   48.085151] ata5: SATA link down (SStatus 0 SControl 300)
[   48.248163] ata2.00: configured for UDMA/100
[   49.169417] PM: resume of devices complete after 1430.899 msecs
[   49.169733] iwlwifi 0000:05:00.0: no hotplug settings from platform
[   49.169743] PM: Finishing wakeup.
[   49.169744] Restarting tasks ... done.
[   49.170691] video LNXVIDEO:00: Restoring backlight state
[   49.170694] video LNXVIDEO:01: Restoring backlight state
[   49.644845] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
[   49.646671] jme 0000:04:00.5: irq 50 for MSI/MSI-X
[   49.671645] jme 0000:04:00.5 eth0: Link is down
[   49.671717] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   49.674119] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
[   49.681037] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
[   49.778035] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   49.806241] xhci_hcd 0000:02:00.0: no hotplug settings from platform
[   49.859417] iwlwifi 0000:05:00.0: no hotplug settings from platform
[   56.264694] wlan0: authenticate with [STRIPPED]
[   56.277969] wlan0: send auth to [STRIPPED] (try 1/3)
[   56.282076] wlan0: authenticated
[   56.283879] wlan0: associate with [STRIPPED] (try 1/3)
[   56.297196] wlan0: RX AssocResp from [STRIPPED] (capab=0x411 status=0 aid=6)
[   56.303746] wlan0: associated
[   56.303826] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

