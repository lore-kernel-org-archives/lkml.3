Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3FJSAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:00:47 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:32922 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3FJSAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-aW05AW+gO_bTG-jCs2PWPHNyJZWK-KUx1eHx6wy=m2XdbEQ@mail.gmail.com>
References: <CAG-aW07oTun9z_bOTLE25X+60KmCG1c0nMFecLrf_UAzNMF2Pw@mail.gmail.com>
 <CA+QCeVRBF_MGFtZtjeDL_YaoobhArLHna-9VKEeHegJ5D=06Pg@mail.gmail.com> <CAG-aW05AW+gO_bTG-jCs2PWPHNyJZWK-KUx1eHx6wy=m2XdbEQ@mail.gmail.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Mon, 10 Jun 2013 21:00:23 +0300
Message-ID: <CA+QCeVQniT-3uP3o+VfQ5vGPhH5U6N_TM9jvn=gpTCdzPDaTog@mail.gmail.com>
Subject: Re: 3.10-rc4: mtrr_cleanup: can not find optimal value, please
 specify mtrr_gran_size/mtrr_chunk_size
To: Matt <jackdachef@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 10 June 2013 18:41, Matt <jackdachef@gmail.com> wrote:
> Hi Sergey,
>
> Hi List, Hi Yinghai Lu,
>
>
> the following patches
>
> http://marc.info/?l=linux-kernel&m=137080807327118&w=2
> http://marc.info/?l=linux-kernel&m=137080805927115&w=2
>
> "fixed" it for me and it works again
>
> meanwhile I also tried out 3.9.5 & 3.8.13 and I got the same "BAD"
> result on 3.9.5 whereas with 3.8.13 it worked fine
>
>
> result of 3.10-rc5 + patches:

3.10-rc5 with patches has curred error messages in dmesg but MTRRs
still do not cover my entire memory (7748Mb) or anything close to it
("total RAM covered: 2936M").Unfortunately, I don't have anything
other to compare to because this system started straight with 3.9.X

rathamahata@piledriver ~ $ free -m
             total       used       free     shared    buffers     cached
Mem:          7748       1264       6483          0         56        513
-/+ buffers/cache:        695       7053
Swap:         3659          0       3659
rathamahata@piledriver ~ $

...
[    0.000000] e820: last_pfn = 0x23f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-D2FFF write-protect
[    0.000000]   D3000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000B7800000 mask FFFFFF800000 uncachable
[    0.000000]   3 base 0000B8000000 mask FFFFF8000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000023f000000 aka 9200M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
[    0.000000] total RAM covered: 2936M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4
 lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
[    0.000000] e820: update [mem 0xb7800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xb7800 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]20:
last_pfn = 0x23f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-D2FFF write-protect
[    0.000000]   D3000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000B7800000 mask FFFFFF800000 uncachable
[    0.000000]   3 base 0000B8000000 mask FFFFF8000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000023f000000 aka 9200M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
[    0.000000] total RAM covered: 2936M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4
 lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
