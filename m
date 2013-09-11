Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3IKL1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:27:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61447 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3IKL0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_NrAGkJ+Ufw1nbfSDc_nzq1qdX1VFtmrgrYR6=0hGK0w@mail.gmail.com>
References: <CAPgLHd_NrAGkJ+Ufw1nbfSDc_nzq1qdX1VFtmrgrYR6=0hGK0w@mail.gmail.com>
Date: Wed, 11 Sep 2013 07:26:47 -0400
Message-ID: <CAF6AEGv9XS+VrPmB4-26pzjr97WEvaCXQgk7000sOznAZnZj8A@mail.gmail.com>
Subject: Re: [PATCH] drm/omap: fix error return code in omap_dmm_probe()
From: Rob Clark <robdclark@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Greg KH <gregkh@linuxfoundation.org>,
        Andy Gross <andy.gross@ti.com>, joe@perches.com,
        yongjun_wei@trendmicro.com.cn,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 7:16 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENOMEM in the refill memory alloc error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks

Reviewed-by: Rob Clark <robdclark@gmail.com>

> ---
>  drivers/gpu/drm/omapdrm/omap_dmm_tiler.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
> index 9b794c9..ab546c9 100644
> --- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
> +++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
> @@ -675,6 +675,7 @@ static int omap_dmm_probe(struct platform_device *dev)
>                                 &omap_dmm->refill_pa, GFP_KERNEL);
>         if (!omap_dmm->refill_va) {
>                 dev_err(&dev->dev, "could not allocate refill memory\n");
> +               ret = -ENOMEM;
>                 goto fail;
>         }
>
>
