Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3FJTBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:01:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:54622 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3FJTBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXj4GUAqmRfGykKsedSi=B-ogbVFax2txe_p0gCP_bFng@mail.gmail.com>
References: <CAG-aW07oTun9z_bOTLE25X+60KmCG1c0nMFecLrf_UAzNMF2Pw@mail.gmail.com>
 <CA+QCeVRBF_MGFtZtjeDL_YaoobhArLHna-9VKEeHegJ5D=06Pg@mail.gmail.com>
 <CAG-aW05AW+gO_bTG-jCs2PWPHNyJZWK-KUx1eHx6wy=m2XdbEQ@mail.gmail.com>
 <CA+QCeVQniT-3uP3o+VfQ5vGPhH5U6N_TM9jvn=gpTCdzPDaTog@mail.gmail.com> <CAE9FiQXj4GUAqmRfGykKsedSi=B-ogbVFax2txe_p0gCP_bFng@mail.gmail.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Mon, 10 Jun 2013 22:00:40 +0300
Message-ID: <CA+QCeVSg6B8CSnMO+=ajCXMfxRB6wwJ-g9sHxcnpVi9K1yy=Yg@mail.gmail.com>
Subject: Re: 3.10-rc4: mtrr_cleanup: can not find optimal value, please
 specify mtrr_gran_size/mtrr_chunk_size
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt <jackdachef@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10 June 2013 21:28, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jun 10, 2013 at 11:00 AM, Sergey Meirovich
> <rathamahata@gmail.com> wrote:
>
>> 3.10-rc5 with patches has curred error messages in dmesg but MTRRs
>> still do not cover my entire memory (7748Mb) or anything close to it
>> ("total RAM covered: 2936M").Unfortunately, I don't have anything
>> other to compare to because this system started straight with 3.9.X
>
> Your system is AMD 64bit, so there is TOM2.
>
>>
>> rathamahata@piledriver ~ $ free -m
>>              total       used       free     shared    buffers     cached
>> Mem:          7748       1264       6483          0         56        513
>> -/+ buffers/cache:        695       7053
>> Swap:         3659          0       3659
>> rathamahata@piledriver ~ $
>>
>> ...
>> [    0.000000] e820: last_pfn = 0x23f000 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF write-through
>> [    0.000000]   C0000-D2FFF write-protect
>> [    0.000000]   D3000-DFFFF uncachable
>> [    0.000000]   E0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
>> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
>> [    0.000000]   2 base 0000B7800000 mask FFFFFF800000 uncachable
>> [    0.000000]   3 base 0000B8000000 mask FFFFF8000000 uncachable
>> [    0.000000]   4 disabled
>> [    0.000000]   5 disabled
>> [    0.000000]   6 disabled
>> [    0.000000]   7 disabled
>> [    0.000000] TOM2: 000000023f000000 aka 9200M
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] original variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
>> [    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
>> [    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
>> [    0.000000] total RAM covered: 2936M
>> [    0.000000] Found optimal setting for mtrr clean up
>> [    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4
>>  lose cover RAM: 0G
>> [    0.000000] New variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
>> [    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
>> [    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
>> [    0.000000] e820: update [mem 0xb7800000-0xffffffff] usable ==> reserved
>> [    0.000000] e820: last_pfn = 0xb7800 max_arch_pfn = 0x400000000
>> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
>> [    0.000000] Using GB pages for direct mapping
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]20:
>> last_pfn = 0x23f000 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF write-through
>> [    0.000000]   C0000-D2FFF write-protect
>> [    0.000000]   D3000-DFFFF uncachable
>> [    0.000000]   E0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
>> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
>> [    0.000000]   2 base 0000B7800000 mask FFFFFF800000 uncachable
>> [    0.000000]   3 base 0000B8000000 mask FFFFF8000000 uncachable
>> [    0.000000]   4 disabled
>> [    0.000000]   5 disabled
>> [    0.000000]   6 disabled
>> [    0.000000]   7 disabled
>> [    0.000000] TOM2: 000000023f000000 aka 9200M
>
> [4G, 9200M) is write-back automatically, there is no need to cover them
> again with VAR mtrr.
>
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] original variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
>> [    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
>> [    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
>> [    0.000000] total RAM covered: 2936M
>
> It only count var really.
>
>> [    0.000000] Found optimal setting for mtrr clean up
>> [    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 4
>>  lose cover RAM: 0G
>> [    0.000000] New variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
>> [    0.000000] reg 2, base: 2936MB, range: 8MB, type UC
>> [    0.000000] reg 3, base: 2944MB, range: 128MB, type UC
>> [    0.000000] e820: update [mem 0xb7800000-0xffffffff] usable ==> reserved
>> [    0.000000] e820: last_pfn = 0xb7800 max_arch_pfn = 0x400000000
>> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
>> [    0.000000] Using GB pages for direct mapping
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> ...
>
> so there is no problem with your system...

Thanks a lot for confirming this!
>
> Thanks
>
> Yinghai
