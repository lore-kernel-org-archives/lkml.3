Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3BPDXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:23:39 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:63597 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3BPDXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:23:36 -0500
Date: Fri, 15 Feb 2013 22:23:28 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 3.2.38 most of the time has 100% cpu use reported
Message-ID: <20130216032327.GA2094@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
 <20130207173630.GA8355@roll>
 <20130208190819.GA16894@roll>
 <20130210151140.GA2307@roll>
 <20130212050116.GA2146@roll>
 <1360818247.5374.300.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1360818247.5374.300.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2013 at 05:04:07AM +0000, Ben Hutchings wrote:
> On Tue, 2013-02-12 at 00:01 -0500, tmhikaru@gmail.com wrote:
> > 	Okay, I finally have located the patch causing this bizzare problem
> > for me. Before I discuss it, I'm going to drag out the kernel bug repor=
ting
> > guidelines and try to make a proper bug report out of this.
> >=20
> > [1.] One line summary of the problem:
> > 3.2.38 most of the time has 100% cpu use reported
> >=20
> > [2.] Full description of the problem/report:
> > Reverse applying the patch for
> >=20
> > [9a1f08a1a192f9177d7063d903773aed800b840f] drivers/firmware/dmi_scan.c:=
 fetch dmi version from SMBIOS if it exists
> >=20
> > on top of a clean 3.2.38 tree makes the problem go away.
> [...]
> > I have to admit I have no idea what the patch I'm reversing actually do=
es,
>=20
> It changes how we look for the version of a BIOS interface (DMI or
> SMBIOS).  All the code that it touches, and the version number variable,
> are discarded after boot and therefore can have very limited effect on
> what happens later!

Actually upon poking about, I noticed something VERY different about what
the patch does to my computer during the boot process.  Let me show you
dmesg output from a good kernel without the patch, then a bad one with the
patch, then I'll point out the important differences I noticed:

good:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.38 (root@roll) (gcc version 4.7.1 (GCC) ) =
#1 Mon Feb 11 22:17:04 EST 2013
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 00000000000ea000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005fff8000 - 0000000060000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: ECS M848A/M848A, BIOS 07.00T 04/02/01
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] last_pfn =3D 0x5fff0 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 base 0D0000000 mask FF8000000 write-combining
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009c000] 9c000 size 12288
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 1bfa000-1c00000
[    0.000000] RAMDISK: 5fc59000 - 5fff0000
[    0.000000] Allocated new RAMDISK: 37867000 - 37bfd6a3
[    0.000000] Move RAMDISK from 000000005fc59000 - 000000005ffef6a2 to 378=
67000 - 37bfd6a2
[    0.000000] ACPI: RSDP 000fa260 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 5fff0000 0002C (v01 AMIINT SiS740XX 00001000 MSFT=
 0100000B)
[    0.000000] ACPI: FACP 5fff0030 00081 (v01 AMIINT SiS740XX 00000011 MSFT=
 0100000B)
[    0.000000] ACPI: DSDT 5fff0110 034D2 (v01    SiS      740 00000100 MSFT=
 0100000D)
[    0.000000] ACPI: FACS 5fff8000 00040
[    0.000000] ACPI: APIC 5fff00c0 00050 (v01 AMIINT SiS740XX 00001000 MSFT=
 0100000B)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 643MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0005fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005fff0
[    0.000000] On node 0 totalpages: 393087
[    0.000000] free_area_init_node: node 0, pgdat c14e7a08, node_mem_map f6=
c66200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1288 pages used for memmap
[    0.000000]   HighMem zone: 163562 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 00000000000=
ea000
[    0.000000] PM: Registered nosave memory: 00000000000ea000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 60000000=
:9ec00000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 390015
[    0.000000] Kernel command line: BOOT_IMAGE=3DLinux ro root=3D801 vt.def=
ault_utf8=3D0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 6290944 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00037bfe:0005fff0)
[    0.000000] Memory: 1543180k/1572800k available (3373k kernel code, 2916=
8k reserved, 1672k data, 472k init, 659400k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc14ee000 - 0xc1564000   ( 472 kB)
[    0.000000]       .data : 0xc134b7fd - 0xc14edac0   (1672 kB)
[    0.000000]       .text : 0xc1000000 - 0xc134b7fd   (3373 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Df6008000 soft=3Df600a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2083.173 MHz processor.
[    0.001003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4166.34 BogoMIPS (lpj=3D2083173)
[    0.002003] pid_max: default: 32768 minimum: 301
[    0.002116] Security Framework initialized
[    0.002226] Mount-cache hash table entries: 512
[    0.002518] Initializing cgroup subsys cpuacct
[    0.002595] Initializing cgroup subsys memory
[    0.002682] Initializing cgroup subsys devices
[    0.002755] Initializing cgroup subsys freezer
[    0.002828] Initializing cgroup subsys net_cls
[    0.002901] Initializing cgroup subsys blkio
[    0.003013] Initializing cgroup subsys perf_event
[    0.003126] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
[    0.003217] CPU: AMD Athlon(tm) XP 2800+ stepping 00
[    0.003369] ACPI: Core revision 20110623
[    0.006396] ftrace: allocating 19401 entries in 38 pages
[    0.008130] Performance Events: AMD PMU driver.
[    0.008251] ... version:                0
[    0.008321] ... bit width:              48
[    0.008390] ... generic registers:      4
[    0.008460] ... value mask:             0000ffffffffffff
[    0.008532] ... max period:             00007fffffffffff
[    0.009002] ... fixed-purpose events:   0
[    0.009072] ... event mask:             000000000000000f
[    0.009468] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.009844] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.019998] devtmpfs: initialized
[    0.019998] PM: Registering ACPI NVS region at 5fff8000 (32768 bytes)
[    0.019998] xor: automatically using best checksumming function: pIII_sse
[    0.024002]    pIII_sse  :  1748.000 MB/sec
[    0.024073] xor: using function: pIII_sse (1748.000 MB/sec)
[    0.024154] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.024507] print_constraints: dummy:=20
[    0.024688] NET: Registered protocol family 16
[    0.025196] ACPI: bus type pci registered
[    0.026627] PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=3D2
[    0.026701] PCI: Using configuration type 1 for base access
[    0.035571] bio: create slab <bio-0> at 0
[    0.052138] raid6: int32x1    441 MB/s
[    0.069085] raid6: int32x2    507 MB/s
[    0.086069] raid6: int32x4    570 MB/s
[    0.103009] raid6: int32x8    339 MB/s
[    0.119995] raid6: mmxx1     1457 MB/s
[    0.136990] raid6: mmxx2     2648 MB/s
[    0.154012] raid6: sse1x1    1562 MB/s
[    0.170997] raid6: sse1x2    2570 MB/s
[    0.171067] raid6: using algorithm sse1x2 (2570 MB/s)
[    0.171208] ACPI: Added _OSI(Module Device)
[    0.171280] ACPI: Added _OSI(Processor Device)
[    0.171351] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.171422] ACPI: Added _OSI(Processor Aggregator Device)
[    0.171999] ACPI: EC: Look up EC in DSDT
[    0.175420] ACPI: Interpreter enabled
[    0.175496] ACPI: (supports S0 S1 S4 S5)
[    0.175698] ACPI: Using IOAPIC for interrupt routing
[    0.177297] ACPI: Power Resource [FDDP] (off)
[    0.177735] ACPI: Power Resource [URP1] (off)
[    0.178254] ACPI: Power Resource [URP2] (off)
[    0.178922] ACPI: Power Resource [LPTP] (off)
[    0.182346] ACPI: No dock devices found.
[    0.182418] HEST: Table not found.
[    0.182490] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    0.182940] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.183177] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] =
(ignored)
[    0.183182] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] =
(ignored)
[    0.183186] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff] (ignored)
[    0.183191] pci_root PNP0A03:00: host bridge window [mem 0x000cb000-0x00=
0dffff] (ignored)
[    0.183195] pci_root PNP0A03:00: host bridge window [mem 0x60000000-0xff=
dfffff] (ignored)
[    0.183199] pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xff=
dfffff] (ignored)
[    0.183222] pci 0000:00:00.0: [1039:0746] type 0 class 0x000600
[    0.183236] pci 0000:00:00.0: reg 10: [mem 0xd0000000-0xd7ffffff]
[    0.183311] pci 0000:00:01.0: [1039:0002] type 1 class 0x000604
[    0.183359] pci 0000:00:02.0: [1039:0008] type 0 class 0x000601
[    0.183426] pci 0000:00:02.0: Enabling SiS 96x SMBus
[    0.183519] pci 0000:00:02.1: [1039:0016] type 0 class 0x000c05
[    0.183565] pci 0000:00:02.1: reg 20: [io  0x0c00-0x0c1f]
[    0.183608] pci 0000:00:02.5: [1039:5513] type 0 class 0x000101
[    0.183658] pci 0000:00:02.5: reg 20: [io  0xff00-0xff0f]
[    0.183700] pci 0000:00:03.0: [1039:7001] type 0 class 0x000c03
[    0.183715] pci 0000:00:03.0: reg 10: [mem 0xcfffd000-0xcfffdfff]
[    0.183782] pci 0000:00:03.1: [1039:7001] type 0 class 0x000c03
[    0.183797] pci 0000:00:03.1: reg 10: [mem 0xcfffe000-0xcfffefff]
[    0.183870] pci 0000:00:03.2: [1039:7002] type 0 class 0x000c03
[    0.183888] pci 0000:00:03.2: reg 10: [mem 0xcffdf000-0xcffdffff]
[    0.184001] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    0.184008] pci 0000:00:03.2: PME# disabled
[    0.184036] pci 0000:00:04.0: [1039:0900] type 0 class 0x000200
[    0.184054] pci 0000:00:04.0: reg 10: [io  0xc800-0xc8ff]
[    0.184066] pci 0000:00:04.0: reg 14: [mem 0xcfffc000-0xcfffcfff]
[    0.184108] pci 0000:00:04.0: reg 30: [mem 0xcffa0000-0xcffbffff pref]
[    0.184137] pci 0000:00:04.0: supports D1 D2
[    0.184140] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.184146] pci 0000:00:04.0: PME# disabled
[    0.184173] pci 0000:00:0a.0: [1113:1211] type 0 class 0x000200
[    0.184191] pci 0000:00:0a.0: reg 10: [io  0xc400-0xc4ff]
[    0.184203] pci 0000:00:0a.0: reg 14: [mem 0xcffffd00-0xcffffdff]
[    0.184245] pci 0000:00:0a.0: reg 30: [mem 0xcffe0000-0xcffeffff pref]
[    0.184274] pci 0000:00:0a.0: supports D1 D2
[    0.184277] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.184282] pci 0000:00:0a.0: PME# disabled
[    0.184303] pci 0000:00:0b.0: [1095:3512] type 0 class 0x000106
[    0.184321] pci 0000:00:0b.0: reg 10: [io  0xdc00-0xdc07]
[    0.184332] pci 0000:00:0b.0: reg 14: [io  0xd800-0xd803]
[    0.184343] pci 0000:00:0b.0: reg 18: [io  0xd400-0xd407]
[    0.184354] pci 0000:00:0b.0: reg 1c: [io  0xd000-0xd003]
[    0.184365] pci 0000:00:0b.0: reg 20: [io  0xcc00-0xcc0f]
[    0.184376] pci 0000:00:0b.0: reg 24: [mem 0xcffffe00-0xcfffffff]
[    0.184387] pci 0000:00:0b.0: reg 30: [mem 0xcff00000-0xcff7ffff pref]
[    0.184415] pci 0000:00:0b.0: supports D1 D2
[    0.184436] pci 0000:00:0c.0: [1274:5880] type 0 class 0x000401
[    0.184455] pci 0000:00:0c.0: reg 10: [io  0xc000-0xc03f]
[    0.184529] pci 0000:00:0c.0: supports D2
[    0.184590] pci 0000:01:00.0: [1002:7142] type 0 class 0x000300
[    0.184619] pci 0000:01:00.0: reg 10: [mem 0xb0000000-0xbfffffff 64bit p=
ref]
[    0.184634] pci 0000:01:00.0: reg 18: [mem 0xcfdf0000-0xcfdfffff 64bit]
[    0.184645] pci 0000:01:00.0: reg 20: [io  0x8800-0x88ff]
[    0.184663] pci 0000:01:00.0: reg 30: [mem 0xcfdc0000-0xcfddffff pref]
[    0.184714] pci 0000:01:00.0: supports D1 D2
[    0.184741] pci 0000:01:00.1: [1002:7162] type 0 class 0x000380
[    0.184762] pci 0000:01:00.1: reg 10: [mem 0xcfde0000-0xcfdeffff 64bit]
[    0.184826] pci 0000:01:00.1: supports D1 D2
[    0.184869] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.184945] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    0.184951] pci 0000:00:01.0:   bridge window [mem 0xcfc00000-0xcfdfffff]
[    0.184957] pci 0000:00:01.0:   bridge window [mem 0xaf900000-0xcfafffff=
 pref]
