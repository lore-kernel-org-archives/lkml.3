Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaCaA1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:27:03 -0400
Received: from exsmtp04.agrinet.ch ([81.221.254.203]:60659 "EHLO
	exsmtp04.agrinet.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaCaA0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:26:35 -0400
X-IMP-FROM: _________<joel@weedlight.ch>
X-IMP-AUTH_USERNAME: <joel@weedlight.ch>
X-Original-IP: 178.195.43.205
Message-ID: <1396225592.6272.0.camel@debian>
Subject: Re: vmlinuz-3.12.13-rt21 freezed by application
From: =?ISO-8859-1?Q?Jo=EBl_Kr=E4hemann?= <joel@weedlight.ch>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 31 Mar 2014 02:26:32 +0200
In-Reply-To: <1396222180.3831.0.camel@debian>
References: <1396109648.3443.15.camel@debian>
	 <1396114850.4053.8.camel@debian> <1396222180.3831.0.camel@debian>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 01:29 +0200, Joël Krähemann wrote:
> On Sat, 2014-03-29 at 18:40 +0100, Joël Krähemann wrote:
> > Same effect with vmlinuz-3.12.14-rt23 even with WindowMaker.
> > 
> > The fan turns on on no reaction of the OS without any special realtime
> > privileges. The threads run at priority 0 and can't switch to TTY[0-6].
> > 
> > It's a recent mac book pro output of `lspci -v` attached.
> > 
> > I have programmed a thread wrapper AgsThread with glib-object using
> > pthreads. I'm syncing a tree and having a thread pool which adds threads
> > to the tree at runtime.
> > 
> > Finally my question, what is the state of realtime kernel thread safety?
> > My application runs more or less stable with default debian kernel
> > configuration. But getting real bad performance.
> > 
> > 
> > On Sat, 2014-03-29 at 17:14 +0100, Joël Krähemann wrote:
> > > Hi, my application freezed recent kernel:
> > > 
> > > vmlinuz-3.12.13-rt21
> > > 
> > > http://sourceforge.net/p/ags/blog/2014/03/warning-freezed-gnulinux/
> > > 
> > > 
> > > Now I'm compiling vmlinuz-3.12.14-rt23 but as fully tickles
> > > 
> > > 
> > 
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.12.15-rt25 (root@debian) (gcc version
> 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT RT Sun Mar 30 23:57:59 CEST
> 2014
> [    0.000000] Command line:
> BOOT_IMAGE=(hd0,gpt6)/boot/vmlinuz-3.12.15-rt25 root=/dev/sda6
> nouveau.modeset=1 nouveau.modeset=1 acpi_backlight=vendor vt_handoff=7
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008dfff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000bffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff]
> usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008ad13fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000008ad14000-0x000000008ad52fff]
> ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000008ad53000-0x000000008ad68fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000008ad69000-0x000000008ad74fff]
> ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000008ad75000-0x000000008ad75fff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000008ad76000-0x000000008ad8efff]
> ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000008ad8f000-0x000000008af8ffff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000008af90000-0x000000008affefff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff]
> usable
> [    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000046f5fffff]
> usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
> MBP101.88Z.00EE.B03.1212211437 12/21/2012
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==>
> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x46f600 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-DFFFF write-protect
> [    0.000000]   E0000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
> [    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
> [    0.000000]   2 base 090000000 mask FF0000000 uncachable
> [    0.000000]   3 base 08C000000 mask FFC000000 uncachable
> [    0.000000]   4 base 08B000000 mask FFF000000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> 0x7010600070106
> [    0.000000] e820: last_pfn = 0x8b000 max_arch_pfn = 0x400000000
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size
> 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01ab4000, 0x01ab4fff] PGTABLE
> [    0.000000] BRK [0x01ab5000, 0x01ab5fff] PGTABLE
> [    0.000000] BRK [0x01ab6000, 0x01ab6fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x46f400000-0x46f5fffff]
> [    0.000000]  [mem 0x46f400000-0x46f5fffff] page 2M
> [    0.000000] BRK [0x01ab7000, 0x01ab7fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x46c000000-0x46f3fffff]
> [    0.000000]  [mem 0x46c000000-0x46f3fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x400000000-0x46bffffff]
> [    0.000000]  [mem 0x400000000-0x46bffffff] page 2M
> [    0.000000] BRK [0x01ab8000, 0x01ab8fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
> [    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
> [    0.000000]  [mem 0x40000000-0x40003fff] page 4k
> [    0.000000] BRK [0x01ab9000, 0x01ab9fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x40005000-0x8ad13fff]
> [    0.000000]  [mem 0x40005000-0x401fffff] page 4k
> [    0.000000]  [mem 0x40200000-0x8abfffff] page 2M
> [    0.000000]  [mem 0x8ac00000-0x8ad13fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x8ad53000-0x8ad68fff]
> [    0.000000]  [mem 0x8ad53000-0x8ad68fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x8ad75000-0x8ad75fff]
> [    0.000000]  [mem 0x8ad75000-0x8ad75fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x8ad8f000-0x8af8ffff]
> [    0.000000]  [mem 0x8ad8f000-0x8af8ffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x8afff000-0x8affffff]
> [    0.000000]  [mem 0x8afff000-0x8affffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
> [    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
> [    0.000000] RAMDISK: [mem 0x3664e000-0x3731efff]
> [    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
> [    0.000000] ACPI: XSDT 000000008ad8e1c0 000AC (v01 APPLE   Apple00
> 00000000      01000013)
> [    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00
> 00000000 Loki 0000005F)
> [    0.000000] ACPI: DSDT 000000008ad82000 04D5C (v01 APPLE  MacBookP
> 00100001 INTL 20100915)
> [    0.000000] ACPI: FACS 000000008ad1e000 00040
> [    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: SSDT 000000008ad7f000 0053A (v01 APPLE  SataAhci
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad7e000 00024 (v01 APPLE   SmcDppt
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad79000 00D3E (v01 APPLE    UsbPpt
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad6e000 019AA (v01 APPLE  TbtPEG11
> 00001000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad6d000 0071D (v01  PmRef  Cpu0Ist
> 00003000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad6c000 00B3D (v01  PmRef    CpuPm
> 00003000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad6b000 00315 (v01  PmRef  Cpu0Tst
> 00003000 INTL 20100915)
> [    0.000000] ACPI: SSDT 000000008ad6a000 0037A (v01  PmRef    ApTst
> 00003000 INTL 20100915)
> [    0.000000] ACPI: DMAR 000000008ad69000 00088 (v01 APPLE      IVB
> 00000001 AAPL 00000001)
> [    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00
> 00000001 Loki 0000005F)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem
> 0x0000000000000000-0x000000046f5fffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x46f5fffff]
> [    0.000000]   NODE_DATA [mem 0x46f5eb000-0x46f5effff]
> [    0.000000]  [ffffea0000000000-ffffea0011bfffff] PMD ->
> [ffff88045ec00000-ffff88046ebfffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x46f5fffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0008dfff]
> [    0.000000]   node   0: [mem 0x00090000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x40003fff]
> [    0.000000]   node   0: [mem 0x40005000-0x8ad13fff]
> [    0.000000]   node   0: [mem 0x8ad53000-0x8ad68fff]
> [    0.000000]   node   0: [mem 0x8ad75000-0x8ad75fff]
> [    0.000000]   node   0: [mem 0x8ad8f000-0x8af8ffff]
> [    0.000000]   node   0: [mem 0x8afff000-0x8affffff]
> [    0.000000]   node   0: [mem 0x100000000-0x46f5fffff]
> [    0.000000] On node 0 totalpages: 4170440
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 8821 pages used for memmap
> [    0.000000]   DMA32 zone: 564524 pages, LIFO batch:31
> [    0.000000]   Normal zone: 56280 pages used for memmap
> [    0.000000]   Normal zone: 3601920 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
> 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
> level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0008e000-0x0008ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000bffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000c0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8ad14000-0x8ad52fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8ad69000-0x8ad74fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8ad76000-0x8ad8efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8af90000-0x8affefff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8b000000-0x8f9fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x8fa00000-0xdfffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed0ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff7fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
> [    0.000000] e820: [mem 0x8fa00000-0xdfffffff] available for PCI
> devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
> nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88046f200000 s89536
> r8192 d21056 u262144
> [    0.000000] pcpu-alloc: s89536 r8192 d21056 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 4105254
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line:
> BOOT_IMAGE=(hd0,gpt6)/boot/vmlinuz-3.12.15-rt25 root=/dev/sda6
> nouveau.modeset=1 nouveau.modeset=1 acpi_backlight=vendor vt_handoff=7
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA -
> bailing!
> [    0.000000] Memory: 16327620K/16681760K available (4844K kernel code,
> 706K rwdata, 1592K rodata, 956K init, 1072K bss, 354140K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8,
> Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
> [    0.000000] 	Offload RCU callbacks from all CPUs
> [    0.000000] 	Offload RCU callbacks from CPUs: 0-511.
> [    0.000000] NR_IRQS:33024 nr_irqs:744 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 268435456 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't
> want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.001000] tsc: Detected 2693.870 MHz processor
> [    0.000003] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 5387.74 BogoMIPS (lpj=2693870)
> [    0.000004] pid_max: default: 32768 minimum: 301
> [    0.000029] Security Framework initialized
> [    0.000032] AppArmor: AppArmor disabled by boot time parameter
> [    0.000032] Yama: becoming mindful.
> [    0.001830] Dentry cache hash table entries: 2097152 (order: 13,
> 33554432 bytes)
> [    0.005714] Inode-cache hash table entries: 1048576 (order: 11,
> 8388608 bytes)
> [    0.007317] Mount-cache hash table entries: 256
> [    0.007445] Initializing cgroup subsys memory
> [    0.007452] Initializing cgroup subsys devices
> [    0.007452] Initializing cgroup subsys freezer
> [    0.007453] Initializing cgroup subsys net_cls
> [    0.007454] Initializing cgroup subsys blkio
> [    0.007454] Initializing cgroup subsys perf_event
> [    0.007474] CPU: Physical Processor ID: 0
> [    0.007474] CPU: Processor Core ID: 0
> [    0.007806] mce: CPU supports 9 MCE banks
> [    0.007816] CPU0: Thermal monitoring enabled (TM1)
> [    0.007824] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.007824] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.007824] tlb_flushall_shift: 2
> [    0.007925] Freeing SMP alternatives memory: 20K (ffffffff819a1000 -
> ffffffff819a6000)
> [    0.008626] ACPI: Core revision 20130725
> [    0.013728] ACPI: All ACPI Tables successfully acquired
> [    0.014043] dmar: Host address width 36
> [    0.014044] dmar: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.014048] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap
> c0000020e60262 ecap f0101a
> [    0.014049] dmar: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.014053] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap
> c9008020660262 ecap f0105a
> [    0.014053] dmar: RMRR base: 0x0000008b800000 end: 0x0000008f9fffff
> [    0.014124] IOAPIC id 0 under DRHD base  0xfed91000 IOMMU 1
> [    0.014124] HPET id 0 under DRHD base 0xfed91000
> [    0.014125] [Firmware Bug]: ioapic 2 has no mapping iommu, interrupt
> remapping will be disabled
> [    0.014125] Not enable interrupt remapping
> [    0.014125] Failed to enable irq remapping.  You are vulnerable to
> irq-injection attacks.
> [    0.014579] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.024578] smpboot: CPU0: Intel(R) Core(TM) i7-3740QM CPU @ 2.70GHz
> (fam: 06, model: 3a, stepping: 09)
> [    0.024585] TSC deadline timer enabled
> [    0.024593] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge
> events, full-width counters, Intel PMU driver.
> [    0.033798] ... version:                3
> [    0.033883] ... bit width:              48
> [    0.033965] ... generic registers:      4
> [    0.034049] ... value mask:             0000ffffffffffff
> [    0.034134] ... max period:             0000ffffffffffff
> [    0.034220] ... fixed-purpose events:   3
> [    0.034304] ... event mask:             000000070000000f
> [    0.061486] NMI watchdog: enabled on all CPUs, permanently consumes
> one hw-PMU counter.
> [    0.047745] smpboot: Booting Node   0, Processors  #   1 #   2 #   3
> #   4 #   5 #   6 #   7 OK
> [    0.167429] Brought up 8 CPUs
> [    0.167521] smpboot: Total of 8 processors activated (43101.92
> BogoMIPS)
> [    0.173941] devtmpfs: initialized
> [    0.176943] PM: Registering ACPI NVS region [mem
> 0x8ad14000-0x8ad52fff] (258048 bytes)
> [    0.177181] NET: Registered protocol family 16
> [    0.177349] cpuidle: using governor ladder
> [    0.177442] cpuidle: using governor menu
> [    0.177552] ACPI: bus type PCI registered
> [    0.177642] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.177790] PCI: MMCONFIG for domain 0000 [bus 00-9b] at [mem
> 0xe0000000-0xe9bfffff] (base 0xe0000000)
> [    0.177900] PCI: MMCONFIG at [mem 0xe0000000-0xe9bfffff] reserved in
> E820
> [    0.198035] PCI: Using configuration type 1 for base access
> [    0.198784] bio: create slab <bio-0> at 0
> [    0.198978] ACPI: Added _OSI(Module Device)
> [    0.199070] ACPI: Added _OSI(Processor Device)
> [    0.199153] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.199238] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.200610] ACPI: EC: EC description table is found, configuring boot
> EC
> [    0.205134] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.205701] ACPI: SSDT 000000008ad19190 008AD (v01  PmRef  Cpu0Cst
> 00003001 INTL 20100915)
> [    0.206286] ACPI: Dynamic OEM Table Load:
> [    0.206506] ACPI: SSDT           (null) 008AD (v01  PmRef  Cpu0Cst
> 00003001 INTL 20100915)
> [    0.210042] ACPI: SSDT 000000008ad1a710 003A4 (v01  PmRef    ApIst
> 00003000 INTL 20100915)
> [    0.210651] ACPI: Dynamic OEM Table Load:
> [    0.210894] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst
> 00003000 INTL 20100915)
> [    0.213863] ACPI: SSDT 000000008ad18d90 00119 (v01  PmRef    ApCst
> 00003000 INTL 20100915)
> [    0.214422] ACPI: Dynamic OEM Table Load:
> [    0.214647] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
> 00003000 INTL 20100915)
> [    0.218827] ACPI: Interpreter enabled
> [    0.218926] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S1_] (20130725/hwxface-571)
> [    0.219165] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S2_] (20130725/hwxface-571)
> [    0.219395] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S3_] (20130725/hwxface-571)
> [    0.219635] ACPI: (supports S0 S4 S5)
> [    0.219728] ACPI: Using IOAPIC for interrupt routing
> [    0.219835] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=nocrs" and report a bug
> [    0.220082] ACPI: No dock devices found.
> [    0.228861] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.229075] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
> [    0.229306] acpi PNP0A08:00: ACPI _OSC control (0x19) granted
> [    0.229804] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain
> 0000 [bus 00-9b] only partially covers this bridge
> [    0.230040] PCI host bridge to bus 0000:00
> [    0.230131] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.230219] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.230304] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.230390] pci_bus 0000:00: root bus resource [mem
> 0x000a0000-0x000bffff]
> [    0.230479] pci_bus 0000:00: root bus resource [mem
> 0x8fa00000-0xfeafffff]
> [    0.230566] pci_bus 0000:00: root bus resource [mem
> 0xfed40000-0xfed44fff]
> [    0.230658] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
> [    0.230732] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
> [    0.230760] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.230789] pci 0000:00:01.0: System wakeup disabled by ACPI
> [    0.230903] pci 0000:00:01.1: [8086:0155] type 01 class 0x060400
> [    0.230935] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
> [    0.230962] pci 0000:00:01.1: System wakeup disabled by ACPI
> [    0.231085] pci 0000:00:01.2: [8086:0159] type 01 class 0x060400
> [    0.231154] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
> [    0.231190] pci 0000:00:01.2: System wakeup disabled by ACPI
> [    0.231335] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
> [    0.231359] pci 0000:00:14.0: reg 0x10: [mem 0xc1c00000-0xc1c0ffff
> 64bit]
> [    0.231430] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.231462] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.231592] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
> [    0.231615] pci 0000:00:16.0: reg 0x10: [mem 0xc1c17100-0xc1c1710f
> 64bit]
> [    0.231691] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.231761] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
> [    0.231782] pci 0000:00:1a.0: reg 0x10: [mem 0xc1c16c00-0xc1c16fff]
> [    0.231872] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.231906] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.232033] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
> [    0.232048] pci 0000:00:1b.0: reg 0x10: [mem 0xc1c10000-0xc1c13fff
> 64bit]
> [    0.232116] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.232149] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.232272] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
> [    0.232398] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.232442] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.232565] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
> [    0.232694] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.232737] pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.232869] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
> [    0.232890] pci 0000:00:1d.0: reg 0x10: [mem 0xc1c16800-0xc1c16bff]
> [    0.232984] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.233018] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.233140] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
> [    0.233297] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
> [    0.233315] pci 0000:00:1f.2: reg 0x10: [io  0x3098-0x309f]
> [    0.233323] pci 0000:00:1f.2: reg 0x14: [io  0x30bc-0x30bf]
> [    0.233331] pci 0000:00:1f.2: reg 0x18: [io  0x3090-0x3097]
> [    0.233339] pci 0000:00:1f.2: reg 0x1c: [io  0x30b8-0x30bb]
> [    0.233347] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
> [    0.233355] pci 0000:00:1f.2: reg 0x24: [mem 0xc1c16000-0xc1c167ff]
> [    0.233400] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.233453] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
> [    0.233467] pci 0000:00:1f.3: reg 0x10: [mem 0xc1c17000-0xc1c170ff
> 64bit]
> [    0.233487] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
> [    0.233605] pci 0000:01:00.0: [10de:0fd5] type 00 class 0x030000
> [    0.233616] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xc0ffffff]
> [    0.233626] pci 0000:01:00.0: reg 0x14: [mem 0x90000000-0x9fffffff
> 64bit pref]
> [    0.233636] pci 0000:01:00.0: reg 0x1c: [mem 0xa0000000-0xa1ffffff
> 64bit pref]
> [    0.233643] pci 0000:01:00.0: reg 0x24: [io  0x2000-0x207f]
> [    0.233650] pci 0000:01:00.0: reg 0x30: [mem 0xc1000000-0xc107ffff
> pref]
> [    0.233701] pci 0000:01:00.0: System wakeup disabled by ACPI
> [    0.233824] pci 0000:01:00.1: [10de:0e1b] type 00 class 0x040300
> [    0.233834] pci 0000:01:00.1: reg 0x10: [mem 0xc1080000-0xc1083fff]
> [    1.237261] pci 0000:00:01.0: ASPM: Could not configure common clock
> [    1.237386] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    1.237478] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> [    1.237480] pci 0000:00:01.0:   bridge window [mem
> 0xc0000000-0xc10fffff]
> [    1.237484] pci 0000:00:01.0:   bridge window [mem
> 0x90000000-0xa1ffffff 64bit pref]
> [    1.237548] pci 0000:05:00.0: [8086:1547] type 01 class 0x060400
> [    1.237604] pci 0000:05:00.0: supports D1 D2
> [    1.237605] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.239501] pci 0000:00:01.1: PCI bridge to [bus 05-6b]
> [    1.239621] pci 0000:00:01.1:   bridge window [io  0x4000-0x6fff]
> [    1.239623] pci 0000:00:01.1:   bridge window [mem
> 0xc1d00000-0xce0fffff]
> [    1.239626] pci 0000:00:01.1:   bridge window [mem
> 0xce100000-0xda1fffff 64bit pref]
> [    1.239771] pci 0000:06:00.0: [8086:1547] type 01 class 0x060400
> [    1.239831] pci 0000:06:00.0: supports D1 D2
> [    1.239832] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.239891] pci 0000:06:03.0: [8086:1547] type 01 class 0x060400
> [    1.239949] pci 0000:06:03.0: supports D1 D2
> [    1.239951] pci 0000:06:03.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.240002] pci 0000:06:04.0: [8086:1547] type 01 class 0x060400
> [    1.240059] pci 0000:06:04.0: supports D1 D2
> [    1.240061] pci 0000:06:04.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.240112] pci 0000:06:05.0: [8086:1547] type 01 class 0x060400
> [    1.240165] pci 0000:06:05.0: supports D1 D2
> [    1.240166] pci 0000:06:05.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.240218] pci 0000:06:06.0: [8086:1547] type 01 class 0x060400
> [    1.240271] pci 0000:06:06.0: supports D1 D2
> [    1.240273] pci 0000:06:06.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.240334] pci 0000:05:00.0: PCI bridge to [bus 06-6b]
> [    1.240428] pci 0000:05:00.0:   bridge window [io  0x4000-0x5fff]
> [    1.240431] pci 0000:05:00.0:   bridge window [mem
> 0xc1d00000-0xca0fffff]
> [    1.240436] pci 0000:05:00.0:   bridge window [mem
> 0xce100000-0xd61fffff 64bit pref]
> [    1.240495] acpiphp: Slot [1] registered
> [    1.240607] pci 0000:07:00.0: [8086:1547] type 00 class 0x088000
> [    1.240620] pci 0000:07:00.0: reg 0x10: [mem 0xc1f00000-0xc1f3ffff]
> [    1.240629] pci 0000:07:00.0: reg 0x14: [mem 0xc1f40000-0xc1f40fff]
> [    1.240721] pci 0000:07:00.0: supports D1 D2
> [    1.240723] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.242476] pci 0000:06:00.0: PCI bridge to [bus 07]
> [    1.242597] pci 0000:06:00.0:   bridge window [mem
> 0xc1f00000-0xc1ffffff]
> [    1.242713] pci 0000:08:00.0: [8086:1549] type 01 class 0x060400
> [    1.242845] pci 0000:08:00.0: supports D1 D2
> [    1.242846] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.244438] pci 0000:06:03.0: PCI bridge to [bus 08-38]
> [    1.244562] pci 0000:06:03.0:   bridge window [io  0x4000-0x4fff]
> [    1.244564] pci 0000:06:03.0:   bridge window [mem
> 0xc2000000-0xc60fffff]
> [    1.244569] pci 0000:06:03.0:   bridge window [mem
> 0xce100000-0xd21fffff 64bit pref]
> [    1.244677] pci 0000:09:00.0: [8086:1549] type 01 class 0x060400
> [    1.244813] pci 0000:09:00.0: supports D1 D2
> [    1.244814] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot
> D3cold
> [    1.244932] pci 0000:08:00.0: PCI bridge to [bus 09-0a]
> [    1.245037] pci 0000:08:00.0:   bridge window [mem
> 0xc2000000-0xc20fffff]
> [    1.245046] pci 0000:08:00.0:   bridge window [mem
> 0xce100000-0xce1fffff 64bit pref]
> [    1.245180] pci 0000:0a:00.0: [14e4:1682] type 00 class 0x020000
> [    1.245226] pci 0000:0a:00.0: reg 0x10: [mem 0xce100000-0xce10ffff
> 64bit pref]
> [    1.245261] pci 0000:0a:00.0: reg 0x18: [mem 0xce110000-0xce11ffff
> 64bit pref]
> [    1.245334] pci 0000:0a:00.0: reg 0x30: [mem 0xffff0000-0xffffffff
> pref]
> [    1.245489] pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
> [    1.247310] pci 0000:09:00.0: PCI bridge to [bus 0a]
> [    1.247435] pci 0000:09:00.0:   bridge window [mem
> 0xc2000000-0xc20fffff]
> [    1.247444] pci 0000:09:00.0:   bridge window [mem
> 0xce100000-0xce1fffff 64bit pref]
> [    1.247538] pci 0000:06:04.0: PCI bridge to [bus 39-69]
> [    1.247636] pci 0000:06:04.0:   bridge window [io  0x5000-0x5fff]
> [    1.247639] pci 0000:06:04.0:   bridge window [mem
> 0xc6100000-0xca0fffff]
> [    1.247643] pci 0000:06:04.0:   bridge window [mem
> 0xd2200000-0xd61fffff 64bit pref]
> [    1.247690] pci 0000:06:05.0: PCI bridge to [bus 6a]
> [    1.247788] pci 0000:06:05.0:   bridge window [mem
> 0xc1e00000-0xc1efffff]
> [    1.247839] pci 0000:06:06.0: PCI bridge to [bus 6b]
> [    1.247937] pci 0000:06:06.0:   bridge window [mem
> 0xc1d00000-0xc1dfffff]
> [    1.248023] pci 0000:00:01.2: PCI bridge to [bus 02]
> [    1.248122] pci 0000:00:01.2:   bridge window [mem
> 0xc1b00000-0xc1bfffff]
> [    1.248302] pci 0000:03:00.0: [14e4:16a3] type 00 class 0x020000
> [    1.248338] pci 0000:03:00.0: reg 0x10: [mem 0xc1800000-0xc180ffff
> 64bit pref]
> [    1.248367] pci 0000:03:00.0: reg 0x18: [mem 0xc1810000-0xc181ffff
> 64bit pref]
> [    1.248419] pci 0000:03:00.0: reg 0x30: [mem 0xfffff800-0xffffffff
> pref]
> [    1.248527] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    1.248662] pci 0000:03:00.1: [14e4:16bc] type 00 class 0x080501
> [    1.248700] pci 0000:03:00.1: reg 0x10: [mem 0xc1820000-0xc182ffff
> 64bit pref]
> [    1.248884] pci 0000:03:00.1: PME# supported from D0 D3hot D3cold
> [    1.248925] pci 0000:03:00.1: System wakeup disabled by ACPI
> [    1.250626] pci 0000:00:1c.0: PCI bridge to [bus 03]
> [    1.250725] pci 0000:00:1c.0:   bridge window [mem
> 0xc1a00000-0xc1afffff]
> [    1.250733] pci 0000:00:1c.0:   bridge window [mem
> 0xc1800000-0xc18fffff 64bit pref]
> [    1.250884] pci 0000:04:00.0: [14e4:4331] type 00 class 0x028000
> [    1.250914] pci 0000:04:00.0: reg 0x10: [mem 0xc1900000-0xc1903fff
> 64bit]
> [    1.251085] pci 0000:04:00.0: supports D1 D2
> [    1.251086] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
> [    1.251125] pci 0000:04:00.0: System wakeup disabled by ACPI
> [    1.252500] pci 0000:00:1c.1: PCI bridge to [bus 04]
> [    1.252620] pci 0000:00:1c.1:   bridge window [mem
> 0xc1900000-0xc19fffff]
> [    1.253176] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
> 14 15) *11
> [    1.254165] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12
> 14 15) *0, disabled.
> [    1.255219] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
> 14 15) *0, disabled.
> [    1.256274] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12
> 14 15)
> [    1.257193] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
> 14 15) *0, disabled.
> [    1.258248] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
> 14 15) *0, disabled.
> [    1.259303] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12
> 14 15)
> [    1.260217] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12
> 14 15)
> [    1.262566] ACPI: Enabled 3 GPEs in block 00 to 3F
> [    1.262792] ACPI: \_SB_.PCI0: notify handler is installed
> [    1.262837] Found 1 acpi root devices
> [    1.262859] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data =
> 0x62
> [    1.263038] vgaarb: device added: PCI:0000:01:00.0,decodes=io
> +mem,owns=io+mem,locks=none
> [    1.263141] vgaarb: loaded
> [    1.263225] vgaarb: bridge control possible 0000:01:00.0
> [    1.263340] PCI: Using ACPI for IRQ routing
> [    1.268526] PCI: pci_cache_line_size set to 64 bytes
> [    1.268729] e820: reserve RAM buffer [mem 0x0008e000-0x0008ffff]
> [    1.268731] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.268732] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
> [    1.268733] e820: reserve RAM buffer [mem 0x8ad14000-0x8bffffff]
> [    1.268735] e820: reserve RAM buffer [mem 0x8ad69000-0x8bffffff]
> [    1.268736] e820: reserve RAM buffer [mem 0x8ad76000-0x8bffffff]
> [    1.268738] e820: reserve RAM buffer [mem 0x8af90000-0x8bffffff]
> [    1.268739] e820: reserve RAM buffer [mem 0x8b000000-0x8bffffff]
> [    1.268740] e820: reserve RAM buffer [mem 0x46f600000-0x46fffffff]
> [    1.268834] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    1.269499] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    1.272639] Switched to clocksource hpet
> [    1.274605] pnp: PnP ACPI init
> [    1.274720] ACPI: bus type PNP registered
> [    1.274895] pnp 00:00: [dma 4]
> [    1.274915] pnp 00:00: Plug and Play ACPI device, IDs PNP0200
> (active)
> [    1.274936] pnp 00:01: Plug and Play ACPI device, IDs INT0800
> (active)
> [    1.275040] system 00:02: [mem 0xfed00000-0xfed003ff] has been
> reserved
> [    1.275138] system 00:02: Plug and Play ACPI device, IDs PNP0103
> PNP0c01 (active)
> [    1.275166] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04
> (active)
> [    1.275200] system 00:04: [io  0x1000-0x100f] has been reserved
> [    1.275295] system 00:04: [io  0x0400-0x047f] could not be reserved
> [    1.275384] system 00:04: [io  0x0500-0x057f] has been reserved
> [    1.275469] system 00:04: Plug and Play ACPI device, IDs PNP0c02
> (active)
> [    1.275489] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00
> (active)
> [    1.275519] pnp 00:06: Plug and Play ACPI device, IDs APP0001
> (active)
> [    1.275571] pnp 00:07: Plug and Play ACPI device, IDs APP000b
> (active)
> [    1.275716] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been
> reserved
> [    1.275814] system 00:08: [mem 0xfed10000-0xfed17fff] could not be
> reserved
> [    1.275902] system 00:08: [mem 0xfed18000-0xfed18fff] has been
> reserved
> [    1.275990] system 00:08: [mem 0xfed19000-0xfed19fff] has been
> reserved
> [    1.276078] system 00:08: [mem 0xe0000000-0xefffffff] has been
> reserved
> [    1.276163] system 00:08: [mem 0xfed20000-0xfed3ffff] has been
> reserved
> [    1.276252] system 00:08: [mem 0xfed90000-0xfed93fff] could not be
> reserved
> [    1.281389] system 00:08: [mem 0xfed45000-0xfed8ffff] has been
> reserved
> [    1.281478] system 00:08: [mem 0xff000000-0xffffffff] could not be
> reserved
> [    1.281566] system 00:08: [mem 0xfee00000-0xfeefffff] could not be
> reserved
> [    1.281658] system 00:08: Plug and Play ACPI device, IDs PNP0c02
> (active)
> [    1.283942] system 00:09: [mem 0x20000000-0x201fffff] has been
> reserved
> [    1.284096] system 00:09: [mem 0x40000000-0x401fffff] could not be
> reserved
> [    1.284213] system 00:09: Plug and Play ACPI device, IDs PNP0c01
> (active)
> [    1.284219] pnp: PnP ACPI: found 10 devices
> [    1.284365] ACPI: bus type PNP unregistered
> [    1.290871] pci 0000:0a:00.0: no compatible bridge window for [mem
> 0xffff0000-0xffffffff pref]
> [    1.290979] pci 0000:03:00.0: no compatible bridge window for [mem
> 0xfffff800-0xffffffff pref]
> [    1.291104] pci 0000:09:00.0: bridge window [io  0x1000-0x0fff] to
> [bus 0a] add_size 1000
> [    1.291118] pci 0000:09:00.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [    1.291119] pci 0000:08:00.0: bridge window [io  0x1000-0x0fff] to
> [bus 09-0a] add_size 1000
> [    1.291135] pci 0000:06:05.0: bridge window [io  0x1000-0x0fff] to
> [bus 6a] add_size 1000
> [    1.291137] pci 0000:06:05.0: bridge window [mem
> 0x00100000-0x000fffff 64bit pref] to [bus 6a] add_size 200000
> [    1.291143] pci 0000:06:06.0: bridge window [io  0x1000-0x0fff] to
> [bus 6b] add_size 1000
> [    1.291145] pci 0000:06:06.0: bridge window [mem
> 0x00100000-0x000fffff 64bit pref] to [bus 6b] add_size 200000
> [    1.291186] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    1.291280] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> [    1.291367] pci 0000:00:01.0:   bridge window [mem
> 0xc0000000-0xc10fffff]
> [    1.291457] pci 0000:00:01.0:   bridge window [mem
> 0x90000000-0xa1ffffff 64bit pref]
> [    1.291559] pci 0000:06:05.0: res[15]=[mem 0x00100000-0x000fffff
> 64bit pref] get_res_add_size add_size 200000
> [    1.291561] pci 0000:06:06.0: res[15]=[mem 0x00100000-0x000fffff
> 64bit pref] get_res_add_size add_size 200000
> [    1.291562] pci 0000:06:05.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [    1.291564] pci 0000:06:06.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [    1.291566] pci 0000:06:05.0: BAR 15: can't assign mem pref (size
> 0x200000)
> [    1.291669] pci 0000:06:06.0: BAR 15: can't assign mem pref (size
> 0x200000)
> [    1.291757] pci 0000:06:05.0: BAR 13: can't assign io (size 0x1000)
> [    1.291844] pci 0000:06:06.0: BAR 13: can't assign io (size 0x1000)
> [    1.291932] pci 0000:06:06.0: BAR 15: can't assign mem pref (size
> 0x200000)
> [    1.292021] pci 0000:06:06.0: BAR 13: can't assign io (size 0x1000)
> [    1.292107] pci 0000:06:05.0: BAR 15: can't assign mem pref (size
> 0x200000)
> [    1.292193] pci 0000:06:05.0: BAR 13: can't assign io (size 0x1000)
> [    1.292280] pci 0000:06:00.0: PCI bridge to [bus 07]
> [    1.292368] pci 0000:06:00.0:   bridge window [mem
> 0xc1f00000-0xc1ffffff]
> [    1.292462] pci 0000:08:00.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [    1.292464] pci 0000:08:00.0: BAR 13: assigned [io  0x4000-0x4fff]
> [    1.292560] pci 0000:09:00.0: res[13]=[io  0x1000-0x0fff]
> get_res_add_size add_size 1000
> [    1.292561] pci 0000:09:00.0: BAR 13: assigned [io  0x4000-0x4fff]
> [    1.292653] pci 0000:0a:00.0: BAR 6: assigned [mem
> 0xce120000-0xce12ffff pref]
> [    1.292762] pci 0000:09:00.0: PCI bridge to [bus 0a]
> [    1.292850] pci 0000:09:00.0:   bridge window [io  0x4000-0x4fff]
> [    1.292944] pci 0000:09:00.0:   bridge window [mem
> 0xc2000000-0xc20fffff]
> [    1.293044] pci 0000:09:00.0:   bridge window [mem
> 0xce100000-0xce1fffff 64bit pref]
> [    1.293151] pci 0000:08:00.0: PCI bridge to [bus 09-0a]
> [    1.293248] pci 0000:08:00.0:   bridge window [io  0x4000-0x4fff]
> [    1.293340] pci 0000:08:00.0:   bridge window [mem
> 0xc2000000-0xc20fffff]
> [    1.293442] pci 0000:08:00.0:   bridge window [mem
> 0xce100000-0xce1fffff 64bit pref]
> [    1.293550] pci 0000:06:03.0: PCI bridge to [bus 08-38]
> [    1.293649] pci 0000:06:03.0:   bridge window [io  0x4000-0x4fff]
> [    1.293739] pci 0000:06:03.0:   bridge window [mem
> 0xc2000000-0xc60fffff]
> [    1.293829] pci 0000:06:03.0:   bridge window [mem
> 0xce100000-0xd21fffff 64bit pref]
> [    1.293934] pci 0000:06:04.0: PCI bridge to [bus 39-69]
> [    1.294021] pci 0000:06:04.0:   bridge window [io  0x5000-0x5fff]
> [    1.294110] pci 0000:06:04.0:   bridge window [mem
> 0xc6100000-0xca0fffff]
> [    1.294200] pci 0000:06:04.0:   bridge window [mem
> 0xd2200000-0xd61fffff 64bit pref]
> [    1.294304] pci 0000:06:05.0: PCI bridge to [bus 6a]
> [    1.294390] pci 0000:06:05.0:   bridge window [mem
> 0xc1e00000-0xc1efffff]
> [    1.294484] pci 0000:06:06.0: PCI bridge to [bus 6b]
> [    1.294573] pci 0000:06:06.0:   bridge window [mem
> 0xc1d00000-0xc1dfffff]
> [    1.294668] pci 0000:05:00.0: PCI bridge to [bus 06-6b]
> [    1.294753] pci 0000:05:00.0:   bridge window [io  0x4000-0x5fff]
> [    1.294840] pci 0000:05:00.0:   bridge window [mem
> 0xc1d00000-0xca0fffff]
> [    1.294930] pci 0000:05:00.0:   bridge window [mem
> 0xce100000-0xd61fffff 64bit pref]
> [    1.295032] pci 0000:00:01.1: PCI bridge to [bus 05-6b]
> [    1.295119] pci 0000:00:01.1:   bridge window [io  0x4000-0x6fff]
> [    1.295206] pci 0000:00:01.1:   bridge window [mem
> 0xc1d00000-0xce0fffff]
> [    1.295295] pci 0000:00:01.1:   bridge window [mem
> 0xce100000-0xda1fffff 64bit pref]
> [    1.295396] pci 0000:00:01.2: PCI bridge to [bus 02]
> [    1.295484] pci 0000:00:01.2:   bridge window [mem
> 0xc1b00000-0xc1bfffff]
> [    1.295579] pci 0000:03:00.0: BAR 6: assigned [mem
> 0xc1830000-0xc18307ff pref]
> [    1.295688] pci 0000:00:1c.0: PCI bridge to [bus 03]
> [    1.295777] pci 0000:00:1c.0:   bridge window [mem
> 0xc1a00000-0xc1afffff]
> [    1.295868] pci 0000:00:1c.0:   bridge window [mem
> 0xc1800000-0xc18fffff 64bit pref]
> [    1.295975] pci 0000:00:1c.1: PCI bridge to [bus 04]
> [    1.296075] pci 0000:00:1c.1:   bridge window [mem
> 0xc1900000-0xc19fffff]
> [    1.296170] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.296172] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    1.296173] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    1.296175] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
> [    1.296176] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
> [    1.296178] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> [    1.296179] pci_bus 0000:01: resource 1 [mem 0xc0000000-0xc10fffff]
> [    1.296180] pci_bus 0000:01: resource 2 [mem 0x90000000-0xa1ffffff
> 64bit pref]
> [    1.296182] pci_bus 0000:05: resource 0 [io  0x4000-0x6fff]
> [    1.296183] pci_bus 0000:05: resource 1 [mem 0xc1d00000-0xce0fffff]
> [    1.296185] pci_bus 0000:05: resource 2 [mem 0xce100000-0xda1fffff
> 64bit pref]
> [    1.296186] pci_bus 0000:06: resource 0 [io  0x4000-0x5fff]
> [    1.296187] pci_bus 0000:06: resource 1 [mem 0xc1d00000-0xca0fffff]
> [    1.296189] pci_bus 0000:06: resource 2 [mem 0xce100000-0xd61fffff
> 64bit pref]
> [    1.296190] pci_bus 0000:07: resource 1 [mem 0xc1f00000-0xc1ffffff]
> [    1.296192] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
> [    1.296193] pci_bus 0000:08: resource 1 [mem 0xc2000000-0xc60fffff]
> [    1.296194] pci_bus 0000:08: resource 2 [mem 0xce100000-0xd21fffff
> 64bit pref]
> [    1.296196] pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
> [    1.296197] pci_bus 0000:09: resource 1 [mem 0xc2000000-0xc20fffff]
> [    1.296199] pci_bus 0000:09: resource 2 [mem 0xce100000-0xce1fffff
> 64bit pref]
> [    1.296200] pci_bus 0000:0a: resource 0 [io  0x4000-0x4fff]
> [    1.296201] pci_bus 0000:0a: resource 1 [mem 0xc2000000-0xc20fffff]
> [    1.296203] pci_bus 0000:0a: resource 2 [mem 0xce100000-0xce1fffff
> 64bit pref]
> [    1.296204] pci_bus 0000:39: resource 0 [io  0x5000-0x5fff]
> [    1.296205] pci_bus 0000:39: resource 1 [mem 0xc6100000-0xca0fffff]
> [    1.296207] pci_bus 0000:39: resource 2 [mem 0xd2200000-0xd61fffff
> 64bit pref]
> [    1.296208] pci_bus 0000:6a: resource 1 [mem 0xc1e00000-0xc1efffff]
> [    1.296210] pci_bus 0000:6b: resource 1 [mem 0xc1d00000-0xc1dfffff]
> [    1.296211] pci_bus 0000:02: resource 1 [mem 0xc1b00000-0xc1bfffff]
> [    1.296213] pci_bus 0000:03: resource 1 [mem 0xc1a00000-0xc1afffff]
> [    1.296214] pci_bus 0000:03: resource 2 [mem 0xc1800000-0xc18fffff
> 64bit pref]
> [    1.296215] pci_bus 0000:04: resource 1 [mem 0xc1900000-0xc19fffff]
> [    1.296241] NET: Registered protocol family 2
> [    1.296609] TCP established hash table entries: 131072 (order: 9,
> 2097152 bytes)
> [    1.297253] TCP bind hash table entries: 65536 (order: 9, 3670016
> bytes)
> [    1.297989] TCP: Hash tables configured (established 131072 bind
> 65536)
> [    1.298100] TCP: reno registered
> [    1.298278] UDP hash table entries: 8192 (order: 8, 1048576 bytes)
> [    1.298652] UDP-Lite hash table entries: 8192 (order: 8, 1048576
> bytes)
> [    1.298995] NET: Registered protocol family 1
> [    1.299189] pci 0000:00:14.0: can't derive routing for PCI INT A
> [    1.299283] pci 0000:00:14.0: PCI INT A: no GSI
> [    1.299480] pci 0000:00:14.0: can't derive routing for PCI INT A
> [    1.300138] pci 0000:01:00.0: Boot video device
> [    1.300151] PCI: CLS mismatch (256 != 128), using 64 bytes
> [    1.300206] Unpacking initramfs...
> [    1.513591] Freeing initrd memory: 13124K (ffff88003664e000 -
> ffff88003731f000)
> [    1.513708] dmar: Device scope device [0000:00:02.00] not found
> [    1.513795] dmar: Device scope device [0000:00:02.00] not found
> [    1.513881] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    1.513967] software IO TLB [mem 0x86d14000-0x8ad14000] (64MB) mapped
> at [ffff880086d14000-ffff88008ad13fff]
> [    1.514366] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514373] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514375] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514380] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514384] microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514388] microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514393] microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514399] microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x15
> [    1.514447] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    1.515447] audit: initializing netlink socket (disabled)
> [    1.515550] type=2000 audit(1396220419.495:1): initialized
> [    1.526857] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.527916] VFS: Disk quotas dquot_6.5.2
> [    1.528039] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.528210] msgmni has been set to 31915
> [    1.528617] alg: No test for stdrng (krng)
> [    1.528739] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 252)
> [    1.528892] io scheduler noop registered
> [    1.528990] io scheduler deadline registered
> [    1.529091] io scheduler cfq registered (default)
> [    1.529344] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    1.529456] pcieport 0000:00:01.1: irq 41 for MSI/MSI-X
> [    1.529487] pcieport 0000:00:01.2: enabling device (0000 -> 0002)
> [    1.529694] pcieport 0000:00:01.2: irq 42 for MSI/MSI-X
> [    1.530062] pcieport 0000:05:00.0: irq 43 for MSI/MSI-X
> [    1.530154] pcieport 0000:06:00.0: irq 44 for MSI/MSI-X
> [    1.530247] pcieport 0000:06:03.0: irq 45 for MSI/MSI-X
> [    1.530346] pcieport 0000:06:04.0: irq 46 for MSI/MSI-X
> [    1.530405] pcieport 0000:06:05.0: enabling device (0000 -> 0002)
> [    1.530546] pcieport 0000:06:05.0: irq 47 for MSI/MSI-X
> [    1.530616] pcieport 0000:06:06.0: enabling device (0000 -> 0002)
> [    1.530756] pcieport 0000:06:06.0: irq 48 for MSI/MSI-X
> [    1.530880] pcieport 0000:08:00.0: irq 49 for MSI/MSI-X
> [    1.531042] pcieport 0000:09:00.0: irq 50 for MSI/MSI-X
> [    1.531158] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    1.531344] pciehp 0000:06:03.0:pcie24: HPC vendor_id 8086 device_id
> 1547 ss_vid 2222 ss_did 1111
> [    1.531528] pciehp 0000:06:03.0:pcie24: service driver pciehp loaded
> [    1.531536] pciehp 0000:06:04.0:pcie24: HPC vendor_id 8086 device_id
> 1547 ss_vid 2222 ss_did 1111
> [    1.531729] pciehp 0000:06:04.0:pcie24: service driver pciehp loaded
> [    1.531738] pciehp 0000:06:05.0:pcie24: HPC vendor_id 8086 device_id
> 1547 ss_vid 2222 ss_did 1111
> [    1.531912] pciehp 0000:06:05.0:pcie24: service driver pciehp loaded
> [    1.531920] pciehp 0000:06:06.0:pcie24: HPC vendor_id 8086 device_id
> 1547 ss_vid 2222 ss_did 1111
> [    1.532093] pciehp 0000:06:06.0:pcie24: service driver pciehp loaded
> [    1.532108] pciehp 0000:09:00.0:pcie24: HPC vendor_id 8086 device_id
> 1549 ss_vid 0 ss_did 0
> [    1.532296] pciehp 0000:09:00.0:pcie24: service driver pciehp loaded
> [    1.532300] pciehp: PCI Express Hot Plug Controller Driver version:
> 0.4
> [    1.532415] intel_idle: MWAIT substates: 0x21120
> [    1.532416] intel_idle: v0.4 model 0x3A
> [    1.532417] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    1.532602] GHES: HEST is not enabled!
> [    1.532736] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.533232] Linux agpgart interface v0.103
> [    1.533421] i8042: PNP: No PS/2 controller found. Probing ports
> directly.
> [    2.515255] tsc: Refined TSC clocksource calibration: 2693.889 MHz
> [    2.633326] i8042: No controller found
> [    2.633481] mousedev: PS/2 mouse device common for all mice
> [    2.633604] rtc_cmos 00:05: RTC can wake from S4
> [    2.633810] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    2.633957] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes
> nvram, hpet irqs
> [    2.634076] Intel P-state driver initializing.
> [    2.634169] Intel pstate controlling: cpu 0
> [    2.634298] Intel pstate controlling: cpu 1
> [    2.634409] Intel pstate controlling: cpu 2
> [    2.634510] Intel pstate controlling: cpu 3
> [    2.634621] Intel pstate controlling: cpu 4
> [    2.634729] Intel pstate controlling: cpu 5
> [    2.634840] Intel pstate controlling: cpu 6
> [    2.634946] Intel pstate controlling: cpu 7
> [    2.635067] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
> [    2.635162] AMD IOMMUv2 functionality not available on this system
> [    2.635332] TCP: cubic registered
> [    2.635495] NET: Registered protocol family 10
> [    2.635738] mip6: Mobile IPv6
> [    2.635830] NET: Registered protocol family 17
> [    2.635916] mpls_gso: MPLS GSO support
> [    2.636266] registered taskstats version 1
> [    2.637271] rtc_cmos 00:05: setting system clock to 2014-03-30
> 23:00:21 UTC (1396220421)
> [    2.637429] PM: Hibernation image not present or could not be loaded.
> [    2.638009] Freeing unused kernel memory: 956K (ffffffff818b2000 -
> ffffffff819a1000)
> [    2.638118] Write protecting the kernel read-only data: 8192k
> [    2.640647] Freeing unused kernel memory: 1288K (ffff8800014be000 -
> ffff880001600000)
> [    2.641625] Freeing unused kernel memory: 456K (ffff88000178e000 -
> ffff880001800000)
> [    2.651679] systemd-udevd[138]: starting version 204
> [    2.689519] pps_core: LinuxPPS API ver. 1 registered
> [    2.689658] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
> Rodolfo Giometti <giometti@linux.it>
> [    2.690137] PTP clock support registered
> [    2.693001] tg3.c:v3.133 (Jul 29, 2013)
> [    2.700534] ACPI: bus type USB registered
> [    2.701160] sdhci: Secure Digital Host Controller Interface driver
> [    2.701275] usbcore: registered new interface driver usbfs
> [    2.701473] sdhci: Copyright(c) Pierre Ossman
> [    2.701669] usbcore: registered new interface driver hub
> [    2.702368] SCSI subsystem initialized
> [    2.704016] sdhci-pci 0000:03:00.1: SDHCI controller found
> [14e4:16bc] (rev 10)
> [    2.705454] libata version 3.00 loaded.
> [    2.706253] mmc0: SDHCI controller on PCI [0000:03:00.1] using ADMA
> [    2.715728] usbcore: registered new device driver usb
> [    2.716880] ahci 0000:00:1f.2: version 3.0
> [    2.717041] ahci 0000:00:1f.2: irq 51 for MSI/MSI-X
> [    2.717108] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
> 0x1 impl SATA mode
> [    2.717304] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum
> part ems apst 
> [    2.717481] ahci 0000:00:1f.2: setting latency timer to 64
> [    2.719472] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
> Driver
> [    2.720742] ehci-pci: EHCI PCI platform driver
> [    2.727358] scsi0 : ahci
> [    2.728377] scsi1 : ahci
> [    2.729630] scsi2 : ahci
> [    2.730006] scsi3 : ahci
> [    2.730249] scsi4 : ahci
> [    2.731160] scsi5 : ahci
> [    2.731609] ata1: SATA max UDMA/133 abar m2048@0xc1c16000 port
> 0xc1c16100 irq 51
> [    2.731907] ata2: DUMMY
> [    2.732159] ata3: DUMMY
> [    2.732357] ata4: DUMMY
> [    2.732537] ata5: DUMMY
> [    2.732671] ata6: DUMMY
> [    2.733021] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
> [    2.733208] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
> [    2.733446] xhci_hcd 0000:00:14.0: setting latency timer to 64
> [    2.733453] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    2.733694] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
> bus number 1
> [    2.734052] xhci_hcd 0000:00:14.0: cache line size of 64 is not
> supported
> [    2.734082] xhci_hcd 0000:00:14.0: irq 52 for MSI/MSI-X
> [    2.734237] usb usb1: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    2.734464] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.734682] usb usb1: Product: xHCI Host Controller
> [    2.734881] usb usb1: Manufacturer: Linux 3.12.15-rt25 xhci_hcd
> [    2.735053] usb usb1: SerialNumber: 0000:00:14.0
> [    2.737642] hub 1-0:1.0: USB hub found
> [    2.737840] hub 1-0:1.0: 4 ports detected
> [    2.739159] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    2.739427] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
> bus number 2
> [    2.739718] usb usb2: New USB device found, idVendor=1d6b,
> idProduct=0003
> [    2.739922] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.740131] usb usb2: Product: xHCI Host Controller
> [    2.740376] usb usb2: Manufacturer: Linux 3.12.15-rt25 xhci_hcd
> [    2.740574] usb usb2: SerialNumber: 0000:00:14.0
> [    2.740853] hub 2-0:1.0: USB hub found
> [    2.741071] hub 2-0:1.0: 4 ports detected
> [    2.751082] tg3 0000:0a:00.0 eth0: Tigon3 [partno(BCM957762) rev
> 57766000] (PCI Express) MAC address a8:20:66:2d:5d:b4
> [    2.751224] tg3 0000:0a:00.0 eth0: attached PHY is 57765
> (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
> [    2.751327] tg3 0000:0a:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0]
> ASF[0] TSOcap[1]
> [    2.751425] tg3 0000:0a:00.0 eth0: dma_rwctrl[00000001]
> dma_mask[64-bit]
> [    2.762338] ehci-pci 0000:00:1a.0: setting latency timer to 64
> [    2.762347] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    2.762463] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
> bus number 3
> [    2.762590] ehci-pci 0000:00:1a.0: debug port 2
> [    2.766628] ehci-pci 0000:00:1a.0: cache line size of 64 is not
> supported
> [    2.766673] ehci-pci 0000:00:1a.0: irq 23, io mem 0xc1c16c00
> [    2.772188] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    2.772338] usb usb3: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    2.772434] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.772530] usb usb3: Product: EHCI Host Controller
> [    2.772613] usb usb3: Manufacturer: Linux 3.12.15-rt25 ehci_hcd
> [    2.772697] usb usb3: SerialNumber: 0000:00:1a.0
> [    2.772939] hub 3-0:1.0: USB hub found
> [    2.773060] hub 3-0:1.0: 2 ports detected
> [    2.773324] ehci-pci 0000:00:1d.0: setting latency timer to 64
> [    2.773331] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    2.773428] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
> bus number 4
> [    2.773535] ehci-pci 0000:00:1d.0: debug port 2
> [    2.777519] ehci-pci 0000:00:1d.0: cache line size of 64 is not
> supported
> [    2.777700] ehci-pci 0000:00:1d.0: irq 22, io mem 0xc1c16800
> [    2.783303] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    2.783454] usb usb4: New USB device found, idVendor=1d6b,
> idProduct=0002
> [    2.783565] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.783663] usb usb4: Product: EHCI Host Controller
> [    2.783746] usb usb4: Manufacturer: Linux 3.12.15-rt25 ehci_hcd
> [    2.783830] usb usb4: SerialNumber: 0000:00:1d.0
> [    2.784115] hub 4-0:1.0: USB hub found
> [    2.784250] hub 4-0:1.0: 2 ports detected
> [    3.037228] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    3.037842] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [    3.038135] ata1.00: ATA-8: APPLE SSD SD512E, 1027AP, max UDMA/133
> [    3.038264] ata1.00: 977105060 sectors, multi 1: LBA48 NCQ (depth
> 31/32), AA
> [    3.039058] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [    3.039412] ata1.00: configured for UDMA/133
> [    3.039670] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SD512E
> 1027 PQ: 0 ANSI: 5
> [    3.049242] sd 0:0:0:0: [sda] 977105060 512-byte logical blocks: (500
> GB/465 GiB)
> [    3.049370] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    3.049483] sd 0:0:0:0: [sda] Write Protect is off
> [    3.049575] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.049585] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.053303]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
> [    3.053786] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.054872] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.075114] usb 3-1: new high-speed USB device number 2 using
> ehci-pci
> [    3.125007] EXT4-fs (sda6): mounted filesystem with ordered data
> mode. Opts: (null)
> [    3.190464] usb 3-1: New USB device found, idVendor=8087,
> idProduct=0024
> [    3.190582] usb 3-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    3.190993] hub 3-1:1.0: USB hub found
> [    3.191189] hub 3-1:1.0: 6 ports detected
> [    3.294027] usb 4-1: new high-speed USB device number 2 using
> ehci-pci
> [    3.360115] systemd-udevd[445]: starting version 204
> [    3.408540] usb 4-1: New USB device found, idVendor=8087,
> idProduct=0024
> [    3.408664] usb 4-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    3.409076] hub 4-1:1.0: USB hub found
> [    3.409334] hub 4-1:1.0: 8 ports detected
> [    3.434411] input: Lid Switch
> as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    3.434603] ACPI: Lid Switch [LID0]
> [    3.438555] input: Power Button
> as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    3.438705] ACPI: Power Button [PWRB]
> [    3.442617] input: Sleep Button
> as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    3.442783] ACPI: Sleep Button [SLPB]
> [    3.446044] input: Power Button
> as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [    3.446090] ACPI: AC Adapter [ADP1] (on-line)
> [    3.446333] ACPI: Power Button [PWRF]
> [    3.448274] ACPI: Requesting acpi_cpufreq
> [    3.450019] mei_me 0000:00:16.0: setting latency timer to 64
> [    3.450062] mei_me 0000:00:16.0: irq 53 for MSI/MSI-X
> [    3.473644] [Firmware Bug]: ACPI(GFX0) defines _DOD but not _DOS
> [    3.473914] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes
> post: no)
> [    3.479195] input: Video Bus
> as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/LNXVIDEO:00/input/input4
> [    3.481963] [drm] Initialized drm 1.1.0 20060810
> [    3.484089] usb 3-1.1: new high-speed USB device number 3 using
> ehci-pci
> [    3.499088] wmi: Mapper loaded
> [    3.515034] Switched to clocksource tsc
> [    3.515567] ACPI Warning: \_SB_.PCI0.P0P2.GFX0._DSM: Argument #4 type
> mismatch - Found [Integer], ACPI requires [Package]
> (20130725/nsarguments-95)
> [    3.515832] ACPI Warning: \_SB_.PCI0.P0P2.GFX0._DSM: Argument #4 type
> mismatch - Found [Buffer], ACPI requires [Package]
> (20130725/nsarguments-95)
> [    3.517964] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e7150a2
> [    3.518052] nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
> [    3.518136] nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
> [    3.518549] snd_hda_intel 0000:00:1b.0: irq 54 for MSI/MSI-X
> [    3.520072] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for
> image...
> [    3.520168] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> [    3.520250] nouveau  [   VBIOS][0000:01:00.0] checking PROM for
> image...
> [    3.520370] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> [    3.520453] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for
> image...
> [    3.520538] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> [    3.520622] nouveau  [   VBIOS][0000:01:00.0] checking PCIROM for
> image...
> [    3.520768] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
> [    3.520857] nouveau  [   VBIOS][0000:01:00.0] using image from PCIROM
> [    3.521021] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
> [    3.521114] nouveau  [   VBIOS][0000:01:00.0] version 80.07.26.04.01
> [    3.529417] apple_gmux: gmux device not present
> [    3.530363] nouveau E[   VBIOS][0000:01:00.0] 0x86ba[ ]: unknown
> opcode 0xdb
> [    3.530662] nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
> [    3.530777] nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
> [    3.530895] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
> [    3.546002] input: HDA Intel PCH Headphone
> as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
> [    3.560079] nouveau  [  PTHERM][0000:01:00.0] FAN control: none /
> external
> [    3.560211] nouveau  [  PTHERM][0000:01:00.0] fan management:
> disabled
> [    3.560330] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
> [    3.561274] bcma: bus0: Found chip with id 0x4331, rev 0x02 and
> package 0x09
> [    3.561408] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id
> 0x800, rev 0x25, class 0x0)
> [    3.571549] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id
> 0x812, rev 0x1D, class 0x0)
> [    3.571714] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820,
> rev 0x13, class 0x0)
> [    3.593119] usb 3-1.1: New USB device found, idVendor=05ac,
> idProduct=8510
> [    3.600244] usb 3-1.1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    3.601298] [TTM] Zone  kernel: Available graphics memory: 8171732
> kiB
> [    3.601299] [TTM] Zone   dma32: Available graphics memory: 2097152
> kiB
> [    3.601300] [TTM] Initializing pool allocator
> [    3.601403] [TTM] Initializing DMA pool allocator
> [    3.601564] nouveau  [     DRM] VRAM: 1024 MiB
> [    3.601565] nouveau  [     DRM] GART: 1048576 MiB
> [    3.601568] nouveau  [     DRM] TMDS table version 2.0
> [    3.601570] nouveau  [     DRM] DCB version 4.0
> [    3.601578] nouveau  [     DRM] DCB outp 00: 048101b6 0f230010
> [    3.601579] nouveau  [     DRM] DCB outp 01: 018212d6 0f220020
> [    3.601580] nouveau  [     DRM] DCB outp 02: 01021212 00020020
> [    3.601581] nouveau  [     DRM] DCB outp 03: 088324c6 0f220010
> [    3.601582] nouveau  [     DRM] DCB outp 04: 08032402 00020010
> [    3.601583] nouveau  [     DRM] DCB outp 05: 02843862 00020010
> [    3.601585] nouveau  [     DRM] DCB conn 00: 00020047
> [    3.601586] nouveau  [     DRM] DCB conn 01: 02208146
> [    3.601596] nouveau  [     DRM] DCB conn 02: 01104246
> [    3.601597] nouveau  [     DRM] DCB conn 03: 00410361
> [    3.614162] ACPI Warning: 0x0000000000000428-0x000000000000042f
> SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
> [    3.614163] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [    3.614169] ACPI Warning: 0x0000000000000530-0x000000000000053f
> SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
> [    3.614169] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [    3.614170] ACPI Warning: 0x0000000000000500-0x000000000000052f
> SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
> [    3.614171] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [    3.614171] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    3.614409] ACPI Warning: 0x000000000000efa0-0x000000000000efbf
> SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1
> (20130725/utaddress-251)
> [    3.614409] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [    3.617368] usb 3-1.1: Product: FaceTime HD Camera (Built-in)
> [    3.617481] usb 3-1.1: Manufacturer: Apple Inc.
> [    3.617594] usb 3-1.1: SerialNumber: DJHD1UZ0UPDNYGB0
> [    3.618049] [drm] Supports vblank timestamp caching Rev 1
> (10.10.2010).
> [    3.618170] [drm] No driver support for vblank timestamp query.
> [    3.618308] nouveau W[     DRM] voltage table 0x5a unknown
> [    3.618422] nouveau  [     DRM] 0 available performance level(s)
> [    3.618533] nouveau  [     DRM] c:
> [    3.624771] bcma: bus0: Bus registered
> [    3.629422] nouveau  [     DRM] MM: using COPY for buffer copies
> [    3.639611] input: PC Speaker
> as /devices/platform/pcspkr/input/input6
> [    3.670978] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
> [    3.676033] nouveau  [     DRM] allocated 2880x1800 fb: 0x80000, bo
> ffff8800368af400
> [    3.676989] fbcon: nouveaufb (fb0) is primary device
> [    3.683034] alg: No test for crc32 (crc32-pclmul)
> [    3.701017] usb 4-1.8: new high-speed USB device number 3 using
> ehci-pci
> [    3.771287] applesmc: key=493 fan=2 temp=44 index=43 acc=0 lux=2
> kbd=1
> [    3.786268] usb 4-1.8: New USB device found, idVendor=0424,
> idProduct=2512
> [    3.786269] usb 4-1.8: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    3.786516] hub 4-1.8:1.0: USB hub found
> [    3.786603] hub 4-1.8:1.0: 2 ports detected
> [    3.996887] ACPI: Battery Slot [BAT0] (battery present)
> [    4.011869] iTCO_vendor_support: vendor-support=0
> [    4.013116] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [    4.013195] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled
> by hardware/BIOS
> [    4.032143] cfg80211: Calling CRDA to update world regulatory domain
> [    4.048619] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
> [    4.049039] b43-phy0: Found PHY: Analog 9, Type 7 (HT), Revision 1
> [    4.050015] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [    4.054698] ieee80211 phy0: Selected rate control algorithm
> 'minstrel_ht'
> [    4.057389] media: Linux media interface: v0.10
> [    4.059931] usb 4-1.8.1: new full-speed USB device number 4 using
> ehci-pci
> [    4.060173] Linux video capture interface: v2.00
> [    4.063844] cfg80211: World regulatory domain updated:
> [    4.063845] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [    4.063846] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (N/A, 2000 mBm)
> [    4.063847] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
> (N/A, 2000 mBm)
> [    4.063848] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
> (N/A, 2000 mBm)
> [    4.063848] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
> (N/A, 2000 mBm)
> [    4.063849] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
> (N/A, 2000 mBm)
> [    4.063849] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz),
> (N/A, 0 mBm)
> [    4.065282] uvcvideo: Found UVC 1.00 device FaceTime HD Camera
> (Built-in) (05ac:8510)
> [    4.076216] input: FaceTime HD Camera (Built-in)
> as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.1/3-1.1:1.0/input/input7
> [    4.076259] usbcore: registered new interface driver uvcvideo
> [    4.076259] USB Video Class driver (1.1.1)
> [    4.146867] usb 4-1.8.1: New USB device found, idVendor=0a5c,
> idProduct=4500
> [    4.146868] usb 4-1.8.1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    4.146869] usb 4-1.8.1: Product: BRCM20702 Hub
> [    4.146869] usb 4-1.8.1: Manufacturer: Apple Inc.
> [    4.147207] hub 4-1.8.1:1.0: USB hub found
> [    4.147364] hub 4-1.8.1:1.0: 3 ports detected
> [    4.149220] Console: switching to colour frame buffer device 360x112
> [    4.156111] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
> [    4.156112] nouveau 0000:01:00.0: registered panic notifier
> [    4.156123] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0
> on minor 0
> [    4.156218] hda_intel: Disabling MSI
> [    4.156229] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio
> client
> [    4.220960] usb 4-1.8.2: new full-speed USB device number 5 using
> ehci-pci
> [    4.314322] usb 4-1.8.2: New USB device found, idVendor=05ac,
> idProduct=0263
> [    4.314340] usb 4-1.8.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    4.314349] usb 4-1.8.2: Product: Apple Internal Keyboard / Trackpad
> [    4.314354] usb 4-1.8.2: Manufacturer: Apple Inc.
> [    4.323255] input: HDA NVidia HDMI/DP,pcm=8
> as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input10
> [    4.323840] input: HDA NVidia HDMI/DP,pcm=7
> as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input9
> [    4.324414] input: HDA NVidia HDMI/DP,pcm=3
> as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input8
> [    4.332580] hidraw: raw HID events driver (C) Jiri Kosina
> [    4.335674] input: bcm5974
> as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.2/4-1.8.2:1.2/input/input11
> [    4.336708] usbcore: registered new interface driver bcm5974
> [    4.341214] usbcore: registered new interface driver usbhid
> [    4.341224] usbhid: USB HID core driver
> [    4.353735] input: Apple Inc. Apple Internal Keyboard / Trackpad
> as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.2/4-1.8.2:1.0/input/input12
> [    4.354004] apple 0003:05AC:0263.0001: input,hidraw0: USB HID v1.11
> Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on
> usb-0000:00:1d.0-1.8.2/input0
> [    4.409781] usb 4-1.8.1.1: new full-speed USB device number 6 using
> ehci-pci
> [    4.459550] apple 0003:05AC:0263.0002: hidraw1: USB HID v1.11 Device
> [Apple Inc. Apple Internal Keyboard / Trackpad] on
> usb-0000:00:1d.0-1.8.2/input1
> [    4.486811] usb 4-1.8.1.1: New USB device found, idVendor=05ac,
> idProduct=820a
> [    4.486825] usb 4-1.8.1.1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    4.550779] usb 4-1.8.1.2: new full-speed USB device number 7 using
> ehci-pci
> [    4.609781] EXT4-fs (sda6): re-mounted. Opts: (null)
> [    4.628114] usb 4-1.8.1.2: New USB device found, idVendor=05ac,
> idProduct=820b
> [    4.628126] usb 4-1.8.1.2: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    4.632399] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro
> [    4.691719] usb 4-1.8.1.3: new full-speed USB device number 8 using
> ehci-pci
> [    4.744687] lp: driver loaded but no devices found
> [    4.748957] ppdev: user-space parallel port driver
> [    4.759706] fuse init (API version 7.22)
> [    4.769665] usb 4-1.8.1.3: New USB device found, idVendor=05ac,
> idProduct=8286
> [    4.770240] usb 4-1.8.1.3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    4.770241] usb 4-1.8.1.3: Product: Bluetooth USB Host Controller
> [    4.770242] usb 4-1.8.1.3: Manufacturer: Apple Inc.
> [    4.792971] input: HID 05ac:820a
> as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.1/4-1.8.1.1/4-1.8.1.1:1.0/input/input13
> [    4.793869] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID
> v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1d.0-1.8.1.1/input0
> [    4.794797] input: HID 05ac:820b
> as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.1/4-1.8.1.2/4-1.8.1.2:1.0/input/input14
> [    4.795864] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID
> v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1d.0-1.8.1.2/input0
> [    4.798149] Bluetooth: Core ver 2.16
> [    4.798786] NET: Registered protocol family 31
> [    4.799855] Bluetooth: HCI device and connection manager initialized
> [    4.800958] Bluetooth: HCI socket layer initialized
> [    4.802054] Bluetooth: L2CAP socket layer initialized
> [    4.803145] Bluetooth: SCO socket layer initialized
> [    4.806824] usbcore: registered new interface driver btusb
> [    4.829661] usb 4-1.8.1.1: USB disconnect, device number 6
> [    4.979433] RPC: Registered named UNIX socket transport module.
> [    4.980042] RPC: Registered udp transport module.
> [    4.981137] RPC: Registered tcp transport module.
> [    4.982230] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    4.986064] FS-Cache: Loaded
> [    4.992001] FS-Cache: Netfs 'nfs' registered for caching
> [    4.998262] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    5.030871] usb 4-1.8.1.2: USB disconnect, device number 7
> [    5.398028] Bluetooth: RFCOMM TTY layer initialized
> [    5.398640] Bluetooth: RFCOMM socket layer initialized
> [    5.399687] Bluetooth: RFCOMM ver 1.11
> [    5.401942] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    5.402519] Bluetooth: BNEP filters: protocol multicast
> [    5.403567] Bluetooth: BNEP socket layer initialized

Now, I know what this is good for!

  if(audio_loop->play_recall_ref == 0 &&
     audio_loop->play_channel_ref == 0 &&
     audio_loop->play_audio_ref == 0 &&
     audio_loop->play_notation_ref == 0){
    static const struct timespec req = {
      0,
      250000000,
    };

    if((AGS_THREAD_RUNNING &
(AGS_THREAD(audio_loop->devout_thread)->flags)) != 0){
      ags_thread_stop(AGS_THREAD(audio_loop->devout_thread));
    }

    nanosleep(&req, NULL);
  }

