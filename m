Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab3CMUST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:18:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61662 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab3CMUSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:18:14 -0400
Date: Wed, 13 Mar 2013 21:18:09 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: use do_div() as needed in debugfs code
Message-ID: <20130313201809.GB1896@bremse>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org
References: <20130312054631.GA21167@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312054631.GA21167@www.outflux.net>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:46:31PM -0700, Kees Cook wrote:
> This replaces the open-coded divisions in the debugfs code by calls
> to do_div().
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>

Squashed into the debugfs patch which introduced this regression, thanks
for the quick fixup.
-Daniel

> ---
>  drivers/gpu/drm/i915/i915_debugfs.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
> index d86c304..6f3cbf8 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -1814,9 +1814,9 @@ i915_max_freq_set(void *data, u64 val)
>  	/*
>  	 * Turbo will still be enabled, but won't go above the set value.
>  	 */
> -	dev_priv->rps.max_delay = val / GT_FREQUENCY_MULTIPLIER;
> -
> -	gen6_set_rps(dev, val / GT_FREQUENCY_MULTIPLIER);
> +	do_div(val, GT_FREQUENCY_MULTIPLIER);
> +	dev_priv->rps.max_delay = val;
> +	gen6_set_rps(dev, val);
>  	mutex_unlock(&dev_priv->rps.hw_lock);
>  
>  	return 0;
> @@ -1865,9 +1865,9 @@ i915_min_freq_set(void *data, u64 val)
>  	/*
>  	 * Turbo will still be enabled, but won't go below the set value.
>  	 */
> -	dev_priv->rps.min_delay = val / GT_FREQUENCY_MULTIPLIER;
> -
> -	gen6_set_rps(dev, val / GT_FREQUENCY_MULTIPLIER);
> +	do_div(val, GT_FREQUENCY_MULTIPLIER);
> +	dev_priv->rps.min_delay = val;
> +	gen6_set_rps(dev, val);
>  	mutex_unlock(&dev_priv->rps.hw_lock);
>  
>  	return 0;
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