[    0.184967] pci_bus 0000:00: on NUMA node 0
[    0.184972] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.185157]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x1e)
[    0.187640] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 1=
5)
[    0.188049] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.188497] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 *11 12 14 1=
5)
[    0.189002] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.189450] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.189897] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 7 10 11 12 14 1=
5)
[    0.190340] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15=
) *0, disabled.
[    0.190889] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *10 11 12 14 1=
5)
[    0.191547] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.191659] vgaarb: loaded
[    0.191727] vgaarb: bridge control possible 0000:01:00.0
[    0.192063] SCSI subsystem initialized
[    0.192294] libata version 3.00 loaded.
[    0.192423] usbcore: registered new interface driver usbfs
[    0.192557] usbcore: registered new interface driver hub
[    0.192689] usbcore: registered new device driver usb
[    0.193078] PCI: Using ACPI for IRQ routing
[    0.193180] PCI: pci_cache_line_size set to 32 bytes
[    0.193240] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.193244] reserve RAM buffer: 000000005fff0000 - 000000005fffffff=20
[    0.195801] pnp: PnP ACPI init
[    0.195907] ACPI: bus type pnp registered
[    0.196163] pnp 00:00: [bus 00-ff]
[    0.196169] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.196172] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.196176] pnp 00:00: [io  0x0d00-0xffff window]
[    0.196179] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.196183] pnp 00:00: [mem 0x000cb000-0x000dffff window]
[    0.196186] pnp 00:00: [mem 0x60000000-0xffdfffff window]
[    0.196190] pnp 00:00: [mem 0xfee01000-0xffdfffff window]
[    0.196321] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.196431] pnp 00:01: [io  0x0010-0x001f]
[    0.196435] pnp 00:01: [io  0x0020-0x003f]
[    0.196446] pnp 00:01: [io  0x0044-0x005f]
[    0.196449] pnp 00:01: [io  0x0062-0x0063]
[    0.196452] pnp 00:01: [io  0x0065-0x006f]
[    0.196455] pnp 00:01: [io  0x0072-0x007f]
[    0.196458] pnp 00:01: [io  0x0080]
[    0.196461] pnp 00:01: [io  0x0084-0x0086]
[    0.196464] pnp 00:01: [io  0x0088]
[    0.196467] pnp 00:01: [io  0x008c-0x008e]
[    0.196470] pnp 00:01: [io  0x0090-0x009f]
[    0.196472] pnp 00:01: [io  0x00a0-0x00bf]
[    0.196475] pnp 00:01: [io  0x00e0-0x00ef]
[    0.196478] pnp 00:01: [io  0x0290-0x0297]
[    0.196481] pnp 00:01: [io  0x0480-0x048f]
[    0.196484] pnp 00:01: [io  0x04d0-0x04d1]
[    0.196487] pnp 00:01: [io  0x0c00-0x0c1f]
[    0.196490] pnp 00:01: [io  0x03f0-0x03f1]
[    0.196493] pnp 00:01: [mem 0xfee00000-0xfeefffff]
[    0.196621] system 00:01: [io  0x0290-0x0297] has been reserved
[    0.196697] system 00:01: [io  0x0480-0x048f] has been reserved
[    0.196771] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.196845] system 00:01: [io  0x0c00-0x0c1f] has been reserved
[    0.196919] system 00:01: [io  0x03f0-0x03f1] has been reserved
[    0.196985] system 00:01: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.197062] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197096] pnp 00:02: [dma 4]
[    0.197099] pnp 00:02: [io  0x0000-0x000f]
[    0.197102] pnp 00:02: [io  0x0081-0x0083]
[    0.197105] pnp 00:02: [io  0x0087]
[    0.197108] pnp 00:02: [io  0x0089-0x008b]
[    0.197110] pnp 00:02: [io  0x008f]
[    0.197113] pnp 00:02: [io  0x00c0-0x00df]
[    0.197185] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.197202] pnp 00:03: [io  0x0070-0x0071]
[    0.197224] pnp 00:03: [irq 8]
[    0.197295] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.197310] pnp 00:04: [io  0x0061]
[    0.197388] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.197403] pnp 00:05: [io  0x00f0-0x00ff]
[    0.197411] pnp 00:05: [irq 13]
[    0.197482] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.197629] pnp 00:06: [io  0x03f2-0x03f3]
[    0.197633] pnp 00:06: [io  0x03f4-0x03f5]
[    0.197636] pnp 00:06: [io  0x03f7]
[    0.197642] pnp 00:06: [irq 6]
[    0.197645] pnp 00:06: [dma 2]
[    0.197748] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.198030] pnp 00:07: [io  0x03f8-0x03ff]
[    0.198038] pnp 00:07: [irq 4]
[    0.198177] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.198430] pnp 00:08: [io  0x02f8-0x02ff]
[    0.198437] pnp 00:08: [irq 3]
[    0.198568] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.199044] pnp 00:09: [io  0x0378-0x037f]
[    0.199048] pnp 00:09: [io  0x0778-0x077b]
[    0.199054] pnp 00:09: [irq 7]
[    0.199057] pnp 00:09: [dma 3]
[    0.199218] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.199639] pnp: PnP ACPI: found 10 devices
[    0.199710] ACPI: ACPI bus type pnp unregistered
[    0.239932] Switching to clocksource acpi_pm
[    0.239992] PCI: max bus depth: 1 pci_try_num: 2
[    0.240011] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.240085] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    0.240164] pci 0000:00:01.0:   bridge window [mem 0xcfc00000-0xcfdfffff]
[    0.240241] pci 0000:00:01.0:   bridge window [mem 0xaf900000-0xcfafffff=
 pref]
