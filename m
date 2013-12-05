Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3LENCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:02:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:50036 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab3LENCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:02:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,832,1378882800"; 
   d="scan'208";a="419867408"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Lv Zheng <zetalog@gmail.com>, linux-acpi@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/3] ACPI/i915: Fix wrong <acpi/acpi.h> inclusion in i915 opregion module.
In-Reply-To: <58025298b10c01a76adeed0f27e12d4b764ad99c.1386116927.git.lv.zheng@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1385094640.git.lv.zheng@intel.com> <cover.1386116927.git.lv.zheng@intel.com> <58025298b10c01a76adeed0f27e12d4b764ad99c.1386116927.git.lv.zheng@intel.com>
User-Agent: Notmuch/0.17~rc2+4~gbbbc7bd (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 05 Dec 2013 15:04:16 +0200
Message-ID: <87haanqwj3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013, Lv Zheng <lv.zheng@intel.com> wrote:
> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
> index 41838ea..d4ae48b 100644
> --- a/drivers/gpu/drm/i915/Makefile
> +++ b/drivers/gpu/drm/i915/Makefile
> @@ -38,7 +38,6 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o \
>  	  intel_ringbuffer.o \
>  	  intel_overlay.o \
>  	  intel_sprite.o \
> -	  intel_opregion.o \
>  	  intel_sideband.o \
>  	  intel_uncore.o \
>  	  dvo_ch7xxx.o \
> @@ -51,7 +50,7 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o \
>  
>  i915-$(CONFIG_COMPAT)   += i915_ioc32.o
>  
> -i915-$(CONFIG_ACPI)	+= intel_acpi.o
> +i915-$(CONFIG_ACPI)	+= intel_acpi.o intel_opregion.o
>  
>  i915-$(CONFIG_DRM_I915_FBDEV) += intel_fbdev.o
>  
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index ccdbecc..7f37b83 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -2336,8 +2336,8 @@ extern void intel_i2c_reset(struct drm_device *dev);
>  
>  /* intel_opregion.c */
>  struct intel_encoder;
> -extern int intel_opregion_setup(struct drm_device *dev);
>  #ifdef CONFIG_ACPI
> +extern int intel_opregion_setup(struct drm_device *dev);
>  extern void intel_opregion_init(struct drm_device *dev);
>  extern void intel_opregion_fini(struct drm_device *dev);
>  extern void intel_opregion_asle_intr(struct drm_device *dev);
> @@ -2346,6 +2346,7 @@ extern int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
>  extern int intel_opregion_notify_adapter(struct drm_device *dev,
>  					 pci_power_t state);
>  #else
> +static inline int intel_opregion_setup(struct drm_device *dev) { return 0; }
>  static inline void intel_opregion_init(struct drm_device *dev) { return; }
>  static inline void intel_opregion_fini(struct drm_device *dev) { return; }
>  static inline void intel_opregion_asle_intr(struct drm_device *dev) { return; }

FWIW, the above i915 specific hunks are

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

Nuking the CONFIG_ACPI conditional build within intel_opregion.c is an
obvious follow-up patch later on.


-- 
Jani Nikula, Intel Open Source Technology Center
