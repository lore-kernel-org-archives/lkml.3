Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3CDV5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:57:11 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35247 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603Ab3CDV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <014c01ce18ae$fd08c6b0$f71a5410$%han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
	<014c01ce18ae$fd08c6b0$f71a5410$%han@samsung.com>
Date: Mon, 4 Mar 2013 22:56:55 +0100
X-Google-Sender-Auth: 77DPLosf8iFxjCIDGxLYenpG8oc
Message-ID: <CAMuHMdW760mG5XUCU+vwETqU+G0g+cdF7XQzS9xz7GWWuoKH5A@mail.gmail.com>
Subject: Re: [PATCH 19/24] rtc: rtc-rp5c01: use module_platform_driver_probe()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 9:05 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/rtc/rtc-rp5c01.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
> index 359da6d..d25d2f6 100644
> --- a/drivers/rtc/rtc-rp5c01.c
> +++ b/drivers/rtc/rtc-rp5c01.c
> @@ -294,18 +294,7 @@ static struct platform_driver rp5c01_rtc_driver = {
>         .remove = __exit_p(rp5c01_rtc_remove),
>  };
>
> -static int __init rp5c01_rtc_init(void)
> -{
> -       return platform_driver_probe(&rp5c01_rtc_driver, rp5c01_rtc_probe);
> -}
> -
> -static void __exit rp5c01_rtc_fini(void)
> -{
> -       platform_driver_unregister(&rp5c01_rtc_driver);
> -}
> -
> -module_init(rp5c01_rtc_init);
> -module_exit(rp5c01_rtc_fini);
> +module_platform_driver_probe(rp5c01_rtc_driver, rp5c01_rtc_probe);
>
>  MODULE_AUTHOR("Geert Uytterhoeven <geert@linux-m68k.org>");
>  MODULE_LICENSE("GPL");

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
