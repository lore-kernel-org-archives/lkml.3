Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaCYTqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:46:45 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40603 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCYTqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:46:43 -0400
Date: Tue, 25 Mar 2014 20:46:38 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] i915: Convert last uses of __FUNCTION__ to __func__
Message-ID: <20140325194638.GL26878@phenom.ffwll.local>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <cover.1395775901.git.joe@perches.com>
 <f73fada74a8320ec33f21ed29e21ee47fb016a42.1395775901.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73fada74a8320ec33f21ed29e21ee47fb016a42.1395775901.git.joe@perches.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 12:35:06PM -0700, Joe Perches wrote:
> Just about all of these have been converted to __func__,
> so convert the last uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Pulled into drm-intel, should land in 3.15.

Thanks, Daniel
> ---
>  drivers/gpu/drm/i915/dvo_ns2501.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/dvo_ns2501.c b/drivers/gpu/drm/i915/dvo_ns2501.c
> index 954acb2..e40cd26 100644
> --- a/drivers/gpu/drm/i915/dvo_ns2501.c
> +++ b/drivers/gpu/drm/i915/dvo_ns2501.c
> @@ -234,7 +234,7 @@ static enum drm_mode_status ns2501_mode_valid(struct intel_dvo_device *dvo,
>  {
>  	DRM_DEBUG_KMS
>  	    ("%s: is mode valid (hdisplay=%d,htotal=%d,vdisplay=%d,vtotal=%d)\n",
> -	     __FUNCTION__, mode->hdisplay, mode->htotal, mode->vdisplay,
> +	     __func__, mode->hdisplay, mode->htotal, mode->vdisplay,
>  	     mode->vtotal);
>  
>  	/*
> @@ -262,7 +262,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
>  
>  	DRM_DEBUG_KMS
>  	    ("%s: set mode (hdisplay=%d,htotal=%d,vdisplay=%d,vtotal=%d).\n",
> -	     __FUNCTION__, mode->hdisplay, mode->htotal, mode->vdisplay,
> +	     __func__, mode->hdisplay, mode->htotal, mode->vdisplay,
>  	     mode->vtotal);
>  
>  	/*
> @@ -277,8 +277,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
>  		if (mode->hdisplay == 800 && mode->vdisplay == 600) {
>  			/* mode 277 */
>  			ns->reg_8_shadow &= ~NS2501_8_BPAS;
> -			DRM_DEBUG_KMS("%s: switching to 800x600\n",
> -				      __FUNCTION__);
> +			DRM_DEBUG_KMS("%s: switching to 800x600\n", __func__);
>  
>  			/*
>  			 * No, I do not know where this data comes from.
> @@ -341,8 +340,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
>  
>  		} else if (mode->hdisplay == 640 && mode->vdisplay == 480) {
>  			/* mode 274 */
> -			DRM_DEBUG_KMS("%s: switching to 640x480\n",
> -				      __FUNCTION__);
> +			DRM_DEBUG_KMS("%s: switching to 640x480\n", __func__);
>  			/*
>  			 * No, I do not know where this data comes from.
>  			 * It is just what the video bios left in the DVO, so
> @@ -406,8 +404,7 @@ static void ns2501_mode_set(struct intel_dvo_device *dvo,
>  
>  		} else if (mode->hdisplay == 1024 && mode->vdisplay == 768) {
>  			/* mode 280 */
> -			DRM_DEBUG_KMS("%s: switching to 1024x768\n",
> -				      __FUNCTION__);
> +			DRM_DEBUG_KMS("%s: switching to 1024x768\n", __func__);
>  			/*
>  			 * This might or might not work, actually. I'm silently
>  			 * assuming here that the native panel resolution is
> @@ -459,7 +456,7 @@ static void ns2501_dpms(struct intel_dvo_device *dvo, bool enable)
>  	unsigned char ch;
>  
>  	DRM_DEBUG_KMS("%s: Trying set the dpms of the DVO to %i\n",
> -		      __FUNCTION__, enable);
> +		      __func__, enable);
>  
>  	ch = ns->reg_8_shadow;
>  
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
