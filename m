Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaGOQMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:12:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaGOQMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:12:30 -0400
Date: Tue, 15 Jul 2014 12:10:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 00/16] Enable support of IOAPIC hotplug on x86
 platforms
Message-ID: <20140715161035.GA8097@laptop.dumpdata.com>
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
 <20140714172642.GA12920@laptop.dumpdata.com>
 <20140714194133.GA22857@laptop.dumpdata.com>
 <53C54876.5090606@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53C54876.5090606@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 11:27:50PM +0800, Jiang Liu wrote:
> Hi Konrad,
> 	Thanks for testing the patch set! After analyzing the log
> files, I feel something is wrong with the Radeon driver. With good
> configuration, IRQ18 is shared by OHCI controllers and Radeon GPU
> card. With bad configuration, only OHCI controllers are bound to
> IRQ18. Radeon GPU card may have been bound to another wrong IRQ,
> which then causes the interrupt storm.
> 	But I have no hardware available to verify the hypothesis,
> so could you please help to apply the attached patch and run the
> test again?

Here is the serial log:

Trying 192.168.102.15...
Connected to maxsrv2.
Escape character is '^]'.
Probing EDD (edd=off to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc5upstream-01669-g4f5f437 (konrad@build-external.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Tue Jul 15 12:43:50 EDT 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfeaffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfeb0000-0x00000000cfebdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfebe000-0x00000000cfedffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfee0000-0x00000000cfefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] Early serial console at I/O port 0xe400 (options '115200n8')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080015  04/01/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000ff]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xf   0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
[    0.000000]   mpc: e5e70-e5ffc
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[ m 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37800000-0x379fffff]
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x377fffff]
[    0.000000]  [mem 0x34000000-0x377fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x01a3b000, 0x01a3bfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7aee0000-0x7fffefff]
[    0.000000] Allocated new RAMDISK: [mem 0x32adf000-0x37bfdb9a]
[    0.000000] Move RAMDISK from [mem 0x7aee0000-0x7fffeb9a] to [mem 0x32adf000-0x37bfdb9a]
[    0.000000] ACPI: Early table ch.000000] ACPI: RSDP 0x000FB100 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0xCFEB0000 000040 (v01 040110 RSDT1316 20100401 MSFT 00000097)
[    0.000000] ACPI: FACP 0xCFEB0200 000084 (v01 040110 FACP1316 20100401 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140424/tbfadt-649)
[    0.000000] ACPI: DSDT 0xCFEB0450 00A65F (v01 1AAAA  1AAAA000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0xCFEBE000 000040
[    0.000000] ACPI: APIC 0xCFEB0390 00007C (v01 040110 APIC1316 20100401 MSFT 00000097)
[    0.000000] ACPI: MCFG 0xCFEB0410 00003C (v01 040110 OEMMCFG  20100401 MSFT 00000097)
[    0.000000] ACPI: OEMB 0xCFEBE040 000072 (v01 040110 OEMB1316 20100401 MSFT 00000097)
[    0.000000] ACPI: SRAT 0xCFEBAAB0 0000E8 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 0xCFEBABA0 000038 (v01 040110 OEMHPET  20100401 MSFT 00000097)
[    0.000000] ACPI: SSDT 0xCFEBABE0 00088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 3716MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x01a3c000, 0x01a3cfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcfeaffff]
[    0.000000]   node   0: [mem 0x00000000-0x1fffffff]
[    0.000000] On node 0 totalpages: 982606
[    0.000000] free_area_init_node: node 0, pgdat c1849240, node_mem_map f06df020
[    0.000000]   DMA zone: 32 pages used for   0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7433 pages used for memmap
[    0.000000]   HighMem zone: 754354 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address ic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e6000-0x000fffff]
[    0.000000] e820: [mem 0xcff00000-0xff6fffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f0679000 s35136 r0 d22208 u57344
[    0.000000] pcpu-alloc: s35136 r0 d22208 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 980822
[    0.000000] Kernel command line: initrd=initramfs.cpio.gz apic=debug initcall_debug loglevel=10 nofb selinux=0 console=uart8250,io,0xe400,115200n8 BOOT_IMAGE=vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00120000)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 3798728K/3930424K available (6268K kernel code, 434K rwdata, 1852K rodata, 940K init, 872K bss, 131696K reserved, 3017416K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc185e000 - 0xc1949000   ( 940 kB)
[    0.000000]       .data : 0xc161f627 - 0xc185cbc0   (2293 kB)
[    0.000000]       .text : 0xc1000000 - 0xc161f627   (6269 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
[    0.000000] NR_IRQS:2304 nr_irqs:472 0
[    0.000000] CPU 0 irqstacks, hard=f0008000 soft=f000a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3000.004 MHz processor
[    0.000025] Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.00 BogoMIPS (lpj=3000004)
[    0.011168] pid_max: default: 32768 minimum: 301
[    0.016050] ACPI: Core revision 20140424
[    0.089516] ACPI: All ACPI Tables successfully acquired
[    0.101334] Security Framework initialized
[    0.105628] SELinux:  Disabled at boot.
[    0.109831] Mount-cache hash tableytes)
[    0.116773] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.125318] Initializing cgroup subsys freezer
[    0.130044] CPU: Physical Processor ID: 0
[    0.134250] CPU: Processor Core ID: 0
[    0.138095] mce: CPU supports 6 MCE banks
[    0.142309] LVT offset 0 assigned for vector 0xf9
[    0.147252] process: using AMD E400 aware idle routine
[    0.152644] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.152644] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.152644] tlb_flushall_shift: 6
[    0.168749] Freeing SMP alternatives memory: 28K (c1949000 - c1950000)
[    0.176609] Getting VERSION: 80050010
[    0.180448] Getting VERSION: 80050010
[    0.184291] Getting ID: 0
[    0.187041] Getting ID: f000000
[    0.190335] Getting LVT0: 700
[    0.193442] Getting LVT1: 400
[    0.196547] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.202216] enabled ExtINT on CPU#0
[    0.206070] ESR value before enabling vector: 0x00000004  after: 0x00000000
[    0.213370] ENABLING IO-APIC IRQs
[    0.216850] init IO_APIC IRQs
[    0.219964]  apic 4 pin 0 not connected
[    0.223993] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.232302] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.240603] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.248906] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.257202] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.265501] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.273806] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.282112] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.290422] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:1)
[    0.298729] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.307215] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.315696] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.324180] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.332664] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.341152] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.349642]  apic 4 pin 16 not connected
[    0.353750]  apic 4 pin 17 not connected
[    0.357859]  apic 4 pin 18 not connected
[    0.361958]  apic 4 pin 19 not connected
[    0.366066]  apic 4 pin 20 not connected
[    0.370173]  apic 4 pin 21 not connected
[    0.374280]  apic 4 pin 22 not connected
[    0.378385]  apic 4 pin 23 not connected
[    0.382626] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.398914] smpboot: CPU0: AMD Phenom(tm) II X4 940 Processor (fam: 10, model: 04, stepping: 02)
[    0.408154] Using local [    0.517705] ... lapic delta = 1250027
[    0.521540] ... PM-Timer delta = 357950
[    0.525554] ... PM-Timer result ok
[     0.535784] ..... calibration result: 200004
[    0.540249] ..... CPU clock speed is 3000.0066 MHz.
[    0.545361] ..... host bus clock speed is 200.0004 MHz.
[    0.550849] calling  xen_init_spinlocks_jump+0x0/0x23 @ 1
[    0.556509] initcall xen_init_spinlocks_jump+0x0/0x23 returned 0 after 0 usecs
[    0.564079] calling  set_real_mode_permissions+0x0/0x5d @ 1
[    0.569928] initcall set_real_mode_permissions+0x0/0x5d returned 0 after 0 usecs
[    0.577690] calling  trace_init_perf_perm_irq_work_exit+0x0/0x11 @ 1
[    0.584346] initcall trace_init_perf_perm_irq_work_exit+0x0/0x11 returned 0 after 0 usecs
[    0.592931] calling  trace_init_flags_sys_exit+0x0/0xe @ 1
[    0.598674] initcall trace_init_flags_sys_exit+0x0/0xe returned 0 after 0 usecs
[    0.606344] calling  trace_init_flags_sys_enter+0x0/0xe @ 1
[    0.612180] initcall trace_init_flags_sys_enter+0x0/0xe returned 0 after 0 usecs
[    0.619944] calling  init_hw_perf_events+0x0/0x52b @ 1
[    0.625326] Performance Events: AMD PMU driver.
[    0.630086] ... version:                0
[    0.634284] ... bit width:              48
[    0.638575] ... generic registers:      4
[    0.642781] ... value mask:             0000ffffffffffff
[    0.648352] ... max period:             00007fffffffffff
[    0.653916] ... fixed-purpose events:   0
[    0.658112] ... event mask:             000000000000000f
[    0.663713] initcall init_hw_perf_events+0x0/0x52b returned 0 after 8789 usecs
[    0.671282] calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1
[    0.677948] initcall register_trigger_all_cpu_backtrace+0x0/0x13 returned 0 after 0 usecs
[    0.686517] calling  kvm_spinlock_init_jump+0x0/0x37 @ 1
[    0.692086] initcall kvm_spinlock_init_jump+0x0/0x37 returned 0 after 0 usecs
[    0.699562] calling  spawn_ksoftirqd+0x0/0x23 @ 1
[    0.704519] initcall spawn_ksoftirqd+0x0/0x23 returned 0 after 0 usecs
[    0.711368] calling  init_workqueues+0x0/0x3e6 @ 1
[    0.716785] initcall init_workqueues+0x0/0x3e6 returned 0 after 976 usecs
[    0.723900] calling  migration_init+0x0/0x5b @ 1
[    0.728737] initcall migration_init+0x0/0x5b returned 0 after 0 usecs
[    0.735487] calling  check_cpu_stall_init+0x0/0x16 @ 1
[    0.740871] initcall check_cpu_stall_init+0x0/0x16 returned 0 after 0 usecs
[    0.748167] calling  rcu_scheduler_really_started+0x0/0x11 @ 1
[    0.754278] initcall rcu_scheduler_really_started+0x0/0x11 returned 0 after 0 usecs
[    0.762318] calling  rcu_spawn_gp_kthread+0x0/0x87 @ 1
[    0.767752] initcall rcu_spawn_gp_kthread+0x0/0x87 returned 0 after 0 usecs
[    0.775055] calling  cpu_stop_init+0x0/0x5d @ 1
[    0.779841] initcall cpu_stop_init+0x0/0x5d returned 0 after 0 usecs
[    0.786503] calling  relay_init+0x0/0x11 @ 1
[    0.790977] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.797357] calling  tracer_alloc_buffers+0x0/0x213 @ 1
[    0.802929] initcall tracer_alloc_buffers+0x0/0x213 returned 0 after 0 usecs
[    0.810325] calling  init_events+0x0/0x5f @ 1
[    0.814887] initcall init_events+0x0/0x5f returned 0 after 0 usecs
[    0.821357] calling  init_trace_printk+0x0/0xf @ 1
[    0.826375] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.833318] calling  event_trace_memsetup+0x0/0x5a @ 1
[    0.838744] initcall event_trace_memsetup+0x0/0x5a returned 0 after 0 usecs
[    0.846050] calling  jump_label_init_module+0x0/0xf @ 1
[    0.851534] initcall jump_label_init_module+0x0/0xf returned 0 after 0 usecs
[    0.858930] calling  hashlib_init+0x0/0x11 @ 1
[    0.863586] initcall hashlib_init+0x0/0x11 returned 0 after 0 usecs
[    0.870163] calling  balloon_clear+0x0/0x3b @ 1
[    0.874910] initcall balloon_clear+0x0/0x3b returned 0 after 0 usecs
[    0.881577] calling  rand_initialize+0x0/0x30 @ 1
[    0.886539] initcall rand_initialize+0x0/0x30 returned 0 after 976 usecs
[    0.893569] calling  mce_amd_init+0x0/0x134 @ 1
[    0.898317] MCE: In-kernel MCE decoding enabled.
[    0.903160] initcall mce_amd_init+0x0/0x134 returned 0 after 976 usecs
[    0.910185] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.920336] CPU 1 irqstacks, hard=f02c2000 soft=ef820000
[    0.925902] x86: Booting SMP configuration:
[    0.930286] .... node  #0, CPUs:      #1
[    0.944867] Initializing CPU#1
[    0.945215] masked ExtINT on CPU#1
[    0.947392] process: System has AMD C1E enabled
[    0.947931] CPU 2 irqstacks, hard=f028a000 soft=f028c000
[    0.958480]  #2
[    0.958481] Initializing CPU#2
[    0.958929] masked ExtINT on CPU#2
[    0.961117] process: Switch to broadcast mode on CPU2
[    0.961653] CPU 3 irqstacks, hard=f02be000 soft=f0200000
[    0.972203]  #3
[    0.972203] Initializing CPU#3
[    0.972652] masked ExtINT on CPU#3
[    0.974786] x86: Booted up 1 node, 4 CPUs
[    0.974788] smpboot: Total of 4 processors activated (24000.03 BogoMIPS)
[    0.974831] process: Switch to broadcast mode on CPU3
[    1.009163] process: Switch to broadcast mode on CPU1
[    1.019449] process: Switch to broadcast mode on CPU0
[    1.025075] devtmpfs: initialized
[    1.029491] calling  ipc_ns_i initcall ipc_ns_init+0x0/0x11 returned 0 after 0 usecs
[    1.040551] calling  init_mmap_min_addr+0x0/0x20 @ 1
[    1.045760] initcall init_mmap_min_addr+0x0/0x20 returned 0 after 0 usecs
[    1.052889] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    1.059852] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    1.068715] calling  net_ns_init+0x0/0x100 @ 1
[    1.073512] initcall net_ns_init+0x0/0x100 returned 0 after 0 usecs
[    1.080136] calling  e820_mark_nvs_memory+0x0/0x4e @ 1
[    1.085528] PM: Registering ACPI NVS region [mem 0xcfebe000-0xcfedffff] (139264 bytes)
[    1.093922] initcall e820_mark_nvs_memory+0x0/0x4e returned 0 after 976 usecs
[    1.101420] calling  cpufreq_tsc+0x0/0x26 @ 1
[    1.105997] initcall cpufreq_tsc+0x0/0x26 returned 0 after 0 usecs
[    1.112500] calling  reboot_init+0x0/0x1a @ 1
[    1.117084] initcall reboot_init+0x0/0x1a returned 0 after 0 usecs
[    1.123568] calling  init_lapic_sysfs+0x0/0x1b @ 1
[    1.128594] initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usecs
[    1.135546] calling  cpu_hotplug_pm_sync_init+0x0/0x29 @ 1
[    1.141309] initcall cpu_hotplug_pm_sync_init+0x0/0x29 returned 0 after 0 usecs
[    1.148978] calling  alloc_frozen_cpus+0x0/0x7 @ 1
[    1.154003] initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usecs
[    1.160950] calling  wq_sysfs_init+0x0/0x11 @ 1
[    1.165839] initcall wq_sysfs_init+0x0/0x11 returned 0 after 0 usecs
[    1.165945] kworker/u12:0 (30) used greatest stack depth: 6980 bytes left
[    1.179624] calling  ksysfs_init+0x0/0x74 @ 1
[    1.184276] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
[    1.190771] calling  pm_init+0x0/0x45 @ 1
[    1.195046] initcall pm_init+0x0/0x45 returned 0 after 0 usecs
[    1.201158] calling  pm_disk_init+0x0/0x14 @ 1
[    1.205847] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    1.212431] calling  swsusp_header_init+0x0/0x30 @ 1
[    1.217634] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    1.224766] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    1.230441] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    1.238025] calling  cgroup_wq_init+0x0/0x7c @ 1
[    1.242925] initcall cgroup_wq_init+0x0/0x7c returned 0 after 0 usecs
[    1.249687] calling  event_trace_enable+0x0/0x155 @ 1
[    1.255896] initcall event_trace_enable+0x0/0x155 returned 0 after 976 usecs
[    1.263296] calling  init_zero_pfn+0x0/0x14 @ 1
[    1.268045] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
[    1.274718] calling  fsnotify_init+0x0/0x24 @ 1
[    1.279493] initcall fsnotify_init+0x0/0x24 returned 0 after 0 usecs
[    1.286167] calling  filelock_init+0x0/0x74 @ 1
[    1.290959] initcall filelock_init+0x0/0x74 returned 0 after 0 usecs
[    1.297639] calling  init_misc_binfmt+0x0/0x28 @ 1
[    1.302679] initcall init_misc_binfmt+0x0/0x28 returned 0 after 0 usecs
[    1.309624] calling  init_script_binfmt+0x0/0x13 @ 1
[    1.314842] initcall init_script_binfmt+0x0/0x13 returned 0 after 0 usecs
[    1.321980] calling  init_elf_binfmt+0x0/0x13 @ 1
[    1.326923] initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs
[    1.333784] calling  debugfs_init+0x0/0x4a @ 1
[    1.338459] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    1.345042] calling  securityfs_init+0x0/0x41 @ 1
[    1.350001] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    1.356858] calling  prandom_init+0x0/0xaa @ 1
[    1.361531] initcall prandom_init+0x0/0xaa returned 0 after 0 usecs
[    1.368115] calling  virtio_init+0x0/0x30 @ 1
[    1.372768] initcall virtio_init+0x0/0x30 returned 0 after 976 usecs
[    1.379453] calling  early_resume_init+0x0/0x1a0 @ 1
[    1.384669] RTC time: 16:04:47, date: 07/15/14
[    1.389335] initcall early_resume_init+0x0/0x1a0 returned 0 after 976 usecs
[    1.396636] calling  cpufreq_core_init+0x0/0x29 @ 1
[    1.401761] initcall cpufreq_core_init+0x0/0x29 returned 0 after 0 usecs
[    1.408801] calling  cpuidle_init+0x0/0x36 @ 1
[    1.413501] initcall cpuidle_init+0x0/0x36 returned 0 after 0 usecs
[    1.420099] calling  bsp_pm_check_init+0x0/0x11 @ 1
[    1.425213] initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 usecs
[    1.432261] calling  sock_init+0x0/0x89 @ 1
[    1.436915] initcall sock_init+0x0/0x89 returned 0 after 976 usecs
[    1.443400] calling  net_inuse_init+0x0/0x24 @ 1
[    1.448277] initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs
[    1.455033] calling  netpoll_init+0x0/0x2e @ 1
[    1.459705] initcall netpoll_init+0x0/0x2e returned 0 after 0 usecs
[    1.466291] calling  netlink_proto_init+0x0/0x1a7 @ 1
[    1.471665] NET: Registered protocol family 16
[    1.476362] initcall netlink_proto_init+0x0/0x1a7 returned 0 after 1953 usecs
[    1.483855] calling  __gnttab_init+0x0/0x30 @ 1
[    1.488604] initcall __gnttab_init+0x0/0x30 returned -19 after 0 usecs
[    1.495489] calling  bdi_class_init+0x0/0x40 @ 1
[    1.500489] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.507256] calling  mm_sysfs_init+0x0/0x22 @ 1
[    1.512019] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
[    1.518694] calling  kobject_uevent_init+0x0/0xf @ 1
[    1.523919] initcall kobject_uevent_init+0x0/0xf returned 0 after 0 usecs
[    1.531046] calling  pcibus_class_init+0x0/0x14 @ 1
[    1.536206] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    1.543245] calling  pci_driver_init+0x0/0xf @ 1
[    1.548180] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    1.554946] calling  backlight_class_init+0x0/0x92 @ 1
[    1.560383] initcall backlight_class_init+0x0/0x92 returned 0 after 0 usecs
[    1.567701] calling  xenbus_init+0x0/0x24f @ 1
[    1.572364] initcall xenbus_init+0x0/0x24f returned -19 after 0 usecs
[    1.579136] calling  tty_class_init+0x0/0x2f @ 1
[    1.584015] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
[    1.590779] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    1.596323] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    1.603634] calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
[    1.609673] initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 after 0 usecs
[    1.617624] calling  i2c_init+0x0/0x57 @ 1
[    1.622070] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs
[    1.628284] calling  lguest_devices_init+0x0/0x13f @ 1
[    1.633677] initcall lguest_devices_init+0x0/0x13f returned 0 after 0 usecs
[    1.640990] calling  init_ladder+0x0/0xf @ 1
[    1.645465] cpuidle: using governor ladder
[    1.649768] initcall init_ladder+0x0/0xf returned 0 after 976 usecs
[    1.656360] calling  init_menu+0x0/0xf @ 1
[    1.660658] cpuidle: using governor menu
[    1.664777] initcall init_menu+0x0/0xf returned 0 after 976 usecs
[    1.671173] calling  amd_postcore_init+0x0/0x131 @ 1
[    1.676397] node 0 link 0: io port [1000, ffffff]
[    1.681337] TOM: 00000000d0000000 aka 3328M
[    1.685718] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    1.691117] node 0 link 0: mmio [a0000, bffff]
[    1.695791] node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
[    1.703291] node 0 link 0: mmio [f0000000, fe6fffff]
[    1.708512] node 0 link 0: mmio [fe700000, fe8fffff]
[    1.713721] node 0 link 0: mmio [fe900000, ffefffff]
[    1.718936] TOM2: 0000000130000000 aka 4864M
[    1.723422] bus: [bus 00-07] on node 0 link 0
[    1.728004] bus: 00 [io  0x0000-0xffff]
[    1.732032] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.736786] bus: 00 [mem 0xd0000000-0xdfffffff]
[    1.741537] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.746281] bus: 00 [mem 0x130000000-0xfcffffffff]
[    1.751325] initcall amd_postcore_init+0x0/0x131 returned 0 after 16601 usecs
[    1.758852] calling  boot_params_ksysfs_init+0x0/0x22f @ 1
[    1.764642] initcall boot_params_ksysfs_init+0x0/0x22f returned 0 after 0 usecs
[    1.772318] calling  arch_kdebugfs_init+0x0/0x2a6 @ 1
[    1.777660] initcall arch_kdebugfs_init+0x0/0x2a6 returned 0 after 0 usecs
[    1.784876] calling  init_pit_clocksource+0x0/0x36 @ 1
[    1.790269] initcall init_pit_clocksource+0x0/0x36 returned 0 after 0 usecs
[    1.797577] calling  mtrr_if_init+0x0/0x56 @ 1
[    1.802245] initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
[    1.808823] calling  ffh_cstate_init+0x0/0x27 @ 1
[    1.813757] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usecs
[    1.820711] calling  kdump_buf_page_init+0x0/0x3a @ 1
[    1.826017] initcall kdump_buf_page_init+0x0/0x3a returned 0 after 0 usecs
[    1.833232] calling  activate_jump_labels+0x0/0x2d @ 1
[    1.838631] initcall activate_jump_labels+0x0/0x2d returned 0 after 0 usecs
[    1.845945] calling  acpi_pci_init+0x0/0x5b @ 1
[    1.850702] ACPI: bus type PCI registered
[    1.854912] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.861666] initcall acpi_pci_init+0x0/0x5b returned 0 after 1953 usecs
[    1.868619] calling  dma_bus_init+0x0/0xbb @ 1
[    1.873464] initcall dma_bus_init+0x0/0xbb returned 0 after 0 usecs
[    1.880053] calling  dma_channel_table_init+0x0/0xc4 @ 1
[    1.885756] initcall dma_channel_table_init+0x0/0xc4 returned 0 after 0 usecs
[    1.893255] calling  setup_vcpu_hotplug_event+0x0/0x1f @ 1
[    1.899017] initcall setup_vcpu_hotplug_event+0x0/0x1f returned -19 after 0 usecs
[    1.906877] calling  register_xen_pci_notifier+0x0/0x30 @ 1
[    1.912725] initcall register_xen_pci_notifier+0x0/0x30 returned 0 after 0 usecs
[    1.920482] calling  xen_pcpu_init+0x0/0xc8 @ 1
[    1.925240] initcall xen_pcpu_init+0x0/0xc8 returned -19 after 0 usecs
[    1.932097] calling  dmi_id_init+0x0/0x2a2 @ 1
[    1.937052] initcall dmi_id_init+0x0/0x2a2 returned 0 after 0 usecs
[    1.943643] calling  dca_init+0x0/0x21 @ 1
[    1.947937] dca service started, version 1.12.1
[    1.952729] initcall dca_init+0x0/0x21 returned 0 after 976 usecs
[    1.959141] calling  pci_arch_init+0x0/0x65 @ 1
[    1.963922] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.973688] PCI: not using MMCONFIG
[    1.978012] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
[    1.985667] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[    1.992325] PCI: Using configuration type 1 for base access
[    1.998161] PCI: Using configuration type 1 for extended access
[    2.004391] initcall pci_arch_init+0x0/0x65 returned 0 after 5859 usecs
[    2.011364] calling  topology_init+0x0/0x36 @ 1
[    2.016554] initcall topology_init+0x0/0x36 returned 0 after 0 usecs
[    2.023234] calling  mtrr_init_finialize+0x0/0x30 @ 1
[    2.028533] initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 usecs
[    2.035753] calling  uid_cache_init+0x0/0x7e @ 1
[    2.040636] initcall uid_cache_init+0x0/0x7e returned 0 after 0 usecs
[    2.047394] calling  param_sysfs_init+0x0/0x14c @ 1
[    2.064084] kworker/u12:0 (256) used greatest stack depth: 6856 bytes left
[    2.065136] initcall param_sysfs_init+0x0/0x14c returned 0 after 12695 usecs
[    2.065142] calling  proc_schedstat_init+0x0/0x27 @ 1
[    2.065150] initcall proc_schedstat_init+0x0/0x27 returned 0 after 0 usecs
[    2.065155] calling  pm_sysrq_init+0x0/0x16 @ 1
[    2.097236] initcall pm_sysrq_init+0x0/0x16 returned 0 after 31250 usecs
[    2.104289] calling  create_proc_profile+0x0/0x1e0 @ 1
[    2.109692] initcall create_proc_profile+0x0/0x1e0 returned 0 after 0 usecs
[    2.117004] calling  crash_save_vmcoreinfo_init+0x0/0x5ad @ 1
[    2.123062] initcall crash_save_vmcoreinfo_init+0x0/0x5ad returned 0 after 0 usecs
[    2.131000] calling  crash_notes_memory_init+0x0/0x35 @ 1
[    2.136680] initcall crash_notes_memory_init+0x0/0x35 returned 0 after 0 usecs
[    2.144260] calling  hung_task_init+0x0/0x56 @ 1
[    2.149164] initcall hung_task_init+0x0/0x56 returned 0 after 0 usecs
[    2.155934] calling  default_bdi_init+0x0/0x78 @ 1
[    2.161458] initcall default_bdi_init+0x0/0x78 returned 0 after 976 usecs
[    2.168585] calling  init_reserve_notifier+0x0/0x7 @ 1
[    2.173983] initcall init_reserve_notifier+0x0/0x7 returned 0 after 0 usecs
[    2.181291] calling  init_admin_reserve+0x0/0x30 @ 1
[    2.186493] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 usecs
[    2.193619] calling  init_user_reserve+0x0/0x30 @ 1
[    2.198734] initcall init_user_reserve+0x0/0x30 returned 0 after 0 usecs
[    2.205752] calling  mmu_notifier_init+0x0/0xf @ 1
[    2.210783] initcall mmu_notifier_init+0x0/0xf returned 0 after 0 usecs
[    2.217727] calling  hugepage_init+0x0/0x123 @ 1
[    2.222781] initcall hugepage_init+0x0/0x123 returned 0 after 0 usecs
[    2.229540] calling  crypto_wq_init+0x0/0x41 @ 1
[    2.234471] initcall crypto_wq_init+0x0/0x41 returned 0 after 0 usecs
[    2.241224] calling  cryptomgr_init+0x0/0xf @ 1
[    2.245967] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    2.252639] calling  init_bio+0x0/0xc5 @ 1
[    2.257315] initcall init_bio+0x0/0xc5 returned 0 after 0 usecs
[    2.263532] calling  blk_settings_init+0x0/0x21 @ 1
[    2.268643] initcall blk_settings_init+0x0/0x21 returned 0 after 0 usecs
[    2.275669] calling  blk_ioc_init+0x0/0x2f @ 1
[    2.280373] initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
[    2.286935] calling  blk_softirq_init+0x0/0x54 @ 1
[    2.291962] initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs
[    2.298901] calling  blk_iopoll_setup+0x0/0x54 @ 1
[    2.303924] initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs
[    2.310861] calling  blk_mq_init+0x0/0x16 @ 1
[    2.315426] initcall blk_mq_init+0x0/0x16 returned 0 after 0 usecs
[    2.321899] calling  genhd_device_init+0x0/0x6a @ 1
[    2.327190] initcall genhd_device_init+0x0/0x6a returned 0 after 0 usecs
[    2.334212] calling  blk_dev_integrity_init+0x0/0x2f @ 1
[    2.339828] initcall blk_dev_integrity_init+0x0/0x2f returned 0 after 976 usecs
[    2.347499] calling  pci_slot_init+0x0/0x40 @ 1
[    2.352267] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    2.358926] calling  fbmem_init+0x0/0x96 @ 1
[    2.363450] initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
[    2.369832] calling  acpi_init+0x0/0x26b @ 1
[    2.374413] ACPI: Added _OSI(Module Device)
[    2.378794] ACPI: Added _OSI(Processor Device)
[    2.383453] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.388387] ACPI: Added _OSI(Processor Aggregator Device)
[    2.407799] ACPI: Executed 4 blocks of module-level executable AML code
[    2.491130] ACPI: Interpreter enabled
[    2.494982] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (201580)
[    2.514402] ACPI: (supports S0 S3 S4 S5)
[    2.518506] ACPI: Using IOAPIC for interrupt routing
[    2.523860] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    2.562110] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    2.571234] PCI: Using MM[    2.706886] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.713382] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.722007] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    2.730845] acpi PNP0A03:00: ignoring host bridge window [mem 0x000d0000-0x000dffff] (conflicts with Adapter ROM [mem 0x000cf000-0x000d09ff])
[    2.745897] PCI host bridge to bus 0000:00
[    2.750187] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.755938] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.762427] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.768904] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.776122] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdfffffff]
[    2.783338] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    2.790569] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
[    2.797687] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
[    2.804799] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
[    2.811138] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    2.818092] pci 0000:00:06.0: System wakeup disabled by ACPI
[    2.824405] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    2.830743] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.837704] pci 0000:00:07.0: System wakeup disabled by ACPI
[    2.844018] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    2.850340] pci 0000:00:11.0: reg 0x10: [io  0x7000-0x7007]
[    2.856189] pci 0000:00:11.0: reg 0x14: [io  0x6000-0x6003]
[    2.862035] pci 0000:00:11.0: reg 0x18: [io  0x5000-0x5007]
[    2.867880] pci 0000:00:11.0: reg 0x1c: [io  0x4000-0x4003]
[    2.873730] pci 0000:00:11.0: reg 0x20: [io  0x3000-0x300f]
[    2.879580] pci 0000:00:11.0: reg 0x24: [mem 0xfe6ffc00-0xfe6fffff]
[    2.886993] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    2.893310] pci 0000:00:12.0: reg 0x10: [mem 0xfe6fe000-0xfe6fefff]
[    2.900495] pci 0000:00:12.0: System wakeup disabled by ACPI
[    2.906795] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    2.913103] pci 0000:00:12.1: reg 0x10: [mem 0xfe6fd000-0xfe6fdfff]
[    2.920294] pci 0000:00:12.1: System wakeup disabled by ACPI
[    2.926588] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    2.932895] pci 0000:00:12.2: reg 0x10: [mem 0xfe6ff800-0xfe6ff8ff]
[    2.939550] pci 0000:00:12.2: supports D1 D2
[    2.944020] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    2.950885] pci 0000:00:12.2: System wakeup disabled by ACPI
[    2.957182] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    2.963484] pci 0000:00:13.0: reg 0x10: [mem 0xfe6fc000-0xfe6fcfff]
[    2.970675] pci 0000:00:13.0: System wakeup disabled by ACPI
[    2.976971] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    2.983278] pci 0000:00:13.1: reg 0x10: [mem 0xfe6f7000-0xfe6f7fff]
[    2.990475] pci 0000:00:13.1: System wakeup disabled by ACPI
[    2.996783] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    3.003100] pci 0000:00:13.2: reg 0x10: [mem 0xfe6ff400-0xfe6ff4ff]
[    3.009745] pci 0000:00:13.2: supports D1 D2
[    3.014221] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    3.021083] pci 0000:00:13.2: System wakeup disabled by ACPI
[    3.027383] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    3.034561] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    3.041716] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    3.048603] pci 0000:00:14.4: System wakeup disabled by ACPI
[    3.054907] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    3.061217] pci 0000:00:14.5: reg 0x10: [mem 0xfe6f6000-0xfe6f6fff]
[    3.068407] pci 0000:00:14.5: System wakeup disabled by ACPI
[    3.074718] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    3.081748] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    3.088776] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    3.095810] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    3.102850] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    3.110194] pci 0000:01:05.0: [1002:9610] type 00 class 0x030000
[    3.116494] pci 0000:01:05.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]
[    3.123520] pci 0000:01:05.0: reg 0x14: [io  0x8000-0x80ff]
[    3.129364] pci 0000:01:05.0: reg 0x18: [mem 0xfe8f0000-0xfe8fffff]
[    3.135940] pci 0000:01:05.0: reg 0x24: [mem 0xfe700000-0xfe7fffff]
[    3.142517] pci 0000:01:05.0: supports D1 D2
[    3.147389] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
[    3.153686] pci 0000:01:05.1: reg 0x10: [mem 0xfe8e8000-0xfe8ebfff]
[    3.160280] pci 0000:01:05.1: supports D1 D2
[    3.165128] pci 0000:00:01.0: PCI bridge to [bus 01]
[    3.170331] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    3.176723] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff]
[    3.183838] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.192181] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    3.198481] pci 0000:02:00.0: reg 0x10: [io  0x9800-0x98ff]
[    3.204336] pci 0000:02:00.0: reg 0x18: [mem 0xfe9ff000-0xfe9fffff 64bit]
[    3.211454] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64bit pref]
[    3.219029] pci 0000:02:00.0: reg 0x30: [mem 0xfe9c0000-0xfe9dffff pref]
[    3.226116] pci 0000:02:00.0: supports D1 D2
[    3.230589] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.240045] pci 0000:00:06.0: PCI bridge to [bus 02]
[    3.245252] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    3.253789] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    3.260904] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    3.269243] pci 0000:03:00.0: [197b:2361] type 00 class 0x010601
[    3.275603] pci 0000:03:00.0: reg 0x24: [mem 0xfeafe000-0xfeafffff]
[    3.282233] pci 0000:03:00.0: PME# supported from D3hot
[    3.288153] pci 0000:03:00.1: [197b:2361] type 00 class 0x010185
[    3.294467] pci 0000:03:00.1: reg 0x10: [io  0xb800-0xb807]
[    3.300313] pci 0000:03:00.1: reg 0x14: [io  0xb400-0xb403]
[    3.306157] pci 0000:03:00.1: reg 0x18: [io  0xb000-0xb007]
[    3.312007] pci 0000:03:00.1: reg 0x1c: [io  0xa800-0xa803]
[    3.317860] pci 0000:03:00.1: reg 0x20: [io  0xa400-0xa40f]
[    3.324073] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.334561] pci 0000:00:07.0: PCI bridge to [bus 03]
[    3.339771] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    3.346156] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    3.353508] pci 0000:04:05.0: [10b7:1700] type 00 class 0x020000
[    3.359833] pci 0000:04:05.0: reg 0x10: [mem 0xfebfc000-0xfebfffff]
[    3.366417] pci 0000:04:05.0: reg 0x14: [io  0xe800-0xe8ff]
[    3.372310] pci 0000:04:05.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    3.379379] pci 0000:04:05.0: supports D1 D2
[    3.383855] pci 0000:04:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.391246] pci 0000:04:07.0: [9710:9835] type 00 class 0x070002
[    3.397561] pci 0000:04:07.0: reg 0x10: [io  0xe400-0xe407]
[    3.403415] pci 0000:04:07.0: reg 0x14: [io  0xe000-0xe007]
[    3.409272] pci 0000:04:07.0: reg 0x18: [io  0xd800-0xd807]
[    3.415123] pci 0000:04:07.0: reg 0x1c: [io  0xd400-0xd407]
[    3.420976] pci 0000:04:07.0: reg 0x20: [io  0xd000-0xd007]
[    3.426826] pci 0000:04:07.0: reg 0x24: [io  0xc800-0xc80f]
[    3.433041] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive decode)
[    3.440153] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    3.446545] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    3.453668] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    3.461968] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    3.470277] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    3.479310] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffffff] (subtractive decode)
[    3.488336] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    3.497371] pci_bus 0000:00: on NUMA node 0
[    3.526211] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 *14 15)
[    3.533627] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 12 14 15)
[    3.541043] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    3.548445] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    3.555863] ACPI: PCI Interrupt Link [LNKE] (IRQs *4 10 11 12 14 15)
[    3.563090] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 10 11 12 14 15) *0, disabled.
[    3.571508] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 *15)
[    3.578740] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 10 11 12 14 15) *0, disabled.
[    3.587115] ACPI: Enabled 1 GPEs in block 00 to 1F
[    3.592250] initcall acpi_init+0x0/0x26b returned 0 after 1190429 usecs
[    3.599195] calling  pnp_init+0x0/0xf @ 1
[    3.603484] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    3.609613] calling  balloon_init+0x0/0x1fa @ 1
[    3.614362] initcall balloon_init+0x0/0x1fa returned -19 after 0 usecs
[    3.621208] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    3.626956] initcall xen_setup_shutdown_event+0x0/0x30 returned -19 after 0 usecs
[    3.634797] calling  xenbus_probe_backend_init+0x0/0x23 @ 1
[    3.640711] initcall xenbus_probe_backend_init+0x0/0x23 returned 0 after 0 usecs
[    3.648466] calling  xenbus_probe_frontend_init+0x0/0x7b @ 1
[    3.654492] initcall xenbus_probe_frontend_init+0x0/0x7b returned 0 after 0 usecs
[    3.662329] calling  xen_acpi_pad_init+0x0/0x41 @ 1
[    3.667441] initcall xen_acpi_pad_init+0x0/0x41 returned -19 after 0 usecs
[    3.674657] calling  balloon_init+0x0/0xdd @ 1
[    3.679316] initcall balloon_init+0x0/0xdd returned -19 after 0 usecs
[    3.686076] calling  misc_init+0x0/0xad @ 1
[    3.690510] initcall misc_init+0x0/0xad returned 0 after 0 usecs
[    3.696805] calling  vga_arb_device_init+0x0/0xcc @ 1
[    3.702286] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    3.710818] vgaarb: loaded
[    3.713661] vgaarb: bridge control possible 0000:01:05.0
[    3.719228] initcall vga_arb_device_init+0x0/0xcc returned 0 after 16601 usecs
[    3.726808] calling  cn_init+0x0/0xb0 @ 1
[    3.731041] initcall cn_init+0x0/0xb0 returned 0 after 0 usecs
[    3.737155] calling  dma_buf_init+0x0/0x62 @ 1
[    3.741834] initcall dma_buf_init+0x0/0x62 returned 0 after 0 usecs
[    3.748399] calling  phy_init+0x0/0x2f @ 1
[    3.752909] initcall phy_init+0x0/0x2f returned 0 after 0 usecs
[    3.759121] calling  init_pcmcia_cs+0x0/0x32 @ 1
[    3.763993] initcall init_pcmcia_cs+0x0/0x32 returned 0 after 0 usecs
[    3.770748] calling  usb_init+0x0/0x14c @ 1
[    3.775148] ACPI: bus type USB registered
[    3.779559] usbcore: registered new interface driver usbfs
[    3.785413] usbcore: registered new interface driver hub
[    3.791112] usbcore: registered new device driver usb
[    3.796439] initcall usb_init+0x0/0x14c returned 0 after 21484 usecs
[    3.803103] calling  serio_init+0x0/0x2e @ 1
[    3.807658] initcall serio_init+0x0/0x2e returned 0 after 0 usecs
[    3.814045] calling  input_init+0x0/0xf1 @ 1
[    3.818572] initcall input_init+0x0/0xf1 returned 0 after 0 usecs
[    3.824963] calling  rtc_init+0x0/0x50 @ 1
[    3.829291] initcall rtc_init+0x0/0x50 returned 0 after 0 usecs
[    3.835493] calling  pps_init+0x0/0xa6 @ 1
[    3.839817] pps_core: LinuxPPS API ver. 1 registered
[    3.845021] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.854607] initcall pps_init+0x0/0xa6 returned 0 after 14648 usecs
[    3.861169] calling  ptp_init+0x0/0x8e @ 1
[    3.865495] PTP clock support registered
[    3.869601] initcall ptp_init+0x0/0x8e returned 0 after 3906 usecs
[    3.876088] calling  power_supply_class_init+0x0/0x39 @ 1
[    3.881780] initcall power_supply_class_init+0x0/0x39 returned 0 after 0 usecs
[    3.889355] calling  hwmon_init+0x0/0xda @ 1
[    3.893852] initcall hwmon_init+0x0/0xda returned 0 after 0 usecs
[    3.900246] calling  leds_init+0x0/0x36 @ 1
[    3.904659] initcall leds_init+0x0/0x36 returned 0 after 0 usecs
[    3.910951] calling  efisubsys_init+0x0/0x115 @ 1
[    3.915878] initcall efisubsys_init+0x0/0x115 returned 0 after 0 usecs
[    3.922721] calling  pci_subsys_init+0x0/0x48 @ 1
[    3.927647] PCI: Using ACPI for IRQ routing
[    3.932029] PCI: pci_cache_line_size set to 64 bytes
[    3.937286] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    3.943577] e820: reserve RAM buffer [mem 0xcfeb0000-0xcfffffff]
[    3.949872] initcall pci_subsys_init+0x0/0x48 returned 0 after 21484 usecs
[    3.957082] calling  proto_init+0x0/0xf @ 1
[    3.961473] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    3.967776] calling  net_dev_init+0x0/0x15d @ 1
[    3.973333] initcall net_dev_init+0x0/0x15d returned 0 after 976 usecs
[    3.980187] calling  neigh_init+0x0/0xa4 @ 1
[    3.984667] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
[    3.991052] calling  fib_rules_init+0x0/0xbd @ 1
[    3.995896] initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs
[    4.002655] calling  pktsched_init+0x0/0x121 @ 1
[    4.007503] initcall pktsched_init+0x0/0x121 returned 0 after 0 usecs
[    4.014259] calling  tc_filter_init+0x0/0x6a @ 1
[    4.019091] initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs
[    4.025850] calling  tc_action_init+0x0/0x6a @ 1
[    4.030692] initcall tc_action_init+0x0/0x6a returned 0 after 0 usecs
[    4.037449] calling  genl_init+0x0/0x7a @ 1
[    4.041850] initcall genl_init+0x0/0x7a returned 0 after 0 usecs
[    4.048150] calling  cipso_v4_init+0x0/0x5a @ 1
[    4.052897] initcall cipso_v4_init+0x0/0x5a returned 0 after 0 usecs
[    4.059566] calling  netlbl_init+0x0/0x7d @ 1
[    4.064136] NetLabel: Initializing
[    4.067699] NetLabel:  domain hash size = 128
[    4.072265] NetLabel:  protocols = UNLABELED CIPSOv4
[    4.077521] NetLabel:  unlabeled traffic allowed by default
[    4.083355] initcall netlbl_init+0x0/0x7d returned 0 after 19531 usecs
[    4.090197] calling  rfkill_init+0x0/0x68 @ 1
[    4.094932] initcall rfkill_init+0x0/0x68 returned 0 after 0 usecs
[    4.101449] calling  xen_mcfg_late+0x0/0xa6 @ 1
[    4.106197] initcall xen_mcfg_late+0x0/0xa6 returned 0 after 0 usecs
[    4.112904] calling  xen_p2m_debugfs+0x0/0x49 @ 1
[    4.117856] initcall xen_p2m_debugfs+0x0/0x49 returned 0 after 0 usecs
[    4.124709] calling  xen_spinlock_debugfs+0x0/0x120 @ 1
[    4.130236] initcall xen_spinlock_debugfs+0x0/0x120 returned 0 after 0 usecs
[    4.137632] calling  nmi_warning_debugfs+0x0/0x26 @ 1
[    4.142940] initcall nmi_warning_debugfs+0x0/0x26 returned 0 after 0 usecs
[    4.150154] calling  hpet_late_init+0x0/0xe6 @ 1
[    4.155007] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    4.160420] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    4.168538] initcall hpet_late_init+0x0/0xe6 returned 0 after 13671 usecs
[    4.175652] calling  init_amd_nbs+0x0/0xb6 @ 1
[    4.180325] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs
[    4.186898] calling  clocksource_done_booting+0x0/0x3b @ 1
[    4.192688] Switched to clocksource hpet
[    4.196824] initcall clocksource_done_booting+0x0/0x3b returned 0 after 4046 usecs
[    4.204768] calling  tracer_init_debugfs+0x0/0x165 @ 1
[    4.210688] initcall tracer_init_debugfs+0x0/0x165 returned 0 after 507 usecs
[    4.218186] calling  init_trace_printk_function_export+0x0/0x33 @ 1
[    4.224777] initcall init_trace_printk_function_export+0x0/0x33 returned 0 after 6 usecs
[    4.233279] calling  event_trace_init+0x0/0x1ee @ 1
[    4.258969] initcall event_trace_init+0x0/0x1ee returned 0 after 20107 usecs
[    4.266368] calling  init_kprobe_trace+0x0/0271510] initcall init_kprobe_trace+0x0/0x92 returned 0 after 11 usecs
[    4.278648] calling  init_pipe_fs+0x0/0x3d @ 1
[    4.283419] initcall init_pipe_fs+0x0/0x3d returned 0 after 103 usecs
[    4.290194] calling  eventpoll_init+0x0/0xd0 @ 1
[    4.295127] initcall eventpoll_init+0x0/0xd0 returned 0 after 88 usecs
[    4.301975] calling  anon_inode_init+0x0/0x56 @ 1
[    4.307019] initcall anon_inode_init+0x0/0x56 returned 0 after 96 usecs
[    4.313957] calling  proc_cmdline_init+0x0/0x27 @ 1
[    4.319091] initcall proc_cmdline_init+0x0/0x27 returned 0 after 7 usecs
[    4.326121] calling  proc_consoles_init+0x0/0x27 @ 1
[    4.331346] initcall proc_consoles_init+0x0/0x27 returned 0 after 6 usecs
[    4.338467] calling  proc_cpuinfo_init+0x0/0x27 @ 1
[    4.343603] initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 6 usecs
[    4.350635] calling  proc_devices_init+0x0/0x27 @ 1
[    4.355775] initcall proc_devices_init+0x0/0x27 returned 0 after 5 usecs
[    4.362797] calling  proc_interrupts_init+0x0/0x27 @ 1
[    4.368191] initcall proc_interrupts_init+0x0/0x27 returned 0 after 5 usecs
[    4.375503] calling  proc_loadavg_init+0x0/0x27 @ 1
[    4.380618] initcall proc_loadavg_init+0x0/0x27 returned 0 after 5 usecs
[    4.387655] calling  proc_meminfo_init+0x0/0x27 @ 1
[    4.392779] initcall proc_meminfo_init+0x0/0x27 returned 0 after 6 usecs
[    4.399806] calling  proc_stat_init+0x0/0x27 @ 1
[    4.404655] initcall proc_stat_init+0x0/0x27 returned 0 after 6 usecs
[    4.411420] calling  proc_uptime_init+0x0/0x27 @ 1
[    4.416458] initcall proc_uptime_init+0x0/0x27 returned 0 after 5 usecs
[    4.423395] calling  proc_version_init+0x0/0x27 @ 1
[    4.428528] initcall proc_version_init+0x0/0x27 returned 0 after 6 usecs
[    4.435558] calling  proc_softirqs_init+0x0/0x27 @ 1
[    4.440785] initcall proc_softirqs_init+0x0/0x27 returned 0 after 6 usecs
[    4.447913] calling  proc_kcore_init+0x0/0xae @ 1
[    4.452864] initcall proc_kcore_init+0x0/0xae returned 0 after 8 usecs
[    4.459706] calling  vmcore_init+0x0/0x68b @ 1
[    4.464364] initcall vmcore_init+0x0/0x68b returned 0 after 0 usecs
[    4.470955] calling  proc_kmsg_init+0x0/0x2a @ 1
[    4.475803] initcall proc_kmsg_init+0x0/0x2a returned 0 after 5 usecs
[    4.482575] calling  proc_page_init+0x0/0x4a @ 1
[    4.487439] initcall proc_page_init+0x0/0x4a returned 0 after 15 usecs
[    4.494301] calling  init_ramfs_fs+0x0/0x44 @ 1
[    4.499134] initcall init_ramfs_fs+0x0/0x44 returned 0 after 67 usecs
[    4.505913] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    4.511307] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 1 usecs
[    4.518624] calling  acpi_event_init+0x0/0x37 @ 1
[    4.523585] initcall acpi_event_init+0x0/0x37 returned 0 after 26 usecs
[    4.530536] calling  pnp_system_init+0x0/0xf @ 1
[    4.535440] initcall pnp_system_init+0x0/0xf returned 0 after 54 usecs
[    4.542292] calling  pnpacpi_init+0x0/0x88 @ 1
[    4.546965] pnp: PnP ACPI init
[    4.550206] ACPI: bus type PNP registered
[    4.555615] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.563308] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.589832] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    4.597146] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    4.604098] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.613413] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    4.619643] system 00:03: [io  0x040b] has been reserved
[    4.625225] system 00:03: [io  0x04d6] has been reserved
[    4.630815] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    4.637031] system 00:03: [io  0x0c14] has been reserved
[    4.642616] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    4.648832] system 00:03: [io  0x0c52] has been reserved
[    4.654424] system 00:03: [io  0x0c6c] has been reserved
[    4.660008] system 00:03: [io  0x0c6f] has been reserved
[    4.665601] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    4.671826] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    4.678056] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    4.684282] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    4.690501] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    4.696723] system 00:03: [io  0x0800-0x089f] could not be reserved
[    4.703300] system 00:03: [io  0x0b00-0x0b0f] has been reserved
[    4.709520] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    4.715739] system 00:03: [io  0x0900-0x090f] has been reserved
[    4.721960] system 00:03: [io  0x0910-0x091f] has been reserved
[    4.728179] system 00:03: [io  0xfe00-0xfefe] has been reserved
[    4.734393] system 00:03: [mem 0xffb80000-0xffbfffff] has been reserved
[    4.741355] system 00:03: [mem 0xfec10000-0xfec1001f] has been reserved
[    4.748303] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.757860] system 00:04: [io  0x0e00-0x0e0f] has been reserved
[    4.764083] system 00:04: [io  0x0e80-0x0e8f] has been reserved
[    4.770315] system 00:04: [io  0x0f40-0x0f4f] has been reserved
[    4.776529] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    4.782747] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.790429] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    4.797387] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.806197] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
[    4.813513] system 00:06: [mem 0x000c0000-0x000cffff] could not be reserved
[    4.820823] system 00:06: [mem 0x000e0000-0x000fffff] could not be reserved
[    4.828143] system 00:06: [mem 0x00100000-0xcfefffff] could not be reserved
[    4.835447] system 00:06: [mem 0xfec00000-0xffffffff] could not be reserved
[    4.842755] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.850721] pnp: PnP ACPI: found 7 devices
[    4.855023] ACPI: bus type PNP unregistered
[    4.859421] initcall pnpacpi_init+0x0/0x88 returned 0 after 305418 usecs
[    4.866458] calling  pcistub_init+0x0/0x280 @ 1
[    4.872012] initcall pcistub_init+0x0/0x280 returned 0 after 780 usecs
[    4.878868] calling  chr_dev_init+0x0/0xc9 @ 1
[    4.891079] kworker/u12:0 (512) used greatest stack depth: 6704 bytes left
[    4.894577] initcall chr_dev_init+0x0/0xc9 ret23] initcall firmware_class_init+0x0/0xd7 returned 0 after 35 usecs
[    4.894628] calling  init_pcmcia_bus+0x0/0x5e @ 1
[    4.894713] initcall init_pcmcia_bus+0x0/0x5e returned 0 after 78 usecs
[    4.894717] calling  thermal_init+0x0/0x78 @ 1
[    4.894780] initcall thermal_init+0x0/0x78 returned 0 after 58 usecs
[    4.894786] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    4.894791] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 2 usecs
[    4.894796] calling  init_acpi_pm_clocksource+0x0/0x18d @ 1
[    4.929353] initcall init_acpi_pm_clocksource+0x0/0x18d returned 0 after 33776 usecs
[    4.929358] calling  pcibios_assign_resources+0x0/0x8f @ 1
[    4.929405] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.929408] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    4.929413] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff]
[    4.929417] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.929423] pci 0000:00:06.0: PCI bridge to [bus 02]
[    4.929425] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    4.929431] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    4.929434] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    4.929442] pci 0000:00:07.0: PCI bridge to [bus 03]
[    4.929443] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    4.929449] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    4.929460] pci 0000:00:14.4: PCI bridge to [bus 04]
[    4.929462] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    4.929470] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    4.929485] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.929486] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.929488] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.929489] pci_bus 0000:00: resource 7 [mem 0xcff00000-0xdfffffff]
[    4.929490] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
[    4.929491] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    4.929492] pci_bus 0000:01: resource 1 [mem 0xfe700000-0xfe8fffff]
[    4.929493] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    4.929494] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    4.929495] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    4.929496] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    4.929497] pci_bus 0000:03: resource 0 [io  0xa000-0xbfff]
[    4.929498] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    4.929500] pci_bus 0000:04: resource 0 [io  0xc000-0xefff]
[    4.929501] pci_bus 0000:04: resource 1 [mem 0xfeb00000-0xfebfffff]
[    4.929502] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    4.929503] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    4.929504] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    4.929505] pci_bus 0000:04: resource 7 [mem 0xcff00000-0xdfffffff]
[    4.929506] pci_bus 0000:04: resource 8 [mem 0xf0000000-0xfebfffff]
[    4.929509] initcall pcibios_assign_resources+0x0/0x8f returned 0 after 145 usecs
[    4.929514] calling  sysctl_core_init+0x0/0x23 @ 1
[    4.929537] initcall sysctl_core_init+0x0/0x23 returned 0 after 20 usecs
[    4.929542] calling  inet_init+0x0/0x25b @ 1
[    5.218383] NET: Registered protocol family 2
[    5.223741] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    5.231167] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    5.237951] TCP: Hash tables configured (established 8192 bind 8192)
[    5.244647] TCP: reno registered
[    5.248037] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    5.254257] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    5.261270] initcall inet_init+0x0/0x25b returned 0 after 324255 usecs
[    5.268128] calling  ipv4_offload_init+0x0/0x5d @ 1
[    5.273251] initcall ipv4_offload_init+0x0/0x5d returned 0 after 1 usecs
[    5.280294] calling  af_unix_init+0x0/0x4d @ 1
[    5.284988] NET: Registered protocol family 1
[    5.289573] initcall af_unix_init+0x0/0x4d returned 0 after 4514 usecs
[    5.296431] calling  ipv6_offload_init+0x0/0x7a @ 1
[    5.301554] initcall ipv6_offload_init+0x0/0x7a returned 0 after 1 usecs
[    5.308604] calling  init_sunrpc+0x0/0x5f @ 1
[    5.313533] RPC: Registered named UNIX socket transport module.
[    5.319757] RPC: Registered udp transport module.
[    5.324705] RPC: Registered tcp transport module.
[    5.329657] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.336428] initcall init_sunrpc+0x0/0x5f returned 0 after 22734 usecs
[    5.343307] calling  pci_apply_final_quirks+0x0/0x112 @ 1
[    5.348977] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    5.356229] pci 0000:00:12.0: already assigned IRQ14
[    5.362927] IOAPIC[0]: Set routing entry (4-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    5.371499] pci 0000:00:12.0: assigned new IRQ16
[    5.439991] pci 0000:00:12.1: already assigned IRQ14
[    5.446627] IOAPIC[0]: Set routing entry (4-16 -> 0x51 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    5.455209] pci 0000:00:12.1: assigned new IRQ16
[    5.533832] pci 0000:00:12.2: already assigned IRQ7
[    5.540329] IOAPIC[0]: Set routing entry (4-17 -> 0x61 -> IRQ 17 Mode:12.2: assigned new IRQ17
[    5.555096] pci 0000:00:13.0: already assigned IRQ10
[    5.561712] IOAPIC[0]: Set routing entry (4-18 -> 0x71 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    5.570298] pci 0000:00:13.0: assigned new IRQ18
[    5.648742] pci 0000:00:13.1: already assigned IRQ10
[    5.655375] IOAPIC[0]: Set routing entry (4-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    5.663965] pci 0000:00:13.1: assigned new IRQ18
[    5.742666] pci 0000:00:13.2: already assigned IRQ11
[    5.749305] IOAPIC[0]: Set routing entry (4-19 -> 0x91 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    5.757899] pci 0000:00:13.2: assigned new IRQ19
[    5.764085] pci 0000:00:14.5: already assigned IRQ10
[    5.770691] IOAPIC[0]: Set routing entry (4-18 -> 0xa1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    5.779285] pci 0000:00:14.5: assigned new IRQ18
[    5.857557] pci 0000:01:05.0: Boot video device
[    5.862332] PCI: CLS 64 bytes, default 64
[    5.866554] initcall pci_ap/0x112 returned 0 after 505921 usecs
[    5.874605] calling  populate_rootfs+0x0/0xf9 @ 1
[    5.879707] Unpacking initramfs...
[    7.729446] microcode: updated early to new patch_level=0x010000db
[    7.763376] Freeing initrd memory: 83068K (f2adf000 - f7bfe000)
[    7.769609] initcall populate_rootfs+0x0/0xf9 returned 0  7.788688] calling  register_kernel_offset_dumper+0x0/0x16 @ 1
[    7.794910] initcall register_kernel_offset_dumper+0x0/0x16 returned 0 after 2 usecs
[    7.803043] calling  i8259A_init_ops+0x0/0x1d @ 1
[    7.807988] initcall i8259A_init_ops+0x0/0x1d returned 0 after 1 usecs
[    7.814844] calling  sbf_init+0x0/0xf1 @ 1
[    7.819147] initcall sbf_init+0x0/0xf1 returned 0 after 0 usecs
[    7.825362] calling  init_tsc_clocksource+0x0/0xa7 @ 1
[    7.830766] initcall init_tsc_clocksource+0x0/0xa7 returned 0 after 2 usecs
[    7.838075] calling  add_rtc_cmos+0x0/0x99 @ 1
[    7.842743] initcall add_rtc_cmos+0x0/0x99 returned 0 after 2 usecs
[    7.849324] calling  i8237A_init_ops+0x0/0x11 @ 1
[    7.854274] initcall i8237A_init_ops+0x0/0x11 returned 0 after 1 usecs
[    7.861136] calling  cache_sysfs_init+0x0/0x69 @ 1
[    7.867518] initcall cache_sysfs_init+0x0/0x69 returned 0 after 1311 usecs
[    7.874737] calling  amd_uncore_init+0x0/0x111 @ 1
[    7.879765] initcall amd_uncore_init+0x0/0x111 returned -19 after 1 usecs
[    7.886894] calling  intel_uncore_init+0x0/0x3ea @ 1
[    7.892109] initcall intel_uncore_init+0x0/0x3ea returned -19 after 2 usecs
[    7.899429] calling  rapl_pmu_init+0x0/0x194 @ 1
[    7.904280] initcall rapl_pmu_init+0x0/0x194 returned 0 after 1 usecs
[    7.911054] calling  inject_init+0x0/0x30 @ 1
[    7.915632] Machine check injector initialized
[    7.920311] initcall inject_init+0x0/0x30 returned 0 after 4572 usecs
[    7.927079] calling  thermal_throttle_init_device+0x0/0x6d @ 1
[    7.933201] initcall thermal_throttle_init_device+0x0/0x6d returned 0 after 1 usecs
[    7.941250] calling  microcode_init+0x0/0x18c @ 1
[    7.946328] microcode: CPU0: patch_level=0x010000db
[    7.951480] microcode: CPU1: patch_level=0x01000086
[    7.956635] microcode: CPU2: patch_level=0x01000086
[    7.961787] microcode: CPU3: patch_level=0x01000086
[    7.967107] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.976355] initcall microcode_init+0x0/0x18c returned 0 after 29479 usecs
[    7.983582] calling  amd_ibs_init+0x0/0x21f @ 1
[    7.988340] LVT offset 1 assigned for vector 0x400
[    7.993375] IBS: LVT offset 1 assigned
[    7.997423] perf: AMD IBS detected (0x0000001f)
[    8.002178] initcall amd_ibs_init+0x0/0x21f returned 0 after 13526 usecs
[    8.009216] calling  msr_init+0x0/0x153 @ 1
[    8.014275] initcall msr_init+0x0/0x153 returned 0 after 647 usecs
[    8.020794] calling  cpuid_init+0x0/0x153 @ 1
[    8.025989] initcall cpuid_init+0x0/0x153 returned 0 after 607 usecs
[    8.032672] calling  ioapic_init_ops+0x0/0x11 @ 1
[    8.037614] initcall ioapic_init_ops+0x0/0x11 returned 0 after 0 usecs
[    8.044467] calling  add_pcspkr+0x0/0x3b @ 1
[    8.049038] initcall add_pcspkr+0x0/0x3b returned 0 after 84 usecs
[    8.055536] calling  start_periodic_check_for_corruption+0x0/0x60 @ 1
[    8.062302] Scanning for low memory corruption every 60 seconds
[    8.068516] initcall start_periodic_check_for_corruption+0x0/0x60 returned 0 after 6073 usecs
[    8.077479] calling  sysfb_init+0x0/0x80 @ 1
[    8.082070] initcall sysfb_init+0x0/0x80 returned 0 after 105 usecs
[    8.088654] calling  pt_dump_init+0x0/0x70 @ 1
[    8.093329] initcall pt_dump_init+0x0/0x70 returned 0 after 11 usecs
[    8.099995] calling  aes_init+0x0/0xf @ 1
[    8.104288] initcall aes_init+0x0/0xf returned 0 after 83 usecs
[    8.110516] calling  proc_execdomains_init+0x0/0x27 @ 1
[    8.116025] initcall proc_execdomains_init+0x0/0x27 returned 0 after 19 usecs
[    8.123531] calling  ioresources_init+0x0/0x44 @ 1
[    8.128578] initcall ioresources_init+0x0/0x44 returned 0 after 11 usecs
[    8.135616] calling  snapshot_device_init+0x0/0xf @ 1
[    8.141085] initcall snapshot_device_init+0x0/0xf returned 0 after 154 usecs
[    8.148501] calling  irq_pm_init_ops+0x0/0x11 @ 1
[    8.153439] initcall irq_pm_init_ops+0x0/0x11 returned 0 after 1 usecs
[    8.160304] calling  init_posix_timers+0x0/0x22b @ 1
[    8.165595] initcall init_posix_timers+0x0/0x22b returned 0 after 66 usecs
[    8.172828] calling  init_posix_cpu_timers+0x0/0x9b @ 1
[    8.178316] initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 1 usecs
[    8.185728] calling  timekeeping_init_ops+0x0/0x11 @ 1
[    8.191131] initcall timekeeping_init_ops+0x0/0x11 returned 0 after 0 usecs
[    8.198454] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[    8.204233] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after 198 usecs
[    8.211933] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    8.217521] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 7 usecs
[    8.225020] calling  alarmtimer_init+0x0/0x151 @ 1
[    8.230229] initcall alarmtimer_init+0x0/0x151 returned 0 after 173 usecs
[    8.237362] calling  clockevents_init_sysfs+0x0/0xa3 @ 1
[    8.243617] initcall clockevents_init_sysfs+0x0/0xa3 returned 0 after 647 usecs
[    8.251310] calling  init_tstats_procfs+0x0/0x30 @ 1
[    8.256529] initcall init_tstats_procfs+0x0/0x30 returned 0 after 7 usecs
[    8.263663] calling  futex_init+0x0/0xe6 @ 1
[    8.268147] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    8.274770] initcall futex_init+0x0/0xe6 returned 0 after 6476 usecs
[    8.281460] calling  proc_dma_init+0x0/0x27 @ 1
[    8.286219] initcall proc_dma_init+0x0/0x27 returned 0 after 6 usecs
[    8.292906] calling  proc_modules_init+0x0/0x27 @ 1
[    8.298040] initcall proc_modules_init+0x0/0x27 returned 0 after 6 usecs
[    8.305082] calling  kallsyms_init+0x0/0x2a @ 1
[    8.309860] initcall kallsyms_init+0x0/0x2a returned 0 after 8 usecs
[    8.316526] calling  pid_namespaces_init+0x0/0x32 @ 1
[    8.321875] initcall pid_namespaces_init+0x0/0x32 returned 0 after 33 usecs
[    8.329186] calling  ikconfig_init+0x0/0x41 @ 1
[    8.333956] initcall ikconfig_init+0x0/0x41 returned 0 after 7 usecs
[    8.340628] calling  audit_init+0x0/0xed @ 1
[    8.345120] audit: initializing netlink subsys (disabled)
[    8.350832] audit: type=2000 audit(1405440292.728:1): initialized
[    8.357230] initcall audit_init+0x0/0xed returned 0 after 11836 usecs
[    8.364009] calling  audit_watch_init+0x0/0x31 @ 1
[    8.369044] initcall audit_watch_init+0x0/0x31 returned 0 after 3 usecs
[    8.376011] calling  audit_tree_init+0x0/0x3b @ 1
[    8.380953] initcall audit_tree_init+0x0/0x3b returned 0 after 3 usecs
[    8.387815] calling  init_kprobes+0x0/0x177 @ 1
[    8.393023] initcall init_kprobes+0x0/0x177 returned 0 after 436 usecs
[    8.399887] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    8.405197] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 14 usecs
[    8.412512] calling  init_tracepoints+0x0/0x29 @ 1
[    8.417541] initcall init_tracepoints+0x0/0x29 returned 0 after 0 usecs
[    8.424515] calling  init_blk_tracer+0x0/0x56 @ 1
[    8.429462] initcall init_blk_tracer+0x0/0x56 returned 0 after 2 usecs
[    8.436322] calling  perf_event_sysfs_init+0x0/0x8f @ 1
[    8.442562] initcall perf_event_sysfs_init+0x0/0x8f returned 0 after 732 usecs
[    8.450142] calling  init_per_zone_wmark_min+0x0/0x9d @ 1
[    8.455820] initcall init_per_zone_wmark_min+0x0/0x9d returned 0 after 4 usecs
[    8.463405] calling  kswapd_init+0x0/0x1d @ 1
[    8.468115] initcall kswapd_init+0x0/0x1d returned 0 after 137 usecs
[    8.474802] calling  extfrag_debug_init+0x0/0x7b @ 1
[    8.480037] initcall extfrag_debug_init+0x0/0x7b returned 0 after 21 usecs
[    8.487269] calling  setup_vmstat+0x0/0xcf @ 1
[    8.491962] initcall setup_vmstat+0x0/0xcf returned 0 after 26 usecs
[    8.498637] calling  mm_compute_batch_init+0x0/0x51 @ 1
[    8.504133] initcall mm_compute_batch_init+0x0/0x51 returned 0 after 0 usecs
[    8.511541] calling  slab_proc_init+0x0/0x2a @ 1
[    8.516401] initcall slab_proc_init+0x0/0x2a returned 0 after 6 usecs
[    8.523164] calling  workingset_init+0x0/0x38 @ 1
[    8.528111] initcall workingset_init+0x0/0x38 returned 0 after 5 usecs
[    8.534959] calling  proc_vmalloc_init+0x0/0x2a @ 1
[    8.540104] initcall proc_vmalloc_init+0x0/0x2a returned 0 after 6 usecs
[    8.547150] calling  procswaps_init+0x0/0x27 @ 1
[    8.552016] initcall procswaps_init+0x0/0x27 returned 0 after 6 usecs
[    8.558778] calling  init_frontswap+0x0/0x84 @ 1
[    8.563668] initcall init_frontswap+0x0/0x84 returned 0 after 30 usecs
[    8.570531] calling  hugetlb_init+0x0/0x3d8 @ 1
[    8.575290] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.582045] initcall hugetlb_init+0x0/0x3d8 returned 0 after 6602 usecs
[    8.588990] calling  slab_proc_init+0x0/0x7 @ 1
[    8.593752] initcall slab_proc_init+0x0/0x7 returned 0 after 0 usecs
[    8.600437] calling  cpucache_init+0x0/0x40 @ 1
[    8.605202] initcall cpucache_init+0x0/0x40 returned 0 after 1 usecs
[    8.611877] calling  init_cleancache+0x0/0xa8 @ 1
[    8.616843] initcall init_cleancache+0x0/0xa8 returned 0 after 29 usecs
[    8.623791] calling  zs_init+0x0/0x90 @ 1
[    8.628009] initcall zs_init+0x0/0x90 returned 0 after 3 usecs
[    8.634132] calling  fcntl_init+0x0/0x2f @ 1
[    8.638664] initcall fcntl_init+0x0/0x2f returned 0 after 36 usecs
[    8.645152] calling  proc_filesystems_init+0x0/0x27 @ 1
[    8.650654] initcall proc_filesystems_init+0x0/0x27 returned 0 after 6 usecs
[    8.658052] calling  dio_init+0x0/0x32 @ 1
[    8.662402] initcall dio_init+0x0/0x32 returned 0 after 49 usecs
[    8.668721] calling  fsnotify_mark_init+0x0/0x46 @ 1
[    8.674003] initcall fsnotify_mark_init+0x0/0x46 returned 0 after 67 usecs
[    8.681235] calling  dnotify_init+0x0/0x7c @ 1
[    8.685978] initcall dnotify_init+0x0/0x7c returned 0 after 73 usecs
[    8.692645] calling  inotify_user_setup+0x0/0x50 @ 1
[    8.697901] initcall inotify_user_setup+0x0/0x50 returned 0 after 34 usecs
[    8.705121] calling  aio_setup+0x0/0x7e @ 1
[    8.709686] initcall aio_setup+0x0/0x7e returned 0 after 167 usecs
[    8.716175] calling  proc_locks_init+0x0/0x27 @ 1
[    8.721130] initcall proc_locks_init+0x0/0x27 returned 0 after 6 usecs
[    8.727988] calling  dquot_init+0x0/0x116 @ 1
[    8.732571] VFS: Disk quotas dquot_6.5.2
[    8.736846] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    8.743697] initcall dquot_init+0x0/0x116 returned 0 after 10874 usecs
[    8.750563] calling  init_v2_quota_format+0x0/0x1d @ 1
[    8.755967] initcall init_v2_quota_format+0x0/0x1d returned 0 after 1 usecs
[    8.763292] calling  quota_init+0x0/0x2e @ 1
[    8.767814] initcall quota_init+0x0/0x2e returned 0 after 25 usecs
[    8.774307] calling  init_devpts_fs+0x0/0x52 @ 1
[    8.779285] initcall init_devpts_fs+0x0/0x52 returned 0 after 116 usecs
[    8.786243] calling  init_hugetlbfs_fs+0x0/0x145 @ 1
[    8.791690] initcall init_hugetlbfs_fs+0x0/0x145 returned 0 after 221 usecs
[    8.799007] calling  init_fat_fs+0x0/0x4c @ 1
[    8.803661] initcall init_fat_fs+0x0/0x4c returned 0 after 70 usecs
[    8.810236] calling  init_vfat_fs+0x0/0xf @ 1
[    8.814813] initcall init_vfat_fs+0x0/0xf returned 0 after 1 usecs
[    8.821319] calling  init_msdos_fs+0x0/0xf @ 1
[    8.825985] initcall init_msdos_fs+0x0/0xf returned 0 after 1 usecs
[    8.832573] calling  init_iso9660_fs+0x0/0x69 @ 1
[    8.837560] initcall init_iso9660_fs+0x0/0x69 returned 0 after 49 usecs
[    8.844501] calling  init_nfs_fs+0x0/0x142 @ 1
[    8.849628] initcall init_nfs_fs+0x0/0x142 returned 0 after 444 usecs
[    8.856395] calling  init_nfs_v2+0x0/0x11 @ 1
[    8.860980] initcall init_nfs_v2+0x0/0x11 returned 0 after 1 usecs
[    8.867474] calling  init_nfs_v3+0x0/0x11 @ 1
[    8.872057] initcall init_nfs_v3+0x0/0x11 returned 0 after 1 usecs
[    8.878551] calling  init_nfs_v4+0x0/0x30 @ 1
[    8.883123] NFS: Registering the id_resolver key type
[    8.888451] Key type id_resolver registered
[    8.892844] Key type id_legacy registered
[    8.897066] initcall init_nfs_v4+0x0/0x30 returned 0 after 13628 usecs
[    8.903946] calling  init_nlm+0x0/0x3b @ 1
[    8.908278] initcall init_nlm+0x0/0x3b returned 0 after 15 usecs
[    8.914593] calling  init_nls_cp437+0x0/0x11 @ 1
[    8.919448] initcall init_nls_cp437+0x0/0x11 returned 0 after 1 usecs
[    8.926224] calling  init_nls_ascii+0x0/0x11 @ 1
[    8.931086] initcall init_nls_ascii+0x0/0x11 returned 0 after 1 usecs
[    8.937850] calling  init_nls_iso8859_1+0x0/0x11 @ 1
[    8.943069] initcall init_nls_iso8859_1+0x0/0x11 returned 0 after 0 usecs
[    8.950222] calling  init_nls_utf8+0x0/0x23 @ 1
[    8.954996] initcall init_nls_utf8+0x0/0x23 returned 0 after 1 usecs
[    8.961680] calling  init_ntfs_fs+0x0/0x1c9 @ 1
[    8.966443] ntfs: driver 2.1.30 [Flags: R/W].
[    8.971213] initcall init_ntfs_fs+0x0/0x1c9 returned 0 after 4661 usecs
[    8.978166] calling  init_autofs4_fs+0x0/0x26 @ 1
[    8.983195] tsc: Refined TSC clocksource calibration: 3000.106 MHz
[    8.983305] initcall init_autofs4_fs+0x0/0x26 returned 0 after 178 usecs
[    8.983311] calling  init_pstore_fs+0x0/0x41 @ 1
[    8.983332] initcall init_pstore_fs+0x0/0x41 returned 0 after 17 usecs
[    8.983337] calling  ipc_init+0x0/0x20 @ 1
[    8.983353] msgmni has been set to 1688
[    8.983375] initcall ipc_init+0x0/0x20 returned 0 after 34 usecs
[    8.983380] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    8.983399] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 14 usecs
[    8.983404] calling  init_mqueue_fs+0x0/0x91 @ 1
[    9.039869] initcall init_mqueue_fs+0x0/0x91 returned 0 after 55190 usecs
[    9.047010] calling  key_proc_init+0x0/0x64 @ 1
[    9.051805] initcall key_proc_init+0x0/0x64 returned 0 after 25 usecs
[    9.058584] calling  selinux_nf_ip_init+0x0/0x65 @ 1
[    9.063817] initcall selinux_nf_ip_init+0x0/0x65 returned 0 after 4 usecs
[    9.070959] calling  init_sel_fs+0x0/0x8b @ 1
[    9.075557] initcall init_sel_fs+0x0/0x8b returned 0 after 4 usecs
[    9.082060] calling  selnl_init+0x0/0x53 @ 1
[    9.086577] initcall selnl_init+0x0/0x53 returned 0 after 25 usecs
[    9.093085] calling  sel_netif_init+0x0/0x54 @ 1
[    9.097945] initcall sel_netif_init+0x0/0x54 returned 0 after 0 usecs
[    9.104716] calling  sel_netnode_init+0x0/0x5f @ 1
[    9.109758] initcall sel_netnode_init+0x0/0x5f returned 0 after 0 usecs
[    9.116723] calling  sel_netport_init+0x0/0x5f @ 1
[    9.121763] initcall sel_netport_init+0x0/0x5f returned 0 after 0 usecs
[    9.128716] calling  aurule_init+0x0/0x2d @ 1
[    9.133312] initcall aurule_init+0x0/0x2d returned 0 after 10 usecs
[    9.139919] calling  crypto_algapi_init+0x0/0xc @ 1
[    9.145066] initcall crypto_algapi_init+0x0/0xc returned 0 after 16 usecs
[    9.152224] calling  chainiv_module_init+0x0/0xf @ 1
[    9.157450] initcall chainiv_module_init+0x0/0xf returned 0 after 4 usecs
[    9.164588] calling  eseqiv_module_init+0x0/0xf @ 1
[    9.169730] initcall eseqiv_module_init+0x0/0xf returned 0 after 4 usecs
[    9.176790] calling  hmac_module_init+0x0/0xf @ 1
[    9.181743] initcall hmac_module_init+0x0/0xf returned 0 after 4 usecs
[    9.188608] calling  md5_mod_init+0x0/0xf @ 1
[    9.193289] initcall md5_mod_init+0x0/0xf returned 0 after 95 usecs
[    9.199879] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    9.205372] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 74 usecs
[    9.212783] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    9.218278] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 0 usecs
[    9.225702] calling  des_generic_mod_init+0x0/0x14 @ 1
[    9.231258] initcall des_generic_mod_init+0x0/0x14 returned 0 after 141 usecs
[    9.238772] calling  aes_init+0x0/0xf @ 1
[    9.243080] initcall aes_init+0x0/0xf returned 0 after 83 usecs
[    9.249309] calling  zlib_mod_init+0x0/0xf @ 1
[    9.254066] initcall zlib_mod_init+0x0/0xf returned 0 after 83 usecs
[    9.260745] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    9.266612] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 0 usecs
[    9.274386] calling  crypto_authenc_esn_module_init+0x0/0xf @ 1
[    9.280609] initcall crypto_authenc_esn_module_init+0x0/0xf returned 0 after 0 usecs
[    9.288750] calling  krng_mod_init+0x0/0xf @ 1
[    9.293507] initcall krng_mod_init+0x0/0xf returned 0 after 83 usecs
[    9.300189] calling  proc_genhd_init+0x0/0x44 @ 1
[    9.305147] initcall proc_genhd_init+0x0/0x44 returned 0 after 12 usecs
[    9.312106] calling  init_emergency_pool+0x0/0x53 @ 1
[    9.317433] bounce: pool size: 64 pages
[    9.321466] initcall init_emergency_pool+0x0/0x53 returned 0 after 3954 usecs
[    9.328970] calling  bsg_init+0x0/0x119 @ 1
[    9.333442] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    9.341222] initcall bsg_init+0x0/0x119 returned 0 after 7674 usecs
[    9.347820] calling  noop_init+0x0/0xf @ 1
[    9.352143] io scheduler noop registered
[    9.356286] initcall noop_init+0x0/0xf returned 0 after 4050 usecs
[    9.362794] calling  deadline_init+0x0/0xf @ 1
[    9.367478] io scheduler deadline registered
[    9.371977] initcall deadline_init+0x0/0xf returned 0 after 4400 usecs
[    9.378838] calling  cfq_init+0x0/0x89 @ 1
[    9.383234] io scheduler cfq registered (default)
[    9.388180] initcall cfq_init+0x0/0x89 returned 0 after 4908 usecs
[    9.394679] calling  percpu_counter_startup+0x0/0x35 @ 1
[    9.400287] initcall percpu_counter_startup+0x0/0x35 returned 0 after 6 usecs
[    9.407803] calling  audit_classes_init+0x0/0x4f @ 1
[    9.413053] initcall audit_classes_init+0x0/0x4f returned 0 after 19 usecs
[    9.420280] calling  phy_core_init+0x0/0x45 @ 1
[    9.425086] initcall phy_core_init+0x0/0x45 returned 0 after 34 usecs
[    9.431869] calling  pci_proc_init+0x0/0x64 @ 1
[    9.436866] initcall pci_proc_init+0x0/0x64 returned 0 after 217 usecs
[    9.443737] calling  pcie_portdrv_init+0x0/0x6f @ 1
[    9.449029] pcieport 0000:00:06.0: already assigned IRQ10
[    9.456460] IOAPIC[0]: Set routing entry (4-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[    9.465056] pcieport 0000:00:06.0: assigned new IRQ18
[    9.470436] pcieport 0000:00:06.0: irq 24 for MSI/MSI-X
[    9.476112] pcieport 0000:00:07.0: already assigned IRQ11
[    9.483487] IOAPIC[0]: Set routing entry (4-19 -> 0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[    9.492077] pcieport 0000:00:07.0: assigned new IRQ19
[    9.497448] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    9.503163] initcall pcie_portdrv_init+0x0/0x6f returned 0 after 53059 usecs
[    9.510584] calling  aer_service_init+0x0/0x28 @ 1
[    9.515703] initcall aer_service_init+0x0/0x28 returned 0 after 66 usecs
[    9.522754] calling  pci_hotplug_init+0x0/0x1e @ 1
[    9.527806] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.533671] initcall pci_hotplug_init+0x0/0x1e returned 0 after 5733 usecs
[    9.540914] calling  pcied_init+0x0/0x76 @ 1
[    9.545536] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    9.552489] initcall pcied_init+0x0/0x76 returned 0 after 6917 usecs
[    9.559184] calling  pcifront_init+0x0/0x41 @ 1
[    9.563957] initcall pcifront_init+0x0/0x41 returned -19 after 5 usecs
[    9.570837] calling  genericbl_driver_init+0x0/0x11 @ 1
[    9.576391] initcall genericbl_driver_init+0x0/0x11 returned 0 after 52 usecs
[    9.583902] calling  cirrusfb_init+0x0/0xaa @ 1
[    9.588748] initcall cirrusfb_init+0x0/0xaa returned 0 after 70 usecs
[    9.595528] calling  efifb_driver_init+0x0/0x11 @ 1
[    9.600717] initcall efifb_driver_init+0x0/0x11 returned 0 after 51 usecs
[    9.607850] calling  intel_idle_init+0x0/0x2ec @ 1
[    9.612906] initcall intel_idle_init+0x0/0x2ec returned -19 after 6 usecs
[    9.620052] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    9.625668] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 13 usecs
[    9.633264] calling  acpi_ac_init+0x0/0x25 @ 1
[    9.638024] initcall acpi_ac_init+0x0/0x25 returned 0 after 76 usecs
[    9.644712] calling  acpi_button_driver_init+0x0/0xf @ 1
[    9.650692] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    9.659477] ACPI: Power Button [PWRB]
[    9.663706] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    9.671500] ACPI: Power Button [PWRF]
[    9.675409] initcall acpi_button_driver_init+0x0/0xf returned 0 after 24540 usecs
[    9.683282] calling  acpi_fan_driver_init+0x0/0xf @ 1
[    9.688664] initcall acpi_fan_driver_init+0x0/0xf returned 0 after 57 usecs
[    9.695983] calling  acpi_processor_driver_init+0x0/0x3e @ 1
[    9.702003] ACPI: processor limited to max C-state 1
[    9.707981] initcall acpi_processor_driver_init+0x0/0x3e returned 0 after 5905 usecs
[    9.716127] calling  acpi_thermal_init+0x0/0x8c @ 1
[    9.724143] thermal LNXTHERM:00: registered as thermal_zone0
[    9.730101] ACPI: Thermal Zone [THRM] (30 C)
[    9.734626] initcall acpi_thermal_init+0x0/0x8c returned 0 after 13060 usecs
[    9.742043] calling  acpi_battery_init+0x0/0x13 @ 1
[    9.747179] initcall acpi_battery_init+0x0/0x13 returned 0 after 9 usecs
[    9.747191] calling  1_acpi_battery_init_async+0x0/0x22 @ 6
[    9.747274] initcall 1_acpi_battery_init_async+0x0/0x22 returned 0 after 76 usecs
[    9.767925] calling  acpi_hed_driver_init+0x0/0xf @ 1
[    9.773300] initcall acpi_hed_driver_init+0x0/0xf returned 0 after 58 usecs
[    9.780601] calling  erst_init+0x0/0x2fa @ 1
[    9.785089] initcall erst_init+0x0/0x2fa returned 0 after 1 usecs
[    9.791495] calling  ghes_init+0x0/0x165 @ 1
[    9.795973] GHES: HEST is not enabled!
[    9.799911] initcall ghes_init+0x0/0x165 returned -22 after 3848 usecs
[    9.806761] calling  einj_init+0x0/0x4ef @ 1
[    9.811250] initcall einj_init+0x0/0x4ef returned -19 after 0 usecs
[    9.817837] calling  ioat_init_module+0x0/0xb0 @ 1
[    9.822867] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    9.829203] initcall ioat_init_module+0x0/0xb0 returned 0 after 6192 usecs
[    9.836438] calling  virtio_mmio_init+0x0/0x11 @ 1
[    9.841516] initcall virtio_mmio_init+0x0/0x11 returned 0 after 48 usecs
[    9.848549] calling  virtio_balloon_driver_init+0x0/0xf @ 1
[    9.854465] initcall virtio_balloon_driver_init+0x0/0xf returned 0 after 47 usecs
[    9.862337] calling  xenbus_probe_initcall+0x0/0x35 @ 1
[    9.867827] initcall xenbus_probe_initcall+0x0/0x35 returned -19 after 1 usecs
[    9.875419] calling  xenbus_init+0x0/0x37 @ 1
[    9.879989] initcall xenbus_init+0x0/0x37 returned -19 after 0 usecs
[    9.886673] calling  xenbus_backend_init+0x0/0x48 @ 1
[    9.891972] initcall xenbus_backend_init+0x0/0x48 returned -19 after 1 usecs
[    9.899386] calling  gntdev_init+0x0/0x48 @ 1
[    9.903965] initcall gntdev_init+0x0/0x48 returned -19 after 1 usecs
[    9.910650] calling  gntalloc_init+0x0/0x37 @ 1
[    9.915397] initcall gntalloc_init+0x0/0x37 returned -19 after 0 usecs
[    9.922260] calling  hypervisor_subsys_init+0x0/0x21 @ 1
[    9.927839] initcall hypervisor_subsys_init+0x0/0x21 returned -19 after 0 usecs
[    9.935533] calling  hyper_sysfs_init+0x0/0xcc @ 1
[    9.940568] initcall hyper_sysfs_init+0x0/0xcc returned -19 after 0 usecs
[    9.947709] calling  platform_pci_module_init+0x0/0x16 @ 1
[    9.953540] initcall platform_pci_module_init+0x0/0x16 returned 0 after 67 usecs
[    9.961328] calling  xen_pcibk_init+0x0/0x110 @ 1
[    9.966264] initcall xen_pcibk_init+0x0/0x110 returned -19 after 1 usecs
[    9.973318] calling  xen_acpi_processor_init+0x0/0x1f7 @ 1
[    9.979079] initcall xen_acpi_processor_init+0x0/0x1f7 returned -19 after 0 usecs
[    9.986949] calling  pty_init+0x0/0x3d9 @ 1
[   10.038373] Switched to clocksource tsc
[   10.055493] initcall pty_init+0x0/0x3d9 returned 0 after 62706 usecs
[   10.0621  10.066668] initcall sysrq_init+0x0/0xbe returned 0 after 9 usecs
[   10.073060] calling  xen_hvc_init+0x0/0x1d5 @ 1
[   10.077818] initcall xen_hvc_init+0x0/0x1d5 returned -19 after 0 usecs
[   10.084674] calling  serial8250_init+0x0/0x16d @ 1
[   10.089704] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   10.098000] initcall serial8250_init+0x0/0x16d returned 0 after 8107 usecs
[   10.105226] calling  serial_pci_driver_init+0x0/0x16 @ 1
[   10.110879] serial 0000:04:07.0: already assigned IRQ15
[   10.116915] IOAPIC[0]: Set routing entry (4-22 -> 0x22 -> IRQ 22 Mode:1 Active:1 Dest:15)
[   10.125505] serial 0000:04:07.0: assigned new IRQ22
[   10.151295] 0000:04:07.0: ttyS0 at I/O 0xe400 (irq = 22, base_baud = 115200) is a 16550A
[   10.159806] console [ttyS0] enab/0x15 @ 1
[   10.187975] initcall init_kgdboc+0x0/0x15 returned 0 after 0 usecs
[   10.194341] calling  init+0x0/0xf3 @ 1
[   10.198342] initcall init+0x0/0xf3 returned 0 after 139 usecs
[   10.204262] calling  hpet_init+0x0/0x57 @ 1
[   10.209047] initcall hpet_init+0x0/0x57 returned 0 after 468 usecs
[   10.215419] calling  nvram_init+0x0/0x7e @ 1
[   10.219944] Non-volatile memory driver v1.3
[   10.224256] initcall nvram_init+0x0/0x7e returned 0 after 4337 usecs
[   10.230806] calling  mod_init+0x0/0x1b6 @ 1
[   10.235148] initcall mod_init+0x0/0x1b6 returned -19 after 31 usecs
[   10.241609] calling  mod_init+0x0/0x12d @ 1
[   10.245923] initcall mod_init+0x0/0x12d returned -19 after 5 usecs
[   10.252294] calling  mod_init+0x0/0x99 @ 1
[   10.256517] initcall mod_init+0x0/0x99 returned -19 after 3 usecs
[   10.262798] calling  mod_init+0x0/0x48 @ 1
[   10.267019] initcall mod_init+0x0/0x48 returned -19 after 0 usecs
[   10.273300] calling  rng_init+0x0/0xf @ 1
[   10.277578] initcall rng_init+0x0/0xf returned 0 after 145 usecs
[   10.283766] calling  agp_init+0x0/0x2f @ 1
[   10.287980] Linux agpgart interface v0.103
[   10.292194] initcall agp_init+0x0/0x2f returned 0 after 4118 usecs
[   10.298559] calling  agp_ali_init+0x0/0x24 @ 1
[   10.303198] initcall agp_ali_init+0x0/0x24 returned 0 after 63 usecs
[   10.309744] calling  agp_ati_init+0x0/0x24 @ 1
[   10.314380] initcall agp_ati_init+0x0/0x24 returned 0 after 62 usecs
[   10.320931] calling  agp_amdk7_init+0x0/0x24 @ 1
[   10.325758] initcall agp_amdk7_init+0x0/0x24 returned 0 after 66 usecs
[   10.332484] calling  agp_amd64_mod_init+0x0/0xa @ 1
[   10.338189] initcall agp_amd64_mod_init+0x0/0xa returned -19 after 664 usecs
[   10.345454] calling  agp_efficeon_init+0x0/0x39 @ 1
[   10.350543] initcall agp_efficeon_init+0x0/0x39 returned 0 after 63 usecs
[   10.357539] calling  agp_intel_init+0x0/0x24 @ 1
[   10.362363] initcall agp_intel_init+0x0/0x24 returned 0 after 66 usecs
[   10.369091] calling  agp_nvidia_init+0x0/0x24 @ 1
[   10.373997] initcall agp_nvidia_init+0x0/0x24 returned 0 after 59 usecs
[   10.380813] calling  agp_sis_init+0x0/0x24 @ 1
[   10.385457] initcall agp_sis_init+0x0/0x24 returned 0 after 65 usecs
[   10.392007] calling  agp_serverworks_init+0x0/0x24 @ 1
[   10.397365] initcall agp_serverworks_init+0x0/0x24 returned 0 after 64 usecs
[   10.404630] calling  agp_via_init+0x0/0x24 @ 1
[   10.409272] initcall agp_via_init+0x0/0x24 returned 0 after 62 usecs
[   10.415821] calling  drm_core_init+0x0/0x107 @ 1
[   10.420637] [drm] Initialized drm 1.1.0 20060810
[   10.425394] initcall drm_core_init+0x0/0x107 returned 0 after 4709 usecs
[   10.432299] calling  cn_proc_init+0x0/0x33 @ 1
[   10.436880] initcall cn_proc_init+0x0/0x33 returned 0 after 3 usecs
[   10.443339] calling  topology_sysfs_init+0x0/0x60 @ 1
[   10.448730] initcall topology_sysfs_init+0x0/0x60 returned 0 after 183 usecs
[   10.455995] calling  loop_init+0x0/0x12b @ 1
[   10.466491] loop: module loaded
[   10.469729] initcall loop_init+0x0/0x12b returned 0 after 9124 usecs
[   10.476279] calld_init+0x0/0x1c @ 1
[   10.508319] initcall mac_hid_init+0x0/0x1c returned 0 after 13 usecs
[   10.514863] calling  macvlan_init_module+0x0/0x31 @ 1
[   10.520065] initcall macvlan_init_module+0x0/0x31 returned 0 after 1 usecs
[   10.527146] calling  macvtap_init+0x0/0xd0 @ 1
[   10.531761] initcall macvtap_init+0x0/0xd0 returned 0 after 39 usecs
[   10.538309] calling  net_olddevs_init+0x0/0x88 @ 1
[   10.543242] initcall net_olddevs_init+0x0/0x88 returned 0 after 2 usecs
[   10.550054] calling  fixed_mdio_bus_init+0x0/0xe3 @ 1
[   10.555461] libphy: Fixed MDIO Bus: probed
[   10.559676] initcall fixed_mdio_bus_init+0x0/0xe3 returned 0 after 4322 usecs
[   10.567026] calling  tun_init+0x0/0x8b @ 1
[   10.571240] tun: Universal TUN/TAP device driver, 1.6
[   10.576438] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.582944] initcall tun_init+0x0/0x8b returned 0 after 11439 usecs
[   10.589405] calling  tg3_driver_init+0x0/0x16 @ 1
[   10.594366] initcall tg3_driver_init+0x0/0x16 returned 0 after 112 usecs
[   10.601272] calling  ixgbevf_init_module+0x0/0x49 @ 1
[   10.606476] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.12.1-k
[   10.616148] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   10.622535] initcall ixgbevf_init_module+0x0/0x49 returned 0 after 15696 usecs
[   10.629973] calling  forcedeth_pci_driver_init+0x0/0x16 @ 1
[   10.635779] initcall forcedeth_pci_driver_init+0x0/0x16 returned 0 after 67 usecs
[   10.643490] calling  netback_init+0x0/0x81 @ 1
[   10.648064] initcall netback_init+0x0/0x81 returned -19 after 0 usecs
[   10.654698] calling  fw_core_init+0x0/0xf1 @ 1
[   10.659471] initcall fw_core_init+0x0/0xf1 returned 0 after 187 usecs
[   10.666110] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[   10.671309] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 0 usecs
[   10.678388] calling  yenta_cardbus_driver_init+0x0/0x16 @ 1
[   10.684234] initcall yenta_cardbus_driver_init+0x0/0x16 returned 0 after 107 usecs
[   10.692028] calling  mon_init+0x0/0xe1 @ 1
[   10.696447] initcall mon_init+0x0/0xe1 returned 0 after 198 usecs
[   10.702724] calling  ehci_hcd_init+0x0/0x58 @ 1
[   10.707386] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.714105] initcall ehci_hcd_init+0x0/0x58 returned 0 after 6567 usecs
[   10.720917] calling  ehci_pci_init+0x0/0x60 @ 1
[   10.725578] ehci-pci: EHCI PCI platform driver
[   10.731927] IOAPIC[0]: Set routing entry (4-17 -> 0x42 -> IRQ 17 Mode:1 Active:1 Dest:15)
[   10.740348] ehci-pci 0000:00:12.2: assigned new IRQ17
[   10.745560] QUIRK: Enable AMD PLL fix
[   10.749357] ehci-pci 0000:00:12.2: EHCI Host Controller
[   10.754995] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[   10.762620] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   10.771576] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[   10.779290] ehci-pci 0000:00:12.2: debug port 1
[   10.784080] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe6ff800
[   10.795563] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   10.801795] usb usb1: New USB device found, idVendor=1d6b, stream-01669-g4f5f437 ehci_hcd
[   10.829215] usb usb1: SerialNumber: 0000:00:12.2
[   10.834924] hub 1-0:1.0: USB hub found
[   10.838846] hub 1-0:1.0: 6 ports detected
[   10.846004] ehci-pci 0000:00:13.2: assigned new IRQ19
[   10.851247] ehci-pci 0000:00:13.2: EHCI Host Controller
[   10.856909] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[   10.864548] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   10.873515] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[   10.881231] ehci-pci 0000:00:13.2: debug port 1
[   10.886028] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe6ff400
[   10.892474] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   10.898692] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   10.905684] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.913120] usb usb2: Product: EHCI Host Controller
[   10.918140] usb usb2: Manufacturer: Linux 3.16.0-rc5upstream-01669-g4f5f437 ehci_hcd
[   10.926111] usb usb2: SerialNumber: 0000:00:13.2
[   10.931796] hub 2-0:1.0: USB hub found
[   10.935733] hub 2-0:1.0: 6 ports detected
[   10.941264] initcall ehci_pci_init+0x0/0x60 returned 0 after 210827 usecs
[   10.948264] calling  ohci_hcd_mod_init+0x0/0x5e @ 1
[   10.953285] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.959656] initcall ohci_hcd_mod_init+0x0/0x5e returned 0 after 6226 usecs
[   10.966825] calling  ohci_pci_init+0x0/0x60 @ 1
[   10.971487] ohci-pci: OHCI PCI platform driver
[   10.977786] IOAPIC[0]: Set routing entry (4-16 -> 0x52 -> IRQ 16 Mode:1 Active:1 Dest:15)
[   10.986207] ohci-pci 0000:00:12.0: assigned new IRQ16
[   10.991442] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   10.997457] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[   11.005213] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe6fe000
[   11.065648] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   11.072656] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.080100] usb usb3: Product: OHCI PCI host controller
[   11.085483] usb usb3: Manufacturer: Linux 3.16.0-rc5upstream-01669-g4f5f437 ohci_hcd
[   11.093458] usb usb3: SerialNumber: 0000:00:12.0
[   11.099160] hub 3-0:1.0: USB hub found
[   11.103095] hub 3-0:1.0: 3 ports detected
[   11.109823] ohci-pci 0000:00:12.1: assigned new IRQ16
[   11.115057] ohci-pci 0000:00:12.1: OHCI PCI host controller
[   11.121069] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 4
[   11.128757] ohci-pci 0000:00:12.1: irq 16, io mem 0xfe6fd000
[   11.189547] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   11.196540] usb usb4: New USB device strings: Mub found
[   11.226943] hub 4-0:1.0: 3 ports detected
[   11.233669] ohci-pci 0000:00:13.0: assigned new IRQ18
[   11.238903] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   11[   11.313410] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   11.320417] usb usb5: New USB device strings: Mt=2, SerialNumber=1
[   11.327857] usb usb5: Product: OHCI PCI host controller
[   11.333244] usb usb5: Manufacturer: Linux 3.16.0-rc5upstream-01669-g4f5f437 ohci_hcd
[   11.341221] usb usb5: SerialNumber: 0000:00:13.0
[   11.346919] hub 5-0:1.0: USB hub found
[   11.350860] hub 5-0:1.0: 3 ports detected
[   11.357625] ohci-pci 0000:00:13.1: assigned new IRQ18
[   11.362861] ohci-pci 0000:00:13.1: OHCI PCI host controller
[   11[   11.437311] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   11.444302] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.451737] usb usb6: Product: OHCI PCI host controller
[   11.457115] usb usb6: Manufacturer: Linux 3.16.0-rc5upstream-01669-g4f5f437 ohci_hcd
[   11.465087] usb usb6: SerialNumber: 0000:00:13.1
[   11.470763] hub 6-0:1.0: USB hub found
[   11.474702] hub 6-0:1.0: 3 ports detected
[   11.481425] ohci-pci 0000:00:14.5: assigned new IRQ18
[   11.486659] ohci-pci 0000:00:14.5: OHCI PCI host controller
[   1100
[   11.561172] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   11.568179] usb usb7: New USB device strings: M-rc5upstream-01669-g4f5f437 ohci_hcd
[   11.588972] usb usb7: SerialNumber: 0000:00:14.5
[   11.594664] hub 7-0:1.0: USB hub found
[   11.598597] hub 7-0:1.0: 2 ports detected
[   11.603522] initcall ohci_pci_init+0x0/0x60 returned 0 after 617800 usecs
[   11.610513] calling  uhci_hcd_init+0x0/0xa4 @ 1
[   11.615175] uhci_hcd: USB Universal Host Controller Interface driver
[   11.621859] initcall uhci_hcd_init+0x0/0xa4 returned 0 after 6532 usecs
[   11.628670] calling  usblp_driver_init+0x0/0x16 @ 1
[   11.633803] usbcore: registered new interface driver usblp
[   11.639447] initcall usblp_driver_init+0x0/0x16 returned 0 after 5619 usecs
[   11.646616] calling  kgdbdbgp_start_thread+0x0/0x57 @ 1
[   11.651994] initcall kgdbdbgp_start_thread+0x0/0x57 returned 0 after 0 usecs
[   11.659253] calling  i8042_init+0x0/0x3b7 @ 1
[   11.663885] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   11.671699] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.676820] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.682051] initcall i8042_init+0x0/0x3b7 returned 0 after 17900 usecs
[   11.688774] calling  serport_init+0x0/0x2e @ 1
[   11.693353] initcall serport_init+0x0/0x2e returned 0 after 0 usecs
[   11.699805] calling  mousedev_init+0x0/0x54 @ 1
[   11.704690] mousedev: PS/2 mouse device common for all mice
[   11.710443] initcall mousedev_init+0x0/0x54 returned 0 after 5831 usecs
[   11.717268] calling  evdev_init+0x0/0xf @ 1
[   11.721868] initcall evdev_init+0x0/0xf returned 0 after 288 usecs
[   11.728250] calling  atkbd_init+0x0/0x20 @ 1
[   11.732738] initcall atkbd_init+0x0/0x20 returned 0 after 71 usecs
[   11.739124] calling  psmouse_init+0x0/0x8a @ 1
[   11.743916] initcall psmouse_init+0x0/0x8a returned 0 after 191 usecs
[   11.750560] calling  cmos_init+0x0/0x66 @ 1
[   11.754917] rtc_cmos 00:01: RTC can wake from S4
[   11.760114] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[   11.766436] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   11.774357] initcall cmos_init+0x0/0x66 returned 0 after 19052 usecs
[   11.780900] calling  i2c_i801_init+0x0/0x92 @ 1
[   11.785674] initcall i2c_i801_init+0x0/0x92 returned 0 after 107 usecs
[   11.792398] calling  cpufreq_gov_dbs_init+0x0/0xf @ 1
[   11.797596] initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 0 usecs
[   11.804679] calling  efivars_sysfs_init+0x0/0x1d0 @ 1
[   11.809878] initcall efivars_sysfs_init+0x0/0x1d0 returned -19 after 0 usecs
[   11.817138] calling  efivars_pstore_init+0x0/0x89 @ 1
[   11.822339] initcall efivars_pstore_init+0x0/0x89 returned 0 after 0 usecs
[   11.829421] calling  vhost_net_init+0x0/0x20 @ 1
[   11.834300] initcall vhost_net_init+0x0/0x20 returned 0 after 124 usecs
[   11.841120] calling  vhost_init+0x0/0x7 @ 1
[   11.845426] initcall vhost_init+0x0/0x7 returned 0 after 0 usecs
[   11.851613] calling  staging_init+0x0/0x7 @ 1
[   11.856096] initcall staging_init+0x0/0x7 returned 0 after 0 usecs
[   11.862465] calling  eeepc_laptop_init+0x0/0x4f @ 1
[   11.867633] initcall eeepc_laptop_init+0x0/0x4f returned -19 after 143 usecs
[   11.874894] calling  sock_diag_init+0x0/0xf @ 1
[   11.879579] initcall sock_diag_init+0x0/0xf returned 0 after 20 usecs
[   11.886212] calling  llc_init+0x0/0x1b @ 1
[   11.890428] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[   11.896525] calling  snap_init+0x0/0x35 @ 1
[   11.900832] initcall snap_init+0x0/0x35 returned 0 after 2 usecs
[   11.907020] calling  blackhole_module_init+0x0/0xf @ 1
[   11.912308] initcall blackhole_module_init+0x0/0xf returned 0 after 0 usecs
[   11.919479] calling  nfnetlink_init+0x0/0x4b @ 1
[   11.924233] Netfilter messages via NETLINK v0.30.
[   11.929087] initcall nfnetlink_init+0x0/0x4b returned 0 after 4744 usecs
[   11.935990] calling  nfnetlink_log_init+0x0/0x8f @ 1
[   11.941113] initcall nfnetlink_log_init+0x0/0x8f returned 0 after 11 usecs
[   11.948193] calling  nf_conntrack_standalone_init+0x0/0x70 @ 1
[   11.954198] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.960687] initcall nf_conntrack_standalone_init+0x0/0x70 returned 0 after 6342 usecs
[   11.968843] calling  ctnetlink_init+0x0/0x92 @ 1
[   11.973594] ctnetlink v0.93: registering with nfnetlink.
[   11.979064] initcall ctnetlink_init+0x0/0x92 returned 0 after 5345 usecs
[   11.985965] calling  nf_conntrack_ftp_init+0x0/0x195 @ 1
[   11.991439] initcall nf_conntrack_ftp_init+0x0/0x195 returned 0 after 6 usecs
[   11.998788] calling  nf_conntrack_irc_init+0x0/0x148 @ 1
[   12.004262] initcall nf_conntrack_irc_init+0x0/0x148 returned 0 after 5 usecs
[   12.011611] calling  nf_conntrack_sip_init+0x0/0x1e4 @ 1
[   12.017080] initcall nf_conntrack_sip_init+0x0/0x1e4 returned 0 after 0 usecs
[   12.024429] calling  xt_init+0x0/0xb5 @ 1
[   12.028558] initcall xt_init+0x0/0xb5 returned 0 after 2 usecs
[   12.034565] calling  tcpudp_mt_init+0x0/0x14 @ 1
[   12.039321] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 0 usecs
[   12.045955] calling  connsecmark_tg_init+0x0/0xf @ 1
[   12.051066] initcall connsecmark_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.058057] calling  nflog_tg_init+0x0/0xf @ 1
[   12.062630] initcall nflog_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.069085] calling  secmark_tg_init+0x0/0xf @ 1
[   12.073838] initcall secmark_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.080471] calling  tcpmss_tg_init+0x0/0x14 @ 1
[   12.085224] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 0 usecs
[   12.091856] calling  conntrack_mt_init+0x0/0x14 @ 1
[   12.096878] initcall conntrack_mt_init+0x0/0x14 returned 0 after 0 usecs
[   12.103781] calling  policy_mt_init+0x0/0x14 @ 1
[   12.108533] initcall policy_mt_init+0x0/0x14 returned 0 after 0 usecs
[   12.115166] calling  state_mt_init+0x0/0xf @ 1
[   12.119739] initcall state_mt_init+0x0/0xf returned 0 after 0 usecs
[   12.126195] calling  gre_offload_init+0x0/0x14 @ 1
[   12.131125] initcall gre_offload_init+0x0/0x14 returned 0 after 0 usecs
[   12.137936] calling  sysctl_ipv4_init+0x0/0x44 @ 1
[   12.142911] initcall sysctl_ipv4_init+0x0/0x44 returned 0 after 43 usecs
[   12.149814] calling  tunnel4_init+0x0/0x6d @ 1
[   12.154386] initcall tunnel4_init+0x0/0x6d returned 0 after 0 usecs
[   12.160839] calling  ipv4_netfilter_init+0x0/0xf @ 1
[   12.165950] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 0 usecs
[   12.172941] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x150 @ 1
[   12.179393] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x150 returned 0 after 175 usecs
[   12.187724] calling  nf_defrag_init+0x0/0x14 @ 1
[   12.192475] initcall nf_defrag_init+0x0/0x14 returned 0 after 0 usecs
[   12.199108] calling  ip_tables_init+0x0/0x8f @ 1
[   12.203880] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.209347] initcall ip_tables_init+0x0/0x8f returned 0 after 5364 usecs
[   12.216249] calling  iptable_filter_init+0x0/0x40 @ 1
[   12.221545] initcall iptable_filter_init+0x0/0x40 returned 0 after 93 usecs
[   12.228715] calling  iptable_mangle_init+0x0/0x40 @ 1
[   12.233992] initcall iptable_mangle_init+0x0/0x40 returned 0 after 75 usecs
[   12.241161] calling  reject_tg_init+0x0/0xf @ 1
[   12.245824] initcall reject_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.252366] calling  ulog_tg_init+0x0/0x74 @ 1
[   12.256957] initcall ulog_tg_init+0x0/0x74 returned 0 after 16 usecs
[   12.263501] calling  cubictcp_register+0x0/0x72 @ 1
[   12.268520] TCP: cubic registered
[   12.271929] initcall cubictcp_register+0x0/0x72 returned 0 after 3332 usecs
[   12.279099] calling  xfrm_user_init+0x0/0x43 @ 1
[   12.283851] Initializing XFRM netlink socket
[   12.288259] initcall xfrm_user_init+0x0/0x43 returned 0 after 4308 usecs
[   12.295161] calling  inet6_init+0x0/0x2c3 @ 1
[   12.299897] NET: Registered protocol family 10
[   12.305254] initcall inet6_init+0x0/0x2c3 returned 0 after 5481 usecs
[   12.311892] calling  ah6_init+0x0/0x75 @ 1
[   12.316110] initcall ah6_init+0x0/0x75 returned 0 after 1 usecs
[   12.322207] calling  esp6_init+0x0/0x75 @ 1
[   12.326511] initcall esp6_init+0x0/0x75 returned 0 after 0 usecs
[   12.332697] calling  xfrm6_transport_init+0x0/0x14 @ 1
[   12.337985] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 0 usecs
[   12.345155] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
[   12.350622] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after 0 usecs
[   12.357970] calling  xfrm6_beet_init+0x0/0x14 @ 1
[   12.362811] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 0 usecs
[   12.369532] calling  ip6_tables_init+0x0/0x8f @ 1
[   12.374395] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.379952] initcall ip6_tables_init+0x0/0x8f returned 0 after 5452 usecs
[   12.386943] calling  ip6table_filter_init+0x0/0x40 @ 1
[   12.392389] initcall ip6table_filter_init+0x0/0x40 returned 0 after 153 usecs
[   12.399739] calling  ip6table_mangle_init+0x0/0x40 @ 1
[   12.405164] initcall ip6table_mangle_init+0x0/0x40 returned 0 after 133 usecs
[   12.412514] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x129 @ 1
[   12.418797] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x129 returned 0 after 11 usecs
[   12.427039] calling  nf_defrag_init+0x0/0x4c @ 1
[   12.431815] initcall nf_defrag_init+0x0/0x4c returned 0 after 22 usecs
[   12.438537] calling  ipv6header_mt6_init+0x0/0xf @ 1
[   12.443646] initcall ipv6header_mt6_init+0x0/0xf returned 0 after 0 usecs
[   12.450635] calling  reject_tg6_init+0x0/0xf @ 1
[   12.455386] initcall reject_tg6_init+0x0/0xf returned 0 after 0 usecs
[   12.462020] calling  sit_init+0x0/0xbc @ 1
[   12.466234] sit: IPv6 over IPv4 tunneling driver
[   12.471881] initcall sit_init+0x0/0xbc returned 0 after 5518 usecs
[   12.478245] calling  packet_init+0x0/0x39 @ 1
[   12.482728] NET: Registered protocol family 17
[   12.487310] initcall packet_init+0x0/0x39 returned 0 after 4478 usecs
[   12.493941] calling  br_init+0x0/0x90 @ 1
[   12.498107] initcall br_init+0x0/0x90 returned 0 after 37 usecs
[   12.504204] calling  init_rpcsec_gss+0x0/0x54 @ 1
[   12.509107] initcall init_rpcsec_gss+0x0/0x54 returned 0 after 59 usecs
[   12.515919] calling  dcbnl_init+0x0/0x5e @ 1
[   12.520314] initcall dcbnl_init+0x0/0x5e returned 0 after 0 usecs
[   12.526588] calling  init_dns_resolver+0x0/0xcd @ 1
[   12.531619] Key type dns_resolver registered
[   12.536013] initcall init_dns_resolver+0x0/0xcd returned 0 after 4305 usecs
[   12.543182] calling  mcheck_init_device+0x0/0x174 @ 1
[   12.549281] initcall mcheck_init_device+0x0/0x174 returned 0 after 876 usecs
[   12.556588] calling  mcheck_debugfs_init+0x0/0x3e @ 1
[   12.561808] initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 19 usecs
[   12.568979] calling  severities_debugfs_init+0x0/0x3e @ 1
[   12.574539] initcall severities_debugfs_init+0x0/0x3e returned 0 after 5 usecs
[   12.581976] calling  threshold_init_device+0x0/0x44 @ 1
[   12.587875] initcall threshold_init_device+0x0/0x44 returned 0 after 510 usecs
[   12.595314] calling  hpet_insert_resource+0x0/0x1e @ 1
[   12.600604] initcall hpet_insert_resource+0x0/0x1e returned 0 after 0 usecs
[   12.607785] calling  update_mp_table+0x0/0x527 @ 1
[   12.612716] initcall update_mp_table+0x0/0x527 returned 0 after 0 usecs
[   12.619529] calling  lapic_insert_resource+0x0/0x46 @ 1
[   12.624907] initcall lapic_insert_resource+0x0/0x46 returned 0 after 0 usecs
[   12.632167] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   12.637454] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 usecs
[   12.644624] calling  print_ICs+0x0/0x437 @ 1
[   12.649017] 
[   12.649017] printing PIC contents
[   12.653949] ... PIC  IMR: ffff
[   12.657089] ... PIC  IRR: 0001
[   12.660236] ... PIC  ISR: 0000
[   12.663379] ... PIC ELCR: ce90
[   12.666529] printing local APIC contents on CPU#0/0:
[   12.671637] ... APIC ID:      00000000 (0)
[   12.675850] ... APIC VERSION: 80050010
[   12.679705] ... APIC TASKPRI: 00000000 (00)
[   12.684006] ... APIC ARBPRI: 00000030 (30)
[   12.688217] ... APIC PROCPRI: 00000000
[   12.692071] ... APIC LDR: 01000000
[   12.695568] ... APIC DFR: ffffffff
[   12.699064] ... APIC SPIV: 000001ff
[   12.702650] ... APIC ISR field:
[   12.705878] 0000000000000000000000000000000000000000000000000000000000000000
[   12.713198] ... APIC TMR field:
[   12.716425] 0000000000000000000000000000000000000000000000000000000000000000
[   12.723746] ... APIC IRR field:
[   12.726974] 0000000000010000000000000000000000000000000000000000000000000000
[   12.734292] ... APIC ESR: 00000000
[   12.737789] ... APIC ICR: 000208ef
[   12.741285] ... APIC ICR2: 06000000
[   12.744871] ... APIC LVTT: 000000ef
[   12.748457] ... APIC LVTPC: 00000400
[   12.752133] ... APIC LVT0: 00010700
[   12.755719] ... APIC LVT1: 00000400
[   12.759304] ... APIC LVTERR: 000000fe
[   12.763068] ... APIC TMICT: 00000000
[   12.766743] ... APIC TMCCT: 00000000
[   12.770418] ... APIC TDCR: 00000003
[   12.774004] ... APIC EFEAT: 00040007
[   12.777681] ... APIC ECTRL: 00000000
[   12.781357] ... APIC EILVT0: 000000f9
[   12.785121] ... APIC EILVT1: 00000400
[   12.788885] ... APIC EILVT2: 00010000
[   12.792649] ... APIC EILVT3: 00010000
[   12.796413] 
[   12.797944] number of MP IRQ sources: 15.
[   12.802076] number of IO-APIC #4 registers: 24.
[   12.806738] testing the IO APIC.......................
[   12.812030] IO APIC #4......
[   12.814991] .... register #00: 04000000
[   12.818938] .......    : physical APIC id: 04
[   12.823420] .......    : Delivery Type: 0
[   12.827545] .......    : LTS          : 0
[   12.831671] .... register #01: 00178021
[   12.835618] .......     : max redirection entries: 17
[   12.840816] .......     : PRQ implemented: 1
[   12.845209] .......     : IO APIC version: 21
[   12.849692] .... register #02: 04000000
[   12.853638] .......     : arbitration: 04
[   12.857762] .... register #03: 04178021
[   12.861708] .......     : Boot DT    : 1
[   12.865742] .... IRQ redirection table:
[   12.869690] 1    0    0   0   0    0    0    00
[   12.874355] 0    0    0   0   0    1    1    31
[   12.879019] 0    0    0   0   0    1    1    30
[   12.883683] 0    0    0   0   0    1    1    33
[   12.888345] 0    0    0   0   0    1    1    34
[   12.893010] 0    0    0   0   0    1    1    35
[   12.897674] 0    0    0   0   0    1    1    36
[   12.902338] 0    0    0   0   0    1    1    37
[   12.907002] 0    0    0   0   0    1    1    38
[   12.911667] 0    1    0   1   0    1    1    39
[   12.916332] 0    0    0   0   0    1    1    3A
[   12.920996] 0    0    0   0   0    1    1    3B
[   12.925661] 0    0    0   0   0    1    1    3C
[   12.930324] 0    0    0   0   0    1    1    3D
[   12.934989] 0    0    0   0   0    1    1    3E
[   12.939653] 0    0    0   0   0    1    1    3F
[   12.944318] 0    1    0   1   0    1    1    52
[   12.948983] 0    1    0   1   0    1    1    42
[   12.953648] 0    1    0   1   0    1    1    B1
[   12.955466] random: nonblocking pool is initialized
[   12.963331] 0    1    0   1   0    1    1    D1
[   12.967994] 1    0    0   0   0    0    0    00
[   12.972657] 1    0    0   0   0    0    0    00
[   12.977321] 1    1    0   1   0    1    1    22
[   12.981985] 1    0    0   0   0    0    0    00
[   12.986647] IRQ to pin mappings:
[   12.989968] IRQ0 -> 0:2
[   12.992503] IRQ1 -> 0:1
[   12.995035] IRQ3 -> 0:3
[   12.997567] IRQ4 -> 0:4
[   13.000099] IRQ5 -> 0:5
[   13.002632] IRQ6 -> 0:6
[   13.005162] IRQ7 -> 0:7
[   13.007697] IRQ8 -> 0:8
[   13.010228] IRQ9 -> 0:9
[   13.012759] IRQ10 -> 0:10
[   13.015472] IRQ11 -> 0:11
[   13.018185] IRQ12 -> 0:12
[   13.020896] IRQ13 -> 0:13
[   13.023610] IRQ14 -> 0:14
[   13.026321] IRQ15 -> 0:15
[   13.029030] IRQ16 -> 0:16
[   13.031740] IRQ17 -> 0:17
[   13.034454] IRQ18 -> 0:18
[   13.037169] IRQ19 -> 0:19
[   13.039883] IRQ22 -> 0:22
[   13.042595] .................................... done.
[   13.047886] initcall print_ICs+0x0/0x437 returned 0 after 389886 usecs
[   13.054610] calling  print_ipi_mode+0x0/0x2e @ 1
[   13.059364] Using IPI No-Shortcut mode
[   13.063221] initcall print_ipi_mode+0x0/0x2e returned 0 after 3769 usecs
[   13.070122] calling  pat_memtype_list_init+0x0/0x37 @ 1
[   13.075506] initcall pat_memtype_list_init+0x0/0x37 returned 0 after 6 usecs
[   13.082765] calling  init_oops_id+0x0/0x50 @ 1
[   13.087341] initcall init_oops_id+0x0/0x50 returned 0 after 2 usecs
[   13.093793] calling  pm_qos_power_init+0x0/0x5d @ 1
[   13.099166] initcall pm_qos_power_init+0x0/0x5d returned 0 after 345 usecs
[   13.106249] calling  pm_debugfs_init+0x0/0x2a @ 1
[   13.111098] initcall pm_debugfs_init+0x0/0x2a returned 0 after 7 usecs
[   13.117820] calling  printk_late_init+0x0/0x38 @ 1
[   13.122751] initcall printk_late_init+0x0/0x38 returned 0 after 1 usecs
[   13.129563] calling  tk_debug_sleep_time_init+0x0/0x41 @ 1
[   13.135215] initcall tk_debug_sleep_time_init+0x0/0x41 returned 0 after 6 usecs
[   13.142740] calling  debugfs_kprobe_init+0x0/0xa6 @ 1
[   13.147964] initcall debugfs_kprobe_init+0x0/0xa6 returned 0 after 25 usecs
[   13.155133] calling  taskstats_init+0x0/0x6e @ 1
[   13.159902] registered taskstats version 1
[   13.164117] initcall taskstats_init+0x0/0x6e returned 0 after 4137 usecs
[   13.171018] calling  clear_boot_tracer+0x0/0x2d @ 1
[   13.176039] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[   13.182938] calling  kdb_ftrace_register+0x0/0x35 @ 1
[   13.188141] initcall kdb_ftrace_register+0x0/0x35 returned 0 after 2 usecs
[   13.195225] calling  fault_around_debugfs+0x0/0x3a @ 1
[   13.200519] initcall fault_around_debugfs+0x0/0x3a returned 0 after 6 usecs
[   13.207688] calling  max_swapfiles_check+0x0/0x7 @ 1
[   13.212797] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 usecs
[   13.219788] calling  set_recommended_min_free_kbytes+0x0/0xb0 @ 1
[   13.226061] initcall set_recommended_min_free_kbytes+0x0/0xb0 returned 0 after 1 usecs
[   13.234215] calling  kmemleak_late_init+0x0/0x8e @ 1
[   13.239386] kmemleak: Kernel memory leak detector initialized
[   13.239389] kmemleak: Automatic memory scanning thread started
[   13.251314] initcall kmemleak_late_init+0x0/0x8e returned 0 after 11712 usecs
[   13.258685] calling  check_early_ioremap_leak+0x0/0x5d @ 1
[   13.264350] initcall check_early_ioremap_leak+0x0/0x5d returned 0 after 0 usecs
[   13.271892] calling  init_root_keyring+0x0/0xa @ 1
[   13.276870] initcall init_root_keyring+0x0/0xa returned 0 after 25 usecs
[   13.283786] calling  fail_make_request_debugfs+0x0/0x23 @ 1
[   13.289585] initcall fail_make_request_debugfs+0x0/0x23 returned 0 after 43 usecs
[   13.297307] calling  prandom_reseed+0x0/0x3e @ 1
[   13.302080] initcall prandom_reseed+0x0/0x3e returned 0 after 0 usecs
[   13.308725] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   13.315199] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 12 usecs
[   13.323627] calling  pci_sysfs_init+0x0/0x44 @ 1
[   13.329681] initcall pci_sysfs_init+0x0/0x44 returned 0 after 1256 usecs
[   13.336592] calling  boot_wait_for_devices+0x0/0x28 @ 1
[   13.341986] initcall boot_wait_for_devices+0x0/0x28 returned -19 after 4 usecs
[   13.349434] calling  deferred_probe_initcall+0x0/0x80 @ 1
[   13.355089] initcall deferred_probe_initcall+0x0/0x80 returned 0 after 86 usecs
[   13.362625] calling  late_resume_init+0x0/0x190 @ 1
[   13.367649]   Magic number: 6:343:85
[   13.371434] initcall late_resume_init+0x0/0x190 returned 0 after 3698 usecs
[   13.378605] calling  firmware_memmap_init+0x0/0x29 @ 1
[   13.384204] initcall firmware_memmap_init+0x0/0x29 returned 0 after 299 usecs
[   13.391557] calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1
[   13.397833] initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 0 usecs
[   13.405991] calling  tcp_congestion_default+0x0/0xf @ 1
[   13.411375] initcall tcp_congestion_default+0x0/0xf returned 0 after 0 usecs
[   13.418639] calling  ip_auto_config+0x0/0xeb7 @ 1
[   13.423493] initcall ip_auto_config+0x0/0xeb7 returned 0 after 8 usecs
[   13.430220] calling  software_resume+0x0/0x280 @ 1
[   13.435156] PM: Hibernation image not present or could not be loaded.
[   13.441789] initcall software_resume+0x0/0x280 returned -2 after 6482 usecs
[   13.449228] async_waiting @ 1
[   13.452286] async_continuing @ 1 after 0 usec
[   13.457058] Freeing unused kernel memory: 940K (c185e000 - c1949000)
[   13.463648] Write protecting the kernel text: 6272k
[   13.468720] Write protecting the kernel read-only data: 1856k
[   13.474635] NX-protecting the kernel data: 3968k
init started: BusyBox v1.14.3 (2014-07-15 12:46:58 EDT)
Mounting directories  [  OK  ]
[   13.489523] uname (1264) used greatest stack depth: 6668 bytes left
[   13.598763] mv (1275) used greatest stack depth: 6628 bytes left
mount: mount poi[   13.613890] mount (1287) used greatest st exist
mount: mount po[   13.624725] mount (1290) used greatest stack depth: 6508 bytes left
int /proc/xen does not exist
^G^G^G^G^G^G^G^G^G^G^G^G^G^Gmount:[   13.637988] udevd (1297): /proc/1297/oom_adj is deprecated, please use /proc/1297/oom_score_adj instead.
 mount point /sys/kernel/config does not exist
