Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965497AbaDJESi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:18:38 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55259 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934594AbaDJERt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 00:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com> <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 10 Apr 2014 13:17:29 +0900
Message-ID: <CAAVeFu+XUzZ7ozMOcp6A-gZJ9o8DZFrdh1j4LvCQtoTcu=PP1g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: SAMSUNG: remove gpio flags in dev-backlight
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, can I have the Samsung folks review and ,aybe even merge this
patch? enable_gpio_flags is never used in any code, is replaced by
gpiod, and we would like to remove it altogether from pwm_bl. Thanks!

Alex.

On Thu, Feb 27, 2014 at 2:53 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> The pwm-backlight driver is moving to use the gpiod interface,
> which has its own mapping mechanism for platform data GPIOs.
> These mappings carry GPIO properties like active low so they don't have
> to be explicitly handled by GPIO consumers.
>
> Because of this change, the enable_gpio_flags member of
> platform_pwm_backlight_data is going away. dev-backlight was passing
> this member, but had no user making use of it, so it can safely be
> removed. Further GPIOs used by pwm-backlight are expected to be
> defined using the mechanisms provided by the gpiod API.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/plat-samsung/dev-backlight.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/plat-samsung/dev-backlight.c b/arch/arm/plat-samsung/dev-backlight.c
> index be4ad0b21c08..2157c5b539e6 100644
> --- a/arch/arm/plat-samsung/dev-backlight.c
> +++ b/arch/arm/plat-samsung/dev-backlight.c
> @@ -124,8 +124,6 @@ void __init samsung_bl_set(struct samsung_bl_gpio_info *gpio_info,
>                 samsung_bl_data->pwm_period_ns = bl_data->pwm_period_ns;
>         if (bl_data->enable_gpio >= 0)
>                 samsung_bl_data->enable_gpio = bl_data->enable_gpio;
> -       if (bl_data->enable_gpio_flags)
> -               samsung_bl_data->enable_gpio_flags = bl_data->enable_gpio_flags;
>         if (bl_data->init)
>                 samsung_bl_data->init = bl_data->init;
>         if (bl_data->notify)
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
