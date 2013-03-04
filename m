Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab3CDV43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:56:29 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:42754 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3CDV42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:56:28 -0500
MIME-Version: 1.0
In-Reply-To: <014a01ce18ae$e294c5e0$a7be51a0$%han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
	<014a01ce18ae$e294c5e0$a7be51a0$%han@samsung.com>
Date: Mon, 4 Mar 2013 22:56:27 +0100
X-Google-Sender-Auth: lXWlrf_dOx9WeRtvztOyzwTh6oQ
Message-ID: <CAMuHMdW_rXNRLs4Och6KdEpbnN32uf_Mj3RM79N_ovz+kpz=Qg@mail.gmail.com>
Subject: Re: [PATCH 17/24] rtc: rtc-ps3: use module_platform_driver_probe()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 9:04 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/rtc/rtc-ps3.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
> index 968133c..846722d 100644
> --- a/drivers/rtc/rtc-ps3.c
> +++ b/drivers/rtc/rtc-ps3.c
> @@ -85,18 +85,7 @@ static struct platform_driver ps3_rtc_driver = {
>         .remove = __exit_p(ps3_rtc_remove),
>  };
>
> -static int __init ps3_rtc_init(void)
> -{
> -       return platform_driver_probe(&ps3_rtc_driver, ps3_rtc_probe);
> -}
> -
> -static void __exit ps3_rtc_fini(void)
> -{
> -       platform_driver_unregister(&ps3_rtc_driver);
> -}
> -
> -module_init(ps3_rtc_init);
> -module_exit(ps3_rtc_fini);
> +module_platform_driver_probe(ps3_rtc_driver, ps3_rtc_probe);
>
>  MODULE_AUTHOR("Sony Corporation");
>  MODULE_LICENSE("GPL");

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
