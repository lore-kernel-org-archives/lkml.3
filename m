Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3AaOLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:11:16 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:42093 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3AaOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <1359611943.12399.2.camel@suxuemin.sh.intel.com>
References: <1359611943.12399.2.camel@suxuemin.sh.intel.com>
Date: Thu, 31 Jan 2013 09:11:13 -0500
Message-ID: <CADnq5_N4oLf+BmjxGvuZhz33CcHBHxeAsbzLYNJBx5CU3AT5og@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Calling object_unrefer() when creating fb failure
From: Alex Deucher <alexdeucher@gmail.com>
To: "Su, Xuemin" <xuemin.su@intel.com>
Cc: airlied@linux.ie, airlied@redhat.com, alexander.deucher@amd.com,
        s.hauer@pengutronix.de, ihadzic@research.bell-labs.com,
        laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        yanmin_zhang@linux.intel.com, bo.he@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:59 AM, Su, Xuemin <xuemin.su@intel.com> wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Date: Thu, 31 Jan 2013 22:13:00 +0800
> Subject: [PATCH] drm/radeon: Calling object_unrefer() when creating fb
>  failure
>
> When kzalloc() failed in radeon_user_framebuffer_create(), need to
> call object_unreference() to match the object_reference().
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: xueminsu <xuemin.su@intel.com>

Thanks.  I've picked this up.

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_display.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
> index ff3def7..05c96fa 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -1115,8 +1115,10 @@ radeon_user_framebuffer_create(struct drm_device *dev,
>         }
>
>         radeon_fb = kzalloc(sizeof(*radeon_fb), GFP_KERNEL);
> -       if (radeon_fb == NULL)
> +       if (radeon_fb == NULL) {
> +               drm_gem_object_unreference_unlocked(obj);
>                 return ERR_PTR(-ENOMEM);
> +       }
>
>         ret = radeon_framebuffer_init(dev, radeon_fb, mode_cmd, obj);
>         if (ret) {
> --
> 1.7.6
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
