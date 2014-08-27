Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbaH0QTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:19:11 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57651 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaH0QTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:19:09 -0400
Date: Wed, 27 Aug 2014 17:19:00 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140827161900.GA25326@sucs.org>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 02:14:02PM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Sitsofe Wheeler
> > Sent: Wednesday, August 27, 2014 20:16 PM
> 
> > > I'm making a patch for this.
> Please see the end of the mail for the inline patch and try it.
> (the patch hasn't been rebased against KY's patchset)

<snip>

> BTW, with the patch below, hyperv_fb can work now, BUT, *occasionally*,
> storvsc_probe() -> ... -> vmbus_open() -> can fail due to
> HV_STATUS_INVALID_ALIGNMENT...

I applied your new patch on top of KY's pieces (it applied cleanly) and
while it doesn't blow up, one warning is printed out and the UP boot
seemed to stall after input: TPPS/2 message (but pressing
ctrl-alt-delete allows the system to reboot cleanly).

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc1.x86_64-00001-g2f966f5a-dirty () (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #130 SMP Wed Aug 27 15:56:03 UTC 2014
[    0.000000] Command line: ro root=UUID=e78f2b16-8836-4e6a-9e5e-fdc6c9d3cfc3 video=hyperv_fb:800x600 LANG=en_US.UTF-8 elevator=noop console=tty0 console=ttyS0,115200n8 initrd=/boot/initramfs-3.17.0-rc1.x86_64-00001-g2f966f5a-dirty.img BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc1.x86_64-00001-g2f966f5a-dirty
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000f7feffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f7ff0000-0x00000000f7ffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000f7fff000-0x00000000f7ffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000207ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] Hypervisor detected: Microsoft HyperV
[    0.000000] HyperV: features 0xe7f, hints 0x2c
[    0.000000] HyperV: LAPIC Timer Frequency: 0x30d40
[    0.000000] e820: last_pfn = 0x208000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xf7ff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x207e00000-0x207ffffff]
[    0.000000] init_memory_mapping: [mem 0x204000000-0x207dfffff]
[    0.000000] init_memory_mapping: [mem 0x200000000-0x203ffffff]
[    0.000000] init_memory_mapping: [mem 0x180000000-0x1ffffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0xf7feffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000] RAMDISK: [mem 0x7fa41000-0x7fffefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F56F0 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x00000000F7FF0000 000040 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000F7FF0200 000081 (v02 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x00000000F7FF1724 002E78 (v01 MSFTVM MSFTVM02 00000002 INTL 02002026)
[    0.000000] ACPI: FACS 0x00000000F7FFF000 000040
[    0.000000] ACPI: WAET 0x00000000F7FF1480 000028 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: SLIC 0x00000000F7FF14C0 000176 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: OEM0 0x00000000F7FF16C0 000064 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000F7FF0600 000090 (v02 VRTUAL MICROSFT 00000001 MSFT 00000001)
[    0.000000] ACPI: APIC 0x00000000F7FF0300 00024C (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000F7FFF040 000064 (v01 VRTUAL MICROSFT 05001223 MSFT 00000097)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xf7ffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x207ffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xf7ffffff] + [mem 0x100000000-0x207ffffff] -> [mem 0x00000000-0x207ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x207ffffff]
[    0.000000]   NODE_DATA [mem 0x206fe7000-0x206ffbfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xf7feffff]
[    0.000000]   node   0: [mem 0x100000000-0x207ffffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x19] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x1d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x1e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x1f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x20] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x21] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x22] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x23] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x24] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x25] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x26] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x27] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x28] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x29] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x2a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x2b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x2d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x2e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x2f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x30] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x31] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x32] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x33] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x34] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x35] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x36] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x37] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x38] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x39] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x3a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x3b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x3c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x3d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x3e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x3f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: 64 Processors exceeds NR_CPUS limit of 16
[    0.000000] smpboot: Allowing 16 CPUs, 15 hotplug CPUs
[    0.000000] e820: [mem 0xf8000000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880206c00000 s83840 r0 d22656 u131072
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063737
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=UUID=e78f2b16-8836-4e6a-9e5e-fdc6c9d3cfc3 video=hyperv_fb:800x600 LANG=en_US.UTF-8 elevator=noop console=tty0 console=ttyS0,115200n8 initrd=/boot/initramfs-3.17.0-rc1.x86_64-00001-g2f966f5a-dirty.img BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc1.x86_64-00001-g2f966f5a-dirty
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Memory: 8135664K/8388152K available (6809K kernel code, 1178K rwdata, 2544K rodata, 1372K init, 15528K bss, 252488K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:552 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: selftest passed
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using PMTIMER reference calibration
[    0.000000] tsc: Detected 3199.984 MHz processor
[    0.007066] Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.96 BogoMIPS (lpj=3199984)
[    0.010037] pid_max: default: 32768 minimum: 301
[    0.011181] ACPI: Core revision 20140724
[    0.141832] ACPI: All ACPI Tables successfully acquired
[    0.146316] Security Framework initialized
[    0.147069] SELinux:  Initializing.
[    0.158419] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.168169] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.171546] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.172219] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.174000] Initializing cgroup subsys memory
[    0.174087] Initializing cgroup subsys devices
[    0.175086] Initializing cgroup subsys freezer
[    0.177084] Initializing cgroup subsys net_cls
[    0.178065] Initializing cgroup subsys blkio
[    0.179061] Initializing cgroup subsys perf_event
[    0.181066] Initializing cgroup subsys hugetlb
[    0.182342] mce: CPU supports 1 MCE banks
[    0.183102] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.183102] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.214385] ftrace: allocating 24816 entries in 97 pages
[    0.230685] Switched APIC routing to physical flat.
[    0.261000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.261009] smpboot: CPU0: Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz (fam: 06, model: 2d, stepping: 07)
[    0.265384] Performance Events: unsupported p6 CPU model 45 no PMU driver, software events only.
[    0.276311] x86: Booted up 1 node, 1 CPUs
[    0.277010] smpboot: Total of 1 processors activated (6399.96 BogoMIPS)
[    0.278049] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.288074] devtmpfs: initialized
[    0.341571] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.342037] pinctrl core: initialized pinctrl subsystem
[    0.344587] NET: Registered protocol family 16
[    0.348248] cpuidle: using governor menu
[    0.350153] ACPI: bus type PCI registered
[    0.351008] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.353654] PCI: Using configuration type 1 for base access
[    0.395125] ACPI: Added _OSI(Module Device)
[    0.396014] ACPI: Added _OSI(Processor Device)
[    0.397011] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.398019] ACPI: Added _OSI(Processor Aggregator Device)
[    0.471244] ACPI: Interpreter enabled
[    0.472072] ACPI: (supports S0 S5)
[    0.473018] ACPI: Using IOAPIC for interrupt routing
[    0.474588] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.696228] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.697047] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.698173] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.749947] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.752442] PCI host bridge to bus 0000:00
[    0.753031] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.754020] pci_bus 0000:00: root bus resource [mem 0xfe0000000-0xfffefffff]
[    0.755022] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.756026] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.757033] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.758058] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfffbffff]
[    0.772845] pci 0000:00:07.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.773011] pci 0000:00:07.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.774009] pci 0000:00:07.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.775019] pci 0000:00:07.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.778204] * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
[    0.778204] * this clock source is slow. Consider trying other clock sources
[    0.782168] pci 0000:00:07.3: quirk: [io  0x0400-0x043f] claimed by PIIX4 ACPI
[    0.897342] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.913638] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.931357] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.950196] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.967501] ACPI: Enabled 1 GPEs in block 00 to 0F
[    0.969838] vgaarb: device added: PCI:0000:00:08.0,decodes=io+mem,owns=io+mem,locks=none
[    0.970019] vgaarb: loaded
[    0.971008] vgaarb: bridge control possible 0000:00:08.0
[    0.974632] SCSI subsystem initialized
[    0.982409] hv_vmbus: Hyper-V Host Build:9600-6.3-17-0.17039; Vmbus version:3.0
[    5.983186] PCI: Using ACPI for IRQ routing
[    5.988032] NetLabel: Initializing
[    5.989008] NetLabel:  domain hash size = 128
[    5.990007] NetLabel:  protocols = UNLABELED CIPSOv4
[    5.991231] NetLabel:  unlabeled traffic allowed by default
[    5.992294] Switched to clocksource hyperv_clocksource
[    6.218281] pnp: PnP ACPI init
[    6.248717] system 00:06: [io  0x01e0-0x01ef] has been reserved
[    6.261551] system 00:06: [io  0x0160-0x016f] has been reserved
[    6.274466] system 00:06: [io  0x0278-0x027f] has been reserved
[    6.287204] system 00:06: [io  0x0378-0x037f] has been reserved
[    6.300893] system 00:06: [io  0x0678-0x067f] has been reserved
[    6.315561] system 00:06: [io  0x0778-0x077f] has been reserved
[    6.330114] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    6.349985] system 00:07: [io  0x0400-0x043f] has been reserved
[    6.364614] system 00:07: [io  0x0370-0x0371] has been reserved
[    6.379156] system 00:07: [io  0x0440-0x044f] has been reserved
[    6.394211] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    6.413877] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    6.437620] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    6.457463] system 00:08: [mem 0x000c0000-0x000dffff] could not be reserved
[    6.477269] system 00:08: [mem 0x000e0000-0x000fffff] could not be reserved
[    6.497149] system 00:08: [mem 0x00100000-0xf7ffffff] could not be reserved
[    6.517489] system 00:08: [mem 0xfffc0000-0xffffffff] has been reserved
[    6.539434] pnp: PnP ACPI: found 9 devices
[    6.598936] NET: Registered protocol family 2
[    6.621089] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    6.650901] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    6.684515] TCP: Hash tables configured (established 65536 bind 65536)
[    6.710364] TCP: reno registered
[    6.726210] UDP hash table entries: 4096 (order: 7, 655360 bytes)
[    6.750899] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes)
[    6.778251] NET: Registered protocol family 1
[    6.796671] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.822037] Unpacking initramfs...
[    7.108096] debug: unmapping init [mem 0xffff88007fa41000-0xffff88007fffefff]
[    7.350049] DMA-API: preallocated 65536 debug entries
[    7.362926] DMA-API: debugging enabled by kernel config
[    7.379248] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    7.393708] software IO TLB [mem 0xf3ff0000-0xf7ff0000] (64MB) mapped at [ffff8800f3ff0000-ffff8800f7feffff]
[    7.421900] RAPL PMU detected, hw unit 2^-0 Joules, API unit is 2^-32 Joules, 3 fixed counters 10737418240 ms ovfl timer
[    7.446422] AVX version of gcm_enc/dec engaged.
[    7.455143] AES CTR mode by8 optimization enabled
[    7.466245] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    7.480246] alg: No test for crc32 (crc32-pclmul)
[    7.497196] futex hash table entries: 4096 (order: 7, 524288 bytes)
[    7.516241] audit: initializing netlink subsys (disabled)
[    7.532488] audit: type=2000 audit(1409155400.532:1): initialized
[    7.553839] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    7.680200] VFS: Disk quotas dquot_6.5.2
[    7.694652] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.720583] SGI XFS with ACLs, security attributes, no debug enabled
[    7.766645] msgmni has been set to 15889
[    7.791413] alg: No test for stdrng (krng)
[    7.808731] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    7.836107] io scheduler noop registered (default)
[    7.854960] io scheduler deadline registered
[    7.876498] io scheduler cfq registered
[    7.900835] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.923484] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    7.950369] hv_vmbus: registering driver hyperv_fb
[    7.971023] hyperv_fb: Screen resolution: 800x600, Color depth: 32
[    8.002021] Console: switching to colour frame buffer device 100x37
[    8.025332] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    8.042203] ACPI: Power Button [PWRF]
[    8.054997] GHES: HEST is not enabled!
[    8.066246] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    8.105870] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    8.152895] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    8.175606] Non-volatile memory driver v1.3
[    8.189035] Linux agpgart interface v0.103
[    8.202038] loop: module loaded
[    8.210967] Loading iSCSI transport class v2.0-870.
[    8.225454] iscsi: registered transport (tcp)
[    8.237023] hv_vmbus: registering driver hv_storvsc
[    8.250570] ------------[ cut here ]------------
[    8.262526] WARNING: CPU: 0 PID: 1 at drivers/hv/hv.c:272 hv_post_message+0x108/0x1a0()
[    8.282261] status = 4
[    8.289323] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1.x86_64-00001-g2f966f5a-dirty #130
[    8.312173] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[    8.336612]  0000000000000009 ffff8801fb1bbb10 ffffffff8169a6ab ffff8801fb1bbb58
[    8.356878]  ffff8801fb1bbb48 ffffffff81071338 ffff8800f1175f28 ffff8800f1175f28
[    8.376703]  0000000000000004 0000000000000000 0000000000000001 ffff8801fb1bbba8
[    8.396499] Call Trace:
[    8.403508]  [<ffffffff8169a6ab>] dump_stack+0x4d/0x66
[    8.416566]  [<ffffffff81071338>] warn_slowpath_common+0x78/0xa0
[    8.431822]  [<ffffffff810713cc>] warn_slowpath_fmt+0x4c/0x50
[    8.446332]  [<ffffffff815a7d78>] hv_post_message+0x108/0x1a0
[    8.461074]  [<ffffffff815a8565>] vmbus_post_msg+0x35/0x60
[    8.475020]  [<ffffffff815a9148>] vmbus_open+0x258/0x360
[    8.488576]  [<ffffffff814b220f>] storvsc_probe+0x16f/0x8f0
[    8.502684]  [<ffffffff815a6c2b>] vmbus_probe+0x3b/0xa0
[    8.516018]  [<ffffffff81479eed>] driver_probe_device+0x16d/0x380
[    8.531302]  [<ffffffff8147a1be>] __driver_attach+0x6e/0xa0
[    8.545178]  [<ffffffff8147a150>] ? __device_attach+0x50/0x50
[    8.559689]  [<ffffffff8147809e>] bus_for_each_dev+0x6e/0xc0
[    8.574104]  [<ffffffff8147a2be>] driver_attach+0x1e/0x20
[    8.587855]  [<ffffffff81478ba8>] bus_add_driver+0x128/0x250
[    8.602279]  [<ffffffff81d84086>] ? iscsi_sw_tcp_init+0x42/0x42
[    8.617066]  [<ffffffff8147a7f8>] driver_register+0x98/0xe0
[    8.631159]  [<ffffffff815a7887>] __vmbus_driver_register+0x57/0x60
[    8.646929]  [<ffffffff81d840cb>] storvsc_drv_init+0x45/0x4f
[    8.661386]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[    8.675690]  [<ffffffff8108dee5>] ? parse_args+0x295/0x430
[    8.689560]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[    8.705274]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[    8.719184]  [<ffffffff8168d2d0>] ? rest_init+0xd0/0xd0
[    8.732193]  [<ffffffff8168d2de>] kernel_init+0xe/0x100
[    8.745075]  [<ffffffff816a31bc>] ret_from_fork+0x7c/0xb0
[    8.758340]  [<ffffffff8168d2d0>] ? rest_init+0xd0/0xd0
[    8.771163] ---[ end trace 5415561ba122a39f ]---
[    8.783292] hv_vmbus: probe failed for device vmbus_0_1 (4)
[    8.797124] hv_storvsc: probe of vmbus_0_1 failed with error 4
[    8.812995] scsi host1: storvsc_host_t
[    8.831860] scsi 1:0:0:0: scsi scan: INQUIRY result too short (5), using 36
[    8.850866] ata_piix 0000:00:07.1: Hyper-V Virtual Machine detected, ATA device ignore set
[    8.909047] scsi 1:0:0:1: Direct-Access     ADATA    SSD S510 120GB   5.2. PQ: 0 ANSI: 0
[    8.929446] scsi host2: ata_piix
[    8.939777] scsi host3: ata_piix
[    8.949576] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    8.965996] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    8.984332] libphy: Fixed MDIO Bus: probed
[    8.994743] hv_vmbus: registering driver hv_netvsc
[    9.009489] hv_netvsc: hv_netvsc channel opened successfully
[    9.049200] scsi 1:0:0:2: Direct-Access     MDT MD50 00AAKS-00TMA0         PQ: 0 ANSI: 2 CCS
[    9.072739] scsi 1:0:0:3: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[    9.095306] scsi 1:0:0:4: Direct-Access              ST1000DM003-9YN1 CC4H PQ: 0 ANSI: 0
[    9.117147] scsi 1:0:0:5: scsi scan: INQUIRY result too short (5), using 36
[    9.137166] scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.157319] scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.184885] scsi 1:1:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.204883] scsi 1:1:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.224911] scsi 1:1:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.244713] scsi 1:1:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.264525] scsi 1:2:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.284320] scsi 1:2:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.304129] scsi 1:2:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.324761] scsi 1:2:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.346377] scsi 1:3:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.366227] scsi 1:3:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.385976] scsi 1:3:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.405571] scsi 1:3:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.425141] scsi 1:4:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.444783] scsi 1:4:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.464456] scsi 1:4:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.483934] scsi 1:4:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.503476] scsi 1:5:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.523013] scsi 1:5:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.542943] scsi 1:5:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.567207] scsi 1:5:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.586990] scsi 1:6:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.606391] scsi 1:6:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.625971] scsi 1:6:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.648896] scsi 1:6:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.668310] scsi 1:7:0:0: scsi scan: INQUIRY result too short (5), using 36
[    9.687595] scsi 1:7:0:1: scsi scan: INQUIRY result too short (5), using 36
[    9.706929] scsi 1:7:1:0: scsi scan: INQUIRY result too short (5), using 36
[    9.726303] scsi 1:7:1:1: scsi scan: INQUIRY result too short (5), using 36
[    9.749219] sd 1:0:0:1: Attached scsi generic sg0 type 0
[    9.764796] sd 1:0:0:1: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    9.787723] sd 1:0:0:2: Attached scsi generic sg1 type 0
[    9.805380] sd 1:0:0:3: Attached scsi generic sg2 type 0
[    9.817963] sd 1:0:0:1: [sda] Write Protect is off
[    9.833578] sd 1:0:0:4: Attached scsi generic sg3 type 0
[    9.865627] sd 1:0:0:1: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.887268] sd 1:0:0:2: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    9.906274] sd 1:0:0:2: [sdb] Write Protect is off
[    9.917915] sd 1:0:0:3: [sdc] 199229440 512-byte logical blocks: (102 GB/95.0 GiB)
[    9.935770] sd 1:0:0:4: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    9.953597] sd 1:0:0:3: [sdc] Write Protect is off
[    9.979061] sd 1:0:0:2: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   10.001751] sd 1:0:0:3: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.025371] sd 1:0:0:4: [sdd] Write Protect is off
[   10.039460] sd 1:0:0:4: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.108118]  sdb: unknown partition table
[   10.122853]  sdc: unknown partition table
[   10.139977]  sda: sda1
[   10.154953]  sdd: sdd1 sdd2
[   10.200686] sd 1:0:0:3: [sdc] Attached SCSI disk
[   10.240513] sd 1:0:0:1: [sda] Attached SCSI disk
[   10.258800] sd 1:0:0:2: [sdb] Attached SCSI disk
[   10.274483] sd 1:0:0:4: [sdd] Attached SCSI disk
[   10.554785] tsc: Refined TSC clocksource calibration: 3200.076 MHz
[   10.788932] hv_netvsc vmbus_0_14: Send section size: 6144, Section count:2560
[   10.812618] hv_netvsc vmbus_0_14: Device MAC 00:15:5d:6f:02:8f link state up
[   10.838646] hv_netvsc: hv_netvsc channel opened successfully
[   10.910838] hv_netvsc vmbus_0_15: Send section size: 6144, Section count:2560
[   10.931164] hv_netvsc vmbus_0_15: Device MAC 00:15:5d:6f:02:a5 link state up
[   10.954001] hv_netvsc: hv_netvsc channel opened successfully
[   11.026171] hv_netvsc vmbus_0_16: Send section size: 6144, Section count:2560
[   11.046748] hv_netvsc vmbus_0_16: Device MAC 00:15:5d:6f:02:a6 link state up
[   11.068795] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   11.094332] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.107078] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.121517] hv_vmbus: registering driver hyperv_keyboard
[   11.137042] mousedev: PS/2 mouse device common for all mice
[   11.153596] rtc_cmos 00:00: RTC can wake from S4
[   11.188466] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   11.206427] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   11.227939] rtc_cmos 00:00: alarms up to one month, 114 bytes nvram
[   11.243866] piix4_smbus 0000:00:07.3: SMBus base address uninitialized - upgrade BIOS or use force_addr=0xaddr
[   11.272147] input: AT Translated Set 2 keyboard as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:07/VMBUS:01/vmbus_0_4/serio2/input/input3
[   11.307137] device-mapper: uevent: version 1.0.3
[   11.321414] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   11.343525] device-mapper: multipath: version 1.7.0 loaded
[   11.357167] device-mapper: multipath round-robin: version 1.0.0 loaded
[   11.373283] device-mapper: multipath queue-length: version 0.1.0 loaded
[   11.389527] device-mapper: multipath service-time: version 0.2.0 loaded
[   11.455090] hidraw: raw HID events driver (C) Jiri Kosina
[   11.470950] hv_vmbus: registering driver hid_hyperv
[   11.487193] input: Microsoft Vmbus HID-compliant Mouse as /devices/0006:045E:0621.0001/input/input5
[   11.513790] hid-generic 0006:045E:0621.0001: input: <UNKNOWN> HID v0.01 Mouse [Microsoft Vmbus HID-compliant Mouse] on
[   11.544146] hv_utils: Registering HyperV Utility Driver
[   11.558579] hv_vmbus: registering driver hv_util
[   11.574303] hv_vmbus: registering driver hv_balloon
[   11.588084] drop_monitor: Initializing network drop monitor service
[   11.606056] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.620990] TCP: cubic registered
[   11.630511] Initializing XFRM netlink socket
[   11.641890] NET: Registered protocol family 17
[   11.657722] registered taskstats version 1
[   11.671507] rtc_cmos 00:00: setting system clock to 2014-08-27 16:03:29 UTC (1409155409)
[   11.697333] debug: unmapping init [mem 0xffffffff81d28000-0xffffffff81e7efff]
[   11.716660] Write protecting the kernel read-only data: 12288k
[   11.733153] debug: unmapping init [mem 0xffff8800016a8000-0xffff8800017fffff]
[   11.751191] debug: unmapping init [mem 0xffff880001a7c000-0xffff880001bfffff]
[   11.811810] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   11.844925] systemd[1]: Detected virtualization 'microsoft'.
[   11.860003] systemd[1]: Running in initial RAM disk.

