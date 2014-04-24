Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaDXQpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:45:42 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63606 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDXQpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org> <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 24 Apr 2014 09:45:14 -0700
Message-ID: <CAK5ve-+J9-u-CMiJq-24eAvP_Hi6ZN41GUkbs4MF7yWaQfGiaA@mail.gmail.com>
Subject: Re: [PATCH 08/13] video/backlight: LM3630A needs PWM
To: Peter Griffin <peter.griffin@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        FBDEV list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 5:28 AM, Peter Griffin <peter.griffin@linaro.org> wrote:
> The LM3630A driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
>
> Based on Arnd Bergmann patch but split out into seperate
> commits per driver based on feedback.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 5a3eb2e..4791af7 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -370,7 +370,7 @@ config BACKLIGHT_AAT2870
>
>  config BACKLIGHT_LM3630A
>         tristate "Backlight Driver for LM3630A"
> -       depends on BACKLIGHT_CLASS_DEVICE && I2C
> +       depends on BACKLIGHT_CLASS_DEVICE && I2C && PWM

Looks good to me,
Acked-by: Bryan Wu <cooloney@gmail.com>

>         select REGMAP_I2C
>         help
>           This supports TI LM3630A Backlight Driver
> --
> 1.7.9.5
>
