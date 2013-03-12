Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3CLEM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:12:58 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:40674 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3CLEM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <1363029923-22122-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363029923-22122-1-git-send-email-gheorghiuandru@gmail.com>
Date: Tue, 12 Mar 2013 13:12:55 +0900
X-Google-Sender-Auth: EDD-_9eDY5QQumAIcXX6Ms4_ZcQ
Message-ID: <CAAQKjZMcdE5v0u952+W8xCve-coxuf7m2ztfO6mH0MD97rnY2Q@mail.gmail.com>
Subject: Re: [PATCH] drivers: gpu: drm: exynos: Replaced kzalloc & memcpy with kmemdup
From: Inki Dae <inki.dae@samsung.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

Thanks,
Inki Dae

2013/3/12 Alexandru Gheorghiu <gheorghiuandru@gmail.com>:
> Replaced calls to kzalloc followed by memcpy with call to kmemdup.
> Patch found using coccinelle.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_vidi.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> index 13ccbd4..9504b0c 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
> @@ -117,13 +117,12 @@ static struct edid *vidi_get_edid(struct device *dev,
>         }
>
>         edid_len = (1 + ctx->raw_edid->extensions) * EDID_LENGTH;
> -       edid = kzalloc(edid_len, GFP_KERNEL);
> +       edid = kmemdup(ctx->raw_edid, edid_len, GFP_KERNEL);
>         if (!edid) {
>                 DRM_DEBUG_KMS("failed to allocate edid\n");
>                 return ERR_PTR(-ENOMEM);
>         }
>
> -       memcpy(edid, ctx->raw_edid, edid_len);
>         return edid;
>  }
>
> @@ -563,12 +562,11 @@ int vidi_connection_ioctl(struct drm_device *drm_dev, void *data,
>                         return -EINVAL;
>                 }
>                 edid_len = (1 + raw_edid->extensions) * EDID_LENGTH;
> -               ctx->raw_edid = kzalloc(edid_len, GFP_KERNEL);
> +               ctx->raw_edid = kmemdup(raw_edid, edid_len, GFP_KERNEL);
>                 if (!ctx->raw_edid) {
>                         DRM_DEBUG_KMS("failed to allocate raw_edid.\n");
>                         return -ENOMEM;
>                 }
> -               memcpy(ctx->raw_edid, raw_edid, edid_len);
>         } else {
>                 /*
>                  * with connection = 0, free raw_edid
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
