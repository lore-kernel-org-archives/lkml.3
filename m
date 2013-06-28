Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3F1WHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:07:05 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35548 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3F1WHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:07:03 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Dan Williams <djbw@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [resend2 PATCH] DMA: remove unused support for MEMSET operations
References: <2026698.ciHxSBJcBE@amdc1032>
	<CAA9_cmf0WE=hFm8B_hk1GY87fk-R-Zv+iGXuBnqpiMA+bJ2oMg@mail.gmail.com>
	<CAOesGMgO6ywqk8XzYMdnBfDmB80bu0uPUL2s5kkux-zi5Sa4cw@mail.gmail.com>
	<5175148.xKLzH0kDXm@amdc1032>
Date: Fri, 28 Jun 2013 15:06:59 -0700
In-Reply-To: <5175148.xKLzH0kDXm@amdc1032> (Bartlomiej Zolnierkiewicz's
	message of "Fri, 28 Jun 2013 19:15:42 +0200")
Message-ID: <87r4flopoc.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> writes:

> Hi,
>
> On Friday, June 28, 2013 09:37:36 AM Olof Johansson wrote:
>> Bartlomiej,
>> 
>> Did you build test on the platforms you changed? You broke dove_defconfig:
>> 
>> In file included from /home/olof/work/next/include/linux/skbuff.h:31:0,
>>                  from /home/olof/work/next/include/linux/if_ether.h:23,
>>                  from /home/olof/work/next/include/net/dsa.h:14,
>>                  from /home/olof/work/next/arch/arm/plat-orion/common.c:21:
>> /home/olof/work/next/arch/arm/plat-orion/common.c: In function
>> 'orion_xor1_init':
>> /home/olof/work/next/arch/arm/plat-orion/common.c:737:14: error:
>> 'DMA_MEMSET' undeclared (first use in this function)
>>   dma_cap_set(DMA_MEMSET, orion_xor1_channels_data[1].cap_mask);
>>               ^
>> /home/olof/work/next/include/linux/dmaengine.h:862:46: note: in
>> definition of macro 'dma_cap_set'
>>  #define dma_cap_set(tx, mask) __dma_cap_set((tx), &(mask))
>>                                               ^
>> /home/olof/work/next/arch/arm/plat-orion/common.c:737:14: note: each
>> undeclared identifier is reported only once for each function it
>> appears in
>>   dma_cap_set(DMA_MEMSET, orion_xor1_channels_data[1].cap_mask);
>>               ^
>> /home/olof/work/next/include/linux/dmaengine.h:862:46: note: in
>> definition of macro 'dma_cap_set'
>>  #define dma_cap_set(tx, mask) __dma_cap_set((tx), &(mask))
>> 
>> 
>> This would also have been found by a "git grep DMA_MEMSET" across the tree.
>> 
>> Andrew, this is coming really late before the merge window, I think it
>> makes sense to hold off to 3.12 if it can't be done without trivial
>> regressions. :(
>
> Sorry for that.  This is an old patch that I ported to current kernels.
> I fixed rejects and verified that it compiles for cases that hit rejects
> but unfortunately I forgot to check for new code related to DMA_MEMSET
> functionality.  Fortunately it seems that the problematic places are in
> plat-orion/common.c and mv_xor.c.  They are fixed in the attached patch.

I just verified that v2 builds now on ARM dove_defconfig and
kirkwood_defconfig (those were 2 that I noticed were broken by this
change.)

Hopefully Andrew can pick up v2.

Thanks,

Kevin

