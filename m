Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaELIKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:10:54 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46152 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaELIKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:10:52 -0400
Date: Mon, 12 May 2014 10:10:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/ast: Fix double lock at PM resume
Message-ID: <20140512081047.GC25056@phenom.ffwll.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1399616055-13427-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399616055-13427-1-git-send-email-tiwai@suse.de>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:14:14AM +0200, Takashi Iwai wrote:
> The recent commit [3ea87855: drm/helper: lock all around force mode
> restore] introduced drm_modeset_lock_all() in
> drm_helper_resume_force_mode() itself, while ast driver still takes
> this lock before calling it.  Remove the caller side lock for avoid a
> fatal deadlock.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Oops, failed to do the audit correctly. Thanks for catching this.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/ast/ast_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
> index 5137f15dba19..27e56dda476d 100644
> --- a/drivers/gpu/drm/ast/ast_drv.c
> +++ b/drivers/gpu/drm/ast/ast_drv.c
> @@ -94,9 +94,7 @@ static int ast_drm_thaw(struct drm_device *dev)
>  	ast_post_gpu(dev);
>  
>  	drm_mode_config_reset(dev);
> -	drm_modeset_lock_all(dev);
>  	drm_helper_resume_force_mode(dev);
> -	drm_modeset_unlock_all(dev);
>  
>  	console_lock();
>  	ast_fbdev_set_suspend(dev, 0);
> -- 
> 1.9.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
