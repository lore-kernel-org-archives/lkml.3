Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaLAQOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:14:39 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33821 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaLAQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:14:35 -0500
MIME-Version: 1.0
In-Reply-To: <54748541.4000600@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<54748541.4000600@users.sourceforge.net>
Date: Mon, 1 Dec 2014 11:14:35 -0500
Message-ID: <CAF6AEGt+tgWjYydTUv+5L2d1r8EMKWhOv=j=T8eoHEOkm8Cciw@mail.gmail.com>
Subject: Re: [PATCH 1/1] GPU-DRM-MSM: Deletion of unnecessary checks before
 two function calls
From: Rob Clark <robdclark@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw, I have these two queued up on msm-next, thanks

BR,
-R

On Tue, Nov 25, 2014 at 8:33 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 25 Nov 2014 14:30:28 +0100
>
> The functions framebuffer_release() and vunmap() perform also input
> parameter validation. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/gpu/drm/msm/msm_fbdev.c | 3 +--
>  drivers/gpu/drm/msm/msm_gem.c   | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
> index ab5bfd2..fd5a6f3 100644
> --- a/drivers/gpu/drm/msm/msm_fbdev.c
> +++ b/drivers/gpu/drm/msm/msm_fbdev.c
> @@ -193,8 +193,7 @@ fail_unlock:
>  fail:
>
>         if (ret) {
> -               if (fbi)
> -                       framebuffer_release(fbi);
> +               framebuffer_release(fbi);
>                 if (fb) {
>                         drm_framebuffer_unregister_private(fb);
>                         drm_framebuffer_remove(fb);
> diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
> index 4b1b82a..157cf21 100644
> --- a/drivers/gpu/drm/msm/msm_gem.c
> +++ b/drivers/gpu/drm/msm/msm_gem.c
> @@ -543,8 +543,7 @@ void msm_gem_free_object(struct drm_gem_object *obj)
>                         drm_free_large(msm_obj->pages);
>
>         } else {
> -               if (msm_obj->vaddr)
> -                       vunmap(msm_obj->vaddr);
> +               vunmap(msm_obj->vaddr);
>                 put_pages(obj);
>         }
>
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
