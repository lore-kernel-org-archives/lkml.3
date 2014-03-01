Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaCARi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 12:38:28 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46751 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaCARi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 12:38:27 -0500
MIME-Version: 1.0
In-Reply-To: <1393689748-32236-2-git-send-email-gidisrael@gmail.com>
References: <1393689748-32236-1-git-send-email-gidisrael@gmail.com>
	<1393689748-32236-2-git-send-email-gidisrael@gmail.com>
Date: Sat, 1 Mar 2014 18:38:27 +0100
X-Google-Sender-Auth: _Z4mFhT55Om9s11KK7rZnKoRVww
Message-ID: <CAMuHMdUiE5QxZZxx-U0W6G=mwGjS8deemMZy_ib5FYmnx6VD+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: use macros from compiler.h instead of __attribute__((...))
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 1, 2014 at 5:02 PM, Gideon Israel Dsouza
<gidisrael@gmail.com> wrote:
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -9,6 +9,8 @@
>  #include <linux/export.h>
>  #include <linux/spinlock.h>
>  #include <linux/vmalloc.h>
> +#include <linux/compiler.h>

Please try to insert new includes in alphabetical order, to avoid
merge conflicts.
It's no always easy, as lots of include lists are not sorted at all.

> +
>  #include "internal.h"
>  #include <asm/dma.h>
>  #include <asm/pgalloc.h>
> @@ -459,9 +461,9 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
>         ms->section_mem_map = 0;
>         return NULL;
>  }
> -#endif
> +endif

Woops, this won't compile?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
