Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaIXSf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:35:56 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35653 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIXSfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:35:54 -0400
Date: Wed, 24 Sep 2014 20:35:49 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 04/27] drm/i915: use pm_runtime_last_busy_and_autosuspend
 helper
Message-ID: <20140924183549.GS15734@phenom.ffwll.local>
Mail-Followup-To: Vinod Koul <vinod.koul@intel.com>,
	linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-5-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411575342-31048-5-git-send-email-vinod.koul@intel.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:44:54PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Ack to merge through whatever tree is appropriate for this. Or tell me
when I should pick this up for drm-intel.
-Daniel
> ---
>  drivers/gpu/drm/i915/intel_pm.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index 40c1229..1ec9b8d 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -6729,8 +6729,7 @@ void intel_runtime_pm_put(struct drm_i915_private *dev_priv)
>  	if (!HAS_RUNTIME_PM(dev))
>  		return;
>  
> -	pm_runtime_mark_last_busy(device);
> -	pm_runtime_put_autosuspend(device);
> +	pm_runtime_last_busy_and_autosuspend(device);
>  }
>  
>  void intel_init_runtime_pm(struct drm_i915_private *dev_priv)
> -- 
> 1.7.0.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
