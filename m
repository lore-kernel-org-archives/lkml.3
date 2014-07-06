Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaGFI7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 04:59:34 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44209 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaGFI7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 04:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <1404637121-1253-1-git-send-email-geert@linux-m68k.org>
References: <1404637121-1253-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 6 Jul 2014 10:59:31 +0200
X-Google-Sender-Auth: p3XTmMn_jsbhOAQDnqczRXav8q0
Message-ID: <CAMuHMdUmQRk8uVyN-+thbfYWVQPsCRHpyEU3T2PSdtN6GPM-gw@mail.gmail.com>
Subject: Re: [PATCH] [media] staging/solo6x10: SOLO6X10 should select BITREVERSE
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC kbuild test robot <fengguang.wu@intel.com>

On Sun, Jul 6, 2014 at 10:58 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> If CONFIG_SOLO6X10=y, but CONFIG_BITREVERSE=m:
>
>     drivers/built-in.o: In function `solo_osd_print':
>     (.text+0x1c7a1f): undefined reference to `byte_rev_table'
>     make: *** [vmlinux] Error 1
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/staging/media/solo6x10/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
> index 6a1906fa1117..1ce2819efcb4 100644
> --- a/drivers/staging/media/solo6x10/Kconfig
> +++ b/drivers/staging/media/solo6x10/Kconfig
> @@ -1,6 +1,7 @@
>  config SOLO6X10
>         tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
>         depends on PCI && VIDEO_DEV && SND && I2C
> +       select BITREVERSE
>         select FONT_SUPPORT
>         select FONT_8x16
>         select VIDEOBUF2_DMA_SG

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
