Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaGQCWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:22:33 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62094 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaGQCWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:22:31 -0400
MIME-Version: 1.0
In-Reply-To: <53BD01ED.30802@gmail.com>
References: <53BD01ED.30802@gmail.com>
Date: Thu, 17 Jul 2014 10:22:30 +0800
Message-ID: <CAF0htA6KyHZ0=-LADoc9=wuj0rtew=Un8+J5=G1m5_6FGJGu5g@mail.gmail.com>
Subject: Re: [PATCH] arch: score: Export necessary symbols in related files
From: Lennox Wu <lennox.wu@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Acked-by: Lennox Wu<lennox.wu@gmail.com>

2014-07-09 16:48 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
> 'csum_partial_copy_from_user' and 'flush_dcache_page' are also needed by
> outside modules, so need export them in the related files.
>
> The related error (with allmodconfig under score):
>
>     MODPOST 1365 modules
>   ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!
>   ERROR: "flush_dcache_page" [net/sunrpc/sunrpc.ko] undefined!
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/score/lib/checksum_copy.c | 1 +
>  arch/score/mm/cache.c          | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/score/lib/checksum_copy.c b/arch/score/lib/checksum_copy.c
> index 04565dd..9b770b3 100644
> --- a/arch/score/lib/checksum_copy.c
> +++ b/arch/score/lib/checksum_copy.c
> @@ -50,3 +50,4 @@ unsigned int csum_partial_copy_from_user(const char *src, char *dst,
>
>         return csum_partial(dst, len, sum);
>  }
> +EXPORT_SYMBOL(csum_partial_copy_from_user);
> diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
> index f85ec1a..be91041 100644
> --- a/arch/score/mm/cache.c
> +++ b/arch/score/mm/cache.c
> @@ -72,6 +72,7 @@ void flush_dcache_page(struct page *page)
>         addr = (unsigned long) page_address(page);
>         flush_data_cache_page(addr);
>  }
> +EXPORT_SYMBOL(flush_dcache_page);
>
>  /* called by update_mmu_cache. */
>  void __update_cache(struct vm_area_struct *vma, unsigned long address,
> --
> 1.9.2.459.g68773ac
