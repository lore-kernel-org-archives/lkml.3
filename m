Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaICLKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:10:03 -0400
Received: from services.gouders.net ([141.101.32.176]:41271 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaICLJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:09:58 -0400
X-Greylist: delayed 676 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 07:09:57 EDT
From: Dirk Gouders <dirk@gouders.net>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] Bisected Problem with LSI PCI FC Adapter
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Wed, 03 Sep 2014 12:57:49 +0200
Message-ID: <ghiol53r9u.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Tyan VX50 (B4985) I ran into problems when updating the kernel: the
PCI FC Adapter is no longer recognized.

Actually, this machine caused more problems, because I was not able to
get it run with fedora, debian or ubuntu but I am somewhat sure that has
to do with grub2 and now I am (again) running Gentoo on it, booting with
legacy grub.  So, I hope that has nothing to do with the PCI FC Adapter
not being recognized.

I bisected this PCI problem to commit 1820ffdccb9b4398 (PCI: Make sure
bus number resources stay within their parents bounds).

With this commit the "bridge configuration invalid..." message is
triggered; I'll attach the dmesg output.


Please note: unfortunately, I am in a hurry to get the VMs on that
server back running this afternoon and then cannot easily test fixes
that need reboots.  It would be nice if someone could reproduce this
problem on a test machine, otherwise I have to test at night or on
weekends...

Dirk