Welcome to Fedora 20 (Heisenbug) dracut-037-11.git20140402.fc20 (Initramfs)!

[   11.892455] systemd[1]: Failed to insert module 'ipv6'
[   11.907277] systemd[1]: Set hostname to <>.
[   11.931154] random: systemd urandom read with 59 bits of entropy available
[   12.052488] psmouse serio1: alps: Unknown ALPS touchpad: E7=12 00 64, EC=12 00 64
[   12.178137] systemd[1]: Expecting device dev-disk-by\x2duuid-e78f2b16\x2d8836\x2d4e6a\x2d9e5e\x2dfdc6c9d3cfc3.device...
         Expecting device dev-disk-by\x2duuid-e78f2b16\x2d883...3cfc3.device...
[   12.227591] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[   12.260579] systemd[1]: Created slice -.slice.
[   12.269807] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[   12.292262] systemd[1]: Created slice System Slice.
[   12.304265] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[   12.332056] systemd[1]: Reached target Slices.
[   12.344235] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[   12.371457] systemd[1]: Reached target Timers.
[   12.383594] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   12.405518] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   12.425954] systemd[1]: Starting Paths.
[  OK  ] Reached target Paths.
[   12.453467] systemd[1]: Reached target Paths.
[   12.465591] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[   12.495685] systemd[1]: Listening on Journal Socket.
[   12.510554] systemd[1]: Started dracut cmdline hook.
[   12.524565] systemd[1]: Started dracut pre-udev hook.
[   12.538900] systemd[1]: Started Load Kernel Modules.
[   12.551318] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[   12.584092] psmouse serio1: trackpoint: failed to get extended button data
[  OK  ] Started Journal Service.
[   12.614439] systemd[1]: Started Journal Service.
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
         Starting Apply Kernel Variables...
         Starting Create static device nodes in /dev...
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started Create static device nodes in /dev.
         Starting udev Kernel Device Manager...
[   13.048698] systemd-udevd[135]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Basic System.
[   13.716858] random: nonblocking pool is initialized
[   17.328354] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x01, buttons: 0/0
[   17.416991] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4

-- 
Sitsofe | http://sucs.org/~sits/
