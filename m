Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3LPKEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:04:12 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57086 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPKEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:04:10 -0500
Date: Mon, 16 Dec 2013 11:05:02 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] drm/i915: fix return value check of
 debugfs_create_file()
Message-ID: <20131216100502.GR9804@phenom.ffwll.local>
Mail-Followup-To: Wei Yongjun <weiyj.lk@gmail.com>, airlied@linux.ie,
	yongjun_wei@trendmicro.com.cn, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <CAPgLHd-C925=6rEnQMMkPvHu6+w_BHcJ1-CG8PdK37XM9dzf_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-C925=6rEnQMMkPvHu6+w_BHcJ1-CG8PdK37XM9dzf_A@mail.gmail.com>
X-Operating-System: Linux phenom 3.12.0+
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

Nice catch! Queued for -next, thanks for the patch.
-Daniel

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

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
