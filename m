Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3AXIai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:30:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:50644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab3AXIad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:30:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="275997806"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: "Su\, Xuemin" <xuemin.su@intel.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: xuemin.su@intel.com, yanmin_zhang@linux.intel.com, bo.he@intel.com
Subject: Re: [PATCH V3] drm_crtc: check if fb_create return NULL
In-Reply-To: <1358987804.18561.22.camel@suxuemin.sh.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1358987804.18561.22.camel@suxuemin.sh.intel.com>
User-Agent: Notmuch/0.14+267~g79b3518 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Jan 2013 10:31:48 +0200
Message-ID: <87bocfugln.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013, "Su, Xuemin" <xuemin.su@intel.com> wrote:
> From: xueminsu <xuemin.su@intel.com>
> Date: Tue, 22 Jan 2013 22:39:39 +0800
> Subject: [PATCH] drm_crtc: check if fb_create return NULL
>
> Some buggy driver may still return NULL in fb_create,
> which leads to kernel panic.
>
> Signed-off-by: xueminsu <xuemin.su@intel.com>
> ---
>  drivers/gpu/drm/drm_crtc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index f2d667b..ae613ec 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -2172,6 +2172,8 @@ int drm_mode_addfb(struct drm_device *dev,
>  		ret = PTR_ERR(fb);
>  		goto out;
>  	}
> +	/* some buggy driver may return NULL here, which may cause panic */
> +	BUG_ON(!fb);

I fail to see the benefit of this compared to just letting it oops...

>  	or->fb_id = fb->base.id;

...right here.


BR,
Jani.

>  	list_add(&fb->filp_head, &file_priv->fbs);
> -- 
> 1.7.6
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