[    0.000000] e820: update [mem 0xb7800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xb7800 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
...


>
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-D3FFF write-protect
> [    0.000000]   D4000-DFFFF uncachable
> [    0.000000]   E0000-E3FFF write-protect
> [    0.000000]   E4000-E7FFF write-through
> [    0.000000]   E8000-EBFFF write-protect
> [    0.000000]   EC000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask E00000000 write-back
> [    0.000000]   1 base 200000000 mask FC0000000 write-back
> [    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 8GB, type WB
> [    0.000000] reg 1, base: 8GB, range: 1GB, type WB
> [    0.000000] reg 2, base: 3GB, range: 1GB, type UC
> [    0.000000] total RAM covered: 8192M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K chunk_size: 64K num_reg: 4   lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
> [    0.000000] reg 2, base: 4GB, range: 4GB, type WB
> [    0.000000] reg 3, base: 8GB, range: 1GB, type WB
>
> cat /proc/mtrr
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg02: base=0x100000000 ( 4096MB), size= 4096MB, count=1: write-back
> reg03: base=0x200000000 ( 8192MB), size= 1024MB, count=1: write-back
> reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining
>
> which is the same like on 3.8.13
>
>
> Thanks !
>
> Matt
>
> On Mon, Jun 10, 2013 at 12:01 PM, Sergey Meirovich
> <rathamahata@gmail.com> wrote:
>> Hi,
>>
>> On 5 June 2013 02:08, Matt <jackdachef@gmail.com> wrote:
>>> Hi everyone,
>>>
>>>
>>> I noticed today the following error messages in /var/log/kern.log :
>>>
>>>
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] MTRR default type: uncachable
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] MTRR fixed ranges enabled:
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   00000-9FFFF write-back
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   A0000-BFFFF uncachable
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   C0000-D3FFF write-protect
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   D4000-DFFFF uncachable
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   E0000-E3FFF write-protect
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   E4000-E7FFF write-through
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   E8000-EBFFF write-protect
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   EC000-EFFFF write-through
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   F0000-FFFFF write-protect
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] MTRR variable ranges enabled:
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   0 base 000000000
>>> mask E00000000 write-back
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   1 base 200000000
>>> mask FC0000000 write-back
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   2 base 0C0000000
>>> mask FC0000000 uncachable
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   3 disabled
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   4 disabled
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   5 disabled
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   6 disabled
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]   7 disabled
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] x86 PAT enabled: cpu
>>> 0, old 0x7040600070406, new 0x7010600070106
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] original variable MTRRs
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] reg 0, base: 0GB,
>>> range: 8GB, type WB
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] reg 1, base: 8GB,
>>> range: 1GB, type WB
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] reg 2, base: 3GB,
>>> range: 1GB, type UC
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] total RAM covered: 8192M
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 64K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 128K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 256K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 128K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 256K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 256K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 512M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1G
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] *BAD*gran_size: 1G
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000]  gran_size: 2G
>>> chunk_size: 2G num_reg: 2   lose cover RAM: 2G
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] mtrr_cleanup: can not
>>> find optimal value
>>> Jun  5 00:26:48 localhost kernel: [    0.000000] please specify
>>> mtrr_gran_size/mtrr_chunk_size
>>>
>>>
>>>
>>> when trying to append some commands, e.g.:
>>>
>>> enable_mtrr_cleanup mtrr_spare_reg_nr=1 mtrr_gran_size=32M mtrr_chunk_size=128M
>>>
>>> or
>>>
>>> enable_mtrr_cleanup mtrr_spare_reg_nr=0
>>>
>>> it doesn't make any change
>>>
>>>
>>> this would yield the following result:
>>>
>>>
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] MTRR default type: uncachable
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] MTRR fixed ranges enabled:
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   00000-9FFFF write-back
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   A0000-BFFFF uncachable
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   C0000-D3FFF write-protect
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   D4000-DFFFF uncachable
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   E0000-E3FFF write-protect
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   E4000-E7FFF write-through
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   E8000-EBFFF write-protect
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   EC000-EFFFF write-through
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   F0000-FFFFF write-protect
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] MTRR variable ranges enabled:
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   0 base 000000000
>>> mask E00000000 write-back
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   1 base 200000000
>>> mask FC0000000 write-back
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   2 base 0C0000000
>>> mask FC0000000 uncachable
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   3 disabled
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   4 disabled
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   5 disabled
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   6 disabled
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]   7 disabled
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] x86 PAT enabled: cpu
>>> 0, old 0x7040600070406, new 0x7010600070106
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] original variable MTRRs
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] reg 0, base: 0GB,
>>> range: 8GB, type WB
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] reg 1, base: 8GB,
>>> range: 1GB, type WB
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] reg 2, base: 3GB,
>>> range: 1GB, type UC
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] total RAM covered: 8192M
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] invalid
>>> mtrr_gran_size or mtrr_chunk_size, will find optimal one
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 64K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 128K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 256K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 128K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 256K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 256K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 512K num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512K
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 1M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 2M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 2M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 4M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 4M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 8M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 8M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 16M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 16M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 32M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 32M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 64M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 64M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 128M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 128M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 256M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 256M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512M
>>> chunk_size: 512M num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512M
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 512M
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1G
>>> chunk_size: 1G num_reg: 4   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] *BAD*gran_size: 1G
>>> chunk_size: 2G num_reg: 5   lose cover RAM: -0G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000]  gran_size: 2G
>>> chunk_size: 2G num_reg: 2   lose cover RAM: 2G
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] mtrr_cleanup: can not
>>> find optimal value
>>> Jun  5 00:20:47 localhost kernel: [    0.000000] please specify
>>> mtrr_gran_size/mtrr_chunk_size
>>>
>>>
>>>
>>>
>>>
>>> Is this some kind of kernel BUG due to the negative value (- 0G) ?
>>>
>>> MTRR seems to be a topic that is not widely discussed or thoroughly
>>> understood when using google to find answers.
>>>
>>> cat /proc/mtrr
>>> reg00: base=0x000000000 (    0MB), size= 8192MB, count=1: write-back
>>> reg01: base=0x200000000 ( 8192MB), size= 1024MB, count=1: write-back
>>> reg02: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
>>>
>>
>> I also seems to suffer from the same issue on 3.9.5:
>> in my situation it looks even weirder:
>> rathamahata@piledriver ~ $ cat /proc/mtrr
>> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
>> reg01: base=0x080000000 ( 2048MB), size=  256MB, count=1: write-back
>> reg02: base=0x08f800000 ( 2296MB), size=    8MB, count=1: uncachable
>> reg03: base=0x0b0000000 ( 2816MB), size=  256MB, count=1: write-combining
>> reg04: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-combining
>> rathamahata@piledriver ~ $ free -m
>>              total       used       free     shared    buffers     cached
>> Mem:          7370        745       6624          0         34        241
>> -/+ buffers/cache:        470       6900
>> Swap:         3659          0       3659
>> rathamahata@piledriver ~ $
