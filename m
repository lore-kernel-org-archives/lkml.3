Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaFWIlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:41:17 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51471 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbaFWIkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140616201004.GA18240@himangi-Dell>
References: <20140616201004.GA18240@himangi-Dell>
Date: Mon, 23 Jun 2014 10:40:41 +0200
X-Google-Sender-Auth: 6huBeMCH5iyty1KKVxR7RGcr7pE
Message-ID: <CAMuHMdVMy6-QPS+JcFQO8LH-BnzjmcaaD_c005WrWqsJ3GQ7Fw@mail.gmail.com>
Subject: Re: [PATCH] zorro: use ARRAY_SIZE
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:10 PM, Himangi Saraogi <himangi774@gmail.com> wrote:
> ARRAY_SIZE is more concise to use when the size of an array is divided
> by the size of its type or the size of its first element.
>
> The Coccinelle semantic patch that makes this change is as follows:
>
> // <smpl>
> @@
> type T;
> T[] E;
> @@
>
> - (sizeof(E)/sizeof(T))
> + ARRAY_SIZE(E)
> // </smpl>
>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

Thanks!

Will apply and queue for v3.17.
I also converted the MANUF definition a few lines above:

-#define MANUF( manuf, name )           { 0x##manuf,
sizeof(__prods_##manuf) / sizeof(struct zorro_prod_info),
__manufstr_##manuf, __prods_##manuf },
+#define MANUF( manuf, name )           { 0x##manuf,
ARRAY_SIZE(__prods_##manuf), __manufstr_##manuf, __prods_##manuf },

> ---
>  drivers/zorro/names.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/zorro/names.c b/drivers/zorro/names.c
> index 6f3fd99..4ccbcc9 100644
> --- a/drivers/zorro/names.c
> +++ b/drivers/zorro/names.c
> @@ -52,7 +52,7 @@ static struct zorro_manuf_info __initdata zorro_manuf_list[] = {
>  #include "devlist.h"
>  };
>
> -#define MANUFS (sizeof(zorro_manuf_list)/sizeof(struct zorro_manuf_info))
> +#define MANUFS ARRAY_SIZE(zorro_manuf_list)
>
>  void __init zorro_name_device(struct zorro_dev *dev)
>  {

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