------------------------------------------------------------------------
[    0.000000] Linux version 3.14.0-rc1-00005-g1820ffd (root@quad) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #18 SMP Wed Sep 3 12:33:21 CEST 2014
[    0.000000] Command line: root=/dev/sda2
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000997ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000099800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000ca000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007ffe9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007ffea000-0x000000007fffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x00000000cfbfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfc00000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000a2fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: NVIDIA  CK8 /Tyan Transport VX50-B4985, BIOS TYAN Transport VX50 B4985 BIOS V3.01.B30 11/27/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xa30000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000a30000000 aka 41728M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfc00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f7770-0x000f777f] mapped at [ffff8800000f7770]
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x018f5000, 0x018f5fff] PGTABLE
[    0.000000] BRK [0x018f6000, 0x018f6fff] PGTABLE
[    0.000000] BRK [0x018f7000, 0x018f7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2fe00000-0xa2fffffff]
[    0.000000]  [mem 0xa2fe00000-0xa2fffffff] page 2M
[    0.000000] BRK [0x018f8000, 0x018f8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2c000000-0xa2fdfffff]
[    0.000000]  [mem 0xa2c000000-0xa2fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xa00000000-0xa2bffffff]
[    0.000000]  [mem 0xa00000000-0xa2bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7ffdffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7ffdffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x80000000-0xcfbfffff]
[    0.000000]  [mem 0x80000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfbfffff] page 2M
[    0.000000] BRK [0x018f9000, 0x018f9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x9ffffffff]
[    0.000000]  [mem 0x100000000-0x9ffffffff] page 1G
[    0.000000] ACPI: RSDP 00000000000f77f0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 000000007ffe0aab 000038 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007ffe4c98 000074 (v01 NVIDIA CK8S     06040000 PTL_ 000F4240)
[    0.000000] ACPI: DSDT 000000007ffe0ae3 0041B5 (v01 NVIDIA      CK8 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007ffeafc0 000040
[    0.000000] ACPI: SSDT 000000007ffe4d0c 005084 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SPCR 000000007ffe9d90 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: APIC 000000007ffe9de0 0001F8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007ffe9fd8 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] Number of physical nodes 8
[    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000130000000
[    0.000000] Node 1 MemBase 0000000130000000 Limit 0000000230000000
[    0.000000] Node 2 MemBase 0000000230000000 Limit 0000000330000000
[    0.000000] Node 3 MemBase 0000000330000000 Limit 0000000430000000
[    0.000000] Node 4 MemBase 0000000430000000 Limit 0000000530000000
[    0.000000] Node 5 MemBase 0000000530000000 Limit 0000000630000000
[    0.000000] Node 6 MemBase 0000000630000000 Limit 0000000830000000
[    0.000000] Node 7 MemBase 0000000830000000 Limit 0000000a30000000
[    0.000000] BSP APIC ID: 04
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000] Initmem setup node 1 [mem 0x130000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22fffc000-0x22fffffff]
[    0.000000] Initmem setup node 2 [mem 0x230000000-0x32fffffff]
[    0.000000]   NODE_DATA [mem 0x32fffc000-0x32fffffff]
[    0.000000] Initmem setup node 3 [mem 0x330000000-0x42fffffff]
[    0.000000]   NODE_DATA [mem 0x42fffc000-0x42fffffff]
[    0.000000] Initmem setup node 4 [mem 0x430000000-0x52fffffff]
[    0.000000]   NODE_DATA [mem 0x52fffc000-0x52fffffff]
[    0.000000] Initmem setup node 5 [mem 0x530000000-0x62fffffff]
[    0.000000]   NODE_DATA [mem 0x62fffc000-0x62fffffff]
[    0.000000] Initmem setup node 6 [mem 0x630000000-0x82fffffff]
[    0.000000]   NODE_DATA [mem 0x82fffc000-0x82fffffff]
[    0.000000] Initmem setup node 7 [mem 0x830000000-0xa2fffffff]
[    0.000000]   NODE_DATA [mem 0xa2fffa000-0xa2fffdfff]
[    0.000000] [ffffea0004280000-ffffea00043fffff] potential offnode page_structs
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012be00000-ffff88012f7fffff] on node 0
[    0.000000] [ffffea0007a80000-ffffea0007bfffff] potential offnode page_structs
[    0.000000]  [ffffea0004400000-ffffea0007bfffff] PMD -> [ffff88022be00000-ffff88022f5fffff] on node 1
[    0.000000] [ffffea000b280000-ffffea000b3fffff] potential offnode page_structs
[    0.000000]  [ffffea0007c00000-ffffea000b3fffff] PMD -> [ffff88032be00000-ffff88032f5fffff] on node 2
[    0.000000] [ffffea000ea80000-ffffea000ebfffff] potential offnode page_structs
[    0.000000]  [ffffea000b400000-ffffea000ebfffff] PMD -> [ffff88042be00000-ffff88042f5fffff] on node 3
[    0.000000] [ffffea0012280000-ffffea00123fffff] potential offnode page_structs
[    0.000000]  [ffffea000ec00000-ffffea00123fffff] PMD -> [ffff88052be00000-ffff88052f5fffff] on node 4
[    0.000000] [ffffea0015a80000-ffffea0015bfffff] potential offnode page_structs
[    0.000000]  [ffffea0012400000-ffffea0015bfffff] PMD -> [ffff88062be00000-ffff88062f5fffff] on node 5
[    0.000000] [ffffea001ca80000-ffffea001cbfffff] potential offnode page_structs
[    0.000000]  [ffffea0015c00000-ffffea001cbfffff] PMD -> [ffff880827e00000-ffff88082edfffff] on node 6
[    0.000000]  [ffffea001cc00000-ffffea0023bfffff] PMD -> [ffff880a27600000-ffff880a2e5fffff] on node 7
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0xa2fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffdffff]
[    0.000000]   node   0: [mem 0x80000000-0xcfbfffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000]   node   1: [mem 0x130000000-0x22fffffff]
[    0.000000]   node   2: [mem 0x230000000-0x32fffffff]
[    0.000000]   node   3: [mem 0x330000000-0x42fffffff]
[    0.000000]   node   4: [mem 0x430000000-0x52fffffff]
[    0.000000]   node   5: [mem 0x530000000-0x62fffffff]
[    0.000000]   node   6: [mem 0x630000000-0x82fffffff]
[    0.000000]   node   7: [mem 0x830000000-0xa2fffffff]
[    0.000000] On node 0 totalpages: 1047416
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11578 pages used for memmap
[    0.000000]   DMA32 zone: 846816 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 6 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 7 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x00099000-0x00099fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000c9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000ca000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffe0000-0x7ffe9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffea000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfc00000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfff7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfff80000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:8
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s79552 r8192 d22848 u524288
[    0.000000] pcpu-alloc: s79552 r8192 d22848 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 [1] 04 05 06 07 
[    0.000000] pcpu-alloc: [2] 08 09 10 11 [3] 12 13 14 15 
[    0.000000] pcpu-alloc: [4] 16 17 18 19 [5] 20 21 22 23 
[    0.000000] pcpu-alloc: [6] 24 25 26 27 [7] 28 29 30 31 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 10341233
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ d0000000 size 64 MB
[    0.000000] Node 1: aperture @ d0000000 size 64 MB
[    0.000000] Node 2: aperture @ d0000000 size 64 MB
[    0.000000] Node 3: aperture @ d0000000 size 64 MB
[    0.000000] Node 4: aperture @ d0000000 size 64 MB
[    0.000000] Node 5: aperture @ d0000000 size 64 MB
[    0.000000] Node 6: aperture @ d0000000 size 64 MB
[    0.000000] Node 7: aperture @ d0000000 size 64 MB
[    0.000000] Memory: 41283204K/41938400K available (4367K kernel code, 605K rwdata, 2328K rodata, 932K init, 892K bss, 655196K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:936 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1908.651 MHz processor
[    0.000018] Calibrating delay loop (skipped), value calculated using timer frequency.. 3817.30 BogoMIPS (lpj=7634604)
[    0.000319] pid_max: default: 32768 minimum: 301
[    0.009350] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.059361] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.083758] Mount-cache hash table entries: 256
[    0.084628] tseg: 00cfc00000
[    0.084633] CPU: Physical Processor ID: 0
[    0.084781] CPU: Processor Core ID: 0
[    0.084927] mce: CPU supports 6 MCE banks
[    0.085082] LVT offset 0 assigned for vector 0xf9
[    0.085235] process: using AMD E400 aware idle routine
[    0.085393] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
tlb_flushall_shift: 4
[    0.085960] Freeing SMP alternatives memory: 20K (ffffffff8180f000 - ffffffff81814000)
[    0.086297] Switched APIC routing to physical flat.
[    0.086886] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.126797] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 8347 HE (fam: 10, model: 02, stepping: 03)
[    0.233914] Performance Events: AMD PMU driver.
[    0.234114] ... version:                0
[    0.234265] ... bit width:              48
[    0.234400] ... generic registers:      4
[    0.234546] ... value mask:             0000ffffffffffff
[    0.234694] ... max period:             00007fffffffffff
[    0.234842] ... fixed-purpose events:   0
[    0.234976] ... event mask:             000000000000000f
[    0.236512] x86: Booting SMP configuration:
[    0.236693] .... node  #0, CPUs:        #1  #2  #3
[    0.278765] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.428591] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.579350] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.731545] .... node  #4, CPUs:   #16 #17 #18 #19
[    0.883678] .... node  #5, CPUs:   #20 #21 #22 #23
[    1.035899] .... node  #6, CPUs:   #24 #25 #26 #27
[    1.188041] .... node  #7, CPUs:   #28 #29 #30 #31
[    1.339624] x86: Booted up 8 nodes, 32 CPUs
[    1.339917] smpboot: Total of 32 processors activated (122204.77 BogoMIPS)
[    1.361939] devtmpfs: initialized
[    1.362749] PM: Registering ACPI NVS region [mem 0x7ffea000-0x7fffffff] (90112 bytes)
[    1.364210] NET: Registered protocol family 16
[    1.364982] cpuidle: using governor ladder
[    1.365127] cpuidle: using governor menu
[    1.365281] node 0 link 1: io port [1000, 3fff]
[    1.365285] node 1 link 1: io port [b000, bfff]
[    1.365288] node 1 link 1: io port [9000, 9fff]
[    1.365291] TOM: 00000000d0000000 aka 3328M
[    1.365440] node 0 link 1: mmio [d4000000, dbffffff]
[    1.365444] node 1 link 1: mmio [dc000000, dc3fffff]
[    1.365447] node 0 link 1: mmio [a0000, bffff]
[    1.365450] node 0 link 1: mmio [e0000000, e7ffffff]
[    1.365452] node 1 link 1: mmio [e8000000, efffffff]
[    1.365454] TOM2: 0000000a30000000 aka 41728M
[    1.365611] bus: [bus 00-7f] on node 0 link 1
[    1.365613] bus: 00 [io  0x0000-0x8fff]
[    1.365615] bus: 00 [io  0xc000-0xffff]
[    1.365616] bus: 00 [io  0xa000-0xafff]
[    1.365618] bus: 00 [mem 0xd0000000-0xdbffffff]
[    1.365619] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.365620] bus: 00 [mem 0xdc400000-0xe7ffffff]
[    1.365621] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.365623] bus: 00 [mem 0xa30000000-0xfcffffffff]
[    1.365624] bus: [bus 80-ff] on node 1 link 1
[    1.365626] bus: 80 [io  0xb000-0xbfff]
[    1.365627] bus: 80 [io  0x9000-0x9fff]
[    1.365628] bus: 80 [mem 0xdc000000-0xdc3fffff]
[    1.365629] bus: 80 [mem 0xe8000000-0xefffffff]
[    1.365775] ACPI: bus type PCI registered
[    1.366154] PCI: Using configuration type 1 for base access
[    1.366310] PCI: Using configuration type 1 for extended access
[    1.382622] bio: create slab <bio-0> at 0
[    1.383716] ACPI: Added _OSI(Module Device)
[    1.383862] ACPI: Added _OSI(Processor Device)
[    1.384018] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.384165] ACPI: Added _OSI(Processor Aggregator Device)
[    1.400068] ACPI: Interpreter enabled
[    1.400286] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    1.400627] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131218/hwxface-580)
[    1.400974] ACPI: (supports S0 S1 S4 S5)
[    1.401121] ACPI: Using IOAPIC for interrupt routing
[    1.401387] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.401947] ACPI: No dock devices found.
[    1.422160] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
[    1.422378] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.422549] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.423048] acpi PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000ca000-0x000fffff])
[    1.423450] PCI host bridge to bus 0000:00
[    1.423602] pci_bus 0000:00: root bus resource [bus 00-07]
[    1.423753] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.423908] pci_bus 0000:00: root bus resource [io  0x0d00-0x3fff]
[    1.424058] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.424200] pci_bus 0000:00: root bus resource [mem 0xd4000000-0xdbffffff]
[    1.424381] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    1.424685] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    1.424734] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.425052] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    1.425062] pci 0000:00:01.1: reg 0x10: [io  0x0000-0x001f]
[    1.425081] pci 0000:00:01.1: reg 0x20: [io  0xa000-0xa03f]
[    1.425088] pci 0000:00:01.1: reg 0x24: [io  0xa040-0xa07f]
[    1.425133] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.425330] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    1.425346] pci 0000:00:02.0: reg 0x10: [mem 0xd4000000-0xd4000fff]
[    1.425391] pci 0000:00:02.0: supports D1 D2
[    1.425398] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.425499] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.425763] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    1.425772] pci 0000:00:02.1: reg 0x10: [mem 0xd4001000-0xd40010ff]
[    1.425823] pci 0000:00:02.1: supports D1 D2
[    1.425833] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.425936] pci 0000:00:02.1: System wakeup disabled by ACPI
[    1.426208] pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
[    1.426239] pci 0000:00:06.0: reg 0x20: [io  0x1400-0x140f]
[    1.426433] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.426445] pci 0000:00:07.0: reg 0x10: [io  0x1440-0x1447]
[    1.426449] pci 0000:00:07.0: reg 0x14: [io  0x1434-0x1437]
[    1.426454] pci 0000:00:07.0: reg 0x18: [io  0x1438-0x143f]
[    1.426459] pci 0000:00:07.0: reg 0x1c: [io  0x1430-0x1433]
[    1.426463] pci 0000:00:07.0: reg 0x20: [io  0x1410-0x141f]
[    1.426468] pci 0000:00:07.0: reg 0x24: [mem 0xd4002000-0xd4002fff]
[    1.426709] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.426720] pci 0000:00:08.0: reg 0x10: [io  0x1458-0x145f]
[    1.426739] pci 0000:00:08.0: reg 0x14: [io  0x144c-0x144f]
[    1.426749] pci 0000:00:08.0: reg 0x18: [io  0x1450-0x1457]
[    1.426753] pci 0000:00:08.0: reg 0x1c: [io  0x1448-0x144b]
[    1.426763] pci 0000:00:08.0: reg 0x20: [io  0x1420-0x142f]
[    1.426772] pci 0000:00:08.0: reg 0x24: [mem 0xd4003000-0xd4003fff]
[    1.426997] pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
[    1.427084] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.427349] pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
[    1.427358] pci 0000:00:0a.0: reg 0x10: [mem 0xd4004000-0xd4004fff]
[    1.427376] pci 0000:00:0a.0: reg 0x14: [io  0x1460-0x1467]
[    1.427400] pci 0000:00:0a.0: supports D1 D2
[    1.427421] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.427536] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.427799] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.427844] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.428035] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.428087] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.428303] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.428346] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.428568] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.428630] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.428852] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.429069] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.429266] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.429461] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.429666] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.429896] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    1.430115] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    1.430318] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    1.430539] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    1.430765] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    1.430957] pci 0000:00:1a.0: [1022:1200] type 00 class 0x060000
[    1.431235] pci 0000:00:1a.1: [1022:1201] type 00 class 0x060000
[    1.431596] pci 0000:00:1a.2: [1022:1202] type 00 class 0x060000
[    1.431835] pci 0000:00:1a.3: [1022:1203] type 00 class 0x060000
[    1.432043] pci 0000:00:1a.4: [1022:1204] type 00 class 0x060000
[    1.432274] pci 0000:00:1b.0: [1022:1200] type 00 class 0x060000
[    1.432491] pci 0000:00:1b.1: [1022:1201] type 00 class 0x060000
[    1.432690] pci 0000:00:1b.2: [1022:1202] type 00 class 0x060000
[    1.432893] pci 0000:00:1b.3: [1022:1203] type 00 class 0x060000
[    1.433103] pci 0000:00:1b.4: [1022:1204] type 00 class 0x060000
[    1.433319] pci 0000:00:1c.0: [1022:1200] type 00 class 0x060000
[    1.433535] pci 0000:00:1c.1: [1022:1201] type 00 class 0x060000
[    1.433748] pci 0000:00:1c.2: [1022:1202] type 00 class 0x060000
[    1.433955] pci 0000:00:1c.3: [1022:1203] type 00 class 0x060000
[    1.434165] pci 0000:00:1c.4: [1022:1204] type 00 class 0x060000
[    1.434352] pci 0000:00:1d.0: [1022:1200] type 00 class 0x060000
[    1.434558] pci 0000:00:1d.1: [1022:1201] type 00 class 0x060000
[    1.434779] pci 0000:00:1d.2: [1022:1202] type 00 class 0x060000
[    1.435012] pci 0000:00:1d.3: [1022:1203] type 00 class 0x060000
[    1.435222] pci 0000:00:1d.4: [1022:1204] type 00 class 0x060000
[    1.435452] pci 0000:00:1e.0: [1022:1200] type 00 class 0x060000
[    1.435685] pci 0000:00:1e.1: [1022:1201] type 00 class 0x060000
[    1.435882] pci 0000:00:1e.2: [1022:1202] type 00 class 0x060000
[    1.436097] pci 0000:00:1e.3: [1022:1203] type 00 class 0x060000
[    1.436309] pci 0000:00:1e.4: [1022:1204] type 00 class 0x060000
[    1.436526] pci 0000:00:1f.0: [1022:1200] type 00 class 0x060000
[    1.436757] pci 0000:00:1f.1: [1022:1201] type 00 class 0x060000
[    1.436946] pci 0000:00:1f.2: [1022:1202] type 00 class 0x060000
[    1.437175] pci 0000:00:1f.3: [1022:1203] type 00 class 0x060000
[    1.437390] pci 0000:00:1f.4: [1022:1204] type 00 class 0x060000
[    1.437763] pci 0000:01:06.0: [8086:1076] type 00 class 0x020000
[    1.437797] pci 0000:01:06.0: reg 0x10: [mem 0xd4120000-0xd413ffff]
[    1.437806] pci 0000:01:06.0: reg 0x14: [mem 0xd4100000-0xd411ffff]
[    1.437814] pci 0000:01:06.0: reg 0x18: [io  0x2080-0x20bf]
[    1.437847] pci 0000:01:06.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.437881] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.438014] pci 0000:01:09.0: [18ca:0020] type 00 class 0x030000
[    1.438034] pci 0000:01:09.0: reg 0x10: [mem 0xd8000000-0xdbffffff pref]
[    1.438048] pci 0000:01:09.0: reg 0x14: [mem 0xd4140000-0xd417ffff]
[    1.438055] pci 0000:01:09.0: reg 0x18: [io  0x2000-0x207f]
[    1.438099] pci 0000:01:09.0: supports D1 D2
[    1.438253] pci 0000:00:09.0: PCI bridge to [bus 01] (subtractive decode)
[    1.438442] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.438446] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.438449] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.438452] pci 0000:00:09.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.438455] pci 0000:00:09.0:   bridge window [io  0x0d00-0x3fff] (subtractive decode)
[    1.438458] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.438460] pci 0000:00:09.0:   bridge window [mem 0xd4000000-0xdbffffff] (subtractive decode)
[    1.438560] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.438841] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.439116] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.439271] pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
[    1.439545] pci 0000:00:0e.0: PCI bridge to [bus 06-07]
[    1.439697] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.439700] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.439705] pci_bus 0000:06: busn_res: [bus 06-07] end is updated to 06
[    1.440683] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.441230] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.441734] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.442234] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
[    1.442778] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.443310] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
[    1.443889] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.444388] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
[    1.444883] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
[    1.445384] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.445923] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.446448] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.446981] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.447493] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
[    1.448029] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.448713] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.448870] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.449034] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.449632] acpi PNP0A03:01: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000ca000-0x000fffff])
[    1.449994] PCI host bridge to bus 0000:80
[    1.450143] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.450286] pci_bus 0000:80: root bus resource [io  0xb000-0xffff]
[    1.450427] pci_bus 0000:80: root bus resource [mem 0x000a0000-0x000bffff]
[    1.450578] pci_bus 0000:80: root bus resource [mem 0xdc000000-0xdc3fffff]
[    1.450755] pci 0000:80:00.0: [10de:005e] type 00 class 0x058000
[    1.451000] pci 0000:80:01.0: [10de:00d3] type 00 class 0x058000
[    1.451196] pci 0000:80:07.0: [10de:0054] type 00 class 0x010185
[    1.451213] pci 0000:80:07.0: reg 0x10: [io  0xb030-0xb037]
[    1.451223] pci 0000:80:07.0: reg 0x14: [io  0xb024-0xb027]
[    1.451228] pci 0000:80:07.0: reg 0x18: [io  0xb028-0xb02f]
[    1.451234] pci 0000:80:07.0: reg 0x1c: [io  0xb020-0xb023]
[    1.451238] pci 0000:80:07.0: reg 0x20: [io  0xb000-0xb00f]
[    1.451244] pci 0000:80:07.0: reg 0x24: [mem 0xdc000000-0xdc000fff]
[    1.451409] pci 0000:80:08.0: [10de:0055] type 00 class 0x010185
[    1.451426] pci 0000:80:08.0: reg 0x10: [io  0xb048-0xb04f]
[    1.451436] pci 0000:80:08.0: reg 0x14: [io  0xb03c-0xb03f]
[    1.451450] pci 0000:80:08.0: reg 0x18: [io  0xb040-0xb047]
[    1.451455] pci 0000:80:08.0: reg 0x1c: [io  0xb038-0xb03b]
[    1.451469] pci 0000:80:08.0: reg 0x20: [io  0xb010-0xb01f]
[    1.451484] pci 0000:80:08.0: reg 0x24: [mem 0xdc001000-0xdc001fff]
[    1.451662] pci 0000:80:0a.0: [10de:0057] type 00 class 0x068000
[    1.451671] pci 0000:80:0a.0: reg 0x10: [mem 0xdc002000-0xdc002fff]
[    1.451676] pci 0000:80:0a.0: reg 0x14: [io  0xb050-0xb057]
[    1.451703] pci 0000:80:0a.0: supports D1 D2
[    1.451722] pci 0000:80:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.451772] pci 0000:80:0a.0: System wakeup disabled by ACPI
[    1.452040] pci 0000:80:0b.0: [10de:005d] type 01 class 0x060400
[    1.452124] pci 0000:80:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.452287] pci 0000:80:0c.0: [10de:005d] type 01 class 0x060400
[    1.452366] pci 0000:80:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.452535] pci 0000:80:0d.0: [10de:005d] type 01 class 0x060400
[    1.452591] pci 0000:80:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.452752] pci 0000:80:0e.0: [10de:005d] type 01 class 0x060400
[    1.452801] pci 0000:80:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.453089] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.453360] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.453628] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.453906] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.454691] vgaarb: device added: PCI:0000:01:09.0,decodes=io+mem,owns=io+mem,locks=none
[    1.454852] vgaarb: loaded
[    1.454999] vgaarb: bridge control possible 0000:01:09.0
[    1.455969] SCSI subsystem initialized
[    1.456465] libata version 3.00 loaded.
[    1.456487] ACPI: bus type USB registered
[    1.456789] usbcore: registered new interface driver usbfs
[    1.457013] usbcore: registered new interface driver hub
[    1.457262] usbcore: registered new device driver usb
[    1.457586] PCI: Using ACPI for IRQ routing
[    1.457737] PCI: pci_cache_line_size set to 64 bytes
[    1.457750] pci 0000:00:01.1: no compatible bridge window for [io  0xa000-0xa03f]
[    1.457911] pci 0000:00:01.1: no compatible bridge window for [io  0xa040-0xa07f]
[    1.458211] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
[    1.458215] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    1.458217] e820: reserve RAM buffer [mem 0xcfc00000-0xcfffffff]
[    1.459034] Switched to clocksource refined-jiffies
[    1.466891] pnp: PnP ACPI init
[    1.467133] ACPI: bus type PNP registered
[    1.467833] system 00:00: [mem 0xff800000-0xffffffff] could not be reserved
[    1.467989] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.468150] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.468304] system 00:00: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.468464] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.469070] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.469577] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.470020] pnp 00:03: [dma 2]
[    1.470156] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.470717] pnp 00:04: [dma 1]
[    1.470958] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.471099] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.471214] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.471688] system 00:07: [io  0x8000-0x807f] could not be reserved
[    1.471849] system 00:07: [io  0x8080-0x80ff] has been reserved
[    1.472000] system 00:07: [io  0x8400-0x847f] has been reserved
[    1.472152] system 00:07: [io  0x8480-0x84ff] has been reserved
[    1.472303] system 00:07: [io  0x8800-0x887f] has been reserved
[    1.472443] system 00:07: [io  0x8880-0x88ff] has been reserved
[    1.472603] system 00:07: [io  0xa000-0xa03f] has been reserved
[    1.472743] system 00:07: [io  0xa040-0xa07f] has been reserved
[    1.472899] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.472943] pnp 00:08: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.1 BAR 0 [io  0x0000-0x001f]
[    1.473208] pnp 00:08: disabling [io  0x0010-0x001f disabled] because it overlaps 0000:00:01.1 BAR 4 [io  0x0000-0x003f]
[    1.473459] pnp 00:08: disabling [io  0x0022-0x003f] because it overlaps 0000:00:01.1 BAR 4 [io  0x0000-0x003f]
[    1.473718] pnp 00:08: disabling [io  0x0010-0x001f disabled] because it overlaps 0000:00:01.1 BAR 5 [io  0x0000-0x003f]
[    1.473978] pnp 00:08: disabling [io  0x0022-0x003f disabled] because it overlaps 0000:00:01.1 BAR 5 [io  0x0000-0x003f]
[    1.474389] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.474541] system 00:08: [io  0x0400-0x045e] has been reserved
[    1.474695] system 00:08: [io  0x9000-0x907f] has been reserved
[    1.474847] system 00:08: [io  0x9080-0x90ff] has been reserved
[    1.475002] system 00:08: [io  0x9200-0x927f] has been reserved
[    1.475152] system 00:08: [io  0x9280-0x92ff] has been reserved
[    1.475302] system 00:08: [io  0x9400-0x947f] has been reserved
[    1.475463] system 00:08: [io  0x9480-0x94ff] has been reserved
[    1.475617] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.475643] pnp 00:09: [dma 4]
[    1.475731] pnp 00:09: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.475835] pnp 00:0a: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.475946] pnp 00:0b: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.476053] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.476618] pnp: PnP ACPI: found 13 devices
[    1.476765] ACPI: bus type PNP unregistered
[    1.488318] Switched to clocksource acpi_pm
[    1.488677] pci 0000:00:01.1: BAR 4: assigned [io  0x1000-0x103f]
[    1.488858] pci 0000:00:01.1: BAR 5: assigned [io  0x1040-0x107f]
[    1.489102] pci 0000:00:01.1: BAR 0: assigned [io  0x1080-0x109f]
[    1.489315] pci 0000:01:06.0: BAR 6: assigned [mem 0xd4180000-0xd419ffff pref]
[    1.489497] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.489682] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.493956] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.494138] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.494322] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.494504] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.494685] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.494866] pci 0000:00:0e.0: PCI bridge to [bus 06]
[    1.495033] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.495213] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.495407] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.495410] pci_bus 0000:00: resource 5 [io  0x0d00-0x3fff]
[    1.495412] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.495414] pci_bus 0000:00: resource 7 [mem 0xd4000000-0xdbffffff]
[    1.495417] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.495420] pci_bus 0000:01: resource 1 [mem 0xd4100000-0xd41fffff]
[    1.495422] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdbffffff pref]
[    1.495424] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.495427] pci_bus 0000:01: resource 5 [io  0x0d00-0x3fff]
[    1.495429] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.495431] pci_bus 0000:01: resource 7 [mem 0xd4000000-0xdbffffff]
[    1.495434] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
[    1.495437] pci_bus 0000:06: resource 1 [mem 0xd4200000-0xd42fffff]
[    1.495465] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.495648] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.495830] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.496020] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.496201] pci_bus 0000:80: resource 4 [io  0xb000-0xffff]
[    1.496203] pci_bus 0000:80: resource 5 [mem 0x000a0000-0x000bffff]
[    1.496206] pci_bus 0000:80: resource 6 [mem 0xdc000000-0xdc3fffff]
[    1.497031] NET: Registered protocol family 2
[    1.498475] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.501906] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.502847] TCP: Hash tables configured (established 524288 bind 65536)
[    1.503141] TCP: reno registered
[    1.503467] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.504802] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.506367] NET: Registered protocol family 1
[    1.507174] RPC: Registered named UNIX socket transport module.
[    1.507351] RPC: Registered udp transport module.
[    1.507525] RPC: Registered tcp transport module.
[    1.507699] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.508574] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    1.765307] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    1.765759] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.765943] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.766127] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.766371] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.766553] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.766745] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.766983] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.767166] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.767349] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.767605] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.767787] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.767980] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.768301] pci 0000:01:09.0: Boot video device
[    1.768437] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.768811] pci 0000:80:0b.0: Found disabled HT MSI Mapping
[    1.768985] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.769229] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.769411] pci 0000:80:0c.0: Found disabled HT MSI Mapping
[    1.769594] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.769824] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.770006] pci 0000:80:0d.0: Found disabled HT MSI Mapping
[    1.770190] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.770415] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.770606] pci 0000:80:0e.0: Found disabled HT MSI Mapping
[    1.770781] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.770969] PCI: CLS 64 bytes, default 64
[    1.774548] PCI-DMA: Disabling AGP.
[    1.776017] PCI-DMA: aperture base @ d0000000 size 65536 KB
[    1.776195] init_memory_mapping: [mem 0xd0000000-0xd3ffffff]
[    1.776372]  [mem 0xd0000000-0xd3ffffff] page 2M
[    1.776390] PCI-DMA: using GART IOMMU.
[    1.776764] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.786364] Simple Boot Flag at 0x37 set to 0x80
[    1.789720] LVT offset 1 assigned for vector 0x400
[    1.789952] IBS: LVT offset 1 assigned
[    1.790240] perf: AMD IBS detected (0x00000007)
[    1.800515] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.837698] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.842081] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.842535] msgmni has been set to 32768
[    1.843251] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.843430] io scheduler noop registered
[    1.843588] io scheduler deadline registered
[    1.843912] io scheduler cfq registered (default)
[    1.844441] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    1.844593] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    1.844894] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    1.845031] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    1.845214] pcieport 0000:80:0b.0: irq 44 for MSI/MSI-X
[    1.845355] pcieport 0000:80:0c.0: irq 45 for MSI/MSI-X
[    1.845496] pcieport 0000:80:0d.0: irq 46 for MSI/MSI-X
[    1.845636] pcieport 0000:80:0e.0: irq 47 for MSI/MSI-X
[    1.846279] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.846451] ACPI: Power Button [PWRB]
[    1.846826] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.846991] ACPI: Power Button [PWRF]
[    1.847364] ACPI: acpi_idle registered with cpuidle
[    1.893965] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.914552] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.935196] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.937027] Linux agpgart interface v0.103
[    1.938762] Floppy drive(s): fd0 is 1.44M
[    1.942772] brd: module loaded
[    1.945257] loop: module loaded
[    1.946302] sata_nv 0000:00:07.0: version 3.5
[    1.946834] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    1.947922] scsi0 : sata_nv
[    1.948551] scsi1 : sata_nv
[    1.949030] ata1: SATA max UDMA/133 cmd 0x1440 ctl 0x1434 bmdma 0x1410 irq 21
[    1.949199] ata2: SATA max UDMA/133 cmd 0x1438 ctl 0x1430 bmdma 0x1418 irq 21
[    1.949703] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    1.950980] scsi2 : sata_nv
[    1.951444] scsi3 : sata_nv
[    1.951760] ata3: SATA max UDMA/133 cmd 0x1458 ctl 0x144c bmdma 0x1420 irq 20
[    1.951915] ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x1448 bmdma 0x1428 irq 20
[    1.952476] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    1.953779] scsi4 : sata_nv
[    1.954216] scsi5 : sata_nv
[    1.954538] ata5: SATA max UDMA/133 cmd 0xb030 ctl 0xb024 bmdma 0xb000 irq 19
[    1.954724] ata6: SATA max UDMA/133 cmd 0xb028 ctl 0xb020 bmdma 0xb008 irq 19
[    1.955130] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
[    1.956898] scsi6 : sata_nv
[    1.956928] FDC 0 is a post-1991 82077
[    1.957499] scsi7 : sata_nv
[    1.958051] ata7: SATA max UDMA/133 cmd 0xb048 ctl 0xb03c bmdma 0xb010 irq 18
[    1.958211] ata8: SATA max UDMA/133 cmd 0xb040 ctl 0xb038 bmdma 0xb018 irq 18
[    1.958614] pata_amd 0000:00:06.0: version 0.4.1
[    1.960046] scsi8 : pata_amd
[    1.960510] scsi9 : pata_amd
[    1.961107] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1400 irq 14
[    1.961260] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1408 irq 15
[    1.961664] tun: Universal TUN/TAP device driver, 1.6
[    1.961881] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.962441] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.962613] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.421374] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.421380] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.421388] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.429459] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.429933] ata5.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.429970] ata3.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.429975] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.429979] ata1.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.429982] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.430730] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.437889] ata7.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.438046] ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.439843] e1000 0000:01:06.0 eth0: (PCI:33MHz:32-bit) 00:e0:81:b0:4d:69
[    2.440063] e1000 0000:01:06.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.440342] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    2.440745] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[    2.445929] ata5.00: configured for UDMA/133
[    2.445944] ata1.00: configured for UDMA/133
[    2.445947] ata3.00: configured for UDMA/133
[    2.453937] ata7.00: configured for UDMA/133
[    2.461623] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.462234] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.462436] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.462604] sd 0:0:0:0: [sda] Write Protect is off
[    2.462752] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.462831] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.466545]  sda: sda1 sda2 sda3
[    2.467532] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.785738] tsc: Refined TSC clocksource calibration: 1908.795 MHz
[    2.929874] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.938395] ata2.00: ATA-6: ST31000340NS, SN04, max UDMA/133
[    2.938537] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.954428] ata2.00: configured for UDMA/133
[    2.954727] scsi 1:0:0:0: Direct-Access     ATA      ST31000340NS     SN04 PQ: 0 ANSI: 5
[    2.955298] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.955458] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.955599] sd 1:0:0:0: [sdb] Write Protect is off
[    2.955602] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.955662] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.956320] scsi 2:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.956823] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.956961] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.957256] sd 2:0:0:0: [sdc] Write Protect is off
[    2.957437] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.957493] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.966525] forcedeth 0000:00:0a.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:67
[    2.966688] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    2.967353] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 17
[    2.973575]  sdb: unknown partition table
[    2.974337] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.978828]  sdc: unknown partition table
[    2.979483] sd 2:0:0:0: [sdc] Attached SCSI disk
[    3.422364] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.430922] ata4.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.431084] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.450916] ata4.00: configured for UDMA/133
[    3.451231] scsi 3:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.451767] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.451897] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    3.452109] sd 3:0:0:0: [sdd] Write Protect is off
[    3.452251] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.452273] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.452327] scsi 4:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.452767] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.452929] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    3.452971] sd 4:0:0:0: [sde] Write Protect is off
[    3.452973] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    3.452998] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.471204]  sde: sde1 sde2 sde3
[    3.471425]  sdd: unknown partition table
[    3.471785] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.472102] sd 4:0:0:0: [sde] Attached SCSI disk
[    3.491168] forcedeth 0000:80:0a.0: ifname eth2, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:68
[    3.494934] forcedeth 0000:80:0a.0: highdma csum gbit lnktim desc-v3
[    3.495709] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.495929] ehci-pci: EHCI PCI platform driver
[    3.496286] ehci-pci 0000:00:02.1: EHCI Host Controller
[    3.496593] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    3.496763] ehci-pci 0000:00:02.1: debug port 1
[    3.496943] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    3.496985] ehci-pci 0000:00:02.1: irq 22, io mem 0xd4001000
[    3.506440] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.507078] hub 1-0:1.0: USB hub found
[    3.507242] hub 1-0:1.0: 10 ports detected
[    3.507772] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.507937] ohci-pci: OHCI PCI platform driver
[    3.508170] ohci-pci 0000:00:02.0: OHCI PCI host controller
[    3.508447] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 2
[    3.508657] ohci-pci 0000:00:02.0: irq 23, io mem 0xd4000000
[    3.564862] hub 2-0:1.0: USB hub found
[    3.565016] hub 2-0:1.0: 10 ports detected
[    3.565487] uhci_hcd: USB Universal Host Controller Interface driver
[    3.565909] usbcore: registered new interface driver usblp
[    3.566154] usbcore: registered new interface driver usb-storage
[    3.566624] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.569634] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.569790] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.570275] mousedev: PS/2 mouse device common for all mice
[    3.571510] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.572885] usbcore: registered new interface driver usbhid
[    3.573034] usbhid: USB HID core driver
[    3.573277] oprofile: AMD IBS detected (0x00000007)
[    3.573426] oprofile: using NMI interrupt.
[    3.573603] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.574506] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.574769] arp_tables: (C) 2002 David S. Miller
[    3.574925] TCP: cubic registered
[    3.575081] NET: Registered protocol family 17
[    3.579796] registered taskstats version 1
[    3.580945] console [netcon0] enabled
[    3.581112] netconsole: network logging started
[    3.581709] acpi-cpufreq: overriding BIOS provided _PSD data
[    3.632806] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.786962] Switched to clocksource tsc
[    3.922723] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.931297] ata6.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.931467] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.947316] ata6.00: configured for UDMA/133
[    3.947683] scsi 5:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.948192] sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.948338] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    3.948586] scsi 6:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.948643] sd 5:0:0:0: [sdf] Write Protect is off
[    3.948646] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    3.948701] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.949578] sd 6:0:0:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.949748] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.949853] sd 6:0:0:0: [sdg] Write Protect is off
[    3.949856] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.949903] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.963054]  sdg: unknown partition table
[    3.963604] sd 6:0:0:0: [sdg] Attached SCSI disk
[    3.968046]  sdf: sdf1 sdf2 sdf3
[    3.968961] sd 5:0:0:0: [sdf] Attached SCSI disk
[    4.195003] usb 2-1: new low-speed USB device number 2 using ohci-pci
[    4.201071] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    4.415219] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.439489] ata8.00: ATA-7: Hitachi HUA721010KLA330, GKAOA70M, max UDMA/133
[    4.439659] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.455503] ata8.00: configured for UDMA/133
[    4.455801] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HUA72101 GKAO PQ: 0 ANSI: 5
[    4.456304] sd 7:0:0:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.456465] sd 7:0:0:0: Attached scsi generic sg7 type 0
[    4.456578] sd 7:0:0:0: [sdh] Write Protect is off
[    4.456581] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    4.456631] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.476217]  sdh: unknown partition table
[    4.476784] sd 7:0:0:0: [sdh] Attached SCSI disk
[    4.643741] ata10.00: ATAPI: TEAC DV-516GB, HT13, max UDMA/33
[    4.643935] ata10: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000) ACPI=0x701f (60:600:0x13)
[    4.683745] ata10.00: configured for UDMA/33
[    4.685803] scsi 9:0:0:0: CD-ROM            TEAC     DV-516GB         HT13 PQ: 0 ANSI: 5
[    4.692806] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    4.692978] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.693396] sr 9:0:0:0: Attached scsi CD-ROM sr0
[    4.693601] sr 9:0:0:0: Attached scsi generic sg8 type 5
[    4.702694] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.711018] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.732346] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.732514] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    4.749372] devtmpfs: mounted
[    4.750484] Freeing unused kernel memory: 932K (ffffffff81726000 - ffffffff8180f000)
[    5.656993] random: nonblocking pool is initialized
[    5.925880] hid-generic 0003:051D:0002.0001: device has no listeners, quitting
[    6.394356] systemd-udevd[1972]: starting version 216
[    6.877845] systemd-udevd[2033]: renamed network interface eth1 to enp0s10
[    6.901811] systemd-udevd[1997]: renamed network interface eth0 to enp1s6
[    6.933938] systemd-udevd[2051]: renamed network interface eth2 to enp128s10
[    6.976890] kvm: Nested Virtualization enabled
[    6.976911] kvm: Nested Paging enabled
[    7.852431] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.297780] e1000: enp1s6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
