Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3KHScx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:32:53 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54457 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3KHScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:32:47 -0500
Date: Fri, 8 Nov 2013 19:33:15 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx@lists.freedesktop.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915/opregion: fix build error on CONFIG_ACPI=n
Message-ID: <20131108183315.GF14082@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@intel.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx@lists.freedesktop.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org
References: <CA+r1ZhjcFpr5KKVX0pLCOP8cAyZoiYO=UyqYMJtNSV-Kt_p7xQ@mail.gmail.com>
 <1383898231-23234-1-git-send-email-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383898231-23234-1-git-send-email-jani.nikula@intel.com>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 10:10:31AM +0200, Jani Nikula wrote:
> Fix CONFIG_ACPI=n build fail
> 
>   CC      drivers/gpu/drm/i915/intel_opregion.o
> drivers/gpu/drm/i915/intel_opregion.c: In function ‘intel_opregion_setup’:
> drivers/gpu/drm/i915/intel_opregion.c:879:2: error: ‘asle_work’ undeclared (first use in this function)
> drivers/gpu/drm/i915/intel_opregion.c:879:2: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [drivers/gpu/drm/i915/intel_opregion.o] Error 1
> 
> introduced in
> commit 91a60f20712179e56b7a6c3d332a5f6f9a54aa11
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Thu Oct 31 18:55:48 2013 +0200
> 
>     drm/i915: move opregion asle request handling to a work queue
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Reference: http://lkml.kernel.org/r/CA+r1ZhjcFpr5KKVX0pLCOP8cAyZoiYO=UyqYMJtNSV-Kt_p7xQ@mail.gmail.com
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Picked up for -fixes, thanks for the patch.
-Daniel

> ---
>  drivers/gpu/drm/i915/intel_opregion.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> index 91b68dc..1b2f41c 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -876,7 +876,9 @@ int intel_opregion_setup(struct drm_device *dev)
>  		return -ENOTSUPP;
>  	}
>  
> +#ifdef CONFIG_ACPI
>  	INIT_WORK(&opregion->asle_work, asle_work);
> +#endif
>  
>  	base = acpi_os_ioremap(asls, OPREGION_SIZE);
>  	if (!base)
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
