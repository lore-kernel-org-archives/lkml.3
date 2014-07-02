Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaGBLNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:13:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:11626 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaGBLNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,587,1400050800"; 
   d="scan'208";a="564102591"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
In-Reply-To: <1404239981-14638-1-git-send-email-fabf@skynet.be>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1404239981-14638-1-git-send-email-fabf@skynet.be>
User-Agent: Notmuch/0.18+25~gfdc3e52 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 02 Jul 2014 14:12:58 +0300
Message-ID: <871tu4f1z9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2014, Fabian Frederick <fabf@skynet.be> wrote:
> use mm.h definition
>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Pushed to drm-intel-next-queued, thanks for the patch.

BR,
Jani.


> ---
>  drivers/gpu/drm/i915/intel_display.c | 10 +++++-----
>  drivers/gpu/drm/i915/intel_fbdev.c   |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 5f285fb..f07cb83 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -6116,8 +6116,8 @@ static void i9xx_get_plane_config(struct intel_crtc *crtc,
>  	aligned_height = intel_align_height(dev, crtc->base.primary->fb->height,
>  					    plane_config->tiled);
>  
> -	plane_config->size = ALIGN(crtc->base.primary->fb->pitches[0] *
> -				   aligned_height, PAGE_SIZE);
> +	plane_config->size = PAGE_ALIGN(crtc->base.primary->fb->pitches[0] *
> +					aligned_height);
>  
>  	DRM_DEBUG_KMS("pipe/plane %d/%d with fb: size=%dx%d@%d, offset=%x, pitch %d, size 0x%x\n",
>  		      pipe, plane, crtc->base.primary->fb->width,
> @@ -7136,8 +7136,8 @@ static void ironlake_get_plane_config(struct intel_crtc *crtc,
>  	aligned_height = intel_align_height(dev, crtc->base.primary->fb->height,
>  					    plane_config->tiled);
>  
> -	plane_config->size = ALIGN(crtc->base.primary->fb->pitches[0] *
> -				   aligned_height, PAGE_SIZE);
> +	plane_config->size = PAGE_ALIGN(crtc->base.primary->fb->pitches[0] *
> +					aligned_height);
>  
>  	DRM_DEBUG_KMS("pipe/plane %d/%d with fb: size=%dx%d@%d, offset=%x, pitch %d, size 0x%x\n",
>  		      pipe, plane, crtc->base.primary->fb->width,
> @@ -8233,7 +8233,7 @@ static u32
>  intel_framebuffer_size_for_mode(struct drm_display_mode *mode, int bpp)
>  {
>  	u32 pitch = intel_framebuffer_pitch_for_width(mode->hdisplay, bpp);
> -	return ALIGN(pitch * mode->vdisplay, PAGE_SIZE);
> +	return PAGE_ALIGN(pitch * mode->vdisplay);
>  }
>  
>  static struct drm_framebuffer *
> diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
> index 088fe93..182fbc2 100644
> --- a/drivers/gpu/drm/i915/intel_fbdev.c
> +++ b/drivers/gpu/drm/i915/intel_fbdev.c
> @@ -81,7 +81,7 @@ static int intelfb_alloc(struct drm_fb_helper *helper,
>  							  sizes->surface_depth);
>  
>  	size = mode_cmd.pitches[0] * mode_cmd.height;
> -	size = ALIGN(size, PAGE_SIZE);
> +	size = PAGE_ALIGN(size);
>  	obj = i915_gem_object_create_stolen(dev, size);
>  	if (obj == NULL)
>  		obj = i915_gem_alloc_object(dev, size);
> -- 
> 1.9.1
>

-- 
Jani Nikula, Intel Open Source Technology Center
