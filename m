Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3EOPUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:20:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:13976 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758243Ab3EOPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:20:46 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Ic89bhc85dh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839hd25he5bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1bceh1d0ch1d2eh1d3fh34h1155h)
X-WSS-ID: 0MMUIMG-01-2TX-02
X-M-MSG: 
Message-ID: <5193A7C3.4010503@amd.com>
Date: Wed, 15 May 2013 17:20:35 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.9 breaks EFI boot on E350
References: <51935981.3010808@amd.com> <CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com>
In-Reply-To: <CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="------------090000060300000404030807"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090000060300000404030807
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 15.05.2013 16:46, schrieb Yinghai Lu:
> On Wed, May 15, 2013 at 2:46 AM, Christian K=F6nig
> <christian.koenig@amd.com> wrote:
>> Hi guys,
>>
>> the following commit breaks booting my E350 based test system in EFI m=
ode:
>>
>>> commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>> Author: Yinghai Lu <yinghai@kernel.org>
>>> Date:   Fri Nov 16 19:38:58 2012 -0800
>>>
>>>      x86, mm: setup page table in top-down
>>
>> This commit was supposed to fix it but obviously there still seem to b=
e some
>> bugs left in 3.9
>>
>>> commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
>>> Author: Yinghai Lu <yinghai@kernel.org>
>>> Date:   Wed Mar 6 20:18:21 2013 -0800
>>>
>>>      x86, mm: Make sure to find a 2M free block for the first mapped =
area
>>>
>>>      Henrik reported that his MacAir 3.1 would not boot with
>>>
>>>      | commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>>      | Date:   Fri Nov 16 19:38:58 2012 -0800
>>>      |
>>>      |    x86, mm: setup page table in top-down
>>>
> can you send out working boot log with memory map?
>
> you need to boot system with "debug ignore_loglevel"

Sure, dmesg output it attached. Let me know if you need anything else.

Christian.

> Thanks
>
> Yinghai
>