[    0.240365] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.240369] pci_bus 0000:00: resource 1 [mem 0x00000000-0x3ffffffff]
[    0.240374] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    0.240377] pci_bus 0000:01: resource 1 [mem 0xcfc00000-0xcfdfffff]
[    0.240381] pci_bus 0000:01: resource 2 [mem 0xaf900000-0xcfafffff pref]
[    0.240447] NET: Registered protocol family 2
[    0.240582] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    0.241060] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.243877] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.244493] TCP: Hash tables configured (established 131072 bind 65536)
[    0.244568] TCP reno registered
[    0.244639] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.244729] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.244951] NET: Registered protocol family 1
[    0.245195] RPC: Registered named UNIX socket transport module.
[    0.245269] RPC: Registered udp transport module.
[    0.245340] RPC: Registered tcp transport module.
[    0.245410] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.245547] pci 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.318023] pci 0000:00:03.0: PCI INT A disabled
[    0.318110] pci 0000:00:03.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.380016] pci 0000:00:03.1: PCI INT B disabled
[    0.380102] pci 0000:00:03.2: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.380190] pci 0000:00:03.2: PCI INT D disabled
[    0.380278] pci 0000:01:00.0: Boot video device
[    0.380286] PCI: CLS 32 bytes, default 32
[    0.380389] Trying to unpack rootfs image as initramfs...
[    0.503777] Freeing initrd memory: 3676k freed
[    0.510756] Intel AES-NI instructions are not detected.
[    0.511241] audit: initializing netlink socket (disabled)
[    0.511335] type=3D2000 audit(1360977394.510:1): initialized
[    0.512082] highmem bounce pool size: 64 pages
[    0.517423] VFS: Disk quotas dquot_6.5.2
[    0.517605] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.518139] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.518296] msgmni has been set to 1733
[    0.519527] async_tx: api initialized (async)
[    0.519748] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.519885] io scheduler noop registered
[    0.519956] io scheduler deadline registered
[    0.520043] io scheduler cfq registered (default)
[    0.520462] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.520930] ERST: Table is not found!
[    0.521009] GHES: HEST is not enabled!
[    0.521094] isapnp: Scanning for PnP cards...
[    0.877304] isapnp: No Plug & Play device found
[    0.881956] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.146095] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.410092] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.431098] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.451779] 00:08: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.452564] Floppy drive(s): fd0 is 1.44M
[    1.467184] FDC 0 is a post-1991 82077
[    1.471886] brd: module loaded
[    1.473554] sata_sil 0000:00:0b.0: version 2.4
[    1.473624] sata_sil 0000:00:0b.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
[    1.474271] scsi0 : sata_sil
[    1.474497] scsi1 : sata_sil
[    1.474695] ata1: SATA max UDMA/100 mmio m512@0xcffffe00 tf 0xcffffe80 i=
rq 17
[    1.474773] ata2: SATA max UDMA/100 mmio m512@0xcffffe00 tf 0xcffffec0 i=
rq 17
[    1.477235] pata_sis 0000:00:02.5: version 0.5.2
[    1.477277] pata_sis 0000:00:02.5: SiS 962/963 MuTIOL IDE UDMA133 contro=
ller
[    1.478086] scsi2 : pata_sis
[    1.478309] scsi3 : pata_sis
[    1.479179] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq=
 14
[    1.479256] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq=
 15
[    1.480625] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.518052] Refined TSC clocksource calibration: 2083.095 MHz.
[    1.518131] Switching to clocksource tsc
[    1.518232] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.518584] mousedev: PS/2 mouse device common for all mice
[    1.518744] rtc_cmos 00:03: RTC can wake from S4
[    1.519024] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.519118] rtc0: alarms up to one month, 114 bytes nvram
[    1.519242] md: linear personality registered for level -1
[    1.519315] md: raid0 personality registered for level 0
[    1.519388] md: raid1 personality registered for level 1
[    1.519460] md: raid10 personality registered for level 10
[    1.519532] md: raid6 personality registered for level 6
[    1.519603] md: raid5 personality registered for level 5
[    1.519675] md: raid4 personality registered for level 4
[    1.519747] md: multipath personality registered for level -4
[    1.519946] device-mapper: uevent: version 1.0.3
[    1.520187] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[    1.520392] cpuidle: using governor ladder
[    1.520463] cpuidle: using governor menu
[    1.520621] TCP cubic registered
[    1.520690] Initializing XFRM netlink socket
[    1.520774] NET: Registered protocol family 17
[    1.520861] Registering the dns_resolver key type
[    1.520957] Using IPI Shortcut mode
[    1.779017] ata1: SATA link down (SStatus 0 SControl 310)
[    2.084024] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    2.103272] ata2.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    2.103348] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.122260] ata2.00: configured for UDMA/100
[    2.122511] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1A=
G0 PQ: 0 ANSI: 5
[    2.122929] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 =
TB/931 GiB)
[    2.123113] sd 1:0:0:0: [sda] Write Protect is off
[    2.123186] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.123218] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    2.140340]  sda: sda1
[    2.140750] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.277302] ata4.00: ATAPI: HL-DT-STDVD-RAM GSA-H55N, 1.03, max UDMA/66
[    2.283297] ata4.00: configured for UDMA/66
[    2.285823] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H55N 1.=
03 PQ: 0 ANSI: 5
[    2.288576] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    2.288688] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.288961] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.289237] registered taskstats version 1
[    2.289906] rtc_cmos 00:03: setting system clock to 2013-02-16 01:16:36 =
UTC (1360977396)
[    2.290242] Freeing unused kernel memory: 472k freed
[    2.290978] Write protecting the kernel text: 3376k
[    2.291107] Write protecting the kernel read-only data: 1372k
[    2.312297] udevd[838]: starting version 182
[    3.625134] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    4.488982] loop: module loaded
[    4.707213] udevd[1002]: starting version 182
[    5.328972] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    5.329108] ACPI: Power Button [PWRB]
[    5.329287] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input1
[    5.329401] ACPI: Sleep Button [SLPB]
[    5.329550] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    5.329662] ACPI: Power Button [PWRF]
[    5.386677] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.388799] parport_pc 00:09: reported by Plug and Play ACPI
[    5.388951] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[    5.548972] ppdev: user-space parallel port driver
[    5.569625] 8139too: 8139too Fast Ethernet driver 0.9.28
[    5.569785] 8139too 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IR=
Q 18
[    5.570350] 8139too 0000:00:0a.0: eth0: RealTek RTL8139 at 0xc400, 00:e0=
:29:9b:1a:15, IRQ 18
[    5.571175] sis900.c: v1.08.10 Apr. 2 2006
[    5.571285] sis900 0000:00:04.0: PCI INT A -> GSI 19 (level, low) -> IRQ=
 19
