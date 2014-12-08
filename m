Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaLHK0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:26:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:25920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbaLHK0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:26:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="495355474"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Daniel Vetter <daniel.vetter@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: drm: i915: intel_dsi_cmd.c:  Remove unused function
In-Reply-To: <1417989055-17859-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1417989055-17859-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 08 Dec 2014 12:26:30 +0200
Message-ID: <87d27uo2sp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Dec 2014, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function dsi_hs_mode_enable() that is not used anywhere.

Please don't.

BR,
Jani.

>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/gpu/drm/i915/intel_dsi_cmd.c |   21 ---------------------
>  drivers/gpu/drm/i915/intel_dsi_cmd.h |    2 --
>  2 files changed, 23 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_dsi_cmd.c b/drivers/gpu/drm/i915/intel_dsi_cmd.c
> index f4767fd..71addcc 100644
> --- a/drivers/gpu/drm/i915/intel_dsi_cmd.c
> +++ b/drivers/gpu/drm/i915/intel_dsi_cmd.c
> @@ -103,27 +103,6 @@ enum dsi_type {
>  	DSI_GENERIC,
>  };
>  
> -/* enable or disable command mode hs transmissions */
> -void dsi_hs_mode_enable(struct intel_dsi *intel_dsi, bool enable)
> -{
> -	struct drm_encoder *encoder = &intel_dsi->base.base;
> -	struct drm_device *dev = encoder->dev;
> -	struct drm_i915_private *dev_priv = dev->dev_private;
> -	struct intel_crtc *intel_crtc = to_intel_crtc(encoder->crtc);
> -	enum pipe pipe = intel_crtc->pipe;
> -	u32 temp;
> -	u32 mask = DBI_FIFO_EMPTY;
> -
> -	if (wait_for((I915_READ(MIPI_GEN_FIFO_STAT(pipe)) & mask) == mask, 50))
> -		DRM_ERROR("Timeout waiting for DBI FIFO empty\n");
> -
> -	temp = I915_READ(MIPI_HS_LP_DBI_ENABLE(pipe));
> -	temp &= DBI_HS_LP_MODE_MASK;
> -	I915_WRITE(MIPI_HS_LP_DBI_ENABLE(pipe), enable ? DBI_HS_MODE : DBI_LP_MODE);
> -
> -	intel_dsi->hs = enable;
> -}
> -
>  static int dsi_vc_send_short(struct intel_dsi *intel_dsi, int channel,
>  			     u8 data_type, u16 data)
>  {
> diff --git a/drivers/gpu/drm/i915/intel_dsi_cmd.h b/drivers/gpu/drm/i915/intel_dsi_cmd.h
> index 46aa1ac..7ad54c0 100644
> --- a/drivers/gpu/drm/i915/intel_dsi_cmd.h
> +++ b/drivers/gpu/drm/i915/intel_dsi_cmd.h
> @@ -36,8 +36,6 @@
>  #define DPI_LP_MODE_EN	false
>  #define DPI_HS_MODE_EN	true
>  
> -void dsi_hs_mode_enable(struct intel_dsi *intel_dsi, bool enable);
> -
>  int dsi_vc_dcs_write(struct intel_dsi *intel_dsi, int channel,
>  		     const u8 *data, int len);
>  
> -- 
> 1.7.10.4
>

-- 
Jani Nikula, Intel Open Source Technology Center
