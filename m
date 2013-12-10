Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3LJCzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3LJCzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:55:15 -0500
Date: Tue, 10 Dec 2013 10:55:10 +0800
From: Dave Young <dyoung@redhat.com>
To: airlied@linux.ie, bskeggs@redhat.com, martin.peres@labri.fr,
        maarten.lankhorst@canonical.com, marcin.slusarz@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [BUG] nouveau: softlockup in kexec kernel
Message-ID: <20131210025510.GA6422@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

nouveau does not works in kexec kernel on HP z420 workstation,
Softlockup happens when the module init, see below full dmesg.

BTW, the machine is using efi boot, I passed acpi_rsdp= in kernel
cmdline. Also tried my efi runtime patches, result is same.

But nouveau driver is happy with nouveau.config=NvMSI=0.

Ideas?

[root@dhcp-16-198 ~]# kexec -e
[   82.954344] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   83.012462] Starting new kernel
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.13.0-rc2+ (dyoung@dhcp-16-198.nay.redhat.com) (gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC) ) #43
[    0.000000] Command line: selinux=0 root=UUID=29296957-5ac6-40c2-a20d-b43d38a1d29d ro crashkernel=128M intel_iommu=off kvm_intel.n 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db41dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db41e000-0x00000000db71afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000db71b000-0x00000000db82ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000db830000-0x00000000db9e0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db9e1000-0x00000000dbaf4fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dbaf5000-0x00000000dbaf5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dbaf6000-0x00000000dbb7bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dbb7c000-0x00000000dbffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820: last_pfn = 0x420000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdc000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4bc0-0x000f4bcf] mapped at [ffff8800000f4bc0]
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x41f600000-0x41f7fffff]
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41f5fffff]
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdb41dfff]
[    0.000000] init_memory_mapping: [mem 0xdbaf5000-0xdbaf5fff]
[    0.000000] init_memory_mapping: [mem 0xdbb7c000-0xdbffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000] init_memory_mapping: [mem 0x41f800000-0x41fffffff]
[    0.000000] RAMDISK: [mem 0x41f842000-0x41ffeefff]
[    0.000000] ACPI: RSDP 00000000db752000 000024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 00000000db752088 00008C (v01 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000db759590 00010C (v05 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000db7521a0 0073EB (v02 HPQOEM SLIC-WKS 00000315 INTL 20051117)
[    0.000000] ACPI: FACS 00000000db9d8080 000040
[    0.000000] ACPI: APIC 00000000db7596a0 000090 (v03 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 00000000db759730 000044 (v01 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: ASF! 00000000db759778 0000A5 (v32 INTEL       HCG 00000001 TFSM 000F4240)
[    0.000000] ACPI: MCFG 00000000db759820 00003C (v01 HPQOEM OEMMCFG. 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000db759860 000038 (v01 HPQOEM SLIC-WKS 01072009 AMI. 00000005)
[    0.000000] ACPI: ASF! 00000000db759898 0000A0 (v32 INTEL       HCG 00000001 TFSM 000F4240)
[    0.000000] ACPI: SSDT 00000000db759938 005913 (v01 COMPAQ      WMI 00000001 MSFT 03000001)
[    0.000000] ACPI: SLIC 00000000db75f250 000176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000db75f3c8 002A71 (v02 HPQOEM   CpuDef 00004000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000db761e40 0CD380 (v02  INTEL    CpuPm 00004000 INTL 20051117)
[    0.000000] ACPI: IFEU 00000000db82f1c0 000042 (v01 HPQOEM SLIC-WKS 01072009      00000000)
[    0.000000] ACPI: DMAR 00000000db82f208 0000A8 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[    0.000000] Reserving 128MB of memory at 768MB for crashkernel (System RAM: 16312MB)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xdb41dfff]
[    0.000000]   node   0: [mem 0xdbaf5000-0xdbaf5fff]
[    0.000000]   node   0: [mem 0xdbb7c000-0xdbffffff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb41e000-0xdb71afff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb71b000-0xdb82ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb830000-0xdb9e0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb9e1000-0xdbaf4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdbaf6000-0xdbb7bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdc000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88041f400000 s83200 r8192 d23296 u524288
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4110656
[    0.000000] Kernel command line: selinux=0 root=UUID=29296957-5ac6-40c2-a20d-b43d38a1d29d ro crashkernel=128M intel_iommu=off kvm_ 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 16192868K/16703752K available (4710K kernel code, 776K rwdata, 2352K rodata, 884K init, 8984K bss, 510884K res)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=4.
[    0.000000]  Offload RCU callbacks from all CPUs
[    0.000000]  Offload RCU callbacks from CPUs: 0-3.
[    0.000000] NO_HZ: Full dynticks CPUs: 1-15.
[    0.000000] NR_IRQS:4352 nr_irqs:1024 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.204 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5588.17 BogoMIPS (lpj=9310680)
[    0.010633] pid_max: default: 32768 minimum: 301
[    0.015339] Mount-cache hash table entries: 256
[    0.020550] CPU: Physical Processor ID: 0
[    0.024562] CPU: Processor Core ID: 0
[    0.028236] mce: CPU supports 16 MCE banks
[    0.032369] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.032369] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.032369] tlb_flushall_shift: 5
[    0.046980] Freeing SMP alternatives memory: 20K (ffffffff81889000 - ffffffff8188e000)
[    0.055942] ACPI: Core revision 20131115
[    0.112924] ACPI: All ACPI Tables successfully acquired
[    0.118979] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.158128] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-1603 0 @ 2.80GHz (fam: 06, model: 2d, stepping: 07)
[    0.167532] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.178121] ... version:                3
[    0.182141] ... bit width:              48
[    0.186245] ... generic registers:      8
[    0.190263] ... value mask:             0000ffffffffffff
[    0.195583] ... max period:             0000ffffffffffff
[    0.200903] ... fixed-purpose events:   3
[    0.204918] ... event mask:             00000007000000ff
[    0.233844] x86: Booting SMP configuration:
[    0.238043] .... node  #0, CPUs:      #1[    0.256802] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
 #2 #3
[    0.302054] x86: Booted up 1 node, 4 CPUs
[    0.306276] smpboot: Total of 4 processors activated (22354.70 BogoMIPS)
[    0.317790] devtmpfs: initialized
[    0.326418] PM: Registering ACPI NVS region [mem 0xdb830000-0xdb9e0fff] (1773568 bytes)
[    0.334521] PM: Registering ACPI NVS region [mem 0xdbaf6000-0xdbb7bfff] (548864 bytes)
[    0.342811] kworker/u8:0 (42) used greatest stack depth: 5952 bytes left
[    0.343186] NET: Registered protocol family 16
[    0.353975] kworker/u8:0 (44) used greatest stack depth: 5816 bytes left
[    0.354801] cpuidle: using governor ladder
[    0.354803] cpuidle: using governor menu
[    0.354912] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.354923] ACPI: bus type PCI registered
[    0.354968] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.354969] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.364156] PCI: Using configuration type 1 for base access
[    0.401968] kworker/u8:0 (43) used greatest stack depth: 5232 bytes left
[    0.413770] bio: create slab <bio-0> at 0
[    0.418128] ACPI: Added _OSI(Module Device)
[    0.422328] ACPI: Added _OSI(Processor Device)
[    0.426782] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.431510] ACPI: Added _OSI(Processor Aggregator Device)
[    0.509356] ACPI: Executed 1 blocks of module-level executable AML code
[    0.796669] ACPI: Interpreter enabled
[    0.800354] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.809628] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.818946] ACPI: (supports S0 S3 S4 S5)
[    0.822877] ACPI: Using IOAPIC for interrupt routing
[    0.828008] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.837556] ACPI: No dock devices found.
[    0.865101] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.871310] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.879857] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.887183] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.896424] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.904178] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.911772] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.919381] PCI host bridge to bus 0000:00
[    0.923508] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.929005] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.935207] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.941410] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.947597] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.953797] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.960689] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.967577] pci_bus 0000:00: root bus resource [mem 0xe4000000-0xefffffff]
[    0.974473] pci_bus 0000:00: root bus resource [mem 0x3c0000000000-0x3c007fffffff]
[    0.982731] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.988781] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.994799] pci 0000:00:03.0: System wakeup disabled by ACPI
[    1.005400] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.011462] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.017787] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.023855] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    1.029858] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    1.035875] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    1.041919] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.047877] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    1.054768] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.066460] pci 0000:00:02.0: PCI bridge to [bus 05]
[    1.071600] pci 0000:00:03.0: PCI bridge to [bus 04]
[    1.077032] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.082176] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.087339] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    1.092476] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    1.104168] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.109574] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
[    1.118158] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 40-ff])
[    1.124364] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.132885] acpi PNP0A08:01: _OSC: platform does not support [PCIeCapability]
[    1.140214] acpi PNP0A08:01: _OSC: not requesting control; platform does not support [PCIeCapability]
[    1.149473] acpi PNP0A08:01: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    1.157244] acpi PNP0A08:01: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    1.164837] acpi PNP0A08:01: _OSC failed (AE_SUPPORT); disabling ASPM
[    1.171674] acpi PNP0A08:01: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-7f] only partially covers this bridge
[    1.182320] PCI host bridge to bus 0000:40
[    1.186435] pci_bus 0000:40: root bus resource [bus 40-ff]
[    1.191949] pci_bus 0000:40: root bus resource [io  0x0000-0x03af]
[    1.198161] pci_bus 0000:40: root bus resource [io  0x03e0-0x0cf7]
[    1.204366] pci_bus 0000:40: root bus resource [mem 0x000c0000-0x000dffff]
[    1.211520] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.219892] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15), disabled.
[    1.228232] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.236389] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
[    1.244544] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15), disabled.
[    1.252885] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.261413] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.269751] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.281416] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.287116] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.295219] vgaarb: loaded
[    1.297935] vgaarb: bridge control possible 0000:05:00.0
[    1.303513] SCSI subsystem initialized
[    1.307677] ACPI: bus type USB registered
[    1.311839] usbcore: registered new interface driver usbfs
[    1.317396] usbcore: registered new interface driver hub
[    1.322816] usbcore: registered new device driver usb
[    1.328547] Advanced Linux Sound Architecture Driver Initialized.
[    1.334653] PCI: Using ACPI for IRQ routing
[    1.342374] PCI: Discovered peer bus 7f
[    1.346333] PCI host bridge to bus 0000:7f
[    1.350444] pci_bus 0000:7f: root bus resource [io  0x0000-0xffff]
[    1.356639] pci_bus 0000:7f: root bus resource [mem 0x00000000-0x3fffffffffff]
[    1.363871] pci_bus 0000:7f: No busn resource found for root bus, will use [bus 7f-ff]
[    1.378246] Switched to clocksource hpet
[    1.382422] FS-Cache: Loaded
[    1.385447] CacheFiles: Loaded
[    1.388632] pnp: PnP ACPI init
[    1.391728] ACPI: bus type PNP registered
[    1.396022] system 00:00: [mem 0xfc000000-0xfcffffff window] has been reserved
[    1.403274] system 00:00: [mem 0xfd000000-0xfdffffff window] has been reserved
[    1.410518] system 00:00: [mem 0xfe000000-0xfeafffff window] has been reserved
[    1.417768] system 00:00: [mem 0xfeb00000-0xfebfffff window] has been reserved
[    1.425013] system 00:00: [mem 0xfed00400-0xfed3ffff window] could not be reserved
[    1.432607] system 00:00: [mem 0xfed45000-0xfedfffff window] has been reserved
[    1.439840] system 00:00: [mem 0xe7346000-0xe7346fff window] has been reserved
[    1.447340] system 00:01: [mem 0xe7344000-0xe7345fff] has been reserved
[    1.454276] system 00:02: [io  0x0620-0x063f] has been reserved
[    1.460217] system 00:02: [io  0x0610-0x061f] has been reserved
[    1.466924] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.473797] system 00:0b: [io  0x0400-0x0453] could not be reserved
[    1.480091] system 00:0b: [io  0x0458-0x047f] has been reserved
[    1.486037] system 00:0b: [io  0x1180-0x119f] has been reserved
[    1.491976] system 00:0b: [io  0x0500-0x057f] has been reserved
[    1.497947] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.504599] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.511568] system 00:0b: [mem 0xfed08000-0xfed08fff] has been reserved
[    1.518195] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    1.525115] system 00:0c: [io  0x0454-0x0457] has been reserved
[    1.532091] system 00:0e: [mem 0xfed40000-0xfed44fff] has been reserved
[    1.538729] pnp: PnP ACPI: found 15 devices
[    1.542915] ACPI: bus type PNP unregistered
[    1.561190] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.566175] pci 0000:00:02.0: PCI bridge to [bus 05]
[    1.571144] pci 0000:00:02.0:   bridge window [io  0xc000-0xcfff]
[    1.577255] pci 0000:00:02.0:   bridge window [mem 0xe6000000-0xe70fffff]
[    1.584056] pci 0000:00:02.0:   bridge window [mem 0xe8000000-0xedffffff 64bit pref]
[    1.591815] pci 0000:00:03.0: PCI bridge to [bus 04]
[    1.596800] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.601778] pci 0000:00:11.0:   bridge window [io  0xd000-0xdfff]
[    1.607891] pci 0000:00:11.0:   bridge window [mem 0xee400000-0xee8fffff 64bit pref]
[    1.615648] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.620639] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    1.625631] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    1.630610] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.635586] pci 0000:00:1c.7:   bridge window [mem 0xe7200000-0xe72fffff]
[    1.642394] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    1.647369] pci 0000:00:1e.0:   bridge window [mem 0xe7100000-0xe71fffff]
[    1.654282] NET: Registered protocol family 2
[    1.659034] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.666634] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.677923] TCP: Hash tables configured (established 131072 bind 65536)
[    1.684586] TCP: reno registered
[    1.687890] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.695265] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.703229] NET: Registered protocol family 1
[    1.709325] Trying to unpack rootfs image as initramfs...
[    1.844122] Freeing initrd memory: 7860K (ffff88041f842000 - ffff88041ffef000)
[    1.851372] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.857829] software IO TLB [mem 0xd741e000-0xdb41e000] (64MB) mapped at [ffff8800d741e000-ffff8800db41dfff]
[    1.868490] Machine check injector initialized
[    1.874521] microcode: CPU0 sig=0x206d7, pf=0x1, revision=0x70e
[    1.880455] microcode: CPU1 sig=0x206d7, pf=0x1, revision=0x70e
[    1.886385] microcode: CPU2 sig=0x206d7, pf=0x1, revision=0x70e
[    1.892316] microcode: CPU3 sig=0x206d7, pf=0x1, revision=0x70e
[    1.898415] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.908618] audit: initializing netlink socket (disabled)
[    1.914072] type=2000 audit(1386643478.509:1): initialized
[    1.922079] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.936377] VFS: Disk quotas dquot_6.5.2
[    1.940455] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.949426] msgmni has been set to 31642
[    1.954410] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.961838] io scheduler noop registered
[    1.965769] io scheduler deadline registered
[    1.970264] io scheduler cfq registered (default)
[    1.978245] ioapic: probe of 0000:00:05.4 failed with error -22
[    1.985191] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.993427] ACPI: Power Button [PWRB]
[    1.997231] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.004645] ACPI: Power Button [PWRF]
[    2.050301] GHES: HEST is not enabled!
[    2.054862] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.082431] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.117927] 0000:00:16.3: ttyS1 at I/O 0xe060 (irq = 17, base_baud = 115200) is a 16550A
[    2.127525] Non-volatile memory driver v1.3
[    2.132887] Linux agpgart interface v0.103
[    2.137396] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.146403] Hangcheck: Using getrawmonotonic().
[    2.160881] brd: module loaded
[    2.179229] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x5 impl RAID mode
[    2.187376] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    2.208848] scsi0 : ahci
[    2.212296] scsi1 : ahci
[    2.215398] scsi2 : ahci
[    2.218551] scsi3 : ahci
[    2.221698] scsi4 : ahci
[    2.224844] scsi5 : ahci
[    2.228020] ata1: SATA max UDMA/133 abar m2048@0xe734b000 port 0xe734b100 irq 64
[    2.235460] ata2: DUMMY
[    2.237919] ata3: SATA max UDMA/133 abar m2048@0xe734b000 port 0xe734b200 irq 64
[    2.245322] ata4: DUMMY
[    2.247790] ata5: DUMMY
[    2.250244] ata6: DUMMY
[    2.258412] scsi6 : ata_generic
[    2.262220] scsi7 : ata_generic
[    2.265856] ata7: PATA max UDMA/100 cmd 0xe0b0 ctl 0xe0a0 bmdma 0xe070 irq 18
[    2.273031] ata8: PATA max UDMA/100 cmd 0xe090 ctl 0xe080 bmdma 0xe078 irq 18
[    2.283162] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.289748] ehci-pci: EHCI PCI platform driver
[    2.295221] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.300694] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.308282] ehci-pci 0000:00:1a.0: debug port 2
[    2.316976] ehci-pci 0000:00:1a.0: irq 16, io mem 0xe734e000
[    2.332736] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.339293] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.346199] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.353468] usb usb1: Product: EHCI Host Controller
[    2.358378] usb usb1: Manufacturer: Linux 3.13.0-rc2+ ehci_hcd
[    2.364249] usb usb1: SerialNumber: 0000:00:1a.0
[    2.392843] random: nonblocking pool is initialized
[    2.572943] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.579263] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.585493] ata3.00: ATAPI: hp       CDDVDW SH-216BB, HE40, max UDMA/100
[    2.592370] ata1.00: ATA-8: ST31000524AS, HP64, max UDMA/100
[    2.598055] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.606103] ata1.00: configured for UDMA/100
[    2.610450] ata3.00: configured for UDMA/100
[    2.615341] scsi 0:0:0:0: Direct-Access     ATA      ST31000524AS     HP64 PQ: 0 ANSI: 5
[    2.870008] tsc: Refined TSC clocksource calibration: 2793.268 MHz
[    3.247017] irq 16: nobody cared (try booting with the "irqpoll" option)
[    3.253743] CPU: 2 PID: 880 Comm: kworker/u8:8 Not tainted 3.13.0-rc2+ #48
[    3.260652] Workqueue: khelper __call_usermodehelper
[    3.265661]  0000000000000000 ffff88041f503e28 ffffffff8148dbe6 ffff88041deda000
[    3.273182]  ffff88041f503e50 ffffffff810a1aea ffff88041deda000 0000000000000000
[    3.280696]  0000000000000010 ffff88041f503e88 ffffffff810a1eb7 ffff88041deda000
[    3.288215] Call Trace:
[    3.290680]  <IRQ>  [<ffffffff8148dbe6>] dump_stack+0x4e/0x7a
[    3.296486]  [<ffffffff810a1aea>] __report_bad_irq+0x2a/0xbc
[    3.302179]  [<ffffffff810a1eb7>] note_interrupt+0x13a/0x1bf
[    3.307866]  [<ffffffff810a01b7>] handle_irq_event_percpu+0x10b/0x11a
[    3.314337]  [<ffffffff810a01ff>] handle_irq_event+0x39/0x56
[    3.320030]  [<ffffffff810a27cf>] handle_fasteoi_irq+0x7a/0xae
[    3.325895]  [<ffffffff81029aed>] handle_irq+0x15d/0x174
[    3.331235]  [<ffffffff81085b12>] ? vtime_account_system+0x70/0x79
[    3.337444]  [<ffffffff81085d08>] ? vtime_common_account_irq_enter+0x3b/0x3d
[    3.344526]  [<ffffffff8102961d>] do_IRQ+0x48/0xae
[    3.349349]  [<ffffffff81495532>] common_interrupt+0x72/0x72
[    3.355031]  <EOI>  [<ffffffff814955f7>] ? retint_restore_args+0x13/0x13
[    3.361797]  [<ffffffff81093563>] ? lock_acquire+0xb4/0xc4
[    3.367309]  [<ffffffff8123bcf9>] ? lockref_get+0xd/0x1b
[    3.372653]  [<ffffffff81494823>] _raw_spin_lock+0x33/0x3f
[    3.378164]  [<ffffffff8123bcf9>] ? lockref_get+0xd/0x1b
[    3.383505]  [<ffffffff8123bcf9>] lockref_get+0xd/0x1b
[    3.388677]  [<ffffffff81122f83>] path_get+0x22/0x25
[    3.393670]  [<ffffffff81140e40>] copy_fs_struct+0x9d/0xd9
[    3.399188]  [<ffffffff8105e194>] copy_process.part.39+0x75d/0x1263
[    3.405477]  [<ffffffff810716cd>] ? ____call_usermodehelper+0x118/0x118
[    3.412102]  [<ffffffff8105ee29>] do_fork+0xc7/0x277
[    3.417079]  [<ffffffff81093563>] ? lock_acquire+0xb4/0xc4
[    3.422577]  [<ffffffff8105effa>] kernel_thread+0x21/0x23
[    3.427979]  [<ffffffff8107174e>] __call_usermodehelper+0x46/0x7b
[    3.434081]  [<ffffffff81074469>] process_one_work+0x22d/0x397
[    3.439924]  [<ffffffff81074404>] ? process_one_work+0x1c8/0x397
[    3.445943]  [<ffffffff81075175>] worker_thread+0x1d3/0x2bd
[    3.451530]  [<ffffffff81074fa2>] ? rescuer_thread+0x26b/0x26b
[    3.457376]  [<ffffffff81079fd3>] kthread+0x100/0x108
[    3.462434]  [<ffffffff81079ed3>] ? kthread_create_on_node+0x1bf/0x1bf
[    3.468977]  [<ffffffff81495d8c>] ret_from_fork+0x7c/0xb0
[    3.474389]  [<ffffffff81079ed3>] ? kthread_create_on_node+0x1bf/0x1bf
[    3.480929] handlers:
[    3.483215] [<ffffffff8132faf8>] usb_hcd_irq
[    3.487517] Disabling IRQ #16
[    3.491552] hub 1-0:1.0: USB hub found
[    3.495451] hub 1-0:1.0: 3 ports detected
[    3.495842] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.496360] sd 0:0:0:0: [sda] Write Protect is off
[    3.496435] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.497160] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.501116] scsi 2:0:0:0: CD-ROM            hp       CDDVDW SH-216BB  HE40 PQ: 0 ANSI: 5
[    3.504894] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.504897] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.507007] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    3.553440] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.553467]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
[    3.556986] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.568307] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.575752] ehci-pci 0000:00:1d.0: debug port 2
[    3.584305] ehci-pci 0000:00:1d.0: irq 23, io mem 0xe734d000
[    3.597419] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.603541] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.610374] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.617615] usb usb2: Product: EHCI Host Controller
[    3.622512] usb usb2: Manufacturer: Linux 3.13.0-rc2+ ehci_hcd
[    3.628367] usb usb2: SerialNumber: 0000:00:1d.0
[    3.634012] hub 2-0:1.0: USB hub found
[    3.637878] hub 2-0:1.0: 3 ports detected
[    3.642957] uhci_hcd: USB Universal Host Controller Interface driver
[    3.649899] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    3.655853] xhci_hcd 0000:08:00.0: new USB bus registered, assigned bus number 3
[    3.663832] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.670634] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.677867] usb usb3: Product: xHCI Host Controller
[    3.682767] usb usb3: Manufacturer: Linux 3.13.0-rc2+ xhci_hcd
[    3.688624] usb usb3: SerialNumber: 0000:08:00.0
[    3.694399] hub 3-0:1.0: USB hub found
[    3.698324] hub 3-0:1.0: 4 ports detected
[    3.703152] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    3.708468] xhci_hcd 0000:08:00.0: new USB bus registered, assigned bus number 4
[    3.716295] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    3.723136] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.730397] usb usb4: Product: xHCI Host Controller
[    3.735310] usb usb4: Manufacturer: Linux 3.13.0-rc2+ xhci_hcd
[    3.741410] usb usb4: SerialNumber: 0000:08:00.0
[    3.747411] hub 4-0:1.0: USB hub found
[    3.751372] hub 4-0:1.0: 4 ports detected
[    3.768509] usbcore: registered new interface driver usb-storage
[    3.775239] usbcore: registered new interface driver usbserial
[    3.781376] usbcore: registered new interface driver usbserial_generic
[    3.788405] usbserial: USB Serial support registered for generic
[    3.795221] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.806668] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.812267] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.818106] mousedev: PS/2 mouse device common for all mice
[    3.825703] rtc_cmos 00:06: RTC can wake from S4
[    3.831285] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.837509] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.846610] ACPI Warning: 0x000000000000e000-0x000000000000e01f SystemIO conflicts with Region \_SB_.PCI0.SMB_.SMIO 1 (20131115/ut)
[    3.859747] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.864425] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    3.876491] Switched to clocksource tsc
[    3.878029] device-mapper: uevent: version 1.0.3
[    3.884671] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.885253] sdhci: Secure Digital Host Controller Interface driver
[    3.885255] sdhci: Copyright(c) Pierre Ossman
[    3.885762] hidraw: raw HID events driver (C) Jiri Kosina
[    3.886046] usbcore: registered new interface driver usbhid
[    3.886047] usbhid: USB HID core driver
[    3.886050] hdaps: supported laptop not found!
[    3.886063] hdaps: driver init failed (ret=-19)!
[    3.886287] Netfilter messages via NETLINK v0.30.
[    3.886299] nfnl_acct: registering with nfnetlink.
[    3.886448] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.887158] ipip: IPv4 over IPv4 tunneling driver
[    3.888359] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.888481] arp_tables: (C) 2002 David S. Miller
[    3.888484] TCP: cubic registered
[    3.888490] NET: Registered protocol family 17
[    3.888588] Bridge firewalling registered
[    3.888784] Key type dns_resolver registered
[    3.891385] registered taskstats version 1
[    3.978391] console [netcon0] enabled
[    3.982097] netconsole: network logging started
[    3.990570] ALSA device list:
[    3.993545]   No soundcards found.
[    3.998061] Freeing unused kernel memory: 884K (ffffffff817ac000 - ffffffff81889000)
[    4.018265] systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +)
[    4.030842] systemd[1]: Running in initial RAM disk.