[    5.572504] 0000:00:04.0: VIA 6103 PHY transceiver found at address 1.
[    5.582064] 0000:00:04.0: Using transceiver found at address 1 as default
[    5.588100] eth1: SiS 900 PCI Fast Ethernet at 0xc800, IRQ 19, 00:19:21:=
9b:5b:e7
[    5.597445] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.597588] ehci_hcd 0000:00:03.2: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    5.597694] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    5.598073] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus =
number 1
[    5.598265] ehci_hcd 0000:00:03.2: irq 23, io mem 0xcffdf000
[    5.604014] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    5.604140] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.604217] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.604327] usb usb1: Product: EHCI Host Controller
[    5.604398] usb usb1: Manufacturer: Linux 3.2.38 ehci_hcd
[    5.604471] usb usb1: SerialNumber: 0000:00:03.2
[    5.604790] hub 1-0:1.0: USB hub found
[    5.604869] hub 1-0:1.0: 6 ports detected
[    5.610798] Linux agpgart interface v0.103
[    5.637643] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
[    5.637778] ACPI: resource 0000:00:02.1 [io  0x0c00-0x0c1f] conflicts wi=
th ACPI region SMRG [io 0xc00-0xc1f]
[    5.637932] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    5.665290] agpgart-sis 0000:00:00.0: SiS chipset [1039/0746]
[    5.675911] agpgart-sis 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[    5.850462] [drm] Initialized drm 1.1.0 20060810
[    5.914464] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.914606] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    5.914714] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    5.916765] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus =
number 2
[    5.916935] ohci_hcd 0000:00:03.0: irq 20, io mem 0xcfffd000
[    5.970062] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.970147] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.970257] usb usb2: Product: OHCI Host Controller
[    5.970998] usb usb2: Manufacturer: Linux 3.2.38 ohci_hcd
[    5.971075] usb usb2: SerialNumber: 0000:00:03.0
[    5.980843] hub 2-0:1.0: USB hub found
[    5.980932] hub 2-0:1.0: 3 ports detected
[    5.981162] snd_ens1371 0000:00:0c.0: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[    6.092867] [drm] radeon kernel modesetting enabled.
[    6.093101] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    6.093538] [drm] initializing kernel modesetting (RV515 0x1002:0x7142 0=
x1002:0x030B).
[    6.093681] [drm] register mmio base: 0xCFDF0000
[    6.093753] [drm] register mmio size: 65536
[    6.094953] ATOM BIOS: PCP
[    6.095063] agpgart-sis 0000:00:00.0: AGP 3.0 bridge
[    6.095154] agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:00:0=
0.0 into 8x mode
[    6.095269] agpgart-sis 0000:00:00.0: SiS delay workaround: giving bridg=
e time to recover
[    6.106056] agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:01:0=
0.0 into 8x mode
[    6.106179] radeon 0000:01:00.0: GTT: 128M 0xD0000000 - 0xD7FFFFFF
[    6.106258] [drm] Generation 2 PCI interface, using max accessible memory
[    6.106336] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x00000=
0000FFFFFFF (256M used)
[    6.106479] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.106553] [drm] Driver supports precise vblank timestamp query.
[    6.106663] [drm] radeon: irq initialized.
[    6.106999] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[    6.107150] [drm] RAM width 128bits DDR
[    6.107378] [TTM] Zone  kernel: Available graphics memory: 443964 kiB.
[    6.107556] [TTM] Zone highmem: Available graphics memory: 773664 kiB.
[    6.107634] [TTM] Initializing pool allocator.
[    6.107755] [drm] radeon: 256M of VRAM memory ready
[    6.107828] [drm] radeon: 128M of GTT memory ready.
[    6.107926] [drm] GART: num cpu pages 32768, num gpu pages 32768
[    6.109713] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    6.115884] radeon 0000:01:00.0: WB disabled
[    6.118658] [drm] Loading R500 Microcode
[    6.171099] [drm] radeon: ring at 0x00000000D0001000
[    6.171207] [drm] ring test succeeded in 9 usecs
[    6.171635] [drm] radeon: ib pool ready.
[    6.171811] [drm] ib test succeeded in 0 usecs
[    6.173757] [drm] Radeon Display Connectors
[    6.173830] [drm] Connector 0:
[    6.173898] [drm]   VGA
[    6.173967] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4=
c 0x7e4c
[    6.174084] [drm]   Encoders:
[    6.174152] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    6.174223] [drm] Connector 1:
[    6.174291] [drm]   S-video
[    6.174358] [drm]   Encoders:
[    6.174426] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    6.174496] [drm] Connector 2:
[    6.174564] [drm]   DVI-I
[    6.174631] [drm]   HPD2
[    6.174699] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5=
c 0x7e5c
[    6.174807] [drm]   Encoders:
[    6.174875] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    6.174946] [drm]     DFP3: INTERNAL_LVTM1
[    6.373277] usb 2-2: new full-speed USB device number 2 using ohci_hcd
[    6.373466] [drm] fb mappable at 0xB0060000
[    6.373565] [drm] vram apper at 0xB0000000
[    6.373637] [drm] size 5300224
[    6.373707] [drm] fb depth is 24
[    6.373776] [drm]    pitch is 5888
[    6.374308] fbcon: radeondrmfb (fb0) is primary device
[    6.409183] Console: switching to colour frame buffer device 180x56
[    6.438388] fb0: radeondrmfb frame buffer device
[    6.438541] drm: registered panic notifier
[    6.438761] [drm] Initialized radeon 2.12.0 20080528 for 0000:01:00.0 on=
 minor 0
[    6.571004] usb 2-2: New USB device found, idVendor=3D058f, idProduct=3D=
9254
[    6.571249] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    6.571488] usb 2-2: Product: Generic USB Hub
[    6.571634] usb 2-2: Manufacturer: ALCOR
[    6.574074] hub 2-2:1.0: USB hub found
[    6.576999] hub 2-2:1.0: 4 ports detected
[    6.881986] usb 2-2.1: new low-speed USB device number 3 using ohci_hcd
[    7.134896] usb 2-2.1: New USB device found, idVendor=3D046d, idProduct=
=3Dc31c
[    7.135132] usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    7.135377] usb 2-2.1: Product: USB Keyboard
[    7.135520] usb 2-2.1: Manufacturer: Logitech
[    7.186292] ohci_hcd 0000:00:03.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    7.186573] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    7.186812] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus =
number 3
[    7.187097] ohci_hcd 0000:00:03.1: irq 21, io mem 0xcfffe000
[    7.240055] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    7.240299] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.240541] usb usb3: Product: OHCI Host Controller
[    7.240704] usb usb3: Manufacturer: Linux 3.2.38 ohci_hcd
[    7.240884] usb usb3: SerialNumber: 0000:00:03.1
[    7.241399] hub 3-0:1.0: USB hub found
[    7.241534] hub 3-0:1.0: 3 ports detected
[    7.265973] usb 2-2.2: new full-speed USB device number 4 using ohci_hcd
[    7.372968] usb 2-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc245
[    7.373221] usb 2-2.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    7.373467] usb 2-2.2: Product: Gaming Mouse G400
[    7.373624] usb 2-2.2: Manufacturer: Logitech
[    7.446967] usb 2-2.3: new low-speed USB device number 5 using ohci_hcd
[    7.555950] usb 2-2.3: New USB device found, idVendor=3D10d5, idProduct=
=3D55a2
[    7.562768] usb 2-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    7.569549] usb 2-2.3: Product: 2Port KVMSwicther
[    7.576327] usb 2-2.3: Manufacturer: No brand
[    7.583094] usb 2-2.3: SerialNumber: 0=12=C2=92
[    7.758752] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
03.0/usb2/2-2/2-2.1/2-2.1:1.0/input/input3
[    7.767971] generic-usb 0003:046D:C31C.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Logitech USB Keyboard] on usb-0000:00:03.0-2.1/input0
[    7.791108] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
03.0/usb2/2-2/2-2.1/2-2.1:1.1/input/input4
[    7.799164] generic-usb 0003:046D:C31C.0002: input,hidraw1: USB HID v1.1=
0 Device [Logitech USB Keyboard] on usb-0000:00:03.0-2.1/input1
[    7.814355] input: Logitech Gaming Mouse G400 as /devices/pci0000:00/000=
0:00:03.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input5
[    7.823992] generic-usb 0003:046D:C245.0003: input,hidraw2: USB HID v1.1=
0 Mouse [Logitech Gaming Mouse G400] on usb-0000:00:03.0-2.2/input0
[    7.849241] generic-usb 0003:046D:C245.0004: hiddev0,hidraw3: USB HID v1=
=2E10 Device [Logitech Gaming Mouse G400] on usb-0000:00:03.0-2.2/input1
[    7.872057] input: No brand 2Port KVMSwicther as /devices/pci0000:00/000=
0:00:03.0/usb2/2-2/2-2.3/2-2.3:1.0/input/input6
[    7.882278] generic-usb 0003:10D5:55A2.0005: input,hidraw4: USB HID v1.1=
0 Keyboard [No brand 2Port KVMSwicther] on usb-0000:00:03.0-2.3/input0
[    7.893766] usbhid 2-2.3:1.1: couldn't find an input interrupt endpoint
[    7.903641] usbcore: registered new interface driver usbhid
[    7.913226] usbhid: USB HID core driver
[    8.170327] fuse init (API version 7.17)
[    9.070587] EXT4-fs (sda1): re-mounted. Opts: acl,user_xattr
[   13.745075] PPP generic driver version 2.4.2
[   13.818965] usbcore: registered new interface driver snd-usb-audio
[   13.841680] uhci_hcd: USB Universal Host Controller Interface driver
[   13.869610] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   14.332503] it87: Found IT8705F chip at 0x290, revision 3
[   19.662670] Adding 2047996k swap on /swap.  Priority:-1 extents:33 acros=
s:63414268k=20
[   22.467944] 8139too 0000:00:0a.0: eth0: link down
[   32.213446] NET: Registered protocol family 10
[   32.213817] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.330826] eth1: Media Link Off
[   34.331434] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   39.831636] ip_tables: (C) 2000-2006 Netfilter Core Team
[   39.858170] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)


