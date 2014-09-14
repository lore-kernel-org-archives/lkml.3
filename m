Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaINOZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:25:52 -0400
Received: from services.gouders.net ([141.101.32.176]:54399 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaINOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:25:48 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <1410700597-27265-1-git-send-email-andreas.noever@gmail.com>
	(Andreas Noever's message of "Sun, 14 Sep 2014 15:16:37 +0200")
References: <ghfvfu1lc1.fsf@quad.gouders.net>
	<1410700597-27265-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sun, 14 Sep 2014 16:24:19 +0200
Message-ID: <ghbnqi1drg.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Noever <andreas.noever@gmail.com> writes:

> Updated version with dmi strings. Dirk can you test this (without pci=nocrs) and look for
> PCI: Ignoring host bridge windows from ACPI
> If it does not show up then I have messed up the DMI_MATCH macros. In that case
> please try to boot with pci=nocrs.

Reboot with the fix done, please find the test results below.
Looks good, I would say, the machine is still running with that kernel
and all VMs active.

Thanks a lot,

Dirk

# lspci -tv

-+-[0000:80]-+-00.0  NVIDIA Corporation CK804 Memory Controller
 |           +-01.0  NVIDIA Corporation CK804 Memory Controller
 |           +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
 |           +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
 |           +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
 |           +-0b.0-[81-85]--
 |           +-0c.0-[86-8a]--
 |           +-0d.0-[8b-8f]--
 |           \-0e.0-[90-94]--
 \-[0000:00]-+-00.0  NVIDIA Corporation CK804 Memory Controller
             +-01.0  NVIDIA Corporation CK804 ISA Bridge
             +-01.1  NVIDIA Corporation CK804 SMBus
             +-02.0  NVIDIA Corporation CK804 USB Controller
             +-02.1  NVIDIA Corporation CK804 USB Controller
             +-06.0  NVIDIA Corporation CK804 IDE
             +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
             +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
             +-09.0-[01]--+-06.0  Intel Corporation 82541GI Gigabit Ethernet Controller
             |            \-09.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z7/Z9 (XG20 core)
             +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
             +-0b.0-[02]--
             +-0c.0-[03]--
             +-0d.0-[05]--
             +-0e.0-[0a]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
             +-18.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-18.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-18.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-18.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-18.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-19.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-19.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-19.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-19.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-19.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1a.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1a.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1a.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1a.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1a.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1b.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1b.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1b.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1b.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1b.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1c.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1c.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1c.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1c.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1c.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1d.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1d.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1d.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1d.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1d.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1e.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1e.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1e.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1e.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1e.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1f.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1f.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1f.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1f.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             \-1f.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control

# dmesg

[    0.000000] Linux version 3.17.0-rc4-00347-g2a3257c (root@quad) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #24 SMP Sun Sep 14 15:53:39 CEST 2014
[    0.000000] Command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M
[    0.000000] tseg: 00cfc00000
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
[    0.000000] AGP: No AGP bridge found
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
[    0.000000] BRK [0x01937000, 0x01937fff] PGTABLE
[    0.000000] BRK [0x01938000, 0x01938fff] PGTABLE
[    0.000000] BRK [0x01939000, 0x01939fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2fe00000-0xa2fffffff]
[    0.000000]  [mem 0xa2fe00000-0xa2fffffff] page 2M
[    0.000000] BRK [0x0193a000, 0x0193afff] PGTABLE
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
[    0.000000] BRK [0x0193b000, 0x0193bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x9ffffffff]
[    0.000000]  [mem 0x100000000-0x9ffffffff] page 1G
[    0.000000] log_buf_len: 16777216 bytes
[    0.000000] early log buf free: 257848(98%)
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F77F0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 0x000000007FFE0AAB 000038 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x000000007FFE4C98 000074 (v01 NVIDIA CK8S     06040000 PTL_ 000F4240)
[    0.000000] ACPI: DSDT 0x000000007FFE0AE3 0041B5 (v01 NVIDIA CK8      06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x000000007FFEAFC0 000040
[    0.000000] ACPI: SSDT 0x000000007FFE4D0C 005084 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SPCR 0x000000007FFE9D90 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: APIC 0x000000007FFE9DE0 0001F8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x000000007FFE9FD8 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
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
[    0.000000]   NODE_DATA [mem 0xa2effa000-0xa2effdfff]
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
[    0.000000]  [ffffea001cc00000-ffffea0023bfffff] PMD -> [ffff880a26600000-ffff880a2d5fffff] on node 7
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
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s79296 r8192 d23104 u524288
[    0.000000] pcpu-alloc: s79296 r8192 d23104 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 [1] 04 05 06 07 
[    0.000000] pcpu-alloc: [2] 08 09 10 11 [3] 12 13 14 15 
[    0.000000] pcpu-alloc: [4] 16 17 18 19 [5] 20 21 22 23 
[    0.000000] pcpu-alloc: [6] 24 25 26 27 [7] 28 29 30 31 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 10341233
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 1: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 2: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 3: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 4: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 5: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 6: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 7: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] Memory: 41266556K/41938400K available (4485K kernel code, 694K rwdata, 2500K rodata, 936K init, 776K bss, 671844K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:680 0
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1908.825 MHz processor
[    0.000018] Calibrating delay loop (skipped), value calculated using timer frequency.. 3817.65 BogoMIPS (lpj=7635300)
[    0.000318] pid_max: default: 32768 minimum: 301
[    0.000566] ACPI: Core revision 20140724
[    0.008488] ACPI: All ACPI Tables successfully acquired
[    0.017403] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.068507] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.091869] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.092195] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.094486] CPU: Physical Processor ID: 0
[    0.094662] CPU: Processor Core ID: 0
[    0.094807] mce: CPU supports 6 MCE banks
[    0.094961] LVT offset 0 assigned for vector 0xf9
[    0.095115] process: using AMD E400 aware idle routine
[    0.095272] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.095728] Freeing SMP alternatives memory: 20K (ffffffff8186e000 - ffffffff81873000)
[    0.096081] Switched APIC routing to physical flat.
[    0.096729] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.137258] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 8347 HE (fam: 10, model: 02, stepping: 03)
[    0.245486] Performance Events: AMD PMU driver.
[    0.245686] ... version:                0
[    0.245833] ... bit width:              48
[    0.245972] ... generic registers:      4
[    0.246117] ... value mask:             0000ffffffffffff
[    0.246265] ... max period:             00007fffffffffff
[    0.246412] ... fixed-purpose events:   0
[    0.246547] ... event mask:             000000000000000f
[    0.248910] x86: Booting SMP configuration:
[    0.249079] .... node  #0, CPUs:        #1  #2  #3
[    0.290308] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.438504] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.590285] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.742168] .... node  #4, CPUs:   #16 #17 #18 #19
[    0.894106] .... node  #5, CPUs:   #20 #21 #22 #23
[    1.045976] .... node  #6, CPUs:   #24 #25 #26 #27
[    1.197836] .... node  #7, CPUs:   #28 #29 #30 #31
[    1.349247] x86: Booted up 8 nodes, 32 CPUs
[    1.349540] smpboot: Total of 32 processors activated (122171.35 BogoMIPS)
[    1.371485] devtmpfs: initialized
[    1.372343] PM: Registering ACPI NVS region [mem 0x7ffea000-0x7fffffff] (90112 bytes)
[    1.373901] NET: Registered protocol family 16
[    1.374436] cpuidle: using governor ladder
[    1.374587] cpuidle: using governor menu
[    1.374789] node 0 link 1: io port [1000, 3fff]
[    1.374793] node 1 link 1: io port [b000, bfff]
[    1.374796] node 1 link 1: io port [9000, 9fff]
[    1.374799] TOM: 00000000d0000000 aka 3328M
[    1.374948] node 0 link 1: mmio [d4000000, dbffffff]
[    1.374952] node 1 link 1: mmio [dc000000, dc3fffff]
[    1.374955] node 0 link 1: mmio [a0000, bffff]
[    1.374958] node 0 link 1: mmio [e0000000, e7ffffff]
[    1.374960] node 1 link 1: mmio [e8000000, efffffff]
[    1.374963] TOM2: 0000000a30000000 aka 41728M
[    1.375112] bus: [bus 00-7f] on node 0 link 1
[    1.375113] bus: 00 [io  0x0000-0x8fff]
[    1.375115] bus: 00 [io  0xc000-0xffff]
[    1.375116] bus: 00 [io  0xa000-0xafff]
[    1.375118] bus: 00 [mem 0xd0000000-0xdbffffff]
[    1.375119] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.375120] bus: 00 [mem 0xdc400000-0xe7ffffff]
[    1.375122] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.375123] bus: 00 [mem 0xa30000000-0xfcffffffff]
[    1.375124] bus: [bus 80-ff] on node 1 link 1
[    1.375126] bus: 80 [io  0xb000-0xbfff]
[    1.375127] bus: 80 [io  0x9000-0x9fff]
[    1.375128] bus: 80 [mem 0xdc000000-0xdc3fffff]
[    1.375129] bus: 80 [mem 0xe8000000-0xefffffff]
[    1.375308] ACPI: bus type PCI registered
[    1.375615] PCI: Using configuration type 1 for base access
[    1.375764] PCI: Using configuration type 1 for extended access
[    1.398355] ACPI: Added _OSI(Module Device)
[    1.398561] ACPI: Added _OSI(Processor Device)
[    1.398708] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.398855] ACPI: Added _OSI(Processor Aggregator Device)
[    1.415406] ACPI: Interpreter enabled
[    1.415584] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    1.415932] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    1.416289] ACPI: (supports S0 S1 S4 S5)
[    1.416439] ACPI: Using IOAPIC for interrupt routing
[    1.416656] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.429097] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
[    1.429303] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.429467] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.429974] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.429976] acpi PNP0A03:00: host bridge window [io  0x0d00-0x3fff] (ignored)
[    1.429979] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.429982] acpi PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.429985] acpi PNP0A03:00: host bridge window [mem 0xd4000000-0xdbffffff] (ignored)
[    1.429988] PCI: root bus 00: hardware-probed resources
[    1.430073] PCI host bridge to bus 0000:00
[    1.430222] pci_bus 0000:00: root bus resource [bus 00-7f]
[    1.430375] pci_bus 0000:00: root bus resource [io  0x0000-0x8fff]
[    1.430526] pci_bus 0000:00: root bus resource [io  0xc000-0xffff]
[    1.430678] pci_bus 0000:00: root bus resource [io  0xa000-0xafff]
[    1.430819] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdbffffff]
[    1.430970] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.431122] pci_bus 0000:00: root bus resource [mem 0xdc400000-0xe7ffffff]
[    1.431273] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xffffffff]
[    1.431442] pci_bus 0000:00: root bus resource [mem 0xa30000000-0xfcffffffff]
[    1.431589] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    1.431609] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    1.431895] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    1.431927] fixup_debug_start: pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xaa
[    1.431929] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.432223] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    1.432232] pci 0000:00:01.1: reg 0x10: [io  0x0000-0x001f]
[    1.432245] pci 0000:00:01.1: reg 0x20: [io  0xa000-0xa03f]
[    1.432250] pci 0000:00:01.1: reg 0x24: [io  0xa040-0xa07f]
[    1.432275] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.432279] pci_pme_active: pci 0000:00:01.1: PME# disabled
[    1.432435] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    1.432443] pci 0000:00:02.0: reg 0x10: [mem 0xd4000000-0xd4000fff]
[    1.432473] pci 0000:00:02.0: supports D1 D2
[    1.432475] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.432478] pci_pme_active: pci 0000:00:02.0: PME# disabled
[    1.432564] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.432792] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    1.432801] pci 0000:00:02.1: reg 0x10: [mem 0xd4001000-0xd40010ff]
[    1.432852] pci 0000:00:02.1: supports D1 D2
[    1.432854] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.432869] pci_pme_active: pci 0000:00:02.1: PME# disabled
[    1.432970] pci 0000:00:02.1: System wakeup disabled by ACPI
[    1.433205] pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
[    1.433222] pci 0000:00:06.0: reg 0x20: [io  0x1400-0x140f]
[    1.433231] pci 0000:00:06.0: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    1.433384] pci 0000:00:06.0: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.433537] pci 0000:00:06.0: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    1.433689] pci 0000:00:06.0: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.433990] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.433998] pci 0000:00:07.0: reg 0x10: [io  0x1440-0x1447]
[    1.434003] pci 0000:00:07.0: reg 0x14: [io  0x1434-0x1437]
[    1.434007] pci 0000:00:07.0: reg 0x18: [io  0x1438-0x143f]
[    1.434012] pci 0000:00:07.0: reg 0x1c: [io  0x1430-0x1433]
[    1.434016] pci 0000:00:07.0: reg 0x20: [io  0x1410-0x141f]
[    1.434021] pci 0000:00:07.0: reg 0x24: [mem 0xd4002000-0xd4002fff]
[    1.434190] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.434197] pci 0000:00:08.0: reg 0x10: [io  0x1458-0x145f]
[    1.434202] pci 0000:00:08.0: reg 0x14: [io  0x144c-0x144f]
[    1.434207] pci 0000:00:08.0: reg 0x18: [io  0x1450-0x1457]
[    1.434211] pci 0000:00:08.0: reg 0x1c: [io  0x1448-0x144b]
[    1.434216] pci 0000:00:08.0: reg 0x20: [io  0x1420-0x142f]
[    1.434221] pci 0000:00:08.0: reg 0x24: [mem 0xd4003000-0xd4003fff]
[    1.434409] pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
[    1.434498] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.434721] pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
[    1.434729] pci 0000:00:0a.0: reg 0x10: [mem 0xd4004000-0xd4004fff]
[    1.434734] pci 0000:00:0a.0: reg 0x14: [io  0x1460-0x1467]
[    1.434758] pci 0000:00:0a.0: supports D1 D2
[    1.434774] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.434783] pci_pme_active: pci 0000:00:0a.0: PME# disabled
[    1.434876] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.435102] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.435137] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.435140] pci_pme_active: pci 0000:00:0b.0: PME# disabled
[    1.435295] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.435325] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.435328] pci_pme_active: pci 0000:00:0c.0: PME# disabled
[    1.435489] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.435522] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.435525] pci_pme_active: pci 0000:00:0d.0: PME# disabled
[    1.435680] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.435712] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.435715] pci_pme_active: pci 0000:00:0e.0: PME# disabled
[    1.435874] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.435883] fixup_debug_start: pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x5
[    1.436033] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.436038] fixup_debug_start: pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x5
[    1.436183] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.436188] fixup_debug_start: pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x5
[    1.436326] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.436331] fixup_debug_start: pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x5
[    1.436471] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.436476] fixup_debug_start: pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x5
[    1.436615] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    1.436620] fixup_debug_start: pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x5
[    1.436767] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    1.436772] fixup_debug_start: pci 0000:00:19.1: calling quirk_mmio_always_on+0x0/0x5
[    1.436907] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    1.436912] fixup_debug_start: pci 0000:00:19.2: calling quirk_mmio_always_on+0x0/0x5
[    1.437052] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    1.437057] fixup_debug_start: pci 0000:00:19.3: calling quirk_mmio_always_on+0x0/0x5
[    1.437201] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    1.437206] fixup_debug_start: pci 0000:00:19.4: calling quirk_mmio_always_on+0x0/0x5
[    1.437348] pci 0000:00:1a.0: [1022:1200] type 00 class 0x060000
[    1.437353] fixup_debug_start: pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x5
[    1.437502] pci 0000:00:1a.1: [1022:1201] type 00 class 0x060000
[    1.437507] fixup_debug_start: pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x5
[    1.437644] pci 0000:00:1a.2: [1022:1202] type 00 class 0x060000
[    1.437648] fixup_debug_start: pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x5
[    1.437787] pci 0000:00:1a.3: [1022:1203] type 00 class 0x060000
[    1.437792] fixup_debug_start: pci 0000:00:1a.3: calling quirk_mmio_always_on+0x0/0x5
[    1.437933] pci 0000:00:1a.4: [1022:1204] type 00 class 0x060000
[    1.437937] fixup_debug_start: pci 0000:00:1a.4: calling quirk_mmio_always_on+0x0/0x5
[    1.438081] pci 0000:00:1b.0: [1022:1200] type 00 class 0x060000
[    1.438086] fixup_debug_start: pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x5
[    1.438238] pci 0000:00:1b.1: [1022:1201] type 00 class 0x060000
[    1.438243] fixup_debug_start: pci 0000:00:1b.1: calling quirk_mmio_always_on+0x0/0x5
[    1.438382] pci 0000:00:1b.2: [1022:1202] type 00 class 0x060000
[    1.438387] fixup_debug_start: pci 0000:00:1b.2: calling quirk_mmio_always_on+0x0/0x5
[    1.438525] pci 0000:00:1b.3: [1022:1203] type 00 class 0x060000
[    1.438530] fixup_debug_start: pci 0000:00:1b.3: calling quirk_mmio_always_on+0x0/0x5
[    1.438674] pci 0000:00:1b.4: [1022:1204] type 00 class 0x060000
[    1.438678] fixup_debug_start: pci 0000:00:1b.4: calling quirk_mmio_always_on+0x0/0x5
[    1.438818] pci 0000:00:1c.0: [1022:1200] type 00 class 0x060000
[    1.438823] fixup_debug_start: pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x5
[    1.438978] pci 0000:00:1c.1: [1022:1201] type 00 class 0x060000
[    1.438983] fixup_debug_start: pci 0000:00:1c.1: calling quirk_mmio_always_on+0x0/0x5
[    1.439122] pci 0000:00:1c.2: [1022:1202] type 00 class 0x060000
[    1.439127] fixup_debug_start: pci 0000:00:1c.2: calling quirk_mmio_always_on+0x0/0x5
[    1.439275] pci 0000:00:1c.3: [1022:1203] type 00 class 0x060000
[    1.439280] fixup_debug_start: pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x5
[    1.439431] pci 0000:00:1c.4: [1022:1204] type 00 class 0x060000
[    1.439436] fixup_debug_start: pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x5
[    1.439588] pci 0000:00:1d.0: [1022:1200] type 00 class 0x060000
[    1.439593] fixup_debug_start: pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x5
[    1.439770] pci 0000:00:1d.1: [1022:1201] type 00 class 0x060000
[    1.439775] fixup_debug_start: pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x5
[    1.439928] pci 0000:00:1d.2: [1022:1202] type 00 class 0x060000
[    1.439933] fixup_debug_start: pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x5
[    1.440073] pci 0000:00:1d.3: [1022:1203] type 00 class 0x060000
[    1.440078] fixup_debug_start: pci 0000:00:1d.3: calling quirk_mmio_always_on+0x0/0x5
[    1.440232] pci 0000:00:1d.4: [1022:1204] type 00 class 0x060000
[    1.440238] fixup_debug_start: pci 0000:00:1d.4: calling quirk_mmio_always_on+0x0/0x5
[    1.440382] pci 0000:00:1e.0: [1022:1200] type 00 class 0x060000
[    1.440387] fixup_debug_start: pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x5
[    1.440550] pci 0000:00:1e.1: [1022:1201] type 00 class 0x060000
[    1.440555] fixup_debug_start: pci 0000:00:1e.1: calling quirk_mmio_always_on+0x0/0x5
[    1.440703] pci 0000:00:1e.2: [1022:1202] type 00 class 0x060000
[    1.440708] fixup_debug_start: pci 0000:00:1e.2: calling quirk_mmio_always_on+0x0/0x5
[    1.440855] pci 0000:00:1e.3: [1022:1203] type 00 class 0x060000
[    1.440860] fixup_debug_start: pci 0000:00:1e.3: calling quirk_mmio_always_on+0x0/0x5
[    1.441008] pci 0000:00:1e.4: [1022:1204] type 00 class 0x060000
[    1.441013] fixup_debug_start: pci 0000:00:1e.4: calling quirk_mmio_always_on+0x0/0x5
[    1.441165] pci 0000:00:1f.0: [1022:1200] type 00 class 0x060000
[    1.441170] fixup_debug_start: pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x5
[    1.441340] pci 0000:00:1f.1: [1022:1201] type 00 class 0x060000
[    1.441345] fixup_debug_start: pci 0000:00:1f.1: calling quirk_mmio_always_on+0x0/0x5
[    1.441497] pci 0000:00:1f.2: [1022:1202] type 00 class 0x060000
[    1.441502] fixup_debug_start: pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x5
[    1.441652] pci 0000:00:1f.3: [1022:1203] type 00 class 0x060000
[    1.441657] fixup_debug_start: pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x5
[    1.441810] pci 0000:00:1f.4: [1022:1204] type 00 class 0x060000
[    1.441815] fixup_debug_start: pci 0000:00:1f.4: calling quirk_mmio_always_on+0x0/0x5
[    1.441969] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    1.441974] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[    1.442012] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    1.442028] pci 0000:01:06.0: [8086:1076] type 00 class 0x020000
[    1.442042] pci 0000:01:06.0: reg 0x10: [mem 0xd4120000-0xd413ffff]
[    1.442050] pci 0000:01:06.0: reg 0x14: [mem 0xd4100000-0xd411ffff]
[    1.442057] pci 0000:01:06.0: reg 0x18: [io  0x2080-0x20bf]
[    1.442086] pci 0000:01:06.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.442116] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.442130] pci_pme_active: pci 0000:01:06.0: PME# disabled
[    1.442230] pci 0000:01:09.0: [18ca:0020] type 00 class 0x030000
[    1.442241] pci 0000:01:09.0: reg 0x10: [mem 0xd8000000-0xdbffffff pref]
[    1.442248] pci 0000:01:09.0: reg 0x14: [mem 0xd4140000-0xd417ffff]
[    1.442255] pci 0000:01:09.0: reg 0x18: [io  0x2000-0x207f]
[    1.442299] pci 0000:01:09.0: supports D1 D2
[    1.442413] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    1.442416] pci 0000:00:09.0: PCI bridge to [bus 01] (subtractive decode)
[    1.442579] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.442582] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.442585] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.442588] pci 0000:00:09.0:   bridge window [io  0x0000-0x8fff] (subtractive decode)
[    1.442591] pci 0000:00:09.0:   bridge window [io  0xc000-0xffff] (subtractive decode)
[    1.442593] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff] (subtractive decode)
[    1.442596] pci 0000:00:09.0:   bridge window [mem 0xd0000000-0xdbffffff] (subtractive decode)
[    1.442603] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.442605] pci 0000:00:09.0:   bridge window [mem 0xdc400000-0xe7ffffff] (subtractive decode)
[    1.442608] pci 0000:00:09.0:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    1.442611] pci 0000:00:09.0:   bridge window [mem 0xa30000000-0xfcffffffff] (subtractive decode)
[    1.442613] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[    1.442618] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[    1.442681] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    1.442685] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    1.442687] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.442839] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    1.442843] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[    1.442905] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[    1.442909] pci_scan_child_bus: pci_bus 0000:03: fixups for bus
[    1.442911] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.443066] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[    1.443070] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[    1.443133] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[    1.443136] pci_scan_child_bus: pci_bus 0000:05: fixups for bus
[    1.443138] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.443281] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[    1.443295] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 0
[    1.443356] pci_scan_child_bus: pci_bus 0000:0a: scanning bus
[    1.443375] pci 0000:0a:00.0: [1000:0646] type 00 class 0x0c0400
[    1.443386] pci 0000:0a:00.0: reg 0x10: [io  0x3000-0x30ff]
[    1.443397] pci 0000:0a:00.0: reg 0x14: [mem 0xd4210000-0xd4213fff 64bit]
[    1.443407] pci 0000:0a:00.0: reg 0x1c: [mem 0xd4200000-0xd420ffff 64bit]
[    1.443436] pci 0000:0a:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
[    1.443480] pci 0000:0a:00.0: supports D1 D2
[    1.443588] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.443856] pci_scan_child_bus: pci_bus 0000:0a: fixups for bus
[    1.443859] pci 0000:00:0e.0: PCI bridge to [bus 0a]
[    1.444013] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.444016] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.444020] pci_scan_child_bus: pci_bus 0000:0a: bus scan returning with max=0a
[    1.444025] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[    1.444039] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[    1.444049] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[    1.444052] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[    1.444061] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 1
[    1.444070] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=0a
[    1.444079] pci_bus 0000:00: on NUMA node 0
[    1.445228] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.445785] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.446292] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.446799] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
[    1.447332] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.447893] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
[    1.448434] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.448947] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
[    1.449451] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
[    1.449959] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.450502] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.451036] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.451589] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.452109] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
[    1.452675] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.453362] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.453520] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.453685] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.453847] acpi PNP0A03:01: [Firmware Bug]: no _PXM; falling back to node 1 from hardware (may be inconsistent with ACPI node numbers)
[    1.454574] acpi PNP0A03:01: host bridge window [io  0xb000-0xffff] (ignored)
[    1.454577] acpi PNP0A03:01: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.454579] acpi PNP0A03:01: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.454582] acpi PNP0A03:01: host bridge window [mem 0xdc000000-0xdc3fffff] (ignored)
[    1.454585] PCI: root bus 80: hardware-probed resources
[    1.454651] PCI host bridge to bus 0000:80
[    1.454799] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.454952] pci_bus 0000:80: root bus resource [io  0xb000-0xbfff]
[    1.455103] pci_bus 0000:80: root bus resource [io  0x9000-0x9fff]
[    1.455243] pci_bus 0000:80: root bus resource [mem 0xdc000000-0xdc3fffff]
[    1.455410] pci_bus 0000:80: root bus resource [mem 0xe8000000-0xefffffff]
[    1.455570] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[    1.455600] pci 0000:80:00.0: [10de:005e] type 00 class 0x058000
[    1.455801] pci 0000:80:01.0: [10de:00d3] type 00 class 0x058000
[    1.455928] pci 0000:80:07.0: [10de:0054] type 00 class 0x010185
[    1.455937] pci 0000:80:07.0: reg 0x10: [io  0xb030-0xb037]
[    1.455942] pci 0000:80:07.0: reg 0x14: [io  0xb024-0xb027]
[    1.455947] pci 0000:80:07.0: reg 0x18: [io  0xb028-0xb02f]
[    1.455952] pci 0000:80:07.0: reg 0x1c: [io  0xb020-0xb023]
[    1.455957] pci 0000:80:07.0: reg 0x20: [io  0xb000-0xb00f]
[    1.455962] pci 0000:80:07.0: reg 0x24: [mem 0xdc000000-0xdc000fff]
[    1.456132] pci 0000:80:08.0: [10de:0055] type 00 class 0x010185
[    1.456140] pci 0000:80:08.0: reg 0x10: [io  0xb048-0xb04f]
[    1.456145] pci 0000:80:08.0: reg 0x14: [io  0xb03c-0xb03f]
[    1.456150] pci 0000:80:08.0: reg 0x18: [io  0xb040-0xb047]
[    1.456155] pci 0000:80:08.0: reg 0x1c: [io  0xb038-0xb03b]
[    1.456160] pci 0000:80:08.0: reg 0x20: [io  0xb010-0xb01f]
[    1.456166] pci 0000:80:08.0: reg 0x24: [mem 0xdc001000-0xdc001fff]
[    1.456311] pci 0000:80:0a.0: [10de:0057] type 00 class 0x068000
[    1.456320] pci 0000:80:0a.0: reg 0x10: [mem 0xdc002000-0xdc002fff]
[    1.456325] pci 0000:80:0a.0: reg 0x14: [io  0xb050-0xb057]
[    1.456352] pci 0000:80:0a.0: supports D1 D2
[    1.456364] pci 0000:80:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.456375] pci_pme_active: pci 0000:80:0a.0: PME# disabled
[    1.456423] pci 0000:80:0a.0: System wakeup disabled by ACPI
[    1.456641] pci 0000:80:0b.0: [10de:005d] type 01 class 0x060400
[    1.456681] pci 0000:80:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.456685] pci_pme_active: pci 0000:80:0b.0: PME# disabled
[    1.456801] pci 0000:80:0c.0: [10de:005d] type 01 class 0x060400
[    1.456839] pci 0000:80:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.456842] pci_pme_active: pci 0000:80:0c.0: PME# disabled
[    1.456953] pci 0000:80:0d.0: [10de:005d] type 01 class 0x060400
[    1.456995] pci 0000:80:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.456998] pci_pme_active: pci 0000:80:0d.0: PME# disabled
[    1.457116] pci 0000:80:0e.0: [10de:005d] type 01 class 0x060400
[    1.457152] pci 0000:80:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.457155] pci_pme_active: pci 0000:80:0e.0: PME# disabled
[    1.457271] pci_scan_child_bus: pci_bus 0000:80: fixups for bus
[    1.457276] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[    1.457326] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[    1.457330] pci_scan_child_bus: pci_bus 0000:81: fixups for bus
[    1.457332] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.457486] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[    1.457491] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[    1.457558] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[    1.457562] pci_scan_child_bus: pci_bus 0000:86: fixups for bus
[    1.457564] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.457709] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[    1.457722] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[    1.457797] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[    1.457801] pci_scan_child_bus: pci_bus 0000:8b: fixups for bus
[    1.457803] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.457957] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[    1.457961] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[    1.458030] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[    1.458033] pci_scan_child_bus: pci_bus 0000:90: fixups for bus
[    1.458035] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.458188] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[    1.458201] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[    1.458205] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[    1.458209] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[    1.458214] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[    1.458217] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94
[    1.458219] pci_bus 0000:80: on NUMA node 1
[    1.458727] vgaarb: device added: PCI:0000:01:09.0,decodes=io+mem,owns=io+mem,locks=none
[    1.458906] vgaarb: loaded
[    1.459051] vgaarb: bridge control possible 0000:01:09.0
[    1.459893] SCSI subsystem initialized
[    1.460254] libata version 3.00 loaded.
[    1.460268] ACPI: bus type USB registered
[    1.460485] usbcore: registered new interface driver usbfs
[    1.460663] usbcore: registered new interface driver hub
[    1.460864] usbcore: registered new device driver usb
[    1.461103] PCI: Using ACPI for IRQ routing
[    1.461254] PCI: pci_cache_line_size set to 64 bytes
[    1.461390] Expanded resource reserved due to conflict with PCI Bus #00
[    1.461534] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
[    1.461539] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    1.461542] e820: reserve RAM buffer [mem 0xcfc00000-0xcfffffff]
[    1.462329] Switched to clocksource refined-jiffies
[    1.470472] pnp: PnP ACPI init
[    1.471161] system 00:00: [mem 0xff800000-0xffffffff] could not be reserved
[    1.471318] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.471481] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.471638] system 00:00: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.471796] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.472344] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.472831] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.473327] pnp 00:03: [dma 2]
[    1.473393] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.473949] pnp 00:04: [dma 1]
[    1.474133] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.474207] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.474289] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.474789] system 00:07: [io  0x8000-0x807f] could not be reserved
[    1.474968] system 00:07: [io  0x8080-0x80ff] has been reserved
[    1.475122] system 00:07: [io  0x8400-0x847f] has been reserved
[    1.475277] system 00:07: [io  0x8480-0x84ff] has been reserved
[    1.475435] system 00:07: [io  0x8800-0x887f] has been reserved
[    1.475591] system 00:07: [io  0x8880-0x88ff] has been reserved
[    1.475742] system 00:07: [io  0xa000-0xa03f] has been reserved
[    1.475893] system 00:07: [io  0xa040-0xa07f] has been reserved
[    1.476034] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.476085] pnp 00:08: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.1 BAR 0 [io  0x0000-0x001f]
[    1.476478] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.476637] system 00:08: [io  0x0400-0x045e] has been reserved
[    1.476791] system 00:08: [io  0x9000-0x907f] has been reserved
[    1.476947] system 00:08: [io  0x9080-0x90ff] has been reserved
[    1.477100] system 00:08: [io  0x9200-0x927f] has been reserved
[    1.477255] system 00:08: [io  0x9280-0x92ff] has been reserved
[    1.477405] system 00:08: [io  0x9400-0x947f] has been reserved
[    1.477555] system 00:08: [io  0x9480-0x94ff] has been reserved
[    1.477695] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.477774] pnp 00:09: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.478402] pnp: PnP ACPI: found 10 devices
[    1.486655] Switched to clocksource acpi_pm
[    1.490220] pci 0000:00:01.1: BAR 0: assigned [io  0x1000-0x101f]
[    1.490382] pci 0000:01:06.0: BAR 6: assigned [mem 0xd4180000-0xd419ffff pref]
[    1.490556] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.490885] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.491041] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.491199] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.491355] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.491507] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.491661] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.491821] pci 0000:0a:00.0: BAR 6: no space for [mem size 0x00100000 pref]
[    1.491977] pci 0000:0a:00.0: BAR 6: failed to assign [mem size 0x00100000 pref]
[    1.492131] pci 0000:00:0e.0: PCI bridge to [bus 0a]
[    1.492279] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.492430] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.492588] pci_bus 0000:00: resource 4 [io  0x0000-0x8fff]
[    1.492590] pci_bus 0000:00: resource 5 [io  0xc000-0xffff]
[    1.492593] pci_bus 0000:00: resource 6 [io  0xa000-0xafff]
[    1.492595] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xdbffffff]
[    1.492598] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    1.492600] pci_bus 0000:00: resource 9 [mem 0xdc400000-0xe7ffffff]
[    1.492602] pci_bus 0000:00: resource 10 [mem 0xf0000000-0xffffffff]
[    1.492605] pci_bus 0000:00: resource 11 [mem 0xa30000000-0xfcffffffff]
[    1.492608] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.492610] pci_bus 0000:01: resource 1 [mem 0xd4100000-0xd41fffff]
[    1.492613] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdbffffff pref]
[    1.492615] pci_bus 0000:01: resource 4 [io  0x0000-0x8fff]
[    1.492617] pci_bus 0000:01: resource 5 [io  0xc000-0xffff]
[    1.492619] pci_bus 0000:01: resource 6 [io  0xa000-0xafff]
[    1.492622] pci_bus 0000:01: resource 7 [mem 0xd0000000-0xdbffffff]
[    1.492624] pci_bus 0000:01: resource 8 [mem 0x000a0000-0x000bffff]
[    1.492626] pci_bus 0000:01: resource 9 [mem 0xdc400000-0xe7ffffff]
[    1.492628] pci_bus 0000:01: resource 10 [mem 0xf0000000-0xffffffff]
[    1.492631] pci_bus 0000:01: resource 11 [mem 0xa30000000-0xfcffffffff]
[    1.492634] pci_bus 0000:0a: resource 0 [io  0x3000-0x3fff]
[    1.492636] pci_bus 0000:0a: resource 1 [mem 0xd4200000-0xd42fffff]
[    1.492654] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.492812] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.492966] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.493123] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.493276] pci_bus 0000:80: resource 4 [io  0xb000-0xbfff]
[    1.493279] pci_bus 0000:80: resource 5 [io  0x9000-0x9fff]
[    1.493281] pci_bus 0000:80: resource 6 [mem 0xdc000000-0xdc3fffff]
[    1.493283] pci_bus 0000:80: resource 7 [mem 0xe8000000-0xefffffff]
[    1.493795] NET: Registered protocol family 2
[    1.495356] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.498566] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.499632] TCP: Hash tables configured (established 524288 bind 65536)
[    1.499929] TCP: reno registered
[    1.500258] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.501390] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.503128] NET: Registered protocol family 1
[    1.503909] RPC: Registered named UNIX socket transport module.
[    1.504123] RPC: Registered udp transport module.
[    1.504271] RPC: Registered tcp transport module.
[    1.504417] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.504592] fixup_debug_start: pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.504619] fixup_debug_start: pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.504626] fixup_debug_start: pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.504635] fixup_debug_start: pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.504644] fixup_debug_start: pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x660
[    1.505109] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    1.762750] fixup_debug_start: pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762772] fixup_debug_start: pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x660
[    1.763188] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    1.763513] fixup_debug_start: pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763522] fixup_debug_start: pci 0000:00:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763534] fixup_debug_start: pci 0000:00:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763542] fixup_debug_start: pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763549] fixup_debug_start: pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763558] fixup_debug_start: pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763603] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.763797] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.763802] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.763958] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.764114] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.764122] fixup_debug_start: pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.764175] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.764325] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.764330] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.764477] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.764637] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.764644] fixup_debug_start: pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.764681] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.764834] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.764839] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.764983] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.765147] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.765154] fixup_debug_start: pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.765194] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.765345] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.765349] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.765496] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.765645] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.765666] fixup_debug_start: pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765673] fixup_debug_start: pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765681] fixup_debug_start: pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765688] fixup_debug_start: pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765695] fixup_debug_start: pci 0000:00:18.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765702] fixup_debug_start: pci 0000:00:19.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765709] fixup_debug_start: pci 0000:00:19.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765716] fixup_debug_start: pci 0000:00:19.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765723] fixup_debug_start: pci 0000:00:19.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765730] fixup_debug_start: pci 0000:00:19.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765737] fixup_debug_start: pci 0000:00:1a.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765744] fixup_debug_start: pci 0000:00:1a.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765751] fixup_debug_start: pci 0000:00:1a.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765758] fixup_debug_start: pci 0000:00:1a.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765766] fixup_debug_start: pci 0000:00:1a.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765773] fixup_debug_start: pci 0000:00:1b.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765780] fixup_debug_start: pci 0000:00:1b.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765787] fixup_debug_start: pci 0000:00:1b.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765794] fixup_debug_start: pci 0000:00:1b.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765801] fixup_debug_start: pci 0000:00:1b.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765809] fixup_debug_start: pci 0000:00:1c.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765816] fixup_debug_start: pci 0000:00:1c.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765823] fixup_debug_start: pci 0000:00:1c.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765831] fixup_debug_start: pci 0000:00:1c.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765838] fixup_debug_start: pci 0000:00:1c.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765845] fixup_debug_start: pci 0000:00:1d.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765853] fixup_debug_start: pci 0000:00:1d.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765860] fixup_debug_start: pci 0000:00:1d.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765868] fixup_debug_start: pci 0000:00:1d.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765875] fixup_debug_start: pci 0000:00:1d.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765883] fixup_debug_start: pci 0000:00:1e.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765890] fixup_debug_start: pci 0000:00:1e.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765898] fixup_debug_start: pci 0000:00:1e.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765905] fixup_debug_start: pci 0000:00:1e.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765913] fixup_debug_start: pci 0000:00:1e.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765920] fixup_debug_start: pci 0000:00:1f.0: calling quirk_amd_nb_node+0x0/0x74
[    1.765928] fixup_debug_start: pci 0000:00:1f.1: calling quirk_amd_nb_node+0x0/0x74
[    1.765935] fixup_debug_start: pci 0000:00:1f.2: calling quirk_amd_nb_node+0x0/0x74
[    1.765943] fixup_debug_start: pci 0000:00:1f.3: calling quirk_amd_nb_node+0x0/0x74
[    1.765950] fixup_debug_start: pci 0000:00:1f.4: calling quirk_amd_nb_node+0x0/0x74
[    1.765959] fixup_debug_start: pci 0000:01:06.0: calling quirk_e100_interrupt+0x0/0x143
[    1.765970] fixup_debug_start: pci 0000:01:09.0: calling pci_fixup_video+0x0/0x11b
[    1.765975] pci 0000:01:09.0: Boot video device
[    1.765985] fixup_debug_start: pci 0000:80:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766015] fixup_debug_start: pci 0000:80:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766023] fixup_debug_start: pci 0000:80:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766031] fixup_debug_start: pci 0000:80:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766040] fixup_debug_start: pci 0000:80:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766048] fixup_debug_start: pci 0000:80:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766088] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.766242] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.766258] pci 0000:80:0b.0: Found disabled HT MSI Mapping
[    1.766607] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.766762] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.766769] fixup_debug_start: pci 0000:80:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.766824] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.766985] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.766991] pci 0000:80:0c.0: Found disabled HT MSI Mapping
[    1.767142] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.767294] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.767311] fixup_debug_start: pci 0000:80:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.767371] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.767526] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.767531] pci 0000:80:0d.0: Found disabled HT MSI Mapping
[    1.767679] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.767830] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.767846] fixup_debug_start: pci 0000:80:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.767887] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.768049] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.768054] pci 0000:80:0e.0: Found disabled HT MSI Mapping
[    1.768207] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.768366] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.768369] PCI: CLS 64 bytes, default 64
[    1.771374] PCI-DMA: Disabling AGP.
[    1.772842] PCI-DMA: aperture base @ d0000000 size 65536 KB
[    1.772992] init_memory_mapping: [mem 0xd0000000-0xd3ffffff]
[    1.773144]  [mem 0xd0000000-0xd3ffffff] page 2M
[    1.773160] PCI-DMA: using GART IOMMU.
[    1.773310] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.782689] Simple Boot Flag at 0x37 set to 0x80
[    1.785791] LVT offset 1 assigned for vector 0x400
[    1.785992] IBS: LVT offset 1 assigned
[    1.786236] perf: AMD IBS detected (0x00000007)
[    1.791969] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.793669] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.797641] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.798057] msgmni has been set to 32768
[    1.798895] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.799065] io scheduler noop registered
[    1.799222] io scheduler deadline registered
[    1.799546] io scheduler cfq registered (default)
[    1.800101] __pci_set_master: pcieport 0000:00:0b.0: enabling bus mastering
[    1.800148] pcieport 0000:00:0b.0: irq 24 for MSI/MSI-X
[    1.800288] __pci_set_master: pcieport 0000:00:0c.0: enabling bus mastering
[    1.800299] pcieport 0000:00:0c.0: irq 25 for MSI/MSI-X
[    1.800394] pcieport 0000:00:0d.0: irq 26 for MSI/MSI-X
[    1.800482] pcieport 0000:00:0e.0: irq 27 for MSI/MSI-X
[    1.800594] __pci_set_master: pcieport 0000:80:0b.0: enabling bus mastering
[    1.800633] pcieport 0000:80:0b.0: irq 28 for MSI/MSI-X
[    1.800723] __pci_set_master: pcieport 0000:80:0c.0: enabling bus mastering
[    1.800734] pcieport 0000:80:0c.0: irq 29 for MSI/MSI-X
[    1.800808] pcieport 0000:80:0d.0: irq 30 for MSI/MSI-X
[    1.800891] pcieport 0000:80:0e.0: irq 31 for MSI/MSI-X
[    1.801346] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.801541] ACPI: Power Button [PWRB]
[    1.801832] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.802000] ACPI: Power Button [PWRF]
[    1.802316] ACPI: acpi_idle registered with cpuidle
[    1.827466] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.848071] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.868636] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.870033] Linux agpgart interface v0.103
[    1.871524] Floppy drive(s): fd0 is 1.44M
[    1.873938] brd: module loaded
[    1.875592] loop: module loaded
[    1.876238] sata_nv 0000:00:07.0: version 3.5
[    1.876605] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    1.877413] scsi host0: sata_nv
[    1.877959] scsi host1: sata_nv
[    1.878172] ata1: SATA max UDMA/133 cmd 0x1440 ctl 0x1434 bmdma 0x1410 irq 21
[    1.878476] ata2: SATA max UDMA/133 cmd 0x1438 ctl 0x1430 bmdma 0x1418 irq 21
[    1.878924] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    1.879537] scsi host2: sata_nv
[    1.879853] scsi host3: sata_nv
[    1.880061] ata3: SATA max UDMA/133 cmd 0x1458 ctl 0x144c bmdma 0x1420 irq 20
[    1.880209] ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x1448 bmdma 0x1428 irq 20
[    1.880884] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    1.881815] scsi host4: sata_nv
[    1.882166] scsi host5: sata_nv
[    1.882595] ata5: SATA max UDMA/133 cmd 0xb030 ctl 0xb024 bmdma 0xb000 irq 19
[    1.882757] ata6: SATA max UDMA/133 cmd 0xb028 ctl 0xb020 bmdma 0xb008 irq 19
[    1.883264] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
[    1.883988] scsi host6: sata_nv
[    1.884344] scsi host7: sata_nv
[    1.884577] ata7: SATA max UDMA/133 cmd 0xb048 ctl 0xb03c bmdma 0xb010 irq 18
[    1.884744] ata8: SATA max UDMA/133 cmd 0xb040 ctl 0xb038 bmdma 0xb018 irq 18
[    1.884976] pata_amd 0000:00:06.0: version 0.4.1
[    1.885950] scsi host8: pata_amd
[    1.886462] scsi host9: pata_amd
[    1.886686] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1400 irq 14
[    1.886832] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1408 irq 15
[    1.887111] tun: Universal TUN/TAP device driver, 1.6
[    1.887309] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.887670] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.887825] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.890460] FDC 0 is a post-1991 82077
[    2.346055] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.346063] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.350009] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.350040] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.354634] ata3.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.354640] ata1.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.354643] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.355123] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.358594] ata5.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.358798] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.358812] ata7.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.358817] ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.364345] e1000 0000:01:06.0 eth0: (PCI:33MHz:32-bit) 00:e0:81:b0:4d:69
[    2.364525] e1000 0000:01:06.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.364758] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    2.365121] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[    2.370576] ata1.00: configured for UDMA/133
[    2.370579] ata3.00: configured for UDMA/133
[    2.371143] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.371814] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.371824] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.372260] sd 0:0:0:0: [sda] Write Protect is off
[    2.372412] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.372478] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.374517] ata5.00: configured for UDMA/133
[    2.374605] ata7.00: configured for UDMA/133
[    2.378485]  sda: sda1 sda2 sda3
[    2.379258] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.781670] tsc: Refined TSC clocksource calibration: 1908.796 MHz
[    2.837623] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.846116] ata2.00: ATA-6: ST31000340NS, SN04, max UDMA/133
[    2.846266] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.862120] ata2.00: configured for UDMA/133
[    2.862399] scsi 1:0:0:0: Direct-Access     ATA      ST31000340NS     SN04 PQ: 0 ANSI: 5
[    2.862873] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.862943] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.863184] scsi 2:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.863313] sd 1:0:0:0: [sdb] Write Protect is off
[    2.863316] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.863377] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.864030] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.864095] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.864464] sd 2:0:0:0: [sdc] Write Protect is off
[    2.864614] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.864668] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.877290]  sdc: unknown partition table
[    2.878069] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.881350]  sdb: unknown partition table
[    2.882046] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.886012] forcedeth 0000:00:0a.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:67
[    2.886189] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    2.886716] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 17
[    3.329193] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.337723] ata4.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.337877] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.353706] ata4.00: configured for UDMA/133
[    3.353973] scsi 3:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.354418] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.354464] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    3.354811] scsi 4:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.354837] sd 3:0:0:0: [sdd] Write Protect is off
[    3.354840] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.354893] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.355853] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.355930] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    3.356225] sd 4:0:0:0: [sde] Write Protect is off
[    3.356390] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    3.356409] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.371841]  sde: sde1 sde2 sde3
[    3.372395] sd 4:0:0:0: [sde] Attached SCSI disk
[    3.372928]  sdd: unknown partition table
[    3.373584] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.409631] forcedeth 0000:80:0a.0: ifname eth2, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:68
[    3.409847] forcedeth 0000:80:0a.0: highdma csum gbit lnktim desc-v3
[    3.410400] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.410575] ehci-pci: EHCI PCI platform driver
[    3.410915] __pci_set_master: ehci-pci 0000:00:02.1: enabling bus mastering
[    3.410962] ehci-pci 0000:00:02.1: EHCI Host Controller
[    3.411232] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    3.411401] ehci-pci 0000:00:02.1: debug port 1
[    3.411607] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    3.411657] ehci-pci 0000:00:02.1: irq 22, io mem 0xd4001000
[    3.421098] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.421880] hub 1-0:1.0: USB hub found
[    3.422055] hub 1-0:1.0: 10 ports detected
[    3.422913] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.423086] ohci-pci: OHCI PCI platform driver
[    3.423349] __pci_set_master: ohci-pci 0000:00:02.0: enabling bus mastering
[    3.423354] ohci-pci 0000:00:02.0: OHCI PCI host controller
[    3.423610] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 2
[    3.423830] ohci-pci 0000:00:02.0: irq 23, io mem 0xd4000000
[    3.479414] hub 2-0:1.0: USB hub found
[    3.479578] hub 2-0:1.0: 10 ports detected
[    3.480061] uhci_hcd: USB Universal Host Controller Interface driver
[    3.480411] usbcore: registered new interface driver usblp
[    3.480617] usbcore: registered new interface driver usb-storage
[    3.480968] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.483754] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.483952] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.484393] mousedev: PS/2 mouse device common for all mice
[    3.485478] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.486320] usbcore: registered new interface driver usbhid
[    3.486485] usbhid: USB HID core driver
[    3.486697] oprofile: AMD IBS detected (0x00000007)
[    3.486845] oprofile: using NMI interrupt.
[    3.487035] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.487789] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.488048] arp_tables: (C) 2002 David S. Miller
[    3.488209] TCP: cubic registered
[    3.488365] NET: Registered protocol family 17
[    3.491408] registered taskstats version 1
[    3.492639] console [netcon0] enabled
[    3.492812] netconsole: network logging started
[    3.493568] acpi-cpufreq: overriding BIOS provided _PSD data
[    3.546200] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.781013] Switched to clocksource tsc
[    3.820626] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.829199] ata6.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.829368] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.845141] ata6.00: configured for UDMA/133
[    3.845428] scsi 5:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.845941] sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.845996] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    3.846191] scsi 6:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.846469] sd 5:0:0:0: [sdf] Write Protect is off
[    3.846502] sd 6:0:0:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.846521] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.846592] sd 6:0:0:0: [sdg] Write Protect is off
[    3.846595] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.846651] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.847343] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    3.847392] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.861327]  sdg: unknown partition table
[    3.861896] sd 6:0:0:0: [sdg] Attached SCSI disk
[    3.864605]  sdf: sdf1 sdf2 sdf3
[    3.865294] sd 5:0:0:0: [sdf] Attached SCSI disk
[    4.110418] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    4.112376] usb 2-1: new low-speed USB device number 2 using ohci-pci
[    4.312193] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.336452] ata8.00: ATA-7: Hitachi HUA721010KLA330, GKAOA70M, max UDMA/133
[    4.336637] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.352422] ata8.00: configured for UDMA/133
[    4.352680] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HUA72101 A70M PQ: 0 ANSI: 5
[    4.353136] sd 7:0:0:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.353217] sd 7:0:0:0: Attached scsi generic sg7 type 0
[    4.353588] sd 7:0:0:0: [sdh] Write Protect is off
[    4.353759] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    4.353817] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.372819]  sdh: unknown partition table
[    4.373307] sd 7:0:0:0: [sdh] Attached SCSI disk
[    4.540300] ata10.00: ATAPI: TEAC DV-516GB, HT13, max UDMA/33
[    4.540481] ata10: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000) ACPI=0x701f (60:600:0x13)
[    4.580139] ata10.00: configured for UDMA/33
[    4.582254] scsi 9:0:0:0: CD-ROM            TEAC     DV-516GB         HT13 PQ: 0 ANSI: 5
[    4.597287] sr 9:0:0:0: [sr0] scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    4.597458] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.597777] sr 9:0:0:0: Attached scsi CD-ROM sr0
[    4.597887] sr 9:0:0:0: Attached scsi generic sg8 type 5
[    4.602173] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.610455] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.631701] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.631869] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    4.648726] devtmpfs: mounted
[    4.649974] Freeing unused kernel memory: 936K (ffffffff81784000 - ffffffff8186e000)
[    5.494514] random: nonblocking pool is initialized
[    5.805081] hid-generic 0003:051D:0002.0001: device has no listeners, quitting
[    6.348925] systemd-udevd[1984]: starting version 216
[    6.814632] Fusion MPT base driver 3.04.20
[    6.814639] Copyright (c) 1999-2008 LSI Corporation
[    6.816095] kvm: Nested Virtualization enabled
[    6.816117] kvm: Nested Paging enabled
[    6.861503] forcedeth 0000:00:0a.0 enp0s10: renamed from eth1
[    6.868040] Fusion MPT FC Host driver 3.04.20
[    6.868452] mptbase: ioc0: Initiating bringup
[    6.878187] forcedeth 0000:80:0a.0 enp128s10: renamed from eth2
[    6.878195] systemd-udevd[2058]: renamed network interface eth1 to enp0s10
[    6.914042] e1000 0000:01:06.0 enp1s6: renamed from eth0
[    6.914057] systemd-udevd[2037]: renamed network interface eth2 to enp128s10
[    6.934001] systemd-udevd[2005]: renamed network interface eth0 to enp1s6
[    7.425491] ioc0: LSIFC949E: Capabilities={Initiator,Target,LAN}
[    8.425090] scsi host10: ioc0: LSIFC949E, FwRev=01031400h, Ports=1, MaxQ=1023, IRQ=17
[    8.425693] mptfc: ioc0: FC Link Established, Speed = 4 Gbps
[    8.426479] scsi 10:0:0:0: Direct-Access     ES-6600S Backup           R001 PQ: 0 ANSI: 5
[    8.426979] sd 10:0:0:0: [sdi] 3906249216 512-byte logical blocks: (1.99 TB/1.81 TiB)
[    8.426986] sd 10:0:0:0: Attached scsi generic sg9 type 0
[    8.427213] sd 10:0:0:0: [sdi] Write Protect is off
[    8.427221] sd 10:0:0:0: [sdi] Mode Sense: bf 00 00 08
[    8.427316] scsi 10:0:0:1: Direct-Access     ES-6600S Data             R001 PQ: 0 ANSI: 5
[    8.427343] sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.427397] mptscsih: ioc0: [10:0:0:0] FCP_ResponseInfo=02000000h
[    8.427908] sd 10:0:0:1: [sdj] 15624996864 512-byte logical blocks: (7.99 TB/7.27 TiB)
[    8.427960] sd 10:0:0:1: Attached scsi generic sg10 type 0
[    8.428114] sd 10:0:0:1: [sdj] Write Protect is off
[    8.428117] sd 10:0:0:1: [sdj] Mode Sense: bf 00 00 08
[    8.428234] sd 10:0:0:1: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.428281] scsi 10:0:0:2: Direct-Access     ES-6600S Systems          R001 PQ: 0 ANSI: 5
[    8.428295] mptscsih: ioc0: [10:0:0:1] FCP_ResponseInfo=02000000h
[    8.428946] sd 10:0:0:2: [sdk] 7812498432 512-byte logical blocks: (3.99 TB/3.63 TiB)
[    8.428956] sd 10:0:0:2: Attached scsi generic sg11 type 0
[    8.429160] sd 10:0:0:2: [sdk] Write Protect is off
[    8.429164] sd 10:0:0:2: [sdk] Mode Sense: bf 00 00 08
[    8.429278] sd 10:0:0:2: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.429280]  sdj: unknown partition table
[    8.429328] mptscsih: ioc0: [10:0:0:2] FCP_ResponseInfo=02000000h
[    8.430104] sd 10:0:0:1: [sdj] Attached SCSI disk
[    8.430372]  sdk: unknown partition table
[    8.431224] sd 10:0:0:2: [sdk] Attached SCSI disk
[    8.446434]  sdi: sdi1
[    8.447090] sd 10:0:0:0: [sdi] Attached SCSI disk
[    9.160490] EXT4-fs (sda2): re-mounted. Opts: (null)
[   10.878530] end_request: I/O error, dev fd0, sector 0
[   10.878537] floppy: error -5 while reading block 0
[   10.902520] end_request: I/O error, dev fd0, sector 0
[   10.902527] floppy: error -5 while reading block 0
[   14.269650] Bridge firewalling registered
[   14.313275] e1000: enp1s6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   14.329356] device enp1s6 entered promiscuous mode
[   14.339831] device br0 entered promiscuous mode
[   14.359392] br0: port 1(enp1s6) entered forwarding state
[   14.359404] br0: port 1(enp1s6) entered forwarding state
[   16.345895] device vnet0 entered promiscuous mode
[   16.357767] br0: port 2(vnet0) entered forwarding state
[   16.357770] br0: port 2(vnet0) entered forwarding state
[   17.596763] device vnet1 entered promiscuous mode
[   17.612696] br0: port 3(vnet1) entered forwarding state
[   17.612699] br0: port 3(vnet1) entered forwarding state
[   17.655129] qemu-system-x86: sending ioctl 5326 to a partition!
[   17.655147] qemu-system-x86: sending ioctl 80200204 to a partition!
[   28.894090] kvm [2985]: vcpu0 unhandled rdmsr: 0xc0010001
[   30.507916] kvm [2977]: vcpu0 unhandled rdmsr: 0xc0010001
[  322.109232] device vnet2 entered promiscuous mode
[  322.125168] br0: port 4(vnet2) entered forwarding state
[  322.125172] br0: port 4(vnet2) entered forwarding state
[  322.172390] qemu-system-x86: sending ioctl 5326 to a partition!
[  322.172406] qemu-system-x86: sending ioctl 80200204 to a partition!
[  322.172543] qemu-system-x86: sending ioctl 5326 to a partition!
[  322.172550] qemu-system-x86: sending ioctl 80200204 to a partition!
[  322.172674] qemu-system-x86: sending ioctl 5326 to a partition!
[  322.172680] qemu-system-x86: sending ioctl 80200204 to a partition!
[  327.580521] device vnet3 entered promiscuous mode
[  327.596424] br0: port 5(vnet3) entered forwarding state
[  327.596429] br0: port 5(vnet3) entered forwarding state
[  327.650363] qemu-system-x86: sending ioctl 5326 to a partition!
[  327.650383] qemu-system-x86: sending ioctl 80200204 to a partition!
[  330.146292] device vnet4 entered promiscuous mode
[  330.174200] br0: port 6(vnet4) entered forwarding state
[  330.174205] br0: port 6(vnet4) entered forwarding state
[  330.227004] qemu-system-x86: sending ioctl 5326 to a partition!
[  330.227025] qemu-system-x86: sending ioctl 80200204 to a partition!
[  331.732903] device vnet5 entered promiscuous mode
[  331.760825] br0: port 7(vnet5) entered forwarding state
[  331.760830] br0: port 7(vnet5) entered forwarding state
[  331.802573] qemu-system-x86: sending ioctl 5326 to a partition!
[  331.802590] qemu-system-x86: sending ioctl 80200204 to a partition!
[  335.773486] kvm [3029]: vcpu0 unhandled rdmsr: 0xc0010001
[  341.234294] kvm [3048]: vcpu0 unhandled rdmsr: 0xc0010001
[  343.067763] kvm [3058]: vcpu0 unhandled rdmsr: 0xc0010001
[  345.673927] kvm [3068]: vcpu0 unhandled rdmsr: 0xc0010001
[  346.491944] kvm [3048]: vcpu1 unhandled rdmsr: 0x3a
[  349.913178] device vnet6 entered promiscuous mode
[  349.929079] br0: port 8(vnet6) entered forwarding state
[  349.929084] br0: port 8(vnet6) entered forwarding state
[  349.976302] qemu-system-x86: sending ioctl 5326 to a partition!
[  349.976319] qemu-system-x86: sending ioctl 80200204 to a partition!
[  349.976443] qemu-system-x86: sending ioctl 5326 to a partition!
[  349.976450] qemu-system-x86: sending ioctl 80200204 to a partition!
[  354.545147] device vnet7 entered promiscuous mode
[  354.561094] br0: port 9(vnet7) entered forwarding state
[  354.561099] br0: port 9(vnet7) entered forwarding state
[  354.607498] qemu-system-x86: sending ioctl 5326 to a partition!
[  354.607516] qemu-system-x86: sending ioctl 80200204 to a partition!
[  354.607640] qemu-system-x86: sending ioctl 5326 to a partition!
[  354.607647] qemu-system-x86: sending ioctl 80200204 to a partition!
[  354.607753] qemu-system-x86: sending ioctl 5326 to a partition!
[  354.607759] qemu-system-x86: sending ioctl 80200204 to a partition!
[  355.170047] kvm [3068]: vcpu0 unhandled rdmsr: 0x3a
[  365.396476] kvm [3083]: vcpu0 unhandled rdmsr: 0xc0010001
[  374.606976] kvm [3110]: vcpu0 unhandled rdmsr: 0xc0010001
[  377.920947] device vnet8 entered promiscuous mode
[  377.936859] br0: port 10(vnet8) entered forwarding state
[  377.936864] br0: port 10(vnet8) entered forwarding state
[  377.978753] scsi_verify_blk_ioctl: 2 callbacks suppressed
[  377.978760] qemu-system-x86: sending ioctl 5326 to a partition!
[  377.978772] qemu-system-x86: sending ioctl 80200204 to a partition!
[  377.978915] qemu-system-x86: sending ioctl 5326 to a partition!
[  377.978923] qemu-system-x86: sending ioctl 80200204 to a partition!
[  382.349090] device vnet9 entered promiscuous mode
[  382.365032] br0: port 11(vnet9) entered forwarding state
[  382.365037] br0: port 11(vnet9) entered forwarding state
[  382.410523] qemu-system-x86: sending ioctl 5326 to a partition!
[  382.410540] qemu-system-x86: sending ioctl 80200204 to a partition!
[  394.650316] kvm [3143]: vcpu0 unhandled rdmsr: 0xc0010001
[  399.655762] kvm [3157]: vcpu0 unhandled rdmsr: 0xc0010001
