Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHOAXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 20:23:51 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45226 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaHOAXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 20:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <1407978100-15947-1-git-send-email-weiyj_lk@163.com>
References: <1407978100-15947-1-git-send-email-weiyj_lk@163.com>
Date: Thu, 14 Aug 2014 20:23:49 -0400
Message-ID: <CAF6AEGtO0DFX2DZeo2LV2UQJsrwWx48pDa3DCbtPHWmVZPz8iA@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Fix missing unlock on error in msm_fbdev_create()
From: Rob Clark <robdclark@gmail.com>
To: weiyj_lk@163.com
Cc: David Airlie <airlied@linux.ie>, Hai Li <hali@codeaurora.org>,
        Thierry Reding <treding@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 9:01 PM,  <weiyj_lk@163.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing unlock before return from function msm_fbdev_create()
> in the error handling case.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, I've got it queued up..

BR,
-R

> ---
>  drivers/gpu/drm/msm/msm_fbdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
> index 9c5221c..ab5bfd2 100644
> --- a/drivers/gpu/drm/msm/msm_fbdev.c
> +++ b/drivers/gpu/drm/msm/msm_fbdev.c
> @@ -143,7 +143,7 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
>         ret = msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
>         if (ret) {
>                 dev_err(dev->dev, "failed to get buffer obj iova: %d\n", ret);
> -               goto fail;
> +               goto fail_unlock;
>         }
>
>         fbi = framebuffer_alloc(0, dev->dev);
>
