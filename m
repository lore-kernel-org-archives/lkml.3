Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbaCTOVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:21:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:15400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbaCTOVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,695,1389772800"; 
   d="scan'208";a="476416258"
Date: Thu, 20 Mar 2014 14:21:25 +0000
From: Damien Lespiau <damien.lespiau@intel.com>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/4] drm: Added plane alpha and color
 blending property
Message-ID: <20140320142125.GR6912@strange.amr.corp.intel.com>
References: <CAKMK7uE3yWRoirtu133JQUwPjhH+D228LFh-+Kk65vAGAj_xww@mail.gmail.com>
 <1394266879-20522-1-git-send-email-sagar.a.kamble@intel.com>
 <1394266879-20522-2-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394266879-20522-2-git-send-email-sagar.a.kamble@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 01:51:16PM +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> This patch creates a generic blending enum property.
> Drivers may support subset of these values.
> 
> Cc: airlied@linux.ie
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> ---
>  drivers/gpu/drm/drm_crtc.c | 33 +++++++++++++++++++++++++++++++++
>  include/drm/drm_crtc.h     | 25 +++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 4e43fc2..15281a3 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -4147,3 +4147,36 @@ void drm_mode_config_cleanup(struct drm_device *dev)
>  	idr_destroy(&dev->mode_config.crtc_idr);
>  }
>  EXPORT_SYMBOL(drm_mode_config_cleanup);
> +
> +struct drm_property *drm_mode_create_blend_property(struct drm_device *dev,
> +				unsigned int supported_factors)
> +{
> +	static const struct drm_prop_enum_list props[] = {
> +		{ DRM_BLEND_NONE,   			"none" },
> +		{ DRM_BLEND_ZERO,  			"zero" },
> +		{ DRM_BLEND_ONE, 			"one" },
> +		{ DRM_BLEND_SRC_COLOR, 			"src-color" },
> +		{ DRM_BLEND_ONE_MINUS_SRC_COLOR,  	"one-minus-src-color" },
> +		{ DRM_BLEND_DST_COLOR, 			"dst-color" },
> +		{ DRM_BLEND_ONE_MINUS_DST_COLOR,  	"one-minus-dst-color" },
> +		{ DRM_BLEND_SRC_ALPHA, 			"src-alpha" },
> +		{ DRM_BLEND_ONE_MINUS_SRC_ALPHA, 	"one-minus-src-alpha" },
> +		{ DRM_BLEND_DST_ALPHA, 			"dst-alpha" },
> +		{ DRM_BLEND_ONE_MINUS_DST_ALPHA, 	"one-minus-dst-alpha" },
> +		{ DRM_BLEND_CONSTANT_COLOR, 		"constant-color" },
> +		{ DRM_BLEND_ONE_MINUS_CONSTANT_COLOR, 	"one-minus-constant-color" },
> +		{ DRM_BLEND_CONSTANT_ALPHA, 		"constant-alpha" },
> +		{ DRM_BLEND_ONE_MINUS_CONSTANT_ALPHA, 	"one-minus-constant-alpha" },
> +		{ DRM_BLEND_SRC_ALPHA_SATURATE, 	"alpha-saturate" },
> +		{ DRM_BLEND_SRC1_COLOR, 		"src1-color" },
> +		{ DRM_BLEND_ONE_MINUS_SRC1_COLOR, 	"one-minus-src1-color" },
> +		{ DRM_BLEND_SRC1_ALPHA, 		"src1-alpha" },
> +		{ DRM_BLEND_ONE_MINUS_SRC1_ALPHA, 	"one-minus-src1-alpha" },
> +		{ DRM_BLEND_PREMULTIPLIED_ALPHA, 	"pre-multiplied-alpha" }
> +	};

Another few notes:

- You seem to assume that there's a need for DRM_BLEND_NONE, what would it
do? The property should default to DRM_BLEND_SRC_COLOR ie "Take the
color from this plane for the blending".

- There's no need to expose SRC1 variants, this was done in GL to expose a
second color the fragment shader can output, not applicable here.

-- 
Damien
