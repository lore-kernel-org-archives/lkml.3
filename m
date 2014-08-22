Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaHVVeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:34:21 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39696 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaHVVeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140822195440.GD12398@glanzmann.de>
References: <20140822195440.GD12398@glanzmann.de>
Date: Fri, 22 Aug 2014 17:34:17 -0400
Message-ID: <CAHQdGtQOypEzD=72Q9ynC8x1bQKh6KM5aJFc1ghRhQihxcxnoA@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 197 at fs/proc/generic.c:521 remove_proc_entry+0x142/0x159()
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Thomas Glanzmann <thomas@glanzmann.de>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 3:54 PM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello everyone,
> after I compiled a new kernel 2 days ago and also with current Linus tip
> I get:
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.17.0-rc1+ (sithglan@mini) (gcc version 4.7.2 (Debian 4.7.2-5) ) #182 SMP Fri Aug 22 20:14:24 CEST 2014
> [    0.000000] Command line: BOOT_IMAGE=/home/sithglan/work/linux-2.6/arch/x86/boot/bzImage root=UUID=c98d312d-f2a1-42d8-834a-ad2f95ce56f8 ro netconsole=4444@192.168.0.7/eth0,6666@192.168.0.3/00:22:4d:6b:97:8f
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000090000000-0x00000000be4b6fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000be4b7000-0x00000000be6b7fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000be6b8000-0x00000000be85ffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000be860000-0x00000000be861fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000be862000-0x00000000be862fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000be863000-0x00000000be864fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000be865000-0x00000000bfec5fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bfec6000-0x00000000bfec7fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bfec8000-0x00000000bfec8fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bfec9000-0x00000000bfecafff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bfecb000-0x00000000bfeccfff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bfecd000-0x00000000bfedefff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bfedf000-0x00000000bfef8fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bfef9000-0x00000000bfefefff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bfeff000-0x00000000bfefffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000d3400000-0x00000000d3400fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] AGP: No AGP bridge found
> [    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 disabled
> [    0.000000]   1 base 000000000 mask F80000000 write-back
> [    0.000000]   2 base 080000000 mask FC0000000 write-back
> [    0.000000]   3 base 100000000 mask FC0000000 write-back
> [    0.000000]   4 base 0BFF00000 mask FFFF00000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: update [mem 0xbff00000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xbe4b7 max_arch_pfn = 0x400000000
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01847000, 0x01847fff] PGTABLE
> [    0.000000] BRK [0x01848000, 0x01848fff] PGTABLE
> [    0.000000] BRK [0x01849000, 0x01849fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
> [    0.000000]  [mem 0x13fe00000-0x13fffffff] page 2M
> [    0.000000] BRK [0x0184a000, 0x0184afff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
> [    0.000000]  [mem 0x13c000000-0x13fdfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
> [    0.000000]  [mem 0x100000000-0x13bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x7fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x7fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x90000000-0xbe4b6fff]
> [    0.000000]  [mem 0x90000000-0xbe3fffff] page 2M
> [    0.000000]  [mem 0xbe400000-0xbe4b6fff] page 4k
> [    0.000000] BRK [0x0184b000, 0x0184bfff] PGTABLE
> [    0.000000] BRK [0x0184c000, 0x0184cfff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x375ac000-0x37acdfff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000FE020 000024 (v02 APPLE )
> [    0.000000] ACPI: XSDT 0x00000000BFEEE1C0 000074 (v01 APPLE  Apple00  00000081      01000013)
> [    0.000000] ACPI: FACP 0x00000000BFEEC000 0000F4 (v03 APPLE  Apple00  00000081 Loki 0000005F)
> [    0.000000] ACPI: DSDT 0x00000000BFEE0000 0050B8 (v01 APPLE  Macmini  00030001 INTL 20061109)
> [    0.000000] ACPI: FACS 0x00000000BFECD000 000040
> [    0.000000] ACPI: HPET 0x00000000BFEEB000 000038 (v01 APPLE  Apple00  00000001 Loki 0000005F)
> [    0.000000] ACPI: APIC 0x00000000BFEEA000 000068 (v01 APPLE  Apple00  00000001 Loki 0000005F)
> [    0.000000] ACPI: MCFG 0x00000000BFEE9000 00003C (v01 APPLE  Apple00  00000001 Loki 0000005F)
> [    0.000000] ACPI: ASF! 0x00000000BFEE8000 0000A5 (v32 APPLE  Apple00  00000001 Loki 0000005F)
> [    0.000000] ACPI: SBST 0x00000000BFEE7000 000030 (v01 APPLE  Apple00  00000001 Loki 0000005F)
> [    0.000000] ACPI: ECDT 0x00000000BFEE6000 000053 (v01 APPLE  Apple00  00000001 Loki 0000005F)
> [    0.000000] ACPI: SSDT 0x00000000BFEC8000 0004DC (v01 APPLE  CpuPm    00003000 INTL 20061109)
> [    0.000000] ACPI: SSDT 0x00000000BFEDF000 0000A5 (v01 SataRe SataPri  00001000 INTL 20061109)
> [    0.000000] ACPI: SSDT 0x00000000BFECC000 00009F (v01 SataRe SataSec  00001000 INTL 20061109)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
> [    0.000000]   NODE_DATA [mem 0x13fffb000-0x13fffefff]
> [    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013ba00000-ffff88013effffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x7fffffff]
> [    0.000000]   node   0: [mem 0x90000000-0xbe4b6fff]
> [    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
> [    0.000000] On node 0 totalpages: 975957
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 9705 pages used for memmap
> [    0.000000]   DMA32 zone: 709815 pages, LIFO batch:31
> [    0.000000]   Normal zone: 3584 pages used for memmap
> [    0.000000]   Normal zone: 262144 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe4b7000-0xbe6b7fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe6b8000-0xbe85ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe860000-0xbe861fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe862000-0xbe862fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe863000-0xbe864fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe865000-0xbfec5fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfec6000-0xbfec7fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfec8000-0xbfec8fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfec9000-0xbfecafff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfecb000-0xbfeccfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfecd000-0xbfedefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfedf000-0xbfef8fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfef9000-0xbfefefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbfeff000-0xbfefffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbff00000-0xd33fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xd3400000-0xd3400fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xd3401000-0xefffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
> [    0.000000] e820: [mem 0xd3401000-0xefffffff] available for PCI devices
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013fc00000 s80512 r8192 d21888 u1048576
> [    0.000000] pcpu-alloc: s80512 r8192 d21888 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 962591
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/home/sithglan/work/linux-2.6/arch/x86/boot/bzImage root=UUID=c98d312d-f2a1-42d8-834a-ad2f95ce56f8 ro netconsole=4444@192.168.0.7/eth0,6666@192.168.0.3/00:22:4d:6b:97:8f
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240 using standard form
> [    0.000000] AGP: Checking aperture...
> [    0.000000] AGP: No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 3768152K/3903828K available (3715K kernel code, 662K rwdata, 1640K rodata, 888K init, 756K bss, 135676K reserved)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:33024 nr_irqs:440 0
> [    0.000000] spurious 8259A interrupt: IRQ7.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 2255.327 MHz processor
> [    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4510.65 BogoMIPS (lpj=9021308)
> [    0.008125] pid_max: default: 32768 minimum: 301
> [    0.008197] ACPI: Core revision 20140724
> [    0.016691] ACPI: All ACPI Tables successfully acquired
> [    0.017111] Security Framework initialized
> [    0.017177] AppArmor: AppArmor disabled by boot time parameter
> [    0.017789] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.020160] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.021306] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.021382] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.021867] Initializing cgroup subsys devices
> [    0.021934] Initializing cgroup subsys freezer
> [    0.021998] Initializing cgroup subsys net_cls
> [    0.022060] Initializing cgroup subsys blkio
> [    0.022122] Initializing cgroup subsys perf_event
> [    0.022218] CPU: Physical Processor ID: 0
> [    0.022278] CPU: Processor Core ID: 0
> [    0.022338] mce: CPU supports 6 MCE banks
> [    0.022404] CPU0: Thermal monitoring enabled (TM2)
> [    0.022474] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> [    0.022474] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
> [    0.022662] Freeing SMP alternatives memory: 12K (ffffffff81785000 - ffffffff81788000)
> [    0.023309] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.063078] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz (fam: 06, model: 17, stepping: 0a)
> [    0.064000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
> [    0.064000] ... version:                2
> [    0.064000] ... bit width:              40
> [    0.064000] ... generic registers:      2
> [    0.064000] ... value mask:             000000ffffffffff
> [    0.064000] ... max period:             000000007fffffff
> [    0.064000] ... fixed-purpose events:   3
> [    0.064000] ... event mask:             0000000700000003
> [    0.064000] x86: Booting SMP configuration:
> [    0.064000] .... node  #0, CPUs:      #1
> [    0.074585] x86: Booted up 1 node, 2 CPUs
> [    0.074703] smpboot: Total of 2 processors activated (9021.30 BogoMIPS)
> [    0.074827] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.076143] devtmpfs: initialized
> [    0.092050] PM: Registering ACPI NVS region [mem 0xbe4b7000-0xbe6b7fff] (2101248 bytes)
> [    0.092233] PM: Registering ACPI NVS region [mem 0xbe860000-0xbe861fff] (8192 bytes)
> [    0.092307] PM: Registering ACPI NVS region [mem 0xbe863000-0xbe864fff] (8192 bytes)
> [    0.092380] PM: Registering ACPI NVS region [mem 0xbfec6000-0xbfec7fff] (8192 bytes)
> [    0.092453] PM: Registering ACPI NVS region [mem 0xbfec9000-0xbfecafff] (8192 bytes)
> [    0.092526] PM: Registering ACPI NVS region [mem 0xbfecd000-0xbfedefff] (73728 bytes)
> [    0.092611] reboot: Apple Macmini3,1 series board detected. Selecting PCI-method for reboots.
> [    0.092816] regulator-dummy: no parameters
> [    0.092816] NET: Registered protocol family 16
> [    0.092816] cpuidle: using governor ladder
> [    0.092816] cpuidle: using governor menu
> [    0.092899] ACPI: bus type PCI registered
> [    0.092957] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.093352] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xf0000000-0xffffffff] (base 0xf0000000)
> [    0.093429] PCI: MMCONFIG at [mem 0xf0000000-0xffffffff] reserved in E820
> [    0.093493] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000) (size reduced!)
> [    0.093681] PCI: Using configuration type 1 for base access
> [    0.104129] ACPI: Added _OSI(Module Device)
> [    0.104138] ACPI: Added _OSI(Processor Device)
> [    0.104198] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.104258] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.109028] ACPI : EC: EC description table is found, configuring boot EC
> [    0.110585] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.112399] ACPI: Dynamic OEM Table Load:
> [    0.112556] ACPI: SSDT 0xFFFF88013ACCC000 000238 (v01 APPLE  Cpu0Ist  00003000 INTL 20061109)
> [    0.113259] ACPI: Dynamic OEM Table Load:
> [    0.113413] ACPI: SSDT 0xFFFF88013ACD6C00 0002AD (v01 APPLE  Cpu0Cst  00003001 INTL 20061109)
> [    0.132328] ACPI: Dynamic OEM Table Load:
> [    0.132483] ACPI: SSDT 0xFFFF88013AC2C600 0000C8 (v01 APPLE  Cpu1Ist  00003000 INTL 20061109)
> [    0.133127] ACPI: Dynamic OEM Table Load:
> [    0.133281] ACPI: SSDT 0xFFFF88013AC584C0 000085 (v01 APPLE  Cpu1Cst  00003000 INTL 20061109)
> [    0.156369] ACPI: Interpreter enabled
> [    0.156435] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
> [    0.156602] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
> [    0.156784] ACPI: (supports S0 S3 S4 S5)
> [    0.156844] ACPI: Using IOAPIC for interrupt routing
> [    0.156947] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.168773] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.168843] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.169309] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
> [    0.169530] acpi PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000ce5ff])
> [    0.169616] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
> [    0.169952] PCI host bridge to bus 0000:00
> [    0.170015] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.170078] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.170141] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.170205] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.170268] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
> [    0.170332] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
> [    0.170396] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
> [    0.170460] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    0.170524] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.170586] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.170650] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    0.170714] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
> [    0.170778] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
> [    0.170842] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
> [    0.170906] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
> [    0.170970] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
> [    0.171034] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
> [    0.171112] pci 0000:00:00.0: [10de:0a82] type 00 class 0x060000
> [    0.171371] pci 0000:00:00.1: [10de:0a88] type 00 class 0x050000
> [    0.171644] pci 0000:00:03.0: [10de:0aae] type 00 class 0x060100
> [    0.171656] pci 0000:00:03.0: reg 0x10: [io  0x2000-0x20ff]
> [    0.171856] pci 0000:00:03.1: [10de:0aa4] type 00 class 0x050000
> [    0.172081] pci 0000:00:03.2: [10de:0aa2] type 00 class 0x0c0500
> [    0.172098] pci 0000:00:03.2: reg 0x10: [io  0x2180-0x21bf]
> [    0.172123] pci 0000:00:03.2: reg 0x20: [io  0x2140-0x217f]
> [    0.172132] pci 0000:00:03.2: reg 0x24: [io  0x2100-0x213f]
> [    0.172172] pci 0000:00:03.2: PME# supported from D3hot D3cold
> [    0.172359] pci 0000:00:03.3: [10de:0a89] type 00 class 0x050000
> [    0.172624] pci 0000:00:03.4: [10de:0a98] type 00 class 0x050000
> [    0.172830] pci 0000:00:03.5: [10de:0aa3] type 00 class 0x0b4000
> [    0.172852] pci 0000:00:03.5: reg 0x10: [mem 0xd3400000-0xd347ffff]
> [    0.173131] pci 0000:00:04.0: [10de:0aa5] type 00 class 0x0c0310
> [    0.173147] pci 0000:00:04.0: reg 0x10: [mem 0xd3488000-0xd3488fff]
> [    0.173202] pci 0000:00:04.0: supports D1 D2
> [    0.173205] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.173306] pci 0000:00:04.0: System wakeup disabled by ACPI
> [    0.173453] pci 0000:00:04.1: [10de:0aa6] type 00 class 0x0c0320
> [    0.173470] pci 0000:00:04.1: reg 0x10: [mem 0xd3489200-0xd34892ff]
> [    0.173535] pci 0000:00:04.1: supports D1 D2
> [    0.173539] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.173647] pci 0000:00:04.1: System wakeup disabled by ACPI
> [    0.173800] pci 0000:00:06.0: [10de:0aa7] type 00 class 0x0c0310
> [    0.173815] pci 0000:00:06.0: reg 0x10: [mem 0xd3487000-0xd3487fff]
> [    0.173870] pci 0000:00:06.0: supports D1 D2
> [    0.173874] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.173974] pci 0000:00:06.0: System wakeup disabled by ACPI
> [    0.174121] pci 0000:00:06.1: [10de:0aa9] type 00 class 0x0c0320
> [    0.174138] pci 0000:00:06.1: reg 0x10: [mem 0xd3489100-0xd34891ff]
> [    0.174203] pci 0000:00:06.1: supports D1 D2
> [    0.174207] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.174309] pci 0000:00:06.1: System wakeup disabled by ACPI
> [    0.174461] pci 0000:00:08.0: [10de:0ac0] type 00 class 0x040300
> [    0.174476] pci 0000:00:08.0: reg 0x10: [mem 0xd3480000-0xd3483fff]
> [    0.174531] pci 0000:00:08.0: PME# supported from D3hot D3cold
> [    0.174706] pci 0000:00:09.0: [10de:0aab] type 01 class 0x060401
> [    0.174898] pci 0000:00:0a.0: [10de:0ab0] type 00 class 0x020000
> [    0.174914] pci 0000:00:0a.0: reg 0x10: [mem 0xd3486000-0xd3486fff]
> [    0.174922] pci 0000:00:0a.0: reg 0x14: [io  0x21e0-0x21e7]
> [    0.174931] pci 0000:00:0a.0: reg 0x18: [mem 0xd3489000-0xd34890ff]
> [    0.174939] pci 0000:00:0a.0: reg 0x1c: [mem 0xd3489300-0xd348930f]
> [    0.174985] pci 0000:00:0a.0: supports D1 D2
> [    0.174988] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.175106] pci 0000:00:0a.0: System wakeup disabled by ACPI
> [    0.175252] pci 0000:00:0b.0: [10de:0ab5] type 00 class 0x010185
> [    0.175268] pci 0000:00:0b.0: reg 0x10: [io  0x21d8-0x21df]
> [    0.175276] pci 0000:00:0b.0: reg 0x14: [io  0x21ec-0x21ef]
> [    0.175284] pci 0000:00:0b.0: reg 0x18: [io  0x21d0-0x21d7]
> [    0.175292] pci 0000:00:0b.0: reg 0x1c: [io  0x21e8-0x21eb]
> [    0.175300] pci 0000:00:0b.0: reg 0x20: [io  0x21c0-0x21cf]
> [    0.175308] pci 0000:00:0b.0: reg 0x24: [mem 0xd3484000-0xd3485fff]
> [    0.175511] pci 0000:00:10.0: [10de:0aa0] type 01 class 0x060400
> [    0.175560] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.175781] pci 0000:00:15.0: [10de:0ac6] type 01 class 0x060400
> [    0.176029] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.176278] pci 0000:00:16.0: [10de:0ac7] type 01 class 0x060400
> [    0.176522] pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.176828] pci 0000:00:09.0: PCI bridge to [bus 01] (subtractive decode)
> [    0.176896] pci 0000:00:09.0:   bridge window [mem 0xd3300000-0xd33fffff]
> [    0.176901] pci 0000:00:09.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.176906] pci 0000:00:09.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.176910] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.176913] pci 0000:00:09.0:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
> [    0.176917] pci 0000:00:09.0:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
> [    0.176921] pci 0000:00:09.0:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
> [    0.176925] pci 0000:00:09.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
> [    0.176929] pci 0000:00:09.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.176933] pci 0000:00:09.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.176937] pci 0000:00:09.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
> [    0.176941] pci 0000:00:09.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
> [    0.176945] pci 0000:00:09.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
> [    0.176949] pci 0000:00:09.0:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
> [    0.176952] pci 0000:00:09.0:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
> [    0.176956] pci 0000:00:09.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
> [    0.176960] pci 0000:00:09.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
> [    0.177044] pci 0000:02:00.0: [10de:0861] type 00 class 0x030000
> [    0.177064] pci 0000:02:00.0: reg 0x10: [mem 0xd2000000-0xd2ffffff]
> [    0.177079] pci 0000:02:00.0: reg 0x14: [mem 0xc0000000-0xcfffffff 64bit pref]
> [    0.177094] pci 0000:02:00.0: reg 0x1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
> [    0.177105] pci 0000:02:00.0: reg 0x24: [io  0x1000-0x107f]
> [    0.177115] pci 0000:02:00.0: reg 0x30: [mem 0xd3000000-0xd301ffff pref]
> [    0.177268] pci 0000:00:10.0: PCI bridge to [bus 02]
> [    0.177333] pci 0000:00:10.0:   bridge window [io  0x1000-0x1fff]
> [    0.177338] pci 0000:00:10.0:   bridge window [mem 0xd2000000-0xd30fffff]
> [    0.177344] pci 0000:00:10.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
> [    0.177724] pci 0000:03:00.0: [14e4:4328] type 00 class 0x028000
> [    0.177749] pci 0000:03:00.0: reg 0x10: [mem 0xd3200000-0xd3203fff 64bit]
> [    0.177868] pci 0000:03:00.0: supports D1 D2
> [    0.177872] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.188219] pci 0000:00:15.0: PCI bridge to [bus 03]
> [    0.188300] pci 0000:00:15.0:   bridge window [mem 0xd3200000-0xd32fffff]
> [    0.188500] pci 0000:04:00.0: [11c1:5901] type 00 class 0x0c0010
> [    0.188527] pci 0000:04:00.0: reg 0x10: [mem 0xd3100000-0xd3100fff 64bit]
> [    0.188647] pci 0000:04:00.0: supports D1 D2
> [    0.188650] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.196025] pci 0000:00:16.0: PCI bridge to [bus 04]
> [    0.196106] pci 0000:00:16.0:   bridge window [mem 0xd3100000-0xd31fffff]
> [    0.196806] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15) *0, disabled.
> [    0.197471] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 10 11 14 15) *0, disabled.
> [    0.198134] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15) *0, disabled.
> [    0.198794] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0, disabled.
> [    0.199454] ACPI: PCI Interrupt Link [Z003] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.200202] ACPI: PCI Interrupt Link [Z004] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.200955] ACPI: PCI Interrupt Link [Z005] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.201708] ACPI: PCI Interrupt Link [Z006] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.202458] ACPI: PCI Interrupt Link [Z007] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.203208] ACPI: PCI Interrupt Link [Z008] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.203959] ACPI: PCI Interrupt Link [Z009] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.204704] ACPI: PCI Interrupt Link [Z00A] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.205454] ACPI: PCI Interrupt Link [Z00B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.206205] ACPI: PCI Interrupt Link [Z00C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.206955] ACPI: PCI Interrupt Link [Z00D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.207707] ACPI: PCI Interrupt Link [Z00E] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.208479] ACPI: PCI Interrupt Link [Z00F] (IRQs 16 17 18 19 20 21 22 23) *10
> [    0.209184] ACPI: PCI Interrupt Link [Z00G] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.209935] ACPI: PCI Interrupt Link [Z00H] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.210686] ACPI: PCI Interrupt Link [Z00I] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.211437] ACPI: PCI Interrupt Link [Z00J] (IRQs 16 17 18 19 20 21 22 23) *7
> [    0.212146] ACPI: PCI Interrupt Link [Z00K] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.212897] ACPI: PCI Interrupt Link [Z00L] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.213648] ACPI: PCI Interrupt Link [Z00M] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.214398] ACPI: PCI Interrupt Link [Z00N] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.215149] ACPI: PCI Interrupt Link [Z00O] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.215900] ACPI: PCI Interrupt Link [Z00P] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.216662] ACPI: PCI Interrupt Link [Z00Q] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.217416] ACPI: PCI Interrupt Link [Z00R] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.218170] ACPI: PCI Interrupt Link [Z00S] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.218921] ACPI: PCI Interrupt Link [Z00T] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.219671] ACPI: PCI Interrupt Link [Z00U] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.220390] ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 22 23) *15
> [    0.221094] ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 18 19 20 21 22 23) *11
> [    0.221798] ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 18 19 20 21 22 23) *10
> [    0.222503] ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 18 19 20 21 22 23) *14
> [    0.223208] ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 20 21 22 23) *15
> [    0.223911] ACPI: PCI Interrupt Link [LGPU] (IRQs 16 17 18 19 20 21 22 23) *11
> [    0.224657] ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.225407] ACPI: PCI Interrupt Link [LSI0] (IRQs 16 17 18 19 20 21 22 23) *11
> [    0.226110] ACPI: PCI Interrupt Link [LSI1] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
> [    0.226859] ACPI: PCI Interrupt Link [Z000] (IRQs 16 17 18 19 20 21 22 23) *7
> [    0.227553] ACPI: PCI Interrupt Link [Z001] (IRQs 16 17 18 19 20 21 22 23) *5
> [    0.228242] ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 18 19 20 21 22 23) *14
> [    0.229041] ACPI: Enabled 3 GPEs in block 00 to 1F
> [    0.229199] ACPI: Enabled 1 GPEs in block 20 to 5F
> [    0.229378] ACPI : EC: GPE = 0x3f, I/O: command/status = 0x66, data = 0x62
> [    0.232039] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.232113] vgaarb: loaded
> [    0.236003] vgaarb: bridge control possible 0000:02:00.0
> [    0.236171] PCI: Using ACPI for IRQ routing
> [    0.238172] PCI: pci_cache_line_size set to 64 bytes
> [    0.238642] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.238646] e820: reserve RAM buffer [mem 0xbe4b7000-0xbfffffff]
> [    0.240021] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.240090] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
> [    0.240374] hpet0: 4 comparators, 64-bit 25.000000 MHz counter
> [    0.244031] Switched to clocksource hpet
> [    0.247846] pnp: PnP ACPI init
> [    0.248082] system 00:00: [mem 0xf0000000-0xf3ffffff] has been reserved
> [    0.248149] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.248342] system 00:01: [mem 0xfed00000-0xfed003ff] has been reserved
> [    0.248408] system 00:01: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
> [    0.248689] system 00:02: [io  0x0400-0x047f] could not be reserved
> [    0.248754] system 00:02: [io  0x0480-0x04ff] has been reserved
> [    0.248817] system 00:02: [io  0x0500-0x057f] has been reserved
> [    0.248881] system 00:02: [io  0x0580-0x05ff] has been reserved
> [    0.248944] system 00:02: [io  0x0800-0x087f] has been reserved
> [    0.249008] system 00:02: [io  0x0880-0x08ff] has been reserved
> [    0.249071] system 00:02: [io  0x2140-0x217f] has been reserved
> [    0.249135] system 00:02: [io  0x2100-0x213f] has been reserved
> [    0.249199] system 00:02: [io  0x04d0-0x04d1] has been reserved
> [    0.249260] system 00:02: [io  0x0295-0x0296] has been reserved
> [    0.249324] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.249379] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.250331] pnp: PnP ACPI: found 4 devices
> [    0.259214] pci 0000:00:09.0: PCI bridge to [bus 01]
> [    0.259281] pci 0000:00:09.0:   bridge window [mem 0xd3300000-0xd33fffff]
> [    0.259350] pci 0000:00:10.0: PCI bridge to [bus 02]
> [    0.259412] pci 0000:00:10.0:   bridge window [io  0x1000-0x1fff]
> [    0.259477] pci 0000:00:10.0:   bridge window [mem 0xd2000000-0xd30fffff]
> [    0.259542] pci 0000:00:10.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
> [    0.259618] pci 0000:00:15.0: PCI bridge to [bus 03]
> [    0.259687] pci 0000:00:15.0:   bridge window [mem 0xd3200000-0xd32fffff]
> [    0.259768] pci 0000:00:16.0: PCI bridge to [bus 04]
> [    0.259838] pci 0000:00:16.0:   bridge window [mem 0xd3100000-0xd31fffff]
> [    0.259920] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.259924] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.259927] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.259931] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
> [    0.259934] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
> [    0.259938] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
> [    0.259941] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
> [    0.259945] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
> [    0.259948] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
> [    0.259952] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
> [    0.259955] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
> [    0.259959] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
> [    0.259962] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
> [    0.259965] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
> [    0.259969] pci_bus 0000:00: resource 18 [mem 0x000f0000-0x000fffff]
> [    0.259973] pci_bus 0000:00: resource 19 [mem 0xc0000000-0xfebfffff]
> [    0.259977] pci_bus 0000:01: resource 1 [mem 0xd3300000-0xd33fffff]
> [    0.259980] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
> [    0.259984] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
> [    0.259987] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.259990] pci_bus 0000:01: resource 7 [mem 0x000c0000-0x000c3fff]
> [    0.259994] pci_bus 0000:01: resource 8 [mem 0x000c4000-0x000c7fff]
> [    0.259997] pci_bus 0000:01: resource 9 [mem 0x000c8000-0x000cbfff]
> [    0.260010] pci_bus 0000:01: resource 10 [mem 0x000d0000-0x000d3fff]
> [    0.260013] pci_bus 0000:01: resource 11 [mem 0x000d4000-0x000d7fff]
> [    0.260017] pci_bus 0000:01: resource 12 [mem 0x000d8000-0x000dbfff]
> [    0.260020] pci_bus 0000:01: resource 13 [mem 0x000dc000-0x000dffff]
> [    0.260024] pci_bus 0000:01: resource 14 [mem 0x000e0000-0x000e3fff]
> [    0.260027] pci_bus 0000:01: resource 15 [mem 0x000e4000-0x000e7fff]
> [    0.260031] pci_bus 0000:01: resource 16 [mem 0x000e8000-0x000ebfff]
> [    0.260034] pci_bus 0000:01: resource 17 [mem 0x000ec000-0x000effff]
> [    0.260038] pci_bus 0000:01: resource 18 [mem 0x000f0000-0x000fffff]
> [    0.260041] pci_bus 0000:01: resource 19 [mem 0xc0000000-0xfebfffff]
> [    0.260045] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
> [    0.260049] pci_bus 0000:02: resource 1 [mem 0xd2000000-0xd30fffff]
> [    0.260053] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
> [    0.260057] pci_bus 0000:03: resource 1 [mem 0xd3200000-0xd32fffff]
> [    0.260061] pci_bus 0000:04: resource 1 [mem 0xd3100000-0xd31fffff]
> [    0.260128] NET: Registered protocol family 2
> [    0.260564] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.260809] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.261080] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.261192] TCP: reno registered
> [    0.261263] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.261362] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.261539] NET: Registered protocol family 1
> [    0.262094] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
> [    0.332612] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
> [    0.333275] ACPI: PCI Interrupt Link [Z000] enabled at IRQ 21
> [    0.388605] ACPI: PCI Interrupt Link [Z001] enabled at IRQ 20
> [    0.388986] pci 0000:02:00.0: Boot video device
> [    0.389189] PCI: CLS 256 bytes, default 64
> [    0.389258] Unpacking initramfs...
> [    0.537645] Freeing initrd memory: 5256K (ffff8800375ac000 - ffff880037ace000)
> [    0.537771] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.537836] software IO TLB [mem 0xba4b7000-0xbe4b7000] (64MB) mapped at [ffff8800ba4b7000-ffff8800be4b6fff]
> [    0.538762] futex hash table entries: 512 (order: 3, 32768 bytes)
> [    0.538871] audit: initializing netlink subsys (disabled)
> [    0.538965] audit: type=2000 audit(1408736544.536:1): initialized
> [    0.539509] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.539853] VFS: Disk quotas dquot_6.5.2
> [    0.539936] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.540113] msgmni has been set to 7369
> [    0.540932] alg: No test for stdrng (krng)
> [    0.541030] bounce: pool size: 64 pages
> [    0.541111] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.541186] io scheduler noop registered
> [    0.541247] io scheduler deadline registered
> [    0.541327] io scheduler cfq registered (default)
> [    0.541980] ACPI: PCI Interrupt Link [Z00F] enabled at IRQ 19
> [    0.542124] pcieport 0000:00:15.0: irq 24 for MSI/MSI-X
> [    0.542697] ACPI: PCI Interrupt Link [Z00J] enabled at IRQ 18
> [    0.542826] pcieport 0000:00:16.0: irq 25 for MSI/MSI-X
> [    0.543071] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
> [    0.543136] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    0.543206] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
> [    0.543252] pcieport 0000:00:16.0: Signaling PME through PCIe PME interrupt
> [    0.543316] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
> [    0.543383] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
> [    0.543417] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.543510] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.543646] intel_idle: does not run on family 6 model 23
> [    0.543734] GHES: HEST is not enabled!
> [    0.543880] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.544630] hpet: probe of PNP0103:00 failed with error -22
> [    0.544716] Linux agpgart interface v0.103
> [    0.544980] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    1.536019] tsc: Refined TSC clocksource calibration: 2255.335 MHz
> [    1.571744] i8042: No controller found
> [    1.571941] mousedev: PS/2 mouse device common for all mice
> [    1.572373] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    1.572488] rtc_cmos 00:03: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
> [    1.572583] drop_monitor: Initializing network drop monitor service
> [    1.572756] TCP: cubic registered
> [    1.572863] NET: Registered protocol family 10
> [    1.573276] mip6: Mobile IPv6
> [    1.573338] NET: Registered protocol family 17
> [    1.573413] Key type dns_resolver registered
> [    1.573951] registered taskstats version 1
> [    1.575139] rtc_cmos 00:03: setting system clock to 2014-08-22 19:42:25 UTC (1408736545)
> [    1.575394] PM: Hibernation image not present or could not be loaded.
> [    1.577076] Freeing unused kernel memory: 888K (ffffffff816a7000 - ffffffff81785000)
> [    1.577150] Write protecting the kernel read-only data: 6144k
> [    1.578861] Freeing unused kernel memory: 372K (ffff8800013a3000 - ffff880001400000)
> [    1.580562] Freeing unused kernel memory: 408K (ffff88000159a000 - ffff880001600000)
> [    1.593735] udevd[58]: starting version 175
> [    1.620903] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
> [    1.621421] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 17
> [    1.631410] SCSI subsystem initialized
> [    1.655864] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
> [    1.655993] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
> [    1.656019] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
> [    1.668619] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
> [    1.668749] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
> [    1.672010] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
> [    1.677186] libata version 3.00 loaded.
> [    1.678811] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    1.680679] firewire_ohci 0000:04:00.0: irq 26 for MSI/MSI-X
> [    1.685439] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:23:df:7e:d4:46
> [    1.685522] forcedeth 0000:00:0a.0: highdma csum pwrctl gbit lnktim msi desc-v3
> [    1.685861] ahci 0000:00:0b.0: version 3.0
> [    1.686289] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 16
> [    1.686397] ahci 0000:00:0b.0: controller can't do PMP, turning off CAP_PMP
> [    1.686485] ahci 0000:00:0b.0: irq 27 for MSI/MSI-X
> [    1.686559] ahci 0000:00:0b.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3 impl IDE mode
> [    1.686636] ahci 0000:00:0b.0: flags: 64bit ncq sntf pm led pio slum part boh
> [    1.690506] scsi host0: ahci
> [    1.694516] scsi host1: ahci
> [    1.697287] scsi host2: ahci
> [    1.703472] scsi host3: ahci
> [    1.709380] scsi host4: ahci
> [    1.714118] scsi host5: ahci
> [    1.714313] ata1: SATA max UDMA/133 abar m8192@0xd3484000 port 0xd3484100 irq 27
> [    1.714388] ata2: SATA max UDMA/133 abar m8192@0xd3484000 port 0xd3484180 irq 27
> [    1.714456] ata3: DUMMY
> [    1.714514] ata4: DUMMY
> [    1.714572] ata5: DUMMY
> [    1.714631] ata6: DUMMY
> [    1.736086] firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x0, physUB
> [    2.032031] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.032113] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.032397] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HA, max UDMA/133
> [    2.032461] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    2.032759] ata1.00: configured for UDMA/133
> [    2.032988] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 02HA PQ: 0 ANSI: 5
> [    2.042317] ata2.00: ATAPI: PIONEER DVD-RW  DVRTS08, Q81B, max UDMA/33
> [    2.054612] ata2.00: configured for UDMA/33
> [    2.109506] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVRTS08  Q81B PQ: 0 ANSI: 5
> [    2.165311] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> [    2.165546] sd 0:0:0:0: [sda] Write Protect is off
> [    2.165610] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.165661] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.166301]  sda: sda1
> [    2.166819] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.220264] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
> [    2.220339] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    2.220621] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    2.223101] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    2.223245] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    2.236173] firewire_core 0000:04:00.0: created device fw0: GUID 0023dffffe7ed446, S800
> [    2.536080] Switched to clocksource tsc
> [    2.548345] netpoll: netconsole: local port 4444
> [    2.548408] netpoll: netconsole: local IPv4 address 192.168.0.7
> [    2.548470] netpoll: netconsole: interface 'eth0'
> [    2.548530] netpoll: netconsole: remote port 6666
> [    2.548590] netpoll: netconsole: remote IPv4 address 192.168.0.3
> [    2.548652] netpoll: netconsole: remote ethernet address 00:22:4d:6b:97:8f
> [    2.548716] netpoll: netconsole: device eth0 not up yet, forcing it
> [    2.549308] forcedeth 0000:00:0a.0: irq 28 for MSI/MSI-X
> [    2.549347] forcedeth 0000:00:0a.0 eth0: MSI enabled
> [    2.549630] forcedeth 0000:00:0a.0 eth0: no link during initialization
> [    2.549987] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    4.341211] forcedeth 0000:00:0a.0 eth0: link up
> [    4.341723] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [    4.349350] console [netcon0] enabled
> [    4.349410] netconsole: network logging started
> [    4.364175] device-mapper: uevent: version 1.0.3
> [    4.364410] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [    4.440009] raid6: sse2x1    2851 MB/s
> [    4.508020] raid6: sse2x2    3233 MB/s
> [    4.576017] raid6: sse2x4    4703 MB/s
> [    4.576079] raid6: using algorithm sse2x4 (4703 MB/s)
> [    4.576146] raid6: using ssse3x2 recovery algorithm
> [    4.576479] xor: measuring software checksum speed
> [    4.616004]    prefetch64-sse:  6964.000 MB/sec
> [    4.656003]    generic_sse:  6114.000 MB/sec
> [    4.656065] xor: using function: prefetch64-sse (6964.000 MB/sec)
> [    4.718748] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    5.121466] udevd[446]: starting version 175
> [    5.198722] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    5.198800] Monitor-Mwait will be used to enter C-1 state
> [    5.198812] ACPI: Power Button [PWRB]
> [    5.198970] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
> [    5.199049] ACPI: Sleep Button [SLPB]
> [    5.199152] Monitor-Mwait will be used to enter C-2 state
> [    5.199159] Monitor-Mwait will be used to enter C-3 state
> [    5.199165] tsc: Marking TSC unstable due to TSC halts in idle
> [    5.199249] ACPI: acpi_idle registered with cpuidle
> [    5.199411] Switched to clocksource hpet
> [    5.200195] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    5.200275] ACPI: Power Button [PWRF]
> [    5.246223] i2c i2c-0: nForce2 SMBus adapter at 0x2140
> [    5.246347] i2c i2c-1: nForce2 SMBus adapter at 0x2100
> [    5.293150] ACPI: bus type USB registered
> [    5.293270] usbcore: registered new interface driver usbfs
> [    5.293349] usbcore: registered new interface driver hub
> [    5.295676] usbcore: registered new device driver usb
> [    5.296410] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    5.296989] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.297492] ehci-pci: EHCI PCI platform driver
> [    5.297833] ehci-pci 0000:00:04.1: EHCI Host Controller
> [    5.297907] ehci-pci 0000:00:04.1: new USB bus registered, assigned bus number 1
> [    5.297990] ehci-pci 0000:00:04.1: debug port 1
> [    5.298075] ehci-pci 0000:00:04.1: cache line size of 256 is not supported
> [    5.298096] ehci-pci 0000:00:04.1: irq 22, io mem 0xd3489200
> [    5.298118] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.298920] ohci-pci: OHCI PCI platform driver
> [    5.308052] ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00
> [    5.308197] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.308261] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.308338] usb usb1: Product: EHCI Host Controller
> [    5.308397] usb usb1: Manufacturer: Linux 3.17.0-rc1+ ehci_hcd
> [    5.308463] usb usb1: SerialNumber: 0000:00:04.1
> [    5.308743] hub 1-0:1.0: USB hub found
> [    5.308828] hub 1-0:1.0: 7 ports detected
> [    5.309405] ehci-pci 0000:00:06.1: EHCI Host Controller
> [    5.309479] ehci-pci 0000:00:06.1: new USB bus registered, assigned bus number 2
> [    5.309562] ehci-pci 0000:00:06.1: debug port 1
> [    5.309640] ehci-pci 0000:00:06.1: cache line size of 256 is not supported
> [    5.309660] ehci-pci 0000:00:06.1: irq 20, io mem 0xd3489100
> [    5.320045] ehci-pci 0000:00:06.1: USB 2.0 started, EHCI 1.00
> [    5.320194] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.320259] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.320338] usb usb2: Product: EHCI Host Controller
> [    5.320399] usb usb2: Manufacturer: Linux 3.17.0-rc1+ ehci_hcd
> [    5.320466] usb usb2: SerialNumber: 0000:00:06.1
> [    5.320733] hub 2-0:1.0: USB hub found
> [    5.320807] hub 2-0:1.0: 5 ports detected
> [    5.321560] ohci-pci 0000:00:04.0: OHCI PCI host controller
> [    5.321632] ohci-pci 0000:00:04.0: new USB bus registered, assigned bus number 3
> [    5.321744] ohci-pci 0000:00:04.0: irq 23, io mem 0xd3488000
> [    5.378095] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.378172] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.378247] usb usb3: Product: OHCI PCI host controller
> [    5.378309] usb usb3: Manufacturer: Linux 3.17.0-rc1+ ohci_hcd
> [    5.378370] usb usb3: SerialNumber: 0000:00:04.0
> [    5.378639] hub 3-0:1.0: USB hub found
> [    5.378708] hub 3-0:1.0: 7 ports detected
> [    5.379315] ohci-pci 0000:00:06.0: OHCI PCI host controller
> [    5.379388] ohci-pci 0000:00:06.0: new USB bus registered, assigned bus number 4
> [    5.379505] ohci-pci 0000:00:06.0: irq 21, io mem 0xd3487000
> [    5.434098] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.434173] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.434245] usb usb4: Product: OHCI PCI host controller
> [    5.434309] usb usb4: Manufacturer: Linux 3.17.0-rc1+ ohci_hcd
> [    5.434372] usb usb4: SerialNumber: 0000:00:06.0
> [    5.434629] hub 4-0:1.0: USB hub found
> [    5.434697] hub 4-0:1.0: 5 ports detected
> [    5.435358] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
> [    5.435429] snd_hda_intel 0000:00:08.0: Disabling MSI
> [    5.444548] input: PC Speaker as /devices/platform/pcspkr/input/input3
> [    5.470947] ssb: Found chip with id 0x4321, rev 0x05 and package 0x00
> [    5.471217] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
> [    5.471223] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
> [    5.471229] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x08, vendor 0x4243)
> [    5.471235] ssb: Core 3 found: PCI (cc 0x804, rev 0x0D, vendor 0x4243)
> [    5.471241] ssb: Core 4 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
> [    5.532332] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
> [    5.550659] cfg80211: Calling CRDA to update world regulatory domain
> [    5.571199] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
> [    5.572850] random: nonblocking pool is initialized
> [    5.581864] cfg80211: World regulatory domain updated:
> [    5.581930] cfg80211:  DFS Master region: unset
> [    5.581991] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [    5.582125] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [    5.582201] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [    5.582276] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [    5.582350] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [    5.582427] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [    5.582502] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> [    5.584276] applesmc: key=154 fan=1 temp=8 index=8 acc=0 lux=0 kbd=0
> [    5.604251] b43-phy0: Found PHY: Analog 5, Type 4 (N), Revision 2
> [    5.604533] b43-phy0: Found Radio: Manuf 0x17F, ID 0x2055, Revision 4, Version 0
> [    5.616333] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [    5.621164] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [    6.069751] sound hdaudioC0D0: ALC889A: SKU not ready 0x400000f0
> [    6.090013] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    6.112050] sound hdaudioC0D0: autoconfig: line_outs=1 (0x18/0x0/0x0/0x0/0x0) type:speaker
> [    6.112135] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    6.112199] sound hdaudioC0D0:    hp_outs=1 (0x14/0x0/0x0/0x0/0x0)
> [    6.112261] sound hdaudioC0D0:    mono: mono_out=0x0
> [    6.112322] sound hdaudioC0D0:    dig-out=0x1e/0x0
> [    6.112382] sound hdaudioC0D0:    inputs:
> [    6.112444] sound hdaudioC0D0:      Line=0x15
> [    6.112504] sound hdaudioC0D0:    dig-in=0x1f
> [    6.122813] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    6.166667] loop: module loaded
> [    6.208762] [drm] Initialized drm 1.1.0 20060810
> [    6.215862] wmi: Mapper loaded
> [    6.227673] ACPI Warning: \_SB_.PCI0.IXVE.IGPU._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140724/nsarguments-95)
> [    6.227873] ACPI: \_SB_.PCI0.IXVE.IGPU: failed to evaluate _DSM
> [    6.228224] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 22
> [    6.229618] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
> [    6.229688] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
> [    6.229760] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
> [    6.230096] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
> [    6.292317] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
> [    6.292393] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
> [    6.292705] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
> [    6.292772] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
> [    6.314398] nouveau 0000:02:00.0: irq 29 for MSI/MSI-X
> [    6.314416] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
> [    6.314523] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
> [    6.314586] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
> [    6.314649] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 0 tags
> [    6.344722] nouveau  [  PTHERM][0000:02:00.0] FAN control: none / external
> [    6.344814] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
> [    6.344877] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
> [    6.344964] nouveau  [     CLK][0000:02:00.0] 03: core 150 MHz shader 300 MHz vdec 150 MHz
> [    6.352490] nouveau  [     CLK][0000:02:00.0] 05: core 150 MHz shader 300 MHz vdec 150 MHz
> [    6.352568] nouveau  [     CLK][0000:02:00.0] 0e: core 350 MHz shader 800 MHz vdec 350 MHz
> [    6.352645] nouveau  [     CLK][0000:02:00.0] 0f: core 450 MHz shader 1100 MHz vdec 450 MHz
> [    6.352743] nouveau  [     CLK][0000:02:00.0] --: core 350 MHz shader 800 MHz vdec 350 MHz
> [    6.352988] [TTM] Zone  kernel: Available graphics memory: 1887544 kiB
> [    6.353052] [TTM] Initializing pool allocator
> [    6.353123] [TTM] Initializing DMA pool allocator
> [    6.353200] nouveau  [     DRM] VRAM: 256 MiB
> [    6.353262] nouveau  [     DRM] GART: 1048576 MiB
> [    6.353328] nouveau  [     DRM] TMDS table version 2.0
> [    6.353389] nouveau  [     DRM] DCB version 4.0
> [    6.353453] nouveau  [     DRM] DCB outp 00: 02021286 0f220010
> [    6.353516] nouveau  [     DRM] DCB outp 01: 01000122 00000010
> [    6.353581] nouveau  [     DRM] DCB outp 02: 01000120 0000001e
> [    6.353642] nouveau  [     DRM] DCB outp 03: 02021232 00000010
> [    6.353707] nouveau  [     DRM] DCB conn 00: 00001020
> [    6.353816] nouveau  [     DRM] DCB conn 01: 0000a146
> [    6.353925] nouveau  [     DRM] DCB conn 02: 00005246
> [    6.363820] nouveau W[     DRM] unknown connector type 20
> [    6.364527] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    6.364590] [drm] Driver supports precise vblank timestamp query.
> [    6.376583] nouveau  [     DRM] MM: using M2MF for buffer copies
> [    6.444035] usb 4-1: new full-speed USB device number 2 using ohci-pci
> [    6.489346] nouveau  [     DRM] allocated 1920x1200 fb: 0x50000, bo ffff88013a4d7000
> [    6.490037] fbcon: nouveaufb (fb0) is primary device
> [    6.564449] Console: switching to colour frame buffer device 240x75
> [    6.568492] nouveau 0000:02:00.0: fb0: nouveaufb frame buffer device
> [    6.568507] nouveau 0000:02:00.0: registered panic notifier
> [    6.576058] [drm] Initialized nouveau 1.2.0 20120801 for 0000:02:00.0 on minor 0
> [    6.669088] usb 4-1: New USB device found, idVendor=0a5c, idProduct=4500
> [    6.669113] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    6.669135] usb 4-1: Product: BCM2045B2
> [    6.669149] usb 4-1: Manufacturer: Broadcom
> [    6.672154] hub 4-1:1.0: USB hub found
> [    6.675084] hub 4-1:1.0: 3 ports detected
> [    6.992064] usb 4-2: new low-speed USB device number 3 using ohci-pci
> [    7.205103] usb 4-2: New USB device found, idVendor=046d, idProduct=c05b
> [    7.205136] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.205158] usb 4-2: Product: USB Optical Mouse
> [    7.205172] usb 4-2: Manufacturer: Logitech
> [    7.232443] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:08.0/sound/card0/hdaudioC0D0/input4
> [    7.234450] input: HDA NVidia Line as /devices/pci0000:00/0000:00:08.0/sound/card0/input5
> [    7.234576] input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input6
> [    7.644066] usb 3-1: new full-speed USB device number 2 using ohci-pci
> [    7.856059] usb 3-1: New USB device found, idVendor=17ef, idProduct=6047
> [    7.856089] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.856508] usb 3-1: Product: ThinkPad Compact USB Keyboard with TrackPoint
> [    7.856520] usb 3-1: Manufacturer: Lenovo
> [    7.979387] RPC: Registered named UNIX socket transport module.
> [    7.979417] RPC: Registered udp transport module.
> [    7.979427] RPC: Registered tcp transport module.
> [    7.979437] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    7.983708] FS-Cache: Loaded
> [    7.991183] FS-Cache: Netfs 'nfs' registered for caching
> [    7.999831] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    8.168035] usb 3-5: new low-speed USB device number 3 using ohci-pci
> [    8.330919] NET: Registered protocol family 15
> [    8.383061] usb 3-5: New USB device found, idVendor=05ac, idProduct=8242
> [    8.383533] usb 3-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    8.384114] usb 3-5: Product: IR Receiver
> [    8.385020] usb 3-5: Manufacturer: Apple Computer, Inc.
> [    8.501580] hidraw: raw HID events driver (C) Jiri Kosina
> [    8.529427] usbcore: registered new interface driver usbhid
> [    8.529923] usbhid: USB HID core driver
> [    8.540231] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:06.0/usb4/4-2/4-2:1.0/0003:046D:C05B.0001/input/input7
> [    8.541010] hid-generic 0003:046D:C05B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:06.0-2/input0
> [    8.541877] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:04.0/usb3/3-1/3-1:1.0/0003:17EF:6047.0002/input/input8
> [    8.545495] hid-generic 0003:17EF:6047.0002: input,hidraw1: USB HID v1.00 Keyboard [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:04.0-1/input0
> [    8.546829] input: Lenovo ThinkPad Compact USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:04.0/usb3/3-1/3-1:1.1/0003:17EF:6047.0003/input/input9
> [    8.549690] hid-generic 0003:17EF:6047.0003: input,hiddev0,hidraw2: USB HID v1.00 Mouse [Lenovo ThinkPad Compact USB Keyboard with TrackPoint] on usb-0000:00:04.0-1/input1
> [    8.725255] usb 4-1.1: new full-speed USB device number 4 using ohci-pci
> [    8.793558] Process accounting resumed
> [    8.848091] usb 4-1.1: New USB device found, idVendor=05ac, idProduct=8216
> [    8.848634] usb 4-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    8.849563] usb 4-1.1: Product: Bluetooth USB Host Controller
> [    8.850701] usb 4-1.1: Manufacturer: Apple, Inc.
> [    8.851835] usb 4-1.1: SerialNumber: 002436EB7CF7
> [    9.066240] Bluetooth: Core ver 2.19
> [    9.066868] NET: Registered protocol family 31
> [    9.067741] Bluetooth: HCI device and connection manager initialized
> [    9.069241] Bluetooth: HCI socket layer initialized
> [    9.070094] Bluetooth: L2CAP socket layer initialized
> [    9.071241] Bluetooth: SCO socket layer initialized
> [    9.079044] usbcore: registered new interface driver btusb
> [    9.413913] lp: driver loaded but no devices found
> [    9.427712] ppdev: user-space parallel port driver
> [    9.616558] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input10
> [    9.792047] Ebtables v2.0 registered
> [    9.816894] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    9.837843] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   11.468123] ------------[ cut here ]------------
> [   11.468602] WARNING: CPU: 0 PID: 197 at fs/proc/generic.c:521 remove_proc_entry+0x142/0x159()
> [   11.469484] remove_proc_entry: removing non-empty directory 'fs/nfsfs', leaking at least 'volumes'
> [   11.470583] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport autofs4 ecb btusb bluetooth uinput hid_generic usbhid hid deflate ctr twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common blowfish_generic blowfish_x86_64 blowfish_common des_generic cbc xcbc rmd160 sha512_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop snd_hda_codec_realtek snd_hda_codec_generic arc4 b43 rng_core bcma mac80211 cfg80211 rfkill evdev coretemp kvm_intel ssb applesmc pcspkr input_polldev kvm pcmcia pcmcia_core mmc_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore ohci_pci ohci_hcd ehci_pci ehci_hcd shpchp usbcore usb_common i2c_nforce2 acpi_cpufreq button processor thermal_sys ext4 crc16 jbd2 mbcache xor raid6_pq dm_mod netconsole configfs sg sd_mod crc_t10dif crct10dif_common sr_mod cdrom ata_generic firewire_ohci ahci libahci libata microcode firewire_core crc_itu_t scsi_mod forcedeth
> [   11.478294] CPU: 0 PID: 197 Comm: kworker/u4:4 Not tainted 3.17.0-rc1+ #182
> [   11.479622] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
> [   11.480977] Workqueue: netns cleanup_net
> [   11.482292]  0000000000000000 0000000000000009 ffffffff81398aee ffff8800b92cbcf8
> [   11.483630]  ffffffff8103d10f 0000000000000246 ffffffff811622fd ffff8800b875fbc0
> [   11.484986]  ffff88013a4d8ec0 ffffffffa0679108 ffff8800b98bc970 ffffffffa067910b
> [   11.486318] Call Trace:
> [   11.487661]  [<ffffffff81398aee>] ? dump_stack+0x41/0x51
> [   11.489022]  [<ffffffff8103d10f>] ? warn_slowpath_common+0x78/0x90
> [   11.490343]  [<ffffffff811622fd>] ? remove_proc_entry+0x142/0x159
> [   11.491691]  [<ffffffff8103d1bf>] ? warn_slowpath_fmt+0x45/0x4a
> [   11.493033]  [<ffffffff811622fd>] ? remove_proc_entry+0x142/0x159
> [   11.494345]  [<ffffffffa06681d6>] ? nfs_net_exit+0x9/0x12 [nfs]
> [   11.495632]  [<ffffffff812dcc39>] ? ops_exit_list+0x27/0x48
> [   11.496910]  [<ffffffff812dd450>] ? cleanup_net+0xe5/0x182
> [   11.498149]  [<ffffffff8104e683>] ? process_one_work+0x168/0x26a
> [   11.499357]  [<ffffffff8104e96a>] ? worker_thread+0x1c0/0x28d
> [   11.500557]  [<ffffffff8104e7aa>] ? process_scheduled_works+0x25/0x25
> [   11.501717]  [<ffffffff810520ee>] ? kthread+0x99/0xa1
> [   11.502860]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> [   11.504024]  [<ffffffff8139cdec>] ? ret_from_fork+0x7c/0xb0
> [   11.505158]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> [   11.506302] ---[ end trace 8bd56692dd859f1b ]---
> [   12.030536] postgres (3963): /proc/3963/oom_adj is deprecated, please use /proc/3963/oom_score_adj instead.
> [  227.620134] ------------[ cut here ]------------
> [  227.620152] WARNING: CPU: 0 PID: 197 at fs/proc/generic.c:510 remove_proc_entry+0xde/0x159()
> [  227.620163] name 'fs/nfsfs'
> [  227.620170] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport autofs4 ecb btusb bluetooth uinput hid_generic usbhid hid deflate ctr twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common blowfish_generic blowfish_x86_64 blowfish_common des_generic cbc xcbc rmd160 sha512_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop snd_hda_codec_realtek snd_hda_codec_generic arc4 b43 rng_core bcma mac80211 cfg80211 rfkill evdev coretemp kvm_intel ssb applesmc pcspkr input_polldev kvm pcmcia pcmcia_core mmc_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore ohci_pci ohci_hcd ehci_pci ehci_hcd shpchp usbcore usb_common i2c_nforce2 acpi_cpufreq button processor thermal_sys ext4 crc16 jbd2 mbcache xor raid6_pq dm_mod netconsole configfs sg sd_mod crc_t10dif crct10dif_common sr_mod cdrom ata_generic firewire_ohci ahci libahci libata microcode firewire_core crc_itu_t scsi_mod forcedeth
> [  227.620691] CPU: 0 PID: 197 Comm: kworker/u4:4 Tainted: G        W      3.17.0-rc1+ #182
> [  227.620697] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
> [  227.620706] Workqueue: netns cleanup_net
> [  227.620712]  0000000000000000 0000000000000009 ffffffff81398aee ffff8800b92cbcf8
> [  227.620731]  ffffffff8103d10f 0000000000000246 ffffffff81162299 ffff8800a7ccd240
> [  227.620743]  0000000000000000 ffffffffa0679108 ffff88013b298b70 ffffffffa067910b
> [  227.620760] Call Trace:
> [  227.620771]  [<ffffffff81398aee>] ? dump_stack+0x41/0x51
> [  227.620780]  [<ffffffff8103d10f>] ? warn_slowpath_common+0x78/0x90
> [  227.620787]  [<ffffffff81162299>] ? remove_proc_entry+0xde/0x159
> [  227.620800]  [<ffffffff8103d1bf>] ? warn_slowpath_fmt+0x45/0x4a
> [  227.620806]  [<ffffffff81162299>] ? remove_proc_entry+0xde/0x159
> [  227.620823]  [<ffffffffa06681d6>] ? nfs_net_exit+0x9/0x12 [nfs]
> [  227.620828]  [<ffffffff812dcc39>] ? ops_exit_list+0x27/0x48
> [  227.620837]  [<ffffffff812dd450>] ? cleanup_net+0xe5/0x182
> [  227.620843]  [<ffffffff8104e683>] ? process_one_work+0x168/0x26a
> [  227.620850]  [<ffffffff8104e96a>] ? worker_thread+0x1c0/0x28d
> [  227.620856]  [<ffffffff8104e7aa>] ? process_scheduled_works+0x25/0x25
> [  227.620863]  [<ffffffff810520ee>] ? kthread+0x99/0xa1
> [  227.620870]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> [  227.620878]  [<ffffffff8139cdec>] ? ret_from_fork+0x7c/0xb0
> [  227.620884]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> [  227.620890] ---[ end trace 8bd56692dd859f1c ]---
> [  227.788111] ------------[ cut here ]------------
> [  227.788136] WARNING: CPU: 1 PID: 197 at fs/proc/generic.c:510 remove_proc_entry+0xde/0x159()
> [  227.788141] name 'fs/nfsfs'
> [  227.788144] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parport autofs4 ecb btusb bluetooth uinput hid_generic usbhid hid deflate ctr twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common blowfish_generic blowfish_x86_64 blowfish_common des_generic cbc xcbc rmd160 sha512_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm loop snd_hda_codec_realtek snd_hda_codec_generic arc4 b43 rng_core bcma mac80211 cfg80211 rfkill evdev coretemp kvm_intel ssb applesmc pcspkr input_polldev kvm pcmcia pcmcia_core mmc_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore ohci_pci ohci_hcd ehci_pci ehci_hcd shpchp usbcore usb_common i2c_nforce2 acpi_cpufreq button processor thermal_sys ext4 crc16 jbd2 mbcache xor raid6_pq dm_mod netconsole configfs sg sd_mod crc_t10dif crct10dif_common sr_mod cdrom ata_generic firewire_ohci ahci libahci libata microcode firewire_core crc_itu_t scsi_mod forcedeth
> [  227.788471] CPU: 1 PID: 197 Comm: kworker/u4:4 Tainted: G        W      3.17.0-rc1+ #182
> [  227.788478] Hardware name: Apple Inc. Macmini3,1/Mac-F22C86C8, BIOS     MM31.88Z.0081.B06.0904271717 04/27/09
> [  227.788487] Workqueue: netns cleanup_net
> [  227.788492]  0000000000000000 0000000000000009 ffffffff81398aee ffff8800b92cbcf8
> [  227.788502]  ffffffff8103d10f 0000000000000246 ffffffff81162299 ffff88013a811b40
> [  227.788512]  0000000000000000 ffffffffa0679108 ffff88013b298b70 ffffffffa067910b
> [  227.788523] Call Trace:
> [  227.788532]  [<ffffffff81398aee>] ? dump_stack+0x41/0x51
> [  227.788539]  [<ffffffff8103d10f>] ? warn_slowpath_common+0x78/0x90
> [  227.788545]  [<ffffffff81162299>] ? remove_proc_entry+0xde/0x159
> [  227.788555]  [<ffffffff8103d1bf>] ? warn_slowpath_fmt+0x45/0x4a
> [  227.788563]  [<ffffffff81162299>] ? remove_proc_entry+0xde/0x159
> [  227.788578]  [<ffffffffa06681d6>] ? nfs_net_exit+0x9/0x12 [nfs]
> [  227.788583]  [<ffffffff812dcc39>] ? ops_exit_list+0x27/0x48
> [  227.788590]  [<ffffffff812dd450>] ? cleanup_net+0xe5/0x182
> [  227.788596]  [<ffffffff8104e683>] ? process_one_work+0x168/0x26a
> [  227.788601]  [<ffffffff8104e96a>] ? worker_thread+0x1c0/0x28d
> [  227.788607]  [<ffffffff8104e7aa>] ? process_scheduled_works+0x25/0x25
> [  227.788612]  [<ffffffff810520ee>] ? kthread+0x99/0xa1
> [  227.788618]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> [  227.788624]  [<ffffffff8139cdec>] ? ret_from_fork+0x7c/0xb0
> [  227.788629]  [<ffffffff81052055>] ? __kthread_parkme+0x58/0x58
> [  227.788633] ---[ end trace 8bd56692dd859f1d ]---
> [  299.812125] mce: [Hardware Error]: Machine check events logged
>
> Anyone?
>

See the thread on

  http://lkml.kernel.org/r/1408217806-25877-1-git-send-email-xiyou.wangcong@gmail.com

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
