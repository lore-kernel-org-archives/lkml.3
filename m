Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaGNTn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:43:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51080 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGNTnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:43:45 -0400
Date: Mon, 14 Jul 2014 15:41:33 -0400
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
Message-ID: <20140714194133.GA22857@laptop.dumpdata.com>
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
 <20140714172642.GA12920@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20140714172642.GA12920@laptop.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 01:26:42PM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 25, 2014 at 04:40:31PM +0800, Jiang Liu wrote:
> > This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
> > hotplug on x86 platforms. It's based on tip/x86/apic.
> > 
> > You may pull it from 
> > https://github.com/jiangliu/linux.git ioapic/hotplug_v3
> 
> With this patchset (on top of 3.16-rc5) my USB driver gets notified
> it has interrupts but it thinks it does not have to acknowledge any.
> I can only reproduce this under a 32-bit arch so far.
> 
> Please see the good.log and the bad.log 

tglx asked for apic=debug on the line, so here they are again with
those parameters.

Please note that the 'good.log' this time is
 3.16-rc6 + tip/master + tip/x86/apic

And 'bad.log' is:

 3.16-rc6 + tip/master + tip/x86/apic + ioapic/hotplug_v3


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="good.log"
Content-Transfer-Encoding: quoted-printable

Trying 192.168.102.15...=0D
Connected to maxsrv2.=0D
Escape character is '^]'.=0D
Probing EDD (edd=3Doff to disable)... ok=0D
early console in decompress_kernel=0D
=0D
Decompressing Linux... Parsing ELF... No relocation needed... done.=0D
Booting the kernel.=0D
[    0.000000] Initializing cgroup subsys cpuset=0D
[    0.0000inux version 3.16.0-rc5upstream-01651-g03b9189 (konrad@build-ext=
ernal.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #=
1 SMP Mon Jul 14 14:45:24 EDT 2014=0D
[    0.000000] e820: BIOS-provided physical RAM map:=0D
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usabl=
e=0D
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfeaffff] usabl=
e=0D
[    0.000000] BIOS-e820: [mem 0x00000000cfeb0000-0x00000000cfebdfff] ACPI =
data=0D
[    0.000000] BIOS-e820: [mem 0x00000000cfebe000-0x00000000cfedffff] ACPI =
NVS=0D
[    0.000000] BIOS-e820: [mem 0x00000000cfee0000-0x00000000cfefffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x00000000ff700000-0x00000000ffffffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usabl=
e=0D
[    0.000000] Early serial console at I/O port 0xe400 (options '115200n8')=
=0D
[    0.000000] bootconsole [uart0] enabled=0D
[    0.000000] NX (Execute Disable) protection: active=0D
[    0.000000] SMBIOS 2.5 present.=0D
[    0.000000] DMI: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080015  04/01/2=
010=0D
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved=0D
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable=0D
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x1000000=0D
[    0.000000] MTRR default type: uncachable=0D
[    0.000000] MTRR fixed ranges enabled:=0D
[    0.000000]   00000-9FFFF write-back=0D
[    0.000000]   A0000-EFFFF uncachable=0D
[    0.000000]   F0000-FFFFF write-protect=0D
[    0.000000] MTRR variable ranges enabled:=0D
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back=0D
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back=0D
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back=0D
[    0.000000]   3 disabled=0D
[    0.000000]   4 disabled=0D
[    0.000000]   5 disabled=0D
[    0.000000]   6 disabled=0D
[    0.000000]   7 disabled=0D
[    0.000000] TOM2: 0000000130000000 aka 4864M=0D
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106=0D
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable =3D=3D> rese=
rved=0D
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]=0D
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]=0D
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]=0D
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at =
[c00ff780]=0D
[    0.000000]   mpc: e5e70-e5ffc=0D
[    0.000000] Scanning 1 areas for low memory corruption=0D
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]=0D
[  init_memory_mapping: [mem 0x37800000-0x379fffff]=0D
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M=0D
[    0.000000] init_memory_mapping: [mem 0x34000000-0x377fffff]=0D
[    0.000000]  [mem 0x34000000-0x377fffff] page 2M=0D
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]=0D
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k=0D
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M=0D
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]=0D
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k=0D
[    0.000000] BRK [0x01a3c000, 0x01a3cfff] PGTABLE=0D
[    0.000000] RAMDISK: [mem 0x7aed5000-0x7fffefff]=0D
[    0.000000] Allocated new RAMDISK: [mem 0x32ad4000-0x37bfdd60]=0D
[    0.000000] Move RAMDISK from [mem 0x7aed5000-0x7fffed60] to [mem 0x32ad=
4000-0x37bfdd60]=0D
[    0.000000] ACPI: Early table ch 0.000000] ACPI: RSDT 0xCFEB0000 000040 =
(v01 040110 RSDT1316 20100401 MSFT 00000097)=0D
[    0.000000] ACPI: FACP 0xCFEB0200 000084 (v01 040110 FACP1316 20100401 M=
SFT 00000097)=0D
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock=
 has zero address or length: 0x0000000000000000/0x1 (20140424/tbfadt-649)=0D
[    0.000000] ACPI: DSDT 0xCFEB0450 00A65F (v01 1AAAA  1AAAA000 00000000 I=
NTL 20051117)=0D
[    0.000000] ACPI: FACS 0xCFEBE000 000040=0D
[    0.000000] ACPI: APIC 0xCFEB0390 00007C (v01 040110 APIC1316 20100401 M=
SFT 00000097)=0D
[    0.000000] ACPI: MCFG 0xCFEB0410 00003C (v01 040110 OEMMCFG  20100401 M=
SFT 00000097)=0D
[    0.000000] ACPI: OEMB 0xCFEBE040 000072 (v01 040110 OEMB1316 20100401 M=
SFT 00000097)=0D
[    0.000000] ACPI: SRAT 0xCFEBAAB0 0000E8 (v03 AMD    FAM_F_10 00000002 A=
MD  00000001)=0D
[    0.000000] ACPI: HPET 0xCFEBABA0 000038 (v01 040110 OEMHPET  20100401 M=
SFT 00000097)=0D
[    0.000000] ACPI: SSDT 0xCFEBABE0 00088C (v01 A M I  POWERNOW 00000001 A=
MD  00000001)=0D
[    0.000000] ACPI: Local APIC address 0xfee00000=0D
[    0.000000] mapped APIC to         ffffb000 (        fee00000)=0D
[    0.000000] 3716MB HIGHMEM available.=0D
[    0.000000] 891MB LOWMEM available.=0D
[    0.000000]   mapped low ram: 0 - 37bfe000=0D
[    0.000000]   low ram: 0 - 37bfe000=0D
[    0.000000] BRK [0x01a3d000, 0x01a3dfff] PGTABLE=0D
[    0.000000] Zone ranges:=0D
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]=0D
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]=0D
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fffffff]=0D
[    0.000000] Movable zone start for each node=0D
[    0.000000] Early memory node ranges=0D
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]=0D
[    0.000000]   node   0: [mem 0x00100000-0xcfeaffff]=0D
[    0.000000]   node   0: [mem 0x00000000-0x1fffffff]=0D
[    0.000000] On node 0 totalpages: 982606=0D
[    0.000000] free_area_init_node: node 0, pgdat c1849200, node_mem_map f0=
6d4020=0D
[    0.000000]   DMA zone: 32 pages used for    0.000000]   Normal zone: 17=
52 pages used for memmap=0D
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31=0D
[    0.000000]   HighMem zone: 7433 pages used for memmap=0D
[    0.000000]   HighMem zone: 754354 pages, LIFO batch:31=0D
[    0.000000] Using APIC driver default=0D
[    0.000000] ACPI: PM-Timer IO Port: 0x808=0D
[    0.000000] ACPI: Local APIC address APIC (acpi_id[0x02] lapic_id[0x01] =
enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)=0D
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])=0D
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-=
23=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 4, APIC =
INT 02=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)=0D
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 09, APIC ID 4, APIC =
INT 09=0D
[    0.000000] ACPI: IRQ0 used by override.=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC =
INT 01=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC =
INT 03=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC =
INT 04=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC =
INT 05=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC =
INT 06=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC =
INT 07=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC =
INT 08=0D
[    0.000000] ACPI: IRQ9 used by override.=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC =
INT 0a=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC =
INT 0b=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC =
INT 0c=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC =
INT 0d=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 4, APIC =
INT 0e=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 4, APIC =
INT 0f=0D
[    0.000000] Using ACPI (MADT) for SMP configuration information=0D
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000=0D
[    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs=0D
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)=0D
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]=0D
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e5fff]=0D
[    0.000000] PM: Registered nosave memory: [mem 0x000e6000-0x000fffff]=0D
[    0.000000] e820: [mem 0xcff00000-0xff6fffff] available for PCI devices=
=0D
[    0.000000] Booting paravirtualized kernel on bare hardware=0D
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_no=
de_ids:1=0D
[    0.000000] PERCPU: Embedded 14 pages/cpu @f066e000 s35136 r0 d22208 u57=
344=0D
[    0.000000] pcpu-alloc: s35136 r0 d22208 u57344 alloc=3D14*4096=0D
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 =0D
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 980822=0D
[    0.000000] Kernel command line: initrd=3Dinitramfs.cpio.gz apic=3Ddebug=
 initcall_debug loglevel=3D10 nofb selinux=3D0 console=3Duart8250,io,0xe400=
,115200n8 BOOT_IMAGE=3Dvmlinuz =0D
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)=0D
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)=0D
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)=0D
[    0.000000] Initializing CPU#0=0D
[    0.000000] Initializing HighMem for node 0 (00037bfe:00120000)=0D
[    0.000000] Initializing Movable for node 0 (00000000:00000000)=0D
[    0.000000] Memory: 3798680K/3930424K available (6264K ke000]     fixmap=
  : 0xfff15000 - 0xfffff000   ( 936 kB)=0D
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)=0D
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)=0D
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)=0D
[    0.000000]       .init : 0xc185e000 - 0xc194a000   ( 944 kB)=0D
[    0.000000]       .data : 0xc161e5a7 - 0xc185cb80   (2297 kB)=0D
[    0.000000]       .text : 0xc1000000 - 0xc161e5a7   (6265 kB)=0D
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.=0D
[    0.000000] Hierarchical RCU implementation.=0D
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D6.=0D
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D6=0D
[    0.000000] NR_IRQS:2304 nr_irqs:472 0=0D
[    0.000000] CPU 0 irqstacks, hard=3Df0008000 soft=3Df000a000=0D
[    0.000000] Console: colour VGA+ 80x25=0D
[    0.000000] hpet clockevent registered=0D
[    0.000000] tsc: Fast TSC calibration using PIT=0D
[    0.000000] tsc: Detected 3000.037 MHz processor=0D
[    0.000025] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6000.07 BogoMIPS (lpj=3D3000037)=0D
[    0.011164] pid_max: default: 32768 minimum: 301=0D
[    0.016060] ACPI: Core revision 20140424=0D
[    0.091418] ACPI: All ACPI Tables successfully acquired=0D
[    0.103252] Security Framework initialized=0D
[    0.107549] SELinux:  Disabled at boot.=0D
[    0.111758] Mount-cache hash tablehe hash table entries: 2048 (order: 1,=
 8192 bytes)=0D
[    0.127259] Initializing cgroup subsys freezer=0D
[    0.131990] CPU: Physical Processor ID: 0=0D
[    0.136195] CPU: Processor Core ID: 0=0D
[    0.140036] mce: CPU supports 6 MCE banks=0D
[    0.144252] LVT offset 0 assigned for vector 0xf9=0D
[    0.149191] process: using AMD E400 aware idle routine=0D
[    0.154583] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8=0D
[    0.154583] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0=0D
[    0.154583] tlb_flushall_shift: 6=0D
[    0.170685] Freeing SMP alternatives memory: 28K (c194a000 - c1951000)=0D
[    0.178541] Getting VERSION: 80050010=0D
[    0.182385] Getting VERSION: 80050010=0D
[    0.186219] Getting ID: 0=0D
[    0.188969] Getting ID: f000000=0D
[    0.192263] Getting LVT0: 700=0D
[    0.195371] Getting LVT1: 400=0D
[    0.198486] Enabling APIC mode:  Flat.  Using 1 I/O APICs=0D
[    0.204154] enabled ExtINT on CPU#0=0D
[    0.208001] ESR value before enabling vector: 0x00000004  after: 0x00000=
000=0D
[    0.215307] ENABLING IO-APIC IRQs=0D
[    0.218794] init IO_APIC IRQs=0D
[    0.221899]  apic 4 pin 0 not connected=0D
[    0.225924] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.234244] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.242552] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.250860] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.259177] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.267479] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.275797] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.284112] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.292420] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:1 Dest:1)=0D
[    0.300733] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 =
Active:0 Dest:1)=0D
[    0.309217] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 =
Active:0 Dest:1)=0D
[    0.317700] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)=0D
[    0.326187] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)=0D
[    0.334676] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)=0D
[    0.343167] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)=0D
[    0.351656]  apic 4 pin 16 not connected=0D
[    0.355770]  apic 4 pin 17 not connected=0D
[    0.359880]  apic 4 pin 18 not connected=0D
[    0.363989]  apic 4 pin 19 not connected=0D
[    0.368091]  apic 4 pin 20 not connected=0D
[    0.372199]  apic 4 pin 21 not connected=0D
[    0.376306]  apic 4 pin 22 not connected=0D
[    0.380416]  apic 4 pin 23 not connected=0D
[    0.384649] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1=0D
[    0.400941] smpboot: CPU0: AMD Phenom(tm) II X4 940 Processor (fam: 10, =
model: 04, stepping: 02)=0D
[    0.410177] Using local [    0.520486] ... lapic delta =3D 1250027=0D
[    0.524324] ... PM-Timer delta =3D 357950=0D
[    0.528336] ... PM-Timer result ok=0D
[    0.531898] ..... delta 1250027=0D
[    0.535187] ..... mult: 53688250=0D
[    0.538567] ..... calibration result: 200004=0D
[    0.543037] ..... CPU clock speed is 3000.0065 MHz.=0D
[    0.548143] ..... host bus clock speed is 200.0004 MHz.=0D
[    0.553634] calling  xen_init_spinlocks_jump+0x0/0x23 @ 1=0D
[    0.559302] initcall xen_init_spinlocks_jump+0x0/0x23 returned 0 after 0=
 usecs=0D
[    0.566872] calling  set_real_mode_permissions+0x0/0x5d @ 1=0D
[    0.572716] initcall set_real_mode_permissions+0x0/0x5d returned 0 after=
 0 usecs=0D
[    0.580477] calling  trace_init_perf_perm_irq_work_exit+0x0/0x11 @ 1=0D
[    0.587146] initcall trace_init_perf_perm_irq_work_exit+0x0/0x11 returne=
d 0 after 0 usecs=0D
[    0.595724] calling  trace_init_flags_sys_exit+0x0/0xe @ 1=0D
[    0.601478] initcall trace_init_flags_sys_exit+0x0/0xe returned 0 after =
0 usecs=0D
[    0.609145] calling  trace_init_flags_sys_enter+0x0/0xe @ 1=0D
[    0.614985] initcall trace_init_flags_sys_enter+0x0/0xe returned 0 after=
 0 usecs=0D
[    0.622744] calling  init_hw_perf_events+0x0/0x52b @ 1=0D
[    0.628127] Performance Events: AMD PMU driver.=0D
[    0.632888] ... version:                0=0D
[    0.637091] ... bit width:              48=0D
[    0.641383] ... generic registers:      4=0D
[    0.645585] ... value mask:             0000ffffffffffff=0D
[    0.651149] ... max period:             00007fffffffffff=0D
[    0.656713] ... fixed-purpose events:   0=0D
[    0.660917] ... event mask:             000000000000000f=0D
[    0.666524] initcall init_hw_perf_events+0x0/0x52b returned 0 after 9765=
 usecs=0D
[    0.674110] calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1=0D
[    0.680784] initcall register_trigger_all_cpu_backtrace+0x0/0x13 returne=
d 0 after 0 usecs=0D
[    0.689368] calling  kvm_spinlock_init_jump+0x0/0x37 @ 1=0D
[    0.694934] initcall kvm_spinlock_init_jump+0x0/0x37 returned 0 after 0 =
usecs=0D
[    0.702427] calling  spawn_ksoftirqd+0x0/0x23 @ 1=0D
[    0.707392] initcall spawn_ksoftirqd+0x0/0x23 returned 0 after 0 usecs=0D
[    0.714236] calling  init_workqueues+0x0/0x3e6 @ 1=0D
[    0.719662] initcall init_workqueues+0x0/0x3e6 returned 0 after 976 usec=
s=0D
[    0.726790] calling  migration_init+0x0/0x5b @ 1=0D
[    0.731628] initcall migration_init+0x0/0x5b returned 0 after 0 usecs=0D
[    0.738388] calling  check_cpu_stall_init+0x0/0x16 @ 1=0D
[    0.743768] initcall check_cpu_stall_init+0x0/0x16 returned 0 after 0 us=
ecs=0D
[    0.751076] calling  rcu_scheduler_really_started+0x0/0x11 @ 1=0D
[    0.757195] initcall rcu_scheduler_really_started+0x0/0x11 returned 0 af=
ter 0 usecs=0D
[    0.765226] calling  rcu_spawn_gp_kthread+0x0/0x87 @ 1=0D
[    0.770668] initcall rcu_spawn_gp_kthread+0x0/0x87 returned 0 after 0 us=
ecs=0D
[    0.777974] calling  cpu_stop_init+0x0/0x5d @ 1=0D
[    0.782753] initcall cpu_stop_init+0x0/0x5d returned 0 after 0 usecs=0D
[    0.789424] calling  relay_init+0x0/0x11 @ 1=0D
[    0.793898] initcall relay_init+0x0/0x11 returned 0 after 0 usecs=0D
[    0.800296] calling  tracer_alloc_buffers+0x0/0x213 @ 1=0D
[    0.805868] initcall tracer_alloc_buffers+0x0/0x213 returned 0 after 0 u=
secs=0D
[    0.813263] calling  init_events+0x0/0x5f @ 1=0D
[    0.817833] initcall init_events+0x0/0x5f returned 0 after 0 usecs=0D
[    0.824308] calling  init_trace_printk+0x0/0xf @ 1=0D
[    0.829323] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs=
=0D
[    0.836261] calling  event_trace_memsetup+0x0/0x5a @ 1=0D
[    0.841689] initcall event_trace_memsetup+0x0/0x5a returned 0 after 0 us=
ecs=0D
[    0.849001] calling  jump_label_init_module+0x0/0xf @ 1=0D
[    0.854484] initcall jump_label_init_module+0x0/0xf returned 0 after 0 u=
secs=0D
[    0.861877] calling  hashlib_init+0x0/0x11 @ 1=0D
[    0.866535] initcall hashlib_init+0x0/0x11 returned 0 after 0 usecs=0D
[    0.873118] calling  balloon_clear+0x0/0x3b @ 1=0D
[    0.877869] initcall balloon_clear+0x0/0x3b returned 0 after 0 usecs=0D
[    0.884540] calling  rand_initialize+0x0/0x30 @ 1=0D
[    0.889506] initcall rand_initialize+0x0/0x30 returned 0 after 0 usecs=0D
[    0.896352] calling  mce_amd_init+0x0/0x134 @ 1=0D
[    0.901098] MCE: In-kernel MCE decoding enabled.=0D
[    0.905938] initcall mce_amd_init+0x0/0x134 returned 0 after 976 usecs=0D
[    0.912970] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.=0D
[    0.923135] CPU 1 irqstacks, hard=3Df02c2000 soft=3Def820000=0D
[    0.928713] x86: Booting SMP configuration:=0D
[    0.933098] .... node  #0, CPUs:      #1=0D
[    0.947667] Initializing CPU#1=0D
[    0.948033] masked ExtINT on CPU#1=0D
[    0.950211] process: System has AMD C1E enabled=0D
[    0.950752] CPU 2 irqstacks, hard=3Df028a000 soft=3Df028c000=0D
[    0.961303]  #2=0D
[    0.961303] Initializing CPU#2=0D
[    0.961752] masked ExtINT on CPU#2=0D
[    0.963938] process: Switch to broadcast mode on CPU2=0D
[    0.964466] CPU 3 irqstacks, hard=3Df02be000 soft=3Df0200000=0D
[    0.975017]  #3=0D
[    0.975017] Initializing CPU#3=0D
[    0.975465] masked ExtINT on CPU#3=0D
[    0.977599] x86: Booted up 1 node, 4 CPUs=0D
[    0.977601] smpboot: Total of 4 processors activated (24000.29 BogoMIPS)=
=0D
[    0.977643] process: Switch to broadcast mode on CPU3=0D
[    1.012014] process: Switch to broadcast mode on CPU1=0D
[    1.022303] process: Switch to broadcast mode on CPU0=0D
[    1.027936] devtmpfs: initialized=0D
[    1.032345] calling  ipc_n0/0x11 returned 0 after 0 usecs=0D
[    1.043427] calling  init_mmap_min_addr+0x0/0x20 @ 1=0D
[    1.048635] initcall init_mmap_min_addr+0x0/0x20 returned 0 after 0 usec=
s=0D
[    1.055768] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1=
=0D
[    1.062733] initcall init_cpufreq_transition_notifier_list+0x0/0x18 retu=
rned 0 after 0 usecs=0D
[    1.071593] calling  net_ns_init+0x0/0x100 @ 1=0D
[    1.076389] initcall net_ns_init+0x0/0x100 returned 0 after 0 usecs=0D
[    1.083018] calling  e820_mark_nvs_memory+0x0/0x4e @ 1=0D
[    1.088412] PM: Registering ACPI NVS region [mem 0xcfebe000-0xcfedffff] =
(139264 bytes)=0D
[    1.096800] initcall e820_mark_nvs_memory+0x0/0x4e returned 0 after 976 =
usecs=0D
[    1.104303] calling  cpufreq_tsc+0x0/0x26 @ 1=0D
[    1.108874] initcall cpufreq_tsc+0x0/0x26 returned 0 after 0 usecs=0D
[    1.115375] calling  reboot_init+0x0/0x1a @ 1=0D
[    1.119956] initcall reboot_init+0x0/0x1a returned 0 after 0 usecs=0D
[    1.126445] calling  init_lapic_sysfs+0x0/0x1b @ 1=0D
[    1.131470] initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usecs=
=0D
[    1.138427] calling  cpu_hotplug_pm_sync_init+0x0/0x29 @ 1=0D
[    1.144194] initcall cpu_hotplug_pm_sync_init+0x0/0x29 returned 0 after =
0 usecs=0D
[    1.151876] calling  alloc_frozen_cpus+0x0/0x7 @ 1=0D
[    1.156897] initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usecs=
=0D
[    1.163850] calling  wq_sysfs_init+0x0/0x11 @ 1=0D
[    1.168745] initcall wq_sysfs_init+0x0/0x11 returned 0 after 0 usecs=0D
[    1.168863] kworker/u12:0 (30) used greatest stack depth: 6980 bytes lef=
t=0D
[    1.182547] calling  ksysfs_init+0x0/0x74 @ 1=0D
[    1.187197] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs=0D
[    1.193681] calling  pm_init+0x0/0x45 @ 1=0D
[    1.197956] initcall pm_init+0x0/0x45 returned 0 after 0 usecs=0D
[    1.204076] calling  pm_disk_init+0x0/0x14 @ 1=0D
[    1.208773] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs=0D
[    1.215361] calling  swsusp_header_init+0x0/0x30 @ 1=0D
[    1.220574] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usec=
s=0D
[    1.227721] calling  init_jiffies_clocksource+0x0/0xf @ 1=0D
[    1.233394] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0=
 usecs=0D
[    1.240987] calling  cgroup_wq_init+0x0/0x7c @ 1=0D
[    1.245891] initcall cgroup_wq_init+0x0/0x7c returned 0 after 0 usecs=0D
[    1.252656] calling  event_trace_enable+0x0/0x155 @ 1=0D
[    1.258864] initcall event_trace_enable+0x0/0x155 returned 0 after 976 u=
secs=0D
[    1.266275] calling  init_zero_pfn+0x0/0x14 @ 1=0D
[    1.271023] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs=0D
[    1.277707] calling  fsnotify_init+0x0/0x24 @ 1=0D
[    1.282482] initcall fsnotify_init+0x0/0x24 returned 0 after 0 usecs=0D
[    1.289162] calling  filelock_init+0x0/0x74 @ 1=0D
[    1.293950] initcall filelock_init+0x0/0x74 returned 0 after 0 usecs=0D
[    1.300629] calling  init_misc_binfmt+0x0/0x28 @ 1=0D
[    1.305670] initcall init_misc_binfmt+0x0/0x28 returned 0 after 0 usecs=
=0D
[    1.312625] calling  init_script_binfmt+0x0/0x13 @ 1=0D
[    1.317836] initcall init_script_binfmt+0x0/0x13 returned 0 after 0 usec=
s=0D
[    1.324965] calling  init_elf_binfmt+0x0/0x13 @ 1=0D
[    1.329901] initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs=0D
[    1.336754] calling  debugfs_init+0x0/0x4a @ 1=0D
[    1.341438] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs=0D
[    1.348029] calling  securityfs_init+0x0/0x41 @ 1=0D
[    1.352988] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs=0D
[    1.359848] calling  prandom_init+0x0/0xaa @ 1=0D
[    1.364518] initcall prandom_init+0x0/0xaa returned 0 after 0 usecs=0D
[    1.371106] calling  virtio_init+0x0/0x30 @ 1=0D
[    1.375768] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs=0D
[    1.382265] calling  early_resume_init+0x0/0x1a0 @ 1=0D
[    1.387486] RTC time: 19:21:52, date: 07/14/14=0D
[    1.392157] initcall early_resume_init+0x0/0x1a0 returned 0 after 976 us=
ecs=0D
[    1.399476] calling  cpufreq_core_init+0x0/0x29 @ 1=0D
[    1.404601] initcall cpufreq_core_init+0x0/0x29 returned 0 after 0 usecs=
=0D
[    1.411643] calling  cpuidle_init+0x0/0x36 @ 1=0D
[    1.416333] initcall cpuidle_init+0x0/0x36 returned 0 after 0 usecs=0D
[    1.422921] calling  bsp_pm_check_init+0x0/0x11 @ 1=0D
[    1.428041] initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 usecs=
=0D
[    1.435073] calling  sock_init+0x0/0x89 @ 1=0D
[    1.439719] initcall sock_init+0x0/0x89 returned 0 after 976 usecs=0D
[    1.446205] calling  net_inuse_init+0x0/0x24 @ 1=0D
[    1.451070] initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs=0D
[    1.457834] calling  netpoll_init+0x0/0x2e @ 1=0D
[    1.462503] initcall netpoll_init+0x0/0x2e returned 0 after 0 usecs=0D
[    1.469100] calling  netlink_proto_init+0x0/0x1a7 @ 1=0D
[    1.474477] NET: Registered protocol family 16=0D
[    1.479183] initcall netlink_proto_init+0x0/0x1a7 returned 0 after 1953 =
usecs=0D
[    1.486681] calling  __gnttab_init+0x0/0x30 @ 1=0D
[    1.491440] initcall __gnttab_init+0x0/0x30 returned -19 after 0 usecs=0D
[    1.498331] calling  bdi_class_init+0x0/0x40 @ 1=0D
[    1.503337] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs=0D
[    1.510109] calling  mm_sysfs_init+0x0/0x22 @ 1=0D
[    1.514882] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs=0D
[    1.521556] calling  kobject_uevent_init+0x0/0xf @ 1=0D
[    1.526792] initcall kobject_uevent_init+0x0/0xf returned 0 after 0 usec=
s=0D
[    1.533933] calling  pcibus_class_init+0x0/0x14 @ 1=0D
[    1.539082] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs=
=0D
[    1.546129] calling  pci_driver_init+0x0/0xf @ 1=0D
[    1.551066] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs=0D
[    1.557830] calling  backlight_class_init+0x0/0x92 @ 1=0D
[    1.563265] initcall backlight_class_init+0x0/0x92 returned 0 after 0 us=
ecs=0D
[    1.570589] calling  xenbus_init+0x0/0x24f @ 1=0D
[    1.575259] initcall xenbus_init+0x0/0x24f returned -19 after 0 usecs=0D
[    1.582020] calling  tty_class_init+0x0/0x2f @ 1=0D
[    1.586910] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs=0D
[    1.593675] calling  vtconsole_class_init+0x0/0xc2 @ 1=0D
[    1.599210] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 us=
ecs=0D
[    1.606535] calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1=0D
[    1.612575] initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 aft=
er 0 usecs=0D
[    1.620527] calling  i2c_init+0x0/0x57 @ 1=0D
[    1.624976] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs=0D
[    1.631202] calling  lguest_devices_init+0x0/0x13f @ 1=0D
[    1.636601] initcall lguest_devices_init+0x0/0x13f returned 0 after 0 us=
ecs=0D
[    1.643906] calling  init_ladder+0x0/0xf @ 1=0D
[    1.648390] cpuidle: using governor ladder=0D
[    1.652697] initcall init_ladder+0x0/0xf returned 0 after 976 usecs=0D
[    1.659296] calling  init_menu+0x0/0xf @ 1=0D
[    1.663595] cpuidle: using governor menu=0D
[    1.667714] initcall init_menu+0x0/0xf returned 0 after 976 usecs=0D
[    1.674126] calling  amd_postcore_init+0x0/0x131 @ 1=0D
[    1.679347] node 0 link 0: io port [1000, ffffff]=0D
[    1.684294] TOM: 00000000d0000000 aka 3328M=0D
[    1.688679] Fam 10h mmconf [mem 0xe0000000-0xefffffff]=0D
[    1.694073] node 0 link 0: mmio [a0000, bffff]=0D
[    1.698753] node 0 link 0: mmio [d0000000, efffffff] =3D=3D> [d0000000, =
dfffffff]=0D
[    1.706265] node 0 link 0: mmio [f0000000, fe6fffff]=0D
[    1.711473] node 0 link 0: mmio [fe700000, fe8fffff]=0D
[    1.716690] node 0 link 0: mmio [fe900000, ffefffff]=0D
[    1.721902] TOM2: 0000000130000000 aka 4864M=0D
[    1.726393] bus: [bus 00-07] on node 0 link 0=0D
[    1.730967] bus: 00 [io  0x0000-0xffff]=0D
[    1.734996] bus: 00 [mem 0x000a0000-0x000bffff]=0D
[    1.739745] bus: 00 [mem 0xd0000000-0xdfffffff]=0D
[    1.744491] bus: 00 [mem 0xf0000000-0xffffffff]=0D
[    1.749244] bus: 00 [mem 0x130000000-0xfcffffffff]=0D
[    1.754292] initcall amd_postcore_init+0x0/0x131 returned 0 after 16601 =
usecs=0D
[    1.761816] calling  boot_params_ksysfs_init+0x0/0x22f @ 1=0D
[    1.767604] initcall boot_params_ksysfs_init+0x0/0x22f returned 0 after =
0 usecs=0D
[    1.775269] calling  arch_kdebugfs_init+0x0/0x2a6 @ 1=0D
[    1.780610] initcall arch_kdebugfs_init+0x0/0x2a6 returned 0 after 0 use=
cs=0D
[    1.787837] calling  init_pit_clocksource+0x0/0x36 @ 1=0D
[    1.793232] initcall init_pit_clocksource+0x0/0x36 returned 0 after 0 us=
ecs=0D
[    1.800544] calling  mtrr_if_init+0x0/0x56 @ 1=0D
[    1.805224] initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs=0D
[    1.811796] calling  ffh_cstate_init+0x0/0x27 @ 1=0D
[    1.816728] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usecs=
=0D
[    1.823680] calling  kdump_buf_page_init+0x0/0x3a @ 1=0D
[    1.828988] initcall kdump_buf_page_init+0x0/0x3a returned 0 after 0 use=
cs=0D
[    1.836203] calling  activate_jump_labels+0x0/0x2d @ 1=0D
[    1.841592] initcall activate_jump_labels+0x0/0x2d returned 0 after 0 us=
ecs=0D
[    1.848899] calling  acpi_pci_init+0x0/0x5b @ 1=0D
[    1.853650] ACPI: bus type PCI registered=0D
[    1.857863] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5=0D
[    1.864622] initcall acpi_pci_init+0x0/0x5b returned 0 after 1953 usecs=
=0D
[    1.871575] calling  dma_bus_init+0x0/0xbb @ 1=0D
[    1.876424] initcall dma_bus_init+0x0/0xbb returned 0 after 0 usecs=0D
[    1.883007] calling  dma_channel_table_init+0x0/0xc4 @ 1=0D
[    1.888707] initcall dma_channel_table_init+0x0/0xc4 returned 0 after 0 =
usecs=0D
[    1.896205] calling  setup_vcpu_hotplug_event+0x0/0x1f @ 1=0D
[    1.901964] initcall setup_vcpu_hotplug_event+0x0/0x1f returned -19 afte=
r 0 usecs=0D
[    1.909826] calling  register_xen_pci_notifier+0x0/0x30 @ 1=0D
[    1.915675] initcall register_xen_pci_notifier+0x0/0x30 returned 0 after=
 0 usecs=0D
[    1.923447] calling  xen_pcpu_init+0x0/0xc8 @ 1=0D
[    1.928197] initcall xen_pcpu_init+0x0/0xc8 returned -19 after 0 usecs=0D
[    1.935062] calling  dmi_id_init+0x0/0x2a2 @ 1=0D
[    1.940009] initcall dmi_id_init+0x0/0x2a2 returned 0 after 0 usecs=0D
[    1.946594] calling  dca_init+0x0/0x21 @ 1=0D
[    1.950894] dca service started, version 1.12.1=0D
[    1.955688] initcall dca_init+0x0/0x21 returned 0 after 976 usecs=0D
[    1.962091] calling  pci_arch_init+0x0/0x65 @ 1=0D
[    1.966867] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)=0D
[    1.976638] PCI: not using MMCONFIG=0D
[    1.980953] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.=0D
[    1.988609] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D4=0D
[    1.995275] PCI: Using configuration type 1 for base access=0D
[    2.001129] PCI: Using configuration type 1 for extended access=0D
[    2.007351] initcall pci_arch_init+0x0/0x65 returned 0 after 5859 usecs=
=0D
[    2.014325] calling  topology_init+0x0/0x36 @ 1=0D
[    2.019499] initcall topology_init+0x0/0x36 returned 0 after 0 usecs=0D
[    2.026177] calling  mtrr_init_finialize+0x0/0x30 @ 1=0D
[    2.031485] initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 use=
cs=0D
[    2.038714] calling  uid_cache_init+0x0/0x7e @ 1=0D
[    2.043596] initcall uid_cache_init+0x0/0x7e returned 0 after 0 usecs=0D
[    2.050356] calling  param_sysfs_init+0x0/0x14c @ 1=0D
[    2.058914] kworker/u12:0 (110) used greatest stack depth: 6864 bytes le=
ft=0D
[    2.067902] initcall param_sysfs_init+0x0/0x14c returned 0 after 12695 u=
secs=0D
[    2.075309] calling  proc_schedstat_init+0x0/0x27 @ 1=0D
[    2.080617] initcall proc_schedstat_init+0x0/0x27 returned 0 after 0 use=
cs=0D
[    2.087843] calling  pm_sysrq_init+0x0/0x16 @ 1=0D
[    2.098070] initcall pm_sysrq_init+0x0/0x16 returned 0 after 5859 usecs=
=0D
[    2.105026] calling  create_proc_profile+0x0/0x1elling  crash_save_vmcor=
einfo_init+0x0/0x5ad @ 1=0D
[    2.123799] initcall crash_save_vmcoreinfo_init+0x0/0x5ad returned 0 aft=
er 0 usecs=0D
[    2.131746] calling  crash_notes_memory_init+0x0/0x35 @ 1=0D
[    2.137439] initcall crash_notes_memory_init+0x0/0x35 returned 0 after 0=
 usecs=0D
[    2.145024] calling  hung_task_init+0x0/0x56 @ 1=0D
[    2.149935] initcall hung_task_init+0x0/0x56 returned 0 after 0 usecs=0D
[    2.156699] calling  default_bdi_init+0x0/0x78 @ 1=0D
[    2.162200] initcall default_bdi_init+0x0/0x78 returned 0 after 976 usec=
s=0D
[    2.169333] calling  init_reserve_notifier+0x0/0x7 @ 1=0D
[    2.174716] initcall init_reserve_notifier+0x0/0x7 returned 0 after 0 us=
ecs=0D
[    2.182041] calling  init_admin_reserve+0x0/0x30 @ 1=0D
[    2.187257] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 usec=
s=0D
[    2.194387] calling  init_user_reserve+0x0/0x30 @ 1=0D
[    2.199503] initcall init_user_reserve+0x0/0x30 returned 0 after 0 usecs=
=0D
[    2.206546] calling  mmu_notifier_init+0x0/0xf @ 1=0D
[    2.211598] initcall mmu_notifier_init+0x0/0xf returned 0 after 0 usecs=
=0D
[    2.218531] calling  hugepage_init+0x0/0x123 @ 1=0D
[    2.223578] initcall hugepage_init+0x0/0x123 returned 0 after 0 usecs=0D
[    2.230346] calling  crypto_wq_init+0x0/0x41 @ 1=0D
[    2.235270] initcall crypto_wq_init+0x0/0x41 returned 0 after 0 usecs=0D
[    2.242034] calling  cryptomgr_init+0x0/0xf @ 1=0D
[    2.246799] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs=0D
[    2.253468] calling  init_bio+0x0/0xc5 @ 1=0D
[    2.258150] initcall init_bio+0x0/0xc5 returned 0 after 0 usecs=0D
[    2.264382] calling  blk_settings_init+0x0/0x21 @ 1=0D
[    2.269511] initcall blk_settings_init+0x0/0x21 returned 0 after 0 usecs=
=0D
[    2.276542] calling  blk_ioc_init+0x0/0x2f @ 1=0D
[    2.281236] initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs=0D
[    2.287824] calling  blk_softirq_init+0x0/0x54 @ 1=0D
[    2.292864] initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs=
=0D
[    2.299809] calling  blk_iopoll_setup+0x0/0x54 @ 1=0D
[    2.304839] initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs=
=0D
[    2.311792] calling  blk_mq_init+0x0/0x16 @ 1=0D
[    2.316357] initcall blk_mq_init+0x0/0x16 returned 0 after 0 usecs=0D
[    2.322839] calling  genhd_device_init+0x0/0x6a @ 1=0D
[    2.328151] initcall genhd_device_init+0x0/0x6a returned 0 after 0 usecs=
=0D
[    2.335200] calling  blk_dev_integrity_init+0x0/0x2f @ 1=0D
[    2.340805] initcall blk_dev_integrity_init+0x0/0x2f returned 0 after 0 =
usecs=0D
[    2.348294] calling  pci_slot_init+0x0/0x40 @ 1=0D
[    2.353066] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs=0D
[    2.359733] calling  fbmem_init+0x0/0x96 @ 1=0D
[    2.364265] initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs=0D
[    2.370666] calling  acpi_init+0x0/0x26b @ 1=0D
[    2.375238] ACPI: Added _OSI(Module Device)=0D
[    2.379625] ACPI: Added _OSI(Processor Device)=0D
[    2.384286] ACPI: Added _OSI(3.0 _SCP Extensions)=0D
[    2.389223] ACPI: Added _OSI(Processor Aggregator Device)=0D
[    2.408761] ACPI: Executed 4 blocks of module-level executable AML code=
=0D
[    2.491078] ACPI: Interpreter enabled=0D
[    2.494943] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (2012.518520] ACPI: Using IOAPIC for interrupt routing=0D
[    2.523883] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)=0D
[    2.562693] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACP=
I motherboard resources=0D
[    2.571823] PCI: Using MM PCI: Using host bridge windows from ACPI; if n=
ecessary, use "pci=3Dnocrs" and report a bug=0D
[    2.706737] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=0D
[    2.713243] acpi PNP0A03:00: _OSC: OS supports [Extendnfig ASPM ClockPM =
Segments MSI]=0D
[    2.721881] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM=
=0D
[    2.730714] acpi PNP0A03:00: ignoring host bridge window [mem 0x000d0000=
-0x000dffff] (conflicts with Adapter ROM [mem 0x000cf000-0x000d09ff])=0D
[    2.745698] PCI host bridge to bus 0000:00=0D
[    2.750008] pci_bus 0000:00: root bus resource [bus 00-ff]=0D
[    2.755767] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]=0D
[    2.762266] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]=0D
[    2.768760] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]=0D
[    2.775980] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdffffff=
f]=0D
[    2.783201] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebffff=
f]=0D
[    2.790447] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000=0D
[    2.797573] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400=0D
[    2.804698] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400=0D
[    2.811044] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold=0D
[    2.818004] pci 0000:00:06.0: System wakeup disabled by ACPI=0D
[    2.824312] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400=0D
[    2.830652] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold=0D
[    2.837592] pci 0000:00:07.0: System wakeup disabled by ACPI=0D
[    2.843901] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601=0D
[    2.850214] pci 0000:00:11.0: reg 0x10: [io  0x7000-0x7007]=0D
[    2.856068] pci 0000:00:11.0: reg 0x14: [io  0x6000-0x6003]=0D
[    2.861917] pci 0000:00:11.0: reg 0x18: [io  0x5000-0x5007]=0D
[    2.867778] pci 0000:00:11.0: reg 0x1c: [io  0x4000-0x4003]=0D
[    2.873635] pci 0000:00:11.0: reg 0x20: [io  0x3000-0x300f]=0D
[    2.879481] pci 0000:00:11.0: reg 0x24: [mem 0xfe6ffc00-0xfe6fffff]=0D
[    2.886832] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310=0D
[    2.893143] pci 0000:00:12.0: reg 0x10: [mem 0xfe6fe000-0xfe6fefff]=0D
[    2.900324] pci 0000:00:12.0: System wakeup disabled by ACPI=0D
[    2.906635] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310=0D
[    2.912943] pci 0000:00:12.1: reg 0x10: [mem 0xfe6fd000-0xfe6fdfff]=0D
[    2.920138] pci 0000:00:12.1: System wakeup disabled by ACPI=0D
[    2.926451] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320=0D
[    2.932771] pci 0000:00:12.2: reg 0x10: [mem 0xfe6ff800-0xfe6ff8ff]=0D
[    2.939428] pci 0000:00:12.2: supports D1 D2=0D
[    2.943906] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot=0D
[    2.950752] pci 0000:00:12.2: System wakeup disabled by ACPI=0D
[    2.957066] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310=0D
[    2.963378] pci 0000:00:13.0: reg 0x10: [mem 0xfe6fc000-0xfe6fcfff]=0D
[    2.970562] pci 0000:00:13.0: System wakeup disabled by ACPI=0D
[    2.976863] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310=0D
[    2.983179] pci 0000:00:13.1: reg 0x10: [mem 0xfe6f7000-0xfe6f7fff]=0D
[    2.990348] pci 0000:00:13.1: System wakeup disabled by ACPI=0D
[    2.996660] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320=0D
[    3.002979] pci 0000:00:13.2: reg 0x10: [mem 0xfe6ff400-0xfe6ff4ff]=0D
[    3.009633] pci 0000:00:13.2: supports D1 D2=0D
[    3.014115] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot=0D
[    3.020954] pci 0000:00:13.2: System wakeup disabled by ACPI=0D
[    3.027263] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500=0D
[    3.034422] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100=0D
[    3.041572] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401=0D
[    3.048464] pci 0000:00:14.4: System wakeup disabled by ACPI=0D
[    3.054777] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310=0D
[    3.061086] pci 0000:00:14.5: reg 0x10: [mem 0xfe6f6000-0xfe6f6fff]=0D
[    3.068267] pci 0000:00:14.5: System wakeup disabled by ACPI=0D
[    3.074563] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000=0D
[    3.081619] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000=0D
[    3.088674] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000=0D
[    3.095728] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000=0D
[    3.102778] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000=0D
[    3.110097] pci 0000:01:05.0: [1002:9610] type 00 class 0x030000=0D
[    3.116413] pci 0000:01:05.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]=
=0D
[    3.123451] pci 0000:01:05.0: reg 0x14: [io  0x8000-0x80ff]=0D
[    3.129290] pci 0000:01:05.0: reg 0x18: [mem 0xfe8f0000-0xfe8fffff]=0D
[    3.135875] pci 0000:01:05.0: reg 0x24: [mem 0xfe700000-0xfe7fffff]=0D
[    3.142469] pci 0000:01:05.0: supports D1 D2=0D
[    3.147337] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300=0D
[    3.153645] pci 0000:01:05.1: reg 0x10: [mem 0xfe8e8000-0xfe8ebfff]=0D
[    3.160238] pci 0000:01:05.1: supports D1 D2=0D
[    3.165065] pci 0000:00:01.0: PCI bridge to [bus 01]=0D
[    3.170288] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]=0D
[    3.176687] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff=
]=0D
[    3.183810] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff=
 64bit pref]=0D
[    3.192166] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000=0D
[    3.198479] pci 0000:02:00.0: reg 0x10: [io  0x9800-0x98ff]=0D
[    3.204343] pci 0000:02:00.0: reg 0x18: [mem 0xfe9ff000-0xfe9fffff 64bit=
]=0D
[    3.211476] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64bit=
 pref]=0D
[    3.219065] pci 0000:02:00.0: reg 0x30: [mem 0xfe9c0000-0xfe9dffff pref]=
=0D
[    3.226156] pci 0000:02:00.0: supports D1 D2=0D
[    3.230631] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    3.239875] pci 0000:00:06.0: PCI bridge to [bus 02]=0D
[    3.245082] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]=0D
[    3.251486] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fffff=
]=0D
[    3.258632] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff=
 64bit pref]=0D
[    3.266986] pci 0000:03:00.0: [197b:2361] type 00 class 0x010601=0D
[    3.273362] pci 0000:03:00.0: reg 0x24: [mem 0xfeafe000-0xfeafffff]=0D
[    3.280001] pci 0000:03:00.0: PME# supported from D3hot=0D
[    3.285923] pci 0000:03:00.1: [197b:2361] type 00 class 0x010185=0D
[    3.292258] pci 0000:03:00.1: reg 0x10: [io  0xb800-0xb807]=0D
[    3.298119] pci 0000:03:00.1: reg 0x14: [io  0xb400-0xb403]=0D
[    3.303968] pci 0000:03:00.1: reg 0x18: [io  0xb000-0xb007]=0D
[    3.309828] pci 0000:03:00.1: reg 0x1c: [io  0xa800-0xa803]=0D
[    3.315689] pci 0000:03:00.1: reg 0x20: [io  0xa400-0xa40f]=0D
[    3.321913] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'=0D
[    3.332421] pci 0000:00:07.0: PCI bridge to [bus 03]=0D
[    3.337644] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]=0D
[    3.344044] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff=
]=0D
[    3.351402] pci 0000:04:05.0: [10b7:1700] type 00 class 0x020000=0D
[    3.357732] pci 0000:04:05.0: reg 0x10: [mem 0xfebfc000-0xfebfffff]=0D
[    3.364324] pci 0000:04:05.0: reg 0x14: [io  0xe800-0xe8ff]=0D
[    3.370231] pci 0000:04:05.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]=
=0D
[    3.377307] pci 0000:04:05.0: supports D1 D2=0D
[    3.381788] pci 0000:04:05.0: PME# supported from D0 D1 D2 D3hot D3cold=
=0D
[    3.389160] pci 0000:04:07.0: [9710:9835] type 00 class 0x070002=0D
[    3.395489] pci 0000:04:07.0: reg 0x10: [io  0xe400-0xe407]=0D
[    3.401345] pci 0000:04:07.0: reg 0x14: [io  0xe000-0xe007]=0D
[    3.407197] pci 0000:04:07.0: reg 0x18: [io  0xd800-0xd807]=0D
[    3.413057] pci 0000:04:07.0: reg 0x1c: [io  0xd400-0xd407]=0D
[    3.418916] pci 0000:04:07.0: reg 0x20: [io  0xd000-0xd007]=0D
[    3.424781] pci 0000:04:07.0: reg 0x24: [io  0xc800-0xc80f]=0D
[    3.430994] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive decode=
)=0D
[    3.438126] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]=0D
[    3.444521] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff=
]=0D
[    3.451664] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)=0D
[    3.459994] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)=0D
[    3.468310] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)=0D
[    3.477357] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffffff=
] (subtractive decode)=0D
[    3.486415] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff=
] (subtractive decode)=0D
[    3.495456] pci_bus 0000:00: on NUMA node 0=0D
[    3.525114] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 *14 15)=0D
[    3.532565] ACPI: PCI Interrupt Link [LNKB] (IRQs pt Link [LNKE] (IRQs *=
4 10 11 12 14 15)=0D
[    3.562118] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 10 11 12 14 15) *0, =
disabled.=0D
[    3.570582] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 *15)=0D
[    3.577814] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 10 11 12 14 15) *0, =
disabled.=0D
[    3.586235] ACPI: Enabled 1 GPEs in block 00 to 1F=0D
[    3.591384] initcall acpi_init+0x0/0x26b returned 0 after 451171 usecs=0D
[    3.598253] calling  pnp_init+0x0/0xf @ 1=0D
[    3.602541] initcall pnp_init+0x0/0xf returned 0 after 0 usecs=0D
[    3.608667] calling  balloon_init+0x0/0x1fa @ 1=0D
[    3.613432] initcall balloon_init+0x0/0x1fa returned -19 after 0 usecs=0D
[    3.620294] calling  xen_setup_shutdown_event+0x0/0x30 @ 1=0D
[    3.626056] initcall xen_setup_shutdown_event+0x0/0x30 returned -19 afte=
r 0 usecs=0D
[    3.633917] calling  xenbus_probe_backend_init+0x0/0x23 @ 1=0D
[    3.639854] initcall xenbus_probe_backend_init+0x0/0x23 returned 0 after=
 0 usecs=0D
[    3.647618] calling  xenbus_probe_frontend_init+0x0/0x7b @ 1=0D
[    3.653650] initcall xenbus_probe_frontend_init+0x0/0x7b returned 0 afte=
r 0 usecs=0D
[    3.661511] calling  xen_acpi_pad_init+0x0/0x41 @ 1=0D
[    3.666635] initcall xen_acpi_pad_init+0x0/0x41 returned -19 after 0 use=
cs=0D
[    3.673863] calling  balloon_init+0x0/0xdd @ 1=0D
[    3.678531] initcall balloon_init+0x0/0xdd returned -19 after 0 usecs=0D
[    3.685309] calling  misc_init+0x0/0xad @ 1=0D
[    3.689756] initcall misc_init+0x0/0xad returned 0 after 0 usecs=0D
[    3.696074] calling  vga_arb_device_init+0x0/0xcc @ 1=0D
[    3.701559] vgaarb: device added: PCI:0000:01:05.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone=0D
[    3.710062] vgaarb: loaded=0D
[    3.712893] vgaarb: bridge control possible 0000:01:05.0=0D
[    3.718475] initcall vga_arb_device_init+0x0/0xcc returned 0 after 16601=
 usecs=0D
[    3.726058] calling  cn_init+0x0/0xb0 @ 1=0D
[    3.730289] initcall cn_init+0x0/0xb0 returned 0 after 0 usecs=0D
[    3.736409] calling  dma_buf_init+0x0/0x62 @ 1=0D
[    3.741081] initcall dma_buf_init+0x0/0x62 returned 0 after 0 usecs=0D
[    3.747650] calling  phy_init+0x0/0x2f @ 1=0D
[    3.752170] initcall phy_init+0x0/0x2f returned 0 after 0 usecs=0D
[    3.758378] calling  init_pcmcia_cs+0x0/0x32 @ 1=0D
[    3.763252] initcall init_pcmcia_cs+0x0/0x32 returned 0 after 0 usecs=0D
[    3.770003] calling  usb_init+0x0/0x14c @ 1=0D
[    3.774398] ACPI: bus type USB registered=0D
[    3.778791] usbcore: registered new interface driver usbfs=0D
[    3.784622] usbcore: registered new interface driver hub=0D
[    3.790306] usbcore: registered new device driver usb=0D
[    3.795598] initcall usb_init+0x0/0x14c returned 0 after 20507 usecs=0D
[    3.802262] calling  serio_init+0x0/0x2e @ 1=0D
[    3.806815] initcall serio_init+0x0/0x2e returned 0 after 0 usecs=0D
[    3.813211] calling  input_init+0x0/0xf1 @ 1=0D
[    3.817727] initcall input_init+0x0/0xf1 returned 0 after 0 usecs=0D
[    3.824127] calling  rtc_init+0x0/0x50 @ 1=0D
[    3.828444] initcall rtc_init+0x0/0x50 returned 0 after 0 usecs=0D
[    3.834658] calling  pps_init+0x0/0xa6 @ 1=0D
[    3.838983] pps_core: LinuxPPS API ver. 1 registered=0D
[    3.844190] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>=0D
[    3.853769] initcall pps_init+0x0/0xa6 returned 0 after 14648 usecs=0D
[    3.860341] calling  ptp_init+0x0/0x8e @ 1=0D
[    3.864673] PTP clock support registered=0D
[    3.868784] initcall ptp_init+0x0/0x8e returned 0 after 3906 usecs=0D
[    3.875275] calling  power_supply_class_init+0x0/0x39 @ 1=0D
[    3.880966] initcall power_supply_class_init+0x0/0x39 returned 0 after 0=
 usecs=0D
[    3.888540] calling  hwmon_init+0x0/0xda @ 1=0D
[    3.893049] initcall hwmon_init+0x0/0xda returned 0 after 0 usecs=0D
[    3.899455] calling  leds_init+0x0/0x36 @ 1=0D
[    3.903870] initcall leds_init+0x0/0x36 returned 0 after 0 usecs=0D
[    3.910173] calling  efisubsys_init+0x0/0x115 @ 1=0D
[    3.915108] initcall efisubsys_init+0x0/0x115 returned 0 after 0 usecs=0D
[    3.921955] calling  pci_subsys_init+0x0/0x48 @ 1=0D
[    3.926897] PCI: Using ACPI for IRQ routing=0D
[    3.931281] PCI: pci_cache_line_size set to 64 bytes=0D
[    3.936535] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]=0D
[    3.942830] e820: reserve RAM buffer [mem 0xcfeb0000-0xcfffffff]=0D
[    3.949122] initcall pci_subsys_init+0x0/0x48 returned 0 after 22460 use=
cs=0D
[    3.956332] calling  proto_init+0x0/0xf @ 1=0D
[    3.960722] initcall proto_init+0x0/0xf returned 0 after 0 usecs=0D
[    3.967024] calling  net_dev_init+0x0/0x15d @ 1=0D
[    3.972553] initcall net_dev_init+0x0/0x15d returned 0 after 976 usecs=0D
[    3.979396] calling  neigh_init+0x0/0xa4 @ 1=0D
[    3.983868] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs=0D
[    3.990256] calling  fib_rules_init+0x0/0xbd @ 1=0D
[    3.995094] initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs=0D
[    4.001847] calling  pktsched_init+0x0/0x121 @ 1=0D
[    4.006695] initcall pktsched_init+0x0/0x121 returned 0 after 0 usecs=0D
[    4.013448] calling  tc_filter_init+0x0/0x6a @ 1=0D
[    4.018297] initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs=0D
[    4.025052] calling  tc_action_init+0x0/0x6a @ 1=0D
[    4.029898] initcall tc_action_init+0x0/0x6a returned 0 after 0 usecs=0D
[    4.036655] calling  genl_init+0x0/0x7a @ 1=0D
[    4.041062] initcall genl_init+0x0/0x7a returned 0 after 0 usecs=0D
[    4.047361] calling  cipso_v4_init+0x0/0x5a @ 1=0D
[    4.052108] initcall cipso_v4_init+0x0/0x5a returned 0 after 0 usecs=0D
[    4.058776] calling  netlbl_init+0x0/0x7d @ 1=0D
[    4.063340] NetLabel: Initializing=0D
[    4.066904] NetLabel:  domain hash size =3D 128=0D
[    4.071462] NetLabel:  protocols =3D UNLABELED CIPSOv4=0D
[    4.076718] NetLabel:  unlabeled traffic allowed by default=0D
[    4.082561] initcall netlbl_init+0x0/0x7d returned 0 after 18554 usecs=0D
[    4.089405] calling  rfkill_init+0x0/0x68 @ 1=0D
[    4.094125] initcall rfkill_init+0x0/0x68 returned 0 after 0 usecs=0D
[    4.100620] calling  xen_mcfg_late+0x0/0xa6 @ 1=0D
[    4.105369] initcall xen_mcfg_late+0x0/0xa6 returned 0 after 0 usecs=0D
[    4.112088] calling  xen_p2m_debugfs+0x0/0x49 @ 1=0D
[    4.117033] initcall xen_p2m_debugfs+0x0/0x49 returned 0 after 0 usecs=0D
[    4.123884] calling  xen_spinlock_debugfs+0x0/0x120 @ 1=0D
[    4.129420] initcall xen_spinlock_debugfs+0x0/0x120 returned 0 after 0 u=
secs=0D
[    4.136826] calling  nmi_warning_debugfs+0x0/0x26 @ 1=0D
[    4.142123] initcall nmi_warning_debugfs+0x0/0x26 returned 0 after 0 use=
cs=0D
[    4.149333] calling  hpet_late_init+0x0/0xe6 @ 1=0D
[    4.154184] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0=0D
[    4.159598] hpet0: 4 comparators, 32-bit 14.318180 MHz counter=0D
[    4.167720] initcall hpet_late_init+0x0/0xe6 returned 0 after 12695 usec=
s=0D
[    4.174841] calling  init_amd_nbs+0x0/0xb6 @ 1=0D
[    4.179509] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs=0D
[    4.186085] calling  clocksource_done_booting+0x0/0x3b @ 1=0D
[    4.191885] Switched to clocksource hpet=0D
[    4.196045] initcall clocksource_done_booting+0x0/0x3b returned 0 after =
5056 usecs=0D
[    4.204006] calling  tracer_init_debugfs+0x0/0x165 @ 1=0D
[    4.209921] initcall tracer_init_debugfs+0x0/0x165 returned 0 after 499 =
usecs=0D
[    4.217427] calling  init_trace_printk_function_export+0x0/0x33 @ 1=0D
[    4.224025] initcall init_trace_printk_function_export+0x0/0x33 returned=
 0 after 12 usecs=0D
[    4.232628] calling  event_trace_init+0x0/0x1ee @ 1=0D
[    4.257711] initcall event_trace_init+0x0/0x1ee returned 0 after 19503 u=
secs=0D
[    4.265126] calling  init_kprobe_trace+0x0/0    4.277432] calling  init_=
pipe_fs+0x0/0x3d @ 1=0D
[    4.282216] initcall init_pipe_fs+0x0/0x3d returned 0 after 113 usecs=0D
[    4.288986] calling  eventpoll_init+0x0/0xd0 @ 1=0D
[    4.293931] initcall eventpoll_init+0x0/0xd0 returned 0 after 94 usecs=0D
[    4.300787] calling  anon_inode_init+0x0/0x56 @ 1=0D
[    4.305860] initcall anon_inode_init+0x0/0x56 returned 0 after 117 usecs=
=0D
[    4.312900] calling  proc_cmdline_init+0x0/0x27 @ 1=0D
[    4.318034] initcall proc_cmdline_init+0x0/0x27 returned 0 after 20 usec=
s=0D
[    4.325168] calling  proc_consoles_init+0x0/0x27 @ 1=0D
[    4.330408] initcall proc_consoles_init+0x0/0x27 returned 0 after 15 use=
cs=0D
[    4.337647] calling  proc_cpuinfo_init+0x0/0x27 @ 1=0D
[    4.342791] initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 15 usec=
s=0D
[    4.349940] calling  proc_devices_init+0x0/0x27 @ 1=0D
[    4.355092] initcall proc_devices_init+0x0/0x27 returned 0 after 15 usec=
s=0D
[    4.362238] calling  proc_interrupts_init+0x0/0x27 @ 1=0D
[    4.367661] initcall proc_interrupts_init+0x0/0x27 returned 0 after 15 u=
secs=0D
[    4.375079] calling  proc_loadavg_init+0x0/0x27 @ 1=0D
[    4.380230] initcall proc_loadavg_init+0x0/0x27 returned 0 after 16 usec=
s=0D
[    4.387378] calling  proc_meminfo_init+0x0/0x27 @ 1=0D
[    4.392522] initcall proc_meminfo_init+0x0/0x27 returned 0 after 15 usec=
s=0D
[    4.399667] calling  proc_stat_init+0x0/0x27 @ 1=0D
[    4.404533] initcall proc_stat_init+0x0/0x27 returned 0 after 15 usecs=0D
[    4.411403] calling  proc_uptime_init+0x0/0x27 @ 1=0D
[    4.416456] initcall proc_uptime_init+0x0/0x27 returned 0 after 15 usecs=
=0D
[    4.423507] calling  proc_version_init+0x0/0x27 @ 1=0D
[    4.428663] initcall proc_version_init+0x0/0x27 returned 0 after 24 usec=
s=0D
[    4.435810] calling  proc_softirqs_init+0x0/0x27 @ 1=0D
[    4.441046] initcall proc_softirqs_init+0x0/0x27 returned 0 after 14 use=
cs=0D
[    4.448285] calling  proc_kcore_init+0x0/0xae @ 1=0D
[    4.453247] initcall proc_kcore_init+0x0/0xae returned 0 after 19 usecs=
=0D
[    4.460200] calling  vmcore_init+0x0/0x68b @ 1=0D
[    4.464886] initcall vmcore_init+0x0/0x68b returned 0 after 4 usecs=0D
[    4.471475] calling  proc_kmsg_init+0x0/0x2a @ 1=0D
[    4.476346] initcall proc_kmsg_init+0x0/0x2a returned 0 after 15 usecs=0D
[    4.483219] calling  proc_page_init+0x0/0x4a @ 1=0D
[    4.488096] initcall proc_page_init+0x0/0x4a returned 0 after 21 usecs=0D
[    4.494962] calling  init_ramfs_fs+0x0/0x44 @ 1=0D
[    4.499805] initcall init_ramfs_fs+0x0/0x44 returned 0 after 78 usecs=0D
[    4.506590] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1=0D
[    4.511995] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 4 us=
ecs=0D
[    4.519315] calling  acpi_event_init+0x0/0x37 @ 1=0D
[    4.524294] initcall acpi_event_init+0x0/0x37 returned 0 after 38 usecs=
=0D
[    4.531245] calling  pnp_system_init+0x0/0xf @ 1=0D
[    4.536154] initcall pnp_system_init+0x0/0xf returned 0 after 60 usecs=0D
[    4.543025] calling  pnpacpi_init+0x0/0x88 @ 1=0D
[    4.547709] pnp: PnP ACPI init=0D
[    4.550957] ACPI: bus type PNP registered=0D
[    4.556363] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active=
)=0D
[    4.564049] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=0D
[    4.591161] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reser=
ved=0D
[    4.598483] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved=
=0D
[    4.605436] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active=
)=0D
[    4.614796] system 00:03: [io  0x04d0-0x04d1] has been reserved=0D
[    4.621027] system 00:03: [io  0x040b] has been reserved=0D
[    4.626620] system 00:03: [io  0x04d6] has been reserved=0D
[    4.632219] system 00:03: [io  0x0c00-0x0c01] has been reserved=0D
[    4.638461] system 00:03: [io  0x0c14] has been reserved=0D
[    4.644057] system 00:03: [io  0x0c50-0x0c51] has been reserved=0D
[    4.650291] system 00:03: [io  0x0c52] has been reserved=0D
[    4.655897] system 00:03: [io  0x0c6c] has been reserved=0D
[    4.661498] system 00:03: [io  0x0c6f] has been reserved=0D
[    4.667089] system 00:03: [io  0x0cd0-0x0cd1] has been reserved=0D
[    4.673324] system 00:03: [io  0x0cd2-0x0cd3] has been reserved=0D
[    4.679554] system 00:03: [io  0x0cd4-0x0cd5] has been reserved=0D
[    4.685790] system 00:03: [io  0x0cd6-0x0cd7] has been reserved=0D
[    4.692027] system 00:03: [io  0x0cd8-0x0cdf] has been reserved=0D
[    4.698268] system 00:03: [io  0x0800-0x089f] could not be reserved=0D
[    4.704868] system 00:03: [io  0x0b00-0x0b0f] has been reserved=0D
[    4.711105] system 00:03: [io  0x0b20-0x0b3f] has been reserved=0D
[    4.717344] system 00:03: [io  0x0900-0x090f] has been reserved=0D
[    4.723578] system 00:03: [io  0x0910-0x091f] has been reserved=0D
[    4.729826] system 00:03: [io  0xfe00-0xfefe] has been reserved=0D
[    4.736063] system 00:03: [mem 0xffb80000-0xffbfffff] has been reserved=
=0D
[    4.743034] system 00:03: [mem 0xfec10000-0xfec1001f] has been reserved=
=0D
[    4.749996] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active=
)=0D
[    4.759597] system 00:04: [io  0x0e00-0x0e0f] has been reserved=0D
[    4.765832] system 00:04: [io  0x0e80-0x0e8f] has been reserved=0D
[    4.772075] system 00:04: [io  0x0f40-0x0f4f] has been reserved=0D
[    4.778311] system 00:04: [io  0x0a30-0x0a3f] has been reserved=0D
[    4.784542] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active=
)=0D
[    4.792210] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved=
=0D
[    4.799157] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active=
)=0D
[    4.808009] system 00:06: [mem 0x00000000-0x0009ffff] could not be reser=
ved=0D
[    4.815323] system 00:06: [mem 0x000c0000-0x000cffff] could not be reser=
ved=0D
[    4.822653] system 00:06: [mem 0x000e0000-0x000fffff] could not be reser=
ved=0D
[    4.829988] system 00:06: [mem 0x00100000-0xcfefffff] could not be reser=
ved=0D
[    4.837319] system 00:06: [mem 0xfec00000-0xffffffff] could not be reser=
ved=0D
[    4.844644] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active=
)=0D
[    4.852643] pnp: PnP ACPI: found 7 devices=0D
[    4.856949] ACPI: bus type PNP unregistered=0D
[    4.861346] initcall pnpacpi_init+0x0/0x88 returned 0 after 306575 usecs=
=0D
[    4.868388] calling  pcistub_init+0x0/0x280 @ 1=0D
[    4.873980] initcall pcistub_init+0x0/0x280 returned 0 after 803 usecs=0D
[    4.880846] calling  chr_dev_init+0x0/0xc9 @ 1=0D
[    4.896349] initcall chr_dev_init+0x0/0xc9 returned 0 after 10582 usecs=
=0D
[    4.903311] calling  firmware_class_init+0x0/0xd7992] calling  init_pcmc=
ia_bus+0x0/0x5e @ 1=0D
[    4.921030] initcall init_pcmcia_bus+0x0/0x5e returned 0 after 78 usecs=
=0D
[    4.927989] calling  thermal_init+0x0/0x78 @ 1=0D
[    4.932723] initcall thermal_init+0x0/0x78 returned 0 after 58 usecs=0D
[    4.939406] calling  cpufreq_gov_performance_init+0x0/0xf @ 1=0D
[    4.945457] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 aft=
er 5 usecs=0D
[    4.953431] calling  init_acpi_pm_clocksource+0x0/0x18d @ 1=0D
[    4.993807] initcall init_acpi_pm_clocksource+0x0/0x18d returned 0 after=
 33742 usecs=0D
[    5.001955] calling  pcibios_assign_resources+0x0/0x8f @ 1=0D
[    5.007761] pci 0000:00:01.0: PCI bridge to [bus 01]=0D
[    5.012986] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]=0D
[    5.019411] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff=
]=0D
[    5.026558] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff=
 64bit pref]=0D
[    5.034709] pci 0000:00:06.0: PCI bridge to [bus 02]=0D
[    5.039939] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]=0D
[    5.046352] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fffff=
]=0D
[    5.053493] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff=
 64bit pref]=0D
[    5.061621] pci 0000:00:07.0: PCI bridge to [bus 03]=0D
[    5.066849] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]=0D
[    5.073265] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff=
]=0D
[    5.080413] pci 0000:00:14.4: PCI bridge to [bus 04]=0D
[    5.085647] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]=0D
[    5.092057] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff=
]=0D
[    5.099206] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]=0D
[    5.105064] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]=0D
[    5.110916] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]=0D
[    5.117509] pci_bus 0000:00: resource 7 [mem 0xcff00000-0xdfffffff]=0D
[    5.124096] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]=0D
[    5.130689] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]=0D
[    5.136550] pci_bus 0000:01: resource 1 [mem 0xfe700000-0xfe8fffff]=0D
[    5.143134] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit=
 pref]=0D
[    5.150724] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]=0D
[    5.156591] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]=0D
[    5.163177] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit=
 pref]=0D
[    5.170769] pci_bus 0000:03: resource 0 [io  0xa000-0xbfff]=0D
[    5.176640] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]=0D
[    5.183221] pci_bus 0000:04: resource 0 [io  0xc000-0xefff]=0D
[    5.189074] pci_bus 0000:04: resource 1 [mem 0xfeb00000-0xfebfffff]=0D
[    5.195657] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]=0D
[    5.201526] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]=0D
[    5.207379] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]=0D
[    5.213966] pci_bus 0000:04: resource 7 [mem 0xcff00000-0xdfffffff]=0D
[    5.220555] pci_bus 0000:04: resource 8 [mem 0xf0000000-0xfebfffff]=0D
[    5.227134] initcall pcibios_assign_resources+0x0/0x8f returned 0 after =
214468 usecs=0D
[    5.235281] calling  sysctl_core_init+0x0/0x23 @ 1=0D
[    5.240345] initcall sysctl_core_init+0x0/0x23 returned 0 after 27 usecs=
=0D
[    5.247398] calling  inet_init+0x0/0x25b @ 1=0D
[    5.252105] NET: Registered protocol family 2=0D
[    5.257436] TCP established hash table entries: 8192 (order: 3, 32768 by=
tes)=0D
[    5.264877] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)=0D
[    5.271676] TCP: Hash tables configured (established 8192 bind 8192)=0D
[    5.278403] TCP: reno registered=0D
[    5.281800] UDP hash table entries: 512 (order: 2, 16384 bytes)=0D
[    5.288046] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)=0D
[    5.295075] initcall inet_init+0x0/0x25b returned 0 after 42209 usecs=0D
[    5.301848] calling  ipv4_offload_init+0x0/0x5d @ 1=0D
[    5.306980] initcall ipv4_offload_init+0x0/0x5d returned 0 after 4 usecs=
=0D
[    5.314045] calling  af_unix_init+0x0/0x4d @ 1=0D
[    5.318763] NET: Registered protocol family 1=0D
[    5.323363] initcall af_unix_init+0x0/0x4d returned 0 after 4530 usecs=0D
[    5.330230] calling  ipv6_offload_init+0x0/0x7a @ 1=0D
[    5.335366] initcall ipv6_offload_init+0x0/0x7a returned 0 after 4 usecs=
=0D
[    5.342423] calling  init_sunrpc+0x0/0x5f @ 1=0D
[    5.347383] RPC: Registered named UNIX socket transport module.=0D
[    5.353594] RPC: Registered udp transport module.=0D
[    5.358534] RPC: Registered tcp transport module.=0D
[    5.363482] RPC: Registered tcp NFSv4.1 backchannel transport module.=0D
[    5.370242] initcall init_sunrpc+0x0/0x5f returned 0 after 22711 usecs=0D
[    5.377112] calling  pci_apply_final_quirks+0x0/0x112 @ 1=0D
[    5.382784] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabl=
ed=0D
[    5.391478] IOAPIC[0]: Set routing entry (4-16 -> 0x41 -> IRQ 16 Mode:1 =
Active:1 Dest:15)=0D
[    5.464614] IOAPIC[0]: Set routing entry (4-16 -> 0x51 -> IRQ 16 Mode:1 =
Active:1 Dest:15)=0D
[    5.548462] IOAPIC[0]: Set routing entry (4-17 -> 0x61 -> IRQ 17 Mode:1 =
Active:1 Dest:15)=0D
[    5.559823] IOAPIC[0]: Set routing entry (4-18 -> 0x71 -> IRQ 18 Mode:1 =
Active:1 Dest:15)=0D
[    5.643434] IOAPIC[0]: Set routing entry (4-18 -> 0x81 -> IRQ 18 Mode:1 =
Active:1 Dest:15)=0D
[    5.727331] IOAPIC[0]: Set routing entry (4-19 -> 0x91 -> IRQ 19 Mode:1 =
Active:1 Dest:15)=0D
[    5.738726] IOAPIC[0]: Set rout[    5.820803] pci 0000:01:05.0: Boot vid=
eo device=0D
[    5.825578] PCI: CLS 64 bytes, default 64=0D
[    5.829788] initcall pci_ap0 after 436949 usecs=0D
[    5.837837] calling  populate_rootfs+0x0/0xf9 @ 1=0D
[    5.842943] Unpacking initramfs...=0D
[    7.694231] microcode: updated early to new patch_level=3D0x010000db=0D
[    7.727982] Freeing initrd memory: 83112K (f2ad4000 - f7bfe000)=0D
[    7.734211] initcall populate_rootfs+0x0/0xf9 returned 0 53317] calling =
 register_kernel_offset_dumper+0x0/0x16 @ 1=0D
[    7.759535] initcall register_kernel_offset_dumper+0x0/0x16 returned 0 a=
fter 1 usecs=0D
[    7.767682] calling  i8259A_init_ops+0x0/0x1d @ 1=0D
[    7.772628] initcall i8259A_init_ops+0x0/0x1d returned 0 after 1 usecs=0D
[    7.779502] calling  sbf_init+0x0/0xf1 @ 1=0D
[    7.783810] initcall sbf_init+0x0/0xf1 returned 0 after 1 usecs=0D
[    7.790036] calling  init_tsc_clocksource+0x0/0xa7 @ 1=0D
[    7.795452] initcall init_tsc_clocksource+0x0/0xa7 returned 0 after 2 us=
ecs=0D
[    7.802767] calling  add_rtc_cmos+0x0/0x99 @ 1=0D
[    7.807445] initcall add_rtc_cmos+0x0/0x99 returned 0 after 2 usecs=0D
[    7.814022] calling  i8237A_init_ops+0x0/0x11 @ 1=0D
[    7.818964] initcall i8237A_init_ops+0x0/0x11 returned 0 after 1 usecs=0D
[    7.825828] calling  cache_sysfs_init+0x0/0x69 @ 1=0D
[    7.832182] initcall cache_sysfs_init+0x0/0x69 returned 0 after 1290 use=
cs=0D
[    7.839409] calling  amd_uncore_init+0x0/0x111 @ 1=0D
[    7.844443] initcall amd_uncore_init+0x0/0x111 returned -19 after 0 usec=
s=0D
[    7.851584] calling  intel_uncore_init+0x0/0x3ea @ 1=0D
[    7.856797] initcall intel_uncore_init+0x0/0x3ea returned -19 after 0 us=
ecs=0D
[    7.864117] calling  rapl_pmu_init+0x0/0x194 @ 1=0D
[    7.868973] initcall rapl_pmu_init+0x0/0x194 returned 0 after 2 usecs=0D
[    7.875745] calling  inject_init+0x0/0x30 @ 1=0D
[    7.880319] Machine check injector initialized=0D
[    7.884994] initcall inject_init+0x0/0x30 returned 0 after 4568 usecs=0D
[    7.891772] calling  thermal_throttle_init_device+0x0/0x6d @ 1=0D
[    7.897905] initcall thermal_throttle_init_device+0x0/0x6d returned 0 af=
ter 0 usecs=0D
[    7.905949] calling  microcode_init+0x0/0x18c @ 1=0D
[    7.911027] microcode: CPU0: patch_level=3D0x010000db=0D
[    7.916182] microcode: CPU1: patch_level=3D0x01000086=0D
[    7.921340] microcode: CPU2: patch_level=3D0x01000086=0D
[    7.926488] microcode: CPU3: patch_level=3D0x01000086=0D
[    7.931792] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba=0D
[    7.941048] initcall microcode_init+0x0/0x18c returned 0 after 29479 use=
cs=0D
[    7.948277] calling  amd_ibs_init+0x0/0x21f @ 1=0D
[    7.953049] LVT offset 1 assigned for vector 0x400=0D
[    7.958093] IBS: LVT offset 1 assigned=0D
[    7.962161] perf: AMD IBS detected (0x0000001f)=0D
[    7.966932] initcall amd_ibs_init+0x0/0x21f returned 0 after 13570 usecs=
=0D
[    7.973967] calling  msr_init+0x0/0x153 @ 1=0D
[    7.978999] initcall msr_init+0x0/0x153 returned 0 after 618 usecs=0D
[    7.985496] calling  cpuid_init+0x0/0x153 @ 1=0D
[    7.990930] initcall cpuid_init+0x0/0x153 returned 0 after 811 usecs=0D
[    7.997622] calling  ioapic_init_ops+0x0/0x11 @ 1=0D
[    8.002562] initcall ioapic_init_ops+0x0/0x11 returned 0 after 0 usecs=0D
[    8.009434] calling  add_pcspkr+0x0/0x3b @ 1=0D
[    8.014003] initcall add_pcspkr+0x0/0x3b returned 0 after 84 usecs=0D
[    8.020515] calling  start_periodic_check_for_corruption+0x0/0x60 @ 1=0D
[    8.027285] Scanning for low memory corruption every 60 seconds=0D
[    8.033521] initcall start_periodic_check_for_corruption+0x0/0x60 return=
ed 0 after 6096 usecs=0D
[    8.042494] calling  sysfb_init+0x0/0x80 @ 1=0D
[    8.047084] initcall sysfb_init+0x0/0x80 returned 0 after 99 usecs=0D
[    8.053588] calling  pt_dump_init+0x0/0x70 @ 1=0D
[    8.058285] initcall pt_dump_init+0x0/0x70 returned 0 after 12 usecs=0D
[    8.064965] calling  aes_init+0x0/0xf @ 1=0D
[    8.069285] initcall aes_init+0x0/0xf returned 0 after 108 usecs=0D
[    8.075593] calling  proc_execdomains_init+0x0/0x27 @ 1=0D
[    8.081105] initcall proc_execdomains_init+0x0/0x27 returned 0 after 10 =
usecs=0D
[    8.088604] calling  ioresources_init+0x0/0x44 @ 1=0D
[    8.093650] initcall ioresources_init+0x0/0x44 returned 0 after 12 usecs=
=0D
[    8.100688] calling  snapshot_device_init+0x0/0xf @ 1=0D
[    8.106136] initcall snapshot_device_init+0x0/0xf returned 0 after 134 u=
secs=0D
[    8.113551] calling  irq_pm_init_ops+0x0/0x11 @ 1=0D
[    8.118501] initcall irq_pm_init_ops+0x0/0x11 returned 0 after 0 usecs=0D
[    8.125357] calling  init_posix_timers+0x0/0x22b @ 1=0D
[    8.130633] initcall init_posix_timers+0x0/0x22b returned 0 after 61 use=
cs=0D
[    8.137871] calling  init_posix_cpu_timers+0x0/0x9b @ 1=0D
[    8.143351] initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 1 u=
secs=0D
[    8.150765] calling  timekeeping_init_ops+0x0/0x11 @ 1=0D
[    8.156167] initcall timekeeping_init_ops+0x0/0x11 returned 0 after 5 us=
ecs=0D
[    8.163489] calling  init_clocksource_sysfs+0x0/0x58 @ 1=0D
[    8.169300] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after 21=
7 usecs=0D
[    8.176984] calling  init_timer_list_procfs+0x0/0x30 @ 1=0D
[    8.182573] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 6 =
usecs=0D
[    8.190083] calling  alarmtimer_init+0x0/0x151 @ 1=0D
[    8.195308] initcall alarmtimer_init+0x0/0x151 returned 0 after 180 usec=
s=0D
[    8.202452] calling  clockevents_init_sysfs+0x0/0xa3 @ 1=0D
[    8.208713] initcall clockevents_init_sysfs+0x0/0xa3 returned 0 after 66=
1 usecs=0D
[    8.216383] calling  init_tstats_procfs+0x0/0x30 @ 1=0D
[    8.221615] initcall init_tstats_procfs+0x0/0x30 returned 0 after 7 usec=
s=0D
[    8.228739] calling  futex_init+0x0/0xe6 @ 1=0D
[    8.233240] futex hash table entries: 2048 (order: 5, 131072 bytes)=0D
[    8.239878] initcall futex_init+0x0/0xe6 returned 0 after 6490 usecs=0D
[    8.246562] calling  proc_dma_init+0x0/0x27 @ 1=0D
[    8.251339] initcall proc_dma_init+0x0/0x27 returned 0 after 6 usecs=0D
[    8.258028] calling  proc_modules_init+0x0/0x27 @ 1=0D
[    8.263159] initcall proc_modules_init+0x0/0x27 returned 0 after 6 usecs=
=0D
[    8.270211] calling  kallsyms_init+0x0/0x2a @ 1=0D
[    8.274983] initcall kallsyms_init+0x0/0x2a returned 0 after 6 usecs=0D
[    8.281662] calling  pid_namespaces_init+0x0/0x32 @ 1=0D
[    8.287030] initcall pid_namespaces_init+0x0/0x32 returned 0 after 59 us=
ecs=0D
[    8.294359] calling  ikconfig_init+0x0/0x41 @ 1=0D
[    8.299131] initcall ikconfig_init+0x0/0x41 returned 0 after 7 usecs=0D
[    8.305810] calling  audit_init+0x0/0xed @ 1=0D
[    8.310296] audit: initializing netlink subsys (disabled)=0D
[    8.316026] audit: type=3D2000 audit(1405365715.647:1): initialized=0D
[    8.322431] initcall audit_init+0x0/0xed returned 0 after 11860 usecs=0D
[    8.329191] calling  audit_watch_init+0x0/0x31 @ 1=0D
[    8.334232] initcall audit_watch_init+0x0/0x31 returned 0 after 3 usecs=
=0D
[    8.341178] calling  audit_tree_init+0x0/0x3b @ 1=0D
[    8.346125] initcall audit_tree_init+0x0/0x3b returned 0 after 3 usecs=0D
[    8.352997] calling  init_kprobes+0x0/0x177 @ 1=0D
[    8.358188] initcall init_kprobes+0x0/0x177 returned 0 after 425 usecs=0D
[    8.365041] calling  utsname_sysctl_init+0x0/0x11 @ 1=0D
[    8.370369] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 14 us=
ecs=0D
[    8.377676] calling  init_tracepoints+0x0/0x29 @ 1=0D
[    8.382719] initcall init_tracepoints+0x0/0x29 returned 0 after 0 usecs=
=0D
[    8.389678] calling  init_blk_tracer+0x0/0x56 @ 1=0D
[    8.394627] initcall init_blk_tracer+0x0/0x56 returned 0 after 1 usecs=0D
[    8.401479] calling  perf_event_sysfs_init+0x0/0x8f @ 1=0D
[    8.407722] initcall perf_event_sysfs_init+0x0/0x8f returned 0 after 726=
 usecs=0D
[    8.415325] calling  init_per_zone_wmark_min+0x0/0x9d @ 1=0D
[    8.421001] initcall init_per_zone_wmark_min+0x0/0x9d returned 0 after 4=
 usecs=0D
[    8.428598] calling  kswapd_init+0x0/0x1d @ 1=0D
[    8.433321] initcall kswapd_init+0x0/0x1d returned 0 after 137 usecs=0D
[    8.440014] calling  extfrag_debug_init+0x0/0x7b @ 1=0D
[    8.445260] initcall extfrag_debug_init+0x0/0x7b returned 0 after 24 use=
cs=0D
[    8.452481] calling  setup_vmstat+0x0/0xcf @ 1=0D
[    8.457183] initcall setup_vmstat+0x0/0xcf returned 0 after 31 usecs=0D
[    8.463861] calling  mm_compute_batch_init+0x0/0x51 @ 1=0D
[    8.469359] initcall mm_compute_batch_init+0x0/0x51 returned 0 after 0 u=
secs=0D
[    8.476765] calling  slab_proc_init+0x0/0x2a @ 1=0D
[    8.481628] initcall slab_proc_init+0x0/0x2a returned 0 after 6 usecs=0D
[    8.488389] calling  workingset_init+0x0/0x38 @ 1=0D
[    8.493342] initcall workingset_init+0x0/0x38 returned 0 after 5 usecs=0D
[    8.500197] calling  proc_vmalloc_init+0x0/0x2a @ 1=0D
[    8.505332] initcall proc_vmalloc_init+0x0/0x2a returned 0 after 6 usecs=
=0D
[    8.512371] calling  procswaps_init+0x0/0x27 @ 1=0D
[    8.517230] initcall procswaps_init+0x0/0x27 returned 0 after 6 usecs=0D
[    8.523997] calling  init_frontswap+0x0/0x84 @ 1=0D
[    8.528881] initcall init_frontswap+0x0/0x84 returned 0 after 28 usecs=0D
[    8.535736] calling  hugetlb_init+0x0/0x3d8 @ 1=0D
[    8.540499] HugeTLB registered 2 MB page size, pre-allocated 0 pages=0D
[    8.547253] initcall hugetlb_init+0x0/0x3d8 returned 0 after 6602 usecs=
=0D
[    8.554211] calling  slab_proc_init+0x0/0x7 @ 1=0D
[    8.558966] initcall slab_proc_init+0x0/0x7 returned 0 after 0 usecs=0D
[    8.565652] calling  cpucache_init+0x0/0x40 @ 1=0D
[    8.570411] initcall cpucache_init+0x0/0x40 returned 0 after 1 usecs=0D
[    8.577094] calling  init_cleancache+0x0/0xa8 @ 1=0D
[    8.582074] initcall init_cleancache+0x0/0xa8 returned 0 after 30 usecs=
=0D
[    8.589019] calling  zs_init+0x0/0x90 @ 1=0D
[    8.593244] initcall zs_init+0x0/0x90 returned 0 after 2 usecs=0D
[    8.599372] calling  fcntl_init+0x0/0x2f @ 1=0D
[    8.603909] initcall fcntl_init+0x0/0x2f returned 0 after 38 usecs=0D
[    8.610407] calling  proc_filesystems_init+0x0/0x27 @ 1=0D
[    8.615898] initcall proc_filesystems_init+0x0/0x27 returned 0 after 6 u=
secs=0D
[    8.623310] calling  dio_init+0x0/0x32 @ 1=0D
[    8.627665] initcall dio_init+0x0/0x32 returned 0 after 48 usecs=0D
[    8.633971] calling  fsnotify_mark_init+0x0/0x46 @ 1=0D
[    8.639263] initcall fsnotify_mark_init+0x0/0x46 returned 0 after 73 use=
cs=0D
[    8.646493] calling  dnotify_init+0x0/0x7c @ 1=0D
[    8.651255] initcall dnotify_init+0x0/0x7c returned 0 after 87 usecs=0D
[    8.657924] calling  inotify_user_setup+0x0/0x50 @ 1=0D
[    8.663186] initcall inotify_user_setup+0x0/0x50 returned 0 after 50 use=
cs=0D
[    8.670411] calling  aio_setup+0x0/0x7e @ 1=0D
[    8.674980] initcall aio_setup+0x0/0x7e returned 0 after 170 usecs=0D
[    8.681466] calling  proc_locks_init+0x0/0x27 @ 1=0D
[    8.686426] initcall proc_locks_init+0x0/0x27 returned 0 after 6 usecs=0D
[    8.693282] calling  dquot_init+0x0/0x116 @ 1=0D
[    8.697860] VFS: Disk quotas dquot_6.5.2=0D
[    8.702139] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=0D
[    8.708993] initcall dquot_init+0x0/0x116 returned 0 after 10882 usecs=0D
[    8.715850] calling  init_v2_quota_format+0x0/0x1d @ 1=0D
[    8.721250] initcall init_v2_quota_format+0x0/0x1d returned 0 after 1 us=
ecs=0D
[    8.728575] calling  quota_init+0x0/0x2e @ 1=0D
[    8.733080] initcall quota_init+0x0/0x2e returned 0 after 26 usecs=0D
[    8.739581] calling  init_devpts_fs+0x0/0x52 @ 1=0D
[    8.744550] initcall init_devpts_fs+0x0/0x52 returned 0 after 110 usecs=
=0D
[    8.751506] calling  init_hugetlbfs_fs+0x0/0x145 @ 1=0D
[    8.756973] initcall init_hugetlbfs_fs+0x0/0x145 returned 0 after 230 us=
ecs=0D
[    8.764286] calling  init_fat_fs+0x0/0x4c @ 1=0D
[    8.768943] initcall init_fat_fs+0x0/0x4c returned 0 after 68 usecs=0D
[    8.775530] calling  init_vfat_fs+0x0/0xf @ 1=0D
[    8.780102] initcall init_vfat_fs+0x0/0xf returned 0 after 1 usecs=0D
[    8.786606] calling  init_msdos_fs+0x0/0xf @ 1=0D
[    8.791273] initcall init_msdos_fs+0x0/0xf returned 0 after 1 usecs=0D
[    8.797872] calling  init_iso9660_fs+0x0/0x69 @ 1=0D
[    8.802857] initcall init_iso9660_fs+0x0/0x69 returned 0 after 49 usecs=
=0D
[    8.809798] calling  init_nfs_fs+0x0/0x142 @ 1=0D
[    8.814936] initcall init_nfs_fs+0x0/0x142 returned 0 after 454 usecs=0D
[    8.821707] calling  init_nfs_v2+0x0/0x11 @ 1=0D
[    8.826300] initcall init_nfs_v2+0x0/0x11 returned 0 after 1 usecs=0D
[    8.832786] calling  init_nfs_v3+0x0/0x11 @ 1=0D
[    8.837371] initcall init_nfs_v3+0x0/0x11 returned 0 after 1 usecs=0D
[    8.843865] calling  init_nfs_v4+0x0/0x30 @ 1=0D
[    8.848455] NFS: Registering the id_resolver key type=0D
[    8.853780] Key type id_resolver registered=0D
[    8.858172] Key type id_legacy registered=0D
[    8.862394] initcall init_nfs_v4+0x0/0x30 returned 0 after 13624 usecs=0D
[    8.869268] calling  init_nlm+0x0/0x3b @ 1=0D
[    8.873578] initcall init_nlm+0x0/0x3b returned 0 after 12 usecs=0D
[    8.879901] calling  init_nls_cp437+0x0/0x11 @ 1=0D
[    8.884750] initcall init_nls_cp437+0x0/0x11 returned 0 after 0 usecs=0D
[    8.891525] calling  init_nls_ascii+0x0/0x11 @ 1=0D
[    8.896390] initcall init_nls_ascii+0x0/0x11 returned 0 after 1 usecs=0D
[    8.903159] calling  init_nls_iso8859_1+0x0/0x11 @ 1=0D
[    8.908384] initcall init_nls_iso8859_1+0x0/0x11 returned 0 after 0 usec=
s=0D
[    8.915521] calling  init_nls_utf8+0x0/0x23 @ 1=0D
[    8.920287] initcall init_nls_utf8+0x0/0x23 returned 0 after 2 usecs=0D
[    8.926966] calling  init_ntfs_fs+0x0/0x1c9 @ 1=0D
[    8.931737] ntfs: driver 2.1.30 [Flags: R/W].=0D
[    8.936517] initcall init_ntfs_fs+0x0/0x1c9 returned 0 after 4671 usecs=
=0D
[    8.943476] calling  init_autofs4_fs+0x0/0x26 @ 1=0D
[    8.948492] tsc: Refined TSC clocksource calibration: 3000.106 MHz=0D
[    8.948613] initcall init_autofs4_fs+0x0/0x26 returned 0 after 169 usecs=
=0D
[    8.948620] calling  init_pstore_fs+0x0/0x41 @ 1=0D
[    8.948641] initcall init_pstore_fs+0x0/0x41 returned 0 after 17 usecs=0D
[    8.948645] calling  ipc_init+0x0/0x20 @ 1=0D
[    8.948661] msgmni has been set to 1688=0D
[    8.948681] initcall ipc_init+0x0/0x20 returned 0 after 31 usecs=0D
[    8.948685] calling  ipc_sysctl_init+0x0/0x11 @ 1=0D
[    8.948706] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 17 usecs=
=0D
[    8.948710] calling  init_mqueue_fs+0x0/0x91 @ 1=0D
[    9.005183] initcall init_mqueue_fs+0x0/0x91 returned 0 after 55197 usec=
s=0D
[    9.012337] calling  key_proc_init+0x0/0x64 @ 1=0D
[    9.017118] initcall key_proc_init+0x0/0x64 returned 0 after 11 usecs=0D
[    9.023877] calling  selinux_nf_ip_init+0x0/0x65 @ 1=0D
[    9.029101] initcall selinux_nf_ip_init+0x0/0x65 returned 0 after 0 usec=
s=0D
[    9.036221] calling  init_sel_fs+0x0/0x8b @ 1=0D
[    9.040801] initcall init_sel_fs+0x0/0x8b returned 0 after 0 usecs=0D
[    9.047304] calling  selnl_init+0x0/0x53 @ 1=0D
[    9.051811] initcall selnl_init+0x0/0x53 returned 0 after 14 usecs=0D
[    9.058317] calling  sel_netif_init+0x0/0x54 @ 1=0D
[    9.063185] initcall sel_netif_init+0x0/0x54 returned 0 after 0 usecs=0D
[    9.069948] calling  sel_netnode_init+0x0/0x5f @ 1=0D
[    9.074990] initcall sel_netnode_init+0x0/0x5f returned 0 after 0 usecs=
=0D
[    9.081943] calling  sel_netport_init+0x0/0x5f @ 1=0D
[    9.086979] initcall sel_netport_init+0x0/0x5f returned 0 after 0 usecs=
=0D
[    9.093929] calling  aurule_init+0x0/0x2d @ 1=0D
[    9.098513] initcall aurule_init+0x0/0x2d returned 0 after 2 usecs=0D
[    9.105005] calling  crypto_algapi_init+0x0/0xc @ 1=0D
[    9.110143] initcall crypto_algapi_init+0x0/0xc returned 0 after 7 usecs=
=0D
[    9.117182] calling  chainiv_module_init+0x0/0xf @ 1=0D
[    9.122403] initcall chainiv_module_init+0x0/0xf returned 0 after 1 usec=
s=0D
[    9.129534] calling  eseqiv_module_init+0x0/0xf @ 1=0D
[    9.134655] initcall eseqiv_module_init+0x0/0xf returned 0 after 0 usecs=
=0D
[    9.141691] calling  hmac_module_init+0x0/0xf @ 1=0D
[    9.146640] initcall hmac_module_init+0x0/0xf returned 0 after 1 usecs=0D
[    9.153504] calling  md5_mod_init+0x0/0xf @ 1=0D
[    9.158177] initcall md5_mod_init+0x0/0xf returned 0 after 92 usecs=0D
[    9.164760] calling  sha1_generic_mod_init+0x0/0xf @ 1=0D
[    9.170265] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 99 u=
secs=0D
[    9.177676] calling  crypto_cbc_module_init+0x0/0xf @ 1=0D
[    9.183181] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 3 u=
secs=0D
[    9.190597] calling  des_generic_mod_init+0x0/0x14 @ 1=0D
[    9.196149] initcall des_generic_mod_init+0x0/0x14 returned 0 after 161 =
usecs=0D
[    9.203636] calling  aes_init+0x0/0xf @ 1=0D
[    9.207941] initcall aes_init+0x0/0xf returned 0 after 94 usecs=0D
[    9.214176] calling  zlib_mod_init+0x0/0xf @ 1=0D
[    9.218941] initcall zlib_mod_init+0x0/0xf returned 0 after 92 usecs=0D
[    9.225623] calling  crypto_authenc_module_init+0x0/0xf @ 1=0D
[    9.231482] initcall crypto_authenc_module_init+0x0/0xf returned 0 after=
 0 usecs=0D
[    9.239265] calling  crypto_authenc_esn_module_init+0x0/0xf @ 1=0D
[    9.245485] initcall crypto_authenc_esn_module_init+0x0/0xf returned 0 a=
fter 0 usecs=0D
[    9.253624] calling  krng_mod_init+0x0/0xf @ 1=0D
[    9.258368] initcall krng_mod_init+0x0/0xf returned 0 after 80 usecs=0D
[    9.265054] calling  proc_genhd_init+0x0/0x44 @ 1=0D
[    9.270011] initcall proc_genhd_init+0x0/0x44 returned 0 after 13 usecs=
=0D
[    9.276970] calling  init_emergency_pool+0x0/0x53 @ 1=0D
[    9.282293] bounce: pool size: 64 pages=0D
[    9.286322] initcall init_emergency_pool+0x0/0x53 returned 0 after 3951 =
usecs=0D
[    9.293817] calling  bsg_init+0x0/0x119 @ 1=0D
[    9.298289] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)=0D
[    9.306059] initcall bsg_init+0x0/0x119 returned 0 after 7663 usecs=0D
[    9.312658] calling  noop_init+0x0/0xf @ 1=0D
[    9.316956] io scheduler noop registered=0D
[    9.321089] initcall noop_init+0x0/0xf returned 0 after 4040 usecs=0D
[    9.327580] calling  deadline_init+0x0/0xf @ 1=0D
[    9.332247] io scheduler deadline registered=0D
[    9.336741] initcall deadline_init+0x0/0xf returned 0 after 4392 usecs=0D
[    9.343602] calling  cfq_init+0x0/0x89 @ 1=0D
[    9.347989] io scheduler cfq registered (default)=0D
[    9.352934] initcall cfq_init+0x0/0x89 returned 0 after 4920 usecs=0D
[    9.359430] calling  percpu_counter_startup+0x0/0x35 @ 1=0D
[    9.365010] initcall percpu_counter_startup+0x0/0x35 returned 0 after 1 =
usecs=0D
[    9.372528] calling  audit_classes_init+0x0/0x4f @ 1=0D
[    9.377763] initcall audit_classes_init+0x0/0x4f returned 0 after 12 use=
cs=0D
[    9.384989] calling  phy_core_init+0x0/0x45 @ 1=0D
[    9.389792] initcall phy_core_init+0x0/0x45 returned 0 after 30 usecs=0D
[    9.396578] calling  pci_proc_init+0x0/0x64 @ 1=0D
[    9.401531] initcall pci_proc_init+0x0/0x64 returned 0 after 197 usecs=0D
[    9.408397] calling  pcie_portdrv_init+0x0/0x6f @ 1=0D
[    9.415451] IOAPIC[0]: Set routing entry (4-18 -> 0xb1 -> IRQ 18 Mode:1 =
Active:1 Dest:15)=0D
[    9.424087] pcieport 0000:00:068] IOAPIC[0]: Set routing entry (4-19 -> =
0xd1 -> IRQ 19 Mode:1 Active:1 Dest:15)=0D
[    9.440096] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X=0D
[    9.445812] initcall pcie_portdrv_init+0x0/0x6f returned 0 after 31553 u=
secs=0D
[    9.453213] calling  aer_service_init+0x0/0x28 @ 1=0D
[    9.458301] initcall aer_service_init+0x0/0x28 returned 0 after 48 usecs=
=0D
[    9.465341] calling  pci_hotplug_init+0x0/0x1e @ 1=0D
[    9.470375] pci_hotplug: PCI Hot Plug PCI Core version: 0.5=0D
[    9.476239] initcall pci_hotplug_init+0x0/0x1e returned 0 after 5731 use=
cs=0D
[    9.483468] calling  pcied_init+0x0/0x76 @ 1=0D
[    9.488077] pciehp: PCI Express Hot Plug Controller Driver version: 0.4=
=0D
[    9.495037] initcall pcied_init+0x0/0x76 returned 0 after 6921 usecs=0D
[    9.501711] calling  pcifront_init+0x0/0x41 @ 1=0D
[    9.506479] initcall pcifront_init+0x0/0x41 returned -19 after 1 usecs=0D
[    9.513332] calling  genericbl_driver_init+0x0/0x11 @ 1=0D
[    9.518888] initcall genericbl_driver_init+0x0/0x11 returned 0 after 54 =
usecs=0D
[    9.526392] calling  cirrusfb_init+0x0/0xaa @ 1=0D
[    9.531226] initcall cirrusfb_init+0x0/0xaa returned 0 after 65 usecs=0D
[    9.537999] calling  efifb_driver_init+0x0/0x11 @ 1=0D
[    9.543166] initcall efifb_driver_init+0x0/0x11 returned 0 after 47 usec=
s=0D
[    9.550297] calling  intel_idle_init+0x0/0x2ec @ 1=0D
[    9.555349] initcall intel_idle_init+0x0/0x2ec returned -19 after 2 usec=
s=0D
[    9.562481] calling  acpi_reserve_resources+0x0/0xc8 @ 1=0D
[    9.568076] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 12=
 usecs=0D
[    9.575667] calling  acpi_ac_init+0x0/0x25 @ 1=0D
[    9.580404] initcall acpi_ac_init+0x0/0x25 returned 0 after 69 usecs=0D
[    9.587096] calling  acpi_button_driver_init+0x0/0xf @ 1=0D
[    9.593064] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0=0D
[    9.601843] ACPI: Power Button [PWRB]=0D
[    9.606052] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1=0D
[    9.613828] ACPI: Power Button [PWRF]=0D
[    9.617719] initcall acpi_button_driver_init+0x0/0xf returned 0 after 24=
474 usecs=0D
[    9.625585] calling  acpi_fan_driver_init+0x0/0xf @ 1=0D
[    9.630962] initcall acpi_fan_driver_init+0x0/0xf returned 0 after 51 us=
ecs=0D
[    9.638285] calling  acpi_processor_driver_init+0x0/0x3e @ 1=0D
[    9.644318] ACPI: processor limited to max C-state 1=0D
[    9.650312] initcall acpi_processor_driver_init+0x0/0x3e returned 0 afte=
r 5936 usecs=0D
[    9.658456] calling  acpi_thermal_init+0x0/0x8c @ 1=0D
[    9.666435] thermal LNXTHERM:00: registered as thermal_zone0=0D
[    9.672392] ACPI: Thermal Zone [THRM] (30 C)=0D
[    9.676924] initcall acpi_thermal_init+0x0/0x8c returned 0 after 13029 u=
secs=0D
[    9.684336] calling  acpi_battery_init+0x0/0x13 @ 1=0D
[    9.689478] initcall acpi_battery_init+0x0/0x13 returned 0 after 8 usecs=
=0D
[    9.689501] calling  1_acpi_battery_init_async+0x0/0x22 @ 6=0D
[    9.689578] initcall 1_acpi_battery_init_async+0x0/0x22 returned 0 after=
 71 usecs=0D
[    9.710227] calling  acpi_hed_driver_init+0x0/0xf @ 1=0D
[    9.715595] initcall acpi_hed_driver_init+0x0/0xf returned 0 after 57 us=
ecs=0D
[    9.715697] kworker/u12:0 (617) used greatest stack depth: 6828 bytes le=
ft=0D
[    9.730121] calling  erst_init+0x0/0x2fa @ 1=0D
[    9.734622] initcall erst_init+0x0/0x2fa returned 0 after 1 usecs=0D
[    9.741041] calling  ghes_init+0x0/0x165 @ 1=0D
[    9.745531] GHES: HEST is not enabled!=0D
[    9.749471] initcall ghes_init+0x0/0x165 returned -22 after 3850 usecs=0D
[    9.756337] calling  einj_init+0x0/0x4ef @ 1=0D
[    9.760822] initcall einj_init+0x0/0x4ef returned -19 after 1 usecs=0D
[    9.767406] calling  ioat_init_module+0x0/0xb0 @ 1=0D
[    9.772448] ioatdma: Intel(R) QuickData Technology Driver 4.00=0D
[    9.778787] initcall ioat_init_module+0x0/0xb0 returned 0 after 6195 use=
cs=0D
[    9.786017] calling  virtio_mmio_init+0x0/0x11 @ 1=0D
[    9.791114] initcall virtio_mmio_init+0x0/0x11 returned 0 after 51 usecs=
=0D
[    9.798163] calling  virtio_balloon_driver_init+0x0/0xf @ 1=0D
[    9.804075] initcall virtio_balloon_driver_init+0x0/0xf returned 0 after=
 49 usecs=0D
[    9.811945] calling  xenbus_probe_initcall+0x0/0x35 @ 1=0D
[    9.817448] initcall xenbus_probe_initcall+0x0/0x35 returned -19 after 0=
 usecs=0D
[    9.825048] calling  xenbus_init+0x0/0x37 @ 1=0D
[    9.829635] initcall xenbus_init+0x0/0x37 returned -19 after 0 usecs=0D
[    9.836320] calling  xenbus_backend_init+0x0/0x48 @ 1=0D
[    9.841638] initcall xenbus_backend_init+0x0/0x48 returned -19 after 0 u=
secs=0D
[    9.849052] calling  gntdev_init+0x0/0x48 @ 1=0D
[    9.853646] initcall gntdev_init+0x0/0x48 returned -19 after 0 usecs=0D
[    9.860339] calling  gntalloc_init+0x0/0x37 @ 1=0D
[    9.865105] initcall gntalloc_init+0x0/0x37 returned -19 after 0 usecs=0D
[    9.871981] calling  hypervisor_subsys_init+0x0/0x21 @ 1=0D
[    9.877578] initcall hypervisor_subsys_init+0x0/0x21 returned -19 after =
0 usecs=0D
[    9.885272] calling  hyper_sysfs_init+0x0/0xcc @ 1=0D
[    9.890313] initcall hyper_sysfs_init+0x0/0xcc returned -19 after 0 usec=
s=0D
[    9.897458] calling  platform_pci_module_init+0x0/0x16 @ 1=0D
[    9.903291] initcall platform_pci_module_init+0x0/0x16 returned 0 after =
67 usecs=0D
[    9.911066] calling  xen_pcibk_init+0x0/0x110 @ 1=0D
[    9.916028] initcall xen_pcibk_init+0x0/0x110 returned -19 after 0 usecs=
=0D
[    9.923077] calling  xen_acpi_processor_init+0x0/0x1f7 @ 1=0D
[    9.928856] initcall xen_acpi_processor_init+0x0/0x1f7 returned -19 afte=
r 1 usecs=0D
[    9.936722] calling  pty_init+0x0/0x3d9 @ 1=0D
[   10.003623] Switched to clocksource tsc=0D
[   10.005=E0hvc_init+0x0/0x1d5 @ 1=0D
[   10.005974] initcall xen_hvc_init+0x0/0x1d5 returned -19 after 0 usecs=0D
[   10.005979] calling  serial8250_init+0x0/0x16d @ 1=0D
[   10.005980] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
[   10.007704] initcall serial8250_init+0x0/0x16d returned 0 after 1683 use=
cs=0D
[   10.007709] calling  serial_pci_driver_init+0x0/0x16 @ 1=0D
[   10.008354] IOAPIC[0]: Set routing entry (4-22 -> 0x22 -> IRQ 22 Mode:1 =
Active:1 Dest:15)=0D
[   10.029605] 0000:04:07.0: ttyS0 at I/O 0xe400 (irq =3D 22, base_baud =3D=
 115200) is a 16550A=0D
[   10.080112] console [ttyS0] enabled=0D
[   10.080112] console [ttyS0] enabled=0D
[   10.087386] bootconsole [uart0] disabled=0D
[   10.087386] bootconsole [uart0] disabled=0D
[   10.096125] initcall serial_pci_driver_init+0x0/0x16 returned 0 after 86=
421 usecs=0D
[   10.103875] calling  init_kgdboc+0x0/0x15 @ 1=0D
[   10.108362] initcall init_kgdboc+0x0/0x15 returned 0 after 0 usecs=0D
[   10.114732] calling  init+0x0/0xf3 @ 1=0D
[   10.118738] initcall init+0x0/0xf3 returned 0 after 139 usecs=0D
[   10.124661] calling  hpet_init+0x0/0x57 @ 1=0D
[   10.129489] initcall hpet_init+0x0/0x57 returned 0 after 505 usecs=0D
[   10.135873] calling  nvram_init+0x0/0x7e @ 1=0D
[   10.140396] Non-volatile memory driver v1.3=0D
[   10.144702] initcall nvram_init+0x0/0x7e returned 0 after 4334 usecs=0D
[   10.151246] calling  mod_init+0x0/0x1b6 @ 1=0D
[   10.155582] initcall mod_init+0x0/0x1b6 returned -19 after 30 usecs=0D
[   10.162036] calling  mod_init+0x0/0x12d @ 1=0D
[   10.166347] initcall mod_init+0x0/0x12d returned -19 after 5 usecs=0D
[   10.172712] calling  mod_init+0x0/0x99 @ 1=0D
[   10.176930] initcall mod_init+0x0/0x99 returned -19 after 3 usecs=0D
[   10.183207] calling  mod_init+0x0/0x48 @ 1=0D
[   10.187421] initcall mod_init+0x0/0x48 returned -19 after 0 usecs=0D
[   10.193698] calling  rng_init+0x0/0xf @ 1=0D
[   10.197971] initcall rng_init+0x0/0xf returned 0 after 142 usecs=0D
[   10.204163] calling  agp_init+0x0/0x2f @ 1=0D
[   10.208376] Linux agpgart interface v0.103=0D
[   10.212593] initcall agp_init+0x0/0x2f returned 0 after 4120 usecs=0D
[   10.218957] calling  agp_ali_init+0x0/0x24 @ 1=0D
[   10.223595] initcall agp_ali_init+0x0/0x24 returned 0 after 62 usecs=0D
[   10.230140] calling  agp_ati_init+0x0/0x24 @ 1=0D
[   10.234778] initcall agp_ati_init+0x0/0x24 returned 0 after 64 usecs=0D
[   10.241324] calling  agp_amdk7_init+0x0/0x24 @ 1=0D
[   10.246141] initcall agp_amdk7_init+0x0/0x24 returned 0 after 64 usecs=0D
[   10.252863] calling  agp_amd64_mod_init+0x0/0xa @ 1=0D
[   10.258567] initcall agp_amd64_mod_init+0x0/0xa returned -19 after 668 u=
secs=0D
[   10.265828] calling  agp_efficeon_init+0x0/0x39 @ 1=0D
[   10.270917] initcall agp_efficeon_init+0x0/0x39 returned 0 after 65 usec=
s=0D
[   10.277908] calling  agp_intel_init+0x0/0x24 @ 1=0D
[   10.282731] initcall agp_intel_init+0x0/0x24 returned 0 after 69 usecs=0D
[   10.289454] calling  agp_nvidia_init+0x0/0x24 @ 1=0D
[   10.294357] initcall agp_nvidia_init+0x0/0x24 returned 0 after 61 usecs=
=0D
[   10.301171] calling  agp_sis_init+0x0/0x24 @ 1=0D
[   10.305813] initcall agp_sis_init+0x0/0x24 returned 0 after 65 usecs=0D
[   10.312357] calling  agp_serverworks_init+0x0/0x24 @ 1=0D
[   10.317715] initcall agp_serverworks_init+0x0/0x24 returned 0 after 66 u=
secs=0D
[   10.324975] calling  agp_via_init+0x0/0x24 @ 1=0D
[   10.329618] initcall agp_via_init+0x0/0x24 returned 0 after 67 usecs=0D
[   10.336162] calling  drm_core_init+0x0/0x107 @ 1=0D
[   10.340975] [drm] Initialized drm 1.1.0 20060810=0D
[   10.345728] initcall drm_core_init+0x0/0x107 returned 0 after 4705 usecs=
=0D
[   10.352630] calling  cn_proc_init+0x0/0x33 @ 1=0D
[   10.357206] initcall cn_proc_init+0x0/0x33 returned 0 after 3 usecs=0D
[   10.363661] calling  topology_sysfs_init+0x0/0x60 @ 1=0D
[   10.369066] initcall topology_sysfs_init+0x0/0x60 returned 0 after 195 u=
secs=0D
[   10.376327] calling  loop_init+0x0/0x12b @ 1=0D
[   10.386653] loop: module loaded=0D
[   10.389905] initcall loop_init+0x0/0x12b returned 0 after 8973 usecs=0D
[   10.396463] calling  xen_blkif_init+0x0/0x21 @ 1=0D
[   10.401220] initcall xen_blkif_init+0x0/0x21 returned -19 after 0 usecs=
=0D
[   10.408037] calling  zram_init+0x0/0x2e9 @ 1=0D
[   10.413225] zram: Created 1 device(s) ...=0D
[   10.417367] initcall zram_init+0x0/0x2e9 returned 0 after 4824 usecs=0D
[   10.423921] calling  mac_hid_init+0x0/0x1c @ 1=0D
[   10.428515] initcall mac_hid_init+0x0/0x1c returned 0 after 15 usecs=0D
[   10.435065] calling  macvlan_init_module+0x0/0x31 @ 1=0D
[   10.440282] initcall macvlan_init_module+0x0/0x31 returned 0 after 11 us=
ecs=0D
[   10.447465] calling  macvtap_init+0x0/0xd0 @ 1=0D
[   10.452083] initcall macvtap_init+0x0/0xd0 returned 0 after 37 usecs=0D
[   10.458636] calling  net_olddevs_init+0x0/0x88 @ 1=0D
[   10.463582] initcall net_olddevs_init+0x0/0x88 returned 0 after 10 usecs=
=0D
[   10.470490] calling  fixed_mdio_bus_init+0x0/0xe3 @ 1=0D
[   10.475878] libphy: Fixed MDIO Bus: probed=0D
[   10.480099] initcall fixed_mdio_bus_init+0x0/0xe3 returned 0 after 4306 =
usecs=0D
[   10.487452] calling  tun_init+0x0/0x8b @ 1=0D
[   10.491672] tun: Universal TUN/TAP device driver, 1.6=0D
[   10.496873] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>=0D
[   10.503375] initcall tun_init+0x0/0x8b returned 0 after 11441 usecs=0D
[   10.509844] calling  tg3_driver_init+0x0/0x16 @ 1=0D
[   10.514812] initcall tg3_driver_init+0x0/0x16 returned 0 after 107 usecs=
=0D
[   10.521722] calling  ixgbevf_init_module+0x0/0x49 @ 1=0D
[   10.526929] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.12.1-k=0D
[   10.536602] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.=0D
[   10.542981] initcall ixgbevf_init_module+0x0/0x49 returned 0 after 15694=
 usecs=0D
[   10.550425] calling  forcedeth_pci_driver_init+0x0/0x16 @ 1=0D
[   10.556234] initcall forcedeth_pci_driver_init+0x0/0x16 returned 0 after=
 70 usecs=0D
[   10.563943] calling  netback_init+0x0/0x81 @ 1=0D
[   10.568520] initcall netback_init+0x0/0x81 returned -19 after 0 usecs=0D
[   10.575160] calling  fw_core_init+0x0/0xf1 @ 1=0D
[   10.579913] initcall fw_core_init+0x0/0xf1 returned 0 after 174 usecs=0D
[   10.586564] calling  nonstatic_sysfs_init+0x0/0xf @ 1=0D
[   10.591768] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 4 use=
cs=0D
[   10.598855] calling  yenta_cardbus_driver_init+0x0/0x16 @ 1=0D
[   10.604709] initcall yenta_cardbus_driver_init+0x0/0x16 returned 0 after=
 109 usecs=0D
[   10.612509] calling  mon_init+0x0/0xe1 @ 1=0D
[   10.616926] initcall mon_init+0x0/0xe1 returned 0 after 195 usecs=0D
[   10.623217] calling  ehci_hcd_init+0x0/0x58 @ 1=0D
[   10.627896] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
[   10.634616] initcall ehci_hcd_init+0x0/0x58 returned 0 after 6568 usecs=
=0D
[   10.641434] calling  ehci_pci_init+0x0/0x60 @ 1=0D
[   10.646107] ehci-pci: EHCI PCI platform driver=0D
[   10.652420] IOAPIC[0]: Set routing entry (4-17 -> 0x42 -> IRQ 17 Mode:1 =
Active:1 Dest:15)=0D
[   10.660861] QUIRK: Enable AMD PLL fix=0D
[   10.664670] ehci-pci 0000:00:12.2: EHCI Host Controller=0D
[   10.670316] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus =
number 1=0D
[   10.677956] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround=0D
[   10.686927] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze w=
orkaround=0D
[   10.694655] ehci-pci 0000:00:12.2: debug port 1=0D
[   10.699461] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe6ff800=0D
[   10.705846] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00=0D
[   10.712057] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002=0D
[   10.719047] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[   10.726483] usb usb1: Product: EHCI Host Controller=0D
[   10.731502] usb usb1: Manufacturer: Linux 3.16.0-rc5upstream-01651-g03b9=
189 ehci_hcd=0D
[   10.739474] usb usb1: SerialNumber: 0000:00:12.2=0D
[   10.745142] hub 1-0:1.0: USB hub found=0D
[   10.749062] hub 1-0:1.0: 6 ports detected=0D
[   10.756192] ehci-pci 0000:00:13.2: EHCI Host Controller=0D
[   10.761843] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus =
number 2=0D
[   10.769467] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround=0D
[   10.778422] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze w=
orkaround=0D
[   10.786136] ehci-pci 0000:00:13.2: debug port 1=0D
[   10.790930] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe6ff400=0D
[   10.802739] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00=0D
[   10.808950] usb usb2: New USB device found, idVendor=3D1d6b, urer: Linux=
 3.16.0-rc5upstream-01651-g03b9189 ehci_hcd=0D
[   10.836367] usb usb2: SerialNumber: 0000:00:13.2=0D
[   10.842041] hub 2-0:1.0: USB hub found=0D
[   10.845960] hub 2-0:1.0: 6 ports detected=0D
[   10.851457] initcall ehci_pci_init+0x0/0x60 returned 0 after 200728 usec=
s=0D
[   10.858464] calling  ohci_hcd_mod_init+0x0/0x5e @ 1=0D
[   10.863494] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
[   10.869876] initcall ohci_hcd_mod_init+0x0/0x5e returned 0 after 6242 us=
ecs=0D
[   10.877056] calling  ohci_pci_init+0x0/0x60 @ 1=0D
[   10.881724] ohci-pci: OHCI PCI platform driver=0D
[   10.888075] IOAPIC[0]: Set routing entry (4-16 -> 0x52 -> IRQ 16 Mode:1 =
Active:1 Dest:15)=0D
[   10.896538] ohci-pci 0000:00:12.0: OHCI PCI host controller=0D
[   10.902556] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus =
number 3=0D
[   10.910319] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe6fe000=0D
[   10.964925] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[   10.971917] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[   10.979352] usb usb3: Product: OHCI PCI host controller=0D
[   10.984730] usb usb3: Manufacturer: Linux 3.16.0-rc5upstream-01651-g03b9=
189 ohci_hcd=0D
[   10.992700] usb usb3: SerialNumber: 0000:00:12.0=0D
[   10.998360] hub 3-0:1.0: USB hub found=0D
[   11.002300] hub 3-0:1.0: 3 ports detected=0D
[   11.009030] ohci-pci 0000:00:12.1: OHCI PCI host controller=0D
[   11.015044] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus =
number 4=0D
[   11.022732] ohci-pci 0000:00:12.1: irq 16, io mem 0xfe6fd000=0D
[   11.083814] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[   11.090808] usb usb4: New USB device strings: M_hcd=0D
[   11.111592] usb usb4: SerialNumber: 0000:00:12.1=0D
[   11.117260] hub 4-0:1.0: USB hub found=0D
[   11.121193] hub 4-0:1.0: 3 ports detected=0D
[   11.127916] ohci-pci 0000:00:13.0: OHCI PCI host controller=0D
[   11.133919] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus =
number 5=0D
[   11.141686] ohci-pci 0000:00:13.0: irq 18, io mem 0xfe6fc000=0D
[   11.196708] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[   11.203700] usb usb5: New USB device strings: M
[   11.211133] usb usb5: Product: OHCI PCI host controller=0D
[   11.216511] usb usb5: Manufacturer: Linux 3.16.0-rc5upstream-01651-g03b9=
189 ohci_hcd=0D
[   11.224481] usb usb5: SerialNumber: 0000:00:13.0=0D
[   11.230136] hub 5-0:1.0: USB hub found=0D
[   11.234079] hub 5-0:1.0: 3 ports detected=0D
[   11.240826] ohci-pci 0000:00:13.1: OHCI PCI host controller=0D
[   11.246838] ohci-pci 0000:00:13.1: new USB bus registered, as[   11.3155=
94] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001=0D
[   11.322585] usb usb6: New USB device strings: M0:1.0: USB hub found=0D
[   11.352993] hub 6-0:1.0: 3 ports detected=0D
[   11.359714] ohci-pci 0000:00:14.5: OHCI PCI host controller=0D
[   11.365728] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus =
number 7=0D
[   11.373434] ohci-pci 0000:00:14.5: irq 18, io mem 0xfe6f6000=0D
[   11.428485] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001=0D
[   11.435476] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1=0D
[   11.442910] usb usb7: Product: OHCI PCI host controller=0D
[   11.448287] usb usb7: Manufacturer: Linux 3.16.0-rc5upstream-01651-g03b9=
189 ohci_hcd=0D
[   11.456258] usb usb7: SerialNumber: 0000:00:14.5=0D
[   11.461912] hub 7-0:1.0: USB hub found=0D
[   11.465854] hub 7-0:1.0: 2 ports detected=0D
[   11.470776] initcall ohci_pci_init+0x0/0x60 returned 0 after 575789 usec=
s=0D
[   11.477773] calling  uhci_hcd_init+0x0/0xa4 @ 1=0D
[   11.482434] uhci_hcd: USB Universal Host Controller Interface driver=0D
[   11.489138] initcall uhci_hcd_init+0x0/0xa4 returned 0 after 6552 usecs=
=0D
[   11.495949] calling  usblp_driver_init+0x0/0x16 @ 1=0D
[   11.501080] usbcore: registered new interface driver usblp=0D
[   11.506725] initcall usblp_driver_init+0x0/0x16 returned 0 after 5625 us=
ecs=0D
[   11.513895] calling  kgdbdbgp_start_thread+0x0/0x57 @ 1=0D
[   11.519274] initcall kgdbdbgp_start_thread+0x0/0x57 returned 0 after 0 u=
secs=0D
[   11.526531] calling  i8042_init+0x0/0x3b7 @ 1=0D
[   11.531162] i8042: PNP: No PS/2 controller found. Probing ports directly=
=2E=0D
[   11.538660] serio: i8042 KBD port at 0x60,0x64 irq 1=0D
[   11.543789] serio: i8042 AUX port at 0x60,0x64 irq 12=0D
[   11.549020] initcall i8042_init+0x0/0x3b7 returned 0 after 17598 usecs=0D
[   11.555746] calling  serport_init+0x0/0x2e @ 1=0D
[   11.560319] initcall serport_init+0x0/0x2e returned 0 after 0 usecs=0D
[   11.566776] calling  mousedev_init+0x0/0x54 @ 1=0D
[   11.571643] mousedev: PS/2 mouse device common for all mice=0D
[   11.577390] initcall mousedev_init+0x0/0x54 returned 0 after 5812 usecs=
=0D
[   11.584216] calling  evdev_init+0x0/0xf @ 1=0D
[   11.588825] initcall evdev_init+0x0/0xf returned 0 after 296 usecs=0D
[   11.595208] calling  atkbd_init+0x0/0x20 @ 1=0D
[   11.599693] initcall atkbd_init+0x0/0x20 returned 0 after 83 usecs=0D
[   11.606071] calling  psmouse_init+0x0/0x8a @ 1=0D
[   11.610848] initcall psmouse_init+0x0/0x8a returned 0 after 196 usecs=0D
[   11.617485] calling  cmos_init+0x0/0x66 @ 1=0D
[   11.621839] rtc_cmos 00:01: RTC can wake from S4=0D
[   11.627054] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0=0D
[   11.633373] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs=0D
[   11.641287] initcall cmos_init+0x0/0x66 returned 0 after 19058 usecs=0D
[   11.647831] calling  i2c_i801_init+0x0/0x92 @ 1=0D
[   11.652605] initcall i2c_i801_init+0x0/0x92 returned 0 after 107 usecs=0D
[   11.659327] calling  cpufreq_gov_dbs_init+0x0/0xf @ 1=0D
[   11.664526] initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 0 use=
cs=0D
[   11.671607] calling  efivars_sysfs_init+0x0/0x1d0 @ 1=0D
[   11.676806] initcall efivars_sysfs_init+0x0/0x1d0 returned -19 after 0 u=
secs=0D
[   11.684065] calling  efivars_pstore_init+0x0/0x89 @ 1=0D
[   11.689266] initcall efivars_pstore_init+0x0/0x89 returned 0 after 0 use=
cs=0D
[   11.696347] calling  vhost_net_init+0x0/0x20 @ 1=0D
[   11.701210] initcall vhost_net_init+0x0/0x20 returned 0 after 109 usecs=
=0D
[   11.708023] calling  vhost_init+0x0/0x7 @ 1=0D
[   11.712328] initcall vhost_init+0x0/0x7 returned 0 after 0 usecs=0D
[   11.718513] calling  staging_init+0x0/0x7 @ 1=0D
[   11.722996] initcall staging_init+0x0/0x7 returned 0 after 0 usecs=0D
[   11.729360] calling  eeepc_laptop_init+0x0/0x4f @ 1=0D
[   11.734529] initcall eeepc_laptop_init+0x0/0x4f returned -19 after 145 u=
secs=0D
[   11.741789] calling  sock_diag_init+0x0/0xf @ 1=0D
[   11.746468] initcall sock_diag_init+0x0/0xf returned 0 after 15 usecs=0D
[   11.753101] calling  llc_init+0x0/0x1b @ 1=0D
[   11.757318] initcall llc_init+0x0/0x1b returned 0 after 0 usecs=0D
[   11.763416] calling  snap_init+0x0/0x35 @ 1=0D
[   11.767724] initcall snap_init+0x0/0x35 returned 0 after 2 usecs=0D
[   11.773909] calling  blackhole_module_init+0x0/0xf @ 1=0D
[   11.779199] initcall blackhole_module_init+0x0/0xf returned 0 after 0 us=
ecs=0D
[   11.786368] calling  nfnetlink_init+0x0/0x4b @ 1=0D
[   11.791121] Netfilter messages via NETLINK v0.30.=0D
[   11.795976] initcall nfnetlink_init+0x0/0x4b returned 0 after 4745 usecs=
=0D
[   11.802877] calling  nfnetlink_log_init+0x0/0x8f @ 1=0D
[   11.807997] initcall nfnetlink_log_init+0x0/0x8f returned 0 after 10 use=
cs=0D
[   11.815078] calling  nf_conntrack_standalone_init+0x0/0x70 @ 1=0D
[   11.821083] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)=0D
[   11.827587] initcall nf_conntrack_standalone_init+0x0/0x70 returned 0 af=
ter 6356 usecs=0D
[   11.835742] calling  ctnetlink_init+0x0/0x92 @ 1=0D
[   11.840493] ctnetlink v0.93: registering with nfnetlink.=0D
[   11.845961] initcall ctnetlink_init+0x0/0x92 returned 0 after 5343 usecs=
=0D
[   11.852864] calling  nf_conntrack_ftp_init+0x0/0x195 @ 1=0D
[   11.858336] initcall nf_conntrack_ftp_init+0x0/0x195 returned 0 after 3 =
usecs=0D
[   11.865684] calling  nf_conntrack_irc_init+0x0/0x148 @ 1=0D
[   11.871157] initcall nf_conntrack_irc_init+0x0/0x148 returned 0 after 5 =
usecs=0D
[   11.878507] calling  nf_conntrack_sip_init+0x0/0x1e4 @ 1=0D
[   11.883976] initcall nf_conntrack_sip_init+0x0/0x1e4 returned 0 after 0 =
usecs=0D
[   11.891324] calling  xt_init+0x0/0xb5 @ 1=0D
[   11.895457] initcall xt_init+0x0/0xb5 returned 0 after 6 usecs=0D
[   11.901463] calling  tcpudp_mt_init+0x0/0x14 @ 1=0D
[   11.906215] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 0 usecs=0D
[   11.912848] calling  connsecmark_tg_init+0x0/0xf @ 1=0D
[   11.917958] initcall connsecmark_tg_init+0x0/0xf returned 0 after 0 usec=
s=0D
[   11.924948] calling  nflog_tg_init+0x0/0xf @ 1=0D
[   11.929522] initcall nflog_tg_init+0x0/0xf returned 0 after 0 usecs=0D
[   11.935976] calling  secmark_tg_init+0x0/0xf @ 1=0D
[   11.940728] initcall secmark_tg_init+0x0/0xf returned 0 after 0 usecs=0D
[   11.947362] calling  tcpmss_tg_init+0x0/0x14 @ 1=0D
[   11.952116] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 0 usecs=0D
[   11.958750] calling  conntrack_mt_init+0x0/0x14 @ 1=0D
[   11.963771] initcall conntrack_mt_init+0x0/0x14 returned 0 after 0 usecs=
=0D
[   11.970671] calling  policy_mt_init+0x0/0x14 @ 1=0D
[   11.975424] initcall policy_mt_init+0x0/0x14 returned 0 after 0 usecs=0D
[   11.982057] calling  state_mt_init+0x0/0xf @ 1=0D
[   11.986630] initcall state_mt_init+0x0/0xf returned 0 after 0 usecs=0D
[   11.993087] calling  gre_offload_init+0x0/0x14 @ 1=0D
[   11.998019] initcall gre_offload_init+0x0/0x14 returned 0 after 0 usecs=
=0D
[   12.004832] calling  sysctl_ipv4_init+0x0/0x44 @ 1=0D
[   12.009803] initcall sysctl_ipv4_init+0x0/0x44 returned 0 after 38 usecs=
=0D
[   12.016704] calling  tunnel4_init+0x0/0x6d @ 1=0D
[   12.021278] initcall tunnel4_init+0x0/0x6d returned 0 after 0 usecs=0D
[   12.027732] calling  ipv4_netfilter_init+0x0/0xf @ 1=0D
[   12.032841] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 0 usec=
s=0D
[   12.039831] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x150 @ 1=0D
[   12.046305] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x150 returned 0=
 after 197 usecs=0D
[   12.054638] calling  nf_defrag_init+0x0/0x14 @ 1=0D
[   12.059390] initcall nf_defrag_init+0x0/0x14 returned 0 after 0 usecs=0D
[   12.066022] calling  ip_tables_init+0x0/0x8f @ 1=0D
[   12.070793] ip_tables: (C) 2000-2006 Netfilter Core Team=0D
[   12.076260] initcall ip_tables_init+0x0/0x8f returned 0 after 5363 usecs=
=0D
[   12.083161] calling  iptable_filter_init+0x0/0x40 @ 1=0D
[   12.088475] initcall iptable_filter_init+0x0/0x40 returned 0 after 113 u=
secs=0D
[   12.095734] calling  iptable_mangle_init+0x0/0x40 @ 1=0D
[   12.101006] initcall iptable_mangle_init+0x0/0x40 returned 0 after 71 us=
ecs=0D
[   12.108174] calling  reject_tg_init+0x0/0xf @ 1=0D
[   12.112837] initcall reject_tg_init+0x0/0xf returned 0 after 0 usecs=0D
[   12.119379] calling  ulog_tg_init+0x0/0x74 @ 1=0D
[   12.123969] initcall ulog_tg_init+0x0/0x74 returned 0 after 16 usecs=0D
[   12.130513] calling  cubictcp_register+0x0/0x72 @ 1=0D
[   12.135533] TCP: cubic registered=0D
[   12.138944] initcall cubictcp_register+0x0/0x72 returned 0 after 3334 us=
ecs=0D
[   12.146114] calling  xfrm_user_init+0x0/0x43 @ 1=0D
[   12.150865] Initializing XFRM netlink socket=0D
[   12.155270] initcall xfrm_user_init+0x0/0x43 returned 0 after 4305 usecs=
=0D
[   12.162170] calling  inet6_init+0x0/0x2c3 @ 1=0D
[   12.166879] NET: Registered protocol family 10=0D
[   12.172229] initcall inet6_init+0x0/0x2c3 returned 0 after 5447 usecs=0D
[   12.178869] calling  ah6_init+0x0/0x75 @ 1=0D
[   12.183086] initcall ah6_init+0x0/0x75 returned 0 after 0 usecs=0D
[   12.189180] calling  esp6_init+0x0/0x75 @ 1=0D
[   12.193484] initcall esp6_init+0x0/0x75 returned 0 after 0 usecs=0D
[   12.199670] calling  xfrm6_transport_init+0x0/0x14 @ 1=0D
[   12.204957] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 0 us=
ecs=0D
[   12.212127] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1=0D
[   12.217594] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after 0 =
usecs=0D
[   12.224941] calling  xfrm6_beet_init+0x0/0x14 @ 1=0D
[   12.229781] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 0 usecs=0D
[   12.236504] calling  ip6_tables_init+0x0/0x8f @ 1=0D
[   12.241366] ip6_tables: (C) 2000-2006 Netfilter Core Team=0D
[   12.246922] initcall ip6_tables_init+0x0/0x8f returned 0 after 5450 usec=
s=0D
[   12.253911] calling  ip6table_filter_init+0x0/0x40 @ 1=0D
[   12.259372] initcall ip6table_filter_init+0x0/0x40 returned 0 after 169 =
usecs=0D
[   12.266719] calling  ip6table_mangle_init+0x0/0x40 @ 1=0D
[   12.272156] initcall ip6table_mangle_init+0x0/0x40 returned 0 after 145 =
usecs=0D
[   12.279504] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x129 @ 1=0D
[   12.285788] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x129 returned 0=
 after 11 usecs=0D
[   12.294031] calling  nf_defrag_init+0x0/0x4c @ 1=0D
[   12.298810] initcall nf_defrag_init+0x0/0x4c returned 0 after 25 usecs=0D
[   12.305534] calling  ipv6header_mt6_init+0x0/0xf @ 1=0D
[   12.310642] initcall ipv6header_mt6_init+0x0/0xf returned 0 after 0 usec=
s=0D
[   12.317632] calling  reject_tg6_init+0x0/0xf @ 1=0D
[   12.322384] initcall reject_tg6_init+0x0/0xf returned 0 after 0 usecs=0D
[   12.329016] calling  sit_init+0x0/0xbc @ 1=0D
[   12.333230] sit: IPv6 over IPv4 tunneling driver=0D
[   12.338855] initcall sit_init+0x0/0xbc returned 0 after 5496 usecs=0D
[   12.345219] calling  packet_init+0x0/0x39 @ 1=0D
[   12.349701] NET: Registered protocol family 17=0D
[   12.354281] initcall packet_init+0x0/0x39 returned 0 after 4476 usecs=0D
[   12.360913] calling  br_init+0x0/0x90 @ 1=0D
[   12.365100] initcall br_init+0x0/0x90 returned 0 after 59 usecs=0D
[   12.371195] calling  init_rpcsec_gss+0x0/0x54 @ 1=0D
[   12.376095] initcall init_rpcsec_gss+0x0/0x54 returned 0 after 56 usecs=
=0D
[   12.382906] calling  dcbnl_init+0x0/0x5e @ 1=0D
[   12.387300] initcall dcbnl_init+0x0/0x5e returned 0 after 0 usecs=0D
[   12.393573] calling  init_dns_resolver+0x0/0xcd @ 1=0D
[   12.398606] Key type dns_resolver registered=0D
[   12.403000] initcall init_dns_resolver+0x0/0xcd returned 0 after 4307 us=
ecs=0D
[   12.410171] calling  mcheck_init_device+0x0/0x174 @ 1=0D
[   12.416249] initcall mcheck_init_device+0x0/0x174 returned 0 after 856 u=
secs=0D
[   12.423571] calling  mcheck_debugfs_init+0x0/0x3e @ 1=0D
[   12.428806] initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 14 us=
ecs=0D
[   12.435992] calling  severities_debugfs_init+0x0/0x3e @ 1=0D
[   12.441571] initcall severities_debugfs_init+0x0/0x3e returned 0 after 1=
0 usecs=0D
[   12.449112] calling  threshold_init_device+0x0/0x44 @ 1=0D
[   12.454986] initcall threshold_init_device+0x0/0x44 returned 0 after 468=
 usecs=0D
[   12.462440] calling  hpet_insert_resource+0x0/0x1e @ 1=0D
[   12.467739] initcall hpet_insert_resource+0x0/0x1e returned 0 after 5 us=
ecs=0D
[   12.474917] calling  update_mp_table+0x0/0x527 @ 1=0D
[   12.479860] initcall update_mp_table+0x0/0x527 returned 0 after 4 usecs=
=0D
[   12.486684] calling  lapic_insert_resource+0x0/0x46 @ 1=0D
[   12.492070] initcall lapic_insert_resource+0x0/0x46 returned 0 after 4 u=
secs=0D
[   12.499342] calling  io_apic_bug_finalize+0x0/0x1a @ 1=0D
[   12.504636] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 4 us=
ecs=0D
[   12.511812] calling  print_ICs+0x0/0x437 @ 1=0D
[   12.516211] =0D
[   12.516211] printing PIC contents=0D
[   12.521153] ... PIC  IMR: ffff=0D
[   12.524294] ... PIC  IRR: 0001=0D
[   12.527441] ... PIC  ISR: 0000=0D
[   12.530586] ... PIC ELCR: ce90=0D
[   12.533734] printing local APIC contents on CPU#0/0:=0D
[   12.538842] ... APIC ID:      00000000 (0)=0D
[   12.543054] ... APIC VERSION: 80050010=0D
[   12.546907] ... APIC TASKPRI: 00000000 (00)=0D
[   12.551209] ... APIC ARBPRI: 000000e0 (e0)=0D
[   12.555421] ... APIC PROCPRI: 00000000=0D
[   12.559275] ... APIC LDR: 01000000=0D
[   12.562772] ... APIC DFR: ffffffff=0D
[   12.566269] ... APIC SPIV: 000001ff=0D
[   12.569853] ... APIC ISR field:=0D
[   12.573083] 000000000000000000000000000000000000000000000000000000000000=
0000=0D
[   12.580405] ... APIC TMR field:=0D
[   12.583633] 000000000000000000000000000000000000000000000000000000000000=
0000=0D
[   12.590955] ... APIC IRR field:=0D
[   12.594183] 000000000001000000000000000000000000000000000000000000000000=
8000=0D
[   12.601502] ... APIC ESR: 00000000=0D
[   12.604998] ... APIC ICR: 000208ef=0D
[   12.608495] ... APIC ICR2: 0e000000=0D
[   12.612080] ... APIC LVTT: 000000ef=0D
[   12.615667] ... APIC LVTPC: 00000400=0D
[   12.619344] ... APIC LVT0: 00010700=0D
[   12.622929] ... APIC LVT1: 00000400=0D
[   12.626514] ... APIC LVTERR: 000000fe=0D
[   12.630279] ... APIC TMICT: 00000dc1=0D
[   12.633954] ... APIC TMCCT: 00000000=0D
[   12.637628] ... APIC TDCR: 00000003=0D
[   12.641216] ... APIC EFEAT: 00040007=0D
[   12.644891] ... APIC ECTRL: 00000000=0D
[   12.648567] ... APIC EILVT0: 000000f9=0D
[   12.652332] ... APIC EILVT1: 00000400=0D
[   12.656098] ... APIC EILVT2: 00010000=0D
[   12.659862] ... APIC EILVT3: 00010000=0D
[   12.663627] =0D
[   12.665158] number of MP IRQ sources: 15.=0D
[   12.669292] number of IO-APIC #4 registers: 24.=0D
[   12.673959] testing the IO APIC.......................=0D
[   12.679254] IO APIC #4......=0D
[   12.682219] .... register #00: 04000000=0D
[   12.686174] .......    : physical APIC id: 04=0D
[   12.690662] .......    : Delivery Type: 0=0D
[   12.694787] .......    : LTS          : 0=0D
[   12.698916] .... register #01: 00178021=0D
[   12.702867] .......     : max redirection entries: 17=0D
[   12.708070] .......     : PRQ implemented: 1=0D
[   12.712467] .......     : IO APIC version: 21=0D
[   12.716951] .... register #02: 04000000=0D
[   12.720901] .......     : arbitration: 04=0D
[   12.725031] .... register #03: 04178021=0D
[   12.728981] .......     : Boot DT    : 1=0D
[   12.733019] .... IRQ redirection table:=0D
[   12.736980] 1    0    0   0   0    0    0    00=0D
[   12.741645] 0    0    0   0   0    1    1    31=0D
[   12.746310] 0    0    0   0   0    1    1    30=0D
[   12.750978] 0    0    0   0   0    1    1    33=0D
[   12.755647] 0    0    0   0   0    1    1    34=0D
[   12.760312] 0    0    0   0   0    1    1    35=0D
[   12.764976] 0    0    0   0   0    1    1    36=0D
[   12.769641] 0    0    0   0   0    1    1    37=0D
[   12.774306] 0    0    0   0   0    1    1    38=0D
[   12.778972] 0    1    0   1   0    1    1    39=0D
[   12.783637] 0    0    0   0   0    1    1    3A=0D
[   12.788302] 0    0    0   0   0    1    1    3B=0D
[   12.792970] 0    0    0   0   0    1    1    3C=0D
[   12.797634] 0    0    0   0   0    1    1    3D=0D
[   12.802301] 0    0    0   0   0    1    1    3E=0D
[   12.806967] 0    0    0   0   0    1    1    3F=0D
[   12.811632] 0    1    0   1   0    1    1    52=0D
[   12.816297] 0    1    0   1   0    1    1    42=0D
[   12.820962] 0    1    0   1   0    1    1    B1=0D
[   12.825627] 0    1    0   1   0    1    1    D1=0D
[   12.830292] 1    0    0   0   0    0    0    00=0D
[   12.834957] 1    0    0   0   0    0    0    00=0D
[   12.839622] 1    1    0   1   0    1    1    22=0D
[   12.844287] 1    0    0   0   0    0    0    00=0D
[   12.848948] IRQ to pin mappings:=0D
[   12.852274] IRQ0 -> 0:2=0D
[   12.854810] IRQ1 -> 0:1=0D
[   12.857344] IRQ3 -> 0:3=0D
[   12.859883] IRQ4 -> 0:4=0D
[   12.862416] IRQ5 -> 0:5=0D
[   12.864950] IRQ6 -> 0:6=0D
[   12.867482] IRQ7 -> 0:7=0D
[   12.870017] IRQ8 -> 0:8=0D
[   12.872548] IRQ9 -> 0:9=0D
[   12.875081] IRQ10 -> 0:10=0D
[   12.877793] IRQ11 -> 0:11=0D
[   12.880506] IRQ12 -> 0:12=0D
[   12.883223] IRQ13 -> 0:13=0D
[   12.885937] IRQ14 -> 0:14=0D
[   12.888650] IRQ15 -> 0:15=0D
[   12.891362] IRQ16 -> 0:16=0D
[   12.894081] IRQ17 -> 0:17=0D
[   12.896793] IRQ18 -> 0:18=0D
[   12.899501] IRQ19 -> 0:19=0D
[   12.902214] IRQ22 -> 0:22=0D
[   12.904932] .................................... done.=0D
[   12.910223] initcall print_ICs+0x0/0x437 returned 0 after 385139 usecs=0D
[   12.916952] calling  print_ipi_mode+0x0/0x2e @ 1=0D
[   12.921706] Using IPI No-Shortcut mode=0D
[   12.925569] initcall print_ipi_mode+0x0/0x2e returned 0 after 3778 usecs=
=0D
[   12.932485] calling  pat_memtype_list_init+0x0/0x37 @ 1=0D
[   12.937880] initcall pat_memtype_list_init+0x0/0x37 returned 0 after 15 =
usecs=0D
[   12.945241] calling  init_oops_id+0x0/0x50 @ 1=0D
[   12.949825] initcall init_oops_id+0x0/0x50 returned 0 after 9 usecs=0D
[   12.956292] calling  pm_qos_power_init+0x0/0x5d @ 1=0D
[   12.961657] initcall pm_qos_power_init+0x0/0x5d returned 0 after 336 use=
cs=0D
[   12.968758] calling  pm_debugfs_init+0x0/0x2a @ 1=0D
[   12.973627] initcall pm_debugfs_init+0x0/0x2a returned 0 after 6 usecs=0D
[   12.980365] calling  printk_late_init+0x0/0x38 @ 1=0D
[   12.985317] initcall printk_late_init+0x0/0x38 returned 0 after 1 usecs=
=0D
[   12.992146] calling  tk_debug_sleep_time_init+0x0/0x41 @ 1=0D
[   12.997812] initcall tk_debug_sleep_time_init+0x0/0x41 returned 0 after =
18 usecs=0D
[   13.005435] calling  debugfs_kprobe_init+0x0/0xa6 @ 1=0D
[   13.010670] initcall debugfs_kprobe_init+0x0/0xa6 returned 0 after 30 us=
ecs=0D
[   13.017846] calling  taskstats_init+0x0/0x6e @ 1=0D
[   13.022625] registered taskstats version 1=0D
[   13.026841] initcall taskstats_init+0x0/0x6e returned 0 after 4148 usecs=
=0D
[   13.033751] calling  clear_boot_tracer+0x0/0x2d @ 1=0D
[   13.038775] initcall clear_boot_tracer+0x0/0x2d returned 0 after 4 usecs=
=0D
[   13.045688] calling  kdb_ftrace_register+0x0/0x35 @ 1=0D
[   13.050903] initcall kdb_ftrace_register+0x0/0x35 returned 0 after 15 us=
ecs=0D
[   13.058083] calling  fault_around_debugfs+0x0/0x3a @ 1=0D
[   13.063387] initcall fault_around_debugfs+0x0/0x3a returned 0 after 15 u=
secs=0D
[   13.070660] calling  max_swapfiles_check+0x0/0x7 @ 1=0D
[   13.075779] initcall max_swapfiles_check+0x0/0x7 returned 0 after 4 usec=
s=0D
[   13.082781] calling  set_recommended_min_free_kbytes+0x0/0xb0 @ 1=0D
[   13.089063] initcall set_recommended_min_free_kbytes+0x0/0xb0 returned 0=
 after 10 usecs=0D
[   13.097313] calling  kmemleak_late_init+0x0/0x8e @ 1=0D
[   13.102493] kmemleak: Kernel memory leak detector initialized=0D
[   13.102495] kmemleak: Automatic memory scanning thread started=0D
[   13.114430] initcall kmemleak_late_init+0x0/0x8e returned 0 after 11736 =
usecs=0D
[   13.121793] calling  check_early_ioremap_leak+0x0/0x5d @ 1=0D
[   13.127455] initcall check_early_ioremap_leak+0x0/0x5d returned 0 after =
4 usecs=0D
[   13.134993] calling  init_root_keyring+0x0/0xa @ 1=0D
[   13.139963] initcall init_root_keyring+0x0/0xa returned 0 after 34 usecs=
=0D
[   13.146877] calling  fail_make_request_debugfs+0x0/0x23 @ 1=0D
[   13.152672] initcall fail_make_request_debugfs+0x0/0x23 returned 0 after=
 53 usecs=0D
[   13.160392] calling  prandom_reseed+0x0/0x3e @ 1=0D
[   13.165171] initcall prandom_reseed+0x0/0x3e returned 0 after 21 usecs=0D
[   13.171910] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1=0D
[   13.178378] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned=
 0 after 10 usecs=0D
[   13.186805] calling  pci_sysfs_init+0x0/0x44 @ 1=0D
[   13.192863] initcall pci_sysfs_init+0x0/0x44 returned 0 after 1270 usecs=
=0D
[   13.199769] calling  boot_wait_for_devices+0x0/0x28 @ 1=0D
[   13.205153] initcall boot_wait_for_devices+0x0/0x28 returned -19 after 4=
 usecs=0D
[   13.212604] calling  deferred_probe_initcall+0x0/0x80 @ 1=0D
[   13.218251] initcall deferred_probe_initcall+0x0/0x80 returned 0 after 8=
6 usecs=0D
[   13.225796] calling  late_resume_init+0x0/0x190 @ 1=0D
[   13.230827]   Magic number: 6:895:394=0D
[   13.234713] initcall late_resume_init+0x0/0x190 returned 0 after 3801 us=
ecs=0D
[   13.241891] calling  firmware_memmap_init+0x0/0x29 @ 1=0D
[   13.247497] initcall firmware_memmap_init+0x0/0x29 returned 0 after 306 =
usecs=0D
[   13.254853] calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1=0D
[   13.261136] initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0=
 after 2 usecs=0D
[   13.269299] calling  tcp_congestion_default+0x0/0xf @ 1=0D
[   13.274685] initcall tcp_congestion_default+0x0/0xf returned 0 after 2 u=
secs=0D
[   13.281952] calling  ip_auto_config+0x0/0xeb7 @ 1=0D
[   13.286813] initcall ip_auto_config+0x0/0xeb7 returned 0 after 15 usecs=
=0D
[   13.293636] calling  software_resume+0x0/0x280 @ 1=0D
[   13.298572] PM: Hibernation image not present or could not be loaded.=0D
[   13.305205] initcall software_resume+0x0/0x280 returned -2 after 6484 us=
ecs=0D
[   13.312614] async_waiting @ 1=0D
[   13.315680] async_continuing @ 1 after 0 usec=0D
[   13.320514] Freeing unused kernel memory: 944K (c185e000 - c194a000)=0D
[   13.327102] Write protecting the kernel text: 6268k=0D
[   13.332172] Write protecting the kernel read-only data: 1856k=0D
[   13.338104] NX-protecting the kernel data: 3972k=0D
=0Dinit started: BusyBox v1.14.3 (2014-07-14 12:59:56 EDT)=0D
Mounting directories  [  OK  ]=0D=0D
[   13.461407] mv (1275) used greatest stack depth: 6668 bytes left=0D
mount: mount point /proc/bus/usb does not exist=0D
mount: mount point /proc/xen does not exist=0D
mount: mount point /sys/kernel/con unary operator expected=0D
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^=
G^G^G^G[   13.527207] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] =
@ 1335=0D
[   13.534528] acpi-cpufreq: overriding BIOS provide_mod] @ 1356=0D
^G^G^G^G^G^G^G^G[   13.551527] SCSI subsystem initialized=0D
[   13.554661] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returne=
d 0 after 20171 usecs=0D
^G^G^G^G^G[   13.564257] initcall init_scsi+0x0/0x90 [scsi_mod] returned 0 =
after 13808 usecs=0D
udevd-work[1352][   13.572819] modprobe (1335) used greatest stack depth: 6=
384 bytes left=0D
: error opening [   13.581664] calling  ata_init+0x0/0x295 [libata] @ 1361=
=0D
ATTR{/sys/devices/system/cpu/cpu[   13.589383] calling  rtl8169_pci_driver_=
init+0x0/0x1000 [r8169] @ 1391=0D
[   13.591040] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 1357=0D
0/online} for wr[   13.591709] wmi: Mapper loaded=0D
[   13.591711] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned 0 after 653=
 usecs=0D
iting: Permissio[   13.614985] r8169 Gigabit Ethernet driver 2.3LK-NAPI loa=
ded=0D
n denied=0D
=0D=0D
[   13.622113] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM=
 control=0D
[   13.633324] r8169 0000:02:00.0: irq 26 for MSI/MSI-X=0D
[   13.638871] calling  drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] @=
 1873=0D
[   13.645212] libata version 3.00 loaded.=0D
[   13.645224] initcall ata_init+0x0/0x295 [libata] returned 0 after 56222 =
usecs=0D
[   13.660844] calling  ahci_pci_driver_init+0x0/0x1000 [ahci] @ 1366=0D
[   13.667369] ahci 0000:00:11.0: version 3.0=0D
[   13.670869] calling  ata_generic_pci_driver_init+0x0/0x1000 [ata_generic=
] @ 1361=0D
[   13.671076] initcall ata_generic_pci_driver_init+0x0/0x1000 [ata_generic=
] returned 0 after 200 usecs=0D
[   13.689492] calling  skge_init_module+0x0/0x1000 [skge] @ 1867=0D
[   13.691171] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x=
3f impl SATA mode=0D
[   13.691173] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp=
 pio slum part ccc =0D
[   13.691786] r8169 0000:02:00.0 eth0: RTL8168c/8111c at 0xf844e000, 00:25=
:11:18:a1:2e, XID 1c4000c0 IRQ 26=0D
[   13.691788] r8169 0000:02:00.0 eth0: jumbo features [frames: 6128 bytes,=
 tx checksumming: ko]=0D
[   13.691962] initcall rtl8169_pci_driver_init+0x0/0x1000 [r8169] returned=
 0 after 75321 usecs=0D
[   13.740850] IOAPIC[0]: Set routing entry (4-20 -> 0x72 -> IRQ 20 Mode:1 =
Active:1 Dest:15)=0D
[   13.741685] modprobe (1391) used greatest stack depth: 5484 bytes left=0D
Waiting for devi[   13.756092] skge: 1.14 addr 0xfebfc000 irq 20 chip Yukon=
 rev 1=0D
ces [  OK  ]=0D=0D
[   13.765414] skge 0000:04:05.0 eth1: addr 00:0a:5e:5c:f5:72=0D
[   13.766159] scsi0 : ahci=0D
[   13.774546] initcall skge_init_module+0x0/0x1000 [skge] returned 0 after=
 33755 usecs=0D
[   13.778717] scsi1 : ahci=0D
[   13.781375] scsi2 : ahci=0D
[   13.784426] scsi3 : ahci=0D
[   13.793463] scsi4 : ahci=0D
[   13.798995] scsi5 : ahci=0D
[   13.802643] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] r=
eturned 0 after 141360 usecs=0D
[   13.803228] ata1: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd0=
0 irq 22=0D
[   13.803232] ata2: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd8=
0 irq 22=0D
[   13.803234] ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe0=
0 irq 22=0D
[   13.803237] ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe8=
0 irq 22=0D
[   13.803240] ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff0=
0 irq 22=0D
[   13.803242] ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff8=
0 irq 22=0D
[   13.805598] ahci 0000:03:00.0: JMB361 has only one port=0D
[   13.805611] ahci 0000:03:00.0: forcing port_map 0x3 -> 0x1=0D
[   13.805712] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x=
1 impl SATA mode=0D
[   13.805715] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio =0D
[   13.809568] scsi6 : ahci=0D
[   13.810861] scsi7 : ahci=0D
[   13.811661] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe10=
0 irq 19=0D
[   13.811661] ata8: DUMMY=0D
[   13.811823] initcall ahci_pci_driver_init+0x0/0x1000 [ahci] returned 0 a=
fter 141342 usecs=0D
[   13.909518] calling  ttm_init+0x0/0x1000 [ttm] @ 1873=0D
[   13.914887] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 158 usec=
s=0D
[   13.915086] calling  fb_console_init+0x0/0x1000 [fbcon] @ 2156=0D
[   13.928054] initcall fb_console_init+0x0/0x1000 [fbcon] returned 0 after=
 12671 usecs=0D
[   13.940680] calling  radeon_init+0x0/0xb0 [radeon] @ 1873=0D
[   13.946239] [drm] radeon kernel modesetting enabled.=0D
[   13.952981] [drm] initializing kernel modesetting (RS780 0x1002:0x9610 0=
x1019:0x2119).=0D
[   13.961191] [drm] register mmio base: 0xFE8F0000=0D
[   13.965942] [drm] register mmio size: 65536=0D
[   13.971494] ATOM BIOS: 113=0D
[   13.974392] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x00000=
000CFFFFFFF (256M used)=0D
[   13.983347] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x000000=
00BFFFFFFF=0D
[   13.991142] [drm] Detected VRAM RAM=3D256M, BAR=3D256M=0D
[   13.996071] [drm] RAM width 32bits DDR=0D
[   14.000326] [TTM] Zone  kernel: Available graphics memory: 432674 kiB=0D
[   14.006995] [TTM] Zone highmem: Available graphics memory: 1941382 kiB=0D
[   14.013716] [TTM] Initializing pool allocator=0D
[   14.018295] [TTM] Initializing DMA pool allocator=0D
[   14.023336] [drm] radeon: 256M of VRAM memory ready=0D
[   14.028361] [drm] radeon: 512M of GTT memory ready.=0D
[   14.033535] [drm] Loading RS780 Microcode=0D
[   14.038147] [drm] radeon: power management initialized=0D
[   14.043436] [drm] GART: num cpu pages 131072, num gpu pages 131072=0D
[   14.067686] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000=
).=0D
[   14.074877] radeon 0000:01:05.0: WB enabled=0D
[   14.079182] radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x0=
0000000a0000c00 and cpu addr 0xffca8c00=0D
[   14.089578] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).=
=0D
[   14.096388] [drm] Driver supports precise vblank timestamp query.=0D
[   14.102692] [drm] radeon: irq initialized.=0D
[   14.113578] ata4: SATA link down (SStatus 0 SControl 300)=0D
[   14.119205] ata5: SATA link down (SStatus 0 SControl 300)=0D
[   4.140787] [drm] ib test on ring 0 succeeded in 0 usecs=0D
[   14.144114] [drm] Radeon Display Connectors=0D
[   14.144114] [drm] Connector 0:=0D
[   14.144114] [drm]   VGA-1=0D
[   14.144116] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4=
c 0x7e4c=0D
[   14.144116] [drm]   Encoders:=0D
[   14.144117] [drm]     CRT1: INTERNAL_KLDSCP_DAC1=0D
[   14.144117] [drm] Connector 1:=0D
[   14.144117] [drm]   HDMI-A-1=0D
[   14.144118] [drm]   HPD3=0D
[   14.144118] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5=
c 0x7e5c=0D
[   14.144119] [drm]   Encoders:=0D
[   14.144119] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA=0D
[   14.152870] radeon 0000:01:05.0: No connectors reported connected with m=
odes=0D
[   14.152894] [drm] Cannot find any crtc or sizes - going 1024x768=0D
[   14.166912] [drm] fb mappable at 0xD0141000=0D
[   14.166913] [drm] vram apper at 0xD0000000=0D
[   14.166913] [drm] size 3145728=0D
[   14.166913] [drm] fb depth is 24=0D
G^G^G^G^G^G^G[   14.166914] [drm]    pitch is 4096=0D
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   14.23=
6926] fbcon: radeondrmfb (fb0) is primary device=0D
[   14.245343] Console: switching to colour frame buffer device 128x4ondrmf=
b frame buffer device=0D
[   14.270950] radeon 0000:01:05.0: registered panic notifier=0D
^G^G^G^G^G^G^G^G^G^G^G^G[   14.283807] [drm] Initialized radeon 2.39.0 2008=
0528 for 0000:01:05.0 on minor 0=0D
[   14.291611] initcall radeon_init+0x0/0xbG^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^=
G^G^G[   14.389370] ata2: softreset failed (device not ready)=0D
[   14.394581] ata2: applying PMP SRST workaround and retrying=0D
[   14g PMP SRST workaround and retrying=0D
[   14.411357] ttyS0: 4 input overrun(s)=0D
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[   14.564221] ata2: SATA link up 1.5 Gbps =
(SStatus 113 SControl 300)=0D
[   14.570621] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=0D
[   14.578013] ata2.00: ATA-7: Maxtor 6L080M0, BACE1G10, max UDMA/133=0D
[   14.584377] ata2.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 31/32)=
=0D
[   14.592496] ata1.00: ATA-7: Maxtor 6L080M0, BACE1G10, max UDMA/133=0D
[   14.598858] ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 31/32)=
=0D
[   14.607994] ata2.00: configured for UDMA/133=0D
[   14.612401] ata1.00: configured for UDMA/133=0D
[   14.617237] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   1G=
10 PQ: 0 ANSI: 5=0D
[   14.627258] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   1G=
10 PQ: 0 ANSI: 5=0D
[   14.636538] calling  crc_t10dif_mod_init+0x0/0x1000 [crc_t10dif] @ 2527=
=0D
[   14.643688] modprobe (1366) used greatest stack depth: 5384 bytes left=0D
[   14.650737] calling  crct10dif_mod_init+0x0/0x1000 [crct10dif_generic] @=
 2537=0D
[   14.658165] initcall crct10dif_mod_init+0x0/0x1000 [crct10dif_generic] r=
eturned 0 after 77 usecs=0D
[   14.668118] initcall crc_t10dif_mod_init+0x0/0x1000 [crc_t10dif] returne=
d 0 after 24206 usecs=0D
[   14.678003] calling  init_sd+0x0/0x1000 [sd_mod] @ 2527=0D
[   14.684308] sd 0:0:0:0: [sda] 156250000 512-byte logical blocks: (80.0 G=
B/74.5 GiB)=0D
[   14.684702] initcall init_sd+0x0/0x1000 [sd_mod] returned 0 after 1287 u=
secs=0D
[   14.684734] sd 1:0:0:0: [sdb] 156250000 512-byte logical blocks: (80.0 G=
B/74.5 GiB)=0D
[   14.684991] sd 1:0:0:0: [sdb] Write Protect is off=0D
[   14.684993] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00=0D
[   14.685092] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA=0D
[   14.708253]  sdb: sdb1=0D
[   14.709513] sd 1:0:0:0: [sdb] Attached SCSI disk=0D
[   14.734177] sd 0:0:0:0: [sda] Write Protect is off=0D
[   14.739126] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00=0D
[   14.744465] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA=0D
[   14.744882] calling  init_sg+0x0/0x1000 [sg] @ 2550=0D
[   14.745277] sd 0:0:0:0: Attached scsi generic sg0 type 0=0D
[   14.745579] sd 1:0:0:0: Attached scsi generic sg1 type 0=0D
[   14.745654] initcall init_sg+0x0/0x1000 [sg] returned 0 after 751 usecs=
=0D
[   14.782252] random: nonblocking pool is initialized=0D
[   14.812754]  sda: sda1 sda2 < sda5 >=0D
[   14.818469] sd 0:0:0:0: [sda] Attached SCSI disk=0D
Waiting for init.pre_custom [  OK  ]=0D=0D
Waiting for fb [  OK  ]=0D=0D
Waiting for network [  OK  ]=0D=0D
Bringing up loopback interface:  [  OK  ]=0D=0D
Bringing up interface eth0:  [   15.043040] r8169 0000:02:00.0 eth0: link d=
own=0D
[   15.043055] r8169 0000:02:00.0 eth0: link down=0D
[   15.052229] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready=0D
[   15.060202] device eth0 entered promiscuous mode=0D
[  OK  ]=0D=0D
Bringing up interface eth1:  =0D
Determining IP information for e[   15.096708] skge 0000:04:05.0 eth1: enab=
ling interface=0D
th1...[   15.110056] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready=0D
[   17.374054] r8169 0000:02:00.0 eth0: link up=0D
[   17.378454] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready=0D
[   18.312362] skge 0000:04:05.0 eth1: Link is up at 1000 Mbps, full duplex=
, flow control both=0D
[   18.320965] IPv6: ADDRCONF(NE^G done.=0D
[  OK  ]=0D=0D
Bringing up interface switch:  =0D
Determining IP information for s[   19.249453] switch: port 1(eth0) entered=
 forwarding state=0D
witch...[   19.255350] switch: p^G^G^G^G done.=0D
[  OK  ]=0D=0D
touch: cannot touch `/var/lock/subsys/network': No such file or directory=0D
Waiting for init.custom [  OK  ]=0D=0D
=0D
Starting SSHd ...=0D
=0D
    SSH started [2981]=0D
=0D
=0D
Waiting for SSHd [  OK  ]=0D=0D
WARNING: ssh currently running [2981] ignoring start request=0D
[   21.605219] calling  crc32c_intel_mod_init+0x0/0x1000 [crc32c_intel] @ 3=
017=0D
[   21.612398] initcall crc32c_intel_mod_init+0x^G^G^G^G^G^G^G^G^G^G^G^G^G[=
   21.624274] calling  crc32c_mod_init+0x0/0x1000 [crc32c_generic] @ 3017=0D
[   21.631169] initcall crc32c_mod_init+0x0/0x1000 [crc32c_generic] returne=
d 0 after 74 usecs=0D
[   21.641390] calling  libcrc32c_mod_init+0x0/0x1000 [libcrc32c] @ 3022=0D
[   21.648042] initcall libcrc32c_mod_init+0x0/0x1000 [libcrc32c] returned =
0 after 6 usecs=0D
[   21.658921] calling  iscsi_transport_init+0x0/0x1000 [scsi_transport_isc=
si] @ 3024=0D
[   21.666719] Loading iSCSI transport class v2.0-870.=0D
[   21.672392] initcall iscsi_transport_init+0x0/0x1000 [scsi_transport_isc=
si] returned 0 after 5540 usecs=0D
[   21.684765] calling  iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] @ 3024=0D
[   21.691511] iscsi: registered transport (tcp)=0D
[   21.696002] initcall iscsi_sw_tcp_init+0x0/0x1000 [iscsi_tcp] returned 0=
 after 4567 usecs=0D
Could not read fw values.=0D
Jul 14 19:22:12 tst034 syslogd 1.5.0: restart.=0D=0D
[0:0:0:0]    disk    ATA      Maxtor 6L080M0   1G10  /dev/sda =0D
[1:0:0:0]    disk    ATA      Maxtor 6L080M0   1G10  /dev/sdb =0D
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge=0D
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI 07.0 PCI bridge:=
 Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 3)=0D
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [=
AHCI mode]=0D
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controll=
er=0D
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller=0D
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controlle=
r=0D
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controll=
er=0D
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller=0D
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controlle=
r=0D
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)=0D
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller=0D
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge=0D
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controll=
er=0D
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] HyperTransport Configuration=0D
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] Address Map=0D
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] DRAM Controller=0D
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] Miscellaneous Control=0D
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, S=
empron] Link Control=0D
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200 Grap=
hics=0D
01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller=0D
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI Express Gigabit Ethernet controller (rev 02)=0D
03:00.0 SATA controller: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)=
=0D
03:00.1 IDE interface: JMicron Technology Corp. JMB361 AHCI/IDE (rev 02)=0D
04:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marv=
ell] (rev 10)=0D
04:07.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O Controller =
(rev 01)=0D
           CPU0       CPU1       CPU2       CPU3       =0D
  0:       8521          0          0          0   IO-APIC-edge      timer=
=0D
  1:          0          0          0          2   IO-APIC-edge      i8042=
=0D
  8:          0          1          2         34   IO-APIC-edge      rtc0=0D
  9:          0          0          0          0   IO-APIC-fasteoi   acpi=0D
 12:          0          0          0          4   IO-APIC-edge      i8042=
=0D
 16:          0          0          0          2   IO-APIC  16-fasteoi   oh=
ci_hcd:usb3, ohci_hcd:usb4=0D
 17:          0          0          0          0   IO-APIC  17-fasteoi   eh=
ci_hcd:usb1=0D
 18:          0          0          2          4   IO-APIC  18-fasteoi   oh=
ci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7, radeon=0D
 19:          0          0          0          0   IO-APIC  19-fasteoi   eh=
ci_hcd:usb2, ahci=0D
 20:          0          0          3         18   IO-APIC  20-fasteoi   et=
h1=0D
 22:          0          0          2        192   IO-APIC  22-fasteoi   se=
rial, ahci=0D
 26:          0          0          2        131   PCI-MSI-edge      eth0=0D
NMI:          0          0          0          0   Non-maskable interrupts=
=0D
LOC:       1651       5578       7400       6544   Local timer interrupts=0D
SPU:          0          0          0          0   Spurious interrupts=0D
PMI:          0          0          0          0   Performance monitoring i=
nterrupts=0D
IWI:          0          0          0          0   IRQ work interrupts=0D
RTR:          0          0          0          0   APIC ICR read retries=0D
RES:       1594       2640       2149       2261   Rescheduling interrupts=
=0D
CAL:        273        332        342        365   Function call interrupts=
=0D
TLB:         69         53        104         88   TLB shootdowns=0D
TRM:          0          0          0          0   Thermal event interrupts=
=0D
THR:         ^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G 0  =
        0          0          0   Threshold APIC interrupts=0D
MCE:          0          0          0          0   Machine check exceptions=
=0D
MCP:          1          1          1          1   Machine check polls=0D
THR:          0          0          0          0   Hypervisor callback inte=
rrupts=0D
ERR:          0=0D
MIS:          0=0D
00000000-00000fff : reserved=0D
00001000-0009f3ff : System RAM=0D
0009f400-0009ffff : reserved=0D
000a0000-000bffff : PCI Bus 0000:00=0D
  000a0000-000bffff : Video RAM area=0D
000c0000-000cebff : Video ROM=0D
000cf000-000d09ff : Adapter ROM=0D
000d1000-000d1fff : Adapter ROM=0D
000d5000-000d57ff : Adapter ROM=0D
000e6000-000fffff : reserved=0D
  000f0000-000fffff : System ROM=0D
00100000-cfeaffff : System RAM=0D
  01000000-0161e5a6 : Kernel code=0D
  0161e5a7-0185cb7f : Kernel data=0D
  01951000-01a2afff : Kernel bss=0D
cfeb0000-cfebdfff : ACPI Tables=0D
cfebe000-cfedffff : ACPI Non-volatile Storage=0D
cfee0000-cfefffff : reserved=0D
cff00000-dfffffff : PCI Bus 0000:00=0D
  d0000000-dfffffff : PCI Bus 0000:01=0D
    d0000000-dfffffff : 0000:01:05.0=0D
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]=0D
  e0000000-efffffff : pnp 00:05=0D
f0000000-febfffff : PCI Bus 0000:00=0D
  fdf00000-fdffffff : PCI Bus 0000:02=0D
    fdff0000-fdffffff : 0000:02:00.0=0D
      fdff0000-fdffffff : r8169=0D
  fe6f6000-fe6f6fff : 0000:00:14.5=0D
    fe6f6000-fe6f6fff : ohci_hcd=0D
  fe6f7000-fe6f7fff : 0000:00:13.1=0D
    fe6f7000-fe6f7fff : ohci_hcd=0D
  fe6fc000-fe6fcfff : 0000:00:13.0=0D
    fe6fc000-fe6fcfff : ohci_hcd=0D
  fe6fd000-fe6fdfff : 0000:00:12.1=0D
    fe6fd000-fe6fdfff : ohci_hcd=0D
  fe6fe000-fe6fefff : 0000:00:12.0=0D
    fe6fe000-fe6fefff : ohci_hcd=0D
  fe6ff400-fe6ff4ff : 0000:00:13.2=0D
    fe6ff400-fe6ff4ff : ehci_hcd=0D
  fe6ff800-fe6ff8ff : 0000:00:12.2=0D
    fe6ff800-fe6ff8ff : ehci_hcd=0D
  fe6ffc00-fe6fffff : 0000:00:11.0=0D
    fe6ffc00-fe6fffff : ahci=0D
  fe700000-fe8fffff : PCI Bus 0000:01=0D
    fe700000-fe7fffff : 0000:01:05.0=0D
    fe8e8000-fe8ebfff : 0000:01:05.1=0D
    fe8f0000-fe8fffff : 0000:01:05.0=0D
  fe900000-fe9fffff : PCI Bus 0000:02=0D
    fe9c0000-fe9dffff : 0000:02:00.0=0D
    fe9ff000-fe9fffff : 0000:02:00.0=0D
      fe9ff000-fe9fffff : r8169=0D
  fea00000-feafffff : PCI Bus 0000:03=0D
    feafe000-feafffff : 0000:03:00.0=0D
      feafe000-feafffff : ahci=0D
  feb00000-febfffff : PCI Bus 0000:04=0D
    febc0000-febdffff : 0000:04:05.0=0D
    febfc000-febfffff : 0000:04:05.0=0D
      febfc000-febfffff : skge=0D
fec00000-fec003ff : IOAPIC 0=0D
fec10000-fec1001f : pnp 00:03=0D
fed00000-fed003ff : HPET 2=0D
  fed00000-fed003ff : PNP0103:00=0D
fee00000-fee00fff : Local APIC=0D
  fee00000-fee00fff : pnp 00:02=0D
ff700000-ffffffff : reserved=0D
  ffb80000-ffbfffff : pnp 00:03=0D
100000000-11fffffff : System RAM=0D
MemTotal:        3882764 kB=0D
MemFree:         3582768 kB=0D
MemAvailable:    3494004 kB=0D
Buffers:               0 kB=0D
Cached:           241964 kB=0D
SwapCached:            0 kB=0D
Active:            41724 kB=0D
Inactive:         201532 kB=0D
Active(anon):      41724 kB=0D
Inactive(anon):   201532 kB=0D
Active(file):          0 kB=0D
Inactive(file):        0 kB=0D
Unevictable:        2664 kB=0D
Mlocked:            2664 kB=0D
HighTotal:       3017416 kB=0D
HighFree:        2795548 kB=0D
LowTotal:         865348 kB=0D
LowFree:          787220 kB=0D
SwapTotal:             0 kB=0D
SwapFree:              0 kB=0D
Dirty:                 0 kB=0D
Writeback:             0 kB=0D
AnonPages:          3624 kB=0D
Mapped:             5792 kB=0D
Shmem:            241964 kB=0D
Slab:              40980 kB=0D
SReclaimable:       6060 kB=0D
SUnreclaim:        34920 kB=0D
KernelStack:         784 kB=0D
PageTables:          452 kB=0D
NFS_Unstable:          0 kB=0D
Bounce:                0 kB=0D
WritebackTmp:          0 kB=0D
CommitLimit:     1941380 kB=0D
Committed_AS:     250980 kB=0D
VmallocTotal:     122880 kB=0D
VmallocUsed:       10576 kB=0D
VmallocChunk:     105972 kB=0D
AnonHugePages:         0 kB=0D
HugePages_Total:       0=0D
HugePages_Free:        0=0D
HugePages_Rsvd:        0=0D
HugePages_Surp:        0=0D
Hugepagesize:       2048 kB=0D
DirectMap4k:       12280 kB=0D
DirectMap2M:      901120 kB=0D
Waiting for init.late [  OK  ]=0D=0D
+ . /etc/init.d/functions=0D
++ TEXTDOMAIN=3Dinitscripts=0D
++ umask 022=0D
++ PATH=3D/sbin:/usr/sbin:/bin:/usr/bin=0D
++ export PATH=0D
++ '[' -z '' ']'=0D
++ COLUMNS=3D80=0D
++ '[' -z '' ']'=0D
+++ /sbin/consoletype=0D
++ CONSOLETYPE=3Dserial=0D
++ '[' -f /etc/sysconfig/i18n -a -z '' -a -z '' ']'=0D
++ '[' -z '' ']'=0D
++ '[' -f /etc/sysconfig/init ']'=0D
++ . /etc/sysconfig/init=0D
+++ BOOTUP=3Dcolor=0D
+++ RES_COL=3D60=0D
+++ MOVE_TO_COL=3D'echo -en \033[60G'=0D
+++ SETCOLOR_SUCCESS=3D'echo -[   22.581011] mount.nfs (3069) used greatest=
 stack depth: 5372 bytes left=0D
en \033[0;32m'=0D
+++ SETCOLOR_FAILURE=3D'echo -en \033[0;31m'=0D
+++ SETCOLOR_WARNING=3D'echo -en \033[0;33m'=0D
+++ SETCOLOR_NORMAL=3D'echo -en \033[0;39m'=0D
+++ LOGLEVEL=3D3=0D
+++ PROMPT=3Dyes=0D
+++ AUTOSWAP=3Dno=0D
+++ ACTIVE_CONSOLES=3D'/dev/tty[1-6]'=0D
++ '[' serial =3D serial ']'=0D
++ BOOTUP=3Dserial=0D
++ MOVE_TO_COL=3D=0D
++ SETCOLOR_SUCCESS=3D=0D
++ SETCOLOR_FAILURE=3D=0D
++ SETCOLOR_WARNING=3D=0D
++ SETCOLOR_NORMAL=3D=0D
++ __sed_discard_ignored_files=3D'/\(~\|\.bak\|\.orig\|\.rpmnew\|\.rpmorig\=
|\.rpmsave\)$/d'=0D
+ mkdir -p /mnt/lab=0D
+ echo '192.168.102.1  build'=0D
+ ping -q -c 1 build=0D
PING build.dumpdata.com (192.168.102.1) 56(84) bytes of data.=0D
=0D
--- build.dumpdata.com ping statistics ---=0D
1 packets transmitted, 1 received, 0% packet loss, time 0ms=0D
rtt min/avg/max/mdev =3D 0.260/0.260/0.260/0.000 ms=0D
+ '[' 0 -eq 0 ']'=0D
+ mount build:/srv/tftpboot/lab /mnt/lab -o vers=3D3=0D
+ iscsiadm -m discovery -t st -p build=0D
192.168.102.1:3260,1 iqn.2003-01.org.linux-iscsi.target:sn.bd5777dc54e541e0=
bd772761999275e6=0D
+ iscsiadm -m node -L all=0D
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.target:s=
n.bd5777dc54e541e0bd772761999275e6, portal: 192.168.102.1,3260]=0D
Jul 14 19:22:13 tst034 iscsid: transport class version 2.0-870. iscsid vers=
ion 2.0-870=0D=0D
Jul 14 19:22:13 tst034 iscsid: iSCSI daemon with pid=3D3052 started!=0D=0D
[   22.847498] scsi8 : iSCSI Initiator over TCP/IP=0D
[   23.110152] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.=
0  PQ: 0 ANSI: 5=0D
[   23.120814] sd 8:0:0:0: [sdc] 19get[   23.140048] sd 8:0:0:0: [sdc] Writ=
e Protect is off=0D
[   23.145839] sd 8:0:0:0: [sdc] Mode Sense: 2f 00 00 00=0D
: iqn.2003-01.or[   23.151761] sd 8:0:0:0: [sdc] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA=0D
[   23.151924] calling  dm_init+0x0/0x3f [dm_mod] @ 3091=0D
g.linux-iscsi.ta[   23.167549] device-mapper: ioctl: 4.27.0-ioctl (2013-10-=
30) initialised: dm-devel@redhat.com=0D
rget:sn.bd5777dc[   23.177219] initcall dm_init+0x0/0x3f [dm_mod] returned =
0 after 24720 usecs=0D
54e541e0bd772761[   23.186704] calling  dm_multipath_init+0x0/0x1000 [dm_mu=
ltipath] @ 3091=0D
999275e6, portal[   23.194282] device-mapper: multipath: version 1.7.0 load=
ed=0D
: 192.168.102.1,[   23.201109] initcall dm_multipath_init+0x0/0x1000 [dm_mu=
ltipath] returned 0 after 6894 usecs=0D
3260]: successful=0D
^G+ modprobe dm-multipath=0D
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G+ sleep=
 5=0D
[   23.224678]  sdc: unknown partition table=0D
[   23.236944] sd 8:0:0:0: [sdc] Attached SCSI disk=0D
Jul 14 19:22:14 tst034 iscsid: connection1:0 is operational now=0D=0D
+ pvscan=0D
  PV /dev/sdc   VG guests   lvm2 [931.44 GiB / 113.44 GiB free]=0D
  Total: 1 [931.44 GiB] / in use: 1 [931.44 GiB] / in no VG: 0 ge -aly=0D
^G^G^G^G  31 logical volume(s) in volume group "guests" now active=0D
+ echo 'NFS done'=0D
NFS done=0D
+ xl info=0D
xc: error: Could not obtain handle on privileged command interface (2 =3D N=
o such file or directory): Internal error=0D
libxl: error: libxl.c:99:libxl_ctx_alloc: cannot open libxc handle: No such=
 file or directory=0D
cannot init xl context=0D
+ '[' -e /sys/kernel/debug/xen/mmu/p2m ']'=0D
+ cat /sys/kernel/debug/xen/mmu/p2m=0D
++ boot_parameter cpuplug=0D
++ local param=0D
++ local value=0D
+++ cat /proc/cmdline=0D
+++ tr -s ' \t' '\n'=0D
+++ egrep '^cpuplug=3D|^cpuplug$'=0D
+++ tail -1=0D
++ param=3D=0D
++ '[' -z '' ']'=0D
++ return 1=0D
+ HOTPLUG=3D=0D
+ '[' 1 -eq 0 ']'=0D
+ TMEM_LOADED=3D0=0D
+ swapon /dev/xvda=0D
swapon: /dev/xvda: stat failed: No such file or directory=0D
+ '[' 255 -eq 0 ']'=0D
++ boot_parameter run=0D
++ local param=0D
++ local value=0D
+++ cat /proc/cmdline=0D
+++ tr -s ' \t' '\n'=0D
+++ egrep '^run=3D|^run$'=0D
+++ tail -1=0D
++ param=3D=0D
++ '[' -z '' ']'=0D
++ return 1=0D
+ HOTPLUG=3D=0D
+ '[' 1 -eq 0 ']'=0D
Jul 14 19:22:19 tst034 init: starting pid 3287, tty '/dev/tty1': '/bin/sh'=
=0D=0D
Jul 14 19:22:21 tst034 init: reloading /etc/inittab=0D=0D
Jul 14 19:22:21 tst034 init: starting pid 3291, tty '/dev/ttyS0': '/bin/sh'=
=0D=0D
=0D
=0D
BusyBox v1.14.3 (2014-07-14 12:59:56 EDT) built-in shell (ash)=0D
Enter 'help' for a list of built-in commands.=0D
=0D
# =07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=0D=0D
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=0D=0D
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=0D=0D
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=
=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07=07[   34.291619] =
switch: port 1(eth0) entered forwarding state=0D
Jul 14 19:24:12 tst034 sshd[3293]: WARNING: /etc/ssh/moduli does not exist,=
 using fixed modulus=0D=0D
Jul 14 19:24:12 tst034 sshd[3293]: Accepted publickey for root from 192.168=
=2E102.1 port 47599 ssh2=0D=0D
Jul 14 19:24:12 tst034 sshd[3293]: Received disconnect from 192.168.102.1: =
11: disconnected by user=0D=0D
=0D
# reboot=0D
# Jul 14 19:31:17 tst034 init: starting pid 3297, tty '': '/etc/init.d/halt=
'=0D=0D
Usage: /etc/init.d/halt {start}=0D
=0DThe system is going down NOW!=0D
Jul 14 19:31:17 tst034 init: The system is going down NOW!=0D=0D
=0DSent SIGTERM to all processes=0D
Jul 14 19:31:17 tst034 exiting on signal 15=0D=0D
=0DSent SIGKILL to[  568.399114] sd 8:0:0:0: shutdown=0D
[  568.402457] sd 1:0:0:0: shutdown=0D
[  568.405782] sd 1:0:0:0: [sdb] Synchronizing SCSI ca
[  568.436455] serio serio1: shutdown=0D
[  568.439988] serio serio0: shutdown=0D
[  568.443489] i8042 i8042: shutdown=0D
[  568.446921] ttyS0: 1 input overrun(s)=0D
[  568.447012] system 00:06: shutdown=0D
[  568.447013] system 00:05: shutdown=0D
[  568.447014] system 00:04: shutdown=0D
[  568.447015] system 00:03: shutdown=0D
[  568.447016] system 00:02: shutdown=0D
[  568.447017] rtc_cmos 00:01: shutdown=0D
[  568.447033] system 00:00: shutdown=0D
[  568.447036] serial 0000:04:07.0: shutdown=0D
[  568.447038] skge 0000:04:05.0: shutdown=0D
[  568.448248] pci 0000:00:14.4: System wakeup enabled by ACPI=0D
[  568.489181] pci 0000:03:00.1: shutdown=0D
[  568.493044] ahci 0000:03:00.0: shutdown=0D
[  568.496993] r8169 0000:02:00.0: shutdown=0D
[  568.502241] pci 0000:01:05.1: shutdown=0D
[  568.506100] radeon 0000:01:05.0: shutdown=0D
[  568.510226] pci 0000:00:18.4: shutdown=0D
[  568.514084] pci 0000:00:18.3: shutdown=0D
[  568.517943] pci 0000:00:18.2: shutdown=0D
[  568.521806] pci 0000:00:18.1: shutdown=0D
[  568.525669] pci 0000:00:18.0: shutdown=0D
[  568.529531] ohci-pci 0000:00:14.5: shutdown=0D
[  568.535207] pci 0000:00:14.4: shutdown=0D
[  568.539070] pci 0000:00:14.3: shutdown=0D
[  568.542932] pci 0000:00:14.0: shutdown=0D
[  568.546793] ehci-pci 0000:00:13.2: shutdown=0D
[  568.552451] ohci-pci 0000:00:13.1: shutdown=0D
[  568.558112] ohci-pci 0000:00:13.0: shutdown=0D
[  568.563775] ehci-pci 0000:00:12.2: shutdown=0D
[  568.569923] ------------[ cut here ]------------=0D
[  568.574684] WARNING: CPU: 1 PID: 3300 at /home/konrad/ssd/konrad/xtt-i38=
6/bootstrap/linux-usb/fs/proc/generic.c:521 remove_proc_entry+0x165/0x170()=
=0D
[  568.588294] remove_proc_entry: removing non-empty directory 'irq/17', le=
aking at least 'ehci_hcd:usb1'=0D
[  568.597878] Modules linked in: dm_multipath dm_mod iscsi_boot_sysfs iscs=
i_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c_generic s=
g sd_mod crct10dif_generic crc_t10dif crct10dif_common radeon fbcon tilebli=
t ttm font bitblit softcursor ata_generic ahci libahci drm_kms_helper skge =
r8169 libata mii scsi_mod wmi acpi_cpufreq=0D
[  568.629013] CPU: 1 PID: 3300 Comm: init Not tainted 3.16.0-rc5upstream-0=
1651-g03b9189 #1=0D
[  568.637347] Hardware name: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 08001=
5  04/01/2010=0D
[  568.645411]  00000209 ed0f1cd0 c1617946 c175403c ed0f1d00 c1090c3f c1754=
084 ed0f1d2c=0D
[  568.653458]  00000ce4 c175403c 00000209 c11f22a5 c11f22a5 ef39d1c0 ed0f1=
d78 ef39d20d=0D
[  568.661514]  ed0f1d18 c1090cde 00000009 ed0f1d10 c1754084 ed0f1d2c ed0f1=
d60 c11f22a5=0D
[  568.669570] Call Trace:=0D
[  568.672088]  [<c1617946>] dump_stack+0x48/0x60=0D
[  568.676668]  [<c1090c3f>] warn_slowpath_common+0x7f/0xa0=0D
[  568.682140]  [<c11f22a5>] ? remove_proc_entry+0x165/0x170=0D
[  568.687703]  [<c11f22a5>] ? remove_proc_entry+0x165/0x170=0D
[  568.693266]  [<c1090cde>] warn_slowpath_fmt+0x2e/0x30=0D
[  568.698470]  [<c11f22a5>] remove_proc_entry+0x165/0x170=0D
[  568.703855]  [<c10da6ca>] unregister_irq_proc+0xaa/0xc0=0D
[  568.709240]  [<c10d582f>] free_desc+0x1f/0x60=0D
[  568.713727]  [<c10d58aa>] irq_free_descs+0x3a/0x80=0D
[  568.718664]  [<c10d9e9d>] irq_dispose_mapping+0x2d/0x50=0D
[  568.724048]  [<c1078fd3>] mp_unmap_irq+0x73/0xa0=0D
[  568.728804]  [<c107196b>] acpi_unregister_gsi_ioapic+0x2b/0x40=0D
[  568.734814]  [<c107180f>] acpi_unregister_gsi+0xf/0x20=0D
[  568.740103]  [<c1339cad>] acpi_pci_irq_disable+0x4b/0x50=0D
[  568.745579]  [<c14daa38>] pcibios_disable_device+0x18/0x20=0D
[  568.751232]  [<c130123d>] do_pci_disable_device+0x4d/0x60=0D
[  568.756794]  [<c13012b7>] pci_disable_device+0x47/0xb0=0D
[  568.762087]  [<c10e4741>] ? hrtimer_cancel+0x11/0x20=0D
[  568.767198]  [<c1489667>] ? ehci_shutdown+0x57/0xb0=0D
[  568.772222]  [<c14800b1>] usb_hcd_pci_shutdown+0x31/0x40=0D
[  568.777694]  [<c1304b19>] pci_device_shutdown+0x19/0x50=0D
[  568.783078]  [<c13fda64>] device_shutdown+0x14/0x120=0D
[  568.788188]  [<c10ac29d>] kernel_restart_prepare+0x2d/0x30=0D
[  568.793839]  [<c10ac41e>] kernel_restart+0xe/0x60=0D
[  568.798684]  [<c1619790>] ? mutex_lock+0x20/0x40=0D
[  568.803441]  [<c10ac611>] SYSC_reboot+0x191/0x220=0D
[  568.808287]  [<c115446c>] ? free_pages_prepare+0xdc/0x170=0D
[  568.813850]  [<c10dd077>] ? call_rcu_sched+0x17/0x20=0D
[  568.818964]  [<c1199263>] ? put_object+0x23/0x40=0D
[  568.823720]  [<c119932d>] ? delete_object_full+0x1d/0x30=0D
[  568.829193]  [<c16162e0>] ? kmemleak_free+0x20/0x50=0D
[  568.834217]  [<c10887c5>] ? pgd_free+0x115/0x130=0D
[  568.838971]  [<c108e877>] ? __mmdrop+0x57/0xd0=0D
[  568.843549]  [<c108e877>] ? __mmdrop+0x57/0xd0=0D
[  568.848121]  [<c10b0f6f>] ? finish_task_switch+0xdf/0x130=0D
[  568.853683]  [<c10ac6ba>] SyS_reboot+0x1a/0x20=0D
[  568.858262]  [<c161c718>] sysenter_do_call+0x12/0x16=0D
[  568.863376] ---[ end trace ccc1ec4471c289c8 ]---=0D
[  568.868148] ohci-pci 0000:00:12.1: shutdown=0D
[  568.873813] ohci-pci 0000:00:12.0: shutdown=0D
[  568.879482] ------------[ cut here ]------------=0D
[  568.884236] WARNING: CPU: 1 PID: 3300 at /home/konrad/ssd/konrad/xtt-i38=
6/bootstrap/linux-usb/fs/proc/generic.c:521 remove_proc_entry+0x165/0x170()=
=0D
[  568.897846] remove_proc_entry: removing non-empty directory 'irq/16', le=
aking at least 'ohci_hcd:usb4'=0D
[  568.907430] Modules linked in: dm_multipath dm_mod iscsi_boot_sysfs iscs=
i_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c_generic s=
g sd_mod crct10dif_generic crc_t10dif crct10dif_common radeon fbcon tilebli=
t ttm font bitblit softcursor ata_generic ahci libahci drm_kms_helper skge =
r8169 libata mii scsi_mod wmi acpi_cpufreq=0D
[  568.938539] CPU: 1 PID: 3300 Comm: init Tainted: G        W     3.16.0-r=
c5upstream-01651-g03b9189 #1=0D
[  568.947946] Hardware name: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 08001=
5  04/01/2010=0D
[  568.956008]  00000209 ed0f1cd0 c1617946 c175403c ed0f1d00 c1090c3f c1754=
084 ed0f1d2c=0D
[  568.964068]  00000ce4 c175403c 00000209 c11f22a5 c11f22a5 f755e8c0 ed0f1=
d78 f755e90d=0D
[  568.972128]  ed0f1d18 c1090cde 00000009 ed0f1d10 c1754084 ed0f1d2c ed0f1=
d60 c11f22a5=0D
[  568.980194] Call Trace:=0D
[  568.982715]  [<c1617946>] dump_stack+0x48/0x60=0D
[  568.987294]  [<c1090c3f>] warn_slowpath_common+0x7f/0xa0=0D
[  568.992767]  [<c11f22a5>] ? remove_proc_entry+0x165/0x170=0D
[  568.998328]  [<c11f22a5>] ? remove_proc_entry+0x165/0x170=0D
[  569.003887]  [<c1090cde>] warn_slowpath_fmt+0x2e/0x30=0D
[  569.009092]  [<c11f22a5>] remove_proc_entry+0x165/0x170=0D
[  569.014476]  [<c10da6ca>] unregister_irq_proc+0xaa/0xc0=0D
[  569.019858]  [<c10d582f>] free_desc+0x1f/0x60=0D
[  569.024346]  [<c10d58aa>] irq_free_descs+0x3a/0x80=0D
[  569.029283]  [<c10d9e9d>] irq_dispose_mapping+0x2d/0x50=0D
[  569.034666]  [<c1078fd3>] mp_unmap_irq+0x73/0xa0=0D
[  569.039423]  [<c107196b>] acpi_unregister_gsi_ioapic+0x2b/0x40=0D
[  569.045431]  [<c107180f>] acpi_unregister_gsi+0xf/0x20=0D
[  569.050725]  [<c1339cad>] acpi_pci_irq_disable+0x4b/0x50=0D
[  569.056196]  [<c14daa38>] pcibios_disable_device+0x18/0x20=0D
[  569.061848]  [<c130123d>] do_pci_disable_device+0x4d/0x60=0D
[  569.067410]  [<c13012b7>] pci_disable_device+0x47/0xb0=0D
[  569.072701]  [<c12e08be>] ? __const_udelay+0x1e/0x20=0D
[  569.077814]  [<c14800b1>] usb_hcd_pci_shutdown+0x31/0x40=0D
[  569.083285]  [<c1304b19>] pci_device_shutdown+0x19/0x50=0D
[  569.088667]  [<c13fda64>] device_shutdown+0x14/0x120=0D
[  569.093777]  [<c10ac29d>] kernel_restart_prepare+0x2d/0x30=0D
[  569.099429]  [<c10ac41e>] kernel_restart+0xe/0x60=0D
[  569.104275]  [<c1619790>] ? mutex_lock+0x20/0x40=0D
[  569.109028]  [<c10ac611>] SYSC_reboot+0x191/0x220=0D
[  569.113874]  [<c115446c>] ? free_pages_prepare+0xdc/0x170=0D
[  569.119437]  [<c10dd077>] ? call_rcu_sched+0x17/0x20=0D
[  569.124552]  [<c1199263>] ? put_object+0x23/0x40=0D
[  569.129308]  [<c119932d>] ? delete_object_full+0x1d/0x30=0D
[  569.134779]  [<c16162e0>] ? kmemleak_free+0x20/0x50=0D
[  569.139800]  [<c10887c5>] ? pgd_free+0x115/0x130=0D
[  569.144556]  [<c108e877>] ? __mmdrop+0x57/0xd0=0D
[  569.149134]  [<c108e877>] ? __mmdrop+0x57/0xd0=0D
[  569.153708]  [<c10b0f6f>] ? finish_task_switch+0xdf/0x130=0D
[  569.159269]  [<c10ac6ba>] SyS_reboot+0x1a/0x20=0D
[  569.163843]  [<c161c718>] sysenter_do_call+0x12/0x16=0D
[  569.168951] ---[ end trace ccc1ec4471c289c9 ]---=0D
[  569.173709] ahci 0000:00:11.0: shutdown=0D
[  569.177657] pcieport 0000:00:07.0: shutdown=0D
[  569.181963] pcieport 0000:00:06.0: shutdown=0D
[  569.186273] pci 0000:00:01.0: shutdown=0D
[  569.190136] pci 0000:00:00.0: shutdown=0D
[  569.194034] PM: Calling mce_syscore_shutdown+0x0/0x60=0D

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bad.log"

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc5upstream-01668-g6d2265b (konrad@build-external.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Mon Jul 14 16:25:04 EDT 2014
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
[    0.000000] e820: remove [mem 0x000a0000-0x000fft type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-E
[    0.000000]   F0000-FFFFF write-protect
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
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
[    0.000000]   mpc: e5e70-e5ffc
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
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
[    0.000000] RAMDISK: [mem 0x7aeda000-0x7fffefff]
[    0.000000] Allocated new RAMDISK: [mem 0x32ad9000-0x37bfd3af]
[    0.000000] Move RAMDISK from [mem 0x7aeda000-0x7fffe3af] to [mem 0x32ad9000-0x37bfd3af]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FB100 000014 (v00 ACPIAM)
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
[    0.000000] free_area_init_node: node 0, pgdat c1849240, node_mem_map f06d9020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7433 pages used for memmap
[    0.000000]   HighMem zone: 754354 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
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
[    0.000000] PERCPU: Embedded 14 pages/cpu @f0673000 s35136 r0 d22208 u57344
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
[    0.000000] Memory: 3798704K/3930424K available (6268K kernel code, 434K rwdata, 1852K rodata, 940K init, 872K bss, 131720K reserved, 3017416K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc185e000 - 0xc1949000   ( 940 kB)
[    0.000000]       .data : 0xc161f5e7 - 0xc185cbc0   (2293 kB)
[    0.000000]       .text : 0xc1000000 - 0xc161f5e7   (6269 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=6
[    0.000000] NR_IRQS:2304 nr_irqs:472 0
[    0.000000] CPU 0 irqstacks, hard=f0008000 soft=f000a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2999.984 MHz processor
[    0.000024] Calibrat[    0.091093] ACPI: All ACPI Tables successfully acquired
[    0.102909] Security Framework initialized
[    0.107206] SELinux:  Disabled at boot.
[    0.111409] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.118361] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.126904] Initializing cgroup subsys freezer
[    0.131630] CPU: Physical Processor ID: 0
[    0.135843] CPU: Processor Core ID: 0
[    0.139687] mce: CPU supports 6 MCE banks
[    0.143898] LVT offset 0 assigned for vector 0xf9
[    0.148844] spurious 8259A interrupt: IRQ7.
[    0.153241] process: using AMD E400 aware idle routine
[    0.158635] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.158635] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.158635] tlb_flushall_shift: 6
[    0.174746] Freeing SMP alternatives memory: 28K (c1949000 - c1950000)
[    0.182605] Getting VERSION: 80050010
[    0.186450] Getting VERSION: 80050010
[    0.190294] Getting ID: 0
[    0.193044] Getting ID: f000000
[    0.196339] Getting LVT0: 700
[    0.199451] Getting LVT1: 400
[    0.202570] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.208236] enabled ExtINT on CPU#0
[    0.212083] ESR value before enabling vector: 0x00000004  after: 0x00000000
[    0.219389] ENABLING IO-APIC IRQs
[    0.222872] init IO_APIC IRQs
[    0.225984]  apic 4 pin 0 not connected
[    0.230009] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.238324] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.246636] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.254938] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.263240] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.271540] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.279854] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.288169] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.296472] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1 Dest:1)
[    0.304782] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.313271] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.321761] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.330251] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.338734] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.347226] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.355709]  apic 4 pin 16 not connected
[    0.359821]  apic 4 pin 17 not connected
[    0.363934]  apic 4 pin 18 not connected
[    0.368039]  apic 4 pin 19 not connected
[    0.372149]  apic 4 pin 20 not connected
[    0.376261]  apic 4 pin 21 not connected
[    0.380366]  apic 4 pin 22 not connected
[    0.384472]  apic 4 pin 23 not connected
[    0.388715] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.405012] smpboot: CPU0: AMD Phenom(tm) II X4 940 Processor (fam: 10, model: 04, stepping: 02)
[    0.414255] Using local PIC timer ...
[    0.524481] ... lapic delta = 1250027
[    0.528317] ... PM-Timer delta = 357949
[    0.532335] ... PM-Timer result ok
[  lt: 53688250
[    0.542563] ..... calibration result: 200004
[    0.547037] ..... CPU clock speed is 3000.0061 MHz.
[    0.552144] ..... host bus clock speed is 200.0004 MHz.
[    0.557631] calling  xen_init_spinlocks_jump+0x0/0x23 @ 1
[    0.563292] initcall xen_init_spinlocks_jump+0x0/0x23 returned 0 after 0 usecs
[    0.570860] calling  set_real_mode_permissions+0x0/0x5d @ 1
[    0.576720] initcall set_real_mode_permissions+0x0/0x5d returned 0 after 0 usecs
[    0.584479] calling  trace_init_perf_perm_irq_work_exit+0x0/0x11 @ 1
[    0.591143] initcall trace_init_perf_perm_irq_work_exit+0x0/0x11 returned 0 after 0 usecs
[    0.599719] calling  trace_init_flags_sys_exit+0x0/0xe @ 1
[    0.605478] initcall trace_init_flags_sys_exit+0x0/0xe returned 0 after 0 usecs
[    0.613140] calling  trace_init_flags_sys_enter+0x0/0xe @ 1
[    0.618987] initcall trace_init_flags_sys_enter+0x0/0xe returned 0 after 0 usecs
[    0.626745] calling  init_hw_perf_events+0x0/0x52b @ 1
[    0.632136] Performance Events: AMD PMU driver.
[    0.636895] ... version:                0
[    0.641098] ... bit width:              48
[    0.645384] ... generic registers:      4
[    0.649583] ... value mask:             0000ffffffffffff
[    0.655153] ... max period:             00007fffffffffff
[    0.660723] ... fixed-purpose events:   0
[    0.664922] ... event mask:             000000000000000f
[    0.670529] initcall init_hw_perf_events+0x0/0x52b returned 0 after 9765 usecs
[    0.678116] calling  register_trigger_all_cpu_backtrace+0x0/0x13 @ 1
[    0.684782] initcall register_trigger_all_cpu_backtrace+0x0/0x13 returned 0 after 0 usecs
[    0.693363] calling  kvm_spinlock_init_jump+0x0/0x37 @ 1
[    0.698929] initcall kvm_spinlock_init_jump+0x0/0x37 returned 0 after 0 usecs
[    0.706415] calling  spawn_ksoftirqd+0x0/0x23 @ 1
[    0.711377] initcall spawn_ksoftirqd+0x0/0x23 returned 0 after 0 usecs
[    0.718221] calling  init_workqueues+0x0/0x3e6 @ 1
[    0.723633] initcall init_workqueues+0x0/0x3e6 returned 0 after 976 usecs
[    0.730760] calling  migration_init+0x0/0x5b @ 1
[    0.735599] initcall migration_init+0x0/0x5b returned 0 after 0 usecs
[    0.742357] calling  check_cpu_stall_init+0x0/0x16 @ 1
[    0.747742] initcall check_cpu_stall_init+0x0/0x16 returned 0 after 0 usecs
[    0.755057] calling  rcu_scheduler_really_started+0x0/0x11 @ 1
[    0.761179] initcall rcu_scheduler_really_started+0x0/0x11 returned 0 after 0 usecs
[    0.769209] calling  rcu_spawn_gp_kthread+0x0/0x87 @ 1
[    0.774650] initcall rcu_spawn_gp_kthread+0x0/0x87 returned 0 after 0 usecs
[    0.781955] calling  cpu_stop_init+0x0/0x5d @ 1
[    0.786743] initcall cpu_stop_init+0x0/0x5d returned 0 after 0 usecs
[    0.793409] calling  relay_init+0x0/0x11 @ 1
[    0.797887] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.804284] calling  tracer_alloc_buffers+0x0/0x213 @ 1
[    0.809858] initcall tracer_alloc_buffers+0x0/0x213 returned 0 after 0 usecs
[    0.817263] calling  init_events+0x0/0x5f @ 1
[    0.821832] initcall init_events+0x0/0x5f returned 0 after 0 usecs
[    0.828316] calling  init_trace_printk+0x0/0xf @ 1
[    0.833339] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.840269] calling  event_trace_memsetup+0x0/0x5a @ 1
[    0.845691] initcall event_trace_memsetup+0x0/0x5a returned 0 after 0 usecs
[    0.852997] calling  jump_label_init_module+0x0/0xf @ 1
[    0.858480] initcall jump_label_init_module+0x0/0xf returned 0 after 0 usecs
[    0.865877] calling  hashlib_init+0x0/0x11 @ 1
[    0.870534] initcall hashlib_init+0x0/0x11 returned 0 after 0 usecs
[    0.877117] calling  balloon_clear+0x0/0x3b @ 1
[    0.881867] initcall balloon_clear+0x0/0x3b returned 0 after 0 usecs
[    0.888542] calling  rand_initialize+0x0/0x30 @ 1
[    0.893498] initcall rand_initialize+0x0/0x30 returned 0 after 0 usecs
[    0.900346] calling  mce_amd_init+0x0/0x134 @ 1
[    0.905093] MCE: In-kernel MCE decoding enabled.
[    0.909928] initcall mce_amd_init+0x0/0x134 returned 0 after 976 usecs
[    0.916953] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.927110] CPU 1 irqstacks, hard=f02c2000 soft=ef820000
[    0.932676] x86: Booting SMP configuration:
[    0.937056] .... node  #0, CPUs:      #1
[    0.951657] Initializing CPU#1
[    0.951998] masked ExtINT on CPU#1
[    0.954173] process: System has AMD C1E enabled
[    0.954698] CPU 2 irqstacks, hard=f028a000 soft=f028c000
[    0.965247]  #2
[    0.965248] Initializing CPU#2
[    0.965696] masked ExtINT on CPU#2
[    0.967885] process: Switch to broadcast mode on CPU2
[    0.968425] CPU 3 irqstacks, hard=f02be000 soft=f0200000
[    0.978975]  #3
[    0.978975] Initializing CPU#3
[    0.979424] masked ExtINT on CPU#3
[    0.981559] x86: Booted up 1 node, 4 CPUs
[    0.981561] smpboot: Total of 4 processors activated (23999.87 BogoMIPS)
[    0.981605] process: Switch to broadcast mode on CPU3
[    1.015941] process: Switch to broadcast mode on CPU1
[    1.026234] process: Switch to broadcast mode on CPU0
[    1.031867] devtmpfs: initialized
[    1.036287] calling  ipc_ns_i1] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    1.066680] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    1.075536] calling  net_ns_init+0x0/0x100 @ 1
[    1.080340] initcall net_ns_init+0x0/0x100 returned 0 after 0 usecs
[    1.086964] calling  e820_mark_nvs_memory+0x0/0x4e @ 1
[    1.092361] PM: Registering ACPI NVS region [mem 0xcfebe000-0xcfedffff] (139264 bytes)
[    1.100743] initcall e820_mark_nvs_memory+0x0/0x4e returned 0 after 976 usecs
[    1.108243] calling  cpufreq_tsc+0x0/0x26 @ 1
[    1.112821] initcall cpufreq_tsc+0x0/0x26 returned 0 after 0 usecs
[    1.119308] calling  reboot_init+0x0/0x1a @ 1
[    1.123889] initcall reboot_init+0x0/0x1a returned 0 after 0 usecs
[    1.130386] calling  init_lapic_sysfs+0x0/0x1b @ 1
[    1.135420] initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usecs
[    1.142382] calling  cpu_hotplug_pm_sync_init+0x0/0x29 @ 1
[    1.148144] initcall cpu_hotplug_pm_sync_init+0x0/0x29 returned 0 after 0 usecs
[    1.155825] calling  alloc_frozen_cpus+0x0/0x7 @ 1
[    1.160851] initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usecs
[    1.167803] calling  wq_sysfs_init+0x0/0x11 @ 1
[    1.172689] initcall wq_sysfs_init+0x0/0x11 returned 0 after 0 usecs
[    1.172808] kworker/u12:0 (30) used greatest stack depth: 6980 bytes left
[    1.186490] calling  ksysfs_init+0x0/0x74 @ 1
[    1.191137] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
[    1.197630] calling  pm_init+0x0/0x45 @ 1
[    1.201896] initcall pm_init+0x0/0x45 returned 0 after 0 usecs
[    1.208019] calling  pm_disk_init+0x0/0x14 @ 1
[    1.212713] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    1.219309] calling  swsusp_header_init+0x0/0x30 @ 1
[    1.224516] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    1.231652] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    1.237324] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    1.244908] calling  cgroup_wq_init+0x0/0x7c @ 1
[    1.249806] initcall cgroup_wq_init+0x0/0x7c returned 0 after 0 usecs
[    1.256572] calling  event_trace_enable+0x0/0x155 @ 1
[    1.262795] initcall event_trace_enable+0x0/0x155 returned 0 after 976 usecs
[    1.270203] calling  init_zero_pfn+0x0/0x14 @ 1
[    1.274956] initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
[    1.281627] calling  fsnotify_init+0x0/0x24 @ 1
[    1.286400] initcall fsnotify_init+0x0/0x24 returned 0 after 0 usecs
[    1.293074] calling  filelock_init+0x0/0x74 @ 1
[    1.297864] initcall filelock_init+0x0/0x74 returned 0 after 0 usecs
[    1.304537] calling  init_misc_binfmt+0x0/0x28 @ 1
[    1.309574] initcall init_misc_binfmt+0x0/0x28 returned 0 after 0 usecs
[    1.316518] calling  init_script_binfmt+0x0/0x13 @ 1
[    1.321733] initcall init_script_binfmt+0x0/0x13 returned 0 after 0 usecs
[    1.328862] calling  init_elf_binfmt+0x0/0x13 @ 1
[    1.333800] initcall init_elf_binfmt+0x0/0x13 returned 0 after 0 usecs
[    1.340649] calling  debugfs_init+0x0/0x4a @ 1
[    1.345339] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    1.351920] calling  securityfs_init+0x0/0x41 @ 1
[    1.356875] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    1.363741] calling  prandom_init+0x0/0xaa @ 1
[    1.368411] initcall prandom_init+0x0/0xaa returned 0 after 0 usecs
[    1.375001] calling  virtio_init+0x0/0x30 @ 1
[    1.379654] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    1.386150] calling  early_resume_init+0x0/0x1a0 @ 1
[    1.391374] RTC time: 19:32:12, date: 07/14/14
[    1.396045] initcall early_resume_init+0x0/0x1a0 returned 0 after 976 usecs
[    1.403360] calling  cpufreq_core_init+0x0/0x29 @ 1
[    1.408483] initcall cpufreq_core_init+0x0/0x29 returned 0 after 0 usecs
[    1.415519] calling  cpuidle_init+0x0/0x36 @ 1
[    1.420211] initcall cpuidle_init+0x0/0x36 returned 0 after 0 usecs
[    1.426795] calling  bsp_pm_check_init+0x0/0x11 @ 1
[    1.431908] initcall bsp_pm_check_init+0x0/0x11 returned 0 after 0 usecs
[    1.438947] calling  sock_init+0x0/0x89 @ 1
[    1.443600] initcall sock_init+0x0/0x89 returned 0 after 976 usecs
[    1.450095] calling  net_inuse_init+0x0/0x24 @ 1
[    1.454962] initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs
[    1.461730] calling  netpoll_init+0x0/0x2e @ 1
[    1.466401] initcall netpoll_init+0x0/0x2e returned 0 after 0 usecs
[    1.472978] calling  netlink_proto_init+0x0/0x1a7 @ 1
[    1.478356] NET: Registered protocol family 16
[    1.483058] initcall netlink_proto_init+0x0/0x1a7 returned 0 after 976 usecs
[    1.490460] calling  __gnttab_init+0x0/0x30 @ 1
[    1.495207] initcall __gnttab_init+0x0/0x30 returned -19 after 0 usecs
[    1.502104] calling  bdi_class_init+0x0/0x40 @ 1
[    1.507110] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
[    1.513874] calling  mm_sysfs_init+0x0/0x22 @ 1
[    1.518644] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
[    1.525320] calling  kobject_uevent_init+0x0/0xf @ 1
[    1.530554] initcall kobject_uevent_init+0x0/0xf returned 0 after 0 usecs
[    1.537688] calling  pcibus_class_init+0x0/0x14 @ 1
[    1.542842] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    1.549886] calling  pci_driver_init+0x0/0xf @ 1
[    1.554816] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    1.561586] calling  backlight_class_init+0x0/0x92 @ 1
[    1.567009] initcall backlight_class_init+0x0/0x92 returned 0 after 0 usecs
[    1.574328] calling  xenbus_init+0x0/0x24f @ 1
[    1.578993] initcall xenbus_init+0x0/0x24f returned -19 after 0 usecs
[    1.585761] calling  tty_class_init+0x0/0x2f @ 1
[    1.590647] initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
[    1.597411] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    1.602950] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    1.610261] calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
[    1.616299] initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 after 0 usecs
[    1.624252] calling  i2c_init+0x0/0x57 @ 1
[    1.628710] initcall i2c_init+0x0/0x57 returned 0 after 0 usecs
[    1.634931] calling  lguest_devices_init+0x0/0x13f @ 1
[    1.640327] initcall lguest_devices_init+0x0/0x13f returned 0 after 0 usecs
[    1.647643] calling  init_ladder+0x0/0xf @ 1
[    1.652125] cpuidle: using governor ladder
[    1.656430] initcall init_ladder+0x0/0xf returned 0 after 976 usecs
[    1.663009] calling  init_menu+0x0/0xf @ 1
[    1.667303] cpuidle: using governor menu
[    1.671428] initcall init_menu+0x0/0xf returned 0 after 976 usecs
[    1.677833] calling  amd_postcore_init+0x0/0x131 @ 1
[    1.683056] node 0 link 0: io port [1000, ffffff]
[    1.688000] TOM: 00000000d0000000 aka 3328M
[    1.692393] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    1.697789] node 0 link 0: mmio [a0000, bffff]
[    1.702467] node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
[    1.709978] node 0 link 0: mmio [f0000000, fe6fffff]
[    1.715201] node 0 link 0: mmio [fe700000, fe8fffff]
[    1.720423] node 0 link 0: mmio [fe900000, ffefffff]
[    1.725635] TOM2: 0000000130000000 aka 4864M
[    1.730124] bus: [bus 00-07] on node 0 link 0
[    1.734702] bus: 00 [io  0x0000-0xffff]
[    1.738723] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.743472] bus: 00 [mem 0xd0000000-0xdfffffff]
[    1.748230] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.752985] bus: 00 [mem 0x130000000-0xfcffffffff]
[    1.758029] initcall amd_postcore_init+0x0/0x131 returned 0 after 16601 usecs
[    1.765557] calling  boot_params_ksysfs_init+0x0/0x22f @ 1
[    1.771352] initcall boot_params_ksysfs_init+0x0/0x22f returned 0 after 0 usecs
[    1.779036] calling  arch_kdebugfs_init+0x0/0x2a6 @ 1
[    1.784378] initcall arch_kdebugfs_init+0x0/0x2a6 returned 0 after 0 usecs
[    1.791602] calling  init_pit_clocksource+0x0/0x36 @ 1
[    1.796995] initcall init_pit_clocksource+0x0/0x36 returned 0 after 0 usecs
[    1.804309] calling  mtrr_if_init+0x0/0x56 @ 1
[    1.808988] initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
[    1.815570] calling  ffh_cstate_init+0x0/0x27 @ 1
[    1.820509] initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usecs
[    1.827462] calling  kdump_buf_page_init+0x0/0x3a @ 1
[    1.832780] initcall kdump_buf_page_init+0x0/0x3a returned 0 after 0 usecs
[    1.840005] calling  activate_jump_labels+0x0/0x2d @ 1
[    1.845399] initcall activate_jump_labels+0x0/0x2d returned 0 after 0 usecs
[    1.852710] calling  acpi_pci_init+0x0/0x5b @ 1
[    1.857461] ACPI: bus type PCI registered
[    1.861670] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.868425] initcall acpi_pci_init+0x0/0x5b returned 0 after 1953 usecs
[    1.875378] calling  dma_bus_init+0x0/0xbb @ 1
[    1.880235] initcall dma_bus_init+0x0/0xbb returned 0 after 0 usecs
[    1.886812] calling  dma_channel_table_init+0x0/0xc4 @ 1
[    1.892515] initcall dma_channel_table_init+0x0/0xc4 returned 0 after 0 usecs
[    1.900011] calling  setup_vcpu_hotplug_event+0x0/0x1f @ 1
[    1.905766] initcall setup_vcpu_hotplug_event+0x0/0x1f returned -19 after 0 usecs
[    1.913630] calling  register_xen_pci_notifier+0x0/0x30 @ 1
[    1.919483] initcall register_xen_pci_notifier+0x0/0x30 returned 0 after 0 usecs
[    1.927245] calling  xen_pcpu_init+0x0/0xc8 @ 1
[    1.931999] initcall xen_pcpu_init+0x0/0xc8 returned -19 after 0 usecs
[    1.938864] calling  dmi_id_init+0x0/0x2a2 @ 1
[    1.943832] initcall dmi_id_init+0x0/0x2a2 returned 0 after 0 usecs
[    1.950419] calling  dca_init+0x0/0x21 @ 1
[    1.954718] dca service started, version 1.12.1
[    1.959508] initcall dca_init+0x0/0x21 returned 0 after 976 usecs
[    1.965910] calling  pci_arch_init+0x0/0x65 @ 1
[    1.970683] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.980461] PCI: not using MMCONFIG
[    1.984792] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
[    1.992442] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[    1.999106] PCI: Using configuration type 1 for base access
[    2.004956] PCI: Using configuration type 1 for extended access
[    2.011181] initcall pci_arch_init+0x0/0x65 returned 0 after 5859 usecs
[    2.018168] calling  topology_init+0x0/0x36 @ 1
[    2.023349] initcall topology_init+0x0/0x36 returned 0 after 0 usecs
[    2.030031] calling  mtrr_init_finialize+0x0/0x30 @ 1
[    2.035335] initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 usecs
[    2.042556] calling  uid_cache_init+0x0/0x7e @ 1
[    2.047433] initcall uid_cache_init+0x0/0x7e returned 0 after 0 usecs
[    2.054200] calling  param_sysfs_init+0x0/0x14c @ 1
[    2.072043] initcall param_sysfs_init+0x0/0x14c returned 0 after 12695 usecs
[    2.079456] calling  proc_schedstat_init+0x0[    2.103016] initcall pm_sysrq_init+0x0/0x16 returned 0 after 6835 usecs
[    2.109978] calling  create_proc_profile+0x0/0x1ememory_init+0x0/0x35 @ 1
[    2.142383] initcall crash_notes_memory_init+0x0/0x35 returned 0 after 0 usecs
[    2.149959] calling  hung_task_init+0x0/0x56 @ 1
[    2.154872] initcall hung_task_init+0x0/0x56 returned 0 after 0 usecs
[    2.161642] calling  default_bdi_init+0x0/0x78 @ 1
[    2.167161] initcall default_bdi_init+0x0/0x78 returned 0 after 976 usecs
[    2.174299] calling  init_reserve_notifier+0x0/0x7 @ 1
[    2.179689] initcall init_reserve_notifier+0x0/0x7 returned 0 after 0 usecs
[    2.187000] calling  init_admin_reserve+0x0/0x30 @ 1
[    2.192209] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 usecs
[    2.199333] calling  init_user_reserve+0x0/0x30 @ 1
[    2.204459] initcall init_user_reserve+0x0/0x30 returned 0 after 0 usecs
[    2.211505] calling  mmu_notifier_init+0x0/0xf @ 1
[    2.216555] initcall mmu_notifier_init+0x0/0xf returned 0 after 0 usecs
[    2.223500] calling  hugepage_init+0x0/0x123 @ 1
[    2.228543] initcall hugepage_init+0x0/0x123 returned 0 after 0 usecs
[    2.235327] calling  crypto_wq_init+0x0/0x41 @ 1
[    2.240247] initcall crypto_wq_init+0x0/0x41 returned 0 after 0 usecs
[    2.247018] calling  cryptomgr_init+0x0/0xf @ 1
[    2.251791] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    2.258469] calling  init_bio+0x0/0xc5 @ 1
[    2.263148] initcall init_bio+0x0/0xc5 returned 0 after 0 usecs
[    2.269369] calling  blk_settings_init+0x0/0x21 @ 1
[    2.274493] initcall blk_settings_init+0x0/0x21 returned 0 after 0 usecs
[    2.281525] calling  blk_ioc_init+0x0/0x2f @ 1
[    2.286217] initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
[    2.292796] calling  blk_softirq_init+0x0/0x54 @ 1
[    2.297826] initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs
[    2.304769] calling  blk_iopoll_setup+0x0/0x54 @ 1
[    2.309800] initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs
[    2.316752] calling  blk_mq_init+0x0/0x16 @ 1
[    2.321328] initcall blk_mq_init+0x0/0x16 returned 0 after 0 usecs
[    2.327825] calling  genhd_device_init+0x0/0x6a @ 1
[    2.333153] initcall genhd_device_init+0x0/0x6a returned 0 after 0 usecs
[    2.340205] calling  blk_dev_integrity_init+0x0/0x2f @ 1
[    2.345826] initcall blk_dev_integrity_init+0x0/0x2f returned 0 after 0 usecs
[    2.353327] calling  pci_slot_init+0x0/0x40 @ 1
[    2.358092] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    2.364768] calling  fbmem_init+0x0/0x96 @ 1
[    2.369302] initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
[    2.375699] calling  acpi_init+0x0/0x26b @ 1
[    2.380274] ACPI: Added _OSI(Module Device)
[    2.384668] ACPI: Added _OSI(Processor Device)
[    2.389327] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.394270] ACPI: Added _OSI(Processor Aggregator Device)
[    2.413911] ACPI: Executed 4 blocks of module-level executable AML code
[    2.497107] ACPI: Interpreter enabled
[    2.500966] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    2.510686] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    2.520419] ACPI: (supports S0 S3 S4 S5)
[    2.524536] ACPI: Using IOAPIC for interrupt routing
[    2.529900] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    2.568827] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    2.577956] PCI: Using MMCONFIG for extended config space
[    2.583708] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.604349] kworker/u12:0 (310) used greatest stack depth: 6852 bytes left
[    2.715903] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.722403] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.731041] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    2.739946] acpi PNP0A03:00: ignoring host bridge window [mem 0x000d0000-0x000dffff] (conflicts with Adapter ROM [mem 0x000cf000-0x000d09ff])
[    2.755000] PCI host bridge to bus 0000:00
[    2.759303] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.765075] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.771563] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.778056] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.785274] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdfffffff]
[    2.792502] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    2.799738] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
[    2.806876] pci 0000:00:01.0: [1022:9602] type 01 class 0x060400
[    2.814000] pci 0000:00:06.0: [1022:9606] type 01 class 0x060400
[    2.820341] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    2.827304] pci 0000:00:06.0: System wakeup disabled by ACPI
[    2.833613] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    2.839970] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.846923] pci 0000:00:07.0: System wakeup disabled by ACPI
[    2.853255] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    2.859583] pci 0000:00:11.0: reg 0x10: [io  0x7000-0x7007]
[    2.865437] pci 0000:00:11.0: reg 0x14: [io  0x6000-0x6003]
[    2.871287] pci 0000:00:11.0: reg 0x18: [io  0x5000-0x5007]
[    2.877138] pci 0000:00:11.0: reg 0x1c: [io  0x4000-0x4003]
[    2.882994] pci 0000:00:11.0: reg 0x20: [io  0x3000-0x300f]
[    2.888841] pci 0000:00:11.0: reg 0x24: [mem 0xfe6ffc00-0xfe6fffff]
[    2.896246] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    2.902555] pci 0000:00:12.0: reg 0x10: [mem 0xfe6fe000-0xfe6fefff]
[    2.909737] pci 0000:00:12.0: System wakeup disabled by ACPI
[    2.916053] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    2.922360] pci 0000:00:12.1: reg 0x10: [mem 0xfe6fd000-0xfe6fdfff]
[    2.929554] pci 0000:00:12.1: System wakeup disabled by ACPI
[    2.935868] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    2.942184] pci 0000:00:12.2: reg 0x10: [mem 0xfe6ff800-0xfe6ff8ff]
[    2.948840] pci 0000:00:12.2: supports D1 D2
[    2.953317] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    2.960188] pci 0000:00:12.2: System wakeup disabled by ACPI
[    2.966499] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    2.972812] pci 0000:00:13.0: reg 0x10: [mem 0xfe6fc000-0xfe6fcfff]
[    2.980007] pci 0000:00:13.0: System wakeup disabled by ACPI
[    2.986314] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    2.992629] pci 0000:00:13.1: reg 0x10: [mem 0xfe6f7000-0xfe6f7fff]
[    2.999806] pci 0000:00:13.1: System wakeup disabled by ACPI
[    3.006134] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    3.012447] pci 0000:00:13.2: reg 0x10: [mem 0xfe6ff400-0xfe6ff4ff]
[    3.019101] pci 0000:00:13.2: supports D1 D2
[    3.023579] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    3.030454] pci 0000:00:13.2: System wakeup disabled by ACPI
[    3.036752] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    3.043937] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    3.051086] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    3.057978] pci 0000:00:14.4: System wakeup disabled by ACPI
[    3.064294] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    3.070601] pci 0000:00:14.5: reg 0x10: [mem 0xfe6f6000-0xfe6f6fff]
[    3.077795] pci 0000:00:14.5: System wakeup disabled by ACPI
[    3.084103] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    3.091157] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    3.098215] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    3.105256] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    3.112308] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    3.119650] pci 0000:01:05.0: [1002:9610] type 00 class 0x030000
[    3.125956] pci 0000:01:05.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]
[    3.132992] pci 0000:01:05.0: reg 0x14: [io  0x8000-0x80ff]
[    3.138838] pci 0000:01:05.0: reg 0x18: [mem 0xfe8f0000-0xfe8fffff]
[    3.145415] pci 0000:01:05.0: reg 0x24: [mem 0xfe700000-0xfe7fffff]
[    3.151999] pci 0000:01:05.0: supports D1 D2
[    3.156878] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
[    3.163183] pci 0000:01:05.1: reg 0x10: [mem 0xfe8e8000-0xfe8ebfff]
[    3.169782] pci 0000:01:05.1: supports D1 D2
[    3.174628] pci 0000:00:01.0: PCI bridge to [bus 01]
[    3.179844] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    3.186243] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff]
[    3.193365] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.201723] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    3.208033] pci 0000:02:00.0: reg 0x10: [io  0x9800-0x98ff]
[    3.213908] pci 0000:02:00.0: reg 0x18: [mem 0xfe9ff000-0xfe9fffff 64bit]
[    3.221033] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64bit pref]
[    3.228616] pci 0000:02:00.0: reg 0x30: [mem 0xfe9c0000-0xfe9dffff pref]
[    3.235709] pci 0000:02:00.0: supports D1 D2
[    3.240193] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.248797] pci 0000:00:06.0: PCI bridge to [bus 02]
[    3.254005] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    3.260404] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    3.267557] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    3.275909] pci 0000:03:00.0: [197b:2361] type 00 class 0x010601
[    3.282283] pci 0000:03:00.0: reg 0x24: [mem 0xfeafe000-0xfeafffff]
[    3.288922] pci 0000:03:00.0: PME# supported from D3hot
[    3.294857] pci 0000:03:00.1: [197b:2361] type 00 class 0x010185
[    3.301175] pci 0000:03:00.1: reg 0x10: [io  0xb800-0xb807]
[    3.307028] pci 0000:03:00.1: reg 0x14: [io  0xb400-0xb403]
[    3.312895] pci 0000:03:00.1: reg 0x18: [io  0xb000-0xb007]
[    3.318752] pci 0000:03:00.1: reg 0x1c: [io  0xa800-0xa803]
[    3.324615] pci 0000:03:00.1: reg 0x20: [io  0xa400-0xa40f]
[    3.330844] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.341355] pci 0000:00:07.0: PCI bridge to [bus 03]
[    3.346573] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    3.352966] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    3.360321] pci 0000:04:05.0: [10b7:1700] type 00 class 0x020000
[    3.366648] pci 0000:04:05.0: reg 0x10: [mem 0xfebfc000-0xfebfffff]
[    3.373235] pci 0000:04:05.0: reg 0x14: [io  0xe800-0xe8ff]
[    3.379136] pci 0000:04:05.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    3.386220] pci 0000:04:05.0: supports D1 D2
[    3.390704] pci 0000:04:05.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.398109] pci 0000:04:07.0: [9710:9835] type 00 class 0x070002
[    3.404433] pci 0000:04:07.0: reg 0x10: [io  0xe400-0xe407]
[    3.410299] pci 0000:04:07.0: reg 0x14: [io  0xe000-0xe007]
[    3.416156] pci 0000:04:07.0: reg 0x18: [io  0xd800-0xd807]
[    3.422017] pci 0000:04:07.0: reg 0x1c: [io  0xd400-0xd407]
[    3.427868] pci 0000:04:07.0: reg 0x20: [io  0xd000-0xd007]
[    3.433728] pci 0000:04:07.0: reg 0x24: [io  0xc800-0xc80f]
[    3.439943] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive decode)
[    3.447073] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    3.453478] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    3.460620] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    3.468935] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    3.477250] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    3.486291] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffffff] (subtractive decode)
[    3.495338] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    3.504396] pci_bus 0000:00: on NUMA node 0
[    3.534282] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 *14 15)
[    3.541744] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 12 14 15)
[    3.549184] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    3.556629] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    3.564072] ACPI: PCI Interrupt Link [LNKE] (IRQs *4 10 11 12 14 15)
[    3.571327] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 10 11 12 14 15) *0, disabled.
[    3.579785] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 *15)
[    3.587042] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 10 11 12 14 15) *0, disabled.
[    3.595489] ACPI: Enabled 1 GPEs in block 00 to 1F
[    3.600640] initcall acpi_init+0x0/0x26b returned 0 after 456054 usecs
[    3.607499] calling  pnp_init+0x0/0xf @ 1
[    3.611800] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    3.617939] calling  balloon_init+0x0/0x1fa @ 1
[    3.622700] initcall balloon_init+0x0/0x1fa returned -19 after 0 usecs
[    3.629573] calling  xen_setup_shutdown_event+0x0/0x30 @ 1
[    3.635341] initcall xen_setup_shutdown_event+0x0/0x30 returned -19 after 0 usecs
[    3.643203] calling  xenbus_probe_backend_init+0x0/0x23 @ 1
[    3.649137] initcall xenbus_probe_backend_init+0x0/0x23 returned 0 after 0 usecs
[    3.656913] calling  xenbus_probe_frontend_init+0x0/0x7b @ 1
[    3.662941] initcall xenbus_probe_frontend_init+0x0/0x7b returned 0 after 0 usecs
[    3.670816] calling  xen_acpi_pad_init+0x0/0x41 @ 1
[    3.675945] initcall xen_acpi_pad_init+0x0/0x41 returned -19 after 0 usecs
[    3.683161] calling  balloon_init+0x0/0xdd @ 1
[    3.687821] initcall balloon_init+0x0/0xdd returned -19 after 0 usecs
[    3.694597] calling  misc_init+0x0/0xad @ 1
[    3.699039] initcall misc_init+0x0/0xad returned 0 after 0 usecs
[    3.705358] calling  vga_arb_device_init+0x0/0xcc @ 1
[    3.710840] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    3.719343] vgaarb: loaded
[    3.722175] vgaarb: bridge control possible 0000:01:05.0
[    3.727745] initcall vga_arb_device_init+0x0/0xcc returned 0 after 16601 usecs
[    3.735325] calling  cn_init+0x0/0xb0 @ 1
[    3.739551] initcall cn_init+0x0/0xb0 returned 0 after 0 usecs
[    3.745674] calling  dma_buf_init+0x0/0x62 @ 1
[    3.750350] initcall dma_buf_init+0x0/0x62 returned 0 after 0 usecs
[    3.756917] calling  phy_init+0x0/0x2f @ 1
[    3.761441] initcall phy_init+0x0/0x2f returned 0 after 976 usecs
[    3.767836] calling  init_pcmcia_cs+0x0/0x32 @ 1
[    3.772714] initcall init_pcmcia_cs+0x0/0x32 returned 0 after 0 usecs
[    3.779473] calling  usb_init+0x0/0x14c @ 1
[    3.783872] ACPI: bus type USB registered
[    3.788291] usbcore: registered new interface driver usbfs
[    3.794139] usbcore: registered new interface driver hub
[    3.794230] kworker/u12:0 (428) used greatest stack depth: 6844 bytes left
[    3.807028] usbcore: registered new device driver usb
[    3.812324] initcall usb_init+0x0/0x14c returned 0 after 28320 usecs
[    3.818986] calling  serio_init+0x0/0x2e @ 1
[    3.823532] initcall serio_init+0x0/0x2e returned 0 after 0 usecs
[    3.829928] calling  input_init+0x0/0xf1 @ 1
[    3.834446] initcall input_init+0x0/0xf1 returned 0 after 0 usecs
[    3.840841] calling  rtc_init+0x0/0x50 @ 1
[    3.845180] initcall rtc_init+0x0/0x50 returned 0 after 976 usecs
[    3.851577] calling  pps_init+0x0/0xa6 @ 1
[    3.855900] pps_core: LinuxPPS API ver. 1 registered
[    3.861106] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.870684] initcall pps_init+0x0/0xa6 returned 0 after 14648 usecs
[    3.877262] calling  ptp_init+0x0/0x8e @ 1
[    3.881591] PTP clock support registered
[    3.885700] initcall ptp_init+0x0/0x8e returned 0 after 3906 usecs
[    3.892192] calling  power_supply_class_init+0x0/0x39 @ 1
[    3.897887] initcall power_supply_class_init+0x0/0x39 returned 0 after 0 usecs
[    3.905474] calling  hwmon_init+0x0/0xda @ 1
[    3.909983] initcall hwmon_init+0x0/0xda returned 0 after 0 usecs
[    3.916371] calling  leds_init+0x0/0x36 @ 1
[    3.920789] initcall leds_init+0x0/0x36 returned 0 after 0 usecs
[    3.927097] calling  efisubsys_init+0x0/0x115 @ 1
[    3.932028] initcall efisubsys_init+0x0/0x115 returned 0 after 0 usecs
[    3.938878] calling  pci_subsys_init+0x0/0x48 @ 1
[    3.943811] PCI: Using ACPI for IRQ routing
[    3.948195] PCI: pci_cache_line_size set to 64 bytes
[    3.953447] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    3.959751] e820: reserve RAM buffer [mem 0xcfeb0000-0xcfffffff]
[    3.966059] initcall pci_subsys_init+0x0/0x48 returned 0 after 22460 usecs
[    3.973274] calling  proto_init+0x0/0xf @ 1
[    3.977668] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    3.983967] calling  net_dev_init+0x0/0x15d @ 1
[    3.989524] initcall net_dev_init+0x0/0x15d returned 0 after 976 usecs
[    3.996374] calling  neigh_init+0x0/0xa4 @ 1
[    4.000849] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
[    4.007242] calling  fib_rules_init+0x0/0xbd @ 1
[    4.012078] initcall fib_rules_init+0x0/0xbd returned 0 after 0 usecs
[    4.018834] calling  pktsched_init+0x0/0x121 @ 1
[    4.023685] initcall pktsched_init+0x0/0x121 returned 0 after 0 usecs
[    4.030447] calling  tc_filter_init+0x0/0x6a @ 1
[    4.035287] initcall tc_filter_init+0x0/0x6a returned 0 after 0 usecs
[    4.042046] calling  tc_action_init+0x0/0x6a @ 1
[    4.046882] initcall tc_action_init+0x0/0x6a returned 0 after 0 usecs
[    4.053639] calling  genl_init+0x0/0x7a @ 1
[    4.058044] initcall genl_init+0x0/0x7a returned 0 after 0 usecs
[    4.064349] calling  cipso_v4_init+0x0/0x5a @ 1
[    4.069102] initcall cipso_v4_init+0x0/0x5a returned 0 after 0 usecs
[    4.075764] calling  netlbl_init+0x0/0x7d @ 1
[    4.080327] NetLabel: Initializing
[    4.083894] NetLabel:  domain hash size = 128
[    4.088457] NetLabel:  protocols = UNLABELED CIPSOv4
[    4.093712] NetLabel:  unlabeled traffic allowed by default
[    4.099562] initcall netlbl_init+0x0/0x7d returned 0 after 18554 usecs
[    4.106411] calling  rfkill_init+0x0/0x68 @ 1
[    4.111108] initcall rfkill_init+0x0/0x68 returned 0 after 0 usecs
[    4.117596] calling  xen_mcfg_late+0x0/0xa6 @ 1
[    4.122343] initcall xen_mcfg_late+0x0/0xa6 returned 0 after 0 usecs
[    4.129052] calling  xen_p2m_debugfs+0x0/0x49 @ 1
[    4.134001] initcall xen_p2m_debugfs+0x0/0x49 returned 0 after 0 usecs
[    4.140863] calling  xen_spinlock_debugfs+0x0/0x120 @ 1
[    4.146401] initcall xen_spinlock_debugfs+0x0/0x120 returned 0 after 0 usecs
[    4.153804] calling  nmi_warning_debugfs+0x0/0x26 @ 1
[    4.159109] initcall nmi_warning_debugfs+0x0/0x26 returned 0 after 0 usecs
[    4.166321] calling  hpet_late_init+0x0/0xe6 @ 1
[    4.171176] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    4.176600] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    4.184717] initcall hpet_late_init+0x0/0xe6 returned 0 after 12695 usecs
[    4.191839] calling  init_amd_nbs+0x0/0xb6 @ 1
[    4.196511] initcall init_amd_nbs+0x0/0xb6 returned 0 after 0 usecs
[    4.203089] calling  clocksource_done_booting+0x0/0x3b @ 1
[    4.208858] Switched to clocksource hpet
[    4.212990] initcall clocksource_done_booting+0x0/0x3b returned 0 after 4042 usecs
[    4.220935] calling  tracer_init_debugfs+0x0/0x165 @ 1
[    4.226818] initcall tracer_init_debugfs+0x0/0x165 returned 0 after 476 usecs
[    4.234316] calling  init_trace_printk_function_export+0x0/0x33 @ 1
[    4.240918] initcall init_trace_printk_function_export+0x0/0x33 returned 0 after 8 usecs
[    4.249420] calling  event_trace_init+0x0/0x1ee @ 1
[    4.275136] initcall event_trace_init+0x0/0x1ee returned 0 after 20127 usecs
[    4.282545] calling  init_kprobe_trace+0x0/0_fs+0x0/0x3d @ 1
[    4.299597] initcall init_pipe_fs+0x0/0x3d returned 0 after 105 usecs
[    4.306364] calling  eventpoll_init+0x0/0xd0 @ 1
[    4.311303] initcall eventpoll_init+0x0/0xd0 returned 0 after 88 usecs
[    4.318152] calling  anon_inode_init+0x0/0x56 @ 1
[    4.323189] initcall anon_inode_init+0x0/0x56 returned 0 after 94 usecs
[    4.330135] calling  proc_cmdline_init+0x0/0x27 @ 1
[    4.335265] initcall proc_cmdline_init+0x0/0x27 returned 0 after 7 usecs
[    4.342309] calling  proc_consoles_init+0x0/0x27 @ 1
[    4.347537] initcall proc_consoles_init+0x0/0x27 returned 0 after 6 usecs
[    4.354666] calling  proc_cpuinfo_init+0x0/0x27 @ 1
[    4.359798] initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 6 usecs
[    4.366836] calling  proc_devices_init+0x0/0x27 @ 1
[    4.371971] initcall proc_devices_init+0x0/0x27 returned 0 after 5 usecs
[    4.379014] calling  proc_interrupts_init+0x0/0x27 @ 1
[    4.384420] initcall proc_interrupts_init+0x0/0x27 returned 0 after 6 usecs
[    4.391744] calling  proc_loadavg_init+0x0/0x27 @ 1
[    4.396868] initcall proc_loadavg_init+0x0/0x27 returned 0 after 6 usecs
[    4.403911] calling  proc_meminfo_init+0x0/0x27 @ 1
[    4.409040] initcall proc_meminfo_init+0x0/0x27 returned 0 after 6 usecs
[    4.416070] calling  proc_stat_init+0x0/0x27 @ 1
[    4.420927] initcall proc_stat_init+0x0/0x27 returned 0 after 6 usecs
[    4.427700] calling  proc_uptime_init+0x0/0x27 @ 1
[    4.432734] initcall proc_uptime_init+0x0/0x27 returned 0 after 5 usecs
[    4.439684] calling  proc_version_init+0x0/0x27 @ 1
[    4.444816] initcall proc_version_init+0x0/0x27 returned 0 after 6 usecs
[    4.451852] calling  proc_softirqs_init+0x0/0x27 @ 1
[    4.457070] initcall proc_softirqs_init+0x0/0x27 returned 0 after 6 usecs
[    4.464200] calling  proc_kcore_init+0x0/0xae @ 1
[    4.469157] initcall proc_kcore_init+0x0/0xae returned 0 after 9 usecs
[    4.476013] calling  vmcore_init+0x0/0x68b @ 1
[    4.480686] initcall vmcore_init+0x0/0x68b returned 0 after 1 usecs
[    4.487280] calling  proc_kmsg_init+0x0/0x2a @ 1
[    4.492133] initcall proc_kmsg_init+0x0/0x2a returned 0 after 6 usecs
[    4.498900] calling  proc_page_init+0x0/0x4a @ 1
[    4.503762] initcall proc_page_init+0x0/0x4a returned 0 after 11 usecs
[    4.510621] calling  init_ramfs_fs+0x0/0x44 @ 1
[    4.515451] initcall init_ramfs_fs+0x0/0x44 returned 0 after 71 usecs
[    4.522214] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    4.527626] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 1 usecs
[    4.534936] calling  acpi_event_init+0x0/0x37 @ 1
[    4.539919] initcall acpi_event_init+0x0/0x37 returned 0 after 30 usecs
[    4.546870] calling  pnp_system_init+0x0/0xf @ 1
[    4.551767] initcall pnp_system_init+0x0/0xf returned 0 after 52 usecs
[    4.558624] calling  pnpacpi_init+0x0/0x88 @ 1
[    4.563291] pnp: PnP ACPI init
[    4.566550] ACPI: bus type PNP registered
[    4.571974] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.579673] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.606649] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    4.613977] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    4.620921] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.630292] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    4.636533] system 00:03: [io  0x040b] has been reserved
[    4.642132] system 00:03: [io  0x04d6] has been reserved
[    4.647716] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    4.653937] system 00:03: [io  0x0c14] has been reserved
[    4.659523] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    4.665750] system 00:03: [io  0x0c52] has been reserved
[    4.671340] system 00:03: [io  0x0c6c] has been reserved
[    4.676927] system 00:03: [io  0x0c6f] has been reserved
[    4.682508] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    4.688731] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    4.694956] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    4.701181] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    4.707418] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    4.713652] system 00:03: [io  0x0800-0x089f] could not be reserved
[    4.720241] system 00:03: [io  0x0b00-0x0b0f] has been reserved
[    4.726476] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    4.732709] system 00:03: [io  0x0900-0x090f] has been reserved
[    4.738934] system 00:03: [io  0x0910-0x091f] has been reserved
[    4.745174] system 00:03: [io  0xfe00-0xfefe] has been reserved
[    4.751406] system 00:03: [mem 0xffb80000-0xffbfffff] has been reserved
[    4.758363] system 00:03: [mem 0xfec10000-0xfec1001f] has been reserved
[    4.765340] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.775009] system 00:04: [io  0x0e00-0x0e0f] has been reserved
[    4.781229] system 00:04: [io  0x0e80-0x0e8f] has been reserved
[    4.787454] system 00:04: [io  0x0f40-0x0f4f] has been reserved
[    4.793679] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    4.799909] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.807594] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    4.814552] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.823436] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
[    4.830764] system 00:06: [mem 0x000c0000-0x000cffff] could not be reserved
[    4.838092] system 00:06: [mem 0x000e0000-0x000fffff] could not be reserved
[    4.845416] system 00:06: [mem 0x00100000-0xcfefffff] could not be reserved
[    4.852734] system 00:06: [mem 0xfec00000-0xffffffff] could not be reserved
[    4.860054] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.868070] pnp: PnP ACPI: found 7 devices
[    4.872370] ACPI: bus type PNP unregistered
[    4.876763] initcall pnpacpi_init+0x0/0x88 returned 0 after 306411 usecs
[    4.883802] calling  pcistub_init+0x0/0x280 @ 1
[    4.889359] initcall pcistub_init+0x0/0x280 returned 0 after 773 usecs
[    4.896217] calling  chr_dev_init+0x0/0xc9 @ 1
[    4.912172] initcall chr_dev_init+0x0/0xc9 returned 0 after 11025 usecs
[    4.919126] calling  firmware_class_init+0x0/0xd736829] initcall init_pcmcia_bus+0x0/0x5e returned 0 after 86 usecs
[    4.943783] calling  thermal_init+0x0/0x78 @ 1
[    4.948509] initcall thermal_init+0x0/0x78 returned 0 after 53 usecs
[    4.955192] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    4.961243] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 1 usecs
[    4.969207] calling  init_acpi_pm_clocksource+0x0/0x18d @ 1
[    5.009568] initcall init_acpi_pm_clocksource+0x0/0x18d returned 0 after 33736 usecs
[    5.017717] calling  pcibios_assign_resources+0x0/0x8f @ 1
[    5.023509] pci 0000:00:01.0: PCI bridge to [bus 01]
[    5.028726] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    5.035138] pci 0000:00:01.0:   bridge window [mem 0xfe700000-0xfe8fffff]
[    5.042268] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    5.050401] pci 0000:00:06.0: PCI bridge to [bus 02]
[    5.055614] pci 0000:00:06.0:   bridge window [io  0x9000-0x9fff]
[    5.062031] pci 0000:00:06.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    5.069148] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    5.077297] pci 0000:00:07.0: PCI bridge to [bus 03]
[    5.082503] pci 0000:00:07.0:   bridge window [io  0xa000-0xbfff]
[    5.088913] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    5.096045] pci 0000:00:14.4: PCI bridge to [bus 04]
[    5.101267] pci 0000:00:14.4:   bridge window [io  0xc000-0xefff]
[    5.107671] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    5.114818] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    5.120670] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    5.126529] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    5.133116] pci_bus 0000:00: resource 7 [mem 0xcff00000-0xdfffffff]
[    5.139703] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff]
[    5.146298] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    5.152151] pci_bus 0000:01: resource 1 [mem 0xfe700000-0xfe8fffff]
[    5.158735] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    5.166324] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    5.172177] pci_bus 0000:02: resource 1 [mem 0xfe900000-0xfe9fffff]
[    5.178755] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    5.186336] pci_bus 0000:03: resource 0 [io  0xa000-0xbfff]
[    5.192193] pci_bus 0000:03: resource 1 [mem 0xfea00000-0xfeafffff]
[    5.198783] pci_bus 0000:04: resource 0 [io  0xc000-0xefff]
[    5.204640] pci_bus 0000:04: resource 1 [mem 0xfeb00000-0xfebfffff]
[    5.211218] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    5.217074] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    5.222915] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    5.229515] pci_bus 0000:04: resource 7 [mem 0xcff00000-0xdfffffff]
[    5.236096] pci_bus 0000:04: resource 8 [mem 0xf0000000-0xfebfffff]
[    5.242691] initcall pcibios_assign_resources+0x0/0x8f returned 0 after 214267 usecs
[    5.250826] calling  sysctl_core_init+0x0/0x23 @ 1
[    5.255888] initcall sysctl_core_init+0x0/0x23 returned 0 after 29 usecs
[    5.262942] calling  inet_init+0x0/0x25b @ 1
[    5.267663] NET: Registered protocol family 2
[    5.273011] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    5.280448] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    5.287234] TCP: Hash tables configured (established 8192 bind 8192)
[    5.293948] TCP: reno registered
[    5.297337] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    5.303562] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    5.310583] initcall inet_init+0x0/0x25b returned 0 after 42178 usecs
[    5.317363] calling  ipv4_offload_init+0x0/0x5d @ 1
[    5.322487] initcall ipv4_offload_init+0x0/0x5d returned 0 after 1 usecs
[    5.329533] calling  af_unix_init+0x0/0x4d @ 1
[    5.334231] NET: Registered protocol family 1
[    5.338824] initcall af_unix_init+0x0/0x4d returned 0 after 4521 usecs
[    5.345679] calling  ipv6_offload_init+0x0/0x7a @ 1
[    5.350814] initcall ipv6_offload_init+0x0/0x7a returned 0 after 3 usecs
[    5.357853] calling  init_sunrpc+0x0/0x5f @ 1
[    5.362815] RPC: Registered named UNIX socket transport module.
[    5.369029] RPC: Registered udp transport module.
[    5.373978] RPC: Registered tcp transport module.
[    5.378927] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.385691] initcall init_sunrpc+0x0/0x5f returned 0 after 22730 usecs
[    5.392546] calling  pci_apply_final_quirks+0x0/0x112 @ 1
[    5.398215] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    5.766860] pci 0000:01:05.0: Boot video device
[    5.771642] PCI: CLS 64 bytes, default 64
[    5.775863] initcall pci_apply_final_quirks+0x0/0x112 returned 0 after 369146 usecs
[    5.783911] calling  populate_rootfs+0x0/0xf9 @ 1
[    5.789023] Unpacking initramfs...
[    7.642758] microcode: updated early to new patch_level=0x010000db
[    7.676706] Freeing initrd memory: 83092K (f2ad9000 - f7bfe000)
[    7.682929] initcall populate_rootfs+0x0/0xf9 returned 0 
[    7.695201] initcall pci_iommu_init+0x0/0x34 returned 0 after 2 usecs
[    7.702026] calling  register_kernel_offset_dumper+0x0/0x16 @ 1
[    7.708256] initcall register_kernel_offset_dumper+0x0/0x16 returned 0 after 2 usecs
[    7.716387] calling  i8259A_init_ops+0x0/0x1d @ 1
[    7.721336] initcall i8259A_init_ops+0x0/0x1d returned 0 after 2 usecs
[    7.728197] calling  sbf_init+0x0/0xf1 @ 1
[    7.732501] initcall sbf_init+0x0/0xf1 returned 0 after 1 usecs
[    7.738718] calling  init_tsc_clocksource+0x0/0xa7 @ 1
[    7.744121] initcall init_tsc_clocksource+0x0/0xa7 returned 0 after 2 usecs
[    7.751447] calling  add_rtc_cmos+0x0/0x99 @ 1
[    7.756121] initcall add_rtc_cmos+0x0/0x99 returned 0 after 2 usecs
[    7.762706] calling  i8237A_init_ops+0x0/0x11 @ 1
[    7.767659] initcall i8237A_init_ops+0x0/0x11 returned 0 after 1 usecs
[    7.774522] calling  cache_sysfs_init+0x0/0x69 @ 1
[    7.780885] initcall cache_sysfs_init+0x0/0x69 returned 0 after 1295 usecs
[    7.788110] calling  amd_uncore_init+0x0/0x111 @ 1
[    7.793155] initcall amd_uncore_init+0x0/0x111 returned -19 after 1 usecs
[    7.800293] calling  intel_uncore_init+0x0/0x3ea @ 1
[    7.805514] initcall intel_uncore_init+0x0/0x3ea returned -19 after 0 usecs
[    7.812838] calling  rapl_pmu_init+0x0/0x194 @ 1
[    7.817686] initcall rapl_pmu_init+0x0/0x194 returned 0 after 1 usecs
[    7.824464] calling  inject_init+0x0/0x30 @ 1
[    7.829048] Machine check injector initialized
[    7.833725] initcall inject_init+0x0/0x30 returned 0 after 4571 usecs
[    7.840498] calling  thermal_throttle_init_device+0x0/0x6d @ 1
[    7.846629] initcall thermal_throttle_init_device+0x0/0x6d returned 0 after 0 usecs
[    7.854685] calling  microcode_init+0x0/0x18c @ 1
[    7.859762] microcode: CPU0: patch_level=0x010000db
[    7.864913] microcode: CPU1: patch_level=0x01000086
[    7.870072] microcode: CPU2: patch_level=0x01000086
[    7.875231] microcode: CPU3: patch_level=0x01000086
[    7.880548] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.889808] initcall microcode_init+0x0/0x18c returned 0 after 29500 usecs
[    7.897043] calling  amd_ibs_init+0x0/0x21f @ 1
[    7.901815] LVT offset 1 assigned for vector 0x400
[    7.906861] IBS: LVT offset 1 assigned
[    7.910911] perf: AMD IBS detected (0x0000001f)
[    7.915673] initcall amd_ibs_init+0x0/0x21f returned 0 after 13546 usecs
[    7.922713] calling  msr_init+0x0/0x153 @ 1
[    7.927818] initcall msr_init+0x0/0x153 returned 0 after 690 usecs
[    7.934327] calling  cpuid_init+0x0/0x153 @ 1
[    7.939493] initcall cpuid_init+0x0/0x153 returned 0 after 574 usecs
[    7.946175] calling  ioapic_init_ops+0x0/0x11 @ 1
[    7.951135] initcall ioapic_init_ops+0x0/0x11 returned 0 after 1 usecs
[    7.957989] calling  add_pcspkr+0x0/0x3b @ 1
[    7.962570] initcall add_pcspkr+0x0/0x3b returned 0 after 84 usecs
[    7.969066] calling  start_periodic_check_for_corruption+0x0/0x60 @ 1
[    7.975846] Scanning for low memory corruption every 60 seconds
[    7.982065] initcall start_periodic_check_for_corruption+0x0/0x60 returned 0 after 6077 usecs
[    7.991032] calling  sysfb_init+0x0/0x80 @ 1
[    7.995617] initcall sysfb_init+0x0/0x80 returned 0 after 94 usecs
[    8.002115] calling  pt_dump_init+0x0/0x70 @ 1
[    8.006813] initcall pt_dump_init+0x0/0x70 returned 0 after 10 usecs
[    8.013489] calling  aes_init+0x0/0xf @ 1
[    8.017801] initcall aes_init+0x0/0xf returned 0 after 89 usecs
[    8.024027] calling  proc_execdomains_init+0x0/0x27 @ 1
[    8.029527] initcall proc_execdomains_init+0x0/0x27 returned 0 after 11 usecs
[    8.037042] calling  ioresources_init+0x0/0x44 @ 1
[    8.042082] initcall ioresources_init+0x0/0x44 returned 0 after 11 usecs
[    8.049131] calling  snapshot_device_init+0x0/0xf @ 1
[    8.054573] initcall snapshot_device_init+0x0/0xf returned 0 after 127 usecs
[    8.061974] calling  irq_pm_init_ops+0x0/0x11 @ 1
[    8.066931] initcall irq_pm_init_ops+0x0/0x11 returned 0 after 0 usecs
[    8.073790] calling  init_posix_timers+0x0/0x22b @ 1
[    8.079088] initcall init_posix_timers+0x0/0x22b returned 0 after 69 usecs
[    8.086310] calling  init_posix_cpu_timers+0x0/0x9b @ 1
[    8.091802] initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 0 usecs
[    8.099208] calling  timekeeping_init_ops+0x0/0x11 @ 1
[    8.104620] initcall timekeeping_init_ops+0x0/0x11 returned 0 after 0 usecs
[    8.111940] calling  init_clocksource_sysfs+0x0/0x58 @ 1
[    8.117728] initcall init_clocksource_sysfs+0x0/0x58 returned 0 after 199 usecs
[    8.125415] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    8.130991] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 6 usecs
[    8.138503] calling  alarmtimer_init+0x0/0x151 @ 1
[    8.143718] initcall alarmtimer_init+0x0/0x151 returned 0 after 172 usecs
[    8.150871] calling  clockevents_init_sysfs+0x0/0xa3 @ 1
[    8.157109] initcall clockevents_init_sysfs+0x0/0xa3 returned 0 after 645 usecs
[    8.164792] calling  init_tstats_procfs+0x0/0x30 @ 1
[    8.170025] initcall init_tstats_procfs+0x0/0x30 returned 0 after 6 usecs
[    8.177163] calling  futex_init+0x0/0xe6 @ 1
[    8.181654] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    8.188259] initcall futex_init+0x0/0xe6 returned 0 after 6460 usecs
[    8.194935] calling  proc_dma_init+0x0/0x27 @ 1
[    8.199709] initcall proc_dma_init+0x0/0x27 returned 0 after 6 usecs
[    8.206379] calling  proc_modules_init+0x0/0x27 @ 1
[    8.211506] initcall proc_modules_init+0x0/0x27 returned 0 after 6 usecs
[    8.218544] calling  kallsyms_init+0x0/0x2a @ 1
[    8.223303] initcall kallsyms_init+0x0/0x2a returned 0 after 7 usecs
[    8.229979] calling  pid_namespaces_init+0x0/0x32 @ 1
[    8.235332] initcall pid_namespaces_init+0x0/0x32 returned 0 after 37 usecs
[    8.242641] calling  ikconfig_init+0x0/0x41 @ 1
[    8.247414] initcall ikconfig_init+0x0/0x41 returned 0 after 6 usecs
[    8.254091] calling  audit_init+0x0/0xed @ 1
[    8.258578] audit: initializing netlink subsys (disabled)
[    8.264287] audit: type=2000 audit(1405366335.595:1): initialized
[    8.270680] initcall audit_init+0x0/0xed returned 0 after 11828 usecs
[    8.277448] calling  audit_watch_init+0x0/0x31 @ 1
[    8.282478] initcall audit_watch_init+0x0/0x31 returned 0 after 3 usecs
[    8.289440] calling  audit_tree_init+0x0/0x3b @ 1
[    8.294378] initcall audit_tree_init+0x0/0x3b returned 0 after 3 usecs
[    8.301246] calling  init_kprobes+0x0/0x177 @ 1
[    8.306447] initcall init_kprobes+0x0/0x177 returned 0 after 431 usecs
[    8.313323] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    8.318635] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 12 usecs
[    8.325966] calling  init_tracepoints+0x0/0x29 @ 1
[    8.331001] initcall init_tracepoints+0x0/0x29 returned 0 after 3 usecs
[    8.337958] calling  init_blk_tracer+0x0/0x56 @ 1
[    8.342896] initcall init_blk_tracer+0x0/0x56 returned 0 after 1 usecs
[    8.349768] calling  perf_event_sysfs_init+0x0/0x8f @ 1
[    8.356011] initcall perf_event_sysfs_init+0x0/0x8f returned 0 after 745 usecs
[    8.363604] calling  init_per_zone_wmark_min+0x0/0x9d @ 1
[    8.369293] initcall init_per_zone_wmark_min+0x0/0x9d returned 0 after 4 usecs
[    8.376884] calling  kswapd_init+0x0/0x1d @ 1
[    8.381618] initcall kswapd_init+0x0/0x1d returned 0 after 152 usecs
[    8.388296] calling  extfrag_debug_init+0x0/0x7b @ 1
[    8.393551] initcall extfrag_debug_init+0x0/0x7b returned 0 after 23 usecs
[    8.400769] calling  setup_vmstat+0x0/0xcf @ 1
[    8.405483] initcall setup_vmstat+0x0/0xcf returned 0 after 37 usecs
[    8.412163] calling  mm_compute_batch_init+0x0/0x51 @ 1
[    8.417658] initcall mm_compute_batch_init+0x0/0x51 returned 0 after 0 usecs
[    8.425065] calling  slab_proc_init+0x0/0x2a @ 1
[    8.429930] initcall slab_proc_init+0x0/0x2a returned 0 after 9 usecs
[    8.436702] calling  workingset_init+0x0/0x38 @ 1
[    8.441653] initcall workingset_init+0x0/0x38 returned 0 after 5 usecs
[    8.448505] calling  proc_vmalloc_init+0x0/0x2a @ 1
[    8.453637] initcall proc_vmalloc_init+0x0/0x2a returned 0 after 6 usecs
[    8.460683] calling  procswaps_init+0x0/0x27 @ 1
[    8.465532] initcall procswaps_init+0x0/0x27 returned 0 after 6 usecs
[    8.472299] calling  init_frontswap+0x0/0x84 @ 1
[    8.477179] initcall init_frontswap+0x0/0x84 returned 0 after 30 usecs
[    8.484032] calling  hugetlb_init+0x0/0x3d8 @ 1
[    8.488794] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.495540] initcall hugetlb_init+0x0/0x3d8 returned 0 after 6595 usecs
[    8.502503] calling  slab_proc_init+0x0/0x7 @ 1
[    8.507262] initcall slab_proc_init+0x0/0x7 returned 0 after 0 usecs
[    8.513940] calling  cpucache_init+0x0/0x40 @ 1
[    8.518698] initcall cpucache_init+0x0/0x40 returned 0 after 1 usecs
[    8.525371] calling  init_cleancache+0x0/0xa8 @ 1
[    8.530349] initcall init_cleancache+0x0/0xa8 returned 0 after 31 usecs
[    8.537304] calling  zs_init+0x0/0x90 @ 1
[    8.541511] initcall zs_init+0x0/0x90 returned 0 after 2 usecs
[    8.547640] calling  fcntl_init+0x0/0x2f @ 1
[    8.552159] initcall fcntl_init+0x0/0x2f returned 0 after 34 usecs
[    8.558665] calling  proc_filesystems_init+0x0/0x27 @ 1
[    8.564151] initcall proc_filesystems_init+0x0/0x27 returned 0 after 7 usecs
[    8.571563] calling  dio_init+0x0/0x32 @ 1
[    8.575892] initcall dio_init+0x0/0x32 returned 0 after 36 usecs
[    8.582198] calling  fsnotify_mark_init+0x0/0x46 @ 1
[    8.587486] initcall fsnotify_mark_init+0x0/0x46 returned 0 after 71 usecs
[    8.594720] calling  dnotify_init+0x0/0x7c @ 1
[    8.599479] initcall dnotify_init+0x0/0x7c returned 0 after 89 usecs
[    8.606165] calling  inotify_user_setup+0x0/0x50 @ 1
[    8.611429] initcall inotify_user_setup+0x0/0x50 returned 0 after 53 usecs
[    8.618649] calling  aio_setup+0x0/0x7e @ 1
[    8.623224] initcall aio_setup+0x0/0x7e returned 0 after 163 usecs
[    8.629724] calling  proc_locks_init+0x0/0x27 @ 1
[    8.634680] initcall proc_locks_init+0x0/0x27 returned 0 after 6 usecs
[    8.641550] calling  dquot_init+0x0/0x116 @ 1
[    8.646125] VFS: Disk quotas dquot_6.5.2
[    8.650418] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    8.657292] initcall dquot_init+0x0/0x116 returned 0 after 10915 usecs
[    8.664154] calling  init_v2_quota_format+0x0/0x1d @ 1
[    8.669557] initcall init_v2_quota_format+0x0/0x1d returned 0 after 1 usecs
[    8.676868] calling  quota_init+0x0/0x2e @ 1
[    8.681385] initcall quota_init+0x0/0x2e returned 0 after 26 usecs
[    8.687869] calling  init_devpts_fs+0x0/0x52 @ 1
[    8.692831] initcall init_devpts_fs+0x0/0x52 returned 0 after 111 usecs
[    8.699790] calling  init_hugetlbfs_fs+0x0/0x145 @ 1
[    8.705231] initcall init_hugetlbfs_fs+0x0/0x145 returned 0 after 225 usecs
[    8.712543] calling  init_fat_fs+0x0/0x4c @ 1
[    8.717212] initcall init_fat_fs+0x0/0x4c returned 0 after 78 usecs
[    8.723792] calling  init_vfat_fs+0x0/0xf @ 1
[    8.728364] initcall init_vfat_fs+0x0/0xf returned 0 after 1 usecs
[    8.734858] calling  init_msdos_fs+0x0/0xf @ 1
[    8.739531] initcall init_msdos_fs+0x0/0xf returned 0 after 1 usecs
[    8.746124] calling  init_iso9660_fs+0x0/0x69 @ 1
[    8.751135] initcall init_iso9660_fs+0x0/0x69 returned 0 after 64 usecs
[    8.758096] calling  init_nfs_fs+0x0/0x142 @ 1
[    8.763189] initcall init_nfs_fs+0x0/0x142 returned 0 after 421 usecs
[    8.769966] calling  init_nfs_v2+0x0/0x11 @ 1
[    8.774546] initcall init_nfs_v2+0x0/0x11 returned 0 after 1 usecs
[    8.781041] calling  init_nfs_v3+0x0/0x11 @ 1
[    8.785623] initcall init_nfs_v3+0x0/0x11 returned 0 after 1 usecs
[    8.792118] calling  init_nfs_v4+0x0/0x30 @ 1
[    8.796697] NFS: Registering the id_resolver key type
[    8.802011] Key type id_resolver registered
[    8.806414] Key type id_legacy registered
[    8.810629] initcall init_nfs_v4+0x0/0x30 returned 0 after 13618 usecs
[    8.817495] calling  init_nlm+0x0/0x3b @ 1
[    8.821805] initcall init_nlm+0x0/0x3b returned 0 after 11 usecs
[    8.828129] calling  init_nls_cp437+0x0/0x11 @ 1
[    8.832979] initcall init_nls_cp437+0x0/0x11 returned 0 after 1 usecs
[    8.839756] calling  init_nls_ascii+0x0/0x11 @ 1
[    8.844605] initcall init_nls_ascii+0x0/0x11 returned 0 after 0 usecs
[    8.851378] calling  init_nls_iso8859_1+0x0/0x11 @ 1
[    8.856591] initcall init_nls_iso8859_1+0x0/0x11 returned 0 after 0 usecs
[    8.863732] calling  init_nls_utf8+0x0/0x23 @ 1
[    8.868491] initcall init_nls_utf8+0x0/0x23 returned 0 after 1 usecs
[    8.875177] calling  init_ntfs_fs+0x0/0x1c9 @ 1
[    8.879942] ntfs: driver 2.1.30 [Flags: R/W].
[    8.881524] tsc: Refined TSC clocksource calibration: 3000.106 MHz
[    8.891208] initcall init_ntfs_fs+0x0/0x1c9 returned 0 after 11010 usecs
[    8.898251] calling  init_autofs4_fs+0x0/0x26 @ 1
[    8.903334] initcall init_autofs4_fs+0x0/0x26 returned 0 after 137 usecs
[    8.910392] calling  init_pstore_fs+0x0/0x41 @ 1
[    8.915260] initcall init_pstore_fs+0x0/0x41 returned 0 after 15 usecs
[    8.922127] calling  ipc_init+0x0/0x20 @ 1
[    8.926447] msgmni has been set to 1688
[    8.930504] initcall ipc_init+0x0/0x20 returned 0 after 3981 usecs
[    8.937012] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    8.941962] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 10 usecs
[    8.948926] calling  init_mqueue_fs+0x0/0x91 @ 1
[    8.953918] initcall init_mqueue_fs+0x0/0x91 returned 0 after 141 usecs
[    8.960858] calling  key_proc_init+0x0/0x64 @ 1
[    8.965636] initcall key_proc_init+0x0/0x64 returned 0 after 12 usecs
[    8.972407] calling  selinux_nf_ip_init+0x0/0x65 @ 1
[    8.977626] initcall selinux_nf_ip_init+0x0/0x65 returned 0 after 1 usecs
[    8.984762] calling  init_sel_fs+0x0/0x8b @ 1
[    8.989340] initcall init_sel_fs+0x0/0x8b returned 0 after 0 usecs
[    8.995836] calling  selnl_init+0x0/0x53 @ 1
[    9.000349] initcall selnl_init+0x0/0x53 returned 0 after 22 usecs
[    9.006855] calling  sel_netif_init+0x0/0x54 @ 1
[    9.011701] initcall sel_netif_init+0x0/0x54 returned 0 after 0 usecs
[    9.018482] calling  sel_netnode_init+0x0/0x5f @ 1
[    9.023510] initcall sel_netnode_init+0x0/0x5f returned 0 after 0 usecs
[    9.030470] calling  sel_netport_init+0x0/0x5f @ 1
[    9.035501] initcall sel_netport_init+0x0/0x5f returned 0 after 0 usecs
[    9.042455] calling  aurule_init+0x0/0x2d @ 1
[    9.047041] initcall aurule_init+0x0/0x2d returned 0 after 3 usecs
[    9.053550] calling  crypto_algapi_init+0x0/0xc @ 1
[    9.058685] initcall crypto_algapi_init+0x0/0xc returned 0 after 6 usecs
[    9.065732] calling  chainiv_module_init+0x0/0xf @ 1
[    9.070947] initcall chainiv_module_init+0x0/0xf returned 0 after 1 usecs
[    9.078092] calling  eseqiv_module_init+0x0/0xf @ 1
[    9.083225] initcall eseqiv_module_init+0x0/0xf returned 0 after 0 usecs
[    9.090269] calling  hmac_module_init+0x0/0xf @ 1
[    9.095222] initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
[    9.102076] calling  md5_mod_init+0x0/0xf @ 1
[    9.106740] initcall md5_mod_init+0x0/0xf returned 0 after 78 usecs
[    9.113335] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    9.118828] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 90 usecs
[    9.126245] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    9.131738] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 0 usecs
[    9.139133] calling  des_generic_mod_init+0x0/0x14 @ 1
[    9.144695] initcall des_generic_mod_init+0x0/0x14 returned 0 after 149 usecs
[    9.152209] calling  aes_init+0x0/0xf @ 1
[    9.156513] initcall aes_init+0x0/0xf returned 0 after 82 usecs
[    9.162737] calling  zlib_mod_init+0x0/0xf @ 1
[    9.167493] initcall zlib_mod_init+0x0/0xf returned 0 after 81 usecs
[    9.174169] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    9.180034] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 0 usecs
[    9.187808] calling  crypto_authenc_esn_module_init+0x0/0xf @ 1
[    9.194033] initcall crypto_authenc_esn_module_init+0x0/0xf returned 0 after 0 usecs
[    9.202175] calling  krng_mod_init+0x0/0xf @ 1
[    9.206952] initcall krng_mod_init+0x0/0xf returned 0 after 94 usecs
[    9.213628] calling  proc_genhd_init+0x0/0x44 @ 1
[    9.218583] initcall proc_genhd_init+0x0/0x44 returned 0 after 14 usecs
[    9.225531] calling  init_emergency_pool+0x0/0x53 @ 1
[    9.230850] bounce: pool size: 64 pages
[    9.234870] initcall init_emergency_pool+0x0/0x53 returned 0 after 3941 usecs
[    9.242372] calling  bsg_init+0x0/0x119 @ 1
[    9.246854] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    9.254634] initcall bsg_init+0x0/0x119 returned 0 after 7689 usecs
[    9.261209] calling  noop_init+0x0/0xf @ 1
[    9.265516] io scheduler noop registered
[    9.269638] initcall noop_init+0x0/0xf returned 0 after 4028 usecs
[    9.276139] calling  deadline_init+0x0/0xf @ 1
[    9.280809] io scheduler deadline registered
[    9.285304] initcall deadline_init+0x0/0xf returned 0 after 4392 usecs
[    9.292163] calling  cfq_init+0x0/0x89 @ 1
[    9.296545] io scheduler cfq registered (default)
[    9.301494] initcall cfq_init+0x0/0x89 returned 0 after 4911 usecs
[    9.307979] calling  percpu_counter_startup+0x0/0x35 @ 1
[    9.313574] initcall percpu_counter_startup+0x0/0x35 returned 0 after 1 usecs
[    9.321073] calling  audit_classes_init+0x0/0x4f @ 1
[    9.326307] initcall audit_classes_init+0x0/0x4f returned 0 after 11 usecs
[    9.333538] calling  phy_core_init+0x0/0x45 @ 1
[    9.338325] initcall phy_core_init+0x0/0x45 returned 0 after 30 usecs
[    9.345108] calling  pci_proc_init+0x0/0x64 @ 1
[    9.350090] initcall pci_proc_init+0x0/0x64 returned 0 after 212 usecs
[    9.356953] calling  pcie_portdrv_init+0x0/0x6f @ 1
[    9.362284] pcieport 0000:00:06.0: irq 24 for MSI/MSI-X
[    9.368026] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    9.373748] initcall pcie_portdrv_init+0x0/0x6f returned 0 after 11402 usecs
[    9.381157] calling  aer_service_init+0x0/0x28 @ 1
[    9.386239] initcall aer_service_init+0x0/0x28 returned 0 after 47 usecs
[    9.393282] calling  pci_hotplug_init+0x0/0x1e @ 1
[    9.398316] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.404170] initcall pci_hotplug_init+0x0/0x1e returned 0 after 5722 usecs
[    9.411398] calling  pcied_init+0x0/0x76 @ 1
[    9.416007] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    9.422965] initcall pcied_init+0x0/0x76 returned 0 after 6925 usecs
[    9.429656] calling  pcifront_init+0x0/0x41 @ 1
[    9.434420] initcall pcifront_init+0x0/0x41 returned -19 after 0 usecs
[    9.441290] calling  genericbl_driver_init+0x0/0x11 @ 1
[    9.446847] initcall genericbl_driver_init+0x0/0x11 returned 0 after 52 usecs
[    9.454357] calling  cirrusfb_init+0x0/0xaa @ 1
[    9.459187] initcall cirrusfb_init+0x0/0xaa returned 0 after 65 usecs
[    9.465968] calling  efifb_driver_init+0x0/0x11 @ 1
[    9.471137] initcall efifb_driver_init+0x0/0x11 returned 0 after 47 usecs
[    9.478267] calling  intel_idle_init+0x0/0x2ec @ 1
[    9.483292] initcall intel_idle_init+0x0/0x2ec returned -19 after 1 usecs
[    9.490430] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    9.496046] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 12 usecs
[    9.503640] calling  acpi_ac_init+0x0/0x25 @ 1
[    9.508386] initcall acpi_ac_init+0x0/0x25 returned 0 after 71 usecs
[    9.515063] calling  acpi_button_driver_init+0x0/0xf @ 1
[    9.521024] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    9.529801] ACPI: Power Button [PWRB]
[    9.534022] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    9.541810] ACPI: Power Button [PWRF]
[    9.545701] initcall acpi_button_driver_init+0x0/0xf returned 0 after 24480 usecs
[    9.553562] calling  acpi_fan_driver_init+0x0/0xf @ 1
[    9.558942] initcall acpi_fan_driver_init+0x0/0xf returned 0 after 52 usecs
[    9.566263] calling  acpi_processor_driver_init+0x0/0x3e @ 1
[    9.572285] ACPI: processor limited to max C-state 1
[    9.578284] initcall acpi_processor_driver_init+0x0/0x3e returned 0 after 5938 usecs
[    9.586434] calling  acpi_thermal_init+0x0/0x8c @ 1
[    9.594431] thermal LNXTHERM:00: registered as thermal_zone0
[    9.600391] ACPI: Thermal Zone [THRM] (30 C)
[    9.604942]9.612362] calling  acpi_battery_init+0x0/0x13 @ 1
[    9.617508] initcall acpi_battery_init+0x0/0x13 returned 0 after 17 usecs
[    9.617528] calling  1_acpi_battery_init_async+0x0/0x22 @ 6
[    9.617606] initcall 1_acpi_battery_init_async+0x0/0x22 returned 0 after 72 usecs
[    9.638357] calling  acpi_hed_driver_init+0x0/0xf @ 1
[    9.643733] initcall acpi_hed_driver_init+0x0/0xf returned 0 after 63 usecs
[    9.651058] calling  erst_init+0x0/0x2fa @ 1
[    9.655550] initcall erst_init+0x0/0x2fa returned 0 after 4 usecs
[    9.661968] calling  ghes_init+0x0/0x165 @ 1
[    9.666466] GHES: HEST is not enabled!
[    9.670415] initcall ghes_init+0x0/0x165 returned -22 after 3860 usecs
[    9.677278] calling  einj_init+0x0/0x4ef @ 1
[    9.681775] initcall einj_init+0x0/0x4ef returned -19 after 4 usecs
[    9.688377] calling  ioat_init_module+0x0/0xb0 @ 1
[    9.693420] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    9.699770] initcall ioat_init_module+0x0/0xb0 returned 0 after 6209 usecs
[    9.707001] calling  virtio_mmio_init+0x0/0x11 @ 1
[    9.712098] initcall virtio_mmio_init+0x0/0x11 returned 0 after 58 usecs
[    9.719143] calling  virtio_balloon_driver_init+0x0/0xf @ 1
[    9.725057] initcall virtio_balloon_driver_init+0x0/0xf returned 0 after 55 usecs
[    9.732936] calling  xenbus_probe_initcall+0x0/0x35 @ 1
[    9.738436] initcall xenbus_probe_initcall+0x0/0x35 returned -19 after 4 usecs
[    9.746034] calling  xenbus_init+0x0/0x37 @ 1
[    9.750628] initcall xenbus_init+0x0/0x37 returned -19 after 0 usecs
[    9.757311] calling  xenbus_backend_init+0x0/0x48 @ 1
[    9.762637] initcall xenbus_backend_init+0x0/0x48 returned -19 after 0 usecs
[    9.770058] calling  gntdev_init+0x0/0x48 @ 1
[    9.774651] initcall gntdev_init+0x0/0x48 returned -19 after 4 usecs
[    9.781340] calling  gntalloc_init+0x0/0x37 @ 1
[    9.786112] initcall gntalloc_init+0x0/0x37 returned -19 after 0 usecs
[    9.792985] calling  hypervisor_subsys_init+0x0/0x21 @ 1
[    9.798581] initcall hypervisor_subsys_init+0x0/0x21 returned -19 after 0 usecs
[    9.806267] calling  hyper_sysfs_init+0x0/0xcc @ 1
[    9.811322] initcall hyper_sysfs_init+0x0/0xcc returned -19 after 3 usecs
[    9.818468] calling  platform_pci_module_init+0x0/0x16 @ 1
[    9.824317] initcall platform_pci_module_init+0x0/0x16 returned 0 after 75 usecs
[    9.832096] calling  xen_pcibk_init+0x0/0x110 @ 1
[    9.837057] initcall xen_pcibk_init+0x0/0x110 returned -19 after 4 usecs
[    9.844114] calling  xen_acpi_processor_init+0x0/0x1f7 @ 1
[    9.849896] initcall xen_acpi_processor_init+0x0/0x1f7 returned -19 after 4 usecs
[    9.857781] calling  pty_init+0x0/0x3d9 @ 1
[    9.867628] kworker/u12:0 (662) used greatest stack depth: 6828 bytes left
[    9.874903] kworker/u12:0 (708) used greatest [    9.902507] kworker/u12:0 (945) used greatest stack depth: 6712 bytes left
[    9.924829] initcall pty_init+0x0/0x3d9 returncalling  sysrq_init+0x0/0xbe @ 1
[    9.935992] initcall sysrq_init+0x0/0xbe returned 0 after 9 usecs
[    9.942390] calling  xen_hvc_init+0x0/0x1d5 @ 1
[    9.947145] initcall xen_hvc_init+0x0/0x1d5 returned -19 after 0 usecs
[    9.953988] calling  serial8250_init+0x0/0x16d @ 1
[    9.959010] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.967300] initcall serial8250_init+0x0/0x16d returned 0 after 8102 usecs
[    9.974524] calling  serial_pci_driver_init+0x0/0x16 @ 1
[   10.000847] 0000:04:07.0: ttyS0 at I/O 0xe400 (irq = 15, base_baud = 115200) is a 16550A
[   10.009351] console [ttyS0] enabled
[   10.009351] console [ttyS0] enabled
[   10.016601] bootconsole [uart0] disabled
[   10.016601] bootconsole [uart0] disabled
[   10.025337] initcall serial_pci_driver_init+0x0/0x16 returned 0 after 44216 usecs
[   10.033050] calling  init_kgdboc+0x0/0x15 @ 1
[   10.037535] initcall init_kgdboc+0x0/0x15 returned 0 after 0 usecs
[   10.043899] calling  init+0x0/0xf3 @ 1
[   10.047907] initcall init+0x0/0xf3 returned 0 after 147 usecs
[   10.053827] calling  hpet_init+0x0/0x57 @ 1
[   10.058632] initcall hpet_init+0x0/0x57 returned 0 after 487 usecs
[   10.065000] calling  nvram_init+0x0/0x7e @ 1
[   10.069514] Non-volatile memory driver v1.3
[   10.073823] initcall nvram_init+0x0/0x7e returned 0 after 4329 usecs
[   10.080368] calling  mod_init+0x0/0x1b6 @ 1
[   10.084706] initcall mod_init+0x0/0x1b6 returned -19 after 31 usecs
[   10.091162] calling  mod_init+0x0/0x12d @ 1
[   10.095473] initcall mod_init+0x0/0x12d returned -19 after 5 usecs
[   10.101840] calling  mod_init+0x0/0x99 @ 1
[   10.106059] initcall mod_init+0x0/0x99 returned -19 after 3 usecs
[   10.112336] calling  mod_init+0x0/0x48 @ 1
[   10.116552] initcall mod_init+0x0/0x48 returned -19 after 0 usecs
[   10.122829] calling  rng_init+0x0/0xf @ 1
[   10.127111] initcall rng_init+0x0/0xf returned 0 after 152 usecs
[   10.133303] calling  agp_init+0x0/0x2f @ 1
[   10.137519] Linux agpgart interface v0.103
[   10.141735] initcall agp_init+0x0/0x2f returned 0 after 4119 usecs
[   10.148101] calling  agp_ali_init+0x0/0x24 @ 1
[   10.152743] initcall agp_ali_init+0x0/0x24 returned 0 after 67 usecs
[   10.159288] calling  agp_ati_init+0x0/0x24 @ 1
[   10.163928] initcall agp_ati_init+0x0/0x24 returned 0 after 65 usecs
[   10.170471] calling  agp_amdk7_init+0x0/0x24 @ 1
[   10.175299] initcall agp_amdk7_init+0x0/0x24 returned 0 after 74 usecs
[   10.182023] calling  agp_amd64_mod_init+0x0/0xa @ 1
[   10.187732] initcall agp_amd64_mod_init+0x0/0xa returned -19 after 673 usecs
[   10.194992] calling  agp_efficeon_init+0x0/0x39 @ 1
[   10.200079] initcall agp_efficeon_init+0x0/0x39 returned 0 after 65 usecs
[   10.207071] calling  agp_intel_init+0x0/0x24 @ 1
[   10.211893] initcall agp_intel_init+0x0/0x24 returned 0 after 68 usecs
[   10.218617] calling  agp_nvidia_init+0x0/0x24 @ 1
[   10.223523] initcall agp_nvidia_init+0x0/0x24 returned 0 after 61 usecs
[   10.230336] calling  agp_sis_init+0x0/0x24 @ 1
[   10.234979] initcall agp_sis_init+0x0/0x24 returned 0 after 67 usecs
[   10.241523] calling  agp_serverworks_init+0x0/0x24 @ 1
[   10.246878] initcall agp_serverworks_init+0x0/0x24 returned 0 after 65 usecs
[   10.254136] calling  agp_via_init+0x0/0x24 @ 1
[   10.258777] initcall agp_via_init+0x0/0x24 returned 0 after 67 usecs
[   10.265320] calling  drm_core_init+0x0/0x107 @ 1
[   10.270134] [drm] Initialized drm 1.1.0 20060810
[   10.274887] initcall drm_core_init+0x0/0x107 returned 0 after 4705 usecs
[   10.281788] calling  cn_proc_init+0x0/0x33 @ 1
[   10.286364] initcall cn_proc_init+0x0/0x33 returned 0 after 3 usecs
[   10.292818] calling  topology_sysfs_init+0x0/0x60 @ 1
[   10.298215] initcall topology_sysfs_init+0x0/0x60 returned 0 after 194 usecs
[   10.305475] calling  loop_init+0x0/0x12b @ 1
[   10.315970] loop: module loaded
[   10.319211] initcall loop_init+0x0/0x12b returned 0 after 9128 usecs
[   10.325761] calling  xen_blkif_init+0x0/0x21 @ 1
[   10.330514] initcall xen_blkif_init+0x0/0x21 returned -19 after 0 usecs
[   10.337325] calling  zram_init+0x0/0x2e9 @ 1
[   10.342547] zram: Created 1 device(s) ...
[   10.346678] initcall zram_init+0x0/0x2e9 returned 0 after 4842 usecs
[   10.353223] calling  mac_hid_init+0x0/0x1c @ 1
[   10.357812] initcall mac_hid_init+0x0/0x1c returned 0 after 10 usecs
[   10.364356] calling  macvlan_init_module+0x0/0x31 @ 1
[   10.369561] initcall macvlan_init_module+0x0/0x31 returned 0 after 2 usecs
[   10.376649] calling  macvtap_init+0x0/0xd0 @ 1
[   10.381262] initcall macvtap_init+0x0/0xd0 returned 0 after 37 usecs
[   10.387811] calling  net_olddevs_init+0x0/0x88 @ 1
[   10.392750] initcall net_olddevs_init+0x0/0x88 returned 0 after 2 usecs
[   10.399566] calling  fixed_mdio_bus_init+0x0/0xe3 @ 1
[   10.404965] libphy: Fixed MDIO Bus: probed
[   10.409181] initcall fixed_mdio_bus_init+0x0/0xe3 returned 0 after 4312 usecs
[   10.416533] calling  tun_init+0x0/0x8b @ 1
[   10.420753] tun: Universal TUN/TAP device driver, 1.6
[   10.425956] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.432454] initcall tun_init+0x0/0x8b returned 0 after 11437 usecs
[   10.438915] calling  tg3_driver_init+0x0/0x16 @ 1
[   10.443872] initcall tg3_driver_init+0x0/0x16 returned 0 after 108 usecs
[   10.450779] calling  ixgbevf_init_module+0x0/0x49 @ 1
[   10.455978] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver - version 2.12.1-k
[   10.465652] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   10.472038] initcall ixgbevf_init_module+0x0/0x49 returned 0 after 15698 usecs
[   10.479480] calling  forcedeth_pci_driver_init+0x0/0x16 @ 1
[   10.485282] initcall forcedeth_pci_driver_init+0x0/0x16 returned 0 after 64 usecs
[   10.492989] calling  netback_init+0x0/0x81 @ 1
[   10.497567] initcall netback_init+0x0/0x81 returned -19 after 0 usecs
[   10.504201] calling  fw_core_init+0x0/0xf1 @ 1
[   10.508968] initcall fw_core_init+0x0/0xf1 returned 0 after 184 usecs
[   10.515604] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[   10.520803] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 0 usecs
[   10.527884] calling  yenta_cardbus_driver_init+0x0/0x16 @ 1
[   10.533731] initcall yenta_cardbus_driver_init+0x0/0x16 returned 0 after 108 usecs
[   10.541524] calling  mon_init+0x0/0xe1 @ 1
[   10.545962] initcall mon_init+0x0/0xe1 returned 0 after 218 usecs
[   10.552240] calling  ehci_hcd_init+0x0/0x58 @ 1
[   10.556905] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.563625] initcall ehci_hcd_init+0x0/0x58 returned 0 after 6567 usecs
[   10.570437] calling  ehci_pci_init+0x0/0x60 @ 1
[   10.575100] ehci-pci: EHCI PCI platform driver
[   10.581451] IOAPIC[0]: Set routing entry (4-17 -> 0x61 -> IRQ 17 Mode:1 Active:1 Dest:15)
[   10.589887] QUIRK: Enable AMD PLL fix
[   10.593686] ehci-pci 0000:00:12.2: EHCI Host Controller
[   10.599349] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[   10.606974] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   10.615928] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[   10.623642] ehci-pci 0000:00:12.2: debug port 1
[   10.628440] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe6ff800
[   10.639895] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   10.646121] usb usb1: New USB device found, idVendor=1d6b, oduct=0002
[   10.653113] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.660548] usb usb1: Product: EHCI Host Controller
[   10.665567] usb usb1: Manufacturer: Linux 3.16.0-rc5upstream-01668-g6d2265b ehci_hcd
[   10.673537] usb usb1: SerialNumber: 0000:00:12.2
[   10.679236] hub 1-0:1.0: USB hub found
[   10.683155] hub 1-0:1.0: 6 ports detected
[   10.690402] IOAPIC[0]: Set routing entry (4-19 -> 0x71 -> IRQ 19 Mode:1 Active:1 Dest:15)
[   10.698862] ehci-pci 0000:00:13.2: EHCI Host Controller
[   10.704524] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[   10.712148] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   10.721103] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[   10.728818] ehci-pci 0000:00:13.2: debug port 1
[   10.733607] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe6ff400
[   10.744795] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   10.751004] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   10.757998] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.765431] usb usb2: Product: EHCI Host Controller
[   10.770450] usb usb2: Manufacturer: Linux 3.16.0-rc5upstream-01668-g6d2265b ehci_hcd
[   10.778420] usb usb2: SerialNumber: 0000:00:13.2
[   10.784099] hub 2-0:1.0: USB hub found
[   10.788032] hub 2-0:1.0: 6 ports detected
[   10.793565] initcall ehci_pci_init+0x0/0x60 returned 0 after 213543 usecs
[   10.800576] calling  ohci_hcd_mod_init+0x0/0x5e @ 1
[   10.805601] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.811985] initcall ohci_hcd_mod_init+0x0/0x5e returned 0 after 6238 usecs
[   10.819167] calling  ohci_pci_init+0x0/0x60 @ 1
[   10.823834] ohci-pci: OHCI PCI platform driver
[   10.830189] IOAPIC[0]: Set routing entry (4-16 -> 0x81 -> IRQ 16 Mode:1 Active:1 Dest:15)
[   10.838654] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   10.844671] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[   10.852428] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe6fe000
[   10.906982] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   10.913975] usb usb3: New USB device strings: Mupstream-01668-g6d2265b ohci_hcd
[   10.934761] usb usb3: SerialNumber: 0000:00:12.0
[   10.940477] hub 3-0:1.0: USB hub found
[   10.944420] hub 3-0:1.0: 3 ports detected
[   10.951199] ohci-pci 0000:00:12.1: OHCI PCI host controller
[   10.957230] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus number 4
[   10.964919] ohci-pci 0000:00:12.1: irq 16, io mem 0xfe6fd000
[   11.025872] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   11.032864] usb usb4: New USB device strings: M6d2265b ohci_hcd
[   11.053647] usb usb4: SerialNumber: 0000:00:12.1
[   11.059328] hub 4-0:1.0: USB hub found
[   11.063263] hub 4-0:1.0: 3 ports detected
[   11.070071] IOAPIC[0]: Set routing entry (4-18 -> 0x91 -> IRQ 18 Mode:1 Active:1 Dest:15)
[   11.078534] ohci-pci 0000:00:13ber 5
[   11.092315] ohci-pci 0000:00:13.0: irq 18, io mem 0xfe6fc000
[   11.146761] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   11.153753] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.161186] usb usb5: Product: OHCI PCI host controller
[   11.166563] usb usb5: Manufacturer: Linux 3.16.0-rc5upstream-01668-g6d2265b ohci_hcd
[   11.174533] usb usb5: SerialNumber: 0000:00:13.0
[   11.180241] hub 5-0:1.0: USB hub found
[   11.184185] hub 5-0:1.0: 3 ports detected
[   11.190978] ohci-pci 0000:00:13.1: OHCI PCI host controller
[   11.197002] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 6
[   11.204693] ohci-pci 0000:00:13.1: irq 18, io mem 0xfe6f7000
[   11.265643] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   11.272636] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.280069] usb usb6: Product: OHCI PCI host controller
[   11.285447] usb usb6: Manufacturer: Linux 3.16.0-rc5upstream-01668-g6d2265b ohci_hcd
[   11.293417] usb usb6: SerialNumber: 0000:00:13.1
[   11.299103] hub 6-0:1.0: USB hub found
[   11.303034] hub 6-0:1.0: 3 ports detected
[   11.309824] ohci-pci 0000:00:14.5: OHCI PCI host controller
[   11.315848] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 7
[   11.323554] ohci-pci 0000:00:14.5: irq 18, io mem 0xfe6f6000
[   11.378556] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   11.385566] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.393017] usb usb7: Product: OHCI PCI host controller
[   11.398396] usb usb7: Manufacturer: Linux 3.16.0-rc5upstream-01668-g6d2265b ohci_hcd
[   11.406371] usb usb7: SerialNumber: 0000:00:14.5
[   11.412079] hub 7-0:1.0: USB hub found
[   11.416009] hub 7-0:1.0: 2 ports detected
[   11.420944] initcall ohci_pci_init+0x0/0x60 returned 0 after 583665 usecs
[   11.427943] calling  uhci_hcd_init+0x0/0xa4 @ 1
[   11.432604] uhci_hcd: USB Universal Host Controller Interface driver
[   11.439293] initcall uhci_hcd_init+0x0/0xa4 returned 0 after 6537 usecs
[   11.446104] calling  usblp_driver_init+0x0/0x16 @ 1
[   11.451229] usbcore: registered new interface driver usblp
[   11.456874] initcall usblp_driver_init+0x0/0x16 returned 0 after 5620 usecs
[   11.464047] calling  kgdbdbgp_start_thread+0x0/0x57 @ 1
[   11.469426] initcall kgdbdbgp_start_thread+0x0/0x57 returned 0 after 0 usecs
[   11.476685] calling  i8042_init+0x0/0x3b7 @ 1
[   11.481321] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   11.488819] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.493942] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.499179] initcall i8042_init+0x0/0x3b7 returned 0 after 17602 usecs
[   11.505905] calling  serport_init+0x0/0x2e @ 1
[   11.510483] initcall serport_init+0x0/0x2e returned 0 after 0 usecs
[   11.516940] calling  mousedev_init+0x0/0x54 @ 1
[   11.521820] mousedev: PS/2 mouse device common for all mice
[   11.527579] initcall mousedev_init+0x0/0x54 returned 0 after 5835 usecs
[   11.534400] calling  evdev_init+0x0/0xf @ 1
[   11.539012] initcall evdev_init+0x0/0xf returned 0 after 297 usecs
[   11.545428] calling  atkbd_init+0x0/0x20 @ 1
[   11.549910] initcall atkbd_init+0x0/0x20 returned 0 after 82 usecs
[   11.556284] calling  psmouse_init+0x0/0x8a @ 1
[   11.561070] initcall psmouse_init+0x0/0x8a returned 0 after 205 usecs
[   11.567717] calling  cmos_init+0x0/0x66 @ 1
[   11.572071] rtc_cmos 00:01: RTC can wake from S4
[   11.577265] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[   11.583588] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   11.591506] initcall cmos_init+0x0/0x66 returned 0 after 19046 usecs
[   11.598051] calling  i2c_i801_init+0x0/0x92 @ 1
[   11.602828] initcall i2c_i801_init+0x0/0x92 returned 0 after 111 usecs
[   11.609552] calling  cpufreq_gov_dbs_init+0x0/0xf @ 1
[   11.614752] initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 0 usecs
[   11.621834] calling  efivars_sysfs_init+0x0/0x1d0 @ 1
[   11.627033] initcall efivars_sysfs_init+0x0/0x1d0 returned -19 after 0 usecs
[   11.634293] calling  efivars_pstore_init+0x0/0x89 @ 1
[   11.639492] initcall efivars_pstore_init+0x0/0x89 returned 0 after 0 usecs
[   11.646574] calling  vhost_net_init+0x0/0x20 @ 1
[   11.651449] initcall vhost_net_init+0x0/0x20 returned 0 after 120 usecs
[   11.658270] calling  vhost_init+0x0/0x7 @ 1
[   11.662576] initcall vhost_init+0x0/0x7 returned 0 after 0 usecs
[   11.668762] calling  staging_init+0x0/0x7 @ 1
[   11.673246] initcall staging_init+0x0/0x7 returned 0 after 0 usecs
[   11.679611] calling  eeepc_laptop_init+0x0/0x4f @ 1
[   11.684804] initcall eeepc_laptop_init+0x0/0x4f returned -19 after 169 usecs
[   11.692066] calling  sock_diag_init+0x0/0xf @ 1
[   11.696745] initcall sock_diag_init+0x0/0xf returned 0 after 16 usecs
[   11.703379] calling  llc_init+0x0/0x1b @ 1
[   11.707594] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[   11.713691] calling  snap_init+0x0/0x35 @ 1
[   11.717998] initcall snap_init+0x0/0x35 returned 0 after 2 usecs
[   11.724184] calling  blackhole_module_init+0x0/0xf @ 1
[   11.729473] initcall blackhole_module_init+0x0/0xf returned 0 after 0 usecs
[   11.736643] calling  nfnetlink_init+0x0/0x4b @ 1
[   11.741395] Netfilter messages via NETLINK v0.30.
[   11.746248] initcall nfnetlink_init+0x0/0x4b returned 0 after 4743 usecs
[   11.753151] calling  nfnetlink_log_init+0x0/0x8f @ 1
[   11.758271] initcall nfnetlink_log_init+0x0/0x8f returned 0 after 10 usecs
[   11.765353] calling  nf_conntrack_standalone_init+0x0/0x70 @ 1
[   11.771358] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   11.777863] initcall nf_conntrack_standalone_init+0x0/0x70 returned 0 after 6358 usecs
[   11.786017] calling  ctnetlink_init+0x0/0x92 @ 1
[   11.790769] ctnetlink v0.93: registering with nfnetlink.
[   11.796237] initcall ctnetlink_init+0x0/0x92 returned 0 after 5344 usecs
[   11.803141] calling  nf_conntrack_ftp_init+0x0/0x195 @ 1
[   11.808613] initcall nf_conntrack_ftp_init+0x0/0x195 returned 0 after 3 usecs
[   11.815964] calling  nf_conntrack_irc_init+0x0/0x148 @ 1
[   11.821438] initcall nf_conntrack_irc_init+0x0/0x148 returned 0 after 5 usecs
[   11.828788] calling  nf_conntrack_sip_init+0x0/0x1e4 @ 1
[   11.834255] initcall nf_conntrack_sip_init+0x0/0x1e4 returned 0 after 0 usecs
[   11.841603] calling  xt_init+0x0/0xb5 @ 1
[   11.845735] initcall xt_init+0x0/0xb5 returned 0 after 4 usecs
[   11.851742] calling  tcpudp_mt_init+0x0/0x14 @ 1
[   11.856494] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 0 usecs
[   11.863129] calling  connsecmark_tg_init+0x0/0xf @ 1
[   11.868238] initcall connsecmark_tg_init+0x0/0xf returned 0 after 0 usecs
[   11.875229] calling  nflog_tg_init+0x0/0xf @ 1
[   11.879803] initcall nflog_tg_init+0x0/0xf returned 0 after 0 usecs
[   11.886257] calling  secmark_tg_init+0x0/0xf @ 1
[   11.891009] initcall secmark_tg_init+0x0/0xf returned 0 after 0 usecs
[   11.897642] calling  tcpmss_tg_init+0x0/0x14 @ 1
[   11.902393] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 0 usecs
[   11.909026] calling  conntrack_mt_init+0x0/0x14 @ 1
[   11.914046] initcall conntrack_mt_init+0x0/0x14 returned 0 after 0 usecs
[   11.920948] calling  policy_mt_init+0x0/0x14 @ 1
[   11.925699] initcall policy_mt_init+0x0/0x14 returned 0 after 0 usecs
[   11.932332] calling  state_mt_init+0x0/0xf @ 1
[   11.936905] initcall state_mt_init+0x0/0xf returned 0 after 0 usecs
[   11.943358] calling  gre_offload_init+0x0/0x14 @ 1
[   11.948289] initcall gre_offload_init+0x0/0x14 returned 0 after 0 usecs
[   11.955101] calling  sysctl_ipv4_init+0x0/0x44 @ 1
[   11.960074] initcall sysctl_ipv4_init+0x0/0x44 returned 0 after 41 usecs
[   11.966973] calling  tunnel4_init+0x0/0x6d @ 1
[   11.971549] initcall tunnel4_init+0x0/0x6d returned 0 after 0 usecs
[   11.978003] calling  ipv4_netfilter_init+0x0/0xf @ 1
[   11.983112] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 0 usecs
[   11.990103] calling  nf_conntrack_l3proto_ipv4_init+0x0/0x150 @ 1
[   11.996577] initcall nf_conntrack_l3proto_ipv4_init+0x0/0x150 returned 0 after 197 usecs
[   12.004909] calling  nf_defrag_init+0x0/0x14 @ 1
[   12.009661] initcall nf_defrag_init+0x0/0x14 returned 0 after 0 usecs
[   12.016292] calling  ip_tables_init+0x0/0x8f @ 1
[   12.021063] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.026531] initcall ip_tables_init+0x0/0x8f returned 0 after 5364 usecs
[   12.033431] calling  iptable_filter_init+0x0/0x40 @ 1
[   12.038727] initcall iptable_filter_init+0x0/0x40 returned 0 after 93 usecs
[   12.045896] calling  iptable_mangle_init+0x0/0x40 @ 1
[   12.051169] initcall iptable_mangle_init+0x0/0x40 returned 0 after 71 usecs
[   12.058339] calling  reject_tg_init+0x0/0xf @ 1
[   12.062999] initcall reject_tg_init+0x0/0xf returned 0 after 0 usecs
[   12.069543] calling  ulog_tg_init+0x0/0x74 @ 1
[   12.074139] initcall ulog_tg_init+0x0/0x74 returned 0 after 19 usecs
[   12.080682] calling  cubictcp_register+0x0/0x72 @ 1
[   12.085700] TCP: cubic registered
[   12.089111] initcall cubictcp_register+0x0/0x72 returned 0 after 3333 usecs
[   12.096279] calling  xfrm_user_init+0x0/0x43 @ 1
[   12.101030] Initializing XFRM netlink socket
[   12.105441] initcall xfrm_user_init+0x0/0x43 returned 0 after 4310 usecs
[   12.112341] calling  inet6_init+0x0/0x2c3 @ 1
[   12.117051] NET: Registered protocol family 10
[   12.122382] initcall inet6_init+0x0/0x2c3 returned 0 after 5433 usecs
[   12.129017] calling  ah6_init+0x0/0x75 @ 1
[   12.133234] initcall ah6_init+0x0/0x75 returned 0 after 1 usecs
[   12.139331] calling  esp6_init+0x0/0x75 @ 1
[   12.143636] initcall esp6_init+0x0/0x75 returned 0 after 0 usecs
[   12.149821] calling  xfrm6_transport_init+0x0/0x14 @ 1
[   12.155110] initcall xfrm6_transport_init+0x0/0x14 returned 0 after 0 usecs
[   12.162279] calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
[   12.167745] initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after 0 usecs
[   12.175093] calling  xfrm6_beet_init+0x0/0x14 @ 1
[   12.179933] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 0 usecs
[   12.186656] calling  ip6_tables_init+0x0/0x8f @ 1
[   12.191518] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.197075] initcall ip6_tables_init+0x0/0x8f returned 0 after 5450 usecs
[   12.204066] calling  ip6table_filter_init+0x0/0x40 @ 1
[   12.209511] initcall ip6table_filter_init+0x0/0x40 returned 0 after 152 usecs
[   12.216860] calling  ip6table_mangle_init+0x0/0x40 @ 1
[   12.222299] initcall ip6table_mangle_init+0x0/0x40 returned 0 after 147 usecs
[   12.229649] calling  nf_conntrack_l3proto_ipv6_init+0x0/0x129 @ 1
[   12.235934] initcall nf_conntrack_l3proto_ipv6_init+0x0/0x129 returned 0 after 11 usecs
[   12.244176] calling  nf_defrag_init+0x0/0x4c @ 1
[   12.248950] initcall nf_defrag_init+0x0/0x4c returned 0 after 23 usecs
[   12.255673] calling  ipv6header_mt6_init+0x0/0xf @ 1
[   12.260782] initcall ipv6header_mt6_init+0x0/0xf returned 0 after 0 usecs
[   12.267771] calling  reject_tg6_init+0x0/0xf @ 1
[   12.272522] initcall reject_tg6_init+0x0/0xf returned 0 after 0 usecs
[   12.279155] calling  sit_init+0x0/0xbc @ 1
[   12.283370] sit: IPv6 over IPv4 tunneling driver
[   12.289039] initcall sit_init+0x0/0xbc returned 0 after 5540 usecs
[   12.295406] calling  packet_init+0x0/0x39 @ 1
[   12.299888] NET: Registered protocol family 17
[   12.304468] initcall packet_init+0x0/0x39 returned 0 after 4476 usecs
[   12.311100] calling  br_init+0x0/0x90 @ 1
[   12.315274] initcall br_init+0x0/0x90 returned 0 after 47 usecs
[   12.321372] calling  init_rpcsec_gss+0x0/0x54 @ 1
[   12.326282] initcall init_rpcsec_gss+0x0/0x54 returned 0 after 66 usecs
[   12.333096] calling  dcbnl_init+0x0/0x5e @ 1
[   12.337490] initcall dcbnl_init+0x0/0x5e returned 0 after 0 usecs
[   12.343766] calling  init_dns_resolver+0x0/0xcd @ 1
[   12.348798] Key type dns_resolver registered
[   12.353193] initcall init_dns_resolver+0x0/0xcd returned 0 after 4307 usecs
[   12.360364] calling  mcheck_init_device+0x0/0x174 @ 1
[   12.366439] initcall mcheck_init_device+0x0/0x174 returned 0 after 857 usecs
[   12.373749] calling  mcheck_debugfs_init+0x0/0x3e @ 1
[   12.378970] initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 19 usecs
[   12.386139] calling  severities_debugfs_init+0x0/0x3e @ 1
[   12.391701] initcall severities_debugfs_init+0x0/0x3e returned 0 after 5 usecs
[   12.399143] calling  threshold_init_device+0x0/0x44 @ 1
[   12.405009] initcall threshold_init_device+0x0/0x44 returned 0 after 475 usecs
[   12.412447] calling  hpet_insert_resource+0x0/0x1e @ 1
[   12.417737] initcall hpet_insert_resource+0x0/0x1e returned 0 after 0 usecs
[   12.424909] calling  update_mp_table+0x0/0x527 @ 1
[   12.429840] initcall update_mp_table+0x0/0x527 returned 0 after 0 usecs
[   12.436653] calling  lapic_insert_resource+0x0/0x46 @ 1
[   12.442032] initcall lapic_insert_resource+0x0/0x46 returned 0 after 0 usecs
[   12.449293] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   12.454582] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 usecs
[   12.461752] calling  print_ICs+0x0/0x437 @ 1
[   12.466146] 
[   12.466146] printing PIC contents
[   12.471079] ... PIC  IMR: ffff
[   12.474220] ... PIC  IRR: 0001
[   12.477365] ... PIC  ISR: 0000
[   12.480509] ... PIC ELCR: ce90
[   12.483659] printing local APIC contents on CPU#0/0:
[   12.488768] ... APIC ID:      00000000 (0)
[   12.492981] ... APIC VERSION: 80050010
[   12.496835] ... APIC TASKPRI: 00000000 (00)
[   12.501137] ... APIC ARBPRI: 00000030 (30)
[   12.505348] ... APIC PROCPRI: 00000000
[   12.509202] ... APIC LDR: 01000000
[   12.512698] ... APIC DFR: ffffffff
[   12.516194] ... APIC SPIV: 000001ff
[   12.519781] ... APIC ISR field:
[   12.523011] 0000000000000000000000000000000000000000000000000000000000000000
[   12.530329] ... APIC TMR field:
[   12.533556] 0000000000000000000000000000000000000000000000000000000000000000
[   12.540877] ... APIC IRR field:
[   12.544104] 0000000000010000000000000000000000000000000000000000000000000000
[   12.551424] ... APIC ESR: 00000000
[   12.554922] ... APIC ICR: 000208ef
[   12.558420] ... APIC ICR2: 0a000000
[   12.562005] ... APIC LVTT: 000000ef
[   12.565592] ... APIC LVTPC: 00000400
[   12.569267] ... APIC LVT0: 00010700
[   12.572853] ... APIC LVT1: 00000400
[   12.576440] ... APIC LVTERR: 000000fe
[   12.580204] ... APIC TMICT: 00000000
[   12.583880] ... APIC TMCCT: 00000000
[   12.587554] ... APIC TDCR: 00000003
[   12.591141] ... APIC EFEAT: 00040007
[   12.594816] ... APIC ECTRL: 00000000
[   12.598490] ... APIC EILVT0: 000000f9
[   12.602256] ... APIC EILVT1: 00000400
[   12.606022] ... APIC EILVT2: 00010000
[   12.609786] ... APIC EILVT3: 00010000
[   12.613550] 
[   12.615081] number of MP IRQ sources: 15.
[   12.619207] number of IO-APIC #4 registers: 24.
[   12.623868] testing the IO APIC.......................
[   12.629159] IO APIC #4......
[   12.632123] .... register #00: 04000000
[   12.636070] .......    : physical APIC id: 04
[   12.640553] .......    : Delivery Type: 0
[   12.644679] .......    : LTS          : 0
[   12.648804] .... register #01: 00178021
[   12.652749] .......     : max redirection entries: 17
[   12.657946] .......     : PRQ implemented: 1
[   12.662338] .......     : IO APIC version: 21
[   12.666822] .... register #02: 04000000
[   12.670769] .......     : arbitration: 04
[   12.674902] .... register #03: 04178021
[   12.678850] .......     : Boot DT    : 1
[   12.682890] .... IRQ redirection table:
[   12.686840] 1    0    0   0   0    0    0    00
[   12.691505] 0    0    0   0   0    1    1    31
[   12.696170] 0    0    0   0   0    1    1    30
[   12.700833] 0    0    0   0   0    1    1    33
[   12.705498] 0    0    0   0   0    1    1    34
[   12.710163] 0    0    0   0   0    1    1    35
[   12.714827] 0    0    0   0   0    1    1    36
[   12.719492] 0    0    0   0   0    1    1    37
[   12.724156] 0    0    0   0   0    1    1    38
[   12.728821] 0    1    0   1   0    1    1    39
[   12.733484] 0    0    0   0   0    1    1    3A
[   12.738148] 0    0    0   0   0    1    1    3B
[   12.742814] 0    0    0   0   0    1    1    3C
[   12.747479] 0    0    0   0   0    1    1    3D
[   12.752142] 0    0    0   0   0    1    1    3E
[   12.756809] 0    0    0   0   0    1    1    3F
[   12.761472] 0    1    0   1   0    1    1    81
[   12.766138] 0    1    0   1   0    1    1    61
[   12.770801] 0    1    0   1   0    1    1    91
[   12.775466] 0    1    0   1   0    1    1    71
[   12.780131] 1    0    0   0   0    0    0    00
[   12.784803] 1    0    0   0   0    0    0    00
[   12.789466] 1    0    0   0   0    0    0    00
[   12.794129] 1    0    0   0   0    0    0    00
[   12.798790] IRQ to pin mappings:
[   12.802111] IRQ0 -> 0:2
[   12.804643] IRQ1 -> 0:1
[   12.807177] IRQ3 -> 0:3
[   12.809707] IRQ4 -> 0:4
[   12.812243] IRQ5 -> 0:5
[   12.814777] IRQ6 -> 0:6
[   12.817309] IRQ7 -> 0:7
[   12.819840] IRQ8 -> 0:8
[   12.822375] IRQ9 -> 0:9
[   12.824908] IRQ10 -> 0:10
[   12.827617] IRQ11 -> 0:11
[   12.830329] IRQ12 -> 0:12
[   12.833040] IRQ13 -> 0:13
[   12.835754] IRQ14 -> 0:14
[   12.838463] IRQ15 -> 0:15
[   12.841175] IRQ16 -> 0:16
[   12.843886] IRQ17 -> 0:17
[   12.846599] IRQ18 -> 0:18
[   12.849311] IRQ19 -> 0:19
[   12.852025] .................................... done.
[   12.857312] initcall print_ICs+0x0/0x437 returned 0 after 382357 usecs
[   12.864037] calling  print_ipi_mode+0x0/0x2e @ 1
[   12.868787] Using IPI No-Shortcut mode
[   12.872645] initcall print_ipi_mode+0x0/0x2e returned 0 after 3769 usecs
[   12.879547] calling  pat_memtype_list_init+0x0/0x37 @ 1
[   12.884931] initcall pat_memtype_list_init+0x0/0x37 returned 0 after 6 usecs
[   12.892193] calling  init_oops_id+0x0/0x50 @ 1
[   12.896767] initcall init_oops_id+0x0/0x50 returned 0 after 1 usecs
[   12.903222] calling  pm_qos_power_init+0x0/0x5d @ 1
[   12.908597] initcall pm_qos_power_init+0x0/0x5d returned 0 after 347 usecs
[   12.915688] calling  pm_debugfs_init+0x0/0x2a @ 1
[   12.920537] initcall pm_debugfs_init+0x0/0x2a returned 0 after 8 usecs
[   12.927260] calling  printk_late_init+0x0/0x38 @ 1
[   12.932193] initcall printk_late_init+0x0/0x38 returned 0 after 0 usecs
[   12.939005] calling  tk_debug_sleep_time_init+0x0/0x41 @ 1
[   12.944657] initcall tk_debug_sleep_time_init+0x0/0x41 returned 0 after 6 usecs
[   12.952184] calling  debugfs_kprobe_init+0x0/0xa6 @ 1
[   12.957411] initcall debugfs_kprobe_init+0x0/0xa6 returned 0 after 26 usecs
[   12.964580] calling  taskstats_init+0x0/0x6e @ 1
[   12.969347] registered taskstats version 1
[   12.973563] initcall taskstats_init+0x0/0x6e returned 0 after 4136 usecs
[   12.980464] calling  clear_boot_tracer+0x0/0x2d @ 1
[   12.985482] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[   12.992383] calling  kdb_ftrace_register+0x0/0x35 @ 1
[   12.997585] initcall kdb_ftrace_register+0x0/0x35 returned 0 after 3 usecs
[   13.004665] calling  fault_around_debugfs+0x0/0x3a @ 1
[   13.009958] initcall fault_around_debugfs+0x0/0x3a returned 0 after 6 usecs
[   13.017128] calling  max_swapfiles_check+0x0/0x7 @ 1
[   13.022237] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 usecs
[   13.029228] calling  set_recommended_min_free_kbytes+0x0/0xb0 @ 1
[   13.035501] initcall set_recommended_min_free_kbytes+0x0/0xb0 returned 0 after 1 usecs
[   13.043656] calling  kmemleak_late_init+0x0/0x8e @ 1
[   13.048817] kmemleak: Kernel memory leak detector initialized
[   13.048820] kmemleak: Automatic memory scanning thread started
[   13.060737] initcall kmemleak_late_init+0x0/0x8e returned 0 after 11702 usecs
[   13.068087] calling  check_early_ioremap_leak+0x0/0x5d @ 1
[   13.073735] initcall check_early_ioremap_leak+0x0/0x5d returned 0 after 0 usecs
[   13.081264] calling  init_root_keyring+0x0/0xa @ 1
[   13.086218] initcall init_root_keyring+0x0/0xa returned 0 after 22 usecs
[   13.093120] calling  fail_make_request_debugfs+0x0/0x23 @ 1
[   13.098900] initcall fail_make_request_debugfs+0x0/0x23 returned 0 after 43 usecs
[   13.106607] calling  prandom_reseed+0x0/0x3e @ 1
[   13.111372] initcall prandom_reseed+0x0/0x3e returned 0 after 13 usecs
[   13.118097] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   13.124557] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 6 usecs
[   13.132889] calling  pci_sysfs_init+0x0/0x44 @ 1
[   13.138936] initcall pci_sysfs_init+0x0/0x44 returned 0 after 1264 usecs
[   13.145838] calling  boot_wait_for_devices+0x0/0x28 @ 1
[   13.151217] initcall boot_wait_for_devices+0x0/0x28 returned -19 after 0 usecs
[   13.158656] calling  deferred_probe_initcall+0x0/0x80 @ 1
[   13.164312] initcall deferred_probe_initcall+0x0/0x80 returned 0 after 96 usecs
[   13.171846] calling  late_resume_init+0x0/0x190 @ 1
[   13.176873]   Magic number: 6:551:546
[   13.180733] mem null: hash matches
[   13.184263] initcall late_resume_init+0x0/0x190 returned 0 after 7222 usecs
[   13.191438] calling  firmware_memmap_init+0x0/0x29 @ 1
[   13.197035] initcall firmware_memmap_init+0x0/0x29 returned 0 after 296 usecs
[   13.204394] calling  pci_mmcfg_late_insert_resources+0x0/0x43 @ 1
[   13.210673] initcall pci_mmcfg_late_insert_resources+0x0/0x43 returned 0 after 0 usecs
[   13.218831] calling  tcp_congestion_default+0x0/0xf @ 1
[   13.224214] initcall tcp_congestion_default+0x0/0xf returned 0 after 0 usecs
[   13.231477] calling  ip_auto_config+0x0/0xeb7 @ 1
[   13.236331] initcall ip_auto_config+0x0/0xeb7 returned 0 after 8 usecs
[   13.243058] calling  software_resume+0x0/0x280 @ 1
[   13.247994] PM: Hibernation image not present or could not be loaded.
[   13.254630] initcall software_resume+0x0/0x280 returned -2 after 6486 usecs
[   13.262028] async_waiting @ 1
[   13.265106] async_continuing @ 1 after 0 usec
[   13.269892] Freeing unused kernel memory: 940K (c185e000 - c1949000)
[   13.276482] Write protecting the kernel text: 6272k
[   13.281547] Write protecting the kernel read-only data: 1856k
[   13.287477] NX-protecting the kernel data: 3968k
[   13.295666] consoletype (1261) used greatest stack depth: 6452 bytes left
[   13.305313] random: nonblocking pool is initialized
[   13.421749] rm (1276) used greatest stack depth: 6436 bytes left
[   13.450879] udevd (1297): /proc/1297/oom_adj is deprecated, please use /proc/1297/oom_score_adj instead.
[   13.487357] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 1354
[   13.494627] calling  acpi_wmi_init+0x0/0x1000 [wmi] @ 1371
[   13.494659] acpi-cpufreq: overriding BIOS provided _PSD data
[   13.506811] wmi: Mapper loaded
[   13.507231] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returned 0 after 12765 usecs
[   13.507366] calling  init_scsi+0x0/0x90 [scsi_mod] @ 1390
[   13.524303] initcall acpi_wmi_init+0x0/0x1000 [wmi] returned 0 after 17774 usecs
[   13.524388] modprobe (1354) used greatest stack depth: 6396 bytes left
[   13.539915] SCSI subsystem initialized
[   13.543782] initcall init_scsi+0x0/0x90 [scsi_mod] returned 0 after 35589 usecs
[   13.556262] calling  ata_init+0x0/0x295 [libata] @ 1385
[   13.562131] calling  skge_init_module+0x0/0x1000 [skge] @ 1500
[] skge: 1.14 addr 0xfebfc000 irq 4 chip Yukon rev 1
[   13.568573] calling  drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] @ 1505
[   13.584276] skge 0000:04:05.0 eth0: addr 00:0a:5e:5c:f5:72
[   13.594109] calling  rtl8169_pci_driver_init+0x0/0x1000 [r8169] @ 1395
[   13.595012] initcall skge_init_module+0x0/0x1000 [13.608889] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   13.608943] modprobe (1500) used greatest stack depth: 6336 bytes left
[   13.611922] libata version 3.00 loaded.
[   13.611932] initcall ata_init+0x0/0x295 [libata] returned 0 after 49141 usecs
[   13.632707] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[   13.640595] r8169 0000:02:00.0: irq 26 for MSI/MSI-X
[   13.640738] calling  ata_generic_pci_driver_init+0x0/0x1000 [ata_generic] @ 1385
[   13.640967] initcall ata_generic_pci_driver_init+0x0/0x1000 [ata_generic] returned 0 after 221 usecs
[   13.663674] calling  ahci_pci_driver_init+0x0/0x1000 [ahci] @ 1390
[   13.665004] r8169 0000:02:00.0 eth1: RTL8168c/8111c at 0xf844e000, 00:25:11:18:a1:2e, XID 1c4000c0 IRQ 26
[   13.665006] r8169 0000:02:00.0 eth1: jumbo features [frames: 6128 bytes, tx checksumming: ko]
[   13.665177] initcall rtl8169_pci_driver_init+0x0/0x1000 [r8169] returned 0 after 55100 usecs
[   13.697427] ahci 0000:00:11.0: version 3.0
[   13.697537] modprobe (1395) used greatest stack depth: 6120 bytes left
[   13.708646] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   13.717072] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[   13.736190] scsi0 : ahci
[   13.740271] scsi1 : ahci
[   13.746654] scsi2 : ahci
[   13.749815] initcall drm_fb_helper_modinit+0x0/0x1000 [drm_kms_helper] returned 0 after 177152 usecs
[   13.750607] scsi3 : ahci
[   13.751945] scsi4 : ahci
[   13.753495] scsi5 : ahci
[   13.754298] ata1: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd00 irq 15
[   13.754301] ata2: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffd80 irq 15
[   13.754304] ata3: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe00 irq 15
[   13.754306] ata4: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6ffe80 irq 15
[   13.754309] ata5: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff00 irq 15
[   13.754312] ata6: SATA max UDMA/133 abar m1024@0xfe6ffc00 port 0xfe6fff80 irq 15
[   13.754467] ahci 0000:03:00.0: JMB361 has only one port
[   13.754478] ahci 0000:03:00.0: forcing port_map 0x3 -> 0x1
[   13.754576] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
[   13.754578] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio 
[   13.757281] scsi6 : ahci
[   13.758602] scsi7 : ahci
[   13.759424] ata7: SATA max UDMA/133 abar m8192@0xfeafe000 port 0xfeafe100 irq 11
[   13.759425] ata8: DUMMY
[   13.759587] initcall ahci_pci_driver_init+0x0/0x1000 [ahci] returned 0 after 60829 usecs
[   13.863888] calling  ttm_init+0x0/0x1000 [ttm] @ 1505
[   13.869251] initcall ttm_init+0x0/0x1000 [ttm] returned 0 after 1turned 0 after 188 usecs
[   13.893252] calling  radeon_init+0x0/0xb0 [radeon] @ 1505
[   13.898813] [drm] radeon kernel modesetting enabled.
[   13.905208] [drm] initializing kernel modesetting (RS780 0x1002:0x9610 0x1019:0x2119).
[   13.913394] [drm] register mmio base: 0xFE8F0000
[   13.918163] [drm] register mmio size: 65536
[   13.923762] ATOM BIOS: 113
[   13.926663] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 - 0x00000000CFFFFFFF (256M used)
[   13.935619] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[   13.943413] [drm] Detected VRAM RAM=256M, BAR=256M
[   13.948344] [drm] RAM width 32bits DDR
[   13.952601] [TTM] Zone  kernel: Available graphics memory: 432674 kiB
[   13.959232] [TTM] Zone highmem: Available graphics memory: 1941382 kiB
[   13.965950] [TTM] Initializing pool allocator
[   13.970534] [TTM] Initializing DMA pool allocator
[   13.975580] [drm] radeon: 256M of VRAM memory ready
[   13.980608] [drm] radeon: 512M of GTT memory ready.
[   13.985793] [drm] Loading RS780 Microcode
[   13.990406] [drm] radeon: power management initialized
[   13.995696] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   14.009801] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
[   14.016990] radeon 0000:01:05.0: WB enabled
[[   14.083874] [drm] ring test on 0 succeeded in 0 usecs
[   14.089346] [drm] ib test on ring 0 succeeded in 0 usecs
[   14.097918] [drm] Radeon Display Connectors
[   14.102230] [drm] Connector 0:
[   14.105376] [drm]   VGA-1
[   14.108072] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[   14.115690] [drm]   Encoders:
[   14.118748] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   14.123505] [drm] Connector 1:
[   14.126652] [drm]   HDMI-A-1
[   14.129621] [drm]   HPD3
[   14.132232] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[   14.139851] [drm]   Encoders:
[   14.142911] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[   14.156270] radeon 0000:01:05.0: No connectors reported connected with modes
[   14.163553] [drm] Cannot find any crtc or sizes - going 1024x768
[   14.166555] ata3: SATA link down (SStatus 0 SControl 300)
[   14.167553] ata7: SATA link down (SStatus 0 SControl 300)
[   14.169547] ata4: SATA link down (SStatus 0 SControl 300)
[   14.170655] ata6: SATA link down (SStatus 0 SControl 300)
[   14.170837] ata5: SATA link down (SStatus 0 SControl 300)
[   14.214520] [drm] fb mappable at 0xD0141000
[   14.218830] [drm] vram apper at 0xD0000000
[   14.223049] [drm] size 3145728
[   14.226196] [drm] fb depth is 24
[   14.229522] [drm]    pitch is 4096
[   14.233651] fbcon: radeondrmfb (fb0) is primary device
[   14.252412] Console: switching to colour frame buffer device 128x4on 0000:01:05.0: registered panic notifier
[   14.297800] [drm] Initialized radeon 2.39.0 20080528 for 0000:01:05.0 on minor 0
[   14.305606] initcall radeon_init+0x0/0xb0 [radeon] returned 0 after 397610 usecs
[   14.313637] modprobe (1505) used greatest stack depth: 5436 bytes left
[   14.349452] ata2: softreset failed (device not ready)
[   14.354670] ata2: applying PMP SRST workaround and retrying
[   14.360432] ata1: softreset failed (device not ready)
[   14.365639] ata1: applying PMP SRST workaround and retrying
[   14.524259] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.530675] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   18.335276] irq 18: nobody cared (try booting with the "irqpoll" option)
[   18.342176] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.16.0-rc5upstream-01668-g6d2265b #1
[   18.350680] Hardware name: ECS A780GM-A Ultra/A780GM-A Ultra, BIOS 080015  04/01/2010
[   18.358739]  f02cc5dc f02bff50 c1618986 f02cc580 f02bff70 c10d87e7 c1741950 00000012
[   18.366780]  c18345e0 00000001 f02cc580 00000000 f02bff94 c10d8a62 00000012 c2f397be
[   18.374819]  0000002f f02f0b80 f02cc580 00000000 ef2ddd80 f02bffd0 c10d65ee c10d65ee
[   18.382857] Call Trace:
[   18.385375]  [<c1618986>] dump_stack+0x48/0x60
[   18.389948]  [<c10d87e7>] __report_bad_irq+0x27/0xc0
[   18.395055]  [<c10d8a62>] note_interrupt+0x1e2/0x230
[   18.400164]  [<c10d65ee>] handle_irq_event_percpu+0x9e/0x1c0
[   18.405987]  [<c10d65ee>] ? handle_irq_event_percpu+0x9e/0x1c0
[   18.411988]  [<c10d6747>] handle_irq_event+0x37/0x60
[   18.417095]  [<c10d91e8>] handle_fasteoi_irq+0x58/0xf0
[   18.422380]  [<c10d9190>] ? handle_percpu_irq+0x50/0x50
[   18.427756]  [<c1046d2a>] handle_irq+0x9a/0xd0
[   18.432327]  <IRQ>  [<c10461bd>] do_IRQ+0x3d/0xd0
[   18.437183]  [<c1074d36>] ? lapic_next_event+0x16/0x20
[   18.442469]  [<c10f14da>] ? clockevents_program_event+0xca/0x190
[   18.448649]  [<c161ddec>] common_interrupt+0x2c/0x34
[   18.453756]  [<c1081c45>] ? native_safe_halt+0x5/0x10
[   18.458955]  [<c104e4b7>] default_idle+0x17/0xb0
[   18.463703]  [<c104e5bf>] amd_e400_idle+0x6f/0xf0
[   18.468543]  [<c104dda9>] arch_cpu_idle+0x9/0x10
[   18.473293]  [<c10c6a2e>] cpu_startup_entry+0x23e/0x3a0
[   18.478668]  [<c1073e5c>] start_secondary+0x18c/0x200
[   18.483863] handlers:
[   18.486199] [<c14717c0>] usb_hcd_irq
[   18.489886] [<c14717c0>] usb_hcd_irq
[   18.493571] [<c14717c0>] usb_hcd_irq
[   18.497256] Disabling IRQ #18
[   19.525576] ata2.00: qc timeout (cmd 0xec)
[   19.529807] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   19.5361FY (I/O error, err_mask=0x4)
[   20.004031] ata2: softreset failed (device not ready)
[   20.009236] ata2: applying PMP SRST workaround and retrying
[   20[   20.177831] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   20.184238] ata1: SATA link up 1.5 Gbps (SStatus 113 S[   30.174487] ata2.00: qc timeout (cmd 0xec)
[   30.178715] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   30.1849)
[   30.194534] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   30.200808] ata1: limiting SATA link speed to 1.5 Gbps
[   30.663099] ata2: softreset failed (device not ready)
[   30.668302] ata2: applying PMP SRST workaround and retrying
[   30.674057] ata1: softreset failed (device not ready)
[   30.679259] ata1: applying PMP SRST workaround and retrying
[   30.837971] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   30.844378] ata1: SATA link up 1.5 Gbps (SStatus 113 S
telnet> Connection closed.
[Connecting to system 34 ]

--jI8keyz6grp/JLjh--