--------------090000060300000404030807
Content-Type: text/x-log; name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="dmesg.log"
Content-Description: dmesg.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-19-generic (buildd@allspice) (gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-1ubuntu1) ) #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 (Ubuntu 3.8.0-19.30-generic 3.8.8)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-19-generic root=UUID=f7d7dd2b-3dec-4d67-ae48-6c6c8d8ae7ff ro debug ignore_loglevel
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006ea07fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006ea08000-0x000000006ea55fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006ea56000-0x000000006f47efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006f47f000-0x000000006f87bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006f87c000-0x000000006f87cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000006f87d000-0x000000006f883fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006f884000-0x000000006fc97fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006fc98000-0x000000006fef2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006fef3000-0x000000006fefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x6f470000  ACPI 2.0=0x6f470000  SMBIOS=0xf04c0  MPS=0xfd480 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x0000000000077000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x0000000000077000-0x0000000000078000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x0000000000078000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000001000000-0x0000000002445000) (20MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000002445000-0x000000003611e000) (828MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x000000003611e000-0x0000000037087000) (15MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000037087000-0x0000000047eac000) (270MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000047eac000-0x0000000060e2a000) (399MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000060e2a000-0x0000000060e30000) (0MB)
[    0.000000] efi: mem11: type=1, attr=0xf, range=[0x0000000060e30000-0x0000000060e4e000) (0MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000060e4e000-0x0000000063690000) (40MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x0000000063690000-0x00000000638d1000) (2MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x00000000638d1000-0x0000000063d07000) (4MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x0000000063d07000-0x0000000063eea000) (1MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x0000000063eea000-0x0000000063eef000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x0000000063eef000-0x0000000063ef0000) (0MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x0000000063ef0000-0x0000000064027000) (1MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x0000000064027000-0x0000000064055000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x0000000064055000-0x000000006405b000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x000000006405b000-0x00000000640bf000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000640bf000-0x00000000640c0000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x00000000640c0000-0x00000000640c4000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x00000000640c4000-0x00000000640c5000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x00000000640c5000-0x000000006e3fd000) (163MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x000000006e3fd000-0x000000006e808000) (4MB)
[    0.000000] efi: mem27: type=2, attr=0xf, range=[0x000000006e808000-0x000000006e812000) (0MB)
[    0.000000] efi: mem28: type=3, attr=0xf, range=[0x000000006e812000-0x000000006ea08000) (1MB)
[    0.000000] efi: mem29: type=0, attr=0xf, range=[0x000000006ea08000-0x000000006ea17000) (0MB)
[    0.000000] efi: mem30: type=0, attr=0xf, range=[0x000000006ea17000-0x000000006ea56000) (0MB)
[    0.000000] efi: mem31: type=10, attr=0xf, range=[0x000000006ea56000-0x000000006ec65000) (2MB)
[    0.000000] efi: mem32: type=10, attr=0xf, range=[0x000000006ec65000-0x000000006f47f000) (8MB)
[    0.000000] efi: mem33: type=6, attr=0x800000000000000f, range=[0x000000006f47f000-0x000000006f799000) (3MB)
[    0.000000] efi: mem34: type=6, attr=0x800000000000000f, range=[0x000000006f799000-0x000000006f7aa000) (0MB)
[    0.000000] efi: mem35: type=6, attr=0x800000000000000f, range=[0x000000006f7aa000-0x000000006f7ac000) (0MB)
[    0.000000] efi: mem36: type=6, attr=0x800000000000000f, range=[0x000000006f7ac000-0x000000006f845000) (0MB)
[    0.000000] efi: mem37: type=5, attr=0x800000000000000f, range=[0x000000006f845000-0x000000006f850000) (0MB)
[    0.000000] efi: mem38: type=5, attr=0x800000000000000f, range=[0x000000006f850000-0x000000006f87c000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x000000006f87c000-0x000000006f87d000) (0MB)
[    0.000000] efi: mem40: type=10, attr=0xf, range=[0x000000006f87d000-0x000000006f884000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x000000006f884000-0x000000006f9d3000) (1MB)
[    0.000000] efi: mem42: type=3, attr=0xf, range=[0x000000006f9d3000-0x000000006fc71000) (2MB)
[    0.000000] efi: mem43: type=4, attr=0xf, range=[0x000000006fc71000-0x000000006fc86000) (0MB)
[    0.000000] efi: mem44: type=3, attr=0xf, range=[0x000000006fc86000-0x000000006fc98000) (0MB)
[    0.000000] efi: mem45: type=6, attr=0x800000000000000f, range=[0x000000006fc98000-0x000000006fef3000) (2MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x000000006fef3000-0x000000006ff00000) (0MB)
[    0.000000] efi: mem47: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem48: type=11, attr=0x8000000000000001, range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] efi: mem49: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] efi: mem50: type=11, attr=0x8000000000000001, range=[0x00000000fed61000-0x00000000fed71000) (0MB)
[    0.000000] efi: mem51: type=11, attr=0x8000000000000001, range=[0x00000000fed80000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem52: type=11, attr=0x8000000000000001, range=[0x00000000fef00000-0x0000000100000000) (17MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./E350M1, BIOS P1.80 12/21/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x6ff00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 06FF00000 mask FFFF00000 uncachable
[    0.000000]   2 base 070000000 mask FF0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 1791MB, range: 1MB, type UC
[    0.000000] reg 2, base: 1792MB, range: 256MB, type UC
[    0.000000] total RAM covered: 1791M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 1791MB, range: 1MB, type UC
[    0.000000] reg 2, base: 1792MB, range: 256MB, type UC
[    0.000000] found SMP MP-table at [mem 0x000fd6e0-0x000fd6ef] mapped at [ffff8800000fd6e0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x6fefffff]
[    0.000000]  [mem 0x00000000-0x3fffffff] page 1G
[    0.000000]  [mem 0x40000000-0x6fdfffff] page 2M
[    0.000000]  [mem 0x6fe00000-0x6fefffff] page 4k
[    0.000000] kernel direct mapping tables up to 0x6fefffff @ [mem 0x1fffd000-0x1fffffff]
[    0.000000] RAMDISK: [mem 0x3611e000-0x37086fff]
[    0.000000] ACPI: RSDP 000000006f470000 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 000000006f470078 0006C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 000000006f4759b8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20121018/tbfadt-598)
[    0.000000] ACPI: DSDT 000000006f470178 0583F (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 000000006f47df80 00040
[    0.000000] ACPI: APIC 000000006f475ab0 00062 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 000000006f475b18 00044 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 000000006f475b60 0003C (v01 ALASKA    A M I 01072009 MSFT 00010013)
[    0.000000] ACPI: AAFT 000000006f475ba0 00042 (v01 ALASKA OEMAAFT  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 000000006f475be8 00038 (v01 ALASKA    A M I 01072009 AMI  00000005)
[    0.000000] ACPI: BGRT 000000006f475c20 00038 (v00 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 000000006f475c58 003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 000000006f476038 0168E (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000006fefffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x6fefffff]
[    0.000000]   NODE_DATA [mem 0x6e80d000-0x6e811fff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880061a00000-ffff8800635fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x6ea07fff]
[    0.000000]   node   0: [mem 0x6f87c000-0x6f87cfff]
[    0.000000]   node   0: [mem 0x6f884000-0x6fc97fff]
[    0.000000]   node   0: [mem 0x6fef3000-0x6fefffff]
[    0.000000] On node 0 totalpages: 454074
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 9 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7100 pages used for memmap
[    0.000000]   DMA32 zone: 442990 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000006ea08000 - 000000006ea56000
[    0.000000] PM: Registered nosave memory: 000000006ea56000 - 000000006f47f000
[    0.000000] PM: Registered nosave memory: 000000006f47f000 - 000000006f87c000
[    0.000000] PM: Registered nosave memory: 000000006f87d000 - 000000006f884000
[    0.000000] PM: Registered nosave memory: 000000006fc98000 - 000000006fef3000
[    0.000000] e820: [mem 0x6ff00000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880063a00000 s85056 r8192 d21440 u1048576
[    0.000000] pcpu-alloc: s85056 r8192 d21440 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 446901
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-19-generic root=UUID=f7d7dd2b-3dec-4d67-ae48-6c6c8d8ae7ff ro debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1577556k/1833984k available (7006k kernel code, 17688k absent, 238740k reserved, 6238k data, 992k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 7340032 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 1600.049 MHz processor
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3200.09 BogoMIPS (lpj=6400196)
[    0.000021] pid_max: default: 32768 minimum: 301
[    0.002035] Security Framework initialized
[    0.002058] AppArmor: AppArmor initialized
[    0.002064] Yama: becoming mindful.
[    0.002438] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003878] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004558] Mount-cache hash table entries: 256
[    0.004935] Initializing cgroup subsys cpuacct
[    0.004951] Initializing cgroup subsys memory
[    0.004972] Initializing cgroup subsys devices
[    0.004979] Initializing cgroup subsys freezer
[    0.004987] Initializing cgroup subsys blkio
[    0.004994] Initializing cgroup subsys perf_event
[    0.005003] Initializing cgroup subsys hugetlb
[    0.005056] tseg: 006ff00000
[    0.005064] CPU: Physical Processor ID: 0
[    0.005069] CPU: Processor Core ID: 0
[    0.005076] mce: CPU supports 6 MCE banks
[    0.005097] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.005097] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.005097] tlb_flushall_shift: 5
[    0.005345] Freeing SMP alternatives: 24k freed
[    0.010065] ACPI: Core revision 20121018
[    0.031149] ftrace: allocating 26690 entries in 105 pages
[    0.056391] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.096037] smpboot: CPU0: AMD E-350D APU with Radeon(tm) HD Graphics (fam: 14, model: 02, stepping: 00)
[    0.201164] Performance Events: AMD PMU driver.
[    0.201176] ... version:                0
[    0.201181] ... bit width:              48
[    0.201186] ... generic registers:      4
[    0.201192] ... value mask:             0000ffffffffffff
[    0.201197] ... max period:             00007fffffffffff
[    0.201202] ... fixed-purpose events:   0
[    0.201207] ... event mask:             000000000000000f
[    0.203543] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.203766] smpboot: Booting Node   0, Processors  #1 OK
[    0.216814] Brought up 2 CPUs
[    0.216822] smpboot: Total of 2 processors activated (6400.19 BogoMIPS)
[    0.217769] devtmpfs: initialized
[    0.219958] EVM: security.selinux
[    0.219965] EVM: security.SMACK64
[    0.219970] EVM: security.capability
[    0.220094] PM: Registering ACPI NVS region [mem 0x6ea56000-0x6f47efff] (10653696 bytes)
[    0.220498] PM: Registering ACPI NVS region [mem 0x6f87d000-0x6f883fff] (28672 bytes)
[    0.222464] regulator-dummy: no parameters
[    0.222589] NET: Registered protocol family 16
[    0.223035] ACPI: bus type pci registered
[    0.223147] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.223160] PCI: not using MMCONFIG
[    0.223166] PCI: Using configuration type 1 for base access
[    0.223171] PCI: Using configuration type 1 for extended access
[    0.225090] bio: create slab <bio-0> at 0
[    0.225317] ACPI: Added _OSI(Module Device)
[    0.225328] ACPI: Added _OSI(Processor Device)
[    0.225334] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.225341] ACPI: Added _OSI(Processor Aggregator Device)
[    0.226974] ACPI: EC: Look up EC in DSDT
[    0.228841] ACPI: Executed 2 blocks of module-level executable AML code
[    0.232943] ACPI: Interpreter enabled
[    0.232960] ACPI: (supports S0 S3 S4 S5)
[    0.233002] ACPI: Using IOAPIC for interrupt routing
[    0.233056] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.233153] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.259276] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.261175] ACPI: No dock devices found.
[    0.261193] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.261552] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.261562] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.262223] PCI host bridge to bus 0000:00
[    0.262235] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.262244] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.262252] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.262261] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.262268] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.262277] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.262286] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.262294] pci_bus 0000:00: root bus resource [mem 0x80000000-0xffffffff]
[    0.262315] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    0.262384] pci 0000:00:01.0: [1002:9802] type 00 class 0x030000
[    0.262404] pci 0000:00:01.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.262419] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.262434] pci 0000:00:01.0: reg 18: [mem 0xfeb00000-0xfeb3ffff]
[    0.262503] pci 0000:00:01.0: supports D1 D2
[    0.262534] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    0.262552] pci 0000:00:01.1: reg 10: [mem 0xfeb44000-0xfeb47fff]
[    0.262633] pci 0000:00:01.1: supports D1 D2
[    0.262671] pci 0000:00:04.0: [1022:1512] type 01 class 0x060400
[    0.262756] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.262813] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
[    0.262843] pci 0000:00:11.0: reg 10: [io  0xf190-0xf197]
[    0.262860] pci 0000:00:11.0: reg 14: [io  0xf180-0xf183]
[    0.262877] pci 0000:00:11.0: reg 18: [io  0xf170-0xf177]
[    0.262895] pci 0000:00:11.0: reg 1c: [io  0xf160-0xf163]
[    0.262912] pci 0000:00:11.0: reg 20: [io  0xf150-0xf15f]
[    0.262929] pci 0000:00:11.0: reg 24: [mem 0xfeb4f000-0xfeb4f3ff]
[    0.262961] pci 0000:00:11.0: set SATA to AHCI mode
[    0.263034] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.263057] pci 0000:00:12.0: reg 10: [mem 0xfeb4e000-0xfeb4efff]
[    0.263156] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.263185] pci 0000:00:12.2: reg 10: [mem 0xfeb4d000-0xfeb4d0ff]
[    0.263292] pci 0000:00:12.2: supports D1 D2
[    0.263299] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.263337] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.263359] pci 0000:00:13.0: reg 10: [mem 0xfeb4c000-0xfeb4cfff]
[    0.263455] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.263485] pci 0000:00:13.2: reg 10: [mem 0xfeb4b000-0xfeb4b0ff]
[    0.263591] pci 0000:00:13.2: supports D1 D2
[    0.263598] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.263635] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.263735] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.263758] pci 0000:00:14.1: reg 10: [io  0xf140-0xf147]
[    0.263776] pci 0000:00:14.1: reg 14: [io  0xf130-0xf133]
[    0.263793] pci 0000:00:14.1: reg 18: [io  0xf120-0xf127]
[    0.263811] pci 0000:00:14.1: reg 1c: [io  0xf110-0xf113]
[    0.263828] pci 0000:00:14.1: reg 20: [io  0xf100-0xf10f]
[    0.263885] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.263917] pci 0000:00:14.2: reg 10: [mem 0xfeb40000-0xfeb43fff 64bit]
[    0.264005] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.264032] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.264139] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.264202] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.264226] pci 0000:00:14.5: reg 10: [mem 0xfeb4a000-0xfeb4afff]
[    0.264324] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.264428] pci 0000:00:15.0: supports D1 D2
[    0.264467] pci 0000:00:15.1: [1002:43a1] type 01 class 0x060400
[    0.264571] pci 0000:00:15.1: supports D1 D2
[    0.264615] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.264638] pci 0000:00:16.0: reg 10: [mem 0xfeb49000-0xfeb49fff]
[    0.264734] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.264776] pci 0000:00:16.2: reg 10: [mem 0xfeb48000-0xfeb480ff]
[    0.264883] pci 0000:00:16.2: supports D1 D2
[    0.264891] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.264931] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    0.264988] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    0.265043] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    0.265099] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    0.265165] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    0.265216] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    0.265267] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    0.265318] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    0.265428] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.265518] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.265536] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.265546] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.265555] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.265565] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.265576] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.265586] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.265596] pci 0000:00:14.4:   bridge window [mem 0x80000000-0xffffffff] (subtractive decode)
[    0.265667] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.265772] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.265800] pci 0000:04:00.0: reg 10: [io  0xe000-0xe0ff]
[    0.265842] pci 0000:04:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.265872] pci 0000:04:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.265975] pci 0000:04:00.0: supports D1 D2
[    0.265982] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.276768] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.276793] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.276819] pci 0000:00:15.1:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.276988] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.277065] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.277151] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.277218]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.277229]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.279701] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11 14 15)
[    0.279833] ACPI: PCI Interrupt Link [LNKB] (IRQs *10 11 14 15)
[    0.279966] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 *11 14 15)
[    0.280090] ACPI: PCI Interrupt Link [LNKD] (IRQs *10 11 14 15)
[    0.280193] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11 14 15) *0
[    0.280278] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11 14 15) *0
[    0.280362] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11 14 15) *0
[    0.280445] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11 14 15) *0
[    0.280710] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.280743] vgaarb: loaded
[    0.280749] vgaarb: bridge control possible 0000:00:01.0
[    0.281164] SCSI subsystem initialized
[    0.281173] ACPI: bus type scsi registered
[    0.281300] libata version 3.00 loaded.
[    0.281347] ACPI: bus type usb registered
[    0.281392] usbcore: registered new interface driver usbfs
[    0.281415] usbcore: registered new interface driver hub
[    0.281481] usbcore: registered new device driver usb
[    0.281731] PCI: Using ACPI for IRQ routing
[    0.291708] PCI: pci_cache_line_size set to 64 bytes
[    0.291840] e820: reserve RAM buffer [mem 0x6ea08000-0x6fffffff]
[    0.291849] e820: reserve RAM buffer [mem 0x6f87d000-0x6fffffff]
[    0.291856] e820: reserve RAM buffer [mem 0x6fc98000-0x6fffffff]
[    0.291863] e820: reserve RAM buffer [mem 0x6ff00000-0x6fffffff]
[    0.292077] NetLabel: Initializing
[    0.292084] NetLabel:  domain hash size = 128
[    0.292089] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.292112] NetLabel:  unlabeled traffic allowed by default
[    0.292245] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.292258] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.294291] Switching to clocksource hpet
[    0.305708] AppArmor: AppArmor Filesystem Enabled
[    0.305784] pnp: PnP ACPI init
[    0.305815] ACPI: bus type pnp registered
[    0.306070] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.306084] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.306658] system 00:01: [io  0x040b] has been reserved
[    0.306668] system 00:01: [io  0x04d6] has been reserved
[    0.306677] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.306685] system 00:01: [io  0x0c14] has been reserved
[    0.306693] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.306702] system 00:01: [io  0x0c52] has been reserved
[    0.306710] system 00:01: [io  0x0c6c] has been reserved
[    0.306717] system 00:01: [io  0x0c6f] has been reserved
[    0.306725] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.306734] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.306742] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.306750] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.306763] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.306771] system 00:01: [io  0x0800-0x089f] has been reserved
[    0.306780] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.306788] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.306796] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.306804] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.306815] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.306824] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.306833] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.306842] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.306852] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.306861] system 00:01: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.306870] system 00:01: [mem 0xffc00000-0xffffffff] has been reserved
[    0.306880] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.307052] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.307063] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.307309] pnp 00:03: Plug and Play ACPI device, IDs NTN0530 (active)
[    0.307339] pnp 00:04: [dma 4]
[    0.307382] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.307439] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.307491] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.307602] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.307613] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.307671] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.307752] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.308224] pnp 00:0a: [dma 0 disabled]
[    0.308327] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.308580] system 00:0b: [mem 0x70000000-0x7fffffff] has been reserved
[    0.308592] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.308874] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.308887] pnp: PnP ACPI: found 13 devices
[    0.308893] ACPI: ACPI bus type pnp unregistered
[    0.317166] pci 0000:00:04.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.317186] pci 0000:00:04.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.317198] pci 0000:00:04.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.317239] pci 0000:00:04.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.317251] pci 0000:00:04.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.317262] pci 0000:00:04.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.317279] pci 0000:00:04.0: BAR 14: assigned [mem 0x80000000-0x801fffff]
[    0.317291] pci 0000:00:04.0: BAR 15: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.317304] pci 0000:00:04.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.317314] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.317324] pci 0000:00:04.0:   bridge window [io  0x1000-0x1fff]
[    0.317336] pci 0000:00:04.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.317347] pci 0000:00:04.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.317361] pci 0000:00:14.4: PCI bridge to [bus 02]
[    0.317380] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.317399] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.317408] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.317422] pci 0000:00:15.1:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.317488] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.317496] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.317504] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.317512] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.317520] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.317528] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.317535] pci_bus 0000:00: resource 10 [mem 0x80000000-0xffffffff]
[    0.317544] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.317551] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
[    0.317559] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.317569] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.317576] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.317583] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.317591] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.317598] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.317607] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.317614] pci_bus 0000:02: resource 10 [mem 0x80000000-0xffffffff]
[    0.317622] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.317631] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.317705] NET: Registered protocol family 2
[    0.317984] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.318162] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.318346] TCP: Hash tables configured (established 16384 bind 16384)
[    0.318457] TCP: reno registered
[    0.318480] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.318517] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.318689] NET: Registered protocol family 1
[    0.318727] pci 0000:00:01.0: Boot video device
[    0.641892] PCI: CLS 64 bytes, default 64
[    0.642014] Trying to unpack rootfs image as initramfs...
[    1.145184] Freeing initrd memory: 15780k freed
[    1.155453] LVT offset 0 assigned for vector 0x400
[    1.155522] perf: AMD IBS detected (0x000000ff)
[    1.155826] Initialise module verification
[    1.155916] audit: initializing netlink socket (disabled)
[    1.155944] type=2000 audit(1368630942.044:1): initialized
[    1.206976] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.210063] VFS: Disk quotas dquot_6.5.2
[    1.210175] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.211219] fuse init (API version 7.20)
[    1.211403] msgmni has been set to 3460
[    1.212237] Key type asymmetric registered
[    1.212252] Asymmetric key parser 'x509' registered
[    1.212332] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.212396] io scheduler noop registered
[    1.212408] io scheduler deadline registered (default)
[    1.212427] io scheduler cfq registered
[    1.212801] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.212837] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.213009] efifb: probing for efifb
[    1.213192] efifb: framebuffer at 0xc0000000, mapped to 0xffffc90011580000, using 1920k, total 1920k
[    1.213201] efifb: mode is 800x600x32, linelength=3200, pages=1
[    1.213207] efifb: scrolling: redraw
[    1.213213] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.216054] Console: switching to colour frame buffer device 100x37
[    1.218782] fb0: EFI VGA frame buffer device
[    1.218962] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.219046] ACPI: Power Button [PWRB]
[    1.219154] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.219226] ACPI: Power Button [PWRF]
[    1.219372] ACPI: acpi_idle registered with cpuidle
[    1.228633] GHES: HEST is not enabled!
[    1.228869] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.249406] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.252181] Linux agpgart interface v0.103
[    1.254891] brd: module loaded
[    1.256360] loop: module loaded
[    1.258666] libphy: Fixed MDIO Bus: probed
[    1.260306] tun: Universal TUN/TAP device driver, 1.6
[    1.261828] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.263434] PPP generic driver version 2.4.2
[    1.265042] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.266567] ehci-pci: EHCI PCI platform driver
[    1.268122] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.269643] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.271180] QUIRK: Enable AMD PLL fix
[    1.272698] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.274313] ehci-pci 0000:00:12.2: debug port 1
[    1.275931] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb4d000
[    1.288794] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.290449] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.292009] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.293591] usb usb1: Product: EHCI Host Controller
[    1.295151] usb usb1: Manufacturer: Linux 3.8.0-19-generic ehci_hcd
[    1.296716] usb usb1: SerialNumber: 0000:00:12.2
[    1.298465] hub 1-0:1.0: USB hub found
[    1.299995] hub 1-0:1.0: 5 ports detected
[    1.301693] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.303185] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.304693] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.306245] ehci-pci 0000:00:13.2: debug port 1
[    1.307775] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb4b000
[    1.320745] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.322306] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.323751] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.325191] usb usb2: Product: EHCI Host Controller
[    1.326591] usb usb2: Manufacturer: Linux 3.8.0-19-generic ehci_hcd
[    1.328009] usb usb2: SerialNumber: 0000:00:13.2
[    1.329628] hub 2-0:1.0: USB hub found
[    1.331026] hub 2-0:1.0: 5 ports detected
[    1.332579] ehci-pci 0000:00:16.2: EHCI Host Controller
[    1.333975] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 3
[    1.335379] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.336836] ehci-pci 0000:00:16.2: debug port 1
[    1.338293] ehci-pci 0000:00:16.2: irq 17, io mem 0xfeb48000
[    1.348705] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.350204] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.351622] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.353044] usb usb3: Product: EHCI Host Controller
[    1.354438] usb usb3: Manufacturer: Linux 3.8.0-19-generic ehci_hcd
[    1.355848] usb usb3: SerialNumber: 0000:00:16.2
[    1.357425] hub 3-0:1.0: USB hub found
[    1.358801] hub 3-0:1.0: 4 ports detected
[    1.360276] ehci-platform: EHCI generic platform driver
[    1.361630] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.363028] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.364389] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[    1.365801] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfeb4e000
[    1.424605] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.425968] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.427330] usb usb4: Product: OHCI Host Controller
[    1.428696] usb usb4: Manufacturer: Linux 3.8.0-19-generic ohci_hcd
[    1.430068] usb usb4: SerialNumber: 0000:00:12.0
[    1.431649] hub 4-0:1.0: USB hub found
[    1.433036] hub 4-0:1.0: 5 ports detected
[    1.434558] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.435914] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.437299] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeb4c000
[    1.496484] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.497876] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.499254] usb usb5: Product: OHCI Host Controller
[    1.500636] usb usb5: Manufacturer: Linux 3.8.0-19-generic ohci_hcd
[    1.502010] usb usb5: SerialNumber: 0000:00:13.0
[    1.503645] hub 5-0:1.0: USB hub found
[    1.505072] hub 5-0:1.0: 5 ports detected
[    1.506636] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.508015] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[    1.509444] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfeb4a000
[    1.568356] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.569743] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.571117] usb usb6: Product: OHCI Host Controller
[    1.572504] usb usb6: Manufacturer: Linux 3.8.0-19-generic ohci_hcd
[    1.573905] usb usb6: SerialNumber: 0000:00:14.5
[    1.575467] hub 6-0:1.0: USB hub found
[    1.576859] hub 6-0:1.0: 2 ports detected
[    1.578324] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    1.579677] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[    1.581075] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfeb49000
[    1.640245] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.641646] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.643046] usb usb7: Product: OHCI Host Controller
[    1.644435] usb usb7: Manufacturer: Linux 3.8.0-19-generic ohci_hcd
[    1.645828] usb usb7: SerialNumber: 0000:00:16.0
[    1.647360] hub 7-0:1.0: USB hub found
[    1.648746] hub 7-0:1.0: 4 ports detected
[    1.650240] uhci_hcd: USB Universal Host Controller Interface driver
[    1.651740] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.655686] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.657126] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.658757] mousedev: PS/2 mouse device common for all mice
[    1.660373] rtc_cmos 00:05: RTC can wake from S4
[    1.661901] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.663305] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.664893] device-mapper: uevent: version 1.0.3
[    1.666410] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    1.667903] cpuidle: using governor ladder
[    1.669397] cpuidle: using governor menu
[    1.670797] ledtrig-cpu: registered to indicate activity on CPUs
[    1.672205] EFI Variables Facility v0.08 2004-May-17
[    1.680259] ashmem: initialized
[    1.681893] TCP: cubic registered
[    1.683484] NET: Registered protocol family 10
[    1.685209] NET: Registered protocol family 17
[    1.686588] Key type dns_resolver registered
[    1.688397] Loading module verification certificates
[    1.692081] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 4fb521df0b0fa81f775431361b8076d5d0f1869a'
[    1.694871] registered taskstats version 1
[    1.701251] Key type trusted registered
[    1.707021] Key type encrypted registered
[    1.713417] rtc_cmos 00:05: setting system clock to 2013-05-15 15:15:42 UTC (1368630942)
[    1.714993] powernow-k8: this CPU is not supported anymore, using acpi-cpufreq instead.
[    1.718811] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.720506] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.721986] EDD information not available.
[    1.726243] Freeing unused kernel memory: 992k freed
[    1.728363] Write protecting the kernel read-only data: 12288k
[    1.736840] Freeing unused kernel memory: 1176k freed
[    1.745086] Freeing unused kernel memory: 1080k freed
[    1.776279] udevd[95]: starting version 175
[    1.861922] Disabling lock debugging due to kernel taint
[    1.886084] ahci 0000:00:11.0: version 3.0
[    1.887757] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    1.889342] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[    1.892167] scsi0 : ahci
[    1.898947] scsi1 : ahci
[    1.903482] scsi2 : ahci
[    1.906070] scsi3 : ahci
[    1.907607] ata1: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f100 irq 19
[    1.909081] ata2: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f180 irq 19
[    1.910476] ata3: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f200 irq 19
[    1.911830] ata4: SATA max UDMA/133 abar m1024@0xfeb4f000 port 0xfeb4f280 irq 19
[    1.934892] pata_atiixp 0000:00:14.1: enabling device (0000 -> 0001)
[    1.956405] scsi4 : pata_atiixp
[    1.959522] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.960961] r8169 0000:04:00.0: enabling device (0000 -> 0003)
[    1.962543] r8169 0000:04:00.0: irq 40 for MSI/MSI-X
[    1.963941] scsi5 : pata_atiixp
[    1.965927] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf100 irq 14
[    1.967339] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf108 irq 15
[    1.969119] r8169 0000:04:00.0 eth0: RTL8168e/8111e at 0xffffc90000032000, bc:5f:f4:9b:b0:bf, XID 0c200000 IRQ 40
[    1.971881] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.151448] tsc: Refined TSC clocksource calibration: 1599.999 MHz
[    2.153008] Switching to clocksource tsc
[    2.187392] usb 5-4: new low-speed USB device number 2 using ohci_hcd
[    2.231351] ata1: SATA link down (SStatus 0 SControl 300)
[    2.232902] ata3: SATA link down (SStatus 0 SControl 300)
[    2.243341] ata4: SATA link down (SStatus 0 SControl 300)
[    2.368150] usb 5-4: New USB device found, idVendor=1d57, idProduct=ac01
[    2.369617] usb 5-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.370996] usb 5-4: Manufacturer: Mouse
[    2.403098] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.403749] usbcore: registered new interface driver usbhid
[    2.403752] usbhid: USB HID core driver
[    2.409127] ata2.00: ATA-8: ST9500325AS, 0001SDM1, max UDMA/133
[    2.410588] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.415772] input: Mouse as /devices/pci0000:00/0000:00:13.0/usb5/5-4/5-4:1.0/input/input2
[    2.417672] hid-generic 0003:1D57:AC01.0001: input,hidraw0: USB HID v1.10 Keyboard [Mouse] on usb-0000:00:13.0-4/input0
[    2.418176] ata2.00: configured for UDMA/133
[    2.420303] scsi 1:0:0:0: Direct-Access     ATA      ST9500325AS      0001 PQ: 0 ANSI: 5
[    2.420637] sd 1:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.420740] sd 1:0:0:0: [sda] Write Protect is off
[    2.420743] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.420786] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.421601] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.434008] input: Mouse as /devices/pci0000:00/0000:00:13.0/usb5/5-4/5-4:1.1/input/input3
[    2.438928] hid-generic 0003:1D57:AC01.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [Mouse] on usb-0000:00:13.0-4/input1
[    2.476705]  sda: sda1 sda2 sda3
[    2.479229] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.506907] usb 4-1: new low-speed USB device number 2 using ohci_hcd
[    2.676681] usb 4-1: New USB device found, idVendor=045e, idProduct=0752
[    2.678555] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.680368] usb 4-1: Product: Wired Keyboard 400
[    2.682113] usb 4-1: Manufacturer: Microsoft
[    2.691222] input: Microsoft Wired Keyboard 400 as /devices/pci0000:00/0000:00:12.0/usb4/4-1/4-1:1.0/input/input4
[    2.694896] hid-generic 0003:045E:0752.0003: input,hidraw2: USB HID v1.11 Keyboard [Microsoft Wired Keyboard 400] on usb-0000:00:12.0-1/input0
[    2.962192] usb 4-2: new low-speed USB device number 3 using ohci_hcd
[    3.055874] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    3.057746] EXT4-fs (sda2): write access will be enabled during recovery
[    3.126972] usb 4-2: New USB device found, idVendor=192f, idProduct=0416
[    3.128920] usb 4-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    3.130786] usb 4-2: Product: USB Optical Mouse
[    3.139481] input: USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb4/4-2/4-2:1.0/input/input5
[    3.143599] hid-generic 0003:192F:0416.0004: input,hidraw3: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:12.0-2/input0
[    5.249790] EXT4-fs (sda2): recovery complete
[    5.264191] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   11.834422] Adding 1815548k swap on /dev/sda3.  Priority:-1 extents:1 across:1815548k 
[   11.895260] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.987879] udevd[350]: starting version 175
[   12.184486] lp: driver loaded but no devices found
[   12.199606] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   12.205412] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   12.223636] sp5100_tco: PCI Revision ID: 0x42
[   12.227504] sp5100_tco: Using 0xfed80b00 for watchdog MMIO address
[   12.229539] sp5100_tco: Last reboot was not triggered by watchdog.
[   12.248148] sp5100_tco: initialized (0xffffc90000034b00). heartbeat=60 sec (nowayout=0)
[   12.357152] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[   12.379893] acpi device:1a: registered as cooling_device2
[   12.381873] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   12.387691] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[   12.568795] Registered IR keymap rc-rc6-mce
[   12.569390] input: Nuvoton w836x7hg Infrared Remote Transceiver as /devices/pnp0/00:03/rc/rc0/input7
[   12.569631] rc0: Nuvoton w836x7hg Infrared Remote Transceiver as /devices/pnp0/00:03/rc/rc0
[   12.575186] nuvoton_cir: driver has been successfully loaded
[   12.585998] IR NEC protocol handler initialized
[   12.590132] snd_hda_intel 0000:00:01.1: irq 41 for MSI/MSI-X
[   12.602610] IR RC5(x) protocol handler initialized
[   12.619496] IR RC6 protocol handler initialized
[   12.627941] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input8
[   12.628723] snd_hda_intel 0000:00:14.2: enabling device (0000 -> 0002)
[   12.632384] IR JVC protocol handler initialized
[   12.666030] IR Sony protocol handler initialized
[   12.695915] IR SANYO protocol handler initialized
[   12.716496] input: MCE IR Keyboard/Mouse (nuvoton-cir) as /devices/virtual/input/input9
[   12.719926] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card1/input10
[   12.721748] IR MCE Keyboard/mouse protocol handler initialized
[   12.724715] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card1/input11
[   12.725090] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card1/input12
[   12.725394] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card1/input13
[   12.727919] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card1/input14
[   12.744387] lirc_dev: IR Remote Control driver registered, major 250 
[   12.752239] rc rc0: lirc_dev: driver ir-lirc-codec (nuvoton-cir) registered at minor = 0
[   12.752336] IR LIRC bridge handler initialized
[   12.837750] microcode: CPU0: patch_level=0x0500010d
[   12.924959] microcode: CPU1: patch_level=0x0500010d
[   12.925212] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   13.065752] kvm: Nested Virtualization enabled
[   13.065821] kvm: Nested Paging enabled
[   13.420039] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[   13.882348] type=1400 audit(1368630954.684:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=471 comm="apparmor_parser"
[   13.886872] type=1400 audit(1368630954.688:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=471 comm="apparmor_parser"
[   13.891088] type=1400 audit(1368630954.692:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=471 comm="apparmor_parser"
[   14.386481] type=1400 audit(1368630955.188:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=644 comm="apparmor_parser"
[   14.391377] type=1400 audit(1368630955.196:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=644 comm="apparmor_parser"
[   14.396017] type=1400 audit(1368630955.200:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=644 comm="apparmor_parser"
[   14.621506] init: failsafe main process (786) killed by TERM signal
[   14.692770] Bluetooth: Core ver 2.16
[   14.694764] NET: Registered protocol family 31
[   14.696665] Bluetooth: HCI device and connection manager initialized
[   14.699467] Bluetooth: HCI socket layer initialized
[   14.699473] Bluetooth: L2CAP socket layer initialized
[   14.699487] Bluetooth: SCO socket layer initialized
[   14.707748] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.709709] Bluetooth: BNEP filters: protocol multicast
[   14.711606] Bluetooth: BNEP socket layer initialized
[   14.717527] Bluetooth: RFCOMM TTY layer initialized
[   14.719411] Bluetooth: RFCOMM socket layer initialized
[   14.721254] Bluetooth: RFCOMM ver 1.11
[   14.773353] ppdev: user-space parallel port driver
[   14.933218] init: avahi-cups-reload main process (840) terminated with status 1
[   15.642030] r8169 0000:04:00.0 eth0: link down
[   15.643907] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.646246] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.196409] type=1400 audit(1368630957.000:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper" pid=905 comm="apparmor_parser"
[   16.201998] type=1400 audit(1368630957.008:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper//chromium_browser" pid=905 comm="apparmor_parser"
[   16.732834] type=1400 audit(1368630957.540:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=904 comm="apparmor_parser"
[   16.736893] type=1400 audit(1368630957.544:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper//chromium_browser" pid=904 comm="apparmor_parser"
[   17.961143] r8169 0000:04:00.0 eth0: link up
[   17.963063] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.765957] init: lightdm main process (1010) terminated with status 1
[   20.781883] init: plymouth-ready (started) main process (454) terminated with status 1

--------------090000060300000404030807--
