Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaKLRYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:24:40 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33844 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaKLRYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:24:35 -0500
Message-ID: <5463979C.6090600@gmail.com>
Date: Wed, 12 Nov 2014 19:23:40 +0200
From: Giedrius Statkevicius <giedriuswork@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>, miklos@szeredi.hu
CC: fuse-devel@lists.sourceforge.net, thierry.reding@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fuse: don't check for file->private_data on open().
References: <20141112112643.GA30821@ulmo.nvidia.com> <1415809894-24084-1-git-send-email-martink@posteo.de>
In-Reply-To: <1415809894-24084-1-git-send-email-martink@posteo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.11.12 18:31, Martin Kepplinger wrote:
> The miscdevice core now sets file->private_data to the struct miscdevice
> so don't fail when this is not NULL.
> 
> Reported-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
Hello,

Looks like this patch does not solve the problem with FUSE I have
mentioned in the original report. I have gone ahead and patched
3.18.0-rc4-next-20141112 with your patch and tested it. Was not able to
get into gdm, barely got into another tty but was not able to do
anything, still experiencing lockups. I cannot comment on the patch as I
am not familiar with the code.

The whole journal of that boot with only 'kernel:' lines:

Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys cpuset
Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys cpu
Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys cpuacct
Lap 12 19:01:15 ghost kernel: Linux version 3.18.0-rc4-next-20141112-dirty (giedrius@ghost) (gcc version 4.9.2 (GCC) ) #51 SMP PREEMPT Wed Nov 12 18:41:54 EET 2014
Lap 12 19:01:15 ghost kernel: Command line: initrd=\intel-ucode.img initrd=\initramfs-linux-next.img root=/dev/mapper/lvm-root cryptdevice=/dev/sda2:lvm rw
Lap 12 19:01:15 ghost kernel: e820: BIOS-provided physical RAM map:
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000b8a9cfff] usable
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000b8a9d000-0x00000000b9ebdfff] reserved
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000b9ebe000-0x00000000b9fbdfff] ACPI NVS
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000b9fbe000-0x00000000b9ffefff] ACPI data
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000b9fff000-0x00000000b9ffffff] usable
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x00000000ffec0000-0x00000000ffedefff] reserved
Lap 12 19:01:15 ghost kernel: BIOS-e820: [mem 0x0000000100000000-0x000000013fdfffff] usable
Lap 12 19:01:15 ghost kernel: NX (Execute Disable) protection: active
Lap 12 19:01:15 ghost kernel: e820: update [mem 0xb2d7d018-0xb2d8d057] usable ==> usable
Lap 12 19:01:15 ghost kernel: e820: update [mem 0xb2d70018-0xb2d7c857] usable ==> usable
Lap 12 19:01:15 ghost kernel: extended physical RAM map:
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x0000000000000000-0x000000000009cfff] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x000000000009d000-0x000000000009ffff] reserved
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x0000000000100000-0x00000000b2d70017] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b2d70018-0x00000000b2d7c857] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b2d7c858-0x00000000b2d7d017] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b2d7d018-0x00000000b2d8d057] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b2d8d058-0x00000000b8a9cfff] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b8a9d000-0x00000000b9ebdfff] reserved
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b9ebe000-0x00000000b9fbdfff] ACPI NVS
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b9fbe000-0x00000000b9ffefff] ACPI data
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000b9fff000-0x00000000b9ffffff] usable
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x00000000ffec0000-0x00000000ffedefff] reserved
Lap 12 19:01:15 ghost kernel: reserve setup_data: [mem 0x0000000100000000-0x000000013fdfffff] usable
Lap 12 19:01:15 ghost kernel: efi: EFI v2.10 by HPQ
Lap 12 19:01:15 ghost kernel: efi:  ACPI=0xb9ffe000  ACPI 2.0=0xb9ffe014  SMBIOS=0xb956d598 
Lap 12 19:01:15 ghost kernel: efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem01: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000007000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000007000-0x0000000000058000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem03: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000058000-0x0000000000059000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem04: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000059000-0x000000000009d000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem05: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009d000-0x00000000000a0000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem06: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000001000000) (15MB)
Lap 12 19:01:15 ghost kernel: efi: mem07: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001000000-0x0000000001e36000) (14MB)
Lap 12 19:01:15 ghost kernel: efi: mem08: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001e36000-0x000000007fa72000) (2012MB)
Lap 12 19:01:15 ghost kernel: efi: mem09: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007fa72000-0x0000000080000000) (5MB)
Lap 12 19:01:15 ghost kernel: efi: mem10: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000080000000-0x00000000afc68000) (764MB)
Lap 12 19:01:15 ghost kernel: efi: mem11: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000afc68000-0x00000000b1a9e000) (30MB)
Lap 12 19:01:15 ghost kernel: efi: mem12: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b1a9e000-0x00000000b1abe000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem13: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b1abe000-0x00000000b2d70000) (18MB)
Lap 12 19:01:15 ghost kernel: efi: mem14: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b2d70000-0x00000000b2d92000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem15: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b2d92000-0x00000000b2da9000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem16: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b2da9000-0x00000000b33d1000) (6MB)
Lap 12 19:01:15 ghost kernel: efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b33d1000-0x00000000b4a8e000) (22MB)
Lap 12 19:01:15 ghost kernel: efi: mem18: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4a8e000-0x00000000b4a9d000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem19: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4a9d000-0x00000000b4cc0000) (2MB)
Lap 12 19:01:15 ghost kernel: efi: mem20: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4cc0000-0x00000000b4d48000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem21: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4d48000-0x00000000b4d8c000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem22: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4d8c000-0x00000000b4e14000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem23: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4e14000-0x00000000b4e4a000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem24: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4e4a000-0x00000000b4e50000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem25: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4e50000-0x00000000b4e51000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem26: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4e51000-0x00000000b4e62000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem27: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4e62000-0x00000000b4e63000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem28: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b4e63000-0x00000000b6b63000) (29MB)
Lap 12 19:01:15 ghost kernel: efi: mem29: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6b63000-0x00000000b6b67000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem30: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6b67000-0x00000000b6b72000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem31: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6b72000-0x00000000b6b74000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem32: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6b74000-0x00000000b6b78000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem33: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6b78000-0x00000000b6b79000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem34: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6b79000-0x00000000b6ca0000) (1MB)
Lap 12 19:01:15 ghost kernel: efi: mem35: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6ca0000-0x00000000b6ca1000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem36: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b6ca1000-0x00000000b8a9d000) (29MB)
Lap 12 19:01:15 ghost kernel: efi: mem37: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000b8a9d000-0x00000000b8c30000) (1MB)
Lap 12 19:01:15 ghost kernel: efi: mem38: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000b8c30000-0x00000000b92a4000) (6MB)
Lap 12 19:01:15 ghost kernel: efi: mem39: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000b92a4000-0x00000000b93d2000) (1MB)
Lap 12 19:01:15 ghost kernel: efi: mem40: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000b93d2000-0x00000000b96be000) (2MB)
Lap 12 19:01:15 ghost kernel: efi: mem41: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b96be000-0x00000000b9d88000) (6MB)
Lap 12 19:01:15 ghost kernel: efi: mem42: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b9d88000-0x00000000b9ebe000) (1MB)
Lap 12 19:01:15 ghost kernel: efi: mem43: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b9ebe000-0x00000000b9fb0000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem44: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b9fb0000-0x00000000b9fbe000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem45: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b9fbe000-0x00000000b9fcc000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem46: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b9fcc000-0x00000000b9fff000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem47: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000b9fff000-0x00000000ba000000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem48: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000013fe00000) (1022MB)
Lap 12 19:01:15 ghost kernel: efi: mem49: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem50: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
Lap 12 19:01:15 ghost kernel: efi: mem51: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |  ] range=[0x00000000ffec0000-0x00000000ffedf000) (0MB)
Lap 12 19:01:15 ghost kernel: SMBIOS 2.7 present.
Lap 12 19:01:15 ghost kernel: DMI: Hewlett-Packard HP ProBook 4540s/17F6, BIOS 68IRR Ver. F.32 11/06/2012
Lap 12 19:01:15 ghost kernel: e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
Lap 12 19:01:15 ghost kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
Lap 12 19:01:15 ghost kernel: AGP: No AGP bridge found
Lap 12 19:01:15 ghost kernel: e820: last_pfn = 0x13fe00 max_arch_pfn = 0x400000000
Lap 12 19:01:15 ghost kernel: MTRR default type: uncachable
Lap 12 19:01:15 ghost kernel: MTRR fixed ranges enabled:
Lap 12 19:01:15 ghost kernel:   00000-9FFFF write-back
Lap 12 19:01:15 ghost kernel:   A0000-BFFFF uncachable
Lap 12 19:01:15 ghost kernel:   C0000-FFFFF write-protect
Lap 12 19:01:15 ghost kernel: MTRR variable ranges enabled:
Lap 12 19:01:15 ghost kernel:   0 base 0FF800000 mask FFF800000 write-protect
Lap 12 19:01:15 ghost kernel:   1 base 000000000 mask F80000000 write-back
Lap 12 19:01:15 ghost kernel:   2 base 080000000 mask FC0000000 write-back
Lap 12 19:01:15 ghost kernel:   3 base 0BC000000 mask FFC000000 uncachable
Lap 12 19:01:15 ghost kernel:   4 base 0BB000000 mask FFF000000 uncachable
Lap 12 19:01:15 ghost kernel:   5 base 100000000 mask FC0000000 write-back
Lap 12 19:01:15 ghost kernel:   6 base 13FE00000 mask FFFE00000 uncachable
Lap 12 19:01:15 ghost kernel:   7 disabled
Lap 12 19:01:15 ghost kernel:   8 disabled
Lap 12 19:01:15 ghost kernel:   9 disabled
Lap 12 19:01:15 ghost kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Lap 12 19:01:15 ghost kernel: e820: last_pfn = 0xba000 max_arch_pfn = 0x400000000
Lap 12 19:01:15 ghost kernel: Scanning 1 areas for low memory corruption
Lap 12 19:01:15 ghost kernel: Base memory trampoline at [ffff880000097000] 97000 size 24576
Lap 12 19:01:15 ghost kernel: init_memory_mapping: [mem 0x00000000-0x000fffff]
Lap 12 19:01:15 ghost kernel:  [mem 0x00000000-0x000fffff] page 4k
Lap 12 19:01:15 ghost kernel: BRK [0x01b2b000, 0x01b2bfff] PGTABLE
Lap 12 19:01:15 ghost kernel: BRK [0x01b2c000, 0x01b2cfff] PGTABLE
Lap 12 19:01:15 ghost kernel: BRK [0x01b2d000, 0x01b2dfff] PGTABLE
Lap 12 19:01:15 ghost kernel: init_memory_mapping: [mem 0x13fc00000-0x13fdfffff]
Lap 12 19:01:15 ghost kernel:  [mem 0x13fc00000-0x13fdfffff] page 2M
Lap 12 19:01:15 ghost kernel: BRK [0x01b2e000, 0x01b2efff] PGTABLE
Lap 12 19:01:15 ghost kernel: init_memory_mapping: [mem 0x13c000000-0x13fbfffff]
Lap 12 19:01:15 ghost kernel:  [mem 0x13c000000-0x13fbfffff] page 2M
Lap 12 19:01:15 ghost kernel: init_memory_mapping: [mem 0x100000000-0x13bffffff]
Lap 12 19:01:15 ghost kernel:  [mem 0x100000000-0x13bffffff] page 2M
Lap 12 19:01:15 ghost kernel: init_memory_mapping: [mem 0x00100000-0xb8a9cfff]
Lap 12 19:01:15 ghost kernel:  [mem 0x00100000-0x001fffff] page 4k
Lap 12 19:01:15 ghost kernel:  [mem 0x00200000-0xb89fffff] page 2M
Lap 12 19:01:15 ghost kernel:  [mem 0xb8a00000-0xb8a9cfff] page 4k
Lap 12 19:01:15 ghost kernel: init_memory_mapping: [mem 0xb9fff000-0xb9ffffff]
Lap 12 19:01:15 ghost kernel:  [mem 0xb9fff000-0xb9ffffff] page 4k
Lap 12 19:01:15 ghost kernel: BRK [0x01b2f000, 0x01b2ffff] PGTABLE
Lap 12 19:01:15 ghost kernel: RAMDISK: [mem 0x7fa72000-0x7fffffff]
Lap 12 19:01:15 ghost kernel: ACPI: Early table checksum verification disabled
Lap 12 19:01:15 ghost kernel: ACPI: RSDP 0x00000000B9FFE014 000024 (v02 HPQOEM)
Lap 12 19:01:15 ghost kernel: ACPI: XSDT 0x00000000B9FFE120 00007C (v01 HPQOEM SLIC-MPC 0000000F      01000013)
Lap 12 19:01:15 ghost kernel: ACPI: FACP 0x00000000B9FFC000 00010C (v05 HPQOEM 17F6     0000000F HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: DSDT 0x00000000B9FD5000 02116E (v02 HPQOEM 17F6     00000001 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: FACS 0x00000000B9EB3000 000040
Lap 12 19:01:15 ghost kernel: ACPI: HPET 0x00000000B9FFB000 000038 (v01 HPQOEM 17F6     00000001 HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: APIC 0x00000000B9FFA000 0000BC (v01 HPQOEM 17F6     00000001 HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: MCFG 0x00000000B9FF9000 00003C (v01 HPQOEM 17F6     00000001 HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: ASF! 0x00000000B9FF8000 0000A5 (v32 HPQOEM 17F6     00000001 HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0x00000000B9FD2000 0002CA (v01 HPQOEM SataAhci 00001000 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0x00000000B9FD1000 00048A (v01 HPQOEM PtidDevc 00001000 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: FPDT 0x00000000B9FCF000 000044 (v01 HPQOEM 17F6     00000001 HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: BGRT 0x00000000B9FCE000 000038 (v00 HPQOEM 17F6     00000001 HP   00000001)
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0x00000000B9FCD000 000974 (v01 PmRef  Cpu0Ist  00003000 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0x00000000B9FCC000 000AAD (v01 PmRef  CpuPm    00003000 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: Local APIC address 0xfee00000
Lap 12 19:01:15 ghost kernel: No NUMA configuration found
Lap 12 19:01:15 ghost kernel: Faking a node at [mem 0x0000000000000000-0x000000013fdfffff]
Lap 12 19:01:15 ghost kernel: NODE_DATA(0) allocated [mem 0x13fdf9000-0x13fdfcfff]
Lap 12 19:01:15 ghost kernel:  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013b400000-ffff88013f3fffff] on node 0
Lap 12 19:01:15 ghost kernel: Zone ranges:
Lap 12 19:01:15 ghost kernel:   DMA      [mem 0x00001000-0x00ffffff]
Lap 12 19:01:15 ghost kernel:   DMA32    [mem 0x01000000-0xffffffff]
Lap 12 19:01:15 ghost kernel:   Normal   [mem 0x100000000-0x13fdfffff]
Lap 12 19:01:15 ghost kernel: Movable zone start for each node
Lap 12 19:01:15 ghost kernel: Early memory node ranges
Lap 12 19:01:15 ghost kernel:   node   0: [mem 0x00001000-0x0009cfff]
Lap 12 19:01:15 ghost kernel:   node   0: [mem 0x00100000-0xb8a9cfff]
Lap 12 19:01:15 ghost kernel:   node   0: [mem 0xb9fff000-0xb9ffffff]
Lap 12 19:01:15 ghost kernel:   node   0: [mem 0x100000000-0x13fdfffff]
Lap 12 19:01:15 ghost kernel: Initmem setup node 0 [mem 0x00001000-0x13fdfffff]
Lap 12 19:01:15 ghost kernel: On node 0 totalpages: 1017914
Lap 12 19:01:15 ghost kernel:   DMA zone: 64 pages used for memmap
Lap 12 19:01:15 ghost kernel:   DMA zone: 22 pages reserved
Lap 12 19:01:15 ghost kernel:   DMA zone: 3996 pages, LIFO batch:0
Lap 12 19:01:15 ghost kernel:   DMA32 zone: 11755 pages used for memmap
Lap 12 19:01:15 ghost kernel:   DMA32 zone: 752286 pages, LIFO batch:31
Lap 12 19:01:15 ghost kernel:   Normal zone: 4088 pages used for memmap
Lap 12 19:01:15 ghost kernel:   Normal zone: 261632 pages, LIFO batch:31
Lap 12 19:01:15 ghost kernel: Reserving Intel graphics stolen memory at 0xbb200000-0xbf1fffff
Lap 12 19:01:15 ghost kernel: ACPI: PM-Timer IO Port: 0x408
Lap 12 19:01:15 ghost kernel: ACPI: Local APIC address 0xfee00000
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
Lap 12 19:01:15 ghost kernel: ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
Lap 12 19:01:15 ghost kernel: IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
Lap 12 19:01:15 ghost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Lap 12 19:01:15 ghost kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Lap 12 19:01:15 ghost kernel: ACPI: IRQ0 used by override.
Lap 12 19:01:15 ghost kernel: ACPI: IRQ9 used by override.
Lap 12 19:01:15 ghost kernel: Using ACPI (MADT) for SMP configuration information
Lap 12 19:01:15 ghost kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Lap 12 19:01:15 ghost kernel: smpboot: Allowing 8 CPUs, 4 hotplug CPUs
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb2d70000-0xb2d70fff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb2d7c000-0xb2d7cfff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb2d7d000-0xb2d7dfff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb2d8d000-0xb2d8dfff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb8a9d000-0xb9ebdfff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb9ebe000-0xb9fbdfff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xb9fbe000-0xb9ffefff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xba000000-0xbb1fffff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xbb200000-0xbf1fffff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xbf200000-0xe00f7fff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xe00f8000-0xe00f8fff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xe00f9000-0xfed1bfff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xfed20000-0xffebffff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xffec0000-0xffedefff]
Lap 12 19:01:15 ghost kernel: PM: Registered nosave memory: [mem 0xffedf000-0xffffffff]
Lap 12 19:01:15 ghost kernel: e820: [mem 0xbf200000-0xe00f7fff] available for PCI devices
Lap 12 19:01:15 ghost kernel: Booting paravirtualized kernel on bare hardware
Lap 12 19:01:15 ghost kernel: setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8 nr_node_ids:1
Lap 12 19:01:15 ghost kernel: PERCPU: Embedded 31 pages/cpu @ffff88013fa00000 s86976 r8192 d31808 u262144
Lap 12 19:01:15 ghost kernel: pcpu-alloc: s86976 r8192 d31808 u262144 alloc=1*2097152
Lap 12 19:01:15 ghost kernel: pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Lap 12 19:01:15 ghost kernel: Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1001985
Lap 12 19:01:15 ghost kernel: Policy zone: Normal
Lap 12 19:01:15 ghost kernel: Kernel command line: initrd=\intel-ucode.img initrd=\initramfs-linux-next.img root=/dev/mapper/lvm-root cryptdevice=/dev/sda2:lvm rw
Lap 12 19:01:15 ghost kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Lap 12 19:01:15 ghost kernel: xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
Lap 12 19:01:15 ghost kernel: AGP: Checking aperture...
Lap 12 19:01:15 ghost kernel: AGP: No AGP bridge found
Lap 12 19:01:15 ghost kernel: Calgary: detecting Calgary via BIOS EBDA area
Lap 12 19:01:15 ghost kernel: Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Lap 12 19:01:15 ghost kernel: Memory: 3828832K/4071656K available (5285K kernel code, 901K rwdata, 1636K rodata, 1152K init, 1160K bss, 242824K reserved, 0K cma-reserved)
Lap 12 19:01:15 ghost kernel: SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Lap 12 19:01:15 ghost kernel: Preemptible hierarchical RCU implementation.
Lap 12 19:01:15 ghost kernel:         RCU dyntick-idle grace-period acceleration is enabled.
Lap 12 19:01:15 ghost kernel:         RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
Lap 12 19:01:15 ghost kernel: RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
Lap 12 19:01:15 ghost kernel: NR_IRQS:8448 nr_irqs:488 16
Lap 12 19:01:15 ghost kernel: Console: colour dummy device 80x25
Lap 12 19:01:15 ghost kernel: console [tty0] enabled
Lap 12 19:01:15 ghost kernel: hpet clockevent registered
Lap 12 19:01:15 ghost kernel: tsc: Fast TSC calibration using PIT
Lap 12 19:01:15 ghost kernel: tsc: Detected 2494.365 MHz processor
Lap 12 19:01:15 ghost kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 4990.59 BogoMIPS (lpj=8314550)
Lap 12 19:01:15 ghost kernel: pid_max: default: 32768 minimum: 301
Lap 12 19:01:15 ghost kernel: ACPI: Core revision 20140926
Lap 12 19:01:15 ghost kernel: ACPI: All ACPI Tables successfully acquired
Lap 12 19:01:15 ghost kernel: Security Framework initialized
Lap 12 19:01:15 ghost kernel: Yama: becoming mindful.
Lap 12 19:01:15 ghost kernel: Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Lap 12 19:01:15 ghost kernel: Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Lap 12 19:01:15 ghost kernel: Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
Lap 12 19:01:15 ghost kernel: Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys devices
Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys freezer
Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys net_cls
Lap 12 19:01:15 ghost kernel: Initializing cgroup subsys blkio
Lap 12 19:01:15 ghost kernel: CPU: Physical Processor ID: 0
Lap 12 19:01:15 ghost kernel: CPU: Processor Core ID: 0
Lap 12 19:01:15 ghost kernel: ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
                              ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
Lap 12 19:01:15 ghost kernel: mce: CPU supports 7 MCE banks
Lap 12 19:01:15 ghost kernel: CPU0: Thermal monitoring enabled (TM1)
Lap 12 19:01:15 ghost kernel: Freeing SMP alternatives memory: 16K (ffffffff81a03000 - ffffffff81a07000)
Lap 12 19:01:15 ghost kernel: ftrace: allocating 20317 entries in 80 pages
Lap 12 19:01:15 ghost kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Lap 12 19:01:15 ghost kernel: smpboot: CPU0: Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz (fam: 06, model: 3a, stepping: 09)
Lap 12 19:01:15 ghost kernel: TSC deadline timer enabled
Lap 12 19:01:15 ghost kernel: Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
Lap 12 19:01:15 ghost kernel: ... version:                3
Lap 12 19:01:15 ghost kernel: ... bit width:              48
Lap 12 19:01:15 ghost kernel: ... generic registers:      4
Lap 12 19:01:15 ghost kernel: ... value mask:             0000ffffffffffff
Lap 12 19:01:15 ghost kernel: ... max period:             0000ffffffffffff
Lap 12 19:01:15 ghost kernel: ... fixed-purpose events:   3
Lap 12 19:01:15 ghost kernel: ... event mask:             000000070000000f
Lap 12 19:01:15 ghost kernel: x86: Booting SMP configuration:
Lap 12 19:01:15 ghost kernel: .... node  #0, CPUs:      #1
Lap 12 19:01:15 ghost kernel: NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
Lap 12 19:01:15 ghost kernel:  #2 #3
Lap 12 19:01:15 ghost kernel: x86: Booted up 1 node, 4 CPUs
Lap 12 19:01:15 ghost kernel: smpboot: Total of 4 processors activated (19962.37 BogoMIPS)
Lap 12 19:01:15 ghost kernel: devtmpfs: initialized
Lap 12 19:01:15 ghost kernel: PM: Registering ACPI NVS region [mem 0xb9ebe000-0xb9fbdfff] (1048576 bytes)
Lap 12 19:01:15 ghost kernel: pinctrl core: initialized pinctrl subsystem
Lap 12 19:01:15 ghost kernel: RTC time: 17:00:44, date: 11/12/14
Lap 12 19:01:15 ghost kernel: NET: Registered protocol family 16
Lap 12 19:01:15 ghost kernel: cpuidle: using governor ladder
Lap 12 19:01:15 ghost kernel: cpuidle: using governor menu
Lap 12 19:01:15 ghost kernel: ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Lap 12 19:01:15 ghost kernel: ACPI: bus type PCI registered
Lap 12 19:01:15 ghost kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Lap 12 19:01:15 ghost kernel: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Lap 12 19:01:15 ghost kernel: PCI: not using MMCONFIG
Lap 12 19:01:15 ghost kernel: PCI: Using configuration type 1 for base access
Lap 12 19:01:15 ghost kernel: ACPI: Added _OSI(Module Device)
Lap 12 19:01:15 ghost kernel: ACPI: Added _OSI(Processor Device)
Lap 12 19:01:15 ghost kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Lap 12 19:01:15 ghost kernel: ACPI: Added _OSI(Processor Aggregator Device)
Lap 12 19:01:15 ghost kernel: ACPI: Executed 1 blocks of module-level executable AML code
Lap 12 19:01:15 ghost kernel: [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
Lap 12 19:01:15 ghost kernel: ACPI: Dynamic OEM Table Load:
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0xFFFF88013A6C4000 000861 (v01 PmRef  Cpu0Cst  00003001 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: Dynamic OEM Table Load:
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0xFFFF88013A6D1C00 000303 (v01 PmRef  ApIst    00003000 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: Dynamic OEM Table Load:
Lap 12 19:01:15 ghost kernel: ACPI: SSDT 0xFFFF88013A6A2A00 000119 (v01 PmRef  ApCst    00003000 INTL 20110112)
Lap 12 19:01:15 ghost kernel: ACPI: Interpreter enabled
Lap 12 19:01:15 ghost kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
Lap 12 19:01:15 ghost kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
Lap 12 19:01:15 ghost kernel: ACPI: (supports S0 S3 S4 S5)
Lap 12 19:01:15 ghost kernel: ACPI: Using IOAPIC for interrupt routing
Lap 12 19:01:15 ghost kernel: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Lap 12 19:01:15 ghost kernel: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
Lap 12 19:01:15 ghost kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Lap 12 19:01:15 ghost kernel: ACPI: Power Resource [APPR] (off)
Lap 12 19:01:15 ghost kernel: ACPI: Power Resource [COMP] (on)
Lap 12 19:01:15 ghost kernel: ACPI: Power Resource [LPP] (on)
Lap 12 19:01:15 ghost kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
Lap 12 19:01:15 ghost kernel: acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
Lap 12 19:01:15 ghost kernel: acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
Lap 12 19:01:15 ghost kernel: PCI host bridge to bus 0000:00
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [bus 00-3e]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0xbf200000-0xdfffffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfedfffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
Lap 12 19:01:15 ghost kernel: pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
Lap 12 19:01:15 ghost kernel: pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff 64bit]
Lap 12 19:01:15 ghost kernel: pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
Lap 12 19:01:15 ghost kernel: pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: reg 0x10: [mem 0xd0900000-0xd090ffff 64bit]
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: PME# supported from D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
Lap 12 19:01:15 ghost kernel: pci 0000:00:16.0: reg 0x10: [mem 0xd0914000-0xd091400f 64bit]
Lap 12 19:01:15 ghost kernel: pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
Lap 12 19:01:15 ghost kernel: pci 0000:00:1a.0: reg 0x10: [mem 0xd0919000-0xd09193ff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1a.0: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
Lap 12 19:01:15 ghost kernel: pci 0000:00:1b.0: reg 0x10: [mem 0xd0910000-0xd0913fff 64bit]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
Lap 12 19:01:15 ghost kernel: pci 0000:00:1d.0: reg 0x10: [mem 0xd0918000-0xd09183ff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:00:1d.0: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.0: [8086:1e59] type 00 class 0x060100
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: reg 0x10: [io  0x3068-0x306f]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: reg 0x14: [io  0x3074-0x3077]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: reg 0x18: [io  0x3060-0x3067]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: reg 0x1c: [io  0x3070-0x3073]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: reg 0x20: [io  0x3040-0x305f]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: reg 0x24: [mem 0xd0917000-0xd09177ff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1f.2: PME# supported from D3hot
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.0:   bridge window [mem 0xd0800000-0xd08fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.0: [197b:2392] type 00 class 0x088000
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.0: reg 0x10: [mem 0xd0703000-0xd07030ff]
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.2: [197b:2391] type 00 class 0x080501
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.2: reg 0x10: [mem 0xd0702000-0xd07020ff]
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.3: [197b:2393] type 00 class 0x088000
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.3: reg 0x10: [mem 0xd0701000-0xd07010ff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2: PCI bridge to [bus 02]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2:   bridge window [mem 0xd0700000-0xd07fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.0: [1814:3290] type 00 class 0x028000
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.0: reg 0x10: [mem 0xd0610000-0xd061ffff]
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.0: PME# supported from D0 D3hot
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.0: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.1: [1814:3298] type 00 class 0x0d1100
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.1: reg 0x10: [mem 0xd0600000-0xd060ffff]
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.1: supports D1
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.1: PME# supported from D0 D1 D3hot
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3: PCI bridge to [bus 03]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3:   bridge window [mem 0xd0600000-0xd06fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: reg 0x10: [io  0x2000-0x20ff]
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: reg 0x18: [mem 0xd0404000-0xd0404fff 64bit pref]
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: reg 0x20: [mem 0xd0400000-0xd0403fff 64bit pref]
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: supports D1 D2
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: System wakeup disabled by ACPI
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5: PCI bridge to [bus 04]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5:   bridge window [mem 0xd0500000-0xd05fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5:   bridge window [mem 0xd0400000-0xd04fffff 64bit pref]
Lap 12 19:01:15 ghost kernel: acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Lap 12 19:01:15 ghost kernel: ACPI: Enabled 5 GPEs in block 00 to 3F
Lap 12 19:01:15 ghost kernel: ACPI : EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
Lap 12 19:01:15 ghost kernel: vgaarb: setting as boot device: PCI:0000:00:02.0
Lap 12 19:01:15 ghost kernel: vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Lap 12 19:01:15 ghost kernel: vgaarb: loaded
Lap 12 19:01:15 ghost kernel: vgaarb: bridge control possible 0000:00:02.0
Lap 12 19:01:15 ghost kernel: PCI: Using ACPI for IRQ routing
Lap 12 19:01:15 ghost kernel: PCI: pci_cache_line_size set to 64 bytes
Lap 12 19:01:15 ghost kernel: e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
Lap 12 19:01:15 ghost kernel: e820: reserve RAM buffer [mem 0xb2d70018-0xb3ffffff]
Lap 12 19:01:15 ghost kernel: e820: reserve RAM buffer [mem 0xb2d7d018-0xb3ffffff]
Lap 12 19:01:15 ghost kernel: e820: reserve RAM buffer [mem 0xb8a9d000-0xbbffffff]
Lap 12 19:01:15 ghost kernel: e820: reserve RAM buffer [mem 0xba000000-0xbbffffff]
Lap 12 19:01:15 ghost kernel: e820: reserve RAM buffer [mem 0x13fe00000-0x13fffffff]
Lap 12 19:01:15 ghost kernel: NetLabel: Initializing
Lap 12 19:01:15 ghost kernel: NetLabel:  domain hash size = 128
Lap 12 19:01:15 ghost kernel: NetLabel:  protocols = UNLABELED CIPSOv4
Lap 12 19:01:15 ghost kernel: NetLabel:  unlabeled traffic allowed by default
Lap 12 19:01:15 ghost kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Lap 12 19:01:15 ghost kernel: hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Lap 12 19:01:15 ghost kernel: Switched to clocksource hpet
Lap 12 19:01:15 ghost kernel: pnp: PnP ACPI init
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed10000-0xfed17fff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed18000-0xfed18fff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed19000-0xfed19fff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xe0000000-0xefffffff] could not be reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
Lap 12 19:01:15 ghost kernel: system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
Lap 12 19:01:15 ghost kernel: system 00:01: [io  0xfe00-0xfe0f] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:01: [io  0xfe80-0xfe8f] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0x0200-0x027f] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0x1000-0x100f] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0xffff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0xffff] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0x0400-0x047f] could not be reserved
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0x0500-0x057f] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:02: [io  0xef80-0xef9f] has been reserved
Lap 12 19:01:15 ghost kernel: system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
Lap 12 19:01:15 ghost kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
Lap 12 19:01:15 ghost kernel: pnp 00:04: Plug and Play ACPI device, IDs HPQ8001 PNP0303 (active)
Lap 12 19:01:15 ghost kernel: pnp 00:05: Plug and Play ACPI device, IDs SYN0197 SYN0100 SYN0002 PNP0f13 (active)
Lap 12 19:01:15 ghost kernel: system 00:06: [mem 0x20000000-0x201fffff] could not be reserved
Lap 12 19:01:15 ghost kernel: system 00:06: [mem 0x40004000-0x40004fff] could not be reserved
Lap 12 19:01:15 ghost kernel: system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
Lap 12 19:01:15 ghost kernel: pnp: PnP ACPI: found 7 devices
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.0:   bridge window [mem 0xd0800000-0xd08fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.0: BAR 6: assigned [mem 0xd0710000-0xd071ffff pref]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2: PCI bridge to [bus 02]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.2:   bridge window [mem 0xd0700000-0xd07fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3: PCI bridge to [bus 03]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.3:   bridge window [mem 0xd0600000-0xd06fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5: PCI bridge to [bus 04]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5:   bridge window [mem 0xd0500000-0xd05fffff]
Lap 12 19:01:15 ghost kernel: pci 0000:00:1c.5:   bridge window [mem 0xd0400000-0xd04fffff 64bit pref]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 20 [mem 0xbf200000-0xdfffffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 21 [mem 0xf0000000-0xfedfffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:00: resource 22 [mem 0xfee01000-0xffffffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:01: resource 1 [mem 0xd0800000-0xd08fffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:02: resource 1 [mem 0xd0700000-0xd07fffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:03: resource 1 [mem 0xd0600000-0xd06fffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:04: resource 1 [mem 0xd0500000-0xd05fffff]
Lap 12 19:01:15 ghost kernel: pci_bus 0000:04: resource 2 [mem 0xd0400000-0xd04fffff 64bit pref]
Lap 12 19:01:15 ghost kernel: NET: Registered protocol family 2
Lap 12 19:01:15 ghost kernel: TCP established hash table entries: 32768 (order: 6, 262144 bytes)
Lap 12 19:01:15 ghost kernel: TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
Lap 12 19:01:15 ghost kernel: TCP: Hash tables configured (established 32768 bind 32768)
Lap 12 19:01:15 ghost kernel: TCP: reno registered
Lap 12 19:01:15 ghost kernel: UDP hash table entries: 2048 (order: 4, 65536 bytes)
Lap 12 19:01:15 ghost kernel: UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
Lap 12 19:01:15 ghost kernel: NET: Registered protocol family 1
Lap 12 19:01:15 ghost kernel: pci 0000:00:02.0: Video device with shadowed ROM
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: enabling device (0000 -> 0002)
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: can't derive routing for PCI INT A
Lap 12 19:01:15 ghost kernel: pci 0000:00:14.0: PCI INT A: no GSI
Lap 12 19:01:15 ghost kernel: PCI: CLS 64 bytes, default 64
Lap 12 19:01:15 ghost kernel: Unpacking initramfs...
Lap 12 19:01:15 ghost kernel: Freeing initrd memory: 5688K (ffff88007fa72000 - ffff880080000000)
Lap 12 19:01:15 ghost kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Lap 12 19:01:15 ghost kernel: software IO TLB [mem 0xada9e000-0xb1a9e000] (64MB) mapped at [ffff8800ada9e000-ffff8800b1a9dfff]
Lap 12 19:01:15 ghost kernel: RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
Lap 12 19:01:15 ghost kernel: Scanning for low memory corruption every 60 seconds
Lap 12 19:01:15 ghost kernel: futex hash table entries: 2048 (order: 5, 131072 bytes)
Lap 12 19:01:15 ghost kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
Lap 12 19:01:15 ghost kernel: zpool: loaded
Lap 12 19:01:15 ghost kernel: zbud: loaded
Lap 12 19:01:15 ghost kernel: VFS: Disk quotas dquot_6.5.2
Lap 12 19:01:15 ghost kernel: VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Lap 12 19:01:15 ghost kernel: Key type big_key registered
Lap 12 19:01:15 ghost kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
Lap 12 19:01:15 ghost kernel: io scheduler noop registered
Lap 12 19:01:15 ghost kernel: io scheduler deadline registered
Lap 12 19:01:15 ghost kernel: io scheduler cfq registered (default)
Lap 12 19:01:15 ghost kernel: pcieport 0000:00:1c.0: enabling device (0000 -> 0002)
Lap 12 19:01:15 ghost kernel: pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
Lap 12 19:01:15 ghost kernel: pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.2: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pci 0000:02:00.3: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
Lap 12 19:01:15 ghost kernel: pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pci 0000:03:00.1: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
Lap 12 19:01:15 ghost kernel: pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
Lap 12 19:01:15 ghost kernel: pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
Lap 12 19:01:15 ghost kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Lap 12 19:01:15 ghost kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Lap 12 19:01:15 ghost kernel: efifb: probing for efifb
Lap 12 19:01:15 ghost kernel: efifb: framebuffer at 0xc0000000, mapped to 0xffffc90010800000, using 4128k, total 4128k
Lap 12 19:01:15 ghost kernel: efifb: mode is 1366x768x32, linelength=5504, pages=1
Lap 12 19:01:15 ghost kernel: efifb: scrolling: redraw
Lap 12 19:01:15 ghost kernel: efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Lap 12 19:01:15 ghost kernel: Console: switching to colour frame buffer device 170x48
Lap 12 19:01:15 ghost kernel: fb0: EFI VGA frame buffer device
Lap 12 19:01:15 ghost kernel: intel_idle: MWAIT substates: 0x21120
Lap 12 19:01:15 ghost kernel: intel_idle: v0.4 model 0x3A
Lap 12 19:01:15 ghost kernel: intel_idle: lapic_timer_reliable_states 0xffffffff
Lap 12 19:01:15 ghost kernel: GHES: HEST is not enabled!
Lap 12 19:01:15 ghost kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Lap 12 19:01:15 ghost kernel: Linux agpgart interface v0.103
Lap 12 19:01:15 ghost kernel: error detecting cacheinfo..cpu0
Lap 12 19:01:15 ghost kernel: rtc_cmos 00:03: RTC can wake from S4
Lap 12 19:01:15 ghost kernel: rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Lap 12 19:01:15 ghost kernel: rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Lap 12 19:01:15 ghost kernel: Intel P-state driver initializing.
Lap 12 19:01:15 ghost kernel: ledtrig-cpu: registered to indicate activity on CPUs
Lap 12 19:01:15 ghost kernel: TCP: cubic registered
Lap 12 19:01:15 ghost kernel: NET: Registered protocol family 10
Lap 12 19:01:15 ghost kernel: NET: Registered protocol family 17
Lap 12 19:01:15 ghost kernel: registered taskstats version 1
Lap 12 19:01:15 ghost kernel:   Magic number: 6:696:36
Lap 12 19:01:15 ghost kernel: rtc_cmos 00:03: setting system clock to 2014-11-12 17:00:46 UTC (1415811646)
Lap 12 19:01:15 ghost kernel: PM: Hibernation image not present or could not be loaded.
Lap 12 19:01:15 ghost kernel: Freeing unused kernel memory: 1152K (ffffffff818e3000 - ffffffff81a03000)
Lap 12 19:01:15 ghost kernel: Write protecting the kernel read-only data: 8192k
Lap 12 19:01:15 ghost kernel: Freeing unused kernel memory: 848K (ffff88000152c000 - ffff880001600000)
Lap 12 19:01:15 ghost kernel: Freeing unused kernel memory: 412K (ffff880001799000 - ffff880001800000)
Lap 12 19:01:15 ghost kernel: random: systemd-tmpfile urandom read with 5 bits of entropy available
Lap 12 19:01:15 ghost kernel: i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Lap 12 19:01:15 ghost kernel: i8042: Detected active multiplexing controller, rev 1.1
Lap 12 19:01:15 ghost kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Lap 12 19:01:15 ghost kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Lap 12 19:01:15 ghost kernel: ACPI: bus type USB registered
Lap 12 19:01:15 ghost kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Lap 12 19:01:15 ghost kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Lap 12 19:01:15 ghost kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Lap 12 19:01:15 ghost kernel: usbcore: registered new interface driver usbfs
Lap 12 19:01:15 ghost kernel: sdhci: Secure Digital Host Controller Interface driver
Lap 12 19:01:15 ghost kernel: usbcore: registered new interface driver hub
Lap 12 19:01:15 ghost kernel: usbcore: registered new device driver usb
Lap 12 19:01:15 ghost kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Lap 12 19:01:15 ghost kernel: sdhci: Copyright(c) Pierre Ossman
Lap 12 19:01:15 ghost kernel: ehci-pci: EHCI PCI platform driver
Lap 12 19:01:15 ghost kernel: sdhci-pci 0000:02:00.0: SDHCI controller found [197b:2392] (rev 30)
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1a.0: EHCI Host Controller
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1a.0: debug port 2
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1a.0: irq 16, io mem 0xd0919000
Lap 12 19:01:15 ghost kernel: sdhci-pci 0000:02:00.0: enabling device (0000 -> 0002)
Lap 12 19:01:15 ghost kernel: sdhci-pci 0000:02:00.0: No vmmc regulator found
Lap 12 19:01:15 ghost kernel: sdhci-pci 0000:02:00.0: No vqmmc regulator found
Lap 12 19:01:15 ghost kernel: AVX version of gcm_enc/dec engaged.
Lap 12 19:01:15 ghost kernel: mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
Lap 12 19:01:15 ghost kernel: sdhci-pci 0000:02:00.2: SDHCI controller found [197b:2391] (rev 30)
Lap 12 19:01:15 ghost kernel: sdhci-pci 0000:02:00.2: Refusing to bind to secondary interface.
Lap 12 19:01:15 ghost kernel: AES CTR mode by8 optimization enabled
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Lap 12 19:01:15 ghost kernel: hub 1-0:1.0: USB hub found
Lap 12 19:01:15 ghost kernel: hub 1-0:1.0: 2 ports detected
Lap 12 19:01:15 ghost kernel: SCSI subsystem initialized
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: PCI INT A: no GSI
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
Lap 12 19:01:15 ghost kernel: libata version 3.00 loaded.
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
Lap 12 19:01:15 ghost kernel: hub 2-0:1.0: USB hub found
Lap 12 19:01:15 ghost kernel: hub 2-0:1.0: 4 ports detected
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
Lap 12 19:01:15 ghost kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
Lap 12 19:01:15 ghost kernel: hub 3-0:1.0: USB hub found
Lap 12 19:01:15 ghost kernel: hub 3-0:1.0: 4 ports detected
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1d.0: EHCI Host Controller
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1d.0: debug port 2
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1d.0: irq 16, io mem 0xd0918000
Lap 12 19:01:15 ghost kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Lap 12 19:01:15 ghost kernel: ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Lap 12 19:01:15 ghost kernel: hub 4-0:1.0: USB hub found
Lap 12 19:01:15 ghost kernel: hub 4-0:1.0: 2 ports detected
Lap 12 19:01:15 ghost kernel: ahci 0000:00:1f.2: version 3.0
Lap 12 19:01:15 ghost kernel: ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
Lap 12 19:01:15 ghost kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
Lap 12 19:01:15 ghost kernel: ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems apst 
Lap 12 19:01:15 ghost kernel: scsi host0: ahci
Lap 12 19:01:15 ghost kernel: scsi host1: ahci
Lap 12 19:01:15 ghost kernel: scsi host2: ahci
Lap 12 19:01:15 ghost kernel: scsi host3: ahci
Lap 12 19:01:15 ghost kernel: scsi host4: ahci
Lap 12 19:01:15 ghost kernel: scsi host5: ahci
Lap 12 19:01:15 ghost kernel: ata1: SATA max UDMA/133 abar m2048@0xd0917000 port 0xd0917100 irq 29
Lap 12 19:01:15 ghost kernel: ata2: SATA max UDMA/133 abar m2048@0xd0917000 port 0xd0917180 irq 29
Lap 12 19:01:15 ghost kernel: ata3: DUMMY
Lap 12 19:01:15 ghost kernel: ata4: DUMMY
Lap 12 19:01:15 ghost kernel: ata5: DUMMY
Lap 12 19:01:15 ghost kernel: ata6: DUMMY
Lap 12 19:01:15 ghost kernel: usb 1-1: new high-speed USB device number 2 using ehci-pci
Lap 12 19:01:15 ghost kernel: usb 4-1: new high-speed USB device number 2 using ehci-pci
Lap 12 19:01:15 ghost kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Lap 12 19:01:15 ghost kernel: ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
Lap 12 19:01:15 ghost kernel: ata1.00: ATA-8: Hitachi HTS547575A9E384, JE4OA50A, max UDMA/100
Lap 12 19:01:15 ghost kernel: ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Lap 12 19:01:15 ghost kernel: ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
Lap 12 19:01:15 ghost kernel: ata1.00: configured for UDMA/100
Lap 12 19:01:15 ghost kernel: scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54757 A50A PQ: 0 ANSI: 5
Lap 12 19:01:15 ghost kernel: hub 1-1:1.0: USB hub found
Lap 12 19:01:15 ghost kernel: hub 1-1:1.0: 6 ports detected
Lap 12 19:01:15 ghost kernel: hub 4-1:1.0: USB hub found
Lap 12 19:01:15 ghost kernel: hub 4-1:1.0: 6 ports detected
Lap 12 19:01:15 ghost kernel: usb 1-1.3: new high-speed USB device number 3 using ehci-pci
Lap 12 19:01:15 ghost kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Lap 12 19:01:15 ghost kernel: ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
Lap 12 19:01:15 ghost kernel: ata2.00: ATAPI: hp       DVDRAM GT80N, R102, max UDMA/100
Lap 12 19:01:15 ghost kernel: ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
Lap 12 19:01:15 ghost kernel: ata2.00: configured for UDMA/100
Lap 12 19:01:15 ghost kernel: scsi 1:0:0:0: CD-ROM            hp       DVDRAM GT80N     R102 PQ: 0 ANSI: 5
Lap 12 19:01:15 ghost kernel: sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
Lap 12 19:01:15 ghost kernel: sd 0:0:0:0: [sda] 4096-byte physical blocks
Lap 12 19:01:15 ghost kernel: sd 0:0:0:0: [sda] Write Protect is off
Lap 12 19:01:15 ghost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Lap 12 19:01:15 ghost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Lap 12 19:01:15 ghost kernel: sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Lap 12 19:01:15 ghost kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Lap 12 19:01:15 ghost kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Lap 12 19:01:15 ghost kernel:  sda: sda1 sda2
Lap 12 19:01:15 ghost kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Lap 12 19:01:15 ghost kernel: tsc: Refined TSC clocksource calibration: 2494.334 MHz
Lap 12 19:01:15 ghost kernel: device-mapper: uevent: version 1.0.3
Lap 12 19:01:15 ghost kernel: device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
Lap 12 19:01:15 ghost kernel: Switched to clocksource tsc
Lap 12 19:01:15 ghost kernel: random: nonblocking pool is initialized
Lap 12 19:01:15 ghost kernel: NET: Registered protocol family 38
Lap 12 19:01:15 ghost kernel: EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
Lap 12 19:01:15 ghost kernel: EXT4-fs (dm-1): re-mounted. Opts: data=ordered
Lap 12 19:01:16 ghost kernel: ACPI: AC Adapter [AC] (on-line)
Lap 12 19:01:16 ghost kernel: input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input5
Lap 12 19:01:16 ghost kernel: ACPI: Sleep Button [SLPB]
Lap 12 19:01:16 ghost kernel: input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input6
Lap 12 19:01:16 ghost kernel: ACPI: Lid Switch [LID]
Lap 12 19:01:16 ghost kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input7
Lap 12 19:01:16 ghost kernel: ACPI: Power Button [PWRF]
Lap 12 19:01:16 ghost kernel: Initializing HPQ6001 module
Lap 12 19:01:16 ghost kernel: input: HP Wireless hotkeys as /devices/virtual/input/input8
Lap 12 19:01:16 ghost kernel: hp_accel: laptop model unknown, using default axes configuration
Lap 12 19:01:16 ghost kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Lap 12 19:01:16 ghost kernel: ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140926/utaddress-258)
Lap 12 19:01:16 ghost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Lap 12 19:01:16 ghost kernel: ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140926/utaddress-258)
Lap 12 19:01:16 ghost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Lap 12 19:01:16 ghost kernel: ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140926/utaddress-258)
Lap 12 19:01:16 ghost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Lap 12 19:01:16 ghost kernel: ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140926/utaddress-258)
Lap 12 19:01:16 ghost kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Lap 12 19:01:16 ghost kernel: lpc_ich: Resource conflict(s) found affecting gpio_ich
Lap 12 19:01:16 ghost kernel: lis3lv02d: 8 bits 3DC sensor found
Lap 12 19:01:16 ghost kernel: wmi: Mapper loaded
Lap 12 19:01:16 ghost kernel: [drm] Initialized drm 1.1.0 20060810
Lap 12 19:01:16 ghost kernel: snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
Lap 12 19:01:17 ghost kernel: jmb38x_ms 0000:02:00.3: enabling device (0000 -> 0002)
Lap 12 19:01:17 ghost kernel: [drm] Memory usable by graphics device = 2048M
Lap 12 19:01:17 ghost kernel: [drm] Replacing VGA console driver
Lap 12 19:01:17 ghost kernel: thermal LNXTHERM:00: registered as thermal_zone0
Lap 12 19:01:17 ghost kernel: ACPI: Thermal Zone [CPUZ] (51 C)
Lap 12 19:01:17 ghost kernel: checking generic (c0000000 408000) vs hw (c0000000 10000000)
Lap 12 19:01:17 ghost kernel: fb: switching to inteldrmfb from EFI VGA
Lap 12 19:01:17 ghost kernel: Console: switching to colour dummy device 80x25
Lap 12 19:01:17 ghost kernel: ACPI: Battery Slot [BAT0] (battery present)
Lap 12 19:01:17 ghost kernel: [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Lap 12 19:01:17 ghost kernel: [drm] Driver supports precise vblank timestamp query.
Lap 12 19:01:17 ghost kernel: vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Lap 12 19:01:17 ghost kernel: fbcon: inteldrmfb (fb0) is primary device
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0: autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0:    hp_outs=1 (0xb/0x0/0x0/0x0/0x0)
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0:    mono: mono_out=0x0
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0:    inputs:
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0:      Internal Mic=0x11
Lap 12 19:01:17 ghost kernel: sound hdaudioC0D0:      Mic=0xc
Lap 12 19:01:17 ghost kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Lap 12 19:01:17 ghost kernel: r8169 0000:04:00.0: can't disable ASPM; OS doesn't have ASPM control
Lap 12 19:01:17 ghost kernel: r8169 0000:04:00.0 eth0: RTL8168evl/8111evl at 0xffffc900006fa000, b4:b5:2f:84:6f:3e, XID 0c900880 IRQ 33
Lap 12 19:01:17 ghost kernel: r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
Lap 12 19:01:17 ghost kernel: cfg80211: Calling CRDA to update world regulatory domain
Lap 12 19:01:17 ghost kernel: input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/hdaudioC0D0/input9
Lap 12 19:01:17 ghost kernel: input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
Lap 12 19:01:17 ghost kernel: input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
Lap 12 19:01:17 ghost kernel: input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Lap 12 19:01:17 ghost kernel: thermal LNXTHERM:01: registered as thermal_zone1
Lap 12 19:01:17 ghost kernel: ACPI: Thermal Zone [GFXZ] (0 C)
Lap 12 19:01:17 ghost kernel: rt2800pci 0000:03:00.0: enabling device (0000 -> 0002)
Lap 12 19:01:17 ghost kernel: ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3290, rev 0015 detected
Lap 12 19:01:17 ghost kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 3290 detected
Lap 12 19:01:17 ghost kernel: Console: switching to colour frame buffer device 170x48
Lap 12 19:01:17 ghost kernel: i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
Lap 12 19:01:17 ghost kernel: i915 0000:00:02.0: registered panic notifier
Lap 12 19:01:17 ghost kernel: ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Lap 12 19:01:17 ghost kernel: microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
Lap 12 19:01:17 ghost kernel: microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
Lap 12 19:01:17 ghost kernel: microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
Lap 12 19:01:17 ghost kernel: microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
Lap 12 19:01:17 ghost kernel: microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Lap 12 19:01:18 ghost kernel: thermal LNXTHERM:02: registered as thermal_zone2
Lap 12 19:01:18 ghost kernel: ACPI: Thermal Zone [EXTZ] (42 C)
Lap 12 19:01:18 ghost kernel: thermal LNXTHERM:03: registered as thermal_zone3
Lap 12 19:01:18 ghost kernel: ACPI: Thermal Zone [LOCZ] (51 C)
Lap 12 19:01:18 ghost kernel: input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input17
Lap 12 19:01:18 ghost kernel: ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Lap 12 19:01:18 ghost kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input18
Lap 12 19:01:18 ghost kernel: [drm] Initialized i915 1.6.0 20141107 for 0000:00:02.0 on minor 0
Lap 12 19:01:18 ghost kernel: thermal LNXTHERM:04: registered as thermal_zone4
Lap 12 19:01:18 ghost kernel: ACPI: Thermal Zone [BATZ] (26 C)
Lap 12 19:01:18 ghost kernel: thermal LNXTHERM:05: registered as thermal_zone5
Lap 12 19:01:18 ghost kernel: ACPI: Thermal Zone [PCHZ] (0 C)
Lap 12 19:01:18 ghost kernel: r8169 0000:04:00.0 enp4s0: renamed from eth0
Lap 12 19:01:18 ghost kernel: rt2800pci 0000:03:00.0 wlo1: renamed from wlan0
Lap 12 19:01:18 ghost kernel: ppdev: user-space parallel port driver
Lap 12 19:01:18 ghost kernel: intel_rapl: Found RAPL domain package
Lap 12 19:01:18 ghost kernel: intel_rapl: Found RAPL domain core
Lap 12 19:01:18 ghost kernel: intel_rapl: Found RAPL domain uncore
Lap 12 19:01:18 ghost kernel: iTCO_vendor_support: vendor-support=0
Lap 12 19:01:18 ghost kernel: input: HP WMI hotkeys as /devices/virtual/input/input19
Lap 12 19:01:18 ghost kernel: psmouse serio4: synaptics: Touchpad model: 1, fw: 7.5, id: 0x1e0b1, caps: 0xf00473/0x640000/0xa2400, board id: 1397, fw id: 958907
Lap 12 19:01:18 ghost kernel: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input16
Lap 12 19:01:18 ghost kernel: mousedev: PS/2 mouse device common for all mice
Lap 12 19:01:19 ghost kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
Lap 12 19:01:19 ghost kernel: iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
Lap 12 19:01:19 ghost kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Lap 12 19:01:19 ghost kernel: Adding 4194300k swap on /dev/mapper/lvm-swap.  Priority:-1 extents:1 across:4194300k FS
Lap 12 19:01:20 ghost kernel: EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: data=ordered
Lap 12 19:01:24 ghost kernel: media: Linux media interface: v0.10
Lap 12 19:01:24 ghost kernel: Linux video capture interface: v2.00
Lap 12 19:01:24 ghost kernel: Bluetooth: Core ver 2.19
Lap 12 19:01:24 ghost kernel: NET: Registered protocol family 31
Lap 12 19:01:24 ghost kernel: Bluetooth: HCI device and connection manager initialized
Lap 12 19:01:24 ghost kernel: Bluetooth: HCI socket layer initialized
Lap 12 19:01:24 ghost kernel: Bluetooth: L2CAP socket layer initialized
Lap 12 19:01:24 ghost kernel: Bluetooth: SCO socket layer initialized
Lap 12 19:01:26 ghost kernel: r8169 0000:04:00.0 enp4s0: link down
Lap 12 19:01:26 ghost kernel: ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt3290.bin'
Lap 12 19:01:26 ghost kernel: ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.37
Lap 12 19:01:28 ghost kernel: wlo1: authenticate with 00:25:53:b3:72:6e
Lap 12 19:01:28 ghost kernel: wlo1: send auth to 00:25:53:b3:72:6e (try 1/3)
Lap 12 19:01:28 ghost kernel: wlo1: authenticated
Lap 12 19:01:28 ghost kernel: rt2800pci 0000:03:00.0 wlo1: disabling HT/VHT due to WEP/TKIP use
Lap 12 19:01:28 ghost kernel: rt2800pci 0000:03:00.0 wlo1: disabling HT as WMM/QoS is not supported by the AP
Lap 12 19:01:28 ghost kernel: rt2800pci 0000:03:00.0 wlo1: disabling VHT as WMM/QoS is not supported by the AP
Lap 12 19:01:28 ghost kernel: wlo1: associate with 00:25:53:b3:72:6e (try 1/3)
Lap 12 19:01:28 ghost kernel: wlo1: RX AssocResp from 00:25:53:b3:72:6e (capab=0x411 status=0 aid=1)
Lap 12 19:01:28 ghost kernel: wlo1: associated
Lap 12 19:01:36 ghost kernel: fuse init (API version 7.23)
Lap 12 19:02:00 ghost kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [gvfsd-fuse:6523]
Lap 12 19:02:00 ghost kernel: Modules linked in: fuse bluetooth videodev media msr nls_iso8859_1 nls_cp437 vfat joydev iTCO_wdt mousedev coretemp fat hwmon iTCO_vendor_support intel_rapl x86_pkg_temp_thermal ppdev hp_wmi sparse_keymap intel_powerclamp kvm_intel kvm microcode arc4 psmouse rt2800pci eeprom_93cx6 rt2x00pci rt2800mmio rt2x00mmio rt2800lib rt2x00lib mac80211 evdev mac_hid serio_raw cfg80211 r8169 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic i915 jmb38x_ms mii memstick rfkill crc_ccitt i2c_algo_bit snd_hda_intel drm_kms_helper snd_hda_controller tpm_tis drm snd_hda_codec battery i2c_core tpm snd_hwdep wmi thermal lpc_ich snd_pcm snd_timer intel_gtt parport_pc shpchp parport hp_accel video mfd_core hp_wireless button processor mei_me mei snd soundcore lis3lv02d input_polldev ac ext4 crc16 mbcache
Lap 12 19:02:00 ghost kernel:  jbd2 algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crc32_pclmul ahci crc32c_intel libahci ghash_clmulni_intel atkbd libata libps2 aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper sdhci_pci ehci_pci xhci_pci cryptd xhci_hcd ehci_hcd scsi_mod sdhci mmc_core usbcore usb_common i8042 serio
Lap 12 19:02:00 ghost kernel: CPU: 0 PID: 6523 Comm: gvfsd-fuse Not tainted 3.18.0-rc4-next-20141112-dirty #51
Lap 12 19:02:00 ghost kernel: Hardware name: Hewlett-Packard HP ProBook 4540s/17F6, BIOS 68IRR Ver. F.32 11/06/2012
Lap 12 19:02:00 ghost kernel: task: ffff8800b51144b0 ti: ffff880139e08000 task.ti: ffff880139e08000
Lap 12 19:02:00 ghost kernel: RIP: 0010:[<ffffffff81523f07>]  [<ffffffff81523f07>] _raw_spin_lock+0x37/0x40
Lap 12 19:02:00 ghost kernel: RSP: 0018:ffff880139e0be78  EFLAGS: 00000206
Lap 12 19:02:00 ghost kernel: RAX: 0000000000006463 RBX: 0000000400000001 RCX: 0000000000000000
Lap 12 19:02:00 ghost kernel: RDX: 00000000000000e5 RSI: ffff880136403900 RDI: ffffffffa07a6000
Lap 12 19:02:00 ghost kernel: RBP: ffff880139e0be78 R08: 0000000000000000 R09: 0000000000000000
Lap 12 19:02:00 ghost kernel: R10: ffff880136403910 R11: 0000000000000246 R12: ffff8800b86afcc0
Lap 12 19:02:00 ghost kernel: R13: 0000000000000000 R14: ffff8800b75e402e R15: 0000000478863266
Lap 12 19:02:00 ghost kernel: FS:  00007f328b5e6700(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
Lap 12 19:02:00 ghost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Lap 12 19:02:00 ghost kernel: CR2: 00007fd6f4001598 CR3: 000000007fac5000 CR4: 00000000001407f0
Lap 12 19:02:00 ghost kernel: Stack:
Lap 12 19:02:00 ghost kernel:  ffff880139e0be98 ffffffffa0797a92 ffff88007f9aa020 ffff880136403900
Lap 12 19:02:00 ghost kernel:  ffff880139e0bee8 ffffffff811c2fef ffff880139e0bef8 ffff880136403910
Lap 12 19:02:00 ghost kernel:  ffff8800b51144b0 0000000000000000 ffffffff81a48b60 ffff8800b5114be8
Lap 12 19:02:00 ghost kernel: Call Trace:
Lap 12 19:02:00 ghost kernel:  [<ffffffffa0797a92>] fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:02:00 ghost kernel:  [<ffffffff811c2fef>] __fput+0x9f/0x200
Lap 12 19:02:00 ghost kernel:  [<ffffffff811c319e>] ____fput+0xe/0x10
Lap 12 19:02:00 ghost kernel:  [<ffffffff8108bfff>] task_work_run+0x9f/0xe0
Lap 12 19:02:00 ghost kernel:  [<ffffffff81014e45>] do_notify_resume+0x95/0xa0
Lap 12 19:02:00 ghost kernel:  [<ffffffff81524b60>] int_signal+0x12/0x17
Lap 12 19:02:00 ghost kernel: Code: 7e 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 cc 38 c1 75 07 5d c3 0f 1f 44 00 00 b8 00 80 00 00 eb 08 90 f3 90 83 e8 01 74 f1 <0f> b6 17 38 ca 75 f2 5d c3 0f 1f 44 00 00 55 48 89 e5 9c 58 0f 
Lap 12 19:02:28 ghost kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [gvfsd-fuse:6523]
Lap 12 19:02:28 ghost kernel: Modules linked in: fuse bluetooth videodev media msr nls_iso8859_1 nls_cp437 vfat joydev iTCO_wdt mousedev coretemp fat hwmon iTCO_vendor_support intel_rapl x86_pkg_temp_thermal ppdev hp_wmi sparse_keymap intel_powerclamp kvm_intel kvm microcode arc4 psmouse rt2800pci eeprom_93cx6 rt2x00pci rt2800mmio rt2x00mmio rt2800lib rt2x00lib mac80211 evdev mac_hid serio_raw cfg80211 r8169 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic i915 jmb38x_ms mii memstick rfkill crc_ccitt i2c_algo_bit snd_hda_intel drm_kms_helper snd_hda_controller tpm_tis drm snd_hda_codec battery i2c_core tpm snd_hwdep wmi thermal lpc_ich snd_pcm snd_timer intel_gtt parport_pc shpchp parport hp_accel video mfd_core hp_wireless button processor mei_me mei snd soundcore lis3lv02d input_polldev ac ext4 crc16 mbcache
Lap 12 19:02:28 ghost kernel:  jbd2 algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crc32_pclmul ahci crc32c_intel libahci ghash_clmulni_intel atkbd libata libps2 aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper sdhci_pci ehci_pci xhci_pci cryptd xhci_hcd ehci_hcd scsi_mod sdhci mmc_core usbcore usb_common i8042 serio
Lap 12 19:02:28 ghost kernel: CPU: 0 PID: 6523 Comm: gvfsd-fuse Tainted: G             L 3.18.0-rc4-next-20141112-dirty #51
Lap 12 19:02:28 ghost kernel: Hardware name: Hewlett-Packard HP ProBook 4540s/17F6, BIOS 68IRR Ver. F.32 11/06/2012
Lap 12 19:02:28 ghost kernel: task: ffff8800b51144b0 ti: ffff880139e08000 task.ti: ffff880139e08000
Lap 12 19:02:28 ghost kernel: RIP: 0010:[<ffffffff81523f02>]  [<ffffffff81523f02>] _raw_spin_lock+0x32/0x40
Lap 12 19:02:28 ghost kernel: RSP: 0018:ffff880139e0be78  EFLAGS: 00000282
Lap 12 19:02:28 ghost kernel: RAX: 00000000000002bc RBX: 0000000400000001 RCX: 0000000000000000
Lap 12 19:02:28 ghost kernel: RDX: 00000000000000e5 RSI: ffff880136403900 RDI: ffffffffa07a6000
Lap 12 19:02:28 ghost kernel: RBP: ffff880139e0be78 R08: 0000000000000000 R09: 0000000000000000
Lap 12 19:02:28 ghost kernel: R10: ffff880136403910 R11: 0000000000000246 R12: ffff8800b86afcc0
Lap 12 19:02:28 ghost kernel: R13: 0000000000000000 R14: ffff8800b75e402e R15: 0000000478863266
Lap 12 19:02:28 ghost kernel: FS:  00007f328b5e6700(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
Lap 12 19:02:28 ghost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Lap 12 19:02:28 ghost kernel: CR2: 00007fd6f4001598 CR3: 000000007fac5000 CR4: 00000000001407f0
Lap 12 19:02:28 ghost kernel: Stack:
Lap 12 19:02:28 ghost kernel:  ffff880139e0be98 ffffffffa0797a92 ffff88007f9aa020 ffff880136403900
Lap 12 19:02:28 ghost kernel:  ffff880139e0bee8 ffffffff811c2fef ffff880139e0bef8 ffff880136403910
Lap 12 19:02:28 ghost kernel:  ffff8800b51144b0 0000000000000000 ffffffff81a48b60 ffff8800b5114be8
Lap 12 19:02:28 ghost kernel: Call Trace:
Lap 12 19:02:28 ghost kernel:  [<ffffffffa0797a92>] fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:02:28 ghost kernel:  [<ffffffff811c2fef>] __fput+0x9f/0x200
Lap 12 19:02:28 ghost kernel:  [<ffffffff811c319e>] ____fput+0xe/0x10
Lap 12 19:02:28 ghost kernel:  [<ffffffff8108bfff>] task_work_run+0x9f/0xe0
Lap 12 19:02:28 ghost kernel:  [<ffffffff81014e45>] do_notify_resume+0x95/0xa0
Lap 12 19:02:28 ghost kernel:  [<ffffffff81524b60>] int_signal+0x12/0x17
Lap 12 19:02:28 ghost kernel: Code: ff 05 43 8a ae 7e 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 cc 38 c1 75 07 5d c3 0f 1f 44 00 00 b8 00 80 00 00 eb 08 90 f3 90 <83> e8 01 74 f1 0f b6 17 38 ca 75 f2 5d c3 0f 1f 44 00 00 55 48 
Lap 12 19:03:00 ghost kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [gvfsd-fuse:6523]
Lap 12 19:03:12 ghost kernel: Modules linked in: fuse bluetooth videodev media msr nls_iso8859_1 nls_cp437 vfat joydev iTCO_wdt mousedev coretemp fat hwmon iTCO_vendor_support intel_rapl x86_pkg_temp_thermal ppdev hp_wmi sparse_keymap intel_powerclamp kvm_intel kvm microcode arc4 psmouse rt2800pci eeprom_93cx6 rt2x00pci rt2800mmio rt2x00mmio rt2800lib rt2x00lib mac80211 evdev mac_hid serio_raw cfg80211 r8169 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic i915 jmb38x_ms mii memstick rfkill crc_ccitt i2c_algo_bit snd_hda_intel drm_kms_helper snd_hda_controller tpm_tis drm snd_hda_codec battery i2c_core tpm snd_hwdep wmi thermal lpc_ich snd_pcm snd_timer intel_gtt parport_pc shpchp parport hp_accel video mfd_core hp_wireless button processor mei_me mei snd soundcore lis3lv02d input_polldev ac ext4 crc16 mbcache
Lap 12 19:03:12 ghost kernel:  jbd2 algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crc32_pclmul ahci crc32c_intel libahci ghash_clmulni_intel atkbd libata libps2 aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper sdhci_pci ehci_pci xhci_pci cryptd xhci_hcd ehci_hcd scsi_mod sdhci mmc_core usbcore usb_common i8042 serio
Lap 12 19:03:12 ghost kernel: CPU: 0 PID: 6523 Comm: gvfsd-fuse Tainted: G             L 3.18.0-rc4-next-20141112-dirty #51
Lap 12 19:03:12 ghost kernel: Hardware name: Hewlett-Packard HP ProBook 4540s/17F6, BIOS 68IRR Ver. F.32 11/06/2012
Lap 12 19:03:12 ghost kernel: task: ffff8800b51144b0 ti: ffff880139e08000 task.ti: ffff880139e08000
Lap 12 19:03:12 ghost kernel: RIP: 0010:[<ffffffff81523f02>]  [<ffffffff81523f02>] _raw_spin_lock+0x32/0x40
Lap 12 19:03:12 ghost kernel: RSP: 0018:ffff880139e0be78  EFLAGS: 00000282
Lap 12 19:03:12 ghost kernel: RAX: 000000000000452f RBX: 0000000400000001 RCX: 0000000000000000
Lap 12 19:03:12 ghost kernel: RDX: 00000000000000e5 RSI: ffff880136403900 RDI: ffffffffa07a6000
Lap 12 19:03:12 ghost kernel: RBP: ffff880139e0be78 R08: 0000000000000000 R09: 0000000000000000
Lap 12 19:03:12 ghost kernel: R10: ffff880136403910 R11: 0000000000000246 R12: ffff8800b86afcc0
Lap 12 19:03:12 ghost kernel: R13: 0000000000000000 R14: ffff8800b75e402e R15: 0000000478863266
Lap 12 19:03:12 ghost kernel: FS:  00007f328b5e6700(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
Lap 12 19:03:12 ghost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Lap 12 19:03:12 ghost kernel: CR2: 00007fd6f4001598 CR3: 000000007fac5000 CR4: 00000000001407f0
Lap 12 19:03:12 ghost kernel: Stack:
Lap 12 19:03:12 ghost kernel:  ffff880139e0be98 ffffffffa0797a92 ffff88007f9aa020 ffff880136403900
Lap 12 19:03:12 ghost kernel:  ffff880139e0bee8 ffffffff811c2fef ffff880139e0bef8 ffff880136403910
Lap 12 19:03:12 ghost kernel:  ffff8800b51144b0 0000000000000000 ffffffff81a48b60 ffff8800b5114be8
Lap 12 19:03:12 ghost kernel: Call Trace:
Lap 12 19:03:12 ghost kernel:  [<ffffffffa0797a92>] fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:03:12 ghost kernel:  [<ffffffff811c2fef>] __fput+0x9f/0x200
Lap 12 19:03:12 ghost kernel:  [<ffffffff811c319e>] ____fput+0xe/0x10
Lap 12 19:03:12 ghost kernel:  [<ffffffff8108bfff>] task_work_run+0x9f/0xe0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81014e45>] do_notify_resume+0x95/0xa0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81524b60>] int_signal+0x12/0x17
Lap 12 19:03:12 ghost kernel: Code: ff 05 43 8a ae 7e 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 cc 38 c1 75 07 5d c3 0f 1f 44 00 00 b8 00 80 00 00 eb 08 90 f3 90 <83> e8 01 74 f1 0f b6 17 38 ca 75 f2 5d c3 0f 1f 44 00 00 55 48 
Lap 12 19:03:12 ghost kernel: INFO: rcu_sched self-detected stall on CPU { 0}  (t=18000 jiffies g=-259 c=-260 q=1)
Lap 12 19:03:12 ghost kernel: Task dump for CPU 0:
Lap 12 19:03:12 ghost kernel: gvfsd-fuse      R  running task        0  6523      1 0x00000008
Lap 12 19:03:12 ghost kernel:  ffff8800b51144b0 00000000a137f01e ffff88013fa03d68 ffffffff8109aee6
Lap 12 19:03:12 ghost kernel:  0000000000000000 ffffffff81853780 ffff88013fa03d88 ffffffff8109e6cd
Lap 12 19:03:12 ghost kernel:  ffff88013fa03d88 0000000000000001 ffff88013fa03db8 ffffffff810cf791
Lap 12 19:03:12 ghost kernel: Call Trace:
Lap 12 19:03:12 ghost kernel:  <IRQ>  [<ffffffff8109aee6>] sched_show_task+0xb6/0x120
Lap 12 19:03:12 ghost kernel:  [<ffffffff8109e6cd>] dump_cpu_task+0x3d/0x50
Lap 12 19:03:12 ghost kernel:  [<ffffffff810cf791>] rcu_dump_cpu_stacks+0x91/0xd0
Lap 12 19:03:12 ghost kernel:  [<ffffffff810d395c>] rcu_check_callbacks+0x4cc/0x780
Lap 12 19:03:12 ghost kernel:  [<ffffffff8109f760>] ? account_process_tick+0x60/0x170
Lap 12 19:03:12 ghost kernel:  [<ffffffff810d8b69>] update_process_times+0x39/0x60
Lap 12 19:03:12 ghost kernel:  [<ffffffff810e8025>] tick_sched_handle.isra.16+0x25/0x60
Lap 12 19:03:12 ghost kernel:  [<ffffffff810e80a4>] tick_sched_timer+0x44/0x80
Lap 12 19:03:12 ghost kernel:  [<ffffffff810d9107>] __run_hrtimer+0x77/0x250
Lap 12 19:03:12 ghost kernel:  [<ffffffff810e8060>] ? tick_sched_handle.isra.16+0x60/0x60
Lap 12 19:03:12 ghost kernel:  [<ffffffff810d9ce7>] hrtimer_interrupt+0x107/0x260
Lap 12 19:03:12 ghost kernel:  [<ffffffff8104913c>] local_apic_timer_interrupt+0x3c/0x70
Lap 12 19:03:12 ghost kernel:  [<ffffffff81527421>] smp_apic_timer_interrupt+0x41/0x60
Lap 12 19:03:12 ghost kernel:  [<ffffffff8152570d>] apic_timer_interrupt+0x6d/0x80
Lap 12 19:03:12 ghost kernel:  <EOI>  [<ffffffff81523f0a>] ? _raw_spin_lock+0x3a/0x40
Lap 12 19:03:12 ghost kernel:  [<ffffffffa0797a92>] fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:03:12 ghost kernel:  [<ffffffff811c2fef>] __fput+0x9f/0x200
Lap 12 19:03:12 ghost kernel:  [<ffffffff811c319e>] ____fput+0xe/0x10
Lap 12 19:03:12 ghost kernel:  [<ffffffff8108bfff>] task_work_run+0x9f/0xe0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81014e45>] do_notify_resume+0x95/0xa0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81524b60>] int_signal+0x12/0x17
Lap 12 19:03:12 ghost kernel: INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 3, t=18006 jiffies, g=-259, c=-260, q=1)
Lap 12 19:03:12 ghost kernel: Task dump for CPU 0:
Lap 12 19:03:12 ghost kernel: gvfsd-fuse      R  running task        0  6523      1 0x00000008
Lap 12 19:03:12 ghost kernel:  ffffffff81520296 ffff8800b51144b0 0000000000014180 ffff880139e0bfd8
Lap 12 19:03:12 ghost kernel:  0000000000014180 ffff88013ab275c0 ffff8800b51144b0 ffff88007fbf3c00
Lap 12 19:03:12 ghost kernel:  0000000000000018 ffff88007fbf2c00 ffff88007fa1c518 ffff88013fad4180
Lap 12 19:03:12 ghost kernel: Call Trace:
Lap 12 19:03:12 ghost kernel:  [<ffffffff81520296>] ? __schedule+0x3b6/0xa10
Lap 12 19:03:12 ghost kernel:  [<ffffffff810a8008>] ? enqueue_task_fair+0x128/0x5d0
Lap 12 19:03:12 ghost kernel:  [<ffffffff8109f045>] ? sched_clock_cpu+0xb5/0xe0
Lap 12 19:03:12 ghost kernel:  [<ffffffff8109876a>] ? check_preempt_curr+0x5a/0xa0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81520919>] ? schedule+0x29/0x70
Lap 12 19:03:12 ghost kernel:  [<ffffffff8152353c>] ? schedule_timeout+0x1bc/0x250
Lap 12 19:03:12 ghost kernel:  [<ffffffff8109b867>] ? wake_up_process+0x27/0x50
Lap 12 19:03:12 ghost kernel:  [<ffffffff810b02b8>] ? __wake_up+0x48/0x60
Lap 12 19:03:12 ghost kernel:  [<ffffffff810843e8>] ? call_usermodehelper_exec+0xb8/0x160
Lap 12 19:03:12 ghost kernel:  [<ffffffff81084648>] ? __request_module+0x1b8/0x2d0
Lap 12 19:03:12 ghost kernel:  [<ffffffff8126052c>] ? security_inode_permission+0x1c/0x30
Lap 12 19:03:12 ghost kernel:  [<ffffffff811cc075>] ? __inode_permission+0x45/0xd0
Lap 12 19:03:12 ghost kernel:  [<ffffffff811cc118>] ? inode_permission+0x18/0x50
Lap 12 19:03:12 ghost kernel:  [<ffffffff811cdefe>] ? link_path_walk+0x27e/0x9b0
Lap 12 19:03:12 ghost kernel:  [<ffffffff811cd913>] ? lookup_fast+0x53/0x300
Lap 12 19:03:12 ghost kernel:  [<ffffffff811cb288>] ? complete_walk+0x68/0x110
Lap 12 19:03:12 ghost kernel:  [<ffffffff811ce6aa>] ? path_lookupat+0x7a/0x850
Lap 12 19:03:12 ghost kernel:  [<ffffffff811d1ebe>] ? user_path_at_empty+0x6e/0xd0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81523f0a>] ? _raw_spin_lock+0x3a/0x40
Lap 12 19:03:12 ghost kernel:  [<ffffffffa0797a92>] ? fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:03:12 ghost kernel:  [<ffffffff811c2fef>] ? __fput+0x9f/0x200
Lap 12 19:03:12 ghost kernel:  [<ffffffff811c319e>] ? ____fput+0xe/0x10
Lap 12 19:03:12 ghost kernel:  [<ffffffff8108bfff>] ? task_work_run+0x9f/0xe0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81014e45>] ? do_notify_resume+0x95/0xa0
Lap 12 19:03:12 ghost kernel:  [<ffffffff81524b60>] ? int_signal+0x12/0x17
Lap 12 19:03:24 ghost kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [gvfsd-fuse:6523]
Lap 12 19:03:24 ghost kernel: Modules linked in: fuse bluetooth videodev media msr nls_iso8859_1 nls_cp437 vfat joydev iTCO_wdt mousedev coretemp fat hwmon iTCO_vendor_support intel_rapl x86_pkg_temp_thermal ppdev hp_wmi sparse_keymap intel_powerclamp kvm_intel kvm microcode arc4 psmouse rt2800pci eeprom_93cx6 rt2x00pci rt2800mmio rt2x00mmio rt2800lib rt2x00lib mac80211 evdev mac_hid serio_raw cfg80211 r8169 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic i915 jmb38x_ms mii memstick rfkill crc_ccitt i2c_algo_bit snd_hda_intel drm_kms_helper snd_hda_controller tpm_tis drm snd_hda_codec battery i2c_core tpm snd_hwdep wmi thermal lpc_ich snd_pcm snd_timer intel_gtt parport_pc shpchp parport hp_accel video mfd_core hp_wireless button processor mei_me mei snd soundcore lis3lv02d input_polldev ac ext4 crc16 mbcache
Lap 12 19:03:24 ghost kernel:  jbd2 algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crc32_pclmul ahci crc32c_intel libahci ghash_clmulni_intel atkbd libata libps2 aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper sdhci_pci ehci_pci xhci_pci cryptd xhci_hcd ehci_hcd scsi_mod sdhci mmc_core usbcore usb_common i8042 serio
Lap 12 19:03:24 ghost kernel: CPU: 0 PID: 6523 Comm: gvfsd-fuse Tainted: G             L 3.18.0-rc4-next-20141112-dirty #51
Lap 12 19:03:24 ghost kernel: Hardware name: Hewlett-Packard HP ProBook 4540s/17F6, BIOS 68IRR Ver. F.32 11/06/2012
Lap 12 19:03:24 ghost kernel: task: ffff8800b51144b0 ti: ffff880139e08000 task.ti: ffff880139e08000
Lap 12 19:03:24 ghost kernel: RIP: 0010:[<ffffffff81523f07>]  [<ffffffff81523f07>] _raw_spin_lock+0x37/0x40
Lap 12 19:03:24 ghost kernel: RSP: 0018:ffff880139e0be78  EFLAGS: 00000202
Lap 12 19:03:24 ghost kernel: RAX: 0000000000001629 RBX: 0000000400000001 RCX: 0000000000000000
Lap 12 19:03:24 ghost kernel: RDX: 00000000000000e5 RSI: ffff880136403900 RDI: ffffffffa07a6000
Lap 12 19:03:24 ghost kernel: RBP: ffff880139e0be78 R08: 0000000000000000 R09: 0000000000000000
Lap 12 19:03:24 ghost kernel: R10: ffff880136403910 R11: 0000000000000246 R12: ffff8800b86afcc0
Lap 12 19:03:24 ghost kernel: R13: 0000000000000000 R14: ffff8800b75e402e R15: 0000000478863266
Lap 12 19:03:24 ghost kernel: FS:  00007f328b5e6700(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
Lap 12 19:03:24 ghost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Lap 12 19:03:24 ghost kernel: CR2: 00007fd6f4001598 CR3: 000000007fac5000 CR4: 00000000001407f0
Lap 12 19:03:24 ghost kernel: Stack:
Lap 12 19:03:24 ghost kernel:  ffff880139e0be98 ffffffffa0797a92 ffff88007f9aa020 ffff880136403900
Lap 12 19:03:24 ghost kernel:  ffff880139e0bee8 ffffffff811c2fef ffff880139e0bef8 ffff880136403910
Lap 12 19:03:24 ghost kernel:  ffff8800b51144b0 0000000000000000 ffffffff81a48b60 ffff8800b5114be8
Lap 12 19:03:24 ghost kernel: Call Trace:
Lap 12 19:03:24 ghost kernel:  [<ffffffffa0797a92>] fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:03:24 ghost kernel:  [<ffffffff811c2fef>] __fput+0x9f/0x200
Lap 12 19:03:24 ghost kernel:  [<ffffffff811c319e>] ____fput+0xe/0x10
Lap 12 19:03:24 ghost kernel:  [<ffffffff8108bfff>] task_work_run+0x9f/0xe0
Lap 12 19:03:24 ghost kernel:  [<ffffffff81014e45>] do_notify_resume+0x95/0xa0
Lap 12 19:03:24 ghost kernel:  [<ffffffff81524b60>] int_signal+0x12/0x17
Lap 12 19:03:24 ghost kernel: Code: 7e 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 cc 38 c1 75 07 5d c3 0f 1f 44 00 00 b8 00 80 00 00 eb 08 90 f3 90 83 e8 01 74 f1 <0f> b6 17 38 ca 75 f2 5d c3 0f 1f 44 00 00 55 48 89 e5 9c 58 0f 
Lap 12 19:03:52 ghost kernel: NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [gvfsd-fuse:6523]
Lap 12 19:03:52 ghost kernel: Modules linked in: fuse bluetooth videodev media msr nls_iso8859_1 nls_cp437 vfat joydev iTCO_wdt mousedev coretemp fat hwmon iTCO_vendor_support intel_rapl x86_pkg_temp_thermal ppdev hp_wmi sparse_keymap intel_powerclamp kvm_intel kvm microcode arc4 psmouse rt2800pci eeprom_93cx6 rt2x00pci rt2800mmio rt2x00mmio rt2800lib rt2x00lib mac80211 evdev mac_hid serio_raw cfg80211 r8169 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic i915 jmb38x_ms mii memstick rfkill crc_ccitt i2c_algo_bit snd_hda_intel drm_kms_helper snd_hda_controller tpm_tis drm snd_hda_codec battery i2c_core tpm snd_hwdep wmi thermal lpc_ich snd_pcm snd_timer intel_gtt parport_pc shpchp parport hp_accel video mfd_core hp_wireless button processor mei_me mei snd soundcore lis3lv02d input_polldev ac ext4 crc16 mbcache
Lap 12 19:03:52 ghost kernel:  jbd2 algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crc32_pclmul ahci crc32c_intel libahci ghash_clmulni_intel atkbd libata libps2 aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper sdhci_pci ehci_pci xhci_pci cryptd xhci_hcd ehci_hcd scsi_mod sdhci mmc_core usbcore usb_common i8042 serio
Lap 12 19:03:52 ghost kernel: CPU: 0 PID: 6523 Comm: gvfsd-fuse Tainted: G             L 3.18.0-rc4-next-20141112-dirty #51
Lap 12 19:03:52 ghost kernel: Hardware name: Hewlett-Packard HP ProBook 4540s/17F6, BIOS 68IRR Ver. F.32 11/06/2012
Lap 12 19:03:52 ghost kernel: task: ffff8800b51144b0 ti: ffff880139e08000 task.ti: ffff880139e08000
Lap 12 19:03:52 ghost kernel: RIP: 0010:[<ffffffff81523f07>]  [<ffffffff81523f07>] _raw_spin_lock+0x37/0x40
Lap 12 19:03:52 ghost kernel: RSP: 0018:ffff880139e0be78  EFLAGS: 00000202
Lap 12 19:03:52 ghost kernel: RAX: 0000000000000c52 RBX: 0000000400000001 RCX: 0000000000000000
Lap 12 19:03:52 ghost kernel: RDX: 00000000000000e5 RSI: ffff880136403900 RDI: ffffffffa07a6000
Lap 12 19:03:52 ghost kernel: RBP: ffff880139e0be78 R08: 0000000000000000 R09: 0000000000000000
Lap 12 19:03:52 ghost kernel: R10: ffff880136403910 R11: 0000000000000246 R12: ffff8800b86afcc0
Lap 12 19:03:52 ghost kernel: R13: 0000000000000000 R14: ffff8800b75e402e R15: 0000000478863266
Lap 12 19:03:52 ghost kernel: FS:  00007f328b5e6700(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
Lap 12 19:03:52 ghost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Lap 12 19:03:52 ghost kernel: CR2: 00007fd6f4001598 CR3: 000000007fac5000 CR4: 00000000001407f0
Lap 12 19:03:52 ghost kernel: Stack:
Lap 12 19:03:52 ghost kernel:  ffff880139e0be98 ffffffffa0797a92 ffff88007f9aa020 ffff880136403900
Lap 12 19:03:52 ghost kernel:  ffff880139e0bee8 ffffffff811c2fef ffff880139e0bef8 ffff880136403910
Lap 12 19:03:52 ghost kernel:  ffff8800b51144b0 0000000000000000 ffffffff81a48b60 ffff8800b5114be8
Lap 12 19:03:52 ghost kernel: Call Trace:
Lap 12 19:03:52 ghost kernel:  [<ffffffffa0797a92>] fuse_dev_release+0x22/0x80 [fuse]
Lap 12 19:03:52 ghost kernel:  [<ffffffff811c2fef>] __fput+0x9f/0x200
Lap 12 19:03:52 ghost kernel:  [<ffffffff811c319e>] ____fput+0xe/0x10
Lap 12 19:03:52 ghost kernel:  [<ffffffff8108bfff>] task_work_run+0x9f/0xe0
Lap 12 19:03:52 ghost kernel:  [<ffffffff81014e45>] do_notify_resume+0x95/0xa0
Lap 12 19:03:52 ghost kernel:  [<ffffffff81524b60>] int_signal+0x12/0x17
Lap 12 19:03:52 ghost kernel: Code: 7e 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 cc 38 c1 75 07 5d c3 0f 1f 44 00 00 b8 00 80 00 00 eb 08 90 f3 90 83 e8 01 74 f1 <0f> b6 17 38 ca 75 f2 5d c3 0f 1f 44 00 00 55 48 89 e5 9c 58 0f 
Lap 12 19:04:10 ghost kernel: SysRq : Kill All Tasks
Lap 12 19:04:11 ghost kernel: SysRq : Emergency Sync
Lap 12 19:04:11 ghost kernel: Emergency Sync complete
