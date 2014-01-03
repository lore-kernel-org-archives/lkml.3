Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaACGUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:20:03 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:39932 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaACGUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:20:00 -0500
MIME-Version: 1.0
In-Reply-To: <1388726757-7387-1-git-send-email-tushar.behera@linaro.org>
References: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org> <1388726757-7387-1-git-send-email-tushar.behera@linaro.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 2 Jan 2014 22:19:38 -0800
Message-ID: <CAK5ve-K0aCVTo+21G47M0aYT8f-vkqLAd9etWxSY+ieib8KfMQ@mail.gmail.com>
Subject: Re: [PATCH V2] leds: s3c24xx: Fix build failure
To: Tushar Behera <tushar.behera@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 9:25 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> Commit c67d0f29262b ("ARM: s3c24xx: get rid of custom <mach/gpio.h>")
> removed the usage of mach/gpio.h file, but we need to include
> plat/gpio-cfg.h to avoid following build error.
>
> Fixes following build error.
> drivers/leds/leds-s3c24xx.c: In function ‘s3c24xx_led_probe’:
> drivers/leds/leds-s3c24xx.c:100:2: error: implicit declaration of
> function ‘s3c_gpio_setpull’ [-Werror=implicit-function-declaration]
>

I think this patch should go with Linus's patchset.

-Bryan

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Changes for V2:
> * Updated commit message
>
> Bryan,
>
> I should have been more explicit regarding this patch. This patch fixes
> build error on linux-next after the above patch was merged.
>
> Tested at next-20131224.
>
>  drivers/leds/leds-s3c24xx.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
> index 76483fb..87cf215 100644
> --- a/drivers/leds/leds-s3c24xx.c
> +++ b/drivers/leds/leds-s3c24xx.c
> @@ -21,6 +21,7 @@
>
>  #include <mach/hardware.h>
>  #include <mach/regs-gpio.h>
> +#include <plat/gpio-cfg.h>
>  #include <linux/platform_data/leds-s3c24xx.h>
>
>  /* our context */
> --
> 1.7.9.5
>
