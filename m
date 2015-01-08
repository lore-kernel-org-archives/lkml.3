Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbbAHDa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 22:30:26 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:54192 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbbAHDaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 22:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <1420673754-6645-1-git-send-email-festevam@gmail.com>
References: <1420673754-6645-1-git-send-email-festevam@gmail.com>
Date: Thu, 8 Jan 2015 11:30:24 +0800
Message-ID: <CA+8Hj82JWcb_+cvc6d75rd-2C_AiMmZwOAOFa2gTq2f1RpTz8A@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx_v6_v7_defconfig: Select CONFIG_FB_MXS
From: Liu Ying <liu.y.victor@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-08 7:35 GMT+08:00 Fabio Estevam <festevam@gmail.com>:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> CONFIG_FB_MXS is the LCD driver for mx6solo-lite and mx6solox.
>
> Enable it by default.

I'm not sure if it is suitable to enable CONFIG_FB_MXS by default.
At least, I have no strong objections.

I am considering to add a LCDIF CRTC driver to the imx-drm framework
so that we may use the existing LDB drm driver to support the mx6solox
LVDS interface.

I see the i915 and omap2 fb drivers depend on !DRM_XXXX:

grep DRM_ drivers/video/fbdev/ -nr
drivers/video/fbdev/omap2/omapfb/Kconfig:3:        depends on FB &&
OMAP2_DSS && !DRM_OMAP
drivers/video/fbdev/Kconfig:1197:       depends on !DRM_I915

So, similarly, we'll probably have two LCDIF drivers and make the DRM
one enabled by default - finally, CONFIG_FB_MXS is disabled.

Another concern is the compatibility. Since both the framebuffer driver
and the imx-drm driver would export the framebuffer interface to the
user space, we'd better to keep the interface behavior the same.
Maybe, this is not a big problem, because we need to keep the compatibility
anyway...

Regards,
Liu Ying

>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  arch/arm/configs/imx_v6_v7_defconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
> index 9575af8..1f36977 100644
> --- a/arch/arm/configs/imx_v6_v7_defconfig
> +++ b/arch/arm/configs/imx_v6_v7_defconfig
> @@ -203,6 +203,7 @@ CONFIG_DRM_PANEL_SIMPLE=y
>  CONFIG_LCD_CLASS_DEVICE=y
>  CONFIG_LCD_L4F00242T03=y
>  CONFIG_LCD_PLATFORM=y
> +CONFIG_FB_MXS=y
>  CONFIG_BACKLIGHT_PWM=y
>  CONFIG_BACKLIGHT_GPIO=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best Regards,
Liu Ying