Welcome to Fedora 19 (Schr�ödinger��’s Cat) dracut-029-2.fc19 (Initramfs)!

[    4.049810] systemd[1]: Failed to insert module 'ipv6'
[    4.055294] systemd[1]: Set hostname to <dhcp-16-198.nay.redhat.com>.
[    4.076219] systemd[1]: Expecting device dev-disk-by\x2duuid-23de383d\x2dd380\x2d440f\x2d8488\x2d68ac1b555894.device...
         Expecting device dev-disk-by\x2duuid-23de383d\x2dd38...55894.device...
[    4.098141] systemd[1]: Expecting device dev-disk-by\x2duuid-7113fe11\x2dc86a\x2d4911\x2d99fd\x2d1159eae49ea2.device...
         Expecting device dev-disk-by\x2duuid-7113fe11\x2dc86...49ea2.device...
[    4.121514] systemd[1]: Expecting device dev-disk-by\x2duuid-29296957\x2d5ac6\x2d40c2\x2da20d\x2db43d38a1d29d.device...
         Expecting device dev-disk-by\x2duuid-29296957\x2d5ac...1d29d.device...
[    4.144854] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[    4.158202] systemd[1]: Reached target Timers.
[    4.162727] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[    4.174877] systemd[1]: Listening on Journal Socket.
[    4.180437] systemd[1]: Started dracut cmdline hook.
[    4.186023] systemd[1]: Starting dracut pre-udev hook...
         Starting dracut pre-udev hook...
