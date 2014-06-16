Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaFPQGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:06:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41393 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaFPQGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <1402929569-14500-1-git-send-email-j@bitron.ch>
References: <1402929569-14500-1-git-send-email-j@bitron.ch>
Date: Mon, 16 Jun 2014 18:06:14 +0200
X-Google-Sender-Auth: jtbRTFqyfdlOQIbrYHogUTkrxpo
Message-ID: <CAMuHMdWVEsn7=Z69xMFb-HZxUbc4iDtUnY7mp1i_tn9k1X_JsA@mail.gmail.com>
Subject: Re: [PATCH] spi: sh-sci: fix use-after-free in sh_sci_spi_remove()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?J=C3=BCrg_Billeter?= <j@bitron.ch>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 4:39 PM, Jürg Billeter <j@bitron.ch> wrote:
> setbits() uses sp->membase.
>
> Signed-off-by: Jürg Billeter <j@bitron.ch>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/spi/spi-sh-sci.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi-sh-sci.c b/drivers/spi/spi-sh-sci.c
> index 1f56ef6..b83dd73 100644
> --- a/drivers/spi/spi-sh-sci.c
> +++ b/drivers/spi/spi-sh-sci.c
> @@ -175,9 +175,9 @@ static int sh_sci_spi_remove(struct platform_device *dev)
>  {
>         struct sh_sci_spi *sp = platform_get_drvdata(dev);
>
> -       iounmap(sp->membase);
> -       setbits(sp, PIN_INIT, 0);
>         spi_bitbang_stop(&sp->bitbang);
> +       setbits(sp, PIN_INIT, 0);
> +       iounmap(sp->membase);
>         spi_master_put(sp->bitbang.master);
>         return 0;
>  }
> --
> 2.0.0

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
