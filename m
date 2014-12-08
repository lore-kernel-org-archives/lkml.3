Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaLHKYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:24:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:17850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaLHKYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:24:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="426421404"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Daniel Vetter <daniel.vetter@intel.com>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/20] drm/i915: fix misspelling of current function in string
In-Reply-To: <1417980062-25151-8-git-send-email-Julia.Lawall@lip6.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-8-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 08 Dec 2014 12:24:27 +0200
Message-ID: <87fvcqo2w4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Dec 2014, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> Replace a misspelled function name by %s and then __func__.
>
> This was done using Coccinelle, including the use of Levenshtein distance,
> as proposed by Rasmus Villemoes.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> The semantic patch is difficult to summarize, but is available in the cover
> letter of this patch series.
>
> The message is sort of ambiguous, but I assume that it is intended to refer
> to the function in which the problem is detected.

Hmm, DRM_DEBUG prints __func__ too.

Jani.

>
>  drivers/gpu/drm/i915/i915_gem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index d2ba315..fa21d1c 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -4335,7 +4335,7 @@ i915_gem_unpin_ioctl(struct drm_device *dev, void *data,
>  	}
>  
>  	if (obj->pin_filp != file) {
> -		DRM_DEBUG("Not pinned by caller in i915_gem_pin_ioctl(): %d\n",
> +		DRM_DEBUG("Not pinned by caller in %s(): %d\n", __func__,
>  			  args->handle);
>  		ret = -EINVAL;
>  		goto out;
>

-- 
Jani Nikula, Intel Open Source Technology Center