Bad:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.38 (root@roll) (gcc version 4.7.1 (GCC) ) =
#2 Fri Feb 15 20:37:40 EST 2013
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 00000000000ea000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005fff8000 - 0000000060000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] Legacy DMI 0.0 present.
[    0.000000] DMI:  , BIOS =20
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] last_pfn =3D 0x5fff0 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 base 0D0000000 mask FF8000000 write-combining
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009c000] 9c000 size 12288
[    0.000000] init_memory_mapping: 0000000000000000-0000000037bfe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037a00000 page 2M
[    0.000000]  0037a00000 - 0037bfe000 page 4k
[    0.000000] kernel direct mapping tables up to 37bfe000 @ 1bfa000-1c00000
[    0.000000] RAMDISK: 5fc59000 - 5fff0000
[    0.000000] Allocated new RAMDISK: 37867000 - 37bfd6a3
[    0.000000] Move RAMDISK from 000000005fc59000 - 000000005ffef6a2 to 378=
67000 - 37bfd6a2
[    0.000000] ACPI: RSDP 000fa260 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 5fff0000 0002C (v01 AMIINT SiS740XX 00001000 MSFT=
 0100000B)
[    0.000000] ACPI: FACP 5fff0030 00081 (v01 AMIINT SiS740XX 00000011 MSFT=
 0100000B)
[    0.000000] ACPI: DSDT 5fff0110 034D2 (v01    SiS      740 00000100 MSFT=
 0100000D)
[    0.000000] ACPI: FACS 5fff8000 00040
[    0.000000] ACPI: APIC 5fff00c0 00050 (v01 AMIINT SiS740XX 00001000 MSFT=
 0100000B)
[    0.000000] ACPI: no DMI BIOS year, acpi=3Dforce is required to enable A=
CPI
[    0.000000] ACPI: Disabling ACPI support
[    0.000000] 643MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00037bfe
[    0.000000]   HighMem  0x00037bfe -> 0x0005fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005fff0
[    0.000000] On node 0 totalpages: 393087
[    0.000000] free_area_init_node: node 0, pgdat c14e7a08, node_mem_map f6=
c66200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1288 pages used for memmap
[    0.000000]   HighMem zone: 163562 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.o=
rg
[    0.000000] Found and enabled local APIC!
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 00000000000=
ea000
[    0.000000] PM: Registered nosave memory: 00000000000ea000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 60000000=
:9ec00000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 390015
[    0.000000] Kernel command line: BOOT_IMAGE=3DLinuxOld ro root=3D801 vt.=
default_utf8=3D0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 6290944 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00037bfe:0005fff0)
[    0.000000] Memory: 1543184k/1572800k available (3374k kernel code, 2916=
4k reserved, 1672k data, 472k init, 659400k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc14ee000 - 0xc1564000   ( 472 kB)
[    0.000000]       .data : 0xc134b83d - 0xc14edac0   (1672 kB)
[    0.000000]       .text : 0xc1000000 - 0xc134b83d   (3374 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Df6006000 soft=3Df6008000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2083.264 MHz processor.
[    0.001002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4166.52 BogoMIPS (lpj=3D2083264)
[    0.002003] pid_max: default: 32768 minimum: 301
[    0.002116] Security Framework initialized
[    0.002225] Mount-cache hash table entries: 512
[    0.002518] Initializing cgroup subsys cpuacct
[    0.002595] Initializing cgroup subsys memory
[    0.002682] Initializing cgroup subsys devices
[    0.002756] Initializing cgroup subsys freezer
[    0.002829] Initializing cgroup subsys net_cls
[    0.002903] Initializing cgroup subsys blkio
[    0.003013] Initializing cgroup subsys perf_event
[    0.003124] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
[    0.003216] CPU: AMD Athlon(tm) XP 2800+ stepping 00
[    0.003373] ftrace: allocating 19401 entries in 38 pages
[    0.005132] Performance Events: AMD PMU driver.
[    0.005252] ... version:                0
[    0.005322] ... bit width:              48
[    0.005392] ... generic registers:      4
[    0.005461] ... value mask:             0000ffffffffffff
[    0.005533] ... max period:             00007fffffffffff
[    0.006003] ... fixed-purpose events:   0
[    0.006073] ... event mask:             000000000000000f
[    0.006463] Enabling APIC mode:  Flat.  Using 0 I/O APICs
[    0.108221] devtmpfs: initialized
[    0.108456] PM: Registering ACPI NVS region at 5fff8000 (32768 bytes)
[    0.108582] xor: automatically using best checksumming function: pIII_sse
[    0.112993]    pIII_sse  :  2072.000 MB/sec
[    0.113065] xor: using function: pIII_sse (2072.000 MB/sec)
[    0.113145] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.113502] print_constraints: dummy:=20
[    0.113682] NET: Registered protocol family 16
[    0.115529] PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=3D2
[    0.115604] PCI: Using configuration type 1 for base access
[    0.124438] bio: create slab <bio-0> at 0
[    0.141129] raid6: int32x1    441 MB/s
[    0.158076] raid6: int32x2    507 MB/s
[    0.175062] raid6: int32x4    570 MB/s
[    0.191998] raid6: int32x8    339 MB/s
[    0.208984] raid6: mmxx1     1457 MB/s
[    0.225977] raid6: mmxx2     2648 MB/s
[    0.243005] raid6: sse1x1    1562 MB/s
[    0.259983] raid6: sse1x2    2570 MB/s
[    0.260054] raid6: using algorithm sse1x2 (2570 MB/s)
[    0.260184] ACPI: Interpreter disabled.
[    0.260438] vgaarb: loaded
[    0.260733] SCSI subsystem initialized
[    0.260956] libata version 3.00 loaded.
[    0.261080] usbcore: registered new interface driver usbfs
[    0.261208] usbcore: registered new interface driver hub
[    0.261339] usbcore: registered new device driver usb
[    0.261717] PCI: Probing PCI hardware
[    0.261789] PCI: Probing PCI hardware (bus 00)
[    0.261889] pci 0000:00:00.0: [1039:0746] type 0 class 0x000600
[    0.261903] pci 0000:00:00.0: reg 10: [mem 0xd0000000-0xd7ffffff]
[    0.261984] pci 0000:00:01.0: [1039:0002] type 1 class 0x000604
[    0.262033] pci 0000:00:02.0: [1039:0008] type 0 class 0x000601
[    0.262099] pci 0000:00:02.0: Enabling SiS 96x SMBus
[    0.262193] pci 0000:00:02.1: [1039:0016] type 0 class 0x000c05
[    0.262239] pci 0000:00:02.1: reg 20: [io  0x0c00-0x0c1f]
[    0.262282] pci 0000:00:02.5: [1039:5513] type 0 class 0x000101
[    0.262324] pci 0000:00:02.5: reg 20: [io  0xff00-0xff0f]
[    0.262366] pci 0000:00:03.0: [1039:7001] type 0 class 0x000c03
[    0.262381] pci 0000:00:03.0: reg 10: [mem 0xcfffd000-0xcfffdfff]
[    0.262448] pci 0000:00:03.1: [1039:7001] type 0 class 0x000c03
[    0.262462] pci 0000:00:03.1: reg 10: [mem 0xcfffe000-0xcfffefff]
[    0.262534] pci 0000:00:03.2: [1039:7002] type 0 class 0x000c03
[    0.262552] pci 0000:00:03.2: reg 10: [mem 0xcffdf000-0xcffdffff]
[    0.262625] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    0.262632] pci 0000:00:03.2: PME# disabled
[    0.262659] pci 0000:00:04.0: [1039:0900] type 0 class 0x000200
[    0.262677] pci 0000:00:04.0: reg 10: [io  0xc800-0xc8ff]
[    0.262689] pci 0000:00:04.0: reg 14: [mem 0xcfffc000-0xcfffcfff]
[    0.262731] pci 0000:00:04.0: reg 30: [mem 0xcffa0000-0xcffbffff pref]
[    0.262760] pci 0000:00:04.0: supports D1 D2
[    0.262763] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.262768] pci 0000:00:04.0: PME# disabled
[    0.262796] pci 0000:00:0a.0: [1113:1211] type 0 class 0x000200
[    0.262814] pci 0000:00:0a.0: reg 10: [io  0xc400-0xc4ff]
[    0.262825] pci 0000:00:0a.0: reg 14: [mem 0xcffffd00-0xcffffdff]
[    0.262868] pci 0000:00:0a.0: reg 30: [mem 0xcffe0000-0xcffeffff pref]
[    0.262896] pci 0000:00:0a.0: supports D1 D2
[    0.262899] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.262904] pci 0000:00:0a.0: PME# disabled
[    0.262924] pci 0000:00:0b.0: [1095:3512] type 0 class 0x000106
[    0.262942] pci 0000:00:0b.0: reg 10: [io  0xdc00-0xdc07]
[    0.262953] pci 0000:00:0b.0: reg 14: [io  0xd800-0xd803]
[    0.262964] pci 0000:00:0b.0: reg 18: [io  0xd400-0xd407]
[    0.262979] pci 0000:00:0b.0: reg 1c: [io  0xd000-0xd003]
[    0.262991] pci 0000:00:0b.0: reg 20: [io  0xcc00-0xcc0f]
[    0.263002] pci 0000:00:0b.0: reg 24: [mem 0xcffffe00-0xcfffffff]
[    0.263013] pci 0000:00:0b.0: reg 30: [mem 0xcff00000-0xcff7ffff pref]
[    0.263041] pci 0000:00:0b.0: supports D1 D2
[    0.263063] pci 0000:00:0c.0: [1274:5880] type 0 class 0x000401
[    0.263081] pci 0000:00:0c.0: reg 10: [io  0xc000-0xc03f]
[    0.263156] pci 0000:00:0c.0: supports D2
[    0.263218] pci 0000:01:00.0: [1002:7142] type 0 class 0x000300
[    0.263246] pci 0000:01:00.0: reg 10: [mem 0xb0000000-0xbfffffff 64bit p=
ref]
[    0.263262] pci 0000:01:00.0: reg 18: [mem 0xcfdf0000-0xcfdfffff 64bit]
[    0.263272] pci 0000:01:00.0: reg 20: [io  0x8800-0x88ff]
[    0.263291] pci 0000:01:00.0: reg 30: [mem 0xcfdc0000-0xcfddffff pref]
[    0.263342] pci 0000:01:00.0: supports D1 D2
[    0.263369] pci 0000:01:00.1: [1002:7162] type 0 class 0x000380
[    0.263390] pci 0000:01:00.1: reg 10: [mem 0xcfde0000-0xcfdeffff 64bit]
[    0.263454] pci 0000:01:00.1: supports D1 D2
[    0.263497] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.263573] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    0.263579] pci 0000:00:01.0:   bridge window [mem 0xcfc00000-0xcfdfffff]
[    0.263585] pci 0000:00:01.0:   bridge window [mem 0xaf900000-0xcfafffff=
 pref]
