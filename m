Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3IRAIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:08:18 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47086 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IRAIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <1379366394.3828.10.camel@localhost.localdomain>
References: <1379366394.3828.10.camel@localhost.localdomain>
Date: Tue, 17 Sep 2013 20:08:15 -0400
Message-ID: <CAF6AEGt28s5vDAxoZ9U6ibm7zVZWrFfH_sBe+w3RczCr_kYaBg@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Odd PTR_ERR usage
From: Rob Clark <robdclark@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 5:19 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> The variable priv->kms is not initialized yet.
>
> Found by "scripts/coccinelle/tests/odd_ptr_err.cocci".
> PTR_ERR should access the value just tested by IS_ERR.
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

thanks, I've got it queued up

BR,
-R

> ---
>
> diff -u -p a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -199,7 +199,7 @@ static int msm_load(struct drm_device *d
>                  * imx drm driver on iMX5
>                  */
>                 dev_err(dev->dev, "failed to load kms\n");
> -               ret = PTR_ERR(priv->kms);
> +               ret = PTR_ERR(kms);
>                 goto fail;
>         }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
