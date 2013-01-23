Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3AWOOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:14:49 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44015 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3AWOOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:14:48 -0500
MIME-Version: 1.0
In-Reply-To: <1358908049.18561.12.camel@suxuemin.sh.intel.com>
References: <1358908049.18561.12.camel@suxuemin.sh.intel.com>
Date: Wed, 23 Jan 2013 09:14:47 -0500
Message-ID: <CADnq5_Oiq3FrVLeA6uovDQnGrmZ3=gPaH173Q9aw9yMhfWM1kA@mail.gmail.com>
Subject: Re: [PATCH] radeon_display: Use pointer return error codes
From: Alex Deucher <alexdeucher@gmail.com>
To: "Su, Xuemin" <xuemin.su@intel.com>
Cc: airlied@linux.ie, airlied@redhat.com, alexander.deucher@amd.com,
        s.hauer@pengutronix.de, ihadzic@research.bell-labs.com,
        laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        bo.he@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 9:27 PM, Su, Xuemin <xuemin.su@intel.com> wrote:
> From: xueminsu <xuemin.su@intel.com>
> Date: Tue, 22 Jan 2013 22:16:53 +0800
> Subject: [PATCH] radeon_display: Use pointer return error codes
>
> drm_mode_addfb() expects fb_create return error code
> instead of NULL.
>
> Signed-off-by: xueminsu <xuemin.su@intel.com>

Thanks.  Added to my fixes queue.

Alex


> ---
>  drivers/gpu/drm/radeon/radeon_display.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
> index 1da2386..ff3def7 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -1122,7 +1122,7 @@ radeon_user_framebuffer_create(struct drm_device *dev,
>         if (ret) {
>                 kfree(radeon_fb);
>                 drm_gem_object_unreference_unlocked(obj);
> -               return NULL;
> +               return ERR_PTR(ret);
>         }
>
>         return &radeon_fb->base;
> --
> 1.7.6
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