[    4.202502] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[    4.224869] systemd[1]: Started Journal Service.
[    4.230165] systemd[1]: Starting Setup Virtual Console...
         Starting Setup Virtual Console...
[    4.245693] systemd[1]: Started Load Kernel Modules.
[    4.250808] systemd[1]: Starting udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[    4.264832] systemd[1]: Listening on udev Kernel Socket.
[    4.270266] systemd[1]: Starting udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[    4.284898] systemd[1]: Listening on udev Control Socket.
[    4.290347] systemd[1]: Starting Sockets.
[  OK  ] Reached target Sockets.
[    4.301581] systemd[1]: Reached target Sockets.
[    4.306148] systemd[1]: Starting Swap.
[  OK  ] Reached target Swap.
[    4.318377] systemd[1]: Reached target Swap.
[    4.322717] systemd[1]: Starting Local File Systems.
[  OK  ] Reached target Local File Systems.
[    4.338409] systemd[1]: Reached target Local File Systems.
[  OK  ] Started dracut pre-udev hook.
[    4.355082] systemd[1]: Started dracut pre-udev hook.
[  OK  ] Started Setup Virtual Console.
[    4.371767] systemd[1]: Started Setup Virtual Console.
[    4.377297] systemd[1]: Starting udev Kernel Device Manager...
         Starting udev Kernel Device Manager...
