Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaCVPdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:33:45 -0400
Received: from fep22.mx.upcmail.net ([62.179.121.42]:47615 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaCVPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:32:55 -0400
X-Greylist: delayed 1005 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Mar 2014 11:32:54 EDT
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <532DA935.4010907@odi.ch>
Date: Sat, 22 Mar 2014 16:16:05 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, christian.koenig@amd.com
Subject: [bisected] drm/radeon: fences regression
Content-Type: multipart/mixed;
 boundary="------------020705070805090103030803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020705070805090103030803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I am seeing a GPU lockup from any v3.13 up to 3.14-rc7, which basically renders 
my computer unusable under recent kernels :-(

[   55.762710] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000msec
[   55.762715] radeon 0000:01:00.0: GPU lockup (waiting for 0x0000000000000004 
last fence id 0x000000000000000 on ring 5)
[   55.762717] [drm:uvd_v1_0_ib_test] *ERROR* radeon: fence wait failed (-35).
[   55.762720] [drm:radeon_ib_ring_tests] *ERROR* radeon: failed testing IB on 
ring 5 (-35).

Hardware is an iMac 11,2 with a Radeon 4670 M96XT (RV730), 256MB GDDR3.


Bisected to this commit:

commit f9eaf9ae782d6480f179850e27e6f4911ac10227
Author: Christian König <christian.koenig@amd.com>
Date:   Tue Oct 29 20:14:47 2013 +0100

     drm/radeon: rework and fix reset detection v2

     Stop fiddling with jiffies, always wait for RADEON_FENCE_JIFFIES_TIMEOUT.
     Consolidate the two wait sequence implementations into just one function.
     Activate all waiters and remember if the reset was already done instead of
     trying to reset from only one thread.

     v2: clear reset flag earlier to avoid timeout in IB test

Unfortunately this patch no longer cleanly unapplies on v3.13.

--------------020705070805090103030803
Content-Type: text/x-log;
 name="kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel.log"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7+ (root@gandalf) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.3, pie-0.5.5) ) #10 SMP PREEMPT Sat Mar 22 16:02:10 CET 2014
