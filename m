Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaHRV2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:28:36 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56980 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaHRV2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <1408396422-32658-2-git-send-email-bobby.prani@gmail.com>
References: <1408396422-32658-1-git-send-email-bobby.prani@gmail.com>
	<1408396422-32658-2-git-send-email-bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 23:28:33 +0200
X-Google-Sender-Auth: Q8YO7JXTe5hdZtCeUBFQHw2fjDw
Message-ID: <CAMuHMdV_vAPCPh1JdCxtf0iz6haHULUV8t0oYt0jrEAky2WSLw@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build error for vga16fb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>, Jean Delvare <jdelvare@suse.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@linaro.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pranith,

On Mon, Aug 18, 2014 at 11:13 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Fix a build error caused by
>
> drivers/built-in.o: In function `vga16fb_probe':
> drivers/video/fbdev/vga16fb.c:1326: undefined reference to `vgacon_remap_base'
> drivers/video/fbdev/vga16fb.c:1326: undefined reference to `vgacon_remap_base'
> make: *** [vmlinux] Error 1
>
> This is occuring as vgacon_remap_base is exported only when
> CONFIG_VGA_CONSOLE=y. Fix the error by making FB_VBA16 depend on
> CONFIG_VGA_CONSOLE.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/video/fbdev/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
> index e911b9c..09df564 100644
> --- a/drivers/video/fbdev/Kconfig
> +++ b/drivers/video/fbdev/Kconfig
> @@ -547,7 +547,7 @@ config FB_IMSTT
>
>  config FB_VGA16
>         tristate "VGA 16-color graphics support"
> -       depends on FB && (X86 || PPC)
> +       depends on FB && (X86 || PPC) && CONFIG_VGA_CONSOLE

The dependency on CONFIG_VGA_CONSOLE only exists on PPC, not on x86.
So this is not correct.

Digging a bit deeper: There's no code left in arch/powerpc that actually
sets vgacon_remap_base, so it's not gonna work anyway.
It seems vga16 support on PPC died with the removal of arch/ppc/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
