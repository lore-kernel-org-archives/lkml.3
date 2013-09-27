Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3I0DMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:12:32 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49006 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3I0DMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <1380232016-25368-1-git-send-email-vincent.stehle@laposte.net>
References: <1380232016-25368-1-git-send-email-vincent.stehle@laposte.net>
Date: Fri, 27 Sep 2013 05:12:29 +0200
Message-ID: <CAMeQTsZoPoDBeBrnM9zRLo8qKjm0+ZtZ15NeUqt_imJUNg-M2Q@mail.gmail.com>
Subject: Re: [PATCH] gma500: define do_gma_backlight_set only when used
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@laposte.net>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:46 PM, Vincent Stehlé
<vincent.stehle@laposte.net> wrote:
> Make sure static function do_gma_backlight_set() is only defined when
> CONFIG_BACKLIGHT_CLASS_DEVICE is defined, as it is never called otherwise.
>
> This fixes the following warning:
>
>   drivers/gpu/drm/gma500/backlight.c:29:13: warning: ‘do_gma_backlight_set’ defined but not used [-Wunused-function]
>
> While at it, remove some end of line spaces.
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: David Airlie <airlied@linux.ie>
> ---
>
> Hi,
>
> This can be seen with mainline or linux-next with e.g. allmodconfig on x86.
>
> Best regards,
>
> V.
>
>  drivers/gpu/drm/gma500/backlight.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/backlight.c b/drivers/gpu/drm/gma500/backlight.c
> index 143eba3..399731e 100644
> --- a/drivers/gpu/drm/gma500/backlight.c
> +++ b/drivers/gpu/drm/gma500/backlight.c
> @@ -26,13 +26,13 @@
>  #include "intel_bios.h"
>  #include "power.h"
>
> +#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
>  static void do_gma_backlight_set(struct drm_device *dev)
>  {
> -#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
>         struct drm_psb_private *dev_priv = dev->dev_private;
>         backlight_update_status(dev_priv->backlight_device);
> -#endif
>  }
> +#endif
>
>  void gma_backlight_enable(struct drm_device *dev)
>  {
> @@ -43,7 +43,7 @@ void gma_backlight_enable(struct drm_device *dev)
>                 dev_priv->backlight_device->props.brightness = dev_priv->backlight_level;
>                 do_gma_backlight_set(dev);
>         }
> -#endif
> +#endif
>  }
>
>  void gma_backlight_disable(struct drm_device *dev)
> @@ -55,7 +55,7 @@ void gma_backlight_disable(struct drm_device *dev)
>                 dev_priv->backlight_device->props.brightness = 0;
>                 do_gma_backlight_set(dev);
>         }
> -#endif
> +#endif
>  }
>
>  void gma_backlight_set(struct drm_device *dev, int v)
> @@ -67,7 +67,7 @@ void gma_backlight_set(struct drm_device *dev, int v)
>                 dev_priv->backlight_device->props.brightness = v;
>                 do_gma_backlight_set(dev);
>         }
> -#endif
> +#endif
>  }
>
>  int gma_backlight_init(struct drm_device *dev)
> --
> 1.8.4.rc3

Thanks, looks good, I'll apply it to the gma500-fixes branch.

Acked-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
