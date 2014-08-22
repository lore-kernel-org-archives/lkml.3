Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaHVHN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:13:27 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57487 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaHVHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:13:25 -0400
MIME-Version: 1.0
In-Reply-To: <007701cfbdd1$a70486e0$f50d94a0$%han@samsung.com>
References: <007701cfbdd1$a70486e0$f50d94a0$%han@samsung.com>
Date: Fri, 22 Aug 2014 09:13:23 +0200
X-Google-Sender-Auth: PWlAwmEGEdpi9pB27t0Mr7FTR6Q
Message-ID: <CAMuHMdUWwwRC1drp6XOxUOY2zDf4qY62OKT4taRthktGgOM=6g@mail.gmail.com>
Subject: Re: [PATCH] backlight: platform_lcd: remove unnecessary #ifdef CONFIG_OF
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 8:23 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> Remove unnecessary #ifdef CONFIG_OF, because this is already
> handled by the of_match_ptr macro.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/platform_lcd.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
> index c3d2e209fc8f..2bca5ca760ee 100644
> --- a/drivers/video/backlight/platform_lcd.c
> +++ b/drivers/video/backlight/platform_lcd.c
> @@ -137,13 +137,11 @@ static int platform_lcd_resume(struct device *dev)
>  static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
>                         platform_lcd_resume);
>
> -#ifdef CONFIG_OF
>  static const struct of_device_id platform_lcd_of_match[] = {
>         { .compatible = "platform-lcd" },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
> -#endif
>
>  static struct platform_driver platform_lcd_driver = {
>         .driver         = {

Doesn't this introduce a compiler warning ("defined but not used") if
CONFIG_OF is not set?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