cat: /sys/hypervisor/type: No such file or directory
/usr/bin/load_xen_modules: line 3: [: ==: unary operator expected
[   13.675010] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 1346
[   13.682280] acpi-cpufreq: overriding BIOS provideit_scsi+0x0/0x90 [scsi_mod] @ 1370
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^Gudevd-work[1392]: error op[   13.712287] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returned 0 after 29775 usecs
ening ATTR{/sys/[   13.721849] calling  rtl8169_pci_driver_init+0x0/0x1000 [r8169] @ 1374
devices/system/c[   13.729556] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   13.729939] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 1428
pu/cpu0/online} [   13.730559] wmi: Mapper loaded
[   13.730561] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned 0 after 605 usecs
for writing: Per[   13.754350] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
mission denied
[   13.763315] r8169 0000:02:00.0: already assigned IRQ10

[   13.770186] modprobe (1346) used greatest stack depth: 6220 bytes left
[   13.772025] r8169 0000:02:00.0: assigned new IRQ18
[   13.772271] r8169 0000:02:00.0: irq 26 for MSI/MSI-X
[   13.773679] r8169 0000:02:00.0 eth0: RTL8168c/8111c at 0xf8480000, 00:25:11:18:a1:2e, XID 1c4000c0 IRQ 26
[   13.773680] r8169 0000:02:00.0 eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]
[   13.773820] initcall rtl8169_pci_driver_init+0x0/0x1000 [r8169] returned 0 after 43350 usecs
[   13.775374] SCSI subsystem initialized
[   13.775384] initcall init_scsi+0x0/0x90 [scsi_mod] returned 0 after 67052 usecs
[   13.826221] modprobe (1374) used greatest stack depth: 5428 bytes left
[   13.830171] calling  skge_init_module+0x0/0x1000 [skge] @ 1423
[   13.830253] skge 0000:04:05.0: already assigned IRQ4
[   13.830972] IOAPIC[0]: Set routing entry (4-20 -> 0x72 -> IRQ 20 Mode:1 Active:1 Dest:15)
[   13.830975] skge 0000:04:05.0: assigned new IRQ20
[   13.831081] skge: 1.14 addr 0xfebfc000 irq 20 chip Yukon rev 1
[   13.832607] skge 0000:04:05.0 eth1: addr 00:0a:5e:5c:f5:72
[   13.832739] initcall skge_init_module+0x0/0x1000 [skge] returned 0 after 2507 usecs
Waiting for devices [   13.878513] calling  ata_init+0x0/0x295 [libata] @ 1377
[   13.885795] libata version 3.00 loaded.
[   13.885805] initcall ata_init+0x0/0x295 [libata] returned 0 after 7117 usecs
[   13.898615] calling  ata_generic_pci_driver_init+0x0/0x1000 [ata_generic] @ 1377
[   13.906494] initcall ata_generic_pci_driver_init+0x0/0x1000 [ata_generic] returned 0 after 244 usecs
[  OK  ]
[   13.917857] calling  ahci_pci_driver_init+0x0/0x1000 [ahci] @ 1370
[   13.924298] ahci 0000:00:11.0: version 3.0
[   13.924311] ahci 0000:00:11.0: already assigned IRQ15
[   13.926512] ahci 0000:00:11.0: assigned new IRQ22
[   13.926822] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   13.926824] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[   13.933862] scsi0 : ahci
[   13.948183] scsi1 : ahci
[   13.949312] scsi2 : ahci
[   13.950296] scsi3 : ahci
[   13.951253] scsi4 : ahci
[   13.952202] scsi5 : ahci
[   13.952991] ata1: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd00 irq 22
[   13.952993] ata2: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd80 irq 22
[   13.952996] ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe00 irq 22
[   13.952998] ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe80 irq 22
[   13.953001] ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff00 irq 22
[   13.953004] ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff80 irq 22
[   13.953101] ahci 0000:03:00.0: already assigned IRQ11
[   13.955249] ahci 0000:03:00.0: assigned new IRQ19
[   13.955312] ahci 0000:03:00.0: JMB361 has only one port
[   13.955324] ahci 0000:03:00.0: forcing port_map 0x3 -> 0x1
[   13.955420] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
[   13.955422] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio 
[   13.957792] scsi6 : ahci
[   13.958711] scsi7 : ahci
[   13.959494] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe100 irq 19
[   13.959495] ata8: DUMMY
[   13.959649] initcall ahci_pci_driver_init+0x0/0x1000 [ahci] returned 0 after 34623 usecs
[   13.965502] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] returned 0 after 260042 usecs
[   14.009948] calling  ttm_init+0x0/0x1000 [ttm] @ 1389
[   14.010087] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 131 usecs
[   14.076765] calling  fb_console_init+0x0/0x1000 [fbcon] @ 1958
[   14.104242] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 after 26852 usecs
[   14.106015] calling  radeon_init+0x0/0xb0 [radeon] @ 1389
[   14.106016] [drm] radeon kernel modesetting enabled.
[   14.106445] radeon 0000:01:05.0: already assigned IRQ10
[   14.106828] radeon 0000:01:05.0: assigned new IRQ18
[   14.107670] [drm] initializing kernel modesetting (RS780 0x1002:0x9610 0x1019:0x2119).
[   14.107701] [drm] register mmio base: 0xFE8F0000
[   14.107701] [drm] register mmio size: 65536
[   14.108983] ATOM BIOS: 113
[   14.109100] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x00000000CFFFFFFF (256M used)
[   14.109102] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[   14.109107] [drm] Detected VRAM RAM=256M, BAR=256M
[   14.109108] [drm] RAM width 32bits DDR
[   14.109519] [TTM] Zone  kernel: Available graphics memory: 432674 kiB
[   14.109519] [TTM] Zone highmem: Available graphics memory: 1941382 kiB
[   14.109520] [TTM] Initializing pool allocator
[   14.109617] [TTM] Initializing DMA pool allocator
[   14.109826] [drm] radeon: 256M of VRAM memory ready
[   14.109833] [drm] radeon: 512M of GTT memory ready.
[   14.109990] [drm] Loading RS780 Microcode
[   14.110480] [drm] radeon: power management initialized
[   14.110483] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   14.126817] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
[   14.126993] radeon 0000:01:05.0: WB enabled
[   14.126995] radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffc95c00
[   14.127004] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   14.127004] [drm] Driver supports precise vblank timestamp query.
[   14.127006] radeon 0000:01:05.0: Radeon device interrupt IRQ18
[   14.127048] [drm] radeon: irq initialized.
[   14.161062] [drm] ring test on 0 succeeded in 0 usecs
[   14.161339] [drm] ib test on ring 0 succeeded in 0 usecs
[   14.164468] [drm] Radeon Display Connectors
[   14.164468] [drm] Connector 0:
[   14.164469] [drm]   VGA-1
[   14.164470] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[   14.164470] [drm]   Encoders:
[   14.164471] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   14.164471] [drm] Connector 1:
[   14.164471] [drm]   HDMI-A-1
[   14.164472] [drm]   HPD3
[   14.164473] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[   14.164473] [drm]   Encoders:
[   14.164473] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[   14.172707] radeon 0000:01:05.0: No connectors reported connected with modes
[   14.172733] [drm] Cannot find any crtc or sizes - going 1024x768
[   14.186828] [drm] fb mappable at 0xD0141000
[   14.186829] [drm] vram apper at 0xD0000000
[   14.186829] [drm] size 3145728
[   14.186830] [drm] fb depth is 24
[   14.186830] [drm]    pitch is 4096
[   14.258263] ata3: SATA link down (SStatus 0 SControl 300)
[   14.258314] ata5: SATA link down (SStatus 0 SControl 300)
[   14.262265] ata6: SATA link down (SStatus 0 SControl 300)
[   14.265263] ata7: SATA link down (SStatus 0 SControl 300)
[   14.386799] fbcon: radeondrmfb (fb0) is primary device
[   14.399999] Console: switching to colour frame buffer device 128x4onmfb frame buffer device
[   14.425538] radeon 0000:01:05.0: registered panic notifier
^G^G^G^G^G^G^G^G^G^G^G^G^G[   14.440150] [drm] Initialized radeon 2.39.0 20080528 for 0000:01:05.0 on minor 0
[   14.447987] initcall radeon_init+0x0/0xb0 [radeon] returned 0 after 334245 usecs
[   14.491102] ata4: SATA link down (SStatus 0 SControl 300)
[   14.650937] ata2: softreset failed (device not ready)
[   14.656138] ata2: applying PMP SRST workaround and retrying
[   14888] ata1: softreset failed (device not ready)
[   14.667094] ata1: applying PMP SRST workaround and retrying
^G[   14.825782] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.832166] ata1: SATA link up 1.5 Gbps (SStatus 113 S
[   14.853975] ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   14.856083] ata2.00: configured for UDMA/133
[   14.857025] ata1.00: configured for UDMA/133
[   14.857448] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   1G10 PQ: 0 ANSI: 5
[   14.859006] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   1G10 PQ: 0 ANSI: 5
^G^G^G^G^G^G^G^G[   14.895922] modprobe (1370) used greatest stack depth: 5404 bytes left
^G^G^G^G^G^G^G^G[   14.904639] calling  crc_t10dif_mod_init+0x0/0x1000 [crc_t10dif] @ 2549
^G^G^G^G^G^G^G^G[   14.913294] calling  crct10dif_mod_init+0x0/0x1000 [crct10dif_generic] @ 2554
^G^G^G^G^G^G^G^G[   14.920813] initcall crct10dif_mod_init+0x0/0x1000 [crct10dif_generic] returned 0 after 72 usecs
^G^G^G^G^G^G^G^G[   14.932141] initcall crc_t10dif_mod_init+0x0/0x1000 [crc_t10dif] returned 0 after 19732 usecs
^G^G^G^G^G^G^G^G[   14.942552] calling  init_sd+0x0/0x1000 [sd_mod] @ 2549
[   14.949182] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[   14.949541] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 1290 usecs
[   14.949635] sd 1:0:0:0: [sdb] 156250000 512-byte logical blocks: (80.0 GB/74.5 GiB)
[   14.949896] sd 1:0:0:0: [sdb] Write Protect is off
[   14.949898] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   14.949998] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.975458]  sdb: sdb1
[   14.976723] sd 1:0:0:0: [sdb] Attached SCSI disk
[   14.999076] sd 0:0:0:0: [sda] Write Protect is off
[   15.004037] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.009362] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.053396]  sda: sda1 sda2 < sda5 >
[   15.059082] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.066299] calling  init_sg+0x0/0x1000 [sg] @ 2573
[   15.071748] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.077563] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   15.083104] initcall init_sg+0x0/0x1000 [sg] returned 0 after 11496 usecs
Waiting for init.pre_custom [  OK  ]
Waiting for fb [  OK  ]
Waiting for network [  OK  ]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [   15.307607] r8169 0000:02:00.0 eth0: link down
[   15.307622] r8169 0000:02:00.0 eth0: link down
[   15.316804] IPv6: ADDRCady
^G^G^G^G^G^G^G^G^G[   15.324819] device eth0 entered promiscuous mode
[  OK  ]
Bringing up interface eth1:  
Determining IP information for e[   15.361350] skge 0000:04:05.0 eth1: enabling interface
th1...[   15.374652] IPv6: ADDRCONFG^G^G^G^G^G[   17.608867] r8169 0000:02:00.0 eth0: link up
[   17.613269] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.705312] skge 0000:04:05.0 eth1: Link is up at 1000 Mbps, full duplex, flow control both
[   18.713916] IPv6: ADDRCONF(NEomes ready
^G^G^G^G^G^G^G done.
[  OK  ]
Bringing up interface switch:  
Determining IP information for s[   21.847151] switch: port 1(eth0) entered forwarding state
w1(eth0) entered forwarding state
^G^G^G^G^G^G^G^G^G done.
[  OK  ]
touch: cannot touch `/var/lock/subsys/network': No such file or directory
Waiting for init.custom [  OK  ]

Starting SSHd ...

    SSH started [2998]


Waiting for SSHd [  OK  ]
WARNING: ssh currently running [2998] ignoring start request
[   24.227539] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @ 3034
[   24.234719] initcall crc32c_intel_mod_init+0x@ 3034
[   24.254672] ttyS0: 3 input overrun(s)
[   24.254696] initcall crc32c_mod_init+0x0/0x1000 [crc32c_generic] returned 0 after 126 usecs
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   24.268757] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 3039
[   24.276561] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned 0 after 6 usecs
[   24.287383] calling  iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] @ 3041
[   24.295179] Loading iSCSI transport class v2.0-870.
[   24.300850] initcall iscsi_transport_init+0x0/0x1000 [scsi_transport_iscsi] returned 0 after 5538 usecs
[   24.313214] calling  iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] @ 3041
[   24.319963] iscsi: registered transport (tcp)
[   24.324452] initcall iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] returned 0 after 4570 usecs
Could not read fw values.
Jul 15 16:05:10 tst034 syslogd 1.5.0: restart.
[0:0:0:0]    disk    ATA      Maxtor 6L080M0   1G10 ^G00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
00:07.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 3)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Graphics
01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
03:00.0 SATA controller: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)
03:00.1 IDE interface: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)
04:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 10)
04:07.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01)
           CPU0       CPU1       CPU2       CPU3       
  0:      10841          0          0          0   IO-APIC-edge      timer
  1:          0          0          0          2   IO-APIC-edge      i8042
  8:          1          0         16         46   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4   IO-APIC-edge      i8042
 16:          0          0          0          2   IO-APIC  16-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4
 17:          0          0          0          0   IO-APIC  17-fasteoi   ehci_hcd:usb1
 18:          0          0          0          6   IO-APIC  18-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, radeon
 19:          0          0          0          0   IO-APIC  19-fasteoi   ehci_hcd:usb2, ahci
 20:          0          0          8         17   IO-APIC  20-fasteoi   eth1
 22:          0          1         11        186   IO-APIC  22-fasteoi   serial, ahci
 26:          1          0          2        129   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:       1982       7383       6983       8933   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       2318       2461       2445       2118   Rescheduling interrupts
CAL:        373        175        369        384   Function call interrupts
TLB:         50         77         89        101   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
THR:          0          0          0          0   Hypervisor callback interrupts
ERR:          0
MIS:          0
00000000-00000fff : reserved
00001000-0009f3ff : System RAM
0009f400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000cebff : Video ROM
000cf000-000d09ff : Adapter ROM
000d1000-000d1fff : Adapter ROM
000d5000-000d57ff : Adapter ROM
000e6000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-cfeaffff : System RAM
  01000000-0161f626 : Kernel code
  0161f627-0185cbbf : Kernel data
  01950000-01a29fff : Kernel bss
cfeb0000-cfebdfff : ACPI Tables
cfebe000-cfedffff : ACPI Non-volatile Storage
cfee0000-cfefffff : reserved
cff00000-dfffffff : PCI Bus 0000:00
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:05.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:05
f0000000-febfffff : PCI Bus 0000:00
  fdf00000-fdffffff : PCI Bus 0000:02
    fdff0000-fdffffff : 0000:02:00.0
      fdff0000-fdffffff : r8169
  fe6f6000-fe6f6fff : 0000:00:14.5
    fe6f6000-fe6f6fff : ohci_hcd
  fe6f7000-fe6f7fff : 0000:00:13.1
    fe6f7000-fe6f7fff : ohci_hcd
  fe6fc000-fe6fcfff : 0000:00:13.0
    fe6fc000-fe6fcfff : ohci_hcd
  fe6fd000-fe6fdfff : 0000:00:12.1
    fe6fd000-fe6fdfff : ohci_hcd
  fe6fe000-fe6fefff : 0000:00:12.0
    fe6fe000-fe6fefff : ohci_hcd
  fe6ff400-fe6ff4ff : 0000:00:13.2
    fe6ff400-fe6ff4ff : ehci_hcd
  fe6ff800-fe6ff8ff : 0000:00:12.2
    fe6ff800-fe6ff8ff : ehci_hcd
  fe6ffc00-fe6fffff : 0000:00:11.0
    fe6ffc00-fe6fffff : ahci
  fe700000-fe8fffff : PCI Bus 0000:01
    fe700000-fe7fffff : 0000:01:05.0
    fe8e8000-fe8ebfff : 0000:01:05.1
    fe8f0000-fe8fffff : 0000:01:05.0
  fe900000-fe9fffff : PCI Bus 0000:02
    fe9c0000-fe9dffff : 0000:02:00.0
    fe9ff000-fe9fffff : 0000:02:00.0
      fe9ff000-fe9fffff : r8169
  fea00000-feafffff : PCI Bus 0000:03
    feafe000-feafffff : 0000:03:00.0
      feafe000-feafffff : ahci
  feb00000-febfffff : PCI Bus 0000:04
    febc0000-febdffff : 0000:04:05.0
    febfc000-febfffff : 0000:04:05.0
      febfc000-febfffff : skge
fec00000-fec003ff : IOAPIC 0
fec10000-fec1001f : pnp 00:03
fed00000-fed003ff : HPET 2
  fed00000-fed003ff : PNP0103:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:02
ff700000-ffffffff : reserved
  ffb80000-ffbfffff : pnp 00:03
100000000-11fffffff : System RAM
MemTotal:        3882764 kB
MemFree:         3582332 kB
MemAvailable:    3493596 kB
Buffers:               0 kB
Cached:           241832 kB
SwapCached:            0 kB
Active:            41884 kB
Inactive:         201360 kB
Active(anon):      41884 kB
Inactive(anon):   201360 kB
Active(file):          0 kB
Inactive(file):        0 kB
Unevictable:        2664 kB
Mlocked:            2664 kB
HighTotal:       3017416 kB
HighFree:        2796172 kB
LowTotal:         865348 kB
LowFree:          786160 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          3920 kB
Mapped:             5760 kB
Shmem:            241832 kB
Slab:              41248 kB
SReclaimable:       6108 kB
SUnreclaim:        35140 kB
KernelStack:         912 kB
PageTables:          292 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1941380 kB
Committed_AS:     249636 kB
VmallocTotal:     122880 kB
VmallocUsed:       10576 kB
VmallocChunk:     105972 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       12280 kB
DirectMap2M:      901120 kB
Waiting for init.late [  OK  ]
+ . /etc/init.d/functions
++ TEXTDOMAIN=initscripts
++ umask 022
++ PATH=/sbin:/usr/sbin:/bin:/usr/bin
++ export PATH
++ '[' -z '' ']'
++ COLUMNS=80
++ '[' -z '' ']'
+++ /sbin/consoletype
++ CONSOLETYPE=serial
++ '[' -f /etc/sysconfig/i18n -a -z '' -a -z '' ']'
++ '[' -z '' ']'
++ '[' -f /etc/sysconfig/init ']'
++ . /etc/sysconfig/init
+++ BOOTUP=color
+++ RES_COL=60
+++ MOVE_TO_COL='echo -en \033[60G'
+++ SETCOLOR_SUCCESS='echo -en \033[0;32m'
+++ SETCOLOR_FAILURE='echo -en \033[0;31m'
+++ SETCOLOR_WARNING='echo -en \033[0;33m'
+++ SETCOLOR_NORMAL='echo -en \033[0;39m'
+++ LOGLEVEL=3
+++ PROMPT=yes
+++ AUTOSWAP=no
+++ ACTIVE_CONSOLES='/dev/tty[1-6]'
++ '[' serial = serial ']'
++ BOOTUP=serial
++ MOVE_TO_COL=
++ SETCOLOR_SUCCESS=
++ SETCOLOR_FAILURE=
++ SETCOLOR_WARNING=
++ SETCOLOR_NORMAL=
++ __sed_discard_ignored_files='/\(~\|\.bak\|\.orig\|\.rpmnew\|\.rpmorig\|\.rpmsave\)$/d'
+ mkdir -p /mnt/lab
+ echo '192.168.102.1  build'
+ ping -q -c 1 build
PING build.dumpdata.com (192.168.102.1) 56(84) bytes of data.

--- build.dumpdata.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.287/0.287/0.287/0.000 ms
+ '[' 0 -eq 0 ']'
+ mount build:/srv/tftpboot/lab /mnt/lab -o vers=3
[   25.269431] mount.nfs (3088) used greatest stack depth: 5372 bytes left
+ iscsiadm -m discovery -t st -p build
192.168.102.
+ iscsiadm -m node -L all
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:sn.bd5777dc54e541e0bd772761999275e6, portal: 192.168.102.1,3260]
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GJul 15 16:05:11 tst034 iscsid: transport class version 2.0-870. iscsid version 2.0-870
Jul 15 16:05:11 tst034 iscsid: iSCSI da^G[   25.537079] scsi8 : iSCSI Initiator over TCP/IP
[   25.800158] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
[   25.811364] sd 8:0:0:0: [sdc] 1953380352 512-byte logical blocks: (1.00 TB/931 GiB)
[   25.811414] sd 8:0:0:0: Attached scsi generic sg2 type 0
Login to [iface:[   25.825780] sd 8:0:0:0: [sdc] Write Protect is off
 default, target[   25.831091] sd 8:0:0:0: [sdc] Mode Sense: 2f 00 00 00
: iqn.2003-01.or[   25.838442] calling  dm_init+0x0/0x3f [dm_mod] @ 3110
[   25.838629] sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
g.linux-iscsi.ta[   25.854284] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
rget:sn.bd5777dc[   25.863893] initcall dm_init+0x0/0x3f [dm_mod] returned 0 after 9909 usecs
54e541e0bd772761[   25.873281] calling  dm_multipath_init+0x0/0x1000 [dm_multipath] @ 3110
999275e6, portal[   25.880852] device-mapper: multipath: version 1.7.0 loaded
: 192.168.102.1,[   25.887720] initcall dm_multipath_init+0x0/0x1000 [dm_multipath] returned 0 after 6941 usecs
3260]: successful
+ modprobe dm-multipath
+ sleep 5
[   25.905012]  sdc: unknown partition table
[   25.931530] sd 8:0:0:0: [sdc] Attached SCSI disk
Jul 15 16:05:12 tst034 iscsid: connection1:0 is operational now
+ pvscan
  PV /dev/sdc   VG guests   lvm2 [931.44 GiB / 113.44 GiB free]
  Total: 1 [931.44 GiB] / in use: 1 [931.44 GiB] / in no VG: 0 G^G  31 logical volume(s) in volume group "guests" now active
+ echo 'NFS done'
NFS done
+ xl info
xc: error: Could not obtain annot init xl context
+ '[' -e /sys/kernel/debug/xen/mmu/p2m ']'
+ cat /sys/kernel/debug/xen/mmu/p2m
++ boot_parameter cpuplug
++ local param
++ local value
+++ cat /proc/cmdline
+++ tr -s ' \t' '\n'
+++ egrep '^cpuplug=|^cpuplug$'
+++ tail -1
++ param=
++ '[' -z '' ']'
++ return 1
+ HOTPLUG=
+ '[' 1 -eq 0 ']'
+ TMEM_LOADED=0
+ swapon /dev/xvda
swapon: /dev/xvda: stat failed: No such file or directory
+ '[' 255 -eq 0 ']'
++ boot_parameter run
++ local param
++ local value
+++ cat /proc/cmdline
+++ tr -s ' \t' '\n'
+++ egrep '^run=|^run$'
+++ tail -1
++ param=
++ '[' -z '' ']'
++ return 1
+ HOTPLUG=
+ '[' 1 -eq 0 ']'
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GJul 15 16:05:17 tst034 init: starting pid 3307, tty '/dev/tty1': '/bin/sh'
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^GJul 15 16:05:19 tst034 init: reloading /etc/inittab
Jul 15 16:05:19 tst034 init: starting pid 3311, tty '/dev/ttyS0': '/bin/sh'


BusyBox v1.14.3 (2014-07-15 12:46:58 EDT) built-in shell (ash)
Enter 'help' for a list of built-in commands.

# 



[   36.890969] switch: port 1(eth0) entered forwarding state

# uname -a
Linux tst034.dumpdata.com 3.16.0-rc5upstream-01669-g4f5f437 #1 SMP Tue Jul 15 12:43:50 EDT 2014 i686 i686 i386 GNU/Linux
# dmesg | grep -i already
[    5.356229] pci 0000:00:12.0: already assigned IRQ14
[    5.439991] pci 0000:00:12.1: already assigned IRQ14
[    5.533830000:00:14.5: already assigned IRQ10
[    9.449029] pcieport 0000:00:06.0: already assigned IRQ10
[    9.476112] pcieport 0000:00:07.0: already assigned IRQ11
[   10.110879] serial 0000:04:07.0: already assigned IRQ15
[   13.763315] r8169 0000:02:00.0: already assigned IRQ10
[   13.830253] skge 0000:04:05.0: already assigned IRQ4
[   13.924311] ahci 0000:00:11.0: already assigned IRQ15
[   13.953101] ahci 0000:03:00.0: already assigned IRQ11
[   14.106445] radeon 0000:01:05.0: already assigned IRQ10
# # dmesg | grep -i already[J      ssigned
[    0.142309] LVT offset 0 assigned for vector 0xf9
[    5.356229] pci 0000:00:12.0: already assigned IRQ14
[    5.371499] pci 0000:00:12.0: assigned new IRQ16
[    5.439991] pci 0000:00:12.1: already assigned IRQ14
[    5.455209] pci 0000:00:12.1: assigned new IRQ16
[    5.533832] pci 0000:00:12.2: already assigned IRQ7
[    5.548917] pci 0000:00:12.2: assigned new IRQ17
[    5.555096] pci 0000:00:13.0: already assigned IRQ10
[    5.570298] pci 0000:00:13.0: assigned new IRQ18
[    5.648742] pci 0000:00:13.1: already assigned IRQ10
[    5.663965] pci 0000:00:13.1: assigned new IRQ18
[    5.742666] pci 0000:00:13.2: already assigned IRQ11
[    5.757899] pci 0000:00:13.2: assigned new IRQ19
[    5.764085] pci 0000:00:14.5: already assigned IRQ10
[    5.779285] pci 0000:00:14.5: assigned new IRQ18
[    7.988340] LVT offset 1 assigned for vector 0x400
[    7.993375] IBS: LVT offset 1 assigned
[    9.449029] pcieport 0000:00:06.0: already assigned IRQ10
[    9.465056] pcieport 0000:00:06.0: assigned new IRQ18
[    9.476112] pcieport 0000:00:07.0: already assigned IRQ11
[    9.492077] pcieport 0000:00:07.0: assigned new IRQ19
[   10.110879] serial 0000:04:07.0: already assigned IRQ15
[   10.125505] serial 0000:04:07.0: assigned new IRQ22
[   10.740348] ehci-pci 0000:00:12.2: assigned new IRQ17
[   10.754995] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[   10.846004] ehci-pci 0000:00:13.2: assigned new IRQ19
[   10.856909] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[   10.986207] ohci-pci 0000:00:12.0: assigned new IRQ16
[   10.997457] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[   11.109823] ohci-pci 0000:00:12.1: assigned new IRQ16
[   11.121069] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 4
[   11.233669] ohci-pci 0000:00:13.0: assigned new IRQ18
[   11.244921] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 5
[   11.357625] ohci-pci 0000:00:13.1: assigned new IRQ18
[   11.368877] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 6
[   11.481425] ohci-pci 0000:00:14.5: assigned new IRQ18
[   11.492680] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 7
[   13.763315] r8169 0000:02:00.0: already assigned IRQ10
[   13.772025] r8169 0000:02:00.0: assigned new IRQ18
[   13.830253] skge 0000:04:05.0: already assigned IRQ4
[   13.830975] skge 0000:04:05.0: assigned new IRQ20
[   13.924311] ahci 0000:00:11.0: already assigned IRQ15
[   13.926512] ahci 0000:00:11.0: assigned new IRQ22
[   13.953101] ahci 0000:03:00.0: already assigned IRQ11
[   13.955249] ahci 0000:03:00.0: assigned new IRQ19
[   14.106445] radeon 0000:01:05.0: already assigned IRQ10
[   14.106828] radeon 0000:01:05.0: assigned new IRQ18
# 
telnet> Connection closed.
[Connecting to system 34 ]
