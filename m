Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3A2Dov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:44:51 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36372 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3A2Dos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:44:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOONhdcDG65MF9jaiM0Pi4RsXq1MaLtRfhqR7831K6QgC-w@mail.gmail.com>
References: <20130109132409.GB18395@phenom.dumpdata.com>
	<CAE9FiQUznCR6i56AW6jhiCCK-pQxnAquzxUoWWQamoSC8YAZKA@mail.gmail.com>
	<87d2xeul5v.fsf@xmission.com>
	<CAE9FiQX-OxTzt3BPh3nSLQxDUBGR=eKob5AqXYzy=Lw9NYTaGw@mail.gmail.com>
	<CAE9FiQVsbDfLOyv=D4_BLtrKpp+Ydj7pren8Cu3rNGztbj=w=w@mail.gmail.com>
	<20130111163548.GB25620@phenom.dumpdata.com>
	<CAE9FiQVts6aTaRFM3aKWj46RCRiheM5gS55h=LVveaGXk_kR8g@mail.gmail.com>
	<CAE9FiQVTfTisOrrQhv0vmsgA8Asaj5EUE5s93OFyTHfA+dWdfQ@mail.gmail.com>
	<CAE9FiQWU6mnWxnzDtaR51H7GTbYmKgb0zy6xRCGYO4+oyc82Gg@mail.gmail.com>
	<20130118155535.GJ9973@phenom.dumpdata.com>
	<20130124153924.GA5943@konrad-lan.dumpdata.com>
	<CAKocOONcM4HK1ZtUJb7C1xVCEWcz_pG2UZ0hzxGpxSmBSYa1Ww@mail.gmail.com>
	<CAKocOOPvK5S92ESU12yN5U=8fjSDFtDMrjJAmqxkqqTrzFzVCA@mail.gmail.com>
	<CAE9FiQVvO+mgZxKmA4aGS0ujngux97kK7F0JkA4oYVhVEi_bGw@mail.gmail.com>
	<CAKocOONhdcDG65MF9jaiM0Pi4RsXq1MaLtRfhqR7831K6QgC-w@mail.gmail.com>
Date: Mon, 28 Jan 2013 19:44:47 -0800
X-Google-Sender-Auth: 2BmK4rfenTpepVSN7A3g-0jQMZA
Message-ID: <CAE9FiQWYHDYmNYO=Jx3e+m1+rq1vRHuOWPvOO8At2LL=Qsj6KA@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 6:27 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, Jan 24, 2013 at 2:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Your for-x86-boot git boots on AMD system I have. However, with
> memmap=4095$1M option, it panics very early in boot. I don't have
> physical access to the console and I will try to get you the panic
> information tomorrow.

panic is good, but it is supposed some kind of late..

I tested on kvm and it panic late as expected:

early console in setup code
Probing EDD (edd=off to disable)... ok
early console in decompress_kernel
decompress_kernel:
  input: [0x2c042c2-0x3555455], output: 0x1000000, heap: [0x355cc40-0x3564c3f]

