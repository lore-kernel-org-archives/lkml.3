Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3CFKEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:04:51 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:40482 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3CFKEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:04:45 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av1tAE8TN1FV5qjOPGdsb2JhbABEh2CFILdoAwGBVhcDAQEBATg0gioBAQQBGgEMExwjEAgDEgINDQEBFg8FJQoGFBOIDQq8BBWNLAUXBQogfAUHEgEFgkdhA5MGg0OGB41xgWgBAQcXBA
X-IronPort-AV: E=Sophos;i="4.84,794,1355094000"; 
   d="scan'208";a="291264619"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 11:07:43 +0100
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306100743.GA407@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
 <20130306080642.GA535@polaris.bitmath.org>
 <51370990.5040508@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51370990.5040508@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > commit 8d57470d8f859635deffe3919d7d4867b488b85a
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Fri Nov 16 19:38:58 2012 -0800
> > 
> >     x86, mm: setup page table in top-down
> >     
> >     Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
> >     Then use mapped pages to map more ranges below, and keep looping until
> >     all pages get mapped.
> > 
> > Being a 64-bit apple-EFI machine, it probably runs through an obscure
> > path in this patch. I wish I had more vital information, but I get the
> > white screen of death, so not much to go on so far.
> > 
> 
> Adding Yinghai.
> 
> Can you get a boot log with "debug memblock=debug" from the last
> successful commit point?  Are you booting EFI or BootCamp?

Attached the dmesg log, booting from f763ad1 which is on top of
3.7-rc6. I am booting with EFI_STUB, straight into the kernel.
The command line and modules are built in.

Never mind the nouveau trap in the log, that is an old unrelated problem.

Thanks,
Henrik

