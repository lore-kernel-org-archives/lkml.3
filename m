Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaAWKIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:08:04 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54844 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaAWKID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:08:03 -0500
MIME-Version: 1.0
In-Reply-To: <1390470990-16065-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1390470990-16065-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Thu, 23 Jan 2014 15:38:02 +0530
Message-ID: <CAK9yfHz4KR5A8KgXfak_tgfCOGg8O+KW2dSH3nZ_A8cRZ16Dxw@mail.gmail.com>
Subject: Re: [PATCH] lib/genalloc.c: add check gen_pool_dma_alloc() if dma
 pointer is not NULL
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nicolin Chen <b42378@freescale.com>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 23 January 2014 15:26, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> In the gen_pool_dma_alloc() the dma pointer can be NULL
> and while assigning gen_pool_virt_to_phys(pool, vaddr) to
> dma caused the following crash on da850 evm,
>
[snip]
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  lib/genalloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index dda3116..f48163f 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -334,7 +334,8 @@ void *gen_pool_dma_alloc(struct gen_pool *pool, size_t size, dma_addr_t *dma)
>         if (!vaddr)
>                 return NULL;
>
> -       *dma = gen_pool_virt_to_phys(pool, vaddr);
> +       if (dma)
> +               *dma = gen_pool_virt_to_phys(pool, vaddr);

Wouldn't it be better to return (with error/message) if dma is NULL
rather than silently ignore it?

>
>         return (void *)vaddr;


-- 
With warm regards,
Sachin
