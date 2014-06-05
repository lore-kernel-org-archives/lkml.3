Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbaFEAFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:05:49 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44788 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbaFEAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:05:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1406041450310.21286@lnfm1.sai.msu.ru>
References: <alpine.LRH.2.00.1406041450310.21286@lnfm1.sai.msu.ru>
Date: Wed, 4 Jun 2014 20:05:46 -0400
Message-ID: <CAF6AEGvLJeF4QVXkTh2YLLePqQ4h4j+igixeX5HL8o=x4S=CuQ@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: msm: Replace type of paddr to uint32_t.
From: Rob Clark <robdclark@gmail.com>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Airlie <airlied@linux.ie>, linux-arm-msm@vger.kernel.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        matwey.kornilov@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 6:54 AM, Matwey V. Kornilov <matwey@sai.msu.ru> wrote:
> From e7147352639fd8f92b1cc85cff9bc5046c7a2130 Mon Sep 17 00:00:00 2001
> From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
> Date: Mon, 2 Jun 2014 20:17:29 +0400
> Subject: [PATCH] Replace type of paddr to uint32_t.
>
> This patch helps to avoid the following build issue:
>
> drivers/gpu/drm/msm/msm_fbdev.c:108:2: error: passing argument 3 of
> 'msm_gem_get_iova_locked' from incompatible pointer type [-Werror]
>   msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
>   ^
> In file included from drivers/gpu/drm/msm/msm_fbdev.c:18:0:
> drivers/gpu/drm/msm/msm_drv.h:153:5: note: expected 'uint32_t *' but
> argument is of type 'dma_addr_t *'
>  int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
>      ^
>
> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>

Reviewed-by: Rob Clark <robdclark@gmail.com>

> ---
>  drivers/gpu/drm/msm/msm_fbdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_fbdev.c
> b/drivers/gpu/drm/msm/msm_fbdev.c
> index a752ab8..5107fc4 100644
> --- a/drivers/gpu/drm/msm/msm_fbdev.c
> +++ b/drivers/gpu/drm/msm/msm_fbdev.c
> @@ -59,7 +59,7 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
>         struct drm_framebuffer *fb = NULL;
>         struct fb_info *fbi = NULL;
>         struct drm_mode_fb_cmd2 mode_cmd = {0};
> -       dma_addr_t paddr;
> +       uint32_t paddr;
>         int ret, size;
>
>         sizes->surface_bpp = 32;
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
