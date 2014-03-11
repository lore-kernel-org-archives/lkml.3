Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaCKUjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:39:40 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54525 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbaCKUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:39:38 -0400
Date: Tue, 11 Mar 2014 21:39:34 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/fb-helper: Do the 'max_conn_count' zero check
Message-ID: <20140311203934.GJ30571@phenom.ffwll.local>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1394415238-20085-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394415238-20085-1-git-send-email-Li.Xiubo@freescale.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 09:33:58AM +0800, Xiubo Li wrote:
> Since we cannot make sure the 'max_conn_count' will always be none
> zero from the users, and then if max_conn_count equals to zero, the
> kcalloc() will return ZERO_SIZE_PTR, which equals to ((void *)16).
> 
> So this patch fix this with just doing the 'max_conn_count' zero check
> in the front of drm_fb_helper_init().
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> CC: Jani Nikula <jani.nikula@linux.intel.com>

Makes sense.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/drm_fb_helper.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 3d13ca6e2..a0d286c 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -514,6 +514,9 @@ int drm_fb_helper_init(struct drm_device *dev,
>  	struct drm_crtc *crtc;
>  	int i;
>  
> +	if (!max_conn_count)
> +		return -EINVAL;
> +
>  	fb_helper->dev = dev;
>  
>  	INIT_LIST_HEAD(&fb_helper->kernel_fb_list);
> -- 
> 1.8.4
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
