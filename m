Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbaDPQHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:07:01 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:60306 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422635AbaDPQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <201404160847.27300.sfking@fdwdc.com>
References: <201404141745.44279.sfking@fdwdc.com>
	<20140416001931.GA17350@js1304-P5Q-DELUXE>
	<201404160847.27300.sfking@fdwdc.com>
Date: Wed, 16 Apr 2014 18:06:57 +0200
X-Google-Sender-Auth: TMCjopFpN5VEB6yrXJ_R9PCNTL0
Message-ID: <CAMuHMdV2zSWaDbHNv3QQeEgu26PQX9TWn7cHA=4U0YOK0bbExg@mail.gmail.com>
Subject: Re: [uClinux-dev] v3.15-rc1 slab allocator broken on m68knommu (coldfire)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven King <sfking@fdwdc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, Apr 16, 2014 at 5:47 PM, Steven King <sfking@fdwdc.com> wrote:
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache *cachep,
>         return freelist;
>  }
>
> -static inline freelist_idx_t get_free_obj(struct page *page, unsigned char idx)
> +static inline freelist_idx_t get_free_obj(struct page *page, unsigned int idx)
>  {
>         return ((freelist_idx_t *)page->freelist)[idx];
>  }
>
>  static inline void set_free_obj(struct page *page,
> -                                       unsigned char idx, freelist_idx_t val)
> +                                       unsigned int idx, freelist_idx_t val)
>  {
>         ((freelist_idx_t *)(page->freelist))[idx] = val;
>  }
>
>
> then v3.15-rc1 will boot using the slab allocator.

Is "idx" ever larger than 255?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