[    0.264494] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.264847] pci 0000:00:02.0: SIS IRQ router [1039:0963]
[    0.264938] PCI: setting IRQ 5 as level-triggered
[    0.264943] pci 0000:00:02.1: found PCI INT B -> IRQ 5
[    0.264989] pci 0000:00:02.1: sharing IRQ 5 with 0000:00:0b.0
[    0.265083] PCI: pci_cache_line_size set to 32 bytes
[    0.265142] reserve RAM buffer: 000000000009fc00 - 000000000009ffff=20
[    0.265147] reserve RAM buffer: 000000005fff0000 - 000000005fffffff=20
[    0.267721] pnp: PnP ACPI: disabled
[    0.273417] PCI: max bus depth: 1 pci_try_num: 2
[    0.273442] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.273519] pci 0000:00:01.0:   bridge window [io  0x8000-0x8fff]
[    0.273597] pci 0000:00:01.0:   bridge window [mem 0xcfc00000-0xcfdfffff]
[    0.273675] pci 0000:00:01.0:   bridge window [mem 0xaf900000-0xcfafffff=
 pref]
[    0.273803] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.273807] pci_bus 0000:00: resource 1 [mem 0x00000000-0x3ffffffff]
[    0.273811] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    0.273815] pci_bus 0000:01: resource 1 [mem 0xcfc00000-0xcfdfffff]
[    0.273818] pci_bus 0000:01: resource 2 [mem 0xaf900000-0xcfafffff pref]
[    0.273875] NET: Registered protocol family 2
[    0.274025] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    0.274486] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.276647] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.277255] TCP: Hash tables configured (established 131072 bind 65536)
[    0.277330] TCP reno registered
[    0.277401] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.277492] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.277777] NET: Registered protocol family 1
[    0.277995] RPC: Registered named UNIX socket transport module.
[    0.278070] RPC: Registered udp transport module.
[    0.278141] RPC: Registered tcp transport module.
[    0.278211] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.278325] pci 0000:00:03.0: found PCI INT A -> IRQ 5
[    0.340980] pci 0000:00:03.1: found PCI INT B -> IRQ 5
[    0.402966] PCI: setting IRQ 10 as level-triggered
[    0.402970] pci 0000:00:03.2: found PCI INT D -> IRQ 10
[    0.403092] pci 0000:01:00.0: Boot video device
[    0.403099] PCI: CLS 32 bytes, default 32
[    0.403198] Trying to unpack rootfs image as initramfs...
[    0.527738] Freeing initrd memory: 3676k freed
[    0.534367] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)
[    0.534854] Intel AES-NI instructions are not detected.
[    0.535314] audit: initializing netlink socket (disabled)
[    0.535409] type=3D2000 audit(1360978886.534:1): initialized
[    0.536076] highmem bounce pool size: 64 pages
[    0.541392] VFS: Disk quotas dquot_6.5.2
[    0.541571] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.542105] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.542263] msgmni has been set to 1733
[    0.543471] async_tx: api initialized (async)
[    0.543679] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.543815] io scheduler noop registered
[    0.543886] io scheduler deadline registered
[    0.543936] io scheduler cfq registered (default)
[    0.544360] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.544749] isapnp: Scanning for PnP cards...
[    0.901012] isapnp: No Plug & Play device found
[    0.905607] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.149902] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.394859] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.395875] Floppy drive(s): fd0 is 1.44M
[    1.411462] FDC 0 is a post-1991 82077
[    1.415590] brd: module loaded
[    1.417931] sata_sil 0000:00:0b.0: version 2.4
[    1.417986] sata_sil 0000:00:0b.0: found PCI INT A -> IRQ 5
[    1.418070] sata_sil 0000:00:0b.0: sharing IRQ 5 with 0000:00:02.1
[    1.418718] scsi0 : sata_sil
[    1.418949] scsi1 : sata_sil
[    1.419148] ata1: SATA max UDMA/100 mmio m512@0xcffffe00 tf 0xcffffe80 i=
rq 5
[    1.419225] ata2: SATA max UDMA/100 mmio m512@0xcffffe00 tf 0xcffffec0 i=
rq 5
[    1.421618] pata_sis 0000:00:02.5: version 0.5.2
[    1.421658] pata_sis 0000:00:02.5: SiS 962/963 MuTIOL IDE UDMA133 contro=
ller
[    1.422433] scsi2 : pata_sis
[    1.422657] scsi3 : pata_sis
[    1.422856] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq=
 14