[    0.000000] Command line: root=/dev/sda3 root=/dev/sda3 rootfstype=ext4 net.ifnames=0 snd-hda-intel.model=imac27 video=eDP-1:1920x1080MR@60e
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000008dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf672fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf673000-0x00000000bf6eefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf6ef000-0x00000000bf7f5fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf7f6000-0x00000000bf7fefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf7ff000-0x00000000bf7fffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf800000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Apple Inc. iMac11,2/Mac-F2238AC8, BIOS    IM112.88Z.0057.B00.1005031455 05/03/10
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xbf673 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0209c000, 0x0209cfff] PGTABLE
[    0.000000] BRK [0x0209d000, 0x0209dfff] PGTABLE
[    0.000000] BRK [0x0209e000, 0x0209efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13be00000-0x13bffffff]
[    0.000000]  [mem 0x13be00000-0x13bffffff] page 2M
[    0.000000] BRK [0x0209f000, 0x0209ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x138000000-0x13bdfffff]
[    0.000000]  [mem 0x138000000-0x13bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x137ffffff]
[    0.000000]  [mem 0x100000000-0x137ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf672fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf672fff] page 4k
[    0.000000] ACPI: RSDP 00000000000fe020 000024 (v02 APPLE )
[    0.000000] ACPI: XSDT 00000000bf70e1c0 000084 (v01 APPLE   Apple00 00000057      01000013)
[    0.000000] ACPI: FACP 00000000bf70b000 0000F4 (v04 APPLE   Apple00 00000057 Loki 0000005F)
[    0.000000] ACPI: DSDT 00000000bf6ff000 00571C (v01 APPLE      iMac 00110001 INTL 20061109)
[    0.000000] ACPI: FACS 00000000bf67a000 000040
[    0.000000] ACPI: ASF! 00000000bf70d000 0000A5 (v32 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: HPET 00000000bf70a000 000038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 00000000bf709000 0000BC (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 00000000bf708000 0000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 00000000bf706000 000030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 00000000bf705000 000053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 00000000bf6fa000 000518 (v01 APPLE  UsbNoRmh 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bf6f7000 000A10 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: MCFG 00000000bf707000 00003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 00000000bf6fe000 0000FA (v01 SataRe  SataPri 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bf6fd000 0000FA (v01 SataRe  SataSec 00001000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff880137600000-ffff88013b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008dfff]
[    0.000000]   node   0: [mem 0x00090000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbf672fff]
[    0.000000]   node   0: [mem 0x100000000-0x13bffffff]
[    0.000000] On node 0 totalpages: 1029647
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12186 pages used for memmap
[    0.000000]   DMA32 zone: 779891 pages, LIFO batch:31
[    0.000000]   Normal zone: 3840 pages used for memmap
[    0.000000]   Normal zone: 245760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0008e000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000bffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000c0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf673000-0xbf6eefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf6ef000-0xbf7f5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf7f6000-0xbf7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf7ff000-0xbf7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013bc00000 s79808 r8192 d22592 u262144
[    0.000000] pcpu-alloc: s79808 r8192 d22592 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013536
[    0.000000] Kernel command line: root=/dev/sda3 root=/dev/sda3 rootfstype=ext4 net.ifnames=0 snd-hda-intel.model=imac27 video=eDP-1:1920x1080MR@60e
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3962780K/4118588K available (8260K kernel code, 827K rwdata, 2616K rodata, 972K init, 832K bss, 155808K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3058.933 MHz processor
[    0.000022] Calibrating delay loop (skipped), value calculated using timer frequency.. 6117.86 BogoMIPS (lpj=12235732)
[    0.000184] pid_max: default: 32768 minimum: 301
[    0.000266] ACPI: Core revision 20131218
[    0.002667] ACPI: All ACPI Tables successfully acquired
[    0.002849] Mount-cache hash table entries: 256
[    0.003049] Initializing cgroup subsys blkio
[    0.003144] Disabled fast string operations
[    0.003223] CPU: Physical Processor ID: 0
[    0.003300] CPU: Processor Core ID: 0
[    0.003380] mce: CPU supports 9 MCE banks
[    0.003463] CPU0: Thermal LVT vector (0xfa) already installed
[    0.003469] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 6
[    0.003703] Freeing SMP alternatives memory: 28K (ffffffff81fc3000 - ffffffff81fca000)
[    0.004206] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043998] smpboot: CPU0: Intel(R) Core(TM) i3 CPU         540  @ 3.07GHz (fam: 06, model: 25, stepping: 05)
[    0.150924] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.151168] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.151252] ... version:                3
[    0.151330] ... bit width:              48
[    0.151407] ... generic registers:      4
[    0.151485] ... value mask:             0000ffffffffffff
[    0.151563] ... max period:             000000007fffffff
[    0.151642] ... fixed-purpose events:   3
[    0.151720] ... event mask:             000000070000000f
[    0.174967] x86: Booting SMP configuration:
[    0.175045] .... node  #0, CPUs:      #1
[    0.186107] Disabled fast string operations
[    0.186121] CPU1: Thermal LVT vector (0xfa) already installed
[    0.194991]  #2
[    0.206220] Disabled fast string operations
[    0.206233] CPU2: Thermal LVT vector (0xfa) already installed
[    0.226125]  #3
[    0.226125] Disabled fast string operations
[    0.226137] CPU3: Thermal LVT vector (0xfa) already installed
[    0.228252] x86: Booted up 1 node, 4 CPUs
[    0.228484] smpboot: Total of 4 processors activated (24471.46 BogoMIPS)
[    0.230476] devtmpfs: initialized
[    0.230748] PM: Registering ACPI NVS region [mem 0xbf673000-0xbf6eefff] (507904 bytes)
[    0.231059] NET: Registered protocol family 16
[    0.231389] cpuidle: using governor ladder
[    0.231468] cpuidle: using governor menu
[    0.231580] ACPI: bus type PCI registered
[    0.231742] dca service started, version 1.12.1
[    0.231855] PCI: MMCONFIG for domain 0000 [bus 00-06] at [mem 0xe0000000-0xe06fffff] (base 0xe0000000)
[    0.231976] PCI: MMCONFIG at [mem 0xe0000000-0xe06fffff] reserved in E820
[    0.232458] PCI: Using configuration type 1 for base access
[    0.238749] bio: create slab <bio-0> at 0
[    0.238925] ACPI: Added _OSI(Module Device)
[    0.239008] ACPI: Added _OSI(Processor Device)
[    0.239085] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.239164] ACPI: Added _OSI(Processor Aggregator Device)
[    0.239914] ACPI : EC: EC description table is found, configuring boot EC
[    0.242585] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.242926] ACPI: SSDT 00000000bf7f9598 0004FF (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.243244] ACPI: Dynamic OEM Table Load:
[    0.243399] ACPI: SSDT           (null) 0004FF (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.243638] ACPI: SSDT 00000000bf7f7798 0006E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.243945] ACPI: Dynamic OEM Table Load:
[    0.244100] ACPI: SSDT           (null) 0006E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.268399] ACPI: SSDT 00000000bf7f8c18 0003A4 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.268752] ACPI: Dynamic OEM Table Load:
[    0.268907] ACPI: SSDT           (null) 0003A4 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.280309] ACPI: SSDT 00000000bf7f6d98 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.280634] ACPI: Dynamic OEM Table Load:
[    0.280788] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.292585] ACPI: Interpreter enabled
[    0.292666] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
[    0.293683] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    0.293890] ACPI: (supports S0 S3 S4 S5)
[    0.293967] ACPI: Using IOAPIC for interrupt routing
[    0.294093] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.307605] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.307690] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.307797] \_SB_.PCI0:_OSC invalid UUID
[    0.307797] _OSC request data:1 1f 0 
[    0.307800] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.308242] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-06] only partially covers this bridge
[    0.308410] PCI host bridge to bus 0000:00
[    0.308489] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.308569] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.308651] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.308732] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.308816] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeafffff]
[    0.308904] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.309007] pci 0000:00:01.0: [8086:0041] type 01 class 0x060400
[    0.309034] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.309077] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.309220] pci 0000:00:1a.0: [8086:3b3b] type 00 class 0x0c0300
[    0.309254] pci 0000:00:1a.0: reg 0x20: [io  0x3100-0x311f]
[    0.309372] pci 0000:00:1a.7: [8086:3b3c] type 00 class 0x0c0320
[    0.309390] pci 0000:00:1a.7: reg 0x10: [mem 0xd0505c00-0xd0505fff]
[    0.309464] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.309510] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.309640] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.309652] pci 0000:00:1b.0: reg 0x10: [mem 0xd0500000-0xd0503fff 64bit]
[    0.309711] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.309756] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.309881] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.309938] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.309983] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.310111] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.310167] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.310214] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.310340] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.310396] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.310443] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.310574] pci 0000:00:1d.0: [8086:3b36] type 00 class 0x0c0300
[    0.310607] pci 0000:00:1d.0: reg 0x20: [io  0x30a0-0x30bf]
[    0.310725] pci 0000:00:1d.7: [8086:3b34] type 00 class 0x0c0320
[    0.310742] pci 0000:00:1d.7: reg 0x10: [mem 0xd0505800-0xd0505bff]
[    0.310816] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.310863] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.310988] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.311105] pci 0000:00:1f.0: [8086:3b02] type 00 class 0x060100
[    0.311274] pci 0000:00:1f.2: [8086:3b20] type 00 class 0x01018f
[    0.311286] pci 0000:00:1f.2: reg 0x10: [io  0x3128-0x312f]
[    0.311292] pci 0000:00:1f.2: reg 0x14: [io  0x3134-0x3137]
[    0.311298] pci 0000:00:1f.2: reg 0x18: [io  0x3120-0x3127]
[    0.311303] pci 0000:00:1f.2: reg 0x1c: [io  0x3130-0x3133]
[    0.311309] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x302f]
[    0.311315] pci 0000:00:1f.2: reg 0x24: [io  0xffe0-0xffef]
[    0.311419] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.311431] pci 0000:00:1f.3: reg 0x10: [mem 0xd0506000-0xd05060ff 64bit]
[    0.311447] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.311543] pci 0000:00:1f.6: [8086:3b32] type 00 class 0x118000
[    0.311561] pci 0000:00:1f.6: reg 0x10: [mem 0xd0504000-0xd0504fff 64bit]
[    0.311740] pci 0000:01:00.0: [1002:9488] type 00 class 0x030000
[    0.311750] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.311758] pci 0000:01:00.0: reg 0x18: [mem 0xd0420000-0xd042ffff 64bit]
[    0.311763] pci 0000:01:00.0: reg 0x20: [io  0x2000-0x20ff]
[    0.311773] pci 0000:01:00.0: reg 0x30: [mem 0xd0400000-0xd041ffff pref]
[    0.311798] pci 0000:01:00.0: supports D1 D2
[    0.311813] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.311941] pci 0000:01:00.1: [1002:aa38] type 00 class 0x040300
[    0.311951] pci 0000:01:00.1: reg 0x10: [mem 0xd0430000-0xd0433fff 64bit]
[    0.311997] pci 0000:01:00.1: supports D1 D2
[    0.312056] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.312137] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.312139] pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd04fffff]
[    0.312141] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.312217] pci 0000:02:00.0: [14e4:1684] type 00 class 0x020000
[    0.312238] pci 0000:02:00.0: reg 0x10: [mem 0xd0300000-0xd030ffff 64bit]
[    0.312289] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.312378] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.312411] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.320300] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.320381] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.320384] pci 0000:00:1c.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.320388] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd07fffff 64bit pref]
[    0.320460] pci 0000:03:00.0: [168c:002a] type 00 class 0x028000
[    0.320481] pci 0000:03:00.0: reg 0x10: [mem 0xd0200000-0xd020ffff 64bit]
[    0.320595] pci 0000:03:00.0: supports D1
[    0.320596] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.320620] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.320740] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.320865] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.320946] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.320948] pci 0000:00:1c.1:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.320952] pci 0000:00:1c.1:   bridge window [mem 0xd0800000-0xd09fffff 64bit pref]
[    0.321029] pci 0000:04:00.0: [104c:823e] type 01 class 0x060400
[    0.321143] pci 0000:04:00.0: supports D1 D2
[    0.328305] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.328386] pci 0000:00:1c.2:   bridge window [io  0x6000-0x6fff]
[    0.328389] pci 0000:00:1c.2:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.328393] pci 0000:00:1c.2:   bridge window [mem 0xd0a00000-0xd0bfffff 64bit pref]
[    0.328489] pci 0000:05:00.0: [104c:823f] type 00 class 0x0c0010
[    0.328512] pci 0000:05:00.0: reg 0x10: [mem 0xd0104000-0xd01047ff]
[    0.328525] pci 0000:05:00.0: reg 0x14: [mem 0xd0100000-0xd0103fff]
[    0.328622] pci 0000:05:00.0: supports D1 D2
[    0.328623] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot
[    0.328730] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.328819] pci 0000:04:00.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.328904] pci 0000:00:1e.0: PCI bridge to [bus 06] (subtractive decode)
[    0.328990] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
[    0.328994] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.328995] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.328996] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.328997] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfeafffff] (subtractive decode)
[    0.329020] pci_bus 0000:00: on NUMA node 0
[    0.329123] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.329785] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15), disabled.
[    0.330407] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.331066] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15), disabled.
[    0.331687] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.332353] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10, disabled.
[    0.333014] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11, disabled.
[    0.333677] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15), disabled.
[    0.334284] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.334366] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.334453] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.334538] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.334702] PCI host bridge to bus 0000:ff
[    0.334781] pci_bus 0000:ff: root bus resource [bus ff]
[    0.334864] pci 0000:ff:00.0: [8086:2c61] type 00 class 0x060000
[    0.334916] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.334970] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.335018] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.335067] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.335115] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.335169] pci_bus 0000:ff: on NUMA node 0
[    0.335214] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.335385] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.335582] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.335669] vgaarb: loaded
[    0.335743] vgaarb: bridge control possible 0000:01:00.0
[    0.335925] SCSI subsystem initialized
[    0.336080] libata version 3.00 loaded.
[    0.336156] ACPI: bus type USB registered
[    0.336278] usbcore: registered new interface driver usbfs
[    0.336382] usbcore: registered new interface driver hub
[    0.336491] usbcore: registered new device driver usb
[    0.336627] Linux video capture interface: v2.00
[    0.336755] pps_core: LinuxPPS API ver. 1 registered
[    0.336834] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.336970] PTP clock support registered
[    0.337097] EDAC MC: Ver: 3.0.0
[    0.337408] Advanced Linux Sound Architecture Driver Initialized.
[    0.337490] PCI: Using ACPI for IRQ routing
[    0.337569] PCI: pci_cache_line_size set to 64 bytes
[    0.337616] e820: reserve RAM buffer [mem 0x0008e000-0x0008ffff]
[    0.337617] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.337618] e820: reserve RAM buffer [mem 0xbf673000-0xbfffffff]
[    0.337761] NET: Registered protocol family 23
[    0.337852] Bluetooth: Core ver 2.18
[    0.337947] NET: Registered protocol family 31
[    0.338026] Bluetooth: HCI device and connection manager initialized
[    0.338109] Bluetooth: HCI socket layer initialized
[    0.338188] Bluetooth: L2CAP socket layer initialized
[    0.338271] Bluetooth: SCO socket layer initialized
[    0.338430] cfg80211: Calling CRDA to update world regulatory domain
[    0.338582] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.339016] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.341117] Switched to clocksource hpet
[    0.343596] pnp: PnP ACPI init
[    0.343690] ACPI: bus type PNP registered
[    0.343810] pnp 00:00: [dma 4]
[    0.343854] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.343898] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.344027] system 00:02: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.344112] system 00:02: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.344160] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.344219] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.344301] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.344384] system 00:04: [io  0xffff] has been reserved
[    0.344472] system 00:04: [io  0xffff] has been reserved
[    0.344552] system 00:04: [io  0x0400-0x047f] could not be reserved
[    0.344634] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.344715] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.344796] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.344868] system 00:05: [io  0x06a0-0x06af] has been reserved
[    0.344950] system 00:05: [io  0x06b0-0x06ff] has been reserved
[    0.345032] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.345077] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.345133] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    0.345321] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.345404] system 00:08: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.345488] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.345570] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.345652] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.345734] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.345816] system 00:08: [mem 0xfeb00000-0xfeb03fff] has been reserved
[    0.345898] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.345980] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    0.346064] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.346148] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.346257] pnp: PnP ACPI: found 9 devices
[    0.346334] ACPI: bus type PNP unregistered
[    0.354288] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.354370] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.354452] pci 0000:00:01.0:   bridge window [mem 0xd0400000-0xd04fffff]
[    0.354536] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.354624] pci 0000:02:00.0: BAR 6: assigned [mem 0xd0600000-0xd060ffff pref]
[    0.354708] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.354788] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.354870] pci 0000:00:1c.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.354955] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd07fffff 64bit pref]
[    0.355042] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.355122] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.355206] pci 0000:00:1c.1:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.355290] pci 0000:00:1c.1:   bridge window [mem 0xd0800000-0xd09fffff 64bit pref]
[    0.355377] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.355462] pci 0000:04:00.0:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.355553] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
[    0.355633] pci 0000:00:1c.2:   bridge window [io  0x6000-0x6fff]
[    0.355716] pci 0000:00:1c.2:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.355800] pci 0000:00:1c.2:   bridge window [mem 0xd0a00000-0xd0bfffff 64bit pref]
[    0.355887] pci 0000:00:1e.0: PCI bridge to [bus 06]
[    0.355968] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
[    0.356056] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.356057] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.356058] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.356059] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfeafffff]
[    0.356060] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.356061] pci_bus 0000:01: resource 1 [mem 0xd0400000-0xd04fffff]
[    0.356062] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.356063] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.356064] pci_bus 0000:02: resource 1 [mem 0xd0300000-0xd03fffff]
[    0.356065] pci_bus 0000:02: resource 2 [mem 0xd0600000-0xd07fffff 64bit pref]
[    0.356066] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.356067] pci_bus 0000:03: resource 1 [mem 0xd0200000-0xd02fffff]
[    0.356068] pci_bus 0000:03: resource 2 [mem 0xd0800000-0xd09fffff 64bit pref]
[    0.356070] pci_bus 0000:04: resource 0 [io  0x6000-0x6fff]
[    0.356071] pci_bus 0000:04: resource 1 [mem 0xd0100000-0xd01fffff]
[    0.356072] pci_bus 0000:04: resource 2 [mem 0xd0a00000-0xd0bfffff 64bit pref]
[    0.356073] pci_bus 0000:05: resource 1 [mem 0xd0100000-0xd01fffff]
[    0.356074] pci_bus 0000:06: resource 1 [mem 0xd0000000-0xd00fffff]
[    0.356075] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.356076] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.356077] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.356078] pci_bus 0000:06: resource 7 [mem 0xc0000000-0xfeafffff]
[    0.356106] NET: Registered protocol family 2
[    0.356282] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.356411] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.356573] TCP: Hash tables configured (established 32768 bind 32768)
[    0.356682] TCP: reno registered
[    0.356759] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.356852] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.356980] NET: Registered protocol family 1
[    0.357430] pci 0000:01:00.0: Boot video device
[    0.357442] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.357455] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.357538] software IO TLB [mem 0xbb673000-0xbf673000] (64MB) mapped at [ffff8800bb673000-ffff8800bf672fff]
[    0.357874] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x4
[    0.357959] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x4
[    0.358043] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x4
[    0.358128] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x4
[    0.358260] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.359057] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    0.359158] PCLMULQDQ-NI instructions are not detected.
[    0.359238] sha256_ssse3: Using SSSE3 optimized SHA-256 implementation
[    0.359357] sha512_ssse3: Using SSSE3 optimized SHA-512 implementation
[    0.359475] AVX or AES-NI instructions are not detected.
[    0.359556] AVX instructions are not detected.
[    0.359634] AVX2 or AES-NI instructions are not detected.
[    0.360178] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.360305] audit: initializing netlink subsys (disabled)
[    0.360394] audit: type=2000 audit(1395500771.244:1): initialized
[    0.360739] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.363909] NTFS driver 2.1.30 [Flags: R/W].
[    0.364108] msgmni has been set to 7739
[    0.364748] NET: Registered protocol family 38
[    0.364827] Key type asymmetric registered
[    0.364905] Asymmetric key parser 'x509' registered
[    0.365051] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    0.365145] io scheduler noop registered
[    0.365223] io scheduler deadline registered
[    0.365346] io scheduler cfq registered (default)
[    0.365588] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.366659] intel_idle: MWAIT substates: 0x1120
[    0.366660] intel_idle: v0.4 model 0x25
[    0.366660] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.366797] ipmi message handler version 39.2
[    0.366879] ipmi device interface
[    0.366981] IPMI Watchdog: driver initialized
[    0.367155] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.367243] ACPI: Power Button [PWRB]
[    0.367375] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.367461] ACPI: Sleep Button [SLPB]
[    0.367592] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.367676] ACPI: Power Button [PWRF]
[    0.367852] [Firmware Bug]: ACPI(GFX0) defines _DOD but not _DOS
[    0.367942] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.368677] acpi device:03: registered as cooling_device0
[    0.368809] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/LNXVIDEO:00/input/input3
[    0.369449] GHES: HEST is not enabled!
[    0.369527] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.369704] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.370255] lp: driver loaded but no devices found
[    0.371328] Non-volatile memory driver v1.3
[    0.371461] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    0.371580] Hangcheck: Using getrawmonotonic().
[    0.373843] brd: module loaded
[    0.374825] loop: module loaded
[    0.375012] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20131218/utaddress-258)
[    0.375258] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.375382] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20131218/utaddress-258)
[    0.375626] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.375747] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20131218/utaddress-258)
[    0.375992] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.376114] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20131218/utaddress-258)
[    0.376359] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.376480] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    0.376777] ata_piix 0000:00:1f.2: version 2.13
[    0.376864] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.530129] scsi0 : ata_piix
[    0.530350] scsi1 : ata_piix
[    0.530517] ata1: SATA max UDMA/133 cmd 0x3128 ctl 0x3134 bmdma 0x3020 irq 19
[    0.530603] ata2: SATA max UDMA/133 cmd 0x3120 ctl 0x3130 bmdma 0x3028 irq 19
[    0.531057] tg3.c:v3.136 (Jan 03, 2014)
[    0.628814] tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM95764m) rev 5784100] (PCI Express) MAC address c4:2c:03:04:79:f7
[    0.628938] tg3 0000:02:00.0 eth0: attached PHY is 5784 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    0.629060] tg3 0000:02:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.629145] tg3 0000:02:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.059500] ath: EEPROM regdomain: 0x37
[    1.059501] ath: EEPROM indicates we should expect a direct regpair map
[    1.059502] ath: Country alpha2 being used: AW
[    1.059503] ath: Regpair used: 0x37
[    1.059504] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
[    1.059505] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059506] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
[    1.059506] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059507] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
[    1.059508] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059508] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
[    1.059509] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059509] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
[    1.059510] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059510] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
[    1.059511] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059512] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
[    1.059512] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059513] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
[    1.059513] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059514] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
[    1.059515] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059515] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
[    1.059516] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059516] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
[    1.059517] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    1.059517] cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits it
[    1.059518] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits it
[    1.059518] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits it
[    1.059519] cfg80211: Updating information on frequency 5180 MHz with regulatory rule:
[    1.059520] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059520] cfg80211: Updating information on frequency 5200 MHz with regulatory rule:
[    1.059521] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059521] cfg80211: Updating information on frequency 5220 MHz with regulatory rule:
[    1.059522] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059522] cfg80211: Updating information on frequency 5240 MHz with regulatory rule:
[    1.059523] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059524] cfg80211: Updating information on frequency 5260 MHz with regulatory rule:
[    1.059524] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059525] cfg80211: Updating information on frequency 5280 MHz with regulatory rule:
[    1.059525] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059526] cfg80211: Updating information on frequency 5300 MHz with regulatory rule:
[    1.059526] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059527] cfg80211: Updating information on frequency 5320 MHz with regulatory rule:
[    1.059528] cfg80211: 5140000 KHz - 5360000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059528] cfg80211: Disabling freq 5500 MHz as custom regd has no rule that fits it
[    1.059529] cfg80211: Disabling freq 5520 MHz as custom regd has no rule that fits it
[    1.059529] cfg80211: Disabling freq 5540 MHz as custom regd has no rule that fits it
[    1.059530] cfg80211: Disabling freq 5560 MHz as custom regd has no rule that fits it
[    1.059530] cfg80211: Disabling freq 5580 MHz as custom regd has no rule that fits it
[    1.059530] cfg80211: Disabling freq 5600 MHz as custom regd has no rule that fits it
[    1.059531] cfg80211: Disabling freq 5620 MHz as custom regd has no rule that fits it
[    1.059531] cfg80211: Disabling freq 5640 MHz as custom regd has no rule that fits it
[    1.059532] cfg80211: Disabling freq 5660 MHz as custom regd has no rule that fits it
[    1.059532] cfg80211: Disabling freq 5680 MHz as custom regd has no rule that fits it
[    1.059533] cfg80211: Disabling freq 5700 MHz as custom regd has no rule that fits it
[    1.059533] cfg80211: Updating information on frequency 5745 MHz with regulatory rule:
[    1.059534] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059534] cfg80211: Updating information on frequency 5765 MHz with regulatory rule:
[    1.059535] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059535] cfg80211: Updating information on frequency 5785 MHz with regulatory rule:
[    1.059536] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059537] cfg80211: Updating information on frequency 5805 MHz with regulatory rule:
[    1.059537] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.059538] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    1.059538] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    1.065245] cfg80211: Ignoring regulatory request set by core since the driver uses its own custom regulatory domain
[    1.065272] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    1.065512] cfg80211: Pending regulatory request, waiting for it to be processed...
[    1.065581] ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xffffc900007a0000, irq=17
[    1.121734] firewire_ohci 0000:05:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x2
[    1.122187] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.122270] ehci-pci: EHCI PCI platform driver
[    1.122446] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    1.122583] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.122677] ehci-pci 0000:00:1a.7: debug port 2
[    1.126659] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    1.126670] ehci-pci 0000:00:1a.7: irq 21, io mem 0xd0505c00
[    1.137726] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.137831] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.137913] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.137997] usb usb1: Product: EHCI Host Controller
[    1.138076] usb usb1: Manufacturer: Linux 3.14.0-rc7+ ehci_hcd
[    1.138156] usb usb1: SerialNumber: 0000:00:1a.7
[    1.138373] hub 1-0:1.0: USB hub found
[    1.138455] hub 1-0:1.0: 6 ports detected
[    1.138732] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.138873] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.138966] ehci-pci 0000:00:1d.7: debug port 2
[    1.142936] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    1.142946] ehci-pci 0000:00:1d.7: irq 23, io mem 0xd0505800
[    1.153735] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.153837] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.153952] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.154035] usb usb2: Product: EHCI Host Controller
[    1.154115] usb usb2: Manufacturer: Linux 3.14.0-rc7+ ehci_hcd
[    1.154195] usb usb2: SerialNumber: 0000:00:1d.7
[    1.154541] hub 2-0:1.0: USB hub found
[    1.154622] hub 2-0:1.0: 8 ports detected
[    1.154911] uhci_hcd: USB Universal Host Controller Interface driver
[    1.155005] uhci_hcd 0000:00:1a.0: Found HC with no IRQ. Check BIOS/PCI 0000:00:1a.0 setup!
[    1.155092] uhci_hcd 0000:00:1a.0: init 0000:00:1a.0 fail, -19
[    1.155178] uhci_hcd 0000:00:1d.0: Found HC with no IRQ. Check BIOS/PCI 0000:00:1d.0 setup!
[    1.155264] uhci_hcd 0000:00:1d.0: init 0000:00:1d.0 fail, -19
[    1.155879] usbcore: registered new interface driver usblp
[    1.156069] usbcore: registered new interface driver usb-storage
[    1.156210] usbcore: registered new interface driver ums-sddr09
[    1.156394] usbcore: registered new interface driver ums-sddr55
[    1.156581] usbcore: registered new interface driver appledisplay
[    1.156775] usbcore: registered new interface driver isight_firmware
[    1.157179] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.450011] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.622262] firewire_core 0000:05:00.0: created device fw0: GUID e80688fffebea1f8, S800
[    1.670251] tsc: Refined TSC clocksource calibration: 3058.999 MHz
[    1.878299] ata2.01: failed to resume link (SControl 0)
[    1.882273] ata1.01: failed to resume link (SControl 0)
[    2.034486] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.034573] ata2.01: SATA link down (SStatus 4 SControl 0)
[    2.034658] ata2.01: link offline, clearing class 3 to NONE
[    2.038492] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.038579] ata1.01: SATA link down (SStatus 4 SControl 0)
[    2.042560] ata2.00: ATAPI: HL-DT-STDVDRW  GA32N, KC09, max UDMA/100
[    2.047068] ata1.00: ATA-8: WDC WD5000AAKS-40V6A0, 05.01D06, max UDMA/133
[    2.047150] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.058576] ata2.00: configured for UDMA/100
[    2.063067] ata1.00: configured for UDMA/133
[    2.063238] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-4 05.0 PQ: 0 ANSI: 5
[    2.063526] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.063643] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.063651] sd 0:0:0:0: [sda] Write Protect is off
[    2.063653] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.063669] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.184037] i8042: No controller found
[    2.184046] usb 1-1: New USB device found, idVendor=0424, idProduct=2514
[    2.184047] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.184322] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRW  GA32N     KC09 PQ: 0 ANSI: 5
[    2.184438] mousedev: PS/2 mouse device common for all mice
[    2.184476] hub 1-1:1.0: USB hub found
[    2.184584] hub 1-1:1.0: 4 ports detected
[    2.185018] usbcore: registered new interface driver appletouch
[    2.185128] usbcore: registered new interface driver bcm5974
[    2.185299] rtc_cmos 00:06: RTC can wake from S4
[    2.185519] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.185620] rtc_cmos 00:06: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.185728] i2c /dev entries driver
[    2.185958] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20131218/utaddress-258)
[    2.186192] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.186403] usbcore: registered new interface driver uvcvideo
[    2.186479] USB Video Class driver (1.1.1)
[    2.193488] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.193568] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.193805] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.193918] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.223550]  sda: sda1 sda2 sda3 sda4
[    2.224196] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.298630] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.423890] applesmc: key=276 fan=3 temp=35 index=34 acc=0 lux=0 kbd=0
[    2.424402] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    2.424491] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    2.424600] iTCO_vendor_support: vendor-support=0
[    2.424709] usbcore: registered new interface driver btusb
[    2.424903] sdhci: Secure Digital Host Controller Interface driver
[    2.424980] sdhci: Copyright(c) Pierre Ossman
[    2.425540] hidraw: raw HID events driver (C) Jiri Kosina
[    2.426046] usbcore: registered new interface driver usbhid
[    2.426121] usbhid: USB HID core driver
[    2.426531] snd_hda_intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[    2.426626] snd_hda_intel 0000:01:00.1: irq 42 for MSI/MSI-X
[    2.426755] GACT probability NOT on
[    2.426833] u32 classifier
[    2.426904]     Actions configured
[    2.426979] Netfilter messages via NETLINK v0.30.
[    2.427065] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.427244] ctnetlink v0.93: registering with nfnetlink.
[    2.427369] xt_time: kernel timezone is -0000
[    2.427448] ip_set: protocol 6
[    2.427737] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.427863] TCP: cubic registered
[    2.427938] Initializing XFRM netlink socket
[    2.428189] NET: Registered protocol family 10
[    2.428734] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input4
[    2.429157] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.429478] sit: IPv6 over IPv4 tunneling driver
[    2.429727] NET: Registered protocol family 17
[    2.429809] NET: Registered protocol family 15
[    2.429888] IrCOMM protocol (Dag Brattli)
[    2.431012] usb 2-1: New USB device found, idVendor=0424, idProduct=2514
[    2.431096] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.431436] hub 2-1:1.0: USB hub found
[    2.431636] hub 2-1:1.0: 4 ports detected
[    2.435518] Bluetooth: RFCOMM socket layer initialized
[    2.435604] Bluetooth: RFCOMM ver 1.11
[    2.435685] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.435767] Bluetooth: HIDP socket layer initialized
[    2.436272] registered taskstats version 1
[    2.437370] PM: Hibernation image not present or could not be loaded.
[    2.437371] ALSA device list:
[    2.437447]   #1: HDA ATI HDMI at 0xd0430000 irq 42
[    2.438014] input: HDA Intel MID SPDIF In as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    2.438296] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    2.438499] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    2.521607] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    2.521699] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[    2.523035] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    2.564025] devtmpfs: mounted
[    2.564800] Freeing unused kernel memory: 972K (ffffffff81ed0000 - ffffffff81fc3000)
[    2.564880] Write protecting the kernel read-only data: 14336k
[    2.568836] Freeing unused kernel memory: 1968K (ffff880001814000 - ffff880001a00000)
[    2.571547] Freeing unused kernel memory: 1480K (ffff880001c8e000 - ffff880001e00000)
[    2.617167] usb 1-1.1: New USB device found, idVendor=0a5c, idProduct=4500
[    2.618075] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.618155] usb 1-1.1: Product: BRCM2046 Hub
[    2.618231] usb 1-1.1: Manufacturer: Apple Inc.
[    2.618990] hub 1-1.1:1.0: USB hub found
[    2.619321] hub 1-1.1:1.0: 3 ports detected
[    2.670990] Switched to clocksource tsc
[    2.707167] usb 1-1.2: new high-speed USB device number 4 using ehci-pci
[    2.820378] usb 1-1.2: New USB device found, idVendor=05ac, idProduct=8403
[    2.820471] usb 1-1.2: New USB device strings: Mfr=3, Product=4, SerialNumber=2
[    2.820550] usb 1-1.2: Product: Card Reader
[    2.820623] usb 1-1.2: Manufacturer: Apple
[    2.820698] usb 1-1.2: SerialNumber: 000000009833
[    2.821835] usb-storage 1-1.2:1.0: USB Mass Storage device detected
[    2.822151] scsi2 : usb-storage 1-1.2:1.0
[    2.907319] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
[    3.016381] usb 2-1.1: New USB device found, idVendor=05ac, idProduct=8502
[    3.016469] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.016547] usb 2-1.1: Product: Built-in iSight
[    3.016622] usb 2-1.1: Manufacturer: Apple Inc.
[    3.016696] usb 2-1.1: SerialNumber: 8TA5G22VRDDQ2L00
[    3.017864] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8502)
[    3.023406] input: Built-in iSight as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.1/2-1.1:1.0/input/input8
[    3.111472] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
[    3.225172] usb 2-1.2: New USB device found, idVendor=05ac, idProduct=8242
[    3.225262] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.225341] usb 2-1.2: Product: IR Receiver
[    3.225415] usb 2-1.2: Manufacturer: Apple Computer, Inc.
[    3.232049] input: Apple Computer, Inc. IR Receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.2/2-1.2:1.0/0003:05AC:8242.0001/input/input9
[    3.232659] appleir 0003:05AC:8242.0001: input,hiddev0,hidraw0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.7-1.2/input0
[    3.319625] usb 2-1.3: new full-speed USB device number 5 using ehci-pci
[    3.413525] usb 2-1.3: New USB device found, idVendor=067b, idProduct=2305
[    3.413616] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.413693] usb 2-1.3: Product: IEEE-1284 Controller
[    3.413768] usb 2-1.3: Manufacturer: Prolific Technology Inc.
[    3.420070] usblp 2-1.3:1.0: usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 vid 0x067B pid 0x2305
[    3.491725] usb 1-1.1.1: new full-speed USB device number 5 using ehci-pci
[    3.589534] usb 1-1.1.1: New USB device found, idVendor=05ac, idProduct=8215
[    3.589625] usb 1-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.589703] usb 1-1.1.1: Product: Bluetooth USB Host Controller
[    3.589779] usb 1-1.1.1: Manufacturer: Apple Inc.
[    3.589853] usb 1-1.1.1: SerialNumber: 7C6D629FDB2D
[    3.821736] scsi 2:0:0:0: Direct-Access     APPLE    SD Card Reader   1.00 PQ: 0 ANSI: 0
[    3.822374] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    3.823955] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    3.834315] random: nonblocking pool is initialized
[    5.563403] systemd-udevd[1394]: starting version 208
[    6.239086] [drm] Initialized drm 1.1.0 20060810
[    7.264508] [drm] radeon kernel modesetting enabled.
[    7.264784] [drm] initializing kernel modesetting (RV730 0x1002:0x9488 0x106B:0x00B6).
[    7.264804] [drm] register mmio base: 0xD0420000
[    7.264804] [drm] register mmio size: 65536
[    7.264836] radeon 0000:01:00.0: Invalid ROM contents
[    7.264852] ATOM BIOS: 113
[    7.264917] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
[    7.264918] radeon 0000:01:00.0: GTT: 1024M 0x0000000010000000 - 0x000000004FFFFFFF
[    7.264919] [drm] Detected VRAM RAM=256M, BAR=256M
[    7.264919] [drm] RAM width 128bits DDR
[    7.264967] [TTM] Zone  kernel: Available graphics memory: 1983614 kiB
[    7.264969] [TTM] Initializing pool allocator
[    7.264972] [TTM] Initializing DMA pool allocator
[    7.264988] [drm] radeon: 256M of VRAM memory ready
[    7.264989] [drm] radeon: 1024M of GTT memory ready.
[    7.264998] [drm] Loading RV730 Microcode
[    7.430532] [drm] Special thermal controller config
[    7.430578] [drm:radeon_pm_init_dpm] *ERROR* radeon: dpm initialization failed
[    7.465059] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    7.466093] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    7.472939] [drm] PCIE GART of 1024M enabled (table at 0x000000000025D000).
[    7.472992] radeon 0000:01:00.0: WB enabled
[    7.472994] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000010000c00 and cpu addr 0xffff8801361f4c00
[    7.472996] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000010000c0c and cpu addr 0xffff8801361f4c0c
[    7.473613] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x000000000005c598 and cpu addr 0xffffc90000d1c598
[    7.473614] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    7.473615] [drm] Driver supports precise vblank timestamp query.
[    7.473635] radeon 0000:01:00.0: irq 43 for MSI/MSI-X
[    7.473646] radeon 0000:01:00.0: radeon: using MSI.
[    7.473671] [drm] radeon: irq initialized.
[    7.520050] [drm] ring test on 0 succeeded in 1 usecs
[    7.520108] [drm] ring test on 3 succeeded in 1 usecs
[    7.694911] [drm] ring test on 5 succeeded in 1 usecs
[    7.694915] [drm] UVD initialized successfully.
[    7.695158] [drm] ib test on ring 0 succeeded in 0 usecs
[    7.695179] [drm] ib test on ring 3 succeeded in 0 usecs
[   17.850240] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000msec
[   17.850245] radeon 0000:01:00.0: GPU lockup (waiting for 0x0000000000000002 last fence id 0x0000000000000000 on ring 5)
[   17.850248] [drm:uvd_v1_0_ib_test] *ERROR* radeon: fence wait failed (-35).
[   17.850252] [drm:radeon_ib_ring_tests] *ERROR* radeon: failed testing IB on ring 5 (-35).
[   17.851869] [drm] radeon atom DIG backlight initialized
[   17.851871] [drm] Radeon Display Connectors
[   17.851871] [drm] Connector 0:
[   17.851872] [drm]   DP-1
[   17.851872] [drm]   HPD1
[   17.851873] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[   17.851874] [drm]   Encoders:
[   17.851874] [drm]     DFP1: INTERNAL_UNIPHY
[   17.851875] [drm] Connector 1:
[   17.851875] [drm]   eDP-1
[   17.851876] [drm]   HPD2
[   17.851876] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[   17.851877] [drm]   Encoders:
[   17.851877] [drm]     LCD1: INTERNAL_UNIPHY
[   17.851877] [drm] Connector 2:
[   17.851878] [drm]   VGA-1
[   17.851879] [drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[   17.851879] [drm]   Encoders:
[   17.851880] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   17.937431] [drm] fb mappable at 0xC0460000
[   17.937432] [drm] vram apper at 0xC0000000
[   17.937433] [drm] size 8294400
[   17.937433] [drm] fb depth is 24
[   17.937434] [drm]    pitch is 7680
[   17.937639] fbcon: radeondrmfb (fb0) is primary device
[   17.958798] Console: switching to colour frame buffer device 240x67
[   17.963139] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[   17.963140] radeon 0000:01:00.0: registered panic notifier
[   17.963149] [drm] Initialized radeon 2.37.0 20080528 for 0000:01:00.0 on minor 0
[   18.897834] EXT4-fs (sda3): re-mounted. Opts: (null)
[   19.082817] Adding 7812092k swap on /dev/sda4.  Priority:-1 extents:1 across:7812092k 
[   21.169262] tg3 0000:02:00.0: irq 44 for MSI/MSI-X
[   21.953410] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.322684] tg3 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex
[   24.322687] tg3 0000:02:00.0 eth0: Flow control is off for TX and off for RX
[   24.322700] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.134546] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   32.251055] cfg80211: Pending regulatory request, waiting for it to be processed...
[   32.345116] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   32.346736] wlan0: Trigger new scan to find an IBSS to join
[   32.392023] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev- instead.
[   32.456926] cfg80211: Pending regulatory request, waiting for it to be processed...
[   35.041609] wlan0: Trigger new scan to find an IBSS to join
[   37.139959] wlan0: Trigger new scan to find an IBSS to join
[   39.215427] wlan0: Trigger new scan to find an IBSS to join
[   39.394793] wlan0: Creating new IBSS network, BSSID ce:67:8d:ee:04:89
[   39.401825] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   40.597018] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   40.597040] cfg80211: Pending regulatory request, waiting for it to be processed...
[   41.751202] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   47.704108] radeon 0000:01:00.0: GPU reset succeeded, trying to resume
[   47.814844] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[   47.816942] [drm] PCIE GART of 1024M enabled (table at 0x000000000025D000).
[   47.816977] radeon 0000:01:00.0: WB enabled
[   47.816979] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000010000c00 and cpu addr 0xffff8801361f4c00
[   47.816981] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000010000c0c and cpu addr 0xffff8801361f4c0c
[   47.817597] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x000000000005c598 and cpu addr 0xffffc90000d1c598
[   47.863708] [drm] ring test on 0 succeeded in 1 usecs
[   47.863766] [drm] ring test on 3 succeeded in 1 usecs
[   48.038555] [drm] ring test on 5 succeeded in 1 usecs
[   48.038559] [drm] UVD initialized successfully.
[   48.038585] [drm] ib test on ring 0 succeeded in 0 usecs
[   48.038607] [drm] ib test on ring 3 succeeded in 1 usecs
[   58.192367] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000msec
[   58.192371] radeon 0000:01:00.0: GPU lockup (waiting for 0x0000000000000004 last fence id 0x0000000000000000 on ring 5)
[   58.192373] [drm:uvd_v1_0_ib_test] *ERROR* radeon: fence wait failed (-35).
[   58.192377] [drm:radeon_ib_ring_tests] *ERROR* radeon: failed testing IB on ring 5 (-35).
[   58.192405] [drm:radeon_pm_resume_dpm] *ERROR* radeon: dpm resume failed
[   64.512303] apple 0005:05AC:023A.0002: unknown main item tag 0x0
[   66.574610] input: gandalf kbd as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/bluetooth/hci0/hci0:11/0005:05AC:023A.0002/input/input10
[   66.574812] apple 0005:05AC:023A.0002: input,hidraw1: BLUETOOTH HID v0.50 Keyboard [gandalf kbd] on 7c:6d:62:9f:db:2d
[   67.093799] magicmouse 0005:05AC:030D.0003: unknown main item tag 0x0
[   67.176028] input: gandalf mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/bluetooth/hci0/hci0:12/0005:05AC:030D.0003/input/input11
[   67.176191] magicmouse 0005:05AC:030D.0003: input,hidraw2: BLUETOOTH HID v0.84 Mouse [gandalf mouse] on 7c:6d:62:9f:db:2d

--------------020705070805090103030803--
