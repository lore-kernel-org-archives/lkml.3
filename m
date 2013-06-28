Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3F1Qhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:37:38 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:60993 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3F1Qhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:37:37 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAA9_cmf0WE=hFm8B_hk1GY87fk-R-Zv+iGXuBnqpiMA+bJ2oMg@mail.gmail.com>
References: <2026698.ciHxSBJcBE@amdc1032>
	<CAA9_cmf0WE=hFm8B_hk1GY87fk-R-Zv+iGXuBnqpiMA+bJ2oMg@mail.gmail.com>
Date: Fri, 28 Jun 2013 09:37:36 -0700
Message-ID: <CAOesGMgO6ywqk8XzYMdnBfDmB80bu0uPUL2s5kkux-zi5Sa4cw@mail.gmail.com>
Subject: Re: [resend2 PATCH] DMA: remove unused support for MEMSET operations
From: Olof Johansson <olof@lixom.net>
To: Dan Williams <djbw@fb.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej,

Did you build test on the platforms you changed? You broke dove_defconfig:

In file included from /home/olof/work/next/include/linux/skbuff.h:31:0,
                 from /home/olof/work/next/include/linux/if_ether.h:23,
                 from /home/olof/work/next/include/net/dsa.h:14,
                 from /home/olof/work/next/arch/arm/plat-orion/common.c:21:
/home/olof/work/next/arch/arm/plat-orion/common.c: In function
'orion_xor1_init':
/home/olof/work/next/arch/arm/plat-orion/common.c:737:14: error:
'DMA_MEMSET' undeclared (first use in this function)
  dma_cap_set(DMA_MEMSET, orion_xor1_channels_data[1].cap_mask);
              ^
/home/olof/work/next/include/linux/dmaengine.h:862:46: note: in
definition of macro 'dma_cap_set'
 #define dma_cap_set(tx, mask) __dma_cap_set((tx), &(mask))
                                              ^
/home/olof/work/next/arch/arm/plat-orion/common.c:737:14: note: each
undeclared identifier is reported only once for each function it
appears in
  dma_cap_set(DMA_MEMSET, orion_xor1_channels_data[1].cap_mask);
              ^
/home/olof/work/next/include/linux/dmaengine.h:862:46: note: in
definition of macro 'dma_cap_set'
 #define dma_cap_set(tx, mask) __dma_cap_set((tx), &(mask))


This would also have been found by a "git grep DMA_MEMSET" across the tree.

Andrew, this is coming really late before the merge window, I think it
makes sense to hold off to 3.12 if it can't be done without trivial
regressions. :(



-Olof

On Thu, Jun 27, 2013 at 1:20 PM, Dan Williams <djbw@fb.com> wrote:
> On Wed, Jun 26, 2013 at 6:31 AM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
>> There have never been any real users of MEMSET operations
>> since they have been introduced in January 2007 (commit
>> 7405f74badf46b5d023c5d2b670b4471525f6c91 "dmaengine: refactor
>> dmaengine around dma_async_tx_descriptor").  Therefore remove
>> support for them for now, it can be always brought back when
>> needed.
>>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Dan Williams <djbw@fb.com>
>> Cc: Tomasz Figa <t.figa@samsung.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>
> I see Andrew has already picked this up.
>
> Acked-by: Dan Williams <djbw@fb.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
