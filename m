Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3KFJRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:17:08 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41659 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3KFJRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:17:05 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21114.2315.610902.200164@gargle.gargle.HOWL>
Date: Wed, 6 Nov 2013 10:16:59 +0100
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Subject: [BUG?] mtrr sanitizer fails on Latitude E6230
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently got a Dell Latitude E6230 (Ivy Bridge i7-3540M) and noticed that
the mtrr sanitizer failed on it:

=== snip ===
Linux version 3.12.0 (mikpe@barley) (gcc version 4.8.3 20131017 (prerelease) (GCC) ) #1 SMP Wed Nov 6 09:46:02 CET 2013
Command line: ro root=LABEL=/ resume=/dev/sda2 rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=sv-latin1
KERNEL supported cpus:
  Intel GenuineIntel
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009d3ff] usable
BIOS-e820: [mem 0x000000000009d400-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
BIOS-e820: [mem 0x0000000040005000-0x00000000d5f09fff] usable
BIOS-e820: [mem 0x00000000d5f0a000-0x00000000d5ffffff] reserved
BIOS-e820: [mem 0x00000000d6000000-0x00000000d6751fff] usable
BIOS-e820: [mem 0x00000000d6752000-0x00000000d67fffff] reserved
BIOS-e820: [mem 0x00000000d6800000-0x00000000d6fb2fff] usable
BIOS-e820: [mem 0x00000000d6fb3000-0x00000000d6ffffff] ACPI data
BIOS-e820: [mem 0x00000000d7000000-0x00000000d86fbfff] usable
BIOS-e820: [mem 0x00000000d86fc000-0x00000000d87fffff] ACPI NVS
BIOS-e820: [mem 0x00000000d8800000-0x00000000d96d4fff] usable
BIOS-e820: [mem 0x00000000d96d5000-0x00000000da054fff] reserved
BIOS-e820: [mem 0x00000000da055000-0x00000000da097fff] ACPI NVS
BIOS-e820: [mem 0x00000000da098000-0x00000000daadcfff] usable
BIOS-e820: [mem 0x00000000daadd000-0x00000000dafeffff] reserved
BIOS-e820: [mem 0x00000000daff0000-0x00000000daffffff] usable
BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
NX (Execute Disable) protection: active
SMBIOS 2.7 present.
DMI: Dell Inc. Latitude E6230/0Y47PX, BIOS A11 08/27/2013
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-E7FFF uncachable
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask E00000000 write-back
  1 base 200000000 mask FE0000000 write-back
  2 base 0E0000000 mask FE0000000 uncachable
  3 base 0DC000000 mask FFC000000 uncachable
  4 base 0DB800000 mask FFF800000 uncachable
  5 base 21F000000 mask FFF000000 uncachable
  6 base 21E800000 mask FFF800000 uncachable
  7 base 21E600000 mask FFFE00000 uncachable
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 8GB, type WB
reg 1, base: 8GB, range: 512MB, type WB
reg 2, base: 3584MB, range: 512MB, type UC
reg 3, base: 3520MB, range: 64MB, type UC
reg 4, base: 3512MB, range: 8MB, type UC
reg 5, base: 8688MB, range: 16MB, type UC
reg 6, base: 8680MB, range: 8MB, type UC
reg 7, base: 8678MB, range: 2MB, type UC
total RAM covered: 8094M
 gran_size: 64K 	chunk_size: 64K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 128K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 256K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 64K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 64K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -16M
*BAD*gran_size: 64K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -16M
 gran_size: 64K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 0G
*BAD*gran_size: 64K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1G
 gran_size: 128K 	chunk_size: 128K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 256K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 128K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 128K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -16M
*BAD*gran_size: 128K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -16M
 gran_size: 128K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 0G
*BAD*gran_size: 128K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1G
 gran_size: 256K 	chunk_size: 256K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 256K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 256K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 256K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 256K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 256K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 256K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 256K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -16M
*BAD*gran_size: 256K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -16M
 gran_size: 256K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 0G
*BAD*gran_size: 256K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1G
 gran_size: 512K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 512K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 512K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 512K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 512K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 512K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 512K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -16M
*BAD*gran_size: 512K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -16M
 gran_size: 512K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 0G
*BAD*gran_size: 512K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1G
 gran_size: 1M 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 1M 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 1M 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 1M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 1M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 1M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -16M
*BAD*gran_size: 1M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -16M
 gran_size: 1M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 0G
*BAD*gran_size: 1M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1G
 gran_size: 2M 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 2M 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 2M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 2M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 2M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -16M
*BAD*gran_size: 2M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -16M
 gran_size: 2M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 2M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 2M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 0G
 gran_size: 2M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 0G
*BAD*gran_size: 2M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1G
 gran_size: 4M 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 4M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 4M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
*BAD*gran_size: 4M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: -14M
*BAD*gran_size: 4M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: -14M
 gran_size: 4M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 2M
 gran_size: 4M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 2M
 gran_size: 4M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 2M
 gran_size: 4M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 2M
*BAD*gran_size: 4M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1022M
 gran_size: 8M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 102M
 gran_size: 8M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 38M
 gran_size: 8M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 38M
 gran_size: 8M 	chunk_size: 64M 	num_reg: 9  	lose cover RAM: 6M
 gran_size: 8M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 6M
 gran_size: 8M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 6M
 gran_size: 8M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 6M
 gran_size: 8M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 6M
 gran_size: 8M 	chunk_size: 2G 	num_reg: 9  	lose cover RAM: 6M
 gran_size: 16M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 46M
 gran_size: 16M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 46M
 gran_size: 16M 	chunk_size: 64M 	num_reg: 9  	lose cover RAM: 14M
 gran_size: 16M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 14M
 gran_size: 16M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 14M
 gran_size: 16M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 14M
 gran_size: 16M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 14M
 gran_size: 16M 	chunk_size: 2G 	num_reg: 9  	lose cover RAM: 14M
 gran_size: 32M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 30M
 gran_size: 32M 	chunk_size: 64M 	num_reg: 9  	lose cover RAM: 30M
 gran_size: 32M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 30M
 gran_size: 32M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 30M
 gran_size: 32M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 30M
 gran_size: 32M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 30M
 gran_size: 32M 	chunk_size: 2G 	num_reg: 9  	lose cover RAM: 30M
 gran_size: 64M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 94M
 gran_size: 64M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 94M
 gran_size: 64M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 94M
 gran_size: 64M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 94M
 gran_size: 64M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 94M
 gran_size: 64M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 94M
 gran_size: 128M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 158M
 gran_size: 128M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 158M
 gran_size: 128M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 158M
 gran_size: 128M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 158M
 gran_size: 128M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 158M
 gran_size: 256M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 414M
 gran_size: 256M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 414M
 gran_size: 256M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 414M
 gran_size: 256M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 414M
 gran_size: 512M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 926M
 gran_size: 512M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 926M
 gran_size: 512M 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 926M
 gran_size: 1G 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 926M
 gran_size: 1G 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 926M
 gran_size: 2G 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 1950M
mtrr_cleanup: can not find optimal value
please specify mtrr_gran_size/mtrr_chunk_size
=== snip ===

For now I'm disabling the mtrr sanitizer in this machine's kernel.

/Mikael
