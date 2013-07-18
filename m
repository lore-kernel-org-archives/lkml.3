Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab3GRRVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:21:15 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53296 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab3GRRVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <20968.8776.742486.828059@quad.stoffel.home>
References: <1374166572-7988-1-git-send-email-uulinux@gmail.com>
	<20968.8776.742486.828059@quad.stoffel.home>
Date: Fri, 19 Jul 2013 01:21:12 +0800
Message-ID: <CAAV+Mu6npcxE9b8qcgKaVdnKESxefhdZccP3chuggOq0c7NCqA@mail.gmail.com>
Subject: Re: [PATCH] mm: negative left shift count when PAGE_SHIFT > 20
From: Jerry <uulinux@gmail.com>
To: John Stoffel <john@stoffel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, zhuwei.lu@archermind.com,
        tianfu.huang@archermind.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jerry> When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
> Jerry> calculating here will generate an unexpected result. In addition, if
> Jerry> PAGE_SHIFT > 20, The memory size represented by numentries was already
> Jerry> integral multiple of 1MB.
>
> Why this magic number of 20?  Please explain it better and replace it
> was a #define that means something here.

Because 2^20 = 1MB.

The intention of previous code is "/* round applicable memory size up
to nearest megabyte */".

>
> Jerry> Signed-off-by: Jerry <uulinux@gmail.com>
> Jerry> ---
> Jerry>  mm/page_alloc.c | 8 +++++---
> Jerry>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> Jerry> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> Jerry> index b100255..cd41797 100644
> Jerry> --- a/mm/page_alloc.c
> Jerry> +++ b/mm/page_alloc.c
> Jerry> @@ -5745,9 +5745,11 @@ void *__init alloc_large_system_hash(const char *tablename,
> Jerry>          if (!numentries) {
> Jerry>                  /* round applicable memory size up to nearest megabyte */
> Jerry>                  numentries = nr_kernel_pages;
> Jerry> -                numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
> Jerry> -                numentries >>= 20 - PAGE_SHIFT;
> Jerry> -                numentries <<= 20 - PAGE_SHIFT;
> Jerry> +                if (20 > PAGE_SHIFT) {
> Jerry> +                        numentries += (1UL << (20 - PAGE_SHIFT)) - 1;
> Jerry> +                        numentries >>= 20 - PAGE_SHIFT;
> Jerry> +                        numentries <<= 20 - PAGE_SHIFT;
> Jerry> +                }
>
> Jerry>                  /* limit to 1 bucket per 2^scale bytes of low memory */
> Jerry>                  if (scale > PAGE_SHIFT)
> Jerry> --
> Jerry> 1.8.1.5
>
> Jerry> --
> Jerry> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> Jerry> the body of a message to majordomo@vger.kernel.org
> Jerry> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Jerry> Please read the FAQ at  http://www.tux.org/lkml/



--
I love linux!!!
