Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaABWnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:43:10 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34389 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaABWnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:43:08 -0500
MIME-Version: 1.0
In-Reply-To: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
References: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 2 Jan 2014 14:42:45 -0800
Message-ID: <CAK5ve-L9RxRouoS=F8CywGW_s_tw4eZzLc4O0=_HdYtaMBVMuQ@mail.gmail.com>
Subject: Re: [PATCH] leds: s3c24xx: Fix build failure
To: Tushar Behera <tushar.behera@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 1:09 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
> Fixes following build error.
> drivers/leds/leds-s3c24xx.c: In function ‘s3c24xx_led_probe’:
> drivers/leds/leds-s3c24xx.c:100:2: error: implicit declaration of
> function ‘s3c_gpio_setpull’ [-Werror=implicit-function-declaration]
>

I don't see any building error with s3c2410_defconfig. Actually this
<plat/gpio-cfg.h> is included in
arch/arm/mach-s3c24xx/include/mach/gpio.h which is in
arch/arm/include/asm/gpio.h, then <linux/gpio.h>

Thanks,
-Bryan

> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
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