Decompressing Linux... xz... Parsing ELF... done.
Booting the kernel.
[    0.000000] bootconsole [uart0] enabled
[    0.000000]    real_mode_data :      phys 0000000000014480
[    0.000000]    real_mode_data :      virt ffff880000014480
[    0.000000]       boot_params : init virt ffffffff831489c0
[    0.000000]       boot_params :      phys 00000000031489c0
[    0.000000]       boot_params :      virt ffff8800031489c0
[    0.000000] boot_command_line : init virt ffffffff83036020
[    0.000000] boot_command_line :      phys 0000000003036020
[    0.000000] boot_command_line :      virt ffff880003036020
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x021825b9]
[    0.000000] .rodata: [0x02200000-0x02a24fff]
[    0.000000]   .data: [0x02c00000-0x02dcc8bf]
[    0.000000]   .init: [0x02dce000-0x03133fff]
[    0.000000]    .bss: [0x03142000-0x03ddffff]
[    0.000000]    .brk: [0x03de0000-0x03e04fff]
[    0.000000] memblock_reserve: [0x0009fc00-0x000fffff] * BIOS reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc5-yh-01253-gdf8eac2-dirty
(yhlu@linux-siqj.site) (gcc version 4.7.1 20120723 [gcc-4_7-branch
revision 189773] (SUSE Linux) ) #1194 SMP Mon Jan 28 19:36:41 PST 2013
[    0.000000] memblock_reserve: [0x01000000-0x03ddffff] TEXT DATA BSS
[    0.000000] memblock_reserve: [0x7d9ac000-0x7fffefff] RAMDISK
[    0.000000] Command line: BOOT_IMAGE=linux debug ignore_loglevel
memmap=4095M$1M pci=routeirq ramdisk_size=262144 root=/dev/ram0 rw
ip=dhcp console=uart8250,io,0x3f8,115200 initrd=initrd.img
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] Physical RAM map:
[    0.000000] raw: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] raw: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] raw: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] raw: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] raw: [mem 0x00000000dfffe000-0x00000000dfffffff] reserved
[    0.000000] raw: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] raw: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] raw: [mem 0x0000000100000000-0x000000019fffffff] usable
[    0.000000] e820: BIOS-provided physical RAM map (sanitized by setup):
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000019fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] user: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000f0000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x000000019fffffff] usable
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] .text .data .bss are not marked as E820_RAM!
[    0.000000] e820: remove [mem 0x01000000-0x03e04fff]
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1a0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820: last_pfn = 0x3e05 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fda20-0x000fda2f]
mapped at [ffff8800000fda20]
[    0.000000] memblock_reserve: [0x000fda20-0x000fda2f] * MP-table mpf
[    0.000000] memblock_reserve: [0x000fda30-0x000fdb23] * MP-table mpc
[    0.000000] memblock_reserve: [0x03de0000-0x03de5fff] BRK
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0xa2e94c00 reserved size = 0x5499400
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]	[0x00010000-0x0009efff], 0x8f000 bytes
[    0.000000]  memory[0x1]	[0x01000000-0x03e04fff], 0x2e05000 bytes
[    0.000000]  memory[0x2]	[0x100000000-0x19fffffff], 0xa0000000 bytes
[    0.000000]  reserved.cnt  = 0x3
[    0.000000]  reserved[0x0]	[0x0009fc00-0x000fffff], 0x60400 bytes
[    0.000000]  reserved[0x1]	[0x01000000-0x03de5fff], 0x2de6000 bytes
[    0.000000]  reserved[0x2]	[0x7d9ac000-0x7fffefff], 0x2653000 bytes
[    0.000000] memblock_reserve: [0x00099000-0x0009efff] TRAMPOLINE
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03de1000, 0x03de1fff] PGTABLE
[    0.000000] BRK [0x03de2000, 0x03de2fff] PGTABLE
[    0.000000] BRK [0x03de3000, 0x03de3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x19fe00000-0x19fffffff]
[    0.000000]  [mem 0x19fe00000-0x19fffffff] page 2M
[    0.000000] BRK [0x03de4000, 0x03de4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x19c000000-0x19fdfffff]
[    0.000000]  [mem 0x19c000000-0x19fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x180000000-0x19bffffff]
[    0.000000]  [mem 0x180000000-0x19bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x01000000-0x03e04fff]
[    0.000000]  [mem 0x01000000-0x03dfffff] page 2M
[    0.000000]  [mem 0x03e00000-0x03e04fff] page 4k
[    0.000000] memblock_reserve: [0x19ffff000-0x19fffffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
[    0.000000] BRK [0x03de5000, 0x03de5fff] PGTABLE
[    0.000000] memblock_reserve: [0x19fffe000-0x19fffefff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7d9ac000-0x7fffefff]
[    0.000000] memblock_reserve: [0x19d9ab000-0x19fffdfff] NEW RAMDISK
[    0.000000] Allocated new RAMDISK: [mem 0x19d9ab000-0x19fffd667]
[    0.000000] Move RAMDISK from [mem 0x7d9ac000-0x7fffe667] to [mem
0x19d9ab000-0x19fffd667]
[    0.000000]    memblock_free: [0x7d9ac000-0x7fffefff]ACPI: RSDP
00000000000fd870 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe3d0 00038 (v01 BOCHS  BXPCRSDT
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 00074 (v01 BOCHS  BXPCFACP
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe410 0124A (v01   BXPC   BXDSDT
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 00040
[    0.000000] ACPI: SSDT 00000000dffffe30 00110 (v01 BOCHS  BXPCSSDT
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffffd10 00080 (v01 BOCHS  BXPCAPIC
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffffcd0 00038 (v01 BOCHS  BXPCHPET
00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 00000000dffff660 0066E (v01   BXPC BXSSDTPC
00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000019fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x19fffffff]
[    0.000000] memblock_reserve: [0x19d984000-0x19d9aafff]
[    0.000000]   NODE_DATA [mem 0x19d984000-0x19d9aafff]
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0xa2e94c00 reserved size = 0x54c8400
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]	[0x00010000-0x0009efff], 0x8f000 bytes on node 0
[    0.000000]  memory[0x1]	[0x01000000-0x03e04fff], 0x2e05000 bytes on node 0
[    0.000000]  memory[0x2]	[0x100000000-0x19fffffff], 0xa0000000
bytes on node 0
[    0.000000]  reserved.cnt  = 0x4
[    0.000000]  reserved[0x0]	[0x00099000-0x0009efff], 0x6000 bytes
[    0.000000]  reserved[0x1]	[0x0009fc00-0x000fffff], 0x60400 bytes
[    0.000000]  reserved[0x2]	[0x01000000-0x03de5fff], 0x2de6000 bytes
[    0.000000]  reserved[0x3]	[0x19d984000-0x19fffffff], 0x267c000 bytes
[    0.000000] memblock_reserve: [0x19d983000-0x19d983fff] sparse section
[    0.000000] memblock_reserve: [0x19d583000-0x19d982fff] usemap_map
[    0.000000] memblock_reserve: [0x19d582d40-0x19d582fdf] usemap section
[    0.000000] memblock_reserve: [0x19d182d40-0x19d582d3f] map_map
[    0.000000] memblock_reserve: [0x19a600000-0x19cffffff] vmemmap buf
[    0.000000] memblock_reserve: [0x19d181000-0x19d181fff] vmemmap block
[    0.000000]  [ffffea0000000000-ffffea7fffffffff] PGD @
ffff88019d181000 on node 0
[    0.000000] memblock_reserve: [0x19d180000-0x19d180fff] vmemmap block
[    0.000000]  [ffffea0000000000-ffffea003fffffff] PUD @
ffff88019d180000 on node 0
[    0.000000]    memblock_free: [0x19d000000-0x19cffffff]
[    0.000000]  [ffffea0000000000-ffffea00067fffff] PMD ->
[ffff88019a600000-ffff88019cffffff] on node 0
[    0.000000]    memblock_free: [0x19d182d40-0x19d582d3f]
[    0.000000]    memblock_free: [0x19d583000-0x19d982fff]Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x19fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x01000000-0x03e04fff]
[    0.000000]   node   0: [mem 0x100000000-0x19fffffff]
[    0.000000] start - node_states[2]:
[    0.000000] On node 0 totalpages: 667284
[    0.000000]   DMA zone: 3 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 134 pages, LIFO batch:0
[    0.000000] memblock_reserve: [0x19d92b000-0x19d982fff] pgdat
[    0.000000]   DMA32 zone: 185 pages used for memmap
[    0.000000]   DMA32 zone: 11596 pages, LIFO batch:1
[    0.000000] memblock_reserve: [0x19d8d3000-0x19d92afff] pgdat
[    0.000000]   Normal zone: 10240 pages used for memmap
[    0.000000]   Normal zone: 645120 pages, LIFO batch:31
[    0.000000] memblock_reserve: [0x19d87b000-0x19d8d2fff] pgdat
[    0.000000] after - node_states[2]: 0
[    0.000000] memblock_reserve: [0x19d87a000-0x19d87afff] pgtable
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] memblock_reserve: [0x19d879f80-0x19d879fc0] hpet res
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] init_cpu_to_node:
[    0.000000] cpu 0 -> apicid 0x0 -> node 0
[    0.000000] cpu 1 -> apicid 0x1 -> node 0
[    0.000000] memblock_reserve: [0x19d879f00-0x19d879f42] ioapic res
[    0.000000] nr_irqs_gsi: 40
[    0.000000] memblock_reserve: [0x19d879d40-0x19d879ec7] e820 resources
[    0.000000] memblock_reserve: [0x19d879cc0-0x19d879d27] firmware map
[    0.000000] memblock_reserve: [0x19d879c40-0x19d879ca7] firmware map
[    0.000000] memblock_reserve: [0x19d879bc0-0x19d879c27] firmware map
[    0.000000] memblock_reserve: [0x19d879b40-0x19d879ba7] firmware map
[    0.000000] memblock_reserve: [0x19d879ac0-0x19d879b27] firmware map
[    0.000000] memblock_reserve: [0x19d879a40-0x19d879aa7] firmware map
[    0.000000] memblock_reserve: [0x19d8799c0-0x19d879a27] firmware map
[    0.000000] memblock_reserve: [0x19d879940-0x19d8799a7] firmware map
[    0.000000] memblock_reserve: [0x19d879900-0x19d87991f] nosave region
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000001000000
[    0.000000] memblock_reserve: [0x19d8798c0-0x19d8798df] nosave region
[    0.000000] PM: Registered nosave memory: 0000000003e05000 - 0000000100000000
[    0.000000] e820: cannot find a gap in the 32bit address range
[    0.000000] e820: PCI devices with unassigned 32bit BARs may break!
[    0.000000] e820: [mem 0x1a0100000-0x1a04fffff] available for PCI devices
[    0.000000] memblock_reserve: [0x19d879800-0x19d8798a4] saved_command_l
[    0.000000] memblock_reserve: [0x19d879740-0x19d8797e4] static_command_
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] memblock_reserve: [0x19d878740-0x19d87973f] pcpu_alloc_info
[    0.000000] memblock_reserve: [0x19d877740-0x19d87873f] pcpu area
[    0.000000] memblock_reserve: [0x19a200000-0x19a5fffff] pcpu_alloc
[    0.000000]    memblock_free: [0x19a3dc000-0x19a3fffff]
[    0.000000]    memblock_free: [0x19a5dc000-0x19a5fffff][
0.000000] PERCPU: Embedded 476 pages/cpu @ffff88019a200000 s1917968
r8192 d23536 u2097152
[    0.000000] memblock_reserve: [0x19d877700-0x19d877707] pcpu group_offs
[    0.000000] memblock_reserve: [0x19d8776c0-0x19d8776c7] pcpu group_size
[    0.000000] memblock_reserve: [0x19d877680-0x19d877687] pcpu unit_map
[    0.000000] memblock_reserve: [0x19d877640-0x19d87764f] pcpu unit_off
[    0.000000] pcpu-alloc: s1917968 r8192 d23536 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] memblock_reserve: [0x19d8774c0-0x19d87760f] pcpu slot
[    0.000000] memblock_reserve: [0x19d877440-0x19d8774bf] pcpu chunk_stru
[    0.000000] memblock_reserve: [0x19d8773c0-0x19d87743f] pcpu chunk_stru
[    0.000000]    memblock_free: [0x19d878740-0x19d87973f]
[    0.000000]    memblock_free: [0x19d877740-0x19d87873f][
0.000000] memblock_reserve: [0x19d879540-0x19d87973f] node_to_cpumask
[    0.000000] memblock_reserve: [0x19d879340-0x19d87953f] cpu_initialized
[    0.000000] memblock_reserve: [0x19d879140-0x19d87933f] cpu_callin_mask
[    0.000000] memblock_reserve: [0x19d878f40-0x19d87913f] cpu_callout_mas
[    0.000000] memblock_reserve: [0x19d878d40-0x19d878f3f] cpu_calibrated_
[    0.000000] memblock_reserve: [0x19d878b40-0x19d878d3f] cpu_sibling_set
[    0.000000] build_zonelists: local_node: 0 next_best_node: 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 656850
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=linux debug
ignore_loglevel memmap=4095M$1M pci=routeirq ramdisk_size=262144
root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200
initrd=initrd.img
[    0.000000] memblock_reserve: [0x19d86f3c0-0x19d8773bf] large system ha
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] pci_iommu_alloc:
__iommu_entry_pci_swiotlb_detect_4gb+0x0/0x28 ffffffff8312de48
[    0.000000] pci_iommu_alloc:
__iommu_entry_pci_swiotlb_detect_override+0x0/0x28 ffffffff8312de70
[    0.000000] Cannot allocate SWIOTLB buffer
[    0.000000] pci_iommu_alloc:
__iommu_entry_gart_iommu_hole_init+0x0/0x28 ffffffff8312de98
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] pci_iommu_alloc:
__iommu_entry_amd_iommu_detect+0x0/0x28 ffffffff8312dec0
[    0.000000] pci_iommu_alloc:
__iommu_entry_detect_intel_iommu+0x0/0x28 ffffffff8312dee8
[    0.000000]        [0x00010000-0x00098fff]
[    0.000000]        [0x03de6000-0x03e04fff]
[    0.000000]        [0x100000000-0x19a1fffff]
[    0.000000]        [0x19a3dc000-0x19a3fffff]
[    0.000000]        [0x19a5dc000-0x19a5fffff]
[    0.000000]        [0x19d000000-0x19d17ffff]
[    0.000000]        [0x19d182000-0x19d581fff]
[    0.000000]        [0x19d583000-0x19d86efff]
[    0.000000]        [0x19d878000-0x19d877fff]
[    0.000000]        [0x19d87a000-0x19d879fff]
[    0.000000] Memory: 2534768k/6815744k available (17929k kernel
code, 4146608k absent, 134368k reserved, 12584k data, 3480k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:847872 nr_irqs:40 0
[    0.000000] IOAPIC[0]: apic_id 0, GSI 0-23 ==> irq 0-23 reserved
[    0.000000] IOAPIC[extra]: GSI 24-39 ==> irq 24-39 reserved
[    0.000000]   alloc irq_desc for 0 on node 0
[    0.000000]   alloc irq_desc for 1 on node 0
[    0.000000]   alloc irq_desc for 2 on node 0
[    0.000000]   alloc irq_desc for 3 on node 0
[    0.000000]   alloc irq_desc for 4 on node 0
[    0.000000]   alloc irq_desc for 5 on node 0
[    0.000000]   alloc irq_desc for 6 on node 0
[    0.000000]   alloc irq_desc for 7 on node 0
[    0.000000]   alloc irq_desc for 8 on node 0
[    0.000000]   alloc irq_desc for 9 on node 0
[    0.000000]   alloc irq_desc for 10 on node 0
[    0.000000]   alloc irq_desc for 11 on node 0
[    0.000000]   alloc irq_desc for 12 on node 0
[    0.000000]   alloc irq_desc for 13 on node 0
[    0.000000]   alloc irq_desc for 14 on node 0
[    0.000000]   alloc irq_desc for 15 on node 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 11010048 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2492.129 MHz processor
[    0.004005] CPU0: Calibrating delay loop (skipped), value
calculated using timer frequency.. 4984.25 BogoMIPS (lpj=9968516)
[    0.008012] pid_max: default: 32768 minimum: 301
[    0.009727] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.012845] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.014741] Mount-cache hash table entries: 256
[    0.016693] Initializing cgroup subsys cpuacct
[    0.017788] Initializing cgroup subsys memory
[    0.018896] Initializing cgroup subsys devices
[    0.020007] Initializing cgroup subsys freezer
[    0.021101] Initializing cgroup subsys blkio
[    0.022218] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.023387] CPU: L2 cache: 4096K
[    0.024011] CPU 0/0x0 -> Node 0
[    0.024786] CPU 0 microcode level: 0x1
[    0.025708] mce: CPU supports 10 MCE banks
[    0.026729] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026729] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026729] tlb_flushall_shift: 6
[    0.028191] Freeing SMP alternatives: 52k freed
[    0.029312] ACPI: Core revision 20130117
[    0.034050] ACPI: All ACPI Tables successfully acquired
[    0.035310] ftrace: allocating 54533 entries in 214 pages
[    0.053148] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.097443] smpboot: CPU0: Intel QEMU Virtual CPU version 1.2.50
(fam: 06, model: 02, stepping: 03)
[    0.100000] Performance Events: unsupported p6 CPU model 2 no PMU
driver, software events only.
[    0.100000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.100292] SMP alternatives: lockdep: fixing up alternatives
[    0.101559] smpboot: Booting processor 1 APIC 0x1 ip 0x9a000
[    0.008000] Initializing CPU#1
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 4096K
[    0.008000] CPU 1/0x1 -> Node 0
[    0.120006] smpboot: CPU1: Intel QEMU Virtual CPU version 1.2.50
(fam: 06, model: 02, stepping: 03)
[    0.122979] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.128133] Brought up 2 CPUs
[    0.132000] CPU1: Calibrating delay using timer specific routine..
4984.64 BogoMIPS (lpj=9969291)
[    0.209504] smpboot: Total of 2 processors activated (9968.90 BogoMIPS)
[    0.210312] setup_ioapic_desc() done
[    0.210868] mtrr_aps_init() done
[    0.211301] build_sched_domain done
[    0.211706] register_sched_domain_sysctl done
[    0.212024] non_isolated_cpus inited
[    0.212490] hotcpu_notifier to cpuset_cpu done
[    0.212950] hotcpu_notifier to update_runtime done
[    0.213433] init_hrtick done
[    0.213767] sched_init_granularity done
[    0.214203] init_sched_rt_class done
[    0.214635] cpuset_init_smp done
[    0.214635] usermodehelper_init done
[    0.214635] shmem_init done
[    0.216004] devtmpfs_init done
[    0.216391] devices_init done
[    0.216721] buses_init done
[    0.217010] classes_init done
[    0.217348] firmware_init done
[    0.217709] hypervisor_init done
[    0.218214] platform_bus_init done
[    0.218703] cpu_dev_init done
[    0.220520] memory_dev_init done
[    0.220872] driver_init done
[    0.221413] init_irq_proc done
[    0.221759] do_ctors done
[    0.222056] usermodehelper_enable done
[    0.222633] xor: automatically using best checksumming function:
[    0.264005]    generic_sse: 12602.000 MB/sec
[    0.264464] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.265477] NET: Registered protocol family 16
[    0.268117] i2c-core: driver [dummy] registered
[    0.268655] ACPI: bus type pci registered
[    0.269121] dca service started, version 1.12.1
[    0.269121] PCI: Using configuration type 1 for base access
[    0.380160] bio: create slab <bio-0> at 0
[    0.448005] raid6: sse2x1    8363 MB/s
[    0.516010] raid6: sse2x2   10289 MB/s
[    0.584008] raid6: sse2x4   11245 MB/s
[    0.584435] raid6: using algorithm sse2x4 (11245 MB/s)
[    0.584927] raid6: using intx1 recovery algorithm
[    0.585598] init_acpi_device_notify done
[    0.585598] ACPI: Added _OSI(Module Device)
[    0.585598] ACPI: Added _OSI(Processor Device)
[    0.585598] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.585928] ACPI: Added _OSI(Processor Aggregator Device)
[    0.588016] acpi_os_initialize1 done
[    0.590308] acpi_enable_subsystem done
[    0.590692] ACPI: EC: Look up EC in DSDT
[    0.591317] acpi_ec_ecdt_probe done
[    0.595277] acpi_initialize_objects done
[    0.595815] acpi_bus_osc_support done
[    0.596036] acpi_sysfs_init done
[    0.596851] acpi_early_processor_set_pdc done
[    0.597277] acpi_boot_ec_enable done
[    0.597658] ACPI: Interpreter enabled
[    0.598063] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While
evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.599245] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20130117/hwxface-568)
[    0.600270]  S3 S4 S5)
[    0.600629] acpi_sleep_init done
[    0.600952] ACPI: Using IOAPIC for interrupt routing
[    0.601491] acpi_bus_init_irq done
[    0.601826] acpi_install_notify_handler done
[    0.602357] acpi_root_dir created
[    0.602691] acpi_bus_init done
[    0.602972] pci_mmcfg_late_init done
[    0.603521] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.604016] acpi_pci_root_init done
[    0.604436] acpi_pci_link_init done
[    0.604784] acpi_platform_init done
[    0.605106] acpi_csrt_init done
[    0.620326] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.620887] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.621931] acpi PNP0A03:00: ACPI _OSC support notification failed,
disabling PCIe ASPM
[    0.624111] acpi PNP0A03:00: Unable to request _OSC control (_OSC
support mask: 0x08)
[    0.625123] acpi PNP0A03:00: fail to add MMCONFIG information,
can't access extended PCI configuration space under this bridge.
[    0.626402] PCI host bridge to bus 0000:00
[    0.628007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.628622] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.629310] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.629947] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.630609] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.631274] pci_bus 0000:00: scanning bus
[    0.632108] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.632725] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    0.633971] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.633971] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.637841] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.639480] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.640065] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x50
[    0.641029] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x130
[    0.642466] pci 0000:00:01.3: PIO at [io  0xb000-0xb03f]
[    0.642998] pci 0000:00:01.3: addon resource PIIX4 ACPI [io
0xb000-0xb03f] added
[    0.644026] pci 0000:00:01.3: PIO at [io  0xb100-0xb10f]
[    0.644525] pci 0000:00:01.3: addon resource PIIX4 SMB [io
0xb100-0xb10f] added
[    0.645225] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x20
[    0.647143] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.648962] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.650404] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.655651] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.656246] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.658215] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.660679] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.666322] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.668599] pci_bus 0000:00: fixups for bus
[    0.669563] pci_bus 0000:00: bus scan returning with max=00
[    0.670847] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.672084]   acpi_pci_ioapic_add is called for \_SB_.PCI0 ffff8801988c91e0
[    0.674128]   acpi_pci_iommu_add is called for \_SB_.PCI0 ffff8801988c91e0
[    0.677276] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.678311] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.679181] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.680397] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.681223] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.682194] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.682194] acpi root: \_SB_.PCI0 notify handler is installed
[    0.682194] Found 1 acpi root devices
[    0.684015] acpi_scan_init done
[    0.684399] acpi_ec_init done
[    0.684399] acpi_debugfs_init done
[    0.684755] acpi_sleep_proc_init done
[    0.685139] acpi_wakeup_device_init done
[    0.686506] ACPI: No dock devices found.
[    0.688145] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.688969] vgaarb: loaded
[    0.689237] vgaarb: bridge control possible 0000:00:02.0
[    0.689831] SCSI subsystem initialized
[    0.689831] ACPI: bus type scsi registered
[    0.692101] libata version 3.00 loaded.
[    0.692677] ACPI: bus type usb registered
[    0.692677] usbcore: registered new interface driver usbfs
[    0.692782] usbcore: registered new interface driver hub
[    0.692782] usbcore: registered new device driver usb
[    0.696180] pps_core: LinuxPPS API ver. 1 registered
[    0.696611] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.697563] PTP clock support registered
[    0.700198] wmi: Mapper loaded
[    0.700485] Advanced Linux Sound Architecture Driver Initialized.
[    0.700780] PCI: Using ACPI for IRQ routing
[    0.700780] PCI: Routing PCI interrupts for all devices because
"pci=routeirq" specified
[    0.701759] ACPI Exception: AE_NOT_FOUND, Evaluating _SRS
(20130117/pci_link-363)
[    0.704420] ACPI: Unable to set IRQ for PCI Interrupt Link [LNKS].
Try pci=noacpi or acpi=off
[    0.706538] pci 0000:00:01.3: PCI INT A: no GSI - using ISA IRQ 9
[    0.707364] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.708127] PCI: pci_cache_line_size set to 64 bytes
[    0.709395] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7
flags 0x110] (d=0, p=0)
[    0.710234] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags
0x110] (d=0, p=0)
[    0.711091] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177
flags 0x110] (d=0, p=0)
[    0.712005] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags
0x110] (d=0, p=0)
[    0.712758] pci 0000:00:01.1: BAR 4: reserving [io  0xc040-0xc04f
flags 0x40101] (d=0, p=0)
[    0.713543] pci 0000:00:01.3: BAR 17: reserving [io  0xb000-0xb03f
flags 0x100] (d=0, p=0)
[    0.714380] pci 0000:00:01.3: BAR 18: reserving [io  0xb100-0xb10f
flags 0x100] (d=0, p=0)
[    0.715234] pci 0000:00:02.0: BAR 0: reserving [mem
0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.716006] pci 0000:00:02.0: BAR 1: reserving [mem
0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    0.716856] pci 0000:00:03.0: BAR 0: reserving [mem
0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    0.717699] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f
flags 0x40101] (d=0, p=0)
[    0.720052] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.720690] e820: reserve RAM buffer [mem 0x03e05000-0x03ffffff]
[    0.721420] Bluetooth: Core ver 2.16
[    0.721420] NET: Registered protocol family 31
[    0.724017] Bluetooth: HCI device and connection manager initialized
[    0.725596] Bluetooth: HCI socket layer initialized
[    0.726161] Bluetooth: L2CAP socket layer initialized
[    0.726655] Bluetooth: SCO socket layer initialized
[    0.728528] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.729324] cfg80211: Calling CRDA to update world regulatory domain
[    0.730101] Switching to clocksource hpet
[    0.766022] FS-Cache: Loaded
[    0.766821] CacheFiles: Loaded
[    0.767702] pnp: PnP ACPI init
[    0.768472] ACPI: bus type pnp registered
[    0.769582] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.771642] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.773368] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.775044] pnp 00:03: [dma 2]
[    0.775977] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.777890] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.779751] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.781854] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.783655] pnp: PnP ACPI: found 7 devices
[    0.784719] ACPI: ACPI bus type pnp unregistered
[    0.785838] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.806903] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.808278] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.809605] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.811076] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.812684] NET: Registered protocol family 2
[    0.813963] TCP established hash table entries: 32768 (order: 7,
524288 bytes)
[    0.815898] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    0.819977] TCP: Hash tables configured (established 32768 bind 32768)
[    0.821600] TCP: reno registered
[    0.822438] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    0.824848] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    0.826639] NET: Registered protocol family 1
[    0.827501] RPC: Registered named UNIX socket transport module.
[    0.828310] RPC: Registered udp transport module.
[    0.828853] RPC: Registered tcp transport module.
[    0.829329] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.830038] pci 0000:00:00.0: calling quirk_natoma+0x0/0x40
[    0.830580] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.831213] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    0.831853] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.832792] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x40
[    0.833410] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.834124] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xe0
[    0.834696] pci 0000:00:02.0: Boot video device
[    0.835139] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1c0
[    0.835802] PCI: CLS 0 bytes, default 64
[    0.836521] Trying to unpack rootfs image as initramfs...
[    0.841605] rootfs image is not initramfs (no cpio magic); looks
like an initrd
[    0.868223] Freeing initrd memory: 39244k freed
[    0.875329] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.876117] software IO TLB: No low mem
[    0.876860] kvm: no hardware support
[    0.877278] has_svm: not amd
[    0.877640] kvm: no hardware support
[    0.878195] Machine check injector initialized
[    0.880145] microcode: CPU0 sig=0x623, pf=0x0, revision=0x1
[    0.881139] microcode: CPU1 sig=0x623, pf=0x0, revision=0x1
[    0.881950] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.930662] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.949664] VFS: Disk quotas dquot_6.5.2
[    0.950330] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.952186] DLM installed
[    0.955513] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.957586] FS-Cache: Netfs 'nfs' registered for caching
[    0.959002] NFS: Registering the id_resolver key type
[    0.959609] Key type id_resolver registered
[    0.960185] Key type id_legacy registered
[    0.961346] NTFS driver 2.1.30 [Flags: R/O].
[    0.962202] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.965459] Btrfs loaded
[    0.967659] GFS2 installed
[    0.967957] msgmni has been set to 5027
[    0.972163] async_tx: api initialized (async)
[    0.973046] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 251)
[    0.974200] io scheduler noop registered
[    0.974614] io scheduler deadline registered
[    0.976305] io scheduler cfq registered (default)
[    0.979413] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.980707] pciehp: pcie_port_service_register = 0
[    0.981188] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.981862] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    0.982720] cpcihp_generic: Generic port I/O CompactPCI Hot Plug
Driver version: 0.1
[    0.983557] cpcihp_generic: not configured, disabling.
[    0.984399] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.985083] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.985716]   add_bridge is called for \_SB_.PCI0 ffff8801988c91e0
[    0.986387] acpiphp_glue: found PCI host-bus bridge with hot-pluggable slots
[    0.987114] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.988400] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.989300] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.990186] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.991106] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.992044] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.992955] acpiphp_glue: found ACPI PCI Hotplug slot 3 at PCI 0000:00:03
[    0.993737] pci_bus 0000:00: dev 03, created physical slot 3
[    0.994696] pci_hotplug: __pci_hp_register: Added slot 3 to the list
[    0.995305] acpiphp: Slot [3] registered
[    0.995727] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    0.996750] acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:00:04
[    0.997513] pci_bus 0000:00: dev 04, created physical slot 4
[    0.998383] pci_hotplug: __pci_hp_register: Added slot 4 to the list
[    0.999104] acpiphp: Slot [4] registered
[    0.999581] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.000608] acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:00:05
[    1.001355] pci_bus 0000:00: dev 05, created physical slot 5
[    1.002210] pci_hotplug: __pci_hp_register: Added slot 5 to the list
[    1.003061] acpiphp: Slot [5] registered
[    1.003606] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.004869] acpiphp_glue: found ACPI PCI Hotplug slot 6 at PCI 0000:00:06
[    1.006092] pci_bus 0000:00: dev 06, created physical slot 6
[    1.007599] pci_hotplug: __pci_hp_register: Added slot 6 to the list
[    1.008576] acpiphp: Slot [6] registered
[    1.009019] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.009958] acpiphp_glue: found ACPI PCI Hotplug slot 7 at PCI 0000:00:07
[    1.010663] pci_bus 0000:00: dev 07, created physical slot 7
[    1.011507] pci_hotplug: __pci_hp_register: Added slot 7 to the list
[    1.012403] acpiphp: Slot [7] registered
[    1.012870] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.013667] acpiphp_glue: found ACPI PCI Hotplug slot 8 at PCI 0000:00:08
[    1.014364] pci_bus 0000:00: dev 08, created physical slot 8
[    1.015183] pci_hotplug: __pci_hp_register: Added slot 8 to the list
[    1.015883] acpiphp: Slot [8] registered
[    1.016448] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.017347] acpiphp_glue: found ACPI PCI Hotplug slot 9 at PCI 0000:00:09
[    1.018092] pci_bus 0000:00: dev 09, created physical slot 9
[    1.018942] pci_hotplug: __pci_hp_register: Added slot 9 to the list
[    1.019588] acpiphp: Slot [9] registered
[    1.020070] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.021018] acpiphp_glue: found ACPI PCI Hotplug slot 10 at PCI 0000:00:0a
[    1.021797] pci_bus 0000:00: dev 0a, created physical slot 10
[    1.022619] pci_hotplug: __pci_hp_register: Added slot 10 to the list
[    1.023278] acpiphp: Slot [10] registered
[    1.023703] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.024743] acpiphp_glue: found ACPI PCI Hotplug slot 11 at PCI 0000:00:0b
[    1.025522] pci_bus 0000:00: dev 0b, created physical slot 11
[    1.026446] pci_hotplug: __pci_hp_register: Added slot 11 to the list
[    1.027102] acpiphp: Slot [11] registered
[    1.027553] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.028570] acpiphp_glue: found ACPI PCI Hotplug slot 12 at PCI 0000:00:0c
[    1.029291] pci_bus 0000:00: dev 0c, created physical slot 12
[    1.030153] pci_hotplug: __pci_hp_register: Added slot 12 to the list
[    1.030880] acpiphp: Slot [12] registered
[    1.031303] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.032265] acpiphp_glue: found ACPI PCI Hotplug slot 13 at PCI 0000:00:0d
[    1.033189] pci_bus 0000:00: dev 0d, created physical slot 13
[    1.034177] pci_hotplug: __pci_hp_register: Added slot 13 to the list
[    1.035003] acpiphp: Slot [13] registered
[    1.035873] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.037446] acpiphp_glue: found ACPI PCI Hotplug slot 14 at PCI 0000:00:0e
[    1.038243] pci_bus 0000:00: dev 0e, created physical slot 14
[    1.039209] pci_hotplug: __pci_hp_register: Added slot 14 to the list
[    1.039880] acpiphp: Slot [14] registered
[    1.040523] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.041310] acpiphp_glue: found ACPI PCI Hotplug slot 15 at PCI 0000:00:0f
[    1.041997] pci_bus 0000:00: dev 0f, created physical slot 15
[    1.042810] pci_hotplug: __pci_hp_register: Added slot 15 to the list
[    1.043530] acpiphp: Slot [15] registered
[    1.043946] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.044926] acpiphp_glue: found ACPI PCI Hotplug slot 16 at PCI 0000:00:10
[    1.045693] pci_bus 0000:00: dev 10, created physical slot 16
[    1.046565] pci_hotplug: __pci_hp_register: Added slot 16 to the list
[    1.047281] acpiphp: Slot [16] registered
[    1.047697] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.048659] acpiphp_glue: found ACPI PCI Hotplug slot 17 at PCI 0000:00:11
[    1.049342] pci_bus 0000:00: dev 11, created physical slot 17
[    1.050088] pci_hotplug: __pci_hp_register: Added slot 17 to the list
[    1.050849] acpiphp: Slot [17] registered
[    1.051250] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.052215] acpiphp_glue: found ACPI PCI Hotplug slot 18 at PCI 0000:00:12
[    1.052900] pci_bus 0000:00: dev 12, created physical slot 18
[    1.053683] pci_hotplug: __pci_hp_register: Added slot 18 to the list
[    1.054364] acpiphp: Slot [18] registered
[    1.054847] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.055681] acpiphp_glue: found ACPI PCI Hotplug slot 19 at PCI 0000:00:13
[    1.056551] pci_bus 0000:00: dev 13, created physical slot 19
[    1.057330] pci_hotplug: __pci_hp_register: Added slot 19 to the list
[    1.057993] acpiphp: Slot [19] registered
[    1.058432] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.059293] acpiphp_glue: found ACPI PCI Hotplug slot 20 at PCI 0000:00:14
[    1.060134] pci_bus 0000:00: dev 14, created physical slot 20
[    1.060934] pci_hotplug: __pci_hp_register: Added slot 20 to the list
[    1.061642] acpiphp: Slot [20] registered
[    1.062134] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.063206] acpiphp_glue: found ACPI PCI Hotplug slot 21 at PCI 0000:00:15
[    1.064324] pci_bus 0000:00: dev 15, created physical slot 21
[    1.065437] pci_hotplug: __pci_hp_register: Added slot 21 to the list
[    1.066835] acpiphp: Slot [21] registered
[    1.067700] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.068707] acpiphp_glue: found ACPI PCI Hotplug slot 22 at PCI 0000:00:16
[    1.069480] pci_bus 0000:00: dev 16, created physical slot 22
[    1.070259] pci_hotplug: __pci_hp_register: Added slot 22 to the list
[    1.070973] acpiphp: Slot [22] registered
[    1.071659] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.072728] acpiphp_glue: found ACPI PCI Hotplug slot 23 at PCI 0000:00:17
[    1.073443] pci_bus 0000:00: dev 17, created physical slot 23
[    1.074251] pci_hotplug: __pci_hp_register: Added slot 23 to the list
[    1.074892] acpiphp: Slot [23] registered
[    1.075352] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.076324] acpiphp_glue: found ACPI PCI Hotplug slot 24 at PCI 0000:00:18
[    1.077140] pci_bus 0000:00: dev 18, created physical slot 24
[    1.077936] pci_hotplug: __pci_hp_register: Added slot 24 to the list
[    1.078687] acpiphp: Slot [24] registered
[    1.079161] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.079964] acpiphp_glue: found ACPI PCI Hotplug slot 25 at PCI 0000:00:19
[    1.080824] pci_bus 0000:00: dev 19, created physical slot 25
[    1.081636] pci_hotplug: __pci_hp_register: Added slot 25 to the list
[    1.082358] acpiphp: Slot [25] registered
[    1.082803] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.083598] acpiphp_glue: found ACPI PCI Hotplug slot 26 at PCI 0000:00:1a
[    1.084546] pci_bus 0000:00: dev 1a, created physical slot 26
[    1.085363] pci_hotplug: __pci_hp_register: Added slot 26 to the list
[    1.086074] acpiphp: Slot [26] registered
[    1.086478] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.087266] acpiphp_glue: found ACPI PCI Hotplug slot 27 at PCI 0000:00:1b
[    1.088072] pci_bus 0000:00: dev 1b, created physical slot 27
[    1.088939] pci_hotplug: __pci_hp_register: Added slot 27 to the list
[    1.089568] acpiphp: Slot [27] registered
[    1.089998] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.090857] acpiphp_glue: found ACPI PCI Hotplug slot 28 at PCI 0000:00:1c
[    1.091586] pci_bus 0000:00: dev 1c, created physical slot 28
[    1.092884] pci_hotplug: __pci_hp_register: Added slot 28 to the list
[    1.093499] acpiphp: Slot [28] registered
[    1.094494] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.096476] acpiphp_glue: found ACPI PCI Hotplug slot 29 at PCI 0000:00:1d
[    1.097539] pci_bus 0000:00: dev 1d, created physical slot 29
[    1.098408] pci_hotplug: __pci_hp_register: Added slot 29 to the list
[    1.099258] acpiphp: Slot [29] registered
[    1.099685] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.100727] acpiphp_glue: found ACPI PCI Hotplug slot 30 at PCI 0000:00:1e
[    1.101477] pci_bus 0000:00: dev 1e, created physical slot 30
[    1.102336] pci_hotplug: __pci_hp_register: Added slot 30 to the list
[    1.102993] acpiphp: Slot [30] registered
[    1.103477] pci_bus 0000:00:   bridge DEVICE_ACPI_HANDLE
ffff8801988c91e0 : pci0000:00
[    1.104472] acpiphp_glue: found ACPI PCI Hotplug slot 31 at PCI 0000:00:1f
[    1.105438] pci_bus 0000:00: dev 1f, created physical slot 31
[    1.106302] pci_hotplug: __pci_hp_register: Added slot 31 to the list
[    1.106997] acpiphp: Slot [31] registered
[    1.109325] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    1.111415] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.112313] ACPI: Power Button [PWRF]
[    1.120725] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.201277] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.224167] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.228414] Non-volatile memory driver v1.3
[    1.230047] Linux agpgart interface v0.103
[    1.232449] [drm] Initialized drm 1.1.0 20060810
[    1.234289] i2c-core: driver [sil164] registered
[    1.242053] brd: module loaded
[    1.246536] loop: module loaded
[    1.247697] mtip32xx Version 1.2.6os3
[    1.249241] i2c-core: driver [at24] registered
[    1.251815] Loading iSCSI transport class v2.0-870.
[    1.255062] rdac: device handler registered
[    1.257222] iscsi: registered transport (tcp)
[    1.258584] Adaptec aacraid driver 1.2-0[29801]-ms
[    1.259927] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    1.261817] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    1.263790] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
Driver: 8.04.00.08-k-debug.
[    1.266289] iscsi: registered transport (qla4xxx)
[    1.267542] QLogic iSCSI HBA Driver
[    1.268322] Emulex LightPulse Fibre Channel SCSI driver 8.3.36
[    1.269763] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[    1.271554] Brocade BFA FC/FCOE SCSI driver - version: 3.1.2.1
[    1.273501] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16
00:01:03 EST 2006)
[    1.275475] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    1.277402] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
[    1.279120] mpt2sas version 14.100.00.00 loaded
[    1.280992] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.283443] SCSI Media Changer driver v0.25
[    1.285280] osd: LOADED open-osd 0.2.1
[    1.286542] ata_piix 0000:00:01.1: version 2.13
[    1.287754] ata_piix 0000:00:01.1: enabling bus mastering
[    1.289137] ata_piix 0000:00:01.1: setting latency timer to 64
[    1.293173] scsi0 : ata_piix
[    1.294650] scsi1 : ata_piix
[    1.295733] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
[    1.297436] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
[    1.314246] libphy: Fixed MDIO Bus: probed
[    1.315809] tun: Universal TUN/TAP device driver, 1.6
[    1.317044] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.318930] CAN device driver interface
[    1.320130] usbcore: registered new interface driver peak_usb
[    1.321798] usbcore: registered new interface driver usb_8dev
[    1.323734] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16
(Dec 05, 2012)
[    1.325753] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit
Ethernet Driver bnx2x 1.78.02-0 (2013/01/14)
[    1.328941] Brocade 10G Ethernet driver - version: 3.1.2.1
[    1.332090] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.333805] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.335248] e1000 0000:00:03.0: enabling bus mastering
[    1.336565] e1000 0000:00:03.0: setting latency timer to 64
[    1.452633] ata1.01: NODEV after polling detection
[    1.454089] ata1.00: ATA-7: QEMU HARDDISK, 1.2.50, max UDMA/100
[    1.455532] ata1.00: 65536 sectors, multi 16: LBA48
[    1.458521] ata1.00: configured for MWDMA2
[    1.460235] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK
  1.2. PQ: 0 ANSI: 5
