Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaAWKVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:21:53 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36407 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaAWKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:21:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHz4KR5A8KgXfak_tgfCOGg8O+KW2dSH3nZ_A8cRZ16Dxw@mail.gmail.com>
References: <1390470990-16065-1-git-send-email-prabhakar.csengg@gmail.com> <CAK9yfHz4KR5A8KgXfak_tgfCOGg8O+KW2dSH3nZ_A8cRZ16Dxw@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 Jan 2014 15:51:31 +0530
Message-ID: <CA+V-a8vN2VBCjuAMGootU=t+PbjK7wVDQeYZgV03Wa5070WwFw@mail.gmail.com>
Subject: Re: [PATCH] lib/genalloc.c: add check gen_pool_dma_alloc() if dma
 pointer is not NULL
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nicolin Chen <b42378@freescale.com>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Thu, Jan 23, 2014 at 3:38 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Prabhakar,
>
> On 23 January 2014 15:26, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> In the gen_pool_dma_alloc() the dma pointer can be NULL
>> and while assigning gen_pool_virt_to_phys(pool, vaddr) to
>> dma caused the following crash on da850 evm,
>>
> [snip]
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  lib/genalloc.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/genalloc.c b/lib/genalloc.c
>> index dda3116..f48163f 100644
>> --- a/lib/genalloc.c
>> +++ b/lib/genalloc.c
>> @@ -334,7 +334,8 @@ void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
>>         if (!vaddr)
>>                 return NULL;
>>
>> -       *dma = gen_pool_virt_to_phys(pool, vaddr);
>> +       if (dma)
>> +               *dma = gen_pool_virt_to_phys(pool, vaddr);
>
> Wouldn't it be better to return (with error/message) if dma is NULL
> rather than silently ignore it?
>
I am not sure if returning here with error is OK,
may be just adding a warning message could be OK ?

Regards,
--Prabhakar Lad
