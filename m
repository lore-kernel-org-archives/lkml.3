Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaIWNDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:03:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:38415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaIWNDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:03:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,580,1406617200"; 
   d="scan'208";a="577531807"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Joe Perches <joe@perches.com>, David Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm: change drm_err return type to void
In-Reply-To: <1411403411.2952.36.camel@joe-AO725>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1411403411.2952.36.camel@joe-AO725>
User-Agent: Notmuch/0.18.1+110~gd9ec63c (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Sep 2014 16:00:44 +0300
Message-ID: <87lhpa5w5f.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Joe Perches <joe@perches.com> wrote:
> The return value is not used by callers of this function
> nor by uses of the DRM_ERROR macro so change the function
> to return void.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


> ---
> This change is associated to a desire to eventually
> change printk to return void.
>
> No x86 change in output size for drm_drv.o
>
>  drivers/gpu/drm/drm_drv.c | 7 ++-----
>  include/drm/drmP.h        | 2 +-
>  2 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index 6a11902..8889f8e 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -56,22 +56,19 @@ static struct idr drm_minors_idr;
>  struct class *drm_class;
>  static struct dentry *drm_debugfs_root;
>  
> -int drm_err(const char *func, const char *format, ...)
> +void drm_err(const char *func, const char *format, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> -	int r;
>  
>  	va_start(args, format);
>  
>  	vaf.fmt = format;
>  	vaf.va = &args;
>  
> -	r = printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
> +	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
>  
>  	va_end(args);
> -
> -	return r;
>  }
>  EXPORT_SYMBOL(drm_err);
>  
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 5c60d38..2163ccb 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -124,7 +124,7 @@ extern __printf(2, 3)
>  void drm_ut_debug_printk(const char *function_name,
>  			 const char *format, ...);
>  extern __printf(2, 3)
> -int drm_err(const char *func, const char *format, ...);
> +void drm_err(const char *func, const char *format, ...);
>  
>  /***********************************************************************/
>  /** \name DRM template customization defaults */
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
