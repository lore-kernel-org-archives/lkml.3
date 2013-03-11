Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3CKXQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:16:12 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:64018 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3CKXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:16:09 -0400
Date: Tue, 12 Mar 2013 00:16:01 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] drm/i915: clarify reasoning for the access_ok call
Message-ID: <20130311231601.GD3872@bremse>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org
References: <20130311213735.GA22493@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311213735.GA22493@www.outflux.net>
X-Operating-System: Linux bremse 3.8.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:37:35PM -0700, Kees Cook wrote:
> This clarifies the comment above the access_ok check so a missing
> VERIFY_READ doesn't alarm anyone.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
> v2:
>  - rewrote comment, thanks to Chris Wilson

Queued for -next, thanks for the patch. Fyi I prefer the patch changelog
in the actual commit message so that it gets recorded in git. Usually it's
not that interesting, but sometimes knowning the history of a patch is
really important. I've fixed this while applying.
-Daniel
> ---
>  drivers/gpu/drm/i915/i915_gem_execbuffer.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> index bf7ceca..89c4039 100644
> --- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> @@ -751,7 +751,11 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
>  
>  		length = exec[i].relocation_count *
>  			sizeof(struct drm_i915_gem_relocation_entry);
> -		/* we may also need to update the presumed offsets */
> +		/*
> +		 * We must check that the entire relocation array is safe
> +		 * to read, but since we may need to update the presumed
> +		 * offsets during execution, check for full write access.
> +		 */
>  		if (!access_ok(VERIFY_WRITE, ptr, length))
>  			return -EFAULT;
>  
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