[    1.422932] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq=
 15
[    1.424217] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.431029] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.431383] mousedev: PS/2 mouse device common for all mice
[    1.431736] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    1.431810] rtc0: alarms up to one day, 114 bytes nvram
[    1.431931] md: linear personality registered for level -1
[    1.432004] md: raid0 personality registered for level 0
[    1.432077] md: raid1 personality registered for level 1
[    1.432149] md: raid10 personality registered for level 10
[    1.432222] md: raid6 personality registered for level 6
[    1.432294] md: raid5 personality registered for level 5
[    1.432365] md: raid4 personality registered for level 4
[    1.432437] md: multipath personality registered for level -4
[    1.432625] device-mapper: uevent: version 1.0.3
[    1.432893] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[    1.433098] cpuidle: using governor ladder
[    1.433170] cpuidle: using governor menu
[    1.433335] TCP cubic registered
[    1.433405] Initializing XFRM netlink socket
[    1.433490] NET: Registered protocol family 17
[    1.433579] Registering the dns_resolver key type
[    1.433672] Using IPI Shortcut mode
[    1.535784] Switching to clocksource tsc
[    1.732655] ata1: SATA link down (SStatus 0 SControl 310)
[    2.037580] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    2.056822] ata2.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    2.056897] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.075804] ata2.00: configured for UDMA/100
[    2.076055] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1A=
G0 PQ: 0 ANSI: 5
[    2.076476] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 =
TB/931 GiB)
[    2.076660] sd 1:0:0:0: [sda] Write Protect is off
[    2.076734] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.076765] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    2.082240]  sda: sda1
[    2.082649] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.231804] ata4.00: ATAPI: HL-DT-STDVD-RAM GSA-H55N, 1.03, max UDMA/66
[    2.237799] ata4.00: configured for UDMA/66
[    2.240326] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H55N 1.=
03 PQ: 0 ANSI: 5
[    2.242954] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    2.243067] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.243340] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.243620] registered taskstats version 1
[    2.244218] rtc_cmos rtc_cmos: setting system clock to 2013-02-16 01:41:=
28 UTC (1360978888)
[    2.244518] Freeing unused kernel memory: 472k freed
[    2.245318] Write protecting the kernel text: 3376k
[    2.245421] Write protecting the kernel read-only data: 1372k
[    2.266782] udevd[774]: starting version 182
[    2.397479] spurious 8259A interrupt: IRQ7.
[    3.577943] EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts: (null)
[    4.441737] loop: module loaded
[    4.659928] udevd[939]: starting version 182
[    5.311999] sis900.c: v1.08.10 Apr. 2 2006
[    5.312136] sis900 0000:00:04.0: found PCI INT A -> IRQ 5
[    5.313392] 0000:00:04.0: VIA 6103 PHY transceiver found at address 1.
[    5.322944] 0000:00:04.0: Using transceiver found at address 1 as default
[    5.324239] eth0: SiS 900 PCI Fast Ethernet at 0xc800, IRQ 5, 00:19:21:9=
b:5b:e7
[    5.326757] udevd[945]: renamed network interface eth0 to eth1
[    5.401388] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.401527] ehci_hcd 0000:00:03.2: found PCI INT D -> IRQ 10
[    5.401666] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    5.402053] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus =
number 1
[    5.402237] ehci_hcd 0000:00:03.2: irq 10, io mem 0xcffdf000
[    5.407663] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    5.407793] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.407869] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.407980] usb usb1: Product: EHCI Host Controller
[    5.408052] usb usb1: Manufacturer: Linux 3.2.38 ehci_hcd
[    5.408124] usb usb1: SerialNumber: 0000:00:03.2
[    5.408453] hub 1-0:1.0: USB hub found
[    5.408531] hub 1-0:1.0: 6 ports detected
[    5.422691] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.432587] Linux agpgart interface v0.103
[    5.442516] agpgart-sis 0000:00:00.0: SiS chipset [1039/0746]
[    5.453816] agpgart-sis 0000:00:00.0: AGP aperture is 128M @ 0xd0000000
[    5.471755] 8139too: 8139too Fast Ethernet driver 0.9.28
[    5.471897] PCI: setting IRQ 11 as level-triggered
[    5.471904] 8139too 0000:00:0a.0: found PCI INT A -> IRQ 11
[    5.472487] 8139too 0000:00:0a.0: eth0: RealTek RTL8139 at 0xc400, 00:e0=
:29:9b:1a:15, IRQ 11
[    5.534915] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
[    5.558918] [drm] Initialized drm 1.1.0 20060810
[    5.694814] [drm] radeon kernel modesetting enabled.
[    5.695391] [drm] initializing kernel modesetting (RV515 0x1002:0x7142 0=
x1002:0x030B).
[    5.695534] [drm] register mmio base: 0xCFDF0000
[    5.695611] [drm] register mmio size: 65536
[    5.696810] ATOM BIOS: PCP
[    5.696916] agpgart-sis 0000:00:00.0: AGP 3.0 bridge
[    5.697005] agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:00:0=
0.0 into 8x mode
[    5.697118] agpgart-sis 0000:00:00.0: SiS delay workaround: giving bridg=
e time to recover
[    5.707625] agpgart-sis 0000:00:00.0: putting AGP V3 device at 0000:01:0=
0.0 into 8x mode
[    5.707746] radeon 0000:01:00.0: GTT: 128M 0xD0000000 - 0xD7FFFFFF
[    5.707824] [drm] Generation 2 PCI interface, using max accessible memory
[    5.707902] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x00000=
0000FFFFFFF (256M used)
[    5.708045] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.708119] [drm] Driver supports precise vblank timestamp query.
[    5.708211] [drm] radeon: irq initialized.
[    5.708532] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[    5.708642] [drm] RAM width 128bits DDR
[    5.708828] [TTM] Zone  kernel: Available graphics memory: 443966 kiB.
[    5.708903] [TTM] Zone highmem: Available graphics memory: 773666 kiB.
[    5.708977] [TTM] Initializing pool allocator.
[    5.709108] [drm] radeon: 256M of VRAM memory ready
[    5.709181] [drm] radeon: 128M of GTT memory ready.
[    5.709280] [drm] GART: num cpu pages 32768, num gpu pages 32768
[    5.711125] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    5.712514] radeon 0000:01:00.0: WB disabled
[    5.715803] [drm] Loading R500 Microcode
[    5.780870] [drm] radeon: ring at 0x00000000D0001000
[    5.780980] [drm] ring test succeeded in 9 usecs
[    5.781399] [drm] radeon: ib pool ready.
[    5.781592] [drm] ib test succeeded in 0 usecs
[    5.783546] [drm] Radeon Display Connectors
[    5.783626] [drm] Connector 0:
[    5.783695] [drm]   VGA
[    5.783763] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4=
c 0x7e4c
[    5.783873] [drm]   Encoders:
[    5.783942] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.784012] [drm] Connector 1:
[    5.784080] [drm]   S-video
[    5.784147] [drm]   Encoders:
[    5.784215] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    5.784286] [drm] Connector 2:
[    5.784354] [drm]   DVI-I
[    5.784421] [drm]   HPD2
[    5.784489] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5=
c 0x7e5c
[    5.784601] [drm]   Encoders:
[    5.784669] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    5.784740] [drm]     DFP3: INTERNAL_LVTM1
[    5.940984] [drm] fb mappable at 0xB0060000
[    5.941064] [drm] vram apper at 0xB0000000
[    5.941134] [drm] size 5300224
[    5.941203] [drm] fb depth is 24
[    5.941271] [drm]    pitch is 5888
[    5.941631] fbcon: radeondrmfb (fb0) is primary device
[    5.978358] Console: switching to colour frame buffer device 180x56
[    6.009404] fb0: radeondrmfb frame buffer device
[    6.009563] drm: registered panic notifier
[    6.012115] [drm] Initialized radeon 2.12.0 20080528 for 0000:01:00.0 on=
 minor 0
