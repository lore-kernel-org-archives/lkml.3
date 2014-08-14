Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaHNLAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:00:11 -0400
Received: from mx.ungleich.ch ([77.109.138.221]:46854 "EHLO mx.ungleich.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaHNLAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:00:04 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2014 07:00:03 EDT
Date: Thu, 14 Aug 2014 12:53:51 +0200
From: Nico Schottelius <nico-kernel-2014-08-14@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-kernel-2014-08-14@schottelius.org>
Subject: Linux 3.16: O2 Micro MMC missing in lspci
Message-ID: <20140814105351.GA3110@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-2014-08-14@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: gold (Linux 3.16.0-2-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

when booting into 3.16.0-2-ARCH I miss the following
entry in lspci:

[12:50] gold:debug-sd-card-reader% diff 3.15/lspci 3.16/lspci 
17d16
< 03:00.0 SD Host controller: O2 Micro, Inc. SD/MMC Card Reader
Controller (rev 01)

This causes my system to be unable to mount/see the sd cards.
My hardware is a Dell E7440 notebook.

I attached dmesg & lspci of both kernels.

Anyone an idea on what might be wrong?

The only related issues I found is
    https://bugs.archlinux.org/task/26971

and that there was a change in the mmc area:

    https://lkml.org/lkml/2014/6/10/491

Cheers,

Nico

p.s.: Please cc on reply

-- 
New PGP key: 659B 0D91 E86E 7E24 FD15  69D0 C729 21A1 293F 2D24

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.7-1-ARCH (nobody@var-lib-archbuild-extra-x86_64-thomas) (gcc version 4.9.1 (GCC) ) #1 SMP PREEMPT Mon Jul 28 20:06:17 CEST 2014
[    0.000000] Command line: initrd=\EFI\archiso\archiso.img archisobasedir=arch archisolabel=ARCH_201408
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000004efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000004f000-0x000000000004ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000050000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf64bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf64c000-0x00000000cf652fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf653000-0x00000000d027afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d027b000-0x00000000d0753fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d0754000-0x00000000d7db3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7db4000-0x00000000d7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d8000000-0x00000000d8758fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d8759000-0x00000000d87fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d8800000-0x00000000d8fa9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d8faa000-0x00000000d8ffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d9000000-0x00000000da71bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da71c000-0x00000000da7fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da800000-0x00000000dbd04fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dbd05000-0x00000000dbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd000000-0x00000000df1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021edfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xd8feb000  ACPI=0xd8feb000  SMBIOS=0xf0000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000007000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000007000-0x000000000004f000) (0MB)
[    0.000000] efi: mem03: type=0, attr=0xf, range=[0x000000000004f000-0x0000000000050000) (0MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000000050000-0x000000000009d000) (0MB)
[    0.000000] efi: mem05: type=4, attr=0xf, range=[0x000000000009d000-0x000000000009e000) (0MB)
[    0.000000] efi: mem06: type=0, attr=0xf, range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001f60000) (15MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000001f60000-0x000000007ec62000) (1997MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x000000007ec62000-0x0000000080000000) (19MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x0000000080000000-0x00000000cc776000) (1223MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x00000000cc776000-0x00000000cc876000) (1MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x00000000cc876000-0x00000000ce6ec000) (30MB)
[    0.000000] efi: mem14: type=1, attr=0xf, range=[0x00000000ce6ec000-0x00000000cf64c000) (15MB)
[    0.000000] efi: mem15: type=10, attr=0xf, range=[0x00000000cf64c000-0x00000000cf653000) (0MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x00000000cf653000-0x00000000cf9ed000) (3MB)
[    0.000000] efi: mem17: type=3, attr=0xf, range=[0x00000000cf9ed000-0x00000000d024f000) (8MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000d024f000-0x00000000d0260000) (0MB)
[    0.000000] efi: mem19: type=3, attr=0xf, range=[0x00000000d0260000-0x00000000d0272000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x00000000d0272000-0x00000000d027b000) (0MB)
[    0.000000] efi: mem21: type=6, attr=0x800000000000000f, range=[0x00000000d027b000-0x00000000d0754000) (4MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x00000000d0754000-0x00000000d0766000) (0MB)
[    0.000000] efi: mem23: type=7, attr=0xf, range=[0x00000000d0766000-0x00000000d16c1000) (15MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x00000000d16c1000-0x00000000d2052000) (9MB)
[    0.000000] efi: mem25: type=7, attr=0xf, range=[0x00000000d2052000-0x00000000d20a1000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x00000000d20a1000-0x00000000d21c4000) (1MB)
[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x00000000d21c4000-0x00000000d224b000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x00000000d224b000-0x00000000d242f000) (1MB)
[    0.000000] efi: mem29: type=7, attr=0xf, range=[0x00000000d242f000-0x00000000d2438000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x00000000d2438000-0x00000000d24cd000) (0MB)
[    0.000000] efi: mem31: type=7, attr=0xf, range=[0x00000000d24cd000-0x00000000d24d3000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x00000000d24d3000-0x00000000d2645000) (1MB)
[    0.000000] efi: mem33: type=7, attr=0xf, range=[0x00000000d2645000-0x00000000d2647000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x00000000d2647000-0x00000000d282b000) (1MB)
[    0.000000] efi: mem35: type=7, attr=0xf, range=[0x00000000d282b000-0x00000000d282e000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x00000000d282e000-0x00000000d2b07000) (2MB)
[    0.000000] efi: mem37: type=7, attr=0xf, range=[0x00000000d2b07000-0x00000000d2b0f000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x00000000d2b0f000-0x00000000d2be0000) (0MB)
[    0.000000] efi: mem39: type=7, attr=0xf, range=[0x00000000d2be0000-0x00000000d2be8000) (0MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x00000000d2be8000-0x00000000d2d29000) (1MB)
[    0.000000] efi: mem41: type=7, attr=0xf, range=[0x00000000d2d29000-0x00000000d2d31000) (0MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x00000000d2d31000-0x00000000d2d33000) (0MB)
[    0.000000] efi: mem43: type=7, attr=0xf, range=[0x00000000d2d33000-0x00000000d2d48000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x00000000d2d48000-0x00000000d2d51000) (0MB)
[    0.000000] efi: mem45: type=7, attr=0xf, range=[0x00000000d2d51000-0x00000000d2d53000) (0MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x00000000d2d53000-0x00000000d5000000) (34MB)
[    0.000000] efi: mem47: type=7, attr=0xf, range=[0x00000000d5000000-0x00000000d5908000) (9MB)
[    0.000000] efi: mem48: type=2, attr=0xf, range=[0x00000000d5908000-0x00000000d5909000) (0MB)
[    0.000000] efi: mem49: type=7, attr=0xf, range=[0x00000000d5909000-0x00000000d590a000) (0MB)
[    0.000000] efi: mem50: type=2, attr=0xf, range=[0x00000000d590a000-0x00000000d590b000) (0MB)
[    0.000000] efi: mem51: type=1, attr=0xf, range=[0x00000000d590b000-0x00000000d5922000) (0MB)
[    0.000000] efi: mem52: type=2, attr=0xf, range=[0x00000000d5922000-0x00000000d5924000) (0MB)
[    0.000000] efi: mem53: type=1, attr=0xf, range=[0x00000000d5924000-0x00000000d593f000) (0MB)
[    0.000000] efi: mem54: type=3, attr=0xf, range=[0x00000000d593f000-0x00000000d6000000) (6MB)
[    0.000000] efi: mem55: type=7, attr=0xf, range=[0x00000000d6000000-0x00000000d7db4000) (29MB)
[    0.000000] efi: mem56: type=6, attr=0x800000000000000f, range=[0x00000000d7db4000-0x00000000d8000000) (2MB)
[    0.000000] efi: mem57: type=7, attr=0xf, range=[0x00000000d8000000-0x00000000d8759000) (7MB)
[    0.000000] efi: mem58: type=5, attr=0x800000000000000f, range=[0x00000000d8759000-0x00000000d8800000) (0MB)
[    0.000000] efi: mem59: type=7, attr=0xf, range=[0x00000000d8800000-0x00000000d8faa000) (7MB)
[    0.000000] efi: mem60: type=9, attr=0xf, range=[0x00000000d8faa000-0x00000000d9000000) (0MB)
[    0.000000] efi: mem61: type=7, attr=0xf, range=[0x00000000d9000000-0x00000000da71c000) (23MB)
[    0.000000] efi: mem62: type=10, attr=0xf, range=[0x00000000da71c000-0x00000000da800000) (0MB)
[    0.000000] efi: mem63: type=7, attr=0xf, range=[0x00000000da800000-0x00000000dbd05000) (21MB)
[    0.000000] efi: mem64: type=0, attr=0xf, range=[0x00000000dbd05000-0x00000000dc000000) (2MB)
[    0.000000] efi: mem65: type=0, attr=0x8000000000000000, range=[0x00000000dd000000-0x00000000df200000) (34MB)
[    0.000000] efi: mem66: type=11, attr=0x8000000000000001, range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem67: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem68: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem69: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem70: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem71: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] efi: mem72: type=7, attr=0xf, range=[0x0000000100000000-0x000000021ee00000) (4590MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Dell Inc. Latitude E7440/07F3F4, BIOS A09 05/01/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21ee00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7E00000000 write-back
[    0.000000]   1 base 0200000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   3 base 00DE000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00DD000000 mask 7FFF000000 uncachable
[    0.000000]   5 base 021F000000 mask 7FFF000000 uncachable
[    0.000000]   6 base 021EE00000 mask 7FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdbd05 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b3e000, 0x01b3efff] PGTABLE
[    0.000000] BRK [0x01b3f000, 0x01b3ffff] PGTABLE
[    0.000000] BRK [0x01b40000, 0x01b40fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21ec00000-0x21edfffff]
[    0.000000]  [mem 0x21ec00000-0x21edfffff] page 2M
[    0.000000] BRK [0x01b41000, 0x01b41fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21ebfffff]
[    0.000000]  [mem 0x21c000000-0x21ebfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcf64bfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcf5fffff] page 2M
[    0.000000]  [mem 0xcf600000-0xcf64bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcf653000-0xd027afff]
[    0.000000]  [mem 0xcf653000-0xcf7fffff] page 4k
[    0.000000]  [mem 0xcf800000-0xd01fffff] page 2M
[    0.000000]  [mem 0xd0200000-0xd027afff] page 4k
[    0.000000] BRK [0x01b42000, 0x01b42fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xd0754000-0xd7db3fff]
[    0.000000]  [mem 0xd0754000-0xd07fffff] page 4k
[    0.000000]  [mem 0xd0800000-0xd7bfffff] page 2M
[    0.000000]  [mem 0xd7c00000-0xd7db3fff] page 4k
[    0.000000] BRK [0x01b43000, 0x01b43fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xd8000000-0xd8758fff]
[    0.000000]  [mem 0xd8000000-0xd85fffff] page 2M
[    0.000000]  [mem 0xd8600000-0xd8758fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd8800000-0xd8fa9fff]
[    0.000000]  [mem 0xd8800000-0xd8dfffff] page 2M
[    0.000000]  [mem 0xd8e00000-0xd8fa9fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd9000000-0xda71bfff]
[    0.000000]  [mem 0xd9000000-0xda5fffff] page 2M
[    0.000000]  [mem 0xda600000-0xda71bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda800000-0xdbd04fff]
[    0.000000]  [mem 0xda800000-0xdbbfffff] page 2M
[    0.000000]  [mem 0xdbc00000-0xdbd04fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x7ec62000-0x7fffffff]
[    0.000000] ACPI: RSDP 0x00000000D8FEB000 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000D8FEB090 0000A4 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000D8FFCA20 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000D8FEB1C8 011851 (v02 DELL   CBX3     00000014 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DA7FE080 000040
[    0.000000] ACPI: UEFI 0x00000000D8FFD000 00063A (v01 INTEL  RstSataE 00000000 ??   00000000)
[    0.000000] ACPI: APIC 0x00000000D8FFD640 000072 (v03 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000D8FFD6B8 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: SLIC 0x00000000D8FFD700 000176 (v03 DELL   CBX3     01072009 MSFT 00010013)
[    0.000000] ACPI: LPIT 0x00000000D8FFD878 00005C (v01 DELL   CBX3     00000000 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D8FFD8D8 000228 (v01 INTEL  sensrhub 00000000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000D8FFDB00 00051F (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000D8FFE020 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
[    0.000000] ACPI: HPET 0x00000000D8FFEAF8 000038 (v01 DELL   CBX3     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D8FFEB30 000455 (v01 SataRe SataTabl 00001000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000D8FFEF88 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
[    0.000000] ACPI: ASF! 0x00000000D8FFEFC8 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: BGRT 0x00000000D8FFF070 000038 (v00 H?\xffffffc6H??          01072009 AMI  00010013)
[    0.000000] ACPI: DMAR 0x00000000D8FFF0A8 0000B0 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 0x00000000D8FFF158 00005C (v01 INTEL  RstSataV 00000000 ??   00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021edfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21edfffff]
[    0.000000]   NODE_DATA [mem 0x21edf4000-0x21edf8fff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880216400000-ffff88021e3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21edfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0004efff]
[    0.000000]   node   0: [mem 0x00050000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xcf64bfff]
[    0.000000]   node   0: [mem 0xcf653000-0xd027afff]
[    0.000000]   node   0: [mem 0xd0754000-0xd7db3fff]
[    0.000000]   node   0: [mem 0xd8000000-0xd8758fff]
[    0.000000]   node   0: [mem 0xd8800000-0xd8fa9fff]
[    0.000000]   node   0: [mem 0xd9000000-0xda71bfff]
[    0.000000]   node   0: [mem 0xda800000-0xdbd04fff]
[    0.000000]   node   0: [mem 0x100000000-0x21edfffff]
[    0.000000] On node 0 totalpages: 2072980
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13968 pages used for memmap
[    0.000000]   DMA32 zone: 893944 pages, LIFO batch:31
[    0.000000]   Normal zone: 18360 pages used for memmap
[    0.000000]   Normal zone: 1175040 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdd200000-0xdf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 56
[    0.000000] PM: Registered nosave memory: [mem 0x0004f000-0x0004ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf64c000-0xcf652fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd027b000-0xd0753fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7db4000-0xd7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd8759000-0xd87fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd8faa000-0xd8ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda71c000-0xda7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdbd05000-0xdbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc000000-0xdcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd000000-0xdf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021ea00000 s87168 r8192 d23424 u524288
[    0.000000] pcpu-alloc: s87168 r8192 d23424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2040566
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=\EFI\archiso\archiso.img archisobasedir=arch archisolabel=ARCH_201408
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7984360K/8291920K available (5225K kernel code, 886K rwdata, 1644K rodata, 1116K init, 1284K bss, 307560K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:8448 nr_irqs:984 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] tsc: Detected 2693.908 MHz processor
[    0.000023] Calibrating delay loop (skipped), value calculated using timer frequency.. 5389.30 BogoMIPS (lpj=8979693)
[    0.000025] pid_max: default: 32768 minimum: 301
[    0.000029] ACPI: Core revision 20140214
[    0.010524] ACPI: All ACPI Tables successfully acquired
[    0.012068] Security Framework initialized
[    0.012073] Yama: becoming mindful.
[    0.012460] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.014059] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.014789] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.014796] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.014970] Initializing cgroup subsys memory
[    0.014973] Initializing cgroup subsys devices
[    0.014974] Initializing cgroup subsys freezer
[    0.014975] Initializing cgroup subsys net_cls
[    0.014976] Initializing cgroup subsys blkio
[    0.014991] CPU: Physical Processor ID: 0
[    0.014992] CPU: Processor Core ID: 0
[    0.014995] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.015856] mce: CPU supports 7 MCE banks
[    0.015866] CPU0: Thermal monitoring enabled (TM1)
[    0.015874] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
tlb_flushall_shift: 6
[    0.015943] Freeing SMP alternatives memory: 20K (ffffffff819f6000 - ffffffff819fb000)
[    0.018292] ftrace: allocating 20230 entries in 80 pages
[    0.024681] dmar: Host address width 39
[    0.024683] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.024690] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.024691] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.024695] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.024696] dmar: RMRR base: 0x000000d7f1a000 end: 0x000000d7f28fff
[    0.024696] dmar: RMRR base: 0x000000dd000000 end: 0x000000df1fffff
[    0.024818] IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
[    0.024818] HPET id 0 under DRHD base 0xfed91000
[    0.024819] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.024941] Enabled IRQ remapping in x2apic mode
[    0.024942] Enabling x2apic
[    0.024942] Enabled x2apic
[    0.024948] Switched APIC routing to cluster x2apic.
[    0.025552] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.058548] smpboot: CPU0: Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz (fam: 06, model: 45, stepping: 01)
[    0.058555] TSC deadline timer enabled
[    0.058561] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.058567] ... version:                3
[    0.058567] ... bit width:              48
[    0.058568] ... generic registers:      4
[    0.058569] ... value mask:             0000ffffffffffff
[    0.058569] ... max period:             0000ffffffffffff
[    0.058570] ... fixed-purpose events:   3
[    0.058570] ... event mask:             000000070000000f
[    0.081969] x86: Booting SMP configuration:
[    0.081971] .... node  #0, CPUs:      #1
[    0.095939] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.102616]  #2 #3
[    0.140983] x86: Booted up 1 node, 4 CPUs
[    0.140986] smpboot: Total of 4 processors activated (21559.23 BogoMIPS)
[    0.144397] devtmpfs: initialized
[    0.146074] PM: Registering ACPI NVS region [mem 0xcf64c000-0xcf652fff] (28672 bytes)
[    0.146075] PM: Registering ACPI NVS region [mem 0xda71c000-0xda7fffff] (933888 bytes)
[    0.146621] pinctrl core: initialized pinctrl subsystem
[    0.146655] RTC time: 10:24:13, date: 08/14/14
[    0.146681] NET: Registered protocol family 16
[    0.146736] cpuidle: using governor ladder
[    0.146737] cpuidle: using governor menu
[    0.146745] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.146747] ACPI: bus type PCI registered
[    0.146748] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.146785] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.146787] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.146850] PCI: Using configuration type 1 for base access
[    0.146855] dmi type 0xB1 record - unknown flag
[    0.147434] ACPI: Added _OSI(Module Device)
[    0.147435] ACPI: Added _OSI(Processor Device)
[    0.147436] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.147437] ACPI: Added _OSI(Processor Aggregator Device)
[    0.150590] ACPI: Executed 1 blocks of module-level executable AML code
[    0.164900] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.435930] ACPI: SSDT 0x00000000DBDAEC18 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.436340] ACPI: Dynamic OEM Table Load:
[    0.436341] ACPI: SSDT 0x0000000000000000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.449365] ACPI: SSDT 0x00000000DBDAE618 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.449919] ACPI: Dynamic OEM Table Load:
[    0.449920] ACPI: SSDT 0x0000000000000000 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.462594] ACPI: SSDT 0x00000000DBDADD98 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.463009] ACPI: Dynamic OEM Table Load:
[    0.463010] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.502569] ACPI: Interpreter enabled
[    0.502576] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.502582] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.502598] ACPI: (supports S0 S3 S4 S5)
[    0.502599] ACPI: Using IOAPIC for interrupt routing
[    0.502626] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.180609] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.180613] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.180778] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    1.180873] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    1.181278] PCI host bridge to bus 0000:00
[    1.181280] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.181282] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.181283] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.181284] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.181286] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    1.181287] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    1.181288] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    1.181289] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    1.181290] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    1.181291] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    1.181292] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    1.181293] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    1.181295] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff]
[    1.181301] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    1.181378] pci 0000:00:02.0: [8086:0a16] type 00 class 0x030000
[    1.181387] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    1.181393] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.181397] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    1.181464] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    1.181469] pci 0000:00:03.0: reg 0x10: [mem 0xf7e34000-0xf7e37fff 64bit]
[    1.181555] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    1.181570] pci 0000:00:14.0: reg 0x10: [mem 0xf7e20000-0xf7e2ffff 64bit]
[    1.181628] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.181659] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.181688] pci 0000:00:16.0: [8086:9c3a] type 00 class 0x078000
[    1.181705] pci 0000:00:16.0: reg 0x10: [mem 0xf7e3f000-0xf7e3f01f 64bit]
[    1.181762] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.181820] pci 0000:00:16.3: [8086:9c3d] type 00 class 0x070002
[    1.181832] pci 0000:00:16.3: reg 0x10: [io  0xf0e0-0xf0e7]
[    1.181838] pci 0000:00:16.3: reg 0x14: [mem 0xf7e3d000-0xf7e3dfff]
[    1.181940] pci 0000:00:19.0: [8086:155a] type 00 class 0x020000
[    1.181953] pci 0000:00:19.0: reg 0x10: [mem 0xf7e00000-0xf7e1ffff]
[    1.181959] pci 0000:00:19.0: reg 0x14: [mem 0xf7e3c000-0xf7e3cfff]
[    1.181965] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    1.182011] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.206263] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.206299] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    1.206311] pci 0000:00:1b.0: reg 0x10: [mem 0xf7e30000-0xf7e33fff 64bit]
[    1.206367] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.206404] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.206440] pci 0000:00:1c.0: [8086:9c10] type 01 class 0x060400
[    1.206504] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.206542] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.206577] pci 0000:00:1c.3: [8086:9c16] type 01 class 0x060400
[    1.206644] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.206683] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.206717] pci 0000:00:1c.4: [8086:9c18] type 01 class 0x060400
[    1.206783] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.206822] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    1.206856] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
[    1.206874] pci 0000:00:1d.0: reg 0x10: [mem 0xf7e3b000-0xf7e3b3ff]
[    1.206952] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.206989] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.207021] pci 0000:00:1f.0: [8086:9c43] type 00 class 0x060100
[    1.207176] pci 0000:00:1f.2: [8086:282a] type 00 class 0x010400
[    1.207188] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    1.207194] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    1.207199] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    1.207205] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    1.207211] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    1.207216] pci 0000:00:1f.2: reg 0x24: [mem 0xf7e3a000-0xf7e3a7ff]
[    1.207245] pci 0000:00:1f.2: PME# supported from D3hot
[    1.207300] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    1.207312] pci 0000:00:1f.3: reg 0x10: [mem 0xf7e39000-0xf7e390ff 64bit]
[    1.207328] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.207450] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.207588] pci 0000:02:00.0: [8086:08b1] type 00 class 0x028000
[    1.207615] pci 0000:02:00.0: reg 0x10: [mem 0xf7d00000-0xf7d01fff 64bit]
[    1.207817] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.207852] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.212988] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.212992] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    1.214879] pci 0000:03:00.0: [1217:8520] type 00 class 0x080501
[    1.214896] pci 0000:03:00.0: reg 0x10: [mem 0xf7c01000-0xf7c01fff]
[    1.214908] pci 0000:03:00.0: reg 0x14: [mem 0xf7c00000-0xf7c007ff]
[    1.215039] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    1.215066] pci 0000:03:00.0: System wakeup disabled by ACPI
[    1.221404] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.221408] pci 0000:00:1c.4:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    1.221479] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    1.299911] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.299947] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.299981] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.300014] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.300048] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.300083] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.300117] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.300151] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.366811] ACPI: Enabled 2 GPEs in block 00 to 7F
[    1.366850] ACPI : EC: GPE = 0x27, I/O: command/status = 0x934, data = 0x930
[    1.366916] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.366919] vgaarb: loaded
[    1.366920] vgaarb: bridge control possible 0000:00:02.0
[    1.366966] PCI: Using ACPI for IRQ routing
[    1.368107] PCI: pci_cache_line_size set to 64 bytes
[    1.368144] e820: reserve RAM buffer [mem 0x0004f000-0x0004ffff]
[    1.368145] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    1.368146] e820: reserve RAM buffer [mem 0xcf64c000-0xcfffffff]
[    1.368147] e820: reserve RAM buffer [mem 0xd027b000-0xd3ffffff]
[    1.368147] e820: reserve RAM buffer [mem 0xd7db4000-0xd7ffffff]
[    1.368148] e820: reserve RAM buffer [mem 0xd8759000-0xdbffffff]
[    1.368149] e820: reserve RAM buffer [mem 0xd8faa000-0xdbffffff]
[    1.368150] e820: reserve RAM buffer [mem 0xda71c000-0xdbffffff]
[    1.368151] e820: reserve RAM buffer [mem 0xdbd05000-0xdbffffff]
[    1.368152] e820: reserve RAM buffer [mem 0x21ee00000-0x21fffffff]
[    1.368209] NetLabel: Initializing
[    1.368210] NetLabel:  domain hash size = 128
[    1.368210] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.368218] NetLabel:  unlabeled traffic allowed by default
[    1.368228] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.368232] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.370250] Switched to clocksource hpet
[    1.373479] pnp: PnP ACPI init
[    1.373491] ACPI: bus type PNP registered
[    1.373557] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    1.373559] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.373647] pnp 00:01: [dma 4]
[    1.373660] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.373675] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.373751] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.373842] system 00:04: [io  0x0680-0x069f] has been reserved
[    1.373843] system 00:04: [io  0xffff] has been reserved
[    1.373844] system 00:04: [io  0xffff] has been reserved
[    1.373847] system 00:04: [io  0xffff] has been reserved
[    1.373848] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    1.373849] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    1.373850] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    1.373851] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    1.373853] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    1.373854] system 00:04: [io  0x164e-0x164f] has been reserved
[    1.373855] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.373881] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.373912] system 00:06: [io  0x1854-0x1857] has been reserved
[    1.373914] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.373945] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    1.373946] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.373985] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.374005] pnp 00:09: Plug and Play ACPI device, IDs DLL05cb PNP0f13 (active)
[    1.603594] pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    1.603810] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.604012] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.604014] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.604015] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.604017] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.604018] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.604020] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.604021] system 00:0c: [mem 0xfed90000-0xfed93fff] could not be reserved
[    1.604023] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.604024] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    1.604026] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.604027] system 00:0c: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    1.604028] system 00:0c: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    1.604030] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.604066] pnp 00:0d: Plug and Play ACPI device, IDs SMO8810 (active)
[    1.923433] pnp: PnP ACPI: found 14 devices
[    1.923435] ACPI: bus type PNP unregistered
[    1.929380] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.929389] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.929393] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    1.929398] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.929401] pci 0000:00:1c.4:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    1.929407] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.929408] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.929409] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.929410] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    1.929412] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    1.929413] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    1.929414] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    1.929415] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    1.929416] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    1.929417] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    1.929418] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    1.929419] pci_bus 0000:00: resource 15 [mem 0xdf200000-0xfeafffff]
[    1.929420] pci_bus 0000:02: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    1.929422] pci_bus 0000:03: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    1.929441] NET: Registered protocol family 2
[    1.929551] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    1.929675] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.929840] TCP: Hash tables configured (established 65536 bind 65536)
[    1.929854] TCP: reno registered
[    1.929861] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.929888] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.929930] NET: Registered protocol family 1
[    1.929938] pci 0000:00:02.0: Boot video device
[    1.977001] PCI: CLS 64 bytes, default 64
[    1.977035] Unpacking initramfs...
[    3.630605] Freeing initrd memory: 20088K (ffff88007ec62000 - ffff880080000000)
[    3.630625] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.630627] software IO TLB [mem 0xc8776000-0xcc776000] (64MB) mapped at [ffff8800c8776000-ffff8800cc775fff]
[    3.630744] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    3.630769] Scanning for low memory corruption every 60 seconds
[    3.630923] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    3.640500] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.641368] zbud: loaded
[    3.641489] VFS: Disk quotas dquot_6.5.2
[    3.641512] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.641581] msgmni has been set to 15785
[    3.641613] Key type big_key registered
[    3.641701] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    3.641730] io scheduler noop registered
[    3.641731] io scheduler deadline registered
[    3.641750] io scheduler cfq registered (default)
[    3.642059] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.642069] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.642090] efifb: probing for efifb
[    3.642102] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90004f80000, using 1876k, total 1875k
[    3.642103] efifb: mode is 800x600x32, linelength=3200, pages=1
[    3.642103] efifb: scrolling: redraw
[    3.642105] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    3.643034] Console: switching to colour frame buffer device 100x37
[    3.643882] fb0: EFI VGA frame buffer device
[    3.643886] intel_idle: MWAIT substates: 0x11142120
[    3.643887] intel_idle: v0.4 model 0x45
[    3.643888] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.644052] GHES: HEST is not enabled!
[    3.644085] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.644280] serial 0000:00:16.3: enabling device (0000 -> 0003)
[    3.664668] 0000:00:16.3: ttyS0 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A
[    3.664808] Linux agpgart interface v0.103
[    3.664835] rtc_cmos 00:05: RTC can wake from S4
[    3.664944] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    3.664968] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.664975] Intel P-state driver initializing.
[    3.664984] Intel pstate controlling: cpu 0
[    3.664995] Intel pstate controlling: cpu 1
[    3.665006] Intel pstate controlling: cpu 2
[    3.665017] Intel pstate controlling: cpu 3
[    3.665078] ledtrig-cpu: registered to indicate activity on CPUs
[    3.665294] TCP: cubic registered
[    3.665508] NET: Registered protocol family 10
[    3.665945] NET: Registered protocol family 17
[    3.666535] registered taskstats version 1
[    3.667448]   Magic number: 10:497:426
[    3.667599] rtc_cmos 00:05: setting system clock to 2014-08-14 10:24:17 UTC (1408011857)
[    3.667773] PM: Hibernation image not present or could not be loaded.
[    3.669594] Freeing unused kernel memory: 1116K (ffffffff818df000 - ffffffff819f6000)
[    3.669598] Write protecting the kernel read-only data: 8192k
[    3.675161] Freeing unused kernel memory: 908K (ffff88000151d000 - ffff880001600000)
[    3.677324] Freeing unused kernel memory: 404K (ffff88000179b000 - ffff880001800000)
[    3.682879] random: systemd-tmpfile urandom read with 7 bits of entropy available
[    3.683697] systemd-udevd[59]: starting version 215
[    3.690817] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    3.691253] ACPI: Lid Switch [LID0]
[    3.691295] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    3.691298] ACPI: Power Button [PBTN]
[    3.691330] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    3.691331] ACPI: Sleep Button [SBTN]
[    3.691361] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.691362] ACPI: Power Button [PWRF]
[    3.694584] sdhci: Secure Digital Host Controller Interface driver
[    3.694586] sdhci: Copyright(c) Pierre Ossman
[    3.696465] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.697009] i8042: Warning: Keylock active
[    3.699340] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.699477] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.700324] wmi: Mapper loaded
[    3.701223] pps_core: LinuxPPS API ver. 1 registered
[    3.701225] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.701581] ACPI: bus type USB registered
[    3.701583] PTP clock support registered
[    3.701598] usbcore: registered new interface driver usbfs
[    3.701604] usbcore: registered new interface driver hub
[    3.701639] usbcore: registered new device driver usb
[    3.702657] [drm] Initialized drm 1.1.0 20060810
[    3.702730] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.702735] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    3.702806] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    3.702808] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    3.702813] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.702829] xhci_hcd 0000:00:14.0: irq 58 for MSI/MSI-X
[    3.703174] hub 1-0:1.0: USB hub found
[    3.703239] hub 1-0:1.0: 9 ports detected
[    3.703707] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.703826] ehci-pci: EHCI PCI platform driver
[    3.704717] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.704720] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    3.704960] hub 2-0:1.0: USB hub found
[    3.704969] hub 2-0:1.0: 4 ports detected
[    3.705636] sdhci-pci 0000:03:00.0: SDHCI controller found [1217:8520] (rev 1)
[    3.706112] SCSI subsystem initialized
[    3.706980] libata version 3.00 loaded.
[    3.707075] mmc0: Unknown controller version (3). You may experience problems.
[    3.707123] mmc0: no vqmmc regulator found
[    3.707125] mmc0: no vmmc regulator found
[    3.707198] mmc0: SDHCI controller on PCI [0000:03:00.0] using ADMA
[    3.708325] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.708340] e1000e 0000:00:19.0: irq 59 for MSI/MSI-X
[    3.722613] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.902560] mmc0: new high speed SDXC card at address e624
[    3.903163] mmcblk0: mmc0:e624 SU128 119 GiB 
[    3.915671]  mmcblk0: unknown partition table
[    4.012205] e1000e 0000:00:19.0 eth0: registered PHC clock
[    4.012209] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) ec:f4:bb:4c:66:14
[    4.012210] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.012233] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    4.012392] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    4.012398] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    4.012409] ehci-pci 0000:00:1d.0: debug port 2
[    4.016291] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    4.016313] ehci-pci 0000:00:1d.0: irq 21, io mem 0xf7e3b000
[    4.062730] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    4.072667] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.072837] hub 3-0:1.0: USB hub found
[    4.072842] hub 3-0:1.0: 3 ports detected
[    4.073415] [drm] Memory usable by graphics device = 2048M
[    4.073418] checking generic (e0000000 1d5000) vs hw (e0000000 10000000)
[    4.073419] fb: switching to inteldrmfb from EFI VGA
[    4.073432] Console: switching to colour dummy device 80x25
[    4.119366] i915 0000:00:02.0: irq 60 for MSI/MSI-X
[    4.119375] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.119376] [drm] Driver supports precise vblank timestamp query.
[    4.119400] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.181024] fbcon: inteldrmfb (fb0) is primary device
[    4.485879] usb 1-6: new high-speed USB device number 3 using xhci_hcd
[    4.632483] tsc: Refined TSC clocksource calibration: 2693.763 MHz
[    4.663443] usb-storage 1-6:1.0: USB Mass Storage device detected
[    4.663519] scsi0 : usb-storage 1-6:1.0
[    4.663574] usbcore: registered new interface driver usb-storage
[    4.663727] usbcore: registered new interface driver uas
[    4.822420] usb 1-7: new high-speed USB device number 4 using xhci_hcd
[    5.003765] usb 1-7: config 1 has an invalid interface number: 8 but max is 3
[    5.003767] usb 1-7: config 1 has no interface number 1
[    5.004168] usb 1-7: config 2 has an invalid interface number: 12 but max is 1
[    5.004170] usb 1-7: config 2 has an invalid interface number: 13 but max is 1
[    5.004171] usb 1-7: config 2 has an invalid interface number: 13 but max is 1
[    5.004172] usb 1-7: config 2 has no interface number 0
[    5.004173] usb 1-7: config 2 has no interface number 1
[    5.007091] usbcore: registered new interface driver cdc_ncm
[    5.007321] usbcore: registered new interface driver cdc_wdm
[    5.008989] cdc_mbim 1-7:2.12: cdc-wdm0: USB WDM device
[    5.009088] cdc_mbim 1-7:2.12 wwan0: register 'cdc_mbim' at usb-0000:00:14.0-7, CDC MBIM, 4a:65:6a:4c:a9:5b
[    5.009100] usbcore: registered new interface driver cdc_mbim
[    5.112364] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    5.236215] hub 3-1:1.0: USB hub found
[    5.236294] hub 3-1:1.0: 8 ports detected
[    5.305544] Console: switching to colour frame buffer device 240x67
[    5.310250] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    5.310251] i915 0000:00:02.0: registered panic notifier
[    5.311570] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    5.352345] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    5.502222] usb 3-1.3: new full-speed USB device number 3 using ehci-pci
[    5.632234] Switched to clocksource tsc
[    5.665546] usb 3-1.5: new full-speed USB device number 4 using ehci-pci
[    5.666349] scsi 0:0:0:0: Direct-Access     TDK LoR  TF10             PMAP PQ: 0 ANSI: 6
[    5.668908] sd 0:0:0:0: [sda] 30261248 512-byte logical blocks: (15.4 GB/14.4 GiB)
[    5.669728] sd 0:0:0:0: [sda] Write Protect is off
[    5.669731] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[    5.670559] sd 0:0:0:0: [sda] No Caching mode page found
[    5.670598] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    5.674046]  sda: sda1 sda2
[    5.676292] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    5.774719] usb 3-1.5: config 0 has an invalid interface number: 3 but max is 2
[    5.774722] usb 3-1.5: config 0 has no interface number 2
[    5.789636] usb 3-1.5: config 0 descriptor??
[    5.962046] acpi device:55: registered as cooling_device0
[    6.122118] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    6.122154] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    6.122179] ahci 0000:00:1f.2: version 3.0
[    6.122476] ahci 0000:00:1f.2: irq 61 for MSI/MSI-X
[    6.122490] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    6.135244] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x3 impl RAID mode
[    6.135247] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag led clo only pio slum part sxs deso sadm sds apst 
[    6.282342] scsi1 : ahci
[    6.282423] scsi2 : ahci
[    6.282483] scsi3 : ahci
[    6.282538] scsi4 : ahci
[    6.282571] ata1: SATA max UDMA/133 abar m2048@0xf7e3a000 port 0xf7e3a100 irq 61
[    6.282572] ata2: SATA max UDMA/133 abar m2048@0xf7e3a000 port 0xf7e3a180 irq 61
[    6.282573] ata3: DUMMY
[    6.282574] ata4: DUMMY
[    6.601777] ata1: SATA link down (SStatus 0 SControl 300)
[    6.921637] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.923732] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[    6.923735] ata2.00: ATA-9: SAMSUNG SSD PM851 mSATA 256GB, EXT48D0Q, max UDMA/133
[    6.923737] ata2.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    6.924129] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[    6.924199] ata2.00: configured for UDMA/133
[    6.924393] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM85 EXT4 PQ: 0 ANSI: 5
[    6.924677] sd 2:0:0:0: [sdb] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    6.924766] sd 2:0:0:0: [sdb] Write Protect is off
[    6.924770] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.924801] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.925958]  sdb: sdb1 sdb2 sdb3
[    6.926212] sd 2:0:0:0: [sdb] Attached SCSI disk
[    6.979443] ISO 9660 Extensions: RRIP_1991A
[    6.983047] loop: module loaded
[    7.020027] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    7.025850] device-mapper: uevent: version 1.0.3
[    7.025912] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    7.037746] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
[    7.285805] systemd[1]: systemd 215 running in system mode. (+PAM -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ +SECCOMP -APPARMOR)
[    7.285906] systemd[1]: Detected architecture 'x86-64'.
[    7.292654] systemd[1]: Set hostname to <archiso>.
[    7.416661] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    7.416704] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    7.416711] systemd[1]: Starting Remote File Systems.
[    7.416777] systemd[1]: Reached target Remote File Systems.
[    7.416797] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    7.416905] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    7.416913] systemd[1]: Starting Encrypted Volumes.
[    7.416954] systemd[1]: Reached target Encrypted Volumes.
[    7.416962] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    7.416981] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    7.416986] systemd[1]: Starting Paths.
[    7.417025] systemd[1]: Reached target Paths.
[    7.417029] systemd[1]: Starting Swap.
[    7.417066] systemd[1]: Reached target Swap.
[    7.417072] systemd[1]: Starting Root Slice.
[    7.420407] systemd[1]: Created slice Root Slice.
[    7.420414] systemd[1]: Starting User and Session Slice.
[    7.420534] systemd[1]: Created slice User and Session Slice.
[    7.420540] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    7.420600] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    7.420605] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    7.420656] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    7.420661] systemd[1]: Starting Delayed Shutdown Socket.
[    7.420709] systemd[1]: Listening on Delayed Shutdown Socket.
[    7.420714] systemd[1]: Starting Journal Socket (/dev/log).
[    7.420768] systemd[1]: Listening on Journal Socket (/dev/log).
[    7.420773] systemd[1]: Starting LVM2 metadata daemon socket.
[    7.420822] systemd[1]: Listening on LVM2 metadata daemon socket.
[    7.420829] systemd[1]: Starting udev Kernel Socket.
[    7.420874] systemd[1]: Listening on udev Kernel Socket.
[    7.420880] systemd[1]: Starting udev Control Socket.
[    7.420926] systemd[1]: Listening on udev Control Socket.
[    7.420932] systemd[1]: Starting Journal Socket.
[    7.420983] systemd[1]: Listening on Journal Socket.
[    7.420992] systemd[1]: Starting System Slice.
[    7.421106] systemd[1]: Created slice System Slice.
[    7.421113] systemd[1]: Starting system-getty.slice.
[    7.421231] systemd[1]: Created slice system-getty.slice.
[    7.421238] systemd[1]: Starting Setup Virtual Console...
[    7.421491] systemd[1]: Mounting POSIX Message Queue File System...
[    7.429901] systemd[1]: Starting Load Kernel Modules...
[    7.430164] systemd[1]: Mounting Debug File System...
[    7.452041] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    7.452400] systemd[1]: Mounting Huge Pages File System...
[    7.479966] systemd[1]: Started Set Up Additional Binary Formats.
[    7.479987] systemd[1]: Starting udev Coldplug all Devices...
[    7.480307] systemd[1]: Starting Journal Service...
[    7.480705] systemd[1]: Started Journal Service.
[    7.732773] FS-Cache: Loaded
[    7.783978] RPC: Registered named UNIX socket transport module.
[    7.783980] RPC: Registered udp transport module.
[    7.783981] RPC: Registered tcp transport module.
[    7.783982] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.857289] FS-Cache: Netfs 'nfs' registered for caching
[    7.893847] random: nonblocking pool is initialized
[    8.041619] systemd-journald[178]: Received request to flush runtime journal from PID 1
[    8.204227] systemd-udevd[220]: starting version 215
[    8.471185] ACPI: AC Adapter [AC] (off-line)
[    8.567756] thermal LNXTHERM:00: registered as thermal_zone0
[    8.567759] ACPI: Thermal Zone [THM] (25 C)
[    8.593648] mei_me 0000:00:16.0: irq 62 for MSI/MSI-X
[    8.617749] systemd-udevd[233]: renamed network interface wwan0 to wwp0s20u7c2i12
[    8.620697] mei_me 0000:00:16.0: NFC MEI VERSION: IVN 0x1 Vendor ID 0x1 Type 0x1
[    8.626929] ACPI: Battery Slot [BAT0] (battery present)
[    8.628441] systemd-udevd[222]: renamed network interface eth0 to eno1
[    8.694820] parport_pc 00:0a: [io  0x0378-0x037b]
[    8.694867] parport_pc 00:0a: [irq 5]
[    8.714729] hidraw: raw HID events driver (C) Jiri Kosina
[    8.723182] systemd-journald[178]: Received request to flush runtime journal from PID 1
[    8.726493] ACPI: Battery Slot [BAT1] (battery absent)
[    8.830742] media: Linux media interface: v0.10
[    8.876999] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    8.878535] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    8.878540] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    8.916754] Linux video capture interface: v2.00
[    8.923314] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    8.923761] snd_hda_intel 0000:00:03.0: enabling device (0000 -> 0002)
[    8.945950] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.950881] snd_hda_intel 0000:00:03.0: irq 63 for MSI/MSI-X
[    8.957632] parport_pc 00:0a: activated
[    8.957637] parport_pc 00:0a: reported by Plug and Play ACPI
[    8.958006] snd_hda_intel 0000:00:1b.0: irq 64 for MSI/MSI-X
[    8.958733] parport_pc 00:0a: disabled
[    8.967419] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x17
[    9.044472] ppdev: user-space parallel port driver
[    9.044764] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[    9.044938] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    9.045005] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input11
[    9.054480] iTCO_vendor_support: vendor-support=0
[    9.083030] input: Dell WMI hotkeys as /devices/virtual/input/input12
[    9.083038] cfg80211: Calling CRDA to update world regulatory domain
[    9.083377] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    9.083415] iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1860)
[    9.083466] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.102265] sound hdaudioC1D0: autoconfig: line_outs=1 (0x16/0x0/0x0/0x0/0x0) type:line
[    9.102269] sound hdaudioC1D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    9.102272] sound hdaudioC1D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    9.102274] sound hdaudioC1D0:    mono: mono_out=0x0
[    9.102275] sound hdaudioC1D0:    inputs:
[    9.102277] sound hdaudioC1D0:      Dock Mic=0x19
[    9.102279] sound hdaudioC1D0:      Headset Mic=0x1a
[    9.102281] sound hdaudioC1D0:      Internal Mic=0x12
[    9.107219] Bluetooth: Core ver 2.19
[    9.107230] NET: Registered protocol family 31
[    9.107230] Bluetooth: HCI device and connection manager initialized
[    9.107235] Bluetooth: HCI socket layer initialized
[    9.107236] Bluetooth: L2CAP socket layer initialized
[    9.107243] Bluetooth: SCO socket layer initialized
[    9.110138] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/hdaudioC1D0/input13
[    9.111576] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
[    9.111801] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
[    9.111863] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
[    9.127479] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x17
[    9.129078] microcode: CPU0 updated to revision 0x18, date = 2014-05-23
[    9.129089] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x17
[    9.129119] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x17
[    9.130016] microcode: CPU1 updated to revision 0x18, date = 2014-05-23
[    9.130023] microcode: CPU2 sig=0x40651, pf=0x40, revision=0x17
[    9.130047] microcode: CPU2 sig=0x40651, pf=0x40, revision=0x17
[    9.130910] microcode: CPU2 updated to revision 0x18, date = 2014-05-23
[    9.130929] microcode: CPU3 sig=0x40651, pf=0x40, revision=0x17
[    9.130950] microcode: CPU3 sig=0x40651, pf=0x40, revision=0x17
[    9.131781] microcode: CPU3 updated to revision 0x18, date = 2014-05-23
[    9.131816] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    9.140036] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_HD (0c45:64d2)
[    9.169952] nfc: nfc_init: NFC Core ver 0.1
[    9.169973] NET: Registered protocol family 39
[    9.181711] input: Laptop_Integrated_Webcam_HD as /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4:1.0/input/input17
[    9.181775] usbcore: registered new interface driver uvcvideo
[    9.181777] USB Video Class driver (1.1.1)
[    9.202008] usbcore: registered new interface driver btusb
[    9.215734] Bluetooth: hci0: read Intel version: 370710018002030d37
[    9.215737] Bluetooth: hci0: Intel device is already patched. patch num: 37
[    9.233993] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    9.233996] Copyright(c) 2003- 2014 Intel Corporation
[    9.234028] iwlwifi 0000:02:00.0: enabling device (0000 -> 0002)
[    9.234173] iwlwifi 0000:02:00.0: irq 65 for MSI/MSI-X
[    9.245510] Probing NFC pn544
[    9.302294] iwlwifi 0000:02:00.0: loaded firmware version 23.214.9.0 op_mode iwlmvm
[    9.331683] AVX2 version of gcm_enc/dec engaged.
[    9.379742] cfg80211: World regulatory domain updated:
[    9.379745] cfg80211:  DFS Master region: unset
[    9.379746] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    9.379748] cfg80211:   (2402000 KHz - 2472000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    9.379749] cfg80211:   (2457000 KHz - 2482000 KHz @ 0 KHz), (N/A, 2000 mBm), (N/A)
[    9.379750] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    9.379751] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[    9.379752] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    9.379753] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    9.379754] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    9.379755] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    9.436270] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[    9.436318] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[    9.436531] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[    9.649565] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    9.671647] systemd-udevd[221]: renamed network interface wlan0 to wlp2s0
[   10.187189] e1000e 0000:00:19.0: irq 59 for MSI/MSI-X
[   10.290399] e1000e 0000:00:19.0: irq 59 for MSI/MSI-X
[   10.290482] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
[   10.317449] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input18
[   10.318317] mousedev: PS/2 mouse device common for all mice
[   10.329583] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input8
[   55.051586] FAT-fs (sdb1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Intel Corporation Haswell-ULT DRAM Controller (rev 0b)
00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 0b)
00:03.0 Audio device: Intel Corporation Haswell-ULT HD Audio Controller (rev 0b)
00:14.0 USB controller: Intel Corporation 8 Series USB xHCI HC (rev 04)
00:16.0 Communication controller: Intel Corporation 8 Series HECI #0 (rev 04)
00:16.3 Serial controller: Intel Corporation 8 Series HECI KT (rev 04)
00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I218-LM (rev 04)
00:1b.0 Audio device: Intel Corporation 8 Series HD Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 1 (rev e4)
00:1c.3 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 4 (rev e4)
00:1c.4 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 5 (rev e4)
00:1d.0 USB controller: Intel Corporation 8 Series USB EHCI #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation 8 Series LPC Controller (rev 04)
00:1f.2 RAID bus controller: Intel Corporation 82801 Mobile SATA Controller [RAID mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 8 Series SMBus Controller (rev 04)
02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)
03:00.0 SD Host controller: O2 Micro, Inc. SD/MMC Card Reader Controller (rev 01)

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-2-ARCH (nobody@var-lib-archbuild-testing-x86_64-tobias) (gcc version 4.9.1 (GCC) ) #1 SMP PREEMPT Mon Aug 4 19:04:45 CEST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=08538c78-68c6-4a5e-a1d2-7cee706e69c5 rw quiet root=/dev/mapper/root cryptdevice=/dev/sda3:root
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000004efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000004f000-0x000000000004ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000050000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf64bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf64c000-0x00000000cf652fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf653000-0x00000000d027afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d027b000-0x00000000d0753fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d0754000-0x00000000d7db3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7db4000-0x00000000d7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d8000000-0x00000000d8758fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d8759000-0x00000000d87fffff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000d8800000-0x00000000d8fa9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d8faa000-0x00000000d8ffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d9000000-0x00000000da71bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da71c000-0x00000000da7fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da800000-0x00000000dbd04fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dbd05000-0x00000000dbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd000000-0x00000000df1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021edfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xd8feb000  ACPI=0xd8feb000  SMBIOS=0xf0000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000004f000) (0MB)
[    0.000000] efi: mem01: type=0, attr=0xf, range=[0x000000000004f000-0x0000000000050000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000050000-0x000000000009d000) (0MB)
[    0.000000] efi: mem03: type=4, attr=0xf, range=[0x000000000009d000-0x000000000009e000) (0MB)
[    0.000000] efi: mem04: type=0, attr=0xf, range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem05: type=2, attr=0xf, range=[0x0000000000100000-0x0000000001047000) (15MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000001047000-0x0000000002000000) (15MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000002000000-0x0000000002f47000) (15MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000002f47000-0x00000000376aa000) (839MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x00000000376aa000-0x0000000037b4d000) (4MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000037b4d000-0x0000000096dcd000) (1522MB)
[    0.000000] efi: mem11: type=2, attr=0xf, range=[0x0000000096dcd000-0x00000000cc776000) (857MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x00000000cc776000-0x00000000cc876000) (1MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x00000000cc876000-0x00000000cf64c000) (45MB)
[    0.000000] efi: mem14: type=10, attr=0xf, range=[0x00000000cf64c000-0x00000000cf653000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x00000000cf653000-0x00000000cf9ed000) (3MB)
[    0.000000] efi: mem16: type=3, attr=0xf, range=[0x00000000cf9ed000-0x00000000d024f000) (8MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x00000000d024f000-0x00000000d0260000) (0MB)
[    0.000000] efi: mem18: type=3, attr=0xf, range=[0x00000000d0260000-0x00000000d0272000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x00000000d0272000-0x00000000d027b000) (0MB)
[    0.000000] efi: mem20: type=6, attr=0x800000000000000f, range=[0x00000000d027b000-0x00000000d0754000) (4MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x00000000d0754000-0x00000000d0766000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000d0766000-0x00000000d14b8000) (13MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x00000000d14b8000-0x00000000d2052000) (11MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x00000000d2052000-0x00000000d22b5000) (2MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x00000000d22b5000-0x00000000d23d8000) (1MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x00000000d23d8000-0x00000000d245f000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x00000000d245f000-0x00000000d24cd000) (0MB)
[    0.000000] efi: mem28: type=7, attr=0xf, range=[0x00000000d24cd000-0x00000000d24d3000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x00000000d24d3000-0x00000000d2608000) (1MB)
[    0.000000] efi: mem30: type=7, attr=0xf, range=[0x00000000d2608000-0x00000000d260d000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x00000000d260d000-0x00000000d26be000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x00000000d26be000-0x00000000d26bf000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x00000000d26bf000-0x00000000d2d29000) (6MB)
[    0.000000] efi: mem34: type=7, attr=0xf, range=[0x00000000d2d29000-0x00000000d2d39000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x00000000d2d39000-0x00000000d2d5d000) (0MB)
[    0.000000] efi: mem36: type=7, attr=0xf, range=[0x00000000d2d5d000-0x00000000d2d69000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf, range=[0x00000000d2d69000-0x00000000d5000000) (34MB)
[    0.000000] efi: mem38: type=7, attr=0xf, range=[0x00000000d5000000-0x00000000d5922000) (9MB)
[    0.000000] efi: mem39: type=1, attr=0xf, range=[0x00000000d5922000-0x00000000d593f000) (0MB)
[    0.000000] efi: mem40: type=3, attr=0xf, range=[0x00000000d593f000-0x00000000d6000000) (6MB)
[    0.000000] efi: mem41: type=7, attr=0xf, range=[0x00000000d6000000-0x00000000d7db4000) (29MB)
[    0.000000] efi: mem42: type=6, attr=0x800000000000000f, range=[0x00000000d7db4000-0x00000000d8000000) (2MB)
[    0.000000] efi: mem43: type=7, attr=0xf, range=[0x00000000d8000000-0x00000000d8759000) (7MB)
[    0.000000] efi: mem44: type=5, attr=0x800000000000000f, range=[0x00000000d8759000-0x00000000d8800000) (0MB)
[    0.000000] efi: mem45: type=7, attr=0xf, range=[0x00000000d8800000-0x00000000d8faa000) (7MB)
[    0.000000] efi: mem46: type=9, attr=0xf, range=[0x00000000d8faa000-0x00000000d9000000) (0MB)
[    0.000000] efi: mem47: type=7, attr=0xf, range=[0x00000000d9000000-0x00000000da71c000) (23MB)
[    0.000000] efi: mem48: type=10, attr=0xf, range=[0x00000000da71c000-0x00000000da800000) (0MB)
[    0.000000] efi: mem49: type=7, attr=0xf, range=[0x00000000da800000-0x00000000dbcfb000) (20MB)
[    0.000000] efi: mem50: type=2, attr=0xf, range=[0x00000000dbcfb000-0x00000000dbd05000) (0MB)
[    0.000000] efi: mem51: type=0, attr=0xf, range=[0x00000000dbd05000-0x00000000dc000000) (2MB)
[    0.000000] efi: mem52: type=0, attr=0x8000000000000000, range=[0x00000000dd000000-0x00000000df200000) (34MB)
[    0.000000] efi: mem53: type=11, attr=0x8000000000000001, range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem54: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem55: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem56: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem57: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem58: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] efi: mem59: type=7, attr=0xf, range=[0x0000000100000000-0x000000021ee00000) (4590MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Dell Inc. Latitude E7440/07F3F4, BIOS A09 05/01/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x21ee00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7E00000000 write-back
[    0.000000]   1 base 0200000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   3 base 00DE000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 00DD000000 mask 7FFF000000 uncachable
[    0.000000]   5 base 021F000000 mask 7FFF000000 uncachable
[    0.000000]   6 base 021EE00000 mask 7FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdbd05 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02b23000, 0x02b23fff] PGTABLE
[    0.000000] BRK [0x02b24000, 0x02b24fff] PGTABLE
[    0.000000] BRK [0x02b25000, 0x02b25fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21ec00000-0x21edfffff]
[    0.000000]  [mem 0x21ec00000-0x21edfffff] page 2M
[    0.000000] BRK [0x02b26000, 0x02b26fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21ebfffff]
[    0.000000]  [mem 0x21c000000-0x21ebfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcf64bfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcf5fffff] page 2M
[    0.000000]  [mem 0xcf600000-0xcf64bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcf653000-0xd027afff]
[    0.000000]  [mem 0xcf653000-0xcf7fffff] page 4k
[    0.000000]  [mem 0xcf800000-0xd01fffff] page 2M
[    0.000000]  [mem 0xd0200000-0xd027afff] page 4k
[    0.000000] BRK [0x02b27000, 0x02b27fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xd0754000-0xd7db3fff]
[    0.000000]  [mem 0xd0754000-0xd07fffff] page 4k
[    0.000000]  [mem 0xd0800000-0xd7bfffff] page 2M
[    0.000000]  [mem 0xd7c00000-0xd7db3fff] page 4k
[    0.000000] BRK [0x02b28000, 0x02b28fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xd8000000-0xd8758fff]
[    0.000000]  [mem 0xd8000000-0xd85fffff] page 2M
[    0.000000]  [mem 0xd8600000-0xd8758fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd8800000-0xd8fa9fff]
[    0.000000]  [mem 0xd8800000-0xd8dfffff] page 2M
[    0.000000]  [mem 0xd8e00000-0xd8fa9fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd9000000-0xda71bfff]
[    0.000000]  [mem 0xd9000000-0xda5fffff] page 2M
[    0.000000]  [mem 0xda600000-0xda71bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda800000-0xdbd04fff]
[    0.000000]  [mem 0xda800000-0xdbbfffff] page 2M
[    0.000000]  [mem 0xdbc00000-0xdbd04fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x376aa000-0x37b4cfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000D8FEB000 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000D8FEB090 0000A4 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000D8FFCA20 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000D8FEB1C8 011851 (v02 DELL   CBX3     00000014 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DA7FE080 000040
[    0.000000] ACPI: UEFI 0x00000000D8FFD000 00063A (v01 INTEL  RstSataE 00000000 ??   00000000)
[    0.000000] ACPI: APIC 0x00000000D8FFD640 000072 (v03 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000D8FFD6B8 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: SLIC 0x00000000D8FFD700 000176 (v03 DELL   CBX3     01072009 MSFT 00010013)
[    0.000000] ACPI: LPIT 0x00000000D8FFD878 00005C (v01 DELL   CBX3     00000000 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D8FFD8D8 000228 (v01 INTEL  sensrhub 00000000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000D8FFDB00 00051F (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000D8FFE020 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
[    0.000000] ACPI: HPET 0x00000000D8FFEAF8 000038 (v01 DELL   CBX3     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D8FFEB30 000455 (v01 SataRe SataTabl 00001000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000D8FFEF88 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
[    0.000000] ACPI: ASF! 0x00000000D8FFEFC8 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: BGRT 0x00000000D8FFF070 000038 (v00 H?\xffffffc6H??          01072009 AMI  00010013)
[    0.000000] ACPI: DMAR 0x00000000D8FFF0A8 0000B0 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 0x00000000D8FFF158 00005C (v01 INTEL  RstSataV 00000000 ??   00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021edfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21edfffff]
[    0.000000]   NODE_DATA [mem 0x21edf4000-0x21edf8fff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880216400000-ffff88021e3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21edfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0004efff]
[    0.000000]   node   0: [mem 0x00050000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xcf64bfff]
[    0.000000]   node   0: [mem 0xcf653000-0xd027afff]
[    0.000000]   node   0: [mem 0xd0754000-0xd7db3fff]
[    0.000000]   node   0: [mem 0xd8000000-0xd8758fff]
[    0.000000]   node   0: [mem 0xd8800000-0xd8fa9fff]
[    0.000000]   node   0: [mem 0xd9000000-0xda71bfff]
[    0.000000]   node   0: [mem 0xda800000-0xdbd04fff]
[    0.000000]   node   0: [mem 0x100000000-0x21edfffff]
[    0.000000] On node 0 totalpages: 2072980
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13968 pages used for memmap
[    0.000000]   DMA32 zone: 893944 pages, LIFO batch:31
[    0.000000]   Normal zone: 18360 pages used for memmap
[    0.000000]   Normal zone: 1175040 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdd200000-0xdf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 56
[    0.000000] PM: Registered nosave memory: [mem 0x0004f000-0x0004ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf64c000-0xcf652fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd027b000-0xd0753fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd7db4000-0xd7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd8759000-0xd87fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd8faa000-0xd8ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda71c000-0xda7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdbd05000-0xdbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc000000-0xdcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd000000-0xdf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021ea00000 s86784 r8192 d23808 u524288
[    0.000000] pcpu-alloc: s86784 r8192 d23808 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2040565
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=08538c78-68c6-4a5e-a1d2-7cee706e69c5 rw quiet root=/dev/mapper/root cryptdevice=/dev/sda3:root
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7999744K/8291920K available (5332K kernel code, 887K rwdata, 1684K rodata, 1128K init, 1164K bss, 292176K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:8448 nr_irqs:984 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] tsc: Detected 2693.748 MHz processor
[    0.000024] Calibrating delay loop (skipped), value calculated using timer frequency.. 5389.97 BogoMIPS (lpj=8979160)
[    0.000026] pid_max: default: 32768 minimum: 301
[    0.000030] ACPI: Core revision 20140424
[    0.010486] ACPI: All ACPI Tables successfully acquired
[    0.011923] Security Framework initialized
[    0.011928] Yama: becoming mindful.
[    0.012329] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.014013] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.014790] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.014797] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.014995] Initializing cgroup subsys memory
[    0.015009] Initializing cgroup subsys devices
[    0.015013] Initializing cgroup subsys freezer
[    0.015015] Initializing cgroup subsys net_cls
[    0.015018] Initializing cgroup subsys blkio
[    0.015036] CPU: Physical Processor ID: 0
[    0.015037] CPU: Processor Core ID: 0
[    0.015041] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.015901] mce: CPU supports 7 MCE banks
[    0.015911] CPU0: Thermal monitoring enabled (TM1)
[    0.015919] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
tlb_flushall_shift: 6
[    0.015995] Freeing SMP alternatives memory: 20K (ffffffff819f9000 - ffffffff819fe000)
[    0.018368] ftrace: allocating 20429 entries in 80 pages
[    0.024986] dmar: Host address width 39
[    0.024988] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.024995] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.024996] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.025000] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.025000] dmar: RMRR base: 0x000000d7f1a000 end: 0x000000d7f28fff
[    0.025001] dmar: RMRR base: 0x000000dd000000 end: 0x000000df1fffff
[    0.025122] IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
[    0.025123] HPET id 0 under DRHD base 0xfed91000
[    0.025123] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.025251] Enabled IRQ remapping in x2apic mode
[    0.025252] Enabling x2apic
[    0.025253] Enabled x2apic
[    0.025259] Switched APIC routing to cluster x2apic.
[    0.025873] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.058865] smpboot: CPU0: Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz (fam: 06, model: 45, stepping: 01)
[    0.058872] TSC deadline timer enabled
[    0.058889] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.058904] ... version:                3
[    0.058905] ... bit width:              48
[    0.058906] ... generic registers:      4
[    0.058906] ... value mask:             0000ffffffffffff
[    0.058907] ... max period:             0000ffffffffffff
[    0.058908] ... fixed-purpose events:   3
[    0.058908] ... event mask:             000000070000000f
[    0.085634] x86: Booting SMP configuration:
[    0.085636] .... node  #0, CPUs:      #1
[    0.099598] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.106286]  #2 #3
[    0.141723] x86: Booted up 1 node, 4 CPUs
[    0.141726] smpboot: Total of 4 processors activated (21558.90 BogoMIPS)
[    0.145203] devtmpfs: initialized
[    0.146914] PM: Registering ACPI NVS region [mem 0xcf64c000-0xcf652fff] (28672 bytes)
[    0.146916] PM: Registering ACPI NVS region [mem 0xda71c000-0xda7fffff] (933888 bytes)
[    0.147495] pinctrl core: initialized pinctrl subsystem
[    0.147531] RTC time: 10:30:28, date: 08/14/14
[    0.147566] NET: Registered protocol family 16
[    0.147647] cpuidle: using governor ladder
[    0.147649] cpuidle: using governor menu
[    0.147666] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.147667] ACPI: bus type PCI registered
[    0.147669] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.147719] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.147721] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.147783] PCI: Using configuration type 1 for base access
[    0.147788] dmi type 0xB1 record - unknown flag
[    0.158678] ACPI: Added _OSI(Module Device)
[    0.158680] ACPI: Added _OSI(Processor Device)
[    0.158681] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.158682] ACPI: Added _OSI(Processor Aggregator Device)
[    0.161900] ACPI: Executed 1 blocks of module-level executable AML code
[    0.175713] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.462032] ACPI: Dynamic OEM Table Load:
[    0.462038] ACPI: SSDT 0xFFFF880212FDA400 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.475473] ACPI: Dynamic OEM Table Load:
[    0.475478] ACPI: SSDT 0xFFFF880212FB1800 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.488700] ACPI: Dynamic OEM Table Load:
[    0.488703] ACPI: SSDT 0xFFFF880212F7EA00 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.528692] ACPI: Interpreter enabled
[    0.528698] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.528704] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.528721] ACPI: (supports S0 S3 S4 S5)
[    0.528722] ACPI: Using IOAPIC for interrupt routing
[    0.528745] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.221256] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.221261] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.221430] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    1.221526] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    1.221913] PCI host bridge to bus 0000:00
[    1.221915] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.221917] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.221918] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.221919] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.221920] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    1.221921] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    1.221922] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    1.221923] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    1.221924] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    1.221925] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    1.221926] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    1.221927] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    1.221928] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff]
[    1.221934] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    1.222006] pci 0000:00:02.0: [8086:0a16] type 00 class 0x030000
[    1.222015] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    1.222020] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.222023] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    1.222084] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    1.222090] pci 0000:00:03.0: reg 0x10: [mem 0xf7e34000-0xf7e37fff 64bit]
[    1.222167] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    1.222180] pci 0000:00:14.0: reg 0x10: [mem 0xf7e20000-0xf7e2ffff 64bit]
[    1.222219] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.222251] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.222280] pci 0000:00:16.0: [8086:9c3a] type 00 class 0x078000
[    1.222297] pci 0000:00:16.0: reg 0x10: [mem 0xf7e3f000-0xf7e3f01f 64bit]
[    1.222354] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.222413] pci 0000:00:16.3: [8086:9c3d] type 00 class 0x070002
[    1.222425] pci 0000:00:16.3: reg 0x10: [io  0xf0e0-0xf0e7]
[    1.222431] pci 0000:00:16.3: reg 0x14: [mem 0xf7e3d000-0xf7e3dfff]
[    1.222535] pci 0000:00:19.0: [8086:155a] type 00 class 0x020000
[    1.222548] pci 0000:00:19.0: reg 0x10: [mem 0xf7e00000-0xf7e1ffff]
[    1.222554] pci 0000:00:19.0: reg 0x14: [mem 0xf7e3c000-0xf7e3cfff]
[    1.222560] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    1.222606] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.245835] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.245874] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    1.245887] pci 0000:00:1b.0: reg 0x10: [mem 0xf7e30000-0xf7e33fff 64bit]
[    1.245943] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.245981] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.246019] pci 0000:00:1c.0: [8086:9c10] type 01 class 0x060400
[    1.246085] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.246124] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.246161] pci 0000:00:1c.3: [8086:9c16] type 01 class 0x060400
[    1.246229] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.246268] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.246303] pci 0000:00:1c.4: [8086:9c18] type 01 class 0x060400
[    1.246371] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.246410] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    1.246447] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
[    1.246463] pci 0000:00:1d.0: reg 0x10: [mem 0xf7e3b000-0xf7e3b3ff]
[    1.246528] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.246566] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.246599] pci 0000:00:1f.0: [8086:9c43] type 00 class 0x060100
[    1.246755] pci 0000:00:1f.2: [8086:282a] type 00 class 0x010400
[    1.246767] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    1.246773] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    1.246779] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    1.246784] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    1.246790] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    1.246796] pci 0000:00:1f.2: reg 0x24: [mem 0xf7e3a000-0xf7e3a7ff]
[    1.246824] pci 0000:00:1f.2: PME# supported from D3hot
[    1.246883] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    1.246894] pci 0000:00:1f.3: reg 0x10: [mem 0xf7e39000-0xf7e390ff 64bit]
[    1.246910] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.247046] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.247181] pci 0000:02:00.0: [8086:08b1] type 00 class 0x028000
[    1.247212] pci 0000:02:00.0: reg 0x10: [mem 0xf7d00000-0xf7d01fff 64bit]
[    1.247364] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.247399] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.252567] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.252571] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    1.252631] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.252636] pci 0000:00:1c.4:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    1.252706] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    1.332869] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.332906] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.332940] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.332973] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.333006] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.333038] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.333071] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.333104] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.403120] ACPI: Enabled 2 GPEs in block 00 to 7F
[    1.403160] ACPI : EC: GPE = 0x27, I/O: command/status = 0x934, data = 0x930
[    1.403247] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.403249] vgaarb: loaded
[    1.403250] vgaarb: bridge control possible 0000:00:02.0
[    1.403309] PCI: Using ACPI for IRQ routing
[    1.404430] PCI: pci_cache_line_size set to 64 bytes
[    1.404464] e820: reserve RAM buffer [mem 0x0004f000-0x0004ffff]
[    1.404465] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    1.404466] e820: reserve RAM buffer [mem 0xcf64c000-0xcfffffff]
[    1.404467] e820: reserve RAM buffer [mem 0xd027b000-0xd3ffffff]
[    1.404468] e820: reserve RAM buffer [mem 0xd7db4000-0xd7ffffff]
[    1.404469] e820: reserve RAM buffer [mem 0xd8759000-0xdbffffff]
[    1.404471] e820: reserve RAM buffer [mem 0xd8faa000-0xdbffffff]
[    1.404472] e820: reserve RAM buffer [mem 0xda71c000-0xdbffffff]
[    1.404473] e820: reserve RAM buffer [mem 0xdbd05000-0xdbffffff]
[    1.404474] e820: reserve RAM buffer [mem 0x21ee00000-0x21fffffff]
[    1.404558] NetLabel: Initializing
[    1.404559] NetLabel:  domain hash size = 128
[    1.404559] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.404568] NetLabel:  unlabeled traffic allowed by default
[    1.404585] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.404589] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.406609] Switched to clocksource hpet
[    1.409933] pnp: PnP ACPI init
[    1.409949] ACPI: bus type PNP registered
[    1.410007] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    1.410010] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.410186] system 00:01: [io  0x0680-0x069f] has been reserved
[    1.410188] system 00:01: [io  0xffff] has been reserved
[    1.410189] system 00:01: [io  0xffff] has been reserved
[    1.410190] system 00:01: [io  0xffff] has been reserved
[    1.410191] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    1.410192] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    1.410193] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    1.410194] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    1.410196] system 00:01: [io  0x1800-0x18fe] could not be reserved
[    1.410197] system 00:01: [io  0x164e-0x164f] has been reserved
[    1.410198] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.410223] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.410256] system 00:03: [io  0x1854-0x1857] has been reserved
[    1.410258] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.410288] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.410290] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.410317] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.410335] pnp 00:06: Plug and Play ACPI device, IDs DLL05cb PNP0f13 (active)
[    1.556647] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    1.556852] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.557047] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.557048] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.557050] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.557051] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.557053] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.557054] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.557056] system 00:09: [mem 0xfed90000-0xfed93fff] could not be reserved
[    1.557057] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.557058] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    1.557060] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.557061] system 00:09: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    1.557063] system 00:09: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    1.557064] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.756530] pnp: PnP ACPI: found 10 devices
[    1.756533] ACPI: bus type PNP unregistered
[    1.762498] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.762507] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    1.762510] pci 0000:00:1c.3:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    1.762516] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    1.762519] pci 0000:00:1c.4:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    1.762525] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.762527] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.762528] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.762529] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    1.762530] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    1.762531] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    1.762532] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    1.762533] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    1.762534] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    1.762535] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    1.762536] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    1.762537] pci_bus 0000:00: resource 15 [mem 0xdf200000-0xfeafffff]
[    1.762539] pci_bus 0000:02: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    1.762540] pci_bus 0000:03: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    1.762562] NET: Registered protocol family 2
[    1.762703] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    1.762833] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.763017] TCP: Hash tables configured (established 65536 bind 65536)
[    1.763033] TCP: reno registered
[    1.763040] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.763070] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.763125] NET: Registered protocol family 1
[    1.763134] pci 0000:00:02.0: Boot video device
[    1.763140] pci 0000:00:14.0: enabling device (0000 -> 0002)
[    1.783329] pci 0000:00:1d.0: enabling device (0000 -> 0002)
[    1.783442] PCI: CLS 64 bytes, default 64
[    1.783475] Unpacking initramfs...
[    1.843160] Freeing initrd memory: 4748K (ffff8800376aa000 - ffff880037b4d000)
[    1.843180] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.843182] software IO TLB [mem 0xc8776000-0xcc776000] (64MB) mapped at [ffff8800c8776000-ffff8800cc775fff]
[    1.843316] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    1.843351] Scanning for low memory corruption every 60 seconds
[    1.843528] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    1.843764] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.844659] zbud: loaded
[    1.844785] VFS: Disk quotas dquot_6.5.2
[    1.844811] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.844894] msgmni has been set to 15786
[    1.844931] Key type big_key registered
[    1.845034] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.845073] io scheduler noop registered
[    1.845075] io scheduler deadline registered
[    1.845108] io scheduler cfq registered (default)
[    1.845430] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.845443] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.845469] efifb: probing for efifb
[    1.845486] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90004f80000, using 8128k, total 8128k
[    1.845487] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    1.845488] efifb: scrolling: redraw
[    1.845489] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.848770] Console: switching to colour frame buffer device 240x67
[    1.851847] fb0: EFI VGA frame buffer device
[    1.851853] intel_idle: MWAIT substates: 0x11142120
[    1.851854] intel_idle: v0.4 model 0x45
[    1.851855] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.852029] GHES: HEST is not enabled!
[    1.852081] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.852277] serial 0000:00:16.3: enabling device (0000 -> 0003)
[    1.872665] 0000:00:16.3: ttyS0 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A
[    1.872811] Linux agpgart interface v0.103
[    1.872843] rtc_cmos 00:02: RTC can wake from S4
[    1.872953] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.872978] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.872985] Intel P-state driver initializing.
[    1.872994] Intel pstate controlling: cpu 0
[    1.873005] Intel pstate controlling: cpu 1
[    1.873016] Intel pstate controlling: cpu 2
[    1.873028] Intel pstate controlling: cpu 3
[    1.873096] ledtrig-cpu: registered to indicate activity on CPUs
[    1.873392] TCP: cubic registered
[    1.873613] NET: Registered protocol family 10
[    1.874031] NET: Registered protocol family 17
[    1.874717] registered taskstats version 1
[    1.875672]   Magic number: 10:600:527
[    1.875830] rtc_cmos 00:02: setting system clock to 2014-08-14 10:30:30 UTC (1408012230)
[    1.876034] PM: Hibernation image not present or could not be loaded.
[    1.877876] Freeing unused kernel memory: 1128K (ffffffff818df000 - ffffffff819f9000)
[    1.877879] Write protecting the kernel read-only data: 8192k
[    1.880790] Freeing unused kernel memory: 800K (ffff880002538000 - ffff880002600000)
[    1.881462] Freeing unused kernel memory: 364K (ffff8800027a5000 - ffff880002800000)
[    1.885743] random: systemd-tmpfile urandom read with 5 bits of entropy available
[    1.886574] systemd-udevd[59]: starting version 215
[    1.909118] sdhci: Secure Digital Host Controller Interface driver
[    1.909121] sdhci: Copyright(c) Pierre Ossman
[    1.910346] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.910877] i8042: Warning: Keylock active
[    1.913359] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.913394] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.914646] ACPI: bus type USB registered
[    1.914671] usbcore: registered new interface driver usbfs
[    1.914680] usbcore: registered new interface driver hub
[    1.915416] SCSI subsystem initialized
[    1.916357] libata version 3.00 loaded.
[    1.916943] usbcore: registered new device driver usb
[    1.916986] ahci 0000:00:1f.2: version 3.0
[    1.917182] ahci 0000:00:1f.2: irq 58 for MSI/MSI-X
[    1.917198] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    1.917679] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.917758] ehci-pci: EHCI PCI platform driver
[    1.918077] AVX2 version of gcm_enc/dec engaged.
[    1.924953] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.929796] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x3 impl RAID mode
[    1.929799] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag led clo only pio slum part sxs deso sadm sds apst 
[    1.930298] scsi0 : ahci
[    1.930402] scsi1 : ahci
[    1.930493] scsi2 : ahci
[    1.930580] scsi3 : ahci
[    1.930627] ata1: SATA max UDMA/133 abar m2048@0xf7e3a000 port 0xf7e3a100 irq 58
[    1.930629] ata2: SATA max UDMA/133 abar m2048@0xf7e3a000 port 0xf7e3a180 irq 58
[    1.930630] ata3: DUMMY
[    1.930632] ata4: DUMMY
[    1.930760] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.930766] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.930839] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.930860] xhci_hcd 0000:00:14.0: irq 59 for MSI/MSI-X
[    1.931057] hub 1-0:1.0: USB hub found
[    1.931073] hub 1-0:1.0: 9 ports detected
[    1.932540] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.932543] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.932672] hub 2-0:1.0: USB hub found
[    1.932680] hub 2-0:1.0: 4 ports detected
[    1.933300] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.933304] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    1.933314] ehci-pci 0000:00:1d.0: debug port 2
[    1.937205] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.937216] ehci-pci 0000:00:1d.0: irq 21, io mem 0xf7e3b000
[    1.946432] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.946663] hub 3-0:1.0: USB hub found
[    1.946668] hub 3-0:1.0: 3 ports detected
[    2.249702] ata1: SATA link down (SStatus 0 SControl 300)
[    2.289709] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    2.569590] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.571614] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[    2.571617] ata2.00: ATA-9: SAMSUNG SSD PM851 mSATA 256GB, EXT48D0Q, max UDMA/133
[    2.571618] ata2.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.571982] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[    2.572048] ata2.00: configured for UDMA/133
[    2.572157] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SSD PM85 8D0Q PQ: 0 ANSI: 5
[    2.573569] sd 1:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    2.573635] sd 1:0:0:0: [sda] Write Protect is off
[    2.573637] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.573658] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.575136]  sda: sda1 sda2 sda3
[    2.576078] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.600718] device-mapper: uevent: version 1.0.3
[    2.600800] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    2.702923] usb 1-6: new high-speed USB device number 3 using xhci_hcd
[    2.846147] tsc: Refined TSC clocksource calibration: 2693.764 MHz
[    2.880651] usb-storage 1-6:1.0: USB Mass Storage device detected
[    2.880745] scsi4 : usb-storage 1-6:1.0
[    2.880798] usbcore: registered new interface driver usb-storage
[    2.881006] usbcore: registered new interface driver uas
[    3.039434] usb 1-7: new high-speed USB device number 4 using xhci_hcd
[    3.220554] usb 1-7: config 1 has an invalid interface number: 8 but max is 3
[    3.220557] usb 1-7: config 1 has no interface number 1
[    3.220855] usb 1-7: config 2 has an invalid interface number: 12 but max is 1
[    3.220857] usb 1-7: config 2 has an invalid interface number: 13 but max is 1
[    3.220859] usb 1-7: config 2 has an invalid interface number: 13 but max is 1
[    3.220860] usb 1-7: config 2 has no interface number 0
[    3.220861] usb 1-7: config 2 has no interface number 1
[    3.326031] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    3.449884] hub 3-1:1.0: USB hub found
[    3.449989] hub 3-1:1.0: 8 ports detected
[    3.715900] usb 3-1.3: new full-speed USB device number 3 using ehci-pci
[    3.845890] Switched to clocksource tsc
[    3.879230] usb 3-1.5: new full-speed USB device number 4 using ehci-pci
[    3.883350] scsi 4:0:0:0: Direct-Access     TDK LoR  TF10             PMAP PQ: 0 ANSI: 6
[    3.884164] sd 4:0:0:0: [sdb] 30261248 512-byte logical blocks: (15.4 GB/14.4 GiB)
[    3.884939] sd 4:0:0:0: [sdb] Write Protect is off
[    3.884942] sd 4:0:0:0: [sdb] Mode Sense: 23 00 00 00
[    3.885722] sd 4:0:0:0: [sdb] No Caching mode page found
[    3.885746] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    3.889145]  sdb: sdb1 sdb2
[    3.891519] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    3.973922] usb 3-1.5: config 0 has an invalid interface number: 3 but max is 2
[    3.973925] usb 3-1.5: config 0 has no interface number 2
[    3.988203] usb 3-1.5: config 0 descriptor??
[    6.120586] random: nonblocking pool is initialized
[   10.809169] NET: Registered protocol family 38
[   18.751840] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   18.913445] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[   18.935094] EXT4-fs (dm-0): re-mounted. Opts: data=ordered
[   18.979297] systemd-udevd[209]: starting version 215
[   19.022362] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   19.026243] pps_core: LinuxPPS API ver. 1 registered
[   19.026247] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   19.026398] mei_me 0000:00:16.0: irq 60 for MSI/MSI-X
[   19.026949] PTP clock support registered
[   19.033745] ACPI: AC Adapter [AC] (off-line)
[   19.034205] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   19.034207] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   19.034526] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[   19.034667] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   19.034684] e1000e 0000:00:19.0: irq 61 for MSI/MSI-X
[   19.037438] ACPI: Lid Switch [LID0]
[   19.037503] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[   19.037507] ACPI: Power Button [PBTN]
[   19.037547] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input4
[   19.037550] ACPI: Sleep Button [SBTN]
[   19.037604] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   19.037606] ACPI: Power Button [PWRF]
[   19.039966] hidraw: raw HID events driver (C) Jiri Kosina
[   19.040035] [drm] Initialized drm 1.1.0 20060810
[   19.053284] ACPI: Battery Slot [BAT0] (battery present)
[   19.053779] parport_pc 00:07: [io  0x0378-0x037b]
[   19.053815] parport_pc 00:07: [irq 5]
[   19.056773] mei_me 0000:00:16.0: NFC MEI VERSION: IVN 0x1 Vendor ID 0x1 Type 0x1
[   19.070788] media: Linux media interface: v0.10
[   19.081406] usbcore: registered new interface driver usbserial
[   19.081416] Linux video capture interface: v2.00
[   19.081421] usbcore: registered new interface driver usbserial_generic
[   19.081433] usbserial: USB Serial support registered for generic
[   19.082119] Bluetooth: Core ver 2.19
[   19.082127] NET: Registered protocol family 31
[   19.082128] Bluetooth: HCI device and connection manager initialized
[   19.082133] Bluetooth: HCI socket layer initialized
[   19.082135] Bluetooth: L2CAP socket layer initialized
[   19.082142] Bluetooth: SCO socket layer initialized
[   19.082382] usbcore: registered new interface driver cdc_ncm
[   19.082653] cfg80211: Calling CRDA to update world regulatory domain
[   19.083946] usbcore: registered new interface driver cdc_wdm
[   19.084279] usbcore: registered new interface driver qcserial
[   19.084292] usbserial: USB Serial support registered for Qualcomm USB modem
[   19.086267] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_HD (0c45:64d2)
[   19.088212] Intel(R) Wireless WiFi driver for Linux, in-tree:
[   19.088214] Copyright(c) 2003- 2014 Intel Corporation
[   19.088246] iwlwifi 0000:02:00.0: enabling device (0000 -> 0002)
[   19.092756] usbcore: registered new interface driver btusb
[   19.094684] iwlwifi 0000:02:00.0: irq 62 for MSI/MSI-X
[   19.100101] cdc_mbim 1-7:2.12: cdc-wdm0: USB WDM device
[   19.100254] cdc_mbim 1-7:2.12 wwan0: register 'cdc_mbim' at usb-0000:00:14.0-7, CDC MBIM, 9e:1e:8d:71:ba:27
[   19.100278] usbcore: registered new interface driver cdc_mbim
[   19.102934] iwlwifi 0000:02:00.0: loaded firmware version 23.214.9.0 op_mode iwlmvm
[   19.106316] Bluetooth: hci0: read Intel version: 370710018002030d37
[   19.106319] Bluetooth: hci0: Intel device is already patched. patch num: 37
[   19.111994] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   19.123144] ACPI: Battery Slot [BAT1] (battery absent)
[   19.123815] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[   19.123861] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   19.124102] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   19.128612] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x17
[   19.128635] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x17
[   19.128677] input: Laptop_Integrated_Webcam_HD as /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4:1.0/input/input8
[   19.128995] microcode: CPU2 sig=0x40651, pf=0x40, revision=0x17
[   19.129058] usbcore: registered new interface driver uvcvideo
[   19.129060] USB Video Class driver (1.1.1)
[   19.129323] microcode: CPU3 sig=0x40651, pf=0x40, revision=0x17
[   19.129356] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   19.136935] wmi: Mapper loaded
[   19.145698] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   19.156904] systemd-journald[189]: Received request to flush runtime journal from PID 1
[   19.157663] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   19.236572] nfc: nfc_init: NFC Core ver 0.1
[   19.236590] NET: Registered protocol family 39
[   19.243436] input: Dell WMI hotkeys as /devices/virtual/input/input9
[   19.247007] systemd-udevd[212]: renamed network interface wwan0 to wwp0s20u7c2i12
[   19.252639] ppdev: user-space parallel port driver
[   19.253427] Probing NFC pn544
[   19.331307] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   19.350248] systemd-udevd[215]: renamed network interface wlan0 to wlp2s0
[   19.350442] e1000e 0000:00:19.0 eth0: registered PHC clock
[   19.350446] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) ec:f4:bb:4c:66:14
[   19.350448] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[   19.350472] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[   19.350494] snd_hda_intel 0000:00:03.0: enabling device (0000 -> 0002)
[   19.350496] parport_pc 00:07: activated
[   19.350501] parport_pc 00:07: reported by Plug and Play ACPI
[   19.376976] systemd-udevd[213]: renamed network interface eth0 to eno1
[   19.377581] [drm] Memory usable by graphics device = 2048M
[   19.377583] [drm] Replacing VGA console driver
[   19.377587] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
[   19.377589] fb: switching to inteldrmfb from EFI VGA
[   19.377610] snd_hda_intel 0000:00:1b.0: irq 63 for MSI/MSI-X
[   19.377631] Console: switching to colour dummy device 80x25
[   19.388574] sound hdaudioC1D0: autoconfig: line_outs=1 (0x16/0x0/0x0/0x0/0x0) type:line
[   19.388576] sound hdaudioC1D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   19.388578] sound hdaudioC1D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   19.388579] sound hdaudioC1D0:    mono: mono_out=0x0
[   19.388579] sound hdaudioC1D0:    inputs:
[   19.388581] sound hdaudioC1D0:      Dock Mic=0x19
[   19.388582] sound hdaudioC1D0:      Headset Mic=0x1a
[   19.388583] sound hdaudioC1D0:      Internal Mic=0x12
[   19.394016] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/hdaudioC1D0/input10
[   19.394197] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[   19.394260] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[   19.394322] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[   19.394471] thermal LNXTHERM:00: registered as thermal_zone1
[   19.394474] ACPI: Thermal Zone [THM] (25 C)
[   19.394505] parport_pc 00:07: disabled
[   19.426892] i915 0000:00:02.0: irq 64 for MSI/MSI-X
[   19.426904] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   19.426906] [drm] Driver supports precise vblank timestamp query.
[   19.426935] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   19.452146] [drm] VBT doesn't support DRRS
[   19.492067] fbcon: inteldrmfb (fb0) is primary device
[   20.437849] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input14
[   20.440703] mousedev: PS/2 mouse device common for all mice
[   20.450973] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input7
[   20.549777] Console: switching to colour frame buffer device 240x67
[   20.557122] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   20.557124] i915 0000:00:02.0: registered panic notifier
[   20.575452] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   20.629775] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input15
[   20.629877] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   20.629979] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140424/utaddress-258)
[   20.629986] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   20.633929] iTCO_vendor_support: vendor-support=0
[   20.634425] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   20.634461] iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1860)
[   20.634510] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   20.636368] snd_hda_intel 0000:00:03.0: irq 65 for MSI/MSI-X
[   20.647252] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input16
[   20.648037] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input17
[   20.648103] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input18
[   21.342943] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   69.393283] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   69.393500] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   69.405280] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   73.634976] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   73.635190] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   73.646823] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   77.386909] wlp2s0: authenticate with d4:ca:6d:e5:d3:0b
[   77.390364] wlp2s0: send auth to d4:ca:6d:e5:d3:0b (try 1/3)
[   77.394753] wlp2s0: authenticated
[   77.395879] wlp2s0: associate with d4:ca:6d:e5:d3:0b (try 1/3)
[   77.401784] wlp2s0: RX AssocResp from d4:ca:6d:e5:d3:0b (capab=0x431 status=0 aid=3)
[   77.404650] wlp2s0: associated
[   77.404683] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[   97.367761] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 6
[   97.378873] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 - driver resynced.
[   98.493266] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 6
[   98.503573] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 - driver resynced.
[  431.031154] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  431.032124] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  431.033186] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  431.034242] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  431.035283] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  431.035287] psmouse serio1: issuing reconnect request
[  920.822632] snd_hda_intel 0000:00:1b.0: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[  941.044693] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  941.045742] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  941.046782] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 lost sync at byte 1
[  941.049983] psmouse serio1: DualPoint TouchPad at isa0060/serio1/input0 - driver resynced.

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Intel Corporation Haswell-ULT DRAM Controller (rev 0b)
00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 0b)
00:03.0 Audio device: Intel Corporation Haswell-ULT HD Audio Controller (rev 0b)
00:14.0 USB controller: Intel Corporation 8 Series USB xHCI HC (rev 04)
00:16.0 Communication controller: Intel Corporation 8 Series HECI #0 (rev 04)
00:16.3 Serial controller: Intel Corporation 8 Series HECI KT (rev 04)
00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I218-LM (rev 04)
00:1b.0 Audio device: Intel Corporation 8 Series HD Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 1 (rev e4)
00:1c.3 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 4 (rev e4)
00:1c.4 PCI bridge: Intel Corporation 8 Series PCI Express Root Port 5 (rev e4)
00:1d.0 USB controller: Intel Corporation 8 Series USB EHCI #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation 8 Series LPC Controller (rev 04)
00:1f.2 RAID bus controller: Intel Corporation 82801 Mobile SATA Controller [RAID mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 8 Series SMBus Controller (rev 04)
02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)

--ibTvN161/egqYuK8--
