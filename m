Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaI0PNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 11:13:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51962 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaI0PNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 11:13:33 -0400
Subject: Re: [PATCH] Remove GFP_DMA and GFP_DMA32 from flags before passing it into kmalloc.
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <CAHkaATRAuo=Mh1tmMVDxnWeO8ARjW+KBfHNLpaFG3XxN5uY-hQ@mail.gmail.com>
Date: Sat, 27 Sep 2014 16:13:28 +0100
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <983713E2-1EBC-45CC-8212-20FBFAA9AC0B@arm.com>
References: <CAHkaATRAuo=Mh1tmMVDxnWeO8ARjW+KBfHNLpaFG3XxN5uY-hQ@mail.gmail.com>
To: Miles MH Chen <orca.chen@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Sep 2014, at 16:09, Miles MH Chen <orca.chen@gmail.com> wrote:
> Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
> ---
>  arch/arm64/mm/dma-mapping.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
> index 4164c5a..273cf6d 100644
> --- a/arch/arm64/mm/dma-mapping.c
> +++ b/arch/arm64/mm/dma-mapping.c
> @@ -103,7 +103,8 @@ static void *__dma_alloc_noncoherent(struct device *dev, size_t size,
>      ptr = __dma_alloc_coherent(dev, size, dma_handle, flags, attrs);
>      if (!ptr)
>          goto no_mem;
> -    map = kmalloc(sizeof(struct page *) << order, flags & ~GFP_DMA);
> +    map = kmalloc(sizeof(struct page *) << order,
> +                    flags & ~(GFP_DMA | GFP_DMA32));

Do you have an explanation on why this is needed (and such explanation
should also be included in the commit log)? We don’t use ZONE_DMA32 on
arm64 (we did initially but it was for the wrong reasons).

Thanks,

Catalin