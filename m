Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbbAIEBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:01:44 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42998 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbbAIEBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <1420622830-8608-1-git-send-email-djkurtz@chromium.org>
References: <1420622830-8608-1-git-send-email-djkurtz@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 9 Jan 2015 12:01:21 +0800
X-Google-Sender-Auth: dnNMSnh4uKRnRNQjRoV9YTkYQ88
Message-ID: <CAGS+omALWyadW50tmU+FbfFGj9RgjQHeYqdEh5ZdWpJnMdnCyg@mail.gmail.com>
Subject: Re: [PATCH] drm/rockchip: fix dma_alloc_attrs() error check
To: Mark Yao <mark.yao@rock-chips.com>
Cc: Pawel Osciak <posciak@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Daniel Kurtz <djkurtz@chromium.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 5:27 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> dma_alloc_attrs() returns NULL if it cannot allocate a dma buffer (or
> mapping), not a negative error code.
>
> Rerported-by: Pawel Osciak <posciak@chromium.org>

Oops!  I just noticed that this is spelled wrong.  Should be "Reported-by".

Mark, could you fix up on your tree, or is it too late?

> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> index bc98a22..7ca8799e 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> @@ -34,12 +34,9 @@ static int rockchip_gem_alloc_buf(struct rockchip_gem_object *rk_obj)
>         rk_obj->kvaddr = dma_alloc_attrs(drm->dev, obj->size,
>                                          &rk_obj->dma_addr, GFP_KERNEL,
>                                          &rk_obj->dma_attrs);
> -       if (IS_ERR(rk_obj->kvaddr)) {
> -               int ret = PTR_ERR(rk_obj->kvaddr);
> -
> -               DRM_ERROR("failed to allocate %#x byte dma buffer, %d",
> -                         obj->size, ret);
> -               return ret;
> +       if (!rk_obj->kvaddr) {
> +               DRM_ERROR("failed to allocate %#x byte dma buffer", obj->size);
> +               return -ENOMEM;
>         }
>
>         return 0;
> --
> 2.2.0.rc0.207.ga3a616c
>
