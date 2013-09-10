Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3IJIZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:25:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:21646 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab3IJIY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:24:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,876,1371106800"; 
   d="scan'208";a="401071447"
Date: Tue, 10 Sep 2013 11:24:52 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/sdvo: Fully translate sync flags in
 the dtd->mode conversion
Message-ID: <20130910082452.GI11428@intel.com>
References: <522A5008.6060005@t-online.de>
 <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:02:48AM +0200, Daniel Vetter wrote:
> Instead of just a flag bit for each of the positive/negative sync
> modes drm actually uses a separate flag for each ... This upsets the
> modeset checker since the adjusted mode filled out at modeset time
> doesn't match the one reconstructed at check time (since the
> ->get_config callback already gets this right).
> 
> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> Cc: Knut Petersen <Knut_Petersen@t-online.de>
> References: http://www.gossamer-threads.com/lists/linux/kernel/1778688?do=post_view_threaded
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/intel_sdvo.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
> index 85037b9..5033c74 100644
> --- a/drivers/gpu/drm/i915/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/intel_sdvo.c
> @@ -866,8 +866,12 @@ static void intel_sdvo_get_mode_from_dtd(struct drm_display_mode * mode,
>  		mode->flags |= DRM_MODE_FLAG_INTERLACE;
>  	if (dtd->part2.dtd_flags & DTD_FLAG_HSYNC_POSITIVE)
>  		mode->flags |= DRM_MODE_FLAG_PHSYNC;
> +	else
> +		mode->flags |= DRM_MODE_FLAG_NHSYNC;
>  	if (dtd->part2.dtd_flags & DTD_FLAG_VSYNC_POSITIVE)
>  		mode->flags |= DRM_MODE_FLAG_PVSYNC;
> +	else
> +		mode->flags |= DRM_MODE_FLAG_NVSYNC;
>  }
>  
>  static bool intel_sdvo_check_supp_encode(struct intel_sdvo *intel_sdvo)
> -- 
> 1.8.4.rc3
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel OTC
