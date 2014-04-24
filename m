Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaDXQqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:46:07 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63608 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDXQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <1398342509-10243-10-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org> <1398342509-10243-10-git-send-email-peter.griffin@linaro.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 24 Apr 2014 09:45:36 -0700
Message-ID: <CAK5ve-KXg-LX2uG9bwg3Q1CZAUa7-a=n07uYs+URjKMs-5F-8A@mail.gmail.com>
Subject: Re: [PATCH 09/13] video/backlight: LP8788 needs PWM
To: Peter Griffin <peter.griffin@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Milo Kim <milo.kim@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        FBDEV list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 5:28 AM, Peter Griffin <peter.griffin@linaro.org> wrote:
> The LP8788 driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
>
> Based on Arnd Bergmann patch but split out into seperate
> commits per driver based on feedback.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: Milo Kim <milo.kim@ti.com>
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
> index 4791af7..ac6bc28 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -393,7 +393,7 @@ config BACKLIGHT_LP855X
>
>  config BACKLIGHT_LP8788
>         tristate "Backlight driver for TI LP8788 MFD"
> -       depends on BACKLIGHT_CLASS_DEVICE && MFD_LP8788
> +       depends on BACKLIGHT_CLASS_DEVICE && MFD_LP8788 && PWM

Looks good to me,
Acked-by: Bryan Wu <cooloney@gmail.com>

>         help
>           This supports TI LP8788 backlight driver.
>
> --
> 1.7.9.5
>