[    1.463117] sd 0:0:0:0: [sda] 65536 512-byte logical blocks: (33.5
MB/32.0 MiB)
[    1.465345] sd 0:0:0:0: [sda] Write Protect is off
[    1.466212] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.467542] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.470354] ata2.01: NODEV after polling detection
[    1.471804] ata2.00: ATAPI: QEMU DVD-ROM, 1.2.50, max UDMA/100
[    1.474013] ata2.00: configured for MWDMA2
[    1.476308] Kernel panic - not syncing: Can not allocate SWIOTLB
buffer earlier and can't now provide you with the DMA bounce buffer
[    1.479216] Pid: 2057, comm: kworker/u:3 Not tainted
3.8.0-rc5-yh-01253-gdf8eac2-dirty #1194
[    1.480035] Call Trace:
[    1.480035]  [<ffffffff82159a78>] panic+0xc0/0x1ce
[    1.480035]  [<ffffffff814e0b54>] swiotlb_tbl_map_single+0x34/0x290
[    1.480035]  [<ffffffff814e1219>] map_single+0x19/0x20
[    1.480035]  [<ffffffff814e12e8>] swiotlb_map_sg_attrs+0xc8/0x170
[    1.480035]  [<ffffffff819b5ef1>] ata_qc_issue+0x2d1/0x3a0
[    1.480035]  [<ffffffff819bcab0>] ? ata_scsi_set_sense.constprop.13+0x30/0x30
[    1.480035]  [<ffffffff819bb508>] ata_scsi_translate+0x128/0x190
[    1.480035]  [<ffffffff819becf4>] ? ata_scsi_queuecmd+0x34/0x2c0
[    1.480035]  [<ffffffff819bef08>] ata_scsi_queuecmd+0x248/0x2c0
[    1.480035]  [<ffffffff817469c1>] scsi_dispatch_cmd+0x1c1/0x2e0
[    1.480035]  [<ffffffff8174e502>] scsi_request_fn+0x572/0x5b0
[    1.480035]  [<ffffffff810eb3aa>] ? __lock_is_held+0x5a/0x80
[    1.480035]  [<ffffffff81499837>] __blk_run_queue+0x37/0x50
[    1.480035]  [<ffffffff81498f69>] __elv_add_request+0x119/0x290
[    1.480035]  [<ffffffff8149d252>] ? drive_stat_acct+0x52/0x1f0
[    1.480035]  [<ffffffff814a0fb7>] blk_queue_bio+0x337/0x3d0
[    1.480035]  [<ffffffff8149fe9e>] generic_make_request+0xbe/0x120
[    1.480035]  [<ffffffff814a0020>] submit_bio+0x120/0x160
[    1.480035]  [<ffffffff811e5aea>] ? bio_alloc_bioset+0x9a/0x130
[    1.480035]  [<ffffffff811e069f>] submit_bh+0x1af/0x1e0
[    1.480035]  [<ffffffff811e3f4a>] block_read_full_page+0x32a/0x350
[    1.480035]  [<ffffffff811e6cd0>] ? I_BDEV+0x10/0x10
[    1.480035]  [<ffffffff8114f3d7>] ? add_to_page_cache_locked+0xc7/0x130
[    1.480035]  [<ffffffff811e7580>] ? blkdev_write_begin+0x30/0x30
[    1.480035]  [<ffffffff811e7598>] blkdev_readpage+0x18/0x20
[    1.480035]  [<ffffffff8114f622>] do_read_cache_page+0x92/0x180
[    1.480035]  [<ffffffff8114f75c>] read_cache_page_async+0x1c/0x20
[    1.480035]  [<ffffffff8114f76e>] read_cache_page+0xe/0x20
[    1.480035]  [<ffffffff814abad0>] read_dev_sector+0x30/0xa0
[    1.480035]  [<ffffffff814b04cf>] read_lba+0x10f/0x190
[    1.480035]  [<ffffffff814b0baf>] efi_partition+0x11f/0x6c0
[    1.480035]  [<ffffffff814cb8e4>] ? snprintf+0x34/0x40
[    1.480035]  [<ffffffff814b0a90>] ? compare_gpts+0x290/0x290
[    1.480035]  [<ffffffff814acc7c>] check_partition+0xfc/0x200
[    1.480035]  [<ffffffff814ac8ca>] rescan_partitions+0x8a/0x2c0
[    1.480035]  [<ffffffff811e8804>] __blkdev_get+0x4b4/0x4e0
[    1.480035]  [<ffffffff811e8b8d>] blkdev_get+0x35d/0x3d0
[    1.480035]  [<ffffffff811c8c67>] ? unlock_new_inode+0x77/0x90
[    1.480035]  [<ffffffff811e72bf>] ? bdget+0x11f/0x140
[    1.480035]  [<ffffffff814a9537>] ? disk_get_part+0x17/0xa0
[    1.480035]  [<ffffffff814a9efd>] add_disk+0x2ed/0x4a0
[    1.480035]  [<ffffffff819a3a79>] sd_probe_async+0x129/0x1f0
[    1.480035]  [<ffffffff810b7b1c>] async_run_entry_fn+0xdc/0x1a0
[    1.480035]  [<ffffffff810a938d>] process_one_work+0x2dd/0x560
[    1.480035]  [<ffffffff810a9320>] ? process_one_work+0x270/0x560
[    1.480035]  [<ffffffff810a9e79>] ? worker_thread+0x59/0x3a0
[    1.480035]  [<ffffffff810b7a40>] ? async_schedule+0x20/0x20
[    1.480035]  [<ffffffff810aa09a>] worker_thread+0x27a/0x3a0
[    1.480035]  [<ffffffff810ea7ad>] ? trace_hardirqs_on+0xd/0x10
[    1.480035]  [<ffffffff810a9e20>] ? manage_workers+0x280/0x280
[    1.480035]  [<ffffffff810af888>] kthread+0xe8/0xf0
[    1.480035]  [<ffffffff810af7a0>] ? __init_kthread_worker+0x70/0x70
[    1.480035]  [<ffffffff8217ef5c>] ret_from_fork+0x7c/0xb0
[    1.480035]  [<ffffffff810af7a0>] ? __init_kthread_worker+0x70/0x70