[    4.398908] systemd-udevd[1008]: starting version 204
[  OK  ] Started udev Kernel Device Manager.
[    4.415188] systemd[1]: Started udev Kernel Device Manager.
[    4.421113] systemd[1]: Started dracut pre-trigger hook.
[    4.426560] systemd[1]: Starting udev Coldplug all Devices...
         Starting udev Coldplug all Devices...
[    4.478397] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    4.485239] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.577871] wmi: Mapper loaded
[    4.578913] hub 1-1:1.0: USB hub found
[    4.582128] [drm] Initialized drm 1.1.0 20060810
[    4.597365] nouveau  [  DEVICE][0000:05:00.0] BOOT0  : 0x0a8c00b1
[    4.602039] firewire_ohci 0000:09:05.0: added OHCI v1.0 device as card 0, 8 IR + 8 IT contexts, quirks 0x80
[    4.613435] nouveau  [  DEVICE][0000:05:00.0] Chipset: GT218 (NVA8)
[    4.615564] ata_id (1449) used greatest stack depth: 4432 bytes left
[    4.626481] nouveau  [  DEVICE][0000:05:00.0] Family : NV50
[    4.633638] nouveau  [   VBIOS][0000:05:00.0] checking PRAMIN for image...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[    4.678599] hub 1-1:1.0: 6 ports detected
[  OK  ] Reached target System Initialization.
         Starting Show Plymouth Boot Screen...