[    6.016487] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.016774] ohci_hcd 0000:00:03.0: found PCI INT A -> IRQ 5
[    6.017040] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    6.017360] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus =
number 2
[    6.017648] ohci_hcd 0000:00:03.0: irq 5, io mem 0xcfffd000
[    6.070536] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    6.070784] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.071029] usb usb2: Product: OHCI Host Controller
[    6.071194] usb usb2: Manufacturer: Linux 3.2.38 ohci_hcd
[    6.071376] usb usb2: SerialNumber: 0000:00:03.0
[    6.071825] hub 2-0:1.0: USB hub found
[    6.071961] hub 2-0:1.0: 3 ports detected
[    6.072206] snd_ens1371 0000:00:0c.0: found PCI INT A -> IRQ 11
[    6.428400] usb 2-2: new full-speed USB device number 2 using ohci_hcd
[    6.617434] usb 2-2: New USB device found, idVendor=3D058f, idProduct=3D=
9254
[    6.617663] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    6.617905] usb 2-2: Product: Generic USB Hub
[    6.618052] usb 2-2: Manufacturer: ALCOR
[    6.620522] hub 2-2:1.0: USB hub found
[    6.623433] hub 2-2:1.0: 4 ports detected
[    6.936391] usb 2-2.1: new low-speed USB device number 3 using ohci_hcd
[    7.185368] usb 2-2.1: New USB device found, idVendor=3D046d, idProduct=
=3Dc31c
[    7.185602] usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    7.185848] usb 2-2.1: Product: USB Keyboard
[    7.185991] usb 2-2.1: Manufacturer: Logitech
[    7.187229] ohci_hcd 0000:00:03.1: found PCI INT B -> IRQ 5
[    7.187490] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    7.187731] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus =
number 3
[    7.201165] ohci_hcd 0000:00:03.1: irq 5, io mem 0xcfffe000
[    7.260306] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    7.267052] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    7.273775] usb usb3: Product: OHCI Host Controller
[    7.280479] usb usb3: Manufacturer: Linux 3.2.38 ohci_hcd
[    7.287242] usb usb3: SerialNumber: 0000:00:03.1
[    7.297629] hub 3-0:1.0: USB hub found
[    7.304448] hub 3-0:1.0: 3 ports detected
[    7.318352] usb 2-2.2: new full-speed USB device number 4 using ohci_hcd
[    7.431337] usb 2-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc245
[    7.438389] usb 2-2.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    7.445557] usb 2-2.2: Product: Gaming Mouse G400
[    7.452793] usb 2-2.2: Manufacturer: Logitech
[    7.533325] usb 2-2.3: new low-speed USB device number 5 using ohci_hcd
[    7.631066] Clocksource tsc unstable (delta =3D 87920554 ns)
[    7.638320] Switching to clocksource jiffies
[    7.655525] usb 2-2.3: New USB device found, idVendor=3D10d5, idProduct=
=3D55a2
[    7.656522] usb 2-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    7.657524] usb 2-2.3: Product: 2Port KVMSwicther
[    7.658513] usb 2-2.3: Manufacturer: No brand
[    7.659513] usb 2-2.3: SerialNumber: 0=12=C2=92
[    7.858487] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
03.0/usb2/2-2/2-2.1/2-2.1:1.0/input/input0
[    7.860506] generic-usb 0003:046D:C31C.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Logitech USB Keyboard] on usb-0000:00:03.0-2.1/input0
[    7.875690] input: Logitech USB Keyboard as /devices/pci0000:00/0000:00:=
03.0/usb2/2-2/2-2.1/2-2.1:1.1/input/input1
[    7.877587] generic-usb 0003:046D:C31C.0002: input,hidraw1: USB HID v1.1=
0 Device [Logitech USB Keyboard] on usb-0000:00:03.0-2.1/input1
[    7.887156] input: Logitech Gaming Mouse G400 as /devices/pci0000:00/000=
0:00:03.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input2
[    7.889232] generic-usb 0003:046D:C245.0003: input,hidraw2: USB HID v1.1=
0 Mouse [Logitech Gaming Mouse G400] on usb-0000:00:03.0-2.2/input0
[    7.904546] generic-usb 0003:046D:C245.0004: hiddev0,hidraw3: USB HID v1=
=2E10 Device [Logitech Gaming Mouse G400] on usb-0000:00:03.0-2.2/input1
[    7.918823] input: No brand 2Port KVMSwicther as /devices/pci0000:00/000=
0:00:03.0/usb2/2-2/2-2.3/2-2.3:1.0/input/input3
[    7.921427] generic-usb 0003:10D5:55A2.0005: input,hidraw4: USB HID v1.1=
0 Keyboard [No brand 2Port KVMSwicther] on usb-0000:00:03.0-2.3/input0
[    7.921534] usbhid 2-2.3:1.1: couldn't find an input interrupt endpoint
[    7.924001] usbcore: registered new interface driver usbhid
[    7.924501] usbhid: USB HID core driver
[    8.161157] fuse init (API version 7.17)
[    9.538991] EXT4-fs (sda1): re-mounted. Opts: acl,user_xattr
[   14.151244] PPP generic driver version 2.4.2
[   14.214794] usbcore: registered new interface driver snd-usb-audio
[   14.228491] uhci_hcd: USB Universal Host Controller Interface driver
[   14.246197] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   14.713916] it87: Found IT8705F chip at 0x290, revision 3
[   20.039716] Adding 2047996k swap on /swap.  Priority:-1 extents:33 acros=
s:63414268k=20
[   22.595138] 8139too 0000:00:0a.0: eth0: link down
[   33.513019] NET: Registered protocol family 10
[   33.513419] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.575177] eth1: Media Link Off
[   35.575789] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   41.010045] ip_tables: (C) 2000-2006 Netfilter Core Team
[   41.036616] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)


Important bits I noticed: The 'bad' kernel initially boots with acpi
disabled, then later turns it back on, whereas the 'good' one boots with
acpi completely enabled with no problems.

Also, very early on just after yelling about the NX bit not existing in my
cpu, it says this: (-good/+bad)

-[    0.000000] DMI 2.3 present.
-[    0.000000] DMI: ECS M848A/M848A, BIOS 07.00T 04/02/01
+[    0.000000] Legacy DMI 0.0 present.
+[    0.000000] DMI:  , BIOS =20

The 'good' kernel without the patch finds something for DMI (That is in fact
my motherboard model number, so I know it's doing *something* right) whereas
the bad one with the patch...  Does not.

Anyway, I suppose I could try using acpi=3Dforce as the kernel suggests for=
 a
workaround for now, but I'm still convinced something went wrong with that
patch now more than ever.  Due to the fact that ACPI gets reenabled I didn't
catch on that something was going wrong so early in the boot process with it
until now.

One thing I want to emphasize is that the only difference between the two
kernels is that lone patch.

As for perf top, I tried running it as you suggested, but I honestly can't
figure out how to get this thing to dump output to a file. Every time I
redirect stdio/stderr I get a empty file, I don't know what I'm doing wrong.
Any tips?

=46rom console I did try to copy down the kernel entries it listed. These t=
wo
were listed consistently every single time at the top, sometimes with
different percentage points.  I don't know what it's doing, so feel free to
explain.

When I copied down this output it was just after the machine had finished
booting from a root login and was otherwise idle with no tasks running other
than perf

These entries were copied by hand, so please forgive any mistakes I made. I
would have copied and pasted the entries from within Xorg's terminals, but
the change of environment cluttered the output and made it list KDE
libraries and such as the first items.

%24.81 [kernel]         [k] bitfill_aligned
%14.84 [kernel]         [k] cfb_imageblit

Often these are different percentages, but tend to stay around the same
values with little jitter.  Often the interrupts is 0 and both kernel: and
exact: entries are "-nan%" without the quotes.  I don't know what any of
this means unfortunately, or even if I'm doing the equivalent of holding the
map upside down.

Tim McGrath

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUR77r5EncCrqzVruAQJrHQgAiIqh0+hXGe6aB4ix4nKfZmSUPhUccxHm
oAi6ZVVA40ISzWBQI+ZC/7Un7A+1pl9S3ILYWLAmww17/o0wulVSBUmbfC+Wz1kG
bvaa4rfnCOsCiwZpFjxQp381oiyQ8L8oshSXZ3M1l4fNQ0UngNR9LQjr+bi9UBQm
nSbHsn0Q4H6H5dv5GnGNup6K+EYnLOoOpNT6zJ+pzuOqm3wijzaBmDLcZH4mTRTs
rsUalcUVZee8mCXPHiMrsDEXkmFAlRKyr2fzseFH+mTQb1eUMtSa29TbjHbjYx3D
wXym1l3eUsk8jxuTfcOu+5YT7RA0JvKSunj18sWK48fICs0UmUUqtg==
=Lpfs
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
