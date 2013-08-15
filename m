Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3HOKzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:55:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:5499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3HOKzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:55:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,885,1367996400"; 
   d="scan'208";a="387526820"
Date: Thu, 15 Aug 2013 11:55:33 +0100
From: Damien Lespiau <damien.lespiau@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [PATCH] i915: Add a Kconfig option to turn on
 i915.preliminary_hw_support by default
Message-ID: <20130815105533.GA4490@strange.amr.corp.intel.com>
References: <20130813232130.GA20895@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813232130.GA20895@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:23:17PM -0700, Josh Triplett wrote:
> When building kernels for a preliminary hardware target, having to add a
> kernel command-line option can prove inconvenient.  Add a Kconfig option
> that changes the default of this option to 1.

FWIW, I like it (and had something similar in mind for this on other
little parameters/debug features). 

Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

It doesn't apply cleanly to drm-intel/drm-intel-nightly which is the
preferred branch to base patches on. Daniel might fix this himself as
this is rather trivial to solve.

-- 
Damien

> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> I dropped the indication of the default in the module parameter
> documentation, but I could also change it to show the default for the
> current kernel via ifdef.
> 
>  drivers/gpu/drm/Kconfig         | 9 +++++++++
>  drivers/gpu/drm/i915/i915_drv.c | 4 ++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index a7c54c8..35d57ed 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -168,6 +168,15 @@ config DRM_I915_KMS
>  	  the driver to bind to PCI devices, which precludes loading things
>  	  like intelfb.
>  
> +config DRM_I915_PRELIMINARY_HW_SUPPORT
> +	bool "Enable preliminary support for prerelease Intel hardware by default"
> +	depends on DRM_I915
> +	help
> +	  Choose this option if you have prerelease Intel hardware and want the
> +	  i915 driver to support it by default.  You can enable such support at
> +	  runtime with the module option i915.preliminary_hw_support=1; this
> +	  option changes the default for that module option.
> +
>  config DRM_MGA
>  	tristate "Matrox g200/g400"
>  	depends on DRM && PCI
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index 45b3c03..594e06c 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -118,10 +118,10 @@ module_param_named(i915_enable_ppgtt, i915_enable_ppgtt, int, 0600);
>  MODULE_PARM_DESC(i915_enable_ppgtt,
>  		"Enable PPGTT (default: true)");
>  
> -unsigned int i915_preliminary_hw_support __read_mostly = 0;
> +unsigned int i915_preliminary_hw_support __read_mostly = IS_ENABLED(CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT);
>  module_param_named(preliminary_hw_support, i915_preliminary_hw_support, int, 0600);
>  MODULE_PARM_DESC(preliminary_hw_support,
> -		"Enable preliminary hardware support. (default: false)");
> +		"Enable preliminary hardware support.");
>  
>  int i915_disable_power_well __read_mostly = 1;
>  module_param_named(disable_power_well, i915_disable_power_well, int, 0600);
> -- 
> 1.8.4.rc2
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
