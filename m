Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaDXUsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:48:50 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52120 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaDXUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <1393873736-26867-1-git-send-email-balbi@ti.com>
References: <1393873736-26867-1-git-send-email-balbi@ti.com>
Date: Thu, 24 Apr 2014 16:48:48 -0400
Message-ID: <CAF6AEGvBt=KVk5q2DNhOrkZ=ZiG=V9SdEDDsDj69Z0phAa30+Q@mail.gmail.com>
Subject: Re: [PATCH] drm/tilcdc: restore correct display mode and contents on
 pm resume
From: Rob Clark <robdclark@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: David Airlie <airlied@linux.ie>, "airlied@redhat.com" <airlied@redhat.com>,
        Benoit Parrot <bparrot@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 2:08 PM, Felipe Balbi <balbi@ti.com> wrote:
> From: Darren Etheridge <detheridge@ti.com>
>
> On resume the screen contents were not being restored properly.  Looking at
> other DRM drivers it seems a call to drm_helper_resume_force_mode() is needed
> in the resume handler to force restoration of the mode and framebuffer data.
>
> Signed-off-by: Darren Etheridge <detheridge@ti.com>

Reviewed-by: Rob Clark <robdclark@gmail.com>

> ---
>  drivers/gpu/drm/tilcdc/tilcdc_drv.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> index 171a820..1a5ddfa 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> @@ -563,6 +563,13 @@ static int tilcdc_pm_resume(struct device *dev)
>                 if (registers[i].save && (priv->rev >= registers[i].rev))
>                         tilcdc_write(ddev, registers[i].reg, priv->saved_register[n++]);
>
> +       /*
> +        * if this call isn't here, the display is blank on return from
> +        * suspend.  With this call here the contents of the framebuffer
> +        * during suspend are restored correctly.
> +        */
> +       drm_helper_resume_force_mode(ddev);
> +
>         drm_kms_helper_poll_enable(ddev);
>
>         return 0;
> --
> 1.9.0
>
