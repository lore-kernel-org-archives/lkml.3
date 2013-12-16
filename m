Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3LPLG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:06:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab3LPLG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:06:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,494,1384329600"; 
   d="scan'208";a="450671290"
Date: Mon, 16 Dec 2013 11:06:55 +0000
From: Damien Lespiau <damien.lespiau@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH -next] drm/i915: fix return value check of
 debugfs_create_file()
Message-ID: <20131216110655.GB26921@strange.amr.corp.intel.com>
References: <CAPgLHd-C925=6rEnQMMkPvHu6+w_BHcJ1-CG8PdK37XM9dzf_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-C925=6rEnQMMkPvHu6+w_BHcJ1-CG8PdK37XM9dzf_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 02:13:25PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function debugfs_create_file() returns NULL
> pointer not ERR_PTR() if debugfs is enabled. The IS_ERR() test in
> the return value check should be replaced with NULL test.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

-- 
Damien

> ---
>  drivers/gpu/drm/i915/i915_debugfs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index 7008aac..856e18b 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -1920,8 +1920,8 @@ static int i915_pipe_crc_create(struct dentry *root, struct drm_minor *minor,
>  	info->dev = dev;
>  	ent = debugfs_create_file(info->name, S_IRUGO, root, info,
>  				  &i915_pipe_crc_fops);
> -	if (IS_ERR(ent))
> -		return PTR_ERR(ent);
> +	if (!ent)
> +		return -ENOMEM;
>  
>  	return drm_add_fake_info_node(minor, ent, info);
>  }
> @@ -2931,8 +2931,8 @@ static int i915_forcewake_create(struct dentry *root, struct drm_minor *minor)
>  				  S_IRUSR,
>  				  root, dev,
>  				  &i915_forcewake_fops);
> -	if (IS_ERR(ent))
> -		return PTR_ERR(ent);
> +	if (!ent)
> +		return -ENOMEM;
>  
>  	return drm_add_fake_info_node(minor, ent, &i915_forcewake_fops);
>  }
> @@ -2949,8 +2949,8 @@ static int i915_debugfs_create(struct dentry *root,
>  				  S_IRUGO | S_IWUSR,
>  				  root, dev,
>  				  fops);
> -	if (IS_ERR(ent))
> -		return PTR_ERR(ent);
> +	if (!ent)
> +		return -ENOMEM;
>  
>  	return drm_add_fake_info_node(minor, ent, fops);
>  }
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
