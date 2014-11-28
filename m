Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaK1RS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:18:29 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54269 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaK1RSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:18:21 -0500
Date: Fri, 28 Nov 2014 09:18:12 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, ntrrgc@gmail.com,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / video: check _DOD list when creating backlight
 device
Message-ID: <20141128171812.GA3658@norris-Latitude-E6410>
References: <542A4949.2020208@intel.com>
 <1648939.GaN1bonAuX@vostro.rjw.lan>
 <5436470B.3030306@intel.com>
 <20141128095928.GA5106@norris-Latitude-E6410>
 <54786294.5030105@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <54786294.5030105@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 07:55:00PM +0800, Aaron Lu wrote:
> On 11/28/2014 05:59 PM, Brian Norris wrote:
> > And indeed, there is a regression! My Dell Latituded E6410's backlight
> > control no longer works after this commit, and I get messages like this
> > instead:
> > 
> > [   57.214610] ACPI: Failed to switch the brightness
> > 
> > If I revert this commit, my backlight controls work again. Also, I
> > regain a cooling device (?) that was being ignored:
> > 
> > [    1.332682] acpi device:02: registered as cooling_device0
> > 
> > Do you need any additional info to handle the regression, or should we
> > just revert the patch?
> 
> Please attach acpidump, dmesg with video.dyndbg="module video +pft" in
> kernel cmdline, list the /sys/class/backlight with and without this
> commit, thanks.

Appending dmesg and attaching acpidump. Unfortunately, I'm using a few
binary modules, since Wifi and GPU suspend/resume support are broken
otherwise, but I did test briefly with Nouveau anyway. Results are
essentially the same with Nouveau (although Nouveau seems to provide an
extra backlight device, though it doesn't seem to do anything for me).

Before reverting:

$ ls -al /sys/class/backlight
total 0
drwxr-xr-x  2 root root 0 Nov 28 09:01 .
drwxr-xr-x 58 root root 0 Nov 28 09:01 ..

After reverting:

$ ls -al /sys/class/backlight
total 0
drwxr-xr-x  2 root root 0 Nov 28 09:10 .
drwxr-xr-x 50 root root 0 Nov 28 09:10 ..
lrwxrwxrwx  1 root root 0 Nov 28 09:09 acpi_video0 -> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0

Thanks,
Brian

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-031800rc6-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201411231935 SMP Mon Nov 24 00:36:20 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-031800rc6-generic root=UUID=94708557-3228-49c4-af63-5b93fde98f92 ro video.dyndbg=+pft
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000095bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000095c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf65efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf65f000-0x00000000cf67efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf67f000-0x00000000cf76efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf76f000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E6410/07XJP9, BIOS A06 11/20/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x12c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 120000000 mask FF0000000 write-back
[    0.000000]   5 base 12C000000 mask FFC000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 4GB, range: 512MB, type WB
[    0.000000] reg 4, base: 4608MB, range: 256MB, type WB
[    0.000000] reg 5, base: 4800MB, range: 64MB, type UC
[    0.000000] total RAM covered: 4032M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 6  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 4GB, range: 512MB, type WB
[    0.000000] reg 4, base: 4608MB, range: 128MB, type WB
[    0.000000] reg 5, base: 4736MB, range: 64MB, type WB
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcf65f max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f2200-0x000f220f] mapped at [ffff8800000f2200]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff88000008f000] 8f000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd0000, 0x01fd0fff] PGTABLE
[    0.000000] BRK [0x01fd1000, 0x01fd1fff] PGTABLE
[    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12be00000-0x12bffffff]
[    0.000000]  [mem 0x12be00000-0x12bffffff] page 2M
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x128000000-0x12bdfffff]
[    0.000000]  [mem 0x128000000-0x12bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x127ffffff]
[    0.000000]  [mem 0x100000000-0x127ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcf65efff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcf5fffff] page 2M
[    0.000000]  [mem 0xcf600000-0xcf65efff] page 4k
[    0.000000] RAMDISK: [mem 0x35ce8000-0x36e6bfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FE300 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000CF67DE18 000064 (v01 DELL   E2       06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000CF75FC18 0000F4 (v04 DELL   E2       06222004 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xCF76BF40/0x00000000CF76ED40, using 32-bit address (20140926/tbfadt-283)
[    0.000000] ACPI: DSDT 0x00000000CF73E018 00A248 (v01 DELL   E2       00001001 INTL 20080729)
[    0.000000] ACPI: FACS 0x00000000CF76BF40 000040
[    0.000000] ACPI: APIC 0x00000000CF67CF18 00008C (v02 DELL   E2       06222004 MSFT 00010013)
[    0.000000] ACPI: TCPA 0x00000000CF76DD18 000032 (v02                 00000000      00000000)
[    0.000000] ACPI: MCFG 0x00000000CF76DC98 00003C (v01 A M I  GMCH945. 06222004 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CF76DC18 000038 (v01 DELL   E2       00000001 ASL  00000061)
[    0.000000] ACPI: BOOT 0x00000000CF76DB98 000028 (v01 DELL   E2       06222004 AMI  00010013)
[    0.000000] ACPI: SLIC 0x00000000CF766818 000176 (v03 DELL   E2       06222004 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000CF74D018 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20080729)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012bffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x12bff7000-0x12bffbfff]
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff880127600000-ffff88012b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00094fff]
[    0.000000]   node   0: [mem 0x00100000-0xcf65efff]
[    0.000000]   node   0: [mem 0x100000000-0x12bffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x12bffffff]
[    0.000000] On node 0 totalpages: 1029619
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3988 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13210 pages used for memmap
[    0.000000]   DMA32 zone: 845407 pages, LIFO batch:31
[    0.000000]   Normal zone: 2816 pages used for memmap
[    0.000000]   Normal zone: 180224 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00095000-0x00095fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00096000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf65f000-0xcf67efff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf67f000-0xcf76efff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf76f000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88012bc00000 s82880 r8192 d31808 u262144
[    0.000000] pcpu-alloc: s82880 r8192 d31808 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1013508
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-031800rc6-generic root=UUID=94708557-3228-49c4-af63-5b93fde98f92 ro video.dyndbg=+pft
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3951404K/4118476K available (7904K kernel code, 1155K rwdata, 3792K rodata, 1392K init, 1316K bss, 167072K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:488 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2659.891 MHz processor
[    0.000031] Calibrating delay loop (skipped), value calculated using timer frequency.. 5319.78 BogoMIPS (lpj=10639564)
[    0.000160] pid_max: default: 32768 minimum: 301
[    0.000229] ACPI: Core revision 20140926
[    0.006464] ACPI: All ACPI Tables successfully acquired
[    0.008005] Security Framework initialized
[    0.008089] AppArmor: AppArmor initialized
[    0.008157] Yama: becoming mindful.
[    0.008493] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009464] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009950] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.010028] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.010304] Initializing cgroup subsys memory
[    0.010379] Initializing cgroup subsys devices
[    0.010446] Initializing cgroup subsys freezer
[    0.010513] Initializing cgroup subsys net_cls
[    0.010579] Initializing cgroup subsys blkio
[    0.010645] Initializing cgroup subsys perf_event
[    0.010713] Initializing cgroup subsys net_prio
[    0.010780] Initializing cgroup subsys hugetlb
[    0.010866] CPU: Physical Processor ID: 0
[    0.010933] CPU: Processor Core ID: 0
[    0.011036] mce: CPU supports 9 MCE banks
[    0.011111] CPU0: Thermal monitoring handled by SMI
[    0.011120] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.011120] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.011309] Freeing SMP alternatives memory: 28K (ffffffff81e7e000 - ffffffff81e85000)
[    0.012466] ftrace: allocating 32476 entries in 127 pages
[    0.027000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.066762] smpboot: CPU0: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GHz (fam: 06, model: 25, stepping: 02)
[    0.175038] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.175332] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.175400] ... version:                3
[    0.175464] ... bit width:              48
[    0.175528] ... generic registers:      4
[    0.175593] ... value mask:             0000ffffffffffff
[    0.175658] ... max period:             000000007fffffff
[    0.175723] ... fixed-purpose events:   3
[    0.175787] ... event mask:             000000070000000f
[    0.177355] x86: Booting SMP configuration:
[    0.177424] .... node  #0, CPUs:      #1
[    0.188633] CPU1: Thermal monitoring handled by SMI
[    0.190827] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.191094]  #2
[    0.202208] CPU2: Thermal monitoring handled by SMI
[    0.204435]  #3<7>[    0.215609] CPU3: Thermal monitoring handled by SMI
[    0.217710] x86: Booted up 1 node, 4 CPUs
[    0.217783] smpboot: Total of 4 processors activated (21279.12 BogoMIPS)
[    0.220598] devtmpfs: initialized
[    0.224790] evm: security.selinux
[    0.226014] evm: security.SMACK64
[    0.226077] evm: security.SMACK64EXEC
[    0.226140] evm: security.SMACK64TRANSMUTE
[    0.226204] evm: security.SMACK64MMAP
[    0.226268] evm: security.ima
[    0.226331] evm: security.capability
[    0.226450] PM: Registering ACPI NVS region [mem 0xcf67f000-0xcf76efff] (983040 bytes)
[    0.227488] pinctrl core: initialized pinctrl subsystem
[    0.227630] regulator-dummy: no parameters
[    0.227734] RTC time: 17:00:43, date: 11/28/14
[    0.227897] NET: Registered protocol family 16
[    0.231039] cpuidle: using governor ladder
[    0.235034] cpuidle: using governor menu
[    0.235170] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.235253] ACPI: bus type PCI registered
[    0.235318] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.235457] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.235544] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.235720] PCI: Using configuration type 1 for base access
[    0.235796] dmi type 0xB1 record - unknown flag
[    0.239471] ACPI: Added _OSI(Module Device)
[    0.239540] ACPI: Added _OSI(Processor Device)
[    0.239605] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.239670] ACPI: Added _OSI(Processor Aggregator Device)
[    0.251064] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.275326] ACPI: Dynamic OEM Table Load:
[    0.275494] ACPI: SSDT 0xFFFF880125692800 000474 (v01 PmRef  Cpu0Ist  00003000 INTL 20080729)
[    0.276014] ACPI: Dynamic OEM Table Load:
[    0.276183] ACPI: SSDT 0xFFFF880125711000 000891 (v01 PmRef  Cpu0Cst  00003001 INTL 20080729)
[    0.283264] ACPI: Dynamic OEM Table Load:
[    0.283429] ACPI: SSDT 0xFFFF8801256F1C00 000303 (v01 PmRef  ApIst    00003000 INTL 20080729)
[    0.287151] ACPI: Dynamic OEM Table Load:
[    0.287318] ACPI: SSDT 0xFFFF880125687E00 000119 (v01 PmRef  ApCst    00003000 INTL 20080729)
[    0.315140] ACPI: Interpreter enabled
[    0.315213] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.315395] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.315585] ACPI: (supports S0 S3 S4 S5)
[    0.315652] ACPI: Using IOAPIC for interrupt routing
[    0.315742] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.599877] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.599954] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.600060] \_SB_.PCI0:_OSC invalid UUID
[    0.600061] _OSC request data:1 1f 0 
[    0.600065] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.600750] PCI host bridge to bus 0000:00
[    0.600821] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.600888] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.600955] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.601022] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.601090] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfeafffff]
[    0.601165] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.601183] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.601327] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
[    0.601358] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.601389] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.601529] pci 0000:00:19.0: [8086:10ea] type 00 class 0x020000
[    0.601554] pci 0000:00:19.0: reg 0x10: [mem 0xe9600000-0xe961ffff]
[    0.601565] pci 0000:00:19.0: reg 0x14: [mem 0xe9680000-0xe9680fff]
[    0.601576] pci 0000:00:19.0: reg 0x18: [io  0x8040-0x805f]
[    0.601664] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.601703] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.601814] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.601838] pci 0000:00:1a.0: reg 0x10: [mem 0xe9670000-0xe96703ff]
[    0.601946] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.601986] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.602097] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.602120] pci 0000:00:1b.0: reg 0x10: [mem 0xe9660000-0xe9663fff 64bit]
[    0.602229] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.602271] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.602378] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.602482] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.602524] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.602630] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.602738] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.602781] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.602887] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.602994] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.603036] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.603145] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.603250] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.603293] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.603409] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.603433] pci 0000:00:1d.0: reg 0x10: [mem 0xe9650000-0xe96503ff]
[    0.603542] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.603582] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.603687] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.603785] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.603890] pci 0000:00:1f.0: [8086:3b07] type 00 class 0x060100
[    0.604061] pci 0000:00:1f.2: [8086:282a] type 00 class 0x010400
[    0.604088] pci 0000:00:1f.2: reg 0x10: [io  0x8090-0x8097]
[    0.604098] pci 0000:00:1f.2: reg 0x14: [io  0x8080-0x8083]
[    0.604108] pci 0000:00:1f.2: reg 0x18: [io  0x8070-0x8077]
[    0.604119] pci 0000:00:1f.2: reg 0x1c: [io  0x8060-0x8063]
[    0.604129] pci 0000:00:1f.2: reg 0x20: [io  0x8020-0x803f]
[    0.604140] pci 0000:00:1f.2: reg 0x24: [mem 0xe9640000-0xe96407ff]
[    0.604207] pci 0000:00:1f.2: PME# supported from D3hot
[    0.604277] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.604297] pci 0000:00:1f.3: reg 0x10: [mem 0xe9630000-0xe96300ff 64bit]
[    0.604329] pci 0000:00:1f.3: reg 0x20: [io  0x8000-0x801f]
[    0.604423] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.604450] pci 0000:00:1f.6: reg 0x10: [mem 0xe9620000-0xe9620fff 64bit]
[    0.604634] pci 0000:01:00.0: [10de:0a6c] type 00 class 0x030000
[    0.604644] pci 0000:01:00.0: reg 0x10: [mem 0xe2000000-0xe2ffffff]
[    0.604652] pci 0000:01:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.604661] pci 0000:01:00.0: reg 0x1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    0.604667] pci 0000:01:00.0: reg 0x24: [io  0x7000-0x707f]
[    0.604672] pci 0000:01:00.0: reg 0x30: [mem 0xe3000000-0xe307ffff pref]
[    0.604753] pci 0000:01:00.1: [10de:0be3] type 00 class 0x040300
[    0.604763] pci 0000:01:00.1: reg 0x10: [mem 0xe3080000-0xe3083fff]
[    0.604867] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.604935] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.604937] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    0.605010] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.605083] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.605087] pci 0000:00:1c.0:   bridge window [mem 0xe8200000-0xe95fffff]
[    0.605236] pci 0000:03:00.0: [14e4:4353] type 00 class 0x028000
[    0.605284] pci 0000:03:00.0: reg 0x10: [mem 0xe6e00000-0xe6e03fff 64bit]
[    0.605554] pci 0000:03:00.0: supports D1 D2
[    0.605555] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.605614] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.612391] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.612479] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.612483] pci 0000:00:1c.1:   bridge window [mem 0xe6e00000-0xe81fffff]
[    0.612635] pci 0000:04:00.0: [1180:e476] type 02 class 0x060700
[    0.612661] pci 0000:04:00.0: reg 0x10: [mem 0xe5940000-0xe5940fff]
[    0.612747] pci 0000:04:00.0: supports D1 D2
[    0.612748] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.612779] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.612947] pci 0000:04:00.1: [1180:e822] type 00 class 0x080501
[    0.612974] pci 0000:04:00.1: reg 0x10: [mem 0xe5930000-0xe59300ff]
[    0.613142] pci 0000:04:00.1: supports D1 D2
[    0.613144] pci 0000:04:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.613272] pci 0000:04:00.4: [1180:e832] type 00 class 0x0c0010
[    0.613298] pci 0000:04:00.4: reg 0x10: [mem 0xe5900000-0xe59007ff]
[    0.613465] pci 0000:04:00.4: supports D1 D2
[    0.613467] pci 0000:04:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.620432] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.620510] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    0.620515] pci 0000:00:1c.2:   bridge window [mem 0xe3100000-0xe59fffff]
[    0.620609] pci_bus 0000:05: busn_res: can not insert [bus 05-ff] under [bus 04-05] (conflicts with (null) [bus 04-05])
[    0.620614] pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 08
[    0.620616] pci_bus 0000:05: busn_res: can not insert [bus 05-08] under [bus 04-05] (conflicts with (null) [bus 04-05])
[    0.620620] pci_bus 0000:05: [bus 05-08] partially hidden behind bridge 0000:04 [bus 04-05]
[    0.620707] pci 0000:00:1c.2: bridge has subordinate 05 but max busn 08
[    0.620857] acpiphp: Slot [1] registered
[    0.620930] pci 0000:00:1c.3: PCI bridge to [bus 06-0b]
[    0.620999] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.621003] pci 0000:00:1c.3:   bridge window [mem 0xe5a00000-0xe6dfffff]
[    0.621088] pci 0000:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
[    0.621169] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.621171] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.621172] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.621174] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfeafffff] (subtractive decode)
[    0.667017] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.667773] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.668472] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.669166] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.669919] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.670613] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.671417] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    0.672108] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.698884] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    0.698957] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.699041] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.699168] PCI host bridge to bus 0000:3f
[    0.699238] pci_bus 0000:3f: root bus resource [bus 3f]
[    0.699306] pci 0000:3f:00.0: [8086:2c62] type 00 class 0x060000
[    0.699346] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.699388] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.699426] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.699462] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.699499] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.719450] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.719659] ACPI : EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    0.719837] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.719906] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.719987] vgaarb: loaded
[    0.720050] vgaarb: bridge control possible 0000:01:00.0
[    0.720319] SCSI subsystem initialized
[    0.720441] libata version 3.00 loaded.
[    0.720466] ACPI: bus type USB registered
[    0.720549] usbcore: registered new interface driver usbfs
[    0.720626] usbcore: registered new interface driver hub
[    0.720711] usbcore: registered new device driver usb
[    0.720903] PCI: Using ACPI for IRQ routing
[    0.723132] PCI: pci_cache_line_size set to 64 bytes
[    0.723236] e820: reserve RAM buffer [mem 0x00095c00-0x0009ffff]
[    0.723237] e820: reserve RAM buffer [mem 0xcf65f000-0xcfffffff]
[    0.723341] NetLabel: Initializing
[    0.723408] NetLabel:  domain hash size = 128
[    0.723472] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.723549] NetLabel:  unlabeled traffic allowed by default
[    0.723688] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.724192] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.726300] Switched to clocksource hpet
[    0.731702] AppArmor: AppArmor Filesystem Enabled
[    0.731816] pnp: PnP ACPI init
[    0.732060] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.732132] system 00:00: [io  0x1000-0x1003] has been reserved
[    0.732199] system 00:00: [io  0x1004-0x1013] has been reserved
[    0.732266] system 00:00: [io  0xffff] has been reserved
[    0.732332] system 00:00: [io  0x0400-0x047f] could not be reserved
[    0.732400] system 00:00: [io  0x0500-0x057f] has been reserved
[    0.732467] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.732537] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.732570] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.732597] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.774458] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    0.774488] pnp 00:04: Plug and Play ACPI device, IDs DLL040a PNP0f13 (active)
[    0.774691] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.774764] system 00:05: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.774832] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.774900] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.774967] system 00:05: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.775035] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.775104] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.775172] system 00:05: [mem 0xff000000-0xffffffff] could not be reserved
[    0.775241] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.775309] system 00:05: [mem 0xe96c0000-0xe96c0fff] has been reserved
[    0.775379] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.818662] pnp: PnP ACPI: found 6 devices
[    0.825378] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.825389] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.825408] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04-05] add_size 200000
[    0.825419] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06-0b] add_size 200000
[    0.825433] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.825435] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.825437] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.825438] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.825445] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe9700000-0xe98fffff 64bit pref]
[    0.825531] pci 0000:00:1c.1: BAR 15: assigned [mem 0xe9900000-0xe9afffff 64bit pref]
[    0.825613] pci 0000:00:1c.2: BAR 15: assigned [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    0.825694] pci 0000:00:1c.3: BAR 15: assigned [mem 0xe9d00000-0xe9efffff 64bit pref]
[    0.825776] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.825841] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.825910] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    0.825980] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.826047] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    0.826118] pci 0000:00:1c.0:   bridge window [mem 0xe8200000-0xe95fffff]
[    0.826188] pci 0000:00:1c.0:   bridge window [mem 0xe9700000-0xe98fffff 64bit pref]
[    0.826272] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.826351] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.826425] pci 0000:00:1c.1:   bridge window [mem 0xe6e00000-0xe81fffff]
[    0.826495] pci 0000:00:1c.1:   bridge window [mem 0xe9900000-0xe9afffff 64bit pref]
[    0.826581] pci 0000:04:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.826583] pci 0000:04:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.826584] pci 0000:04:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.826586] pci 0000:04:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.826588] pci 0000:04:00.0: BAR 15: no space for [mem size 0x04000000 pref]
[    0.826661] pci 0000:04:00.0: BAR 15: failed to assign [mem size 0x04000000 pref]
[    0.826741] pci 0000:04:00.0: BAR 16: no space for [mem size 0x04000000]
[    0.826808] pci 0000:04:00.0: BAR 16: failed to assign [mem size 0x04000000]
[    0.826877] pci 0000:04:00.0: BAR 13: assigned [io  0x2000-0x20ff]
[    0.826945] pci 0000:04:00.0: BAR 14: assigned [io  0x2400-0x24ff]
[    0.827013] pci 0000:04:00.0: BAR 16: no space for [mem size 0x04000000]
[    0.827081] pci 0000:04:00.0: BAR 16: failed to assign [mem size 0x04000000]
[    0.827149] pci 0000:04:00.0: BAR 15: no space for [mem size 0x04000000 pref]
[    0.827216] pci 0000:04:00.0: BAR 15: failed to assign [mem size 0x04000000 pref]
[    0.827296] pci 0000:04:00.0: CardBus bridge to [bus 05-08]
[    0.827362] pci 0000:04:00.0:   bridge window [io  0x2000-0x20ff]
[    0.827433] pci 0000:04:00.0:   bridge window [io  0x2400-0x24ff]
[    0.827505] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.827572] pci 0000:00:1c.2:   bridge window [io  0x2000-0x3fff]
[    0.827643] pci 0000:00:1c.2:   bridge window [mem 0xe3100000-0xe59fffff]
[    0.828866] pci 0000:00:1c.2:   bridge window [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    0.828951] pci 0000:00:1c.3: PCI bridge to [bus 06-0b]
[    0.829022] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.829093] pci 0000:00:1c.3:   bridge window [mem 0xe5a00000-0xe6dfffff]
[    0.829162] pci 0000:00:1c.3:   bridge window [mem 0xe9d00000-0xe9efffff 64bit pref]
[    0.829247] pci 0000:00:1e.0: PCI bridge to [bus 0c]
[    0.829329] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.829330] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.829332] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.829333] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xfeafffff]
[    0.829335] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    0.829336] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xe30fffff]
[    0.829338] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
[    0.829339] pci_bus 0000:02: resource 1 [mem 0xe8200000-0xe95fffff]
[    0.829341] pci_bus 0000:02: resource 2 [mem 0xe9700000-0xe98fffff 64bit pref]
[    0.829342] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.829344] pci_bus 0000:03: resource 1 [mem 0xe6e00000-0xe81fffff]
[    0.829345] pci_bus 0000:03: resource 2 [mem 0xe9900000-0xe9afffff 64bit pref]
[    0.829347] pci_bus 0000:04: resource 0 [io  0x2000-0x3fff]
[    0.829348] pci_bus 0000:04: resource 1 [mem 0xe3100000-0xe59fffff]
[    0.829350] pci_bus 0000:04: resource 2 [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    0.829351] pci_bus 0000:05: resource 0 [io  0x2000-0x20ff]
[    0.829353] pci_bus 0000:05: resource 1 [io  0x2400-0x24ff]
[    0.829354] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.829355] pci_bus 0000:06: resource 1 [mem 0xe5a00000-0xe6dfffff]
[    0.829357] pci_bus 0000:06: resource 2 [mem 0xe9d00000-0xe9efffff 64bit pref]
[    0.829359] pci_bus 0000:0c: resource 4 [io  0x0000-0x0cf7]
[    0.829360] pci_bus 0000:0c: resource 5 [io  0x0d00-0xffff]
[    0.829361] pci_bus 0000:0c: resource 6 [mem 0x000a0000-0x000bffff]
[    0.829363] pci_bus 0000:0c: resource 7 [mem 0xd0000000-0xfeafffff]
[    0.829391] NET: Registered protocol family 2
[    0.829631] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.829814] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.830007] TCP: Hash tables configured (established 32768 bind 32768)
[    0.830108] TCP: reno registered
[    0.830182] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.830277] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.830422] NET: Registered protocol family 1
[    0.830867] pci 0000:01:00.0: Video device with shadowed ROM
[    0.830926] PCI: CLS 64 bytes, default 64
[    0.830982] Trying to unpack rootfs image as initramfs...
[    1.095670] Freeing initrd memory: 17936K (ffff880035ce8000 - ffff880036e6c000)
[    1.095788] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.095860] software IO TLB [mem 0xcb65f000-0xcf65f000] (64MB) mapped at [ffff8800cb65f000-ffff8800cf65efff]
[    1.095994] Simple Boot Flag at 0xf1 set to 0x1
[    1.096273] microcode: CPU0 sig=0x20652, pf=0x10, revision=0xc
[    1.096350] microcode: CPU1 sig=0x20652, pf=0x10, revision=0xc
[    1.096426] microcode: CPU2 sig=0x20652, pf=0x10, revision=0xc
[    1.096505] microcode: CPU3 sig=0x20652, pf=0x10, revision=0xc
[    1.096643] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.096750] Scanning for low memory corruption every 60 seconds
[    1.097209] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.097311] Initialise system trusted keyring
[    1.097399] audit: initializing netlink subsys (disabled)
[    1.097485] audit: type=2000 audit(1417194042.988:1): initialized
[    1.097882] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.099257] zpool: loaded
[    1.099325] zbud: loaded
[    1.099568] VFS: Disk quotas dquot_6.5.2
[    1.099667] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.100179] fuse init (API version 7.23)
[    1.100327] msgmni has been set to 7752
[    1.100451] Key type big_key registered
[    1.101103] Key type asymmetric registered
[    1.101176] Asymmetric key parser 'x509' registered
[    1.101274] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.101407] io scheduler noop registered
[    1.101480] io scheduler deadline registered (default)
[    1.101581] io scheduler cfq registered
[    1.101877] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.102436] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.102519] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.102645] intel_idle: MWAIT substates: 0x1120
[    1.102646] intel_idle: v0.4 model 0x25
[    1.102647] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.103331] ACPI: AC Adapter [AC] (on-line)
[    1.103529] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.104445] ACPI: Lid Switch [LID]
[    1.104611] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.104724] ACPI: Power Button [PBTN]
[    1.104878] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.104988] ACPI: Sleep Button [SBTN]
[    1.105138] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.105246] ACPI: Power Button [PWRF]
[    1.105980] GHES: HEST is not enabled!
[    1.106234] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.112650] Linux agpgart interface v0.103
[    1.114466] brd: module loaded
[    1.115476] loop: module loaded
[    1.115760] libphy: Fixed MDIO Bus: probed
[    1.115878] tun: Universal TUN/TAP device driver, 1.6
[    1.115998] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.116117] PPP generic driver version 2.4.2
[    1.116279] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.116374] ehci-pci: EHCI PCI platform driver
[    1.116611] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.116692] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.116837] ehci-pci 0000:00:1a.0: debug port 2
[    1.120850] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.120878] ehci-pci 0000:00:1a.0: irq 16, io mem 0xe9670000
[    1.123260] ACPI: Battery Slot [BAT0] (battery present)
[    1.130474] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.130618] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.130695] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.130774] usb usb1: Product: EHCI Host Controller
[    1.130838] usb usb1: Manufacturer: Linux 3.18.0-031800rc6-generic ehci_hcd
[    1.130906] usb usb1: SerialNumber: 0000:00:1a.0
[    1.138946] hub 1-0:1.0: USB hub found
[    1.139021] hub 1-0:1.0: 2 ports detected
[    1.163056] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.163102] ACPI: Battery Slot [BAT1] (battery absent)
[    1.163210] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.163301] ehci-pci 0000:00:1d.0: debug port 2
[    1.167294] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.167309] ehci-pci 0000:00:1d.0: irq 17, io mem 0xe9650000
[    1.178467] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.178661] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.178737] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.178816] usb usb2: Product: EHCI Host Controller
[    1.178881] usb usb2: Manufacturer: Linux 3.18.0-031800rc6-generic ehci_hcd
[    1.178948] usb usb2: SerialNumber: 0000:00:1d.0
[    1.179373] hub 2-0:1.0: USB hub found
[    1.179466] hub 2-0:1.0: 2 ports detected
[    1.179714] ehci-platform: EHCI generic platform driver
[    1.179811] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.179899] ohci-pci: OHCI PCI platform driver
[    1.179994] ohci-platform: OHCI generic platform driver
[    1.180085] uhci_hcd: USB Universal Host Controller Interface driver
[    1.180251] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.181292] i8042: Warning: Keylock active
[    1.182643] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.182736] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.183258] mousedev: PS/2 mouse device common for all mice
[    1.184203] rtc_cmos 00:01: RTC can wake from S4
[    1.184609] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.184778] rtc_cmos 00:01: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.185100] device-mapper: uevent: version 1.0.3
[    1.185368] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.185708] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) initialised: dm-devel@redhat.com
[    1.185849] ledtrig-cpu: registered to indicate activity on CPUs
[    1.186135] TCP: cubic registered
[    1.186473] NET: Registered protocol family 10
[    1.187118] NET: Registered protocol family 17
[    1.187221] Key type dns_resolver registered
[    1.188255] Loading compiled-in X.509 certificates
[    1.190482] Loaded X.509 cert 'Magrathea: Glacier signing key: c0ad8766a60c0ad1f3c220cbfbc6f07e3893fbdc'
[    1.190619] registered taskstats version 1
[    1.193001] Key type trusted registered
[    1.196885] Key type encrypted registered
[    1.199873] AppArmor: AppArmor sha1 policy hashing enabled
[    1.199967] ima: No TPM chip found, activating TPM-bypass!
[    1.200098] evm: HMAC attrs: 0x1
[    1.201055]   Magic number: 6:899:37
[    1.201149] bdi 7:2: hash matches
[    1.201391] rtc_cmos 00:01: setting system clock to 2014-11-28 17:00:44 UTC (1417194044)
[    1.202878] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.202953] EDD information not available.
[    1.203073] PM: Hibernation image not present or could not be loaded.
[    1.204235] Freeing unused kernel memory: 1392K (ffffffff81d22000 - ffffffff81e7e000)
[    1.204319] Write protecting the kernel read-only data: 12288k
[    1.205124] Freeing unused kernel memory: 276K (ffff8800017bb000 - ffff880001800000)
[    1.205871] Freeing unused kernel memory: 304K (ffff880001bb4000 - ffff880001c00000)
[    1.218929] systemd-udevd[115]: starting version 204
[    1.237317] pps_core: LinuxPPS API ver. 1 registered
[    1.237389] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.238560] PTP clock support registered
[    1.242093] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.242164] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.242466] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.242572] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    1.245244] sdhci: Secure Digital Host Controller Interface driver
[    1.245320] sdhci: Copyright(c) Pierre Ossman
[    1.246757] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:e822] (rev 3)
[    1.246962] sdhci-pci 0000:04:00.1: No vmmc regulator found
[    1.247035] sdhci-pci 0000:04:00.1: No vqmmc regulator found
[    1.251382] mmc0: SDHCI controller on PCI [0000:04:00.1] using DMA
[    1.314554] firewire_ohci 0000:04:00.4: added OHCI v1.0 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    1.470436] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.483086] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:26:b9:dc:54:79
[    1.483170] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.483281] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 10, PBA No: 3041FF-0FF
[    1.484563] ahci 0000:00:1f.2: version 3.0
[    1.484799] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    1.484884] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl RAID mode
[    1.484983] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    1.490481] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.515330] scsi host0: ahci
[    1.515590] scsi host1: ahci
[    1.515828] scsi host2: ahci
[    1.516065] scsi host3: ahci
[    1.516290] scsi host4: ahci
[    1.516507] scsi host5: ahci
[    1.516628] ata1: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640100 irq 26
[    1.516718] ata2: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640180 irq 26
[    1.516797] ata3: DUMMY
[    1.516859] ata4: DUMMY
[    1.516923] ata5: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640300 irq 26
[    1.517003] ata6: SATA max UDMA/133 abar m2048@0xe9640000 port 0xe9640380 irq 26
[    1.602934] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    1.603011] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.603586] hub 1-1:1.0: USB hub found
[    1.603797] hub 1-1:1.0: 6 ports detected
[    1.622923] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    1.623004] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.623453] hub 2-1:1.0: USB hub found
[    1.623639] hub 2-1:1.0: 8 ports detected
[    1.814811] firewire_core 0000:04:00.4: created device fw0: GUID 0274de61374fc000, S400
[    1.834561] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.834669] ata5: SATA link down (SStatus 0 SControl 300)
[    1.834770] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.834879] ata6: SATA link down (SStatus 0 SControl 300)
[    1.835110] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.835273] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HD, max UDMA/133
[    1.835350] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.835905] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.836067] ata1.00: configured for UDMA/133
[    1.836304] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 02HD PQ: 0 ANSI: 5
[    1.836523] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.836539] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.836721] sd 0:0:0:0: [sda] Write Protect is off
[    1.836798] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.836805] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.837632]  sda: sda1 sda2 < sda5 >
[    1.838288] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.844666] ata2.00: ATAPI: TEAC DVD-ROM DV18SA, D.0D, max UDMA/100
[    1.848355] ata2.00: configured for UDMA/100
[    1.863969] scsi 1:0:0:0: CD-ROM            TEAC     DVD-ROM DV18SA   D.0D PQ: 0 ANSI: 5
[    1.874757] usb 1-1.4: new high-speed USB device number 3 using ehci-pci
[    1.893171] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    1.893262] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.893510] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.893579] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.894520] usb 2-1.7: new full-speed USB device number 3 using ehci-pci
[    1.958627] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    1.958696] EXT4-fs (sda1): write access will be enabled during recovery
[    1.974276] usb 1-1.4: New USB device found, idVendor=05ca, idProduct=1814
[    1.974345] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.974431] usb 1-1.4: Product: Laptop_Integrated_Webcam_3M
[    1.974511] usb 1-1.4: Manufacturer: CN06YWTK7248705I03FC
[    1.976617] EXT4-fs (sda1): orphan cleanup on readonly fs
[    1.987266] EXT4-fs (sda1): 27 orphan inodes deleted
[    1.987333] EXT4-fs (sda1): recovery complete
[    1.989782] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.990899] usb 2-1.7: New USB device found, idVendor=413c, idProduct=8187
[    1.990900] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.990902] usb 2-1.7: Product: DW375 Bluetooth Module
[    1.990903] usb 2-1.7: Manufacturer: Dell Computer Corp
[    1.990903] usb 2-1.7: SerialNumber: F07BCBA9833E
[    2.062794] usb 2-1.8: new full-speed USB device number 4 using ehci-pci
[    2.094488] tsc: Refined TSC clocksource calibration: 2660.000 MHz
[    2.166822] random: init urandom read with 48 bits of entropy available
[    2.185830] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5801
[    2.185915] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.186001] usb 2-1.8: Product: 5880
[    2.186087] usb 2-1.8: Manufacturer: Broadcom Corp
[    2.186152] usb 2-1.8: SerialNumber: 0123456789ABCD
[    2.186376] usb 2-1.8: config 0 descriptor??
[    2.198705] init: plymouth-upstart-bridge main process (200) terminated with status 1
[    2.198823] init: plymouth-upstart-bridge main process ended, respawning
[    2.203950] init: plymouth-upstart-bridge main process (210) terminated with status 1
[    2.204082] init: plymouth-upstart-bridge main process ended, respawning
[    2.207028] init: plymouth-upstart-bridge main process (213) terminated with status 1
[    2.207140] init: plymouth-upstart-bridge main process ended, respawning
[    2.209518] init: plymouth-upstart-bridge main process (215) terminated with status 1
[    2.209626] init: plymouth-upstart-bridge main process ended, respawning
[    2.213664] init: plymouth-upstart-bridge main process (217) terminated with status 1
[    2.213673] init: plymouth-upstart-bridge main process ended, respawning
[    2.239037] init: ureadahead main process (203) terminated with status 5
[    2.334141] Adding 4880380k swap on /dev/sda5.  Priority:-1 extents:1 across:4880380k SSFS
[    2.390383] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    2.633710] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input7
[    2.646998] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input6
[    3.094837] Switched to clocksource tsc
[    3.423477] init: Failed to spawn lttng-sessiond main process: unable to execute: No such file or directory
[    3.494139] systemd-udevd[436]: starting version 204
[    3.548562] lp: driver loaded but no devices found
[    3.560504] ppdev: user-space parallel port driver
[    3.564417] parport_pc 00:03: [io  0x0378-0x037b]
[    3.564513] parport_pc 00:03: [irq 5]
[    3.601738] audit: type=1400 audit(1417194046.893:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=484 comm="apparmor_parser"
[    3.601746] audit: type=1400 audit(1417194046.893:3): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=484 comm="apparmor_parser"
[    3.602296] audit: type=1400 audit(1417194046.893:4): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=484 comm="apparmor_parser"
[    3.602664] Bluetooth: Core ver 2.19
[    3.602684] NET: Registered protocol family 31
[    3.602686] Bluetooth: HCI device and connection manager initialized
[    3.602696] Bluetooth: HCI socket layer initialized
[    3.602698] Bluetooth: L2CAP socket layer initialized
[    3.602705] Bluetooth: SCO socket layer initialized
[    3.608686] Bluetooth: RFCOMM TTY layer initialized
[    3.608698] Bluetooth: RFCOMM socket layer initialized
[    3.608705] Bluetooth: RFCOMM ver 1.11
[    3.610048] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.610050] Bluetooth: BNEP filters: protocol multicast
[    3.610055] Bluetooth: BNEP socket layer initialized
[    3.634165] init: cups main process (511) killed by HUP signal
[    3.634175] init: cups main process ended, respawning
[    3.678839] random: nonblocking pool is initialized
[    3.702722] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140926/utaddress-258)
[    3.702734] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.702738] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140926/utaddress-258)
[    3.702743] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.702750] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140926/utaddress-258)
[    3.702753] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.702757] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140926/utaddress-258)
[    3.702761] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.702762] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.756667] [drm] Initialized drm 1.1.0 20060810
[    3.763575] audit: type=1400 audit(1417194047.057:5): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=561 comm="apparmor_parser"
[    3.763584] audit: type=1400 audit(1417194047.057:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=561 comm="apparmor_parser"
[    3.763587] audit: type=1400 audit(1417194047.057:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=561 comm="apparmor_parser"
[    3.763934] audit: type=1400 audit(1417194047.057:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=561 comm="apparmor_parser"
[    3.763938] audit: type=1400 audit(1417194047.057:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=561 comm="apparmor_parser"
[    3.764104] audit: type=1400 audit(1417194047.057:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=561 comm="apparmor_parser"
[    3.765894] cfg80211: Calling CRDA to update world regulatory domain
[    3.766356] usbcore: registered new interface driver btusb
[    3.775944] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.776120] [496] acpi_video_dev_register_backlight: acpi device:01: not in _DOD list, ignore
[    3.776124] [496] acpi_video_dev_register_backlight: acpi device:02: not in _DOD list, ignore
[    3.776127] [496] acpi_video_dev_register_backlight: acpi device:03: not in _DOD list, ignore
[    3.776130] [496] acpi_video_dev_register_backlight: acpi device:04: not in _DOD list, ignore
[    3.776132] [496] acpi_video_dev_register_backlight: acpi device:05: not in _DOD list, ignore
[    3.776135] [496] acpi_video_dev_register_backlight: acpi device:06: not in _DOD list, ignore
[    3.778356] wmi: Mapper loaded
[    3.778911] snd_hda_intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[    3.787397] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[    3.802808] parport_pc 00:03: activated
[    3.802822] parport_pc 00:03: reported by Plug and Play ACPI
[    3.802898] yenta_cardbus 0000:04:00.0: CardBus bridge found [1028:040a]
[    3.802932] yenta_cardbus 0000:04:00.0: CardBus bridge to [bus 05-08]
[    3.802935] yenta_cardbus 0000:04:00.0:   bridge window [io  0x2000-0x20ff]
[    3.802940] yenta_cardbus 0000:04:00.0:   bridge window [io  0x2400-0x24ff]
[    3.802946] yenta_cardbus 0000:04:00.0:   bridge window [mem 0xe3100000-0xe44fffff pref]
[    3.802951] yenta_cardbus 0000:04:00.0:   bridge window [mem 0xe4800000-0xe4bfffff]
[    3.803485] snd_hda_intel 0000:01:00.1: Disabling MSI
[    3.803499] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    3.807479] sound hdaudioC0D0: autoconfig: line_outs=1 (0xe/0x0/0x0/0x0/0x0) type:line
[    3.807483] sound hdaudioC0D0:    speaker_outs=1 (0xd/0x0/0x0/0x0/0x0)
[    3.807484] sound hdaudioC0D0:    hp_outs=1 (0xb/0x0/0x0/0x0/0x0)
[    3.807486] sound hdaudioC0D0:    mono: mono_out=0x0
[    3.807487] sound hdaudioC0D0:    inputs:
[    3.807489] sound hdaudioC0D0:      Dock Mic=0xf
[    3.807491] sound hdaudioC0D0:      Internal Mic=0x11
[    3.807492] sound hdaudioC0D0:      Mic=0xa
[    3.810515] media: Linux media interface: v0.10
[    3.813963] sound hdaudioC0D1: autoconfig: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    3.813969] sound hdaudioC0D1:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.813971] sound hdaudioC0D1:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.813973] sound hdaudioC0D1:    mono: mono_out=0x0
[    3.813975] sound hdaudioC0D1:    inputs:
[    3.816804] Linux video capture interface: v2.00
[    3.828369] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled until i915 loads
[    3.829184] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[    3.839955] input: HDA Intel MID Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    3.840093] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    3.840278] input: HDA Intel MID Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    3.840472] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    3.849768] wl: module license 'MIXED/Proprietary' taints kernel.
[    3.849773] Disabling lock debugging due to kernel taint
[    3.852106] parport_pc 00:03: disabled
[    3.853373] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input8
[    3.855556] wl: module verification failed: signature and/or  required key missing - tainting kernel
[    3.862925] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_3M (05ca:1814)
[    3.869695] input: Laptop_Integrated_Webcam_3M as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input13
[    3.869797] usbcore: registered new interface driver uvcvideo
[    3.869800] USB Video Class driver (1.1.1)
[    3.872819] SSE version of gcm_enc/dec engaged.
[    3.900452] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.935500] yenta_cardbus 0000:04:00.0: ISA IRQ mask 0x0000, PCI irq 18
[    3.935506] yenta_cardbus 0000:04:00.0: Socket status: 30000006
[    3.935511] pci_bus 0000:05: Upper limit for fixing this bridge's parent bridge: #05
[    3.935517] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window: [io  0x2000-0x3fff]
[    3.935520] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window: [mem 0xe3100000-0xe59fffff]
[    3.935523] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe3100000-0xe59fffff:
[    3.935529]  excluding 0xe3100000-0xe4d2ffff 0xe5770000-0xe59fffff
[    3.935535] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge window: [mem 0xe9b00000-0xe9cfffff 64bit pref]
[    3.935537] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe9b00000-0xe9cfffff:
[    3.935542]  excluding 0xe9b00000-0xe9cfffff
[    3.968329] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    3.973012] [drm] Initialized nvidia-drm 0.0.0 20130102 for 0000:01:00.0 on minor 0
[    3.973025] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  331.89  Tue Jul  1 13:30:18 PDT 2014
[    3.981721] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    3.990189] wlan0: Broadcom BCM4353 802.11 Hybrid Wireless Controller 6.30.223.248 (r487574)
[    4.076185] input: Dell WMI hotkeys as /devices/virtual/input/input14
[    4.098283] cfg80211: World regulatory domain updated:
[    4.098288] cfg80211:  DFS Master region: unset
[    4.098290] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    4.098293] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    4.098296] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    4.098299] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    4.098302] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    4.098304] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    4.133801] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[    4.133812]  excluding 0xc0000-0xfffff
[    4.133830] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[    4.133964]  excluding 0xa0000000-0xa0ffffff
[    4.133989] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[    4.133995]  excluding 0x60000000-0x60ffffff
[    4.153054] init: failsafe main process (650) killed by TERM signal
[    4.615341] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[    4.615410] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[    4.615465] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[    4.615523] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
[    4.690876] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    4.794772] e1000e 0000:00:19.0: irq 25 for MSI/MSI-X
[    4.794885] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.555273] nvidia 0000:01:00.0: irq 28 for MSI/MSI-X
[    5.557629] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.557690] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.557736] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.557784] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.557827] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.575064] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.575146] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.575188] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    5.575220] ACPI Warning: \_SB_.PCI0.AGP_.VID_._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140926/nsarguments-95)
[    6.747792] dell_wmi: Received unknown WMI event (0x11)
[    8.057804] dell_wmi: Received unknown WMI event (0x11)
[    8.277763] init: plymouth-upstart-bridge main process ended, respawning
[    8.992337] cfg80211: Calling CRDA for country: US
[    8.994781] cfg80211: Regulatory domain changed to country: US
[    8.994786] cfg80211:  DFS Master region: unset
[    8.994788] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    8.994791] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm), (N/A)
[    8.994793] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm), (N/A)
[    8.994796] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (0 s)
[    8.994798] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (0 s)
[    8.994801] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (0 s)
[    8.994803] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm), (N/A)
[    8.994805] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
[   33.700552] audit_printk_skb: 177 callbacks suppressed
[   33.700555] audit: type=1400 audit(1417194076.288:70): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=2666 comm="apparmor_parser"
[   33.700559] audit: type=1400 audit(1417194076.288:71): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=2666 comm="apparmor_parser"
[   33.700855] audit: type=1400 audit(1417194076.288:72): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=2666 comm="apparmor_parser"

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=acpidump

RSD  @ 0x00000000000FE300
  0000: 52 53 44 20 50 54 52 20 51 44 45 4C 4C 20 20 02  RSD PTR QDELL  .
  0010: 18 DF 67 CF 24 00 00 00 18 DE 67 CF 00 00 00 00  ..g.$.....g.....
  0020: B0 00 00 00                                      ....

RSDT @ 0x00000000CF67DF18
  0000: 52 53 44 54 48 00 00 00 01 E8 44 45 4C 4C 20 20  RSDTH.....DELL  
  0010: 45 32 20 20 20 20 20 00 04 20 22 06 4D 53 46 54  E2     .. ".MSFT
  0020: 13 00 01 00 18 EA 76 CF 18 CF 67 CF 18 EB 76 CF  ......v...g...v.
  0030: 18 DD 76 CF 98 DC 76 CF 18 DC 76 CF 98 DB 76 CF  ..v...v...v...v.
  0040: 18 68 76 CF 18 D0 74 CF                          .hv...t.

XSDT @ 0x00000000CF67DE18
  0000: 58 53 44 54 64 00 00 00 01 FD 44 45 4C 4C 20 20  XSDTd.....DELL  
  0010: 45 32 20 20 20 20 20 00 04 20 22 06 4D 53 46 54  E2     .. ".MSFT
  0020: 13 00 01 00 18 FC 75 CF 00 00 00 00 18 CF 67 CF  ......u.......g.
  0030: 00 00 00 00 18 DD 76 CF 00 00 00 00 98 DC 76 CF  ......v.......v.
  0040: 00 00 00 00 18 DC 76 CF 00 00 00 00 98 DB 76 CF  ......v.......v.
  0050: 00 00 00 00 18 68 76 CF 00 00 00 00 18 D0 74 CF  .....hv.......t.
  0060: 00 00 00 00                                      ....

DSDT @ 0x00000000CF73E018
  0000: 44 53 44 54 48 A2 00 00 01 CD 44 45 4C 4C 20 20  DSDTH.....DELL  
  0010: 45 32 20 20 20 20 20 00 01 10 00 00 49 4E 54 4C  E2     .....INTL
  0020: 29 07 08 20 14 1A 42 43 4C 52 01 70 0A 00 60 A2  ).. ..BCLR.p..`.
  0030: 0F 95 60 87 68 42 42 57 52 68 60 0A 00 75 60 14  ..`.hBBWRh`..u`.
  0040: 13 42 42 57 52 03 8C 68 69 56 41 4C 5F 70 6A 56  .BBWR..hiVAL_pjV
  0050: 41 4C 5F 14 12 42 42 52 44 02 8C 68 69 56 41 4C  AL_..BBRD..hiVAL
  0060: 5F A4 56 41 4C 5F 14 13 42 57 57 52 03 8B 68 69  _.VAL_..BWWR..hi
  0070: 56 41 4C 5F 70 6A 56 41 4C 5F 14 12 42 57 52 44  VAL_pjVAL_..BWRD
  0080: 02 8B 68 69 56 41 4C 5F A4 56 41 4C 5F 14 13 42  ..hiVAL_.VAL_..B
  0090: 44 57 52 03 8A 68 69 56 41 4C 5F 70 6A 56 41 4C  DWR..hiVAL_pjVAL
  00A0: 5F 14 12 42 44 52 44 02 8A 68 69 56 41 4C 5F A4  _..BDRD..hiVAL_.
  00B0: 56 41 4C 5F 14 40 05 53 54 52 45 02 08 53 54 52  VAL_.@.STRE..STR
  00C0: 31 11 03 0A 50 08 53 54 52 32 11 03 0A 50 70 68  1...P.STR2...Pph
  00D0: 53 54 52 31 70 69 53 54 52 32 70 00 60 70 01 61  STR1piSTR2p.`p.a
  00E0: A2 22 61 70 42 42 52 44 53 54 52 31 60 61 70 42  ."apBBRDSTR1`apB
  00F0: 42 52 44 53 54 52 32 60 62 A0 07 92 93 61 62 A4  BRDSTR2`b....ab.
  0100: 00 75 60 A4 01 14 39 58 50 54 42 01 70 87 68 60  .u`...9XPTB.p.h`
  0110: A0 08 93 8E 68 0A 02 75 60 08 4F 42 55 46 11 02  ....h..u`.OBUF..
  0120: 60 70 68 4F 42 55 46 A0 12 93 8E 68 0A 02 76 60  `phOBUF....h..v`
  0130: 70 0A 00 88 4F 42 55 46 60 00 A4 4F 42 55 46 14  p...OBUF`..OBUF.
  0140: 2E 53 54 44 47 03 70 68 60 A0 15 92 95 68 0A 0A  .STDG.ph`....h..
  0150: 78 68 0A 0A 60 61 70 53 54 44 47 61 69 6A 6A 72  xh..`apSTDGaijjr
  0160: 60 0A 30 60 70 60 88 69 6A 00 75 6A A4 6A 14 3E  `.0`p`.ij.uj.j.>
  0170: 58 50 54 53 01 08 4C 42 55 46 11 03 0A 20 70 53  XPTS..LBUF... pS
  0180: 54 44 47 68 4C 42 55 46 0A 00 60 70 0A 00 88 4C  TDGhLBUF..`p...L
  0190: 42 55 46 60 00 75 60 08 4F 42 55 46 11 02 60 70  BUF`.u`.OBUF..`p
  01A0: 4C 42 55 46 4F 42 55 46 A4 4F 42 55 46 08 57 39  LBUFOBUF.OBUF.W9
  01B0: 38 53 0D 4D 69 63 72 6F 73 6F 66 74 20 57 69 6E  8S.Microsoft Win
  01C0: 64 6F 77 73 00 08 4E 54 35 53 0D 4D 69 63 72 6F  dows..NT5S.Micro
  01D0: 73 6F 66 74 20 57 69 6E 64 6F 77 73 20 4E 54 00  soft Windows NT.
  01E0: 08 57 49 4E 4D 0D 4D 69 63 72 6F 73 6F 66 74 20  .WINM.Microsoft 
  01F0: 57 69 6E 64 6F 77 73 4D 45 3A 20 4D 69 6C 6C 65  WindowsME: Mille
  0200: 6E 6E 69 75 6D 20 45 64 69 74 69 6F 6E 00 08 57  nnium Edition..W
  0210: 58 50 5F 0D 57 69 6E 64 6F 77 73 20 32 30 30 31  XP_.Windows 2001
  0220: 00 08 57 4C 47 5F 0D 57 69 6E 64 6F 77 73 20 32  ..WLG_.Windows 2
  0230: 30 30 36 00 08 57 49 4E 37 0D 57 69 6E 64 6F 77  006..WIN7.Window
  0240: 73 20 32 30 30 39 00 08 4C 49 4E 58 0D 4C 69 6E  s 2009..LINX.Lin
  0250: 75 78 00 10 47 0F 5C 5F 53 42 5F 08 41 43 4F 53  ux..G.\_SB_.ACOS
  0260: 0A 00 14 45 0B 4F 53 49 44 00 A0 48 0A 93 41 43  ...E.OSID..H..AC
  0270: 4F 53 0A 00 70 0A 01 41 43 4F 53 A0 42 05 5B 12  OS..p..ACOS.B.[.
  0280: 5C 5F 4F 53 49 60 A0 11 5C 5F 4F 53 49 57 58 50  \_OSI`..\_OSIWXP
  0290: 5F 70 0A 10 41 43 4F 53 A0 11 5C 5F 4F 53 49 57  _p..ACOS..\_OSIW
  02A0: 4C 47 5F 70 0A 20 41 43 4F 53 A0 11 5C 5F 4F 53  LG_p. ACOS..\_OS
  02B0: 49 57 49 4E 37 70 0A 80 41 43 4F 53 A0 11 5C 5F  IWIN7p..ACOS..\_
  02C0: 4F 53 49 4C 49 4E 58 70 0A 40 41 43 4F 53 A1 44  OSILINXp.@ACOS.D
  02D0: 04 A0 15 53 54 52 45 5C 5F 4F 53 5F 57 39 38 53  ...STRE\_OS_W98S
  02E0: 70 0A 02 41 43 4F 53 A0 15 53 54 52 45 5C 5F 4F  p..ACOS..STRE\_O
  02F0: 53 5F 57 49 4E 4D 70 0A 04 41 43 4F 53 A0 15 53  S_WINMp..ACOS..S
  0300: 54 52 45 5C 5F 4F 53 5F 4E 54 35 53 70 0A 08 41  TRE\_OS_NT5Sp..A
  0310: 43 4F 53 A4 41 43 4F 53 14 16 53 54 4F 53 00 4F  COS.ACOS..STOS.O
  0320: 53 49 44 47 45 4E 53 0A 06 41 43 4F 53 0A 00 14  SIDGENS..ACOS...
  0330: 0A 53 4F 53 30 02 53 54 4F 53 14 10 53 4F 53 34  .SOS0.STOS..SOS4
  0340: 02 A0 09 93 68 0A 04 53 54 4F 53 08 53 53 31 5F  ....h..STOS.SS1_
  0350: 0A 00 08 53 53 32 5F 0A 00 08 53 53 33 5F 0A 00  ...SS2_...SS3_..
  0360: 08 53 53 34 5F 0A 00 08 49 4F 53 54 0B 00 44 08  .SS4_...IOST..D.
  0370: 54 4F 50 4D 0C FF FF FF CF 08 52 4F 4D 53 0C 00  TOPM......ROMS..
  0380: 00 E0 FF 08 4D 47 31 42 0C 00 00 00 00 08 4D 47  ....MG1B......MG
  0390: 31 4C 0C 00 00 00 00 08 4D 47 32 42 0C 00 00 00  1L......MG2B....
  03A0: D0 08 4D 47 32 4C 0C 00 C0 80 2C 08 4D 43 48 42  ..MG2L....,.MCHB
  03B0: 0C 00 00 D1 FE 08 4D 43 48 4C 0B 00 40 08 45 47  ......MCHL..@.EG
  03C0: 50 42 0C 00 90 D1 FE 08 45 47 50 4C 0B 00 10 08  PB......EGPL....
  03D0: 44 4D 49 42 0C 00 80 D1 FE 08 44 4D 49 4C 0B 00  DMIB......DMIL..
  03E0: 10 08 49 46 50 42 0C 00 40 D1 FE 08 49 46 50 4C  ..IFPB..@...IFPL
  03F0: 0B 00 10 08 50 45 42 53 0C 00 00 00 F8 08 50 45  ....PEBS......PE
  0400: 4C 4E 0C 00 00 00 04 08 54 54 54 42 0C 00 00 D2  LN......TTTB....
  0410: FE 08 54 54 54 4C 0C 00 00 02 00 08 50 42 4C 4B  ..TTTL......PBLK
  0420: 0B 10 04 08 53 4D 49 50 0A B2 08 50 4D 33 30 0B  ....SMIP...PM30.
  0430: 30 04 08 53 52 43 42 0C 00 C0 D1 FE 08 53 52 43  0..SRCB......SRC
  0440: 4C 0B 00 40 08 53 55 53 57 0A FF 08 46 4D 42 4C  L..@.SUSW...FMBL
  0450: 0A 01 08 46 44 54 50 0A 02 08 42 52 46 5F 0A 01  ...FDTP...BRF_..
  0460: 08 42 50 48 5F 0A 02 08 42 4C 43 5F 0A 03 08 42  .BPH_...BLC_...B
  0470: 52 46 53 0A 04 08 42 50 48 53 0A 05 08 42 4C 43  RFS...BPHS...BLC
  0480: 54 0A 06 08 42 52 46 34 0A 07 08 42 45 50 5F 0A  T...BRF4...BEP_.
  0490: 08 08 42 42 46 5F 0A 09 08 42 4F 46 5F 0A 0A 08  ..BBF_...BOF_...
  04A0: 42 50 54 5F 0A 0B 08 53 52 41 46 0A 0C 08 57 57  BPT_...SRAF...WW
  04B0: 50 5F 0A 0D 08 53 44 4F 45 0A 0E 08 41 43 50 48  P_...SDOE...ACPH
  04C0: 0A DE 08 41 53 53 42 0A 00 08 41 4F 54 42 0A 00  ...ASSB...AOTB..
  04D0: 08 41 41 58 42 0A 00 08 50 45 48 50 0A 00 08 53  .AAXB...PEHP...S
  04E0: 48 50 43 0A 01 08 50 45 50 4D 0A 00 08 50 45 45  HPC...PEPM...PEE
  04F0: 52 0A 00 08 50 45 43 53 0A 00 08 49 54 4B 45 0A  R...PECS...ITKE.
  0500: 00 08 54 52 54 50 0A 01 08 54 52 54 44 0A 02 08  ..TRTP...TRTD...
  0510: 54 52 54 49 0A 03 08 47 43 44 44 0A 01 08 44 53  TRTI...GCDD...DS
  0520: 54 41 0A 0A 08 44 53 4C 4F 0A 0C 08 44 53 4C 43  TA...DSLO...DSLC
  0530: 0A 0E 08 50 49 54 53 0A 10 08 53 42 43 53 0A 12  ...PITS...SBCS..
  0540: 08 53 41 4C 53 0A 13 08 4C 53 53 53 0A 2A 08 53  .SALS...LSSS.*.S
  0550: 4F 4F 54 0A 35 08 50 44 42 52 0A 4D 08 53 50 33  OOT.5.PDBR.M.SP3
  0560: 4F 0A 2E 08 53 50 31 4F 0B 4E 09 08 49 4F 32 42  O...SP1O.N..IO2B
  0570: 0B 80 06 08 49 4F 50 42 0B 4E 09 08 53 50 32 4F  ....IOPB.N..SP2O
  0580: 0A 4E 08 54 43 47 4D 0A 01 5B 80 47 4E 56 53 00  .N.TCGM..[.GNVS.
  0590: 0C 18 6C 76 CF 0B 73 01 5B 81 4F 33 47 4E 56 53  ..lv..s.[.O3GNVS
  05A0: 10 4F 53 59 53 10 53 4D 49 46 08 50 52 4D 30 08  .OSYS.SMIF.PRM0.
  05B0: 50 52 4D 31 08 53 43 49 46 08 50 52 4D 32 08 50  PRM1.SCIF.PRM2.P
  05C0: 52 4D 33 08 4C 43 4B 46 08 50 52 4D 34 08 50 52  RM3.LCKF.PRM4.PR
  05D0: 4D 35 08 50 38 30 44 20 4C 49 44 53 08 50 57 52  M5.P80D LIDS.PWR
  05E0: 53 08 44 42 47 53 08 54 48 4F 46 08 41 43 54 31  S.DBGS.THOF.ACT1
  05F0: 08 41 43 54 54 08 50 53 56 54 08 54 43 31 56 08  .ACTT.PSVT.TC1V.
  0600: 54 43 32 56 08 54 53 50 56 08 43 52 54 54 08 44  TC2V.TSPV.CRTT.D
  0610: 54 53 45 08 44 54 53 31 08 44 54 53 32 08 44 54  TSE.DTS1.DTS2.DT
  0620: 53 46 08 00 38 52 45 56 4E 08 00 10 41 50 49 43  SF..8REVN...APIC
  0630: 08 54 43 4E 54 08 50 43 50 30 08 50 43 50 31 08  .TCNT.PCP0.PCP1.
  0640: 50 50 43 4D 08 50 50 4D 46 20 00 08 4E 41 54 50  PPCM.PPMF ..NATP
  0650: 08 43 4D 41 50 08 43 4D 42 50 08 4C 50 54 50 08  .CMAP.CMBP.LPTP.
  0660: 46 44 43 50 08 43 4D 43 50 08 43 49 52 50 08 53  FDCP.CMCP.CIRP.S
  0670: 4D 53 43 08 57 33 38 31 08 53 4D 43 31 08 49 47  MSC.W381.SMC1.IG
  0680: 44 53 08 54 4C 53 54 08 43 41 44 4C 08 50 41 44  DS.TLST.CADL.PAD
  0690: 4C 08 43 53 54 45 10 4E 53 54 45 10 53 53 54 45  L.CSTE.NSTE.SSTE
  06A0: 10 4E 44 49 44 08 44 49 44 31 20 44 49 44 32 20  .NDID.DID1 DID2 
  06B0: 44 49 44 33 20 44 49 44 34 20 44 49 44 35 20 4B  DID3 DID4 DID5 K
  06C0: 53 56 30 20 4B 53 56 31 08 00 38 42 4C 43 53 08  SV0 KSV1..8BLCS.
  06D0: 42 52 54 4C 08 41 4C 53 45 08 41 4C 41 46 08 4C  BRTL.ALSE.ALAF.L
  06E0: 4C 4F 57 08 4C 48 49 48 08 00 08 45 4D 41 45 08  LOW.LHIH...EMAE.
  06F0: 45 4D 41 50 10 45 4D 41 4C 10 00 08 4D 45 46 45  EMAP.EMAL...MEFE
  0700: 08 44 53 54 53 08 00 10 54 50 4D 50 08 54 50 4D  .DSTS...TPMP.TPM
  0710: 45 08 4D 4F 52 44 08 54 43 47 50 08 50 50 52 50  E.MORD.TCGP.PPRP
  0720: 20 50 50 52 51 08 4C 50 50 52 08 47 54 46 30 38   PPRQ.LPPR.GTF08
  0730: 47 54 46 32 38 49 44 45 4D 08 47 54 46 31 38 42  GTF28IDEM.GTF18B
  0740: 49 44 5F 08 00 38 54 43 4D 50 08 54 43 4D 45 08  ID_..8TCMP.TCME.
  0750: 00 40 04 41 53 4C 42 20 49 42 54 54 08 49 50 41  .@.ASLB IBTT.IPA
  0760: 54 08 49 54 56 46 08 49 54 56 4D 08 49 50 53 43  T.ITVF.ITVM.IPSC
  0770: 08 49 42 4C 43 08 49 42 49 41 08 49 53 53 43 08  .IBLC.IBIA.ISSC.
  0780: 49 34 30 39 08 49 35 30 39 08 49 36 30 39 08 49  I409.I509.I609.I
  0790: 37 30 39 08 49 50 43 46 08 49 44 4D 53 08 49 46  709.IPCF.IDMS.IF
  07A0: 31 45 08 48 56 43 4F 08 4E 58 44 31 20 4E 58 44  1E.HVCO.NXD1 NXD
  07B0: 32 20 4E 58 44 33 20 4E 58 44 34 20 4E 58 44 35  2 NXD3 NXD4 NXD5
  07C0: 20 4E 58 44 36 20 4E 58 44 37 20 4E 58 44 38 20   NXD6 NXD7 NXD8 
  07D0: 47 53 4D 49 08 50 41 56 50 08 00 08 4F 53 43 43  GSMI.PAVP...OSCC
  07E0: 08 4E 45 58 50 08 53 44 47 56 08 53 44 44 56 08  .NEXP.SDGV.SDDV.
  07F0: 00 30 44 53 45 4E 08 45 43 4F 4E 08 47 50 49 43  .0DSEN.ECON.GPIC
  0800: 08 43 54 59 50 08 4C 30 31 43 08 56 46 4E 30 08  .CTYP.L01C.VFN0.
  0810: 56 46 4E 31 08 00 40 07 4E 56 47 41 20 4E 56 48  VFN1..@.NVGA NVH
  0820: 41 20 41 4D 44 41 20 44 49 44 36 20 44 49 44 37  A AMDA DID6 DID7
  0830: 20 44 49 44 38 20 45 42 41 53 20 43 50 53 50 20   DID8 EBAS CPSP 
  0840: 45 45 43 50 20 45 56 43 50 20 58 42 41 53 20 4F  EECP EVCP XBAS O
  0850: 42 53 31 20 4F 42 53 32 20 4F 42 53 33 20 4F 42  BS1 OBS2 OBS3 OB
  0860: 53 34 20 4F 42 53 35 20 4F 42 53 36 20 4F 42 53  S4 OBS5 OBS6 OBS
  0870: 37 20 4F 42 53 38 20 00 48 05 41 54 4D 43 08 50  7 OBS8 .H.ATMC.P
  0880: 54 4D 43 08 41 54 52 41 08 50 54 52 41 08 50 4E  TMC.ATRA.PTRA.PN
  0890: 48 4D 20 54 42 41 42 20 54 42 41 48 20 52 54 49  HM TBAB TBAH RTI
  08A0: 50 08 54 53 4F 44 08 41 54 50 43 08 50 54 50 43  P.TSOD.ATPC.PTPC
  08B0: 08 50 46 4C 56 08 42 52 45 56 08 44 50 42 4D 08  .PFLV.BREV.DPBM.
  08C0: 44 50 43 4D 08 44 50 44 4D 08 41 4C 46 50 08 49  DPCM.DPDM.ALFP.I
  08D0: 4D 4F 4E 08 46 46 53 4E 08 10 8F 7F 03 5C 5F 53  MON.FFSN.....\_S
  08E0: 42 5F 08 50 52 30 30 12 43 25 25 12 0F 04 0C FF  B_.PR00.C%%.....
  08F0: FF 01 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0900: FF 01 00 0A 01 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0910: FF 01 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0920: FF 01 00 0A 03 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  0930: FF 02 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0940: FF 1F 00 0A 00 4C 4E 4B 46 0A 00 12 0F 04 0C FF  .....LNKF.......
  0950: FF 1F 00 0A 01 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  0960: FF 1F 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0970: FF 1F 00 0A 03 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0980: FF 1D 00 0A 00 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0990: FF 1A 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  09A0: FF 1B 00 0A 00 4C 4E 4B 47 0A 00 12 0F 04 0C FF  .....LNKG.......
  09B0: FF 1C 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  09C0: FF 1C 00 0A 01 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  09D0: FF 1C 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  09E0: FF 1C 00 0A 03 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  09F0: FF 19 00 0A 00 4C 4E 4B 45 0A 00 12 0F 04 0C FF  .....LNKE.......
  0A00: FF 16 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0A10: FF 16 00 0A 01 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  0A20: FF 16 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0A30: FF 16 00 0A 03 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0A40: FF 03 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0A50: FF 03 00 0A 01 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0A60: FF 03 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0A70: FF 03 00 0A 03 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  0A80: FF 04 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0A90: FF 04 00 0A 01 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0AA0: FF 04 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0AB0: FF 04 00 0A 03 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  0AC0: FF 05 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0AD0: FF 05 00 0A 01 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0AE0: FF 05 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0AF0: FF 05 00 0A 03 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  0B00: FF 06 00 0A 00 4C 4E 4B 41 0A 00 12 0F 04 0C FF  .....LNKA.......
  0B10: FF 06 00 0A 01 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  0B20: FF 06 00 0A 02 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  0B30: FF 06 00 0A 03 4C 4E 4B 44 0A 00 08 41 52 30 30  .....LNKD...AR00
  0B40: 12 49 20 25 12 0D 04 0C FF FF 01 00 0A 00 0A 00  .I %............
  0B50: 0A 10 12 0D 04 0C FF FF 01 00 0A 01 0A 00 0A 11  ................
  0B60: 12 0D 04 0C FF FF 01 00 0A 02 0A 00 0A 12 12 0D  ................
  0B70: 04 0C FF FF 01 00 0A 03 0A 00 0A 13 12 0D 04 0C  ................
  0B80: FF FF 02 00 0A 00 0A 00 0A 10 12 0D 04 0C FF FF  ................
  0B90: 1F 00 0A 00 0A 00 0A 15 12 0D 04 0C FF FF 1F 00  ................
  0BA0: 0A 01 0A 00 0A 13 12 0D 04 0C FF FF 1F 00 0A 02  ................
  0BB0: 0A 00 0A 12 12 0D 04 0C FF FF 1F 00 0A 03 0A 00  ................
  0BC0: 0A 10 12 0D 04 0C FF FF 1D 00 0A 00 0A 00 0A 11  ................
  0BD0: 12 0D 04 0C FF FF 1A 00 0A 00 0A 00 0A 10 12 0D  ................
  0BE0: 04 0C FF FF 1B 00 0A 00 0A 00 0A 16 12 0D 04 0C  ................
  0BF0: FF FF 1C 00 0A 00 0A 00 0A 10 12 0D 04 0C FF FF  ................
  0C00: 1C 00 0A 01 0A 00 0A 11 12 0D 04 0C FF FF 1C 00  ................
  0C10: 0A 02 0A 00 0A 12 12 0D 04 0C FF FF 1C 00 0A 03  ................
  0C20: 0A 00 0A 13 12 0D 04 0C FF FF 19 00 0A 00 0A 00  ................
  0C30: 0A 14 12 0D 04 0C FF FF 16 00 0A 00 0A 00 0A 10  ................
  0C40: 12 0D 04 0C FF FF 16 00 0A 01 0A 00 0A 13 12 0D  ................
  0C50: 04 0C FF FF 16 00 0A 02 0A 00 0A 12 12 0D 04 0C  ................
  0C60: FF FF 16 00 0A 03 0A 00 0A 11 12 0D 04 0C FF FF  ................
  0C70: 03 00 0A 00 0A 00 0A 10 12 0D 04 0C FF FF 03 00  ................
  0C80: 0A 01 0A 00 0A 11 12 0D 04 0C FF FF 03 00 0A 02  ................
  0C90: 0A 00 0A 12 12 0D 04 0C FF FF 03 00 0A 03 0A 00  ................
  0CA0: 0A 13 12 0D 04 0C FF FF 04 00 0A 00 0A 00 0A 10  ................
  0CB0: 12 0D 04 0C FF FF 04 00 0A 01 0A 00 0A 11 12 0D  ................
  0CC0: 04 0C FF FF 04 00 0A 02 0A 00 0A 12 12 0D 04 0C  ................
  0CD0: FF FF 04 00 0A 03 0A 00 0A 13 12 0D 04 0C FF FF  ................
  0CE0: 05 00 0A 00 0A 00 0A 10 12 0D 04 0C FF FF 05 00  ................
  0CF0: 0A 01 0A 00 0A 11 12 0D 04 0C FF FF 05 00 0A 02  ................
  0D00: 0A 00 0A 12 12 0D 04 0C FF FF 05 00 0A 03 0A 00  ................
  0D10: 0A 13 12 0D 04 0C FF FF 06 00 0A 00 0A 00 0A 10  ................
  0D20: 12 0D 04 0C FF FF 06 00 0A 01 0A 00 0A 11 12 0D  ................
  0D30: 04 0C FF FF 06 00 0A 02 0A 00 0A 12 12 0D 04 0C  ................
  0D40: FF FF 06 00 0A 03 0A 00 0A 13 08 50 52 30 34 12  ...........PR04.
  0D50: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 41 0A 00  :.........LNKA..
  0D60: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 42 0A 00 12 0D  ........LNKB....
  0D70: 04 0B FF FF 0A 02 4C 4E 4B 43 0A 00 12 0D 04 0B  ......LNKC......
  0D80: FF FF 0A 03 4C 4E 4B 44 0A 00 08 41 52 30 34 12  ....LNKD...AR04.
  0D90: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 10 12 0B  2...............
  0DA0: 04 0B FF FF 0A 01 0A 00 0A 11 12 0B 04 0B FF FF  ................
  0DB0: 0A 02 0A 00 0A 12 12 0B 04 0B FF FF 0A 03 0A 00  ................
  0DC0: 0A 13 08 50 52 30 35 12 3A 04 12 0D 04 0B FF FF  ...PR05.:.......
  0DD0: 0A 00 4C 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKB..........
  0DE0: 4C 4E 4B 43 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKC..........LN
  0DF0: 4B 44 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 41  KD..........LNKA
  0E00: 0A 00 08 41 52 30 35 12 32 04 12 0B 04 0B FF FF  ...AR05.2.......
  0E10: 0A 00 0A 00 0A 11 12 0B 04 0B FF FF 0A 01 0A 00  ................
  0E20: 0A 12 12 0B 04 0B FF FF 0A 02 0A 00 0A 13 12 0B  ................
  0E30: 04 0B FF FF 0A 03 0A 00 0A 10 08 50 52 30 36 12  ...........PR06.
  0E40: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 43 0A 00  :.........LNKC..
  0E50: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 44 0A 00 12 0D  ........LNKD....
  0E60: 04 0B FF FF 0A 02 4C 4E 4B 41 0A 00 12 0D 04 0B  ......LNKA......
  0E70: FF FF 0A 03 4C 4E 4B 42 0A 00 08 41 52 30 36 12  ....LNKB...AR06.
  0E80: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 12 12 0B  2...............
  0E90: 04 0B FF FF 0A 01 0A 00 0A 13 12 0B 04 0B FF FF  ................
  0EA0: 0A 02 0A 00 0A 10 12 0B 04 0B FF FF 0A 03 0A 00  ................
  0EB0: 0A 11 08 50 52 30 37 12 3A 04 12 0D 04 0B FF FF  ...PR07.:.......
  0EC0: 0A 00 4C 4E 4B 44 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKD..........
  0ED0: 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKA..........LN
  0EE0: 4B 42 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 43  KB..........LNKC
  0EF0: 0A 00 08 41 52 30 37 12 32 04 12 0B 04 0B FF FF  ...AR07.2.......
  0F00: 0A 00 0A 00 0A 13 12 0B 04 0B FF FF 0A 01 0A 00  ................
  0F10: 0A 10 12 0B 04 0B FF FF 0A 02 0A 00 0A 11 12 0B  ................
  0F20: 04 0B FF FF 0A 03 0A 00 0A 12 08 50 52 30 38 12  ...........PR08.
  0F30: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 41 0A 00  :.........LNKA..
  0F40: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 42 0A 00 12 0D  ........LNKB....
  0F50: 04 0B FF FF 0A 02 4C 4E 4B 43 0A 00 12 0D 04 0B  ......LNKC......
  0F60: FF FF 0A 03 4C 4E 4B 44 0A 00 08 41 52 30 38 12  ....LNKD...AR08.
  0F70: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 10 12 0B  2...............
  0F80: 04 0B FF FF 0A 01 0A 00 0A 11 12 0B 04 0B FF FF  ................
  0F90: 0A 02 0A 00 0A 12 12 0B 04 0B FF FF 0A 03 0A 00  ................
  0FA0: 0A 13 08 50 52 30 45 12 3A 04 12 0D 04 0B FF FF  ...PR0E.:.......
  0FB0: 0A 00 4C 4E 4B 43 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKC..........
  0FC0: 4C 4E 4B 44 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKD..........LN
  0FD0: 4B 41 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 42  KA..........LNKB
  0FE0: 0A 00 08 41 52 30 45 12 32 04 12 0B 04 0B FF FF  ...AR0E.2.......
  0FF0: 0A 00 0A 00 0A 12 12 0B 04 0B FF FF 0A 01 0A 00  ................
  1000: 0A 13 12 0B 04 0B FF FF 0A 02 0A 00 0A 10 12 0B  ................
  1010: 04 0B FF FF 0A 03 0A 00 0A 11 08 50 52 30 46 12  ...........PR0F.
  1020: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 44 0A 00  :.........LNKD..
  1030: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 41 0A 00 12 0D  ........LNKA....
  1040: 04 0B FF FF 0A 02 4C 4E 4B 42 0A 00 12 0D 04 0B  ......LNKB......
  1050: FF FF 0A 03 4C 4E 4B 43 0A 00 08 41 52 30 46 12  ....LNKC...AR0F.
  1060: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 13 12 0B  2...............
  1070: 04 0B FF FF 0A 01 0A 00 0A 10 12 0B 04 0B FF FF  ................
  1080: 0A 02 0A 00 0A 11 12 0B 04 0B FF FF 0A 03 0A 00  ................
  1090: 0A 12 08 50 52 30 31 12 4B 13 14 12 0F 04 0C FF  ...PR01.K.......
  10A0: FF 03 00 0A 00 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  10B0: FF 03 00 0A 01 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  10C0: FF 03 00 0A 02 4C 4E 4B 46 0A 00 12 0F 04 0C FF  .....LNKF.......
  10D0: FF 03 00 0A 03 4C 4E 4B 47 0A 00 12 0F 04 0C FF  .....LNKG.......
  10E0: FF 02 00 0A 00 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  10F0: FF 02 00 0A 01 4C 4E 4B 44 0A 00 12 0F 04 0C FF  .....LNKD.......
  1100: FF 02 00 0A 02 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  1110: FF 02 00 0A 03 4C 4E 4B 41 0A 00 12 0D 04 0B FF  .....LNKA.......
  1120: FF 0A 00 4C 4E 4B 46 0A 00 12 0D 04 0B FF FF 0A  ...LNKF.........
  1130: 01 4C 4E 4B 47 0A 00 12 0D 04 0B FF FF 0A 02 4C  .LNKG..........L
  1140: 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B  NKB..........LNK
  1150: 45 0A 00 12 0F 04 0C FF FF 01 00 0A 00 4C 4E 4B  E............LNK
  1160: 47 0A 00 12 0F 04 0C FF FF 01 00 0A 01 4C 4E 4B  G............LNK
  1170: 46 0A 00 12 0F 04 0C FF FF 01 00 0A 02 4C 4E 4B  F............LNK
  1180: 45 0A 00 12 0F 04 0C FF FF 01 00 0A 03 4C 4E 4B  E............LNK
  1190: 42 0A 00 12 0F 04 0C FF FF 05 00 0A 00 4C 4E 4B  B............LNK
  11A0: 43 0A 00 12 0F 04 0C FF FF 05 00 0A 01 4C 4E 4B  C............LNK
  11B0: 45 0A 00 12 0F 04 0C FF FF 05 00 0A 02 4C 4E 4B  E............LNK
  11C0: 47 0A 00 12 0F 04 0C FF FF 05 00 0A 03 4C 4E 4B  G............LNK
  11D0: 46 0A 00 08 41 52 30 31 12 43 11 14 12 0D 04 0C  F...AR01.C......
  11E0: FF FF 03 00 0A 00 0A 00 0A 13 12 0D 04 0C FF FF  ................
  11F0: 03 00 0A 01 0A 00 0A 12 12 0D 04 0C FF FF 03 00  ................
  1200: 0A 02 0A 00 0A 15 12 0D 04 0C FF FF 03 00 0A 03  ................
  1210: 0A 00 0A 16 12 0D 04 0C FF FF 02 00 0A 00 0A 00  ................
  1220: 0A 12 12 0D 04 0C FF FF 02 00 0A 01 0A 00 0A 13  ................
  1230: 12 0D 04 0C FF FF 02 00 0A 02 0A 00 0A 11 12 0D  ................
  1240: 04 0C FF FF 02 00 0A 03 0A 00 0A 10 12 0B 04 0B  ................
  1250: FF FF 0A 00 0A 00 0A 15 12 0B 04 0B FF FF 0A 01  ................
  1260: 0A 00 0A 16 12 0B 04 0B FF FF 0A 02 0A 00 0A 11  ................
  1270: 12 0B 04 0B FF FF 0A 03 0A 00 0A 14 12 0D 04 0C  ................
  1280: FF FF 01 00 0A 00 0A 00 0A 16 12 0D 04 0C FF FF  ................
  1290: 01 00 0A 01 0A 00 0A 15 12 0D 04 0C FF FF 01 00  ................
  12A0: 0A 02 0A 00 0A 14 12 0D 04 0C FF FF 01 00 0A 03  ................
  12B0: 0A 00 0A 11 12 0D 04 0C FF FF 05 00 0A 00 0A 00  ................
  12C0: 0A 12 12 0D 04 0C FF FF 05 00 0A 01 0A 00 0A 14  ................
  12D0: 12 0D 04 0C FF FF 05 00 0A 02 0A 00 0A 16 12 0D  ................
  12E0: 04 0C FF FF 05 00 0A 03 0A 00 0A 15 08 50 52 30  .............PR0
  12F0: 41 12 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 41  A.:.........LNKA
  1300: 0A 00 12 0D 04 0B FF FF 0A 01 4C 4E 4B 42 0A 00  ..........LNKB..
  1310: 12 0D 04 0B FF FF 0A 02 4C 4E 4B 43 0A 00 12 0D  ........LNKC....
  1320: 04 0B FF FF 0A 03 4C 4E 4B 44 0A 00 08 41 52 30  ......LNKD...AR0
  1330: 41 12 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 10  A.2.............
  1340: 12 0B 04 0B FF FF 0A 01 0A 00 0A 11 12 0B 04 0B  ................
  1350: FF FF 0A 02 0A 00 0A 12 12 0B 04 0B FF FF 0A 03  ................
  1360: 0A 00 0A 13 08 50 52 30 43 12 3A 04 12 0D 04 0B  .....PR0C.:.....
  1370: FF FF 0A 00 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF  ....LNKA........
  1380: 0A 01 4C 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 02  ..LNKB..........
  1390: 4C 4E 4B 43 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E  LNKC..........LN
  13A0: 4B 44 0A 00 08 41 52 30 43 12 32 04 12 0B 04 0B  KD...AR0C.2.....
  13B0: FF FF 0A 00 0A 00 0A 10 12 0B 04 0B FF FF 0A 01  ................
  13C0: 0A 00 0A 11 12 0B 04 0B FF FF 0A 02 0A 00 0A 12  ................
  13D0: 12 0B 04 0B FF FF 0A 03 0A 00 0A 13 08 50 52 38  .............PR8
  13E0: 30 12 43 2A 2A 12 0F 04 0C FF FF 01 00 0A 00 4C  0.C**..........L
  13F0: 4E 4B 41 0A 00 12 0F 04 0C FF FF 01 00 0A 01 4C  NKA............L
  1400: 4E 4B 42 0A 00 12 0F 04 0C FF FF 01 00 0A 02 4C  NKB............L
  1410: 4E 4B 43 0A 00 12 0F 04 0C FF FF 01 00 0A 03 4C  NKC............L
  1420: 4E 4B 44 0A 00 12 0F 04 0C FF FF 03 00 0A 00 4C  NKD............L
  1430: 4E 4B 41 0A 00 12 0F 04 0C FF FF 03 00 0A 01 4C  NKA............L
  1440: 4E 4B 42 0A 00 12 0F 04 0C FF FF 03 00 0A 02 4C  NKB............L
  1450: 4E 4B 43 0A 00 12 0F 04 0C FF FF 03 00 0A 03 4C  NKC............L
  1460: 4E 4B 44 0A 00 12 0F 04 0C FF FF 04 00 0A 00 4C  NKD............L
  1470: 4E 4B 41 0A 00 12 0F 04 0C FF FF 04 00 0A 01 4C  NKA............L
  1480: 4E 4B 42 0A 00 12 0F 04 0C FF FF 04 00 0A 02 4C  NKB............L
  1490: 4E 4B 43 0A 00 12 0F 04 0C FF FF 04 00 0A 03 4C  NKC............L
  14A0: 4E 4B 44 0A 00 12 0F 04 0C FF FF 05 00 0A 00 4C  NKD............L
  14B0: 4E 4B 41 0A 00 12 0F 04 0C FF FF 05 00 0A 01 4C  NKA............L
  14C0: 4E 4B 42 0A 00 12 0F 04 0C FF FF 05 00 0A 02 4C  NKB............L
  14D0: 4E 4B 43 0A 00 12 0F 04 0C FF FF 05 00 0A 03 4C  NKC............L
  14E0: 4E 4B 44 0A 00 12 0F 04 0C FF FF 06 00 0A 00 4C  NKD............L
  14F0: 4E 4B 41 0A 00 12 0F 04 0C FF FF 06 00 0A 01 4C  NKA............L
  1500: 4E 4B 42 0A 00 12 0F 04 0C FF FF 06 00 0A 02 4C  NKB............L
  1510: 4E 4B 43 0A 00 12 0F 04 0C FF FF 06 00 0A 03 4C  NKC............L
  1520: 4E 4B 44 0A 00 12 0F 04 0C FF FF 1F 00 0A 00 4C  NKD............L
  1530: 4E 4B 46 0A 00 12 0F 04 0C FF FF 1F 00 0A 01 4C  NKF............L
  1540: 4E 4B 44 0A 00 12 0F 04 0C FF FF 1F 00 0A 02 4C  NKD............L
  1550: 4E 4B 43 0A 00 12 0F 04 0C FF FF 1F 00 0A 03 4C  NKC............L
  1560: 4E 4B 41 0A 00 12 0F 04 0C FF FF 1D 00 0A 00 4C  NKA............L
  1570: 4E 4B 42 0A 00 12 0F 04 0C FF FF 1D 00 0A 01 4C  NKB............L
  1580: 4E 4B 44 0A 00 12 0F 04 0C FF FF 1D 00 0A 02 4C  NKD............L
  1590: 4E 4B 41 0A 00 12 0F 04 0C FF FF 1D 00 0A 03 4C  NKA............L
  15A0: 4E 4B 43 0A 00 12 0F 04 0C FF FF 1A 00 0A 00 4C  NKC............L
  15B0: 4E 4B 41 0A 00 12 0F 04 0C FF FF 1A 00 0A 01 4C  NKA............L
  15C0: 4E 4B 46 0A 00 12 0F 04 0C FF FF 1A 00 0A 02 4C  NKF............L
  15D0: 4E 4B 43 0A 00 12 0F 04 0C FF FF 1A 00 0A 03 4C  NKC............L
  15E0: 4E 4B 44 0A 00 12 0F 04 0C FF FF 1B 00 0A 00 4C  NKD............L
  15F0: 4E 4B 47 0A 00 12 0F 04 0C FF FF 1C 00 0A 00 4C  NKG............L
  1600: 4E 4B 41 0A 00 12 0F 04 0C FF FF 1C 00 0A 01 4C  NKA............L
  1610: 4E 4B 42 0A 00 12 0F 04 0C FF FF 1C 00 0A 02 4C  NKB............L
  1620: 4E 4B 43 0A 00 12 0F 04 0C FF FF 1C 00 0A 03 4C  NKC............L
  1630: 4E 4B 44 0A 00 12 0F 04 0C FF FF 19 00 0A 00 4C  NKD............L
  1640: 4E 4B 45 0A 00 12 0F 04 0C FF FF 16 00 0A 00 4C  NKE............L
  1650: 4E 4B 41 0A 00 12 0F 04 0C FF FF 16 00 0A 01 4C  NKA............L
  1660: 4E 4B 44 0A 00 12 0F 04 0C FF FF 16 00 0A 02 4C  NKD............L
  1670: 4E 4B 43 0A 00 12 0F 04 0C FF FF 16 00 0A 03 4C  NKC............L
  1680: 4E 4B 42 0A 00 08 41 52 38 30 12 4F 24 2A 12 0D  NKB...AR80.O$*..
  1690: 04 0C FF FF 01 00 0A 00 0A 00 0A 10 12 0D 04 0C  ................
  16A0: FF FF 01 00 0A 01 0A 00 0A 11 12 0D 04 0C FF FF  ................
  16B0: 01 00 0A 02 0A 00 0A 12 12 0D 04 0C FF FF 01 00  ................
  16C0: 0A 03 0A 00 0A 13 12 0D 04 0C FF FF 03 00 0A 00  ................
  16D0: 0A 00 0A 10 12 0D 04 0C FF FF 03 00 0A 01 0A 00  ................
  16E0: 0A 11 12 0D 04 0C FF FF 03 00 0A 02 0A 00 0A 12  ................
  16F0: 12 0D 04 0C FF FF 03 00 0A 03 0A 00 0A 13 12 0D  ................
  1700: 04 0C FF FF 04 00 0A 00 0A 00 0A 10 12 0D 04 0C  ................
  1710: FF FF 04 00 0A 01 0A 00 0A 11 12 0D 04 0C FF FF  ................
  1720: 04 00 0A 02 0A 00 0A 12 12 0D 04 0C FF FF 04 00  ................
  1730: 0A 03 0A 00 0A 13 12 0D 04 0C FF FF 05 00 0A 00  ................
  1740: 0A 00 0A 10 12 0D 04 0C FF FF 05 00 0A 01 0A 00  ................
  1750: 0A 11 12 0D 04 0C FF FF 05 00 0A 02 0A 00 0A 12  ................
  1760: 12 0D 04 0C FF FF 05 00 0A 03 0A 00 0A 13 12 0D  ................
  1770: 04 0C FF FF 06 00 0A 00 0A 00 0A 10 12 0D 04 0C  ................
  1780: FF FF 06 00 0A 01 0A 00 0A 11 12 0D 04 0C FF FF  ................
  1790: 06 00 0A 02 0A 00 0A 12 12 0D 04 0C FF FF 06 00  ................
  17A0: 0A 03 0A 00 0A 13 12 0D 04 0C FF FF 1F 00 0A 00  ................
  17B0: 0A 00 0A 15 12 0D 04 0C FF FF 1F 00 0A 01 0A 00  ................
  17C0: 0A 13 12 0D 04 0C FF FF 1F 00 0A 02 0A 00 0A 12  ................
  17D0: 12 0D 04 0C FF FF 1F 00 0A 03 0A 00 0A 10 12 0D  ................
  17E0: 04 0C FF FF 1D 00 0A 00 0A 00 0A 11 12 0D 04 0C  ................
  17F0: FF FF 1D 00 0A 01 0A 00 0A 13 12 0D 04 0C FF FF  ................
  1800: 1D 00 0A 02 0A 00 0A 10 12 0D 04 0C FF FF 1D 00  ................
  1810: 0A 03 0A 00 0A 12 12 0D 04 0C FF FF 1A 00 0A 00  ................
  1820: 0A 00 0A 10 12 0D 04 0C FF FF 1A 00 0A 01 0A 00  ................
  1830: 0A 15 12 0D 04 0C FF FF 1A 00 0A 02 0A 00 0A 12  ................
  1840: 12 0D 04 0C FF FF 1A 00 0A 03 0A 00 0A 13 12 0D  ................
  1850: 04 0C FF FF 1B 00 0A 00 0A 00 0A 16 12 0D 04 0C  ................
  1860: FF FF 1C 00 0A 00 0A 00 0A 10 12 0D 04 0C FF FF  ................
  1870: 1C 00 0A 01 0A 00 0A 11 12 0D 04 0C FF FF 1C 00  ................
  1880: 0A 02 0A 00 0A 12 12 0D 04 0C FF FF 1C 00 0A 03  ................
  1890: 0A 00 0A 13 12 0D 04 0C FF FF 19 00 0A 00 0A 00  ................
  18A0: 0A 14 12 0D 04 0C FF FF 16 00 0A 00 0A 00 0A 10  ................
  18B0: 12 0D 04 0C FF FF 16 00 0A 01 0A 00 0A 13 12 0D  ................
  18C0: 04 0C FF FF 16 00 0A 02 0A 00 0A 12 12 0D 04 0C  ................
  18D0: FF FF 16 00 0A 03 0A 00 0A 11 08 50 52 38 32 12  ...........PR82.
  18E0: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 41 0A 00  :.........LNKA..
  18F0: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 42 0A 00 12 0D  ........LNKB....
  1900: 04 0B FF FF 0A 02 4C 4E 4B 43 0A 00 12 0D 04 0B  ......LNKC......
  1910: FF FF 0A 03 4C 4E 4B 44 0A 00 08 41 52 38 32 12  ....LNKD...AR82.
  1920: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 10 12 0B  2...............
  1930: 04 0B FF FF 0A 01 0A 00 0A 11 12 0B 04 0B FF FF  ................
  1940: 0A 02 0A 00 0A 12 12 0B 04 0B FF FF 0A 03 0A 00  ................
  1950: 0A 13 08 50 52 38 41 12 3A 04 12 0D 04 0B FF FF  ...PR8A.:.......
  1960: 0A 00 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKA..........
  1970: 4C 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKB..........LN
  1980: 4B 43 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 44  KC..........LNKD
  1990: 0A 00 08 41 52 38 41 12 32 04 12 0B 04 0B FF FF  ...AR8A.2.......
  19A0: 0A 00 0A 00 0A 10 12 0B 04 0B FF FF 0A 01 0A 00  ................
  19B0: 0A 11 12 0B 04 0B FF FF 0A 02 0A 00 0A 12 12 0B  ................
  19C0: 04 0B FF FF 0A 03 0A 00 0A 13 08 50 52 38 43 12  ...........PR8C.
  19D0: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 41 0A 00  :.........LNKA..
  19E0: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 42 0A 00 12 0D  ........LNKB....
  19F0: 04 0B FF FF 0A 02 4C 4E 4B 43 0A 00 12 0D 04 0B  ......LNKC......
  1A00: FF FF 0A 03 4C 4E 4B 44 0A 00 08 41 52 38 43 12  ....LNKD...AR8C.
  1A10: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 10 12 0B  2...............
  1A20: 04 0B FF FF 0A 01 0A 00 0A 11 12 0B 04 0B FF FF  ................
  1A30: 0A 02 0A 00 0A 12 12 0B 04 0B FF FF 0A 03 0A 00  ................
  1A40: 0A 13 08 50 52 38 34 12 3A 04 12 0D 04 0B FF FF  ...PR84.:.......
  1A50: 0A 00 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKA..........
  1A60: 4C 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKB..........LN
  1A70: 4B 43 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 44  KC..........LNKD
  1A80: 0A 00 08 41 52 38 34 12 32 04 12 0B 04 0B FF FF  ...AR84.2.......
  1A90: 0A 00 0A 00 0A 10 12 0B 04 0B FF FF 0A 01 0A 00  ................
  1AA0: 0A 11 12 0B 04 0B FF FF 0A 02 0A 00 0A 12 12 0B  ................
  1AB0: 04 0B FF FF 0A 03 0A 00 0A 13 08 50 52 38 35 12  ...........PR85.
  1AC0: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 42 0A 00  :.........LNKB..
  1AD0: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 43 0A 00 12 0D  ........LNKC....
  1AE0: 04 0B FF FF 0A 02 4C 4E 4B 44 0A 00 12 0D 04 0B  ......LNKD......
  1AF0: FF FF 0A 03 4C 4E 4B 41 0A 00 08 41 52 38 35 12  ....LNKA...AR85.
  1B00: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 11 12 0B  2...............
  1B10: 04 0B FF FF 0A 01 0A 00 0A 12 12 0B 04 0B FF FF  ................
  1B20: 0A 02 0A 00 0A 13 12 0B 04 0B FF FF 0A 03 0A 00  ................
  1B30: 0A 10 08 50 52 38 36 12 3A 04 12 0D 04 0B FF FF  ...PR86.:.......
  1B40: 0A 00 4C 4E 4B 43 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKC..........
  1B50: 4C 4E 4B 44 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKD..........LN
  1B60: 4B 41 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 42  KA..........LNKB
  1B70: 0A 00 08 41 52 38 36 12 32 04 12 0B 04 0B FF FF  ...AR86.2.......
  1B80: 0A 00 0A 00 0A 12 12 0B 04 0B FF FF 0A 01 0A 00  ................
  1B90: 0A 13 12 0B 04 0B FF FF 0A 02 0A 00 0A 10 12 0B  ................
  1BA0: 04 0B FF FF 0A 03 0A 00 0A 11 08 50 52 38 37 12  ...........PR87.
  1BB0: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 44 0A 00  :.........LNKD..
  1BC0: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 41 0A 00 12 0D  ........LNKA....
  1BD0: 04 0B FF FF 0A 02 4C 4E 4B 42 0A 00 12 0D 04 0B  ......LNKB......
  1BE0: FF FF 0A 03 4C 4E 4B 43 0A 00 08 41 52 38 37 12  ....LNKC...AR87.
  1BF0: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 13 12 0B  2...............
  1C00: 04 0B FF FF 0A 01 0A 00 0A 10 12 0B 04 0B FF FF  ................
  1C10: 0A 02 0A 00 0A 11 12 0B 04 0B FF FF 0A 03 0A 00  ................
  1C20: 0A 12 08 50 52 38 38 12 3A 04 12 0D 04 0B FF FF  ...PR88.:.......
  1C30: 0A 00 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKA..........
  1C40: 4C 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKB..........LN
  1C50: 4B 43 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 44  KC..........LNKD
  1C60: 0A 00 08 41 52 38 38 12 32 04 12 0B 04 0B FF FF  ...AR88.2.......
  1C70: 0A 00 0A 00 0A 10 12 0B 04 0B FF FF 0A 01 0A 00  ................
  1C80: 0A 11 12 0B 04 0B FF FF 0A 02 0A 00 0A 12 12 0B  ................
  1C90: 04 0B FF FF 0A 03 0A 00 0A 13 08 50 52 38 45 12  ...........PR8E.
  1CA0: 3A 04 12 0D 04 0B FF FF 0A 00 4C 4E 4B 43 0A 00  :.........LNKC..
  1CB0: 12 0D 04 0B FF FF 0A 01 4C 4E 4B 44 0A 00 12 0D  ........LNKD....
  1CC0: 04 0B FF FF 0A 02 4C 4E 4B 41 0A 00 12 0D 04 0B  ......LNKA......
  1CD0: FF FF 0A 03 4C 4E 4B 42 0A 00 08 41 52 38 45 12  ....LNKB...AR8E.
  1CE0: 32 04 12 0B 04 0B FF FF 0A 00 0A 00 0A 12 12 0B  2...............
  1CF0: 04 0B FF FF 0A 01 0A 00 0A 13 12 0B 04 0B FF FF  ................
  1D00: 0A 02 0A 00 0A 10 12 0B 04 0B FF FF 0A 03 0A 00  ................
  1D10: 0A 11 08 50 52 38 46 12 3A 04 12 0D 04 0B FF FF  ...PR8F.:.......
  1D20: 0A 00 4C 4E 4B 44 0A 00 12 0D 04 0B FF FF 0A 01  ..LNKD..........
  1D30: 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF 0A 02 4C 4E  LNKA..........LN
  1D40: 4B 42 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E 4B 43  KB..........LNKC
  1D50: 0A 00 08 41 52 38 46 12 32 04 12 0B 04 0B FF FF  ...AR8F.2.......
  1D60: 0A 00 0A 00 0A 13 12 0B 04 0B FF FF 0A 01 0A 00  ................
  1D70: 0A 10 12 0B 04 0B FF FF 0A 02 0A 00 0A 11 12 0B  ................
  1D80: 04 0B FF FF 0A 03 0A 00 0A 12 08 50 52 38 31 12  ...........PR81.
  1D90: 4B 13 14 12 0F 04 0C FF FF 03 00 0A 00 4C 4E 4B  K............LNK
  1DA0: 44 0A 00 12 0F 04 0C FF FF 03 00 0A 01 4C 4E 4B  D............LNK
  1DB0: 43 0A 00 12 0F 04 0C FF FF 03 00 0A 02 4C 4E 4B  C............LNK
  1DC0: 46 0A 00 12 0F 04 0C FF FF 03 00 0A 03 4C 4E 4B  F............LNK
  1DD0: 47 0A 00 12 0F 04 0C FF FF 02 00 0A 00 4C 4E 4B  G............LNK
  1DE0: 43 0A 00 12 0F 04 0C FF FF 02 00 0A 01 4C 4E 4B  C............LNK
  1DF0: 44 0A 00 12 0F 04 0C FF FF 02 00 0A 02 4C 4E 4B  D............LNK
  1E00: 42 0A 00 12 0F 04 0C FF FF 02 00 0A 03 4C 4E 4B  B............LNK
  1E10: 41 0A 00 12 0D 04 0B FF FF 0A 00 4C 4E 4B 46 0A  A..........LNKF.
  1E20: 00 12 0D 04 0B FF FF 0A 01 4C 4E 4B 47 0A 00 12  .........LNKG...
  1E30: 0D 04 0B FF FF 0A 02 4C 4E 4B 42 0A 00 12 0D 04  .......LNKB.....
  1E40: 0B FF FF 0A 03 4C 4E 4B 45 0A 00 12 0F 04 0C FF  .....LNKE.......
  1E50: FF 01 00 0A 00 4C 4E 4B 47 0A 00 12 0F 04 0C FF  .....LNKG.......
  1E60: FF 01 00 0A 01 4C 4E 4B 46 0A 00 12 0F 04 0C FF  .....LNKF.......
  1E70: FF 01 00 0A 02 4C 4E 4B 45 0A 00 12 0F 04 0C FF  .....LNKE.......
  1E80: FF 01 00 0A 03 4C 4E 4B 42 0A 00 12 0F 04 0C FF  .....LNKB.......
  1E90: FF 05 00 0A 00 4C 4E 4B 43 0A 00 12 0F 04 0C FF  .....LNKC.......
  1EA0: FF 05 00 0A 01 4C 4E 4B 45 0A 00 12 0F 04 0C FF  .....LNKE.......
  1EB0: FF 05 00 0A 02 4C 4E 4B 47 0A 00 12 0F 04 0C FF  .....LNKG.......
  1EC0: FF 05 00 0A 03 4C 4E 4B 46 0A 00 08 41 52 38 31  .....LNKF...AR81
  1ED0: 12 43 11 14 12 0D 04 0C FF FF 03 00 0A 00 0A 00  .C..............
  1EE0: 0A 13 12 0D 04 0C FF FF 03 00 0A 01 0A 00 0A 12  ................
  1EF0: 12 0D 04 0C FF FF 03 00 0A 02 0A 00 0A 15 12 0D  ................
  1F00: 04 0C FF FF 03 00 0A 03 0A 00 0A 16 12 0D 04 0C  ................
  1F10: FF FF 02 00 0A 00 0A 00 0A 12 12 0D 04 0C FF FF  ................
  1F20: 02 00 0A 01 0A 00 0A 13 12 0D 04 0C FF FF 02 00  ................
  1F30: 0A 02 0A 00 0A 11 12 0D 04 0C FF FF 02 00 0A 03  ................
  1F40: 0A 00 0A 10 12 0B 04 0B FF FF 0A 00 0A 00 0A 15  ................
  1F50: 12 0B 04 0B FF FF 0A 01 0A 00 0A 16 12 0B 04 0B  ................
  1F60: FF FF 0A 02 0A 00 0A 11 12 0B 04 0B FF FF 0A 03  ................
  1F70: 0A 00 0A 14 12 0D 04 0C FF FF 01 00 0A 00 0A 00  ................
  1F80: 0A 16 12 0D 04 0C FF FF 01 00 0A 01 0A 00 0A 15  ................
  1F90: 12 0D 04 0C FF FF 01 00 0A 02 0A 00 0A 14 12 0D  ................
  1FA0: 04 0C FF FF 01 00 0A 03 0A 00 0A 11 12 0D 04 0C  ................
  1FB0: FF FF 05 00 0A 00 0A 00 0A 12 12 0D 04 0C FF FF  ................
  1FC0: 05 00 0A 01 0A 00 0A 14 12 0D 04 0C FF FF 05 00  ................
  1FD0: 0A 02 0A 00 0A 16 12 0D 04 0C FF FF 05 00 0A 03  ................
  1FE0: 0A 00 0A 15 08 50 52 30 32 12 3A 04 12 0D 04 0B  .....PR02.:.....
  1FF0: FF FF 0A 00 4C 4E 4B 41 0A 00 12 0D 04 0B FF FF  ....LNKA........
  2000: 0A 01 4C 4E 4B 42 0A 00 12 0D 04 0B FF FF 0A 02  ..LNKB..........
  2010: 4C 4E 4B 43 0A 00 12 0D 04 0B FF FF 0A 03 4C 4E  LNKC..........LN
  2020: 4B 44 0A 00 08 41 52 30 32 12 32 04 12 0B 04 0B  KD...AR02.2.....
  2030: FF FF 0A 00 0A 00 0A 10 12 0B 04 0B FF FF 0A 01  ................
  2040: 0A 00 0A 11 12 0B 04 0B FF FF 0A 02 0A 00 0A 12  ................
  2050: 12 0B 04 0B FF FF 0A 03 0A 00 0A 13 08 50 52 53  .............PRS
  2060: 41 11 09 0A 06 23 F8 DC 18 79 00 06 50 52 53 41  A....#...y..PRSA
  2070: 50 52 53 42 06 50 52 53 41 50 52 53 43 06 50 52  PRSB.PRSAPRSC.PR
  2080: 53 41 50 52 53 44 06 50 52 53 41 50 52 53 45 06  SAPRSD.PRSAPRSE.
  2090: 50 52 53 41 50 52 53 46 06 50 52 53 41 50 52 53  PRSAPRSF.PRSAPRS
  20A0: 47 06 50 52 53 41 50 52 53 48 5B 82 81 F0 01 50  G.PRSAPRSH[....P
  20B0: 43 49 30 08 5F 48 49 44 0C 41 D0 0A 08 08 5F 43  CI0._HID.A...._C
  20C0: 49 44 0C 41 D0 0A 03 08 5F 41 44 52 0A 00 14 0A  ID.A...._ADR....
  20D0: 5E 42 4E 30 30 00 A4 0A 00 14 0B 5F 42 42 4E 00  ^BN00......_BBN.
  20E0: A4 42 4E 30 30 08 5F 55 49 44 0A 00 14 16 5F 50  .BN00._UID...._P
  20F0: 52 54 00 A0 0A 50 49 43 4D A4 41 52 30 30 A4 50  RT...PICM.AR00.P
  2100: 52 30 30 5B 80 48 42 55 53 02 0A 40 0A C0 5B 81  R00[.HBUS..@..[.
  2110: 4A 06 48 42 55 53 03 45 50 45 4E 01 00 0B 45 50  J.HBUS.EPEN...EP
  2120: 42 52 14 00 20 4D 48 45 4E 01 00 0D 4D 48 42 52  BR.. MHEN...MHBR
  2130: 12 00 20 49 49 45 4E 01 00 0B 44 49 42 49 14 00  .. IIEN...DIBI..
  2140: 40 0A 44 49 45 4E 01 00 0B 44 49 42 52 14 00 20  @.DIEN...DIBR.. 
  2150: 49 50 45 4E 01 00 0B 49 50 42 52 14 00 40 17 54  IPEN...IPBR..@.T
  2160: 55 55 44 10 00 40 06 00 04 54 4C 55 44 0C 00 48  UUD..@...TLUD..H
  2170: 0B 00 03 47 54 53 45 01 00 04 5B 80 4D 43 48 54  ...GTSE...[.MCHT
  2180: 00 0C 00 00 D1 FE 0B 00 11 5B 81 2F 4D 43 48 54  .........[./MCHT
  2190: 01 00 80 A0 06 41 44 56 45 01 00 0B 41 44 56 54  .....ADVE...ADVT
  21A0: 14 00 80 6D 01 54 30 49 53 10 00 40 1F 54 31 49  ...m.T0IS..@.T1I
  21B0: 53 10 00 48 47 45 53 43 53 08 08 42 55 46 30 11  S..HGESCS..BUF0.
  21C0: 43 1F 0B EE 01 88 0D 00 02 0C 00 00 00 00 00 FE  C...............
  21D0: 00 00 00 FF 00 87 17 00 01 0C 03 00 00 00 00 00  ................
  21E0: 00 00 00 F7 0C 00 00 00 00 00 00 F8 0C 00 00 47  ...............G
  21F0: 01 F8 0C F8 0C 01 08 87 17 00 01 0C 03 00 00 00  ................
  2200: 00 00 0D 00 00 FF FF 00 00 00 00 00 00 00 F3 00  ................
  2210: 00 87 17 00 00 0C 03 00 00 00 00 00 00 0A 00 FF  ................
  2220: FF 0B 00 00 00 00 00 00 00 02 00 87 17 00 00 0C  ................
  2230: 03 00 00 00 00 00 00 0C 00 FF 3F 0C 00 00 00 00  ..........?.....
  2240: 00 00 40 00 00 87 17 00 00 0C 03 00 00 00 00 00  ..@.............
  2250: 40 0C 00 FF 7F 0C 00 00 00 00 00 00 40 00 00 87  @...........@...
  2260: 17 00 00 0C 03 00 00 00 00 00 80 0C 00 FF BF 0C  ................
  2270: 00 00 00 00 00 00 40 00 00 87 17 00 00 0C 03 00  ......@.........
  2280: 00 00 00 00 C0 0C 00 FF FF 0C 00 00 00 00 00 00  ................
  2290: 40 00 00 87 17 00 00 0C 03 00 00 00 00 00 00 0D  @...............
  22A0: 00 FF 3F 0D 00 00 00 00 00 00 40 00 00 87 17 00  ..?.......@.....
  22B0: 00 0C 03 00 00 00 00 00 40 0D 00 FF 7F 0D 00 00  ........@.......
  22C0: 00 00 00 00 40 00 00 87 17 00 00 0C 03 00 00 00  ....@...........
  22D0: 00 00 80 0D 00 FF BF 0D 00 00 00 00 00 00 40 00  ..............@.
  22E0: 00 87 17 00 00 0C 03 00 00 00 00 00 C0 0D 00 FF  ................
  22F0: FF 0D 00 00 00 00 00 00 40 00 00 87 17 00 00 0C  ........@.......
  2300: 03 00 00 00 00 00 00 0E 00 FF 3F 0E 00 00 00 00  ..........?.....
  2310: 00 00 40 00 00 87 17 00 00 0C 03 00 00 00 00 00  ..@.............
  2320: 40 0E 00 FF 7F 0E 00 00 00 00 00 00 40 00 00 87  @...........@...
  2330: 17 00 00 0C 03 00 00 00 00 00 80 0E 00 FF BF 0E  ................
  2340: 00 00 00 00 00 00 40 00 00 87 17 00 00 0C 03 00  ......@.........
  2350: 00 00 00 00 C0 0E 00 FF FF 0E 00 00 00 00 00 00  ................
  2360: 40 00 00 87 17 00 00 0C 03 00 00 00 00 00 00 0F  @...............
  2370: 00 FF FF 0F 00 00 00 00 00 00 00 01 00 87 17 00  ................
  2380: 00 0C 03 00 00 00 00 00 00 00 00 FF FF AF FE 00  ................
  2390: 00 00 00 00 00 00 00 87 17 00 00 0C 03 00 00 00  ................
  23A0: 00 00 00 D4 FE FF 4F D4 FE 00 00 00 00 00 00 00  ......O.........
  23B0: 00 79 00 14 41 51 5F 43 52 53 08 8B 42 55 46 30  .y..AQ_CRS..BUF0
  23C0: 0A 0A 50 42 4D 58 70 74 7A 5C 50 45 4C 4E 0A 14  ..PBMXptz\PELN..
  23D0: 00 0A 02 00 50 42 4D 58 8B 42 55 46 30 0A 0E 50  ....PBMX.BUF0..P
  23E0: 42 4C 4E 70 74 7A 5C 50 45 4C 4E 0A 14 00 0A 01  BLNptz\PELN.....
  23F0: 00 50 42 4C 4E A0 25 5C 2F 04 5F 53 42 5F 43 50  .PBLN.%\/._SB_CP
  2400: 42 47 49 4D 43 48 50 4D 31 4C 8A 42 55 46 30 0A  BGIMCHPM1L.BUF0.
  2410: 7C 43 30 4C 4E 70 00 43 30 4C 4E A0 29 93 5C 2F  |C0LNp.C0LN.).\/
  2420: 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 31  ._SB_CPBGIMCHPM1
  2430: 4C 0A 01 8D 42 55 46 30 0B 58 03 43 30 52 57 70  L...BUF0.X.C0RWp
  2440: 00 43 30 52 57 A0 25 5C 2F 04 5F 53 42 5F 43 50  .C0RW.%\/._SB_CP
  2450: 42 47 49 4D 43 48 50 4D 31 48 8A 42 55 46 30 0A  BGIMCHPM1H.BUF0.
  2460: 96 43 34 4C 4E 70 00 43 34 4C 4E A0 29 93 5C 2F  .C4LNp.C4LN.).\/
  2470: 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 31  ._SB_CPBGIMCHPM1
  2480: 48 0A 01 8D 42 55 46 30 0B 28 04 43 34 52 57 70  H...BUF0.(.C4RWp
  2490: 00 43 34 52 57 A0 25 5C 2F 04 5F 53 42 5F 43 50  .C4RW.%\/._SB_CP
  24A0: 42 47 49 4D 43 48 50 4D 32 4C 8A 42 55 46 30 0A  BGIMCHPM2L.BUF0.
  24B0: B0 43 38 4C 4E 70 00 43 38 4C 4E A0 29 93 5C 2F  .C8LNp.C8LN.).\/
  24C0: 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 32  ._SB_CPBGIMCHPM2
  24D0: 4C 0A 01 8D 42 55 46 30 0B F8 04 43 38 52 57 70  L...BUF0...C8RWp
  24E0: 00 43 38 52 57 A0 25 5C 2F 04 5F 53 42 5F 43 50  .C8RW.%\/._SB_CP
  24F0: 42 47 49 4D 43 48 50 4D 32 48 8A 42 55 46 30 0A  BGIMCHPM2H.BUF0.
  2500: CA 43 43 4C 4E 70 00 43 43 4C 4E A0 29 93 5C 2F  .CCLNp.CCLN.).\/
  2510: 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 32  ._SB_CPBGIMCHPM2
  2520: 48 0A 01 8D 42 55 46 30 0B C8 05 43 43 52 57 70  H...BUF0...CCRWp
  2530: 00 43 43 52 57 A0 25 5C 2F 04 5F 53 42 5F 43 50  .CCRW.%\/._SB_CP
  2540: 42 47 49 4D 43 48 50 4D 33 4C 8A 42 55 46 30 0A  BGIMCHPM3L.BUF0.
  2550: E4 44 30 4C 4E 70 00 44 30 4C 4E A0 29 93 5C 2F  .D0LNp.D0LN.).\/
  2560: 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 33  ._SB_CPBGIMCHPM3
  2570: 4C 0A 01 8D 42 55 46 30 0B 98 06 44 30 52 57 70  L...BUF0...D0RWp
  2580: 00 44 30 52 57 A0 25 5C 2F 04 5F 53 42 5F 43 50  .D0RW.%\/._SB_CP
  2590: 42 47 49 4D 43 48 50 4D 33 48 8A 42 55 46 30 0A  BGIMCHPM3H.BUF0.
  25A0: FE 44 34 4C 4E 70 00 44 34 4C 4E A0 29 93 5C 2F  .D4LNp.D4LN.).\/
  25B0: 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 33  ._SB_CPBGIMCHPM3
  25C0: 48 0A 01 8D 42 55 46 30 0B 68 07 44 34 52 57 70  H...BUF0.h.D4RWp
  25D0: 00 44 34 52 57 A0 26 5C 2F 04 5F 53 42 5F 43 50  .D4RW.&\/._SB_CP
  25E0: 42 47 49 4D 43 48 50 4D 34 4C 8A 42 55 46 30 0B  BGIMCHPM4L.BUF0.
  25F0: 18 01 44 38 4C 4E 70 00 44 38 4C 4E A0 29 93 5C  ..D8LNp.D8LN.).\
  2600: 2F 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D  /._SB_CPBGIMCHPM
  2610: 34 4C 0A 01 8D 42 55 46 30 0B 38 08 44 38 52 57  4L...BUF0.8.D8RW
  2620: 70 00 44 38 52 57 A0 26 5C 2F 04 5F 53 42 5F 43  p.D8RW.&\/._SB_C
  2630: 50 42 47 49 4D 43 48 50 4D 34 48 8A 42 55 46 30  PBGIMCHPM4H.BUF0
  2640: 0B 32 01 44 43 4C 4E 70 00 44 43 4C 4E A0 29 93  .2.DCLNp.DCLN.).
  2650: 5C 2F 04 5F 53 42 5F 43 50 42 47 49 4D 43 48 50  \/._SB_CPBGIMCHP
  2660: 4D 34 48 0A 01 8D 42 55 46 30 0B 08 09 44 43 52  M4H...BUF0...DCR
  2670: 57 70 00 44 43 52 57 A0 26 5C 2F 04 5F 53 42 5F  Wp.DCRW.&\/._SB_
  2680: 43 50 42 47 49 4D 43 48 50 4D 35 4C 8A 42 55 46  CPBGIMCHPM5L.BUF
  2690: 30 0B 4C 01 45 30 4C 4E 70 00 45 30 4C 4E A0 29  0.L.E0LNp.E0LN.)
  26A0: 93 5C 2F 04 5F 53 42 5F 43 50 42 47 49 4D 43 48  .\/._SB_CPBGIMCH
  26B0: 50 4D 35 4C 0A 01 8D 42 55 46 30 0B D8 09 45 30  PM5L...BUF0...E0
  26C0: 52 57 70 00 45 30 52 57 A0 26 5C 2F 04 5F 53 42  RWp.E0RW.&\/._SB
  26D0: 5F 43 50 42 47 49 4D 43 48 50 4D 35 48 8A 42 55  _CPBGIMCHPM5H.BU
  26E0: 46 30 0B 66 01 45 34 4C 4E 70 00 45 34 4C 4E A0  F0.f.E4LNp.E4LN.
  26F0: 29 93 5C 2F 04 5F 53 42 5F 43 50 42 47 49 4D 43  ).\/._SB_CPBGIMC
  2700: 48 50 4D 35 48 0A 01 8D 42 55 46 30 0B A8 0A 45  HPM5H...BUF0...E
  2710: 34 52 57 70 00 45 34 52 57 A0 26 5C 2F 04 5F 53  4RWp.E4RW.&\/._S
  2720: 42 5F 43 50 42 47 49 4D 43 48 50 4D 36 4C 8A 42  B_CPBGIMCHPM6L.B
  2730: 55 46 30 0B 80 01 45 38 4C 4E 70 00 45 38 4C 4E  UF0...E8LNp.E8LN
  2740: A0 29 93 5C 2F 04 5F 53 42 5F 43 50 42 47 49 4D  .).\/._SB_CPBGIM
  2750: 43 48 50 4D 36 4C 0A 01 8D 42 55 46 30 0B 78 0B  CHPM6L...BUF0.x.
  2760: 45 38 52 57 70 00 45 38 52 57 A0 26 5C 2F 04 5F  E8RWp.E8RW.&\/._
  2770: 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 36 48 8A  SB_CPBGIMCHPM6H.
  2780: 42 55 46 30 0B 9A 01 45 43 4C 4E 70 00 45 43 4C  BUF0...ECLNp.ECL
  2790: 4E A0 29 93 5C 2F 04 5F 53 42 5F 43 50 42 47 49  N.).\/._SB_CPBGI
  27A0: 4D 43 48 50 4D 36 48 0A 01 8D 42 55 46 30 0B 48  MCHPM6H...BUF0.H
  27B0: 0C 45 43 52 57 70 00 45 43 52 57 A0 26 5C 2F 04  .ECRWp.ECRW.&\/.
  27C0: 5F 53 42 5F 43 50 42 47 49 4D 43 48 50 4D 30 48  _SB_CPBGIMCHPM0H
  27D0: 8A 42 55 46 30 0B B4 01 46 30 4C 4E 70 00 46 30  .BUF0...F0LNp.F0
  27E0: 4C 4E A0 29 93 5C 2F 04 5F 53 42 5F 43 50 42 47  LN.).\/._SB_CPBG
  27F0: 49 4D 43 48 50 4D 30 48 0A 01 8D 42 55 46 30 0B  IMCHPM0H...BUF0.
  2800: 18 0D 46 30 52 57 70 00 46 30 52 57 8A 42 55 46  ..F0RWp.F0RW.BUF
  2810: 30 0B C2 01 4D 31 4D 4E 8A 42 55 46 30 0B C6 01  0...M1MN.BUF0...
  2820: 4D 31 4D 58 8A 42 55 46 30 0B CE 01 4D 31 4C 4E  M1MX.BUF0...M1LN
  2830: A0 41 07 7D 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00  .A.}.{PNHM......
  2840: 0C E0 06 01 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00  ......{PNHM.....
  2850: 00 0C A0 06 01 00 00 A0 2A 92 95 50 4E 48 4D 0C  ........*..PNHM.
  2860: E1 06 01 00 70 5C 2F 04 5F 53 42 5F 50 43 49 30  ....p\/._SB_PCI0
  2870: 49 4F 31 30 54 4F 4C 4D 60 79 75 60 0A 1A 4D 31  IO10TOLM`yu`..M1
  2880: 4D 4E A1 1F 70 5C 2F 04 5F 53 42 5F 50 43 49 30  MN..p\/._SB_PCI0
  2890: 49 49 4F 30 54 4F 4C 4D 60 79 75 60 0A 1A 4D 31  IIO0TOLM`yu`..M1
  28A0: 4D 4E A1 0C 79 54 4C 55 44 0A 14 4D 31 4D 4E 72  MN..yTLUD..M1MNr
  28B0: 74 4D 31 4D 58 4D 31 4D 4E 00 0A 01 4D 31 4C 4E  tM1MXM1MN...M1LN
  28C0: A4 42 55 46 30 08 47 55 49 44 11 13 0A 10 5B 4D  .BUF0.GUID....[M
  28D0: DB 33 F7 1F 1C 40 96 57 74 41 C0 3D D7 66 08 53  .3...@.WtA.=.f.S
  28E0: 55 50 50 0A 00 08 43 54 52 4C 0A 00 14 45 0B 5F  UPP...CTRL...E._
  28F0: 4F 53 43 0C 70 6B 60 8A 60 0A 00 43 44 57 31 8A  OSC.pk`.`..CDW1.
  2900: 60 0A 04 43 44 57 32 8A 60 0A 08 43 44 57 33 A0  `..CDW2.`..CDW3.
  2910: 43 08 90 93 68 47 55 49 44 4E 45 58 50 70 43 44  C...hGUIDNEXPpCD
  2920: 57 32 53 55 50 50 70 43 44 57 33 43 54 52 4C A0  W2SUPPpCDW3CTRL.
  2930: 27 80 7B 43 44 57 31 0A 01 00 00 A0 0D 7B 43 54  '.{CDW1......{CT
  2940: 52 4C 0A 02 00 4E 48 50 47 A0 0D 7B 43 54 52 4C  RL...NHPG..{CTRL
  2950: 0A 04 00 4E 50 4D 45 A0 10 92 93 69 01 7D 43 44  ...NPME....i.}CD
  2960: 57 31 0A 08 43 44 57 31 A0 16 92 93 43 44 57 33  W1..CDW1....CDW3
  2970: 43 54 52 4C 7D 43 44 57 31 0A 10 43 44 57 31 70  CTRL}CDW1..CDW1p
  2980: 43 54 52 4C 43 44 57 33 70 43 54 52 4C 4F 53 43  CTRLCDW3pCTRLOSC
  2990: 43 A4 60 A1 0E 7D 43 44 57 31 0A 04 43 44 57 31  C.`..}CDW1..CDW1
  29A0: A4 60 10 48 4F 5C 2E 5F 53 42 5F 50 43 49 30 14  .`.HO\._SB_PCI0.
  29B0: 45 04 41 52 30 30 00 A0 30 7D 93 7B 50 4E 48 4D  E.AR00..0}.{PNHM
  29C0: 0C F0 FF 0F 00 00 0C E0 06 01 00 93 7B 50 4E 48  ............{PNH
  29D0: 4D 0C F0 FF 0F 00 00 0C A0 06 01 00 00 A4 5C 2E  M.............\.
  29E0: 5F 53 42 5F 41 52 38 30 A1 0C A4 5C 2E 5F 53 42  _SB_AR80...\._SB
  29F0: 5F 41 52 30 30 14 45 04 50 52 30 30 00 A0 30 7D  _AR00.E.PR00..0}
  2A00: 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01  .{PNHM..........
  2A10: 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06  ..{PNHM.........
  2A20: 01 00 00 A4 5C 2E 5F 53 42 5F 50 52 38 30 A1 0C  ....\._SB_PR80..
  2A30: A4 5C 2E 5F 53 42 5F 50 52 30 30 14 45 04 41 52  .\._SB_PR00.E.AR
  2A40: 30 31 00 A0 30 7D 93 7B 50 4E 48 4D 0C F0 FF 0F  01..0}.{PNHM....
  2A50: 00 00 0C E0 06 01 00 93 7B 50 4E 48 4D 0C F0 FF  ........{PNHM...
  2A60: 0F 00 00 0C A0 06 01 00 00 A4 5C 2E 5F 53 42 5F  ..........\._SB_
  2A70: 41 52 38 31 A1 0C A4 5C 2E 5F 53 42 5F 41 52 30  AR81...\._SB_AR0
  2A80: 31 14 45 04 50 52 30 31 00 A0 30 7D 93 7B 50 4E  1.E.PR01..0}.{PN
  2A90: 48 4D 0C F0 FF 0F 00 00 0C E0 06 01 00 93 7B 50  HM............{P
  2AA0: 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06 01 00 00 A4  NHM.............
  2AB0: 5C 2E 5F 53 42 5F 50 52 38 31 A1 0C A4 5C 2E 5F  \._SB_PR81...\._
  2AC0: 53 42 5F 50 52 30 31 14 45 04 41 52 30 32 00 A0  SB_PR01.E.AR02..
  2AD0: 30 7D 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0  0}.{PNHM........
  2AE0: 06 01 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C  ....{PNHM.......
  2AF0: A0 06 01 00 00 A4 5C 2E 5F 53 42 5F 41 52 38 32  ......\._SB_AR82
  2B00: A1 0C A4 5C 2E 5F 53 42 5F 41 52 30 32 14 45 04  ...\._SB_AR02.E.
  2B10: 50 52 30 32 00 A0 30 7D 93 7B 50 4E 48 4D 0C F0  PR02..0}.{PNHM..
  2B20: FF 0F 00 00 0C E0 06 01 00 93 7B 50 4E 48 4D 0C  ..........{PNHM.
  2B30: F0 FF 0F 00 00 0C A0 06 01 00 00 A4 5C 2E 5F 53  ............\._S
  2B40: 42 5F 50 52 38 32 A1 0C A4 5C 2E 5F 53 42 5F 50  B_PR82...\._SB_P
  2B50: 52 30 32 14 45 04 41 52 30 34 00 A0 30 7D 93 7B  R02.E.AR04..0}.{
  2B60: 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01 00 93  PNHM............
  2B70: 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06 01 00  {PNHM...........
  2B80: 00 A4 5C 2E 5F 53 42 5F 41 52 38 34 A1 0C A4 5C  ..\._SB_AR84...\
  2B90: 2E 5F 53 42 5F 41 52 30 34 14 45 04 50 52 30 34  ._SB_AR04.E.PR04
  2BA0: 00 A0 30 7D 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00  ..0}.{PNHM......
  2BB0: 0C E0 06 01 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00  ......{PNHM.....
  2BC0: 00 0C A0 06 01 00 00 A4 5C 2E 5F 53 42 5F 50 52  ........\._SB_PR
  2BD0: 38 34 A1 0C A4 5C 2E 5F 53 42 5F 50 52 30 34 14  84...\._SB_PR04.
  2BE0: 45 04 41 52 30 35 00 A0 30 7D 93 7B 50 4E 48 4D  E.AR05..0}.{PNHM
  2BF0: 0C F0 FF 0F 00 00 0C E0 06 01 00 93 7B 50 4E 48  ............{PNH
  2C00: 4D 0C F0 FF 0F 00 00 0C A0 06 01 00 00 A4 5C 2E  M.............\.
  2C10: 5F 53 42 5F 41 52 38 35 A1 0C A4 5C 2E 5F 53 42  _SB_AR85...\._SB
  2C20: 5F 41 52 30 35 14 45 04 50 52 30 35 00 A0 30 7D  _AR05.E.PR05..0}
  2C30: 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01  .{PNHM..........
  2C40: 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06  ..{PNHM.........
  2C50: 01 00 00 A4 5C 2E 5F 53 42 5F 50 52 38 35 A1 0C  ....\._SB_PR85..
  2C60: A4 5C 2E 5F 53 42 5F 50 52 30 35 14 45 04 41 52  .\._SB_PR05.E.AR
  2C70: 30 36 00 A0 30 7D 93 7B 50 4E 48 4D 0C F0 FF 0F  06..0}.{PNHM....
  2C80: 00 00 0C E0 06 01 00 93 7B 50 4E 48 4D 0C F0 FF  ........{PNHM...
  2C90: 0F 00 00 0C A0 06 01 00 00 A4 5C 2E 5F 53 42 5F  ..........\._SB_
  2CA0: 41 52 38 36 A1 0C A4 5C 2E 5F 53 42 5F 41 52 30  AR86...\._SB_AR0
  2CB0: 36 14 45 04 50 52 30 36 00 A0 30 7D 93 7B 50 4E  6.E.PR06..0}.{PN
  2CC0: 48 4D 0C F0 FF 0F 00 00 0C E0 06 01 00 93 7B 50  HM............{P
  2CD0: 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06 01 00 00 A4  NHM.............
  2CE0: 5C 2E 5F 53 42 5F 50 52 38 36 A1 0C A4 5C 2E 5F  \._SB_PR86...\._
  2CF0: 53 42 5F 50 52 30 36 14 45 04 41 52 30 37 00 A0  SB_PR06.E.AR07..
  2D00: 30 7D 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0  0}.{PNHM........
  2D10: 06 01 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C  ....{PNHM.......
  2D20: A0 06 01 00 00 A4 5C 2E 5F 53 42 5F 41 52 38 37  ......\._SB_AR87
  2D30: A1 0C A4 5C 2E 5F 53 42 5F 41 52 30 37 14 45 04  ...\._SB_AR07.E.
  2D40: 50 52 30 37 00 A0 30 7D 93 7B 50 4E 48 4D 0C F0  PR07..0}.{PNHM..
  2D50: FF 0F 00 00 0C E0 06 01 00 93 7B 50 4E 48 4D 0C  ..........{PNHM.
  2D60: F0 FF 0F 00 00 0C A0 06 01 00 00 A4 5C 2E 5F 53  ............\._S
  2D70: 42 5F 50 52 38 37 A1 0C A4 5C 2E 5F 53 42 5F 50  B_PR87...\._SB_P
  2D80: 52 30 37 14 45 04 41 52 30 38 00 A0 30 7D 93 7B  R07.E.AR08..0}.{
  2D90: 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01 00 93  PNHM............
  2DA0: 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06 01 00  {PNHM...........
  2DB0: 00 A4 5C 2E 5F 53 42 5F 41 52 38 38 A1 0C A4 5C  ..\._SB_AR88...\
  2DC0: 2E 5F 53 42 5F 41 52 30 38 14 45 04 50 52 30 38  ._SB_AR08.E.PR08
  2DD0: 00 A0 30 7D 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00  ..0}.{PNHM......
  2DE0: 0C E0 06 01 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00  ......{PNHM.....
  2DF0: 00 0C A0 06 01 00 00 A4 5C 2E 5F 53 42 5F 50 52  ........\._SB_PR
  2E00: 38 38 A1 0C A4 5C 2E 5F 53 42 5F 50 52 30 38 14  88...\._SB_PR08.
  2E10: 45 04 41 52 30 41 00 A0 30 7D 93 7B 50 4E 48 4D  E.AR0A..0}.{PNHM
  2E20: 0C F0 FF 0F 00 00 0C E0 06 01 00 93 7B 50 4E 48  ............{PNH
  2E30: 4D 0C F0 FF 0F 00 00 0C A0 06 01 00 00 A4 5C 2E  M.............\.
  2E40: 5F 53 42 5F 41 52 38 41 A1 0C A4 5C 2E 5F 53 42  _SB_AR8A...\._SB
  2E50: 5F 41 52 30 41 14 45 04 50 52 30 41 00 A0 30 7D  _AR0A.E.PR0A..0}
  2E60: 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01  .{PNHM..........
  2E70: 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06  ..{PNHM.........
  2E80: 01 00 00 A4 5C 2E 5F 53 42 5F 50 52 38 41 A1 0C  ....\._SB_PR8A..
  2E90: A4 5C 2E 5F 53 42 5F 50 52 30 41 5B 82 45 04 41  .\._SB_PR0A[.E.A
  2EA0: 47 50 5F 08 5F 41 44 52 0C 00 00 01 00 14 0F 5F  GP_._ADR......._
  2EB0: 50 52 57 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F  PRW..GPRW......_
  2EC0: 50 52 54 00 A0 0A 50 49 43 4D A4 41 52 30 32 A4  PRT...PICM.AR02.
  2ED0: 50 52 30 32 5B 82 0C 56 49 44 5F 08 5F 41 44 52  PR02[..VID_._ADR
  2EE0: 0A 00 5B 82 36 50 30 50 31 08 5F 41 44 52 0C 00  ..[.6P0P1._ADR..
  2EF0: 00 1E 00 14 0F 5F 50 52 57 00 A4 47 50 52 57 0A  ....._PRW..GPRW.
  2F00: 0B 0A 04 14 16 5F 50 52 54 00 A0 0A 50 49 43 4D  ....._PRT...PICM
  2F10: A4 41 52 30 31 A4 50 52 30 31 5B 82 41 93 4C 50  .AR01.PR01[.A.LP
  2F20: 43 42 08 5F 41 44 52 0C 00 00 1F 00 10 4E 5B 5C  CB._ADR......N[\
  2F30: 5F 53 42 5F 5B 80 5C 2F 04 5F 53 42 5F 50 43 49  _SB_[.\/._SB_PCI
  2F40: 30 4C 50 43 42 4C 50 43 31 02 0A 40 0A C0 5B 81  0LPCBLPC1..@..[.
  2F50: 43 04 5C 2F 04 5F 53 42 5F 50 43 49 30 4C 50 43  C.\/._SB_PCI0LPC
  2F60: 42 4C 50 43 31 00 00 40 10 50 41 52 43 08 50 42  BLPC1..@.PARC.PB
  2F70: 52 43 08 50 43 52 43 08 50 44 52 43 08 00 20 50  RC.PCRC.PDRC.. P
  2F80: 45 52 43 08 50 46 52 43 08 50 47 52 43 08 50 48  ERC.PFRC.PGRC.PH
  2F90: 52 43 08 5B 82 49 0A 4C 4E 4B 41 08 5F 48 49 44  RC.[.I.LNKA._HID
  2FA0: 0C 41 D0 0C 0F 08 5F 55 49 44 0A 01 14 11 5F 44  .A...._UID...._D
  2FB0: 49 53 08 7D 50 41 52 43 0A 80 50 41 52 43 08 5F  IS.}PARC..PARC._
  2FC0: 50 52 53 11 09 0A 06 23 FA D4 18 79 00 14 3A 5F  PRS....#...y..:_
  2FD0: 43 52 53 08 08 52 54 4C 41 11 09 0A 06 23 00 00  CRS..RTLA....#..
  2FE0: 18 79 00 8B 52 54 4C 41 0A 01 49 52 51 30 70 00  .y..RTLA..IRQ0p.
  2FF0: 49 52 51 30 79 0A 01 7B 50 41 52 43 0A 0F 00 49  IRQ0y..{PARC...I
  3000: 52 51 30 A4 52 54 4C 41 14 1C 5F 53 52 53 09 8B  RQ0.RTLA.._SRS..
  3010: 68 0A 01 49 52 51 30 82 49 52 51 30 60 76 60 70  h..IRQ0.IRQ0`v`p
  3020: 60 50 41 52 43 14 18 5F 53 54 41 08 A0 0C 7B 50  `PARC.._STA...{P
  3030: 41 52 43 0A 80 00 A4 0A 09 A1 04 A4 0A 0B 5B 82  ARC...........[.
  3040: 49 0A 4C 4E 4B 42 08 5F 48 49 44 0C 41 D0 0C 0F  I.LNKB._HID.A...
  3050: 08 5F 55 49 44 0A 02 14 11 5F 44 49 53 08 7D 50  ._UID...._DIS.}P
  3060: 42 52 43 0A 80 50 42 52 43 08 5F 50 52 53 11 09  BRC..PBRC._PRS..
  3070: 0A 06 23 FA D8 18 79 00 14 3A 5F 43 52 53 08 08  ..#...y..:_CRS..
  3080: 52 54 4C 42 11 09 0A 06 23 00 00 18 79 00 8B 52  RTLB....#...y..R
  3090: 54 4C 42 0A 01 49 52 51 30 70 00 49 52 51 30 79  TLB..IRQ0p.IRQ0y
  30A0: 0A 01 7B 50 42 52 43 0A 0F 00 49 52 51 30 A4 52  ..{PBRC...IRQ0.R
  30B0: 54 4C 42 14 1C 5F 53 52 53 09 8B 68 0A 01 49 52  TLB.._SRS..h..IR
  30C0: 51 30 82 49 52 51 30 60 76 60 70 60 50 42 52 43  Q0.IRQ0`v`p`PBRC
  30D0: 14 18 5F 53 54 41 08 A0 0C 7B 50 42 52 43 0A 80  .._STA...{PBRC..
  30E0: 00 A4 0A 09 A1 04 A4 0A 0B 5B 82 49 0A 4C 4E 4B  .........[.I.LNK
  30F0: 43 08 5F 48 49 44 0C 41 D0 0C 0F 08 5F 55 49 44  C._HID.A...._UID
  3100: 0A 03 14 11 5F 44 49 53 08 7D 50 43 52 43 0A 80  ...._DIS.}PCRC..
  3110: 50 43 52 43 08 5F 50 52 53 11 09 0A 06 23 FA D4  PCRC._PRS....#..
  3120: 18 79 00 14 3A 5F 43 52 53 08 08 52 54 4C 43 11  .y..:_CRS..RTLC.
  3130: 09 0A 06 23 00 00 18 79 00 8B 52 54 4C 43 0A 01  ...#...y..RTLC..
  3140: 49 52 51 30 70 00 49 52 51 30 79 0A 01 7B 50 43  IRQ0p.IRQ0y..{PC
  3150: 52 43 0A 0F 00 49 52 51 30 A4 52 54 4C 43 14 1C  RC...IRQ0.RTLC..
  3160: 5F 53 52 53 09 8B 68 0A 01 49 52 51 30 82 49 52  _SRS..h..IRQ0.IR
  3170: 51 30 60 76 60 70 60 50 43 52 43 14 18 5F 53 54  Q0`v`p`PCRC.._ST
  3180: 41 08 A0 0C 7B 50 43 52 43 0A 80 00 A4 0A 09 A1  A...{PCRC.......
  3190: 04 A4 0A 0B 5B 82 49 0A 4C 4E 4B 44 08 5F 48 49  ....[.I.LNKD._HI
  31A0: 44 0C 41 D0 0C 0F 08 5F 55 49 44 0A 04 14 11 5F  D.A...._UID...._
  31B0: 44 49 53 08 7D 50 44 52 43 0A 80 50 44 52 43 08  DIS.}PDRC..PDRC.
  31C0: 5F 50 52 53 11 09 0A 06 23 FA D8 18 79 00 14 3A  _PRS....#...y..:
  31D0: 5F 43 52 53 08 08 52 54 4C 44 11 09 0A 06 23 00  _CRS..RTLD....#.
  31E0: 00 18 79 00 8B 52 54 4C 44 0A 01 49 52 51 30 70  ..y..RTLD..IRQ0p
  31F0: 00 49 52 51 30 79 0A 01 7B 50 44 52 43 0A 0F 00  .IRQ0y..{PDRC...
  3200: 49 52 51 30 A4 52 54 4C 44 14 1C 5F 53 52 53 09  IRQ0.RTLD.._SRS.
  3210: 8B 68 0A 01 49 52 51 30 82 49 52 51 30 60 76 60  .h..IRQ0.IRQ0`v`
  3220: 70 60 50 44 52 43 14 18 5F 53 54 41 08 A0 0C 7B  p`PDRC.._STA...{
  3230: 50 44 52 43 0A 80 00 A4 0A 09 A1 04 A4 0A 0B 5B  PDRC...........[
  3240: 82 49 0A 4C 4E 4B 45 08 5F 48 49 44 0C 41 D0 0C  .I.LNKE._HID.A..
  3250: 0F 08 5F 55 49 44 0A 05 14 11 5F 44 49 53 08 7D  .._UID...._DIS.}
  3260: 50 45 52 43 0A 80 50 45 52 43 08 5F 50 52 53 11  PERC..PERC._PRS.
  3270: 09 0A 06 23 FA D4 18 79 00 14 3A 5F 43 52 53 08  ...#...y..:_CRS.
  3280: 08 52 54 4C 45 11 09 0A 06 23 00 00 18 79 00 8B  .RTLE....#...y..
  3290: 52 54 4C 45 0A 01 49 52 51 30 70 00 49 52 51 30  RTLE..IRQ0p.IRQ0
  32A0: 79 0A 01 7B 50 45 52 43 0A 0F 00 49 52 51 30 A4  y..{PERC...IRQ0.
  32B0: 52 54 4C 45 14 1C 5F 53 52 53 09 8B 68 0A 01 49  RTLE.._SRS..h..I
  32C0: 52 51 30 82 49 52 51 30 60 76 60 70 60 50 45 52  RQ0.IRQ0`v`p`PER
  32D0: 43 14 18 5F 53 54 41 08 A0 0C 7B 50 45 52 43 0A  C.._STA...{PERC.
  32E0: 80 00 A4 0A 09 A1 04 A4 0A 0B 5B 82 49 0A 4C 4E  ..........[.I.LN
  32F0: 4B 46 08 5F 48 49 44 0C 41 D0 0C 0F 08 5F 55 49  KF._HID.A...._UI
  3300: 44 0A 06 14 11 5F 44 49 53 08 7D 50 46 52 43 0A  D...._DIS.}PFRC.
  3310: 80 50 46 52 43 08 5F 50 52 53 11 09 0A 06 23 FA  .PFRC._PRS....#.
  3320: D8 18 79 00 14 3A 5F 43 52 53 08 08 52 54 4C 46  ..y..:_CRS..RTLF
  3330: 11 09 0A 06 23 00 00 18 79 00 8B 52 54 4C 46 0A  ....#...y..RTLF.
  3340: 01 49 52 51 30 70 00 49 52 51 30 79 0A 01 7B 50  .IRQ0p.IRQ0y..{P
  3350: 46 52 43 0A 0F 00 49 52 51 30 A4 52 54 4C 46 14  FRC...IRQ0.RTLF.
  3360: 1C 5F 53 52 53 09 8B 68 0A 01 49 52 51 30 82 49  ._SRS..h..IRQ0.I
  3370: 52 51 30 60 76 60 70 60 50 46 52 43 14 18 5F 53  RQ0`v`p`PFRC.._S
  3380: 54 41 08 A0 0C 7B 50 46 52 43 0A 80 00 A4 0A 09  TA...{PFRC......
  3390: A1 04 A4 0A 0B 5B 82 49 0A 4C 4E 4B 47 08 5F 48  .....[.I.LNKG._H
  33A0: 49 44 0C 41 D0 0C 0F 08 5F 55 49 44 0A 07 14 11  ID.A...._UID....
  33B0: 5F 44 49 53 08 7D 50 47 52 43 0A 80 50 47 52 43  _DIS.}PGRC..PGRC
  33C0: 08 5F 50 52 53 11 09 0A 06 23 FA D4 18 79 00 14  ._PRS....#...y..
  33D0: 3A 5F 43 52 53 08 08 52 54 4C 47 11 09 0A 06 23  :_CRS..RTLG....#
  33E0: 00 00 18 79 00 8B 52 54 4C 47 0A 01 49 52 51 30  ...y..RTLG..IRQ0
  33F0: 70 00 49 52 51 30 79 0A 01 7B 50 47 52 43 0A 0F  p.IRQ0y..{PGRC..
  3400: 00 49 52 51 30 A4 52 54 4C 47 14 1C 5F 53 52 53  .IRQ0.RTLG.._SRS
  3410: 09 8B 68 0A 01 49 52 51 30 82 49 52 51 30 60 76  ..h..IRQ0.IRQ0`v
  3420: 60 70 60 50 47 52 43 14 18 5F 53 54 41 08 A0 0C  `p`PGRC.._STA...
  3430: 7B 50 47 52 43 0A 80 00 A4 0A 09 A1 04 A4 0A 0B  {PGRC...........
  3440: 5B 82 49 0A 4C 4E 4B 48 08 5F 48 49 44 0C 41 D0  [.I.LNKH._HID.A.
  3450: 0C 0F 08 5F 55 49 44 0A 08 14 11 5F 44 49 53 08  ..._UID...._DIS.
  3460: 7D 50 48 52 43 0A 80 50 48 52 43 08 5F 50 52 53  }PHRC..PHRC._PRS
  3470: 11 09 0A 06 23 FA D8 18 79 00 14 3A 5F 43 52 53  ....#...y..:_CRS
  3480: 08 08 52 54 4C 48 11 09 0A 06 23 00 00 18 79 00  ..RTLH....#...y.
  3490: 8B 52 54 4C 48 0A 01 49 52 51 30 70 00 49 52 51  .RTLH..IRQ0p.IRQ
  34A0: 30 79 0A 01 7B 50 48 52 43 0A 0F 00 49 52 51 30  0y..{PHRC...IRQ0
  34B0: A4 52 54 4C 48 14 1C 5F 53 52 53 09 8B 68 0A 01  .RTLH.._SRS..h..
  34C0: 49 52 51 30 82 49 52 51 30 60 76 60 70 60 50 48  IRQ0.IRQ0`v`p`PH
  34D0: 52 43 14 18 5F 53 54 41 08 A0 0C 7B 50 48 52 43  RC.._STA...{PHRC
  34E0: 0A 80 00 A4 0A 09 A1 04 A4 0A 0B 5B 80 4C 50 43  ...........[.LPC
  34F0: 30 02 0A 40 0A C0 5B 81 22 4C 50 43 30 00 00 40  0..@..[."LPC0..@
  3500: 20 49 4F 44 30 08 49 4F 44 31 08 00 40 37 52 41   IOD0.IOD1..@7RA
  3510: 45 4E 01 00 0D 52 43 42 41 12 5B 82 3D 44 4D 41  EN...RCBA.[.=DMA
  3520: 43 08 5F 48 49 44 0C 41 D0 02 00 08 5F 43 52 53  C._HID.A...._CRS
  3530: 11 28 0A 25 47 01 00 00 00 00 01 20 47 01 81 00  .(.%G...... G...
  3540: 81 00 01 11 47 01 93 00 93 00 01 0D 47 01 C0 00  ....G.......G...
  3550: C0 00 01 20 2A 10 01 79 00 5B 82 26 46 57 48 44  ... *..y.[.&FWHD
  3560: 08 5F 48 49 44 0C 25 D4 08 00 08 5F 43 52 53 11  ._HID.%...._CRS.
  3570: 11 0A 0E 86 09 00 00 00 00 00 FF 00 00 00 01 79  ...............y
  3580: 00 5B 82 4F 0A 48 50 45 54 08 5F 48 49 44 0C 41  .[.O.HPET._HID.A
  3590: D0 01 03 08 5F 55 49 44 0A 00 08 42 55 46 30 11  ...._UID...BUF0.
  35A0: 11 0A 0E 86 09 00 01 00 00 D0 FE 00 04 00 00 79  ...............y
  35B0: 00 14 28 5F 53 54 41 00 A0 13 92 95 4F 53 59 53  ..(_STA.....OSYS
  35C0: 0B D1 07 A0 08 48 50 41 45 A4 0A 0F A1 0A A0 08  .....HPAE.......
  35D0: 48 50 41 45 A4 0A 0B A4 0A 00 14 47 05 5F 43 52  HPAE.......G._CR
  35E0: 53 08 A0 4A 04 48 50 41 45 8A 42 55 46 30 0A 04  S..J.HPAE.BUF0..
  35F0: 48 50 54 30 A0 12 93 48 50 41 53 0A 01 70 0C 00  HPT0...HPAS..p..
  3600: 10 D0 FE 48 50 54 30 A0 12 93 48 50 41 53 0A 02  ...HPT0...HPAS..
  3610: 70 0C 00 20 D0 FE 48 50 54 30 A0 12 93 48 50 41  p.. ..HPT0...HPA
  3620: 53 0A 03 70 0C 00 30 D0 FE 48 50 54 30 A4 42 55  S..p..0..HPT0.BU
  3630: 46 30 5B 82 45 0A 49 50 49 43 08 5F 48 49 44 0B  F0[.E.IPIC._HID.
  3640: 41 D0 08 5F 43 52 53 11 41 09 0A 8D 47 01 20 00  A.._CRS.A...G. .
  3650: 20 00 01 02 47 01 24 00 24 00 01 02 47 01 28 00   ...G.$.$...G.(.
  3660: 28 00 01 02 47 01 2C 00 2C 00 01 02 47 01 30 00  (...G.,.,...G.0.
  3670: 30 00 01 02 47 01 34 00 34 00 01 02 47 01 38 00  0...G.4.4...G.8.
  3680: 38 00 01 02 47 01 3C 00 3C 00 01 02 47 01 A0 00  8...G.<.<...G...
  3690: A0 00 01 02 47 01 A4 00 A4 00 01 02 47 01 A8 00  ....G.......G...
  36A0: A8 00 01 02 47 01 AC 00 AC 00 01 02 47 01 B0 00  ....G.......G...
  36B0: B0 00 01 02 47 01 B4 00 B4 00 01 02 47 01 B8 00  ....G.......G...
  36C0: B8 00 01 02 47 01 BC 00 BC 00 01 02 47 01 D0 04  ....G.......G...
  36D0: D0 04 01 02 22 04 00 79 00 5B 82 25 4D 41 54 48  ...."..y.[.%MATH
  36E0: 08 5F 48 49 44 0C 41 D0 0C 04 08 5F 43 52 53 11  ._HID.A...._CRS.
  36F0: 10 0A 0D 47 01 F0 00 F0 00 01 01 22 00 20 79 00  ...G.......". y.
  3700: 5B 82 4B 0A 4C 44 52 43 08 5F 48 49 44 0C 41 D0  [.K.LDRC._HID.A.
  3710: 0C 02 08 5F 55 49 44 0A 02 08 5F 43 52 53 11 4E  ..._UID..._CRS.N
  3720: 08 0A 8A 47 01 2E 00 2E 00 01 02 47 01 4E 00 4E  ...G.......G.N.N
  3730: 00 01 02 47 01 61 00 61 00 01 01 47 01 63 00 63  ...G.a.a...G.c.c
  3740: 00 01 01 47 01 65 00 65 00 01 01 47 01 67 00 67  ...G.e.e...G.g.g
  3750: 00 01 01 47 01 70 00 70 00 01 01 47 01 80 00 80  ...G.p.p...G....
  3760: 00 01 01 47 01 92 00 92 00 01 01 47 01 B2 00 B2  ...G.......G....
  3770: 00 01 02 47 01 80 06 80 06 01 20 47 01 00 10 00  ...G...... G....
  3780: 10 01 04 47 01 04 10 04 10 01 10 47 01 FF FF FF  ...G.......G....
  3790: FF 01 01 47 01 00 04 00 04 01 80 47 01 00 05 00  ...G.......G....
  37A0: 05 01 80 47 01 4E 16 4E 16 01 02 79 00 5B 82 25  ...G.N.N...y.[.%
  37B0: 52 54 43 5F 08 5F 48 49 44 0C 41 D0 0B 00 08 5F  RTC_._HID.A...._
  37C0: 43 52 53 11 10 0A 0D 47 01 70 00 70 00 01 08 22  CRS....G.p.p..."
  37D0: 00 01 79 00 5B 82 2D 54 49 4D 52 08 5F 48 49 44  ..y.[.-TIMR._HID
  37E0: 0C 41 D0 01 00 08 5F 43 52 53 11 18 0A 15 47 01  .A...._CRS....G.
  37F0: 40 00 40 00 01 04 47 01 50 00 50 00 10 04 22 01  @.@...G.P.P...".
  3800: 00 79 00 5B 82 48 04 50 53 32 4B 08 5F 48 49 44  .y.[.H.PS2K._HID
  3810: 0C 41 D0 03 03 08 5F 43 52 53 11 19 0A 16 47 01  .A...._CRS....G.
  3820: 60 00 60 00 01 01 47 01 64 00 64 00 01 01 23 02  `.`...G.d.d...#.
  3830: 00 01 79 00 08 5F 50 52 53 11 13 0A 10 31 00 4B  ..y.._PRS....1.K
  3840: 60 00 01 4B 64 00 01 22 02 00 38 79 00 5B 82 4F  `..Kd.."..8y.[.O
  3850: 04 48 44 45 46 08 5F 41 44 52 0C 00 00 1B 00 5B  .HDEF._ADR.....[
  3860: 80 48 44 41 52 02 0A 4C 0A 10 5B 81 22 48 44 41  .HDAR..L..[."HDA
  3870: 52 02 44 43 4B 41 01 00 07 44 43 4B 4D 01 00 06  R.DCKA...DCKM...
  3880: 44 43 4B 53 01 00 30 00 0F 50 4D 45 53 01 14 0F  DCKS..0..PMES...
  3890: 5F 50 52 57 00 A4 47 50 52 57 0A 0D 0A 04 5B 82  _PRW..GPRW....[.
  38A0: 4F 0A 52 50 30 31 08 5F 41 44 52 0C 00 00 1C 00  O.RP01._ADR.....
  38B0: 5B 80 50 58 43 53 02 0A 40 0A C0 5B 81 41 05 50  [.PXCS..@..[.A.P
  38C0: 58 43 53 40 00 40 09 00 0D 4C 41 53 58 01 00 32  XCS@.@...LASX..2
  38D0: 41 42 50 58 01 00 02 50 44 43 58 01 00 02 50 44  ABPX...PDCX...PD
  38E0: 53 58 01 00 01 4C 53 43 58 01 00 27 00 10 50 53  SX...LSCX..'..PS
  38F0: 50 58 01 00 4F 3A 00 1E 48 50 45 58 01 50 4D 45  PX..O:..HPEX.PME
  3900: 58 01 00 1E 48 50 53 58 01 50 4D 53 58 01 5B 82  X...HPSX.PMSX.[.
  3910: 18 50 58 53 58 08 5F 41 44 52 0A 00 08 5F 50 52  .PXSX._ADR..._PR
  3920: 57 12 06 02 0A 09 0A 04 14 0F 5F 50 52 57 00 A4  W........._PRW..
  3930: 47 50 52 57 0A 09 0A 04 14 16 5F 50 52 54 00 A0  GPRW......_PRT..
  3940: 0A 50 49 43 4D A4 41 52 30 34 A4 50 52 30 34 5B  .PICM.AR04.PR04[
  3950: 82 4F 0A 52 50 30 32 08 5F 41 44 52 0C 01 00 1C  .O.RP02._ADR....
  3960: 00 5B 80 50 58 43 53 02 0A 40 0A C0 5B 81 41 05  .[.PXCS..@..[.A.
  3970: 50 58 43 53 40 00 40 09 00 0D 4C 41 53 58 01 00  PXCS@.@...LASX..
  3980: 32 41 42 50 58 01 00 02 50 44 43 58 01 00 02 50  2ABPX...PDCX...P
  3990: 44 53 58 01 00 01 4C 53 43 58 01 00 27 00 10 50  DSX...LSCX..'..P
  39A0: 53 50 58 01 00 4F 3A 00 1E 48 50 45 58 01 50 4D  SPX..O:..HPEX.PM
  39B0: 45 58 01 00 1E 48 50 53 58 01 50 4D 53 58 01 5B  EX...HPSX.PMSX.[
  39C0: 82 18 50 58 53 58 08 5F 41 44 52 0A 00 08 5F 50  ..PXSX._ADR..._P
  39D0: 52 57 12 06 02 0A 09 0A 04 14 0F 5F 50 52 57 00  RW........._PRW.
  39E0: A4 47 50 52 57 0A 09 0A 04 14 16 5F 50 52 54 00  .GPRW......_PRT.
  39F0: A0 0A 50 49 43 4D A4 41 52 30 35 A4 50 52 30 35  ..PICM.AR05.PR05
  3A00: 5B 82 4F 0A 52 50 30 33 08 5F 41 44 52 0C 02 00  [.O.RP03._ADR...
  3A10: 1C 00 5B 80 50 58 43 53 02 0A 40 0A C0 5B 81 41  ..[.PXCS..@..[.A
  3A20: 05 50 58 43 53 40 00 40 09 00 0D 4C 41 53 58 01  .PXCS@.@...LASX.
  3A30: 00 32 41 42 50 58 01 00 02 50 44 43 58 01 00 02  .2ABPX...PDCX...
  3A40: 50 44 53 58 01 00 01 4C 53 43 58 01 00 27 00 10  PDSX...LSCX..'..
  3A50: 50 53 50 58 01 00 4F 3A 00 1E 48 50 45 58 01 50  PSPX..O:..HPEX.P
  3A60: 4D 45 58 01 00 1E 48 50 53 58 01 50 4D 53 58 01  MEX...HPSX.PMSX.
  3A70: 5B 82 18 50 58 53 58 08 5F 41 44 52 0A 00 08 5F  [..PXSX._ADR..._
  3A80: 50 52 57 12 06 02 0A 09 0A 04 14 0F 5F 50 52 57  PRW........._PRW
  3A90: 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F 50 52 54  ..GPRW......_PRT
  3AA0: 00 A0 0A 50 49 43 4D A4 41 52 30 36 A4 50 52 30  ...PICM.AR06.PR0
  3AB0: 36 5B 82 4E 0D 52 50 30 34 08 5F 41 44 52 0C 03  6[.N.RP04._ADR..
  3AC0: 00 1C 00 5B 80 50 58 43 53 02 0A 40 0A C0 5B 81  ...[.PXCS..@..[.
  3AD0: 41 05 50 58 43 53 40 00 40 09 00 0D 4C 41 53 58  A.PXCS@.@...LASX
  3AE0: 01 00 32 41 42 50 58 01 00 02 50 44 43 58 01 00  ..2ABPX...PDCX..
  3AF0: 02 50 44 53 58 01 00 01 4C 53 43 58 01 00 27 00  .PDSX...LSCX..'.
  3B00: 10 50 53 50 58 01 00 4F 3A 00 1E 48 50 45 58 01  .PSPX..O:..HPEX.
  3B10: 50 4D 45 58 01 00 1E 48 50 53 58 01 50 4D 53 58  PMEX...HPSX.PMSX
  3B20: 01 5B 82 47 04 50 58 53 58 08 5F 41 44 52 0A 00  .[.G.PXSX._ADR..
  3B30: 08 5F 45 4A 44 0D 5C 5F 53 42 2E 50 43 49 30 2E  ._EJD.\_SB.PCI0.
  3B40: 45 48 43 32 2E 52 48 55 42 2E 50 52 54 31 2E 50  EHC2.RHUB.PRT1.P
  3B50: 52 54 33 00 14 09 5F 52 4D 56 00 A4 0A 01 08 5F  RT3..._RMV....._
  3B60: 50 52 57 12 06 02 0A 09 0A 04 14 0F 5F 50 52 57  PRW........._PRW
  3B70: 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F 50 52 54  ..GPRW......_PRT
  3B80: 00 A0 0A 50 49 43 4D A4 41 52 30 37 A4 50 52 30  ...PICM.AR07.PR0
  3B90: 37 5B 82 4F 0A 52 50 30 35 08 5F 41 44 52 0C 04  7[.O.RP05._ADR..
  3BA0: 00 1C 00 5B 80 50 58 43 53 02 0A 40 0A C0 5B 81  ...[.PXCS..@..[.
  3BB0: 41 05 50 58 43 53 40 00 40 09 00 0D 4C 41 53 58  A.PXCS@.@...LASX
  3BC0: 01 00 32 41 42 50 58 01 00 02 50 44 43 58 01 00  ..2ABPX...PDCX..
  3BD0: 02 50 44 53 58 01 00 01 4C 53 43 58 01 00 27 00  .PDSX...LSCX..'.
  3BE0: 10 50 53 50 58 01 00 4F 3A 00 1E 48 50 45 58 01  .PSPX..O:..HPEX.
  3BF0: 50 4D 45 58 01 00 1E 48 50 53 58 01 50 4D 53 58  PMEX...HPSX.PMSX
  3C00: 01 5B 82 18 50 58 53 58 08 5F 41 44 52 0A 00 08  .[..PXSX._ADR...
  3C10: 5F 50 52 57 12 06 02 0A 09 0A 04 14 0F 5F 50 52  _PRW........._PR
  3C20: 57 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F 50 52  W..GPRW......_PR
  3C30: 54 00 A0 0A 50 49 43 4D A4 41 52 30 38 A4 50 52  T...PICM.AR08.PR
  3C40: 30 38 5B 82 4F 0A 52 50 30 37 08 5F 41 44 52 0C  08[.O.RP07._ADR.
  3C50: 06 00 1C 00 5B 80 50 58 43 53 02 0A 40 0A C0 5B  ....[.PXCS..@..[
  3C60: 81 41 05 50 58 43 53 40 00 40 09 00 0D 4C 41 53  .A.PXCS@.@...LAS
  3C70: 58 01 00 32 41 42 50 58 01 00 02 50 44 43 58 01  X..2ABPX...PDCX.
  3C80: 00 02 50 44 53 58 01 00 01 4C 53 43 58 01 00 27  ..PDSX...LSCX..'
  3C90: 00 10 50 53 50 58 01 00 4F 3A 00 1E 48 50 45 58  ..PSPX..O:..HPEX
  3CA0: 01 50 4D 45 58 01 00 1E 48 50 53 58 01 50 4D 53  .PMEX...HPSX.PMS
  3CB0: 58 01 5B 82 18 50 58 53 58 08 5F 41 44 52 0A 00  X.[..PXSX._ADR..
  3CC0: 08 5F 50 52 57 12 06 02 0A 09 0A 04 14 0F 5F 50  ._PRW........._P
  3CD0: 52 57 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F 50  RW..GPRW......_P
  3CE0: 52 54 00 A0 0A 50 49 43 4D A4 41 52 30 45 A4 50  RT...PICM.AR0E.P
  3CF0: 52 30 45 5B 82 4F 0A 52 50 30 38 08 5F 41 44 52  R0E[.O.RP08._ADR
  3D00: 0C 07 00 1C 00 5B 80 50 58 43 53 02 0A 40 0A C0  .....[.PXCS..@..
  3D10: 5B 81 41 05 50 58 43 53 40 00 40 09 00 0D 4C 41  [.A.PXCS@.@...LA
  3D20: 53 58 01 00 32 41 42 50 58 01 00 02 50 44 43 58  SX..2ABPX...PDCX
  3D30: 01 00 02 50 44 53 58 01 00 01 4C 53 43 58 01 00  ...PDSX...LSCX..
  3D40: 27 00 10 50 53 50 58 01 00 4F 3A 00 1E 48 50 45  '..PSPX..O:..HPE
  3D50: 58 01 50 4D 45 58 01 00 1E 48 50 53 58 01 50 4D  X.PMEX...HPSX.PM
  3D60: 53 58 01 5B 82 18 50 58 53 58 08 5F 41 44 52 0A  SX.[..PXSX._ADR.
  3D70: 00 08 5F 50 52 57 12 06 02 0A 09 0A 04 14 0F 5F  .._PRW........._
  3D80: 50 52 57 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F  PRW..GPRW......_
  3D90: 50 52 54 00 A0 0A 50 49 43 4D A4 41 52 30 46 A4  PRT...PICM.AR0F.
  3DA0: 50 52 30 46 5B 82 1F 47 4C 41 4E 08 5F 41 44 52  PR0F[..GLAN._ADR
  3DB0: 0C 00 00 19 00 14 0F 5F 50 52 57 00 A4 47 50 52  ......._PRW..GPR
  3DC0: 57 0A 0D 0A 04 5B 82 3F 49 4F 31 30 08 5F 41 44  W....[.?IO10._AD
  3DD0: 52 0C 00 00 08 00 5B 80 49 42 55 53 02 0A D0 0A  R.....[.IBUS....
  3DE0: E0 5B 81 23 49 42 55 53 03 00 1A 54 4F 4C 4D 06  .[.#IBUS...TOLM.
  3DF0: 00 1A 54 4F 48 4D 26 00 40 52 56 54 45 4E 01 00  ..TOHM&.@RVTEN..
  3E00: 0B 56 54 42 41 14 5B 82 48 05 49 4F 31 58 08 5F  .VTBA.[.H.IO1X._
  3E10: 41 44 52 0C 01 00 08 00 5B 80 50 42 49 43 02 0A  ADR.....[.PBIC..
  3E20: 00 0A F0 5B 81 3B 50 42 49 43 03 00 40 3E 53 52  ...[.;PBIC..@>SR
  3E30: 30 5F 20 53 52 31 5F 20 53 52 32 5F 20 53 52 33  0_ SR1_ SR2_ SR3
  3E40: 5F 20 53 52 34 5F 20 53 52 35 5F 20 53 52 36 5F  _ SR4_ SR5_ SR6_
  3E50: 20 53 52 37 5F 20 53 52 38 5F 20 53 52 39 5F 20   SR7_ SR8_ SR9_ 
  3E60: 5B 82 3F 49 49 4F 30 08 5F 41 44 52 0C 00 00 14  [.?IIO0._ADR....
  3E70: 00 5B 80 49 42 55 53 02 0A D0 0A E0 5B 81 23 49  .[.IBUS.....[.#I
  3E80: 42 55 53 03 00 1A 54 4F 4C 4D 06 00 1A 54 4F 48  BUS...TOLM...TOH
  3E90: 4D 26 00 40 52 56 54 45 4E 01 00 0B 56 54 42 41  M&.@RVTEN...VTBA
  3EA0: 14 5B 82 48 05 49 49 4F 58 08 5F 41 44 52 0C 01  .[.H.IIOX._ADR..
  3EB0: 00 14 00 5B 80 50 42 49 43 02 0A 00 0A F0 5B 81  ...[.PBIC.....[.
  3EC0: 3B 50 42 49 43 03 00 40 3E 53 52 30 5F 20 53 52  ;PBIC..@>SR0_ SR
  3ED0: 31 5F 20 53 52 32 5F 20 53 52 33 5F 20 53 52 34  1_ SR2_ SR3_ SR4
  3EE0: 5F 20 53 52 35 5F 20 53 52 36 5F 20 53 52 37 5F  _ SR5_ SR6_ SR7_
  3EF0: 20 53 52 38 5F 20 53 52 39 5F 20 5B 82 36 50 45   SR8_ SR9_ [.6PE
  3F00: 47 33 08 5F 41 44 52 0C 00 00 03 00 14 0F 5F 50  G3._ADR......._P
  3F10: 52 57 00 A4 47 50 52 57 0A 09 0A 04 14 16 5F 50  RW..GPRW......_P
  3F20: 52 54 00 A0 0A 50 49 43 4D A4 41 52 30 41 A4 50  RT...PICM.AR0A.P
  3F30: 52 30 41 5B 82 1F 50 45 47 34 08 5F 41 44 52 0C  R0A[..PEG4._ADR.
  3F40: 00 00 04 00 14 0F 5F 50 52 57 00 A4 47 50 52 57  ......_PRW..GPRW
  3F50: 0A 09 0A 04 5B 82 36 50 45 47 35 08 5F 41 44 52  ....[.6PEG5._ADR
  3F60: 0C 00 00 05 00 14 0F 5F 50 52 57 00 A4 47 50 52  ......._PRW..GPR
  3F70: 57 0A 09 0A 04 14 16 5F 50 52 54 00 A0 0A 50 49  W......_PRT...PI
  3F80: 43 4D A4 41 52 30 43 A4 50 52 30 43 5B 82 1F 50  CM.AR0C.PR0C[..P
  3F90: 45 47 36 08 5F 41 44 52 0C 00 00 06 00 14 0F 5F  EG6._ADR......._
  3FA0: 50 52 57 00 A4 47 50 52 57 0A 09 0A 04 10 4B 12  PRW..GPRW.....K.
  3FB0: 5C 5F 47 50 45 14 4F 0D 5F 4C 30 39 00 86 5C 2F  \_GPE.O._L09..\/
  3FC0: 03 5F 53 42 5F 50 43 49 30 41 47 50 5F 0A 02 86  ._SB_PCI0AGP_...
  3FD0: 5C 2F 03 5F 53 42 5F 50 43 49 30 52 50 30 31 0A  \/._SB_PCI0RP01.
  3FE0: 02 86 5C 2F 03 5F 53 42 5F 50 43 49 30 52 50 30  ..\/._SB_PCI0RP0
  3FF0: 32 0A 02 86 5C 2F 03 5F 53 42 5F 50 43 49 30 52  2...\/._SB_PCI0R
  4000: 50 30 33 0A 02 86 5C 2F 03 5F 53 42 5F 50 43 49  P03...\/._SB_PCI
  4010: 30 52 50 30 34 0A 02 86 5C 2F 03 5F 53 42 5F 50  0RP04...\/._SB_P
  4020: 43 49 30 52 50 30 35 0A 02 86 5C 2F 03 5F 53 42  CI0RP05...\/._SB
  4030: 5F 50 43 49 30 52 50 30 37 0A 02 86 5C 2F 03 5F  _PCI0RP07...\/._
  4040: 53 42 5F 50 43 49 30 52 50 30 38 0A 02 86 5C 2F  SB_PCI0RP08...\/
  4050: 03 5F 53 42 5F 50 43 49 30 50 45 47 33 0A 02 86  ._SB_PCI0PEG3...
  4060: 5C 2F 03 5F 53 42 5F 50 43 49 30 50 45 47 34 0A  \/._SB_PCI0PEG4.
  4070: 02 86 5C 2F 03 5F 53 42 5F 50 43 49 30 50 45 47  ..\/._SB_PCI0PEG
  4080: 35 0A 02 86 5C 2F 03 5F 53 42 5F 50 43 49 30 50  5...\/._SB_PCI0P
  4090: 45 47 36 0A 02 14 18 5F 4C 30 42 00 86 5C 2F 03  EG6...._L0B..\/.
  40A0: 5F 53 42 5F 50 43 49 30 50 30 50 31 0A 02 14 2A  _SB_PCI0P0P1...*
  40B0: 5F 4C 30 44 00 86 5C 2F 03 5F 53 42 5F 50 43 49  _L0D..\/._SB_PCI
  40C0: 30 48 44 45 46 0A 02 86 5C 2F 03 5F 53 42 5F 50  0HDEF...\/._SB_P
  40D0: 43 49 30 47 4C 41 4E 0A 02 10 4F 06 5C 5F 50 52  CI0GLAN...O.\_PR
  40E0: 5F 5B 83 0B 43 50 55 30 01 10 04 00 00 06 5B 83  _[..CPU0......[.
  40F0: 0B 43 50 55 31 02 10 04 00 00 06 5B 83 0B 43 50  .CPU1......[..CP
  4100: 55 32 03 10 04 00 00 06 5B 83 0B 43 50 55 33 04  U2......[..CPU3.
  4110: 10 04 00 00 06 5B 83 0B 43 50 55 34 05 10 04 00  .....[..CPU4....
  4120: 00 06 5B 83 0B 43 50 55 35 06 10 04 00 00 06 5B  ..[..CPU5......[
  4130: 83 0B 43 50 55 36 07 10 04 00 00 06 5B 83 0B 43  ..CPU6......[..C
  4140: 50 55 37 08 10 04 00 00 06 5B 01 4D 55 54 58 00  PU7......[.MUTX.
  4150: 5B 80 50 52 54 30 01 0A 80 0A 04 5B 81 0B 50 52  [.PRT0.....[..PR
  4160: 54 30 13 50 38 30 48 20 14 40 08 50 38 58 48 0A  T0.P80H .@.P8XH.
  4170: A0 18 93 68 0A 00 70 7D 7B 50 38 30 44 0C 00 FF  ...h..p}{P80D...
  4180: FF FF 00 69 00 50 38 30 44 A0 1C 93 68 0A 01 70  ...i.P80D...h..p
  4190: 7D 7B 50 38 30 44 0C FF 00 FF FF 00 79 69 0A 08  }{P80D......yi..
  41A0: 00 00 50 38 30 44 A0 1C 93 68 0A 02 70 7D 7B 50  ..P80D...h..p}{P
  41B0: 38 30 44 0C FF FF 00 FF 00 79 69 0A 10 00 00 50  80D......yi....P
  41C0: 38 30 44 A0 1C 93 68 0A 03 70 7D 7B 50 38 30 44  80D...h..p}{P80D
  41D0: 0C FF FF FF 00 00 79 69 0A 18 00 00 50 38 30 44  ......yi....P80D
  41E0: 70 50 38 30 44 50 38 30 48 5B 80 53 50 52 54 01  pP80DP80H[.SPRT.
  41F0: 0A B2 0A 02 5B 81 0B 53 50 52 54 11 53 53 4D 50  ....[..SPRT.SSMP
  4200: 08 14 13 5C 5F 50 49 43 01 70 68 47 50 49 43 70  ...\_PIC.phGPICp
  4210: 68 50 49 43 4D 14 1E 47 45 54 42 0B 77 68 0A 08  hPICM..GETB.wh..
  4220: 60 77 69 0A 08 61 5B 13 6A 60 61 54 42 46 33 A4  `wi..a[.j`aTBF3.
  4230: 54 42 46 33 14 09 54 52 41 50 0A A4 0A 00 10 4F  TBF3..TRAP.....O
  4240: 20 5C 2E 5F 53 42 5F 50 43 49 30 14 44 0D 49 49   \._SB_PCI0.D.II
  4250: 4E 49 02 A0 08 92 93 68 0A 02 A4 00 70 0B D0 07  NI.....h....p...
  4260: 4F 53 59 53 A0 49 0B 5B 12 5C 5F 4F 53 49 60 A0  OSYS.I.[.\_OSI`.
  4270: 15 5C 5F 4F 53 49 0D 4C 69 6E 75 78 00 70 0B E8  .\_OSI.Linux.p..
  4280: 03 4F 53 59 53 A0 1C 5C 5F 4F 53 49 0D 57 69 6E  .OSYS..\_OSI.Win
  4290: 64 6F 77 73 20 32 30 30 31 00 70 0B D1 07 4F 53  dows 2001.p...OS
  42A0: 59 53 A0 20 5C 5F 4F 53 49 0D 57 69 6E 64 6F 77  YS. \_OSI.Window
  42B0: 73 20 32 30 30 31 20 53 50 31 00 70 0B D1 07 4F  s 2001 SP1.p...O
  42C0: 53 59 53 A0 20 5C 5F 4F 53 49 0D 57 69 6E 64 6F  SYS. \_OSI.Windo
  42D0: 77 73 20 32 30 30 31 20 53 50 32 00 70 0B D2 07  ws 2001 SP2.p...
  42E0: 4F 53 59 53 A0 1C 5C 5F 4F 53 49 0D 57 69 6E 64  OSYS..\_OSI.Wind
  42F0: 6F 77 73 20 32 30 30 36 00 70 0B D6 07 4F 53 59  ows 2006.p...OSY
  4300: 53 A0 1C 5C 5F 4F 53 49 0D 57 69 6E 64 6F 77 73  S..\_OSI.Windows
  4310: 20 32 30 30 39 00 70 0B D9 07 4F 53 59 53 A4 00   2009.p...OSYS..
  4320: 14 4F 06 4E 48 50 47 08 70 0A 00 5E 2E 52 50 30  .O.NHPG.p..^.RP0
  4330: 31 48 50 45 58 70 0A 00 5E 2E 52 50 30 32 48 50  1HPEXp..^.RP02HP
  4340: 45 58 70 0A 00 5E 2E 52 50 30 33 48 50 45 58 70  EXp..^.RP03HPEXp
  4350: 0A 00 5E 2E 52 50 30 34 48 50 45 58 70 0A 01 5E  ..^.RP04HPEXp..^
  4360: 2E 52 50 30 31 48 50 53 58 70 0A 01 5E 2E 52 50  .RP01HPSXp..^.RP
  4370: 30 32 48 50 53 58 70 0A 01 5E 2E 52 50 30 33 48  02HPSXp..^.RP03H
  4380: 50 53 58 70 0A 01 5E 2E 52 50 30 34 48 50 53 58  PSXp..^.RP04HPSX
  4390: 14 4D 0B 4E 50 4D 45 08 70 0A 00 5E 2E 52 50 30  .M.NPME.p..^.RP0
  43A0: 31 50 4D 45 58 70 0A 00 5E 2E 52 50 30 32 50 4D  1PMEXp..^.RP02PM
  43B0: 45 58 70 0A 00 5E 2E 52 50 30 33 50 4D 45 58 70  EXp..^.RP03PMEXp
  43C0: 0A 00 5E 2E 52 50 30 34 50 4D 45 58 70 0A 00 5E  ..^.RP04PMEXp..^
  43D0: 2E 52 50 30 35 50 4D 45 58 70 0A 00 5E 2E 52 50  .RP05PMEXp..^.RP
  43E0: 30 37 50 4D 45 58 70 0A 00 5E 2E 52 50 30 38 50  07PMEXp..^.RP08P
  43F0: 4D 45 58 70 0A 01 5E 2E 52 50 30 31 50 4D 53 58  MEXp..^.RP01PMSX
  4400: 70 0A 01 5E 2E 52 50 30 32 50 4D 53 58 70 0A 01  p..^.RP02PMSXp..
  4410: 5E 2E 52 50 30 33 50 4D 53 58 70 0A 01 5E 2E 52  ^.RP03PMSXp..^.R
  4420: 50 30 34 50 4D 53 58 70 0A 01 5E 2E 52 50 30 35  P04PMSXp..^.RP05
  4430: 50 4D 53 58 70 0A 01 5E 2E 52 50 30 37 50 4D 53  PMSXp..^.RP07PMS
  4440: 58 70 0A 01 5E 2E 52 50 30 38 50 4D 53 58 10 34  Xp..^.RP08PMSX.4
  4450: 5C 00 08 50 49 43 4D 0A 00 08 50 52 57 50 12 04  \..PICM...PRWP..
  4460: 02 00 00 14 1F 47 50 52 57 02 70 68 88 50 52 57  .....GPRW.ph.PRW
  4470: 50 0A 00 00 70 69 88 50 52 57 50 0A 01 00 A4 50  P...pi.PRWP....P
  4480: 52 57 50 10 40 36 5C 2E 5F 53 42 5F 50 43 49 30  RWP.@6\._SB_PCI0
  4490: 5B 82 42 35 50 44 52 43 08 5F 48 49 44 0C 41 D0  [.B5PDRC._HID.A.
  44A0: 0C 02 08 5F 55 49 44 0A 01 08 42 55 46 30 11 4A  ..._UID...BUF0.J
  44B0: 08 0A 86 86 09 00 01 00 00 00 00 00 40 00 00 86  ............@...
  44C0: 09 00 01 00 00 00 00 00 40 00 00 86 09 00 01 00  ........@.......
  44D0: 00 00 00 00 10 00 00 86 09 00 01 00 00 00 00 00  ................
  44E0: 10 00 00 86 09 00 01 00 00 00 00 00 00 00 00 86  ................
  44F0: 09 00 01 00 00 D2 FE 00 00 02 00 86 09 00 00 00  ................
  4500: 00 D9 FE 00 40 00 00 86 09 00 01 00 50 D4 FE 00  ....@.......P...
  4510: B0 04 00 86 09 00 00 00 00 00 FF 00 00 00 01 86  ................
  4520: 09 00 00 00 00 E0 FE 00 00 10 00 86 09 00 01 00  ................
  4530: 00 00 00 00 10 00 00 79 00 14 4A 2A 5F 43 52 53  .......y..J*_CRS
  4540: 08 8A 42 55 46 30 0A 04 52 42 52 30 79 5C 2F 04  ..BUF0..RBR0y\/.
  4550: 5F 53 42 5F 50 43 49 30 4C 50 43 42 52 43 42 41  _SB_PCI0LPCBRCBA
  4560: 0A 0E 52 42 52 30 8A 42 55 46 30 0A 7C 54 42 52  ..RBR0.BUF0.|TBR
  4570: 30 70 54 42 41 42 54 42 52 30 8A 42 55 46 30 0A  0pTBABTBR0.BUF0.
  4580: 80 54 42 4C 4E A0 0F 93 54 42 41 42 0A 00 70 0A  .TBLN...TBAB..p.
  4590: 00 54 42 4C 4E A0 36 7D 93 7B 50 4E 48 4D 0C F0  .TBLN.6}.{PNHM..
  45A0: FF 0F 00 00 0C E0 06 01 00 93 7B 50 4E 48 4D 0C  ..........{PNHM.
  45B0: F0 FF 0F 00 00 0C A0 06 01 00 00 8A 42 55 46 30  ............BUF0
  45C0: 0A 14 4D 42 4C 4E 70 00 4D 42 4C 4E A1 22 8A 42  ..MBLNp.MBLN.".B
  45D0: 55 46 30 0A 10 4D 42 52 30 79 5C 2F 03 5F 53 42  UF0..MBR0y\/._SB
  45E0: 5F 50 43 49 30 4D 48 42 52 0A 0E 4D 42 52 30 8A  _PCI0MHBR..MBR0.
  45F0: 42 55 46 30 0A 1C 44 42 52 30 79 5C 2F 03 5F 53  BUF0..DBR0y\/._S
  4600: 42 5F 50 43 49 30 44 49 42 52 0A 0C 44 42 52 30  B_PCI0DIBR..DBR0
  4610: A0 3B 7D 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C  .;}.{PNHM.......
  4620: E0 06 01 00 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00  .....{PNHM......
  4630: 0C A0 06 01 00 00 79 5C 2F 03 5F 53 42 5F 50 43  ......y\/._SB_PC
  4640: 49 30 44 49 42 49 0A 0C 44 42 52 30 A0 36 7D 93  I0DIBI..DBR0.6}.
  4650: 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01 00  {PNHM...........
  4660: 93 7B 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06 01  .{PNHM..........
  4670: 00 00 8A 42 55 46 30 0A 2C 45 42 4C 4E 70 00 45  ...BUF0.,EBLNp.E
  4680: 42 4C 4E A1 22 8A 42 55 46 30 0A 28 45 42 52 30  BLN.".BUF0.(EBR0
  4690: 79 5C 2F 03 5F 53 42 5F 50 43 49 30 45 50 42 52  y\/._SB_PCI0EPBR
  46A0: 0A 0C 45 42 52 30 8A 42 55 46 30 0A 34 58 42 52  ..EBR0.BUF0.4XBR
  46B0: 30 79 5C 2F 04 5F 53 42 5F 43 50 42 47 49 4D 43  0y\/._SB_CPBGIMC
  46C0: 48 50 58 42 52 0A 14 58 42 52 30 8A 42 55 46 30  HPXBR..XBR0.BUF0
  46D0: 0A 38 58 53 5A 30 7A 0C 00 00 00 10 5C 2F 04 5F  .8XSZ0z.....\/._
  46E0: 53 42 5F 43 50 42 47 49 4D 43 48 50 58 53 5A 58  SB_CPBGIMCHPXSZX
  46F0: 53 5A 30 8A 42 55 46 30 0A 4C 56 54 42 30 8A 42  SZ0.BUF0.LVTB0.B
  4700: 55 46 30 0A 50 56 54 4C 4E A0 44 0A 7D 93 7B 50  UF0.PVTLN.D.}.{P
  4710: 4E 48 4D 0C F0 FF 0F 00 00 0C E0 06 01 00 93 7B  NHM............{
  4720: 50 4E 48 4D 0C F0 FF 0F 00 00 0C A0 06 01 00 00  PNHM............
  4730: A0 44 04 92 95 50 4E 48 4D 0C E1 06 01 00 A0 2E  .D...PNHM.......
  4740: 5C 2F 04 5F 53 42 5F 50 43 49 30 49 4F 31 30 56  \/._SB_PCI0IO10V
  4750: 54 45 4E 79 5C 2F 04 5F 53 42 5F 50 43 49 30 49  TENy\/._SB_PCI0I
  4760: 4F 31 30 56 54 42 41 0A 0C 56 54 42 30 A1 07 70  O10VTBA..VTB0..p
  4770: 00 56 54 4C 4E A1 38 A0 2E 5C 2F 04 5F 53 42 5F  .VTLN.8..\/._SB_
  4780: 50 43 49 30 49 49 4F 30 56 54 45 4E 79 5C 2F 04  PCI0IIO0VTENy\/.
  4790: 5F 53 42 5F 50 43 49 30 49 49 4F 30 56 54 42 41  _SB_PCI0IIO0VTBA
  47A0: 0A 0C 56 54 42 30 A1 07 70 00 56 54 4C 4E A1 30  ..VTB0..p.VTLN.0
  47B0: A0 26 5C 2F 03 5F 53 42 5F 50 43 49 30 41 44 56  .&\/._SB_PCI0ADV
  47C0: 45 79 5C 2F 03 5F 53 42 5F 50 43 49 30 41 44 56  Ey\/._SB_PCI0ADV
  47D0: 54 0A 0C 56 54 42 30 A1 07 70 00 56 54 4C 4E A4  T..VTB0..p.VTLN.
  47E0: 42 55 46 30 10 4B 3B 5C 00 5B 80 49 4F 5F 54 01  BUF0.K;\.[.IO_T.
  47F0: 0B 04 10 0A 10 5B 81 24 49 4F 5F 54 01 54 52 50  .....[.$IO_T.TRP
  4800: 49 10 00 10 00 10 00 10 54 52 50 30 08 00 08 00  I.......TRP0....
  4810: 08 00 08 00 08 00 08 00 08 00 08 5B 80 49 4F 5F  ...........[.IO_
  4820: 44 01 0B 00 10 0A 04 5B 81 0B 49 4F 5F 44 01 54  D......[..IO_D.T
  4830: 52 50 44 08 5B 80 49 4F 5F 48 01 0B 00 10 0A 04  RPD.[.IO_H......
  4840: 5B 81 0B 49 4F 5F 48 01 54 52 50 48 08 5B 80 50  [..IO_H.TRPH.[.P
  4850: 4D 49 4F 01 0B 00 04 0A 80 5B 81 26 50 4D 49 4F  MIO......[.&PMIO
  4860: 01 00 40 10 00 02 53 50 53 54 01 00 4D 10 00 01  ..@...SPST..M...
  4870: 47 50 45 43 01 00 4E 10 00 09 53 43 49 53 01 00  GPEC..N...SCIS..
  4880: 06 5B 80 47 50 49 4F 01 0B 00 05 0A 64 5B 81 47  .[.GPIO.....d[.G
  4890: 0F 47 50 49 4F 01 47 55 30 30 08 47 55 30 31 08  .GPIO.GU00.GU01.
  48A0: 47 55 30 32 08 47 55 30 33 08 47 49 4F 30 08 47  GU02.GU03.GIO0.G
  48B0: 49 4F 31 08 47 49 4F 32 08 47 49 4F 33 08 00 20  IO1.GIO2.GIO3.. 
  48C0: 47 4C 30 30 08 47 4C 30 31 08 47 4C 30 32 08 00  GL00.GL01.GL02..
  48D0: 03 47 50 32 37 01 47 50 32 38 01 00 03 00 40 04  .GP27.GP28....@.
  48E0: 47 42 30 30 08 47 42 30 31 08 47 42 30 32 08 47  GB00.GB01.GB02.G
  48F0: 42 30 33 08 00 40 08 47 49 56 30 08 47 49 56 31  B03..@.GIV0.GIV1
  4900: 08 47 49 56 32 08 47 49 56 33 08 47 55 30 34 08  .GIV2.GIV3.GU04.
  4910: 47 55 30 35 08 47 55 30 36 08 47 55 30 37 08 47  GU05.GU06.GU07.G
  4920: 49 4F 34 08 47 49 4F 35 08 47 49 4F 36 08 47 49  IO4.GIO5.GIO6.GI
  4930: 4F 37 08 00 05 00 01 00 02 47 4C 30 35 08 47 4C  O7.......GL05.GL
  4940: 30 36 08 47 4C 30 37 08 00 20 47 55 30 38 08 47  06.GL07.. GU08.G
  4950: 55 30 39 08 47 55 30 41 08 47 55 30 42 08 47 49  U09.GU0A.GU0B.GI
  4960: 4F 38 08 47 49 4F 39 08 47 49 4F 41 08 47 49 4F  O8.GIO9.GIOA.GIO
  4970: 42 08 47 4C 30 38 08 47 4C 30 39 08 47 4C 30 41  B.GL08.GL09.GL0A
  4980: 08 47 4C 30 42 08 5B 80 52 43 52 42 00 53 52 43  .GL0B.[.RCRB.SRC
  4990: 42 0B 00 40 5B 81 4F 05 52 43 52 42 13 00 80 00  B..@[.O.RCRB....
  49A0: 08 00 80 00 10 00 80 02 02 48 50 41 53 02 00 05  .........HPAS...
  49B0: 48 50 41 45 01 00 48 09 00 01 00 01 53 41 54 44  HPAE..H.....SATD
  49C0: 01 53 4D 42 44 01 48 44 41 44 01 00 0B 52 50 31  .SMBD.HDAD...RP1
  49D0: 44 01 52 50 32 44 01 52 50 33 44 01 52 50 34 44  D.RP2D.RP3D.RP4D
  49E0: 01 52 50 35 44 01 52 50 36 44 01 52 50 37 44 01  .RP5D.RP6D.RP7D.
  49F0: 52 50 38 44 01 14 46 04 47 45 54 50 09 A0 0F 93  RP8D..F.GETP....
  4A00: 7B 68 0A 09 00 0A 00 A4 0C FF FF FF FF A0 0D 93  {h..............
  4A10: 7B 68 0A 09 00 0A 08 A4 0B 84 03 7A 7B 68 0B 00  {h.........z{h..
  4A20: 03 00 0A 08 60 7A 7B 68 0B 00 30 00 0A 0C 61 A4  ....`z{h..0...a.
  4A30: 77 0A 1E 74 0A 09 72 60 61 00 00 00 14 30 47 44  w..t..r`a....0GD
  4A40: 4D 41 0D A0 23 68 A0 07 90 69 6C A4 0A 14 A0 0E  MA..#h...il.....
  4A50: 90 6A 6C A4 77 74 0A 04 6B 00 0A 0F 00 A4 77 74  .jl.wt..k.....wt
  4A60: 0A 04 6B 00 0A 1E 00 A4 0C FF FF FF FF 14 1F 47  ..k............G
  4A70: 45 54 54 09 A4 77 0A 1E 74 0A 09 72 7B 7A 68 0A  ETT..w..t..r{zh.
  4A80: 02 00 0A 03 00 7B 68 0A 03 00 00 00 00 14 46 06  .....{h.......F.
  4A90: 47 45 54 46 0B 08 54 4D 50 46 0A 00 A0 0D 68 7D  GETF..TMPF....h}
  4AA0: 54 4D 50 46 0A 01 54 4D 50 46 A0 11 7B 6A 0A 02  TMPF..TMPF..{j..
  4AB0: 00 7D 54 4D 50 46 0A 02 54 4D 50 46 A0 0D 69 7D  .}TMPF..TMPF..i}
  4AC0: 54 4D 50 46 0A 04 54 4D 50 46 A0 11 7B 6A 0A 20  TMPF..TMPF..{j. 
  4AD0: 00 7D 54 4D 50 46 0A 08 54 4D 50 46 A0 12 7B 6A  .}TMPF..TMPF..{j
  4AE0: 0B 00 40 00 7D 54 4D 50 46 0A 10 54 4D 50 46 A4  ..@.}TMPF..TMPF.
  4AF0: 54 4D 50 46 14 3E 53 45 54 50 0B A0 08 94 68 0A  TMPF.>SETP....h.
  4B00: F0 A4 0A 08 A1 2E A0 28 7B 69 0A 02 00 A0 10 90  .......({i......
  4B10: 92 94 68 0A 78 7B 6A 0A 02 00 A4 0B 01 23 A0 10  ..h.x{j......#..
  4B20: 90 92 94 68 0A B4 7B 6A 0A 01 00 A4 0B 01 21 A4  ...h..{j......!.
  4B30: 0B 01 10 14 3B 53 44 4D 41 09 A0 09 92 94 68 0A  ....;SDMA.....h.
  4B40: 14 A4 0A 01 A0 09 92 94 68 0A 1E A4 0A 02 A0 09  ........h.......
  4B50: 92 94 68 0A 2D A4 0A 01 A0 09 92 94 68 0A 3C A4  ..h.-.......h.<.
  4B60: 0A 02 A0 09 92 94 68 0A 5A A4 0A 01 A4 0A 00 14  ......h.Z.......
  4B70: 30 53 45 54 54 0B A0 26 7B 69 0A 02 00 A0 0F 90  0SETT..&{i......
  4B80: 92 94 68 0A 78 7B 6A 0A 02 00 A4 0A 0B A0 0F 90  ..h.x{j.........
  4B90: 92 94 68 0A B4 7B 6A 0A 01 00 A4 0A 09 A4 0A 04  ..h..{j.........
  4BA0: 10 48 78 5C 2E 5F 53 42 5F 50 43 49 30 5B 82 4C  .Hx\._SB_PCI0[.L
  4BB0: 24 53 41 54 30 08 5F 41 44 52 0C 02 00 1F 00 5B  $SAT0._ADR.....[
  4BC0: 80 53 41 43 53 02 0A 40 0A C0 5B 81 4E 06 53 41  .SACS..@..[.N.SA
  4BD0: 43 53 03 50 52 49 54 10 53 45 43 54 10 50 53 49  CS.PRIT.SECT.PSI
  4BE0: 54 04 53 53 49 54 04 00 18 53 59 4E 43 04 00 0C  T.SSIT...SYNC...
  4BF0: 53 44 54 30 02 00 02 53 44 54 31 02 00 02 53 44  SDT0...SDT1...SD
  4C00: 54 32 02 00 02 53 44 54 33 02 00 42 04 49 43 52  T2...SDT3..B.ICR
  4C10: 30 04 49 43 52 31 04 49 43 52 32 04 49 43 52 33  0.ICR1.ICR2.ICR3
  4C20: 04 49 43 52 34 04 49 43 52 35 04 00 48 1C 4D 41  .ICR4.ICR5..H.MA
  4C30: 50 56 02 00 04 53 41 4D 53 02 14 09 5F 53 54 41  PV...SAMS..._STA
  4C40: 00 A4 0A 0F 5B 82 45 0D 50 52 54 30 08 5F 41 44  ....[.E.PRT0._AD
  4C50: 52 0B FF FF 08 47 54 46 30 11 0A 0A 07 00 00 00  R....GTF0.......
  4C60: 00 00 A0 00 14 18 5F 53 54 41 00 A0 0C 92 93 53  ......_STA.....S
  4C70: 41 4D 53 0A 00 A4 0A 0F A1 04 A4 0A 00 14 41 09  AMS...........A.
  4C80: 5F 53 44 44 01 08 46 46 53 30 11 0A 0A 07 00 00  _SDD..FFS0......
  4C90: 00 00 00 A0 00 8C 46 46 53 30 0A 00 46 46 30 30  ......FFS0..FF00
  4CA0: 8C 46 46 53 30 0A 06 46 46 30 36 A0 4A 05 93 87  .FFS0..FF06.J...
  4CB0: 68 0B 00 02 A0 41 05 92 93 46 46 53 4E 0A 00 8B  h....A...FFSN...
  4CC0: 68 0B 34 01 57 31 35 34 8B 68 0B 38 01 57 31 35  h.4.W154.h.8.W15
  4CD0: 36 A0 34 7B 93 57 31 35 34 0B 28 10 93 7B 57 31  6.4{.W154.(..{W1
  4CE0: 35 36 0B 00 40 00 0B 00 40 00 A0 1B 93 7B 57 31  56..@...@....{W1
  4CF0: 35 36 0B 00 80 00 0A 00 70 0A 5A 46 46 30 30 70  56......p.ZFF00p
  4D00: 0A EF 46 46 30 36 70 46 46 53 30 47 54 46 30 14  ..FF06pFFS0GTF0.
  4D10: 0B 5F 47 54 46 00 A4 47 54 46 30 5B 82 24 50 52  ._GTF..GTF0[.$PR
  4D20: 49 5F 08 5F 41 44 52 0A 00 14 17 5F 53 54 41 00  I_._ADR...._STA.
  4D30: A0 0B 93 53 41 4D 53 0A 00 A4 0A 0F A1 04 A4 0A  ...SAMS.........
  4D40: 00 5B 82 43 06 53 45 43 30 08 5F 41 44 52 0A 01  .[.C.SEC0._ADR..
  4D50: 14 17 5F 53 54 41 00 A0 0B 93 53 41 4D 53 0A 00  .._STA....SAMS..
  4D60: A4 0A 0F A1 04 A4 0A 00 5B 82 3C 4D 41 53 54 08  ........[.<MAST.
  4D70: 5F 41 44 52 0A 00 14 13 5F 45 4A 30 01 47 45 4E  _ADR...._EJ0.GEN
  4D80: 53 0A 17 0A 02 0A 00 A4 0A 00 14 1B 5F 53 54 41  S..........._STA
  4D90: 00 70 47 45 4E 53 0A 17 0A 01 0A 00 60 A0 05 60  .pGENS......`..`
  4DA0: A4 0A 0F A4 0A 00 14 44 05 5C 2F 05 5F 53 42 5F  .......D.\/._SB_
  4DB0: 50 43 49 30 53 41 54 30 53 45 43 30 4F 44 44 45  PCI0SAT0SEC0ODDE
  4DC0: 02 86 5C 2F 05 5F 53 42 5F 50 43 49 30 53 41 54  ..\/._SB_PCI0SAT
  4DD0: 30 53 45 43 30 4D 41 53 54 0A 01 A0 1F 92 95 4F  0SEC0MAST......O
  4DE0: 53 49 44 0A 10 86 5C 2F 04 5F 53 42 5F 50 43 49  SID...\/._SB_PCI
  4DF0: 30 53 41 54 30 53 45 43 30 0A 01 5B 82 4B 08 53  0SAT0SEC0..[.K.S
  4E00: 41 54 31 08 5F 41 44 52 0C 05 00 1F 00 5B 80 53  AT1._ADR.....[.S
  4E10: 41 43 53 02 0A 40 0A C0 5B 81 4E 06 53 41 43 53  ACS..@..[.N.SACS
  4E20: 03 50 52 49 54 10 53 45 43 54 10 50 53 49 54 04  .PRIT.SECT.PSIT.
  4E30: 53 53 49 54 04 00 18 53 59 4E 43 04 00 0C 53 44  SSIT...SYNC...SD
  4E40: 54 30 02 00 02 53 44 54 31 02 00 02 53 44 54 32  T0...SDT1...SDT2
  4E50: 02 00 02 53 44 54 33 02 00 42 04 49 43 52 30 04  ...SDT3..B.ICR0.
  4E60: 49 43 52 31 04 49 43 52 32 04 49 43 52 33 04 49  ICR1.ICR2.ICR3.I
  4E70: 43 52 34 04 49 43 52 35 04 00 48 1C 4D 41 50 56  CR4.ICR5..H.MAPV
  4E80: 02 00 04 53 41 4D 53 02 5B 82 4F 49 53 42 55 53  ...SAMS.[.OISBUS
  4E90: 08 5F 41 44 52 0C 03 00 1F 00 5B 80 53 4D 42 50  ._ADR.....[.SMBP
  4EA0: 02 0A 40 0A C0 5B 81 0D 53 4D 42 50 03 00 02 49  ..@..[..SMBP...I
  4EB0: 32 43 45 01 5B 80 53 4D 50 42 02 0A 20 0A 04 5B  2CE.[.SMPB.. ..[
  4EC0: 81 0D 53 4D 50 42 03 00 05 53 42 41 52 0B 5B 80  ..SMPB...SBAR.[.
  4ED0: 53 4D 42 49 01 79 53 42 41 52 0A 05 00 0A 10 5B  SMBI.ySBAR.....[
  4EE0: 81 3A 53 4D 42 49 01 48 53 54 53 08 00 08 48 43  .:SMBI.HSTS...HC
  4EF0: 4F 4E 08 48 43 4F 4D 08 54 58 53 41 08 44 41 54  ON.HCOM.TXSA.DAT
  4F00: 30 08 44 41 54 31 08 48 42 44 52 08 50 45 43 52  0.DAT1.HBDR.PECR
  4F10: 08 52 58 53 41 08 53 44 41 54 10 14 48 04 53 53  .RXSA.SDAT..H.SS
  4F20: 58 42 0A A0 08 53 54 52 54 A4 0A 00 70 0A 00 49  XB...STRT...p..I
  4F30: 32 43 45 70 0A BF 48 53 54 53 70 68 54 58 53 41  2CEp..HSTSphTXSA
  4F40: 70 69 48 43 4F 4D 70 0A 48 48 43 4F 4E A0 13 43  piHCOMp.HHCON..C
  4F50: 4F 4D 50 7D 48 53 54 53 0A FF 48 53 54 53 A4 0A  OMP}HSTS..HSTS..
  4F60: 01 A4 0A 00 14 4A 04 53 52 58 42 09 A0 09 53 54  .....J.SRXB...ST
  4F70: 52 54 A4 0B FF FF 70 0A 00 49 32 43 45 70 0A BF  RT....p..I2CEp..
  4F80: 48 53 54 53 70 7D 68 0A 01 00 54 58 53 41 70 0A  HSTSp}h...TXSAp.
  4F90: 44 48 43 4F 4E A0 15 43 4F 4D 50 7D 48 53 54 53  DHCON..COMP}HSTS
  4FA0: 0A FF 48 53 54 53 A4 44 41 54 30 A4 0B FF FF 14  ..HSTS.DAT0.....
  4FB0: 4E 04 53 57 52 42 0B A0 08 53 54 52 54 A4 0A 00  N.SWRB...STRT...
  4FC0: 70 0A 00 49 32 43 45 70 0A BF 48 53 54 53 70 68  p..I2CEp..HSTSph
  4FD0: 54 58 53 41 70 69 48 43 4F 4D 70 6A 44 41 54 30  TXSApiHCOMpjDAT0
  4FE0: 70 0A 48 48 43 4F 4E A0 13 43 4F 4D 50 7D 48 53  p.HHCON..COMP}HS
  4FF0: 54 53 0A FF 48 53 54 53 A4 0A 01 A4 0A 00 14 40  TS..HSTS.......@
  5000: 05 53 52 44 42 0A A0 09 53 54 52 54 A4 0B FF FF  .SRDB...STRT....
  5010: 70 0A 00 49 32 43 45 70 0A BF 48 53 54 53 70 7D  p..I2CEp..HSTSp}
  5020: 68 0A 01 00 54 58 53 41 70 69 48 43 4F 4D 70 0A  h...TXSApiHCOMp.
  5030: 48 48 43 4F 4E A0 15 43 4F 4D 50 7D 48 53 54 53  HHCON..COMP}HSTS
  5040: 0A FF 48 53 54 53 A4 44 41 54 30 A4 0B FF FF 14  ..HSTS.DAT0.....
  5050: 4C 05 53 57 52 57 0B A0 08 53 54 52 54 A4 0A 00  L.SWRW...STRT...
  5060: 70 0A 00 49 32 43 45 70 0A BF 48 53 54 53 70 68  p..I2CEp..HSTSph
  5070: 54 58 53 41 70 69 48 43 4F 4D 7B 6A 0A FF 44 41  TXSApiHCOM{j..DA
  5080: 54 31 7B 7A 6A 0A 08 00 0A FF 44 41 54 30 70 0A  T1{zj.....DAT0p.
  5090: 4C 48 43 4F 4E A0 13 43 4F 4D 50 7D 48 53 54 53  LHCON..COMP}HSTS
  50A0: 0A FF 48 53 54 53 A4 0A 01 A4 0A 00 14 4C 05 53  ..HSTS.......L.S
  50B0: 52 44 57 0A A0 09 53 54 52 54 A4 0B FF FF 70 0A  RDW...STRT....p.
  50C0: 00 49 32 43 45 70 0A BF 48 53 54 53 70 7D 68 0A  .I2CEp..HSTSp}h.
  50D0: 01 00 54 58 53 41 70 69 48 43 4F 4D 70 0A 4C 48  ..TXSApiHCOMp.LH
  50E0: 43 4F 4E A0 1F 43 4F 4D 50 7D 48 53 54 53 0A FF  CON..COMP}HSTS..
  50F0: 48 53 54 53 A4 7D 79 44 41 54 30 0A 08 00 44 41  HSTS.}yDAT0...DA
  5100: 54 31 00 A4 0C FF FF FF FF 14 40 0A 53 42 4C 57  T1........@.SBLW
  5110: 0C A0 08 53 54 52 54 A4 0A 00 70 6B 49 32 43 45  ...STRT...pkI2CE
  5120: 70 0A BF 48 53 54 53 70 68 54 58 53 41 70 69 48  p..HSTSphTXSApiH
  5130: 43 4F 4D 70 87 6A 44 41 54 30 70 0A 00 61 70 83  COMp.jDAT0p..ap.
  5140: 88 6A 0A 00 00 48 42 44 52 70 0A 54 48 43 4F 4E  .j...HBDRp.THCON
  5150: A2 42 04 94 87 6A 61 70 0B A0 0F 60 A2 12 90 92  .B...jap...`....
  5160: 7B 48 53 54 53 0A 80 00 60 76 60 5B 21 0A 32 A0  {HSTS...`v`[!.2.
  5170: 0A 92 60 4B 49 4C 4C A4 0A 00 70 0A 80 48 53 54  ..`KILL...p..HST
  5180: 53 75 61 A0 0F 94 87 6A 61 70 83 88 6A 61 00 48  Sua....jap..ja.H
  5190: 42 44 52 A0 13 43 4F 4D 50 7D 48 53 54 53 0A FF  BDR..COMP}HSTS..
  51A0: 48 53 54 53 A4 0A 01 A4 0A 00 14 48 0D 53 42 4C  HSTS.......H.SBL
  51B0: 52 0B 08 54 42 55 46 11 04 0B 00 01 A0 08 53 54  R..TBUF.......ST
  51C0: 52 54 A4 0A 00 70 6A 49 32 43 45 70 0A BF 48 53  RT...pjI2CEp..HS
  51D0: 54 53 70 7D 68 0A 01 00 54 58 53 41 70 69 48 43  TSp}h...TXSApiHC
  51E0: 4F 4D 70 0A 54 48 43 4F 4E 70 0B A0 0F 60 A2 12  OMp.THCONp...`..
  51F0: 90 92 7B 48 53 54 53 0A 80 00 60 76 60 5B 21 0A  ..{HSTS...`v`[!.
  5200: 32 A0 0A 92 60 4B 49 4C 4C A4 0A 00 70 44 41 54  2...`KILL...pDAT
  5210: 30 88 54 42 55 46 0A 00 00 70 0A 80 48 53 54 53  0.TBUF...p..HSTS
  5220: 70 0A 01 61 A2 45 04 95 61 83 88 54 42 55 46 0A  p..a.E..a..TBUF.
  5230: 00 00 70 0B A0 0F 60 A2 12 90 92 7B 48 53 54 53  ..p...`....{HSTS
  5240: 0A 80 00 60 76 60 5B 21 0A 32 A0 0A 92 60 4B 49  ...`v`[!.2...`KI
  5250: 4C 4C A4 0A 00 70 48 42 44 52 88 54 42 55 46 61  LL...pHBDR.TBUFa
  5260: 00 70 0A 80 48 53 54 53 75 61 A0 15 43 4F 4D 50  .p..HSTSua..COMP
  5270: 7D 48 53 54 53 0A FF 48 53 54 53 A4 54 42 55 46  }HSTS..HSTS.TBUF
  5280: A4 0A 00 14 47 05 53 54 52 54 08 70 0A C8 60 A2  ....G.STRT.p..`.
  5290: 21 60 A0 18 7B 48 53 54 53 0A 40 00 76 60 5B 22  !`..{HSTS.@.v`["
  52A0: 0A 01 A0 08 93 60 0A 00 A4 0A 01 A1 05 70 0A 00  .....`.......p..
  52B0: 60 70 0B A0 0F 60 A2 21 60 A0 19 7B 48 53 54 53  `p...`.!`..{HSTS
  52C0: 0A 01 00 76 60 5B 21 0A 32 A0 09 93 60 0A 00 4B  ...v`[!.2...`..K
  52D0: 49 4C 4C A1 04 A4 0A 00 A4 0A 01 14 30 43 4F 4D  ILL.........0COM
  52E0: 50 08 70 0B A0 0F 60 A2 21 60 A0 0C 7B 48 53 54  P.p...`.!`..{HST
  52F0: 53 0A 02 00 A4 0A 01 A1 11 76 60 5B 21 0A 32 A0  S........v`[!.2.
  5300: 09 93 60 0A 00 4B 49 4C 4C A4 0A 00 14 1C 4B 49  ..`..KILL.....KI
  5310: 4C 4C 08 7D 48 43 4F 4E 0A 02 48 43 4F 4E 7D 48  LL.}HCON..HCON}H
  5320: 53 54 53 0A FF 48 53 54 53 10 4F 0E 5C 5F 53 42  STS..HSTS.O.\_SB
  5330: 5F 5B 82 46 0E 41 4C 53 5F 08 5F 48 49 44 0D 41  _[.F.ALS_._HID.A
  5340: 43 50 49 30 30 30 38 00 14 41 05 5F 53 54 41 00  CPI0008..A._STA.
  5350: 08 41 42 55 46 11 03 0A 02 8C 41 42 55 46 0A 00  .ABUF.....ABUF..
  5360: 41 43 4D 44 8C 41 42 55 46 0A 01 41 44 41 54 70  ACMD.ABUF..ADATp
  5370: 0A 04 41 43 4D 44 70 47 45 4E 53 0A 09 41 42 55  ..ACMDpGENS..ABU
  5380: 46 87 41 42 55 46 60 A0 0A 93 41 44 41 54 00 70  F.ABUF`...ADAT.p
  5390: 00 60 A1 05 70 0A 0F 60 A4 60 14 41 05 5F 41 4C  .`..p..`.`.A._AL
  53A0: 49 00 08 41 42 55 46 11 03 0A 02 8C 41 42 55 46  I..ABUF.....ABUF
  53B0: 0A 00 41 43 4D 44 8C 41 42 55 46 0A 01 41 44 41  ..ACMD.ABUF..ADA
  53C0: 54 70 0A 05 41 43 4D 44 70 47 45 4E 53 0A 09 41  Tp..ACMDpGENS..A
  53D0: 42 55 46 87 41 42 55 46 60 A0 0A 93 41 44 41 54  BUF.ABUF`...ADAT
  53E0: 00 70 00 60 A1 05 70 0A 0F 60 A4 60 08 5F 41 4C  .p.`..p..`.`._AL
  53F0: 52 12 27 05 12 06 02 0A 46 0A 00 12 06 02 0A 49  R.'.....F......I
  5400: 0A 0A 12 06 02 0A 55 0A 50 12 07 02 0A 64 0B 2C  ......U.P....d.,
  5410: 01 12 07 02 0A 96 0B E8 03 10 4D 13 5C 5F 53 42  ..........M.\_SB
  5420: 5F 5B 82 44 13 43 50 42 47 08 5F 48 49 44 0C 41  _[.D.CPBG._HID.A
  5430: D0 0A 03 08 5F 55 49 44 0A FF 14 14 5F 42 42 4E  ...._UID...._BBN
  5440: 00 A4 74 7A 5C 50 45 4C 4E 0A 14 00 0A 01 00 08  ..tz\PELN.......
  5450: 5F 41 44 52 0A 00 08 42 55 46 30 11 15 0A 12 88  _ADR...BUF0.....
  5460: 0D 00 02 0C 00 00 00 FF 00 FF 00 00 00 01 00 79  ...............y
  5470: 00 14 46 04 5F 43 52 53 08 8B 42 55 46 30 0A 08  ..F._CRS..BUF0..
  5480: 50 42 4D 4E 70 74 7A 5C 50 45 4C 4E 0A 14 00 0A  PBMNptz\PELN....
  5490: 01 00 50 42 4D 4E 8B 42 55 46 30 0A 0A 50 42 4D  ..PBMN.BUF0..PBM
  54A0: 58 70 74 7A 5C 50 45 4C 4E 0A 14 00 0A 01 00 50  Xptz\PELN......P
  54B0: 42 4D 58 A4 42 55 46 30 5B 82 4D 09 49 4D 43 48  BMX.BUF0[.M.IMCH
  54C0: 08 5F 41 44 52 0A 01 5B 80 50 42 55 53 02 0A 00  ._ADR..[.PBUS...
  54D0: 0A C0 5B 81 43 08 50 42 55 53 03 00 40 20 00 04  ..[.C.PBUS..@ ..
  54E0: 50 4D 30 48 02 00 02 50 4D 31 4C 02 00 02 50 4D  PM0H...PM1L...PM
  54F0: 31 48 02 00 02 50 4D 32 4C 02 00 02 50 4D 32 48  1H...PM2L...PM2H
  5500: 02 00 02 50 4D 33 4C 02 00 02 50 4D 33 48 02 00  ...PM3L...PM3H..
  5510: 02 50 4D 34 4C 02 00 02 50 4D 34 48 02 00 02 50  .PM4L...PM4H...P
  5520: 4D 35 4C 02 00 02 50 4D 35 48 02 00 02 50 4D 36  M5L...PM5H...PM6
  5530: 4C 02 00 02 50 4D 36 48 02 00 02 00 08 00 07 48  L...PM6H.......H
  5540: 45 4E 41 01 00 38 50 58 45 4E 01 50 58 53 5A 02  ENA..8PXEN.PXSZ.
  5550: 00 11 50 58 42 52 0C 10 4E 05 5C 2E 5F 53 42 5F  ..PXBR..N.\._SB_
  5560: 50 43 49 30 5B 82 40 05 41 5F 43 43 08 5F 48 49  PCI0[.@.A_CC._HI
  5570: 44 0D 53 4D 4F 38 38 30 30 00 14 09 5F 53 54 41  D.SMO8800..._STA
  5580: 00 A4 0A 0F 08 5F 55 49 44 01 08 42 55 46 32 11  ....._UID..BUF2.
  5590: 0E 0A 0B 89 06 00 03 01 17 00 00 00 79 00 14 0B  ............y...
  55A0: 5F 43 52 53 08 A4 42 55 46 32 14 0B 5F 53 52 53  _CRS..BUF2.._SRS
  55B0: 09 A4 42 55 46 32 5B 82 4A 2E 5C 2F 04 5F 53 42  ..BUF2[.J.\/._SB
  55C0: 5F 50 43 49 30 4C 50 43 42 54 50 4D 5F 08 5F 48  _PCI0LPCBTPM_._H
  55D0: 49 44 0C 08 6D 01 02 08 5F 43 49 44 0C 41 D0 0C  ID..m..._CID.A..
  55E0: 31 08 5F 53 54 52 11 21 0A 1E 54 00 50 00 4D 00  1._STR.!..T.P.M.
  55F0: 20 00 31 00 2E 00 32 00 20 00 44 00 65 00 76 00   .1...2. .D.e.v.
  5600: 69 00 63 00 65 00 00 00 08 5F 43 52 53 11 11 0A  i.c.e...._CRS...
  5610: 0E 86 09 00 00 00 00 D4 FE 00 50 00 00 79 00 5B  ..........P..y.[
  5620: 80 53 4D 49 50 01 0A B2 0A 01 5B 81 0B 53 4D 49  .SMIP.....[..SMI
  5630: 50 01 49 4F 42 32 08 5B 80 54 50 4D 52 00 0C 00  P.IOB2.[.TPMR...
  5640: 00 D4 FE 0B 00 50 5B 81 0B 54 50 4D 52 00 41 43  .....P[..TPMR.AC
  5650: 43 30 08 14 2D 50 54 53 5F 09 A0 23 90 95 68 0A  C0..-PTS_..#..h.
  5660: 06 94 68 0A 03 A0 18 92 7B 4D 4F 52 44 0A 10 00  ..h.....{MORD...
  5670: 70 0A 02 54 43 47 50 70 0A 5A 49 4F 42 32 A4 0A  p..TCGPp.ZIOB2..
  5680: 00 14 24 5F 53 54 41 00 A0 0B 93 54 50 4D 45 0A  ..$_STA....TPME.
  5690: 00 A4 0A 00 A0 0C 92 93 41 43 43 30 0A FF A4 0A  ........ACC0....
  56A0: 0F A1 04 A4 0A 00 14 43 05 48 49 4E 46 0B 08 5F  .......C.HINF.._
  56B0: 54 5F 30 00 70 99 69 00 5F 54 5F 30 A0 0E 93 5F  T_0.p.i._T_0..._
  56C0: 54 5F 30 0A 00 A4 11 04 0A 01 01 A1 29 A0 24 93  T_0.........).$.
  56D0: 5F 54 5F 30 0A 01 A0 0E 93 5F 53 54 41 0A 00 A4  _T_0....._STA...
  56E0: 12 04 01 0A 00 A4 12 0B 02 0A 01 12 06 02 0A 01  ................
  56F0: 0A 20 A1 02 CC A4 11 03 0A 00 08 54 50 4D 32 12  . .........TPM2.
  5700: 04 02 00 00 08 54 50 4D 33 12 05 03 00 00 00 14  .....TPM3.......
  5710: 45 0D 54 50 50 49 0B 08 5F 54 5F 30 00 70 99 69  E.TPPI.._T_0.p.i
  5720: 00 5F 54 5F 30 A0 0E 93 5F 54 5F 30 0A 00 A4 11  ._T_0..._T_0....
  5730: 04 0A 01 3F A1 4D 0A A0 0E 93 5F 54 5F 30 0A 01  ...?.M...._T_0..
  5740: A4 0D 31 2E 30 00 A1 4B 09 A0 21 93 5F 54 5F 30  ..1.0..K..!._T_0
  5750: 0A 02 70 99 6A 00 50 50 52 51 70 0A 02 54 43 47  ..p.j.PPRQp..TCG
  5760: 50 70 0A 5B 49 4F 42 32 A4 0A 00 A1 46 07 A0 1A  Pp.[IOB2....F...
  5770: 93 5F 54 5F 30 0A 03 70 50 50 52 51 88 54 50 4D  ._T_0..pPPRQ.TPM
  5780: 32 0A 01 00 A4 54 50 4D 32 A1 48 05 A0 0B 93 5F  2....TPM2.H...._
  5790: 54 5F 30 0A 04 A4 0A 02 A1 49 04 A0 35 93 5F 54  T_0......I..5._T
  57A0: 5F 30 0A 05 70 0A 05 54 43 47 50 70 0A 5B 49 4F  _0..p..TCGPp.[IO
  57B0: 42 32 70 4C 50 50 52 88 54 50 4D 33 0A 01 00 70  B2pLPPR.TPM3...p
  57C0: 50 50 52 50 88 54 50 4D 33 0A 02 00 A4 54 50 4D  PPRP.TPM3....TPM
  57D0: 33 A1 10 A0 0B 93 5F 54 5F 30 0A 06 A4 0A 00 A1  3....._T_0......
  57E0: 02 CC A4 0A 01 14 4E 04 53 4D 42 53 0B 08 5F 54  ......N.SMBS.._T
  57F0: 5F 30 00 70 99 69 00 5F 54 5F 30 A0 0E 93 5F 54  _0.p.i._T_0..._T
  5800: 5F 30 0A 00 A4 11 04 0A 01 01 A1 26 A0 21 93 5F  _0.........&.!._
  5810: 54 5F 30 0A 01 70 99 6A 00 4D 4F 52 44 70 0A 01  T_0..p.j.MORDp..
  5820: 54 43 47 50 70 0A 5A 49 4F 42 32 A4 0A 00 A1 02  TCGPp.ZIOB2.....
  5830: CC A4 0A 01 14 4D 06 5F 44 53 4D 0C A0 1F 93 68  .....M._DSM....h
  5840: 11 13 0A 10 A5 16 8E CF E8 C1 25 4E B7 12 4F 54  ..........%N..OT
  5850: A9 67 02 C8 A4 48 49 4E 46 69 6A 6B A0 1F 93 68  .g...HINFijk...h
  5860: 11 13 0A 10 A6 FA DD 3D 1B 36 B4 4E A4 24 8D 10  .......=.6.N.$..
  5870: 08 9D 16 53 A4 54 50 50 49 69 6A 6B A0 1F 93 68  ...S.TPPIijk...h
  5880: 11 13 0A 10 ED 54 60 37 13 CC 75 46 90 1C 47 56  .....T`7..uF..GV
  5890: D7 F2 D4 5D A4 53 4D 42 53 69 6A 6B A4 11 04 0A  ...].SMBSijk....
  58A0: 01 00 10 44 0A 5C 5F 50 52 5F 14 4C 09 50 50 43  ...D.\_PR_.L.PPC
  58B0: 45 02 70 47 45 4E 53 0A 15 0A 00 0A 00 60 70 60  E.pGENS......`p`
  58C0: 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 50 43 86  \/._PR_CPU0_PPC.
  58D0: 43 50 55 30 0A 80 5B 22 0A 64 A0 4C 06 92 95 54  CPU0..[".d.L...T
  58E0: 43 4E 54 0A 02 86 43 50 55 31 0A 80 5B 22 0A 64  CNT...CPU1..[".d
  58F0: A0 46 05 92 95 54 43 4E 54 0A 04 86 43 50 55 32  .F...TCNT...CPU2
  5900: 0A 80 5B 22 0A 64 86 43 50 55 33 0A 80 5B 22 0A  ..[".d.CPU3..[".
  5910: 64 A0 35 92 95 54 43 4E 54 0A 08 86 43 50 55 34  d.5..TCNT...CPU4
  5920: 0A 80 5B 22 0A 64 86 43 50 55 35 0A 80 5B 22 0A  ..[".d.CPU5..[".
  5930: 64 86 43 50 55 36 0A 80 5B 22 0A 64 86 43 50 55  d.CPU6..[".d.CPU
  5940: 37 0A 80 5B 22 0A 64 5B 82 40 08 5C 2F 04 5F 53  7..[".d[.@.\/._S
  5950: 42 5F 50 43 49 30 4C 50 43 42 54 43 4D 5F 08 5F  B_PCI0LPCBTCM_._
  5960: 48 49 44 0C 69 23 01 01 08 5F 43 52 53 11 11 0A  HID.i#..._CRS...
  5970: 0E 86 09 00 00 00 00 D4 FE 00 50 00 00 79 00 5B  ..........P..y.[
  5980: 80 54 43 4D 52 00 0C 00 00 D4 FE 0B 00 50 5B 81  .TCMR........P[.
  5990: 14 54 43 4D 52 00 41 43 43 30 08 00 88 7F 07 56  .TCMR.ACC0.....V
  59A0: 49 44 5F 10 14 24 5F 53 54 41 00 A0 0B 93 54 43  ID_..$_STA....TC
  59B0: 4D 45 0A 00 A4 0A 00 A0 0C 93 56 49 44 5F 0B 4E  ME........VID_.N
  59C0: 1B A4 0A 0F A1 04 A4 0A 00 10 48 47 5C 2E 5F 53  ..........HG\._S
  59D0: 42 5F 50 43 49 30 14 14 55 50 52 57 00 70 47 45  B_PCI0..UPRW.pGE
  59E0: 4E 53 0A 18 0A 01 0A 00 60 A4 60 5B 82 40 20 45  NS......`.`[.@ E
  59F0: 48 43 32 08 5F 41 44 52 0C 00 00 1A 00 08 5F 53  HC2._ADR......_S
  5A00: 31 44 0A 02 08 5F 53 33 44 0A 02 14 30 5F 50 52  1D..._S3D...0_PR
  5A10: 57 00 70 55 50 52 57 60 A0 0D 93 60 0A 03 A4 12  W.pUPRW`...`....
  5A20: 06 02 0A 0D 0A 03 A0 0D 93 60 0A 01 A4 12 06 02  .........`......
  5A30: 0A 0D 0A 01 A4 12 06 02 0A 0D 0A 00 5B 82 4F 1A  ............[.O.
  5A40: 52 48 55 42 08 5F 41 44 52 0A 00 5B 82 42 18 50  RHUB._ADR..[.B.P
  5A50: 52 54 31 08 5F 41 44 52 0A 01 08 5F 55 50 43 12  RT1._ADR..._UPC.
  5A60: 0A 04 0A 00 0A FF 0A 00 0A 00 5B 82 35 50 52 54  ..........[.5PRT
  5A70: 31 08 5F 41 44 52 0A 01 08 5F 55 50 43 12 0A 04  1._ADR..._UPC...
  5A80: 0A FF 0A FF 0A 00 0A 00 08 5F 50 4C 44 11 13 0A  ........._PLD...
  5A90: 10 81 00 00 00 00 00 00 00 30 1C 00 00 00 00 00  .........0......
  5AA0: 00 5B 82 35 50 52 54 32 08 5F 41 44 52 0A 02 08  .[.5PRT2._ADR...
  5AB0: 5F 55 50 43 12 0A 04 0A FF 0A FF 0A 00 0A 00 08  _UPC............
  5AC0: 5F 50 4C 44 11 13 0A 10 81 00 00 00 00 00 00 00  _PLD............
  5AD0: 30 1C 00 00 00 00 00 00 5B 82 40 05 50 52 54 33  0.......[.@.PRT3
  5AE0: 08 5F 41 44 52 0A 03 08 5F 55 50 43 12 0A 04 0A  ._ADR..._UPC....
  5AF0: FF 0A FF 0A 00 0A 00 08 5F 50 4C 44 11 13 0A 10  ........_PLD....
  5B00: 81 00 00 00 00 00 00 00 30 1C 00 00 00 00 00 00  ........0.......
  5B10: 08 5F 45 4A 44 0D 5C 5F 53 42 2E 50 43 49 30 2E  ._EJD.\_SB.PCI0.
  5B20: 52 50 30 34 2E 50 58 53 58 00 5B 82 35 50 52 54  RP04.PXSX.[.5PRT
  5B30: 34 08 5F 41 44 52 0A 04 08 5F 55 50 43 12 0A 04  4._ADR..._UPC...
  5B40: 0A FF 0A FF 0A 00 0A 00 08 5F 50 4C 44 11 13 0A  ........._PLD...
  5B50: 10 81 00 00 00 00 00 00 00 30 1C 00 00 00 00 00  .........0......
  5B60: 00 5B 82 35 50 52 54 35 08 5F 41 44 52 0A 05 08  .[.5PRT5._ADR...
  5B70: 5F 55 50 43 12 0A 04 0A FF 0A FF 0A 00 0A 00 08  _UPC............
  5B80: 5F 50 4C 44 11 13 0A 10 81 00 00 00 00 00 00 00  _PLD............
  5B90: 30 1C 00 00 00 00 00 00 5B 82 35 50 52 54 36 08  0.......[.5PRT6.
  5BA0: 5F 41 44 52 0A 06 08 5F 55 50 43 12 0A 04 0A FF  _ADR..._UPC.....
  5BB0: 0A FF 0A 00 0A 00 08 5F 50 4C 44 11 13 0A 10 81  ......._PLD.....
  5BC0: 00 00 00 00 00 00 00 30 1C 00 00 00 00 00 00 5B  .......0.......[
  5BD0: 82 1C 50 52 54 32 08 5F 41 44 52 0A 02 08 5F 55  ..PRT2._ADR..._U
  5BE0: 50 43 12 0A 04 0A 00 0A FF 0A 00 0A 00 5B 82 43  PC...........[.C
  5BF0: 25 45 48 43 49 08 5F 41 44 52 0C 00 00 1D 00 08  %EHCI._ADR......
  5C00: 5F 53 31 44 0A 02 08 5F 53 33 44 0A 02 14 30 5F  _S1D..._S3D...0_
  5C10: 50 52 57 00 70 55 50 52 57 60 A0 0D 93 60 0A 03  PRW.pUPRW`...`..
  5C20: A4 12 06 02 0A 0D 0A 03 A0 0D 93 60 0A 01 A4 12  ...........`....
  5C30: 06 02 0A 0D 0A 01 A4 12 06 02 0A 0D 0A 00 5B 82  ..............[.
  5C40: 42 20 52 48 55 42 08 5F 41 44 52 0A 00 5B 82 45  B RHUB._ADR..[.E
  5C50: 1D 50 52 54 31 08 5F 41 44 52 0A 01 08 5F 55 50  .PRT1._ADR..._UP
  5C60: 43 12 0A 04 0A 00 0A FF 0A 00 0A 00 5B 82 35 50  C...........[.5P
  5C70: 52 54 31 08 5F 41 44 52 0A 01 08 5F 55 50 43 12  RT1._ADR..._UPC.
  5C80: 0A 04 0A FF 0A 00 0A 00 0A 00 08 5F 50 4C 44 11  ..........._PLD.
  5C90: 13 0A 10 81 00 00 00 00 00 00 00 19 12 00 00 03  ................
  5CA0: 00 00 00 5B 82 35 50 52 54 32 08 5F 41 44 52 0A  ...[.5PRT2._ADR.
  5CB0: 02 08 5F 55 50 43 12 0A 04 0A FF 0A 00 0A 00 0A  .._UPC..........
  5CC0: 00 08 5F 50 4C 44 11 13 0A 10 81 00 00 00 00 00  .._PLD..........
  5CD0: 00 00 11 11 00 00 03 00 00 00 5B 82 35 50 52 54  ..........[.5PRT
  5CE0: 33 08 5F 41 44 52 0A 03 08 5F 55 50 43 12 0A 04  3._ADR..._UPC...
  5CF0: 0A FF 0A 00 0A 00 0A 00 08 5F 50 4C 44 11 13 0A  ........._PLD...
  5D00: 10 81 00 00 00 00 00 00 00 91 11 00 00 03 00 00  ................
  5D10: 00 5B 82 35 50 52 54 34 08 5F 41 44 52 0A 04 08  .[.5PRT4._ADR...
  5D20: 5F 55 50 43 12 0A 04 0A FF 0A 00 0A 00 0A 00 08  _UPC............
  5D30: 5F 50 4C 44 11 13 0A 10 81 00 00 00 00 00 00 00  _PLD............
  5D40: 99 12 00 00 03 00 00 00 5B 82 35 50 52 54 35 08  ........[.5PRT5.
  5D50: 5F 41 44 52 0A 05 08 5F 55 50 43 12 0A 04 0A FF  _ADR..._UPC.....
  5D60: 0A FF 0A 00 0A 00 08 5F 50 4C 44 11 13 0A 10 81  ......._PLD.....
  5D70: 00 00 00 00 00 00 00 3A 1C 00 00 03 00 00 00 5B  .......:.......[
  5D80: 82 35 50 52 54 36 08 5F 41 44 52 0A 06 08 5F 55  .5PRT6._ADR..._U
  5D90: 50 43 12 0A 04 0A FF 0A FF 0A 00 0A 00 08 5F 50  PC............_P
  5DA0: 4C 44 11 13 0A 10 81 00 00 00 00 00 00 00 3A 1C  LD............:.
  5DB0: 00 00 03 00 00 00 5B 82 35 50 52 54 37 08 5F 41  ......[.5PRT7._A
  5DC0: 44 52 0A 07 08 5F 55 50 43 12 0A 04 0A FF 0A 02  DR..._UPC.......
  5DD0: 0A 00 0A 00 08 5F 50 4C 44 11 13 0A 10 81 00 00  ....._PLD.......
  5DE0: 00 00 00 00 00 59 11 00 00 03 00 00 00 5B 82 35  .....Y.......[.5
  5DF0: 50 52 54 38 08 5F 41 44 52 0A 08 08 5F 55 50 43  PRT8._ADR..._UPC
  5E00: 12 0A 04 0A FF 0A FF 0A 00 0A 00 08 5F 50 4C 44  ............_PLD
  5E10: 11 13 0A 10 81 00 00 00 00 00 00 00 30 1C 00 00  ............0...
  5E20: 00 00 00 00 5B 82 1C 50 52 54 32 08 5F 41 44 52  ....[..PRT2._ADR
  5E30: 0A 02 08 5F 55 50 43 12 0A 04 0A 00 0A FF 0A 00  ..._UPC.........
  5E40: 0A 00 10 40 23 5C 5F 47 50 45 14 0A 4E 57 41 4B  ...@#\_GPE..NWAK
  5E50: 02 5F 4C 30 31 14 42 21 5F 4C 30 31 00 A0 32 90  ._L01.B!_L01..2.
  5E60: 93 52 50 31 44 0A 00 5C 2F 04 5F 53 42 5F 50 43  .RP1D..\/._SB_PC
  5E70: 49 30 52 50 30 31 48 50 53 58 70 0A 01 5C 2F 04  I0RP01HPSXp..\/.
  5E80: 5F 53 42 5F 50 43 49 30 52 50 30 31 48 50 53 58  _SB_PCI0RP01HPSX
  5E90: A0 32 90 93 52 50 31 44 0A 00 5C 2F 04 5F 53 42  .2..RP1D..\/._SB
  5EA0: 5F 50 43 49 30 52 50 30 31 50 44 43 58 70 0A 01  _PCI0RP01PDCXp..
  5EB0: 5C 2F 04 5F 53 42 5F 50 43 49 30 52 50 30 31 50  \/._SB_PCI0RP01P
  5EC0: 44 43 58 A0 32 90 93 52 50 32 44 0A 00 5C 2F 04  DCX.2..RP2D..\/.
  5ED0: 5F 53 42 5F 50 43 49 30 52 50 30 32 48 50 53 58  _SB_PCI0RP02HPSX
  5EE0: 70 0A 01 5C 2F 04 5F 53 42 5F 50 43 49 30 52 50  p..\/._SB_PCI0RP
  5EF0: 30 32 48 50 53 58 A0 32 90 93 52 50 32 44 0A 00  02HPSX.2..RP2D..
  5F00: 5C 2F 04 5F 53 42 5F 50 43 49 30 52 50 30 32 50  \/._SB_PCI0RP02P
  5F10: 44 43 58 70 0A 01 5C 2F 04 5F 53 42 5F 50 43 49  DCXp..\/._SB_PCI
  5F20: 30 52 50 30 32 50 44 43 58 A0 32 90 93 52 50 33  0RP02PDCX.2..RP3
  5F30: 44 0A 00 5C 2F 04 5F 53 42 5F 50 43 49 30 52 50  D..\/._SB_PCI0RP
  5F40: 30 33 48 50 53 58 70 0A 01 5C 2F 04 5F 53 42 5F  03HPSXp..\/._SB_
  5F50: 50 43 49 30 52 50 30 33 48 50 53 58 A0 32 90 93  PCI0RP03HPSX.2..
  5F60: 52 50 33 44 0A 00 5C 2F 04 5F 53 42 5F 50 43 49  RP3D..\/._SB_PCI
  5F70: 30 52 50 30 33 50 44 43 58 70 0A 01 5C 2F 04 5F  0RP03PDCXp..\/._
  5F80: 53 42 5F 50 43 49 30 52 50 30 33 50 44 43 58 A0  SB_PCI0RP03PDCX.
  5F90: 32 90 93 52 50 34 44 0A 00 5C 2F 04 5F 53 42 5F  2..RP4D..\/._SB_
  5FA0: 50 43 49 30 52 50 30 34 48 50 53 58 70 0A 01 5C  PCI0RP04HPSXp..\
  5FB0: 2F 04 5F 53 42 5F 50 43 49 30 52 50 30 34 48 50  /._SB_PCI0RP04HP
  5FC0: 53 58 A0 32 90 93 52 50 34 44 0A 00 5C 2F 04 5F  SX.2..RP4D..\/._
  5FD0: 53 42 5F 50 43 49 30 52 50 30 34 50 44 43 58 70  SB_PCI0RP04PDCXp
  5FE0: 0A 01 5C 2F 04 5F 53 42 5F 50 43 49 30 52 50 30  ..\/._SB_PCI0RP0
  5FF0: 34 50 44 43 58 A0 32 90 93 52 50 35 44 0A 00 5C  4PDCX.2..RP5D..\
  6000: 2F 04 5F 53 42 5F 50 43 49 30 52 50 30 35 48 50  /._SB_PCI0RP05HP
  6010: 53 58 70 0A 01 5C 2F 04 5F 53 42 5F 50 43 49 30  SXp..\/._SB_PCI0
  6020: 52 50 30 35 48 50 53 58 A0 32 90 93 52 50 35 44  RP05HPSX.2..RP5D
  6030: 0A 00 5C 2F 04 5F 53 42 5F 50 43 49 30 52 50 30  ..\/._SB_PCI0RP0
  6040: 35 50 44 43 58 70 0A 01 5C 2F 04 5F 53 42 5F 50  5PDCXp..\/._SB_P
  6050: 43 49 30 52 50 30 35 50 44 43 58 86 5C 2E 5F 53  CI0RP05PDCX.\._S
  6060: 42 5F 50 43 49 30 0A 00 14 0A 5F 4C 31 38 00 70  B_PCI0...._L18.p
  6070: 0A 00 60 08 41 50 52 45 0A 00 10 46 5B 5C 2F 03  ..`.APRE...F[\/.
  6080: 5F 53 42 5F 50 43 49 30 4C 50 43 42 5B 82 43 5A  _SB_PCI0LPCB[.CZ
  6090: 45 43 44 56 08 5F 48 49 44 0C 41 D0 0C 09 08 5F  ECDV._HID.A...._
  60A0: 55 49 44 0A 00 08 45 43 52 53 11 15 0A 12 47 01  UID...ECRS....G.
  60B0: 00 00 00 00 00 01 47 01 00 00 00 00 00 01 79 00  ......G.......y.
  60C0: 14 4E 05 5F 43 52 53 00 8B 45 43 52 53 0A 02 44  .N._CRS..ECRS..D
  60D0: 4D 49 4E 8B 45 43 52 53 0A 04 44 4D 41 58 8B 45  MIN.ECRS..DMAX.E
  60E0: 43 52 53 0A 0A 43 4D 49 4E 8B 45 43 52 53 0A 0C  CRS..CMIN.ECRS..
  60F0: 43 4D 41 58 72 0B 00 09 0A 30 60 70 60 44 4D 49  CMAXr....0`p`DMI
  6100: 4E 70 60 44 4D 41 58 72 0B 00 09 0A 34 60 70 60  Np`DMAXr....4`p`
  6110: 43 4D 49 4E 70 60 43 4D 41 58 A4 45 43 52 53 08  CMINp`CMAX.ECRS.
  6120: 5F 47 50 45 0A 10 08 45 43 49 42 11 03 0A FF 5B  _GPE...ECIB....[
  6130: 80 45 43 4F 52 03 0A 00 0A FF 5B 81 41 10 45 43  .ECOR.....[.A.EC
  6140: 4F 52 11 45 43 30 30 08 45 43 30 31 08 45 43 30  OR.EC00.EC01.EC0
  6150: 32 08 45 43 30 33 08 45 43 30 34 08 45 43 30 35  2.EC03.EC04.EC05
  6160: 08 45 43 30 36 08 45 43 30 37 08 45 43 30 38 08  .EC06.EC07.EC08.
  6170: 45 43 30 39 08 45 43 31 30 08 45 43 31 31 08 45  EC09.EC10.EC11.E
  6180: 43 31 32 08 45 43 31 33 08 45 43 31 34 08 45 43  C12.EC13.EC14.EC
  6190: 31 35 08 45 43 31 36 08 45 43 31 37 08 45 43 31  15.EC16.EC17.EC1
  61A0: 38 08 45 43 31 39 08 45 43 32 30 08 45 43 32 31  8.EC19.EC20.EC21
  61B0: 08 45 43 32 32 08 45 43 32 33 08 45 43 32 34 08  .EC22.EC23.EC24.
  61C0: 45 43 32 35 08 45 43 32 36 08 45 43 32 37 08 45  EC25.EC26.EC27.E
  61D0: 43 32 38 08 45 43 32 39 08 45 43 33 30 08 45 43  C28.EC29.EC30.EC
  61E0: 33 31 08 45 43 33 32 08 45 43 33 33 08 45 43 33  31.EC32.EC33.EC3
  61F0: 34 08 45 43 33 35 08 45 43 33 36 08 45 43 33 37  4.EC35.EC36.EC37
  6200: 08 45 43 33 38 08 45 43 33 39 08 45 43 34 30 08  .EC38.EC39.EC40.
  6210: 45 43 34 31 08 45 43 34 32 08 45 43 34 33 08 45  EC41.EC42.EC43.E
  6220: 43 34 34 08 45 43 34 35 08 45 43 34 36 08 45 43  C44.EC45.EC46.EC
  6230: 34 37 08 45 43 34 38 08 45 43 34 39 08 14 12 45  47.EC48.EC49...E
  6240: 43 49 4E 00 45 43 53 33 45 43 53 32 41 43 4F 53  CIN.ECS3ECS2ACOS
  6250: 14 1D 5F 52 45 47 02 A0 16 90 93 68 0A 03 93 69  .._REG.....h...i
  6260: 0A 01 45 43 49 4E 70 0A 01 5C 45 43 52 44 14 0A  ..ECINp..\ECRD..
  6270: 45 43 4D 39 02 45 43 49 4E 14 1A 5F 51 36 36 00  ECM9.ECIN.._Q66.
  6280: A0 0C 92 93 5C 45 43 52 44 0A 01 A4 00 5C 4E 45  ....\ECRD....\NE
  6290: 56 54 A4 00 14 4C 28 45 43 52 31 01 A0 16 93 5C  VT...L(ECR1....\
  62A0: 45 43 52 44 0A 00 70 45 49 53 43 0A 80 68 0A 00  ECRD..pEISC..h..
  62B0: 60 A4 60 5B 23 5C 45 43 4D 58 FF FF 70 0A 00 60  `.`[#\ECMX..p..`
  62C0: A0 0B 93 68 0A 00 70 45 43 30 30 60 A0 0B 93 68  ...h..pEC00`...h
  62D0: 0A 01 70 45 43 30 31 60 A0 0B 93 68 0A 02 70 45  ..pEC01`...h..pE
  62E0: 43 30 32 60 A0 0B 93 68 0A 03 70 45 43 30 33 60  C02`...h..pEC03`
  62F0: A0 0B 93 68 0A 04 70 45 43 30 34 60 A0 0B 93 68  ...h..pEC04`...h
  6300: 0A 05 70 45 43 30 35 60 A0 0B 93 68 0A 06 70 45  ..pEC05`...h..pE
  6310: 43 30 36 60 A0 0B 93 68 0A 07 70 45 43 30 37 60  C06`...h..pEC07`
  6320: A0 0B 93 68 0A 08 70 45 43 30 38 60 A0 0B 93 68  ...h..pEC08`...h
  6330: 0A 09 70 45 43 30 39 60 A0 0B 93 68 0A 0A 70 45  ..pEC09`...h..pE
  6340: 43 31 30 60 A0 0B 93 68 0A 0B 70 45 43 31 31 60  C10`...h..pEC11`
  6350: A0 0B 93 68 0A 0C 70 45 43 31 32 60 A0 0B 93 68  ...h..pEC12`...h
  6360: 0A 0D 70 45 43 31 33 60 A0 0B 93 68 0A 0E 70 45  ..pEC13`...h..pE
  6370: 43 31 34 60 A0 0B 93 68 0A 0F 70 45 43 31 35 60  C14`...h..pEC15`
  6380: A0 0B 93 68 0A 10 70 45 43 31 36 60 A0 0B 93 68  ...h..pEC16`...h
  6390: 0A 11 70 45 43 31 37 60 A0 0B 93 68 0A 12 70 45  ..pEC17`...h..pE
  63A0: 43 31 38 60 A0 0B 93 68 0A 13 70 45 43 31 39 60  C18`...h..pEC19`
  63B0: A0 0B 93 68 0A 14 70 45 43 32 30 60 A0 0B 93 68  ...h..pEC20`...h
  63C0: 0A 15 70 45 43 32 31 60 A0 0B 93 68 0A 16 70 45  ..pEC21`...h..pE
  63D0: 43 32 32 60 A0 0B 93 68 0A 17 70 45 43 32 33 60  C22`...h..pEC23`
  63E0: A0 0B 93 68 0A 18 70 45 43 32 34 60 A0 0B 93 68  ...h..pEC24`...h
  63F0: 0A 19 70 45 43 32 35 60 A0 0B 93 68 0A 1A 70 45  ..pEC25`...h..pE
  6400: 43 32 36 60 A0 0B 93 68 0A 1B 70 45 43 32 37 60  C26`...h..pEC27`
  6410: A0 0B 93 68 0A 1C 70 45 43 32 38 60 A0 0B 93 68  ...h..pEC28`...h
  6420: 0A 1D 70 45 43 32 39 60 A0 0B 93 68 0A 1E 70 45  ..pEC29`...h..pE
  6430: 43 33 30 60 A0 0B 93 68 0A 1F 70 45 43 33 31 60  C30`...h..pEC31`
  6440: A0 0B 93 68 0A 20 70 45 43 33 32 60 A0 0B 93 68  ...h. pEC32`...h
  6450: 0A 21 70 45 43 33 33 60 A0 0B 93 68 0A 22 70 45  .!pEC33`...h."pE
  6460: 43 33 34 60 A0 0B 93 68 0A 23 70 45 43 33 35 60  C34`...h.#pEC35`
  6470: A0 0B 93 68 0A 24 70 45 43 33 36 60 A0 0B 93 68  ...h.$pEC36`...h
  6480: 0A 25 70 45 43 33 37 60 A0 0B 93 68 0A 26 70 45  .%pEC37`...h.&pE
  6490: 43 33 38 60 A0 0B 93 68 0A 27 70 45 43 33 39 60  C38`...h.'pEC39`
  64A0: A0 0B 93 68 0A 28 70 45 43 34 30 60 A0 0B 93 68  ...h.(pEC40`...h
  64B0: 0A 29 70 45 43 34 31 60 A0 0B 93 68 0A 2A 70 45  .)pEC41`...h.*pE
  64C0: 43 34 32 60 A0 0B 93 68 0A 2B 70 45 43 34 33 60  C42`...h.+pEC43`
  64D0: A0 0B 93 68 0A 2C 70 45 43 34 34 60 A0 0B 93 68  ...h.,pEC44`...h
  64E0: 0A 2D 70 45 43 34 35 60 A0 0B 93 68 0A 2E 70 45  .-pEC45`...h..pE
  64F0: 43 34 36 60 A0 0B 93 68 0A 2F 70 45 43 34 37 60  C46`...h./pEC47`
  6500: A0 0B 93 68 0A 30 70 45 43 34 38 60 A0 0B 93 68  ...h.0pEC48`...h
  6510: 0A 31 70 45 43 34 39 60 5B 27 5C 45 43 4D 58 A4  .1pEC49`['\ECMX.
  6520: 60 14 45 04 45 43 52 32 01 70 5C 2F 05 5F 53 42  `.E.ECR2.p\/._SB
  6530: 5F 50 43 49 30 4C 50 43 42 45 43 44 56 45 43 52  _PCI0LPCBECDVECR
  6540: 31 68 60 75 68 79 5C 2F 05 5F 53 42 5F 50 43 49  1h`uhy\/._SB_PCI
  6550: 30 4C 50 43 42 45 43 44 56 45 43 52 31 68 0A 08  0LPCBECDVECR1h..
  6560: 61 72 61 60 60 A4 60 14 49 0C 45 43 57 31 02 A0  ara``.`.I.ECW1..
  6570: 13 93 5C 45 43 52 44 0A 00 45 49 53 43 0A 81 68  ..\ECRD..EISC..h
  6580: 69 A4 00 5B 23 5C 45 43 4D 58 FF FF A0 0B 93 68  i..[#\ECMX.....h
  6590: 0A 00 70 69 45 43 30 30 A0 0B 93 68 0A 01 70 69  ..piEC00...h..pi
  65A0: 45 43 30 31 A0 0B 93 68 0A 02 70 69 45 43 30 32  EC01...h..piEC02
  65B0: A0 0B 93 68 0A 03 70 69 45 43 30 33 A0 0B 93 68  ...h..piEC03...h
  65C0: 0A 04 70 69 45 43 30 34 A0 0B 93 68 0A 05 70 69  ..piEC04...h..pi
  65D0: 45 43 30 35 A0 0B 93 68 0A 06 70 69 45 43 30 36  EC05...h..piEC06
  65E0: A0 0B 93 68 0A 07 70 69 45 43 30 37 A0 0B 93 68  ...h..piEC07...h
  65F0: 0A 08 70 69 45 43 30 38 A0 0B 93 68 0A 09 70 69  ..piEC08...h..pi
  6600: 45 43 30 39 A0 0B 93 68 0A 0A 70 69 45 43 31 30  EC09...h..piEC10
  6610: A0 0B 93 68 0A 0B 70 69 45 43 31 31 A0 0B 93 68  ...h..piEC11...h
  6620: 0A 0C 70 69 45 43 31 32 5B 27 5C 45 43 4D 58 A4  ..piEC12['\ECMX.
  6630: 00 10 4A 51 5C 00 08 45 43 52 44 0A 00 5B 01 45  ..JQ\..ECRD..[.E
  6640: 43 4D 58 01 5B 01 45 43 53 58 01 14 4D 06 45 49  CMX.[.ECSX..M.EI
  6650: 53 43 03 5B 23 45 43 53 58 FF FF 08 45 43 49 42  SC.[#ECSX...ECIB
  6660: 11 03 0A 04 8C 45 43 49 42 0A 00 45 43 49 43 8C  .....ECIB..ECIC.
  6670: 45 43 49 42 0A 01 45 43 50 31 8C 45 43 49 42 0A  ECIB..ECP1.ECIB.
  6680: 02 45 43 50 32 70 68 45 43 49 43 70 69 45 43 50  .ECP2phECICpiECP
  6690: 31 70 6A 45 43 50 32 70 47 45 4E 53 0A 08 45 43  1pjECP2pGENS..EC
  66A0: 49 42 87 45 43 49 42 45 43 49 42 70 45 43 49 43  IB.ECIBECIBpECIC
  66B0: 60 5B 27 45 43 53 58 A4 60 14 2D 45 43 42 54 02  `['ECSX.`.-ECBT.
  66C0: 70 5C 2F 05 5F 53 42 5F 50 43 49 30 4C 50 43 42  p\/._SB_PCI0LPCB
  66D0: 45 43 44 56 45 43 52 31 68 60 7B 60 69 60 A0 05  ECDVECR1h`{`i`..
  66E0: 60 A4 0A 01 A4 0A 00 14 17 45 43 42 31 02 70 45  `........ECB1.pE
  66F0: 43 42 54 68 69 60 A0 05 60 A4 0A 00 A4 0A 01 14  CBThi`..`.......
  6700: 1F 45 43 52 42 01 A4 5C 2F 05 5F 53 42 5F 50 43  .ECRB..\/._SB_PC
  6710: 49 30 4C 50 43 42 45 43 44 56 45 43 52 31 68 14  I0LPCBECDVECR1h.
  6720: 1F 45 43 52 57 01 A4 5C 2F 05 5F 53 42 5F 50 43  .ECRW..\/._SB_PC
  6730: 49 30 4C 50 43 42 45 43 44 56 45 43 52 32 68 14  I0LPCBECDVECR2h.
  6740: 1F 45 43 57 42 02 5C 2F 05 5F 53 42 5F 50 43 49  .ECWB.\/._SB_PCI
  6750: 30 4C 50 43 42 45 43 44 56 45 43 57 31 68 69 14  0LPCBECDVECW1hi.
  6760: 0D 45 43 47 31 00 A4 45 43 52 57 0A 07 14 0F 45  .ECG1..ECRW....E
  6770: 43 47 32 00 A4 45 43 42 54 0A 00 0A 01 14 0F 45  CG2..ECBT......E
  6780: 43 47 33 00 A4 45 43 42 54 0A 00 0A 10 14 0F 45  CG3..ECBT......E
  6790: 43 47 34 00 A4 45 43 42 54 0A 05 0A 04 14 10 45  CG4..ECBT......E
  67A0: 43 47 35 00 70 45 43 52 42 0A 06 60 A4 60 14 10  CG5.pECRB..`.`..
  67B0: 45 43 47 37 00 70 45 43 52 42 0A 09 60 A4 60 5B  ECG7.pECRB..`.`[
  67C0: 01 45 43 4D 31 01 14 41 09 45 43 47 36 02 5B 23  .ECM1..A.ECG6.[#
  67D0: 45 43 4D 31 FF FF 70 45 43 47 32 62 45 43 57 42  ECM1..pECG2bECWB
  67E0: 0A 03 68 70 45 43 52 42 0A 10 88 69 0A 00 00 70  ..hpECRB...i...p
  67F0: 45 43 52 57 0A 12 60 A0 07 93 60 0A 00 75 60 A1  ECRW..`...`..u`.
  6800: 2D A0 11 92 93 62 0A 00 A0 0A 7B 60 0B 00 80 00  -....b....{`....
  6810: 70 FF 60 A1 19 A0 12 7B 60 0B 00 80 00 74 0A 00  p.`....{`....t..
  6820: 60 60 7B 60 0B FF FF 60 A1 04 70 FF 60 70 60 88  ``{`...`..p.`p`.
  6830: 69 0A 01 00 70 45 43 52 57 0A 16 60 70 60 88 69  i...pECRW..`p`.i
  6840: 0A 02 00 70 45 43 52 57 0A 14 60 70 60 88 69 0A  ...pECRW..`p`.i.
  6850: 03 00 5B 27 45 43 4D 31 14 46 06 45 43 4D 38 01  ..['ECM1.F.ECM8.
  6860: 45 43 57 42 0A 04 68 08 4C 42 55 46 11 03 0A 21  ECWB..h.LBUF...!
  6870: 70 0A 00 60 A2 1F 95 60 0A 20 70 45 43 52 42 0A  p..`...`. pECRB.
  6880: 2A 61 70 61 88 4C 42 55 46 60 00 A0 06 93 61 0A  *apa.LBUF`....a.
  6890: 00 A5 75 60 A0 12 92 93 61 0A 00 70 0A 00 88 4C  ..u`....a..p...L
  68A0: 42 55 46 60 00 75 60 75 60 08 4F 42 55 46 11 02  BUF`.u`u`.OBUF..
  68B0: 60 70 4C 42 55 46 4F 42 55 46 A4 4F 42 55 46 08  `pLBUFOBUF.OBUF.
  68C0: 42 53 30 31 12 0F 03 0A 01 0A FF 0D 55 6E 6B 6E  BS01........Unkn
  68D0: 6F 77 6E 00 08 42 53 30 32 12 40 05 0F 0A 03 0A  own..BS02.@.....
  68E0: 02 0D 53 6F 6E 79 00 0A 03 0D 53 61 6E 79 6F 00  ..Sony....Sanyo.
  68F0: 0A 04 0D 50 61 6E 61 73 6F 6E 69 63 00 0A 07 0D  ...Panasonic....
  6900: 53 4D 50 00 0A 08 0D 4D 6F 74 6F 72 6F 6C 61 00  SMP....Motorola.
  6910: 0A 06 0D 53 61 6D 73 75 6E 67 20 53 44 49 00 0A  ...Samsung SDI..
  6920: FF 0D 55 6E 6B 6E 6F 77 6E 00 08 42 53 30 33 12  ..Unknown..BS03.
  6930: 4E 04 13 0A 02 0A 01 0D 50 62 41 63 00 0A 02 0D  N.......PbAc....
  6940: 4C 49 4F 4E 00 0A 03 0D 4E 69 43 64 00 0A 04 0D  LION....NiCd....
  6950: 4E 69 4D 48 00 0A 05 0D 4E 69 5A 6E 00 0A 06 0D  NiMH....NiZn....
  6960: 52 41 4D 00 0A 07 0D 5A 6E 41 52 00 0A 08 0D 4C  RAM....ZnAR....L
  6970: 69 50 00 0A FF 0D 55 6E 6B 6E 6F 77 6E 00 14 4A  iP....Unknown..J
  6980: 04 45 43 55 30 02 70 0A 01 60 70 0A 00 61 A2 29  .ECU0.p..`p..a.)
  6990: 92 93 61 0A FF 70 83 88 68 60 00 61 A0 16 93 69  ..a..p..h`.a...i
  69A0: 61 75 60 70 83 88 68 60 00 62 70 58 50 54 42 62  au`p..h`.bpXPTBb
  69B0: 62 A4 62 72 60 0A 02 60 70 83 88 68 0A 00 00 62  b.br`..`p..h...b
  69C0: 70 45 43 4D 38 62 62 A4 62 14 44 0E 45 43 47 39  pECM8bb.b.D.ECG9
  69D0: 02 5B 23 45 43 4D 31 FF FF 45 43 57 42 0A 03 68  .[#ECM1..ECWB..h
  69E0: 70 0A 01 88 69 0A 00 00 70 45 43 52 57 0A 20 60  p...i...pECRW. `
  69F0: 70 60 88 69 0A 01 00 70 45 43 52 57 0A 1E 61 70  p`.i...pECRW..ap
  6A00: 61 88 69 0A 02 00 70 0A 01 88 69 0A 03 00 70 45  a.i...p...i...pE
  6A10: 43 52 57 0A 22 62 70 62 88 69 0A 04 00 78 60 0A  CRW."bpb.i...x`.
  6A20: 0A 65 63 70 63 88 69 0A 05 00 78 60 0A 21 65 63  .ecpc.i...x`.!ec
  6A30: 70 63 88 69 0A 06 00 78 60 0A 64 65 63 70 63 88  pc.i...x`.decpc.
  6A40: 69 0A 07 00 70 63 88 69 0A 08 00 70 45 43 55 30  i...pc.i...pECU0
  6A50: 42 53 30 31 0A 00 63 70 63 88 69 0A 09 00 70 45  BS01..cpc.i...pE
  6A60: 43 52 57 0A 26 63 70 58 50 54 53 63 63 70 63 88  CRW.&cpXPTSccpc.
  6A70: 69 0A 0A 00 70 45 43 52 42 0A 29 63 70 45 43 55  i...pECRB.)cpECU
  6A80: 30 42 53 30 33 63 63 70 63 88 69 0A 0B 00 70 45  0BS03ccpc.i...pE
  6A90: 43 52 42 0A 28 63 70 45 43 55 30 42 53 30 32 63  CRB.(cpECU0BS02c
  6AA0: 63 70 63 88 69 0A 0C 00 5B 27 45 43 4D 31 14 10  cpc.i...['ECM1..
  6AB0: 45 43 47 41 00 70 45 43 52 42 0A 2F 60 A4 60 14  ECGA.pECRB./`.`.
  6AC0: 0D 45 43 53 31 02 45 43 57 42 0A 02 68 14 0D 45  .ECS1.ECWB..h..E
  6AD0: 43 53 32 01 45 43 57 42 0A 01 68 14 0E 45 43 53  CS2.ECWB..h..ECS
  6AE0: 33 00 45 43 57 42 0A 05 0A 01 5B 01 51 53 45 56  3.ECWB....[.QSEV
  6AF0: 01 14 3E 45 43 30 41 01 5B 23 51 53 45 56 FF FF  ..>EC0A.[#QSEV..
  6B00: 70 45 43 52 42 0A 2B 61 70 0A 00 60 A2 1B 95 60  pECRB.+ap..`...`
  6B10: 61 70 45 43 52 42 0A 2C 62 A0 0C 95 60 87 68 42  apECRB.,b...`.hB
  6B20: 42 57 52 68 60 62 75 60 5B 27 51 53 45 56 A4 68  BWRh`bu`['QSEV.h
  6B30: 14 0D 45 43 53 34 01 45 43 57 42 0A 11 68 14 0D  ..ECS4.ECWB..h..
  6B40: 45 43 53 35 01 45 43 57 42 0A 10 68 14 49 0D 4E  ECS5.ECWB..h.I.N
  6B50: 45 56 54 00 70 45 43 47 31 60 A0 0F 7B 60 0A 01  EVT.pECG1`..{`..
  6B60: 00 5C 45 56 36 5F 0A 01 0A 00 A0 0F 7B 60 0A 40  .\EV6_......{`.@
  6B70: 00 5C 45 56 36 5F 0A 02 0A 00 A0 14 7B 60 0A 04  .\EV6_......{`..
  6B80: 00 70 45 43 47 33 61 5C 45 56 36 5F 0A 03 61 A0  .pECG3a\EV6_..a.
  6B90: 1F 7B 60 0A 10 00 70 45 43 42 54 0A 00 0A 80 61  .{`...pECBT....a
  6BA0: 70 45 43 52 42 0A 2D 62 5C 45 56 37 5F 61 62 A0  pECRB.-b\EV7_ab.
  6BB0: 11 7B 60 0B 00 01 00 5C 45 56 38 5F 0B 00 01 0A  .{`....\EV8_....
  6BC0: 00 A0 11 7B 60 0B 00 02 00 5C 45 56 38 5F 0B 00  ...{`....\EV8_..
  6BD0: 02 0A 00 A0 11 7B 60 0B 00 04 00 5C 45 56 38 5F  .....{`....\EV8_
  6BE0: 0B 00 04 0A 00 A0 11 7B 60 0B 00 08 00 5C 45 56  .......{`....\EV
  6BF0: 38 5F 0B 00 08 0A 00 A0 18 7B 60 0B 00 80 00 70  8_.......{`....p
  6C00: 45 43 52 42 0A 2E 61 5C 45 56 39 5F 0B 00 80 61  ECRB..a\EV9_...a
  6C10: A0 0A 7B 60 0A 08 00 50 57 52 45 A0 0A 7B 60 0A  ..{`...PWRE..{`.
  6C20: 80 00 53 4D 49 45 14 4C 0C 50 57 52 45 00 70 45  ..SMIE.L.PWRE.pE
  6C30: 43 47 35 60 7F 60 41 50 52 45 61 7B 60 7D 0A 01  CG5`.`APREa{`}..
  6C40: 7D 0A 02 0A 10 00 00 41 50 52 45 A0 0F 7B 61 0A  }......APRE..{a.
  6C50: 01 00 5C 45 56 31 30 0A 00 0A 00 7B 41 50 52 45  ..\EV10....{APRE
  6C60: 0A 02 62 A0 1D 7B 61 0A 02 00 A0 0B 62 5C 45 56  ..b..{a.....b\EV
  6C70: 31 31 0A 01 0A 00 A1 0A 5C 45 56 31 31 0A 02 0A  11......\EV11...
  6C80: 00 A0 12 7B 61 0A 04 00 A0 0B 62 5C 45 56 31 31  ...{a.....b\EV11
  6C90: 0A 04 0A 00 A0 12 7B 61 0A 08 00 A0 0B 62 5C 45  ......{a.....b\E
  6CA0: 56 31 31 0A 04 0A 00 7B 41 50 52 45 0A 10 62 A0  V11....{APRE..b.
  6CB0: 1D 7B 61 0A 10 00 A0 0B 62 5C 45 56 31 31 0A 01  .{a.....b\EV11..
  6CC0: 0A 01 A1 0A 5C 45 56 31 31 0A 02 0A 01 A0 12 7B  ....\EV11......{
  6CD0: 61 0A 20 00 A0 0B 62 5C 45 56 31 31 0A 04 0A 01  a. ...b\EV11....
  6CE0: A0 12 7B 61 0A 40 00 A0 0B 62 5C 45 56 31 31 0A  ..{a.@...b\EV11.
  6CF0: 04 0A 01 14 46 04 53 4D 45 45 01 70 68 60 70 47  ....F.SMEE.ph`pG
  6D00: 45 4E 53 0A 11 0A 00 0A 00 60 A0 2F 92 95 5C 2E  ENS......`./..\.
  6D10: 5F 53 42 5F 4F 53 49 44 0A 20 A0 0F 7B 60 0A 04  _SB_OSID. ..{`..
  6D20: 00 5C 45 56 31 32 0A 01 0A 00 A0 0F 7B 60 0A 02  .\EV12......{`..
  6D30: 00 5C 45 56 31 32 0A 02 0A 00 14 4F 06 53 4D 49  .\EV12.....O.SMI
  6D40: 45 00 70 47 45 4E 53 0A 10 0A 00 0A 00 60 A0 0B  E.pGENS......`..
  6D50: 7B 60 0A 04 00 53 4D 45 45 60 A0 0F 7B 60 0A 02  {`...SMEE`..{`..
  6D60: 00 5C 45 56 31 33 0A 00 0A 00 A0 0F 7B 60 0A 08  .\EV13......{`..
  6D70: 00 5C 45 56 34 5F 0A 00 0A 00 A0 0F 7B 60 0A 40  .\EV4_......{`.@
  6D80: 00 5C 45 56 31 34 0A 00 0A 00 A0 0F 7B 60 0A 80  .\EV14......{`..
  6D90: 00 5C 45 56 31 35 0A 00 0A 00 A0 0F 7B 60 0A 10  .\EV15......{`..
  6DA0: 00 5C 45 56 33 5F 0A 00 0A 00 10 39 5C 2F 03 5F  .\EV3_.....9\/._
  6DB0: 53 42 5F 50 43 49 30 4C 50 43 42 14 28 45 49 4E  SB_PCI0LPCB.(EIN
  6DC0: 49 02 A0 21 93 68 0A 02 70 45 43 47 35 41 50 52  I..!.h..pECG5APR
  6DD0: 45 7B 41 50 52 45 7D 0A 01 7D 0A 02 0A 10 00 00  E{APRE}..}......
  6DE0: 41 50 52 45 10 49 05 5C 5F 47 50 45 14 41 05 5F  APRE.I.\_GPE.A._
  6DF0: 4C 31 46 00 70 45 43 47 37 60 A0 14 7B 60 0A 02  L1F.pECG7`..{`..
  6E00: 00 70 45 43 47 33 61 5C 45 56 36 5F 0A 03 61 70  .pECG3a\EV6_..ap
  6E10: 0A 00 61 A0 09 93 60 0A 00 70 0A 01 61 A0 0A 7B  ..a...`..p..a..{
  6E20: 60 0A 01 00 70 0A 01 61 A0 09 93 60 0A 04 70 0A  `...p..a...`..p.
  6E30: 01 61 A0 0B 61 5C 45 56 36 5F 0A 01 0A 01 10 4A  .a..a\EV6_.....J
  6E40: 39 5C 5F 53 42 5F 5B 01 45 43 41 58 01 14 4C 05  9\_SB_[.ECAX..L.
  6E50: 45 45 41 43 02 5B 23 45 43 41 58 FF FF 08 45 41  EEAC.[#ECAX...EA
  6E60: 42 46 11 03 0A 08 8A 45 41 42 46 0A 00 45 43 53  BF.....EABF..ECS
  6E70: 54 8A 45 41 42 46 0A 04 45 43 50 41 70 68 45 43  T.EABF..ECPAphEC
  6E80: 53 54 70 69 45 43 50 41 70 47 45 4E 53 0A 07 45  STpiECPApGENS..E
  6E90: 41 42 46 87 45 41 42 46 45 41 42 46 70 45 43 53  ABF.EABFEABFpECS
  6EA0: 54 60 5B 27 45 43 41 58 A4 60 10 40 0F 5C 5F 53  T`['ECAX.`.@.\_S
  6EB0: 42 5F 14 2B 50 50 52 57 00 08 45 50 52 57 12 06  B_.+PPRW..EPRW..
  6EC0: 02 0A 00 0A 03 70 45 45 41 43 0A 03 0A 00 60 70  .....pEEAC....`p
  6ED0: 60 88 45 50 52 57 0A 00 00 A4 45 50 52 57 5B 82  `.EPRW....EPRW[.
  6EE0: 38 4C 49 44 5F 08 5F 48 49 44 0C 41 D0 0C 0D 14  8LID_._HID.A....
  6EF0: 0E 5F 4C 49 44 00 70 45 43 47 33 60 A4 60 14 0B  ._LID.pECG3`.`..
  6F00: 5F 50 52 57 00 A4 50 50 52 57 14 0D 5F 50 53 57  _PRW..PPRW.._PSW
  6F10: 01 45 45 41 43 0A 02 68 5B 82 29 50 42 54 4E 08  .EEAC..h[.)PBTN.
  6F20: 5F 48 49 44 0C 41 D0 0C 0C 14 0B 5F 50 52 57 00  _HID.A....._PRW.
  6F30: A4 50 50 52 57 14 0D 5F 50 53 57 01 45 45 41 43  .PPRW.._PSW.EEAC
  6F40: 0A 01 68 5B 82 0F 53 42 54 4E 08 5F 48 49 44 0C  ..h[..SBTN._HID.
  6F50: 41 D0 0C 0E 14 46 04 42 54 4E 56 02 A0 2B 93 68  A....F.BTNV..+.h
  6F60: 0A 01 A0 12 93 69 0A 00 86 5C 2E 5F 53 42 5F 50  .....i...\._SB_P
  6F70: 42 54 4E 0A 80 A0 12 93 69 0A 01 86 5C 2E 5F 53  BTN.....i...\._S
  6F80: 42 5F 50 42 54 4E 0A 02 A0 12 93 68 0A 02 86 5C  B_PBTN.....h...\
  6F90: 2E 5F 53 42 5F 53 42 54 4E 0A 80 5B 82 4B 04 41  ._SB_SBTN..[.K.A
  6FA0: 43 5F 5F 08 5F 48 49 44 0D 41 43 50 49 30 30 30  C__._HID.ACPI000
  6FB0: 33 00 14 17 5F 50 43 4C 00 A4 12 0F 03 5C 5F 53  3..._PCL.....\_S
  6FC0: 42 5F 42 41 54 30 42 41 54 31 14 13 5F 50 53 52  B_BAT0BAT1.._PSR
  6FD0: 00 70 45 43 47 35 60 7B 60 0A 01 60 A4 60 14 09  .pECG5`{`..`.`..
  6FE0: 5F 53 54 41 00 A4 0A 0F 14 13 41 43 45 56 02 86  _STA......ACEV..
  6FF0: 5C 2E 5F 53 42 5F 41 43 5F 5F 0A 80 5B 82 4B 07  \._SB_AC__..[.K.
  7000: 42 41 54 30 08 5F 48 49 44 0C 41 D0 0C 0A 08 5F  BAT0._HID.A...._
  7010: 55 49 44 0A 01 08 5F 50 43 4C 12 07 01 5C 5F 53  UID..._PCL...\_S
  7020: 42 5F 14 1A 5F 53 54 41 00 70 45 43 47 35 60 7B  B_.._STA.pECG5`{
  7030: 60 0A 02 60 A0 05 60 A4 0A 1F A4 0A 0F 14 1D 5F  `..`..`........_
  7040: 42 49 46 00 08 42 49 46 30 12 02 0D 45 43 47 39  BIF..BIF0...ECG9
  7050: 0A 01 42 49 46 30 A4 42 49 46 30 14 1D 5F 42 53  ..BIF0.BIF0.._BS
  7060: 54 00 08 42 53 54 30 12 02 04 45 43 47 36 0A 01  T..BST0...ECG6..
  7070: 42 53 54 30 A4 42 53 54 30 5B 82 4E 08 42 41 54  BST0.BST0[.N.BAT
  7080: 31 08 5F 48 49 44 0C 41 D0 0C 0A 08 5F 55 49 44  1._HID.A...._UID
  7090: 0A 02 08 5F 50 43 4C 12 07 01 5C 5F 53 42 5F 14  ..._PCL...\_SB_.
  70A0: 2D 5F 53 54 41 00 70 45 45 41 43 0A 05 0A 00 60  -_STA.pEEAC....`
  70B0: A0 08 95 60 0A 02 A4 0A 00 70 45 43 47 35 60 7B  ...`.....pECG5`{
  70C0: 60 0A 10 60 A0 05 60 A4 0A 1F A4 0A 0F 14 1D 5F  `..`..`........_
  70D0: 42 49 46 00 08 42 49 46 31 12 02 0D 45 43 47 39  BIF..BIF1...ECG9
  70E0: 0A 02 42 49 46 31 A4 42 49 46 31 14 1D 5F 42 53  ..BIF1.BIF1.._BS
  70F0: 54 00 08 42 53 54 31 12 02 04 45 43 47 36 0A 02  T..BST1...ECG6..
  7100: 42 53 54 31 A4 42 53 54 31 14 47 0A 42 54 45 56  BST1.BST1.G.BTEV
  7110: 02 A0 27 93 68 0A 01 A0 12 93 69 0A 00 86 5C 2E  ..'.h.....i...\.
  7120: 5F 53 42 5F 42 41 54 30 0A 81 A1 0E 86 5C 2E 5F  _SB_BAT0.....\._
  7130: 53 42 5F 42 41 54 31 0A 81 A0 27 93 68 0A 02 A0  SB_BAT1...'.h...
  7140: 12 93 69 0A 00 86 5C 2E 5F 53 42 5F 42 41 54 30  ..i...\._SB_BAT0
  7150: 0A 81 A1 0E 86 5C 2E 5F 53 42 5F 42 41 54 31 0A  .....\._SB_BAT1.
  7160: 81 A0 27 93 68 0A 03 A0 12 93 69 0A 00 86 5C 2E  ..'.h.....i...\.
  7170: 5F 53 42 5F 42 41 54 30 0A 80 A1 0E 86 5C 2E 5F  _SB_BAT0.....\._
  7180: 53 42 5F 42 41 54 31 0A 80 A0 27 93 68 0A 04 A0  SB_BAT1...'.h...
  7190: 12 93 69 0A 00 86 5C 2E 5F 53 42 5F 42 41 54 30  ..i...\._SB_BAT0
  71A0: 0A 80 A1 0E 86 5C 2E 5F 53 42 5F 42 41 54 31 0A  .....\._SB_BAT1.
  71B0: 80 10 27 5C 5F 53 42 5F 14 20 43 42 41 54 02 86  ..'\_SB_. CBAT..
  71C0: 5C 2E 5F 53 42 5F 42 41 54 30 0A 81 86 5C 2E 5F  \._SB_BAT0...\._
  71D0: 53 42 5F 42 41 54 31 0A 81 10 40 09 5C 2F 03 5F  SB_BAT1...@.\/._
  71E0: 53 42 5F 50 43 49 30 4C 50 43 42 5B 82 4D 07 53  SB_PCI0LPCB[.M.S
  71F0: 49 4F 42 08 5F 48 49 44 0C 41 D0 0A 05 08 5F 55  IOB._HID.A...._U
  7200: 49 44 0A 03 5B 80 53 49 4F 42 01 5C 49 4F 50 42  ID..[.SIOB.\IOPB
  7210: 0A 02 5B 81 10 53 49 4F 42 11 49 4E 44 58 08 44  ..[..SIOB.INDX.D
  7220: 41 54 41 08 5B 86 44 04 49 4E 44 58 44 41 54 41  ATA.[.D.INDXDATA
  7230: 11 00 38 53 52 30 37 08 00 40 0D 53 52 32 32 08  ..8SR07..@.SR22.
  7240: 53 52 32 33 08 00 48 18 53 52 35 35 08 00 40 05  SR23..H.SR55..@.
  7250: 53 52 36 30 08 53 52 36 31 08 00 40 07 53 52 37  SR60.SR61..@.SR7
  7260: 30 08 00 48 1C 53 52 41 41 08 10 46 2A 5C 2F 04  0..H.SRAA..F*\/.
  7270: 5F 53 42 5F 50 43 49 30 4C 50 43 42 53 49 4F 42  _SB_PCI0LPCBSIOB
  7280: 5B 82 4F 28 44 49 47 43 08 5F 48 49 44 0C 41 D0  [.O(DIGC._HID.A.
  7290: 05 01 08 5F 55 49 44 0A 01 08 5F 50 52 57 12 06  ..._UID..._PRW..
  72A0: 02 0A 08 0A 03 14 4D 04 5F 53 54 41 08 08 44 49  ......M._STA..DI
  72B0: 47 33 11 03 0A 02 8C 44 49 47 33 0A 00 44 49 47  G3.....DIG3..DIG
  72C0: 31 8C 44 49 47 33 0A 01 44 49 47 32 70 0A 01 44  1.DIG3..DIG2p..D
  72D0: 49 47 31 70 47 45 4E 53 0A 14 44 49 47 33 87 44  IG1pGENS..DIG3.D
  72E0: 49 47 33 44 49 47 33 A0 08 44 49 47 32 A4 0A 0F  IG3DIG3..DIG2...
  72F0: A4 0A 00 14 21 5F 44 49 53 08 70 0A 00 53 52 35  ....!_DIS.p..SR5
  7300: 35 70 7B 53 52 32 32 0A EF 00 53 52 32 32 70 0A  5p{SR22...SR22p.
  7310: 00 53 52 41 41 14 4E 0B 5F 43 52 53 08 08 42 55  .SRAA.N._CRS..BU
  7320: 46 30 11 10 0A 0D 47 01 F8 02 F8 02 01 08 22 08  F0....G.......".
  7330: 00 79 00 8C 42 55 46 30 0A 02 49 4F 4C 30 8C 42  .y..BUF0..IOL0.B
  7340: 55 46 30 0A 03 49 4F 48 30 8C 42 55 46 30 0A 04  UF0..IOH0.BUF0..
  7350: 49 4F 4C 31 8C 42 55 46 30 0A 05 49 4F 48 31 8C  IOL1.BUF0..IOH1.
  7360: 42 55 46 30 0A 07 4C 45 4E 30 8B 42 55 46 30 0A  BUF0..LEN0.BUF0.
  7370: 09 49 52 51 57 70 0A 00 53 52 35 35 70 0A 04 53  .IRQWp..SR55p..S
  7380: 52 30 37 70 53 52 36 31 49 4F 4C 30 70 53 52 36  R07pSR61IOL0pSR6
  7390: 31 49 4F 4C 31 70 53 52 36 30 49 4F 48 30 70 53  1IOL1pSR60IOH0pS
  73A0: 52 36 30 49 4F 48 31 70 0A 08 4C 45 4E 30 7B 53  R60IOH1p..LEN0{S
  73B0: 52 37 30 0A 0F 60 A0 09 60 79 01 60 49 52 51 57  R70..`..`y.`IRQW
  73C0: A1 07 70 00 49 52 51 57 70 0A 00 53 52 41 41 A4  ..p.IRQWp..SRAA.
  73D0: 42 55 46 30 08 5F 50 52 53 11 48 04 0A 44 31 08  BUF0._PRS.H..D1.
  73E0: 47 01 F8 02 F8 02 01 08 22 08 00 31 08 47 01 F8  G......."..1.G..
  73F0: 03 F8 03 01 08 22 10 00 31 08 47 01 F8 03 F8 03  ....."..1.G.....
  7400: 01 08 22 F0 1C 31 08 47 01 E8 03 E8 03 01 08 22  .."..1.G......."
  7410: F0 1C 31 08 47 01 E8 02 E8 02 01 08 22 F0 1C 38  ..1.G......."..8
  7420: 79 00 14 4A 0A 5F 53 52 53 09 8C 68 0A 02 49 4F  y..J._SRS..h..IO
  7430: 4C 4F 8C 68 0A 03 49 4F 48 49 8B 68 0A 09 49 52  LO.h..IOHI.h..IR
  7440: 51 57 70 0A 00 53 52 35 35 70 0A 04 53 52 30 37  QWp..SR55p..SR07
  7450: 70 49 4F 4C 4F 53 52 36 31 70 49 4F 48 49 53 52  pIOLOSR61pIOHISR
  7460: 36 30 82 49 52 51 57 60 A0 0A 92 93 49 52 51 57  60.IRQW`....IRQW
  7470: 00 76 60 70 60 53 52 37 30 70 0A 00 53 52 41 41  .v`p`SR70p..SRAA
  7480: A0 29 93 49 4F 48 49 0A 03 A0 13 93 49 4F 4C 4F  .).IOHI.....IOLO
  7490: 0A F8 7B 49 4F 44 30 0A 8F 49 4F 44 30 A1 0C 7D  ..{IOD0..IOD0..}
  74A0: 49 4F 44 30 0A 70 49 4F 44 30 A1 22 A0 13 93 49  IOD0.pIOD0."...I
  74B0: 4F 4C 4F 0A F8 7D 49 4F 44 30 0A 10 49 4F 44 30  OLO..}IOD0..IOD0
  74C0: A1 0C 7D 49 4F 44 30 0A 50 49 4F 44 30 14 21 5F  ..}IOD0.PIOD0.!_
  74D0: 50 53 30 08 70 0A 00 53 52 35 35 70 7D 53 52 32  PS0.p..SR55p}SR2
  74E0: 32 0A 10 00 53 52 32 32 70 0A 00 53 52 41 41 14  2...SR22p..SRAA.
  74F0: 21 5F 50 53 33 08 70 0A 00 53 52 35 35 70 7B 53  !_PS3.p..SR55p{S
  7500: 52 32 32 0A EF 00 53 52 32 32 70 0A 00 53 52 41  R22...SR22p..SRA
  7510: 41 10 11 5C 00 08 44 43 4B 53 0A FF 08 44 43 4B  A..\..DCKS...DCK
  7520: 54 0A 00 10 48 0A 5C 2F 03 5F 53 42 5F 50 43 49  T...H.\/._SB_PCI
  7530: 30 4C 50 43 42 14 43 06 44 43 4B 33 00 A0 2D 5B  0LPCB.C.DCK3..-[
  7540: 12 5C 2F 04 5F 53 42 5F 50 43 49 30 4C 50 43 42  .\/._SB_PCI0LPCB
  7550: 4C 50 54 45 00 86 5C 2F 04 5F 53 42 5F 50 43 49  LPTE..\/._SB_PCI
  7560: 30 4C 50 43 42 4C 50 54 45 0A 01 A0 2D 5B 12 5C  0LPCBLPTE...-[.\
  7570: 2F 04 5F 53 42 5F 50 43 49 30 4C 50 43 42 55 41  /._SB_PCI0LPCBUA
  7580: 52 31 00 86 5C 2F 04 5F 53 42 5F 50 43 49 30 4C  R1..\/._SB_PCI0L
  7590: 50 43 42 55 41 52 31 0A 01 14 16 44 43 4B 34 02  PCBUAR1....DCK4.
  75A0: 70 68 44 43 4B 53 70 69 44 43 4B 54 44 43 4B 33  phDCKSpiDCKTDCK3
  75B0: 14 1B 44 43 4B 35 02 70 45 43 52 42 0A 2D 60 A0  ..DCK5.pECRB.-`.
  75C0: 0C 92 93 60 44 43 4B 54 44 43 4B 33 10 43 69 5C  ...`DCKTDCK3.Ci\
  75D0: 2F 03 5F 53 42 5F 50 43 49 30 4C 50 43 42 5B 80  /._SB_PCI0LPCB[.
  75E0: 4C 50 43 42 01 5C 53 50 32 4F 0A 02 5B 81 10 4C  LPCB.\SP2O..[..L
  75F0: 50 43 42 11 49 4E 44 58 08 44 41 54 41 08 5B 86  PCB.INDX.DATA.[.
  7600: 45 05 49 4E 44 58 44 41 54 41 11 00 08 43 52 30  E.INDXDATA...CR0
  7610: 31 08 43 52 30 32 08 00 48 04 43 52 30 43 08 00  1.CR02..H.CR0C..
  7620: 48 0A 43 52 32 32 08 43 52 32 33 08 43 52 32 34  H.CR22.CR23.CR24
  7630: 08 43 52 32 35 08 43 52 32 36 08 43 52 32 37 08  .CR25.CR26.CR27.
  7640: 43 52 32 38 08 00 40 16 43 52 35 35 08 00 40 2A  CR28..@.CR55..@*
  7650: 43 52 41 41 08 5B 82 42 2F 55 41 52 31 08 5F 48  CRAA.[.B/UAR1._H
  7660: 49 44 0C 41 D0 05 01 08 5F 55 49 44 0A 00 08 5F  ID.A...._UID..._
  7670: 50 52 57 12 06 02 0A 08 0A 03 14 42 08 5F 53 54  PRW........B._ST
  7680: 41 08 08 44 43 4B 39 11 03 0A 04 8C 44 43 4B 39  A..DCK9.....DCK9
  7690: 0A 00 44 43 4B 38 8C 44 43 4B 39 0A 01 44 43 4B  ..DCK8.DCK9..DCK
  76A0: 36 8C 44 43 4B 39 0A 02 44 43 4B 32 8C 44 43 4B  6.DCK9..DCK2.DCK
  76B0: 39 0A 03 44 43 4B 37 70 0A 01 44 43 4B 38 70 47  9..DCK7p..DCK8pG
  76C0: 45 4E 53 0A 13 44 43 4B 39 87 44 43 4B 39 60 70  ENS..DCK9.DCK9`p
  76D0: 60 44 43 4B 39 A0 24 90 93 44 43 4B 36 0A 01 93  `DCK9.$..DCK6...
  76E0: 44 43 4B 37 0A 01 A0 13 91 93 44 43 4B 32 0A 01  DCK7......DCK2..
  76F0: 93 44 43 4B 32 0A 04 A4 0A 0F A4 0A 00 14 21 5F  .DCK2.........!_
  7700: 44 49 53 08 70 0A 00 43 52 35 35 70 7B 43 52 30  DIS.p..CR55p{CR0
  7710: 32 0A F0 00 43 52 30 32 70 0A 00 43 52 41 41 14  2...CR02p..CRAA.
  7720: 47 0B 5F 43 52 53 08 08 42 55 46 30 11 10 0A 0D  G._CRS..BUF0....
  7730: 47 01 F8 03 F8 03 01 08 22 10 00 79 00 8C 42 55  G......."..y..BU
  7740: 46 30 0A 02 49 4F 4C 30 8C 42 55 46 30 0A 03 49  F0..IOL0.BUF0..I
  7750: 4F 48 30 8C 42 55 46 30 0A 04 49 4F 4C 31 8C 42  OH0.BUF0..IOL1.B
  7760: 55 46 30 0A 05 49 4F 48 31 8C 42 55 46 30 0A 07  UF0..IOH1.BUF0..
  7770: 4C 45 4E 30 8B 42 55 46 30 0A 09 49 52 51 57 70  LEN0.BUF0..IRQWp
  7780: 0A 00 43 52 35 35 79 43 52 32 34 0A 02 49 4F 4C  ..CR55yCR24..IOL
  7790: 30 79 43 52 32 34 0A 02 49 4F 4C 31 7A 43 52 32  0yCR24..IOL1zCR2
  77A0: 34 0A 06 49 4F 48 30 7A 43 52 32 34 0A 06 49 4F  4..IOH0zCR24..IO
  77B0: 48 31 70 0A 08 4C 45 4E 30 79 01 7A 7B 43 52 32  H1p..LEN0y.z{CR2
  77C0: 38 0A F0 00 0A 04 00 49 52 51 57 70 0A 00 43 52  8......IRQWp..CR
  77D0: 41 41 A4 42 55 46 30 08 5F 50 52 53 11 48 04 0A  AA.BUF0._PRS.H..
  77E0: 44 31 08 47 01 F8 03 F8 03 01 08 22 10 00 31 08  D1.G......."..1.
  77F0: 47 01 F8 03 F8 03 01 08 22 F0 1C 31 08 47 01 F8  G......."..1.G..
  7800: 02 F8 02 01 08 22 F0 1C 31 08 47 01 E8 03 E8 03  ....."..1.G.....
  7810: 01 08 22 F0 1C 31 08 47 01 E8 02 E8 02 01 08 22  .."..1.G......."
  7820: F0 1C 38 79 00 14 4F 0D 5F 53 52 53 09 8C 68 0A  ..8y..O._SRS..h.
  7830: 02 49 4F 4C 4F 8C 68 0A 03 49 4F 48 49 8B 68 0A  .IOLO.h..IOHI.h.
  7840: 09 49 52 51 57 70 0A 00 43 52 35 35 70 7B 43 52  .IRQWp..CR55p{CR
  7850: 30 32 0A F0 00 43 52 30 32 70 7A 49 4F 4C 4F 0A  02...CR02pzIOLO.
  7860: 02 00 43 52 32 34 7D 43 52 32 34 79 49 4F 48 49  ..CR24}CR24yIOHI
  7870: 0A 06 00 43 52 32 34 7B 43 52 32 38 0A 0F 43 52  ...CR24{CR28..CR
  7880: 32 38 7D 43 52 32 38 79 74 82 49 52 51 57 00 0A  28}CR28yt.IRQW..
  7890: 01 00 0A 04 00 43 52 32 38 7B 49 4F 44 30 0A F8  .....CR28{IOD0..
  78A0: 49 4F 44 30 A0 29 93 49 4F 48 49 0A 03 A0 13 93  IOD0.).IOHI.....
  78B0: 49 4F 4C 4F 0A F8 7D 49 4F 44 30 0A 00 49 4F 44  IOLO..}IOD0..IOD
  78C0: 30 A1 0C 7D 49 4F 44 30 0A 07 49 4F 44 30 A1 22  0..}IOD0..IOD0."
  78D0: A0 13 93 49 4F 4C 4F 0A F8 7D 49 4F 44 30 0A 01  ...IOLO..}IOD0..
  78E0: 49 4F 44 30 A1 0C 7D 49 4F 44 30 0A 05 49 4F 44  IOD0..}IOD0..IOD
  78F0: 30 70 7D 43 52 30 32 0A 08 00 43 52 30 32 70 0A  0p}CR02...CR02p.
  7900: 00 43 52 41 41 14 21 5F 50 53 30 08 70 0A 00 43  .CRAA.!_PS0.p..C
  7910: 52 35 35 70 7D 43 52 30 32 0A 08 00 43 52 30 32  R55p}CR02...CR02
  7920: 70 0A 00 43 52 41 41 14 21 5F 50 53 33 08 70 0A  p..CRAA.!_PS3.p.
  7930: 00 43 52 35 35 70 7B 43 52 30 32 0A F0 00 43 52  .CR55p{CR02...CR
  7940: 30 32 70 0A 00 43 52 41 41 5B 82 45 31 4C 50 54  02p..CRAA[.E1LPT
  7950: 45 08 5F 48 49 44 0C 41 D0 04 01 08 5F 55 49 44  E._HID.A...._UID
  7960: 0A 05 14 42 08 43 4C 50 53 00 08 44 43 4B 39 11  ...B.CLPS..DCK9.
  7970: 03 0A 04 8C 44 43 4B 39 0A 00 44 43 4B 38 8C 44  ....DCK9..DCK8.D
  7980: 43 4B 39 0A 01 44 43 4B 36 8C 44 43 4B 39 0A 02  CK9..DCK6.DCK9..
  7990: 44 43 4B 32 8C 44 43 4B 39 0A 03 44 43 4B 37 70  DCK2.DCK9..DCK7p
  79A0: 0A 02 44 43 4B 38 70 47 45 4E 53 0A 13 44 43 4B  ..DCK8pGENS..DCK
  79B0: 39 87 44 43 4B 39 60 70 60 44 43 4B 39 A0 24 90  9.DCK9`p`DCK9.$.
  79C0: 93 44 43 4B 36 0A 01 93 44 43 4B 37 0A 01 A0 13  .DCK6...DCK7....
  79D0: 91 93 44 43 4B 32 0A 01 93 44 43 4B 32 0A 04 A4  ..DCK2...DCK2...
  79E0: 0A 01 A4 0A 00 14 30 5F 53 54 41 08 A0 26 43 4C  ......0_STA..&CL
  79F0: 50 53 70 0A 00 43 52 35 35 70 43 52 30 31 60 70  PSp..CR55pCR01`p
  7A00: 0A 00 43 52 41 41 A0 09 7B 60 0A 04 00 A4 0A 0F  ..CRAA..{`......
  7A10: A4 0A 0D A4 0A 0D 14 21 5F 44 49 53 08 70 0A 00  .......!_DIS.p..
  7A20: 43 52 35 35 70 7B 43 52 30 31 0A FB 00 43 52 30  CR55p{CR01...CR0
  7A30: 31 70 0A 00 43 52 41 41 14 40 0C 5F 43 52 53 08  1p..CRAA.@._CRS.
  7A40: 08 42 55 46 30 11 10 0A 0D 47 01 00 00 00 00 01  .BUF0....G......
  7A50: 00 22 01 00 79 00 A0 4D 09 43 4C 50 53 8C 42 55  ."..y..M.CLPS.BU
  7A60: 46 30 0A 02 49 4F 4C 30 8C 42 55 46 30 0A 03 49  F0..IOL0.BUF0..I
  7A70: 4F 48 30 8C 42 55 46 30 0A 04 49 4F 4C 31 8C 42  OH0.BUF0..IOL1.B
  7A80: 55 46 30 0A 05 49 4F 48 31 8C 42 55 46 30 0A 07  UF0..IOH1.BUF0..
  7A90: 4C 45 4E 30 8B 42 55 46 30 0A 09 49 52 51 57 70  LEN0.BUF0..IRQWp
  7AA0: 0A 00 43 52 35 35 79 43 52 32 33 0A 02 49 4F 4C  ..CR55yCR23..IOL
  7AB0: 30 79 43 52 32 33 0A 02 49 4F 4C 31 7A 43 52 32  0yCR23..IOL1zCR2
  7AC0: 33 0A 06 49 4F 48 30 7A 43 52 32 33 0A 06 49 4F  3..IOH0zCR23..IO
  7AD0: 48 31 70 0A 04 4C 45 4E 30 70 0A 00 61 7B 43 52  H1p..LEN0p..a{CR
  7AE0: 32 37 0A 0F 61 79 0A 01 61 49 52 51 57 70 0A 00  27..ay..aIRQWp..
  7AF0: 43 52 41 41 A4 42 55 46 30 08 5F 50 52 53 11 45  CRAA.BUF0._PRS.E
  7B00: 05 0A 51 31 08 47 01 78 03 78 03 01 04 22 20 00  ..Q1.G.x.x..." .
  7B10: 31 08 47 01 78 02 78 02 01 04 22 20 00 31 08 47  1.G.x.x..." .1.G
  7B20: 01 BC 03 BC 03 01 04 22 20 00 31 08 47 01 78 03  ......." .1.G.x.
  7B30: 78 03 01 04 22 80 00 31 08 47 01 78 02 78 02 01  x..."..1.G.x.x..
  7B40: 04 22 80 00 31 08 47 01 BC 03 BC 03 01 04 22 80  ."..1.G.......".
  7B50: 00 38 79 00 14 47 0C 5F 53 52 53 09 A0 0A 93 43  .8y..G._SRS....C
  7B60: 4C 50 53 0A 00 A4 00 8C 68 0A 02 49 4F 4C 30 8C  LPS.....h..IOL0.
  7B70: 68 0A 03 49 4F 48 30 8B 68 0A 09 49 52 51 57 70  h..IOH0.h..IRQWp
  7B80: 0A 00 43 52 35 35 70 7B 43 52 30 31 0A FB 00 43  ..CR55p{CR01...C
  7B90: 52 30 31 70 7A 49 4F 4C 30 0A 02 00 43 52 32 33  R01pzIOL0...CR23
  7BA0: 7D 43 52 32 33 79 49 4F 48 30 0A 06 00 43 52 32  }CR23yIOH0...CR2
  7BB0: 33 82 49 52 51 57 60 A0 0A 92 93 49 52 51 57 00  3.IRQW`....IRQW.
  7BC0: 76 60 70 60 43 52 32 37 7B 49 4F 44 31 0A FC 49  v`p`CR27{IOD1..I
  7BD0: 4F 44 31 A0 29 93 49 4F 48 30 0A 03 A0 13 93 49  OD1.).IOH0.....I
  7BE0: 4F 4C 30 0A 78 7D 49 4F 44 31 0A 00 49 4F 44 31  OL0.x}IOD1..IOD1
  7BF0: A1 0C 7D 49 4F 44 31 0A 02 49 4F 44 31 A1 0C 7D  ..}IOD1..IOD1..}
  7C00: 49 4F 44 31 0A 01 49 4F 44 31 7D 43 52 30 31 0A  IOD1..IOD1}CR01.
  7C10: 04 43 52 30 31 70 0A 00 43 52 41 41 14 21 5F 50  .CR01p..CRAA.!_P
  7C20: 53 30 08 70 0A 00 43 52 35 35 70 7D 43 52 30 31  S0.p..CR55p}CR01
  7C30: 0A 04 00 43 52 30 31 70 0A 00 43 52 41 41 14 21  ...CR01p..CRAA.!
  7C40: 5F 50 53 33 08 70 0A 00 43 52 35 35 70 7B 43 52  _PS3.p..CR55p{CR
  7C50: 30 31 0A FB 00 43 52 30 31 70 0A 00 43 52 41 41  01...CR01p..CRAA
  7C60: 10 8F 0D 01 5C 2E 5F 53 42 5F 50 43 49 30 5B 82  ....\._SB_PCI0[.
  7C70: 80 0D 01 56 49 44 5F 08 5F 41 44 52 0C 00 00 02  ...VID_._ADR....
  7C80: 00 08 49 56 44 35 11 03 0A 03 8C 49 56 44 35 0A  ..IVD5.....IVD5.
  7C90: 00 49 56 44 36 8C 49 56 44 35 0A 01 49 56 44 37  .IVD6.IVD5..IVD7
  7CA0: 8C 49 56 44 35 0A 02 49 56 44 38 5B 80 50 43 53  .IVD5..IVD8[.PCS
  7CB0: 5F 02 0A 00 0B 00 01 5B 81 13 50 43 53 5F 40 56  _......[..PCS_@V
  7CC0: 56 49 44 10 00 40 04 44 43 4C 53 10 14 41 05 56  VID..@.DCLS..A.V
  7CD0: 49 4E 49 02 A0 49 04 93 68 0A 02 70 0A 00 49 56  INI..I..h..p..IV
  7CE0: 44 36 70 44 43 4C 53 61 A0 35 93 44 43 4C 53 0B  D6pDCLSa.5.DCLS.
  7CF0: 00 03 70 0A 01 49 56 44 36 70 5C 2F 03 5F 53 42  ..p..IVD6p\/._SB
  7D00: 5F 4C 49 44 5F 5F 4C 49 44 60 5C 2F 04 5F 53 42  _LID__LID`\/._SB
  7D10: 5F 50 43 49 30 56 49 44 5F 47 4C 49 44 60 10 48  _PCI0VID_GLID`.H
  7D20: 07 5C 00 14 43 05 56 44 50 32 02 08 56 44 50 33  .\..C.VDP2..VDP3
  7D30: 11 03 0A 10 8C 56 44 50 33 0A 00 56 44 50 34 8C  .....VDP3..VDP4.
  7D40: 56 44 50 33 0A 01 56 44 50 35 8A 56 44 50 33 0A  VDP3..VDP5.VDP3.
  7D50: 05 56 44 50 36 70 0A 04 56 44 50 34 70 68 56 44  .VDP6p..VDP4phVD
  7D60: 50 35 70 69 56 44 50 36 47 45 4E 53 0A 05 56 44  P5piVDP6GENS..VD
  7D70: 50 33 87 56 44 50 33 14 1F 56 44 50 31 02 70 69  P3.VDP3..VDP1.pi
  7D80: 60 79 60 0A 08 60 7D 60 68 60 70 47 45 4E 53 0A  `y`..`}`h`pGENS.
  7D90: 05 60 0A 00 60 A4 60 08 56 44 50 37 11 05 0A 02  .`..`.`.VDP7....
  7DA0: 00 00 8C 56 44 50 37 0A 01 56 44 50 38 14 13 44  ...VDP7..VDP8..D
  7DB0: 49 4E 49 02 A0 0C 93 68 0A 02 70 0A 01 56 44 50  INI....h..p..VDP
  7DC0: 38 14 16 5F 44 4F 53 01 70 68 56 44 50 38 56 44  8.._DOS.phVDP8VD
  7DD0: 50 31 0A 01 56 44 50 38 14 1C 5F 44 4F 44 00 A4  P1..VDP8.._DOD..
  7DE0: 12 14 06 0B 00 01 0B 00 04 0B 02 03 0B 03 03 0B  ................
  7DF0: 00 03 0B 01 03 5B 82 45 04 43 52 54 5F 14 0A 5F  .....[.E.CRT_.._
  7E00: 41 44 52 00 A4 0B 00 01 14 12 5F 44 43 53 00 70  ADR......._DCS.p
  7E10: 56 44 50 31 0A 02 0A 02 60 A4 60 14 12 5F 44 47  VDP1....`.`.._DG
  7E20: 53 00 70 56 44 50 31 0A 03 0A 02 60 A4 60 14 0D  S.pVDP1....`.`..
  7E30: 5F 44 53 53 01 56 44 50 32 0A 02 68 5B 82 43 16  _DSS.VDP2..h[.C.
  7E40: 4C 43 44 5F 14 0A 5F 41 44 52 00 A4 0B 00 04 14  LCD_.._ADR......
  7E50: 12 5F 44 43 53 00 70 56 44 50 31 0A 02 0A 01 60  ._DCS.pVDP1....`
  7E60: A4 60 14 12 5F 44 47 53 00 70 56 44 50 31 0A 03  .`.._DGS.pVDP1..
  7E70: 0A 01 60 A4 60 14 0D 5F 44 53 53 01 56 44 50 32  ..`.`.._DSS.VDP2
  7E80: 0A 01 68 08 42 52 54 30 0A 64 08 44 42 43 4C 12  ..h.BRT0.d.DBCL.
  7E90: 02 12 14 48 05 5F 42 43 4C 08 08 42 52 54 31 11  ...H._BCL..BRT1.
  7EA0: 03 0A 12 8C 42 52 54 31 0A 00 42 52 54 32 70 0A  ....BRT1..BRT2p.
  7EB0: 01 42 52 54 32 70 47 45 4E 53 0A 09 42 52 54 31  .BRT2pGENS..BRT1
  7EC0: 87 42 52 54 31 62 70 0A 00 60 70 0A 12 61 A2 17  .BRT1bp..`p..a..
  7ED0: 95 60 61 70 42 42 52 44 62 60 63 70 63 88 44 42  .`apBBRDb`cpc.DB
  7EE0: 43 4C 60 00 75 60 A4 44 42 43 4C 14 48 04 5F 42  CL`.u`.DBCL.H._B
  7EF0: 43 4D 09 08 42 52 54 33 11 03 0A 02 8C 42 52 54  CM..BRT3.....BRT
  7F00: 33 0A 00 42 52 54 34 8C 42 52 54 33 0A 01 42 52  3..BRT4.BRT3..BR
  7F10: 54 35 70 0A 02 42 52 54 34 70 68 42 52 54 35 70  T5p..BRT4phBRT5p
  7F20: 68 42 52 54 30 47 45 4E 53 0A 09 42 52 54 33 87  hBRT0GENS..BRT3.
  7F30: 42 52 54 33 14 1A 5F 42 51 43 08 70 47 45 4E 53  BRT3.._BQC.pGENS
  7F40: 0A 09 0A 03 0A 00 60 70 60 42 52 54 30 A4 60 10  ......`p`BRT0.`.
  7F50: 41 05 5C 2F 03 5F 53 42 5F 50 43 49 30 56 49 44  A.\/._SB_PCI0VID
  7F60: 5F 14 3F 42 52 54 36 02 A0 1B 93 68 0A 01 86 5C  _.?BRT6....h...\
  7F70: 2F 04 5F 53 42 5F 50 43 49 30 56 49 44 5F 4C 43  /._SB_PCI0VID_LC
  7F80: 44 5F 0A 86 A0 1C 7B 68 0A 02 00 86 5C 2F 04 5F  D_....{h....\/._
  7F90: 53 42 5F 50 43 49 30 56 49 44 5F 4C 43 44 5F 0A  SB_PCI0VID_LCD_.
  7FA0: 87 5B 82 45 04 44 56 49 5F 14 0A 5F 41 44 52 00  .[.E.DVI_.._ADR.
  7FB0: A4 0B 02 03 14 12 5F 44 43 53 00 70 56 44 50 31  ......_DCS.pVDP1
  7FC0: 0A 02 0A 08 60 A4 60 14 12 5F 44 47 53 00 70 56  ....`.`.._DGS.pV
  7FD0: 44 50 31 0A 03 0A 08 60 A4 60 14 0D 5F 44 53 53  DP1....`.`.._DSS
  7FE0: 01 56 44 50 32 0A 08 68 5B 82 45 04 44 56 49 32  .VDP2..h[.E.DVI2
  7FF0: 14 0A 5F 41 44 52 00 A4 0B 03 03 14 12 5F 44 43  .._ADR......._DC
  8000: 53 00 70 56 44 50 31 0A 02 0A 10 60 A4 60 14 12  S.pVDP1....`.`..
  8010: 5F 44 47 53 00 70 56 44 50 31 0A 03 0A 10 60 A4  _DGS.pVDP1....`.
  8020: 60 14 0D 5F 44 53 53 01 56 44 50 32 0A 10 68 5B  `.._DSS.VDP2..h[
  8030: 82 45 04 44 50 5F 5F 14 0A 5F 41 44 52 00 A4 0B  .E.DP__.._ADR...
  8040: 00 03 14 12 5F 44 43 53 00 70 56 44 50 31 0A 02  ...._DCS.pVDP1..
  8050: 0A 20 60 A4 60 14 12 5F 44 47 53 00 70 56 44 50  . `.`.._DGS.pVDP
  8060: 31 0A 03 0A 20 60 A4 60 14 0D 5F 44 53 53 01 56  1... `.`.._DSS.V
  8070: 44 50 32 0A 20 68 5B 82 45 04 44 50 32 5F 14 0A  DP2. h[.E.DP2_..
  8080: 5F 41 44 52 00 A4 0B 01 03 14 12 5F 44 43 53 00  _ADR......._DCS.
  8090: 70 56 44 50 31 0A 02 0A 40 60 A4 60 14 12 5F 44  pVDP1...@`.`.._D
  80A0: 47 53 00 70 56 44 50 31 0A 03 0A 40 60 A4 60 14  GS.pVDP1...@`.`.
  80B0: 0D 5F 44 53 53 01 56 44 50 32 0A 40 68 10 28 5C  ._DSS.VDP2.@h.(\
  80C0: 2E 5F 53 42 5F 50 43 49 30 5B 80 4D 43 48 50 02  ._SB_PCI0[.MCHP.
  80D0: 0A 40 0A C0 5B 81 10 4D 43 48 50 00 00 40 30 54  .@..[..MCHP..@0T
  80E0: 41 53 4D 0A 00 06 5B 80 49 47 44 50 02 0A 40 0A  ASM...[.IGDP..@.
  80F0: C0 5B 81 45 05 49 47 44 50 00 00 40 09 00 01 47  .[.E.IGDP..@...G
  8100: 49 56 44 01 00 02 47 55 4D 41 03 00 09 00 04 47  IVD...GUMA.....G
  8110: 4D 46 4E 01 00 1B 00 40 46 41 53 4C 45 08 00 18  MFN....@FASLE...
  8120: 47 53 53 45 01 47 53 53 42 0E 47 53 45 53 01 00  GSSE.GSSB.GSES..
  8130: 30 00 0C 43 44 56 4C 01 00 03 00 18 4C 42 50 43  0..CDVL.....LBPC
  8140: 08 00 30 41 53 4C 53 20 5B 80 49 47 44 4D 00 41  ..0ASLS [.IGDM.A
  8150: 53 4C 42 0B 00 20 5B 81 48 19 49 47 44 4D 00 53  SLB.. [.H.IGDM.S
  8160: 49 47 4E 40 08 53 49 5A 45 20 4F 56 45 52 20 53  IGN@.SIZE OVER S
  8170: 56 45 52 40 10 56 56 45 52 40 08 47 56 45 52 40  VER@.VVER@.GVER@
  8180: 08 4D 42 4F 58 20 44 4D 4F 44 20 00 40 50 44 52  .MBOX DMOD .@PDR
  8190: 44 59 20 43 53 54 53 20 43 45 56 54 20 00 40 0A  DY CSTS CEVT .@.
  81A0: 44 49 44 4C 20 44 44 4C 32 20 44 44 4C 33 20 44  DIDL DDL2 DDL3 D
  81B0: 44 4C 34 20 44 44 4C 35 20 44 44 4C 36 20 44 44  DL4 DDL5 DDL6 DD
  81C0: 4C 37 20 44 44 4C 38 20 43 50 44 4C 20 43 50 4C  L7 DDL8 CPDL CPL
  81D0: 32 20 43 50 4C 33 20 43 50 4C 34 20 43 50 4C 35  2 CPL3 CPL4 CPL5
  81E0: 20 43 50 4C 36 20 43 50 4C 37 20 43 50 4C 38 20   CPL6 CPL7 CPL8 
  81F0: 43 41 44 4C 20 43 41 4C 32 20 43 41 4C 33 20 43  CADL CAL2 CAL3 C
  8200: 41 4C 34 20 43 41 4C 35 20 43 41 4C 36 20 43 41  AL4 CAL5 CAL6 CA
  8210: 4C 37 20 43 41 4C 38 20 4E 41 44 4C 20 4E 44 4C  L7 CAL8 NADL NDL
  8220: 32 20 4E 44 4C 33 20 4E 44 4C 34 20 4E 44 4C 35  2 NDL3 NDL4 NDL5
  8230: 20 4E 44 4C 36 20 4E 44 4C 37 20 4E 44 4C 38 20   NDL6 NDL7 NDL8 
  8240: 41 53 4C 50 20 54 49 44 58 20 43 48 50 44 20 43  ASLP TIDX CHPD C
  8250: 4C 49 44 20 43 44 43 4B 20 53 58 53 57 20 45 56  LID CDCK SXSW EV
  8260: 54 53 20 43 4E 4F 54 20 4E 52 44 59 20 00 40 1E  TS CNOT NRDY .@.
  8270: 53 43 49 45 01 47 45 46 43 04 47 58 46 43 03 47  SCIE.GEFC.GXFC.G
  8280: 45 53 46 08 00 10 50 41 52 4D 20 44 53 4C 50 20  ESF...PARM DSLP 
  8290: 00 40 7A 41 52 44 59 20 41 53 4C 43 20 54 43 48  .@zARDY ASLC TCH
  82A0: 45 20 41 4C 53 49 20 42 43 4C 50 20 50 46 49 54  E ALSI BCLP PFIT
  82B0: 20 43 42 4C 56 20 42 43 4C 4D 40 14 43 50 46 4D   CBLV BCLM@.CPFM
  82C0: 20 45 50 46 4D 20 50 4C 55 54 40 25 50 46 4D 42   EPFM PLUT@%PFMB
  82D0: 20 43 43 44 56 20 50 43 46 54 20 00 40 2F 47 56   CCDV PCFT .@/GV
  82E0: 44 31 80 00 0C 50 48 45 44 20 42 44 44 43 40 80  D1...PHED BDDC@.
  82F0: 08 44 42 54 42 12 38 15 0A 00 0A 07 0A 38 0B C0  .DBTB.8......8..
  8300: 01 0B 00 0E 0A 3F 0B C7 01 0B 07 0E 0B F8 01 0B  .....?..........
  8310: 38 0E 0B C0 0F 0A 00 0A 00 0A 00 0A 00 0A 00 0B  8...............
  8320: 00 70 0B 07 70 0B 38 70 0B C0 71 0B 00 7E 08 43  .p..p.8p..q..~.C
  8330: 44 43 54 12 29 05 12 07 02 0A E4 0B 40 01 12 07  DCT.).......@...
  8340: 02 0A DE 0B 4D 01 12 07 02 0A DE 0B 4D 01 12 06  ....M.......M...
  8350: 02 0A 00 0A 00 12 07 02 0A DE 0B 4D 01 08 53 55  ...........M..SU
  8360: 43 43 0A 01 08 4E 56 4C 44 0A 02 08 43 52 49 54  CC...NVLD...CRIT
  8370: 0A 04 08 4E 43 52 54 0A 06 14 4E 51 47 53 43 49  ...NCRT...NQGSCI
  8380: 00 14 42 1F 47 42 44 41 00 A0 1B 93 47 45 53 46  ..B.GBDA....GESF
  8390: 0A 00 70 0B 79 06 50 41 52 4D 70 00 47 45 53 46  ..p.y.PARMp.GESF
  83A0: A4 53 55 43 43 A0 1B 93 47 45 53 46 0A 01 70 0B  .SUCC...GESF..p.
  83B0: 40 02 50 41 52 4D 70 00 47 45 53 46 A4 53 55 43  @.PARMp.GESF.SUC
  83C0: 43 A0 47 04 93 47 45 53 46 0A 04 7B 50 41 52 4D  C.G..GESF..{PARM
  83D0: 0C 00 00 FF EF 50 41 52 4D 7B 50 41 52 4D 79 83  .....PARM{PARMy.
  83E0: 88 44 42 54 42 49 42 54 54 00 0A 10 00 50 41 52  .DBTBIBTT....PAR
  83F0: 4D 7D 49 42 54 54 50 41 52 4D 50 41 52 4D 70 00  M}IBTTPARMPARMp.
  8400: 47 45 53 46 A4 53 55 43 43 A0 4A 06 93 47 45 53  GESF.SUCC.J..GES
  8410: 46 0A 05 70 49 50 53 43 50 41 52 4D 7D 50 41 52  F..pIPSCPARM}PAR
  8420: 4D 79 49 50 41 54 0A 08 00 50 41 52 4D 72 50 41  MyIPAT...PARMrPA
  8430: 52 4D 0B 00 01 50 41 52 4D 7D 50 41 52 4D 79 4C  RM...PARM}PARMyL
  8440: 49 44 53 0A 10 00 50 41 52 4D 72 50 41 52 4D 0C  IDS...PARMrPARM.
  8450: 00 00 01 00 50 41 52 4D 7D 50 41 52 4D 79 49 42  ....PARM}PARMyIB
  8460: 49 41 0A 14 00 50 41 52 4D 70 00 47 45 53 46 A4  IA...PARMp.GESF.
  8470: 53 55 43 43 A0 2D 93 47 45 53 46 0A 06 70 49 54  SUCC.-.GESF..pIT
  8480: 56 46 50 41 52 4D 7D 50 41 52 4D 79 49 54 56 4D  VFPARM}PARMyITVM
  8490: 0A 04 00 50 41 52 4D 70 00 47 45 53 46 A4 53 55  ...PARMp.GESF.SU
  84A0: 43 43 A0 49 07 93 47 45 53 46 0A 07 70 47 49 56  CC.I..GESF..pGIV
  84B0: 44 50 41 52 4D 7F 50 41 52 4D 0A 01 50 41 52 4D  DPARM.PARM..PARM
  84C0: 7D 50 41 52 4D 79 47 4D 46 4E 0A 01 00 50 41 52  }PARMyGMFN...PAR
  84D0: 4D 7D 50 41 52 4D 79 0A 03 0A 0B 00 50 41 52 4D  M}PARMy.....PARM
  84E0: 7D 50 41 52 4D 79 49 44 4D 53 0A 11 00 50 41 52  }PARMyIDMS...PAR
  84F0: 4D 7D 79 83 88 83 88 43 44 43 54 48 56 43 4F 00  M}y....CDCTHVCO.
  8500: 43 44 56 4C 00 0A 15 00 50 41 52 4D 50 41 52 4D  CDVL....PARMPARM
  8510: 70 0A 01 47 45 53 46 A4 53 55 43 43 A0 2C 93 47  p..GESF.SUCC.,.G
  8520: 45 53 46 0A 0A 70 0A 00 50 41 52 4D A0 10 49 53  ESF..p..PARM..IS
  8530: 53 43 7D 50 41 52 4D 0A 03 50 41 52 4D 70 0A 00  SC}PARM..PARMp..
  8540: 47 45 53 46 A4 53 55 43 43 A0 1F 93 47 45 53 46  GESF.SUCC...GESF
  8550: 0A 0B 70 4B 53 56 30 50 41 52 4D 70 4B 53 56 31  ..pKSV0PARMpKSV1
  8560: 47 45 53 46 A4 53 55 43 43 70 00 47 45 53 46 A4  GESF.SUCCp.GESF.
  8570: 43 52 49 54 14 41 2E 53 42 43 42 00 A0 24 93 47  CRIT.A.SBCB..$.G
  8580: 45 53 46 0A 00 70 0A 00 50 41 52 4D 70 0C FD 87  ESF..p..PARMp...
  8590: 0F 00 50 41 52 4D 70 00 47 45 53 46 A4 53 55 43  ..PARMp.GESF.SUC
  85A0: 43 A0 19 93 47 45 53 46 0A 01 70 00 47 45 53 46  C...GESF..p.GESF
  85B0: 70 00 50 41 52 4D A4 53 55 43 43 A0 19 93 47 45  p.PARM.SUCC...GE
  85C0: 53 46 0A 03 70 00 47 45 53 46 70 00 50 41 52 4D  SF..p.GESFp.PARM
  85D0: A4 53 55 43 43 A0 19 93 47 45 53 46 0A 04 70 00  .SUCC...GESF..p.
  85E0: 47 45 53 46 70 00 50 41 52 4D A4 53 55 43 43 A0  GESFp.PARM.SUCC.
  85F0: 19 93 47 45 53 46 0A 05 70 00 47 45 53 46 70 00  ..GESF..p.GESFp.
  8600: 50 41 52 4D A4 53 55 43 43 A0 37 93 47 45 53 46  PARM.SUCC.7.GESF
  8610: 0A 06 70 7B 50 41 52 4D 0A 0F 00 49 54 56 46 70  ..p{PARM...ITVFp
  8620: 7A 7B 50 41 52 4D 0A F0 00 0A 04 00 49 54 56 4D  z{PARM......ITVM
  8630: 70 00 47 45 53 46 70 00 50 41 52 4D A4 53 55 43  p.GESFp.PARM.SUC
  8640: 43 A0 46 04 93 47 45 53 46 0A 07 A0 2B 93 50 41  C.F..GESF...+.PA
  8650: 52 4D 0A 00 70 43 4C 49 44 60 A0 1C 7B 0C 00 00  RM..pCLID`..{...
  8660: 00 80 60 00 7B 43 4C 49 44 0A 0F 43 4C 49 44 47  ..`.{CLID..CLIDG
  8670: 4C 49 44 43 4C 49 44 70 00 47 45 53 46 70 00 50  LIDCLIDp.GESFp.P
  8680: 41 52 4D A4 53 55 43 43 A0 19 93 47 45 53 46 0A  ARM.SUCC...GESF.
  8690: 08 70 00 47 45 53 46 70 00 50 41 52 4D A4 53 55  .p.GESFp.PARM.SU
  86A0: 43 43 A0 24 93 47 45 53 46 0A 09 7B 50 41 52 4D  CC.$.GESF..{PARM
  86B0: 0A FF 49 42 54 54 70 00 47 45 53 46 70 00 50 41  ..IBTTp.GESFp.PA
  86C0: 52 4D A4 53 55 43 43 A0 46 05 93 47 45 53 46 0A  RM.SUCC.F..GESF.
  86D0: 0A 7B 50 41 52 4D 0A FF 49 50 53 43 A0 21 7B 7A  .{PARM..IPSC.!{z
  86E0: 50 41 52 4D 0A 08 00 0A FF 00 7B 7A 50 41 52 4D  PARM......{zPARM
  86F0: 0A 08 00 0A FF 49 50 41 54 76 49 50 41 54 7B 7A  .....IPATvIPAT{z
  8700: 50 41 52 4D 0A 14 00 0A 07 49 42 49 41 70 00 47  PARM.....IBIAp.G
  8710: 45 53 46 70 00 50 41 52 4D A4 53 55 43 43 A0 47  ESFp.PARM.SUCC.G
  8720: 05 93 47 45 53 46 0A 0B 7B 7A 50 41 52 4D 0A 01  ..GESF..{zPARM..
  8730: 00 0A 01 49 46 31 45 A0 1C 7B 50 41 52 4D 79 0A  ...IF1E..{PARMy.
  8740: 0F 0A 0D 00 00 7B 7A 50 41 52 4D 0A 0D 00 0A 0F  .....{zPARM.....
  8750: 49 44 4D 53 A1 10 7B 7A 50 41 52 4D 0A 11 00 0A  IDMS..{zPARM....
  8760: 0F 49 44 4D 53 70 00 47 45 53 46 70 00 50 41 52  .IDMSp.GESFp.PAR
  8770: 4D A4 53 55 43 43 A0 19 93 47 45 53 46 0A 10 70  M.SUCC...GESF..p
  8780: 00 47 45 53 46 70 00 50 41 52 4D A4 53 55 43 43  .GESFp.PARM.SUCC
  8790: A0 2C 93 47 45 53 46 0A 11 70 79 4C 49 44 53 0A  .,.GESF..pyLIDS.
  87A0: 08 00 50 41 52 4D 72 50 41 52 4D 0B 00 01 50 41  ..PARMrPARM...PA
  87B0: 52 4D 70 00 47 45 53 46 A4 53 55 43 43 A0 4E 04  RMp.GESF.SUCC.N.
  87C0: 93 47 45 53 46 0A 12 A0 2A 7B 50 41 52 4D 0A 01  .GESF...*{PARM..
  87D0: 00 A0 13 93 7A 50 41 52 4D 0A 01 00 0A 01 70 0A  ....zPARM.....p.
  87E0: 01 49 53 53 43 A1 0C 70 00 47 45 53 46 A4 43 52  .ISSC..p.GESF.CR
  87F0: 49 54 A1 08 70 0A 00 49 53 53 43 70 00 47 45 53  IT..p..ISSCp.GES
  8800: 46 70 00 50 41 52 4D A4 53 55 43 43 A0 19 93 47  Fp.PARM.SUCC...G
  8810: 45 53 46 0A 13 70 00 47 45 53 46 70 00 50 41 52  ESF..p.GESFp.PAR
  8820: 4D A4 53 55 43 43 A0 24 93 47 45 53 46 0A 14 7B  M.SUCC.$.GESF..{
  8830: 50 41 52 4D 0A 0F 50 41 56 50 70 00 47 45 53 46  PARM..PAVPp.GESF
  8840: 70 00 50 41 52 4D A4 53 55 43 43 70 00 47 45 53  p.PARM.SUCCp.GES
  8850: 46 A4 53 55 43 43 A0 11 93 47 45 46 43 0A 04 70  F.SUCC...GEFC..p
  8860: 47 42 44 41 47 58 46 43 A0 11 93 47 45 46 43 0A  GBDAGXFC...GEFC.
  8870: 06 70 53 42 43 42 47 58 46 43 70 0A 00 47 45 46  .pSBCBGXFCp..GEF
  8880: 43 70 0A 01 53 43 49 53 70 0A 00 47 53 53 45 70  Cp..SCISp..GSSEp
  8890: 0A 00 53 43 49 45 A4 00 14 19 50 44 52 44 00 A0  ..SCIE....PDRD..
  88A0: 0C 92 44 52 44 59 5B 22 41 53 4C 50 A4 92 44 52  ..DRDY["ASLP..DR
  88B0: 44 59 14 1D 50 53 54 53 00 A0 0E 94 43 53 54 53  DY..PSTS....CSTS
  88C0: 0A 02 5B 22 41 53 4C 50 A4 93 43 53 54 53 0A 03  ..["ASLP..CSTS..
  88D0: 14 42 08 47 4E 4F 54 02 A0 08 50 44 52 44 A4 0A  .B.GNOT...PDRD..
  88E0: 01 70 68 43 45 56 54 70 0A 03 43 53 54 53 A0 3F  .phCEVTp..CSTS.?
  88F0: 90 93 43 48 50 44 0A 00 93 69 0A 00 A0 1E 91 94  ..CHPD...i......
  8900: 4F 53 59 53 0B D0 07 95 4F 53 59 53 0B D6 07 86  OSYS....OSYS....
  8910: 5C 2E 5F 53 42 5F 50 43 49 30 69 A1 12 86 5C 2F  \._SB_PCI0i...\/
  8920: 03 5F 53 42 5F 50 43 49 30 56 49 44 5F 69 A0 0D  ._SB_PCI0VID_i..
  8930: 5B 12 48 4E 4F 54 00 48 4E 4F 54 68 A1 13 86 5C  [.HNOT.HNOTh...\
  8940: 2F 03 5F 53 42 5F 50 43 49 30 56 49 44 5F 0A 80  /._SB_PCI0VID_..
  8950: A4 0A 00 14 15 47 48 44 53 01 70 68 54 49 44 58  .....GHDS.phTIDX
  8960: A4 47 4E 4F 54 0A 01 0A 00 14 15 47 4C 49 44 01  .GNOT......GLID.
  8970: 70 68 43 4C 49 44 A4 47 4E 4F 54 0A 02 0A 00 14  phCLID.GNOT.....
  8980: 15 47 44 43 4B 01 70 68 43 44 43 4B A4 47 4E 4F  .GDCK.phCDCK.GNO
  8990: 54 0A 04 0A 00 14 19 50 41 52 44 00 A0 0C 92 41  T......PARD....A
  89A0: 52 44 59 5B 22 41 53 4C 50 A4 92 41 52 44 59 14  RDY["ASLP..ARDY.
  89B0: 49 13 41 49 4E 54 02 A0 10 92 7B 54 43 48 45 79  I.AINT....{TCHEy
  89C0: 0A 01 68 00 00 A4 0A 01 A0 08 50 41 52 44 A4 0A  ..h.......PARD..
  89D0: 01 A0 46 0C 93 68 0A 02 A0 4D 09 43 50 46 4D 7B  ..F..h...M.CPFM{
  89E0: 43 50 46 4D 0A 0F 60 7B 45 50 46 4D 0A 0F 61 A0  CPFM..`{EPFM..a.
  89F0: 2C 93 60 0A 01 A0 0D 7B 61 0A 06 00 70 0A 06 50  ,.`....{a...p..P
  8A00: 46 49 54 A1 18 A0 0D 7B 61 0A 08 00 70 0A 08 50  FIT....{a...p..P
  8A10: 46 49 54 A1 08 70 0A 01 50 46 49 54 A0 2C 93 60  FIT..p..PFIT.,.`
  8A20: 0A 06 A0 0D 7B 61 0A 08 00 70 0A 08 50 46 49 54  ....{a...p..PFIT
  8A30: A1 18 A0 0D 7B 61 0A 01 00 70 0A 01 50 46 49 54  ....{a...p..PFIT
  8A40: A1 08 70 0A 06 50 46 49 54 A0 2C 93 60 0A 08 A0  ..p..PFIT.,.`...
  8A50: 0D 7B 61 0A 01 00 70 0A 01 50 46 49 54 A1 18 A0  .{a...p..PFIT...
  8A60: 0D 7B 61 0A 06 00 70 0A 06 50 46 49 54 A1 08 70  .{a...p..PFIT..p
  8A70: 0A 08 50 46 49 54 A1 0C 7F 50 46 49 54 0A 07 50  ..PFIT...PFIT..P
  8A80: 46 49 54 7D 50 46 49 54 0C 00 00 00 80 50 46 49  FIT}PFIT.....PFI
  8A90: 54 70 0A 04 41 53 4C 43 A1 46 04 A0 29 93 68 0A  Tp..ASLC.F..).h.
  8AA0: 01 70 78 77 69 0A FF 00 0A 64 00 00 42 43 4C 50  .pxwi....d..BCLP
  8AB0: 7D 42 43 4C 50 0C 00 00 00 80 42 43 4C 50 70 0A  }BCLP.....BCLPp.
  8AC0: 02 41 53 4C 43 A1 19 A0 12 93 68 0A 00 70 69 41  .ASLC.....h..piA
  8AD0: 4C 53 49 70 0A 01 41 53 4C 43 A1 04 A4 0A 01 70  LSIp..ASLC.....p
  8AE0: 0A 01 41 53 4C 45 A4 0A 00 14 19 53 43 49 50 00  ..ASLE.....SCIP.
  8AF0: A0 0F 92 93 4F 56 45 52 0A 00 A4 92 47 53 4D 49  ....OVER....GSMI
  8B00: A4 0A 00 10 4A 05 5C 5F 47 50 45 14 42 05 5F 4C  ....J.\_GPE.B._L
  8B10: 30 36 00 A0 4A 04 92 93 5C 2F 04 5F 53 42 5F 50  06..J...\/._SB_P
  8B20: 43 49 30 56 49 44 5F 53 43 49 50 0A 00 A0 27 5C  CI0VID_SCIP...'\
  8B30: 2F 04 5F 53 42 5F 50 43 49 30 56 49 44 5F 47 53  /._SB_PCI0VID_GS
  8B40: 53 45 5C 2F 04 5F 53 42 5F 50 43 49 30 56 49 44  SE\/._SB_PCI0VID
  8B50: 5F 47 53 43 49 A1 08 70 0A 01 53 43 49 53 14 4B  _GSCI..p..SCIS.K
  8B60: 05 49 4C 49 44 00 A0 4B 04 93 49 56 44 36 0A 01  .ILID..K..IVD6..
  8B70: 70 5C 2F 03 5F 53 42 5F 4C 49 44 5F 5F 4C 49 44  p\/._SB_LID__LID
  8B80: 60 5C 2F 04 5F 53 42 5F 50 43 49 30 56 49 44 5F  `\/._SB_PCI0VID_
  8B90: 47 4C 49 44 60 86 5C 2E 5F 53 42 5F 4C 49 44 5F  GLID`.\._SB_LID_
  8BA0: 0A 80 70 0A 00 49 56 44 38 5B 22 0B F4 01 70 0A  ..p..IVD8["...p.
  8BB0: 01 60 A1 05 70 0A 00 60 A4 60 14 10 49 4C 44 45  .`..p..`.`..ILDE
  8BC0: 02 A0 09 93 68 0A 03 49 4C 49 44 14 24 49 56 44  ....h..ILID.$IVD
  8BD0: 31 02 A0 1D 93 49 56 44 36 0A 01 5C 2F 04 5F 53  1....IVD6..\/._S
  8BE0: 42 5F 50 43 49 30 56 49 44 5F 47 48 44 53 0A 00  B_PCI0VID_GHDS..
  8BF0: 14 43 0C 49 56 44 32 02 A0 4B 0B 93 49 56 44 36  .C.IVD2..K..IVD6
  8C00: 0A 01 5C 2F 04 5F 53 42 5F 50 43 49 30 56 49 44  ..\/._SB_PCI0VID
  8C10: 5F 47 44 43 4B 5C 2F 04 5F 53 42 5F 50 43 49 30  _GDCK\/._SB_PCI0
  8C20: 56 49 44 5F 43 44 43 4B A0 4B 08 93 5C 2F 04 5F  VID_CDCK.K..\/._
  8C30: 53 42 5F 50 43 49 30 56 49 44 5F 43 44 43 4B 0A  SB_PCI0VID_CDCK.
  8C40: 01 A0 42 07 93 5C 2F 04 5F 53 42 5F 50 43 49 30  ..B..\/._SB_PCI0
  8C50: 56 49 44 5F 43 4C 49 44 0A 00 5B 22 0B D0 07 70  VID_CLID..["...p
  8C60: 0A 01 49 56 44 38 5C 2F 04 5F 53 42 5F 50 43 49  ..IVD8\/._SB_PCI
  8C70: 30 56 49 44 5F 47 4C 49 44 0A 01 86 5C 2E 5F 53  0VID_GLID...\._S
  8C80: 42 5F 4C 49 44 5F 0A 80 5B 22 0B EE 02 5C 2F 04  B_LID_..["...\/.
  8C90: 5F 53 42 5F 50 43 49 30 56 49 44 5F 47 4C 49 44  _SB_PCI0VID_GLID
  8CA0: 0A 00 86 5C 2E 5F 53 42 5F 4C 49 44 5F 0A 80 5B  ...\._SB_LID_..[
  8CB0: 22 0B D0 07 14 1A 49 56 44 34 02 70 5C 2F 03 5F  ".....IVD4.p\/._
  8CC0: 53 42 5F 4C 49 44 5F 5F 4C 49 44 49 56 44 37 14  SB_LID__LIDIVD7.
  8CD0: 40 07 49 56 44 33 02 A0 48 06 93 49 56 44 36 0A  @.IVD3..H..IVD6.
  8CE0: 01 70 5C 2F 03 5F 53 42 5F 4C 49 44 5F 5F 4C 49  .p\/._SB_LID__LI
  8CF0: 44 60 70 60 5C 2F 04 5F 53 42 5F 50 43 49 30 56  D`p`\/._SB_PCI0V
  8D00: 49 44 5F 43 4C 49 44 A0 38 93 68 0A 03 A0 32 7D  ID_CLID.8.h...2}
  8D10: 92 93 49 56 44 37 60 93 60 0A 00 00 A0 1D 92 95  ..IVD7`.`.......
  8D20: 4F 53 49 44 0A 20 5C 2F 04 5F 53 42 5F 50 43 49  OSID. \/._SB_PCI
  8D30: 30 56 49 44 5F 47 4C 49 44 60 A1 05 49 4C 49 44  0VID_GLID`..ILID
  8D40: 10 4B 13 5C 2F 04 5F 53 42 5F 50 43 49 30 41 47  .K.\/._SB_PCI0AG
  8D50: 50 5F 56 49 44 5F 5B 80 4E 56 48 4D 00 4E 56 48  P_VID_[.NVHM.NVH
  8D60: 41 0C 00 04 01 00 5B 81 44 11 4E 56 48 4D 00 4E  A.....[.D.NVHM.N
  8D70: 56 53 47 40 08 4E 56 53 5A 20 4E 56 56 52 20 00  VSG@.NVSZ NVVR .
  8D80: 40 74 4E 56 48 4F 20 52 56 42 53 20 00 40 3C 54  @tNVHO RVBS .@<T
  8D90: 4E 44 49 08 44 47 4E 44 08 49 47 4E 44 08 00 48  NDI.DGND.IGND..H
  8DA0: 06 00 40 10 44 44 49 31 20 44 44 49 32 20 44 44  ..@.DDI1 DDI2 DD
  8DB0: 49 33 20 44 44 49 34 20 44 44 49 35 20 44 44 49  I3 DDI4 DDI5 DDI
  8DC0: 36 20 44 44 49 37 20 44 44 49 38 20 00 40 18 47  6 DDI7 DDI8 .@.G
  8DD0: 41 43 44 10 47 41 54 44 10 00 40 2E 44 43 50 31  ACD.GATD..@.DCP1
  8DE0: 20 44 43 50 32 20 44 43 50 33 20 44 43 50 34 20   DCP2 DCP3 DCP4 
  8DF0: 44 43 50 35 20 44 43 50 36 20 44 43 50 37 20 44  DCP5 DCP6 DCP7 D
  8E00: 43 50 38 20 44 43 41 31 20 44 43 41 32 20 44 43  CP8 DCA1 DCA2 DC
  8E10: 41 33 20 44 43 41 34 20 44 43 41 35 20 44 43 41  A3 DCA4 DCA5 DCA
  8E20: 36 20 44 43 41 37 20 44 43 41 38 20 44 4E 41 31  6 DCA7 DCA8 DNA1
  8E30: 20 44 4E 41 32 20 44 4E 41 33 20 44 4E 41 34 20   DNA2 DNA3 DNA4 
  8E40: 44 4E 41 35 20 44 4E 41 36 20 44 4E 41 37 20 44  DNA5 DNA6 DNA7 D
  8E50: 4E 41 38 20 00 40 80 52 41 50 4D 08 45 41 50 4D  NA8 .@.RAPM.EAPM
  8E60: 08 54 53 4C 43 10 44 4E 44 49 08 00 48 1D 52 42  .TSLC.DNDI..H.RB
  8E70: 46 31 80 00 40 52 42 46 32 80 00 40 10 44 5D 5C  F1..@RBF2..@.D]\
  8E80: 2F 04 5F 53 42 5F 50 43 49 30 41 47 50 5F 56 49  /._SB_PCI0AGP_VI
  8E90: 44 5F 08 45 56 44 34 11 03 0A 01 8C 45 56 44 34  D_.EVD4.....EVD4
  8EA0: 0A 00 45 56 44 35 5B 80 50 43 53 5F 02 0A 00 0B  ..EVD5[.PCS_....
  8EB0: 00 01 5B 81 13 50 43 53 5F 40 56 56 49 44 10 00  ..[..PCS_@VVID..
  8EC0: 40 04 44 43 4C 53 10 14 2A 56 49 4E 49 02 A0 23  @.DCLS..*VINI..#
  8ED0: 93 68 0A 02 70 0A 00 45 56 44 35 70 44 43 4C 53  .h..p..EVD5pDCLS
  8EE0: 61 A0 10 93 44 43 4C 53 0B 00 03 70 0A 01 45 56  a...DCLS...p..EV
  8EF0: 44 35 08 56 44 50 37 11 05 0A 02 00 00 8C 56 44  D5.VDP7.......VD
  8F00: 50 37 0A 01 56 44 50 38 14 13 44 49 4E 49 02 A0  P7..VDP8..DINI..
  8F10: 0C 93 68 0A 02 70 0A 01 56 44 50 38 14 16 5F 44  ..h..p..VDP8.._D
  8F20: 4F 53 01 70 68 56 44 50 38 56 44 50 31 0A 01 56  OS.phVDP8VDP1..V
  8F30: 44 50 38 14 28 5F 44 4F 44 00 A4 12 20 06 0C 00  DP8.(_DOD... ...
  8F40: 01 00 80 0C 00 24 00 80 0C 02 73 00 80 0C 03 73  .....$....s....s
  8F50: 00 80 0C 00 63 00 80 0C 01 63 00 80 5B 82 4B 05  ....c....c..[.K.
  8F60: 43 52 54 5F 14 20 5F 41 44 52 00 A0 13 95 4F 53  CRT_. _ADR....OS
  8F70: 49 44 0A 20 A4 7B 0C 00 01 00 80 0B FF FF 00 A4  ID. .{..........
  8F80: 0C 00 01 00 80 14 12 5F 44 43 53 00 70 56 44 50  ......._DCS.pVDP
  8F90: 31 0A 02 0A 02 60 A4 60 14 12 5F 44 47 53 00 70  1....`.`.._DGS.p
  8FA0: 56 44 50 31 0A 03 0A 02 60 A4 60 14 0D 5F 44 53  VDP1....`.`.._DS
  8FB0: 53 01 56 44 50 32 0A 02 68 5B 82 46 18 4C 43 44  S.VDP2..h[.F.LCD
  8FC0: 5F 14 20 5F 41 44 52 00 A0 13 95 4F 53 49 44 0A  _. _ADR....OSID.
  8FD0: 20 A4 7B 0C 00 24 00 80 0B FF FF 00 A4 0C 00 24   .{..$.........$
  8FE0: 00 80 14 12 5F 44 43 53 00 70 56 44 50 31 0A 02  ...._DCS.pVDP1..
  8FF0: 0A 01 60 A4 60 14 12 5F 44 47 53 00 70 56 44 50  ..`.`.._DGS.pVDP
  9000: 31 0A 03 0A 01 60 A4 60 14 0D 5F 44 53 53 01 56  1....`.`.._DSS.V
  9010: 44 50 32 0A 01 68 08 42 52 54 30 0A 64 08 44 42  DP2..h.BRT0.d.DB
  9020: 43 4C 12 02 12 14 48 05 5F 42 43 4C 08 08 42 52  CL....H._BCL..BR
  9030: 54 31 11 03 0A 12 8C 42 52 54 31 0A 00 42 52 54  T1.....BRT1..BRT
  9040: 32 70 0A 01 42 52 54 32 70 47 45 4E 53 0A 09 42  2p..BRT2pGENS..B
  9050: 52 54 31 87 42 52 54 31 62 70 0A 00 60 70 0A 12  RT1.BRT1bp..`p..
  9060: 61 A2 17 95 60 61 70 42 42 52 44 62 60 63 70 63  a...`apBBRDb`cpc
  9070: 88 44 42 43 4C 60 00 75 60 A4 44 42 43 4C 14 48  .DBCL`.u`.DBCL.H
  9080: 04 5F 42 43 4D 09 08 42 52 54 33 11 03 0A 02 8C  ._BCM..BRT3.....
  9090: 42 52 54 33 0A 00 42 52 54 34 8C 42 52 54 33 0A  BRT3..BRT4.BRT3.
  90A0: 01 42 52 54 35 70 0A 02 42 52 54 34 70 68 42 52  .BRT5p..BRT4phBR
  90B0: 54 35 70 68 42 52 54 30 47 45 4E 53 0A 09 42 52  T5phBRT0GENS..BR
  90C0: 54 33 87 42 52 54 33 14 1A 5F 42 51 43 08 70 47  T3.BRT3.._BQC.pG
  90D0: 45 4E 53 0A 09 0A 03 0A 00 60 70 60 42 52 54 30  ENS......`p`BRT0
  90E0: A4 60 10 4E 05 5C 2F 04 5F 53 42 5F 50 43 49 30  .`.N.\/._SB_PCI0
  90F0: 41 47 50 5F 56 49 44 5F 14 48 04 42 52 54 36 02  AGP_VID_.H.BRT6.
  9100: A0 1F 93 68 0A 01 86 5C 2F 05 5F 53 42 5F 50 43  ...h...\/._SB_PC
  9110: 49 30 41 47 50 5F 56 49 44 5F 4C 43 44 5F 0A 86  I0AGP_VID_LCD_..
  9120: A0 20 7B 68 0A 02 00 86 5C 2F 05 5F 53 42 5F 50  . {h....\/._SB_P
  9130: 43 49 30 41 47 50 5F 56 49 44 5F 4C 43 44 5F 0A  CI0AGP_VID_LCD_.
  9140: 87 5B 82 4B 05 44 56 49 5F 14 20 5F 41 44 52 00  .[.K.DVI_. _ADR.
  9150: A0 13 95 4F 53 49 44 0A 20 A4 7B 0C 02 73 00 80  ...OSID. .{..s..
  9160: 0B FF FF 00 A4 0C 02 73 00 80 14 12 5F 44 43 53  .......s...._DCS
  9170: 00 70 56 44 50 31 0A 02 0A 08 60 A4 60 14 12 5F  .pVDP1....`.`.._
  9180: 44 47 53 00 70 56 44 50 31 0A 03 0A 08 60 A4 60  DGS.pVDP1....`.`
  9190: 14 0D 5F 44 53 53 01 56 44 50 32 0A 08 68 5B 82  .._DSS.VDP2..h[.
  91A0: 4B 05 44 56 49 32 14 20 5F 41 44 52 00 A0 13 95  K.DVI2. _ADR....
  91B0: 4F 53 49 44 0A 20 A4 7B 0C 03 73 00 80 0B FF FF  OSID. .{..s.....
  91C0: 00 A4 0C 03 73 00 80 14 12 5F 44 43 53 00 70 56  ....s...._DCS.pV
  91D0: 44 50 31 0A 02 0A 10 60 A4 60 14 12 5F 44 47 53  DP1....`.`.._DGS
  91E0: 00 70 56 44 50 31 0A 03 0A 10 60 A4 60 14 0D 5F  .pVDP1....`.`.._
  91F0: 44 53 53 01 56 44 50 32 0A 10 68 5B 82 4B 05 44  DSS.VDP2..h[.K.D
  9200: 50 5F 5F 14 20 5F 41 44 52 00 A0 13 95 4F 53 49  P__. _ADR....OSI
  9210: 44 0A 20 A4 7B 0C 00 63 00 80 0B FF FF 00 A4 0C  D. .{..c........
  9220: 00 63 00 80 14 12 5F 44 43 53 00 70 56 44 50 31  .c...._DCS.pVDP1
  9230: 0A 02 0A 20 60 A4 60 14 12 5F 44 47 53 00 70 56  ... `.`.._DGS.pV
  9240: 44 50 31 0A 03 0A 20 60 A4 60 14 0D 5F 44 53 53  DP1... `.`.._DSS
  9250: 01 56 44 50 32 0A 20 68 5B 82 4B 05 44 50 32 5F  .VDP2. h[.K.DP2_
  9260: 14 20 5F 41 44 52 00 A0 13 95 4F 53 49 44 0A 20  . _ADR....OSID. 
  9270: A4 7B 0C 01 63 00 80 0B FF FF 00 A4 0C 01 63 00  .{..c.........c.
  9280: 80 14 12 5F 44 43 53 00 70 56 44 50 31 0A 02 0A  ..._DCS.pVDP1...
  9290: 40 60 A4 60 14 12 5F 44 47 53 00 70 56 44 50 31  @`.`.._DGS.pVDP1
  92A0: 0A 03 0A 40 60 A4 60 14 0D 5F 44 53 53 01 56 44  ...@`.`.._DSS.VD
  92B0: 50 32 0A 40 68 14 37 55 43 4D 50 02 A0 09 92 93  P2.@h.7UCMP.....
  92C0: 0A 10 87 68 A4 00 A0 09 92 93 0A 10 87 69 A4 00  ...h.........i..
  92D0: 70 00 60 A2 17 95 60 0A 10 A0 0F 92 93 83 88 68  p.`...`........h
  92E0: 60 00 83 88 69 60 00 A4 00 75 60 A4 01 14 40 0C  `...i`...u`...@.
  92F0: 5F 44 53 4D 0C 08 5F 54 5F 30 00 A0 4C 0A 93 55  _DSM.._T_0..L..U
  9300: 43 4D 50 68 11 13 0A 10 75 0B A5 D4 C7 65 F7 46  CMPh....u....e.F
  9310: BF B7 41 51 4C EA 02 44 01 A0 0D 92 93 69 0B 02  ..AQL..D.....i..
  9320: 01 A4 0C 02 00 00 80 70 6A 5F 54 5F 30 A0 19 93  .......pj_T_0...
  9330: 5F 54 5F 30 0A 00 56 44 50 31 0A 06 0A 00 A4 11  _T_0..VDP1......
  9340: 07 0A 04 21 00 08 00 A1 4A 05 A0 43 04 93 5F 54  ...!....J..C.._T
  9350: 5F 30 0A 05 8A 6B 0A 00 44 53 54 53 A0 28 7B 44  _0...k..DSTS.({D
  9360: 53 54 53 0C 00 00 00 01 00 7B 44 53 54 53 0B FF  STS......{DSTS..
  9370: 0F 47 41 54 44 7B 7A 44 53 54 53 0A 0C 00 0B FF  .GATD{zDSTS.....
  9380: 0F 47 41 43 44 A4 11 07 0A 04 00 00 00 00 A1 13  .GACD...........
  9390: A0 11 93 5F 54 5F 30 0A 13 A4 11 07 0A 04 00 06  ..._T_0.........
  93A0: 00 00 A4 0C 02 00 00 80 A4 0C 01 00 00 80 14 25  ...............%
  93B0: 45 56 44 31 02 A0 1E 93 45 56 44 35 0A 01 86 5C  EVD1....EVD5...\
  93C0: 2F 04 5F 53 42 5F 50 43 49 30 41 47 50 5F 56 49  /._SB_PCI0AGP_VI
  93D0: 44 5F 0A 80 14 44 04 45 56 44 32 02 A0 3C 93 45  D_...D.EVD2..<.E
  93E0: 56 44 35 0A 01 A0 1B 93 69 0A 00 86 5C 2F 04 5F  VD5.....i...\/._
  93F0: 53 42 5F 50 43 49 30 41 47 50 5F 56 49 44 5F 0A  SB_PCI0AGP_VID_.
  9400: D1 A1 17 86 5C 2F 04 5F 53 42 5F 50 43 49 30 41  ....\/._SB_PCI0A
  9410: 47 50 5F 56 49 44 5F 0A D2 14 37 45 56 44 33 02  GP_VID_...7EVD3.
  9420: A0 30 93 68 0A 03 A0 2A 93 45 56 44 35 0A 01 A0  .0.h...*.EVD5...
  9430: 0F 95 4F 53 49 44 0A 20 56 44 50 31 0A 05 69 86  ..OSID. VDP1..i.
  9440: 5C 2E 5F 53 42 5F 4C 49 44 5F 0A 80 5B 22 0B F4  \._SB_LID_..["..
  9450: 01 10 48 24 5C 00 5B 01 53 4D 49 58 01 08 53 4D  ..H$\.[.SMIX..SM
  9460: 49 42 0C 00 C0 74 CF 08 50 53 4D 49 0C B2 00 00  IB...t..PSMI....
  9470: 00 14 26 53 4E 56 43 01 5B 80 57 57 50 52 00 53  ..&SNVC.[.WWPR.S
  9480: 4D 49 42 0A 04 5B 81 0B 57 57 50 52 13 53 43 44  MIB..[..WWPR.SCD
  9490: 57 20 70 68 53 43 44 57 14 3C 53 4E 57 42 02 70  W phSCDW.<SNWB.p
  94A0: 53 4D 49 42 60 72 60 69 60 72 60 0A 04 60 5B 80  SMIB`r`i`r`..`[.
  94B0: 57 57 50 52 00 60 0A 01 5B 81 0B 57 57 50 52 11  WWPR.`..[..WWPR.
  94C0: 53 42 59 30 08 8C 68 69 53 56 41 4C 70 53 56 41  SBY0..hiSVALpSVA
  94D0: 4C 53 42 59 30 14 3E 53 4E 52 42 02 70 53 4D 49  LSBY0.>SNRB.pSMI
  94E0: 42 60 72 60 69 60 72 60 0A 04 60 5B 80 57 57 50  B`r`i`r`..`[.WWP
  94F0: 52 00 60 0A 04 5B 81 0B 57 57 50 52 11 53 42 59  R.`..[..WWPR.SBY
  9500: 30 08 8C 68 69 53 56 41 4C 70 53 42 59 30 53 56  0..hiSVALpSBY0SV
  9510: 41 4C A4 68 14 3C 53 4E 56 50 02 70 53 4D 49 42  AL.h.<SNVP.pSMIB
  9520: 60 72 60 69 60 72 60 0A 04 60 5B 80 57 57 50 52  `r`i`r`..`[.WWPR
  9530: 00 60 0A 04 5B 81 0B 57 57 50 52 11 53 44 57 30  .`..[..WWPR.SDW0
  9540: 20 8A 68 69 53 56 41 4C 70 53 56 41 4C 53 44 57   .hiSVALpSVALSDW
  9550: 30 14 3E 53 4E 56 47 02 70 53 4D 49 42 60 72 60  0.>SNVG.pSMIB`r`
  9560: 69 60 72 60 0A 04 60 5B 80 57 57 50 52 00 60 0A  i`r`..`[.WWPR.`.
  9570: 04 5B 81 0B 57 57 50 52 11 53 44 57 30 20 8A 68  .[..WWPR.SDW0 .h
  9580: 69 53 56 41 4C 70 53 44 57 30 53 56 41 4C A4 68  iSVALpSDW0SVAL.h
  9590: 14 38 47 45 4E 53 03 5B 23 53 4D 49 58 FF FF 70  .8GENS.[#SMIX..p
  95A0: 69 60 A0 0E 93 8E 69 0A 01 70 53 4D 42 49 68 69  i`....i..pSMBIhi
  95B0: 60 A0 0F 93 8E 69 0A 03 70 53 4D 42 46 68 69 6A  `....i..pSMBFhij
  95C0: 60 5B 27 53 4D 49 58 A4 60 14 39 53 4D 42 49 02  `['SMIX.`.9SMBI.
  95D0: 53 4E 56 43 68 72 53 4D 49 42 0A 04 60 5B 80 57  SNVChrSMIB..`[.W
  95E0: 57 50 52 00 60 0A 04 5B 81 0B 57 57 50 52 11 53  WPR.`..[..WWPR.S
  95F0: 44 57 30 20 70 69 53 44 57 30 41 53 4D 49 A4 53  DW0 piSDW0ASMI.S
  9600: 44 57 30 14 4E 06 53 4D 42 46 03 A0 07 94 6A 0A  DW0.N.SMBF....j.
  9610: FC A4 69 A0 07 95 87 69 6A A4 69 53 4E 56 43 68  ..i....ij.iSNVCh
  9620: 78 6A 0A 04 63 64 70 0A 00 60 A2 0C 95 60 63 53  xj..cdp..`...`cS
  9630: 4E 57 42 69 60 75 60 A2 0F 95 60 6A 53 4E 56 50  NWBi`u`...`jSNVP
  9640: 69 60 72 60 0A 04 60 41 53 4D 49 70 0A 00 60 A2  i`r`..`ASMIp..`.
  9650: 0E 95 60 63 70 53 4E 52 42 69 60 69 75 60 A2 11  ..`cpSNRBi`iu`..
  9660: 95 60 6A 70 53 4E 56 47 69 60 69 72 60 0A 04 60  .`jpSNVGi`ir`..`
  9670: A4 69 14 27 41 53 4D 49 00 5B 80 53 4D 49 52 01  .i.'ASMI.[.SMIR.
  9680: 50 53 4D 49 0A 01 5B 81 0B 53 4D 49 52 11 53 43  PSMI..[..SMIR.SC
  9690: 4D 44 08 70 0A 04 53 43 4D 44 10 4B 67 5C 5F 53  MD.p..SCMD.Kg\_S
  96A0: 42 5F 5B 82 42 67 41 4D 57 30 5B 01 57 4D 49 58  B_[.BgAMW0[.WMIX
  96B0: 01 08 5F 48 49 44 0D 2A 70 6E 70 30 63 31 34 00  .._HID.*pnp0c14.
  96C0: 08 5F 55 49 44 0A 00 08 5F 57 44 47 11 48 06 0A  ._UID..._WDG.H..
  96D0: 64 BC DC 9D 8D 97 A9 DA 11 B0 12 B6 22 A1 EF 54  d..........."..T
  96E0: 92 41 41 01 00 CE 93 05 A8 97 A9 DA 11 B0 12 B6  .AA.............
  96F0: 22 A1 EF 54 92 42 41 01 02 94 59 BB 9D 97 A9 DA  "..T.BA...Y.....
  9700: 11 B0 12 B6 22 A1 EF 54 92 D0 00 01 08 E0 6C 77  ...."..T......lw
  9710: A3 88 1E DB 11 A9 8B 08 00 20 0C 9A 66 42 43 01  ......... ..fBC.
  9720: 00 21 12 90 05 66 D5 D1 11 B2 F0 00 A0 C9 06 29  .!...f.........)
  9730: 10 4D 4F 01 00 08 49 4E 46 4F 11 03 0A 80 08 45  .MO...INFO.....E
  9740: 43 44 30 0A 00 14 0E 57 45 44 30 01 70 68 45 43  CD0....WED0.phEC
  9750: 44 30 A4 00 14 08 57 43 41 41 01 A4 00 14 4A 06  D0....WCAA....J.
  9760: 57 51 41 41 01 5B 23 57 4D 49 58 FF FF 42 43 4C  WQAA.[#WMIX..BCL
  9770: 52 49 4E 46 4F A0 0C 92 93 68 0A 00 70 49 4E 46  RINFO....h..pINF
  9780: 4F 61 A1 3D 42 44 57 52 49 4E 46 4F 0A 00 0C 44  Oa.=BDWRINFO...D
  9790: 45 4C 4C 42 44 57 52 49 4E 46 4F 0A 04 0C 20 57  ELLBDWRINFO... W
  97A0: 4D 49 42 44 57 52 49 4E 46 4F 0A 08 0A 01 42 44  MIBDWRINFO....BD
  97B0: 57 52 49 4E 46 4F 0A 0C 0A 80 70 49 4E 46 4F 61  WRINFO....pINFOa
  97C0: 5B 27 57 4D 49 58 A4 61 14 08 57 53 41 41 02 A4  ['WMIX.a..WSAA..
  97D0: 69 14 27 57 4D 42 41 03 8A 6A 0A 28 57 42 55 46  i.'WMBA..j.(WBUF
  97E0: 72 57 42 55 46 0A 2C 61 A0 0E 92 94 61 0A 80 70  rWBUF.,a....a..p
  97F0: 57 4D 49 5F 6A 61 60 A4 60 14 19 57 4D 49 5F 02  WMI_ja`.`..WMI_.
  9800: A0 10 92 94 69 0A 80 70 47 45 4E 53 0A 03 68 69  ....i..pGENS..hi
  9810: 68 A4 68 08 57 51 4D 4F 11 4D 4F 0B F8 04 46 4F  h.h.WQMO.MO...FO
  9820: 4D 42 01 00 00 00 E8 04 00 00 D8 15 00 00 44 53  MB............DS
  9830: 00 01 1A 7D DA 54 28 D5 8A 00 01 06 18 42 10 0D  ...}.T(......B..
  9840: 10 22 21 04 12 01 A1 C8 2C 0C 86 10 38 2E 84 1C  ."!.....,...8...
  9850: 40 48 1C 14 4A 08 84 FA 13 C8 AF 00 84 0E 05 C8  @H..J...........
  9860: 14 60 50 80 53 04 11 F4 2A C0 A6 00 93 02 2C 0A  .`P.S...*.....,.
  9870: D0 2E C0 B2 00 DD 02 A4 C3 12 91 E0 28 31 E0 28  ............(1.(
  9880: 9D D8 C2 0D 1B BC 50 14 CD 20 4A 82 CA 05 F8 46  ......P.. J....F
  9890: 10 78 B9 02 24 4F 40 9A 05 18 16 60 5D 80 EC 21  .x..$O@....`]..!
  98A0: 50 A9 43 40 C9 19 02 6A 00 AD 4E 40 F8 95 4E 09  P.C@...j..N@..N.
  98B0: 49 10 CE 58 C5 E3 6B 16 4D CF 49 CE 31 E4 78 5C  I..X..k.M.I.1.x\
  98C0: E8 41 F0 40 0A 40 58 78 08 45 80 41 49 18 0B 75  .A.@.@Xx.E.AI..u
  98D0: 31 6A D4 48 D9 80 0C 51 DA A8 D1 03 3A BF 23 39  1j.H...Q....:.#9
  98E0: BB A3 3B 92 04 46 3D A6 63 2C 6C 46 42 8D D1 1C  ..;..F=.c,lFB...
  98F0: 14 81 C6 0D DA 12 61 35 AE D8 67 66 E1 C3 12 C6  ......a5..gf....
  9900: 11 1C 58 82 46 D1 34 C7 B3 0D 91 E0 20 42 63 64  ..X.F.4..... Bcd
  9910: 40 C8 F3 B0 05 7A E4 09 EC 1E 51 0A 11 34 DF 13  @....z....Q..4..
  9920: A9 51 80 36 0C D9 3A 1B 68 A8 B1 1A 43 11 44 84  .Q.6..:.h...C.D.
  9930: A0 51 0C 16 21 54 88 FF 7F 94 A8 A7 14 24 6A 65  .Q..!T.......$je
  9940: 20 42 0B 66 04 66 7F 10 24 C6 99 41 87 05 CB 00   B.f.f..$..A....
  9950: 91 11 41 A3 61 67 01 0F C7 33 69 7E 62 1A 9C 09  ..A.ag...3i~b...
  9960: C6 3E 3F 50 51 07 07 4A 60 29 03 27 B6 C7 A5 F1  .>?PQ..J`).'....
  9970: 9D 71 D4 10 A7 7E 66 FE 47 78 0B 3E 02 F0 31 78  .q...~f.Gx.>..1x
  9980: B0 87 10 F0 08 D9 19 C0 80 78 EF 93 26 73 F1 59  .........x..&s.Y
  9990: 00 C6 F0 E1 1A 1F 85 C6 C3 CE 07 6C 5C 1C DE 87  ...........l\...
  99A0: 82 13 2E 16 44 01 20 24 EB 7C 80 9E F5 B1 05 7C  ....D. $.|.....|
  99B0: 18 68 F6 0E 41 08 5E 04 7C 74 F0 71 C3 E3 7E DE  .h..A.^.|t.q..~.
  99C0: 00 C3 E1 C0 C3 F1 69 03 B8 8C 80 4B 7B 52 98 40  ......i....K{R.@
  99D0: 92 9F 00 12 03 83 3A 10 F8 60 01 57 12 1C 6A 78  ......:..`.W..jx
  99E0: 9E D8 03 C2 FF FF 28 4F E4 C5 C0 D3 7F 0C 80 71  ......(O.......q
  99F0: 40 F0 B4 4E CA 37 8F 07 09 0F 2A 4C 02 9F 12 18  @..N.7....*L....
  9A00: 1A 3F 6E 80 75 D4 F8 03 02 BC 93 C4 F9 F5 39 00  .?n.u.........9.
  9A10: 1D 1A 4E 91 81 BC 06 9C F4 29 79 7C 09 7C E6 80  ..N......)y|.|..
  9A20: 7D 37 38 8C 83 09 11 E1 3D E0 A9 C3 77 8D 47 81  }78.....=...w.G.
  9A30: 40 11 7A 3B 73 D0 53 88 51 A2 9D 55 98 07 8E 28  @.z;s.S.Q..U...(
  9A40: 3E 72 18 E1 DD C3 77 82 07 90 D6 26 27 DC 40 CF  >r....w....&'.@.
  9A50: 1C 2C DA 99 45 16 40 14 69 34 A8 33 82 4F 03 9E  .,..E.@.i4.3.O..
  9A60: D6 53 8C 8F 12 06 39 C3 03 7B 4E 78 0C F0 80 D9  .S....9..{Nx....
  9A70: FD C0 C7 09 9F 0B F0 AE 01 35 43 1F 36 E0 1C 3A  .........5C.6..:
  9A80: F0 A7 09 FC C1 02 3F 1E 5F 73 D8 84 13 58 FE 20  ......?._s...X. 
  9A90: 50 23 33 B4 67 79 5A AF 01 3E ED 98 C0 E7 0D FF  P#3.gyZ..>......
  9AA0: FF FF 39 1E 0F F8 15 9F 2E C8 5D C1 F3 F5 D9 85  ..9.......].....
  9AB0: D9 18 0F 6A 14 3E E0 E0 CE 2E 3E 02 F8 EC 02 3C  ...j.>....>....<
  9AC0: 27 F1 2C 01 DE 43 80 4F 24 F1 1E B6 60 8C 18 0F  '.,..C.O$...`...
  9AD0: 79 C6 55 0F 43 17 01 AB BB AF A0 8E 5E 60 82 7A  y.U.C.......^`.z
  9AE0: CD C0 9D 5E 80 CF 29 0B DE FF FF 94 05 DC AF 0A  ...^..).........
  9AF0: FC 88 02 06 C8 CE 4E 27 42 78 2F 79 0E F1 ED CA  ......N'Bx/y....
  9B00: 07 93 20 CF 01 11 9E B2 F8 7D 20 4A CC 03 8A 14  .. ......} J....
  9B10: C5 88 41 9E B0 7C 3D 89 61 E8 60 E1 C2 47 78 CA  ..A..|=.a.`..Gx.
  9B20: 02 2C 5E B2 30 A7 2C 60 F0 FF 3F 65 81 6B DC 4F  .,^.0.,`..?e.k.O
  9B30: 59 C0 4C FA 73 92 9C 6A F4 04 50 F4 83 05 85 F1  Y.L.s..j..P.....
  9B40: 29 0B 70 25 EF 80 00 9A B3 93 6F 0B 06 3B 66 5F  ).p%......o..;f_
  9B50: 32 7C 4A 04 C3 21 C3 77 AA 43 79 E4 78 0A F0 11  2|J..!.w.Cy.x...
  9B60: 0B EC 71 8E 01 3A AE F8 88 E5 FF FF 11 0B E0 C6  ..q..:..........
  9B70: 01 04 7F EA 80 75 0F 08 EB 43 07 F0 90 FD 10 D0  .....u...C......
  9B80: 19 C6 92 41 64 E3 5C 43 C7 68 F1 0B D5 4D 21 F6  ...Ad.\C.h...M!.
  9B90: C1 70 D9 40 02 F5 70 2D 98 42 A2 68 34 1A 03 13  .p.@..p-.B.h4...
  9BA0: 18 C1 19 C4 80 CE 08 A1 43 19 4E C5 79 08 F5 FF  ........C.N.y...
  9BB0: 27 18 EA C6 44 67 E7 F9 F3 DB 88 4F 04 06 F6 15  '...Dg.....O....
  9BC0: E2 2D 03 2C C3 F2 E2 9E 00 8E F1 24 13 54 73 AC  .-.,.......$.Ts.
  9BD0: 41 CD C1 57 81 37 32 13 F8 0A 06 B6 D3 0C 46 DF  A..W.72.......F.
  9BE0: 9D 00 14 40 3E 0A F8 BE FC 36 C0 66 F1 CA 6C 34  ...@>....6.f..l4
  9BF0: 9F 3F 11 43 47 89 19 3A 05 F1 D0 1D 74 E8 E8 E3  .?.CG..:....t...
  9C00: 80 4F 56 B8 60 87 2F 68 93 3B DA 13 F3 2C 3C 4F  .OV.`./h.;...,<O
  9C10: DC DC C1 74 44 82 31 78 CC E4 C1 2C 70 F2 A0 F8  ...tD.1x...,p...
  9C20: FF 4F 1E 26 3C 26 EC E1 90 1E 3A 3C 32 3E 4E 9F  .O.&<&....:<2>N.
  9C30: 7E 18 F6 E9 9C 4B D1 33 D2 1D E3 99 0B 03 EB 91  ~....K.3........
  9C40: 73 58 A3 85 3D E0 E7 10 DF 61 7C E0 61 B0 3E BD  sX..=....a|.a.>.
  9C50: 80 E3 F8 05 FF 34 00 9E 03 88 C7 F0 02 C2 8F 2F  .....4........./
  9C60: 3A FF 52 A1 8B 93 3C 18 D4 69 0A 70 75 7A 03 CF  :.R...<..i.puz..
  9C70: 55 1F 77 96 C2 FD FF CF 52 30 0E BF BE C0 FB 2E  U.w.....R0......
  9C80: 65 84 03 79 96 02 7B EC 67 88 0E 01 3E 4B 01 FC  e..y..{.g...>K..
  9C90: 78 7D F8 3C 03 37 F0 E9 17 68 FD FF 4F 21 E0 3F  x}.<.7...h..O!.?
  9CA0: 46 F8 88 83 3B FA 02 B7 83 31 3F 63 E0 8E 63 C0  F...;....1?c..c.
  9CB0: E3 E4 8C 3B 4D 78 08 7C 00 AD 4E 8F 9C 7A 4E 09  ...;Mx.|..N..zN.
  9CC0: 77 1C E0 53 C2 0D 00 A3 D0 A6 4F 8D 46 AD 1A 94  w..S......O.F...
  9CD0: A9 51 A6 41 AD 3E 95 1A 33 A6 03 CE AF 03 1D 0F  .Q.A.>..3.......
  9CE0: 1C EA 85 20 10 4B 7A 75 08 C4 A2 3C 80 B0 B8 26  ... .Kzu...<...&
  9CF0: 40 98 F0 37 81 40 1C 1B 84 8A A5 97 91 F1 19 44  @..7.@.........D
  9D00: 40 0E E1 03 88 45 02 11 38 51 02 4A 9D 80 30 A1  @....E..8Q.J..0.
  9D10: AF 06 81 F8 FF 0F 10 40 17 5C 2E 5F 53 42 5F 41  .......@.\._SB_A
  9D20: 4D 57 30 08 57 4D 45 56 0A 00 08 57 4D 42 55 11  MW0.WMEV...WMBU.
  9D30: 03 0A 80 08 57 4D 5F 5F 0A 00 14 10 53 57 45 56  ....WM__....SWEV
  9D40: 01 7D 57 4D 45 56 68 57 4D 45 56 14 12 43 57 45  .}WMEVhWMEV..CWE
  9D50: 56 01 7B 57 4D 45 56 80 68 00 57 4D 45 56 14 1D  V.{WMEV.h.WMEV..
  9D60: 57 56 53 50 00 5B 23 57 4D 49 58 FF FF 70 0A 00  WVSP.[#WMIX..p..
  9D70: 57 4D 5F 5F 42 43 4C 52 57 4D 42 55 14 15 57 56  WM__BCLRWMBU..WV
  9D80: 43 55 00 5B 23 57 4D 49 58 FF FF 70 0A 00 57 4D  CU.[#WMIX..p..WM
  9D90: 5F 5F 14 34 57 56 50 54 01 70 57 4D 5F 5F 60 72  __.4WVPT.pWM__`r
  9DA0: 60 0A 02 60 A0 22 92 94 60 87 57 4D 42 55 8B 57  `..`."..`.WMBU.W
  9DB0: 4D 42 55 57 4D 5F 5F 57 4D 57 44 70 68 57 4D 57  MBUWM__WMWDphWMW
  9DC0: 44 70 60 57 4D 5F 5F 14 4F 0B 5F 57 45 44 01 57  Dp`WM__.O._WED.W
  9DD0: 56 53 50 A0 0F 92 93 68 0A D0 57 56 43 55 A4 57  VSP....h..WVCU.W
  9DE0: 4D 42 55 A0 11 93 45 43 44 30 0A 00 57 56 43 55  MBU...ECD0..WVCU
  9DF0: A4 57 4D 42 55 A0 24 7B 57 4D 45 56 0B 00 02 00  .WMBU.${WMEV....
  9E00: 43 57 45 56 0B 00 02 57 56 50 54 0A 02 57 56 50  CWEV...WVPT..WVP
  9E10: 54 0A 00 57 56 50 54 0B 45 E0 A1 43 06 A0 3F 7B  T..WVPT.E..C..?{
  9E20: 57 4D 45 56 0B 00 01 00 43 57 45 56 0B 00 01 A0  WMEV....CWEV....
  9E30: 18 45 43 47 34 57 56 50 54 0A 02 57 56 50 54 0A  .ECG4WVPT..WVPT.
  9E40: 00 57 56 50 54 0B 43 E0 A1 14 57 56 50 54 0A 02  .WVPT.C...WVPT..
  9E50: 57 56 50 54 0A 00 57 56 50 54 0B 44 E0 A1 20 A0  WVPT..WVPT.D.. .
  9E60: 1E 7B 57 4D 45 56 0B 00 08 00 70 45 43 30 41 57  .{WMEV....pEC0AW
  9E70: 4D 42 55 57 4D 42 55 43 57 45 56 0B 00 08 57 56  MBUWMBUCWEV...WV
  9E80: 43 55 A4 57 4D 42 55 10 27 5C 00 14 23 57 4D 4E  CU.WMBU.'\..#WMN
  9E90: 46 02 5C 2F 03 5F 53 42 5F 41 4D 57 30 53 57 45  F.\/._SB_AMW0SWE
  9EA0: 56 68 86 5C 2E 5F 53 42 5F 41 4D 57 30 0A D0 10  Vh.\._SB_AMW0...
  9EB0: 4C 04 5C 2F 03 5F 53 42 5F 50 43 49 30 4C 50 43  L.\/._SB_PCI0LPC
  9EC0: 42 5B 82 39 50 53 32 4D 08 5F 48 49 44 0C 11 8C  B[.9PS2M._HID...
  9ED0: 04 0A 08 5F 43 49 44 0C 41 D0 0F 13 08 5F 43 52  ..._CID.A...._CR
  9EE0: 53 11 09 0A 06 23 00 10 01 79 00 08 5F 50 52 53  S....#...y.._PRS
  9EF0: 11 0B 0A 08 31 00 22 00 10 38 79 00 14 0F 5C 41  ....1."..8y...\A
  9F00: 57 41 4B 01 A4 12 06 02 0A 00 0A 00 14 07 5C 41  WAK...........\A
  9F10: 50 54 53 01 08 5C 5F 53 30 5F 12 0A 04 0A 00 0A  PTS..\_S0_......
  9F20: 00 0A 00 0A 00 08 5C 5F 53 33 5F 12 0A 04 0A 05  ......\_S3_.....
  9F30: 0A 00 0A 00 0A 00 08 5C 5F 53 34 5F 12 0A 04 0A  .......\_S4_....
  9F40: 06 0A 00 0A 00 0A 00 08 5C 5F 53 35 5F 12 0A 04  ........\_S5_...
  9F50: 0A 07 0A 00 0A 00 0A 00 14 14 5F 50 54 53 01 5C  .........._PTS.\
  9F60: 41 50 54 53 68 5C 45 56 35 5F 68 0A 00 14 17 5F  APTSh\EV5_h...._
  9F70: 57 41 4B 01 5C 45 56 32 5F 68 0A 00 5C 41 57 41  WAK.\EV2_h..\AWA
  9F80: 4B 68 A4 0A 00 10 1B 5C 2E 5F 53 42 5F 50 43 49  Kh.....\._SB_PCI
  9F90: 30 14 0F 5F 49 4E 49 00 5C 45 56 31 5F 0A 02 0A  0.._INI.\EV1_...
  9FA0: 00 14 20 5C 45 56 39 5F 02 5C 2F 05 5F 53 42 5F  .. \EV9_.\/._SB_
  9FB0: 50 43 49 30 41 47 50 5F 56 49 44 5F 45 56 44 32  PCI0AGP_VID_EVD2
  9FC0: 68 69 14 13 5C 45 56 31 31 02 5C 2E 5F 53 42 5F  hi..\EV11.\._SB_
  9FD0: 42 54 45 56 68 69 14 1C 5C 45 56 37 5F 02 5C 2F  BTEVhi..\EV7_.\/
  9FE0: 04 5F 53 42 5F 50 43 49 30 4C 50 43 42 44 43 4B  ._SB_PCI0LPCBDCK
  9FF0: 34 68 69 14 35 5C 45 56 31 33 02 5C 2F 05 5F 53  4hi.5\EV13.\/._S
  A000: 42 5F 50 43 49 30 41 47 50 5F 56 49 44 5F 45 56  B_PCI0AGP_VID_EV
  A010: 44 31 68 69 5C 2F 04 5F 53 42 5F 50 43 49 30 56  D1hi\/._SB_PCI0V
  A020: 49 44 5F 49 56 44 31 68 69 14 0D 5C 45 56 38 5F  ID_IVD1hi..\EV8_
  A030: 02 57 4D 4E 46 68 69 14 20 5C 45 56 33 5F 02 5C  .WMNFhi. \EV3_.\
  A040: 2F 05 5F 53 42 5F 50 43 49 30 53 41 54 30 53 45  /._SB_PCI0SAT0SE
  A050: 43 30 4F 44 44 45 68 69 14 07 5C 45 56 31 35 02  C0ODDEhi..\EV15.
  A060: 14 13 5C 45 56 34 5F 02 5C 2E 5F 50 52 5F 50 50  ..\EV4_.\._PR_PP
  A070: 43 45 68 69 14 46 09 5C 45 56 31 5F 02 5C 2F 05  CEhi.F.\EV1_.\/.
  A080: 5F 53 42 5F 50 43 49 30 41 47 50 5F 56 49 44 5F  _SB_PCI0AGP_VID_
  A090: 44 49 4E 49 68 69 5C 2F 05 5F 53 42 5F 50 43 49  DINIhi\/._SB_PCI
  A0A0: 30 41 47 50 5F 56 49 44 5F 56 49 4E 49 68 69 5C  0AGP_VID_VINIhi\
  A0B0: 2F 03 5F 53 42 5F 50 43 49 30 49 49 4E 49 68 69  /._SB_PCI0IINIhi
  A0C0: 5C 2F 04 5F 53 42 5F 50 43 49 30 4C 50 43 42 45  \/._SB_PCI0LPCBE
  A0D0: 49 4E 49 68 69 5C 2F 04 5F 53 42 5F 50 43 49 30  INIhi\/._SB_PCI0
  A0E0: 56 49 44 5F 44 49 4E 49 68 69 5C 2F 04 5F 53 42  VID_DINIhi\/._SB
  A0F0: 5F 50 43 49 30 56 49 44 5F 56 49 4E 49 68 69 5C  _PCI0VID_VINIhi\
  A100: 2E 5F 53 42 5F 53 4F 53 30 68 69 14 22 5C 45 56  ._SB_SOS0hi."\EV
  A110: 35 5F 02 45 43 53 31 68 69 5C 2F 04 5F 53 42 5F  5_.ECS1hi\/._SB_
  A120: 50 43 49 30 56 49 44 5F 49 56 44 34 68 69 14 42  PCI0VID_IVD4hi.B
  A130: 04 5C 45 56 36 5F 02 5C 2E 5F 53 42 5F 42 54 4E  .\EV6_.\._SB_BTN
  A140: 56 68 69 5C 2F 05 5F 53 42 5F 50 43 49 30 41 47  Vhi\/._SB_PCI0AG
  A150: 50 5F 56 49 44 5F 45 56 44 33 68 69 5C 2F 04 5F  P_VID_EVD3hi\/._
  A160: 53 42 5F 50 43 49 30 56 49 44 5F 49 4C 44 45 68  SB_PCI0VID_ILDEh
  A170: 69 14 35 5C 45 56 31 32 02 5C 2F 05 5F 53 42 5F  i.5\EV12.\/._SB_
  A180: 50 43 49 30 41 47 50 5F 56 49 44 5F 42 52 54 36  PCI0AGP_VID_BRT6
  A190: 68 69 5C 2F 04 5F 53 42 5F 50 43 49 30 56 49 44  hi\/._SB_PCI0VID
  A1A0: 5F 42 52 54 36 68 69 14 1C 5C 45 56 31 34 02 5C  _BRT6hi..\EV14.\
  A1B0: 2F 04 5F 53 42 5F 50 43 49 30 56 49 44 5F 49 56  /._SB_PCI0VID_IV
  A1C0: 44 32 68 69 14 13 5C 45 56 31 30 02 5C 2E 5F 53  D2hi..\EV10.\._S
  A1D0: 42 5F 41 43 45 56 68 69 14 4F 06 5C 45 56 32 5F  B_ACEVhi.O.\EV2_
  A1E0: 02 5C 2E 5F 47 50 45 4E 57 41 4B 68 69 5C 2E 5F  .\._GPENWAKhi\._
  A1F0: 53 42 5F 43 42 41 54 68 69 5C 2F 04 5F 53 42 5F  SB_CBAThi\/._SB_
  A200: 50 43 49 30 4C 50 43 42 44 43 4B 35 68 69 5C 2F  PCI0LPCBDCK5hi\/
  A210: 05 5F 53 42 5F 50 43 49 30 4C 50 43 42 45 43 44  ._SB_PCI0LPCBECD
  A220: 56 45 43 4D 39 68 69 5C 2F 04 5F 53 42 5F 50 43  VECM9hi\/._SB_PC
  A230: 49 30 56 49 44 5F 49 56 44 33 68 69 5C 2E 5F 53  I0VID_IVD3hi\._S
  A240: 42 5F 53 4F 53 34 68 69                          B_SOS4hi

FACS @ 0x00000000CF76ED40
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0x00000000CF75FC18
  0000: 46 41 43 50 F4 00 00 00 04 53 44 45 4C 4C 20 20  FACP.....SDELL  
  0010: 45 32 20 20 20 20 20 00 04 20 22 06 4D 53 46 54  E2     .. ".MSFT
  0020: 13 00 01 00 40 BF 76 CF 18 E0 73 CF 01 00 09 00  ....@.v...s.....
  0030: B2 00 00 00 A0 A1 00 80 00 04 00 00 00 00 00 00  ................
  0040: 04 04 00 00 00 00 00 00 50 04 00 00 08 04 00 00  ........P.......
  0050: 20 04 00 00 00 00 00 00 04 02 01 04 10 00 00 85   ...............
  0060: 65 00 E9 03 00 04 10 00 01 03 7D 7E 32 13 00 00  e.........}~2...
  0070: A5 86 03 00 01 08 00 00 64 00 00 00 00 00 00 00  ........d.......
  0080: FE 00 00 00 40 ED 76 CF 00 00 00 00 18 E0 73 CF  ....@.v.......s.
  0090: 00 00 00 00 01 20 00 00 00 04 00 00 00 00 00 00  ..... ..........
  00A0: 01 00 00 00 00 00 00 00 00 00 00 00 01 10 00 00  ................
  00B0: 04 04 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  00C0: 00 00 00 00 01 08 00 00 50 04 00 00 00 00 00 00  ........P.......
  00D0: 01 20 00 00 08 04 00 00 00 00 00 00 01 80 00 00  . ..............
  00E0: 20 04 00 00 00 00 00 00 01 00 00 00 00 00 00 00   ...............
  00F0: 00 00 00 00                                      ....

APIC @ 0x00000000CF67CF18
  0000: 41 50 49 43 8C 00 00 00 02 D6 44 45 4C 4C 20 20  APIC......DELL  
  0010: 45 32 20 20 20 20 20 00 04 20 22 06 4D 53 46 54  E2     .. ".MSFT
  0020: 13 00 01 00 00 00 E0 FE 01 00 00 00 00 08 01 00  ................
  0030: 01 00 00 00 00 08 02 04 01 00 00 00 00 08 03 01  ................
  0040: 01 00 00 00 00 08 04 05 01 00 00 00 00 08 05 04  ................
  0050: 00 00 00 00 00 08 06 05 00 00 00 00 00 08 07 06  ................
  0060: 00 00 00 00 00 08 08 07 00 00 00 00 01 0C 02 00  ................
  0070: 00 00 C0 FE 00 00 00 00 02 0A 00 00 02 00 00 00  ................
  0080: 00 00 02 0A 00 09 09 00 00 00 0D 00              ............

TCPA @ 0x00000000CF76DD18
  0000: 54 43 50 41 32 00 00 00 02 AC 00 00 00 00 00 00  TCPA2...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 FF FF FF FF FF FF  ................
  0030: FF FF                                            ..

MCFG @ 0x00000000CF76DC98
  0000: 4D 43 46 47 3C 00 00 00 01 2C 41 20 4D 20 49 20  MCFG<....,A M I 
  0010: 47 4D 43 48 39 34 35 2E 04 20 22 06 4D 53 46 54  GMCH945.. ".MSFT
  0020: 97 00 00 00 00 00 00 00 00 00 00 00 00 00 00 F8  ................
  0030: 00 00 00 00 00 00 00 3F 00 00 00 00              .......?....

HPET @ 0x00000000CF76DC18
  0000: 48 50 45 54 38 00 00 00 01 DB 44 45 4C 4C 20 20  HPET8.....DELL  
  0010: 45 32 20 20 20 20 20 00 01 00 00 00 41 53 4C 20  E2     .....ASL 
  0020: 61 00 00 00 01 A7 86 80 00 40 00 00 00 00 D0 FE  a........@......
  0030: 00 00 00 00 00 EE 37 00                          ......7.

BOOT @ 0x00000000CF76DB98
  0000: 42 4F 4F 54 28 00 00 00 01 C3 44 45 4C 4C 20 20  BOOT(.....DELL  
  0010: 45 32 20 20 20 20 20 20 04 20 22 06 41 4D 49 20  E2      . ".AMI 
  0020: 13 00 01 00 F1 00 00 00                          ........

SLIC @ 0x00000000CF766818
  0000: 53 4C 49 43 76 01 00 00 03 04 44 45 4C 4C 20 20  SLICv.....DELL  
  0010: 45 32 20 20 20 20 20 00 04 20 22 06 4D 53 46 54  E2     .. ".MSFT
  0020: 13 00 01 00 00 00 00 00 9C 00 00 00 06 02 00 00  ................
  0030: 00 24 00 00 52 53 41 31 00 04 00 00 01 00 01 00  .$..RSA1........
  0040: 7F F6 C1 05 BE 5C 57 63 A5 8A 68 F3 6E 8F 06 FA  .....\Wc..h.n...
  0050: AF B4 9F 68 82 23 EC 50 40 5A 73 7F EC E4 07 CB  ...h.#.P@Zs.....
  0060: DC 25 1A 9C E3 E3 66 11 E0 A5 98 06 C5 80 0A FA  .%....f.........
  0070: 42 93 86 98 E7 D5 1B D4 D7 3A A4 0B EE E2 7D BE  B........:....}.
  0080: 5F 5B 15 0C AB D0 21 DE BF E9 B5 6E A4 57 B9 8C  _[....!....n.W..
  0090: 0C D2 BA 3A 69 30 76 94 71 A2 64 D7 4C D8 85 BF  ...:i0v.q.d.L...
  00A0: DF A5 6A C8 DC 45 D5 4D 8C B8 8C 05 2F FC 2E 23  ..j..E.M..../..#
  00B0: C4 29 C5 6F 3F 29 6C 6D 57 79 0E B6 75 ED 21 95  .).o?)lmWy..u.!.
  00C0: 01 00 00 00 B6 00 00 00 00 00 02 00 44 45 4C 4C  ............DELL
  00D0: 20 20 45 32 20 20 20 20 20 00 57 49 4E 44 4F 57    E2     .WINDOW
  00E0: 53 20 01 00 02 00 00 00 00 00 00 00 00 00 00 00  S ..............
  00F0: 00 00 00 00 00 00 4E FA 45 A8 BD BE 37 3B C9 C1  ......N.E...7;..
  0100: FC BD 77 66 D7 E6 D3 AC 94 F6 C0 88 A3 81 71 59  ..wf..........qY
  0110: 11 8F F7 AE 34 D3 38 DF B9 55 2C 71 74 CA 90 3F  ....4.8..U,qt..?
  0120: B1 34 D4 75 CC 89 05 14 51 0D 9A 83 8C 06 64 64  .4.u....Q.....dd
  0130: 67 4A 86 2D 2C FE 7B 5B 14 00 43 A0 D9 83 C8 8C  gJ.-,.{[..C.....
  0140: 2C 84 71 59 AB DC BB 7A D3 76 27 F0 F6 BE 74 C0  ,.qY...z.v'...t.
  0150: B9 2C E0 63 8E C4 8E 10 4B 8E E5 BF 24 6C E0 4D  .,.c....K...$l.M
  0160: B9 90 70 95 D6 18 4A 1C 59 F2 AD 84 F2 12 08 5B  ..p...J.Y......[
  0170: 5E 56 A5 F8 BF EC                                ^V....

SSDT @ 0x00000000CF74D018
  0000: 53 53 44 54 F1 09 00 00 01 66 50 6D 52 65 66 00  SSDT.....fPmRef.
  0010: 43 70 75 50 6D 00 00 00 00 30 00 00 49 4E 54 4C  CpuPm....0..INTL
  0020: 29 07 08 20 10 46 0C 5C 00 08 53 53 44 54 12 43  ).. .F.\..SSDT.C
  0030: 05 0C 0D 43 50 55 30 49 53 54 20 00 0C 18 AA 7E  ...CPU0IST ....~
  0040: CF 0C 74 04 00 00 0D 41 50 49 53 54 20 20 20 00  ..t....APIST   .
  0050: 0C 98 9A 7E CF 0C 03 03 00 00 0D 43 50 55 30 43  ...~.......CPU0C
  0060: 53 54 20 00 0C 18 80 7E CF 0C 91 08 00 00 0D 41  ST ....~.......A
  0070: 50 43 53 54 20 20 20 00 0C 98 7D 7E CF 0C 19 01  PCST   ...}~....
  0080: 00 00 08 43 46 47 44 0C 51 06 20 03 08 5C 50 44  ...CFGD.Q. ..\PD
  0090: 43 30 0C 00 00 00 80 08 5C 50 44 43 31 0C 00 00  C0......\PDC1...
  00A0: 00 80 08 5C 50 44 43 32 0C 00 00 00 80 08 5C 50  ...\PDC2......\P
  00B0: 44 43 33 0C 00 00 00 80 08 5C 50 44 43 34 0C 00  DC3......\PDC4..
  00C0: 00 00 80 08 5C 50 44 43 35 0C 00 00 00 80 08 5C  ....\PDC5......\
  00D0: 50 44 43 36 0C 00 00 00 80 08 5C 50 44 43 37 0C  PDC6......\PDC7.
  00E0: 00 00 00 80 08 5C 53 44 54 4C 00 10 46 27 5C 2E  .....\SDTL..F'\.
  00F0: 5F 50 52 5F 43 50 55 30 08 48 49 30 5F 00 08 48  _PR_CPU0.HI0_..H
  0100: 43 30 5F 00 14 14 5F 50 44 43 01 70 43 50 44 43  C0_..._PDC.pCPDC
  0110: 68 60 47 43 41 50 60 A4 60 14 17 5F 4F 53 43 04  h`GCAP`.`.._OSC.
  0120: 70 43 4F 53 43 68 69 6A 6B 60 47 43 41 50 60 A4  pCOSChijk`GCAP`.
  0130: 60 14 48 06 43 50 44 43 01 8A 68 00 52 45 56 53  `.H.CPDC..h.REVS
  0140: 8A 68 0A 04 53 49 5A 45 70 87 68 60 70 74 60 0A  .h..SIZEp.h`pt`.
  0150: 08 00 61 5B 13 68 0A 40 77 61 0A 08 00 54 45 4D  ..a[.h.@wa...TEM
  0160: 50 08 53 54 53 30 11 07 0A 04 00 00 00 00 73 53  P.STS0........sS
  0170: 54 53 30 54 45 4D 50 62 A4 43 4F 53 43 11 13 0A  TS0TEMPb.COSC...
  0180: 10 16 A6 77 40 0C 29 BE 47 9E BD D8 70 58 71 39  ...w@.).G...pXq9
  0190: 53 52 45 56 53 53 49 5A 45 62 14 4D 0B 43 4F 53  SREVSSIZEb.M.COS
  01A0: 43 04 8A 6B 00 53 54 53 30 8A 6B 0A 04 43 41 50  C..k.STS0.k..CAP
  01B0: 30 8A 68 00 49 49 44 30 8A 68 0A 04 49 49 44 31  0.h.IID0.h..IID1
  01C0: 8A 68 0A 08 49 49 44 32 8A 68 0A 0C 49 49 44 33  .h..IID2.h..IID3
  01D0: 08 55 49 44 30 11 13 0A 10 16 A6 77 40 0C 29 BE  .UID0......w@.).
  01E0: 47 9E BD D8 70 58 71 39 53 8A 55 49 44 30 00 45  G...pXq9S.UID0.E
  01F0: 49 44 30 8A 55 49 44 30 0A 04 45 49 44 31 8A 55  ID0.UID0..EID1.U
  0200: 49 44 30 0A 08 45 49 44 32 8A 55 49 44 30 0A 0C  ID0..EID2.UID0..
  0210: 45 49 44 33 A0 32 92 90 90 93 49 49 44 30 45 49  EID3.2....IID0EI
  0220: 44 30 93 49 49 44 31 45 49 44 31 90 93 49 49 44  D0.IID1EID1..IID
  0230: 32 45 49 44 32 93 49 49 44 33 45 49 44 33 70 0A  2EID2.IID3EID3p.
  0240: 06 53 54 53 30 A4 6B A0 0E 92 93 69 01 70 0A 0A  .STS0.k....i.p..
  0250: 53 54 53 30 A4 6B A4 6B 14 49 10 47 43 41 50 01  STS0.k.k.I.GCAP.
  0260: 8A 68 00 53 54 53 30 8A 68 0A 04 43 41 50 30 A0  .h.STS0.h..CAP0.
  0270: 12 91 93 53 54 53 30 0A 06 93 53 54 53 30 0A 0A  ...STS0...STS0..
  0280: A4 00 A0 16 7B 53 54 53 30 01 00 7B 43 41 50 30  ....{STS0..{CAP0
  0290: 0B FF 0B 43 41 50 30 A4 00 7D 7B 50 44 43 30 0C  ...CAP0..}{PDC0.
  02A0: FF FF FF 7F 00 43 41 50 30 50 44 43 30 A0 48 05  .....CAP0PDC0.H.
  02B0: 7B 43 46 47 44 01 00 A0 4E 04 90 90 7B 43 46 47  {CFGD...N...{CFG
  02C0: 44 0C 00 00 00 01 00 93 7B 50 44 43 30 0A 09 00  D.......{PDC0...
  02D0: 0A 09 92 7B 53 44 54 4C 01 00 7D 53 44 54 4C 01  ...{SDTL..}SDTL.
  02E0: 53 44 54 4C 5B 80 49 53 54 30 00 83 88 53 53 44  SDTL[.IST0...SSD
  02F0: 54 01 00 83 88 53 53 44 54 0A 02 00 5B 20 49 53  T....SSDT...[ IS
  0300: 54 30 48 49 30 5F A0 49 05 7B 43 46 47 44 0A F0  T0HI0_.I.{CFGD..
  0310: 00 A0 4E 04 90 90 7B 43 46 47 44 0C 00 00 00 01  ..N...{CFGD.....
  0320: 00 7B 50 44 43 30 0A 18 00 92 7B 53 44 54 4C 0A  .{PDC0....{SDTL.
  0330: 02 00 7D 53 44 54 4C 0A 02 53 44 54 4C 5B 80 43  ..}SDTL..SDTL[.C
  0340: 53 54 30 00 83 88 53 53 44 54 0A 07 00 83 88 53  ST0...SSDT.....S
  0350: 53 44 54 0A 08 00 5B 20 43 53 54 30 48 43 30 5F  SDT...[ CST0HC0_
  0360: A4 00 10 46 16 5C 2E 5F 50 52 5F 43 50 55 31 08  ...F.\._PR_CPU1.
  0370: 48 49 31 5F 00 08 48 43 31 5F 00 14 1F 5F 50 44  HI1_..HC1_..._PD
  0380: 43 01 70 5C 2F 03 5F 50 52 5F 43 50 55 30 43 50  C.p\/._PR_CPU0CP
  0390: 44 43 68 60 47 43 41 50 60 A4 60 14 22 5F 4F 53  DCh`GCAP`.`."_OS
  03A0: 43 04 70 5C 2F 03 5F 50 52 5F 43 50 55 30 43 4F  C.p\/._PR_CPU0CO
  03B0: 53 43 68 69 6A 6B 60 47 43 41 50 60 A4 60 14 45  SChijk`GCAP`.`.E
  03C0: 07 47 43 41 50 01 8A 68 00 53 54 53 31 8A 68 0A  .GCAP..h.STS1.h.
  03D0: 04 43 41 50 31 A0 12 91 93 53 54 53 31 0A 06 93  .CAP1....STS1...
  03E0: 53 54 53 31 0A 0A A4 00 A0 16 7B 53 54 53 31 01  STS1......{STS1.
  03F0: 00 7B 43 41 50 31 0B FF 0B 43 41 50 31 A4 00 7D  .{CAP1...CAP1..}
  0400: 7B 50 44 43 31 0C FF FF FF 7F 00 43 41 50 31 50  {PDC1......CAP1P
  0410: 44 43 31 A0 10 93 7B 50 44 43 30 0A 09 00 0A 09  DC1...{PDC0.....
  0420: 41 50 50 54 A0 0D 7B 50 44 43 30 0A 18 00 41 50  APPT..{PDC0...AP
  0430: 43 54 A4 00 14 4A 04 41 50 43 54 00 A0 42 04 90  CT...J.APCT..B..
  0440: 7B 43 46 47 44 0A F0 00 92 7B 53 44 54 4C 0A 20  {CFGD....{SDTL. 
  0450: 00 7D 53 44 54 4C 0A 20 53 44 54 4C 5B 80 43 53  .}SDTL. SDTL[.CS
  0460: 54 31 00 83 88 53 53 44 54 0A 0A 00 83 88 53 53  T1...SSDT.....SS
  0470: 44 54 0A 0B 00 5B 20 43 53 54 31 48 43 31 5F 14  DT...[ CST1HC1_.
  0480: 49 04 41 50 50 54 00 A0 41 04 90 7B 43 46 47 44  I.APPT..A..{CFGD
  0490: 01 00 92 7B 53 44 54 4C 0A 10 00 7D 53 44 54 4C  ...{SDTL...}SDTL
  04A0: 0A 10 53 44 54 4C 5B 80 49 53 54 31 00 83 88 53  ..SDTL[.IST1...S
  04B0: 53 44 54 0A 04 00 83 88 53 53 44 54 0A 05 00 5B  SDT.....SSDT...[
  04C0: 20 49 53 54 31 48 49 31 5F 10 4B 0D 5C 2E 5F 50   IST1HI1_.K.\._P
  04D0: 52 5F 43 50 55 32 14 1F 5F 50 44 43 01 70 5C 2F  R_CPU2.._PDC.p\/
  04E0: 03 5F 50 52 5F 43 50 55 30 43 50 44 43 68 60 47  ._PR_CPU0CPDCh`G
  04F0: 43 41 50 60 A4 60 14 22 5F 4F 53 43 04 70 5C 2F  CAP`.`."_OSC.p\/
  0500: 03 5F 50 52 5F 43 50 55 30 43 4F 53 43 68 69 6A  ._PR_CPU0COSChij
  0510: 6B 60 47 43 41 50 60 A4 60 14 4B 08 47 43 41 50  k`GCAP`.`.K.GCAP
  0520: 01 8A 68 00 53 54 53 32 8A 68 0A 04 43 41 50 32  ..h.STS2.h..CAP2
  0530: A0 12 91 93 53 54 53 32 0A 06 93 53 54 53 32 0A  ....STS2...STS2.
  0540: 0A A4 00 A0 16 7B 53 54 53 32 01 00 7B 43 41 50  .....{STS2..{CAP
  0550: 32 0B FF 0B 43 41 50 32 A4 00 7D 7B 50 44 43 32  2...CAP2..}{PDC2
  0560: 0C FF FF FF 7F 00 43 41 50 32 50 44 43 32 A0 1B  ......CAP2PDC2..
  0570: 93 7B 50 44 43 32 0A 09 00 0A 09 5C 2F 03 5F 50  .{PDC2.....\/._P
  0580: 52 5F 43 50 55 31 41 50 50 54 A0 18 7B 50 44 43  R_CPU1APPT..{PDC
  0590: 32 0A 18 00 5C 2F 03 5F 50 52 5F 43 50 55 31 41  2...\/._PR_CPU1A
  05A0: 50 43 54 A4 00 10 4B 0D 5C 2E 5F 50 52 5F 43 50  PCT...K.\._PR_CP
  05B0: 55 33 14 1F 5F 50 44 43 01 70 5C 2F 03 5F 50 52  U3.._PDC.p\/._PR
  05C0: 5F 43 50 55 30 43 50 44 43 68 60 47 43 41 50 60  _CPU0CPDCh`GCAP`
  05D0: A4 60 14 22 5F 4F 53 43 04 70 5C 2F 03 5F 50 52  .`."_OSC.p\/._PR
  05E0: 5F 43 50 55 30 43 4F 53 43 68 69 6A 6B 60 47 43  _CPU0COSChijk`GC
  05F0: 41 50 60 A4 60 14 4B 08 47 43 41 50 01 8A 68 00  AP`.`.K.GCAP..h.
  0600: 53 54 53 33 8A 68 0A 04 43 41 50 33 A0 12 91 93  STS3.h..CAP3....
  0610: 53 54 53 33 0A 06 93 53 54 53 33 0A 0A A4 00 A0  STS3...STS3.....
  0620: 16 7B 53 54 53 33 01 00 7B 43 41 50 33 0B FF 0B  .{STS3..{CAP3...
  0630: 43 41 50 33 A4 00 7D 7B 50 44 43 33 0C FF FF FF  CAP3..}{PDC3....
  0640: 7F 00 43 41 50 33 50 44 43 33 A0 1B 93 7B 50 44  ..CAP3PDC3...{PD
  0650: 43 33 0A 09 00 0A 09 5C 2F 03 5F 50 52 5F 43 50  C3.....\/._PR_CP
  0660: 55 31 41 50 50 54 A0 18 7B 50 44 43 33 0A 18 00  U1APPT..{PDC3...
  0670: 5C 2F 03 5F 50 52 5F 43 50 55 31 41 50 43 54 A4  \/._PR_CPU1APCT.
  0680: 00 10 4B 0D 5C 2E 5F 50 52 5F 43 50 55 34 14 1F  ..K.\._PR_CPU4..
  0690: 5F 50 44 43 01 70 5C 2F 03 5F 50 52 5F 43 50 55  _PDC.p\/._PR_CPU
  06A0: 30 43 50 44 43 68 60 47 43 41 50 60 A4 60 14 22  0CPDCh`GCAP`.`."
  06B0: 5F 4F 53 43 04 70 5C 2F 03 5F 50 52 5F 43 50 55  _OSC.p\/._PR_CPU
  06C0: 30 43 4F 53 43 68 69 6A 6B 60 47 43 41 50 60 A4  0COSChijk`GCAP`.
  06D0: 60 14 4B 08 47 43 41 50 01 8A 68 00 53 54 53 34  `.K.GCAP..h.STS4
  06E0: 8A 68 0A 04 43 41 50 34 A0 12 91 93 53 54 53 34  .h..CAP4....STS4
  06F0: 0A 06 93 53 54 53 34 0A 0A A4 00 A0 16 7B 53 54  ...STS4......{ST
  0700: 53 34 01 00 7B 43 41 50 34 0B FF 0B 43 41 50 34  S4..{CAP4...CAP4
  0710: A4 00 7D 7B 50 44 43 34 0C FF FF FF 7F 00 43 41  ..}{PDC4......CA
  0720: 50 34 50 44 43 34 A0 1B 93 7B 50 44 43 34 0A 09  P4PDC4...{PDC4..
  0730: 00 0A 09 5C 2F 03 5F 50 52 5F 43 50 55 31 41 50  ...\/._PR_CPU1AP
  0740: 50 54 A0 18 7B 50 44 43 34 0A 18 00 5C 2F 03 5F  PT..{PDC4...\/._
  0750: 50 52 5F 43 50 55 31 41 50 43 54 A4 00 10 4B 0D  PR_CPU1APCT...K.
  0760: 5C 2E 5F 50 52 5F 43 50 55 35 14 1F 5F 50 44 43  \._PR_CPU5.._PDC
  0770: 01 70 5C 2F 03 5F 50 52 5F 43 50 55 30 43 50 44  .p\/._PR_CPU0CPD
  0780: 43 68 60 47 43 41 50 60 A4 60 14 22 5F 4F 53 43  Ch`GCAP`.`."_OSC
  0790: 04 70 5C 2F 03 5F 50 52 5F 43 50 55 30 43 4F 53  .p\/._PR_CPU0COS
  07A0: 43 68 69 6A 6B 60 47 43 41 50 60 A4 60 14 4B 08  Chijk`GCAP`.`.K.
  07B0: 47 43 41 50 01 8A 68 00 53 54 53 35 8A 68 0A 04  GCAP..h.STS5.h..
  07C0: 43 41 50 35 A0 12 91 93 53 54 53 35 0A 06 93 53  CAP5....STS5...S
  07D0: 54 53 35 0A 0A A4 00 A0 16 7B 53 54 53 35 01 00  TS5......{STS5..
  07E0: 7B 43 41 50 35 0B FF 0B 43 41 50 35 A4 00 7D 7B  {CAP5...CAP5..}{
  07F0: 50 44 43 35 0C FF FF FF 7F 00 43 41 50 35 50 44  PDC5......CAP5PD
  0800: 43 35 A0 1B 93 7B 50 44 43 35 0A 09 00 0A 09 5C  C5...{PDC5.....\
  0810: 2F 03 5F 50 52 5F 43 50 55 31 41 50 50 54 A0 18  /._PR_CPU1APPT..
  0820: 7B 50 44 43 35 0A 18 00 5C 2F 03 5F 50 52 5F 43  {PDC5...\/._PR_C
  0830: 50 55 31 41 50 43 54 A4 00 10 4B 0D 5C 2E 5F 50  PU1APCT...K.\._P
  0840: 52 5F 43 50 55 36 14 1F 5F 50 44 43 01 70 5C 2F  R_CPU6.._PDC.p\/
  0850: 03 5F 50 52 5F 43 50 55 30 43 50 44 43 68 60 47  ._PR_CPU0CPDCh`G
  0860: 43 41 50 60 A4 60 14 22 5F 4F 53 43 04 70 5C 2F  CAP`.`."_OSC.p\/
  0870: 03 5F 50 52 5F 43 50 55 30 43 4F 53 43 68 69 6A  ._PR_CPU0COSChij
  0880: 6B 60 47 43 41 50 60 A4 60 14 4B 08 47 43 41 50  k`GCAP`.`.K.GCAP
  0890: 01 8A 68 00 53 54 53 36 8A 68 0A 04 43 41 50 36  ..h.STS6.h..CAP6
  08A0: A0 12 91 93 53 54 53 36 0A 06 93 53 54 53 36 0A  ....STS6...STS6.
  08B0: 0A A4 00 A0 16 7B 53 54 53 36 01 00 7B 43 41 50  .....{STS6..{CAP
  08C0: 36 0B FF 0B 43 41 50 36 A4 00 7D 7B 50 44 43 36  6...CAP6..}{PDC6
  08D0: 0C FF FF FF 7F 00 43 41 50 36 50 44 43 36 A0 1B  ......CAP6PDC6..
  08E0: 93 7B 50 44 43 36 0A 09 00 0A 09 5C 2F 03 5F 50  .{PDC6.....\/._P
  08F0: 52 5F 43 50 55 31 41 50 50 54 A0 18 7B 50 44 43  R_CPU1APPT..{PDC
  0900: 36 0A 18 00 5C 2F 03 5F 50 52 5F 43 50 55 31 41  6...\/._PR_CPU1A
  0910: 50 43 54 A4 00 10 4B 0D 5C 2E 5F 50 52 5F 43 50  PCT...K.\._PR_CP
  0920: 55 37 14 1F 5F 50 44 43 01 70 5C 2F 03 5F 50 52  U7.._PDC.p\/._PR
  0930: 5F 43 50 55 30 43 50 44 43 68 60 47 43 41 50 60  _CPU0CPDCh`GCAP`
  0940: A4 60 14 22 5F 4F 53 43 04 70 5C 2F 03 5F 50 52  .`."_OSC.p\/._PR
  0950: 5F 43 50 55 30 43 4F 53 43 68 69 6A 6B 60 47 43  _CPU0COSChijk`GC
  0960: 41 50 60 A4 60 14 4B 08 47 43 41 50 01 8A 68 00  AP`.`.K.GCAP..h.
  0970: 53 54 53 37 8A 68 0A 04 43 41 50 37 A0 12 91 93  STS7.h..CAP7....
  0980: 53 54 53 37 0A 06 93 53 54 53 37 0A 0A A4 00 A0  STS7...STS7.....
  0990: 16 7B 53 54 53 37 01 00 7B 43 41 50 37 0B FF 0B  .{STS7..{CAP7...
  09A0: 43 41 50 37 A4 00 7D 7B 50 44 43 37 0C FF FF FF  CAP7..}{PDC7....
  09B0: 7F 00 43 41 50 37 50 44 43 37 A0 1B 93 7B 50 44  ..CAP7PDC7...{PD
  09C0: 43 37 0A 09 00 0A 09 5C 2F 03 5F 50 52 5F 43 50  C7.....\/._PR_CP
  09D0: 55 31 41 50 50 54 A0 18 7B 50 44 43 37 0A 18 00  U1APPT..{PDC7...
  09E0: 5C 2F 03 5F 50 52 5F 43 50 55 31 41 50 43 54 A4  \/._PR_CPU1APCT.
  09F0: 00                                               .

SSDT @ 0x0000000000000000
  0000: 53 53 44 54 74 04 00 00 01 F4 50 6D 52 65 66 00  SSDTt.....PmRef.
  0010: 43 70 75 30 49 73 74 00 00 30 00 00 49 4E 54 4C  Cpu0Ist..0..INTL
  0020: 29 07 08 20 10 4F 44 5C 2E 5F 50 52 5F 43 50 55  ).. .OD\._PR_CPU
  0030: 30 08 5F 50 50 43 00 14 44 07 5F 50 43 54 00 A0  0._PPC..D._PCT..
  0040: 3E 90 7B 43 46 47 44 01 00 7B 50 44 43 30 01 00  >.{CFGD..{PDC0..
  0050: A4 12 2C 02 11 14 0A 11 82 0C 00 7F 00 00 00 00  ..,.............
  0060: 00 00 00 00 00 00 00 79 00 11 14 0A 11 82 0C 00  .......y........
  0070: 7F 00 00 00 00 00 00 00 00 00 00 00 79 00 A4 12  ............y...
  0080: 2C 02 11 14 0A 11 82 0C 00 01 10 00 00 04 10 00  ,...............
  0090: 00 00 00 00 00 79 00 11 14 0A 11 82 0C 00 01 08  .....y..........
  00A0: 00 00 B3 00 00 00 00 00 00 00 79 00 14 19 58 50  ..........y...XP
  00B0: 53 53 00 A0 0D 7B 50 44 43 30 01 00 A4 4E 50 53  SS...{PDC0...NPS
  00C0: 53 A4 53 50 53 53 08 53 50 53 53 12 40 1B 0D 12  S.SPSS.SPSS.@...
  00D0: 20 06 0C 6B 0A 00 00 0C A8 61 00 00 0C 6E 00 00   ..k.....a...n..
  00E0: 00 0C 0A 00 00 00 0C 83 00 00 00 0C 00 00 00 00  ................
  00F0: 12 20 06 0C 6A 0A 00 00 0C A8 61 00 00 0C 6E 00  . ..j.....a...n.
  0100: 00 00 0C 0A 00 00 00 0C 83 01 00 00 0C 01 00 00  ................
  0110: 00 12 20 06 0C E5 09 00 00 0C 9E 5C 00 00 0C 6E  .. ........\...n
  0120: 00 00 00 0C 0A 00 00 00 0C 83 02 00 00 0C 02 00  ................
  0130: 00 00 12 20 06 0C 5F 09 00 00 0C C1 57 00 00 0C  ... .._.....W...
  0140: 6E 00 00 00 0C 0A 00 00 00 0C 83 03 00 00 0C 03  n...............
  0150: 00 00 00 12 20 06 0C DA 08 00 00 0C FB 52 00 00  .... ........R..
  0160: 0C 6E 00 00 00 0C 0A 00 00 00 0C 83 04 00 00 0C  .n..............
  0170: 04 00 00 00 12 20 06 0C 55 08 00 00 0C 3B 4E 00  ..... ..U....;N.
  0180: 00 0C 6E 00 00 00 0C 0A 00 00 00 0C 83 05 00 00  ..n.............
  0190: 0C 05 00 00 00 12 20 06 0C CF 07 00 00 0C A4 49  ...... ........I
  01A0: 00 00 0C 6E 00 00 00 0C 0A 00 00 00 0C 83 06 00  ...n............
  01B0: 00 0C 06 00 00 00 12 20 06 0C 4A 07 00 00 0C 24  ....... ..J....$
  01C0: 45 00 00 0C 6E 00 00 00 0C 0A 00 00 00 0C 83 07  E...n...........
  01D0: 00 00 0C 07 00 00 00 12 20 06 0C C5 06 00 00 0C  ........ .......
  01E0: BB 40 00 00 0C 6E 00 00 00 0C 0A 00 00 00 0C 83  .@...n..........
  01F0: 08 00 00 0C 08 00 00 00 12 20 06 0C 3F 06 00 00  ......... ..?...
  0200: 0C 76 3C 00 00 0C 6E 00 00 00 0C 0A 00 00 00 0C  .v<...n.........
  0210: 83 09 00 00 0C 09 00 00 00 12 20 06 0C BA 05 00  .......... .....
  0220: 00 0C 3B 38 00 00 0C 6E 00 00 00 0C 0A 00 00 00  ..;8...n........
  0230: 0C 83 0A 00 00 0C 0A 00 00 00 12 20 06 0C 35 05  ........... ..5.
  0240: 00 00 0C 16 34 00 00 0C 6E 00 00 00 0C 0A 00 00  ....4...n.......
  0250: 00 0C 83 0B 00 00 0C 0B 00 00 00 12 20 06 0C AF  ............ ...
  0260: 04 00 00 0C 09 30 00 00 0C 6E 00 00 00 0C 0A 00  .....0...n......
  0270: 00 00 0C 83 0C 00 00 0C 0C 00 00 00 08 5F 50 53  ............._PS
  0280: 53 12 40 1B 0D 12 20 06 0C 6B 0A 00 00 0C A8 61  S.@... ..k.....a
  0290: 00 00 0C 0A 00 00 00 0C 0A 00 00 00 0C 15 00 00  ................
  02A0: 00 0C 15 00 00 00 12 20 06 0C 6A 0A 00 00 0C A8  ....... ..j.....
  02B0: 61 00 00 0C 0A 00 00 00 0C 0A 00 00 00 0C 14 00  a...............
  02C0: 00 00 0C 14 00 00 00 12 20 06 0C E5 09 00 00 0C  ........ .......
  02D0: 9E 5C 00 00 0C 0A 00 00 00 0C 0A 00 00 00 0C 13  .\..............
  02E0: 00 00 00 0C 13 00 00 00 12 20 06 0C 5F 09 00 00  ......... .._...
  02F0: 0C C1 57 00 00 0C 0A 00 00 00 0C 0A 00 00 00 0C  ..W.............
  0300: 12 00 00 00 0C 12 00 00 00 12 20 06 0C DA 08 00  .......... .....
  0310: 00 0C FB 52 00 00 0C 0A 00 00 00 0C 0A 00 00 00  ...R............
  0320: 0C 11 00 00 00 0C 11 00 00 00 12 20 06 0C 55 08  ........... ..U.
  0330: 00 00 0C 3B 4E 00 00 0C 0A 00 00 00 0C 0A 00 00  ...;N...........
  0340: 00 0C 10 00 00 00 0C 10 00 00 00 12 20 06 0C CF  ............ ...
  0350: 07 00 00 0C A4 49 00 00 0C 0A 00 00 00 0C 0A 00  .....I..........
  0360: 00 00 0C 0F 00 00 00 0C 0F 00 00 00 12 20 06 0C  ............. ..
  0370: 4A 07 00 00 0C 24 45 00 00 0C 0A 00 00 00 0C 0A  J....$E.........
  0380: 00 00 00 0C 0E 00 00 00 0C 0E 00 00 00 12 20 06  .............. .
  0390: 0C C5 06 00 00 0C BB 40 00 00 0C 0A 00 00 00 0C  .......@........
  03A0: 0A 00 00 00 0C 0D 00 00 00 0C 0D 00 00 00 12 20  ............... 
  03B0: 06 0C 3F 06 00 00 0C 76 3C 00 00 0C 0A 00 00 00  ..?....v<.......
  03C0: 0C 0A 00 00 00 0C 0C 00 00 00 0C 0C 00 00 00 12  ................
  03D0: 20 06 0C BA 05 00 00 0C 3B 38 00 00 0C 0A 00 00   .......;8......
  03E0: 00 0C 0A 00 00 00 0C 0B 00 00 00 0C 0B 00 00 00  ................
  03F0: 12 20 06 0C 35 05 00 00 0C 16 34 00 00 0C 0A 00  . ..5.....4.....
  0400: 00 00 0C 0A 00 00 00 0C 0A 00 00 00 0C 0A 00 00  ................
  0410: 00 12 20 06 0C AF 04 00 00 0C 09 30 00 00 0C 0A  .. ........0....
  0420: 00 00 00 0C 0A 00 00 00 0C 09 00 00 00 0C 09 00  ................
  0430: 00 00 14 1B 5F 50 53 44 00 A0 0F 7B 50 44 43 30  ...._PSD...{PDC0
  0440: 0B 00 08 00 A4 48 50 53 44 A4 53 50 53 44 08 48  .....HPSD.SPSD.H
  0450: 50 53 44 12 0D 01 12 0A 05 0A 05 00 00 0A FE 0A  PSD.............
  0460: 04 08 53 50 53 44 12 0D 01 12 0A 05 0A 05 00 00  ..SPSD..........
  0470: 0A FC 0A 04                                      ....

SSDT @ 0x0000000000000000
  0000: 53 53 44 54 91 08 00 00 01 5B 50 6D 52 65 66 00  SSDT.....[PmRef.
  0010: 43 70 75 30 43 73 74 00 01 30 00 00 49 4E 54 4C  Cpu0Cst..0..INTL
  0020: 29 07 08 20 10 4C 86 5C 2E 5F 50 52 5F 43 50 55  ).. .L.\._PR_CPU
  0030: 30 14 4F 85 5F 43 53 54 00 A0 4F 2C 90 7B 43 46  0.O._CST..O,.{CF
  0040: 47 44 0C 00 00 20 00 00 7B 50 44 43 30 0B 00 02  GD... ..{PDC0...
  0050: 00 A0 45 1F 92 50 57 52 53 A0 4D 0B 7B 43 46 47  ..E..PWRS.M.{CFG
  0060: 44 0C 00 00 00 20 00 A0 4C 06 7B 43 46 47 44 0A  D.... ..L.{CFGD.
  0070: 40 00 A4 12 40 06 04 0A 03 12 1D 04 11 14 0A 11  @...@...........
  0080: 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79  ...............y
  0090: 00 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C  ................
  00A0: 00 7F 01 02 03 10 00 00 00 00 00 00 00 79 00 0A  .............y..
  00B0: 02 0A CD 0B F4 01 12 1D 04 11 14 0A 11 82 0C 00  ................
  00C0: 7F 01 02 03 30 00 00 00 00 00 00 00 79 00 0A 03  ....0.......y...
  00D0: 0A F5 0A C8 A4 12 41 04 03 0A 02 12 1D 04 11 14  ......A.........
  00E0: 0A 11 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00  ................
  00F0: 00 79 00 01 0A 03 0B E8 03 12 1D 04 11 14 0A 11  .y..............
  0100: 82 0C 00 7F 01 02 03 30 00 00 00 00 00 00 00 79  .......0.......y
  0110: 00 0A 03 0A F5 0A C8 A0 4D 0B 7B 43 46 47 44 0B  ........M.{CFGD.
  0120: 00 02 00 A0 4D 06 7B 43 46 47 44 0A 40 00 A4 12  ....M.{CFGD.@...
  0130: 41 06 04 0A 03 12 1D 04 11 14 0A 11 82 0C 00 7F  A...............
  0140: 01 02 01 00 00 00 00 00 00 00 00 79 00 01 0A 03  ...........y....
  0150: 0B E8 03 12 1E 04 11 14 0A 11 82 0C 00 7F 01 02  ................
  0160: 03 10 00 00 00 00 00 00 00 79 00 0A 02 0A CD 0B  .........y......
  0170: F4 01 12 1E 04 11 14 0A 11 82 0C 00 7F 01 02 03  ................
  0180: 20 00 00 00 00 00 00 00 79 00 0A 03 0A F5 0B 5E   .......y......^
  0190: 01 A4 12 42 04 03 0A 02 12 1D 04 11 14 0A 11 82  ...B............
  01A0: 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79 00  ..............y.
  01B0: 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C 00  ................
  01C0: 7F 01 02 03 20 00 00 00 00 00 00 00 79 00 0A 03  .... .......y...
  01D0: 0A F5 0B 5E 01 A0 4E 04 7B 43 46 47 44 0A 40 00  ...^..N.{CFGD.@.
  01E0: A4 12 42 04 03 0A 02 12 1D 04 11 14 0A 11 82 0C  ..B.............
  01F0: 00 7F 01 02 01 00 00 00 00 00 00 00 00 79 00 01  .............y..
  0200: 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C 00 7F  ................
  0210: 01 02 03 10 00 00 00 00 00 00 00 79 00 0A 02 0A  ...........y....
  0220: CD 0B F4 01 A4 12 21 02 01 12 1D 04 11 14 0A 11  ......!.........
  0230: 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79  ...............y
  0240: 00 01 0A 03 0B E8 03 A0 4F 04 7B 43 46 47 44 0B  ........O.{CFGD.
  0250: 00 02 00 A4 12 42 04 03 0A 02 12 1D 04 11 14 0A  .....B..........
  0260: 11 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00  ................
  0270: 79 00 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82  y...............
  0280: 0C 00 7F 01 02 03 20 00 00 00 00 00 00 00 79 00  ...... .......y.
  0290: 0A 03 0A F5 0B 5E 01 A0 4E 04 7B 43 46 47 44 0A  .....^..N.{CFGD.
  02A0: 40 00 A4 12 42 04 03 0A 02 12 1D 04 11 14 0A 11  @...B...........
  02B0: 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79  ...............y
  02C0: 00 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C  ................
  02D0: 00 7F 01 02 03 10 00 00 00 00 00 00 00 79 00 0A  .............y..
  02E0: 02 0A CD 0B F4 01 A4 12 21 02 01 12 1D 04 11 14  ........!.......
  02F0: 0A 11 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00  ................
  0300: 00 79 00 01 0A 03 0B E8 03 A0 4F 2C 90 7B 43 46  .y........O,.{CF
  0310: 47 44 0C 00 00 20 00 00 7B 50 44 43 30 0B 00 01  GD... ..{PDC0...
  0320: 00 A0 45 1F 92 50 57 52 53 A0 4D 0B 7B 43 46 47  ..E..PWRS.M.{CFG
  0330: 44 0C 00 00 00 20 00 A0 4C 06 7B 43 46 47 44 0A  D.... ..L.{CFGD.
  0340: 40 00 A4 12 40 06 04 0A 03 12 1D 04 11 14 0A 11  @...@...........
  0350: 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79  ...............y
  0360: 00 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C  ................
  0370: 00 01 08 00 00 14 04 00 00 00 00 00 00 79 00 0A  .............y..
  0380: 02 0A CD 0B F4 01 12 1D 04 11 14 0A 11 82 0C 00  ................
  0390: 01 08 00 00 16 04 00 00 00 00 00 00 79 00 0A 03  ............y...
  03A0: 0A F5 0A C8 A4 12 41 04 03 0A 02 12 1D 04 11 14  ......A.........
  03B0: 0A 11 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00  ................
  03C0: 00 79 00 01 0A 03 0B E8 03 12 1D 04 11 14 0A 11  .y..............
  03D0: 82 0C 00 01 08 00 00 16 04 00 00 00 00 00 00 79  ...............y
  03E0: 00 0A 03 0A F5 0A C8 A0 4D 0B 7B 43 46 47 44 0B  ........M.{CFGD.
  03F0: 00 02 00 A0 4D 06 7B 43 46 47 44 0A 40 00 A4 12  ....M.{CFGD.@...
  0400: 41 06 04 0A 03 12 1D 04 11 14 0A 11 82 0C 00 7F  A...............
  0410: 01 02 01 00 00 00 00 00 00 00 00 79 00 01 0A 03  ...........y....
  0420: 0B E8 03 12 1E 04 11 14 0A 11 82 0C 00 01 08 00  ................
  0430: 00 14 04 00 00 00 00 00 00 79 00 0A 02 0A CD 0B  .........y......
  0440: F4 01 12 1E 04 11 14 0A 11 82 0C 00 01 08 00 00  ................
  0450: 15 04 00 00 00 00 00 00 79 00 0A 03 0A F5 0B 5E  ........y......^
  0460: 01 A4 12 42 04 03 0A 02 12 1D 04 11 14 0A 11 82  ...B............
  0470: 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79 00  ..............y.
  0480: 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C 00  ................
  0490: 01 08 00 00 15 04 00 00 00 00 00 00 79 00 0A 03  ............y...
  04A0: 0A F5 0B 5E 01 A0 4E 04 7B 43 46 47 44 0A 40 00  ...^..N.{CFGD.@.
  04B0: A4 12 42 04 03 0A 02 12 1D 04 11 14 0A 11 82 0C  ..B.............
  04C0: 00 7F 01 02 01 00 00 00 00 00 00 00 00 79 00 01  .............y..
  04D0: 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C 00 01  ................
  04E0: 08 00 00 14 04 00 00 00 00 00 00 79 00 0A 02 0A  ...........y....
  04F0: CD 0B F4 01 A4 12 21 02 01 12 1D 04 11 14 0A 11  ......!.........
  0500: 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79  ...............y
  0510: 00 01 0A 03 0B E8 03 A0 4F 04 7B 43 46 47 44 0B  ........O.{CFGD.
  0520: 00 02 00 A4 12 42 04 03 0A 02 12 1D 04 11 14 0A  .....B..........
  0530: 11 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00  ................
  0540: 79 00 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82  y...............
  0550: 0C 00 01 08 00 00 15 04 00 00 00 00 00 00 79 00  ..............y.
  0560: 0A 03 0A F5 0B 5E 01 A0 4E 04 7B 43 46 47 44 0A  .....^..N.{CFGD.
  0570: 40 00 A4 12 42 04 03 0A 02 12 1D 04 11 14 0A 11  @...B...........
  0580: 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00 00 79  ...............y
  0590: 00 01 0A 03 0B E8 03 12 1E 04 11 14 0A 11 82 0C  ................
  05A0: 00 01 08 00 00 14 04 00 00 00 00 00 00 79 00 0A  .............y..
  05B0: 02 0A CD 0B F4 01 A4 12 21 02 01 12 1D 04 11 14  ........!.......
  05C0: 0A 11 82 0C 00 7F 01 02 01 00 00 00 00 00 00 00  ................
  05D0: 00 79 00 01 0A 03 0B E8 03 A0 45 1F 92 50 57 52  .y........E..PWR
  05E0: 53 A0 4D 0B 7B 43 46 47 44 0C 00 00 00 20 00 A0  S.M.{CFGD.... ..
  05F0: 4C 06 7B 43 46 47 44 0A 40 00 A4 12 40 06 04 0A  L.{CFGD.@...@...
  0600: 03 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00 00 00  ................
  0610: 00 00 00 00 00 00 00 79 00 01 0A 03 0B E8 03 12  .......y........
  0620: 1E 04 11 14 0A 11 82 0C 00 01 08 00 00 14 04 00  ................
  0630: 00 00 00 00 00 79 00 0A 02 0A CD 0B F4 01 12 1D  .....y..........
  0640: 04 11 14 0A 11 82 0C 00 01 08 00 00 16 04 00 00  ................
  0650: 00 00 00 00 79 00 0A 03 0A F5 0A C8 A4 12 41 04  ....y.........A.
  0660: 03 0A 02 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00  ................
  0670: 00 00 00 00 00 00 00 00 00 79 00 01 0A 03 0B E8  .........y......
  0680: 03 12 1D 04 11 14 0A 11 82 0C 00 01 08 00 00 16  ................
  0690: 04 00 00 00 00 00 00 79 00 0A 03 0A F5 0A C8 A0  .......y........
  06A0: 4D 0B 7B 43 46 47 44 0B 00 02 00 A0 4D 06 7B 43  M.{CFGD.....M.{C
  06B0: 46 47 44 0A 40 00 A4 12 41 06 04 0A 03 12 1D 04  FGD.@...A.......
  06C0: 11 14 0A 11 82 0C 00 7F 00 00 00 00 00 00 00 00  ................
  06D0: 00 00 00 79 00 01 0A 03 0B E8 03 12 1E 04 11 14  ...y............
  06E0: 0A 11 82 0C 00 01 08 00 00 14 04 00 00 00 00 00  ................
  06F0: 00 79 00 0A 02 0A CD 0B F4 01 12 1E 04 11 14 0A  .y..............
  0700: 11 82 0C 00 01 08 00 00 15 04 00 00 00 00 00 00  ................
  0710: 79 00 0A 03 0A F5 0B 5E 01 A4 12 42 04 03 0A 02  y......^...B....
  0720: 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00 00 00 00  ................
  0730: 00 00 00 00 00 00 79 00 01 0A 03 0B E8 03 12 1E  ......y.........
  0740: 04 11 14 0A 11 82 0C 00 01 08 00 00 15 04 00 00  ................
  0750: 00 00 00 00 79 00 0A 03 0A F5 0B 5E 01 A0 4E 04  ....y......^..N.
  0760: 7B 43 46 47 44 0A 40 00 A4 12 42 04 03 0A 02 12  {CFGD.@...B.....
  0770: 1D 04 11 14 0A 11 82 0C 00 7F 00 00 00 00 00 00  ................
  0780: 00 00 00 00 00 79 00 01 0A 03 0B E8 03 12 1E 04  .....y..........
  0790: 11 14 0A 11 82 0C 00 01 08 00 00 14 04 00 00 00  ................
  07A0: 00 00 00 79 00 0A 02 0A CD 0B F4 01 A4 12 21 02  ...y..........!.
  07B0: 01 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00 00 00  ................
  07C0: 00 00 00 00 00 00 00 79 00 01 0A 03 0B E8 03 A0  .......y........
  07D0: 4F 04 7B 43 46 47 44 0B 00 02 00 A4 12 42 04 03  O.{CFGD......B..
  07E0: 0A 02 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00 00  ................
  07F0: 00 00 00 00 00 00 00 00 79 00 01 0A 03 0B E8 03  ........y.......
  0800: 12 1E 04 11 14 0A 11 82 0C 00 01 08 00 00 15 04  ................
  0810: 00 00 00 00 00 00 79 00 0A 03 0A F5 0B 5E 01 A0  ......y......^..
  0820: 4E 04 7B 43 46 47 44 0A 40 00 A4 12 42 04 03 0A  N.{CFGD.@...B...
  0830: 02 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00 00 00  ................
  0840: 00 00 00 00 00 00 00 79 00 01 0A 03 0B E8 03 12  .......y........
  0850: 1E 04 11 14 0A 11 82 0C 00 01 08 00 00 14 04 00  ................
  0860: 00 00 00 00 00 79 00 0A 02 0A CD 0B F4 01 A4 12  .....y..........
  0870: 21 02 01 12 1D 04 11 14 0A 11 82 0C 00 7F 00 00  !...............
  0880: 00 00 00 00 00 00 00 00 00 79 00 01 0A 03 0B E8  .........y......
  0890: 03                                               .

SSDT @ 0x0000000000000000
  0000: 53 53 44 54 03 03 00 00 01 6B 50 6D 52 65 66 00  SSDT.....kPmRef.
  0010: 41 70 49 73 74 00 00 00 00 30 00 00 49 4E 54 4C  ApIst....0..INTL
  0020: 29 07 08 20 10 48 06 5C 2E 5F 50 52 5F 43 50 55  ).. .H.\._PR_CPU
  0030: 31 14 16 5F 50 50 43 00 A4 5C 2F 03 5F 50 52 5F  1.._PPC..\/._PR_
  0040: 43 50 55 30 5F 50 50 43 14 16 5F 50 43 54 00 A4  CPU0_PPC.._PCT..
  0050: 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 43 54 14  \/._PR_CPU0_PCT.
  0060: 16 5F 50 53 53 00 A4 5C 2F 03 5F 50 52 5F 43 50  ._PSS..\/._PR_CP
  0070: 55 30 5F 50 53 53 14 16 5F 50 53 44 00 A4 5C 2F  U0_PSS.._PSD..\/
  0080: 03 5F 50 52 5F 43 50 55 30 5F 50 53 44 10 48 06  ._PR_CPU0_PSD.H.
  0090: 5C 2E 5F 50 52 5F 43 50 55 32 14 16 5F 50 50 43  \._PR_CPU2.._PPC
  00A0: 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 50  ..\/._PR_CPU0_PP
  00B0: 43 14 16 5F 50 43 54 00 A4 5C 2F 03 5F 50 52 5F  C.._PCT..\/._PR_
  00C0: 43 50 55 30 5F 50 43 54 14 16 5F 50 53 53 00 A4  CPU0_PCT.._PSS..
  00D0: 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 53 53 14  \/._PR_CPU0_PSS.
  00E0: 16 5F 50 53 44 00 A4 5C 2F 03 5F 50 52 5F 43 50  ._PSD..\/._PR_CP
  00F0: 55 30 5F 50 53 44 10 48 06 5C 2E 5F 50 52 5F 43  U0_PSD.H.\._PR_C
  0100: 50 55 33 14 16 5F 50 50 43 00 A4 5C 2F 03 5F 50  PU3.._PPC..\/._P
  0110: 52 5F 43 50 55 30 5F 50 50 43 14 16 5F 50 43 54  R_CPU0_PPC.._PCT
  0120: 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 43  ..\/._PR_CPU0_PC
  0130: 54 14 16 5F 50 53 53 00 A4 5C 2F 03 5F 50 52 5F  T.._PSS..\/._PR_
  0140: 43 50 55 30 5F 50 53 53 14 16 5F 50 53 44 00 A4  CPU0_PSS.._PSD..
  0150: 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 53 44 10  \/._PR_CPU0_PSD.
  0160: 48 06 5C 2E 5F 50 52 5F 43 50 55 34 14 16 5F 50  H.\._PR_CPU4.._P
  0170: 50 43 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F  PC..\/._PR_CPU0_
  0180: 50 50 43 14 16 5F 50 43 54 00 A4 5C 2F 03 5F 50  PPC.._PCT..\/._P
  0190: 52 5F 43 50 55 30 5F 50 43 54 14 16 5F 50 53 53  R_CPU0_PCT.._PSS
  01A0: 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 53  ..\/._PR_CPU0_PS
  01B0: 53 14 16 5F 50 53 44 00 A4 5C 2F 03 5F 50 52 5F  S.._PSD..\/._PR_
  01C0: 43 50 55 30 5F 50 53 44 10 48 06 5C 2E 5F 50 52  CPU0_PSD.H.\._PR
  01D0: 5F 43 50 55 35 14 16 5F 50 50 43 00 A4 5C 2F 03  _CPU5.._PPC..\/.
  01E0: 5F 50 52 5F 43 50 55 30 5F 50 50 43 14 16 5F 50  _PR_CPU0_PPC.._P
  01F0: 43 54 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F  CT..\/._PR_CPU0_
  0200: 50 43 54 14 16 5F 50 53 53 00 A4 5C 2F 03 5F 50  PCT.._PSS..\/._P
  0210: 52 5F 43 50 55 30 5F 50 53 53 14 16 5F 50 53 44  R_CPU0_PSS.._PSD
  0220: 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 50 53  ..\/._PR_CPU0_PS
  0230: 44 10 48 06 5C 2E 5F 50 52 5F 43 50 55 36 14 16  D.H.\._PR_CPU6..
  0240: 5F 50 50 43 00 A4 5C 2F 03 5F 50 52 5F 43 50 55  _PPC..\/._PR_CPU
  0250: 30 5F 50 50 43 14 16 5F 50 43 54 00 A4 5C 2F 03  0_PPC.._PCT..\/.
  0260: 5F 50 52 5F 43 50 55 30 5F 50 43 54 14 16 5F 50  _PR_CPU0_PCT.._P
  0270: 53 53 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F  SS..\/._PR_CPU0_
  0280: 50 53 53 14 16 5F 50 53 44 00 A4 5C 2F 03 5F 50  PSS.._PSD..\/._P
  0290: 52 5F 43 50 55 30 5F 50 53 44 10 48 06 5C 2E 5F  R_CPU0_PSD.H.\._
  02A0: 50 52 5F 43 50 55 37 14 16 5F 50 50 43 00 A4 5C  PR_CPU7.._PPC..\
  02B0: 2F 03 5F 50 52 5F 43 50 55 30 5F 50 50 43 14 16  /._PR_CPU0_PPC..
  02C0: 5F 50 43 54 00 A4 5C 2F 03 5F 50 52 5F 43 50 55  _PCT..\/._PR_CPU
  02D0: 30 5F 50 43 54 14 16 5F 50 53 53 00 A4 5C 2F 03  0_PCT.._PSS..\/.
  02E0: 5F 50 52 5F 43 50 55 30 5F 50 53 53 14 16 5F 50  _PR_CPU0_PSS.._P
  02F0: 53 44 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F  SD..\/._PR_CPU0_
  0300: 50 53 44                                         PSD

SSDT @ 0x0000000000000000
  0000: 53 53 44 54 19 01 00 00 01 E1 50 6D 52 65 66 00  SSDT......PmRef.
  0010: 41 70 43 73 74 00 00 00 00 30 00 00 49 4E 54 4C  ApCst....0..INTL
  0020: 29 07 08 20 10 22 5C 2E 5F 50 52 5F 43 50 55 31  ).. ."\._PR_CPU1
  0030: 14 16 5F 43 53 54 00 A4 5C 2F 03 5F 50 52 5F 43  .._CST..\/._PR_C
  0040: 50 55 30 5F 43 53 54 10 22 5C 2E 5F 50 52 5F 43  PU0_CST."\._PR_C
  0050: 50 55 32 14 16 5F 43 53 54 00 A4 5C 2F 03 5F 50  PU2.._CST..\/._P
  0060: 52 5F 43 50 55 30 5F 43 53 54 10 22 5C 2E 5F 50  R_CPU0_CST."\._P
  0070: 52 5F 43 50 55 33 14 16 5F 43 53 54 00 A4 5C 2F  R_CPU3.._CST..\/
  0080: 03 5F 50 52 5F 43 50 55 30 5F 43 53 54 10 22 5C  ._PR_CPU0_CST."\
  0090: 2E 5F 50 52 5F 43 50 55 34 14 16 5F 43 53 54 00  ._PR_CPU4.._CST.
  00A0: A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F 43 53 54  .\/._PR_CPU0_CST
  00B0: 10 22 5C 2E 5F 50 52 5F 43 50 55 35 14 16 5F 43  ."\._PR_CPU5.._C
  00C0: 53 54 00 A4 5C 2F 03 5F 50 52 5F 43 50 55 30 5F  ST..\/._PR_CPU0_
  00D0: 43 53 54 10 22 5C 2E 5F 50 52 5F 43 50 55 36 14  CST."\._PR_CPU6.
  00E0: 16 5F 43 53 54 00 A4 5C 2F 03 5F 50 52 5F 43 50  ._CST..\/._PR_CP
  00F0: 55 30 5F 43 53 54 10 22 5C 2E 5F 50 52 5F 43 50  U0_CST."\._PR_CP
  0100: 55 37 14 16 5F 43 53 54 00 A4 5C 2F 03 5F 50 52  U7.._CST..\/._PR
  0110: 5F 43 50 55 30 5F 43 53 54                       _CPU0_CST


--yrj/dFKFPuw6o+aM--
