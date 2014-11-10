Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaKJI5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:57:49 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:56433 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaKJI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:57:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140719113513.GA23586@himangi-Dell>
References: <20140719113513.GA23586@himangi-Dell>
Date: Mon, 10 Nov 2014 09:57:45 +0100
X-Google-Sender-Auth: NUOM9_nJU9RSk6whk3DczYRIB1o
Message-ID: <CAMuHMdX46dEKLm6cD3gEEvc_aW52NAKgWG5zNmthCs5jMciU3g@mail.gmail.com>
Subject: Re: [PATCH] mm/m68k: Eliminate memset after alloc_bootmem_pages
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 1:35 PM, Himangi Saraogi <himangi774@gmail.com> wrote:
> alloc_bootmem and related functions always return a zeroed region of memory.
> Thus a memset after calls to these functions is unnecessary.
>
> The following Coccinelle semantic patch was used for making the change:
>
> @@
> expression E,E1;
> @@
>
> E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
> ... when != E
> - memset(E,0,E1);
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Thanks, applied and queued for v3.19.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