[    4.701728] nouveau  [   VBIOS][0000:05:00.0] ... appears to be valid
[    4.708185] nouveau  [   VBIOS][0000:05:00.0] using image from PRAMIN
[    4.714767] nouveau  [   VBIOS][0000:05:00.0] BIT signature found
[    4.720879] nouveau  [   VBIOS][0000:05:00.0] version 70.18.89.00.02
[    4.728836] nouveau  [     PMC][0000:05:00.0] MSI interrupts enabled
[    5.586235] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    5.716989] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    5.723726] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.732239] hub 2-1:1.0: USB hub found
[    5.736134] hub 2-1:1.0: 8 ports detected
[    6.006807] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
[    6.097158] usb 2-1.1: New USB device found, idVendor=0424, idProduct=2412
[    6.104071] usb 2-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.112594] hub 2-1.1:1.0: USB hub found
[    6.116647] hub 2-1.1:1.0: 2 ports detected
[    6.400616] usb 2-1.1.1: new low-speed USB device number 4 using ehci-pci
[    6.508232] usb 2-1.1.1: New USB device found, idVendor=17ef, idProduct=6016
[    6.515320] usb 2-1.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.523025] usb 2-1.1.1: Product: ThinkPad USB Laser Mouse
[    6.528531] usb 2-1.1.1: Manufacturer: Lenovo
[    6.537745] input: Lenovo ThinkPad USB Laser Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.1/2-1.1.1:1.0/input/in5
[    6.551801] hid-generic 0003:17EF:6016.0001: input,hidraw0: USB HID v1.11 Mouse [Lenovo ThinkPad USB Laser Mouse] on usb-0000:00:10
[    6.644260] usb 2-1.1.2: new low-speed USB device number 5 using ehci-pci
[    6.755757] usb 2-1.1.2: New USB device found, idVendor=03f0, idProduct=0324
[    6.762853] usb 2-1.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.770357] usb 2-1.1.2: Product: HP Basic USB Keyboard
[    6.775596] usb 2-1.1.2: Manufacturer: Lite-On Technology Corp.
[    6.786288] input: Lite-On Technology Corp. HP Basic USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.2/2-1.16
[    6.800404] hid-generic 0003:03F0:0324.0002: input,hidraw1: USB HID v1.10 Keyboard [Lite-On Technology Corp. HP Basic USB Keyboard0
[   32.592631] BUG: soft lockup - CPU#3 stuck for 23s! [systemd-udevd:1054]
[   32.599343] Modules linked in: firewire_ohci firewire_core crc_itu_t nouveau(+) cfbfillrect cfbimgblt mxm_wmi cfbcopyarea i2c_algoi
[   32.614100] irq event stamp: 15531025
[   32.617773] hardirqs last  enabled at (15531024): [<ffffffff814955f7>] restore_args+0x0/0x30
[   32.626242] hardirqs last disabled at (15531025): [<ffffffff81496c2d>] apic_timer_interrupt+0x6d/0x80
[   32.635493] softirqs last  enabled at (94532): [<ffffffff810635c4>] __do_softirq+0x1a0/0x22f
[   32.643960] softirqs last disabled at (95889): [<ffffffff81063973>] irq_exit+0x6a/0xee
[   32.651913] CPU: 3 PID: 1054 Comm: systemd-udevd Not tainted 3.13.0-rc2+ #48
[   32.658966] task: ffff88040977a000 ti: ffff88040919a000 task.ti: ffff88040919a000
[   32.666455] RIP: 0010:[<ffffffff810634c2>]  [<ffffffff810634c2>] __do_softirq+0x9e/0x22f
[   32.674575] RSP: 0018:ffff88041f583f30  EFLAGS: 00000202
[   32.679894] RAX: ffff88040977a000 RBX: ffffffff814955f7 RCX: 0000000000000002
[   32.687035] RDX: 0000000000000002 RSI: ffff88040977a6f8 RDI: ffff88040977a000
[   32.694173] RBP: ffff88041f583f78 R08: 0000000000000004 R09: 000052029053604c
[   32.701314] R10: ffff88040977a000 R11: ffffffff81085d08 R12: ffff88041f583ea8
[   32.708456] R13: ffffffff81496c32 R14: ffff88041f583f78 R15: 0000000000000202
[   32.715601] FS:  00007ff31ffce880(0000) GS:ffff88041f580000(0000) knlGS:0000000000000000
[   32.723694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.729445] CR2: 00007ff31ffd6000 CR3: 0000000409096000 CR4: 00000000000407e0
[   32.736589] Stack:
[   32.738605]  ffff88041f583f48 ffffffff81494a3d 0040214000000003 00000000fffea586
[   32.746069]  0000000000000000 ffffffff81742ae8 ffff88040977a000 ffff88040919b7b0
[   32.753528]  0000000000000000 ffff88041f583f90 ffffffff81063973 0000000000000000
[   32.760992] Call Trace:
[   32.763450]  <IRQ> 
[   32.765380]  [<ffffffff81494a3d>] ? _raw_spin_unlock+0x2c/0x40
[   32.771431]  [<ffffffff81063973>] irq_exit+0x6a/0xee
[   32.776403]  [<ffffffff8104a097>] smp_apic_timer_interrupt+0x3f/0x4b
[   32.782761]  [<ffffffff81496c32>] apic_timer_interrupt+0x72/0x80
[   32.788775]  <EOI> 
[   32.790707]  [<ffffffff814955f7>] ? retint_restore_args+0x13/0x13
[   32.797027]  [<ffffffff81093563>] ? lock_acquire+0xb4/0xc4
[   32.802522]  [<ffffffff8116f80a>] ? __proc_create+0x3c/0xfa
[   32.808100]  [<ffffffff81494823>] _raw_spin_lock+0x33/0x3f
[   32.813592]  [<ffffffff8116f80a>] ? __proc_create+0x3c/0xfa
[   32.819170]  [<ffffffff8116f80a>] __proc_create+0x3c/0xfa
[   32.824574]  [<ffffffff8116fb44>] proc_mkdir_data+0x32/0x61
[   32.830152]  [<ffffffff8116fb93>] proc_mkdir+0x10/0x12
[   32.835304]  [<ffffffff810a3f53>] register_irq_proc+0x7b/0x150
[   32.841139]  [<ffffffff810a1592>] __setup_irq+0x32d/0x3e4
[   32.846570]  [<ffffffffa00cd964>] ? nvc0_ltcg_init+0xb5/0xb5 [nouveau]
[   32.853105]  [<ffffffff810a179c>] request_threaded_irq+0xde/0x11c
[   32.859226]  [<ffffffffa00cdc9b>] nouveau_mc_create_+0x128/0x13d [nouveau]
[   32.866120]  [<ffffffffa00cdd0b>] nv04_mc_ctor+0x1a/0x27 [nouveau]
[   32.872323]  [<ffffffffa009d21b>] nouveau_object_ctor+0x2b/0xa5 [nouveau]
[   32.879133]  [<ffffffffa00d88c0>] nouveau_devobj_ctor+0x525/0x5a4 [nouveau]
[   32.886113]  [<ffffffffa009d21b>] nouveau_object_ctor+0x2b/0xa5 [nouveau]
[   32.892923]  [<ffffffffa009d960>] nouveau_object_new+0x141/0x1df [nouveau]
[   32.899824]  [<ffffffffa0108827>] nouveau_drm_load+0x205/0x80a [nouveau]
[   32.906545]  [<ffffffffa000eed5>] ? drm_get_minor+0x18d/0x1d2 [drm]
[   32.912822]  [<ffffffffa000f013>] drm_dev_register+0xf9/0x1b4 [drm]
[   32.919097]  [<ffffffffa0010b64>] drm_get_pci_dev+0x98/0x129 [drm]
[   32.925280]  [<ffffffff81254548>] ? __pci_set_master+0x90/0xb3
[   32.931138]  [<ffffffffa01081bd>] nouveau_drm_probe+0x1da/0x1ff [nouveau]
[   32.937928]  [<ffffffff81258536>] pci_device_probe+0x6e/0xcf
[   32.943596]  [<ffffffff812e290e>] driver_probe_device+0x115/0x2ed
[   32.949695]  [<ffffffff812e2b7a>] __driver_attach+0x5c/0x7e
[   32.955276]  [<ffffffff812e2b1e>] ? __device_attach+0x38/0x38
[   32.961032]  [<ffffffff812e0d81>] bus_for_each_dev+0x7b/0x85
[   32.966699]  [<ffffffff812e2371>] driver_attach+0x19/0x1b
[   32.972104]  [<ffffffff812e1fde>] bus_add_driver+0x128/0x1f2
[   32.977770]  [<ffffffff812e3117>] driver_register+0x89/0xc5
[   32.983354]  [<ffffffff81257c47>] __pci_register_driver+0x58/0x5b
[   32.989449]  [<ffffffffa0188000>] ? 0xffffffffa0187fff
[   32.994602]  [<ffffffffa0010c7b>] drm_pci_init+0x86/0xea [drm]
[   33.000436]  [<ffffffffa0188000>] ? 0xffffffffa0187fff
[   33.005595]  [<ffffffffa0188043>] nouveau_drm_init+0x43/0x45 [nouveau]
[   33.012125]  [<ffffffff810002bf>] do_one_initcall+0xae/0x15b
[   33.017793]  [<ffffffff8110629b>] ? __vunmap+0xb1/0xb8
[   33.022944]  [<ffffffff810b9df5>] load_module+0xc4b/0xeb3
[   33.028352]  [<ffffffff810b767b>] ? store_uevent+0x35/0x35
[   33.033841]  [<ffffffff810ba1aa>] SyS_finit_module+0x79/0x8f
[   33.039506]  [<ffffffff81496068>] tracesys+0xe1/0xe6
[   33.044473] Code: 48 8b 04 25 c0 c9 00 00 ff 80 6c 06 00 00 e8 16 ff 1d 00 89 45 c8 65 c7 04 25 00 0a 01 00 00 00 00 00 e8 f0 dc 0 
