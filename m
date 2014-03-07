Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaCGIgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:36:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:32988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaCGIgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:36:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,606,1389772800"; 
   d="scan'208";a="494038252"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Xiubo Li <Li.Xiubo@freescale.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Xiubo Li <Li.Xiubo@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/fb-helper: Do the mode_set.connectors ZERO_SIZE_PTR check
In-Reply-To: <1394087661-24504-1-git-send-email-Li.Xiubo@freescale.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1394087661-24504-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Notmuch/0.17+107~g88c86a63b991 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Mar 2014 10:28:57 +0200
Message-ID: <87bnxi2z06.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2014, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> Since we cannot make sure the 'max_conn_count' will always be none
> zero from the users, and then if max_conn_count equals to zero, the
> kcalloc() will return ZERO_SIZE_PTR, which equals to ((void *)16).
>
> So this patch fix this via doing the zero pionter check of it.

Please just add a check for max_conn_count == 0 up front and handle it.

BR,
Jani.


>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/gpu/drm/drm_fb_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 3d13ca6e2..c6680ef 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -536,7 +536,7 @@ int drm_fb_helper_init(struct drm_device *dev,
>  				sizeof(struct drm_connector *),
>  				GFP_KERNEL);
>  
> -		if (!fb_helper->crtc_info[i].mode_set.connectors)
> +		if (ZERO_OR_NULL_PTR(fb_helper->crtc_info[i].mode_set.connectors))
>  			goto out_free;
>  		fb_helper->crtc_info[i].mode_set.num_connectors = 0;
>  	}
> -- 
> 1.8.4
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
