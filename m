Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaA1SIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:08:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50254 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaA1SHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:07:49 -0500
Date: Tue, 28 Jan 2014 13:07:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, santosh.shilimkar@ti.com, yinghai@kernel.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Linux 3.14-rc0 + Merge branch 'akpm' (incoming from Andrew - Mon Jan
 27) + Xen + i386 dom0 = BOOM
Message-ID: <20140128180734.GA8158@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


If I boot a kernel that is built on
commit 1b17366d695c8ab03f98d0155357e97a427e1dce
Merge: d12de1e 7179ba5
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jan 27 21:11:26 2014 -0800

    Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/be=
nh/powerpc

it boots .

But if I boot with

commit 54c0a4b46150db1571d955d598cd342c9f1d9657
Merge: 1b17366 c2218e2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jan 27 21:17:55 2014 -0800

    Merge branch 'akpm' (incoming from Andrew)

it blows up.

Here is the juicy bit (attached is the full serial log)


mapping kernel into physical memory
about to get started...
[    0.000000] Reserving virtual address space above 0xff400000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0upstream-08800-g3bf6f37 (konrad@build-ex=
ternal.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) =
#1 SMP Tue Jan 28 11:29:28 EST 2014
[    0.000000] Freeing 99-100 pfn range: 103 pages freed
[    0.000000] Released 103 pages of unused memory
[    0.000000] Set 298846 page(s) to 1-1 mapping
[    0.000000] Populating 3e700-3e767 pfn range: 103 pages added
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x0000000000098fff] usable
[    0.000000] Xen: [mem 0x0000000000099c00-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000004d066fff] usable
[    0.000000] Xen: [mem 0x000000004d067000-0x00000000a58f0fff] unusable
[    0.000000] Xen: [mem 0x00000000a58f1000-0x00000000a58f7fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a58f8000-0x00000000a61b0fff] unusable
[    0.000000] Xen: [mem 0x00000000a61b1000-0x00000000a6596fff] reserved
[    0.000000] Xen: [mem 0x00000000a6597000-0x00000000b74b3fff] unusable
[    0.000000] Xen: [mem 0x00000000b74b4000-0x00000000b76cafff] reserved
[    0.000000] Xen: [mem 0x00000000b76cb000-0x00000000b770bfff] unusable
[    0.000000] Xen: [mem 0x00000000b770c000-0x00000000b77b8fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000b77b9000-0x00000000b7ffefff] reserved
[    0.000000] Xen: [mem 0x00000000b7fff000-0x00000000b7ffffff] unusable
[    0.000000] Xen: [mem 0x00000000bc000000-0x00000000be1fffff] reserved
[    0.000000] Xen: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000023fdfffff] unusable
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Supermicro X10SAE/X10SAE, BIOS 1.00 05/03/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x4d067 max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x077fefff]
[    0.000000] Base memory trampoline at [c0095000] 95000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x36c00000-0x36dfffff]
[    0.000000]  [mem 0x36c00000-0x36dfffff] page 4k
[    0.000000] BRK [0x01a33000, 0x01a33fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x34000000-0x36bfffff]
[    0.000000]  [mem 0x34000000-0x36bfffff] page 4k
[    0.000000] BRK [0x01a34000, 0x01a34fff] PGTABLE
[    0.000000] BRK [0x01a35000, 0x01a35fff] PGTABLE
[    0.000000] BRK [0x01a36000, 0x01a36fff] PGTABLE
[    0.000000] BRK [0x01a37000, 0x01a37fff] PGTABLE
[    0.000000] BRK [0x01a38000, 0x01a38fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x33ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x36e00000-0x36ffdfff]
[    0.000000]  [mem 0x36e00000-0x36ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x01c7f000-0x06bf8fff]
[    0.000000] ACPI: RSDP 000f0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT b7794098 0000AC (v01 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: FACP b779f0b8 00010C (v05 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: DSDT b77941d8 00AEDD (v02 ALASKA    A M I 00000000 INT=
L 20091112)
[    0.000000] ACPI: FACS b77b7080 000040
[    0.000000] ACPI: APIC b779f1c8 000092 (v03 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: FPDT b779f260 000044 (v01 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: SSDT b779f2a8 000540 (v01  PmRef  Cpu0Ist 00003000 INT=
L 20051117)
[    0.000000] ACPI: SSDT b779f7e8 000AD8 (v01  PmRef    CpuPm 00003000 INT=
L 20051117)
[    0.000000] ACPI: SSDT b77a02c0 0002F2 (v01  PmRef  Cpu0Tst 00003000 INT=
L 20051117)
[    0.000000] ACPI: SSDT b77a05b8 000348 (v01  PmRef    ApTst 00003000 INT=
L 20051117)
[    0.000000] ACPI: MCFG b77a0900 00003C (v01 ALASKA    A M I 01072009 MSF=
T 00000097)
[    0.000000] ACPI: HPET b77a0940 000038 (v01 ALASKA    A M I 01072009 AMI=
=2E 00000005)
[    0.000000] ACPI: SSDT b77a0978 00036D (v01 SataRe SataTabl 00001000 INT=
L 20091112)
[    0.000000] ACPI: SSDT b77a0ce8 00327D (v01 SaSsdt  SaSsdt  00003000 INT=
L 20091112)
[    0.000000] ACPI: ASF! b77a3f68 0000A5 (v32 INTEL       HCG 00000001 TFS=
M 000F4240)
[    0.000000] ACPI: XMAR b77a4010 0000B8 (v01 INTEL      HSW  00000001 INT=
L 00000001)
[    0.000000] ACPI: EINJ b77a40c8 000130 (v01    AMI AMI EINJ 00000000    =
  00000000)
[    0.000000] ACPI: ERST b77a41f8 000230 (v01  AMIER AMI ERST 00000000    =
  00000000)
[    0.000000] ACPI: HEST b77a4428 0000A8 (v01    AMI AMI HEST 00000000    =
  00000000)
[    0.000000] ACPI: BERT b77a44d0 000030 (v01    AMI AMI BERT 00000000    =
  00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 352MB HIGHMEM available.
[    0.000000] 879MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 36ffe000
[    0.000000]   low ram: 0 - 36ffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x36ffdfff]
[    0.000000]   HighMem  [mem 0x36ffe000-0x4d066fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x4d066fff]
[    0.000000] On node 0 totalpages: 315391
[    0.000000] free_area_init_node: node 0, pgdat c180da80, node_mem_map f6=
2e2020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   Normal zone: 1728 pages used for memmap
[    0.000000]   Normal zone: 221182 pages, LIFO batch:31
[    0.000000]   HighMem zone: 705 pages used for memmap
[    0.000000]   HighMem zone: 90217 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2 already used, trying 8
[    0.000000] IOAPIC[0]: Unable to change apic_id!
[    0.000000] IOAPIC[0]: apic_id 255, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x00099000-0x00099fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x000fffff]
[    0.000000] e820: [mem 0xbe200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.4-rc2 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f6f85000 s35456 r0 d21888 u57=
344
[    0.000000] pcpu-alloc: s35456 r0 d21888 u57344 alloc=3D14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7=
=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 313631
[    0.000000] Kernel command line: earlyprintk=3Dxen debug nofb console=3D=
tty console=3Dhvc0 xen-pciback.hide=3D(02:00.0)(02:00.1)(03:00.*)(04:00.0) =
loglevel=3D10
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] BUG: unable to handle kernel paging request at fe75f000
[    0.000000] IP: [<c184b741>] memblock_virt_alloc_internal+0x14e/0x188
[    0.000000] *pdpt =3D 0000000001a2c027 *pde =3D 0000000000000000=20
[    0.000000] Oops: 0002 [#1] SMP=20
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0upstream-08800=
-g3bf6f37 #1
[    0.000000] Hardware name: Supermicro X10SAE/X10SAE, BIOS 1.00 05/03/2013
[    0.000000] task: c17c69e0 ti: c17ba000 task.ti: c17ba000
[    0.000000] EIP: e019:[<c184b741>] EFLAGS: 00010046 CPU: 0
[    0.000000] EIP is at memblock_virt_alloc_internal+0x14e/0x188
[    0.000000] EAX: 00000000 EBX: fe75f000 ECX: 00008000 EDX: c18e1c48
[    0.000000] ESI: 00000000 EDI: fe75f000 EBP: c17bbdb8 ESP: c17bbd80
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
[    0.000000] CR0: 80050033 CR2: fe75f000 CR3: 01916000 CR4: 00042660
[    0.000000] Stack:
[    0.000000]  00008000 00000000 00000000 00000000 ffffffff 00000000 fffff=
fff 3e75f000
[    0.000000]  00000000 00008000 00000000 00001000 00000000 ffffffff c17bb=
e04 c184b91d
[    0.000000]  00001000 00000000 00000000 00000000 ffffffff 00000000 fffff=
fff c103b896
[    0.000000] Call Trace:
[    0.000000]  [<c184b91d>] memblock_virt_alloc_try_nid_nopanic+0xac/0xb4
[    0.000000]  [<c103b896>] ? xen_remap_exchanged_ptes+0x176/0x1f0
[    0.000000]  [<c15f5bb0>] ? _raw_spin_unlock_irqrestore+0x20/0x90
[    0.000000]  [<c185850d>] swiotlb_init_with_tbl+0x7d/0x18a
[    0.000000]  [<c15f0915>] xen_swiotlb_init+0x265/0x3d0
[    0.000000]  [<c182947d>] pci_xen_swiotlb_init+0x1b/0x2e
[    0.000000]  [<c182dd00>] pci_iommu_alloc+0x46/0x5a
[    0.000000]  [<c183a9d9>] mem_init+0xe/0x20f
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c1821aa9>] start_kernel+0x21a/0x40e
[    0.000000]  [<c1821700>] ? repair_env_string+0x5b/0x5b
[    0.000000]  [<c182136b>] i386_start_kernel+0x12e/0x131
[    0.000000]  [<c1826000>] xen_start_kernel+0x65c/0x667
[    0.000000] Code: ff ff 89 c1 8b 45 e8 8b 7d ec 89 4d e4 89 44 24 04 89 =
c8 89 3c 24 e8 1c 66 02 00 8b 4d e4 31 c0 8d 99 00 00 00 c0 8b 4d ec 89 df =
<f3> aa 89 d8 c7 04 24 00 00 00 00 8b 55 ec e8 3c 32 da ff 83 c4
[    0.000000] EIP: [<c184b741>] memblock_virt_alloc_internal+0x14e/0x188 S=
S:ESP e021:c17bbd80
[    0.000000] CR2: 00000000fe75f000
[    0.000000] ---[ end trace 54b16dbd029168a1 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
(XEN) Domain 0 crashed: rebooting machine in 5 seconds.
(XEN) Resetting with ACPI MEMORY or I/O RESET_REG.
=80=08 =08=1B[2J=1B[1;1H=1B[1;1H=80=08 =08=1B[01;00H=1B[0m=1B[2;37;40mIniti=
alizing Intel(R) Boot Agent GE v1.3.22                                     =
=1B[02;00HPXE 2.1 Build 086 (WfM 2.0)                                      =
               =1B[03;00HPress Ctrl+S to enter the Setup Menu.             =
                              =1B[04;00H                                   =
                                             =1B[05;00H                    =
                                                            =1B[06;00H     =
                                                                           =
=1B[07;00H                                                                 =
               =1B[08;00H                                                  =
                              =1B[09;00H                                   =
                                             =1B[10;00H                    =
                                                            =1B[11;00H     =
                                                                           =
=1B[12;00H                                                                 =
               =1B[13;00H                                                  =
                              =1B[14;00H                                   =
                                             =1B[15;00H                    =
                                                            =1B[16;00H     =
                                                                           =
=1B[17;00H                                                                 =
               =1B[18;00H                                                  =
                              =1B[19;00H                                   =
                                             =1B[20;00H                    =
                                                            =1B[21;00H     =
                                                                           =
=1B[22;00H                                                                 =
               =1B[23;00H                                                  =
                              =1B[24;00H                                   =
                                            =1B[24;00H=1B[03;39H=1B[03;00HP=
ress Ctrl+S to enter the Setup Menu..                                      =
    =1B[03;39H=1B[03;39H=1B[03;39H=1B[03;39H=1B[03;39H=1B[03;39H=1B[03;39H=
=1B[03;39H=1B[03;39H=1B[03;39H=1B[03;39H=1B[03;39H=80=08 =08=1B[2J=1B[1;1H=
=1B[1;1H=80=08 =08=1B[01;00HInitializing Intel(R) Boot Agent GE v1.3.22    =
                                 =1B[02;00HPXE 2.1 Build 086 (WfM 2.0)     =
                                                =1B[03;00H                 =
                                                               =1B[04;00H  =
                                                                           =
   =1B[05;00HInitializing Intel(R) Boot Agent GE v1.3.22                   =
                  =1B[06;00HPXE 2.1 Build 086 (WfM 2.0)                    =
                                 =1B[07;00HPress Ctrl+S to enter the Setup =
Menu.                                           =1B[08;00H                 =
                                                               =1B[09;00H  =
                                                                           =
   =1B[10;00H                                                              =
                  =1B[11;00H                                               =
                                 =1B[12;00H                                =
                                                =1B[13;00H                 =
                                                               =1B[14;00H  =
                                                                           =
   =1B[15;00H                                                              =
                  =1B[16;00H                                               =
                                 =1B[17;00H                                =
                                               =20

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=memblock
Content-Transfer-Encoding: quoted-printable

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/xen.gz... =1B[07;00Hok
Loading latest/vmlinuz... =1B[01;00Hok
Loading latest/initramfs.cpio.gz... =1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00=
H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[=
01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00=
H=1B[01;00H=1B[01;00H=1B[01;00H=1B[01;00Hok
 Xen 4.4-rc2
(XEN) Xen version 4.4-rc2 (konrad@(none)) (gcc (GCC) 4.4.4 20100503 (Red Ha=
t 4.4.4-2)) debug=3Dy Tue Jan 28 10:58:43 EST 2014
(XEN) Latest ChangeSet: Tue Jan 28 12:28:33 2014 +0800 git:85a50e1-dirty
(XEN) Bootloader: unknown
(XEN) Command line: com1=3D115200,8n1 console=3Dcom1,vga guest_loglvl=3Dall=
 tmem tmem_compress tmem_dedup dom0_mem=3D999M,max:1232M dom0_max_vcpus=3D3=
 cpufreq=3Dperformance,verbose loglvl=3Dall apic=3Ddebug
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: none; EDID transfer time: 0 seconds
(XEN)  EDID info not retrieved because no DDC retrieval method detected
(XEN) Disc information:
(XEN)  Found 1 MBR signatures
(XEN)  Found 1 EDD information structures
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 0000000000099c00 (usable)
(XEN)  0000000000099c00 - 00000000000a0000 (reserved)
(XEN)  00000000000e0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 00000000a58f1000 (usable)
(XEN)  00000000a58f1000 - 00000000a58f8000 (ACPI NVS)
(XEN)  00000000a58f8000 - 00000000a61b1000 (usable)
(XEN)  00000000a61b1000 - 00000000a6597000 (reserved)
(XEN)  00000000a6597000 - 00000000b74b4000 (usable)
(XEN)  00000000b74b4000 - 00000000b76cb000 (reserved)
(XEN)  00000000b76cb000 - 00000000b770c000 (usable)
(XEN)  00000000b770c000 - 00000000b77b9000 (ACPI NVS)
(XEN)  00000000b77b9000 - 00000000b7fff000 (reserved)
(XEN)  00000000b7fff000 - 00000000b8000000 (usable)
(XEN)  00000000bc000000 - 00000000be200000 (reserved)
(XEN)  00000000f8000000 - 00000000fc000000 (reserved)
(XEN)  00000000fec00000 - 00000000fec01000 (reserved)
(XEN)  00000000fed00000 - 00000000fed04000 (reserved)
(XEN)  00000000fed1c000 - 00000000fed20000 (reserved)
(XEN)  00000000fee00000 - 00000000fee01000 (reserved)
(XEN)  00000000ff000000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 000000023fe00000 (usable)
(XEN) ACPI: RSDP 000F0490, 0024 (r2 ALASKA)
(XEN) ACPI: XSDT B7794098, 00AC (r1 ALASKA    A M I  1072009 AMI     10013)
(XEN)  ACPI: DSDT B77941D8, AEDD (r2 ALASKA    A M I        0 INTL 20091112)
(XEN) ACPI: FACS B77B7080, 0040
(XEN) ACPI: APIC B779F1C8, 0092 (r3 ALASKA    A M I  1072009 AMI     10013)
(XEN) ACPI: FPDT B779F260, 0044 (r1 ALASKA    A M I  1072009 AMI     10013)
(XEN) ACPI: SSDT B779F2A8, 0540 (r1  PmRef  Cpu0Ist     3000 INTL 20051117)
(XEN) ACPI: SSDT B779F7E8, 0AD8 (r1  PmRef    CpuPm     3000 INTL 20051117)
(XEN) ACPI: SSDT B77A02C0, 02F2 (r1  PmRef  Cpu0Tst     3000 INTL 20051117)
(XEN) ACPI: SSDT B77A05B8, 0348 (r1  PmRef    ApTst     3000 INTL 20051117)
(XEN) ACPI: MCFG B77A0900, 003C (r1 ALASKA    A M I  1072009 MSFT       97)
(XEN) ACPI: HPET B77A0940, 0038 (r1 ALASKA    A M I  1072009 AMI.        5)
(XEN) ACPI: SSDT B77A0978, 036D (r1 SataRe SataTabl     1000 INTL 20091112)
(XEN) ACPI: SSDT B77A0CE8, 327D (r1 SaSsdt  SaSsdt      3000 INTL 20091112)
(XEN) ACPI: ASF! B77A3F68, 00A5 (r32 INTEL       HCG        1 TFSM    F4240)
(XEN) ACPI: DMAR B77A4010, 00B8 (r1 INTEL      HSW         1 INTL        1)
(XEN) ACPI: EINJ B77A40C8, 0130 (r1    AMI AMI EINJ        0             0)
(XEN) ACPI: ERST B77A41F8, 0230 (r1  AMIER AMI ERST        0             0)
(XEN) ACPI: HEST B77A4428, 00A8 (r1    AMI AMI HEST        0             0)
(XEN) ACPI: BERT B77A44D0, 0030 (r1    AMI AMI BERT        0             0)
(XEN) System RAM: 8046MB (8239752kB)
(XEN) No NUMA configuration found
(XEN) Faking a node at 0000000000000000-000000023fe00000
(XEN) Domain heap initialised
(XEN) found SMP MP-table at 000fd870
(XEN) DMI 2.7 present.
(XEN) Using APIC driver default
(XEN) ACPI: PM-Timer IO Port: 0x1808
(XEN) ACPI: v5 SLEEP INFO: control[0:0], status[0:0]
(XEN) ACPI: SLEEP INFO: pm1x_cnt[1804,0], pm1x_evt[1800,0]
(XEN) ACPI: 32/64X FACS address mismatch in FADT - b77b7080/000000000000000=
0, using 32
(XEN) ACPI:             wakeup_vec[b77b708c], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
(XEN) Processor #0 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
(XEN) Processor #2 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
(XEN) Processor #4 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
(XEN) Processor #6 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
(XEN) Processor #1 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
(XEN) Processor #3 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
(XEN) Processor #5 7:12 APIC version 21
(XEN) ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
(XEN) Processor #7 7:12 APIC version 21
(XEN) ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
(XEN) ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) ACPI: IRQ9 used by override.
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x8086a701 base: 0xfed00000
(XEN) Xen ERST support is initialized.
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) SMP: Allowing 8 CPUs (0 hotplug CPUs)
(XEN) IRQ limits: 24 GSI, 1528 MSI/MSI-X
(XEN) Switched to APIC driver x2apic_cluster.
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 3400.099 MHz processor.
(XEN) Initing memory sharing.
(XEN) xstate_init: using cntxt_size: 0x340 and states: 0x: BCAST 1 SER 0 CM=
CI 1 firstbank 0 extended MCE MSR 0
(XEN) Intel machine check reporting enabled
(XEN) PCI: MCFG configuration 0: base f8000000 segment 0000 buses 00 - 3f
(XEN) PCI: MCFG area at f8000000 reserved in E820
(XEN) PCI: Using MCFG for segment 0000 bus 00-3f
(XEN) Intel VT-d iommu 0 supported page sizes: 4kB.
(XEN) Intel VT-d iommu 1 supported page sizes: 4kB.
(XEN) Intel VT-d Snoop Control not enabled.
(XEN) Intel VT-d Dom0 DMA Passthrough not enabled.
(XEN) Intel VT-d Queued Invalidation enabled.
(XEN) Intel VT-d Interrupt Remapping enabled.
(XEN) Intel VT-d Shared EPT tables not enabled.
(XEN) 02:00.0: alloced (179)
(XEN) 02:00.0: alloced (189) ffff83023456cf70,pdev ffff8302345ef0d0
(XEN) 02:00.1: alloced (179)
(XEN) 02:00.1: alloced (189) ffff8302345ef250,pdev ffff8302345ef190
(XEN) 04:00.0: alloced (179)
(XEN) 04:00.0: alloced (189) ffff8302345ef520,pdev ffff8302345ef460
(XEN) 05:00.0: status=3D0010 (alloc_pdev+0xb7/0x360 wants 11)
(XEN) 05:00.0: pos=3D60
(XEN) 05:00.0: id=3D0d
(XEN) 05:00.0: pos=3Da0
(XEN) 05:00.0: id=3D01
(XEN) 05:00.0: pos=3D00
(XEN) 05:00.0: no cap 11
(XEN) 08:00.0: alloced (179)
(XEN) 08:00.0: alloced (189) ffff8302345efeb0,pdev ffff8302345efdf0
(XEN) I/O virtualisation enabled
(XEN)  - Dom0 mode: Relaxed
(XEN) Interrupt remapping enabled
(XEN) Enabled directed EOI wit IRQs
(XEN)  -> Using old ACK method
(XEN) ..TIMER: vector=3D0xF0 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
(XEN) TSC deadline timer enabled
(XEN) Platform timer is 14.318MHz HPET
(XEN) Allocated console ring of 64 KiB.
(XEN) mwait-idle: MWAIT substates: 0x42120
(XEit-idle: lapic_timer_reliable_states 0xffffffff
(XEN) VMX: Supported advanced features:
(XEN)  - APIC MMIO access virtualisati)  - VMCS shadowing
(XEN) HVM: ASIDs enabled.
(XEN) HVM: VMX enabled
(XEN) HVM: Hardware Assisted Paging (HAP) detected
(XEN) HVM: HAP page sizes: 4kB, 2MB, 1GB
(XEN) Brought up 8 CPUs
(XEN) tmem: initialized comp=3D1 dedup=3D1 tze=3D0
(XEN) ACPI sleep modes: S3
(XEN) mcheck_poll: Machine check polling timer started.
(XEN) *** LOADING DOMAIN 0 ***
(XEN) elf_parse_binary: phdr: paddr=3D0x1000000 memsz=3D0x7ba000
(XEN) elf_parse_binary: phdr: paddr=3D0x17ba000 memsz=3D0x4c5000
(XEN) elf_parse_binary: memory: 0x1000000 -> 0x1c7f000
(XEN) elf_xen_parse_note: GUEST_OS =3D "linux"
(XEN) elf_xen_parse_note: GUEST_VERSION =3D "2.6"
(XEN) elf_xen_parse_note: XEN_VERSION =3D "xen-3.0"
(XEN) elf_xen_parse_note: VIRT_BASE =3D 0xc0000000
(XEN) elf_xen_parse_note: ENTRY =3D 0xc182122c
(XEN) elf_xen_parse_note: HYPERCALL_PAGE =3D 0xc1001000
(XEN) elf_xen_parse_note: FEATURES =3D "!writable_page_tables|pae_pgdir_abo=
ve_4gb"
(XEN) elf_xen_parse_note: SUPPORTED_FEATURES =3D 0x801
(XEN) elf_xen_parse_note: PAE_MODE =3D "yes"
(XEN) elf_xen_parse_note: LOADER =3D "generic"
(XEN) elf_xen_parse_note: unknown xen elf note (0xd)
(XEN) elf_xen_parse_note: SUSPEND_CANCEL =3D 0x1
(XEN) elf_xen_parse_note: HV_START_LOW =3D 0xf5800000
(XEN) elf_xen_parse_note: PADDR_OFFSET =3D 0x0
(XEN) elf_xen_addr_calc_check: addresses:
(XEN)     virt_base        =3D 0xc0000000
(XEN)     elf_paddr_offset =3D 0x0
(XEN)     virt_offset      =3D 0xc0000000
(XEN)     virt_kstart      =3D 0xc1000000
(XEN)     virt_kend        =3D 0xc1c7f000
(XEN)     virt_entry       =3D 0xc182122c
(XEN)     p2m_base         =3D 0xffffffffffffffff
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 32-bit, PAE, lsb, paddr 0x1000000 -> 0x1c7f000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000230000000->0000000234000000 (219014 pages to b=
e allocated)
(XEN)  Init. ramdisk: 000000023ae86000->000000023fdffbc9
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: 00000000c1000000->00000000c1c7f000
(XEN)  Init. ramdisk: 00000000c1c7f000->00000000c6bf8bc9
(XEN)  Phys-Mach map: 00000000c6bf9000->00000000c6cf2c00
(XEN)  Start info:    00000000c6cf3000->00000000c6cf34b4
(XEN)  Page tables:   00000000c6cf4000->00000000c6d31000
(XEN)  Boot stack:    00000000c6d31000->00000000c6d32000
(XEN)  TOTAL:         00000000c0000000->00000000c7000000
(XEN)  ENTRY ADDRESS: 00000000c182122c
(XEN) Dom0 has maximum 3 VCPUs
(XEN) elf_load_binary: phdr 0 at 0xc1000000 -> 0xc17ba000
(XEN) elf_load_binary: phdr 1 at 0xc17ba000 -> 0xc1913000
(XEN) Scrubbing Free RAM: .................................................=
=2E...................done.
(XEN) Initial low memory virq threshold set at 0x4000 pages.
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEswitch input to Xen)
(XEN) Freed 272kB init memory.
mapping kernel into physical memory
about to get started...
[    0.000000] Reserving virtual address space above 0xff400000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0upstream-08800-g3bf6f37 (konrad@build-ex=
ternal.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) =
#1 SMP Tue Jan 28 11:29:28 EST 2014
[    0.000000] Freeing 99-100 pfn range: 103 pages freed
[    0.000000] Released 103 pages of unused memory
[    0.000000] Set 298846 page(s) to 1-1 mapping
[    0.000000] Populating 3e700-3e767 pfn range: 103 pages added
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x0000000000098fff] usable
[    0.000000] Xen: [mem 0x0000000000099c00-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000004d066fff] usable
[    0.000000] Xen: [mem 0x000000004d067000-0x00000000a58f0fff] unusable
[    0.000000] Xen: [mem 0x00000000a58f1000-0x00000000a58f7fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000a58f8000-0x00000000a61b0fff] unusable
[    0.000000] Xen: [mem 0x00000000a61b1000-0x00000000a6596fff] reserved
[    0.000000] Xen: [mem 0x00000000a6597000-0x00000000b74b3fff] unusable
[    0.000000] Xen: [mem 0x00000000b74b4000-0x00000000b76cafff] reserved
[    0.000000] Xen: [mem 0x00000000b76cb000-0x00000000b770bfff] unusable
[    0.000000] Xen: [mem 0x00000000b770c000-0x00000000b77b8fff] ACPI NVS
[    0.000000] Xen: [mem 0x00000000b77b9000-0x00000000b7ffefff] reserved
[    0.000000] Xen: [mem 0x00000000b7fff000-0x00000000b7ffffff] unusable
[    0.000000] Xen: [mem 0x00000000bc000000-0x00000000be1fffff] reserved
[    0.000000] Xen: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] Xen: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] Xen: [mem 0x0000000100000000-0x000000023fdfffff] unusable
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Supermicro X10SAE/X10SAE, BIOS 1.00 05/03/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x4d067 max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x077fefff]
[    0.000000] Base memory trampoline at [c0095000] 95000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x36c00000-0x36dfffff]
[    0.000000]  [mem 0x36c00000-0x36dfffff] page 4k
[    0.000000] BRK [0x01a33000, 0x01a33fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x34000000-0x36bfffff]
[    0.000000]  [mem 0x34000000-0x36bfffff] page 4k
[    0.000000] BRK [0x01a34000, 0x01a34fff] PGTABLE
[    0.000000] BRK [0x01a35000, 0x01a35fff] PGTABLE
[    0.000000] BRK [0x01a36000, 0x01a36fff] PGTABLE
[    0.000000] BRK [0x01a37000, 0x01a37fff] PGTABLE
[    0.000000] BRK [0x01a38000, 0x01a38fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x33ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x36e00000-0x36ffdfff]
[    0.000000]  [mem 0x36e00000-0x36ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x01c7f000-0x06bf8fff]
[    0.000000] ACPI: RSDP 000f0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT b7794098 0000AC (v01 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: FACP b779f0b8 00010C (v05 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: DSDT b77941d8 00AEDD (v02 ALASKA    A M I 00000000 INT=
L 20091112)
[    0.000000] ACPI: FACS b77b7080 000040
[    0.000000] ACPI: APIC b779f1c8 000092 (v03 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: FPDT b779f260 000044 (v01 ALASKA    A M I 01072009 AMI=
  00010013)
[    0.000000] ACPI: SSDT b779f2a8 000540 (v01  PmRef  Cpu0Ist 00003000 INT=
L 20051117)
[    0.000000] ACPI: SSDT b779f7e8 000AD8 (v01  PmRef    CpuPm 00003000 INT=
L 20051117)
[    0.000000] ACPI: SSDT b77a02c0 0002F2 (v01  PmRef  Cpu0Tst 00003000 INT=
L 20051117)
[    0.000000] ACPI: SSDT b77a05b8 000348 (v01  PmRef    ApTst 00003000 INT=
L 20051117)
[    0.000000] ACPI: MCFG b77a0900 00003C (v01 ALASKA    A M I 01072009 MSF=
T 00000097)
[    0.000000] ACPI: HPET b77a0940 000038 (v01 ALASKA    A M I 01072009 AMI=
=2E 00000005)
[    0.000000] ACPI: SSDT b77a0978 00036D (v01 SataRe SataTabl 00001000 INT=
L 20091112)
[    0.000000] ACPI: SSDT b77a0ce8 00327D (v01 SaSsdt  SaSsdt  00003000 INT=
L 20091112)
[    0.000000] ACPI: ASF! b77a3f68 0000A5 (v32 INTEL       HCG 00000001 TFS=
M 000F4240)
[    0.000000] ACPI: XMAR b77a4010 0000B8 (v01 INTEL      HSW  00000001 INT=
L 00000001)
[    0.000000] ACPI: EINJ b77a40c8 000130 (v01    AMI AMI EINJ 00000000    =
  00000000)
[    0.000000] ACPI: ERST b77a41f8 000230 (v01  AMIER AMI ERST 00000000    =
  00000000)
[    0.000000] ACPI: HEST b77a4428 0000A8 (v01    AMI AMI HEST 00000000    =
  00000000)
[    0.000000] ACPI: BERT b77a44d0 000030 (v01    AMI AMI BERT 00000000    =
  00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 352MB HIGHMEM available.
[    0.000000] 879MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 36ffe000
[    0.000000]   low ram: 0 - 36ffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x36ffdfff]
[    0.000000]   HighMem  [mem 0x36ffe000-0x4d066fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x4d066fff]
[    0.000000] On node 0 totalpages: 315391
[    0.000000] free_area_init_node: node 0, pgdat c180da80, node_mem_map f6=
2e2020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   Normal zone: 1728 pages used for memmap
[    0.000000]   Normal zone: 221182 pages, LIFO batch:31
[    0.000000]   HighMem zone: 705 pages used for memmap
[    0.000000]   HighMem zone: 90217 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2 already used, trying 8
[    0.000000] IOAPIC[0]: Unable to change apic_id!
[    0.000000] IOAPIC[0]: apic_id 255, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x00099000-0x00099fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x000fffff]
[    0.000000] e820: [mem 0xbe200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.4-rc2 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f6f85000 s35456 r0 d21888 u57=
344
[    0.000000] pcpu-alloc: s35456 r0 d21888 u57344 alloc=3D14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7=
=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 313631
[    0.000000] Kernel command line: earlyprintk=3Dxen debug nofb console=3D=
tty console=3Dhvc0 xen-pciback.hide=3D(02:00.0)(02:00.1)(03:00.*)(04:00.0) =
loglevel=3D10
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] BUG: unable to handle kernel paging request at fe75f000
[    0.000000] IP: [<c184b741>] memblock_virt_alloc_internal+0x14e/0x188
[    0.000000] *pdpt =3D 0000000001a2c027 *pde =3D 0000000000000000=20
[    0.000000] Oops: 0002 [#1] SMP=20
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0upstream-08800=
-g3bf6f37 #1
[    0.000000] Hardware name: Supermicro X10SAE/X10SAE, BIOS 1.00 05/03/2013
[    0.000000] task: c17c69e0 ti: c17ba000 task.ti: c17ba000
[    0.000000] EIP: e019:[<c184b741>] EFLAGS: 00010046 CPU: 0
[    0.000000] EIP is at memblock_virt_alloc_internal+0x14e/0x188
[    0.000000] EAX: 00000000 EBX: fe75f000 ECX: 00008000 EDX: c18e1c48
[    0.000000] ESI: 00000000 EDI: fe75f000 EBP: c17bbdb8 ESP: c17bbd80
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
[    0.000000] CR0: 80050033 CR2: fe75f000 CR3: 01916000 CR4: 00042660
[    0.000000] Stack:
[    0.000000]  00008000 00000000 00000000 00000000 ffffffff 00000000 fffff=
fff 3e75f000
[    0.000000]  00000000 00008000 00000000 00001000 00000000 ffffffff c17bb=
e04 c184b91d
[    0.000000]  00001000 00000000 00000000 00000000 ffffffff 00000000 fffff=
fff c103b896
[    0.000000] Call Trace:
[    0.000000]  [<c184b91d>] memblock_virt_alloc_try_nid_nopanic+0xac/0xb4
[    0.000000]  [<c103b896>] ? xen_remap_exchanged_ptes+0x176/0x1f0
[    0.000000]  [<c15f5bb0>] ? _raw_spin_unlock_irqrestore+0x20/0x90
[    0.000000]  [<c185850d>] swiotlb_init_with_tbl+0x7d/0x18a
[    0.000000]  [<c15f0915>] xen_swiotlb_init+0x265/0x3d0
[    0.000000]  [<c182947d>] pci_xen_swiotlb_init+0x1b/0x2e
[    0.000000]  [<c182dd00>] pci_iommu_alloc+0x46/0x5a
[    0.000000]  [<c183a9d9>] mem_init+0xe/0x20f
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c15f8e00>] ? vmalloc_fault+0x30/0x1c0
[    0.000000]  [<c1821aa9>] start_kernel+0x21a/0x40e
[    0.000000]  [<c1821700>] ? repair_env_string+0x5b/0x5b
[    0.000000]  [<c182136b>] i386_start_kernel+0x12e/0x131
[    0.000000]  [<c1826000>] xen_start_kernel+0x65c/0x667
[    0.000000] Code: ff ff 89 c1 8b 45 e8 8b 7d ec 89 4d e4 89 44 24 04 89 =
c8 89 3c 24 e8 1c 66 02 00 8b 4d e4 31 c0 8d 99 00 00 00 c0 8b 4d ec 89 df =
<f3> aa 89 d8 c7 04 24 00 00 00 00 8b 55 ec e8 3c 32 da ff 83 c4
[    0.000000] EIP: [<c184b741>] memblock_virt_alloc_internal+0x14e/0x188 S=
S:ESP e021:c17bbd80
[    0.000000] CR2: 00000000fe75f000
[    0.000000] ---[ end trace 54b16dbd029168a1 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
(XEN) Domain 0 crashed: rebooting machine in 5 seconds.
(XEN) Resetting with ACPI MEMORY or I/O RESET_REG.

--BXVAT5kNtrzKuDFl--
