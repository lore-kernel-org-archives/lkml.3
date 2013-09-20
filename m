Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3ITHdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:33:51 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61380 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3ITHdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:33:49 -0400
MIME-Version: 1.0
In-Reply-To: <6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
	<6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>
Date: Fri, 20 Sep 2013 09:33:49 +0200
X-Google-Sender-Auth: H1MG3HlV39247A8weZMGap-ILcA
Message-ID: <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Maciej and linux-mips

On Fri, Sep 20, 2013 at 3:53 AM, Joe Perches <joe@perches.com> wrote:
> This driver apparently hasn't compiled since 2.5 days as
> it uses a #define that isn't around anymore.
>
> Remove it.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/video/Kconfig      |  10 -
>  drivers/video/Makefile     |   1 -
>  drivers/video/pmag-aa-fb.c | 510 ---------------------------------------------
>  3 files changed, 521 deletions(-)
>  delete mode 100644 drivers/video/pmag-aa-fb.c
>
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 14317b7..e92798e 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -1821,16 +1821,6 @@ config FB_HIT
>           This is the frame buffer device driver for the Hitachi HD64461 LCD
>           frame buffer card.
>
> -config FB_PMAG_AA
> -       bool "PMAG-AA TURBOchannel framebuffer support"
> -       depends on (FB = y) && TC
> -       select FB_CFB_FILLRECT
> -       select FB_CFB_COPYAREA
> -       select FB_CFB_IMAGEBLIT
> -       help
> -         Support for the PMAG-AA TURBOchannel framebuffer card (1280x1024x1)
> -         used mainly in the MIPS-based DECstation series.
> -
>  config FB_PMAG_BA
>         tristate "PMAG-BA TURBOchannel framebuffer support"
>         depends on FB && TC
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index e8bae8d..5c8b340 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -114,7 +114,6 @@ obj-$(CONFIG_FB_AU1100)               += au1100fb.o
>  obj-$(CONFIG_FB_AU1200)                  += au1200fb.o
>  obj-$(CONFIG_FB_VT8500)                  += vt8500lcdfb.o
>  obj-$(CONFIG_FB_WM8505)                  += wm8505fb.o
> -obj-$(CONFIG_FB_PMAG_AA)         += pmag-aa-fb.o
>  obj-$(CONFIG_FB_PMAG_BA)         += pmag-ba-fb.o
>  obj-$(CONFIG_FB_PMAGB_B)         += pmagb-b-fb.o
>  obj-$(CONFIG_FB_MAXINE)                  += maxinefb.o
> diff --git a/drivers/video/pmag-aa-fb.c b/drivers/video/pmag-aa-fb.c
> deleted file mode 100644

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
