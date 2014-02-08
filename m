Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBHVTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:19:24 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46242 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBHVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:19:22 -0500
MIME-Version: 1.0
In-Reply-To: <1391893281.19595.3.camel@x220>
References: <1391893281.19595.3.camel@x220>
Date: Sat, 8 Feb 2014 22:19:21 +0100
X-Google-Sender-Auth: fP6yfV5YIYTjpdks5TzYZqBiN9M
Message-ID: <CAMuHMdXV3N5ReDDkp2PEfF0sOFJxQw0pECBGgWmrg9Ex6YE-LQ@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2: use SUPERH, not SH
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 8, 2014 at 10:01 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Commit 0079aae0f1e6 ("spi: omap2: Add build dependencies for
> writel_relaxed()") added an optional Kconfig dependency on SH. That
> Kconfig symbol doesn't exist. Apparently SUPERH was intended. Use that.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Nice catch!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

BTW, MICROBLAZE can be added as well. It got writel_relaxed() in
v3.14-rc1.

> ---
> Basically untested.
>
>  drivers/spi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index ba9310b..205dbfe 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -307,7 +307,7 @@ config SPI_OMAP_UWIRE
>
>  config SPI_OMAP24XX
>         tristate "McSPI driver for OMAP"
> -       depends on ARM || ARM64 || AVR32 || HEXAGON || MIPS || SH
> +       depends on ARM || ARM64 || AVR32 || HEXAGON || MIPS || SUPERH
>         depends on ARCH_OMAP2PLUS || COMPILE_TEST
>         help
>           SPI master controller for OMAP24XX and later Multichannel SPI

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
