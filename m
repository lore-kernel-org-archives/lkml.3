Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbbATLKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:10:45 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47218 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbbATLKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:10:39 -0500
Date: Tue, 20 Jan 2015 12:10:35 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/36] drm/plane: Make ->atomic_update() mandatory
Message-ID: <20150120111035.GY10113@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:48:21AM +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> There is no use-case where it would be useful for drivers not to
> implement this function and the transitional plane helpers already
> require drivers to provide an implementation.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/drm_atomic_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index d467185f7942..010661f23035 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1108,7 +1108,7 @@ void drm_atomic_helper_commit_planes(struct drm_device *dev,
>  
>  		funcs = plane->helper_private;
>  
> -		if (!funcs || !funcs->atomic_update)
> +		if (!funcs)
>  			continue;
>  
>  		old_plane_state = old_state->plane_states[i];
> -- 
> 2.1.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
