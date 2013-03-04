Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3CDVzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:55:54 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63789 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3CDVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <014501ce18ae$96f88a90$c4e99fb0$%han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
	<014501ce18ae$96f88a90$c4e99fb0$%han@samsung.com>
Date: Mon, 4 Mar 2013 22:55:52 +0100
X-Google-Sender-Auth: HB3uUu0JBCabKiRNm2Rf6I9_UZM
Message-ID: <CAMuHMdX4w0F_qH66gpvXq=j=k3+6OLk19LPXd2MEbTokjvWxDA@mail.gmail.com>
Subject: Re: [PATCH 12/24] rtc: rtc-msm6242: use module_platform_driver_probe()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 9:02 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/rtc/rtc-msm6242.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
> index fcb113c..3ac1e8e 100644
> --- a/drivers/rtc/rtc-msm6242.c
> +++ b/drivers/rtc/rtc-msm6242.c
> @@ -252,18 +252,7 @@ static struct platform_driver msm6242_rtc_driver = {
>         .remove = __exit_p(msm6242_rtc_remove),
>  };
>
> -static int __init msm6242_rtc_init(void)
> -{
> -       return platform_driver_probe(&msm6242_rtc_driver, msm6242_rtc_probe);
> -}
> -
> -static void __exit msm6242_rtc_fini(void)
> -{
> -       platform_driver_unregister(&msm6242_rtc_driver);
> -}
> -
> -module_init(msm6242_rtc_init);
> -module_exit(msm6242_rtc_fini);
> +module_platform_driver_probe(msm6242_rtc_driver, msm6242_rtc_probe);
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