---

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc6+ (rydberg@polaris) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Wed Mar 6 10:52:49 CET 2013
[    0.000000] Command line: 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000006f000000-0x000000007effffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f000000-0x000000007f718fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f719000-0x000000007f938fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f939000-0x000000007f953fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f954000-0x000000007f96afff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007f96b000-0x000000007f96efff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f96f000-0x000000007f99afff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f99b000-0x000000007f9b1fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f9b2000-0x000000007f9dafff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f9db000-0x000000007fef8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fef9000-0x000000007fefffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000093200000-0x0000000093200fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v1.10 by Apple
[    0.000000] efi:  ACPI=0x7f96a000  ACPI 2.0=0x7f96a014  SMBIOS=0x7f71a000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000008f000) (0MB)
[    0.000000] efi: mem01: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: type=2, attr=0xf, range=[0x0000000000090000-0x0000000000096000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000096000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001db0000) (13MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000001db0000-0x000000006d0d6000) (1715MB)
[    0.000000] efi: mem07: type=1, attr=0xf, range=[0x000000006d0d6000-0x000000006d546000) (4MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x000000006d546000-0x000000006d9b6000) (4MB)
[    0.000000] efi: mem09: type=4, attr=0xf, range=[0x000000006d9b6000-0x000000006e615000) (12MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000006e615000-0x000000006e616000) (0MB)
[    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000006e616000-0x000000006e7ac000) (1MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000006e7ac000-0x000000006ea6e000) (2MB)
[    0.000000] efi: mem13: type=2, attr=0xf, range=[0x000000006ea6e000-0x000000006ea6f000) (0MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x000000006ea6f000-0x000000006f000000) (5MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000007f000000-0x000000007f6af000) (6MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x000000007f6af000-0x000000007f719000) (0MB)
[    0.000000] efi: mem17: type=10, attr=0xf, range=[0x000000007f719000-0x000000007f939000) (2MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x000000007f939000-0x000000007f954000) (0MB)
[    0.000000] efi: mem19: type=9, attr=0xf, range=[0x000000007f954000-0x000000007f96b000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000007f96b000-0x000000007f96f000) (0MB)
[    0.000000] efi: mem21: type=6, attr=0x800000000000000f, range=[0x000000007f96f000-0x000000007f99b000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x000000007f99b000-0x000000007f9b2000) (0MB)
[    0.000000] efi: mem23: type=5, attr=0x800000000000000f, range=[0x000000007f9b2000-0x000000007f9db000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x000000007f9db000-0x000000007fc2c000) (2MB)
[    0.000000] efi: mem25: type=3, attr=0xf, range=[0x000000007fc2c000-0x000000007fd5f000) (1MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x000000007fd5f000-0x000000007fef9000) (1MB)
[    0.000000] efi: mem27: type=0, attr=0xf, range=[0x000000007fef9000-0x000000007feff000) (0MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000007feff000-0x000000007ff00000) (0MB)
[    0.000000] efi: mem29: type=0, attr=0x8000000000000000, range=[0x000000006f000000-0x000000007f000000) (256MB)
[    0.000000] efi: mem30: type=11, attr=0x8000000000000000, range=[0x0000000093200000-0x0000000093201000) (0MB)
[    0.000000] efi: mem31: type=11, attr=0x8000000000000000, range=[0x00000000ffc00000-0x00000000ffc80000) (0MB)
[    0.000000] efi: mem32: type=11, attr=0x8000000000000000, range=[0x00000000ffc80000-0x00000000ffca8000) (0MB)
[    0.000000] efi: mem33: type=11, attr=0x8000000000000000, range=[0x00000000ffca8000-0x00000000ffcca000) (0MB)
[    0.000000] efi: mem34: type=11, attr=0x8000000000000000, range=[0x00000000ffcca000-0x00000000ffffc000) (3MB)
[    0.000000] efi: mem35: type=11, attr=0x8000000000000000, range=[0x00000000ffffc000-0x0000000100000000) (0MB)
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir3,1/Mac-942452F5819B1C1B, BIOS    MBA31.88Z.0061.B00.1009101530 09/10/10
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x7fef9 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 080000000 mask F80000000 uncachable
[    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] memblock_reserve: [0x000000029fa000-0x000000029fa219] setup_arch+0x62b/0x7e9
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x6fbfc000 reserved size = 0xa5b8d9
[    0.000000]  memory.cnt  = 0x8
[    0.000000]  memory[0x0]	[0x00000000010000-0x0000000008efff], 0x7f000 bytes
[    0.000000]  memory[0x1]	[0x00000000090000-0x0000000009ffff], 0x10000 bytes
[    0.000000]  memory[0x2]	[0x00000000100000-0x0000006effffff], 0x6ef00000 bytes
[    0.000000]  memory[0x3]	[0x0000007f000000-0x0000007f718fff], 0x719000 bytes
[    0.000000]  memory[0x4]	[0x0000007f939000-0x0000007f953fff], 0x1b000 bytes
[    0.000000]  memory[0x5]	[0x0000007f96b000-0x0000007f96efff], 0x4000 bytes
[    0.000000]  memory[0x6]	[0x0000007f99b000-0x0000007f9b1fff], 0x17000 bytes
[    0.000000]  memory[0x7]	[0x0000007f9db000-0x0000007fef8fff], 0x51e000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]	[0x00000000095000-0x000000000956bf], 0x6c0 bytes
[    0.000000]  reserved[0x1]	[0x0000000009f000-0x000000000fffff], 0x61000 bytes
[    0.000000]  reserved[0x2]	[0x00000002000000-0x000000029fa218], 0x9fa219 bytes
[    0.000000] memblock_reserve: [0x0000006d9b6000-0x0000006e615000] efi_reserve_boot_services+0xb4/0xd0
[    0.000000] memblock_reserve: [0x0000006e616000-0x0000006e7ac000] efi_reserve_boot_services+0xb4/0xd0
[    0.000000] memblock_reserve: [0x0000006ea6f000-0x0000006f000000] efi_reserve_boot_services+0xb4/0xd0
[    0.000000] memblock_reserve: [0x0000007f000000-0x0000007f6af000] efi_reserve_boot_services+0xb4/0xd0
[    0.000000] memblock_reserve: [0x0000007fc2c000-0x0000007fd5f000] efi_reserve_boot_services+0xb4/0xd0
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] memblock_reserve: [0x00000000099000-0x0000000009f000] setup_real_mode+0x62/0x17b
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x6effffff] page 2M
[    0.000000]  [mem 0x7f000000-0x7f5fffff] page 2M
[    0.000000]  [mem 0x7f600000-0x7f718fff] page 4k
[    0.000000]  [mem 0x7f939000-0x7f953fff] page 4k
[    0.000000]  [mem 0x7f96b000-0x7f96efff] page 4k
[    0.000000]  [mem 0x7f99b000-0x7f9b1fff] page 4k
[    0.000000]  [mem 0x7f9db000-0x7f9fffff] page 4k
[    0.000000]  [mem 0x7fa00000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7fef8fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x7fef8fff @ [mem 0x7fee3000-0x7fef8fff] prealloc
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6effffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x6effffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x7f000000-0x7f718fff]
[    0.000000]  [mem 0x7f000000-0x7f5fffff] page 2M
[    0.000000]  [mem 0x7f600000-0x7f718fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7f939000-0x7f953fff]
[    0.000000]  [mem 0x7f939000-0x7f953fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7f96b000-0x7f96efff]
[    0.000000]  [mem 0x7f96b000-0x7f96efff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7f99b000-0x7f9b1fff]
[    0.000000]  [mem 0x7f99b000-0x7f9b1fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7f9db000-0x7fef8fff]
[    0.000000]  [mem 0x7f9db000-0x7f9fffff] page 4k
[    0.000000]  [mem 0x7fa00000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7fef8fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x7fef8fff @ [mem 0x7fee3000-0x7fee7fff] final
[    0.000000] memblock_reserve: [0x0000007fee3000-0x0000007fee8000] init_mem_mapping+0x296/0x2b0
[    0.000000] ACPI: RSDP 000000007f96a014 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000007f96a1c0 00084 (v01 APPLE   Apple00 00000061      01000013)
[    0.000000] ACPI: FACP 000000007f968000 000F4 (v04 APPLE   Apple00 00000061 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000007f95b000 0572C (v01 APPLE  MacBookA 00030001 INTL 20061109)
[    0.000000] ACPI: FACS 000000007f71e000 00040
[    0.000000] ACPI: HPET 000000007f967000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000007f966000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000007f965000 00068 (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! 000000007f963000 000A5 (v32 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000007f962000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000007f961000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000007f958000 00107 (v01 APPLE  SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f957000 00024 (v01 APPLE     Apple 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f955000 0008A (v01 APPLE  NoSDCard 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007f954000 004DC (v01  APPLE    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: MCFG 000000007f964000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] memblock_reserve: [0x0000007fef8000-0x0000007fef9000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000006d5b6000-0x0000006d9b6000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef7f00-0x0000007fef7ff0] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000006d1b6000-0x0000006d5b6000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000006b200000-0x0000006d000000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef6000-0x0000007fef7000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef5000-0x0000007fef6000] __alloc_memory_core_early+0x56/0x61
[    0.000000]    memblock_free: [0x0000006d000000-0x0000006d000000] sparse_mem_maps_populate_node+0xe9/0x12a
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88006b200000-ffff88006cffffff] on node 0
[    0.000000]    memblock_free: [0x0000006d1b6000-0x0000006d5b6000] sparse_init+0x24d/0x2ae
[    0.000000]    memblock_free: [0x0000006d5b6000-0x0000006d9b6000] paging_init+0x11/0x18
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x6effffff]
[    0.000000]   node   0: [mem 0x7f000000-0x7f718fff]
[    0.000000]   node   0: [mem 0x7f939000-0x7f953fff]
[    0.000000]   node   0: [mem 0x7f96b000-0x7f96efff]
[    0.000000]   node   0: [mem 0x7f99b000-0x7f9b1fff]
[    0.000000]   node   0: [mem 0x7f9db000-0x7fef8fff]
[    0.000000] On node 0 totalpages: 457724
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 8 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000] memblock_reserve: [0x0000007fef7d80-0x0000007fef7f00] __alloc_memory_core_early+0x56/0x61
[    0.000000]   DMA32 zone: 8124 pages used for memmap
[    0.000000]   DMA32 zone: 445617 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x0000007fee9000-0x0000007fef5000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fee8000-0x0000007fee9000] __alloc_memory_core_early+0x56/0x61
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] memblock_reserve: [0x0000007fef7d00-0x0000007fef7d41] __alloc_memory_core_early+0x56/0x61
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] memblock_reserve: [0x0000007fef7c80-0x0000007fef7cc3] __alloc_memory_core_early+0x56/0x61
[    0.000000] nr_irqs_gsi: 40
[    0.000000] memblock_reserve: [0x0000007fef7880-0x0000007fef7c70] __alloc_memory_core_early+0x56/0x61
[    0.000000] e820: [mem 0x93201000-0xffbfffff] available for PCI devices
[    0.000000] memblock_reserve: [0x0000007fef7800-0x0000007fef7849] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef7780-0x0000007fef77c9] __alloc_memory_core_early+0x56/0x61
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] memblock_reserve: [0x0000007fee2000-0x0000007fee3000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fee1000-0x0000007fee2000] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fa00000-0x0000007fc00000] __alloc_memory_core_early+0x56/0x61
[    0.000000]    memblock_free: [0x0000007fa17000-0x0000007fb00000] pcpu_embed_first_chunk+0x166/0x279
[    0.000000]    memblock_free: [0x0000007fb17000-0x0000007fc00000] pcpu_embed_first_chunk+0x166/0x279
[    0.000000] PERCPU: Embedded 23 pages/cpu @ffff88007fa00000 s72384 r0 d21824 u1048576
[    0.000000] memblock_reserve: [0x0000007fef7740-0x0000007fef7748] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef7700-0x0000007fef7708] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef76c0-0x0000007fef76c8] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef7680-0x0000007fef7690] __alloc_memory_core_early+0x56/0x61
[    0.000000] pcpu-alloc: s72384 r0 d21824 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] memblock_reserve: [0x0000007fef7540-0x0000007fef7680] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef74c0-0x0000007fef7520] __alloc_memory_core_early+0x56/0x61
[    0.000000]    memblock_free: [0x0000007fee2000-0x0000007fee3000] pcpu_embed_first_chunk+0x24d/0x279
[    0.000000]    memblock_free: [0x0000007fee1000-0x0000007fee2000] pcpu_embed_first_chunk+0x267/0x279
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 449528
[    0.000000] Kernel command line: root=/dev/sda2 ro elevator=noop hid_apple.fnmode=2 debug memblock=debug 
[    0.000000] memblock_reserve: [0x0000007fedb000-0x0000007fee3000] __alloc_memory_core_early+0x56/0x61
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] memblock_reserve: [0x0000006e86f000-0x0000006ea6f000] __alloc_memory_core_early+0x56/0x61
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] memblock_reserve: [0x0000007fddb000-0x0000007fedb000] __alloc_memory_core_early+0x56/0x61
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] memblock_reserve: [0x0000007fef7280-0x0000007fef74c0] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef7240-0x0000007fef7248] __alloc_memory_core_early+0x56/0x61
[    0.000000] memblock_reserve: [0x0000007fef7200-0x0000007fef7208] __alloc_memory_core_early+0x56/0x61
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1758484k/2096100k available (6829k kernel code, 265204k absent, 72412k reserved, 2373k data, 516k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1397.068 MHz processor
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 2794.13 BogoMIPS (lpj=5588272)
[    0.004015] pid_max: default: 32768 minimum: 301
[    0.004035] init_memory_mapping: [mem 0x7f96f000-0x7f99afff]
[    0.004041]  [mem 0x7f96f000-0x7f99afff] page 4k
[    0.004059] init_memory_mapping: [mem 0x7f9b2000-0x7f9dafff]
[    0.004064]  [mem 0x7f9b2000-0x7f9dafff] page 4k
[    0.004076] init_memory_mapping: [mem 0x7feff000-0x7fefffff]
[    0.004081]  [mem 0x7feff000-0x7fefffff] page 4k
[    0.004093] init_memory_mapping: [mem 0x6f000000-0x7effffff]
[    0.004098]  [mem 0x6f000000-0x7effffff] page 2M
[    0.201964] Mount-cache hash table entries: 256
[    0.202246] CPU: Physical Processor ID: 0
[    0.202252] CPU: Processor Core ID: 0
[    0.202257] process: using mwait in idle threads
[    0.202267] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.202361] Freeing SMP alternatives: 24k freed
[    0.202382] ACPI: Core revision 20120913
[    0.209687] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.249383] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     U9400  @ 1.40GHz (fam: 06, model: 17, stepping: 0a)
[    0.252000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.252000] ... version:                2
[    0.252000] ... bit width:              40
[    0.252000] ... generic registers:      2
[    0.252000] ... value mask:             000000ffffffffff
[    0.252000] ... max period:             000000007fffffff
[    0.252000] ... fixed-purpose events:   3
[    0.252000] ... event mask:             0000000700000003
[    0.280054] smpboot: Booting Node   0, Processors  #1 OK
[    0.292036] Brought up 2 CPUs
[    0.292046] smpboot: Total of 2 processors activated (5588.27 BogoMIPS)
[    0.296002] devtmpfs: initialized
[    0.296251] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.296260] PM: Registering ACPI NVS region [mem 0x7f719000-0x7f938fff] (2228224 bytes)
[    0.296382] NET: Registered protocol family 16
[    0.296553] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.296562] ACPI: bus type pci registered
[    0.296630] dca service started, version 1.12.1
[    0.296928] PCI: MMCONFIG for domain 0000 [bus 00-02] at [mem 0xf0000000-0xf02fffff] (base 0xf0000000)
[    0.296937] PCI: not using MMCONFIG
[    0.296942] PCI: Using configuration type 1 for base access
[    0.298750] bio: create slab <bio-0> at 0
[    0.298750] ACPI: Added _OSI(Module Device)
[    0.298750] ACPI: Added _OSI(Processor Device)
[    0.298750] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.298750] ACPI: Added _OSI(Processor Aggregator Device)
[    0.300740] ACPI: EC: EC description table is found, configuring boot EC
[    0.305740] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.306161] ACPI: SSDT 000000007f71dc98 001FB (v01  APPLE  Cpu0Ist 00003000 INTL 20061109)
[    0.306588] ACPI: Dynamic OEM Table Load:
[    0.306596] ACPI: SSDT           (null) 001FB (v01  APPLE  Cpu0Ist 00003000 INTL 20061109)
[    0.306769] ACPI: SSDT 000000007f71c618 005A6 (v01  APPLE  Cpu0Cst 00003001 INTL 20061109)
[    0.307178] ACPI: Dynamic OEM Table Load:
[    0.307186] ACPI: SSDT           (null) 005A6 (v01  APPLE  Cpu0Cst 00003001 INTL 20061109)
[    0.344265] ACPI: SSDT 000000007f71df18 000C8 (v01  APPLE  Cpu1Ist 00003000 INTL 20061109)
[    0.344684] ACPI: Dynamic OEM Table Load:
[    0.344692] ACPI: SSDT           (null) 000C8 (v01  APPLE  Cpu1Ist 00003000 INTL 20061109)
[    0.344811] ACPI: SSDT 000000007f71bf18 00085 (v01  APPLE  Cpu1Cst 00003000 INTL 20061109)
[    0.345219] ACPI: Dynamic OEM Table Load:
[    0.345227] ACPI: SSDT           (null) 00085 (v01  APPLE  Cpu1Cst 00003000 INTL 20061109)
[    0.384226] ACPI: Interpreter enabled
[    0.384234] ACPI: (supports S0 S3 S5)
[    0.384255] ACPI: Using IOAPIC for interrupt routing
[    0.384279] PCI: MMCONFIG for domain 0000 [bus 00-02] at [mem 0xf0000000-0xf02fffff] (base 0xf0000000)
[    0.384621] PCI: MMCONFIG at [mem 0xf0000000-0xf02fffff] reserved in ACPI motherboard resources
[    0.396334] ACPI: EC: GPE = 0x57, I/O: command/status = 0x66, data = 0x62
[    0.396389] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.396581] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.396707] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-02] only partially covers this bridge
[    0.396750] PCI host bridge to bus 0000:00
[    0.396757] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.396764] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.396771] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.396777] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.396784] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.396791] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.396798] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.396804] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.396811] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.396818] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.396824] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.396831] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.396838] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.396844] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.396851] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.396857] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.396864] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.396871] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.396895] pci 0000:00:00.0: [10de:0d60] type 00 class 0x060000
[    0.397024] pci 0000:00:00.1: [10de:0d68] type 00 class 0x050000
[    0.397215] pci 0000:00:01.0: [10de:0d6d] type 00 class 0x050000
[    0.397397] pci 0000:00:01.1: [10de:0d6e] type 00 class 0x050000
[    0.397580] pci 0000:00:01.2: [10de:0d6f] type 00 class 0x050000
[    0.397762] pci 0000:00:01.3: [10de:0d70] type 00 class 0x050000
[    0.397950] pci 0000:00:02.0: [10de:0d71] type 00 class 0x050000
[    0.398132] pci 0000:00:02.1: [10de:0d72] type 00 class 0x050000
[    0.398314] pci 0000:00:03.0: [10de:0d80] type 00 class 0x060100
[    0.398330] pci 0000:00:03.0: reg 10: [io  0x2100-0x21ff]
[    0.398392] pci 0000:00:03.1: [10de:0d7b] type 00 class 0x050000
[    0.398495] pci 0000:00:03.2: [10de:0d79] type 00 class 0x0c0500
[    0.398517] pci 0000:00:03.2: reg 10: [io  0x2000-0x20ff]
[    0.398531] pci 0000:00:03.2: reg 14: [mem 0x93286000-0x93287fff]
[    0.398557] pci 0000:00:03.2: reg 20: [io  0x2240-0x227f]
[    0.398570] pci 0000:00:03.2: reg 24: [io  0x2200-0x223f]
[    0.398616] pci 0000:00:03.2: PME# supported from D3hot D3cold
[    0.398651] pci 0000:00:03.3: [10de:0d69] type 00 class 0x050000
[    0.398876] pci 0000:00:03.4: [10de:0d7a] type 00 class 0x0b4000
[    0.398904] pci 0000:00:03.4: reg 10: [mem 0x93200000-0x9327ffff]
[    0.399064] pci 0000:00:04.0: [10de:0d9c] type 00 class 0x0c0310
[    0.399084] pci 0000:00:04.0: reg 10: [mem 0x9328a000-0x9328afff]
[    0.399151] pci 0000:00:04.0: supports D1 D2
[    0.399157] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.399181] pci 0000:00:04.1: [10de:0d9d] type 00 class 0x0c0320
[    0.399203] pci 0000:00:04.1: reg 10: [mem 0x9328b100-0x9328b1ff]
[    0.399281] pci 0000:00:04.1: supports D1 D2
[    0.399287] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.399321] pci 0000:00:06.0: [10de:0d9c] type 00 class 0x0c0310
[    0.399340] pci 0000:00:06.0: reg 10: [mem 0x93289000-0x93289fff]
[    0.399407] pci 0000:00:06.0: supports D1 D2
[    0.399413] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.399438] pci 0000:00:06.1: [10de:0d9d] type 00 class 0x0c0320
[    0.399459] pci 0000:00:06.1: reg 10: [mem 0x9328b000-0x9328b0ff]
[    0.399538] pci 0000:00:06.1: supports D1 D2
[    0.399544] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.399582] pci 0000:00:08.0: [10de:0d94] type 00 class 0x040300
[    0.399605] pci 0000:00:08.0: reg 10: [mem 0x93280000-0x93283fff]
[    0.399686] pci 0000:00:08.0: PME# supported from D3hot D3cold
[    0.399715] pci 0000:00:0a.0: [10de:0d88] type 00 class 0x010601
[    0.399735] pci 0000:00:0a.0: reg 10: [io  0x2298-0x229f]
[    0.399748] pci 0000:00:0a.0: reg 14: [io  0x22a4-0x22a7]
[    0.399760] pci 0000:00:0a.0: reg 18: [io  0x2290-0x2297]
[    0.399772] pci 0000:00:0a.0: reg 1c: [io  0x22a0-0x22a3]
[    0.399784] pci 0000:00:0a.0: reg 20: [io  0x2280-0x228f]
[    0.399797] pci 0000:00:0a.0: reg 24: [mem 0x93284000-0x93285fff]
[    0.399859] pci 0000:00:0b.0: [10de:0d75] type 00 class 0x050000
[    0.399881] pci 0000:00:0b.0: reg 10: [mem 0x93288000-0x93288fff]
[    0.400149] pci 0000:00:15.0: [10de:0d9b] type 01 class 0x060400
[    0.400437] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.400506] pci 0000:00:17.0: [10de:0d76] type 01 class 0x060400
[    0.400568] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    0.400851] pci 0000:01:00.0: [14e4:4353] type 00 class 0x028000
[    0.400880] pci 0000:01:00.0: reg 10: [mem 0x93100000-0x93103fff 64bit]
[    0.401004] pci 0000:01:00.0: supports D1 D2
[    0.401010] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.401080] pci 0000:00:15.0: PCI bridge to [bus 01]
[    0.401107] pci 0000:00:15.0:   bridge window [mem 0x93100000-0x931fffff]
[    0.401170] pci 0000:02:00.0: [10de:08a2] type 00 class 0x030000
[    0.401191] pci 0000:02:00.0: reg 10: [mem 0x92000000-0x92ffffff]
[    0.401207] pci 0000:02:00.0: reg 14: [mem 0x80000000-0x8fffffff 64bit pref]
[    0.401222] pci 0000:02:00.0: reg 1c: [mem 0x90000000-0x91ffffff 64bit pref]
[    0.401235] pci 0000:02:00.0: reg 24: [io  0x1000-0x107f]
[    0.401247] pci 0000:02:00.0: reg 30: [mem 0x93000000-0x9301ffff pref]
[    0.401317] pci 0000:00:17.0: PCI bridge to [bus 02]
[    0.401326] pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
[    0.401334] pci 0000:00:17.0:   bridge window [mem 0x92000000-0x930fffff]
[    0.401345] pci 0000:00:17.0:   bridge window [mem 0x80000000-0x91ffffff 64bit pref]
[    0.401372] pci_bus 0000:00: on NUMA node 0
[    0.401379] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.401576] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.401719]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.401917]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.418819] ACPI: PCI Interrupt Link [LNK1] (IRQs *16 17 18 19 20 21 22 23)
[    0.418941] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 *17 18 19 20 21 22 23)
[    0.419061] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 *18 19 20 21 22 23)
[    0.419180] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 *19 20 21 22 23)
[    0.419298] ACPI: PCI Interrupt Link [Z00J] (IRQs 16 17 18 19 20 *21 22 23)
[    0.419417] ACPI: PCI Interrupt Link [Z00K] (IRQs 16 17 18 19 20 *21 22 23)
[    0.419536] ACPI: PCI Interrupt Link [Z00L] (IRQs 16 17 18 19 20 *21 22 23)
[    0.419655] ACPI: PCI Interrupt Link [Z00M] (IRQs 16 17 18 19 20 *21 22 23)
[    0.419774] ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 *22 23)
[    0.419891] ACPI: PCI Interrupt Link [LUS0] (IRQs 16 *17 18 19 20 21 22 23)
[    0.420019] ACPI: PCI Interrupt Link [LUS2] (IRQs 16 *17 18 19 20 21 22 23)
[    0.420137] ACPI: PCI Interrupt Link [LMAC] (IRQs 16 *17 18 19 20 21 22 23)
[    0.420257] ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 *20 21 22 23)
[    0.420377] ACPI: PCI Interrupt Link [LGPU] (IRQs *16 17 18 19 20 21 22 23)
[    0.420496] ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.420620] ACPI: PCI Interrupt Link [LSI0] (IRQs 16 17 *18 19 20 21 22 23)
[    0.420738] ACPI: PCI Interrupt Link [Z000] (IRQs 16 17 *18 19 20 21 22 23)
[    0.420856] ACPI: PCI Interrupt Link [Z001] (IRQs 16 17 18 19 20 21 *22 23)
[    0.420970] ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.421048] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=none,locks=none
[    0.421048] vgaarb: loaded
[    0.421048] vgaarb: bridge control possible 0000:02:00.0
[    0.421048] SCSI subsystem initialized
[    0.421048] ACPI: bus type scsi registered
[    0.421048] libata version 3.00 loaded.
[    0.421048] ACPI: bus type usb registered
[    0.421048] usbcore: registered new interface driver usbfs
[    0.421048] usbcore: registered new interface driver hub
[    0.421048] usbcore: registered new device driver usb
[    0.421048] wmi: Mapper loaded
[    0.421048] Advanced Linux Sound Architecture Driver Initialized.
[    0.421048] PCI: Using ACPI for IRQ routing
[    0.421048] PCI: pci_cache_line_size set to 64 bytes
[    0.421048] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.421048] e820: reserve RAM buffer [mem 0x6f000000-0x6fffffff]
[    0.421048] e820: reserve RAM buffer [mem 0x7f719000-0x7fffffff]
[    0.421048] e820: reserve RAM buffer [mem 0x7f954000-0x7fffffff]
[    0.421048] e820: reserve RAM buffer [mem 0x7f96f000-0x7fffffff]
[    0.421048] e820: reserve RAM buffer [mem 0x7f9b2000-0x7fffffff]
[    0.421048] e820: reserve RAM buffer [mem 0x7fef9000-0x7fffffff]
[    0.421048] Bluetooth: Core ver 2.16
[    0.421048] NET: Registered protocol family 31
[    0.421048] Bluetooth: HCI device and connection manager initialized
[    0.421048] Bluetooth: HCI socket layer initialized
[    0.421048] Bluetooth: L2CAP socket layer initialized
[    0.421048] Bluetooth: SCO socket layer initialized
[    0.421048] cfg80211: Calling CRDA to update world regulatory domain
[    0.421048] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.428013] Switching to clocksource hpet
[    0.428080] pnp: PnP ACPI init
[    0.428098] ACPI: bus type pnp registered
[    0.428198] pnp 00:00: [bus 00-ff]
[    0.428205] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.428212] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.428218] pnp 00:00: [io  0x0d00-0xffff window]
[    0.428224] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.428230] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.428237] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.428243] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.428250] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.428256] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.428262] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.428269] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.428275] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.428282] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.428288] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.428294] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.428301] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.428307] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.428314] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.428357] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.428390] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.428397] pnp 00:01: [mem 0xf0000000-0xf3ffffff]
[    0.428443] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.428453] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.428474] pnp 00:02: [io  0x0300-0x031f]
[    0.428488] pnp 00:02: [irq 6]
[    0.428515] pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
[    0.428568] pnp 00:03: [io  0x0000-0x0008]
[    0.428575] pnp 00:03: [io  0x000a-0x000f]
[    0.428581] pnp 00:03: [io  0x0081-0x0083]
[    0.428586] pnp 00:03: [io  0x0087]
[    0.428592] pnp 00:03: [io  0x0089-0x008b]
[    0.428597] pnp 00:03: [io  0x008f]
[    0.428602] pnp 00:03: [io  0x00c0-0x00d1]
[    0.428607] pnp 00:03: [io  0x00d4-0x00df]
[    0.428613] pnp 00:03: [dma 4]
[    0.428640] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.428719] pnp 00:04: [irq 0 disabled]
[    0.428730] pnp 00:04: [irq 8]
[    0.428735] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.428781] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.428791] system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.428811] pnp 00:05: [io  0x00f0-0x00f1]
[    0.428822] pnp 00:05: [irq 13]
[    0.428849] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.428999] pnp 00:06: [io  0x0400-0x047f]
[    0.429006] pnp 00:06: [io  0x0480-0x04ff]
[    0.429012] pnp 00:06: [io  0x0500-0x057f]
[    0.429019] pnp 00:06: [io  0x0580-0x05ff]
[    0.429025] pnp 00:06: [io  0x0800-0x087f]
[    0.429030] pnp 00:06: [io  0x0880-0x08ff]
[    0.429036] pnp 00:06: [io  0x0010-0x001f]
[    0.429041] pnp 00:06: [io  0x0022-0x003f]
[    0.429046] pnp 00:06: [io  0x0044-0x005f]
[    0.429052] pnp 00:06: [io  0x0063]
[    0.429057] pnp 00:06: [io  0x0065]
[    0.429062] pnp 00:06: [io  0x0067-0x006f]
[    0.429067] pnp 00:06: [io  0x0072-0x0073]
[    0.429072] pnp 00:06: [io  0x0074-0x007f]
[    0.429078] pnp 00:06: [io  0x0091-0x0093]
[    0.429083] pnp 00:06: [io  0x0097-0x009f]
[    0.429088] pnp 00:06: [io  0x00a2-0x00bf]
[    0.429094] pnp 00:06: [io  0x00e0-0x00ef]
[    0.429099] pnp 00:06: [io  0x04d0-0x04d1]
[    0.429104] pnp 00:06: [io  0x0080]
[    0.429109] pnp 00:06: [io  0x0295-0x0296]
[    0.429168] system 00:06: [io  0x0400-0x047f] has been reserved
[    0.429177] system 00:06: [io  0x0480-0x04ff] has been reserved
[    0.429184] system 00:06: [io  0x0500-0x057f] has been reserved
[    0.429194] system 00:06: [io  0x0580-0x05ff] has been reserved
[    0.429201] system 00:06: [io  0x0800-0x087f] has been reserved
[    0.429209] system 00:06: [io  0x0880-0x08ff] has been reserved
[    0.429217] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.429224] system 00:06: [io  0x0295-0x0296] has been reserved
[    0.429233] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.429249] pnp 00:07: [io  0x0070-0x0077]
[    0.429277] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.434007] pnp: PnP ACPI: found 8 devices
[    0.434013] ACPI: ACPI bus type pnp unregistered
[    0.441752] bcma-pci-bridge 0000:01:00.0: enabling device (0000 -> 0002)
[    0.441940] ACPI: PCI Interrupt Link [Z00J] enabled at IRQ 21
[    0.441979] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[    0.442005] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[    0.442027] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[    0.442065] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[    0.492170] bcma: bus0: Bus registered
[    0.492228] pci 0000:00:15.0: PCI bridge to [bus 01]
[    0.492245] pci 0000:00:15.0:   bridge window [mem 0x93100000-0x931fffff]
[    0.492272] pci 0000:00:17.0: PCI bridge to [bus 02]
[    0.492280] pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
[    0.492289] pci 0000:00:17.0:   bridge window [mem 0x92000000-0x930fffff]
[    0.492298] pci 0000:00:17.0:   bridge window [mem 0x80000000-0x91ffffff 64bit pref]
[    0.492326] pci 0000:00:17.0: setting latency timer to 64
[    0.492333] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.492340] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.492346] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.492353] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.492360] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.492367] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.492373] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.492380] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.492387] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.492393] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.492400] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.492407] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.492413] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.492420] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.492427] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.492433] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    0.492440] pci_bus 0000:00: resource 20 [mem 0x80000000-0xfebfffff]
[    0.492447] pci_bus 0000:01: resource 1 [mem 0x93100000-0x931fffff]
[    0.492454] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.492461] pci_bus 0000:02: resource 1 [mem 0x92000000-0x930fffff]
[    0.492468] pci_bus 0000:02: resource 2 [mem 0x80000000-0x91ffffff 64bit pref]
[    0.492512] NET: Registered protocol family 2
[    0.492693] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.494542] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.495147] TCP: Hash tables configured (established 262144 bind 65536)
[    0.495237] TCP: reno registered
[    0.495249] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.495274] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.495393] NET: Registered protocol family 1
[    0.495551] RPC: Registered named UNIX socket transport module.
[    0.495559] RPC: Registered udp transport module.
[    0.495564] RPC: Registered tcp transport module.
[    0.495568] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.495927] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 17
[    0.548226] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
[    0.548429] ACPI: PCI Interrupt Link [Z000] enabled at IRQ 18
[    0.604199] ACPI: PCI Interrupt Link [Z001] enabled at IRQ 22
[    0.604341] PCI: CLS 256 bytes, default 64
[    0.607115] NFS: Registering the id_resolver key type
[    0.607134] Key type id_resolver registered
[    0.607139] Key type id_legacy registered
[    0.607228] msgmni has been set to 3489
[    0.608601] io scheduler noop registered (default)
[    0.608608] io scheduler deadline registered
[    0.608642] io scheduler cfq registered
[    0.608916] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    0.609143] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    0.609152] bcma-pci-bridge 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.609167] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    0.609859] efifb: probing for efifb
[    0.611189] efifb: framebuffer at 0x80010000, mapped to 0xffffc90000880000, using 6144k, total 6144k
[    0.611198] efifb: mode is 1366x768x32, linelength=8192, pages=1
[    0.611203] efifb: scrolling: redraw
[    0.611209] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.615859] Console: switching to colour frame buffer device 170x48
[    0.620388] fb0: EFI VGA frame buffer device
[    0.620511] ACPI: AC Adapter [ADP1] (on-line)
[    0.620668] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.620746] ACPI: Lid Switch [LID0]
[    0.620825] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.620887] ACPI: Power Button [PWRB]
[    0.620965] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.621026] ACPI: Sleep Button [SLPB]
[    0.621123] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.621179] ACPI: Power Button [PWRF]
[    0.621287] [Firmware Bug]: ACPI(IGPU) defines _DOD but not _DOS
[    0.621446] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[    0.621543] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2b/LNXVIDEO:00/input/input4
[    0.621679] ACPI: Requesting acpi_cpufreq
[    0.621809] Monitor-Mwait will be used to enter C-1 state
[    0.621855] Monitor-Mwait will be used to enter C-2 state
[    0.621899] Monitor-Mwait will be used to enter C-3 state
[    0.621942] tsc: Marking TSC unstable due to TSC halts in idle
[    0.621996] ACPI: acpi_idle registered with cpuidle
[    0.633655] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.633863] Real Time Clock Driver v1.12b
[    0.633942] [drm] Initialized drm 1.1.0 20060810
[    0.634217] checking generic (80010000 600000) vs hw (80000000 10000000)
[    0.635961] fb: conflicting fb hw usage nouveaufb vs EFI VGA - removing generic driver
[    0.637770] Console: switching to colour dummy device 80x25
[    0.637915] nouveau 0000:02:00.0: setting latency timer to 64
[    0.637927] nouveau 0000:02:00.0: enabling device (0006 -> 0007)
[    0.638243] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 16
[    0.638856] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0af100a2
[    0.638865] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP89 (NVAF)
[    0.638872] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    0.643450] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    0.720894] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    0.720902] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    0.721079] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    0.721087] nouveau  [   VBIOS][0000:02:00.0] version 70.89.13.00
[    0.741275] nouveau  [     MXM][0000:02:00.0] no VBIOS data, nothing to do
[    0.824412] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system memory
[    0.824420] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    0.841511] ACPI: Battery Slot [BAT0] (battery present)
[    2.112067] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=1 to enable
[    2.112146] [TTM] Zone  kernel: Available graphics memory: 893286 kiB
[    2.112153] [TTM] Initializing pool allocator
[    2.112162] [TTM] Initializing DMA pool allocator
[    2.114615] nouveau  [     DRM] VRAM: 256 MiB
[    2.114626] nouveau  [     DRM] GART: 512 MiB
[    2.114633] nouveau  [     DRM] BIT BIOS found
[    2.114641] nouveau  [     DRM] Bios version 70.89.13.00
[    2.114648] nouveau  [     DRM] TMDS table version 2.0
[    2.114654] nouveau  [     DRM] DCB version 4.0
[    2.114660] nouveau  [     DRM] DCB outp 00: 040001b6 0f220010
[    2.114667] nouveau  [     DRM] DCB outp 01: 020112a6 0f220010
[    2.114673] nouveau  [     DRM] DCB outp 02: 02011262 00020010
[    2.114679] nouveau  [     DRM] DCB conn 00: 00002047
[    2.114686] nouveau  [     DRM] DCB conn 01: 00101146
[    2.127345] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.127353] [drm] No driver support for vblank timestamp query.
[    3.297663] nouveau  [     DRM] 4 available performance level(s)
[    3.297673] nouveau  [     DRM] 0: core 405MHz shader 405MHz memory 405MHz voltage 900mV
[    3.297683] nouveau  [     DRM] 1: core 450MHz shader 810MHz memory 450MHz voltage 900mV
[    3.297693] nouveau  [     DRM] 2: core 450MHz shader 810MHz memory 450MHz voltage 900mV
[    3.297702] nouveau  [     DRM] 3: core 450MHz shader 950MHz memory 450MHz voltage 900mV
[    3.297711] nouveau  [     DRM] c: core 405MHz shader 810MHz
[    3.397981] nouveau  [     DRM] MM: using M2MF for buffer copies
[    3.473843] nouveau  [     DRM] allocated 1366x768 fb: 0x50000, bo ffff88006eca1400
[    3.473921] fbcon: nouveaufb (fb0) is primary device
[    3.520860] Console: switching to colour frame buffer device 170x48
[    3.526090] fb0: nouveaufb frame buffer device
[    3.526133] drm: registered panic notifier
[    3.526176] [drm] Initialized nouveau 1.1.0 20120801 for 0000:02:00.0 on minor 0
[    3.526305] loop: module loaded
[    3.526439] ahci 0000:00:0a.0: version 3.0
[    3.526665] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 20
[    3.526740] ahci 0000:00:0a.0: irq 41 for MSI/MSI-X
[    3.526786] ahci 0000:00:0a.0: AHCI 0001.0300 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
[    3.526803] ahci 0000:00:0a.0: flags: 64bit ncq sntf pm led pio slum part apst 
[    3.526818] ahci 0000:00:0a.0: setting latency timer to 64
[    3.527026] scsi0 : ahci
[    3.527102] ata1: SATA max UDMA/133 abar m8192@0x93284000 port 0x93284100 irq 41
[    3.527152] tun: Universal TUN/TAP device driver, 1.6
[    3.527162] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.527229] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 21
[    3.528034] usbcore: registered new interface driver asix
[    3.528054] usbcore: registered new interface driver cdc_ether
[    3.528071] usbcore: registered new interface driver cdc_eem
[    3.528090] usbcore: registered new interface driver rndis_host
[    3.528113] usbcore: registered new interface driver ipheth
[    3.528131] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.528173] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    3.528187] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    3.529285] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 1
[    3.529395] ieee80211 phy0: Selected rate control algorithm 'pid'
[    3.532243] ehci_hcd 0000:00:04.1: disable lpm/ppcd for nvidia mcp89
[    3.533646] ehci_hcd 0000:00:04.1: debug port 1
[    3.556020] ehci_hcd 0000:00:04.1: cache line size of 256 is not supported
[    3.556405] ehci_hcd 0000:00:04.1: irq 23, io mem 0x9328b100
[    3.568019] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.10
[    3.568567] hub 1-0:1.0: USB hub found
[    3.569071] hub 1-0:1.0: 6 ports detected
[    3.571039] ehci_hcd 0000:00:06.1: setting latency timer to 64
[    3.571983] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    3.573463] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bus number 2
[    3.574903] ehci_hcd 0000:00:06.1: disable lpm/ppcd for nvidia mcp89
[    3.576328] ehci_hcd 0000:00:06.1: debug port 1
[    3.600022] ehci_hcd 0000:00:06.1: cache line size of 256 is not supported
[    3.600397] ehci_hcd 0000:00:06.1: irq 22, io mem 0x9328b000
[    3.612019] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.10
[    3.612514] hub 2-0:1.0: USB hub found
[    3.612840] hub 2-0:1.0: 6 ports detected
[    3.614573] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.615424] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    3.616725] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    3.618017] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 3
[    3.619344] ohci_hcd 0000:00:04.0: irq 17, io mem 0x9328a000
[    3.678145] hub 3-0:1.0: USB hub found
[    3.678489] hub 3-0:1.0: 6 ports detected
[    3.679305] ohci_hcd 0000:00:06.0: setting latency timer to 64
[    3.680061] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    3.681292] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bus number 4
[    3.682572] ohci_hcd 0000:00:06.0: irq 18, io mem 0x93289000
[    3.738149] hub 4-0:1.0: USB hub found
[    3.738491] hub 4-0:1.0: 6 ports detected
[    3.739284] uhci_hcd: USB Universal Host Controller Interface driver
[    3.739987] usbcore: registered new interface driver cdc_acm
[    3.741167] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    3.742427] usbcore: registered new interface driver usblp
[    3.743654] Initializing USB Mass Storage driver...
[    3.744926] usbcore: registered new interface driver usb-storage
[    3.746136] USB Mass Storage support registered.
[    3.747409] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.749491] i8042: No controller found
[    3.749935] mousedev: PS/2 mouse device common for all mice
[    3.751388] usbcore: registered new interface driver appletouch
[    3.752542] usbcore: registered new interface driver bcm5974
[    3.753910] usbcore: registered new interface driver wacom
[    3.844026] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.844614] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (unknown) filtered out
[    3.844968] ata1.00: ATA-8: APPLE SSD TS128C, CJAA0201, max UDMA/100
[    3.846002] ata1.00: 236978176 sectors, multi 16: LBA48 
[    3.847558] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (unknown) filtered out
[    3.848673] ata1.00: configured for UDMA/100
[    3.864111] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD TS128C CJAA PQ: 0 ANSI: 5
[    3.864588] ACPI: Invalid Power Resource to register!
[    3.864633] sd 0:0:0:0: [sda] 236978176 512-byte logical blocks: (121 GB/113 GiB)
[    3.866293] sd 0:0:0:0: [sda] Write Protect is off
[    3.867630] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.869059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.871794]  sda: sda1 sda2 sda3 sda4
[    3.872430] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.904623] applesmc: key=313 fan=1 temp=27 index=26 acc=0 lux=0 kbd=0
[    3.905175] usbcore: registered new interface driver btusb
[    3.905578] cpuidle: using governor ladder
[    3.907051] cpuidle: using governor menu
[    3.908455] EFI Variables Facility v0.08 2004-May-17
[    4.104117] usb 1-6: new high-speed USB device number 4 using ehci_hcd
[    4.217254] usbcore: registered new interface driver usbhid
[    4.217612] usbhid: USB HID core driver
[    4.218563] snd_hda_intel 0000:00:08.0: enabling device (0000 -> 0002)
[    4.219913] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 19
[    4.221247] hda_intel: Disabling MSI
[    4.222724] hda_intel: position_fix set to 1 for device 10de:cb89
[    4.224304] snd_hda_intel 0000:00:08.0: setting latency timer to 64
[    4.556099] usb 3-3: new full-speed USB device number 2 using ohci_hcd
[    4.798973] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.0/input/input5
[    4.799433] apple 0003:05AC:0243.0001: input: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/input0
[    4.811113] apple 0003:05AC:0243.0002: device has no listeners, quitting
[    4.811505] apple 0003:05AC:0243.0002: hw start failed
[    4.814159] input: bcm5974 as /devices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.2/input/input6
[    5.116099] usb 3-5: new full-speed USB device number 3 using ohci_hcd
[    5.341152] hub 3-5:1.0: USB hub found
[    5.344103] hub 3-5:1.0: 3 ports detected
[    5.690112] usb 3-5.1: new full-speed USB device number 4 using ohci_hcd
[    5.811485] input: HID 05ac:820a as /devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5.1/3-5.1:1.0/input/input7
[    5.811946] hid-generic 0003:05AC:820A.0003: input: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:04.0-5.1/input0
[    5.890112] usb 3-5.2: new full-speed USB device number 5 using ohci_hcd
[    6.011441] input: HID 05ac:820b as /devices/pci0000:00/0000:00:04.0/usb3/3-5/3-5.2/3-5.2:1.0/input/input8
[    6.011977] hid-generic 0003:05AC:820B.0004: input: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:04.0-5.2/input0
[    6.090112] usb 3-5.3: new full-speed USB device number 6 using ohci_hcd
[    6.242115] usb 3-5.1: USB disconnect, device number 4
[    6.464056] usb 3-5.2: USB disconnect, device number 5
[    6.512352] TCP: cubic registered
[    6.512738] Initializing XFRM netlink socket
[    6.514062] NET: Registered protocol family 10
[    6.516098] sit: IPv6 over IPv4 tunneling driver
[    6.517862] NET: Registered protocol family 17
[    6.519597] NET: Registered protocol family 15
[    6.521437] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    6.523271] Bluetooth: HIDP socket layer initialized
[    6.525152] Key type dns_resolver registered
[    6.528606] ALSA device list:
[    6.528961]   #0: HDA NVidia at 0x93280000 irq 19
[    6.745528] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    6.936320] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    7.244687] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    7.245385] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    7.250748] devtmpfs: mounted
[    7.251598] Freeing unused kernel memory: 516k freed
[    7.408356] systemd[1]: systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    7.414186] systemd[1]: Set hostname to <polaris>.
[    7.499039] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[    7.501054] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    7.502942] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    7.504873] systemd[1]: Starting Remote File Systems.
[    7.508865] systemd[1]: Reached target Remote File Systems.
[    7.510785] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    7.514771] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    7.516656] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    7.520460] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    7.522320] systemd[1]: Starting Delayed Shutdown Socket.
[    7.526104] systemd[1]: Listening on Delayed Shutdown Socket.
[    7.527947] systemd[1]: Starting LVM2 metadata daemon socket.
[    7.531734] systemd[1]: Listening on LVM2 metadata daemon socket.
[    7.533583] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    7.535377] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    7.537248] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    7.539049] systemd[1]: Starting udev Kernel Socket.
[    7.542500] systemd[1]: Listening on udev Kernel Socket.
[    7.544274] systemd[1]: Starting udev Control Socket.
[    7.547753] systemd[1]: Listening on udev Control Socket.
[    7.549503] systemd[1]: Starting Swap.
[    7.553084] systemd[1]: Reached target Swap.
[    7.554833] systemd[1]: Expecting device dev-sda3.device...
[    7.558448] systemd[1]: Starting Journal Socket.
[    7.562087] systemd[1]: Listening on Journal Socket.
[    7.563854] systemd[1]: Starting File System Check on Root Device...
[    7.612722] systemd[1]: Starting udev Coldplug all Devices...
[    7.658149] systemd[1]: Started Set Up Additional Binary Formats.
[    7.658572] systemd[1]: Starting Setup Virtual Console...
[    7.700863] systemd[1]: Mounted Huge Pages File System.
[    7.701584] systemd[1]: Mounted Configuration File System.
[    7.702338] systemd[1]: Starting udev Kernel Device Manager...
[    7.736264] systemd[1]: Mounted POSIX Message Queue File System.
[    7.736653] systemd[1]: Mounted FUSE Control File System.
[    7.737407] systemd[1]: Starting Journal Service...
[    7.739526] systemd-udevd[99]: starting version 197
[    7.784642] systemd[1]: Started Journal Service.
[    7.786862] systemd[1]: Started udev Kernel Device Manager.
[    7.836530] systemd[1]: Started File System Check on Root Device.
[    7.896550] systemd[1]: Started Setup Virtual Console.
[    7.897157] systemd[1]: Starting Remount Root and Kernel File Systems...
[    7.949413] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro,discard
[    7.956552] systemd[1]: Started udev Coldplug all Devices.
[    7.976550] systemd[1]: Started Remount Root and Kernel File Systems.
[    7.977226] systemd[1]: Starting Local File Systems (Pre).
[    7.980390] systemd[1]: Reached target Local File Systems (Pre).
[    7.981962] systemd[1]: Mounting /tmp...
[    8.016174] systemd[1]: Starting Load Random Seed...
[    8.049781] systemd[1]: Starting Sound Card.
[    8.050774] systemd[1]: Reached target Sound Card.
[    8.054020] systemd[1]: Mounted /tmp.
[    8.097085] systemd[1]: Started Load Random Seed.
[    8.105764] systemd[1]: Found device APPLE_SSD_TS128C.
[    8.106358] systemd[1]: Starting File System Check on /dev/sda3...
[    8.217069] systemd[1]: Started File System Check on /dev/sda3.
[    8.217774] systemd[1]: Mounting /home...
[    8.551402] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: discard
[    8.553398] systemd[1]: Mounted /home.
[    8.554267] systemd[1]: Starting Local File Systems.
[    8.557555] systemd[1]: Reached target Local File Systems.
[    8.561213] systemd[1]: Starting Recreate Volatile Files and Directories...
[    8.596615] systemd[1]: Starting Trigger Flushing of Journal to Persistent Storage...
[    8.689137] systemd[1]: Started Recreate Volatile Files and Directories.
[    8.689849] systemd[1]: Starting System Initialization.
[    8.693175] systemd[1]: Reached target System Initialization.
[    8.694840] systemd[1]: Starting Restore Sound Card State...
[    8.748582] systemd[1]: Starting Daily Cleanup of Temporary Directories.
[    8.749361] systemd[1]: Started Daily Cleanup of Temporary Directories.
[    8.750097] systemd[1]: Starting D-Bus System Message Bus Socket.
[    8.753266] systemd[1]: Listening on D-Bus System Message Bus Socket.
[    8.754862] systemd[1]: Starting Sockets.
[    8.758214] systemd[1]: Reached target Sockets.
[    8.759815] systemd[1]: Starting Basic System.
[    8.763126] systemd[1]: Reached target Basic System.
[    8.764714] systemd[1]: Starting Provides automatic netcfg wireless connection...
[    8.808436] systemd[1]: Starting Local fixups...
[    8.844347] systemd[1]: Starting Periodic Command Scheduler...
[    8.884269] systemd[1]: Starting Login Service...
[    8.923025] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[    8.923389] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[    8.925472] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.927755] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.929993] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.932205] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.934385] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.936536] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.938637] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.940720] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.942775] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.944820] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.946808] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.948764] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.950690] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.952623] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.954511] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.956383] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.958216] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.960027] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.961779] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.963498] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.965193] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.966843] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.968471] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.970064] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.971631] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.973194] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.974720] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.976226] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.977701] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.979160] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.980590] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.981979] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.983346] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.984700] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.986021] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.987334] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.988631] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.989901] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.991127] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.992319] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.993481] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.994620] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.995723] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.996819] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.997883] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.998926] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    8.999929] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.000917] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.001827] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.002731] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.003636] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.004555] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.005462] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.006362] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.007257] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.008171] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.009073] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.009980] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.010880] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.011780] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.012693] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.013596] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.014505] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.015413] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.016328] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.017231] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.018136] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.019040] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.019945] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.020861] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.021775] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.022687] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.023593] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.024504] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.025406] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.026312] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.027203] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.028113] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.028998] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.029888] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.030784] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.031685] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.032597] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.033496] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.034389] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.035293] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.036200] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.037093] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.037992] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.038917] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.039810] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.040705] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.041587] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.042480] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.043400] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.044293] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.045186] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.046097] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.047007] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.047886] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.048770] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.049657] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.050554] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.051442] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.052339] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.053229] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.054131] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.055019] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.055919] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.056803] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.057680] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.058585] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.059499] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.060383] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.061262] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.062154] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.063032] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.063937] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.064823] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.065697] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.066609] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.067521] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.068400] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.069276] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.070172] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.071081] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.071993] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.072887] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.073760] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.074665] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.075545] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.076417] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.077290] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.078170] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.079079] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.079985] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.080872] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.081757] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.082633] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.083537] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.084434] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.085313] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.086229] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.087113] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.088002] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.088901] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.089787] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.090706] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.091597] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.092496] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.093384] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.094276] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.095167] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.096069] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.096962] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.097846] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.098742] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.099640] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.100547] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.101443] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.102349] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.103253] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.104165] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.105058] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.105959] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.106861] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.107764] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.108676] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.109582] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.110490] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.111396] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.112315] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.113222] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.114133] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.115036] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.116183] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.116301] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.116301] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.119551] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.120657] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.121694] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.122988] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.124006] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.124642] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.126312] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.127212] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.128112] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.129004] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.130143] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.131099] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.132000] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.132914] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.133938] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.134844] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.135738] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.136647] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.137543] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.137899] systemd[1]: Starting D-Bus System Message Bus...
[    9.139270] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.139420] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    9.139476] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    9.188723] systemd[1]: Started D-Bus System Message Bus.
[    9.256803] systemd-journald[101]: Received SIGUSR1
[    9.270351] systemd-journald[101]: File /var/log/journal/955918ddf496dd79f30e3a4b00000a36/system.journal corrupted or uncleanly shut down, renaming and replacing.
[   13.121223] wlan0: authenticate with 00:18:e7:e9:e7:1d
[   13.131504] wlan0: send auth to 00:18:e7:e9:e7:1d (try 1/3)
[   13.133043] wlan0: authenticated
[   13.136160] wlan0: associate with 00:18:e7:e9:e7:1d (try 1/3)
[   13.139446] wlan0: RX AssocResp from 00:18:e7:e9:e7:1d (capab=0x431 status=0 aid=2)
[   13.139880] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[   13.139909] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   13.139936] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   13.139970] wlan0: associated
[   13.141499] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   18.768448] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
